
panelSetting = {}
local this = panelSetting;

local message;
local gameObject;
local slider_audio
local slider_music
local audioProces
local musicProces
local ButtonAudio
local ButtonMusic
local ButtonAutoRotation

local ButtonPermissions
local ButtonGPS
local PlayerSoundOn
local PlayerSoundOff

local ButtonLogout
local ButtonCloseRoom
local ButtonLeaveRoom
local ButtonOK
local mask

local audio_on = 1
local music_on = 1

local playerSound = 1 --1 普通  2 方言 
local localtionService = 1
local landScape = 1
local status, err = false, ""

function this.Awake(obj)
	gameObject = obj;

	slider_audio = gameObject.transform:Find('slider_audio'):GetComponent('UISlider');
	slider_music = gameObject.transform:Find('slider_music'):GetComponent('UISlider');
	
	audioProces = gameObject.transform:Find('slider_audio/Label')
	musicProces = gameObject.transform:Find('slider_music/Label')
    ButtonAudio = gameObject.transform:Find('ButtonAudio');
    ButtonMusic = gameObject.transform:Find('ButtonMusic');
	PlayerSoundOn = gameObject.transform:Find('PlayerSound/on');
	PlayerSoundOff = gameObject.transform:Find('PlayerSound/off');
	ButtonPermissions = gameObject.transform:Find('Buttonlocaltion/Permissions')
	ButtonGPS = gameObject.transform:Find('Buttonlocaltion/GPS')
	ButtonAutoRotation = gameObject.transform:Find('ButtonAutoRotation');
    ButtonLogout = gameObject.transform:Find('ButtonLogout');
    ButtonCloseRoom = gameObject.transform:Find('ButtonCloseRoom');
	ButtonLeaveRoom = gameObject.transform:Find('ButtonLeaveRoom');
	ButtonOK = gameObject.transform:Find('BaseContent/ButtonClose');
    mask = gameObject.transform:Find('BaseContent/mask');

    EventDelegate.AddForLua(slider_audio.onChange, this.OnAudioSliderValueChange)
    EventDelegate.AddForLua(slider_music.onChange, this.OnMusicSliderValueChange)

	message = gameObject:GetComponent('LuaBehaviour');
    message:AddClick(ButtonAudio.gameObject, this.OnClickButtonAudio);
    message:AddClick(ButtonMusic.gameObject, this.OnClickButtonMusic);
	message:AddClick(PlayerSoundOn.gameObject, this.OnClickPlayerSoundOn);
	message:AddClick(PlayerSoundOff.gameObject, this.OnClickPlayerSoundOff);
	message:AddClick(ButtonPermissions.gameObject, this.OnClickPermissions);
	message:AddClick(ButtonGPS.gameObject, this.OnClickGPS);
	message:AddClick(ButtonAutoRotation.gameObject, this.OnClickButtonAutoRotation);
    message:AddClick(ButtonLogout.gameObject, this.OnClickButtonLogout);
    message:AddClick(ButtonCloseRoom.gameObject, this.OnClicButtonCloseRoom);
	message:AddClick(ButtonLeaveRoom.gameObject, this.OnClicButtonLeaveRoom);

	message:AddClick(ButtonOK.gameObject, this.OnClickMask);
	if IsAppleReview() then
        ButtonPermissions.parent.gameObject:SetActive(false)
	end
	
	status, err = pcall(function() PlatformManager.Instance:HasLocationPermissions() end)
end

function this.Update()
   
end
function this.Start()
    slider_audio.value = UnityEngine.PlayerPrefs.GetFloat('audio_value', 1)
    slider_music.value = UnityEngine.PlayerPrefs.GetFloat('music_value', 1)
    audio_on = UnityEngine.PlayerPrefs.GetInt('audio_on', 1)
    music_on = UnityEngine.PlayerPrefs.GetInt('music_on', 1)
	playerSound = UnityEngine.PlayerPrefs.GetInt('playerSound', 1)
	localtionService = UnityEngine.PlayerPrefs.GetInt('localtionService', 1)
	-- landScape = UnityEngine.PlayerPrefs.GetInt('landScape', 1)
	
	-- if audio_on == 1 then
	-- 	ButtonAudio:Find('on').gameObject:SetActive(true)
	-- 	ButtonAudio:Find('off').gameObject:SetActive(false)
	-- else
	-- 	ButtonAudio:Find('on').gameObject:SetActive(false)
	-- 	ButtonAudio:Find('off').gameObject:SetActive(true)
	-- end
	
	-- if music_on == 1 then
	-- 	ButtonMusic:Find('on').gameObject:SetActive(true)
	-- 	ButtonMusic:Find('off').gameObject:SetActive(false)
	-- else
	-- 	ButtonMusic:Find('on').gameObject:SetActive(false)
	-- 	ButtonMusic:Find('off').gameObject:SetActive(true)
	-- end
	
	PlayerSoundOn:GetComponent('UIToggle'):Set(playerSound == 1)
	PlayerSoundOff:GetComponent('UIToggle'):Set(playerSound ~= 1)
	
	-- if landScape == 0 then
	-- 	ButtonAutoRotation:Find('on').gameObject:SetActive(false)
	-- 	ButtonAutoRotation:Find('off').gameObject:SetActive(true)
	-- else
	-- 	ButtonAutoRotation:Find('on').gameObject:SetActive(true)
	-- 	ButtonAutoRotation:Find('off').gameObject:SetActive(false)
	-- end
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
	print(name..'打开'..gameObject.name)
	
	-- if name=='panelLobby' then
	-- 	ButtonLogout.gameObject:SetActive(true)
	-- 	ButtonCloseRoom.gameObject:SetActive(false)
	-- 	ButtonLeaveRoom.gameObject:SetActive(false)
	-- 	slider_audio.gameObject.transform.localPosition=Vector3(5,-30,0)
	-- 	slider_music.gameObject.transform.localPosition=Vector3(5,-90,0)
	-- elseif name=='panelInGameLand' then
	-- 		-- body
		
	-- end
end

function this.OnEnable()
	if CONST.IPcheckOn and status then
		ButtonPermissions.parent.gameObject:SetActive(true)
		this.checkLocationButtonStatus()
	end
	
	
	-- local which = UnityEngine.PlayerPrefs.GetInt('showWhichButton', 0)
	-- print('which:'..which)
	-- if which == 0 then
	-- 	ButtonLogout.gameObject:SetActive(true)
	-- 	ButtonCloseRoom.gameObject:SetActive(false)
	-- 	ButtonLeaveRoom.gameObject:SetActive(false)
	-- elseif which == 1 then
	-- 	ButtonLogout.gameObject:SetActive(false)
	-- 	ButtonCloseRoom.gameObject:SetActive(true)
	-- 	ButtonLeaveRoom.gameObject:SetActive(false)
	-- else
	-- 	ButtonLogout.gameObject:SetActive(false)
	-- 	ButtonCloseRoom.gameObject:SetActive(false)
	-- 	ButtonLeaveRoom.gameObject:SetActive(true)
	-- end
	
	-- ButtonAutoRotation.gameObject:SetActive(not isIngame)
end

function this.OnAudioSliderValueChange()
    UnityEngine.PlayerPrefs.SetFloat('audio_value', UIProgressBar.current.value)
	AudioManager.Instance:SetAudioVolume(UIProgressBar.current.value)
	audioProces:GetComponent('UILabel').text = math.ceil(UIProgressBar.current.value*100)..'%'
end

function this.OnMusicSliderValueChange()
    UnityEngine.PlayerPrefs.SetFloat('music_value', UIProgressBar.current.value)
    AudioManager.Instance:SetMusicVolume(UIProgressBar.current.value)
	musicProces:GetComponent('UILabel').text = math.ceil(UIProgressBar.current.value*100)..'%'
end

function this.OnClickButtonMusic(go)
	AudioManager.Instance:PlayAudio('btn')
    if music_on == 1 then
        music_on = 0
    else
        music_on = 1
    end
    UnityEngine.PlayerPrefs.SetInt('music_on', music_on)
    AudioManager.Instance.MusicOn =music_on == 1
	
	-- if music_on ==1 then
	-- 	ButtonMusic:Find('on').gameObject:SetActive(true)
	-- 	ButtonMusic:Find('off').gameObject:SetActive(false)
	-- else
	-- 	ButtonMusic:Find('on').gameObject:SetActive(false)
	-- 	ButtonMusic:Find('off').gameObject:SetActive(true)
	-- end
end

function this.OnClicButtonCloseRoom(go)
	AudioManager.Instance:PlayAudio('btn')
	local msg = Message.New()
    msg.type = phz_pb.DISSOLVE
	local body = phz_pb.PDissolve()
	body.decision = phz_pb.APPLY
	msg.body = body:SerializeToString()
	SendGameMessage(msg, nil);
	
	PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickButtonLogout(go)
	AudioManager.Instance:PlayAudio('btn')
	print('OnClickButtonLogout')

	if panelInGame and panelInGame.fanHuiRoomNumber then
		panelMessageBox.SetParamers(ONLY_OK, function ()
			if roomInfo.gameType == proxy_pb.PDK then
				PanelManager.Instance:ShowWindow('panelInGame_pdk',gameObject.name)
			elseif roomInfo.gameType == proxy_pb.PHZ then
				PanelManager.Instance:ShowWindow('panelInGameLand',gameObject.name)
			elseif roomInfo.gameType == proxy_pb.MJ then
				PanelManager.Instance:ShowWindow('panelInGamemj',gameObject.name)
			elseif roomInfo.gameType == proxy_pb.XHZD then
				PanelManager.Instance:ShowWindow('panelInGame_xhzd',gameObject.name)
			elseif roomInfo.gameType == proxy_pb.DTZ then
				PanelManager.Instance:ShowWindow('panelInGame_dtz',gameObject.name)
			elseif roomInfo.gameType == proxy_pb.YJQF then
				PanelManager.Instance:ShowWindow('panelInGame_yjqf',gameObject.name)
			end
		end, nil, '您已加入房间无法退出，请进入房间解散后在操作', '返回房间')
		PanelManager.Instance:ShowWindow('panelMessageBox')
		return 
	end

    local msg = Message.New()
    msg.type = proxy_pb.LOGOUT;
	SendProxyMessage(msg, nil);

	-- by jih >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	UnityEngine.PlayerPrefs.DeleteKey(PLAYER_SESSION_ID)
	UnityEngine.PlayerPrefs.Save()
	-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	
	PanelManager.Instance:HideAllWindow()
	PanelManager.Instance:ShowWindow('panelLogin')
end

function this.OnClicButtonLeaveRoom(go)
	AudioManager.Instance:PlayAudio('btn')
    local msg = Message.New()
    msg.type = phz_pb.LEAVE_ROOM
	SendGameMessage(msg, nil)
	PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickButtonAudio(go)
	AudioManager.Instance:PlayAudio('btn')
    if audio_on == 1 then
        audio_on = 0
    else
        audio_on = 1
    end
    UnityEngine.PlayerPrefs.SetInt('audio_on', audio_on)
    AudioManager.Instance.AudioOn = audio_on == 1
	
	print('audio_on:'..audio_on)
	if audio_on == 1 then
		ButtonAudio:Find('on').gameObject:SetActive(true)
		ButtonAudio:Find('off').gameObject:SetActive(false)
	else
		ButtonAudio:Find('on').gameObject:SetActive(false)
		ButtonAudio:Find('off').gameObject:SetActive(true)
	end
end

function this.OnClickPlayerSoundOn(go)
	AudioManager.Instance:PlayAudio('btn')
	playerSound = 1
	UnityEngine.PlayerPrefs.SetInt('playerSound', playerSound)
	-- if panelInGame then
	-- 	panelInGame.OpenVoiceEvent()()
	-- end
end
function this.OnClickPlayerSoundOff(go)
	AudioManager.Instance:PlayAudio('btn')
    playerSound = 0
    UnityEngine.PlayerPrefs.SetInt('playerSound', playerSound)
	-- if panelInGame then
	-- 	panelInGame.CloseVoiceEvent()()
	-- end
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

function this.OnApplicationFocus(focus)
	if focus==true and CONST.IPcheckOn and status then
		this.checkLocationButtonStatus()
	end
end

function this.OnClickButtonAutoRotation(go)
	AudioManager.Instance:PlayAudio('btn')
	-- if landScape == 0 then
	-- 	landScape = 1
	-- else
	-- 	landScape = 0
	-- end
	-- UnityEngine.PlayerPrefs.SetInt('landScape', landScape)
	-- if landScape == 1 then
	-- 	ButtonAutoRotation:Find('on').gameObject:SetActive(true)
	-- 	ButtonAutoRotation:Find('off').gameObject:SetActive(false)
	-- else
	-- 	ButtonAutoRotation:Find('on').gameObject:SetActive(false)
	-- 	ButtonAutoRotation:Find('off').gameObject:SetActive(true)
	-- end
end 

function this.OnClickMask(go)
	AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
end