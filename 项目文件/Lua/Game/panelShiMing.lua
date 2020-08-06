local proxy_pb = require 'proxy_pb'

panelShiMing = {}
local this = panelShiMing

local gameObject
local ButtonClose
local inputName
local ButtonBind
local inputNum

local bindErrorNum = 0

--启动事件--
function this.Awake(obj)
	gameObject = obj

	ButtonClose = gameObject.transform:Find('BaseContent/ButtonClose')
	inputName = gameObject.transform:Find('right/inputName')
	ButtonBind = gameObject.transform:Find('right/ButtonBind')
	inputNum = gameObject.transform:Find('right/inputNum')

	message = gameObject:GetComponent('LuaBehaviour')
    message:AddClick(ButtonClose.gameObject, this.OnButtonClose)
	message:AddClick(ButtonBind.gameObject, this.OnClickButtonBind)
	message:AddSubmit(inputName.gameObject, this.OnInputNameSubmit)
	message:AddSubmit(inputNum.gameObject, this.OnInputNumSubmit)
	
	--EventDelegate.AddForLua(input:GetComponent('UIInput').onSubmit, this.OnInputSubmit)

end
function this.Update()
   
end
function this.Start()
end

function this.OnEnable()
	ButtonBind:GetComponent('UIButton').isEnabled = false
	inputName:GetComponent('UIInput').value=''
	inputNum:GetComponent('UIInput').value=''
end

function this.OnClickButtonBind(go)
	AudioManager.Instance:PlayAudio('btn')
	ButtonBind:GetComponent('UIButton').isEnabled = false
	
	local msg = Message.New()
    msg.type = proxy_pb.NAME_AUTHENTICATE
	local body = proxy_pb.PNameAuthenticate()
	body.name = inputName:GetComponent('UIInput').value
	body.idCard = inputNum:GetComponent('UIInput').value
	msg.body = body:SerializeToString()
	SendProxyMessage(msg, this.OnBindResult)
end



function this.OnInputNameSubmit(go)
	print('输入完成'..string.len(inputName:GetComponent('UIInput').value))
	-- if string.len(input:GetComponent('UIInput').value)==11 then
	-- 	ButtonGet:GetComponent('UIButton').isEnabled = true
	-- else
	-- 	ButtonGet:GetComponent('UIButton').isEnabled = false
	-- end
end

function this.OnInputNumSubmit(go)
	if string.len(inputNum:GetComponent('UIInput').value)==18 then
		ButtonBind:GetComponent('UIButton').isEnabled = true
	else
		ButtonBind:GetComponent('UIButton').isEnabled = false
	end
end




function this.OnBindResult(msg)
	local b = proxy_pb.RResult();
    b:ParseFromString(msg.body);
	if b.code==1 then
		ButtonBind:GetComponent('UIButton').isEnabled = false
		--info_login.phone = inputName:GetComponent('UIInput').value
		--inputName:GetComponent('BoxCollider').enabled = false
		userInfo.hasNameAuth=true
		panelMessageTip.SetParamers('实名认证成功', 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
		PanelManager.Instance:HideWindow(gameObject.name)
	else
		inputNum:GetComponent('UIInput').value=''
		ButtonBind:GetComponent('UIButton').isEnabled = false
		panelMessageTip.SetParamers('实名认证失败'..b.msg, 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	end
end



--单击事件--
function this.OnButtonClose(go)
    PanelManager.Instance:HideWindow(gameObject.name)
end