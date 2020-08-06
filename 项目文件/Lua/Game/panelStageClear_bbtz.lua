require("BBTZ.HandCard")
require("BBTZ.BBTZ_Tools")

local bbtz_pd = require("bbtz_pb")

panelStageClear_bbtz = {}
local this = panelStageClear_bbtz

local gameObject = nil
local message = nil

local Prefab = {}
local playerViews = {}

local ButtonOK = nil
local ButtonShare = nil
local ButtonXiPai = nil
local DarkCards = nil

function this.Start()

end

function this.OnApplicationFocus()

end

function this.Awake(go)
    gameObject = go
    message = gameObject:GetComponent('LuaBehaviour')
    Prefab.Card = gameObject.transform:Find("Prefabs/Card")
    Prefab.CardGroup = gameObject.transform:Find("Prefabs/CardGroup")
    ButtonShare = gameObject.transform:Find("Buttons/ButtonShare");
    
    local gamers = gameObject.transform:Find("Gamers")
    for i = 1, 3 do
        local playerView = {}
        local objectStr = "Player"..i
        playerView.Info = {}
        playerView.Info.ID = gamers.transform:Find(objectStr.."/Info/ID")
        playerView.Info.Name = gamers.transform:Find(objectStr.."/Info/Name")
        playerView.Info.Iamge = gamers.transform:Find(objectStr.."/Info/Iamge")
        playerView.Info.Master = gamers.transform:Find(objectStr.."/Info/Master")
        playerView.GameState = {}
        playerView.GameState.Grid = gamers.transform:Find(objectStr.."/GameState")
        playerView.GameState.Chui = gamers.transform:Find(objectStr.."/GameState/Chui")
        playerView.GameState.Gun = gamers.transform:Find(objectStr.."/GameState/Gun")
        playerView.GameState.Dou = gamers.transform:Find(objectStr.."/GameState/Dou")
        playerView.GameState.FanDou = gamers.transform:Find(objectStr.."/GameState/FanDou")
        playerView.GameState.HelpDou = gamers.transform:Find(objectStr.."/GameState/HelpDou")
        playerView.GameInfo = {}
        playerView.GameInfo.ZhuaScore = gamers.transform:Find(objectStr.."/GameInfo/ZhuaScore")
        playerView.GameInfo.ChaoScore = gamers.transform:Find(objectStr.."/GameInfo/ChaoScore")
        playerView.GameInfo.TotalScore = gamers.transform:Find(objectStr.."/GameInfo/TotalScore")
        playerView.GameInfo.Score = gamers.transform:Find(objectStr.."/GameInfo/Score")
        playerView.GameInfo.CardTable =gamers.transform:Find(objectStr.."/CardTable")
        playerView.gameObject = gamers.transform:Find(objectStr).gameObject

        table.insert(playerViews, playerView)
    end

    ButtonOK = gameObject.transform:Find("Buttons/ButtonOK")
    DarkCards = gameObject.transform:Find("DarkCards")
    ButtonXiPai = gameObject.transform:Find("Buttons/ButtonXiPai")

    message:AddClick(ButtonOK.gameObject, this.OnClickNext)
    message:AddClick(ButtonShare.gameObject,this.OnClickShared);
    message:AddClick(ButtonXiPai.gameObject,this.OnClickButtonXiPai);
end

function this.setButtonsStatus(hideXiPai)
    if hideXiPai==nil and RoundData.roomData.setting.openShuffle==true and RoundData.isInGame==true and RoundData.data.gameOver==false then
        ButtonXiPai.gameObject:SetActive(true)
        ButtonXiPai:Find('Label'):GetComponent('UILabel').text='洗牌'
        ButtonXiPai:GetComponent('UIButton').isEnabled=true
    else
        ButtonXiPai.gameObject:SetActive(false)
    end
    if RoundData.isBack==true then
		local hasXiPai=false
		for i=1,#RoundData.playerData do
			if RoundData.playerData[i].isShuffle then
				panelInGame.needXiPai=true
				if RoundData.playerData[i].seat==RoundData.mySeat then
					ButtonXiPai:Find('Label'):GetComponent('UILabel').text='已洗牌'
					ButtonXiPai:GetComponent('UIButton').isEnabled=false
					break
				end
			end
        end
        RoundData.isBack=false
	end
end

function this.OnClickButtonXiPai(go)
    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
        ButtonXiPai:GetComponent('UIButton').isEnabled=false
        AudioManager.Instance:PlayAudio('btn')
        local msg = Message.New()
        msg.type = bbtz_pd.SHUFFLE
        SendGameMessage(msg, nil)
    end, nil, '洗牌会消耗'..RoundData.roomData.setting.shuffleFee..'疲劳值，是否确认洗牌？(确认洗牌后将自动进入下一局)')
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.onGetXiPaiResult(msg)
    local b = bbtz_pd.RShuffle()
    b:ParseFromString(msg.body)
    if b.seat==RoundData.mySeat then
        --错误码 83:洗牌成功  84:洗牌失败非疲劳值不足  85:洗牌失败疲劳值不足  86:重复洗牌
        if b.code==83 then
            ButtonXiPai:Find('Label'):GetComponent('UILabel').text='已洗牌'
            local msg = Message.New()
            msg.type = bbtz_pd.READY
            SendGameMessage(msg, nil)
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
    RegisterGameCallBack(bbtz_pd.SHUFFLE, this.onGetXiPaiResult)
    this.setButtonsStatus()
    for i = 1, #playerViews do
        local playerView = playerViews[i]
        this.ResetPlayerView(playerView, {}, {})
    end

    this.SetRoomInfoView((RoundData.roomData.round - 1).."/"..RoundData.roomData.setting.rounds, roomInfo.roomNumber)
    for i = 1, #RoundData.data.players do
        local playerEnd = RoundData.data.players[i]
        local playerData = RoundData.playerData[playerEnd.seat]
        local playerView = playerViews[i]
        playerView.gameObject:SetActive(true)
        this.ResetPlayerView(playerView, playerData, playerEnd)
        --local cards = {{cards = {0,1,2,3}},{cards = {0,1,2,3}},{cards = {0,1,2,3}}}
        this.SetPlayerCards(playerView.GameInfo.CardTable, playerEnd.playCards, playerEnd.cards)
    end

    local isPlayer2 = #RoundData.data.players == 2 
    this.SetPlayerViewChange(isPlayer2)
    playerViews[3].gameObject:SetActive(not isPlayer2)

    DarkCards.gameObject:SetActive(isPlayer2)
    local cardTable = DarkCards:Find("CardTable")
    Util.ClearChild(cardTable)
    if isPlayer2 then
        local darkCards = RoundData.data.darkCards;
        darkCards = Bbtz_CardLogic.GetDeskHanCard(darkCards);
        this.SetCardGroup(cardTable, darkCards, "")
        cardTable.gameObject:GetComponent("UITable"):Reposition()
    end
end

function this.SetPlayerCards(cardTable, playCards, restCards)
    for i = 1, #playCards do
        this.SetCardGroup(cardTable, playCards[i].cards, GetCardCategoryString(playCards[i].category))
    end

    --剩下未出的牌
    if #restCards ~= 0 then 
        restCards = Bbtz_CardLogic.GetDeskHanCard(restCards);
        this.SetCardGroup(cardTable, restCards, "", function(obj)
            obj.transform:Find("background"):GetComponent('UISprite').color = Color(181/256, 181/256, 181/256)
        end)
    end
    cardTable.gameObject:GetComponent("UITable"):Reposition()
end

function this.SetCardGroup(cardTable, cards, type, func)
    function SetGridCards(grid, cards, cardPrefab, isAddDepth, func)
        local depthGap = 2;
        local bbtzPaiSize = UnityEngine.PlayerPrefs.GetInt("bbtzPaiSize",1);
       
        for i = 1, #cards do
            local obj = NGUITools.AddChild(grid.gameObject, cardPrefab.gameObject)
            if func then func(obj) end
            SetWidgetDepth(obj.transform, isAddDepth and i + depthGap or 2)
            SetCardKeyColor(obj, cards[i],bbtzPaiSize);
            obj.gameObject:SetActive(true)
            depthGap = depthGap + 2;
        end
    end

    local cardGroup = NGUITools.AddChild(cardTable.gameObject, Prefab.CardGroup.gameObject)
    SetGridCards(cardGroup.transform:Find("Grid"), cards, Prefab.Card, #cards ~= 1, func)
    cardGroup.gameObject:SetActive(true)
    GridResetPosition(cardGroup.transform:Find("Grid"))
    this.SetLabelText(cardGroup.transform:Find("Label"), type)
end

function this.SetPlayerViewChange(isPlayer2)
    local needHide = isPlayer2
    playerViews[2].GameInfo.ChaoScore.gameObject:SetActive(needHide)
    playerViews[2].GameInfo.TotalScore.gameObject:SetActive(needHide)
    playerViews[2].gameObject.transform:Find("GridLine/HideLine").gameObject:SetActive(needHide)
end

function this.ResetPlayerView(playerView, playerData, playerEnd)
    this.SetLabelText(playerView.Info.ID, "ID:"..tostring(playerData.id))
    this.SetLabelText(playerView.Info.Name, playerData.name)
    playerView.Info.Master.gameObject:SetActive(playerEnd.isBanker)
    if playerData.icon ~= nil then
        coroutine.start(LoadPlayerIcon, playerView.Info.Iamge:GetComponent('UITexture'), playerData.icon)
    else
        playerView.Info.Iamge:GetComponent('UITexture').mainTexture = nil
    end

    local grid = playerView.GameState.Grid
    for i=0, grid.transform.childCount - 1 do
        local state = grid.transform:GetChild(i)
        state.gameObject:SetActive(false)
    end
    
    playerView.GameState.Chui.gameObject:SetActive(playerEnd.hammer)
    playerView.GameState.Gun.gameObject:SetActive(playerEnd.shoot)
    playerView.GameState.Dou.gameObject:SetActive(playerEnd.steep)
    playerView.GameState.FanDou.gameObject:SetActive(playerEnd.reverse)
    playerView.GameState.HelpDou.gameObject:SetActive(playerEnd.helpSteep)
    GridResetPosition(playerView.GameState.Grid)

    this.SetLabelText(playerView.GameInfo.ZhuaScore, playerEnd.grabScore)
    this.SetLabelText(playerView.GameInfo.ChaoScore, playerEnd.chaoScore)
    this.SetLabelText(playerView.GameInfo.TotalScore, playerEnd.sum)
    this.SetLabelText(playerView.GameInfo.Score, this.GetNumColorAndString(playerEnd.score))
    Util.ClearChild(playerView.GameInfo.CardTable)
end

function this.SetRoomInfoView(round, roomId)
    SetLabelText(gameObject.transform:Find("RoundInfo/round"), round)
    SetLabelText(gameObject.transform:Find("RoundInfo/roomNum"), roomId)
end

function this.OnClickNext(go)
	if RoundData.isInGame then 
		if RoundData.roomData.state ~= bbtz_pd.BIGOVER then
			local msg = Message.New()
			msg.type = bbtz_pd.READY
			SendGameMessage(msg, nil)
		else
			PanelManager.Instance:ShowWindow("panelStageClearAll_bbtz")
		end
	end 
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickShared(go)
    print("OnClickShared was called");
	if not RoundData.isInGame then 
		return
	end
	PanelManager.Instance:ShowWindow('panelShared', {showName = 'JieTuShare'})
end

function this.SetLabelText(label, text, color)
    label.gameObject:GetComponent("UILabel").text = text
    if color ~= nil then
        label.gameObject:GetComponent('UILabel').color = color
    end
end

function this.GetNumColorAndString(num)
    num = (num == nil) and 0 or num
    if num >= 0 then
        return "+"..num, Color(214/256, 18/256, 0)
    else
        return num, Color(0, 63/256, 165/256)
    end
end

function this.Update()
end

function this.WhoShow(fuc)
	fuc()
end