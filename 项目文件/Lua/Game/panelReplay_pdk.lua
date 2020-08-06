local proxy_pb = require 'proxy_pb'
local pdk_pb = require 'pdk_pb'

panelReplay_pdk = {}
local this = panelReplay_pdk;

local message;
local gameObject;

local playerName={}
local playerPlateNum={}
local playerIcon={}
local playerMaster={}
local playerGridIn={}
local playerGridOut={}
local playerPass={}
local playerpiaofen={}
local playerNiao={}
local playerTrusteeship={}
local playerOfflineTime={}
local roomSetting

local ButtonSlow
local ButtonPause
local ButtonFast
local FastLabel
local ButtonBack
local SlowLabel

local RoundDetail
local playerData={}
local mySeat

local isPause = false
local playInterval = 2
local playIndex = 1
local rawSpeed
local network
local conFun
local conTime
local refreshStateCoroutine
local pingLabel = ""
local playerzi = {}

local roomData = {}
local dismissTypeTip
--启动事件--
function this.Awake(obj)
	gameObject = obj;
	message = gameObject:GetComponent('LuaBehaviour');

    ButtonSlow = gameObject.transform:Find('control/ButtonSlow')
	SlowLabel = gameObject.transform:Find('control/ButtonSlow/Label')
    ButtonPause = gameObject.transform:Find('control/ButtonPause');
    ButtonFast = gameObject.transform:Find('control/ButtonFast');
	FastLabel = gameObject.transform:Find('control/ButtonFast/Label')
    ButtonBack = gameObject.transform:Find('control/ButtonBack')
	roomSetting = gameObject.transform:Find('setting')
	network = gameObject.transform:Find('state/network'):GetComponent('UISprite')
	batteryLevel = gameObject.transform:Find('state/battery/level'):GetComponent('UISprite')
	--pingLabel = gameObject.transform:Find('ping'):GetComponent('UILabel')
	RegisterGameCallBack(pdk_pb.PONG, this.OnPong)
	-- message:AddPress(network.gameObject, function (go, state)
	-- 	pingLabel.gameObject:SetActive(state)
	-- end)

    message:AddClick(ButtonSlow.gameObject, this.OnClickButtonSlow);
    message:AddClick(ButtonPause.gameObject, this.OnClickButtonPause);
    message:AddClick(ButtonFast.gameObject, this.OnClickButtonFast);
    message:AddClick(ButtonBack.gameObject, this.OnClickButtonBack);

    for i=0,2 do
		playerName[i] = gameObject.transform:Find('player'..i..'/info/name');
		playerPlateNum[i] = gameObject.transform:Find('player'..i..'/card/num');
		playerIcon[i] = gameObject.transform:Find('player'..i..'/info/Texture'..i);
		message:AddClick(playerIcon[i].gameObject, this.OnClickPlayerIcon)
		--playerScore[i] = gameObject.transform:Find('player'..i..'/score');
		playerMaster[i] = gameObject.transform:Find('player'..i..'/info/master');
		playerGridIn[i] = gameObject.transform:Find('player'..i..'/GridIn');
		playerGridOut[i] = gameObject.transform:Find('player'..i..'/GridOut');
		playerPass[i] = gameObject.transform:Find('player'..i..'/pass')
		playerpiaofen[i] = gameObject.transform:Find('player'..i..'/info/piaofen')
		playerzi[i] = gameObject.transform:Find('player'..i..'/texiaozi')
		playerNiao[i] = gameObject.transform:Find('player'..i..'/info/Niao')
		playerTrusteeship[i] = gameObject.transform:Find('player'..i..'/info/trusteeship')
		playerOfflineTime[i] = gameObject.transform:Find('player'..i..'/info/offlineTime')
	end
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
	 --生成card
	local inCardItem = gameObject.transform:Find('inCardItem').gameObject
	local depth = 5
	local outCardItem = gameObject.transform:Find('outCardItem').gameObject
	for i = 0, 2 do
		for j = 0, 15 do
			local obj1 = NGUITools.AddChild(playerGridIn[i].gameObject,inCardItem.gameObject)
			this.SetCardDepth(obj1,depth+j*3)
			local obj = NGUITools.AddChild(playerGridOut[i].gameObject,outCardItem.gameObject)
			this.SetCardDepth(obj,depth+j*3)
		end
	end
end
function this.SetCardDepth(obj,dep)
	obj.gameObject:SetActive(false)
	obj.transform:Find("type"):GetComponent("UISprite").depth = dep+1
	obj.transform:Find("typeSmall"):GetComponent("UISprite").depth = dep+1
	obj.transform:Find("num"):GetComponent("UISprite").depth = dep+1
	obj.transform:Find("typeBig"):GetComponent("UISprite").depth = dep+1
	obj.transform:Find("bg"):GetComponent("UISprite").depth = dep
	obj.transform:Find("shouchu"):GetComponent("UISprite").depth = dep+1
	obj.transform:Find("typeBig").gameObject:SetActive(false)
	obj.transform:Find("shouchu").gameObject:SetActive(false)
end
function this.Start()
	if refreshStateCoroutine then
		coroutine.stop(refreshStateCoroutine)
	end
	refreshStateCoroutine = coroutine.start(this.RefreshState)
end
function this.Update()
	
end
function this.Reset()
    playInterval = 2
    isPause = false
    playIndex = 1
	
	for i=0,2 do
		playerGridOut[i].gameObject:SetActive(false)
		playerGridIn[i].gameObject:SetActive(false)
		playerpiaofen[i]:GetComponent('UILabel').text = ''
		playerzi[i].gameObject:SetActive(false)
		playerNiao[i].gameObject:SetActive(false)
		playerTrusteeship[i].gameObject:SetActive(false)
		playerOfflineTime[i].gameObject:SetActive(false)
	end
	ButtonPause:GetComponent('UIButton').normalSprite = 'zanting'
	FastLabel:GetComponent('UILabel').text = ''
	SlowLabel:GetComponent('UILabel').text = ''
end

local whoShow
function this.WhoShow(data)
	panelLogin.HideNetWaitting()
	this.Reset()

	whoShow = data
	if not data.isNeedRequest then
		return 
	end

	local msg = Message.New()
	local b = proxy_pb.PRoundRecords()
	b.roomId = replayData.roomId
	b.round = replayData.round
	b.gameType = proxy_pb.PDK
    msg.type = proxy_pb.ROUND_RECORDS
    msg.body = b:SerializeToString()
    SendProxyMessage(msg, this.OnGetRoundDetail);
	PanelManager.Instance:HideWindow('panelRecordDetail')
	PanelManager.Instance:HideWindow('panelRecord')
	PanelManager.Instance:HideWindow('panelLobby')
    PanelManager.Instance:HideWindow('panelClub')
	gameObject.transform:Find('dismissTypeTip/Tip').gameObject:SetActive(false)
	gameObject.transform:Find('dismissTypeTip/dismissTypeTipBtn').gameObject:SetActive(true)
end

function this.OnEnable()
end

function this.OnGetRoundDetail(msg)
    print('OnGetRoundDetail')
    local b = pdk_pb.RRoundRecords()
    b:ParseFromString(msg.body)
    RoundDetail = b
	print('b.diss : '..b.diss)
	
	dismissTypeTip:GetComponent("UILabel").text = b.diss
	playerData={}
    for i=1, #RoundDetail.players do
        local p = RoundDetail.players[i]
        playerData[p.seat] = p
        -- if p.id == info_login.id then
        --     mySeat = p.seat
		-- end
	end
	mySeat = 0
	if whoShow.isSelectSeat then
		mySeat = whoShow.mySeat
	end
	print('playerData num:'..#playerData..' mySeat:'..mySeat)
    this.RefreshRoom()

    conFun = coroutine.start(this.AutoPlay)
end

function this.GetPlayerDataByUIIndex(index)
	local i = index + mySeat
	if i > 0 then
		i = i % #RoundDetail.players
	end
	
	return playerData[i]
end

function this.GetUIIndexBySeat(seat)
    return ((#playerData+1)-mySeat+seat)%(#playerData+1)
end

function this.RefreshRoom()
	print(replayData.roomNumber)
    gameObject.transform:Find('state/room/ID'):GetComponent("UILabel").text = replayData.roomNumber
    gameObject.transform:Find('state/round/num'):GetComponent("UILabel").text = "第"..replayData.round..'/'..RoundDetail.setting.rounds.."局"
    conTime = coroutine.start(RefreshTime, gameObject.transform:Find('state/time'):GetComponent("UILabel"), 1)

    for i=0,2 do
		if i < RoundDetail.setting.size then
			playerName[i].parent.gameObject:SetActive(true)
			local p = this.GetPlayerDataByUIIndex(i)
			playerName[i]:GetComponent('UILabel').text = p.name
			if RoundDetail.setting.showCount then
				playerPlateNum[i]:GetComponent('UILabel').text = #p.cards
				playerPlateNum[i].gameObject:SetActive(true)
			else
				playerPlateNum[i].gameObject:SetActive(false)
			end
			if RoundDetail.setting.floatScore  then
				for k = 1, #RoundDetail.scores do
					if p.seat == RoundDetail.scores[k].seat then
						if RoundDetail.scores[k].floatScore == 0 then
							playerpiaofen[i]:GetComponent("UILabel").text = "不飘分"
						else
							playerpiaofen[i]:GetComponent("UILabel").text = "飘"..RoundDetail.scores[k].floatScore.."分"
						end
					end
				end
			end

			if RoundDetail.setting.hitBird ~= 0 then
				for k = 1, #RoundDetail.scores do
					if p.seat == RoundDetail.scores[k].seat then
						playerNiao[i].gameObject:SetActive(RoundDetail.scores[k].hitBird)
					end
				end
			end

			coroutine.start(LoadPlayerIcon, playerIcon[i]:GetComponent('UITexture'), p.icon)
			SetUserData(playerIcon[i].gameObject, p)
			if(#RoundDetail.records > 0 and p.seat == RoundDetail.records[1].seat) then
				playerMaster[i].gameObject:SetActive(true)
			else
				playerMaster[i].gameObject:SetActive(false)
			end
	 
			playerGridOut[i].gameObject:SetActive(false)
			playerGridIn[i].gameObject:SetActive(true)
			RefreshGrid(playerGridIn[i], p.cards, true)
		else
			SetUserData(playerIcon[i].gameObject, nil)
			playerName[i].parent.gameObject:SetActive(false)
		end
    end
	
	local setting_text = getWanFaText_pdk(RoundDetail.setting,false, false,true)

	
	--gameObject.transform:Find('setting'):GetComponent("UILabel").text = setting_text
	roomSetting:GetComponent('UILabel').text = setting_text
	roomSetting:Find('setting'):GetComponent("UILabel").text = setting_text
end


function this.AutoPlay()
    Debugger.Log('replay start', nil)
	if #RoundDetail.records == 0 then
		print('no records!')
		return
	end
	
	coroutine.wait(1)
	
    local lastSeat = RoundDetail.records[1].seat -1
    while playIndex <= #RoundDetail.records do
        if not isPause then
            for i=0,2 do
                playerGridOut[i].gameObject:SetActive(false)
            end

            local d = RoundDetail.records[playIndex]
			if #d.cards == 0 then
				math.randomseed(os.time())
				local index = math.random(0, 2)
				print('index :'..index)
				local i = this.GetUIIndexBySeat(d.seat)
				playerPass[i]:GetChild(index):GetComponent("UISprite"):MakePixelPerfect()
				playerPass[i]:GetChild(index).gameObject:SetActive(true)
				print("要不起声音名字",string.format('yaobuqi_%d_%d',1 ,index+1))
				AudioManager.Instance:PlayAudio(string.format('yaobuqi_%d_%d',1 ,index+1))
				playIndex = playIndex+1
			else
				for i = 0, 2 do
					for j = 0, 2 do
						playerPass[i]:GetChild(j).gameObject:SetActive(false)
					end
				end
                this.OnPlayerPlay(d.seat, d.cards, d.offline, d.trusteeship,d.category)
				playIndex = playIndex+1
            end
			if RoundDetail.roundEnd and RoundDetail.roundEnd~=nil then 
				if playIndex > #RoundDetail.records and #RoundDetail.roundEnd.players > 0 then
					coroutine.wait(0.5)
					RoundData.data = RoundDetail.roundEnd
					RoundData.mySeat = mySeat
					RoundData.playerData = playerData
					RoundData.playerIcon = playerIcon
					RoundData.setting = RoundDetail.setting
					local roomData = {}
					roomData.round = replayData.round+1
					roomData.setting = RoundDetail.setting
					RoundData.roomData = roomData
					roomInfo.roomNumber = replayData.roomNumber
					RoundData.isInGame = false
					PanelManager.Instance:ShowWindow('panelStageClear_pdk')
					return
				end
			end
			coroutine.wait(playInterval)
		else
			coroutine.wait(0.5)
        end
    end
end

function this.OnPlayerPlay(seat, cards, offline, trusteeship,category)

	--过牌
	if cards == nil or #cards == 0 then
		return 
	end

    local pData = playerData[seat]
    for i=1,#cards do
        for j=1,#pData.cards do
            if cards[i] == pData.cards[j] then
                table.remove(pData.cards, j)
                break
            end
        end
    end
	
	--table.sort(cards, tableSortDesc)
	--local groupCards ={}
	--[[local groups = GetCardsGroup(cards)
	local group3 = GetGroupByID(3, groups)
	local group2 = GetGroupByID(2, groups)
	local group1 = GetGroupByID(1, groups)
	if #group3 > 0 then
		for i=1,#group3 do
			table.insert(groupCards, group3[i][1])
			table.insert(groupCards, group3[i][2])
			table.insert(groupCards, group3[i][3])
		end
		for i=1,#group2 do
			table.insert(groupCards, group2[i][1])
			table.insert(groupCards, group2[i][2])
		end
		for i=1,#group1 do
			table.insert(groupCards, group1[i][1])
		end
	elseif #group2 > 0 then
		for i=1,#group2 do
			table.insert(groupCards, group2[i][1])
			table.insert(groupCards, group2[i][2])
		end
	else
		for i=1,#cards do
			table.insert(groupCards, cards[i])
		end
	end]]
	
    local index = this.GetUIIndexBySeat(seat)
	playerGridOut[index].gameObject:SetActive(true)
    RefreshGrid(playerGridIn[index], pData.cards, true)
    RefreshGrid(playerGridOut[index], cards,true)
	playerPlateNum[index]:GetComponent('UILabel').text = #pData.cards
	this.PlayCardSound(cards, 1,index,category)

	--托管离线标识
	playerOfflineTime[index].gameObject:SetActive(offline == true)
	playerTrusteeship[index].gameObject:SetActive(trusteeship == true)
end
function this.PlayCardSound(cards, sex,index,category)
	local soundName = ''
	local spritename=""
	if category==-1 then
		local cardGroups = GetCardsGroup(cards)
		for i=4,1,-1 do
			local group = GetGroupByID(i, cardGroups)
			if #group > 0 then
				if i == 4 then
					if #cards  == 4 then
						soundName = string.format('bomb_%d', sex)
						spritename = "zhadan"
					elseif #cards == 6 then
						soundName = string.format('sidaier_%d', sex)
						spritename = "4d2"
					else
						local group3 = GetGroupByID(3, cardGroups)
						if #group3 >= 2 then
							soundName = string.format('fei_%d', sex)
							spritename = "feiji"
						else
							soundName = string.format('sidaisan_%d', sex)
							spritename = "4d3"
						end

					end
				elseif i == 3 then
					if #group == 1 then
						if #cards == 3 and GetPlateNum(group[1][1]) == 14 and roomData.setting.bombAAA then
							soundName = string.format('bomb_%d', sex)
							spritename = "zhadan"
						else
							soundName = string.format('sandaier_%d', sex)
							--if #cards == 4 then
								--spritename = "3d1"
							--elseif #cards == 5 then
								spritename = "3d2"
							--else
								--spritename = "3z"
							--end
						end
					else
						soundName = string.format('fei_%d', sex)
						spritename = "feiji"
					end
				elseif i == 2 then
					if #group == 1 then
						soundName = string.format('dui_%d_%d', sex, GetPlateNum(group[1][1]))
						spritename = "duizi"
					else
						soundName = string.format('liandui_%d', sex)
						spritename = "liandui"
					end
				else
					if #group == 1 then
						soundName = string.format('dan_%d_%d', sex, GetPlateNum(group[1][1]))
					else
						soundName = string.format('shunzi_%d', sex)
						spritename = "shunzi"
					end
				end
				break
			end
		end
	else
		if category == ZHA_DAN or category == SI then
			soundName = string.format('bomb_%d', sex)
			spritename = "zhadan"
		elseif category == FEI_ER or category == FEI_YI or category == SAN_SHUN then
			soundName = string.format('fei_%d', sex)
			spritename = "feiji"
		elseif category == LIAN_DUI then
			soundName = string.format('liandui_%d', sex)
			spritename = "liandui" 
		elseif category == SHUN then
			soundName = string.format('shunzi_%d', sex)
			spritename = "shunzi"
		elseif category == DAN then 
			soundName = string.format('dan_%d_%d', sex, GetPlateNum(cards[1]))
		elseif category == DUI then
			soundName = string.format('dui_%d_%d', sex, GetPlateNum(cards[1]))
			spritename = "duizi"
		elseif category == SAN or category == SAN_YI or category == SAN_ER then
			soundName = string.format('sandaier_%d', sex)
			spritename = "3d2"
		elseif category == SI_ER or category == SI_YI then
			soundName = string.format('sidaier_%d', sex)
			spritename = "4d2"
		elseif category == SI_SAN then
			soundName = string.format('sidaisan_%d', sex)
			spritename = "4d3"
		end
	end
	
	--[[if spritename ~= "" then
		coroutine.start(
			function()
				playerzi[index].gameObject:SetActive(true)
				playerzi[index]:GetChild(0):GetComponent("UISprite").spriteName = spritename
				playerzi[index]:GetChild(0):GetComponent("UISprite"):MakePixelPerfect()
				coroutine.wait(1)
				playerzi[index].gameObject:SetActive(false)
			end
		)
	end]]
	print("语音播放名字",soundName..category)
	if soundName ~= nil and soundName ~= '' then
		AudioManager.Instance:PlayAudio(soundName)
	end
end
function this.OnClickButtonSlow(go)
	AudioManager.Instance:PlayAudio('btn')
    if playInterval < 3.5 then
		if playInterval < rawSpeed then
			playInterval = rawSpeed
			FastLabel:GetComponent('UILabel').text = ''
		else
			playInterval = playInterval + 0.5
		end
    end
	local num = math.abs(rawSpeed - playInterval)/0.5
	if num > 0 then
		SlowLabel:GetComponent('UILabel').text = 'x'..num
	else
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
	print('isPause:'..tostring(isPause))
end

function this.OnClickButtonFast(go)
	AudioManager.Instance:PlayAudio('btn')
    if playInterval > 0.5 then
		if playInterval > rawSpeed then
			playInterval = rawSpeed
			SlowLabel:GetComponent('UILabel').text = ''
		else
			playInterval = playInterval - 0.5
		end
    end
	
	local num = math.abs(rawSpeed - playInterval)/0.5
	if num > 0 then
		FastLabel:GetComponent('UILabel').text = 'x'..num
	else
		FastLabel:GetComponent('UILabel').text = ''
	end
end

function this.OnClickButtonBack(go)
	AudioManager.Instance:PlayAudio('btn')
    coroutine.stop(conFun)
    coroutine.stop(conTime)
	PanelManager.Instance:ShowWindow(whoShow.name)
    PanelManager.Instance:HideWindow(gameObject.name)
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
    if string.len(pingLabel) == 0 then
        return 3
    end
    local ping = tonumber(pingLabel)
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
		pingLabel = int64.tonum2(Util.GetTime()) - int64.tonum2(connect.LastHeartBeatTime)
	else 
		pingLabel =  ''
	end
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
		userData.gameType	= proxy_pb.PHZ
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