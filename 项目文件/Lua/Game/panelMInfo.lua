local json = require 'json'
local proxy_pb = require 'proxy_pb'
panelMInfo = {}
local this = panelMInfo;

local message
local gameObject
local mask

local nameLobby
local ipLobby
local iconLobby
local sexLobby
local moneyLobby
local posLobby
local idLobby
local lobbyRoot
local addressLabel

local bindPhone
local weixin
local shiMing
local yaoqingren 
local myvisitingcard

local buttonClose
local buttonAdd

local noSettingBtn
local noSettingLabel
local noSettingChange

function this.Awake(obj)
	gameObject = obj;

	nameLobby = gameObject.transform:Find('lobby/name')
    ipLobby = gameObject.transform:Find('lobby/ip')
    iconLobby = gameObject.transform:Find('lobby/icon/Texture')
    sexLobby = gameObject.transform:Find('lobby/sex')
	moneyLobby = gameObject.transform:Find('lobby/money/num')
	posLobby = gameObject.transform:Find('lobby/pos')
	idLobby = gameObject.transform:Find('lobby/id')
	lobbyRoot = gameObject.transform:Find('lobby')
	buttonClose = gameObject.transform:Find('BaseContent/ButtonClose')
	addressLabel = gameObject.transform:Find('lobby/address')

	bindPhone = gameObject.transform:Find('lobby/bindphone')
	weixin = gameObject.transform:Find('lobby/weixin')
	shiMing = gameObject.transform:Find('lobby/shiming')
	yaoqingren  = gameObject.transform:Find('lobby/yaoqingren')
	
	myvisitingcard = gameObject.transform:Find('lobby/visitingcard')

	buttonAdd = gameObject.transform:Find('lobby/money/button')
	
	noSettingBtn = gameObject.transform:Find('lobby/changePassword/noSettingBtn')
	noSettingLabel = gameObject.transform:Find('lobby/changePassword/noSettingLabel')
	noSettingChange  = gameObject.transform:Find('lobby/changePassword/noSettingChange')

    mask = gameObject.transform:Find('BaseContent/mask')
	message = gameObject:GetComponent('LuaBehaviour')
    message:AddClick(mask.gameObject, this.OnClickMask)
    message:AddClick(buttonClose.gameObject, this.OnClickMask)
    --message:AddClick(buttonAdd.gameObject, this.OnClickBuy)

	message:AddClick(bindPhone:Find('Label').gameObject, this.OnClickBindPhone)
	message:AddClick(bindPhone:Find('data/changeBtn').gameObject, function (go)
        AudioManager.Instance:PlayAudio('btn')
        PanelManager.Instance:ShowWindow('panelBindPhoneNum',3)
	end)
	message:AddClick(noSettingBtn.gameObject, function (go)
        AudioManager.Instance:PlayAudio('btn')
        PanelManager.Instance:ShowWindow('panelBindPhoneNum',2)
	end)
	message:AddClick(noSettingChange:Find('changeBtn').gameObject, this.OnClickChangePassword)
	message:AddClick(weixin:Find('no').gameObject, this.OnClickWeiXin)
	message:AddClick(shiMing:Find('Label').gameObject, this.OnClickShiMing)
	message:AddClick(yaoqingren:Find('Label').gameObject, this.OnClickYaoQingRen)
	message:AddClick(myvisitingcard.gameObject, this.OnClickMyVisitingCard)

	if IsAppleReview() then
		gameObject.transform:Find('lobby/money').gameObject:SetActive(false)
	end
end
function this.OnClickBuy(go)
	AudioManager.Instance:PlayAudio('btn')
	PanelManager.Instance:HideWindow(gameObject.name)
	PanelManager.Instance:ShowWindow('panelBuyDiamond')
end
function this.Start()
end
function this.Update()
    
end
function this.OnEnable()
end
function this.WhoShow(data)
	print('WhoShowminfo')
    
	lobbyRoot.gameObject:SetActive(true)
	
	nameLobby:GetComponent('UILabel').text = data.nickname
	if data.balance and IsAppleReview()==false then
		moneyLobby.parent.gameObject:SetActive(true)
		moneyLobby:GetComponent('UILabel').text = data.balance
	else
		moneyLobby.parent.gameObject:SetActive(false)
	end
	if info_login.id ~= data.id then moneyLobby.parent.gameObject:SetActive(false) end
	idLobby:GetComponent('UILabel').text = 'ID:'..(data.userId~=nil and data.userId or data.id)
	if data.address then
		addressLabel:GetComponent('UILabel').text=data.address
	end
	
	--posLobby:GetComponent('UILabel').text = ''

	--print(userInfo.sex)
    -- if userInfo.sex == 1 then
    --     sexLobby:GetComponent('UISprite').spriteName = 'man'
    -- else
    --     sexLobby:GetComponent('UISprite').spriteName = 'woman'
    -- end
    
	ipLobby:GetComponent('UILabel').text ='IP:'.. data.ip
	coroutine.start(LoadPlayerIcon, iconLobby:GetComponent('UITexture'), data.icon)

	print('手机号'..userInfo.phone)
	this.RefreshPhone()

	shiMing:Find('Label').gameObject:SetActive(not userInfo.hasNameAuth)
	shiMing:Find('data').gameObject:SetActive( userInfo.hasNameAuth)

	weixin:Find('no').gameObject:SetActive(true)
	weixin:Find('yes').gameObject:SetActive(false)
	
	yaoqingren:Find('Label').gameObject:SetActive(#userInfo.inviterId ==0)
	yaoqingren:Find('data').gameObject:SetActive(#userInfo.inviterId ~=0)

	print('邀请码：'..info_login.inviterId)
	if proxy_pb.RInvitatedUsers().users then
		yaoqingren:Find('data'):GetComponent('UILabel').text = userInfo.inviterId
	end
end

function this.RefreshPhone()
	if #userInfo.phone ~= 0 then	
		bindPhone:Find('data'):GetComponent('UILabel').text = userInfo.phone 
	end

	bindPhone:Find('data').gameObject:SetActive(#userInfo.phone ~= 0) 
	bindPhone:Find('Label').gameObject:SetActive(#userInfo.phone == 0)
	
	noSettingBtn.gameObject:SetActive(not userInfo.passWord)
	noSettingLabel.gameObject:SetActive(not userInfo.passWord)
	noSettingChange.gameObject:SetActive(userInfo.passWord)
end

function this.OnClickMask(go)
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickBindPhone(go)
	PanelManager.Instance:HideWindow(gameObject.name)
	PanelManager.Instance:ShowWindow('panelBindPhoneNum',1)
end

function this.OnClickShiMing(go)
	PanelManager.Instance:HideWindow(gameObject.name)
	PanelManager.Instance:ShowWindow('panelShiMing')
end
function this.OnClickYaoQingRen (go)
	PanelManager.Instance:HideWindow(gameObject.name)
	PanelManager.Instance:ShowWindow('panelYaoQingMa')
end

function this.OnClickMyVisitingCard(go)
	PanelManager.Instance:HideWindow(gameObject.name)
	local userData = {}
    userData.whoShow = gameObject.name
    -- userData.nickname = info_login.nickname
    -- userData.icon = info_login.icon
    -- userData.sex = info_login.sex
    -- userData.ip = info_login.ip
	userData.userId = info_login.id
    -- userData.balance = info_login.balance
	PanelManager.Instance:ShowWindow('panelVisitingCard',userData)
end

function this.OnClickChangePassword(go)
	AudioManager.Instance:PlayAudio('btn')
	PanelManager.Instance:ShowWindow('panelBindPhoneNum',4)
end