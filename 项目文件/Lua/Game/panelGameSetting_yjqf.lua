local yjqf_pb = require 'yjqf_pb'

panelGameSetting_yjqf = {}
local this = panelGameSetting_yjqf

local message
local gameObject

local dissolveRoomBtn
local dissolveWaitingTime = 5
local waiteCloseRoomBtn
local WaiteCloseRoomCoroutine
local set={}
local position = {
	transform=nil,
	distance={},
	playerGPS={},
}
local rule={}
local sound={}

function this.Awake(obj)
	gameObject      = obj
	message = gameObject:GetComponent('LuaBehaviour')

	dissolveRoomBtn = gameObject.transform:Find('dissolveRoomBtn')
	message:AddClick(dissolveRoomBtn.gameObject, this.OnClicButtonCloseRoom)

	message:AddClick(gameObject.transform:Find('closeBtn').gameObject, function (go)
		AudioManager.Instance:PlayAudio('btn')
    	PanelManager.Instance:HideWindow(gameObject.name)
	end)
	waiteCloseRoomBtn = gameObject.transform:Find('waiteCloseRoomBtn')

	set.cardSizeNormal = gameObject.transform:Find('set/cardColor/0')
	set.cardSizeSuper = gameObject.transform:Find('set/cardColor/1')
	message:AddClick(set.cardSizeNormal.gameObject, this.OnCardSizeChange)
	message:AddClick(set.cardSizeSuper.gameObject, this.OnCardSizeChange)
	set.group0 = gameObject.transform:Find('set/tableType/0')
	set.group1 = gameObject.transform:Find('set/tableType/1')
	set.group2 = gameObject.transform:Find('set/tableType/2')
	set.group3 = gameObject.transform:Find('set/tableType/3')
	message:AddClick(set.group0.gameObject, this.OnClickDesktop)
	message:AddClick(set.group1.gameObject, this.OnClickDesktop)
	message:AddClick(set.group2.gameObject, this.OnClickDesktop)
	message:AddClick(set.group3.gameObject, this.OnClickDesktop)

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
		local pla = {}
		pla.transform = players:Find(i)
		pla.dingwei = pla.transform:Find('dingwei')
		pla.name = pla.transform:Find('name')
		position.playerGPS[i] = pla
	end

	rule.wanFaLabel = gameObject.transform:Find('rule/WanFa/Label'):GetComponent('UILabel')
	rule.ruleLabel = gameObject.transform:Find('rule/Rule/Label'):GetComponent('UILabel')   

	sound.sliderAudio = gameObject.transform:Find('sound/slider_audio'):GetComponent('UISlider')
	sound.sliderMusic = gameObject.transform:Find('sound/slider_music'):GetComponent('UISlider')
	EventDelegate.AddForLua(sound.sliderAudio.onChange, this.OnAudioSliderValueChange)
    EventDelegate.AddForLua(sound.sliderMusic.onChange, this.OnMusicSliderValueChange)
	sound.audioProces = gameObject.transform:Find('sound/slider_audio/Label')
	sound.musicProces = gameObject.transform:Find('sound/slider_music/Label')
	sound.pthSound = gameObject.transform:Find('sound/playerSound/pth')
	sound.fySound = gameObject.transform:Find('sound/playerSound/fy')
	message:AddClick(sound.pthSound.gameObject, this.OnClickPlayerSound)
	message:AddClick(sound.fySound.gameObject, this.OnClickPlayerSound)
end
function this.Update()
end
function this.Start()
end
function this.OnEnable()
	set.cardSizeNormal:GetComponent('UIToggle'):Set(UnityEngine.PlayerPrefs.GetInt("yjqfpaiSize", 0) == 0)
	set.cardSizeSuper:GetComponent('UIToggle'):Set(UnityEngine.PlayerPrefs.GetInt("yjqfpaiSize", 0) == 1)
	local ground = UnityEngine.PlayerPrefs.GetInt("ground_yjqf", 1)
    set.group0:GetComponent('UIToggle'):Set(ground == 0)
	set.group1:GetComponent('UIToggle'):Set(ground == 1)
	set.group2:GetComponent('UIToggle'):Set(ground == 2)
	set.group3:GetComponent('UIToggle'):Set(ground == 3)
	sound.sliderAudio.value = UnityEngine.PlayerPrefs.GetFloat('audio_value', 1)
	sound.sliderMusic.value = UnityEngine.PlayerPrefs.GetFloat('music_value', 1)
	
	sound.pthSound:GetComponent('UIToggle'):Set(UnityEngine.PlayerPrefs.GetInt("sound_yjqf", 1) == 0)
	sound.fySound:GetComponent('UIToggle'):Set(UnityEngine.PlayerPrefs.GetInt("sound_yjqf", 1) == 1)

	if roomData.setting.dissolveLimit == proxy_pb.FIVE_SECONDS and panelInGame.isGameing and panelInGame.myseflDissolveTimes > 0 then
		this.ShowWaitClose()
	end
	this.SetShowRule()
	local datas = {}
	for i = 0, roomData.setting.size - 1 do
		datas[i] = panelInGame.GetPlayerDataByUIIndex(i)
	end
	local pos = {}
	if roomData.setting.size == 2 then
		pos = pos2
	elseif roomData.setting.size == 3 then
		pos = pos3
	end
	SetGPSInfo(position,pos,datas,roomData.setting.size)
end
function this.WhoShow()
end

function this.OnClicButtonCloseRoom(go)
	AudioManager.Instance:PlayAudio('btn')
	if panelInGame.isGameing or DestroyRoomData.mySeat == 0 then
		if roomData.dissolveType == 3 then
			panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '该牌友群已设置不可自主解散房间，若有疑问请联系群主');
			PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
			return
		end
		print("解散房间")
		local msg = Message.New()
		msg.type = yjqf_pb.DISSOLVE
		local b = yjqf_pb.PDissolve()
		b.decision = yjqf_pb.APPLY
		msg.body = b:SerializeToString()
		--增加一次申请解散次数
		panelInGame.myseflDissolveTimes = panelInGame.myseflDissolveTimes + 1
		SendGameMessage(msg, nil)
	else
		this.OnClicButtonLeaveRoom()
	end
	PanelManager.Instance:HideWindow(gameObject.name)
end
function this.OnClicButtonLeaveRoom(go)
	print("离开房间")
	AudioManager.Instance:PlayAudio('btn')
	local msg = Message.New()
	msg.type = yjqf_pb.LEAVE_ROOM
	panelInGame.fanHuiRoomNumber = nil
	SendGameMessage(msg, nil)
end
function this.ShowWaitClose()
	if WaiteCloseRoomCoroutine ~= nil then
		coroutine.stop(WaiteCloseRoomCoroutine)
		WaiteCloseRoomCoroutine = nil
	end
	WaiteCloseRoomCoroutine = coroutine.start(function ()
		WaiteCloseRoom.gameObject:SetActive(true)
		WaiteCloseRoom.transform:Find('Label'):GetComponent('UILabel').text = dissolveWaitingTime..'秒'
		for i=1, dissolveWaitingTime do
			coroutine.wait(1)
			WaiteCloseRoom.transform:Find('Label'):GetComponent('UILabel').text = dissolveWaitingTime - i..'秒'
		end
		WaiteCloseRoom.gameObject:SetActive(false)
	end)
end

function this.OnCardSizeChange(go)
	UnityEngine.PlayerPrefs.SetInt('yjqfpaiSize', tonumber(go.name))
	panelInGame.ChangePaiMian()
end

function this.OnClickDesktop(go)
	AudioManager.Instance:PlayAudio('btn')
	UnityEngine.PlayerPrefs.SetInt('ground_yjqf', tonumber(go.name))
	panelInGame.ChangeDesktopBg()
end

function this.SetShowRule()
	rule.wanFaLabel.text = roomData.playName
	rule.ruleLabel.text= getYJQFRuleString(roomData.setting)
end

function this.OnAudioSliderValueChange()
    UnityEngine.PlayerPrefs.SetFloat('audio_value', UIProgressBar.current.value)
	AudioManager.Instance:SetAudioVolume(UIProgressBar.current.value)
	sound.audioProces:GetComponent('UILabel').text = math.ceil(UIProgressBar.current.value*100)..'%'
end

function this.OnMusicSliderValueChange()
    UnityEngine.PlayerPrefs.SetFloat('music_value', UIProgressBar.current.value)
    AudioManager.Instance:SetMusicVolume(UIProgressBar.current.value)
	sound.musicProces:GetComponent('UILabel').text = math.ceil(UIProgressBar.current.value*100)..'%'
end
function this.OnClickPlayerSound(go)
	if go == sound.pthSound.gameObject then
		UnityEngine.PlayerPrefs.SetInt("sound_yjqf", 0)
	else
		UnityEngine.PlayerPrefs.SetInt("sound_yjqf", 1)
	end
end


