require("class")
require("Card")

HandCard = class()
--牌的集合 cards 不是服务器定义的 由“Cards”
function HandCard:ctor(cards)
    self._cards = CopyCards(cards)
    table.sort(self._cards, function(a, b)
        return a < b;
    end)

    self:Init()
end

--获得一个按照牌面值分类的键值对 比如 {3={3,3,3},4={4,4},5={5,5,5,5},6={6}},并且返回关联数组{1=3,2=4,3=5,4=6}
--needKey需不需要把key返回

local function GetCardKeyTable(cards, needKey)
        local cardKeyTables = {}

        for i = 1, #cards do
            local key = Card.GetCardKey(cards[i])
            local cardTable = cardKeyTables[key]

            if  cardTable == nil then
                cardTable = {}
                cardKeyTables[key] = cardTable;
            end

            table.insert(cardTable, cards[i])
        end

        if not needKey then return cardKeyTables end

        local cardKeys = {}
        local index = 1;
        for k,v in pairs(cardKeyTables) do
            cardKeys[index] = k
            index = index + 1
        end
        table.sort(cardKeys, function(a, b) return a < b end)

        return  cardKeyTables, cardKeys
end

--以数量为key，找出所有某个数量级的牌组，比如{2={{3,3},{7,7}},5={{J,J,J,J,J}},3={{8,8,8},{4,4,4},{6,6,6}}};
local function GetCardCountTable(cardKeyTable, cardCount)
        local cardCountTables = {}

        for _,v in pairs(cardKeyTable) do
            local count = #v
            local cardTable = cardCountTables[count]

            if cardTable == nil then
                cardTable = {}
                cardCountTables[count] = cardTable
            end

            table.insert(cardTable, v)
        end

        for i = 1, cardCount do
            if cardCountTables[i] == nil then
                cardCountTables[i] = {}
            end
        end

        return cardCountTables
end

--按花色将牌分组，比如{"方块"={4,7,9,J},"黑桃"={4,8,J,10},"梅花"={9,4,A,7}}
local function GetHandCardColor(cards)
        local cardColors = {}
        for i = 1, #cards do
            local key   = Card.GetCardKey(cards[i])
            local color = Card.GetCardColor(cards[i])

            --这种写法看不懂请看下面注释的等价的写法
            local colorTable = cardColors[color]
            if colorTable == nil then
                colorTable = {}
                cardColors[color] = colorTable
            end
            local cardsTable = colorTable[key]
            if cardsTable == nil then
                cardsTable = {}
                colorTable[key] = cardsTable
            end

            --if cardColors[color] == nil then
            --    cardColors[color] = {};
            --end
            --if cardColors[color][key] == nil then
            --    cardColors[color][key] = {};
            --end
            --table.insert(cardColors[color][key], cards[i])
            table.insert(cardsTable, cards[i])
        end
        return cardColors
end

function HandCard:Init()
    local cardKeyTable, cardkeys = GetCardKeyTable(self._cards, true)
    --{ [ [] ] }  牌面值对应的所有牌
    self._cardKeys = cardkeys
    self._cardKeyTables = cardKeyTable

    self._cardColorTable = GetHandCardColor(self._cards) --[key]{color[]{card,card,},color[]{card,card,}}
    self._cardCountTables = GetCardCountTable(cardKeyTable, 4) --牌的数量对应的所有牌

    return self
end

function HandCard:Cards() return self._cards end

function HandCard:Length() return #self._cards end

function HandCard:GetCards(key, count, color)
    local cards = {}

    local cardTable = self._cardKeyTables[key]
    if color ~= nil then
        cardTable = self._cardColorTable[color] and self._cardColorTable[color][key] or {}
    end

    if cardTable == nil then return false end

    if count == nil then return cardTable end

    if #cardTable < count then return false end

    for i = 1, count do
        table.insert(cards, cardTable[i])
    end
    return cards
end

function HandCard:GetKeyCards(key)
    local cards = self._cardKeyTables[key]
    return cards == nil and {} or cards
end

--获得花色的统计
function HandCard:GetColorCount()
    local count = 0
    local colors = {}
    for k, v in pairs(self._cardColorTable) do
        count = count + 1
        table.insert(colors, k)
    end

    return count, colors
end

function HandCard:SingleColor()
    local count, colors = self:GetColorCount()

    if count > 1 then
        return nil
    end

    return colors[1]
end

--找到比compareKey更大的牌 key 牌的数量
function HandCard:FindGreaterCard(compareKey, count, ifNeedOtherCountCard)
    if compareKey == nil or count == nil then return {} end
    local cardGroups = {}
    for i = 1, #self._cardKeys do
        local key = self._cardKeys[i]
        if  key > compareKey then
            local cards = self:GetCards(key, count)
          
            if cards then
                for j=1,#cards do
                    cards[j].key = Card.GetCardKey(cards[j]);
                end
                table.insert(cardGroups, cards)
            end
        end
    end

    if not ifNeedOtherCountCard then
        for i = #cardGroups, 1, -1 do
            local key = Card.GetCardKey(cardGroups[i][1])
            if #self._cardKeyTables[key] > count then
                table.remove(cardGroups, i)
            end
        end
    end

    return cardGroups
end

--找到所有连续的牌
function HandCard:FindAllOrderlyCard(orderlyCount, cardCount, color)
    local cardGroups = {}

    local firstChekcCount = #self._cardKeys - orderlyCount + 1
    local lastCheckCount = orderlyCount - 1
    for firstIndex = 1, firstChekcCount do
        for lastIndex = lastCheckCount, #self._cardKeys - firstIndex do
            local firstKey = self._cardKeys[firstIndex]
            local lastKey = self._cardKeys[firstIndex + lastIndex]

            if lastKey - firstKey ~= lastIndex then
                break
            end
            local cardGroup = {}
            local complete = true
            for i = firstIndex, firstIndex + lastIndex do
                local key = self._cardKeys[i]
                local cards = self:GetCards(key, cardCount, color)
                if not cards then
                    complete = false
                    break
                end
                for j = 1, #cards do
                    local tempKey = Card.GetCardKey(cards[j]);
                    if  tempKey == 16 or tempKey == 15 then--顺子不包括大王和2
                        complete = false;
                        break;
                    end
                    table.insert(cardGroup, cards[j])
                end
            end

            if complete then
                table.insert(cardGroups, cardGroup)
            end
        end
    end

    return cardGroups;
end

--找到所有制定连续数量的牌
function HandCard:FindOrderlyCard(orderlyCount, cardCount, color)
    local cardGroups = self:FindAllOrderlyCard(orderlyCount, cardCount, color)

    for i = #cardGroups, 1, -1 do
        local count = #cardGroups[i] / cardCount
        if count ~= orderlyCount then
            table.remove(cardGroups, i)
        end
    end

    return cardGroups
end

--找到所有不重复的
function HandCard:GetNoRepeatOrderlyCard(orderlyCount, cardCount, color)
    local cardGroups = {}
    local cards = CopyCards(self._cards)
    --去掉2，
    for i = #cards, 1,-1 do
        if cards[i].value == 48 or cards[i].value == 49 or cards[i].value == 50 or cards[i].value == 51 then
            table.remove(cards,i);
        end
    end
    while #cards >= (orderlyCount * cardCount) do
        local handCard = HandCard.New(cards)
        local group = handCard:GetLongestOrderlyCard(orderlyCount, cardCount, color)
        handCard:RemoveCard(group)
        cards = handCard:Cards()
        if #group == 0 then
            break
        else
            table.insert(cardGroups, group)
        end
    end

    return cardGroups
end

--找到所有指定连续数量的牌
function HandCard:FindGreaterOrderlyCard(compareKey, orderlyCount, cardCount, color)
    local cardGroups = {}
    if orderlyCount ~= nil then
        cardGroups = self:FindOrderlyCard(orderlyCount, cardCount, color)
    else
        cardGroups = self:FindAllOrderlyCard(2, 1, color)
    end

    for i = #cardGroups, 1, -1 do
        local key = Card.GetCardKey(cardGroups[i][1])
        if key <= compareKey then
            table.remove(cardGroups, i)
        end
    end

    return cardGroups
end

--找到最长指定连续数量的牌
function HandCard:GetLongestOrderlyCard(orderlyCount, cardCount, color)
    local cardGroups = self:FindAllOrderlyCard(orderlyCount, cardCount, color)

    if #cardGroups == 0 then return {} end

    table.sort(cardGroups, function (groupA, groupB) return #groupA > #groupB end)

    return cardGroups[1]
end

local function Get510KCard(cardKeyTables)
    local card5Count = cardKeyTables[5] ~= nil and #cardKeyTables[5] or 0
    local card10Count = cardKeyTables[10] ~= nil and #cardKeyTables[10] or 0
    local cardKCount = cardKeyTables[13] ~= nil and #cardKeyTables[13] or 0

    local minCardCount = math.min(card5Count, card10Count, cardKCount)
    if minCardCount == 0 then return {} end

    local cardGroup = {}
    for i = 1, minCardCount do
        local group = {cardKeyTables[5][i], cardKeyTables[10][i], cardKeyTables[13][i]}
        table.insert(cardGroup, group)
    end

    return cardGroup
end

local function RemoveCard(cards, removeCards)
    for i = 1, #removeCards do
        for j = #cards, 1, -1 do
            if removeCards[i] == cards[j] then
                table.remove(cards, j)
            end
        end
    end

    return cards
end

--返回5 10 k
function HandCard:Get510KCard(btrue)
    local cleanCard = function (cards, cardGroup, card510KGroup)
        for i = 1, #cardGroup do
            cards = RemoveCard(cards, cardGroup[i])
            table.insert(card510KGroup, cardGroup[i])
        end
        return cards;
    end

    local cards = CopyCards(self._cards)
    if btrue then
        local colorCards, flush510KGroup = GetHandCardColor(cards), {}
        for i = 0, 3 do
            if colorCards[i] then
                local cardGroup = Get510KCard(colorCards[i])
                cards = cleanCard(cards, cardGroup, flush510KGroup)
            end
        end
        return flush510KGroup
    else
        local cardGroup,card510KGroup = Get510KCard(GetCardKeyTable(cards)), {}
        for i = 1, #cardGroup do
            table.insert(card510KGroup, cardGroup[i])
        end
        return card510KGroup
    end
end

function HandCard:RemoveCard(cards)
    self._cards = RemoveCard(self._cards, cards)
    self:Init()
end

function HandCard:RemoveCardGroup(cardGroup)
    for i = 1, #cardGroup do
        self._cards = RemoveCard(self._cards, cardGroup[i])
    end
    self:Init()
end

function CheckContainCardKey(cardKeys, key)
    for i = 1, #cardKeys do
        if cardKeys[i] == key then
            return true
        end
    end
    return false
end

function HandCard:CheckContainCardKey(key)
    return CheckContainCardKey(self._cardKeys, key)
end

--返回能达到要求数目的牌，比如寻找能满足3个5的牌，那么{5554}，{55554}，这些都能满足
--count 满足的数量
--isMoreThen 是否找出所有满足数量的牌
function HandCard:GetCardGroupByCount(count, isMoreThen)
    local cards = {}

    if not isMoreThen then
        cards = self._cardCountTables[count]
    else
        for k, v in pairs(self._cardCountTables) do
            if k >= count then
                for i = 1, #v do
                    local temp = {}
                    for j = 1, count do
                        table.insert(temp, v[i][j])
                    end
                    table.insert(cards, temp)
                end
            end
        end
    end

    table.sort(cards, function (groupA, groupB) return Card.GetCardKey(groupA[1]) < Card.GetCardKey(groupB[1]) end)

    return cards
end

--当排数小于5张时，获得这些牌的牌型，牌型的牌面值最小值，该牌型具有的数量
--返回值  牌型 牌型的牌面的起始值（牌面已经从小打到排序了，比如连对，4455，那么就是4，再比如555（三张），就是5，） 该牌型具有的数量
--cardKeys 是已经根据key（牌面）的大小排过序了，从小到大的排序
function HandCard:CheckHandCardInfoLess5(cards, cardKeys, cardKeyTable)
    -- print("CheckHandCardInfoLess5 was called");
    local cardCount = #cards

    local firstCardKey = cardKeys[1]
    local lastCardKey = cardKeys[#cardKeys]

    if #cards == 1 and cardKeys[1] == 16 then
        return Card.Category.TIANZHA, 0, 1
    end

    --第一个牌面值跟最后一个牌面值一样
    if firstCardKey == lastCardKey then
        local category = nil
        if cardCount == 1 then
            category = Card.Category.DAN
        elseif cardCount == 2 then
            category = Card.Category.DUI;
        elseif cardCount == 3 then
            category = Card.Category.SAN
        elseif cardCount == 4 then
            category = Card.Category.BOOM
        end

        return category, firstCardKey, 1
    end
    --510K的判断
    if #cards == 3 and #cardKeys == 3 and cardKeys[1] == 5 and cardKeys[2] == 10 and cardKeys[3] == 13 then
        -- print("path------------>1")
        return self:GetColorCount() == 1 and Card.Category.ZWSK or Card.Category.WSK, 0, 1
    end

    local cardGroup = self:GetCardGroupByCount(3);
    if cardCount == 4 and #cardGroup == 1 then
        -- print("path-------->2")
        return Card.Category.SAN, Card.GetCardKey(cardGroup[1][1]), 1
    end

    if cardCount / 2 == 2 and cardCount % 2 == 0 and lastCardKey - firstCardKey == 1 and lastCardKey ~= Card.GetCardKey(51) then --连队不能有2
        
        return Card.Category.LIAN_DUI, lastCardKey, 2
    end
end

--检查飞机与带牌的情况
local function Check3nNcardInfo(cards, orderlyCards)
    local cardCount = #cards
    local orderlyCount = #orderlyCards / 3
    if orderlyCount == 0 then 
        return nil, nil, nil 
    end

    local firstCardKey = Card.GetCardKey(orderlyCards[1])
    local lastCardKey = Card.GetCardKey(orderlyCards[#orderlyCards])

    --全部牌都是飞机主体，没有带任何牌
    if cardCount % 3 == 0 and lastCardKey - firstCardKey == (cardCount / 3) - 1 then
        return Card.Category.FEI, lastCardKey, orderlyCount
    --5连飞机？
    elseif orderlyCount == cardCount / 5 and lastCardKey - firstCardKey == (cardCount / 5) - 1 then
        return Card.Category.FEI, lastCardKey, orderlyCount
    elseif orderlyCount * 5 ~= cardCount and (orderlyCount - 1) * 5 == cardCount then
        return Card.Category.FEI, lastCardKey, orderlyCount
    elseif cardCount - orderlyCount * 3 < orderlyCount * 2 then
        return Card.Category.FEI, lastCardKey, orderlyCount
    end
end

--返回值  牌型 判断牌型大小的最小值 判断牌型的数量
function HandCard:CheckHandCardInfoMore5(cards, cardKeys, cardKeyTable)
    local cardCount = #cards
    local cardCountTables = self._cardCountTables

    local firstCardKey = cardKeys[1]
    local lastCardKey = cardKeys[#cardKeys]
    if cardCount == 5 and #cardCountTables[3] == 1  then
        return Card.Category.SAN, Card.GetCardKey(cardCountTables[3][1][1]), 1
    elseif cardCount == 5 and #cardCountTables[4] == 1 then
        return Card.Category.SISAN, Card.GetCardKey(cardCountTables[4][1][1]), 1
    elseif cardCount == 6 and #cardCountTables[4] == 1 then
        return Card.Category.SISAN, Card.GetCardKey(cardCountTables[4][1][1]), 1
    elseif cardCount == 7 and #cardCountTables[4] == 1 then
        return Card.Category.SISAN, Card.GetCardKey(cardCountTables[4][1][1]), 1
    elseif (lastCardKey - firstCardKey) == (cardCount - 1) and self:IsDisciplinary(cardKeys,1)
            and not (self:CheckContainCardKey(Card.GetCardKey(48)) or--不包括2的意思
            self:CheckContainCardKey(Card.GetCardKey(49)) or
            self:CheckContainCardKey(Card.GetCardKey(50)) or
            self:CheckContainCardKey(Card.GetCardKey(51))) then
        return Card.Category.SHUN, lastCardKey, cardCount;
    elseif (cardCount / 2) >= 2
            and (cardCount % 2) == 0
            and (lastCardKey - firstCardKey) == ((cardCount / 2) - 1)
            and #cardCountTables[2] == (cardCount / 2)
            and not (self:CheckContainCardKey(Card.GetCardKey(48)) or
            self:CheckContainCardKey(Card.GetCardKey(49)) or
            self:CheckContainCardKey(Card.GetCardKey(50)) or
            self:CheckContainCardKey(Card.GetCardKey(51))) then
        return Card.Category.LIAN_DUI, lastCardKey, cardCount / 2;
    else
        return Check3nNcardInfo(cards, self:GetLongestOrderlyCard(2, 3))
    end
end

--是否有规律的增加或者减少
function HandCard:IsDisciplinary(cardKeys,gap)

    if cardKeys == nil or gap == nil then
        return false;
    end

    if #cardKeys <= 1 then
        return true;
    end
    for i = 1, #cardKeys-1 do
        if cardKeys[i+1] - cardKeys[i] ~= gap then
            return false;
        end
    end
    return true;
end

--返回值  牌型 判断牌型大小的最小值 判断牌型的数量
function HandCard:GetHandCardCategory()
    local category = nil
    local minCardKey = nil
    local categoryCount = #self._cards

    if #self._cards < 5 then
        category, minCardKey, categoryCount = self:CheckHandCardInfoLess5(self._cards, self._cardKeys, self.cardCountTables)
    else
        category, minCardKey, categoryCount = self:CheckHandCardInfoMore5(self._cards, self._cardKeys, self.cardCountTables)
    end
    return category, minCardKey, categoryCount
end

function CopyCards(cards)
    if cards == nil then return {} end;
    local tmepCards = {}
    for i = 1, #cards do
        table.insert(tmepCards, cards[i])
    end
    return tmepCards
end
