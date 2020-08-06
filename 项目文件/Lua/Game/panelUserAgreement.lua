

panelUserAgreement = {}
local this = panelUserAgreement

local message
local gameObject
local ButtonClose
local mask

function this.Awake(obj)
	gameObject = obj
    mask = gameObject.transform:Find('BaseContent/mask')
	message = gameObject:GetComponent('LuaBehaviour')
	ButtonClose = gameObject.transform:Find('BaseContent/ButtonClose')
    message:AddClick(ButtonClose.gameObject, this.OnClickMask)
end
function this.Update()
   
end
function this.Start()
end

function this.OnEnable()
end

function this.OnClickMask(go)
    PanelManager.Instance:HideWindow(gameObject.name)
end