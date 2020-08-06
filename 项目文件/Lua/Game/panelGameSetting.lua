panelGameSetting = {}
local this = panelGameSetting

local message;
local gameObject

local slider_audio
local slider_music
local audioProces
local musicProces

local paiMianOn
local paiMianOff
local ground1
local ground0
local ground2
local PlayerSoundOn
local PlayerSoundOff
local PaiSizeSuper
local PaiSizeNormal
local AnimSlow
local AnimFast
local AnimThunder

local ButtonLogout
local ButtonCloseRoom
local ButtonOK
local ButtonClose
local mask

local playerSound = 0
local localtionService = 1
local paiMian = 1
local ground = 0
local paiSize = 0
local animaSpeed = 0
local QuikChiToggle;

local C_DismissWaitingTime = 5
local WaiteCloseRoom
local WaiteCloseRoomCoroutine
local PlayerUIObjs = {}
local position = {
	transform=nil,
	distance={},
	playerGPS={},
}
local WanFaLab = nil
local RuleLab = nil
local isGameing=false

function this.Awake(obj)
	gameObject = obj

	slider_audio = gameObject.transform:Find('soundSetting/slider_audio'):GetComponent('UISlider')
	slider_music = gameObject.transform:Find('soundSetting/slider_music'):GetComponent('UISlider')
	audioProces = gameObject.transform:Find('soundSetting/slider_audio/Label')
	musicProces = gameObject.transform:Find('soundSetting/slider_music/Label')
	PlayerSoundOn = gameObject.transform:Find('soundSetting/PlayerSound/on')
	PlayerSoundOff = gameObject.transform:Find('soundSetting/PlayerSound/off')

	paiMianOn = gameObject.transform:Find('viewSetting/paiMian/on')
	paiMianOff = gameObject.transform:Find('viewSetting/paiMian/off')
	QuikChiToggle = gameObject.transform:Find('viewSetting/paiMian/QuikChilPai')
	ground1 = gameObject.transform:Find('viewSetting/ground/1')
	ground0 = gameObject.transform:Find('viewSetting/ground/0')
	ground2 = gameObject.transform:Find('viewSetting/ground/2')

	PaiSizeNormal = gameObject.transform:Find('viewSetting/size/normalPai')
	PaiSizeSuper = gameObject.transform:Find('viewSetting/size/superPai')
	
	AnimSlow = gameObject.transform:Find('viewSetting/speed/slow')
	AnimFast = gameObject.transform:Find('viewSetting/speed/fast')
	AnimThunder = gameObject.transform:Find('viewSetting/speed/thunder')

    ButtonCloseRoom = gameObject.transform:Find('ButtonCloseRoom')
	
	ButtonClose = gameObject.transform:Find('ButtonSure')
	ButtonOK = gameObject.transform:Find('ButtonOK')
    mask = gameObject.transform:Find('mask')
	
	WaiteCloseRoom = gameObject.transform:Find('WaiteCloseRoom')

	WanFaLab        = gameObject.transform:Find('ruleSettting/WanFa/Label'):GetComponent('UILabel') 
    RuleLab         = gameObject.transform:Find('ruleSettting/Rule/Label'):GetComponent('UILabel')
    EventDelegate.AddForLua(slider_audio.onChange, this.OnAudioSliderValueChange)
    EventDelegate.AddForLua(slider_music.onChange, this.OnMusicSliderValueChange)
	message = gameObject:GetComponent('LuaBehaviour');
	message:AddClick(PlayerSoundOn.gameObject, this.OnClickPlayerSoundOn)
	message:AddClick(PlayerSoundOff.gameObject, this.OnClickPlayerSoundOff)
	message:AddClick(paiMianOn.gameObject, this.OnClickPaiMianOn)
	message:AddClick(paiMianOff.gameObject, this.OnClickPaiMianOff)
	message:AddClick(ground1.gameObject, this.OnClickGround1)
	message:AddClick(ground0.gameObject, this.OnClickGround0)
	message:AddClick(ground2.gameObject, this.OnClickGround2)
	message:AddClick(ButtonCloseRoom.gameObject, this.OnClicButtonCloseRoom)
	
	message:AddClick(PaiSizeNormal.gameObject, this.OnPaiSizeChange)
	message:AddClick(PaiSizeSuper.gameObject, this.OnPaiSizeChange)

	message:AddClick(AnimSlow.gameObject, this.OnAnimSpeedChange)
	message:AddClick(AnimFast.gameObject, this.OnAnimSpeedChange)
	message:AddClick(AnimThunder.gameObject, this.OnAnimSpeedChange)

    message:AddClick(ButtonOK.gameObject, this.OnClickMask)
    message:AddClick(ButtonClose.gameObject, this.OnClickMask)
	message:AddClick(QuikChiToggle.gameObject, this.OnQuikChiPaiClick)
	this.GetDistanceUI()
end
function this.GetDistanceUI()
    position.transform = gameObject.transform:Find('position')
	local dis = position.transform:Find('distances')
	for i = 0, dis.childCount-1 do
		local len = {}
		len.transform = dis.transform:Find('distance'..i)
		len.length = dis.transform:Find('distance'..i..'/Label')
		position.distance[i] = len
	end
	local players = position.transform:Find('players')
	for i = 0, players.childCount-1 do
		local index = i
        if roomData.setting.size == 4 then
            if i == 1 then
                index = 3
            elseif i == 2 then
                index = 1
            elseif i == 3 then
                index = 2
            end
        end
		local pla = {}
		pla.transform = players:Find(index)
		pla.dingwei = pla.transform:Find('dingwei')
		pla.name = pla.transform:Find('name')
		position.playerGPS[i] = pla
	end
end
function this.Update()
end
function this.Start()
end
function this.OnEnable()
    slider_audio.value = UnityEngine.PlayerPrefs.GetFloat('audio_value', 1)
	slider_music.value = UnityEngine.PlayerPrefs.GetFloat('music_value', 1)
	
	paiMian = UnityEngine.PlayerPrefs.GetInt('paiMian', 1)
	ground = UnityEngine.PlayerPrefs.GetInt('ground', 1)
	playerSound = UnityEngine.PlayerPrefs.GetInt('playerSound', 0)

	localtionService = UnityEngine.PlayerPrefs.GetInt('localtionService', 1)
	-- landScape = UnityEngine.PlayerPrefs.GetInt('landScape', 1)
	paiSize = UnityEngine.PlayerPrefs.GetInt("paiSize", 1)
	if roomData.setting.roomTypeValue == proxy_pb.SYZP 
	or roomData.setting.roomTypeValue == proxy_pb.SYBP then
		animaSpeed = UnityEngine.PlayerPrefs.GetInt('animaSpeed', 2)
	else
		animaSpeed = UnityEngine.PlayerPrefs.GetInt('animaSpeed', 1)
	end	
	
	paiMianOn:GetComponent('UIToggle'):Set(paiMian == 1)
	paiMianOff:GetComponent('UIToggle'):Set(paiMian ~= 1)

	ground1:GetComponent('UIToggle'):Set(ground == 1)
	ground0:GetComponent('UIToggle'):Set(ground == 0)
	ground2:GetComponent('UIToggle'):Set(ground == 2)

	PlayerSoundOn:GetComponent('UIToggle'):Set(playerSound == 1)
	PlayerSoundOff:GetComponent('UIToggle'):Set(playerSound ~= 1)
	
	print("paiSize："..paiSize)
	PaiSizeNormal:GetComponent('UIToggle'):Set(paiSize == 0)
	PaiSizeSuper:GetComponent('UIToggle'):Set(paiSize == 1)

	print("animaSpeed"..animaSpeed)
	AnimSlow:GetComponent('UIToggle'):Set(animaSpeed == 0)
	AnimFast:GetComponent('UIToggle'):Set(animaSpeed == 1)
	AnimThunder:GetComponent('UIToggle'):Set(animaSpeed == 2)
	QuikChiToggle:GetComponent("UIToggle"):Set(UnityEngine.PlayerPrefs.GetInt("phz_quickchi",0)==1)

	paiMianOn.parent.gameObject:SetActive(true)
	PaiSizeNormal.parent.gameObject:SetActive(true)
	AnimSlow.parent.gameObject:SetActive(true)
	ground2.gameObject:SetActive(true)

	print(tostring(roomData.dissolveLimit))
	print(tostring(panelInGame.myseflDissolveTimes))
	if roomData.dissolveLimit == proxy_pb.UNLIMITED then
	elseif roomData.dissolveLimit == proxy_pb.FIVE_SECONDS and isGameing and panelInGame.myseflDissolveTimes > 0 then
		this.ShowWaitClose()
	end
end

function this.WhoShow(name)
	isGameing=name
	this.SetRuleInfo()
	local datas = {}
	for i = 0, roomData.setting.size - 1 do
		datas[i] = panelInGame.GetPlayerDataByUIIndex(i)
	end
	local pos = {}
	if roomData.setting.size == 2 then
		pos = pos2
	elseif roomData.setting.size == 3 then
		pos = pos3
	elseif roomData.setting.size == 4 then
		pos = pos4	
	end
	SetGPSInfo(position,pos,datas,roomData.setting.size)
end
function this.OnApplicationFocus()
end

function this.SetRuleInfo()
	print("SetRuleInfo was called");
	WanFaLab.text 	= roomData.playName
	RuleLab.text 	= getWanFaText(roomData.setting, false, false, false)
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
function this.OnClicButtonCloseRoom(go)
	if isGameing then
		 --不能解散
		 if roomData.state == 2 and roomData.dissolveType == 3 then
			panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '该牌友群已设置不可自主解散房间，若有疑问请联系群主');
			PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
			return
		end
		AudioManager.Instance:PlayAudio('btn')
		print("解散房间phz")
		local msg = Message.New()
		msg.type = phz_pb.DISSOLVE
		local body = phz_pb.PDissolve()
		body.decision = phz_pb.APPLY
		msg.body = body:SerializeToString()
		SendGameMessage(msg, nil)
		--增加一次申请解散次数
		panelInGame.myseflDissolveTimes = panelInGame.myseflDissolveTimes + 1
	else
		this.OnClicButtonLeaveRoom()
	end
	PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClicButtonLeaveRoom(go)
	AudioManager.Instance:PlayAudio('btn')
	local msg = Message.New()
	msg.type = phz_pb.LEAVE_ROOM
	SendGameMessage(msg, nil)
	panelInGame.fanHuiRoomNumber = nil
	PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickPlayerSoundOn(go)
	AudioManager.Instance:PlayAudio('btn')
	playerSound = 1
	UnityEngine.PlayerPrefs.SetInt('playerSound', playerSound)
end
function this.OnClickPlayerSoundOff(go)
	AudioManager.Instance:PlayAudio('btn')
	playerSound = 0
	UnityEngine.PlayerPrefs.SetInt('playerSound', playerSound)
end
function this.OnClickPaiMianOn(go)
	AudioManager.Instance:PlayAudio('btn')
	paiMian = 1
	if panelInGame~=nil then
		panelInGame.changePaiMian(paiMian)
	end
	UnityEngine.PlayerPrefs.SetInt('paiMian', paiMian)
end
function this.OnClickPaiMianOff(go)
	AudioManager.Instance:PlayAudio('btn')
	paiMian = 0
	if panelInGame~=nil then
		panelInGame.changePaiMian(paiMian)
	end
	UnityEngine.PlayerPrefs.SetInt('paiMian', paiMian)
end

function this.OnClickGround1(go)
	AudioManager.Instance:PlayAudio('btn')
	ground = 1
	if panelInGame~=nil then
		panelInGame.changeBG(ground)
	end
	UnityEngine.PlayerPrefs.SetInt('ground', ground)
end

function this.OnClickGround0(go)
	AudioManager.Instance:PlayAudio('btn')
	ground = 0
	if panelInGame~=nil then
		panelInGame.changeBG(ground)
	end
	UnityEngine.PlayerPrefs.SetInt('ground', ground)
end

function this.OnClickGround2(go)
	AudioManager.Instance:PlayAudio('btn')
	ground = 2
	if panelInGame~=nil then
		panelInGame.changeBG(ground)
	end
	UnityEngine.PlayerPrefs.SetInt('ground', ground)
end

function this.OnClickMask(go)
	AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnPaiSizeChange(go)
	if go == PaiSizeSuper.gameObject then
		paiSize = 1
	else
		paiSize = 0
	end
	panelInGame.changePaiSize(paiSize)
	UnityEngine.PlayerPrefs.SetInt('paiSize', paiSize)
end

function this.OnQuikChiPaiClick(go)
	print("state:"..tostring(go:GetComponent("UIToggle").value));
	--go:GetComponent("UIToggle"):Set(not go:GetComponent("UIToggle").value);
	UnityEngine.PlayerPrefs.SetInt('phz_quickchi', go:GetComponent("UIToggle").value and 1 or 0);
end

function this.OnAnimSpeedChange(go)
	if go == AnimSlow.gameObject then
		animaSpeed = 0
	elseif go == AnimFast.gameObject then
		animaSpeed = 1
	else
		animaSpeed = 2
	end
	UnityEngine.PlayerPrefs.SetInt('animaSpeed', animaSpeed)
end

function this.ShowWaitClose()
	if WaiteCloseRoomCoroutine ~= nil then
		coroutine.stop(WaiteCloseRoomCoroutine)
		WaiteCloseRoomCoroutine = nil
	end
	WaiteCloseRoomCoroutine = coroutine.start(function ()
		WaiteCloseRoom.gameObject:SetActive(true)
		WaiteCloseRoom.transform:Find('Label'):GetComponent('UILabel').text = C_DismissWaitingTime..'秒';
		for i=1, C_DismissWaitingTime do
			coroutine.wait(1);
			WaiteCloseRoom.transform:Find('Label'):GetComponent('UILabel').text = C_DismissWaitingTime - i..'秒';
		end
		WaiteCloseRoom.gameObject:SetActive(false)
	end)
end

