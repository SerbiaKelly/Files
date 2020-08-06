require("Lua.Game.Tools.class")

InternalGrid = class()
function InternalGrid:ctor( ... )
    self.cellWidth = 200
    self.cellHeight = 200 
    self.maxPerLine = 1
end

function InternalGrid:CellWidth()
    return self.cellWidth
end

function InternalGrid:CellHeight()
    return self.cellHeight
end

function InternalGrid:SetCellSize(cellWidth, cellHeight)
    self.cellWidth = cellWidth
    self.cellHeight = cellHeight
end

function InternalGrid:SetMaxPerLine(line)
    if line == nil or line < 1 then
        self.maxPerLine = 1
    else
        self.maxPerLine = line
    end
end

function InternalGrid:GetMaxPerLine()
    return self.maxPerLine
end

function InternalGrid:Reposition(superScrollList)
    --NGUITools.SetDirty(superScrollList)
    local list = self:GetChildList(superScrollList)
    self:ResetPosition(superScrollList:transform(), list)
end

function InternalGrid:GetChildList(superScrollList)
    local list = {}
    local transform = superScrollList:transform()

    for i=0, transform.childCount - 1 do
        table.insert(list, transform:GetChild(i))
    end

    return list
end

function InternalGrid:ResetPosition(transform, list)
    local x = 0
    local y = 0
    local maxX = 0
    local maxY = 0

    local maxIndex = transform.childCount
    for i=1,maxIndex do
        local t = list[i]

        local pos = t.localPosition
        local depth = pos.z

        pos = Vector3(self.cellWidth * x, self.cellHeight * y, depth)

        t.localPosition = pos

        maxX = Mathf.Max(maxX, x)
        maxY = Mathf.Max(maxY, y)

        x = x + 1
        if x >= self.maxPerLine and  self.maxPerLine > 0  then
            x = 0;
            y = y + 1
        end
    end
end