local phz_pb = require 'phz_pb'

panelDestroyRoom = {}
local this = panelDestroyRoom;

local message;
local gameObject;

local ButtonAccpet
local ButtonReject
local ButtonOK

local LabelMsg
local mask
local LabelTime

local coolDownTime = 300
local conFun

--启动事件--
function this.Awake(obj)
	gameObject = obj;

    mask = gameObject.transform:Find('mask');
    LabelMsg = gameObject.transform:Find('message');

    ButtonAccpet = gameObject.transform:Find('ButtonAccpet');
    ButtonReject = gameObject.transform:Find('ButtonReject');
	ButtonOK = gameObject.transform:Find('ButtonOK');
	LabelTime = gameObject.transform:Find('clock/Label');

	message = gameObject:GetComponent('LuaBehaviour');
    message:AddClick(ButtonAccpet.gameObject, this.OnClickButtonAccpet);
    message:AddClick(ButtonReject.gameObject, this.OnClickButtonReject);
	message:AddClick(ButtonOK.gameObject, this.OnClickButtonOK);
end
function this.Update()
   
end
function this.Start()
end

local choose = {}
local AgainstCount = 0;
function this.OnEnable()
	--coolDownTime = panelClub.clubInfo.waitTime * 60
	coolDownTime = DestroyRoomData.roomData.dissolution.remainMs + int64.tonum2(Util.GetTime())/1000
	print('remainMs:'..DestroyRoomData.roomData.dissolution.remainMs)
	conFun = coroutine.start(this.CoolDown)
	choose = {}  
	AgainstCount = 0

	if DestroyRoomData.roomData.dissolution.rejects ~= nil and #DestroyRoomData.roomData.dissolution.rejects ~= 0 then
		print('roomData.dissolution.rejects', #DestroyRoomData.roomData.dissolution.rejects)
		for i = 1, #DestroyRoomData.roomData.dissolution.rejects do
			this.Refresh(DestroyRoomData.roomData.dissolution.rejects[i])
		end
	else
		this.Refresh()
	end
end

function this.CoolDown()
	print('coolDownTime:'..coolDownTime- int64.tonum2(Util.GetTime())/1000)
	while coolDownTime - int64.tonum2(Util.GetTime())/1000 > 0 and gameObject.activeSelf do
		LabelTime:GetComponent('UILabel').text = string.format("%d秒后自动解散房间",coolDownTime - int64.tonum2(Util.GetTime())/1000)
		coroutine.wait(1)
	end
end

function this.Refresh(reject)
	local dissolveType = DestroyRoomData.roomData.dissolveType
	if panelInGame == panelInGame_xhzd then
		dissolveType = DestroyRoomData.roomData.setting.dissolveType
	elseif panelInGame == panelInGame_dtz then
		dissolveType = DestroyRoomData.roomData.setting.dissolveType
	end

	local str = ''
	local isCompleted = false

	if reject then
		choose[reject] = 2
		AgainstCount = AgainstCount + 1

		local pData = panelInGame.GetPlayerDataBySeat(reject)
		if dissolveType ~= 1 and  AgainstCount ~= 0 then
			isCompleted = true
			str = string.format('由于【%s】拒绝，房间解散失败，游戏继续', pData.name)
		else
			local maxAgainstCount = math.ceil(DestroyRoomData.roomData.setting.size / 2)

			if AgainstCount == maxAgainstCount then
				isCompleted = true
				str = string.format('由于同意人数少于一半，房间解散失败，游戏继续')
			end
		end
	end

	print('isCompleted:',isCompleted)
	print('AgainstCount:',AgainstCount)
	if isCompleted then
		LabelMsg:GetComponent('UILabel').text = str
		ButtonOK.gameObject:SetActive(true)
		ButtonReject.gameObject:SetActive(false)
		ButtonAccpet.gameObject:SetActive(false)
		coroutine.stop(conFun)
		choose = {}
		if DestroyRoomData.roomData.dissolution ~= nil and 
			DestroyRoomData.roomData.dissolution.rejects ~= nil and #DestroyRoomData.roomData.dissolution.rejects ~= 0 then
			tableClear(DestroyRoomData.roomData.dissolution.rejects)
		end
		return 
	end

	ButtonOK.gameObject:SetActive(false)
	ButtonReject.gameObject:SetActive(true)
	ButtonAccpet.gameObject:SetActive(true)
	local pData = panelInGame.GetPlayerDataBySeat(DestroyRoomData.roomData.dissolution.applicant)
	choose[pData.seat] = 1
	local str = string.format('【%s】申请解散房间，请等待其他玩家\r\n', pData.name)
	for k,v in ipairs(DestroyRoomData.roomData.dissolution.acceptors) do
		pData = panelInGame.GetPlayerDataBySeat(v)
		choose[pData.seat] = 1
		if pData.seat ~= DestroyRoomData.roomData.dissolution.applicant then
			local str_acceptors = string.format('【%s】同意解散房间\r\n', pData.name)
			str = str .. str_acceptors
		end
	end
	print('playerData : '..#DestroyRoomData.playerData)
	for i=0,#DestroyRoomData.playerData do
		pData = DestroyRoomData.playerData[i]
		if pData ~= nil then
			if not choose[pData.seat] then
				local s = string.format('【%s】等待选择\r\n', pData.name)
				str = str .. s
			elseif choose[pData.seat] == 2 then
				local s = string.format('【%s】已拒绝\r\n', pData.name)
				str = str .. s
			end
		end
	end
	str = str .. '(到达剩余时间后未做选择，则默认同意)'
	LabelMsg:GetComponent('UILabel').text = str
	
	if choose[DestroyRoomData.mySeat] then
		ButtonReject.gameObject:SetActive(false)
		ButtonAccpet.gameObject:SetActive(false)
	end
end

--单击事件--
function this.OnClickMask(go)
	coroutine.stop(conFun)
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickButtonReject(go)
	AudioManager.Instance:PlayAudio('btn')
	if panelInGame == panelInGame_pdk then
		local msg = Message.New()
		msg.type = pdk_pb.DISSOLVE_REJECT
		--local body = pdk_pb.DISSOLVE_REJECT()
		--body.decision = pdk_pb.AGAINST
		--msg.body = body:SerializeToString()
		SendGameMessage(msg, nil)
	elseif panelInGame == panelInGameLand then
		local msg = Message.New()
		msg.type = phz_pb.DISSOLVE
		local body = phz_pb.PDissolve()
		body.decision = phz_pb.AGAINST
		msg.body = body:SerializeToString()
		SendGameMessage(msg, nil)
	elseif panelInGame == panelInGamemj then
		local msg = Message.New()
		msg.type = csm_pb.DISSOLVE
		local body = csm_pb.PDissolve()
		body.decision = csm_pb.AGAINST
		msg.body = body:SerializeToString()
		SendGameMessage(msg, nil)
	elseif panelInGame == panelInGame_xhzd then
		local msg = Message.New()
		msg.type = xhzd_pb.DISSOLVE
		local body = xhzd_pb.PDissolve()
		body.decision = xhzd_pb.AGAINST
		msg.body = body:SerializeToString()
		SendGameMessage(msg, nil)
	elseif panelInGame == panelInGame_dtz then
		local msg = Message.New()
		msg.type = dtz_pb.DISSOLVE
		local body = dtz_pb.PDissolve()
		body.decision = dtz_pb.AGAINST
		msg.body = body:SerializeToString()
		SendGameMessage(msg, nil)
	elseif panelInGame == panelInGame_bbtz then
		local msg = Message.New()
		msg.type = bbtz_pb.DISSOLVE
		local body = bbtz_pb.PDissolve()
		body.decision = bbtz_pb.AGAINST
		msg.body = body:SerializeToString()
		SendGameMessage(msg, nil)
	elseif panelInGame == panelInGame_xplp then 
		local msg = Message.New()
		msg.type = xplp_pb.DISSOLVE
		local body = xplp_pb.PDissolve()
		body.decision = xplp_pb.AGAINST
		msg.body = body:SerializeToString()
		SendGameMessage(msg, nil)
	elseif panelInGame == panelInGame_hnhsm then 
		local msg = Message.New()
		msg.type = hnm_pb.DISSOLVE
		local body = hnm_pb.PDissolve()
		body.decision = hnm_pb.AGAINST
		msg.body = body:SerializeToString()
		SendGameMessage(msg, nil)
	elseif panelInGame == panelInGame_hnzzm then 
		local msg = Message.New()
		msg.type = hnm_pb.DISSOLVE
		local body = hnm_pb.PDissolve()
		body.decision = hnm_pb.AGAINST
		msg.body = body:SerializeToString()
		SendGameMessage(msg, nil)
	elseif panelInGame == panelInGame_yjqf then 
		local msg = Message.New()
		msg.type = yjqf_pb.DISSOLVE
		local body = yjqf_pb.PDissolve()
		body.decision = yjqf_pb.AGAINST
		msg.body = body:SerializeToString()
		SendGameMessage(msg, nil)
	elseif panelInGame == panelInGame_dzahm then 
		local msg = Message.New()
		msg.type = dzm_pb.DISSOLVE
		local body = dzm_pb.PDissolve()
		body.decision = dzm_pb.AGAINST
		msg.body = body:SerializeToString()
		SendGameMessage(msg, nil)
	end
	ButtonReject.gameObject:SetActive(false)
	ButtonAccpet.gameObject:SetActive(false)
end

function this.OnClickButtonAccpet(go)
	AudioManager.Instance:PlayAudio('btn')
	if panelInGame == panelInGame_pdk then
		local msg = Message.New()
		msg.type = pdk_pb.DISSOLVE_ACCEPT
		--local body = pdk_pb.PDissolve()
		 --body.decision = pdk_pb.AGREE
		 --msg.body = body:SerializeToString()
		SendGameMessage(msg, nil)
	elseif panelInGame == panelInGameLand then
		local msg = Message.New()
		msg.type = phz_pb.DISSOLVE
		local body = phz_pb.PDissolve()
		body.decision = phz_pb.AGREE
		msg.body = body:SerializeToString()
		SendGameMessage(msg, nil)
	elseif panelInGame == panelInGamemj then
		local msg = Message.New()
		msg.type = csm_pb.DISSOLVE
		local body = csm_pb.PDissolve()
		body.decision = csm_pb.AGREE
		msg.body = body:SerializeToString()
		SendGameMessage(msg, nil)
	elseif panelInGame == panelInGame_xhzd then
		local msg = Message.New()
		msg.type = xhzd_pb.DISSOLVE
		local body = xhzd_pb.PDissolve()
		body.decision = xhzd_pb.AGREE
		msg.body = body:SerializeToString()
		SendGameMessage(msg, nil);
	elseif panelInGame == panelInGame_dtz then
		local msg 		= Message.New();
		msg.type 		= dtz_pb.DISSOLVE;
		local body 		= dtz_pb.PDissolve();
		body.decision 	= dtz_pb.AGREE;
		msg.body 		= body:SerializeToString();
		SendGameMessage(msg, nil);
	elseif panelInGame == panelInGame_bbtz then
		local msg 		= Message.New();
		msg.type 		= bbtz_pb.DISSOLVE;
		local body 		= bbtz_pb.PDissolve();
		body.decision 	= bbtz_pb.AGREE;
		msg.body 		= body:SerializeToString();
		SendGameMessage(msg, nil);
	elseif panelInGame == panelInGame_xplp then 
		local msg 		= Message.New();
		msg.type 		= xplp_pb.DISSOLVE;
		local body 		= xplp_pb.PDissolve();
		body.decision 	= xplp_pb.AGREE;
		msg.body 		= body:SerializeToString();
		SendGameMessage(msg, nil);
	elseif panelInGame == panelInGame_hnhsm then 
		local msg 		= Message.New();
		msg.type 		= hnm_pb.DISSOLVE;
		local body 		= hnm_pb.PDissolve();
		body.decision 	= hnm_pb.AGREE;
		msg.body 		= body:SerializeToString();
		SendGameMessage(msg, nil);
	elseif panelInGame == panelInGame_hnzzm then 
		local msg 		= Message.New();
		msg.type 		= hnm_pb.DISSOLVE;
		local body 		= hnm_pb.PDissolve();
		body.decision 	= hnm_pb.AGREE;
		msg.body 		= body:SerializeToString();
		SendGameMessage(msg, nil);
	elseif panelInGame == panelInGame_yjqf then 
		local msg 		= Message.New();
		msg.type 		= yjqf_pb.DISSOLVE;
		local body 		= yjqf_pb.PDissolve();
		body.decision 	= yjqf_pb.AGREE;
		msg.body 		= body:SerializeToString();
		SendGameMessage(msg, nil);
	elseif panelInGame == panelInGame_dzahm then 
		local msg 		= Message.New();
		msg.type 		= dzm_pb.DISSOLVE;
		local body 		= dzm_pb.PDissolve();
		body.decision 	= dzm_pb.AGREE;
		msg.body 		= body:SerializeToString();
		SendGameMessage(msg, nil);
	end
	ButtonReject.gameObject:SetActive(false)
	ButtonAccpet.gameObject:SetActive(false)
end

function this.OnClickButtonOK(go)
	AudioManager.Instance:PlayAudio('btn')
    this.OnClickMask(go)
end