local hsth_pb = require 'hsth_pb'
local proxy_pb = require "proxy_pb"

panelStageClear_hsth = {}
local this = panelStageClear_hsth

local message
local gameObject

local roundNum
local roomNum
local timeNum
local ButtonOK
local ButtonShare
local ButtonXiPai

local playerInfo={}
local playerBg
local player
local cardItem
local playerItem
local myCardsGrid
local depth=5

--启动事件--
function this.Awake(obj)
	gameObject = obj
	message = gameObject:GetComponent('LuaBehaviour')

	roundNum = gameObject.transform:Find('roundInfo/round')
	roomNum = gameObject.transform:Find('roundInfo/roomNum')
	timeNum = gameObject.transform:Find('roundInfo/time')
	ButtonOK = gameObject.transform:Find('ButtonOK')
	message:AddClick(ButtonOK.gameObject, this.OnClickButtonOK)
	ButtonShare = gameObject.transform:Find('ButtonShare')
	message:AddClick(ButtonShare.gameObject, this.onClickButtonShare)
	ButtonXiPai = gameObject.transform:Find('ButtonXiPai')
	message:AddClick(ButtonXiPai.gameObject, this.OnClickButtonXiPai)
	myCardsGrid = gameObject.transform:Find("myCards/restCardScrollView/restCardGrid")
	playerBg = gameObject.transform:Find('playerBg')
	cardItem = gameObject.transform:Find('cardItem')
	playerItem = gameObject.transform:Find('playerItem')
	player = gameObject.transform:Find('players')
	for i = 0, 5 do
		local obj = NGUITools.AddChild(player.gameObject,playerItem.gameObject)
		local playerUI = {}
		playerUI.obj  = obj.transform
		playerUI.playerIcon = playerUI.obj:Find('HeadImage/HeadIcon')
		playerUI.playerName = playerUI.obj:Find('name')
		playerUI.playerID = playerUI.obj:Find('ID')
		playerUI.playerMedalIcon = playerUI.obj:Find('medalIcon')
		playerUI.playerScorePos = playerUI.obj:Find('scorePos')
		playerUI.playerHistoryScore = playerUI.playerScorePos:Find('historyScore')
		playerUI.playerXiScore = playerUI.obj:Find('xiScore')
		playerUI.playerRewardScore = playerUI.playerScorePos:Find('rewardScore')
		playerUI.playerGetScore = playerUI.obj:Find('getScore')	
		playerUI.playerZongScore = playerUI.playerScorePos:Find('zongScore')	
		playerUI.playerCardScrollView = playerUI.obj:Find('scrollView')
		playerUI.playerCardGrid = playerUI.playerCardScrollView:Find('grid')
		playerUI.playerRightArrow = playerUI.obj:Find('rightArrow')
		playerUI.playerLeftArrow = playerUI.obj:Find('leftArrow')
		table.insert(playerInfo,playerUI)
	end
end
function this.Start()
end
function this.Update()
end

function this.OnEnable()
	RegisterGameCallBack(hsth_pb.SHUFFLE, this.onGetXiPaiResult)
	this.setButtonsStatus()
	this.Refresh()
end
function this.WhoShow(fuc)
	fuc()
end

function this.setButtonsStatus(hideXiPai)
    if hideXiPai==nil and RoundData.isInGame==true and RoundData.gameOver==false and roomData.setting.openShuffle==true then
        ButtonXiPai.gameObject:SetActive(true)
        ButtonXiPai:Find('Label'):GetComponent('UILabel').text='洗牌'
        ButtonXiPai:GetComponent('UIButton').isEnabled=true
    else
        ButtonXiPai.gameObject:SetActive(false)
    end
end

function this.OnClickButtonXiPai(go)
    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
        ButtonXiPai:GetComponent('UIButton').isEnabled=false
        AudioManager.Instance:PlayAudio('btn')
        local msg = Message.New()
        msg.type = hsth_pb.SHUFFLE
        SendGameMessage(msg, nil)
    end, nil, '洗牌会消耗'..roomData.setting.shuffleFee..'疲劳值，是否确认洗牌？(确认洗牌后将自动进入下一局)')
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.onGetXiPaiResult(msg)
    local b = hsth_pb.RShuffle()
    b:ParseFromString(msg.body)
    if b.seat==DestroyRoomData.mySeat then
        --错误码 83:洗牌成功  84:洗牌失败非疲劳值不足  85:洗牌失败疲劳值不足  86:重复洗牌
        if b.code==83 then
			ButtonXiPai:Find('Label'):GetComponent('UILabel').text='已洗牌'
			local msg = Message.New()
			msg.type = hsth_pb.READY
			SendGameMessage(msg, nil)
			if RoundData.isInGame then 
				panelInGame.hasStageClear=false
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

function this.OnClickButtonOK(go)
	AudioManager.Instance:PlayAudio('btn')
	if RoundData.isInGame then
		print('RoundData.gameOver : '..tostring(RoundData.gameOver)..' RoundAllData.over : '..tostring(RoundAllData.over))
		if RoundData.gameOver or RoundAllData.over then
			PanelManager.Instance:ShowWindow('panelStageClearAll_hsth')
		else
			local msg = Message.New()
			msg.type = hsth_pb.READY
			SendGameMessage(msg, nil)
		end
		panelInGame.hasStageClear=false
	end
	PanelManager.Instance:HideWindow(gameObject.name)
end

function this.onClickButtonShare(go)
	if not RoundData.isInGame then
		return
	end
	local data = {}
    data.showName = 'JieTuShare'
    PanelManager.Instance:ShowWindow('panelShared', data)
end
function this.Refresh()
	roundNum:GetComponent("UILabel").text = '第'..roomData.round/roomData.setting.rounds..'局'
	roomNum:GetComponent("UILabel").text = '房间号：'..roomInfo.roomNumber
	timeNum:GetComponent("UILabel").text =  '时间：'..os.date('%Y/%m/%d %H:%M')
	roomData.round = roomData.round + 1
	--显示暗牌
	myCardsGrid.parent.parent.gameObject:SetActive(roomData.setting.size == 2)
	if roomData.setting.size == 2 then
		table.sort(RoundData.darkCards)
		for i = 1, #RoundData.darkCards do
			local obj
			if #RoundData.darkCards > myCardsGrid.childCount then
				obj = NGUITools.AddChild(myCardsGrid.gameObject,cardItem.gameObject)
				obj.transform:GetComponent("UISprite").depth = i*2+depth -1
				obj.transform:Find("hua"):GetComponent("UISprite").depth = i*2+depth
				obj.transform:Find("card"):GetComponent("UISprite").depth = i*2+depth
			else
				obj = myCardsGrid:GetChild(i-1).gameObject
			end
			this.SetCardItem(RoundData.darkCards[i],obj)
		end
		for i = 0, myCardsGrid.childCount-1 do
            if i < #RoundData.darkCards then
                myCardsGrid:GetChild(i).gameObject:SetActive(true)
            else
                myCardsGrid:GetChild(i).gameObject:SetActive(false)
            end
		end
		myCardsGrid:GetComponent('UIGrid'):Reposition()
		myCardsGrid.parent:GetComponent("UIScrollView"):ResetPosition()
	end
	for i = 1, #playerInfo do
		playerInfo[i].obj.gameObject:SetActive(false)
		playerInfo[i].playerScorePos.gameObject:SetActive(true)
	end
	for i = 1, #RoundData.players do
		this.SetPlayerInfo(playerInfo[i],RoundData.players[i])
	end
	if roomData.setting.size == 6 then
		playerInfo[1].playerScorePos.gameObject:SetActive(false)
		playerInfo[3].playerScorePos.gameObject:SetActive(false)
		playerInfo[4].playerScorePos.gameObject:SetActive(false)
		playerInfo[6].playerScorePos.gameObject:SetActive(false)
	elseif roomData.setting.size == 4 then
		playerInfo[2].playerScorePos.gameObject:SetActive(false)
		playerInfo[4].playerScorePos.gameObject:SetActive(false)
	end
	for i = 0, playerBg.childCount-1 do
		playerBg:GetChild(i).gameObject:SetActive(false)
	end
	playerBg:Find(tostring(roomData.setting.size)).gameObject:SetActive(true)
	player.localPosition = Vector3(player.localPosition.x,roomData.setting.size ~= 6 and -5 or 14,player.localPosition.z)
	player:GetComponent('UIGrid').cellHeight = roomData.setting.size ~= 6 and 108 or 76
	player:GetComponent('UIGrid'):Reposition()
end

function this.SetPlayerInfo(playerUI,data)
	playerUI.obj.gameObject:SetActive(true)
	playerUI.playerScorePos.localPosition = Vector3(player.localPosition.x,roomData.setting.size ~= 4 and 0 or -50,player.localPosition.z)
	coroutine.start(LoadPlayerIcon,playerUI.playerIcon:GetComponent("UITexture"),data.icon)
	playerUI.playerName:GetComponent("UILabel").text = data.name
	playerUI.playerID:GetComponent("UILabel").text = 'ID:'..data.id
	playerUI.playerMedalIcon:GetComponent('UISprite').spriteName = "名次"..data.placing
	playerUI.playerHistoryScore:GetComponent("UILabel").text = data.historyScore
	playerUI.playerXiScore:GetComponent("UILabel").text = data.happlyScore
	playerUI.playerRewardScore:GetComponent("UILabel").text = data.rewardScore
	playerUI.playerGetScore:GetComponent("UILabel").text = data.grabScore
	local win = ''
	if data.win < 0 then
		win = '[165CF9]'..data.win
	elseif data.win == 0 then
		win = '[FF0000]'..data.win
	else
		win = '[FF0000]+'..data.win
	end
	playerUI.playerZongScore:GetComponent("UILabel").text = win
	table.sort(data.cards)
	for i = 1, #data.cards do
		local obj
		if #data.cards > playerUI.playerCardGrid.childCount then
			obj = NGUITools.AddChild(playerUI.playerCardGrid.gameObject,cardItem.gameObject)
		else
			obj = playerUI.playerCardGrid:GetChild(i-1).gameObject
		end
		this.SetCardItem(data.cards[i],obj)
	end
	for i = 0, playerUI.playerCardGrid.childCount-1 do
		if i < #data.cards then
			playerUI.playerCardGrid:GetChild(i).gameObject:SetActive(true)
			playerUI.playerCardGrid:GetChild(i):GetComponent("UISprite").depth = i*3+depth -1
			playerUI.playerCardGrid:GetChild(i):Find("hua"):GetComponent("UISprite").depth = i*3+depth
			playerUI.playerCardGrid:GetChild(i):Find("card"):GetComponent("UISprite").depth = i*3+depth
		else
			playerUI.playerCardGrid:GetChild(i).gameObject:SetActive(false)
		end
	end
	playerUI.playerRightArrow.gameObject:SetActive(data.cards ~= nil and #data.cards>6)
	playerUI.playerLeftArrow.gameObject:SetActive(data.cards ~= nil and #data.cards>6)
	playerUI.playerCardScrollView:GetComponent("UIScrollView"):ResetPosition()
	playerUI.playerCardGrid:GetComponent('UIGrid'):Reposition()
end

function this.SetCardItem(card,setObj)
	local huaTrans = setObj.transform:Find("hua")
	local cardTrans = setObj.transform:Find("card")
	huaTrans:GetComponent("UISprite").spriteName = this.GetPlateTypeString(card)
	cardTrans:GetComponent("UISprite").spriteName = this.GetPlateNumString(card)
	cardTrans:GetComponent("UISprite").color = this.GetPlateColor(GetPlateType(card))
end

function this.GetPlateColor(plateType)
	if plateType == 0 or plateType == 2 then
		return Color.white
	elseif plateType == 1 or plateType == 3 then
		return Color.New(51/255 ,52/255 ,57/255)
	end
end

--获得牌的类型字符串
function this.GetPlateTypeString(card)
	local plateType = GetPlateType(card)
	if plateType == 0 then
		return "DiamondIcon1"
	elseif plateType == 1 then
		return "ClubIcon1"
	elseif plateType == 2 then
		return "HeartIcon1"
	elseif plateType == 3 then
		return "SpadeIcon1"
	else
		return "unknow icon"
	end
end

--获得牌的牌面字符串
function this.GetPlateNumString(card)
	local plateNum = GetPlateNum(card)
	return "card_"..plateNum
end
