
panelMessageTip = {}
local this = panelMessageTip;

local message;
local gameObject;

local labelMessage
local mask

function this.Awake(obj)
	gameObject = obj;

    mask = gameObject.transform:Find('mask')
    labelMessage = gameObject.transform:Find('message')

	message = gameObject:GetComponent('LuaBehaviour')
    message:AddSubmit(labelMessage:Find('bg').gameObject, this.onclickBG)
end

function this.onclickBG(go)
	if panelMessageTipFuc~=nil then
		gameObject:SetActive(false)
		panelMessageTipFuc()
	end
end

function this.Start()
end

function this.OnEnable()
	if panelMessageTipMsg then
		labelMessage:GetComponent('UILabel').text = panelMessageTipMsg
	else
		labelMessage:GetComponent('UILabel').text = ''
	end
	coroutine.start(this.mUpdate)
end
function this.Update()
   
end
function this.SetParamers(tmessage, show_time, func)
	panelMessageTipShowTime = show_time
	panelMessageTipMsg = tmessage
	panelMessageTipFuc = func
end

function this.mUpdate()
	while panelMessageTipShowTime > 0 do
		coroutine.wait(0.5)
		panelMessageTipShowTime = panelMessageTipShowTime - 0.5
	end
	if panelMessageTipFuc~=nil then
		return
	else
		gameObject:SetActive(false)
	end
end