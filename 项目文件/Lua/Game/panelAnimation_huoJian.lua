panelAnimation_huoJian = {}
local this = panelAnimation_huoJian;

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
		WaitForSeconds(1.233)
		gameObject:SetActive(false)
	end)
end

function this.WhoShow()
end