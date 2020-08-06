require("class")
require("HandCard")
require("BBTZ_Tools")

CardGrid = class()

function CardGrid:ctor(card, grid, refrshCallback, selectCardCallback, releaseSelectCallback, verifySelectedCallback)
    self.grid = grid
    self.card = card
    self.dictionary = {}
    self.selectCards = {}
    self.refrshCallback = refrshCallback
    self.selectCardCallback = selectCardCallback
    self.releaseSelectCallback = releaseSelectCallback
    self.verifySelectedCallback = verifySelectedCallback

    if not self.grid:GetComponent("BoxCollider") then
        return
    end
    local trigger = UIEventTrigger.Get(self.grid)
    EventDelegate.AddForLua(
        trigger.onPress,
        function()
            self:ClickStart()
        end
    )
    EventDelegate.AddForLua(
        trigger.onRelease,
        function()
            self:ClickEnd()
        end
    )
end

function CardGrid:CreateHandCard(count, depth)
    for i = 0, count - 1 do
        local card = NGUITools.AddChild(self.grid.gameObject, self.card.gameObject)
        card.gameObject.name = i
        card.gameObject:SetActive(false)
        card.transform.localPosition = Vector3.zero
    end
    --GridResetPosition(self.grid)
end

function CardGrid:InitCont(count, depth)
    self:Clean()
    self._cardCount = count
    self:CreateHandCard(count, depth == nil and 3 or depth)
    return self
end

function CardGrid:GetCards()
    local tmep = {}
    for i = 1, #self.dictionary do
        table.insert(tmep, self.dictionary[i].card)
    end
    return tmep
end

function CardGrid:Clean()
    self.dictionary = {}
    for i = 0, self.grid.transform.childCount - 1 do
        UnityEngine.Object.Destroy(self.grid.transform:GetChild(i).gameObject)
    end
end

local function GetActiveChilds(transform)
    local hideChilds,
        activeChilds = {}, {}
    for i = 0, transform.childCount - 1 do
        local child = transform:GetChild(i)
        if child.gameObject.activeInHierarchy then
            table.insert(activeChilds, child)
        else
            table.insert(hideChilds, child)
        end
    end
    return activeChilds, hideChilds
end

function CardGrid:Refresh()
    self:RefreshCards(self:GetCards())
end

function CardGrid:RefreshCards(cards)
    if #cards == 0 then
        for i = 1, self.grid.transform.childCount do
            self.grid.transform:GetChild(i - 1).gameObject:SetActive(false)
        end
        return
    end

    local activeChilds,hideChilds = GetActiveChilds(self.grid.transform)
    for i = #activeChilds, #cards, -1 do
        activeChilds[i].gameObject:SetActive(false)
    end
    for i = 1, #cards - #activeChilds do
        table.insert(activeChilds, hideChilds[i])
    end

    self.dictionary = {}
    for i = 1, #cards do
        local obj = activeChilds[i]
        if obj then
            obj.gameObject:SetActive(true)
            if self.refrshCallback ~= nil then
                self.refrshCallback(i, obj, cards[i])
            end
            self.dictionary[i] = {card = cards[i], obj = obj}
        end
    end
    GridResetPosition(self.grid)

    self.selectCards = {}
    if self.releaseSelectCallback ~= nil then
        self.releaseSelectCallback(self.selectCards)
    end
end

function CardGrid:Hide()
    for i = 0, self.grid.transform.childCount - 1 do
        local obj = self.grid.transform:GetChild(i)
        obj.gameObject:SetActive(false)
        obj.transform.localPosition = Vector3.zero
    end
    self.dictionary = {}
end

function CardGrid:RemoveCards(cards, equalAction, callBack)
    for i = 1, #cards do
        for j = #self.dictionary, 1, -1 do
            if equalAction ~= nil and equalAction(self.dictionary[j].card, cards[i]) then
                self.dictionary[j].obj.gameObject:SetActive(false)
                table.remove(self.dictionary, j)
            elseif self.dictionary[j].card == cards[i] then
                self.dictionary[j].obj.gameObject:SetActive(false)
                table.remove(self.dictionary, j)
            end
        end
    end
    local restCards = self:GetCards()
    if callBack ~= nil then
        restCards = callBack(restCards)
    end
    self.selectCards = {}
    self:RefreshCards(restCards)
end

function CardGrid:SetSelectedCards(cards, equalAction)
    for i = 1, #self.dictionary do
        if self.refrshCallback ~= nil then
            self.refrshCallback(i, self.dictionary[i].obj, self.dictionary[i].card)
        end
    end

    self.selectCards = {}
    for i = 1, #self.dictionary do
        local info = self.dictionary[i].card
        for j = 1, #cards do
            if equalAction ~= nil and equalAction(info, cards[j]) then
                table.insert(self.selectCards, info)
                self.selectCardCallback(self.dictionary[i].obj, self.dictionary[i].card, false)
            elseif info == cards[j] then
                table.insert(self.selectCards, info)
                self.selectCardCallback(self.dictionary[i].obj, self.dictionary[i].card, false)
            end
        end
    end
    AudioManager.Instance:PlayAudio("touchcard")
    self.releaseSelectCallback(self.selectCards)
end

function CardGrid:GetSelecedCards()
    return self.selectCards
end

function CardGrid:SetTouchEanble(eanble)
    self.grid:GetComponent("BoxCollider").enabled = eanble
end

local startPositopn = Vector3.zero
function CardGrid:ClickStart()
    if #self.dictionary == 0 then
        return
    end
    startPositopn = GetMousePosition(self.grid)
end

function CardGrid:ClickEnd()
    if #self.dictionary == 0 then
        return
    end

    local endPosition = GetMousePosition(self.grid)
    local minX = Mathf.Min(startPositopn.x, endPosition.x)
    local maxX = Mathf.Max(startPositopn.x, endPosition.x)
    local minY = startPositopn.y -- Mathf.Min(startPositopn.y, endPosition.y);
    local maxY = minY -- Mathf.Max(startPositopn.y, endPosition.y);
    self:CheckContainsCard(minX, maxX, minY, maxY)
end

function CardGrid:CheckContainsCard(minX, maxX, minY, maxY)
    local grid = self.grid:GetComponent("UIGrid")
    local colNum = grid.maxPerLine

    local gridWidth = grid.cellWidth
    local gridHeight = grid.cellHeight

    local cardCount = #self.dictionary
    local cardObj = self.dictionary[1].obj
    local itemWidth = cardObj.transform:Find("Body/Background"):GetComponent("UIWidget").width / 2
    local itemHeight = cardObj.transform:Find("Body/Background"):GetComponent("UIWidget").height / 2

    self.selectCards = {}
    for i = 1, #self.dictionary do
        cardObj = self.dictionary[i].obj
        local info = self.dictionary[i].card
        local position = cardObj.transform.localPosition
        local iminX = position.x - itemWidth
        local imaxX = ((math.modf(i % colNum) ~= 0 and i ~= cardCount) and gridWidth or itemWidth * 2) + iminX
        local iminY = (position.y - itemHeight) + (math.modf(((i - 1) / colNum)) == 0 and 0 or -gridHeight)
        local imaxY = position.y + itemHeight
        if imaxX > minX and maxX > iminX then
            if imaxY > minY and maxY > iminY then
                self.selectCardCallback(cardObj.gameObject, info, false)
            end
        end

        if self.verifySelectedCallback(cardObj.gameObject, info) then
            table.insert(self.selectCards, info)
        end
    end
    AudioManager.Instance:PlayAudio("touchcard")
    self.releaseSelectCallback(self.selectCards)
end
