local csm_pb = require 'csm_pb'
local phz_pb = require 'phz_pb'
require 'const'

panelInGamemj = {}
local this = panelInGamemj
local gameObject
local message

local roomRound
local roomID
local waitRoomID --等待时房间号
local roomTime
local batteryLevel
local network
local pingLabel
local roomSetting
local line
local operation_send
local dipai
local curOperatPlateEffect
local kaiBao
local playerBrid

local playerName={}
local playerIcon={}
local playerScore={}
local playerHeadBGObj={}
local playerMaster={}
local playerSound={}
local playerOffline={}
local playerGridXi={}
local playerThrow={}
local playerReady={}
local playerOperationEffectPos={}
local playerMoPaiPos={}
local playerCurMoPi={}
local playerGridHand={}
local curActivePlayerIcon={}
local playerHandGridPos ={};--每个玩家手牌grid的原始位置信息
local playerTableThrowGridPos = {};--牌桌上的牌的grid的初始位置
local playerHupaiPos = {};
local playerKuang = {};--玩家出牌的特效框
local effectCategories = {};--特效位置
local playerTrusteeship = {}
local playerOfflineTime = {}
local playerOfflineCoroutines = {}
local playerAnimation	= {}

local playerEmojiCoroutine = {}
playerEmojiCoroutine[0] = {}
playerEmojiCoroutine[1] = {}
playerEmojiCoroutine[2] = {}
playerEmojiCoroutine[3] = {}

local playerPiaoFen={}
local playerChuPaiShows = {}--出牌时展示动画
local effectGang;--杠牌特效
local ButtonSetting
local ButtonChat
local ButtonSound
local ButtonInvite
local ButtonCloseRoom
local ButtonExitRoom
local ButtonNext
local ButtonReady--准备按钮
local RecordTiShi--录音提示
local waitopTip;--等待其他玩家操作提示
local newTingOperation

local ButtonHu
local ButtonGang
local ButtonPeng
local ButtonChi
local ButtonGuo
local ButtonBu
local ButtonGPS;
local ButtonRule;--玩法按钮
local ButtonMore;--更多按钮
local playerTingButton;--玩家的听牌按钮
local TingItemPrefab;--听牌元素预制
local morePanel;--更多弹窗

local piaofendlg
local piaofenbtn0
local piaofenbtn1
local piaofenbtn2
local piaofenbtn3
local gameTypeobj;--游戏类型

local playerMsg={}
local playerGameMsg={}
local playerMsgBG={}
local playerEmoji={}
local playerCoroutine = {}
playerCoroutine[0] = {}
playerCoroutine[1] = {}
playerCoroutine[2] = {}
playerCoroutine[3] = {}

local playerData={}
local roomData={}
local dissolution={}
local mySeat
local needChuPai = false
local dargObj = nil
local paiAnimations={}
local needChuPaiBefroeHu = false
local rollResult
local ButtonRefresh;--刷新游戏
local tingData;--提牌的数据

this.fanHuiRoomNumber = nil
this.OnRoundStarted = nil
this.needCheckNet=true

local GPS;--GPS游戏对象
local distances = {};--相隔距离游戏对象
--local RuleInfoPanel--玩法展示界面
local ruleCloseButton;
local ruleMask;
local operation_mask;--操作屏蔽按钮
local RestTime;--剩余多少时间解散

local HongzhongPlateValue = 31;

local lastSelectmahjong;--最后一个点击的麻将，用来做点击上移效果

local draggingObject = nil;


local dragDepthOffset = 100;
local dragCardFrameDepth = 0;
local dragCardDepth = 0;
local tingTipDepth = 0;

local haveSuddenBonus = false;--是否有中途起手胡
local suddenBonusData = {};--中途起手胡的数据
local suddenColorPlates = {};--中途起手胡颜色牌
local DelegateTime;--委托时间
local DelegatePanel;--委托面板
local trusteeshipcor = nil;
local offlineState = false;
local GvoiceCor;


local lastOperat={}
local RoundData={}
local RoundAllData={}
ROperationData=nil

local connect
local connectCor
local voiceCor
local playerSize = 4
this.chatTexts={}

local cardColorNum = 2;--牌色的数量
local BgColorNum = 3;--背景颜色的数量

local bgColor;--牌色的索引
local cardColor;--背景的颜色索引1.蓝色 2.绿色
local cardText;--背景的字体索引

local IsAutoDissolve = false
local AutoDissolveData

this.myseflDissolveTimes = 0
local IsMoPaiDrag = false;
local curMoPaiObj;

local remainTime = 15
local panelShare
local lessPlayerStartView
local lessPlayerStartToggle
function this.Awake(obj)
	gameObject 				= obj;
    this.gameObject 		= obj
	message 				= gameObject:GetComponent('LuaBehaviour');

	roomID 					= gameObject.transform:Find('stateBar/room/ID');
	waitRoomID 				= gameObject.transform:Find('setting/roominfo/waitRoomID');
	roomTime 				= gameObject.transform:Find('stateBar/time');
	roomRound 				= gameObject.transform:Find('DiPai/frame/round');
	roomSetting 			= gameObject.transform:Find('setting');
	gameTypeobj 			= gameObject.transform:Find('type');
	line 					= gameObject.transform:Find('line')
	operation_send 			= gameObject.transform:Find('operation_send')
	dipai 					= gameObject.transform:Find('DiPai')
	kaiBao 					= gameObject.transform:Find('KaiBao')
	curOperatPlateEffect 	= gameObject.transform:Find('curOperatPlateEffect')
	playerBrid 				= gameObject.transform:Find('Birds')
	
	ButtonSetting 			= gameObject.transform:Find('morePanel/ButtonSetting')
	ButtonChat	 			= gameObject.transform:Find('ButtonChat')
	ButtonSound 			= gameObject.transform:Find('ButtonSound')
	ButtonInvite 			= gameObject.transform:Find('bottomButtons/ButtonInvite')
	ButtonCloseRoom 		= gameObject.transform:Find('bottomButtons/ButtonCloseRoom')
	ButtonExitRoom 			= gameObject.transform:Find('bottomButtons/ButtonExitRoom')
	ButtonNext 				= gameObject.transform:Find('ButtonNext')
	ButtonReady 			= gameObject.transform:Find('ButtonReady')
	ButtonRefresh 			= gameObject.transform:Find('ButtonRefresh');
	operation_mask			= gameObject.transform:Find("operationMask");
	
	ButtonHu 				= operation_send:Find('Button2Hu')
	ButtonGang 				= operation_send:Find('Button3Gang')
	ButtonPeng 				= operation_send:Find('Button5Peng')
	ButtonChi 				= operation_send:Find('Button6Chi')
	ButtonGuo 				= operation_send:Find('Button1Guo')
	ButtonBu 				= operation_send:Find('Button4Bu')
	this.ButtonGuo 			= ButtonGuo
	GPS 					= gameObject.transform:Find("GPS");
	morePanel 				= gameObject.transform:Find("morePanel");
	waitopTip 				= gameObject.transform:Find("waitopTip");

	ButtonGPS				= gameObject.transform:Find("morePanel/ButtonGPS");
	ButtonMore				= gameObject.transform:Find("ButtonMore");
	ButtonRule				= gameObject.transform:Find("morePanel/ButtonRules");
	--RuleInfoPanel 			= gameObject.transform:Find('RuleInfoPanel');
	--ruleCloseButton			= RuleInfoPanel:Find('CloseButton');
	--ruleMask 				= RuleInfoPanel:Find('mask')
	RecordTiShi				= gameObject.transform:Find('RecordTiShi');

	piaofendlg 				= gameObject.transform:Find('piaofendlg');
	piaofenbtn0 			= gameObject.transform:Find('piaofendlg/0');
	piaofenbtn1 			= gameObject.transform:Find('piaofendlg/1');
	piaofenbtn2 			= gameObject.transform:Find('piaofendlg/2');
	piaofenbtn3 			= gameObject.transform:Find('piaofendlg/3');
	playerTingButton 		= gameObject.transform:Find("tingOperation");
	TingItemPrefab 			= gameObject.transform:Find("tingOperation/cardItem");
	effectGang				= gameObject.transform:Find("effectGang");
	RestTime				= gameObject.transform:Find("RestTime");
	DelegateTime			= gameObject.transform:Find("TrusteeshipTip");
	DelegatePanel			= gameObject.transform:Find("TrusteeshipPanel");
    newTingOperation        = gameObject.transform:Find('newTingOperation');
	lessPlayerStartView     = gameObject.transform:Find('lessPlayerStart');
	lessPlayerStartToggle	= lessPlayerStartView:Find('toggle/tg');

	message:AddClick(lessPlayerStartToggle.gameObject, 		this.OnClickLessPlayerStartToggle)
	--message:AddClick(ButtonSetting.gameObject, this.OnClickButtonSetting)
	message:AddClick(ButtonChat.gameObject, 		this.OnClickButtonChat)
	message:AddPress(ButtonSound.gameObject,	 	this.OnPressButtonSound)
	message:AddClick(ButtonCloseRoom.gameObject, 	this.OnClicButtonCloseRoom)
	message:AddClick(ButtonExitRoom.gameObject, 	this.OnClicButtonLeaveRoom)
	message:AddClick(ButtonReady.gameObject, 		this.OnClickButtonNext)
	message:AddClick(ButtonHu.gameObject, 			this.OnClickOperationButton)
	message:AddClick(ButtonGang.gameObject, 		this.OnClickOperationButton)
	message:AddClick(ButtonPeng.gameObject, 		this.OnClickOperationButton)
	message:AddClick(ButtonChi.gameObject, 			this.OnClickOperationButton)
	message:AddClick(ButtonGuo.gameObject, 			this.SureGuoMsgBox)
	message:AddClick(ButtonBu.gameObject, 			this.OnClickOperationButton)
	message:AddClick(ButtonRefresh.gameObject,		this.OnClickButtonRefresh);

	message:AddClick(ButtonMore.gameObject, 		this.OnClickButtonSetting);


	message:AddClick(piaofenbtn0.gameObject, 		this.OnClickPiaoFen);
	message:AddClick(piaofenbtn1.gameObject, 		this.OnClickPiaoFen);
	message:AddClick(piaofenbtn2.gameObject, 		this.OnClickPiaoFen);
	message:AddClick(piaofenbtn3.gameObject, 		this.OnClickPiaoFen);
	message:AddClick(playerTingButton.gameObject, 	this.OnClickButtonTing);
	message:AddClick(DelegatePanel:Find("CancelTrusteeshipBtn").gameObject, 	this.OnClickCancelTrustesship);


	--message:AddClick(gameObject.transform:Find("morePanel/mask").gameObject, function (obj)  morePanel.gameObject:SetActive(false) end);



	--房间的邀请好友
	message:AddClick(ButtonInvite.gameObject, this.ShowPanelShare);
    panelShare = gameObject.transform:Find('panelShare');
    message:AddClick(panelShare:Find('xianLiao').gameObject, this.OnClickButtonXLInvite);
    message:AddClick(panelShare:Find('friendGroup').gameObject, this.OnClickButtonInvite);

	message:AddClick(panelShare:Find('copy').gameObject, this.OnClickButtonCopy);
    message:AddClick(panelShare:Find('ButtonClose').gameObject, this.ClosePanelShare);
    message:AddClick(panelShare:Find('mask').gameObject, this.ClosePanelShare);

	batteryLevel = gameObject.transform:Find('stateBar/battery/level'):GetComponent('UISprite')
	network = gameObject.transform:Find('stateBar/network'):GetComponent('UISprite')
	pingLabel = gameObject.transform:Find('stateBar/ping'):GetComponent('UILabel')
	RegisterGameCallBack(csm_pb.PONG, this.OnPong)
	message:AddPress(network.gameObject, 
		function (go, state)
			pingLabel.gameObject:SetActive(state)
		end
	)
	this.GetPlayerUI()
	this.fitScreen()
end

function this.fitScreen()
	--宽屏手机自适应
	newTingOperation.localPosition = isShapedScreen and Vector3(-363,-177,0) or Vector3(-363,-200,0);
	if isShapedScreen  then
		playerGridHand[0].localPosition = Vector3(455*FitScale, -288, 0)
		playerGridHand[0].localScale = Vector3(FitScale, FitScale, 1)
		playerGridXi[0].localPosition = Vector3(-636-FitOffset, -315, 0)
		playerGridXi[0].localScale = Vector3(FitScale, FitScale, 1)
		
		playerCurMoPi[0].localPosition = Vector3(574*FitScale, -288, 0)
		playerCurMoPi[0].localScale = Vector3(FitScale, FitScale, 1)

		ButtonChat.localPosition = Vector3(704, -55, 0)
		ButtonSound.localPosition = Vector3(704, 55, 0)
		playerTingButton.localPosition = Vector3(712, -170, 0)
		playerTingButton:Find('frame').localPosition = Vector3(-729, 64, 0)

		
		playerGridHand[1].localPosition = Vector3(597, -175, 0)
		playerGridXi[1].localPosition = Vector3(584, -152, 0)
		playerCurMoPi[1].localPosition = Vector3(597, 238, 0)
		playerGridHand[3].localPosition = Vector3(-601, 243, 0)
		playerGridXi[3].localPosition = Vector3(-590, 287, 0)
		playerCurMoPi[3].localPosition = Vector3(-601, -170, 0)
	end
	for i=0,3 do
		if playerHupaiPos[i] == nil then
			playerHupaiPos[i] = playerOperationEffectPos[i].position;
		end
		if playerTableThrowGridPos[i] == nil then
			playerTableThrowGridPos[i] = playerThrow[i].localPosition;
		end
		if playerHandGridPos[i] == nil then
			playerHandGridPos[i] = playerGridHand[i].localPosition;
		end
	end
end

function this.OnApplicationFocus()

end

function this.WhoShow(data)
	gameObject:SetActive(false)
	this.SetMyAlpha(1)
	this.OnRoundStarted = nil
	PanelManager.Instance:HideAllWindow()
	gameObject:SetActive(true)
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

function this.Start()
	coroutine.start(RefreshTime, roomTime:GetComponent('UILabel'), 60)
end

function this.Update()

	if IsMoPaiDrag then
		this.DraggingMoPai(draggingObject);
	end

end

function this.RegisterGameCallBack()
	ClearGameCallBack()
	RegisterGameCallBack(csm_pb.PLAYER_ENTER, 			this.OnPlayerEnter)
	RegisterGameCallBack(csm_pb.PLAYER_JOIN, 			this.OnPlayerJion)
	RegisterGameCallBack(csm_pb.LEAVE_ROOM, 			this.OnLeaveRoom)
	RegisterGameCallBack(csm_pb.PLAYER_LEAVE, 			this.OnPlayerLeave)
	RegisterGameCallBack(csm_pb.ROUND_START, 			this.OnRoundStart)
	RegisterGameCallBack(csm_pb.LORD_DISSOLVE, 			this.OnLordDissolve)
	RegisterGameCallBack(csm_pb.ROUND_END, 				this.OnRoundEnd)
	RegisterGameCallBack(csm_pb.READY, 					this.OnReady)
	RegisterGameCallBack(csm_pb.MOPAI, 					this.OnPlayerMoPai)
	RegisterGameCallBack(csm_pb.CHUPAI, 				this.OnPlayerChuPai)
	RegisterGameCallBack(csm_pb.CHIPAI, 				this.OnPlayerChiPai)
	RegisterGameCallBack(csm_pb.PENGPAI, 				this.OnPlayerPengPai)
	RegisterGameCallBack(csm_pb.ZHISHAIZI, 				this.onPlayerZhiShaiZi)
	RegisterGameCallBack(csm_pb.GANGPAI, 				this.OnPlayerGangPai)
	RegisterGameCallBack(csm_pb.BUPAI, 					this.OnPlayerBuPai)
	RegisterGameCallBack(csm_pb.FOLD, 					this.OnPlayerGuo)
	RegisterGameCallBack(csm_pb.ASK_LAO, 				this.OnPlayerAskLao)
	RegisterGameCallBack(csm_pb.LAOHAIDI,				this.OnPlayerLaoHaiDi)
	RegisterGameCallBack(csm_pb.HUPAI, 					this.OnPlayerHuPai)
	RegisterGameCallBack(csm_pb.GAME_OVER, 				this.OnOver)
	RegisterGameCallBack(csm_pb.DISSOLVE, 				this.OnDissolve)
	RegisterGameCallBack(csm_pb.DESTROY, 				this.Destroy)
	RegisterGameCallBack(csm_pb.SEND_CHAT, 				this.OnSendChat)
	RegisterGameCallBack(csm_pb.START_HU, 				this.onPlayerStartHu)
	RegisterGameCallBack(csm_pb.START_HU_END, 			this.onPlayerStartHuEnd)
	RegisterGameCallBack(csm_pb.DISCONNECTED, 			this.OnDisconnected)
	RegisterGameCallBack(csm_pb.VOICE_MEMBER, 			this.OnVoiceMember)
	RegisterGameCallBack(csm_pb.NO_ROOM, 				this.OnRoomNoExist)
	RegisterGameCallBack(csm_pb.ENTER_ERROR, 			this.OnRoomError)
	RegisterGameCallBack(csm_pb.ENABLE_FLOAT_SCORE, 	this.OnPiaoFen)
	RegisterGameCallBack(csm_pb.PUBLICITY_FLOAT_SCORE, 	this.OnShowPiaoFen)
	RegisterGameCallBack(csm_pb.ZT_HU, 					this.onPlayerZhongtuhu)
	RegisterGameCallBack(csm_pb.ZT_HU_END, 				this.onPlayerZhongtuhuEnd)
	RegisterGameCallBack(csm_pb.AUTO_DISSOLVE,			this.OnAutoDissolve)
	RegisterGameCallBack(csm_pb.TRUSTEESHIP,			this.OnTrustesship)
	RegisterGameCallBack(csm_pb.GIFT, 					this.OnPlayerEmoji)
	RegisterGameCallBack(csm_pb.ERROR_INFO, 			this.OnGameError)
	RegisterGameCallBack(csm_pb.OVERTIME_DISSOLVE,this.OnOverTimeDissolve)
	RegisterGameCallBack(csm_pb.REFRESH_SCORE_BOARD,this.OnRefreshScoreBoard)
	RegisterGameCallBack(csm_pb.CHOICE_MINORITY,this.onGetRChoiceMinority)
	RegisterGameCallBack(csm_pb.UPDATE_MINORITY,this.OnUpdateMinority)--UPDATE_MINORITY = 50;            // 更新玩家少人开局状态，再房间离开房间时广播
end

function this.OnRefreshScoreBoard(msg)
	print('更新分数')
	local b = csm_pb.RRefreshScoreBoard()
	b:ParseFromString(msg.body)
	for i=1,#b.scoreBoard do
		local index = this.GetUIIndex(this.GetUIIndexBySeat(b.scoreBoard[i].seat),playerSize)
		playerScore[index]:GetComponent('UILabel').text = b.scoreBoard[i].score;
	end
end

function this.OnEnable()
	PanelManager.Instance:HideWindow('panelLobby');
	PanelManager.Instance:HideWindow('panelClub');
	panelInGame = panelInGamemj;
    panelInGame.needXiPai=false
	this.RegisterGameCallBack()
	connect = NetWorkManager.Instance:CreateConnect('game');
    connect.IP = GetServerIPorTag(false, roomInfo.host)
    connect.Port = roomInfo.port
	connect.GroupName = ConfigManager.getProperty('ProxyServer', 'GroupName', '');
    connect.onConnectLua = this.OnConnect
    connect.disConnectLua = this.OnDisconnect
    connect.rspCallBackLua = receiveGameMessage;
	connect.reConnectNum = ConfigManager.getIntProperty('Setting', 'ReconnectNum', 5)
    connect:Connect()
	
	coroutine.start(this.RefreshState)

	--获取主题颜色
	bgColor 	= UnityEngine.PlayerPrefs.GetInt('bgColor_mj', 1);
	cardColor 	= UnityEngine.PlayerPrefs.GetInt('cardColor_mj', 1);
	cardText 	= UnityEngine.PlayerPrefs.GetInt('cardText_mj', 1);


	
	-- local msg = Message.New()
	-- msg.type = proxy_pb.PING
	-- connect.heartBeatMsg = msg
	connect.heartBeatInterval = 5;
	
	this.StartCheckNetState()
	
	if panelChat then
		panelChat.ClearChat()
	end
	
	voiceMemeber = {}
	isIngame = true
	if panelClub then
		panelClub.isInClub=false
	end
	this.GetGPSUI();

	this.RsetWhenStart()
	this.HidePlatesGrid();



	--设置主题颜色
	this.ChooseBG(bgColor);
	-- this.SetCardColor(cardColor);
	AudioManager.Instance:StopMusic()
    AudioManager.Instance:PlayMusic('GameBG_mj', true)

	UnityEngine.Screen.sleepTimeout = UnityEngine.SleepTimeout.NeverSleep
	
	LuaManager.Instance:DoFile('effManger.lua')

	for i = 0, 3 do
		playerTrusteeship[i].gameObject:SetActive(false)
	end
	IsAutoDissolve = false
end

function this.RsetWhenStart()
	--print("RsetWhenStart was called")
	line.gameObject:SetActive(false)
	operation_send.gameObject:SetActive(false);
	operation_mask.gameObject:SetActive(false);
	this.SetWaitOpTip(false,"");
	--print("operation_mask-------------->10");
	curOperatPlateEffect.gameObject:SetActive(false)
	newTingOperation.gameObject:SetActive(false)
	ButtonNext.gameObject:SetActive(false)
	
	this.RefreshCurMoPai(-1, -1)
	this.HideAllBirds()

end





function this.RsetWhenJionRoom()
	this.ResetWhenStateChange()
	this.RsetWhenClickNextRound();
	print("roomData.state###########:"..roomData.state);
	if csm_pb.GAMING == roomData.state then
		if roomData.activeSeat == mySeat  and not roomData.waitOperate then
			needChuPai = true
			line.gameObject:SetActive(needChuPai)
		end
		if roomData.activeSeat then
			this.ShowWaitOpreatEffect(roomData.activeSeat, true)
		end
		print("outMahjong:"..tostring(roomData.outMahjong).."|hasField:"..tostring(roomData:HasField('outMahjong')));
		print("outSeat:"..tostring(roomData.outSeat).."|hasField:"..tostring(roomData:HasField('outSeat')));
		if roomData:HasField('outMahjong') and roomData:HasField('outSeat') then
			lastOperat.plate = {roomData.outMahjong}
			lastOperat.seat = roomData.outSeat
		end
		local p = this.GetPlayerDataBySeat(mySeat)
		if p.moMahjong ~= -1 then
			lastOperat.plate = {p.moMahjong}
		end
		for i=1,#p.categories do
			if p.categories[i].category == 1 then
				lastOperat.plate = {}
				for j=1,#p.categories[i].mahjongs,4 do
					table.insert(lastOperat.plate, p.categories[i].mahjongs[j])
				end
			end
		end

		--提示是否等待操作
		this.SetWaitOpTip(roomData.waitOperateTip,"请等待其他玩家操作");
		--print("roomData.waitOperateTip:"..tostring(roomData.waitOperateTip));

		--玩家是否可以操作
		this.OperationForbidden(p.sealPai);
		--print('outMahjong:'..roomData.outMahjong..' outSeat:'..roomData.outSeat..' laoMahjong:'..roomData.laoMahjong..' mopai:'..p.moMahjong)
		--掷色子
		if #roomData.zhiShaiZi.zhiMahjongs > 0 and roomData.zhiShaiZi.seat >=0 then
			local pData = this.GetPlayerDataBySeat(roomData.zhiShaiZi.seat);
			if pData then
				for i = 1, #roomData.zhiShaiZi.zhiMahjongs do
					table.insert(pData.paiHe,roomData.zhiShaiZi.zhiMahjongs[i]);
				end
			end
		end


		this.RefreshAllGridXi()
		this.RefreshAllCurMoPai()
		this.RefreshAllGridHand()
		this.RefreshAllTabelThrow()
		print("HideWaittingUI--->RsetWhenJionRoom");
		this.HideWaittingUI();
		

		--if roomData:HasField('zhiMahjong1') and roomData:HasField('zhiMahjong2') then
		--	coroutine.start(this.OnRollEnd, roomData.zhiMahjong1, roomData.zhiMahjong2, 2)
		--end

		--处理中途起手胡的数据
		if p.haveZtHu then
			for i = 1, #p.operations do
				if p.operations[i].operation == csm_pb.ZTHU then
					this.SetSuddenBonus(p.haveZtHu,p.ztHuItem,p.operations[i].mahjongs);
				end
			end
		end


		--长沙麻将才有海底捞
		if roomData.askLao ~= nil and roomData.askLao.seat >= 0 then
			if roomData.askLao.seat == mySeat  then
				if playerTingButton.gameObject.activeSelf then 
					panelMessageBox.SetParamers(OK_CANCLE, this.OnClickMsgBoxOk, this.OnClickMsgCancle, '是否捞海底？');
				else
					panelMessageBox.SetParamers(ONLY_CANCLE, this.OnClickMsgBoxOk, this.OnClickMsgCancle, '是否捞海底？');
				end
				
				PanelManager.Instance:ShowWindow('panelMessageBox');
			else
				--等待玩家选择海底捞
			end

		else
			this.RefreshOperationSend(p.operations, 'JionRoom');

		end
		-- if p.sealPai and p.moMahjong ~= -1 and ButtonHu.gameObject.activeSelf == false and ButtonGang.gameObject.activeSelf == false then
		-- 	this.SendChuPaiMsg(p.moMahjong)
		-- end

		--托管
		if p.trusteeship then
			this.SetMyseflInTrustesship(mySeat,true);
		end
	end
end

--设置补牌杠牌的数据，有哪些牌可以补或者杠
function this.SetBuGangData(pData)
	--print("SetBuGangData was called,pData.before -->operations.length:",#pData.operations);
	lastOperat.buGang = {};
	ROperationData = {};
	for i = 1, #pData.operations do
		if pData.operations[i].operation == csm_pb.BU or pData.operations[i].operation == csm_pb.GANG then
			for j = 1, #pData.operations[i].mahjongs do
				table.insert(lastOperat.buGang, {op_type=pData.operations[i].operation,mahjong=pData.operations[i].mahjongs[j]});
			end
		end
	end
	--print("SetBuGangData was called,pData.after -->operations.length:",#pData.operations);



end

function this.RsetWhenClickNextRound()
	if roomData.state ~= csm_pb.GAMING then
		for i=0,3 do
			playerGridXi[i].gameObject:SetActive(false)
			playerThrow[i].gameObject:SetActive(false)
			playerGridHand[i].gameObject:SetActive(false)
		end
	end
end


function this.HidePlatesGrid()
	for i=0,3 do
		playerGridXi[i].gameObject:SetActive(false)
		playerThrow[i].gameObject:SetActive(false)
		playerGridHand[i].gameObject:SetActive(false)
	end
end

function this.ResetWhenStateChange()
	--print(('RsetWhenStateChange');
	
	-- ButtonCloseRoom.gameObject:SetActive(#playerData ~= playerSize and mySeat == 0)
	-- ButtonExitRoom.gameObject:SetActive(#playerData ~= playerSize and mySeat ~= 0)
	-- ButtonSetting.gameObject:SetActive(#playerData == playerSize)
	ButtonNext.gameObject:SetActive(false)
	operation_send.gameObject:SetActive(false)

	operation_mask.gameObject:SetActive(roomData.waitOperate);
	this.SetWaitOpTip(roomData.waitOperateTip,"请等待其他玩家操作");
	--print("roomData.waitOperateTip--------"..tostring(roomData.waitOperateTip));
	--print("operation_mask-------------->1");
	curOperatPlateEffect.gameObject:SetActive(false)
	-- 条件的意思为：正在游戏中或者（准备中并且人数都齐了）
	dipai.gameObject:SetActive(this.NeedShowDiPai());
	roomRound.gameObject:SetActive(this.NeedShowDiPai());
	this.ShowWaittingUI(roomData.state);
	morePanel.gameObject:SetActive(false);
	function SetCurState(index,csm_pb,roomData,i)
		playerGridXi[index].gameObject:SetActive(csm_pb.GAMING == roomData.state and i < playerSize)
		playerThrow[index].gameObject:SetActive(csm_pb.GAMING == roomData.state and i < playerSize)
		playerGridHand[index].gameObject:SetActive(csm_pb.GAMING == roomData.state and i < playerSize);
		-- curActivePlayerIcon[i].gameObject:SetActive(false)
		curActivePlayerIcon[index]:Find('frame').gameObject:SetActive(false);
		curActivePlayerIcon[index]:Find('select').gameObject:SetActive(false);
		curActivePlayerIcon[index]:Find('unselect').gameObject:SetActive(true);
		playerCurMoPi[index].gameObject:SetActive(csm_pb.GAMING == roomData.state and i < playerSize);
	end


	for i=0,playerSize-1 do
		SetCurState((this.GetUIIndex(i,playerSize)),csm_pb,roomData,i);
	end

	PanelManager.Instance:HideWindow("panelStageClear_mj");

	needChuPai = false
end


function this.NeedShowDiPai()
	if roomData.state == csm_pb.GAMING then--如果正在游戏中，那么肯定是要显示
		return true;
	else
		if roomData.state == csm_pb.READYING then--如果是准备状态
			if roomData.round > 1 then --之前刚刚打完一局，进入下一句的等待中
				return true;
			else--刚刚加入房间的起始局

				local myData = this.GetPlayerDataBySeat(mySeat);
				if #playerData == roomData.setting.size and this.IsAllReaded() then--游戏启动了飘分
					if roomData.setting.floatScore then
						return this.IsAllPiaofen();
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
	--csm_pb.GAMING == roomData.state or (csm_pb.READYING == roomData.state and #playerData == playerSize and this.IsAllReaded())
end

--获得GPS游戏对象
function this.GetGPSUI()
	for i = 1, 6 do
		distances[i] = GPS:Find("Distance/distance"..i);
	end
end

function this.GetPlayerUI()
	for i=0,3 do
		playerName[i] = gameObject.transform:Find('player'..i..'/name')
		playerIcon[i] = gameObject.transform:Find('player'..i..'/Texture')
		playerScore[i] = gameObject.transform:Find('player'..i..'/score')
		playerHeadBGObj[i] = gameObject.transform:Find('player'..i..'/bg')
		playerMaster[i] = gameObject.transform:Find('player'..i..'/master')
		playerSound[i] = gameObject.transform:Find('player'..i..'/sound')
		playerOffline[i] = gameObject.transform:Find('player'..i..'/offline')
		playerReady[i] = gameObject.transform:Find('player'..i..'/ready')
		playerMsg[i] = gameObject.transform:Find('player'..i..'/Msg')
		playerGameMsg[i] = gameObject.transform:Find('player'..i..'/gameMsg')
		playerMsgBG[i] = gameObject.transform:Find('player'..i..'/Msg/MsgBG')
		playerEmoji[i] = gameObject.transform:Find('player'..i..'/Emoji')
		playerSound[i] = gameObject.transform:Find('player'..i..'/sound')
		playerOperationEffectPos[i] = gameObject.transform:Find('player'..i..'/operation_pos')
		playerMoPaiPos[i] = gameObject.transform:Find('player'..i..'/mopai_pos')
		playerPiaoFen[i] = gameObject.transform:Find("player"..i.."/piaofen");
		playerKuang[i] = gameObject.transform:Find("player"..i.."/kuang");
		playerTrusteeship[i] = gameObject.transform:Find('player'..i..'/trusteeship')
		playerOfflineTime[i] = gameObject.transform:Find('player'..i..'/offlineTime')
		playerAnimation[i] 	= gameObject.transform:Find('teshubiaoqing/'..i);
		playerThrow[i] = gameObject.transform:Find('player'..i..'_mj/TabelThrow')
		playerGridXi[i] = gameObject.transform:Find('player'..i..'_mj/GridXi')
		playerGridHand[i] = gameObject.transform:Find('player'..i..'_mj/GridHand')
		playerChuPaiShows[i] = gameObject.transform:Find('player'..i..'_mj/chuPaiShow')
		playerCurMoPi[i] = gameObject.transform:Find('player'..i..'_mj/MoPaiGrid')
		curActivePlayerIcon[i] = gameObject.transform:Find('DiPai/DeskTimerIndex'..i)
		effectCategories[i] = gameObject.transform:Find('effectCategories/cate'..i);


		message:RemoveClick(playerIcon[i].gameObject)
		message:AddClick(playerIcon[i].gameObject, this.OnClickPlayerIcon)

		if i == 0 then
			UIEventListener.Get(playerCurMoPi[i]:GetChild(0).gameObject).onDragStart = this.OnDragStartPlate;
			UIEventListener.Get(playerCurMoPi[i]:GetChild(0).gameObject).onDragEnd = this.OnDragEndtPlate;
			UIEventListener.Get(playerCurMoPi[i]:GetChild(0).gameObject).onDoubleClick = this.OnDoubleClickPlate;
			UIEventListener.Get(playerCurMoPi[i]:GetChild(0).gameObject).onClick = this.OnClickMahjong;
		end
	end

end

function this.SetPlayerPos(state)

	--设置座位位置
	local localPos = nil
	for i=0,3 do
		if state  ~= csm_pb.GAMING and (#playerData < roomData.setting.size or roomData.round == 1) then
			if i == 0 then
				localPos = Vector3.New(0,-119,0)
			elseif i == 1 then
				localPos = Vector3.New(395,55,0)
			elseif i == 2 then
				localPos = Vector3.New(0,271,0)
			else
				localPos = Vector3.New(-393,55,0)
			end
		else
			if i == 0 then
				localPos = isShapedScreen==true and Vector3(-707,-130,0) or Vector3.New(-611,-168,0)
			elseif i == 1 then
				localPos = isShapedScreen==true and Vector3(707,180,0) or Vector3.New(610,180,0)
			elseif i == 2 then
				localPos = Vector3.New(316.8,298.1,0)
			else
				localPos = isShapedScreen==true and Vector3(-707,177.5,0) or Vector3.New(-611,177.5,0)
			end
		end
		playerName[i].parent.localPosition = localPos
	end

	--两人局
	if roomData.setting.size == 2 then
		playerName[0].parent.gameObject:SetActive(true);
		playerName[1].parent.gameObject:SetActive(false);
		playerName[2].parent.gameObject:SetActive(true);
		playerName[3].parent.gameObject:SetActive(false);
	--三人局
	elseif roomData.setting.size == 3 then
		playerName[0].parent.gameObject:SetActive(true);
		playerName[1].parent.gameObject:SetActive(true);
		playerName[2].parent.gameObject:SetActive(false);
		playerName[3].parent.gameObject:SetActive(true);
	--四人局
	elseif roomData.setting.size == 4 then
		playerName[0].parent.gameObject:SetActive(true);
		playerName[1].parent.gameObject:SetActive(true);
		playerName[2].parent.gameObject:SetActive(true);
		playerName[3].parent.gameObject:SetActive(true);
	end
	
end

function this.OnConnect()
	coroutine.start(
		function()
			while not isLogin do
				coroutine.wait(0.1)
			end
			this.JionRoom()
		end
	)
end

function this.OnDisconnect()
	--print('game OnDisconnect')
	connect.IP = GetServerIPorTag(false,roomInfo.host)
	connect.Port = roomInfo.port
	connect:ClearSendMessage()
end

function this.CheckNetState()
	--print('panelInGame.CheckNetState')
	coroutine.wait(1)
	
	while gameObject.activeSelf and this.needCheckNet==true do
		if connect.IsReConnect then
			PanelManager.Instance:ShowWindow('panelGameNetWaitting')
		elseif  not connect.IsConnect then
			PanelManager.Instance:HideWindow('panelNetWaitting')
            panelLogin.HideAllNetWaitting()
			panelMessageBox.SetParamers(OK_CANCLE, this.OnNetCheckButtonOK, this.OnNetCheckButtonCancle, '网络连接失败，是否继续连接？')
			PanelManager.Instance:ShowWindow('panelGameNetWaitting')
			break
		elseif connect.IsConnect then
			PanelManager.Instance:HideWindow('panelGameNetWaitting')
		end
		
		coroutine.wait(0.5)
	end
end

function this.StopCheckNetState()
	--print('StopCheckNetState')
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
	msg.type 		= csm_pb.JOIN_ROOM
	local body 		= csm_pb.PJoinRoom();
	body.roomNumber = roomInfo.roomNumber
	body.token 		= roomInfo.token


	if UnityEngine.Application.isEditor then
		--print("editor GPS");
		body.longitude 	= 113.9237598273;
		body.latitude 	= 24.7427623656;
		body.address 	= "中国广东省韶关市曲江区小坑镇";
	else
		--print("other platform GPS");
		body.longitude 	= tonumber(UnityEngine.PlayerPrefs.GetFloat("longitude",0));
		body.latitude 	= tonumber(UnityEngine.PlayerPrefs.GetFloat("latitude",0));
		body.address 	= UnityEngine.PlayerPrefs.GetString("address","");
	end


	--print("发送经纬度给服务器：longitude，latitude，address",body.longitude,body.latitude ,body.address );

	msg.body 		= body:SerializeToString();
	SendGameMessage(msg, this.OnJoinRoomResult)
end

function this.OnJoinRoomResult(msg)
    panelInGame.needXiPai=false
	--print(("OnJoinRoomResult was called");
	panelLogin.HideNetWaitting();
	local body = csm_pb.RJoinRoom();
	body:ParseFromString(msg.body)
	roomData	= body.room
	mySeat 		= body.seat
	playerSize 	= roomData.setting.size;
	this.hideAllPlayerMsg()
	this.initLessPlayerStart()
	print('收到开启少人模式',roomData.setting.minorityMode)
	lessPlayerStartView.gameObject:SetActive(roomData.setting.minorityMode)
	this.fanHuiRoomNumber = roomInfo.roomNumber;
	-- body.room.player[].mahjongs.remove(body.room.player[].moMahjong)
	print("我的椅子号  ",mySeat);
	playerData={}
	dissolution = {}
	dissolution.acceptors = {}
	dissolution.remainMs = 0;
	offlineState = false;
	for i=1,#body.room.players do
		local p = body.room.players[i]
		p.sex = p.sex == 0 and 1 or p.sex
		--print(p.ready,"准备状态",p.thinkTime)
		--print('player.seat'..p.seat..'|connected:'..tostring(p.connected));
		table.insert(playerData, p)
		--print('-------------------------> seat:'..p.seat..' floatScore:'..p.floatScore)
		--print(tostring(p.connected))
		if p.thinkTime > 0 and p:HasField('decision') then
			dissolution.remainMs = p.thinkTime
			if p.decision == csm_pb.APPLY then
				dissolution.applicant = p.seat
			elseif p.decision == csm_pb.AGREE then
				table.insert(dissolution.acceptors, p.seat)
			end
		end
		if not p:HasField('moMahjong') then
			p.moMahjong = -1
		end
	end

	this.SetPlayerPos(roomData.state);
	roomID:GetComponent('UILabel').text = roomInfo.roomNumber;
	waitRoomID:GetComponent('UILabel').text = roomInfo.roomNumber;

	--print('roomData state '..roomData.state)
	--print('roomData activeSeat:'..roomData.activeSeat..' mySeat:'..mySeat)
	
	DestroyRoomData.roomData 	= roomData;
	DestroyRoomData.playerData 	= playerData;
	DestroyRoomData.mySeat 		= mySeat;

	this.myseflDissolveTimes = 0

	--处理补牌
	this.SetBuGangData(this.GetPlayerDataBySeat(mySeat));

	--DestroyRoomData.roomData.dissolution = dissolution;
	--print('destroyroom countdown time is:'..dissolution.remainMs)
	--print("dissolution.remainMs@@@  ",dissolution.remainMs)
	if dissolution.remainMs > 0 then
		DestroyRoomData.roomData.dissolution.remainMs = getIntPart(dissolution.remainMs/1000);
		this.SetDestoryPanelShow();
	else
		PanelManager.Instance:HideWindow('panelDestroyRoom')
	end

	this.SetRestTime();

	

	RoundAllData.over = false
	PanelManager.Instance:HideWindow("panelsuddenBonus");
	this.SetRoundNum(roomData.round);
	this.SetDipaiNum(roomData.surplus)
	this.RefreshPlayer();
	this.SettingText();
	this.SetReadyVisiable();
	this.RsetWhenJionRoom();
	this.CheckStartPiaoFen();
	this.VoiceCoroutineInit();
	if roomData.state == 2 then
		this.SetInviteVisiable(false)
	else
		if roomData.round > 1 then
			this.SetInviteVisiable(false)
		else
			this.SetInviteVisiable(#playerData ~= (roomData.setting.size) or (not this.GetPlayerDataBySeat(mySeat).ready) or not this.IsAllReaded())
		end
	end

		--处理听牌
	if body.seat == mySeat  then
		local tingMahjongs = this.GetPlayerDataBySeat(mySeat).tingMahjongs;
		if tingMahjongs and #tingMahjongs > 0 and  #this.GetPlayerDataBySeat(mySeat).tingTip <=0 then
			playerTingButton.gameObject:SetActive(true);
			--print("#tingMahjongs:"..(#tingMahjongs));
			this.needKeep = true;
			SetUserData(playerTingButton.gameObject, tingMahjongs);
			playerTingButton:Find("frame").gameObject:SetActive(false);
			this.SetNewTingScrollView(tingMahjongs)
			newTingOperation.gameObject:SetActive(true);
		else
			playerTingButton.gameObject:SetActive(false);
			newTingOperation.gameObject:SetActive(false);
			this.needKeep = false;
		end

		--处理提牌
		this.SetTiPlateMark(playerGridHand[0],this.GetPlayerDataBySeat(mySeat).mahjongs,this.GetPlayerDataBySeat(mySeat).tingTip);
		this.SetTiPlateMark(playerCurMoPi[0],{this.GetPlayerDataBySeat(mySeat).moMahjong},this.GetPlayerDataBySeat(mySeat).tingTip);
		tingData = this.GetPlayerDataBySeat(mySeat).tingTip;
	end




	--显示GPS信息
	print("roomData.state == csm_pb.READYING"..tostring(roomData.state == csm_pb.READYING).."|roomData.round="..roomData.round);
	GPS.gameObject:SetActive(roomData.state == csm_pb.READYING and roomData.round == 1);
	this.GPSRefresh();

	--设置飘分
	--piaofendlg.gameObject:SetActive(false)
end

function this.SetNewTingScrollView(tingMahjongs)
    if not tingMahjongs then return end;
    local bg        = newTingOperation:Find("bg");
    local tingGrid  = newTingOperation:Find("Grid");
    --先隐藏
    for i=0,tingGrid.childCount-1 do
        tingGrid:GetChild(i).gameObject:SetActive(false);
    end

    local realWidth = #tingMahjongs * tingGrid:GetComponent("UIGrid").cellWidth;
	local itemPrefab = newTingOperation:Find("cardItem");
	if #tingMahjongs>=21 then
		bg:GetComponent("UISprite").width=1482
	else	
		bg:GetComponent("UISprite").width = realWidth + 110;
	end
    for i=1,#tingMahjongs do
        local cardItem = nil;
        if i > tingGrid.childCount then 
            cardItem = NGUITools.AddChild(tingGrid.gameObject,itemPrefab.gameObject);
        else
            cardItem = tingGrid:GetChild(i-1).gameObject;
        end
        cardItem:SetActive(true);
        SetUserData(cardItem.gameObject,tingMahjongs[i]);
        local cardBg = cardItem.transform:GetComponent("UISprite");
        local cardPlate = cardItem.transform:Find("card"):GetComponent("UISprite");
        cardBg.spriteName = this.getColorCardName(CONST.cardPrefabHandStandBg[1],cardColor);
        cardPlate.spriteName = this.GetCardTextName(tingMahjongs[i].mahjong,cardText);
    end

	tingGrid:GetComponent('UIPanel').clipOffset=Vector2(0,0)
	tingGrid.localPosition=Vector3(-56,0,0)
    tingGrid:GetComponent("UIGrid"):Reposition();
	tingGrid:GetComponent('UIScrollView'):ResetPosition()
end

--设置离解散还剩余的时间
local restTime = 0;
local RefeshTimeCoroutine;
function this.SetRestTime()
	if roomData.state == csm_pb.READYING and roomData.clubId ~= "0" and roomData.round == 1  then
		restTime = roomData.time/1000 -- 600 - os.time() + roomData.time;
		print('时间：'..roomData.time);
		RestTime:Find("Time"):GetComponent('UILabel').text = os.date("%M:%S", restTime);
		RestTime.gameObject:SetActive(true);
		if RefeshTimeCoroutine == nil then
			RefeshTimeCoroutine = coroutine.start(this.RefreshTime, RestTime:Find("Time"):GetComponent('UILabel'));
		end
	else
		RestTime.gameObject:SetActive(false);
	end
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

--展示等待时候的UI
function this.ShowWaittingUI(state)
	print("ShowWaittingUI was called:")
	local show = not this.NeedShowDiPai();
	print("show:"..tostring(show).."|IsAllReaded:"..tostring(this.IsAllReaded()))
	ButtonReady.gameObject:SetActive(not this.GetPlayerDataBySeat(mySeat).ready);
	--ButtonExitRoom.gameObject:SetActive(true);
	roomSetting.gameObject:SetActive(show);
	this.SetGameTypePos();
end

--隐藏等待的UI
function this.HideWaittingUI()
	print("HideWaittingUI was called");
	ButtonReady.gameObject:SetActive(false);
	--ButtonExitRoom.gameObject:SetActive(false);
	--roomSetting.gameObject:SetActive(false)
	this.SetGameTypePos();
	RestTime.gameObject:SetActive(false);
end

function this.SetInviteVisiable(show)
	--print('SetInviteVisiable:'..tostring(show))
	--if show then
		--ButtonCloseRoom.gameObject:SetActive(mySeat == 0)
		--ButtonExitRoom.gameObject:SetActive(mySeat ~= 0)
	--else
		ButtonCloseRoom.gameObject:SetActive(show)
		ButtonExitRoom.gameObject:SetActive(show)
	--end

	if not PlatformManager.Instance:IsWXAppInstalled() then
		show = false
	end
	-- if roomData.clubId ~= '0' then                      -- 在牌友群房主不饿能返回大厅
	-- 	ButtonExitRoom.gameObject:SetActive(false)
	-- end
	ButtonInvite.gameObject:SetActive(show)
	if mySeat == 0 then
		ButtonCloseRoom:Find('Label'):GetComponent("UILabel").text = "解散房间"
	else
		ButtonCloseRoom:Find('Label'):GetComponent("UILabel").text = "退出房间"
	end
	ButtonInvite.parent:GetComponent("UIGrid"):Reposition()
end

function this.SettingText()

	--print("SettingText was called");

	roomSetting:Find('Label'):GetComponent('UILabel').text = GetMJRuleText(roomData.setting,false,false);
	gameTypeobj:Find("playName"):GetComponent("UILabel").text = roomData.playName;

end

function this.BirdTitle(num)
	local result = ""
	if num == 0 then
		result = "不抓"
	elseif num == 1 then
		result = "单"
	elseif num == 2 then
		result = "双"
	elseif num == 4 then
		result = "四"
	end
	return result .. "鸟"
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

--通过playerSize 将UI上的index转换成特殊的UI上的index
function this.GetUIIndex(index,playerSize)
	if playerSize == 2 then
		if index ==1 then
			return 2;
		else
			return index;
		end
	elseif playerSize == 3 then
		if index == 2 then
			return 3;
		else
			return index;
		end
	else
		return index;
	end

end

function this.GetPlayerDataBySeat(seat)
	for i=1,#playerData do
		if playerData[i].seat == seat then
			return playerData[i]
		end
	end
	
	return nil
end

--填充座位上的玩家数据
function this.RefreshPlayer()

	function SetPlayerState(index,p)
		playerName[index].gameObject:SetActive(true)
		playerName[index]:GetComponent('UILabel').text = p.name;
        coroutine.start(LoadPlayerIcon, playerIcon[index]:GetComponent('UITexture'), p.icon);
		SetUserData(playerIcon[index].gameObject, p);
		playerScore[index].gameObject:SetActive(true);
		playerScore[index]:GetComponent('UILabel').text = p.score;
		playerMaster[index].gameObject:SetActive(roomData.bankerSeat == p.seat);
		
		this.setLessPlayerStart(index, p.minorityValue)--设置少人功能显示

		--设置飘分
		playerPiaoFen[index].gameObject:SetActive(true);
		if roomData.setting.fixedFloatScore~=0 then
			playerPiaoFen[index].gameObject:SetActive(true);
			playerPiaoFen[index]:GetComponent('UILabel').text = "飘"..roomData.setting.fixedFloatScore.."分"
		elseif roomData.setting.floatScore then
			--print("player["..index.."] playerScore:"..p.floatScore);

			if p.floatScore == -1 then
				playerPiaoFen[index]:GetComponent('UILabel').text = "";
			elseif p.floatScore == 0 then
				playerPiaoFen[index]:GetComponent('UILabel').text = "不飘分";
			else
				playerPiaoFen[index]:GetComponent('UILabel').text = "飘"..p.floatScore.."分"
			end

		else
			playerPiaoFen[index]:GetComponent('UILabel').text = ""
		end

		local bWait = (roomData.round ==1 and roomData.state ~= csm_pb.GAMING)--csm_pb.WAITING --等待的时候 隐藏背景和分数
		print("是不是等待状态 ",bWait,roomData.state)
		playerHeadBGObj[index].gameObject:SetActive(not bWait)
		playerScore[index].gameObject:SetActive(not bWait)
		playerTrusteeship[index].gameObject:SetActive(p.trusteeship)
		playerOfflineTime[index].gameObject:SetActive(false)
		if p.disconnectTimes ~= nil and p.disconnectTimes ~= 0 then
			print("p.disconnectTimes:---------->"..tostring(p.disconnectTimes));
			this.StartOfflineIncrease(p.seat, p.disconnectTimes)
		end
	end

	function hidePlayerState(index,p)
		playerName[index].gameObject:SetActive(false)
		playerIcon[index]:GetComponent('UITexture').mainTexture = nil
		playerScore[index].gameObject:SetActive(false)
		playerMaster[index].gameObject:SetActive(false)
		playerPiaoFen[index].gameObject:SetActive(false);
		playerPiaoFen[index]:GetComponent('UILabel').text = "";
		playerOffline[index].gameObject:SetActive(false)
		playerTrusteeship[index].gameObject:SetActive(false)
		playerOfflineTime[index].gameObject:SetActive(false)
		SetUserData(playerIcon[index].gameObject, nil)
	end

	function hideSoundState(index)
		playerSound[index].gameObject:SetActive(false)
		playerMoPaiPos[index].gameObject:SetActive(false)
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

end

function this.OnPlayerEnter(msg)
	--print('OnPlayerEnter---------------------------->')
	local b = csm_pb.RPlayer();
	b:ParseFromString(msg.body);
	b.connected = true;
	b.disconnectTimes = 0;
	this.StopOfflineIncrease(b.seat)
	table.insert(playerData, b);
	function setEnterState(index,b)
		playerOffline[index].gameObject:SetActive(false);
		playerReady[index].gameObject:SetActive(false);
		b.ready = false
	end

	local index = this.GetUIIndexBySeat(b.seat);

	setEnterState(this.GetUIIndex(index,playerSize),b);
    this.RefreshPlayer()
	AudioManager.Instance:PlayAudio('audio_enter')
end

function this.OnPlayerJion(msg)
	--print('OnPlayerJion----------------------------------------->')
	local b = csm_pb.RPlayerJoin();
	b:ParseFromString(msg.body);
	local pData = this.GetPlayerDataBySeat(b.seat);
	pData.connected = true;
	pData.ip = b.ip;
	pData.ready = b.ready;
	pData.disconnectTimes = 0;
	--print('OnPlayerJion座位号' .. b.seat);
	if b.longitude and b.longitude ~= 0 then
		this.GetPlayerDataBySeat(b.seat).longitude = b.longitude
		this.GetPlayerDataBySeat(b.seat).latitude = b.latitude
	else
		this.GetPlayerDataBySeat(b.seat).longitude = 0
		this.GetPlayerDataBySeat(b.seat).latitude = 0
	end
	if b.address and b.address ~= "" then
		this.GetPlayerDataBySeat(b.seat).address = b.address
	else
		this.GetPlayerDataBySeat(b.seat).address = "未获取到该玩家位置"
	end
	print("这个玩家的经纬度位置为 ",b.longitude,b.latitude,b.address)


	local index = this.GetUIIndexBySeat(b.seat);
	playerOffline[this.GetUIIndex(index,playerSize)].gameObject:SetActive(false);

	
	this.SetReadyVisiable()
	this.RefreshPlayer()
	this.GPSRefresh();
	this.NotifyGameStart()

	this.StopOfflineIncrease(b.seat)
end

function this.OnLeaveRoom(msg)
	print('OnLeaveRoom')

	NetWorkManager.Instance:DeleteConnect('game');
	PanelManager.Instance:HideAllWindow()
	panelLogin.HideGameNetWaitting();
	if roomData.clubId ~= '0' then
        local data = {}
        data.name = 'panelInGamemj'
		-- data.clubId = roomData.clubId
		PanelManager.Instance:ShowWindow('panelClub', data)
	else
		PanelManager.Instance:ShowWindow('panelLobby')
	end
	roomData.clubId = '0'
end

function this.OnPlayerLeave(msg)
	print('OnPlayerLeave');
	local b = csm_pb.RSeat();
	b:ParseFromString(msg.body)
    for i=#playerData,1,-1 do
		if playerData[i].seat == b.seat then
			table.remove(playerData, i)
			break
		end
	end
	local index = this.GetUIIndexBySeat(b.seat);

	playerReady[this.GetUIIndex(index,playerSize)].gameObject:SetActive(false);
	this.RefreshPlayer();
	this.GPSRefresh();
end


function this.RefreshGridHandByIndex(index, uiIndex, plates, mahjongCount, isReplay, moMahjong, DownCards)
	this.RefreshGridHand(playerGridHand[this.GetUIIndex(index,playerSize)], this.GetUIIndex(index,playerSize), plates, mahjongCount, isReplay, moMahjong, DownCards);

end



--刷新手中的牌
function this.RefreshGridHand(GridHand, uiIndex, plates, mahjongCount, isReplay, moMahjong, DownCards)
	print("uiIndex:"..uiIndex.."|plates.length:"..#plates.."|mahjongCount:"..mahjongCount);
	--print("RefreshGridHand was called-------------------------------------->");
	--处理手上拖拽出去那张牌，要隐藏
	if uiIndex == 0 then
		--还原层级代码
		if draggingObject then
			draggingObject:GetComponent("UISprite").depth = dragCardFrameDepth;
			draggingObject.transform:Find("card"):GetComponent("UISprite").depth = dragCardDepth;
		end
	end
	if uiIndex == 0 then
		table.sort(plates, tableSortDesc);
		----处理红中
		local hongzhongCount = GetMJPlateCount(plates,HongzhongPlateValue);
		tableRemoveByKeys(plates,getRemoveKeys({HongzhongPlateValue}));
		for i = 1, hongzhongCount do
			tableAdd(plates,{HongzhongPlateValue});
		end

	else
		table.sort(plates, tableSortAsc);
	end

	local down = #DownCards > 0
	if moMahjong ~= -1 then
		--print("seat"..uiIndex.."hava moMajian:"..moMahjong);
		if uiIndex == 0 and #plates >= mahjongCount then
			for i=1,#plates do
				if moMahjong == plates[i] then
					plates:remove(i)
					break
				end
			end
		else
			mahjongCount = mahjongCount-1
		end
	end
	if uiIndex == 0 then
		mahjongCount = #plates
	end

	local prefabName = CONST.cardPrefabHand[uiIndex+1]

	-- --print('hand plates num:'..#plates..' mahjongCount:'..mahjongCount..' prefabName:'..prefabName..' DownCards:'..#DownCards)
	for j=GridHand.childCount,mahjongCount-1 do
		local cardGroupHand = ResourceManager.Instance:LoadAssetSync(prefabName)
		local obj = NGUITools.AddChild(GridHand.gameObject, cardGroupHand)
		obj.name = prefabName
		if uiIndex == 1 then
			obj:GetComponent('UISprite').depth = 20-j
			obj.transform:Find('card'):GetComponent('UISprite').depth = 20-j+1
		end
		if not isReplay then
			UIEventListener.Get(obj.gameObject).onDragStart = this.OnDragStartPlate;
			UIEventListener.Get(obj.gameObject).onDrag = this.OnDragging;
			UIEventListener.Get(obj.gameObject).onDragEnd = this.OnDragEndtPlate;
			UIEventListener.Get(obj.gameObject).onDoubleClick = this.OnDoubleClickPlate;
			UIEventListener.Get(obj.gameObject).onClick = this.OnClickMahjong;
		end
	end

	local itemSp,itemChilSp
	for i=0,GridHand.childCount-1 do
		if i < mahjongCount then
			local item = GridHand:GetChild(i)
			item.name = prefabName..i
			item.gameObject:SetActive(true);
			itemSp = item:GetComponent('UISprite');
			itemChilSp = item:Find('card'):GetComponent('UISprite');
			itemSp.spriteName = this.getColorCardName(CONST.cardPrefabHandStandBg[uiIndex+1],cardColor);
			itemChilSp.gameObject:SetActive(false)
			if GridHand == playerGridHand[0] then
				itemChilSp.gameObject:SetActive(true)
				itemChilSp.spriteName = this.GetCardTextName(plates[i+1],cardText);
				SetUserData(item.gameObject, plates[i+1])
				itemChilSp.transform.localPosition = CONST.cardPrefabHandStandOffset[uiIndex+1]
				--设置牌面值
				itemChilSp.transform:GetComponent("UISprite").width = this.GetCardPlateSize(plates[i+1],cardText).x;
				itemChilSp.transform:GetComponent("UISprite").height = this.GetCardPlateSize(plates[i+1],cardText).y;
			end

			--胡牌倒下
			if down then
				for j=#DownCards,1,-1 do
					if DownCards[j] == plates[i+1] or uiIndex ~= 0 then
						itemSp.spriteName = this.getColorCardName(CONST.cardPrefabHandDownBg[uiIndex+1],cardColor);
						itemChilSp.gameObject:SetActive(true)
						itemChilSp.spriteName = this.GetCardTextName(DownCards[j],cardText);
						itemChilSp.transform.localPosition = CONST.cardPrefabHandDownOffset[uiIndex+1]
						table.remove(DownCards, j)
						if uiIndex ~= 0 then
							itemSp.width = CONST.cardDownSize[uiIndex+1].x;
							itemSp.height = CONST.cardDownSize[uiIndex+1].y;
							--itemChilSp:MakePixelPerfect()
						end
						break;
					end
				end
			else
				if uiIndex ~= 0 then
					itemSp:MakePixelPerfect();
					--itemSp.width = CONST.cardDownSize[uiIndex+1].x;
					--itemSp.height = CONST.cardDownSize[uiIndex+1].y;
					--itemChilSp:MakePixelPerfect();
				end
			end
		else
			GridHand:GetChild(i).gameObject:SetActive(false)
		end
	end
	if not down then
		GridHand:GetComponent('UIGrid').cellWidth = CONST.cardPrefabHandStandGridCell[uiIndex+1].x
		GridHand:GetComponent('UIGrid').cellHeight = CONST.cardPrefabHandStandGridCell[uiIndex+1].y
	else
		GridHand:GetComponent('UIGrid').cellWidth = CONST.cardPrefabHandDownGridCell[uiIndex+1].x
		GridHand:GetComponent('UIGrid').cellHeight = CONST.cardPrefabHandDownGridCell[uiIndex+1].y
	end




	StartCoroutine(function()
		WaitForSeconds(0.02);
		--WaitForEndOfFrame();
		--GridHand:GetComponent('UIGrid'):Reposition();
		GridHand:GetComponent('UIGrid').repositionNow = true;
	end);

	local pos = GridHand.localPosition;
	local gridcellWidth = GridHand:GetComponent('UIGrid').cellWidth
	local gridcellHeight = GridHand:GetComponent('UIGrid').cellHeight
	if uiIndex == 0 then
		--pos.x = GridHand.localPosition.x + (gridcellWidth * mahjongCount) - gridcellWidth*0.5 +75;
		pos.y = GridHand.localPosition.y;
		pos.x = playerCurMoPi[uiIndex].localPosition.x;
	elseif uiIndex == 1 then
		pos.y = GridHand.localPosition.y - (gridcellHeight * mahjongCount) + gridcellHeight*0.5  + 50
	elseif uiIndex == 2 then
		pos.x = GridHand.localPosition.x - (gridcellWidth * mahjongCount) + gridcellWidth*0.5 - 12
	else
		pos.y = GridHand.localPosition.y - (gridcellHeight * mahjongCount) + gridcellHeight*0.5 - 50
	end
	playerCurMoPi[uiIndex].localPosition = pos;

	--清除手牌的颜色
	if uiIndex == 0 then
		this.SetPlateUIColor(playerGridHand[0], {}, false);
	end

end



function this.RefreshAllGridHand()
	--print("RefreshAllGridHand was called")
	for i=0,playerSize-1 do
		--把手牌的grid位置还原
		-- playerGridHand[i].localPosition = playerHandGridPos[i];
		local pData = this.GetPlayerDataByUIIndex(i)
		if pData and i < playerSize then
			
			local cards = {}
			for i = 1, #pData.categories do
				if pData.categories[i].category == 3 or pData.categories[i].category == 4 then
					cards = tableClone(pData.categories[i].mahjongs)
				elseif #cards < 14 then
					tableMerge(cards, pData.categories[i].mahjongs)
				end
			end
			this.RefreshGridHand(playerGridHand[this.GetUIIndex(i,playerSize)], this.GetUIIndex(i,playerSize), pData.mahjongs, pData.mahjongCount, false, pData.moMahjong, cards);
			playerGridHand[this.GetUIIndex(i,playerSize)].gameObject:SetActive(true);

		else
			playerGridHand[this.GetUIIndex(i,playerSize)].gameObject:SetActive(false);

		end
	end
end

--刷新玩家手上的摸牌
function this.RefreshAllCurMoPai()
	--print("RefreshAllCurMoPai was called!");
	local index = -1
	local mahjong = -1
	for i=0,playerSize-1 do
		local pData = this.GetPlayerDataByUIIndex(i)
		if pData  and pData.moMahjong ~= -1 then
			print('RefreshAllCurMoPai player:'..pData.name..' mopai:'..pData.moMahjong)
			index = i
			mahjong = pData.moMahjong
			break
		end
	end
	--print("RefreshCurMoPai before,index:"..index.." playerSize:"..playerSize);
	this.RefreshCurMoPai(index, mahjong);
end

function this.RefreshCurMoPai(index, plate, down)
	--print("RefreshCurMoPai was called index:"..index.." plate:"..plate.." down:"..tostring(down).." playerSize:"..playerSize);
	--print("findbefore--->GetUIIndex:"..this.GetUIIndex(index,playerSize));
	for i=0,playerSize-1 do
		if i == index then
			this.SetCurMoPai(this.GetUIIndex(index,playerSize),this.GetUIIndex(index,playerSize),plate,down);

		else
			playerCurMoPi[this.GetUIIndex(i,playerSize)].gameObject:SetActive(false);
		end
	end
end

--设置当前的摸牌
--down表示是否是展示：比如胡牌的时候，down=true
function this.SetCurMoPai(i,index,plate,down)
	playerCurMoPi[i].gameObject:SetActive(true);
	playerCurMoPi[i]:Find("curMoPai").gameObject:SetActive(true);
	local itemSp = playerCurMoPi[i]:GetChild(0):GetComponent('UISprite');
	local itemChilSp = playerCurMoPi[i]:GetChild(0):Find('card'):GetComponent('UISprite');
	itemChilSp.gameObject:SetActive(down or i == 0);--摸牌只能自己看到
	if not down then
		itemSp.spriteName = this.getColorCardName(CONST.cardPrefabHandStandBg[i+1],cardColor);
		if i == 0 then
			itemChilSp.spriteName = this.GetCardTextName(plate,cardText);
			SetUserData(itemSp.gameObject, plate)
			itemChilSp.width = this.GetCardPlateSize(plate,cardText).x;
			itemChilSp.height = this.GetCardPlateSize(plate,cardText).y;
		end
		itemChilSp.transform.localPosition = CONST.cardPrefabHandStandOffset[i+1];
		
		if index ~= 0 then
			itemSp:MakePixelPerfect()
			--itemChilSp:MakePixelPerfect()
		end

	else
		itemSp.spriteName = this.getColorCardName(CONST.cardPrefabHandDownBg[i+1],cardColor);
		itemChilSp.spriteName = this.GetCardTextName(plate,cardText);
		itemChilSp.transform.localPosition = CONST.cardPrefabHandDownOffset[i+1];

		if index ~= 0 then
			itemSp.width = CONST.cardDownSize[index+1].x;
			itemSp.height = CONST.cardDownSize[index+1].y;
			--itemChilSp:MakePixelPerfect()
		end

	end

end


--根据颜色值获取麻将牌的名称
function this.getColorCardName(name,colorIndex)
	if colorIndex == 1 then --绿色
		return name;
	elseif colorIndex == 2 then --黄色
		return name..'y';
	end
end

--根据用户选择选择麻将的牌面
function this.GetCardTextName(plateIndex,cardTextIndex)
	--这里需要说明：换牌面只换“万”字，从一万到9万(废弃了)
	--print(("plateIndex:"..plateIndex);
	--print(("cardTextIndex:"..cardTextIndex);
	return tostring(plateIndex);
	

end

--根据用户的选择选择牌面大小
function this.GetCardPlateSize(plateIndex,cardTextIndex)
	--print("plateIndex:"..plateIndex.."|cardTextIndex:"..cardTextIndex);
	if cardTextIndex == 2 then 
		return CONST.cardStandWanScaleWidth[2];
	else
		if plateIndex <=8 then 
			return CONST.cardStandWanScaleWidth[1];
		else
			return CONST.cardStandTongTiaoScaleWidth[1];
		end
	end
end

function this.RefreshGridXiByIndex(index,operationCards)
	this.RefreshGridXi(playerGridXi[this.GetUIIndex(index,playerSize)],operationCards);

end

function this.RefreshGridXi(grid, operationCards)
	local prefabName = 'cardZuoButtom';
	local downSpriteName = 'mj_04';
	local upSpriteName = 'mj_01';
	local uiIndex = 0
	if grid == playerGridXi[0] then
		prefabName = 'cardZuoButtom'
		uiIndex = 0
		upSpriteName = 'mj_01';
		downSpriteName = 'mj_04';
	elseif grid == playerGridXi[1]  then
		prefabName = 'cardZuoRight'
		uiIndex = 1
		upSpriteName = 'mj_07';
		downSpriteName = 'mj_08';
	elseif grid == playerGridXi[2]  then
		prefabName = 'cardZuoTop'
		uiIndex = 2
		upSpriteName = 'mj_09';
		downSpriteName = 'mj_04';
	else
		prefabName = 'cardZuoLeft'
		uiIndex = 3
		upSpriteName = 'mj_07';
		downSpriteName = 'mj_08';
	end

	local leftCards = { }

	if not operationCards then
		return ;
	end

	for i = 1, #operationCards do
		local operation_type = operationCards[i].operation;
		local op_cards = operationCards[i].cards;
		if operation_type == csm_pb.SORT_CHI then
			table.insert(leftCards, {operation = csm_pb.CHI, plates={op_cards[1] , op_cards[2], op_cards[3]}});
		elseif operation_type == csm_pb.SORT_PENG then
			table.insert(leftCards, {operation = csm_pb.PENG, plates={op_cards[1] , op_cards[1], op_cards[1]}});
		elseif operation_type == csm_pb.SORT_MING then
			table.insert(leftCards, {operation = csm_pb.GANG, plates={op_cards[1], op_cards[1], op_cards[1], op_cards[1]}, state = csm_pb.MING});
		elseif operation_type == csm_pb.SORT_DARK then
			table.insert(leftCards, {operation = csm_pb.GANG, plates={op_cards[1], op_cards[1], op_cards[1], op_cards[1]}, state = csm_pb.AN});
		elseif operation_type == csm_pb.SORT_DIAN then
			table.insert(leftCards, {operation = csm_pb.GANG, plates={op_cards[1], op_cards[1], op_cards[1], op_cards[1]}, state = csm_pb.DIAN});
		end

	end

	for j=grid.childCount, #leftCards-1 do
		local cardGroupXi = ResourceManager.Instance:LoadAssetSync(prefabName)
		local obj = NGUITools.AddChild(grid.gameObject, cardGroupXi)
	end
	for i=0,grid.childCount-1 do
		if i < #leftCards then
			local group = leftCards[i+1]
			local item = grid:GetChild(i)
			for j=0,item.childCount-1 do
				if j < #group.plates then
					local show = true --明杠：下面三张，上面一张，四张全部正面朝上 点杠：下面三张朝上，上面一张朝下 暗杠：下面三张朝下，上面一张朝上
					if j < 3  then
						if group.state == csm_pb.AN then
							show = false
						end
					else
						if group.state == csm_pb.MING then
							show = false;
						end
					end
					if not show then
						item:GetChild(j):GetComponent('UISprite').spriteName = this.getColorCardName(downSpriteName,cardColor);
						item:GetChild(j):GetChild(0).gameObject:SetActive(false)
					else
						item:GetChild(j):GetComponent('UISprite').spriteName = this.getColorCardName(upSpriteName,cardColor);
						item:GetChild(j):GetChild(0):GetComponent('UISprite').spriteName = this.GetCardTextName(group.plates[j+1],cardText);
						item:GetChild(j):GetChild(0).gameObject:SetActive(true)
					end
					item:GetChild(j).gameObject:SetActive(true)
				else
					item:GetChild(j).gameObject:SetActive(false)
				end
			end
			item.gameObject:SetActive(true)
		else
			grid:GetChild(i).gameObject:SetActive(false)
		end
	end

	StartCoroutine(function()
		WaitForEndOfFrame();
		grid:GetComponent('UIGrid').repositionNow = true;
		WaitForEndOfFrame();
		grid:GetComponent('UIGrid').enabled = false;
		grid:GetComponent('UIGrid').enabled = true;
	end);


	--
	local pos = playerGridHand[uiIndex].localPosition;
	local gridcellWidth = grid:GetComponent('UIGrid').cellWidth
	local gridcellHeight = grid:GetComponent('UIGrid').cellHeight
	if uiIndex == 0 then
		--if #leftCards > 0 then --有碰吃杠的时候才通过下面逻辑来对齐
		--    pos.x = grid.localPosition.x + (#leftCards > 0 and  gridcellWidth * (#leftCards - 0.5) + 50 or -50)
		--else
		--    -- pos.x = 601;--暂时这样设置TODO（后面需要修改）
		--    pos = playerHandGridPos[uiIndex];
		--end
	elseif uiIndex == 1 then
		if #leftCards > 0 then
			pos.y = grid.localPosition.y + (gridcellHeight * #leftCards) - gridcellHeight*0.5 + 20
		else
			pos = playerHandGridPos[uiIndex];
		end
	elseif uiIndex == 2 then
		if #leftCards > 0 then
			pos.x = grid.localPosition.x -  gridcellWidth * #leftCards  + 110;
		else
			pos = playerHandGridPos[uiIndex];
		end

	else
		if #leftCards > 0 then
			pos.y = grid.localPosition.y - (gridcellHeight * #leftCards) + gridcellHeight*0.5-45
		else
			pos = playerHandGridPos[uiIndex];
		end

	end
	if uiIndex ~=0 then
		playerGridHand[uiIndex].localPosition = pos;
	end


end

function this.RefreshAllGridXi()
	-- --print("RefreshAllGridXi was called");
	for i=0,playerSize-1 do
		local pData = this.GetPlayerDataByUIIndex(i)
		if pData then
			this.RefreshGridXi(playerGridXi[this.GetUIIndex(i,playerSize)], pData.operationCards)
		else
			this.RefreshGridXi(playerGridXi[this.GetUIIndex(i,playerSize)], {});
		end

	end

	
end

function this.RefreshTabelThrowByIndex(index, plates, seat)
	--print("RefreshTabelThrowByIndex:index:"..index..",seat:"..seat);
	this.RefreshTabelThrow(playerThrow[this.GetUIIndex(index,playerSize)], plates, seat);


end
	

function this.RefreshTabelThrow(UItabel, plates, seat)
	-- --print("RefreshTabelThrow was called,cardColor:"..cardColor);
	local prefabName = 'cardPaiHeButtom'
	local throwCardIndex = 1;
	if UItabel == playerThrow[0] then
		prefabName = 'cardPaiHeButtom';
		throwCardIndex = 1;
	elseif UItabel == playerThrow[1]  then
		prefabName = 'cardPaiHeRight';
		throwCardIndex = 2;
	elseif UItabel == playerThrow[2]  then
		prefabName = 'cardPaiHeTop';
		throwCardIndex = 3;
	else
		prefabName = 'cardPaiHeLeft'
		throwCardIndex = 4;
	end
	--print(string.format('RefreshTabelThrow:%s num:%d prefabName:%s' ,UItabel.parent.gameObject.name, #plates, prefabName))
	for j=UItabel.childCount,#plates-1 do
		local card = ResourceManager.Instance:LoadAssetSync(prefabName)
		local rot = card.transform.localRotation
		local obj = NGUITools.AddChild(UItabel.gameObject, card)
		obj.transform.localRotation = rot;
	end


	--如果是两个人打，那么牌桌上的牌20张再换行
	if prefabName == 'cardPaiHeTop' then
		local tableGrid = UItabel:GetComponent('UIGrid');
		if playerSize == 2 then

			tableGrid.maxPerLine = 20;
			UItabel.localPosition.x = 424;
			UItabel.localPosition = Vector3(424,196,0);
		else
			tableGrid.maxPerLine = 12;
			UItabel.localPosition = playerTableThrowGridPos[2];
		end
	elseif prefabName == 'cardPaiHeButtom' then
		local tableGrid = UItabel:GetComponent('UIGrid');
		if playerSize == 2 then
			tableGrid.maxPerLine = 20;
			UItabel.localPosition.x = -501;
			UItabel.localPosition = Vector3(-501,UItabel.localPosition.y,0);
		else
			tableGrid.maxPerLine = 12;
			UItabel.localPosition = playerTableThrowGridPos[0];
		end
	end
	for i=0,UItabel.childCount-1 do
		if i < #plates then
			local item = UItabel:GetChild(i);
			this.SetPlateColor(item.gameObject,false);
			item:GetComponent('UISprite').spriteName = this.getColorCardName(CONST.cardPrefabHandDownBg[throwCardIndex],cardColor);
			item:Find('card'):GetComponent('UISprite').spriteName = this.GetCardTextName(plates[i+1],cardText);
			SetUserData(item.gameObject, plates[i+1]);
			-- print("prefabName="..prefabName);
			if  prefabName == 'cardPaiHeLeft' then
				item:GetComponent('UISprite').depth = i+2;
				item:Find('card'):GetComponent('UISprite').depth = i+3;
			elseif prefabName == 'cardPaiHeRight'  then
				item:GetComponent('UISprite').depth = 50-i-1
				item:Find('card'):GetComponent('UISprite').depth = 50-i
			elseif prefabName == 'cardPaiHeButtom'   then
				if i > UItabel:GetComponent('UIGrid').maxPerLine-1 then
					local maxPerLine = UItabel:GetComponent('UIGrid').maxPerLine;
					item:GetComponent('UISprite').depth = 5- math.floor(i/maxPerLine);
				else
					item:GetComponent('UISprite').depth = 5;
				end

			end
			-- StartCoroutine(function()
			-- 	WaitForEndOfFrame();
			-- 	item.gameObject:SetActive(true);
			-- end);
			item.gameObject:SetActive(true);

		else
			UItabel:GetChild(i).gameObject:SetActive(false)
		end


	end
	UItabel:GetComponent('UIGrid'):Reposition();


end

function this.SetPlateEffectShowByIndex(index,plates, seat)
	this.SetPlateEffectShow(playerThrow[this.GetUIIndex(index,playerSize)], plates, seat);

end

function this.SetPlateEffectShow(UItabel, plates, seat)
	if seat == lastOperat.seat and plates[#plates] == lastOperat.plate[1] then
		curOperatPlateEffect.gameObject:SetActive(true)
		curOperatPlateEffect.position = UItabel:GetChild(#plates-1).position;

		StartCoroutine(function ()
			WaitForEndOfFrame();
			local itemPos = UItabel:GetChild(#plates-1).position;
			if math.abs(curOperatPlateEffect.position.x - itemPos.x)>3 then
				curOperatPlateEffect.position = itemPos;
			end
			if math.abs(curOperatPlateEffect.position.y - itemPos.y)>3 then
				curOperatPlateEffect.position = itemPos;
			end
		end);
		
		----print('seat:'..seat..' plate:'..plates[#plates])
		----print('plate pos:'..UItabel:GetChild(#plates-1).localPosition.x..' '..UItabel:GetChild(#plates-1).localPosition.y..' '..UItabel:GetChild(#plates-1).localPosition.z)
	end	
end

function this.RefreshAllTabelThrow()
	-- --print("RefreshAllTabelThrow was called");
	for i=0,playerSize-1 do
		local pData = this.GetPlayerDataByUIIndex(i)
		if pData and i < playerSize then

			playerThrow[this.GetUIIndex(i,playerSize)].gameObject:SetActive(true);
			this.RefreshTabelThrow(playerThrow[this.GetUIIndex(i,playerSize)], pData.paiHe, pData.seat);
			this.SetPlateEffectShow(playerThrow[this.GetUIIndex(i,playerSize)], pData.paiHe, pData.seat);
		else
			playerThrow[this.GetUIIndex(i,playerSize)].gameObject:SetActive(false);

		end
	end
end





function this.OnDragStartPlate(obj)


	print('OnDragStartPlate:'..tostring(obj));
	dragCardFrameDepth = obj:GetComponent("UISprite").depth;
	dragCardDepth = obj.transform:Find("card"):GetComponent("UISprite").depth;


	this.StartDragMoPai(obj);


	local tingTip = obj.transform:Find("tingTip");
	if tingTip then
		tingTipDepth = tingTip:GetComponent("UISprite").depth ;
		tingTip:GetComponent("UISprite").depth = dragDepthOffset + 2;
	end

	obj:GetComponent("UISprite").depth = dragDepthOffset;
	obj.transform:Find("card"):GetComponent("UISprite").depth =  dragDepthOffset + 1;

	operation_mask.gameObject:SetActive(true);--牌还没有排列好之前，先不能让用户操作，否则会有层级的问题
	--print("operation_mask-------------->2");


	--print("dragStart mahjongs.length:"..(#playerData[1].mahjongs));
	--显示提牌
	if tingTip then
		--拿到听牌集
		local tingMahjongs = GetUserData(tingTip.gameObject);
		if tingMahjongs then
			--print("get user's tingMahjongs--->");
			playerTingButton.gameObject:SetActive(true);
			local bgFrame = playerTingButton:Find("frame");
			bgFrame.gameObject:SetActive(true);
			newTingOperation.gameObject:SetActive(false);
			this.SetTingScrollView(tingMahjongs);
			this.SetNewTingScrollView(tingMahjongs);
			this.needDisappearDragEnd = true;
		end
	end

end





function this.StartDragMoPai(obj)

	this.originDragPos = obj.transform.localPosition;
	IsMoPaiDrag = true;
	draggingObject = obj;

end

function this.MousePosition()
	local  mousePosition = UnityEngine.Input.mousePosition;
	local wroldPosition = UICamera.mainCamera:ScreenToWorldPoint(mousePosition);
	local grid = nil;
	if draggingObject == playerCurMoPi[0]:GetChild(0).gameObject then--是摸得那张牌
		grid = playerCurMoPi[0];
	else
		grid = playerGridHand[0];
	end

	local nguiPosition = grid:InverseTransformPoint(wroldPosition);
	return nguiPosition;
end

function this.DraggingMoPai(obj)
	obj.transform.localPosition = this.MousePosition();
end

function this.DragEndMoPai(obj)
	IsMoPaiDrag = false;
	--curMoPaiObj.transform:SetParent(playerCurMoPi[0]);
	--if obj == playerCurMoPi[0]:GetChild(0).gameObject then
	--
	--end
	obj.transform.localPosition = this.originDragPos;
	draggingObject = nil;

end


function this.OnDragging(obj)

	--print("on draging:.."..tostring(obj).."|pos:"..pos);
	--
	--print("ui depth:"..(obj:GetComponent("UISprite").depth));
	--print("ui depth:"..(obj.transform:Find("card"):GetComponent("UISprite").depth));
	--obj.transform.parent = playerGridHand[0];
	--
	--if obj == playerCurMoPi[0]:GetChild(0).gameObject then
	--	obj.transform.localPosition = Vector3.New(pos.x,pos.y,0);
	--end


end

function this.OnDragEndtPlate(obj)

	print('OnDragEndPlate:obj'..tostring(obj));
	--还原层级代码
	obj:GetComponent("UISprite").depth = dragCardFrameDepth;
	obj.transform:Find("card"):GetComponent("UISprite").depth = dragCardDepth;
	local tingTip = obj.transform:Find("tingTip");
	if tingTip then
		obj.transform:Find("tingTip"):GetComponent("UISprite").depth = tingTipDepth;
	end

	--print("OnDragEndtPlate  needChuPai:"..tostring(needChuPai).." sealPai:"..tostring(this.GetPlayerDataBySeat(mySeat).sealPai));
	if needChuPai and connect.IsConnect and (not this.GetPlayerDataBySeat(mySeat).sealPai) then
		--print(" needChuPai and connect.IsConnect");
		local myData = this.GetPlayerDataBySeat(mySeat);
		if UICamera.currentTouch.dragged.transform.position.y > line.position.y then
			local plate = GetUserData(UICamera.currentTouch.dragged)
			--print('drag card id:'..plate)
			if obj == playerCurMoPi[0]:GetChild(0).gameObject then
				--print("you dragged mopaiGrid--------1");
			else
				--print("you dragged pai!-------1")
				tableRemovePlate(myData.mahjongs,plate);--移除出了的牌
				--把摸到的牌放进手牌中
				if myData.moMahjong and myData.moMahjong ~= -1 then
					myData.mahjongs:append(myData.moMahjong);
				end
			end
			print("出的牌是:"..plate);
			this.SendChuPaiMsg(plate, UICamera.currentTouch.dragged);
			obj:SetActive(false);

			--print("set drag obj:"..obj.name.." plateDragFinished = "..tostring(true));

		else--如果牌没有打出去，那么继续显示提牌
			obj:SetActive(true);
			--print("set drag obj:"..obj.name.." plateDragFinished = "..tostring(false));
			if tingTip then
				this.SetTiPlateMark(playerGridHand[0],myData.mahjongs,tingData);
			end

		end
		--清空点击的牌
		lastSelectmahjong = nil;

	end

	this.DragEndMoPai(obj);
	local obj = UICamera.currentTouch.dragged
	if obj then
		coroutine.start(
				function()
					coroutine.wait(1)
					if obj.transform:GetComponent('BoxCollider') then
						obj.transform:GetComponent('BoxCollider').enabled = true
					end
				end
		)
	end

	local pData = this.GetPlayerDataBySeat(mySeat);

	--当不是自己出牌的时候，牌回到原来的位置，并且重新排列
	StartCoroutine(function ()
		--WaitForSeconds(0.1);
		WaitForEndOfFrame();
		--重新排列GridHand的位置，因为拖拽牌的时候，NGUI的bug会让GridHand位置改变，导致手牌往右移动
		this.RefreshAllGridXi();
		this.RefreshGridHand(playerGridHand[0],0,pData.mahjongs, pData.mahjongCount, false, -1, {});
		--print("dragEnd mahjongs.length:"..(#playerData[1].mahjongs));

		operation_mask.gameObject:SetActive(false);
		--print("operation_mask-------------->3");



	end);

	if this.needDisappearDragEnd then
		playerTingButton.gameObject:SetActive(false);
		local bgFrame = playerTingButton:Find("frame");
		bgFrame.gameObject:SetActive(false);
		this.needDisappearDragEnd = false;
	end



end

function this.OnDoubleClickPlate(obj)
	--print('OnDoubleClickPlate')
	if needChuPai and connect.IsConnect and (not this.GetPlayerDataBySeat(mySeat).sealPai) then
		local plate = GetUserData(obj)

		if obj == playerCurMoPi[0]:GetChild(0).gameObject then
			--print("you dragged mopaiGrid--------1");
		else
			--print("you dragged pai!-------1")
			local myData = this.GetPlayerDataBySeat(mySeat);
			tableRemovePlate(myData.mahjongs,plate);--移除出了的牌
			--把摸到的牌放进手牌中
			if myData.moMahjong and myData.moMahjong ~= -1 then
				myData.mahjongs:append(myData.moMahjong);
			end
		end
		this.SendChuPaiMsg(plate, obj);
		lastSelectmahjong = nil;
	end


	local pData = this.GetPlayerDataBySeat(mySeat);

	--当不是自己出牌的时候，牌回到原来的位置，并且重新排列
	StartCoroutine(function ()
		--WaitForSeconds(0.1);
		WaitForEndOfFrame();
		this.RefreshGridHand(playerGridHand[0],0,pData.mahjongs, pData.mahjongCount, false, -1, {});
		--print("dragEnd mahjongs.length:"..(#playerData[1].mahjongs));

		operation_mask.gameObject:SetActive(false);
		--print("operation_mask-------------->4");

	end);
end

function this.SendChuPaiMsg(plate, dragObj)
	local msg = Message.New()
	msg.type = csm_pb.CHUPAI
	local body = csm_pb.POperation()
	body.mahjong = plate
	msg.body = body:SerializeToString()
	SendGameMessage(msg, nil)
	needChuPai = false;

	--出牌之后隐藏提牌标识
	this.HideTiMark(playerGridHand[0]);
	this.HideTiMark(playerCurMoPi[0]);
end

function this.OnClicButtonDisbandRoom(go)
    AudioManager.Instance:PlayAudio('btn')
    local msg = Message.New()
    msg.type = csm_pb.DISSOLVE
    local body = csm_pb.PDissolve()
    body.decision = csm_pb.APPLY
    msg.body = body:SerializeToString()
    SendGameMessage(msg, nil);
end
function this.OnRoundStart(msg)
	local b = csm_pb.RRoundStart()
	b:ParseFromString(msg.body)
	if roomData.round == 1 and (not (roomData.setting.size == 2)) then
		local datas = {}
		for i = 0, roomData.setting.size - 1 do
			datas[i] = this.GetPlayerDataByUIIndex(i)
		end
        InspectIPAndGPS(datas,roomData.setting.size == 3 and pos3 or pos4,this.OnClicButtonDisbandRoom)   
    end
	this.initLessPlayerStart()
	if panelInGame.needXiPai==true then
		panelInGame.needXiPai=false
		connect.IsZanTing=true
		PanelManager.Instance:ShowWindow('panelXiPai_dice',
		{diceOnePoints=panelInGamemj.diceOnePoints,
		diceTwoPoints=panelInGamemj.diceTwoPoints,fuc=
		function()
			this.gameStart(b)
			connect.IsZanTing=false
		end})
	else
		this.gameStart(b)	
	end
end

function this.copy(fromTable, toTable)
    for k, v in pairs(fromTable) do
        toTable[k] = v
    end
end

function this.gameStart(b)
	print('OnRoundStart was called')
	local ipGroup ={}
	local nameGroup ={}
	local pData = nil
	for i=1,#b.players do
		local p = b.players[i]
		p.sex = p.sex == 0 and 1 or p.sex
		pData = this.GetPlayerDataBySeat(p.seat)
		tableClear(pData.mahjongs)
		tableClear(pData.chi)
		tableClear(pData.peng)
		tableClear(pData.mingGang)
		tableClear(pData.anGang)
		tableClear(pData.dianGang)
		tableClear(pData.paiHe)
		tableClear(pData.tingMahjongs);
		tableAdd(pData.mahjongs, p.mahjongs)
		tableAdd(pData.tingMahjongs,p.tingMahjongs);
		pData.ready 		= true
		pData.mahjongCount 	= p.mahjongCount
		pData.haveStartHu 	= p.haveStartHu;
		pData.moMahjong 	= -1
		pData.sealPai 		= p.sealPai
		pData.floatScore 	= p.floatScore;
		pData.minorityValue = 0

		local same = false
		for j=1,#ipGroup do
			if ipGroup[j][1] == p.ip then
				same = true
				table.insert(ipGroup[j], p.ip)
				table.insert(nameGroup[j], p.name)
				break
			end
		end
		if not same and #p.ip > 0 then
			table.insert(ipGroup, {p.ip})
			table.insert(nameGroup, {p.name})
		end
	end
	if b.setting and b.setting.size>0 then
		this.copy(b.setting,roomData.setting)
		this.SettingText();
	end
	roomData.bankerSeat = b.bankerSeat
	--activeseat位置
	roomData.activeSeat = b.bankerSeat;
	roomData.state = csm_pb.GAMING;

	--去除上一局中，抢杠胡的标志
	roomData.waitOperateTip = false;
	
	this.SetInviteVisiable(false)

	this.ResetWhenStateChange();

	--处理听牌
	local myData = this.GetPlayerDataByUIIndex(0);

	if myData.tingMahjongs and #myData.tingMahjongs > 0 then
		playerTingButton.gameObject:SetActive(true);
		this.SetNewTingScrollView(myData.tingMahjongs)
		newTingOperation.gameObject:SetActive(true);
		--print("#tingMahjongs:"..(#myData.tingMahjongs));
		this.needKeep = true;
		SetUserData(playerTingButton.gameObject, myData.tingMahjongs);
	else
		playerTingButton.gameObject:SetActive(false);
		newTingOperation.gameObject:SetActive(false);
		this.needKeep = false;
	end

	--处理提牌
	--local p = {0, 1, 2, 2, 4, 4, 5, 7, 8, 8, 9, 9, 12, 15, 15, 16, 17, 19, 19, 19}
	--RefreshGridHand(playerGridHand, p)
	this.SetRoundNum(roomData.round);
	this.RefreshAllGridXi();
	this.RefreshAllGridHand();
	this.RefreshAllCurMoPai();
	this.RefreshAllTabelThrow();
	this.SetReadyVisiable();
	this.RefreshPlayer();
	print("roomData.state="..roomData.state);
	this.SetPlayerPos(roomData.state);
	this.SetUIOriginPos();

	this.HideWaittingUI();
	print("HideWaittingUI---->OnRoundStart")

	--设置飘分
	this.SetPiaoFen();

	-- 关闭GPS显示
	GPS.gameObject:SetActive(false);
	print("gameStart GPS: set false,roomData.state = "..roomData.state);

	--取消禁止操作
	this.OperationForbidden(false);

	local names = ""
	for i=1,#nameGroup do
		if #nameGroup[i] > 1 then
			for j=1,#nameGroup[i] do
				names = names..nameGroup[i][j]
				if j~=#nameGroup[i] then
					names = names..'、'
				end
			end
			names = names..'\nIP地址相同\n\n'
		end
	end
	if #names > 0 and roomData.round == 1 then
		coroutine.start(
			function()
				coroutine.wait(1)
				panelMessageBox.SetParamers(ONLY_OK, nil, nil, names)
				PanelManager.Instance:ShowWindow('panelMessageBox')
			end
		)
	end



end

--将UI设置回原来的位置
function this.SetUIOriginPos()
	print("SetUIOriginPos was called");
	--手牌grid
	--桌面牌grid
	for i = 0,3 do
		playerGridHand[i].localPosition = playerHandGridPos[i];
		playerThrow[i].localPosition = playerTableThrowGridPos[i];
	end

end
this.hasStageClear=false;
function this.OnRoundEnd(msg)
	print('OnRoundEnd------------------------------------------------>')
	this.hasStageClear=true
	local b = csm_pb.REnd();
	b:ParseFromString(msg.body);
	--更新玩家的手牌
	for i = 1, #b.players do
		local pData = this.GetPlayerDataBySeat(b.players[i].seat);
		--1.手牌
		tableClear(pData.mahjongs);
		tableAdd(pData.mahjongs,b.players[i].mahjongs);
		--2.吃，碰，杠，补清除
		tableClear(pData.operationCards);

	end

	coroutine.start(  --延时摊牌
		function()
			connect.IsZanTing=true
			if  b.wasteland  then --荒庄，小结算
				coroutine.wait(0.4);
			elseif #b.birds<=0 then
				coroutine.wait(0.2); --赢了但是没有抓鸟，跳过抓鸟动画的等待时间
			else
				coroutine.wait(0.2);--有抓鸟，正常的抓鸟动画等待
			end
			this.DoRoundEndData(b);
		end
	)
	--print('RoundData.over:'..tostring(RoundData.over))
end

local stageRoomInfo = {}
function this.DoRoundEndData(b)
	--print("DoRoundEndData was called------------------------->");
	RoundData.data 			= b
	RoundData.mySeat 		= mySeat
	RoundData.playerData 	= playerData
	roomData.state 			= csm_pb.READYING
	if roomData.setting.rounds >= roomData.round then
		roomData.round = roomData.round+1;
		RoundData.over = true
	end

	for i=1,#playerData do
		playerData[i].ready = false
	end
	this.HideAllWaitOperateEffect();
	this.SetPlateUIColor(playerGridHand[0], {}, false)
	--扎鸟动画
	local duration = 0.3;
	--print("b.birds:"..(#b.birds));
	for i = 1, #b.birds do
		if b.birds[i] then
			print("fly bird:"..i);
			this.FlyBirds(b.birds[i].seat,b.birds[i].mahjongs,#b.birds[i].mahjongs,duration);
		end
	end
	for j=1,#b.players do
		local pData = this.GetPlayerDataBySeat(b.players[j].seat)
		pData.score = b.players[j].score
	end
	this.RefreshPlayer()
	operation_send.gameObject:SetActive(false)
	operation_mask.gameObject:SetActive(false);
	this.SetWaitOpTip(false,"");
	--print("operation_mask-------------->5");

	coroutine.start(
		function()
			if b.wasteland then

			else
				coroutine.wait(0.7);
			end

			stageRoomInfo 		= {};
			stageRoomInfo.roomNumber 	= roomInfo.roomNumber;
			stageRoomInfo.roomData 		= roomData;
			stageRoomInfo.cardColor 	= cardColor;
			stageRoomInfo.cardText 		= cardText;
			stageRoomInfo.RoundData 	= RoundData;
			stageRoomInfo.RoundAllData 	= RoundAllData;
			stageRoomInfo.isInGame =true
			stageRoomInfo.gameOver =b.gameOver
			stageRoomInfo.fuc=function()
				connect.IsZanTing=false
			end
			PanelManager.Instance:ShowWindow('panelStageClear_mj', stageRoomInfo)
			dipai.gameObject:SetActive(true)
			this.HideAllBirds();
			PanelManager.Instance:HideWindow("panelGameSetting_mj");
			PanelManager.Instance:HideWindow("panelChat");
			morePanel.gameObject:SetActive(false);
			PanelManager.Instance:HideWindow("panelVisitingCard");
			PanelManager.Instance:HideWindow("panelsuddenBonus");
			PanelManager.Instance:HideWindow("panelMessageBox");
			coroutine.stop(trusteeshipcor);
			--DelegateTime.gameObject:SetActive(false);
			--DelegatePanel.gameObject:SetActive(false);

			this.SetDipaiNum(roomData.surplus);
			this.SetRoundNum(roomData.round);


		end
	)

	--隐藏听牌
	playerTingButton.gameObject:SetActive(false);
	this.needKeep = false;
	--清空一些数据
	this.ClearData();
	--隐藏头像框上的特效
	this.HideAllKuang();
end

function this.FlyBirds(seat, value, count, duration)
	print(string.format("扎鸟, seat = %d,  count = %d", seat, count))
	local index = this.GetUIIndexBySeat(seat)
	local t = this.GetFreeBirds(count)
	--print("t.length:"..tostring(#t));
	for i=1,count do
		--print("path fly bird!");
		--print("t[i]="..i..","..tostring(t[i]));
		t[i].gameObject:SetActive(true);
		t[i].localPosition = Vector3.zero
		t[i]:Find("MajiangBg2"):GetComponent("UISprite").spriteName = this.getColorCardName("mj_02",cardColor);

		local tweenPos = t[i]:GetComponent('TweenPosition');
		tweenPos:ResetToBeginning();
		tweenPos.worldSpace = false;
		tweenPos.from = Vector3.New(0,0,0);
		--当鸟牌只有一个的时候，让鸟牌的位置靠中间一点，取第二个位置的值，但有个特殊，左边这个人的位置，它还是取第一个位置的值
		local realIndex = this.GetUIIndex(index,playerSize);
		local posIndex = count == 1 and (realIndex==3 and i or i + 1) or i;
		tweenPos.to = CONST.birdPos[this.GetUIIndex(index,playerSize)+1][posIndex];
		--print("["..(this.GetUIIndex(index,playerSize)+1).."]["..i.."] b_pos:"..tostring(tweenPos.to));
		tweenPos.duration = duration;
		StartCoroutine(function()
				tweenPos.value.y = tweenPos.value.y+0.1;
			end);
		tweenPos:PlayForward();



		--print("after:"..tostring(t[i]:GetComponent('SpringPosition').target));
		t[i]:Find('Pai'):GetComponent('UISprite').spriteName = this.GetCardTextName(value[i],cardText);

	end
	AudioManager.Instance:PlayAudio("audio_bird");
end

function this.OnReady(msg)
	local b = csm_pb.RSeat()
	b:ParseFromString(msg.body)
	print('OnReady--------------------------> myseat:'..mySeat.."|ready seat:"..b.seat);
	local ix = this.GetUIIndexBySeat(b.seat);
	playerReady[this.GetUIIndex(ix,playerSize)].gameObject:SetActive(true);
	playerPiaoFen[this.GetUIIndex(ix,playerSize)].gameObject:SetActive(false);
	playerPiaoFen[this.GetUIIndex(ix,playerSize)]:GetComponent("UILabel").text = "";
	--playerData[this.GetUIIndex(ix,playerSize)].ready = true
	this.GetPlayerDataBySeat(b.seat).ready = true;

	dipai.gameObject:SetActive(this.NeedShowDiPai());
	roomRound.gameObject:SetActive(this.NeedShowDiPai());

	AudioManager.Instance:PlayAudio('audio_ready');
	if b.seat == mySeat then
		ButtonReady.gameObject:SetActive(false);
	end
	--处理网络很差的时候短线重连，隐藏小结算界面

	if b.seat == mySeat  then
		print("清理上一局的数据");

		this.RsetWhenStart();
		this.RsetWhenClickNextRound();
		if PanelManager.Instance:IsActive("panelStageClear_mj") then
			PanelManager.Instance:HideWindow("panelStageClear_mj");
			dipai.gameObject:SetActive(true)
		end

		this.hasStageClear = false;
	end

	this.NotifyGameStart()
end



function this.OnDisconnected(msg)
	print('OnDisconnected')
	local b = csm_pb.RSeat();
	b:ParseFromString(msg.body);
	local i = this.GetUIIndexBySeat(b.seat);
	this.GetPlayerDataBySeat(b.seat).connected = false;
	playerOffline[this.GetUIIndex(i,playerSize)].gameObject:SetActive(true);

	--断线之后停止托管的携程
	--offlineState = true;
	--coroutine.stop(trusteeshipcor);
	this.StartOfflineIncrease(b.seat, 0);

end

function this.onPlayerStartHu(msg)
	print('onPlayerStarHu was called');
	local b = csm_pb.RStartHus();
	b:ParseFromString(msg.body)
	--起手胡开始，禁用玩家操作
	operation_mask.gameObject:SetActive(true);

	if roomData.activeSeat == mySeat and roomData.bankerSeat == mySeat then
		this.SetWaitOpTip(true,"请等待其他玩家操作");
	else
		this.SetWaitOpTip(false,"");
	end

	local data = {};
	data.roomData = roomData;
	data.startHu = b.startHu;

	PanelManager.Instance:ShowWindow("panelStartHu",data);
	for i = 1, #b.startHu do
		local pData = this.GetPlayerDataBySeat(b.startHu[i].seat)
		if roomData.setting.roomTypeValue == proxy_pb.CSM then
			AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(pData.sex==1 and 'man_' or 'woman_').."qishouhu")
		else
			AudioManager.Instance:PlayAudio((pData.sex == 1 and "man_" or "woman_").."hu")
		end
	end
end

--只有庄家会收到这个协议的返回
function this.onPlayerStartHuEnd(msg)
	-- print("onPlayerStarHuEnd was called@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
	local b = csm_pb.RStartHuEnd()
	b:ParseFromString(msg.body)

	--起手胡结束玩家可以再次操作
	operation_mask.gameObject:SetActive(false);
	this.SetWaitOpTip(false,"");
	roomData.waitOperateTip = false;


	--更新玩家可以进行的操作
	local pData = this.GetPlayerDataBySeat(mySeat);
	tableClear(pData.operations);
	tableAdd(pData.operations,b.operations);

	this.SetBuGangData(pData);
	--this.SetPlateUIColor(playerGridHand[0], {}, false);
	this.RefreshOperationSend(b.operations, 'StarHuEnd');

	needChuPai = true;
	roomData.waitOperate = false;
	--print("roomData.waitOperate:"..tostring(roomData.waitOperate));

	--隐藏听牌功能
	if b.seat == mySeat then
		playerTingButton.gameObject:SetActive(false);
		playerTingButton:Find("frame").gameObject:SetActive(false);
		this.needKeep = false;

		--处理提牌
		this.SetTiPlateMark(playerGridHand[0],pData.mahjongs,b.tingTip);
		this.SetTiPlateMark(playerCurMoPi[0],{pData.moMahjong},b.tingTip);
		tingData = b.tingTip;
	end
end

function this.OnPlayerMoPai(msg)
	-- print("OnPlayerMoPai was called.......................................");
	local b = csm_pb.RMoPai()
	b:ParseFromString(msg.body)
	--print('mopai mahjong:'..b.mahjong)
	--print('mahjongs:'..table.concat(b.mahjongs, ','))
	--print('mahjongCount:'..b.mahjongCount)
	--print('haveStartHu:'..tostring(b.haveStartHu))
	--print("haveStartHu in OnPlayerMoPai:"..tostring(b.haveStartHu));
	roomData.waitOperate = b.haveStartHu;
	roomData.waitOperateTip = b.haveStartHu;

	local index = this.GetUIIndexBySeat(b.seat);
	local pData = this.GetPlayerDataBySeat(b.seat);
	--print("b.seat:"..b.seat);
	--print("pData.seat:"..pData.seat);

	--设置activeSeat
	roomData.activeSeat = b.seat;
	--删除摸的牌
	if b.seat == mySeat then
		pData.mahjongCount 	= b.mahjongCount;
		tableRemovePlate(b.mahjongs,b.mahjong);
		--更新玩家的手牌moMahjong
		tableClear(pData.mahjongs);
		tableAdd(pData.mahjongs,b.mahjongs);
	else
		pData.mahjongCount 	= b.mahjongCount-1;
	end



	--更新玩家可以进行的操作
	tableClear(pData.operations);
	tableAdd(pData.operations,b.operations);


	--print("this haveZtHu on ----------------->moPai:"..tostring(b.haveZtHu));

	--设置中途起手胡
	if b.seat == mySeat then
		if b.haveZtHu then
			for i = 1, #pData.operations do
				if pData.operations[i].operation == csm_pb.ZTHU then
					this.SetSuddenBonus(b.haveZtHu,b.ztHuItem,pData.operations[i].mahjongs);
				end
			end
		end
	end

	this.PlayerMoPai(index,pData,b);
	--隐藏听牌功能
	if b.seat == mySeat then
		newTingOperation.gameObject:SetActive(false);
		playerTingButton.gameObject:SetActive(false);
		playerTingButton:Find("frame").gameObject:SetActive(false);
		this.needKeep = false;
		--operation_mask.gameObject:SetActive(false);
		operation_mask.gameObject:SetActive(roomData.waitOperate);
		if roomData.waitOperateTip then
			this.SetWaitOpTip(true,"请等待其他玩家操作");
		else
			this.SetWaitOpTip(false,"");

		end

		--print("operation_mask-------------->7");

		this.OperationForbidden(this.GetPlayerDataBySeat(mySeat).sealPai);

		--处理提牌
		this.SetTiPlateMark(playerGridHand[0],this.GetPlayerDataBySeat(mySeat).mahjongs,b.tingTip);
		this.SetTiPlateMark(playerCurMoPi[0],{b.mahjong},b.tingTip);
		tingData = b.tingTip;
	end

	DelayMsgDispatch(connect, 0.5)
end

function this.PlayerMoPai(index,pData,b)
	--这里的index不需要再转换了，因为这里已经转换一次了
	--print("PlayerMoPai---->index:"..index.." mo mahjong:"..b.mahjong);

	this.GetPlayerDataBySeat(mySeat).haveStartHu = b.haveStartHu
	pData.moMahjong = -1
	this.RefreshGridHand(playerGridHand[this.GetUIIndex(index,playerSize)], this.GetUIIndex(index,playerSize), pData.mahjongs, pData.mahjongCount, false, pData.moMahjong, {})
	pData.moMahjong = b.mahjong
	this.RefreshCurMoPai(index, b.mahjong);
	this.SetDipaiNum(b.surplus)
	if b.seat == mySeat then

		if index == 0 then
			playerCurMoPi[index]:Find("curMoPai").localPosition = Vector3.New(0,0,0);
		else
			--print("insert mopai,index:"..index);
			pData.mahjongs:append(b.mahjong)
		end
		needChuPai = not b.haveStartHu;
	else
		pData.mahjongCount = b.mahjongCount;
		needChuPai = false
	end

	this.ShowWaitOpreatEffect(b.seat, true)
	lastOperat.op = csm_pb.MOPAI
	lastOperat.plate = {b.mahjong}
	lastOperat.seat = b.seat;
	--处理补牌
	this.SetBuGangData(pData);

	this.RefreshOperationSend(b.operations, 'mopai');

	if b.seat == mySeat and b.sealPai and ButtonHu.gameObject.activeSelf == false and ButtonGang.gameObject.activeSelf == false then
		--this.SendChuPaiMsg(b.mahjong)
	end
end

function this.OnPlayerChuPai(msg)
    local b = csm_pb.RChuPai()
    b:ParseFromString(msg.body)
	if roomData.setting.trusteeship == 0 then
		remainTime = 15
	else
		if roomData.trusteeshipRemainMs>0 then
			remainTime = roomData.trusteeshipRemainMs
		else
			remainTime = roomData.setting.trusteeship
		end
	end
    --print("handCount:"..b.handCount);
    --print('OnPlayerChuPai');
    local pData = this.GetPlayerDataBySeat(b.seat);
    --print("player sex:"..pData.sex);
    local index = this.GetUIIndexBySeat(b.seat);

    pData.paiHe:append(b.mahjong);
    --刷新打出到牌桌上的牌
    --print("remove plate:"..b.mahjong);
    playerChuPaiShows[this.GetUIIndex(index,playerSize)].gameObject:SetActive(true);
    local showSpriteName = playerChuPaiShows[this.GetUIIndex(index,playerSize)]:GetComponent("UISprite").spriteName;
    playerChuPaiShows[this.GetUIIndex(index,playerSize)]:GetComponent("UISprite").spriteName = this.getColorCardName("mj_02",cardColor);
	playerChuPaiShows[this.GetUIIndex(index,playerSize)]:Find("card"):GetComponent("UISprite").spriteName = this.GetCardTextName(b.mahjong,cardText);
	playerChuPaiShows[this.GetUIIndex(index,playerSize)]:Find("card"):GetComponent("UISprite").width  =this.GetCardPlateSize(b.mahjong,cardText).x;
	playerChuPaiShows[this.GetUIIndex(index,playerSize)]:Find("card"):GetComponent("UISprite").height =this.GetCardPlateSize(b.mahjong,cardText).y;
    this.RefreshTabelThrowByIndex(index,  pData.paiHe, b.seat);

    StartCoroutine(function ()
        WaitForSeconds(1);
        --播放出牌动画
        playerChuPaiShows[this.GetUIIndex(index,playerSize)].gameObject:SetActive(false);
    end)

    --自己的牌单独处理
    if b.seat ~= mySeat then
        this.DoRemovePlates(b.seat, {b.mahjong}, false);
        --如果手中的牌跟跟服务器的牌不一致，重连
        --print("b.handCount:"..b.handCount);
        --print("pData.mahjongCount:"..pData.mahjongCount);
        if b.handCount ~= (#this.GetPlayerDataBySeat(b.seat).mahjongs) then
        end
    end

    --print("player:"..b.seat.." plates:"..(#this.GetPlayerDataBySeat(b.seat).mahjongs));
    needChuPai = false
    pData.moMahjong = -1

    --更新玩家可以进行的操作
    tableClear(pData.operations);
    tableAdd(pData.operations,b.operations);

    lastOperat.op 		= csm_pb.CHUPAI
    lastOperat.plate 	= {b.mahjong}
    lastOperat.seat 	= b.seat

    this.SetBuGangData(pData);
    this.SetPlateUIColor(playerGridHand[0], {}, false)
    this.RefreshOperationSend(b.operations, 'chupai');

    StartCoroutine(function ()
        WaitForEndOfFrame();
        this.SetPlateEffectShowByIndex(index,pData.paiHe, b.seat);
    end);


    --处理听牌
    if b.seat == mySeat then
        if b.tingMahjongs and #b.tingMahjongs > 0 then
			playerTingButton.gameObject:SetActive(true);
			this.SetNewTingScrollView(b.tingMahjongs)
			newTingOperation.gameObject:SetActive(true);
            this.needKeep = true;
            --print("#tingMahjongs:"..(#b.tingMahjongs));
            SetUserData(playerTingButton.gameObject, b.tingMahjongs);


        else
			playerTingButton.gameObject:SetActive(false);
			newTingOperation.gameObject:SetActive(false);
            this.needKeep = false;
        end

        --出牌之后隐藏提牌标识
        this.HideTiMark(playerGridHand[0]);
        this.HideTiMark(playerCurMoPi[0]);
        tingData = {};
    end

	local pMyData = this.GetPlayerDataBySeat(mySeat);
    --处理托管时出牌后，受伤的牌不消失
	if b.seat == mySeat and pMyData.trusteeship then

		--找到了可以删除的牌
		if tableRemovePlate(pMyData.mahjongs,b.mahjong) then
			--如果手中有摸的牌,把摸的牌放入手牌
			if playerCurMoPi[0].gameObject.activeInHierarchy then
				local moPlate = GetUserData(playerCurMoPi[0]:GetChild(0).gameObject);
				table.insert(pMyData.mahjongs,moPlate);
				playerCurMoPi[0].gameObject:SetActive(false);
			end
		end
		this.RefreshGridHand(playerGridHand[0],0,pMyData.mahjongs, #pMyData.mahjongs, false, -1, {});
	end

	--刷新出牌
	this.RefreshCurMoPai(-1, b.mahjong);
	--sex 1表示男生，2表示女生
	if roomData.setting.roomTypeValue == proxy_pb.CSM then
		AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(pData.sex==1 and 'man' or 'woman')..math.floor(b.mahjong / 9 + 1)..(b.mahjong % 9 + 1))
	else
		AudioManager.Instance:PlayAudio((pData.sex==1 and 'man' or 'woman')..math.floor(b.mahjong / 9 + 1)..(b.mahjong % 9 + 1))
	end
	--DelayMsgDispatch(connect, 0.5)
end

--判断玩家的吃牌是否是属于卡牌，比如 123,吃1，吃2，789，吃7，吃8
--chiMahjong 被吃的那张牌
--others 参与吃的牌
function this.isChiKa(chiMahjong,others)
	if not chiMahjong or not others then return false end;
	table.sort(others,function (a,b) return a < b; end)
	if others[2]-others[1] == 2 then
		return true;
	else
		--三万或七万
		if chiMahjong == 2 then
			return chiMahjong > others[1] and chiMahjong > others[2];
		end

		if chiMahjong == 6 then
			return chiMahjong < others[1] and chiMahjong < others[2];
		end
		--三筒或七筒
		if chiMahjong == 11 then
			return chiMahjong > others[1] and chiMahjong > others[2];
		end

		if chiMahjong == 15 then
			return chiMahjong < others[1] and chiMahjong < others[2];
		end
		--三条或七条
		if chiMahjong == 20 then
			return chiMahjong > others[1] and chiMahjong > others[2];
		end

		if chiMahjong == 24 then
			return chiMahjong < others[1] and chiMahjong < others[2];
		end
	end

	return false;
end

--玩家吃牌
function this.OnPlayerChiPai(msg)
	local b = csm_pb.RChiPai()
	b:ParseFromString(msg.body)

	this.RefreshCurMoPai(-1, b.mahjong)
	local pData = this.GetPlayerDataBySeat(b.seat)
	local i = this.GetUIIndexBySeat(b.seat)

	--activeseat位置
	roomData.activeSeat = b.seat;


	--更新玩家可以进行的操作
	local myData = this.GetPlayerDataBySeat(mySeat);
	tableClear(myData.operations);
	tableAdd(myData.operations,b.operations);

	--显示特效
	effManger.ShowEffect(gameObject,"chi",playerHupaiPos[this.GetUIIndex(i,playerSize)]);

	table.insert(pData.operationCards,{operation = csm_pb.SORT_CHI,cards = {b.others[1],b.mahjong,b.others[2]}});
	for i = 1, #pData.operationCards do
		-- print("operation_type"..pData.operationCards[i].operation);
		for j = 1, #pData.operationCards[i].cards do
			print("card:"..pData.operationCards[i].cards[j]);
		end
		-- print("---------------");
	end
	this.RefreshGridXiByIndex(i,pData.operationCards);
	this.DoRemovePlates(b.seat, b.others, false)
	if b.seat == mySeat then
		newTingOperation.gameObject:SetActive(false);
		playerTingButton.gameObject:SetActive(false);
		needChuPai = true
	else
		needChuPai = false
	end
	if b:HasField('outSeat') then
		local pData_out = this.GetPlayerDataBySeat(b.outSeat)
		local i_out = this.GetUIIndexBySeat(b.outSeat)
		for i=#pData_out.paiHe,1,-1 do
			if pData_out.paiHe[i] == b.mahjong then
				pData_out.paiHe:remove(i)
				break
			end
		end
		this.RefreshTabelThrowByIndex(i_out, pData_out.paiHe, b.outSeat);
		curOperatPlateEffect.gameObject:SetActive(false)
	end
	--更新操作
	lastOperat.op = csm_pb.CHIPAI
	lastOperat.plate = {b.mahjong}
	lastOperat.seat = b.seat

	this.SetBuGangData(myData);
	this.SetPlateUIColor(playerGridHand[0], {}, false)
	this.RefreshOperationSend(b.operations, 'chipai')
	this.ShowWaitOpreatEffect(b.seat, true)

	--处理提牌
	this.SetTiPlateMark(playerGridHand[0],this.GetPlayerDataBySeat(mySeat).mahjongs,b.tingTip);
	tingData = b.tingTip;
	if roomData.setting.roomTypeValue == proxy_pb.CSM then
		AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(pData.sex==1 and 'man_' or 'woman_')..'chi')
	else
		AudioManager.Instance:PlayAudio((pData.sex==1 and 'man_' or 'woman_').."chi")
	end
	DelayMsgDispatch(connect, 0.5)
end

function this.OnPlayerPengPai(msg)
	print("OnPlayerPengPai was called");
	local b = csm_pb.RPengPai()
	b:ParseFromString(msg.body)

	--更新玩家可以进行的操作
	local myData = this.GetPlayerDataBySeat(mySeat);
	tableClear(myData.operations);
	tableAdd(myData.operations,b.operations);


	--activeseat位置
	roomData.activeSeat = b.seat;

	--print("pengPai seat:"..b.seat);
	this.RefreshCurMoPai(-1, b.mahjong)
	local pData = this.GetPlayerDataBySeat(b.seat)
	local i = this.GetUIIndexBySeat(b.seat)
	--显示特效
	effManger.ShowEffect(gameObject,"peng",playerHupaiPos[this.GetUIIndex(i,playerSize)]);



	table.insert(pData.operationCards,{operation = csm_pb.SORT_PENG,cards = {b.mahjong}});
	this.RefreshGridXiByIndex(i,pData.operationCards);
	this.DoRemovePlates(b.seat, {b.mahjong, b.mahjong}, false)
	if b.seat == mySeat then
		newTingOperation.gameObject:SetActive(false);
		playerTingButton.gameObject:SetActive(false);
		needChuPai = true
	else
		needChuPai = false
	end

	if b:HasField('outSeat') then
		local pData_out = this.GetPlayerDataBySeat(b.outSeat)
		local i_out = this.GetUIIndexBySeat(b.outSeat)
		for i=#pData_out.paiHe,1,-1 do
			if pData_out.paiHe[i] == b.mahjong then
				pData_out.paiHe:remove(i)
				break
			end
		end
		this.RefreshTabelThrowByIndex(i_out, pData_out.paiHe, b.outSeat);
		curOperatPlateEffect.gameObject:SetActive(false)
	end

	lastOperat.op = csm_pb.PENGPAI
	lastOperat.plate = {}
	lastOperat.seat = b.seat

	this.SetBuGangData(myData);
	this.SetPlateUIColor(playerGridHand[0], {}, false)
	this.RefreshOperationSend(b.operations, 'penpai')
	this.ShowWaitOpreatEffect(b.seat, true);

	--处理提牌
	this.SetTiPlateMark(playerGridHand[0],this.GetPlayerDataBySeat(mySeat).mahjongs,b.tingTip);
	tingData = b.tingTip;
	if roomData.setting.roomTypeValue == proxy_pb.CSM then
		AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(pData.sex==1 and 'man_' or 'woman_')..'peng')
	else
		AudioManager.Instance:PlayAudio((pData.sex==1 and 'man_' or 'woman_').."peng")
	end
	DelayMsgDispatch(connect, 0.5)
end


function this.OnPlayerBuPai(msg)

	print("OnPlayerBuPai was called.............");

	local b = csm_pb.RBuPai()
	b:ParseFromString(msg.body)
	--更新玩家可以进行的操作
	local myData = this.GetPlayerDataBySeat(mySeat);
	tableClear(myData.operations);
	tableAdd(myData.operations,b.operations);
	--activeseat位置
	roomData.activeSeat = b.seat;
	local pData = this.GetPlayerDataBySeat(b.seat)
	local i = this.GetUIIndexBySeat(b.seat)
	local plates={b.mahjong, b.mahjong, b.mahjong}
	if b.gangType == csm_pb.MING then
		table.insert(pData.operationCards,{operation = csm_pb.SORT_MING,cards = {b.mahjong}});
	elseif b.gangType == csm_pb.AN then
		table.insert(pData.operationCards,{operation = csm_pb.SORT_DARK,cards = {b.mahjong}});
		table.insert(plates, b.mahjong)
	elseif b.gangType == csm_pb.DIAN then
		table.insert(pData.operationCards,{operation = csm_pb.SORT_DIAN,cards = {b.mahjong}});
		table.insert(plates, b.mahjong)
	end
	for i=1,#pData.operationCards do
		if pData.operationCards[i].operation == csm_pb.SORT_PENG then
			if pData.operationCards[i].cards[1] == b.mahjong then
				table.remove(pData.operationCards,i);
				break;
			end
		end
	end
	this.RefreshGridXiByIndex(i,pData.operationCards);

	--显示特效
	function getEffectStringByRoomType(roomType)
		if roomType == proxy_pb.CSM then
			return "bu";
		elseif roomType == proxy_pb.ZZM or roomType == proxy_pb.HZM then
			return "gang";
		end
	end

	effManger.ShowEffect(gameObject,getEffectStringByRoomType(roomData.setting.roomTypeValue),playerHupaiPos[this.GetUIIndex(i,playerSize)]);

	this.RefreshCurMoPai(-1);

	--点杠只删除一张牌
	if b.gangType == csm_pb.DIAN then
		this.DoRemovePlates(b.seat, {b.mahjong}, false)
	else
		this.DoRemovePlates(b.seat, plates, false)
	end

	--有抢杠胡(请注意，长沙麻将没有抢杠胡)
	if b.seat == mySeat and b.hasChoices == 1 and roomData.setting.roomTypeValue ~=  proxy_pb.CSM then
		needChuPai = true;
		--抢杠胡
		operation_mask.gameObject:SetActive(true);
		this.SetWaitOpTip(true,"请等待其他玩家操作");
	else
		needChuPai = false

	end
	if b:HasField('outSeat') and b.gangType == csm_pb.MING then
		local pData_out = this.GetPlayerDataBySeat(b.outSeat)
		local i_out = this.GetUIIndexBySeat(b.outSeat)
		for i=#pData_out.paiHe,1,-1 do
			if pData_out.paiHe[i] == b.mahjong then
				pData_out.paiHe:remove(i);
				-- print("remove paihe ."..b.mahjong);
				break
			end
		end
		this.RefreshTabelThrowByIndex(i_out,pData_out.paiHe, b.outSeat);
		curOperatPlateEffect.gameObject:SetActive(false)
	end

	--lastOperat.buGang = {};
	lastOperat.op = csm_pb.BUPAI
	lastOperat.plate = {b.mahjong};
	--lastOperat.plate = {};
	lastOperat.seat = b.seat

	this.SetBuGangData(myData);
	this.ShowWaitOpreatEffect(b.seat, true)
	this.SetPlateUIColor(playerGridHand[0], {}, false)
	this.RefreshOperationSend(b.operations, 'bupai')
	if roomData.setting.roomTypeValue == proxy_pb.CSM then
		AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(pData.sex==1 and 'man_' or 'woman_')..'bu')
	else
		AudioManager.Instance:PlayAudio((pData.sex==1 and 'man_' or 'woman_').."gang")
	end
	DelayMsgDispatch(connect, 0.5)
end

function this.OnPlayerGangPai(msg)
	-- print("OnPlayerGangPai was called................");
	local b = csm_pb.RGangPai()
	b:ParseFromString(msg.body)
	--print('OnPlayerGangPai:'..b.mahjong)

	--更新玩家可以进行的操作
	local pData = this.GetPlayerDataBySeat(b.seat);
	tableClear(pData.operations);
	tableClear(pData.mahjongs);
	tableAdd(pData.operations,b.operations);
	tableAdd(pData.mahjongs,b.mahjongs);
	pData.mahjongCount = b.mahjongCount;

	--activeseat位置
	roomData.activeSeat = b.seat;
	print("b.seat:"..b.seat);

	rollResult = nil
	local index = this.GetUIIndexBySeat(b.seat)
	-- print("pData.mahjongs:"..#pData.mahjongs);
	for i=1,#pData.mahjongs do
		print(pData.mahjongs[i]);
	end

	--如果杠的牌在手牌中
	local effectString = "";
	local plates={b.mahjong, b.mahjong, b.mahjong}
	if b.gangType == csm_pb.MING then
		-- print("player ming gang-------->");
		table.insert(pData.operationCards,{operation = csm_pb.SORT_MING,cards = {b.mahjong}});
		if roomData.setting.roomTypeValue == proxy_pb.CSM then
			AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(pData.sex==1 and 'man_' or 'woman_')..'gang')
		else
			AudioManager.Instance:PlayAudio((pData.sex==1 and 'man_' or 'woman_').."gang")
		end
		effectString = "mg";
	elseif b.gangType == csm_pb.AN then
		-- print("player an gang-------->");
		table.insert(pData.operationCards,{operation=csm_pb.SORT_DARK,cards = {b.mahjong}});
		table.insert(plates, b.mahjong);
		if roomData.setting.roomTypeValue == proxy_pb.CSM then
			AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(pData.sex==1 and 'man_' or 'woman_')..'gang')
		else
			AudioManager.Instance:PlayAudio((pData.sex==1 and 'man_' or 'woman_').."gang")
		end
		effectString = "ag";
	elseif b.gangType == csm_pb.DIAN then
		-- print("player dian gang-------->");
		table.insert(pData.operationCards,{operation=csm_pb.SORT_DIAN,cards = {b.mahjong}});
		table.insert(plates, b.mahjong)
		if roomData.setting.roomTypeValue == proxy_pb.CSM then
			AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(pData.sex==1 and 'man_' or 'woman_')..'gang')
		else
			AudioManager.Instance:PlayAudio((pData.sex==1 and 'man_' or 'woman_').."gang")
		end
		effectString = "gang";
	end

	--如果杠的牌是已经碰的牌
	for i=1,#pData.operationCards do
		if pData.operationCards[i].operation == csm_pb.SORT_PENG then
			if pData.operationCards[i].cards[1] == b.mahjong then
				plates={b.mahjong};
				table.remove(pData.operationCards,i);
				break;
			end
		end
	end

	--显示特效
	effManger.ShowEffect(gameObject,effectString,playerHupaiPos[this.GetUIIndex(index,playerSize)]);

	this.RefreshGridXiByIndex(index,pData.operationCards);
	this.DoRemovePlates(b.seat, plates, false,true);
	needChuPai = false

	if b:HasField('outSeat') and (b.gangType == csm_pb.MING or b.gangType == csm_pb.AN)  then
		local pData_out = this.GetPlayerDataBySeat(b.outSeat)
		local i_out = this.GetUIIndexBySeat(b.outSeat)
		for i=#pData_out.paiHe,1,-1 do
			if pData_out.paiHe[i] == b.mahjong then
				pData_out.paiHe:remove(i)
				break
			end
		end
		this.RefreshTabelThrowByIndex(i_out,pData_out.paiHe, b.outSeat);
		curOperatPlateEffect.gameObject:SetActive(false)
	end
	this.RefreshCurMoPai(-1, b.mahjong);

	--coroutine.start(this.Roll, 1, b.firstDice, b.secondDice, .2, b.seat, b.outRange)
	--lastOperat.buGang 	= {};
	lastOperat.op 		= csm_pb.GANGPAI
	lastOperat.plate 	= {b.mahjong};
	lastOperat.seat 	= b.seat

	this.SetBuGangData(pData);
	this.SetPlateUIColor(playerGridHand[0], {}, false)
	this.RefreshOperationSend(b.operations, 'gangpai')
	if b.gangType == 0 then
		if roomData.setting.roomTypeValue == proxy_pb.CSM then
			AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(pData.sex==1 and 'man_' or 'woman_')..'gang')
		else
			AudioManager.Instance:PlayAudio((pData.sex==1 and 'man_' or 'woman_').."gang")
		end
	end

	--处理等待其他玩家操作[抢杠胡]
	if b.seat == mySeat then
		--this.SetWaitOpTip(true,"请等待其他玩家操作");
	else
	end
	--处理听牌
	if b.seat == mySeat and b.tingMahjongs and #b.tingMahjongs > 0 then
		--处理提牌
		this.HideTiMark(playerGridHand[0]);
		this.HideTiMark(playerCurMoPi[0]);
		tingData = {};

		newTingOperation.gameObject:SetActive(false);
		playerTingButton.gameObject:SetActive(true);
		this.needKeep = true;
		--print("#tingMahjongs:"..(#b.tingMahjongs));
		SetUserData(playerTingButton.gameObject, b.tingMahjongs);
		this.OperationForbidden(true);
	end
	DelayMsgDispatch(connect, 0.5)
end

--玩家禁止操作
function this.OperationForbidden(isForbidden)
	operation_mask.gameObject:SetActive(isForbidden);
	local myData = this.GetPlayerDataBySeat(mySeat);
	myData.sealPai = isForbidden;
end

function this.Roll(duration, value1, value2, lifetime, clientseat, isChujie)
	if not lifetime then
		lifetime = 3
	end
	kaiBao:Find('ShaiZiAnimation').gameObject:SetActive(true)
	AudioManager.Instance:PlayAudio('audio_shaizi')
	coroutine.wait(duration)
	if value1 and value2 then
		kaiBao:Find('ShaiZiGroups/ShaiZi1'):GetComponent('UISprite').spriteName = 'shaizi'..value1
		kaiBao:Find('ShaiZiGroups/ShaiZi2'):GetComponent('UISprite').spriteName = 'shaizi'..value2
	else
		--self.kaiBao:Object():ShowShaiZi()
		--print('roll no value')
	end
	coroutine.wait(lifetime)
	kaiBao:Find('ShaiZiAnimation').gameObject:SetActive(false)

	if isChujie then
		effManger.ShowEffect(gameObject, 'chujie', Vector3.zero)
	else
		if rollResult then
			coroutine.start(this.OnRollEnd, rollResult.firstMahjong, rollResult.secondMahjong, 2)
		end
	end
end

function this.OnRollEnd(value1, value2, lifetime)
	local b = this.GetFreeBirds(2)
	
	b[1].gameObject:SetActive(true)
	b[2].gameObject:SetActive(true)
	b[1]:GetComponent('UIWidget').alpha = 1
	b[1]:Find('Pai'):GetComponent('UISprite').spriteName = this.GetCardTextName(value1,cardText);
	b[1].localPosition = Vector3.New(-150, 0, 0)

	b[2]:GetComponent('UIWidget').alpha = 1
	b[2]:Find('Pai'):GetComponent('UISprite').spriteName = this.GetCardTextName(value2,cardText);
	b[2].localPosition = Vector3.New(150, 0, 0)
	
	coroutine.wait(lifetime)
	b[1].gameObject:SetActive(false)
	b[2].gameObject:SetActive(false)
end

function this.GetOpreationPlates(operations)
	local opPlates = {};
	for i = 1, #operations do
		if operations[i].mahjongs[1] then
			table.insert(opPlates,operations[i].mahjongs[1]);
		end
	end
	return opPlates;
end


--玩家中途起手胡
function this.onPlayerZhongtuhu(msg)
	print('onPlayerZhongtuhu was called');
	local reciveMsg  = csm_pb.RZtHu();
	reciveMsg:ParseFromString(msg.body);
	local suddenData  = {};
	table.insert(suddenData,{seat = reciveMsg.seat,categories = {reciveMsg.huCategory},plates = reciveMsg.mahjongs})
	PanelManager.Instance:ShowWindow("panelSuddenEffect",suddenData)
	if roomData.setting.roomTypeValue == proxy_pb.CSM then
		local str = ''
		if reciveMsg.huCategory == 26 then
			str = 'zhongtusixi'
		elseif reciveMsg.huCategory == 27 then
			str = 'zhongtuliuliushun'
		else
			str = 'hu'
		end
		AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(this.GetPlayerDataBySeat(reciveMsg.seat).sex==1 and 'man_' or 'woman_')..str)
	else
		AudioManager.Instance:PlayAudio((this.GetPlayerDataBySeat(reciveMsg.seat).sex == 1 and "man_" or "woman_").."hu")
	end
end

--玩家中途起手胡结束
function this.onPlayerZhongtuhuEnd(msg)
	print('onPlayerZhongtuhuEnd was called')
	local reciveMsg  = csm_pb.RZtHuEnd();
	reciveMsg:ParseFromString(msg.body);
	--清除数据
	this.SetSuddenBonus(false,{},{});
	--刷新操作
	local myData = this.GetPlayerDataBySeat(mySeat);
	tableClear(myData.operations);
	tableAdd(myData.operations,reciveMsg.operations);
	this.SetBuGangData(myData);
	this.SetPlateUIColor(playerGridHand[0], {}, false);
	this.RefreshOperationSend(myData.operations, 'zthuend')
	needChuPai = true
end


function this.onPlayerZhiShaiZi(msg)
	print('onPlayerZhiShaiZi')
	local b = csm_pb.RZhiShaiZi()
	b:ParseFromString(msg.body)

	--更新玩家可以进行的操作
	local myData = this.GetPlayerDataBySeat(mySeat);
	tableClear(myData.operations);
	tableAdd(myData.operations,b.operations);

	--播放掷色子动画
	connect.IsZanTing=true
	PanelManager.Instance:ShowWindow('panelXiPai_dice',
	{diceOnePoints=b.diceOnePoints,
	diceTwoPoints=b.diceTwoPoints,fuc=
	function()
		connect.IsZanTing=false

		local pData = this.GetPlayerDataBySeat(b.seat)
		local index = this.GetUIIndex(this.GetUIIndexBySeat(b.seat),playerSize);
		for i = 1, #b.zhiMahjongs do
			pData.paiHe:append(b.zhiMahjongs[i]);
		end
		
		rollResult = b;

		this.SetDipaiNum(b.surplus);

		--1.获得要出的几个牌的游戏对象
		local effobjs = {};
		--2.获得要出的几个牌的位置
		--local fromPos = {};
		--local toPos = {};
		for i = 1, 4 do
			effobjs[i] = effectGang:GetChild(i-1);
			if i<=#b.zhiMahjongs then
				--设置牌的值
				effobjs[i]:Find("Pai"):GetComponent("UISprite").spriteName = this.GetCardTextName(pData.paiHe[#pData.paiHe - #b.zhiMahjongs + i],cardText);
				--fromPos[i] = effobjs[i].position;
				--toPos[i] = playerThrow[this.GetUIIndex(index,playerSize)]:GetChild(#pData.paiHe - #b.zhiMahjongs + i -1).position;
				effobjs[i].gameObject:SetActive(true);
			else
				effobjs[i].gameObject:SetActive(false);
			end
		end
		effectGang.gameObject:SetActive(true);
		effectGang:GetComponent('UIGrid'):Reposition();
		StartCoroutine(function()
			WaitForSeconds(1.5)
			effectGang.gameObject:SetActive(false);
			this.RefreshTabelThrowByIndex(index,pData.paiHe, pData.seat);
		end)
		--隐藏其他玩家操作提示[抢杠胡结束]
		if b.seat == mySeat then
			this.SetWaitOpTip(false,"");
		end



		lastOperat.op = csm_pb.GANGPAI;
		lastOperat.plate = this.GetOpreationPlates(myData.operations);
		lastOperat.seat = b.seat
		this.SetBuGangData(myData);
		this.RefreshOperationSend(b.operations, 'ZhiShaiZi');
	end})
end

function this.OnPlayerAskLao(msg)
	print('OnPlayerAskLao')
	local b = csm_pb.RAskLao()
	b:ParseFromString(msg.body)

	if mySeat == b.seat then
		print("playerTingButton activeSelf"..tostring(playerTingButton.gameObject.activeSelf));
		if playerTingButton.gameObject.activeSelf then 
			panelMessageBox.SetParamers(OK_CANCLE, this.OnClickMsgBoxOk, this.OnClickMsgCancle, '是否捞海底？');
		else
			panelMessageBox.SetParamers(ONLY_CANCLE, this.OnClickMsgBoxOk, this.OnClickMsgCancle, '是否捞海底？');
		end
		
		PanelManager.Instance:ShowWindow('panelMessageBox');
	else
		this.SetWaitOpTip(true,"请等待其他玩家操作");

	end
end

function this.OnClickMsgBoxOk()
	local msg = Message.New()
	msg.type = csm_pb.LAOHAIDI
	SendGameMessage(msg, nil)
end

function this.OnClickMsgCancle()
	local msg = Message.New()
	msg.type = csm_pb.FOLD
	SendGameMessage(msg, nil)
end

function this.OnPlayerLaoHaiDi(msg)
	print('OnPlayerLaoHaiDi')
	local action = csm_pb.RLaoHaiDi();
	action:ParseFromString(msg.body);
	--更新玩家操作
	if action.seat == mySeat then
		local myData = this.GetPlayerDataBySeat(mySeat);
		tableClear(myData.operations);
		tableAdd(myData.operations,action.operations);

		this.SetBuGangData(myData);
		this.RefreshOperationSend(action.operations, 'LaoHaiDi');
		this.SetWaitOpTip(false,"");
	else
		this.SetWaitOpTip(true,"请等待其他玩家操作");
	end

	local b = this.GetFreeBirds(0);
	if #b > 0 then
		b[1]:GetComponent('UIWidget').alpha = 1
		b[1]:Find('Pai'):GetComponent('UISprite').spriteName = this.GetCardTextName(action.mahjong,cardText);
		b[1].gameObject:SetActive(true);
	else
		--print('get birds error')
	end
	DelayMsgDispatch(connect, 0.5)
end

function this.OnPlayerHuPai(msg)
	print('OnPlayerHuPai')
	local b = csm_pb.RWin()
	b:ParseFromString(msg.body)

	
	operation_send.gameObject:SetActive(false);

	this.OperationForbidden(this.GetPlayerDataBySeat(mySeat).sealPai);
	--print("operation_mask-------------->9");

	this.SetPlateUIColor(playerGridHand[0], {}, false)
	for i=1,#b.winPlayers do
		local index = this.GetUIIndexBySeat(b.winPlayers[i].seat);
		if #b.winPlayers[i].huItems > 0 then
			local p = this.GetPlayerDataBySeat(b.winPlayers[i].seat)
			if b.winPlayers[i].selfMo then
				if roomData.setting.roomTypeValue == proxy_pb.CSM then
					AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(p.sex==1 and 'man_' or 'woman_')..'zimo')
				else
					AudioManager.Instance:PlayAudio((p.sex==1 and 'man_' or 'woman_').."zimo")
				end
				effManger.ShowEffect(gameObject, 'zm', playerHupaiPos[this.GetUIIndex(this.GetUIIndexBySeat(b.winPlayers[i].seat),playerSize)])
			else
				if roomData.setting.roomTypeValue == proxy_pb.CSM then
					AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(p.sex==1 and 'man_' or 'woman_')..'hu')
				else
					AudioManager.Instance:PlayAudio((p.sex==1 and 'man_' or 'woman_').."hu")
				end
				effManger.ShowEffect(gameObject, 'hu', playerHupaiPos[this.GetUIIndex(this.GetUIIndexBySeat(b.winPlayers[i].seat),playerSize)]);
			end

			--删掉摸的那张牌[因为手牌中含有摸到的那张牌，]
			if b.winPlayers[i].selfMo then
				tableRemovePlate(b.winPlayers[i].mahjongs,b.winPlayers[i].huItems[1].huMahjong);
			end
		end

		coroutine.start(  --延时摊牌
		function()
			coroutine.wait(0.2);
			this.RefreshGridHandByIndex(this.GetUIIndex(index,playerSize),this.GetUIIndex(index,playerSize),b.winPlayers[i].mahjongs, #b.winPlayers[i].mahjongs, false, -1, tableClone(b.winPlayers[i].mahjongs));
			--自摸的话，显示手上的牌，因为RefreshGridHandByIndex会隐藏掉手上的牌，需要再显示
			if #b.winPlayers[i].huItems > 0 then
				if b.winPlayers[i].selfMo then
					this.RefreshCurMoPai(index, b.winPlayers[i].huItems[1].huMahjong, true);
				end
			end
		end
		)

		this.HideTiMark(playerGridHand[0]);
		this.HideTiMark(playerCurMoPi[0]);
	end

	--设置放炮通炮
	this.SetPao(b);
	DelayMsgDispatch(connect, 0.5)
end

function this.SetPao(winData)
	if winData.outSeat < 0 then
		return;
	end

	local isFangPao = true
	local winSeat = -1;
	for i = 1, #winData.winPlayers do
		if(winSeat == -1) then
			winSeat = winData.winPlayers[i].seat
		elseif winSeat ~= winData.winPlayers[i].seat then
			isFangPao = false;
			break;
		end

	end

	if isFangPao  then -- 放炮
		--print("tp-------------->1");
		effManger.ShowEffect(gameObject, 'fp', playerHupaiPos[this.GetUIIndex(this.GetUIIndexBySeat(winData.outSeat),playerSize)]);
	else -- 通炮
		--print("fp-------------->2");
		effManger.ShowEffect(gameObject, 'tp', playerHupaiPos[this.GetUIIndex(this.GetUIIndexBySeat(winData.outSeat),playerSize)]);
	end

end

function this.OnPlayerGuo(msg)
	print("OnPlayerGuo was called");
	local b = csm_pb.RSeat();
	b:ParseFromString(msg.body);
	if b.seat == mySeat then
		operation_send.gameObject:SetActive(false);
		--operation_mask.gameObject:SetActive(false);
		--PanelManager.Instance:HideWindow('panelMessageBox');
		this.OperationForbidden(this.GetPlayerDataBySeat(mySeat).sealPai);
		--print("operation_mask-------------->10");
		this.SetPlateUIColor(playerGridHand[0], {}, false);
	end

	--处理听牌和提牌
	if b.seat == mySeat then
		--处理提牌
		this.HideTiMark(playerGridHand[0]);
		this.HideTiMark(playerCurMoPi[0]);
		tingData = {};
	end
	DelayMsgDispatch(connect, 0.5)
end

function this.OnOver(msg)
	print('OnOver was called ')
	local b = csm_pb.ROver()
	b:ParseFromString(msg.body)

	RoundAllData.data = b
	RoundAllData.mySeat = mySeat
	RoundAllData.playerData = playerData
	RoundAllData.roomData = roomData
	RoundAllData.over = true
	RoundAllData.playName = roomData.playName
	local Trusteeships={}
	for i = 0, roomData.setting.size-1 do
		local  k = i
		if roomData.setting.size == 3 then
			if i == 2 then
				k = 3					
			end
		elseif roomData.setting.size == 2 then
			if i == 1 then
				k = 2					
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

	local overData = {};
	overData.RoundAllData = RoundAllData;
	overData.roomInfo = roomInfo;
	print("b.complete:"..tostring(b.complete))
	print("this.hasStageClear:"..tostring(this.hasStageClear))
	if not b.complete and this.hasStageClear==false then
		PanelManager.Instance:HideWindow('panelInGamemj');
		PanelManager.Instance:HideWindow('panelStageClear_mj');
		PanelManager.Instance:HideWindow("panelsuddenBonus");
		PanelManager.Instance:HideWindow("panelStartHu");
		PanelManager.Instance:ShowWindow("panelStageClearAll_mj",overData);
	end
	
	--print('on over complete:'..tostring(b.complete))
end

function this.OnDissolve(msg)
	this.fanHuiRoomNumber = nil
	local b = csm_pb.RDissolve()
	b:ParseFromString(msg.body)
	--print('OnDissolve seat:'..b.seat..' decision:'..b.decision)
	print('房间已被解散');
	this.HideAllKuang();

	if b.decision == csm_pb.APPLY then--申请解散

		DestroyRoomData.roomData.dissolution.applicant = b.seat;
		while #DestroyRoomData.roomData.dissolution.acceptors > 0 do
			table.remove(DestroyRoomData.roomData.dissolution.acceptors, #DestroyRoomData.roomData.dissolution.acceptors)
		end
		if b.remainMs and b.remainMs > 0 then
			DestroyRoomData.roomData.dissolution.remainMs = b.remainMs/1000;
		else
			DestroyRoomData.roomData.dissolution.remainMs = 300;
		end


		this.SetDestoryPanelShow();
		-- --print('applicant:'..dissolution.applicant)
	elseif b.decision == csm_pb.AGREE then
		table.insert(DestroyRoomData.roomData.dissolution.acceptors, b.seat);
		--DestroyRoomData.roomData.dissolution = dissolution;
		panelDestroyRoom.Refresh();
		-- --print('applicant:'..dissolution.applicant..' acceptors:'..table.concat(dissolution.acceptors, ','))
	elseif b.decision == csm_pb.AGAINST then
		panelDestroyRoom.Refresh(b.seat)
	else
		Debugger.LogError('decision unkown type:'..b.decision, nil)
	end
end

function this.Destroy(msg)
	print('房间已被销毁');
	this.fanHuiRoomNumber = nil
	this.QuitVoiceRoom()
	this.StopAllOfflineIncrease()
	this.StopCheckNetState()
	NetWorkManager.Instance:DeleteConnect('game')
	PanelManager.Instance:HideWindow('panelDestroyRoom')
	panelLogin.HideGameNetWaitting();

	if PanelManager.Instance:IsActive('panelGameSetting_mj') then
		PanelManager.Instance:HideWindow('panelGameSetting_mj');
	end
	if PanelManager.Instance:IsActive('panelVisitingCard') then
		PanelManager.Instance:HideWindow('panelVisitingCard');
	end
	if PanelManager.Instance:IsActive('panelChat') then
		PanelManager.Instance:HideWindow('panelChat');
	end

	if PanelManager.Instance:IsActive("panelChiPai_mj") then
		PanelManager.Instance:HideWindow('panelChiPai_mj');
	end

	coroutine.stop(trusteeshipcor);
	DelegateTime.gameObject:SetActive(false);
	DelegatePanel.gameObject:SetActive(false);

	if panelStageClear_mj then
		panelStageClear_mj.setButtonsStatus(true)
	end
	-- 没有开局解散房间直接退到大厅
	if roomData.round == 1 and roomData.state == csm_pb.READYING then
		if roomData.clubId ~= '0' then
			print('！！！！！！！！！！！！！！！！！！！！！牌友群' )
			local data = {}
			data.name = 'panelInGamemj'
			-- data.clubId = roomData.clubId
			PanelManager.Instance:ShowWindow('panelClub', data)
		else
			PanelManager.Instance:HideAllWindow()
			PanelManager.Instance:ShowWindow('panelLobby');
		end
		roomData.clubId = '0'
		--panelInGame =nil
	end
end

function this.SetDestoryPanelShow() 
	PanelManager.Instance:HideWindow('panelDestroyRoom')
    PanelManager.Instance:ShowWindow('panelDestroyRoom')
end

function this.SetReadyVisiable()

	function setReady(index,p)
		if p.ready then 
			playerReady[index].gameObject:SetActive(true);
		else
			playerReady[index].gameObject:SetActive(false);
		end
	end

    for i=0,playerSize -1 do
		local p = this.GetPlayerDataByUIIndex(i);
		if roomData.state ~= csm_pb.GAMING and p then
			setReady(this.GetUIIndex(i,playerSize),p);
		else
			playerReady[this.GetUIIndex(i,playerSize)].gameObject:SetActive(false);

        end
    end
end

function this.getAccorColor(color)
	if color == 1 then
		return Color.New(57/255,123/255,174/255);
	else
		return Color.New(52/255,209/255,186/255);
	end
end

function this.getNumColor(color)
	if color == 1 then
		return Color.New(76/255,189/255,197/255);
	else
		return Color.New(205/255,220/255,114/255);
	end
end

function this.SetGameColor(color)
	dipai:Find("frame/roundHead"):GetComponent("UILabel").color = this.getAccorColor(color);
	dipai:Find("frame/roundHead/roundTail"):GetComponent("UILabel").color = this.getAccorColor(color);
	roomRound:GetComponent("UILabel").color = this.getNumColor(color);
	dipai:Find("frame/leftHead"):GetComponent("UILabel").color = this.getAccorColor(color);
	dipai:Find("frame/leftHead/leftTail"):GetComponent("UILabel").color = this.getAccorColor(color);
	dipai:Find('frame/leftCard'):GetComponent('UILabel').color = this.getNumColor(color);
end

function this.SetRoundNum(num)
	roomRound:GetComponent('UILabel').text = num..'/'..roomData.setting.rounds;
end

function this.SetDipaiNum(num)
	dipai:Find('frame/leftCard'):GetComponent('UILabel').text = string.format('%d', num);
end

function this.OnClickButtonSetting(go)
	AudioManager.Instance:PlayAudio('btn')
	----print('playerSize:'..roomData.setting.size..' playerData size:'..#playerData ..' mySeat:'..mySeat)
	-- if playerSize == #playerData or mySeat == 0 then
	-- 	UnityEngine.PlayerPrefs.SetInt('showWhichButton', 1)
	-- else
	-- 	UnityEngine.PlayerPrefs.SetInt('showWhichButton', 2)
	-- end
	local sendData = {};

	local gpsdata = {};
	gpsdata.playerData = playerData;
	gpsdata.distanceTable = this.GetDistance(playerSize);
	gpsdata.playerSize = playerSize;

	sendData.gpsdata = gpsdata;
	sendData.roomData = roomData;
	sendData.mySeat  = mySeat;
	local  isallready = true
	for i=1,#playerData do
		if playerData[i].ready == false then
			isallready = false
			break;
		end
	end
	print( roomData.round,isallready,mySeat)
	if roomData.round > 1 or isallready  then
		sendData.ingame = true;
		PanelManager.Instance:ShowWindow('panelGameSetting_mj', sendData)
	else
		sendData.ingame = false;
		PanelManager.Instance:ShowWindow('panelGameSetting_mj', sendData)
		
	end
    --PanelManager.Instance:ShowWindow('panelGameSetting_mj');
end

--设置游戏背景
function this.ChooseBG(bgIndex)
	print("ChooseBG:"..bgIndex);

	for i = 1,BgColorNum do
		local bg = gameObject.transform:Find('gameBGs/bg'..i);
		if bgIndex == i then 
			bg.gameObject:SetActive(true);
		else
			bg.gameObject:SetActive(false);
		end
	end

	this.SetGameColor(bgIndex);
end

--设置牌的颜色
function this.SetCardColor(colorIndex)
	 print("SetCardColor:"..colorIndex);
	cardColor = colorIndex;

	this.RefreshAllGridXi();
	this.RefreshAllTabelThrow();
	--设置手中的牌的颜色
	for i = 0,3 do
		for j=0,playerGridHand[i].childCount-1 do
			local cardItem = playerGridHand[i]:GetChild(j);
			if cardItem then
				--print("set hand color:"..cardColor);
				cardItem:GetComponent('UISprite').spriteName = this.getColorCardName(CONST.cardPrefabHandStandBg[i+1],cardColor);
			end
		end
	end
	--设置摸牌的颜色
	for i = 0,playerSize-1 do
		playerCurMoPi[this.GetUIIndex(i,playerSize)]:Find("curMoPai"):GetComponent("UISprite").spriteName = this.getColorCardName(CONST.cardPrefabHandStandBg[(this.GetUIIndex(i,playerSize))+1],cardColor);
	end

end

--设置牌的字体
function this.SetCardText(textIndex)
	print("SetCardText:"..textIndex);
	cardText =  textIndex
	this.RefreshAllGridXi();
	this.RefreshAllTabelThrow();
	this.RefreshAllGridHand();
	--设置手中的牌的颜色
	for i = 0,3 do
		for j=0,playerGridHand[i].childCount-1 do
			local cardItem = playerGridHand[i]:GetChild(j);
			if cardItem then
				--print("set hand color:"..cardColor);
				-- print("cardItem:"..tostring(cardItem).."|j:"..j);
				if i == 0 then
					local plate = GetUserData(cardItem.gameObject);
					cardItem:GetChild(0):GetComponent('UISprite').spriteName = this.GetCardTextName(plate,textIndex);
				end

			end
		end
	end
	--设置摸牌的颜色
	for i = 0,playerSize-1 do
		if i == 0 then
			local itemSp = playerCurMoPi[this.GetUIIndex(i,playerSize)]:GetChild(0):Find("card"):GetComponent('UISprite');
			local plate = GetUserData(itemSp.transform.parent.gameObject);
			if plate then
				itemSp.spriteName = this.GetCardTextName(plate,textIndex);
				itemSp.width = this.GetCardPlateSize(plate,textIndex).x;
				itemSp.height = this.GetCardPlateSize(plate,textIndex).y;
			end
		end
	end

	--设置听牌的颜色
	local tingScrollView = playerTingButton:Find("frame/TingScrollView");
	tingScrollView.gameObject:SetActive(true);
	local tingGrid = playerTingButton:Find("frame/TingScrollView/Grid");
	for i = 0, tingGrid.childCount-1 do
		local obj = tingGrid:GetChild(i);
		obj:GetComponent("UISprite").spriteName = this.getColorCardName(CONST.cardPrefabHandStandBg[1],cardColor);
		local data = GetUserData(obj.gameObject);
		obj:Find("card"):GetComponent("UISprite").spriteName = this.GetCardTextName(data.mahjong,cardText);
	end

end


function this.GetCardColor()
	return cardColor;
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



function this.OnClickButtonInvite(go)
	print("OnClickButtonInvite was called");
	local str = "";
	str = str ..'房间号：' .. roomInfo.roomNumber .. ',';
	if roomData.setting.roomTypeValue == proxy_pb.CSM then
		str = str .."长沙麻将,";
	elseif roomData.setting.roomTypeValue == proxy_pb.ZZM then
		str = str .."转转麻将,";
	elseif roomData.setting.roomTypeValue == proxy_pb.HZM then
		str = str .."红中麻将,";
	end

	str = str ..GetMJRuleText(roomData.setting,false,true);

	str = str .."房已开好,就等你来！"

	--print("分享信息", str);
	local que = roomData.setting.size - tableCount(playerData);
	local title = roomInfo.roomNumber.."房，"..roomData.playName..roomData.setting.size.."缺"..que
	--print("title",title);
	--print("panelLogin.HttpUrl:"..tostring(panelLogin.HttpUrl));

	PlatformManager.Instance:ShareLink('http://'..panelLogin.HttpUrl..'/shareRoom.html?appType=1&state=' ..proxy_pb.MJ..roomInfo.roomNumber, title, str, 0);

end

function this.OnClickButtonNext(go)
	AudioManager.Instance:PlayAudio('btn')
	if RoundData.over and RoundAllData.over then
		--print("panelStageClearAll_mj roomInfo.roomNumber"..roomInfo.roomNumber);
		local overData = {};
		overData.RoundAllData = RoundAllData;
		overData.roomInfo = roomInfo;
		PanelManager.Instance:ShowWindow('panelStageClearAll_mj',overData);
	else
		local msg = Message.New()
		msg.type = csm_pb.READY
		SendGameMessage(msg, nil);
		go:SetActive(false);
	end
end



function this.OnSendChat(msg)
	local b = csm_pb.RChat()
	b:ParseFromString(msg.body)
	----print('OnSendChat seat:'..b.seat..' type:'..b.type)

	local index = this.GetUIIndexBySeat(b.seat)
	if b.type == 0 then --图片
		this.showEmoji(index, b.position)
	elseif b.type == 1 then -- 语音文本
		local p = this.GetPlayerDataBySeat(b.seat)
		this.playVoice(string.format('chat_%d_%d', p.sex, b.position))
		this.showText(index, b.text)
	else --纯文本
		this.showText(index, b.text)
		local p = this.GetPlayerDataBySeat(b.seat)
		if panelChat then
			panelChat.AddChatToLabel(p.name..':'..b.text)
		else
			table.insert(this.chatTexts, p.name..':'..b.text)
		end
	end
end

function this.playVoice(vioceName)
	AudioManager.Instance:PlayAudio(vioceName)
end

function this.showText(index, text)
	coroutine.stop(playerCoroutine[index])
	playerCoroutine[index] = coroutine.start(
		function()
			playerMsg[this.GetUIIndex(index,playerSize)].gameObject:SetActive(true)
			playerMsg[this.GetUIIndex(index,playerSize)]:GetComponent('UILabel').text = text
			--playerMsg[this.GetUIIndex(index,playerSize)]:GetComponent('UILabel').color = Color(244/255,244/255,244/255)
			local width = playerMsg[this.GetUIIndex(index,playerSize)]:GetComponent('UILabel').width
			playerMsgBG[this.GetUIIndex(index,playerSize)]:GetComponent('UISprite').width = width + 40
			playerEmoji[this.GetUIIndex(index,playerSize)].gameObject:SetActive(false)
			coroutine.wait(5)
			playerMsg[this.GetUIIndex(index,playerSize)].gameObject:SetActive(false)
		end
	)
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
	playerMsg[this.GetUIIndex(seat,playerSize)].gameObject:SetActive(false)
	playerEmoji[this.GetUIIndex(seat,playerSize)].gameObject:SetActive(true)
	coroutine.stop(playerCoroutine[seat])
	playerCoroutine[seat] = coroutine.start(function()
		for i = 1, 30 do
			playerEmoji[this.GetUIIndex(seat,playerSize)]:GetComponent('UISprite').spriteName = str .. '_' .. (i % myTable[str] + 1)
			coroutine.wait(0.1)
		end
		playerEmoji[this.GetUIIndex(seat,playerSize)].gameObject:SetActive(false)
	end)
end

function this.VoiceCoroutineInit()
	if GvoiceCor then
		StopCoroutine(GvoiceCor)
	end
	GvoiceCor = StartCoroutine(this.TickNGCloudVoice)
	NGCloudVoice.Instance:ApplyMessageKey();
end

function this.TickNGCloudVoice()
	while gameObject.activeSelf do
		NGCloudVoice.Instance:Poll()
		coroutine.wait(0.03)
	end
end

local voiceMemeber = {}
local voiceCheckCor = nil
function this.TickCheckVoice()
	while gameObject.activeSelf do
		local curTime = os.time()
		for i=#voiceMemeber,1,-1 do
			if curTime - voiceMemeber[i].time > 2 then
				if voiceMemeber[i].stat ~= 0 then
					--print('manual close memberId:'..voiceMemeber[i].id)
					this.OnMemberVoiceStateChanged(voiceMemeber[i].id, 0)
				end
				table.remove(voiceMemeber, i)
			end
		end
		
		coroutine.wait(2)
	end
end

function this.JoinTeamRoom()
	NGCloudVoice.Instance:SetModeRealTime()
	NGCloudVoice.Instance:JoinTeamRoom('csm' .. roomInfo.roomNumber)
end

function this.QuitVoiceRoom()
	if Util.GetPlatformStr() == 'win' then
		return
	end
	NGCloudVoice.Instance:OnQuitRoomCompleted(this, function(that, args)
		coroutine.stop(voiceCor)
		NGCloudVoice.Instance:ClearQuitRoomCompletedCallback();
	end)
	NGCloudVoice.Instance:QuitRoom()
end

function this.MemberVoiceHandler(that, args)
	-- a int array composed of [memberid_0, status,memberid_1, status ... memberid_2*count, status] here,
	-- status could be 0, 1, 2. 0 meets silence and 1/2 means saying
	local members = args[0]		
	local count = args[1]	-- count of members who's status has changed.
	----print('MemberVoiceHandler:'..count)
	for i = 0, count - 1 do
		local index = i * 2
		local memberId = members[index]
		local status = members[index + 1]
		that.OnMemberVoiceStateChanged(memberId, status)
	end
end

function this.OnMemberVoiceStateChanged(memberId, status)
	print('OnMemberVoiceStateChanged memberId:'..memberId..' status:'..status)
	if memberId == nil or status == nil then
		return
	end

	local player = this.GetPlayerByMemberId(memberId)
	if not player then
		return
	end

	local index = this.GetUIIndexBySeat(player.seat)
	local active = (status ~= 0);
	playerSound[this.GetUIIndex(index,playerSize)].gameObject:SetActive(active);

	-- 如果玩家已经屏蔽实时语音，退出
	if UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 1) == 0 then
		return
	end

	if active then
		AudioManager.Instance.AudioOn = false
		AudioManager.Instance.MusicOn = false
		this.openSpeak = true
	else
		if not this.openMic then
			AudioManager.Instance.AudioOn = UnityEngine.PlayerPrefs.GetInt('audio_on', 1) == 1
			AudioManager.Instance.MusicOn = UnityEngine.PlayerPrefs.GetInt('music_on', 1) == 1
		end
		this.openSpeak = nil
	end
	
	local mem = nil
	for i=1,#voiceMemeber do
		if voiceMemeber[i].id == memberId then
			mem = voiceMemeber[i]
			mem.stat = status
			mem.time = os.time()
			break
		end
	end
	if not mem then
		mem = {}
		mem.id = memberId
		mem.stat = status
		mem.time = os.time()
		table.insert(voiceMemeber, mem)
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
			print('说话')
			this.startTalk()
		else
			print('松开')
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

-- 屏蔽其他玩家实时语音状态
function this.ShieldVoiceEvent()
	local canOpenSpeaker = UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 1)
	if Util.GetPlatformStr() ~= 'win' then
		if canOpenSpeaker == 1 then
			NGCloudVoice.Instance:OpenSpeaker()
		else
			NGCloudVoice.Instance:CloseSpeaker()
		end
	end
end

function this.GetPlayerByMemberId(memberId)
	for i = 1, #playerData do
		local p = playerData[i]
		print("i:"..i.."|memberId:"..tostring(p.memberId));
		if p and p.memberId and p.memberId == memberId then
			return p
		end
	end
	return nil
end

function this.OnVoiceMember(msg)
	local b = csm_pb.RVoiceMember()
	b:ParseFromString(msg.body)
	--print('seat ' .. b.seat .. ' join voice room, member id is ' .. b.memberId)
	local player = this.GetPlayerDataBySeat(b.seat)
	if player then
		player.voiceId = b.voiceId;
		NGCloudVoice.Instance:Click_btnDownloadFile(player.voiceId);
	else
		print('无法通过座位号 ' .. b.seat .. ' 获取到用户信息')
	end
end

function this.RefreshState()
    while gameObject.activeSelf do
		-- 修改电池电量
		batteryLevel.fillAmount = UnityEngine.SystemInfo.batteryLevel

		-- 重设网络状态
		local networkType = PlatformManager.Instance:GetNetworkType();
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
		-- msg.type = csm_pb.APPLY
		-- SendGameMessage(msg, nil)
		-- local msg = Message.New()
        msg.type = csm_pb.DISSOLVE
        local body = csm_pb.PDissolve()
        body.decision = csm_pb.APPLY
        msg.body = body:SerializeToString()
        SendGameMessage(msg, nil);
	else
		print("离开房间")
		AudioManager.Instance:PlayAudio('btn')
		local msg = Message.New()
		msg.type = csm_pb.LEAVE_ROOM
		SendGameMessage(msg, nil)
	end

	this.fanHuiRoomNumber = nil
end

function this.OnClicButtonLeaveRoom(go)
	print("返回大厅")
	-- AudioManager.Instance:PlayAudio('btn')
    -- local msg = Message.New()
    -- msg.type = csm_pb.LEAVE_ROOM
	-- SendGameMessage(msg, nil)
	print('返回大厅')
    print(mySeat)                                   --房主在lobby退出可以返回，房间留存
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

function this.SetMyAlpha(alpha)
    gameObject.transform:GetComponent('UIPanel').alpha = alpha
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
            data.name = gameObject.name
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

function this.OnRoomError(msg)
	panelMessageTip.SetParamers('加入房间错误', 2)
	PanelManager.Instance:ShowWindow('panelMessageTip')
	coroutine.start(
    function()
        coroutine.wait(2)
        panelLogin.HideGameNetWaitting();
        if roomData.clubId ~= '0' then
            local data = {}
            data.name = gameObject.name
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

function this.SureGuoMsgBox(go)
	if(ButtonHu.gameObject.activeSelf)then --胡的时候确认一下
		panelMessageBox.SetParamers(OK_CANCLE,
		function ()
			this.OnClickOperationButton(ButtonGuo)
		end, nil, '是否确定放弃胡牌？')
		PanelManager.Instance:ShowWindow('panelMessageBox')
	else 
		this.OnClickOperationButton(ButtonGuo)
	end
end

function this.OnClickOperationButton(go)
	print("OnClickOperationButton was called");
	local msg = Message.New()
	local body = csm_pb.POperation()
	this.OperationForbidden(this.GetPlayerDataBySeat(mySeat).sealPai);

	if go.transform == ButtonHu then
		local pData = this.GetPlayerDataBySeat(mySeat);
		if pData.haveStartHu then--起手胡
			msg.type = csm_pb.START_HU;
			operation_mask.gameObject:SetActive(true);
			this.SetWaitOpTip(roomData.waitOperateTip and roomData.activeSeat == mySeat,"请等待其他玩家操作");
		elseif this.GetSuddenBonus() then--中途起手
			if #suddenBonusData > 1 then
				local data = suddenBonusData;
				PanelManager.Instance:ShowWindow('panelsuddenBonus',data);
			else
				msg.type = csm_pb.ZT_HU;
				body.mahjong = suddenBonusData[1].op_plate;
				table.insert(body.mahjongs,suddenBonusData[1].op_mahjong);
				msg.body = body:SerializeToString();
				SendGameMessage(msg, nil)
				return ;

			end
		else
			if lastOperat.plate then
				body.mahjong = lastOperat.plate[1];
			else--游戏重连会遇到点胡会报错的问题，这就需要去玩家数据中找到胡牌项
				body.mahjong = this.getHuPlates(this.GetPlayerDataBySeat(mySeat).operations)[1];
			end

			msg.type = csm_pb.HUPAI
		end

		operation_send.gameObject:SetActive(false);


		--print("Hupai----------------------------------->");
	elseif go.transform == ButtonGuo then
		msg.type = csm_pb.FOLD
		PanelManager.Instance:HideWindow('panelChiPai_mj')
		if ButtonHu.gameObject.activeSelf then --如果当前轮到我出牌
			needChuPai = roomData.activeSeat == mySeat and (not roomData.waitOperateTip);
			line.gameObject:SetActive(needChuPai);
			this.SetWaitOpTip(roomData.waitOperateTip and roomData.activeSeat == mySeat,"请等待其他玩家操作");
		end

		operation_send.gameObject:SetActive(false);
		this.SetPlateUIColor(playerGridHand[0], {}, false);

	elseif go.transform == ButtonChi or go.transform == ButtonPeng or go.transform == ButtonGang or go.transform == ButtonBu  then

		if ButtonHu.gameObject.activeInHierarchy then
			panelMessageBox.SetParamers(OK_CANCLE,
					function () this.SureIgnoreHuPai(go); end, nil, '是否确定放弃胡牌？');
			PanelManager.Instance:ShowWindow('panelMessageBox');
		else
			this.SureIgnoreHuPai(go);
			return;
		end
		return;
	else
		Debugger.LogError('OnClickOperationButton unkown button {0}', go.name)
	end
	msg.body = body:SerializeToString();
	SendGameMessage(msg, nil)
end


function this.SureIgnoreHuPai(go)
	print("SureIgnoreHuPai was called");
	local op = nil
	if go.transform == ButtonChi then
		op = csm_pb.CHI
	elseif go.transform == ButtonPeng then
		op = csm_pb.PENG
	elseif go.transform == ButtonGang  then
		op = this.GetOperationByGameType(roomData.setting.roomTypeValue);
	else
		op = csm_pb.BU
	end

	--筛选操作
	local opdata = {};
	local newOperationData =  this.FilterOp(ROperationData,op);

	opdata.op = op;
	opdata.newOperationData = newOperationData;
	if  #newOperationData > 1 then
		PanelManager.Instance:ShowWindow('panelChiPai_mj',opdata);
	else
		this.SendMsg(1,newOperationData);
	end

end

--筛选操作
function this.FilterOp(OperationData, opType)
	if OperationData == nil or #OperationData ==0 then
		return {};
	end

	local newROperationData = {};

	for i = 1, #OperationData do
		if OperationData[i].type == opType then
			table.insert(newROperationData,OperationData[i]);
		end

	end

	return newROperationData;

end


function this.SendMsg(chiIndex,OperationData)
	--print("SendMsg was called,chiIndex:"..chiIndex);
	--print("OperationData.length:"..(#OperationData));
	local msg = Message.New()
	local op = OperationData[chiIndex];
	if not op then
		Debugger.LogError('send msg error', nil)
		return
	end
	
	if op.type == csm_pb.CHI then
		msg.type = csm_pb.CHIPAI
	elseif op.type == csm_pb.PENG then
		msg.type = csm_pb.PENGPAI
	elseif op.type == csm_pb.GANG then
		msg.type = csm_pb.GANGPAI
	elseif op.type == csm_pb.BU then
		msg.type = csm_pb.BUPAI
	else
		Debugger.LogError('send msg type error', nil)
		return
	end
	local body = csm_pb.POperation()
	body.mahjong = OperationData[chiIndex].mahjong;
	for i=1,#OperationData[chiIndex].mahjongs do
		if op.type == csm_pb.CHI then
			if body.mahjong ~= OperationData[chiIndex].mahjongs[i] then
				body.mahjongs:append(OperationData[chiIndex].mahjongs[i])
			end
		else
			body.mahjongs:append(OperationData[chiIndex].mahjongs[i])
		end
	end
	--print('send msg mahjong:'..body.mahjong..' mahjongs:'..table.concat(body.mahjongs, ','))
	msg.body = body:SerializeToString()
	SendGameMessage(msg, nil)
end

function this.DoRemovePlates(seat, plates, ignoreUI,isGang)
	local pData = this.GetPlayerDataBySeat(seat)
	if not pData then
		print('pData is nil');
		return
	end
	
	local index = this.GetUIIndexBySeat(seat);
	--是自己
	if index == 0 then
		for i=1,#plates do
			local p = plates[i]
			for j=#pData.mahjongs,1,-1 do
				if pData.mahjongs[j] == p then
					pData.mahjongs:remove(j)
					break
				end
			end
		end
	else
		if not isGang then 
			pData.mahjongCount = pData.mahjongCount - #plates
		end
	end

	-- print("#plates:"..#plates.."pData.mahjongCount:"..pData.mahjongCount);
	
	if not ignoreUI then
		this.RefreshGridHandByIndex(index,index, pData.mahjongs, pData.mahjongCount, false, -1, {});
	end
end

function this.RefreshOperationSend(operations, from)
	print('RereshOperationSend:'..#operations..' '..from)
	if #operations == 1 and operations[1].operation == csm_pb.ZTHU then
		playerTingButton:Find("frame").gameObject:SetActive(false);
		return
	end
	operation_send.gameObject:SetActive(#operations ~= 0);

	ButtonHu.gameObject:SetActive(false);
	ButtonGang.gameObject:SetActive(false);
	ButtonPeng.gameObject:SetActive(false);
	ButtonChi.gameObject:SetActive(false);
	ButtonGuo.gameObject:SetActive(true);
	ButtonBu.gameObject:SetActive(false);
	PanelManager.Instance:HideWindow('panelChiPai_mj');

	local allChangeColorPlate = {}
	local haveGang = false;

	for i=1,#operations do
		if operations[i].operation ~= csm_pb.HU then
			local op,colorPlate = this.GetKindTable(operations[i].mahjongs, operations[i].operation);
			tableMerge(allChangeColorPlate, colorPlate)
			tableMerge(ROperationData, op)
		end

		if operations[i].operation == csm_pb.CHI then
			ButtonChi.gameObject:SetActive(true)
		elseif operations[i].operation == csm_pb.PENG then
			ButtonPeng.gameObject:SetActive(true)
		elseif operations[i].operation == csm_pb.GANG then
			ButtonGang.gameObject:SetActive(true);
			haveGang = true;
		elseif operations[i].operation== csm_pb.BU then
			this.SetOpertionByGameType(operations[i].operation);
			haveGang = true;
		elseif operations[i].operation == csm_pb.HU then
			ButtonHu.gameObject:SetActive(true);
			playerTingButton:Find("frame").gameObject:SetActive(false);
		elseif operations[i].operation == csm_pb.LAO then
			--捞海底暂时先不处理
		elseif operations[i].operation == csm_pb.ZTHU then--中途起手胡
			ButtonHu.gameObject:SetActive(true);
			playerTingButton:Find("frame").gameObject:SetActive(false);
			haveGang = true;
		else
			Debugger.LogError('RereshOperationSend unkown type {0}', tostring(operations[i].operation))
		end
	end

	tableRemoveSameEle(allChangeColorPlate, haveGang and 4 or 2)
	--print('operation mahjongs num:'..#ROperationData..' lastPlate:'..table.concat(lastOperat.plate, ',')..' allChangeColorPlate:'..table.concat(allChangeColorPlate,','))
	if #allChangeColorPlate > 0 then
		this.SetPlateUIColor(playerGridHand[0], allChangeColorPlate, true)
	end

	if ButtonHu.gameObject.activeSelf then
		needChuPaiBefroeHu = needChuPai
		needChuPai = false
		line.gameObject:SetActive(needChuPai);
	end

	operation_send:GetComponent('UIGrid'):Reposition();
end

function this.getHuPlates( operations )
	if not operations then return {} end;
	for i=1,#operations do
		if operations[i].operation == csm_pb.HU then 
			return operations[i].mahjongs;
		end
	end
	return {};
end

--根据麻将类新的不同，转换操作显示
function this.SetOpertionByGameType(operation)
	print("SetOpertionByGameType was called,operation:"..operation);
	--1.长沙麻将 正常
	--2.转转红中 传过来的是补，表现为杠
	if roomData.setting.roomTypeValue == proxy_pb.CSM then
		ButtonBu.gameObject:SetActive(operation == csm_pb.BU);
	else
		ButtonBu.gameObject:SetActive(false);
		ButtonGang.gameObject:SetActive(true);
	end

end

--根据麻将累心不同，返回转换后的操作，（发送消息给服务器的时候用）
function this.GetOperationByGameType(roomType)
	if roomType == proxy_pb.CSM then
		return csm_pb.GANG ;
	elseif roomType == proxy_pb.ZZM or roomType == proxy_pb.HZM then
		return csm_pb.BU;
	end
end

function this.PrintOP(op)
	local opstring = "";
	if op == csm_pb.GUO then
		opstring = "过";
	elseif op == csm_pb.CHI then
		opstring = "吃";

	elseif op == csm_pb.PENG then
		opstring = "碰";

	elseif op == csm_pb.BU then
		opstring = "补";

	elseif op == csm_pb.GANG then
		opstring = "杠";

	elseif op == csm_pb.HU then
		opstring = "胡";

	elseif op == csm_pb.LAO then
		opstring = "捞";
	else
		opstring = "未知操作类型";

	end

	print("current operation:"..opstring);
end

function this.GetKindTable(plates, op_type)
	local plateGroup;
	local kindTabel = {};
	local pData = this.GetPlayerDataBySeat(mySeat);
	local alljionChiPlate = {};
	local count = 0
	--print('GetKindTable op_type:'..op_type..' plates:'..table.concat(plates, ',')..' player mahjongs:'..table.concat(pData.mahjongs,','))

	this.PrintOP(op_type);

	if op_type == csm_pb.CHI then
		for j=1,#plates do
			plateGroup = getIntPart(plates[j]/9)
			local plate = plates[j]
			local splate = nil
			local pb = {}
			for i=1,#pData.mahjongs do
				splate = pData.mahjongs[i]
				if plateGroup == getIntPart(splate/9) and (splate >= plate-2 and splate <= plate+2) then
					table.insert(pb, splate)
				end
			end
			table.insert(pb, plate)
			----print('pb:'..table.concat(pb, ','))
			tableRemoveSameEle(pb)
			table.sort(pb, tableSortAsc)
			----print('pb tableRemoveSameEle:'..table.concat(pb, ','))
			for i=1,#pb do
				if i+2 <= #pb and pb[i+2]-pb[i] == 2 then
					table.insert(kindTabel, {type = csm_pb.CHI, mahjong=plate, mahjongs={pb[i], pb[i+1], pb[i+2]}})
					if pb[i] ~= plate then
						table.insert(alljionChiPlate, pb[i])
					end
					if pb[i+1] ~= plate then
						table.insert(alljionChiPlate, pb[i+1])
					end
					if pb[i+2] ~= plate then
						table.insert(alljionChiPlate, pb[i+2])
					end
					----print('alljionChiPlate :'..table.concat(alljionChiPlate, ','))
				end
			end
		end
		tableRemoveSameEle(alljionChiPlate)
	elseif op_type == csm_pb.PENG or op_type == csm_pb.GANG or op_type == csm_pb.BU then
		for j=1,#plates do
			--计算手牌中的相应牌的数量
			count = 0
			for i=1,#pData.mahjongs do
				if plates[j] == pData.mahjongs[i] then
					count = count + 1
				end
			end
			for i=1,#pData.operationCards do
				local operation_type = pData.operationCards[i].operation;
				local op_cards = pData.operationCards[i].cards;
				if (operation_type == csm_pb.SORT_PENG and plates[j] == op_cards[1]) and (op_type == csm_pb.GANG or op_type == csm_pb.BU) then
					table.insert(kindTabel, {type = op_type, mahjong = plates[j], mahjongs = {plates[j], plates[j], plates[j], plates[j]}})
					table.insert(alljionChiPlate,plates[j])

				end
			end
			if count > 1 and op_type == csm_pb.PENG then
				table.insert(kindTabel, {type = csm_pb.PENG, mahjong = plates[j], mahjongs = {plates[j], plates[j], plates[j]}})
				table.insert(alljionChiPlate,plates[j])
				table.insert(alljionChiPlate,plates[j])

			elseif count == 3 then
				table.insert(kindTabel, {type = op_type, mahjong = plates[j], mahjongs = {plates[j], plates[j], plates[j], plates[j]}})
				table.insert(alljionChiPlate,plates[j])
				table.insert(alljionChiPlate,plates[j])
				table.insert(alljionChiPlate,plates[j])

			end
		end

	elseif op_type == csm_pb.ZTHU then
		alljionChiPlate = suddenColorPlates;
	end

	function haveSameOp(op_type,plate)
		for i = 1, #kindTabel do
			if kindTabel[i].type == op_type and plate == kindTabel[i].mahjongs[1] then
				return true;
			end
		end

		return false;
	end

	function fetchKindTable(pData,op_type)
		local countTable = {}
		for i=1,#pData.mahjongs do
			local p = pData.mahjongs[i]
			for j = 1, #lastOperat.buGang do
				--print("check ------------ lastOperat.buGang[j].mahjong"..lastOperat.buGang[j].mahjong);
				if p == lastOperat.buGang[j].mahjong and lastOperat.buGang[j].op_type == op_type  then

					if countTable[p] == nil then
						countTable[p] = 1
					else
						countTable[p] = countTable[p] + 1;
						if countTable[p] >= 4 then
							if not haveSameOp(op_type,p) then
								table.insert(kindTabel, {type = op_type, mahjong = p, mahjongs = {p, p, p, p}})
								table.insert(alljionChiPlate,p)
								table.insert(alljionChiPlate,p)
								table.insert(alljionChiPlate,p)
								table.insert(alljionChiPlate,p)
							end
						end
					end

					break;
				end
			end


		end

		--吃碰牌里面的
		for j = 1, #lastOperat.buGang do
			for i=1,#pData.operationCards do

				local operation_type = pData.operationCards[i].operation;
				local op_cards = pData.operationCards[i].cards;
				if operation_type == csm_pb.SORT_PENG then
					if lastOperat.buGang[j].mahjong == op_cards[1] and lastOperat.buGang[j].op_type == op_type then

						local tempPlate = lastOperat.buGang[j].mahjong;
						if not haveSameOp(op_type,tempPlate) then
							table.insert(kindTabel, {type = op_type, mahjong = lastOperat.buGang[j].mahjong, mahjongs = { tempPlate, tempPlate, tempPlate, tempPlate }})
							table.insert(alljionChiPlate, tempPlate)
						end
					end
				end

			end
		end

	end
	
	--手上有4个牌的情况
	if op_type == csm_pb.GANG  then
		fetchKindTable(pData,op_type);
	elseif op_type == csm_pb.BU then
		fetchKindTable(pData,op_type);
	end
	
	return kindTabel,alljionChiPlate
end

function this.SetPlateUIColor(gridHand, plates, dark)
	--print('SetPlateUIColor plates:'.. table.concat(plates, ',')..' dark:'..tostring(dark))
	local p = nil
	local item  = nil
	local f = false
	for i=0,gridHand.childCount-1 do
		item = gridHand:GetChild(i)
		p = GetUserData(item.gameObject)
		if item.gameObject.activeSelf or not dark then
			f = false
			for j=#plates,1,-1 do
				if p == plates[j] then
					table.remove(plates, j)
					f = true
					break
				end
			end
			if not f then
				if dark then
					item:GetComponent('UISprite').color = Color.gray
					item:GetChild(0):GetComponent('UISprite').color = Color.gray
				else
					item:GetComponent('UISprite').color = Color.white
					item:GetChild(0):GetComponent('UISprite').color = Color.white
				end
			end
		end
	end
end

local swcor = nil

function this.HideAllWaitOperateEffect()
	for i = 1, #playerData do
		local index = this.GetUIIndex(this.GetUIIndexBySeat(playerData[i].seat),playerSize);
		curActivePlayerIcon[index]:Find('frame').gameObject:SetActive(false);
		curActivePlayerIcon[index]:Find('select').gameObject:SetActive(false);
		curActivePlayerIcon[index]:Find('unselect').gameObject:SetActive(true);
	end
end

--显示出牌的状态，东西南北，哪个该出牌了
function this.ShowWaitOpreatEffect(seat, show)
	coroutine.stop(swcor);
	coroutine.stop(trusteeshipcor);
	local index = this.GetUIIndexBySeat(seat)
	function showState(index,show)
		curActivePlayerIcon[index]:Find('frame').gameObject:SetActive(show);
		curActivePlayerIcon[index]:Find('select').gameObject:SetActive(show);
		curActivePlayerIcon[index]:Find('unselect').gameObject:SetActive(not show);
		playerKuang[index].gameObject:SetActive(show);
	end

	--先隐藏所有
	for i=0,3 do
		showState(i,false);
	end

	for i=0,playerSize-1 do
		if index == i then
			showState(this.GetUIIndex(i,playerSize),show);
			if show then
				swcor = coroutine.start(
						function()
							if roomData.setting.trusteeship == 0 then
								remainTime = 15
							else
								if roomData.trusteeshipRemainMs>0 then
									remainTime = roomData.trusteeshipRemainMs
								else
									remainTime = roomData.setting.trusteeship
								end
							end
							while remainTime >= 0 do
								dipai:Find('timer'):GetComponent('UILabel').text = string.format('%02d', remainTime)
								remainTime = remainTime -1
								coroutine.wait(1)
							end
						end
				);

			end

			if show then
				this.CheckTrusteeshipTime(seat);
			end
		else
			showState(this.GetUIIndex(i,playerSize),not show);
		end
	end
	----print('ShowWaitOpreatEffect seat:'..seat..' show:'..tostring(show))
end

function this.CheckTrusteeshipTime(seat)
	trusteeshipcor = coroutine.start(
			function()

				local trusteeshipTime = -1;
				--print("roomData.trusteeshipRemainMs:"..roomData.trusteeshipRemainMs);
				if roomData.trusteeshipRemainMs >0 then
					trusteeshipTime = roomData.trusteeshipRemainMs;
					roomData.trusteeshipRemainMs = roomData.setting.trusteeship;
				else
					trusteeshipTime = roomData.setting.trusteeship;
				end

				local pData = this.GetPlayerDataBySeat(seat);
				if pData and pData.trusteeship then--如果处于托管中，那么时间置为0
					trusteeshipTime = 0;
					if seat == mySeat then
						this.SetMyseflInTrustesship(seat,true);
					end
				end

				--print("offlineState:"..tostring(offlineState));

				while trusteeshipTime >= 0 and (not offlineState) do

					coroutine.wait(1);
					--print("trusteeshipTime------>"..trusteeshipTime);
					--进入托管
					if trusteeshipTime <= 10 then
						if seat == mySeat then
							DelegateTime.gameObject:SetActive(true);
							DelegateTime:Find("Time"):GetComponent("UILabel").text = trusteeshipTime;
						end

						if trusteeshipTime <= 0 then
							DelegateTime.gameObject:SetActive(false);
						end
					else
						DelegateTime.gameObject:SetActive(false);
					end
					trusteeshipTime = trusteeshipTime -1
				end
			end
	);
end

function this.GetFreeBirds(count)
	local t = {}
	local item 
	for i=0,playerBrid.childCount-1 do
		item = playerBrid:GetChild(i)
		if not item.gameObject.activeSelf and #t < count then
			table.insert(t, item)
		end
	end
	
	for i=#t,count do
		local perfab = ResourceManager.Instance:LoadAssetSync('Bird')
		local e = NGUITools.AddChild(playerBrid.gameObject, perfab)
		e.gameObject:SetActive(false)
		table.insert(t, e.transform)
	end
	
	return t
end

function this.HideAllBirds()
	for i=0,playerBrid.childCount-1 do
		playerBrid:GetChild(i).gameObject:SetActive(false)
	end
end


function this.ShowPanelShare(go)
	print("ShowPanelShare was called");
    panelShare.gameObject:SetActive(true)
end

function this.ClosePanelShare(go)
    panelShare.gameObject:SetActive(false)
end


function this.OnClickButtonXLInvite(go)

	local str = "";
	str = str ..'房间号：' .. roomInfo.roomNumber .. ',';
	if roomData.setting.roomTypeValue == proxy_pb.CSM then
		str = str .."长沙麻将,";
	elseif roomData.setting.roomTypeValue == proxy_pb.ZZM then
		str = str .."转转麻将,";
	elseif roomData.setting.roomTypeValue == proxy_pb.HZM then
		str = str .."红中麻将,";
	end

	str = str ..GetMJRuleText(roomData.setting,false,true);

	str = str .."房已开好,就等你来！";
	--print("分享信息", str);
	local que = roomData.setting.size - (#playerData);
	local title = roomInfo.roomNumber.."房,"..roomData.playName..roomData.setting.size.."缺"..que;
	--print("title",title);
	--print("panelLogin.HttpUrl:"..tostring(panelLogin.HttpUrl));

	PlatformManager.Instance:ShareLinkToXL('http://'..panelLogin.HttpUrl..'/share/xl/jionRoom.html?roomId='..roomInfo.roomNumber..'&gameType='..proxy_pb.MJ..'&appType=1', title, str);

end

function this.OnClickButtonCopy(go)
	local str = "";
	if roomData.setting.roomTypeValue == proxy_pb.CSM then
		str = str.."长沙麻将,";
	elseif roomData.setting.roomTypeValue == proxy_pb.ZZM then
		str = str.."转转麻将,";
	end
	str = str..'房号:' .. roomInfo.roomNumber..",";

	str = str .. GetMJRuleText(roomData.setting,false,true);

	Util.CopyToSystemClipbrd(str);
	panelMessageTip.SetParamers('复制成功', 1.5);
	PanelManager.Instance:ShowWindow('panelMessageTip');
end


function this.OnClickButtonRefresh(GO)
	--print("OnClickButtonRefresh was called");
	AudioManager.Instance:PlayAudio('btn');
	PanelManager.Instance:RestartGame();
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

	elseif playerSize == 3 then
		distances[2].gameObject:SetActive(false);
		distances[3].gameObject:SetActive(false);
		distances[6].gameObject:SetActive(false);

		distances[1].gameObject:SetActive(true);
		distances[4].gameObject:SetActive(true);
		distances[5].gameObject:SetActive(true);

	else
		for i = 1, 6 do
			distances[i].gameObject:SetActive(true);
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
	for key, value in pairs(distanceTable) do
		--print("key="..key..",value:"..value);
		if value == -1 then
			distances[key].gameObject:SetActive(false);
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
		return {1,5,4};
	else
		return {1,2,3,4,5,6};
	end
end


function this.OnClickButtonGPS(GO)
	AudioManager.Instance:PlayAudio('btn');
	local gpsdata = {};
	gpsdata.playerData = playerData;
	gpsdata.distanceTable = this.GetDistance(playerSize);
	gpsdata.playerSize = playerSize;
	--PanelManager.Instance:ShowWindow('panelGPS_mj',gpsdata);
end

--显示规则界面
function this.ShowRule(go)
	AudioManager.Instance:PlayAudio('btn')

	local playString = '';
	if roomData.setting.roomTypeValue == proxy_pb.ZZM then
		playString = "转转麻将";
	elseif roomData.setting.roomTypeValue == proxy_pb.CSM then
		playString = "长沙麻将";
	elseif roomData.setting.roomTypeValue == proxy_pb.HZM then
		playString = "红中麻将";
	end
	--RuleInfoPanel:Find('WanFa/Label'):GetComponent('UILabel').text = playString;
	--RuleInfoPanel:Find('Rule/Label'):GetComponent('UILabel').text= GetMJRuleText(roomData.setting,false);
	--RuleInfoPanel.gameObject:SetActive(true);
end


function this.OnclickButtonMore()
	--morePanel.gameObject:SetActive(not morePanel.gameObject.activeSelf);
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
--[[    @desc: 停止说话
    author:{author}
    time:2018-09-12 16:59:06
    @return:
]]
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
	print('发送给服务器' .. fileid)
	local msg = Message.New()
	msg.type = csm_pb.VOICE_MEMBER
	local body = csm_pb.PVoiceMember()
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
	for i = 0, roomData.setting.size -1 do
		if this.GetPlayerDataByUIIndex(i).voiceId == fileid then
			playerSound[this.GetUIIndex(i,playerSize)].gameObject:SetActive(true);
		else
			playerSound[this.GetUIIndex(i,playerSize)].gameObject:SetActive(false);
		end

	end
end


function this.PlayRecordFilComplete(fileid)
	--继续播放背景音乐
	if isPress == false then
		AudioManager.Instance.AudioOn = UnityEngine.PlayerPrefs.GetInt('audio_on', 1) == 1
		AudioManager.Instance.MusicOn = UnityEngine.PlayerPrefs.GetInt('music_on', 1) == 1
	end
	for i = 0, roomData.setting.size-1 do
		if this.GetPlayerDataByUIIndex(i).voiceId == fileid then
			--print('有相等的' .. fileid)
			playerSound[this.GetUIIndex(i,playerSize)].gameObject:SetActive(false)
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

--展示玩家信息
function this.OnClickPlayerIcon(go)
	if IsAppleReview() then
		return
	end
	local pData = GetUserData(go)
	if not pData then
		return
	end
	--print('名片'..pData.id)
	--print('名片tu'..pData.imgUrl)
	--print('icontu'..pData.icon)
	--print('signature'..pData.signature)
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
	userData.gameType	= proxy_pb.MJ;
	userData.signature 	= pData.signature
	userData.sendMsgAllowed = roomData.setting.sendMsgAllowed
	userData.isShowSomeID=false
    userData.fee = pData.fee
	userData.gameMode = roomData.setting.gameMode
	PanelManager.Instance:ShowWindow('panelPlayerInfo', userData);
end

--设置飘分
function this.SetPiaoFen()

	for i = 0, playerSize-1 do
		local pData = this.GetPlayerDataByUIIndex(i);
		if roomData.setting.fixedFloatScore~=0 then
			playerPiaoFen[this.GetUIIndex(i,playerSize)].gameObject:SetActive(true);
			playerPiaoFen[this.GetUIIndex(i,playerSize)]:GetComponent('UILabel').text = "飘"..roomData.setting.fixedFloatScore.."分"
		elseif roomData.setting.floatScore then
			playerPiaoFen[this.GetUIIndex(i,playerSize)].gameObject:SetActive(true);
			if pData.floatScore == -1 then
				playerPiaoFen[this.GetUIIndex(i,playerSize)]:GetComponent('UILabel').text = "";
			elseif pData.floatScore == 0 then
				playerPiaoFen[this.GetUIIndex(i,playerSize)]:GetComponent('UILabel').text = "不飘分";
			else
				playerPiaoFen[this.GetUIIndex(i,playerSize)]:GetComponent('UILabel').text = "飘"..pData.floatScore.."分"
			end
		else
			playerPiaoFen[this.GetUIIndex(i,playerSize)].gameObject:SetActive(false);
		end

	end
end

function this.OnPiaoFen()
	print("启动飘分111111111111111")
	piaofendlg.gameObject:SetActive(true)
	this.SetInviteVisiable(false)
	this.HideWaittingUI();
	print("HideWaittingUI---->OnPiaoFen")
	GPS.gameObject:SetActive(false)
end

function this.OnShowPiaoFen(msg)
	print("公示飘分111111111111111")
	local b = csm_pb.RPublicityFloatScore()
	b:ParseFromString(msg.body);
	local i = this.GetUIIndexBySeat(b.seat);
	playerPiaoFen[this.GetUIIndex(i,playerSize)].gameObject:SetActive(true)
	if b.score == 0 then
		playerPiaoFen[this.GetUIIndex(i,playerSize)]:GetComponent('UILabel').text = "不飘分"
	else
		playerPiaoFen[this.GetUIIndex(i,playerSize)]:GetComponent('UILabel').text = "飘"..b.score.."分"
	end
	if b.seat == mySeat then
		piaofendlg.gameObject:SetActive(false);
	end
end

function this.OnClickPiaoFen(go)
	print("设置飘分。。。。。。。。")
	local msg = Message.New()
	msg.type = csm_pb.SET_FLOAT_SCORE
	local body = csm_pb.PFloatScore()
	if go.name == "0" then
		body.score = 0
	elseif go.name == "1" then
		body.score = 1
	elseif go.name == "2" then
		body.score = 2
	elseif go.name == "3" then
		body.score = 3
	end
	msg.body = body:SerializeToString();
	SendGameMessage(msg, this.OnPiaoFenCallBack);
	piaofendlg.gameObject:SetActive(false);
end

function this.OnPiaoFenCallBack(msg)
	print("设置飘分回调。。。。。。。。")
end

function this.CheckStartPiaoFen()

	piaofendlg.gameObject:SetActive(false);
	local  isallready = true
	--print("#playerData",#playerData)
	for i=1,#playerData do
		--print("是否准备",playerData[i].ready)
		if playerData[i].ready == false then
			isallready = false
			break;
		end
	end
	local myPlayerData = this.GetPlayerDataBySeat(mySeat);
	if roomData.setting.floatScore and myPlayerData.floatScore == -1 and roomData.state == 1 and isallready and #roomData.players >= roomData.setting.size  then
		--print("启动飘分111111111111111")
		piaofendlg.gameObject:SetActive(true);
		this.HideWaittingUI();
	end
	--print("roomData.setting.floatScore",roomData.setting.floatScore);
	--print("playerData[mySeat].floatScore == -1",myPlayerData.floatScore == -1);
	--print("roomData.state == 1",roomData.state == 1);
	--print("isallready",isallready);
	--print("#playerData >= roomData.setting.size",#roomData.players >= roomData.setting.size);
end


--听牌按钮
function this.OnClickButtonTing(obj)
	print("OnClickButtonTing");
	local tingMahjongs = GetUserData(playerTingButton.gameObject);
	local bgFrame = playerTingButton:Find("frame");
	local oldTingIsActive=bgFrame.gameObject.activeSelf
	if oldTingIsActive then
		bgFrame.gameObject:SetActive(false);
		this.SetNewTingScrollView(tingMahjongs);
		newTingOperation.gameObject:SetActive(true);
	else
		newTingOperation.gameObject:SetActive(false);
		this.SetTingScrollView(tingMahjongs);
		bgFrame.gameObject:SetActive(true);
	end
end

--填充听牌提示的内容
function this.SetTingScrollView(tingMahjongs)
	if not tingMahjongs then return end;
	local bgFrame = playerTingButton:Find("frame");
	--print("tingMahjongs.length:",#tingMahjongs);
	local tingScrollView = playerTingButton:Find("frame/TingScrollView");
	tingScrollView.gameObject:SetActive(true);
	local tingGrid = playerTingButton:Find("frame/TingScrollView/Grid");
	--先隐藏
	for i = 0, tingGrid.childCount-1 do
		tingGrid:GetChild(i).gameObject:SetActive(false);
	end

	--print("tingGrid.childCount:"..tingGrid.childCount);
	--计算宽度

	local realWidth = #tingMahjongs * tingGrid:GetComponent("UIGrid").cellWidth;
	local maxWidth = CONST.TingFrameWidth.x;
	--print("realWidth",realWidth);
	--print("maxWidth",maxWidth);
	if maxWidth < realWidth then

		tingScrollView:GetComponent("UIPanel").baseClipRegion = Vector4.New(0,0,maxWidth,CONST.TingFrameWidth.y);
		bgFrame:GetComponent("UISprite").width = CONST.TingFrameWidth.x + 80;
	else
		tingScrollView:GetComponent("UIPanel").baseClipRegion = Vector4.New(0,0,realWidth+10,CONST.TingFrameWidth.y);
		bgFrame:GetComponent("UISprite").width = realWidth + 100;
	end
	for firdex = 1, #tingMahjongs do
		if firdex > tingGrid.childCount then
			local cardItem = NGUITools.AddChild(tingGrid.gameObject,TingItemPrefab.gameObject);
			--print("add child obj!");
			cardItem:SetActive(true);
		end

		local obj = tingGrid:GetChild(firdex -1);
		obj.gameObject:SetActive(true);
		--print("obj:"..tostring(obj));
		SetUserData(obj.gameObject,tingMahjongs[firdex]);
		obj:GetComponent("UISprite").spriteName = this.getColorCardName(CONST.cardPrefabHandStandBg[1],cardColor);
		obj:Find("card"):GetComponent("UISprite").spriteName = this.GetCardTextName(tingMahjongs[firdex].mahjong,cardText);
		--UIEventListener.Get(obj.gameObject).onClick = this.OnClickButtonTingItem;

		--统计张数
		obj:Find("num"):GetComponent("UILabel").text =  this.GetTingPaiCount(tingMahjongs[firdex].mahjong);
		obj:Find("fan"):GetComponent("UILabel").text  = tingMahjongs[firdex].fan .. "番";

	end

	tingScrollView:GetComponent('UIPanel').clipOffset=Vector2(0,0)
	tingScrollView.localPosition=Vector3(17,0,0)
	tingGrid:GetComponent("UIGrid"):Reposition();
	tingScrollView:GetComponent("UIScrollView"):ResetPosition();

end

--获取听牌数量
function this.GetTingPaiCount(plate)
	--自己手上的牌
	local myData = this.GetPlayerDataBySeat(mySeat);
	local countInHand = GetMJPlateCount(myData.mahjongs,plate);

	--手上摸的牌
	local countMo = 0;
	if roomData.activeSeat == mySeat then
		countMo = GetMJPlateCount({this.GetPlayerDataBySeat(mySeat).moMahjong},plate);
	end
	local countOther = 0;
	--print("playerData.length:"..(#playerData));
	--print("playerSize:"..playerSize);
	for secdex = 0, playerSize - 1 do
		local pData = this.GetPlayerDataByUIIndex(secdex);
		if pData then
			--别人已经打出的牌
			--print("paiHe.length:"..(#pData.paiHe));
			countOther = countOther + GetMJPlateCount(pData.paiHe,plate);
			--手上的吃碰杠牌
			local countCPG = 0;

			for i = 1, #pData.operationCards do
				local operation_type = pData.operationCards[i].operation;
				local op_cards = pData.operationCards[i].cards;
				if operation_type == csm_pb.SORT_CHI then
					countCPG = countCPG + GetMJPlateCount({op_cards[1] , op_cards[2], op_cards[3]},plate);
				elseif operation_type == csm_pb.SORT_PENG then
					countCPG = countCPG + GetMJPlateCount({op_cards[1]},plate)*3;
				elseif operation_type == csm_pb.SORT_MING then
					countCPG = countCPG + GetMJPlateCount({op_cards[1]},plate)*4;
				elseif operation_type == csm_pb.SORT_DARK then
					countCPG = countCPG + GetMJPlateCount({op_cards[1]},plate)*4;
				elseif operation_type == csm_pb.SORT_DIAN then
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
	if roomData.setting.roomTypeValue == proxy_pb.HZM and plate == HongzhongPlateValue then
		countTotal = roomData.setting.hongZhongCount- countInHand -countOther-countMo;
	else
		countTotal = (4- countInHand -countOther-countMo);
	end

	return countTotal;

end

--听牌元素点击事件
function this.OnClickButtonTingItem(obj)
	print("OnClickButtonTingItem was called:"..tostring(obj));
	local plate = GetUserData(obj);
	--print("plate:"..plate);
end


--提牌标记
function this.SetTiPlateMark(gridHand,mahjongs,tingTips)
	print("SetTiPlateMark was called");
	--1.先隐藏所有提牌标识
	for i = 0, gridHand.childCount-1 do
		local tingTip = gridHand:GetChild(i):Find("tingTip");
		tingTip.gameObject:SetActive(false);
		--清空数据
		SetUserData(tingTip.gameObject,nil);
	end
	--2.显示新的标识
	local posKeyDatas = GetMJTingPosKey(mahjongs,tingTips);
	--print("posKeyDatas.length:"..(#posKeyDatas));
	for i = 1, #posKeyDatas do
		local cardItem = gridHand:GetChild(posKeyDatas[i].posKey-1);
		--print("set ting data pos:"..posKeyDatas[i].posKey);
		local tingTip = cardItem:Find("tingTip");
		tingTip.gameObject:SetActive(true);
		SetUserData(tingTip.gameObject, posKeyDatas[i].tingMahjongs);
		--print("ti data length:"..(#posKeyDatas[i].tingMahjongs));

	end

end


--隐藏提牌标识
function this.HideTiMark(handGrid)
	for i = 0, handGrid.childCount -1 do
		local cardItem = handGrid:GetChild(i);
		local tingTip = cardItem:Find("tingTip");
		cardItem:Find("tingTip").gameObject:SetActive(false);
		SetUserData(tingTip.gameObject,nil);
	end
end

--清空数据
function this.ClearData()


	--1.清空飘分
	--playerPiaoFen[this.GetUIIndex(i,playerSize)]:GetComponent('UILabel').text = "";
	for i = 0, playerSize-1 do
		playerPiaoFen[this.GetUIIndex(i,playerSize)]:GetComponent('UILabel').text = "";
	end

	--2.清空提牌提示
	for i = 1, playerGridHand[0].childCount do
		SetUserData(playerGridHand[0]:GetChild(i-1):Find("tingTip").gameObject,nil);
		SetUserData(playerTingButton.gameObject, nil);
	end
	dipai:Find('timer'):GetComponent('UILabel').text = 0;
	coroutine.stop(swcor);
	--清除吃碰杠补操作的数据
	lastOperat.buGang 	= {};
	ROperationData 		= {};
	lastOperat.plate 	= {};
	lastOperat.seat 	= -1


	--清除中途起手胡的数据
	haveSuddenBonus = false;--是否有中途起手胡
	suddenBonusData = {};--中途起手胡的数据
	suddenColorPlates = {};--中途起手胡颜色牌

end

--点击麻将产生一个小唯一
local posOffset = 30;
function this.OnClickMahjong(obj)
	--print("OnClickMahjong  was called");
	local needTiTip = false;
	local plate = GetUserData(obj);
	if lastSelectmahjong == nil then--第一次点击或者上一次点击的牌打出去了
		local pos = obj.transform.localPosition;
		if pos.y > 10 then
			pos.y = pos.y-posOffset;
		else
			pos.y = pos.y+posOffset;
		end

		obj.transform.localPosition = pos;
		needTiTip = true;

	else
		local pos = lastSelectmahjong.transform.localPosition;
		if obj == lastSelectmahjong then--若上次跟当前点的是同一个对象
			if pos.y > 10 then
				lastSelectmahjong.transform.localPosition = Vector3.New(pos.x,pos.y-posOffset,0);
				needTiTip = false;
			else
				lastSelectmahjong.transform.localPosition = Vector3.New(pos.x,pos.y+posOffset,0);
				needTiTip = true;
			end
		else
			if pos.y> 10 then
				lastSelectmahjong.transform.localPosition = Vector3.New(pos.x,pos.y-posOffset,0);
			end
			local currentPos = obj.transform.localPosition;
			obj.transform.localPosition = Vector3.New(currentPos.x,currentPos.y+posOffset,0);
			needTiTip = true;
		end


	end

	if lastSelectmahjong then
		local lastPlate = GetUserData(lastSelectmahjong);
		this.CheckPlateState(lastPlate,false);
	end

	this.CheckPlateState(plate,needTiTip);

	if needTiTip then
		--显示提牌
		local tingTip = obj.transform:Find("tingTip");
		if tingTip then
			--print("process ti plate------->")

			--拿到听牌集
			local tingMahjongs = GetUserData(tingTip.gameObject);
			if tingMahjongs then
				--print("get user's tingMahjongs--->");
				playerTingButton.gameObject:SetActive(true);
				local bgFrame = playerTingButton:Find("frame");
				bgFrame.gameObject:SetActive(true);
				this.SetTingScrollView(tingMahjongs);
				this.SetNewTingScrollView(tingMahjongs);
				this.needDisappearDragEnd = true;
				newTingOperation.gameObject:SetActive(false);
			else
				playerTingButton.gameObject:SetActive(this.needKeep);
				local bgFrame = playerTingButton:Find("frame");
				bgFrame.gameObject:SetActive(false);
				this.needDisappearDragEnd = false;
			end
		end
	else
		playerTingButton.gameObject:SetActive(this.needKeep);
		local bgFrame = playerTingButton:Find("frame");

		bgFrame.gameObject:SetActive(false);
		this.needDisappearDragEnd = false;

	end
	--print("this.needKeep:"..tostring(this.needKeep));


	lastSelectmahjong = obj;
end

function this.SetGameTypePos()

	if roomSetting.gameObject.activeSelf then
		gameTypeobj.localPosition = Vector3.New(-4,171,0);
	else
		gameTypeobj.localPosition = Vector3.New(-4,102,0);
	end
end

function this.HideAllKuang()
	for i = 0, playerSize-1 do
		playerKuang[this.GetUIIndex(i,playerSize)].gameObject:SetActive(false);
	end



	this.SetWaitOpTip(false,"");
end

--检查该牌的状态，打出去多少，手上又多少，杠牌又有哪些
function this.CheckPlateState(plate, showColor)
	for firdex = 0, playerSize-1 do
		if playerThrow[this.GetUIIndex(firdex,playerSize)].childCount > 0 then
			for secdex = 0, playerThrow[this.GetUIIndex(firdex, playerSize)].childCount - 1 do
				local throwItem = playerThrow[this.GetUIIndex(firdex,playerSize)]:GetChild(secdex);
				if throwItem.gameObject.activeSelf then
					local itemPlate = GetUserData(throwItem.gameObject);
					if itemPlate == plate then
						this.SetPlateColor(throwItem,showColor);
					end
				end
			end
		else
			break;
		end
	end
end

function this.SetPlateColor(throwItemobj,showColor)
	if showColor then
		throwItemobj:GetComponent("UISprite").color = Color(255/255,222/255,84/255);
	else
		throwItemobj:GetComponent("UISprite").color = Color(255/255,255/255,255/255);
	end
end

function this.NotifyGameStart()
    --通知玩家返回游戏
    if #playerData == roomData.setting.size and roomData.round == 1 and roomData.state ~= phz_pb.GAMING then
        if this.OnRoundStarted ~= nil then
			this.OnRoundStarted()
		end
	end
end

local waitCoroutine;

--设置等待其他玩家操作的提示
function this.SetWaitOpTip(show,tipString)


	function SetTip(argShow,argTipString)
		waitopTip:Find("danTip"):GetComponent("UILabel").text = argTipString;
		waitopTip.gameObject:SetActive(argShow and not ButtonHu.gameObject.activeInHierarchy);
	end

	if waitCoroutine then
		coroutine.stop(waitCoroutine);
	end

	if show then
		waitCoroutine = coroutine.start(
				function()
					coroutine.wait(1)--这里之所以等待，是为了截图等待其他玩家操作的提示一闪而过的问题
					SetTip(show,tipString);
				end
		);
	else
		SetTip(show,tipString);
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

function this.IsAllPiaofen()
	if roomData.setting.size == #playerData  then
		for i=1,#playerData do
			if playerData[i].floatScore == -1 then
				return false
			end
		end
	else
		return false
	end

	return true
end

--设置中途起手胡
function this.SetSuddenBonus(argHaveSudden,argSuddenBonusItem,operatePlate)
	haveSuddenBonus = argHaveSudden;
	if haveSuddenBonus then
		suddenBonusData,suddenColorPlates = this.GetSuddenBonusData( argSuddenBonusItem,operatePlate);
	else
		suddenBonusData = {};
		suddenColorPlates = {};
	end

end

--获得中途起手胡变量
function this.GetSuddenBonus()
	return haveSuddenBonus;
end

--获得中途起手胡数据结构
function this.GetSuddenBonusData(suddenBonusItem,operatePlate)
	local suddenBonusData = {};
	local suddenColor = {};
	local Category_Prefab = GetCategoryPrefabStr();
	if Category_Prefab[suddenBonusItem.huCategory+1]  == "ztsx" then --中途四喜
		for i = 1, #operatePlate do
			local itemData = {};
			local plates = {};

			for j = 1, 4 do
				table.insert(plates,operatePlate[i]);
			end

			itemData.op_plate = operatePlate[i];
			itemData.op_mahjong = operatePlate[i];
			itemData.plates = plates;
			table.insert(suddenBonusData,itemData);
			--选出高亮的牌
			for j = 1, 3 do
				table.insert(suddenColor,operatePlate[i]);
			end

		end


	elseif Category_Prefab[suddenBonusItem.huCategory+1] == "ztlls" then --中途六六顺

		for i = 1, #suddenBonusItem.opMahjongs do
			local itemData = {};
			local plates = {};
			for k = 1, #operatePlate do
				for j = 1, 3 do
					table.insert(plates,operatePlate[k]);
				end

				for j = 1, 3 do
					table.insert(plates,suddenBonusItem.opMahjongs[i])
				end
				itemData.op_plate = operatePlate[k];
				itemData.op_mahjong = suddenBonusItem.opMahjongs[i];
				itemData.plates = plates;
			end
			table.insert(suddenBonusData,itemData);
		end

		--选出高亮的牌
		for i = 1, #operatePlate do
			for j = 1, 3 do
				table.insert(suddenColor,operatePlate[i]);
			end
		end

		for i = 1, #suddenBonusItem.opMahjongs do
			for j = 1, 3 do
				table.insert(suddenColor,suddenBonusItem.opMahjongs[i]);
			end
		end
	end
	return suddenBonusData,suddenColor;
end

--获取人数
function this.GetPlayerSize()
	return playerSize;
end

function this.OnAutoDissolve(msg)
    local body = csm_pb.RAutoDissolve()
    body:ParseFromString(msg.body)

    IsAutoDissolve = true
	AutoDissolveData = body
	PanelManager.Instance:ShowWindow('panelAutoDissolve', AutoDissolveData)
    print('----------------------------------自动解散了----------------------------------------')
end

function this.OnTrustesship(msg)
	local body = csm_pb.RTrusteeship();
	body:ParseFromString(msg.body);

	--print('-----------------------------------------有人托管了-------------------------------------------')
	--print('托管的位置：'..tostring(body.seat));
	--print('托管是否开启：'..tostring(body.enable));

	if body.seat == mySeat then
		coroutine.stop(trusteeshipcor);
		trusteeshipcor = nil
	end

	this.SetMyseflInTrustesship(body.seat, body.enable);
	this.GetPlayerDataBySeat(body.seat).trusteeship = body.enable;
	this.ShowWaitOpreatEffect(roomData.activeSeat,true);
	playerTrusteeship[this.GetUIIndex(this.GetUIIndexBySeat(body.seat), playerSize)].gameObject:SetActive(body.enable)
end

function this.SetMyseflInTrustesship(seat, enable)
	if seat == mySeat then
		operation_mask.gameObject:SetActive(enable);
		DelegatePanel.gameObject:SetActive(enable)
		DelegateTime.gameObject:SetActive(false);
	end
end

--取消托管
function this.OnClickCancelTrustesship(go)
	local msg = Message.New()
	msg.type = csm_pb.TRUSTEESHIP
	local body = csm_pb.PTrusteeship()
	body.enable = false
	msg.body = body:SerializeToString();
	DelegateTime.gameObject:SetActive(false);
	DelegatePanel.gameObject:SetActive(false);
	SendGameMessage(msg)
end

function this.OnClickLessPlayerStartToggle(go)
	AudioManager.Instance:PlayAudio('btn')
	local msg = Message.New()
	msg.type = csm_pb.CHOICE_MINORITY
	local body = csm_pb.PChoiceMinority()
	body.enable = lessPlayerStartToggle:GetComponent('UIToggle').value
	msg.body = body:SerializeToString();
	SendGameMessage(msg)
end

function this.onGetRChoiceMinority(msg)
	local body = csm_pb.RChoiceMinority();
	body:ParseFromString(msg.body)
	print('onGetRChoiceMinority!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
	this.setLessPlayerStart(this.GetUIIndex(this.GetUIIndexBySeat(body.seat),playerSize), body.minorityValue)
end

function this.OnUpdateMinority(msg)
	local body = csm_pb.RUpdateMinority();
	body:ParseFromString(msg.body)
	print('OnUpdateMinority!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
	this.initLessPlayerStart()
	for i=1,#body.minorities do
		this.setLessPlayerStart(this.GetUIIndex(this.GetUIIndexBySeat(body.minorities[i].seat),playerSize), body.minorities[i].minorityValue)
	end
end

function this.initLessPlayerStart()
	lessPlayerStartView.gameObject:SetActive(false)
	this.hideAllPlayerGameMsg()
end

function this.setLessPlayerStart(index, minorityValue)
	print('少人index '..index..' minorityValue '..tostring(minorityValue))
	lessPlayerStartView.gameObject:SetActive(minorityValue~=0)--不可用(比如房间为2人玩法时)
	if minorityValue==1 then--可以选择两人开局
		if index==0 then
			lessPlayerStartToggle:GetComponent('UIToggle'):Set(false)
			lessPlayerStartToggle:Find('Label'):GetComponent('UILabel').text='2人开局'
		end
		playerGameMsg[index].gameObject:SetActive(false)
	elseif minorityValue==2 then--已选择两人开局
		if index==0 then
			lessPlayerStartToggle:GetComponent('UIToggle'):Set(true)
			lessPlayerStartToggle:Find('Label'):GetComponent('UILabel').text='2人开局'
		end
		this.showPlayerGameMsg(index,'申请两人开局')
	elseif minorityValue==3 then--可以选择三人开局
		if index==0 then
			lessPlayerStartToggle:GetComponent('UIToggle'):Set(false)
			lessPlayerStartToggle:Find('Label'):GetComponent('UILabel').text='3人开局'
		end
		playerGameMsg[index].gameObject:SetActive(false)
	elseif minorityValue==4 then--已选择三人开局
		if index==0 then
			lessPlayerStartToggle:GetComponent('UIToggle'):Set(true)
			lessPlayerStartToggle:Find('Label'):GetComponent('UILabel').text='3人开局'
		end
		this.showPlayerGameMsg(index,'申请三人开局')
	end
end

function this.showPlayerGameMsg(index, text)
	playerGameMsg[index].gameObject:SetActive(true)
	playerGameMsg[index]:GetComponent('UILabel').text = text
	--playerGameMsg[index]:GetComponent('UILabel').color = Color(244/255,244/255,244/255)
	local width = playerGameMsg[index]:GetComponent('UILabel').width
	playerGameMsg[index]:Find('MsgBG'):GetComponent('UISprite').width = width + 40
end

function this.hideAllPlayerGameMsg()
	for i=0,3 do
		playerGameMsg[i].gameObject:SetActive(false)
	end
end

function this.hideAllPlayerMsg()
	for i=0,3 do
		playerMsg[i].gameObject:SetActive(false)
	end
end

function this.OnGameError(msg)
    local error = csm_pb.RError()
    error:ParseFromString(msg.body)

    panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, error.info)
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.StartOfflineIncrease(seat, startTime)
	this.StopOfflineIncrease(seat)
	print('------------------有人离线，开始离线计时'..(seat)..'----------------------')

	local index = this.GetUIIndex(this.GetUIIndexBySeat(seat), playerSize)
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
	local index = this.GetUIIndex(this.GetUIIndexBySeat(seat), playerSize)
	local coroutines = playerOfflineCoroutines[index]

	if coroutines ~= nil then
		coroutine.stop(coroutines)
		coroutines = nil;
		print('------------------取消离线倒计时'..(seat)..'----------------------')
	end

	playerOfflineTime[index].gameObject:SetActive(false)
end

function this.StopAllOfflineIncrease()
	for i = 0, #playerOfflineCoroutines do
		local coroutines =  playerOfflineCoroutines[i]
		if coroutines ~= nil then
			coroutine.stop(coroutines)
			coroutines = nil;
		end
	end
end


function this.OnPlayerEmoji(msg)
	local b = csm_pb.RGift()
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