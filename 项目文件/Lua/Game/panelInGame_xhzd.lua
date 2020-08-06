local xhzd_pb = require 'xhzd_pb'
local phz_pb = require 'phz_pb'
require "Game.Tools.UITools"


panelInGame_xhzd = {}
local this = panelInGame_xhzd
local gameObject
local message

local roomID
local roomTime
local roomRound
local CountDown
local playerInfo={}
local playerName={}
local playerIcon={}
local playerScore={}
local playerMaster={}
local playerSound={}
local playerGridIn={}
local playerGridInHorizontal={}
local GridInHorizontal
local playerGridInHorizontal1
local playerGridInHorizontal2
local playerGridOut={}
local beLeftCardGrid={}
local beLeftCardBoom={}
local playerGridOutDaiZi={}
local OutCardZhaDan={}
local OutCardZhaDanWenZi={}
local OutCardZhaDanWenZiBG={}
local playerReady={}
local playerBaoZhuang={}
local OutCardFinish={}
local playerLight={}
local playerzi={}
local playerwenzi={}
local playerKuang={}
local playerNiao={}
local playerTrusteeship={}
local playerOfflineTime={}
local playerSound={}
local roomSetting
local onClickWidget

local playerData={}
local mySeat

local ButtonMore
local ButtonRefresh
local ButtonChat
local ButtonSound
local ButtonCapitulate
local ButtonHorizontal
local ButtonInvite
local ButtonCloseRoom
local ButtonExitRoom
local ButtonHelp
local ButtonPlay
local ButtonPass

local PlayerUIObjs = {}
local DistanceObjs = {}

local conCountDown

local lastFindCards={}
local lastFindCategory = 0
local helpNumWhenHaveOneCard = 0

local setting_text

local playerMsg={}
local playerMsgBG={}
local playerEmoji={}
local playerAnimation={}
local playerCoroutine = {}
local readybtn
local RecordTiShi--录音提示
playerCoroutine[0] = {}
playerCoroutine[1] = {}
playerCoroutine[2] = {}
playerCoroutine[3] = {}
local playerEmojiCoroutine = {}
playerEmojiCoroutine[0] = {}
playerEmojiCoroutine[1] = {}
playerEmojiCoroutine[2] = {}
playerEmojiCoroutine[3] = {}

local IsAutoDissolve = false
local AutoDissolveData

local curPai
local selectCards={}
local connect
function this.GetNetState()
	return connect.IsConnect
end
local connectCor
local RuleInfoPanel--玩法展示界面
local bg
local bg1
local bg2
local bg3
local bg4
local ButtonGPS
this.chatTexts = {}
this.fanHuiRoomNumber = nil
this.OnRoundStarted = nil
this.needCheckNet=true
local RestTime
local restTime
local RefeshTimeCoroutine
local ishelp = false
local batteryLevel
local network
local pingLabel
local lastime
local GvoiceCor
local refreshStateCoroutine
local panelShare
local baoZhuangView--包庄的界面
local scoreView={} --积分界面
local winSeat
local helpOutCardsIndex =1
local myCardList
local GPS
local selectOutCardType
local selectOutCardTypeBG
local selectCardGrid
local selectOutCardGrid ={}
local selectOutCardTypeGrid={}
local selectOutCardTypeGridDaizi = {}
local noBigCard
local maxCard
local minCard
local keyCardCount 
local selectCardType = {}

local tempIntList1 = {}
local tempIntList2 = {}
local tempIntList3 = {}
local tempIntList4 = {}
local tempIntList5 = {}
local tempIntList6 = {}
local tempIntList7 = {}
local tempIntList8 = {}

local selectOutCardTypes = {}
local outCard = {}
local XHZDIsHorizontalCards = false
this.myseflDissolveTimes = 0
local isMySelfTrusteeship = false
local TrusteeshipPanel
local TrusteeshipTip
local trusteeshipcor = nil;
local offlineState = false;
local playerOfflineCoroutines={}

local PlayNiaoView
local NotNiao
local PlayNiao

local fangHeShou--防合手界面
function this.Awake(obj)
	gameObject = obj;
    this.gameObject = obj
	message = gameObject:GetComponent('LuaBehaviour');
	RestTime = gameObject.transform:Find("RestTime")
	roomID = gameObject.transform:Find('topbg/room/ID');
	roomTime = gameObject.transform:Find('time');
	roomRound = gameObject.transform:Find('topbg/round/num');
	CountDown = gameObject.transform:Find('CountDown');
	roomSetting = gameObject.transform:Find('setting')
	onClickWidget = gameObject.transform:Find('OnClick')
	noBigCard = gameObject.transform:Find('noBigCard')
	GridInHorizontal = gameObject.transform:Find('player0/GridInHorizontal');
	playerGridInHorizontal1 = gameObject.transform:Find('player0/GridInHorizontal/1');
	playerGridInHorizontal2 = gameObject.transform:Find('player0/GridInHorizontal/2');
	for i = 0, playerGridInHorizontal1.transform.childCount-1 do
		table.insert(playerGridInHorizontal,playerGridInHorizontal1:GetChild(i))
		message:AddClick(playerGridInHorizontal1:GetChild(i).gameObject, this.OnClickCard);
		message:AddEventTrigger(playerGridInHorizontal1:GetChild(i).gameObject, this.OnClickCard);
	end
	for i = 0, playerGridInHorizontal2.transform.childCount-1 do
		table.insert(playerGridInHorizontal,playerGridInHorizontal2:GetChild(i))
		message:AddClick(playerGridInHorizontal2:GetChild(i).gameObject, this.OnClickCard);
		message:AddEventTrigger(playerGridInHorizontal2:GetChild(i).gameObject, this.OnClickCard);
	end
	for i=0,3 do
		playerInfo[i] = gameObject.transform:Find('player'..i..'/info');
		playerName[i] = gameObject.transform:Find('player'..i..'/info/name');
		playerIcon[i] = gameObject.transform:Find('player'..i..'/info/Texture');
		playerScore[i] = gameObject.transform:Find('player'..i..'/info/score');
		playerMaster[i] = gameObject.transform:Find('player'..i..'/info/master');
		playerSound[i] = gameObject.transform:Find('player'..i..'/info/sound');
		playerGridIn[i] = gameObject.transform:Find('player'..i..'/GridIn');
		playerGridOut[i] = gameObject.transform:Find('player'..i..'/Grid/GridOut');
		playerGridOutDaiZi[i] = gameObject.transform:Find('player'..i..'/Grid/dai');
		OutCardZhaDan[i] = gameObject.transform:Find('player'..i..'/Grid/zhadan');
		OutCardZhaDanWenZiBG[i] = gameObject.transform:Find('player'..i..'/Grid/zhadan/sp');
		OutCardZhaDanWenZi[i] = gameObject.transform:Find('player'..i..'/Grid/zhadan/lb');
		playerReady[i] = gameObject.transform:Find('player'..i..'/info/ready');
		playerBaoZhuang[i] = gameObject.transform:Find('player'..i..'/info/texiao/baozhuang');
		OutCardFinish[i] = gameObject.transform:Find('player'..i..'/info/texiao/OutCardFinish');
		playerLight[i] = gameObject.transform:Find('player'..i..'/info/texiao/alarm')
		playerMsg[i] = gameObject.transform:Find('player'..i..'/info/chat/Msg');
		playerMsgBG[i] = gameObject.transform:Find('player'..i..'/info/Msg/MsgBG');
		playerEmoji[i] = gameObject.transform:Find('player'..i..'/info/Emoji');
		playerAnimation[i] = gameObject.transform:Find('teshubiaoqing/'..i);
		playerzi[i] = gameObject.transform:Find('player'..i..'/texiaozi/pass')
		playerwenzi[i] = gameObject.transform:Find('player'..i..'/texiaozi/tishi')
		playerKuang[i] = gameObject.transform:Find('player'..i..'/info/kuang01')
		playerTrusteeship[i] = gameObject.transform:Find('player'..i..'/info/trusteeship')
		playerOfflineTime[i] = gameObject.transform:Find('player'..i..'/info/offline')
		playerNiao[i] = gameObject.transform:Find('player'..i..'/info/niao')
		beLeftCardGrid[i] = gameObject.transform:Find('beLeftCard/'..i..'/GridOut');
		beLeftCardBoom[i] = gameObject.transform:Find('beLeftCard/'..i..'/zhadanshow');

		message:AddClick(playerIcon[i].gameObject, this.OnClickPlayerIcon);
		
		for j=0,playerGridIn[i].childCount-1 do
			local group = playerGridIn[i]:GetChild(j)
			local paiGrid = group:Find('cardGrid')
			for k=0,paiGrid.childCount-1 do
				message:AddClick(paiGrid:GetChild(k).gameObject, this.OnClickCard);
				message:AddEventTrigger(paiGrid:GetChild(k).gameObject, this.OnClickCard);
			end
		end
	end
	RecordTiShi = gameObject.transform:Find('RecordTiShi');
	ButtonChat = gameObject.transform:Find('ButtonChat');
	ButtonSound = gameObject.transform:Find('ButtonSound');
	ButtonCapitulate = gameObject.transform:Find('ButtonCapitulate');
	ButtonHorizontal = gameObject.transform:Find('ButtonHorizontal');
	ButtonInvite = gameObject.transform:Find('bottomButtons/ButtonInvite');
	ButtonHelp = gameObject.transform:Find('CountDown/ButtonHelp');
	ButtonPlay = gameObject.transform:Find('CountDown/ButtonPlay');
	ButtonPass = gameObject.transform:Find('CountDown/ButtonPass');
	ButtonCloseRoom = gameObject.transform:Find('bottomButtons/ButtonCloseRoom')
	ButtonExitRoom = gameObject.transform:Find('bottomButtons/ButtonExitRoom')
	readybtn = gameObject.transform:Find("readybtn")
	this.Awake1()
end

function this.Awake1()
	fangHeShou = gameObject.transform:Find('fangHeShou')
	TrusteeshipTip = gameObject.transform:Find('TrusteeshipTip')
	TrusteeshipPanel = gameObject.transform:Find('TrusteeshipPanel')
	message:AddClick(TrusteeshipPanel.transform:Find('CancelTrusteeshipBtn').gameObject, this.OnClickCancelTrustesship)
	curPai = gameObject.transform:Find("cutCard")

	PlayNiaoView = gameObject.transform:Find('PlayNiaoView')
    PlayNiao = PlayNiaoView.transform:Find('PlayNiao')
    NotNiao = PlayNiaoView.transform:Find('NotNiao')

	bg = gameObject.transform:Find("bg")
	bg1 = gameObject.transform:Find("bg1")
	bg2 = gameObject.transform:Find("bg2")
	bg3 = gameObject.transform:Find("bg3")
	bg4 = gameObject.transform:Find("bg4")
	
	--刷新按钮   更多按钮
	ButtonRefresh = gameObject.transform:Find('topbg/btn/ButtonRefresh');
	ButtonMore = gameObject.transform:Find('topbg/btn/ButtonMore');
	message:AddClick(ButtonRefresh.gameObject, this.OnClickButtonRefresh)
	message:AddClick(ButtonMore.gameObject, this.OnClickButtonSetting)

	message:AddClick(PlayNiao.gameObject, this.OnClickPlayNiao)
	message:AddClick(NotNiao.gameObject, this.OnClickPlayNiao)
	--包庄界面
	baoZhuangView = gameObject.transform:Find('baoZhuangView');
	message:AddClick(baoZhuangView:Find('bao').gameObject, this.OnClickBaoZhuang)
	message:AddClick(baoZhuangView:Find('buBao').gameObject, this.OnClickBaoZhuang)
	--积分界面
	scoreView.transform = gameObject.transform:Find('scoreView');
	scoreView.allScore = {}--大面板积分
	scoreView.allScore.transform = scoreView.transform:Find('allScore');
	scoreView.allScore.players = {}
	for i=0,3 do
		scoreView.allScore.players[i]={}
		scoreView.allScore.players[i].gameObject = scoreView.allScore.transform:Find('play'..i).gameObject
		scoreView.allScore.players[i].transform = scoreView.allScore.transform:Find('play'..i)
		scoreView.allScore.players[i].name = scoreView.allScore.players[i].transform:Find('name')
		scoreView.allScore.players[i].history = scoreView.allScore.players[i].transform:Find('history')
		scoreView.allScore.players[i].now = scoreView.allScore.players[i].transform:Find('now')
		scoreView.allScore.players[i].happyScore = scoreView.allScore.players[i].transform:Find('happyScore')
	end
	scoreView.score = {}--当前牌面分
	scoreView.score.transform = scoreView.transform:Find('score');
	scoreView.score.scoreLabel = scoreView.score.transform:Find('scoreLabel')

	selectOutCardType = gameObject.transform:Find('selectOutCardType');
	selectOutCardTypeBG = gameObject.transform:Find('selectOutCardType/bg');
	selectCardGrid = gameObject.transform:Find('selectOutCardType/outcard');
	for i = 0, 5 do
		selectOutCardGrid[i]  = gameObject.transform:Find('selectOutCardType/outcard/'..i);
		selectOutCardTypeGrid[i]  = gameObject.transform:Find('selectOutCardType/outcard/'..i..'/GridOut');
		selectOutCardTypeGridDaizi[i] = gameObject.transform:Find('selectOutCardType/outcard/'..i..'/dai');
		message:AddClick(selectOutCardGrid[i].gameObject, this.OnClickSelectOutCardType)
	end
	this.changeBG(UnityEngine.PlayerPrefs.GetInt('ground_xhzd', 1))
	message:AddClick(ButtonChat.gameObject, this.OnClickButtonChat);
	message:AddPress(ButtonSound.gameObject, this.OnPressButtonSound);
	message:AddClick(ButtonCapitulate.gameObject, this.OnClickButtonCapitulate);
	message:AddClick(ButtonHorizontal.gameObject, this.OnClickButtonHorizontal);
	message:AddClick(ButtonInvite.gameObject, this.ShowPanelShare)
	message:AddClick(ButtonCloseRoom.gameObject, this.OnClicButtonCloseRoom)
	message:AddClick(ButtonExitRoom.gameObject, this.OnClicButtonLeaveRoom)
	message:AddClick(ButtonHelp.gameObject, this.OnClickButtonHelp);
	message:AddClick(ButtonPlay.gameObject, this.OnClickButtonPlay);
	message:AddClick(ButtonPass.gameObject, this.OnClickOnButtonPass);
	message:AddClick(onClickWidget.gameObject, this.OnClickBG);
	message:AddClick(readybtn.gameObject, this.OnClickReady);
	panelShare = gameObject.transform:Find('panelShare');
    message:AddClick(panelShare:Find('xianLiao').gameObject, this.OnClickButtonXLInvite)
    message:AddClick(panelShare:Find('friendGroup').gameObject, this.OnClickButtonInvite)
    message:AddClick(panelShare:Find('copy').gameObject, this.OnClicButtonCopy)
    message:AddClick(panelShare:Find('ButtonClose').gameObject, this.ClosePanelShare)
	message:AddClick(panelShare:Find('mask').gameObject, this.ClosePanelShare)
	message:AddClick(selectOutCardTypeBG.gameObject, this.CloseSelectOutCardType)
	batteryLevel = gameObject.transform:Find('battery/level'):GetComponent('UISprite')
	network = gameObject.transform:Find('network'):GetComponent('UISprite')
	pingLabel = gameObject.transform:Find('ping'):GetComponent('UILabel')
	RegisterGameCallBack(xhzd_pb.PONG, this.OnPong)
	message:AddPress(network.gameObject, function (go, state)
		pingLabel.gameObject:SetActive(state)
	end)
end

function this.Start()
	GPS = gameObject.transform:Find('GPS')
	this.GetDistanceUI()
	coroutine.start(RefreshTime, roomTime:GetComponent('UILabel'), 60)
	if refreshStateCoroutine then
		coroutine.stop(refreshStateCoroutine)
	end
	refreshStateCoroutine = coroutine.start(this.RefreshState)
	for i=1,16 do
		local pai = playerGridInHorizontal[i]
		pai.transform:Find('bg'):GetComponent('UISprite').depth = 30+i
		pai.transform:Find('type'):GetComponent('UISprite').depth = 31+i
		pai.transform:Find('typeSmall'):GetComponent('UISprite').depth = 31+i
		pai.transform:Find('num'):GetComponent('UISprite').depth = 31+i
		pai.transform:Find('typeBig'):GetComponent('UISprite').depth = 32+i
	end
	for i = 17, #playerGridInHorizontal do
		local pai = playerGridInHorizontal[i]
		pai.transform:Find('bg'):GetComponent('UISprite').depth = i
		pai.transform:Find('type'):GetComponent('UISprite').depth = i+1
		pai.transform:Find('typeSmall'):GetComponent('UISprite').depth = i+1
		pai.transform:Find('num'):GetComponent('UISprite').depth = i+1
		pai.transform:Find('typeBig'):GetComponent('UISprite').depth = i+2
	end
end

function this.GetDistanceUI()
    --用户信息
    for i = 0, 3 do
        PlayerUIObjs[i] = {};
        PlayerUIObjs[i].transform = GPS:Find("Players/Player"..i);
        PlayerUIObjs[i].Name = PlayerUIObjs[i].transform:Find("Name");
    end
    --距离信息
    for i = 1, 6 do
        DistanceObjs[i] = {};
        DistanceObjs[i].transform = GPS:Find("Distance"..i);
        DistanceObjs[i].disLabel = DistanceObjs[i].transform:Find("Label");
    end
end
function this.WhoShow(data)
	gameObject:SetActive(false)
	this.SetMyAlpha(1)
	this.OnRoundStarted = nil
	PanelManager.Instance:HideAllWindow()
	gameObject:SetActive(true)
	for i = 0,3 do
		scoreView.allScore.players[i].now:GetComponent('TweenPosition').enabled = false
	end
	XHZDIsHorizontalCards = UnityEngine.PlayerPrefs.GetInt('XHZDIsHorizontalCards', 0) == 1
	if XHZDIsHorizontalCards then
		ButtonHorizontal:Find("lb"):GetComponent('UILabel').text = '竖牌'
	else
		ButtonHorizontal:Find("lb"):GetComponent('UILabel').text = '横牌'
	end
	this.OnClickBG(onClickWidget.gameObject)
	this.ClearnSelectCard()
end

function this.OnEnable()
	selectCards = {}
    PanelManager.Instance:HideWindow('panelLobby')
    PanelManager.Instance:HideWindow('panelClub')
	panelInGame = panelInGame_xhzd
    panelInGame.needXiPai=false
	
    isIngame = true
	if panelClub then
		panelClub.isInClub=false
	end
	
	scoreView.allScore.transform.gameObject:SetActive(false)
	scoreView.score.transform.gameObject:SetActive(false)
	scoreView.transform.gameObject:SetActive(false)
	PlayNiaoView.gameObject:SetActive(false)
	for i = 0, 3 do
		playerNiao[i].gameObject:SetActive(false)
	end
	this.RegisterGameCallBack()
	if conMarquee then
		coroutine.stop(conMarquee)
	end
	connect = NetWorkManager.Instance:CreateConnect('game');
    connect.IP = GetServerIPorTag(false, roomInfo.host)
	connect.Port = roomInfo.port
	connect.GroupName = ConfigManager.getProperty('ProxyServer', 'GroupName', '');
    connect.onConnectLua = this.OnConnect
    connect.disConnectLua = this.OnDisconnect
    connect.rspCallBackLua = receiveGameMessage;
	connect.reConnectNum = ConfigManager.getIntProperty('Setting', 'ReconnectNum', 5)
    connect:Connect();
	connect.heartBeatInterval = 5;
	
	this.StartCheckNetState()
	AudioManager.Instance:PlayMusic('ZD_Bgm', true)
	this.ClearRoom()
	for i = 0, 3 do
		playerTrusteeship[i].gameObject:SetActive(false)
		playerOfflineTime[i].gameObject:SetActive(false)
	end
	if panelChat then
        panelChat.ClearChat()
	end
end

function this.Update()
end

function this.RegisterGameCallBack()
	ClearGameCallBack()
    RegisterGameCallBack(xhzd_pb.PLAYER_ENTER, this.OnPlayerEnter)
	RegisterGameCallBack(xhzd_pb.PLAYER_JOIN, this.OnPlayerJion)
	RegisterGameCallBack(xhzd_pb.LEAVE_ROOM, this.OnLeaveRoom)
	RegisterGameCallBack(xhzd_pb.PLAYER_LEAVE, this.OnPlayerLeave)
	RegisterGameCallBack(xhzd_pb.ROUND_START, this.OnRoundStart)
    RegisterGameCallBack(xhzd_pb.LORD_DISSOLVE, this.OnLordDissolve)
	RegisterGameCallBack(xhzd_pb.ROUND_END, this.OnRoundEnd)
	RegisterGameCallBack(xhzd_pb.READY, this.OnReady)
	RegisterGameCallBack(xhzd_pb.PLAY, this.OnPlayerPlay)
	RegisterGameCallBack(xhzd_pb.PASS, this.OnPlayerPass)
	RegisterGameCallBack(xhzd_pb.DESTROY, this.Destroy)
	RegisterGameCallBack(xhzd_pb.DISSOLVE, this.OnDissolve)
	RegisterGameCallBack(xhzd_pb.SEND_CHAT, this.OnSendChat)
	RegisterGameCallBack(xhzd_pb.DISCONNECTED, this.OnDisconnected)
	RegisterGameCallBack(xhzd_pb.VOICE_MEMBER, this.OnVoiceMember)
	RegisterGameCallBack(xhzd_pb.NO_ROOM, this.OnRoomNoExist)
	RegisterGameCallBack(xhzd_pb.ENTER_ERROR, this.OnRoomError)
	RegisterGameCallBack(xhzd_pb.WAIT_CUT_CARD, this.OnWaitCutCard)
	RegisterGameCallBack(xhzd_pb.CUT_CARD, this.OnCutCard)
	RegisterGameCallBack(xhzd_pb.WAIT_WRAP_BANKER, this.OnWaitBaoZhuang)
	RegisterGameCallBack(xhzd_pb.WRAP_BANKER, this.OnBaoZhuangResult)
	RegisterGameCallBack(xhzd_pb.AGAIN_SCORE_ANI, this.OnScoreListAgain)
	RegisterGameCallBack(xhzd_pb.HAPPLY_ANI, this.OnScoreListHapply)
	RegisterGameCallBack(xhzd_pb.WAIT_PLAY, this.FristWhoChuPai)
	RegisterGameCallBack(xhzd_pb.CHANGE_SEAT, this.ChangeSeat)
	RegisterGameCallBack(xhzd_pb.GAME_OVER, this.OnGameOver)
	RegisterGameCallBack(xhzd_pb.DISARM, this.OnCapitulate)
	RegisterGameCallBack(xhzd_pb.DISARM_ERROR, this.OnCapitulateError)
	RegisterGameCallBack(xhzd_pb.PLAY_ERROR, this.OnPlayError)
	RegisterGameCallBack(xhzd_pb.GIFT, this.OnPlayerEmoji)
	RegisterGameCallBack(xhzd_pb.AUTO_DISSOLVE, this.OnAutoDissolve)

	RegisterGameCallBack(xhzd_pb.DISSOLVE_LIMIT_TIMES_ERROR, this.OnDissolveError)
	RegisterGameCallBack(xhzd_pb.DISSOLVE_UNABLE_ERROR, this.OnDissolveNotAllowed)
	RegisterGameCallBack(xhzd_pb.DISSOLVE_LIMIT_SECONDS_ERROR, this.OnDissolveTimeTooShort)

	RegisterGameCallBack(xhzd_pb.TRUSTEESHIP,this.OnTrustesship)

	RegisterGameCallBack(xhzd_pb.DA_NIAO,this.OnDaNiao)
	RegisterGameCallBack(xhzd_pb.WAIT_NIAO,this.OnWaitNiao)

	RegisterGameCallBack(xhzd_pb.OVERTIME_DISSOLVE,this.OnOverTimeDissolve)
end

function this.OnDaNiao(msg)
	print('收到打鸟..................')
	local body = xhzd_pb.RWaitNiao()
	body:ParseFromString(msg.body)
	if body.isNiao then
		local index = this.GetUIIndexBySeat(body.seat)
		playerNiao[index].gameObject:SetActive(true)
	end
	if body.seat == mySeat then
		PlayNiaoView.gameObject:SetActive(false)
		this.StopTrustesship()
	end
end

function this.OnWaitNiao(msg)
	print('打鸟.................')
	this.SetInviteVisiable(false)
	PlayNiaoView.gameObject:SetActive(true)
	this.SetDelegateCount(mySeat)
end

function this.OnClickPlayNiao(go)
	local isNiao =false
	if go == PlayNiao.gameObject then
		isNiao=true
	end
	PlayNiaoView.gameObject:SetActive(false)
	local msg = Message.New()
	msg.type = xhzd_pb.DA_NIAO
	local body = xhzd_pb.PWaitNiao()
	body.isNiao = isNiao
	msg.body = body:SerializeToString();
	SendGameMessage(msg, nil)
end
--疲劳值不足自动解散房间
function this.OnAutoDissolve(msg)
	print('疲劳值不足自动解散房间')
	local body = xhzd_pb.RAutoDissolve()
    body:ParseFromString(msg.body)

    IsAutoDissolve = true
    AutoDissolveData = body
end

function this.OnClickButtonRefresh(GO)
	AudioManager.Instance:PlayAudio('btn')
	PanelManager.Instance:RestartGame()
end

function this.changeBG(ground)
	if ground == 1 then
		bg:GetComponent('UITexture').mainTexture = bg1:GetComponent('UITexture').mainTexture
	elseif ground == 2 then
		bg:GetComponent('UITexture').mainTexture = bg2:GetComponent('UITexture').mainTexture
	elseif ground == 3 then
		bg:GetComponent('UITexture').mainTexture = bg3:GetComponent('UITexture').mainTexture
	elseif ground == 4 then
		bg:GetComponent('UITexture').mainTexture = bg4:GetComponent('UITexture').mainTexture
	end
end
function this.OnClickButtonSetting(go)
	AudioManager.Instance:PlayAudio('btn')
	local sendData = {};
	sendData.roomData = roomData;
	local  isallready = true
	for i=1,#playerData do
		if playerData[i].ready == false then
			isallready = false
			break;
		end
	end
	if roomData.round > 1 or isallready  then
		sendData.ingame = true;
		PanelManager.Instance:ShowWindow('panelGameSetting_xhzd', sendData)
	else
		if mySeat == 0 then
			sendData.ingame = false;
			PanelManager.Instance:ShowWindow('panelGameSetting_xhzd', sendData)
		else
			sendData.ingame = false;
			PanelManager.Instance:ShowWindow('panelGameSetting_xhzd', sendData)
		end
	end
end

function this.OnClickReady(go)
	local msg = Message.New()
	msg.type = xhzd_pb.READY
	SendGameMessage(msg, nil)
	go.gameObject:SetActive(false)
end

function this.RefreshTime(labelTime)
    while true do
        if restTime > 0 then
            labelTime.text = os.date("%M:%S", restTime) --getDaoJiShi(timeChuo)--os.date("%M:%S")
            restTime = restTime - 1
        end
        coroutine.wait(1)
    end
end

function this.FristWhoChuPai(msg)
	--第一次谁出牌
	local data = xhzd_pb.RWaitPlay()
	data:ParseFromString(msg.body)
	roomData.activeSeat = data.seat
	this.setFangHeShou(false)
	this.SetDelegateCount(roomData.activeSeat)
	this.SetCountDownVisiable()
	local index = this.GetUIIndexBySeat(data.seat)
	for i = 0, 3 do
		if i==index then
			playerKuang[i].gameObject:SetActive(true)
		else
			playerKuang[i].gameObject:SetActive(false)
		end
	end
	ButtonCapitulate.gameObject:SetActive(roomData.setting.size==4);
	if roomData.setting.size == 2 then
		StartCoroutine(function()
			WaitForSeconds(1.5)
			this.RefreshMyGridIn()
			ButtonHorizontal.gameObject:SetActive(true)
			AudioManager.Instance:PlayAudio('gameStart07')
			local mycard={trueValues={data.cardValue},type={GetPlateType(data.cardValue)},value=GetPlateNum(data.cardValue)+2}
			this.setPai(curPai.gameObject,mycard,1)
			local positionTo = playerIcon[this.GetUIIndexBySeat(data.seat)].position
			curPai.gameObject:SetActive(true)
			TweenPosition.Begin(curPai.gameObject, 1, positionTo, true)
			TweenScale.Begin(curPai.gameObject, 1, Vector3(0.51,0.56,1))
			WaitForSeconds(4)
			curPai.position=Vector3.zero
			curPai.gameObject:SetActive(false)
		end)
	end
end
function this.ChangeSeat(msg)
	--都选择不包庄后交换位置
	local data = xhzd_pb.RChangeSeat()
	data:ParseFromString(msg.body)
	coroutine.start(
		function()
			panelMessageTip.SetParamers('交换位置中，请稍等...', 1)
			PanelManager.Instance:ShowWindow('panelMessageTip')
			coroutine.wait(1)
			mySeat = data.seat
			for i=1,#data.players do
				local play = data.players[i]
				playerData[play.seat] = play
			end
			print("我的座位号是",mySeat)
			DestroyRoomData.playerData = playerData
			DestroyRoomData.mySeat = data.seat
			this.RefreshPlayer()
			this.UpdateScoreView(data.scoreList,false)
		end
	)
end

function this.OnScoreListAgain(msg)
	local data = xhzd_pb.RScoreListAgain()
	print('收到分数消息')
	data:ParseFromString(msg.body)
	this.UpdateScoreView(data.scores,true)
	AudioManager.Instance:PlayAudio('addScore')
end
function this.OnScoreListHapply(msg)
	local data = xhzd_pb.RScoreListHapply()
	print('收到喜分消息')
	data:ParseFromString(msg.body)
	this.UpdateScoreView(data.scores,false)
	AudioManager.Instance:PlayAudio('addScore')
end
function this.UpdateScoreView(scoreList,isFristEnd)
	if scoreList ~= nil and #scoreList >0 then
		for i=1,#scoreList do
			if playerData[scoreList[i].seat].WrapBankerType==xhzd_pb.YES_WRAP_BANKER then
				scoreView.allScore.players[i-1].name:GetComponent('UILabel').text ='[ff6600](庄)[-]'..playerData[scoreList[i].seat].name
			else
				scoreView.allScore.players[i-1].name:GetComponent('UILabel').text = playerData[scoreList[i].seat].name
			end
			
			scoreView.allScore.players[i-1].history:GetComponent('UILabel').text = scoreList[i].historyScore
			if scoreList[i].roundScore ~= 0 and scoreList[i].roundScore ~= tonumber(scoreView.allScore.players[i-1].now:GetComponent('UILabel').text) then
				scoreView.allScore.players[i-1].now:GetComponent('UILabel').color = Color.red
				scoreView.allScore.players[i-1].now:GetComponent('TweenPosition').enabled = true
				local pos = scoreView.allScore.players[i-1].now.transform.localPosition
				coroutine.start(
					function()
						coroutine.wait(2)
						scoreView.allScore.players[i-1].now:GetComponent('TweenPosition').enabled = false
						scoreView.allScore.players[i-1].now:GetComponent('UILabel').color = Color.white
						scoreView.allScore.players[i-1].now.transform.localPosition = pos
					end
				)
			end
			scoreView.allScore.players[i-1].now:GetComponent('UILabel').text = scoreList[i].roundScore
			scoreView.allScore.players[i-1].happyScore:GetComponent('UILabel').text = scoreList[i].happyScore
			scoreView.allScore.players[i-1].gameObject:SetActive(true);
			local index = this.GetUIIndexBySeat(scoreList[i].seat)
			playerScore[index].transform:GetComponent('UILabel').text = scoreList[i].roundScore
		end
		if isFristEnd then
			scoreView.score.scoreLabel:GetComponent('UILabel').text = 0
		end
		for j = #scoreList, #scoreView.allScore.players do
			if j<=#scoreView.allScore.players then
				scoreView.allScore.players[j].gameObject:SetActive(false);
			end
		end
	end
end

function this.OnPlayError(msg)
	--print('OnPlayError : 出牌错误 ');
	panelMessageTip.SetParamers('出牌错误', 2)
	PanelManager.Instance:ShowWindow('panelMessageTip')
	CountDown.gameObject:SetActive(true)
end

function this.OnCutCard(msg)
	local data = xhzd_pb.RCutCard()
	data:ParseFromString(msg.body)
	this.StopTrustesship()
	print('收到切牌消息 : '..data.seat)
	if panelCutCard then
		panelCutCard.onGetCutResult(data)
		StartCoroutine(function()
			WaitForSeconds(1)
			PanelManager.Instance:HideWindow('panelCutCard')
		end)
	end
	this.SetInviteVisiable(false)
end

function this.OnWaitCutCard(msg)
	local data = xhzd_pb.RWaitCutCard()
	data:ParseFromString(msg.body)
	if panelInGame.needXiPai==true then
		panelInGame.needXiPai=false
		connect.IsZanTing=true
		PanelManager.Instance:ShowWindow('panelXiPai_poker',function()
			this.qiePai(data)
			connect.IsZanTing=false
		end)
	else
		this.qiePai(data)	
	end
end

function this.qiePai(data)
	if data.seat == mySeat then
		this.SetDelegateCount(data.seat)
	end
	this.showPanelCutCard(data.seat,43)
	RestTime.gameObject:SetActive(false)
	GPS.gameObject:SetActive(false)
	this.SetInviteVisiable(false)
	print('等待切牌 : '..data.seat)
	for i = 0, 3 do
		playerReady[i].gameObject:SetActive(false)
	end
end

function this.showPanelCutCard(seat,cutPostion)
	local shuJu = {
					isMeCut=seat==mySeat,
					name=this.GetPlayerDataBySeat(seat).name,
					endX=cutPostion
					}
	PanelManager.Instance:ShowWindow('panelCutCard',shuJu)
end

function this.OnBaoZhuangResult(msg)
	print('收到包庄消息')
	this.StopTrustesship()
	local data = xhzd_pb.RWrapBanker()
	data:ParseFromString(msg.body)
	baoZhuangView.gameObject:SetActive(false)
	local index = this.GetUIIndexBySeat(data.seat)
	playerData[data.seat].WrapBankerType = data.WrapBankerType
	if data.WrapBankerType == xhzd_pb.YES_WRAP_BANKER then
		this.setFangHeShou(false)
		for i = 0,3  do
			if scoreView.allScore.players[i].name:GetComponent('UILabel').text == playerData[data.seat].name then
				scoreView.allScore.players[i].name:GetComponent('UILabel').text = '[ff6600](庄)[-]'..playerData[data.seat].name
			end
		end
		StartCoroutine(
		function()
			playerBaoZhuang[index]:GetComponent('UISprite').spriteName = 'sp_包庄';
			playerBaoZhuang[index]:GetComponent('UISprite'):MakePixelPerfect()
			playerBaoZhuang[index].gameObject:SetActive(true);
			playerBaoZhuang[index].gameObject:GetComponent('TweenScale').from = Vector3(0,0,0)
			playerBaoZhuang[index].gameObject:GetComponent('TweenScale').to = Vector3(1,1,1)
			playerBaoZhuang[index].gameObject:GetComponent('TweenScale').duration = 0.8
			playerBaoZhuang[index].gameObject:GetComponent('TweenScale'):ResetToBeginning()
			playerBaoZhuang[index].gameObject:GetComponent('TweenScale'):PlayForward()
			playerBaoZhuang[index].gameObject:GetComponent('TweenAlpha').from = 0
			playerBaoZhuang[index].gameObject:GetComponent('TweenAlpha').to = 1
			playerBaoZhuang[index].gameObject:GetComponent('TweenAlpha').duration = 0.8
			playerBaoZhuang[index].gameObject:GetComponent('TweenAlpha'):ResetToBeginning()
			playerBaoZhuang[index].gameObject:GetComponent('TweenAlpha'):PlayForward()
			WaitForSeconds(0.8)
			playerBaoZhuang[index].gameObject:GetComponent('TweenAlpha').from = 1
			playerBaoZhuang[index].gameObject:GetComponent('TweenAlpha').to = 0
			playerBaoZhuang[index].gameObject:GetComponent('TweenAlpha').duration = 0.7
			playerBaoZhuang[index].gameObject:GetComponent('TweenAlpha'):ResetToBeginning()
			playerBaoZhuang[index].gameObject:GetComponent('TweenAlpha'):PlayForward()
		end
		)
		playerMaster[index].gameObject:SetActive(true)
	elseif data.WrapBankerType == xhzd_pb.NO_WRAP_BANKER then
		StartCoroutine(
		function()
			if data.seat==mySeat then
				this.setFangHeShou(false)
			end
			playerBaoZhuang[index]:GetComponent('UISprite').spriteName = 'sp_不包庄';
			playerBaoZhuang[index]:GetComponent('UISprite'):MakePixelPerfect()
			playerBaoZhuang[index].gameObject:SetActive(true);
			playerBaoZhuang[index].gameObject:GetComponent('TweenScale').from = Vector3(0,0,0)
			playerBaoZhuang[index].gameObject:GetComponent('TweenScale').to = Vector3(1,1,1)
			playerBaoZhuang[index].gameObject:GetComponent('TweenScale').duration = 0.8
			playerBaoZhuang[index].gameObject:GetComponent('TweenScale'):ResetToBeginning()
			playerBaoZhuang[index].gameObject:GetComponent('TweenScale'):PlayForward()
			playerBaoZhuang[index].gameObject:GetComponent('TweenAlpha').from = 0
			playerBaoZhuang[index].gameObject:GetComponent('TweenAlpha').to = 1
			playerBaoZhuang[index].gameObject:GetComponent('TweenAlpha').duration = 0.8
			playerBaoZhuang[index].gameObject:GetComponent('TweenAlpha'):ResetToBeginning()
			playerBaoZhuang[index].gameObject:GetComponent('TweenAlpha'):PlayForward()
			WaitForSeconds(0.8)
			playerBaoZhuang[index].gameObject:GetComponent('TweenAlpha').from = 1
			playerBaoZhuang[index].gameObject:GetComponent('TweenAlpha').to = 0
			playerBaoZhuang[index].gameObject:GetComponent('TweenAlpha').duration = 0.7
			playerBaoZhuang[index].gameObject:GetComponent('TweenAlpha'):ResetToBeginning()
			playerBaoZhuang[index].gameObject:GetComponent('TweenAlpha'):PlayForward()
		end
		)
	else
		playerBaoZhuang[index]:GetComponent('UISprite').spriteName = '';
	end
end

function this.setFangHeShou(hideCard)
	if roomData.setting.size == 4 then
		if hideCard==true then
			ButtonHorizontal.gameObject:SetActive(false)
			GridInHorizontal.gameObject:SetActive(false)
			playerGridIn[0].gameObject:SetActive(false)
			fangHeShou.gameObject:SetActive(true)
		else
			ButtonHorizontal.gameObject:SetActive(roomData.state == xhzd_pb.GAMING or roomData.state == xhzd_pb.WRAPPING)
			GridInHorizontal.gameObject:SetActive(XHZDIsHorizontalCards)
			playerGridIn[0].gameObject:SetActive(not XHZDIsHorizontalCards)
			fangHeShou.gameObject:SetActive(false)
		end
	end	
end

function this.OnWaitBaoZhuang(msg)
	local data = xhzd_pb.RWaitWrapBanker()
	data:ParseFromString(msg.body)
	print('OnWaitBaoZhuang 到谁包庄....... : ',data.seat..'  showCutCard : '..tostring(data.showCutCard))
	if data.showCutCard==true then
		StartCoroutine(function()
			WaitForSeconds(1.5)
			this.RefreshMyGridIn()
			if data.seat==mySeat  then
				baoZhuangView.gameObject:SetActive(true)
			else
				this.setFangHeShou(true)
			end
			AudioManager.Instance:PlayAudio('gameStart07')
			local mycard={trueValues={data.card},type={GetPlateType(data.card)},value=GetPlateNum(data.card)+2}
			this.setPai(curPai.gameObject,mycard,1)
			local positionTo = playerIcon[this.GetUIIndexBySeat(data.seat)].position
			curPai.gameObject:SetActive(true)
			TweenPosition.Begin(curPai.gameObject, 1, positionTo, true)
			TweenScale.Begin(curPai.gameObject, 1, Vector3(0.51,0.56,1))
			WaitForSeconds(4)
			curPai.position=Vector3.zero
			curPai.gameObject:SetActive(false)
		end)
	else
		if data.seat==mySeat  then
			baoZhuangView.gameObject:SetActive(true)
			this.setFangHeShou(false)
		end
	end
	if data.seat==mySeat  then
		this.SetDelegateCount(data.seat)
	end
	local index = this.GetUIIndexBySeat(data.seat)
	for i = 0, 3 do
		if i==index then
			playerKuang[i].gameObject:SetActive(true)
		else
			playerKuang[i].gameObject:SetActive(false)
		end
	end
end

function this.OnClickBaoZhuang(go)
	AudioManager.Instance:PlayAudio('btn')
	local msg = Message.New()
	msg.type = xhzd_pb.WRAP_BANKER
	local body = xhzd_pb.PWrapBanker()
	if go.name=='bao' then
		panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
			body.WrapBankerType = xhzd_pb.YES_WRAP_BANKER
			msg.body = body:SerializeToString();
			SendGameMessage(msg, nil)
		end, nil, "是否确定要包庄？")
		PanelManager.Instance:ShowWindow('panelMessageBoxTiShi');
	else
		body.WrapBankerType = xhzd_pb.NO_WRAP_BANKER
		msg.body = body:SerializeToString();
		SendGameMessage(msg, nil)
	end
	
end

function this.OnRoomError(msg)
    panelMessageTip.SetParamers('加入房间错误', 2)
    PanelManager.Instance:ShowWindow('panelMessageTip')
    coroutine.start(
    function()
		coroutine.wait(2)
		panelLogin.HideGameNetWaitting();
        if roomData.clubId ~= '0' then
            local data = {}
            data.name = 'panelInGame_xhzd'
            PanelManager.Instance:ShowWindow('panelClub', data)
        else
            PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
		end
		roomData.clubId = '0'
		this.Destroy()
    end
    )
end
function this.OnRoomNoExist(msg)
    panelMessageTip.SetParamers('房间已解散', 2)
    PanelManager.Instance:ShowWindow('panelMessageTip')
    coroutine.start(
    function()
		coroutine.wait(2)
		panelLogin.HideGameNetWaitting();
        if roomData.clubId ~= '0' then
            local data = {}
            data.name = 'panelInGame_xhzd'
            PanelManager.Instance:ShowWindow('panelClub', data)
        else
            PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
		end
		roomData.clubId = '0'
		this.Destroy()
    end
    )
end

function this.OnConnect()
	this.JionRoom()
end

function this.OnDisconnect()
	connect.IP = GetServerIPorTag(false,roomInfo.host)
	connect.Port = roomInfo.port
    print('网络连接断开。。。。。。。。。。。')
end

function this.CheckNetState()
	print('panelInGame.CheckNetState')
	coroutine.wait(1)
	while gameObject.activeSelf and this.needCheckNet==true do
		if connect.IsReConnect then
			print("进入重连状态..................................")
			PanelManager.Instance:ShowWindow('panelGameNetWaitting')
		elseif  not connect.IsConnect then
			print("进入网络断开状态..................................")
			PanelManager.Instance:HideWindow('panelGameNetWaitting')
			panelLogin.HideAllNetWaitting()
			panelMessageBoxTiShi.SetParamers(OK_CANCLE, this.OnNetCheckButtonOK, this.OnNetCheckButtonCancle, '网络连接失败，是否继续连接？')
			PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
			break
		elseif connect.IsConnect then
			PanelManager.Instance:HideWindow('panelGameNetWaitting')
		end
		coroutine.wait(0.5)
	end
end

function this.StopCheckNetState()
	print('StopCheckNetState')
	connect.reConnectNum = 0
    this.needCheckNet=false
	coroutine.stop(connectCor)
end

function this.StartCheckNetState()
    this.needCheckNet=true
	connectCor = coroutine.start(this.CheckNetState)
end

function this.OnNetCheckButtonOK()
	connect.reConnectNum = ConfigManager.getIntProperty('Setting', 'ReconnectNum', 5)
	this.StartCheckNetState()
end

function this.OnNetCheckButtonCancle()
	UnityEngine.Application.Quit()
end

function this.JionRoom()
	local msg 		= Message.New()
	msg.type 		= xhzd_pb.JOIN_ROOM
	local body 		= xhzd_pb.PJoinRoom();
	body.roomNumber = roomInfo.roomNumber
	body.token 		= roomInfo.token
	body.longitude 	= tonumber(UnityEngine.PlayerPrefs.GetFloat("longitude",0));
    body.latitude 	= tonumber(UnityEngine.PlayerPrefs.GetFloat("latitude",0));
	body.address 	= UnityEngine.PlayerPrefs.GetString("address","");
	msg.body = body:SerializeToString();
	SendGameMessage(msg, this.OnJionRoomResult)
end

function this.OnJionRoomResult(msg)
    panelInGame.needXiPai=false
	print('OnJionRoomResult')
	this.ClearRoom()
	for i = 0, 3 do
		playerTrusteeship[i].gameObject:SetActive(false)
		playerOfflineTime[i].gameObject:SetActive(false)
	end
	panelLogin.HideNetWaitting()
	this.fanHuiRoomNumber = roomInfo.roomNumber
	local body = xhzd_pb.RJoinRoom()
	body:ParseFromString(msg.body)
	roomData = body.room
	mySeat = body.seat
	playerData = {}
	for i=1,#body.room.players do
		local p = body.room.players[i]
		playerData[p.seat] = p
	end
	offlineState = false;
	roomID:GetComponent('UILabel').text = roomInfo.roomNumber
	this.OnPlayerHand(nil,nil)
	DestroyRoomData.roomData = roomData
	DestroyRoomData.playerData = playerData
	DestroyRoomData.mySeat = mySeat

	this.myseflDissolveTimes = 0
	if roomData.dissolution.acceptors ~= nil and #roomData.dissolution.acceptors > 0 then
		roomData.dissolution.remainMs = roomData.dissolution.remainMs/1000
		coroutine.start(
		function()
			for i =1,#roomData.dissolution.acceptors do
				if roomData.dissolution.acceptors[i] == roomData.dissolution.applicant then
					table.remove(roomData.dissolution.acceptors, i)
				end
			end
			PanelManager.Instance:HideWindow('panelDestroyRoom')
			PanelManager.Instance:ShowWindow('panelDestroyRoom')
		end
		)
	else
		PanelManager.Instance:HideWindow('panelDestroyRoom')
	end

	if roomData.state == 1 and roomData.clubId ~= "0" and roomData.round == 1  then
        restTime = roomData.time/1000 -- 600 - os.time() + body.room.time
        RestTime:Find("Time"):GetComponent('UILabel').text = os.date("%M:%S", restTime)
        RestTime.gameObject:SetActive(true)
        if RefeshTimeCoroutine == nil then
            RefeshTimeCoroutine = coroutine.start(this.RefreshTime, RestTime:Find("Time"):GetComponent('UILabel'))
        end
    else
        RestTime.gameObject:SetActive(false)
	end
	local setting_gound = getXHZDRuleString(roomData.setting)
	this.SetRoundNum(roomData.round)
	roomSetting:GetComponent('UILabel').text = setting_gound
	roomSetting:GetChild(0):GetComponent('UILabel').text = setting_gound
	gameObject.transform:Find('dsz'):GetComponent('UILabel').text = roomData.playName
	gameObject.transform:Find('dsz'):GetChild(0):GetComponent('UILabel').text = roomData.playName
	ButtonExitRoom.parent:GetComponent("UIGrid"):Reposition()
	this.RefreshMyGridIn()
    this.SetReadyVisiable()
	this.RefreshPlayer()
	this.GPSRefresh()
	for i = 1, #roomData.scores do
		this.UpdateScoreView(roomData.scores)
	end
	scoreView.score.scoreLabel:GetComponent('UILabel').text = roomData.smallRoundScore
	scoreView.score.transform.gameObject:SetActive(true)
	scoreView.allScore.transform.gameObject:SetActive(true)
	scoreView.transform.gameObject:SetActive(true)
	lastFindCards = {}
	selectCards = {}
	helpNumWhenHaveOneCard = 0
	
	RoundAllData.over = false
    if Util.GetPlatformStr() ~= 'win' then
		print('开始语音poll！！！！！！！！！！')
		if GvoiceCor then
			StopCoroutine(GvoiceCor)
		end
		GvoiceCor = StartCoroutine(this.TickNGCloudVoice)
		NGCloudVoice.Instance:ApplyMessageKey()
	end
	if roomData.round == 1  then
        local longitude = UnityEngine.PlayerPrefs.GetFloat("longitude",0)
        local latitude = UnityEngine.PlayerPrefs.GetFloat("latitude",0)
        local address = UnityEngine.PlayerPrefs.GetString("address","")
        if (longitude == 0 and latitude == 0) and address=="" then 
            panelMessageBox.SetParamers(ONLY_OK,nil,nil,"未允许游戏获取定位");
            PanelManager.Instance:ShowWindow("panelMessageBox");
        end
	end
	print('roomData.activeSeat : '..roomData.activeSeat..'  mySeat : '..mySeat..'  roomData.state : '..roomData.state)
	if roomData.state ~= xhzd_pb.CUTING and panelCutCard then
		PanelManager.Instance:HideWindow('panelCutCard')
	end
	this.setFangHeShou(false)
	if roomData.state == xhzd_pb.CUTING then--切牌中
		this.showPanelCutCard(roomData.activeSeat,roomData.cutPostion)
	elseif roomData.state == xhzd_pb.WRAPPING then--包庄中
		if roomData.activeSeat==mySeat then
			baoZhuangView.gameObject:SetActive(true)
		else
			this.setFangHeShou(playerData[mySeat].WrapBankerType==xhzd_pb.NOT_SELECTED)	
		end
		local index = this.GetUIIndexBySeat(roomData.activeSeat)
		for i = 0, 3 do
			if i==index then
				playerKuang[i].gameObject:SetActive(true)
			else
				playerKuang[i].gameObject:SetActive(false)
			end
		end
	end
	--刷新出牌信息
	if roomData.state == xhzd_pb.GAMING then
		ButtonCapitulate.gameObject:SetActive(roomData.setting.size==4);
		for i = 0, 3 do
			playerBaoZhuang[i].gameObject:SetActive(false);
		end
		if roomData.disarm ~= nil and #roomData.disarm ~= 0 then
			local capitulateInfo = {}
			capitulateInfo.plays = playerData
			capitulateInfo.time = roomData.disarm.time
			capitulateInfo.seat = roomData.disarm.seat
			capitulateInfo.mySeat = mySeat
			PanelManager.Instance:ShowWindow('panelCapitulate',capitulateInfo)
			coroutine.start(function ()
				while(panelCapitulate == nil)do
					WaitForEndOfFrame()
				end
				for i = 1, #roomData.disarm do
					if roomData.disarm[i].type == xhzd_pb.DISARM_APPLY or  roomData.disarm[i].type == xhzd_pb.DISARM_AGREE then
						panelCapitulate.ShowButton(roomData.disarm[i].seat,mySeat)
					end
				end
			end)
		else
			PanelManager.Instance:HideWindow('panelCapitulate')
		end
		if roomData.latestHand ~= nil and #roomData.latestHand.cards > 0 then
			if roomData.latestSeat ~= roomData.activeSeat then
				this.OnPlayerHand(roomData.latestSeat, roomData.latestHand)
			end
		end
		this.SetInviteVisiable(false)
		this.SetCountDownVisiable()
		for i = 1, #body.room.players do
			local data = body.room.players[i]
			local index = this.GetUIIndexBySeat(data.seat)
			if data.WrapBankerType == xhzd_pb.YES_WRAP_BANKER then
				playerMaster[index].gameObject:SetActive(true)
			else
				playerMaster[index].gameObject:SetActive(false)
			end
			local name ;
			OutCardFinish[index].gameObject:SetActive(true);
			if data.roundOrder == 0 then
				name = '上游'
			elseif data.roundOrder == 1 then
				if roomData.setting.size == 4 then
					name = '二游'
				else
					name = '下游'
				end
			elseif data.roundOrder == 2 then
				name = '三游'
			elseif data.roundOrder == 3 then
				name = '下游'
			else
				name = ''
				OutCardFinish[index].gameObject:SetActive(false);
			end
			OutCardFinish[index]:GetComponent('UISprite').spriteName = name;
			if data.actionState == 2 then
				if roomData.activeSeat ~= mySeat then
					playerzi[index].transform.gameObject:SetActive(true)
					playerzi[index].transform:GetComponent("UISprite").spriteName = 'pass_1'
					playerzi[index].transform:GetComponent('UISprite'):MakePixelPerfect()
				else
					playerzi[index].transform.gameObject:SetActive(false)
				end
			else
				playerzi[index].transform.gameObject:SetActive(false)
			end
		end
	else
		if roomData.round > 1 then
			this.SetInviteVisiable(false)
		else
			this.SetInviteVisiable(#playerData ~= (roomData.setting.size - 1) or (not playerData[mySeat].ready) or not this.IsAllReaded())
		end
	end
	
	if roomData.state == xhzd_pb.ENDING then
		if body.room.endPlayer ~= nil and #body.room.endPlayer>0  then
			local stageRoomInfo 		= {};
			stageRoomInfo.roomNumber 	= roomInfo.roomNumber;
			stageRoomInfo.roomData 		= roomData;
			stageRoomInfo.cardsDark = body.room.cardsDark
			local aaa = {}
			for i = 1, #body.room.endPlayer do
				table.insert(aaa, body.room.endPlayer[i])
				local index = this.GetUIIndexBySeat(body.room.endPlayer[i].seat)
				local isOutCardOneOrTow = false
				if index == 1 or index == 2 then
					isOutCardOneOrTow=true
				end
			end
			stageRoomInfo.playerDatas 	= aaa;
			stageRoomInfo.playerData 	= playerData;
			stageRoomInfo.isInGame = true
			stageRoomInfo.gameOver 	= false;
			stageRoomInfo.isBack 	= true;
			stageRoomInfo.fuc=function()
				connect.IsZanTing=false
			end
			PanelManager.Instance:ShowWindow('panelStageClear_xhzd',stageRoomInfo);
		end
	end

	--托管
	if this.GetPlayerDataBySeat(mySeat).trusteeship then
		TrusteeshipPanel.gameObject:SetActive(true)
		TrusteeshipTip.gameObject:SetActive(false);
		isMySelfTrusteeship=true
	end

	if roomData.state ~= xhzd_pb.READYING and roomData.setting.size == 2 and roomData.setting.niao ~= 0  then
		for i = 1, #body.room.players do
			local player = body.room.players[i]
			local inx = this.GetUIIndexBySeat(player.seat)
			print('player.niao : '..player.niao)
			if player.niao ~= nil then
				if player.niao == 0 and player.seat == mySeat then
					PlayNiaoView.gameObject:SetActive(true)
					this.SetDelegateCount(mySeat)
				elseif player.niao == 1 then
					playerNiao[inx].gameObject:SetActive(true)
				elseif player.niao == 2 then
					playerNiao[inx].gameObject:SetActive(false)
				end
			end
		end
	end
	
end
function this.GetPlayerDataByUIIndex(index)
	local i = index + mySeat
    if i > 0 then
        i = i % (#playerData+1)
	end
	if index > #playerData then
		return nil
	else
		return playerData[i]
	end
end
function this.GetUIIndexBySeat(seat)
    return ((#playerData+1)-mySeat+seat)%(#playerData+1)
end
--刷新玩家信息
function this.RefreshPlayer()
	print('刷新玩家信息')
	for i=0,3 do
		local p = this.GetPlayerDataByUIIndex(i)
		if i <= #playerData and p ~= nil then
			playerInfo[i].gameObject:SetActive(true)
			playerName[i]:GetComponent('UILabel').text = p.name
            coroutine.start(LoadPlayerIcon, playerIcon[i]:GetComponent('UITexture'), p.icon)
			SetUserData(playerIcon[i].gameObject, p)
			playerIcon[i].gameObject:SetActive(true)

			playerScore[i]:GetComponent('UILabel').text = p.score
			print(i..' : '..tostring(p.connected)..' p.disconnectTimes : '..tostring(p.disconnectTimes))
			if p.connected then
				playerOfflineTime[i].gameObject:SetActive(false)
			else
				playerOfflineTime[i].gameObject:SetActive(true)
			end
			if p.disconnectTimes ~= nil and p.disconnectTimes ~= 0 then
				print('aaaaaaaaaaaa');
				this.StartOfflineIncrease(p.seat, p.disconnectTimes)
			end
			if p.cardCount == 1 and p.seat ~= mySeat then
				playerLight[i].gameObject:SetActive(true)
			else
				playerLight[i].gameObject:SetActive(false)
			end
			playerTrusteeship[i].gameObject:SetActive(p.trusteeship)
		else
			playerInfo[i].gameObject:SetActive(false)
			playerName[i]:GetComponent('UILabel').text = ''
			playerIcon[i].gameObject:SetActive(true)
			playerIcon[i]:GetComponent('UITexture').mainTexture = nil
			playerScore[i]:GetComponent('UILabel').text = '0'
			playerGridIn[i].gameObject:SetActive(false)
			playerGridOut[i].gameObject:SetActive(false)
			selectOutCardTypeGridDaizi[i].gameObject:SetActive(false)
			playerGridOutDaiZi[i].gameObject:SetActive(false)
			OutCardZhaDan[i].gameObject:SetActive(false)
			playerMaster[i].gameObject:SetActive(false)
			playerLight[i].gameObject:SetActive(false)
			playerOfflineTime[i].gameObject:SetActive(false)
			playerTrusteeship[i].gameObject:SetActive(false)
			SetUserData(playerIcon[i].gameObject, nil)
		end
		playerSound[i].gameObject:SetActive(false)
	end
end
function this.OutCardSort(hand)
	table.sort(hand.cards)
	local outCardSort = 
	{
		cards ={},
		feiji ={},
		daipai={}
	}
	local fenxicard = this.fenXiCard(hand.cards)
	local cardsNum = #hand.cards
	if hand.category == 2 then
		local daipai1 = {}
		local feiji1 = {}
		for i = 5, 15 do
			if fenxicard[i] then
				local aaaa = fenxicard[i]
				if aaaa.num >=3 then
					for j = 1, 3 do
						table.insert(feiji1, aaaa.trueValues[j])
					end
				end
			end
		end
		daipai1 = this.GetDaiPai(hand.cards,feiji1)
		outCardSort.cards = hand.cards;
		outCardSort.feiji = feiji1;
		outCardSort.daipai = daipai1;
		return outCardSort
	elseif hand.category == 5 then
		local daipai1 = {}
		local feiji1 = {}
		for i = (GetPlateNum(hand.minCard)+2), (GetPlateNum(hand.maxCard)+2) do
			if fenxicard[i] then
				for j = 1, 3 do
					table.insert(feiji1,fenxicard[i].trueValues[j])
				end
			end
		end
		daipai1 = this.GetDaiPai(hand.cards,feiji1)
		outCardSort.cards = hand.cards;
		outCardSort.feiji = feiji1;
		outCardSort.daipai = daipai1;
		return outCardSort
	else
		outCardSort.cards = hand.cards;
		outCardSort.feiji = {};
		outCardSort.daipai = {};
		return outCardSort
	end
end

function this.OnPlayerHand(seat, hand)--显示其他玩家出的牌
    for i=0,#playerGridOut do
		playerGridOut[i].gameObject:SetActive(false)
		selectOutCardTypeGridDaizi[i].gameObject:SetActive(false)
		playerGridOutDaiZi[i].gameObject:SetActive(false)
		playerwenzi[i].gameObject:SetActive(false)
		OutCardZhaDan[i].gameObject:SetActive(false)
    end
    if (not seat) or (not hand) then
        return
	end
	local index = this.GetUIIndexBySeat(seat)
	playerGridOut[index].gameObject:SetActive(true)
	local outcard = {}
	outcard.cards = hand.cards
	outcard.category = hand.category
	outcard.maxCard = hand.maxCard
	outcard.minCard = hand.minCard
	outcard.keyCardCount = hand.keyCardCount
	local isOutCardOneOrTow = false
	if index ==1 or index ==2 then
		isOutCardOneOrTow = true
	end
	print('hand.cards : '..#hand.cards..'  hand.category : '..tostring(hand.category)..'   hand.maxCard : '..hand.maxCard..'   hand.minCard : '
	..hand.minCard..'   hand.keyCardCount : '..hand.keyCardCount..'  index : '..index..'  isOutCardOneOrTow : '..tostring(isOutCardOneOrTow))
	this.RefreshOutGrid(playerGridOut[index],this.OutCardSort(outcard),isOutCardOneOrTow,index,false)
	if hand.category == 6 then
		OutCardZhaDan[index].transform.gameObject:SetActive(true)
		OutCardZhaDanWenZi[index].transform:GetComponent("UILabel").text = string.format( "%d 张",#hand.cards);
		if #hand.cards == 4 then
			OutCardZhaDanWenZiBG[index].transform:GetComponent("UISprite").spriteName = '提示_4炸';
		else
			OutCardZhaDanWenZiBG[index].transform:GetComponent("UISprite").spriteName = '提示_4炸以上';
		end
	end
end

function this.OnPlayerEnter(msg)
	print('OnPlayerEnter........')
	local b = xhzd_pb.RPlayer()
	b:ParseFromString(msg.body)
	playerData[b.seat]=b
	playerData[b.seat].connected=b.connected
	playerData[b.seat].ready = false
    local i = this.GetUIIndexBySeat(b.seat)
	playerOfflineTime[i].gameObject:SetActive(false)
    playerReady[i].gameObject:SetActive(false)
	this.RefreshPlayer()
	scoreView.allScore.players[b.seat].name:GetComponent('UILabel').text =  b.WrapBankerType==xhzd_pb.YES_WRAP_BANKER and '[ff6600](庄)[-]'..b.name or b.name
	scoreView.allScore.players[b.seat].history:GetComponent('UILabel').text = '0'
	scoreView.allScore.players[b.seat].now:GetComponent('UILabel').text = '0'
	scoreView.allScore.players[b.seat].happyScore:GetComponent('UILabel').text = '0'
	scoreView.allScore.players[b.seat].gameObject:SetActive(true);
end

function this.OnPlayerJion(msg)
	print('OnPlayerJion玩家进来了')
	local b = xhzd_pb.RPlayerJoin()
	b:ParseFromString(msg.body)

	playerData[b.seat].connected = true
	playerData[b.seat].ip = b.ip
	playerData[b.seat].ready = b.ready
	if b.longitude and b.longitude ~= 0 then
        playerData[b.seat].longitude = b.longitude
        playerData[b.seat].latitude = b.latitude
    else
        playerData[b.seat].longitude = 0
        playerData[b.seat].latitude = 0
    end
    if b.address and b.address ~= "" then
        playerData[b.seat].address = b.address
    else
        playerData[b.seat].address = "未获取到该玩家位置"
	end
    local i = this.GetUIIndexBySeat(b.seat)
	playerOfflineTime[i].gameObject:SetActive(false)
	if roomData.state ~= xhzd_pb.READYING and roomData.state ~= xhzd_pb.ENDING  then
		for i = 0, 3 do
			playerReady[i].gameObject:SetActive(false)
		end
	else
		playerReady[i].gameObject:SetActive(b.ready)
	end
	this.GPSRefresh()
	ButtonInvite.gameObject:SetActive(#playerData ~= roomData.setting.size - 1 and IsAppleReview() == false)
	ButtonInvite.parent:GetComponent("UIGrid"):Reposition()
	this.NotifyGameStart()
	this.StopOfflineIncrease(b.seat)
end
function this.GetDistance()
	local keys = {1,2,3,4,5,6};
	local i = 0;
	local distanceTable = {};
	for key, value in pairs(keys) do
		if i <= 3 then
			local playerData1 = this.GetPlayerDataByUIIndex(i);
			local p2index = (i + 1) % 4;
			local playerData2 = this.GetPlayerDataByUIIndex(p2index);
			if playerData1 and playerData2 then
				local tempDistance = GetDistance(playerData1.longitude, playerData1.latitude, playerData2.longitude, playerData2.latitude);
				distanceTable[value] = tempDistance;
			else
				distanceTable[value] = -1;
			end
		else
			local playerData1;
			local playerData2;
			if key == 5 then
				playerData1 = this.GetPlayerDataByUIIndex(1);
				playerData2 = this.GetPlayerDataByUIIndex(3);
			elseif key == 6 then
				playerData1 = this.GetPlayerDataByUIIndex(0);
				playerData2 = this.GetPlayerDataByUIIndex(2);
			end
			if playerData1 and playerData2 then
				local tempDistance = GetDistance(playerData1.longitude, playerData1.latitude, playerData2.longitude, playerData2.latitude);
				distanceTable[value] = tempDistance;
			else
				distanceTable[value] = -1;
			end
		end
		i = i+1;
	end
	return distanceTable;
end

function this.SetPlayerInfo()
	for i = 0, 3 do
		PlayerUIObjs[i].Name:GetComponent("UILabel").text = '';
    end
	for i = 0, 3 do
		local player = this.GetPlayerDataByUIIndex(i);
		if player ~= nil then
			--名字
			PlayerUIObjs[i].Name:GetComponent("UILabel").text = player.name;
		else
			PlayerUIObjs[i].Name:GetComponent("UILabel").text = '';	
		end
    end
end

function this.SetDistance()
    local distanceTable = this.GetDistance();
    for key, value in pairs(distanceTable) do
        if value == -1 then
            DistanceObjs[key].disLabel:GetComponent("UILabel").text = '';
        else
            DistanceObjs[key].disLabel:GetComponent("UILabel").text = value;
        end
    end
end

function this.GPSRefresh()
	if roomData.setting.size == 2 or roomData.state == xhzd_pb.GAMING or roomData.state == xhzd_pb.CUTING or roomData.state == xhzd_pb.WRAPPING or roomData.state == xhzd_pb.ENDING or roomData.round ~= 1   then
		GPS.gameObject:SetActive(false)
        return 
	end
	this.SetPlayerInfo()
	this.SetDistance()
    GPS.gameObject:SetActive(true)
end

function this.getLineIndex(a,b)
	if a==0 or b==0 then
		return a + b - 1;
	else
		return a + b ;
	end
end
function this.OnPlayerLeave(msg)
	print('OnPlayerLeave')
	local b = xhzd_pb.RPlayerLeave()
	b:ParseFromString(msg.body)
	local i = this.GetUIIndexBySeat(b.seat)
	playerReady[i].gameObject:SetActive(false)
    playerData[b.seat] = nil
	this.RefreshPlayer()
	this.GPSRefresh()

	ButtonInvite.gameObject:SetActive(#playerData ~= roomData.setting.size -1 and IsAppleReview() == false)
	ButtonInvite.parent:GetComponent("UIGrid"):Reposition()
	scoreView.allScore.players[b.seat].gameObject:SetActive(false);
end
function this.OnLeaveRoom(msg)
	print('OnLeaveRoom')
	NetWorkManager.Instance:DeleteConnect('game');
	PanelManager.Instance:HideWindow('panelDestroyRoom')
	panelLogin.HideGameNetWaitting();
    if roomData.clubId ~= '0' then
        local data = {}
        data.name = 'panelInGame_xhzd'
        PanelManager.Instance:ShowWindow('panelClub', data)
    else
        PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
	end
	roomData.clubId = '0'
end

function this.RefreshMyGridIn()
	print('RefreshMyGridIn');
	for i=0,roomData.setting.size -1 do
		local pData = this.GetPlayerDataByUIIndex(i)
		if pData ~= nil and pData.seat == mySeat then
			this.RefreshGrid(pData.cards)
			myCardList = pData.cards
		end
    end
end

function this.OnRoundStart(msg) --游戏开始
	GPS.gameObject:SetActive(false)
	selectCards={}
	local b = xhzd_pb.RRoundStart()
	b:ParseFromString(msg.body)
	print('OnRoundStart')
	for i=1,#b.players do
		local p = b.players[i]
		
		while(#playerData[p.seat].cards > 0) do
			playerData[p.seat].cards:remove(#playerData[p.seat].cards)
		end
		
		for j=1,#p.cards do
			playerData[p.seat].cards:append(p.cards[j])
		end
	end
	for i=#roomData.latestHand.cards,1,-1 do
		roomData.latestHand.cards:remove(i)
	end
	roomData.state = xhzd_pb.GAMING
	this.SetInviteVisiable(false)
    this.SetReadyVisiable()
    this.SetRoundNum(roomData.round)
	lastFindCards ={}
	helpNumWhenHaveOneCard = 0
	if roomData.round == 1 and not (roomData.setting.size == 2) then
        local datas = {}
		for i = 0, roomData.setting.size - 1 do
			datas[i] = this.GetPlayerDataByUIIndex(i)
		end
        InspectIPAndGPS(datas,roomData.setting.size == 3 and pos3 or pos4,this.OnClicButtonDisbandRoom)   
    end
end
function this.OnClicButtonDisbandRoom(go)
    local msg = Message.New()
	msg.type = xhzd_pb.DISSOLVE
	local body = xhzd_pb.PDissolve()
	body.decision = 0;
	msg.body = body:SerializeToString();
	SendGameMessage(msg, nil)
end
function this.GetBoomInx(boomNum,inx)
	local num ={}
	for i = 1, #boomNum do
		if boomNum[i] == inx then
			local num1 = 0
			for j = 1, i-1 do
				num1  = num1 + boomNum[j]
			end
			table.insert(num,num1)
		end
	end
	return num
end

function this.SetBeLeftCardBoom(grid,cards,index,isOutCardOneOrTow)
	if cards ~= nil and #cards>0 then
		local fenxicard = this.fenXiCard(cards)
		local boomNum = {}
		local num = {}
		for i = 5, 15 do
			if  fenxicard[i] then
				table.insert(boomNum,fenxicard[i].num)
			end
		end
		local num4 = this.GetBoomInx(boomNum,4)
		local num5 = this.GetBoomInx(boomNum,5)
		local num6 = this.GetBoomInx(boomNum,6)
		local num7 = this.GetBoomInx(boomNum,7)
		local num8 = this.GetBoomInx(boomNum,8)
		for i = 1, #num4 do
			table.insert(num,num4[i])
		end
		for i = 1, #num5 do
			table.insert(num,num5[i])
		end
		for i = 1, #num6 do
			table.insert(num,num6[i])
		end
		for i = 1, #num7 do
			table.insert(num,num7[i])
		end
		for i = 1, #num8 do
			table.insert(num,num8[i])
		end
		for i = 1, #num do
			local inx = 0
			local  pos = Vector3(0,0,0) 
			if fenxicard[(GetPlateNum(cards[num[i]+1])+2)].num == 4 then
				if isOutCardOneOrTow then
					inx = (grid.transform.childCount) - (num[i]+1)
					local pos1 = grid:GetChild(inx-1).localPosition;
					pos = Vector3(-(pos1.x + 10), pos1.y ,0);
				else
					inx = num[i]+1
					local pos1 = grid:GetChild(inx).localPosition
					pos = Vector3((pos1.x-10), pos1.y ,0 )
				end
			elseif fenxicard[GetPlateNum(cards[num[i]+1])+2].num == 5 then
				if isOutCardOneOrTow then
					inx = (grid.transform.childCount) - (num[i]+2)
					local pos1 = grid:GetChild(inx-1).localPosition
					pos = Vector3(-(pos1.x + 30), pos1.y ,0)
				else
					inx = num[i]+1
					local pos1 = grid:GetChild(inx).localPosition
					pos = Vector3((pos1.x +10), pos1.y ,0)
				end
			elseif fenxicard[GetPlateNum(cards[num[i]+1])+2].num == 6 then
				if isOutCardOneOrTow then
					inx = (grid.transform.childCount) - (num[i]+3)
					local pos1 = grid:GetChild(inx-1).localPosition
					pos = Vector3(-(pos1.x+40), pos1.y ,0)
				else
					inx = num[i]+1
					local pos1 = grid:GetChild(inx).localPosition
					pos = Vector3((pos1.x+30), pos1.y ,0 )
				end
			elseif fenxicard[GetPlateNum(cards[num[i]+1])+2].num == 7 then
				if isOutCardOneOrTow then
					inx = (grid.transform.childCount) - (num[i]+4)
					local pos1 = grid:GetChild(inx-1).localPosition
					pos = Vector3(-(pos1.x + 60), pos1.y ,0)
				else
					inx = num[i]+1
					local pos1 = grid:GetChild(inx).localPosition
					pos = Vector3((pos1.x + 40), pos1.y ,0)
				end
			elseif fenxicard[GetPlateNum(cards[num[i]+1])+2].num == 8 then
				if isOutCardOneOrTow then
					inx = (grid.transform.childCount) - (num[i]+5)
					local pos1 = grid:GetChild(inx-1).localPosition
					pos = Vector3(-(pos1.x + 80), pos1.y ,0)
				else
					inx = num[i]+1
					local pos1 = grid:GetChild(inx).localPosition
					pos = Vector3((pos1.x+60), pos1.y ,0 )
				end
			end
			if fenxicard[GetPlateNum(cards[num[i]+1])+2].num==4 then
				beLeftCardBoom[index]:GetChild(i-1):GetComponent('UISprite').spriteName='提示_4炸'
			else
				beLeftCardBoom[index]:GetChild(i-1):GetComponent('UISprite').spriteName='提示_4炸以上'
			end
			beLeftCardBoom[index]:GetChild(i-1):Find('Label'):GetComponent('UILabel').text = fenxicard[GetPlateNum(cards[num[i]+1])+2].num..'张'
			beLeftCardBoom[index]:GetChild(i-1).localPosition = Vector3(pos.x, pos.y-20 ,0)
			beLeftCardBoom[index]:GetChild(i-1).gameObject:SetActive(true);
		end
	end
end
this.hasStageClear=false;
function this.OnRoundEnd(msg)
	print('OnRoundEnd')
	ButtonHorizontal.gameObject:SetActive(false)
	this.hasStageClear=true
	local b = xhzd_pb.RRoundEnd()
	b:ParseFromString(msg.body)
	noBigCard.gameObject:SetActive(false)
	roomData.round = roomData.round+1
	
	ButtonHelp.gameObject:GetComponent('UIButton').isEnabled = false;
	ButtonPass.gameObject:GetComponent('UIButton').isEnabled = false;
	ButtonPlay.gameObject:GetComponent('UIButton').isEnabled = false;
	CountDown.gameObject:SetActive(false);
	TrusteeshipTip.gameObject:SetActive(false);
    TrusteeshipPanel.gameObject:SetActive(false);
    --coroutine.stop(trusteeshipcor);
	coroutine.start(
		function()
			connect.IsZanTing=true
			if panelCapitulate then
				PanelManager.Instance:HideWindow('panelCapitulate')
			end
			local isShow = true
			if roomData.setting.size == 2 then
				if #b.players[1].cards == 0 and #b.players[2].cards == 0 then
					isShow = false
				end	
			else
				if #b.players[1].cards == 0 and #b.players[2].cards == 0 and #b.players[3].cards == 0 and #b.players[4].cards == 0 then
					isShow = false
				end	
			end
			print('isshow : '..tostring(isShow))
			--隐藏出的牌
			coroutine.wait(1)
			for i = 0, 3 do
				playerzi[i].gameObject:SetActive(false)
				this.initOutCardGroup(playerGridOut[i])
				playerGridOutDaiZi[i].gameObject:SetActive(false)
				OutCardZhaDan[i].gameObject:SetActive(false)
			end
			--隐藏自己的手牌
			this.initCardGroup()
			--显示玩家剩余牌
			if isShow then
				for i = 1, #b.players do
					local index = this.GetUIIndexBySeat(b.players[i].seat)
					local isOutCardOneOrTow = false
					if index == 1 or index == 2 then
						isOutCardOneOrTow=true
					end
					local outcard = {}
					table.sort(b.players[i].cards)
					outcard.cards = b.players[i].cards
					outcard.feiji = {}
					outcard.daipai = {}
					this.RefreshOutGrid(beLeftCardGrid[index],outcard,isOutCardOneOrTow,index,false)
					this.SetBeLeftCardBoom(beLeftCardGrid[index],b.players[i].cards,index,isOutCardOneOrTow)
				end
				for i=1,#b.scores do
					local data = b.scores[i]
					scoreView.allScore.players[i-1].happyScore:GetComponent('UILabel').text = data.happyScore
					scoreView.allScore.players[i-1].gameObject:SetActive(true)
				end
				AudioManager.Instance:PlayAudio('addScore')
				coroutine.wait(3)
			end

			if IsAutoDissolve then
				PanelManager.Instance:ShowWindow('panelAutoDissolve', AutoDissolveData)
				IsAutoDissolve = false
			end
			
			--打开小结算界面
			local stageRoomInfo 		= {};
			stageRoomInfo.roomNumber 	= roomInfo.roomNumber;
			stageRoomInfo.roomData 		= roomData;
			stageRoomInfo.playerDatas 	= b.players;
			stageRoomInfo.playerData  	= playerData
			stageRoomInfo.cardsDark = b.cardsDark
			stageRoomInfo.isInGame = true
			stageRoomInfo.gameOver 	= b.gameOver;
			stageRoomInfo.isBack 	= false;
			stageRoomInfo.fuc=function()
				connect.IsZanTing=false
			end
			PanelManager.Instance:ShowWindow('panelStageClear_xhzd',stageRoomInfo)
			for i = 0, #playerData do
				if playerData[i] ~= nil then
					playerData[i].WrapBankerType = xhzd_pb.NOT_SELECTED
				end
			end
			local scoreResults = {}
			for i = 1, #b.scores do
				local scoreResult ={}
				local data = b.scores[i]
				scoreResult.seat = data.seat
				scoreResult.roundScore = 0
				scoreResult.happyScore =0
				scoreResult.historyScore=data.historyScore
				table.insert(scoreResults,scoreResult)
			end
			this.UpdateScoreView(scoreResults,true)
			for i=0,3 do
				playerScore[i]:GetComponent('UILabel').text ='0'
			end
			this.ClearRoom()
		end
	)
end

function this.OnGameOver(msg)
	print('所有局数结束')
	local b = xhzd_pb.ROver()
	b:ParseFromString(msg.body)
	if b == nil then
		print("服务器下发的大结算数据为空666666666666666666666666666")
	else
		print("服务器下发的大结算数据不为空9999999999999999999999999")
	end
	RoundAllData.data = b
	RoundAllData.mySeat = mySeat
	RoundAllData.playerData = playerData
	RoundAllData.over = true
	RoundAllData.playName = roomData.playName
	local Trusteeships={}
    for i = 0, roomData.setting.size-1 do
		local da = this.GetPlayerDataByUIIndex(i)
		print('iiiiiiiiiiiiiiiiiiiiiiiiiiii : '..i)
        if playerTrusteeship[i].gameObject.activeSelf then
            Trusteeships[da.seat] = true
        else
            Trusteeships[da.seat] = false
        end
    end
    for i = 0, #Trusteeships do
        print(i..'Trusteeships[i] : '..tostring(Trusteeships[i]))
    end
    RoundAllData.isTrusteeships = Trusteeships
	if panelCapitulate then
		PanelManager.Instance:HideWindow('panelCapitulate')
	end
	if  this.hasStageClear==false  then
		PanelManager.Instance:ShowWindow('panelStageClearAll_xhzd',RoundAllData)
		PanelManager.Instance:HideWindow(gameObject.name)
		this.ClearRoom()
		for i = 0, 3 do
			playerTrusteeship[i].gameObject:SetActive(false)
			playerOfflineTime[i].gameObject:SetActive(false)
		end
		for i=0,3 do
			playerName[i]:GetComponent('UILabel').text = ''
			playerIcon[i].gameObject:SetActive(false)
			playerScore[i]:GetComponent('UILabel').text =''
		end
	end
end
function this.Destroy(msg)
	print('销毁房间..............'..roomData.clubId)
	if panelCutCard then
		PanelManager.Instance:HideWindow('panelCutCard')
	end
	
	this.setFangHeShou(false)	
	this.StopCheckNetState()
	this.fanHuiRoomNumber = nil
	NetWorkManager.Instance:DeleteConnect('game')
	panelLogin.HideGameNetWaitting()
	PanelManager.Instance:HideWindow('panelDestroyRoom')

	TrusteeshipTip.gameObject:SetActive(false);
    TrusteeshipPanel.gameObject:SetActive(false);
	this.ClearRoom()
	for i = 0, 3 do
		playerTrusteeship[i].gameObject:SetActive(false)
		playerOfflineTime[i].gameObject:SetActive(false)
	end
	if panelStageClear_xhzd then
		panelStageClear_xhzd.setButtonsStatus(true)
	end
    coroutine.stop(trusteeshipcor);
	offlineState = true;
	if not RoundAllData.over  then
		if roomData.clubId ~= '0' then
			local data = {}
			data.name = 'panelInGame_xhzd'
			data.clubId = roomData.clubId
			PanelManager.Instance:ShowWindow('panelClub', data)
		else
			PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
		end
		roomData.clubId = '0'
		--panelInGame =nil
		return 
	end
	this.StopAllOfflineIncrease()
end
function this.OnReady(msg)
	print('OnReady')
	local b = xhzd_pb.RReady()
	b:ParseFromString(msg.body)
    local ix = this.GetUIIndexBySeat(b.seat)
	playerReady[ix].gameObject:SetActive(true)
	playerData[b.seat].ready = true
	if b.seat == mySeat then
		readybtn.gameObject:SetActive(false)
	end
	for i=0,3 do
		playerGridOut[i].gameObject:SetActive(false)
		selectOutCardTypeGridDaizi[i].gameObject:SetActive(false)
		playerGridOutDaiZi[i].gameObject:SetActive(false)
		OutCardZhaDan[i].gameObject:SetActive(false)
		playerGridIn[i].gameObject:SetActive(false)
	end
	this.NotifyGameStart()
	if b.seat == mySeat and panelStageClear_xhzd then
		PanelManager.Instance:HideWindow('panelStageClear_xhzd')
	end
end

function this.OnDisconnected(msg)
	print('OnDisconnected')
	local b = xhzd_pb.RSeat()
	b:ParseFromString(msg.body)
	local i = this.GetUIIndexBySeat(b.seat)
	playerData[b.seat].connected = false
	playerOfflineTime[i].gameObject:SetActive(true)
	--断线后停止托管的倒计时
	this.StartOfflineIncrease(b.seat, 0)
end

function this.OnPlayerPlay(msg)
	print('OnPlayerPlay   玩家出牌了.........')
	this.StopTrustesship()
	local b = xhzd_pb.RPlay()
	b:ParseFromString(msg.body)
	AudioManager.Instance:PlayAudio('betcard')
	if b.hand.category == 6 then
		AudioManager.Instance:PlayAudio('ZD_LittleBoom')
	end

	this.OnPlayerHand(b.seat, b.hand)
	scoreView.score.scoreLabel:GetComponent('UILabel').text=b.score and b.score or 0
	local pData = playerData[b.seat]
	local i = this.GetUIIndexBySeat(b.seat)
	if mySeat == pData.seat then
		for ii=1,#b.hand.cards do
			local cardID = b.hand.cards[ii]
			local itemOut = nil
			for j=0,playerGridOut[i].transform.childCount-1 do
				local item = playerGridOut[i].transform:GetChild(j)
				if item.gameObject.activeSelf and GetUserData(item.gameObject) == cardID then
					itemOut = item
					break
				end
			end
			
			local itemIn = nil
			for k=0,playerGridIn[i].transform.childCount-1 do
				local item = playerGridIn[i].transform:GetChild(k)
				if item.gameObject.activeSelf and GetUserData(item.gameObject) == cardID then
					itemIn = item
					item:Find('typeBig').gameObject:SetActive(false)
					break
				end
			end
			
			if itemOut and itemIn then
				local tw_pos = itemOut:GetComponent('TweenPosition')
				local pos = itemOut.transform.position
				itemOut.transform.position =  itemIn.transform.position
				TweenPosition.Begin(itemOut.gameObject, 0.1, pos, true)
				
				local tw_sc = itemOut:GetComponent('TweenScale')
				local f = playerGridIn[i].transform.localScale.x / playerGridOut[i].transform.localScale.x
				itemOut.transform.localScale = Vector3.New(f, f, f)
				TweenScale.Begin(itemOut.gameObject, 0.1, Vector3.one)
			end
		end
		for i=1,#b.hand.cards do
			for j=1,#pData.cards do
				if b.hand.cards[i] == pData.cards[j] then
					pData.cards:remove(j)
					break
				end
			end
		end
		myCardList = pData.cards
		this.RefreshGrid(pData.cards)
	end
	
	for i=#roomData.latestHand.cards,1,-1 do
		roomData.latestHand.cards:remove(i)
	end
	for i=1,#b.hand.cards do
		roomData.latestHand.cards:append(b.hand.cards[i])
	end
	this.PlayCardSound(b.hand,pData.sex)

	if b.cardCount == 1 and mySeat ~= b.seat then
		playerLight[i].gameObject:SetActive(true)
		coroutine.start(
			function()
				coroutine.wait(1)
				AudioManager.Instance:PlayAudio(string.format('baodan_%d_1', pData.sex))
			end
		)
	elseif b.cardCount == 0 then
		playerLight[i].gameObject:SetActive(false)
	end

	OutCardFinish[i].gameObject:SetActive(false);
	local index = this.GetUIIndexBySeat(b.seat)
	local name ;
	if b.roundOrder == 0 then
		name = '上游'
	elseif b.roundOrder == 1 then
		if roomData.setting.size == 4 then
			name = '二游'
		else
			name = '下游'
		end
	elseif b.roundOrder == 2 then
		name = '三游'
	elseif b.roundOrder == 3 then
		name = '下游'	
	elseif b.roundOrder == -1 then
		name = ''	
	end
	OutCardFinish[index]:GetComponent('UISprite').spriteName = name;
	OutCardFinish[index].gameObject:SetActive(b.roundOrder ~= -1);
	if b.roundOrder ~= -1 then
		AudioManager.Instance:PlayAudio('winerVoice')
	end
	if b.nextSeat == -1 then
		return ;
	end
	roomData.activeSeat =  b.nextSeat
	roomData.latestSeat = b.seat
	roomData.latestHand.minCard = b.hand.minCard
	roomData.latestHand.maxCard = b.hand.maxCard
	roomData.latestHand.keyCardCount = b.hand.keyCardCount
	roomData.latestHand.category = b.hand.category
	if b.seat == mySeat then
		selectCards={}
	end
	lastFindCards = {}
	helpNumWhenHaveOneCard = 0
	winSeat = nil
	if #b.hand.cards ~= 0 then
		this.SetDelegateCount(roomData.activeSeat)
		this.SetCountDownVisiable()
	end
	for i = 0, 3 do
		playerzi[i].gameObject:SetActive(false);
	end
	
	DelayMsgDispatch(connect, 0.5)
end

function this.PlayCardSound(hand,sex)
	local soundName =''
	if hand.category == 0 then
		soundName = string.format('single_%d_%d', sex, GetPlateNum(hand.cards[1])+2)
	elseif hand.category == 1 then	
		soundName = string.format('double_%d_%d', sex, GetPlateNum(hand.cards[1])+2)
	elseif hand.category == 2 then	
		local outCardSort = this.OutCardSort(hand)
		soundName = string.format('triple_%d_%d', sex, GetPlateNum(outCardSort.feiji[1])+2)
	elseif hand.category == 3 then
		soundName = string.format('danshun_%d', sex)
	elseif hand.category == 4 then
		soundName = string.format('shuangshun_%d', sex)
	elseif hand.category == 5 then
		soundName = string.format('plane_%d', sex)
	elseif hand.category == 6 then
		soundName = string.format('zhadan_%d', sex)
	end
	if soundName ~= nil then
		AudioManager.Instance:PlayAudio(soundName)
	end
end

function this.OnPlayerPass(msg)
	print("玩家过牌。。。。。")
	this.StopTrustesship()
	local b = xhzd_pb.RPass()
	b:ParseFromString(msg.body)
	local index = this.GetUIIndexBySeat(b.seat)
	OutCardZhaDan[index].gameObject:SetActive(false)
	this.initOutCardGroup(playerGridOut[index])
	playerGridOutDaiZi[index].gameObject:SetActive(false)
	selectOutCardTypeGridDaizi[index].gameObject:SetActive(false)
	noBigCard.gameObject:SetActive(false)
	if b.nextSeat == -1 then
		playerzi[index].gameObject:SetActive(true);
		AudioManager.Instance:PlayAudio(string.format('pass_%d_1', playerData[b.seat].sex))
		playerzi[index].gameObject:GetComponent('UISprite').spriteName = 'pass_1';
		playerzi[index].gameObject:GetComponent('UISprite'):MakePixelPerfect()
		return 
	end
	roomData.activeSeat = b.nextSeat
	winSeat = b.winSeat
	print('b.winSeat : '..b.winSeat..' b.nextSeat : '..b.nextSeat)
	this.SetDelegateCount(roomData.activeSeat)
	coroutine.start(
		function()
			playerzi[index].gameObject:GetComponent('UISprite').spriteName = 'pass_1';
			playerzi[index].gameObject:GetComponent('UISprite'):MakePixelPerfect()
			if isMySelfTrusteeship and b.seat == mySeat then
				CountDown.gameObject:SetActive(false)
				coroutine.wait(0.4)
				WaitForEndOfFrame()
				playerzi[index].gameObject:SetActive(true);
				AudioManager.Instance:PlayAudio(string.format('pass_%d_1', playerData[b.seat].sex))
				if b.winSeat == b.nextSeat then
					coroutine.wait(0.4)
					WaitForEndOfFrame()
					for i = 0, 3 do
						playerzi[i].gameObject:SetActive(false);
						playerGridOut[i].gameObject:SetActive(false)
						selectOutCardTypeGridDaizi[i].gameObject:SetActive(false)
						playerGridOutDaiZi[i].gameObject:SetActive(false)
						playerwenzi[i].gameObject:SetActive(false)
						OutCardZhaDan[i].gameObject:SetActive(false)
					end
					this.SetCountDownVisiable()
				else
					this.SetCountDownVisiable()
				end
			else
				playerzi[index].gameObject:SetActive(true);
				AudioManager.Instance:PlayAudio(string.format('pass_%d_1', playerData[b.seat].sex))
				if b.winSeat == b.nextSeat then
					coroutine.wait(0.4)
					WaitForEndOfFrame()
					for i = 0, 3 do
						playerzi[i].gameObject:SetActive(false);
						playerGridOut[i].gameObject:SetActive(false)
						selectOutCardTypeGridDaizi[i].gameObject:SetActive(false)
						playerGridOutDaiZi[i].gameObject:SetActive(false)
						playerwenzi[i].gameObject:SetActive(false)
						OutCardZhaDan[i].gameObject:SetActive(false)
					end
					this.SetCountDownVisiable()
				else
					this.SetCountDownVisiable()
				end
			end
		end
	)
	
	DelayMsgDispatch(connect, 1)
end

function this.OnDissolve(msg)
	local b = xhzd_pb.RDissolve()
	b:ParseFromString(msg.body)
	if b.decision == xhzd_pb.APPLY then
		roomData.dissolution.applicant = b.seat;
		while #roomData.dissolution.acceptors > 0 do
			table.remove(roomData.dissolution.acceptors, #roomData.dissolution.acceptors)
		end
		roomData.dissolution.remainMs = b.remainMs/1000
		this.SetDestoryPanelShow()
	elseif b.decision == xhzd_pb.AGREE then
		table.insert(DestroyRoomData.roomData.dissolution.acceptors, b.seat)
		panelDestroyRoom.Refresh()
	elseif b.decision == xhzd_pb.AGAINST then
		table.insert(DestroyRoomData.roomData.dissolution.rejects, b.seat)
		panelDestroyRoom.Refresh(b.seat)
	end
end

function this.ClearRoom()
	for i=0,3 do
		playerScore[i]:GetComponent('UILabel').text ='0'
		playerMaster[i].gameObject:SetActive(false)
		playerSound[i].gameObject:SetActive(false)
		playerGridIn[i].gameObject:SetActive(false)
		playerGridOut[i].gameObject:SetActive(false)
		selectOutCardTypeGridDaizi[i].gameObject:SetActive(false)
		playerGridOutDaiZi[i].gameObject:SetActive(false)
		OutCardZhaDan[i].gameObject:SetActive(false)
		playerReady[i].gameObject:SetActive(false)
		
		playerwenzi[i].gameObject:SetActive(false)
		playerLight[i].gameObject:SetActive(false)
		playerBaoZhuang[i].gameObject:SetActive(false);
		OutCardFinish[i].gameObject:SetActive(false);
		playerKuang[i].gameObject:SetActive(false)
		this.initOutCardGroup(beLeftCardGrid[i])
		for j = 1, beLeftCardBoom[i].transform.childCount do
			beLeftCardBoom[i]:GetChild(j-1).gameObject:SetActive(false);
		end
	end
	ButtonCapitulate.gameObject:SetActive(false);
	baoZhuangView.gameObject:SetActive(false)
	
	ButtonHelp.gameObject:GetComponent('UIButton').isEnabled = false;
	ButtonPass.gameObject:GetComponent('UIButton').isEnabled = false;
	ButtonPlay.gameObject:GetComponent('UIButton').isEnabled = false;
	CountDown.gameObject:SetActive(false)
	noBigCard.gameObject:SetActive(false)
	roomData.state = xhzd_pb.READYING
	this.OnClickBG(onClickWidget.gameObject)
	this.ClearnSelectCard()
	PanelManager.Instance:HideWindow("panelPlayerInfo");
	PanelManager.Instance:HideWindow("panelChat");
	PanelManager.Instance:HideWindow("panelGameSetting_xhzd");
end
--是否显示解散房间，返回大厅，邀请玩家按钮
function this.SetInviteVisiable(show)
	ButtonCloseRoom.gameObject:SetActive(show)
	ButtonExitRoom.gameObject:SetActive(show)

	if not PlatformManager.Instance:IsWXAppInstalled() then
		show = false
	end
	ButtonInvite.gameObject:SetActive(#playerData ~= roomData.setting.size - 1 and IsAppleReview() == false)
	if mySeat == 0 then
		ButtonCloseRoom:Find('Label'):GetComponent("UILabel").text = "解散房间"
	else
		ButtonCloseRoom:Find('Label'):GetComponent("UILabel").text = "退出房间"
	end
	ButtonInvite.parent:GetComponent("UIGrid"):Reposition()
end

function this.SetDestoryPanelShow() 
	PanelManager.Instance:HideWindow('panelDestroyRoom')
    PanelManager.Instance:ShowWindow('panelDestroyRoom')
end

function this.SetReadyVisiable()
    for i=0,3 do
        if roomData.state == xhzd_pb.WAITING then
			playerReady[i].gameObject:SetActive(false)
			readybtn.gameObject:SetActive(true)
        elseif roomData.state == xhzd_pb.READYING or roomData.state == xhzd_pb.ENDING then
			local p = this.GetPlayerDataByUIIndex(i)
			if p~=nil and p.ready then
				playerReady[i].gameObject:SetActive(true)
			else
				playerReady[i].gameObject:SetActive(false)
			end
			if p~=nil and p.seat == mySeat then
				if p.ready then
					readybtn.gameObject:SetActive(false)
				else
					readybtn.gameObject:SetActive(true)
				end 
			end
		else
			playerReady[i].gameObject:SetActive(false)
			readybtn.gameObject:SetActive(false)
        end
    end
end

function this.SetCountDownVisiable()
	local index = this.GetUIIndexBySeat(roomData.activeSeat)
	print('轮到我操作了我的ui索引是 ：'..tostring(winSeat));
	local noPass = false
	if roomData.activeSeat == mySeat then
		if #roomData.latestHand.cards > 0 then
			if roomData.latestSeat ~= mySeat then
				if winSeat ~= nil and roomData.activeSeat == winSeat then
					ButtonPass.gameObject:GetComponent('UIButton').isEnabled = false;
				else
					ButtonPass.gameObject:GetComponent('UIButton').isEnabled = true;
				end
			else
				ButtonPass.gameObject:GetComponent('UIButton').isEnabled = false;
			end
		else
			ButtonPass.gameObject:GetComponent('UIButton').isEnabled = false;
		end
		local cardObjs,cardValues=this.getSelectCard()
		noPass = ButtonPass.gameObject:GetComponent('UIButton').isEnabled==false
		outCard = this.findPromptCards(myCardList,roomData.latestHand,noPass)
		local canoutcard,card,ischai = this.CanOutCard(cardValues,roomData.latestHand,noPass)
		if roomData ~= nil and roomData.latestHand ~= nil then
			print('outCard length : '..#outCard..'   #roomData.latestHand.cards : '..#roomData.latestHand.cards..'   roomData.latestHand.minCard : '..roomData.latestHand.minCard..'   roomData.latestHand.maxCard : '
			..roomData.latestHand.maxCard..'   roomData.latestHand.category : '..roomData.latestHand.category)
		end
		if outCard~= nil and #outCard>0 then
			ButtonHelp.gameObject:GetComponent('UIButton').isEnabled = true;
			noBigCard.gameObject:SetActive(false)
		else
			ButtonHelp.gameObject:GetComponent('UIButton').isEnabled = false;
			noBigCard.gameObject:SetActive(true)
		end
		if canoutcard and cardValues ~= nil and #cardValues>0 then
			ButtonPlay.gameObject:GetComponent('UIButton').isEnabled = true;
		else
			ButtonPlay.gameObject:GetComponent('UIButton').isEnabled = false;
		end
		helpOutCardsIndex = 1
		CountDown.gameObject:SetActive(true)
	else
		CountDown.gameObject:SetActive(false)
	end
	for i = 0, 3 do
		if i==index then
			playerKuang[i].gameObject:SetActive(true)
		else
			playerKuang[i].gameObject:SetActive(false)
		end
	end
end

function this.SetRoundNum(num)
	roomRound:GetComponent('UILabel').text = "第"..num..'/'..roomData.setting.rounds..'局'--..setting_text
	--设置游戏规则面板
end

function this.OnClickButtonChat(go)
	print('roomData.setting.sendMsgAllowed : '..tostring(roomData.setting.sendMsgAllowed))
	AudioManager.Instance:PlayAudio('btn')
	if roomData.setting.sendMsgAllowed then
        PanelManager.Instance:ShowWindow('panelChat')
    else
        panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '群主已经禁止游戏过程中聊天，如有疑问请联系群主')
        PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
    end
end

function this.OnClickButtonCapitulate(go)
	local msg = Message.New()
	msg.type = xhzd_pb.DISARM
	local body = xhzd_pb.PDisarm();
	body.type = xhzd_pb.DISARM_APPLY
	msg.body = body:SerializeToString();
	SendGameMessage(msg, nil);
end
function this.OnCapitulate(msg)
	local b = xhzd_pb.RDisarm()
	b:ParseFromString(msg.body)
	if b.type == xhzd_pb.DISARM_APPLY then
			local capitulateInfo = {}
			capitulateInfo.plays = playerData
			capitulateInfo.seat = b.seat
			capitulateInfo.mySeat = mySeat
			capitulateInfo.time = b.time
			PanelManager.Instance:ShowWindow('panelCapitulate',capitulateInfo)
	elseif b.type == xhzd_pb.DISARM_AGREE then
		if panelCapitulate then
			panelCapitulate.ShowButton(b.seat,mySeat)
		end	
	elseif b.type == xhzd_pb.DISARM_REJECT then
		if panelCapitulate then
			panelCapitulate.ShowReject(b.seat)
		end	
	end
end

function this.OnCapitulateError()
	panelMessageTip.SetParamers('不满足投降条件', 2)
	PanelManager.Instance:ShowWindow('panelMessageTip')
end

function this.OnClickButtonHorizontal(go)
	print('切换横竖牌')
	this.ClearnSelectCard()
	this.OnClickBG(onClickWidget.gameObject)
	if XHZDIsHorizontalCards then
		XHZDIsHorizontalCards = false
		UnityEngine.PlayerPrefs.SetInt('XHZDIsHorizontalCards', 0)
		ButtonHorizontal:Find("lb"):GetComponent('UILabel').text = '横牌'
		this.RefreshMyGridIn()
	else
		XHZDIsHorizontalCards = true
		ButtonHorizontal:Find("lb"):GetComponent('UILabel').text = '竖牌'
		UnityEngine.PlayerPrefs.SetInt('XHZDIsHorizontalCards', 1)
		this.RefreshMyGridIn()
	end
end

function this.OnClickButtonInvite(go)
	local msg  =""
	msg = msg .. roomData.setting.rounds .. '局，'

	if roomData.setting.size~=nil then
        if roomData.setting.size==2 then
			msg = msg .. '2人玩，'
        elseif roomData.setting.size==4 then
            msg = msg .. '4人玩，'
        end
    end
	if roomData.clubId ~= '0' then
		msg = msg .. '群主支付，'
	else
		if roomData.setting.paymentType == 0 then
			msg = msg .. '房主支付，'
		else
			msg = msg .. '赢家支付，'
		end
	end
	if roomData.setting.happyScoreAdd~=nil then
        if roomData.setting.happyScoreAdd==true then
            msg = msg..'喜分算加分，'
        else
            msg = msg..'喜分算乘分，'
        end
    end
    
    if roomData.setting.canStraight~=nil then
        if roomData.setting.canStraight == true then 
            msg = msg.."可打顺子，"
        end
    end
    
    if roomData.setting.bomb3AsHappy~=nil then
        if roomData.setting.bomb3AsHappy == true then 
            msg = msg.."三个炸弹算一个喜分，"
        end
	end
	
	if roomData.setting.baseScore~=nil then
        msg = msg.."底分"..roomData.setting.baseScore..'分，'
    end

    if roomData.setting.multiple~=nil then
        if roomData.setting.multiple == 1 then 
            msg = msg.."半干，"
        elseif roomData.setting.multiple == 2 then 
            msg = msg.."全干，"
        end
    end

	if roomData.setting.trusteeship then
        if roomData.setting.trusteeship == 0 then
            msg = msg .. " 不托管";
        else
            msg = msg..(roomData.setting.trusteeship/60).."分钟后托管"
            if roomData.setting.trusteeshipDissolve then
                msg = msg .. " 本局解散";
            else
                msg = msg .. " 满局解散";
            end
        end
	end
	
	msg = msg.."房已开好,就等你来！"
	local que = roomData.setting.size - (#playerData+1)
	local title = roomInfo.roomNumber.."房,"..roomData.playName..roomData.setting.size.."缺"..que	
	PlatformManager.Instance:ShareLink('http://'..panelLogin.HttpUrl..'/shareRoom.html?appType=1&state=' ..proxy_pb.XHZD..roomInfo.roomNumber, title, msg, 0)
end

function this.OnClickPlayerIcon(go)
    if IsAppleReview() then
        return
    end
    local pData = GetUserData(go)
    if not pData then
        return
    end
	local userData = {}
	userData.rseat = pData.seat
    userData.nickname = pData.name
    userData.icon = pData.icon
    userData.ip = pData.ip
    userData.userId = pData.id
    userData.address = pData.address
    userData.imgUrl = pData.imgUrl
	userData.gameType = proxy_pb.XHZD;
	userData.signature = pData.signature
	userData.sendMsgAllowed = true
    userData.fee = pData.fee
	userData.isShowSomeID = false
	userData.gameMode = roomData.setting.gameMode
    PanelManager.Instance:ShowWindow('panelPlayerInfo', userData)
end

function this.OnPlayerEmoji(msg)
	local b = xhzd_pb.RGift()
	b:ParseFromString(msg.body)
	local name = ''
	local inx = 0
	local soundName =''
	if b.index == 1 then
		name = 'emoji_zhadan'
		inx = 13
		soundName = 'bombVoice'
	elseif b.index == 2 then
		name = 'emoji_jidan'
		inx = 11
		soundName = 'eggVoice'
	elseif b.index == 3 then
		name = 'emoji_pijiu'
		inx = 13
		soundName = 'cheersVoice'
	elseif b.index == 4 then
		name = 'emoji_hongchun'
		inx = 17
		soundName = 'voiceLove'
	elseif b.index == 5 then
		name = 'emoji_xianhua'
		inx = 3
		soundName = 'flowerVoice'
	elseif b.index == 6 then
		name = 'emoji_dianzan'
		inx = 3
		soundName = 'zan'
	end
	if b.rseat ~= b.seat then
		coroutine.stop(playerEmojiCoroutine[this.GetUIIndexBySeat(b.seat)])
		StartCoroutine(function()
			PanelManager.Instance:HideWindow('panelPlayerInfo')
			local positionFrom = playerIcon[this.GetUIIndexBySeat(b.seat)].position
			local positionTo = playerIcon[this.GetUIIndexBySeat(b.rseat)].position
			local animation =playerAnimation[this.GetUIIndexBySeat(b.seat)]
			
			animation.gameObject:GetComponent('UISprite').spriteName = name
			animation.gameObject:GetComponent('UISprite'):MakePixelPerfect()
			animation.gameObject:GetComponent('TweenPosition').worldSpace = true
			animation.gameObject:GetComponent('TweenPosition').from = positionFrom
			animation.gameObject:GetComponent('TweenPosition').to = positionTo
			animation.gameObject:GetComponent('TweenPosition').duration = 1
			animation.gameObject:GetComponent('TweenPosition'):ResetToBeginning()
			animation.gameObject:GetComponent('TweenPosition'):PlayForward()
			animation.gameObject:SetActive(true)
			coroutine.wait(1)
			if inx == 0 then
				coroutine.wait(2)
				animation.gameObject:SetActive(false)
			else
				local time = 0.1
				if inx == 3 then
					time=0.2
				end
				this.playEmoji(this.GetUIIndexBySeat(b.seat),inx,name,time,soundName)
			end
		end)
	else
		return 
	end
end

function this.playEmoji(myseatinx,index,name,time,soundName)
	playerEmojiCoroutine[myseatinx] = coroutine.start(function()
		AudioManager.Instance:PlayAudio(soundName)
		for i = 1, index do
			playerAnimation[myseatinx]:GetComponent('UISprite').spriteName = name..'_'..i
			playerAnimation[myseatinx].gameObject:GetComponent('UISprite'):MakePixelPerfect()
			coroutine.wait(time)
		end
		playerAnimation[myseatinx].gameObject:SetActive(false)
	end)
end

function this.ExpandSelectZhaDan(myList,totalList,grid)
	for i = 5, 15 do
		if myList[i] and totalList[i] then
			local gridComponent 
			if totalList[i].num == 4 or totalList[i].num == 5 or totalList[i].num == 6 then
				for j=0,grid.childCount-1 do
					local group = grid:GetChild(j)
					local cardGrid = group:Find('cardGrid')
					for k=0,cardGrid.childCount-1 do
						local card = cardGrid:GetChild(k)
						if GetUserData(card.gameObject) == totalList[i].trueValues[1] then
							group:Find('type').gameObject:SetActive(false)
							gridComponent = cardGrid:GetComponent('UIGrid')
						end
					end
				end
				if gridComponent.cellHeight~=-39 and gridComponent.cellHeight>-39 then
					gridComponent.cellHeight=-39
					gridComponent:Reposition()
				end
			elseif totalList[i].num == 7 then
				for j=0,grid.childCount-1 do
					local group = grid:GetChild(j)
					local cardGrid = group:Find('cardGrid')
					for k=0,cardGrid.childCount-1 do
						local card = cardGrid:GetChild(k)
						if GetUserData(card.gameObject) == totalList[i].trueValues[1] then
							group:Find('type').gameObject:SetActive(false)
							gridComponent = cardGrid:GetComponent('UIGrid')
						end
					end
				end
				if gridComponent.cellHeight~=-32 and gridComponent.cellHeight>-32 then
					gridComponent.cellHeight=-32
					gridComponent:Reposition()
				end
			elseif totalList[i].num == 8 then
				for j=0,grid.childCount-1 do
					local group = grid:GetChild(j)
					local cardGrid = group:Find('cardGrid')
					for k=0,cardGrid.childCount-1 do
						local card = cardGrid:GetChild(k)
						if GetUserData(card.gameObject) == totalList[i].trueValues[1] then
							gridComponent = cardGrid:GetComponent('UIGrid')
							group:Find('type').gameObject:SetActive(false)
						end
					end
				end
				if gridComponent.cellHeight~=-28 and gridComponent.cellHeight>-28 then
					gridComponent.cellHeight=-28
					gridComponent:Reposition()
				end
			end
		end
	end
end

function this.SetTiShiSelectCard(cards,totalCards)
	local myList = this.fenXiCard(cards)
	local marrSelectCard = {}
	local totalList = this.fenXiCard(totalCards)
	local isShunZi = false
	for i = 5, 15 do
		if myList[i] then
			table.insert(marrSelectCard,i)
		end
	end
	for i = 5, 15 do
		if myList[i] then
			if myList[i].num > 1 then
				isShunZi = false
			else
				if #marrSelectCard>4 then
					isShunZi = true
				end
			end
		end
	end

	if XHZDIsHorizontalCards then
		local cardIndex={}
		for i = 1, #playerGridInHorizontal do
			local cardValue = GetUserData(playerGridInHorizontal[i].gameObject)
			if cardValue then
				local val = GetPlateNum(cardValue)+2
				if not cardIndex[val] then
					cardIndex[val] = {}
				end
				table.insert(cardIndex[val],i)
			end
		end
		
		for i = 5, 15 do
			if myList[i] then
				for j = 1, myList[i].num do
					local pos = playerGridInHorizontal[cardIndex[i][j]].transform.localPosition
					pos.y = 20
					playerGridInHorizontal[cardIndex[i][j]].transform.localPosition = pos
				end
			end
		end
	else
		local grid = playerGridIn[0]
		this.ExpandSelectZhaDan(myList,totalList,grid)
		for i=0,grid.childCount-1 do
			local group = grid:GetChild(i)
			local cardGrid = group:Find('cardGrid')
			for j=0,cardGrid.childCount-1 do
				local card = cardGrid:GetChild(j)
				for k = 1, #cards do
					if cards[k] == GetUserData(card.gameObject) then
						if isShunZi then
							cardGrid:GetChild(0).transform:Find('typeBig').gameObject:SetActive(true)
						else
							if #cards == 1 then
								cardGrid:GetChild(0).transform:Find('typeBig').gameObject:SetActive(true)
							elseif #cards == 2 then
								this.SetSelectCardBG(cardGrid,1)
							elseif #cards == 3 then
								this.SetSelectCardBG(cardGrid,2)
							elseif #cards == 4 then
								if #marrSelectCard == 2 then
									this.SetSelectCardBG(cardGrid,1)
								else
									this.SetSelectCardBG(cardGrid,3)
								end
							elseif #cards == 5 then
								this.SetSelectCardBG(cardGrid,4)
							elseif #cards == 6 then
								if #marrSelectCard == 2 then
									this.SetSelectCardBG(cardGrid,2)
								elseif #marrSelectCard == 3 then
									this.SetSelectCardBG(cardGrid,1)
								elseif #marrSelectCard == 1 then
									this.SetSelectCardBG(cardGrid,5)
								end
							elseif #cards == 7 then
								this.SetSelectCardBG(cardGrid,6)
							elseif #cards == 8 then
								if #marrSelectCard == 4 then
									this.SetSelectCardBG(cardGrid,1)
								elseif #marrSelectCard == 1 then
									this.SetSelectCardBG(cardGrid,7)
								end
							elseif #cards == 9 then
								if #marrSelectCard == 3 then
									this.SetSelectCardBG(cardGrid,2)
								end
							elseif #cards == 10 then
								if #marrSelectCard == 5 then
									this.SetSelectCardBG(cardGrid,1)
								end
							elseif #cards == 12 then
								if #marrSelectCard == 6 then
									this.SetSelectCardBG(cardGrid,1)
								elseif #marrSelectCard == 4 then
										this.SetSelectCardBG(cardGrid,2)
								end
							elseif #cards == 14 then
								if #marrSelectCard == 7 then
									this.SetSelectCardBG(cardGrid,1)
								end
							elseif #cards == 15 then
								if #marrSelectCard == 5 then
									this.SetSelectCardBG(cardGrid,2)
								end
							elseif #cards == 16 then
								if #marrSelectCard == 8 then
									this.SetSelectCardBG(cardGrid,1)
								end
							elseif #cards == 18 then
								if #marrSelectCard == 9 then
									this.SetSelectCardBG(cardGrid,1)
								elseif #marrSelectCard == 6 then
									this.SetSelectCardBG(cardGrid,2)
								end
							elseif #cards == 20 then
								if #marrSelectCard == 10 then
									this.SetSelectCardBG(cardGrid,1)
								end
							elseif #cards == 21 then
								if #marrSelectCard == 7 then
									this.SetSelectCardBG(cardGrid,2)
								end
							elseif #cards == 22 then
								if #marrSelectCard == 11 then
									this.SetSelectCardBG(cardGrid,1)
								end
							end
						end
					end
				end
			end
		end
	end
	
	if CountDown.gameObject.activeSelf then
		if #cards>0 then
			ButtonPlay.gameObject:GetComponent('UIButton').isEnabled = true;
		else 
			ButtonPlay.gameObject:GetComponent('UIButton').isEnabled = false;
		end
	end
end

function this.SetSelectCardBG(grid,inx)
	for i = 0, inx do
		grid:GetChild(i).transform:Find('typeBig').gameObject:SetActive(true)
	end
end

function this.OnClickButtonHelp(go)
	AudioManager.Instance:PlayAudio('btn')
	local helpOutCards = {}
	if outCard ~= nil and #outCard > 0 then
		if helpOutCardsIndex > #outCard then
			helpOutCardsIndex = 1
		end
		if helpOutCardsIndex <= #outCard then
			helpOutCards = outCard[helpOutCardsIndex]
			helpOutCardsIndex = helpOutCardsIndex + 1
		end
	end  
	
	if helpOutCards == nil or #helpOutCards == 0 then
		panelMessageTip.SetParamers('没有大的过上家的牌', 1)
		PanelManager.Instance:ShowWindow('panelMessageTip')
		return;
	end
	this.ClearnSelectCard()
	this.OnClickBG(onClickWidget.gameObject)
	print('helpOutCardsIndex : '..helpOutCardsIndex..' #outCard length: '..#outCard..' #helpOutCards length: '..#helpOutCards..'   myCardList length: '..#myCardList)
	this.SetTiShiSelectCard(helpOutCards,myCardList)
end
function this.GetBoomHelpOutCardList()
	local helpOutCards = {}
	for i = 1, #tempIntList4 do
		table.insert(helpOutCards,tempIntList4[i] )
	end
	for i = 1, #tempIntList5 do
		table.insert(helpOutCards,tempIntList5[i] )
	end
	for i = 1, #tempIntList6 do
		table.insert(helpOutCards,tempIntList6[i] )
	end
	for i = 1, #tempIntList7 do
		table.insert(helpOutCards,tempIntList7[i] )
	end
	for i = 1, #tempIntList8 do
		table.insert(helpOutCards,tempIntList8[i] )
	end
	return helpOutCards;
end

--获得两连
function this.GetLiangLian(marr,tempMyCard,num,nohelp)
	local lianglian ={}
	for i=1,#marr-1 do
		for j=i+1,#marr do
			if marr[j]-marr[i]==1 then
				if #tempMyCard[marr[i]].trueValues >= num and #tempMyCard[marr[j]].trueValues >= num then
					local cards ={}
					for k = 1, num do
						table.insert(cards,tempMyCard[marr[i]].trueValues[k])
					end
					for k = 1, num do
						table.insert(cards,tempMyCard[marr[j]].trueValues[k])
					end
					table.sort(cards)
					table.insert(lianglian,cards)
					if not nohelp then
						if num == 2 then
							table.insert(tempIntList2,cards)
						elseif num == 3 then
							table.insert(tempIntList3,cards)
						end
					end
				end
			end
		end
	end
	return lianglian;
end

function this.GetTotalShunZi(marr,tempMyCard)
	local shunzi ={}
	if #marr > 4 then
		--5顺
		for i = 5, #marr do
			for j = 1, #marr - 4 do
				if marr[i] - marr[j] == 4 and marr[i] ~= 15 then
					if marr[i] - marr[j+1] == 3 
					and marr[i] - marr[j+2] == 2 
					and marr[i] - marr[j+3] == 1 then
						local shunzi5 = {}
						shunzi5 = this.GetShunZi(marr,tempMyCard,j,i)
						table.insert(shunzi,shunzi5)
					end
				end
			end
		end	
		--6顺
		for i = 6, #marr do
			for j = 1, #marr - 5 do
				if marr[i] - marr[j] == 5 and marr[i] ~= 15 then
					if  marr[i] - marr[j+1] == 4 
					and marr[i] - marr[j+2] == 3 
					and marr[i] - marr[j+3] == 2 
					and marr[i] - marr[j+4] == 1 then
						local shunzi6 = {}
						shunzi6 = this.GetShunZi(marr,tempMyCard,j,i)
						table.insert(shunzi,shunzi6)
					end
				end
			end
		end	
		--7顺
		for i = 7, #marr do
			for j = 1, #marr - 6 do
				if marr[i] - marr[j] == 6 and marr[i] ~= 15 then
					if  marr[i] - marr[j+1] == 5 
					and marr[i] - marr[j+2] == 4 
					and marr[i] - marr[j+3] == 3
					and marr[i] - marr[j+4] == 2
					and marr[i] - marr[j+5] == 1 then
						local shunzi7 = {}
						shunzi7 = this.GetShunZi(marr,tempMyCard,j,i)
						table.insert(shunzi,shunzi7)
					end
				end
			end
		end	
		--8顺
		for i = 8, #marr do
			for j = 1, #marr - 7 do
				if marr[i] - marr[j] == 7 and marr[i] ~= 15 then
					if  marr[i] - marr[j+1] == 6 
					and marr[i] - marr[j+2] == 5 
					and marr[i] - marr[j+3] == 4
					and marr[i] - marr[j+4] == 3
					and marr[i] - marr[j+5] == 2
					and marr[i] - marr[j+6] == 1 then
						local shunzi8 = {}
						shunzi8 = this.GetShunZi(marr,tempMyCard,j,i)
						table.insert(shunzi,shunzi8)
					end
				end
			end
		end	
		--9顺
		for i = 9, #marr do
			for j = 1, #marr - 8 do
				if marr[i] - marr[j] == 8 and marr[i] ~= 15 then
					if  marr[i] - marr[j+1] == 7
					and marr[i] - marr[j+2] == 6 
					and marr[i] - marr[j+3] == 5
					and marr[i] - marr[j+4] == 4
					and marr[i] - marr[j+5] == 3
					and marr[i] - marr[j+6] == 2
					and marr[i] - marr[j+7] == 1 then
						local shunzi9 = {}
						shunzi9 = this.GetShunZi(marr,tempMyCard,j,i)
						table.insert(shunzi,shunzi9)
					end
				end
			end
		end	
		--10顺
		for i = 10, #marr do
			for j = 1, #marr - 9 do
				if marr[i] - marr[j] == 9 and marr[i] ~= 15 then
					if  marr[i] - marr[j+1] == 8 
					and marr[i] - marr[j+2] == 7 
					and marr[i] - marr[j+3] == 6
					and marr[i] - marr[j+4] == 5
					and marr[i] - marr[j+5] == 4
					and marr[i] - marr[j+6] == 3
					and marr[i] - marr[j+7] == 2
					and marr[i] - marr[j+8] == 1 then
						local shunzi10 = {}
						shunzi10 = this.GetShunZi(marr,tempMyCard,j,i)
						table.insert(shunzi,shunzi10)
					end
				end
			end
		end	
	end
	return shunzi;
end
function this.GetShunZi(marr,tempMyCard,min,max)
	local shunzi = {}
	for i = min, max do
		table.insert(shunzi,tempMyCard[marr[i]].trueValues[1])
	end
	return shunzi
end
--获得三连及以上
function this.GetSanLian(marr,tempMyCard,lianglian,num,nohelp)
	local lianduis ={}
	for i = 1, #marr do
		if #tempMyCard[marr[i]].trueValues>=num then
			for j = 1, #lianglian do
				local vals = lianglian[j]
				if marr[i]-(GetPlateNum(vals[1])+2) == -1  then
					local liandui ={}
					for k = 1, #vals do
						table.insert(liandui,vals[k])
					end
					for l = 1, num do
						table.insert(liandui,tempMyCard[marr[i]].trueValues[l])
					end
					table.sort(liandui)
					table.insert(lianduis,liandui)
				end
			end
		end
	end
	local removeInx ={}
	for i = 1, #lianduis-1 do
		for j=i+1,#lianduis do
			if (GetPlateNum(lianduis[i][1])+2) == (GetPlateNum(lianduis[j][1])+2) then
				table.insert(removeInx,j)
			end
		end
	end
	for i = 1, #removeInx do
		table.remove(lianduis,removeInx[i])
	end
	if not nohelp then
		for i = 1, #lianduis do
			if num == 2 then
				table.insert(tempIntList2,lianduis[i])
			elseif num == 3 then
				table.insert(tempIntList3,lianduis[i])
			end
		end
	end
	return lianduis
end

function this.GetLianDui(liandui,xiaolianshu)
	local helpOutCards = {}
	for i = 1, #liandui do
		local lianduiVal = {}
		for j = 1, #liandui[i] do
			table.insert(lianduiVal,(GetPlateNum(liandui[i][j])+2))
		end
		table.sort(lianduiVal)
		if lianduiVal[1] > (GetPlateNum(xiaolianshu)+2) then
			table.insert(helpOutCards,liandui[i])
		end
		
	end
	return helpOutCards
end
function this.GetBoomList(zhadanCards,num,lastMarr)
	local cards = {}
	--先选炸弹为num个的大于其他玩家的炸弹
	for i = 1, #zhadanCards do
		if (GetPlateNum(zhadanCards[i][1])+2) > lastMarr[1] and (#zhadanCards[i]) == num then
			table.insert(cards,zhadanCards[i])
		end
	end
	--拆num个以上的炸弹
	for i = 1, #zhadanCards do
		if (GetPlateNum(zhadanCards[i][1])+2) > lastMarr[1] and (#zhadanCards[i]) > num then
			table.insert(cards,zhadanCards[i])
		end
	end
	--选num个以上的炸弹
	for i = 1, #zhadanCards do
		if (#zhadanCards[i]) > num then
			table.insert(cards,zhadanCards[i])
		end
	end
	return cards;
end
function this.findPromptCards(myCads,lasthand,noPass)
	local helpOutCards = {}
	local lastCard = lasthand.cards
	local lastCardType = lasthand.category
	local tempMyCard = this.fenXiCard(myCads)
	local tempLastCard = this.fenXiCard(lastCard)
	local lastCardCount = #lastCard
	local myCardCount = #myCads
	tempIntList1 = {}
	tempIntList2 = {}
	tempIntList3 = {}
	tempIntList4 = {}
	tempIntList5 = {}
	tempIntList6 = {}
	tempIntList7 = {}
	tempIntList8 = {}
	local myMarr = {}
	local lastMarr = {}
	print('我的牌的数量 ：'..#myCads..'  上个玩家出牌的数量 ： '..#lastCard..' 上个玩家出牌的类型 : '..lastCardType..'  是否不能点不出 ： '..tostring(noPass))
	--分析我的牌（不包括连对，飞机，顺子）
	for i = 5, 15 do
		if tempMyCard[i] then
			local val = tempMyCard[i]
			local intList ={}
			table.insert(myMarr,val.value)
			if #val.trueValues == 1 then
				for j = 1, #val.trueValues do
					table.insert(intList,val.trueValues[j] )
				end
				table.insert(tempIntList1,intList)
			elseif #val.trueValues == 2 then
				for j = 1, #val.trueValues do
					table.insert(intList,val.trueValues[j] )
				end
				table.insert(tempIntList2,intList)
			elseif #val.trueValues == 3 then
				for j = 1, #val.trueValues do
					table.insert(intList,val.trueValues[j] )
				end
				table.insert(tempIntList3,intList)
			elseif #val.trueValues == 4 then
				for j = 1, #val.trueValues do
					table.insert(intList,val.trueValues[j] )
				end
				table.insert(tempIntList4,intList)
			elseif #val.trueValues == 5 then
				for j = 1, #val.trueValues do
					table.insert(intList,val.trueValues[j] )
				end
				table.insert(tempIntList5,intList)
			elseif #val.trueValues == 6 then
				for j = 1, #val.trueValues do
					table.insert(intList,val.trueValues[j] )
				end
				table.insert(tempIntList6,intList)
			elseif #val.trueValues == 7 then
				for j = 1, #val.trueValues do
					table.insert(intList,val.trueValues[j] )
				end
				table.insert(tempIntList7,intList)
			elseif #val.trueValues == 8 then
				for j = 1, #val.trueValues do
					table.insert(intList,val.trueValues[j] )
				end
				table.insert(tempIntList8,intList)
			end
		end
		--分析上个玩家的牌
		if tempLastCard[i] then
			table.insert(lastMarr,tempLastCard[i].value)
		end
	end
	
	--我先出牌，上家没有牌，不能点pass(不提示顺子)
	if noPass then
		--连对
		local liandui2 = this.GetLiangLian(myMarr,tempMyCard,2)
		local liandui3 = this.GetSanLian(myMarr,tempMyCard,liandui2,2)
		local liandui4 = this.GetSanLian(myMarr,tempMyCard,liandui3,2)
		local liandui5 = this.GetSanLian(myMarr,tempMyCard,liandui4,2)
		local liandui6 = this.GetSanLian(myMarr,tempMyCard,liandui5,2)
		local liandui7 = this.GetSanLian(myMarr,tempMyCard,liandui6,2)
		local liandui8 = this.GetSanLian(myMarr,tempMyCard,liandui7,2)
		local liandui9 = this.GetSanLian(myMarr,tempMyCard,liandui8,2)
		local liandui10 = this.GetSanLian(myMarr,tempMyCard,liandui9,2)
		local liandui11 = this.GetSanLian(myMarr,tempMyCard,liandui10,2)
		--飞机
		local feiji2 = this.GetLiangLian(myMarr,tempMyCard,3)
		local feiji3 = this.GetSanLian(myMarr,tempMyCard,feiji2,3)
		local feiji4 = this.GetSanLian(myMarr,tempMyCard,feiji3,3)
		local feiji5 = this.GetSanLian(myMarr,tempMyCard,feiji4,3)
		local feiji6 = this.GetSanLian(myMarr,tempMyCard,feiji5,3)
		local feiji7 = this.GetSanLian(myMarr,tempMyCard,feiji6,3)
		for i = 1, #tempIntList1 do
			table.insert(helpOutCards,tempIntList1[i] )
		end
		for i = 1, #tempIntList2 do
			table.insert(helpOutCards,tempIntList2[i] )
		end
		for i = 1, #tempIntList3 do
			table.insert(helpOutCards,tempIntList3[i] )
		end
		if UnityEngine.PlayerPrefs.GetInt('XHZDcanStraight',0) == 1 then
			local shunzi = this.GetTotalShunZi(myMarr,tempMyCard)
			for i = 1, #shunzi do
				table.insert(helpOutCards,shunzi[i])
			end
		end
		for i = 1, #tempIntList4 do
			table.insert(helpOutCards,tempIntList4[i] )
		end
		for i = 1, #tempIntList5 do
			table.insert(helpOutCards,tempIntList5[i] )
		end
		for i = 1, #tempIntList6 do
			table.insert(helpOutCards,tempIntList6[i] )
		end
		for i = 1, #tempIntList7 do
			table.insert(helpOutCards,tempIntList7[i] )
		end
		for i = 1, #tempIntList8 do
			table.insert(helpOutCards,tempIntList8[i] )
		end
		print('不能点不出.........'..#helpOutCards)
		return helpOutCards
	end

	--上家出单 
	if lastCardType == 0 then
		print('上家出单.........')
		for i = 1, #tempIntList1 do
			if (GetPlateNum(tempIntList1[i][1])+2) > lastMarr[1] then
				table.insert(helpOutCards,tempIntList1[i])
			end
		end
		for i = 1, #myMarr do
			if #tempMyCard[myMarr[i]].trueValues>1 and tempMyCard[myMarr[i]].value > lastMarr[1] then
				local danpai = {}
				table.insert(danpai,tempMyCard[myMarr[i]].trueValues[1])
				table.insert(helpOutCards,danpai)
			end
		end
		local  zhadanCards = this.GetBoomHelpOutCardList();
		for i = 1, #zhadanCards do
			table.insert(helpOutCards,zhadanCards[i])
		end
		return helpOutCards
	end

	--上家出对
	if lastCardType == 1 then
		print('上家出对.........')
		for i = 1, #tempIntList2 do
			if (GetPlateNum(tempIntList2[i][1])+2) > lastMarr[1] then
				table.insert(helpOutCards,tempIntList2[i])
			end
		end
		for i = 1, #myMarr do
			if #tempMyCard[myMarr[i]].trueValues>2 and tempMyCard[myMarr[i]].value > lastMarr[1] then
				local duizi = {}
				table.insert(duizi,tempMyCard[myMarr[i]].trueValues[1])
				table.insert(duizi,tempMyCard[myMarr[i]].trueValues[2])
				table.insert(helpOutCards,duizi)
			end
		end
		local  zhadanCards = this.GetBoomHelpOutCardList();
		for i = 1, #zhadanCards do
			table.insert(helpOutCards,zhadanCards[i])
		end
		return helpOutCards
	end

	--上家出三张
	if lastCardType == 2 then
		print('上家出三张.........')
		for i = 1, #tempIntList3 do
			if (GetPlateNum(tempIntList3[i][1])+2) > (GetPlateNum(lasthand.maxCard)+2) then
				table.insert(helpOutCards,tempIntList3[i])
			end
		end
		for i = 1, #myMarr do
			if #tempMyCard[myMarr[i]].trueValues>3 and tempMyCard[myMarr[i]].value > (GetPlateNum(lasthand.maxCard)+2) then
				local sanzhang = {}
				table.insert(sanzhang,tempMyCard[myMarr[i]].trueValues[1])
				table.insert(sanzhang,tempMyCard[myMarr[i]].trueValues[2])
				table.insert(sanzhang,tempMyCard[myMarr[i]].trueValues[3])
				table.insert(helpOutCards,sanzhang)
			end
		end
		local  zhadanCards = this.GetBoomHelpOutCardList();
		for i = 1, #zhadanCards do
			table.insert(helpOutCards,zhadanCards[i])
		end
		return helpOutCards
	end

	--上家出连对
	if lastCardType == 4 then
		print('上家出连对.........')
		local liandui2 = this.GetLiangLian(myMarr,tempMyCard,2)
		local liandui3 = this.GetSanLian(myMarr,tempMyCard,liandui2,2)
		local liandui4 = this.GetSanLian(myMarr,tempMyCard,liandui3,2)
		local liandui5 = this.GetSanLian(myMarr,tempMyCard,liandui4,2)
		local liandui6 = this.GetSanLian(myMarr,tempMyCard,liandui5,2)
		local liandui7 = this.GetSanLian(myMarr,tempMyCard,liandui6,2)
		local liandui8 = this.GetSanLian(myMarr,tempMyCard,liandui7,2)
		local liandui9 = this.GetSanLian(myMarr,tempMyCard,liandui8,2)
		local liandui10 = this.GetSanLian(myMarr,tempMyCard,liandui9,2)
		local liandui11 = this.GetSanLian(myMarr,tempMyCard,liandui10,2)
		if lastCardCount == 4 and  myCardCount >=4 then
			--2连对
			helpOutCards = this.GetLianDui(liandui2,lasthand.minCard)
		elseif lastCardCount == 6 and  myCardCount >=6 then
			--3连对
			helpOutCards = this.GetLianDui(liandui3,lasthand.minCard)
		elseif lastCardCount == 8 and  myCardCount >=8 then
			--4连对
			helpOutCards = this.GetLianDui(liandui4,lasthand.minCard)
		elseif lastCardCount == 10 and  myCardCount >=10 then
			--5连对
			helpOutCards = this.GetLianDui(liandui5,lasthand.minCard)
		elseif lastCardCount == 12 and  myCardCount >=12 then
			--6连对
			helpOutCards = this.GetLianDui(liandui6,lasthand.minCard)
		elseif lastCardCount == 14 and  myCardCount >=14 then
			--7连对
			helpOutCards = this.GetLianDui(liandui7,lasthand.minCard)
		elseif lastCardCount == 16 and  myCardCount >=16 then
			--8连对
			helpOutCards = this.GetLianDui(liandui8,lasthand.minCard)
		elseif lastCardCount == 18 and  myCardCount >=18 then
			--9连对
			helpOutCards = this.GetLianDui(liandui9,lasthand.minCard)
		elseif lastCardCount == 20 and  myCardCount >=20 then
			--10连对
			helpOutCards = this.GetLianDui(liandui10,lasthand.minCard)
		elseif lastCardCount == 22 and  myCardCount >=22 then
			--11连对
			helpOutCards = this.GetLianDui(liandui11,lasthand.minCard)
		end
		local  zhadanCards = this.GetBoomHelpOutCardList();
		for i = 1, #zhadanCards do
			table.insert(helpOutCards,zhadanCards[i])
		end
		return helpOutCards
	end
	--上家出顺子
	if lastCardType == 3 then
		print('上家出顺子.........')
		if UnityEngine.PlayerPrefs.GetInt('XHZDcanStraight',0) == 1 then
			local shunzi = this.GetTotalShunZi(myMarr,tempMyCard)
			for i = 1, #shunzi do
				if (GetPlateNum(shunzi[i][1])+2) > (GetPlateNum(lasthand.minCard)+2) and #shunzi[i] == lastCardCount then
					table.insert(helpOutCards,shunzi[i])
				end
			end
		end
		local  zhadanCards = this.GetBoomHelpOutCardList();
		for i = 1, #zhadanCards do
			table.insert(helpOutCards,zhadanCards[i])
		end
		return helpOutCards
	end
	--上家出飞机
	if lastCardType == 5 then
		print('上家出飞机.........')
		local feiji2 = this.GetLiangLian(myMarr,tempMyCard,3)
		local feiji3 = this.GetSanLian(myMarr,tempMyCard,feiji2,3)
		local feiji4 = this.GetSanLian(myMarr,tempMyCard,feiji3,3)
		local feiji5 = this.GetSanLian(myMarr,tempMyCard,feiji4,3)
		local feiji6 = this.GetSanLian(myMarr,tempMyCard,feiji5,3)
		local feiji7 = this.GetSanLian(myMarr,tempMyCard,feiji6,3)
		local keyCardCount = lasthand.keyCardCount
		if keyCardCount == 2 then
			helpOutCards = this.GetLianDui(feiji2,lasthand.minCard)
		elseif keyCardCount == 3 then
			helpOutCards = this.GetLianDui(feiji3,lasthand.minCard)
		elseif keyCardCount == 4 then
			helpOutCards = this.GetLianDui(feiji4,lasthand.minCard)
		elseif keyCardCount == 5 then
			helpOutCards = this.GetLianDui(feiji5,lasthand.minCard)
		elseif keyCardCount == 6 then
			helpOutCards = this.GetLianDui(feiji6,lasthand.minCard)
		elseif keyCardCount == 7 then
			helpOutCards = this.GetLianDui(feiji7,lasthand.minCard)
		end
		local  zhadanCards = this.GetBoomHelpOutCardList();
		for i = 1, #zhadanCards do
			table.insert(helpOutCards,zhadanCards[i])
		end
		return helpOutCards
	end

	--上家出炸弹
	if lastCardType == 6 then
		print('上家出炸弹.........')
		local  zhadanCards = this.GetBoomHelpOutCardList();
		if lastCardCount == 4 then
			helpOutCards = this.GetBoomList(zhadanCards,4,lastMarr)
			return helpOutCards
		elseif lastCardCount == 5 then
			helpOutCards = this.GetBoomList(zhadanCards,5,lastMarr)
			return helpOutCards
		elseif lastCardCount == 6 then
			helpOutCards = this.GetBoomList(zhadanCards,6,lastMarr)
			return helpOutCards
		elseif lastCardCount == 7 then
			helpOutCards = this.GetBoomList(zhadanCards,7,lastMarr)
			return helpOutCards
		elseif lastCardCount == 8 then
			helpOutCards = this.GetBoomList(zhadanCards,8,lastMarr)
			return helpOutCards
		end
	end
	return helpOutCards;
end

function this.GetDaiPai(cards,feiji)
	local daipai1 = {}
	local feiji1 = {}
	local daipai = {}
	for i = 1, #cards do
		table.insert(daipai1,cards[i])
	end
	for i = 1, #feiji do
		table.insert(feiji1,feiji[i])
	end
	for i = 1, #daipai1 do
		for j = 1, #feiji1 do
			if daipai1[i] == feiji1[j] then
				daipai1[i] = -1
				feiji1[j] = -2
			end
		end
	end
	for i = 1, #daipai1 do
		if daipai1[i] ~= -1 then
			table.insert(daipai,daipai1[i])
		end
	end
	return daipai
end

function this.GetSelectType(cards,feiji,num)
	local daipai ={}
	local sandai ={}
	for i = 1, #feiji do
		table.insert(daipai,this.GetDaiPai(cards,feiji[i]))
	end
	for i = 1, #feiji do
		local fei = feiji[i]
		local aaa={}
		aaa.category =5
		aaa.feiji = feiji[i]
		aaa.daipai = daipai[i]
		aaa.max = fei[#fei]
		aaa.min = fei[1]
		aaa.keyCardCount = num
		table.insert(sandai,aaa)
	end
	return sandai
end

function this.SelectCardType(cards,myMarr,tempMyCard)
	local feiji2 = this.GetLiangLian(myMarr,tempMyCard,3,true)
	local feiji3 = this.GetSanLian(myMarr,tempMyCard,feiji2,3,true)
	local feiji4 = this.GetSanLian(myMarr,tempMyCard,feiji3,3,true)
	local feiji5 = this.GetSanLian(myMarr,tempMyCard,feiji4,3,true)
	local sandai = {}

	if feiji5 ~= nil and #feiji5>0 then
		if #cards == 15 then
			local selectType3 = this.GetSelectType(cards,feiji3,3)
			for i = 1, #selectType3 do
				table.insert(sandai,selectType3[i])
			end
			local selectType4 = this.GetSelectType(cards,feiji4,4)
			for i = 1, #selectType4 do
				table.insert(sandai,selectType4[i])
			end
			local selectType5 = this.GetSelectType(cards,feiji5,5)
			for i = 1, #selectType5 do
				table.insert(sandai,selectType5[i])
			end
		elseif #cards > 15 and #cards <= 20 then
			local selectType4 = this.GetSelectType(cards,feiji4,4)
			for i = 1, #selectType4 do
				table.insert(sandai,selectType4[i])
			end
			local selectType5 = this.GetSelectType(cards,feiji5,5)
			for i = 1, #selectType5 do
				table.insert(sandai,selectType5[i])
			end
		end
	elseif feiji4 ~= nil and #feiji4>0 then
		if #cards >= 12 and #cards <= 15 then
			local selectType3 = this.GetSelectType(cards,feiji3,3)
			for i = 1, #selectType3 do
				table.insert(sandai,selectType3[i])
			end
			local selectType4 = this.GetSelectType(cards,feiji4,4)
			for i = 1, #selectType4 do
				table.insert(sandai,selectType4[i])
			end
		end
	elseif feiji3 ~= nil and #feiji3>0 then
		if #cards >= 9 and #cards <= 10 then
			local selectType2 = this.GetSelectType(cards,feiji2,2)
			for i = 1, #selectType2 do
				table.insert(sandai,selectType2[i])
			end
			local selectType3 = this.GetSelectType(cards,feiji3,3)
			for i = 1, #selectType3 do
				table.insert(sandai,selectType3[i])
			end
		end
	end
	return sandai
end

function this.IsNeedSelectCardType(cards,lasthand,isChaiZhaDan)
	local mySelectCards = this.fenXiCard(cards)
	local mySelectCardsNum = #cards
	local myMarr ={}
	local sandai ={}
	for i = 5, 15 do
		if mySelectCards[i] then
			table.insert(myMarr, mySelectCards[i].value)
		end
	end
	if isChaiZhaDan and #myMarr==1 and (mySelectCardsNum ==4 or mySelectCardsNum == 5) then
		local feiji1 = {}
		local daipai1 = {} 
		local feiji2 = {}
		
		if mySelectCardsNum == 5 then
			for i = 1, #cards-2 do
				table.insert(feiji1,cards[i])
			end
			table.insert(daipai1,cards[#cards-1])
			table.insert(daipai1,cards[#cards])
		else
			for i = 1, #cards-1 do
				table.insert(feiji1,cards[i])
			end
			table.insert(daipai1,cards[#cards])
		end
		
		for i = 1, #cards do
			table.insert(feiji2,cards[i])
		end
		local bbb={}
		bbb.category =6
		bbb.feiji = feiji2
		bbb.daipai = {}
		bbb.max = cards[1]
		bbb.min = cards[1]
		bbb.keyCardCount = #cards
		table.insert(sandai,bbb)
		if ButtonPass.gameObject:GetComponent('UIButton').isEnabled == false or (lasthand.category == 2 and (GetPlateNum(cards[1])) > (GetPlateNum(lasthand.minCard))) then
			local aaa={}
			aaa.category =2
			aaa.feiji = feiji1
			aaa.daipai = daipai1
			aaa.max = feiji1[#feiji1]
			aaa.min = feiji1[1]
			aaa.keyCardCount = 3
			table.insert(sandai,aaa)
		end
		
	end
	if ButtonPass.gameObject:GetComponent('UIButton').isEnabled == false then
		if mySelectCardsNum >= 9 then
			sandai = this.SelectCardType(cards,myMarr,mySelectCards)
		end
	else
		local feiji2 = this.GetLiangLian(myMarr,mySelectCards,3,true)
		local feiji3 = this.GetSanLian(myMarr,mySelectCards,feiji2,3,true)
		local feiji4 = this.GetSanLian(myMarr,mySelectCards,feiji3,3,true)
		local feiji5 = this.GetSanLian(myMarr,mySelectCards,feiji4,3,true)
		if lasthand ~= nil and lasthand.category == 5 then
			if lasthand.keyCardCount == 2 then
				if feiji2 ~= nil and  #feiji2>0 then
					for i = 1, #feiji2 do
						if (GetPlateNum(feiji2[i][1])+2) > (GetPlateNum(lasthand.minCard)+2) and ((#cards - #feiji2[i]) <= (lasthand.keyCardCount*2)) then
							local aaa={}
							aaa.category =5
							aaa.feiji = feiji2[i]
							aaa.daipai = this.GetDaiPai(cards,feiji2[i])
							aaa.max = feiji2[i][#feiji2[i]]
							aaa.min = feiji2[i][1]
							aaa.keyCardCount = 2
							table.insert(sandai,aaa)
						end
					end
				end
			elseif lasthand.keyCardCount == 3 then
				if feiji3 ~= nil and  #feiji3>0 then
					for i = 1, #feiji3 do
						if (GetPlateNum(feiji3[i][1])+2) > (GetPlateNum(lasthand.minCard)+2) and ((#cards - #feiji3[i]) <= (lasthand.keyCardCount*2)) then
							local aaa={}
							aaa.category =5
							aaa.feiji = feiji3[i]
							aaa.daipai = this.GetDaiPai(cards,feiji3[i])
							aaa.max = feiji3[i][#feiji3[i]]
							aaa.min = feiji3[i][1]
							aaa.keyCardCount = 3
							table.insert(sandai,aaa)
						end
					end
				end
			elseif lasthand.keyCardCount == 4 then
				if feiji4 ~= nil and  #feiji4>0 then
					for i = 1, #feiji4 do
						if (GetPlateNum(feiji4[i][1])+2) > (GetPlateNum(lasthand.minCard)+2) and ((#cards - #feiji4[i]) <= (lasthand.keyCardCount*2)) then
							local aaa={}
							aaa.category =5
							aaa.feiji = feiji4[i]
							aaa.daipai = this.GetDaiPai(cards,feiji4[i])
							aaa.max = feiji4[i][#feiji4[i]]
							aaa.min = feiji4[i][1]
							aaa.keyCardCount = 4
							table.insert(sandai,aaa)
						end
					end
				end
			elseif lasthand.keyCardCount == 5 then	
				if feiji5 ~= nil and  #feiji5>0 then
					for i = 1, #feiji5 do
						if (GetPlateNum(feiji5[i][1])+2) > (GetPlateNum(lasthand.minCard)+2) and ((#cards - #feiji5[i]) <= (lasthand.keyCardCount*2)) then
							local aaa={}
							aaa.category =5
							aaa.feiji = feiji5[i]
							aaa.daipai = this.GetDaiPai(cards,feiji5[i])
							aaa.max = feiji5[i][#feiji5[i]]
							aaa.min = feiji5[i][1]
							aaa.keyCardCount = 5
							table.insert(sandai,aaa)
						end
					end
				end
			end
		end
	end
	if sandai ~= nil and #sandai>1 then
		return true,sandai
	end
	return false,sandai
end
function this.OnClickSelectOutCardType(go)
	local outcard ={}
	local selectCards,selectCardValues=this.getSelectCard()
	for i = 1, #selectOutCardTypes do
		if go.name == tostring(i-1) then
			outcard = selectOutCardTypes[i]
		end
	end
	local msg = Message.New()
	msg.type = xhzd_pb.PLAY
	local b = xhzd_pb.PPlay()
	for i =1,#selectCardValues do
		table.insert(b.cards, selectCardValues[i])
	end
	b.category = outcard.category
	b.maxCard = outcard.max
	b.minCard = outcard.min
	b.keyCardCount = outcard.keyCardCount
	msg.body = b:SerializeToString()
	SendGameMessage(msg, nil)
	selectOutCardType.gameObject:SetActive(false);
	
	ButtonHelp.gameObject:GetComponent('UIButton').isEnabled = false;
	ButtonPass.gameObject:GetComponent('UIButton').isEnabled = false;
	ButtonPlay.gameObject:GetComponent('UIButton').isEnabled = false;
	CountDown.gameObject:SetActive(false)
	this.ClearnSelectCard()
	helpOutCardsIndex =1
end

function this.CloseSelectOutCardType(go)
	selectOutCardType.gameObject:SetActive(false);
end

function this.OnClickButtonPlay(go)
	AudioManager.Instance:PlayAudio('btn')
	local selectCards,selectCardValues=this.getSelectCard()
	if #selectCards == 0 then
		return
	end
	
	local noPass = ButtonPass.gameObject:GetComponent('UIButton').isEnabled==false
	local canOutCard,mySelectCard,isChaiZhaDan = this.CanOutCard(selectCardValues,roomData.latestHand,noPass)
	print('#roomData.latestHand.cards : '..#roomData.latestHand.cards..'  roomData.latestHand.minCard : '..roomData.latestHand.minCard..'  roomData.latestHand.maxCard : '
	..roomData.latestHand.maxCard..'  selectCardValues : '..#selectCardValues..'   canOutCard : '..tostring(canOutCard)..'   isChaiZhaDan : '..tostring(isChaiZhaDan))
	if not canOutCard then
		panelMessageTip.SetParamers('请选择正确的牌型', 1)
		PanelManager.Instance:ShowWindow('panelMessageTip')
		local myList = this.fenXiCard(selectCardValues)
		local totalList = this.fenXiCard(myCardList)
		local grid = playerGridIn[0]
		if not XHZDIsHorizontalCards  then
			this.ExpandSelectZhaDan(myList,totalList,grid)
		end
		return 
	end
	local canSelectCardType,selectCardTypes = this.IsNeedSelectCardType(selectCardValues,roomData.latestHand,isChaiZhaDan)
	selectOutCardTypes = selectCardTypes
	if canSelectCardType then
		if #selectCardTypes <= 2 then
			print('我选择的背景是200')
			selectOutCardTypeBG:GetComponent('UISprite').height = 200
		elseif #selectCardTypes < 2 and #selectCardTypes < 5 then
			print('我选择的背景是400')
			selectOutCardTypeBG:GetComponent('UISprite').height = 400
		elseif #selectCardTypes >= 5 then
			print('我选择的背景是600')
			selectOutCardTypeBG:GetComponent('UISprite').height = 600
		end
		for i = 1, #selectCardTypes do
			local outcard = {}
			outcard.cards = selectCardValues
			outcard.feiji = selectCardTypes[i].feiji
			outcard.daipai = selectCardTypes[i].daipai
			selectOutCardGrid[i-1].gameObject:SetActive(true);
			this.RefreshOutGrid(selectOutCardTypeGrid[i-1], outcard,false,(i-1),true)
		end
		for i = 0, #selectOutCardTypeGrid do
			if i >= #selectCardTypes then
				selectOutCardGrid[i].gameObject:SetActive(false);
			end
		end
		selectOutCardType.gameObject:SetActive(true);
		for i = 0, 3 do
			selectOutCardTypeGrid[i]:GetComponent('UIGrid'):Reposition()
		end
		selectCardGrid:GetComponent('UIGrid'):Reposition()
	else
		local msg = Message.New()
		msg.type = xhzd_pb.PLAY
		local b = xhzd_pb.PPlay()
		for i =1,#mySelectCard.cards do
			table.insert(b.cards, mySelectCard.cards[i])
		end

		b.category = mySelectCard.category
		b.maxCard = mySelectCard.max
		b.minCard =mySelectCard.min
		b.keyCardCount = mySelectCard.keyCardCount
		msg.body = b:SerializeToString()
		print('mySelectCard.cards length : '..#mySelectCard.cards..'   mySelectCard.category : '..tostring(mySelectCard.category)..' max : '..mySelectCard.max..' min : '..mySelectCard.min..
		'  mySelectCard.keyCardCount : '..mySelectCard.keyCardCount)
		SendGameMessage(msg, nil)
		
		ButtonHelp.gameObject:GetComponent('UIButton').isEnabled = false;
		ButtonPass.gameObject:GetComponent('UIButton').isEnabled = false;
		ButtonPlay.gameObject:GetComponent('UIButton').isEnabled = false;
		CountDown.gameObject:SetActive(false)
		selectOutCardType.gameObject:SetActive(false);
		this.ClearnSelectCard()
		helpOutCardsIndex =1
	end
end

function this.OnClickOnButtonPass()
	local msg = Message.New()
	msg.type = xhzd_pb.PASS
	SendGameMessage(msg, nil)
	
	ButtonHelp.gameObject:GetComponent('UIButton').isEnabled = false;
	ButtonPass.gameObject:GetComponent('UIButton').isEnabled = false;
	ButtonPlay.gameObject:GetComponent('UIButton').isEnabled = false;
	CountDown.gameObject:SetActive(false);
	this.ClearnSelectCard()
	this.OnClickBG(onClickWidget.gameObject)
end

function this.OnMousePressHoverCard(go)
	this.OnClickCard(go, false)
end

function this.OnSendChat(msg)
	local b = xhzd_pb.RChat()
	b:ParseFromString(msg.body)

	local index = this.GetUIIndexBySeat(b.seat)
	if b.type == 0 then --图片
		this.showEmoji(index, b.position)
	elseif b.type == 1 then -- 语音文本
		local p = this.GetPlayerDataByUIIndex(this.GetUIIndexBySeat(b.seat))
		if p~=nil then
			this.playVoice(string.format('chat_%d_%d', p.sex, b.position))
			this.showText(index, b.text)
		end
	else --纯文本
		this.showText(index, b.text)
		local p = this.GetPlayerDataByUIIndex(this.GetUIIndexBySeat(b.seat))
		if p~=nil then
			if panelChat then
				panelChat.AddChatToLabel(p.name .. ':' .. b.text)
			else
				table.insert(this.chatTexts, p.name .. ':' .. b.text)
			end 
		end
	end
end

function this.playVoice(vioceName)
	AudioManager.Instance:PlayAudio(vioceName)
end

function this.showText(seat, text)
	coroutine.stop(playerCoroutine[seat])
	playerCoroutine[seat] = coroutine.start(function()
		playerMsg[seat].gameObject:SetActive(true)
		playerMsg[seat]:GetComponent('UILabel').text = text
		playerMsg[seat]:GetComponent('UILabel').color = Color(244/255,244/255,244/255)
		local width = playerMsg[seat]:GetComponent('UILabel').width
		playerEmoji[seat].gameObject:SetActive(false)
		coroutine.wait(5)
		playerMsg[seat].gameObject:SetActive(false)
	end)
end

function this.showEmoji(seat, position)
	local myTable = {}
	myTable['emoji_1'] = 2
	myTable['emoji_2'] = 4
	myTable['emoji_3'] = 9
	myTable['emoji_4'] = 2
	myTable['emoji_5'] = 5

	myTable['emoji_6'] = 9
	myTable['emoji_7'] = 3
	myTable['emoji_8'] = 4
	myTable['emoji_9'] = 2
	myTable['emoji_10'] = 4

	myTable['emoji_11'] = 4
	myTable['emoji_12'] = 2

	local str = 'emoji_' .. position
	playerMsg[seat].gameObject:SetActive(false)
	playerEmoji[seat].gameObject:SetActive(true)
	coroutine.stop(playerCoroutine[seat])
	playerCoroutine[seat] = coroutine.start(function()
		for i = 1, 30 do
			playerEmoji[seat]:GetComponent('UISprite').spriteName = str .. '_' .. (i % myTable[str] + 1)
			coroutine.wait(0.1)
		end
		playerEmoji[seat].gameObject:SetActive(false)
	end)
end

-- by jih，加入语音房间 ----------------------------------------------------------------------------------------------------------

function this.TickNGCloudVoice()
    while gameObject.activeSelf do
        NGCloudVoice.Instance:Poll()
        coroutine.wait(0.03)
    end
end

--是否按下录音键
local isPress = false;
--是否需要上传录音文件
local isUpload = false;
--静音前的音量值
local BGMvolume = 0
function this.OnPressButtonSound(go, state)
	print('roomData.setting.sendVoiceAllowed : '..tostring(roomData.setting.sendVoiceAllowed))
	if roomData.setting.sendVoiceAllowed then
		if state == true then
			this.startTalk()
		else
			local mousePositionY = UnityEngine.Input.mousePosition.y
			local buttonY = UnityEngine.Screen.height / 2 + (go.transform.localPosition.y * UnityEngine.Screen.height / 750)
			local buttonHeight = 3 * UnityEngine.Screen.height / 50
			if mousePositionY > buttonY + buttonHeight then
				panelMessageTip.SetParamers('取消发送', 1)
				PanelManager.Instance:ShowWindow('panelMessageTip')
				this.stopTalk(false)
				return
			end
			this.stopTalk(true)
		end
	else
		panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '群主已经禁止游戏过程中发送语音，如有疑问请联系群主')
        PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
	end
    
end
function this.StartRecord()
    WaitForSeconds(0)
    --当按住录音按钮超过0.5秒时才执行录音，因为多次短时间录的文件不会被下一次覆盖
    if isPress == true then
        isUpload = true;
        print("这里开始录制语音！！！！！！");
        NGCloudVoice.Instance:Click_btnStartRecord();
    end
end
function this.startTalk()
    isPress = true;
    isUpload = false;
    playerSound[0].gameObject:SetActive(false)
    --当还没播放完录音时，按住录音。。。。。。
    NGCloudVoice.Instance:Click_btnStopPlayRecordFile();
    --停止播放背景音乐
    AudioManager.Instance.AudioOn = false
    AudioManager.Instance.MusicOn = false
	RecordTiShi.gameObject:SetActive(true);
	--延迟0.5秒，因为不延迟会把最后一点背景声音录进去
	StartCoroutine(this.StartRecord);
end
function this.stopTalk(needUploadFile)
    isPress = false;
    --继续播放背景音乐
    AudioManager.Instance.AudioOn = UnityEngine.PlayerPrefs.GetInt('audio_on', 1) == 1
    AudioManager.Instance.MusicOn = UnityEngine.PlayerPrefs.GetInt('music_on', 1) == 1

	RecordTiShi.gameObject:SetActive(false);
	NGCloudVoice.Instance:Click_btnStopRecord();
	--超过0.5秒才上传播放录音
	if isUpload == true and needUploadFile == true then
		NGCloudVoice.Instance:Click_btnUploadFile();
		print("这里开始上传录制完后的语音！！！！！！");
	end
end

function this.UploadReccordFileComplete(fileid)
    print('发送给服务器' .. fileid)
    local msg = Message.New()
    msg.type = xhzd_pb.VOICE_MEMBER
    local body = xhzd_pb.PVoiceMember()
    body.voiceId = fileid
    msg.body = body:SerializeToString()
    SendGameMessage(msg, nil)
end
--[[    @desc: 下载录音文件完成回调
    author:{author}
    time:2018-09-12 16:29:09
    --@fileid: 录音文件id
    @return:
]]
function this.DownloadRecordFileComplete(fileid)
    print('下载完成' .. fileid);
    --停止播放背景音乐
    AudioManager.Instance.AudioOn = false;
	AudioManager.Instance.MusicOn = false;
	for i = 0, #playerData do
        if this.GetPlayerDataByUIIndex(i).voiceId == fileid then
			playerSound[i].gameObject:SetActive(true);
		else
			playerSound[i].gameObject:SetActive(false);
		end
	end
end

function this.PlayRecordFilComplete(fileid)
    --继续播放背景音乐
    if isPress == false then
        AudioManager.Instance.AudioOn = UnityEngine.PlayerPrefs.GetInt('audio_on', 1) == 1
        AudioManager.Instance.MusicOn = UnityEngine.PlayerPrefs.GetInt('music_on', 1) == 1
    end
    for i = 0, #playerData do
        if this.GetPlayerDataByUIIndex(i).voiceId == fileid then
            print('有相等的' .. fileid)
            playerSound[i].gameObject:SetActive(false)
        end
    end
end
-- 屏蔽其他玩家实时语音状态
function this.ShieldVoiceEvent()
	local canOpenSpeaker = UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 1)
	if canOpenSpeaker == 1 then
		NGCloudVoice.Instance:OpenSpeaker()
	else
		NGCloudVoice.Instance:CloseSpeaker()
	end
end

function this.GetPlayerByMemberId(memberId)
	for i = 0, roomData.setting.size - 1 do
		local p = playerData[i]
		if p and p.memberId and p.memberId == memberId then
			return p
		end
	end
	return nil
end

function this.OnVoiceMember(msg)
	print('OnVoiceMember : aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')
	local b = xhzd_pb.RVoiceMember()
	b:ParseFromString(msg.body)
	local player = playerData[b.seat]
	if player then
		player.voiceId = b.voiceId
        NGCloudVoice.Instance:Click_btnDownloadFile(player.voiceId)
	else
		print('无法通过座位号 ' .. b.seat .. ' 获取到用户信息')
	end
end

function this.RefreshState()
    while gameObject.activeSelf do
        -- 修改电池电量
        batteryLevel.fillAmount =  UnityEngine.SystemInfo.batteryLevel
        -- 重设网络状态
        local networkType = PlatformManager.Instance:GetNetworkType()
        if networkType == 1 then
            network.spriteName = 'wifi' .. this.NetLevel()
        elseif networkType == 2 then
            network.spriteName = 'gprs' .. this.NetLevel()
        elseif string.find(network.spriteName, 'wifi') then
            network.spriteName = 'wifi0'
        else
            network.spriteName = 'gprs0'
        end
        coroutine.wait(10)
    end
end

function this.NetLevel()
    if string.len(pingLabel.text) == 0 then
        return 3
    end
    local ping = tonumber(pingLabel.text)
    if ping < 100 then
        return 3
    elseif ping < 200 then
        return 2
    else
        return 1
    end
end

function this.OnPong()
	local connect = NetWorkManager.Instance:FindConnet('game')
	if connect then
		pingLabel.text = int64.tonum2(Util.GetTime()) - int64.tonum2(connect.LastHeartBeatTime)
	else 
		pingLabel.text =  ''
	end
end

function this.OnClicButtonCloseRoom(go)
	if mySeat == 0 then
		print("申请解散房间")
		AudioManager.Instance:PlayAudio('btn')
		local msg = Message.New()
		msg.type = xhzd_pb.DISSOLVE
		local body = xhzd_pb.PDissolve()
		body.decision = 0;
		msg.body = body:SerializeToString();
		SendGameMessage(msg, nil)
	else
		print("离开房间")
		AudioManager.Instance:PlayAudio('btn')
		local msg = Message.New()
		msg.type = xhzd_pb.LEAVE_ROOM
		SendGameMessage(msg, nil)
	end
	this.fanHuiRoomNumber = nil
end

function this.OnClicButtonLeaveRoom(go)
	AudioManager.Instance:PlayAudio('btn')
    if roomData.clubId == '0' then
        print('不在在牌友群中')
        this.SetMyAlpha(0)
        PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
        panelMessageTip.SetParamers('返回大厅后，您的房间将会继续保留哦', 1)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	else
        print('在牌友群中')
        this.SetMyAlpha(0)
        PanelManager.Instance:ShowWindow('panelClub',{name = gameObject.name})
        panelMessageTip.SetParamers('返回俱乐部后，您的房间将会继续保留哦', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
    end
end

function this.GetPlayerDataBySeat(seat)
	if playerData[seat] == nil then
	end
	return  playerData[seat]
end
function this.SetMyAlpha(alpha)
    gameObject.transform:GetComponent('UIPanel').alpha = alpha
end

function this.OnLordDissolve(msg)
    panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '该房间已被群主或管理员解散')
	PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
	this.fanHuiRoomNumber = nil
end

function this.OnOverTimeDissolve(msg)
	panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '规定时间内房间未开始已自动解散')
	PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.ShowPanelShare(go)
    panelShare.gameObject:SetActive(true)
end
function this.ClosePanelShare(go)
    panelShare.gameObject:SetActive(false)
end
function this.OnClicButtonCopy(go)
    local msg = '房号:' .. roomInfo.roomNumber
	msg = msg .."," .."新化炸弹,"..getXHZDRuleString(roomData.setting,false)
	print("复制的信息",msg)
    Util.CopyToSystemClipbrd(msg)
    panelMessageTip.SetParamers('复制成功', 1.5)
    PanelManager.Instance:ShowWindow('panelMessageTip')
end
function this.OnClickButtonXLInvite(go)
	local msg = '房号：' .. roomInfo.roomNumber .. '，'
	msg = msg .. roomData.setting.rounds .. '局，'

	if roomData.setting.size~=nil then
        if roomData.setting.size==2 then
			msg = msg .. '2人玩，'
        elseif roomData.setting.size==4 then
            msg = msg .. '4人玩，'
        end
    end

	if roomData.clubId ~= '0' then
		msg = msg .. '群主支付，'
	else
		if roomData.setting.paymentType == 0 then
			msg = msg .. '房主支付，'
		else
			msg = msg .. '赢家支付，'
		end
	end
	if roomData.setting.happyScoreAdd~=nil then
        if roomData.setting.happyScoreAdd==true then
            msg = msg..'喜分算加分,';
        else
            msg = msg..'喜分算乘分,';
        end
    end
    if roomData.setting.canStraight~=nil then
        if roomData.setting.canStraight == true then 
            msg = msg.."可打顺子,";
        end
    end
    if roomData.setting.bomb3AsHappy~=nil then
        if roomData.setting.bomb3AsHappy == true then 
            msg = msg.."三个炸弹算一个喜分，";
        end
	end
	
	if roomData.setting.baseScore~=nil then
        msg = msg.."底分"..roomData.setting.baseScore..'分，'
    end

    if roomData.setting.multiple~=nil then
        if roomData.setting.multiple == 1 then 
            msg = msg.."半干，"
        elseif roomData.setting.multiple == 2 then 
            msg = msg.."全干，"
        end
    end

	if roomData.setting.trusteeship then
        if roomData.setting.trusteeship == 0 then
            msg = msg .. " 不托管";
        else
            msg = msg..(roomData.setting.trusteeship/60).."分钟后托管"
            if roomData.setting.trusteeshipDissolve then
                msg = msg .. " 本局解散";
            else
                msg = msg .. " 满局解散";
            end
        end
	end

	print("分享闲聊信息",msg)
	local que = roomData.setting.size - (#playerData+1)
	local title = roomInfo.roomNumber.."房,"..roomData.playName..roomData.setting.size.."缺"..que	
    PlatformManager.Instance:ShareLinkToXL('http://'..panelLogin.HttpUrl..'/share/xl/jionRoom.html?roomId='..roomInfo.roomNumber..'&gameType='..proxy_pb.XHZD..'&appType=1', title, msg)
end

function this.NotifyGameStart()
	--通知玩家返回游戏
	if #playerData == (roomData.setting.size - 1) and roomData.round == 1 and roomData.state ~= phz_pb.GAMING then
		if this.OnRoundStarted ~= nil then
			this.OnRoundStarted()
		end
	end
end

function this.IsAllReaded()
    if roomData.setting.size - 1 == #playerData  then
        for i=0,#playerData do
            if playerData[i].ready == false then
                return false
            end
        end
    else
        return false
    end

    return true
end
--给牌面赋值
function this.setPai(item,mycard,index)
	local t = item.transform:Find('type')
	local tSmall = item.transform:Find('typeSmall')
	local num = item.transform:Find('num')
	tSmall.gameObject:SetActive(false)
	num.gameObject:SetActive(false)
	t.gameObject:SetActive(false)
	local trueValue = index and mycard.trueValues[index] or mycard.trueValues[1]
	SetUserData(item.gameObject, trueValue)
	if trueValue < 52 then
		local strType
		local col = Color.white
		if mycard.type[index] == 0 then
			strType='DiamondIcon1'
			col = Color.white
		elseif mycard.type[index] == 1 then
			strType='ClubIcon1'
			col.r = 51/255
			col.g = 52/255
			col.b = 57/255
		elseif mycard.type[index] == 2 then
			strType='HeartIcon1'
			col = Color.white
		elseif mycard.type[index] == 3 then
			strType='SpadeIcon1'
			col.r = 51/255
			col.g = 52/255
			col.b = 57/255
		end
		t.gameObject:SetActive(true)
		t:GetComponent('UISprite').spriteName=strType
		tSmall:GetComponent('UISprite').spriteName=strType
		num.gameObject:SetActive(true)
		num:GetComponent('UISprite').spriteName = 'card_'..mycard.value
		num:GetComponent('UISprite').color=col
	end
end
--分析数据
function this.fenXiCard(cards)
	local myList = {}
	if cards then
		for i = 1, #cards do
			local value = GetPlateNum(cards[i])+2--逻辑值（牌面值）
			if not myList[value] then
				myList[value]={}				
				myList[value].trueValues = {}--真实的值（服务器定义的值）
				myList[value].num = 0--牌的个数
				myList[value].type = {}--牌的花色
			end
			table.insert(myList[value].trueValues,cards[i])
			myList[value].value = value
			myList[value].num = myList[value].num + 1
			table.insert(myList[value].type, GetPlateType(cards[i]))
		end
	end
	return myList
end
--初始化手牌
function this.initCardGroup()
	for i=0,playerGridIn[0].childCount-1 do 
		local group = playerGridIn[0]:GetChild(i)
		group:Find('type').gameObject:SetActive(false)
		local cardGrid = group:Find('cardGrid')
		for j=0,cardGrid.childCount-1 do
			cardGrid:GetChild(j).gameObject:SetActive(false)
		end
		group.gameObject:SetActive(false)
	end
	for i = 1, #playerGridInHorizontal do
		playerGridInHorizontal[i].gameObject:SetActive(false)
	end
end
--初始化出牌仓
function this.initOutCardGroup(grid)
	for i=0,grid.childCount-1 do
		grid:GetChild(i).gameObject:SetActive(false)
		grid:GetChild(i):GetComponent('UIWidget').alpha =1
	end
end
--给手牌賦值
function this.cardGroupFuZhi(cards,myList)
	if XHZDIsHorizontalCards then
		GridInHorizontal.gameObject:SetActive(true)
		playerGridIn[0].gameObject:SetActive(false)
		table.sort(cards)
		local sortCards={}
		if #cards<17 then
			table.sort(cards, tableSortDesc)
			for i = 1, #cards do
				table.insert(sortCards,cards[i])
			end
		else
			local cards1={}
			local cards2={}
			for i = 1, 16 do
				table.insert(cards1,cards[i])
			end
			table.sort(cards1, tableSortDesc)
			for i = 17, #cards do
				table.insert(cards2,cards[i])
			end
			table.sort(cards2, tableSortDesc)
			for i = 1, #cards1 do
				table.insert(sortCards,cards1[i])
			end
			for i = 1, #cards2 do
				table.insert(sortCards,cards2[i])
			end
		end
		for i = 1, #sortCards do
			local pai = playerGridInHorizontal[i]
			local t = pai.transform:Find('type')
			local tSmall = pai.transform:Find('typeSmall')
			local num = pai.transform:Find('num')
			pai.gameObject:SetActive(true)
			tSmall.gameObject:SetActive(false)
			SetUserData(pai.gameObject, sortCards[i])
			local strType
			local plateType = GetPlateType(sortCards[i]);
			local col 
			if plateType == 0 then
				strType = "DiamondIcon1";
				col = Color.white;
			elseif plateType == 1 then
				strType = "ClubIcon1";
				col = Color.New(51/255 ,52/255 ,57/255);
			elseif plateType == 2 then
				strType = "HeartIcon1";
				col = Color.white;
			elseif plateType == 3 then
				strType = "SpadeIcon1"
				col = Color.New(51/255 ,52/255 ,57/255);
			else
				strType = "unknow icon"
			end
			t:GetComponent('UISprite').spriteName=strType
			tSmall:GetComponent('UISprite').spriteName=strType
			num:GetComponent("UISprite").color = col
			num:GetComponent('UISprite').spriteName = 'card_'..tostring(GetPlateNum(sortCards[i])+2)
		end
		for i = 1, #playerGridInHorizontal do
			if playerGridInHorizontal[i].gameObject.activeSelf == false then
				SetUserData(playerGridInHorizontal[i].gameObject, nil)
			end
		end
		playerGridInHorizontal1:GetComponent('UIGrid'):Reposition()
		playerGridInHorizontal2:GetComponent('UIGrid'):Reposition()
	else	
		GridInHorizontal.gameObject:SetActive(false)
		playerGridIn[0].gameObject:SetActive(true)
		for i=5,15 do 
			if myList[i] then
				local v = myList[i]
				local group = playerGridIn[0]:GetChild(15-v.value)
				local cardGrid = group:Find('cardGrid')
				local type = group:Find('type')
				if v.num>=4 then
					if v.num==4 then
						type:GetComponent('UISprite').spriteName='提示_4炸'
					else
						type:GetComponent('UISprite').spriteName='提示_4炸以上'
					end
					type:Find('Label'):GetComponent('UILabel').text = v.num..'张'
					type.gameObject:SetActive(true)
				end
				for j=0,v.num-1 do
					local item = cardGrid:GetChild(j)
					item.gameObject:SetActive(true)
					this.setPai(item,v,j+1)
				end
				group.gameObject:SetActive(true)
	
				if v.num>3 then
					cardGrid:GetComponent('UIGrid').cellHeight = -15
				else
					cardGrid:GetComponent('UIGrid').cellHeight = -60
				end
				cardGrid:GetComponent('UIGrid'):Reposition()
			end
		end
		playerGridIn[0]:GetComponent('UIGrid'):Reposition()
	end
end
--给出牌赋值
function this.outCardGroupFuZhi(outcard,grid,isOutCardOneOrTow,index,isSelectOutCardType)
	if outcard.cards ~= nil and #outcard.cards>0 then
		table.sort(outcard.cards)
		if outcard.feiji ~= nil and #outcard.feiji>0 then
			table.sort(outcard.feiji)
			local feijiNum = #outcard.feiji
			local gridChildNum = grid.transform.childCount
			for i = 1,feijiNum  do
				if gridChildNum>i then
					local j 
					if isOutCardOneOrTow then
						j = gridChildNum-i
					else
						j = i-1
					end
					local item = grid:GetChild(j)
					item.gameObject:SetActive(true)
					local card=
					{
						trueValues={outcard.feiji[i]},
						type={GetPlateType(outcard.feiji[i])},
						value=GetPlateNum(outcard.feiji[i])+2
					}
					this.setPai(item,card,1)
				end
			end
			if outcard.daipai ~= nill and #outcard.daipai>0 then
				table.sort(outcard.daipai)
				for i = 1,#outcard.daipai  do
					local j 
					if isOutCardOneOrTow then
						j = gridChildNum-feijiNum-i-3
					else
						j = i+feijiNum+2
					end
					if gridChildNum>j then
						local item = grid:GetChild(j)
						item.gameObject:SetActive(true)
						local card=
						{
							trueValues={outcard.daipai[i]},
							type={GetPlateType(outcard.daipai[i])},
							value=GetPlateNum(outcard.daipai[i])+2
						}
						this.setPai(item,card,1)
					end
				end
				if isOutCardOneOrTow then
					StartCoroutine(function()
						grid:GetChild(gridChildNum-feijiNum-1):GetComponent('UIWidget').alpha =0
						grid:GetChild(gridChildNum-feijiNum-2):GetComponent('UIWidget').alpha =0
						grid:GetChild(gridChildNum-feijiNum-3):GetComponent('UIWidget').alpha =0
						grid:GetChild(gridChildNum-feijiNum-1).gameObject:SetActive(true)
						grid:GetChild(gridChildNum-feijiNum-2).gameObject:SetActive(true)
						grid:GetChild(gridChildNum-feijiNum-3).gameObject:SetActive(true)
						grid:GetComponent('UIGrid'):Reposition()
						WaitForEndOfFrame()	
						playerGridOutDaiZi[index].transform.position =  grid:GetChild(gridChildNum-feijiNum-2).transform.position
						playerGridOutDaiZi[index].gameObject:SetActive(true)
					end)
				else
					StartCoroutine(function()
						grid:GetChild(#outcard.feiji):GetComponent('UIWidget').alpha =0
						grid:GetChild(#outcard.feiji+1):GetComponent('UIWidget').alpha =0
						grid:GetChild(#outcard.feiji+2):GetComponent('UIWidget').alpha =0
						grid:GetChild(#outcard.feiji).gameObject:SetActive(true)
						grid:GetChild(#outcard.feiji+1).gameObject:SetActive(true)
						grid:GetChild(#outcard.feiji+2).gameObject:SetActive(true)
						grid:GetComponent('UIGrid'):Reposition()
						WaitForEndOfFrame()
						local vector = grid:GetChild(#outcard.feiji+1).transform.position
						if isSelectOutCardType then
							selectOutCardTypeGridDaizi[index].position = Vector3(vector.x,vector.y,vector.z+0.01)
							selectOutCardTypeGridDaizi[index].gameObject:SetActive(true)
						else
							playerGridOutDaiZi[index].transform.position =  Vector3(vector.x,vector.y,vector.z+0.01)
							playerGridOutDaiZi[index].gameObject:SetActive(true)
						end
						
					end)
				end
			else
				grid:GetComponent('UIGrid'):Reposition()
			end
		else
			for i = 1,#outcard.cards  do
				if grid.transform.childCount>=i then
					local item
					if isOutCardOneOrTow then
						item = grid:GetChild(grid.transform.childCount-i)
					else
						item = grid:GetChild(i-1)
					end
					item.gameObject:SetActive(true)
					local card=
					{
						trueValues={outcard.cards[i]},
						type={GetPlateType(outcard.cards[i])},
						value=GetPlateNum(outcard.cards[i])+2
					}
					this.setPai(item,card,1)
				end
			end
			grid:GetComponent('UIGrid'):Reposition()
		end
	end
end
--刷新出的牌
function this.RefreshOutGrid(grid, outcard,isOutCardOneOrTow,index,isSelectOutCardType)
	this.initOutCardGroup(grid)--初始化出牌仓
	this.outCardGroupFuZhi(outcard,grid,isOutCardOneOrTow,index,isSelectOutCardType)--给出牌复制
end
--刷新自己手牌
function this.RefreshGrid(cards)
	local myList = this.fenXiCard(cards)--分析数据  存到该表
	this.initCardGroup()--初始化手牌
	this.cardGroupFuZhi(cards,myList)--给手牌复制
end
--点击牌
function this.OnClickCard(go, isClick)
	AudioManager.Instance:PlayAudio('touchcard')
	if XHZDIsHorizontalCards then
		for i = 1, #playerGridInHorizontal do
			if playerGridInHorizontal[i].gameObject == go then
				if go.transform.localPosition.y == 0 then
					local pos = go.transform.localPosition
					pos.y = 20
					go.transform.localPosition = pos
				else
					local pos = go.transform.localPosition
					pos.y = 0
					go.transform.localPosition = pos
				end
			end
		end
	else
		if go.transform:Find('typeBig').gameObject.activeSelf == false then
			go.transform:Find('typeBig').gameObject:SetActive(true)
		else
			go.transform:Find('typeBig').gameObject:SetActive(false)
		end
		local grid = go.transform.parent
		local cardNum = 0
		for j=0,grid.childCount-1 do
			if grid:GetChild(j).gameObject.activeSelf then
				cardNum = cardNum+1
			end
		end
		local gridComponent = grid:GetComponent('UIGrid')
		if cardNum == 2 or cardNum == 3 then
			if gridComponent.cellHeight~=-60 and gridComponent.cellHeight>-60 then
				gridComponent.cellHeight=-60
				gridComponent:Reposition()
			end
		elseif cardNum == 4 or cardNum == 5 or cardNum == 6 then
			if gridComponent.cellHeight~=-39 and gridComponent.cellHeight>-39 then
				gridComponent.cellHeight=-39
				gridComponent:Reposition()
			end
		elseif cardNum == 7 then
			if gridComponent.cellHeight~=-32 and gridComponent.cellHeight>-32 then
				gridComponent.cellHeight=-32
				gridComponent:Reposition()
			end
		elseif cardNum == 8 then
			if gridComponent.cellHeight~=-28 and gridComponent.cellHeight>-28 then
				gridComponent.cellHeight=-28
				gridComponent:Reposition()
			end
		end
		grid.parent:Find('type').gameObject:SetActive(false)	
	end
	if CountDown.gameObject.activeSelf then
		local selectCards,selectCardValues=this.getSelectCard()
		if #selectCards>0 then
			ButtonPlay.gameObject:GetComponent('UIButton').isEnabled = true;
		else 
			ButtonPlay.gameObject:GetComponent('UIButton').isEnabled = false;
		end
	end
end
function this.GetSeletCard(cards,category,max,min,key)
	local mySelectCard ={}
	mySelectCard.cards = cards
	mySelectCard.category = category
	mySelectCard.max = max
	mySelectCard.min =min
	mySelectCard.keyCardCount = key
	return mySelectCard
end
--上家有牌
function this.IsZhaDanChai(feiji,lasthand,myCards,cards,key)
	if feiji ~= nil and #feiji>0 then
		local myfeiji = this.GetLianDui(feiji,lasthand.minCard)
		if myfeiji[1] ~= nil and #myfeiji[1]>0 then
			for i = 1, #myfeiji[1],3 do
				if myCards[GetPlateNum(myfeiji[1][i])+2].num>3  then
					if (#cards - #myfeiji[1]) <= (key*2) then
						return  true,this.GetSeletCard(cards,5,(myfeiji[1][#myfeiji[1]]),(myfeiji[1][1]),key),true
					end
				end
			end
			if (#cards - #myfeiji[1]) <= (key*2) then
				return  true,this.GetSeletCard(cards,5,(myfeiji[1][#myfeiji[1]]),(myfeiji[1][1]),key),false
			end
		end
	end
	return false,nil,false
end

function this.IsZhaDanChai2(feiji,myCards,cards,key)
	if feiji ~= nil and #feiji>0 then
		for i = 1, #feiji[1],3 do
			if myCards[GetPlateNum(feiji[1][i])+2].num>3  then
				return  true,this.GetSeletCard(cards,5,(feiji[1][#feiji[1]]),feiji[1][1],key),true
			end
		end
		return  true,this.GetSeletCard(cards,5,(feiji[1][#feiji[1]]),(feiji[1][1]),key),false
	end
	return false,nil,false
end

function this.CanOutCard(cards,lasthand,nopass)
	table.sort(cards)
	local myCards = this.fenXiCard(cards)
	local cardsNum = #cards
	local myMarr = {}
	
	for i = 5, 15 do
		if myCards[i] then
			table.insert(myMarr,myCards[i].value)
		end
	end
	local feiji2 = this.GetLiangLian(myMarr,myCards,3,true)
	local feiji3 = this.GetSanLian(myMarr,myCards,feiji2,3,true)
	local feiji4 = this.GetSanLian(myMarr,myCards,feiji3,3,true)
	local feiji5 = this.GetSanLian(myMarr,myCards,feiji4,3,true)
	local feiji6 = this.GetSanLian(myMarr,myCards,feiji5,3,true)
	local feiji7 = this.GetSanLian(myMarr,myCards,feiji6,3,true)

	local liandui2 = this.GetLiangLian(myMarr,myCards,2,true)
	local liandui3 = this.GetSanLian(myMarr,myCards,liandui2,2,true)
	local liandui4 = this.GetSanLian(myMarr,myCards,liandui3,2,true)
	local liandui5 = this.GetSanLian(myMarr,myCards,liandui4,2,true)
	local liandui6 = this.GetSanLian(myMarr,myCards,liandui5,2,true)
	local liandui7 = this.GetSanLian(myMarr,myCards,liandui6,2,true)
	local liandui8 = this.GetSanLian(myMarr,myCards,liandui7,2,true)
	local liandui9 = this.GetSanLian(myMarr,myCards,liandui8,2,true)
	local liandui10 = this.GetSanLian(myMarr,myCards,liandui9,2,true)
	local liandui11 = this.GetSanLian(myMarr,myCards,liandui10,2,true)
	if not nopass and  lasthand ~= nil and #lasthand.cards>0 then
		print('上家不是自己..............')
		local lastMarr = {}
		local lastCards = this.fenXiCard(lasthand.cards)
		local lastCardsNum = #lasthand.cards
		local lastcardsCategory = lasthand.category
		for i = 5, 15 do
			if lastCards[i] then
				table.insert(lastMarr,lastCards[i].value)
			end
		end
		if lastcardsCategory == 0 then
			--单牌
			if cardsNum == 1 then
				if #myMarr==1 and myMarr[1] > lastMarr[1] then
					return true,this.GetSeletCard(cards,0,cards[1],cards[1],cardsNum),false
				end
			end
			if cardsNum>3 and #myMarr == 1 then
				return  true,this.GetSeletCard(cards,6,cards[1],cards[1],cardsNum),false
			end
		elseif lastcardsCategory == 1 then
			--对子
			if cardsNum == 2 then
				if #myMarr==1 and myMarr[1] > lastMarr[1] then
					return true,this.GetSeletCard(cards,1,cards[1],cards[1],cardsNum),false
				end
			end
			if cardsNum>3 and #myMarr == 1 then
				return  true,this.GetSeletCard(cards,6,cards[1],cards[1],cardsNum),false
			end
		elseif lastcardsCategory == 2 then
			--三张
			print('上家出三张')
			
			if (cardsNum >= 3 and cardsNum <=5) then
				local lastval
				for i = 5, 15 do
					if lastCards[i] then
						if lastCards[i].num>=3 then
							lastval = i
						end
					end
				end
				for i = 5, 15 do
					if myCards[i] then
						if myCards[i].num == 3 and i>lastval then
							return  true,this.GetSeletCard(cards,2,myCards[i].trueValues[1],myCards[i].trueValues[1],3),false
						elseif myCards[i].num == 4 and i>lastval  then
							return  true,this.GetSeletCard(cards,2,myCards[i].trueValues[1],myCards[i].trueValues[1],3),true
						elseif myCards[i].num == 5 and i>lastval  then
							return  true,this.GetSeletCard(cards,2,myCards[i].trueValues[1],myCards[i].trueValues[1],3),true
						end
					end
				end
			end
			if cardsNum>3 and #myMarr == 1 then
				return  true,this.GetSeletCard(cards,6,cards[1],cards[1],cardsNum),false
			end
		elseif lastcardsCategory == 3 then	
			--单顺
			print('上家出单顺')
			if cardsNum == lastCardsNum 
			and #myMarr==#lastMarr 
			and myMarr[1]>lastMarr[1] 
			and myMarr[#myMarr] ~= 15 then
				return  true,this.GetSeletCard(cards,3,cards[#cards],cards[1],cardsNum),false
			end
			if cardsNum>3 and #myMarr == 1 then
				return  true,this.GetSeletCard(cards,6,cards[1],cards[1],cardsNum),false
			end
		elseif lastcardsCategory == 4 then
			--双顺
			print('上家出连对')
			if cardsNum == lastCardsNum 
			and #myMarr==#lastMarr 
			and myMarr[1]>lastMarr[1] then
				return  true,this.GetSeletCard(cards,4,cards[#cards],cards[1],cardsNum),false
			end
			if cardsNum>3 and #myMarr == 1 then
				return  true,this.GetSeletCard(cards,6,cards[1],cards[1],cardsNum),false
			end
		elseif lastcardsCategory == 5 then
			--飞机
			print('上家出飞机')
			if cardsNum>3 and cardsNum<9 then
				if #myMarr == 1 then
					return  true,this.GetSeletCard(cards,6,cards[1],cards[1],cardsNum),false
				else
					if lasthand.keyCardCount == 2 then
						return this.IsZhaDanChai(feiji2,lasthand,myCards,cards,2)
					end
				end
			else
				if lasthand.keyCardCount == 2 then
					return this.IsZhaDanChai(feiji2,lasthand,myCards,cards,2)
				elseif lasthand.keyCardCount == 3 then
					return this.IsZhaDanChai(feiji3,lasthand,myCards,cards,3)
				elseif lasthand.keyCardCount == 4 then
					return this.IsZhaDanChai(feiji4,lasthand,myCards,cards,4)
				elseif lasthand.keyCardCount == 5 then
					return this.IsZhaDanChai(feiji5,lasthand,myCards,cards,5)
				elseif lasthand.keyCardCount == 6 then
					return this.IsZhaDanChai(feiji6,lasthand,myCards,cards,6)
				elseif lasthand.keyCardCount == 7 then
					return this.IsZhaDanChai(feiji7,lasthand,myCards,cards,7)
				end
			end
		elseif lastcardsCategory == 6 then
			--炸弹
			print('上家出炸弹')
			if  #myMarr==1 then
				if cardsNum>lastCardsNum  then
					return true,this.GetSeletCard(cards,6,cards[1],cards[1],cardsNum),false
				elseif cardsNum == lastCardsNum  and myMarr[1]>lastMarr[1] then
					return true,this.GetSeletCard(cards,6,cards[1],cards[1],cardsNum),false
				end
			end
		end
		return false,nil,false
	else
		print('上家是自己................'..'  cardsNum : '..cardsNum)
		if cardsNum == 1 then
			return true,this.GetSeletCard(cards,0,cards[1],cards[1],cardsNum),false
		elseif cardsNum == 2 then
			if #myMarr == 1 then
				return true,this.GetSeletCard(cards,1,cards[1],cards[1],cardsNum),false
			end
		elseif cardsNum == 3 then
			if #myMarr == 1 then
				return true,this.GetSeletCard(cards,2,cards[1],cards[1],3),false
			end
		elseif cardsNum == 4 then
			if #myMarr == 1 then
				return true,this.GetSeletCard(cards,6,cards[1],cards[1],cardsNum),true
			end
			if #myMarr == 2 then
				for i = 1, #myMarr do
					if myCards[myMarr[i]].num == 3 then
						return true,this.GetSeletCard(cards,2,myCards[myMarr[i]].trueValues[1],myCards[myMarr[i]].trueValues[1],3),false
					end
				end
				if liandui2 ~= nil and #liandui2>0 then
					return  true,this.GetSeletCard(cards,4,(liandui2[1][#liandui2[1]]),(liandui2[1][1]),cardsNum),false
				end
			end
		elseif cardsNum == 5 then
			if #myMarr == 1 then
				return true,this.GetSeletCard(cards,6,cards[1],cards[1],cardsNum),true
			elseif #myMarr == 2 then
				for i = 1, #myMarr do
					if myCards[myMarr[i]].num == 3 then
						return true,this.GetSeletCard(cards,2,myCards[myMarr[i]].trueValues[1],myCards[myMarr[i]].trueValues[1],3),false
					elseif myCards[myMarr[i]].num == 4 then
						return true,this.GetSeletCard(cards,2,myCards[myMarr[i]].trueValues[1],myCards[myMarr[i]].trueValues[1],3),true
					end
				end
			elseif #myMarr == 3 then
				for i = 1, #myMarr do
					if myCards[myMarr[i]].num == 3 then
						return true,this.GetSeletCard(cards,2,myCards[myMarr[i]].trueValues[1],myCards[myMarr[i]].trueValues[1],3),false
					end
				end
			elseif #myMarr == 5 then
				if myMarr[5] - myMarr[4] == 1 
				and myMarr[5] - myMarr[3] == 2
				and myMarr[5] - myMarr[2] == 3
				and myMarr[5] - myMarr[1] == 4 then
					return this.IsCanOutShunZi(cards,myMarr,cardsNum)
				end
			end
		elseif cardsNum == 6 then
			if #myMarr == 1 then
				return true,this.GetSeletCard(cards,6,cards[1],cards[1],cardsNum),false
			elseif #myMarr == 2 then
				return this.IsZhaDanChai2(feiji2,myCards,cards,2)
			elseif #myMarr == 3 then
				if liandui3 ~= nil and #liandui3>0 then
					return  true,this.GetSeletCard(cards,4,(liandui3[1][#liandui3[1]]),(liandui3[1][1]),#cards),false
				end
			elseif #myMarr == 6 then
				if  myMarr[6] - myMarr[5] == 1 
				and myMarr[6] - myMarr[4] == 2
				and myMarr[6] - myMarr[3] == 3
				and myMarr[6] - myMarr[2] == 4
				and myMarr[6] - myMarr[1] == 5 then
					return this.IsCanOutShunZi(cards,myMarr,cardsNum)
				end
			end
		elseif cardsNum == 7 then
			if #myMarr == 1 then
				return true,this.GetSeletCard(cards,6,cards[1],cards[1],cardsNum),false
			elseif #myMarr == 2 or #myMarr == 3 then
				return this.IsZhaDanChai2(feiji2,myCards,cards,2)
			elseif #myMarr == 7 then
				if  myMarr[7] - myMarr[6] == 1 
				and myMarr[7] - myMarr[5] == 2
				and myMarr[7] - myMarr[4] == 3
				and myMarr[7] - myMarr[3] == 4
				and myMarr[7] - myMarr[2] == 5
				and myMarr[7] - myMarr[1] == 6 then
					return this.IsCanOutShunZi(cards,myMarr,cardsNum)
				end
			end
		elseif cardsNum == 8 then
			if #myMarr == 1 then
				return true,this.GetSeletCard(cards,6,cards[1],cards[1],cardsNum),false
			elseif #myMarr == 2 or #myMarr == 3 then
				return this.IsZhaDanChai2(feiji2,myCards,cards,2)
			elseif #myMarr == 4 then
				if feiji2 ~= nil and #feiji2>0 then
					return this.IsZhaDanChai2(feiji2,myCards,cards,2)
				end
				if liandui4 ~= nil and #liandui4>0 then
					return  true,this.GetSeletCard(cards,4,(liandui4[1][#liandui4[1]]),(liandui4[1][1]),#cards),false
				end
			elseif #myMarr == 8 then
				if  myMarr[8] - myMarr[7] == 1 
				and myMarr[8] - myMarr[6] == 2
				and myMarr[8] - myMarr[5] == 3
				and myMarr[8] - myMarr[4] == 4
				and myMarr[8] - myMarr[3] == 5
				and myMarr[8] - myMarr[2] == 6
				and myMarr[8] - myMarr[1] == 7 then
					return this.IsCanOutShunZi(cards,myMarr,cardsNum)
				end
			end
		elseif cardsNum == 9 then
			if #myMarr == 2 or #myMarr == 4 or #myMarr == 5 then
				return this.IsZhaDanChai2(feiji2,myCards,cards,2)
			elseif #myMarr == 3 then
				if feiji3 ~= nil and #feiji3>0 then
					return this.IsZhaDanChai2(feiji3,myCards,cards,3)
				else
					return this.IsZhaDanChai2(feiji2,myCards,cards,2)
				end
			elseif #myMarr == 9 then
				if  myMarr[9] - myMarr[8] == 1 
				and myMarr[9] - myMarr[7] == 2
				and myMarr[9] - myMarr[6] == 3
				and myMarr[9] - myMarr[5] == 4
				and myMarr[9] - myMarr[4] == 5
				and myMarr[9] - myMarr[3] == 6
				and myMarr[9] - myMarr[2] == 7
				and myMarr[9] - myMarr[1] == 8 then
					return this.IsCanOutShunZi(cards,myMarr,cardsNum)
				end
			end
		elseif cardsNum == 10 then
			if #myMarr == 2 or #myMarr == 6 then
				return this.IsZhaDanChai2(feiji2,myCards,cards,2)
			elseif #myMarr == 3 or #myMarr == 4 then
				if feiji3 ~= nil and #feiji3>0 then
					return this.IsZhaDanChai2(feiji3,myCards,cards,3)
				else
					return this.IsZhaDanChai2(feiji2,myCards,cards,2)
				end
			elseif #myMarr == 5 then
				if feiji2 ~= nil and #feiji2>0 then
					return this.IsZhaDanChai2(feiji2,myCards,cards,2)
				end
				if liandui5 ~= nil and #liandui5>0 then
					return  true,this.GetSeletCard(cards,4,(liandui5[1][#liandui5[1]]),(liandui5[1][1]),#cards),false
				end
			elseif #myMarr == 10 then
				if  myMarr[10] - myMarr[9] == 1 
				and myMarr[10] - myMarr[8] == 2
				and myMarr[10] - myMarr[7] == 3
				and myMarr[10] - myMarr[6] == 4
				and myMarr[10] - myMarr[5] == 5
				and myMarr[10] - myMarr[4] == 6
				and myMarr[10] - myMarr[3] == 7
				and myMarr[10] - myMarr[2] == 8
				and myMarr[10] - myMarr[1] == 9 then
					return this.IsCanOutShunZi(cards,myMarr,cardsNum)
				end
			end
		elseif cardsNum == 11 then
			if #myMarr == 3 or #myMarr == 4 or #myMarr == 5 then
				return this.IsZhaDanChai2(feiji3,myCards,cards,3)
			end
		elseif cardsNum == 12 then
			if #myMarr == 3 or #myMarr == 5 then
				return this.IsZhaDanChai2(feiji3,myCards,cards,3)
			elseif #myMarr == 4 then
				if feiji4 ~= nil and #feiji4>0 then
					return this.IsZhaDanChai2(feiji4,myCards,cards,4)
				else
					return this.IsZhaDanChai2(feiji3,myCards,cards,3)
				end
			elseif #myMarr == 6 then
				if feiji3 ~= nil and #feiji3>0 then
					return this.IsZhaDanChai2(feiji3,myCards,cards,3)
				end
				if liandui6 ~= nil and #liandui6>0 then
					return  true,this.GetSeletCard(cards,4,(liandui6[1][#liandui6[1]]),(liandui6[1][1]),#cards),false
				end
			end
		elseif cardsNum == 13 then
			if #myMarr == 3 or #myMarr == 6 or #myMarr == 7 or #myMarr == 8 or #myMarr == 9 then
				return this.IsZhaDanChai2(feiji3,myCards,cards,3)
			elseif  #myMarr == 4 or #myMarr == 5 then
				if feiji4 ~= nil and #feiji4>0 then
					return this.IsZhaDanChai2(feiji4,myCards,cards,4)
				else
					return this.IsZhaDanChai2(feiji3,myCards,cards,3)
				end
			end
		elseif cardsNum == 14 then
			if #myMarr == 3 or #myMarr == 8  or #myMarr == 9 then
				return this.IsZhaDanChai2(feiji3,myCards,cards,3)
			elseif #myMarr == 4 or #myMarr == 5 or #myMarr == 6 then
				if feiji4 ~= nil and #feiji4>0 then
					return this.IsZhaDanChai2(feiji4,myCards,cards,4)
				else
					return this.IsZhaDanChai2(feiji3,myCards,cards,3)
				end
			elseif #myMarr == 7 then
				if feiji3 ~= nil and #feiji3>0 then
					return this.IsZhaDanChai2(feiji3,myCards,cards,3)
				end
				if liandui7 ~= nil and #liandui7>0 then
					return  true,this.GetSeletCard(cards,4,(liandui7[1][#liandui7[1]]),(liandui7[1][1]),#cards),false
				end	
			end
		elseif cardsNum == 15 then
			if #myMarr == 3 or #myMarr == 8 or #myMarr == 9 then
				return this.IsZhaDanChai2(feiji3,myCards,cards,3)
			elseif #myMarr == 4 or #myMarr == 7 or #myMarr == 6 then
				if feiji4 ~= nil and #feiji4>0 then
					return this.IsZhaDanChai2(feiji4,myCards,cards,4)
				else
					return this.IsZhaDanChai2(feiji3,myCards,cards,3)
				end
			elseif #myMarr == 5 then
				if feiji5 ~= nil and #feiji5>0 then
					return this.IsZhaDanChai2(feiji5,myCards,cards,5)
				elseif feiji4 ~= nil and #feiji4>0 then
					return this.IsZhaDanChai2(feiji4,myCards,cards,4)
				elseif feiji3 ~= nil and #feiji3>0 then
					return this.IsZhaDanChai2(feiji3,myCards,cards,3)
				end
			end
		elseif cardsNum == 16 then
			if #myMarr == 4 or #myMarr == 7 then
				return this.IsZhaDanChai2(feiji4,myCards,cards,4)
			elseif #myMarr == 5 or #myMarr == 6 then
				if feiji5 ~= nil and #feiji5>0 then
					return this.IsZhaDanChai2(feiji5,myCards,cards,5)
				elseif feiji4 ~= nil and #feiji4>0 then
					return this.IsZhaDanChai2(feiji4,myCards,cards,4)
				end
			elseif #myMarr == 8 then
				if feiji4 ~= nil and #feiji4>0 then
					return this.IsZhaDanChai2(feiji4,myCards,cards,4)
				end
				if liandui8 ~= nil and #liandui8>0 then
					return  true,this.GetSeletCard(cards,4,(liandui8[1][#liandui8[1]]),(liandui8[1][1]),#cards),false
				end	
			end
		elseif cardsNum == 17 then
			if #myMarr == 4 or #myMarr == 8 or #myMarr == 9 then
				return this.IsZhaDanChai2(feiji4,myCards,cards,4)
			elseif #myMarr == 5 or #myMarr == 6 or #myMarr == 7  then
				if feiji5 ~= nil and #feiji5>0 then
					return this.IsZhaDanChai2(feiji5,myCards,cards,5)
				elseif feiji4 ~= nil and #feiji4>0 then
					return this.IsZhaDanChai2(feiji4,myCards,cards,4)
				end
			end
		elseif cardsNum == 18 then
			if #myMarr == 4 or #myMarr == 10 then
				return this.IsZhaDanChai2(feiji4,myCards,cards,4)
			elseif #myMarr == 5 or #myMarr == 8 or #myMarr == 7  then
				if feiji5 ~= nil and #feiji5>0 then
					return this.IsZhaDanChai2(feiji5,myCards,cards,5)
				elseif feiji4 ~= nil and #feiji4>0 then
					return this.IsZhaDanChai2(feiji4,myCards,cards,4)
				end
			elseif #myMarr == 6 then
				if feiji6 ~= nil and #feiji6>0 then
					return this.IsZhaDanChai2(feiji6,myCards,cards,6)
				elseif feiji5 ~= nil and #feiji5>0 then
					return this.IsZhaDanChai2(feiji5,myCards,cards,5)
				elseif feiji4 ~= nil and #feiji4>0 then
					return this.IsZhaDanChai2(feiji4,myCards,cards,4)
				end
			elseif #myMarr == 9 then
				if feiji4 ~= nil and #feiji4>0 then
					return this.IsZhaDanChai2(feiji4,myCards,cards,4)
				end
				if liandui9 ~= nil and #liandui9>0 then
					return  true,this.GetSeletCard(cards,4,(liandui9[1][#liandui9[1]]),(liandui9[1][1]),#cards),false
				end	
			end
		elseif cardsNum == 19 then
			if #myMarr == 4 or #myMarr == 10 or #myMarr == 11 then
				return this.IsZhaDanChai2(feiji4,myCards,cards,4)
			elseif #myMarr == 5 or #myMarr == 8 or #myMarr == 9 then
				if feiji5 ~= nil and #feiji5>0 then
					return this.IsZhaDanChai2(feiji5,myCards,cards,5)
				elseif feiji4 ~= nil and #feiji4>0 then
					return this.IsZhaDanChai2(feiji4,myCards,cards,4)
				end
			elseif #myMarr == 6 or #myMarr == 7 then
				if feiji6 ~= nil and #feiji6>0 then
					return this.IsZhaDanChai2(feiji6,myCards,cards,6)
				elseif feiji5 ~= nil and #feiji5>0 then
					return this.IsZhaDanChai2(feiji5,myCards,cards,5)
				elseif feiji4 ~= nil and #feiji4>0 then
					return this.IsZhaDanChai2(feiji4,myCards,cards,4)
				end
			end
		elseif cardsNum == 20 then
			if #myMarr == 4 or  #myMarr == 11 then
				return this.IsZhaDanChai2(feiji4,myCards,cards,4)
			elseif #myMarr == 5 or #myMarr == 9 then
				if feiji5 ~= nil and #feiji5>0 then
					return this.IsZhaDanChai2(feiji5,myCards,cards,5)
				elseif feiji4 ~= nil and #feiji4>0 then
					return this.IsZhaDanChai2(feiji4,myCards,cards,4)
				end
			elseif #myMarr == 6 or #myMarr == 7 or #myMarr == 8 then
				if feiji6 ~= nil and #feiji6>0 then
					return this.IsZhaDanChai2(feiji6,myCards,cards,6)
				elseif feiji5 ~= nil and #feiji5>0 then
					return this.IsZhaDanChai2(feiji5,myCards,cards,5)
				elseif feiji4 ~= nil and #feiji4>0 then
					return this.IsZhaDanChai2(feiji4,myCards,cards,4)
				end
			elseif #myMarr == 10 then
				if feiji5 ~= nil and #feiji5>0 then
					return this.IsZhaDanChai2(feiji5,myCards,cards,5)
				elseif feiji4 ~= nil and #feiji4>0 then
					return this.IsZhaDanChai2(feiji4,myCards,cards,4)
				end
				if liandui10 ~= nil and #liandui10>0 then
					return  true,this.GetSeletCard(cards,4,(liandui10[1][#liandui10[1]]),(liandui10[1][1]),#cards),false
				end	
			end
		elseif cardsNum == 21 then
			if #myMarr == 5 or #myMarr == 10 or #myMarr == 11 then
				return this.IsZhaDanChai2(feiji5,myCards,cards,5)
			elseif #myMarr == 6 or #myMarr == 8 or #myMarr == 9 then
				if feiji6 ~= nil and #feiji6>0 then
					return this.IsZhaDanChai2(feiji6,myCards,cards,6)
				elseif feiji5 ~= nil and #feiji5>0 then
					return this.IsZhaDanChai2(feiji5,myCards,cards,5)
				end
			elseif #myMarr == 7 then
				if feiji7 ~= nil and #feiji7>0 then
					return this.IsZhaDanChai2(feiji7,myCards,cards,7)
				elseif feiji6 ~= nil and #feiji6>0 then
					return this.IsZhaDanChai2(feiji6,myCards,cards,6)
				elseif feiji5 ~= nil and #feiji5>0 then
					return this.IsZhaDanChai2(feiji5,myCards,cards,5)
				end
			end
		else
			if #myMarr == 5 then
				return this.IsZhaDanChai2(feiji5,myCards,cards,5)
			elseif #myMarr == 6 or #myMarr == 9 or #myMarr == 10 then
				if feiji6 ~= nil and #feiji6>0 then
					return this.IsZhaDanChai2(feiji6,myCards,cards,6)
				elseif feiji5 ~= nil and #feiji5>0 then
					return this.IsZhaDanChai2(feiji5,myCards,cards,5)
				end
			elseif #myMarr == 7  or #myMarr == 8 then
				if feiji7 ~= nil and #feiji7>0 then
					return this.IsZhaDanChai2(feiji7,myCards,cards,7)
				elseif feiji6 ~= nil and #feiji6>0 then
					return this.IsZhaDanChai2(feiji6,myCards,cards,6)
				elseif feiji5 ~= nil and #feiji5>0 then
					return this.IsZhaDanChai2(feiji5,myCards,cards,5)
				end
			elseif #myMarr == 11 then
				if feiji5 ~= nil and #feiji5>0 then
					return this.IsZhaDanChai2(feiji5,myCards,cards,5)
				elseif liandui11 ~= nil and #liandui11>0 then
					return  true,this.GetSeletCard(cards,4,(liandui11[1][#liandui11[1]]),(liandui11[1][1]),#cards),false
				end	
			end
			
		end
		return false,nil,false
	end
end

function this.IsCanOutShunZi(cards,myMarr,cardsNum)
	if UnityEngine.PlayerPrefs.GetInt('XHZDcanStraight',0) == 1 and (GetPlateNum(cards[#cards])+2) ~= 15 then
		return true,this.GetSeletCard(cards,3,cards[#cards],cards[1],cardsNum),false
	end
	return false,nil,false
end
--点击桌面缩回展开的牌
function this.OnClickBG(go)
	--print('清空了')
	for i=0,playerGridIn[0].childCount-1 do
		local cardNum = 0
		local paiGrid=playerGridIn[0]:GetChild(i):Find('cardGrid')
		for j=0,paiGrid.childCount-1 do
			if paiGrid:GetChild(j).gameObject.activeSelf then
				cardNum = cardNum+1
			end
		end
		if cardNum>3 then
			playerGridIn[0]:GetChild(i):Find('type').gameObject:SetActive(true)
			paiGrid:GetComponent('UIGrid').cellHeight=-15
			paiGrid:GetComponent('UIGrid'):Reposition()
		end
	end
	for i = 1, #playerGridInHorizontal do
		local pai = playerGridInHorizontal[i]
		local pos = pai.transform.localPosition
		pos.y = 0
		pai.transform.localPosition = pos
	end
	playerGridInHorizontal1:GetComponent('UIGrid'):Reposition()
	playerGridInHorizontal2:GetComponent('UIGrid'):Reposition()
	if CountDown.gameObject.activeSelf then
		local selectCards,selectCardValues=this.getSelectCard()
		if #selectCards>0 then
			ButtonPlay.gameObject:GetComponent('UIButton').isEnabled = true;
		else 
			ButtonPlay.gameObject:GetComponent('UIButton').isEnabled = false;
		end
	end
end

function this.ClearnSelectCard()
	for i=0,playerGridIn[0].childCount-1 do
		local paiGrid=playerGridIn[0]:GetChild(i):Find('cardGrid')
		for j=0,paiGrid.childCount-1 do
			local pai = paiGrid:GetChild(j)
			if pai:Find('typeBig').gameObject.activeSelf == true then
				pai:Find('typeBig').gameObject:SetActive(false)
			end
		end
	end
end
--获得选择的牌的对象和值的集合 
function this.getSelectCard()
	local cards = {}
	local cardValues = {}
	if XHZDIsHorizontalCards then
		for i = 1, #playerGridInHorizontal do
			local pai = playerGridInHorizontal[i]
			if pai.transform.localPosition.y == 20 then
				table.insert(cards,pai.gameObject)
				table.insert(cardValues,GetUserData(pai.gameObject))
			end
		end
	else
		for i=0,playerGridIn[0].childCount-1 do
			local paiGrid=playerGridIn[0]:GetChild(i):Find('cardGrid')
			for j=0,paiGrid.childCount-1 do
				local pai = paiGrid:GetChild(j)
				if pai:Find('typeBig').gameObject.activeSelf == true then
					table.insert(cards,pai.gameObject)
					table.insert(cardValues,GetUserData(pai.gameObject))
				end
			end
		end
	end
	return cards,cardValues
end

function this.OnDissolveError()
	print('OnDissolveError')
	panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, "群主已设置最多申请解散5次，如有疑问请联系群主")
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.OnDissolveNotAllowed()
	print('OnDissolveNotAllowed')
	panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, "群主已设置房间不能解散，如有疑问请联系群主")
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.OnDissolveTimeTooShort()
	print('OnDissolveTimeTooShort')
	panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, "群主已设置申请解散的间隔不能小于5秒，如有疑问请联系群主")
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.OnTrustesship(msg)
    local body = xhzd_pb.RTrusteeship();
    body:ParseFromString(msg.body);

   print('-----------------------------------------有人托管了-------------------------------------------')
   print('托管的位置：'..tostring(body.seat));
   print('托管是否开启：'..tostring(body.enable));
   playerTrusteeship[this.GetUIIndexBySeat(body.seat)].gameObject:SetActive(body.enable)
    roomData.trusteeshipRemainMs = -1;--这里赋值为-1，然后再ShowWaitOpreatEffect就会启用配置的时间
	if body.seat == mySeat then
		TrusteeshipTip.gameObject:SetActive(false);
		TrusteeshipPanel.gameObject:SetActive(body.enable);
		isMySelfTrusteeship=true
	end
    this.GetPlayerDataBySeat(body.seat).trusteeship = body.enable;
end

function this.OnClickCancelTrustesship(go)
	local msg = Message.New()
	msg.type = xhzd_pb.TRUSTEESHIP
	local body = xhzd_pb.PTrusteeship()
	body.enable = false
	msg.body = body:SerializeToString();
	TrusteeshipTip.gameObject:SetActive(false);
	TrusteeshipPanel.gameObject:SetActive(false);
	isMySelfTrusteeship=false
	if roomData.state == xhzd_pb.GAMING then
		this.ClearnSelectCard()
		this.OnClickBG(onClickWidget.gameObject)
	end
	
	SendGameMessage(msg)
end

--设置托管
function this.SetDelegateCount(seat)
    print("SetDelegateCount was called--------------------->");
    this.StopTrustesship()
    trusteeshipcor = coroutine.start(
            function()
                local trusteeshipTime = -1;
                print("roomData.trusteeshipRemainMs:"..getIntPart(roomData.trusteeshipRemainMs / 1000)..' roomData.setting.trusteeship : '..roomData.setting.trusteeship);
                if getIntPart(roomData.trusteeshipRemainMs / 1000) >0 then
                    trusteeshipTime = getIntPart(roomData.trusteeshipRemainMs / 1000)
                    roomData.trusteeshipRemainMs = roomData.setting.trusteeship;
                else
                    trusteeshipTime = roomData.setting.trusteeship;
                end
                local pData = this.GetPlayerDataBySeat(seat);
                if pData.trusteeship then--如果处于托管中，那么时间置为0
                    trusteeshipTime = 0;
					if seat == mySeat then
						TrusteeshipPanel.gameObject:SetActive(true)
						TrusteeshipTip.gameObject:SetActive(false);
                    end
                end

                print("offlineState :"..tostring(offlineState)..'  trusteeshipTime : '..trusteeshipTime);
                print(tostring(trusteeshipTime >= 0))
                while trusteeshipTime >= 0 and (not offlineState) do
					print(trusteeshipTime)
                    coroutine.wait(1);
                    --print("trusteeshipTime------>"..trusteeshipTime.."seat:"..seat..",myseat:"..mySeat);

                    --进入托管
                    if trusteeshipTime <= 10 and not TrusteeshipPanel.gameObject.activeSelf then
                        if seat == mySeat then
                            TrusteeshipTip.gameObject:SetActive(true);
                            TrusteeshipTip:Find("Time"):GetComponent("UILabel").text = trusteeshipTime;
                        end

                        if trusteeshipTime <= 0 then
							TrusteeshipTip.gameObject:SetActive(false);
                        end
                    else
                        TrusteeshipTip.gameObject:SetActive(false);
                    end
                    trusteeshipTime = trusteeshipTime -1
                end
            end
    );
end

function this.StopTrustesship()
    print("------------------------停止托管计时------------------------------")
    coroutine.stop(trusteeshipcor);
    trusteeshipcor = nil;
    TrusteeshipTip.gameObject:SetActive(false);
end

function this.StartOfflineIncrease(seat, startTime)
	this.StopOfflineIncrease(seat)
	print('------------------有人离线，开始离线计时'..(seat)..'----------------------')

	local offlineTime = playerOfflineTime[this.GetUIIndexBySeat(seat)];
	playerOfflineCoroutines[this.GetUIIndexBySeat(seat)] = coroutine.start(this.OfflineIncrease, offlineTime, startTime)
end

function this.OfflineIncrease(timeObj, startTime)
	print('OfflineIncrease .......................')
	local timeLabel = timeObj.transform:Find('Time'):GetComponent('UILabel');
	timeLabel.text = os.date("%M:%S", startTime);
	timeObj.gameObject:SetActive(true)

	while true do
		coroutine.wait(1);
		--print(' startTime : '..startTime)
		startTime = startTime + 1 
		timeLabel.text = os.date("%M:%S", startTime);
	end
end

function this.StopOfflineIncrease(seat)
	local coroutines = playerOfflineCoroutines[this.GetUIIndexBySeat(seat)]

	if coroutines ~= nil then
		coroutine.stop(coroutines)
		coroutines = nil;
		print('------------------取消离线倒计时'..(seat)..'----------------------')
	end

	playerOfflineTime[this.GetUIIndexBySeat(seat)].gameObject:SetActive(false)
end
function this.StopAllOfflineIncrease()
	for i = 0, #playerOfflineCoroutines do
		print('-------------Mark----------', i)
		local coroutines =  playerOfflineCoroutines[i]
		if coroutines ~= nil then
			coroutine.stop(coroutines)
			coroutines = nil;
		end
	end
end
