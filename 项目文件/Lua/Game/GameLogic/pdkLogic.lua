local json = require 'json'

pdk_Logic = {}
local this = pdk_Logic

function this.getIntPart(x)
    if x <= 0 then
        return math.ceil(x)
    end

    if math.ceil(x) == x then
        x = math.ceil(x)
    else
        x = math.ceil(x) - 1
    end
    return x
end

function this.GetCardHash(card)
    return this.getIntPart(card/4)+3
end

function this.GetCardHashTable(cards)
    local cardTable = {}
    for i = 1, #cards do
        local cardHash = this.GetCardHash(cards[i])
        local cardGroup = cardTable[cardHash]
        if cardGroup == nil then
            cardGroup = {}
        end

        table.insert(cardGroup, cards[i])
        cardTable[cardHash] = cardGroup
    end

    local Index = 1
    local cardHashTable = {}
    for k,v in pairs(cardTable) do
        cardHashTable[Index] = k
        Index = Index + 1
    end
    
    -- for k,v in pairs(cardTable) do 可能不安顺序遍历
    table.sort(cardHashTable, function (cardHashA, cardHashB)
        return cardHashA < cardHashB
    end )

    return cardTable, cardHashTable
end

function this.FindCanPlayCard(handCards, lastOutCards, category, isFindAll, nextOnlyOneCard)

    print('lastCategory：'..tostring(category))

    local handCardsTmep = {}
    for i = 1, #handCards do
        table.insert(handCardsTmep, handCards[i])
    end

    local LastOutCardsTmep = {}
    for i = 1, #lastOutCards do
        table.insert(LastOutCardsTmep, lastOutCards[i])
    end

    table.sort(handCardsTmep, tableSortAsc)
    table.sort(LastOutCardsTmep, tableSortAsc)
    -- print("handCardsTmep: "..tostring(json:encode(handCardsTmep)))
    -- print("LastOutCardsTmep: "..tostring(json:encode(LastOutCardsTmep)))

    local HandcardTable, HandCardHashTable = this.GetCardHashTable(handCardsTmep)
    -- print('HandcardTable: '..tostring(json:encode(HandcardTable)))
    -- print("HandCardHashTable: "..tostring(json:encode(HandCardHashTable))..'||长度：'..#HandCardHashTable)

    local LastCardTable, LastCardHashTable = this.GetCardHashTable(LastOutCardsTmep)
    -- print('LastCardTable: '..tostring(json:encode(LastCardTable)))
    -- print("LastCardHashTable: "..tostring(json:encode(LastCardHashTable))..'||长度：'..#LastCardHashTable)

    local zhaDanGroup = {}
    local group4 = this.GetCardGroupByCount(this.GetCardsGroup(handCardsTmep), 4)
    --炸弹
    for i = 1, #group4 do
        local cardGroup = {}
        for j = 1, #group4[i] do
            table.insert(cardGroup, group4[i][j])
        end
        table.insert(zhaDanGroup, cardGroup)
    end
 
    --跑得快16  AAA当炸弹 
    if roomData.setting.bombAAA and HandcardTable[this.GetCardHash(47)] ~= nil 
        and #HandcardTable[this.GetCardHash(47)] == 3 then
        local cardGroup = {}
        for i = 1, 3 do
            table.insert(cardGroup, HandcardTable[this.GetCardHash(47)][i])
        end
        table.insert(zhaDanGroup, cardGroup)
    end

    if not roomData.setting.bombSplit then
        for i=1, #zhaDanGroup do
            local cardHash = this.GetCardHash(zhaDanGroup[i][1])
            HandcardTable[cardHash] = {}
        end
    end

    local ret = {}

    if category == ZHA_DA then
        local lastOutMinCard = this.GetCardHash(LastOutCardsTmep[1])
        print(json:encode(lastOutMinCard))
        for i = #zhaDanGroup, 1, -1 do
            if this.GetCardHash(zhaDanGroup[i][1]) <= lastOutMinCard then
                table.remove(zhaDanGroup, i)
            end
        end
        
        ret = zhaDanGroup
    end

    while true do
        if category == DAN then

            local lastOutMaxCard = this.GetCardHash(lastOutCards[1])
            for i = 1, #handCardsTmep do
                if this.GetCardHash(handCardsTmep[i]) > lastOutMaxCard then
                    table.insert(ret, {handCardsTmep[i]})
                end
            end
            if nextOnlyOneCard then
                table.sort(ret, function (a, b) return a[1] > b[1] end)
            end
            print('可以出的单牌：'..tostring(json:encode(ret)))
        elseif category == DUI then
    
            if #handCardsTmep < 2 then
                break --为了适配 原来的上个人的逻辑
            end
    
            local lastOutMaxCard = this.GetCardHash(lastOutCards[1])
            for i = 1, #handCardsTmep do
                local cardHash = this.GetCardHash(handCardsTmep[i])
                if cardHash > lastOutMaxCard and #HandcardTable[cardHash] >= 2 then
                    local cardGroup = {}
                    cardGroup[1] = HandcardTable[cardHash][1]
                    cardGroup[2] = HandcardTable[cardHash][2]
                    table.insert(ret, cardGroup)
                end
            end
    
            print('可以出的对子：'..tostring(json:encode(ret)))
        elseif category == SAN or category == SAN_YI or category == SAN_ER then
    
            if #handCardsTmep < 3 then
                break --为了适配 原来的上个人的逻辑
            end
            
            local lastOutMaxCard = this.GetCardHash(this.GetCardGroupByCount(this.GetCardsGroup(LastOutCardsTmep), 3, true)[1][1])
            for i = 1, #HandCardHashTable do
                local cardHash = HandCardHashTable[i]
                if cardHash > lastOutMaxCard and #HandcardTable[cardHash] >= 3 then
                    local cardGroup = {}
                    cardGroup[1] = HandcardTable[cardHash][1]
                    cardGroup[2] = HandcardTable[cardHash][2]
                    cardGroup[3] = HandcardTable[cardHash][3]
                    table.insert(ret, cardGroup)
                end
            end
    
            print('可以出的3同：'..tostring(json:encode(ret)))
        elseif category == SHUN then
    
            local lastOutCardCount = #LastOutCardsTmep
    
            if #handCardsTmep < lastOutCardCount then
                break --为了适配 原来的上个人的逻辑
            end
    
            local lastOutMinCard = this.GetCardHash(LastOutCardsTmep[1])
            print('上次出牌顺子最小的：'..tostring(lastOutMinCard))
            ret = this.GetContinuousCards(HandCardHashTable, HandcardTable, lastOutMinCard, (lastOutCardCount), 1, this.GetCardHash(51))
            print('可以出的顺子：'..tostring(json:encode(ret)))
    
        elseif category == LIAN_DUI then
            
            if #handCardsTmep < #LastOutCardsTmep then
                break --为了适配 原来的上个人的逻辑
            end
    
            local lastOutCardCount = #LastOutCardsTmep / 2
            local lastOutMinCard = this.GetCardHash(LastOutCardsTmep[1])
            print('上次出牌顺子最小的：'..tostring(this.GetCardHash(LastOutCardsTmep[1])))
            ret = this.GetContinuousCards(HandCardHashTable, HandcardTable, lastOutMinCard, lastOutCardCount, 2)
            print('可以出的连队：'..tostring(json:encode(ret)))
        elseif category == SAN_SHUN or category == FEI_YI or category == FEI_ER then
    
            if #handCardsTmep < 6 then
                break --为了适配 原来的上个人的逻辑
            end
    
            local lastCardGroup = this.GetMaxContinuousCards(LastCardHashTable, LastCardTable, 2, 3)
            local lastMaxCount = #lastCardGroup / 3
            local lastMaxCardHash = this.GetCardHash(lastCardGroup[#lastCardGroup])
            if lastMaxCount * 3 ~= #LastOutCardsTmep and (lastMaxCount - 1) * 5 == #LastOutCardsTmep and #LastOutCardsTmep == 10 then
                lastMaxCount = lastMaxCount - 1
            end
    
            print('上次出牌3N最大的：'..tostring(lastMaxCardHash))
            ret = this.GetContinuousCards(HandCardHashTable, HandcardTable, lastMaxCardHash, lastMaxCount, 3)
            print('可以出的3n：'..tostring(json:encode(ret)))
    
        elseif category == SI_YI or category == SI_ER or category == SI_SAN then
    
            local group4 = this.GetCardGroupByCount(this.GetCardsGroup(handCardsTmep), 4)
            if #handCardsTmep < 4 or #group4 == 0 then
                break --为了适配 原来的上个人的逻辑
            end
    
            local lastOutMinCard = this.GetCardHash(this.GetCardGroupByCount(this.GetCardsGroup(LastOutCardsTmep), 4)[1][1])
    
            for i = 1, #group4 do
                if this.GetCardHash(group4[i][1]) > lastOutMinCard then
                    
                    local cardGroup = {}
                    for j = 1, #group4[i] do
                        table.insert(cardGroup, group4[i][j])
                    end
    
                    table.insert(ret, cardGroup)
                end
            end
    
            print('可以出的4N：'..tostring(json:encode(ret)))
        end
        break
    end

    --如果没有其他可以出的牌 那么牌型转换陈炸弹   为了适配 原来的上个人的逻辑
    if #ret == 0 then 
        if #zhaDanGroup ~= 0 then 
            category = ZHA_DA
            ret = zhaDanGroup
        else
            return {} --为了适配 原来的上个人的逻辑
        end
    end

    return isFindAll and ret or ret[1], category
end

function this.GetContinuousCards(HandCardHashTable, HandcardTable, minCard, count, cardCount, notCardHash)
    local ret = {}
    
    local CheckCount = count - 1
    print('minCard:', minCard)
    for i = 1, #HandCardHashTable - CheckCount do
        while true do 

            if HandCardHashTable[i] <= minCard or HandCardHashTable[i + CheckCount] - HandCardHashTable[i] ~= CheckCount then
                print(HandCardHashTable[i])
               break
            end

            local cardGroup = {}
            local complete = true
            for j = i, i + CheckCount do
                
                if notCardHash ~= nil and HandCardHashTable[j] == notCardHash then
                    complete = false
                    break
                end 

                if #HandcardTable[HandCardHashTable[j]] < cardCount then
                    complete = false
                    break
                end

                for k = 1, cardCount do
                    table.insert(cardGroup, HandcardTable[HandCardHashTable[j]][k])
                end

            end

            if complete then
                table.insert(ret,  cardGroup)
            end
            
            break
        end

    end

    return ret
end

--[[
    @desc: 得到所有大于最小连续的牌
    --@HandCardHashTable: 牌值
	--@HandcardTable:牌值对应的牌的数量
    --@count: 最小连续
    --@cardCount: 单张数量
    @return:
]]
function this.GetAllMinContinuousCards(HandCardHashTable, HandcardTable, count, cardCount)
    local ret = {}

    local CheckCount = count - 1
    for i = 1, #HandCardHashTable - CheckCount do
        for j = CheckCount, #HandCardHashTable - i do

            --print(HandCardHashTable[i + j], HandCardHashTable[i], j)
            if HandCardHashTable[i + j] - HandCardHashTable[i] ~= j then
                break
            end

            --print(HandCardHashTable[i + j], HandCardHashTable[i], j)
            local cardGroup = {}
            local complete = true
            for x = i, i + j do
                
                if #HandcardTable[HandCardHashTable[x]] < cardCount then
                    complete = false
                    break
                end

                for y = 1, cardCount do
                    table.insert(cardGroup, HandcardTable[HandCardHashTable[x]][y])
                end
            end

            if complete then
                table.insert(ret, cardGroup)
            end

        end
    end

    return ret
end

function this.GetMaxContinuousCards(HandCardHashTable, HandcardTable, count, cardCount)
    local cardGroups = this.GetAllMinContinuousCards(HandCardHashTable, HandcardTable, count, cardCount)

    if #cardGroups == 0 then
        return {}
    end


    table.sort(cardGroups, function (groupA, groupB) return #groupA > #groupB end)

    return cardGroups[1]
end

function this.GroupInOrderFor3n(group)
    local num = 1
    local Index = nil
    for i = 1, #group do
        if i < #group then
            if this.GetCardHash(group[i+1][1]) - this.GetCardHash(group[i][1]) == 1 then
                num = num + 1
                
                if Index == nil then
                    Index = i
                end
            end
        end
    end
    return num, Index
end

function this.GetCardsGroup(cards)
    local cardGroups={}
    local cardFlag={}
    for i=1,#cards do
        if not cardFlag[cards[i]] or cardFlag[cards[i]] == false then
            local group = {}
            table.insert(group, cards[i])
            cardFlag[cards[i]] = true
            local plateNumI = this.GetCardHash(cards[i])

            for j=i+1,#cards do
                local plateNumJ = this.GetCardHash(cards[j])
                if plateNumI == plateNumJ then
                    table.insert(group, cards[j])
                    cardFlag[cards[j]] = true 
                else
                    cardFlag[cards[j]] = false
                end
            end
            if not cardGroups[#group] then  
                cardGroups[#group] = {}
            end
            table.insert(cardGroups[#group], group)
		end
    end
    
    for i = 1, 5 do
        if cardGroups[i] == nil then
            cardGroups[i] = {}
        end
    end

	return cardGroups
end

function this.GetCardGroupByCount(cardGroup, count, isMoreThen)
    local cards = {}

    if not isMoreThen then
        cards = cardGroup[count]
    else
        for k, v in pairs(cardGroup) do
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

    table.sort(cards, function (groupA, groupB) return this.GetCardHash(groupA[1]) < this.GetCardHash(groupB[1]) end)

    return cards
end

function this.CheckCardOutRule(choseCards, handCards, lastOutCards, lastOutCategory, nextOnlyOneCard)

    if #choseCards == 0 then
        print('没有选择任何牌')
        return false 
    end

    local handCardSize = #handCards
    local choseCardsTmep = {}
    for i = 1, #choseCards do
        table.insert(choseCardsTmep, choseCards[i])
    end

    local handCardsTmep = {}
    for i=1,#handCards do
        table.insert(handCardsTmep, handCards[i])
    end

    table.sort(handCardsTmep, tableSortAsc)
    table.sort(choseCardsTmep, tableSortAsc)

    local handCategory, minCardHash, count = nil
    if #choseCardsTmep < 5 then
        handCategory,minCardHash,count = this.CheckCardOutRuleByLess5(choseCardsTmep)
    else
        handCategory,minCardHash,count = this.CheckCardOutRuleByMore5(choseCardsTmep)
    end

    if handCategory == nil then
        print("没有找到任何牌型")
        return false
    end

    if not this.CheckGameSettingCanOut(handCategory) then
        if handCategory == SI_YI then --如果牌型为4 1  可以转换为三带二
            handCategory = SAN_ER
        end
    end

    print('当前手牌的：'..tostring(handCategory)..'  上家的：'..tostring(lastOutCategory))
    if this.CheckInClearCategory(handCategory) and #choseCardsTmep ~= handCardSize then
        if handCategory == SI_YI then --如果牌型为4 1  可以转换为三带二
            print('4 1 转3 2')
            handCategory = SAN_ER
        else
            print('非净手')
            return false
        end
    end

    --要检查炸弹是不是包含在出的牌里 炸弹 四带一 四带二 四带三 不用检查
    if roomData.setting.bombSplit == false and (handCategory ~= ZHA_DA) then
        local isHaveBoom, isHaveFull = this.CheckHaveZHADAN(handCards, choseCardsTmep)
        print('炸弹检查', isHaveBoom, isHaveFull)
        if isHaveBoom then
            if (handCategory == SI_YI or handCategory == SI_ER or handCategory == SI_SAN) then
                if not isHaveFull then  print('炸弹不可拆'); return false; end
            else
                print('炸弹不可拆')
                return false
            end
        end
    end

    --下家报单必须出最大的牌
    if nextOnlyOneCard and handCategory == DAN and minCardHash ~= this.GetCardHash(handCardsTmep[#handCardsTmep]) then
        print('下家报单必须出最大的牌')
        return false
    end

    --炸弹大于其他非炸弹牌型
    if handCategory == ZHA_DA and lastOutCategory ~= ZHA_DA then
        print('炸弹大于其他非炸弹牌型')
        return true
    end

    --如果是我直接出牌
    if (lastOutCards == nil or lastOutCategory == nil) then
        print('我直接出')
        return this.CheckGameSettingCanOut(handCategory)

    elseif not this.CheckCategory(handCategory, lastOutCategory, #choseCardsTmep == handCardSize) then --我跟牌

        if handCategory == SI_YI and lastOutCategory == SAN_ER then --如果牌型为4 1  可以转换为三带二
            print('4 1 转3 2')
            handCategory = SAN_ER
        else
            print('牌型不匹配')
            return false
        end
        print('到这里了呀')
    end

    print('我的手牌牌型：', tostring(handCategory))
    if not this.CheckGameSettingCanOut(handCategory) then
        print('当前规则不能出的牌型：', tostring(handCategory))
        return false
    end

    local LastOutCardsTmep = {}
    for i = 1, #lastOutCards do
        table.insert(LastOutCardsTmep, lastOutCards[i])
    end
    
    table.sort(LastOutCardsTmep, tableSortAsc)

    local lastCardGroup = this.GetCardsGroup(LastOutCardsTmep)
    local lastCardTable, lastCardHashTable = this.GetCardHashTable(LastOutCardsTmep)

    local lastOutMinCard, lastOutcount = 1, 1
    if lastOutCategory == DAN or lastOutCategory == DUI or lastOutCategory == SAN or
        lastOutCards == ZHA_DA then
        lastOutMinCard = this.GetCardHash(LastOutCardsTmep[1]) 
    elseif lastOutCategory == SHUN then 
        lastOutcount = #LastOutCardsTmep
        lastOutMinCard = this.GetCardHash(LastOutCardsTmep[1]) 
    elseif lastOutCategory == LIAN_DUI then
        lastOutcount = #LastOutCardsTmep / 2
        lastOutMinCard = this.GetCardHash(LastOutCardsTmep[1]) 
    elseif lastOutCategory == SAN_SHUN then
        lastOutcount = #LastOutCardsTmep / 3
        lastOutMinCard = this.GetCardHash(LastOutCardsTmep[1]) 
    elseif lastOutCategory == SAN_YI or lastOutCategory == SAN_ER then
        local group3 = this.GetCardGroupByCount(lastCardGroup, 3, true)
        lastOutMinCard = this.GetCardHash(group3[1][1])
    elseif lastOutCategory == SI_YI or lastOutCategory == SI_ER or lastOutCategory == SI_SAN then
        lastOutMinCard = this.GetCardHash(lastCardGroup[4][1][1])
    elseif lastOutCategory == FEI_ER then
        local cards = this.GetMaxContinuousCards(lastCardHashTable, lastCardTable, 2, 3)
        lastOutcount = #cards / 3
        if  lastOutcount * 5 ~= #LastOutCardsTmep and (lastOutcount - 1) * 5 == #LastOutCardsTmep then
            lastOutcount = lastOutcount - 1
        end
        lastOutMinCard = this.GetCardHash(cards[1])
    elseif lastOutCategory == FEI_YI then
        local cards = this.GetMaxContinuousCards(lastCardHashTable, lastCardTable, 2, 3)
        lastOutcount = #cards / 3
        lastOutMinCard = this.GetCardHash(cards[1])
    -- elseif lastOutCategory == FEI_YI then
    --     local Continuous, Index = this.GroupInOrderFor3n(lastCardGroup[3])
    --     if #lastOutCards == 10 and #lastCardGroup[3] ~= Continuous then
    --         lastOutcount = Continuous
    --         lastOutMinCard = lastCardGroup[3][Index][1]
    --     elseif #lastCardGroup[3] == Continuous then
    --         lastOutcount =  #lastCardGroup[3]
    --         lastOutMinCard = lastCardGroup[3][1][1]
    --     end
    end

    print('当前手牌的最小：'..tostring(minCardHash)..'  上家的最小：'..tostring(lastOutMinCard))
    print('当前手牌的数量：'..tostring(count)..'  上家的数量：'..tostring(lastOutcount))

    return minCardHash > lastOutMinCard and count == lastOutcount
end

function this.CheckCardOutRuleByLess5(choseCards)

    local category = nil 
    local Count = 1
    local minCardHash = 3

    local cardGroup = this.GetCardsGroup(choseCards)
    local firstCardHash = this.GetCardHash(choseCards[1])
    local lastCardHash = this.GetCardHash(choseCards[#choseCards])
    if firstCardHash == lastCardHash then
        if #choseCards == 1 then
            category = DAN
        elseif #choseCards == 2 then
            category =  DUI
        elseif #choseCards == 3 then
            if roomData.setting.bombAAA and firstCardHash == this.GetCardHash(47) then -- AAA当炸弹
                category = ZHA_DA
            else
                category =  SAN
            end
        elseif #choseCards == 4 then
            category =  ZHA_DA
        end

        minCardHash = firstCardHash
    end
    
    if #choseCards == 4 and #this.GetCardGroupByCount(cardGroup, 3) == 1 then
        category =  SAN_YI
        minCardHash = this.GetCardHash(cardGroup[3][1][1])
    end
    
    local choseCardSize = #choseCards
    if choseCardSize / 2 >= 2 and choseCardSize % 2 == 0 and lastCardHash - firstCardHash == (choseCardSize / 2) - 1 
        and #cardGroup[2] == choseCardSize / 2
        and firstCardHash ~= this.GetCardHash(51) and lastCardHash ~= this.GetCardHash(51) then
        Count = 2
        category =  LIAN_DUI
        minCardHash = firstCardHash
    end

    return category, minCardHash, Count 
end

function this.CheckCardOutRuleByMore5(choseCards)

    local choseCardSize = #choseCards
    local cardGroup = this.GetCardsGroup(choseCards)
    local cardTable, cardHashTable =  this.GetCardHashTable(choseCards)
    
    local category = nil 
    local Count = 1
    local minCardHash = 3
    if choseCardSize == 5 and #cardGroup[3] == 1  then
        category = SAN_ER
        minCardHash = this.GetCardHash(cardGroup[3][1][1])
    elseif choseCardSize == 5 and #cardGroup[4] == 1  then
        category = SI_YI
        minCardHash = this.GetCardHash(cardGroup[4][1][1])
    elseif choseCardSize == 6 and #cardGroup[4] == 1 then
        category =  SI_ER
        minCardHash = this.GetCardHash(cardGroup[4][1][1])
    elseif choseCardSize == 7 and #cardGroup[4] == 1 then
        category = SI_SAN
        minCardHash = this.GetCardHash(cardGroup[4][1][1])
    elseif #cardGroup[1] == choseCardSize 
        and cardHashTable[#cardHashTable] - cardHashTable[1] == choseCardSize - 1 and not this.CheckContainHash(cardHashTable, this.GetCardHash(51)) then
        category = SHUN
        Count = choseCardSize
        minCardHash = cardHashTable[1]
    elseif choseCardSize / 2 >= 2 and choseCardSize % 2 == 0 
        and #cardGroup[2] == choseCardSize / 2 and cardHashTable[#cardHashTable] - cardHashTable[1] == (choseCardSize / 2) - 1 
        and not this.CheckContainHash(cardHashTable, this.GetCardHash(51)) then
        category = LIAN_DUI
        Count = #cardGroup[2]
        minCardHash = cardHashTable[1]
    else --进入 333 444 飞机判断
        -- local continuousGroup = this.GetMaxContinuousCards(cardHashTable, cardTable, 2, 3)
        -- local continuousCount = #continuousGroup / 3

        -- if continuousCount >= 2 then
        --     local firstCardHash = this.GetCardHash(continuousGroup[1])
        --     local lastCardHash = this.GetCardHash(continuousGroup[#continuousGroup])
        --     print(json:encode(continuousGroup), continuousCount, firstCardHash, lastCardHash)

        --     if choseCardSize % 3 == 0 and lastCardHash - firstCardHash == (choseCardSize / 3) - 1 then
        --         category = SAN_SHUN
        --         Count = continuousCount
        --         minCardHash = firstCardHash
        --     -- elseif continuousCount == choseCardSize / 4 and lastCardHash - firstCardHash == (choseCardSize / 4) - 1 then --这个排序跑得快没有 
        --     --     category = FEI_YI
        --     --     minCardHash = firstCardHash
        --     elseif continuousCount == choseCardSize / 5 and lastCardHash - firstCardHash == (choseCardSize / 5) - 1 then
        --         category = FEI_ER
        --         Count = continuousCount
        --         minCardHash = firstCardHash
        --     else -- 未带满牌的飞机
        --         --local continuousGroup = this.GetMaxContinuousCards(cardHashTable, cardTable, 2, 3)
        --         if (continuousCount - 1) * 5 == choseCardSize and choseCardSize == 10 then -- 333 444 555 1
        --             category = FEI_ER
        --             Count = continuousCount - 1
        --             minCardHash = this.GetCardHash(continuousGroup[1])
        --         elseif continuousCount * 2 > (choseCardSize - (continuousCount * 3)) then
        --             category = FEI_YI
        --             Count = continuousCount
        --             minCardHash = this.GetCardHash(continuousGroup[1])
        --         end
        --     end
        -- end

        category, minCardHash, Count = this.Check3n1Cards(cardTable, cardHashTable, choseCardSize)

    end

    return category, minCardHash, Count
end 

function this.CheckCategory(categoryA, categoryB, isClearHand)

    local categorys = {}
    categorys[DAN] = 1
    categorys[DUI] = 2
    categorys[SAN] = 3
    categorys[SAN_YI] = 3
    categorys[SAN_ER] = 3
    categorys[SHUN] = 4
    categorys[LIAN_DUI] = 5
    categorys[SAN_SHUN] = 6
    categorys[FEI_YI] = 7
    categorys[FEI_ER] = 7
    categorys[ZHA_DA] = 8
    categorys[SI_YI] = 9
    categorys[SI_ER] = 9
    categorys[SI_SAN] = 9

    if categorys[categoryA] == categorys[categoryB] then
        --print(tostring(not isClearHand), tostring((categoryA == SI_ER or categoryA == SI_YI)))
        if not isClearHand and (categoryA == SI_ER or categoryA == SI_YI) and categoryA ~= categoryB then
            return false
        end

        return true
    else
        return false
    end
end

function this.CheckInClearCategory(category)
    local categorys = {}
    categorys[SAN_YI] = true
    categorys[SAN] = true
    categorys[SI_YI] = true

    if roomData.setting.bombBeltTwo == false then
        categorys[SI_ER] = true
    end

    categorys[SAN_SHUN] = true
    categorys[FEI_YI] = true

    return categorys[category] == true
end

function this.CheckGameSettingCanOut(category)
    if roomData.setting.bombBelt == false and roomData.setting.bombBeltTwo == false then
        if category == SI_YI or category == SI_ER or category == SI_SAN then
            return false
        end
    elseif roomData.setting.bombBelt == false then
        if category == SI_SAN then
            return false
        end
    elseif roomData.setting.bombBeltTwo == false then
        if category == SI_ER then
            return roomData.setting.bombBelt == true
        end
    end

    return true
end

--检查是不是包含某个值
function this.CheckContainHash(cardHashTable, card)
    for i = 1, #cardHashTable do
        if cardHashTable[i] == card then
            return true
        end
    end

    return false
end

--检查是不是包含某个值
function this.CheckContainCard(cards, card)
    local cardHash = this.GetCardHash(card)
    for i = 1, #cards do
        if this.GetCardHash(cards) == cardHash then
            return true
        end
    end

    return false
end

function this.Check3n1Cards(cardTable, cardHashTable, cardCount)
    local continuousGroup = this.GetMaxContinuousCards(cardHashTable, cardTable, 2, 3)
    local continuousCount = #continuousGroup / 3

    if continuousCount == 0 then
        return nil, nil, nil
    end

    local firstCardHash = this.GetCardHash(continuousGroup[1])
    local lastCardHash = this.GetCardHash(continuousGroup[#continuousGroup])

    local category = nil
    local count = nil 
    local minCardHash = nil
    if cardCount % 3 == 0 and lastCardHash - firstCardHash == (cardCount / 3) - 1 then
        category = SAN_SHUN
        count = continuousCount
        minCardHash = this.GetCardHash(continuousGroup[1])
    elseif continuousCount == cardCount / 5 and lastCardHash - firstCardHash == (cardCount / 5) - 1 then
        category = FEI_ER
        count = continuousCount
        minCardHash = this.GetCardHash(continuousGroup[1])
    elseif continuousCount * 5 ~= cardCount and (continuousCount - 1) * 5 == cardCount then
        category = FEI_ER
        count = continuousCount - 1
        minCardHash = this.GetCardHash(continuousGroup[1])
    elseif cardCount - continuousCount * 3 < continuousCount * 2 then
        category = FEI_YI
        count = continuousCount
        minCardHash = this.GetCardHash(continuousGroup[1])
    end

    return category, minCardHash, count
end

function this.CheckHaveZHADAN(handCards, choseCards)
    local zhaDanGroup = this.FindCanPlayCard(handCards, {-100, -100, -100, -100}, ZHA_DA, true)
    local cardTable, cardHashTable = this.GetCardHashTable(choseCards)
    print(json:encode(zhaDanGroup))
    local isHaveBoom = false
    local isHaveFull = true;
    for i = 1, #zhaDanGroup do
        if this.CheckContainHash(cardHashTable, this.GetCardHash(zhaDanGroup[i][1])) 
            and this.GetCardHash(zhaDanGroup[i][1]) ~= this.GetCardHash(47) then
            --and #cardTable[this.GetCardHash(zhaDanGroup[i][1])] ~= #zhaDanGroup[i] then
            isHaveBoom = true  
            if isHaveFull then
                print(#cardTable[this.GetCardHash(zhaDanGroup[i][1])], #zhaDanGroup[i])
                isHaveFull = #cardTable[this.GetCardHash(zhaDanGroup[i][1])] == #zhaDanGroup[i]
            end
        end
    end

    return isHaveBoom, isHaveFull
end

DAN=0        --单牌
DUI=1        --对子
SAN=2        --三不带
SAN_YI=3     --三带一
SAN_ER=4     --三带二
SHUN=5       --顺子
LIAN_DUI=6   --连对，点数相连的2个及以上的对子
SAN_SHUN=7   --三顺，点数相连的2个及以上的3同张
FEI_YI=8     --飞机带一张
FEI_ER=9     --飞机带两张
ZHA_DA=10     --炸弹
SI = 11
SI_YI = 12
SI_ER = 13
SI_SAN = 14
--    SI_SHUN,    // 四顺，点数相连的2个及以上的4同张      没有这副牌型
--    SI_FEI_ER,  // 四顺飞机 除四带三牌型之外的所有特殊牌型   没有这副牌型
--    SI_FEI_SAN, // 四顺飞机 带 三张    没有这副牌型