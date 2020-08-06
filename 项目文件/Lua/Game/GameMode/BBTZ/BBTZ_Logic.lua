require("Class")
require("GPSTool")
require("GameLogic")
require("BBTZ_Player")
require("CardGrid")
require("FsmMachine")
require("ScoreCardPanel")
require("IntegralPanel")
require("BBTZ.Bbtz_CardLogic")
local json = require("json")
local bbtz_pb = require("bbtz_pb")

BBTZ_Logic = class(GameLogic)
local this = nil
local message = nil

local c_MaxSize = 3

local gameObject
local prafebs = {}
local GpsView = nil
local playerViews = {}

local distances 	= {};--相隔距离游戏对象
local gpsPlayers 	= {};
local gpsTool       = nil;

local lastCategory

local gameMachine = FsmMachine:New()
local gameMachineStateName = {
    Chui        = bbtz_pb.OPTION_HAMMER,--锤
    Gun         = bbtz_pb.OPTION_SHOOT,--枪
    Robbing     = bbtz_pb.OPTION_ROBBING,--抢
    Steep       = bbtz_pb.OPTION_STEEP,--徒陡
    HelpSteep   = bbtz_pb.OPTION_HELP_STEEP,--助陡
    Reverse     = bbtz_pb.OPTION_REVERSE,--反斗
}

local roomInfoView = {}
local gameStateBtns = {}
local noBigCardTip = nil

local selfCardGrid = nil
local AutoDissolutionState = {}
AutoDissolutionState.Coroutine = nil

local lasterOutCards = {}
local tipCanOutCardGroup = {}
local tipCanOutCardGroupIndex = 0

function BBTZ_Logic:ctor(gameView, game_pb, gameType, obj)
    this = self
    self:InitMachine()
    self.PlayerActive       = event("PlayerActive", true)
    self.PlayerOptionWait   = event("PlayerOptionWait", true)
    self.RefreshScoreBoard  = event("RefreshScoreBoard", true)
    self.bbtzPaiSize        = UnityEngine.PlayerPrefs.GetInt("bbtzPaiSize",1);

    gameObject = obj
    message = gameObject:GetComponent('LuaBehaviour')

    prafebs.Card = gameObject.transform:Find("Prefabs/Card")
    prafebs.OutCard = gameObject.transform:Find("Prefabs/OutCard")
    prafebs.ScoreCard = gameObject.transform:Find("Prefabs/ScoreCard")
    prafebs.gameObject = gameObject.transform:Find("Prefabs").gameObject

    local gamers = gameObject.transform:Find("Gamers")
    for i = 1, c_MaxSize do
        local objectStr     = "Player"..i
        local obj           = gamers.transform:Find(objectStr)
        local outCardGrid   = gameObject.transform:Find("GamerOutCards/OutCards"..i)
        local restCardGrid  = gameObject.transform:Find("GamerRestCards/CardGrid"..i)
        local playerView    = BBTZ_Player.New(obj.gameObject,gameObject);
        local outCardGrid   = CardGrid.New(prafebs.OutCard, outCardGrid.gameObject, BBTZ_Logic.OnRefreshCard):InitCont(17)
        local restCardGrid  = CardGrid.New(prafebs.OutCard, restCardGrid.gameObject, BBTZ_Logic.OnRefreshCard):InitCont(17)
        playerView:SetGameLogic(self):SetWidhetObj(outCardGrid, restCardGrid,obj.gameObject,gameObject,i);
		
        table.insert(playerViews, playerView)
    end
	
	for i = 1, #playerViews do
		local RoundDetail = {}
		RoundDetail.openUserCard = true
		RoundDetail.isLord = true
		playerViews[i]:SetRoundDetail(RoundDetail)
	end
    local lookScoreBtn = gameObject.transform:Find("Top/Buttons/LookScoreBtn")
    local ownedCards = gameObject.transform:Find("MySelfCardGrid")
    local cardRefreshBtn = gameObject.transform:Find("SelfCardRefreshBtn")
    selfCardGrid = CardGrid.New(prafebs.Card, ownedCards.gameObject, BBTZ_Logic.OnRefreshCard, self.OnSelectCards,
        self.OnReleaseSelectCards, self.OnVerifySelectedCards):InitCont(17)

    GpsView = gameObject.transform:Find("GPS")
    self:GetGPSUI();
    AutoDissolutionState.Tip = gameObject.transform:Find("AutoDissolutionTip")
    noBigCardTip = gameObject.transform:Find("NoBigCard")
    IntegralPanel.Init(gameObject.transform:Find("GamerScorings/"), self)
    ScoreCardPanel.Init(gameObject.transform:Find("ScoreCardPanel"), prafebs.ScoreCard)

    roomInfoView.RoomID = gameObject.transform:Find("Top/RoomID/Text")
    roomInfoView.RoomNum = gameObject.transform:Find("Top/RoundNum/Text")
    roomInfoView.TotalScore = gameObject.transform:Find("TotalScore/Label")

    local gameStateBtn = gameObject.transform:Find("GameStateBtns")
    gameStateBtns.PlayState = {}
    gameStateBtns.PlayState.gameObject = gameStateBtn.transform:Find("PlayState").gameObject
    gameStateBtns.PlayState.PlayButton = gameStateBtn.transform:Find("PlayState/ButtonPlay")
    gameStateBtns.PlayState.PassButton = gameStateBtn.transform:Find("PlayState/ButtonPass")
    gameStateBtns.PlayState.HelpButton = gameStateBtn.transform:Find("PlayState/ButtonHelp")
    gameStateBtns.ReadyState = {}
    gameStateBtns.ReadyState.gameObject = gameStateBtn.transform:Find("ReadyState").gameObject
    gameStateBtns.ReadyState.ReadyButton = gameStateBtn.transform:Find("ReadyState/ReadyButton")
    gameStateBtns.ChuiState = {}
    gameStateBtns.ChuiState.gameObject = gameStateBtn.transform:Find("PlayChuiState").gameObject
    gameStateBtns.ChuiState.ChuiButton = gameStateBtn.transform:Find("PlayChuiState/ButtonChui")
    gameStateBtns.ChuiState.NoChuiButton = gameStateBtn.transform:Find("PlayChuiState/ButtonNoChui")
    gameStateBtns.GunState = {}
    gameStateBtns.GunState.gameObject = gameStateBtn.transform:Find("PlayGunState").gameObject
    gameStateBtns.GunState.GunButton = gameStateBtn.transform:Find("PlayGunState/ButtonGun")
    gameStateBtns.GunState.SurrenderButton = gameStateBtn.transform:Find("PlayGunState/ButtonSurrender")
    gameStateBtns.RobbingState = {}
    gameStateBtns.RobbingState.gameObject = gameStateBtn.transform:Find("PlayRobbingState").gameObject
    gameStateBtns.RobbingState.RobbingButton = gameStateBtn.transform:Find("PlayRobbingState/ButtonRobbing")
    gameStateBtns.RobbingState.NoRobbingButton = gameStateBtn.transform:Find("PlayRobbingState/ButtonNoRobbing")
    gameStateBtns.SteepState = {}
    gameStateBtns.SteepState.gameObject = gameStateBtn.transform:Find("PlaySteepState").gameObject
    gameStateBtns.SteepState.SteepButton = gameStateBtn.transform:Find("PlaySteepState/ButtonSteep")
    gameStateBtns.SteepState.NoSteepButton = gameStateBtn.transform:Find("PlaySteepState/ButtonNoSteep")
    gameStateBtns.SteepState.HelpSteepButton = gameStateBtn.transform:Find("PlaySteepState/ButtonHelpSteep")
    gameStateBtns.SteepState.ReverseSteepButton = gameStateBtn.transform:Find("PlaySteepState/ButtonReverseSteep")

    message:AddClick(lookScoreBtn.gameObject, self.OnClickLookScoreBtn)
    message:AddClick(gameStateBtns.ReadyState.ReadyButton.gameObject, self.OnClickReadyBtn)
    message:AddClick(cardRefreshBtn.gameObject, function(go) selfCardGrid:Refresh() end)

    AddChildsClick(message, gameStateBtns.PlayState.gameObject.transform, self.OnClickPlay)
    AddChildsClick(message, gameStateBtns.ChuiState.gameObject.transform, self.OnClickChuiButtons)
    AddChildsClick(message, gameStateBtns.RobbingState.gameObject.transform, self.OnClickRobbingButtons)
    AddChildsClick(message, gameStateBtns.SteepState.gameObject.transform, self.OnClickSteepButtons)
    AddChildsClick(message, gameStateBtns.GunState.gameObject.transform, self.OnClickGunButtons)
end

function BBTZ_Logic:OnInitView(data)
    self:RemoveAllPlayerView(true)
    self:RemoveAllPlayerData(true)
    selfCardGrid:Hide()
    noBigCardTip.gameObject:SetActive(false)
    CloseChild(gameStateBtns.PlayState.gameObject.transform)
    CloseChild(gameStateBtns.ReadyState.gameObject.transform)
    CloseChild(gameStateBtns.ChuiState.gameObject.transform)
    CloseChild(gameStateBtns.GunState.gameObject.transform)
    CloseChild(gameStateBtns.RobbingState.gameObject.transform)
    CloseChild(gameStateBtns.SteepState.gameObject.transform)
    table.foreach(playerViews, function(_, playerView) playerView:CleanView() end)
    self:EnterGameServer(roomInfo.host, roomInfo.port)
end

--获得GPS游戏对象
function BBTZ_Logic:GetGPSUI()
    for i = 1, 6 do
        distances[i] = GpsView:Find("Distance/distance"..i);
    end

    for i = 1, 4 do
        gpsPlayers[i] = GpsView:Find("Players/Player"..i);
    end
end

function BBTZ_Logic:OnJoinRoom(data)
    --print("OnJoinRoom was called------------>");
    roomData        = data.room
    lasterOutCards  = data.room.latestHand;
    panelInGame.myseflDissolveTimes = 0
    print("roomData.state", roomData.state)
    self:CheckAutoDissolutionState()
    self:AutoRegisterPlayerView(data.seat, roomData.setting.size)

    panelInGame.fanHuiRoomNumber 	= roomInfo.roomNumber

    this:GetPlayerViewBySeat(data.room.latestSeat):SetOutCards(data.room.latestHand,nil,nil);
    SetLabelText(roomInfoView.RoomID, roomInfo.roomNumber)
    SetLabelText(roomInfoView.TotalScore, roomData.deskScore)
    SetLabelText(gameObject.transform:Find("PlayRule"), GetBBTZRuleString(roomData.setting, false))
    if roomData.dissolution.remainMs > 0 then
        roomData.dissolution.remainMs = math.modf(roomData.dissolution.remainMs/1000)
        self:SetDestroy()
    end


end

function BBTZ_Logic:AutoRegisterPlayerView(mySeat, size)
    for i = 1, size do
        playerViews[i]:OpenView()
        self:RegisterPlayerView(playerViews[i])
    end

    for i = size + 1, c_MaxSize do
        playerViews[i]:CloseView()
    end

    self:SetMySeat(mySeat, size)
    self:ResetAllPlayerView()
end

--开局倒计时自动解散的
function BBTZ_Logic:CheckAutoDissolutionState()
    if (not IsGameReadState(roomData) or roomData.clubId == "0") then
        AutoDissolutionState.Tip.gameObject:SetActive(false)
        return
    end

    local timer = function(timeLabel, time)
        while true do
            timeLabel:GetComponent("UILabel").text = os.date("%M:%S", time)
            coroutine.wait(1)
            time = time - 1
        end
    end

    if AutoDissolutionState.Coroutine ~= nil then
        coroutine.stop(AutoDissolutionState.Coroutine)
        AutoDissolutionState.Coroutine = nil
    end

    AutoDissolutionState.Tip.gameObject:SetActive(true)
    local timeLabel = AutoDissolutionState.Tip.transform:Find("Time")
    AutoDissolutionState.Coroutine = coroutine.start(timer, timeLabel, roomData.time / 1000)
end

function BBTZ_Logic:OnPlayerJoin(data)
    --print("-----------------OnPlayerJoin---------------")
    self:RefreshGpsView()
    self:ForeachPlayerDatas(function(playerView,_) playerView:SetGameRoomData(roomData) end);
    if data.seat == this.mySeat then
        this:RestoreGameScene()--重建
    end
end

function BBTZ_Logic:OnLeaveRoom()
    --print("-----------------OnLeaveRoom-----------------")
    panelLogin.HideGameNetWaitting();
    panelInGame.fanHuiRoomNumber = nil
	PanelManager.Instance:HideWindow('panelDestroyRoom');
    if roomData.clubId ~= '0' then
        PanelManager.Instance:ShowWindow('panelClub', {name = gameObject.name})
        panelMessageTip.SetParamers('返回俱乐部后，您的房间将会继续保留哦', 1)
    else
        PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
        panelMessageTip.SetParamers('返回大厅后，您的房间将会继续保留哦', 1)

    end
    roomData.clubId = '0'
end

function BBTZ_Logic:OnPlayerLeave(seat)
    print("座位号："..seat.."玩家，离开房间")
    self:RefreshGpsView();
end

function BBTZ_Logic:OnLordDissolve()
    panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '该房间已被群主或管理员解散')
	PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function BBTZ_Logic:OnAutoDissolve(data)
    DestroyRoomData.roomData = roomData;
    PanelManager.Instance:ShowWindow('panelAutoDissolve', data);
end

function BBTZ_Logic:OnRoomCannotDissolve()
    panelMessageBox.SetParamers(ONLY_OK,nil,nil,"房间设置为不能解散");
	PanelManager.Instance:ShowWindow("panelMessageBox");
end

function BBTZ_Logic:OnRoomDissolveLimit5()
    panelMessageBox.SetParamers(ONLY_OK,nil,nil,"每局解散最大申请次数不能超过5次");
	PanelManager.Instance:ShowWindow("panelMessageBox");
end

function BBTZ_Logic:OnPlayCategoryError()
    panelMessageBox.SetParamers(ONLY_OK,nil,nil,"牌型错误");
	PanelManager.Instance:ShowWindow("panelMessageBox");
end

function BBTZ_Logic:OnPlayOutOfCardsError()
    panelMessageBox.SetParamers(ONLY_OK,nil,nil,"出牌错误");
	PanelManager.Instance:ShowWindow("panelMessageBox");
end

function BBTZ_Logic:OnPlayCompareError()
    panelMessageBox.SetParamers(ONLY_OK,nil,nil,"小于上家牌型");
	PanelManager.Instance:ShowWindow("panelMessageBox");
end


function BBTZ_Logic:OnPlayerDisconnected(seat) 
    print("座位号："..seat.."玩家，断开连接") 
end

--玩家准备
function BBTZ_Logic:OnPlayerReady(seat)
    print("-----------------OnReady-----------------")
    -- if IsGameRoundEnd(roomData) then --可能我刚从小结算出来
    --     this:ResetGameState()
    -- end
    roomData.state = bbtz_pb.READY
    this:GetPlayerDataBySeat(seat).ready = true
    print("myseat:"..self.mySeat.."|ready seat:"..seat);
    if seat == self.mySeat then
        CloseChild(gameStateBtns.ReadyState.gameObject.transform)
    end
end

function BBTZ_Logic:OnGameRoundStart(data)
    print("-----------------OnGameRoundStart-----------------")
    if panelInGame.needXiPai==true then
        panelInGame.needXiPai=false
        self.connect.IsZanTing=true
        PanelManager.Instance:ShowWindow('panelXiPai_poker',function()
            self.connect.IsZanTing=false
            roomData.state = bbtz_pb.OPTION
            this:RestoreGameScene()--重建
            self:CheckAutoDissolutionState();
        end)
    else
        roomData.state = bbtz_pb.OPTION
        this:RestoreGameScene()--重建
        self:CheckAutoDissolutionState();	
    end
   
end

function BBTZ_Logic:OnGameRoundEnd(data)
    print("-----------------OnGameRoundEnd-----------------")
    this:SetRoundEnd(data, true,true)
    ScoreCardPanel.Hide();
    ScoreCardPanel.ClearData();
end

function BBTZ_Logic:OnGameRoundOver(data)
    print("-----------------OnGameRoundOver-----------------")
    this:SetRoundOver(data)
    ScoreCardPanel.Hide();
    ScoreCardPanel.ClearData();
end

function BBTZ_Logic:OnGameDestroy(data)
    print('OnGameDestroy')
    self.super.OnGameDestroy(self, data)
    panelInGame.fanHuiRoomNumber = nil
    PanelManager.Instance:HideWindow("panelDestroyRoom")
    if roomData.state == bbtz_pb.BIGOVER then
        return;
    end
    if roomData.clubId ~= '0' then
        PanelManager.Instance:ShowWindow('panelClub', {name = 'panelInGame_bbtz'});
    else
        PanelManager.Instance:ShowWindow('panelLobby',gameObject.name);
    end
end

function BBTZ_Logic.OnDissolve(msg)
    local body = this:GetMesaageData(bbtz_pb.RDissolve(), msg)
    if body.decision == bbtz_pb.APPLY then
		roomData.dissolution.applicant = body.seat;
		while #roomData.dissolution.acceptors > 0 do
			table.remove(roomData.dissolution.acceptors, #roomData.dissolution.acceptors)
		end
        roomData.dissolution.remainMs = body.remainMs/1000
        this:SetDestroy()
	elseif body.decision == bbtz_pb.AGREE then
		table.insert(DestroyRoomData.roomData.dissolution.acceptors, body.seat)
		panelDestroyRoom.Refresh()
	elseif body.decision == bbtz_pb.AGAINST then
		table.insert(DestroyRoomData.roomData.dissolution.rejects, body.seat)
		panelDestroyRoom.Refresh(body.seat)
    end
end

function BBTZ_Logic.OnRefreshMaster(msg)
    local data = this:GetMesaageData(bbtz_pb.RSeat(), msg)

    --先隐藏之前的所有庄家
    this:ForeachPlayerDatas(function(playerView,_) playerView:SetMaster(false) end);
    roomData.banker = data.seat;
    --再设置新的庄家
    this:GetPlayerViewBySeat(data.seat):SetMaster(true)
end

function BBTZ_Logic.OnPlayerOption(msg)
    local data = this:GetMesaageData(bbtz_pb.RPlayOption(), msg)
    print("OnPlayerOption", data.seat, data.option, tostring(data.confim))
    if data.seat == this.mySeat then
        this.PlayerActive(false, 0)
        gameMachine:Switch(data.option, false)
    end
    if data.option == bbtz_pb.OPTION_HELP_STEEP then
        CloseChild(gameStateBtns.SteepState.gameObject.transform)
    end
    this:GetPlayerViewBySeat(data.seat):SetOptionFlag(data.option, data.confim)
end

function BBTZ_Logic.OnPlayerOptionWait(msg)
    local data = this:GetMesaageData(bbtz_pb.RPlayOptionWait(), msg)
    if this.mySeat ~= data.seat then
        return
    end
   this:SetPlayerOptionMachine(data.option)
end

function BBTZ_Logic:SetPlayerOptionMachine(option)
    print("SetPlayerOptionMachine", option)
    if option == bbtz_pb.OPTION_EMPTY then return end
    self.PlayerActive(true, roomData.setting.trusteeship)
    self.PlayerOptionWait()
    gameMachine:Switch(option, true)
    this:GetPlayerDataBySeat(this.mySeat).option = option
end

function BBTZ_Logic.OnPlayWiat(msg)
    local data = this:GetMesaageData(bbtz_pb.RSeat(), msg)
    roomData.state = bbtz_pb.GAMING
    this:GetPlayerDataBySeat(this.mySeat).option = bbtz_pb.OPTION_EMPTY
    this:SetActiveSeat(data.seat, bbtz_pb.PLAY_STATUS, true)
end

function BBTZ_Logic.OnPlayerOutCard(msg)
    local data = this:GetMesaageData(bbtz_pb.RPlay(), msg)
    SetLabelText(roomInfoView.TotalScore, data.deskScore)
    this:SetPlayerPlay(data.forward, data.state, data.seat, data.latestHand, data.roundOrder, true)
    lastCategory = data.latestHand.category;
    --更新积分板
    if data.state == bbtz_pb.PLAY_STATUS then
        ScoreCardPanel.Refresh();
    end
end

function BBTZ_Logic.OnPlayPass(msg)
    local data = this:GetMesaageData(bbtz_pb.RPass(), msg)
    this:SetPlayerPlay(data.forward, data.state, data.seat, nil, nil, true)
    if lastCategory ==  Card.Category.TIANZHA then
        CloseChild(gameStateBtns.PlayState.gameObject.transform);
    end
    --更新积分板
    if data.state == bbtz_pb.PLAY_STATUS then
        ScoreCardPanel.Refresh();
    end
	local connect = NetWorkManager.Instance:FindConnet('game')
	DelayMsgDispatch(connect, 0.5)
end

function BBTZ_Logic.OnRefreshScoreBoard(msg)
    -- print("更新积分板")
    local data = this:GetMesaageData(bbtz_pb.RRefScoreBoard(), msg)
    SetLabelText(roomInfoView.TotalScore, 0)
    this.RefreshScoreBoard(data.scores)
    if data.refGrab then this:GetPlayerViewBySeat(data.seat):UpdateScore(data.roundGrab) end
end

------------------------牌面更新--------------------
function BBTZ_Logic.OnRefreshCard(i, cardObj, info)
    local cardBody = cardObj.transform:Find("Body")
    local colorBox = cardBody.transform:Find("ColorBox")
    SetCardDepth(cardBody, i * 3)
    local bbtzPaiSize = UnityEngine.PlayerPrefs.GetInt("bbtzPaiSize",1);
    SetCardKeyColor(cardBody, info,bbtzPaiSize);
    --设置牌面

    cardBody.localPosition = Vector3.zero
    if colorBox == nil then return end
    CloseChild(colorBox)
    if info.SpecialType ~= SpecialType.None then
        colorBox:Find(info.SpecialType).gameObject:SetActive(true)
    end
end

function BBTZ_Logic.OnVerifySelectedCards(cardObj, info)
    --print("OnVerifySelectedCards was called");
    return cardObj.transform:Find("Body").localPosition.y ~= 0
end

function BBTZ_Logic.OnSelectCards(cardObj, info, reset)
    --print("OnSelectCards was called");

    local pos = cardObj.transform:Find("Body").localPosition
    if pos.y ~= 0 or reset then
        cardObj.transform:Find("Body").localPosition = Vector3.zero
    else
        cardObj.transform:Find("Body").localPosition = Vector3(pos.x, pos.y + 50, pos.z)
    end
end

function BBTZ_Logic.OnReleaseSelectCards(selectCards)
    print("OnReleaseSelectCards was called");
    --AudioManager.Instance:PlayAudio('touchcard');
    if not this:CheckCanOut(roomData.activeSeat) then return end
    local canOut = Bbtz_CardLogic.CheckCompliance(selectCards, lasterOutCards.cards, lasterOutCards.category,lasterOutCards.keyCardCount)
    SetBoxTouch(gameStateBtns.PlayState.PlayButton, canOut)
end
------------------------牌面更新--------------------

function BBTZ_Logic:InitMachine()
    --锤
    gameMachine:Add(gameMachineStateName.Chui, function(isOption)
        SetChildActive(gameStateBtns.ChuiState.gameObject.transform, isOption)
    end)
    --开枪
    gameMachine:Add(gameMachineStateName.Gun, function(isOption)
        SetChildActive(gameStateBtns.GunState.gameObject.transform, isOption)
    end)
    --抢
    gameMachine:Add(gameMachineStateName.Robbing, function(isOption)
        SetChildActive(gameStateBtns.RobbingState.gameObject.transform, isOption)
    end)
    --陡
    gameMachine:Add(gameMachineStateName.Steep, function(isOption)
        SetChildActive(gameStateBtns.SteepState.gameObject.transform, isOption)
        gameStateBtns.SteepState.HelpSteepButton.gameObject:SetActive(false)
        gameStateBtns.SteepState.ReverseSteepButton.gameObject:SetActive(false)
        gameStateBtns.SteepState.gameObject:GetComponent("UIGrid"):Reposition()
    end)
    gameMachine:Add(gameMachineStateName.HelpSteep, function(isOption)
        SetChildActive(gameStateBtns.SteepState.gameObject.transform, isOption)
        gameStateBtns.SteepState.SteepButton.gameObject:SetActive(false)
        gameStateBtns.SteepState.ReverseSteepButton.gameObject:SetActive(false)
        gameStateBtns.SteepState.gameObject:GetComponent("UIGrid"):Reposition()
    end)
    gameMachine:Add(gameMachineStateName.Reverse, function(isOption)
        SetChildActive(gameStateBtns.SteepState.gameObject.transform, isOption)
        gameStateBtns.SteepState.HelpSteepButton.gameObject:SetActive(false)
        gameStateBtns.SteepState.SteepButton.gameObject:SetActive(false)
        gameStateBtns.SteepState.gameObject:GetComponent("UIGrid"):Reposition()
    end)
end

function BBTZ_Logic:RefreshGpsView(close)
    if roomData.setting.size == 2 or close == true or roomData.state ~= bbtz_pb.READYING then
        GpsView.gameObject:SetActive(false)
        return;
    end
    GpsView.gameObject:SetActive(true);
    if gpsTool == nil then
        gpsTool = GPSTool.New(self,roomData,distances,gpsPlayers);
    end
    gpsTool:Refresh(self,roomData);
end


function BBTZ_Logic:RestoreGameScene()
    SetLabelText(roomInfoView.RoomNum, roomData.round.."/"..roomData.setting.rounds)
    -- print("self.mySeat:"..self.mySeat);
    local playerData = self:GetPlayerDataBySeat(self.mySeat)
    -- print("playerData.name:"..playerData.name);
    -- print("playerData.cards is nil:"..tostring(playerData.cards== nil))
    -- print("1 playerData.cards.length:"..(#playerData.cards));
    if roomData.state == bbtz_pb.READYING then
        SetChildActive(gameStateBtns.ReadyState.gameObject.transform, not playerData.ready)
        return
    end
    self:RefreshGpsView(true) --不在准备就隐藏gps
    self:ResetRoundStartState()
    self:UpdatePlayerRestCardNum()
    CloseChild(gameStateBtns.ReadyState.gameObject.transform)
    -- print("2 playerData.cards.length:"..(#playerData.cards));
    selfCardGrid:RefreshCards(Bbtz_CardLogic.GetDeskHanCard(playerData.cards))
    -- print("3 playerData.cards.length:"..(#playerData.cards));

    self:SetPlayerOptionMachine(self:GetPlayerDataBySeat(this.mySeat).option)

    if IsGameRoundEnd(roomData) and #roomData["end"].players ~= 0 then
        self:SetRoundEnd(roomData["end"],false,false)
    elseif roomData.state == bbtz_pb.GAMING then
        lasterOutCards = roomData.latestHand
        self:SetActiveSeat(roomData.activeSeat, roomData.status, false, roomData.trusteeshipRemainMs)
        self:GetPlayerViewBySeat(roomData.latestSeat):SetOutCards(lasterOutCards, nil, false)
    end
end

function BBTZ_Logic:TipOutCard()
    if #tipCanOutCardGroup == 0 then
        tipCanOutCardGroupIndex = 0
        tipCanOutCardGroup = Bbtz_CardLogic.FindCanOutCards(selfCardGrid:GetCards(), lasterOutCards)
        if #tipCanOutCardGroup == 0 then return end
        print("可以出的牌"..json:encode(tipCanOutCardGroup))
    end

    selfCardGrid:SetSelectedCards(tipCanOutCardGroup[tipCanOutCardGroupIndex + 1], Bbtz_CardLogic.CardEqual)
    tipCanOutCardGroupIndex = (tipCanOutCardGroupIndex + 1) % #tipCanOutCardGroup
end

function BBTZ_Logic:CleanTipOutCard()
    tipCanOutCardGroup = {}
end

function BBTZ_Logic:SetActiveSeat(activeSeat, activeState, needWait, trusteeshipRemainMs)
    roomData.activeSeat = activeSeat
    roomData.status = activeState
    if self.clearEffectCoroutine~=nil then
        coroutine.stop(self.clearEffectCoroutine);
    end
    self.clearEffectCoroutine = coroutine.start(function()
        this:ForeachPlayerDatas(function(playerView,_) playerView:SetActiveFlag(false) end);
        this:GetPlayerViewBySeat(activeSeat):SetActiveFlag(true);
        if activeState == bbtz_pb.PLAY_STATUS then
            coroutine.wait(needWait and 1 or 0)
            for i = 1, #self.playerViews do
                self.playerViews[i]:CleanOutCardAndEffect()
            end
        end
        local isCanOption = self:CheckCanOut(roomData.activeSeat)
        self.PlayerActive(isCanOption, trusteeshipRemainMs == nil and roomData.setting.trusteeship or trusteeshipRemainMs)
        if isCanOption then
            self:CleanTipOutCard();
            lasterOutCards = activeState == bbtz_pb.PLAY_STATUS and {} or lasterOutCards;
            OpenChild(gameStateBtns.PlayState.gameObject.transform);
            noBigCardTip.gameObject:SetActive(activeState == bbtz_pb.PASS_STATUSS and lastCategory ~= Card.Category.TIANZHA)
            --print("activeState:"..activeState.."|bbtz_pb.PASS_STATUSS:"..bbtz_pb.PASS_STATUSS);
            gameStateBtns.PlayState.PassButton.gameObject:SetActive(activeState ~= bbtz_pb.PLAY_STATUS)
            gameStateBtns.PlayState.PlayButton.gameObject:SetActive(activeState ~= bbtz_pb.PASS_STATUSS)
            SetBoxTouch(gameStateBtns.PlayState.HelpButton, activeState ~= bbtz_pb.PASS_STATUSS and activeState ~= bbtz_pb.PLAY_STATUS)
            SetBoxTouch(gameStateBtns.PlayState.PlayButton, Bbtz_CardLogic.CheckCompliance(selfCardGrid:GetSelecedCards(), lasterOutCards.cards, lasterOutCards.category));

            gameStateBtns.PlayState.gameObject:GetComponent("UIGrid"):Reposition();
        else
            noBigCardTip.gameObject:SetActive(false)
            CloseChild(gameStateBtns.PlayState.gameObject.transform)
        end
    end)
end

--检测能否出牌
function BBTZ_Logic:CheckCanOut(activeSeat)
    if activeSeat ~= self.mySeat or this:GetPlayerDataBySeat(self.mySeat).option ~= bbtz_pb.OPTION_EMPTY then
        return false
    end
    return roomData.status ~= bbtz_pb.OVER_STATUS--roomData.status == bbtz_pb.FOLLOW_STATUS or roomData.status == bbtz_pb.PLAY_STATUS
end

function BBTZ_Logic:SetPlayerPlay(forward, forwardState, latestOptionSeat, lastHand, roundOrder, needEffect)
    --print("SetPlayerPlay was called-----------------");
    if lastHand ~= nil and #lastHand.cards ~= 0 then
        print("玩家出牌座位："..latestOptionSeat, #lastHand.cards, lastHand.category, roundOrder)
        print("forward:"..forward.."|latestOptionSeat:"..latestOptionSeat.."|mySeat:"..self.mySeat);
        local laster = this:GetPlayerDataBySeat(latestOptionSeat)
        if latestOptionSeat == this.mySeat then
            local mycards = this:GetPlayerDataBySeat(this.mySeat).cards;
            RemoveCard(mycards, lastHand.cards);
            selfCardGrid:RefreshCards(Bbtz_CardLogic.GetDeskHanCard(mycards));
        else--不是自己的时候，天炸不要显示操作按钮
          
        end

        if lastHand.category == Card.Category.TIANZHA then
            CloseChild(gameStateBtns.PlayState.gameObject.transform);
        end
        lasterOutCards = lastHand
        roomData.latestSeat = latestOptionSeat
        laster.len = laster.len - #lastHand.cards
        self:UpdatePlayerRestCardNum(latestOptionSeat, laster.len);
        --print("laster.len:"..laster.len);
        this:GetPlayerViewBySeat(latestOptionSeat - 1):CleanOutCardAndEffect()
        this:GetPlayerViewBySeat(latestOptionSeat):SetOutCards(lastHand, roundOrder, needEffect)
    else
        this:GetPlayerViewBySeat(latestOptionSeat):SetPass()
    end
    if not this:CheckRoundEnd(forwardState)  then--如果游戏还在继续，那么设置下一个出牌玩家
        if lastHand == nil or lastHand.category ~= Card.Category.TIANZHA then
            -- print("SetActiveSeat---------------------------------------------------->")
            this:SetActiveSeat(forward, forwardState, false);
        end
    else--如果游戏结束，那么隐藏所有操作按钮
        CloseChild(gameStateBtns.PlayState.gameObject.transform)
    end
	local connect = NetWorkManager.Instance:FindConnet('game')
	DelayMsgDispatch(connect, 0.5)
end

function BBTZ_Logic:UpdatePlayerRestCardNum(seat, num)
    --print("UpdatePlayerRestCardNum was called,seat:"..tostring(seat).."|num:"..tostring(num));
    if seat ~= nil then
        self:GetPlayerViewBySeat(seat):SetRestCardNum(num)
        if self:GetPlayerDataBySeat(seat).len == 1 then
            self:GetPlayerViewBySeat(seat):ShowWarnningText(self.mySeat);
        end
    else
        local playerDatas = self:GetPlayerDatas()
        for key, value in pairs(playerDatas) do
            local playerView = self:GetPlayerViewBySeat(value.seat);
            playerView:SetRestCardNum(value.len);
        end
    end
end

function BBTZ_Logic:SendSelectCards(selectedCards)
    local body = bbtz_pb.PPlay()
    tableAdd(body.cards, Bbtz_CardLogic.CardInfoToGameCard(selectedCards))
    this:SendGameMsg(bbtz_pb.PLAY, body:SerializeToString())
    selfCardGrid:RemoveCards(selectedCards, nil, function(cards)
        return Bbtz_CardLogic.GetDeskHanCard(Bbtz_CardLogic.CardInfoToGameCard(cards))
    end, true)
end

function BBTZ_Logic:CheckRoundEnd(state)
    return state == bbtz_pb.OVER_STATUS
end

function BBTZ_Logic:ResetRoundStartState()
    self:ForeachPlayerDatas(function(playerView,_) playerView:ResetRoundStartState() end);
    PanelManager.Instance:HideWindow("panelStageClear_bbtz");
end

function BBTZ_Logic:ResetGameState()
    selfCardGrid:Hide()
    noBigCardTip.gameObject:SetActive(false)
    CloseChild(gameStateBtns.PlayState.gameObject.transform)
    self:ForeachPlayerDatas(function(playerView,_) playerView:ResetGameState() end)
end

--needAdd 断线重连进来，如果有小结算状态，就不用加了，正常流程才需要加
function BBTZ_Logic:SetRoundEnd(data, needShowRestCards,needAdd)
    RoundData.data          = data
    RoundData.mySeat        = this.mySeat
    RoundData.playerData   = this:GetPlayerDatas()
    roomData.round          = needAdd and roomData.round + 1 or roomData.round;
    RoundData.roomData      = roomData
    roomData.state          = bbtz_pb.GAMEOVER
    RoundData.isInGame      = true
    RoundData.isBack = not needAdd
    coroutine.start(function()
		local connect = NetWorkManager.Instance:FindConnet('game')
		connect.IsZanTing=true
        if not needShowRestCards then
            table.foreachi(data.players, function(_, playerEnd)
                self:GetPlayerViewBySeat(playerEnd.seat):SetRestCards(playerEnd.cards)
            end)
            if needAdd then --如果是断线重连进来的，就不要等待了，直接显示小结算
                coroutine.wait(2)
            end

        end
        if needAdd then --如果是断线重连进来的，就不要等待了，直接显示小结算
            coroutine.wait(1)
        end
		
        PanelManager.Instance:ShowWindow("panelStageClear_bbtz",function()
            connect.IsZanTing=false
        end)
        PanelManager.Instance:HideWindow("panelChat");
        PanelManager.Instance:HideWindow("panelGameSetting_bbtz");
        self:ResetGameState()
        selfCardGrid:Hide()
    end)
end

function BBTZ_Logic:SetRoundOver(data)
    RoundAllData.data = data
    RoundAllData.mySeat = this.mySeat
    RoundAllData.playerDatas = this:GetPlayerDatas()
    local trusteeshipData = {};
    --从本地获取托管数据
    for k,v in pairs(RoundAllData.playerDatas) do
        if not trusteeshipData[v.seat] then
            trusteeshipData[v.seat] = this:GetPlayerViewBySeat(v.seat).trusteeshipFlag.gameObject.activeSelf;
        end
    end
    RoundAllData.trusteeshipData = trusteeshipData;
    -- print("trusteeshipData:"..json:encode(trusteeshipData));
    RoundAllData.roomData = roomData;
    roomData.state = bbtz_pb.BIGOVER
    if data.complete then
        return
    end
    PanelManager.Instance:ShowWindow("panelStageClearAll_bbtz")
    PanelManager.Instance:HideWindow("panelChat");
    PanelManager.Instance:HideWindow("panelGameSetting_bbtz");
end

function BBTZ_Logic:SetDestroy()
    print("SetDestroy wa calld")
    DestroyRoomData = {}
    DestroyRoomData.roomData 	= roomData
    DestroyRoomData.playerData 	= self.playerDatas
    DestroyRoomData.mySeat 		= self.mySeat
    PanelManager.Instance:HideWindow('panelDestroyRoom');
    PanelManager.Instance:ShowWindow("panelDestroyRoom");
    PanelManager.Instance:HideWindow("panelChat");
    PanelManager.Instance:HideWindow("panelGameSetting_bbtz");
    if panelStageClear_bbtz then
		panelStageClear_bbtz.setButtonsStatus(true)
	end
end

do ------------------------按钮回调--------------------
    function BBTZ_Logic.OnClickLookScoreBtn(go)
        if ScoreCardPanel.IsActive() then
            ScoreCardPanel:Hide()
        else
            ScoreCardPanel:Show()
        end
    end

    function BBTZ_Logic.OnClickReadyBtn(go)
        AudioManager.Instance:PlayAudio('btn')
        this:SendGameMsg(bbtz_pb.READY, nil)
        gameStateBtns.ReadyState.ReadyButton.gameObject:SetActive(false)
    end

    function BBTZ_Logic.OnClickChuiButtons(go)
        AudioManager.Instance:PlayAudio('btn')
        local body = bbtz_pb.PPlayOption()
        body.option = bbtz_pb.OPTION_HAMMER
        body.confim = go.gameObject == gameStateBtns.ChuiState.ChuiButton.gameObject
        print("OnClickGuiButtons", tostring(body.confim))
        CloseChild(gameStateBtns.ChuiState.gameObject.transform)
        this:SendGameMsg(bbtz_pb.PLAY_OPTION, body:SerializeToString())
    end

    function BBTZ_Logic.OnClickGunButtons(go)
        AudioManager.Instance:PlayAudio('btn')
        local body = bbtz_pb.PPlayOption()
        body.option = bbtz_pb.OPTION_SHOOT
        body.confim = go.gameObject == gameStateBtns.GunState.GunButton.gameObject
        print("OnClickGunButtons", tostring(body.confim))
        CloseChild(gameStateBtns.GunState.gameObject.transform)
        this:SendGameMsg(bbtz_pb.PLAY_OPTION, body:SerializeToString())
    end

    function BBTZ_Logic.OnClickRobbingButtons(go)
        AudioManager.Instance:PlayAudio('btn')
        local body = bbtz_pb.PPlayOption()
        body.option = bbtz_pb.OPTION_ROBBING
        body.confim = go.gameObject == gameStateBtns.RobbingState.RobbingButton.gameObject
        print("OnClickRobbingButtons", tostring(body.confim))
        CloseChild(gameStateBtns.RobbingState.gameObject.transform)
        this:SendGameMsg(bbtz_pb.PLAY_OPTION, body:SerializeToString())
    end

    function BBTZ_Logic.OnClickSteepButtons(go)
        AudioManager.Instance:PlayAudio('btn')
        local option = this:GetPlayerDataBySeat(this.mySeat).option
        local body = bbtz_pb.PPlayOption()
        body.option = option
        body.confim = go.gameObject ~= gameStateBtns.SteepState.NoSteepButton.gameObject
        print("OnClickSteepButtons", option, tostring(body.confim))
        CloseChild(gameStateBtns.SteepState.gameObject.transform)
        this:SendGameMsg(bbtz_pb.PLAY_OPTION, body:SerializeToString())
    end

    function BBTZ_Logic.OnClickPlay(go)
        --print("OnClickPlay.."..nil);
        AudioManager.Instance:PlayAudio('btn')
        if go.gameObject == gameStateBtns.PlayState.PassButton.gameObject then
            this:SendGameMsg(bbtz_pb.PASS, nil);
        elseif go.gameObject == gameStateBtns.PlayState.HelpButton.gameObject then
            this:TipOutCard()
            return
        elseif go.gameObject == gameStateBtns.PlayState.PlayButton.gameObject then
            local selectedCards = selfCardGrid:GetSelecedCards()
            if Bbtz_CardLogic.CheckSplitSpecialCards(nil, selectedCards) then
                this:SendSelectCards(selectedCards)
            else
                panelMessageBox.SetParamers(OK_CANCLE, function() this:SendSelectCards(selectedCards)
                    CloseChild(gameStateBtns.PlayState.gameObject.transform) end, nil,"要出的牌将会拆除炸弹，是否确认出牌？")
                PanelManager.Instance:ShowWindow("panelMessageBox")
                return
            end
        end
        CloseChild(gameStateBtns.PlayState.gameObject.transform)
    end
end

function BBTZ_Logic:RegisterGameCallBack()
    RegisterGameCallBack(bbtz_pb.PLAY_OPTION,           self.OnPlayerOption)
    RegisterGameCallBack(bbtz_pb.PLAY_OPTION_WAIT,      self.OnPlayerOptionWait)
    RegisterGameCallBack(bbtz_pb.PLAY_WIAT,             self.OnPlayWiat)
    RegisterGameCallBack(bbtz_pb.PLAY,                  self.OnPlayerOutCard)
    RegisterGameCallBack(bbtz_pb.PASS,                  self.OnPlayPass)
    RegisterGameCallBack(bbtz_pb.REFRESH_SCOREBOARD,    self.OnRefreshScoreBoard)
    RegisterGameCallBack(bbtz_pb.PLAY_REFRESH_BANKER,   self.OnRefreshMaster)
    RegisterGameCallBack(bbtz_pb.DISSOLVE,              self.OnDissolve)
end

function BBTZ_Logic:OnRoomError()
    panelMessageTip.SetParamers('加入房间错误', 2)
    PanelManager.Instance:ShowWindow('panelMessageTip')
    coroutine.start(
    function()
		coroutine.wait(2)
		panelLogin.HideGameNetWaitting();
        if roomData.clubId ~= '0' then
            local data = {}
            data.name = 'panelInGame_bbtz'
            PanelManager.Instance:ShowWindow('panelClub', data)
        else
            PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
		end
		roomData.clubId = '0'
		this:OnGameDestroy()
    end
    )
end

function BBTZ_Logic:OnRoomDissolveIn5Seconds()
	panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '规定时间内房间未开始已自动解散')
	PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function BBTZ_Logic:OnRoomNoExist()
    panelMessageTip.SetParamers('房间已解散', 2)
    PanelManager.Instance:ShowWindow('panelMessageTip')
    coroutine.start(
        function()
            coroutine.wait(2)
            panelLogin.HideGameNetWaitting();
            if roomData.clubId ~= '0' then
                local data = {}
                data.name = 'panelInGame_bbtz'
                PanelManager.Instance:ShowWindow('panelClub', data)
            else
                PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
            end
            roomData.clubId = '0'
            this:OnGameDestroy()
        end
        )
end

function BBTZ_Logic:ChangePaiSize(bbtzPaiSize)
    self.bbtzPaiSize = bbtzPaiSize;
    if selfCardGrid then
        local mycards = this:GetPlayerDataBySeat(this.mySeat).cards;
        selfCardGrid:RefreshCards(Bbtz_CardLogic.GetDeskHanCard(mycards));
        self:GetPlayerViewBySeat(roomData.latestSeat):SetOutCards(lasterOutCards, nil, false)
    end
end

function IsGameReadState(roomData)
    return roomData.round == 1 and roomData.state == 1
end

function IsGameRoundEnd(roomData)
    return roomData.state == bbtz_pb.GAMEOVER
end

function IsGaming(logic, roomData)
    return logic:IsAllReaded() or not IsGameReadState(roomData) or roomData.round > 1
end
