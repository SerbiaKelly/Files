panelAnimation_tongzi = {}
local this = panelAnimation_tongzi;

local message
local gameObject

local animationEnd=true

local paoTong
local zhaDan
local Boom
local yingZi
local zui
local baoZhaBoom
function this.Awake(obj)
	gameObject = obj;
	message = gameObject:GetComponent('LuaBehaviour');
	
	paoTong = gameObject.transform:Find('paoTong')
	zhaDan = gameObject.transform:Find('zhadan')
	Boom = gameObject.transform:Find('boom')
	yingZi = paoTong:Find('yingzi')
	zui = paoTong:Find('zui')
	baoZhaBoom = Boom:Find('baozha')
end

function this.Start()
end
function this.Update()
end

function this.OnEnable()
	
end
local goOutCoroutine
local shotCoroutine
local boomCoroutine
function this.init()
	if goOutCoroutine then
		StopCoroutine(goOutCoroutine)
	end
	if shotCoroutine then
		zhaDan.gameObject:SetActive(false)
		StopCoroutine(shotCoroutine)
	end
	if boomCoroutine then
		Boom.gameObject:SetActive(false)
		StopCoroutine(boomCoroutine)
	end
end
function this.WhoShow()
	this.init()
    if animationEnd==true then
		goOutCoroutine=StartCoroutine(this.goOut)
	else
		shotCoroutine=StartCoroutine(this.shot)	
	end
	animationEnd=false
end

local goOutTime=0.3
local idleTime=0.2
function this.goOut()
	yingZi.gameObject:SetActive(true)
	this.positionTo(paoTong,Vector3(-953,88,0),Vector3(-400,88,0),goOutTime)
	WaitForSeconds(goOutTime)
	yingZi.gameObject:SetActive(false)
	WaitForSeconds(idleTime)
	shotCoroutine=StartCoroutine(this.shot)
end

local upTime=0.2
local feiTime=0.2
local downTime=0.2
function this.shot()
	zui:GetComponent('UISprite').spriteName='炮嘴张'
	this.scaleTo(zui,Vector3(1,1,1),Vector3(0.9,1,1),0.02)
	WaitForEndOfFrame()
	this.scaleTo(paoTong,Vector3(1,1,1),Vector3(0.9,1,1),0.02)
	this.scaleTo(zui,zui.localScale,Vector3(0.85,1,1),0.02)
	WaitForEndOfFrame()
	this.scaleTo(zui,zui.localScale,Vector3(0.8,1,1),0.02)
	WaitForEndOfFrame()
	this.scaleTo(paoTong,paoTong.localScale,Vector3(1,1,1),0.02)
	this.scaleTo(zui,zui.localScale,Vector3(0.85,1,1),0.02)
	WaitForEndOfFrame()
	this.scaleTo(zui,zui.localScale,Vector3(0.9,1,1),0.02)
	WaitForEndOfFrame()
	this.scaleTo(zui,zui.localScale,Vector3(1,1,1),0.02)
	WaitForEndOfFrame()
	zhaDan.gameObject:SetActive(true)
	this.positionTo(zhaDan,Vector3(-86,175,0),Vector3(31,245,0),upTime)
	WaitForSeconds(upTime)
	this.positionTo(zhaDan,Vector3(31,245,0),Vector3(202,189,0),feiTime)
	WaitForSeconds(feiTime)
	this.positionTo(zhaDan,Vector3(202,189,0),Vector3(301,66,0),downTime)
	WaitForSeconds(downTime)
	zhaDan.gameObject:SetActive(false)
	boomCoroutine=StartCoroutine(this.boom)
end

function this.boom()
	Boom.gameObject:SetActive(true)
	local sprite=baoZhaBoom:GetComponent('UISprite')
	
	for i=1,11 do
		sprite.spriteName='喷火-'..i
		WaitForSeconds(1/11)
		if i==11 then
			Boom.gameObject:SetActive(false)
			WaitForSeconds(1)
			gameObject:SetActive(false)
			animationEnd=true
			break
		end
	end
end

function this.positionTo(transform,from,to,duration)
    gameObject:SetActive(true)
    --TweenPosition.Begin(transform.gameObject, duration, to, false)
    local tweenPosition=transform:GetComponent('TweenPosition')
    tweenPosition:ResetToBeginning()
    tweenPosition.worldSpace = false
    tweenPosition.from = from
    tweenPosition.to = to
    tweenPosition.duration = duration
    tweenPosition:PlayForward()
    return duration
end

function this.rotationTo(transform,from,to,duration)
    gameObject:SetActive(true)
    --TweenRotation.Begin(transform.gameObject, duration, to, false)
    local tweenRotation=transform:GetComponent('TweenRotation')
    tweenRotation:ResetToBeginning()
    tweenRotation.from = from
    tweenRotation.to = to
    tweenRotation.duration = duration
    tweenRotation:PlayForward()
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