

local csm_pb = require 'csm_pb'
panelGameSetting_mj = {}
local this = panelGameSetting_mj;

local message;
local gameObject;
local slider_audio
local slider_music
local audioProces
local musicProces
local PlayerSoundOn
local PlayerSoundOff
local ButtonCloseRoom
local ButtonOK
local ButtonClose
local mask
local playerSound = 1

local cardColorNum = 2;
local BgColorNum = 3;

----------------------------定位-------------------------
local PlayerUIObjs = {};
local DistanceObjs = {};
--------------------------------------------------------
local WanFaLab = nil;
local RuleLab = nil;

local view_Set;
local view_local;
local view_rule;

local roomData;

local C_DismissWaitingTime = 5
local WaiteCloseRoom
local WaiteCloseRoomCoroutine
local mySeat = nil;

function this.Awake(obj)
    gameObject      = obj
    message = gameObject:GetComponent('LuaBehaviour')
	slider_audio    = gameObject.transform:Find('view_sound/soundSetting/slider_audio'):GetComponent('UISlider');
	slider_music    = gameObject.transform:Find('view_sound/soundSetting/slider_music'):GetComponent('UISlider');
	audioProces     = gameObject.transform:Find('view_sound/soundSetting/slider_audio/Label')
    musicProces     = gameObject.transform:Find('view_sound/soundSetting/slider_music/Label')
    PlayerSoundOn   = gameObject.transform:Find('view_sound/PlayerSound/on')
	PlayerSoundOff  = gameObject.transform:Find('view_sound/PlayerSound/off')
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
    message:AddClick(PlayerSoundOn.gameObject, this.OnClickPlayerSound)
	message:AddClick(PlayerSoundOff.gameObject, this.OnClickPlayerSound)

	

    for i = 1,cardColorNum do
        local cardColor = gameObject.transform:Find('view_Set/viewSetting/cardColor/'..i);
        local cardText = gameObject.transform:Find('view_Set/viewSetting/cardText/'..i);
        message:AddClick(cardColor.gameObject,this.OnCardColorClick);
        message:AddClick(cardText.gameObject,this.OnCardTextClick);
    end

    for i = 1,BgColorNum do
        local cardBG = gameObject.transform:Find('view_Set/viewSetting/tableType/'..i);
        message:AddClick(cardBG.gameObject,this.OnBGColorClick);
    end
	
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

    isGameing= data.ingame;
    roomData = data.roomData;
    mySeat  = data.mySeat;
    this.ClickShowRule();
    this.ClickTable_Local(data.gpsdata)
    this.SetPresetting();

end

function this.OnEnable()

end

function this.SetPresetting()
    slider_audio.value = UnityEngine.PlayerPrefs.GetFloat('audio_value', 1)
    slider_music.value = UnityEngine.PlayerPrefs.GetFloat('music_value', 1)
    local playerSound = 1
    if roomData.setting.roomTypeValue == proxy_pb.CSM then
        playerSound = UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)
    end
    PlayerSoundOn.parent.gameObject:SetActive(roomData.setting.roomTypeValue == proxy_pb.CSM)
    slider_audio.transform.parent.localPosition = roomData.setting.roomTypeValue == proxy_pb.CSM and Vector3(0,0,0) or Vector3(0,65,0)
	PlayerSoundOn:GetComponent('UIToggle'):Set(playerSound == 1)
	PlayerSoundOff:GetComponent('UIToggle'):Set(playerSound ~= 1)

    local bgColor   = UnityEngine.PlayerPrefs.GetInt('bgColor_mj', 1);
    local cardColor = UnityEngine.PlayerPrefs.GetInt('cardColor_mj', 1);
    local cardText  = UnityEngine.PlayerPrefs.GetInt('cardText_mj', 1);

    for i = 1, cardColorNum do
        local cardColorTrans = gameObject.transform:Find('view_Set/viewSetting/cardColor/'..i);
        local cardTextTrans = gameObject.transform:Find('view_Set/viewSetting/cardText/'..i);
        cardColorTrans:GetComponent('UIToggle'):Set(cardColor == i);
        cardTextTrans:GetComponent('UIToggle'):Set(cardText == i);
    end

    for i = 1,BgColorNum do
        local bgColorTrans = gameObject.transform:Find('view_Set/viewSetting/tableType/'..i);
        bgColorTrans:GetComponent('UIToggle'):Set(bgColor == i);
    end


    if roomData.dissolveLimit == proxy_pb.UNLIMITED then

    elseif roomData.dissolveLimit == proxy_pb.FIVE_SECONDS and isGameing and panelInGame.myseflDissolveTimes > 0 then
        this.ShowWaitClose()
    end
end

function this.OnClickPlayerSound(go)
    AudioManager.Instance:PlayAudio('btn')
	if go == PlayerSoundOn.gameObject then
        UnityEngine.PlayerPrefs.SetInt('csmplayerSound', 1)
    else
        UnityEngine.PlayerPrefs.SetInt('csmplayerSound', 0)
    end
end

--设置游戏牌色
function this.OnCardColorClick(obj)
     print("OnCardColorClick:"..tostring(obj));
    AudioManager.Instance:PlayAudio('btn')
    panelInGame.SetCardColor(tonumber(obj.name));
    UnityEngine.PlayerPrefs.SetInt('cardColor_mj', tonumber(obj.name));
end

--设置麻将牌的牌面字体
function this.OnCardTextClick(obj)
    print("OnCardTextClick"..tostring(obj));
    AudioManager.Instance:PlayAudio('btn')
    panelInGame.SetCardText(tonumber(obj.name));
    UnityEngine.PlayerPrefs.SetInt('cardText_mj', tonumber(obj.name));

end

--设置游戏背景
function this.OnBGColorClick(obj)
    -- print("OnBGColorClick:"..tostring(obj));
    AudioManager.Instance:PlayAudio('btn')
    panelInGame.ChooseBG(tonumber(obj.name));
    UnityEngine.PlayerPrefs.SetInt('bgColor_mj', tonumber(obj.name));
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
        print("2222")
        local msg = Message.New()
        msg.type = csm_pb.DISSOLVE
        local body = csm_pb.PDissolve()
        body.decision = csm_pb.APPLY
        msg.body = body:SerializeToString()
        SendGameMessage(msg, nil);
        --增加一次申请解散次数
		panelInGame.myseflDissolveTimes = panelInGame.myseflDissolveTimes + 1
    else
        print("1111")
		this.OnClicButtonLeaveRoom()
		
	end
    
	-- AudioManager.Instance:PlayAudio('btn')
	-- local msg = Message.New();
	-- msg.type = csm_pb.DISSOLVE;
	-- local body = csm_pb.PDissolve();
	-- body.decision = csm_pb.APPLY;
	-- msg.body = body:SerializeToString();
	-- SendGameMessage(msg, nil);
	PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClicButtonLeaveRoom(go)
	AudioManager.Instance:PlayAudio('btn')
	if mySeat == 0 then
		local msg = Message.New();
		local msg       = Message.New();
        msg.type        = csm_pb.DISSOLVE;
        local body      = csm_pb.PDissolve();
        body.decision   = csm_pb.APPLY;
        msg.body        = body:SerializeToString();
        SendGameMessage(msg, nil);
		print("解散房间");
	else
		local msg = Message.New();
		msg.type = csm_pb.LEAVE_ROOM;
        SendGameMessage(msg, nil);
		print("离开房间");
        
    end
    panelInGame.fanHuiRoomNumber = nil
	PanelManager.Instance:HideWindow(gameObject.name)
end


----------------------------点击定位-----------------------
function this.ClickTable_Local(data)
    
    this.SetGPSUI(data.playerSize);
    this.SetDistance(data.distanceTable);
    this.SetPlayerInfo(data.playerSize);

end


function this.GetDistanceUI()
    local distanceObj = gameObject.transform:Find("view_local/Distance");
    local playerObj = gameObject.transform:Find("view_local/players");
    --用户信息
    for i = 1, 4 do
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
function this.SetGPSUI(playerSize)
    if playerSize == 2 then
        for i = 1, 6 do
            DistanceObjs[i].transform.gameObject:SetActive(false);
        end
        --DistanceObjs[6].transform.gameObject:SetActive(true);

        PlayerUIObjs[1].transform.gameObject:SetActive(true);
        PlayerUIObjs[2].transform.gameObject:SetActive(false);
        PlayerUIObjs[3].transform.gameObject:SetActive(true);
        PlayerUIObjs[4].transform.gameObject:SetActive(false);

    elseif playerSize == 3 then
        DistanceObjs[2].transform.gameObject:SetActive(false);
        DistanceObjs[3].transform.gameObject:SetActive(false);
        DistanceObjs[6].transform.gameObject:SetActive(false);

        DistanceObjs[1].transform.gameObject:SetActive(true);
        DistanceObjs[4].transform.gameObject:SetActive(true);
        DistanceObjs[5].transform.gameObject:SetActive(true);

        PlayerUIObjs[1].transform.gameObject:SetActive(true);
        PlayerUIObjs[2].transform.gameObject:SetActive(true);
        PlayerUIObjs[3].transform.gameObject:SetActive(false);
        PlayerUIObjs[4].transform.gameObject:SetActive(true);

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
function this.SetDistance(distanceTable)
    print("SetDistance was called");
    for key, value in pairs(distanceTable) do
        print("key="..key..",value:"..value);
        if value == -1 then
            DistanceObjs[key].transform.gameObject:SetActive(false);
        else
            DistanceObjs[key].transform.gameObject:SetActive(true);
            DistanceObjs[key].disLabel:GetComponent("UILabel").text = value;
        end

    end
end


function this.SetPlayerInfo(playerSize)
    for i = 0, playerSize - 1 do

        local player = panelInGame.GetPlayerDataByUIIndex(i);
        if player then

            --头像
            coroutine.start(LoadPlayerIcon, PlayerUIObjs[panelInGame.GetUIIndex(i,playerSize)+1].HeadImage:GetComponent('UITexture'), player.icon);

            --名字
            PlayerUIObjs[panelInGame.GetUIIndex(i,playerSize)+1].Name:GetComponent("UILabel").text = player.name;
            --id
            PlayerUIObjs[panelInGame.GetUIIndex(i,playerSize)+1].ID:GetComponent("UILabel").text = player.id;
            PlayerUIObjs[panelInGame.GetUIIndex(i,playerSize)+1].HeadImage.gameObject:SetActive(true);
        else
            PlayerUIObjs[panelInGame.GetUIIndex(i,playerSize)+1].HeadImage.gameObject:SetActive(false);
            PlayerUIObjs[panelInGame.GetUIIndex(i,playerSize)+1].Name:GetComponent("UILabel").text = "";
        end



    end
end
---------------------------------------------------

function this.ClickShowRule()
	--AudioManager.Instance:PlayAudio('btn')

	local playString = '';
	if roomData.setting.roomTypeValue == proxy_pb.ZZM then
		playString = "转转麻将";
	elseif roomData.setting.roomTypeValue == proxy_pb.CSM then
		playString = "长沙麻将";
	elseif roomData.setting.roomTypeValue == proxy_pb.HZM then
		playString = "红中麻将";
	end
	WanFaLab.text = playString;
	RuleLab.text= GetMJRuleText(roomData.setting,false);
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

