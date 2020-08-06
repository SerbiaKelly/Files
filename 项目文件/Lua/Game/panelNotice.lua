panelNotice = {}
local this = panelNotice;
local tip
local message;
local gameObject;
local mask
local labelMessage
local ButtonClose
local messageList
local Grid
local hongbaoyuToggle
local reportCheatToggle
local firstTimeChargeToggle
local prefabItem
local input
local gongGaoTime
local ButtonCopy


local contactInput--联系方式的输入框
local contactButton--联系方式的提交按钮
this.msg =''
local messageListGO={}

function this.Awake(obj)
	gameObject 					= obj;
	message 					= gameObject:GetComponent('LuaBehaviour');
	

	-- contactInput 				= gameObject.transform:Find('PanelDaiLiYouJiang/recievedi');
	-- contactButton 				= contactInput:Find('buttonrecieve');

    mask = gameObject.transform:Find('BaseContent/mask');
   
	ButtonClose = gameObject.transform:Find('BaseContent/ButtonClose')
	Grid = gameObject.transform:Find('Table')
	hongbaoyuToggle = Grid:Find('hongbaoyu')
	reportCheatToggle = Grid:Find('reportCheat')
	firstTimeChargeToggle = Grid:Find('firstTimeCharge')
	--ButtonCopy = gameObject.transform:Find('PanelDaiLiYouJiang/copydi/buttoncopy')
	--message:AddClick(ButtonCopy.gameObject,this.OnClickButtonCopy)
    message:AddClick(ButtonClose.gameObject, this.OnClickMask);
    -- message:AddClick(contactButton.gameObject, this.OnClickContactButton);
    --message:AddClick(gameObject.transform:Find('PanelreportCheat/noticeTextrue').gameObject, this.OnClickCopyButton);
	
end


function this.WhoShow(name)
	-- noticeToggle:GetComponent('UIToggle'):Set(name=='gongGao')
	-- messageToggle:GetComponent('UIToggle'):Set(name=='daiLi')
	-- huoDongToggle:GetComponent('UIToggle'):Set(name=='huoDong')
end
function this.Start()
	
	
end 


function this.OnEnable()
	for i=0,Grid.childCount-1 do
		Grid:GetChild(i):GetComponent('UIToggle'):Set(false)
	end
	if info_login.userType>0 and false then
		gameObject.transform:Find('hongbaoyulg').gameObject:SetActive(true)
		hongbaoyuToggle.gameObject:SetActive(true)
		hongbaoyuToggle:GetComponent('UIToggle'):Set(true)
	else
		gameObject.transform:Find('hongbaoyulg').gameObject:SetActive(false)
		hongbaoyuToggle.gameObject:SetActive(false)
		reportCheatToggle:GetComponent('UIToggle'):Set(true)
	end
	Grid:GetComponent('UIGrid'):Reposition()
end

function this.OnClickCopyButton(go)
	Util.CopyToSystemClipbrd("hnhaipi");
    panelMessageTip.SetParamers('复制成功', 1.5)
	PanelManager.Instance:ShowWindow('panelMessageTip')	
end


function this.OnClickContactButton(go)
	AudioManager.Instance:PlayAudio('btn')
	if userInfo.contact and userInfo.contact~='' then
		panelMessageTip.SetParamers('您已提交过联系方式，请勿重复提交', 1)
		PanelManager.Instance:ShowWindow('panelMessageTip')
		return
	end
	local inputText=trim(contactInput:GetComponent('UIInput').value)
	if inputText~='' then
		local msg = Message.New()
		msg.type = proxy_pb.ADD_CONTACT_INFO
		local body = proxy_pb.PAddContactInfo();
		body.contact=inputText
		msg.body = body:SerializeToString()
		SendProxyMessage(msg, this.OnResult)
	else
		panelMessageTip.SetParamers('请输入联系方式', 1)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	end
end

function this.OnResult(msg)
	local b = proxy_pb.RResult();
    b:ParseFromString(msg.body);
	if b.code==1 then
		panelMessageTip.SetParamers('提交成功，请耐心等待工作人员联系', 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	end
end

function this.getHuoDong(go)
	
end

function this.getMessage(go)
	
	
end
function this.getNotice(go)
	
end
function this.OnGetNotice(msg)

	this.Refresh()
end
function this.RefreshNotice(data)

end
function this.Update()

end
function this.OnGetMessage(msg)
	
    this.Refresh()
end

function this.Refresh()
	
end

function this.ButtonAgree(go)
	
end


function this.ButtonDisagree(go)

end

function this.OnClickMask(go)
	PanelManager.Instance:HideWindow(gameObject.name)
	--PanelManager.Instance:ShowWindow('panelHuoDong')
end

function this.agreeResult(msg)
	
end
function this.disagreeResult(msg)

end

function this.OnClickButtonCopy()
	AudioManager.Instance:PlayAudio('btn')
	local copyString = 'hnhaipi'				--微信客服公众号
	Util.CopyToSystemClipbrd(copyString)
	panelMessageTip.SetParamers('复制成功', 1.5)
	PanelManager.Instance:ShowWindow('panelMessageTip')
end








