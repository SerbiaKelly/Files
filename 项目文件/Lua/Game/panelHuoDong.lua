panelHuoDong = {}
local this = panelHuoDong;
local message;
local gameObject;
local mask
local ButtonClose

function this.Awake(obj)
	gameObject 					= obj;
	message 					= gameObject:GetComponent('LuaBehaviour');
    mask = gameObject.transform:Find('mask');
   
	ButtonClose = gameObject.transform:Find('ButtonClose')
	
    message:AddClick(ButtonClose.gameObject, this.OnClickMask);
	
end


function this.Start()
	
	
end 


function this.OnEnable()
    
end

function this.Update()
    
end




function this.OnClickMask(go)
    PanelManager.Instance:HideWindow(gameObject.name)
end