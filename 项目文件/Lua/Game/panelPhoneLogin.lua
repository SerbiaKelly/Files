require 'common'
require	'logic'
local panelRegisterAccount = require 'panelRegisterAccount'

panelPhoneLogin = {}
local this = panelPhoneLogin

this.PHONE_LOGIN = 1; --手机号登录
this.CODE_LOGIN = 2;  --手机验证码登录
this.FORGET_PASS = 3;	--忘记密码
this.UPDATE_PASS = 4;	--设置新密码
this.GAMEID_LOGIN = 5;	--游戏ID登录
this.REG_ACCOUNT = 6;	--注册新账号


local message
local gameObject

local phoneInput
local verificationInput
local loginBtn
local getBtn
local lastTime
local closeButton
local beginAction
local currentState = PHONE_LOGIN
local forgetPassWordLabel;
local loginByCodeLable;
local loginByPassWordLable;
local backButton;
local Inputpass1;
local Inputpass2;
local verifyCoroutine;
local regAccount
local PanelReg
local isCountDown = false;



function this.Awake(go)
	gameObject = go
	gameObject.transform:SetParent(panelLogin.gameObject.transform)
    message 				= gameObject:GetComponent('LuaBehaviour')

    loginBtn 				= gameObject.transform:Find('LoginBtn')
    lastTime 				= gameObject.transform:Find('LastTime')
    getBtn 					= gameObject.transform:Find('GetVerificationBtn')
    phoneInput 				= gameObject.transform:Find('InputPhone')
    verificationInput 		= gameObject.transform:Find('InputVerification')
    closeButton 			= gameObject.transform:Find('BaseContent/ButtonClose')

	forgetPassWordLabel 	= gameObject.transform:Find('forgetPassWord');
	loginByCodeLable 		= gameObject.transform:Find('loginByCode');
	loginByPassWordLable 	= gameObject.transform:Find('loginByPassWord');
	backButton 				= gameObject.transform:Find('backButton');
	Inputpass1 				= gameObject.transform:Find('Inputpass1');
	Inputpass2 				= gameObject.transform:Find('Inputpass2');
	regAccount 				= gameObject.transform:Find('regAccount');
	PanelReg				= gameObject.transform:Find('PanelReg');
	
    message:AddClick(getBtn.gameObject, 			this.OnGetVerification)
    message:AddClick(loginBtn.gameObject, 			this.OnPhoneLogin)
    message:AddClick(closeButton.gameObject, function (go)
        PanelManager.Instance:HideWindow(gameObject.name)
    end)

	message:AddClick(forgetPassWordLabel.gameObject, 	this.OnForgetPassClick);
	message:AddClick(loginByCodeLable.gameObject,		this.OnLoginByCodeClick);
	message:AddClick(loginByPassWordLable.gameObject,	this.OnLoginByPassClick);
	message:AddClick(regAccount.gameObject,				this.OnClickRegAccount);
	message:AddClick(backButton.gameObject,				this.OnClickBack);

	panelRegisterAccount.Awake(PanelReg.gameObject,message)
end

function this.OnEnable()
end

function this.WhoShow(data)
	this.SetPanelState(data and data.state or currentState)
	if currentState == this.PHONE_LOGIN or currentState == this.GAMEID_LOGIN then
		beginAction = currentState
	end
end

function this.Update()
end

function this.OnForgetPassClick(go)
	this.SetPanelState(this.FORGET_PASS)
end

function this.OnLoginByCodeClick(go)
	this.SetPanelState(this.CODE_LOGIN)
end

function this.OnLoginByPassClick(go)
	this.SetPanelState(this.PHONE_LOGIN)
end

function this.OnClickRegAccount(go)
	if (Time.realtimeSinceStartup - panelRegisterAccount.lastGetUserIDTime) > 60 then
		PanelReg.gameObject:SetActive(true)
		panelRegisterAccount.OnEnable()
	else
		panelMessageTip.SetParamers("您注册太频繁请稍后再试",1)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	end
end


function this.SetPanelState(state)
	if state ~= currentState then
		phoneInput:GetComponent("UIInput").value = "";
		Inputpass2:GetComponent("UIInput").value = "";
	end
	currentState = state;
	forgetPassWordLabel.gameObject:SetActive(false);
	loginByCodeLable.gameObject:SetActive(false);
	loginByPassWordLable.gameObject:SetActive(false);
	Inputpass1.gameObject:SetActive(false);
	Inputpass2.gameObject:SetActive(false);
	verificationInput.gameObject:SetActive(false);
	phoneInput.gameObject:SetActive(false);
	getBtn.gameObject:SetActive(false);
	backButton.gameObject:SetActive(false);
	lastTime.gameObject:SetActive(false);
	regAccount.gameObject:SetActive(false)

	if state == this.PHONE_LOGIN then
		forgetPassWordLabel.gameObject:SetActive(true);
		loginByCodeLable.gameObject:SetActive(true);
		Inputpass2.gameObject:SetActive(true);
		phoneInput.gameObject:SetActive(true);
		loginBtn:Find("Label"):GetComponent("UILabel").text = "登录";
		this.SetTitle("手机登录");
		phoneInput:GetComponent('UIInput').defaultText = "请输入手机号码";
		Inputpass2:GetComponent('UIInput').defaultText = "请输入登录密码";
	elseif state == this.CODE_LOGIN then
		loginByPassWordLable.gameObject:SetActive(true);
		verificationInput.gameObject:SetActive(true);
		phoneInput.gameObject:SetActive(true);
		getBtn.gameObject:SetActive(true);
		backButton.gameObject:SetActive(true);
		loginBtn:Find("Label"):GetComponent("UILabel").text = "登录";
		this.SetTitle("手机登录");
		phoneInput:GetComponent('UIInput').defaultText = "请输入手机号码";
		verificationInput:GetComponent("UIInput").value = "";
		verificationInput:GetComponent('UIInput').defaultText = " 请输入验证码";
		lastTime.gameObject:SetActive(isCountDown);
	elseif state == this.FORGET_PASS then
		verificationInput.gameObject:SetActive(true);
		phoneInput.gameObject:SetActive(true);
		getBtn.gameObject:SetActive(true);
		backButton.gameObject:SetActive(true);
		loginBtn:Find("Label"):GetComponent("UILabel").text = "下一步";
		this.SetTitle("忘记密码");
		phoneInput:GetComponent('UIInput').defaultText = "请输入手机号码";
		verificationInput:GetComponent("UIInput").value = "";
		verificationInput:GetComponent('UIInput').defaultText = " 请输入验证码";
		lastTime.gameObject:SetActive(isCountDown);
	elseif state == this.UPDATE_PASS then
		Inputpass1.gameObject:SetActive(true);
		Inputpass2.gameObject:SetActive(true);
		backButton.gameObject:SetActive(true);
		loginBtn:Find("Label"):GetComponent("UILabel").text = "确定";
		this.SetTitle("设置新密码");
		Inputpass1:GetComponent('UIInput').defaultText = "请输入8-20位的数字和字母组合";
		Inputpass1:GetComponent("UIInput").value = "";
		Inputpass2:GetComponent('UIInput').defaultText = "请再次输入密码";
		loginBtn:GetComponent("UIButton").isEnabled = true;
	elseif state == this.GAMEID_LOGIN then
		forgetPassWordLabel.gameObject:SetActive(true);
		Inputpass2.gameObject:SetActive(true);
		phoneInput.gameObject:SetActive(true);
		regAccount.gameObject:SetActive(true)
		loginBtn:Find("Label"):GetComponent("UILabel").text = "登录";
		this.SetTitle("账号登录");
		phoneInput:GetComponent('UIInput').defaultText = '请输入游戏ID'
		Inputpass2:GetComponent('UIInput').defaultText = "请输入登录密码";
		local accountID = UnityEngine.PlayerPrefs.GetString('game_account_id')
		if accountID ~= '' then
			phoneInput:GetComponent('UIInput').value = accountID
		end
	end
end

function this.SetTitle(titleText)
	gameObject.transform:Find("BaseContent/Label1"):GetComponent("UILabel").text = titleText;
	gameObject.transform:Find("BaseContent/Label2"):GetComponent("UILabel").text = titleText;
end

function this.OnClickBack(go)
	local backAction
	if currentState == this.CODE_LOGIN then
		backAction = this.PHONE_LOGIN
	elseif currentState == this.UPDATE_PASS then
		backAction = this.FORGET_PASS
	elseif currentState == this.REG_ACCOUNT then
		backAction = this.GAMEID_LOGIN
	elseif currentState == this.FORGET_PASS then
		backAction = beginAction
	else
		return
	end
	this.SetPanelState(backAction)
end

--[[function this.OnGetResult(msg)
	local b = proxy_pb.RResult();
    b:ParseFromString(msg.body);
	if b.code==1 then
		this.setGetBtn(not isCountDown);
	else
		panelMessageBox.SetParamers(ONLY_OK, this.weixinLogin, nil, '手机号未绑定，需要获取微信信息方可登录',"微信登录",nil,nil,nil,true);
		PanelManager.Instance:ShowWindow('panelMessageBox');
	end
end

function this.weixinLogin()
	panelLogin.isPhoneLogin=true
	PlatformManager.Instance:Login()
end]]--

function this.OnGetVerification(go)
	if string.len(phoneInput:GetComponent("UIInput").value) ~= 11 then
		panelMessageTip.SetParamers('请输入正确的手机号码',1)
		PanelManager.Instance:ShowWindow('panelMessageTip')
		return
	end

    local msg = Message.New()
    msg.type = proxy_pb.LOGIN_SMS_CODE
    local body = proxy_pb.PObtainSmsCode()
	body.phone = phoneInput:GetComponent('UIInput').value
	body.gameType=proxy_pb.PHZ
	body.gamePack=proxy_pb.HPYX--对应不同的包传不同的值
	msg.body = body:SerializeToString()
	SendProxyMessage(msg, nil)

	if verifyCoroutine ~= nil then
		coroutine.stop(verifyCoroutine);
	end
	isCountDown = true;
	verifyCoroutine = coroutine.start(
		function()
			lastTime:GetComponent('UILabel').text=60
            lastTime.gameObject:SetActive(true)
            this.setGetBtn(false)
			for i=59,0,-1 do
				coroutine.wait(1)
				lastTime:GetComponent('UILabel').text=i
			end
			isCountDown = false;
			lastTime.gameObject:SetActive(false)
			this.setGetBtn(true)
		end
	)

end

function this.setGetBtn(isOn)
	getBtn:GetComponent('UIButton').isEnabled = isOn
end


function this.OnPhoneLogin(go)
	if currentState == this.FORGET_PASS then
		this.CheckVerifyCode();
	elseif currentState == this.CODE_LOGIN then
		this.SendLoginMsg();
	elseif currentState == this.UPDATE_PASS then
		this.SendNewPassMsg();
	elseif currentState == this.PHONE_LOGIN then
		this.SendLoginMsg();
	elseif currentState == this.GAMEID_LOGIN then
		this.SendLoginMsg();
	end
end

--向服务器发送修改密码的校验码验证
function this.CheckVerifyCode()
	if string.len(verificationInput:GetComponent('UIInput').value)~=6 or 
	string.len(phoneInput:GetComponent("UIInput").value) ~= 11 then
		panelMessageTip.SetParamers('请输入正确的手机号码或验证码',1)
		PanelManager.Instance:ShowWindow('panelMessageTip')
		return
	end
	
	local msg 			= Message.New();
	msg.type 			= proxy_pb.CHECK_VERIFY_CODE;
	local msgBody 		= proxy_pb.PCheckCerifyCode();
	msgBody.phone 		= phoneInput:GetComponent("UIInput").value;
	msgBody.verifyCode 	= verificationInput:GetComponent("UIInput").value;
	msg.body 			= msgBody:SerializeToString();

	SendProxyMessage(msg, function (msg)
		print("checke verify return!");
		local data = proxy_pb.RResult();
		data:ParseFromString(msg.body);
		if data.code == 1 then
			local phone = phoneInput:GetComponent("UIInput").value
			this.SetPanelState(this.UPDATE_PASS);
			phoneInput:GetComponent("UIInput").value = phone
		else
			panelMessageBox.SetParamers(ONLY_OK, nil, nil, '验证码不正确');
			PanelManager.Instance:ShowWindow('panelMessageBox');
		end

	end);
end


function this.SendLoginMsg()
	local errMsg = ''
	if currentState == this.PHONE_LOGIN then
		if string.len(phoneInput:GetComponent("UIInput").value) ~= 11 then
			errMsg = '请输入正确的手机号码'
		elseif string.len(Inputpass2:GetComponent("UIInput").value) < 8 or string.len(Inputpass2:GetComponent("UIInput").value) > 20 then
			errMsg = '输入的密码长度不符合要求'
		end
	elseif currentState == this.CODE_LOGIN then
		if string.len(phoneInput:GetComponent("UIInput").value) ~= 11 then
			errMsg = '请输入正确的手机号码'
		elseif string.len(verificationInput:GetComponent("UIInput").value) ~= 6 then
			errMsg = '输入的验证码长度不符合要求'
		end
	elseif currentState == this.GAMEID_LOGIN then
		if string.len(phoneInput:GetComponent("UIInput").value) ~= 7 then
			errMsg = '请输入正确的游戏ID'
		elseif string.len(Inputpass2:GetComponent("UIInput").value) < 8 or string.len(Inputpass2:GetComponent("UIInput").value) > 20 then
			errMsg = '输入的密码长度不符合要求'
		end
	end
	
	if errMsg ~= '' then
		panelMessageTip.SetParamers(errMsg,1,nil)
		PanelManager.Instance:ShowWindow('panelMessageTip')
		return
	end
	
	local msg = Message.New()
	msg.type = proxy_pb.AUTHENTICATE
	local body = proxy_pb.PAuthenticate();
	if UnityEngine.PlayerPrefs.HasKey(PLAYER_SESSION_ID) then
		body.sessionId = UnityEngine.PlayerPrefs.GetString(PLAYER_SESSION_ID)
	end
	if not UnityEngine.PlayerPrefs.HasKey(PLAYER_UUID) then
		UnityEngine.PlayerPrefs.SetString(PLAYER_UUID, UnityEngine.SystemInfo.deviceUniqueIdentifier)
	end
	body.uuid 		= UnityEngine.PlayerPrefs.GetString(PLAYER_UUID)
	body.platform 	= Util.GetPlatformStr();
	body.phone 		= phoneInput:GetComponent('UIInput').value
	
	if currentState == this.PHONE_LOGIN then
		body.password = Inputpass2:GetComponent('UIInput').value;
	elseif currentState == this.CODE_LOGIN then
		body.verifyCode = verificationInput:GetComponent('UIInput').value
	elseif currentState == this.GAMEID_LOGIN then
		body.userId = body.phone
		body.password = Inputpass2:GetComponent('UIInput').value;
		body.phone 		= '';
		UnityEngine.PlayerPrefs.SetString('game_account_id', body.userId)
	end

	if panelLogin.code then
		body.code = panelLogin.code
	end
	msg.body = body:SerializeToString()

	print(' uuid:'..body.uuid..' platform:'..body.platform..' phone:'..body.phone..' verfyCode:'..body.verifyCode..' userId:'..body.userId)
	SendProxyMessage(msg, panelLogin.LoginRes)
end

function this.SendNewPassMsg()
	if string.len(Inputpass1:GetComponent("UIInput").value) < 8 or string.len(Inputpass1:GetComponent("UIInput").value) > 20 then
		panelMessageTip.SetParamers("输入的密码长度不符合要求",1,nil)
		PanelManager.Instance:ShowWindow('panelMessageTip')
		return
	end

	if Inputpass1:GetComponent("UIInput").value ~= Inputpass2:GetComponent("UIInput").value then
		panelMessageTip.SetParamers("两次输入的密码不一致",1,nil)
		PanelManager.Instance:ShowWindow('panelMessageTip')
		return
	end
		
	local msg = Message.New();
	msg.type = proxy_pb.UPDATE_USER_PASSWORD;

	local msgBody = proxy_pb.PUpdateUserPassword();
	msgBody.password = Inputpass2:GetComponent("UIInput").value;
	msgBody.phone = phoneInput:GetComponent("UIInput").value;

	msg.body = msgBody:SerializeToString();

	SendProxyMessage(msg,function (msg)

		local data = proxy_pb.RResult();
		data:ParseFromString(msg.body);
		if data.code == 1 then
			panelMessageTip.SetParamers("密码修改成功",1,nil);
			PanelManager.Instance:ShowWindow('panelMessageTip');
			
			-- 返回到手机登录或账号登录
			this.SetPanelState(beginAction)
		end
	end);


end




