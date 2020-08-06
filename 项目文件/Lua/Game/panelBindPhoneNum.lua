local proxy_pb = require 'proxy_pb'

panelBindPhoneNum = {}
local this = panelBindPhoneNum

this.BIND_PHONE = 1--绑定手机
this.BIND_SET = 2--设置密码
this.CHANGE_PHONE=3--修改绑定手机
this.CHANGE_PASSWORD = 4--修改密码
local gameObject
local message
local ButtonClose
local input
local ButtonBind
local yanZhengMa
local ButtonGet
local lastTime
local titleLabel
local InputPass1
local InputPass2
local tipsLabel

local bindErrorNum = 0
local currentState

local verifyCoroutine
local isCountDown = false
--启动事件--
function this.Awake(obj)
	gameObject = obj

	ButtonClose 	= gameObject.transform:Find('BaseContent/ButtonClose')
	input 			= gameObject.transform:Find('right/Input')
	ButtonBind 		= gameObject.transform:Find('right/ButtonBind')
	yanZhengMa 		= gameObject.transform:Find('right/yanZhengMa')
	ButtonGet 		= gameObject.transform:Find('right/ButtonGet')
	lastTime 		= gameObject.transform:Find('right/lastTime')

	InputPass1 		= gameObject.transform:Find('right/InputPass1');
	InputPass2 		= gameObject.transform:Find('right/InputPass2');
	tipsLabel 		= gameObject.transform:Find('Tips');
	titleLabel		= gameObject.transform:Find('BaseContent/Label1');
	message 		= gameObject:GetComponent('LuaBehaviour')

    message:AddClick(ButtonClose.gameObject, 	this.OnButtonClose)
	message:AddClick(ButtonBind.gameObject, 	this.OnClickButtonBind)
	message:AddClick(ButtonGet.gameObject, 		this.OnClickButtonGet)
	EventDelegate.AddForLua(input:GetComponent('UIInput').onChange, this.OnInputSubmit)
end
function this.Update()
   
end
function this.Start()
end

function this.OnEnable()

end

function this.SetPanelState(state)
	currentState = state;
	ButtonClose.gameObject:SetActive(true)
	if state == this.BIND_PHONE or state == this.CHANGE_PHONE then
		ButtonGet.gameObject:SetActive(true);
		input.gameObject:SetActive(true);
		input:GetComponent('BoxCollider').enabled = true
		input:GetComponent("UIInput").value = "";
		input:GetComponent('UIInput').defaultText = "请输入手机号码";
		yanZhengMa.gameObject:SetActive(true);
		yanZhengMa:GetComponent("UIInput").value = "";
		yanZhengMa:GetComponent('UIInput').defaultText = "请输入验证码";
		InputPass1.gameObject:SetActive(false);
		InputPass2.gameObject:SetActive(false);
		ButtonGet:GetComponent('UIButton').isEnabled = false;
		tipsLabel:Find("Label"):GetComponent("UILabel").text = state == this.BIND_PHONE and "为了您的账号安全，请绑定手机号码，绑定后可使用手机号登录" or ''
		titleLabel:GetComponent("UILabel").text = state == this.BIND_PHONE and "绑定手机" or '修改绑定手机'
		lastTime.gameObject:SetActive(isCountDown);
	elseif state == this.BIND_SET or state == this.CHANGE_PASSWORD then
		ButtonGet.gameObject:SetActive(false);
		input.gameObject:SetActive(false);
		yanZhengMa.gameObject:SetActive(false);
		InputPass1.gameObject:SetActive(true);
		InputPass1:GetComponent('UIInput').defaultText = "请输入8-20位的数字和字母组合";
		InputPass1:GetComponent("UIInput").value = "";
		InputPass2.gameObject:SetActive(true);
		InputPass2:GetComponent('UIInput').defaultText = "请再次输入密码";
		InputPass2:GetComponent("UIInput").value = "";
		tipsLabel:Find("Label"):GetComponent("UILabel").text = state == this.BIND_SET and ("请牢记您的游戏ID（"..userInfo.id.."）与设置的密码，设置后可使用游戏ID与密码登录") or ''
		titleLabel:GetComponent("UILabel").text = state == this.BIND_SET and "设置密码" or '修改密码'
		lastTime.gameObject:SetActive(false);
		if state == this.BIND_SET then
			ButtonClose.gameObject:SetActive(false)
		end
	end
end

function this.OnClickButtonBind(go)
	AudioManager.Instance:PlayAudio('btn')
	if currentState == this.BIND_PHONE or currentState == this.CHANGE_PHONE then
		if input:GetComponent('UIInput').value=='' then
			panelMessageTip.SetParamers("请输入手机号码",1,nil)
			PanelManager.Instance:ShowWindow('panelMessageTip')
			return
		end
		if string.len(input:GetComponent('UIInput').value)~=11 then
			panelMessageTip.SetParamers("请输入正确的手机号码",1,nil)
			PanelManager.Instance:ShowWindow('panelMessageTip')
			return
		end
		if string.len(yanZhengMa:GetComponent('UIInput').value) ~= 6 then
			panelMessageTip.SetParamers("输入的验证码长度不符合要求",1,nil)
			PanelManager.Instance:ShowWindow('panelMessageTip')
			return
		end
	end
	if currentState == this.BIND_SET or currentState == this.CHANGE_PASSWORD then
		if string.len(InputPass1:GetComponent("UIInput").value) < 8 or string.len(InputPass1:GetComponent("UIInput").value) > 20 then
			panelMessageTip.SetParamers("输入的密码长度不符合要求",1,nil)
			PanelManager.Instance:ShowWindow('panelMessageTip')
			return
		end
		if InputPass1:GetComponent("UIInput").value ~= InputPass2:GetComponent("UIInput").value then
			panelMessageTip.SetParamers("两次输入的密码不一致",1,nil)
			PanelManager.Instance:ShowWindow('panelMessageTip')
			return
		end
	end
	if currentState == this.BIND_PHONE then
		this.SendBindMsg()
	elseif currentState == this.BIND_SET then
		this.SendSetPassWordMsg()
	elseif currentState == this.CHANGE_PHONE then
		this.SendChangePhoneMsg()
	elseif currentState == this.CHANGE_PASSWORD then
		this.SendChangePassWordMsg()
	end
end

function this.SendBindMsg()
	local msg 		= Message.New();
	msg.type 		= proxy_pb.CHECK_SMS_CODE;
	local body 		= proxy_pb.PCheckSmsCode();
	body.verifyCode = yanZhengMa:GetComponent('UIInput').value;
	msg.body 		= body:SerializeToString();
	SendProxyMessage(msg, this.OnBindResult);
end

function this.SendSetPassWordMsg()
	local msg = Message.New();
	msg.type = proxy_pb.SET_PASSWORD
	local msgBody = proxy_pb.PSetPassword()
	msgBody.password = InputPass2:GetComponent("UIInput").value
	msg.body = msgBody:SerializeToString()
	SendProxyMessage(msg,function (msg)
		local data = proxy_pb.RResult()
		data:ParseFromString(msg.body)
		if data.code == 1 then
			panelMessageTip.SetParamers("密码设置成功",1,nil)
			PanelManager.Instance:ShowWindow('panelMessageTip')
			PanelManager.Instance:HideWindow(gameObject.name)
			userInfo.passWord = true
			if panelMInfo then
				panelMInfo.RefreshPhone()
			end
			this.OnButtonClose()
		end
	end);
end

function this.SendChangePhoneMsg()
	local msg 		= Message.New();
	msg.type 		= proxy_pb.CHECK_SMS_CODE;
	local body 		= proxy_pb.PCheckSmsCode();
	body.verifyCode = yanZhengMa:GetComponent('UIInput').value;
	msg.body 		= body:SerializeToString();
	SendProxyMessage(msg,function (msg)
		local b = proxy_pb.RResult();
		b:ParseFromString(msg.body);
		if b.code==1 then
			info_login.phone = input:GetComponent('UIInput').value
			userInfo.phone = info_login.phone
			input:GetComponent('BoxCollider').enabled = false
			panelMessageTip.SetParamers('修改绑定手机成功', 1.5);
			PanelManager.Instance:ShowWindow('panelMessageTip')
			PanelManager.Instance:HideWindow(gameObject.name)
			panelMInfo.RefreshPhone()
			this.OnButtonClose()
		else
			yanZhengMa:GetComponent('UIInput').value=''
			panelMessageTip.SetParamers('修改绑定手机失败'..b.msg, 1.5)
			PanelManager.Instance:ShowWindow('panelMessageTip')
		end
	end);
end

function this.SendChangePassWordMsg()
	local msg = Message.New();
	msg.type = proxy_pb.SET_PASSWORD
	local msgBody = proxy_pb.PSetPassword()
	msgBody.password = InputPass2:GetComponent("UIInput").value
	msg.body = msgBody:SerializeToString()
	SendProxyMessage(msg,function (msg)
		local data = proxy_pb.RResult()
		data:ParseFromString(msg.body)
		if data.code == 1 then
			panelMessageTip.SetParamers("密码修改成功",1,nil)
			PanelManager.Instance:ShowWindow('panelMessageTip')
			PanelManager.Instance:HideWindow(gameObject.name)
			userInfo.passWord = true
			panelMInfo.RefreshPhone()
			this.OnButtonClose()
		end
	end)
end

function this.OnClickButtonGet(go)
	ButtonGet:GetComponent('UIButton').isEnabled = false
	local msg 		= Message.New()
	msg.type 		= proxy_pb.OBTAIN_SMS_CODE;
	local body 		= proxy_pb.PObtainSmsCode();
	body.phone 		= input:GetComponent('UIInput').value;
	body.gameType	=proxy_pb.PHZ;
	body.gamePack   =proxy_pb.HPYX--对应不同的包传不同的值
	msg.body 		= body:SerializeToString();
	SendProxyMessage(msg, nil)
	
	print('获取验证码'..input:GetComponent('UIInput').value)
	if verifyCoroutine ~= nil then
		coroutine.stop(verifyCoroutine);
	end
	isCountDown = true;
	verifyCoroutine = coroutine.start(
			function()
				lastTime:GetComponent('UILabel').text=60
				lastTime.gameObject:SetActive(true)
				for i=59,0,-1 do
					coroutine.wait(1)
					lastTime:GetComponent('UILabel').text=i
				end
				isCountDown = false;
				lastTime.gameObject:SetActive(false)
				if string.len(input:GetComponent('UIInput').value)==11 then
					ButtonGet:GetComponent('UIButton').isEnabled = true;
				end
			end
	)
end

function this.OnInputSubmit(go)
	if string.len(input:GetComponent('UIInput').value)==11 then
		ButtonGet:GetComponent('UIButton').isEnabled = not isCountDown;
	else
		ButtonGet:GetComponent('UIButton').isEnabled = false
	end
end

function this.WhoShow(data)
	this.SetPanelState(data)
end

function this.OnBindResult(msg)
	local b = proxy_pb.RResult();
    b:ParseFromString(msg.body);
	if b.code==1 then
		info_login.phone = input:GetComponent('UIInput').value
		userInfo.phone = info_login.phone
		input:GetComponent('BoxCollider').enabled = false
		panelMessageTip.SetParamers('绑定成功', 1.5);
		PanelManager.Instance:ShowWindow('panelMessageTip')
		this.OnButtonClose()
		--this.SetPanelState(this.BIND_SET)
	else
		yanZhengMa:GetComponent('UIInput').value=''
		panelMessageTip.SetParamers('绑定失败'..b.msg, 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	end
end

function this.OnButtonClose(go)
    PanelManager.Instance:HideWindow(gameObject.name)
end