
require("GPSTool");
local xplp_pb = require 'xplp_pb'
panelGameSetting_xplp = {}
local this = panelGameSetting_xplp;

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
local toggleNormalPlate;--普通牌面
local toggleSuperPlate;--大牌面
local toggleNormalLanguage;--普通话
local toggleLocalLanguage;--方言

local roomData;

local C_DismissWaitingTime = 5
local WaiteCloseRoom
local WaiteCloseRoomCoroutine
local outPlateTypeToggle;

local gpsTool = nil;
local logic  = nil;

function this.Awake(obj)
	gameObject              = obj;
	slider_audio            = gameObject.transform:Find('view_sound/soundSetting/slider_audio'):GetComponent('UISlider');
	slider_music            = gameObject.transform:Find('view_sound/soundSetting/slider_music'):GetComponent('UISlider');
	audioProces             = gameObject.transform:Find('view_sound/soundSetting/slider_audio/Label')
	musicProces             = gameObject.transform:Find('view_sound/soundSetting/slider_music/Label')
    ButtonCloseRoom         = gameObject.transform:Find('ButtonCloseRoom');
	ButtonOK                = gameObject.transform:Find('ButtonOK');
    mask                    = gameObject.transform:Find('mask');
    WanFaLab                = gameObject.transform:Find('view_rule/WanFa/Label'):GetComponent('UILabel');    
    RuleLab                 = gameObject.transform:Find('view_rule/Rule/Label'):GetComponent('UILabel');    
    view_Set                = gameObject.transform:Find('view_Set');
    view_local              = gameObject.transform:Find('view_local');
    view_rule               = gameObject.transform:Find('view_rule');
    toggleNormalPlate       = gameObject.transform:Find("view_Set/viewSetting/cardText/normalPai");
    toggleSuperPlate        = gameObject.transform:Find("view_Set/viewSetting/cardText/superPai");
    toggleNormalLanguage    = gameObject.transform:Find("view_sound/PlayerSound/common");
    toggleLocalLanguage     = gameObject.transform:Find("view_sound/PlayerSound/local");
    WaiteCloseRoom          = gameObject.transform:Find('WaiteCloseRoom')
    outPlateTypeToggle      = gameObject.transform:Find('view_Set/viewSetting/OutPlateTypeToggle');

    EventDelegate.AddForLua(slider_audio.onChange, this.OnAudioSliderValueChange)
    EventDelegate.AddForLua(slider_music.onChange, this.OnMusicSliderValueChange)

	message = gameObject:GetComponent('LuaBehaviour');
    
    message:AddClick(view_Set.gameObject,   this.OnClickTableType);
    message:AddClick(view_local.gameObject, this.OnClickTableType);
    message:AddClick(view_rule.gameObject,  this.OnClickTableType);

    message:AddClick(toggleNormalPlate.gameObject,  this.OnCardTextClick);
    message:AddClick(toggleSuperPlate.gameObject,   this.OnCardTextClick);

    message:AddClick(toggleNormalLanguage.gameObject,   this.OnClickLanguage);
    message:AddClick(toggleLocalLanguage.gameObject,   this.OnClickLanguage);

    message:AddClick(outPlateTypeToggle.gameObject,   this.OnClickOutPlateType);


    for i = 1,cardColorNum do
        local cardColor = gameObject.transform:Find('view_Set/viewSetting/cardColor/'..i);
        message:AddClick(cardColor.gameObject,this.OnCardColorClick);
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

function this.OnApplicationFocus()

end

local isGameing=false
function this.WhoShow(data)
    
    isGameing   = data.ingame;
    roomData    = data.roomData;
    logic       = data.logic;
    print("roomData==nil"..tostring(roomData == nil));
    if gpsTool == nil then 
        gpsTool = GPSTool.New(logic,roomData,DistanceObjs,PlayerUIObjs);
    end
    gpsTool:Refresh(logic,roomData);
    this.ClickShowRule();
    this.ClickTable_Local()
    this.SetPresetting();
    this.SetPlayerInfo();

end

function this.OnEnable()

end

function this.SetPresetting()
    slider_audio.value = UnityEngine.PlayerPrefs.GetFloat('audio_value', 1)
    slider_music.value = UnityEngine.PlayerPrefs.GetFloat('music_value', 1)


    local bgColor   = UnityEngine.PlayerPrefs.GetInt('bgColor_xplp', 1);
    local cardColor = UnityEngine.PlayerPrefs.GetInt('cardColor_xplp', 1);
    local cardText  = UnityEngine.PlayerPrefs.GetInt('cardText_xplp', 1);
    local language  = UnityEngine.PlayerPrefs.GetInt('language_xplp', 2);
    local outPlateType  = UnityEngine.PlayerPrefs.GetInt('outPlateType_xplp', 1);

    toggleNormalLanguage.transform:GetComponent("UIToggle"):Set(language == 1);
    toggleLocalLanguage.transform:GetComponent("UIToggle"):Set(language == 2);

    toggleNormalPlate.transform:GetComponent("UIToggle"):Set(cardText == 2);
    toggleSuperPlate.transform:GetComponent("UIToggle"):Set(cardText == 1);
    outPlateTypeToggle:GetComponent("UIToggle"):Set(outPlateType == 1);

    for i = 1, cardColorNum do
        local cardColorTrans = gameObject.transform:Find('view_Set/viewSetting/cardColor/'..i);
        cardColorTrans:GetComponent('UIToggle'):Set(cardColor == i);
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



--设置游戏牌色
function this.OnCardColorClick(obj)
     print("OnCardColorClick:"..tostring(obj));
    AudioManager.Instance:PlayAudio('btn')
    panelInGame.SetCardColor(tonumber(obj.name));
    UnityEngine.PlayerPrefs.SetInt('cardColor_xplp', tonumber(obj.name));
end

--设置麻将牌的牌面字体
function this.OnCardTextClick(obj)
    print("OnCardTextClick"..tostring(obj));
    AudioManager.Instance:PlayAudio('btn')
    if obj == toggleNormalPlate.gameObject then 
        print("path--------->1")
        panelInGame.SetCardText(2);
        UnityEngine.PlayerPrefs.SetInt('cardText_xplp', 2);
    elseif obj == toggleSuperPlate.gameObject then 
        print("path--------->2")
        panelInGame.SetCardText(1);
        UnityEngine.PlayerPrefs.SetInt('cardText_xplp', 1);
    end
    
end

--设置普通话或者方言
function this.OnClickLanguage(go)
    if go == toggleNormalLanguage.gameObject then 
        panelInGame.SetLanguage(1);
        UnityEngine.PlayerPrefs.SetInt('language_xplp', 1);
    elseif go == toggleLocalLanguage.gameObject then 
        panelInGame.SetLanguage(2);
        UnityEngine.PlayerPrefs.SetInt('language_xplp', 2);
    end
    
end

--设置游戏背景
function this.OnBGColorClick(obj)
    -- print("OnBGColorClick:"..tostring(obj));
    AudioManager.Instance:PlayAudio('btn')
    panelInGame.ChooseBG(tonumber(obj.name));
    UnityEngine.PlayerPrefs.SetInt('bgColor_xplp', tonumber(obj.name));
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
    AudioManager.Instance:PlayAudio('btn')
    if isGameing then
         --不能解散
		if roomData.state == 2 and roomData.dissolveType == 3 then
			panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '该牌友群已设置不可自主解散房间，若有疑问请联系群主');
			PanelManager.Instance:ShowWindow('panelMessageBoxTiShi');
			return
		end
        local msg       = Message.New();
        msg.type        = xplp_pb.DISSOLVE;
        local body      = xplp_pb.PDissolve();
        body.decision   = xplp_pb.APPLY;
        msg.body        = body:SerializeToString();
        SendGameMessage(msg, nil);
        --增加一次申请解散次数
        panelInGame.myseflDissolveTimes = panelInGame.myseflDissolveTimes + 1;
    else
		this.OnClicButtonLeaveRoom();
	end
	PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClicButtonLeaveRoom(go)
    AudioManager.Instance:PlayAudio('btn')
    if logic.mySeat == 0 then 
        local msg       = Message.New();
        msg.type        = xplp_pb.DISSOLVE;
        local body      = xplp_pb.PDissolve();
        body.decision   = xplp_pb.APPLY;
        msg.body        = body:SerializeToString();
        SendGameMessage(msg, nil);
    else
        local msg   = Message.New()
		msg.type    = xplp_pb.LEAVE_ROOM;
		SendGameMessage(msg, nil)
    end
	
    panelInGame.fanHuiRoomNumber = nil
	PanelManager.Instance:HideWindow(gameObject.name)
end


----------------------------点击定位-----------------------
function this.ClickTable_Local()
    gpsTool:Refresh(logic,roomData);
end


function this.GetDistanceUI()
    local distanceObj = gameObject.transform:Find("view_local/Distance");
    local playerObj = gameObject.transform:Find("view_local/players");
    --用户信息
    for i = 1, 4 do
        PlayerUIObjs[i] = {};
        PlayerUIObjs[i].transform = playerObj:Find("Player"..i);
        PlayerUIObjs[i].HeadImage = PlayerUIObjs[i].transform:Find("tx");
        PlayerUIObjs[i].Name = PlayerUIObjs[i].transform:Find("Name");
        PlayerUIObjs[i].ID = PlayerUIObjs[i].transform:Find("id");
        PlayerUIObjs[i].gameObject = PlayerUIObjs[i].transform.gameObject;
    end

    --距离信息
    for i = 1, 6 do
        DistanceObjs[i] = {};
        DistanceObjs[i].transform = distanceObj:Find("distance"..i);
        DistanceObjs[i].gameObject = DistanceObjs[i].transform.gameObject;
        DistanceObjs[i].disLabel = DistanceObjs[i].transform:Find("disLabel");
    end

end



---------------------------------------------------

function this.ClickShowRule()
	--AudioManager.Instance:PlayAudio('btn')
	local playString = '溆浦老牌';
	WanFaLab.text = playString;
	RuleLab.text= GetXPLPRuleText(roomData.setting,false);
end


function this.OnClickTableType(go)
	AudioManager.Instance:PlayAudio('btn');
    if(go == view_Set.gameObject) then
        
    elseif go == view_local.gameObject then
        
    elseif go == view_rule.gameObject then
        
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


function this.SetPlayerInfo()
    --先清空数据
    for i=1,4 do
        PlayerUIObjs[i].Name:GetComponent("UILabel").text 	= "";
        PlayerUIObjs[i].ID:GetComponent("UILabel").text 	= "";
        coroutine.start(LoadPlayerIcon, PlayerUIObjs[i].HeadImage:GetComponent('UITexture'), "null");
    end
    
    for i = 1, 4 do
        local player = logic:GetPlayerDataByUIIdex(i);
        local realIndex = logic:GetCorrectUIIndex(i,roomData.setting.size);
        
        if player  then
            --头像
            print("realIndex:"..tostring(realIndex));
            print("i:"..tostring(i));
            coroutine.start(LoadPlayerIcon, PlayerUIObjs[realIndex].HeadImage:GetComponent('UITexture'), player.icon);
            --名字
            PlayerUIObjs[realIndex].Name:GetComponent("UILabel").text = player.name;
            print("player.name:"..tostring(player.name));
            --id
            PlayerUIObjs[realIndex].ID:GetComponent("UILabel").text = player.id;
        end
    end
end

function this.OnClickOutPlateType()
    
    if outPlateTypeToggle:GetComponent("UIToggle").value then 
        UnityEngine.PlayerPrefs.SetInt('outPlateType_xplp', 1);
        panelInGame.SetOutPlateType(1);
    else
        UnityEngine.PlayerPrefs.SetInt('outPlateType_xplp', 0);
        panelInGame.SetOutPlateType(0);
    end

    
end
