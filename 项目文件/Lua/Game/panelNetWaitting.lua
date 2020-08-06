
panelNetWaitting = {}
local this = panelNetWaitting;

local message;
local gameObject;

local waitIcon
local mask

--���¼�--
function this.Awake(obj)
	gameObject = obj;

    --waitIcon = gameObject.transform:Find('wait');
    mask = gameObject.transform:Find('mask');
	message = gameObject:GetComponent('LuaBehaviour');
    --message:AddClick(mask.gameObject, this.OnClickMask);
end

function this.Start()
end

function this.OnEnable()
	for i=0,2 do
		gameObject.transform:GetChild(i).gameObject:SetActive(false)
	end
	coroutine.start(this.WaitRotation)
end
function this.Update()
   
end
function this.WaitRotation()
	coroutine.wait(0.5)
	for i=0,2 do
		gameObject.transform:GetChild(i).gameObject:SetActive(true)
	end
end


--�����¼�--
function this.OnClickMask(go)
    PanelManager.Instance:HideWindow(gameObject.name)
end