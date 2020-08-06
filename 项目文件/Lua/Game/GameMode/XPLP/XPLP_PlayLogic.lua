xplp_pb = require("xplp_pb");
XPLP_PlayLogic = {};
local this = XPLP_PlayLogic;


--是否需要显示东南西北方位展示的UI
function this.NeedShowDiPai(roomData,logic)
	if roomData.state == xplp_pb.GAMING then--如果正在游戏中，
		return true;
	else
		if roomData.state == xplp_pb.READYING then--如果是准备状态
			if roomData.round > 1 then --之前刚刚打完一局，进入下一句的等待中
				return true;
			else--刚刚加入房间的起始局,并且还在准备中，肯定不需要显示的
				return false;
			end
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
		if operations[i].operation == xplp_pb.CHI then 
			local chiOpTable,chiRelevantTable = this.FindAllChiPlates(handMahjongs,operations[i].mahjongs);
			tableAdd(relevantOpTable,chiOpTable);
			tableAdd(relevantTable,chiRelevantTable);
		elseif operations[i].operation == xplp_pb.PENG then 
			local pengOpTable,pengRelevantTable = this.FindAllPengPlates(handMahjongs,operations[i].mahjongs);
			tableAdd(relevantOpTable,pengOpTable);
			tableAdd(relevantTable,pengRelevantTable);
		elseif operations[i].operation == xplp_pb.GANG or operations[i].operation == xplp_pb.BU then 
			-- print("path--------------------->xplp_pb.GANG");
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
	for i=1,#plates,3 do
		table.insert( canChiTable, {type = xplp_pb.CHI,mahjong = plates[i],mahjongs = {plates[i],plates[i+1],plates[i+2]}} );
		table.insert( relevantPlates, plates[i+1]);
		table.insert( relevantPlates, plates[i+2]);
	end
	return canChiTable, relevantPlates;
end

--根据提供的牌，找出所有碰相关的牌
function this.FindAllPengPlates(handMahjongs,plates)
	local canPenTable = {};
	local relevantPlates = {};
	for i=1,#plates do
		table.insert( canPenTable, {type = xplp_pb.PENG,mahjong = plates[i],mahjongs={plates[i],plates[i],plates[i]}} );
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
			-- print("path--------->3,operation_type == xplp_pb.SORT_PENG:"..tostring(operation_type == xplp_pb.SORT_PENG)..",plates[i] == op_cards[1]:"..tostring(plates[i] == op_cards[1])..",(op_type == xplp_pb.GANG:"..tostring(op_type == xplp_pb.GANG)..",(op_type == xplp_pb.BU:"..tostring(op_type == xplp_pb.BU));
			--这里解释一下，(operation_type == xplp_pb.SORT_PENG and plates[i] == op_cards[1]) 表示必须要从碰牌里面去选，碰牌才能
			--杠或者补，(op_type == xplp_pb.GANG or op_type == xplp_pb.BU)表示必须是补和杠才能这样做
			if (operation_type == xplp_pb.SORT_PENG and plates[i] == op_cards[1]) and (op_type == xplp_pb.GANG or op_type == xplp_pb.BU)   then 
				
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
	if op == xplp_pb.GUO then
		opstring = "过";
	elseif op == xplp_pb.CHI then
		opstring = "吃";
	elseif op == xplp_pb.PENG then
		opstring = "碰";
	elseif op == xplp_pb.BU then
		opstring = "补";
	elseif op == xplp_pb.GANG then
		opstring = "杠";
	elseif op == xplp_pb.HU then
		opstring = "胡";
	elseif op == xplp_pb.LAO then
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
	for secdex = 1, logic.totalSize do
		local pData = logic:GetPlayerDataByUIIdex(secdex);
		if pData then
			--别人已经打出的牌
			--print("paiHe.length:"..(#pData.paiHe));
			countOther = countOther + GetMJPlateCount(pData.paiHe,plate);
			--手上的吃碰牌
			local countCP = 0;
			for i = 1, #pData.operationCards do
				local operation_type = pData.operationCards[i].operation;
				local op_cards = pData.operationCards[i].cards;
				if operation_type == xplp_pb.SORT_CHI then
					countCP = countCP + GetMJPlateCount({op_cards[1] , op_cards[2], op_cards[3]},plate);
				elseif operation_type == xplp_pb.SORT_PENG then
					countCP = countCP + GetMJPlateCount({op_cards[1]},plate)*3;
				end
			end
			countOther = countOther + countCP;
		else
			print("player wrong data,can't count number of plates!");
			return -1;
		end
	end
	local countTotal = 0;
	countTotal = (4- countInHand -countOther-countMo);
	return countTotal;
end


--查看剩余牌的时候，对于打出去的牌进行检查，当检查到该牌的时候，对它做一个高亮的标记
function this.CheckPlateState(plate, showColor,uiLayer,logic)
	local gameUIObjects = uiLayer:GetgameUIObjects();
	for firdex = 1, logic.totalSize do
		local playerView = gameUIObjects.playerViews[logic:GetCorrectUIIndex(logic:GetPlayerViewIndexBySeat(logic:GetPlayerDataByUIIdex(firdex).seat))];
		if playerView.xplp_GridTool.gridThrow.childCount > 0 then
			for secdex = 1, playerView.xplp_GridTool.gridThrow.childCount do
				local throwItem = playerView.xplp_GridTool.gridThrow:GetChild(secdex-1);
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


