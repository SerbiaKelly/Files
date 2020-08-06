local proxy_pb = require 'proxy_pb'
local phz_pb = require 'phz_pb'

panelReplay = {}
local this = panelReplay

local message
local gameObject

local playerName={}
local playerIcon={}
local playerMaster={}
local playerScore={}
local playerGridXi={}
local playerThrow={}
local playerXiNum={}
local playerRoundScore={}
local playerOperationEffectPos={}
local playerMoPaiPos={}
local playerGridHand={}
local playerPiao = {}
local playerNiao = {}
local playerTuo = {}
local playerTrusteeship={}
local playerOfflineTime={}
local playerLianZhuang={}
local playerWarn={}
local playerAddScoreLabel={}

local operation_receive
local dipai
local curMoPai

local playerDi
local roomSetting
local curOperatPlateEffect
local curPais

local ButtonSlow
local ButtonPause
local ButtonFast
local FastLabel
local ButtonBack
local SlowLabel

local operation_send
local ButtonHu
local ButtonPao
local ButtonTi
local ButtonWei
local ButtonPeng
local ButtonChi
local ButtonGuo

local RoundDetail
local playerData={}
local mySeat = -1
local paiAnimations={}
local bankerSeat

local isPause = false
local playInterval = 1.5
local playIndex = 1
local rawSpeed
local lastOperat={}
local dipaiNum = 19
local cutTime = 0.25

roomData = {}

local conFun
local conTime

local bg
local chouPlates = {}
local dismissTypeTip
local whoShow 
--启动事件--
function this.Awake(obj)
	gameObject = obj;
	message = gameObject:GetComponent('LuaBehaviour');

    bg = gameObject.transform:Find('Bg');
    ButtonSlow = gameObject.transform:Find('control/ButtonSlow')
	SlowLabel = gameObject.transform:Find('control/ButtonSlow/Label')
    ButtonPause = gameObject.transform:Find('control/ButtonPause');
    ButtonFast = gameObject.transform:Find('control/ButtonFast');
	FastLabel = gameObject.transform:Find('control/ButtonFast/Label')
    ButtonBack = gameObject.transform:Find('control/ButtonBack')
	roomSetting = gameObject.transform:Find('setting')
	curOperatPlateEffect = gameObject.transform:Find('curOperatPlateEffect')
	curPais =  gameObject.transform:Find('curPais')

	operation_send = gameObject.transform:Find('operation_send')
	ButtonHu = operation_send:Find('ButtonHu')
	ButtonPao = operation_send:Find('ButtonPao')
	ButtonTi = operation_send:Find('ButtonTi')
	ButtonWei = operation_send:Find('ButtonWei')
    ButtonPeng = operation_send:Find('ButtonPeng')
    ButtonChi = operation_send:Find('ButtonChi')
    ButtonGuo = operation_send:Find('ButtonGuo')

    message:AddClick(ButtonSlow.gameObject, this.OnClickButtonSlow);
    message:AddClick(ButtonPause.gameObject, this.OnClickButtonPause);
    message:AddClick(ButtonFast.gameObject, this.OnClickButtonFast);
    message:AddClick(ButtonBack.gameObject, this.OnClickButtonBack);
	
	for i = 0, 3 do
        local playerIcon = gameObject.transform:Find('player' .. i .. '/Texture')
        message:AddClick(playerIcon.gameObject, this.OnClickPlayerIcon)
    end

	operation_receive = gameObject.transform:Find('operation_receive')
	dipai = gameObject.transform:Find('DiPai')
	curMoPai =  gameObject.transform:Find('curMoPai')
	
	playerDi = gameObject.transform:Find('player0/TableDi')
	
	dismissTypeTip = gameObject.transform:Find('dismissTypeTip/Tip/text')
	message:AddClick(gameObject.transform:Find('dismissTypeTip/Tip/dismissTypeTipBtn').gameObject, function (go)
        gameObject.transform:Find('dismissTypeTip/Tip').gameObject:SetActive(false)
		gameObject.transform:Find('dismissTypeTip/dismissTypeTipBtn').gameObject:SetActive(true)
    end)
	message:AddClick(gameObject.transform:Find('dismissTypeTip/dismissTypeTipBtn').gameObject, function (go)
        gameObject.transform:Find('dismissTypeTip/Tip').gameObject:SetActive(true)
		gameObject.transform:Find('dismissTypeTip/dismissTypeTipBtn').gameObject:SetActive(false)
    end)
	
	this.GetPlayerUI()
	rawSpeed = playInterval
end
function this.changeBG(lanOrLv)

	print('lanOrLv: '..tostring(lanOrLv))
    for i = 0, bg.childCount - 1 do
        if i == lanOrLv then
            bg.transform:GetChild(i).gameObject:SetActive(true)
        else
            bg.transform:GetChild(i).gameObject:SetActive(false)
        end
    end
    -- gameObject.transform:Find('type'):GetComponent('UILabel').color = yanse
    -- for i = 0, roomSetting:Find('op').childCount - 1 do
    --     roomSetting:Find('op'):GetChild(i):GetComponent('UILabel').color = yanse
    -- end
end
function this.Start()
end
function this.Update()
end

function this.WhoShow(data)
	panelLogin.HideNetWaitting()
	this.Reset()
	whoShow = data
	if not data.isNeedRequest then
		return 
	end

	PanelManager.Instance:HideWindow('panelLobby')
    PanelManager.Instance:HideWindow('panelClub')
    local msg = Message.New()
	local b = proxy_pb.PRoundRecords()
	b.roomId = replayData.roomId
	b.round = replayData.round
	b.gameType = proxy_pb.PHZ
    msg.type = proxy_pb.ROUND_RECORDS
    msg.body = b:SerializeToString()
    SendProxyMessage(msg, this.OnGetRoundDetail);
	
    PanelManager.Instance:HideWindow('panelRecordDetail')
end

function this.OnEnable()
	this.changeBG(UnityEngine.PlayerPrefs.GetInt('ground', 1))
	AudioManager.Instance:PlayMusic('GameBG', true);
	gameObject.transform:Find('dismissTypeTip/Tip').gameObject:SetActive(false)
	gameObject.transform:Find('dismissTypeTip/dismissTypeTipBtn').gameObject:SetActive(true)
end

function this.GetPlayerUI(playerNum)
	playerNum = playerNum or 4
	for i=0,3 do
		local index = i
        -- if playerNum == 4 then
        --     if i == 1 then
        --         index = 3
        --     elseif i == 2 then
        --         index = 1
        --     elseif i == 3 then
        --         index = 2
        --     end
        -- end
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
		playerName[i] = gameObject.transform:Find('player'..index..'/name')
		playerIcon[i] = gameObject.transform:Find('player'..index..'/Texture')
		playerScore[i] = gameObject.transform:Find('player'..index..'/score')
		playerMaster[i] = gameObject.transform:Find('player'..index..'/master')
		playerThrow[i] = gameObject.transform:Find('player'..index..'/TabelThrow')
		playerGridXi[i] = gameObject.transform:Find('player'..index..'/GridXi')
		playerXiNum[i] = gameObject.transform:Find('player'..index..'/xiNum')
		playerOperationEffectPos[i] = gameObject.transform:Find('player'..index..'/operation_pos')
		playerMoPaiPos[i] = gameObject.transform:Find('player'..index..'/mopai_pos')
		playerRoundScore[i] = gameObject.transform:Find('player'..index..'/score_round')
		playerGridHand[i] = gameObject.transform:Find('player'..index..'/GridHand')
		playerNiao[i] = gameObject.transform:Find('player'..index..'/Niao')
		playerPiao[i] = gameObject.transform:Find('player'..index..'/piaofen')
		playerTuo[i] = gameObject.transform:Find('player'..index..'/Tuo')
		playerTrusteeship[i] = gameObject.transform:Find('player'..index..'/trusteeship')
		playerOfflineTime[i] = gameObject.transform:Find('player'..index..'/offlineTime')
		playerLianZhuang[i] = gameObject.transform:Find('player'..index..'/lianZhuang')
        playerWarn[i] = gameObject.transform:Find('player'..index..'/warn')
        playerAddScoreLabel[i] = gameObject.transform:Find('player'..index..'/addScoreLabel')
		playerName[i].parent.gameObject:SetActive(true)
		if playerNum == 3 then
			playerName[3].parent.gameObject:SetActive(false)
		elseif playerNum == 2 then
			playerName[2].parent.gameObject:SetActive(false)
			playerName[3].parent.gameObject:SetActive(false)
		end
		if playerNum == 4 then
			local pos = playerGridXi[0].localPosition
			pos.x=-130
			pos.y=48
			playerGridXi[0].localPosition = pos
			pos = dipai.localPosition
			pos.y=34
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
	
end

function this.Reset()
    playInterval = 1.5
    isPause = false
    playIndex = 1
	mySeat = -1
	lastOperat={}
	operation_send.gameObject:SetActive(false)

	ButtonPause:GetComponent('UIButton').normalSprite = 'zanting'
	FastLabel:GetComponent('UILabel').text = ''
	SlowLabel:GetComponent('UILabel').text = ''
	for i=0,curPais.childCount-1 do
		curPais:GetChild(i).gameObject:SetActive(false)
	end
	
	for i=0,3 do
		--print('playerGridHand[i]',playerGridHand[i])
		playerGridHand[i].gameObject:SetActive(false)
		playerGridXi[i].gameObject:SetActive(false)
		playerThrow[i].gameObject:SetActive(false)
		playerXiNum[i].gameObject:SetActive(false)
		playerTrusteeship[i].gameObject:SetActive(false)
		playerOfflineTime[i].gameObject:SetActive(false)
		playerWarn[i].gameObject:SetActive(false)
		playerLianZhuang[i].gameObject:SetActive(false)
		playerAddScoreLabel[i].gameObject:SetActive(false)
	end
	curOperatPlateEffect.gameObject:SetActive(false)
end

function this.SettingText()
	local AllOption = getWanFaText(roomData.setting, true, false, false)
    -- for i=1,#op do
    --     AllOption = AllOption..op[i]..((i == #op) and "" or "，")
    -- end
    roomSetting:Find("op"):Find("AllOption"):GetComponent('UILabel').text = '[000000]'..AllOption
    roomSetting:Find("op"):Find("AllOption").gameObject:SetActive(true)
	gameObject.transform:Find('type'):GetComponent('UILabel').text = '[000000]'..playTypeString[roomData.setting.roomTypeValue]
    roomSetting.gameObject:SetActive(true)
end

function this.OnGetRoundDetail(msg)
    print('OnGetRoundDetail')
    local b = phz_pb.RRoundRecords()
	b:ParseFromString(msg.body)
	chouPlates = {}
    RoundDetail = b
	bankerSeat = #RoundDetail.records > 0 and RoundDetail.records[1].seat or 0
	roomData={}
	roomData.setting=RoundDetail.setting
	print('dipaiNum : '..b.surplus..'b.diss : '..b.diss)
	dipaiNum = b.surplus+1
	dismissTypeTip:GetComponent("UILabel").text = b.diss
	playerData={}
    for i=1, #RoundDetail.players do
        local p = RoundDetail.players[i]
		p.sex = p.sex == 0 and 1 or p.sex
        if p.id == info_login.id then
			mySeat = p.seat
		else
			if mySeat == -1 then
				mySeat=bankerSeat
			end
		end
		
		table.insert(playerData, p)
	end
	if whoShow.isSelectSeat then
		mySeat = whoShow.mySeat
	end
	this.GetPlayerUI(roomData.setting.size)
	this.SettingText()
	
    this.RefreshRoom()
    conFun = coroutine.start(this.AutoPlay)
end

function this.GetPlayerDataByUIIndex(index)
    if roomData.setting.size == 2 then
        return (index == 0) and this.GetPlayerDataBySeat(mySeat) or this.GetPlayerDataBySeat((mySeat == 1) and 0 or 1)
    end
    local i = index + mySeat
    i = i % roomData.setting.size
    --print(' i : '..i..' index : '..index..'  mySeat : '..mySeat)
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

function this.RefreshRoom()
	--print(replayData.roomNumber)
    gameObject.transform:Find('state/room/ID'):GetComponent("UILabel").text = replayData.roomNumber
    gameObject.transform:Find('state/round/num'):GetComponent("UILabel").text = replayData.round..'/'..RoundDetail.setting.rounds
    conTime = coroutine.start(RefreshTime, gameObject.transform:Find('state/time'):GetComponent("UILabel"), 1)
	--roomSetting:Find('type'):GetComponent('UISprite').spriteName = RoundDetail.setting.roomType == proxy_pb.SYZP and 'word_syzp' or 'word_sybp'
	dipai:Find('Label'):GetComponent('UILabel').text = string.format('剩%d张', dipaiNum)
	
	this.RefreshAllGridHand()
	this.RefreshAllGridXi()
	this.RefreshAllTabelThrow()
	this.RefreshAllXiNum()
	this.RefreshPlayer()
end

function this.RefreshAllGridHand()
	for i=0,3 do
		local pData = this.GetPlayerDataByUIIndex(i)
		if pData and i < roomData.setting.size then
			playerGridHand[i].gameObject:SetActive(true)
			--Util.ClearChild(playerGridHand[i])
			playerGridHand[i].parent.gameObject:SetActive(true)
			RefreshMyGridHand(playerGridHand[i], pData, true, i==0 and 'cardGroupHand' or 'cardGroupXiReplay')
		end
	end
end

function this.RefreshAllGridXi()
	for i=0,3 do
		local pData = this.GetPlayerDataByUIIndex(i)
		if pData and i < roomData.setting.size then
			playerGridXi[i].gameObject:SetActive(true)
			RefreshGridXi(playerGridXi[i], playerGridXi, pData.menZi,{})
		else
			RefreshGridXi(playerGridXi[i], playerGridXi, {},{})
		end
	end
end

function this.RefreshAllTabelThrow()
	for i=0,3 do
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
	for i=0,3 do
		local pData = this.GetPlayerDataByUIIndex(i)
		if pData and i < roomData.setting.size then
			playerXiNum[i].gameObject:SetActive(true)
			if RoundDetail.setting.roomTypeValue == proxy_pb.YXPHZ then
				playerXiNum[i]:GetComponent('UILabel').text = '0胡'
            else
                playerXiNum[i]:GetComponent('UILabel').text = '胡息:0'
            end
		else
			playerXiNum[i].gameObject:SetActive(false)
		end
	end
end

function this.RefreshPlayer()
	for i=0,3 do
		local p = this.GetPlayerDataByUIIndex(i)
		if p  and i < roomData.setting.size then
			playerName[i].gameObject:SetActive(true)
			playerName[i]:GetComponent('UILabel').text = p.name
            coroutine.start(LoadPlayerIcon, playerIcon[i]:GetComponent('UITexture'), p.icon)
			playerIcon[i].gameObject:SetActive(true)
			SetUserData(playerIcon[i].gameObject, p)
			playerScore[i]:GetComponent('UILabel').text = p.score
			playerMaster[i].gameObject:SetActive(p.seat == bankerSeat)
			playerXiNum[i].gameObject:SetActive(true)

			print(tostring(p.niao), tostring(p.tuo))
			playerNiao[i].gameObject:SetActive(p.niao)
			playerPiao[i].gameObject:SetActive(p.piao ~= 0 and p.piao ~= -1)
            playerPiao[i]:GetComponent('UILabel').text = (p.piao ~= 0 and p.piao ~= -1) and ('飘'..p.piao..'分') or ''
			playerTuo[i].gameObject:SetActive(p.tuo)
			if p.lianHu>1 and roomData.setting.mode == 0 then
                playerLianZhuang[i].gameObject:SetActive(true)
                playerLianZhuang[i]:GetComponent('UILabel').text = '连庄x'..p.lianHu
            end
		else
			playerName[i]:GetComponent('UILabel').text = ''
			playerIcon[i].gameObject:SetActive(true)
			SetUserData(playerIcon[i].gameObject, nil)
			playerScore[i]:GetComponent('UILabel').text = '0'
			playerMaster[i].gameObject:SetActive(false)
			playerXiNum[i].gameObject:SetActive(false)
			playerNiao[i].gameObject:SetActive(false)
			playerPiao[i].gameObject:SetActive(false)
			playerTuo[i].gameObject:SetActive(false)
		end
	end
end

function this.AutoPlay()
    Debugger.Log('replay start', nil)
	if #RoundDetail.records == 0 then
		print('no records!')
		return
	end
	
	coroutine.wait(1)
	
    local lastSeat = RoundDetail.records[1].seat -1
    while gameObject.activeSelf do
        if not isPause then
			local currentRecord = RoundDetail.records[playIndex]
			local nextRecord = playIndex < #RoundDetail.records and RoundDetail.records[playIndex+1] or nil
			if currentRecord then
				this.OnPlayerPlay(currentRecord)
			end
			print('等待间隔 '..playInterval..'下一帧数据 '..tostring(nextRecord))
			coroutine.wait(playInterval)
			if currentRecord then
				this.OnPlayerCanOperation(currentRecord,nextRecord)
			end
			playIndex = playIndex+1
			
			if RoundDetail.roundEnd and RoundDetail.roundEnd~=nil then 
				print('RoundDetail.roundEnd : '..tostring(RoundDetail.roundEnd))
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
					PanelManager.Instance:ShowWindow('panelStageClear')
					return
				end
			end 
			--coroutine.wait(playInterval)
		else
			coroutine.wait(0.5)
        end
    end
end

function this.OnPlayerClick(playerOperation,nextRecord)
	--print('用户点击seat'..nextRecord.seat..' myseat'..mySeat..' 是否亮起'..tostring(operation_send.gameObject.activeSelf)..' 操作值'..nextRecord.operation)
	if operation_send.gameObject.activeSelf then
		local btn
		if playerOperation.chosenOperation~=nil then
			if playerOperation.chosenOperation == phz_pb.CHI then
				print('用户过胡点吃')
				btn=ButtonChi
			elseif playerOperation.chosenOperation == phz_pb.PENG then
				print('用户过胡点碰')
				btn=ButtonPeng
			elseif playerOperation.chosenOperation == phz_pb.PAO then
				print('用户过胡点跑')
				btn=ButtonPao
			elseif playerOperation.chosenOperation == phz_pb.TI then
				print('用户过胡点提')
				btn=ButtonTi
			elseif playerOperation.chosenOperation == phz_pb.WEI then
				print('用户过胡点歪')
				btn=ButtonWei
			elseif playerOperation.chosenOperation == phz_pb.PASS then
				print('用户点过')
				btn=ButtonGuo
			end
		elseif nextRecord~=nil then
			if nextRecord.seat==mySeat then
				if nextRecord.operation == phz_pb.CHI then
					print('用户点吃')
					btn=ButtonChi
				elseif nextRecord.operation == phz_pb.PENG then
					print('用户点碰')
					btn=ButtonPeng
				elseif playerOperation.chosenOperation == phz_pb.PAO then
					print('用户过胡点跑')
					btn=ButtonPao
				elseif playerOperation.chosenOperation == phz_pb.TI then
					print('用户过胡点提')
					btn=ButtonTi
				elseif playerOperation.chosenOperation == phz_pb.WEI then
					print('用户过胡点歪')
					btn=ButtonWei
				elseif nextRecord.operation == phz_pb.HU then
					print('用户点胡')
					btn=ButtonHu
				end
			end
		end
		
		if btn then
			local sp = btn:Find('Background'):GetComponent('UISprite')
			sp.color=Color(183/255,163/255,123/255)
			btn:GetComponent('TweenScale').from = Vector3.one
			btn:GetComponent('TweenScale').to = Vector3(1.2,1.2,1.2)
			btn:GetComponent('TweenScale').duration = 0.2
			btn:GetComponent('TweenScale'):ResetToBeginning()
			btn:GetComponent('TweenScale'):PlayForward()
			coroutine.wait(0.2)
			sp.color=Color.white
			btn:GetComponent('TweenScale').from = Vector3(1.2,1.2,1.2)
			btn:GetComponent('TweenScale').to = Vector3.one
			btn:GetComponent('TweenScale').duration = 0.2
			btn:GetComponent('TweenScale'):ResetToBeginning()
			btn:GetComponent('TweenScale'):PlayForward()
			coroutine.wait(0.2)
		end
		operation_send.gameObject:SetActive(false)
		--print('playerOperation.confirmPassHu!!!!!!',playerOperation.confirmPassHu)
		if playerOperation.confirmPassHu and playerOperation.confirmPassHu==true then
			panelMessageBoxTiShi.SetParamers(ONLY_OK_CANCLE, nil, nil, '是否确定放弃胡牌？')
			PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
			--coroutine.wait(playInterval)
			panelMessageBoxTiShi.VirtualOKClick()
			coroutine.wait(1.4)
		end
	end
end

function this.OnPlayerCanOperation(currentRecord,nextRecord)
	--print("playerOperations长度"..#currentRecord.playerOperations)
	for i=1,#currentRecord.playerOperations do
		if currentRecord.playerOperations[i].seat==mySeat then
			--print("playerOperations[i].operations长度"..#currentRecord.playerOperations[i].operations)
			ButtonHu.gameObject:SetActive(false)
			ButtonPao.gameObject:SetActive(false)
			ButtonTi.gameObject:SetActive(false)
			ButtonWei.gameObject:SetActive(false)
			ButtonPeng.gameObject:SetActive(false)
			ButtonChi.gameObject:SetActive(false)
			ButtonGuo.gameObject:SetActive(false)
			local operations=currentRecord.playerOperations[i].operations
			local needActive=false
			for j=1,#operations do
				if operations[j] == phz_pb.CHI then
					print('弹按钮吃')
					ButtonChi.gameObject:SetActive(true)
					needActive=true
				elseif operations[j] == phz_pb.PENG then
					print('弹按钮碰')
					ButtonPeng.gameObject:SetActive(true)
					needActive=true
				elseif operations[j] == phz_pb.PAO then
					if roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
						print('弹按钮跑')
						ButtonPao.gameObject:SetActive(true)
						needActive=true
					end
				elseif operations[j] == phz_pb.TI then
					if roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
						print('弹按钮提')
						ButtonTi.gameObject:SetActive(true)
						needActive=true
					end
				elseif operations[j] == phz_pb.WEI then
					if roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
						print('弹按钮偎')
						ButtonWei.gameObject:SetActive(true)
						needActive=true
					end
				elseif operations[j] == phz_pb.HU then
					print('弹按钮胡')
					ButtonHu.gameObject:SetActive(true)
					needActive=true
				end
			end
		
			if needActive==true then
				ButtonGuo.gameObject:SetActive(needActive)
				operation_send.gameObject:SetActive(needActive)
				operation_send:GetComponent('UITable'):Reposition()
			end
			coroutine.wait(playInterval)
			this.OnPlayerClick(currentRecord.playerOperations[i],nextRecord)
			break
		end
	end
end

function this.OnPlayerPlay(currentRecord)
	print('播放操作'..currentRecord.operation)
	if currentRecord.operation == phz_pb.MO then
		print('正在摸')
		this.OnMoPai(currentRecord)
	elseif currentRecord.operation == phz_pb.CHU then
		print('正在出')
		this.OnChuPai(currentRecord)
	elseif currentRecord.operation == phz_pb.CHI then
		print('正在吃')
		this.OnChiPai(currentRecord)
	elseif currentRecord.operation == phz_pb.PENG then
		print('正在碰')
		this.OnPengPai(currentRecord)
	elseif currentRecord.operation == phz_pb.PAO then
		print('正在跑')
		this.OnPaoPai(currentRecord)
	elseif currentRecord.operation == phz_pb.TI or currentRecord.operation == phz_pb.START_TI then
		print('正在提')
		this.OnTiPai(currentRecord)
	elseif currentRecord.operation == phz_pb.WEI then
		print('正在微')
		this.OnWeiPai(currentRecord)
	elseif currentRecord.operation == phz_pb.HU then
		print('正在胡')
		this.OnHuPai(currentRecord)
	else
		print('unkown operation:'..currentRecord.operation)
	end

	local index = this.GetUIIndexBySeat(currentRecord.seat)
	playerOfflineTime[index].gameObject:SetActive(currentRecord.offline == true)
	playerTrusteeship[index].gameObject:SetActive(currentRecord.trusteeship == true)
end

function this.OnMoPai(record)
	local index = this.GetUIIndexBySeat(record.seat)
	
	--print('seat:'..record.seat..' ui index:'..index)
	if record.toHand then
		this.GetPlayerDataBySeat(record.seat).plates:append(record.plate)
		RefreshMyGridHand(playerGridHand[index], this.GetPlayerDataBySeat(record.seat), true, index==0 and 'cardGroupHand' or 'cardGroupXiReplay')
		
		if record.seat == bankerSeat then
			if #this.GetPlayerDataBySeat(record.seat).plates ~= 21 then
				this.ShowTipEffect('buEffect', record.seat)
			end
		else
			this.ShowTipEffect('buEffect', record.seat)
		end
	end
	dipaiNum = dipaiNum - 1
	this.playPaiAnimation(record.seat, record.plate, dipai.position, playerMoPaiPos[index].position,
											Vector3.zero, Vector3.one, true, not record.toHand)

	dipai:Find('Label'):GetComponent('UILabel').text = string.format('剩%d张', dipaiNum)
	AudioManager.Instance:PlayAudio('chupai')
	coroutine.wait(0.1)
	local audioName = ""
	if UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 1 then
		audioName = string.format('pai_%d_%d', 1, record.plate)
	elseif UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 0 then
		if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
			audioName = string.format('f_17_pai_%d_%d', 1, record.plate)
		else
			audioName = string.format('fpai_%d_%d', 1, record.plate)
		end
	end
	AudioManager.Instance:PlayAudio(audioName)
	
	lastOperat.op = phz_pb.MO_PAI
	lastOperat.plate = record.plate
	lastOperat.seat = record.seat
end

function this.OnChuPai(record)
	local index = this.GetUIIndexBySeat(record.seat)
	playerWarn[index].gameObject:SetActive(record.isWarning)
	this.DoRemovePlates(record.seat, {record.plate})
	
	this.playPaiAnimation(record.seat, record.plate, playerIcon[index].position, playerMoPaiPos[index].position,
										Vector3.zero, Vector3.one, false, true)
	
	AudioManager.Instance:PlayAudio('chupai')
	coroutine.wait(0.1)
	local audioName = ""
	if UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 1 then
		audioName = string.format('pai_%d_%d', 1, record.plate)
	elseif UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 0 then
		if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
			audioName = string.format('f_17_pai_%d_%d', 1, record.plate)
		elseif roomData.setting.roomTypeValue == proxy_pb.YJGHZ then
            audioName = string.format('f_18_pai_%d_%d', 1, record.plate)
		elseif roomData.setting.roomTypeValue == proxy_pb.AHPHZ then
            audioName = string.format('f_19_pai_%d_%d', 1, record.plate)
		else
			audioName = string.format('fpai_%d_%d', 1, record.plate)
		end
	end
	AudioManager.Instance:PlayAudio(audioName)
	if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
		coroutine.wait(0.1)
		AudioManager.Instance:PlayAudio('f_17_baojing_1')
	end
	lastOperat.op = phz_pb.CHU_PAI
	lastOperat.plate = record.plate
	lastOperat.seat = record.seat
end

function this.OnChiPai(record)
	
	local temp = {}
	table.insert(temp, record.plate)
	for i=1,#record.chis do
		table.insert(temp, record.chis[i])
	end
	local index = this.GetUIIndexBySeat(record.seat)
	this.DoRemovePlates(record.seat, record.chis)
	local menZis = {}
	for i=1,#temp,3 do
		local menZi = phz_pb.ROperationPlate()
		menZi.operation = phz_pb.CHI
		menZi.plates:append(temp[i])
		menZi.plates:append(temp[i+1])
		menZi.plates:append(temp[i+2])
		table.insert(this.GetPlayerDataBySeat(record.seat).menZi, menZi)
		table.insert(menZis, menZi)
	end
	chouPlates = {}
	for i = 1, #record.chouPlates do
		table.insert(chouPlates,record.chouPlates)
	end
	if roomData.setting.roomTypeValue == proxy_pb.YJGHZ and record.seat == mySeat then
		SetChouPlates(playerGridHand,chouPlates)
	end
	RefreshGridXi(playerGridXi[index], playerGridXi, this.GetPlayerDataBySeat(record.seat).menZi,menZis,false,true)
	if RoundDetail.setting.roomTypeValue == proxy_pb.YXPHZ then
    else
        playerXiNum[index]:GetComponent('UILabel').text = '胡息:'..record.deskHuXi
    end
	
	this.stopPaiAnimiation(lastOperat.seat, lastOperat.plate)
	index = this.GetUIIndexBySeat(lastOperat.seat)
	if this.GetPlayerDataBySeat(lastOperat.seat).paiHe[#this.GetPlayerDataBySeat(lastOperat.seat).paiHe] == lastOperat.plate then
		table.remove(this.GetPlayerDataBySeat(lastOperat.seat).paiHe, #this.GetPlayerDataBySeat(lastOperat.seat).paiHe)
		RefreshTabelThrow(playerThrow[index], this.GetPlayerDataBySeat(lastOperat.seat).paiHe)
	end

	curOperatPlateEffect.gameObject:SetActive(false)
	this.ShowTipEffect('chiEffect', record.seat)

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

	lastOperat.op = phz_pb.CHI_PAI
	lastOperat.plate = record.plate
	lastOperat.seat = record.seat
end

function this.OnPengPai(record)
	local index = this.GetUIIndexBySeat(record.seat)
	local plates = {record.plate, record.plate}
	this.DoRemovePlates(record.seat, plates)
	local menZi = phz_pb.ROperationPlate()
	menZi.operation = phz_pb.PENG
	menZi.plates:append(record.plate)
	menZi.plates:append(record.plate)
	menZi.plates:append(record.plate)
	menZi.fromSeat = record.fromSeat
	table.insert(this.GetPlayerDataBySeat(record.seat).menZi, menZi)
	local menZis={}
	table.insert(menZis, menZi)
	RefreshGridXi(playerGridXi[index], playerGridXi, this.GetPlayerDataBySeat(record.seat).menZi,menZis,false,true)
	chouPlates = {}
	for i = 1, #record.chouPlates do
		table.insert(chouPlates,record.chouPlates)
	end
	if roomData.setting.roomTypeValue == proxy_pb.YJGHZ and record.seat == mySeat then
		SetChouPlates(playerGridHand,chouPlates)
	end
	if RoundDetail.setting.roomTypeValue == proxy_pb.YXPHZ then
		for i = 1, #record.piaoScore do
            this.SetZhongTuFen(record.piaoScore[i].halfScore,record.piaoScore[i].seat)
        end
		for i = 1, #record.halfScore do
            local ind = this.GetUIIndexBySeat(record.halfScore[i].seat)
            playerXiNum[ind]:GetComponent('UILabel').text = (record.halfScore[i].halfScore > 0 and '+' or '')..record.halfScore[i].halfScore..'胡'
        end
    else
        playerXiNum[index]:GetComponent('UILabel').text = '胡息:'..record.deskHuXi
    end
	
	this.stopPaiAnimiation(lastOperat.seat, lastOperat.plate)
	index = this.GetUIIndexBySeat(lastOperat.seat)
	if this.GetPlayerDataBySeat(lastOperat.seat).paiHe[#this.GetPlayerDataBySeat(lastOperat.seat).paiHe] == lastOperat.plate then
		table.remove(this.GetPlayerDataBySeat(lastOperat.seat).paiHe, #this.GetPlayerDataBySeat(lastOperat.seat).paiHe)
		RefreshTabelThrow(playerThrow[index], this.GetPlayerDataBySeat(lastOperat.seat).paiHe)
	end

	curOperatPlateEffect.gameObject:SetActive(false)
	if record.isPeng3 then
        this.ShowTipEffect('pengSanDaEffect', record.seat)
    elseif record.isPeng4 then
        this.ShowTipEffect('pengSiQingEffect', record.seat)
    else
        this.ShowTipEffect('pengEffect', record.seat)
    end
	local audioName = ""
	if UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 1 then
		audioName = string.format('peng_%d', 1)
	elseif UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 0 then
		if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
            if record.isPeng3 then
                audioName = string.format('f_17_pengsanda_%d', 1)
            elseif record.isPeng4 then
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
	
	lastOperat.op = phz_pb.PENG_PAI
	lastOperat.plate = record.plate
	lastOperat.seat = record.seat
end

function this.OnWeiPai(record)
	local index = this.GetUIIndexBySeat(record.seat)
	local plates = {record.plate, record.plate, record.plate}
	this.DoRemovePlates(record.seat, plates)
	local menZi = phz_pb.ROperationPlate()
	menZi.operation = phz_pb.WEI
	menZi.plates:append(record.plate)
	menZi.plates:append(record.plate)
	menZi.plates:append(record.plate)
	table.insert(this.GetPlayerDataBySeat(record.seat).menZi, menZi)
	local menZis={}
	table.insert(menZis, menZi)
	RefreshGridXi(playerGridXi[index], playerGridXi, this.GetPlayerDataBySeat(record.seat).menZi,menZis,false,true)
	if RoundDetail.setting.roomTypeValue == proxy_pb.YXPHZ then
		for i = 1, #record.piaoScore do
            this.SetZhongTuFen(record.piaoScore[i].halfScore,record.piaoScore[i].seat)
        end
		for i = 1, #record.halfScore do
            local ind = this.GetUIIndexBySeat(record.halfScore[i].seat)
            playerXiNum[ind]:GetComponent('UILabel').text = (record.halfScore[i].halfScore > 0 and '+' or '')..record.halfScore[i].halfScore..'胡'
        end
    else
        playerXiNum[index]:GetComponent('UILabel').text = '胡息:'..record.deskHuXi
    end
	if lastOperat.plate == record.plate then
		this.stopPaiAnimiation(lastOperat.seat, lastOperat.plate)
		index = this.GetUIIndexBySeat(lastOperat.seat)
		if this.GetPlayerDataBySeat(lastOperat.seat).paiHe[#this.GetPlayerDataBySeat(lastOperat.seat).paiHe] == lastOperat.plate then
			table.remove(this.GetPlayerDataBySeat(lastOperat.seat).paiHe, #this.GetPlayerDataBySeat(lastOperat.seat).paiHe)
			RefreshTabelThrow(playerThrow[index], this.GetPlayerDataBySeat(lastOperat.seat).paiHe)
		end
		lastOperat.op = phz_pb.WEI_PAI
		lastOperat.plate = record.plate
		lastOperat.seat = record.seat
	end
	
	curOperatPlateEffect.gameObject:SetActive(false)
	print('record.isSao3: '..tostring(record.isSao3)..'record.isSao4: '..tostring(record.isSao4))
	if record.isSao3 then
        this.ShowTipEffect('saoSanDaEffect', record.seat)
    elseif record.isSao4 then
        this.ShowTipEffect('saoSiQingEffect', record.seat)
    else
		this.ShowTipEffect(roomData.setting.roomTypeValue == proxy_pb.YJGHZ and 'waiEffect' or 'weiEffect', record.seat)
    end
	local audioName = ""
	if UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 1 then
		audioName = string.format('wei_%d', 1)
	elseif UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 0) == 0 then
		if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
            if record.isSao3 then
                audioName = string.format('f_17_saosanda_%d', 1)
            elseif record.isSao4 then
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
end

function this.OnPaoPai(record)
	local index = this.GetUIIndexBySeat(record.seat)
	local menZi = nil
	for i=1,#this.GetPlayerDataBySeat(record.seat).menZi do
		local m = this.GetPlayerDataBySeat(record.seat).menZi[i]
		if (m.operation == phz_pb.PENG or m.operation == phz_pb.WEI) and m.plates[1] == record.plate then
			m.operation = phz_pb.PAO
			m.plates:append(record.plate)
			menZi = m
		end
	end
	
	local plates = {record.plate, record.plate, record.plate, record.plate}
	this.DoRemovePlates(record.seat, plates)

	if not menZi then
		menZi = phz_pb.ROperationPlate()
		menZi.operation = phz_pb.PAO
		menZi.plates:append(record.plate)
		menZi.plates:append(record.plate)
		menZi.plates:append(record.plate)
		menZi.plates:append(record.plate)
		menZi.fromSeat = record.fromSeat
		table.insert(this.GetPlayerDataBySeat(record.seat).menZi, menZi)
	end
	local menZis={}
	table.insert(menZis, menZi)
	RefreshGridXi(playerGridXi[index], playerGridXi, this.GetPlayerDataBySeat(record.seat).menZi,menZis,false,true,true)
	if RoundDetail.setting.roomTypeValue == proxy_pb.YXPHZ then
		for i = 1, #record.piaoScore do
            this.SetZhongTuFen(record.piaoScore[i].halfScore,record.piaoScore[i].seat)
        end
        for i = 1, #record.halfScore do
            local ind = this.GetUIIndexBySeat(record.halfScore[i].seat)
            playerXiNum[ind]:GetComponent('UILabel').text = (record.halfScore[i].halfScore > 0 and '+' or '')..record.halfScore[i].halfScore..'胡'
        end
    else
        playerXiNum[index]:GetComponent('UILabel').text = '胡息:'..record.deskHuXi
    end
	
	this.stopPaiAnimiation(lastOperat.seat, lastOperat.plate)
	index = this.GetUIIndexBySeat(lastOperat.seat)
	if this.GetPlayerDataBySeat(lastOperat.seat).paiHe[#this.GetPlayerDataBySeat(lastOperat.seat).paiHe] == lastOperat.plate then
		table.remove(this.GetPlayerDataBySeat(lastOperat.seat).paiHe, #this.GetPlayerDataBySeat(lastOperat.seat).paiHe)
		RefreshTabelThrow(playerThrow[index], this.GetPlayerDataBySeat(lastOperat.seat).paiHe)
	end

	curOperatPlateEffect.gameObject:SetActive(false)
	this.ShowTipEffect(roomData.setting.roomTypeValue == proxy_pb.YJGHZ and 'piaoEffect' or 'paoEffect', record.seat)
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
	
	lastOperat.op = phz_pb.PAO_PAI
	lastOperat.plate = record.plate
	lastOperat.seat = record.seat
end

function this.OnTiPai(record)
	local menZi = nil
	local index = this.GetUIIndexBySeat(record.seat)
	for i=1,#this.GetPlayerDataBySeat(record.seat).menZi do
		local m = this.GetPlayerDataBySeat(record.seat).menZi[i]
		if m.operation == phz_pb.WEI and m.plates[1] == record.plate then
			m.operation = phz_pb.TI
			m.plates:append(record.plate)
			menZi = m
		end
	end
	
	local plates = {record.plate, record.plate, record.plate, record.plate}
	this.DoRemovePlates(record.seat, plates)
	
	if not menZi then
		menZi = phz_pb.ROperationPlate()
		menZi.operation = phz_pb.TI
		menZi.plates:append(record.plate)
		menZi.plates:append(record.plate)
		menZi.plates:append(record.plate)
		menZi.plates:append(record.plate)
		table.insert(this.GetPlayerDataBySeat(record.seat).menZi, menZi)
	end
	local menZis={}
	table.insert(menZis, menZi)
	RefreshGridXi(playerGridXi[index], playerGridXi, this.GetPlayerDataBySeat(record.seat).menZi,menZis,false,true,true)
	if RoundDetail.setting.roomTypeValue == proxy_pb.YXPHZ then
		for i = 1, #record.piaoScore do
            this.SetZhongTuFen(record.piaoScore[i].halfScore,record.piaoScore[i].seat)
        end
        for i = 1, #record.halfScore do
            local ind = this.GetUIIndexBySeat(record.halfScore[i].seat)
            playerXiNum[ind]:GetComponent('UILabel').text = (record.halfScore[i].halfScore > 0 and '+' or '')..record.halfScore[i].halfScore..'胡'
        end
    else
        playerXiNum[index]:GetComponent('UILabel').text = '胡息:'..record.deskHuXi
    end
	if lastOperat.plate == record.plate then
		this.stopPaiAnimiation(lastOperat.seat, lastOperat.plate)
		index = this.GetUIIndexBySeat(lastOperat.seat)
		if this.GetPlayerDataBySeat(lastOperat.seat).paiHe[#this.GetPlayerDataBySeat(lastOperat.seat).paiHe] == lastOperat.plate then
			table.remove(this.GetPlayerDataBySeat(lastOperat.seat).paiHe, #this.GetPlayerDataBySeat(lastOperat.seat).paiHe)
			RefreshTabelThrow(playerThrow[index], this.GetPlayerDataBySeat(lastOperat.seat).paiHe)
		end
		lastOperat.op = phz_pb.TI
		lastOperat.plate = record.plate
		lastOperat.seat = record.seat
	end

	curOperatPlateEffect.gameObject:SetActive(false)
	this.ShowTipEffect(roomData.setting.roomTypeValue == proxy_pb.YJGHZ and 'liuEffect' or 'tiEffect', record.seat)
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
end

function this.OnHuPai(record)
	this.ShowTipEffect('huEffect', record.seat)
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
end

function this.DoRemovePlates(seat, plates)
	local pData = this.GetPlayerDataBySeat(seat)
	if not pData then
		print('playerData is nil ',seat)
		return
	end
	
	for i=0,#plates do
		local p = plates[i]
		for j=#pData.plates,1,-1 do
			if pData.plates[j] == p then
				table.remove(pData.plates, j)
				break
			end
		end
	end
	local index = this.GetUIIndexBySeat(seat)
	--Util.ClearChild(playerGridHand[index])
	RefreshMyGridHand(playerGridHand[index], pData, true, index==0 and 'cardGroupHand' or 'cardGroupXiReplay')
end
local allCards = {}
--[[    @desc: 
    author:{Einstein}
    time:2018-07-30 20:42:23
    --@tu:要赋值的牌transform
	--@zhi: 牌的值
    @return:
]]
function this.setPaiMian(tu, zhi)
    tu.gameObject:SetActive(true)
    local index = tu:GetComponent('UISprite')
    if not allCards[index] then
        allCards[index] = index
    end
    allCards[index].spriteName = 'card' .. (UnityEngine.PlayerPrefs.GetInt('paiMian', 1) == 1 and '_' or '1_') .. zhi
end
function this.playPaiAnimation(seat, plate, posFrom, posTo, scaleFrom, scaleTo, isMoPai, addToPaiHe)
	--print(string.format('playPaiAnimation seat:%d plate:%d isMoPai:%s addToPaiHe:%s', seat, plate, tostring(isMoPai), tostring(addToPaiHe)))

	local AnimSpeed = 0.3
	local animSpeedScale = 1;
    -- local animSpeedScale = 1;
    -- if UnityEngine.PlayerPrefs.GetInt("animaSpeed", 0) == 1 then
    --     animSpeedScale = 0.5
    -- elseif UnityEngine.PlayerPrefs.GetInt("animaSpeed", 0) == 2 then
    --     animSpeedScale = 0
    -- end

	local curPai = nil
	local anima ={}
	anima.finish = false
	anima.addToPaiHe = addToPaiHe
	for i=0,curPais.childCount-1 do
		if not curPais:GetChild(i).gameObject.activeSelf then
			curPai = curPais:GetChild(i)
			break
		end
	end
	local cor = coroutine.start(
		function()
			this.setPaiMian(curPai:Find('plate0'), plate)
        	this.setPaiMian(curPai:Find('plate1'), plate)
			curPai.gameObject:SetActive(true)
			local index = this.GetUIIndexBySeat(seat)
			if index ~= 0 then
				--curPai:GetComponent('UISprite').spriteName = '牌面拷贝45'
				curPai:Find('mesh_lan').gameObject:SetActive(false)
				curPai:Find('mesh_cheng').gameObject:SetActive(true)
				--print('座位' .. index)
			else
				--curPai:GetComponent('UISprite').spriteName = '牌面拷贝43'
				curPai:Find('mesh_lan').gameObject:SetActive(true)
				curPai:Find('mesh_cheng').gameObject:SetActive(false)
				--print('座位' .. index)
			end
			curPai:GetComponent('TweenPosition').worldSpace = true
			curPai:GetComponent('TweenPosition').from = posFrom
			curPai:GetComponent('TweenPosition').to = posTo
			curPai:GetComponent('TweenPosition').duration = AnimSpeed * animSpeedScale
			curPai:GetComponent('TweenPosition'):ResetToBeginning()
			curPai:GetComponent('TweenPosition'):PlayForward()
			curPai:GetComponent('TweenScale').from = scaleFrom
			curPai:GetComponent('TweenScale').to = scaleTo
			curPai:GetComponent('TweenScale').duration = AnimSpeed * animSpeedScale
			curPai:GetComponent('TweenScale'):ResetToBeginning()
			curPai:GetComponent('TweenScale'):PlayForward()
			curPai:Find('mopailight').gameObject:SetActive(isMoPai)
        	curPai:Find('chupailight').gameObject:SetActive(not isMoPai)
			coroutine.wait(playInterval-curPai:GetComponent('TweenPosition').duration*2)
			if anima.addToPaiHe then
				local index = this.GetUIIndexBySeat(seat)
				this.GetPlayerDataBySeat(seat).paiHe:append(plate)
				RefreshTabelThrow(playerThrow[index], this.GetPlayerDataBySeat(seat).paiHe, seat)
				this.SetPlateEffectShow(playerThrow[index], this.GetPlayerDataBySeat(seat).paiHe, seat)
				local uiObj = playerThrow[index]:GetChild(#this.GetPlayerDataBySeat(seat).paiHe-1)
				uiObj.gameObject:SetActive(false)
				curOperatPlateEffect.gameObject:SetActive(false)
				
				curPai:GetComponent('TweenPosition').from = curPai.position
				curPai:GetComponent('TweenPosition').to = uiObj.position
				curPai:GetComponent('TweenPosition').duration = AnimSpeed * animSpeedScale
				curPai:GetComponent('TweenPosition'):ResetToBeginning()
				curPai:GetComponent('TweenPosition'):PlayForward()
				-- curPai:GetComponent('TweenScale').from = Vector3.one
				-- curPai:GetComponent('TweenScale').to = Vector3.New(1, 0.35, 1)
				-- curPai:GetComponent('TweenScale').duration = AnimSpeed * animSpeedScale
				-- curPai:GetComponent('TweenScale'):ResetToBeginning()
				-- curPai:GetComponent('TweenScale'):PlayForward()
				coroutine.wait(curPai:GetComponent('TweenPosition').duration)
				if anima.addToPaiHe then
					uiObj.gameObject:SetActive(true)
					curOperatPlateEffect.gameObject:SetActive(true)
				else
					table.remove(this.GetPlayerDataBySeat(seat).paiHe, #this.GetPlayerDataBySeat(seat).paiHe)
				end
			end
			curPai.gameObject:SetActive(false)
			anima.finish = true
			--print('playPaiAnimation finish seat:'..seat..' plate:'..plate)
			
			local index = 0
			for i=1,#paiAnimations do
				if paiAnimations[i].seat == seat and paiAnimations[i].plate == plate then
					table.remove(paiAnimations, index)
					--print('remove playPaiAnimation seat:'..seat..' plate:'..plate)
					break
				end
			end
			
		end
	)
	
	anima.cor = cor
	anima.seat = seat
	anima.plate = plate
	anima.curPai = curPai
	table.insert(paiAnimations, anima)
end

function this.stopPaiAnimiation(seat, plate)
	--print('stopPaiAnimiation seat:'..seat..' plate:'..plate)
	local anima = nil
	for i=#paiAnimations,1,-1 do
		if paiAnimations[i].seat == seat and paiAnimations[i].plate == plate then
			anima = paiAnimations[i]
			coroutine.stop(anima.cor)
			anima.addToPaiHe = false
			anima.curPai.gameObject:SetActive(false)
			table.remove(paiAnimations, i)
			--print('find Animiation')
		end
	end
end

function this.ShowTipEffect(effectName, seat)
	local index = this.GetUIIndexBySeat(seat)
	local eff = nil
	for i=0,operation_receive.childCount-1 do
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

function this.SetPlateEffectShow(UItabel, plates, seat)
	if seat == lastOperat.seat and plates[#plates] == lastOperat.plate then
		curOperatPlateEffect.gameObject:SetActive(true)
		curOperatPlateEffect.position = UItabel:GetChild(#plates-1).position
	end 
end

function this.OnClickButtonSlow(go)
	AudioManager.Instance:PlayAudio('btn')
	if rawSpeed > playInterval then
		playInterval = rawSpeed
		FastLabel:GetComponent('UILabel').text = ''
	else
		if playInterval + cutTime  <= 2 then
			playInterval = playInterval + cutTime
		end
	end
	local num = math.abs(rawSpeed - playInterval)/cutTime
	if num > 0 then
		SlowLabel:GetComponent('UILabel').text = 'x'..num
	else
		SlowLabel:GetComponent('UILabel').text = ''
	end
	print('OnClickButtonSlow playInterval:'..playInterval)
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
	if playInterval > rawSpeed then
		playInterval = rawSpeed
		SlowLabel:GetComponent('UILabel').text = ''
	else
		if playInterval - cutTime >= 1 then
			playInterval = playInterval - cutTime
		end
	end
	
	local num = math.abs(rawSpeed - playInterval)/cutTime
	if num > 0 then
		FastLabel:GetComponent('UILabel').text = 'x'..num
	else
		FastLabel:GetComponent('UILabel').text = ''
	end
	print('OnClickButtonFast playInterval:'..playInterval)
end

function this.OnClickButtonBack(go)
	AudioManager.Instance:PlayAudio('btn')
    coroutine.stop(conFun)
    coroutine.stop(conTime)
	
    PanelManager.Instance:ShowWindow(whoShow.name)
    PanelManager.Instance:HideWindow(gameObject.name)
	Util.ClearChild(operation_receive)
	AudioManager.Instance:PlayMusic('MainBG', true)
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
		userData.sendMsgAllowed = roomData.setting.sendMsgAllowed
		userData.isRePlay = true
		if roomData.clubId ~= '0' then
			userData.gameMode = roomData.setting.gameMode
		end
		userData.isShowSomeID = not RoundDetail.isLord
		userData.fee = pData.fee
		PanelManager.Instance:ShowWindow('panelPlayerInfo', userData)
	end
end

function this.SetZhongTuFen(score,seat)
    print('SetZhongTuFen score:'..score..' seat: '..seat)
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