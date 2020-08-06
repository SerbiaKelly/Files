panelAnimation_xi = {}
local this = panelAnimation_xi;

local message
local gameObject

local xi
local zi
local guang
local huo

function this.Awake(obj)
	gameObject = obj;
	message = gameObject:GetComponent('LuaBehaviour');
	
	xi = gameObject.transform:Find('xi')
	zi = xi:Find('1')
	guang = xi:Find('2')
	huo = xi:Find('3')
end

function this.Start()
end
function this.Update()
end

function this.OnEnable()
	
end

local boomCoroutine
function this.init()
	if boomCoroutine then
		xi.gameObject:SetActive(false)
		zi.gameObject:SetActive(true)
		zi:GetComponent('UISprite').color=Color(1,1,1,1)
		guang.gameObject:SetActive(false)
		huo.gameObject:SetActive(false)
		StopCoroutine(boomCoroutine)
	end
end

function this.WhoShow(position)
	xi.localPosition=position
	this.init()
	boomCoroutine=StartCoroutine(this.boom)
end

local idleTime=0.2
local scaleTime=0.2
local boomTime=0.3
function this.boom()
	xi.gameObject:SetActive(true)
	zi.gameObject:SetActive(true)
	WaitForSeconds(idleTime)
	this.scaleTo(zi,Vector3(1,1,1)*0.7,Vector3(1,1.2,1)*0.7,scaleTime)
	WaitForSeconds(scaleTime)
	this.scaleTo(zi,Vector3(1,1.2,1)*0.7,Vector3(1,1,1)*0.7,scaleTime)
	WaitForSeconds(scaleTime)
	guang.gameObject:SetActive(true)
	huo.gameObject:SetActive(true)
	this.alphaTo(zi,1,0.8,boomTime)
	WaitForSeconds(boomTime)
	guang.gameObject:SetActive(false)
	zi.gameObject:SetActive(false)
	local sprite=huo:GetComponent('UISprite')
	for i=1,10 do
		sprite.spriteName='火'..i
		WaitForSeconds(1/10)
		if i==10 then
			xi.gameObject:SetActive(false)
			zi:GetComponent('UISprite').color=Color(1,1,1,1)
			huo.gameObject:SetActive(false)
			WaitForSeconds(0.5)
			gameObject:SetActive(false)
			break
		end
	end
end

function this.alphaTo(transform,from,to,duration)
    gameObject:SetActive(true)
    --TweenAlpha.Begin(transform.gameObject, duration, to, false)
    local tweenScale=transform:GetComponent('TweenAlpha')
    tweenScale:ResetToBeginning()
    tweenScale.from = from
    tweenScale.to = to
    tweenScale.duration = duration
    tweenScale:PlayForward()
    return duration
end

function this.scaleTo(transform,from,to,duration)
    gameObject:SetActive(true)
    --TweenScale.Begin(transform.gameObject, duration, to, false)
    local tweenScale=transform:GetComponent('TweenScale')
    tweenScale:ResetToBeginning()
    tweenScale.from = from
    tweenScale.to = to
    tweenScale.duration = duration
    tweenScale:PlayForward()
    return duration
end