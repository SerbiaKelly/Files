local json = require 'json'

function SplitIntoGroups(plates, use1510, useJiaoPai,useTi,useKan)
	
	table.sort(plates, tableSortAsc)
	local dicPlates = {}
	for i = 1, #plates do
		if not dicPlates[plates[i]] then
			dicPlates[plates[i]] = 1
		else
			dicPlates[plates[i]] = dicPlates[plates[i]] + 1
		end
	end

	local DebugStr = ""
	for key, value in pairs(dicPlates) do
		DebugStr = DebugStr..'"'..json:encode(key)..'":'..json:encode(value).."|"
	end
	--print("牌的数量类型："..DebugStr)

	local TiGroup = {}
	local KanGroup = {}
	for key, value in pairs(dicPlates) do
		if value == 4 then
			local group = {}
			for i = 1, 4 do
				table.insert(group, key)
			end
			--group.lock = true
			dicPlates[key] = 0
			table.insert(TiGroup,group)
		elseif value == 3 then
			local group = {}
			for i = 1, 3 do
				table.insert(group, key)
			end
			--group.lock = true
			dicPlates[key] = 0
			table.insert(KanGroup, group)
		end
	end
	-- print("提牌："..json:encode(TiGroup))
	-- print("坎牌："..json:encode(KanGroup))

	-- local DebugStr = ""
	-- for key, value in pairs(dicPlates) do
	-- 	DebugStr = DebugStr..'"'..json:encode(key)..'":'..json:encode(value).."|"
	-- end
	-- print("取提喂后的牌的数量类型："..DebugStr)

	local GroupDui = {}
	for key, value in pairs(dicPlates) do
		if value == 2 then
			local group = {}
			table.insert(group, key)
			table.insert(group, key)
			table.insert(GroupDui, group)
			dicPlates[key] = 0
		end
	end
	
	local Group2710, GroupBig2710,Group123, GroupBig123,Group1510, GroupBig1510  = SplitSingle123And2710(dicPlates,use1510)
	--print("大123："..json:encode(GroupBig123).."，小123："..json:encode(Group123))
	--print("大2710："..json:encode(GroupBig2710).."，小2710："..json:encode(Group2710))
	--print("大1510："..json:encode(GroupBig1510).."，小1510："..json:encode(Group1510))
	--local DebugStr = ""
	--for key, value in pairs(dicPlates) do
	--	DebugStr = DebugStr..'"'..json:encode(key)..'":'..json:encode(value).."|"
	--end
	--print("取有息句子的牌的数量类型："..DebugStr)

	local GroupJu = SplitSingleJuhuai(dicPlates)
	-- print("句子："..json:encode(GroupJu))
	-- local DebugStr = ""
	-- for key, value in pairs(dicPlates) do
	-- 	DebugStr = DebugStr..'"'..json:encode(key)..'":'..json:encode(value).."|"
	-- end
	-- print("取句子的牌的数量类型："..DebugStr)

	local GroupJiao = {}
	if useJiaoPai then
		for i = #GroupDui, 1, -1 do
			local plate = GroupDui[i][1]
			for key, value in pairs(dicPlates) do
				if value ~= 0 then
					local needPalte = -1
					if plate < 10 then
						needPalte = plate + 10
					else
						needPalte = plate - 10
					end
					if needPalte == key then
						local group = {}
						table.insert(group, key)
						table.insert(group, GroupDui[i][1])
						table.insert(group, GroupDui[i][2])
						table.remove(GroupDui, i)
						table.insert(GroupJiao, group)
						dicPlates[key] = dicPlates[key] - 1
					end
				end
			end
		end
	end
	
	-- print("绞牌："..json:encode(GroupJiao))
	-- print("对子："..json:encode(GroupDui))
	-- local DebugStr = ""
	-- for key, value in pairs(dicPlates) do
	-- 	DebugStr = DebugStr..'"'..json:encode(key)..'":'..json:encode(value).."|"
	-- end
	-- print("取对子和绞牌的牌的数量类型："..DebugStr)

	local GroupHalfJu = SplitSingleJuhuaiHalfWork(dicPlates)
	-- print("半句话："..json:encode(GroupHalfJu))
	-- local DebugStr = ""
	-- for key, value in pairs(dicPlates) do
	-- 	DebugStr = DebugStr..'"'..json:encode(key)..'":'..json:encode(value).."|"
	-- end
	--print("取取半句话后牌的数量类型："..DebugStr)

	local GroupDan = {}
	for key, value in pairs(dicPlates) do
		if value == 1 then
			table.insert(GroupDan, {key})
			dicPlates[key] = dicPlates[key] - 1
		end
	end
	--print("单："..json:encode(GroupDan))
	local DebugStr = ""
	for key, value in pairs(dicPlates) do
	 	DebugStr = DebugStr..'"'..json:encode(key)..'":'..json:encode(value).."|"
	end
	--print("取单后牌的数量类型："..DebugStr)
	

	local finalGroup = {}
	--提
	for i=1,#TiGroup do
		if useTi then
			TiGroup[i].lock = true
		end
		table.insert(finalGroup, TiGroup[i])
		--print('group4:'..group4[i][1])
	end
	
	--坎
	for i=1,#KanGroup do
		if useKan then
			KanGroup[i].lock = true
		end
		table.insert(finalGroup, KanGroup[i])
		--print('group3:'..group3[i][1])
	end

	for i = 1, #GroupBig2710 do
		table.sort(GroupBig2710[i], tableSortDesc)
		table.insert(finalGroup, GroupBig2710[i])
	end

	for i=1, #GroupBig123 do
		table.sort(GroupBig123[i], tableSortDesc)
		table.insert(finalGroup, GroupBig123[i])
	end

	for i=1, #GroupBig1510 do
		table.sort(GroupBig1510[i], tableSortDesc)
		table.insert(finalGroup, GroupBig1510[i])
	end
	
	for i=1, #Group123 do
		table.sort(Group123[i], tableSortDesc)
		table.insert(finalGroup, Group123[i])
	end

	for i = 1, #Group2710 do
		table.sort(Group2710[i], tableSortDesc)
		table.insert(finalGroup, Group2710[i])
	end
	
	for i = 1, #Group1510 do
		table.sort(Group1510[i], tableSortDesc)
		table.insert(finalGroup, Group1510[i])
	end

	for i = 1, #GroupJu do
		table.sort(GroupJu[i], tableSortDesc)
		table.insert(finalGroup, GroupJu[i])
	end

	for i = 1, #GroupDui do
		table.insert(finalGroup, GroupDui[i])
	end

	for i = #GroupJiao, 1, -1 do
		table.insert(finalGroup, GroupJiao[i])
	end

	for i = 1, #GroupHalfJu do
		table.sort(GroupHalfJu[i], tableSortDesc)
		table.insert(finalGroup, GroupHalfJu[i])
	end

	for i = 1, #GroupDan do
		table.insert(finalGroup, GroupDan[i])
	end
	
	--防止溢出
	for i=0,#GroupDan-1 do
		if #finalGroup-11 <= 0 then
			break
		end
		table.insert(finalGroup[11-i], 1, finalGroup[#finalGroup][1])
		table.remove(finalGroup,#finalGroup)
	end
	--print("排序前牌型："..json:encode(finalGroup))


	local sort = function (cardGroup, callBack)
		for i = 1, #cardGroup do
			for j = 1, #cardGroup - i do
				if callBack(cardGroup[j], cardGroup[j + 1]) then
					local temp = cardGroup[j]
					cardGroup[j] = cardGroup[j + 1]
					cardGroup[j + 1] = temp
				end
			end
		end
	end
	

	sort(finalGroup, function(a, b) return a[#a] > b[#b] end)

	sort(finalGroup, function(a, b) return a[#a] % 10 > b[#b] % 10 end)
	
	--print("排序后牌型："..json:encode(finalGroup))

	return finalGroup
end

function is_include(value, tab)
    for k,v in ipairs(tab) do
      if v == value then
          return true
      end
    end
    return false
end

--group3：大小2710 123 1510
--plates: 剩下的牌
function SplitSingle123And2710(dicPlates,use1510)
	
	local groupBig123 = {}
	local groupBig2710 = {}
	local groupBig1510 = {}
	groupBig123 = SplitSingle123And2710Work({10,11,12}, dicPlates)
	groupBig2710 = SplitSingle123And2710Work({11,16,19}, dicPlates)
	if use1510 then
		groupBig1510 = SplitSingle123And2710Work({10,14,19}, dicPlates)
	end
	
	local group123 = {}
	local group2710 = {}
	local group1510 = {}
	group123 = SplitSingle123And2710Work({0,1,2},dicPlates)
	group2710 = SplitSingle123And2710Work({1,6,9},dicPlates)
	if use1510 then
		group1510 = SplitSingle123And2710Work({0,4,9},dicPlates)
	end

	return group2710, groupBig2710, group123, groupBig123, group1510, groupBig1510
end

function SplitSingle123And2710Work(groupPlates, dicPlates)
	local GroupJu = {}
	local Index = -1
	for i=1,#groupPlates do
		if dicPlates[groupPlates[i]] ~= nil and dicPlates[groupPlates[i]] >= 1 then
			if Index == -1 then Index = i end
			if i - Index == #groupPlates - 1 then
				local minCount = 10
				for j = Index, i do
					if minCount > dicPlates[groupPlates[j]] then
						minCount = dicPlates[groupPlates[j]]
					end
				end
				for j = 1, minCount do
					local group = {}
					for z = Index, i do
						dicPlates[groupPlates[z]] = dicPlates[groupPlates[z]] -1
						table.insert(group, groupPlates[z])
					end
					table.insert(GroupJu, group)
				end
				Index = -1
			end
		else
			Index = -1
		end
	end

	return GroupJu
end

--group3：一句话
--plates: 剩下的牌
function SplitSingleJuhuai(dicPlates)
	
	local GroupJu = {}
	for i = 0, 7 do
		local group = SplitSingleJuhuaiWork(i, 2, dicPlates)
		if group ~= nil and #group ~= 0 then
			for j = 1, #group do
				table.insert(GroupJu, group[j])
			end
		end
	end

	for i = 10, 17 do
		local group = SplitSingleJuhuaiWork(i, 2, dicPlates)
		if group ~= nil and #group ~= 0 then
			for j = 1, #group do
				table.insert(GroupJu, group[j])
			end
		end
	end

	return GroupJu
end

function SplitSingleJuhuaiWork(index, count, dicPlates)

	local GroupJu = {}
	if dicPlates[index] == nil and dicPlates[index] == 0 then
		return nil
	end

	local minCount = 4
	for i = index, index + count do
		if dicPlates[i] == nil or dicPlates[i] < 1 then
			return GroupJu
		elseif minCount > dicPlates[i] then 
			minCount = dicPlates[i]
		end
	end
	
	for j = 1, minCount do
		local group = {}
		for i = index, index + count do
			dicPlates[i] = dicPlates[i] -1
			table.insert(group, i)
		end
		table.insert(GroupJu, group)
	end

	return GroupJu
end

function SplitSingleJuhuaiHalfWork(dicPlates)
	local GroupHalfJu = {}

	local GroupTT = {{1,6},{1,9},{6,9},{11,16},{11,19},{16,19}}
	for i = 1, #GroupTT do
		local group = SplitSingle123And2710Work(GroupTT[i], dicPlates)
		if group ~= nil and #group ~= 0  then
			 for i = 1, #group do
				table.insert(GroupHalfJu, group[i])
				print("2710："..json:encode(group))
			 end
		 end
	end

	-- local DebugStr = ""
	-- for key, value in pairs(dicPlates) do
	-- 	DebugStr = DebugStr..'"'..json:encode(key)..'":'..json:encode(value).."|"
	-- end
	-- print("牌的数量类型："..DebugStr)

	for key, value in pairs(dicPlates) do
		if (value >= 1)  then
			for i = 1, 2 do
				if (dicPlates[key + i] ~= nil and dicPlates[key + i] >= 1) and math.modf((key) / 10) == math.modf((key + i) / 10) then
					local group = {}
					table.insert(group, key)
					table.insert(group, key + i)
					dicPlates[key] = dicPlates[key] - 1
					dicPlates[key + i] = dicPlates[key + i] - 1
					table.insert(GroupHalfJu, group)
					break
				end
			end
		end
	end

	for key, value in pairs(dicPlates) do
		if value ~= 0 then
			if dicPlates[key + 10] ~= nil and dicPlates[key + 10] ~=0  then
				local group = {}
				table.insert(group, key)
				table.insert(group, key + 10)
				dicPlates[key] = dicPlates[key] - 1
				dicPlates[key + 10] = dicPlates[key + 10] - 1
				table.insert(GroupHalfJu, group)
			end
		end
	end

	-- for key, value in pairs(dicPlates) do
	-- 	if (value >= 1)  then
	-- 		for i = 1, 5 do
	-- 			if (dicPlates[key + i] ~= nil and dicPlates[key + i] >= 1) and math.modf((key) / 10) == math.modf((key + i) / 10) then
	-- 				local group = {}
	-- 				table.insert(group, key)
	-- 				table.insert(group, key + i)
	-- 				dicPlates[key] = dicPlates[key] - 1
	-- 				dicPlates[key + i] = dicPlates[key + i] - 1
	-- 				table.insert(GroupHalfJu, group)
	-- 				break
	-- 			end
	-- 		end
	-- 	end
	-- end
	
	return GroupHalfJu
end

--判断字符长度是否达到限制
function charachterIsLimit(str, limitLen)
    local len = string.len(str)
	local strLength = 0
    while str do
        local fontUTF = string.byte(str,1)
        if fontUTF == nil then
            break
        end
        if fontUTF > 127 then 
            local tmp = string.sub(str,1,3)
            strLength = strLength+2
            str = string.sub(str,4,len)
        else
            local tmp = string.sub(str,1,1)
            strLength = strLength+1
            str = string.sub(str,2,len)
        end
    end
	return strLength>limitLen
end