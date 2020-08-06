local xhzd_pb = require 'xhzd_pb'

panelGameSetting_xhzd = {}
local this = panelGameSetting_xhzd;

local message;
local gameObject;
local slider_audio
local slider_music
local audioProces
local musicProces
local ButtonCloseRoom
local ButtonOK
local ButtonClose
local mask
local playerSound = 1

local ground = 0
local xhzdpaiSize = 0
----------------------------定位-------------------------
local PlayerUIObjs = {};
local DistanceObjs = {};
--------------------------------------------------------
local WanFaLab = nil;
local RuleLab = nil;

local view_Set;
local view_local;
local view_rule;

local PaiSizeSuper
local PaiSizeNormal
local ground1
local ground2
local ground3
local ground4

local roomData;

local C_DismissWaitingTime = 5
local WaiteCloseRoom
local WaiteCloseRoomCoroutine

function this.Awake(obj)
	gameObject      = obj;
	slider_audio    = gameObject.transform:Find('view_Set/soundSetting/slider_audio'):GetComponent('UISlider');
	slider_music    = gameObject.transform:Find('view_Set/soundSetting/slider_music'):GetComponent('UISlider');
	audioProces     = gameObject.transform:Find('view_Set/soundSetting/slider_audio/Label')
	musicProces     = gameObject.transform:Find('view_Set/soundSetting/slider_music/Label')
    ButtonCloseRoom = gameObject.transform:Find('ButtonCloseRoom');
	ButtonOK        = gameObject.transform:Find('ButtonOK');
    mask            = gameObject.transform:Find('mask');

    WanFaLab        = gameObject.transform:Find('view_rule/WanFa/Label'):GetComponent('UILabel');    
    RuleLab         = gameObject.transform:Find('view_rule/Rule/Label'):GetComponent('UILabel');    

    view_Set        = gameObject.transform:Find('view_Set');
    view_local      = gameObject.transform:Find('view_local');
    view_rule       = gameObject.transform:Find('view_rule');

	WaiteCloseRoom = gameObject.transform:Find('WaiteCloseRoom')

    EventDelegate.AddForLua(slider_audio.onChange, this.OnAudioSliderValueChange)
    EventDelegate.AddForLua(slider_music.onChange, this.OnMusicSliderValueChange)

	message = gameObject:GetComponent('LuaBehaviour');
    
    message:AddClick(view_Set.gameObject, this.OnClickTableType);
    message:AddClick(view_local.gameObject, this.OnClickTableType);
    message:AddClick(view_rule.gameObject, this.OnClickTableType);
	
	PaiSizeNormal = gameObject.transform:Find('view_Set/viewSetting/cardColor/normalPai')
	PaiSizeSuper = gameObject.transform:Find('view_Set/viewSetting/cardColor/superPai')
	message:AddClick(PaiSizeNormal.gameObject, this.OnPaiSizeChange)
	message:AddClick(PaiSizeSuper.gameObject, this.OnPaiSizeChange)

	ground1 = gameObject.transform:Find('view_Set/viewSetting/tableType/0')
	ground2 = gameObject.transform:Find('view_Set/viewSetting/tableType/1')
	ground3 = gameObject.transform:Find('view_Set/viewSetting/tableType/2')
	ground4 = gameObject.transform:Find('view_Set/viewSetting/tableType/3')
	
	message:AddClick(ground1.gameObject, this.OnClickGround1)
	message:AddClick(ground2.gameObject, this.OnClickGround2)
	message:AddClick(ground3.gameObject, this.OnClickGround3)
	message:AddClick(ground4.gameObject, this.OnClickGround4)

	message:AddClick(ButtonCloseRoom.gameObject, this.OnClicButtonCloseRoom);
    message:AddClick(ButtonOK.gameObject, this.OnClickMask);
    this.GetDistanceUI()
end

function this.Update()
   
end

function this.Start()

end

local isGameing=false
function this.WhoShow(data)
    isGameing= data.ingame
    roomData = data.roomData
    this.ClickShowRule();
    this.SetGPSUI();
    this.SetDistance();
	this.SetPlayerInfo();
	
	print(tostring(roomData.setting.dissolveLimit))
	--print(tostring(panelInGame.myseflDissolveTimes))
	if roomData.setting.dissolveLimit == proxy_pb.UNLIMITED then

	elseif roomData.setting.dissolveLimit == proxy_pb.FIVE_SECONDS and isGameing and panelInGame.myseflDissolveTimes > 0 then
		this.ShowWaitClose()
	end
end

function this.OnEnable()
    slider_audio.value = UnityEngine.PlayerPrefs.GetFloat('audio_value', 1)
    slider_music.value = UnityEngine.PlayerPrefs.GetFloat('music_value', 1)
    
    local bgColor = UnityEngine.PlayerPrefs.GetInt('bgColor_mj', 1);
    local cardColor = UnityEngine.PlayerPrefs.GetInt('cardColor_mj', 1);
	xhzdpaiSize = UnityEngine.PlayerPrefs.GetInt("xhzdpaiSize", 0)
	PaiSizeNormal:GetComponent('UIToggle'):Set(xhzdpaiSize == 0)
	PaiSizeSuper:GetComponent('UIToggle'):Set(xhzdpaiSize == 1)

	ground = UnityEngine.PlayerPrefs.GetInt("ground_xhzd", 1)
    ground1:GetComponent('UIToggle'):Set(ground == 1)
	ground2:GetComponent('UIToggle'):Set(ground == 2)
	ground3:GetComponent('UIToggle'):Set(ground == 3)
	ground4:GetComponent('UIToggle'):Set(ground == 4)
end

--设置游戏牌大小
function this.OnPaiSizeChange(go)
	
	if go == PaiSizeSuper.gameObject then
		xhzdpaiSize = 1
	else
		xhzdpaiSize = 0
	end
	--panelInGame.changePaiSize(xhzdpaiSize)
	UnityEngine.PlayerPrefs.SetInt('xhzdpaiSize', xhzdpaiSize)
end

--设置游戏背景
function this.OnClickGround1(go)
	AudioManager.Instance:PlayAudio('btn')
	ground = 1
	if panelInGame~=nil then
		panelInGame.changeBG(ground)
	end
	UnityEngine.PlayerPrefs.SetInt('ground_xhzd', ground)
end

function this.OnClickGround2(go)
	AudioManager.Instance:PlayAudio('btn')
	ground = 2
	if panelInGame~=nil then
		panelInGame.changeBG(ground)
	end
	UnityEngine.PlayerPrefs.SetInt('ground_xhzd', ground)
	--UnityEngine.PlayerPrefs.SetInt('ground', ground)
end

function this.OnClickGround3(go)
	AudioManager.Instance:PlayAudio('btn')
	ground = 3
	if panelInGame~=nil then
		panelInGame.changeBG(ground)
	end
	UnityEngine.PlayerPrefs.SetInt('ground_xhzd', ground)
	--UnityEngine.PlayerPrefs.SetInt('ground', ground)
end
function this.OnClickGround4(go)
	AudioManager.Instance:PlayAudio('btn')
	ground = 4
	if panelInGame~=nil then
		panelInGame.changeBG(ground)
	end
	UnityEngine.PlayerPrefs.SetInt('ground_xhzd', ground)
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
		 if panelInGame.IsAllReaded() and roomData.dissolveType == 3 then
			panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '该牌友群已设置不可自主解散房间，若有疑问请联系群主');
			PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
			return
		end

		print('roomData.state:'..roomData.state)

		AudioManager.Instance:PlayAudio('btn')
		if panelInGame == panelInGame_xhzd then
			local msg = Message.New()
			msg.type = xhzd_pb.DISSOLVE
			local b = xhzd_pb.PDissolve()
			b.decision = xhzd_pb.APPLY
			msg.body = b:SerializeToString()
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
	if panelInGame == panelInGame_xhzd then
		local msg = Message.New()
		msg.type = xhzd_pb.LEAVE_ROOM
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

function this.ClickShowRule()
	WanFaLab.text = '新化炸弹';
	RuleLab.text= getXHZDRuleString(roomData.setting,false);
end

function this.GetDistanceUI()
    local distanceObj = gameObject.transform:Find("view_local/Distance");
    local playerObj = gameObject.transform:Find("view_local/players");
    --用户信息
    for i = 0, 3 do
        PlayerUIObjs[i] = {};
        PlayerUIObjs[i].transform = playerObj:Find("Player"..i);
        PlayerUIObjs[i].HeadImage = PlayerUIObjs[i].transform:Find("tx");
        PlayerUIObjs[i].Name = PlayerUIObjs[i].transform:Find("name");
        PlayerUIObjs[i].ID = PlayerUIObjs[i].transform:Find("id");
    end
    --距离信息
    for i = 1, 6 do
        DistanceObjs[i] = {};
        DistanceObjs[i].transform = distanceObj:Find("distance"..i);
        DistanceObjs[i].disLabel = DistanceObjs[i].transform:Find("disLabel");
    end
end

--根据玩的人数设置GSP的显隐
function this.SetGPSUI()
    for i = 1, 6 do
        DistanceObjs[i].transform.gameObject:SetActive(true);
    end
    for i = 0, 3 do
        PlayerUIObjs[i].transform.gameObject:SetActive(true);
    end
end

--设置距离
function this.SetDistance()
    local distanceTable = panelInGame.GetDistance();
    for key, value in pairs(distanceTable) do
        --print("key="..key..",value:"..value);
        if value == -1 then
            DistanceObjs[key].disLabel:GetComponent("UILabel").text = '';
        else
            DistanceObjs[key].disLabel:GetComponent("UILabel").text = value;
        end
    end
end

function this.SetPlayerInfo()
	for i = 0, 3 do
		PlayerUIObjs[i].HeadImage:GetComponent('UITexture').mainTexture = nil
		PlayerUIObjs[i].Name:GetComponent("UILabel").text = '';
		PlayerUIObjs[i].ID:GetComponent("UILabel").text = '';
    end
	for i = 0, 3 do
		local player = panelInGame.GetPlayerDataByUIIndex(i);
		if player ~= nil then
			--print(i..'  player : '..tostring(player.seat))
			--头像
			coroutine.start(LoadPlayerIcon, PlayerUIObjs[i].HeadImage:GetComponent('UITexture'), player.icon);
			--名字
			PlayerUIObjs[i].Name:GetComponent("UILabel").text = player.name;
			--id
			PlayerUIObjs[i].ID:GetComponent("UILabel").text = player.id;
		else
			PlayerUIObjs[i].HeadImage:GetComponent('UITexture').mainTexture = nil
			PlayerUIObjs[i].Name:GetComponent("UILabel").text = '';
			PlayerUIObjs[i].ID:GetComponent("UILabel").text = '';		
		end
    end
end

function this.OnClickMask(go)
	AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
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


