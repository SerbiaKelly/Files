require 'panelPayOption'

panelBuyDiamond={}
local this=panelBuyDiamond

local message;
local gameObject;
local ButtonClose
local uiGrid
local tip
local moneyNum

local ButtonDaiLi
local ButtonHuoDong
local ButtonMore

local corFunc

this.itemId = 0


--���¼�--
function this.Awake(obj)
	gameObject = obj;
	
	ButtonDaiLi = gameObject.transform:Find('ButtonDaiLi')
	ButtonHuoDong = gameObject.transform:Find('ButtonHuoDong')
	ButtonMore = gameObject.transform:Find('ButtonMore')
	moneyNum = gameObject.transform:Find('moneyNum/Label')
	tip = gameObject.transform:Find('tip')
    uiGrid = gameObject.transform:Find('Panel/Grid')
    ButtonClose = gameObject.transform:Find('ButtonClose');
	message = gameObject:GetComponent('LuaBehaviour');
    message:AddClick(ButtonClose.gameObject, this.OnClickMask);
    message:AddClick(ButtonDaiLi.gameObject, this.OnClickDaiLi);
    message:AddClick(ButtonHuoDong.gameObject, this.OnClickHuoDong);
	message:AddClick(ButtonMore.gameObject, this.OnClickMore);
	if IsAppleReview() then
		ButtonDaiLi.gameObject:SetActive(false)
		ButtonHuoDong.gameObject:SetActive(false)
		ButtonMore.gameObject:SetActive(false)
	end
end

function this.OnClickDaiLi(go)
	AudioManager.Instance:PlayAudio('btn')
	PanelManager.Instance:HideWindow(gameObject.name)
	PanelManager.Instance:ShowWindow('panelNotice','daiLi')
end
function this.OnClickHuoDong(go)
	AudioManager.Instance:PlayAudio('btn')
	PanelManager.Instance:HideWindow(gameObject.name)
	PanelManager.Instance:ShowWindow('panelNotice','huoDong')
end
function this.OnClickMore(go)
	AudioManager.Instance:PlayAudio('btn')
	PanelManager.Instance:HideWindow(gameObject.name)
	PanelManager.Instance:ShowWindow('panelNotice','gongGao')
end
function this.Start()
    for i=0,uiGrid.childCount-1 do
        message:AddClick(uiGrid:GetChild(i).gameObject, this.OnClickItem);
    end
end
function this.Update()
   
end
function this.OnEnable()
	this.itemId = 0
	this.setMoneyNum(info_login.balance)
	if not IsAppleReview() and isLogin then
		local msg = Message.New()
		msg.type = proxy_pb.FIRST_RECHARGE
		SendProxyMessage(msg, this.OnGetMsgFirstRecharge)
	end
end
--设置钻石余额
function this.setMoneyNum(num)
	moneyNum:GetComponent('UILabel').text=num
end

function this.OnGetMsgFirstRecharge(msg)
	print('OnGetMsgFirstRecharge')
	local b = proxy_pb.RFirstRecharge()
	b:ParseFromString(msg.body)
	tip.gameObject:SetActive(not b.haveRecharge)
end

function this.OnClickMask(go)
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickItem(go)
	if IsAppleReview() then
		local label = go.transform:Find('id'):GetComponent('UILabel')
		PlatformManager.Instance:Buy(label.text)
		this.SetItemEnable(false)
		
		print('buy diamond: '..label.text)
	else
		this.itemId = tonumber(go.transform:Find('id_weixin'):GetComponent('UILabel').text)
		PanelManager.Instance:ShowWindow('panelPayType')
		print('buy diamond: '..this.itemId)
	end
end

function this.AutoUnLock()
	coroutine.wait(15)
	this.SetItemEnable(true)
end

function this.SetItemEnable(enable)
	for i=0,uiGrid.childCount-1 do
		local item = uiGrid:GetChild(i)
		item:GetComponent('BoxCollider').enabled = enable
	end
	
	if corFunc then
		coroutine.stop(corFunc)
		corFunc = nil
	end
	
	if not enable then
		corFunc = coroutine.start(this.AutoUnLock)
	end
end
