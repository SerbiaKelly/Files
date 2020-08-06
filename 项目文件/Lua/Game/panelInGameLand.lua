local phz_pb = require 'phz_pb'
local json = require 'json'

panelInGameLand = {}
local this = panelInGameLand
local gameObject
local message

this.fanHuiRoomNumber = nil
this.OnRoundStarted = nil
this.needCheckNet=true

local roomRound
local roomID
local roomTime
local batteryLevel
local network
local pingLabel
local roomSetting
local line
local chupaishoushi --提示出牌手势
local operation_send
local operation_receive
local dipai
local curOperatPlateEffect
local moOperatPlateEffect
local curPais

local playerName = {}
local playerIcon = {}
local playerScore = {}
local playerMaster = {}
local playerSound = {}
local playerKongWei = {}
local playerOffline = {}
local playerGridXi = {}
local playerThrow = {}
local playerReady = {}
local playerClock = {}
local playerXiNum = {}
local playerOperationEffectPos = {}
local playerMoPaiPos = {}
local playerRoundScore = {}
local playerGridStageClear = {}
local playerGridXiLabel = {}
local playerSiShou = {}--死手
--local TingPaiListGO={}
local allCards = {}
local playerNiao = {}
local playerPiao = {}
local playerTuo = {}
local playerTrusteeship = {}
local playerTrusteeshipTime = {}
local playerOfflineTime={}
local playerOfflineCoroutines={}
local playerAnimation		= {}
local playerLianZhuang={}
local playerWarn={}
local playerAddScoreLabel={}
local playerGridHand
local playerDi
local xingPlate

local ButtonSetting
local ButtonChat
local ButtonSound
local ButtonCloseRoom
local ButtonExitRoom
local ButtonNext
local ButtonRefresh

local ButtonHu
local ButtonPao
local ButtonPeng
local ButtonChi
local ButtonGuo
local ButtonTi
local ButtonWei
local ButtonTing
local tingGrid              --听牌底框
local prefabTing            --要听的牌

local kuang01 = {}
local lanBG
local lvBG
local mesh_lan
local mesh_cheng
local playerMsg = {}
local playerMsgBG = {}
local playerEmoji = {}
local playerCoroutine = {}
playerCoroutine[0] = {}
playerCoroutine[1] = {}
playerCoroutine[2] = {}

local playerEmojiCoroutine = {}
playerEmojiCoroutine[0] = {}
playerEmojiCoroutine[1] = {}
playerEmojiCoroutine[2] = {}
playerEmojiCoroutine[3] = {}

local playerData = {}
roomData = roomData and roomData or {}
local mySeat = -1
local needChuPai = false
local paiAnimations = {}
local needChuPaiBefroeHu = false
local dragObj
local isShowPanelChiPai = false

local DelegateTime;--委托时间
local DelegatePanel;--委托面板

lastOperat = {}
ROperationChiData = nil

local selectCards = {}
local connect
local isWhoShowEvent = false
function this.GetNetState()
	return connect.IsConnect
end
local connectCor
local voiceCor
local stageClearCor
this.chatTexts = {}

local GPS = {
	transform=nil,
	distance={},
	playerGPS={},
}

local RestTime
local IsRefreshTime = false

local RecordTiShi--录音提示
local allPlates = {}--桌面所有出现的牌的值记录
local myTingPlates--自己的听牌数据

local ButtonInvite--邀请按钮
local panelShare--分享界面

local PlayNiaoView
local NotNiao
local PlayNiao

local PlayTuoView
local NotTuo
local PlayTuo

local playPiaoView

local IsAutoDissolve = false
local AutoDissolveData
local trusteeshipcor = nil;
local offlineState = false;

local conCountDown
local remainTime

this.myseflDissolveTimes = 0

local chouPlates = {}
function this.Awake(obj)
    gameObject = obj
    this.gameObject = obj
    message = gameObject:GetComponent('LuaBehaviour');
    RestTime = gameObject.transform:Find("RestTime")
    roomID = gameObject.transform:Find('state/room/ID');
    roomTime = gameObject.transform:Find('state/time');
    roomRound = gameObject.transform:Find('state/round/num');
    roomSetting = gameObject.transform:Find('setting')
    line = gameObject.transform:Find('line')
    chupaishoushi = gameObject.transform:Find('chupaishoushi')
    operation_send = gameObject.transform:Find('operation_send')
    operation_receive = gameObject.transform:Find('operation_receive')
    dipai = gameObject.transform:Find('DiPai')
    curOperatPlateEffect = gameObject.transform:Find('curOperatPlateEffect')
    moOperatPlateEffect = gameObject.transform:Find('moOperatPlateEffect')
    curPais = gameObject.transform:Find('curPais')
    for i = 0, 3 do
        local playerIcon = gameObject.transform:Find('Container/player' .. i .. '/Texture')
        kuang01[i] = gameObject.transform:Find('Container/player' .. i .. '/kuang01')
        message:AddClick(playerIcon.gameObject, this.OnClickPlayerIcon)
        playerAnimation[i] 	= gameObject.transform:Find('teshubiaoqing/'..i);
        if i == 0 then
            playerGridHand = gameObject.transform:Find('Container/player' .. i .. '/GridHand')
            playerDi = gameObject.transform:Find('Container/player' .. i .. '/TableDi')
        end
    end
    GPS.transform = gameObject.transform:Find('GPS')
    local dis = GPS.transform:Find('distances')
    for i = 0, dis.childCount-1 do
        local len = {}
        len.transform = dis.transform:Find('distance'..i)
        len.length = dis.transform:Find('distance'..i..'/Label')
        GPS.distance[i] = len
    end
	this.AwakeExtra()
end

--=============Awake中已使用超过60外部变量，后面要使用新变量请添加在些
function this.AwakeExtra()
    DelegateTime = gameObject.transform:Find("TrusteeshipTip")
    DelegatePanel = gameObject.transform:Find("TrusteeshipPanel")

    RecordTiShi = gameObject.transform:Find('RecordTiShi')
    lanBG = gameObject.transform:Find('lan');
    lvBG = gameObject.transform:Find('Bg');
    ButtonSetting = gameObject.transform:Find('btn/ButtonSetting')
    ButtonRefresh = gameObject.transform:Find('btn/ButtonRefresh')
    ButtonChat = gameObject.transform:Find('Container/ButtonChat')
    ButtonSound = gameObject.transform:Find('Container/ButtonSound')
    --邀请，解散，返回按钮
    ButtonInvite = gameObject.transform:Find('bottomButtons/ButtonInvite')

    panelShare = gameObject.transform:Find('panelShare')

    ButtonCloseRoom = gameObject.transform:Find('bottomButtons/ButtonCloseRoom')
    ButtonExitRoom = gameObject.transform:Find('bottomButtons/ButtonExitRoom')
    ButtonNext = gameObject.transform:Find('ButtonNext')

    ButtonHu = operation_send:Find('ButtonHu')
    ButtonPao = operation_send:Find('ButtonPao')
    ButtonPeng = operation_send:Find('ButtonPeng')
    ButtonChi = operation_send:Find('ButtonChi')
    ButtonGuo = operation_send:Find('ButtonGuo')
    ButtonTi = operation_send:Find('ButtonTi')
    ButtonWei = operation_send:Find('ButtonWei')
    ButtonTing = gameObject.transform:Find('ButtonTing')
    tingGrid = ButtonTing:Find('di')                                    --听牌底框
    prefabTing = ButtonTing:Find('card')                                --要听的牌
    PlayNiaoView = gameObject.transform:Find('PlayNiaoView')
    PlayNiao = PlayNiaoView.transform:Find('PlayNiao')
    NotNiao = PlayNiaoView.transform:Find('NotNiao')
    playPiaoView = gameObject.transform:Find('piaofendlg')
    PlayTuoView = gameObject.transform:Find('PlayTuoView')
    NotTuo = PlayTuoView.transform:Find('NotTuo')
    PlayTuo = PlayTuoView.transform:Find('PlayTuo')
    batteryLevel = gameObject.transform:Find('state/battery/level'):GetComponent('UISprite')
    network = gameObject.transform:Find('state/network'):GetComponent('UISprite')
    pingLabel = gameObject.transform:Find('ping'):GetComponent('UILabel')

    this.BindEvent()

    message:AddPress(network.gameObject,
            function(go, state)
                pingLabel.gameObject:SetActive(state)
            end
    )
    if IsAppleReview() then
        ButtonInvite.gameObject:SetActive(false)
        ButtonSound.gameObject:SetActive(false)
    end

    if isShapedScreen  then
        local widget = gameObject.transform:Find('Container'):GetComponent('UIWidget')
        widget.leftAnchor.absolute = ipxLiuHai
        widget.rightAnchor.absolute = -ipxLiuHai
    end
	xingPlate = gameObject.transform:Find('xingPlate')
end
function this.GetPlayerUI(playerNum, isInit)
    --print('GetPlayerUI')
    playerNum = playerNum and playerNum or 4
    for i = 0, 3 do
        local index = i
        if playerNum == 2 then
            if i == 1 then
                index = 2
            elseif i == 2 then
                index = 1
            elseif i == 3 then
                index = 3
            end
        elseif playerNum == 4 then
            if i == 1 then
                index = 1
            elseif i == 2 then
                index = 3
            elseif i == 3 then
                index = 2
            end
        end
        playerName[i] = gameObject.transform:Find('Container/player' .. index .. '/name')
        playerIcon[i] = gameObject.transform:Find('Container/player' .. index .. '/Texture')
        playerScore[i] = gameObject.transform:Find('Container/player' .. index .. '/score')
        playerMaster[i] = gameObject.transform:Find('Container/player' .. index .. '/master')
        playerSound[i] = gameObject.transform:Find('Container/player' .. index .. '/sound')
        playerKongWei[i] = gameObject.transform:Find('Container/player' .. index .. '/kongwei')
        playerOffline[i] = gameObject.transform:Find('Container/player' .. index .. '/offline')
        playerThrow[i] = gameObject.transform:Find('Container/player' .. index .. '/TabelThrow')
        playerGridXi[i] = gameObject.transform:Find('Container/player' .. index .. '/GridXi')
        playerReady[i] = gameObject.transform:Find('Container/player' .. index .. '/ready')
        playerClock[i] = gameObject.transform:Find('Container/player' .. index .. '/Clock')
        playerMsg[i] = gameObject.transform:Find('Container/player' .. index .. '/Msg')
        playerMsgBG[i] = gameObject.transform:Find('Container/player' .. index .. '/Msg/MsgBG')
        playerEmoji[i] = gameObject.transform:Find('Container/player' .. index .. '/Emoji')
        playerXiNum[i] = gameObject.transform:Find('Container/player' .. index .. '/xiNum')
        playerOperationEffectPos[i] = gameObject.transform:Find('Container/player' .. index .. '/operation_pos')
        playerMoPaiPos[i] = gameObject.transform:Find('Container/player' .. index .. '/mopai_pos')
        playerRoundScore[i] = gameObject.transform:Find('Container/player' .. index .. '/score_round')
        playerGridStageClear[i] = gameObject.transform:Find('Container/player' .. index .. '/GridStageClear')
        playerGridXiLabel[i] = gameObject.transform:Find('Container/player' .. index .. '/GridXiLabel')
        playerSiShou[i] = gameObject.transform:Find('Container/player' .. index .. '/siShou')
        playerNiao[i] = gameObject.transform:Find('Container/player' .. index .. '/Niao')
        playerPiao[i] = gameObject.transform:Find('Container/player' .. index .. '/piaofen')
        playerTuo[i] = gameObject.transform:Find('Container/player' .. index .. '/Tuo')
        kuang01[i] = gameObject.transform:Find('Container/player' .. index .. '/kuang01')
        playerTrusteeship[i] = gameObject.transform:Find('Container/player'..index..'/trusteeship')
        playerTrusteeshipTime[i] = gameObject.transform:Find('Container/player'..index..'/trusteeShipTime')
        playerOfflineTime[i] = gameObject.transform:Find('Container/player'..index..'/offlineTime')
        playerLianZhuang[i] = gameObject.transform:Find('Container/player'..index..'/lianZhuang')
        playerWarn[i] = gameObject.transform:Find('Container/player'..index..'/warn')
        playerAddScoreLabel[i] = gameObject.transform:Find('Container/player'..index..'/addScoreLabel')
        playerName[i].parent.gameObject:SetActive(not isInit)
    end
    local players = GPS.transform:Find('players')
    for i = 0, players.childCount-1 do
        local pla = {}
        local index = i
        if playerNum == 4 then
            if i == 1 then
                index = 3
            elseif i == 2 then
                index = 1
            elseif i == 3 then
                index = 2
            end
        end
        pla.transform = players:Find(index)
        pla.dingwei = pla.transform:Find('dingwei')
        pla.name = pla.transform:Find('name')
        GPS.playerGPS[i] = pla
    end
    if playerNum == 3 then
        playerName[3].parent.gameObject:SetActive(false)
    elseif playerNum == 2 then
        playerName[2].parent.gameObject:SetActive(false)
        playerName[3].parent.gameObject:SetActive(false)
    end
    if playerNum == 4 then
        local pos = playerGridXi[0].localPosition
        pos.x=-126
        pos.y=58
        playerGridXi[0].localPosition = pos
        pos = dipai.localPosition
        pos.y=135
        dipai.localPosition = pos
    else
        local pos = playerGridXi[0].localPosition
        pos.x=392
        pos.y=253 
        playerGridXi[0].localPosition = pos
        pos = dipai.localPosition
        pos.y=325
        dipai.localPosition = pos
    end
end
function this.BindEvent()
    message:AddClick(DelegatePanel:Find("CancelTrusteeshipBtn").gameObject, 	this.OnClickCancelTrustesship)

    message:AddClick(ButtonInvite.gameObject, this.ShowPanelShare)
    message:AddClick(panelShare:Find('friendGroup').gameObject, this.OnClickButtonInvite)
    message:AddClick(panelShare:Find('copy').gameObject, this.OnClicButtonCopy)
    message:AddClick(panelShare:Find('ButtonClose').gameObject, this.ClosePanelShare)
    message:AddClick(panelShare:Find('mask').gameObject, this.ClosePanelShare)

    message:AddClick(ButtonTing.gameObject, this.OnClickButtonTing)
    message:AddClick(ButtonRefresh.gameObject, this.OnClickButtonRefresh)
    message:AddClick(ButtonSetting.gameObject, this.OnClickButtonSetting)
    message:AddClick(ButtonChat.gameObject, this.OnClickButtonChat)
    message:AddPress(ButtonSound.gameObject, this.OnPressButtonSound)
    message:AddClick(ButtonCloseRoom.gameObject, this.OnClicButtonCloseRoom)
    message:AddClick(ButtonExitRoom.gameObject, this.OnClicButtonLeaveRoom)
    message:AddClick(ButtonNext.gameObject, this.OnClickButtonNext)
    message:AddClick(ButtonHu.gameObject, this.OnClickOperationButton)
    message:AddClick(ButtonPao.gameObject, this.OnClickOperationButton)
    message:AddClick(ButtonPeng.gameObject, this.OnClickOperationButton)
    message:AddClick(ButtonChi.gameObject, this.OnClickOperationButton)
    message:AddClick(ButtonGuo.gameObject, this.OnClickOperationButton)
    message:AddClick(ButtonTi.gameObject, this.OnClickOperationButton)
    message:AddClick(ButtonWei.gameObject, this.OnClickOperationButton)
    message:AddClick(PlayNiao.gameObject, this.OnClickChoiceNiao)
    message:AddClick(NotNiao.gameObject, this.OnClickChoiceNiao)
    message:AddClick(PlayTuo.gameObject, this.OnClickChoiceTuo)
    message:AddClick(NotTuo.gameObject, this.OnClickChoiceTuo)
    for i = 0, playPiaoView.childCount - 1 do
        message:AddClick(playPiaoView:GetChild(i).gameObject, this.OnClickChoicePiao)
    end
end
function this.OnClickButtonTing(go)
    AudioManager.Instance:PlayAudio('btn')
    go.transform:Find('di').gameObject:SetActive(not go.transform:Find('di').gameObject.activeSelf)
end
function this.OnClickButtonRefresh(GO)
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:RestartGame()
end
function this.OnApplicationFocus()
end
function this.Update()
end
function this.Start()
end
function this.OnEnable()
	if not isWhoShowEvent then
		Debugger.LogWarning('重复调用,取消从whoshow引起的调用')
		return nil
	end
    --print('亮起转转')
    PanelManager.Instance:HideWindow('panelLobby')
    PanelManager.Instance:HideWindow('panelClub')
  
    --PanelManager.Instance:ShowWindow('panelNetWaitting')
    panelInGame = panelInGameLand
    panelInGame.needXiPai=false
    this.RegisterGameCallBack()
	connect = NetWorkManager.Instance:FindConnet('game')
	if connect then
		this.StopCheckNetState()
		NetWorkManager.Instance:DeleteConnect('game')
	end
	coroutine.start(
		function()
			coroutine.wait(0.1)
			connect = NetWorkManager.Instance:CreateConnect('game');
			connect.IP = GetServerIPorTag(false, roomInfo.host)
			connect.Port = roomInfo.port
			connect.GroupName = ConfigManager.getProperty('ProxyServer', 'GroupName', '');
			connect.onConnectLua = this.OnConnect
			connect.disConnectLua = this.OnDisconnect
			connect.rspCallBackLua = receiveGameMessage;
			connect.reConnectNum = ConfigManager.getIntProperty('Setting', 'ReconnectNum', 5)
			connect.heartBeatInterval = 5
			connect:Connect()
		end
	)
    chupaishoushi.gameObject:SetActive(false)
    coroutine.start(this.RefreshState)
    this.changeBG(UnityEngine.PlayerPrefs.GetInt('ground', 1))
    this.StartCheckNetState()
    if panelChat then
        panelChat.ClearChat()
    end
    isIngame = true
	if panelClub then
		panelClub.isInClub=false
	end
    this.GetPlayerUI(4, true)
    this.RsetWhenClickNextRound()
    UnityEngine.Screen.sleepTimeout = UnityEngine.SleepTimeout.NeverSleep
    AudioManager.Instance:StopMusic()
    AudioManager.Instance:PlayMusic('GameBG', true)
    GPS.transform.gameObject:SetActive(false)
    IsAutoDissolve = false
    for i = 0, 3 do
        playerTrusteeship[i].gameObject:SetActive(false)
    end
end
function this.WhoShow(data)
	gameObject:SetActive(false)
	this.SetMyAlpha(1)
	this.OnRoundStarted = nil
	PanelManager.Instance:HideAllWindow()
	isWhoShowEvent = true
	gameObject:SetActive(true)
	isWhoShowEvent = false
end
function this.RegisterGameCallBack()
    ClearGameCallBack()
    RegisterGameCallBack(phz_pb.PLAYER_ENTER, this.OnPlayerEnter)
    RegisterGameCallBack(phz_pb.PLAYER_JOIN, this.OnPlayerJion)
    RegisterGameCallBack(phz_pb.LEAVE_ROOM, this.OnLeaveRoom)
    RegisterGameCallBack(phz_pb.PLAYER_LEAVE, this.OnPlayerLeave)
    RegisterGameCallBack(phz_pb.ROUND_START, this.OnRoundStart)
    RegisterGameCallBack(phz_pb.ROUND_END, this.OnRoundEnd)
    RegisterGameCallBack(phz_pb.READY, this.OnReady)
    RegisterGameCallBack(phz_pb.MO_PAI, this.OnPlayerMoPai)
    RegisterGameCallBack(phz_pb.CHU_PAI, this.OnPlayerChuPai)
    RegisterGameCallBack(phz_pb.CHI_PAI, this.OnPlayerChiPai)
    RegisterGameCallBack(phz_pb.PENG_PAI, this.OnPlayerPengPai)
    RegisterGameCallBack(phz_pb.WEI_PAI, this.OnPlayerWeiPai)
    RegisterGameCallBack(phz_pb.PAO_PAI, this.OnPlayerPaoPai)
    RegisterGameCallBack(phz_pb.TI_PAI, this.OnPlayerTiPai)
    RegisterGameCallBack(phz_pb.FOLD, this.OnPlayerGuo)
    RegisterGameCallBack(phz_pb.PASS_HU, this.OnPlayerPassHu)
    RegisterGameCallBack(phz_pb.HU_PAI, this.OnPlayerHuPai)
    RegisterGameCallBack(phz_pb.GAME_OVER, this.OnOver)
    RegisterGameCallBack(phz_pb.DISSOLVE, this.OnDissolve)
    RegisterGameCallBack(phz_pb.LORD_DISSOLVE, this.OnLordDissolve)
    RegisterGameCallBack(phz_pb.DESTROY, this.Destroy)
    RegisterGameCallBack(phz_pb.SEND_CHAT, this.OnSendChat)
    RegisterGameCallBack(phz_pb.DISCONNECTED, this.OnDisconnected)
    RegisterGameCallBack(phz_pb.VOICE_MEMBER, this.OnVoiceMember)
    RegisterGameCallBack(phz_pb.NO_ROOM, this.OnRoomNoExist)
    RegisterGameCallBack(phz_pb.ENTER_ERROR, this.OnRoomError)
    RegisterGameCallBack(phz_pb.TING_PAI, this.OnGetTingPai)
    RegisterGameCallBack(phz_pb.CHOICE_NIAO, this.OnChoiceNiao)
    RegisterGameCallBack(phz_pb.CHOICE_TUO, this.OnChoiceTuo)
    RegisterGameCallBack(phz_pb.CHOICE_PIAO, this.OnChoicePiao)

    RegisterGameCallBack(phz_pb.AUTO_DISSOLVE, this.OnAutoDissolve)
    RegisterGameCallBack(phz_pb.PHZ_AUTO_DISSOLVE, this.OnHuangDissolve);
    RegisterGameCallBack(phz_pb.PONG, this.OnPong)
    RegisterGameCallBack(phz_pb.TRUSTEESHIP,			this.OnTrustesship)

    RegisterGameCallBack(phz_pb.ERROR_INFO, this.OnGameError)
    RegisterGameCallBack(phz_pb.PASS_HU_CONFIRM, this.OnGuoHu)
    RegisterGameCallBack(phz_pb.GIFT, this.OnPlayerEmoji)
    RegisterGameCallBack(phz_pb.OVERTIME_DISSOLVE,this.OnOverTimeDissolve)

    RegisterGameCallBack(phz_pb.WUFU_WARNING,this.OnChoiceWarning)
end

function this.initHandGridAndEffect()
    Util.ClearChild(playerGridHand)
    Util.ClearChild(operation_receive)
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

function this.RsetWhenStart()
    this.tingQueues=nil
    line.gameObject:SetActive(false)
    chupaishoushi.gameObject:SetActive(false)
    dipai.gameObject:SetActive(false)
    operation_send.gameObject:SetActive(false)
    curOperatPlateEffect.gameObject:SetActive(false)
    moOperatPlateEffect.gameObject:SetActive(false)
    playerGridHand.gameObject:SetActive(false)
    playerDi.gameObject:SetActive(false)
    ButtonTing.gameObject:SetActive(false)
    ButtonCloseRoom.gameObject:SetActive(false)
    ButtonNext.gameObject:SetActive(false)
    Util.ClearChild(playerGridHand)
    Util.ClearChild(operation_receive)

    gameObject.transform:Find('bottomButtons'):GetComponent('UIGrid').repositionNow = true
    gameObject.transform:Find('bottomButtons'):GetComponent('UIGrid'):Reposition()
end

function this.RsetWhenJionRoom()
    this.RsetWhenStateChange()
    chupaishoushi.gameObject:SetActive(false)
    if phz_pb.GAMING == roomData.state then
        local p = this.GetPlayerDataBySeat(mySeat)
        if roomData.activeSeat == mySeat and roomData.outPlate == -1 then
            needChuPai = true
            if roomData.setting.roomTypeValue == proxy_pb.YJGHZ and roomData.activeSeat == mySeat and #p.operations > 0 then
                needChuPai = false
            end
            chupaishoushi.gameObject:SetActive(needChuPai)
            kuang01[this.GetUIIndexBySeat(roomData.activeSeat)].gameObject:SetActive(true)
        end
        if roomData.activeSeat then
            this.ShowWaitOpreatEffect(roomData.activeSeat, true)
            kuang01[this.GetUIIndexBySeat(roomData.activeSeat)].gameObject:SetActive(true)
        end
        this.RereshOperationSend(p.operations, 'JionRoom')
        lastOperat.plate = roomData.outPlate
        lastOperat.seat = roomData.activeSeat

        dipai:Find('Label'):GetComponent('UILabel').text = string.format('%d张', roomData.surplus)
        RefreshMyGridHand(playerGridHand, p)
        this.RefreshSiShou()
        this.RefreshAllGridXi()
        this.RefreshAllTabelThrow()
        myTingPlates=this.GetPlayerDataBySeat(mySeat).tingPlates
        this.setTingPai()--听牌

        --托管
        if p.trusteeship then
            this.SetMyseflInTrustesship(mySeat,true);
        end

    else
        this.ShowWaitOpreatEffect(roomData.activeSeat, false)
        kuang01[this.GetUIIndexBySeat(roomData.activeSeat)].gameObject:SetActive(false)
    end

    for i = 0, curPais.childCount - 1 do
        curPais:GetChild(i).gameObject:SetActive(false)
    end

    if needChuPai then
        this.SetDelegateCount(mySeat)
    end

    if phz_pb.GAMING == roomData.state then
        print("出牌的人"..roomData.outSeat)
        print("出的牌"..roomData.outPlate)
        if roomData.outPlate ~= -1 then
            local index=this.GetUIIndexBySeat(roomData.outSeat)
            print("uiindex"..index)
            local pData = this.GetPlayerDataByUIIndex(index)
            if pData.paiHe[#pData.paiHe]==roomData.outPlate then
                table.remove(pData.paiHe)
            end
            RefreshTabelThrow(playerThrow[index], pData.paiHe, pData.seat)
            curOperatPlateEffect.gameObject:SetActive(false)
            moOperatPlateEffect.gameObject:SetActive(false)
            this.playPaiAnimation(roomData.outSeat, roomData.outPlate, playerMoPaiPos[index].position, playerMoPaiPos[index].position, Vector3.zero, Vector3.one * 0.8, true, true, true)
        end
    end
end
--[[    @desc: 刷新玩家死手或者送偎跑的标记
    author:{author}
    time:2018-08-31 15:36:09
    @return:
]]
function this.RefreshSiShou()
    for i = 0, 2 do
        playerSiShou[i].gameObject:SetActive(false)
        local pData = this.GetPlayerDataByUIIndex(i)
        if pData and i < roomData.setting.size then
            if pData.siShou and pData.siShou == true then
            else
                if pData.songWeiPao and pData.songWeiPao == true then
                    playerSiShou[i].gameObject:SetActive(true)
                end
            end
        end
    end
end

function this.RefreshPlayNiao()
    for i = 0, 2 do
        playerNiao[i].gameObject:SetActive(false)
        local pData = this.GetPlayerDataByUIIndex(i)
        if pData and i < roomData.setting.size then
            print("是不是选择了打鸟："..pData.daNiao)
            playerNiao[i].gameObject:SetActive(pData.daNiao == 1)
        end
    end
end

function this.RefreshPlayerTuo()
    for i = 0, 2 do
        playerTuo[i].gameObject:SetActive(false)
        local pData = this.GetPlayerDataByUIIndex(i)
        if pData and i < roomData.setting.size then
            print("是不是选择了打坨："..pData.daTuo)
            playerTuo[i].gameObject:SetActive(pData.daTuo == 1)
        end
    end
end

function this.RsetWhenClickNextRound()
    for i = 0, 3 do
        playerGridXi[i].gameObject:SetActive(false)
        playerThrow[i].gameObject:SetActive(false)
        playerGridStageClear[i].gameObject:SetActive(false)
        playerRoundScore[i].gameObject:SetActive(false)
        playerGridXiLabel[i].gameObject:SetActive(false)
        playerSiShou[i].gameObject:SetActive(false)
        Util.ClearChild(playerThrow[i])
    end
    for i = 0, curPais.childCount - 1 do
        curPais:GetChild(i).gameObject:SetActive(false)
    end

    myTingPlates = nil
    ButtonTing.gameObject:SetActive(false)
end

function this.RsetWhenStateChange()
    ButtonInvite.gameObject:SetActive(#playerData ~= roomData.setting.size and IsAppleReview() == false)
    if mySeat ~= 0 then--如果我不是房主
        ButtonCloseRoom:Find('Label'):GetComponent('UILabel').text='退出房间'
    else
        ButtonCloseRoom:Find('Label'):GetComponent('UILabel').text='解散房间'
    end

    this.RestButtonState()
    playerDi.gameObject:SetActive(false)
    operation_send.gameObject:SetActive(false)
    ButtonTing.gameObject:SetActive(false)
    playerGridHand.gameObject:SetActive(phz_pb.GAMING == roomData.state)
    curOperatPlateEffect.gameObject:SetActive(false)
    moOperatPlateEffect.gameObject:SetActive(false)
    dipai.gameObject:SetActive(phz_pb.GAMING == roomData.state)
    Util.ClearChild(playerGridHand)
    for i = 0, 3 do
        playerGridXi[i].gameObject:SetActive(phz_pb.GAMING == roomData.state and i < roomData.setting.size)
        playerThrow[i].gameObject:SetActive(phz_pb.GAMING == roomData.state and i < roomData.setting.size)
        playerGridStageClear[i].gameObject:SetActive(false)
        playerRoundScore[i].gameObject:SetActive(false)
        playerGridXiLabel[i].gameObject:SetActive(false)
        playerIcon[i]:Find('waitOpreatEffect').gameObject:SetActive(false)
        playerSiShou[i].gameObject:SetActive(false)
        playerAddScoreLabel[i].gameObject:SetActive(false)
        playerTrusteeshipTime[i].gameObject:SetActive(false)
        playerWarn[i].gameObject:SetActive(false)
    end
    lastOperat.seat = -1
    lastOperat.plate = -1
    needChuPai = false

    --gameObject.transform:Find('bottomButtons'):GetComponent('UIGrid').repositionNow = true
    gameObject.transform:Find('bottomButtons'):GetComponent('UIGrid'):Reposition()
end

function this.RestButtonState()
    ButtonCloseRoom.gameObject:SetActive(phz_pb.GAMING ~= roomData.state and roomData.round == 1 and not this.IsAllReaded())  
    ButtonExitRoom.gameObject:SetActive(phz_pb.GAMING ~= roomData.state and roomData.round == 1 and not this.IsAllReaded())              
    ButtonNext.gameObject:SetActive(phz_pb.READYING == roomData.state and roomData.round == 1 and this.GetPlayerDataByUIIndex(0).ready==false)
end



function this.OnConnect()
    connect.IsZanTing=false
    coroutine.start(
    function()
        while not isLogin do
            coroutine.wait(0.1)
        end
       --print('加入游戏房间。。。。。。。')
        this.JionRoom()
    end
    )
    this.stopAllPaiAnimiation()
    coroutine.stop(stageClearCor)
    stageClearCor = nil
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
            print("进入重连状态..................................")
            PanelManager.Instance:ShowWindow('panelGameNetWaitting')
        elseif not connect.IsConnect then
            print("进入网络断开状态..................................")
            PanelManager.Instance:HideWindow('panelGameNetWaitting')
            panelLogin.HideAllNetWaitting()
            panelMessageBoxTiShi.SetParamers(OK_CANCLE, this.OnNetCheckButtonOK, this.OnNetCheckButtonCancle, '网络连接失败，是否继续连接？')
            PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
            break
        elseif connect.IsConnect then
            --print("进入重连成功 状态..................................")
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
    local msg       = Message.New()
    msg.type        = phz_pb.JOIN_ROOM
    local body      = phz_pb.PJoinRoom();
    body.roomNumber = roomInfo.roomNumber
    body.token      = roomInfo.token
    body.longitude  = tonumber(UnityEngine.PlayerPrefs.GetFloat("longitude",0));
    body.latitude   = tonumber(UnityEngine.PlayerPrefs.GetFloat("latitude",0));
    body.address    = UnityEngine.PlayerPrefs.GetString("address","");

    --print(roomData.round)
   --print('传给服务器的地址' .. body.address)
    msg.body = body:SerializeToString()
    IsRefreshTime = false;
    SendGameMessage(msg, this.OnJionRoomResult)
end
local GvoiceCor--语音的协程
local restTime
local RefeshTimeCoroutine
function this.OnJionRoomResult(msg)
    panelInGame.needXiPai=false
    panelLogin.HideNetWaitting()
    if PanelManager.Instance:IsActive('panelMessageBoxTiShi') then
        PanelManager.Instance:HideWindow('panelMessageBoxTiShi')
    end
    allCards={}--清空所有记录的牌
    local body = phz_pb.RJoinRoom()
    body:ParseFromString(msg.body)
    this.fanHuiRoomNumber = roomInfo.roomNumber
    roomData = body.room
    print('有没有clubid' .. roomData.clubId)
    mySeat = body.seat

    playerData = {}
    for i = 1, #body.room.players do
        local p = body.room.players[i]
        p.sex = p.sex == 0 and 1 or p.sex
        table.insert(playerData, p)
    end
    this.CheckNeedOpenPlayPiao()
    this.CheckNeedOpenPlayNiao()
    this.CheckNeedOpenPlayTuo()
    coroutine.start(RefreshTime, roomTime:GetComponent('UILabel'), 60)
    offlineState = false;
    chouPlates = {}
    for i = 1, #(this.GetPlayerDataBySeat(mySeat).chouPlates) do
        table.insert(chouPlates,this.GetPlayerDataBySeat(mySeat).chouPlates[i])
    end
    this.GetPlayerUI(roomData.setting.size)
    roomID:GetComponent('UILabel').text = roomInfo.roomNumber


    DestroyRoomData.roomData = roomData
    DestroyRoomData.playerData = playerData
    DestroyRoomData.mySeat = mySeat

    this.myseflDissolveTimes = 0 --自己申请解散房间的次数

    --print('destroyroom countdown time is:'..roomData.dissolution.remainMs)
    if roomData.dissolution.remainMs > 0 then
        roomData.dissolution.remainMs = getIntPart(roomData.dissolution.remainMs / 1000)
        this.SetDestoryPanelShow()
    else
        PanelManager.Instance:HideWindow('panelDestroyRoom')
    end

    print("游戏局数："..body.room.round)
    print("游戏状态：" .. body.room.state .. "")
    if roomData.state == phz_pb.READYING and body.room.clubId ~= "0" and body.room.round == 1  then
        restTime = body.room.time -- 600 - os.time() + body.room.time
       --print('时间：'..body.room.time) 
        RestTime:Find("Time"):GetComponent('UILabel').text = os.date("%M:%S", restTime)
        RestTime.gameObject:SetActive(true)
        if RefeshTimeCoroutine == nil then
            RefeshTimeCoroutine = coroutine.start(this.RefreshTime, RestTime:Find("Time"):GetComponent('UILabel'))
        end
    else
        RestTime.gameObject:SetActive(false)
    end

    RoundAllData.over = false
    this.SetRoundNum(roomData.round)
    this.RefreshPlayer()
    this.SettingText()

    this.RefreshAllXiNum()
    this.SetReadyVisiable()
    this.RsetWhenJionRoom()
    
    if Util.GetPlatformStr() ~= 'win' then
		print('开始语音poll！！！！！！！！！！')
		if GvoiceCor then
			StopCoroutine(GvoiceCor)
		end
		GvoiceCor = StartCoroutine(this.TickNGCloudVoice)
		NGCloudVoice.Instance:ApplyMessageKey()
	end
    

     ----检查是否开启定位
    if (roomData.setting.size > 2) and roomData.round == 1  then
        local longitude = UnityEngine.PlayerPrefs.GetFloat("longitude",0)
        local latitude = UnityEngine.PlayerPrefs.GetFloat("latitude",0)
        local address = UnityEngine.PlayerPrefs.GetString("address","")
       --print('longitude:'..longitude..", latitude:"..latitude..", address:"..address)
        if (longitude == 0 and latitude == 0) and address=="" then 
            panelMessageBox.SetParamers(ONLY_OK,nil,nil,"未允许游戏获取定位");
            PanelManager.Instance:ShowWindow("panelMessageBox");
        end
    end
end

function this.RefreshTime(labelTime)
    --print('时间戳' .. getDaoJiShi(timeChuo))
    while true do
        if restTime > 0 then
            labelTime.text = os.date("%M:%S", restTime) --getDaoJiShi(timeChuo)--os.date("%M:%S")
            restTime = restTime - 1
        end
        coroutine.wait(1)
    end
end

function this.SettingText()
    local AllOption = ""
    AllOption = getWanFaText(roomData.setting, false, false, false)
    roomSetting:Find("op"):Find("AllOption"):GetComponent('UILabel').text = '[000000]'..AllOption
    roomSetting:Find("op"):Find("AllOption").gameObject:SetActive(true)

    gameObject.transform:Find('type'):GetComponent('UILabel').text = '[000000]'..roomData.playName

    roomSetting.gameObject:SetActive(true)
end

function this.GetPlayerDataByUIIndex(index)
    if roomData.setting.size == 2 then
        return (index == 0) and this.GetPlayerDataBySeat(mySeat) or this.GetPlayerDataBySeat((mySeat == 1) and 0 or 1)
    end
    local i = index + mySeat
    i = i % roomData.setting.size
    return this.GetPlayerDataBySeat(i)
end

function this.GetUIIndexBySeat(seat)
    if roomData.setting.size == 2 then
        return (seat == mySeat) and 0 or 1
    end
    return (roomData.setting.size - mySeat + seat) % roomData.setting.size
end

function this.GetPlayerDataBySeat(seat)
    for i = 1, #playerData do
        if playerData[i].seat == seat then
            return playerData[i]
        end
    end
    return nil
end

function this.RefreshPlayer()
    local playerNum=0
    for i = 0, roomData.setting.size-1 do
        local p = this.GetPlayerDataByUIIndex(i)
        if p then
            playerNum=playerNum+1
            playerName[i].gameObject:SetActive(true)
            playerName[i]:GetComponent('UILabel').text = p.name
            coroutine.start(LoadPlayerIcon, playerIcon[i]:GetComponent('UITexture'), p.icon)
            SetUserData(playerIcon[i].gameObject, p)
            playerIcon[i].gameObject:SetActive(true)
            playerScore[i].gameObject:SetActive(true)
            playerScore[i]:GetComponent('UILabel').text = p.score
            playerMaster[i].gameObject:SetActive(roomData.bankerSeat == p.seat)
            playerOffline[i].gameObject:SetActive(not p.connected)
            playerXiNum[i].gameObject:SetActive(true)
            playerKongWei[i].gameObject:SetActive(false)
            playerNiao[i].gameObject:SetActive(p.daNiao == 1)
            print('p.piao : '..p.piao)
            playerPiao[i].gameObject:SetActive(p.piao ~= 0 and p.piao ~= -1)
            playerPiao[i]:GetComponent('UILabel').text = (p.piao ~= 0 and p.piao ~= -1) and ('飘'..p.piao..'分') or ''
            playerTuo[i].gameObject:SetActive(p.daTuo == 1)
            playerTrusteeship[i].gameObject:SetActive(p.trusteeship)
            playerOfflineTime[i].gameObject:SetActive(not p.connected)
            if p.disconnectTimes ~= nil and p.disconnectTimes ~= 0 then
				this.StartOfflineIncrease(p.seat, p.disconnectTimes)
            end
            playerWarn[i].gameObject:SetActive(p.isWarning)
            if p.lianHu>1 and roomData.setting.mode == 0 then
                playerLianZhuang[i].gameObject:SetActive(true)
                playerLianZhuang[i]:GetComponent('UILabel').text = '连庄x'..p.lianHu
            else
                playerLianZhuang[i].gameObject:SetActive(false)
            end
        else
            playerName[i].gameObject:SetActive(false)
            playerIcon[i].gameObject:SetActive(false)
            playerKongWei[i].gameObject:SetActive(true)
            playerScore[i].gameObject:SetActive(false)
            playerMaster[i].gameObject:SetActive(false)
            playerOffline[i].gameObject:SetActive(false)
            SetUserData(playerIcon[i].gameObject, nil)
            playerXiNum[i].gameObject:SetActive(false)
            playerNiao[i].gameObject:SetActive(false)
            playerPiao[i].gameObject:SetActive(false)
            playerTuo[i].gameObject:SetActive(false)
            playerTrusteeship[i].gameObject:SetActive(false)
            playerOfflineTime[i].gameObject:SetActive(false)
            playerWarn[i].gameObject:SetActive(false)
            playerLianZhuang[i].gameObject:SetActive(false)
        end
        playerSound[i].gameObject:SetActive(false)
        playerMoPaiPos[i].gameObject:SetActive(false)
    end
    ButtonSound.gameObject:SetActive(playerNum>1)
end

function this.OnPlayerEnter(msg)
    --print('OnPlayerEnter')
    local b = phz_pb.RPlayer()
    b:ParseFromString(msg.body)

    table.insert(playerData, b)
    b.connected = true
    local index = this.GetUIIndexBySeat(b.seat)
    playerOffline[index].gameObject:SetActive(true)
    playerReady[index].gameObject:SetActive(false)
    playerKongWei[index].gameObject:SetActive(false)
    --b.ready = false

    this.RefreshPlayer()
end

function this.changeBG(lanOrLv)
    --local yanse = lanOrLv == 1 and Color(27 / 255, 61 / 255, 93 / 255) or Color(10 / 255, 79 / 255, 57 / 255) 
   
    local yanse = Color(0, 0, 0)
    if lanOrLv == 1 then
        yanse = Color(27 / 255, 61 / 255, 93 / 255)
    elseif lanOrLv == 0 then
        yanse = Color(10 / 255, 79 / 255, 57 / 255)
    else
        yanse = Color(144 / 255, 131 / 255, 75 / 255)
    end
    
    for i = 0, lvBG.childCount - 1 do
        if i == lanOrLv then
            lvBG.transform:GetChild(i).gameObject:SetActive(true)
        else
            lvBG.transform:GetChild(i).gameObject:SetActive(false)
        end
    end
end

function this.changePaiSize(paiSize)
    local size = Vector3(1,1,1)
    local w = 87
    local h = 88
    if paiSize == 1 then
        playerGridHand.transform.localPosition=Vector3(536,-226,0)
        size = Vector3(1.2, 1.2, 1)
        w = w * 1.2
        h = 93
    else
        playerGridHand.transform.localPosition=Vector3(536,-211,0)
        size = Vector3(1, 1, 1)
    end

    for i=0,playerGridHand.transform.childCount - 1 do
        local grid = playerGridHand.transform:GetChild(i)
        for j=0, grid.transform.childCount - 1 do
            local pai = grid.transform:GetChild(j)
            pai.transform.localScale = size
        end
        grid:GetComponent('UIWidget').width = w
        grid:GetComponent('UIGrid').cellHeight = h
        grid:GetComponent('UIGrid'):Reposition()
    end
    
    playerGridHand:GetComponent('UIGrid').cellWidth = w
    playerGridHand:GetComponent('UIGrid'):Reposition()
end

function this.OnPlayerJion(msg)
   --print('OnPlayerJion')
    local b = phz_pb.RPlayerJoin()
    b:ParseFromString(msg.body)

    local pData = this.GetPlayerDataBySeat(b.seat)
    pData.connected = true
    pData.ip = b.ip
    pData.ready = b.ready
    if b.longitude and b.longitude ~= 0 then
        pData.longitude = b.longitude
        pData.latitude = b.latitude
    else
        pData.longitude = 0
        pData.latitude = 0
    end

    if b.address and b.address ~= "" then
        pData.address = b.address
    else
        pData.address = "未获取到该玩家位置"
    end
   --print('OnPlayerJion座位号' .. b.seat)
   --print('OnPlayerJion地址' .. b.address)
   --print('我的座位：'..mySeat)

    local index = this.GetUIIndexBySeat(b.seat)
    playerOffline[index].gameObject:SetActive(false)
    ButtonInvite.gameObject:SetActive(#playerData ~= roomData.setting.size and IsAppleReview() == false)
    gameObject.transform:Find('bottomButtons'):GetComponent('UIGrid').repositionNow = true
    gameObject.transform:Find('bottomButtons'):GetComponent('UIGrid'):Reposition()
    this.SetReadyVisiable()
    this.RefreshPlayer()
    if (roomData.state == phz_pb.READYING) and roomData.setting.size > 2 then
		local datas = {}
		for i = 0, roomData.setting.size - 1 do
			datas[i] = this.GetPlayerDataByUIIndex(i)
		end
        GPS.transform.gameObject:SetActive(true)
		SetGPSInfo(GPS,roomData.setting.size == 3 and pos3 or pos4,datas,roomData.setting.size)
    end
    this.CheckNeedOpenPlayPiao()
    this.CheckNeedOpenPlayNiao()
    this.CheckNeedOpenPlayTuo()

    this.NotifyGameStart()
    this.StopOfflineIncrease(b.seat)
end

function this.OnLeaveRoom(msg)
   --print('OnLeaveRoom')
    NetWorkManager.Instance:DeleteConnect('game')
    PanelManager.Instance:HideWindow('panelDestroyRoom')
    panelLogin.HideGameNetWaitting();
    if roomData.clubId ~= '0' then
        local data = {}
        data.name = 'panelInGameLand'
        -- data.clubId = roomData.clubId
        PanelManager.Instance:ShowWindow('panelClub', data)
    else
       --print('dddddddddddddddd')
        PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
    end
    roomData.clubId = '0'
end


function this.OnPlayerLeave(msg)
   --print('OnPlayerLeave')
    local b = phz_pb.RSeat()
    b:ParseFromString(msg.body)
    for i = #playerData, 1, -1 do
        if playerData[i].seat == b.seat then
            table.remove(playerData, i)
            break
        end
    end
    local index = this.GetUIIndexBySeat(b.seat)
    playerReady[index].gameObject:SetActive(false)
    ButtonInvite.gameObject:SetActive(#playerData ~= roomData.setting.size and IsAppleReview() == false)
    gameObject.transform:Find('bottomButtons'):GetComponent('UIGrid').repositionNow = true
    gameObject.transform:Find('bottomButtons'):GetComponent('UIGrid'):Reposition()
    this.RefreshPlayer()
    if (roomData.state == phz_pb.READYING) and roomData.setting.size > 2 then
		local datas = {}
		for i = 0, roomData.setting.size - 1 do
			datas[i] = this.GetPlayerDataByUIIndex(i)
		end
        GPS.transform.gameObject:SetActive(true)
		SetGPSInfo(GPS,roomData.setting.size == 3 and pos3 or pos4,datas,roomData.setting.size)
    end
    this.CheckNeedOpenPlayPiao()
    this.CheckNeedOpenPlayNiao()
    this.CheckNeedOpenPlayTuo()
end
--统计所有出现的牌
function this.collectionAllPlate(plates)
    for i = 1, #plates do
        if  not allPlates[plates[i]]  then
            allPlates[plates[i]] = 1
        else
            allPlates[plates[i]] = allPlates[plates[i]] + 1
        end
    end
end

function RefreshMyGridHand(GridHand, player, isReplay, prefabName)
    allCards={}
    Util.ClearChild(playerGridHand)
    local use1510 = false
    if (roomData.setting.roomTypeValue == proxy_pb.HYSHK 
    or roomData.setting.roomTypeValue == proxy_pb.HYLHQ 
    or roomData.setting.roomTypeValue == proxy_pb.XTPHZ)
    and roomData.setting.yiWuShi then
        use1510 = true
    end
    local useJiaoPai = true
    if roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
        useJiaoPai = false
    end
    local useTi = true
    if roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
        useTi = false
    end
    local useKan = true
    if roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
        useKan = false
    end
    local plateGroups = SplitIntoGroups(isReplay and player.plates or player.hands,use1510,useJiaoPai,useTi,useKan)
    
    local prefab = prefabName and prefabName or 'cardGroupHand'

    for j = GridHand.childCount, 10 do
        local cardGroupHand = ResourceManager.Instance:LoadAssetSync(prefab)
        local obj = NGUITools.AddChild(GridHand.gameObject, cardGroupHand)
        obj.name = prefab
        if not isReplay then
            for i = 0, obj.transform.childCount - 1 do
                local card = obj.transform:GetChild(i).gameObject
                UIEventListener.Get(card).onDragStart = this.OnDragStartPlate
                UIEventListener.Get(card).onDragEnd = this.OnDragEndtPlate
                message:AddClick(card, this.OnClickCard)
                message:AddPress(card, function(go,isPress) 
                    go.transform.localPosition = Vector3(go.transform.localPosition.x, go.transform.localPosition.y+(isPress==true and 70 or -70), 0)
                end)
            end
        end
    end

    --GridHand:GetComponent('UIGrid'):Reposition()
    for i = 0, GridHand.childCount - 1 do
        local item = GridHand:GetChild(i)
        if i < #plateGroups then
            local group = plateGroups[i + 1]
            item.localPosition=Vector3(i,0,0)
            item.gameObject:SetActive(true)
            for j = 0, item.childCount - 1 do
                if j < #group then
                    if not item:GetChild(j).gameObject.activeSelf then
                        item:GetChild(j).localPosition = Vector3.zero
                    end
                    item:GetChild(j).gameObject:SetActive(true)
                    if item:GetChild(j):GetComponent('BoxCollider') then
                        item:GetChild(j):GetComponent('BoxCollider').enabled = (not group.lock) and (not isReplay)
                    end
                else
                    item:GetChild(j).gameObject:SetActive(false)
                    SetUserData(item:GetChild(j).gameObject, nil)
                end
            end
            if prefabName=='cardGroupXiReplay' then
                table.sort(group) 
            end
            for j = 0, #group - 1 do
                local card = item:GetComponent('UIGrid'):GetChild(j)
                if prefab == 'cardGroupHand' then
                    card:Find('bg'):GetComponent('UISprite').depth = j * 4 + 5
                    card:Find('bg/ting').gameObject:SetActive(false)
                    if this.tingQueues~=nil then
                        for q=1,#this.tingQueues do
                            if this.tingQueues[q].plate==group[j + 1] then
                                card:Find('bg/ting').gameObject:SetActive(true)
                                card:Find('bg/ting'):GetComponent('UISprite').depth = j * 4 + 8
                                break
                            end
                        end
                    end
                    
                    card:Find('bg/plate0'):GetComponent('UISprite').depth = j * 4 + 7
                    this.setPaiMian(card:Find('bg/plate0'), group[j + 1])
                    --card:Find('bg/plate0'):GetComponent('UISprite').spriteName = 'card_'..group[j+1]
                    card:Find('bg/plate1'):GetComponent('UISprite').depth = j * 4 + 7
                    this.setPaiMian(card:Find('bg/plate1'), group[j + 1])
                    --card:Find('bg/plate1'):GetComponent('UISprite').spriteName = 'card_'..group[j+1]
                    card:Find('bg/mask'):GetComponent('UISprite').depth = j * 4 + 6
                    card:Find('bg/mask').gameObject:SetActive(group.lock)
                else
                    card:GetComponent('UISprite').depth = j * 4 + 5
                    card:Find('plate'):GetComponent('UISprite').depth = j * 4 + 20
                    this.setPaiMian(card:Find('plate'), group[j + 1])
                    --card:Find('plate'):GetComponent('UISprite').spriteName = 'card_'..group[j+1]
                end
                SetUserData(card.gameObject, group[j + 1])
            end
            if not isReplay then
                item:GetComponent('BoxCollider').enabled = not group.lock
            else
                if item:GetComponent('UIPanel') then
                    item:GetComponent('UIPanel').depth = 4 + i
                end
            end
            item:GetComponent('UIGrid'):Reposition()
        else
            item.gameObject:SetActive(false)
            for j = 0, item.childCount - 1 do
                item:GetChild(j).gameObject:SetActive(false)
            end
        end
        if not isReplay then
            StartCoroutine(function ()
                WaitForEndOfFrame()
                item:GetComponent('UIGrid').animateSmoothly=true
            end)
        end
    end
    if roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
        SetChouPlates(playerGridHand,chouPlates)
    end
    -- if isReplay and prefab == 'cardGroupXiReplay' then
    --     local cellWidth = Mathf.Clamp((9 - #plateGroups) * 4 + 34, 34, 45)
    --     GridHand:GetComponent('UIGrid').cellWidth = cellWidth
    -- end
    GridHand:GetComponent('UIGrid').animateSmoothly=false
    GridHand:GetComponent('UIGrid'):Reposition()
    if not isReplay then
        StartCoroutine(function ()
            WaitForEndOfFrame()
            GridHand:GetComponent('UIGrid').animateSmoothly=true
        end)
    end
    if not isReplay  then
        this.changePaiSize(UnityEngine.PlayerPrefs.GetInt('paiSize', 1))
    end
end
function this.SetJianTou(seat,item)
    item:Find('jiantou').gameObject:SetActive(true)
    local inx = this.GetUIIndexBySeat(seat)
    print('SetJianTou seat: '..seat..' inx: '..inx)
    local num = 0
    if inx==0 then
        num = -90
    elseif inx==1 then
        num = 0
    elseif inx==2 then
        if roomData.setting.size == 3 then
            num = 180
        else
            num = 90
        end
    else
        num = 180
    end
    item:Find('jiantou').localRotation = Quaternion.Euler(0,0,num)
end

function RefreshGridXi(grid, playerGridXi, ROperationPlate,menZis, isStageClear,isPlay,isTiPao)
    print(string.format('RefreshGridXi:%s num:%d' ,grid.parent.gameObject.name, #ROperationPlate))
    --print('grid.childCount : '..grid.childCount..'  #ROperationPlate : '..#ROperationPlate);
	local tipaoNum=-1
	if isTiPao then
		for i=1, #ROperationPlate do
			--print('ROperationPlate[i].plates[1] : '..ROperationPlate[i].plates[1])
			if ROperationPlate[i].plates[1] == menZis[1].plates[1] then
				tipaoNum=i-1
			end
		end
		--print('tipaoNum : '..tipaoNum);
	end
    local num = tipaoNum>=0 and tipaoNum or (#menZis>=2 and (#ROperationPlate-#menZis) or #ROperationPlate-1)
    for j = grid.childCount, #ROperationPlate - 1 do
        local cardGroupXi = ResourceManager.Instance:LoadAssetSync('cardGroupXiGame')
		for i = 0, cardGroupXi.transform.childCount-1 do
            cardGroupXi.transform:GetChild(i):GetComponent('UISprite').depth = 3--+j
            cardGroupXi.transform:GetChild(i):Find('plate'):GetComponent('UISprite').depth = 4--+j
            cardGroupXi.transform:GetChild(i):Find('jiantou'):GetComponent('UISprite').depth = 5--+j
        end
        local obj = NGUITools.AddChild(grid.gameObject, cardGroupXi)
    end
    for i = 0, grid.childCount - 1 do
        if i < #ROperationPlate then
            grid:GetChild(i).gameObject:SetActive(true)
            local group = ROperationPlate[i + 1]
            local item = grid:GetChild(i)
            local plates = {}
            if group.operation == phz_pb.CHI or group.operation == phz_pb.JIAO or group.operation == phz_pb.JU then
                for j = 1, #group.plates do
                    table.insert(plates, group.plates[j])
                end
            elseif group.operation == phz_pb.DUI then
                for j = 1, 2 do
                    table.insert(plates, group.plates[1])
                end
            elseif group.operation == phz_pb.PENG or group.operation == phz_pb.WEI or group.operation == phz_pb.KAN or group.operation == phz_pb.CHOU_WEI then
                for j = 1, 3 do
                    table.insert(plates, group.plates[1])
                end
            elseif group.operation == phz_pb.PAO or group.operation == phz_pb.TI or group.operation == phz_pb.START_TI then
                for j = 1, 4 do
                    table.insert(plates, group.plates[1])
                end
            else
                Debugger.LogError('RefreshGridXi unkown type {0}', tostring(group.operation))
            end

            for j = 0, item.childCount - 1 do
                if j < #plates then
                    local show = true
                    -- if roomData.setting.roomTypeValue ~= proxy_pb.HHHGW  then
                    --     print("进的这。。。。。。。。。。。。。。。。"..group.operation)
                    --     if (group.operation == phz_pb.TI) and j > 0 then
                    --         show = false
                    --     elseif (group.operation == phz_pb.WEI) then
                    --         if j > 0 then
                    --             show = false
                    --         end
                    --         if (roomData.setting.roomTypeValue == proxy_pb.CSPHZ or roomData.setting.roomTypeValue == proxy_pb.CDPHZ) and grid ~= playerGridXi[0] then
                    --             show = false
                    --         end
                    --     end
                    -- else
                    --     if group.operation == phz_pb.WEI or group.operation == phz_pb.TI then
                    --         if grid == playerGridXi[0] then
                    --             if j > 0 then
                    --                 show = false
                    --             end
                    --         else
                    --             show = false
                    --         end
                    --     elseif (group.operation == phz_pb.CHOU_WEI or group.operation == phz_pb.START_TI) and j > 0 then
                    --         show = false
                    --     end
                    -- end
                    --print("roomData.setting.roomTypeValue:"..roomData.setting.roomTypeValue)
                    if group.operation ~= phz_pb.PENG and group.operation ~= phz_pb.CHI and group.operation ~= phz_pb.PAO then
                        if roomData.setting.roomTypeValue == proxy_pb.LDFPF 
                        or roomData.setting.roomTypeValue == proxy_pb.SYZP 
                        or roomData.setting.roomTypeValue == proxy_pb.SYBP  
                        or roomData.setting.roomTypeValue == proxy_pb.XXGHZ 
                        or roomData.setting.roomTypeValue == proxy_pb.LYZP
                        or ((roomData.setting.roomTypeValue == proxy_pb.CDPHZ 
                        or roomData.setting.roomTypeValue == proxy_pb.CSPHZ  
                        or roomData.setting.roomTypeValue == proxy_pb.AHPHZ 
                        or roomData.setting.roomTypeValue == proxy_pb.HHHGW 
                        or roomData.setting.roomTypeValue == proxy_pb.HSPHZ 
                        or roomData.setting.roomTypeValue == proxy_pb.CDDHD) and (group.operation ==  phz_pb.TI or group.operation == phz_pb.CHOU_WEI))
                        or ((roomData.setting.roomTypeValue == proxy_pb.HYSHK or roomData.setting.roomTypeValue == proxy_pb.HYLHQ) and (roomData.setting.canMingWei or group.operation == phz_pb.CHOU_WEI))
                        or (roomData.setting.roomTypeValue == proxy_pb.NXPHZ and (group.operation == phz_pb.CHOU_WEI or group.operation == phz_pb.TI))
                        or (roomData.setting.roomTypeValue == proxy_pb.XTPHZ and (group.operation ==  phz_pb.TI or (roomData.setting.canMingWei and group.operation == phz_pb.WEI) or ((roomData.setting.chouWeiLiang and group.operation == phz_pb.CHOU_WEI))))
                        or roomData.setting.roomTypeValue == proxy_pb.YXPHZ and (group.operation == phz_pb.CHOU_WEI or group.operation == phz_pb.TI or group.operation == phz_pb.START_TI)
                        or roomData.setting.roomTypeValue == proxy_pb.YJGHZ and (group.operation == phz_pb.CHOU_WEI or group.operation == phz_pb.TI or group.operation == phz_pb.WEI)
                        or roomData.setting.roomTypeValue == proxy_pb.CZZP and (group.operation == phz_pb.CHOU_WEI or group.operation == phz_pb.TI or group.operation == phz_pb.WEI or group.operation == phz_pb.START_TI) then
                            show = false
                            if j == 0 then
                                show = true
                            end
                        else
                            show = false
                            if (grid == playerGridXi[0]) and j == 0 then
                                show = true
                            end
                        end
                    end
                    
                    if not isStageClear and not show then
                        item:GetChild(j):GetComponent('UISprite').spriteName = 'Card_Big_50'
                        item:GetChild(j):GetChild(0).gameObject:SetActive(false)
                    else
                        item:GetChild(j):GetComponent('UISprite').spriteName = 'Card_half_Big_001'
                        this.setPaiMian(item:GetChild(j):Find('plate'), plates[j + 1])
                        --item:GetChild(j):Find('plate'):GetComponent('UISprite').spriteName = 'card_'..plates[j+1]
                        item:GetChild(j):GetChild(0).gameObject:SetActive(true)
                    end
                    item:GetChild(j).gameObject:SetActive(true)
                    SetUserData(item:GetChild(j).gameObject,plates[j + 1]);
                else
                    item:GetChild(j).gameObject:SetActive(false)
                end
                item:GetChild(j):Find('jiantou').gameObject:SetActive(false)
            end
            print('group.fromSeat:'..group.fromSeat)
            if roomData.setting.roomTypeValue == proxy_pb.YXPHZ and  roomData.setting.size > 2 and group.fromSeat ~= -1 then
                this.SetJianTou(group.fromSeat,item:GetChild(#plates-1))  
            end
            item.gameObject:SetActive(true)
            item:GetComponent('UIGrid'):Reposition()
        else
            grid:GetChild(i).gameObject:SetActive(false)
        end
    end
    if not isPlay then
        for i = 0, grid.childCount-1 do
            grid:GetChild(i):GetComponent('TweenPosition').enabled = false
            grid:GetChild(i):GetComponent('TweenScale').enabled = false
        end
        grid:GetComponent('UIGrid'):Reposition()
    else
	    --print('num : '..num..' #menZis : '..#menZis)
		for i = 1, #menZis do
			--print('num+i-1 : '..num+i-1)
			local temp = grid:GetChild(num+i-1)
			for j = 0, temp.childCount - 1 do
				temp:GetChild(j):GetComponent('UISprite').depth = 15
				temp:GetChild(j):Find('plate'):GetComponent('UISprite').depth = 16
			end
			temp:GetComponent('TweenScale').enabled = true
            local tweensca =  temp:GetComponent('TweenScale')
            tweensca.from = Vector3(1.5,1.5,1.5)
            tweensca.to = Vector3(1,1,1)
            tweensca.duration = 0.2
            tweensca:ResetToBeginning()
            tweensca:PlayForward()
            temp:GetComponent('TweenPosition').enabled = true
            local tweenpos =  temp:GetComponent('TweenPosition')
            local inx = tonumber(string.match(grid.parent.gameObject.name,'%d'))
            if inx == 1 or inx == 3 then
                tweenpos.from = Vector3(-51*3-(i-1)*51,0,0)
                tweenpos.to = Vector3(-51*(num+i-1),0,0)
            else
                tweenpos.from = Vector3(51*3+(i-1)*51,0,0)
                tweenpos.to = Vector3(51*(num+i-1),0,0)
            end
            tweenpos.duration = 0.2
            tweenpos.delay = 0.5
            tweenpos:ResetToBeginning()
            tweenpos:PlayForward()
		end
		
		StartCoroutine(
        function()
            coroutine.wait(1.1)
             grid:GetComponent('UIGrid'):Reposition()
			 for j = 0, grid.childCount - 1 do
                local temp =grid:GetChild(j)
                local sca = temp.transform.localScale
                sca= Vector3.one
                temp.transform.localScale=sca
				for i = 0, temp.childCount-1 do
					temp:GetChild(i):GetComponent('UISprite').depth = 3--+j
					temp:GetChild(i):Find('plate'):GetComponent('UISprite').depth = 4--+j
				end
			end
		end
		)
    end
end

--[[    @desc: 
    author:{Einstein}
    time:2018-07-30 20:42:23
    --@tu:要赋值的牌transform
	--@zhi: 牌的值
    @return:
]]
function this.setPaiMian(tu, zhi)
    tu.gameObject:SetActive(true)
    local sp = tu:GetComponent('UISprite')
    allCards[tu:GetInstanceID()]=sp
    sp.spriteName = 'card' .. (UnityEngine.PlayerPrefs.GetInt('paiMian', 1) == 1 and '_' or '1_') .. zhi
end

function this.changePaiMian(paiMian)
    if paiMian == 1 then
        for k, v in pairs(allCards) do
            local str = v.spriteName
            v.spriteName = string.gsub(str, '1_', '_')
        end
    else
        for k, v in pairs(allCards) do
            local str = v.spriteName
            local index = string.find(str, '_')
            v.spriteName = 'card1'..string.sub(str,index)
        end
    end
end

function this.RefreshGridXiLabel(grid, ROperationPlate)
    grid.gameObject:SetActive(true)
    for i = 0, grid.childCount - 1 do
        if i < #ROperationPlate then
            local group = ROperationPlate[i + 1]
            local item = grid:GetChild(i)
            local str = ''
            if group.operation == phz_pb.CHI then
                table.sort(group.plates, tableSortDesc)
                if (group.plates[1] == group.plates[2]) or (group.plates[2] == group.plates[3]) then
                    group.operation = phz_pb.JIAO
                else
                    group.operation = phz_pb.JU
                end
            end

            if group.operation == phz_pb.JU then
                str = '句'
            elseif group.operation == phz_pb.JIAO then
                str = '绞'
            elseif group.operation == phz_pb.DUI then
                str = '对'
            elseif group.operation == phz_pb.PENG then
                str = '碰'
            elseif group.operation == phz_pb.WEI or group.operation == phz_pb.CHOU_WEI then
                str = '偎'
            elseif group.operation == phz_pb.KAN then
                str = '坎'
            elseif group.operation == phz_pb.PAO then
                str = '跑'
            elseif group.operation == phz_pb.TI or group.operation == phz_pb.START_TI then
                str = '提'
            else
                Debugger.LogError('RefreshGridXiLabel unkown type {0}', tostring(group.operation))
            end
            item.gameObject:SetActive(true)
            item:GetComponent('UILabel').text = str
        else
            grid:GetChild(i).gameObject:SetActive(false)
        end
    end
    grid:GetComponent('UIGrid').repositionNow = true
end

function this.RefreshAllGridXi()
    for i = 0, 3 do
        local pData = this.GetPlayerDataByUIIndex(i)
        if pData and i < roomData.setting.size then
            RefreshGridXi(playerGridXi[i], playerGridXi, pData.menZi,{})
        else
            RefreshGridXi(playerGridXi[i], playerGridXi, {},{})
        end
    end
end

function RefreshTabelThrow(UItabel, plates, seat)
    print(string.format('RefreshTabelThrow:%s num:%d', UItabel.parent.gameObject.name, #plates))
    for j = UItabel.childCount, #plates - 1 do
        local card = ResourceManager.Instance:LoadAssetSync('card')
        local obj = NGUITools.AddChild(UItabel.gameObject, card)
    end
    for i = 0, UItabel.childCount - 1 do
        if i < #plates then
            local item = UItabel:GetChild(i)
            this.setPaiMian(item:Find('plate'), plates[i + 1])
            SetUserData(item.gameObject, plates[i + 1])
            item.gameObject:SetActive(true)
        else
            UItabel:GetChild(i).gameObject:SetActive(false)
        end
    end
    UItabel:GetComponent('UITable'):Reposition()
end

function this.SetPlateEffectShow(UItabel, plates, seat, isMoPai)
    if seat == lastOperat.seat and plates[#plates] == lastOperat.plate then
        curOperatPlateEffect.gameObject:SetActive(not isMoPai)
        moOperatPlateEffect.gameObject:SetActive(isMoPai)
        curOperatPlateEffect.position = UItabel:GetChild(#plates - 1).position
        moOperatPlateEffect.position = UItabel:GetChild(#plates - 1).position
        UItabel:GetChild(#plates - 1):GetComponent("UISprite").color = Color(1, 1, 1, 1)
    end
end

function this.RefreshAllTabelThrow()
    for i = 0, 3 do
        local pData = this.GetPlayerDataByUIIndex(i)
        if pData and i < roomData.setting.size then
            playerThrow[i].gameObject:SetActive(true)
            RefreshTabelThrow(playerThrow[i], pData.paiHe, pData.seat)
        else
            playerThrow[i].gameObject:SetActive(false)
        end
    end
end

function this.RefreshAllXiNum()
    for i = 0, 3 do
        local pData = this.GetPlayerDataByUIIndex(i)
        if pData and i < roomData.setting.size then
            playerXiNum[i].gameObject:SetActive(true)
            if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
                local ind = this.GetUIIndexBySeat(pData.seat)
                playerXiNum[ind]:GetComponent('UILabel').text = (pData.halfScore > 0 and '+' or '')..pData.halfScore..'胡'
            else
                playerXiNum[i]:GetComponent('UILabel').text = '胡息:'..pData.deskHuXi
            end
        else
            playerXiNum[i].gameObject:SetActive(false)
            playerXiNum[i]:GetComponent('UILabel').text = roomData.setting.roomTypeValue == proxy_pb.YXPHZ and '0胡' or '胡息:0'
        end
    end
end

this.tingQueues=nil
function this.OnGetTingPai(msg)
   --print('收到服务器听牌的数据')
    local b = phz_pb.RTingPai()
    b:ParseFromString(msg.body)
   --print('数据长度'..#b.queues)
    if ButtonHu.gameObject.activeSelf then
        this.tingQueues=nil
        this.refreshWillTingMark()
    else
        this.tingQueues=b.queues
        -- for i=1,#this.tingQueues do
        --    --print('数据值为'..this.tingQueues[i].plate)
        -- end
        this.refreshWillTingMark()
    end
end

--刷新手牌上的听标记
function this.refreshWillTingMark()
    if this.tingQueues~=nil then
        for i = 0, playerGridHand.childCount - 1 do
            local item = playerGridHand:GetChild(i)
            if item.gameObject.activeSelf then
                if item.gameObject.name=='cardGroupHand' then
                    for j = 0, item.childCount - 1 do
                        local card = item:GetChild(j)
                        card:Find('bg/ting').gameObject:SetActive(false)
                        local pValue = GetUserData(card.gameObject)
                        if pValue~=nil then
                            ----print('牌的值为'..pValue)
                            for k=1,#this.tingQueues do
                                if pValue==this.tingQueues[k].plate then
                                    card:Find('bg/ting').gameObject:SetActive(true)
                                    card:Find('bg/ting'):GetComponent('UISprite').depth = card:Find('bg/plate1'):GetComponent('UISprite').depth+1
                                    break
                                end
                            end
                        end
                    end
                else
                    item:Find('bg/ting').gameObject:SetActive(false)
                    local pValue = GetUserData(item.gameObject)
                    if pValue~=nil then
                        ----print('牌的值为'..pValue)
                        for k=1,#this.tingQueues do
                            if pValue==this.tingQueues[k].plate then
                                item:Find('bg/ting').gameObject:SetActive(true)
                                item:Find('bg/ting'):GetComponent('UISprite').depth = item:Find('bg/plate1'):GetComponent('UISprite').depth+1
                                break
                            end
                        end
                    end
                end
            end
        end
    else
        for i = 0, playerGridHand.childCount - 1 do
            local item = playerGridHand:GetChild(i)
            if item.gameObject.activeSelf then
                if item.gameObject.name=='cardGroupHand' then
                    for j = 0, item.childCount - 1 do
                        item:GetChild(j):Find('bg/ting').gameObject:SetActive(false)
                    end
                else
                    item:Find('bg/ting').gameObject:SetActive(false)
                end
            end
        end
    end
end

--单点换牌操作
function this.OnClickCard(go)
    local num = 0
    local maxPos = Vector3(0,0,0)
    local maxTransform = nil
    local changePos = Vector3(0,0,0)
    local changeTransform = nil
    local paiGrid = go.transform.parent
    local gridHeight = keepTwoDecimalPlaces(paiGrid:GetComponent('UIGrid').cellHeight)
    for i = 0, paiGrid.childCount - 1 do
        local pai = paiGrid:GetChild(i)
        if pai.gameObject.activeSelf then
            num=num+1
            if keepTwoDecimalPlaces(pai.localPosition.y) == keepTwoDecimalPlaces(go.transform.localPosition.y) + gridHeight then
                changePos = Vector3(pai.localPosition.x,pai.localPosition.y,pai.localPosition.z)
                changeTransform = pai
            end
            if maxPos.y < pai.localPosition.y then
                maxPos = Vector3(pai.localPosition.x,pai.localPosition.y,pai.localPosition.z)
                maxTransform = pai
            end
        end
    end
    if changeTransform and num>=2 and maxPos.y ~= go.transform.localPosition.y then
        local myValue = GetUserData(go)
        local changeValue = GetUserData(changeTransform.gameObject)
        local myTing = go.transform:Find('bg/ting').gameObject.activeSelf
        local changeTing = changeTransform:Find('bg/ting').gameObject.activeSelf
        this.setPaiMian(go.transform:Find('bg/plate0'), changeValue)
        this.setPaiMian(go.transform:Find('bg/plate1'), changeValue)
        this.setPaiMian(changeTransform:Find('bg/plate0'), myValue)
        this.setPaiMian(changeTransform:Find('bg/plate1'), myValue)
        go.transform:Find('bg/ting').gameObject:SetActive(changeTing)
        changeTransform:Find('bg/ting').gameObject:SetActive(myTing)
        SetUserData(go, changeValue)
        SetUserData(changeTransform.gameObject, myValue)
    end
end

function this.OnDragStartPlate()
    --print('OnDragStartPlate')
    local draggeGO = UICamera.currentTouch.dragged
    draggeGO.transform:Find('bg'):GetComponent('UISprite').depth = 50
    draggeGO.transform:Find('bg/plate0'):GetComponent('UISprite').depth = 51
    draggeGO.transform:Find('bg/plate1'):GetComponent('UISprite').depth = 52
    draggeGO.transform:Find('bg/ting'):GetComponent('UISprite').depth = 53
    
    if this.tingQueues~=nil then
        local plate = GetUserData(draggeGO)
        for i=1,#this.tingQueues do
            if this.tingQueues[i].plate==plate then
                myTingPlates=this.tingQueues[i].tingPlates
                this.setTingPai(nil, true)
                break
            end
        end
    end
    line.gameObject:SetActive(needChuPai)
end

local paramter = {};
function this.OnDragEndtPlate()
    print('OnDragEndPlate')
    local draggeGO = UICamera.currentTouch.dragged
    
    if draggeGO.transform:Find('bg/ting').gameObject.activeSelf then
        myTingPlates=nil
        this.setTingPai(nil, true)
    end
    
    if needChuPai then
        if connect.IsConnect then
            if draggeGO.transform.position.y > line.position.y and ButtonHu.gameObject.activeInHierarchy==false then
                local plate = GetUserData(draggeGO)
                --print('drag card id:'..plate)
                dragObj = draggeGO
                paramter.mySeat = mySeat;
                paramter.plate = plate;
                paramter.position1 = playerIcon[0].position
                paramter.position2 = playerMoPaiPos[0].position
                if #chouPlates > 0 then
                    print('chouPlates length : '..#chouPlates..' plate :'..plate)
                    for i = 1, #chouPlates do
                        if chouPlates[i] == plate then
                            RefreshMyGridHand(playerGridHand, this.GetPlayerDataBySeat(mySeat))
                            return 
                        end
                    end
                end
                if this.HaveWei(plate) and roomData.setting.roomTypeValue ~= proxy_pb.YJGHZ and roomData.setting.roomTypeValue ~= proxy_pb.AHPHZ then
                    panelMessageBoxTiShi.SetParamers(OK_CANCLE, this.OnClickMsgBoxOk, nil, '该牌有玩家偎，打出该牌后不能动张，是否打出？')
                    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
                elseif this.HaveWuFuWarn(plate) then
                    panelMessageBoxTiShi.SetParamers(OK_CANCLE, this.OnClickWuFuWeanOK, this.OnClickWuFuWeanCancle, '是否需要五福报警？',nil,'不需要')
                    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
                else
                    this.SendChuPaiMsg(plate, draggeGO)
                    -- dragObj:SetActive(false)
                    local dragCardPos = dragObj.transform.position
                    this.playPaiAnimation(mySeat, plate, dragCardPos, playerMoPaiPos[0].position,
                    Vector3.one, Vector3.one * 0.8, false, true, true)
                
                    AudioManager.Instance:PlayAudio('chupai')
    
                    coroutine.start(
                    function()
                        coroutine.wait(0.1)
    
                        local audioName = ""
                        if UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 1 then
                            audioName = string.format('pai_%d_%d', 1, plate)
                        elseif UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 0 then
                            if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
                                audioName = string.format('f_17_pai_%d_%d', 1, plate)
                            elseif roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
                                audioName = string.format('f_18_pai_%d_%d', 1, plate)
							elseif roomData.setting.roomTypeValue == proxy_pb.AHPHZ then
                                audioName = string.format('f_19_pai_%d_%d', 1, plate)
                            else
                                audioName = string.format('fpai_%d_%d', 1, plate)
                            end
                        end
                        AudioManager.Instance:PlayAudio(audioName)
                    end
                    )
                end
            end
        else
            panelMessageTip.SetParamers('当前网络不通', 2)
            PanelManager.Instance:ShowWindow('panelMessageTip')    
        end
    end

    this.SetGridXiDepth(draggeGO.transform.parent:GetComponent('UIGrid'))
    this.RefreshHandPlatesGrid(playerGridHand)
    line.gameObject:SetActive(false)
end

function this.OnClickWuFuWeanOK()
    local msg = Message.New()
	msg.type = phz_pb.WUFU_WARNING
	local body = phz_pb.PChoiceWarning()
	body.isWarning = true
    msg.body = body:SerializeToString()
    SendGameMessage(msg, nil)
    this.OnClickMsgBoxOk()
end
function this.OnClickWuFuWeanCancle()
    local msg = Message.New()
	msg.type = phz_pb.WUFU_WARNING
	local body = phz_pb.PChoiceWarning()
    body.isWarning = false
    msg.body = body:SerializeToString()
    SendGameMessage(msg, nil)
    this.OnClickMsgBoxOk()
end

function this.OnChoiceWarning(msg)
    local data = phz_pb.RChoiceWarning()
    data:ParseFromString(msg.body)
    local inx = this.GetUIIndexBySeat(data.seat)
    playerWarn[inx].gameObject:SetActive(true)
    if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
		AudioManager.Instance:PlayAudio('f_17_baojing_1')
	end
end
--刷新手牌的Grid
function this.RefreshHandPlatesGrid(pGridHand)
    StartCoroutine(function()
        WaitForEndOfFrame()
        for i = 0, pGridHand.childCount - 1 do
            local group = pGridHand:GetChild(i)
            local grid = group:GetComponent('UIGrid')
            if grid then
                grid.repositionNow = true
                local active = false
                for j = 0, group.childCount - 1 do
                    if group:GetChild(j).gameObject.activeSelf then
                        active = true
                        break
                    end
                end
                group.gameObject:SetActive(active)
            end
        end
        pGridHand:GetComponent('UIGrid').repositionNow = true
    end)
end

function this.OnClickMsgBoxOk()
    this.playPaiAnimation(paramter.mySeat, paramter.plate, paramter.position1, paramter.position2,Vector3.zero, Vector3.one * 0.8, false, true, true)
    AudioManager.Instance:PlayAudio('chupai');
    coroutine.start(
        function()
            coroutine.wait(0.1);
            local audioName = "";
            if UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 1 then
                audioName = string.format('pai_%d_%d', 1, paramter.plate)
            elseif UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 0 then
                if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
                    audioName = string.format('f_17_pai_%d_%d', 1, paramter.plate)
                elseif roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
                    audioName = string.format('f_18_pai_%d_%d', 1, paramter.plate)
				elseif roomData.setting.roomTypeValue == proxy_pb.AHPHZ then
                    audioName = string.format('f_19_pai_%d_%d', 1, paramter.plate)
                else
                    audioName = string.format('fpai_%d_%d', 1, paramter.plate)
                end
            end
            AudioManager.Instance:PlayAudio(audioName)
        end)
    this.SendChuPaiMsg(GetUserData(dragObj), dragObj)
end

function this.SetGridXiDepth(grid)
    if not IsNil(grid) then
        StartCoroutine(
        function()
            WaitForSeconds(0.1)
            if not IsNil(grid) then
                if playerGridHand:GetComponent('UIGrid'):GetIndex(grid.transform) == -1 then
                    return
                end
                
                for i = 0, grid.transform.childCount-1 do
                    local obj = grid:GetChild(i)
                    if not obj then
                        break
                    end
                    obj:Find('bg'):GetComponent('UISprite').depth = i * 4 + 5
                    obj:Find('bg/plate0'):GetComponent('UISprite').depth = i * 4 + 6
                    obj:Find('bg/plate1'):GetComponent('UISprite').depth = i * 4 + 6
                    obj:Find('bg/mask'):GetComponent('UISprite').depth = i * 4 + 7
                    obj:Find('bg/ting'):GetComponent('UISprite').depth = i * 4 + 8
                end
            end
        end
        )
    end
end

function this.SendChuPaiMsg(plate, dragObj)
    print('SendChuPaiMsg................')
    local msg = Message.New()
    msg.type = phz_pb.CHU_PAI
    local body = phz_pb.POperation()
    body.plate = plate
    msg.body = body:SerializeToString()
    SendGameMessage(msg, nil)
    needChuPai = false
    dragObj:SetActive(false)
    chupaishoushi.gameObject:SetActive(false)
end

function this.HaveWuFuWarn(plate)
    if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
        print('mySeat: '..mySeat)
        local p = this.GetPlayerDataBySeat(mySeat)
        local num = 0
        for i = 1, #p.menZi do
            if num == 3 then
                if p.menZi[i].operation == phz_pb.WEI or p.menZi[i].operation == phz_pb.CHOU_WEI or p.menZi[i].operation == phz_pb.PENG then
                    local myList = {}
                    if p.hands then
                        for k = 1, #p.hands do
                            local value = p.hands[k]
                            if not myList[value] then
                                myList[value]={}				
                                myList[value].num = 0--牌的个数
                            end
                            myList[value].num = myList[value].num + 1
                        end
                    end
                    for k = 0, 19 do
                        if myList[k] then
                            if myList[k].num == 2 and k ~= plate then
                                return true
                            end
                        end
                    end
                end
            end
            if p.menZi[i].operation == phz_pb.WEI or p.menZi[i].operation == phz_pb.CHOU_WEI or p.menZi[i].operation == phz_pb.TI or p.menZi[i].operation == phz_pb.PENG then
                num = num + 1
            end
        end
    end
    return false
end
function this.HaveWei(plate)
    if roomData.setting.roomTypeValue == proxy_pb.HHHGW 
    or roomData.setting.roomTypeValue == proxy_pb.CSPHZ 
	or roomData.setting.roomTypeValue == proxy_pb.AHPHZ 
    or roomData.setting.roomTypeValue == proxy_pb.CDPHZ
    or roomData.setting.roomTypeValue == proxy_pb.CDDHD
    or roomData.setting.roomTypeValue == proxy_pb.HSPHZ
    or roomData.setting.roomTypeValue == proxy_pb.NXPHZ
    or roomData.setting.roomTypeValue == proxy_pb.YXPHZ
    or ((roomData.setting.roomTypeValue == proxy_pb.HYSHK or roomData.setting.roomTypeValue == proxy_pb.HYLHQ or roomData.setting.roomTypeValue == proxy_pb.XTPHZ) and not roomData.setting.canMingWei) then
        return false
    end

    for i = 1, #playerData do
        local p = playerData[i]
        for j = 1, #p.menZi do
            if p.menZi[j].operation == phz_pb.WEI and p.menZi[j].plates[1] == plate then
                return true
            end
        end
    end
    return false
end

function this.OnRoundStart(msg)
   print('OnRoundStart')
    local b = phz_pb.RRoundStart()
	local status, err
    b:ParseFromString(msg.body)
    GPS.transform.gameObject:SetActive(false)
    if panelInGame.needXiPai==true then
        panelInGame.needXiPai=false
        connect.IsZanTing=true
        local xipaiData = {};
        xipaiData.needChangeAtlas = false;
        xipaiData.finishedFun = function()
			--this.gameStart(b)
			status, err = pcall(this.gameStart, b)
            connect.IsZanTing=false
			if not status then
				this.OnClickButtonRefresh(nil)
				Debugger.LogError("gameStart err ".. err)
			end
		end
		PanelManager.Instance:ShowWindow('panelXiPai_ziPai',xipaiData);
	else
		status, err = pcall(this.gameStart, b)
		if not status then
			this.OnClickButtonRefresh(nil)
			Debugger.LogError("gameStart err ".. err)
		end
	end
end

function this.gameStart(b)
    allCards={}--清空所有记录的牌
    playerData = {}
    for i = 1, #b.players do
        local p = b.players[i]
        p.sex = p.sex == 0 and 1 or p.sex
        table.insert(playerData, p)
    end
    roomData.bankerSeat = b.bankerSeat
    roomData.state = phz_pb.GAMING

    this.RsetWhenStateChange()

    this.SetRoundNum(roomData.round)
    RefreshMyGridHand(playerGridHand, this.GetPlayerDataBySeat(mySeat))
    this.RefreshAllXiNum()
    this.RefreshAllGridXi()
    this.RefreshAllTabelThrow()
    this.SetReadyVisiable()
    this.RefreshPlayer()
    RestTime.gameObject:SetActive(false)
    if roomData.round == 1 and not (roomData.setting.size == 2) then
        local datas = {}
		for i = 0, roomData.setting.size - 1 do
			datas[i] = this.GetPlayerDataByUIIndex(i)
		end
        InspectIPAndGPS(datas,roomData.setting.size == 3 and pos3 or pos4,this.OnClicButtonDisbandRoom)   
    end
    if roomData.round == 1 then
        AudioManager.Instance:PlayAudio('gamebegin')
    else
        AudioManager.Instance:PlayAudio('fapai')
    end
    --有可能在重连上来后 还在小解算 需要将小解算隐藏
    if PanelManager.Instance:IsActive('panelStageClear') then
        this.hasStageClear = false
        PanelManager.Instance:HideWindow('panelStageClear')
    end
end

function this.OnClicButtonDisbandRoom(go)
    AudioManager.Instance:PlayAudio('btn')
    local msg = Message.New()
    msg.type = phz_pb.DISSOLVE
    local body = phz_pb.PDissolve()
    body.decision = phz_pb.APPLY
    msg.body = body:SerializeToString()
    SendGameMessage(msg, nil);
end
this.hasStageClear=false;
function this.OnRoundEnd(msg)
    print('OnRoundEnd was called');
    this.hasStageClear=true
    ButtonTing.gameObject:SetActive(false)
    local b = phz_pb.REnd()
    b:ParseFromString(msg.body)
    RoundData.data = b
    RoundData.mySeat = mySeat
    RoundData.playerData = playerData
    RoundData.playerIcon = playerIcon
    RoundData.setting = roomData.setting
	RoundData.isInGame = true
    roomData.state = phz_pb.READYING
    
    if b.gameOver==false then
        roomData.round = roomData.round + 1
        RoundData.over = false
    else
        RoundData.over = true
    end

    print('b.gameOver', tostring(b.gameOver))
    print('RoundData.over:' .. tostring(RoundData.over))
    for i = 1, #playerData do
        playerData[i].ready = false
        playerData[i].piao = -1
    end
    -- if roomData.setting.roomTypeValue == proxy_pb.SYBP or roomData.setting.roomTypeValue == proxy_pb.LDFPF or roomData.setting.roomTypeValue == proxy_pb.XXGHZ then
    --     roomData.round = roomData.round + 1
    -- end
    this.ShowWaitOpreatEffect(b.seat, false)
    kuang01[this.GetUIIndexBySeat(b.seat)].gameObject:SetActive(false)
    stageClearCor = coroutine.start(
    function()
		connect.IsZanTing=true
        coroutine.wait(1.5)
        this.StageClear(b)
    end
    )

   --print('RoundData.over:' .. tostring(RoundData.over))
end

local huTypeName = {[phz_pb.TIAN_HU] = '天胡',
[phz_pb.DI_HU] = '地胡',
[phz_pb.HEI_HU] = '黑胡',
[phz_pb.HONG_HU] = '红胡',
[phz_pb.DIAN_HU] = '点胡',
[phz_pb.WU_HU] = '乌胡',
[phz_pb.PENG_PENG_HU] = '碰碰胡',
[phz_pb.SHI_BA_DA] = '十八大',
[phz_pb.SHI_LIU_XIAO] = '十六小',
[phz_pb.HAI_DI_HU] = '海底胡',
[phz_pb.YI_DIAN_HONG] = '一点红',
[phz_pb.PU_TONG_HU] = '',
[phz_pb.YI_KUAI_BIAN] = '一块匾',
[phz_pb.SHI_SAN_HONG] = '十三红',
[phz_pb.SHI_HONG] = '十红',
[phz_pb.KA_HU_20] = '20卡胡',
[phz_pb.KA_HU_30] = '30卡胡',
[phz_pb.ZI_MO] = '自摸',
[phz_pb.TING_HU] = '听胡',
[phz_pb.DA_HU] = '大胡'    ,
[phz_pb.XIAO_HU] = '小胡',
[phz_pb.DUI_DUI_HU] = '对子胡',
[phz_pb.SHUA_HOU] = '耍猴',
[phz_pb.HUANG_FAN] = '黄番'    ,
[phz_pb.SHI_BA_XIAO] = '十八小',
[phz_pb.ER_BI] = '二比',
[phz_pb.SAN_BI] = '三比',
[phz_pb.SI_BI] = '四比',
[phz_pb.SHUANG_PIAO] = '双飘',
[phz_pb.DA_HONG]='大红',
[phz_pb.XIAO_HONG]='小红',
[phz_pb.PIAO_HU]='飘胡'
}

function this.getHuTypeName(TYPE)
    return huTypeName[TYPE]
end

function this.StageClear(data)
   --print('StageClear hupai seat:' .. data.seat)
    this.tingQueues=nil
    this.refreshWillTingMark()
    this.stopAllPaiAnimiation()
    operation_send.gameObject:SetActive(false)
    chupaishoushi.gameObject:SetActive(false)
    Util.ClearChild(playerGridHand)
    playerGridHand.gameObject:SetActive(false)
    curOperatPlateEffect.gameObject:SetActive(false)
    moOperatPlateEffect.gameObject:SetActive(false)
    dipai.gameObject:SetActive(false)
    for i = 0, 3 do
        playerPiao[i].gameObject:SetActive(false)
    end
    chouPlates = {}
    this.RsetWhenStateChange()

    for i = 1, #data.players do
        local playerData = data.players[i]
        local uiIndex = this.GetUIIndexBySeat(playerData.seat)
        print("玩家坐位" .. playerData.seat .. "结算刷新分数：" .. playerData.total)
        playerScore[uiIndex]:GetComponent('UILabel').text = playerData.total
        Util.ClearChild(playerThrow[uiIndex])
        playerThrow[uiIndex].gameObject:SetActive(false)
        kuang01[uiIndex].gameObject:SetActive(false)
    end
    this.initHandGridAndEffect()
    PanelManager.Instance:HideWindow('panelChat')
    PanelManager.Instance:HideWindow('panelChiPai')
    DelegateTime.gameObject:SetActive(false);
    DelegatePanel.gameObject:SetActive(false);
    coroutine.stop(trusteeshipcor);

   --print('是不是自动解散：'..tostring(IsAutoDissolve))
    --if not IsAutoDissolve then
        PanelManager.Instance:ShowWindow('panelStageClear',function()
		    connect.IsZanTing=false
        end)
    --else
        --PanelManager.Instance:ShowWindow('panelAutoDissolve', AutoDissolveData)
    --end
    stageClearCor = nil
end

function this.OnReady(msg)
    --print('OnReady')
    local b = phz_pb.RSeat()
    b:ParseFromString(msg.body)
    local ix = this.GetUIIndexBySeat(b.seat)
    playerReady[ix].gameObject:SetActive(true)
    this.GetPlayerDataBySeat(b.seat).ready = true

    this.RsetWhenStateChange()
    this.CheckNeedOpenPlayPiao()
    this.CheckNeedOpenPlayNiao()
    this.CheckNeedOpenPlayTuo()

    this.NotifyGameStart()
    if b.seat == mySeat then
        this.hasStageClear = false;
    end
end

function this.OnDisconnected(msg)
   --print('OnDisconnected')
    local b = phz_pb.RSeat()
    b:ParseFromString(msg.body)
    local i = this.GetUIIndexBySeat(b.seat)
    this.GetPlayerDataBySeat(b.seat).connected = false
    playerOffline[i].gameObject:SetActive(true)
    --断线后停止托管的倒计时
    if b.seat == mySeat then
        offlineState = true;
    end
    coroutine.stop(trusteeshipcor);

    this.StartOfflineIncrease(b.seat, 0)
end
--获取摸的牌的对象
local curPaisIndex = 0
function this.getCurPai()
    for i=0,curPais.childCount-1 do
        local isFree = GetUserData(curPais:GetChild(i).gameObject)
        if isFree==nil or isFree==true then
            SetUserData(curPais:GetChild(i).gameObject,false)
            return curPais:GetChild(i)
        end 
    end
end

local animSpeedScale = 0.1
function this.playPaiAnimation(seat, plate, posFrom, posTo, scaleFrom, scaleTo, isMoPai, addToPaiHe, showPlate)
    print(string.format('playPaiAnimation seat:%d plate:%d isMoPai:%s addToPaiHe:%s', seat, plate, tostring(isMoPai), tostring(addToPaiHe)))
    if seat~=mySeat or isMoPai==true then
        StartCoroutine(function()
            connect.IsZanTing=true
           --print('暂停了'..os.date())
            if UnityEngine.PlayerPrefs.GetInt("animaSpeed", 1) == 0 then
                WaitForSeconds(1.2)
            elseif UnityEngine.PlayerPrefs.GetInt("animaSpeed", 1) == 1 then
                WaitForSeconds(1.0)
            elseif UnityEngine.PlayerPrefs.GetInt("animaSpeed", 1) == 2 then
                WaitForSeconds(0)
            end
            connect.IsZanTing=false
           --print('开始了了'..os.date())
        end)
    end
    
    print("牌大小："..scaleTo.x)
    if UnityEngine.PlayerPrefs.GetInt("animaSpeed", 1) == 0 then
        animSpeedScale = 0.3
    elseif UnityEngine.PlayerPrefs.GetInt("animaSpeed", 1) == 1 then
        animSpeedScale = 0.15
    elseif UnityEngine.PlayerPrefs.GetInt("animaSpeed", 1) == 2 then
        animSpeedScale = 0
    end

   
    local curPai = this.getCurPai()
    print("获取的的牌名称"..curPai.gameObject.name)
    this.setPaiMian(curPai:Find('plate0'), plate)
    this.setPaiMian(curPai:Find('plate1'), plate)
    local index = this.GetUIIndexBySeat(seat)
    if index ~= 0 then
        curPai:GetComponent('UISprite').spriteName = 'Card_half_Big_001'
        curPai:Find('mesh_lan').gameObject:SetActive(false)
        curPai:Find('mesh_cheng').gameObject:SetActive(true)
       --print('ui座位' .. index)
    else
        curPai:GetComponent('UISprite').spriteName = 'Card_half_Big_001'
        curPai:Find('mesh_lan').gameObject:SetActive(true)
        curPai:Find('mesh_cheng').gameObject:SetActive(false)
       --print('ui座位' .. index)
    end
    curPai:Find('mask_bg').gameObject:SetActive(not showPlate and true or false)


    local anima = {}
    anima.addToPaiHe = addToPaiHe
    anima.seat = seat
    anima.plate = plate
    anima.curPai = curPai
    anima.posTo=posTo
    anima.scaleTo=scaleTo
    anima.posFrom=posFrom
    anima.scaleFrom=scaleFrom
    anima.isMoPai=isMoPai
    
   --print('出牌动画数目'..#paiAnimations)
    if anima.addToPaiHe==true then
        table.insert(paiAnimations, anima)
        this.shouPaiAnimation(anima)--收牌动画
    else
        this.chuPaiAnimation(anima)
    end
end

function this.chuPaiAnimation(anima)
    anima.cor = StartCoroutine(
    function()
        local curPai=anima.curPai
        curPai.gameObject:SetActive(true)
        
        curPai:GetComponent('TweenPosition'):ResetToBeginning()
        curPai:GetComponent('TweenPosition').worldSpace = true
        curPai:GetComponent('TweenPosition').from = anima.posFrom
        curPai:GetComponent('TweenPosition').to = anima.posTo
        curPai:GetComponent('TweenPosition').duration = animSpeedScale
        curPai:GetComponent('TweenPosition'):PlayForward()
        curPai:GetComponent('TweenScale'):ResetToBeginning()
        curPai:GetComponent('TweenScale').from = anima.scaleFrom
        curPai:GetComponent('TweenScale').to = anima.scaleTo
        curPai:GetComponent('TweenScale').duration = animSpeedScale
        curPai:GetComponent('TweenScale'):PlayForward()
        curPai:Find('mopailight').gameObject:SetActive(anima.isMoPai)
        curPai:Find('chupailight').gameObject:SetActive(not isMoPai)

        WaitForSeconds(curPai:GetComponent('TweenPosition').duration)
        WaitForEndOfFrame()
        curPai.localScale=anima.scaleTo
        curPai.position=Vector3(anima.posTo.x,anima.posTo.y,anima.posTo.z+0.01)
       --print('摸牌动画赋值' .. anima.plate .. '|' .. curPai.gameObject.name)
        if anima.addToPaiHe ~= true then   
            StartCoroutine(function()
                WaitForSeconds(1)
                curPai.gameObject:SetActive(false)
                SetUserData(curPai.gameObject,true)
            end)
        end
    end)
end

function this.shouPaiAnimation(anima)
   --print('动画数目'..#paiAnimations)
    if #paiAnimations > 1 then
        local lastPai = paiAnimations[1].curPai
           --print('最后一张牌gb ' .. lastPai.gameObject.name)
            local shouPai = StartCoroutine(
            function()
                local index = this.GetUIIndexBySeat(paiAnimations[1].seat)
                this.GetPlayerDataBySeat(paiAnimations[1].seat).paiHe:append(paiAnimations[1].plate)
                RefreshTabelThrow(playerThrow[index], this.GetPlayerDataBySeat(paiAnimations[1].seat).paiHe, paiAnimations[1].seat)
                
                local uiObj = playerThrow[index]:GetChild(#this.GetPlayerDataBySeat(paiAnimations[1].seat).paiHe - 1)
               --print('最后出的牌' .. uiObj.gameObject.name)
                uiObj.gameObject:SetActive(false)
                curOperatPlateEffect.gameObject:SetActive(false)
                moOperatPlateEffect.gameObject:SetActive(false)

                lastPai:GetComponent("TweenPosition"):ResetToBeginning()
                lastPai:GetComponent('TweenPosition').worldSpace = true
                lastPai:GetComponent("TweenPosition").from = paiAnimations[1].posTo
                lastPai:GetComponent("TweenPosition").to = uiObj.position
                lastPai:GetComponent("TweenPosition").duration = 0 --animSpeedScale
                lastPai:GetComponent("TweenPosition"):PlayForward()
                lastPai:GetComponent("TweenScale"):ResetToBeginning()
                lastPai:GetComponent("TweenScale").from = Vector3.one
                lastPai:GetComponent("TweenScale").to = Vector3.zero
                lastPai:GetComponent("TweenScale").duration = 0 --animSpeedScale * 0.9
                lastPai:GetComponent("TweenScale"):PlayForward()


                WaitForSeconds(lastPai:GetComponent("TweenPosition").duration)
                uiObj.gameObject:SetActive(true)
               --print('显示最后出的牌' .. uiObj.gameObject.name)
                uiObj:GetComponent("UISprite").color = Color(1, 1, 1, 1)

                SetUserData(lastPai.gameObject,true)
                lastPai.gameObject:SetActive(false)
               --print('收牌了数目'..#paiAnimations)
                
                table.remove(paiAnimations, 1)
               --print('remove playPaiAnimation seat:' .. paiAnimations[1].seat .. ' plate:' .. paiAnimations[1].plate)
                
                this.chuPaiAnimation(anima)
            end)    
    else
        this.chuPaiAnimation(anima)
    end
end

--出的牌的拖拽回调
function this.OnCurPaiDragEnd(go)
    --go.transform.position = oldCurPaiPosition
end

function this.stopPaiAnimiation(seat, plate)
   --print('stopPaiAnimiation seat:' .. seat .. ' plate:' .. plate)
    local anima = nil
    -- local index = this.GetUIIndexBySeat(seat)
   --print('停止动画摧毁数目'..#paiAnimations)
    if #paiAnimations>0 then
        anima = paiAnimations[1]
        if GetUserData(anima.curPai.gameObject)==false then
           --print('动画还没完！！！！！' .. anima.curPai.gameObject.name)
        end

        StopCoroutine(anima.cor)
        anima.curPai.localScale=anima.scaleTo
        anima.curPai.position=Vector3(anima.posTo.x,anima.posTo.y,anima.posTo.z+0.01)
        SetUserData(anima.curPai.gameObject,true)
        anima.addToPaiHe = false
        anima.curPai.gameObject:SetActive(false)
        table.remove(paiAnimations, 1)
    end
    
end

function this.stopAllPaiAnimiation()
    local anima = nil
    if #paiAnimations>0 then
        for i = #paiAnimations, 1, -1 do
            anima = paiAnimations[i]
            if GetUserData(anima.curPai.gameObject)==false then
               --print('all动画还没完！！！！！' .. anima.curPai.gameObject.name)
            end
            StopCoroutine(anima.cor)
            anima.curPai.localScale=anima.scaleTo
            anima.curPai.position=Vector3(anima.posTo.x,anima.posTo.y,anima.posTo.z+0.01)
            SetUserData(anima.curPai.gameObject,true)
            anima.addToPaiHe = false
            anima.curPai.gameObject:SetActive(false)
        end
    end
    
    paiAnimations = {}
   --print('停止所有 动画摧毁')
end

function this.OnPlayerMoPai(msg)
    local b = phz_pb.RMoPai()
    b:ParseFromString(msg.body)
    --print('OnPlayerMoPai:' .. b.plate .. ' seat:' .. b.seat .. ' toHand:' .. tostring(b.toHand) .. ' display:' .. tostring(b.display)..' handCount:'..b.handCount)

    local index = this.GetUIIndexBySeat(b.seat)
    needChuPai = false
    if b.toHand then
        if b.seat == mySeat then
            this.GetPlayerDataBySeat(b.seat).hands:append(b.plate)
            --print('服务器发给我的听牌数目' .. #b.tingPlates)
            RefreshMyGridHand(playerGridHand, this.GetPlayerDataBySeat(mySeat))

            if b.seat == roomData.bankerSeat then
                if #this.GetPlayerDataBySeat(b.seat).hands ~= 21 then
                    this.ShowTipEffect('buEffect', b.seat)
                end
                needChuPai = true
            else
                this.ShowTipEffect('buEffect', b.seat)
            end
        end
    end

    if this.checkCardNum(b.plate)==false then
        return
    end

    this.playPaiAnimation(b.seat, b.plate, dipai.position, playerMoPaiPos[index].position,
            Vector3.zero, Vector3.one * 0.8, true, not b.toHand, b.display)

    local index = this.GetUIIndexBySeat(b.seat)
    chupaishoushi.gameObject:SetActive(needChuPai)

    dipai:Find('Label'):GetComponent('UILabel').text = string.format('%d张', b.surplus)
    AudioManager.Instance:PlayAudio('chupai')
    if b.display then
        coroutine.start(
                function()
                    coroutine.wait(0.1)
                    local audioName = ""
                    if UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 1 then
                        --print('有人提牌了')
                        --print('播放了字的音效')
                        audioName = string.format('pai_%d_%d', 1, b.plate)
                    elseif UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 0 then
                        if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
                            audioName = string.format('f_17_pai_%d_%d', 1, b.plate)
                        elseif roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
                            audioName = string.format('f_18_pai_%d_%d', 1, b.plate)
						elseif roomData.setting.roomTypeValue == proxy_pb.AHPHZ then
							audioName = string.format('f_19_pai_%d_%d', 1, b.plate)
                        else
                            audioName = string.format('fpai_%d_%d', 1, b.plate)
                        end
                    end
                    AudioManager.Instance:PlayAudio(audioName)
                end
        )
    else
        print("出现暗喂了。。。。。。。。。。。。。。。。")
    end
    this.RereshOperationSend(b.operations, 'mopai')
    if not b.toHand then
        lastOperat.op = phz_pb.MO_PAI
        lastOperat.plate = b.plate
        lastOperat.seat = b.seat
    end
    if (not b.toHand) or (b.seat == roomData.bankerSeat) then
        this.ShowWaitOpreatEffect(b.seat, true)
        kuang01[this.GetUIIndexBySeat(b.seat)].gameObject:SetActive(true)
    end

    myTingPlates=b.tingPlates
    this.setTingPai()--听牌

    if needChuPai then
        this.SetDelegateCount(mySeat);
    end
end

--听牌功能
function this.setTingPai(chupai, needShow)
    --print('听牌数目' .. #myTingPlates)
    if myTingPlates and #myTingPlates > 0 then
        local SIZE    = 45                                                           -- 牌的大小
        local JIANJU = 3                                                            -- 牌与牌的间距
        for i = 0, 19 do
            allPlates[i] = 0
        end

        this.collectionAllPlate(this.GetPlayerDataBySeat(mySeat).hands)

        if chupai then
            this.collectionAllPlate({chupai})
        end
        
        for i = 0, 3 do
            local pData = this.GetPlayerDataByUIIndex(i)
            if pData and i < roomData.setting.size then
                if pData.paiHe then
                    this.collectionAllPlate(pData.paiHe)
                end
                if pData.menZi then
                    for k, v in pairs(pData.menZi) do
                        if v and v.plates then
                            local plates={}
                            if v.operation == phz_pb.CHI or v.operation == phz_pb.JIAO or v.operation == phz_pb.JU then
                                for j = 1, #v.plates do
                                    table.insert(plates, v.plates[j])
                                end
                                
                            elseif v.operation == phz_pb.DUI then
                                for j = 1, 2 do
                                    table.insert(plates, v.plates[1])
                                end
                            elseif v.operation == phz_pb.PENG or v.operation == phz_pb.WEI or v.operation == phz_pb.KAN or v.operation == phz_pb.CHOU_WEI then
                                for j = 1, 3 do
                                    table.insert(plates, v.plates[1])
                                end
                            elseif v.operation == phz_pb.PAO or v.operation == phz_pb.TI or v.operation == phz_pb.START_TI then
                                for j = 1, 4 do
                                    table.insert(plates, v.plates[1])
                                end
                            else
                                Debugger.LogError('无效类型',nil)
                            end
                            if v.operation ~= phz_pb.PENG 
                            and v.operation ~= phz_pb.CHI 
                            and v.operation ~= phz_pb.PAO 
                            and roomData.setting.roomTypeValue ~= proxy_pb.LDFPF 
                            and roomData.setting.roomTypeValue ~= proxy_pb.SYZP 
                            and roomData.setting.roomTypeValue ~= proxy_pb.SYBP
                            and roomData.setting.roomTypeValue ~= proxy_pb.HYLHQ 
                            and roomData.setting.roomTypeValue ~= proxy_pb.HYSHK
                            and roomData.setting.roomTypeValue ~= proxy_pb.LYZP
                            and roomData.setting.roomTypeValue ~= proxy_pb.CZZP
                            and pData.seat~=mySeat then
                                if roomData.setting.roomTypeValue == proxy_pb.YJGHZ and v.operation ~= phz_pb.START_TI then
                                    this.collectionAllPlate(plates)
                                end
                               --print('别人暗喂')
                            else
                                if (roomData.setting.roomTypeValue == proxy_pb.HYLHQ or roomData.setting.roomTypeValue == proxy_pb.HYSHK) then
                                    if v.operation == phz_pb.CHOU_WEI 
                                    or roomData.setting.canMingWei 
                                    or v.operation == phz_pb.PENG 
                                    or v.operation == phz_pb.CHI 
                                    or v.operation == phz_pb.PAO
                                    or ((v.operation == phz_pb.WEI or v.operation == phz_pb.TI or v.operation == phz_pb.START_TI) and pData.seat==mySeat) then
                                        this.collectionAllPlate(plates)
                                    end
                                else
                                    this.collectionAllPlate(plates)
                                end
                            end
                        end
                    end
                end
            end
        end
        for i=tingGrid.childCount,#myTingPlates-1 do
            NGUITools.AddChild(tingGrid.gameObject,prefabTing.gameObject)
        end
        tingGrid:GetComponent('UISprite').width = 45 + SIZE * #myTingPlates + JIANJU * #myTingPlates               --听牌框长度
        for i=0,tingGrid.childCount-1 do
            local tingGO = {}
            tingGO.GO = tingGrid:GetChild(i)  
            if i<#myTingPlates then              
                tingGO.GO.localPosition = Vector3(0 + SIZE * (i+1) + JIANJU * i , 10, 0)                  --计算位置            
                tingGO.GO:Find('Label'):GetComponent('UILabel').text = 4 - allPlates[myTingPlates[i+1]]-- 要听的牌剩余数量      
                this.setPaiMian(tingGO.GO:Find('plate'), myTingPlates[i+1])
                tingGO.GO.gameObject:SetActive(true)
            else
                tingGO.GO.gameObject:SetActive(false)
            end
        end

        ButtonTing.gameObject:SetActive(true)
        if needShow ~= nil then
            ButtonTing:Find('di').gameObject:SetActive(needShow)
        end
    else
        ButtonTing.gameObject:SetActive(false)
    end
end
--校验本地手牌数和服务器手牌数
function this.compareHandCount(handCount)
    print('compareHandCount ......................')
    local plates=this.GetGridHandPlates(playerGridHand)
    if #plates==handCount then
        return true
    else
        connect:Close()
        connect:Connect()
        print('手牌数目不对了,本地牌数'..#plates..'服务器牌数'..handCount..' 房间号'..roomInfo.roomNumber..' 座位号'..mySeat..' 局数'..roomData.round,nil)
        return false
    end
end
--检查牌桌上牌数
function this.checkCardNum(plate)
    local checkPlates = this.GetCheckPlates();
    if plate and #this.GetPlayerDataBySeat(mySeat).hands ~= 21 and roomData.setting.roomTypeValue ~= phz_pb.HYLHQ then--衡阳六胡抢没有21张牌
        table.insert(checkPlates,plate);
    end
    local checkResult = this.PlateInvalidCheck(checkPlates);

    if not checkResult.pass then
        connect:Close()
        connect:Connect()
        Debugger.LogError(tostring(checkResult.plate)..'多牌了'..' 房间号'..roomInfo.roomNumber..' 座位号'..mySeat..' 局数'..roomData.round,nil);
    end
    return checkResult.pass
end

function this.OnPlayerChuPai(msg)
    local b = phz_pb.RChuPai()
    b:ParseFromString(msg.body)
    print('OnPlayerChuPai:' .. b.plate .. ' seat:' .. b.seat..' handCount:'..b.handCount)
    roomData.outPlate = b.plate
    if roomData.setting.trusteeship == 0 then
		remainTime = -1
	else
		if roomData.trusteeshipRemainMs>0 then
			remainTime = roomData.trusteeshipRemainMs
		else
			remainTime = roomData.setting.trusteeship
		end
	end
    local index = this.GetUIIndexBySeat(b.seat)
    needChuPai = false
    chupaishoushi.gameObject:SetActive(needChuPai)
    if mySeat == b.seat then
        this.CancelDragPlate()
        if this.GetPlayerDataBySeat(mySeat).trusteeship then
            this.DoRemovePlates(b.seat, { b.plate }, false)
        else
            RemoveHandPlatesUI(playerGridHand, {})
            this.DoRemovePlates(b.seat, { b.plate }, true)
        end
        myTingPlates=b.tingPlates

        this.tingQueues=nil
        this.refreshWillTingMark()
        --print('tingPlates:'..tostring(b.tingPlates))

        --print('this.GetPlayerDataBySeat(b.seat).hands:'..#this.GetPlayerDataBySeat(b.seat).hands..', b.handCount:'..b.handCount)
        if this.compareHandCount(b.handCount)==false then
            return
            --print('手牌个数对不上，需要刷新。。。。。。。。。。。。。')
        end
    end

    if b.songWeiPao and b.songWeiPao == true then
        playerSiShou[index].gameObject:SetActive(true)
    end

    if this.checkCardNum(b.plate)==false then
        return
    end

    if index~=0 or (index==0 and this.GetPlayerDataBySeat(mySeat).trusteeship) then

        print("--------------------------->");
        this.playPaiAnimation(b.seat, b.plate, playerIcon[index].position, playerMoPaiPos[index].position,
                Vector3.zero, Vector3.one * 0.8, false, true, true)
        AudioManager.Instance:PlayAudio('chupai')
        coroutine.start(
                function()
                    coroutine.wait(0.1)

                    local audioName = ""
                    if UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 1 then
                        audioName = string.format('pai_%d_%d', 1, b.plate)
                    elseif UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 0 then
                        if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
                            audioName = string.format('f_17_pai_%d_%d', 1, b.plate)
                        elseif roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
                            audioName = string.format('f_18_pai_%d_%d', 1, b.plate)
						elseif roomData.setting.roomTypeValue == proxy_pb.AHPHZ then
							audioName = string.format('f_19_pai_%d_%d', 1, b.plate)
                        else
                            audioName = string.format('fpai_%d_%d', 1, b.plate)
                        end
                    end
                    AudioManager.Instance:PlayAudio(audioName)
                end
        )
    end
    this.RereshOperationSend(b.operations, 'chupai')
    if mySeat == b.seat  then
        this.setTingPai(b.plate, true)
    else
        this.setTingPai(b.plate)--听牌
    end
    lastOperat.op = phz_pb.CHU_PAI
    lastOperat.plate = b.plate
    lastOperat.seat = b.seat
end

function this.OnPlayerChiPai(msg)
    local b = phz_pb.RChiPai()
    b:ParseFromString(msg.body)
    roomData.outPlate = -1
    print('吃啊' .. 'last seat' .. lastOperat.seat .. 'last seat' .. lastOperat.plate..' b.operation: '..#b.operations)
    print(string.format('OnPlayerChiPai hand:%d %d other:%d seat:%d deskHuXi:%d',
    b.selectChi[1].plates[2], b.selectChi[1].plates[3], b.selectChi[1].plates[1], b.seat, b.deskHuXi))
    needChuPai = b.seat == mySeat
    if b.seat == mySeat then
        this.CancelDragPlate()
        local temp = {}
        for i = 1, #b.selectChi do
            if i ~= 1 then
                table.insert(temp, b.selectChi[i].plates[1])
            end
            table.insert(temp, b.selectChi[i].plates[2])
            table.insert(temp, b.selectChi[i].plates[3])
            print('b.selectChi[i].plates[1]: '..b.selectChi[i].plates[1])
            print('b.selectChi[i].plates[2]: '..b.selectChi[i].plates[2])
            print('b.selectChi[i].plates[3]: '..b.selectChi[i].plates[3])
        end
        
        this.DoRemovePlates(b.seat, temp)
        myTingPlates=b.tingPlates
        if this.compareHandCount(b.handCount)==false then
            return
            --print('手牌个数对不上，需要刷新。。。。。。。。。。。。。')
        end
    end
   
    
	local menZis = {}
    for i = 1, #b.selectChi do
        local menZi = phz_pb.ROperationPlate()
        menZi.operation = phz_pb.CHI
        menZi.plates:append(b.selectChi[i].plates[1])
        menZi.plates:append(b.selectChi[i].plates[2])
        menZi.plates:append(b.selectChi[i].plates[3])
        table.insert(this.GetPlayerDataBySeat(b.seat).menZi, menZi)
		table.insert(menZis, menZi)
    end
    local index = this.GetUIIndexBySeat(b.seat)
    RefreshGridXi(playerGridXi[index], playerGridXi, this.GetPlayerDataBySeat(b.seat).menZi,menZis,false,true)
    if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
    else
        playerXiNum[index]:GetComponent('UILabel').text = '胡息:'..b.deskHuXi
    end
    this.stopPaiAnimiation(lastOperat.seat, lastOperat.plate)

    index = this.GetUIIndexBySeat(lastOperat.seat)
    if this.GetPlayerDataBySeat(lastOperat.seat).paiHe[#this.GetPlayerDataBySeat(lastOperat.seat).paiHe] == lastOperat.plate then
        table.remove(this.GetPlayerDataBySeat(lastOperat.seat).paiHe, #this.GetPlayerDataBySeat(lastOperat.seat).paiHe)
        RefreshTabelThrow(playerThrow[index], this.GetPlayerDataBySeat(lastOperat.seat).paiHe)
    end
    
    curOperatPlateEffect.gameObject:SetActive(false)
    moOperatPlateEffect.gameObject:SetActive(false)
    operation_send.gameObject:SetActive(false)
    if roomData.setting.roomTypeValue == proxy_pb.YJGHZ and b.seat == mySeat and #b.operations > 0 then
        needChuPai = false
        this.RereshOperationSend(b.operations, 'chipai')
    end
    chupaishoushi.gameObject:SetActive(needChuPai)
    PanelManager.Instance:HideWindow('panelChiPai')
    this.ShowTipEffect('chiEffect', b.seat)

    local audioName = ""
    if UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 1 then
        audioName = string.format('chi_%d', 1)
    elseif UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 0 then
        if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
            audioName = string.format('f_17_chi_%d', 1)
        elseif roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
            audioName = string.format('f_18_chi_%d', 1)
		elseif roomData.setting.roomTypeValue == proxy_pb.AHPHZ then
            audioName = string.format('f_19_chi_%d', 1)
        else
            audioName = string.format('fchi_%d', 1)
        end
    end
    AudioManager.Instance:PlayAudio(audioName)
    this.ShowWaitOpreatEffect(b.seat, true)
    kuang01[this.GetUIIndexBySeat(b.seat)].gameObject:SetActive(true)
    lastOperat.op = phz_pb.CHI_PAI
    lastOperat.plate = b.plate
    lastOperat.seat = b.seat

    this.setTingPai()--听牌

    if needChuPai then
        this.SetDelegateCount(mySeat)
    end

    --牌的数目合法性检测
    if this.checkCardNum()==false then
        return
    end
    if b.seat == mySeat and roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
        chouPlates = {}
        for i = 1, #b.chouPlates do
            table.insert(chouPlates,b.chouPlates[i])
        end
        SetChouPlates(playerGridHand,chouPlates)
    end
end
function SetChouPlates(grid,chouCards)
    print('#chouCards: '..#chouCards)
    if #chouCards == 0 then
        return 
    end
    for i = 1, #chouCards do
        print(i..'b.chouCards : '..chouCards[i])
    end
    for i = 0, grid.childCount - 1 do
        local item = grid:GetChild(i)
        for j = 0, item.childCount - 1 do
            local card = item:GetChild(j)
            if card.gameObject.activeSelf then
                for k = 1, #chouCards do
                    if chouCards[k] == GetUserData(card.gameObject) then
                        card:Find('bg/mask').gameObject:SetActive(true)
                    end
                end
            end
        end
    end
end
function this.OnPlayerPengPai(msg)
    local b = phz_pb.RPengPai()
    b:ParseFromString(msg.body)
    roomData.outPlate = -1
    print('pengle' .. b.seat .. 'last seat' .. lastOperat.seat .. 'last seat' .. lastOperat.plate..' b.operation: '..#b.operations)
    --print('OnPlayerPengPai:'..b.plate..' seat:'..b.seat..' deskHuXi:'..b.deskHuXi)
    needChuPai = b.seat == mySeat
    if b.seat == mySeat then
        this.CancelDragPlate()
        local plates = { b.plate, b.plate }
        this.DoRemovePlates(b.seat, plates)
        myTingPlates=b.tingPlates
        if this.compareHandCount(b.handCount)==false then
            return
            --print('手牌个数对不上，需要刷新。。。。。。。。。。。。。')
        end
    end
   
    local menZi = phz_pb.ROperationPlate()
    menZi.operation = phz_pb.PENG
    menZi.plates:append(b.plate)
    menZi.plates:append(b.plate)
    menZi.plates:append(b.plate)
    menZi.fromSeat = b.fromSeat
    table.insert(this.GetPlayerDataBySeat(b.seat).menZi, menZi)
    local index = this.GetUIIndexBySeat(b.seat)
	local menZis={}
	table.insert(menZis, menZi)
    RefreshGridXi(playerGridXi[index], playerGridXi, this.GetPlayerDataBySeat(b.seat).menZi,menZis,false,true)
    if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
        for i = 1, #b.piaoScore do
            this.SetZhongTuFen(b.piaoScore[i].halfScore,b.piaoScore[i].seat)
        end
        for i = 1, #b.halfScore do
            local ind = this.GetUIIndexBySeat(b.halfScore[i].seat)
            playerXiNum[ind]:GetComponent('UILabel').text = (b.halfScore[i].halfScore > 0 and '+' or '')..b.halfScore[i].halfScore..'胡'
        end
    else
        playerXiNum[index]:GetComponent('UILabel').text = '胡息:'..b.deskHuXi
    end

    this.stopPaiAnimiation(lastOperat.seat, lastOperat.plate)
    index = this.GetUIIndexBySeat(lastOperat.seat)
    if this.GetPlayerDataBySeat(lastOperat.seat).paiHe[#this.GetPlayerDataBySeat(lastOperat.seat).paiHe] == lastOperat.plate then
        table.remove(this.GetPlayerDataBySeat(lastOperat.seat).paiHe, #this.GetPlayerDataBySeat(lastOperat.seat).paiHe)
        RefreshTabelThrow(playerThrow[index], this.GetPlayerDataBySeat(lastOperat.seat).paiHe)
    end

    curOperatPlateEffect.gameObject:SetActive(false)
    moOperatPlateEffect.gameObject:SetActive(false)
    operation_send.gameObject:SetActive(false)
    if roomData.setting.roomTypeValue == proxy_pb.YJGHZ and b.seat == mySeat and #b.operations > 0 then
        needChuPai = false
        this.RereshOperationSend(b.operations, 'pengpai')
    end
    chupaishoushi.gameObject:SetActive(needChuPai)
    PanelManager.Instance:HideWindow('panelChiPai')
    if b.isPeng3 then
        this.ShowTipEffect('pengSanDaEffect', b.seat)
    elseif b.isPeng4 then
        this.ShowTipEffect('pengSiQingEffect', b.seat)
    else
        this.ShowTipEffect('pengEffect', b.seat)
    end
   
    local audioName = ""
    if UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 1 then
        audioName = string.format('peng_%d', 1)
    elseif UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 0 then
        if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
            if b.isPeng3 then
                audioName = string.format('f_17_pengsanda_%d', 1)
            elseif b.isPeng4 then
                audioName = string.format('f_17_pengsiqing_%d', 1)
            else
                audioName = string.format('f_17_peng_%d', 1)
            end
        elseif roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
            audioName = string.format('f_18_peng_%d', 1)
		elseif roomData.setting.roomTypeValue == proxy_pb.AHPHZ then
            audioName = string.format('f_19_peng_%d', 1)
        else
            audioName = string.format('fpeng_%d', 1)
        end
    end
    AudioManager.Instance:PlayAudio(audioName)
    this.ShowWaitOpreatEffect(b.seat, true)
    kuang01[this.GetUIIndexBySeat(b.seat)].gameObject:SetActive(true)
    lastOperat.op = phz_pb.PENG_PAI
    lastOperat.plate = b.plate
    lastOperat.seat = b.seat

    this.setTingPai()

    if needChuPai then
        this.SetDelegateCount(mySeat)
    end
    --this.SetDelegateCount(b.seat);
    --牌的数目合法性检测
    if this.checkCardNum()==false then
        return
    end
    if b.seat == mySeat and roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
        chouPlates = {}
        for i = 1, #b.chouPlates do
            table.insert(chouPlates,b.chouPlates[i])
        end
        SetChouPlates(playerGridHand,b.chouPlates)
    end
    coroutine.start(
    function()
        if isShowPanelChiPai and not PanelManager.Instance:IsActive('panelChiPai') then
            coroutine.wait(0.1)
            PanelManager.Instance:HideWindow('panelChiPai')
            isShowPanelChiPai = false
        end
    end
    )
end

function this.OnPlayerWeiPai(msg)
    local b = phz_pb.RWeiPai()
    b:ParseFromString(msg.body)
    roomData.outPlate = -1
   print('喂牌了' .. b.seat .. '  last seat' .. lastOperat.seat .. '  last seat' ..lastOperat.plate..'  b.chouWei : '..tostring(b.chouWei))
   --print('OnPlayerWeiPai:'..b.plate .. ' seat:' .. b.seat .. ' deskHuXi:' .. b.deskHuXi)

    needChuPai = b.seat == mySeat
    if b.seat == mySeat then
        this.CancelDragPlate()
        local plates = { b.plate, b.plate }
        this.DoRemovePlates(b.seat, plates)
        myTingPlates=b.tingPlates

        if this.compareHandCount(b.handCount)==false then
            return
            --print('手牌个数对不上，需要刷新。。。。。。。。。。。。。')
        end
    end
    chupaishoushi.gameObject:SetActive(needChuPai)
    this.RereshOperationSend(b.operations, 'weipai')

    local menZi = phz_pb.ROperationPlate()
    menZi.operation = b.chouWei and phz_pb.CHOU_WEI or phz_pb.WEI
    menZi.plates:append(b.plate)
    menZi.plates:append(b.plate)
    menZi.plates:append(b.plate)
    table.insert(this.GetPlayerDataBySeat(b.seat).menZi, menZi)
    local index = this.GetUIIndexBySeat(b.seat)
	local menZis={}
	table.insert(menZis, menZi)
    RefreshGridXi(playerGridXi[index], playerGridXi, this.GetPlayerDataBySeat(b.seat).menZi,menZis,false,true)
    if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
        for i = 1, #b.piaoScore do
            this.SetZhongTuFen(b.piaoScore[i].halfScore,b.piaoScore[i].seat)
        end
        for i = 1, #b.halfScore do
            local ind = this.GetUIIndexBySeat(b.halfScore[i].seat)
            playerXiNum[ind]:GetComponent('UILabel').text = (b.halfScore[i].halfScore > 0 and '+' or '')..b.halfScore[i].halfScore..'胡'
        end
    else
        playerXiNum[index]:GetComponent('UILabel').text = '胡息:'..b.deskHuXi
    end

    this.stopPaiAnimiation(lastOperat.seat, lastOperat.plate)
    index = this.GetUIIndexBySeat(lastOperat.seat)
    if this.GetPlayerDataBySeat(lastOperat.seat)~=nil and this.GetPlayerDataBySeat(lastOperat.seat).paiHe[#this.GetPlayerDataBySeat(lastOperat.seat).paiHe] == lastOperat.plate then
        table.remove(this.GetPlayerDataBySeat(lastOperat.seat).paiHe, #this.GetPlayerDataBySeat(lastOperat.seat).paiHe)
        RefreshTabelThrow(playerThrow[index], this.GetPlayerDataBySeat(lastOperat.seat).paiHe)
    end

    curOperatPlateEffect.gameObject:SetActive(false)
    moOperatPlateEffect.gameObject:SetActive(false)
    if b.isSao3 then
        this.ShowTipEffect('saoSanDaEffect', b.seat)
    elseif b.isSao4 then
        this.ShowTipEffect('saoSiQingEffect', b.seat)
    else
        this.ShowTipEffect(roomData.setting.roomTypeValue == proxy_pb.YJGHZ and 'waiEffect' or 'weiEffect', b.seat)
    end

    local audioName = ""
    if UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 1 then
        audioName = string.format('wei_%d', 1)
    elseif UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 0 then
        if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
            if b.isSao3 then
                audioName = string.format('f_17_saosanda_%d', 1)
            elseif b.isSao4 then
                audioName = string.format('f_17_saosiqing_%d', 1)
            else
                audioName = string.format('f_17_wei_%d', 1)
            end
        elseif roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
            audioName = string.format('f_18_wei_%d', 1)
		elseif roomData.setting.roomTypeValue == proxy_pb.AHPHZ then
            audioName = string.format('f_19_wei_%d', 1)
        else
            audioName = string.format('fwei_%d', 1)
        end
    end
    AudioManager.Instance:PlayAudio(audioName)
    this.ShowWaitOpreatEffect(b.seat, true)
    kuang01[this.GetUIIndexBySeat(b.seat)].gameObject:SetActive(true)
    this.setTingPai()--听牌
    lastOperat.op = phz_pb.WEI_PAI
    lastOperat.plate = b.plate
    lastOperat.seat = b.seat

    if needChuPai then
        this.SetDelegateCount(mySeat)
    end
    --this.SetDelegateCount(b.seat);

    --牌的数目合法性检测
    if this.checkCardNum()==false then
        return
    end

end

function this.OnPlayerPaoPai(msg)
    local b = phz_pb.RPaoPai()
    b:ParseFromString(msg.body)
   --print('OnPlayerPaoPai:' .. b.plate .. ' seat:' .. b.seat .. ' deskHuXi:' .. b.deskHuXi .. 'last seat' .. lastOperat.seat .. 'last seat' .. lastOperat.plate)
   roomData.outPlate = -1
    local menZi = nil
    print("mySeat"..tostring(mySeat))
    needChuPai = b.seat == mySeat
    
    for i = 1, #this.GetPlayerDataBySeat(b.seat).menZi do
        local m = this.GetPlayerDataBySeat(b.seat).menZi[i]
        if m.operation == phz_pb.PAO or m.operation == phz_pb.TI then
            StartCoroutine(function()
                connect.IsZanTing=true
               --print('跑牌暂停了'..os.date())
                WaitForSeconds(0.5)
                connect.IsZanTing=false
               --print('跑牌开始了了'..os.date())
            end)
            needChuPai = false
        end
        if (m.operation == phz_pb.PENG or m.operation == phz_pb.WEI) and m.plates[1] == b.plate then
            m.operation = phz_pb.PAO
            m.plates:append(b.plate)
            m.fromSeat = b.fromSeat
            menZi = m
        end
    end

    if b.seat == mySeat then
        this.CancelDragPlate()
        local plates = { b.plate, b.plate, b.plate, b.plate }
        this.DoRemovePlates(b.seat, plates)
        myTingPlates=b.tingPlates
        if this.compareHandCount(b.handCount)==false then
            return
            --print('手牌个数对不上，需要刷新。。。。。。。。。。。。。')
        end
        local  paoOrTiNum = 0
        for j = 1, playerGridXi[this.GetUIIndexBySeat(b.seat)].childCount do
            local firstGrid = playerGridXi[this.GetUIIndexBySeat(b.seat)]:GetChild(j-1)
            if firstGrid.gameObject.activeSelf then
                local paiNum=0
                for k = 1, firstGrid.childCount do
                    local plateObj = firstGrid:GetChild(k-1)
                    if plateObj.gameObject.activeSelf then
                        paiNum=paiNum+1
                        local plate = GetUserData(plateObj.gameObject)
                    end
                end
                if paiNum==4 then
                    paoOrTiNum=paoOrTiNum+1
                end
                print(j..'  paiNum : '..paiNum)
            end
        end
        print('paoOrTiNum : '..paoOrTiNum)
        if paoOrTiNum >=1 then
            needChuPai=false
        end
    end
    print('needChuPai : '..tostring(needChuPai))
    chupaishoushi.gameObject:SetActive(needChuPai)
    this.RereshOperationSend(b.operations, 'paopai')

    if not menZi then
        menZi = phz_pb.ROperationPlate()
        menZi.operation = phz_pb.PAO
        menZi.plates:append(b.plate)
        menZi.plates:append(b.plate)
        menZi.plates:append(b.plate)
        menZi.plates:append(b.plate)
        menZi.fromSeat = b.fromSeat
        table.insert(this.GetPlayerDataBySeat(b.seat).menZi, menZi)
    end
	local menZis={}
	table.insert(menZis, menZi)
    local index = this.GetUIIndexBySeat(b.seat)
    RefreshGridXi(playerGridXi[index], playerGridXi, this.GetPlayerDataBySeat(b.seat).menZi,menZis,false,true,true)
    print('b.deskHuXi:'..b.deskHuXi)
    if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
        for i = 1, #b.piaoScore do
            this.SetZhongTuFen(b.piaoScore[i].halfScore,b.piaoScore[i].seat)
        end
        for i = 1, #b.halfScore do
            local ind = this.GetUIIndexBySeat(b.halfScore[i].seat)
            playerXiNum[ind]:GetComponent('UILabel').text = (b.halfScore[i].halfScore > 0 and '+' or '')..b.halfScore[i].halfScore..'胡'
        end
    else
        playerXiNum[index]:GetComponent('UILabel').text = '胡息:'..b.deskHuXi
    end

    this.stopPaiAnimiation(lastOperat.seat, lastOperat.plate)
    index = this.GetUIIndexBySeat(lastOperat.seat)
    if this.GetPlayerDataBySeat(lastOperat.seat).paiHe[#this.GetPlayerDataBySeat(lastOperat.seat).paiHe] == lastOperat.plate then
        table.remove(this.GetPlayerDataBySeat(lastOperat.seat).paiHe, #this.GetPlayerDataBySeat(lastOperat.seat).paiHe)
        RefreshTabelThrow(playerThrow[index], this.GetPlayerDataBySeat(lastOperat.seat).paiHe)
    end

    curOperatPlateEffect.gameObject:SetActive(false)
    moOperatPlateEffect.gameObject:SetActive(false)
    this.ShowTipEffect(roomData.setting.roomTypeValue == proxy_pb.YJGHZ and 'piaoEffect' or 'paoEffect', b.seat)

    local audioName = ""
    if UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 1 then
        audioName = string.format('pao_%d', 1)
    elseif UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 0 then
        if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
            audioName = string.format('f_17_pao_%d', 1)
        elseif roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
            audioName = string.format('f_18_pao_%d', 1)
		elseif roomData.setting.roomTypeValue == proxy_pb.AHPHZ then
            audioName = string.format('f_19_pao_%d', 1)
        else
            audioName = string.format('fpao_%d', 1)
        end
    end
    AudioManager.Instance:PlayAudio(audioName)
    this.setTingPai()--听牌
    this.ShowWaitOpreatEffect(b.seat, true)
    kuang01[this.GetUIIndexBySeat(b.seat)].gameObject:SetActive(true)
    lastOperat.op = phz_pb.PAO_PAI
    lastOperat.plate = b.plate
    lastOperat.seat = b.seat

    if needChuPai then
        this.SetDelegateCount(mySeat)
    end
    --this.SetDelegateCount(b.seat);


    --牌的数目合法性检测
    if this.checkCardNum()==false then
        return
    end


end

function this.OnPlayerTiPai(msg)
    local b = phz_pb.RTiPai()
    b:ParseFromString(msg.body)
    roomData.outPlate = -1
   --print('tile' .. b.seat)
   --print('OnPlayerTiPai:' .. b.plate .. ' seat:' .. b.seat .. ' deskHuXi:' .. b.deskHuXi .. 'last seat' .. lastOperat.seat .. 'last seat' .. lastOperat.plate)
    needChuPai = b.seat == mySeat
    
    local menZi = nil
    for i = 1, #this.GetPlayerDataBySeat(b.seat).menZi do
        local m = this.GetPlayerDataBySeat(b.seat).menZi[i]
        if m.operation == phz_pb.PAO or m.operation == phz_pb.TI then
            needChuPai = false
        end
        if m.operation == phz_pb.WEI and m.plates[1] == b.plate then
            m.operation = phz_pb.TI
            m.plates:append(b.plate)
            menZi = m
        end
    end

    if b.seat == mySeat then
        this.CancelDragPlate()
        local plates = { b.plate, b.plate, b.plate, b.plate }
        this.DoRemovePlates(b.seat, plates)
        this.RereshOperationSend(b.operations, 'tipai')
        if lastOperat.plate ~= b.plate then
            if b.seat == roomData.bankerSeat then
                needChuPai = true
            else
                needChuPai = false
            end
        end
        myTingPlates=b.tingPlates

        if this.compareHandCount(b.handCount)==false then
            return
            --print('手牌个数对不上，需要刷新。。。。。。。。。。。。。')
        end
        local  paoOrTiNum = 0
        for j = 1, playerGridXi[this.GetUIIndexBySeat(b.seat)].childCount do
            local firstGrid = playerGridXi[this.GetUIIndexBySeat(b.seat)]:GetChild(j-1)
            if firstGrid.gameObject.activeSelf then
                local paiNum=0
                for k = 1, firstGrid.childCount do
                    local plateObj = firstGrid:GetChild(k-1)
                    if plateObj.gameObject.activeSelf then
                        paiNum=paiNum+1
                        local plate = GetUserData(plateObj.gameObject)
                    end
                end
                if paiNum==4 then
                    paoOrTiNum=paoOrTiNum+1
                end
                print(j..'  paiNum : '..paiNum)
            end
        end
        print('paoOrTiNum : '..paoOrTiNum)
        if paoOrTiNum >=1 then
            needChuPai=false
        end
    else
        if b.startTi and roomData.setting.roomTypeValue == proxy_pb.LYZP then
            if mySeat == roomData.bankerSeat then
                needChuPai = true
            end
        else
            needChuPai = false
        end
    end
    chupaishoushi.gameObject:SetActive(needChuPai)
    if not menZi then
        menZi = phz_pb.ROperationPlate()
        menZi.operation = b.startTi and phz_pb.START_TI or phz_pb.TI
        menZi.plates:append(b.plate)
        menZi.plates:append(b.plate)
        menZi.plates:append(b.plate)
        menZi.plates:append(b.plate)
        table.insert(this.GetPlayerDataBySeat(b.seat).menZi, menZi)
    end
    local index = this.GetUIIndexBySeat(b.seat)
	local menZis={}
	table.insert(menZis, menZi)
    RefreshGridXi(playerGridXi[index], playerGridXi, this.GetPlayerDataBySeat(b.seat).menZi,menZis,false,true,true)
    print('b.deskHuXi:'..b.deskHuXi)
    if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
        for i = 1, #b.piaoScore do
            this.SetZhongTuFen(b.piaoScore[i].halfScore,b.piaoScore[i].seat)
        end
        for i = 1, #b.halfScore do
            local ind = this.GetUIIndexBySeat(b.halfScore[i].seat)
            playerXiNum[ind]:GetComponent('UILabel').text = (b.halfScore[i].halfScore > 0 and '+' or '')..b.halfScore[i].halfScore..'胡'
        end
    else
        playerXiNum[index]:GetComponent('UILabel').text = '胡息:'..b.deskHuXi
    end

    if lastOperat.plate == b.plate then
        this.stopPaiAnimiation(lastOperat.seat, lastOperat.plate)
        index = this.GetUIIndexBySeat(lastOperat.seat)
        if this.GetPlayerDataBySeat(lastOperat.seat).paiHe[#this.GetPlayerDataBySeat(lastOperat.seat).paiHe] == lastOperat.plate then
            table.remove(this.GetPlayerDataBySeat(lastOperat.seat).paiHe, #this.GetPlayerDataBySeat(lastOperat.seat).paiHe)
            RefreshTabelThrow(playerThrow[index], this.GetPlayerDataBySeat(lastOperat.seat).paiHe)
        end
        lastOperat.op = phz_pb.TI
        lastOperat.plate = b.plate
        lastOperat.seat = b.seat
        this.ShowWaitOpreatEffect(b.seat, true)
        kuang01[this.GetUIIndexBySeat(b.seat)].gameObject:SetActive(true)
    end

    curOperatPlateEffect.gameObject:SetActive(false)
    moOperatPlateEffect.gameObject:SetActive(false)
    this.ShowTipEffect(roomData.setting.roomTypeValue == proxy_pb.YJGHZ and 'liuEffect' or 'tiEffect', b.seat)

    local audioName = ""
    if UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 1 then
        audioName = string.format('ti_%d', 1)
    elseif UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 0 then
        if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
            audioName = string.format('f_17_ti_%d', 1)
        elseif roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
            audioName = string.format('f_18_ti_%d', 1)
		elseif roomData.setting.roomTypeValue == proxy_pb.AHPHZ then
            audioName = string.format('f_19_ti_%d', 1)
        else
            audioName = string.format('fti_%d', 1)
        end
    end
    AudioManager.Instance:PlayAudio(audioName)
    this.setTingPai()--听牌
    if needChuPai then
        this.SetDelegateCount(mySeat)
    end
    --this.SetDelegateCount(b.seat)
    --牌的数目合法性检测
    if this.checkCardNum()==false then
        return
    end
end

function this.OnPlayerHuPai(msg)
    local b = phz_pb.RHuPai()
    b:ParseFromString(msg.body)
    --print('OnPlayerHuPai')
    operation_send.gameObject:SetActive(false)
    PanelManager.Instance:HideWindow('panelChiPai')
    this.ShowTipEffect('huEffect', b.seat)
    if roomData.setting.roomTypeValue == proxy_pb.HYSHK or roomData.setting.roomTypeValue == proxy_pb.HYLHQ then
        for i = 0, curPais.childCount - 1 do
            curPais:GetChild(i).gameObject:SetActive(false)
        end
    end
    local audioName = ""
    if UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 1 then
        audioName = string.format('hu_%d', 1)
    elseif UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 0 then
        if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
            audioName = string.format('f_17_hu_%d', 1)
        elseif roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
            audioName = string.format('f_18_hu_%d', 1)
		elseif roomData.setting.roomTypeValue == proxy_pb.AHPHZ then
            audioName = string.format('f_19_hu_%d', 1)
        else
            audioName = string.format('fhu_%d', 1)
        end
    end

    AudioManager.Instance:PlayAudio(audioName)

    -- print("有人胡了，坐位号："..b.seat.."，是否自摸："..tostring(b.selfMo))
    --翻醒、跟醒动画
    if roomData.setting.size == 4 and roomData.setting.roomTypeValue == proxy_pb.SYZP then
        this.playPaiAnimation((roomData.bankerSeat + 2) % 4, b.plate, dipai.position, dipai.position,
        Vector3.zero, Vector3.one * 0.8, true, not b.toHand, true)
	elseif (roomData.setting.roomTypeValue == proxy_pb.HYSHK or roomData.setting.roomTypeValue == proxy_pb.HYLHQ) and roomData.setting.xing ~= 2 then
		xingPlate.localScale = Vector3.zero
		xingPlate.gameObject:SetActive(true)
		xingPlate:GetComponent('TweenScale'):ResetToBeginning()
		xingPlate:GetComponent('TweenScale'):PlayForward()
		xingPlate:Find('plate0'):GetComponent('UISprite').spriteName = 'card_'..b.plate
		xingPlate:Find('plate1'):GetComponent('UISprite').spriteName = 'card_'..b.plate
		xingPlate:Find('xingType'):GetComponent('UISprite').spriteName = roomData.setting.xing == 0 and 'fanxing' or 'gengxing'
    end
end

function this.OnPlayerGuo(msg)
    local b = phz_pb.RSeat()
    b:ParseFromString(msg.body)
    if b.seat == mySeat then
        operation_send.gameObject:SetActive(false)
        if kuang01[this.GetUIIndexBySeat(b.seat)].gameObject.activeSelf and roomData.outPlate == -1 and roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
            needChuPai = true
            chupaishoushi.gameObject:SetActive(needChuPai)
        end
    end
end
function this.OnPlayerPassHu(msg)
    print('收到passhu')
    local b = phz_pb.RSeat()
    b:ParseFromString(msg.body)
    if b.seat == mySeat then
        operation_send.gameObject:SetActive(false)
    end
end
function this.SetZhongTuFen(score,seat)
    if score~=0 then
        local str =''
        if score > 0 then
            str = '[FF0000]+'..score
        else
            str = '[0344B0]'..score
        end
        local inx = this.GetUIIndexBySeat(seat)
        playerAddScoreLabel[inx]:GetComponent('UILabel').text = str
        playerAddScoreLabel[inx].gameObject:SetActive(true)
        playerAddScoreLabel[inx]:GetComponent('TweenPosition'):ResetToBeginning()
        playerAddScoreLabel[inx]:GetComponent('TweenPosition'):PlayForward()
        coroutine.start(function()
            coroutine.wait(1.8)
            playerAddScoreLabel[inx].gameObject:SetActive(false)
        end)
    end
end
function this.OnOver(msg)
   print('OnOver was called')
    local b = phz_pb.ROver()
    b:ParseFromString(msg.body)

    RoundAllData.data = b
    RoundAllData.mySeat = mySeat
    RoundAllData.playerData = playerData
    RoundAllData.roomData = roomData
    RoundData.over = true
    RoundAllData.over = true 
    RoundAllData.playName = roomData.playName
    local Trusteeships={}
    for i = 0, roomData.setting.size-1 do
        local da = this.GetPlayerDataByUIIndex(i)
        if playerTrusteeship[i].gameObject.activeSelf then
            Trusteeships[da.seat] = true
        else
            Trusteeships[da.seat] = false
        end
    end
    RoundAllData.isTrusteeships = Trusteeships
    
    if this.hasStageClear==false then
       --print('jin总结算了')
        PanelManager.Instance:HideWindow('panelChiPai')
        PanelManager.Instance:HideWindow('panelInGameLand')
        PanelManager.Instance:HideWindow('panelStageClear')
        PanelManager.Instance:ShowWindow('panelStageClearAll')
    end
end

function this.OnDissolve(msg)
    local b = phz_pb.RDissolve()
    b:ParseFromString(msg.body)
   print('OnDissolve seat:' .. b.seat .. ' decision:' .. b.decision)

    if b.decision == phz_pb.APPLY then
        roomData.dissolution.applicant = b.seat;
        while #roomData.dissolution.acceptors > 0 do
            table.remove(roomData.dissolution.acceptors, #roomData.dissolution.acceptors)
        end
        roomData.dissolution.remainMs = b.remainMs/1000
        PanelManager.Instance:HideWindow('panelDestroyRoom')
        this.SetDestoryPanelShow()
       --print('applicant:' .. roomData.dissolution.applicant)
    elseif b.decision == phz_pb.AGREE then
        table.insert(roomData.dissolution.acceptors, b.seat)
        panelDestroyRoom.Refresh()
       --print('applicant:' .. roomData.dissolution.applicant .. ' acceptors:' .. table.concat(roomData.dissolution.acceptors, ','))
    elseif b.decision == phz_pb.AGAINST then
        panelDestroyRoom.Refresh(b.seat)
    else
        Debugger.LogError('decision unkown type:' .. b.decision, nil)
    end
    PanelManager.Instance:HideWindow('panelMessageBox')
end

function this.Destroy(msg)
    print('房间已被销毁');
    --this.QuitVoiceRoom()
    this.StopCheckNetState()
    this.StopAllOfflineIncrease()
    --coroutine.stop(voiceCor)
    NetWorkManager.Instance:DeleteConnect('game')
    panelLogin.HideGameNetWaitting()
    PanelManager.Instance:HideWindow('panelDestroyRoom')
    this.fanHuiRoomNumber = nil
    if PanelManager.Instance:IsActive('panelGameSetting') then
        PanelManager.Instance:HideWindow('panelGameSetting')
    end
    if PanelManager.Instance:IsActive('panelPlayerInfo') then
        PanelManager.Instance:HideWindow('panelPlayerInfo')
    end

    DelegatePanel.gameObject:SetActive(false);
    DelegateTime.gameObject:SetActive(false);

    coroutine.stop(trusteeshipcor);
    offlineState = true;
    
	if panelStageClear then
		panelStageClear.setButtonsStatus(true)
	end
    -- 没有开局解散房间直接退到大厅
   --print('roomData.round:'..roomData.round)
   --print('roomData.state == phz_pb.READYING'..tostring(roomData.state == phz_pb.READYING))
    if roomData.round == 1 and roomData.state == phz_pb.READYING and this.hasStageClear==false then
        panelLogin.HideGameNetWaitting();
       --print('！！！！！！！！！！！！！！！！！！！！！' .. roomData.clubId)
        if roomData.clubId ~= '0' then
            local data = {}
            data.name = 'panelInGameLand'
            -- data.clubId = roomData.clubId
            PanelManager.Instance:ShowWindow('panelClub', data)
        else
           --print('dddddddddddddddd')
            PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
        end
        roomData.clubId = '0'
        --panelInGame =nil
    end

    --this.StopAllOfflineIncrease()
end

function this.SetDestoryPanelShow()
    PanelManager.Instance:HideWindow('panelDestroyRoom')
    PanelManager.Instance:ShowWindow('panelDestroyRoom')
end

function this.SetReadyVisiable()
    for i = 0, 3 do
        local p = this.GetPlayerDataByUIIndex(i)
        if roomData.state ~= phz_pb.GAMING and p then
            if p.ready then
                playerReady[i].gameObject:SetActive(true)
            else
                playerReady[i].gameObject:SetActive(false)
            end
        else
            playerReady[i].gameObject:SetActive(false)
        end
    end
end

function this.SetRoundNum(num)
    if roomData.setting.roomTypeValue == proxy_pb.SYBP
    or roomData.setting.roomTypeValue == proxy_pb.LDFPF
    or roomData.setting.roomTypeValue == proxy_pb.XXGHZ then
        roomRound:GetComponent('UILabel').text = '第' .. num .. '局 '
    else
        roomRound:GetComponent('UILabel').text = num .. '/' .. roomData.setting.rounds .. '局 '
    end
end

function this.OnClickButtonSetting(go)
    AudioManager.Instance:PlayAudio('btn')
    local isAllReady = this.IsAllReaded()
    if roomData.round > 1 or isAllReady  then
		PanelManager.Instance:ShowWindow('panelGameSetting', true)
		print("游戏中申请解散房间33333333333333333")
	else
		if mySeat == 0 then
			PanelManager.Instance:ShowWindow('panelGameSetting', true)
			print("游戏未开始房主解散房间33333333333333333")
		else
			PanelManager.Instance:ShowWindow('panelGameSetting', false)
			print("游戏未开始玩家离开房间33333333333333333")
		end
	end

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

function this.OnClickButtonInvite(go)
    local msg = ""--'房号:' .. roomInfo.roomNumber
    msg = msg .. getWanFaText(roomData.setting,false,false, true)
    msg = msg..",房已开好,就等你来！"
    print("分享出的的信息为",msg)
    local roomType
    local name
    if roomData.setting.roomType~=nil and roomData.setting.roomType~='' then
        roomType=roomData.setting.roomType
    else
        roomType=roomType
    end
    if playTypeString[roomType] then
        name = playTypeString[roomType]
    else
        name = 'xxx跑胡子'
    end
    local que = roomData.setting.size - (#playerData)
    local title = roomInfo.roomNumber.."房,"..roomData.playName..","..roomData.setting.size.."缺"..que	
    print("title",title)

    
    PlatformManager.Instance:ShareLink('http://'..panelLogin.HttpUrl..'/shareRoom.html?appType=1&state=' ..proxy_pb.PHZ..roomInfo.roomNumber, title , msg, 0)
end

function this.ClosePanelShare(go)
    panelShare.gameObject:SetActive(false)
end

function this.ShowPanelShare(go)
    panelShare.gameObject:SetActive(true)
end

function this.OnClicButtonCopy(go)

    local msg = '房号:' .. roomInfo.roomNumber
    msg = msg .. getWanFaText(roomData.setting,false,false, true)

    Util.CopyToSystemClipbrd(msg)
    panelMessageTip.SetParamers('复制成功', 1.5)
    PanelManager.Instance:ShowWindow('panelMessageTip')
end

function this.OnClickButtonNext(go)
    AudioManager.Instance:PlayAudio('btn')
    if RoundData.over and RoundAllData.over then
        PanelManager.Instance:HideWindow('panelChiPai')
        PanelManager.Instance:HideWindow('panelStageClear')
        PanelManager.Instance:HideWindow('panelInGameLand')
        PanelManager.Instance:ShowWindow('panelStageClearAll')
    else
        local msg = Message.New()
        msg.type = phz_pb.READY
        SendGameMessage(msg, nil)
    end
    this.RsetWhenStart()
    this.RsetWhenClickNextRound()
end

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
    local userData = {}
    userData.whoShow = gameObject.name
    userData.rseat 		= pData.seat
    userData.mySeat		= mySeat;
    userData.nickname   = pData.name
    userData.icon       = pData.icon
    userData.sex        = pData.sex
    userData.ip         = pData.ip
    userData.userId     = pData.id
    userData.balance    = pData.balance
    userData.address    = pData.address
    userData.imgUrl     = pData.imgUrl
    userData.gameType	= proxy_pb.PHZ;
    userData.signature  = pData.signature
    userData.sendMsgAllowed = roomData.setting.sendMsgAllowed
	userData.isShowSomeID = false
    userData.fee = pData.fee
	userData.gameMode = roomData.setting.gameMode
    PanelManager.Instance:ShowWindow('panelPlayerInfo', userData)
end

function this.OnSendChat(msg)
    local b = phz_pb.RChat()
    b:ParseFromString(msg.body)
    --print('OnSendChat seat:'..b.seat..' type:'..b.type)
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
            panelChat.AddChatToLabel(p.name .. ':' .. b.text)
        else
            table.insert(this.chatTexts, p.name .. ':' .. b.text)
        end
    end
end

function this.playVoice(vioceName)
    AudioManager.Instance:PlayAudio(vioceName)
end

function this.showText(index, text)
    local mark = false									--是否有两行需要输出（最大长度位10）
    coroutine.stop(playerCoroutine[index])
    playerCoroutine[index] = coroutine.start(
    function()
        playerMsg[index].gameObject:SetActive(true)
        if string.len(text) > 30 then
            local temp2 = string.sub(text, 31, string.len(text))
            local temp1 = string.sub(text, 1, 10 * 3) .. '\n'
            mark = true
            text = temp1 .. temp2
        end
        playerMsg[index]:GetComponent('UILabel').text = text
        playerMsg[index]:GetComponent('UILabel').color = Color(244/255,244/255,244/255)
        local width = playerMsg[index]:GetComponent('UILabel').width
        local height = playerMsg[index]:GetComponent('UILabel').height
        if mark then
            playerMsgBG[index]:GetComponent('UISprite').height = height * 2
        else
            playerMsgBG[index]:GetComponent('UISprite').height = height + 40
        end

        playerMsgBG[index]:GetComponent('UISprite').width = width + 40
        playerEmoji[index].gameObject:SetActive(false)
        coroutine.wait(5)
        playerMsg[index].gameObject:SetActive(false)
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

-- function this.JoinVoiceRoom()
--     if Util.GetPlatformStr() == 'win' then
--         return
--     end
--     coroutine.stop(voiceCor)
--     NGCloudVoice.Instance:OnMemberVoice(this, this.MemberVoiceHandler)
--     -- 设置加入房间回调
--     NGCloudVoice.Instance:OnJoinRoomCompleted(this, function(that, args)
--         -- 0: code; 1: roomName; 2: memberId
--         local memberId = args[2]
--         NGCloudVoice.Instance:ClearQuitRoomCompletedCallback();
--         that.ShieldVoiceEvent()
--         local existedMemberId = this.GetPlayerDataBySeat(mySeat).memberId
--         if existedMemberId and existedMemberId == memberId then
--            --print('已存在MemberId，且值未变化，不向服务器推送消息')
--             return
--         end
--         this.GetPlayerDataBySeat(mySeat).memberId = memberId
--         local msg = Message.New()
--         msg.type = phz_pb.VOICE_MEMBER
--         local body = phz_pb.PVoiceMember()
--         body.memberId = memberId
--         msg.body = body:SerializeToString()
--         SendGameMessage(msg, nil)
--     end)
--     -- 如果玩家已经在房间内，先退出再加入；否则直接加入
--     if NGCloudVoice.Instance:IsInRoom() then
--         NGCloudVoice.Instance:OnQuitRoomCompleted(this, function(that, args)
--             NGCloudVoice.Instance:ClearQuitRoomCompletedCallback()
--             coroutine.start(
--             function()
--                 coroutine.wait(3)
--                 that.JoinTeamRoom()
--             end
--             )
--         end)
--         NGCloudVoice.Instance:QuitRoom()
--     else
--         this.JoinTeamRoom()
--     end
--     voiceCor = coroutine.start(this.TickNGCloudVoice)
--     coroutine.stop(voiceCheckCor)
--     voiceCheckCor = coroutine.start(this.TickCheckVoice)
-- end
function this.TickNGCloudVoice()
    while gameObject.activeSelf do
        NGCloudVoice.Instance:Poll()
        coroutine.wait(0.03)
    end
end

-- local voiceMemeber = {}
-- local voiceCheckCor = nil
-- function this.TickCheckVoice()
--     while gameObject.activeSelf do
--         local curTime = os.time()
--         for i = #voiceMemeber, 1, -1 do
--             if curTime - voiceMemeber[i].time > 2 then
--                 if voiceMemeber[i].stat ~= 0 then
--                    --print('manual close memberId:' .. voiceMemeber[i].id)
--                     this.OnMemberVoiceStateChanged(voiceMemeber[i].id, 0)
--                 end
--                 table.remove(voiceMemeber, i)
--             end
--         end
--         coroutine.wait(2)
--     end
-- end
-- function this.JoinTeamRoom()
--     NGCloudVoice.Instance:SetModeRealTime()
--     NGCloudVoice.Instance:JoinTeamRoom('phz' .. roomInfo.roomNumber)
-- end
-- function this.QuitVoiceRoom()
--     if Util.GetPlatformStr() == 'win' then
--         return
--     end
--     NGCloudVoice.Instance:OnQuitRoomCompleted(this, function(that, args)
--         coroutine.stop(voiceCor)
--         NGCloudVoice.Instance:ClearQuitRoomCompletedCallback();
--     end)
--     NGCloudVoice.Instance:QuitRoom()
-- end
-- function this.MemberVoiceHandler(that, args)
--     -- a int array composed of [memberid_0, status,memberid_1, status ... memberid_2*count, status] here,
--     -- status could be 0, 1, 2. 0 meets silence and 1/2 means saying
--     local members = args[0]
--     local count = args[1]	-- count of members who's status has changed.
--     --print('MemberVoiceHandler:'..count)
--     for i = 0, count - 1 do
--         local index = i * 2
--         local memberId = members[index]
--         local status = members[index + 1]
--         that.OnMemberVoiceStateChanged(memberId, status)
--     end
-- end
-- function this.OnMemberVoiceStateChanged(memberId, status)
--     --print('OnMemberVoiceStateChanged memberId:'..memberId..' status:'..status)
--     if memberId == nil or status == nil then
--         return
--     end
--     local player = this.GetPlayerByMemberId(memberId)
--     if not player then
--         return
--     end
--     local index = this.GetUIIndexBySeat(player.seat)
--     local active = (status ~= 0)
--     playerSound[index].gameObject:SetActive(active)
--     -- 如果玩家已经屏蔽实时语音，退出
--     if UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 0 then
--         return
--     end
--     if active then
--         AudioManager.Instance.AudioOn = false
--         AudioManager.Instance.MusicOn = false
--         this.openSpeak = true
--     else
--         if not this.openMic then
--             AudioManager.Instance.AudioOn = UnityEngine.PlayerPrefs.GetInt('audio_on', 1) == 1
--             AudioManager.Instance.MusicOn = UnityEngine.PlayerPrefs.GetInt('music_on', 1) == 1
--         end
--         this.openSpeak = nil
--     end
--     local mem = nil
--     for i = 1, #voiceMemeber do
--         if voiceMemeber[i].id == memberId then
--             mem = voiceMemeber[i]
--             mem.stat = status
--             mem.time = os.time()
--             break
--         end
--     end
--     if not mem then
--         mem = {}
--         mem.id = memberId
--         mem.stat = status
--         mem.time = os.time()
--         table.insert(voiceMemeber, mem)
--     end
-- end
--是否按下录音键
local isPress = false;
--是否需要上传录音文件
local isUpload = false;
--静音前的音量值
local BGMvolume = 0
function this.OnPressButtonSound(go, state)
    -- if state then
    -- this.openMic = true
    -- AudioManager.Instance.AudioOn = false
    -- AudioManager.Instance.MusicOn = false
    -- if Util.GetPlatformStr() ~= 'win' then
    --     NGCloudVoice.Instance:OpenMic()
    -- end
    -- else
    -- ButtonSound:GetComponent('BoxCollider').enabled = false
    -- coroutine.start(
    -- function()
    --     coroutine.wait(1)
    --     if Util.GetPlatformStr() ~= 'win' then
    --         NGCloudVoice.Instance:CloseMic()
    --     end
    --     if not this.openSpeak then
    --         AudioManager.Instance.AudioOn = UnityEngine.PlayerPrefs.GetInt('audio_on', 1) == 1
    --         AudioManager.Instance.MusicOn = UnityEngine.PlayerPrefs.GetInt('music_on', 1) == 1
    --     end
    --    --print('AudioManager.Instance.AudioOn:' .. tostring(AudioManager.Instance.AudioOn))
    --     this.openMic = nil
    --     ButtonSound:GetComponent('BoxCollider').enabled = true
    -- end
    -- )
    -- end
    -- local index = this.GetUIIndexBySeat(mySeat)
    -- playerSound[index].gameObject:SetActive(state)
    print('roomData.setting.sendVoiceAllowed : '..tostring(roomData.setting.sendVoiceAllowed))
    if roomData.setting.sendVoiceAllowed then
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
--[[    @desc: 开始录音
    author:{author}
    time:2018-09-12 16:59:21
    @return:
]]
function this.StartRecord()
    WaitForSeconds(0)
    --当按住录音按钮超过0.5秒时才执行录音，因为多次短时间录的文件不会被下一次覆盖
    if isPress == true then
        isUpload = true;
        print("这里开始录制语音！！！！！！");
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
        print("这里开始上传录制完后的语音！！！！！！");
    end
end
--[[    @desc: 上传录音完成回调
    author:{author}
    time:2018-09-12 16:28:01
    --@fileid: 录音文件id
    @return:
]]
function this.UploadReccordFileComplete(fileid)
   --print('发送给服务器' .. fileid)
    local msg = Message.New()
    msg.type = phz_pb.VOICE_MEMBER
    local body = phz_pb.PVoiceMember()
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
   --print('下载完成' .. fileid)
    --停止播放背景音乐
    AudioManager.Instance.AudioOn = false
    AudioManager.Instance.MusicOn = false
    for i = 0, roomData.setting.size-1 do
        if this.GetPlayerDataByUIIndex(i).voiceId == fileid then
           --print('有相等的' .. fileid)
            playerSound[i].gameObject:SetActive(true);
        else
            playerSound[i].gameObject:SetActive(false);
        end
    end

end
--[[    @desc: 播放录音文件完成回调
    author:{author}
    time:2018-09-12 16:29:41
    @return:
]]
function this.PlayRecordFilComplete(fileid)
    --继续播放背景音乐
    if isPress == false then
        AudioManager.Instance.AudioOn = UnityEngine.PlayerPrefs.GetInt('audio_on', 1) == 1
        AudioManager.Instance.MusicOn = UnityEngine.PlayerPrefs.GetInt('music_on', 1) == 1
    end
    for i = 0, roomData.setting.size do
        if this.GetPlayerDataByUIIndex(i).voiceId == fileid then
           --print('有相等的' .. fileid)
            playerSound[i].gameObject:SetActive(false)
        end
    end

end
-- -- 开启或屏蔽其他玩家实时语音状态
-- function this.ShieldVoiceEvent()
--     local canOpenSpeaker = UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0)
--     if Util.GetPlatformStr() ~= 'win' then
--         if canOpenSpeaker == 1 then
--             NGCloudVoice.Instance:OpenSpeaker()
--         else
--             NGCloudVoice.Instance:CloseSpeaker()
--         end
--     end
-- end
-- -- 屏蔽其他玩家实时语音状态
-- function this.CloseVoiceEvent()
--     local canOpenSpeaker = UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0)
--     if Util.GetPlatformStr() ~= 'win' then
--         NGCloudVoice.Instance:CloseSpeaker()
--     end
-- end
-- -- 开启其他玩家实时语音状态
-- function this.OpenVoiceEvent()
--     local canOpenSpeaker = UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0)
--     if Util.GetPlatformStr() ~= 'win' then
--         NGCloudVoice.Instance:OpenSpeaker()
--     end
-- end
-- function this.GetPlayerByMemberId(memberId)
--     for i = 1, #playerData do
--         local p = playerData[i]
--         if p and p.memberId and p.memberId == memberId then
--             return p
--         end
--     end
--     return nil
-- end
function this.OnVoiceMember(msg)
    local b = phz_pb.RVoiceMember()
    b:ParseFromString(msg.body)
   --print('seat ' .. b.seat .. ' 的录音文件, fileid is ' .. b.voiceId)
    local player = this.GetPlayerDataBySeat(b.seat)
    if player then
        player.voiceId = b.voiceId
        NGCloudVoice.Instance:Click_btnDownloadFile(player.voiceId)
    else
       --print('无法通过座位号 ' .. b.seat .. ' 获取到用户信息')
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
   --print('pong'..Util.GetTime())
    local connect = NetWorkManager.Instance:FindConnet('game')
    if connect then
       --print('延迟'..connect.LastHeartBeatTime)
        pingLabel.text = int64.tonum2(Util.GetTime()) - int64.tonum2(connect.LastHeartBeatTime)
    else
        pingLabel.text = ''
    end
end

function this.OnClicButtonCloseRoom(go)
    AudioManager.Instance:PlayAudio('btn')
    if mySeat ~= 0 then
       --print('非房主退出')
        local msg = Message.New()
        this.fanHuiRoomNumber = nil
        msg.type = phz_pb.LEAVE_ROOM
        SendGameMessage(msg, nil)
    else
       --print('房主解散')
        local msg = Message.New()
        msg.type = phz_pb.DISSOLVE
        local body = phz_pb.PDissolve()
        body.decision = phz_pb.APPLY
        msg.body = body:SerializeToString()
        SendGameMessage(msg, nil)
    end
end

function this.OnClicButtonLeaveRoom(go)
   --print('返回大厅')
    print('OnClicButtonLeaveRoom '..mySeat)                                   --房主在lobby退出可以返回，房间留存
    if roomData.clubId == '0' then
       --print('不在牌友群中')
        this.SetMyAlpha(0)
        PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
        panelMessageTip.SetParamers('返回大厅后，您的房间将会继续保留哦', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
    else
       --print('在牌友群中')
        this.SetMyAlpha(0)
        PanelManager.Instance:ShowWindow('panelClub',{name = gameObject.name, clubId = roomData.clubId})
        panelMessageTip.SetParamers('返回俱乐部后，您的房间将会继续保留哦', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
    end
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
            data.name = 'panelInGameLand'
            -- data.clubId = roomData.clubId
            PanelManager.Instance:ShowWindow('panelClub', data)
        else
           --print('dddddddddddddddd')
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
        panelLogin.HideGameNetWaitting()
        if roomData.clubId ~= '0' then
            local data = {}
            data.name = 'panelInGameLand'
            PanelManager.Instance:ShowWindow('panelClub', data)
        else
            PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
        end
        roomData.clubId = '0'
        this.Destroy()
    end
    )
end

local isWillHU = false
function this.OnClickOperationButton(go)
    local msg = Message.New()
    if go.transform == ButtonHu then
        msg.type = phz_pb.HU_PAI
    elseif go.transform == ButtonPao then
        msg.type = phz_pb.PAO_PAI
    elseif go.transform == ButtonPeng then
        msg.type = phz_pb.PENG_PAI
        PanelManager.Instance:HideWindow('panelChiPai')
        if isWillHU then
            panelMessageBoxTiShi.SetParamers(ONLY_OK_CANCLE, function ()
                SendGameMessage(msg, nil)
                this.HideOperationSend()
            end, nil, '是否确定放弃胡牌？')
            PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
            return
        end
    elseif go.transform == ButtonChi then
        local quickChi = UnityEngine.PlayerPrefs.GetInt("phz_quickchi",0);
        if isWillHU then
            panelMessageBoxTiShi.SetParamers(ONLY_OK_CANCLE, function ()
                --快速吃牌
                if quickChi == 1 then
                    if #ROperationChiData.selectChi == 1 and #ROperationChiData.selectChi[1].childs<1 then
                        this.QuickChi()
                        return 
                    end
                end
                PanelManager.Instance:ShowWindow('panelChiPai')
                isShowPanelChiPai = true
            end, nil, '是否确定放弃胡牌？')
            PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
            return
        end
       
        --快速吃牌
        if quickChi == 1 then
            if #ROperationChiData.selectChi == 1 and #ROperationChiData.selectChi[1].childs<1 then
                this.QuickChi()
                return 
            end
        end
        PanelManager.Instance:ShowWindow('panelChiPai')
        isShowPanelChiPai = true
        return
    elseif go.transform == ButtonGuo then
        if ButtonHu.gameObject.activeSelf then
            -- panelMessageBoxTiShi.SetParamers(OK_CANCLE, this.OnHuPaiGuo, nil, '是否确定放弃胡牌？')
            -- PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
            msg.type = phz_pb.FOLD
            SendGameMessage(msg, nil)
            return
        else
            msg.type = phz_pb.FOLD
            PanelManager.Instance:HideWindow('panelChiPai')
        end
    elseif go.transform == ButtonTi then
        print('#ROperationChiData.plates : '..#ROperationChiData.plates)
        msg.type = phz_pb.TI_PAI
        if roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
            if isWillHU then
                panelMessageBoxTiShi.SetParamers(ONLY_OK_CANCLE, function ()
                    if #ROperationChiData.plates > 1 then
                        PanelManager.Instance:ShowWindow('panelChiPai')
                        return
                    end
                    SendGameMessage(msg, nil)
                    this.HideOperationSend()
                end, nil, '是否确定放弃胡牌？')
                PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
                return
            end 
            if #ROperationChiData.plates > 1 then
                PanelManager.Instance:ShowWindow('panelChiPai')
                return
            end
        end
    elseif go.transform == ButtonWei then
        msg.type = phz_pb.WEI_PAI
    else
        Debugger.LogError('OnClickOperationButton unkown button {0}', go.name)
    end
    if roomData.setting.roomTypeValue == proxy_pb.YJGHZ and go.transform ~= ButtonHu then
        if isWillHU then
            panelMessageBoxTiShi.SetParamers(ONLY_OK_CANCLE, function ()
                SendGameMessage(msg, nil)
                this.HideOperationSend()
            end, nil, '是否确定放弃胡牌？')
            PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
            return
        end 
    end
    SendGameMessage(msg, nil)
    this.HideOperationSend()
end

function this.QuickChi()
    this.SendQuikChiMsg(ROperationChiData.selectChi[1]);
    this.HideOperationSend();
    isShowPanelChiPai = false
end

function this.SendQuikChiMsg(chiData)
    local msg       = Message.New();
    msg.type        = phz_pb.CHI_PAI;
    local body      = phz_pb.POperation();
    local chiData   = chiData;
    local t_chiData = phz_pb.RSelectChi();
    t_chiData.id    = chiData.id;
    t_chiData.plates:append(chiData.plates[1]);
    t_chiData.plates:append(chiData.plates[2]);
    t_chiData.plates:append(chiData.plates[3]);
    table.insert(body.selectChi, t_chiData);

    msg.body = body:SerializeToString();
    SendGameMessage(msg, nil)
end

function this.OnHuPaiGuo()
    local msg = Message.New()
    msg.type = phz_pb.PASS_HU
    PanelManager.Instance:HideWindow('panelChiPai')
    if ButtonHu.gameObject.activeSelf and needChuPaiBefroeHu then
        needChuPai = needChuPaiBefroeHu
        chupaishoushi.gameObject:SetActive(needChuPai)
    end
    SendGameMessage(msg, nil)
    operation_send.gameObject:SetActive(false)

    --如果我操作了  则取消我自己的托管
    this.StopTrustesship()
end

function this.HideOperationSend()
    operation_send.gameObject:SetActive(false)

    --如果我操作了  则取消我自己的托管
    this.StopTrustesship()
end

function this.ShowTipEffect(effectName, seat)
    print('effectName : '..effectName)
    local index = this.GetUIIndexBySeat(seat)
    local eff = nil
    for i = 0, operation_receive.childCount - 1 do
        local item = operation_receive:GetChild(i)
        if not item.gameObject.activeSelf and item.name == effectName then
            eff = item
        end
    end
    if not eff then
        local res = ResourceManager.Instance:LoadAssetSync(effectName)
        eff = NGUITools.AddChild(operation_receive.gameObject, res)
        eff.name = effectName
    end

    eff.gameObject:SetActive(true)
    eff.transform.position = playerOperationEffectPos[index].position
end

--参数为UI对象
function RemoveHandPlatesUI(pGridHand, plateObjs)
    --print('RemoveHandPlatesUI:'..#plateObjs)
    for i = 1, #plateObjs do
        plateObjs[i]:SetActive(false)
        --print('hide plate '..plateObjs[i].name)
    end

    local GroupsNum = 0
    for i = 0, pGridHand.childCount - 1 do
        local group = pGridHand:GetChild(i)
        local grid = group:GetComponent('UIGrid')
        if grid then
            grid.repositionNow = true
            local active = false
            for j = 0, group.childCount - 1 do
                if group:GetChild(j).gameObject.activeSelf then
                    active = true
                    GroupsNum = GroupsNum + 1
                    break
                end
            end
            group.gameObject:SetActive(active)
        end
    end

    if pGridHand:GetChild(0).name == 'cardGroupXiReplay' then
        local cellWidth = Mathf.Clamp((9 - GroupsNum) * 4 + 34, 34, 45)
        pGridHand:GetComponent('UIGrid').cellWidth = cellWidth
    end
    pGridHand:GetComponent('UIGrid').repositionNow = true
end

--参数为ID
function RemoveHandPlatesUIByID(pGridHand, plates)
    local plateObjs = {}
    -- for i = 0, pGridHand.childCount - 1 do
    --     local group = pGridHand:GetChild(i)
    --     if group:GetComponent('UIGrid') then
    --         for j = 0, group.childCount - 1 do
    --             local item = group:GetChild(j)
    --             if item.gameObject.activeSelf then
    --                 table.insert(plateObjs, item)
    --             end
    --         end
    --     elseif group.gameObject.activeSelf then
    --         --当玩家正拖动要偎的牌时，该牌对应的UI结构发生变化，所以添加如下代码防止漏删
    --         table.insert(plateObjs, group)
    --     end
    -- end
    --改成倒序遍历
    for i = pGridHand.childCount - 1, 0, -1 do
        local group = pGridHand:GetChild(i)
        if group:GetComponent('UIGrid') then
            if group.gameObject.activeSelf then
                for j = 0, group.childCount - 1 do
                    local item = group:GetChild(j)
                    if item.gameObject.activeSelf then
                        table.insert(plateObjs, item)
                    end
                end
            end
        elseif group.gameObject.activeSelf then
            --当玩家正拖动要偎的牌时，该牌对应的UI结构发生变化，所以添加如下代码防止漏删
            table.insert(plateObjs, group)
        end
    end

    local needRemovePlates = {}
    for i = 1, #plateObjs do
        local id = GetUserData(plateObjs[i].gameObject)
        for k = #plates, 1, -1 do
            if plates[k] == id then
                table.insert(needRemovePlates, plateObjs[i].gameObject)
                table.remove(plates, k)
                --print(item.parent.gameObject.name)
                break
            end
        end
    end
    RemoveHandPlatesUI(pGridHand, needRemovePlates)
end

function this.DoRemovePlates(seat, plates, isgnoreUI)
    local pData = this.GetPlayerDataBySeat(seat)
    if not pData then
       --print('pData is nil')
        return
    end

    for i = 1, #plates do
        local p = plates[i]
        print('temp : '..p)
        for j = #pData.hands, 1, -1 do
            if pData.hands[j] == p then
                table.remove(pData.hands, j)
                break
            end
        end
    end

    if not isgnoreUI then
        RemoveHandPlatesUIByID(playerGridHand, plates)
    end
end

function this.RereshOperationSend(operations, from)
    print('RereshOperationSend:' .. #operations ..' '..from)
    operation_send.gameObject:SetActive(#operations ~= 0)
    ButtonHu.gameObject:SetActive(false)
    ButtonPao.gameObject:SetActive(false)
    ButtonPeng.gameObject:SetActive(false)
    ButtonChi.gameObject:SetActive(false)
    ButtonGuo.gameObject:SetActive(false)
    ButtonWei.gameObject:SetActive(false)
    ButtonTi.gameObject:SetActive(false)
    isWillHU = false
    local str = ''
    for i = 1, #operations do
        if operations[i].operation == phz_pb.CHI then
            print('RereshOperationSend:' .. #operations .. ' 吃')
            ButtonChi.gameObject:SetActive(true)
            ButtonGuo.gameObject:SetActive(true)
            ROperationChiData = operations[i]
            print('selectChi num:'..#ROperationChiData.selectChi)
            str = str .. ' 吃'
        elseif operations[i].operation == phz_pb.PENG then
           --print('RereshOperationSend:' .. #operations .. ' 碰')
            ButtonPeng.gameObject:SetActive(true)
            ButtonGuo.gameObject:SetActive(true)
            str = str .. ' 碰'
        elseif operations[i].operation == phz_pb.PAO then
           --print('RereshOperationSend:' .. #operations .. ' 跑')
            ButtonPao.gameObject:SetActive(true)
            if roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
                ButtonGuo.gameObject:SetActive(true)
            end
            str = str .. ' 跑'
        elseif operations[i].operation == phz_pb.HU then
           --print('RereshOperationSend:' .. #operations .. ' 胡')
            ButtonHu.gameObject:SetActive(true)
            ButtonGuo.gameObject:SetActive(true)
            str = str .. ' 胡'
            isWillHU = true
        elseif operations[i].operation == phz_pb.WEI then
            if roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
                ButtonWei.gameObject:SetActive(true)
                ButtonGuo.gameObject:SetActive(true)
            else
                 operation_send.gameObject:SetActive(false)
            end
        elseif operations[i].operation == phz_pb.TI then
           --print('RereshOperationSend:' .. #operations .. ' 为题')
           ROperationChiData = operations[i]
           if roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
                ButtonTi.gameObject:SetActive(true)
                ButtonGuo.gameObject:SetActive(true)
           else
                operation_send.gameObject:SetActive(false)
           end
        else
            Debugger.LogError('RereshOperationSend unkown type {0}', tostring(operations[i].operation))
        end
    end
    
    if roomData.setting.roomTypeValue ~= proxy_pb.YJGHZ then
        if ButtonPao.gameObject.activeSelf and ButtonHu.gameObject.activeSelf then
            ButtonPao.gameObject:SetActive(false)
        elseif ButtonPao.gameObject.activeSelf and not ButtonHu.gameObject.activeSelf then
            operation_send.gameObject:SetActive(false)
        end
    end
    if ButtonHu.gameObject.activeSelf then
        needChuPaiBefroeHu = needChuPai
        needChuPai = false
        chupaishoushi.gameObject:SetActive(needChuPai)
    end

    operation_send:GetComponent('UITable'):Reposition()
    if str ~= '' then
        --print(str)
    end

    if #operations ~= 0 then
        this.SetDelegateCount(mySeat);
    else
        this.StopTrustesship();        
    end

end

function this.ShowWaitOpreatEffect(seat, show)
    local index = this.GetUIIndexBySeat(seat)
    coroutine.stop(conCountDown)
    for i = 0, 3 do
        if index == i then
            playerIcon[i]:Find('waitOpreatEffect').gameObject:SetActive(show)
            kuang01[i].gameObject:SetActive(show)
        else
            playerIcon[i]:Find('waitOpreatEffect').gameObject:SetActive(false)
            kuang01[i].gameObject:SetActive(false)
        end
        if show then
            if index == i then
                conCountDown = coroutine.start(
                    function()
                        if roomData.setting.trusteeship == 0 then
                            remainTime = -1
                        else
                            if roomData.trusteeshipRemainMs>0 then
                                remainTime = roomData.trusteeshipRemainMs
                            else
                                remainTime = roomData.setting.trusteeship
                            end
                        end
                        print('roomData.trusteeshipRemainMs : '..roomData.trusteeshipRemainMs..' roomData.setting.trusteeship : '..roomData.setting.trusteeship)
						
                        while remainTime >= 0 and roomData.setting do
                            playerTrusteeshipTime[i]:GetComponent('UILabel').text = remainTime
                            playerTrusteeshipTime[i].gameObject:SetActive((roomData.setting.trusteeship-remainTime>15))
                            remainTime = remainTime -1
                            coroutine.wait(1)
                        end
                    end
                    );
            else
                playerTrusteeshipTime[i].gameObject:SetActive(false)
            end
		else
			playerTrusteeshipTime[i].gameObject:SetActive(false)
		end
    end
    --if roomData.state == phz_pb.GAMING and seat == mySeat then
    --    this.SetDelegateCount(seat);
    --end


    --print('ShowWaitOpreatEffect seat:'..seat..' show:'..tostring(show))
end

function this.GetRoomSetting()
    return roomData.setting
end

function this.ChiPaiPosition()
    return ButtonChi.position
end

function this.SetMyAlpha(alpha)
    gameObject.transform:GetComponent('UIPanel').alpha = alpha
end

function this.OnClickButtonToRoom()
    this.SetMyAlpha(1)
    PanelManager.Instance:ShowWindow(gameObject.name)
end

function this.OnChoicePiao(msg)
    local body = phz_pb.RChoicePiao()
    body:ParseFromString(msg.body)
    print('有人选择了飘玩法 : '..body.piao)
    this.GetPlayerDataBySeat(body.seat).piao = body.piao
    if body.seat == mySeat then
        playPiaoView.gameObject:SetActive(false)
    end
    if body.piao then
        playerPiao[this.GetUIIndexBySeat(body.seat)].gameObject:SetActive(true)
        playerPiao[this.GetUIIndexBySeat(body.seat)]:GetComponent('UILabel').text = body.piao ~= 0 and ('飘'..body.piao..'分') or ''
    end
end
function this.CheckNeedOpenPlayPiao()
    playPiaoView.gameObject:SetActive(false)
    if roomData.setting.piao ~= 0 and roomData.setting.size == #playerData  then
        for i=1,#playerData do
            if playerData[i].ready == false then
                return 
            end
        end
		if roomData.setting.roomTypeValue ~= proxy_pb.CZZP then
            return 
        end
        local data = this.GetPlayerDataBySeat(mySeat)
        if data.piao == -1 then
            playPiaoView.gameObject:SetActive(true)
            for i = 1 , playPiaoView.childCount - 1 do
                local piao = 0
                if roomData.setting.piao == 1 then
                    piao = i
                elseif roomData.setting.piao == 2 then
                    if i == 1 then
                        piao = 2
                    elseif i == 2 then
                        piao = 3
                    elseif i == 3 then
                        piao = 5
                    end
                elseif roomData.setting.piao == 3 then
                    if i == 1 then
                        piao = 3
                    elseif i == 2 then
                        piao = 5
                    elseif i == 3 then
                        piao = 10
                    end
                end
                playPiaoView:GetChild(i):Find('Label'):GetComponent('UILabel').text = '飘'..piao..'分'
            end
        end
        this.RestButtonState()
    end
end
function this.OnClickChoicePiao(go)
    local piao = 0
    if tonumber(go.name) ~= 0 then
        piao = tonumber(string.match(go.transform:Find('Label'):GetComponent('UILabel').text,'%d+'))
    end
    local msg = Message.New()
    msg.type = phz_pb.CHOICE_PIAO
    local body = phz_pb.PChoicePiao()
    body.piao = piao
    msg.body = body:SerializeToString()
    print('我选择了飘： '..piao)
    SendGameMessage(msg)
end
function this.OnChoiceNiao(msg)
    local body = phz_pb.RChoiceNiao()
    body:ParseFromString(msg.body)

   --print('有人选择了打鸟玩法')

    this.GetPlayerDataBySeat(body.seat).daNiao = body.niao and 1 or 2 

    if body.seat == mySeat then
        PlayNiaoView.gameObject:SetActive(false)
    end

    if body.niao then
        playerNiao[this.GetUIIndexBySeat(body.seat)].gameObject:SetActive(true)
    end
end

function this.CheckNeedOpenPlayNiao()
    PlayNiaoView.gameObject:SetActive(false)
   --print('是不是娄底放炮罚：'..tostring(roomData.setting.roomTypeValue == proxy_pb.LDFPF)..' 有没有开启打鸟：'..tostring(roomData.setting.niao))
    if roomData.setting.niao and roomData.setting.size == #playerData  then
        for i=1,#playerData do
            if playerData[i].ready == false then
                return 
            end
        end
        
        local playerData = this.GetPlayerDataBySeat(mySeat)

       --print('我有没有选择打鸟'..playerData.daNiao)
        if playerData.daNiao == 0 then
            PlayNiaoView.gameObject:SetActive(true)
        end

        this.RestButtonState()
    end
end

function this.OnClickChoiceNiao(go)
    local niao = false
    if PlayNiao.gameObject == go then
        niao = true
    end
    
    local msg       = Message.New()
    msg.type        = phz_pb.CHOICE_NIAO
    local body      = phz_pb.PChoiceNiao();
    body.niao = niao
    msg.body = body:SerializeToString();

    SendGameMessage(msg)
end

function this.CheckNeedOpenPlayTuo()
    PlayTuoView.gameObject:SetActive(false)
   --print('是不是湘乡告胡子：'..tostring(roomData.setting.roomTypeValue == proxy_pb.XXGHZ)..' 有没有开启打鸟：'..tostring(roomData.setting.tuo))
    if roomData.setting.roomTypeValue == proxy_pb.XXGHZ and roomData.setting.tuo and roomData.setting.size == #playerData  then
        for i=1,#playerData do
            if playerData[i].ready == false then
                return 
            end
        end
        
        local playerData = this.GetPlayerDataBySeat(mySeat)

        if playerData.daTuo == 0 then
            PlayTuoView.gameObject:SetActive(true)
        end
        
        --ButtonCloseRoom.gameObject:SetActive(false)  
        this.RestButtonState() 
    end
end

function this.OnClickChoiceTuo(go)
    local tuo = false
    if PlayTuo.gameObject == go then
        tuo = true
    end
    
    local msg       = Message.New()
    msg.type        = phz_pb.CHOICE_TUO
    local body      = phz_pb.PChoiceTuo();
    body.tuo = tuo
    msg.body = body:SerializeToString();

    SendGameMessage(msg)
end

function this.OnChoiceTuo(msg)
    local body = phz_pb.RChoiceTuo()
    body:ParseFromString(msg.body)

    this.GetPlayerDataBySeat(body.seat).daTuo = body.tuo and 1 or 2 

    if body.seat == mySeat then
        PlayTuoView.gameObject:SetActive(false)
    end

    if body.tuo then
        playerTuo[this.GetUIIndexBySeat(body.seat)].gameObject:SetActive(true)
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

function this.NotifyGameStart()
    --通知玩家返回游戏
    if #playerData == roomData.setting.size and roomData.round == 1 and roomData.state ~= phz_pb.GAMING then
        if this.OnRoundStarted ~= nil then
			this.OnRoundStarted()
		end
	end
end

function this.OnAutoDissolve(msg)
    local body = phz_pb.RAutoDissolve()
    body:ParseFromString(msg.body)

    IsAutoDissolve = true
    AutoDissolveData = body
    PanelManager.Instance:ShowWindow('panelAutoDissolve', AutoDissolveData)
   --print('----------------------------------自动解散了----------------------------------------')
end

function this.OnHuangDissolve(msg)
    print("OnHuangDissolve------------------>was called");
    local body = phz_pb.RSeat();
    body:ParseFromString(msg.body);
    IsAutoDissolve = true
    AutoDissolveData = {};
    AutoDissolveData.huangDissolve = true;
    AutoDissolveData.seat = body.seat;
    AutoDissolveData.phzAutoDissolve = roomData.setting.phzAutoDissolve;
    PanelManager.Instance:ShowWindow('panelAutoDissolve', AutoDissolveData)
end

function this.ShowStageClear()
    PanelManager.Instance:ShowWindow('panelStageClear')
end



function this.OnTrustesship(msg)
    local body = phz_pb.RTrusteeship();
    body:ParseFromString(msg.body);

   --print('-----------------------------------------有人托管了-------------------------------------------')
   --print('托管的位置：'..tostring(body.seat));
   --print('托管是否开启：'..tostring(body.enable));

    roomData.trusteeshipRemainMs = -1;--这里赋值为-1，然后再ShowWaitOpreatEffect就会启用配置的时间

    this.SetMyseflInTrustesship(body.seat, body.enable);
    this.GetPlayerDataBySeat(body.seat).trusteeship = body.enable;
    --this.ShowWaitOpreatEffect(body.seat,true);

    --this.SetDelegateCount(body.seat);
    playerTrusteeship[this.GetUIIndexBySeat(body.seat)].gameObject:SetActive(body.enable)
end

function this.SetMyseflInTrustesship(seat, enable)
    if seat == mySeat then
        PanelManager.Instance:HideWindow('panelChiPai')
        PanelManager.Instance:HideWindow('panelMessageBoxTiShi')
        --operation_mask.gameObject:SetActive(enable);
        DelegatePanel.gameObject:SetActive(enable)
        DelegateTime.gameObject:SetActive(false);
    end
end

--取消托管
function this.OnClickCancelTrustesship(go)
    print("OnClickCancelTrustesship was called")
    local msg = Message.New()
    msg.type = phz_pb.TRUSTEESHIP
    local body = phz_pb.PTrusteeship()
    body.enable = false
    msg.body = body:SerializeToString();
    DelegateTime.gameObject:SetActive(false);
    DelegatePanel.gameObject:SetActive(false);
    SendGameMessage(msg)
    if lastOperat.seat == mySeat and (lastOperat.op == phz_pb.WEI_PAI or lastOperat.op == phz_pb.TI or lastOperat.op == phz_pb.PAO_PAI) then
        needChuPai=true
        line.gameObject:SetActive(needChuPai)
    end
end


--设置托管
function this.SetDelegateCount(seat)
    print("SetDelegateCount was called--------------------->");
    this.StopTrustesship()
    trusteeshipcor = coroutine.start(
            function()

                local trusteeshipTime = -1;
                print("roomData.trusteeshipRemainMs:"..roomData.trusteeshipRemainMs);
                if roomData.trusteeshipRemainMs >0 then
                    trusteeshipTime = roomData.trusteeshipRemainMs;
                    roomData.trusteeshipRemainMs = roomData.setting.trusteeship;
                else
                    trusteeshipTime = roomData.setting.trusteeship;
                end

                local pData = this.GetPlayerDataBySeat(seat);
                if pData.trusteeship then--如果处于托管中，那么时间置为0
                    trusteeshipTime = 0;
                    if seat == mySeat then
                        this.SetMyseflInTrustesship(seat,true);
                    end
                end

                print("offlineState :"..tostring(offlineState));
                print(tostring(trusteeshipTime >= 0))
                while trusteeshipTime >= 0 and (not offlineState) do

                    coroutine.wait(1);
                    --print("trusteeshipTime------>"..trusteeshipTime.."seat:"..seat..",myseat:"..mySeat);

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

function this.StopTrustesship()
    print("------------------------停止托管计时------------------------------")
    coroutine.stop(trusteeshipcor);
    trusteeshipcor = nil;
    DelegateTime.gameObject:SetActive(false);
end

function this.OnGameError(msg)
    local error = phz_pb.RError()
    error:ParseFromString(msg.body)

    panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, error.info)
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.OnGuoHu(msg)
    print("------------------过胡----------------------")
    panelMessageBoxTiShi.SetParamers(ONLY_OK_CANCLE, this.OnHuPaiGuo, nil, '是否确定放弃胡牌？')
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.StartOfflineIncrease(seat, startTime)
	this.StopOfflineIncrease(seat)
	print('------------------有人离线，开始离线计时'..(seat)..'----------------------')

	local offlineTime = playerOfflineTime[this.GetUIIndexBySeat(seat)];
	playerOfflineCoroutines[this.GetUIIndexBySeat(seat)] = coroutine.start(this.OfflineIncrease, offlineTime, startTime)
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
		local coroutines =  playerOfflineCoroutines[i]
		if coroutines ~= nil then
			coroutine.stop(coroutines)
			coroutines = nil;
		end
	end
end

--牌面检测
--paltes 是已经排好序的牌比如{0,0,0,1,1,1,1,3,3,3,3,4,4,4,4}
function this.PlateInvalidCheck(plates)

    local checkResult = {};
    if not plates then
        checkResult.pass = false;
        checkResult.plate = -1;
        return checkResult;
    end

    --排序
    table.sort(plates,tableSortAsc);

    local count = 0;
    local checkPlate = plates[1];
    for i = 1, #plates do
        --print("check plate:".. this.GetPlateWenzi( plates[i]));
        if plates[i] == checkPlate then
            count = count + 1;
            if count > 4 then
                checkResult.pass = false;
                checkResult.plate = plates[i];
                return checkResult;
            end
        else
            count = 1;
            checkPlate = plates[i];
        end
    end

    checkResult.pass = true;
    checkResult.plate = nil;
    return checkResult;
end

--获取需要检测的所有牌
function this.GetCheckPlates()

    local plates = {};

    for i = 1, roomData.setting.size do

        local pData = playerData[i];
        if pData ~= nil then
            if pData.seat == mySeat then
                --1.自己手上的牌
                tableAdd(plates,this.GetGridHandPlates(playerGridHand));
                --2.自己的吃碰的牌
                tableAdd(plates,this.GetGridXiPlates(playerGridXi[this.GetUIIndexBySeat(pData.seat)]));
                --3.自己打出的牌
                tableAdd(plates,this.GetTableThrowPlates(playerThrow[this.GetUIIndexBySeat(pData.seat)]));
            else
                --4.别人手上的牌
                tableAdd(plates,this.GetTableThrowPlates(playerThrow[this.GetUIIndexBySeat(pData.seat)]));
                --5.别人吃碰的牌
                tableAdd(plates,this.GetGridXiPlates(playerGridXi[this.GetUIIndexBySeat(pData.seat)]));
            end
        end

    end

    --插入干扰项 只是测试的时候用
    --for i = 1, #plates do
    --    if plates[i] == 4 then
    --        table.insert(plates,4);
    --        table.insert(plates,4);
    --        table.insert(plates,4);
    --        table.insert(plates,4);
    --    end
    --end
    return plates;

end


--获取手上的牌
function this.GetGridHandPlates(playerGridHand)
    local plates = {};
    for j = 1, playerGridHand.childCount do
        local firstGrid = playerGridHand:GetChild(j-1);
        if firstGrid:GetComponent('UIGrid') then
            if firstGrid.gameObject.activeSelf then
                for k = 1, firstGrid.childCount do
                    local plateObj = firstGrid:GetChild(k-1);
                    if plateObj.gameObject.activeSelf then
                        local plate = GetUserData(plateObj.gameObject);
                        table.insert(plates,plate);
                    end
                end
            end
        elseif firstGrid.gameObject.activeSelf then--因为有正在拖动的牌
            local plate = GetUserData(firstGrid.gameObject);
            table.insert(plates,plate);
        end
    end
    return plates;
end


--获取吃碰杠的牌
function this.GetGridXiPlates(playerGridXi)
    local plates = {};
    for j = 1, playerGridXi.childCount do
        local firstGrid = playerGridXi:GetChild(j-1);
        if firstGrid.gameObject.activeSelf then
            for k = 1, firstGrid.childCount do
                local plateObj = firstGrid:GetChild(k-1);
                if plateObj.gameObject.activeSelf then
                    local plate = GetUserData(plateObj.gameObject);
                    table.insert(plates,plate);
                end
            end
        end
    end

    return plates;

end


--获取打出去的牌
function this.GetTableThrowPlates(playerTableThrow)

    local plates = {};
    for i = 1, playerTableThrow.childCount do
        local plateObj = playerTableThrow:GetChild(i-1);
        if plateObj.gameObject.activeSelf then
            local plate = GetUserData(plateObj.gameObject);
            table.insert(plates,plate);
        end
    end
    return plates;
end

--取消正在拖拽中的牌
function this.CancelDragPlate()
    if UICamera.currentTouch and UICamera.currentTouch.dragged then
        UICamera:Notify(UICamera.currentTouch.dragged, "OnDragEnd", nil)
    end
end
--
--local palteWenzi=
--{
--    "小一",
--    "小二",
--    "小三",
--    "小四",
--    "小五",
--    "小六",
--    "小七",
--    "小八",
--    "小九",
--    "小十",
--    "大壹",
--    "大貮",
--    "大叁",
--    "大肆",
--    "大伍",
--    "大陸",
--    "大柒",
--    "大玐",
--    "大玖",
--    "大拾",
--}

--function this.GetPlateWenzi(palte)
--    return palteWenzi[palte+1];
--end


function this.OnPlayerEmoji(msg)
    local b = phz_pb.RGift()
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
        coroutine.stop(playerEmojiCoroutine[this.GetUIIndexBySeat(b.seat)])
        StartCoroutine(function()
            PanelManager.Instance:HideWindow('panelPlayerInfo');
            local positionFrom  = playerIcon[this.GetUIIndexBySeat(b.seat)].position;
            local positionTo    = playerIcon[this.GetUIIndexBySeat(b.rseat)].position;
            local animation     = playerAnimation[this.GetUIIndexBySeat(b.seat)];

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
                this.playEmoji(this.GetUIIndexBySeat(b.seat),inx,name,time,soundName);
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
            coroutine.wait(time);
        end
        playerAnimation[myseatinx].gameObject:SetActive(false);
    end)
end