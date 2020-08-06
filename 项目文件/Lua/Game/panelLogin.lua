require 'common'
require	'logic'

local protocol_pb = require 'protocol_pb'
local proxy_pb = require 'proxy_pb'

panelLogin = {}
local this = panelLogin;

local message;
local gameObject;
this.gameObject=gameObject
local buttonLogin
local buttonPhoneLogin
local ButtonVisitor
local buttonToggle
local userAgreement
local buttonMesh
local buttonAccountLogin

local LoginInput

local agree = true
local isVisitor = false
local connect
local WXCode
local versionLabel

this.isPhoneLogin=false
this.code=nil
this.GPSdata={}
this.hongBaoQueue = {}

local ipinput
local portinput
local conectserver
local testServerToggle
local NatServerToggle

FitScale = 1
FitOffset = 0
ipxLiuHai=55


roomInfo={}
info_login = {}
userInfo={}
isLogin = false
isLoginPong = false
isIngame = false
isShapedScreen=false--是否是宽屏异形屏

roomData = roomData and roomData or {}

this.isLobbyRecord=true
this.HttpUrl = ConfigManager.getProperty('Http', 'HttpUrl', '');
--启动事件--
function this.Awake(obj)
	gameObject = obj;
	this.gameObject=gameObject
	
	isShapedScreen=(PlatformManager.Instance.isIphoneX or PlatformManager.Instance.isIphoneXSMAX or
	UnityEngine.Screen.width/UnityEngine.Screen.height>1.9)
	if UnityEngine.Screen.width/UnityEngine.Screen.height>1334/750 then
		FitOffset = (750*UnityEngine.Screen.width/UnityEngine.Screen.height -1334)/2
		FitScale = (750*UnityEngine.Screen.width/UnityEngine.Screen.height)/1334
	end

	buttonLogin = gameObject.transform:Find('ButtonLogin');
	conectserver = gameObject.transform:Find('conectserver');
	buttonPhoneLogin = gameObject.transform:Find('ButtonPhoneLogin');
	ButtonVisitor = gameObject.transform:Find('ButtonVisitor');
    buttonToggle = gameObject.transform:Find('Toggle');
	userAgreement = gameObject.transform:Find('userAgreement');
	message = gameObject:GetComponent('LuaBehaviour');
	buttonMesh = gameObject.transform:Find('FX_bj01'):GetChild(4);
	versionLabel = gameObject.transform:Find('version');
	LoginInput = gameObject.transform:Find('input');
	testServerToggle = gameObject.transform:Find("testServerToggle");
	NatServerToggle = gameObject.transform:Find("NatServerToggle");
	buttonAccountLogin =  gameObject.transform:Find('ButtonAccountLogin')

	-- print("testServerToggle:"..tostring(testServerToggle));
	-- print("NatServerToggle:"..tostring(NatServerToggle));
	
	ipinput = gameObject.transform:Find('ipinput');
	portinput = gameObject.transform:Find('portinput');
	message:AddClick(buttonLogin.gameObject, this.OnClickLogin);
	message:AddClick(ButtonVisitor.gameObject, this.OnClickLogin);
    message:AddClick(buttonToggle.gameObject, this.OnClickProtocl);
	message:AddClick(userAgreement.gameObject, this.OnClickuserAgreement);
	message:AddClick(buttonPhoneLogin.gameObject, this.OnclickPhoneLogin);
	message:AddClick(conectserver.gameObject, this.OnclickConectServer);
	message:AddOnValueChange(testServerToggle.gameObject,this.OnTestServerToggleValueChange);
	message:AddOnValueChange(NatServerToggle.gameObject,this.OnNatServerToggleValueChange);
	message:AddClick(buttonAccountLogin.gameObject, this.OnclickAccountLogin);
end

function this.OnActivityReward(msg)
    local b = proxy_pb.RSendRedPackRain()
    b:ParseFromString(msg.body)
    local data = {}
    --data.seat=b.seat
	data.typeName = b.typeName
	data.sourceId = b.sourceId
	data.img = b.img
	data.nickname = b.nickname
    --data.amount=b.amount
    table.insert(this.hongBaoQueue,data)
	print("有红包来了，胡牌类型："..data.typeName,data.img,data.nickname)
	
	
    --this.ShowHongBao()
end
-- function this.ShowHongBao()
--     --if #this.hongBaoQueue>0 then
--         --isShowedGuide = UnityEngine.PlayerPrefs.GetInt('isShowedGuide', 0)
--         --getHongBaoNum=UnityEngine.PlayerPrefs.GetInt('getHongBaoNum', 0)
--         local data=this.hongBaoQueue[#this.hongBaoQueue]
--         local pData=this.GetPlayerDataBySeat(data.seat)
--         this.setHongBao(data.rewardType,data.amount,pData.icon,pData.name,data.plate)
  
--         -- hongBaoShareBTN.gameObject:SetActive(data.seat==mySeat)
--         -- hongBaoSaveBTN.gameObject:SetActive(data.seat==mySeat)
--         -- hongBaoZhanBTN.gameObject:SetActive(data.seat~=mySeat)
--         --hongBaoView:Find('Panel/Label').gameObject:SetActive(data.seat==mySeat)
--         --hongBaoView.gameObject:SetActive(true)
--         -- SetUserData(hongBaoView.gameObject,data)
        
--     --end
-- end
function this.OnclickPhoneLogin(go)
	AudioManager.Instance:PlayAudio('btn')
    if not agree then
        return
	end
	this.code=nil
	PanelManager.Instance:ShowWindow('panelPhoneLogin',{state = 1})
end

function this.OnclickAccountLogin(go)
	AudioManager.Instance:PlayAudio('btn')
    if not agree then
        return
	end
	this.code=nil
	PanelManager.Instance:ShowWindow('panelPhoneLogin',{state = 5})
end

function this.Update()
   
end

function this.Start()
	local loginType = ConfigManager.getIntProperty('Setting', 'LoginType', 2);

	if loginType ~= 0 then --如果不是测试服就自动连接
		connect = NetWorkManager.Instance:CreateConnect('proxy');
		connect.Port =ConfigManager.getIntProperty('ProxyServer', 'serverPort', 0);
		connect.IP = GetServerIPorTag(true)
		connect.GroupName = ConfigManager.getProperty('ProxyServer', 'GroupName', '')
		connect.heartBeatInterval = 5
		connect.onConnectLua = this.OnConnect
		connect.disConnectLua = this.OnDisconnect
		connect.rspCallBackLua = receiveProxyMessage
		connect.reConnectNum = ConfigManager.getIntProperty('Setting', 'ReconnectNum', 5)
		connect:Connect()
		coroutine.start(this.CheckNetState)
	end
	
	local audio_value = UnityEngine.PlayerPrefs.GetFloat('audio_value', 1)
    local music_value = UnityEngine.PlayerPrefs.GetFloat('music_value', 1)
    local audio_on = UnityEngine.PlayerPrefs.GetInt('audio_on', 1)
    local music_on = UnityEngine.PlayerPrefs.GetInt('music_on', 1)
	AudioManager.Instance:SetAudioVolume(audio_value)
	AudioManager.Instance:SetMusicVolume(music_value)
	AudioManager.Instance.MusicOn = music_on == 1
	AudioManager.Instance.AudioOn = audio_on == 1

	print('loginType:'..loginType)
	if loginType == 1 then
		LoginInput:GetComponent('UILabel').text = UnityEngine.SystemInfo.deviceUniqueIdentifier
		LoginInput.gameObject:SetActive(false)
		ButtonVisitor.transform.localPosition=Vector3(0,-146,ButtonVisitor.transform.localPosition.z)
		ButtonVisitor.gameObject:SetActive(true)
		buttonLogin.gameObject:SetActive(false)
		buttonMesh.gameObject:SetActive(false)
		buttonPhoneLogin.gameObject:SetActive(false)
	elseif loginType == 2 then
		LoginInput.gameObject:SetActive(false)
		ButtonVisitor.gameObject:SetActive(false)
		buttonLogin.gameObject:SetActive(true)
		buttonPhoneLogin.gameObject:SetActive(true)
		ipinput.gameObject:SetActive(false);
		portinput.gameObject:SetActive(false);
		conectserver.gameObject:SetActive(false);
		testServerToggle.gameObject:SetActive(false);
		NatServerToggle.gameObject:SetActive(false);
	elseif loginType == 0 then
		LoginInput.gameObject:SetActive(true)
		ButtonVisitor.gameObject:SetActive(true)
		buttonLogin.gameObject:SetActive(true)
		buttonPhoneLogin.gameObject:SetActive(true)
		
		conectserver.gameObject:SetActive(true)
		ipinput.gameObject:SetActive(true)
		portinput.gameObject:SetActive(true)
		testServerToggle.gameObject:SetActive(true)
		NatServerToggle.gameObject:SetActive(true)
	else
		LoginInput.gameObject:SetActive(false)
		ButtonVisitor.gameObject:SetActive(false)
		buttonLogin.gameObject:SetActive(true)
		buttonPhoneLogin.gameObject:SetActive(true)
		ipinput.gameObject:SetActive(false);
		portinput.gameObject:SetActive(false);
		conectserver.gameObject:SetActive(false);
		testServerToggle.gameObject:SetActive(false);
		NatServerToggle.gameObject:SetActive(false);
	end

	RegisterProxyCallBack(proxy_pb.DUPLICATE_LOGIN, this.OnDuplicateLogin)
	RegisterProxyCallBack(proxy_pb.PONG, this.OnPONG)
	RegisterProxyCallBack(proxy_pb.SEND_RED_PACK_RAIN, this.OnActivityReward)

	if Util.GetPlatformStr() == 'win' then
		UnityEngine.PlayerPrefs.DeleteKey(PLAYER_SESSION_ID)
	end

	this.GPSdata.longitude=0
	this.GPSdata.latitude=0
	this.GPSdata.address="未获取到该玩家位置"
	if not IsAppleReview() then
		print('初始化高德')
        PlatformManager.Instance:InitGaoDe()
	end
	
	UnityEngine.Application.targetFrameRate = ConfigManager.getIntProperty('Setting', 'GameFrameRate', 45)
end

function this.OnEnable()
	testServerToggle:GetComponent('UIToggle'):Set(false)
	NatServerToggle:GetComponent('UIToggle'):Set(false)
	ipinput:GetComponent('UILabel').text=GetServerIPorTag(true)
	portinput:GetComponent('UILabel').text=ConfigManager.getIntProperty('ProxyServer', 'serverPort', 0);
	this.test()
	isIngame = false
	if panelClub then
		panelClub.isInClub=false
	end
	
	AudioManager.Instance:StopMusic()
	NetWorkManager.Instance:DeleteConnect('game')
	SetScreenLayout(true, gameObject.transform.parent)	
	versionLabel:GetComponent('UILabel').text = '版本号:'..UpdateManager.gameVersion

	--方便调试
	LoginInput:GetComponent("UILabel").text = "w1"
	ipinput:GetComponent("UILabel").text = "192.168.2.140"
	portinput:GetComponent('UILabel').text = "18888"
end

function this.OnConnect()
	if UnityEngine.PlayerPrefs.HasKey(PLAYER_SESSION_ID) then
		local sessionId = UnityEngine.PlayerPrefs.GetString(PLAYER_SESSION_ID)
		--print(sessionId)
		print("succs IP : "..connect.IP.."Port : "..connect.Port);
		this.Login(false, sessionId)
	else
		this.BackToLogin()
	end
end

function this.OnDisconnect()
	print('proxy OnDisconnect')
	connect.Port =ConfigManager.getIntProperty('ProxyServer', 'serverPort', 0);
    connect.IP = GetServerIPorTag(true)
	isLogin = false
	connect:ClearSendMessage()
	registerProxyReceive(nil)
end

function this.GetNetState()
	if isIngame==true then
		return panelInGame.GetNetState()
	else
		return connect.IsConnect
	end
end

function this.CheckNetState()
	coroutine.wait(2)
	while true do
		if connect.IsReConnect then
			if not isIngame then
				print('断线重连了！！！')
				PanelManager.Instance:ShowWindow('panelProxyNetWaitting')
			end
		elseif  not connect.IsConnect then
			if not isIngame then
				print('网络断开了！！！')
				PanelManager.Instance:HideWindow('panelProxyNetWaitting')
				panelLogin.HideAllNetWaitting()
				panelMessageBoxTiShi.SetParamers(OK_CANCLE, this.OnNetCheckButtonOK, this.OnNetCheckButtonCancle, '网络连接失败，是否继续连接？')
				PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
			else
				this.OnNetCheckButtonOK()
			end
			break
		elseif connect.IsConnect then
			--print('断线重连成功了！！！')
			PanelManager.Instance:HideWindow('panelProxyNetWaitting')
		end
		
		coroutine.wait(0.5)
	end
end

function this.OnNetCheckButtonOK(go)
	if go then
		AudioManager.Instance:PlayAudio('btn')
	end
	connect.reConnectNum = ConfigManager.getIntProperty('Setting', 'ReconnectNum', 5)
	coroutine.start(this.CheckNetState)
end

function this.OnNetCheckButtonCancle()
	AudioManager.Instance:PlayAudio('btn')
	UnityEngine.Application.Quit()
end

--单击事件--
function this.OnClickLogin(go)
	PanelManager.Instance:ShowWindow('panelNetWaitting')
	AudioManager.Instance:PlayAudio('btn')
    if not agree then
        return
	end

	UnityEngine.PlayerPrefs.DeleteKey(PLAYER_SESSION_ID)
	local isWX = go.name == 'ButtonLogin'
	if isWX then
		PlatformManager.Instance:Login()
	else
		this.Login(not isWX, nil)
	end
	-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
end
function  this.OnclickConectServer(go)
	connect = NetWorkManager.Instance:CreateConnect('proxy');
    connect.IP = ipinput:GetComponent('UILabel').text      
    connect.Port = tonumber(portinput:GetComponent('UILabel').text)
	connect.GroupName = ConfigManager.getProperty('ProxyServer', 'GroupName', '')
	print("ip "..connect.IP.." port ".. connect.Port .. " GroupName "..connect.GroupName)
	
	connect.heartBeatInterval = 5
    connect.onConnectLua = this.OnConnect
    connect.disConnectLua = this.OnDisconnect
    connect.rspCallBackLua = receiveProxyMessage
	connect.reConnectNum = ConfigManager.getIntProperty('Setting', 'ReconnectNum', 5)
	connect:Connect()
	coroutine.start(this.CheckNetState)
end
function this.Login(visitor, code)
	PanelManager.Instance:ShowWindow('panelNetWaitting')
	StartCoroutine(function()
		WaitForSeconds(10)
		if isLogin == false then
			this.HideNetWaitting()
		end
	end)
	local body = proxy_pb.PAuthenticate();

	if UnityEngine.PlayerPrefs.HasKey(PLAYER_SESSION_ID) then
		body.sessionId = UnityEngine.PlayerPrefs.GetString(PLAYER_SESSION_ID)
	elseif visitor then
		body.code = LoginInput:GetComponent('UILabel').text
	else
		body.code = code
	end
	-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	-- by jih >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	-- body.uuid = UnityEngine.SystemInfo.deviceUniqueIdentifier;
	if not UnityEngine.PlayerPrefs.HasKey(PLAYER_UUID) then
		UnityEngine.PlayerPrefs.SetString(PLAYER_UUID, UnityEngine.SystemInfo.deviceUniqueIdentifier)
	end
	body.uuid = UnityEngine.PlayerPrefs.GetString(PLAYER_UUID)
	-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	body.platform = Util.GetPlatformStr();
	body.visitor = visitor
	isVisitor = body.visitor
	if inviteId~='' then
		body.inviterId=inviteId
		print('login:绑定的inviteid'..body.inviterId)
		inviteId=''
	end
	
	if body.platform == 'ios' then
		body.gamePack = proxy_pb.HPYX--新版本、嗨皮游戏
		if UnityEngine.Application.identifier == 'com.haipi.phz' then
			body.gamePack = proxy_pb.HPJBCD --嗨皮绝不重叠
		end
	else
		body.gamePack = proxy_pb.QYQM
	end
	
	local msg = Message.New()
	msg.type = proxy_pb.AUTHENTICATE
	msg.body = body:SerializeToString()

	print('login:'..body.code..' uuid:'..body.uuid..' platform:'..body.platform..' visitor:'..tostring(body.visitor))
	SendProxyMessage(msg, this.LoginRes)
end

function this.loginCallBack(errCode, code)
	print('收到微信登录返回')

	panelLogin.HideNetWaitting()
	errCode = tonumber(errCode)
	if errCode ~= 0 then
		print('login code : ' .. errCode)
		return
	end
	this.code=code
	if this.isPhoneLogin==true then
		this.isPhoneLogin=false
		panelPhoneLogin.setGetBtn(true)
	else
		coroutine.start(
			function()
				coroutine.wait(1)
				this.Login(false, code)
			end
		)
	end

	
end

function this.GPSCallBack(longitude, latitude, address)
	print('收到高德定位返回'..longitude..' '..latitude..address)
	if longitude and longitude~="" then
		this.GPSdata.longitude	= tonumber(longitude)
		this.GPSdata.latitude	= tonumber(latitude)
	
		UnityEngine.PlayerPrefs.SetFloat("longitude",this.GPSdata.longitude)
		UnityEngine.PlayerPrefs.SetFloat("latitude",this.GPSdata.latitude)
	else
		UnityEngine.PlayerPrefs.DeleteKey("longitude")
		UnityEngine.PlayerPrefs.DeleteKey("latitude")
	end
	
	if address and address~="" then
		this.GPSdata.address=address
		UnityEngine.PlayerPrefs.SetString("address",this.GPSdata.address)
	else
		UnityEngine.PlayerPrefs.DeleteKey("address")
		this.GPSdata.address=""
	end
end

function this.OnClickProtocl(go)
    agree = not agree 
    --print(agree)
end


--选择测试环境
function this.OnTestServerToggleValueChange(go)
	ipinput:GetComponent('UILabel').text = "106.14.29.177";
	portinput:GetComponent('UILabel').text = "28897";

end

--选择局域网环境
function this.OnNatServerToggleValueChange(go)
	ipinput:GetComponent('UILabel').text = "192.168.2.107"
	portinput:GetComponent('UILabel').text = "18888";
end

function this.OnClickuserAgreement(go)
	PanelManager.Instance:ShowWindow('panelUserAgreement')
end

function this.LoginRes(msg)
	this.HideNetWaitting()
    print('loginres')
    local h = protocol_pb.Header()
    h:ParseFromString(msg.header)

	-- by jih >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	if h.status ~= 0 then
		UnityEngine.PlayerPrefs.DeleteKey(PLAYER_SESSION_ID)
		return
	end
	-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    local b = proxy_pb.RUser();
    b:ParseFromString(msg.body);

	b.sex = b.sex == 0 and 1 or b.sex
    info_login = b
    userInfo.nickname = b.nickname
    userInfo.icon = b.icon
    userInfo.sex = b.sex
    userInfo.ip = b.ip
	userInfo.balance = b.balance
	userInfo.id = b.id
	print('手机号：'..b.phone..'  b.passWord: '..tostring(b.passWord))
	userInfo.phone = b.phone
	userInfo.passWord = b.passWord
	userInfo.inviterId = info_login.inviterId
	userInfo.hasNameAuth=b.hasNameAuth
	userInfo.userType=b.userType
	if b.contact then
		userInfo.contact=b.contact
	end
	
	UnityEngine.PlayerPrefs.SetString(PLAYER_SESSION_ID, b.sessionId)
	if Util.GetPlatformStr() ~= 'win' then
		print('语音初始化！！！！！！！！！！')
		NGCloudVoice.Instance:Init('hphy' .. b.id,"1767866292","a3c49f629b4dd8a9beeef9c59fe46dd3")
		NGCloudVoice.Instance:SetModeMessage()
	end
	--PlatformManager.Instance:InitAppsflyer("jvEq9yTNa4EjmtVXPc76wS",info_login.id)
		
    
	print('uerid:'..info_login.id)

	print('isIngame:'..tostring(isIngame))
	if not isIngame then
		local m = Message.New()
		m.type = proxy_pb.QUERY_ROOM
		SendProxyMessage(m, this.OnQueryRoomResult)
	end
	
	isLogin = true
end

function this.OnQueryRoomResult(msg)
	local b = proxy_pb.RQueryRoom();
    b:ParseFromString(msg.body);
	--PanelManager.Instance:HideAllWindow()
	if b.existed then
		roomInfo.host 		= b.host
		roomInfo.port 		= b.port
		roomInfo.token 		= b.token
		roomInfo.roomNumber = b.roomNumber
		roomInfo.gameType 	= b.gameType
		roomInfo.roomType 	= b.roomType
		print("roomInfo.gameType="..roomInfo.gameType);
		print("roomInfo.roomType="..roomInfo.roomType);
		for key,value in pairs(roomInfo) do
			print(key, value)
		end
		if b.gameType == proxy_pb.PDK then
			PanelManager.Instance:ShowWindow('panelInGame_pdk',gameObject.name)
		elseif b.gameType == proxy_pb.PHZ then
			PanelManager.Instance:ShowWindow('panelInGameLand',gameObject.name)
		elseif b.gameType == proxy_pb.XHZD then
			PanelManager.Instance:ShowWindow('panelInGame_xhzd',gameObject.name)
		elseif b.gameType == proxy_pb.MJ then
			PanelManager.Instance:ShowWindow('panelInGamemj',gameObject.name)
		elseif  b.gameType == proxy_pb.DTZ then
			PanelManager.Instance:ShowWindow('panelInGame_dtz',gameObject.name)
		elseif b.gameType == proxy_pb.BBTZ then
			PanelManager.Instance:ShowWindow('panelInGame_bbtz', gameObject.name)
		elseif b.gameType == proxy_pb.XPLP then 
			PanelManager.Instance:ShowWindow('panelInGame_xplp', gameObject.name)
		elseif b.gameType == proxy_pb.HNM and b.roomType == proxy_pb.HNHSM then 
			PanelManager.Instance:ShowWindow('panelInGame_hnhsm', gameObject.name)
		elseif b.gameType == proxy_pb.HNM and b.roomType == proxy_pb.HNZZM then 
			PanelManager.Instance:ShowWindow('panelInGame_hnzzm', gameObject.name)
		elseif b.gameType == proxy_pb.YJQF then 
			PanelManager.Instance:ShowWindow('panelInGame_yjqf', gameObject.name)
		elseif b.gameType == proxy_pb.DZM then 
			PanelManager.Instance:ShowWindow('panelInGame_dzahm', gameObject.name)
		end
		--PanelManager.Instance:ShowWindow('panelInGameLand',gameObject.name)
	elseif this.NotNeedEnterLobbyOrClub() then

	elseif panelClub and panelClub.isInClub==true then--elseif b.clubId and b.clubId~='' then
		local tmpData={}
		tmpData.name=gameObject.name;
		--tmpData.clubId = b.clubId;
		PanelManager.Instance:ShowWindow('panelClub',tmpData)
		if PanelManager.Instance:IsActive('panelLobby') then
			PanelManager.Instance:HideWindow('panelLobby')
		end
	else
        PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
		if panelJoinRoom then
			panelJoinRoom.OnLogin()
		end
		if panelLobby then
			panelLobby.SetBalance(info_login.balance)
		end
		
		if PanelManager.Instance:IsActive('panelClub') then
			PanelManager.Instance:HideWindow('panelClub')
		end

		GetUpdateNotice(true)
	end
end

--不需要进入大厅或者牌友群（断线重连时停留在当前界面）
function this.NotNeedEnterLobbyOrClub()
	return PanelManager.Instance:IsActive('panelClubHome')==true
end

function this.OnDuplicateLogin(msg)
	print('OnDuplicateLogin')
	NetWorkManager.Instance:DeleteConnect('game')
	panelMessageBox.SetParamers(ONLY_OK, this.BackToLogin, nil, '该账号已在别处登录')
	PanelManager.Instance:ShowWindow('panelMessageBox')
	--账号被顶 需要清楚数据
	if panelInGame then
		panelInGame.gameObject:SetActive(false)
		panelInGame = nil;
	end
	--
	UnityEngine.PlayerPrefs.DeleteKey(PLAYER_SESSION_ID)
end

function this.OnPONG(msg)
	pingTime = int64.tonum2(Util.GetTime()) - int64.tonum2(connect.LastHeartBeatTime)
	isLoginPong = true
	-- print('pingTime:'..pingTime..'ms')
end

function this.BackToLogin()
	local needShowPhoneLogin=false
	if PanelManager.Instance:IsActive('panelPhoneLogin') then
		needShowPhoneLogin=true
	end
	PanelManager.Instance:HideAllWindow()
	PanelManager.Instance:ShowWindow('panelLogin')
	if needShowPhoneLogin==true then
		PanelManager.Instance:ShowWindow('panelPhoneLogin',nil);
	end
end

function this.test()
	LoginInput = gameObject.transform:Find('input');
end

function this.OnWeiXinIsNotInstall(data)
	panelMessageTip.SetParamers('请先安装微信，再进行操作。', 1)
	PanelManager.Instance:ShowWindow('panelMessageTip')
end

function this.OnXianLiaoIsNotInstall(data)
	panelMessageTip.SetParamers('请先安装闲聊，再进行操作。', 1)
	PanelManager.Instance:ShowWindow('panelMessageTip')
end

function this.HideNetWaitting()
    if PanelManager.Instance:IsContainsKey('panelNetWaitting')==true then
        PanelManager.Instance:HideWindow('panelNetWaitting')
    else
        StartCoroutine(function()
            while PanelManager.Instance:IsContainsKey('panelNetWaitting')==false do
                WaitForSeconds(0.2)
            end
            PanelManager.Instance:HideWindow('panelNetWaitting')
        end)
    end
end

function this.HideGameNetWaitting()
    if PanelManager.Instance:IsContainsKey('panelGameNetWaitting')==true then
        PanelManager.Instance:HideWindow('panelGameNetWaitting')
    else
        StartCoroutine(function()
            while PanelManager.Instance:IsContainsKey('panelGameNetWaitting')==false do
                WaitForSeconds(0.2)
            end
            PanelManager.Instance:HideWindow('panelGameNetWaitting')
        end)
    end
end

function this.HideProxyNetWaitting()
    if PanelManager.Instance:IsContainsKey('panelProxyNetWaitting')==true then
        PanelManager.Instance:HideWindow('panelProxyNetWaitting')
    else
        StartCoroutine(function()
            while PanelManager.Instance:IsContainsKey('panelProxyNetWaitting')==false do
                WaitForSeconds(0.2)
            end
            PanelManager.Instance:HideWindow('panelProxyNetWaitting')
        end)
    end
end

function this.HideAllNetWaitting()
	this.HideNetWaitting()
	this.HideGameNetWaitting()
	this.HideProxyNetWaitting()
end