panelAnimation_feiJi = {}
local this = panelAnimation_feiJi;

local message
local gameObject

function this.Awake(obj)
	gameObject = obj;
	message = gameObject:GetComponent('LuaBehaviour');
end

function this.Start()
end
function this.Update()
end

function this.OnEnable()
	StartCoroutine(function()
		WaitForSeconds(1.9)
		gameObject:SetActive(false)
	end)
end

function this.WhoShow()
end