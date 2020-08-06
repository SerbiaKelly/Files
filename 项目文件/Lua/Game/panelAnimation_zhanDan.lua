panelAnimation_zhanDan = {}
local this = panelAnimation_zhanDan;

local message
local gameObject

local zd
local zhanDan
local xian
local huo
local boom

function this.Awake(obj)
	gameObject = obj;
	message = gameObject:GetComponent('LuaBehaviour');
	
	zd = gameObject.transform:Find('zd')
	zhanDan = zd:Find('1')
	xian = zd:Find('2')
	huo = zd:Find('3')
	boom = zd:Find('boom')
end

function this.Start()
end
function this.Update()
end

function this.OnEnable()
	
end

local huoCoroutine
local boomCoroutine
function this.init()
	if huoCoroutine then
		StopCoroutine(huoCoroutine)
	end
	if boomCoroutine then
		StopCoroutine(boomCoroutine)
	end
end

function this.WhoShow(position)
	zd.localPosition=position
	this.init()
	huoCoroutine=StartCoroutine(this.huo)
end

local huoSpead=0.1
function this.huo()
	zhanDan.gameObject:SetActive(true)
	xian.gameObject:SetActive(true)
	huo.gameObject:SetActive(true)
	boom.gameObject:SetActive(false)
	local sprite=xian:GetComponent('UISprite')
	sprite.fillAmount=0.9
	huo.localPosition=Vector3(47,60,0)
	WaitForSeconds(huoSpead)
	
	sprite.fillAmount=0.8
	huo.localPosition=Vector3(40,59,0)
	WaitForSeconds(huoSpead)
	
	sprite.fillAmount=0.65
	huo.localPosition=Vector3(30,58,0)
	WaitForSeconds(huoSpead)
	
	sprite.fillAmount=0.40
	huo.localPosition=Vector3(16,74,0)
	WaitForSeconds(huoSpead)
	
	sprite.fillAmount=0
	huo.localPosition=Vector3(-6,84,0)
	WaitForSeconds(huoSpead)

	boomCoroutine=StartCoroutine(this.boom)
end

function this.boom()
	zhanDan.gameObject:SetActive(false)
	xian.gameObject:SetActive(false)
	huo.gameObject:SetActive(false)
	boom.gameObject:SetActive(true)
	local sprite=boom:GetComponent('UISprite')
	for i=1,12 do
		sprite.spriteName='火-'..i
		WaitForSeconds(1/12)
		if i==12 then
			boom.gameObject:SetActive(false)
			WaitForSeconds(0.5)
			gameObject:SetActive(false)
			break
		end
	end
end