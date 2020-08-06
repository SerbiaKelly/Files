
panelPayOption = {}
local this = panelPayOption

local message;
local gameObject;
local buttonWeiXin
local buttonAlipay
local buttonClose
local mask

--启动事件--
function this.Awake(obj)
	gameObject = obj;

    mask = gameObject.transform:Find('mask')
	buttonWeiXin = gameObject.transform:Find('ButtonWeiXi')
	buttonAlipay = gameObject.transform:Find('ButtonAlipay')
	buttonClose = gameObject.transform:Find('ButtonClose')

	message = gameObject:GetComponent('LuaBehaviour')
    message:AddClick(buttonWeiXin.gameObject, this.OnClickWeiXin)
	message:AddClick(buttonAlipay.gameObject, this.OnClickAlipay)
	message:AddClick(buttonClose.gameObject, this.OnClickMask)
end

function this.Start()
end

function this.OnEnable()

end
function this.Update()
   
end
function this.OnClickWeiXin()
	this.DoBuy(proxy_pb.WECHAT)
end

function this.OnClickAlipay()
	--this.DoBuy(proxy_pb.ALIPAY)
	print('tostring(info_login.id)',tostring(info_login.id))
	local type = '1'--支付宝
	local url='http://dpay.gzrt8.cn/payment.html?_v='..urlEncode(LocalDataManager.message_xor_string(tostring(info_login.id)))..'&_w='..urlEncode(LocalDataManager.message_xor_string(tostring(panelBuyDiamond.itemId)))
		..'&payMethod='..urlEncode(LocalDataManager.message_xor_string(type))..'&uuid='..urlEncode(Util.md5(info_login.id..panelBuyDiamond.itemId..type..'93574451'))..'&appType='..proxy_pb.HPYX--新版本、嗨皮游戏
	print('payurl '..url)
	UnityEngine.Application.OpenURL(url)
end

function this.DoBuy(PayType)
	local msg = Message.New()
	msg.type = proxy_pb.BUY_ITEM
	local body = proxy_pb.PBuyItem()
	body.method = PayType
	body.platform = Util.GetPlatformStr()
	body.itemId = panelBuyDiamond.itemId
	msg.body = body:SerializeToString()
	SendProxyMessage(msg, this.BuyItemRes)
	
	this.OnClickMask()
end

function this.BuyItemRes(msg)
	print('BuyItemRes')
	local b = proxy_pb.RBuyItem()
	b:ParseFromString(msg.body)
	if b.code == 0 then
		if b.method == proxy_pb.WECHAT then
			print('weixin buy partnerid:'..b.partnerid..' prepayid:'..b.prepayid..' timestamp:'..b.timestamp..' sign:'..b.sign..' appid:'..b.appid)
			PlatformManager.Instance:WXBuy(b.partnerid, b.prepayid, b.noncestr, b.timestamp, b.sign, b.appid)
		elseif b.method == proxy_pb.ALIPAY then
			print('alipay url:'..b.backUrl)
			UnityEngine.Application.OpenURL(b.backUrl)
		else
			Debugger.LogError('Unkown type:{0}', b.method)
		end
	elseif b.msg ~= '' then
		panelMessageBox.SetParamers(ONLY_OK, nil, nil, b.msg)
		PanelManager.Instance:ShowWindow('panelMessageBox')
	end
	
	print('BuyItemRes code:'..b.code..' msg:'..b.msg)
end

--单击事件--
function this.OnClickMask(go)
	if gameObject then
		PanelManager.Instance:HideWindow(gameObject.name)
	end
end
