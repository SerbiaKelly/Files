
panelShowSetting = {}
local this = panelShowSetting

local message
local gameObject

local buttonOK
local buttonClose
local toggleOnlyPlay
local toggleHidePlay

function this.Awake(obj)
	gameObject = obj

	buttonOK = gameObject.transform:Find('ButtonOK')
	buttonClose = gameObject.transform:Find('ButtonClose')

	toggleOnlyPlay = gameObject.transform:Find('onlyPlay')
	toggleHidePlay = gameObject.transform:Find('hidePlay')

	message = gameObject:GetComponent('LuaBehaviour')

	message:AddClick(buttonOK.gameObject,this.OnClickButtonOK)
	message:AddClick(buttonClose.gameObject,this.OnClickButtonClose)
end

function this.Start()
end

function this.OnEnable()
	toggleOnlyPlay:GetComponent('UIToggle'):Set(panelClub.clubInfo.displayCurrentPlay)
	toggleHidePlay:GetComponent('UIToggle'):Set(panelClub.clubInfo.displayAllPlay)
end
function this.Update()
end

function this.OnClickButtonOK(go)
	AudioManager.Instance:PlayAudio('btn')
	local msg = Message.New()
    msg.type = proxy_pb.UPDATE_CLUB_USER_DISPLAY_PLAY
    local body = proxy_pb.PUpdateUserDisplayPlay()
    body.clubId = panelClub.clubInfo.clubId
    body.displayCurrentPlay = toggleOnlyPlay:GetComponent("UIToggle").value
    body.displayAllPlay = toggleHidePlay:GetComponent("UIToggle").value
    msg.body = body:SerializeToString()
	SendProxyMessage(msg, nil)
	PanelManager.Instance:HideWindow(gameObject.name)
end
function this.OnClickButtonClose(go)
	AudioManager.Instance:PlayAudio('btn')
	PanelManager.Instance:HideWindow(gameObject.name)
end
