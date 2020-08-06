local yjqf_pb = require 'yjqf_pb'
local proxy_pb = require 'proxy_pb'
panelReplay_yjqf = {}
local this = panelReplay_yjqf

local gameObject
local message

local roomID
local roomRound
local desktopScore

local roomTime
local batteryLevel
local network
local pingLabel

local desktopBG
local playerName
local playerRule
local buttonHelp
local buttonPlay
local inCardGridWigth
local groupInCardGrid
local inCardItem
local desktopDiPaiCard
local TrusteeshipPanel
local TrusteeshipTip
local player={}
local ButtonSlow
local ButtonPause
local ButtonFast
local FastLabel
local ButtonBack
local SlowLabel
local watchPanel
local watchMask
local watchGrid
local watchPlatePrefab
local dismissTypeTip

local roomPeople = 3
local cardDepth = 20

local playerData={}
local mySeat = -1
local cutTime = 0.25
local rawSpeed
local isPause = false
local playInterval = 1.5
local playIndex = 1
local RoundDetail
local conFun
local clockTimeCor
local refreshStateCoroutine
local playerCards = {}

function this.Awake(obj)
    gameObject = obj
    message = gameObject:GetComponent('LuaBehaviour')

    roomID = gameObject.transform:Find('topObj/room/ID')
	roomRound = gameObject.transform:Find('topObj/round/num')
    desktopScore = gameObject.transform:Find('topObj/deskScore/scoreLabel')
    
    roomTime = gameObject.transform:Find('rightObj/time')
	batteryLevel = gameObject.transform:Find('rightObj/battery/level'):GetComponent('UISprite')
	network = gameObject.transform:Find('rightObj/network'):GetComponent('UISprite')
	pingLabel = gameObject.transform:Find('rightObj/ping'):GetComponent('UILabel')

    desktopBG = gameObject.transform:Find('deskBg')
    playerName = gameObject.transform:Find('playName'):GetComponent('UILabel')
	playerRule = gameObject.transform:Find('playName/rule'):GetComponent('UILabel')

    buttonHelp = gameObject.transform:Find('playerOperateBtn/buttonHelp')
	message:AddClick(buttonHelp.gameObject, this.OnClickButtonHelp)
	buttonPlay = gameObject.transform:Find('playerOperateBtn/buttonPlay')
	message:AddClick(buttonPlay.gameObject, this.OnClickButtonPlay)

    inCardGridWigth = gameObject.transform:Find('inCardGridWigth')
	groupInCardGrid = inCardGridWigth:Find('groupInCardGrid')
	inCardItem = gameObject.transform:Find('inCardItem')
    desktopDiPaiCard = gameObject.transform:Find('diPaiCard')
	TrusteeshipTip = gameObject.transform:Find('TrusteeshipTip')
    TrusteeshipPanel = gameObject.transform:Find('TrusteeshipPanel')
    
    for i=0,roomPeople-1 do
		local playerUI = {}
		playerUI.obj = gameObject.transform:Find('player/'..i)
		playerUI.playerWidget = playerUI.obj:GetComponent('UIWidget')
		playerUI.playerInfo = playerUI.obj:Find('info')
		playerUI.playerIcon = playerUI.playerInfo:Find('Texture')
		message:AddClick(playerUI.playerIcon.gameObject, this.OnClickPlayerIcon)
		playerUI.playerScore = playerUI.playerInfo:Find('score')
		playerUI.playerName = playerUI.playerInfo:Find('name')
		playerUI.playerOperateSign = playerUI.playerInfo:Find('kuang01')
		playerUI.playerOutCardEndSign = playerUI.playerInfo:Find('OutCardFinish')
		playerUI.playerRoomer = playerUI.playerInfo:Find('roomer')	
		playerUI.playerTrusteeship = playerUI.playerInfo:Find('trusteeship')	
        playerUI.playerOfflineTime = playerUI.playerInfo:Find('offlineTime')
        playerUI.watchPlate = playerUI.playerInfo:Find('watchPlate')
        message:AddClick(playerUI.watchPlate.gameObject, this.OnClickWatchPlate)
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

    ButtonSlow = gameObject.transform:Find('control/ButtonSlow')
    message:AddClick(ButtonSlow.gameObject, this.OnClickButtonSlow)
    SlowLabel = gameObject.transform:Find('control/ButtonSlow/Label')
    ButtonPause = gameObject.transform:Find('control/ButtonPause')
    message:AddClick(ButtonPause.gameObject, this.OnClickButtonPause)
    ButtonFast = gameObject.transform:Find('control/ButtonFast')
    message:AddClick(ButtonFast.gameObject, this.OnClickButtonFast)
    FastLabel = gameObject.transform:Find('control/ButtonFast/Label')
    ButtonBack = gameObject.transform:Find('control/ButtonBack')
    message:AddClick(ButtonBack.gameObject, this.OnClickButtonBack)

    watchPanel = gameObject.transform:Find("watchPanel")
    watchMask = gameObject.transform:Find("watchPanel/watchMask")
    watchGrid = gameObject.transform:Find("watchPanel/plateGrid")

    message:AddClick(watchMask.gameObject, this.OnWatchMaskClick)
    dismissTypeTip = gameObject.transform:Find('dismissTypeTip/Tip/text')
	message:AddClick(gameObject.transform:Find('dismissTypeTip/Tip/dismissTypeTipBtn').gameObject, function (go)
		gameObject.transform:Find('dismissTypeTip/Tip').gameObject:SetActive(false)
		gameObject.transform:Find('dismissTypeTip/dismissTypeTipBtn').gameObject:SetActive(true)
	end)
	message:AddClick(gameObject.transform:Find('dismissTypeTip/dismissTypeTipBtn').gameObject, function (go)
		gameObject.transform:Find('dismissTypeTip/Tip').gameObject:SetActive(true)
		gameObject.transform:Find('dismissTypeTip/dismissTypeTipBtn').gameObject:SetActive(false)
	end)
    rawSpeed = playInterval
    this.CloneCard()
end

function this.Start()
end
function this.OnEnable()
    AudioManager.Instance:PlayMusic('yjqfBGM', true)
	gameObject.transform:Find('dismissTypeTip/Tip').gameObject:SetActive(false)
	gameObject.transform:Find('dismissTypeTip/dismissTypeTipBtn').gameObject:SetActive(true)
end
function this.Update()
end
local whoShow
function this.WhoShow(data)
    whoShow = data
    panelLogin.HideNetWaitting()
    this.Reset()
    if not data.isNeedRequest then
        return
    end
    PanelManager.Instance:HideWindow('panelLobby')
    PanelManager.Instance:HideWindow('panelClub')
    local msg = Message.New()
    local b = proxy_pb.PRoundRecords()
    b.roomId = replayData.roomId
    b.round = replayData.round
    b.gameType = proxy_pb.YJQF
    msg.type = proxy_pb.ROUND_RECORDS
    msg.body = b:SerializeToString()
    SendProxyMessage(msg, this.OnGetRoundDetail)
    PanelManager.Instance:HideWindow('panelRecordDetail')
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
    --生成看牌
    for j = 0, 41 do
        local obj =  NGUITools.AddChild(watchGrid.gameObject, inCardItem.gameObject)
        obj.transform.localScale = Vector3(0.7,0.75,1)
        this.SetCardDepth(obj,j)
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
function this.Reset()
    playInterval = 1.5
    isPause = false
    playIndex = 1
    mySeat = -1
    playerCards = {}
    playerData = {}
    ButtonPause:GetComponent('UIButton').normalSprite = 'zanting'
    FastLabel:GetComponent('UILabel').text = ''
    SlowLabel:GetComponent('UILabel').text = ''
    local inx = UnityEngine.PlayerPrefs.GetInt('ground_yjqf', 1)
	for i = 0, desktopBG.childCount-1 do
		desktopBG:GetChild(i).gameObject:SetActive(false)
	end
	desktopBG:GetChild(inx).gameObject:SetActive(true)
end

function this.GetUIIndexBySeat(seat)
    return (RoundDetail.setting.size-mySeat+seat)%RoundDetail.setting.size
end
function this.GetPlayerDataByUIIndex(index)
	local i = index + mySeat
	if i > 0 then
		i = i % RoundDetail.setting.size
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
				local clocktime = RoundDetail.setting.trusteeship
				clocktime = clocktime == 0 and 15 or clocktime
				local inx = this.GetUIIndexBySeat(seat)
				for i = 0, RoundDetail.setting.size-1 do
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
function this.RefreshPlayers()
    print('mySeat : '..mySeat..' RoundDetail.setting.size :'..RoundDetail.setting.size)
    print('this.GetUIIndexBySeat(0) : '..this.GetUIIndexBySeat(0))
	player[this.GetUIIndexBySeat(0)].playerRoomer.gameObject:SetActive(true)
	for i = 1, #RoundDetail.players do
		local inx = this.GetUIIndexBySeat(RoundDetail.players[i].seat)
		this.RefreshPlayer(player[inx],RoundDetail.players[i])
	end
end
function this.RefreshPlayer(playerUI,data)
	playerUI.obj.gameObject:SetActive(true)
	playerUI.playerName:GetComponent('UILabel').text = data.name
	coroutine.start(LoadPlayerIcon, playerUI.playerIcon:GetComponent('UITexture'), data.icon)
    SetUserData(playerUI.playerIcon.gameObject,data)
    SetUserData(playerUI.watchPlate.gameObject,data)
	playerUI.playerScore:GetComponent('UILabel').text = 0
	playerUI.playerOfflineTime.gameObject:SetActive(false)
	playerUI.playerTrusteeship.gameObject:SetActive(false)
	
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
				local item = grid:GetChild(i)
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
function this.InitPlayerInfo()
    this.initCardGroup()
    this.initOutCardGroup()
	groupInCardGrid.gameObject:SetActive(false)
    buttonHelp.parent.gameObject:SetActive(false)
    desktopDiPaiCard.gameObject:SetActive(false)
	for i = 0, roomPeople-1 do
		player[i].playerRoomer.gameObject:SetActive(false)
        player[i].obj.gameObject:SetActive(false)
        player[i].playerAllScoreObj.gameObject:SetActive(false)
		player[i].playerOutCardEndSign.gameObject:SetActive(false)
		player[i].clockTime.gameObject:SetActive(false)
		player[i].playerOperateSign.gameObject:SetActive(false)
		player[i].playerPass.gameObject:SetActive(false)
		--player[i].playerCardCategory.gameObject:SetActive(false)
		player[i].playerBoomSign.gameObject:SetActive(false)
		player[i].playerOutCardGrid.gameObject:SetActive(false)
		player[i].playerOutCardTable.gameObject:SetActive(false)
	end
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
--初始化出牌
function this.initOutCardGroup()
	for i=0,RoundDetail.setting.size - 1 do 
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
function this.SetDiPai(cards)
	desktopDiPaiCard.gameObject:SetActive(true)
	desktopDiPaiCard:GetComponent('UIGrid'):Reposition()
	table.sort(cards)
	for i = 1, #cards do
		this.UpdataCardInfo(desktopDiPaiCard:GetChild(i-1),cards[i])
		if GetPlateNum(cards[i]) == 5 or GetPlateNum(cards[i]) == 10 or GetPlateNum(cards[i]) == 13 then
			desktopDiPaiCard:GetChild(i-1):GetComponent('TweenPosition').enabled = true
		end
	end
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
-- 获得局详情
function this.OnGetRoundDetail(msg)
    local b = yjqf_pb.RRoundRecords()
    b:ParseFromString(msg.body)
    RoundDetail = b
	dismissTypeTip:GetComponent("UILabel").text = b.diss
    if refreshStateCoroutine then
		coroutine.stop(refreshStateCoroutine)
	end
	refreshStateCoroutine = coroutine.start(this.RefreshState)
	coroutine.start(RefreshTime, roomTime:GetComponent('UILabel'),60)
	roomData = {}
	roomData.round = replayData.round
	roomInfo.roomNumber = replayData.roomNumber
	roomData.setting = b.setting
    roomID:GetComponent('UILabel').text = replayData.roomNumber
    roomRound:GetComponent('UILabel').text = "第"..replayData.round..'局'
    playerName.text = '沅江千分'
    playerRule.text = getYJQFRuleString(RoundDetail.setting)
    playerData = {}
	for i=1,#RoundDetail.players do
		local p = RoundDetail.players[i]
        playerData[p.seat] = p
        if p.id == info_login.id then
            if mySeat == -1 then
                mySeat = p.seat
            end
        end
    end
    if mySeat == -1 then
        mySeat = 0
    end
	if whoShow.isSelectSeat then
		mySeat = whoShow.mySeat
	end
    this.InitPlayerInfo()
    this.RefreshPlayers()
    conFun = coroutine.start(this.AutoPlay)
end
--自动播放
function this.AutoPlay()
    if #RoundDetail.records == 0 then
        return
    end
    coroutine.wait(1)
    local lastSeat = RoundDetail.records[1].seat -1
	while gameObject.activeSelf do
        if not isPause then
			local d = RoundDetail.records[playIndex]
			playIndex = playIndex+1
            if playIndex > #RoundDetail.records then
				if RoundDetail.roundEnd and RoundDetail.roundEnd~=nil then 
					if #RoundDetail.roundEnd.players > 0 then
						coroutine.stop(clockTimeCor)
						for i = 0, roomPeople-1 do
							player[i].playerBoomSign.gameObject:SetActive(false)
							player[i].playerOutCardGrid.gameObject:SetActive(false)
							player[i].playerOutCardTable.gameObject:SetActive(false)
						end
						this.SetDiPai(RoundDetail.roundEnd.lossCards)
						local isHaveScore =false
						for i = 1, #RoundDetail.roundEnd.lossCards do
							if GetPlateNum(RoundDetail.roundEnd.lossCards[i]) == 5 or GetPlateNum(RoundDetail.roundEnd.lossCards[i]) == 10 or GetPlateNum(RoundDetail.roundEnd.lossCards[i]) == 13 then
								isHaveScore = true
								break
							end
						end
						if isHaveScore then
							AudioManager.Instance:PlayAudio('addScore')	
							local data = RoundDetail.roundEnd.players[1]
							if data.grabScore ~= 0 and data.grabScore ~= tonumber(player[data.seat].playerNowScore:GetComponent('UILabel').text) then
								AudioManager.Instance:PlayAudio('addScore')
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
						this.hasStageClear=true
						RoundData = {}
						RoundData.isInGame = false
						RoundData.gameOver = RoundDetail.roundEnd.gameOver
						RoundData.darkCards = RoundDetail.roundEnd.darkCards
						local players = {}
						for i = 1, #RoundDetail.roundEnd.players do
							local pla = {}
							pla.seat = RoundDetail.roundEnd.players[i].seat
							pla.historyScore = RoundDetail.roundEnd.players[i].historyScore
							pla.happlyScore = RoundDetail.roundEnd.players[i].happlyScore
							pla.rewardScore = RoundDetail.roundEnd.players[i].rewardScore
							pla.grabScore = RoundDetail.roundEnd.players[i].grabScore
							pla.win = RoundDetail.roundEnd.players[i].win
							pla.cards = RoundDetail.roundEnd.players[i].cards
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
						PanelManager.Instance:ShowWindow('panelStageClear_yjqf')
						desktopDiPaiCard.gameObject:SetActive(false)
						return 
					end
				end
			end
			if playIndex > #RoundDetail.records then
				return 
			end
			this.OnDoPlayer(d)
			print('c : '..d.c.."  当前进度 ",playIndex,"/",#RoundDetail.records)
			if d.c == 'CPass' or d.c == 'CPlay' then
				coroutine.wait(playInterval)
			end
        else
            coroutine.wait(0.5)
		end
	end
end

function this.OnDoPlayer(record)
    if record.c == 'CStart' then
        playerCards[record.seat] = record.cards
        if record.seat == mySeat then
            desktopScore:GetComponent('UILabel').text = 0
            this.UpdataBoardScore(record.boards)
            this.UpdataPlayerCard(record.cards,groupInCardGrid)
        end
    elseif record.c == 'CPass' then--不要
        this.OnPlayerPass(record)
    elseif record.c == 'CPlay' then--出牌
        this.OnPlayerPlay(record)
    elseif record.c == 'CBoardScore' then--刷新计分板
        desktopScore:GetComponent('UILabel').text = record.cardScore
        this.UpdataBoardScore(record.boards,true)
    end
	if record.c ~= 'CBoardScore' then
        player[this.GetUIIndexBySeat(record.seat)].playerTrusteeship.gameObject:SetActive(record.trusteeship) 
        player[this.GetUIIndexBySeat(record.seat)].playerOfflineTime.gameObject:SetActive(not record.offline)
    end
end
function this.OnPlayerPlay(record)
	AudioManager.Instance:PlayAudio('betcard')
    local index = this.GetUIIndexBySeat(record.seat)
    for i=1,#record.hand.cards do
        for j=1,#playerCards[record.seat] do
            if record.hand.cards[i] == playerCards[record.seat][j] then
                playerCards[record.seat]:remove(j)
                break
            end
        end
	end
	coroutine.stop(clockTimeCor)
	for i = 0, roomPeople-1 do
		player[i].playerBoomSign.gameObject:SetActive(false)
		player[i].playerOperateSign.gameObject:SetActive(false)
		player[i].playerOutCardTable.gameObject:SetActive(false)
		player[i].playerOutCardGrid.gameObject:SetActive(false)
		player[i].playerPass.gameObject:SetActive(false)
		player[i].clockTime.gameObject:SetActive(false)
	end
	player[this.GetUIIndexBySeat(record.seat)].playerOperateSign.gameObject:SetActive(true)
	if mySeat == record.seat then
		this.UpdataPlayerCard(playerCards[mySeat],groupInCardGrid)
	end
	if record.hand.category == 5 or record.hand.category == 3 then
		this.UpdataPlayerCard(record.hand.cards,player[index].playerOutCardTable,record.hand)
	else
		this.UpdataPlayerCard(record.hand.cards,player[index].playerOutCardGrid,record.hand)
    end
    
	local name 
	if record.roundOrder == 0 then
		name = '上游'
	elseif record.roundOrder == 1 then
		if RoundDetail.setting.size == 3 then
			name = '中游'
		else
			name = '下游'
		end
	elseif record.roundOrder == 2 then
		name = '下游'
	elseif record.roundOrder == -1 then
		name = ''	
	end
	if record.roundOrder ~= -1 then
		AudioManager.Instance:PlayAudio('winerVoice')
	end
	player[index].playerOutCardEndSign:GetComponent('UISprite').spriteName = name
	player[index].playerOutCardEndSign.gameObject:SetActive(record.roundOrder ~= -1)
	this.PlayCardSound(record.hand.cards,record.hand.category,playerData[record.seat].sex,UnityEngine.PlayerPrefs.GetInt("sound_yjqf", 1) == 1)
	player[index].playerPass.gameObject:SetActive(false)
	if record.hand.category == 6 then
		if #record.hand.cards < 7 then
			player[index].playerBoomSign:GetComponent('UISprite').spriteName='提示_4炸'
		else
			player[index].playerBoomSign:GetComponent('UISprite').spriteName='提示_4炸以上'
		end
		player[index].playerBoomSign:Find('Label'):GetComponent('UILabel').text = #record.hand.cards..'张'
		player[index].playerBoomSign.gameObject:SetActive(true)
	end
	--[[local teXiaoName = ''
	if record.hand.category == 0 then
		teXiaoName = 'danzhang'
	elseif record.hand.category == 1 then
		teXiaoName = 'duizi'
	elseif record.hand.category == 2 then
		teXiaoName = 'liandui'
	elseif record.hand.category == 3 then
		teXiaoName = '3d2'
	elseif record.hand.category == 4 then
		teXiaoName = 'shunzi'
	elseif record.hand.category == 5 then
		teXiaoName = 'feiji'
	elseif record.hand.category == 6 then
		teXiaoName = 'zhadan'
	end
	for i = 0, RoundDetail.setting.size - 1 do
		player[i].playerCardCategory.gameObject:SetActive(false)
	end
	player[index].playerCardCategory:GetComponent('UISprite').spriteName = teXiaoName
	player[index].playerCardCategory:GetComponent('UISprite'):MakePixelPerfect()
	player[index].playerCardCategory.gameObject:SetActive(true)]]
end
function this.OnPlayerPass(record)
	coroutine.stop(clockTimeCor)
	for i = 0, RoundDetail.setting.size - 1 do
		player[i].playerOperateSign.gameObject:SetActive(false)
		player[i].playerPass.gameObject:SetActive(false)
		player[i].clockTime.gameObject:SetActive(false)
	end
	player[this.GetUIIndexBySeat(record.seat)].playerOutCardTable.gameObject:SetActive(false)
	player[this.GetUIIndexBySeat(record.seat)].playerOutCardGrid.gameObject:SetActive(false)
	--player[this.GetUIIndexBySeat(record.seat)].playerCardCategory.gameObject:SetActive(false)
	player[this.GetUIIndexBySeat(record.seat)].playerBoomSign.gameObject:SetActive(false)
	player[this.GetUIIndexBySeat(record.seat)].playerPass.gameObject:SetActive(true)
	player[this.GetUIIndexBySeat(record.seat)].playerOperateSign.gameObject:SetActive(true)
	local name 
	if record.roundOrder == 0 then
		name = '上游'
	elseif record.roundOrder == 1 then
		if RoundDetail.setting.size == 3 then
			name = '中游'
		else
			name = '下游'
		end
	elseif record.roundOrder == 2 then
		name = '下游'
	elseif record.roundOrder == -1 then
		name = ''	
	end
	if record.roundOrder ~= -1 then
		AudioManager.Instance:PlayAudio('winerVoice')
	end
	player[this.GetUIIndexBySeat(record.seat)].playerOutCardEndSign:GetComponent('UISprite').spriteName = name
	player[this.GetUIIndexBySeat(record.seat)].playerOutCardEndSign.gameObject:SetActive(record.roundOrder ~= -1)
	local soundName = ''
	if UnityEngine.PlayerPrefs.GetInt("sound_yjqf", 1) == 1 then
		soundName = soundName..'fy_yjqf_'
	end
	soundName = soundName..string.format('yaobuqi_%d_%d', playerData[record.seat].sex,(math.random(0, 1))+1)
	AudioManager.Instance:PlayAudio(soundName)
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
	print('#cards : '..#cards)
	print('soundName : '..soundName)
	if soundName ~= nil and soundName ~= '' then
		AudioManager.Instance:PlayAudio(soundName)
	end
end
function this.UpdataBoardScore(data,isPlay)
	for i = 1, #data do
		local board = data[i]
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
		end
		player[this.GetUIIndexBySeat(board.seat)].playerScore:GetComponent('UILabel').text = board.roundGrab
		player[board.seat].playerNowScore:GetComponent('UILabel').text = board.roundGrab
		print(i..' board.nickname: '..board.nickname..' board.historyScore : '..board.historyScore..' board.happlyScore : '..board.happlyScore..' board.roundGrab : '..board.roundGrab)
	end
end
function this.OnClickButtonSlow(go)
    AudioManager.Instance:PlayAudio('btn')
    if playInterval + cutTime  <= 2 then
        playInterval = playInterval + cutTime
    end
    local num = (rawSpeed - playInterval)/cutTime
    if num > 0 then
        FastLabel:GetComponent('UILabel').text = 'x'..num
        SlowLabel:GetComponent('UILabel').text = ''
    elseif num <0 then
        FastLabel:GetComponent('UILabel').text = ''
        SlowLabel:GetComponent('UILabel').text = 'x'..math.abs(num)
    else
        FastLabel:GetComponent('UILabel').text = ''
        SlowLabel:GetComponent('UILabel').text = ''
    end
end
function this.OnClickButtonPause(go)
    AudioManager.Instance:PlayAudio('btn')
    isPause = not isPause
    if isPause then
        ButtonPause:GetComponent('UIButton').normalSprite = 'bofang'
    else
        ButtonPause:GetComponent('UIButton').normalSprite = 'zanting'
    end
end
function this.OnClickButtonFast(go)
    AudioManager.Instance:PlayAudio('btn')
    if playInterval - cutTime >= 0.5 then
        playInterval = playInterval - cutTime
    end
    local num = (rawSpeed - playInterval)/cutTime
    if num > 0 then
        FastLabel:GetComponent('UILabel').text = 'x'..num
        SlowLabel:GetComponent('UILabel').text = ''
    elseif num <0 then
        FastLabel:GetComponent('UILabel').text = ''
        SlowLabel:GetComponent('UILabel').text = 'x'..math.abs(num)
    else
        FastLabel:GetComponent('UILabel').text = ''
        SlowLabel:GetComponent('UILabel').text = ''
    end
end
function this.OnClickButtonBack(go)
    AudioManager.Instance:PlayAudio('btn')
    coroutine.stop(conFun)
    PanelManager.Instance:ShowWindow(whoShow.name)
    PanelManager.Instance:HideWindow(gameObject.name)
    AudioManager.Instance:PlayMusic('MainBG', true)
end
--点击看牌按钮
function this.OnClickWatchPlate(go)
    --先暂停
    isPause = true
    ButtonPause:GetComponent('UIButton').normalSprite = 'bofang'
    --显示牌面窗口
    watchPanel.gameObject:SetActive(true)
    local seat = GetUserData(go).seat
    this.SetWatchPlatesGrid(playerCards[seat])
end
--点击空白处关闭看牌
function this.OnWatchMaskClick(go)
    --先播放
    isPause = false
    ButtonPause:GetComponent('UIButton').normalSprite = 'zanting'
    --关闭牌面显示窗口
    watchPanel.gameObject:SetActive(false)
end
--设置查看的牌面
function this.SetWatchPlatesGrid(cards)
    if not cards then
        return
    end
    for i = 0, watchGrid.childCount-1 do
        watchGrid:GetChild(i).gameObject:SetActive(false)
    end
    table.sort(cards,tableSortDesc)
    for i = 1, #cards do
        this.UpdataCardInfo(watchGrid:GetChild(i-1),cards[i])
    end
    watchGrid:GetComponent("UIGrid"):Reposition()
end
function this.OnClickPlayerIcon(go)
    print(' RoundDetail.openUserCard : '..tostring(RoundDetail.openUserCard)..' RoundDetail.isLord : '..tostring(RoundDetail.isLord))
	if RoundDetail.openUserCard then
		local pData = GetUserData(go)
		if not pData then
			return
		end
		local userData = {}
		userData.rseat 		= pData.seat
		userData.mySeat		= mySeat
		userData.nickname   = pData.name
		userData.icon       = pData.icon
		userData.sex        = pData.sex
		userData.ip         = pData.ip
		userData.userId     = pData.id
		userData.gameType	= proxy_pb.YJQF
		userData.signature  = ''
		userData.imgUrl  = ''
		userData.sendMsgAllowed = RoundDetail.setting.sendMsgAllowed
		userData.isRePlay = true
        userData.gameMode = RoundDetail.setting.gameMode
		userData.fee = pData.fee
		userData.isShowSomeID = not RoundDetail.isLord
		PanelManager.Instance:ShowWindow('panelPlayerInfo', userData)
	end
end