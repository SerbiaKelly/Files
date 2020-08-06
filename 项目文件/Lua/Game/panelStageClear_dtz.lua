local dtz_pb = require 'dtz_pb'
local proxy_pb = require "proxy_pb"
require "Lua.Game.GameLogic.dtz_Logic"

panelStageClear_dtz = {}
local this = panelStageClear_dtz

local message
local gameObject

local mask
local names					= {}
local userids 				= {};
local icons					= {}
local medalIcons			= {}
local groups 				= {}
local beClosed 				= {}
local catchScores 			= {}
local XiTotals 				= {}
local restCardGrid			= {}
local restCardScrollViews 	= {}
local cardItemPrefabs
local leftArrows 			= {};
local rightArrows 			= {};

local HistoryTotal_VLines 	= {};--历史总分的两条可隐藏或者显示的横线
local CurrentB_AND_P_VLines = {};--本局奖罚的两条可隐藏或者显示的横线
local CurrentTotal_VLines 	= {};--本局总分的两条可隐藏或者显示的横线

local historyTotals 		= {};
local b_and_ps 				= {};
local totalScores 			= {};

local historyTotalGroups 	= {};
local b_and_pGroups 		= {};
local totalScoreGroups 		= {};
local myCardsGrid 			= nil;


local ButtonOK
local ButtonShare
local ButtonXiPai
local gameRound;--多少局了
local roomNum;--房间号
local roomData = nil;
local xiTongLabel;
local whoShow
--启动事件--
function this.Awake(obj)
	gameObject = obj;
    ButtonOK = gameObject.transform:Find('ButtonOK')
	ButtonShare = gameObject.transform:Find('ButtonShare')
	ButtonXiPai = gameObject.transform:Find('ButtonXiPai')
	message = gameObject:GetComponent('LuaBehaviour')
    message:AddClick(ButtonOK.gameObject, this.OnClickButtonOK)
	message:AddClick(ButtonShare.gameObject, this.onClickButtonShare)
    message:AddClick(ButtonXiPai.gameObject, this.OnClickButtonXiPai)
    for i=1,4 do
		names[i] 					= gameObject.transform:Find('players/Player'..i..'/Name')
		userids[i] 					= gameObject.transform:Find('players/Player'..i..'/ID')
		icons[i] 					= gameObject.transform:Find('players/Player'..i..'/HeadImage/HeadIcon')
		medalIcons[i]				= gameObject.transform:Find('players/Player'..i..'/medalIcon')
		groups[i]					= gameObject.transform:Find('players/Player'..i..'/group')
		beClosed[i]					= gameObject.transform:Find('players/Player'..i..'/beClose')
		catchScores[i]				= gameObject.transform:Find('players/Player'..i..'/catchScore')
		XiTotals[i]					= gameObject.transform:Find('players/Player'..i..'/XiTotal')
		restCardGrid[i]				= gameObject.transform:Find('players/Player'..i..'/restCardScrollView/restCardGrid')
		restCardScrollViews[i]		= gameObject.transform:Find('players/Player'..i..'/restCardScrollView')
		leftArrows[i] 				= gameObject.transform:Find('players/Player'..i..'/leftArrow')
		rightArrows[i] 				= gameObject.transform:Find('players/Player'..i..'/rightArrow')
	end

	cardItemPrefabs		= gameObject.transform:Find('carditem')
	roomNum 			= gameObject.transform:Find('roundInfo/roomNum');
	gameRound 			= gameObject.transform:Find('roundInfo/round');
	myCardsGrid 		= gameObject.transform:Find("myCards/restCardScrollView/restCardGrid");
	xiTongLabel 		= gameObject.transform:Find("tableTitle/xiTongLabel");

	this.GetGroupsUI();

end

function this.Start()
end

function this.setButtonsStatus(hideXiPai)
    if hideXiPai==nil and roomData.setting.openShuffle==true and whoShow.isInGame==true and whoShow.gameOver==false then
        ButtonXiPai.gameObject:SetActive(true)
        ButtonXiPai:Find('Label'):GetComponent('UILabel').text='洗牌'
        ButtonXiPai:GetComponent('UIButton').isEnabled=true
    else
        ButtonXiPai.gameObject:SetActive(false)
    end
	if whoShow.isBack==true then
		local hasXiPai=false
		for i=1,#whoShow.playerData do
			if whoShow.playerData[i].isShuffle then
				panelInGame.needXiPai=true
				if whoShow.playerData[i].seat==DestroyRoomData.mySeat then
					ButtonXiPai:Find('Label'):GetComponent('UILabel').text='已洗牌'
					ButtonXiPai:GetComponent('UIButton').isEnabled=false
					break
				end
			end
		end
		whoShow.isBack=false
	end
end

function this.OnClickButtonXiPai(go)
    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
        ButtonXiPai:GetComponent('UIButton').isEnabled=false
        AudioManager.Instance:PlayAudio('btn')
        local msg = Message.New()
        msg.type = dtz_pb.SHUFFLE
        SendGameMessage(msg, nil)
    end, nil, '洗牌会消耗'..roomData.setting.shuffleFee..'疲劳值，是否确认洗牌？(确认洗牌后将自动进入下一局)')
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.onGetXiPaiResult(msg)
    local b = dtz_pb.RShuffle()
    b:ParseFromString(msg.body)
    if b.seat==DestroyRoomData.mySeat then
        --错误码 83:洗牌成功  84:洗牌失败非疲劳值不足  85:洗牌失败疲劳值不足  86:重复洗牌
        if b.code==83 then
			ButtonXiPai:Find('Label'):GetComponent('UILabel').text='已洗牌'
			local msg = Message.New()
			msg.type = dtz_pb.READY
			SendGameMessage(msg, nil);
			if whoShow.isInGame then 
				panelInGame_dtz.hasStageClear=false
			end
			PanelManager.Instance:HideWindow(gameObject.name)
        elseif  b.code==84 then
            ButtonXiPai:GetComponent('UIButton').isEnabled=true
            panelMessageBox.SetParamers(ONLY_OK, nil, nil, '暂时不能洗牌')
            PanelManager.Instance:ShowWindow('panelMessageBox')
        elseif  b.code==85 then
            ButtonXiPai:GetComponent('UIButton').isEnabled=true
            panelMessageBox.SetParamers(ONLY_OK, nil, nil, '疲劳值不足')
            PanelManager.Instance:ShowWindow('panelMessageBox')
        elseif  b.code==86 then
            ButtonXiPai:GetComponent('UIButton').isEnabled=true
            panelMessageBox.SetParamers(ONLY_OK, nil, nil, '请勿重复点击')
            PanelManager.Instance:ShowWindow('panelMessageBox')
        else
            ButtonXiPai:GetComponent('UIButton').isEnabled=true
            panelMessageBox.SetParamers(ONLY_OK, nil, nil, '洗牌未知错误')
            PanelManager.Instance:ShowWindow('panelMessageBox')
        end
    end
    if panelInGame.needXiPai==false and b.code==83 then
        panelInGame.needXiPai=true
    end
end

function this.OnEnable()
	
end
function this.Update()

end

function this.GetGroupsUI()

	for i = 1, 2 do
		local index = 0;
		if i == 1 then
			index = i;
		elseif i == 2 then
			index = i+1;
		end
		HistoryTotal_VLines[i] 		= gameObject.transform:Find("lineGrid/horizontal/h2/c"..index);
		CurrentB_AND_P_VLines[i] 	= gameObject.transform:Find("lineGrid/horizontal/h4/c"..index);
		CurrentTotal_VLines[i] 		= gameObject.transform:Find("lineGrid/horizontal/h6/c"..index);
	end

	for i = 1, 2 do
		historyTotalGroups[i]  	= gameObject.transform:Find("HistoryTotal/currentHistoryGroup"..i);
		b_and_pGroups[i]  		= gameObject.transform:Find("CurrentB_AND_P/punish_and_awardGroup"..i);
		totalScoreGroups[i]  	= gameObject.transform:Find("CurrentTotalScore/totalScoreGroup"..i);
	end
	for i = 1, 4 do
		historyTotals[i] 	= gameObject.transform:Find("HistoryTotal/currentHistory"..i);
		b_and_ps[i] 		= gameObject.transform:Find("CurrentB_AND_P/punish_and_award"..i);
		totalScores[i] 		= gameObject.transform:Find("CurrentTotalScore/totalScore"..i);

	end
end
function this.WhoShow(data)
	if data.isInGame then 
		data.fuc()
	end
	whoShow = data
	roomNum:GetComponent("UILabel").text = data.roomNumber;
	gameRound:GetComponent("UILabel").text = (data.roomData.round-1);
	roomData = data.roomData;
	this.Refresh(data);
	this.SetCardsInHands(data.darkCards);
    RegisterGameCallBack(dtz_pb.SHUFFLE, this.onGetXiPaiResult)
    this.setButtonsStatus()
end
function this.GetPlayerDataBySeat(playerData,seat)
	for i=1,#playerData do
		if playerData[i].seat == seat then
			return playerData[i]
		end
	end
	return nil
end
function this.Refresh(roundEnd)
	print("Refresh was called");
	if not roundEnd.playerDatas then
		print("playerDatas is nil in SetRestCardf");
		return ;
	end

	local  data = {}
	data = roundEnd.playerDatas;
	if roomData.setting.size == 4 then--按照分组排序
		table.sort(data,function (a,b) return a.group < b.group end);
	else
		table.sort(data,function (a,b) return a.roundOrder < b.roundOrder end);
	end

	for i = 1, 4 do
		names[i].parent.gameObject:SetActive(false);
	end

	for i = 1, #data do
		names[i].parent.gameObject:SetActive(true);
		--设置玩家信息
		local player = this.GetPlayerDataBySeat(roundEnd.playerData,data[i].seat);
        names[i]:GetComponent("UILabel").text 		= player.name;
		userids[i]:GetComponent("UILabel").text 	= "ID:"..player.id;
		coroutine.start(LoadPlayerIcon,icons[i]:GetComponent("UITexture"),player.icon);
		print("player "..i.." roundOrder:"..tostring(data[i].roundOrder+1));
		medalIcons[i]:GetComponent('UISprite').spriteName 	= "名次"..(data[i].roundOrder+1);
		catchScores[i]:GetComponent("UILabel").text 		= data[i].roundGrab;
		XiTotals[i]:GetComponent("UILabel").text 			= data[i].bonusScore;
		if data[i].isOff then
			beClosed[i].gameObject:SetActive(true);
			medalIcons[i].gameObject:SetActive(false);
		else
			beClosed[i].gameObject:SetActive(false);
			medalIcons[i].gameObject:SetActive(true);
		end
	end
	for i = 1, #data do
		this.SetRestCardf(data[i].cards,i);
	end

	if roomData.setting.cardCount == 3 then
		xiTongLabel:GetComponent("UILabel").text = "地炸/筒总分";
	elseif roomData.setting.cardCount == 4 then
		xiTongLabel:GetComponent("UILabel").text = "喜总分";
	elseif roomData.setting.cardCount == 5 then
		xiTongLabel:GetComponent("UILabel").text = "喜/筒总分";
	end


	this.SetBonusData(data);
end


function this.SetBonusData(playerDatas)
	--没有分组
	if roomData.setting.size < 4 then
		for i = 1, 2 do
			--显示横线
			HistoryTotal_VLines[i].gameObject:SetActive(true);
			CurrentB_AND_P_VLines[i].gameObject:SetActive(true);
			CurrentTotal_VLines[i].gameObject:SetActive(true);

			--隐藏分组时才会显示的文字
			historyTotalGroups[i].gameObject:SetActive(false);
			b_and_pGroups[i].gameObject:SetActive(false);
			totalScoreGroups[i].gameObject:SetActive(false);
		end

		for i = 1, 4 do
			historyTotals[i].gameObject:SetActive(true);
			b_and_ps[i].gameObject:SetActive(true);
			totalScores[i].gameObject:SetActive(true);
			groups[i].gameObject:SetActive(false);
		end

		for i = 1, 4 do
			if i<= #playerDatas then
				historyTotals[i]:GetComponent("UILabel").text = playerDatas[i].historyTotalScore;
				b_and_ps[i]:GetComponent("UILabel").text = playerDatas[i].roundBonus;
				local get = totalScores[i]:Find("get");
				local lost = totalScores[i]:Find("lost");
				get:GetComponent("UILabel").text = "+"..playerDatas[i].roundScore;
                lost:GetComponent("UILabel").text = playerDatas[i].roundScore;
				get.gameObject:SetActive(playerDatas[i].roundScore >= 0);
				lost.gameObject:SetActive(playerDatas[i].roundScore < 0);
			else
				historyTotals[i].gameObject:SetActive(false);
				b_and_ps[i].gameObject:SetActive(false);
				totalScores[i].gameObject:SetActive(false);
			end

		end
	--分组了
	else
		for i = 1, 2 do
			--显示横线
			HistoryTotal_VLines[i].gameObject:SetActive(false);
			CurrentB_AND_P_VLines[i].gameObject:SetActive(false);
			CurrentTotal_VLines[i].gameObject:SetActive(false);

			--隐藏分组时才会显示的文字
			historyTotalGroups[i].gameObject:SetActive(true);
			b_and_pGroups[i].gameObject:SetActive(true);
			totalScoreGroups[i].gameObject:SetActive(true);
		end

		for i = 1, 4 do
			historyTotals[i].gameObject:SetActive(false);
			b_and_ps[i].gameObject:SetActive(false);
			totalScores[i].gameObject:SetActive(false);
			groups[i].gameObject:SetActive(true);
			if playerDatas[i].group == 0 then
				groups[i]:GetComponent("UISprite").spriteName = "扑克通用-A组标记";
			else
				groups[i]:GetComponent("UISprite").spriteName = "扑克通用-B组标记";
			end

		end

		for i = 1, 2 do
			local index= i == 1 and i or i+2;
			historyTotalGroups[i]:GetComponent("UILabel").text = playerDatas[index].historyTotalScore;
			b_and_pGroups[i]:GetComponent("UILabel").text = playerDatas[index].roundBonus;
			local get = totalScoreGroups[i]:Find("get");
			local lost = totalScoreGroups[i]:Find("lost");
			get:GetComponent("UILabel").text = "+"..playerDatas[index].roundScore;
			lost:GetComponent("UILabel").text = playerDatas[index].roundScore;
			get.gameObject:SetActive(playerDatas[index].roundScore >= 0);
			lost.gameObject:SetActive(playerDatas[index].roundScore < 0);
		end
	end
end


function this.SetCardsInHands(cards)
	if not cards then
		return ;
	end;

	table.sort(cards,function (a,b) return a > b end);

	local leftArrow = gameObject.transform:Find("myCards/leftArrow");
	local rightArrow = gameObject.transform:Find("myCards/rightArrow");
	local cardLength = #cards;
	leftArrow.gameObject:SetActive(cardLength > 16);
	rightArrow.gameObject:SetActive(cardLength > 16);
	local baseDepth = 5;
	for i = 1, cardLength do
		local clone = nil
		if myCardsGrid.childCount>=i then
			clone = myCardsGrid.transform:GetChild(i-1).gameObject
		else
			clone = NGUITools.AddChild(myCardsGrid.gameObject,cardItemPrefabs.gameObject)
		end
		clone.gameObject:SetActive(true);
		this.SetCardItem(cards[i],clone,baseDepth + i*5);
	end

	for j = #cards, myCardsGrid.childCount do
		if j< myCardsGrid.childCount then
			myCardsGrid.transform:GetChild(j).gameObject:SetActive(false)
		end
	end
	myCardsGrid:GetComponent('UIGrid'):Reposition();
	myCardsGrid.parent:GetComponent("UIScrollView"):ResetPosition();

end

--设置剩余的牌
function this.SetRestCardf(cards,index)
	print('玩家剩余的牌的数量 ：'..#cards);
	local grid = restCardGrid[index].transform

	leftArrows[index].gameObject:SetActive(#cards > 6);
	rightArrows[index].gameObject:SetActive(#cards > 6);

	table.sort(cards,function (a,b) return a > b; end);
	local baseDepth = 5;
	for i = 1, #cards do
		local clone = nil
		if grid.childCount == nil or grid.childCount>=i then
			clone = grid.transform:GetChild(i-1).gameObject
		else
			clone = NGUITools.AddChild(grid.gameObject,cardItemPrefabs.gameObject)
		end
		clone.gameObject:SetActive(true)
		this.SetCardItem(cards[i],clone,baseDepth+i*5);
	end
	for j = #cards, grid.childCount do
		if j< grid.childCount then
			grid.transform:GetChild(j).gameObject:SetActive(false)
		end
	end
	grid:GetComponent('UIGrid'):Reposition();
	restCardScrollViews[index]:GetComponent("UIScrollView"):ResetPosition();

end
function this.ProcessCard(cards)
	local myList = {}
	if cards then
		for i = 1, #cards do

			local _type = GetPlateType(cards[i]);
			local _value = GetPlateNum(cards[i])+2;
			local _trueValue = cards[i];

			--大小王特殊处理
			if _value == 16 then
				if _type == 0 then--小王
					_value = 16;
				else
					_value = 17;
				end
			end

			table.insert(myList,{trueValue = _trueValue,type = _type,value = _value});
		end
	end
	--print("ProcessCard.length:"..#myList);
	return myList
end
function this.SetCardItem(card,setObj,depth)

	local huaTrans = setObj.transform:Find("hua");
	local cardTrans = setObj.transform:Find("card");
	local king1 = setObj.transform:Find("king1");
	local king2 = setObj.transform:Find("king2");
	local processCard = this.ProcessCard({card})[1];
	setObj:GetComponent("UISprite").depth = depth -1;


	if dtz_Logic.IsJocker(processCard) then
		king1:GetComponent("UISprite").spriteName = dtz_Logic.IsRedJocker(processCard) and "bJoker_1" or "xJoker_1";
		king2:GetComponent("UISprite").spriteName = dtz_Logic.IsRedJocker(processCard) and "bJoker_2" or "xJoker_2";
		king1.gameObject:SetActive(true);
		king2.gameObject:SetActive(true);
		huaTrans.gameObject:SetActive(false);
		cardTrans.gameObject:SetActive(false);
		king1:GetComponent("UISprite").depth = depth;
		king2:GetComponent("UISprite").depth = depth;
	else
		king1.gameObject:SetActive(false);
		king2.gameObject:SetActive(false);
		huaTrans.gameObject:SetActive(true);
		cardTrans.gameObject:SetActive(true);
		huaTrans:GetComponent("UISprite").depth = depth;
		cardTrans:GetComponent("UISprite").depth = depth;
		huaTrans:GetComponent("UISprite").spriteName 	= this.GetPlateTypeString(card);
		cardTrans:GetComponent("UISprite").spriteName 	= this.GetPlateNumString(card);
		cardTrans:GetComponent("UISprite").color 		= this.GetPlateColor(GetPlateType(card));
	end

end

function this.GetPlateColor(plateType)
	if plateType == 0 or plateType == 2 then
		return Color.white;
	elseif plateType == 1 or plateType == 3 then
		return Color.New(51/255 ,52/255 ,57/255);
	end
end

--获得牌的类型字符串
function this.GetPlateTypeString(card)
	local plateType = GetPlateType(card);
	if plateType == 0 then
		return "DiamondIcon1";
	elseif plateType == 1 then
		return "ClubIcon1";
	elseif plateType == 2 then
		return "HeartIcon1";
	elseif plateType == 3 then
		return "SpadeIcon1"
	else
		return "unknow icon"
	end
end

--获得牌的牌面字符串
function this.GetPlateNumString(card)
	local plateNum = GetPlateNum(card)+2;--注意这里+2，是因为新化炸弹跟跑得快有区别，新化炸弹直接从5开始
	return "card_"..plateNum;
end

--单击事件--
function this.OnClickMask(go)
    PanelManager.Instance:HideWindow(gameObject.name)
	if whoShow.isInGame then 
		panelInGame_dtz.hasStageClear=false
	end
end

function this.OnClickButtonOK(go)
	AudioManager.Instance:PlayAudio('btn')
	if whoShow.isInGame then 
		if RoundAllData.over then
		local stageInfo = {};
		stageInfo.players = RoundAllData.data.players;
		stageInfo.roomNumber =roomInfo.roomNumber;
		PanelManager.Instance:ShowWindow('panelStageClearAll_dtz',stageInfo);
		else
			local msg = Message.New()
			msg.type = dtz_pb.READY
			SendGameMessage(msg, nil);
		end
	end
	this.OnClickMask(go)
end

function this.onClickButtonShare(go)
	if not whoShow.isInGame then
		return
	end
	local data = {}
    data.showName = 'JieTuShare'
    PanelManager.Instance:ShowWindow('panelShared', data)
end