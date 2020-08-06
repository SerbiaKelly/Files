hnm_pb 			= require("hnm_pb");
HNZZM_PlayLogic = {};
local this 		= HNZZM_PlayLogic;


--是否需要显示东南西北方位展示的UI
function this.NeedShowDiPai(roomData,logic)
    if roomData.state == hnm_pb.GAMING then--如果正在游戏中，那么肯定是要显示
		return true;
	else
		if roomData.state == hnm_pb.READYING then--如果是准备状态
			if roomData.round > 1 then --之前刚刚打完一局，进入下一句的等待中
				return true;
			else--刚刚加入房间的起始局

				local myData = logic:GetPlayerDataBySeat(logic.mySeat);
				if logic:GetPlayerDataLength() == roomData.setting.size and logic:IsAllReaded() then
					--如果有勾选跑分
					if roomData.setting.selectPao == -1 then 
						return logic:IsRunScoreFinished();
					else
						return true;
					end
					
				else
					return false;
				end
			end
		else
			return false;
		end
	end
end


--获得吃碰杠补相关的牌
function this.GetRelevantPlates(operations,handMahjongs,operationCards)
	-- print("GetRelevantPlates,operations.length="..#operations..",handMahjongs.length="..#handMahjongs..",operationCards.length="..#operationCards)
	local relevantTable = {};
	local relevantOpTable = {};
	local relevantPlates = {};
	for i=1,#operations do
		if operations[i].operation == hnm_pb.CHI then 
			local chiOpTable,chiRelevantTable = this.FindAllChiPlates(handMahjongs,operations[i].mahjongs);
			tableAdd(relevantOpTable,chiOpTable);
			tableAdd(relevantTable,chiRelevantTable);
		elseif operations[i].operation == hnm_pb.PENG then 
			local pengOpTable,pengRelevantTable = this.FindAllPengPlates(handMahjongs,operations[i].mahjongs);
			tableAdd(relevantOpTable,pengOpTable);
			tableAdd(relevantTable,pengRelevantTable);
		elseif operations[i].operation == hnm_pb.GANG or operations[i].operation == hnm_pb.BU then 
			-- print("path--------------------->hnm_pb.GANG");
			local buGangOpTable,buGangRelevantTable = this.FindAllBuGangPlates(handMahjongs,operations[i].mahjongs,operations[i].operation,operationCards);
			tableAdd(relevantOpTable,buGangOpTable);
			tableAdd(relevantTable,buGangRelevantTable);
		end
	end

	for i=1,#relevantTable do
		if not relevantPlates[relevantTable[i]] then 
			relevantPlates[relevantTable[i]] = relevantTable[i];
		end
	end

	-- print("relevantOpTable");
	-- print_r(relevantOpTable);
	-- print("relevantPlates");
	-- print_r(relevantPlates);


	return relevantOpTable,relevantPlates;
end

--根据提供的牌，找出所有吃相关的牌，比如服务器告诉你5万可以吃，那么3万，4万，6万，7万都应该找出来
function this.FindAllChiPlates(handMahjongs,plates)
	local canChiTable = {};
	local relevantPlates = {};
	for i=1,#handMahjongs do
		local needChiPlates = {};
		local plateGroup = getIntPart(plates[i]/9);
		local checkPlate = plates[i];
		for j=1,#handMahjongs do
			local handCheckPlate = handMahjongs[j];
			--把可以吃的牌全都找出来，不管连续与否
			if plateGroup == getIntPart(handCheckPlate/9) and (handCheckPlate >= checkPlate-1 and handCheckPlate<=checkPlate+2) then 
				table.insert( needChiPlates, handCheckPlate );
			end
		end
		table.insert( needChiPlates, checkPlate );--把操作的牌也放进去
		tableRemoveSameEle(needChiPlates,1);--删掉重复的，每个牌只留一张
		table.sort(needChiPlates, tableSortAsc)--由大到小排序
		
		for i=1,#needChiPlates do
			if i+2 <= #needChiPlates and needChiPlates[i+2]-needChiPlates[i] == 2 then --连续，表示可以吃牌
				table.insert( canChiTable, {type = hnm_pb.CHI,mahjong = checkPlate,mahjongs = {needChiPlates[i],needChiPlates[i+1],needChiPlates[i+1]}} );
				for j=i,i+2 do
					if needChiPlates[j] ~= checkPlate then 
						table.insert( relevantPlates, needChiPlates[j] );
					end
				end
			end
		end

	end

	return canChiTable, relevantPlates;
end

--根据提供的牌，找出所有碰相关的牌
function this.FindAllPengPlates(handMahjongs,plates)
	local canPenTable = {};
	local relevantPlates = {};
	for i=1,#plates do
		table.insert( canPenTable, {type = hnm_pb.PENG,mahjong = plates[i],mahjongs={plates[i],plates[i],plates[i]}} );
		for j=1,2 do
			table.insert( relevantPlates, plates[i] );
		end	
	end
	return canPenTable,relevantPlates;
end
--根据提供的牌，找出所有杠补相关的牌
function this.FindAllBuGangPlates(handMahjongs,plates,op_type,operationCards)
	-- print("FindAllBuGangPlates,plates.length:"..#plates,",handMahjongs.length:"..#handMahjongs);
	local canGangTable = {};
	local relevantPlates = {};
	--1.首先再手牌里面找
	for i=1,#plates do
		local count = 0;
		for j=1,#handMahjongs do
			-- print("campare,plate="..plates[i]..",handMahjong="..handMahjongs[j]);
			if plates[i] == handMahjongs[j] then 
				count = count + 1;
			end
		end
		if count >= 3 then --说明手上有可以杠或者补的牌
			-- print("path------------->2.count="..count);
			table.insert( canGangTable, {type = op_type,mahjong = plates[i],mahjongs = {plates[i],plates[i],plates[i],plates[i]}} );
			for k=1,3 do
				table.insert(relevantPlates,plates[i]);
			end
		end
	end
	--2.再玩家已经碰的牌里面去找,只不过，这里面找的，就没有相关的牌了，因为不用在手牌上标记
	for i=1,#plates do
		for j=1,#operationCards do
			
			local operation_type = operationCards[j].operation;
			local op_cards = operationCards[j].cards;
			-- print("path--------->3,operation_type == hnm_pb.SORT_PENG:"..tostring(operation_type == hnm_pb.SORT_PENG)..",plates[i] == op_cards[1]:"..tostring(plates[i] == op_cards[1])..",(op_type == hnm_pb.GANG:"..tostring(op_type == hnm_pb.GANG)..",(op_type == hnm_pb.BU:"..tostring(op_type == hnm_pb.BU));
			--这里解释一下，(operation_type == hnm_pb.SORT_PENG and plates[i] == op_cards[1]) 表示必须要从碰牌里面去选，碰牌才能
			--杠或者补，(op_type == hnm_pb.GANG or op_type == hnm_pb.BU)表示必须是补和杠才能这样做
			if (operation_type == hnm_pb.SORT_PENG and plates[i] == op_cards[1]) and (op_type == hnm_pb.GANG or op_type == hnm_pb.BU)   then 
				
				table.insert(canGangTable, {type = op_type, mahjong = plates[i], mahjongs = {plates[i], plates[i], plates[i], plates[i]}});
			end
		end
	end
	
	return canGangTable,relevantPlates;
end

--获得操作对应的牌
function this.GetOpeartionPlates(operations,op_type)
	for i=1,#operations do
		if operations[i].operation == op_type then 
			return operations[i].mahjongs;
		end
	end
	print("GetOpeartionPlates cann't find relevant plates!!!!!!!!!!!!!!!!!");
	return nil;
end

--
function this.FilterOp()

end

function this.PrintOP(op)
	local opstring = "";
	if op == hnm_pb.GUO then
		opstring = "过";
	elseif op == hnm_pb.CHI then
		opstring = "吃";
	elseif op == hnm_pb.PENG then
		opstring = "碰";
	elseif op == hnm_pb.BU then
		opstring = "补";
	elseif op == hnm_pb.GANG then
		opstring = "杠";
	elseif op == hnm_pb.HU then
		opstring = "胡";
	elseif op == hnm_pb.LAO then
		opstring = "捞";
	else
		opstring = "未知操作类型";
	end
	print("current operation:"..opstring);
end


--获得操作以及对应的牌，并且返回特定的数据结构，吃牌的时候需要用
function this.GetOperation_platesPairs(operations,op_type,playerData)

end


--获取听牌数量
function this.GetTingPaiCount(plate,logic,uiLayer)
	--自己手上的牌
	local myData = logic:GetPlayerDataBySeat(logic.mySeat);
	local countInHand = GetMJPlateCount(myData.mahjongs,plate);

	--手上摸的牌
	local countMo = 0;
	if logic.roomData.activeSeat == logic.mySeat then
		countMo = GetMJPlateCount({logic:GetPlayerDataBySeat(logic.mySeat).moMahjong},plate);
	end
	-- print("countMo:"..countMo);
	local countOther = 0;
	--print("playerData.length:"..(#playerData));
	--print("playerSize:"..playerSize);
	for secdex = 1, logic.totalSize do
		local pData = logic:GetPlayerDataByUIIdex(secdex);
		if pData then
			--别人已经打出的牌
			--print("paiHe.length:"..(#pData.paiHe));
			countOther = countOther + GetMJPlateCount(pData.paiHe,plate);
			--手上的吃碰杠牌
			local countCPG = 0;

			for i = 1, #pData.operationCards do
				local operation_type = pData.operationCards[i].operation;
				local op_cards = pData.operationCards[i].cards;
				if operation_type == hnm_pb.SORT_CHI then
					countCPG = countCPG + GetMJPlateCount({op_cards[1] , op_cards[2], op_cards[3]},plate);
				elseif operation_type == hnm_pb.SORT_PENG then
					countCPG = countCPG + GetMJPlateCount({op_cards[1]},plate)*3;
				elseif operation_type == hnm_pb.SORT_MING then
					countCPG = countCPG + GetMJPlateCount({op_cards[1]},plate)*4;
				elseif operation_type == hnm_pb.SORT_DARK then
					countCPG = countCPG + GetMJPlateCount({op_cards[1]},plate)*4;
				elseif operation_type == hnm_pb.SORT_DIAN then
					countCPG = countCPG + GetMJPlateCount({op_cards[1]},plate)*4;
				end
			end

			countOther = countOther + countCPG;
		else
			print("player wrong data,can't count number of plates!");
			return -1;
		end
	end

	local countTotal = 0;
	if logic.roomData.setting.roomTypeValue == proxy_pb.HZM and plate == HongzhongPlateValue then
		countTotal = logic.roomData.setting.hongZhongCount - countInHand - countOther - countMo;
	else
		countTotal = (4- countInHand -countOther-countMo);
	end
	return countTotal;
end


--检查该牌的状态，打出去多少，手上又多少，杠牌又有哪些
function this.CheckPlateState(plate, showColor,uiLayer,logic)
	local gameUIObjects = uiLayer:GetgameUIObjects();
	for firdex = 1, logic.totalSize do
		local playerView = gameUIObjects.playerViews[logic:GetCorrectUIIndex(logic:GetPlayerViewIndexBySeat(logic:GetPlayerDataByUIIdex(firdex).seat))];
		if playerView.hnzzm_GridTool.gridThrow.childCount > 0 then
			for secdex = 1, playerView.hnzzm_GridTool.gridThrow.childCount do
				local throwItem = playerView.hnzzm_GridTool.gridThrow:GetChild(secdex-1);
				if throwItem.gameObject.activeSelf then
					local itemPlate = GetUserData(throwItem.gameObject);
					if itemPlate == plate then
						uiLayer:SetPlateColor(throwItem,showColor);
					end
				end
			end
		else
			break;
		end
	end
end


