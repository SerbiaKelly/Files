

panelGameSetting_pdk = {}
local this = panelGameSetting_pdk;

local message;
local gameObject;

-- local soundSettingToggle
-- local viewSettingToggle

local slider_audio
local slider_music
local audioProces
local musicProces

local paiMianOn
local paiMianOff
local ground1
local ground2
local ground3
local ground4
local PlayerSoundOn
local PlayerSoundOff
local PaiSizeSuper
local PaiSizeNormal
local PaiMianSizeSuper
local PaiMianSizeNormal
local AnimSlow
local AnimFast
local AnimThunder

local ButtonLogout
local ButtonCloseRoom
local ButtonOK
local ButtonClose
local mask


local playerSound = 1
local localtionService = 1
local paiMian = 1
local ground = 0
local pdkpaiSize = 0
local pdkpaiMianSize = 1
local animaSpeed = 0

----------------------------定位-------------------------
local PlayerUIObjs = {};
local DistanceObjs = {};
--------------------------------------------------------
local WanFaLab = nil;
local RuleLab = nil;


local C_DismissWaitingTime = 5
local WaiteCloseRoom
local WaiteCloseRoomCoroutine

function this.Awake(obj)
	gameObject = obj;

	-- soundSettingToggle = gameObject.transform:Find('toggle/sound')
	-- viewSettingToggle = gameObject.transform:Find('toggle/view')

	slider_audio = gameObject.transform:Find('soundSetting/slider_audio'):GetComponent('UISlider');
	slider_music = gameObject.transform:Find('soundSetting/slider_music'):GetComponent('UISlider');
	audioProces = gameObject.transform:Find('soundSetting/slider_audio/Label')
	musicProces = gameObject.transform:Find('soundSetting/slider_music/Label')
	PlayerSoundOn = gameObject.transform:Find('soundSetting/PlayerSound/on');
	PlayerSoundOff = gameObject.transform:Find('soundSetting/PlayerSound/off');

	paiMianOn = gameObject.transform:Find('viewSetting/paiMian/on')
	paiMianOff = gameObject.transform:Find('viewSetting/paiMian/off')
	ground1 = gameObject.transform:Find('viewSetting/ground/0')
	ground2 = gameObject.transform:Find('viewSetting/ground/1')
	ground3 = gameObject.transform:Find('viewSetting/ground/2')
	ground4 = gameObject.transform:Find('viewSetting/ground/3')

	PaiSizeNormal = gameObject.transform:Find('viewSetting/size/normalPai')
	PaiSizeSuper = gameObject.transform:Find('viewSetting/size/superPai')

	PaiMianSizeNormal = gameObject.transform:Find('viewSetting/paiSize/normalPai')
	PaiMianSizeSuper = gameObject.transform:Find('viewSetting/paiSize/superPai')
	
	AnimSlow = gameObject.transform:Find('viewSetting/speed/slow')
	AnimFast = gameObject.transform:Find('viewSetting/speed/fast')
	AnimThunder = gameObject.transform:Find('viewSetting/speed/thunder')

    ButtonCloseRoom = gameObject.transform:Find('ButtonCloseRoom');
	
	ButtonClose = gameObject.transform:Find('ButtonSure');
	ButtonOK = gameObject.transform:Find('ButtonOK');
    mask = gameObject.transform:Find('mask');

	WaiteCloseRoom = gameObject.transform:Find('WaiteCloseRoom')
	WanFaLab        = gameObject.transform:Find('ruleSetting/WanFa/Label'):GetComponent('UILabel');    
    RuleLab         = gameObject.transform:Find('ruleSetting/Rule/Label'):GetComponent('UILabel');  

    EventDelegate.AddForLua(slider_audio.onChange, this.OnAudioSliderValueChange)
    EventDelegate.AddForLua(slider_music.onChange, this.OnMusicSliderValueChange)

	message = gameObject:GetComponent('LuaBehaviour');
	message:AddClick(PlayerSoundOn.gameObject, this.OnClickPlayerSoundOn);
	message:AddClick(PlayerSoundOff.gameObject, this.OnClickPlayerSoundOff);
	message:AddClick(paiMianOn.gameObject, this.OnClickPaiMianOn);
	message:AddClick(paiMianOff.gameObject, this.OnClickPaiMianOff);
	message:AddClick(ground1.gameObject, this.OnClickGround1)
	message:AddClick(ground2.gameObject, this.OnClickGround2)
	message:AddClick(ground3.gameObject, this.OnClickGround3)
	message:AddClick(ground4.gameObject, this.OnClickGround4)
	message:AddClick(ButtonCloseRoom.gameObject, this.OnClicButtonCloseRoom);
	
	message:AddClick(PaiSizeNormal.gameObject, this.OnPaiSizeChange)
	message:AddClick(PaiSizeSuper.gameObject, this.OnPaiSizeChange)

	message:AddClick(PaiMianSizeNormal.gameObject, this.OnPaiMianSizeChange)
	message:AddClick(PaiMianSizeSuper.gameObject, this.OnPaiMianSizeChange)

	message:AddClick(AnimSlow.gameObject, this.OnAnimSpeedChange)
	message:AddClick(AnimFast.gameObject, this.OnAnimSpeedChange)
	message:AddClick(AnimThunder.gameObject, this.OnAnimSpeedChange)

    message:AddClick(ButtonOK.gameObject, this.OnClickMask);
	message:AddClick(ButtonClose.gameObject, this.OnClickMask);
	this.GetDistanceUI();
end
function this.Update()
   
end
function this.Start()

end
local isGameing=false
function this.WhoShow(name)
	isGameing=name
	this.SetGPSUI(roomData.setting.size);
    this.SetDistance(this.GetDistance(roomData.setting.size),roomData.setting.size);
	this.SetPlayerInfo();
	this.SetRuleInfo();
end

--根据玩的人数设置GSP的显隐
function this.SetGPSUI(playerSize)

	if playerSize == 2 then
		for i = 1, 6 do
			DistanceObjs[i].transform.gameObject:SetActive(false);
		end

		PlayerUIObjs[1].transform.gameObject:SetActive(true);
		PlayerUIObjs[2].transform.gameObject:SetActive(true);
		PlayerUIObjs[3].transform.gameObject:SetActive(false);
		PlayerUIObjs[4].transform.gameObject:SetActive(false);

	elseif playerSize == 3 then
		DistanceObjs[1].transform.gameObject:SetActive(false);
		DistanceObjs[2].transform.gameObject:SetActive(false);
		DistanceObjs[5].transform.gameObject:SetActive(false);
		DistanceObjs[3].transform.gameObject:SetActive(true);
		DistanceObjs[4].transform.gameObject:SetActive(true);
		DistanceObjs[6].transform.gameObject:SetActive(true);

		PlayerUIObjs[1].transform.gameObject:SetActive(true);
		PlayerUIObjs[3].transform.gameObject:SetActive(true);
		PlayerUIObjs[4].transform.gameObject:SetActive(true);
		PlayerUIObjs[2].transform.gameObject:SetActive(false);
	else
		for i = 1, 6 do
			DistanceObjs[i].transform.gameObject:SetActive(true);
		end
		for i = 1, 4 do
			PlayerUIObjs[i].transform.gameObject:SetActive(true);
		end
	end



end



--设置距离
function this.SetDistance(distanceTable,playerSize)
	if playerSize == 2 then return end;
	for key, value in pairs(distanceTable) do
		--print("key="..key..",value:"..value);
		if value == -1 then
			DistanceObjs[key].transform.gameObject:SetActive(false);
		else
			DistanceObjs[key].transform.gameObject:SetActive(true);
			DistanceObjs[key].transform:Find("disLabel"):GetComponent("UILabel").text = value;
		end

	end
end

function this.GetDistanceKey(playerSize)
	if playerSize == 2 then
		--return {};
		return {6};
	elseif playerSize == 3 then
		return {6,3,4};
	else
		return {1,2,3,4,5,6};
	end
end

--根据玩的人数和玩家的GPS信息返回对应的距离
function this.GetDistance(playerSize)
	local keys = this.GetDistanceKey(playerSize);
	local i = 0;
	local distanceTable = {};
	for key, value in pairs(keys) do

		if i <= 3 then
			local playerData1 = panelInGame.GetPlayerDataByUIIndex(i);
			local p2index = (i + 1) % playerSize;
			local playerData2 = panelInGame.GetPlayerDataByUIIndex(p2index);

			if playerData1 and playerData2 then
				local tempDistance = GetDistance(playerData1.longitude, playerData1.latitude, playerData2.longitude, playerData2.latitude);
				distanceTable[value] = tempDistance;
			else
				distanceTable[value] = -1;
			end
		else
			local playerData1;
			local playerData2;
			if key == 5 then
				playerData1 = panelInGame.GetPlayerDataByUIIndex(1);
				playerData2 = panelInGame.GetPlayerDataByUIIndex(3);
			elseif key == 6 then
				playerData1 = panelInGame.GetPlayerDataByUIIndex(0);
				playerData2 = panelInGame.GetPlayerDataByUIIndex(2);
			end

			if playerData1 and playerData2 then
				local tempDistance = GetDistance(playerData1.longitude, playerData1.latitude, playerData2.longitude, playerData2.latitude);
				distanceTable[value] = tempDistance;
			else
				distanceTable[value] = -1;
			end
		end
		i = i+1;
	end
	return distanceTable;
end

function this.SetPlayerInfo()
    for i = 0, 3 do
        local player = panelInGame.GetPlayerDataByUIIndex(i);
		local realIndex = this.GetUIIndex(i,roomData.setting.size)+1;
		if player then
			--头像
			print("realIndex:"..tostring(realIndex));
			print("i:"..tostring(i));
			coroutine.start(LoadPlayerIcon, PlayerUIObjs[realIndex].HeadImage:GetComponent('UITexture'), player.icon);
			--名字
			PlayerUIObjs[realIndex].Name:GetComponent("UILabel").text = player.name;
			print("player.name:"..tostring(player.name));
			--id
			PlayerUIObjs[realIndex].ID:GetComponent("UILabel").text = player.id;
		else

			PlayerUIObjs[realIndex].Name:GetComponent("UILabel").text 	= "";
			PlayerUIObjs[realIndex].ID:GetComponent("UILabel").text 	= "";
			coroutine.start(LoadPlayerIcon, PlayerUIObjs[realIndex].HeadImage:GetComponent('UITexture'), "null");
		end
    end
end

function this.SetRuleInfo()
	print("SetRuleInfo was called");
	WanFaLab.text 	= roomData.playName
	RuleLab.text 	= getWanFaText(roomData.setting, false, false, false)
end

function this.GetUIIndex(index,playerSize)
	if playerSize == 3 then
		if index == 1 then
			return 2;
		elseif index == 2 then
			return 3;
		elseif index == 3 then
			return 0;
		else
			return index;
		end
	else
		return index;
	end
end


function this.GetDistanceUI()
    local distanceObj = gameObject.transform:Find("localSetting/Distance");
    local playerObj = gameObject.transform:Find("localSetting/players");
    --用户信息
    for i = 1, 4 do
        PlayerUIObjs[i] = {};
        PlayerUIObjs[i].transform = playerObj:Find("Player"..i);
        PlayerUIObjs[i].HeadImage = PlayerUIObjs[i].transform:Find("tx");
        PlayerUIObjs[i].Name = PlayerUIObjs[i].transform:Find("Name");
        PlayerUIObjs[i].ID = PlayerUIObjs[i].transform:Find("id");
    end
    --距离信息
    for i = 1, 6 do
        DistanceObjs[i] = {};
        DistanceObjs[i].transform = distanceObj:Find("distance"..i);
        DistanceObjs[i].disLabel = DistanceObjs[i].transform:Find("disLabel");
    end
end
function this.OnEnable()
    slider_audio.value = UnityEngine.PlayerPrefs.GetFloat('audio_value', 1)
	slider_music.value = UnityEngine.PlayerPrefs.GetFloat('music_value', 1)
	--if panelInGame == panelInGame_pdk then
		--paiMian = UnityEngine.PlayerPrefs.GetInt('paiMian_pdk', 1)
	ground = UnityEngine.PlayerPrefs.GetInt('ground_pdk', 1)
	playerSound = UnityEngine.PlayerPrefs.GetInt('playerSound_pdk', 1)
	-- else
	-- 	paiMian = UnityEngine.PlayerPrefs.GetInt('paiMian', 1)
	-- 	ground = UnityEngine.PlayerPrefs.GetInt('ground', 1)
	-- 	playerSound = UnityEngine.PlayerPrefs.GetInt('playerSound', 1)
	-- end

	--localtionService = UnityEngine.PlayerPrefs.GetInt('localtionService', 1)
	-- landScape = UnityEngine.PlayerPrefs.GetInt('landScape', 1)
	pdkpaiSize = UnityEngine.PlayerPrefs.GetInt("pdkpaiSize", 0)
	pdkpaiMianSize = UnityEngine.PlayerPrefs.GetInt("pdkpaiMianSize", 1)
	--animaSpeed = UnityEngine.PlayerPrefs.GetInt('animaSpeed', 0)
	
	-- paiMianOn:GetComponent('UIToggle'):Set(paiMian == 1)
	-- paiMianOff:GetComponent('UIToggle'):Set(paiMian ~= 1)

	ground1:GetComponent('UIToggle'):Set(ground == 1)
	ground2:GetComponent('UIToggle'):Set(ground == 2)
	ground3:GetComponent('UIToggle'):Set(ground == 3)
	ground4:GetComponent('UIToggle'):Set(ground == 4)

	PlayerSoundOn:GetComponent('UIToggle'):Set(playerSound == 1)
	PlayerSoundOff:GetComponent('UIToggle'):Set(playerSound ~= 1)
	
	-- print("paiSize："..paiSize)
	 PaiSizeNormal:GetComponent('UIToggle'):Set(pdkpaiSize == 0)
	 PaiSizeSuper:GetComponent('UIToggle'):Set(pdkpaiSize == 1)

	 PaiMianSizeNormal:GetComponent('UIToggle'):Set(pdkpaiMianSize == 0)
	 PaiMianSizeSuper:GetComponent('UIToggle'):Set(pdkpaiMianSize == 1)
	-- print("animaSpeed"..animaSpeed)
	-- AnimSlow:GetComponent('UIToggle'):Set(animaSpeed == 0)
	-- AnimFast:GetComponent('UIToggle'):Set(animaSpeed == 1)
	-- AnimThunder:GetComponent('UIToggle'):Set(animaSpeed == 2)


	-- if panelInGame == panelInGame_pdk then
	-- 	paiMianOn.parent.gameObject:SetActive(false)
	-- 	PaiSizeNormal.parent.gameObject:SetActive(false)
	-- 	AnimSlow.parent.gameObject:SetActive(false)
	-- 	ground2.gameObject:SetActive(false)
	-- else
	-- 	paiMianOn.parent.gameObject:SetActive(true)
	-- 	PaiSizeNormal.parent.gameObject:SetActive(true)
	-- 	AnimSlow.parent.gameObject:SetActive(true)
	-- 	ground2.gameObject:SetActive(true)
	-- end

	print(tostring(roomData.dissolveLimit))
	print(tostring(panelInGame.myseflDissolveTimes))
	if roomData.dissolveLimit == proxy_pb.UNLIMITED then

	elseif roomData.dissolveLimit == proxy_pb.FIVE_SECONDS and isGameing and panelInGame.myseflDissolveTimes > 0 then
		this.ShowWaitClose()
	end
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
		 if panelInGame.IsAllReaded() and roomData.dissolveType == 3 then
			panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '该牌友群已设置不可自主解散房间，若有疑问请联系群主');
			PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
			return
		end

		print('roomData.state:'..roomData.state)

		AudioManager.Instance:PlayAudio('btn')
		if panelInGame == panelInGame_pdk then
			local msg = Message.New()
			msg.type = pdk_pb.DISSOLVE_APPLY
			SendGameMessage(msg, nil)
			print("解散房间")
		else
			local msg = Message.New()
			msg.type = phz_pb.DISSOLVE
			local body = phz_pb.PDissolve()
			body.decision = phz_pb.APPLY
			msg.body = body:SerializeToString()
			SendGameMessage(msg, nil);
		end

		--增加一次申请解散次数
		panelInGame.myseflDissolveTimes = panelInGame.myseflDissolveTimes + 1

	else
		this.OnClicButtonLeaveRoom()
		
	end
	
	
	PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClicButtonLeaveRoom(go)
	AudioManager.Instance:PlayAudio('btn')
	if panelInGame == panelInGame_pdk then
		local msg = Message.New()
		msg.type = pdk_pb.LEAVE_ROOM
		SendGameMessage(msg, nil)
		print("离开房间")
		panelInGame.fanHuiRoomNumber = nil
	else
		local msg = Message.New()
		msg.type = phz_pb.LEAVE_ROOM
		SendGameMessage(msg, nil)
	end
	PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickPlayerSoundOn(go)
	AudioManager.Instance:PlayAudio('btn')
	playerSound = 1
	if panelInGame == panelInGame_pdk then
		UnityEngine.PlayerPrefs.SetInt('playerSound_pdk', playerSound)
	else
		UnityEngine.PlayerPrefs.SetInt('playerSound', playerSound)
	end
	-- if panelInGame then
	-- 	panelInGame.OpenVoiceEvent()()
	-- end
end
function this.OnClickPlayerSoundOff(go)
	AudioManager.Instance:PlayAudio('btn')
	playerSound = 0
	if panelInGame == panelInGame_pdk then
		UnityEngine.PlayerPrefs.SetInt('playerSound_pdk', playerSound)
	else
		UnityEngine.PlayerPrefs.SetInt('playerSound', playerSound)
	end
    --UnityEngine.PlayerPrefs.SetInt('playerSound', playerSound)
	-- if panelInGame then
	-- 	panelInGame.CloseVoiceEvent()()
	-- end
end
function this.OnClickPaiMianOn(go)
	AudioManager.Instance:PlayAudio('btn')
	paiMian = 1
	if panelInGame~=nil then
		panelInGame.changePaiMian(paiMian)
	end
	if panelInGame == panelInGame_pdk then
		UnityEngine.PlayerPrefs.SetInt('paiMian_pdk', paiMian)
	else
		UnityEngine.PlayerPrefs.SetInt('paiMian', paiMian)
	end
	--UnityEngine.PlayerPrefs.SetInt('paiMian', paiMian)
end
function this.OnClickPaiMianOff(go)
	AudioManager.Instance:PlayAudio('btn')
	paiMian = 0
	if panelInGame~=nil then
		panelInGame.changePaiMian(paiMian)
	end
	if panelInGame == panelInGame_pdk then
		UnityEngine.PlayerPrefs.SetInt('paiMian_pdk', paiMian)
	else
		UnityEngine.PlayerPrefs.SetInt('paiMian', paiMian)
	end
	--UnityEngine.PlayerPrefs.SetInt('paiMian', paiMian)
end

function this.OnClickGround1(go)
	AudioManager.Instance:PlayAudio('btn')
	ground = 1
	if panelInGame~=nil then
		panelInGame.changeBG(ground)
	end
	UnityEngine.PlayerPrefs.SetInt('ground_pdk', ground)
end

function this.OnClickGround2(go)
	AudioManager.Instance:PlayAudio('btn')
	ground = 2
	if panelInGame~=nil then
		panelInGame.changeBG(ground)
	end
	UnityEngine.PlayerPrefs.SetInt('ground_pdk', ground)
	--UnityEngine.PlayerPrefs.SetInt('ground', ground)
end

function this.OnClickGround3(go)
	AudioManager.Instance:PlayAudio('btn')
	ground = 3
	if panelInGame~=nil then
		panelInGame.changeBG(ground)
	end
	UnityEngine.PlayerPrefs.SetInt('ground_pdk', ground)
	--UnityEngine.PlayerPrefs.SetInt('ground', ground)
end
function this.OnClickGround4(go)
	AudioManager.Instance:PlayAudio('btn')
	ground = 4
	if panelInGame~=nil then
		panelInGame.changeBG(ground)
	end
	UnityEngine.PlayerPrefs.SetInt('ground_pdk', ground)
	--UnityEngine.PlayerPrefs.SetInt('ground', ground)
end

function this.OnClickMask(go)
	AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnPaiSizeChange(go)
	
	if go == PaiSizeSuper.gameObject then
		pdkpaiSize = 1
	else
		pdkpaiSize = 0
	end

	panelInGame.changePaiSize(pdkpaiSize)
	UnityEngine.PlayerPrefs.SetInt('pdkpaiSize', pdkpaiSize)
end

function this.OnPaiMianSizeChange(go)
	
	if go == PaiMianSizeSuper.gameObject then
		pdkpaiMianSize = 1
	else
		pdkpaiMianSize = 0
	end

	panelInGame.changePaiMianSize(pdkpaiMianSize)
	UnityEngine.PlayerPrefs.SetInt('pdkpaiMianSize', pdkpaiMianSize)
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
	end);
end