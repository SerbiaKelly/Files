local dtz_pb = require 'dtz_pb'
local phz_pb = require 'phz_pb'
require "Game.Tools.UITools"
require "Game.GameLogic.dtz_Logic"

panelInGame_dtz = {}
local this = panelInGame_dtz
local gameObject
local message

local playerSize 	= 4;
local distances 	= {};--相隔距离游戏对象
local gpsPlayers 	= {};

local roomID
local roomTime
local roomRound
local ShowCardTip
local playerName	={}
local playerIcon	={}
local playerScore	={}
local playerGroups 	={}
local playerSound	={}
local playerOffline	={}
local playerGridIn	={}
local playerGridInCenter 	= {};
local playerGridOut			= {}
local OutCardZhaDan			= {}
local OutCardZhaDanWenZi	= {}
local OutCardZhaDanWenZiBG	= {}
local playerReady			= {}
local OutCardFinish			= {}
local playerzi				= {}
local playerwenzi			= {}
local playerKuang			= {}
local playerSound			= {}
local playerWarnning 		= {};
local playerRoomers 		= {};
local roomSetting
local onClickWidget
local InCardItemPrefab;
local changeSeatButtons 	= {};
local startGameButton; --房主开始游戏
local playerAnimation		= {}

local TrusteeshipTip
local TrusteeshipPanel
local CancelTrusteeshipBtn
local TrusteeshipCoroutine

local playerTrusteeship={}
local playerOfflineTime={}
local playerOfflineCoroutines={}

local playerData={}
local mySeat;

local ButtonMore
local ButtonRefresh
local buttonrefresh
local ButtonChat
local ButtonSound
local ButtonSort
local ButtonInvite
local ButtonCloseRoom
local ButtonExitRoom
local ButtonHelp
local ButtonPlay
local ButtonPass
local playerBonusScores = {};
local currentDeskScore = nil;
local changeSeatTip;
local noBigCard;

local lastFindCards={}
local helpNumWhenHaveOneCard = 0

local setting_text

local playerMsg			= {}
local playerMsgBG		= {}
local playerEmoji		= {}
local playerRestCards	= {};--玩家剩余牌
local playerCoroutine 	= {}
local readybtn
local RecordTiShi--录音提示
playerCoroutine[0] = {}
playerCoroutine[1] = {}
playerCoroutine[2] = {}
local roomData;
local curPai
local mySelectCards={}
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
local batteryLevel
local network
local pingLabel
local GvoiceCor
local refreshStateCoroutine
local panelShare
local scoreView={} --积分界面
local winSeat
local helpOutCardsIndex =1

local playerEmojiCoroutine = {}
playerEmojiCoroutine[0] = {}
playerEmojiCoroutine[1] = {}
playerEmojiCoroutine[2] = {}
playerEmojiCoroutine[3] = {}

local GPS;
local selectOutCardType
local selectOutCardTypeBG


local inCardColumLimit = 24;
local outCardColumLimit = 26;
local cutlimit = 15;

local currentPlayState 			= nil;
local currentChooseCardsData 	= nil;--当前选择的牌
local overCenterCardCount 		= 24;--如果手牌低于这个数值，说明只有一行，要居中显示
local NeedCombination 			= false;--是否需要合并
local clickMoveDistance 		= 30;--点击牌后垂直移动的距离
local dtzPlateType 				= 1;--打筒子牌面类型

this.myseflDissolveTimes = 0
local layout
function this.Awake(obj)
	gameObject 			= obj;
    this.gameObject 	= obj
	message 			= gameObject:GetComponent('LuaBehaviour');
	RestTime 			= gameObject.transform:Find("RestTime")
	roomID 				= gameObject.transform:Find('topbg/room/ID');
	roomTime 			= gameObject.transform:Find('time');
	roomRound 			= gameObject.transform:Find('topbg/round/num');
	ShowCardTip 		= gameObject.transform:Find('ShowCardTip');
	roomSetting 		= gameObject.transform:Find('setting');
	onClickWidget 		= gameObject.transform:Find('OnClick');
	GPS 				= gameObject.transform:Find('GPS');
	startGameButton 	= gameObject.transform:Find("startGameButton");
	noBigCard 			= gameObject.transform:Find("noBigCard");
	for i=0,3 do
		playerName[i] 				= gameObject.transform:Find('player'..i..'/info/name');
		playerIcon[i] 				= gameObject.transform:Find('player'..i..'/info/Texture');
		playerScore[i] 				= gameObject.transform:Find('player'..i..'/info/score');
		playerGroups[i] 			= gameObject.transform:Find('player'..i..'/info/group');
		playerSound[i] 				= gameObject.transform:Find('player'..i..'/info/sound');
		playerOffline[i] 			= gameObject.transform:Find('player'..i..'/info/offline');
		playerRoomers[i]			= gameObject.transform:Find('player'..i..'/info/roomer');
		playerGridIn[i] 			= gameObject.transform:Find('player'..i..'/GridIn');
		playerGridInCenter[i] 		= gameObject.transform:Find('player'..i..'/GridInCenter');
		playerGridOut[i] 			= gameObject.transform:Find('player'..i..'/Grid/GridOut');
		OutCardZhaDan[i] 			= gameObject.transform:Find('player'..i..'/Grid/zhadan');
		OutCardZhaDanWenZiBG[i] 	= gameObject.transform:Find('player'..i..'/Grid/zhadan/sp');
		OutCardZhaDanWenZi[i] 		= gameObject.transform:Find('player'..i..'/Grid/zhadan/lb');
		playerReady[i] 				= gameObject.transform:Find('player'..i..'/info/ready');
		OutCardFinish[i] 			= gameObject.transform:Find('player'..i..'/info/OutCardFinish');
		playerMsg[i] 				= gameObject.transform:Find('player'..i..'/info/Msg');
		playerMsgBG[i] 				= gameObject.transform:Find('player'..i..'/info/Msg/MsgBG');
		playerEmoji[i] 				= gameObject.transform:Find('player'..i..'/info/Emoji');
		playerzi[i] 				= gameObject.transform:Find('player'..i..'/texiaozi/pass')
		playerwenzi[i] 				= gameObject.transform:Find('player'..i..'/texiaozi/tishi')
		playerKuang[i] 				= gameObject.transform:Find('player'..i..'/info/kuang01');
		playerTrusteeship[i] 		= gameObject.transform:Find('player'..i..'/info/trusteeship')
		playerOfflineTime[i] 		= gameObject.transform:Find('player'..i..'/info/offlineTime')
		playerAnimation[i] 			= gameObject.transform:Find('teshubiaoqing/'..i);
		if i > 0 then
			changeSeatButtons[i]   	= gameObject.transform:Find('player'..i..'/buttonChangeSeat');
			message:AddClick(changeSeatButtons[i].gameObject,this.OnClickButtonChangeSeat);
			playerRestCards[i]		= gameObject.transform:Find('player'..i..'/restCards');
			playerWarnning[i]		= gameObject.transform:Find('player'..i..'/info/warnning');
		end
		message:AddClick(playerIcon[i].gameObject, this.OnClickPlayerIcon);
	end

	
	this.Awake1()
end

function this.Awake1()
	batteryLevel 		= gameObject.transform:Find('battery/level'):GetComponent('UISprite');
	network 			= gameObject.transform:Find('network'):GetComponent('UISprite');
	pingLabel 			= gameObject.transform:Find('ping'):GetComponent('UILabel');

	RecordTiShi 		= gameObject.transform:Find('RecordTiShi');
	ButtonChat 			= gameObject.transform:Find('ButtonChat');
	ButtonSound 		= gameObject.transform:Find('ButtonSound');

	ButtonSort 			= gameObject.transform:Find('ButtonSort');
	ButtonInvite 		= gameObject.transform:Find('bottomButtons/ButtonInvite');
	ButtonHelp 			= gameObject.transform:Find('ShowCardTip/ButtonHelp');
	ButtonPlay 			= gameObject.transform:Find('ShowCardTip/ButtonPlay');
	ButtonPass 			= gameObject.transform:Find('ShowCardTip/ButtonPass');
	ButtonCloseRoom 	= gameObject.transform:Find('bottomButtons/ButtonCloseRoom')
	ButtonExitRoom 		= gameObject.transform:Find('bottomButtons/ButtonExitRoom')
	changeSeatTip 		= gameObject.transform:Find('changeSeatTip');
	readybtn 			= gameObject.transform:Find("readybtn")
	bg 					= gameObject.transform:Find("bg")
	bg1 				= gameObject.transform:Find("bg1")
	bg2 				= gameObject.transform:Find("bg2")
	bg3 				= gameObject.transform:Find("bg3")
	bg4 				= gameObject.transform:Find("bg4")
	InCardItemPrefab  	= gameObject.transform:Find("player0/InCardItem");

	TrusteeshipTip = gameObject.transform:Find('TrusteeshipTip')
	TrusteeshipPanel = gameObject.transform:Find('TrusteeshipPanel')
	CancelTrusteeshipBtn = TrusteeshipPanel.transform:Find('CancelTrusteeshipBtn')

	message:AddClick(CancelTrusteeshipBtn.gameObject, this.OnClickCancelTrustesship)

	--刷新按钮   更多按钮
	ButtonRefresh = gameObject.transform:Find('topbg/btn/ButtonRefresh');
	ButtonMore = gameObject.transform:Find('topbg/btn/ButtonMore');
	message:AddClick(ButtonMore.gameObject, this.OnClickButtonSetting)

	--积分界面
	scoreView 					= gameObject.transform:Find('scoreView');
	selectOutCardType 			= gameObject.transform:Find('selectOutCardType');
	selectOutCardTypeBG 		= gameObject.transform:Find('selectOutCardType/bg');
	panelShare 					= gameObject.transform:Find('panelShare');

	this.changeBG(UnityEngine.PlayerPrefs.GetInt('ground_dtz', 2))
	message:AddClick(ButtonRefresh.gameObject, 		this.OnClickButtonRefresh)
	message:AddClick(ButtonChat.gameObject, 		this.OnClickButtonChat);
	message:AddPress(ButtonSound.gameObject, 		this.OnPressButtonSound);
	message:AddClick(ButtonSort.gameObject, 		this.OnClickButtonSort);
	message:AddClick(ButtonInvite.gameObject, 		this.ShowPanelShare)
	message:AddClick(ButtonCloseRoom.gameObject, 	this.OnClickButtonCloseRoom)
	message:AddClick(ButtonExitRoom.gameObject, 	this.OnClickButtonLeaveRoom)
	message:AddClick(ButtonHelp.gameObject, 		this.OnClickButtonHelp);
	message:AddClick(ButtonPlay.gameObject, 		this.OnClickButtonPlay);
	message:AddClick(ButtonPass.gameObject, 		this.OnClickOnButtonPass);
	message:AddClick(onClickWidget.gameObject, 		this.OnClickBG);
	message:AddClick(readybtn.gameObject, 			this.OnClickReady);

	message:AddClick(panelShare:Find('xianLiao').gameObject, 		this.OnClickButtonXLInvite);
	message:AddClick(panelShare:Find('friendGroup').gameObject, 	this.OnClickButtonInvite);
	message:AddClick(panelShare:Find('copy').gameObject, 			this.OnClicButtonCopy);
	message:AddClick(panelShare:Find('ButtonClose').gameObject, 	this.ClosePanelShare);
	message:AddClick(panelShare:Find('mask').gameObject, 			this.ClosePanelShare);
	message:AddClick(startGameButton.gameObject,						this.OnClickStartGameButton);
	RegisterGameCallBack(dtz_pb.PONG, this.OnPong)
	message:AddPress(network.gameObject, function (go, state)
		pingLabel.gameObject:SetActive(state)
	end)
	for i = 0, 3 do
		playerBonusScores[i] = scoreView:Find("allScore/playerGrid/playItem"..i);
	end
	currentDeskScore = scoreView:Find("current5_10_KScore");
	--生成出牌
	for i = 0, 3 do
		playerGridOut[i].gameObject:SetActive(true)
		for j = 0, 51 do
			local obj =  NGUITools.AddChild(playerGridOut[i].gameObject, gameObject.transform:Find('outCardItem').gameObject)
			obj.name = j
			obj.transform.localScale = Vector3(0.58,0.58,0.58)
			obj.gameObject:SetActive(false)
		end
	end
	for i = 0, 3 do
		playerGridOut[i]:GetComponent('UIGrid'):Reposition()
	end
	--宽屏手机自适应
	layout=gameObject.transform:Find('layout')
	if isShapedScreen  then
		local fixOffsetScale=0.015
		local offsetX=40
		local offsetScale=FitScale*FitOffset/UnityEngine.Screen.width/2-0.02
		local widget = layout:Find('left'):GetComponent('UIWidget')
		widget.rightAnchor.absolute = offsetX

		widget = layout:Find('right'):GetComponent('UIWidget')
		widget.leftAnchor.absolute = -offsetX

		ShowCardTip.localPosition = Vector3(15, 5, 0)
		
		local paiOffsetY=(FitScale-offsetScale-1)*160/2
		playerGridInCenter[0].localScale=Vector3(FitScale-offsetScale-fixOffsetScale,FitScale-offsetScale-fixOffsetScale,1)
		playerGridInCenter[0].localPosition=Vector3(652+(offsetX+48*11)*(FitScale-1),42+paiOffsetY,1)
		playerGridIn[0].localScale=Vector3(FitScale-offsetScale-fixOffsetScale,FitScale-offsetScale-fixOffsetScale,1)
		playerGridIn[0].localPosition=Vector3(105,42+paiOffsetY,1)
		playerGridOut[0].parent.localPosition=Vector3(708,300,0)
		playerzi[0].parent.localPosition=Vector3(753,295,0)	
		--playerGridOut[1].localPosition=Vector3(-1374,37,0)
		-- local widget = playerGridIn[0]:GetComponent('UIWidget')
		-- widget.bottomAnchor.absolute = 179
		-- widget.leftAnchor.absolute = 60
	end
end

function this.Start()

	coroutine.start(RefreshTime, roomTime:GetComponent('UILabel'), 60)
	if refreshStateCoroutine then
		coroutine.stop(refreshStateCoroutine)
	end
	refreshStateCoroutine = coroutine.start(this.RefreshState)
end

function this.HideUIWhileStart()
	readybtn.gameObject:SetActive(false);
end

function this.WhoShow(data)
	gameObject:SetActive(false)
	this.SetMyAlpha(1)
	this.OnRoundStarted = nil
	PanelManager.Instance:HideAllWindow()
	gameObject:SetActive(true)
end

function this.OnEnable()

    PanelManager.Instance:HideWindow('panelLobby');
    PanelManager.Instance:HideWindow('panelClub');
	panelInGame = panelInGame_dtz;
    panelInGame.needXiPai=false

	dtzPlateType = UnityEngine.PlayerPrefs.GetInt("dtzpaiSize", 1);

	isIngame = true
	if panelClub then
		panelClub.isInClub=false
	end
	this.GetGPSUI();
	this.RegisterGameCallBack()
	connect 				= NetWorkManager.Instance:CreateConnect('game');
    connect.IP 				= GetServerIPorTag(false, roomInfo.host)
    connect.Port 			= roomInfo.port
	connect.GroupName 		= ConfigManager.getProperty('ProxyServer', 'GroupName', '');
    connect.onConnectLua 	= this.OnConnect
    connect.disConnectLua 	= this.OnDisconnect
    connect.rspCallBackLua 	= receiveGameMessage;
	connect.reConnectNum 	= ConfigManager.getIntProperty('Setting', 'ReconnectNum', 5)
    connect:Connect();
	
	local msg 	= Message.New()
	msg.type 	= proxy_pb.PING
	connect.heartBeatMsg = msg
	connect.heartBeatInterval = 5;
	
	this.StartCheckNetState()
	
	AudioManager.Instance:PlayMusic('ZD_Bgm', true)
	--this.ClearRoom()
	if panelChat then
        panelChat.ClearChat()
	end
	for i = 0, 3 do
		playerTrusteeship[i].gameObject:SetActive(false)
	end
	this.ResetView()
	this.HideUIWhileStart();
end

function this.ResetView()
	this.StopCheckTrusteeship()
	TrusteeshipPanel.gameObject:SetActive(false)
end



function this.JionRoom()
	--print("JionRoom was called ------------------>");
	local msg 		= Message.New();
	msg.type 		= dtz_pb.JOIN_ROOM;
	local body 		= dtz_pb.PJoinRoom();
	body.roomNumber = roomInfo.roomNumber;
	body.token 		= roomInfo.token;
	body.longitude 	= tonumber(UnityEngine.PlayerPrefs.GetFloat("longitude",0));
	body.latitude 	= tonumber(UnityEngine.PlayerPrefs.GetFloat("latitude",0));
	body.address 	= UnityEngine.PlayerPrefs.GetString("address","");
	msg.body 		= body:SerializeToString();
	SendGameMessage(msg, this.OnJoinRoomResult)
end


function this.OnApplicationFocus()

end


function this.RegisterGameCallBack()
	ClearGameCallBack();
	RegisterGameCallBack(dtz_pb.PLAYER_ENTER, 					this.OnPlayerEnter)
	RegisterGameCallBack(dtz_pb.PLAYER_JOIN, 					this.OnPlayerJion)
	RegisterGameCallBack(dtz_pb.LEAVE_ROOM, 					this.OnLeaveRoom)
	RegisterGameCallBack(dtz_pb.PLAYER_LEAVE, 					this.OnPlayerLeave)
	RegisterGameCallBack(dtz_pb.ROUND_START, 					this.OnRoundStart)
	RegisterGameCallBack(dtz_pb.LORD_DISSOLVE, 					this.OnLordDissolve)
	RegisterGameCallBack(dtz_pb.ROUND_END, 						this.OnRoundEnd)
	RegisterGameCallBack(dtz_pb.READY, 							this.OnReady)
	RegisterGameCallBack(dtz_pb.PLAY, 							this.OnPlayerPlay)
	RegisterGameCallBack(dtz_pb.PASS, 							this.OnPlayerPass)
	RegisterGameCallBack(dtz_pb.DESTROY, 						this.Destroy)
	RegisterGameCallBack(dtz_pb.DISSOLVE, 						this.OnDissolve)
	RegisterGameCallBack(dtz_pb.SEND_CHAT, 						this.OnSendChat)
	RegisterGameCallBack(dtz_pb.DISCONNECTED, 					this.OnDisconnected)
	RegisterGameCallBack(dtz_pb.VOICE_MEMBER, 					this.OnVoiceMember)
	RegisterGameCallBack(dtz_pb.NO_ROOM, 						this.OnRoomNoExist)
	RegisterGameCallBack(dtz_pb.ENTER_ERROR, 					this.OnRoomError)
	RegisterGameCallBack(dtz_pb.GAME_OVER, 						this.OnGameOver)
	RegisterGameCallBack(dtz_pb.PLAY_ERROR, 					this.OnPlayError)
	RegisterGameCallBack(dtz_pb.FLUSH_BONUS_ANI, 				this.OnGetBonusScore);
	RegisterGameCallBack(dtz_pb.START_GAME_ERROR, 				this.OnStartGameError);
	RegisterGameCallBack(dtz_pb.START_GAME_WIAT, 				this.OnStartGameWait);
	RegisterGameCallBack(dtz_pb.CHANGE_SEAT, 					this.OnChangeSeat);
	RegisterGameCallBack(dtz_pb.CHANGE_SUCCESS, 				this.OnChangeSeatSuccess);
	RegisterGameCallBack(dtz_pb.CHANGE_SEAT_ERROR, 				this.OnChangeSeatError);
	RegisterGameCallBack(dtz_pb.CHANGE_SEAT_NOESISTS, 			this.OnChangeSeatUnExist);
	RegisterGameCallBack(dtz_pb.CHANGE_SEAT_INVALID_ERROR, 		this.OnChangeSeatInValid);
	RegisterGameCallBack(dtz_pb.DISSOLVE_UNABLE_ERROR, 			this.OnRoomCannotDissolve);
	RegisterGameCallBack(dtz_pb.DISSOLVE_LIMIT_TIMES_ERROR, 	this.OnRoomDissolveLimit5);
	RegisterGameCallBack(dtz_pb.DISSOLVE_LIMIT_SECONDS_ERROR, 	this.OnRoomDissolveIn5Seconds);
	RegisterGameCallBack(dtz_pb.GIFT, 							this.OnPlayerEmoji)
	RegisterGameCallBack(dtz_pb.AUTO_DISSOLVE, 					this.OnAutoDissolve)
	RegisterGameCallBack(dtz_pb.TRUSTEESHIP, 					this.OnTrustesship)
	RegisterGameCallBack(dtz_pb.OVERTIME_DISSOLVE, 				this.OnOverTimeDissolve)
end



--填充座位上的玩家数据
function this.RefreshPlayer()

	function SetPlayerState(index,p)
		playerName[index].gameObject:SetActive(true)
		playerName[index]:GetComponent('UILabel').text = p.name;
		coroutine.start(LoadPlayerIcon, playerIcon[index]:GetComponent('UITexture'), p.icon);
		SetUserData(playerIcon[index].gameObject, p);
		playerIcon[index].gameObject:SetActive(true);
		playerScore[index].gameObject:SetActive(true);
		playerScore[index]:GetComponent('UILabel').text = p.score;
		--print("roomData.state:"..roomData.state);
		playerReady[index].gameObject:SetActive(p.ready and roomData.state ~= dtz_pb.GAMING);
		playerRoomers[index].gameObject:SetActive(p.id == roomData.ownerId);
		if index > 0 then
			if roomData.state == dtz_pb.READYING and playerSize == 4 and roomData.round == 1 then
				changeSeatButtons[index].gameObject:SetActive(true);
			else
				changeSeatButtons[index].gameObject:SetActive(false);
			end
			--是否显示剩牌
			playerRestCards[index].gameObject:SetActive(roomData.setting.show and roomData.state == dtz_pb.GAMING and p.len > 0);
			--print("playerRestCards in RefreshPlayer :"..tostring(roomData.setting.show and roomData.state == dtz_pb.GAMING));
		end
		if p.seat == 0 or p.seat == 2 then--A组
			playerGroups[index]:GetComponent("UISprite").spriteName = "扑克通用-A组标记";
		else
			playerGroups[index]:GetComponent("UISprite").spriteName = "扑克通用-B组标记";
		end
		playerGroups[index].gameObject:SetActive(playerSize == 4);
		playerScore[index]:GetComponent('UILabel').text = p.roundGrab;
		playerTrusteeship[index].gameObject:SetActive(p.trusteeship)
		playerOfflineTime[index].gameObject:SetActive(false)
		if p.disconnectTimes ~= nil and p.disconnectTimes ~= 0 then
			this.StartOfflineIncrease(p.seat, p.disconnectTimes)
		end
		if p.connected then
			playerOffline[index].gameObject:SetActive(false);
		else
			playerOffline[index].gameObject:SetActive(true);
		end

		this.SetMyseflInTrustesship(p.seat, p.trusteeship)
	end

	function hidePlayerState(index,p)
		playerName[index]:GetComponent('UILabel').text = '';
		playerIcon[index].gameObject:SetActive(true);
		playerIcon[index]:GetComponent('UITexture').mainTexture = nil;
		playerScore[index]:GetComponent('UILabel').text = '0';
		playerGridIn[index].gameObject:SetActive(false);
		playerGridInCenter[index].gameObject:SetActive(false);
		playerGridOut[index].gameObject:SetActive(false);
		OutCardZhaDan[index].gameObject:SetActive(false);
		playerReady[index].gameObject:SetActive(false);
		playerOffline[index].gameObject:SetActive(false);
		playerRoomers[index].gameObject:SetActive(false);
		playerTrusteeship[index].gameObject:SetActive(false)
		playerOfflineTime[index].gameObject:SetActive(false)
		if index > 0 then
			changeSeatButtons[index].gameObject:SetActive(false);
			playerRestCards[index].gameObject:SetActive(false);
		end
		SetUserData(playerIcon[index].gameObject, nil);
	end

	function hideSoundState(index)
		playerSound[index].gameObject:SetActive(false)
	end

	for i=0,playerSize-1 do
		local p = this.GetPlayerDataByUIIndex(i)
		if p then
			SetPlayerState(this.GetUIIndex(i,playerSize),p);
			--设置离线状态
			playerOffline[this.GetUIIndex(i,playerSize)].gameObject:SetActive(not p.connected);
		else
			hidePlayerState(this.GetUIIndex(i,playerSize),p);
		end
		hideSoundState(this.GetUIIndex(i,playerSize));
	end

	if playerSize == 4 then
		this.RefreshGroupData();
	end
end


function this.OnJoinRoomResult(msg)
    panelInGame.needXiPai=false
	panelLogin.HideNetWaitting()
	this.fanHuiRoomNumber 	= roomInfo.roomNumber
	local body 				= dtz_pb.RJoinRoom()
	body:ParseFromString(msg.body)
	roomData 				= body.room;
	mySeat 					= body.seat;
	playerSize 				= roomData.setting.size;
	playerData				= {};
	currentPlayState 		= roomData.playState;
	print('body.room.setting.sendMsgAllowed : '..tostring(body.room.setting.sendMsgAllowed))
	print('body.room.setting.sendVoiceAllowed : '..tostring(body.room.setting.sendVoiceAllowed))
	--print('-----------------', roomData.trusteeshipRemainMs)

	print("我的座位号是",mySeat);
	print("房间人数为",#body.room.players);
	for i=1,#body.room.players do
		local p = body.room.players[i];
		
		--print('----------------------', p.disconnectTimes)
		table.insert(playerData,p);
	end
	print("玩家数据数组的长度为",#playerData)

	this.OnPlayerHand(nil,nil)
	DestroyRoomData.roomData 	= roomData
	DestroyRoomData.playerData 	= playerData
	DestroyRoomData.mySeat 		= mySeat
	this.SetRoomInfo(roomData);

	this.SetReadyVisiable();
	this.RefreshPlayer();
	this.SetPlayerState(roomData.state);
	this.GPSRefresh();
	--this.UpdateScoreView(roomData.scores);
	this.InitBonusScore();
	this.RefreshBonusScore(roomData.bonusBoard);
	this.InitDeskScore(roomData);
	this.InitOutGridDepths();
	this.RefreshChangeSeatState();
	this.InitChangeSeatData(roomData.changeArray);
	if roomData.setting.show then
		this.InitCardCounts();
	end
	if roomData.setting.size == 4 then
		this.RefreshGroupData();
	end

	this.ResetHelpData();


	lastFindCards 			= {}
	selectCards 			= {}
	helpNumWhenHaveOneCard 	= 0
	RoundAllData.over 		= false
	this.myseflDissolveTimes = 0
	this.VoiceCoroutineInit();
	--this.GPSTip(roomData);
	--刷新出牌信息
	if roomData.state == dtz_pb.GAMING then
		GPS.gameObject:SetActive(false);
		if roomData.latestHand ~= nil and #roomData.latestHand.cards > 0 then
			if roomData.latestSeat ~= roomData.activeSeat then
				this.OnPlayerHand(roomData.latestSeat, roomData.latestHand)
			end
		end
		this.SetInviteVisiable(false)
		this.SetCountDownVisiable(roomData.trusteeshipRemainMs);
		this.RefreshShangYouData(body.room.players);
		this.RefreshMyGridIn();
	else
		if roomData.round > 1 then
			this.SetInviteVisiable(false)
		else
			this.SetInviteVisiable(#playerData ~= (roomData.setting.size ) or (not this.GetPlayerDataBySeat(mySeat).ready) or not this.IsAllReaded())
		end

		this.RefreshStartGameState(roomData.enabledChange);
		GPS.gameObject:SetActive(roomData.round == 1);

	end
end

function this.VoiceCoroutineInit()
	if GvoiceCor then
		StopCoroutine(GvoiceCor)
	end
	GvoiceCor = StartCoroutine(this.TickNGCloudVoice)
	NGCloudVoice.Instance:ApplyMessageKey()
end
function this.GPSTip(roomData)
	if roomData.round == 1  then
		local longitude = UnityEngine.PlayerPrefs.GetFloat("longitude",0)
		local latitude 	= UnityEngine.PlayerPrefs.GetFloat("latitude",0)
		local address 	= UnityEngine.PlayerPrefs.GetString("address","")
		if (longitude == 0 and latitude == 0) and address=="" then
			panelMessageBox.SetParamers(ONLY_OK,nil,nil,"未允许游戏获取定位");
			PanelManager.Instance:ShowWindow("panelMessageBox");
		end
	end
end

--设置房间信息
function this.SetRoomInfo(roomData)
	--房间号
	roomID:GetComponent('UILabel').text = roomInfo.roomNumber
	--解散信息
	if roomData.dissolution.remainMs > 0 then
		roomData.dissolution.remainMs = getIntPart(roomData.dissolution.remainMs/1000)
		this.SetDestoryPanelShow()
	end

	--房间多久后会被解散
	if roomData.state == 1 and roomData.clubId ~= "0" and roomData.round == 1  then
		restTime = roomData.time/1000 -- 600 - os.time() + body.room.time
		--print('时间：'..roomData.time)
		RestTime:Find("Time"):GetComponent('UILabel').text = os.date("%M:%S", restTime)
		RestTime.gameObject:SetActive(true)
		if RefeshTimeCoroutine == nil then
			RefeshTimeCoroutine = coroutine.start(this.RefreshTime, RestTime:Find("Time"):GetComponent('UILabel'))
		end
	else
		RestTime.gameObject:SetActive(false)
	end

	--房间的玩法信息
	local setting_gound = GetDTZRuleString(roomData.setting,false);
	this.SetRoundNum(roomData.round);
	roomSetting:GetComponent('UILabel').text 				= setting_gound;
	roomSetting:GetChild(0):GetComponent('UILabel').text 	= setting_gound;

	gameObject.transform:Find('dsz'):GetComponent('UILabel').text 				= roomData.playName
	gameObject.transform:Find('dsz'):GetChild(0):GetComponent('UILabel').text 	= roomData.playName
	ButtonExitRoom.parent:GetComponent("UIGrid"):Reposition();
end

function this.RefreshShangYouData(players)
	for i = 1, #players do
		local data = players[i];
		local index = this.GetUIIndex(this.GetUIIndexBySeat(data.seat),playerSize);

		local name ;
		OutCardFinish[index].gameObject:SetActive(data.roundOrder ~= -1);
		if data.roundOrder == 0 then
			name = '上游'
		elseif data.roundOrder == 1 then
			name = '二游'
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
			if roomData.activeSeat ~= data.seat then
				local b = math.random(1, 3);
				this.ShowVFX(index,true);
			end
		end
	end
end




local startpos = nil
local endPos = nil;
local hoverGridHeight = 90;
local hoverCardHeight = 157;
local hoverCardWidth = 115;

function this.Update()
	if roomData and roomData.state == dtz_pb.GAMING then
		if UnityEngine.Input.GetMouseButtonDown(0) then
			startpos = this.MousePosition();
			endPos = startpos;
		end

		if UnityEngine.Input.GetMouseButton(0) then
			local endPosData = this.GetCutX(this.MousePosition(),hoverCardWidth,hoverCardHeight);
			if  endPosData.find then
				--print("find---------->");
				--print("startpos:"..tostring(startpos));
				--print("endPos:"..tostring(endPos));
				endPos = endPosData.endPos;
			end
			if math.abs(startpos.x-this.MousePosition().x) > 10 then
				this.selectEffect()
			end
		end

		if  UnityEngine.Input.GetMouseButtonUp(0) then
			this.selectEffect(true)
			local minX = startpos.x < endPos.x and startpos.x or endPos.x;
			local maxX = startpos.x > endPos.x and startpos.x or endPos.x;
			local minY = startpos.y;
			local maxY = minY;
			if math.abs(maxX - minX) > 10 then
				--print("big than 10");
				this.CheckCard(minX,maxX,minY,maxY,hoverCardWidth, hoverCardHeight);
			end
		end
	end


end

function this.selectEffect(reset)
	local minX = startpos.x < endPos.x and startpos.x or endPos.x;
	local maxX = startpos.x > endPos.x and startpos.x or endPos.x;
	local minY = startpos.y;
	local maxY = minY;

	local iminX;
	local imaxX;
	local iminY;
	local imaxY;

	local item 		
	local itemPosition
	local sp
	local tongzi
	local tongzikuang
	local xiOrDiZha
	local xiOrDiZhakuang
	local gray=Color(166/255,170/255,175/255)

	local grid = this.IsGridInNeedCenter() and playerGridInCenter[0] or playerGridIn[0];
	if reset then
		for i = 0, grid.childCount-1 do
			item 			= grid:GetChild(i);
			itemPosition 	= item.localPosition;
			sp = item:Find('bg'):GetComponent('UISprite')
			tongzi = item:Find('tongzi'):GetComponent('UISprite')
			tongzikuang = item:Find('tongzi/Sprite'):GetComponent('UISprite')
			xiOrDiZha = item:Find('xiordiZha'):GetComponent('UISprite')
			xiOrDiZhakuang = item:Find('xiordiZha/Sprite'):GetComponent('UISprite')
			sp.color=Color.white
			tongzi.color=Color.white
			tongzikuang.color=Color.white
			xiOrDiZha.color=Color.white
			xiOrDiZhakuang.color=Color.white
		end
		return
	end

	local colNum 		= grid:GetComponent("UIGrid").maxPerLine;

	local gridWidth 	= math.abs(grid:GetComponent("UIGrid").cellWidth);
	local gridHeight 	= math.abs(grid:GetComponent("UIGrid").cellHeight);

	local itemWidth 	= hoverCardWidth;
	local itemHeight 	= hoverCardHeight;
	
	for i = 0, grid.childCount-1 do
		item 			= grid:GetChild(i);
		itemPosition 	= item.localPosition;
		sp = item:Find('bg'):GetComponent('UISprite')
		tongzi = item:Find('tongzi'):GetComponent('UISprite')
		tongzikuang = item:Find('tongzi/Sprite'):GetComponent('UISprite')
		xiOrDiZha = item:Find('xiordiZha'):GetComponent('UISprite')
		xiOrDiZhakuang = item:Find('xiordiZha/Sprite'):GetComponent('UISprite')

		iminX = itemPosition.x - itemWidth/2;
		imaxX = (((i + 1)==24 or (i + 1)==grid.childCount) and iminX + itemWidth or iminX + gridWidth) ;
		imaxY = itemPosition.y + itemHeight/2;

		--y值需要特殊处理
		--第一排
		if i < colNum then
			iminY = itemPosition.y - itemHeight /2;
		else
			local preItem = grid:GetChild(i-colNum);
			--如果它前面的值被选中了
			if this.CardBeenSelected(preItem.gameObject) then
				iminY = itemPosition.y + itemHeight /2 - gridHeight  + clickMoveDistance;
			else
				iminY = itemPosition.y + itemHeight /2 - gridHeight
			end
		end

		if item.gameObject.activeInHierarchy and imaxX > minX and iminX < maxX 
		and maxY < imaxY   and minY > iminY 
		--如果是开始选中的是第二行还是第一行
		and startpos.y < imaxY and startpos.y > iminY then
			sp.color=gray
			tongzi.color=gray
			tongzikuang.color=gray
			xiOrDiZha.color=gray
			xiOrDiZhakuang.color=gray
		else
			sp.color=Color.white
			tongzi.color=Color.white
			tongzikuang.color=Color.white
			xiOrDiZha.color=Color.white
			xiOrDiZhakuang.color=Color.white
		end
	end
end

function this.GetCutX(endPos,cardWidth,cardHeigth)
	local grid 			= this.IsGridInNeedCenter() and playerGridInCenter[0] or playerGridIn[0];
	local colNum 		= grid:GetComponent("UIGrid").maxPerLine;

	local gridWidth 	= math.abs(grid:GetComponent("UIGrid").cellWidth);
	local gridHeight 	= math.abs(grid:GetComponent("UIGrid").cellHeight);

	local itemWidth 	= cardWidth;
	local itemHeight 	= cardHeigth;
	for i = 0, grid.childCount-1 do
		local item 			= grid:GetChild(i);
		local itemPosition 	= item.localPosition;
		local iminX;
		local imaxX;
		local iminY;
		local imaxY;

		iminX = itemPosition.x - itemWidth/2;
		imaxX = ((i + 1) % colNum ~= 0 and iminX + gridWidth or itemPosition.x + itemWidth/2) ;
		imaxY = itemPosition.y + itemHeight/2;

		--y值需要特殊处理
		--第一排
		if i < colNum then
			iminY = itemPosition.y - itemHeight /2;

		else--第二排
			local preItem = grid:GetChild(i-colNum);
			--如果它前面的值被选中了
			if this.CardBeenSelected(preItem.gameObject) then

				iminY = itemPosition.y + itemHeight /2 - gridHeight  + clickMoveDistance;
			else
				iminY = itemPosition.y + itemHeight /2 - gridHeight
			end
		end
		if imaxX > endPos.x and iminX < endPos.x  then
			if endPos.y < imaxY   and endPos.y > iminY   then
				--返回在牌内的最后一点坐标
				return {endPos = endPos,find = true;};
			end
		end

	end

    return{endPos = endPos,find = false;};
end

function this.CheckCard(minX, maxX, minY, maxY,cardWidth,cardHeigth)

	local grid 			= this.IsGridInNeedCenter() and playerGridInCenter[0] or playerGridIn[0];
	local colNum 		= grid:GetComponent("UIGrid").maxPerLine;

	local gridWidth 	= math.abs(grid:GetComponent("UIGrid").cellWidth);
	local gridHeight 	= math.abs(grid:GetComponent("UIGrid").cellHeight);

	local itemWidth 	= cardWidth;
	local itemHeight 	= cardHeigth;
	local haveFund 		= false;
	local maxIndex = -1;
	local minIndex = -1;
	local isSelected = {};
	for i = 0, grid.childCount-1 do
		local item 			= grid:GetChild(i);
		local itemPosition 	= item.localPosition;
		local iminX;
		local imaxX;
		local iminY;
		local imaxY;

		iminX = itemPosition.x - itemWidth/2;
		imaxX = ((i + 1) % colNum ~= 0 and iminX + gridWidth or itemPosition.x + itemWidth/2) ;
		imaxY = itemPosition.y + itemHeight/2;

		--y值需要特殊处理
		--第一排
		if i < colNum then
			iminY = itemPosition.y - itemHeight /2;

		else--第二排
			local preItem = grid:GetChild(i-colNum);
			--如果它前面的值被选中了
			if this.CardBeenSelected(preItem.gameObject) then
				iminY = itemPosition.y + itemHeight /2 - gridHeight  + clickMoveDistance;
			else
				iminY = itemPosition.y + itemHeight /2 - gridHeight
			end
		end
		--print("----------------------------->");
		--print("imaxY->:"..imaxY);
		--print("iminY->:"..iminY);
		--print("iminY->:"..iminY);
		--print("iminY->:"..iminY);
		if imaxX > minX and iminX < maxX  then
			if maxY < imaxY   and minY > iminY   then
				--print("path--------->1");
				--如果是开始选中的是第二行还是第一行
				if startpos.y < imaxY and startpos.y > iminY then
					--print("path--------->2");
					--if minIndex == -1 then
					--	minIndex = i;
					--end

					if i <= colNum -1   then
						isSelected[i] = {};
						isSelected[i] = true;
						maxIndex = i;
						--print("path--------->3");
					else
						isSelected[i] = true;
						maxIndex = i;
						--print("path--------->4");
					end
					haveFund = true;
				end
				--this.OnClickCard(item.gameObject,true);

			end
		end

	end
	if haveFund then

		for i = 0, grid.childCount-1 do
			if grid.gameObject.activeSelf then
				if isSelected[i] then
					this.OnClickCard(grid:GetChild(i).gameObject,true);
				end
				--this.OnClickCard(grid:GetChild(i).gameObject,true);
			end

		end

		--for i = minIndex, maxIndex do
		--	if not isSelected[i] then
		--		this.OnClickCard(grid:Find(i).gameObject,true);
		--	end
		--end
		AudioManager.Instance:PlayAudio('touchcard');
	end


end



function this.MousePosition()
	local  mousePosition = UnityEngine.Input.mousePosition;
	local wroldPosition = UICamera.mainCamera:ScreenToWorldPoint(mousePosition);
	local grid = this.IsGridInNeedCenter() and playerGridInCenter[0] or playerGridIn[0];
	local nguiPosition = grid:InverseTransformPoint(wroldPosition);
	return nguiPosition;
end


function this.SetPlayerState(state)

	--两人局
	if roomData.setting.size == 2 then
		playerName[0].parent.parent.gameObject:SetActive(true);
		playerName[1].parent.parent.gameObject:SetActive(true);
		playerName[2].parent.parent.gameObject:SetActive(false);
		playerName[3].parent.parent.gameObject:SetActive(false);
		--三人局
	elseif roomData.setting.size == 3 then
		playerName[0].parent.parent.gameObject:SetActive(true);
		playerName[1].parent.parent.gameObject:SetActive(true);
		playerName[2].parent.parent.gameObject:SetActive(false);
		playerName[3].parent.parent.gameObject:SetActive(true);
		--四人局
	elseif roomData.setting.size == 4 then
		playerName[0].parent.parent.gameObject:SetActive(true);
		playerName[1].parent.parent.gameObject:SetActive(true);
		playerName[2].parent.parent.gameObject:SetActive(true);
		playerName[3].parent.parent.gameObject:SetActive(true);
	end

end



function this.OnClickButtonRefresh(GO)
	AudioManager.Instance:PlayAudio('btn')
	PanelManager.Instance:RestartGame()
end

--获得GPS游戏对象
function this.GetGPSUI()
	for i = 1, 6 do
		distances[i] = GPS:Find("Distance/distance"..i);
	end

	for i = 1, 4 do
		gpsPlayers[i] = GPS:Find("Players/Player"..i);
	end
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
		PanelManager.Instance:ShowWindow('panelGameSetting_dtz', sendData)
		print("游戏中申请解散房间33333333333333333")
	else
		if this.GetPlayerDataBySeat(mySeat).id == roomData.ownerId then
			sendData.ingame = true;
			PanelManager.Instance:ShowWindow('panelGameSetting_dtz', sendData)
			print("游戏未开始房主解散房间33333333333333333")
		else
			sendData.ingame = false;
			PanelManager.Instance:ShowWindow('panelGameSetting_dtz', sendData)
			print("游戏未开始玩家离开房间33333333333333333")
		end
	end
end

function this.OnClickReady(go)
	local msg = Message.New()
	msg.type = dtz_pb.READY
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


--设置是谁盖出牌了
function this.SetWhoShowShowCard(activeSeat)

	if activeSeat == mySeat then
		ShowCardTip.gameObject:SetActive(true);
		ButtonPass.gameObject:GetComponent('UIButton').isEnabled = false;

		this.StartCheckTrusteeship()
	end
	local index = this.GetUIIndex(this.GetUIIndexBySeat(activeSeat),playerSize);

	for i = 1, playerSize do
		local player = this.GetPlayerDataByUIIndex(i-1);
		if player.seat == activeSeat then
			playerKuang[this.GetUIIndex(i-1,playerSize)].gameObject:SetActive(true);
		else
			playerKuang[this.GetUIIndex(i-1,playerSize)].gameObject:SetActive(false);
		end
	end
end

function this.OnChangeSeat(msg)
	print("OnChangeSeat was called---->");
	--都选择不包庄后交换位置
	local data = dtz_pb.RChangeStatus();
	data:ParseFromString(msg.body);

	--收到了别人的交换座位申请
	if data.change == dtz_pb.CHANGE_APPLY then
		--1.自己就是那个被交换的人
		if data.toSeat == mySeat then
			local applyPlayer = this.GetPlayerDataBySeat(data.seat);
			panelMessageBoxTiShi.SetParamers(OK_CANCLE,
					function ()
						local msg 		= Message.New();
						msg.type 		= dtz_pb.CHANGE_SEAT;
						local msgBody 	= dtz_pb.PChangeSeat();
						msgBody.seat 	= data.seat;
						msgBody.change 	= dtz_pb.CHANGE_OAK;
						msg.body 		= msgBody:SerializeToString();
						SendGameMessage(msg,nil);

					end,
					function()
						local msg 		= Message.New();
						msg.type 		= dtz_pb.CHANGE_SEAT;
						local msgBody 	= dtz_pb.PChangeSeat();
						msgBody.seat 	= data.seat;
						msgBody.change 	= dtz_pb.CHANGE_REFUSE;
						msg.body 		= msgBody:SerializeToString();
						SendGameMessage(msg,nil);
					end,
					applyPlayer.name.."想要和您交换座位，同意吗？","同意","拒绝",nil,nil,false);
			PanelManager.Instance:ShowWindow('panelMessageBoxTiShi');
			--2.自己时交换位置的旁观者
		elseif mySeat ~= data.toSeat and mySeat ~= data.seat then

			local applyPlayer 	= this.GetPlayerDataBySeat(data.seat);
			local acceptPlayer 	= this.GetPlayerDataBySeat(data.toSeat);
			this.ShowChangeSeatTip("[F0CF85]"..applyPlayer.name.."[-][F4F4F4]申请与[-][F0CF85]"..acceptPlayer.name.."[-]换座位");
		end

		--收到了别人的交换座位拒绝
	elseif data.change == dtz_pb.CHANGE_REFUSE then
		if data.toSeat == mySeat then
			local refusePlayer = this.GetPlayerDataBySeat(data.seat);
			panelMessageBox.SetParamers(ONLY_OK,nil,nil,refusePlayer.name.. "拒绝与您交换座位");
			PanelManager.Instance:ShowWindow("panelMessageBox");
		end

        if data.seat ~= mySeat and data.toSeat ~= mySeat then
            local applyPlayer 	= this.GetPlayerDataBySeat(data.seat);
            local acceptPlayer 	= this.GetPlayerDataBySeat(data.toSeat);
            this.ShowChangeSeatTip("[F0CF85]"..applyPlayer.name.."[-][F4F4F4]拒绝与[-][F0CF85]"..acceptPlayer.name.."[-]换座位");
        end


		--别人正在交换座位，
	elseif data.change == dtz_pb.CHANGE_WIATING then
		local applyPlayer 	= this.GetPlayerDataBySeat(data.seat);
		local acceptPlayer 	= this.GetPlayerDataBySeat(data.toSeat);
		this.ShowChangeSeatTip("[F0CF85]"..applyPlayer.name.."[-][F4F4F4]申请与[-][F0CF85]"..acceptPlayer.name.."[-]换座位");
	end

end

function this.ShowChangeSeatTip(msg)
    --"[F0CF85]"..name1.."[-][F4F4F4]申请与[-][F0CF85]"..name2.."[-]换座位";
	coroutine.start(
			function()
				changeSeatTip.gameObject:SetActive(true);
				changeSeatTip:Find("Tip"):GetComponent("UILabel").text = msg;
				coroutine.wait(1);
				changeSeatTip.gameObject:SetActive(false);
			end	);
end

--交换座位成功
function this.OnChangeSeatSuccess(msg)
	local changeSeatData = dtz_pb.RChangeSeat();
	changeSeatData:ParseFromString(msg.body);

	mySeat = changeSeatData.selfSeat;
	DestroyRoomData.mySeat = mySeat;
	tableClear(playerData);
	tableAdd(playerData,changeSeatData.players);
	this.RefreshPlayer();
	this.GPSRefresh();
	PanelManager.Instance:HideWindow("panelMessageBox");
end

--交换位置失败
function this.OnChangeSeatError(msg)
	local RChangeSeatErrorData = dtz_pb.RChangeSeatError();
	RChangeSeatErrorData:ParseFromString(msg.body);

	if RChangeSeatErrorData.code == 0 then
        panelMessageBox.SetParamers(ONLY_OK,nil,nil,'您已经申请跟'..this.GetPlayerDataBySeat(RChangeSeatErrorData.sendSeat).name..'换座位，不能再申请');
	elseif RChangeSeatErrorData.code == 1 then
        panelMessageBox.SetParamers(ONLY_OK,nil,nil,'该玩家正在与'..this.GetPlayerDataBySeat(RChangeSeatErrorData.seat).name..'换座位');
	elseif RChangeSeatErrorData.code == 2 then
        panelMessageBox.SetParamers(ONLY_OK,nil,nil,'该玩家正在与'..this.GetPlayerDataBySeat(RChangeSeatErrorData.sendSeat).name..'换座位');
	end
	PanelManager.Instance:ShowWindow('panelMessageBox');
end

--交换座位的人已经不存在
function this.OnChangeSeatUnExist(msg)
	panelMessageTip.SetParamers('玩家已退出房间', 1);
	PanelManager.Instance:ShowWindow('panelMessageTip');
end


--交换目标无效
function this.OnChangeSeatInValid(mstg)

end



function this.OnPlayError(msg)
	print('OnPlayError : 请选择正确的牌型 ');
	panelMessageTip.SetParamers('请选择正确的牌型', 2)
	PanelManager.Instance:ShowWindow('panelMessageTip')
	ShowCardTip.gameObject:SetActive(true);
	this.RefreshMyGridIn();
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
            data.name = 'panelInGame_dtz'
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
            data.name = 'panelInGame_dtz'
            -- data.clubId = roomData.clubId
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
			--coroutine.wait(1)
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

--通过UI上的index获取绑定再gameObject上的数据对象
function this.GetPlayerDataByUIIndex(index)
	local i = index + mySeat
	i = i % playerSize
	return this.GetPlayerDataBySeat(i)
end

--通过座位号返回再UI上的index
function this.GetUIIndexBySeat(seat)
	return (playerSize-mySeat+seat)%playerSize
end

function this.GetPlayerDataBySeat(seat)
	for i=1,#playerData do
		if playerData[i].seat == seat then
			return playerData[i]
		end
	end

	return nil
end


--通过playerSize 将UI上的index转换成特殊的UI上的index
function this.GetUIIndex(index,playerSize)
	if playerSize == 3 then
		if index == 2 then
			return 3;
		else
			return index;
		end
	else
		return index;
	end
end


--玩家出牌
function this.OnPlayerHand(seat, hand)--显示其他玩家出的牌
	print('OnPlayerHand')
    for i=0,#playerGridOut do
		playerGridOut[i].gameObject:SetActive(false);
		playerwenzi[i].gameObject:SetActive(false);
		OutCardZhaDan[i].gameObject:SetActive(false);
    end
    if (not seat) or (not hand) then
        return
	end
	local index = this.GetUIIndex(this.GetUIIndexBySeat(seat),playerSize);
	local grid 	= playerGridOut[index];
	grid.gameObject:SetActive(true);
	this.RefreshOutGrid(grid,hand,seat);


end

function this.OnPlayerEnter(msg)
	print('玩家进入........')
	local b = dtz_pb.RPlayer()
	b:ParseFromString(msg.body)
	table.insert(playerData,b);
	local pData 	= this.GetPlayerDataBySeat(b.seat);
    local index 	= this.GetUIIndex(this.GetUIIndexBySeat(b.seat),playerSize);
	pData.connected = true;
	playerOffline[index].gameObject:SetActive(false);

	this.RefreshPlayer()
	print(index ..'   玩家加入后playerData的数量 :'..#playerData..'  seat : '..b.seat);

	this.InitBonusScore();
end

function this.OnPlayerJion(msg)
	print('OnPlayerJion玩家进来了')
	local b = dtz_pb.RPlayerJoin()
	b:ParseFromString(msg.body)

	local pData 	= this.GetPlayerDataBySeat(b.seat);
	pData.connected = true
	pData.ip 		= b.ip;
	pData.ready 	= b.ready;
	if b.longitude and b.longitude ~= 0 then
		pData.longitude 	= b.longitude
		pData.latitude 		= b.latitude
    else
		pData.longitude 	= 0
		pData.latitude 		= 0
    end
    if b.address and b.address ~= "" then
		pData.address = b.address
    else
		pData.address = "未获取到该玩家位置"
	end
    local index = this.GetUIIndex(this.GetUIIndexBySeat(b.seat),playerSize);
	playerOffline[index].gameObject:SetActive(false);

	this.GPSRefresh();
	ButtonInvite.gameObject:SetActive(#playerData ~= roomData.setting.size and IsAppleReview() == false)
	ButtonInvite.parent:GetComponent("UIGrid"):Reposition();
	this.NotifyGameStart();
	this.RefreshChangeSeatState();

	this.StopOfflineIncrease(b.seat)
end


--更新GPS位置信息
function this.GPSRefresh()
	this.SetGPSUI(playerSize);
	this.SetDistance(this.GetDistance(playerSize));
end

--根据玩的人数设置GSP的显隐
function this.SetGPSUI(playerSize)
	print("几个人的定位啊~~",playerSize)
	if playerSize == 2 then --两个人不显示定位
		for i = 1, 6 do
			distances[i].gameObject:SetActive(false);
		end
		--distances[6].gameObject:SetActive(true);
		for i = 1, 4 do
			gpsPlayers[i].gameObject:SetActive(false);
		end

	elseif playerSize == 3 then
		distances[1].gameObject:SetActive(false);
		distances[2].gameObject:SetActive(false);
		distances[5].gameObject:SetActive(false);

		distances[3].gameObject:SetActive(true);
		distances[4].gameObject:SetActive(true);
		distances[6].gameObject:SetActive(true);

		gpsPlayers[1].gameObject:SetActive(true);
		gpsPlayers[3].gameObject:SetActive(true);
		gpsPlayers[4].gameObject:SetActive(true);
		gpsPlayers[2].gameObject:SetActive(false);

		function getIndex(index)

			if index == 2 then
				return 3;
			elseif index == 3 then
				return 4;
			else
				return index;
			end
		end

		for i = 1, 3 do
			local player = this.GetPlayerDataByUIIndex(i-1);
			if player then
				gpsPlayers[getIndex(i)]:Find("Name"):GetComponent("UILabel").text = player.name;
			else
				gpsPlayers[getIndex(i)]:Find("Name"):GetComponent("UILabel").text = "";

			end
		end


	else
		for i = 1, 6 do
			distances[i].gameObject:SetActive(true);
		end
		for i = 1, 4 do
			gpsPlayers[i].gameObject:SetActive(true);
			local player = this.GetPlayerDataByUIIndex(i-1);
			if player then
				gpsPlayers[i]:Find("Name"):GetComponent("UILabel").text = player.name;
			else
				gpsPlayers[i]:Find("Name"):GetComponent("UILabel").text = "";
			end
		end
	end

end

--根据玩的人数和玩家的GPS信息返回对应的距离
function this.GetDistance(playerSize)
	local keys = this.GetDistanceKey(playerSize);
	local i = 0;
	local distanceTable = {};
	for key, value in pairs(keys) do

		if i <= 3 then
			local playerData1 = this.GetPlayerDataByUIIndex(i);
			local p2index = (i + 1) % playerSize;
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

--设置距离
function this.SetDistance(distanceTable)
	if playerSize == 2 then return end;
	for key, value in pairs(distanceTable) do
		--print("key="..key..",value:"..value);
		if value == -1 then
			--distances[key].gameObject:SetActive(false);
			distances[key]:Find("disLabel"):GetComponent("UILabel").text = "";
		else
			distances[key].gameObject:SetActive(true);
			distances[key]:Find("disLabel"):GetComponent("UILabel").text = value;
		end

	end
end

function this.GetDistanceKey(playerSize)
	if playerSize == 2 then
		--return {};
		return {6};
	elseif playerSize == 3 then
		return {6,3,4};
	else
		return {1,2,3,4,5,6};
	end
end


function this.GPSGetPlayerDataByUIIndex(index)
	local i = index + mySeat
	i = i % 4
	return this.GPSGetPlayerDataBySeat(i)
end

function this.GPSGetPlayerDataBySeat(seat)
	for i=1,#playerData do
		if playerData[i].seat == seat then
			return playerData[i]
		end
	end
	return nil
end

function this.getLineIndex(a,b)
	if a==0 or b==0 then
		return a + b - 1;
	else
		return a + b ;
	end
end

function this.RefreshGroupData()
	local seats = {0,1,2,3};

	--1.首先设置已经进来的
	for i = 1, #playerData do
		local index = this.GetUIIndex(this.GetUIIndexBySeat(playerData[i].seat),playerSize);
		if playerData[i].seat == 0 or playerData[i].seat == 2 then--A组
			playerGroups[index]:GetComponent("UISprite").spriteName = "扑克通用-A组标记";
		else
			playerGroups[index]:GetComponent("UISprite").spriteName = "扑克通用-B组标记";
		end
		playerGroups[index].gameObject:SetActive(true);
	end

	--2.设置剩下的位置
	for i = 1, #playerData do
		for j = 1, #seats do
			if playerData[i].seat == seats[j] then
				table.remove(seats,j);
				break;
			end
		end
	end

	for i = 1, #seats do
		local index = this.GetUIIndex(this.GetUIIndexBySeat(seats[i]),playerSize);
		if seats[i] == 0 or seats[i] == 2 then--A组
			playerGroups[index]:GetComponent("UISprite").spriteName = "扑克通用-A组标记";
		else
			playerGroups[index]:GetComponent("UISprite").spriteName = "扑克通用-B组标记";
		end
		playerGroups[index].gameObject:SetActive(true);
	end
end


function this.OnPlayerLeave(msg)
	print('OnPlayerLeave');
	local b = dtz_pb.RPlayerLeave();
	b:ParseFromString(msg.body);
	local index = this.GetUIIndex(this.GetUIIndexBySeat(b.seat),playerSize);

	for i = 1, #playerData do
		if playerData[i].seat == b.seat then
			--print("player "..i.." want leave seat:"..tostring(playerData[i].seat));
			table.remove(playerData,i);
			break;
		end
	end
	this.RefreshPlayer();
	this.GPSRefresh();
	this.RefreshChangeSeatState();
	this.InitBonusScore();

	ButtonInvite.gameObject:SetActive(#playerData ~= roomData.setting.size and IsAppleReview() == false)
	ButtonInvite.parent:GetComponent("UIGrid"):Reposition();

end
function this.OnLeaveRoom(msg)
	--print('OnLeaveRoom');
	NetWorkManager.Instance:DeleteConnect('game');
	PanelManager.Instance:HideWindow('panelDestroyRoom');
	panelLogin.HideGameNetWaitting();
    if roomData.clubId ~= '0' then
        local data = {}
        data.name = 'panelInGame_dtz'
        PanelManager.Instance:ShowWindow('panelClub', data)
    else
        PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
	end
	roomData.clubId = '0'

end

function this.RefreshMyGridIn()
	print('RefreshMyGridIn was called,gamestate:'..tostring(roomData.state == dtz_pb.GAMING));

	for i=0,roomData.setting.size -1 do
        local pData = this.GetPlayerDataByUIIndex(i)
		if pData and pData.seat == mySeat then
			local centerGrid = playerGridInCenter[this.GetUIIndex(this.GetUIIndexBySeat(mySeat),playerSize)];
			local grid = playerGridIn[this.GetUIIndex(this.GetUIIndexBySeat(mySeat),playerSize)];
			local finalGrid = nil;
			if #pData.cards > overCenterCardCount then
				finalGrid = grid;
				grid.gameObject:SetActive(true);
				centerGrid.gameObject:SetActive(false);
			else
				finalGrid = centerGrid;
				grid.gameObject:SetActive(false);
				centerGrid.gameObject:SetActive(true);
			end

			this.RefreshGrid(finalGrid, pData.cards);
		else
			playerGridInCenter[i].gameObject:SetActive(false);
			playerGridIn[i].gameObject:SetActive(false);
		end
    end
end


function this.RepositionGridIn()
	local index = this.GetUIIndex(this.GetUIIndexBySeat(mySeat),playerSize);
	local grid = playerGridIn[index].gameObject.activeSelf and playerGridIn[index] or playerGridInCenter[index];
	grid:GetComponent("UIGrid"):Reposition();

end




function this.OnRoundStart(msg) --游戏开始
	print('OnRoundStart');

	local b = dtz_pb.RRoundStart()
	b:ParseFromString(msg.body)
	if roomData.round == 1 and not (roomData.setting.size == 2) then
        local datas = {}
		for i = 0, roomData.setting.size - 1 do
			datas[i] = this.GetPlayerDataByUIIndex(i)
		end
        InspectIPAndGPS(datas,roomData.setting.size == 3 and pos3 or pos4,this.OnClicButtonDisbandRoom)   
    end
	if panelInGame.needXiPai==true then
		panelInGame.needXiPai=false
		connect.IsZanTing=true
		PanelManager.Instance:ShowWindow('panelXiPai_poker',function()
			this.gameStart(b)
			connect.IsZanTing=false
		end)
	else
		this.gameStart(b)	
	end
end

function this.gameStart(b)
	--更新玩家的手牌
	tableClear(playerData);
	tableAdd(playerData,b.players);
	tableClear(roomData.latestHand.cards);
	roomData.activeSeat = b.activeSeat;

	RestTime.gameObject:SetActive(false)
	GPS.gameObject:SetActive(false)
	selectCards={}

	--开局后对托管计时粘贴
	this.StopCheckTrusteeship()

	roomData.state = dtz_pb.GAMING;
	this.SetInviteVisiable(false)
	this.RefreshMyGridIn();

	this.RefreshPlayer();
	this.SetReadyVisiable();
	this.SetRoundNum(roomData.round);

	this.SetWhoShowShowCard(b.activeSeat);
	this.RefreshStartGameState();
	if roomData.setting.show then
		this.InitCardCounts();
	end
	lastFindCards ={}
	helpNumWhenHaveOneCard = 0

	--播放游戏开始音效，
	if roomData.round == 1 then
		AudioManager.Instance:PlayAudio('gameStart07');

	end
	this.ShowAutoRunTip();

	this.SetCountDownVisiable();

	--有可能在托管中 开局后自动 隐藏小结算
	this.CloseStageClear()
end

function this.ShowAutoRunTip()
	if roomData.round == 1 then
		if roomData.setting.size == 4 and roomData.setting.autoRun then
			PanelManager.Instance:HideWindow("panelMessageBoxTiShi");
			PanelManager.Instance:HideWindow("panelMessageBox");
			changeSeatTip.gameObject:SetActive(false);
			panelMessageTip.SetParamers('所有人已准备，游戏自动开始', 2);
			PanelManager.Instance:ShowWindow('panelMessageTip');
		end
	end
end


function this.GPSClear()
    GPS.gameObject:SetActive(false)
end

this.hasStageClear=false;
function this.OnRoundEnd(msg)
	--print('OnRoundEnd')
	this.hasStageClear=true
	local b = dtz_pb.RRoundEnd()
	b:ParseFromString(msg.body)

	roomData.round = roomData.round+1
	ShowCardTip.gameObject:SetActive(false);
	StartCoroutine(function ()
		connect.IsZanTing=true
		WaitForSeconds(2);
		local stageRoomInfo 		= {};
		stageRoomInfo.roomNumber 	= roomInfo.roomNumber;
		stageRoomInfo.roomData 		= roomData;
		stageRoomInfo.playerDatas 	= b.players;
		stageRoomInfo.playerData 	= playerData
		stageRoomInfo.darkCards 	= b.darkCards;
		stageRoomInfo.isInGame = true
		stageRoomInfo.gameOver 	= b.gameOver;
		stageRoomInfo.isBack 	= false;
		stageRoomInfo.fuc=function()
			connect.IsZanTing=false
		end
		PanelManager.Instance:ShowWindow('panelStageClear_dtz',stageRoomInfo);
		this.ClearRoom()
	end);
	--小局结束后后对托管计时粘贴
	this.StopCheckTrusteeship()
end

function this.OnGameOver(msg)
	print('所有局数结束')
	local b = dtz_pb.ROver()
	b:ParseFromString(msg.body)
	--print(msg.body)
	RoundAllData.data 			= b
	RoundAllData.mySeat 		= mySeat
	RoundAllData.playerData 	= playerData
	RoundAllData.over 			= true;
	RoundAllData.roomData		= roomData;
	RoundAllData.playName = roomData.playName
	local Trusteeships={}
	for i = 0, roomData.setting.size-1 do
		local  k = i
		if roomData.setting.size == 3 then
			if i == 2 then
				k = 3					
			end
		end
        local da = this.GetPlayerDataByUIIndex(i)
        if playerTrusteeship[k].gameObject.activeSelf then
            Trusteeships[da.seat] = true
        else
            Trusteeships[da.seat] = false
        end
    end
    for i = 0, #Trusteeships do
        print(i..'Trusteeships[i] : '..tostring(Trusteeships[i]))
    end
    RoundAllData.isTrusteeships = Trusteeships
	-- print("complete", tostring(b.complete))
	-- print("hasStageClear", tostring(this.hasStageClear))

	if not b.complete and this.hasStageClear==false then
		PanelManager.Instance:ShowWindow("panelStageClearAll_dtz",roomInfo);
	end
end

function this.OnReady(msg)
	print('OnReady')
	local b = dtz_pb.RReady()
	b:ParseFromString(msg.body)
    local ix = this.GetUIIndex(this.GetUIIndexBySeat(b.seat),playerSize);
	playerReady[ix].gameObject:SetActive(true);
	this.GetPlayerDataBySeat(b.seat).ready = true
	if b.seat == mySeat then
		readybtn.gameObject:SetActive(false)
		print("readybtn --------------->5");

	end
	for i=0,3 do
		playerGridOut[i].gameObject:SetActive(false)
		OutCardZhaDan[i].gameObject:SetActive(false)
		playerGridIn[i].gameObject:SetActive(false)
		playerGridInCenter[i].gameObject:SetActive(false);
	end

	this.NotifyGameStart();
	this.RefreshStartGameState(roomData.enabledChange);

end

function this.OnDisconnected(msg)
	print('OnDisconnected')
	local b = dtz_pb.RSeat()
	b:ParseFromString(msg.body)
	local index = this.GetUIIndex(this.GetUIIndexBySeat(b.seat),playerSize);
	this.GetPlayerDataBySeat(b.seat).connected = false;
	playerOffline[index].gameObject:SetActive(true);

	this.StartOfflineIncrease(b.seat, 0);
end

function this.OnPlayerPlay(msg)
	print('OnPlayerPlay   玩家出牌了&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&')

	local b = dtz_pb.RPlay()
	b:ParseFromString(msg.body)
	if b.nextSeat == -1 then
		return ;
	end
	currentPlayState = b.state;
	this.OnPlayerHand(b.seat, b.hand);
	--print('当前玩家出的牌的个数 ：'..#b.hand.cards)
	--scoreView.score.scoreLabel:GetComponent('UILabel').text=b.score and b.score or 0
	local pData = this.GetPlayerDataBySeat(b.seat);
	local index = this.GetUIIndex(this.GetUIIndexBySeat(b.seat),playerSize);
	this.RefreshDeskScore(b);
	if roomData.setting.show then
		pData.len = pData.len - #b.hand.cards;
	end

	if mySeat == pData.seat then
		this.RemoveCards(b.hand.cards ,pData.cards);
		this.HideSelectCards();
		this.RefreshMyGridIn();
	else
		this.SetCardCounts(b.cardCount,b.seat);
	end

	this.HideAllVFX();
	if b.next ~= -1 then
		roomData.activeSeat  		= b.next;
	end
	roomData.latestSeat  			= b.seat;
	roomData.latestHand.category 	= b.hand.category;
	roomData.latestHand.keyCardCount = b.hand.keyCardCount;

	tableClear(roomData.latestHand.cards);
	tableAdd(roomData.latestHand.cards,b.hand.cards);
	if b.seat == mySeat then
		mySelectCards={}
	end
	lastFindCards = {}
	helpNumWhenHaveOneCard = 0
	winSeat = nil

	this.SetCountDownVisiable();
	this.PlayCardEffect(index,b.hand.category)
	this.PlayCardSound(b.hand.cards,pData.sex,b.hand.category,b.hand.keyCardCount);
	this.SetOutCardFinish(b);
	this.ResetHelpData();

	DelayMsgDispatch(connect, 0.5)
end

function this.PlayCardEffect(uiIndex,category)
	if category == 4 then
		PanelManager.Instance:ShowWindow('panelAnimation_feiJi')
	elseif category == 5 then
		PanelManager.Instance:ShowWindow('panelAnimation_zhanDan',gameObject.transform:Find('outCardPos/'..uiIndex).localPosition)
	elseif category == 6 then
		PanelManager.Instance:ShowWindow('panelAnimation_tongzi','')
	elseif category == 7 then
		PanelManager.Instance:ShowWindow('panelAnimation_huoJian')
	elseif category == 8 then
		PanelManager.Instance:ShowWindow('panelAnimation_xi',gameObject.transform:Find('outCardPos/'..uiIndex).localPosition)
	end
end

function this.RemoveCards(outCards,HandCards)
	for i=1,#outCards do
		for j=1,#HandCards do
			if outCards[i] == HandCards[j] then
				table.remove(HandCards,j);
				break;
			end
		end
	end
end

function this.HideAllVFX()
	for i = 0, 3 do
		playerzi[i].gameObject:SetActive(false);
		playerwenzi[i].gameObject:SetActive(false);
	end
end

function this.ShowVFX(index,show)
	playerzi[index].gameObject:GetComponent('UISprite').spriteName = 'pass_1';
	playerzi[index].gameObject:GetComponent('UISprite'):MakePixelPerfect();
	playerzi[index].gameObject:SetActive(show);
	playerwenzi[index].gameObject:SetActive(show);
end

--设置剩余牌
function this.SetCardCounts(cardLength,seat)
	--print("SetCardCounts---------------------->");
	if seat ~= mySeat then
		local index = this.GetUIIndex(this.GetUIIndexBySeat(seat),playerSize);
		playerRestCards[index]:Find("num"):GetComponent("UILabel").text = cardLength;
		local sex = this.GetPlayerDataBySeat(seat).sex;
		--print("cardLength-------------------->"..cardLength..",seat:"..seat);
		if cardLength == 1 or cardLength == 2 then
			--print("SetWarnnig was called,cardLength"..cardLength.."seat:"..seat);
			local soundName = cardLength == 1 and string.format("dtzbaodan_%d",sex) or string.format("dtzbaoshuang_%d",sex);
			--print("soundName:"..soundName);
			StartCoroutine(function ()
				WaitForSeconds(0.6);
				AudioManager.Instance:PlayAudio(soundName);
			end);

			this.SetWarnnig(true,index);
		else
			this.SetWarnnig(false,index);
		end
	end
end

--设置警报
function this.SetWarnnig(show,index)
	--print("SetWarnnig------------>show:"..tostring(show));
	playerWarnning[index].gameObject:SetActive(show);

end

function this.HideAllWarnning()
	for i = 1, 3 do
		playerWarnning[i].gameObject:SetActive(false);
	end
end

function this.InitCardCounts()

	for i = 1, 3 do
		playerRestCards[i].gameObject:SetActive(false);
	end
	for i = 1, #playerData do
		if playerData[i].seat ~= mySeat then
			local index = this.GetUIIndex(this.GetUIIndexBySeat(playerData[i].seat),playerSize);
			this.SetCardCounts(playerData[i].len,playerData[i].seat);
			print("playerRestCards in InitCardCounts:"..tostring(roomData.setting.show and roomData.state == dtz_pb.GAMING));
			print("playerData[i].cards:"..#playerData[i].cards);
			playerRestCards[index].gameObject:SetActive(roomData.setting.show and roomData.state == dtz_pb.GAMING and playerData[i].len>0);
		end
	end
end

function this.SetOutCardFinish(data)
	local index = this.GetUIIndex(this.GetUIIndexBySeat(data.seat),playerSize);
	OutCardFinish[index].gameObject:SetActive(false);
	local name ;
	if data.roundOrder == 0 then
		name = '上游'
	elseif data.roundOrder == 1 then
		name = '二游'
	elseif data.roundOrder == 2 then
		name = '三游'
	elseif data.roundOrder == 3 then
		name = '下游'
	elseif data.roundOrder == -1 then
		name = ''
	end
	OutCardFinish[index]:GetComponent('UISprite').spriteName = name;
	OutCardFinish[index].gameObject:SetActive(data.roundOrder ~= -1);
	if data.roundOrder ~= -1 then
		AudioManager.Instance:PlayAudio('winerVoice');
	end

	if data.seat ~= mySeat then
		print("playerRestCards in SetOutCardFinish:"..tostring(roomData.setting.show and data.roundOrder == -1));
		playerRestCards[index].gameObject:SetActive(roomData.setting.show and data.roundOrder == -1);
	end

end


function this.PlayCardSound(cards,sex,category,keyCardCount)
	--print("PlayCardSound:"..tostring(category));
	local soundName =''
	if category == 0 then
		soundName = string.format('dtzsingle_%d_%d', sex, this.ProcessCard(cards)[1].value);
	elseif category == 1 then	
		soundName = string.format('dtzdouble_%d_%d', sex, this.ProcessCard(cards)[1].value);
	elseif category == 2 then	
		local main,slave = dtz_Logic.SeperateMainAndSlave(this.ProcessCard(cards),category,roomData.setting.cardCount,keyCardCount);
		soundName = string.format('dtztriple_%d_%d', sex, main[1].value);
	elseif category == 3 then
		soundName = string.format('dtzliandui_%d', sex);
	elseif category == 4 then
		soundName = string.format('dtzwing_%d', sex);
	elseif category == 5 then
		soundName = string.format('dtzbomb_%d_%d', sex,#this.ProcessCard(cards));
		--this.PlayTailAudio("ZD_LittleBoom");
	elseif category == 6 then
		soundName = string.format('dtztongzi_%d_%d', sex,this.ProcessCard(cards)[1].value);
		--this.PlayTailAudio("ZD_LittleBoom");
	elseif category == 7 then
		soundName = string.format('ZD_LittleBoom');
	elseif category == 8 then
		soundName = string.format('dtzxi_%d_%d', sex,this.ProcessCard(cards)[1].value);
		--this.PlayTailAudio("ZD_LittleBoom");
	end
	print('声音 ：'..soundName)
	if soundName ~= nil then
		if category == 5 and #cards > 10 then
		else
			AudioManager.Instance:PlayAudio(soundName);
		end
	end
end
--播放尾音
function this.PlayTailAudio(soundName)
	StartCoroutine(function ()
		WaitForSeconds(0.5);
		AudioManager.Instance:PlayAudio(soundName);
	end);
end

function this.OnPlayerPass(msg)
	--print("玩家过牌。。。。。")
	local b = dtz_pb.RPass()
	b:ParseFromString(msg.body)

	local index = this.GetUIIndex(this.GetUIIndexBySeat(b.seat),playerSize);
	OutCardZhaDan[index].gameObject:SetActive(false);
	this.initOutCardGroup(playerGridOut[index])
	this.ShowVFX(index,true);

	AudioManager.Instance:PlayAudio(string.format('dtzpass_%d', this.GetPlayerDataBySeat(b.seat).sex));
	if b.nextSeat ~= -1 then
		roomData.activeSeat = b.nextSeat
		--print("OnPlayerPass activeSeat:"..roomData.activeSeat);
		winSeat 			= b.winSeat
		currentPlayState 	= b.state;
		this.SetCountDownVisiable();
	end

	this.ResetHelpData();

	DelayMsgDispatch(connect, 0.5)
end

function this.OnDissolve(msg)
	local b = dtz_pb.RDissolve()
	b:ParseFromString(msg.body)
	print(b.decision)
	if b.decision == dtz_pb.APPLY then
		--print('申请解散房间..............')
		roomData.dissolution.applicant = b.seat;
		while #roomData.dissolution.acceptors > 0 do
			table.remove(roomData.dissolution.acceptors, #roomData.dissolution.acceptors)
		end
		roomData.dissolution.remainMs = b.remainMs/1000
		this.SetDestoryPanelShow()
	elseif b.decision == dtz_pb.AGREE then
		--print('同意解散房间..............')
		table.insert(DestroyRoomData.roomData.dissolution.acceptors, b.seat)
		panelDestroyRoom.Refresh()
	elseif b.decision == dtz_pb.AGAINST then
		--print('拒绝解散房间..............')
		table.insert(DestroyRoomData.roomData.dissolution.rejects, b.seat)
		panelDestroyRoom.Refresh(b.seat)
	end
	if b.failure == true then
		--PanelManager.Instance:HideWindow('panelDestroyRoom')
	end
end

function this.Destroy(msg)
	print('销毁房间..............')
	this.StopCheckNetState()
	this.StopAllOfflineIncrease()
	this.StopCheckTrusteeship()
	this.fanHuiRoomNumber = nil
	NetWorkManager.Instance:DeleteConnect('game')
	panelLogin.HideGameNetWaitting()
	PanelManager.Instance:HideWindow('panelDestroyRoom');
	if panelStageClear_dtz then
		panelStageClear_dtz.setButtonsStatus(true)
	end
	if roomData.round == 1 and roomData.state == dtz_pb.READYING then
		NetWorkManager.Instance:DeleteConnect('game');
		if roomData.clubId ~= '0' then
			local data = {};
			data.name = 'panelInGame_dtz';
			PanelManager.Instance:ShowWindow('panelClub', data);
		else
			PanelManager.Instance:ShowWindow('panelLobby',gameObject.name);
		end
		roomData.clubId = '0'
		--panelInGame =nil
		return

	end

	StartCoroutine(function ()
		WaitForSeconds(2);
		this.ClearRoom();
	end);
end

function this.ClearRoom()
	print("ClearRoom was called");
	for i=0,3 do
		playerScore[i]:GetComponent('UILabel').text ='0'
		playerGroups[i].gameObject:SetActive(false)
		playerSound[i].gameObject:SetActive(false)
		playerOffline[i].gameObject:SetActive(false)
		playerGridIn[i].gameObject:SetActive(false);
		playerGridInCenter[i].gameObject:SetActive(false);
		playerGridOut[i].gameObject:SetActive(false)
		OutCardZhaDan[i].gameObject:SetActive(false)
		playerReady[i].gameObject:SetActive(false)
		OutCardFinish[i].gameObject:SetActive(false);
		playerKuang[i].gameObject:SetActive(false)
		currentPlayState = dtz_pb.PLAYER_PLAY;
		if i>0 then
			playerRestCards[i].gameObject:SetActive(false);
		end


	end
	--tableClear(this.GetPlayerDataBySeat(mySeat).cards);
	this.HideAllWarnning();
	this.HideAllVFX();
	ShowCardTip.gameObject:SetActive(false);
	noBigCard.gameObject:SetActive(false);
	if roomData then
		roomData.state = dtz_pb.READYING
	end

	for i = 1, #playerData do
		tableClear(playerData[i].cards);
	end

	this.ResetHelpData();

	this.InitDeskScore({wu=0,shi=0,king=0});

	PanelManager.Instance:HideWindow("panelPlayerInfo");
	PanelManager.Instance:HideWindow("panelChat");
	PanelManager.Instance:HideWindow("panelGameSetting_dtz");


end



--是否显示解散房间，返回大厅，邀请玩家按钮
function this.SetInviteVisiable(show)
	--print("SetInviteVisiable was called----->");
	ButtonCloseRoom.gameObject:SetActive(show)
	ButtonExitRoom.gameObject:SetActive(show)

	if not PlatformManager.Instance:IsWXAppInstalled() then
		show = false
	end
	ButtonInvite.gameObject:SetActive(#playerData ~= roomData.setting.size and IsAppleReview() == false)
	if this.GetPlayerDataBySeat(mySeat).id == roomData.ownerId then
		ButtonCloseRoom:Find('Label'):GetComponent("UILabel").text = "解散房间"
	else
		ButtonCloseRoom:Find('Label'):GetComponent("UILabel").text = "退出房间"
	end
	ButtonInvite.parent:GetComponent("UIGrid"):Reposition();
end


--初始化交换座位
function this.RefreshChangeSeatState()

	--1.处于可以交换座位的状态
	--2.4人才可以交换座位
	for i = 1, 3 do
		changeSeatButtons[i].gameObject:SetActive(false);
	end

	if playerSize == 4 then
		for i = 1, #playerData do
			if playerData[i].seat ~= mySeat and roomData.state == dtz_pb.READYING then
				changeSeatButtons[this.GetUIIndex(this.GetUIIndexBySeat(playerData[i].seat))].gameObject:SetActive(true);
			end
		end
	end

end

--处理交换位置过程中短线重连的情况
function this.InitChangeSeatData(changeArray)
	if not changeArray or #changeArray == 0 then
		return;
	end
	for i = 1, #changeArray do
		--1.有人要跟我交换
		if changeArray[i].sendSeat == mySeat then
			local applyPlayer = this.GetPlayerDataBySeat(mySeat);
			panelMessageBoxTiShi.SetParamers(OK_CANCLE,
					function ()
						--print("重连后发送交换位置请求")
						local msg 		= Message.New();
						msg.type 		= dtz_pb.CHANGE_SEAT;
						local msgBody 	= dtz_pb.PChangeSeat();
						msgBody.seat 	= changeArray[i].seat;
						msgBody.change 	= dtz_pb.CHANGE_OAK;
						msg.body 		= msgBody:SerializeToString();
						SendGameMessage(msg,nil);

					end,
					function()
						local msg = Message.New();
						msg.type 		= dtz_pb.CHANGE_SEAT;
						local msgBody 	= dtz_pb.PChangeSeat();
						msgBody.seat 	= changeArray[i].seat;
						msgBody.change 	= dtz_pb.CHANGE_REFUSE;
						msg.body 		= msgBody:SerializeToString();
						SendGameMessage(msg,nil);
					end,
					applyPlayer.name.."想要和您交换座位，同意吗？","同意","拒绝",nil,nil,false);
			PanelManager.Instance:ShowWindow('panelMessageBoxTiShi');
		--2.我正在看别人交换
		elseif changeArray[i].sendSeat ~= mySeat and changeArray[i].seat ~= mySeat then
			local applyPlayer 	= this.GetPlayerDataBySeat(changeArray[i].seat);
			local acceptPlayer 	= this.GetPlayerDataBySeat(changeArray[i].sendSeat);
			this.ShowChangeSeatTip("[F0CF85]"..applyPlayer.name.."[-][F4F4F4]申请与[-][F0CF85]"..acceptPlayer.name.."[-]换座位");
		end

	end
end

--点击交换座位
function this.OnClickButtonChangeSeat(go)
	--print("OnClickButtonChangeSeat was called");
	local pData = GetUserData(go.transform.parent:Find("info/Texture").gameObject);
	panelMessageBoxTiShi.SetParamers(OK_CANCLE,
			function ()
				local msg = Message.New();
				msg.type = dtz_pb.CHANGE_SEAT;
				local msgBody = dtz_pb.PChangeSeat();
				msgBody.seat = pData.seat;
				msgBody.change = dtz_pb.CHANGE_APPLY;
				msg.body = msgBody:SerializeToString();
				SendGameMessage(msg,nil);
			end ,
			function ()
				--print("you canceled exchange seat!");
			end ,
			'您确定要和'..pData.name..'换座位吗？');

	PanelManager.Instance:ShowWindow('panelMessageBoxTiShi');
end

function this.SetDestoryPanelShow() 
	PanelManager.Instance:HideWindow('panelDestroyRoom');
    PanelManager.Instance:ShowWindow('panelDestroyRoom');
end

function this.SetReadyVisiable()
    for i=0,3 do
		if roomData.state == dtz_pb.WAITING then
			playerReady[i].gameObject:SetActive(false)
			readybtn.gameObject:SetActive(true)
			print("readybtn --------------->1");
			--print("没有准备好")
		elseif roomData.state == dtz_pb.READYING then
			if i <= #playerData then
				local p = this.GetPlayerDataByUIIndex(i)
				if p and p.ready then
					playerReady[i].gameObject:SetActive(true)
				else
					playerReady[i].gameObject:SetActive(false)
				end
				if p and p.seat == mySeat then
					if p.ready then
						--print(i.."已经准备好")
						readybtn.gameObject:SetActive(false)
						print("readybtn --------------->2");

					else
						readybtn.gameObject:SetActive(true)
						print("readybtn --------------->3");

						--print(i.."没有准备好")
					end
				end
			else
				playerReady[i].gameObject:SetActive(false)
			end
		elseif roomData.state == dtz_pb.GAMEOVER and roomData["end"] ~= nil and (not this.GetPlayerDataBySeat(mySeat).ready) then
			local stageRoomInfo 		= {};
			stageRoomInfo.roomNumber 	= roomInfo.roomNumber;
			stageRoomInfo.roomData 		= roomData;
			stageRoomInfo.playerDatas 	= roomData["end"].players;
			stageRoomInfo.darkCards 	= roomData["end"].darkCards;
			stageRoomInfo.playerData 	= playerData
			stageRoomInfo.isInGame = true
			stageRoomInfo.gameOver 	= false;
			stageRoomInfo.isBack 	= true;
			stageRoomInfo.fuc=function()
				connect.IsZanTing=false
			end
			PanelManager.Instance:ShowWindow('panelStageClear_dtz',stageRoomInfo);
		else
			playerReady[i].gameObject:SetActive(false);
			--print("游戏中了影藏准备按钮")
			readybtn.gameObject:SetActive(false);
			print("readybtn --------------->4");

		end
    end
end

function this.SetCountDownVisiable(time)
	--print("SetCountDownVisiable was called-------->");
	local index = this.GetUIIndex(this.GetUIIndexBySeat(roomData.activeSeat),playerSize);
	ButtonPass.gameObject:SetActive(not roomData.setting.guan);
	noBigCard.gameObject:SetActive(false);
	ButtonPlay:GetComponent("UIButton").isEnabled = true;
	ButtonHelp:GetComponent("UIButton").isEnabled = true;

	print('轮到我操作了我的ui索引是 ：'..tostring(winSeat));
	if roomData.activeSeat == mySeat then
		if currentPlayState == dtz_pb.PLAYER_OVER then
			ShowCardTip.gameObject:SetActive(false);
		else
			--print("currentPlayState:"..currentPlayState);
			if currentPlayState == dtz_pb.PLAYER_PLAY then --不是跟牌，而是轮到自己出牌，不能pass
				ButtonPass:GetComponent("UIButton").isEnabled = false;
				StartCoroutine(function ()--这里之所以等待一下，是想让用户看到对方不要的特效
					this.InitAllOutCardGroup();
					WaitForSeconds(0.5);
					this.HideAllVFX();
				end);

			elseif currentPlayState == dtz_pb.PLAYER_GEN and roomData.setting.guan then -- 有牌必管，并且是在跟牌，不能pass
				ButtonPass:GetComponent("UIButton").isEnabled = false;
			elseif currentPlayState == dtz_pb.PLAYER_GEN or currentPlayState == dtz_pb.PLAYER_PASS then
				ButtonPass:GetComponent("UIButton").isEnabled = true;--处于跟牌的状态，可以pass

				--如果没有能大的牌，要显示提示，同时不能点提示和出牌按钮
				if currentPlayState == dtz_pb.PLAYER_PASS and not roomData.setting.guan then
					noBigCard.gameObject:SetActive(true);
					ButtonPlay:GetComponent("UIButton").isEnabled = false;
					ButtonHelp:GetComponent("UIButton").isEnabled = false;
				end
			end
			if roomData.setting.guan and currentPlayState == dtz_pb.PLAYER_PASS then
				ShowCardTip.gameObject:SetActive(false);

			else
				ShowCardTip.gameObject:SetActive(true);
			end
		end

		this.StartCheckTrusteeship(time)
	else
		ShowCardTip.gameObject:SetActive(false)
		if currentPlayState == dtz_pb.PLAYER_PLAY then
			StartCoroutine(function ()--这里之所以等待一下，是想让用户看到对方不要的特效
				WaitForSeconds(0.5);
				this.InitAllOutCardGroup();
				this.HideAllVFX();
			end);
		end

		this.StopCheckTrusteeship();
	end
	this.ShowVFX(index,false);

	for i = 0, 3 do
		if i==index then
			playerKuang[i].gameObject:SetActive(true)
		else
			playerKuang[i].gameObject:SetActive(false)
		end
	end

	ShowCardTip:GetComponent("UIGrid"):Reposition();

end

function this.SetRoundNum(num)
	roomRound:GetComponent('UILabel').text = "第"..num..'局';
	--设置游戏规则面板
end

function this.OnClickButtonChat(go)
	AudioManager.Instance:PlayAudio('btn')
	print('roomData.setting.sendMsgAllowed : '..tostring(roomData.setting.sendMsgAllowed))
	if roomData.setting.sendMsgAllowed then
        PanelManager.Instance:ShowWindow('panelChat')
    else
        panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '群主已经禁止游戏过程中聊天，如有疑问请联系群主')
        PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
    end
end

--排序
function this.OnClickButtonSort(go)

	--print("OnClickButtonSort was called");
	NeedCombination = not NeedCombination;
	this.RefreshMyGridIn();

end

function this.OnClickButtonInvite(go)
	local msg  ="";
	msg = msg..GetDTZRuleString(roomData.setting,false,true);
	msg = msg.."房已开好,就等你来！"
	print("分享信息",msg)
	local que = roomData.setting.size - (#playerData);
	local title = roomInfo.roomNumber.."房,"..roomData.playName..roomData.setting.size.."缺"..que
	print("title",title);
	PlatformManager.Instance:ShareLink('http://'..panelLogin.HttpUrl..'/shareRoom.html?appType=1&state=' ..proxy_pb.DTZ..roomInfo.roomNumber, title, msg, 0);
end

function this.OnClickPlayerIcon(go)
	if IsAppleReview() then
		return
	end
	local pData = GetUserData(go)
	if not pData then
		return
	end

	local userData 		= {}
	userData.whoShow 	= gameObject.name
	userData.rseat 		= pData.seat
	userData.mySeat		= mySeat;
	userData.nickname 	= pData.name
	userData.icon 		= pData.icon
	userData.sex 		= pData.sex
	userData.ip 		= pData.ip
	userData.userId 	= pData.id
	userData.balance 	= pData.balance
	userData.address 	= pData.address
	userData.imgUrl 	= pData.imgUrl
	userData.gameType	= proxy_pb.DTZ;
	userData.signature 	= pData.signature
	userData.sendMsgAllowed = roomData.setting.sendMsgAllowed
    userData.fee = pData.fee
	userData.isShowSomeID = false
	userData.gameMode = roomData.setting.gameMode
	PanelManager.Instance:ShowWindow('panelPlayerInfo', userData)
end

function this.SetSelectCard(chooseData)
	--print("SetSelectCard was called,cards.length:"..#chooseData.cards);
	for i = 1, #chooseData.cards do
		--print(' cards vaule：'.. chooseData.cards[i].value);
	end
	local grid = this.IsGridInNeedCenter() and playerGridInCenter[0] or playerGridIn[0];


	for i = 0, grid.childCount - 1 do
		local card = grid:GetChild(i);
        this.SetCardSelectState(card.gameObject,false);
	end

	for i = 1, #chooseData.cards do
		for j = 0, grid.childCount-1 do
			local card = grid:GetChild(j);
			local cardData = GetUserData(card.gameObject);

			if cardData.db_id == chooseData.cards[i].db_id  then
                this.SetCardSelectState(card.gameObject,true);
				break;
			end
		end
	end
end

function this.ResetHelpData()
	helpOutCardsIndex = 1;

end

--点击提示
function this.OnClickButtonHelp(go)
	AudioManager.Instance:PlayAudio('btn')
	this.OnClickBG(onClickWidget.gameObject);

	local chooseCardsOrgionTable = nil;
	local isThrowAll = false;
	--print("roomData.latestHand.cards.length:"..#roomData.latestHand.cards);
	if  roomData.activeSeat == mySeat and currentPlayState == dtz_pb.PLAYER_GEN then -- 玩家可以要的上牌
		chooseCardsOrgionTable = dtz_Logic.GetViableChooseCards(this.ProcessCard(roomData.latestHand.cards),roomData.latestHand.category,roomData.setting.cardCount,roomData.latestHand.keyCardCount);
		--看能否一次性出完牌
		isThrowAll = dtz_Logic.IsCanThrowAllByPlane(this.ProcessCard(roomData.latestHand.cards),roomData.setting.cardCount ,false,roomData.latestHand.category);
	elseif   roomData.activeSeat == mySeat and currentPlayState == dtz_pb.PLAYER_PLAY then
		chooseCardsOrgionTable = dtz_Logic.GetViableAllChooseCards(roomData.setting.cardCount);
		--看能否一次性出完牌
		isThrowAll = dtz_Logic.IsCanThrowAllByPlane(nil,roomData.setting.cardCount,false,roomData.latestHand.category)
	end
	local chooseCardsData = dtz_Logic.GenerateChooseCardsData(chooseCardsOrgionTable,roomData.setting.san,roomData.setting.cardCount == 4);
	--print("isThrowAll:"..tostring(isThrowAll));
	if  roomData.setting.san and isThrowAll and  currentPlayState == dtz_pb.PLAYER_PLAY then
		table.insert(chooseCardsData,1,{cards=dtz_Logic.GetCardsDB()});
	end
	local chooseData = nil;
	if chooseCardsData and #chooseCardsData>0 then
		if helpOutCardsIndex > #chooseCardsData then
			helpOutCardsIndex = 1;
		end
		if helpOutCardsIndex <= #chooseCardsData then
			chooseData = chooseCardsData[helpOutCardsIndex];
			helpOutCardsIndex = helpOutCardsIndex + 1;
		end
	else
		panelMessageTip.SetParamers('没有大的过上家的牌', 1);
		PanelManager.Instance:ShowWindow('panelMessageTip');
		return;
	end

	this.SetSelectCard(chooseData);
	currentChooseCardsData = chooseData;

end


function this.SelectCardType()
	
end

function this.OnClickButtonPlay(go)
	AudioManager.Instance:PlayAudio('btn')

	local selectCards, selectCardDatas =this.getSelectCards();
	--判断是否会拆除地炸，喜，筒子，炸弹等
	local judgeCards 	= selectCardDatas;
	local breakData 	= dtz_Logic.GetBreakData(judgeCards,roomData.setting.cardCount);

	local tip = "";
	local breakKeys = {};
	for i = 1, #breakData do
		if not breakKeys[breakData[i].breakOP] then
			breakKeys[breakData[i].breakOP] = breakData[i];
		end
	end

	for key, value in pairs(breakKeys) do
		tip = tip .. dtz_Logic.GetBreakString(key)..",";
	end

	if #breakData > 0 then
		panelMessageBox.SetParamers(CANCLE_OK,
				function ()
					this.SendCardsPlay();
					breakData = nil;
					breakKeys = {};
				end,
				function()
					breakData = nil;
					breakKeys = {};
				end,
				"要出的牌将会"..tip.."是否确认出牌？");
		PanelManager.Instance:ShowWindow('panelMessageBox');
	else
		this.SendCardsPlay();
	end
end


function this.SendCardsPlay()


	local selectCards, selectCardDatas =this.getSelectCards();
	if #selectCards == 0 then
		return
	end
	if #selectCardDatas >3 and #selectCardDatas <=5 then
		if not roomData.setting.san and dtz_Logic.IsSanDai(selectCardDatas)  then--如果没有勾选三带，那么就不能出三带的牌
			this.OnPlayError();
		end
	end
	---if canOutCard then
	local msg = Message.New();
	msg.type = dtz_pb.PLAY;
	local b = dtz_pb.PPlay();
	for i = 1, #selectCardDatas do
		table.insert(b.cards, selectCardDatas[i].trueValue)
	end

	tableClear(mySelectCards);
	tableAdd(mySelectCards,selectCards);
	--this.RepositionGridIn();
	--print("send cards to servers,length:"..(#b.cards));
	--for i = 1, #selectCardDatas do
	--	print("send to server card["..i.."]"..selectCardDatas[i].value);
	--end
	msg.body = b:SerializeToString();
	SendGameMessage(msg, nil);
	ShowCardTip.gameObject:SetActive(false);
	currentChooseCardsData = nil;
end

function this.HideSelectCards()
	for i = 1, #mySelectCards do
		this.SetCardSelectState(mySelectCards[i].gameObject,false);
		mySelectCards[i].gameObject:SetActive(false);
	end
end

function this.OnClickOnButtonPass()
	if roomData.setting.guan then

		if roomData.activeSeat == mySeat and currentPlayState == dtz_pb.PLAYER_GEN then
			panelMessageTip.SetParamers('有牌必管，不能pass', 1);
			PanelManager.Instance:ShowWindow('panelMessageTip');
			return;
		end
	end
	local msg = Message.New();
	msg.type = dtz_pb.PASS;
	SendGameMessage(msg, nil);
	ShowCardTip.gameObject:SetActive(false);
end

function this.OnMousePressHoverCard(go)
	--print("OnMousePressHoverCard was called");
	this.OnClickCard(go, false)
end

function this.OnSendChat(msg)
	print('')
	local b = dtz_pb.RChat()
	b:ParseFromString(msg.body)

	local index = this.GetUIIndex(this.GetUIIndexBySeat(b.seat),playerSize);
	if b.type == 0 then --图片
		this.showEmoji(index, b.position)
	elseif b.type == 1 then -- 语音文本
		--print("b.seat6666666666666666666666",b.seat)
		local p = this.GetPlayerDataByUIIndex(this.GetUIIndexBySeat(b.seat))
        this.playVoice(string.format('chat_%d_%d', p.sex, b.position))
        this.showText(index, b.text)
	else --纯文本
		this.showText(index, b.text)
		local p = this.GetPlayerDataByUIIndex(this.GetUIIndexBySeat(b.seat))
        if panelChat then
            panelChat.AddChatToLabel(p.name .. ':' .. b.text)
        else
            table.insert(this.chatTexts, p.name .. ':' .. b.text)
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
		playerMsg[seat]:Find("MsgLabel"):GetComponent('UILabel').text = text;
		playerMsg[seat]:Find("MsgLabel"):GetComponent('UILabel').color = Color(244/255,244/255,244/255)
		playerEmoji[seat].gameObject:SetActive(false);
		coroutine.wait(5)
		playerMsg[seat].gameObject:SetActive(false);
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
    if  roomData.setting.sendVoiceAllowed then
		if state == true then
			--print('说话')
			this.startTalk()
		else
			--print('松开')
			local mousePositionY = UnityEngine.Input.mousePosition.y
			local buttonY = UnityEngine.Screen.height / 2 + (go.transform.localPosition.y * UnityEngine.Screen.height / 750)
			local buttonHeight = 3 * UnityEngine.Screen.height / 50
			--print('UnityEngine.Input.mousePosition.y=' .. mousePositionY)
			--print('button.y==' .. buttonY)
			--print('按钮高度' .. buttonHeight)
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
        --print("这里开始录制语音！！！！！！");
        NGCloudVoice.Instance:Click_btnStartRecord();
    end
end
--[[    @desc: 开始说话
    author:{author}
    time:2018-09-12 16:58:48
    @return:
]]
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
		--print("这里开始上传录制完后的语音！！！！！！");
	end
end

function this.UploadReccordFileComplete(fileid)
    --print('发送给服务器' .. fileid)
    local msg = Message.New()
    msg.type = dtz_pb.VOICE_MEMBER
    local body = dtz_pb.PVoiceMember()
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
    --print('下载完成' .. fileid);
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
            --print('有相等的' .. fileid)
            playerSound[i].gameObject:SetActive(false)
        end
    end

end
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
	local b = dtz_pb.RVoiceMember()
	b:ParseFromString(msg.body)
	local player = this.GetPlayerDataBySeat(b.seat);
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
        network:MakePixelPerfect();
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
		pingLabel.text = Util.GetTime() - connect.LastHeartBeatTime
	else 
		pingLabel.text =  ''
	end
end
function this.OnClicButtonDisbandRoom()
    local msg = Message.New()
    msg.type = dtz_pb.DISSOLVE
    local body = dtz_pb.PDissolve()
    body.decision = dtz_pb.APPLY
    msg.body = body:SerializeToString()
    SendGameMessage(msg, nil)
end
function this.OnClickButtonCloseRoom(go)
	--print("OnClicButtonCloseRoom was called");
	if this.GetPlayerDataBySeat(mySeat).id == roomData.ownerId then--我是房主
		--print("申请解散房间")
		AudioManager.Instance:PlayAudio('btn')
		local msg 		= Message.New()
		msg.type 		= dtz_pb.DISSOLVE
		local body 		= dtz_pb.PDissolve()
		body.decision 	= 0;
		msg.body 		= body:SerializeToString();
		SendGameMessage(msg, nil)
	else
		--print("离开房间")
		AudioManager.Instance:PlayAudio('btn')
		local msg = Message.New()
		msg.type = dtz_pb.LEAVE_ROOM
		SendGameMessage(msg, nil)
	end
	this.fanHuiRoomNumber = nil
end

function this.OnClickButtonLeaveRoom(go)
	AudioManager.Instance:PlayAudio('btn')
    --local msg = Message.New()
    --msg.type = dtz_pb.LEAVE_ROOM
	--SendGameMessage(msg, nil)
	--print('返回大厅')
    --print(mySeat)                                   --房主在lobby退出可以返回，房间留存
    if roomData.clubId == '0' then
        --print('不在在牌友群中')
        this.SetMyAlpha(0)
        PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
        panelMessageTip.SetParamers('返回大厅后，您的房间将会继续保留哦', 1)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	else
        --print('在牌友群中')
        this.SetMyAlpha(0)
        PanelManager.Instance:ShowWindow('panelClub',{name = gameObject.name})
        panelMessageTip.SetParamers('返回俱乐部后，您的房间将会继续保留哦', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
    end
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
	msg = msg..GetDTZRuleString(roomData.setting,false,true);
	--print("复制的信息",msg)
    Util.CopyToSystemClipbrd(msg)
    panelMessageTip.SetParamers('复制成功', 1.5)
    PanelManager.Instance:ShowWindow('panelMessageTip')
end
function this.OnClickButtonXLInvite(go)
	local msg = '房号：' .. roomInfo.roomNumber .. '，'

	--print("分享闲聊信息",msg)
	local que = roomData.setting.size - (#playerData)
	local title = roomInfo.roomNumber.."房,"..roomData.playName..roomData.setting.size.."缺"..que;
    PlatformManager.Instance:ShareLinkToXL('http://'..panelLogin.HttpUrl..'/share/xl/jionRoom.html?roomId='..roomInfo.roomNumber..'&gameType='..proxy_pb.DTZ..'&appType=1', title, msg);
end
function this.GetRedBagReocrdCount()
    local msg = Message.New()
	msg.type = proxy_pb.ACTIVITY_REWARD_RECORD
    local body = proxy_pb.PActivityRewardRecord()
    body.startTime = os.time()
    body.endTime = os.time()
    msg.body = body:SerializeToString();
    -- print("开红包",body.clubId,body.sourceId)
	SendProxyMessage(msg, this.HowRecord)
end
function this.HowRecord(msg)
    local b = proxy_pb.RActivityRewardRecord()
    b:ParseFromString(msg.body)
    print("记录",b.count)
    if b.count == 0 then
        --redbagrecord.gameObject:SetActive(false)
    else
        --redbagrecord.gameObject:SetActive(true)
    end
end

function this.NotifyGameStart()
	--通知玩家返回游戏
	if #playerData == (roomData.setting.size) and roomData.round == 1 and roomData.state ~= phz_pb.GAMING then
		if this.OnRoundStarted ~= nil then
			this.OnRoundStarted()
		end
	end
end

function this.IsAllReaded()
    if roomData.setting.size == #playerData  then
        for i=1,#playerData do
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
function this.setPai(item,mycard)
	local t 		= item.transform:Find('type');
	local tSmall 	= item.transform:Find('typeSmall');
	local king1 	= item.transform:Find('king1')
	local king2 	= item.transform:Find('king2')
	local num 		= item.transform:Find('num');


	tSmall.gameObject:SetActive(false)
	king1.gameObject:SetActive(false)
	king2.gameObject:SetActive(false)
	num.gameObject:SetActive(false)
	t.gameObject:SetActive(false)
	SetUserData(item.gameObject, mycard);
	if mycard.trueValue == nil then
	end
	if mycard.trueValue < 52 then
		local strType
		local col = Color.white
		if mycard.type == 0 then
			strType='DiamondIcon1'
			col = Color.white
		elseif mycard.type == 1 then
			strType='ClubIcon'
			col.r = 51/255
			col.g = 52/255
			col.b = 57/255
		elseif mycard.type == 2 then
			strType='HeartIcon1'
			col = Color.white
		elseif mycard.type == 3 then
			strType='SpadeIcon'
			col.r = 51/255
			col.g = 52/255
			col.b = 57/255
		end
		if dtz_Logic.IsJocker(mycard) then
			king1:GetComponent("UISprite").spriteName = dtz_Logic.IsRedJocker(mycard) and "bJoker_1" or "xJoker_1"
			king1.gameObject:SetActive(true)
			king2:GetComponent("UISprite").spriteName = dtz_Logic.IsRedJocker(mycard) and "bJoker_2" or "xJoker_2"
			king2.gameObject:SetActive(true)
		else
			t.gameObject:SetActive(true)
			t:GetComponent('UISprite').spriteName		=tostring(strType);
			tSmall.gameObject:SetActive(true)
			tSmall:GetComponent('UISprite').spriteName	=tostring(strType);
			num.gameObject:SetActive(true)
			num:GetComponent('UISprite').spriteName 	= this.GetCardTypeString(mycard);
			num:GetComponent('UISprite').color=col

		end
	end
end

function this.SetMyGridInType(item)
	local t 		= item.transform:Find('type');
	local num 		= item.transform:Find('num');

	if dtzPlateType == 0 then
		num:GetComponent("UISprite").width = 41;
		num:GetComponent("UISprite").height = 49;
		t.localPosition = Vector3.New(-32.8,9.2,0);
		num.localPosition = Vector3.New(-31,51.4,0);
	elseif dtzPlateType == 1 then
		num:GetComponent("UISprite").width = 44;
		num:GetComponent("UISprite").height = 53;
		num.localPosition = Vector3.New(-33.2,47.1,0);
		t.localPosition = Vector3(-33.8,8.6,0);
	elseif dtzPlateType == 2 then
		num:GetComponent("UISprite").width = 40;
		num:GetComponent("UISprite").height = 48;
		num.localPosition = Vector3.New(-33,51.4,0);
		t.localPosition = Vector3.New(-33.8,16.5,0);
	end
end

function this.SetOutGridType(item)
	local t 		= item.transform:Find('type');
	local num 		= item.transform:Find('num');
	local bg 		= item.transform:Find('bg');

	if dtzPlateType == 0 then
		num:GetComponent("UISprite").width = 55;
		num:GetComponent("UISprite").height = 66;
		num.localPosition = Vector3.New(-44,75.3,0);
		t.localPosition = Vector3.New(-44.6,20.3,0);
	elseif dtzPlateType == 2 then
		num:GetComponent("UISprite").width = 58;
		num:GetComponent("UISprite").height = 70;
		num.localPosition = Vector3.New(-42.3,76.6,0);
		t.localPosition = Vector3.New(-44.2,29.2,0);
	elseif dtzPlateType == 1 then
		num:GetComponent("UISprite").width = 64;
		num:GetComponent("UISprite").height = 77;
		num.localPosition = Vector3.New(-43.5,71.9,0);
		t.localPosition = Vector3.New(-44.5,19.3,0);

	end
	bg:GetComponent("UISprite").width = 182;
end

function this.GetCardTypeString(mycard)
	local typeString = "";
	if dtz_Logic.IsJocker(mycard) then
	else
		if dtzPlateType == 1 or dtzPlateType == 2 then
			typeString = 'card_'..mycard.value.."_1";
		else
			typeString = 'card_'..mycard.value
		end
	end
	return typeString;
end

--设置牌的depth
function this.setCardDepth(cardObj,depth)
	local t 		= cardObj.transform:Find('type');
	local tSmall 	= cardObj.transform:Find('typeSmall');
	local king1 		= cardObj.transform:Find('king1');
	local king2 		= cardObj.transform:Find('king2');
	local num 		= cardObj.transform:Find('num');
	local bg		= cardObj.transform:Find("bg");
	local xiordiZha = cardObj.transform:Find('xiordiZha');
	local tongzi 	= cardObj.transform:Find('tongzi');

	dtz_Logic.SetSpriteDepth(t:GetComponent("UISprite"),		depth+1);
	dtz_Logic.SetSpriteDepth(tSmall:GetComponent("UISprite"),	depth+1);
	dtz_Logic.SetSpriteDepth(king1:GetComponent("UISprite"),		depth+1);
	dtz_Logic.SetSpriteDepth(king2:GetComponent("UISprite"),		depth+1);
	dtz_Logic.SetSpriteDepth(num:GetComponent("UISprite"),		depth+1);
	dtz_Logic.SetSpriteDepth(bg:GetComponent("UISprite"),		depth-1);
	dtz_Logic.SetSpriteDepth(xiordiZha:GetComponent("UISprite"),depth);
	dtz_Logic.SetSpriteDepth(xiordiZha:Find("Sprite"):GetComponent("UISprite"),depth+1);
	dtz_Logic.SetSpriteDepth(tongzi:GetComponent("UISprite"),	depth);
	dtz_Logic.SetSpriteDepth(tongzi:Find("Sprite"):GetComponent("UISprite"),depth+1);


end
--分析数据
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
--获取多张同值的牌型
function this.getMultipleCards(num,myList)
	local cardsGroup={}
	for i=5,15 do
		if myList[i] then
			if myList[i].num==num then
				table.insert(cardsGroup,myList[i])
			end
		end
	end
	return cardsGroup
end
--初始化手牌
function this.initCardGroup(grid)
	for i=0,grid.childCount-1 do 
		local card = grid:GetChild(i)
		card.gameObject:SetActive(false)
	end
end
--初始化出牌仓
function this.initOutCardGroup(grid)
	for i=0,grid.childCount-1 do
		grid:GetChild(i).gameObject:SetActive(false)
	end
end

--初始化所有出仓牌
function this.InitAllOutCardGroup()
	for i = 0, roomData.setting.size-1 do
		playerGridOut[this.GetUIIndex(i,playerSize)].gameObject:SetActive(false);
	end
end




local baseInCardDepth = 44;
--给手牌賦值
function this.refreshCardsValues(cardList, grid)
	--print("refreshCardsValues----->");
	if #cardList <= inCardColumLimit then
		local depth = baseInCardDepth;
		for i = 1, #cardList do
			local card = nil;
			if i <= grid.childCount then
				card = grid.transform:GetChild(i-1).gameObject;
			else
				card = NGUITools.AddChild(grid.gameObject, InCardItemPrefab.gameObject);
				message:AddClick(card,this.OnClickCard);
                message:AddEventTrigger(card, this.OnMousePressHoverCard);
			end
			this.setPai(card,cardList[i]);
			this.SetMyGridInType(card);
			this.setCardDepth(card,depth);
			card.gameObject:SetActive(true);
			depth  = depth + 5;
		end

		--隐藏不需要的
		for i = #cardList, grid.childCount-1 do
			grid.transform:GetChild(i).gameObject:SetActive(false);
		end
	else
		local depth = baseInCardDepth;
		--第一排
		for i = 1, inCardColumLimit do
			local card = nil;
			if i <= grid.childCount then
				card = grid.transform:GetChild(i-1).gameObject;
			else
				card = NGUITools.AddChild(grid.gameObject, InCardItemPrefab.gameObject);
				message:AddClick(card,this.OnClickCard);
				--message:AddEventTrigger(card, this.OnMousePressHoverCard);

			end
			this.setPai(card,cardList[i]);
			this.SetMyGridInType(card);
			this.setCardDepth(card,depth);
			card.gameObject:SetActive(true);
			depth = depth + 5;
		end

		--第二排
		depth = baseInCardDepth -20;
		for i = inCardColumLimit + 1, #cardList do
			local card = nil;
			if i <= grid.childCount then
				card = grid.transform:GetChild(i-1).gameObject;
			else
				card = NGUITools.AddChild(grid.gameObject, InCardItemPrefab.gameObject);
				message:AddClick(card,this.OnClickCard);
				--message:AddEventTrigger(card, this.OnMousePressHoverCard);

			end
			this.setPai(card,cardList[i]);
			this.SetMyGridInType(card);
			this.setCardDepth(card,depth);
			card.gameObject:SetActive(true);
			depth = depth + 5;
		end

		--隐藏不显示的牌
		for i = #cardList, grid.childCount-1 do
			local card = grid.transform:GetChild(i);
			card.gameObject:SetActive(false);
		end
	end

	--全部置为未选择状态
	for i = 0, grid.childCount-1 do
		local card = grid.transform:GetChild(i);
		SetUserData(card:Find("bg").gameObject,false);
	end


	--标记地炸，筒子和喜牌，用颜色标记
	this.MarkSpecialByColor(grid);

	grid:GetComponent("UIGrid"):Reposition();
end

--刷新手牌，居中对齐的那种
function this.CenterRefreshCardsValues(cardList, grid)

	local depth = baseInCardDepth;
	for i = 1, #cardList do
		local card = nil;
		if i <= grid.childCount then
			card = grid.transform:GetChild(i-1).gameObject;
		else
			card = NGUITools.AddChild(grid.gameObject, InCardItemPrefab.gameObject);
			message:AddClick(card,this.OnClickCard);
			--message:AddEventTrigger(card, this.OnMousePressHoverCard);
		end
		this.setPai(card,cardList[i]);
		this.SetMyGridInType(card);
		this.setCardDepth(card,depth);
		card.gameObject:SetActive(true);
		depth  = depth + 5;
	end

	--全部置为未选择状态
	for i = 0, grid.childCount-1 do
		local card = grid.transform:GetChild(i);
		SetUserData(card:Find("bg").gameObject,false);
		SetUserData(card:Find("typeSmall").gameObject,i+1);
	end

	--标记地炸，筒子和喜牌，用颜色标记
	this.MarkSpecialByColor(grid);

	grid:GetComponent("UIGrid"):Reposition();

end

--用颜色标记地炸，筒子和喜
function this.MarkSpecialByColor(grid)
	local allTongzi 	= {};
	local allDiBombs 	= {};
	local allXi 		= {};
	if roomData.setting.cardCount == 3 then
		 allDiBombs 	= dtz_Logic.GetAllDiBombs();
	else
		 allXi 			= dtz_Logic.GetAllXi();
	end
	allTongzi 			= dtz_Logic.GetAllTongzi();
	--先把所有牌变成普通牌
	for i = 1, grid.childCount do
		local cardItem = grid:GetChild(i-1);
		if cardItem.gameObject.activeSelf then
			cardItem:Find("xiordiZha").gameObject:SetActive(false);
			cardItem:Find("tongzi").gameObject:SetActive(false);
		end
	end
	for i = 1, grid.childCount do
		local cardItem = grid:GetChild(i-1);
		if cardItem.gameObject.activeSelf then
			local card = GetUserData(cardItem.gameObject);
			--设置筒子牌的颜色
			for j = 1, #allTongzi do
				local canSet = true;
				--不能存在于喜中
				for k = 1, #allXi do
					if dtz_Logic.IsFindInTable(allXi[k],card,"db_id") then
						canSet = false;
						--print("allXi,can't set....db_id:"..card.db_id.."|value:"..card.value);
						break;
					end
				end
				--不能存在于地炸中
				for k = 1, #allDiBombs do
					if dtz_Logic.IsFindInTable(allDiBombs[k],card,"db_id") then
						canSet = false;
						--print("allDiBombs,can't set....db_id:"..card.db_id.."|value:"..card.value);

						break;
					end
				end
				if canSet and dtz_Logic.IsFindInTable(allTongzi[j],card,"db_id") then
					cardItem:Find("tongzi").gameObject:SetActive(true);
				end
			end
			--设置喜牌颜色
			for j = 1, #allXi do
				if dtz_Logic.IsFindInTable(allXi[j],card,"db_id") then
					cardItem:Find("xiordiZha").gameObject:SetActive(true);
				end
			end
			--设置所有地炸颜色
			for j = 1, #allDiBombs do
				if dtz_Logic.IsFindInTable(allDiBombs[j],card,"db_id") then
					cardItem:Find("xiordiZha").gameObject:SetActive(true);
				end
			end

		end
	end

end

--给出牌赋值
function this.RefreshOutCards(mainCards,slaveCards,grid,layOutTable)

	--1.隐藏的
	for i = 1, #layOutTable.hideIndexs do
		grid.transform:GetChild(layOutTable.hideIndexs[i]-1).gameObject:SetActive(false);
	end

	--2.主牌
	for i = 1, #layOutTable.outCardIndex do
		local cardObj = grid.transform:GetChild(layOutTable.outCardIndex[i]-1).gameObject;
		cardObj:SetActive(true);
		this.setPai(cardObj,mainCards[i]);
		this.SetOutGridType(cardObj);
	end
	--3.带的牌
	for i = 1, #layOutTable.withCardsIndexs do
		local withCardObj = grid.transform:GetChild(layOutTable.withCardsIndexs[i]-1).gameObject;
		withCardObj:SetActive(true);
		this.setPai(withCardObj,slaveCards[i]);
		this.SetOutGridType(withCardObj);

	end
	--

end

--刷新出的牌
function this.RefreshOutGrid(grid, hand,seat)
	--print("RefreshOutGrid refreshGrid name "..grid.name..' card num:'..#hand.cards)
	this.initOutCardGroup(grid)--初始化出牌仓
	local afterProscessCards = this.ProcessCard(hand.cards);
	local mainCards,slaveCards = dtz_Logic.SeperateMainAndSlave(afterProscessCards,hand.category,roomData.setting.cardCount,hand.keyCardCount);
	local layOutTable = dtz_Logic.GetOutGridLayOut(outCardColumLimit,cutlimit,mainCards,slaveCards,this.GetUIIndex(this.GetUIIndexBySeat(seat),playerSize));
	this.RefreshOutCards(mainCards,slaveCards,grid,layOutTable)--给出牌赋值
end

function this.InitOutGridDepths()
	print()
	local baseDepth = 7;
	for i = 0, 3 do
		local grid = playerGridOut[i];
		for j = 1, outCardColumLimit do
			local item = grid:GetChild(j-1);
			item.transform:Find('type'):GetComponent("UISprite").depth 		= baseDepth + j*2;
			item.transform:Find('typeSmall'):GetComponent("UISprite").depth 	= baseDepth + j*2;
			item.transform:Find('king1'):GetComponent("UISprite").depth 		= baseDepth + j*2;
			item.transform:Find('king2'):GetComponent("UISprite").depth 		= baseDepth + j*2;
			item.transform:Find('num'):GetComponent("UISprite").depth 			= baseDepth + j*2;
			item.transform:Find('bg'):GetComponent("UISprite").depth 			= baseDepth + j*2 -1;
		end

		for j = outCardColumLimit + 1, 2* outCardColumLimit do
			local item = grid:GetChild(j-1);
			item.transform:Find('type'):GetComponent("UISprite").depth 		= baseDepth + (j-outCardColumLimit-5)*2;
			item.transform:Find('typeSmall'):GetComponent("UISprite").depth 	= baseDepth + (j-outCardColumLimit-5)*2;
			item.transform:Find('king1'):GetComponent("UISprite").depth 		= baseDepth + (j-outCardColumLimit-5)*2;
			item.transform:Find('king2'):GetComponent("UISprite").depth 		= baseDepth + (j-outCardColumLimit-5)*2;
			item.transform:Find('num'):GetComponent("UISprite").depth 			= baseDepth + (j-outCardColumLimit-5)*2;
			item.transform:Find('bg'):GetComponent("UISprite").depth 			= baseDepth + (j-outCardColumLimit-5)*2 -1;
		end


	end
end
--刷新自己手牌

function this.RefreshGrid(grid, cards)
	--print("RefreshGrid refreshGrid name "..grid.name..' card num:'..#cards)
	local cardList = this.ProcessCard(cards)--分析数据  存到该表
	local args = {};
	args.cardCount 			= roomData.setting.cardCount;
	args.needCombination 	= NeedCombination;
	args.isWithPlate		= roomData.setting.san;
	cardList = dtz_Logic.InitDB(cardList,args);
	this.initCardGroup(grid)--初始化手牌
	if #cards <= overCenterCardCount then
		this.CenterRefreshCardsValues(cardList,grid);
	else
		this.refreshCardsValues(cardList,grid)--给手牌复制
	end



end

--检测牌是否已经选择了
function this.CardBeenSelected(go)

	if not go then
		return false;
	end

	local isSelected = GetUserData(go.transform:Find("bg").gameObject);

	if not isSelected then
		return false;
	else
		return isSelected;
	end

end

--设置牌的选择状态
function this.SetCardSelectState(go,state)
	if not go then
		return;
	end;

	local isSelected = GetUserData(go.transform:Find("bg").gameObject);
	--1.这张牌还没有被设置过
	if isSelected == nil then
		SetUserData(go.transform:Find("bg").gameObject,state);
		if state then
			local pos = go.transform.localPosition;
			pos.y = pos.y + clickMoveDistance;
			go.transform.localPosition = pos;
		end
		--这张牌以前被设置过
	else
		if isSelected then
			--对于选择状态只处理将牌置为未选择状态
			if not state then
				local pos = go.transform.localPosition;
				pos.y = pos.y - clickMoveDistance;
				go.transform.localPosition = pos;
			end
			SetUserData(go.transform:Find("bg").gameObject,state);

		else
			--对于未选择状态值处理将牌置为选择状态
			if state then
				local pos = go.transform.localPosition;
				pos.y = pos.y + clickMoveDistance;
				go.transform.localPosition = pos;
			end
			SetUserData(go.transform:Find("bg").gameObject,state);
		end
	end
end
--点击牌
function this.OnClickCard(go, hoverCard)
	if hoverCard then

	else
		AudioManager.Instance:PlayAudio('touchcard');
	end

	local sprite = go.transform:Find('bg'):GetComponent('UISprite');

	if this.CardBeenSelected(go) then
		this.SetCardSelectState(go,false);
	else
		this.SetCardSelectState(go,true);
	end

end
--点击桌面清空选择的牌以及展开的牌
function this.OnClickBG(go)
	if roomData.state == dtz_pb.GAMING then
		this.RefreshMyGridIn();
	end
	--print('清空了')
end
--获得选择的牌的对象和值的集合 
function this.getSelectCards()
	local cards = {}
	local cardValues = {}

	local selectGrid = this.IsGridInNeedCenter() and playerGridInCenter[0] or playerGridIn[0];

	for i=0,selectGrid.childCount-1 do
		local cardObj = selectGrid:GetChild(i);
		if cardObj.gameObject.activeSelf and this.CardBeenSelected(cardObj.gameObject) then
			table.insert(cards,cardObj.gameObject);
			table.insert(cardValues,GetUserData(cardObj.gameObject));
		end
	end
	return cards,cardValues;
end

--手牌是否需要居中
function this.IsGridInNeedCenter()
	return #(this.GetPlayerDataBySeat(mySeat).cards) <= overCenterCardCount;
end


--获得服务器历史得分，本局抓分，喜得分
function this.OnGetBonusScore(msg)
	--print("OnGetBonusScore was called------>")
	local data = dtz_pb.RBonusScoreList();
	--print('角历史得分，本局抓分，喜得分')
	data:ParseFromString(msg.body);
	this.RefreshBonusScore(data);

end
local grabScoreAudio = -1;
--更新历史得分，本局抓分，喜得分
function this.RefreshBonusScore(data)
	--print("RefreshBonusScore was called");
	if #data.bonusScores ==0 or data == nil then
		--print("invalid data in RefreshBonusScore !");
		return;
	end

	for i = 1, #data.bonusScores do
		local initItem = playerBonusScores[data.bonusScores[i].seat];
		initItem.gameObject:SetActive(true);
		initItem:Find("history"):GetComponent("UILabel").text 			= data.bonusScores[i].historyTotalScore;
		initItem:Find("now"):GetComponent("UILabel").text 				= data.bonusScores[i].roundGrab;
		--播放抓分动画
		if data.grab and data.seat == data.bonusScores[i].seat then
			local tw 	= initItem:Find("now"):GetComponent("TweenPosition");
			local twl 	= initItem:Find("now"):GetComponent("UILabel");
			local pos 	= initItem:Find("now").localPosition;
			tw.enabled 	= true;
			twl.color 	= Color.red;
			StartCoroutine(function ()
				WaitForSeconds(2);
				tw.enabled = false;
				twl.color = Color.white;
				initItem:Find("now").localPosition = pos;
			end);

		end
		initItem:Find("happyScore"):GetComponent("UILabel").text 	= (data.bonusScores[i].cyclesScore + data.bonusScores[i].deepScore + data.bonusScores[i].happlyScore);
	end

	if data.grab then
		--玩家抓分
		local index = this.GetUIIndex(this.GetUIIndexBySeat(data.seat),playerSize);
		playerScore[index]:GetComponent("UILabel").text = data.grabPlayer;

		--牌桌清空
		currentDeskScore:Find("5ScoreNum"):GetComponent("UILabel").text 		= "0";
		currentDeskScore:Find("10ScoreNum"):GetComponent("UILabel").text 		= "0";
		currentDeskScore:Find("kScoreNum"):GetComponent("UILabel").text 		= "0";
		currentDeskScore:Find("totalScoreNum"):GetComponent("UILabel").text 	= "0";
		this.PlayerAddScroeAudio();

	end
	if data.bonus then
		this.PlayerAddScroeAudio();
	end
end

function this.PlayerAddScroeAudio()
	StartCoroutine(function ()
		WaitForSeconds(0.6);
		AudioManager.Instance:PlayAudio('addScore');
	end);
end


function this.SetBonusLayOut(playerSize)

	local bg 			= scoreView:Find("allScore");
	local grid 			= scoreView:Find("allScore/playerGrid");
	local finalHeight 	= 0;
	if playerSize == 4 then
		finalHeight = 30 + grid:GetComponent("UIGrid").cellHeight*2;
	else
		finalHeight = 30 + grid:GetComponent("UIGrid").cellHeight*playerSize;
	end
	bg:GetComponent("UISprite").height = finalHeight;
end


--初始化历史得分，本局抓分，喜得分
function this.InitBonusScore()
	--print("InitBonusScore was called--------------------------------------->");
	if roomData.setting.cardCount == 3 then
		scoreView:Find("allScore/title/happyScore"):GetComponent("UILabel").text = "地炸/筒总分";
	elseif roomData.setting.cardCount == 4 then
		scoreView:Find("allScore/title/happyScore"):GetComponent("UILabel").text = "喜总分";
	elseif roomData.setting.cardCount == 5 then
		scoreView:Find("allScore/title/happyScore"):GetComponent("UILabel").text = "喜/筒总分";
	end

	for i = 0, 3 do
		playerBonusScores[i].gameObject:SetActive(false);
	end

	--如果时4人，那么分A,B组
	if playerSize == 4 then
		playerBonusScores[0].gameObject:SetActive(true);
		playerBonusScores[1].gameObject:SetActive(true);
		playerBonusScores[2].gameObject:SetActive(false);
		playerBonusScores[3].gameObject:SetActive(false);
		playerBonusScores[0]:Find("groupA").gameObject:SetActive(true);
		playerBonusScores[1]:Find("groupB").gameObject:SetActive(true);
		playerBonusScores[0]:Find("name").gameObject:SetActive(false);
		playerBonusScores[1]:Find("name").gameObject:SetActive(false);

		for i = 0, playerSize-1 do
			local initItem = playerBonusScores[i];
			initItem:Find("history"):GetComponent("UILabel").text 		= "0";
			initItem:Find("now"):GetComponent("UILabel").text 			= "0";
			initItem:Find("happyScore"):GetComponent("UILabel").text 	= "0";
		end

	else
		playerBonusScores[0]:Find("groupA").gameObject:SetActive(false);
		playerBonusScores[1]:Find("groupB").gameObject:SetActive(false);
		playerBonusScores[0]:Find("name").gameObject:SetActive(true);
		playerBonusScores[1]:Find("name").gameObject:SetActive(true);
		for i = 0, playerSize-1 do
			local initItem = playerBonusScores[i];
			local player = this.GetPlayerDataBySeat(i);
			initItem.gameObject:SetActive(true);
			initItem:Find("name"):GetComponent("UILabel").text 		= "";
			initItem:Find("history"):GetComponent("UILabel").text 		= "";
			initItem:Find("now"):GetComponent("UILabel").text 			= "";
			initItem:Find("happyScore"):GetComponent("UILabel").text 	= "";
			if player then

				initItem:Find("name"):GetComponent("UILabel").text 		= player.name;
				initItem:Find("history"):GetComponent("UILabel").text 		= "0";
				initItem:Find("now"):GetComponent("UILabel").text 			= "0";
				initItem:Find("happyScore"):GetComponent("UILabel").text 	= "0";
			end
		end
	end
	this.SetBonusLayOut(playerSize);
	scoreView:Find("allScore/playerGrid"):GetComponent("UIGrid"):Reposition();


end

--更新牌桌分数
function this.RefreshDeskScore(data)
	if not data then
		return
	end;
	currentDeskScore:Find("5ScoreNum"):GetComponent("UILabel").text 		= data.deskWu/5;
	currentDeskScore:Find("10ScoreNum"):GetComponent("UILabel").text 		= data.deskShi/10;
	currentDeskScore:Find("kScoreNum"):GetComponent("UILabel").text 		= data.deskKing/10;
	currentDeskScore:Find("totalScoreNum"):GetComponent("UILabel").text 	= data.deskWu + data.deskShi + data.deskKing ;

end

--初始化牌桌分数
function this.InitDeskScore(roomData)

	currentDeskScore:Find("5ScoreNum"):GetComponent("UILabel").text 		= roomData.wu/5;
	currentDeskScore:Find("10ScoreNum"):GetComponent("UILabel").text 		= roomData.shi/10;
	currentDeskScore:Find("kScoreNum"):GetComponent("UILabel").text 		= roomData.king/10;
	currentDeskScore:Find("totalScoreNum"):GetComponent("UILabel").text 	= roomData.wu + roomData.shi + roomData.king;

end

--房主点击开始游戏
function this.OnClickStartGameButton(go)
	--print("OnClickStartGameButton was called");
	local msg = Message.New();
	msg.type = dtz_pb.START_GAME;
	SendGameMessage(msg, nil);
	startGameButton.gameObject:SetActive(false);
end

function this.OnStartGameError(msg)
	panelMessageBox.SetParamers(ONLY_OK,nil,nil,"房间已经开始游戏");
	PanelManager.Instance:ShowWindow("panelMessageBox");

end

function this.OnStartGameWait(msg)
	panelMessageBox.SetParamers(ONLY_OK,nil,nil,"玩家正在交换座位,等待玩家交换完成");
	PanelManager.Instance:ShowWindow("panelMessageBox");
	startGameButton.gameObject:SetActive(true);
end

function this.RefreshStartGameState(enabledChange)
	--print("RefreshStartGameState was called");
	if playerSize == 4 then
		if this.IsAllReaded() and roomData.state ~= dtz_pb.GAMING and  roomData.round == 1 then
			startGameButton.gameObject:SetActive(this.GetPlayerDataBySeat( mySeat).id == roomData.ownerId);
			this.SetInviteVisiable(false);
		else
			startGameButton.gameObject:SetActive(false);
		end
	else
		startGameButton.gameObject:SetActive(false);
	end
end

-- 房间不能解散
function this.OnRoomCannotDissolve(msg)
	panelMessageBox.SetParamers(ONLY_OK,nil,nil,"房间设置为不能解散");
	PanelManager.Instance:ShowWindow("panelMessageBox");
end

-- 每局最大申请次数不能超过5次
function this.OnRoomDissolveLimit5(msg)
	panelMessageBox.SetParamers(ONLY_OK,nil,nil,"每局解散最大申请次数不能超过5次");
	PanelManager.Instance:ShowWindow("panelMessageBox");
end

-- 解散间隔不能小于5秒
function this.OnRoomDissolveIn5Seconds(msg)
	panelMessageBox.SetParamers(ONLY_OK,nil,nil,"房间申请解散间隔不能小于5秒");
	PanelManager.Instance:ShowWindow("panelMessageBox");
end

function this.OnAutoDissolve(msg)
    local body = dtz_pb.RAutoDissolve()
    body:ParseFromString(msg.body)
	PanelManager.Instance:ShowWindow('panelAutoDissolve', body)
    --print('----------------------------------自动解散了----------------------------------------')
end


function this.OnPlayerEmoji(msg)
	local b = dtz_pb.RGift()
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
	--print("b.rseat:"..b.rseat);
	--print("b.seat:"..b.seat);
	--print("uiindex:")
	if b.rseat ~= b.seat then
		coroutine.stop(playerEmojiCoroutine[this.GetUIIndex(this.GetUIIndexBySeat(b.seat),playerSize)])
		StartCoroutine(function()
			PanelManager.Instance:HideWindow('panelPlayerInfo');
			local positionFrom = playerIcon[this.GetUIIndex(this.GetUIIndexBySeat(b.seat),playerSize)].position;
			local positionTo = playerIcon[this.GetUIIndex(this.GetUIIndexBySeat(b.rseat),playerSize)].position;
			local animation =playerAnimation[this.GetUIIndex(this.GetUIIndexBySeat(b.seat),playerSize)];

			animation.gameObject:GetComponent('UISprite').spriteName 		= name
			animation.gameObject:GetComponent('UISprite'):MakePixelPerfect()
			animation.gameObject:GetComponent('TweenPosition').worldSpace 	= true
			animation.gameObject:GetComponent('TweenPosition').from 		= positionFrom
			animation.gameObject:GetComponent('TweenPosition').to 			= positionTo
			animation.gameObject:GetComponent('TweenPosition').duration 	= 1;
			animation.gameObject:GetComponent('TweenPosition'):ResetToBeginning();
			animation.gameObject:GetComponent('TweenPosition'):PlayForward();
			animation.gameObject:SetActive(true);
			coroutine.wait(1)
			if inx == 0 then
				coroutine.wait(2);
				animation.gameObject:SetActive(false);
			else
				local time = 0.1;
				if inx == 3 then
					time=0.2;
				end
				this.playEmoji(this.GetUIIndex(this.GetUIIndexBySeat(b.seat),playerSize),inx,name,time,soundName);
			end
		end)
	else
		return
	end
end

function this.playEmoji(myseatinx,index,name,time,soundName)
	playerEmojiCoroutine[myseatinx] = coroutine.start(function()
		AudioManager.Instance:PlayAudio(soundName);
		for i = 1, index do
			playerAnimation[myseatinx]:GetComponent('UISprite').spriteName = name..'_'..i;
			playerAnimation[myseatinx].gameObject:GetComponent('UISprite'):MakePixelPerfect();
			coroutine.wait(time);
		end
		playerAnimation[myseatinx].gameObject:SetActive(false);
	end)
end

function this.changePaiSize(dtzpaiSize)
	if roomData.state == dtz_pb.GAMING then
		dtzPlateType = dtzpaiSize;
		this.RefreshMyGridIn();
		this.OnPlayerHand(roomData.latestSeat, roomData.latestHand);
	end
end

function this.OnTrustesship(msg)
	local body = dtz_pb.RTrusteeship()
	body:ParseFromString(msg.body)
    --
	--print('-----------------------------------------有人托管了-------------------------------------------')
	--print('托管的位置：'..tostring(body.seat))
	--print('托管是否开启：'..tostring(body.enable))

	this.SetMyseflInTrustesship(body.seat, body.enable)

	local index = this.GetUIIndex(this.GetUIIndexBySeat(body.seat),playerSize)

	this.GetPlayerDataBySeat(body.seat).trusteeship = body.enable
	playerTrusteeship[index].gameObject:SetActive(body.enable)
end

function this.SetMyseflInTrustesship(seat, enable)
	if seat == mySeat then
		--this.SetCardDisable(not enable)
		TrusteeshipPanel.gameObject:SetActive(enable)
	end
end

function this.StartCheckTrusteeship(time)
	if TrusteeshipCoroutine then
		this.StopCheckTrusteeship()
	end

	TrusteeshipCoroutine = coroutine.start(this.CheckTrusteeship, time == 0 and nil or time)
end

local showDelayTime = 10
function this.CheckTrusteeship(time)

	if roomData.setting.trusteeship == nil 
		or roomData.setting.trusteeship == 0 or this.GetPlayerDataBySeat(mySeat).trusteeship then
		return 
	end
	
	if time == nil then
		time = roomData.setting.trusteeship
	end

	local delayTime = time - showDelayTime;
	--print('----------------------------------开始检测托管剩余：'..delayTime..'--------------------------------')
	coroutine.wait(delayTime)

	local doweTime = delayTime < 0 and time or showDelayTime

	--print('----------------------------------展示托管倒计时---------------------------------------')
	local timeLabel = TrusteeshipTip.transform:Find('Time')
	--if seat == mySeat then
	TrusteeshipTip.gameObject:SetActive(true)
	for i=doweTime, 1, -1 do
		timeLabel:GetComponent('UILabel').text = i
		coroutine.wait(1)
	end	

	this.StopCheckTrusteeship()
end


function this.StopCheckTrusteeship()
	--print('----------------------------------停止托管倒计时---------------------------------------')

	coroutine.stop(TrusteeshipCoroutine)
	TrusteeshipCoroutine = nil
	TrusteeshipTip.gameObject:SetActive(false)
end

function this.OnClickCancelTrustesship(go)
	local msg = Message.New()
	msg.type = dtz_pb.TRUSTEESHIP
	local body = dtz_pb.PTrusteeship()
	body.enable = false
	msg.body = body:SerializeToString();
	SendGameMessage(msg)
end

function this.StartOfflineIncrease(seat, startTime)
	this.StopOfflineIncrease(seat)
	--print('------------------有人离线，开始离线计时'..(seat)..'----------------------')

	local index = this.GetUIIndex(this.GetUIIndexBySeat(seat),playerSize)

	local offlineTime = playerOfflineTime[index];
	playerOfflineCoroutines[index] = coroutine.start(this.OfflineIncrease, offlineTime, startTime)
end

function this.OfflineIncrease(timeObj, startTime)
	local timeLabel = timeObj.transform:Find('Time'):GetComponent('UILabel');
	timeLabel.text = os.date("%M:%S", startTime);
	timeObj.gameObject:SetActive(true)

	while true do
		coroutine.wait(1);

		startTime = startTime + 1 
		timeLabel.text = os.date("%M:%S", startTime);
	end
end

function this.StopOfflineIncrease(seat)
	local index = this.GetUIIndex(this.GetUIIndexBySeat(seat),playerSize)

	local coroutines = playerOfflineCoroutines[index]

	if coroutines ~= nil then
		coroutine.stop(coroutines)
		coroutines = nil;
		--print('------------------取消离线倒计时'..(seat)..'----------------------')
	end

	playerOfflineTime[index].gameObject:SetActive(false)
end

function this.StopAllOfflineIncrease()
	for i = 0, #playerOfflineCoroutines do
		--print('-------------Mark----------', i)
		local coroutines =  playerOfflineCoroutines[i]
		if coroutines ~= nil then
			coroutine.stop(coroutines)
			coroutines = nil;
		end
	end
end

function this.CloseStageClear()
	this.hasStageClear = false
	PanelManager.Instance:HideWindow("panelStageClear_dtz")
end