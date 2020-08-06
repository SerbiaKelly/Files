local panelRegisterAccount = {}
local this = panelRegisterAccount


local message
local gameObject

local backButton
local regID
local nickName
local pass
local passConfirm
local regButton
local getUserID

function this. Awake(go, mess)
	gameObject = go
    message = mess
	regButton 				= gameObject.transform:Find('regBtn')
	backButton 				= gameObject.transform:Find('backButton')
	regID 					= gameObject.transform:Find('regID')
	nickName 				= gameObject.transform:Find('nickName')
	pass 					= gameObject.transform:Find('pass')
	passConfirm 			= gameObject.transform:Find('passConfirm')
	
	message:AddClick(backButton.gameObject,		this.OnClickBack)
	message:AddClick(regButton.gameObject, 		this.onClickReg)
	EventDelegate.AddForLua(nickName:GetComponent('UIInput').onChange, this.OnNickNameInput)
	
	nickName:GetComponent('UIInput').submitOnUnselect = true
	pass:GetComponent('UIInput').submitOnUnselect = true
	passConfirm:GetComponent('UIInput').submitOnUnselect = true
	this.lastGetUserIDTime = -60
end

function this.OnEnable()
	regID:GetComponent('UIInput').value = '您的游戏ID：'
	nickName:GetComponent('UIInput').value = ''
	pass:GetComponent('UIInput').value = ''
	passConfirm:GetComponent('UIInput').value = ''
	getUserID = ''
	this.require_regID()
end

function this.require_regID()
	local msg = Message.New()
	msg.type = proxy_pb.OBTAIN_USER_ID
	SendProxyMessage(msg, this.OnGetResult)
end

function this.OnGetResult(msg)
	local b = proxy_pb.RObtainUserId()
    b:ParseFromString(msg.body)
	regID:GetComponent('UIInput').value = '您的游戏ID：'..b.userId
	getUserID = b.userId
	this.lastGetUserIDTime = Time.realtimeSinceStartup
end

function this.onClickReg(go)
	local msg = ''
	if not getUserID or getUserID == '' then
		msg = '游戏ID获取失败,请重新注册'
	elseif nickName:GetComponent('UIInput').value == '' or charachterIsLimit(nickName:GetComponent('UIInput').value, 14) then
		msg = '昵称长度错误,请输入不超过7个汉字'
	elseif string.len(pass:GetComponent('UIInput').value)<8 or string.len(pass:GetComponent('UIInput').value)>20 then
		msg = '密码不符合要求'
	elseif string.len(passConfirm:GetComponent('UIInput').value) ~= string.len(pass:GetComponent('UIInput').value) then
		msg = '请确认两次输入的密码是否正确'
	end
	
	if msg ~= '' then
		panelMessageTip.SetParamers(msg,1)
		PanelManager.Instance:ShowWindow('panelMessageTip')
		return
	else
		local msg = Message.New()
		msg.type = proxy_pb.REGISTER
		local msgBody = proxy_pb.PRegister()
		msgBody.userId = getUserID
		msgBody.nickname = nickName:GetComponent('UIInput').value
		msgBody.password = pass:GetComponent('UIInput').value
		msgBody.confirmPassword = passConfirm:GetComponent('UIInput').value
		if not UnityEngine.PlayerPrefs.HasKey(PLAYER_UUID) then
			UnityEngine.PlayerPrefs.SetString(PLAYER_UUID, UnityEngine.SystemInfo.deviceUniqueIdentifier)
		end
		msgBody.uuid = UnityEngine.PlayerPrefs.GetString(PLAYER_UUID)
		msgBody.platform = Util.GetPlatformStr()
		if msgBody.platform == 'ios' then
			msgBody.gamePack = proxy_pb.HPYX--新版本、嗨皮游戏
			if UnityEngine.Application.identifier == 'com.haipi.phz' then
				msgBody.gamePack = proxy_pb.HPJBCD --嗨皮绝不重叠
			end
		else
			msgBody.gamePack = proxy_pb.QYQM
		end
		msg.body = msgBody:SerializeToString()
		SendProxyMessage(msg, this.regAccountResult)
	end
end

function this.regAccountResult(msg)
	local data = proxy_pb.RResult()
	data:ParseFromString(msg.body)
	if data.code == 1 then
		panelMessageTip.SetParamers("注册成功",1)
		PanelManager.Instance:ShowWindow('panelMessageTip')
		UnityEngine.PlayerPrefs.SetString('game_account_id', getUserID)
		
		panelPhoneLogin.SetPanelState(panelPhoneLogin.GAMEID_LOGIN)
	end
	this.OnClickBack(go)
end

function this.OnClickBack(go)
	gameObject:SetActive(false)
end

local curr_value
function this.OnNickNameInput()
    local str = nickName:GetComponent('UIInput').value
    if charachterIsLimit(str, 14) then
        nickName:GetComponent('UIInput').value = curr_value
		return
    end
    curr_value = nickName:GetComponent('UIInput').value
end

return panelRegisterAccount