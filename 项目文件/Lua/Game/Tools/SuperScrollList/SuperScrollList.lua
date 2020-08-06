require("Lua.Game.Tools.class")
require("Lua.Game.Tools.SuperScrollList.InternalGrid")
require("Lua.Game.Tools.SuperScrollList.Line")

SuperScrollList = class()
function SuperScrollList:ctor( ... )
    local arg = {...}
    self.ScrollView =  arg[1].transform:GetComponent('UIScrollView')
    self.panel = self.ScrollView.transform:GetComponent('UIPanel')
    self._transform = arg[2]
    self._grid = InternalGrid.New()
    
    self._items = {}
    self._dataSize = 0
    self._scrollLinesIndexStart = -1
    self._scrollLineSize = 0
    self._forceRefresh = false;
    self._firstLine = nil;
    self._scrollLines = {}
    self._lastLine = nil
    self._prefab = nil

    self.onItemRefresh = nil
    self.onItemInstance = nil

    self.panel.onClipMove = function (panel)
        self:UpdateLines()
    end
end

function SuperScrollList:transform()
    return self._transform
end

function SuperScrollList:LineCapacity()
    return self._grid:GetMaxPerLine()
end

function SuperScrollList:Clear()
    --self.ScrollView = nil

    for i=1,#self._items do
        self._items[i].gameObject:SetActive(false)
        UnityEngine.Object.Destroy(self._items[i].gameObject)
    end

    self._items = {}

    self._dataSize = 0
    self._scrollLinesIndexStart = -1

    self._firstLine = nil
    self._lastLine = nil
    self._scrollLines = {}
end

function SuperScrollList:SetCellSize(cellWidth, cellHeight)
    self._grid:SetCellSize(cellWidth,cellHeight)
end

function SuperScrollList:SpawnNewList(prefab, dataSize)
    self:Clear()
    self:InitItems(prefab)

    self:Resize(dataSize)
end

function SuperScrollList:SetRefreshCallback(refreshCallback)
    self.onItemRefresh = refreshCallback
end

function SuperScrollList:SetItemInstanceCallback(itemInstanceCallback)
    self.onItemInstance = itemInstanceCallback
end

function SuperScrollList:InitItems(prefab)
    self._prefab = prefab;
    local itemLineSize = self:CalculateRequireLineNum();
    local itemSize = itemLineSize * self:LineCapacity();

    local format = 'D' .. string.len(''..itemSize)
    for i = 0, itemSize - 1 do
        local go = NGUITools.AddChild(self._transform.gameObject, self._prefab);
        go:SetActive(true)
        go.name = tostring(i, format)

        if go:GetComponent('Collider') ~= nil then
            UIEventListener.Get(go).onClick = OnClick_Item;
        end

        if self.onItemInstance ~= nil then
            self.onItemInstance(go)
        end
    end

    self._grid:Reposition(self)
    self._items = self._grid:GetChildList(self)

    if itemLineSize > 0 then
       self._firstLine = Line.New()
       self._firstLine:SetIndex(0)
       for i=1, self:LineCapacity() do
            self._firstLine:AddMember(self._items[i])
       end
    end
    if itemLineSize > 1 then
        self._lastLine = Line.New()
        self._lastLine:SetIndex(-1)
        for i= itemLineSize * self:LineCapacity(), #self._items do
            self._lastLine:AddMember(self._items[i])
        end
    end
    if itemLineSize > 2 then
        self._scrollLines = {}
        for i=2,itemLineSize - 1 do
            local line = Line.New()
            line:SetIndex(-1)
            local dataIndexStart = self:LineCapacity() * i
            for j=0, self:LineCapacity() - 1 do
                line:AddMember(self._items[j + dataIndexStart])
            end

            table.insert(self._scrollLines, line)
        end
    end
end

function SuperScrollList:CalculateRequireLineNum()
    local viewLength = self.panel:GetViewSize().y;
	local itemDistance = Mathf.Abs(self._grid:CellHeight());
	local needScrollLines = Mathf.Floor(viewLength / itemDistance) + 3;
	return needScrollLines + 2;
end

function SuperScrollList:DataLineSize()
    return self._dataSize <= 0 and 0 or (self._dataSize + self:LineCapacity() - 1) / self:LineCapacity()
end

function SuperScrollList:Resize(dataSize)
    self._dataSize = dataSize
    local dataLineSize = self:DataLineSize()

    self._firstLine:SetIndex(dataLineSize > 0 and 0 or -1)
    self._firstLine:SetActiveCount(Mathf.Min(self._dataSize, self:LineCapacity()))
    for i=1, self._firstLine:MemberCount() do
        self._firstLine:GetMember(i).gameObject:SetActive(i <= self._firstLine:GetActiveCount())
    end

    if dataLineSize > 1 then
        self._lastLine:SetIndex(dataLineSize - 1)
        self._lastLine:SetActiveCount(self._dataSize - self._lastLine:GetIndex() * self:LineCapacity())
        for i=1, self._lastLine:MemberCount() do
            self._lastLine:GetMember(i).gameObject:SetActive(i <= self._lastLine:GetActiveCount())
        end
        self:SetLinePosition(self._lastLine)
    else
        self._lastLine:SetIndex(-1)
        self._lastLine:SetActiveCount(0)
        for i=1,self._lastLine:MemberCount()do
            self._lastLine:GetMember(i).gameObject:SetActive(false);
        end
    end

    local scrollDataLineSize = Mathf.Max(dataLineSize - 2, 0);
    self._scrollLineSize = Mathf.Min(scrollDataLineSize, #self._scrollLines);
    for i=1, #self._scrollLines do
        local line = self._scrollLines[i];
        line:SetIndex(-1)
        if i <= self._scrollLineSize then
            line:SetActiveCount(self:LineCapacity())
            for j = 1, line:MemberCount() do
                line:GetMember(j).gameObject:SetActive(true);
            end
        else
            line:SetActiveCount(0)
            for j = 1, line:MemberCount() do
                line:GetMember(j).gameObject:SetActive(false);
            end
        end
    end

    if self.onItemRefresh ~= nil then
        if self._firstLine:GetIndex() >= 0 then
            for i = 1, self._firstLine:GetActiveCount() do
                self.onItemRefresh(self._firstLine:GetMember(i).gameObject, i - 1)
            end
        end
        if self._lastLine:GetIndex() >= 0 then
            local dataIndex = self._lastLine:GetIndex() * self:LineCapacity()
            for i=1, self._lastLine:GetActiveCount() do
                self.onItemRefresh(self._lastLine:GetMember(i).gameObject, dataIndex)
            end
        end
    end

    self._forceRefresh = true
    self:UpdateLines()

    self.ScrollView:InvalidateBounds()
    self.ScrollView:RestrictWithinBounds(false, self.ScrollView.canMoveHorizontally, self.ScrollView.canMoveVertically)
end

function SuperScrollList:UpdateLines()
    if self._scrollLineSize == 0 then
        return 
    end

    local corners = self.panel.worldCorners
    for i = 0, 3 do
        local v = corners[i]
        v = self._transform:InverseTransformPoint(v)
        corners[i] = v
    end

    local firstLineOffset = 0
    local linesIncremental = self._lastLine:GetMember(1).localPosition.y > self._firstLine:GetMember(1).localPosition.y
    firstLineOffset = self._firstLine:GetMember(1).localPosition.y - (linesIncremental and corners[0].y or corners[2].y)

    local linesDistance = self:CalculateLinesDistance()
    local firstLineOffsetRate = firstLineOffset / -linesDistance;
    local scrollLinesIndexStart = Mathf.Clamp(Mathf.Floor(firstLineOffsetRate), 1, self._lastLine:GetIndex() - self._scrollLineSize);
    if scrollLinesIndexStart ~= self._scrollLinesIndexStart or self._forceRefresh then
        self._scrollLinesIndexStart = scrollLinesIndexStart
        local listIndexStart = self:LineIndex2ScrollListIndex(scrollLinesIndexStart)
        for i=1,self._scrollLineSize do
            local listIndex = i + listIndexStart
            listIndex = listIndex <= self._scrollLineSize and listIndex or listIndex - self._scrollLineSize
            local line = self._scrollLines[listIndex]
            local scrollLineIndex = scrollLinesIndexStart + (i - 1)
            if line:GetIndex() ~= scrollLineIndex or self._forceRefresh then
                line:SetIndex(scrollLineIndex)
                self:SetLinePosition(line)
                if self.onItemRefresh ~= nil then
                    local dataIndexStart = line.index * self:LineCapacity()
                    for j=1, self:LineCapacity() do
                        self.onItemRefresh(line:GetMember(j), dataIndexStart)
                    end
                end
            end
        end
    end

    self._forceRefresh = false
end

function SuperScrollList:SetLinePosition(line)
    local distanceToFirstLine = self:CalculateLinesDistanceVector() * line:GetIndex()
    for i=1, line:MemberCount() do
        line:GetMember(i).localPosition = self._firstLine:GetMember(i).localPosition + distanceToFirstLine
    end
end

function SuperScrollList:CalculateLinesDistanceVector()
    return Vector3(0, self._grid:CellHeight(), 0)
end

function SuperScrollList:CalculateLinesDistance()
    return self._grid:CellHeight()
end

function SuperScrollList:LineIndex2ScrollListIndex(lineIndex)
    return (lineIndex - 1) % #self._scrollLines
end

function SuperScrollList:OnClick_Item(go)
    
end
