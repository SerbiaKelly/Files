local xhzd_pb = require 'xhzd_pb'
local proxy_pb = require "proxy_pb"

panelStageClear_xhzd = {}
local this = panelStageClear_xhzd

local message
local gameObject

local mask
local playerInfo={}
local names			= {}
local userids 		= {};
local icons			= {}
local medalIcons	= {}
local baozhuangs 	= {}
local gans			= {}
local catchScores 	= {}
local countScores 	= {}
local xiScores		= {}
local croundScores	= {}
local restCardGrid	= {}
local restCardScrollViews = {}
local cardItemPrefabs
local leftArrows = {};
local rightArrows = {};
local c1;
local c2;
local currentBonus1;
local currentBonus2;
local players4;
local scoreBG
local myCardsGrid
local anPai

local isSelectBaoZhuang
local depth=5
local ButtonOK
local ButtonShare
local ButtonXiPai
local gameRound;--多少局了
local roomNum;--房间号
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
		playerInfo[i]  = gameObject.transform:Find('players/Player'..i)
		names[i] 					= gameObject.transform:Find('players/Player'..i..'/Name')
		userids[i] 					= gameObject.transform:Find('players/Player'..i..'/ID')
		icons[i] 					= gameObject.transform:Find('players/Player'..i..'/HeadImage/HeadIcon')
		medalIcons[i]				= gameObject.transform:Find('players/Player'..i..'/medalIcon')
		baozhuangs[i]				= gameObject.transform:Find('players/Player'..i..'/baozhuang')
		gans[i]						= gameObject.transform:Find('players/Player'..i..'/ganLabel')
		catchScores[i]				= gameObject.transform:Find('players/Player'..i..'/catchScore')
		countScores[i]				= gameObject.transform:Find('players/Player'..i..'/countScore')
		xiScores[i]					= gameObject.transform:Find('players/Player'..i..'/xiScore')
		croundScores[i]				= gameObject.transform:Find('players/Player'..i..'/croundScore')
		restCardGrid[i]				= gameObject.transform:Find('players/Player'..i..'/restCardScrollView/restCardGrid')
		restCardScrollViews[i]		= gameObject.transform:Find('players/Player'..i..'/restCardScrollView')
		leftArrows[i] 				= gameObject.transform:Find('players/Player'..i..'/leftArrow')
		rightArrows[i] 				= gameObject.transform:Find('players/Player'..i..'/rightArrow')
	end
	c1 			= gameObject.transform:Find('lineGrid/c1');
	c2 			= gameObject.transform:Find('lineGrid/c2');
	roomNum 	= gameObject.transform:Find('roundInfo/roomNum');
	gameRound 	= gameObject.transform:Find('roundInfo/round');
	currentBonus1 = gameObject.transform:Find("currenRound/currentBonus1");
	currentBonus2 = gameObject.transform:Find("currenRound/currentBonus2");
	players4 = gameObject.transform:Find("lineGrid/player4");
	scoreBG = gameObject.transform:Find("lineGrid/bg");
	myCardsGrid = gameObject.transform:Find("myCards/restCardScrollView/restCardGrid");
	cardItemPrefabs			= gameObject.transform:Find('carditem')
	anPai = gameObject.transform:Find('myCards')
	for i = 0, 43 do
		local clone = nil
		clone = NGUITools.AddChild(myCardsGrid.gameObject,cardItemPrefabs.gameObject)
		clone.gameObject:SetActive(true);
		clone.transform:GetComponent("UISprite").depth = depth -1;
		clone.transform:Find("hua"):GetComponent("UISprite").depth = depth;
		clone.transform:Find("card"):GetComponent("UISprite").depth = depth;
	end
	myCardsGrid:GetComponent('UIGrid'):Reposition();
	myCardsGrid.transform.parent:GetComponent("UIScrollView"):ResetPosition();
end

function this.Start()
end

function this.setButtonsStatus(hideXiPai)
    if hideXiPai==nil and whoShow.roomData.setting.openShuffle==true and whoShow.isInGame==true and whoShow.gameOver==false then
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
        msg.type = xhzd_pb.SHUFFLE
        SendGameMessage(msg, nil)
    end, nil, '洗牌会消耗'..whoShow.roomData.setting.shuffleFee..'疲劳值，是否确认洗牌？(确认洗牌后将自动进入下一局)')
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.onGetXiPaiResult(msg)
    local b = xhzd_pb.RShuffle()
    b:ParseFromString(msg.body)
    if b.seat==DestroyRoomData.mySeat then
        --错误码 83:洗牌成功  84:洗牌失败非疲劳值不足  85:洗牌失败疲劳值不足  86:重复洗牌
        if b.code==83 then
			ButtonXiPai:Find('Label'):GetComponent('UILabel').text='已洗牌'
			local msg = Message.New()
			msg.type = xhzd_pb.READY
			SendGameMessage(msg, nil)
			for i = 1, 4 do
				local  pos = restCardScrollViews[i].transform.localPosition
				pos.x = 936
				restCardScrollViews[i].transform.localPosition = pos
				local pos1 = restCardScrollViews[i]:GetComponent("UIPanel").clipOffset
				pos1.x =0
				restCardScrollViews[i]:GetComponent("UIPanel").clipOffset = pos1
			end
			panelInGame_xhzd.hasStageClear=false
			RoundAllData.over = false
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
function this.WhoShow(data)
	if data.isInGame then 
		data.fuc()
	end
	whoShow = data
	roomNum:GetComponent("UILabel").text = data.roomNumber;
	gameRound:GetComponent("UILabel").text = (data.roomData.round-1)..'/'..data.roomData.setting.rounds;
	myCardsGrid.gameObject:SetActive(data.roomData.setting.size == 2)
	this.Refresh(data);
	print('data.cardsDark : '..#data.cardsDark)
	this.SetCardsInHands(data.cardsDark);
    RegisterGameCallBack(xhzd_pb.SHUFFLE, this.onGetXiPaiResult)
    this.setButtonsStatus()
end
function this.GetPlayerDataBySeat(playerData,seat)
	if playerData[seat] == nil then
	end
	return  playerData[seat]
end
function this.Refresh(roundEnd)
	local data = roundEnd.playerDatas
	if not data then
		print("playerDatas is nil in SetRestCardf");
		return ;
	end
	for i = 1, 4 do
		restCardGrid[i].gameObject:SetActive(false)
		playerInfo[i].gameObject:SetActive(false)
	end
	anPai.gameObject:SetActive(roomData.setting.size == 2);
	players4.gameObject:SetActive(roomData.setting.size == 4);
	scoreBG:GetComponent("UISprite").height = roomData.setting.size == 2 and 268 or 484
	if roomData.setting.size == 2 then
		currentBonus1:GetComponent("UILabel").text = data[1].bonus
		currentBonus2:GetComponent("UILabel").text = data[2].bonus 
		this.SetScorePos(currentBonus1,117)
		this.SetScorePos(currentBonus2,17)
	else
		for i = 1, #data do
			if data[i].warpSeat ~= nil then
				if  data[i].warpSeat == -1  then
					isSelectBaoZhuang = false
				else
					isSelectBaoZhuang = true
				end
			end
		end
		currentBonus1:GetComponent("UILabel").text = data[1].bonus;
		if isSelectBaoZhuang then
			currentBonus2:GetComponent("UILabel").text = data[2].bonus 
			this.SetScorePos(currentBonus1,117)
			this.SetScorePos(currentBonus2,-90)
		else
			currentBonus2:GetComponent("UILabel").text = data[3].bonus 
			this.SetScorePos(currentBonus1,65)
			this.SetScorePos(currentBonus2,-150)
		end
	end
	c1.gameObject:SetActive(roomData.setting.size == 2 or isSelectBaoZhuang);
	c2.gameObject:SetActive(roomData.setting.size == 2 or (not isSelectBaoZhuang));
	for i = 1, #data do
		--设置玩家信息
		playerInfo[i].gameObject:SetActive(true)
		local player = this.GetPlayerDataBySeat(roundEnd.playerData,data[i].seat);
        names[i]:GetComponent("UILabel").text = player.name;
		userids[i]:GetComponent("UILabel").text = player.id;
		coroutine.start(LoadPlayerIcon,icons[i]:GetComponent("UITexture"),player.icon);
		print('i : '..i..'  data.placing : '..tostring(data[i].placing))
		medalIcons[i]:GetComponent('UISprite').spriteName = "名次"..tostring(data[i].placing+1)
		
		--设置分数
		if data[i].seat == data[i].warpSeat then
			baozhuangs[i].gameObject:SetActive(true);
		else
			baozhuangs[i].gameObject:SetActive(false);
		end
		
		catchScores[i]:GetComponent("UILabel").text = data[i].grab;
		countScores[i]:GetComponent("UILabel").text = data[i].mark;--TODO暂时写0
		xiScores[i]:GetComponent("UILabel").text = data[i].happy;
		local get = croundScores[i]:Find("get").gameObject;
		local lost = croundScores[i]:Find("lost").gameObject;
		get:SetActive(data[i].score >= 0);
		lost:SetActive(data[i].score < 0);
		get:GetComponent("UILabel").text = data[i].score;
		lost:GetComponent("UILabel").text = data[i].score;
		if data[i].flag == 0 then
			gans[i].gameObject:SetActive(false);
			gans[i].gameObject:GetComponent("UILabel").text = "";
		elseif data[i].flag == 1 then
			gans[i].gameObject:SetActive(true);
			gans[i].gameObject:GetComponent("UILabel").text = "半干";
		elseif data[i].flag == 2 then
			gans[i].gameObject:SetActive(true);
			gans[i].gameObject:GetComponent("UILabel").text = "全干";
		end
		this.SetRestCardf(data[i].cards,i);
	end
end

function this.SetScorePos(obj,pos_y)
	local p =  obj.localPosition
	p.y = pos_y
	obj.localPosition = p
end

function this.SetCardsInHands(cards)
	if not cards then
		return ;
	end;
	table.sort(cards);
	if cards ~= nil and #cards>0 then
		for i = 1, myCardsGrid.transform.childCount do
			this.SetCardItem(cards[i],myCardsGrid.transform:GetChild(i-1).gameObject)
		end
	end
end

--设置剩余的牌
function this.SetRestCardf(cards,index)
	print('玩家剩余的牌的数量 ：'..#cards..' index ：'..index);
	if cards ~= nil and #cards>0 then
		table.sort(cards)
		restCardGrid[index].gameObject:SetActive(true)
		local grid = restCardGrid[index].transform
		for i = 1, grid.transform.childCount do
			if i > #cards then
				grid.transform:GetChild(i-1).gameObject:SetActive(false)
			else
				grid.transform:GetChild(i-1).gameObject:SetActive(true)
				this.SetCardItem(cards[i],grid.transform:GetChild(i-1).gameObject)
			end
		end
		grid:GetComponent('UIGrid'):Reposition()
	end
	leftArrows[index].gameObject:SetActive(cards ~= nil and #cards>6);
	rightArrows[index].gameObject:SetActive(cards ~= nil and #cards>6);
end

function this.SetCardItem(card,setObj)
	local huaTrans = setObj.transform:Find("hua");
	local cardTrans = setObj.transform:Find("card");
	huaTrans:GetComponent("UISprite").spriteName = this.GetPlateTypeString(card);
	cardTrans:GetComponent("UISprite").spriteName = this.GetPlateNumString(card);
	cardTrans:GetComponent("UISprite").color = this.GetPlateColor(GetPlateType(card));
	
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

function this.OnClickButtonOK(go)
	AudioManager.Instance:PlayAudio('btn')
	if whoShow.isInGame then 
		if not RoundAllData.over then
			local msg = Message.New()
			msg.type = xhzd_pb.READY
			SendGameMessage(msg, nil)
		else
			PanelManager.Instance:ShowWindow('panelStageClearAll_xhzd',RoundAllData)
		end
		for i = 1, 4 do
			local  pos = restCardScrollViews[i].transform.localPosition
			pos.x = 936
			restCardScrollViews[i].transform.localPosition = pos
			local pos1 = restCardScrollViews[i]:GetComponent("UIPanel").clipOffset
			pos1.x =0
			restCardScrollViews[i]:GetComponent("UIPanel").clipOffset = pos1
		end
		panelInGame_xhzd.hasStageClear=false
		RoundAllData.over = false
	end
	PanelManager.Instance:HideWindow(gameObject.name)
end

function this.onClickButtonShare(go)
	if not whoShow.isInGame then
		return
	end
	local data = {}
    data.showName = 'JieTuShare'
    PanelManager.Instance:ShowWindow('panelShared', data)
end