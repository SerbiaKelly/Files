panelLobby = {}
local this = panelLobby;

local message;
local gameObject;



local playerIcon
local playerName
local playerID
local moneyNum
local buttonAdd
local buttonShop
local buttonMessage
local buttonHelp
local buttonSetting
local ButtonJinDu--禁赌声明按钮
local panelJinDu--禁赌声明界面
local ButtonRestart--重启按钮
local buttonShiMing
local buttonBind
local buttonYaoQingMa
local buttonMore
local moreGO

local buttonPHZ
local buttonPDK
local buttonMJ
local buttonDTZ
local buttonXHZD
local buttonBBTZ;
local buttonJoinRoom
local buttonClub
local buttonHuoDong
local daiLiHouTai

local buttonKeFu
local buttonRecord
local buttonShare
local buttonShouChong
local WinningButton
local MyIdCardButton

local marqueeBG
local marqueeLabel
local yun

local testing =true

local marqueeList = proxy_pb.RMarqueeList()

local NotcieGunDongXC

local LeftButtonsDown;

local PlaysButtonDown;

function this.Awake(obj)
	gameObject = obj;
	this.gameObject = obj
	message = gameObject:GetComponent('LuaBehaviour');

	buttonYaoQingMa = gameObject.transform:Find('LeftButtons/Container/yaoQingMa');
	buttonMore = gameObject.transform:Find('LeftButtons/Container/buttonMore')
	playerIcon = gameObject.transform:Find('top/playerIcon');
    playerID = gameObject.transform:Find('top/playerID');
    playerName = gameObject.transform:Find('top/playerName');
    moneyNum = gameObject.transform:Find('top/money/num');

	yun = gameObject.transform:Find('FX_bj04/yun')
	moreGO = gameObject.transform:Find('top/more');
	buttonAdd = gameObject.transform:Find('top/money');
--禁赌声明
	ButtonJinDu = gameObject.transform:Find('top/ButtonJinDu');
	panelJinDu = gameObject.transform:Find('panelJinDu');
	message:AddClick(ButtonJinDu.gameObject, this.OnClickJinDu);
	message:AddClick(panelJinDu:Find('BaseContent/ButtonClose').gameObject, this.CloseJinDu);

	ButtonRestart = gameObject.transform:Find('top/ButtonRestart');
	message:AddClick(ButtonRestart.gameObject, function()
		PanelManager.Instance:RestartGame()
	end);

	buttonShiMing = gameObject.transform:Find('LeftButtons/Container/ButtonShiMing');
	buttonBind = gameObject.transform:Find('LeftButtons/Container/ButtonBind');
	buttonShop = gameObject.transform:Find('buttom/buttonShop');
    buttonMessage = gameObject.transform:Find('buttom/buttonMessage');
    buttonHelp = gameObject.transform:Find('buttom/buttonHelp');
    buttonSetting = gameObject.transform:Find('buttom/buttonSetting');
	buttonPHZ = gameObject.transform:Find('PlaysButton/Container/PHZ');
	buttonPDK = gameObject.transform:Find('PlaysButton/Container/PDK');
	buttonMJ = gameObject.transform:Find('PlaysButton/Container/MJ');
	buttonDTZ = gameObject.transform:Find('PlaysButton/Container/DTZ')
	buttonXHZD = gameObject.transform:Find('PlaysButton/Container/XHZD')
	buttonBBTZ = gameObject.transform:Find('PlaysButton/Container/BBTZ')
	buttonJoinRoom = gameObject.transform:Find('ButtonJoin');
	buttonClub = gameObject.transform:Find('ButtonClub');
	buttonHuoDong = gameObject.transform:Find('buttonHuoDong');
	daiLiHouTai = gameObject.transform:Find('LeftButtons/Container/daiLiHouTai');
	message:AddClick(daiLiHouTai.gameObject, this.OnClickDaiLiHouTai);

    buttonKeFu = gameObject.transform:Find('buttom/buttonKeFu');
    buttonRecord = gameObject.transform:Find('buttom/buttonRecord');
    buttonShare = gameObject.transform:Find('buttom/buttonShare');
	buttonShouChong = gameObject.transform:Find('top/shouchong')

	marqueeBG = gameObject.transform:Find('top/Sprite/bg');
	marqueeLabel = gameObject.transform:Find('top/Notcie/Label');

	WinningButton = gameObject.transform:Find('LeftButtons/Container/WinningButton')
	MyIdCardButton = gameObject.transform:Find('LeftButtons/Container/MyIdCardButton')

	message:AddClick(buttonYaoQingMa.gameObject, this.OnClickYaoQingMa);
    message:AddClick(buttonAdd.gameObject, this.OnClickAdd);
    message:AddClick(buttonShop.gameObject, this.OnClickAdd);

    message:AddClick(buttonShiMing.gameObject, this.OnClickButtonShiMing);
    message:AddClick(buttonBind.gameObject, this.OnClickButtonBind);

	message:AddClick(playerIcon.gameObject, this.OnClickPlayerIcon);
    message:AddClick(buttonMessage.gameObject, this.OnClickButtonMessage);
    message:AddClick(buttonHelp.gameObject, this.OnClickButtonHelp);
    message:AddClick(buttonSetting.gameObject, this.OnClickButtonSetting);

	message:AddClick(buttonPHZ.gameObject, this.OnClickButtonCreateRoom);
	message:AddClick(buttonPDK.gameObject, this.OnClickButtonCreateRoom);
	message:AddClick(buttonMJ.gameObject, this.OnClickButtonCreateRoom);
	message:AddClick(buttonXHZD.gameObject, this.OnClickButtonCreateRoom);
	message:AddClick(buttonDTZ.gameObject, this.OnClickButtonCreateRoom);
	message:AddClick(buttonBBTZ.gameObject, this.OnClickButtonCreateRoom);

    message:AddClick(buttonJoinRoom.gameObject, this.OnClickButtonJoinRoom);
	message:AddClick(buttonClub.gameObject, this.OnClickbuttonClub);
	message:AddClick(buttonMore.gameObject, this.OnClickbuttonMore);


    message:AddClick(buttonRecord.gameObject, this.OnClickButtonRecord);
    message:AddClick(buttonShare.gameObject, this.OnClickButtonShare);
	message:AddClick(buttonKeFu.gameObject,this.OnClickButtonKeFu)
	message:AddClick(WinningButton.gameObject, this.OnClickButtonWinning)
	message:AddClick(buttonHuoDong.gameObject, this.OnClickButtonCreateRoom)
	message:AddClick(MyIdCardButton.gameObject, function (go)
		local userData = {}
		userData.whoShow = gameObject.name
		userData.userId = info_login.id
		PanelManager.Instance:ShowWindow('panelVisitingCard',userData)
	end)



	if IsAppleReview() then
		--gameObject.transform:Find('top/money').gameObject:SetActive(false)
		gameObject.transform:Find('FX_bj04/Cube_ios').gameObject:SetActive(false);
		buttonJoinRoom:Find("Sprite").gameObject:SetActive(true)
		buttonHuoDong.gameObject:SetActive(false)
		buttonShare.gameObject:SetActive(false)
		buttonMessage.gameObject:SetActive(false)
		daiLiHouTai.gameObject:SetActive(false)
		ButtonJinDu.gameObject:SetActive(false)
		buttonKeFu.gameObject:SetActive(false)
		buttonYaoQingMa.gameObject:SetActive(false)
	end
	--yun.localScale=Vector3(FitScale,1,1)
	local  ishavenewmsg =  ConfigManager.getBoolProperty('Setting', 'ishavenewmsg', false) --每次发包需手动维护这个值 来控制更新公告是否显示
	print("ishavenewmsg",ishavenewmsg)
	if UpdateManager.gameVersion ~= "" then
		print("服务器版本号",UpdateManager.gameVersion)
		local ver =  UnityEngine.PlayerPrefs.GetInt('myversion', 0)
		print("本地版本号",ver)
		if ver == 0 or ver < tonumber(UpdateManager.gameVersion) then
			UnityEngine.PlayerPrefs.SetInt('myversion', tonumber(UpdateManager.gameVersion))
			if ishavenewmsg  then
				print("显示更新公告")
				PanelManager.Instance:ShowWindow('panelUpdateNoticeMore')
			end
		end
	end
	--UnityEngine.Application.OpenURL('weixin://')

	LeftButtonsDown = gameObject.transform:Find('LeftButtons/Down')
	local leftScroll = gameObject.transform:Find('LeftButtons/Container'):GetComponent('UIScrollView')
	leftScroll:GetComponent("UIPanel").onClipMove = function (panel)
		if leftScroll.verticalScrollBar.value == 0 and LeftButtonsDown:Find("Sprite").localRotation.eulerAngles.z >= 180 then
			LeftButtonsDown:Find("Sprite"):Rotate(Vector3(0, 0, -180))
		elseif leftScroll.verticalScrollBar.value >= 0.9 and LeftButtonsDown:Find("Sprite").localRotation.eulerAngles.z == 0 then
			LeftButtonsDown:Find("Sprite"):Rotate(Vector3(0, 0, 180))
		end
	end
	message:AddClick(LeftButtonsDown.gameObject, function (go)
		print(tostring(UITools.ScrollViewCanMove(leftScroll)))
		if not UITools.ScrollViewCanMove(leftScroll) then
			return
		end

		leftScroll:Scroll(LeftButtonsDown:Find("Sprite").localRotation.eulerAngles.z == 0 and -1 or 1)
		leftScroll:UpdatePosition()
	end)

	PlaysButtonDown = gameObject.transform:Find('PlaysButton/Down')
	PlaysScroll = gameObject.transform:Find('PlaysButton/Container'):GetComponent('UIScrollView')
	PlaysScroll:GetComponent("UIPanel").onClipMove = function (panel)
		if PlaysScroll.horizontalScrollBar.value == 0 and PlaysButtonDown:Find("Sprite").localRotation.eulerAngles.z >= 180 then
			PlaysButtonDown:Find("Sprite"):Rotate(Vector3(0, 0, -180))
		elseif PlaysScroll.horizontalScrollBar.value >= 0.9 and PlaysButtonDown:Find("Sprite").localRotation.eulerAngles.z == 0 then
			PlaysButtonDown:Find("Sprite"):Rotate(Vector3(0, 0, 180))
		end
	end
	message:AddClick(PlaysButtonDown.gameObject, function (go)
		if not UITools.ScrollViewCanMove(PlaysScroll) then
			return
		end

		PlaysScroll:Scroll(PlaysButtonDown:Find("Sprite").localRotation.eulerAngles.z == 0 and 1 or -1)
		PlaysScroll:UpdatePosition()
	end)
end

function this.OnClickDaiLiHouTai(go)
	AudioManager.Instance:PlayAudio('btn')
	UnityEngine.Application.OpenURL('http://hp.17hiya.top')
end

function this.OnClickButtonWinning(go)
	AudioManager.Instance:PlayAudio('btn')
	--UnityEngine.Application.OpenURL('weixin://')
	PanelManager.Instance:ShowWindow('panelRedBog')
end

function this.OnClickJinDu(go)
	AudioManager.Instance:PlayAudio('btn')
	panelJinDu.gameObject:SetActive(true)
end

function this.CloseJinDu(go)
	AudioManager.Instance:PlayAudio('btn')
	panelJinDu.gameObject:SetActive(false)
end

function this.OnClickButtonShiMing(go)
	AudioManager.Instance:PlayAudio('btn')
	if not userInfo.hasNameAuth then
		PanelManager.Instance:ShowWindow('panelShiMing')
	end

end
function this.OnClickYaoQingMa(go)
	AudioManager.Instance:PlayAudio('btn')
	if #info_login.inviterId == 0 then
		PanelManager.Instance:ShowWindow('panelYaoQingMa')
	else
		panelMessageTip.SetParamers('您已经绑定'..info_login.inviterId..'玩家。', 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	end

end

function this.OnClickbuttonMore()
	AudioManager.Instance:PlayAudio('btn')
	PanelManager.Instance:ShowWindow('panelNotice')
end

function this.OnClickLiBao(go)
	AudioManager.Instance:PlayAudio('btn')
	PanelManager.Instance:ShowWindow('panelNotice','daiLi')

end

function this.OnClickButtonBind(go)
	AudioManager.Instance:PlayAudio('btn')
	if #userInfo.phone == 0 then
		PanelManager.Instance:ShowWindow('panelBindPhoneNum',1)
	else
		panelMessageTip.SetParamers('您已经绑定', 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	end

end

function this.Start()
	RegisterProxyCallBack(proxy_pb.MARQUEE_UPDATE, this.MarqueeListRes)
	RegisterProxyCallBack(proxy_pb.BALANCE_CHANGE, this.BalanceChangeRes)
	RegisterProxyCallBack(proxy_pb.SYS_MESSAGE, this.OnSysmessage)

	--每天弹一次公告
	--local needPopupNotice = UnityEngine.PlayerPrefs.GetInt('NoticeTrigger',-1);
	--local day = tonumber(os.date("%d", os.time()));
	--if needPopupNotice == -1 then
		PanelManager.Instance:ShowWindow('panelNotice');
		--UnityEngine.PlayerPrefs.SetInt('NoticeTrigger',day);
	-- else
	-- 	if needPopupNotice ~= day then
	-- 		PanelManager.Instance:ShowWindow('panelNotice');
	-- 		UnityEngine.PlayerPrefs.SetInt('NoticeTrigger',day);
	-- 	end
	-- end
	print("获取未领取红包数量记录")
	this.GetHongBaoRecord()

end
function this.GetHongBaoRecord()
    local msg = Message.New()
	-- msg.type = proxy_pb.RED_PACK_NO_RECEIVE_TOTAL
	-- SendProxyMessage(msg, this.HowMuch)
end
function this.HowMuch(msg)
    local b = proxy_pb.RRedPackNoReceiveTotal()
    b:ParseFromString(msg.body)
    if b.amount ~= nil and b.amount ~= "" and  tonumber(b.amount) > 0 then
		panelMessageBoxTiShi.SetParamers(ONLY_OK, function ()
			Util.CopyToSystemClipbrd('hnhaipi')
			UnityEngine.Application.OpenURL('weixin://')
		end, nil, "您当前有"..b.amount.."元红包尚未领取，赶紧关注公众号(hnhaipi)领取吧~","复制并跳转")
		PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
    end
end
function this.Update()

end
function this.OnEnable()
	userInfo.nickname = info_login.nickname
    userInfo.icon = info_login.icon
    userInfo.sex = info_login.sex
    userInfo.ip = info_login.ip
	userInfo.balance = info_login.balance
	userInfo.id = info_login.id
	userInfo.inviterId = info_login.inviterId
	moreGO.gameObject:SetActive(false)
	daiLiHouTai.gameObject:SetActive(info_login.userType>0)
	if panelInGame and panelInGame.fanHuiRoomNumber then
		buttonJoinRoom:Find('join').gameObject:SetActive(false)
		buttonJoinRoom:Find('return').gameObject:SetActive(true)
		else
		buttonJoinRoom:Find('join').gameObject:SetActive(true)
		buttonJoinRoom:Find('return').gameObject:SetActive(false)
	end

	if not NotcieGunDongXC then
		NotcieGunDongXC = StartCoroutine(this.UpdateMarquee)
	end

	print('info_login.icon'..info_login.icon)
	if info_login.icon~=nil and info_login.icon~='' then
		coroutine.start(LoadPlayerIcon, playerIcon:GetComponent('UITexture'), info_login.icon)
	end

    playerName:GetComponent('UILabel').text = info_login.nickname
    playerID:GetComponent('UILabel').text = info_login.id
    moneyNum:GetComponent('UILabel').text = info_login.balance
	print('手机号：userInfo.phone '..#userInfo.phone )
	--buttonYaoQingMa.gameObject:SetActive(#userInfo.inviterId==0)
	buttonBind.gameObject:SetActive (#userInfo.phone == 0)
	--buttonShiMing.gameObject:SetActive(not userInfo.hasNameAuth)

	coroutine.start(
		function()
			--coroutine.wait(2)
			while not isLogin do
				coroutine.wait(1)
			end
			if isLogin then
				local msg = Message.New()
				msg.type = proxy_pb.MARQUEE_LIST
				SendProxyMessage(msg, this.MarqueeListRes)

				msg = Message.New()
				msg.type = proxy_pb.USER_BALANCE
				SendProxyMessage(msg, this.BalanceChangeRes)
				--print("lobby send message")
				if not IsAppleReview() then
					local msg = Message.New()
					msg.type = proxy_pb.FIRST_RECHARGE
					SendProxyMessage(msg, this.OnGetMsgFirstRecharge)
				end
			end
		end
	)
	isIngame = false
	if panelClub then
		panelClub.isInClub=false
	end
	--UnityEngine.Screen.sleepTimeout = UnityEngine.SleepTimeout.SystemSetting
	AudioManager.Instance:StopMusic()
	AudioManager.Instance:PlayMusic('MainBG', true)
	SetScreenLayout(true, gameObject.transform.parent)
	--coroutine.start(StartGPS)

	gameObject.transform:Find('LeftButtons/Container'):GetComponent('UIGrid'):Reposition()

	local selectedGame = UnityEngine.PlayerPrefs.GetString('selectedGame', "PHZ")
	local buttons = buttonDTZ.parent;
	local gameButton = buttons:Find(selectedGame)
	gameButton:SetAsFirstSibling();
	buttons:GetComponent('UIGrid'):Reposition();
	buttons:GetComponent('UIScrollView'):ResetPosition()
	
	if not userInfo.passWord then
		PanelManager.Instance:ShowWindow('panelBindPhoneNum',2)
	end
end

function this.OnGetMsgFirstRecharge(msg)
	print('OnGetMsgFirstRecharge')
	local b = proxy_pb.RFirstRecharge()
	b:ParseFromString(msg.body)
	--buttonShouChong.gameObject:SetActive(not b.haveRecharge)
end

function this.MarqueeListRes(msg)
	print('MarqueeListRes')
	local b = proxy_pb.RMarqueeList()
	b:ParseFromString(msg.body)
	marqueeList = b
end

function this.MarqueeUpdateRes(msg)
	print('MarqueeUpdateRes')
	local b = proxy_pb.RMarqueeList()
	b:ParseFromString(msg.body)
	marqueeList = b
end

function this.BalanceChangeRes(msg)
	print('BalanceChangeRes')
	local b = proxy_pb.RUserBalance()
	b:ParseFromString(msg.body)
	userInfo.balance = b.balance
	info_login.balance = b.balance
	moneyNum:GetComponent('UILabel').text = info_login.balance
    if panelBuyDiamond then
        panelBuyDiamond.setMoneyNum(info_login.balance)
    end
end

function this.SetBalance(Balance)
	moneyNum:GetComponent('UILabel').text = Balance
end

function this.OnSysmessage(msg)
	print('OnSysmessage')
	local b = proxy_pb.RSysMessage()
	b:ParseFromString(msg.body)
	panelMessageBox.SetParamers(ONLY_OK, nil, nil, b.message)
	PanelManager.Instance:ShowWindow('panelMessageBox')
end

function this.UpdateMarquee()
	print('UpdateMarquee')
	local marqueeBGWidth = marqueeBG:GetComponent('UIWidget').width
	local label = marqueeLabel:GetComponent('UILabel')
	label.text = ''
	local index = 0
	while gameObject.activeSelf do
		if #marqueeList.contents > 0 then
			if index == 0 then
				index = index + 1
				label.text = marqueeList.contents[index]
				local pos = marqueeLabel.localPosition
				pos.x = marqueeBGWidth/2 + label.width/2
				marqueeLabel.localPosition = pos
				--print('notice is:'..label.text)
			end
			local pos = marqueeLabel.localPosition
			if pos.x < (-marqueeBGWidth/2 + -label.width/2) then
				index = index+1
				if index > #marqueeList.contents then
					index = 1
				end
				label.text = marqueeList.contents[index]
				pos.x = marqueeBGWidth/2 + label.width/2
				marqueeLabel.localPosition = pos
				--print('notice is:'..label.text)
			else
				local pos = marqueeLabel.localPosition
				pos.x = pos.x - 1
				marqueeLabel.localPosition = pos
			end
			WaitForEndOfFrame()
		else
			label.text = ''
			WaitForSeconds(1)
			index = 0
		end
	end
	NotcieGunDongXC = nil
end

function this.OnClickPlayerIcon()
	PanelManager.Instance:ShowWindow('panelMInfo',info_login)
end

function this.OnClickAdd(go)
	AudioManager.Instance:PlayAudio('btn')
	PanelManager.Instance:ShowWindow('panelBuyDiamond')
end

function this.OnClickButtonShouChong(go)
	AudioManager.Instance:PlayAudio('btn')
	PanelManager.Instance:ShowWindow('panelBuyDiamond')
	-- if #info_login.inviterId == 0 and not IsAppleReview() then
	-- 	PanelManager.Instance:ShowWindow('panelActivity')
	-- else
	-- 	PanelManager.Instance:ShowWindow('panelBuyDiamond')
	-- end
end

function this.OnClickButtonMessage(go)
	AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:ShowWindow('panelNotice','gongGao')
end

function this.OnClickButtonHelp(go)
	AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:ShowWindow('panelHelp',"lobby")
end

function this.OnClickButtonSetting(go)
	AudioManager.Instance:PlayAudio('btn')
	--UnityEngine.PlayerPrefs.SetInt('showWhichButton', 0)
    PanelManager.Instance:ShowWindow('panelSetting')
end

function this.OnClickButtonCreateRoom(go)
	AudioManager.Instance:PlayAudio('btn')
	--coroutine.start(StartGPS)

	if panelInGame and panelInGame.fanHuiRoomNumber then
		panelMessageBox.SetParamers(ONLY_OK,this.OnClickButtonToRoom,nil,'您已经加入了一个房间，不可重复加入','返回房间')
		PanelManager.Instance:ShowWindow('panelMessageBox')
	else
		if  go == buttonPDK.gameObject then
			UnityEngine.PlayerPrefs.SetInt('createRoomType', 30)
			UnityEngine.PlayerPrefs.SetInt('createGameType', 1)
		elseif go == buttonMJ.gameObject  then
			local createRoomType= UnityEngine.PlayerPrefs.GetInt('createRoomTypeMaJiang', 50)
			UnityEngine.PlayerPrefs.SetInt('createRoomType', createRoomType)
			UnityEngine.PlayerPrefs.SetInt('createGameType', 2)
		elseif go == buttonDTZ.gameObject  then
			UnityEngine.PlayerPrefs.SetInt('createRoomType', 36)
			UnityEngine.PlayerPrefs.SetInt('createGameType', 1)
		elseif go == buttonXHZD.gameObject  then
			UnityEngine.PlayerPrefs.SetInt('createRoomType', 35)
			UnityEngine.PlayerPrefs.SetInt('createGameType', 1)
		elseif go == buttonPHZ.gameObject then
			local createRoomType= UnityEngine.PlayerPrefs.GetInt('createRoomTypeZiPai', 1)
			UnityEngine.PlayerPrefs.SetInt('createRoomType', createRoomType)
			UnityEngine.PlayerPrefs.SetInt('createGameType', 0)
		elseif go == buttonBBTZ.gameObject then
			UnityEngine.PlayerPrefs.SetInt('createRoomType', 37)
			UnityEngine.PlayerPrefs.SetInt('createGameType', 1)
		end
		PanelManager.Instance:ShowWindow('panelCreateRoomNew')
	end

	if go ~= buttonHuoDong.gameObject then
		UnityEngine.PlayerPrefs.SetString('selectedGame', go.name)
	end
end

function this.OnClickButtonJoinRoom(go)
	AudioManager.Instance:PlayAudio('btn')
	--coroutine.start(StartGPS)
	print('房间'..tostring(roomInfo))
	print('房间号'..tostring(roomInfo.roomNumber))
	if panelInGame and panelInGame.fanHuiRoomNumber then 				-- 房主在lobby时能返回
		if panelInGame.SetMyAlpha then panelInGame.SetMyAlpha(1) end
		if panelInGame == panelInGame_pdk  then
			PanelManager.Instance:ShowWindow('panelInGame_pdk',gameObject.name)
		elseif panelInGame == panelInGamemj  then
			PanelManager.Instance:ShowWindow('panelInGamemj',gameObject.name)
		elseif panelInGame == panelInGame_xhzd  then
			PanelManager.Instance:ShowWindow('panelInGame_xhzd',gameObject.name)
		elseif panelInGame == panelInGameLand then
			PanelManager.Instance:ShowWindow('panelInGameLand',gameObject.name)
		elseif panelInGame == panelInGame_dtz then
			PanelManager.Instance:ShowWindow('panelInGame_dtz',gameObject.name)
		elseif panelInGame == panelInGame_bbtz then
			PanelManager.Instance:ShowWindow('panelInGame_bbtz',gameObject.name)
		elseif panelInGame == panelInGame_xplp then
			PanelManager.Instance:ShowWindow('panelInGame_xplp',gameObject.name)
		elseif panelInGame == panelInGame_hnhsm then
			PanelManager.Instance:ShowWindow('panelInGame_hnhsm',gameObject.name)
		elseif panelInGame == panelInGame_hnzzm then
			PanelManager.Instance:ShowWindow('panelInGame_hnzzm',gameObject.name)
		elseif panelInGame == panelInGame_yjqf then 
			PanelManager.Instance:ShowWindow('panelInGame_yjqf',gameObject.name)
		elseif panelInGame == panelInGame_dzahm then 
			PanelManager.Instance:ShowWindow('panelInGame_dzahm',gameObject.name)
		end
	else
		PanelManager.Instance:ShowWindow('panelJoinRoom')
	end
end

function this.OnClickbuttonClub(go)
	AudioManager.Instance:PlayAudio('btn')

	-- if panelInGame and panelInGame.fanHuiRoomNumber then
	-- 	panelMessageBox.SetParamers(ONLY_OK,this.OnClickButtonToRoom,nil,'您已经加入了一个房间，不可重复加入','进入房间')
	-- 	PanelManager.Instance:ShowWindow('panelMessageBox')
	-- else
		local msg = Message.New();
		msg.type = proxy_pb.ENTER_CLUB;
		local body = proxy_pb.PEnterClub();
		body.clubId= '';
		-- body.gameType=proxy_pb.PHZ
		msg.body = body:SerializeToString();
		SendProxyMessage(msg, this.OnEnterClubResult)
	-- end
end
--进入牌友群的回调
function this.OnEnterClubResult(msg)
	print('OnEnterClubResult')
	local data = proxy_pb.REnterClub();
	data:ParseFromString(msg.body);
	if data.queryRoom.existed then
		roomInfo.host = data.queryRoom.host
		roomInfo.port = data.queryRoom.port
		roomInfo.token = data.queryRoom.token
		roomInfo.roomNumber = data.queryRoom.roomNumber
		roomInfo.gameType = data.queryRoom.gameType
		roomInfo.roomType = data.queryRoom.roomType

		if data.queryRoom.gameType == proxy_pb.PDK then
			PanelManager.Instance:ShowWindow('panelInGame_pdk',gameObject.name)
		elseif data.queryRoom.gameType == proxy_pb.PHZ then
			PanelManager.Instance:ShowWindow('panelInGameLand',gameObject.name)
		elseif data.queryRoom.gameType == proxy_pb.MJ then
			PanelManager.Instance:ShowWindow('panelInGamemj',gameObject.name)
		elseif data.queryRoom.gameType == proxy_pb.XHZD  then
			PanelManager.Instance:ShowWindow('panelInGame_xhzd',gameObject.name)
		elseif data.queryRoom.gameType == proxy_pb.DTZ then
			PanelManager.Instance:ShowWindow('panelInGame_dtz',gameObject.name)
		elseif data.queryRoom.gameType == proxy_pb.BBTZ then
			PanelManager.Instance:ShowWindow('panelInGame_bbtz',gameObject.name)
		elseif data.queryRoom.gameType == proxy_pb.XPLP then
			PanelManager.Instance:ShowWindow('panelInGame_xplp',gameObject.name)
		elseif data.queryRoom.gameType == proxy_pb.HNM and data.queryRoom.roomType == proxy_pb.HNHSM then
			PanelManager.Instance:ShowWindow('panelInGame_hnhsm',gameObject.name)
		elseif data.queryRoom.gameType == proxy_pb.HNM and data.queryRoom.roomType == proxy_pb.HNZZM then
			PanelManager.Instance:ShowWindow('panelInGame_hnzzm',gameObject.name)
		elseif data.queryRoom.gameType == proxy_pb.YJQF then 
			PanelManager.Instance:ShowWindow('panelInGame_yjqf',gameObject.name)
		end
		return
	end

	if data.clubCount==0 then
		PanelManager.Instance:HideWindow('panelLobby')
		PanelManager.Instance:ShowWindow('panelClubHome','panelLobby')
	else
		local tmpData={}
		tmpData.name='panelLobby'
		tmpData.data = data
		PanelManager.Instance:ShowWindow('panelClub',tmpData)
	end
end

function this.OnClickButtonAddLink(go)
	AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:ShowWindow('panelBuyDiamond')
end

function this.OnClickButtonRecord(go)
	panelLogin.isLobbyRecord=true
	AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:ShowWindow('panelRecord',gameObject.name)
end

function this.OnClickButtonShare(go)
	AudioManager.Instance:PlayAudio('btn')
	local data={showName='shareGame'}
	PanelManager.Instance:ShowWindow('panelShared',data)
	--PlatformManager.Instance:GetAppsflyerUrl(userInfo.id)
end

function this.buyCallBack(errcode, strData)
	print('buyCallBack errcode:'..errcode..' strData:'..strData)
	if errcode ~= '0' then
		panelMessageBox.SetParamers(ONLY_OK, nil, nil, errcode == '1' and '该商品暂时无法购买' or '购买失败')
		PanelManager.Instance:ShowWindow('panelMessageBox')
	else
		local msg = Message.New()
		msg.type = proxy_pb.VALIDATE_RECEIPT
		local body = proxy_pb.PValidateReceipt()
		body.receipt = strData
		msg.body = body:SerializeToString()
		SendProxyMessage(msg, this.ValidateReceipt)
	end

	panelBuyDiamond.SetItemEnable(true)
end

function this.WXBuyCallBack(errcode)
	panelMessageTip.SetParamers(errcode == '0' and '购买成功' or '购买失败', 2)
	PanelManager.Instance:ShowWindow('panelMessageTip')
end

function this.ValidateReceipt(msg)
	print('ValidateReceipt')
	local b = proxy_pb.RValidateReceipt()
	b:ParseFromString(msg.body)
	userInfo.balance = b.balance
	info_login.balance = b.balance
	moneyNum:GetComponent('UILabel').text = info_login.balance
    if panelBuyDiamond then
        panelBuyDiamond.setMoneyNum(info_login.balance)
    end
end

function this.OnClickButtonKeFu(go)
    -- print('打开客服')
    -- PanelManager.Instance:ShowWindow('panelKeFu')
	panelMessageTip.SetParamers("客服系统维护中...",1,nil)
	PanelManager.Instance:ShowWindow('panelMessageTip')
end

function this.OnClickButtonToRoom()
	if panelInGame.SetMyAlpha then panelInGame.SetMyAlpha(1) end
	if panelInGame == panelInGame_pdk  then
		PanelManager.Instance:ShowWindow('panelInGame_pdk',gameObject.name)
	elseif panelInGame == panelInGamemj  then
		PanelManager.Instance:ShowWindow('panelInGamemj',gameObject.name)
	elseif panelInGame == panelInGame_xhzd  then
		PanelManager.Instance:ShowWindow('panelInGame_xhzd',gameObject.name)
	elseif panelInGame == panelInGameLand then
		PanelManager.Instance:ShowWindow('panelInGameLand',gameObject.name)
	elseif panelInGame == panelInGame_dtz then
		PanelManager.Instance:ShowWindow('panelInGame_dtz',gameObject.name)
	elseif panelInGame == panelInGame_bbtz then
		PanelManager.Instance:ShowWindow('panelInGame_bbtz', gameObject.name)
	elseif panelInGame == panelInGame_xplp then 
		PanelManager.Instance:ShowWindow('panelInGame_xplp', gameObject.name)
	elseif panelInGame == panelInGame_hnhsm then 
		PanelManager.Instance:ShowWindow('panelInGame_hnhsm', gameObject.name)
	elseif panelInGame == panelInGame_yjqf then 
		PanelManager.Instance:ShowWindow('panelInGame_yjqf',gameObject.name)
	end
	--PanelManager.Instance:ShowWindow('panelInGameLand',gameObject.name)
end


function this.WhoShow(data)
	print("data:"..data)
	PanelManager.Instance:HideWindow(data);
	this.HideReplayWindows();
end


function this.HideReplayWindows()
	PanelManager.Instance:HideWindow("panelReplay_dtz")
	PanelManager.Instance:HideWindow("panelReplay_mj")
	PanelManager.Instance:HideWindow("panelReplay_pdk")
	PanelManager.Instance:HideWindow("panelReplay")
	PanelManager.Instance:HideWindow("panelReplay_xhzd")
	PanelManager.Instance:HideWindow("panelReplay_yjqf")
end
