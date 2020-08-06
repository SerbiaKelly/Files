require("BBTZ.BBTZ_Logic")
require("GameTools")
local bbtz_pb = require("bbtz_pb")
local EventDispatcher = require("Event.EventDispatcher")

panelInGame_bbtz = {}
local this = panelInGame_bbtz
local logic = nil
local message = nil
local gameObject = nil
local roomStateBtns = {}
local recordTiShi = nil
local TrusteeshipView = {}
local trusteeshipCoroutine = nil
this.myseflDissolveTimes = 0
function panelInGame_bbtz.Awake(go)
    gameObject = go
    this.gameObject = go
    message = gameObject:GetComponent('LuaBehaviour')
    logic = BBTZ_Logic.New(panelInGame_bbtz, bbtz_pb, 5, gameObject)
    
    logic.InitView:Add(this.OnInitView, nil)
    logic.JoinRoom:Add(this.OnJoinRoom, nil)
    logic.PlayerJoin:Add(this.OnRefreshRoomButtons, nil)
    logic.PlayerLeave:Add(this.OnRefreshRoomButtons, nil)
    logic.PlayerOptionWait:Add(this.OnPlayerOptionWait, nil)
    logic.PlayerActive:Add(this.OnPlayerActive, nil)
    logic.Trusteeship:Add(this.OnTrusteeship, nil)
    logic.RoundStart:Add(this.OnRoundStarted,nil);
    

    recordTiShi = gameObject.transform:Find("RecordTiShi")
    local settingButton = gameObject.transform:Find("Top/Buttons/ButtonSetting")
    local refreshButton = gameObject.transform:Find("Top/Buttons/ButtonRefresh")
    local chatButton = gameObject.transform:Find("ButtonChat")
    local soundButton = gameObject.transform:Find("ButtonSound")
    local roomStateBtn = gameObject.transform:Find("RoomStateBtns")
    roomStateBtns.gameObject = roomStateBtn.gameObject
    roomStateBtns.InviteButton = roomStateBtn.transform:Find("ButtonInvite")
    roomStateBtns.ExitButton = roomStateBtn.transform:Find("ButtonCloseRoom")
    roomStateBtns.BackButton = roomStateBtn.transform:Find("ButtonExitRoom")

    TrusteeshipView.gameObject = gameObject.transform:Find("Trusteeship").gameObject
    TrusteeshipView.TipPanel = gameObject.transform:Find("Trusteeship/TipPanel")
    TrusteeshipView.CancelPanel = gameObject.transform:Find("Trusteeship/CancelPanel")
    local cancelTrusteeshipBtn = TrusteeshipView.CancelPanel:Find("CancelTrusteeshipBtn")

    message:AddClick(settingButton.gameObject, this.OnClickSetting)
    message:AddClick(refreshButton.gameObject, this.OnClickRefreshButton)
    message:AddClick(chatButton.gameObject, this.OnClickChat)
    message:AddClick(cancelTrusteeshipBtn.gameObject, this.OnClickCancelTrusteeship)
    message:AddPress(soundButton.gameObject, this.OnPressButtonSound);
    AddChildsClick(message, roomStateBtns.gameObject.transform, this.OnClickRoomButton)

    local roomTime = gameObject.transform:Find("Top/Time")
	local network = gameObject.transform:Find('Top/Network'):GetComponent('UISprite');
    local batteryLevel = gameObject.transform:Find('Top/Battery/level'):GetComponent('UISprite');
    coroutine.start(RefreshTime, roomTime:GetComponent('UILabel'), 60)
    coroutine.start(RefreshPhoneState, gameObject, logic, batteryLevel, network)

    
end

function this.Update()

end

function this.WhoShow(name)
    panelInGame = {}
    panelInGame = panelInGame_bbtz
    panelInGame.OnRoundStarted = nil
    panelInGame.fanHuiRoomNumber = roomInfo.roomNumber
    panelInGame.needXiPai=false
    PanelManager.Instance:HideAllWindow()
    PanelManager.Instance:ShowWindow(gameObject.name)
    logic:Init();
end

function this.OnEnable()
    AudioManager.Instance:PlayMusic('ZD_Bgm', true)
    recordTiShi.gameObject:SetActive(false)
    panelInGame_bbtz.BackgroundChange(GetCurBackground())
    EventDispatcher.Instance:RemoveAllEvent("GameBackgroundChange")
    EventDispatcher.Instance:AddEvent("GameBackgroundChange", panelInGame_bbtz.BackgroundChange)
end

function this.OnApplicationFocus()

end

function this.SetMyAlpha(alpha)
    gameObject.transform:GetComponent('UIPanel').alpha = alpha
end

function this.ChangePaiSize(bbtzPaiSize)
    if logic then
        logic:ChangePaiSize(bbtzPaiSize);
    end
end

function this.BackgroundChange(ground)
    local Background = gameObject.transform:Find("Background")
    local changedBackground = gameObject.transform:Find("Background/Bg"..ground)
    if ground == 1 then
		Background:GetComponent('UITexture').mainTexture = changedBackground:GetComponent('UITexture').mainTexture
	elseif ground == 2 then
		Background:GetComponent('UITexture').mainTexture = changedBackground:GetComponent('UITexture').mainTexture
	elseif ground == 3 then
		Background:GetComponent('UITexture').mainTexture = changedBackground:GetComponent('UITexture').mainTexture
	elseif ground == 4 then
		Background:GetComponent('UITexture').mainTexture = changedBackground:GetComponent('UITexture').mainTexture
	end
end

function this.NotifyGameStart()
	--通知玩家返回游戏
	if logic:GetPlayerDataLength() == (roomData.setting.size) and roomData.round == 1 and panelInGame_bbtz.OnRoundStarted ~= nil then
		panelInGame_bbtz.OnRoundStarted()
        panelInGame_bbtz.OnRoundStarted = nil
	end
end

function this.GetPlayerDataBySeat(seat)
    return logic:GetPlayerDataBySeat(seat)
end

function this.IsAllReaded()
    return logic:IsAllReaded()
end

function this.OnInitView()
    this.StopTrusteeshipVerification()
    TrusteeshipView.CancelPanel.gameObject:SetActive(false)
end

function this.OnJoinRoom(data)
    panelInGame.needXiPai=false
    SetChildActive(roomStateBtns.gameObject.transform, data.room.state == bbtz_pb.READYING)
    SetLabelText(roomStateBtns.ExitButton:Find("Label"), logic.mySeat == 0 and "解散房间" or "离开房间")
    this.OnTrusteeship(logic.mySeat, logic:GetPlayerDataBySeat(logic.mySeat).trusteeship)
end

function this.OnRoundStarted(data)
    SetChildActive(roomStateBtns.gameObject.transform, false);
    if logic.roomData.round == 1 and (not (logic.roomData.setting.size == 2)) then
        local datas = {}
        for i = 0, logic.roomData.setting.size - 1 do
            datas[i] = logic:GetPlayerDataByUIIdex(i)
        end
        InspectIPAndGPS(datas,logic.roomData.setting.size == 3 and pos3 or pos4,function()
            local msg       = Message.New()
            msg.type        = bbtz_pb.DISSOLVE
            local body      = bbtz_pb.PDissolve()
            body.decision   = bbtz_pb.APPLY
            msg.body        = body:SerializeToString()
            SendGameMessage(msg, nil)
        end)   
    end
end

function this.OnRefreshRoomButtons()
    if roomData.state ~= bbtz_pb.READYING then return end
    local isFull = logic:GetPlayerDataLength() == roomData.setting.size;
    print("isFull:"..tostring(isFull));
    OpenChild(roomStateBtns.gameObject.transform)
    roomStateBtns.InviteButton.gameObject:SetActive(not isFull)
    GridResetPosition(roomStateBtns.gameObject.transform)
    if isFull then panelInGame_bbtz.NotifyGameStart() end
end

function this.OnPlayerOptionWait()
    SetChildActive(roomStateBtns.gameObject.transform, false)
    this.NotifyGameStart()
end

function this.OnPlayerActive(enable, time)
    -- print("ActiveEnable:", enable)
    if roomData.setting.trusteeship == 0 or logic:GetPlayerDataBySeat(logic.mySeat).trusteeship then
        return
    end
    this.StopTrusteeshipVerification()
    if enable then
        this.StartTrusteeshipVerification(time)
    end
end

function this.StartTrusteeshipVerification(time)
    -- print("要快点操作啊 托管开始倒计时了", time)
    trusteeshipCoroutine = StartTrusteeshipVerification(time, function(i) 
        TrusteeshipView.TipPanel.gameObject:SetActive(true)
        SetLabelText(TrusteeshipView.TipPanel:Find("Time"), i)
    end, function() 
        TrusteeshipView.TipPanel.gameObject:SetActive(false)
    end)
end

function this.StopTrusteeshipVerification()
    StopTrusteeshipVerification(trusteeshipCoroutine)
    TrusteeshipView.TipPanel.gameObject:SetActive(false)
end

function this.OnTrusteeship(seat, enable)
    if seat ~= logic.mySeat then
        return
    end
    if not enable and roomData.activeSeat == logic.mySeat then
        this.StartTrusteeshipVerification(roomData.setting.trusteeship)
    end
    this.StopTrusteeshipVerification()
    TrusteeshipView.CancelPanel.gameObject:SetActive(enable)
end

function this.OnClickCancelTrusteeship(go)
	local body = bbtz_pb.PTrusteeship()
	body.enable = false
	logic:SendGameMsg(bbtz_pb.TRUSTEESHIP, body:SerializeToString())
end

function this.OnClickSetting(go)
    AudioManager.Instance:PlayAudio('btn')
    local inGameing = IsGaming(logic, roomData) or logic.mySeat == 0
    PanelManager.Instance:ShowWindow("panelGameSetting_bbtz", {inGameing = inGameing, logic = logic,roomData = roomData});
end

function this.OnClickRefreshButton(go)
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:RestartGame()
end

function this.OnClickChat(go)
    AudioManager.Instance:PlayAudio('btn')
    if roomData.setting.sendMsgAllowed then 
        PanelManager.Instance:ShowWindow("panelChat");
    else
        panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '群主已经禁止游戏过程中聊天，如有疑问请联系群主')
        PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
    end
end

function this.OnClickRoomButton(go)
    print("OnClickRoomButton was")
    AudioManager.Instance:PlayAudio('btn')
    if go.gameObject == roomStateBtns.InviteButton.gameObject then
        local msg = GetBBTZRuleString(roomData.setting).."房已开好,就等你来！"
        local title = roomInfo.roomNumber.."房,"..roomData.playName..roomData.setting.size.."缺"..(roomData.setting.size - logic:GetPlayerDataLength())
        PlatformManager.Instance:ShareLink('http://'..panelLogin.HttpUrl..'/shareRoom.html?appType=1&state=' ..proxy_pb.BBTZ..roomInfo.roomNumber, title, msg, 0);
    elseif go.gameObject == roomStateBtns.ExitButton.gameObject then
        logic:LeaveRoomIfNeedClose()
    elseif go.gameObject == roomStateBtns.BackButton.gameObject then
        PanelManager.Instance:HideAllWindow()
        if roomData.clubId == "0" then
            PanelManager.Instance:ShowWindow("panelLobby")
        else
            PanelManager.Instance:ShowWindow("panelClub", {name = gameObject.name})
        end
    end
end

function this.OnPressButtonSound(go, state)
    print('roomData.setting.sendVoiceAllowed : '..tostring(roomData.setting.sendVoiceAllowed))

    if  roomData.setting.sendVoiceAllowed then
        if state == true then
            logic:RequestRecord()
            recordTiShi.gameObject:SetActive(true)
        else
            local mousePositionY = UnityEngine.Input.mousePosition.y
            local buttonY = UnityEngine.Screen.height / 2 + (go.transform.localPosition.y * UnityEngine.Screen.height / 750)
            local buttonHeight = 3 * UnityEngine.Screen.height / 50
            logic:ResponseRecord(not (mousePositionY > buttonY + buttonHeight))
            recordTiShi.gameObject:SetActive(false)
        end
    else
       panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '群主已经禁止游戏过程中发送语音，如有疑问请联系群主')
       PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
    end


end