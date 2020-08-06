panelClubHome = {}
local this = panelClubHome;



local message;
local gameObject;

local buttonAdd
local buttonMessage
local buttonHelp
local buttonSetting

local buttonCreateClub
local buttonApply
local buttonClose

local buttonAddLink
local buttonRecord
local buttonShare
local buttonShouChong

this.panelSetClub={}
local inputName
local inputWanFa

local panelSeccesful
local SeccesfulName
local SeccesfulID

local marqueeBG
local marqueeLabel

local marqueeList = proxy_pb.RMarqueeList() 

local createClubsID--创建的牌友群的id

function this.Awake(obj)
	
	gameObject = obj;
	this.gameObject = obj
	message = gameObject:GetComponent('LuaBehaviour');

	panelSeccesful = gameObject.transform:Find('panelSeccesful');
	SeccesfulName = panelSeccesful:Find('name')
	SeccesfulID = panelSeccesful:Find('id')
	message:AddClick(panelSeccesful:Find('BaseContent/ButtonClose').gameObject, this.OnClickClosepanelSeccesful);
	message:AddClick(panelSeccesful:Find('ButtonCopy').gameObject, this.OnClickCopy);
	message:AddClick(panelSeccesful:Find('ButtonBind').gameObject, this.OnClickPanelSeccesfulSure);

	this.panelSetClub = gameObject.transform:Find('panelSetClub');
	inputName = this.panelSetClub:Find('right/inputName')
	inputWanFa = this.panelSetClub:Find('right/inputNum/wanFa')
	message:AddClick(this.panelSetClub:Find('BaseContent/ButtonClose').gameObject, this.OnClickClosePanelSetClub);
	message:AddClick(this.panelSetClub:Find('right/ButtonBind').gameObject, this.OnClickPanelSetClubSure);
	--message:AddClick(this.panelSetClub:Find('right/ButtonSet').gameObject, this.OnClickSetWanFa);
    buttonCreateClub = gameObject.transform:Find('middle/ButtonCreate');
	buttonApply = gameObject.transform:Find('middle/ButtonApply');
	buttonClose = gameObject.transform:Find('middle/ButtonClose');


	
	marqueeBG = gameObject.transform:Find('top/Sprite/bg');
	marqueeLabel = gameObject.transform:Find('top/Notcie/Label');

	

    message:AddClick(buttonCreateClub.gameObject, this.OnClickbuttonCreateClub);
    message:AddClick(buttonApply.gameObject, this.OnClickButtonApply);
	message:AddClick(buttonClose.gameObject, this.OnClickbuttonClose);

	
	if IsAppleReview() then
		--gameObject.transform:Find('top/money').gameObject:SetActive(false)
		--buttonShare.gameObject:SetActive(false)
	end
end

function this.OnClickClosePanelSetClub()
	AudioManager.Instance:PlayAudio('btn')
	this.panelSetClub.gameObject:SetActive(false)
end
function this.setWanFaLabel(wanfa)
	if wanfa==0 then
		inputWanFa:GetComponent('UILabel').text='邵阳字牌'
	elseif wanfa==1 then
		inputWanFa:GetComponent('UILabel').text='邵阳剥皮'
	elseif wanfa==2 then
		inputWanFa:GetComponent('UILabel').text='怀化红拐弯'
	elseif wanfa==6 then
		inputWanFa:GetComponent('UILabel').text='娄底放炮罚'
	elseif wanfa==7 then
		inputWanFa:GetComponent('UILabel').text='常德跑胡子'
	elseif wanfa==9 then
		inputWanFa:GetComponent('UILabel').text='长沙跑胡子'
	end
end
function this.OnClickPanelSetClubSure()
	AudioManager.Instance:PlayAudio('btn')
	local inputText=trim(inputName:GetComponent('UIInput').value)
	if inputText~='' and #inputText <= 21 then
		this.panelSetClub.gameObject:SetActive(false)
		local msg = Message.New()
		msg.type = proxy_pb.CREATE_CLUB
		local body = proxy_pb.PCreateClub();
		body.name=inputText;
		
		msg.body = body:SerializeToString();
		SendProxyMessage(msg, this.OnCreateClubResult);
	else
		if #inputText > 21 then
			panelMessageTip.SetParamers('牌友群名称不能超过七个字', 1)
			PanelManager.Instance:ShowWindow('panelMessageTip')
		else
		panelMessageTip.SetParamers('请输入牌友群名称', 1)
		PanelManager.Instance:ShowWindow('panelMessageTip')
		end
	end
	
end
function this.OnCreateClubResult(msg)
	print('OnCreateClubResult')
	local b = proxy_pb.RCreateClub();
    b:ParseFromString(msg.body);
	createClubsID=b.clubId
	panelSeccesful.gameObject:SetActive(true)
	SeccesfulName:GetComponent('UILabel').text='恭喜你，你的牌友群[ff0000]'..b.name..'[-]创建成功！'
	SeccesfulID:GetComponent('UILabel').text='群ID：'..b.clubId
	print('name:'..b.name..' gameType:'..tostring(b.gameType)..' memberSize:'..tostring(b.memberSize)
	..' clubSize:'..tostring(b.clubSize)..' createTime:'..tostring(b.createTime))

end


function this.OnClickClosepanelSeccesful()
	AudioManager.Instance:PlayAudio('btn')
	this.panelSetClub.gameObject:SetActive(false)
	PanelManager.Instance:HideWindow('panelLobby')
	local data={}
	data.name='panelClubHome'
	data.clubId=createClubsID
	PanelManager.Instance:ShowWindow('panelClub',data)
end

function this.OnClickPanelSeccesfulSure()
	panelSeccesful.gameObject:SetActive(false)
	AudioManager.Instance:PlayAudio('btn')
	PanelManager.Instance:HideWindow('panelLobby')
	local data={}
	data.name='panelClubHome'
	data.clubId=createClubsID
	PanelManager.Instance:ShowWindow('panelClub',data)

end

function this.OnClickCopy()
	AudioManager.Instance:PlayAudio('btn')
    local copyString=createClubsID
    Util.CopyToSystemClipbrd(copyString)
    panelMessageTip.SetParamers('复制成功', 1.5)
	PanelManager.Instance:ShowWindow('panelMessageTip')
end

function this.Start()
	
end

function this.OnEnable()
	RegisterProxyCallBack(proxy_pb.REFRESH, this.refreshClub);
	userInfo.nickname = info_login.nickname
    userInfo.icon = info_login.icon
    userInfo.sex = info_login.sex
    userInfo.ip = info_login.ip
	userInfo.balance = info_login.balance
	userInfo.id = info_login.id
end
function this.refreshClub(msg)
	local b = proxy_pb.RRefresh()
	b:ParseFromString(msg.body)
	print('刷新牌友群'..b.userId)
	if b.operation==proxy_pb.ADD_MEMBER then
		print('刷新牌友群新增玩家')
		
	elseif b.operation==proxy_pb.PASS_JOIN then
		print('刷新牌友群同意指定玩家加入某个牌友群')
		panelMessageTip.SetParamers('加入牌友群成功。', 1)
		PanelManager.Instance:ShowWindow('panelMessageTip')
		if panelInGame and panelInGame.gameObject.activeSelf then
			return
		end
		local tmpData={}
		tmpData.name=gameObject.name
		PanelManager.Instance:ShowWindow('panelClub',tmpData)
	elseif b.operation==proxy_pb.QUIT_CLUB then
		print('刷新牌友群玩家退出牌友群')
	elseif b.operation==proxy_pb.NEED_REFRESH then
		print('刷新牌友群刷新牌友群')
	elseif b.operation==proxy_pb.UPDATE_USER_TYPE then
		print('刷新牌友群更新玩家用户类型')
	end
end
function this.OnClickbuttonCreateClub(go)
	print('OnClickbuttonCreateClub')
	AudioManager.Instance:PlayAudio('btn')
	-- if userInfo.balance<100 then
	-- 	panelMessageBox.SetParamers(ONLY_OK, this.OnClicButtonToBuy, nil, '钻石不足\n开通需要消耗100个钻石', '充 值')
	-- 	PanelManager.Instance:ShowWindow('panelMessageBox')
	-- 	return
	-- end
	print('userInfo.phone : '..userInfo.phone)
	if (userInfo.phone == nil or userInfo.phone == '' ) and userInfo.userType == 0 then
		PanelManager.Instance:ShowWindow('panelBindPhoneNum',1)
	else
		this.panelSetClub.gameObject:SetActive(true)
	end
end
function this.Update()
   
end
function this.OnClicButtonToBuy()
	PanelManager.Instance:ShowWindow('panelBuyDiamond')
end

function this.OnClickButtonApply(go)
	print('OnClickButtonApply')
	AudioManager.Instance:PlayAudio('btn')
	--coroutine.start(StartGPS)
    PanelManager.Instance:ShowWindow('panelClubApply')
end

local whoS
function this.WhoShow(name)
	whoS=name
	createClubsID = nil
end

function this.OnClickbuttonClose(go)
	print('OnClickbuttonClose')
	AudioManager.Instance:PlayAudio('btn')
	print("谁打开的："..whoS)
	if whoS=='panelClub' then
		local data={}
		data.name='panelClubHome'
		data.clubId=createClubsID
		PanelManager.Instance:ShowWindow('panelClub',data)
	elseif whoS=='panelLobby' then
        PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
	end
end


