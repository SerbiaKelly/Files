

panelGuiZe = {}
local this = panelGuiZe;

local message;
local gameObject;
local buttonClose
local mask

--���¼�--
function this.Awake(obj)
	gameObject = obj;

    mask = gameObject.transform:Find('mask');
	buttonClose = gameObject.transform:Find('ButtonClose')

	message = gameObject:GetComponent('LuaBehaviour');
    message:AddClick(buttonClose.gameObject, this.OnClickMask);
end
function this.Update()
    
end
function this.Start()
end

function this.OnEnable()
end

--�����¼�--
function this.OnClickMask(go)
    PanelManager.Instance:HideWindow(gameObject.name)
end
