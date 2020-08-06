require("Class")
require("GameLogic")
require("BBTZ_Player")
require("CardGrid")
require("GameMode.BBTZ.ScoreCardPanel")
require("GameMode.BBTZ.IntegralPanel")
require("BBTZ.Bbtz_CardLogic")
require("BBTZ.BBTZ_Logic")
local bbtz_pb = require("bbtz_pb")
local proxy_pb = require("proxy_pb")

panelReplay_bbtz = {}
local this = panelReplay_bbtz

local message
local gameObject
local logic = nil
local c_MaxSize = 3
local curPlaySpeed = 2
local c_DefPlaySpeed = 2
local c_MaxPlaySpeed = 3.5
local c_MinPlaySpeed = 0.5
local c_DefPlayInterval = 0.5

local isPause = false
local autoPlayCor = nil

local prafebs = {}
local playerViews = {}
local roomInfoView = {}
local ReplayControl = {}
local PlayerOwnedGrids = {}
local lastOutCardSeat = 0
local RefreshScoreBoardEvent = nil;

local dismissTypeTip

function this.Awake(go)
    gameObject = go
    message = gameObject:GetComponent('LuaBehaviour')
    logic = GameLogic.New(this, bbtz_pb, 5, gameObject)

    prafebs.Card = gameObject.transform:Find("Prefabs/Card")
    prafebs.OutCard = gameObject.transform:Find("Prefabs/OutCard")
    prafebs.ScoreCard = gameObject.transform:Find("Prefabs/ScoreCard")
    prafebs.gameObject = gameObject.transform:Find("Prefabs").gameObject
    local gamers = gameObject.transform:Find("Gamers")
    for i = 1, c_MaxSize do
        local objectStr = "Player"..i
        local obj = gamers.transform:Find(objectStr)
        local outCardGrid = gameObject.transform:Find("GamerOutCards/OutCards"..i)
        local restCardGrid = gameObject.transform:Find("GamerRestCards/CardGrid"..i)
        local playerView = BBTZ_Player.New(obj.gameObject,gameObject);
        local outCardGrid = CardGrid.New(prafebs.OutCard, outCardGrid.gameObject, BBTZ_Logic.OnRefreshCard):InitCont(17)
        local restCardGrid = CardGrid.New(prafebs.OutCard, restCardGrid.gameObject, BBTZ_Logic.OnRefreshCard):InitCont(17)
        playerView:SetGameLogic(logic):SetWidhetObj(outCardGrid, restCardGrid,obj.gameObject,gameObject,i)
		
        table.insert(playerViews, playerView)
        table.insert(PlayerOwnedGrids, CardGrid.New(prafebs.Card, gameObject.transform:Find("PlayerOwnedGrids/CardGrid"..i).gameObject, BBTZ_Logic.OnRefreshCard))
    end

    logic.RefreshScoreBoard = event("RePlayRefreshScoreBoard", true);
    logic.RoundStart        = event("RePlayRoundStart",true);
    IntegralPanel.Init(gameObject.transform:Find("GamerScorings/"), logic);

    roomInfoView.RoomID = gameObject.transform:Find("Top/RoomID/Text")
    roomInfoView.RoomNum = gameObject.transform:Find("Top/RoundNum/Text")
    roomInfoView.setting = gameObject.transform:Find("PlayRule")
    roomInfoView.TotalScore = gameObject.transform:Find("TotalScore/Label")

    ReplayControl.ButtonBack = gameObject.transform:Find("ReplayControl/ButtonBack")
    ReplayControl.ButtonSlow = gameObject.transform:Find('ReplayControl/ButtonSlow')
	ReplayControl.SlowLabel = gameObject.transform:Find('ReplayControl/ButtonSlow/Label')
    ReplayControl.ButtonPause = gameObject.transform:Find('ReplayControl/ButtonPause');
    ReplayControl.ButtonFast = gameObject.transform:Find('ReplayControl/ButtonFast');
    ReplayControl.FastLabel = gameObject.transform:Find('ReplayControl/ButtonFast/Label')
    
    ScoreCardPanel.Init(gameObject.transform:Find("ScoreCardPanel"), prafebs.ScoreCard)

    message:AddClick(ReplayControl.ButtonSlow.gameObject, this.OnClickkButtonPlaySpeed);
    message:AddClick(ReplayControl.ButtonPause.gameObject, this.OnClickkButtonPlaySpeed);
    message:AddClick(ReplayControl.ButtonFast.gameObject, this.OnClickkButtonPlaySpeed);
    message:AddClick(ReplayControl.ButtonBack.gameObject, this.OnClickButtonBack);

    message:AddClick(gameObject.transform:Find("Top/Buttons/LookScoreBtn").gameObject, this.OnClickLookScoreBtn);
    
	dismissTypeTip = gameObject.transform:Find('dismissTypeTip/Tip/text')
	message:AddClick(gameObject.transform:Find('dismissTypeTip/Tip/dismissTypeTipBtn').gameObject, function (go)
		gameObject.transform:Find('dismissTypeTip/Tip').gameObject:SetActive(false)
		gameObject.transform:Find('dismissTypeTip/dismissTypeTipBtn').gameObject:SetActive(true)
	end)
	message:AddClick(gameObject.transform:Find('dismissTypeTip/dismissTypeTipBtn').gameObject, function (go)
		gameObject.transform:Find('dismissTypeTip/Tip').gameObject:SetActive(true)
		gameObject.transform:Find('dismissTypeTip/dismissTypeTipBtn').gameObject:SetActive(false)
	end)


end

local whoShow
function this.WhoShow(data)
	panelLogin.HideNetWaitting()
	whoShow = data
	if not data.isNeedRequest then
		return 
    end
    
    logic:Init();

	local msg = Message.New()
	local b = proxy_pb.PRoundRecords()
	b.roomId = replayData.roomId
	b.round = replayData.round
	b.gameType = proxy_pb.BBTZ
    msg.type = proxy_pb.ROUND_RECORDS
    msg.body = b:SerializeToString()
    print("请求战绩详情"..replayData.roomId, replayData.round)
    SendProxyMessage(msg, this.OnGetRoundDetail);
	PanelManager.Instance:HideWindow('panelRecordDetail')
	PanelManager.Instance:HideWindow('panelRecord')
	PanelManager.Instance:HideWindow('panelLobby')
    PanelManager.Instance:HideWindow('panelClub')
    
   

end

function this.OnApplicationFocus()

end

function this.Update()

end


 function this.OnClickLookScoreBtn(go)
    if ScoreCardPanel.IsActive() then
        ScoreCardPanel:Hide()
    else
        ScoreCardPanel:Show()
    end
end



    

function this.OnEnable()
    for i = 1, c_MaxSize do
        playerViews[i]:CleanView()
    end
    SetLabelText(ReplayControl.FastLabel, "")
    SetLabelText(ReplayControl.SlowLabel, "")
    AudioManager.Instance:PlayMusic('ZD_Bgm', true);
	gameObject.transform:Find('dismissTypeTip/Tip').gameObject:SetActive(false)
	gameObject.transform:Find('dismissTypeTip/dismissTypeTipBtn').gameObject:SetActive(true)
end

function this.Start()

end

function this.OnGetRoundDetail(msg)
    print('OnGetRoundDetail')
    RoundDetail = logic:GetMesaageData(bbtz_pb.RRoundRecords(), msg)
    print('RoundDetail.diss : '..RoundDetail.diss)
    dismissTypeTip:GetComponent("UILabel").text = RoundDetail.diss
    print("RoundDetail:", #RoundDetail.records, tostring(RoundDetail))
	print(' RoundDetail.openUserCard : '..tostring(RoundDetail.openUserCard)..' RoundDetail.isLord : '..tostring(RoundDetail.isLord))
	local roomData = {}
	roomData.setting = RoundDetail.setting
	for i = 1, #playerViews do
		playerViews[i]:SetGameRoomData(roomData)
		playerViews[i]:SetRoundDetail(RoundDetail)
	end
    this.SetTabelTotalScore(0)
    this.SetRoomInfoView(RoundDetail.roomNumber, "第"..replayData.round..'/'..RoundDetail.setting.rounds.."局", RoundDetail.setting)
    logic:AutoRegisterPlayerDatas(RoundDetail.players)
    this.AutoRegisterPlayerView(0, RoundDetail.setting.size)
    logic.RoundStart();

    for i = 1, #RoundDetail.players do
        local playerData = RoundDetail.players[i]
        local viewIndex = logic:GetPlayerViewIndexBySeat(playerData.seat)
        print(#playerData.cards)
        PlayerOwnedGrids[viewIndex]:RefreshCards(Bbtz_CardLogic.GetDeskHanCard(playerData.cards))
    end
    
    autoPlayCor = coroutine.start(this.AutoPlay)
end

function this.AutoRegisterPlayerView(mySeat, size)
    for i = 1, size do
        playerViews[i]:OpenView()
        PlayerOwnedGrids[i]:InitCont(17)
        logic:RegisterPlayerView(playerViews[i])
    end

    for i = size + 1, c_MaxSize do
        playerViews[i]:CloseView()
        PlayerOwnedGrids[i]:InitCont(17)
    end
    logic:SetMySeat(whoShow.isSelectSeat and whoShow.mySeat or mySeat, size)
    logic:ResetAllPlayerView()
    logic:ForeachPlayerDatas(function(playerView, playerData) 
        playerView:SetOffineFlag(false)
        playerView:SetMaster(playerData.isBlanker)
    end)
end

function this.SetRoomInfoView(roomId, roundNum, setting)
    SetLabelText(roomInfoView.RoomID, roomId)
    SetLabelText(roomInfoView.RoomNum, roundNum)
    SetLabelText(roomInfoView.setting, GetBBTZRuleString(setting))
end

function this.SetTabelTotalScore(num)
    SetLabelText(roomInfoView.TotalScore, num)
end

function this.AutoPlay()
    isPause = false
    curPlaySpeed = c_DefPlaySpeed
    local playIndex = 1
    while playIndex <= #RoundDetail.records do
        if not isPause then
            coroutine.wait(curPlaySpeed)
            
            this.OnPlayRecord(RoundDetail.records[playIndex])
            playIndex = playIndex + 1
			if RoundDetail.roundEnd and RoundDetail.roundEnd~=nil then 
				 if playIndex > #RoundDetail.records and #RoundDetail.roundEnd.players > 0 then
					coroutine.wait(0.5)
					RoundData.data = RoundDetail.roundEnd
					RoundData.mySeat = mySeat
					RoundData.playerData = {};
					for i=1, #RoundDetail.players do
					   RoundData.playerData[RoundDetail.players[i].seat] = RoundDetail.players[i]
					end
					RoundData.playerIcon = playerIcon
					RoundData.setting = RoundDetail.setting
					local roomData = {}
					roomData.round = replayData.round+1
					roomData.setting = RoundDetail.setting
					RoundData.roomData = roomData
					roomInfo.roomNumber = replayData.roomNumber
					RoundData.isInGame      = false
					PanelManager.Instance:ShowWindow("panelStageClear_bbtz")
					return
				end
			end
           
		else
			coroutine.wait(0.5)
        end
    end
end

function this.OnPlayRecord(record)
    print("OnPlayRecord.operate:"..record.operate);
    if record.operate == 0 then
        this.SetPlayerPlay(record.seat, record.seat, {})
    elseif record.operate == 1 then
        this.SetPlayerPlay(record.seat, record.seat, record.cards, record.category, record.roundOrder, record.deskScore)
    elseif record.operate == 2 then
      
        print("SetPlayerScoreAndTotalScore------------------>");
    elseif record.operate == 3 then
        logic:GetPlayerViewBySeat(record.seat):SetOptionFlag(bbtz_pb.OPTION_SHOOT, false)
    end
    this.SetPlayerScoreAndTotalScore(record);
    if record.operate ~= 2 then --如果等于2，那就是最后一步了，不用处理玩家状态
        this.SetPlayerState(record)
    end
    
    ScoreCardPanel.SetScoreCards(record.cardsBoard);
end

function this.SetPlayerPlay(activeSeat, lastSeat, lastCards, lastCategory, roundOrder, deskScore)
    logic:ForeachPlayerDatas(function(playerView,_) playerView:SetActiveFlag(false) end)
    logic:GetPlayerViewBySeat(activeSeat):SetActiveFlag(true)
    if lastCards ~= nil and #lastCards ~= 0 then
        --print("上一个玩家出牌座位："..lastSeat, #lastCards, lastCategory)
        if lastOutCardSeat == activeSeat then
            logic:ForeachPlayerDatas(function(playerView,_) 
                playerView:CleanOutCardAndEffect() 
            end)
        end
        lastOutCardSeat = activeSeat
        SetLabelText(roomInfoView.TotalScore, deskScore);
        logic:GetPlayerViewBySeat(lastSeat):SetOutCards({cards=lastCards,category= lastCategory},roundOrder, true);
        PlayerOwnedGrids[logic:GetPlayerViewIndexBySeat(lastSeat)]:RemoveCards(lastCards,
                function(cardA, cardB)
                    return cardA.value == cardB ;
                end,
                function(cards)
                    return Bbtz_CardLogic.GetDeskHanCard(Bbtz_CardLogic.CardInfoToGameCard(cards));
                end)
    else
        logic:GetPlayerViewBySeat(activeSeat):SetPass()
    end
end

function this.SetPlayerScoreAndTotalScore(record)
    SetLabelText(roomInfoView.TotalScore, record.deskScore)
    if record.refScore then 
        -- print("record.seat."..record.seat);
        -- print("record.serefSeatat."..record.refSeat);
        logic:GetPlayerViewBySeat(record.refSeat):UpdateScore(record.grabScore) 
        
    end
    logic.RefreshScoreBoard(record.scores)
end

function this.SetPlayerState(record)
    print("record.connected:"..tostring(record.connected));
    local playerView = logic:GetPlayerViewBySeat(record.seat)
    playerView:SetOffineFlag(not record.connected)
    playerView:SetTrusteeship(record.trusteeship)
end

function this.OnOnPlayRecordEnd()
    panelMessageBox.SetParamers(OK_CANCLE, this.OnClickButtonBack, nil, "当前牌局已结束，是否要离开？")
    PanelManager.Instance:ShowWindow("panelMessageBox")
end

function this.OnClickButtonBack(go)
    logic:RemoveAllPlayerData(true)
    for i = 1, #PlayerOwnedGrids do
        PlayerOwnedGrids[i]:Clean()
    end
    if autoPlayCor ~= nil then
        coroutine.stop(autoPlayCor)
        autoPlayCor = nil
    end
    PanelManager.Instance:ShowWindow(whoShow.name)
    PanelManager.Instance:HideWindow(gameObject.name)
    ScoreCardPanel:Hide();
    ScoreCardPanel.ClearData();
end

function this.OnClickkButtonPlaySpeed(go)
    local speed = 0
    local label = nil
    if go.gameObject == ReplayControl.ButtonFast.gameObject then
        speed = -c_DefPlayInterval
        label = ReplayControl.FastLabel
        SetLabelText(ReplayControl.SlowLabel, "")
        curPlaySpeed = curPlaySpeed > c_DefPlaySpeed and c_DefPlaySpeed or curPlaySpeed
    elseif go.gameObject == ReplayControl.ButtonSlow.gameObject then
        speed = c_DefPlayInterval
        label = ReplayControl.SlowLabel
        SetLabelText(ReplayControl.FastLabel, "")
        curPlaySpeed = curPlaySpeed < c_DefPlaySpeed and c_DefPlaySpeed or curPlaySpeed
    elseif go.gameObject == ReplayControl.ButtonPause.gameObject then
        isPause = not isPause
        ReplayControl.ButtonPause:GetComponent('UIButton').normalSprite = isPause and 'bofang' or "zanting"
        return
    end

    local newSpeed = curPlaySpeed + speed
    if newSpeed >= c_MinPlaySpeed and newSpeed <= c_MaxPlaySpeed then
        curPlaySpeed = newSpeed
        print("curPlaySpeed", curPlaySpeed)
        local num = math.abs(newSpeed - c_DefPlaySpeed) / 0.5
        SetLabelText(label, num > 0 and "x"..num or "")
    end
end

