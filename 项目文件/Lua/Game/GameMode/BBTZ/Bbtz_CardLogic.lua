require("Card")
require("HandCard")
local json = require("json")
Bbtz_CardLogic = {}
local this = Bbtz_CardLogic

SpecialType = {None = "None", ZWSK = "ZWSK", WSK = "WSK", Flush = "Flush", DiZha = "DiZha", ZhaDan = "ZhaDan"}

--得到桌面手牌
function this.GetDeskHanCard(sCards)
    local handCard = HandCard.New(this.CardtoCardInfo(sCards))

    local diZhaGroup,flushGroup,zhaDanGroup,flush510KGroup,c510kGroup = this.FindSpecialCards(handCard)

    local restCards = {handCard:Cards()}

    local sortCards = {}
    this.SetCardTable(diZhaGroup, sortCards, SpecialType.DiZha)
    this.SetCardTable(flushGroup, sortCards, SpecialType.Flush)
    this.SetCardTable(zhaDanGroup, sortCards, SpecialType.ZhaDan)
    this.SetCardTable(flush510KGroup, sortCards, SpecialType.ZWSK)
    this.SetCardTable(c510kGroup, sortCards, SpecialType.WSK)
    this.SetCardTable(restCards, sortCards, SpecialType.None)

    print(#diZhaGroup, #flushGroup, #zhaDanGroup, #flush510KGroup, #c510kGroup, #restCards)
    -- print(#sortCards, json:encode(sortCards))
    return sortCards
end

--将source牌集合插入des集合 会追加一个specialType 特殊类型
function this.SetCardTable(sourceCards, destinationCards, specialType)
    for i = 1, #sourceCards do
        table.sort(
            sourceCards[i],
            function(a, b)
                return a > b
            end
        )
        this.InsertTable(
            destinationCards,
            sourceCards[i],
            function(card)
                card.SpecialType = specialType
                return card
             --{Card = card, Key = Card.GetCardKey(card), Color = Card.GetCardColor(card), SpecialType = specialType}
            end
        )
    end
end

--得到桌面已出的手牌
function this.GetDeskOutHanCard(lastHandCards)
    --print("lastHandCards was called");
    --print("cards.length:"..#(lastHandCards.cards).."|category:"..lastHandCards.category.."|keyCardCount:"..lastHandCards.keyCardCount.."|maxValue:"..lastHandCards.maxValue.."|minValue:"..lastHandCards.minValue);
    local sortCard = {}
    local m_HandCard = HandCard.New(lastHandCards.cards)
    local sCards = this.CardtoCardInfo(lastHandCards.cards)
    this.InsertTable(
        sortCard,
        sCards,
        function(card)
            card.SpecialType = SpecialType.None
            return card
         --{Card = card, Key = Card.GetCardKey(card), Color = Card.GetCardColor(card), SpecialType = specialType}
        end
    )
    sortCard = this.GetOutCardByMainAndWith(m_HandCard, lastHandCards)
    return sortCard
end
--keyCardCount 比如三连飞机，那么keyCardCount=3 比如5连对，那么keyCardCount=5
--检测牌型大小（是否可以压牌）
function this.CheckCompliance(cardInfos, lasterCards, lasterCategory,keyCardCount)
    -- print("cardInfos.length:"..#cardInfos);
    -- print("keyCardCount:"..tostring(keyCardCount));
    local handCard = HandCard.New(cardInfos)
    local mCategory,mMinkey, mCount = handCard:GetHandCardCategory()
    print("mCategory:", mCategory)
    if mCategory == nil then
        return false
    end
    --print("#lasterCards:"..(#lasterCards).."|lasterCards:"..(#lasterCards).."|lasterCategory:"..lasterCategory);
    if lasterCategory == nil or lasterCards == nil or #lasterCards == 0 then
        --这个时候时自己出牌,检测四带三有没有开启
        if mCategory == Card.Category.SISAN and (not roomData.setting.betSan) then
            --虽然不能四带三，但是如果是炸弹带一个牌，那么就是三带二，也是可以出牌的,比如AAAA加一个K，其实是AAA,AK这样的三带二
            return #cardInfos <= 5
        end
        return true
    end

    local mCategory = this.GetTransformSpecial(handCard, mCategory, mMinkey, mCount)
    local lCategory = lasterCategory
    local lastHandCard,lMinkey,lCount = this.GetOutCardCategory(lasterCards, lasterCategory)
    local mSize = this.GetSpecialCategorySize(mCategory)
    local lSize = this.GetSpecialCategorySize(lCategory)

    print(mCategory, mMinkey, mCount, mSize)
    print(lCategory, lMinkey, lCount, lSize)

    if mSize ~= lSize then
        return mSize > lSize
    end

    if mSize == 0 then --如果两个都为0 则都是普通牌型
        if lCategory ~= mCategory then
            --这里有种特殊情况，对方出的是三带的牌，而自己可能用炸弹带牌的类型去出，比如炸弹带一个牌，其实是把炸弹拆开，变成了三带二去打
            if lCategory == Card.Category.SAN and mCategory == Card.Category.SISAN then
                return mMinkey > lMinkey and #cardInfos <= 5
            end
            return false
        else
            --这里飞机有一种特殊情况，比如对方出三连飞机，自己其实可以出四连飞机，但是其实是三连飞机带的牌刚好凑够一个四连飞机
            if lCategory == Card.Category.FEI then 
                if mCount == keyCardCount then 
                    return mMinkey > lMinkey;
                elseif mCount > keyCardCount then 
                    return (mMinkey > lMinkey and #cardInfos <= (keyCardCount*5));--这里其实是lCount*3+lCount*2,
                else
                    return false;
                end
            else
                return mMinkey > lMinkey and mCount == lCount
            end
            
        end
    end

    if lCategory == Card.Category.BOOM then
        return mMinkey > lMinkey
    elseif lCategory == Card.Category.THS then
        if mCount > lCount then --同花顺个数比较
            return true
        else
            --同花顺个数相同时
            if mCount == lCount then
                if mMinkey > lMinkey then
                    return true
                elseif mMinkey == lMinkey then --数量相同，最大值也相同，那就比花色
                    return handCard:SingleColor() > Card.GetCardColor(lasterCards[1])
                else
                    return false
                end
            else
                return false
            end
        end
    elseif lCategory == Card.Category.DIZHA then
        return (mCount > lCount) and true or (mCount == lCount and mMinkey > lMinkey)
    elseif lCategory == Card.Category.ZWSK and roomData.setting.mask then
        return handCard:SingleColor() > Card.GetCardColor(lasterCards[1])
    end

    return false
end

CardTypeCategory = {
    [SpecialType.ZWSK] = Card.Category.ZWSK,
    [SpecialType.WSK] = Card.Category.WSK,
    [SpecialType.ZhaDan] = Card.Category.BOOM,
    [SpecialType.Flush] = Card.Category.THS,
    [SpecialType.DiZha] = Card.Category.DIZHA
}
function this.CheckSplitSpecialCards(cards, sendCardInfos)
    local cardTypes = {}
    local lock = {}
    for i = 1, #sendCardInfos do
        if sendCardInfos[i].SpecialType ~= SpecialType.None and not lock[sendCardInfos[i].SpecialType] then
            lock[sendCardInfos[i].SpecialType] = true
            table.insert(cardTypes, CardTypeCategory[sendCardInfos[i].SpecialType])
        end
    end

    -- print(#cardTypes)
    if #cardTypes == 0 then
        return true
    elseif #cardTypes > 1 then
        return false
    end

    local handCard = HandCard.New(sendCardInfos)
    local category,
        minkey,
        count = handCard:GetHandCardCategory()
    local category = this.GetTransformSpecial(handCard, category, minkey, count)

    return this.CheckContain(cardTypes, category)
end

--寻找可以出的牌（提示）
function this.FindCanOutCards(cards, latestHand)
    if latestHand == nil then
        return {}
    end

    print("lasterCards.lenth:" .. #latestHand.cards)
    print("lasterCategory:" .. latestHand.category)

    local handCard = HandCard.New(cards)
    local lastHandCard,lastMinKey,lastCount = this.GetOutCardCategory(latestHand.cards, latestHand.category) --HandCard.New(lasterCards)
    local tianZha = handCard:GetKeyCards(16)
    local diZhaGroup,flushGroup,zhaDanGroup,ZWSKGroup,WSKGroup = this.FindSpecialCards(handCard)

    local cardGroup = {}
    if latestHand.category == Card.Category.DAN then
        cardGroup = handCard:FindGreaterCard(Card.GetCardKey(latestHand.cards[1]), 1, true)
    elseif latestHand.category == Card.Category.DUI then
        cardGroup = handCard:FindGreaterCard(Card.GetCardKey(latestHand.cards[1]), 2, true)
    elseif latestHand.category == Card.Category.SAN then
        --如果拿不到三张，有可能是炸弹[四张一样的，比如AAAA加一个K = 三带[AAA,AK]]
        cardGroup = handCard:FindGreaterCard(Card.GetCardKey(latestHand.maxValue), 3)
    elseif latestHand.category == Card.Category.LIAN_DUI then
        local minKey = Card.GetCardKey(lastHandCard:Cards()[1])
        cardGroup = handCard:FindGreaterOrderlyCard(minKey, #latestHand.cards / 2, 2)
    elseif latestHand.category == Card.Category.SHUN then
        local minKey = Card.GetCardKey(lastHandCard:Cards()[1])
        cardGroup = handCard:FindGreaterOrderlyCard(minKey, #latestHand.cards, 1)
    elseif latestHand.category == Card.Category.FEI then
        local minkey = lastMinKey
        cardGroup = handCard:FindGreaterOrderlyCard(minkey, lastCount, 3)
    end
    local checkCompliance = function(cardGroup, specialGroup)
        for i = 1, #specialGroup do
            if this.CheckCompliance(specialGroup[i], latestHand.cards, latestHand.category) then
                table.insert(cardGroup, specialGroup[i])
            end
        end
    end

    checkCompliance(cardGroup, WSKGroup)
    checkCompliance(cardGroup, ZWSKGroup)
    checkCompliance(cardGroup, zhaDanGroup)
    checkCompliance(cardGroup, flushGroup)
    checkCompliance(cardGroup, diZhaGroup)

    if #tianZha ~= 0 then
        table.insert(cardGroup, tianZha)
    end

    print(json:encode(cardGroup))
    return cardGroup
end

--找到所有特殊牌
function this.FindSpecialCards(handCard)
    local checkReplace = function(handCard, cardGroup, verifyCardGroup)
        -- print("verifyCardGroup.length:"..#verifyCardGroup);
        -- print_r(verifyCardGroup);
        for i = 1, #cardGroup do
            if verifyCardGroup and #verifyCardGroup>0 then
              -- print("------------verifyCardGroup");
                for j = #verifyCardGroup, 1, -1 do
                    if this.ReplaceRepeatedCardIfcan(handCard, cardGroup[i], verifyCardGroup[j]) then
                        -- print("cardGroup[i]:"..json:encode(cardGroup[i]));
                        -- print("verifyCardGroup[j]:"..json:encode(verifyCardGroup[j]));
                        table.remove(verifyCardGroup, j)
                    end
                end
            end
        end
    end

    local diZhas = handCard:GetNoRepeatOrderlyCard(4, 2)
    -- print("diZhas----------------->");
    -- print(json:encode(diZhas))
    local ths = {}
    for i = 3, 0, -1 do
        local group = handCard:GetNoRepeatOrderlyCard(5, 1, i)
        if #group ~= 0 then
            this.InsertTable(ths, group)
        end
    end

    -- print("ths.length:"..(#ths));
    -- print(json:encode(ths));
    checkReplace(handCard, diZhas, ths)
    -- print("after replace,dizha:");
    -- print(json:encode(diZhas))
    handCard:RemoveCardGroup(ths)



    local zhaDans = handCard:FindGreaterCard(0, 4)
    -- print(json:encode(zhaDans))
    -- print("zhaDans.length:"..#zhaDans);
    checkReplace(handCard, diZhas, zhaDans)
    -- print("zhaDans.length:"..#zhaDans);
    handCard:RemoveCardGroup(zhaDans)

    local zwsks = handCard:Get510KCard(true)
    checkReplace(handCard, diZhas, zwsks)
    handCard:RemoveCardGroup(zwsks)

    local wsk = handCard:Get510KCard()
    checkReplace(handCard, diZhas, wsk)
    handCard:RemoveCardGroup(wsk)
    handCard:RemoveCardGroup(diZhas)
    return diZhas, ths, zhaDans, zwsks, wsk
end

--替换重复的牌  如果可以
function this.ReplaceRepeatedCardIfcan(handCard, aCards, bCards)
    local completed = true
    local equalKeys,equalTables = this.FindEqualCardKey(aCards, bCards)

    --没有相同的，直接返回false
    if GetTabelLength(equalKeys) == 0 then
        -- print("path---->1");
        return false;
    end

    -- print_r(equalTables);
    local needReplaceCard = {}
    for card, v in pairs(equalKeys) do
        local key = Card.GetCardKey(card)
        local cards = equalTables[key]
        local findCards = handCard:GetCards(key)
        if #cards >= #findCards then--出错了？
            -- print("path---->2");
            completed = false
        else
            table.insert(needReplaceCard, {card = card, cards = cards, findCards = findCards})
        end
    end

   

    table.sort(
        aCards,
        function(a, b)
            return a < b
        end
    )
    -- print("path---------->completed:"..tostring(completed));
    return completed
end

--找到两个组牌中，相同的牌，牌面相同，花色也要相同，
--equalKeys 相同牌的数组，以牌的真实值为key，重复出现数量为value
--equalTables 两组牌中，只要牌面值相等就会存入到这个数组中
function this.FindEqualCardKey(cards, otherCards)
    local equalKeys = {}
    local equalTables,lockequalTables = {}, {}
    -- print("#cards:"..#cards);
    -- print("#otherCards:"..#otherCards);
    for i = 1, #cards do
        for j = 1, #otherCards do
            local key1 = Card.GetCardKey(cards[i])
            local key2 = Card.GetCardKey(otherCards[j])
            
            if key1 == key2 then
                -- print("key1 == key2:"..tostring(key1 == key2),key1,key2);
                if cards[i] == otherCards[j] then
                  local equalCardTable = equalTables[key1]
                  if equalCardTable == nil then
                      equalCardTable = {}
                      equalTables[key1] = equalCardTable
                  end

                  --标记是否查找过
                  if not lockequalTables[cards[i]] then
                      lockequalTables[cards[i]] = true
                      table.insert(equalCardTable, cards[i])
                  end
                  --标记是否查找过
                  if not lockequalTables[otherCards[j]] then
                      lockequalTables[cards[i]] = true
                      table.insert(equalCardTable, otherCards[j])
                  end
                  --找到了就统计数量
                    equalKeys[cards[i]] = equalKeys[cards[i]] == nil and 1 or equalKeys[cards[i]] + 1;
                    
                    -- print("find eque key:"..Card.GetCardKey(cards[i]).."| color:"..Card.GetCardColor(cards[i]));
                end
            end
        end
    end

    -- print("equalTables");
    -- print_r(equalTables);

    return equalKeys, equalTables
end

--对比牌是不是相同
function this.CardEqual(cardA, cardB)
    return cardA == cardB --and cardA.SpecialType == cardB.SpecialType
end

function this.CardtoCardInfo(cards)
    if cards == nil then
        return {}
    end
    local tmep = {}
    for i = 1, #cards do
        table.insert(tmep, Card.New(cards[i]))
    end
    return tmep
end

function this.CardInfoToGameCard(cards)
    local temp = {}
    for i = 1, #cards do
        table.insert(temp, cards[i].value)
    end
    return temp
end

--将普通牌型能否转换成特殊怕牌型
function this.GetTransformSpecial(handCard, category, minKey, count)
    if Card.Category.LIAN_DUI == category and count >= 4 then
        category = Card.Category.DIZHA
    elseif category == Card.Category.SHUN and handCard:GetColorCount() == 1 and count >= 5 then
        category = Card.Category.THS
    elseif category == Card.Category.WSK and handCard:GetColorCount() == 1 then
        category = Card.Category.ZWSK
    end
    return category
end

--得到特殊牌型的大小
function this.GetSpecialCategorySize(category)
    local special = {
        [Card.Category.TIANZHA] = 10,
        [Card.Category.DIZHA] = 9,
        [Card.Category.THS] = 8,
        [Card.Category.BOOM] = 7,
        [Card.Category.ZWSK] = 6,
        [Card.Category.WSK] = 5
    }

    local size = special[category]
    if size == nil then
        return 0
    end
    return size
end

--获得主体跟带牌
function this.GetOutCardByMainAndWith(m_HandCard, lastHandCards)
    local mainCards = {}
    local withCards = {}

    local finalCards = {}
    if not lastHandCards.cards then
        return {}
    end

    local cardKeyTables = m_HandCard._cardKeyTables

    if lastHandCards.category == Card.Category.SAN then
        for key, value in pairs(cardKeyTables) do
            if #value >= 3 then
                for i = 1, 3 do
                    table.insert(mainCards, value[i])
                end

                for i = 4, #value do
                    table.insert(withCards, value[i])
                end
            else
                for i = 1, #value do
                    table.insert(withCards, value[i])
                end
            end
        end
        table.sort(
            withCards,
            function(a, b)
                return a < b
            end
        )
        for i = 1, #mainCards do
            table.insert(finalCards, Card.New(mainCards[i]))
        end
        for i = 1, #withCards do
            table.insert(finalCards, Card.New(withCards[i]))
        end
    elseif lastHandCards.category == Card.Category.FEI then
        for key, value in pairs(cardKeyTables) do
            if #value >= 3 then
                for i = 1, 3 do
                    if
                        Card.GetCardKey(value[i]) >= Card.GetCardKey(lastHandCards.minValue) and
                            Card.GetCardKey(value[i]) <= Card.GetCardKey(lastHandCards.maxValue)
                     then
                        table.insert(mainCards, value[i])
                    else
                        table.insert(withCards, value[i])
                    end
                end
                for i = 4, #value do
                    table.insert(withCards, value[i])
                end
            else
                for i = 1, #value do
                    table.insert(withCards, value[i])
                end
            end
        end

        table.sort(
            mainCards,
            function(a, b)
                return a < b
            end
        )
        table.sort(
            withCards,
            function(a, b)
                return a < b
            end
        )

        for i = 1, #mainCards do
            table.insert(finalCards, Card.New(mainCards[i]))
        end
        for i = 1, #withCards do
            table.insert(finalCards, Card.New(withCards[i]))
        end
    elseif lastHandCards.category == Card.Category.SISAN then
        for key, value in pairs(cardKeyTables) do
            if #value >= 4 then
                for i = 1, 4 do
                    table.insert(mainCards, value[i])
                end
                for i = 5, #value do
                    table.insert(withCards, value[i])
                end
            else
                for i = 1, #value do
                    table.insert(withCards, value[i])
                end
            end
        end
        table.sort(
            withCards,
            function(a, b)
                return a < b
            end
        )
        for i = 1, #mainCards do
            table.insert(finalCards, Card.New(mainCards[i]))
        end
        for i = 1, #withCards do
            table.insert(finalCards, Card.New(withCards[i]))
        end
    else
        table.sort(
            m_HandCard._cards,
            function(a, b)
                return a < b
            end
        )
        finalCards = m_HandCard._cards
    end

    return finalCards
end

--得到别人出牌的最小值 牌型数量
function this.GetOutCardCategory(cards, category)
    local minKey = nil
    local count = 1
    local handCard = HandCard.New(cards)
    if category == Card.Category.DAN or category == Card.Category.DUI or category == Card.Category.BOOM then
        minKey = Card.GetCardKey(cards[1])
    elseif category == Card.Category.SHUN or category == Card.Category.THS then
        count = #cards
        minKey = Card.GetCardKey(cards[1])
    elseif category == Card.Category.LIAN_DUI or category == Card.Category.DIZHA then
        count = #cards / 2
        minKey = Card.GetCardKey(cards[1])
    elseif category == Card.Category.WSK or category == Card.Category.ZWSK then
        count = #cards / 3
        minKey = Card.GetCardKey(cards[1])
    elseif category == Card.Category.SAN then
        --如果拿不到三张，有可能是炸弹[四张一样的，比如AAAA加一个K = 三带[AAA,AK]]拆自己的三张
        if handCard:GetCardGroupByCount(3) == nil or #handCard:GetCardGroupByCount(3) == 0 then
            minKey = Card.GetCardKey(handCard:GetCardGroupByCount(4)[1][1])
        else
            minKey = Card.GetCardKey(handCard:GetCardGroupByCount(3)[1][1])
        end
    elseif Card.Category.SISAN == category then
        minKey = Card.GetCardKey(handCard:GetCardGroupByCount(4)[1][1])
    elseif category == Card.Category.FEI then
        local cards = handCard:GetLongestOrderlyCard(2, 3)
        count = #cards / 3
        minKey = Card.GetCardKey(cards[#cards])
        if count * 5 ~= #cards and (count - 1) * 5 == #cards then
            count = count - 1
        end
    end

    return handCard, minKey, count
end

do --操作数据的方法
    --把一个表插入另外表里  conversion转换
    function this.InsertTable(otable, vtable, conversion)
        for i = 1, #vtable do
            local value = vtable[i]
            if conversion ~= nil then
                value = conversion(vtable[i])
            end
            table.insert(otable, value)
        end
    end

    function this.CheckContain(tableA, value)
        for i = 1, #tableA do
            if tableA[i] == value then
                return true
            end
        end
        return false
    end

    --从findCards找出cards 中没有出现的牌
    function this.NotAppearCard(cards, findCards)
        local notFindCards = {}
        for i = 1, #findCards do
            local card = findCards[i]
            if not this.CheckContain(cards, card) then
                table.insert(notFindCards, card)
            end
        end
        return notFindCards
    end

    function TableFindIndex(table, k)
        for i = 1, #table do
            if table[i] == k then
                return i
            end
        end
        return -1
    end

    function GetTabelLength(table)
        local count = 0
        for k, v in pairs(table) do
            count = count + 1
        end
        return count
    end
end
