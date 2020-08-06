local yjqf_pb = require 'yjqf_pb'
panelInGame_yjqf = {}
local this = panelInGame_yjqf

local gameObject
local message

local roomPeople = 3
local roomID
local roomRound
local desktopScore
local roomTime
local batteryLevel
local network
local pingLabel
local refreshStateCoroutine
local desktopDiPaiSign
local desktopBG
local GPS = {
	transform=nil,
	distance={},
	playerGPS={},
}
local playerName
local playerRule
local readyBtn
local ButtonInvite
local ButtonCloseRoom
local ButtonExitRoom
local panelShare
local buttonHelp
local buttonPlay
local inCardGridWigth
local groupInCardGrid
local inCardItem
local curPai
local cardDepth = 20
local player={}
local desktopDiPaiCard
local RecordTiShi--录音提示
local TrusteeshipPanel
local TrusteeshipTip
local clubRoomDestoryTime


local connect
function this.GetNetState()
	return connect.IsConnect
end
local connectCor

local mySeat
local playerData={}

this.needXiPai = false
this.OnRoundStarted = nil
this.isGameing =false
this.hasStageClear=false
this.fanHuiRoomNumber = nil
local offlineState = false
local trusteeshipcor = nil
local playerOfflineCoroutines={}
this.myseflDissolveTimes = 0
local isMySelfTrusteeship = false
local clubRoomDestoryTimeCoroutine 
local GvoiceCor
local IsAutoDissolve = false
local AutoDissolveData
local playerCoroutine = {}
local clockTimeCor
this.cutCardInfo = {}
local playerEmojiCoroutine = {}
playerEmojiCoroutine[0] = {}
playerEmojiCoroutine[1] = {}
playerEmojiCoroutine[2] = {}
local outCard={}
local helpOutCardsIndex = 1
local lastPlayerOutHand = {}
function this.Awake(obj)
	gameObject = obj
	this.gameObject = obj
	message = gameObject:GetComponent('LuaBehaviour')

	roomID = gameObject.transform:Find('topObj/room/ID')
	roomRound = gameObject.transform:Find('topObj/round/num')
	desktopScore = gameObject.transform:Find('topObj/deskScore/scoreLabel')

	roomTime = gameObject.transform:Find('rightObj/time')
	batteryLevel = gameObject.transform:Find('rightObj/battery/level'):GetComponent('UISprite')
	network = gameObject.transform:Find('rightObj/network'):GetComponent('UISprite')
	pingLabel = gameObject.transform:Find('rightObj/ping'):GetComponent('UILabel')
	
	message:AddClick(gameObject.transform:Find('rightObj/ButtonRefresh').gameObject, function (go)
		AudioManager.Instance:PlayAudio('btn')
		PanelManager.Instance:RestartGame()
	end)
	message:AddClick(gameObject.transform:Find('rightObj/ButtonSetting').gameObject, function (go)
		AudioManager.Instance:PlayAudio('btn')
		PanelManager.Instance:ShowWindow('panelGameSetting_yjqf')
	end)

	desktopDiPaiSign = gameObject.transform:Find('rightObj/dipai')

	GPS.transform = gameObject.transform:Find('GPS')
	local dis = GPS.transform:Find('distances')
	for i = 0, dis.childCount-1 do
		local len = {}
		len.transform = dis.transform:Find('distance'..i)
		len.length = dis.transform:Find('distance'..i..'/Label')
		GPS.distance[i] = len
	end
	local players = GPS.transform:Find('players')
	for i = 0, players.childCount-1 do
		local pla = {}
		pla.transform = players:Find(i)
		pla.dingwei = pla.transform:Find('dingwei')
		pla.name = pla.transform:Find('name')
		GPS.playerGPS[i] = pla
	end
	desktopBG = gameObject.transform:Find('deskBg')
	playerName = gameObject.transform:Find('playName'):GetComponent('UILabel')
	playerRule = gameObject.transform:Find('playName/rule'):GetComponent('UILabel')

	message:AddPress(gameObject.transform:Find('btn/ButtonSound').gameObject, this.OnPressButtonSound)
	message:AddClick(gameObject.transform:Find('btn/ButtonChat').gameObject, this.OnClickButtonChat)

	readyBtn = gameObject.transform:Find('readyBtn')
	message:AddClick(readyBtn.gameObject, this.OnClickReady)
	ButtonInvite = gameObject.transform:Find('bottomButtons/ButtonInvite')
	message:AddClick(ButtonInvite.gameObject, this.ShowPanelShare)
	ButtonCloseRoom = gameObject.transform:Find('bottomButtons/ButtonCloseRoom')
	message:AddClick(ButtonCloseRoom.gameObject, this.OnClicButtonCloseRoom)
	ButtonExitRoom = gameObject.transform:Find('bottomButtons/ButtonExitRoom')
	message:AddClick(ButtonExitRoom.gameObject, this.OnClicButtonLeaveRoom)

	panelShare = gameObject.transform:Find('panelShare')
    message:AddClick(panelShare:Find('friendGroup').gameObject, this.OnClickButtonInvite)
    message:AddClick(panelShare:Find('copy').gameObject, this.OnClicButtonCopy)
    message:AddClick(panelShare:Find('ButtonClose').gameObject, this.ClosePanelShare)
	message:AddClick(panelShare:Find('mask').gameObject, this.ClosePanelShare)

	buttonHelp = gameObject.transform:Find('playerOperateBtn/buttonHelp')
	message:AddClick(buttonHelp.gameObject, this.OnClickButtonHelp)
	buttonPlay = gameObject.transform:Find('playerOperateBtn/buttonPlay')
	message:AddClick(buttonPlay.gameObject, this.OnClickButtonPlay)

	inCardGridWigth = gameObject.transform:Find('inCardGridWigth')
	groupInCardGrid = inCardGridWigth:Find('groupInCardGrid')
	
	inCardItem = gameObject.transform:Find('inCardItem')
	
	for i=0,roomPeople-1 do
		local playerUI = {}
		playerUI.obj = gameObject.transform:Find('player/'..i)
		playerUI.playerWidget = playerUI.obj:GetComponent('UIWidget')
		playerUI.playerInfo = playerUI.obj:Find('info')
		playerUI.playerIcon = playerUI.playerInfo:Find('Texture')
		message:AddClick(playerUI.playerIcon.gameObject, this.OnClickPlayerIcon)
		playerUI.playerScore = playerUI.playerInfo:Find('score')
		playerUI.playerName = playerUI.playerInfo:Find('name')
		playerUI.playerReady = playerUI.playerInfo:Find('ready')
		playerUI.playerMsgLabel = playerUI.playerInfo:Find('Msg/MsgLabel')
		playerUI.playerEmoji = playerUI.playerInfo:Find('Emoji')
		playerUI.playerSound = playerUI.playerInfo:Find('sound')
		playerUI.playerOperateSign = playerUI.playerInfo:Find('kuang01')
		playerUI.playerOutCardEndSign = playerUI.playerInfo:Find('OutCardFinish')
		playerUI.playerRoomer = playerUI.playerInfo:Find('roomer')	
		playerUI.playerTrusteeship = playerUI.playerInfo:Find('trusteeship')	
		playerUI.playerOfflineTime = playerUI.playerInfo:Find('offlineTime')
		playerUI.playerAnimation = playerUI.playerInfo:Find('teshubiaoqing')
		if i == 0 then
			playerUI.clockTime = gameObject.transform:Find('playerOperateBtn/clock')
		else
			playerUI.clockTime = playerUI.playerInfo:Find('clock')
		end
		playerUI.playerPass = playerUI.obj:Find('texiaozi/pass')
		playerUI.playerCardCategory = playerUI.obj:Find('texiaozi/Category')
		playerUI.playerBoomSign = playerUI.obj:Find('texiaozi/boomSign')
		playerUI.playerOutCardGrid = playerUI.obj:Find('outCardGrid')
		playerUI.playerOutCardTable = playerUI.obj:Find('outCardTable')
		playerUI.playerAllScoreObj = gameObject.transform:Find('scoreView/play'..i)
		playerUI.playerAllScoreName = playerUI.playerAllScoreObj:Find('name')
		playerUI.playerHistory= playerUI.playerAllScoreObj:Find('history')
		playerUI.playerNowScore = playerUI.playerAllScoreObj:Find('now')
		playerUI.playerHappyScore = playerUI.playerAllScoreObj:Find('happyScore')
		player[i] = playerUI
	end
	desktopDiPaiCard = gameObject.transform:Find('diPaiCard')
	RecordTiShi = gameObject.transform:Find('RecordTiShi')
	TrusteeshipTip = gameObject.transform:Find('TrusteeshipTip')
	TrusteeshipPanel = gameObject.transform:Find('TrusteeshipPanel')
	message:AddClick(TrusteeshipPanel.transform:Find('CancelTrusteeshipBtn').gameObject, this.OnClickCancelTrustesship)
	clubRoomDestoryTime = gameObject.transform:Find('RestTime')
	this.CloneCard()
end
function this.Start()
end
function this.OnEnable()
	AudioManager.Instance:PlayMusic('yjqfBGM', true)
	this.ChangeDesktopBg()
	panelInGame = panelInGame_yjqf
	this.needXiPai=false
	isIngame = true
	if panelClub then
		panelClub.isInClub=false
	end
	if refreshStateCoroutine then
		coroutine.stop(refreshStateCoroutine)
	end
	refreshStateCoroutine = coroutine.start(this.RefreshState)
	coroutine.start(RefreshTime, roomTime:GetComponent('UILabel'),60)
	this.RegisterGameCallBack()
	connect = NetWorkManager.Instance:FindConnet('game')
	if connect then
		this.StopCheckNetState()
		NetWorkManager.Instance:DeleteConnect('game')
	end
	coroutine.start(
		function()
			coroutine.wait(0.1)
			connect = NetWorkManager.Instance:CreateConnect('game')
			connect.IP = GetServerIPorTag(false, roomInfo.host)
			connect.Port = roomInfo.port
			print('connect.IP : '..connect.IP..' connect.Port :'..connect.Port)
			connect.GroupName = ConfigManager.getProperty('ProxyServer', 'GroupName', '')
			connect.onConnectLua = this.OnConnect
			connect.disConnectLua = this.OnDisconnect
			connect.rspCallBackLua = receiveGameMessage
			connect.reConnectNum = ConfigManager.getIntProperty('Setting', 'ReconnectNum', 5)
			connect:Connect()
			connect.heartBeatInterval = 5
		end
	)
	this.StartCheckNetState()
	GPS.transform.gameObject:SetActive(false)
	if panelChat then
        panelChat.ClearChat()
	end
end
function this.Update()
end
function this.OnApplicationFocus(isfoucs)	
end
function this.WhoShow(data)
	this.OnRoundStarted = nil
	for i = 0, roomPeople-1 do
		if i ~=0 then
			player[i].obj.gameObject:SetActive(false)
		end
	end
	PanelManager.Instance:HideAllWindow()
	gameObject:SetActive(true)
end
--注册消息
function this.RegisterGameCallBack()
	ClearGameCallBack()
	RegisterGameCallBack(yjqf_pb.PONG, this.OnPong)
	RegisterGameCallBack(yjqf_pb.PLAYER_ENTER, this.OnPlayerEnter)
	RegisterGameCallBack(yjqf_pb.PLAYER_JOIN, this.OnPlayerJion)
	RegisterGameCallBack(yjqf_pb.LEAVE_ROOM, this.OnLeaveRoom)
	RegisterGameCallBack(yjqf_pb.PLAYER_LEAVE, this.OnPlayerLeave)
	RegisterGameCallBack(yjqf_pb.ENTER_ERROR, this.OnRoomError)
	RegisterGameCallBack(yjqf_pb.NO_ROOM, this.OnNoRoom)
	RegisterGameCallBack(yjqf_pb.CUT_WIAT, this.OnCutWait)
	RegisterGameCallBack(yjqf_pb.ROUND_START, this.OnRoundStart)
	RegisterGameCallBack(yjqf_pb.ROUND_END, this.OnRoundEnd)
	RegisterGameCallBack(yjqf_pb.GAME_OVER, this.OnGameOver)
	RegisterGameCallBack(yjqf_pb.DESTROY, this.OnDestory)
	RegisterGameCallBack(yjqf_pb.DISSOLVE, this.OnDissolve)
	RegisterGameCallBack(yjqf_pb.OVERTIME_DISSOLVE,this.OnOverTimeDissolve)
	RegisterGameCallBack(yjqf_pb.LORD_DISSOLVE, this.OnLordDissolve)

	RegisterGameCallBack(yjqf_pb.READY, this.OnReady)
	RegisterGameCallBack(yjqf_pb.PLAY_WAIT, this.OnWaitPlay)
	RegisterGameCallBack(yjqf_pb.PLAY, this.OnPlay)
	RegisterGameCallBack(yjqf_pb.PLAY_ERROR, this.OnPlayError)
	
	RegisterGameCallBack(yjqf_pb.PASS, this.OnPass)
	RegisterGameCallBack(yjqf_pb.GIFT, this.OnPlayerEmoji)
	RegisterGameCallBack(yjqf_pb.SEND_CHAT, this.OnSendChat)
	RegisterGameCallBack(yjqf_pb.VOICE_MEMBER, this.OnVoiceMember)
	RegisterGameCallBack(yjqf_pb.DISCONNECTED, this.OnDisconnected)
	RegisterGameCallBack(yjqf_pb.AUTO_DISSOLVE, this.OnAutoDissolve)
	RegisterGameCallBack(yjqf_pb.TRUSTEESHIP,this.OnTrustesship)
	RegisterGameCallBack(yjqf_pb.FLUSH_BANKER,this.OnFlushBanker)
	RegisterGameCallBack(yjqf_pb.SCORE_BOARD,this.OnScoreBoard)
	RegisterGameCallBack(yjqf_pb.ERROR_INFO, this.OnErrorInfo)
end

function this.RefreshState()
    while gameObject.activeSelf do
        -- 修改电池电量
        local level = PlatformManager.Instance:GetBatteryLevel()
        local width = level / 100
        
        batteryLevel.fillAmount =  width

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
        coroutine.wait(30)
    end
end

function this.NetLevel()
	--网络WIFI显示
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
	--延迟显示
	local connect = NetWorkManager.Instance:FindConnet('game')
	if connect then
		pingLabel.text = int64.tonum2(Util.GetTime()) - int64.tonum2(connect.LastHeartBeatTime)
	else 
		pingLabel.text =  ''
	end
end

--连接网络
function this.OnConnect()
	connect.IsZanTing=false
	this.JionRoom()
end
function this.OnDisconnect()
	connect.IP = GetServerIPorTag(false, roomInfo.host)
	connect.Port = roomInfo.port 
    print('网络连接断开。。。。。。。。。。。')
end
function this.CheckNetState()
	print('CheckNetState')
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
--连接网络end

function this.NotifyGameStart()
	--通知玩家返回游戏
	if #playerData == (roomData.setting.size - 1) and roomData.round == 1 and roomData.state ~= yjqf_pb.GAMING then
		if this.OnRoundStarted ~= nil then
			this.OnRoundStarted()
		end
	end
end
function this.CloneCard()
	groupInCardGrid.gameObject:SetActive(false)
	for i = 0,groupInCardGrid.childCount - 1 do
		--生成手牌
		for j = 0, 11 do
			local obj =  NGUITools.AddChild(groupInCardGrid:GetChild(i):Find('cardGrid').gameObject, inCardItem.gameObject)
			message:AddClick(obj, this.OnClickCard)
			message:AddEventTrigger(obj, this.OnMousePressHoverCard)
			obj.name = j
			obj.transform.localScale = Vector3(0.7,0.75,1)
			local dep = 150-3*j
			obj.transform:Find("bg"):GetComponent("UISprite").depth = dep
			obj.transform:Find("mask"):GetComponent("UISprite").depth = dep+1
			obj.transform:Find("type"):GetComponent("UISprite").depth = dep+2
			obj.transform:Find("num"):GetComponent("UISprite").depth = dep+2
		end
	end
	--生成出的牌
	for i = 0, roomPeople-1 do
		player[i].playerOutCardGrid.gameObject:SetActive(false)
		for j = 0, 23 do
			local obj =  NGUITools.AddChild(player[i].playerOutCardGrid.gameObject, inCardItem.gameObject)
			obj.transform.localScale = Vector3(0.58,0.58,0.58)
			this.SetCardDepth(obj,j)
		end
		player[i].playerOutCardTable.gameObject:SetActive(false)
		for j = 0, 23 do
			local obj =  NGUITools.AddChild(player[i].playerOutCardTable:Find('sanGePaiGrid').gameObject, inCardItem.gameObject)
			obj.transform.localScale = Vector3(0.58,0.58,0.58)
			this.SetCardDepth(obj,j)
		end
		for j = 0, 15 do
			local obj =  NGUITools.AddChild(player[i].playerOutCardTable:Find('daiPaiGrid').gameObject, inCardItem.gameObject)
			obj.transform.localScale = Vector3(0.58,0.58,0.58)
			this.SetCardDepth(obj,j)
		end
	end
end
function this.SetCardDepth(obj,i)
	local dep = cardDepth+4*i
	obj.transform:Find("bg"):GetComponent("UISprite").depth = dep
	obj.transform:Find("mask"):GetComponent("UISprite").depth = dep+1
	obj.transform:Find("type"):GetComponent("UISprite").depth = dep+2
	obj.transform:Find("num"):GetComponent("UISprite").depth = dep+2
end
function this.ChangeDesktopBg()
	local inx = UnityEngine.PlayerPrefs.GetInt('ground_yjqf', 1)
	for i = 0, desktopBG.childCount-1 do
		desktopBG:GetChild(i).gameObject:SetActive(false)
	end
	desktopBG:GetChild(inx).gameObject:SetActive(true)
end
function this.ChangePaiMian()
end
function this.GetUIIndexBySeat(seat)
    return (roomData.setting.size-mySeat+seat)%roomData.setting.size
end
function this.GetPlayerDataByUIIndex(index)
	local i = index + mySeat
	if i > 0 then
		i = i % roomData.setting.size
	end
	return playerData[i]
end
function this.GetPlayerDataBySeat(seat)
	return  playerData[seat]
end

function this.SetClockTime(seat)
	coroutine.stop(clockTimeCor)
	clockTimeCor = nil
	clockTimeCor = coroutine.start(
            function()
				local clocktime = -1
				print('roomData.trusteeshipRemainMs : '..roomData.trusteeshipRemainMs)
                if roomData.trusteeshipRemainMs > 0 then
                    clocktime = roomData.trusteeshipRemainMs
                    roomData.trusteeshipRemainMs = roomData.setting.trusteeship
                else
                    clocktime = roomData.setting.trusteeship
				end
				clocktime = clocktime == 0 and 15 or clocktime
				local inx = this.GetUIIndexBySeat(seat)
				for i = 0, roomData.setting.size-1 do
					player[i].clockTime.gameObject:SetActive(false)
				end
				while clocktime >= 0 do
					--print('clocktime : '..clocktime)
					player[inx].clockTime:Find('time'):GetComponent('UILabel').text = clocktime>=0 and clocktime or 0
					player[inx].clockTime.gameObject:SetActive(true)
					if clocktime <= 5 then
						AudioManager.Instance:PlayAudio('second')
				   end
					coroutine.wait(1)
					clocktime = clocktime -1
				end
            end
    )
end
function this.OnPlayerEnter(msg)
	print('OnPlayerEnter.................................................')
	local b = yjqf_pb.RPlayer()
	b:ParseFromString(msg.body)
	playerData[b.seat]=b
	playerData[b.seat].connected=b.connected
	playerData[b.seat].ready = false
    local inx = this.GetUIIndexBySeat(b.seat)
	player[inx].playerOfflineTime.gameObject:SetActive(false)
    player[inx].playerReady.gameObject:SetActive(false)
	this.RefreshPlayer(player[inx],b)
	local data = {}
	data.cardScore = 0
	local boards = {}
	boards.seat = b.seat
	boards.nickname = b.name
	boards.historyScore = 0
	boards.roundGrab = 0
	boards.happlyScore = 0
	data.boards = {boards}
	this.UpdataBoardScore(data)
end

function this.JionRoom()
	local msg 		= Message.New()
	msg.type 		= yjqf_pb.JOIN_ROOM
	local body 		= yjqf_pb.PJoinRoom()
	body.roomNumber = roomInfo.roomNumber
	body.token 		= roomInfo.token
	body.longitude 	= tonumber(UnityEngine.PlayerPrefs.GetFloat("longitude",0))
    body.latitude 	= tonumber(UnityEngine.PlayerPrefs.GetFloat("latitude",0))
	body.address 	= UnityEngine.PlayerPrefs.GetString("address","")
	msg.body = body:SerializeToString()
	SendGameMessage(msg, this.OnJionRoomResult)
end
function this.OnJionRoomResult(msg)
	print('OnJionRoomResult.......................................')
	panelLogin.HideNetWaitting()
	this.fanHuiRoomNumber = roomInfo.roomNumber
	offlineState = false
	roomID:GetComponent('UILabel').text = roomInfo.roomNumber
	this.myseflDissolveTimes = 0
	this.needXiPai=false
	local body = yjqf_pb.RJoinRoom()
	body:ParseFromString(msg.body)
	playerName.text = body.room.playName
	playerRule.text = getYJQFRuleString(body.room.setting)
	roomData = {}
	roomData = body.room
	mySeat = body.seat
	playerData = {}
	for i=1,#body.room.players do
		local p = body.room.players[i]
		playerData[p.seat] = p
	end
	this.SetRoundNum(roomData.round)
	RoundAllData.over = false
	DestroyRoomData.roomData = body.room
	DestroyRoomData.playerData = playerData
	DestroyRoomData.mySeat = mySeat
	if body.room.dissolution ~= nil and body.room.dissolution.remainMs ~= nil and body.room.dissolution.remainMs > 0 then
		body.room.dissolution.remainMs = body.room.dissolution.remainMs/1000
		for i =1,#body.room.dissolution.acceptors do
			if body.room.dissolution.acceptors[i] == body.room.dissolution.applicant then
				table.remove(body.room.dissolution.acceptors, i)
			end
		end
		PanelManager.Instance:HideWindow('panelDestroyRoom')
		PanelManager.Instance:ShowWindow('panelDestroyRoom')
	else
		PanelManager.Instance:HideWindow('panelDestroyRoom')
	end
	print('roomData.clubId : '..roomData.clubId..' roomData.state : '..tostring(roomData.state)..' mySeat: '..mySeat)
	this.isGameing = roomData.state == yjqf_pb.GAMING or roomData.state == yjqf_pb.CUTCARD
	for i = 0, roomPeople-1 do
		player[i].playerRoomer.gameObject:SetActive(false)
		player[i].playerAllScoreObj.gameObject:SetActive(false)
	end
	this.InitPlayerInfo()
	if (roomData.state == yjqf_pb.READYING) and roomData.clubId ~= "0" and roomData.round == 1 then
		coroutine.stop(clubRoomDestoryTimeCoroutine)
		clubRoomDestoryTimeCoroutine = nil
		clubRoomDestoryTime:Find("Time"):GetComponent('UILabel').text = os.date("%M:%S", roomData.time)
		clubRoomDestoryTime.gameObject:SetActive(true)
        if clubRoomDestoryTimeCoroutine == nil then
			clubRoomDestoryTimeCoroutine = coroutine.start(
				function()
					while true do
						if roomData.time > 0 then
							clubRoomDestoryTime:Find("Time"):GetComponent('UILabel').text = os.date("%M:%S", roomData.time) --getDaoJiShi(timeChuo)--os.date("%M:%S")
							roomData.time = roomData.time - 1
						end
						coroutine.wait(1)
					end
				end
			)
		end
	else
		clubRoomDestoryTime.gameObject:SetActive(false)
	end
	if Util.GetPlatformStr() ~= 'win' then
		print('开始语音poll！！！！！！！！！！')
		if GvoiceCor then
			StopCoroutine(GvoiceCor)
		end
		GvoiceCor = StartCoroutine(this.TickNGCloudVoice)
		NGCloudVoice.Instance:ApplyMessageKey()
	end
	if roomData.state == yjqf_pb.READYING then
		this.UpdateStateReadying()
	elseif roomData.state == yjqf_pb.CUTCARD then
		this.UpdateStateCutCard()
	elseif roomData.state == yjqf_pb.GAMING then
		this.UpdateStateGaming()
	end
end

function this.UpdateStateReadying()
	this.RefreshPlayers()
	print('#roomData.scoreBoard: '..#roomData.scoreBoard)
	this.UpdataBoardScore(roomData.scoreBoard)
	if roomData.roundEnd ~= nil and #roomData.roundEnd.players > 0 then
		this.SetInviteVisiable(false)
		local b = roomData.roundEnd
		RoundData = {}
		RoundData.isInGame = true
		RoundData.gameOver = b.gameOver
		RoundData.darkCards = b.darkCards
		local players = {}
		for i = 1, #b.players do
			local pla = {}
			pla.seat = b.players[i].seat
			pla.historyScore = b.players[i].historyScore
			pla.happlyScore = b.players[i].happlyScore
			pla.rewardScore = b.players[i].rewardScore
			pla.grabScore = b.players[i].grabScore
			pla.win = b.players[i].win
			pla.cards = b.players[i].cards
			pla.placing = i
			table.insert(players,pla)
		end
		for i = 1, #players do
			if playerData[players[i].seat] ~= nil then
				players[i].name =  playerData[players[i].seat].name
				players[i].id =  playerData[players[i].seat].id
				players[i].icon =  playerData[players[i].seat].icon
			end
		end
		RoundData.players = players
		coroutine.start(
			function()
				PanelManager.Instance:ShowWindow('panelStageClear_yjqf',function()
				end)
			end
		)
	end
end
function this.UpdateStateCutCard()
	this.RefreshPlayers()
	this.UpdataBoardScore(roomData.scoreBoard)
	this.cutCardInfo.isMeCut = roomData.cutWait.seat == mySeat
	this.cutCardInfo.name = playerData[roomData.cutWait.seat].name
	this.cutCardInfo.index = roomData.cutWait.index
	PanelManager.Instance:ShowWindow('panelCutCard_yjqf')
end
function this.UpdateStateGaming()
	this.RefreshPlayers()
	this.UpdataBoardScore(roomData.scoreBoard)
	player[this.GetUIIndexBySeat(roomData.activeSeat)].playerOperateSign.gameObject:SetActive(true)
	outCard = this.findPromptCards(playerData[roomData.activeSeat].cards,roomData.hand)
	this.SetCountDownVisiable(roomData.activeSeat)
	this.UpdataPlayerCard(playerData[mySeat].cards,groupInCardGrid)
	if roomData.hand.cards ~= nil then
		if roomData.hand.category == 5 or roomData.hand.category == 3 then
			this.UpdataPlayerCard(roomData.hand.cards,player[this.GetUIIndexBySeat(roomData.hand.seat)].playerOutCardTable,roomData.hand)
		else
			this.UpdataPlayerCard(roomData.hand.cards,player[this.GetUIIndexBySeat(roomData.hand.seat)].playerOutCardGrid,roomData.hand)
		end
	end
end
function this.SetRoundNum(num)
	roomRound:GetComponent('UILabel').text = "第"..num..'局'
end

function this.InitPlayerInfo()
	groupInCardGrid.gameObject:SetActive(false)
	buttonHelp.parent.gameObject:SetActive(false)
	desktopDiPaiSign.gameObject:SetActive(false)
	helpOutCardsIndex = 1
	for i = 0, roomPeople-1 do
		player[i].playerReady.gameObject:SetActive(false)
		player[i].playerMsgLabel.parent.gameObject:SetActive(false)
		player[i].playerEmoji.gameObject:SetActive(false)
		player[i].playerOutCardEndSign.gameObject:SetActive(false)
		player[i].playerAnimation.gameObject:SetActive(false)
		player[i].clockTime.gameObject:SetActive(false)
		player[i].playerSound.gameObject:SetActive(false)
		player[i].playerOperateSign.gameObject:SetActive(false)
		player[i].playerPass.gameObject:SetActive(false)
		--player[i].playerCardCategory.gameObject:SetActive(false)
		player[i].playerBoomSign.gameObject:SetActive(false)
		player[i].playerOutCardGrid.gameObject:SetActive(false)
		player[i].playerOutCardTable.gameObject:SetActive(false)
	end
end
function this.RefreshPlayers()
	for i = 1, #roomData.players do
		if roomData.players[i].seat == mySeat then
			readyBtn.gameObject:SetActive(not roomData.players[i].ready)
		end
	end
	print('playerData[mySeat].ready: '..tostring(playerData[mySeat].ready))
	this.SetInviteVisiable((#roomData.players ~= roomData.setting.size) or (not playerData[mySeat].ready))
	player[this.GetUIIndexBySeat(0)].playerRoomer.gameObject:SetActive(true)
	for i = 1, #roomData.players do
		local inx = this.GetUIIndexBySeat(roomData.players[i].seat)
		this.RefreshPlayer(player[inx],roomData.players[i])
	end
end
function this.RefreshPlayer(playerUI,data)
	playerUI.obj.gameObject:SetActive(true)
	playerUI.playerName:GetComponent('UILabel').text = data.name
	coroutine.start(LoadPlayerIcon, playerUI.playerIcon:GetComponent('UITexture'), data.icon)
	SetUserData(playerUI.playerIcon.gameObject,data)
	playerUI.playerScore:GetComponent('UILabel').text = data.score
	if roomData.state == yjqf_pb.READYING then
		playerUI.playerReady.gameObject:SetActive(data.ready)
	end
	playerUI.playerOfflineTime.gameObject:SetActive(not data.connected)
	if data.offlineTimes ~= nil and data.offlineTimes ~= 0 then
		this.StartOfflineIncrease(data.seat, data.offlineTimes)
	end
	playerUI.playerTrusteeship.gameObject:SetActive(data.trusteeship)
	if data.seat == mySeat then
		TrusteeshipPanel.gameObject:SetActive(data.trusteeship)
	end
end

--是否显示解散房间，返回大厅，邀请玩家按钮
function this.SetInviteVisiable(show)
	ButtonInvite.parent.gameObject:SetActive(true)
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

function this.OnPlayerJion(msg)
	print('OnPlayerJion玩家进来了.........................')
	local b = yjqf_pb.RPlayerJoin()
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
	if (roomData.state == yjqf_pb.READYING) and roomData.setting.size == 3 then
		local datas = {}
		for i = 0, roomData.setting.size - 1 do
			datas[i] = this.GetPlayerDataByUIIndex(i)
		end
		GPS.transform.gameObject:SetActive(true)
		SetGPSInfo(GPS,pos3,datas,roomData.setting.size)
	end
	player[this.GetUIIndexBySeat(b.seat)].playerRoomer.gameObject:SetActive(b.seat == 0)
	this.RefreshPlayer(player[this.GetUIIndexBySeat(b.seat)],playerData[b.seat])
	ButtonInvite.gameObject:SetActive(#playerData ~= roomData.setting.size - 1 and IsAppleReview() == false)
	ButtonInvite.parent:GetComponent("UIGrid"):Reposition()
	this.NotifyGameStart()
	this.StopOfflineIncrease(b.seat)
end

function this.OnLeaveRoom(msg)
	print('OnLeaveRoom....................................................')
	NetWorkManager.Instance:DeleteConnect('game')
	PanelManager.Instance:HideWindow('panelDestroyRoom')
	panelLogin.HideGameNetWaitting()
    if roomData.clubId ~= '0' then
        local data = {}
        data.name = 'panelInGame_yjqf'
        PanelManager.Instance:ShowWindow('panelClub', data)
    else
        PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
	end
	roomData.clubId = '0'
end

function this.OnPlayerLeave(msg)
	print('OnPlayerLeave......................................')
	local b = yjqf_pb.RPlayerLeave()
	b:ParseFromString(msg.body)
	local inx = this.GetUIIndexBySeat(b.seat)
    playerData[b.seat] = nil
	if roomData.state == yjqf_pb.READYING and roomData.setting.size == 3 then
		local datas = {}
		for i = 0, roomData.setting.size - 1 do
			datas[i] = this.GetPlayerDataByUIIndex(i)
		end
		GPS.transform.gameObject:SetActive(true)
		SetGPSInfo(GPS,pos3,datas,roomData.setting.size)
	end
	player[inx].obj.gameObject:SetActive(false)
	ButtonInvite.gameObject:SetActive(#playerData ~= roomData.setting.size -1 and IsAppleReview() == false)
	ButtonInvite.parent:GetComponent("UIGrid"):Reposition()
	player[inx].playerAllScoreObj.gameObject:SetActive(false)
end
function this.OnRoomError(msg)
	print('OnEnterError......................')
	panelMessageTip.SetParamers('加入房间错误', 2)
    PanelManager.Instance:ShowWindow('panelMessageTip')
    coroutine.start(
    function()
        coroutine.wait(2)
        panelLogin.HideGameNetWaitting()
        if roomData.clubId ~= '0' then
            local data = {}
            data.name = gameObject.name
            PanelManager.Instance:ShowWindow('panelClub', data)
        else
            PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
        end
        roomData.clubId = '0'
        this.Destroy()
    end
    )
end
function this.OnNoRoom(msg)
	print('OnNoRoom......................')
	panelMessageTip.SetParamers('房间已解散', 2)
    PanelManager.Instance:ShowWindow('panelMessageTip')
    coroutine.start(
    function()
		coroutine.wait(2)
		this.OnDestory(msg)
		if roomData.clubId ~= '0' then
			local data = {}
			data.name = gameObject.name
			data.clubId = roomData.clubId
			PanelManager.Instance:ShowWindow('panelClub', data)
		else
			PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
		end
		roomData.clubId = '0'
        panelInGame =nil
    end
    )
end
function this.OnClicButtonDisbandRoom()
    local msg = Message.New()
    msg.type = yjqf_pb.DISSOLVE
    local body = yjqf_pb.PDissolve()
    body.decision = yjqf_pb.APPLY
    msg.body = body:SerializeToString()
    SendGameMessage(msg, nil)
end
function this.OnCutWait(msg)
	local data = yjqf_pb.RCutWiat()
	data:ParseFromString(msg.body)
	this.isGameing = true
	print('OnCutWait.............收到切牌消息 : '..data.seat)
	this.StopTrustesship()
	clubRoomDestoryTime.gameObject:SetActive(false)
	readyBtn.gameObject:SetActive(false)
	this.SetInviteVisiable(false)
	GPS.transform.gameObject:SetActive(false)
	if roomData.round == 1 and roomData.setting.size == 3 then
		local datas = {}
		for i = 0, roomData.setting.size - 1 do
			datas[i] = this.GetPlayerDataByUIIndex(i)
		end
        InspectIPAndGPS(datas,pos3,this.OnClicButtonDisbandRoom)
    end
	roomData.state = yjqf_pb.CUTCARD
	this.SetRoundNum(roomData.round)
	for i = 0, roomPeople-1 do
		player[i].playerReady.gameObject:SetActive(false)
	end
	if gameObject.activeSelf then
		if this.needXiPai==true then
			this.needXiPai=false
			connect.IsZanTing=true
			PanelManager.Instance:ShowWindow('panelXiPai_poker',function()
				this.cutCardInfo.isMeCut = data.seat == mySeat
				this.cutCardInfo.name = playerData[data.seat].name
				this.cutCardInfo.index = data.index
				PanelManager.Instance:ShowWindow('panelCutCard_yjqf')
				connect.IsZanTing=false
			end)
		else
			this.cutCardInfo.isMeCut = data.seat == mySeat
			this.cutCardInfo.name = playerData[data.seat].name
			this.cutCardInfo.index = data.index
			PanelManager.Instance:ShowWindow('panelCutCard_yjqf')
		end
	end
end
function this.OnFlushBanker(msg)
end

function this.OnScoreBoard(msg)
	local data = yjqf_pb.RScoreBoard()
	data:ParseFromString(msg.body)
	print('OnScoreBoard.............刷新计分板')
	this.UpdataBoardScore(data,true)
end
function this.UpdataBoardScore(data,isPlay)
	desktopScore:GetComponent('UILabel').text = data.cardScore
	for i = 1, #data.boards do
		local board = data.boards[i]
		player[board.seat].playerAllScoreObj.gameObject:SetActive(true)
		player[board.seat].playerAllScoreName:GetComponent('UILabel').text = board.nickname
		player[board.seat].playerHistory:GetComponent('UILabel').text = board.historyScore
		if board.happlyScore ~= 0 and board.happlyScore ~= tonumber(player[board.seat].playerHappyScore:GetComponent('UILabel').text) and isPlay then
			AudioManager.Instance:PlayAudio('addScore')
		end
		player[board.seat].playerHappyScore:GetComponent('UILabel').text = board.happlyScore
		if board.roundGrab ~= 0 and board.roundGrab ~= tonumber(player[board.seat].playerNowScore:GetComponent('UILabel').text) and isPlay then
			AudioManager.Instance:PlayAudio('addScore')
			player[board.seat].playerNowScore:GetComponent('UILabel').color = Color.red
			player[board.seat].playerNowScore:GetComponent('TweenPosition').enabled = true
			local pos = player[board.seat].playerNowScore.transform.localPosition
			coroutine.start(
				function()
					coroutine.wait(2)
					player[board.seat].playerNowScore:GetComponent('TweenPosition').enabled = false
					player[board.seat].playerNowScore:GetComponent('UILabel').color = Color.white
					player[board.seat].playerNowScore.transform.localPosition = pos
				end
			)
		else
			player[board.seat].playerNowScore:GetComponent('TweenPosition').enabled = false
		end
		player[board.seat].playerNowScore:GetComponent('UILabel').text = board.roundGrab
		player[this.GetUIIndexBySeat(board.seat)].playerScore:GetComponent('UILabel').text = board.roundGrab
		--print(i..' board.nickname: '..board.nickname..' board.historyScore : '..board.historyScore..' board.happlyScore : '..board.happlyScore..' board.roundGrab : '..board.roundGrab)
	end
end
function this.OnOverTimeDissolve(msg)
	panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '规定时间内房间未开始已自动解散')
	PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end
function this.OnLordDissolve(msg)
	print('OnLordDissolve......................')
	panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '该房间已被群主或管理员解散')
	PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
	this.fanHuiRoomNumber = nil
end
function this.OnDisconnected(msg)
	print('OnDisconnected......................')
	print('OnDisconnected')
	local b = yjqf_pb.RSeat()
	b:ParseFromString(msg.body)
	local i = this.GetUIIndexBySeat(b.seat)
	playerData[b.seat].connected = false
	player[i].playerOfflineTime.gameObject:SetActive(true)
	--断线后停止托管的倒计时
	this.StartOfflineIncrease(b.seat, 0)
end

function this.OnDissolve(msg)
	print('OnDissolve......................')
	local b = yjqf_pb.RDissolve()
	b:ParseFromString(msg.body)
	if b.decision == yjqf_pb.APPLY then
		roomData.dissolution.applicant = b.seat
		while #roomData.dissolution.acceptors > 0 do
			table.remove(roomData.dissolution.acceptors, #roomData.dissolution.acceptors)
		end
		roomData.dissolution.remainMs = b.remainMs/1000
		PanelManager.Instance:HideWindow('panelDestroyRoom')
    	PanelManager.Instance:ShowWindow('panelDestroyRoom')
	elseif b.decision == yjqf_pb.AGREE then
		if panelDestroyRoom then
			table.insert(DestroyRoomData.roomData.dissolution.acceptors, b.seat)
			panelDestroyRoom.Refresh()
		end
	elseif b.decision == yjqf_pb.AGAINST then
		if panelDestroyRoom then
			table.insert(DestroyRoomData.roomData.dissolution.rejects, b.seat)
			panelDestroyRoom.Refresh(b.seat)
		end
	end
end
function this.OnDestory(msg)
	print('房间已被销毁')
    this.StopCheckNetState()
    this.StopAllOfflineIncrease()
    NetWorkManager.Instance:DeleteConnect('game')
    panelLogin.HideGameNetWaitting()
    PanelManager.Instance:HideWindow('panelDestroyRoom')
    this.fanHuiRoomNumber = nil
    if PanelManager.Instance:IsActive('panelGameSetting_dda') then
        PanelManager.Instance:HideWindow('panelGameSetting_dda')
    end
    if PanelManager.Instance:IsActive('panelPlayerInfo') then
        PanelManager.Instance:HideWindow('panelPlayerInfo')
	end
	if PanelManager.Instance:IsActive('panelCutCard_yjqf') then
        PanelManager.Instance:HideWindow('panelCutCard_yjqf')
	end
	TrusteeshipTip.gameObject:SetActive(false)
    TrusteeshipPanel.gameObject:SetActive(false)
	coroutine.stop(trusteeshipcor)
	coroutine.stop(clockTimeCor)
	coroutine.stop(clubRoomDestoryTimeCoroutine)
	if panelStageClear_yjqf then
		panelStageClear_yjqf.setButtonsStatus(true)
	end
    offlineState = true
    if roomData.round == 1 and roomData.state == yjqf_pb.READYING and this.hasStageClear==false then
        panelLogin.HideGameNetWaitting()
        if roomData.clubId ~= '0' then
            local data = {}
            data.name = 'panelInGame_dda'
            PanelManager.Instance:ShowWindow('panelClub', data)
        else
            PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
        end
        roomData.clubId = '0'
		panelInGame =nil
		PanelManager.Instance:HideWindow(gameObject.name)
    end
end

function this.UpdataPlayerCard(cards,grid,hand)
	print('grid: '..grid.name..' #cards : '..#cards)
	local cardList = this.fenXiCard(cards)
	if grid == groupInCardGrid then
		this.initCardGroup()
		for i=5,15 do 
			if cardList[i] then
				local v = cardList[i]
				local group = grid:GetChild(15-v.value)
				local cardGrid = group:Find('cardGrid')
				local type = group:Find('type')
				if v.num>=4 then
					if v.num < 7 then
						type:GetComponent('UISprite').spriteName='提示_4炸'
					else
						type:GetComponent('UISprite').spriteName='提示_4炸以上'
					end
					type:Find('Label'):GetComponent('UILabel').text = v.num..'张'
					type.gameObject:SetActive(true)
				end
				for j=0,v.num-1 do
					local item = cardGrid:GetChild(j)
					SetUserData(item.gameObject,v.trueValues[j+1])
					this.UpdataCardInfo(item,v.trueValues[j+1])
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
	else
		this.initOutCardGroup()
		table.sort(cards)
		if hand.category == 5 or hand.category == 3 then
			--三张或对子
			local daipai = {}
			local sange = {}
			for i = 1, #cards do
				local cal = getIntPart(cards[i]/4)
				if cal <= hand.maxKeyRank and cal >= hand.minKeyRank then
					table.insert(sange,cards[i])
				else
					table.insert(daipai,cards[i])
				end
			end
			for i = 1, #sange do
				this.UpdataCardInfo(grid:Find('sanGePaiGrid'):GetChild(i-1),sange[i])
			end
			for i = 1, #daipai do
				this.UpdataCardInfo(grid:Find('daiPaiGrid'):GetChild(i-1),daipai[i])
			end
			grid:Find('zi').gameObject:SetActive(true)
			grid:Find('daiPaiGrid'):GetComponent('UIGrid'):Reposition()
			grid:Find('sanGePaiGrid'):GetComponent('UIGrid'):Reposition()
		else
			for i = 1, #cards do
				local item = grid:GetChild(i-1)
				this.UpdataCardInfo(item,cards[i])
			end
		end
	end
	grid.gameObject:SetActive(true)
	if 'outCardTable' == grid.name then
		grid:GetComponent('UITable'):Reposition()
	else
		grid:GetComponent('UIGrid'):Reposition()
	end
end
function this.UpdataCardInfo(item,card)
	local plateNum = GetPlateNum(card)
	local plateType = GetPlateType(card)
	local paiMianValue = UnityEngine.PlayerPrefs.GetInt('dda_paiMianValue', 3)
	local strPlateNum = 'card_'..plateNum
	local strplateType = ''
	local color = Color.white
	local type = item:Find('type'):GetComponent('UISprite')
	local num = item:Find('num'):GetComponent('UISprite')
	if plateType == 0 then
		strplateType = "DiamondIcon1"
	elseif plateType == 1 then
		strplateType = "ClubIcon1"
		color = Color(51/255,52/255,57/255)
	elseif plateType == 2 then
		strplateType = "HeartIcon1"
	elseif plateType == 3 then
		strplateType = "SpadeIcon1"
		color = Color(51/255,52/255,57/255)
	else
		strplateType = "unknow icon"
	end
	num.spriteName = strPlateNum
	num.color = color
	type.spriteName = strplateType
	type.color = color
	item.gameObject:SetActive(true)
end
--分析数据
function this.fenXiCard(cards)
	local myList = {}
	if cards then
		for i = 1, #cards do
			local value = GetPlateNum(cards[i])--逻辑值（牌面值）
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
	for i=0,groupInCardGrid.childCount-1 do 
		local group = groupInCardGrid:GetChild(i)
		group:Find('type').gameObject:SetActive(false)
		local cardGrid = group:Find('cardGrid')
		for j=0,cardGrid.childCount-1 do
			cardGrid:GetChild(j).gameObject:SetActive(false)
		end
		group.gameObject:SetActive(false)
	end
end
--初始化手牌
function this.initOutCardGroup()
	for i=0,roomData.setting.size - 1 do 
		local cardGrid = player[i].playerOutCardGrid 
		cardGrid.gameObject:SetActive(false)
		for j=0,cardGrid.childCount-1 do
			cardGrid:GetChild(j).gameObject:SetActive(false)
		end
		player[i].playerOutCardTable.gameObject:SetActive(false)
		local sanGePaiGrid = player[i].playerOutCardTable:Find('sanGePaiGrid')
		for j=0,sanGePaiGrid.childCount-1 do
			sanGePaiGrid:GetChild(j).gameObject:SetActive(false)
		end
		player[i].playerOutCardTable:Find('zi').gameObject:SetActive(false)
		local daiPaiGrid = player[i].playerOutCardTable:Find('daiPaiGrid')
		for j=0,daiPaiGrid.childCount-1 do
			daiPaiGrid:GetChild(j).gameObject:SetActive(false)
		end
	end
end
function this.OnRoundStart(msg) --游戏开始
	print('OnRoundStart........................')
	local data = yjqf_pb.RRoundStart()
	data:ParseFromString(msg.body)
	connect.IsZanTing=true
	this.isGameing = true
	for i=1,#data.players do
		local p = data.players[i]
		while(#playerData[p.seat].cards > 0) do
			playerData[p.seat].cards:remove(#playerData[p.seat].cards)
		end
		for j=1,#p.cards do
			playerData[p.seat].cards:append(p.cards[j])
		end
	end
	desktopDiPaiSign.gameObject:SetActive(true)
	StartCoroutine(function()
		WaitForSeconds(1.5)
		PanelManager.Instance:HideWindow('panelCutCard_yjqf')
		local obj = gameObject.transform:Find('cutCard')
		this.UpdataCardInfo(obj,data.cutCardValue)
		local positionTo = player[this.GetUIIndexBySeat(data.activeSeat)].playerIcon.position
		obj.gameObject:SetActive(true)
		TweenPosition.Begin(obj.gameObject, 1, positionTo, true)
		TweenScale.Begin(obj.gameObject,1,Vector3(0.51,0.56,1))
		connect.IsZanTing=false
		WaitForSeconds(4)
		obj.position=Vector3.zero
		obj.gameObject:SetActive(false)
		
	end)
end

function this.OnWaitPlay(msg)
	print('OnWaitPlay ............................')
	local b = yjqf_pb.RSeat()
	b:ParseFromString(msg.body)
	this.isGameing = true
	roomData.state = yjqf_pb.GAMING
	this.UpdataPlayerCard(playerData[mySeat].cards,groupInCardGrid)
	player[this.GetUIIndexBySeat(b.seat)].playerOperateSign.gameObject:SetActive(true)
	roomData.activeSeat = b.seat
	this.SetCountDownVisiable(b.seat)
	outCard = this.findPromptCards(playerData[b.seat].cards)
	AudioManager.Instance:PlayAudio('gameStart07')
end

--疲劳值不足自动解散房间
function this.OnAutoDissolve(msg)
	print('疲劳值不足自动解散房间......................................')
	local body = yjqf_pb.RAutoDissolve()
    body:ParseFromString(msg.body)
    IsAutoDissolve = true
	AutoDissolveData = body
	PanelManager.Instance:ShowWindow('panelAutoDissolve', AutoDissolveData)
end
function this.SetDiPai(cards)
	desktopDiPaiCard.gameObject:SetActive(true)
	desktopDiPaiCard:GetComponent('UIGrid'):Reposition()
	table.sort(cards)
	for i = 1, #cards do
		print('GetPlateNum(cards[i]) : '..GetPlateNum(cards[i]))
		this.UpdataCardInfo(desktopDiPaiCard:GetChild(i-1),cards[i])
		if GetPlateNum(cards[i]) == 5 or GetPlateNum(cards[i]) == 10 or GetPlateNum(cards[i]) == 13 then
			desktopDiPaiCard:GetChild(i-1):GetComponent('TweenPosition').enabled = true
		end
	end
end
function this.OnRoundEnd(msg)
	print('OnRoundEnd.........................................')
	local b = yjqf_pb.RRoundEnd()
	b:ParseFromString(msg.body)
	connect.IsZanTing=true
	coroutine.stop(clockTimeCor)
	this.hasStageClear=true
	RoundData = {}
	RoundData.isInGame = true
	RoundData.gameOver = b.gameOver
	RoundData.darkCards = b.darkCards
	local players = {}
	for i = 1, #b.players do
		local pla = {}
		pla.seat = b.players[i].seat
		pla.historyScore = b.players[i].historyScore
		pla.happlyScore = b.players[i].happlyScore
		pla.rewardScore = b.players[i].rewardScore
		pla.grabScore = b.players[i].grabScore
		pla.win = b.players[i].win
		pla.cards = b.players[i].cards
		pla.placing = i
		table.insert(players,pla)
	end
	for i = 1, #players do
		if playerData[players[i].seat] ~= nil then
			players[i].name =  playerData[players[i].seat].name
			players[i].id =  playerData[players[i].seat].id
			players[i].icon =  playerData[players[i].seat].icon
		end
	end
	RoundData.players = players
	coroutine.start(
		function()
			coroutine.wait(1)
			for i = 0, roomPeople-1 do
				player[i].playerBoomSign.gameObject:SetActive(false)
				player[i].playerOutCardGrid.gameObject:SetActive(false)
				player[i].playerOutCardTable.gameObject:SetActive(false)
			end
			this.SetDiPai(b.lossCards)
			local isHaveScore =false
			for i = 1, #b.lossCards do
				if GetPlateNum(b.lossCards[i]) == 5 or GetPlateNum(b.lossCards[i]) == 10 or GetPlateNum(b.lossCards[i]) == 13 then
					isHaveScore = true
					break
				end
			end
			if isHaveScore then
				local data = b.players[1]
				if data.grabScore ~= 0 and data.grabScore ~= tonumber(player[data.seat].playerNowScore:GetComponent('UILabel').text) then
					AudioManager.Instance:PlayAudio('addScore')
					print('data.grabScore : '..data.grabScore)
					player[data.seat].playerNowScore:GetComponent('UILabel').text = data.grabScore
					player[data.seat].playerNowScore:GetComponent('UILabel').color = Color.red
					player[data.seat].playerNowScore:GetComponent('TweenPosition').enabled = true
					local pos = player[data.seat].playerNowScore.transform.localPosition
					coroutine.wait(2)
					player[data.seat].playerNowScore:GetComponent('TweenPosition').enabled = false
					player[data.seat].playerNowScore:GetComponent('UILabel').color = Color.white
					player[data.seat].playerNowScore.transform.localPosition = pos
				end
			else
				coroutine.wait(2)
			end
			desktopDiPaiCard.gameObject:SetActive(false)
			PanelManager.Instance:ShowWindow('panelStageClear_yjqf',function()
				connect.IsZanTing=false
				this.InitPlayerInfo()
				this.initCardGroup()
			end)
		end
	)
end

function this.OnGameOver(msg)
	print('所有局数结束.................')
	local b = yjqf_pb.ROver()
	b:ParseFromString(msg.body)
	this.isGameing = false
	RoundAllData.over = true
	RoundAllData.mySeat = mySeat
	RoundAllData.complete = b.complete
	RoundAllData.roomId = b.roomId
	local players = {}
	for i = 1, #b.players do
		local pla = {}
		pla.seat = b.players[i].seat 
		pla.bigWinner = b.players[i].bigWinner 
		pla.win = b.players[i].win 
		pla.firstCount = b.players[i].firstCount 
		pla.happlyCount = b.players[i].happlyCount 
		pla.happlyScore = b.players[i].happlyScore 
		pla.cardsScore = b.players[i].cardsScore 
		pla.resultScore = b.players[i].resultScore 
		pla.score = b.players[i].score 
		pla.fee = b.players[i].fee 
		table.insert(players,pla)
	end
	for i = 1, #players do
		if playerData[players[i].seat] ~= nil then
			players[i].name =  playerData[players[i].seat].name
			players[i].id =  playerData[players[i].seat].id
			players[i].icon =  playerData[players[i].seat].icon
			players[i].signature =  playerData[players[i].seat].signature
			players[i].imgUrl =  playerData[players[i].seat].imgUrl
		end
		players[i].trusteeship = player[this.GetUIIndexBySeat(players[i].seat)].playerTrusteeship.gameObject.activeSelf
	end
	
	RoundAllData.players = players
	if this.hasStageClear==false  then
		PanelManager.Instance:ShowWindow('panelStageClearAll_yjqf')
		this.InitPlayerInfo()
		PanelManager.Instance:HideWindow(gameObject.name)
	end
end

function this.OnClickReady(go)
	print('OnClickReady...........')
	local msg = Message.New()
	msg.type = yjqf_pb.READY
	SendGameMessage(msg, nil)
	go.gameObject:SetActive(false)
end
function this.OnReady(msg)
	print('OnReady.......')
	local b = yjqf_pb.RSeat()
	b:ParseFromString(msg.body)
	playerData[b.seat].ready = true
	player[this.GetUIIndexBySeat(b.seat)].playerReady.gameObject:SetActive(true)
	
	if b.seat == mySeat then
		readyBtn.gameObject:SetActive(false)
		this.hasStageClear=false
		if panelStageClear_yjqf then
			PanelManager.Instance:HideWindow('panelStageClear_yjqf')
		end
	end
	this.NotifyGameStart()
end

function this.SetCountDownVisiable(activeSeat)
	buttonHelp.parent.gameObject:SetActive(activeSeat == mySeat)
	this.SetClockTime(activeSeat)
	this.SetDelegateCount(activeSeat)
end
function this.OnClickButtonPlay(go)
	AudioManager.Instance:PlayAudio('btn')
	local msg = Message.New()
	msg.type = yjqf_pb.PLAY
	local b = yjqf_pb.PPlay()
	for i = 0,groupInCardGrid.childCount-1 do 
		local cardGrid = groupInCardGrid:GetChild(i):Find('cardGrid')
		for j = 0,cardGrid.childCount-1 do
			if cardGrid:GetChild(j).gameObject.activeSelf and cardGrid:GetChild(j):Find('mask').gameObject.activeSelf then
				table.insert(b.cards, GetUserData(cardGrid:GetChild(j).gameObject))
			end
		end
	end
	if #b.cards == 0 then
		return 
	end
	print('OnClickButtonPlay.......'..#b.cards)
	msg.body = b:SerializeToString()
	SendGameMessage(msg, nil)
end
function this.OnPlay(msg)
	local b = yjqf_pb.RPlay()
	b:ParseFromString(msg.body)
	if b.seat == mySeat then
		buttonHelp.parent.gameObject:SetActive(false)
		this.OnClickBG()	
	end
	
	AudioManager.Instance:PlayAudio('betcard')
	print('OnPlay.......#b.hand.cards'..#b.hand.cards..' b.nextSeat : '..b.nextSeat..' b.seat : '..b.seat..' b.status : '..b.status)
	desktopScore:GetComponent('UILabel').text = b.deskCardScore
	roomData.activeSeat = b.nextSeat
	lastPlayerOutHand = b.hand
	local index = this.GetUIIndexBySeat(b.seat)
	if mySeat == b.seat then
		for i=1,#b.hand.cards do
			for j=1,#playerData[mySeat].cards do
				if b.hand.cards[i] == playerData[mySeat].cards[j] then
					playerData[mySeat].cards:remove(j)
					break
				end
			end
		end
		this.UpdataPlayerCard(playerData[mySeat].cards,groupInCardGrid)
	end
	
	--player[this.GetUIIndexBySeat(b.nextSeat)].playerCardCategory.gameObject:SetActive(false)
	coroutine.stop(clockTimeCor)
	for i = 0, roomPeople-1 do
		player[i].playerBoomSign.gameObject:SetActive(false)
		player[i].playerOperateSign.gameObject:SetActive(false)
		player[i].playerOutCardTable.gameObject:SetActive(false)
		player[i].playerOutCardGrid.gameObject:SetActive(false)
		player[i].playerPass.gameObject:SetActive(false)
		player[i].clockTime.gameObject:SetActive(false)
	end
	player[this.GetUIIndexBySeat(b.nextSeat)].playerOperateSign.gameObject:SetActive(true)
	if b.hand.category == 5 or b.hand.category == 3 then
		this.UpdataPlayerCard(b.hand.cards,player[index].playerOutCardTable,b.hand)
	else
		this.UpdataPlayerCard(b.hand.cards,player[index].playerOutCardGrid,b.hand)
	end
	local name 
	if b.roundOrder == 0 then
		name = '上游'
	elseif b.roundOrder == 1 then
		if roomData.setting.size == 3 then
			name = '中游'
		else
			name = '下游'
		end
	elseif b.roundOrder == 2 then
		name = '下游'
	elseif b.roundOrder == -1 then
		name = ''	
	end
	player[index].playerOutCardEndSign:GetComponent('UISprite').spriteName = name
	player[index].playerOutCardEndSign.gameObject:SetActive(b.roundOrder ~= -1)
	if b.roundOrder ~= -1 then
		AudioManager.Instance:PlayAudio('winerVoice')
	end

	if b.hand.category == 6 then
		if #b.hand.cards < 7 then
			player[index].playerBoomSign:GetComponent('UISprite').spriteName='提示_4炸'
		else
			player[index].playerBoomSign:GetComponent('UISprite').spriteName='提示_4炸以上'
		end
		player[index].playerBoomSign:Find('Label'):GetComponent('UILabel').text = #b.hand.cards..'张'
		player[index].playerBoomSign.gameObject:SetActive(true)
	end
	this.PlayCardSound(b.hand.cards,b.hand.category,playerData[b.seat].sex,UnityEngine.PlayerPrefs.GetInt("sound_yjqf", 1) == 1)
	if (b.status == 2 or b.status == 3) and mySeat == b.nextSeat then
		helpOutCardsIndex = 1
		outCard = this.findPromptCards(playerData[roomData.activeSeat].cards,b.hand)
		this.SetCountDownVisiable(b.nextSeat)
	end
end
function this.PlayCardSound(cards,category,sex,isfy)
	local soundName = ''
	if isfy then
		soundName = soundName..'fy_yjqf_'
	end
	if category == 0 then
		soundName = soundName..string.format('dan_%d_%d', sex,GetPlateNum(cards[1]))
	elseif category == 1 then
		soundName = soundName..string.format('dui_%d_%d', sex,GetPlateNum(cards[1]))
	elseif category == 2 then
		soundName = soundName..string.format('liandui_%d', sex)
	elseif category == 3 then
		soundName = soundName..string.format('sandaier_%d', sex)
	elseif category == 4 then
		soundName = soundName..string.format('shunzi_%d', sex)
	elseif category == 5 then
		soundName = soundName..string.format('fei_%d', sex)
	elseif category == 6 then
		if isfy then
			soundName = soundName..string.format('bomb_%d_%d', sex , #cards)
		else
			soundName = soundName..string.format('bomb_%d', sex)
		end
	end
	if soundName ~= nil and soundName ~= '' then
		AudioManager.Instance:PlayAudio(soundName)
	end
end
function this.OnPass(msg)
	local b = yjqf_pb.RPass()
	b:ParseFromString(msg.body)
	print('OnPass.......'..' b.nextSeat : '..b.nextSeat..' b.seat'..b.seat..' b.status : '..b.status)
	desktopScore:GetComponent('UILabel').text = b.deskCardScore
	roomData.activeSeat = b.nextSeat
	coroutine.stop(clockTimeCor)
	for i = 0, roomPeople-1 do
		player[i].playerOperateSign.gameObject:SetActive(false)
		player[i].playerPass.gameObject:SetActive(false)
		player[i].clockTime.gameObject:SetActive(false)
	end
	
	player[this.GetUIIndexBySeat(b.nextSeat)].playerOutCardTable.gameObject:SetActive(false)
	player[this.GetUIIndexBySeat(b.nextSeat)].playerOutCardGrid.gameObject:SetActive(false)
	--player[this.GetUIIndexBySeat(b.nextSeat)].playerCardCategory.gameObject:SetActive(false)
	player[this.GetUIIndexBySeat(b.nextSeat)].playerBoomSign.gameObject:SetActive(false)
	player[this.GetUIIndexBySeat(b.seat)].playerPass.gameObject:SetActive(true)
	player[this.GetUIIndexBySeat(b.nextSeat)].playerOperateSign.gameObject:SetActive(true)
	local soundName = ''
	if UnityEngine.PlayerPrefs.GetInt("sound_yjqf", 1) == 1 then
		soundName = soundName..'fy_yjqf_'
	end
	soundName = soundName..string.format('yaobuqi_%d_%d', playerData[b.seat].sex,(math.random(0, 1))+1)
	AudioManager.Instance:PlayAudio(soundName)
	local name 
	if b.roundOrder == 0 then
		name = '上游'
	elseif b.roundOrder == 1 then
		if roomData.setting.size == 3 then
			name = '中游'
		else
			name = '下游'
		end
	elseif b.roundOrder == 2 then
		name = '下游'
	elseif b.roundOrder == -1 then
		name = ''	
	end
	player[this.GetUIIndexBySeat(b.seat)].playerOutCardEndSign:GetComponent('UISprite').spriteName = name
	player[this.GetUIIndexBySeat(b.seat)].playerOutCardEndSign.gameObject:SetActive(b.roundOrder ~= -1)
	if b.roundOrder ~= -1 then
		AudioManager.Instance:PlayAudio('winerVoice')
	end
	if (b.status == 2 or b.status == 3) and mySeat == b.nextSeat then
		helpOutCardsIndex = 1
		if b.status == 3 then
			outCard = this.findPromptCards(playerData[roomData.activeSeat].cards,lastPlayerOutHand)
		else
			outCard = this.findPromptCards(playerData[roomData.activeSeat].cards)
			for i = 0, roomPeople-1 do
				player[i].playerBoomSign.gameObject:SetActive(false)
				player[i].playerOutCardTable.gameObject:SetActive(false)
				player[i].playerOutCardGrid.gameObject:SetActive(false)
			end
		end
		this.SetCountDownVisiable(b.nextSeat)
	end
end
function this.OnPlayError(msg)
	panelMessageTip.SetParamers('请选择正确的牌型', 1)
	PanelManager.Instance:ShowWindow('panelMessageTip')
	this.SetCountDownVisiable(mySeat)
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
	this.OnClickBG()
	print('helpOutCardsIndex : '..helpOutCardsIndex..' #outCard length: '..#outCard..' #helpOutCards length: '..#helpOutCards)
	this.SetTiShiSelectCard(helpOutCards)
	
end
--获得提示牌
function this.SetTiShiSelectCard(cards)
	local cardsData = this.fenXiCard(cards)
	for i=0,groupInCardGrid.childCount-1 do 
		local group = groupInCardGrid:GetChild(i):Find('cardGrid')
		if group:GetChild(0).gameObject.activeSelf then
			local card = GetUserData(group:GetChild(0).gameObject)
			if card ~= nil and cardsData[GetPlateNum(card)] ~= nil then 
				for j = 1 , cardsData[GetPlateNum(card)].num do
					group:GetChild(j-1):Find('mask').gameObject:SetActive(true)
				end
			end
		end
	end
end
local group1 = {}
local group2 = {}
local group3 = {}
local group4 = {}
local group5 = {}
local group6 = {}
local group7 = {}
local group8 = {}
local group9 = {}
local group10 = {}
local group11 = {}
local group12 = {}
function this.findPromptCards(myCards,lasthand)
	local myCardList = this.fenXiCard(myCards)
	local helpOutCards = {}
	group1 = {}
	group2 = {}
	group3 = {}
	group4 = {}
	group5 = {}
	group6 = {}
	group7 = {}
	group8 = {}
	group9 = {}
	group10 = {}
	group11 = {}
	group12 = {}
	local marr1 = {} 
	local marrChai1 = {}
	local marr2 = {}
	local marrChai2 = {}
	local marr3 = {}
	local marrDaiPai = {}
	
	for i = 5, 15 do
		if myCardList[i] then
			if myCardList[i].num == 1 then
				table.insert(group1,this.GetGroupNum(myCardList[i]))
			end
			if myCardList[i].num == 2 then
				table.insert(group2,this.GetGroupNum(myCardList[i]))
			end
			if myCardList[i].num == 3 then
				table.insert(group3,this.GetGroupNum(myCardList[i]))
			end
			if myCardList[i].num == 4 then
				table.insert(group4,this.GetGroupNum(myCardList[i]))
			end
			if myCardList[i].num == 5 then
				table.insert(group5,this.GetGroupNum(myCardList[i]))
			end
			if myCardList[i].num == 6 then
				table.insert(group6,this.GetGroupNum(myCardList[i]))
			end
			if myCardList[i].num == 7 then
				table.insert(group7,this.GetGroupNum(myCardList[i]))
			end
			if myCardList[i].num == 8 then
				table.insert(group8,this.GetGroupNum(myCardList[i]))
			end
			if myCardList[i].num == 9 then
				table.insert(group9,this.GetGroupNum(myCardList[i]))
			end
			if myCardList[i].num == 10 then
				table.insert(group10,this.GetGroupNum(myCardList[i]))
			end
			if myCardList[i].num == 11 then
				table.insert(group11,this.GetGroupNum(myCardList[i]))
			end
			if myCardList[i].num == 12 then
				table.insert(group12,this.GetGroupNum(myCardList[i]))
			end
		end
	end
	for i = 1, #group1 do
		table.insert(marr1, GetPlateNum(group1[i][1]))
	end
	for i = 1, #group2 do
		table.insert(marr2, GetPlateNum(group2[i][1]))
	end
	for i = 1, #group3 do
		table.insert(marr3, GetPlateNum(group3[i][1]))
	end
	for i = 1, #marr1 do
		table.insert(marrDaiPai,marr1[i])
		if marr1[i] ~= 15 then
			table.insert(marrChai1, marr1[i])
		end
	end
	for i = 1, #marr2 do
		table.insert(marrDaiPai,marr2[i])
		table.insert(marrChai2, marr2[i])
		if marr2[i] ~= 15 then
			table.insert(marrChai1, marr2[i])
		end
	end
	for i = 1, #marr3 do
		table.insert(marrDaiPai,marr3[i])
		table.insert(marrChai2, marr3[i])
		if marr3[i] ~= 15 then
			table.insert(marrChai1, marr3[i])
		end
	end
	table.sort(marrChai1)
	table.sort(marrChai2)
	local totalFeiJi = this.GetTotalDanLong(marr3,myCardList,3)
	local totalShunZi = this.GetTotalDanLong(marr1,myCardList,1)
	local totalShunZiChai = this.GetTotalDanLong(marrChai1,myCardList,1)
	local totalLianDui = this.GetTotalDanLong(marr2,myCardList,2)
	local totalLianDuiChai = this.GetTotalDanLong(marrChai2,myCardList,2)
	local boomTotal=this.GetBoom()
	if lasthand ~= nil and #lasthand.cards ~= 0 then
		print('跟牌。。。。。。。。。。。。')
		if lasthand.category == 6 then
			for i = 1, #boomTotal do
				if #lasthand.cards == #boomTotal[i] and GetPlateNum(lasthand.cards[1]) < GetPlateNum(boomTotal[i][1]) then
					table.insert(helpOutCards,boomTotal[i])
				end
				if #lasthand.cards < #boomTotal[i] then
					table.insert(helpOutCards,boomTotal[i])
				end
			end
		else
			if lasthand.category == 0 then--单张
				for i = 1, #group1 do
					if GetPlateNum(lasthand.cards[1]) < GetPlateNum(group1[i][1]) then
						table.insert(helpOutCards,group1[i])
					end
				end
				for i = 1, #group2 do
					if GetPlateNum(lasthand.cards[1]) < GetPlateNum(group2[i][1]) then
						table.insert(helpOutCards,{group2[i][1]})
					end
				end
				for i = 1, #group3 do
					if GetPlateNum(lasthand.cards[1]) < GetPlateNum(group3[i][1]) then
						table.insert(helpOutCards,{group3[i][1]})
					end
				end
			elseif lasthand.category == 1 then--对子
				for i = 1, #group2 do
					if GetPlateNum(lasthand.cards[1]) < GetPlateNum(group2[i][1]) then
						table.insert(helpOutCards,group2[i])
					end
				end
				for i = 1, #group3 do
					if GetPlateNum(lasthand.cards[1]) < GetPlateNum(group3[i][1]) then
						table.insert(helpOutCards,{group3[i][1],group3[i][2]})
					end
				end
			elseif lasthand.category == 2 then--连对
				for i = 1, #totalLianDui do
					if #lasthand.cards == #totalLianDui[i] then
						table.sort(lasthand.cards)
						table.sort(totalLianDui[i])
						if GetPlateNum(lasthand.cards[1]) < GetPlateNum(totalLianDui[i][1]) then
							table.insert(helpOutCards,totalLianDui[i])
						end
					end
				end
				for i = 1, #totalLianDuiChai do
					if #lasthand.cards == #totalLianDuiChai[i] then
						table.sort(lasthand.cards)
						table.sort(totalLianDuiChai[i])
						if GetPlateNum(lasthand.cards[1]) < GetPlateNum(totalLianDuiChai[i][1]) then
							local aa = totalLianDuiChai[i]
							local isRepeat = false
							for j = 1,#totalLianDui do
								table.sort(totalLianDui[j])
								local bb = totalLianDui[j]
								if GetPlateNum(aa[1]) == GetPlateNum(bb[1]) and GetPlateNum(aa[#aa]) == GetPlateNum(bb[#bb]) then
									isRepeat = true
									break
								end
							end
							if not isRepeat then
								table.insert(helpOutCards,totalLianDuiChai[i])
							end
						end
					end
				end
			elseif lasthand.category == 3 then--三个
				local sange = this.GetSanGeOrFeiJi(group3,marrDaiPai,myCardList,lasthand)
				for i = 1, #sange do
					table.insert(helpOutCards,sange[i])
				end
			elseif lasthand.category == 4 then--顺子
				for i = 1, #totalShunZi do
					if #lasthand.cards == #totalShunZi[i] then
						table.sort(lasthand.cards)
						table.sort(totalShunZi[i])
						if GetPlateNum(lasthand.cards[1]) < GetPlateNum(totalShunZi[i][1]) then
							table.insert(helpOutCards,totalShunZi[i])
						end
					end
				end
				for i = 1, #totalShunZiChai do
					if #lasthand.cards == #totalShunZiChai[i] then
						table.sort(lasthand.cards)
						table.sort(totalShunZiChai[i])
						if GetPlateNum(lasthand.cards[1]) < GetPlateNum(totalShunZiChai[i][1]) then
							local aa = totalShunZiChai[i]
							local isRepeat = false
							for j = 1,#totalShunZi do
								table.sort(totalShunZi[j])
								local bb = totalShunZi[j]
								if GetPlateNum(aa[1]) == GetPlateNum(bb[1]) and GetPlateNum(aa[#aa]) == GetPlateNum(bb[#bb]) then
									isRepeat = true
									break
								end
							end
							if not isRepeat then
								table.insert(helpOutCards,totalShunZiChai[i])
							end
						end
					end
				end
			elseif lasthand.category == 5 then--飞机
				local feiji = this.GetSanGeOrFeiJi(totalFeiJi,marrDaiPai,myCardList,lasthand)
				for i = 1, #feiji do
					table.insert(helpOutCards,feiji[i])
				end
			end
			for i = 1, #boomTotal do
				table.insert(helpOutCards,boomTotal[i])
			end
		end
	else
		print('先手出牌。。。。。。。。。。。。')
		--飞机
		local feiji = this.GetSanGeOrFeiJi(totalFeiJi,marrDaiPai,myCardList)
		for i = 1, #feiji do
			table.insert(helpOutCards,feiji[i])
		end 
		print('飞机 :'..#feiji)
		--三张
		local sange = this.GetSanGeOrFeiJi(group3,marrDaiPai,myCardList)
		for i = 1, #sange do
			table.insert(helpOutCards,sange[i])
		end 
		print('三张个数 :'..#sange)
		--顺子
		for i = 1, #totalShunZiChai do
			if #totalShunZiChai[i] > 4 and i == #totalShunZiChai then
				table.insert(helpOutCards,totalShunZiChai[i])
			end
		end
		--连对
		for i = 1, #totalLianDui do
			table.insert(helpOutCards,totalLianDui[i])
		end
		for i = 1, #totalLianDuiChai do
			table.sort(totalLianDuiChai[i])
			local aa = totalLianDuiChai[i]
			if #aa == #totalLianDuiChai[#totalLianDuiChai] then
				local isRepeat = false
				for j = 1,#totalLianDui do
					table.sort(totalLianDui[j])
					local bb = totalLianDui[j]
					if GetPlateNum(aa[1]) == GetPlateNum(bb[1]) and GetPlateNum(aa[#aa]) == GetPlateNum(bb[#bb]) then
						isRepeat = true
						break
					end
				end
				if not isRepeat then
					table.insert(helpOutCards,totalLianDuiChai[i])
				end
			end
		end
		--对子
		for i = 1, #group2 do
			table.insert(helpOutCards,group2[i])
		end
		if #group2 == 0 then
			for i = 1, #group3 do
				table.insert(helpOutCards,{group3[i][1],group3[i][2]})
			end
		end
		print('对子 :'..#group2)
		--单张
		for i = 1, #group1 do
			table.insert(helpOutCards,group1[i])
		end
		if #group1 == 0 then
			for i = 1, #group2 do
				table.insert(helpOutCards,{group2[i][1]})
			end
			for i = 1, #group3 do
				table.insert(helpOutCards,{group3[i][1]})
			end
		end
		print('单张 :'..#group1)
		--炸弹
		for i = 1, #boomTotal do
			table.insert(helpOutCards,boomTotal[i])
		end
		print('炸弹 :'..#boomTotal)
	end
	print('提示牌长度 :'..#helpOutCards)
	return helpOutCards
end
function this.GetGroupNum(data)
	local tab = {}
	for i = 1, #data.trueValues do
		table.insert(tab,data.trueValues[i])
	end
	return tab
end
function this.GetBoom()
	local boomTotal = {}
	for i = 1, #group4 do
		table.insert(boomTotal,group4[i])
	end
	for i = 1, #group5 do
		table.insert(boomTotal,group5[i])
	end
	for i = 1, #group6 do
		table.insert(boomTotal,group6[i])
	end
	for i = 1, #group7 do
		table.insert(boomTotal,group7[i])
	end
	for i = 1, #group8 do
		table.insert(boomTotal,group8[i])
	end
	for i = 1, #group9 do
		table.insert(boomTotal,group9[i])
	end
	for i = 1, #group10 do
		table.insert(boomTotal,group10[i])
	end
	for i = 1, #group11 do
		table.insert(boomTotal,group11[i])
	end
	for i = 1, #group12 do
		table.insert(boomTotal,group12[i])
	end
	return boomTotal
end
function this.GetTotalDanLong(marr,tempMyCard,num)
	local danlong ={}
	--2顺
	for i = 2, #marr do
		for j = 1, #marr - 1 do
			if marr[i] - marr[j] == 1 then
				local danlong2 = {}
				danlong2 = this.GetDanLong(marr,tempMyCard,j,i,num)
				table.insert(danlong,danlong2)
			end
		end
	end
	--3顺
	for i = 3, #marr do
		for j = 1, #marr - 2 do
			if marr[i] - marr[j] == 2 then
				if marr[i] - marr[j+1] == 1 then
					local danlong3 = {}
					danlong3 = this.GetDanLong(marr,tempMyCard,j,i,num)
					table.insert(danlong,danlong3)
				end
			end
		end
	end
	--4顺
	for i = 4, #marr do
		for j = 1, #marr - 3 do
			if marr[i] - marr[j] == 3 then
				if marr[i] - marr[j+1] == 2 
				and marr[i] - marr[j+2] == 1 then
					local danlong4 = {}
					danlong4 = this.GetDanLong(marr,tempMyCard,j,i,num)
					table.insert(danlong,danlong4)
				end
			end
		end
	end	
	--5顺
	for i = 5, #marr do
		for j = 1, #marr - 4 do
			if marr[i] - marr[j] == 4 then
				if marr[i] - marr[j+1] == 3 
				and marr[i] - marr[j+2] == 2 
				and marr[i] - marr[j+3] == 1 then
					local danlong5 = {}
					danlong5 = this.GetDanLong(marr,tempMyCard,j,i,num)
					table.insert(danlong,danlong5)
				end
			end
		end
	end	
	--6顺
	for i = 6, #marr do
		for j = 1, #marr - 5 do
			if marr[i] - marr[j] == 5 then
				if  marr[i] - marr[j+1] == 4 
				and marr[i] - marr[j+2] == 3 
				and marr[i] - marr[j+3] == 2 
				and marr[i] - marr[j+4] == 1 then
					local danlong6 = {}
					danlong6 = this.GetDanLong(marr,tempMyCard,j,i,num)
					table.insert(danlong,danlong6)
				end
			end
		end
	end	
	--7顺
	for i = 7, #marr do
		for j = 1, #marr - 6 do
			if marr[i] - marr[j] == 6 then
				if  marr[i] - marr[j+1] == 5 
				and marr[i] - marr[j+2] == 4 
				and marr[i] - marr[j+3] == 3
				and marr[i] - marr[j+4] == 2
				and marr[i] - marr[j+5] == 1 then
					local danlong7 = {}
					danlong7 = this.GetDanLong(marr,tempMyCard,j,i,num)
					table.insert(danlong,danlong7)
				end
			end
		end
	end
	--8顺
	for i = 8, #marr do
		for j = 1, #marr - 7 do
			if marr[i] - marr[j] == 7 then
				if  marr[i] - marr[j+1] == 6 
				and marr[i] - marr[j+2] == 5 
				and marr[i] - marr[j+3] == 4
				and marr[i] - marr[j+4] == 3
				and marr[i] - marr[j+5] == 2
				and marr[i] - marr[j+6] == 1 then
					local danlong8 = {}
					danlong8 = this.GetDanLong(marr,tempMyCard,j,i,num)
					table.insert(danlong,danlong8)
				end
			end
		end
	end	
	--9顺
	for i = 9, #marr do
		for j = 1, #marr - 8 do
			if marr[i] - marr[j] == 8 then
				if  marr[i] - marr[j+1] == 7
				and marr[i] - marr[j+2] == 6 
				and marr[i] - marr[j+3] == 5
				and marr[i] - marr[j+4] == 4
				and marr[i] - marr[j+5] == 3
				and marr[i] - marr[j+6] == 2
				and marr[i] - marr[j+7] == 1 then
					local danlong9 = {}
					danlong9 = this.GetDanLong(marr,tempMyCard,j,i,num)
					table.insert(danlong,danlong9)
				end
			end
		end
	end	
	--10顺
	for i = 10, #marr do
		for j = 1, #marr - 9 do
			if marr[i] - marr[j] == 9 then
				if  marr[i] - marr[j+1] == 8 
				and marr[i] - marr[j+2] == 7 
				and marr[i] - marr[j+3] == 6
				and marr[i] - marr[j+4] == 5
				and marr[i] - marr[j+5] == 4
				and marr[i] - marr[j+6] == 3
				and marr[i] - marr[j+7] == 2
				and marr[i] - marr[j+8] == 1 then
					local danlong10 = {}
					danlong10 = this.GetDanLong(marr,tempMyCard,j,i,num)
					table.insert(danlong,danlong10)
				end
			end
		end
	end	
	--11顺
	for i = 11, #marr do
		for j = 1, #marr - 10 do
			if marr[i] - marr[j] == 10 then
				if  marr[i] - marr[j+1] == 9 
				and marr[i] - marr[j+2] == 8 
				and marr[i] - marr[j+3] == 7
				and marr[i] - marr[j+4] == 6
				and marr[i] - marr[j+5] == 5
				and marr[i] - marr[j+6] == 4
				and marr[i] - marr[j+7] == 3
				and marr[i] - marr[j+8] == 2
				and marr[i] - marr[j+9] == 1 then
					local danlong11 = {}
					danlong11 = this.GetDanLong(marr,tempMyCard,j,i,num)
					table.insert(danlong,danlong11)
				end
			end
		end
	end
	return danlong
end
function this.GetDanLong(marr,tempMyCard,min,max,num)
	local danlong = {}
	for i = marr[min], marr[max] do
		for j = 1, num do
			table.insert(danlong,tempMyCard[i].trueValues[j])
		end
	end
	return danlong
end
function this.GetSanGeOrFeiJi(sanGeOrFeiJi,marrDaiPai,myCardList,lasthand)
	local helpCards = {}
	local totalNum = 0
	for i = 1, #group3 do
		totalNum = totalNum + #group3[i]
	end
	print('totalNum :'..totalNum)
	for i = 1, #sanGeOrFeiJi do
		local data = {}
		if lasthand ~= nil then
			table.sort(sanGeOrFeiJi[i])
			if lasthand.keyCardCount == (#sanGeOrFeiJi[i]) and lasthand.minKeyRank < (getIntPart(sanGeOrFeiJi[i][1]/4)) then
				data = sanGeOrFeiJi[i]
			end
		else
			data = sanGeOrFeiJi[i]
		end
		local daiPaiData = this.fenXiCard(data)
		local daiPaiNum = 2*(#data)/3
		local daiPaiTotalNum = #group1 + #group2*2 + totalNum - #data
		print('daiPaiNum : '..daiPaiNum..' daiPaiTotalNum : '..daiPaiTotalNum)
		if daiPaiTotalNum >= daiPaiNum then
			local feiji = {}
			for j = 1, #data do
				table.insert(feiji,data[j])
			end
			for k = 1, #marrDaiPai do
				print('marrDaiPai value: '..marrDaiPai[k])
				if myCardList[marrDaiPai[k]] then
					local aa = myCardList[marrDaiPai[k]]
					if #data ~= 0 and daiPaiData[marrDaiPai[k]] == nil then
						for l = 1, aa.num do
							table.insert(feiji,aa.trueValues[l])
							if #data ~= 0 and #feiji == #data + daiPaiNum then
								table.insert(helpCards,feiji)
								break
							end
						end
					end
					if #data ~= 0 and #feiji == #data + daiPaiNum then
						break
					end	
				end
			end
			print('feiji: '..#feiji)
			print('marrDaiPai: '..#marrDaiPai)
		end
	end
	return helpCards
end
--获得提示牌end
--点击牌
function this.OnClickCard(go)
	print('OnClickCard..............')
	AudioManager.Instance:PlayAudio('touchcard')
	local myCardList = this.fenXiCard(playerData[mySeat].cards) 
	for i = 5, 15 do
		if myCardList[i] then
			if GetPlateNum(GetUserData(go)) == myCardList[i].value and myCardList[i].num >3 then
				for j = 0, go.transform.parent.childCount - 1 do
					if go.transform.parent:GetChild(j).gameObject.activeSelf and go.transform.parent:GetChild(j).gameObject ~= go then
						go.transform.parent:GetChild(j):Find('mask').gameObject:SetActive(not go.transform.parent:GetChild(j):Find('mask').gameObject.activeSelf)
					end
				end
			end
		end
	end
	go.transform:Find('mask').gameObject:SetActive(not go.transform:Find('mask').gameObject.activeSelf)
end
function this.OnMousePressHoverCard(go)
	this.OnClickCard(go)
end
function this.OnClickBG(go)
	for i=0,groupInCardGrid.childCount-1 do 
		local cardGrid = groupInCardGrid:GetChild(i):Find('cardGrid')
		for j=0,cardGrid.childCount-1 do
			cardGrid:GetChild(j):Find('mask').gameObject:SetActive(false)
		end
	end
end
--点击牌end

function this.OnClicButtonCloseRoom(go)
	print('OnClicButtonCloseRoom...............................')
	AudioManager.Instance:PlayAudio('btn')
	if mySeat == 0 then
		print("申请解散房间")
		AudioManager.Instance:PlayAudio('btn')
		local msg = Message.New()
		msg.type = yjqf_pb.DISSOLVE
		local body = yjqf_pb.PDissolve()
		body.decision = yjqf_pb.APPLY
		msg.body = body:SerializeToString()
		SendGameMessage(msg, nil)
	else
		print("离开房间")
		AudioManager.Instance:PlayAudio('btn')
		local msg = Message.New()
		msg.type = yjqf_pb.LEAVE_ROOM
		SendGameMessage(msg, nil)
	end
	this.fanHuiRoomNumber = nil
end

function this.OnClicButtonLeaveRoom(go)
	print('OnClicButtonLeaveRoom ...............')
	AudioManager.Instance:PlayAudio('btn')
    if roomData.clubId == '0' then
		print('不在在牌友群中')
		PanelManager.Instance:HideWindow(gameObject.name)
        PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
        panelMessageTip.SetParamers('返回大厅后，您的房间将会继续保留哦', 1)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	else
		print('在牌友群中')
		PanelManager.Instance:HideWindow(gameObject.name)
        PanelManager.Instance:ShowWindow('panelClub',{name = gameObject.name})
        panelMessageTip.SetParamers('返回俱乐部后，您的房间将会继续保留哦', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
    end
end

function this.OnClickPlayerIcon(go)
	AudioManager.Instance:PlayAudio('btn')
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
	userData.gameType = proxy_pb.YJQF
	userData.signature = pData.signature
	userData.sendMsgAllowed = true
    userData.fee = pData.fee
	userData.isShowSomeID = false
	userData.gameMode = roomData.setting.gameMode
    PanelManager.Instance:ShowWindow('panelPlayerInfo', userData)
end

--语音
function this.TickNGCloudVoice()
	--加入房间语音
    while gameObject.activeSelf do
        NGCloudVoice.Instance:Poll()
        coroutine.wait(0.03)
    end
end
function this.OnPressButtonSound(go, state)
	print('roomData.setting.sendVoiceAllowed : '..tostring(roomData.setting.sendVoiceAllowed))
	if roomData.setting.sendVoiceAllowed then
		if state == true then
			this.startTalk()
		else
			local mousePositionY = UnityEngine.Input.mousePosition.y
			local buttonY = UnityEngine.Screen.height / 2 + (go.transform.position.y * UnityEngine.Screen.height / 750)
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
function this.startTalk()
    isPress = true
    isUpload = false
    player[0].playerSound.gameObject:SetActive(false)
    --当还没播放完录音时，按住录音。。。。。。
    NGCloudVoice.Instance:Click_btnStopPlayRecordFile()
    --停止播放背景音乐
    AudioManager.Instance.AudioOn = false
    AudioManager.Instance.MusicOn = false
	RecordTiShi.gameObject:SetActive(true)
	--延迟0.5秒，因为不延迟会把最后一点背景声音录进去
	StartCoroutine(this.StartRecord)
end
function this.stopTalk(needUploadFile)
    isPress = false
    --继续播放背景音乐
    AudioManager.Instance.AudioOn = UnityEngine.PlayerPrefs.GetInt('audio_on', 1) == 1
    AudioManager.Instance.MusicOn = UnityEngine.PlayerPrefs.GetInt('music_on', 1) == 1
	RecordTiShi.gameObject:SetActive(false)
	NGCloudVoice.Instance:Click_btnStopRecord()
	--超过0.5秒才上传播放录音
	if isUpload == true and needUploadFile == true then
		NGCloudVoice.Instance:Click_btnUploadFile()
		print("这里开始上传录制完后的语音！！！！！！")
	end
end
function this.StartRecord()
    WaitForSeconds(0)
    --当按住录音按钮超过0.5秒时才执行录音，因为多次短时间录的文件不会被下一次覆盖
    if isPress == true then
        isUpload = true
        print("这里开始录制语音！！！！！！")
        NGCloudVoice.Instance:Click_btnStartRecord()
    end
end
function this.UploadReccordFileComplete(fileid)
    print('发送给服务器' .. fileid)
    local msg = Message.New()
    msg.type = yjqf_pb.VOICE_MEMBER
    local body = yjqf_pb.PVoiceMember()
    body.voiceId = fileid
    msg.body = body:SerializeToString()
    SendGameMessage(msg, nil)
end
function this.DownloadRecordFileComplete(fileid)
    print('下载完成' .. fileid);
    --停止播放背景音乐
    AudioManager.Instance.AudioOn = false
	AudioManager.Instance.MusicOn = false
	for i = 0, #playerData do
		player[i].playerSound.gameObject:SetActive(this.GetPlayerDataByUIIndex(i).voiceId == fileid)
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
            player[i].playerSound.gameObject:SetActive(false)
        end
    end
end
function this.ShieldVoiceEvent()
	-- 屏蔽其他玩家实时语音状态
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
	local b = yjqf_pb.RVoiceMember()
	b:ParseFromString(msg.body)
	local pla = playerData[b.seat]
	if pla then
		pla.voiceId = b.voiceId
        NGCloudVoice.Instance:Click_btnDownloadFile(pla.voiceId)
	else
		print('无法通过座位号 ' .. b.seat .. ' 获取到用户信息')
	end
end
--语音end

--聊天
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
function this.OnSendChat(msg)
	print('OnSendChat ................')
    local b = yjqf_pb.RChat()
    b:ParseFromString(msg.body)
	local index = this.GetUIIndexBySeat(b.seat)
    if b.type == 0 then --图片
        this.showEmoji(index, b.position)
    elseif b.type == 1 then -- 语音文本
		local p = playerData[b.seat]
		AudioManager.Instance:PlayAudio(string.format('chat_%d_%d', p.sex, b.position))
        this.showText(index, b.text)
    else --纯文本
        this.showText(index, b.text)
        local p = playerData[b.seat]
        if panelChat then
            panelChat.AddChatToLabel(p.name .. ':' .. b.text)
        else
            table.insert(this.chatTexts, p.name .. ':' .. b.text)
        end
    end
end
function this.showText(seat, text)
	coroutine.stop(playerCoroutine[seat])
	playerCoroutine[seat] = coroutine.start(function()
		player[seat].playerMsgLabel.parent.gameObject:SetActive(true)
		player[seat].playerMsgLabel:GetComponent('UILabel').text = text
		player[seat].playerMsgLabel:GetComponent('UILabel').color = Color(244/255,244/255,244/255)
		player[seat].playerEmoji.gameObject:SetActive(false)
		coroutine.wait(5)
		player[seat].playerMsgLabel.parent.gameObject:SetActive(false)
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
	player[seat].playerMsgLabel.parent.gameObject:SetActive(false)
	player[seat].playerEmoji.gameObject:SetActive(true)
	coroutine.stop(playerCoroutine[seat])
	playerCoroutine[seat] = coroutine.start(function()
		for i = 1, 30 do
			player[seat].playerEmoji:GetComponent('UISprite').spriteName = str .. '_' .. (i % myTable[str] + 1)
			coroutine.wait(0.1)
		end
		player[seat].playerEmoji.gameObject:SetActive(false)
	end)
end
--聊天end

--特殊表情
function this.OnPlayerEmoji(msg)
	print('OnPlayerEmoji ................')
	local b = yjqf_pb.RGift()
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
			PanelManager.Instance:HideWindow('panelPlayerInfo');
			local positionFrom = player[this.GetUIIndexBySeat(b.seat)].playerIcon.position
			local positionTo = player[this.GetUIIndexBySeat(b.rseat)].playerIcon.position
			local animation = player[this.GetUIIndexBySeat(b.seat)].playerAnimation

			animation.gameObject:GetComponent('UISprite').spriteName 		= name
			animation.gameObject:GetComponent('UISprite'):MakePixelPerfect()
			animation.gameObject:GetComponent('TweenPosition').worldSpace 	= true
			animation.gameObject:GetComponent('TweenPosition').from 		= positionFrom
			animation.gameObject:GetComponent('TweenPosition').to 			= positionTo
			animation.gameObject:GetComponent('TweenPosition').duration 	= 1
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
			player[myseatinx].playerAnimation:GetComponent('UISprite').spriteName = name..'_'..i
			player[myseatinx].playerAnimation.gameObject:GetComponent('UISprite'):MakePixelPerfect()
			coroutine.wait(time)
		end
		player[myseatinx].playerAnimation.gameObject:SetActive(false)
	end)
end
--特殊表情end

--邀请分享
function this.ShowPanelShare(go)
    panelShare.gameObject:SetActive(true)
end
function this.ClosePanelShare(go)
    panelShare.gameObject:SetActive(false)
end
function this.OnClickButtonInvite(go)
	print('OnClickButtonInvite ................')
	local msg  =""
	msg = msg..getYJQFRuleString(roomData.setting)
	msg = msg.."房已开好,就等你来！"
	local que = roomData.setting.size - (#playerData+1)
	local title = roomInfo.roomNumber.."房,"..roomData.playName..roomData.setting.size.."缺"..que	
	PlatformManager.Instance:ShareLink('http://'..panelLogin.HttpUrl..'/shareRoom.html?appType=1&state=' ..proxy_pb.YJQF..roomInfo.roomNumber, title, msg, 0)
end
function this.OnClicButtonCopy(go)
	print('OnClicButtonCopy ................')
    local msg = '房号:' .. roomInfo.roomNumber
	msg = msg .."," .."沅江千分,"..getYJQFRuleString(roomData.setting)
	print("复制的信息",msg)
    Util.CopyToSystemClipbrd(msg)
    panelMessageTip.SetParamers('复制成功', 1.5)
    PanelManager.Instance:ShowWindow('panelMessageTip')
end
--邀请分享end

--离线
function this.StartOfflineIncrease(seat, startTime)
	this.StopOfflineIncrease(seat)
	--print('------------------有人离线，开始离线计时'..(seat)..'----------------------')
	local offlineTime = player[this.GetUIIndexBySeat(seat)].playerOfflineTime
	playerOfflineCoroutines[this.GetUIIndexBySeat(seat)] = coroutine.start(this.OfflineIncrease, offlineTime, startTime)
end
function this.StopOfflineIncrease(seat)
	local coroutines = playerOfflineCoroutines[this.GetUIIndexBySeat(seat)]

	if coroutines ~= nil then
		coroutine.stop(coroutines)
		coroutines = nil;
		--print('------------------取消离线倒计时'..(seat)..'----------------------')
	end
	player[this.GetUIIndexBySeat(seat)].playerOfflineTime.gameObject:SetActive(false)
end
function this.OfflineIncrease(timeObj, startTime)
	--print('OfflineIncrease .......................')
	local timeLabel = timeObj.transform:Find('Time'):GetComponent('UILabel');
	timeLabel.text = os.date("%M:%S", startTime);
	timeObj.gameObject:SetActive(true)
	while true do
		coroutine.wait(1)
		startTime = startTime + 1 
		timeLabel.text = os.date("%M:%S", startTime)
	end
end
function this.StopAllOfflineIncrease()
	for i = 0, #playerOfflineCoroutines do
		--print('-------------Mark----------', i)
		local coroutines =  playerOfflineCoroutines[i]
		if coroutines ~= nil then
			coroutine.stop(coroutines)
			coroutines = nil
		end
	end
end
--离线end

--托管
function this.OnTrustesship(msg)
    local body = yjqf_pb.RTrusteeship()
    body:ParseFromString(msg.body)
	print('OnTrustesship ....托管的位置：'..tostring(body.seat)..' 托管是否开启：'..tostring(body.enable))
	player[this.GetUIIndexBySeat(body.seat)].playerTrusteeship.gameObject:SetActive(body.enable)
	roomData.trusteeshipRemainMs = -1;--这里赋值为-1，然后再ShowWaitOpreatEffect就会启用配置的时间
	if body.seat == mySeat then
		TrusteeshipTip.gameObject:SetActive(false)
		TrusteeshipPanel.gameObject:SetActive(body.enable)
		isMySelfTrusteeship=true
	end
    playerData[body.seat].trusteeship = body.enable
end

function this.OnClickCancelTrustesship(go)
	print('OnClickCancelTrustesship ................')
	local msg = Message.New()
	msg.type = yjqf_pb.TRUSTEESHIP
	local body = yjqf_pb.PTrusteeship()
	body.enable = false
	msg.body = body:SerializeToString()
	TrusteeshipTip.gameObject:SetActive(false)
	TrusteeshipPanel.gameObject:SetActive(false)
	isMySelfTrusteeship=false
	msg.body = body:SerializeToString()
	SendGameMessage(msg)
end

function this.SetDelegateCount(seat)
    this.StopTrustesship()
    trusteeshipcor = coroutine.start(
            function()
                local trusteeshipTime = -1
                if getIntPart(roomData.trusteeshipRemainMs / 1000) >0 then
                    trusteeshipTime = getIntPart(roomData.trusteeshipRemainMs / 1000)
                    roomData.trusteeshipRemainMs = roomData.setting.trusteeship
                else
                    trusteeshipTime = roomData.setting.trusteeship
				end
                if playerData[seat] ~= nil and playerData[seat].trusteeship then--如果处于托管中，那么时间置为0
                    trusteeshipTime = 0;
					if seat == mySeat then
						TrusteeshipPanel.gameObject:SetActive(true)
						TrusteeshipTip.gameObject:SetActive(false)
                    end
                end
                while trusteeshipTime >= 0 and (not offlineState) do
                    --进入托管
                    if trusteeshipTime <= 10 and not TrusteeshipPanel.gameObject.activeSelf then
						if seat == mySeat then
                            TrusteeshipTip.gameObject:SetActive(true)
                            TrusteeshipTip:Find("Time"):GetComponent("UILabel").text = trusteeshipTime
                        end
						if trusteeshipTime <= 0 then
							TrusteeshipTip.gameObject:SetActive(false)
                        end
					else
                        TrusteeshipTip.gameObject:SetActive(false)
					end
					coroutine.wait(1)
                    trusteeshipTime = trusteeshipTime -1
				end
            end
    );
end

function this.StopTrustesship()
    coroutine.stop(trusteeshipcor)
    trusteeshipcor = nil
    TrusteeshipTip.gameObject:SetActive(false)
end
--托管end