local pdk_pb = require 'pdk_pb'
local phz_pb = require 'phz_pb'
require "Game.GameLogic.pdkLogic"
require 'const'

local passIcon = {}

panelInGame_pdk = {}
local this = panelInGame_pdk
local gameObject
local message

local roomID
local roomTime
local roomRound
local CountDown

local playerName={}
local playerPlateNum={}
local playerIcon={} 
local playerScore={}
local playerMaster={}
local playerSound={}
local playerOffline={}
local playerGridIn={}
local playerGridOut={}
local playerReady={}
local playerLight={}
local playerClock={}
local playerWinIcon={}
local playerPass={}
local playerzi={}
local playerSound={}
local playerPiaoFen={}
local roomSetting
local onClickWidget
local playerNiao={}
local playerTrusteeship={}
local playerOfflineTime={}
local playerOfflineCoroutines={}
local playerAnimation		= {}
local playerEmojiCoroutine = {}
playerEmojiCoroutine[0] = {}
playerEmojiCoroutine[1] = {}
playerEmojiCoroutine[2] = {}
playerEmojiCoroutine[3] = {}

local playerData={}
--local roomData = {}
local mySeat

local ButtonRefresh
local buttonrefresh
local ButtonChat
local ButtonSound
local ButtonInvite
local ButtonCloseRoom
local ButtonExitRoom
local ButtonHelp
local ButtonPlay
local ButtonPass

local conCountDown
local danTip

local lastFindCards={}
local lastFindCategory = 0
local helpNumWhenHaveOneCard = 0

SPADE_THREE = nil
local setting_text

local playerMsg={}
local playerMsgBG={}
local playerEmoji={}
local playerCoroutine = {}
local piaofendlg
local piaofenbtn0
local piaofenbtn1
local piaofenbtn2
local piaofenbtn3
local readybtn
local RecordTiShi--录音提示
playerCoroutine[0] = {}
playerCoroutine[1] = {}
playerCoroutine[2] = {}

local selectCards={}
local connect
function this.GetNetState()
	return connect.IsConnect
end
local connectCor
local bg
local bg1
local bg2
local bg3
local bg4
this.chatTexts = {}
local paimian
this.fanHuiRoomNumber = nil

this.OnRoundStarted = nil
this.needCheckNet=true

local RestTime
local restTime
local RefeshTimeCoroutine
local ishelp = false
-- by jih >>>>>>>>>>>>>>>>>>>>>>>
local batteryLevel
local network
local pingLabel
local lastime
local GvoiceCor
local refreshStateCoroutine
local panelShare
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

local IsAutoDissolve = false
local AutoDissolveData

local TrusteeshipPanel
local TrusteeshipTip
local CancelTrusteeshipBtn
local TrusteeshipCoroutine

local PlayNiaoView
local NotNiao
local PlayNiao

local layout

this.myseflDissolveTimes = 0

local GPS = {
	transform=nil,
	distance={},
	playerGPS={},
}

function this.Awake(obj)
	gameObject = obj;
    this.gameObject = obj
	message = gameObject:GetComponent('LuaBehaviour');
	RestTime = gameObject.transform:Find("RestTime")
	roomID = gameObject.transform:Find('topbg/room/ID');
	roomTime = gameObject.transform:Find('time');
	roomRound = gameObject.transform:Find('topbg/round/num');
	CountDown = gameObject.transform:Find('CountDown');
	roomSetting = gameObject.transform:Find('setting')
	onClickWidget = gameObject.transform:Find('OnClick')
	for i=0,2 do
		playerName[i] = gameObject.transform:Find('player'..i..'/info/name');
		playerPlateNum[i] = gameObject.transform:Find('player'..i..'/card/num');
		playerIcon[i] = gameObject.transform:Find('player'..i..'/info/Texture'..i);
		playerScore[i] = gameObject.transform:Find('player'..i..'/info/score');
		playerMaster[i] = gameObject.transform:Find('player'..i..'/info/master');
		playerSound[i] = gameObject.transform:Find('player'..i..'/info/sound');
		playerOffline[i] = gameObject.transform:Find('player'..i..'/info/offline');
		playerGridIn[i] = gameObject.transform:Find('player'..i..'/GridIn');
		playerGridOut[i] = gameObject.transform:Find('player'..i..'/GridOut');
		playerReady[i] = gameObject.transform:Find('player'..i..'/info/ready');
		playerLight[i] = gameObject.transform:Find('player'..i..'/light');
		playerAnimation[i] = gameObject.transform:Find('teshubiaoqing/'..i);
		if i == 0 then
			playerClock[i] = gameObject.transform:Find('Clock');
		else
			playerClock[i] = gameObject.transform:Find('player'..i..'/Clock');
		end
		playerWinIcon[i] = gameObject.transform:Find('player'..i..'/winIcon');
		playerMsg[i] = gameObject.transform:Find('player'..i..'/info/Msg');
		playerMsgBG[i] = gameObject.transform:Find('player'..i..'/info/Msg/MsgBG');
		playerEmoji[i] = gameObject.transform:Find('player'..i..'/info/Emoji');
		playerPass[i] = gameObject.transform:Find('player'..i..'/pass')
		playerzi[i] = gameObject.transform:Find('player'..i..'/texiaozi')
		--playerSound[i] = gameObject.transform:Find('player'..i..'/sound')
		playerPiaoFen[i] = gameObject.transform:Find('player'..i..'/info/piaofen')
		playerNiao[i] = gameObject.transform:Find('player'..i..'/info/Niao')
		playerTrusteeship[i] = gameObject.transform:Find('player'..i..'/info/trusteeship')
		playerOfflineTime[i] = gameObject.transform:Find('player'..i..'/info/offlineTime')
		message:AddClick(playerIcon[i].gameObject, this.OnClickPlayerIcon);
	end
	paimian = gameObject.transform:Find('player0/paimian');
	RecordTiShi = gameObject.transform:Find('RecordTiShi');
	ButtonRefresh = gameObject.transform:Find('topbg/btn/ButtonRefresh');
	ButtonChat = gameObject.transform:Find('ButtonChat');
	ButtonSound = gameObject.transform:Find('ButtonSound');
	ButtonInvite = gameObject.transform:Find('bottomButtons/ButtonInvite');
	ButtonHelp = gameObject.transform:Find('CountDown/ButtonHelp');
	ButtonPlay = gameObject.transform:Find('CountDown/ButtonPlay');
	ButtonPass = gameObject.transform:Find('CountDown/ButtonPass');
	ButtonCloseRoom = gameObject.transform:Find('bottomButtons/ButtonCloseRoom')
	ButtonExitRoom = gameObject.transform:Find('bottomButtons/ButtonExitRoom')
	danTip = gameObject.transform:Find('dantipbaba/danTip')
	piaofendlg = gameObject.transform:Find('piaofendlg');
	piaofenbtn0 = gameObject.transform:Find('piaofendlg/0');
	piaofenbtn1 = gameObject.transform:Find('piaofendlg/1');
	piaofenbtn2 = gameObject.transform:Find('piaofendlg/2');
	piaofenbtn3 = gameObject.transform:Find('piaofendlg/3');
	readybtn = gameObject.transform:Find("readybtn")
	bg = gameObject.transform:Find("bg")
	bg1 = gameObject.transform:Find("bg1")
	bg2 = gameObject.transform:Find("bg2")
	bg3 = gameObject.transform:Find("bg3")
	bg4 = gameObject.transform:Find("bg4")
	this.changeBG(UnityEngine.PlayerPrefs.GetInt('ground_pdk', 1))
	message:AddClick(ButtonRefresh.gameObject, this.OnClickButtonRefresh)
	message:AddClick(ButtonChat.gameObject, this.OnClickButtonChat);
	message:AddPress(ButtonSound.gameObject, this.OnPressButtonSound);
	message:AddClick(ButtonInvite.gameObject, this.ShowPanelShare)
	message:AddClick(ButtonCloseRoom.gameObject, this.OnClicButtonCloseRoom)
	message:AddClick(ButtonExitRoom.gameObject, this.OnClicButtonLeaveRoom)
	message:AddClick(ButtonHelp.gameObject, this.OnClickButtonHelp);
	message:AddClick(ButtonPlay.gameObject, this.OnClickButtonPlay);
	message:AddClick(ButtonPass.gameObject, this.OnClickOnButtonPass);
	message:AddClick(onClickWidget.gameObject, this.OnClickWidget);
	message:AddClick(piaofenbtn0.gameObject, this.OnClickPiaoFen);
	message:AddClick(piaofenbtn1.gameObject, this.OnClickPiaoFen);
	message:AddClick(piaofenbtn2.gameObject, this.OnClickPiaoFen);
	message:AddClick(piaofenbtn3.gameObject, this.OnClickPiaoFen);
	message:AddClick(readybtn.gameObject, this.OnClickReady);
	message:AddClick(gameObject.transform:Find('topbg/btn/ButtonSetting').gameObject, this.OnClickButtonSetting)
	panelShare = gameObject.transform:Find('panelShare');
    message:AddClick(panelShare:Find('xianLiao').gameObject, this.OnClickButtonXLInvite)
    message:AddClick(panelShare:Find('friendGroup').gameObject, this.OnClickButtonInvite)
    message:AddClick(panelShare:Find('copy').gameObject, this.OnClicButtonCopy)
    message:AddClick(panelShare:Find('ButtonClose').gameObject, this.ClosePanelShare)
	message:AddClick(panelShare:Find('mask').gameObject, this.ClosePanelShare)
	
	this.Init()
end

function this.Init()

	TrusteeshipTip = gameObject.transform:Find('TrusteeshipTip')
	TrusteeshipPanel = gameObject.transform:Find('TrusteeshipPanel')
	CancelTrusteeshipBtn = TrusteeshipPanel.transform:Find('CancelTrusteeshipBtn')

	PlayNiaoView = gameObject.transform:Find('PlayNiaoView')
    PlayNiao = PlayNiaoView.transform:Find('PlayNiao')
    NotNiao = PlayNiaoView.transform:Find('NotNiao')

	message:AddClick(CancelTrusteeshipBtn.gameObject, this.OnClickCancelTrustesship)
	message:AddClick(PlayNiao.gameObject, this.OnClickPlayNiao)
	message:AddClick(NotNiao.gameObject, this.OnClickPlayNiao)

	batteryLevel = gameObject.transform:Find('battery/level'):GetComponent('UISprite')
	network = gameObject.transform:Find('network'):GetComponent('UISprite')
	pingLabel = gameObject.transform:Find('ping'):GetComponent('UILabel')
	RegisterGameCallBack(pdk_pb.PONG, this.OnPong)
	message:AddPress(network.gameObject, function (go, state)
		pingLabel.gameObject:SetActive(state)
	end)
	--生成card
	local inCardItem = gameObject.transform:Find('inCardItem').gameObject
	local depth = 5
	for i = 0, 15 do
		local obj = NGUITools.AddChild(playerGridIn[0].gameObject,inCardItem.gameObject)
		this.SetCardDepth(obj,depth+i*3)
	end
	for j=0,playerGridIn[0].childCount-1 do
		message:AddClick(playerGridIn[0]:GetChild(j).gameObject, this.OnClickCard);
		--message:AddEventTrigger(playerGridIn[i]:GetChild(j).gameObject, this.OnMousePressHoverCard);
	end
	local outCardItem = gameObject.transform:Find('outCardItem').gameObject
	for i = 0, 2 do
		for j = 0, 15 do
			local obj = NGUITools.AddChild(playerGridOut[i].gameObject,outCardItem.gameObject)
			this.SetCardDepth(obj,depth+j*3)
		end
	end
	
	--宽屏手机自适应
	layout=gameObject.transform:Find('layout')
	if isShapedScreen  then
		local widget = layout:Find('left'):GetComponent('UIWidget')
		widget.rightAnchor.absolute = ipxLiuHai

		widget = layout:Find('right'):GetComponent('UIWidget')
		widget.leftAnchor.absolute = -ipxLiuHai

		widget = playerName[0].parent:GetComponent('UIWidget')
		widget.bottomAnchor.absolute = 0

		widget = ButtonChat:GetComponent('UIWidget')
		widget.bottomAnchor.absolute = 35

		widget = ButtonSound:GetComponent('UIWidget')
		widget.bottomAnchor.absolute = 77

		playerGridOut[0].localPosition = Vector3(659, 340, 0)
	end
	this.changePaiMianSize(UnityEngine.PlayerPrefs.GetInt("pdkpaiMianSize", 1))

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
end

function this.changePaiMianSize(pdkpaiMianSize)
	local proportion=0.9
	local offsetScale=FitScale*FitOffset/UnityEngine.Screen.width
	if isShapedScreen then
		CountDown.localPosition = pdkpaiMianSize==1 and Vector3(0, 20, 0) or Vector3(0, -11, 0)
		playerClock[0].localPosition = pdkpaiMianSize==1 and Vector3(-1, 30, 0) or Vector3(-1, -1, 0)
		playerGridIn[0].localScale=Vector3(FitScale-offsetScale,FitScale-offsetScale,1)*(pdkpaiMianSize==1 and 1 or proportion)
		local widget = playerGridIn[0]:GetComponent('UIWidget')
		widget.bottomAnchor.absolute = pdkpaiMianSize==1 and 179 or 148
		widget.leftAnchor.absolute = pdkpaiMianSize==1 and 60 or 60
		paimian.localScale=Vector3(FitScale-offsetScale,FitScale-offsetScale,1)*(pdkpaiMianSize==1 and 1 or proportion)
		widget = paimian:GetComponent('UIWidget')
		widget.bottomAnchor.absolute = pdkpaiMianSize==1 and 179 or 148
	else
		CountDown.localPosition = pdkpaiMianSize==1 and Vector3(0, -8, 0) or Vector3(0, -36, 0)
		playerClock[0].localPosition = pdkpaiMianSize==1 and Vector3(-1, -6, 0) or Vector3(-1, -34, 0)
		playerGridIn[0].localScale=Vector3(1,1,1)*(pdkpaiMianSize==1 and 1 or proportion)
		local widget = playerGridIn[0]:GetComponent('UIWidget')
		widget.bottomAnchor.absolute = pdkpaiMianSize==1 and 138 or 110
		widget.leftAnchor.absolute = pdkpaiMianSize==1 and 44 or 44
		paimian.localScale=Vector3(1,1,1)*(pdkpaiMianSize==1 and 1 or proportion)
		widget = paimian:GetComponent('UIWidget')
		widget.bottomAnchor.absolute = pdkpaiMianSize==1 and 138 or 110
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
function this.OnClickButtonRefresh(GO)
	AudioManager.Instance:PlayAudio('btn')
	PanelManager.Instance:RestartGame()
	-- panelMessageTip.SetParamers("游戏数据刷新成功！", 2)
	-- PanelManager.Instance:ShowWindow('panelMessageTip')
    -- Util.ClearChild(playerGridHand)
    -- RefreshMyGridHand(playerGridHand, this.GetPlayerDataBySeat(mySeat).hands)
end

function this.changeBG(ground)
	if ground == 1 then
		bg:GetComponent('UITexture').mainTexture = bg1:GetComponent('UITexture').mainTexture
	elseif ground == 2 then
		bg:GetComponent('UITexture').mainTexture = bg2:GetComponent('UITexture').mainTexture
	elseif ground == 3 then
		bg:GetComponent('UITexture').mainTexture = bg3:GetComponent('UITexture').mainTexture
	elseif ground == 4 then
		bg:GetComponent('UITexture').mainTexture = bg4:GetComponent('UITexture').mainTexture
	end
end

function this.OnClickButtonSetting(go)
	AudioManager.Instance:PlayAudio('btn')
	print("roomData.setting.size",roomData.setting.size,"#playerData",#playerData)
	local  isallready = true
	print("#playerData",#playerData)
	for i=0,#playerData do
		print("是否准备",playerData[i].ready)
		if playerData[i].ready == false then
			isallready = false
			break;
		end
	end
	if roomData.round > 1 or isallready  then
		PanelManager.Instance:ShowWindow('panelGameSetting_pdk', true)
		print("游戏中申请解散房间33333333333333333")
	else
		if mySeat == 0 then
			PanelManager.Instance:ShowWindow('panelGameSetting_pdk', false)
			print("游戏未开始房主解散房间33333333333333333")
		else
			PanelManager.Instance:ShowWindow('panelGameSetting_pdk', false)
			print("游戏未开始玩家离开房间33333333333333333")
		end
	end
end

local fisrtclick = true 
local startpos = nil
function this.Update()
	if this.GetPlayerDataBySeat(mySeat) ~= nil and this.GetPlayerDataBySeat(mySeat).trusteeship then
		return 
	end

	if UnityEngine.Input.GetMouseButton(0) then
		if fisrtclick then
			startpos = UnityEngine.Input.mousePosition
		end
		fisrtclick = false
	end
	if UnityEngine.Input.GetMouseButtonUp(0) then
		fisrtclick = true
		--print("UnityEngine.Input.mousePosition",UnityEngine.Input.mousePosition.x,UnityEngine.Input.mousePosition.y)
		local huapai = {}
		if startpos~=nil then
			if math.abs(startpos.x-UnityEngine.Input.mousePosition.x ) > 10 then
				--print("有滑动痕迹开始检测")
				for j=0,playerGridIn[0].childCount-1 do
					local obj = playerGridIn[0]:GetChild(j).gameObject
					local  minX 
					local  maxX
					if UnityEngine.Input.mousePosition.x > startpos.x then
						minX = startpos.x
						maxX = UnityEngine.Input.mousePosition.x --+ 60 * UnityEngine.Screen.width / 1334
					else
						minX = UnityEngine.Input.mousePosition.x --- 60 * UnityEngine.Screen.width / 1334
						maxX = startpos.x
					end
					if obj.activeSelf and this.between(minX,maxX,UnityEngine.Input.mousePosition.y,obj) then
						--this.OnClickCard(obj, false)
						table.insert(huapai, GetUserData(obj.gameObject))
					end
				end
			end
		end
		--print("#huapai",#huapai)
		if #huapai > 5 then
			local shunzi = this.FindMaxShun(huapai)
			--print("#shunzi",#shunzi)
			-- for b = 1, #shunzi do
			-- 	print("shunzi",GetPlateNum(shunzi[b]))
			-- end
			local cs = {}
			for i = 1, #huapai do
				cs[i] = huapai[i]
			end
			table.sort(cs, tableSortDesc)
			local cardGroups = GetCardsGroup(cs)
			local group3 = GetGroupByID(3, cardGroups)
			local isfeiji = true
			if #group3 > 1 then
			   if	GroupInOrderForSanDai1(group3) then
			   else
					isfeiji = false
			   end
			else
				isfeiji = false
			end
			local iswulianshun = true
			for g = 1, #shunzi do
				local num = 0
				for j=0,playerGridIn[0].childCount-1 do
					local item = playerGridIn[0].transform:GetChild(j)
					if item.gameObject.activeSelf then
						if GetPlateNum(shunzi[g]) == GetPlateNum(GetUserData(item.gameObject)) then
							--this.OnClickCard(item.gameObject, false)
							num = num + 1
						end
					end
				end
				if num < 2  then
					iswulianshun = false
					break
				end
			end
			if #shunzi > 0 and iswulianshun == false and isfeiji == false then
				for i = 1, #shunzi do
					for j=0,playerGridIn[0].childCount-1 do
						local item = playerGridIn[0].transform:GetChild(j)
						if item.gameObject.activeSelf then
							if shunzi[i] == GetUserData(item.gameObject) then
								this.OnClickCard(item.gameObject, false)
								--AudioManager.Instance:PlayAudio('click_poker')
							end
						end
					end
				end
			else
				for i = 1, #huapai do
					for j=0,playerGridIn[0].childCount-1 do
						local item = playerGridIn[0].transform:GetChild(j)
						if item.gameObject.activeSelf then
							if huapai[i] == GetUserData(item.gameObject) then
								this.OnClickCard(item.gameObject, false)
								--AudioManager.Instance:PlayAudio('click_poker')
							end
						end
					end
				end
			end
		else
			for i = 1, #huapai do
				for j=0,playerGridIn[0].childCount-1 do
					local item = playerGridIn[0].transform:GetChild(j)
					if item.gameObject.activeSelf then
						if huapai[i] == GetUserData(item.gameObject) then
							this.OnClickCard(item.gameObject, false)
							--AudioManager.Instance:PlayAudio('click_poker')
						end
					end
				end
			end
		end
		if #huapai > 0 then
			AudioManager.Instance:PlayAudio('click_poker')
		end
	end	
end
function this.between(minX,maxX,miny,obj)
	local  lefx_x = UICamera.mainCamera:WorldToScreenPoint(obj.transform.position).x - 134* UnityEngine.Screen.width / 1334;
	local  lefx_y = UICamera.mainCamera:WorldToScreenPoint(obj.transform.position).y + 126 * UnityEngine.Screen.width / 1334;
	if minX >  lefx_x and minX - lefx_x < (75* UnityEngine.Screen.width / 1334) and lefx_y >= miny then
		return true
	else
		if (lefx_x >= minX and lefx_x <= maxX) and lefx_y >= miny then
			return true;
		end
		return false;
	end
end
function this.OnClickReady(go)
	local msg = Message.New()
	msg.type = pdk_pb.READY
	SendGameMessage(msg, nil)
	go.gameObject:SetActive(false)
end

function this.Start()
	coroutine.start(RefreshTime, roomTime:GetComponent('UILabel'), 60)
	if refreshStateCoroutine then
		coroutine.stop(refreshStateCoroutine)
	end
	refreshStateCoroutine = coroutine.start(this.RefreshState)
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
function this.RegisterGameCallBack()
	ClearGameCallBack()
    RegisterGameCallBack(pdk_pb.PLAYER_ENTER, this.OnPlayerEnter)
	RegisterGameCallBack(pdk_pb.PLAYER_JOIN, this.OnPlayerJion)
	RegisterGameCallBack(pdk_pb.LEAVE_ROOM, this.OnLeaveRoom)
	RegisterGameCallBack(pdk_pb.PLAYER_LEAVE, this.OnPlayerLeave)
	RegisterGameCallBack(pdk_pb.ROUND_START, this.OnRoundStart)
    RegisterGameCallBack(pdk_pb.LORD_DISSOLVE, this.OnLordDissolve)
	RegisterGameCallBack(pdk_pb.ROUND_END, this.OnRoundEnd)
	RegisterGameCallBack(pdk_pb.READY, this.OnReady)
	RegisterGameCallBack(pdk_pb.PLAY, this.OnPlayerPlay)
	RegisterGameCallBack(pdk_pb.PLAY_ERROR,this.OnPlayError)
	RegisterGameCallBack(pdk_pb.PASS, this.OnPlayerPass)
	RegisterGameCallBack(pdk_pb.OVER, this.OnOver)
	RegisterGameCallBack(pdk_pb.DISSOLVE_APPLY, this.OnDissolveApply)
	RegisterGameCallBack(pdk_pb.DISSOLVE_ACCEPT, this.OnDissolveAccept)
	RegisterGameCallBack(pdk_pb.DISSOLVE_REJECT, this.OnDissolveReject)
	RegisterGameCallBack(pdk_pb.DESTROY, this.Destroy)
	RegisterGameCallBack(pdk_pb.DISSOLVE, this.Dissolve)
	RegisterGameCallBack(pdk_pb.SEND_CHAT, this.OnSendChat)
	RegisterGameCallBack(pdk_pb.DISCONNECTED, this.OnDisconnected)
	RegisterGameCallBack(pdk_pb.VOICE_MEMBER, this.OnVoiceMember)
	RegisterGameCallBack(pdk_pb.ENABLE_FLOAT_SCORE, this.OnPiaoFen)
	RegisterGameCallBack(pdk_pb.PUBLICITY_FLOAT_SCORE, this.OnShowPiaoFen)
	RegisterGameCallBack(pdk_pb.HAND_CARD, this.OnFangHeShou)
	RegisterGameCallBack(pdk_pb.NO_ROOM, this.OnRoomNoExist)
	RegisterGameCallBack(pdk_pb.ENTER_ERROR, this.OnRoomError)

	RegisterGameCallBack(pdk_pb.AUTO_DISSOLVE, this.OnAutoDissolve)
	RegisterGameCallBack(pdk_pb.TRUSTEESHIP, this.OnTrustesship)
	RegisterGameCallBack(pdk_pb.ENABLE_HIT_BIRD, this.OnEnablePlayNiao) --启动打鸟
	RegisterGameCallBack(pdk_pb.HIT_BIRD, this.OnPlayerChooseNiao)

	RegisterGameCallBack(pdk_pb.ERROR_INFO, this.OnGameError)
	RegisterGameCallBack(pdk_pb.GIFT,this.OnPlayerEmoji)

	RegisterGameCallBack(pdk_pb.OVERTIME_DISSOLVE,this.OnOverTimeDissolve)
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
            data.name = 'panelInGame_pdk'
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
function this.OnRoomNoExist(msg)
    panelMessageTip.SetParamers('房间已解散', 2)
    PanelManager.Instance:ShowWindow('panelMessageTip')
    coroutine.start(
    function()
		coroutine.wait(2)
		panelLogin.HideGameNetWaitting();
        if roomData.clubId ~= '0' then
            local data = {}
            data.name = 'panelInGame_pdk'
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
function this.OnFangHeShou(msg)
	print("防合手推牌")
	local p = pdk_pb.RCards()
	p:ParseFromString(msg.body)
	print('before remove num is '..#playerData[p.seat].cards)
	while(#playerData[p.seat].cards > 0) do
		playerData[p.seat].cards:remove(#playerData[p.seat].cards)
	end
	print('after remove num is '..#playerData[p.seat].cards)
	
	for i=1,#p.cards do
		playerData[p.seat].cards:append(p.cards[i])
	end
	print('after add num is '..#playerData[p.seat].cards)
	
	-- for i=#roomData.latestHand.cards,1,-1 do
	-- 	roomData.latestHand.cards:remove(i)
	-- end
    this.RefreshMyGridIn()
end
function this.OnPiaoFen()
	print("启动飘分111111111111111")
	piaofendlg.gameObject:SetActive(true)
	this.SetInviteVisiable(false)
	GPS.transform.gameObject:SetActive(false)
end
function this.OnShowPiaoFen(msg)
	print("公示飘分111111111111111")
	local b = pdk_pb.RPublicityFloatScore()
	b:ParseFromString(msg.body)
	local i = this.GetUIIndexBySeat(b.seat)
	--playerPiaoFen[i].gameObject:SetActive(true)
	if b.score == 0 then
		playerPiaoFen[i]:GetComponent('UILabel').text = "不飘分"
	else
		playerPiaoFen[i]:GetComponent('UILabel').text = "飘"..b.score.."分"
	end
	if b.seat == mySeat then
		piaofendlg.gameObject:SetActive(false)
	end
end
function this.OnClickPiaoFen(go)
	print("设置飘分。。。。。。。。")
	local msg = Message.New()
	msg.type = pdk_pb.SET_FLOAT_SCORE
	local body = pdk_pb.PFloatScore()
	if go.name == "0" then
		body.score = 0
	elseif go.name == "1" then
		body.score = 2
	elseif go.name == "2" then
		body.score = 3
	elseif go.name == "3" then
		body.score = 5
	end
	msg.body = body:SerializeToString();
	SendGameMessage(msg, this.OnPiaoFenCallBack)
	piaofendlg.gameObject:SetActive(false)
end
function this.OnPiaoFenCallBack(msg)
	print("设置飘分回调。。。。。。。。")
end
function this.OnEnable()
	--PanelManager.Instance:ShowWindow('panelNetWaitting')
	selectCards = {}
    PanelManager.Instance:HideWindow('panelLobby')
    PanelManager.Instance:HideWindow('panelClub')
	panelInGame = panelInGame_pdk
    panelInGame.needXiPai=false
	
    isIngame = true
	if panelClub then
		panelClub.isInClub=false
	end
	
	
	this.RegisterGameCallBack()
	if conMarquee then
		coroutine.stop(conMarquee)
	end
	connect = NetWorkManager.Instance:CreateConnect('game');
    connect.IP = GetServerIPorTag(false, roomInfo.host)
    connect.Port = roomInfo.port
	connect.GroupName = ConfigManager.getProperty('ProxyServer', 'GroupName', '');
    connect.onConnectLua = this.OnConnect
    connect.disConnectLua = this.OnDisconnect
    connect.rspCallBackLua = receiveGameMessage;
	connect.reConnectNum = ConfigManager.getIntProperty('Setting', 'ReconnectNum', 5)
    connect:Connect();
	
	-- local msg = Message.New()
	-- msg.type = proxy_pb.PING
	-- connect.heartBeatMsg = msg
	connect.heartBeatInterval = 5;
	
	this.StartCheckNetState()
	for i = 0, 2 do
		playerTrusteeship[i].gameObject:SetActive(false)
	end
	AudioManager.Instance:PlayMusic('bgm', true)
	this.ClearRoom()
	if panelChat then
        panelChat.ClearChat()
	end
	
	this.RestView()
end

function this.RestView()
	IsAutoDissolve = false

	TrusteeshipTip.gameObject:SetActive(false)
	TrusteeshipPanel.gameObject:SetActive(false)
	PlayNiaoView.gameObject:SetActive(false)
end

function this.OnConnect()
	this.JionRoom()
end

function this.OnDisconnect()
	connect.IP = GetServerIPorTag(false,roomInfo.host)
	connect.Port = roomInfo.port
    print('网络连接断开。。。。。。。。。。。')
end

function this.CheckNetState()
	print('panelInGame.CheckNetState')
	coroutine.wait(1)
	--connect.reConnectNum = ConfigManager.getIntProperty('Setting', 'ReconnectNum', 5)
	while gameObject.activeSelf and this.needCheckNet==true do
		if connect.IsReConnect then
			print("进入重连状态..................................")
			PanelManager.Instance:ShowWindow('panelGameNetWaitting')
			--coroutine.wait(1)
		elseif  not connect.IsConnect then
			print("进入网络断开状态..................................")
			PanelManager.Instance:HideWindow('panelGameNetWaitting')
			panelLogin.HideAllNetWaitting()
			panelMessageBoxTiShi.SetParamers(OK_CANCLE, this.OnNetCheckButtonOK, this.OnNetCheckButtonCancle, '网络连接失败，是否继续连接？')
			PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
			break
		elseif connect.IsConnect then
			--print("进入重连成功 状态..................................")
			PanelManager.Instance:HideWindow('panelGameNetWaitting')
			--coroutine.wait(1)
		-- else
		-- 	coroutine.wait(1)
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

function this.JionRoom()
	local msg 		= Message.New()
	msg.type 		= pdk_pb.JOIN_ROOM
	local body 		= pdk_pb.PJoinRoom();
	body.roomNumber = roomInfo.roomNumber
	body.token 		= roomInfo.token

	body.longitude 	= tonumber(UnityEngine.PlayerPrefs.GetFloat("longitude",0));
    body.latitude 	= tonumber(UnityEngine.PlayerPrefs.GetFloat("latitude",0));
	body.address 	= UnityEngine.PlayerPrefs.GetString("address","");
	
	msg.body = body:SerializeToString();
	SendGameMessage(msg, this.OnJionRoomResult)
end
local  PDKspeed = 0.6
function this.OnJionRoomResult(msg)
    panelInGame.needXiPai=false
	panelLogin.HideNetWaitting()
	this.fanHuiRoomNumber = roomInfo.roomNumber
	paimian.gameObject:SetActive(false)
	piaofendlg.gameObject:SetActive(false)
	local body = pdk_pb.RJoinRoom()
	body:ParseFromString(msg.body)
	roomData = body.room
	mySeat = body.seat
	SPADE_THREE = roomData.firstCard
	playerData={}
	for i=1,#body.room.players do
		local p = body.room.players[i]
		playerData[p.seat] = p
		print('aaaaaaaaaaaaaaaaaaa')
	end
    roomID:GetComponent('UILabel').text = roomInfo.roomNumber
	this.OnPlayerHand(nil, nil)
	if roomData.state ~= 2 then   --等于2 为 游戏中
		roomData.banker = 100
		roomData.activeSeat = 100
	else
		if #roomData.latestHand.cards > 0 then
			this.OnPlayerHand(roomData.latestSeat, roomData.latestHand)
		end
	end
	if roomData.state == 2 then
		this.SetInviteVisiable(false)
	else
		if roomData.round > 1 then
			this.SetInviteVisiable(false)
		else
			this.SetInviteVisiable(#playerData ~= (roomData.setting.size - 1) or (not playerData[mySeat].ready) or not this.IsAllReaded())
		end
	end
	DestroyRoomData.roomData = roomData
	DestroyRoomData.playerData = playerData
	DestroyRoomData.mySeat = mySeat
	
	this.myseflDissolveTimes = 0

	if roomData.dissolution.remainMs > 0 then
		roomData.dissolution.remainMs = getIntPart(roomData.dissolution.remainMs/1000)
		this.SetDestoryPanelShow()
	else
		PanelManager.Instance:HideWindow('panelDestroyRoom')
	end

	if roomData.state == 1 and roomData.clubId ~= "0" and roomData.round == 1  then
        restTime = roomData.time/1000 -- 600 - os.time() + body.room.time
        print('时间：'..roomData.time) 
        RestTime:Find("Time"):GetComponent('UILabel').text = os.date("%M:%S", restTime)
        RestTime.gameObject:SetActive(true)
        if RefeshTimeCoroutine == nil then
            RefeshTimeCoroutine = coroutine.start(this.RefreshTime, RestTime:Find("Time"):GetComponent('UILabel'))
        end
    else
        RestTime.gameObject:SetActive(false)
    end

	this.SetRoundNum(roomData.round);
	local setting_str = getWanFaText_pdk(roomData.setting,false,false,false,false);
	roomSetting:GetComponent('UILabel').text = setting_str;
	roomSetting:GetChild(0):GetComponent('UILabel').text = setting_str;
	gameObject.transform:Find('dsz'):GetComponent('UILabel').text = roomData.playName--roomData.setting.cardCount.."张跑得快"
	gameObject.transform:Find('dsz'):GetChild(0):GetComponent('UILabel').text = roomData.playName--roomData.setting.cardCount.."张跑得快"

    for i=0,2 do
        if roomData.setting.showCount and i ~= 0 then
            playerPlateNum[i].parent.gameObject:SetActive(true)
        else
            playerPlateNum[i].parent.gameObject:SetActive(false)
        end 
		
		if roomData.setting.size == 2 and i == 2 then
			playerName[i].parent.parent.gameObject:SetActive(false)
		else
			playerName[i].parent.parent.gameObject:SetActive(true)
		end
	end

	ButtonExitRoom.parent:GetComponent("UIGrid"):Reposition()
	this.RefreshMyGridIn()
    this.SetReadyVisiable()
	this.RefreshPlayer()
	lastFindCards = {}
	selectCards = {}
	helpNumWhenHaveOneCard = 0
	coroutine.start(
		function()
			if #roomData.latestHand.cards > 0 then
				coroutine.wait(0.5)
			end
			this.SetCountDownVisiable(roomData.state == 2, roomData.activeSeat, roomData.trusteeshipRemainMs)
		end
	)
	RoundAllData.over = false
	if Util.GetPlatformStr() ~= 'win' then
		print('开始语音poll！！！！！！！！！！')
		if GvoiceCor then
			StopCoroutine(GvoiceCor)
		end
		GvoiceCor = StartCoroutine(this.TickNGCloudVoice)
		NGCloudVoice.Instance:ApplyMessageKey()
	end
	this.CheckStartPiaoFen()
	if (roomData.setting.size > 2) and roomData.round == 1  then
        local longitude = UnityEngine.PlayerPrefs.GetFloat("longitude",0)
        local latitude = UnityEngine.PlayerPrefs.GetFloat("latitude",0)
        local address = UnityEngine.PlayerPrefs.GetString("address","")
        if (longitude == 0 and latitude == 0) and address=="" then 
            panelMessageBox.SetParamers(ONLY_OK,nil,nil,"未允许游戏获取定位");
            PanelManager.Instance:ShowWindow("panelMessageBox");
        end
	end
	
	if roomData.state == pdk_pb.READYING and roomData.setting.size == 3 then
		local datas = {}
		for i = 0, roomData.setting.size - 1 do
			datas[i] = this.GetPlayerDataByUIIndex(i)
			print('datas[i] :'..tostring(datas[i]))
		end
		GPS.transform.gameObject:SetActive(true)
		SetGPSInfo(GPS,pos3,datas,roomData.setting.size)
	end
end
function this.CheckStartPiaoFen()
	local  isallready = true
	for i=0,#playerData do
		print("是否准备",playerData[i].ready)
		if playerData[i].ready == false then
			isallready = false
			break;
		end
	end
	if roomData.state == 1 and isallready and #roomData.players >= roomData.setting.size then
		if roomData.setting.floatScore and playerData[mySeat].floatScore == -1 then
			print("启动飘分111111111111111")
			piaofendlg.gameObject:SetActive(true)
		elseif roomData.setting.hitBird ~= 0 and playerData[mySeat].hitBird == -1 then
			this.OnEnablePlayNiao()
		end
	end
end
function this.GetPlayerDataByUIIndex(index)
	local i = index + mySeat
	if i > 0 then
		i = i % roomData.setting.size
	end
	return playerData[i]
end

function this.GetUIIndexBySeat(seat)
    return ((#playerData+1)-mySeat+seat)%(#playerData+1)
end

function this.RefreshPlayer()
	for i=0,2 do
		local p = this.GetPlayerDataByUIIndex(i)
		if i <= #playerData and p ~= nil then
			local p = this.GetPlayerDataByUIIndex(i)
			playerName[i]:GetComponent('UILabel').text = p.name
			if roomData.setting.showCount and i ~= 0 then
				playerPlateNum[i].parent.gameObject:SetActive(true)
			else
				playerPlateNum[i].parent.gameObject:SetActive(false)
			end 
			playerPlateNum[i]:GetComponent('UILabel').text = p.cardCount
            coroutine.start(LoadPlayerIcon, playerIcon[i]:GetComponent('UITexture'), p.icon)
			SetUserData(playerIcon[i].gameObject, p)
			playerIcon[i].gameObject:SetActive(true)

			playerScore[i]:GetComponent('UILabel').text = p.score
			
			if roomData.banker == 100 or roomData.banker ~= p.seat then
				playerMaster[i].gameObject:SetActive(false)
			elseif roomData.banker == p.seat then
				playerMaster[i].gameObject:SetActive(true)
			end
			
			if p.cardCount == 1 and p.seat ~= mySeat then
				playerLight[i].gameObject:SetActive(true)
				playerPlateNum[i].parent.gameObject:SetActive(false)
			else
				playerLight[i].gameObject:SetActive(false)
			end
			
			if p.connected then
				playerOffline[i].gameObject:SetActive(false)
			else
				playerOffline[i].gameObject:SetActive(true)
			end
			--playerPiaoFen[i].gameObject:SetActive(true)
			if roomData.setting.floatScore then
				if p.floatScore == -1 then
					playerPiaoFen[i]:GetComponent('UILabel').text = ""
				elseif p.floatScore == 0 then
					playerPiaoFen[i]:GetComponent('UILabel').text = "不飘分"
				else
					playerPiaoFen[i]:GetComponent('UILabel').text = "飘"..p.floatScore.."分"
				end
			else
				playerPiaoFen[i]:GetComponent('UILabel').text = ""
			end

			playerNiao[i].gameObject:SetActive(p.hitBird == 1)
			playerTrusteeship[i].gameObject:SetActive(p.trusteeship)
			playerOfflineTime[i].gameObject:SetActive(not p.connected)
			if not p.connected and p.disconnectTimes ~= 0 then
				this.StartOfflineIncrease(p.seat, p.disconnectTimes)
			end

			this.SetMyseflInTrustesship(p.seat, p.trusteeship)
		else
			playerName[i]:GetComponent('UILabel').text = ''
			playerPlateNum[i]:GetComponent('UILabel').text = '0'
			playerIcon[i].gameObject:SetActive(true)
			playerIcon[i]:GetComponent('UITexture').mainTexture = nil
			playerScore[i]:GetComponent('UILabel').text = '0'
			playerGridIn[i].gameObject:SetActive(false)
			playerGridOut[i].gameObject:SetActive(false)
			playerMaster[i].gameObject:SetActive(false)
			playerLight[i].gameObject:SetActive(false)
			playerOffline[i].gameObject:SetActive(false)
			playerPiaoFen[i]:GetComponent('UILabel').text = ""
			playerNiao[i].gameObject:SetActive(false)
			playerTrusteeship[i].gameObject:SetActive(false)
			playerOfflineTime[i].gameObject:SetActive(false)
			--playerPiaoFen[i].gameObject:SetActive(false)
			SetUserData(playerIcon[i].gameObject, nil)
		end
		
		playerWinIcon[i].gameObject:SetActive(false)
		playerSound[i].gameObject:SetActive(false)
	end
	--ButtonSound.gameObject:SetActive(#playerData>1)
end

function this.OnPlayerHand(seat, hand)--显示其他玩家出的牌
	print('OnPlayerHand')
    for i=0,#playerGridOut do
        playerGridOut[i].gameObject:SetActive(false)
    end

    if (not seat) or (not hand) then
        return
    end

    local index = this.GetUIIndexBySeat(seat)
    playerGridOut[index].gameObject:SetActive(true)
	RefreshGrid(playerGridOut[index], hand.cards)
    
    if hand.category == DAN then
    elseif hand.category == DUI then
    elseif hand.category == SAN then
    elseif hand.category == SAN_YI then
    elseif hand.category == SAN_ER then
    elseif hand.category == SHUN then
    elseif hand.category == LIAN_DUI then
    elseif hand.category == SAN_SHUN then
    elseif hand.category == FEI_YI then
    elseif hand.category == FEI_ER then
	elseif hand.category == ZHA_DA then
		print("hand.category",hand.category)
        --print('unkown category;{0}', hand.category)
    end
end

function this.OnPlayerEnter(msg)
	print('OnPlayerEnter')
	local b = pdk_pb.RPlayer()
	b:ParseFromString(msg.body)

	playerData[b.seat]=b
    local i = this.GetUIIndexBySeat(b.seat)
	b.connected = true
	playerOffline[i].gameObject:SetActive(true)
    playerReady[i].gameObject:SetActive(false)
	playerData[b.seat].ready = false
    
    this.RefreshPlayer()
	--this.SetInviteVisiable(#playerData ~= roomData.setting.size-1)
	--this.CheckStartPiaoFen()
end

function this.OnPlayerJion(msg)
	print('OnPlayerJion玩家进来了')
	local b = pdk_pb.RPlayerJoin()
	b:ParseFromString(msg.body)

	playerData[b.seat].connected = true
	playerData[b.seat].ip = b.ip
	playerData[b.seat].ready = b.ready
	playerData[b.seat].disconnectTimes = 0
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
	print("这个玩家的经纬度位置为 ",b.longitude,b.latitude,b.address)
    print('OnPlayerJion座位号' .. b.seat)
    --print('OnPlayerJion地址' .. b.address)
    local i = this.GetUIIndexBySeat(b.seat)
	playerOffline[i].gameObject:SetActive(false)
	if roomData.state == 2 then
		playerReady[i].gameObject:SetActive(false)
	else
		playerReady[i].gameObject:SetActive(b.ready)
	end
	if roomData.state == pdk_pb.READYING and roomData.setting.size == 3 then
		local datas = {}
		for i = 0, roomData.setting.size - 1 do
			datas[i] = this.GetPlayerDataByUIIndex(i)
		end
		GPS.transform.gameObject:SetActive(true)
		SetGPSInfo(GPS,pos3,datas,roomData.setting.size)
	end
	print('是不是满人了：'..tostring(#playerData ~= roomData.setting.size))
	ButtonInvite.gameObject:SetActive(#playerData ~= roomData.setting.size - 1 and IsAppleReview() == false)
	ButtonInvite.parent:GetComponent("UIGrid"):Reposition()

	this.NotifyGameStart()

	this.StopOfflineIncrease(b.seat)
end

function this.OnLeaveRoom(msg)
	print('OnLeaveRoom')
	--roomData = {}
	NetWorkManager.Instance:DeleteConnect('game');
	PanelManager.Instance:HideWindow('panelDestroyRoom')
	panelLogin.HideGameNetWaitting();
    if roomData.clubId ~= '0' then
        local data = {}
        data.name = 'panelInGame_pdk'
		-- data.clubId = roomData.clubId
        PanelManager.Instance:ShowWindow('panelClub', data)
    else
        PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
	end
	roomData.clubId = '0'
	--roomData = {}
	SPADE_THREE = nil
end

function this.OnPlayerLeave(msg)
	print('OnPlayerLeave')
	local b = pdk_pb.RPlayerLeave()
	b:ParseFromString(msg.body)
	local i = this.GetUIIndexBySeat(b.seat)
	playerReady[i].gameObject:SetActive(false)
    playerData[b.seat] = nil
	this.RefreshPlayer()
	if (roomData.state == pdk_pb.READYING) and roomData.setting.size > 2 then
		local datas = {}
		for i = 0, roomData.setting.size - 1 do
			datas[i] = this.GetPlayerDataByUIIndex(i)
		end
        GPS.transform.gameObject:SetActive(true)
		SetGPSInfo(GPS,roomData.setting.size == 3 and pos3 or pos4,datas,roomData.setting.size)
	end
	ButtonInvite.gameObject:SetActive(#playerData ~= roomData.setting.size -1 and IsAppleReview() == false)
	ButtonInvite.parent:GetComponent("UIGrid"):Reposition()
end

function this.RefreshMyGridIn()
	for i=0,roomData.setting.size -1 do
        local grid = playerGridIn[i]
        local pData = this.GetPlayerDataByUIIndex(i)
        if pData ~= nil and  pData.seat == mySeat then
            grid.gameObject:SetActive(true)
			RefreshGrid(grid, pData.cards)
			--print("roomData.setting.preventJointly",roomData.setting.preventJointly)
			--print("pData.cards",pData.cards)
			if roomData.setting.preventJointly and #pData.cards == 0 and #roomData.latestHand.cards == 0 and roomData.state == 2 then
				if roomData.setting.cardCount == 15  then
					paimian:GetChild(15).gameObject:SetActive(false)
				else
					paimian:GetChild(15).gameObject:SetActive(true)
				end
				paimian.gameObject:SetActive(true)
				paimian:GetComponent('UIGrid'):Reposition()		
			else
				paimian.gameObject:SetActive(false)
			end
        else
            grid.gameObject:SetActive(false)
        end
    end
end

function this.OnRoundStart(msg) --游戏开始
	RestTime.gameObject:SetActive(false)
	GPS.transform.gameObject:SetActive(false)
	if roomData.round == 1 and (not (roomData.setting.size == 2)) then
		local datas = {}
		for i = 0, roomData.setting.size - 1 do
			datas[i] = this.GetPlayerDataByUIIndex(i)
		end
        InspectIPAndGPS(datas,roomData.setting.size == 3 and pos3 or pos4,this.OnClicButtonDisbandRoom)   
    end
	selectCards={}
	local b = pdk_pb.RRoundStart()
	b:ParseFromString(msg.body)
	if panelInGame.needXiPai==true then
		panelInGame.needXiPai=false
		connect.IsZanTing=true
		PanelManager.Instance:ShowWindow('panelXiPai_poker',function()
			this.gameStart(b)
			connect.IsZanTing=false
		end)
	else
		this.gameStart(b)	
	end
end

function this.gameStart(b)
	print('OnRoundStart')
	print("每局的首出牌是",b.firstCard)
	SPADE_THREE = b.firstCard
	for i=1,#b.players do
		local p = b.players[i]
		playerData[p.seat].cardCount = p.cardCount
		playerData[p.seat].floatScore = p.floatScore
		print("p.cardCount666666666",p.cardCount)
		
		print('before remove num is '..#playerData[p.seat].cards)
		while(#playerData[p.seat].cards > 0) do
			playerData[p.seat].cards:remove(#playerData[p.seat].cards)
		end
		print('after remove num is '..#playerData[p.seat].cards)
		
		for i=1,#p.cards do
			playerData[p.seat].cards:append(p.cards[i])
		end
		print('after add num is '..#playerData[p.seat].cards)

		playerData[p.seat].trusteeship = p.trusteeship
		playerData[p.seat].disconnectTimes = p.disconnectTimes
	end
	
	for i=#roomData.latestHand.cards,1,-1 do
		roomData.latestHand.cards:remove(i)
	end

	if roomData.banker == 100 then
		roomData.banker = b.activeSeat
	end
	roomData.state = 2
	this.SetInviteVisiable(false)
    this.RefreshMyGridIn()
	--readybtn.gameObject:SetActive(false)
	
	this.RefreshPlayer()
    this.SetReadyVisiable()
    this.SetRoundNum(roomData.round)
	
	lastFindCards ={}
	helpNumWhenHaveOneCard = 0
    this.SetCountDownVisiable(true, b.activeSeat)
	if roomData.round == 1 then
		AudioManager.Instance:PlayAudio('gamebegin')
	end

	if PanelManager.Instance:IsActive('panelStageClear_pdk') then
		PanelManager.Instance:HideWindow('panelStageClear_pdk')
	end
end

function this.OnClicButtonDisbandRoom(go)
    AudioManager.Instance:PlayAudio('btn')
    local msg = Message.New();
    msg.type = pdk_pb.DISSOLVE_APPLY;
    SendGameMessage(msg, nil);
end
this.hasStageClear=false;
function this.OnRoundEnd(msg)
	print('OnRoundEnd')
	this.hasStageClear=true
	local b = pdk_pb.RRoundEnd()
	b:ParseFromString(msg.body)
	RoundData.data = b
	RoundData.mySeat = mySeat
	RoundData.playerData = playerData
	RoundData.playerIcon = playerIcon
	RoundData.setting = roomData.setting
	RoundData.roomData = roomData
	RoundData.isInGame = true
	coroutine.start(
		function()
			coroutine.wait(0.5)
			for i=1,#b.players do
				local p = b.players[i]
				local index = this.GetUIIndexBySeat(p.seat)
				if p.seat ~= mySeat then
					playerGridOut[index].gameObject:SetActive(true)
					RefreshGrid(playerGridOut[index], p.cards)
				end
				if b.winner == p.seat then
					playerWinIcon[index].gameObject:SetActive(true)
				end
				playerData[p.seat].score = playerData[p.seat].score + p.score
				playerData[p.seat].ready = false
				playerScore[index]:GetComponent('UILabel').text = playerData[p.seat].score
				playerData[p.seat].floatScore = -1
			end
			
			if mySeat == b.winner then
				AudioManager.Instance:PlayAudio('win')
			else
				AudioManager.Instance:PlayAudio('lose')
			end
			local index = this.GetUIIndexBySeat(roomData.latestSeat)
			playerGridOut[index].gameObject:SetActive(true)
			print('num:'..#roomData.latestHand.cards)
			RefreshGrid(playerGridOut[index], roomData.latestHand.cards)
			
			for i=#roomData.latestHand.cards,1,-1 do
				roomData.latestHand.cards:remove(i)
			end
		end
	)

    roomData.state = 1
	roomData.banker = 100
	if roomData.setting.rounds > roomData.round then
		--roomData.round = roomData.round+1
		RoundData.over = false
	else
		RoundData.over = true
	end
	roomData.round = roomData.round+1
	
	print('RoundData.over:'..tostring(RoundData.over))
	this.SetCountDownVisiable(false, mySeat)
	
	coroutine.start(
		function()
			connect.IsZanTing=true
			coroutine.wait(1)

			print('是不是自动解散：'..tostring(IsAutoDissolve))
			PanelManager.Instance:ShowWindow('panelStageClear_pdk',function()
				connect.IsZanTing=false
			end)
		end
	)
end

function this.OnReady(msg)
	print('OnReady')
	local b = pdk_pb.RReady()
	b:ParseFromString(msg.body)
    local ix = this.GetUIIndexBySeat(b.seat)
	playerReady[ix].gameObject:SetActive(true)
	playerData[b.seat].ready = true
	if b.seat == mySeat then
		readybtn.gameObject:SetActive(false)
	end
	for i=0,2 do
		playerGridOut[i].gameObject:SetActive(false)
		playerGridIn[i].gameObject:SetActive(false)
		playerLight[i].gameObject:SetActive(false)
		playerWinIcon[i].gameObject:SetActive(false)
		playerPiaoFen[i]:GetComponent('UILabel').text = ""
	end
	--this.CheckStartPiaoFen()

	this.NotifyGameStart()
end

function this.OnDisconnected(msg)
	print('OnDisconnected')
	local b = pdk_pb.RSeat()
	b:ParseFromString(msg.body)
	local i = this.GetUIIndexBySeat(b.seat)
	playerData[b.seat].connected = false
	playerOffline[i].gameObject:SetActive(true)
	this.StartOfflineIncrease(b.seat, 0);
end

function this.OnPlayerPlay(msg)
	print('OnPlayerPlay')
	print("玩家出牌1111111111111111111111")
	local b = pdk_pb.RPlay()
	b:ParseFromString(msg.body)
	this.OnPlayerHand(b.seat, b.hand)
    
    local pData = playerData[b.seat]
	local i = this.GetUIIndexBySeat(b.seat)
	print("pData.cardCount7777777",pData.cardCount)
	pData.cardCount = pData.cardCount - #b.hand.cards
	if roomData.setting.showCount then
		playerPlateNum[i]:GetComponent('UILabel').text = pData.cardCount
	else
		playerPlateNum[i]:GetComponent('UILabel').text = ''
	end

	if mySeat == pData.seat then
		for ii=1,#b.hand.cards do
			local cardID = b.hand.cards[ii]
			local itemOut = nil
			for j=0,playerGridOut[i].transform.childCount-1 do
				local item = playerGridOut[i].transform:GetChild(j)
				if item.gameObject.activeSelf and GetUserData(item.gameObject) == cardID then
					itemOut = item
					break
				end
			end
			
			local itemIn = nil
			for k=0,playerGridIn[i].transform.childCount-1 do
				local item = playerGridIn[i].transform:GetChild(k)
				if item.gameObject.activeSelf and GetUserData(item.gameObject) == cardID then
					itemIn = item
					break
				end
			end
			
			if itemOut and itemIn then
				--local tw_pos = itemOut:GetComponent('TweenPosition')
				local pos = itemOut.transform.position
				local s_pos = itemIn.transform.position
				itemOut.gameObject:SetActive(false)
				StartCoroutine(function()
					WaitForEndOfFrame()
					WaitForEndOfFrame()
					itemOut.gameObject:SetActive(true)
					itemOut.transform.position =  s_pos
					--local tw_sc = itemOut:GetComponent('TweenScale')
					local f = playerGridIn[i].transform.localScale.x / playerGridOut[i].transform.localScale.x
					itemOut.transform.localScale = Vector3.New(f, f, f)
					TweenScale.Begin(itemOut.gameObject, 0.1, Vector3.one)
					TweenPosition.Begin(itemOut.gameObject, 0.1, pos, true)
				end)
			else
				print('cant find card')
			end
		end
	
	
		for i=1,#b.hand.cards do
			for j=1,#pData.cards do
				if b.hand.cards[i] == pData.cards[j] then
					pData.cards:remove(j)
					break
				end
			end
		end
	
		if #pData.cards ~= pData.cardCount then
			Debugger.Log('player {0} card count error', pData.name)
		end
		StartCoroutine(function()
			WaitForEndOfFrame()
			WaitForEndOfFrame()
			RefreshGrid(playerGridIn[i], pData.cards)
		end)
	end
	
	local nextSeat = (b.seat+1)%roomData.setting.size
    roomData.activeSeat = nextSeat
    roomData.latestSeat = b.seat
    roomData.latestHand.category = b.hand.category
	for i=#roomData.latestHand.cards,1,-1 do
		roomData.latestHand.cards:remove(i)
	end
	for i=1,#b.hand.cards do
		roomData.latestHand.cards:append(b.hand.cards[i])
	end
	
	this.SetPassVisiable(false, b.seat)
	if b.seat == mySeat then
		selectCards={}
	end
	lastFindCards = {}
	helpNumWhenHaveOneCard = 0
	
	if pData.cardCount ~= 0 then
		print("下家改出牌了........................")
		--coroutine.start(
			--function()
				--coroutine.wait(0)
				this.SetCountDownVisiable(true, nextSeat)
			--end
		--)
		 --显示下家出牌按钮 
	end
	
	this.PlayCardSound(b.hand.cards, pData.sex, i, b.hand.category)
	
	if pData.cardCount == 1 and mySeat ~= pData.seat then
		playerLight[i].gameObject:SetActive(true)
		playerPlateNum[i].parent.gameObject:SetActive(false)
		coroutine.start(
			function()
				coroutine.wait(1)
				AudioManager.Instance:PlayAudio(string.format('baodan_%d_1', pData.sex))
			end
		)
	end

	DelayMsgDispatch(connect, 0.3)
end

function this.PlayCardSound(cards, sex,index, category)
	--local cardGroups = GetCardsGroup(cards)
	local soundName = ''
	local spritename=""
	-- for i=4,1,-1 do
	-- 	local group = GetGroupByID(i, cardGroups)
	-- 	if #group > 0 then
	-- 		if i == 4 then
	-- 			if #cards  == 4 then
	-- 				soundName = string.format('bomb_%d', sex)
	-- 				spritename = "zhadan"
	-- 			elseif #cards == 6 then
	-- 				soundName = string.format('sidaier_%d', sex)
	-- 				spritename = "4d2"
	-- 			else
	-- 				local group3 = GetGroupByID(3, cardGroups)
	-- 				if #group3 >= 2 then
	-- 					soundName = string.format('fei_%d', sex)
	-- 					spritename = "feiji"
	-- 				else
	-- 					soundName = string.format('sidaisan_%d', sex)
	-- 					spritename = "4d3"
	-- 				end

	-- 			end
	-- 		elseif i == 3 then
	-- 			if #group == 1 then
	-- 				if #cards == 3 and GetPlateNum(group[1][1]) == 14 and roomData.setting.bombAAA then
	-- 					soundName = string.format('bomb_%d', sex)
	-- 					spritename = "zhadan"
	-- 				else
	-- 					soundName = string.format('sandaier_%d', sex)
	-- 					--if #cards == 4 then
	-- 						--spritename = "3d1"
	-- 					--elseif #cards == 5 then
	-- 						spritename = "3d2"
	-- 					--else
	-- 						--spritename = "3z"
	-- 					--end
	-- 				end
	-- 			else
	-- 				soundName = string.format('fei_%d', sex)
	-- 				spritename = "feiji"
	-- 			end
	-- 		elseif i == 2 then
	-- 			if #group == 1 then
	-- 				soundName = string.format('dui_%d_%d', sex, GetPlateNum(group[1][1]))
	-- 				spritename = "duizi"
	-- 			else
	-- 				soundName = string.format('liandui_%d', sex)
	-- 				spritename = "liandui"
	-- 			end
	-- 		else
	-- 			if #group == 1 then
	-- 				soundName = string.format('dan_%d_%d', sex, GetPlateNum(group[1][1]))
	-- 			else
	-- 				soundName = string.format('shunzi_%d', sex)
	-- 				spritename = "shunzi"
	-- 			end
	-- 		end
	-- 		break
	-- 	end
	-- end

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

	if spritename ~= "" then
		coroutine.start(
			function()
				playerzi[index].gameObject:SetActive(true)
				playerzi[index]:GetChild(0):GetComponent("UISprite").spriteName = spritename
				playerzi[index]:GetChild(0):GetComponent("UISprite"):MakePixelPerfect()
				coroutine.wait(1)
				playerzi[index].gameObject:SetActive(false)
			end
		)
	end
	--print("语音播放名字",soundName)
	if soundName ~= nil and soundName ~= '' then
		AudioManager.Instance:PlayAudio(soundName)
	end
end

function this.OnPlayerPass(msg)
	print("玩家过牌。。。。。")
	local b = pdk_pb.RPass()
	b:ParseFromString(msg.body)
	
	local nextSeat = (b.seat+1)%roomData.setting.size
	this.SetPassVisiable(true, b.seat)
	print(playerName[this.GetUIIndexBySeat(b.seat)]:GetComponent("UILabel").text..'玩家过牌')
	this.SetCountDownVisiable(true, nextSeat)

    roomData.activeSeat = nextSeat
	DelayMsgDispatch(connect, 0.3)
end

function this.OnOver(msg)
	print('所有局数结束')
	local b = pdk_pb.ROver()
	b:ParseFromString(msg.body)
	--print(msg.body)
	if b == nil then
		print("服务器下发的大结算数据为空666666666666666666666666666")
	else
		print("服务器下发的大结算数据不为空9999999999999999999999999")
	end
	RoundAllData.data = b
	RoundAllData.mySeat = mySeat
	RoundAllData.playerData = playerData
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
    for i = 0, #Trusteeships do
        print(i..'Trusteeships[i] : '..tostring(Trusteeships[i]))
    end
    RoundAllData.isTrusteeships = Trusteeships
	print('on over complete:' .. tostring(b.complete))
    if not b.complete and this.hasStageClear==false then
        PanelManager.Instance:HideWindow(gameObject.name)
        PanelManager.Instance:HideWindow('panelStageClear_pdk')
        PanelManager.Instance:ShowWindow('panelStageClearAll_pdk')
    end
end


function this.OnDissolveApply(msg)
	print('申请解散房间')
	--PanelManager.Instance:HideWindow('panelDestroyRoom')
	local b = pdk_pb.RDissolveAccept()
	b:ParseFromString(msg.body)
	
	roomData.dissolution.applicant = b.seat;
	while #roomData.dissolution.acceptors > 0 do
		table.remove(roomData.dissolution.acceptors, #roomData.dissolution.acceptors)
	end
	roomData.dissolution.remainMs = b.remainMs/1000
	this.SetDestoryPanelShow()
end


function this.OnDissolveAccept(msg)
	print('同意解散房间')
	local b = pdk_pb.RSeat()
	b:ParseFromString(msg.body)
	table.insert(roomData.dissolution.acceptors, b.seat)
	panelDestroyRoom.Refresh()
end


function this.OnDissolveReject(msg)
	print('拒绝解散房间')
	local b = pdk_pb.RSeat()
	b:ParseFromString(msg.body)
	panelDestroyRoom.Refresh(b.seat)
end


function this.Dissolve(msg)
	this.fanHuiRoomNumber = nil
	SPADE_THREE = nil
	print('房间已被解散');
	-- by jih >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	-- NetWorkManager.Instance:DeleteConnect('game');
	-- PanelManager.Instance:HideAllWindow()
	-- PanelManager.Instance:ShowWindow('panelLobby')

	-- if Util.GetPlatformStr() ~= 'win' then
	-- 	this.QuitVoiceRoom()
	-- end
	
	-- if roomData.round == 1 and roomData.state == 1 then

	-- 	--NetWorkManager.Instance:DeleteConnect('game')
	-- 	print('！！！！！！！！！！！！！！！！！！！！！' .. roomData.clubId)
	-- 	if roomData.clubId ~= '0' then
	-- 		print('！！！！！！！！！！！！！！！！！！！！！牌友群' )
    --         local data = {}
    --         data.name = 'panelInGame_pdk'
    --         data.clubId = roomData.clubId
    --         PanelManager.Instance:ShowWindow('panelClub', data)
	-- 	else
	-- 		print('！！！！！！！！！！！！！！！！！！！！！大厅' )
    --         PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
    --     end
	-- 	return
	-- end
	--roomData = {}
	-- TODO
	--local waitForOverInterval = 0
	local waitSecs = 0.2
	coroutine.start(function ()
		--while true do

			coroutine.wait(waitSecs)
			--print("死循环")
			if RoundAllData.over then
				print("所有局数打完显示大结算")
				PanelManager.Instance:HideAllWindow()
				PanelManager.Instance:ShowWindow('panelStageClearAll_pdk')
				
				--break
			end

			readybtn.gameObject:SetActive(true)
			-- if waitForOverInterval > 5 then
			-- 	NetWorkManager.Instance:DeleteConnect('game');
			-- 	PanelManager.Instance:HideAllWindow()
			-- 	PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
				
			-- 	break
			-- end

			--waitForOverInterval = waitForOverInterval + waitSecs
		--end
	end)

	-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	
end


function this.Destroy(msg)
	print('销毁房间')
	SPADE_THREE = nil
	this.StopCheckNetState()
	this.StopAllOfflineIncrease()
	this.fanHuiRoomNumber = nil
	--this.QuitVoiceRoom()
	NetWorkManager.Instance:DeleteConnect('game')
	panelLogin.HideGameNetWaitting()
	PanelManager.Instance:HideWindow('panelDestroyRoom')
    if panelStageClear_pdk then
		panelStageClear_pdk.setButtonsStatus(true)
	end
	if roomData.round == 1 and roomData.state == 1 then
		NetWorkManager.Instance:DeleteConnect('game')
		print('！！！！！！！！！！！！！！！！！！！！！' .. roomData.clubId)
		if roomData.clubId ~= '0' then
			print('！！！！！！！！！！！！！！！！！！！！！牌友群' )
            local data = {}
            data.name = 'panelInGame_pdk'
            -- data.clubId = roomData.clubId
            PanelManager.Instance:ShowWindow('panelClub', data)
		else
			print('！！！！！！！！！！！！！！！！！！！！！大厅' )
            PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
		end
		roomData.clubId = '0'
		--panelInGame =nil
		return
	end
	--roomData = {} 
end

function this.ClearRoom()
	for i=0,2 do
		playerName[i]:GetComponent('UILabel').text = ''
		playerPlateNum[i]:GetComponent('UILabel').text = ''
		playerIcon[i].gameObject:SetActive(false)
		playerScore[i]:GetComponent('UILabel').text =''
		playerMaster[i].gameObject:SetActive(false)
		playerSound[i].gameObject:SetActive(false)
		playerOffline[i].gameObject:SetActive(false)
		playerGridIn[i].gameObject:SetActive(false)
		playerGridOut[i].gameObject:SetActive(false)
		playerReady[i].gameObject:SetActive(false)
		playerLight[i].gameObject:SetActive(false)
		playerClock[i].gameObject:SetActive(false)
		playerWinIcon[i].gameObject:SetActive(false)
		playerPass[i].gameObject:SetActive(false)
		playerzi[i].gameObject:SetActive(false)
		--playerPiaoFen[i].gameObject:SetActive(false)
		playerPiaoFen[i]:GetComponent('UILabel').text = ""
	end

	CountDown.gameObject:SetActive(false)
	roomData.state = 1
end

function this.SetInviteVisiable(show)
	print('SetInviteVisiable:'..tostring(show))
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
	ButtonInvite.gameObject:SetActive(#playerData ~= roomData.setting.size - 1 and IsAppleReview() == false)
	if mySeat == 0 then
		ButtonCloseRoom:Find('Label'):GetComponent("UILabel").text = "解散房间"
	else
		ButtonCloseRoom:Find('Label'):GetComponent("UILabel").text = "退出房间"
	end
	ButtonInvite.parent:GetComponent("UIGrid"):Reposition()
end

function this.SetDestoryPanelShow() 
	PanelManager.Instance:HideWindow('panelDestroyRoom')
    PanelManager.Instance:ShowWindow('panelDestroyRoom')
end

function this.SetReadyVisiable()
    for i=0,2 do
        if roomData.state == 0 then
			playerReady[i].gameObject:SetActive(false)
			readybtn.gameObject:SetActive(true)
			print("没有准备好")
        elseif roomData.state == 1 then
            if i <= #playerData then
				local p = this.GetPlayerDataByUIIndex(i)
				if p and p.ready then
					playerReady[i].gameObject:SetActive(true)
				else
					playerReady[i].gameObject:SetActive(false)
				end
				if p.seat == mySeat then
					if p.ready then
						 print("已经准备好")
						readybtn.gameObject:SetActive(false)
					else
						readybtn.gameObject:SetActive(true)
						print("没有准备好")
					end
				end
             else
                playerReady[i].gameObject:SetActive(false)
             end
        else
			playerReady[i].gameObject:SetActive(false)
			print("游戏中了影藏准备按钮")
			readybtn.gameObject:SetActive(false)
        end
    end
end

function this.SetCountDownVisiable(show, seat, time)
	local index = this.GetUIIndexBySeat(seat)
	print("座位号为"..seat.."返回的index为"..index)

	
	if seat == mySeat and show then
		this.SetPassVisiable(false, seat)
		local nextHasOneCard = false
		if #roomData.latestHand.cards > 0 then
			local audoPlay = false
			if roomData.latestSeat ~= mySeat then
				print("上次出牌的是别人")
				local ns = (mySeat+1)%roomData.setting.size
				if playerData[ns].cardCount == 1 then
					nextHasOneCard = true
				end
				
				--if CheckCanPlay(playerData[mySeat].cards, playerData[mySeat].cards, roomData.latestHand.category, roomData.latestHand.cards, nextHasOneCard) then
				if pdk_Logic.CheckCardOutRule(playerData[mySeat].cards, playerData[mySeat].cards, roomData.latestHand.cards,  roomData.latestHand.category, nextHasOneCard) then
					print("把自己手牌全部放进去判断一波能不能出完")
					local  allcard = playerData[mySeat].cards
					table.sort(allcard, tableSortDesc)
					local cardGroups = GetCardsGroup(allcard)
					local group4 = GetGroupByID(4, cardGroups)
					local group3 = GetGroupByID(3, cardGroups)
					if #group4 > 0 or (roomData.setting.bombAAA and #group3 > 0 and GetPlateNum(group3[1][1]) == 14) then --在三A可当炸弹的时候 还要加入判断 
						audoPlay = false
						show = true
					else
						audoPlay = true
						print("把自己手牌全部放进去判断一波能出完666666666")
						show = false
					end
				elseif #selectCards > 0 then
					print("如果自己选了牌进来判断可不可以出")
					local cs = {}
					for k,v in ipairs(selectCards) do
						table.insert(cs, GetUserData(v))
					end
					--if not CheckCanPlay(cs, playerData[mySeat].cards, roomData.latestHand.category, roomData.latestHand.cards, nextHasOneCard) then
					if not pdk_Logic.CheckCardOutRule(cs, playerData[mySeat].cards, roomData.latestHand.cards, roomData.latestHand.category, nextHasOneCard) then
						this.OnClickWidget()
						print("这个时候选择牌的数量为",#selectCards)
					else
						ButtonPlay:GetComponent('UIButton').isEnabled = true
						print("如果自己选了牌进来判断可以出")
					end
				end
				if show and #selectCards == 0 then --如果没选牌 自动查找自己的牌有没有大得起的
					this.FindCards()
					--this.FindAllCard()
					if #lastFindCards == 0 then
						show = false
					end
				end
			--elseif CheckCanPlay(playerData[mySeat].cards, playerData[mySeat].cards, nil, nil, false) then
			elseif pdk_Logic.CheckCardOutRule(playerData[mySeat].cards, playerData[mySeat].cards, nil, nil, false) then
				local  allcard = playerData[mySeat].cards
				table.sort(allcard, tableSortDesc)
				local cardGroups = GetCardsGroup(allcard)
				local group4 = GetGroupByID(4, cardGroups)
				local group3 = GetGroupByID(3, cardGroups)
				if #group4 > 0 or (roomData.setting.bombAAA and #group3 > 0 and GetPlateNum(group3[1][1]) == 14) then --在三A可当炸弹的时候 还要加入判断 
					audoPlay = false
					show = true
				else
					audoPlay = true
					show = false
				end
				print("上次出牌的还是自己")
			end
			
			if audoPlay then
				coroutine.start(
					function()
						coroutine.wait(0.5)
						print('audoPlay自动出牌....')
						local msg = Message.New()
						msg.type = pdk_pb.PLAY
						local b = pdk_pb.PPlay()
						for k,v in ipairs(playerData[mySeat].cards) do
							table.insert(b.cards, v)
							print(k,v)
						end
						msg.body = b:SerializeToString()
						SendGameMessage(msg, nil)
					end
				)
			end
		end
		CountDown.gameObject:SetActive(show)

		this.StartCheckTrusteeship(seat, time)
	else
		this.SopCheckTrusteeship()
		CountDown.gameObject:SetActive(false)
	end
	coroutine.stop(conCountDown)
	for i=0,2 do
		if show then
			if index == i then
				local remainTime 
				if roomData.setting.trusteeship == 0 then
					remainTime = 15
				else
					if time then
						remainTime = roomData.trusteeshipRemainMs
					else
						remainTime = roomData.setting.trusteeship
					end
				end
				print('remainTime : '..remainTime)
				playerClock[i].gameObject:SetActive(true)
				playerClock[i]:Find('time'):GetComponent('UILabel').text = remainTime
				if seat == mySeat then
					RefreshGrid(playerGridOut[i], {})
				end
				conCountDown = coroutine.start(this.RefreshCoundDownTime, playerClock[i]:Find('time'):GetComponent('UILabel'), remainTime, mySeat == seat)
			else
				playerClock[i].gameObject:SetActive(false)
			end
		else
			playerClock[i].gameObject:SetActive(false)
		end
	end
end
function this.FindAllCard()
	local findCards = {}
	local category
	local nextHasOneCard = false
	local ns = (mySeat+1)%roomData.setting.size
	if playerData[ns].cardCount == 1 then
		nextHasOneCard = true
	end
	findCards = FindAllCanPlayCards(playerData[mySeat].cards, roomData.latestHand.category, roomData.latestHand.cards, nextHasOneCard)
end
function this.FindCards()
	local findCards = {}
	local category
	local nextHasOneCard = false
	
	local ns = (mySeat+1)%roomData.setting.size
	if playerData[ns].cardCount == 1 then
		nextHasOneCard = true
	end
	if #lastFindCards > 0 then
		--findCards,category = FindCanPlayCards(playerData[mySeat].cards, lastFindCategory, lastFindCards, nextHasOneCard)
		findCards,category = pdk_Logic.FindCanPlayCard(playerData[mySeat].cards, lastFindCards, lastFindCategory, false, nextHasOneCard)
		if #findCards == 0 then
			--findCards,category = FindCanPlayCards(playerData[mySeat].cards, roomData.latestHand.category, roomData.latestHand.cards, nextHasOneCard)
			findCards,category = pdk_Logic.FindCanPlayCard(playerData[mySeat].cards, roomData.latestHand.cards, roomData.latestHand.category, false, nextHasOneCard)
		end
	else
		print("自己手牌的数量 ",#playerData[mySeat].cards)
		--findCards,category = FindCanPlayCards(playerData[mySeat].cards, roomData.latestHand.category, roomData.latestHand.cards, nextHasOneCard)
		findCards,category = pdk_Logic.FindCanPlayCard(playerData[mySeat].cards, roomData.latestHand.cards, roomData.latestHand.category, false, nextHasOneCard)
		-- if #findCards == 0 then
		-- 	print('找不到大得起的牌选择过')
		-- 	coroutine.start(
		-- 		function()
		-- 			coroutine.wait(PDKspeed)
		-- 			this.OnClickOnButtonPass()
		-- 		end
		-- 	)
		-- end
	end
	
	local s =''
	for i=1,#findCards do
		s = s .. GetPlateNum(findCards[i]) .. ','
	end
	print('find card:' .. s)
	
	print('lastSelectCardNum:'..#selectCards)
	for i=#selectCards,1,-1 do
		this.OnClickCard(selectCards[i], false)
	end
	selectCards={}
	lastFindCards = {}
	for i = 1, #findCards do
		lastFindCards[i] = findCards[i]
	end
	-- --lastFindCards = findCards
	lastFindCategory = category
	print("返回的类型为",category)
	if category == DAN then
		if ishelp == false then
			if (#findCards == 1 and GetPlateNum(findCards[1])  == GetPlateNum(playerData[mySeat].cards[1])) or category == ZHA_DA then
				print("找到单牌不清空 弹出来"..GetPlateNum(playerData[mySeat].cards[1]))
			else
				lastFindCards = roomData.latestHand.cards
				findCards={}
				print("已经清除")
			end
		else
			print("ishelp".."没有清除")
			ishelp = false
		end
	end
	if category == DUI then
		local cardGroups = GetCardsGroup(playerData[mySeat].cards)
		local group2 = GetGroupByID(2, cardGroups)
		local group3 = GetGroupByID(3, cardGroups)
		local all = {}

		for i=1,#group2 do
			table.insert(all, group2[i])
		end
		for i=1,#group3 do
			local tempGroup = {}
			table.insert(tempGroup, group3[i][1])
			table.insert(tempGroup, group3[i][2])
			table.insert(all, tempGroup)
		end
		table.sort(all, tableSortDescBySubtable)
		if ishelp == false then
			if (#findCards == 2 and #all ~= 0 and GetPlateNum(findCards[1]) == GetPlateNum(all[1][1])) or category == ZHA_DA then
			else
				lastFindCards = roomData.latestHand.cards
				findCards={}
			end
		else
			ishelp = false
		end
	end
	if category ~= DAN and category ~= DUI then
		ishelp = false
	end
	local index = this.GetUIIndexBySeat(mySeat)
	for i=1,#findCards do
		local id = findCards[i]
		for j=0,playerGridIn[index].transform.childCount-1 do
			local item = playerGridIn[index].transform:GetChild(j)
			if item.gameObject.activeSelf and GetUserData(item.gameObject) == id then
				this.OnClickCard(item.gameObject, false)
				break
			end
		end
	end
	--lastFindCards = findCards
	--lastFindCategory = category
end

function this.SetPassVisiable(show, seat)
	local i = this.GetUIIndexBySeat(seat)
	print("1111座位号为"..seat.."返回的index为"..i)
	if show then
		math.randomseed(os.time())
		local index = math.random(0, 2)
		playerPass[i].gameObject:SetActive(show)
		coroutine.start(
			function()
				playerPass[i]:GetChild(index):GetComponent("UISprite"):MakePixelPerfect()
				playerPass[i]:GetChild(index).gameObject:SetActive(true)
				if index==0 then
					playerPass[i]:GetChild(index).localScale=Vector3(1.4,1.4,1)
				end
				coroutine.wait(1)
				playerPass[i]:GetChild(index).gameObject:SetActive(false)
			end
		)
		--print("string.format('yaobuqi_%d_%d', playerData[seat].sex,index+1)",string.format('yaobuqi_%d_%d', playerData[seat].sex,index+1))
		AudioManager.Instance:PlayAudio(string.format('yaobuqi_%d_%d', playerData[seat].sex,index+1))
		-- if index%2 == 0 then
		-- 	AudioManager.Instance:PlayAudio(string.format('yaobuqi_%d_1', playerData[seat].sex))
		-- else
		-- 	AudioManager.Instance:PlayAudio(string.format('yaobuqi_%d_2', playerData[seat].sex))
		-- end
	else
		playerPass[i].gameObject:SetActive(show)
	end
end

function this.SetRoundNum(num)
	roomRound:GetComponent('UILabel').text = "第"..num..'/'..roomData.setting.rounds..'局'--..setting_text
	--设置游戏规则面板
end

function this.RefreshCoundDownTime(labelTime, timeNum, tip)	
	labelTime.text = timeNum
    while timeNum >= 1 and gameObject.activeSelf do
        if timeNum <= 5 and tip then
             AudioManager.Instance:PlayAudio('second')
        end
		coroutine.wait(1)
		timeNum = timeNum - 1
		labelTime.text = timeNum
    end
end

-- function this.OnClickButtonSetting(go)
-- 	AudioManager.Instance:PlayAudio('btn')
-- 	print('roomData.setting.size:'..roomData.setting.size..' playerData size:'..#playerData+1 ..' mySeat:'..mySeat)
-- 	if roomData.setting.size == #playerData+1 or mySeat == 0 then
-- 		UnityEngine.PlayerPrefs.SetInt('showWhichButton', 1)
-- 	else
-- 		UnityEngine.PlayerPrefs.SetInt('showWhichButton', 2)
-- 	end
--     PanelManager.Instance:ShowWindow('panelSetting')
-- end

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
	local msg  =""--= '房号：' .. roomInfo.roomNumber .. '，'
	--msg = msg .. roomData.setting.cardCount .. '张牌，'
	msg = msg .. roomData.setting.rounds .. '局，'
	if roomData.setting.showCount then
		msg = msg .. '显示牌数，'
	else
		msg = msg .. '不显示牌数，'
	end

	if roomData.setting.size == 2 then
		msg = msg .. '2人玩，'
	else
		msg = msg .. '3人玩，'
	end
	-- if roomData.clubId ~= '0' then
	-- 	msg = msg .. '群主支付，'
	-- else
	-- 	if roomData.setting.paymentType == 0 then
	-- 		msg = msg .. '房主支付，'
	-- 	else
	-- 		msg = msg .. '赢家支付，'
	-- 	end
	-- end

	if roomData.setting.firstPlay == pdk_pb.OWNER then
		msg = msg..'首局房主先出, '
	elseif roomData.setting.firstPlay == pdk_pb.S3 then
		msg = msg..'黑桃三先出, '
	elseif roomData.setting.firstPlay == pdk_pb.S3_IN then
		msg = msg..'黑桃三必先出, '
	else
		msg = msg..'幸运翻牌, '
	end
	if roomData.setting.remainBanker then
		msg = msg..'赢家为庄, '
	else
		msg = msg..'延续首轮抢庄规则, '
	end
	if roomData.setting.bombSplit then
		msg = msg..'炸弹可拆, '
	else
		msg = msg..'炸弹不可拆, '
	end
	if roomData.setting.bombBelt then
		msg = msg..'炸弹四带三, '
	else
		--setting_text = setting_text..' 炸弹不可四带三'
	end
	if roomData.setting.bombBeltTwo then
		msg = msg..'炸弹四带二, '
	else
		--setting_text = setting_text..' 炸弹不可四带三'
	end
	if roomData.setting.bombAAA then
		msg = msg..' 3A可当炸弹, '
	else
		--setting_text = setting_text..' 炸弹不可四带三'
	end
	msg = msg.."房已开好,就等你来！"
	print("分享信息",msg)
	--PlatformManager.Instance:ShareLink('https://a.mlinks.cc/AKgB?id=' .. roomInfo.roomNumber, '嗨皮跑得快', msg)
	local que = roomData.setting.size - (#playerData+1)
	local title = roomInfo.roomNumber.."房,"..roomData.playName..roomData.setting.size.."缺"..que	
	print("title",title)
	PlatformManager.Instance:ShareLink('http://'..panelLogin.HttpUrl..'/shareRoom.html?appType=1&state=' ..proxy_pb.PDK..roomInfo.roomNumber, title, msg, 0)
end

-- function this.OnClickPlayerIcon(go)
-- 	local pData = GetUserData(go)
-- 	if not pData then
-- 		return
-- 	end
	
--     userInfo.nickname = pData.name
--     userInfo.icon = pData.icon
--     userInfo.sex = pData.sex
--     userInfo.ip = pData.ip
-- 	userInfo.id = pData.id
-- 	userInfo.balance = pData.balance
-- 	print(userInfo.ip)
-- 	PanelManager.Instance:ShowWindow('panelPlayerInfo')
-- end

function this.OnClickPlayerIcon(go)
    if IsAppleReview() then
        return
    end
    local pData = GetUserData(go)
    if not pData then
        return
    end
    print('名片'..pData.id)
	print('名片tu'..pData.imgUrl)
	print('icontu'..pData.icon)
    local userData = {}
	userData.rseat 		= pData.seat
	userData.mySeat		= mySeat;
    userData.whoShow 	= gameObject.name
    userData.nickname 	= pData.name
    userData.icon 		= pData.icon
    userData.sex 		= pData.sex
    userData.ip 		= pData.ip
    userData.userId 	= pData.id
    userData.balance 	= pData.balance
    userData.address 	= pData.address
    userData.imgUrl 	= pData.imgUrl
	userData.gameType	= proxy_pb.PDK
	userData.signature 	= pData.signature
	userData.sendMsgAllowed = roomData.setting.sendMsgAllowed
    userData.fee = pData.fee
	userData.isShowSomeID = false
	userData.gameMode = roomData.setting.gameMode
    PanelManager.Instance:ShowWindow('panelPlayerInfo', userData)
end
function this.OnClickButtonHelp(go)
	AudioManager.Instance:PlayAudio('btn')
	if roomData.latestSeat ~= mySeat and #roomData.latestHand.cards > 0 then
		ishelp = true
		this.FindCards()
	end
	
	local nextHasOneCard = false
	local ns = (mySeat+1)%roomData.setting.size
	if playerData[ns].cardCount == 1 then
		nextHasOneCard = true
	end
	
	if nextHasOneCard and roomData.latestHand.category == DAN then
		helpNumWhenHaveOneCard = helpNumWhenHaveOneCard + 1
		if helpNumWhenHaveOneCard > 3 then
			coroutine.start(this.ShowDanTip)
		end
	end
end

function this.OnClickButtonPlay(go)
	AudioManager.Instance:PlayAudio('btn')
	if roomData.banker == mySeat and #roomData.latestHand.cards == 0 and roomData.setting.firstPlay == pdk_pb.S3_IN  then --and roomData.round == 1
		if roomData.setting.remainBanker  then --如果赢家为庄 只是第一句黑三必出
			if roomData.round == 1 then
				local get_spadeThree = false
				for k,v in ipairs(selectCards) do
					if GetUserData(v) == SPADE_THREE then
						get_spadeThree = true
						break
					end
				end
				if not get_spadeThree then
					coroutine.start(this.ShowSpadeThreeTip)
					return
				end
			end
		else
			local get_spadeThree = false
			for k,v in ipairs(selectCards) do
				if GetUserData(v) == SPADE_THREE then
					get_spadeThree = true
					break
				end
			end
			if not get_spadeThree then
				coroutine.start(this.ShowSpadeThreeTip)
				return
			end
		end
	end
	if #selectCards == 0 then
		return
	end
	
	local msg = Message.New()
	msg.type = pdk_pb.PLAY
	local b = pdk_pb.PPlay()
	local cards ={}
	for k,v in ipairs(selectCards) do
		table.insert(cards, GetUserData(v))
		print('play card id:'..GetUserData(v))
	end
	
	table.sort(cards, tableSortDesc)
	local groups = GetCardsGroup(cards)
	local group4 = GetGroupByID(4, groups)
	local group3 = GetGroupByID(3, groups)
	local group2 = GetGroupByID(2, groups)
	local group1 = GetGroupByID(1, groups)
	if #group4 > 0 then
		for i=1,#group4 do
			table.insert(b.cards, group4[i][1])
			table.insert(b.cards, group4[i][2])
			table.insert(b.cards, group4[i][3])
			table.insert(b.cards, group4[i][4])
		end
		for i=1,#group3 do
			table.insert(b.cards, group3[i][1])
			table.insert(b.cards, group3[i][2])
			table.insert(b.cards, group3[i][3])
		end
		for i=1,#group2 do
			table.insert(b.cards, group2[i][1])
			table.insert(b.cards, group2[i][2])
		end
		for i=1,#group1 do
			table.insert(b.cards, group1[i][1])
		end
	elseif #group3 > 0 then
		for i=1,#group3 do
			table.insert(b.cards, group3[i][1])
			table.insert(b.cards, group3[i][2])
			table.insert(b.cards, group3[i][3])
		end
		for i=1,#group2 do
			table.insert(b.cards, group2[i][1])
			table.insert(b.cards, group2[i][2])
		end
		for i=1,#group1 do
			table.insert(b.cards, group1[i][1])
		end
	elseif #group2 > 0 then
		for i=1,#group2 do
			table.insert(b.cards, group2[i][1])
			table.insert(b.cards, group2[i][2])
		end
	else
		for i=1,#cards do
			table.insert(b.cards, cards[i])
		end
	end
	msg.body = b:SerializeToString()
	SendGameMessage(msg, nil)

	CountDown.gameObject:SetActive(false)
end

function this.OnClickOnButtonPass()
	local msg = Message.New()
	msg.type = pdk_pb.PASS
	SendGameMessage(msg, nil)
	this.SetCountDownVisiable(false, mySeat)
end

function this.OnClickWidget(go)
	for i=#selectCards,1,-1 do
		this.OnClickCard(selectCards[i], false)
	end
end

function this.OnMousePressHoverCard(go)
	this.OnClickCard(go, false)
	AudioManager.Instance:PlayAudio('click_poker')
end

function this.OnClickCard(go, isClick)
	local isFind = false
	isClick = isClick == nil
	--判断是不是选中
	for k,v in ipairs(selectCards) do
		if v == go then
			isFind = true
			local pos = go.transform.localPosition
			pos.y = 0
			go.transform.localPosition = pos
			table.remove(selectCards, k)
			--print('remove card id:'..GetUserData(go))
			break
		end
	end
	
	--判断下家是否报单
	local nextHasOneCard = false
	local ns = (mySeat+1)%roomData.setting.size
	if playerData[ns].cardCount == 1 then
		nextHasOneCard = true
	end
	
	if not isFind then
		if isClick then	--根据手动选择的牌，自动补全
			local canDo = false
			local cards={}
			local objs={}
			if #roomData.latestHand.cards > 0 and roomData.latestSeat ~= mySeat then
				if roomData.latestHand.category == DAN then
					--canDo = CheckCanPlay({GetUserData(go)}, playerData[mySeat].cards, roomData.latestHand.category, roomData.latestHand.cards, nextHasOneCard)
					canDo = pdk_Logic.CheckCardOutRule({GetUserData(go)}, playerData[mySeat].cards, roomData.latestHand.cards, roomData.latestHand.category, nextHasOneCard)
					cards,objs = this.FindDan(GetUserData(go))
					if canDo == false and #cards > 0 then
						canDo = true
					end
				elseif roomData.latestHand.category == DUI then
					cards,objs = this.FindDui(GetUserData(go))
					if cards then
						--canDo = CheckCanPlay(cards, playerData[mySeat].cards, roomData.latestHand.category, roomData.latestHand.cards, nextHasOneCard)
						canDo = pdk_Logic.CheckCardOutRule(cards, playerData[mySeat].cards, roomData.latestHand.cards, roomData.latestHand.category, nextHasOneCard)
					end
				end

				--取消选中的牌
				if canDo then
					for i=#selectCards,1,-1 do
						this.OnClickCard(selectCards[i], false)
					end

					for i=1,#objs do
						if objs[i] ~= go then
							this.OnClickCard(objs[i], false)
						end
					end
				end
			else
				--canDo = CheckCanPlay({GetUserData(go)}, playerData[mySeat].cards, nil, nil, nextHasOneCard)
				canDo = pdk_Logic.CheckCardOutRule({GetUserData(go)}, playerData[mySeat].cards, nil, nil, nextHasOneCard)
			end
			if not canDo and nextHasOneCard and #selectCards == 0 then
				coroutine.start(this.ShowDanTip)
			end
		end
		print('select card id:'..GetUserData(go))
		table.insert(selectCards, go)
		local pos = go.transform.localPosition
		pos.y = 30
		go.transform.localPosition = pos
	end
	
	local cards = {}
		for k,v in ipairs(selectCards) do
		table.insert(cards, GetUserData(v))
	end
	
	local canPlay = false
	if roomData.latestHand ~= nil and #roomData.latestHand.cards > 0 and roomData.latestSeat ~= mySeat then
		--canPlay = CheckCanPlay(cards, playerData[mySeat].cards, roomData.latestHand.category, roomData.latestHand.cards, nextHasOneCard)
		canPlay = pdk_Logic.CheckCardOutRule(cards, playerData[mySeat].cards, roomData.latestHand.cards, roomData.latestHand.category, nextHasOneCard)
	else
		--canPlay = CheckCanPlay(cards, playerData[mySeat].cards, nil,nil,nextHasOneCard)
		canPlay = pdk_Logic.CheckCardOutRule(cards, playerData[mySeat].cards, nil, nil, nextHasOneCard)
	end
	
	print('canPlay:'..tostring(canPlay))
	if canPlay then
		ButtonPlay:GetComponent('UIButton').isEnabled = true
	else
		ButtonPlay:GetComponent('UIButton').isEnabled = false
	end
	if isClick then
		AudioManager.Instance:PlayAudio('click_poker')
	end
	
	--print('isClick:'..tostring(isClick)..' isFind:'..tostring(isFind)..' cardNum:'..#cards)
	--print('canPlay:'..tostring(canPlay)..' lastCards:'..#roomData.latestHand.cards..' lastSeat:'..roomData.latestSeat..' mySeat:'..mySeat)
	if isClick and not isFind and #cards == 3 and not canPlay and (#roomData.latestHand.cards == 0 or roomData.latestSeat == mySeat) then
		this.Find5Shun(cards)
	end
end
function this.FindMaxShun(huapai)
	print('查找最长的顺子')
	local cs = {}
	for i = 1, #huapai do
		cs[i] = huapai[i]
	end
	table.sort(cs, tableSortAsc)
	-- for b = 1, #cs do
	-- 	print("cs",GetPlateNum(cs[b]))
	-- end
	local nosame ={}
	local index = 1
	for i = 1, #cs do
		if i==1 then
			nosame[index] = cs[i]
			index = index + 1
		else
			if GetPlateNum(cs[i]) ~= GetPlateNum(cs[i-1]) and GetPlateNum(cs[i]) ~= 15 then
				nosame[index] = cs[i]
				index = index + 1
			end
		end
	end
	-- for b = 1, #nosame do
	-- 	print("nosame",GetPlateNum(nosame[b]))
	-- end
	local shunzi = {}
	local  bb = 1
	for i = 1,#nosame -4 do
		for k = 1, i do
			if GetPlateNum(nosame[#nosame-(i-k)]) - GetPlateNum(nosame[k]) == #nosame-(i-k) - k then
				for x = k, #nosame-(i-k) do
					shunzi[bb] = nosame[x]
					--print("shunzibb",shunzi[bb])
					bb = bb + 1			
				end
				return shunzi
			end
		end
	end
	return shunzi
end
function this.Find5Shun(cards)
	print('Find5Shun')
	table.sort(cards, tableSortAsc)
	local maxNum = GetPlateNum(cards[#cards])
	local minNum = GetPlateNum(cards[1])
	
	if maxNum - minNum == 2 then
		local next1Num = maxNum+1
		local next2Num = maxNum+2
		local index = this.GetUIIndexBySeat(mySeat)
		local next1Obj,next2Obj
		
		for i=0,playerGridIn[index].transform.childCount-1 do
			local item = playerGridIn[index].transform:GetChild(i)
			if item.gameObject.activeSelf then
				if next1Num == GetPlateNum(GetUserData(item.gameObject)) then
					next1Obj = item.gameObject
				elseif next2Num == GetPlateNum(GetUserData(item.gameObject)) then
					next2Obj = item.gameObject
				end
			end
		end
		
		if next1Obj and next2Obj then
			this.OnClickCard(next1Obj, false)
			this.OnClickCard(next2Obj, false)
		end
	end
end

function this.FindDan(card)
	print('FindDan')
	local num = GetPlateNum(card)
	local index = this.GetUIIndexBySeat(mySeat)
	local cards ={}
	local objs = {}
	for i=0,playerGridIn[index].transform.childCount-1 do
		local item = playerGridIn[index].transform:GetChild(i)
		if item.gameObject.activeSelf then
			if num == GetPlateNum(GetUserData(item.gameObject)) then
				table.insert(cards, GetUserData(item.gameObject))
				table.insert(objs, item.gameObject)
			end
		end
	end

	if #cards == 4 or (#cards == 3 and roomData.setting.bombAAA and GetPlateNum(cards[1])==14) then

	else
		cards = {}
		objs = {}
	end

	return cards,objs
end

function this.FindDui(card)
	print('FindDui')
	local num = GetPlateNum(card)
	local index = this.GetUIIndexBySeat(mySeat)
	local cards ={}
	local objs = {}
	for i=0,playerGridIn[index].transform.childCount-1 do
		local item = playerGridIn[index].transform:GetChild(i)
		if item.gameObject.activeSelf then
			if num == GetPlateNum(GetUserData(item.gameObject)) then
				table.insert(cards, GetUserData(item.gameObject))
				table.insert(objs, item.gameObject)
			end
		end
	end

	if #cards == 2 or #cards == 4 or (#cards == 3 and roomData.setting.bombAAA and GetPlateNum(cards[1])==14) then

	else
		cards = nil
		objs = nil
	end

	return cards,objs
end

function this.ShowTip(msg)
	print('ShowTip in')
	danTip:GetComponent('UILabel').text = msg
	danTip:GetComponent('UILabel').alpha = 1
	danTip.parent.gameObject:SetActive(true)
	coroutine.wait(1)
	-- while danTip:GetComponent('UILabel').alpha > 0 do
	-- 	danTip:GetComponent('UILabel').alpha = danTip:GetComponent('UILabel').alpha - 0.1
	-- 	coroutine.wait(0.2)
	-- end
	danTip.parent.gameObject:SetActive(false)
	print('ShowTip out')
end

function this.ShowDanTip()
	this.ShowTip('下家已报单，需要先出最大的牌')
end

function this.ShowSpadeThreeTip()
	this.ShowTip('必须先出带首出标志的牌哦！')
end
function this.OnSendChat(msg)
	local b = pdk_pb.RChat()
	b:ParseFromString(msg.body)

	local index = this.GetUIIndexBySeat(b.seat)
	if b.type == 0 then --图片
		-- if b.position == 1 then
		-- 	this.playVoice('emoji ' .. b.position)
		-- end
		this.showEmoji(index, b.position)

	elseif b.type == 1 then -- 语音文本
		--this.playVoice('chat_' .. b.position)
		--this.showText(index, b.text)
		print("b.seat6666666666666666666666",b.seat)
		local p = this.GetPlayerDataByUIIndex(this.GetUIIndexBySeat(b.seat))
		--local p = this.GetPlayerDataBySeat(b.seat)
        this.playVoice(string.format('chat_%d_%d', p.sex, b.position))
        this.showText(index, b.text)
	else --纯文本
		this.showText(index, b.text)
		local p = this.GetPlayerDataByUIIndex(this.GetUIIndexBySeat(b.seat))
        if panelChat then
            panelChat.AddChatToLabel(p.name .. ':' .. b.text)
        else
            table.insert(this.chatTexts, p.name .. ':' .. b.text)
        end
	end
end

-- function this.OnSendChat(msg)
--     local b = phz_pb.RChat()
--     b:ParseFromString(msg.body)
--     --print('OnSendChat seat:'..b.seat..' type:'..b.type)
--     local index = this.GetUIIndexBySeat(b.seat)
--     if b.type == 0 then --图片
--         this.showEmoji(index, b.position)
--     elseif b.type == 1 then -- 语音文本
--         local p = this.GetPlayerDataBySeat(b.seat)
--         this.playVoice(string.format('chat_%d_%d', p.sex, b.position))
--         this.showText(index, b.text)
--     else --纯文本
--         this.showText(index, b.text)
--         local p = this.GetPlayerDataBySeat(b.seat)
--         if panelChat then
--             panelChat.AddChatToLabel(p.name .. ':' .. b.text)
--         else
--             table.insert(this.chatTexts, p.name .. ':' .. b.text)
--         end
--     end
-- end

function this.playVoice(vioceName)
	AudioManager.Instance:PlayAudio(vioceName)
end

function this.showText(seat, text)
	coroutine.stop(playerCoroutine[seat])
	playerCoroutine[seat] = coroutine.start(function()
		playerMsg[seat].gameObject:SetActive(true)
		playerMsg[seat]:GetComponent('UILabel').text = text
		playerMsg[seat]:GetComponent('UILabel').color = Color(244/255,244/255,244/255)
		local width = playerMsg[seat]:GetComponent('UILabel').width
		--playerMsgBG[seat]:GetComponent('UISprite').width = width + 40
		if seat == 1 then
			--playerMsg[seat]:GetComponent('Transform').localPosition = Vector3.New(-width - 80, 93, 0)
		end
		playerEmoji[seat].gameObject:SetActive(false)
		coroutine.wait(5)
		playerMsg[seat].gameObject:SetActive(false)
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

-- by jih，加入语音房间 ----------------------------------------------------------------------------------------------------------

function this.TickNGCloudVoice()
    while gameObject.activeSelf do
        NGCloudVoice.Instance:Poll()
        coroutine.wait(0.03)
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
			print('UnityEngine.Input.mousePosition.y=' .. mousePositionY)
			print('button.y==' .. buttonY)
			print('按钮高度' .. buttonHeight)
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

function this.UploadReccordFileComplete(fileid)
    print('发送给服务器' .. fileid)
    local msg = Message.New()
    msg.type = pdk_pb.VOICE_MEMBER
    local body = pdk_pb.PVoiceMember()
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
	for i = 0, #playerData do
        if this.GetPlayerDataByUIIndex(i).voiceId == fileid then
			playerSound[i].gameObject:SetActive(true);
		else
			playerSound[i].gameObject:SetActive(false);
		end
		
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
            playerSound[i].gameObject:SetActive(false)
        end
    end

end
-- function this.OnVoiceMember(msg)
--     local b = pdk_pb.RVoiceMember()
--     b:ParseFromString(msg.body)
--     print('seat ' .. b.seat .. ' 的录音文件, fileid is ' .. b.voiceId)
--     local player = this.GetPlayerDataBySeat(b.seat)
--     if player then
--         player.voiceId = b.voiceId
--         NGCloudVoice.Instance:Click_btnDownloadFile(player.voiceId)
--     else
--         print('无法通过座位号 ' .. b.seat .. ' 获取到用户信息')
--     end
-- end
-- 屏蔽其他玩家实时语音状态
function this.ShieldVoiceEvent()
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
	local b = pdk_pb.RVoiceMember()
	b:ParseFromString(msg.body)
	print('seat ' .. b.seat .. ' join voice room, member id is ' .. b.memberId)
	local player = playerData[b.seat]
	if player then
		player.voiceId = b.voiceId
        NGCloudVoice.Instance:Click_btnDownloadFile(player.voiceId)
	else
		print('无法通过座位号 ' .. b.seat .. ' 获取到用户信息')
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
		msg.type = pdk_pb.DISSOLVE_APPLY
		SendGameMessage(msg, nil)
	else
		print("离开房间")
		AudioManager.Instance:PlayAudio('btn')
		local msg = Message.New()
		msg.type = pdk_pb.LEAVE_ROOM
		SendGameMessage(msg, nil)
	end

	this.fanHuiRoomNumber = nil
end


function this.OnClicButtonLeaveRoom(go)
	AudioManager.Instance:PlayAudio('btn')
    -- local msg = Message.New()
    -- msg.type = pdk_pb.LEAVE_ROOM
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
function this.WhoShow(data)
	gameObject:SetActive(false)
	this.SetMyAlpha(1)
	this.OnRoundStarted = nil
	PanelManager.Instance:HideAllWindow()
	gameObject:SetActive(true)
end
function this.GetPlayerDataBySeat(seat)
	if playerData[seat] == nil then
	end
	return  playerData[seat]
end
function this.SetMyAlpha(alpha)
    gameObject.transform:GetComponent('UIPanel').alpha = alpha
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

function this.ShowPanelShare(go)
    panelShare.gameObject:SetActive(true)
end
function this.ClosePanelShare(go)
    panelShare.gameObject:SetActive(false)
end
function this.OnClicButtonCopy(go)

    local msg = '房号:' .. roomInfo.roomNumber
	msg = msg ..","..roomData.setting.cardCount .."张跑得快,"..getWanFaText_pdk(roomData.setting,false,false)
	print("复制的信息",msg)
    Util.CopyToSystemClipbrd(msg)
    panelMessageTip.SetParamers('复制成功', 1.5)
    PanelManager.Instance:ShowWindow('panelMessageTip')
end
function this.OnClickButtonXLInvite(go)
	local msg = '房号：' .. roomInfo.roomNumber .. '，'
	msg = msg .. roomData.setting.cardCount .. '张牌，'
	msg = msg .. roomData.setting.rounds .. '局，'
	if roomData.setting.showCount then
		msg = msg .. '显示牌数，'
	else
		msg = msg .. '不显示牌数，'
	end

	if roomData.setting.size == 2 then
		msg = msg .. '2人玩，'
	else
		msg = msg .. '3人玩，'
	end

	if roomData.clubId ~= '0' then
		msg = msg .. '群主支付，'
	else
		if roomData.setting.paymentType == 0 then
			msg = msg .. '房主支付，'
		else
			msg = msg .. '赢家支付，'
		end
	end

	if roomData.setting.firstPlay == pdk_pb.OWNER then
		msg = msg..' 首局房主先出'
	elseif roomData.setting.firstPlay == pdk_pb.S3 then
		msg = msg..' 黑桃三先出'
	elseif roomData.setting.firstPlay == pdk_pb.S3_IN then
		msg = msg..' 黑桃三必先出'
	else
		msg = msg..' 幸运翻牌'
	end
	if roomData.setting.remainBanker then
		msg = msg..' 赢家为庄'
	else
		msg = msg..' 延续首轮抢庄规则'
	end
	if roomData.setting.bombSplit then
		msg = msg..' 炸弹可拆'
	else
		msg = msg..' 炸弹不可拆'
	end
	if roomData.setting.bombBelt then
		msg = msg..' 炸弹四带三'
	else
		--setting_text = setting_text..' 炸弹不可四带三'
	end
	if roomData.setting.bombBeltTwo then
		msg = msg..' 炸弹四带二'
	else
		--setting_text = setting_text..' 炸弹不可四带三'
	end
	if roomData.setting.bombAAA then
		msg = msg..' 3A可当炸弹'
	else
		--setting_text = setting_text..' 炸弹不可四带三'
	end
	print("分享闲聊信息",msg)
	local que = roomData.setting.size - (#playerData+1)
	local title = roomInfo.roomNumber.."房,"..roomData.playName..roomData.setting.size.."缺"..que	
    PlatformManager.Instance:ShareLinkToXL('http://'..panelLogin.HttpUrl..'/share/xl/jionRoom.html?roomId='..roomInfo.roomNumber..'&gameType='..proxy_pb.PDK..'&appType=1', title, msg)
end
function this.changePaiSize(size)
	print("牌的大小为",size)
	if size == 0 then --要求为小牌
		for i = 0, playerGridIn[0].transform.childCount-1 do
			local item = playerGridIn[0].transform:GetChild(i)
			if item.gameObject.activeSelf then
				local num = item:Find('num')
				local spname = num:GetComponent('UISprite').spriteName
				local index = string.find(spname,"b")
				if index == nil then
					return  
				else
					num:GetComponent('UISprite').spriteName = string.sub(spname, 2,-1)
				end
			end
		end
		for i = 0, 2 do
			for k = 0, playerGridOut[i].transform.childCount-1 do
				local item = playerGridOut[i].transform:GetChild(k)
				if item.gameObject.activeSelf then
					local num = item:Find('num')
					local spname = num:GetComponent('UISprite').spriteName
					local index = string.find(spname,"b")
					if index == nil then
						return  
					else
						num:GetComponent('UISprite').spriteName = string.sub(spname, 2,-1)
					end
				end
			end
		end
	else
		for i = 0, playerGridIn[0].transform.childCount-1 do
			local item = playerGridIn[0].transform:GetChild(i)
			if item.gameObject.activeSelf then
				local num = item:Find('num')
				local spname = num:GetComponent('UISprite').spriteName
				local index = string.find(spname,"b")
				if index == nil then
					num:GetComponent('UISprite').spriteName = "b"..spname
				else
					return 
				end
			end
		end
		for i = 0, 2 do
			for k = 0, playerGridOut[i].transform.childCount-1 do
				local item = playerGridOut[i].transform:GetChild(k)
				if item.gameObject.activeSelf then
					local num = item:Find('num')
					local spname = num:GetComponent('UISprite').spriteName
					local index = string.find(spname,"b")
					if index == nil then
						num:GetComponent('UISprite').spriteName = "b"..spname
					else
						return
					end
				end
			end
		end
	end
end

function this.NotifyGameStart()
	--通知玩家返回游戏
	if #playerData == (roomData.setting.size - 1) and roomData.round == 1 and roomData.state ~= phz_pb.GAMING then
		if this.OnRoundStarted ~= nil then
			this.OnRoundStarted()
		end
	end
end

function this.IsAllReaded()
    if roomData.setting.size - 1 == #playerData  then
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

function this.OnAutoDissolve(msg)
    local body = pdk_pb.RAutoDissolve()
    body:ParseFromString(msg.body)

    IsAutoDissolve = true
	AutoDissolveData = body
	PanelManager.Instance:ShowWindow('panelAutoDissolve', AutoDissolveData)
    print('----------------------------------自动解散了----------------------------------------')
end

function this.StartCheckTrusteeship(seat, time)
	if TrusteeshipCoroutine then
		this.SopCheckTrusteeship()
	end

	TrusteeshipCoroutine = coroutine.start(this.CheckTrusteeship, seat, time == 0 and nil or time)
end

local showDelayTime = 10
function this.CheckTrusteeship(seat, time)

	if roomData.setting.trusteeship == nil 
		or roomData.setting.trusteeship == 0 or this.GetPlayerDataBySeat(mySeat).trusteeship then
		return 
	end
	
	if time == nil then
		time = roomData.setting.trusteeship
	end

	local delayTime = time - showDelayTime;
	print('----------------------------------开始检测托管剩余：'..delayTime..'--------------------------------')
	coroutine.wait(delayTime)

	local doweTime = delayTime < 0 and time or showDelayTime

	print('----------------------------------展示托管倒计时---------------------------------------')
	local timeLabel = TrusteeshipTip.transform:Find('Time')
	--if seat == mySeat then
	TrusteeshipTip.gameObject:SetActive(true)
	for i=doweTime, 1, -1 do
		timeLabel:GetComponent('UILabel').text = i
		coroutine.wait(1)
	end	
		--TrusteeshipTip.gameObject:SetActive(false)
	--else
		--coroutine.wait(doweTime)
	--end

	--this.RefreshTrusteeship()
	TrusteeshipCoroutine = nil
end

function this.SopCheckTrusteeship()
	print('----------------------------------停止托管倒计时---------------------------------------')
	coroutine.stop(TrusteeshipCoroutine)
	TrusteeshipCoroutine = nil
	TrusteeshipTip.gameObject:SetActive(false)
end

function this.RefreshTrusteeship()
	local msg = Message.New()
	msg.type = pdk_pb.REFRESH_TRUSTEESHIP
	SendGameMessage(msg)
end

function this.OnTrustesship(msg)
	local body = pdk_pb.RTrusteeship()
	body:ParseFromString(msg.body)

	print('-----------------------------------------有人托管了-------------------------------------------')
	print('托管的位置：'..tostring(body.seat))
	print('托管是否开启：'..tostring(body.enable))

	this.SetMyseflInTrustesship(body.seat, body.enable)

	this.GetPlayerDataBySeat(body.seat).trusteeship = body.enable
	playerTrusteeship[this.GetUIIndexBySeat(body.seat)].gameObject:SetActive(body.enable)
end

function this.SetMyseflInTrustesship(seat, enable)
	if seat == mySeat then
		this.SetCardDisable(not enable)
		TrusteeshipPanel.gameObject:SetActive(enable)
	end
end

function this.OnClickCancelTrustesship(go)
	local msg = Message.New()
	msg.type = pdk_pb.TRUSTEESHIP
	local body = pdk_pb.PTrusteeship()
	body.enable = false
	msg.body = body:SerializeToString();
	SendGameMessage(msg)
end

function this.SetCardDisable(isTrue)
	local handCards = playerGridIn[0]
	print('是否锁定牌'..tostring(isTrue))
	for i = 0, handCards.transform.childCount - 1 do
		local card = handCards.transform:GetChild(i)
		card.transform:GetComponent('BoxCollider').enabled = isTrue
	end
end

--开启打鸟
function this.OnEnablePlayNiao()
	print('------------------------启动打鸟-----------------------')
	PlayNiaoView.gameObject:SetActive(true)
	this.SetInviteVisiable(false)
	GPS.gameObject:SetActive(false)
end

function this.OnClickPlayNiao(go)
	local msg = Message.New()
	msg.type = pdk_pb.HIT_BIRD
	local body = pdk_pb.PHitBird()
	body.enable = go == PlayNiao.gameObject
	msg.body = body:SerializeToString()
	SendGameMessage(msg)
	print('------------------------选择打鸟：'..tostring(body.enable)..'-----------------------')
end

function this.OnPlayerChooseNiao(msg)
	local data = pdk_pb.RHitBird()
	data:ParseFromString(msg.body)
	print('------------------------有人选择了打鸟：'..'座位：'..data.seat..' '..tostring(data.enable)..'-----------------------')
	if data.seat == mySeat then
        PlayNiaoView.gameObject:SetActive(false)
	end
	this.GetPlayerDataBySeat(data.seat).hitBird = data.enable and 1 or 0
	playerNiao[this.GetUIIndexBySeat(data.seat)].gameObject:SetActive(data.enable)
end

function this.OnGameError(msg)
    local error = pdk_pb.RError()
    error:ParseFromString(msg.body)

    panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, error.info)
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
		print('-------------Mark----------', i)
		local coroutines =  playerOfflineCoroutines[i]
		if coroutines ~= nil then
			coroutine.stop(coroutines)
			coroutines = nil;
		end
	end
end

function this.OnPlayerEmoji(msg)
	local b = pdk_pb.RGift()
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
			local positionFrom = playerIcon[this.GetUIIndexBySeat(b.seat)].position;
			local positionTo = playerIcon[this.GetUIIndexBySeat(b.rseat)].position;
			local animation =playerAnimation[this.GetUIIndexBySeat(b.seat)];

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
		AudioManager.Instance:PlayAudio(soundName);
		for i = 1, index do
			playerAnimation[myseatinx]:GetComponent('UISprite').spriteName = name..'_'..i;
			playerAnimation[myseatinx].gameObject:GetComponent('UISprite'):MakePixelPerfect();
			coroutine.wait(time);
		end
		playerAnimation[myseatinx].gameObject:SetActive(false);
	end)
end

function this.OnPlayError(msg)
	print('OnPlayError : 请选择正确的牌型 ');
	panelMessageTip.SetParamers('请选择正确的牌型', 2)
	PanelManager.Instance:ShowWindow('panelMessageTip')
	CountDown.gameObject:SetActive(true);
	this.RefreshMyGridIn();
end