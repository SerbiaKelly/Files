
panelSettingGPS = {}
local this = panelSettingGPS

local message
local gameObject

local ButtonPermissions
local ButtonGPS
local ButtonGPSLoad
local ButtonOK
local mask


function this.Awake(obj)
	gameObject = obj
	ButtonPermissions = gameObject.transform:Find('Buttonlocaltion/Permissions')
	ButtonGPS = gameObject.transform:Find('Buttonlocaltion/GPS')
	ButtonGPSLoad = gameObject.transform:Find('Label')
	ButtonOK = gameObject.transform:Find('BaseContent/ButtonClose')
    mask = gameObject.transform:Find('BaseContent/mask')

	message = gameObject:GetComponent('LuaBehaviour')
	message:AddClick(ButtonPermissions.gameObject, this.OnClickPermissions)
	message:AddClick(ButtonGPS.gameObject, this.OnClickGPS)
	message:AddClick(ButtonOK.gameObject, this.OnClickMask)
	if IsAppleReview() then
        ButtonPermissions.parent.gameObject:SetActive(false)
	end
end

function this.Update()
end

function this.Start()
end

function this.checkLocationButtonStatus()
	if PlatformManager.Instance:HasLocationPermissions() then
		ButtonPermissions:GetComponent('UIButton').isEnabled=false
		local label=ButtonPermissions:Find('Label'):GetComponent('UILabel')
		label.text='已授权定位'
		label.effectColor=Color(96/255,96/255,96/255)
	else
		ButtonPermissions:GetComponent('UIButton').isEnabled=true
		local label=ButtonPermissions:Find('Label'):GetComponent('UILabel')
		label.text='未授权定位'
		label.effectColor=Color(3/255,145/255,162/255)
	end
	if PlatformManager.Instance:GPSisOpen() then
		ButtonGPS:GetComponent('UIButton').isEnabled=false
		local label=ButtonGPS:Find('Label'):GetComponent('UILabel')
		label.text='已开启定位'
		label.effectColor=Color(96/255,96/255,96/255)
	else
		ButtonGPS:GetComponent('UIButton').isEnabled=true
		local label=ButtonGPS:Find('Label'):GetComponent('UILabel')
		label.text='未开启定位'
		label.effectColor=Color(3/255,145/255,162/255)
	end
end

function this.WhoShow(name)
end

function this.OnEnable()
	ButtonPermissions.parent.gameObject:SetActive(true)
	this.checkLocationButtonStatus()
	if cor ~= nil then
		coroutine.stop(cor)
	end
	cor = coroutine.start(this.showAnimaion)
end

function this.OnClickPermissions(go)
	AudioManager.Instance:PlayAudio('btn')
	if PlatformManager.Instance:showLocationPermissionRequestUI() then
		PlatformManager.Instance:ApplyLocationPermissions()
	else
		PlatformManager.Instance:openAppSettingUI()
	end
end

function this.OnClickGPS(go)
	AudioManager.Instance:PlayAudio('btn')
	PlatformManager.Instance:OpenGPS()
end

local cor
function this.OnApplicationFocus(focus)
	if focus==true then
		this.checkLocationButtonStatus()
		if(PlatformManager.Instance:HasLocationPermissions() and PlatformManager.Instance:GPSisOpen()) then
			PlatformManager.Instance:StartLocation()
		end
		if cor ~= nil then
			coroutine.stop(cor)
		end
		cor = coroutine.start(this.showAnimaion)
	end
end

function this.OnClickMask(go)
	AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.showAnimaion()
	local longitude = UnityEngine.PlayerPrefs.GetFloat("longitude",0)
	local latitude = UnityEngine.PlayerPrefs.GetFloat("latitude",0)
	local num = 20
	while num > 0 do
		if longitude == 0 and latitude == 0 then
			if PlatformManager.Instance:HasLocationPermissions() 
			and PlatformManager.Instance:GPSisOpen() then
				ButtonGPSLoad.gameObject:SetActive(true)
			end
		else
			ButtonGPSLoad.gameObject:SetActive(false)
			num = 0
		end
		coroutine.wait(1)
		longitude = UnityEngine.PlayerPrefs.GetFloat("longitude",0)
		latitude = UnityEngine.PlayerPrefs.GetFloat("latitude",0)
		num = num - 1
	end

	ButtonGPSLoad.gameObject:SetActive(false)
	if longitude == 0 and latitude == 0 then
		print('定位失败')
	end
	cor = nil
end