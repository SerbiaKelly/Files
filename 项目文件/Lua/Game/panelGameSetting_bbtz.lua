require("BBTZ_Tools")
require("GPSTool")
local bbtz_pb = require("bbtz_pb")
local EventDispatcher = require("Event.EventDispatcher")
panelGameSetting_bbtz = {}
local this = panelGameSetting_bbtz

local message;
local gameObject;
local audioProces   = nil
local musicProces   = nil
local slider_audio  = nil
local slider_music  = nil
local PlayerUIObjs  = {};
local DistanceObjs  = {};
local ground1, ground2, ground3, ground4
local closeRoomBtn  = nil
local ButtonOK      = nil
local gpsTool       = nil;

local normalPaiButton;
local superPaiButton;
local bbtzPaiSize = 1;

local C_DismissWaitingTime = 5
local WaiteCloseRoom
local WaiteCloseRoomCoroutine

function this.Awake(obj)
    gameObject      = obj;
    message         = gameObject:GetComponent('LuaBehaviour');
    ButtonOK        = gameObject.transform:Find("BaseContent/ButtonClose")
    closeRoomBtn    = gameObject.transform:Find("ButtonCloseRoom")

	audioProces     = gameObject.transform:Find('view_Set/soundSetting/slider_audio/Label')
	musicProces     = gameObject.transform:Find('view_Set/soundSetting/slider_music/Label')
    slider_audio    = gameObject.transform:Find('view_Set/soundSetting/slider_audio'):GetComponent('UISlider');
	slider_music    = gameObject.transform:Find('view_Set/soundSetting/slider_music'):GetComponent('UISlider');

    ground1 = gameObject.transform:Find('view_Set/viewSetting/Backgrounds/1')
	ground2 = gameObject.transform:Find('view_Set/viewSetting/Backgrounds/2')
	ground3 = gameObject.transform:Find('view_Set/viewSetting/Backgrounds/3')
	ground4 = gameObject.transform:Find('view_Set/viewSetting/Backgrounds/4')

    normalPaiButton = gameObject.transform:Find('view_Set/viewSetting/cardColor/normalPai');
    superPaiButton = gameObject.transform:Find('view_Set/viewSetting/cardColor/superPai');
    WaiteCloseRoom = gameObject.transform:Find('WaiteCloseRoom')

    message:AddClick(ButtonOK.gameObject, this.OnClickHide)
    message:AddClick(closeRoomBtn.gameObject, this.OnClickCloseRoom)

    message:AddClick(normalPaiButton.gameObject, this.OnClickChangePaiSize)
    message:AddClick(superPaiButton.gameObject, this.OnClickChangePaiSize)

    EventDelegate.AddForLua(slider_audio.onChange, this.OnAudioSliderValueChange)
    EventDelegate.AddForLua(slider_music.onChange, this.OnMusicSliderValueChange)

    this.GetDistanceUI();

    AddChildsClick(message, gameObject.transform:Find('view_Set/viewSetting/Backgrounds'), this.OnBackgroundChange)
end

local logic = nil
local isGameing = false
function this.WhoShow(data)
    logic = data.logic
    isGameing= data.inGameing
    if gpsTool == nil then
        gpsTool = GPSTool.New(logic,roomData,DistanceObjs,PlayerUIObjs);
    end
    gpsTool:Refresh(logic,roomData);
    this.RefreshRule()
    this.SetPlayerInfo();
    -- print('roomData.dissolveLimit : '..tostring(roomData.setting.dissolveLimit))
    -- print("isGameing:"..tostring(isGameing))
    -- print(" panelInGame.myseflDissolveTimes:"..tostring(panelInGame.myseflDissolveTimes))
    -- print("roomData.setting.dissolveLimit == proxy_pb.FIVE_SECONDS:"..tostring(roomData.setting.dissolveLimit == proxy_pb.FIVE_SECONDS))
	if roomData.setting.dissolveLimit == proxy_pb.UNLIMITED then
		-- print('ssssssssssssssssssssssssssssssssssss')
    elseif roomData.setting.dissolveLimit == proxy_pb.FIVE_SECONDS and isGameing and panelInGame.myseflDissolveTimes > 0 then
		-- print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')
		this.ShowWaitClose()
    end
end

function this.OnEnable()
    bbtzPaiSize = UnityEngine.PlayerPrefs.GetInt("bbtzPaiSize",1);
    normalPaiButton:GetComponent("UIToggle"):Set(bbtzPaiSize == 1);
    superPaiButton:GetComponent("UIToggle"):Set(bbtzPaiSize == 2);
    this.RefreshSetting();
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
        DistanceObjs[i].disLabel = DistanceObjs[i].transform:Find("disLabel");
        DistanceObjs[i].gameObject = DistanceObjs[i].transform.gameObject;
    end
end


function this.OnClickChangePaiSize(go)
    print("OnClickChangePaiSize was called");
    if go == normalPaiButton.gameObject then
        bbtzPaiSize = 1;
    elseif go == superPaiButton.gameObject then
        bbtzPaiSize = 2;
    end
    UnityEngine.PlayerPrefs.SetInt('bbtzPaiSize', bbtzPaiSize);
    panelInGame.ChangePaiSize(bbtzPaiSize);
   
end



function this.RefreshRule()
    local ruleView = gameObject.transform:Find("view_rule")
    SetLabelText(ruleView:Find("WanFa/Label"), "半边天炸")
    SetLabelText(ruleView:Find("Rule/Label"), GetBBTZRuleString(roomData.setting))
end

function this.RefreshSetting()
    local ground = GetCurBackground()
    ground1:GetComponent('UIToggle'):Set(ground == 1)
	ground2:GetComponent('UIToggle'):Set(ground == 2)
	ground3:GetComponent('UIToggle'):Set(ground == 3)
	ground4:GetComponent('UIToggle'):Set(ground == 4)
end

function this.OnClickCloseRoom(go)
    AudioManager.Instance:PlayAudio('btn')
    if isGameing then
        if panelInGame.IsAllReaded() and roomData.setting.dissolveType == 3 then
           panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '该牌友群已设置不可自主解散房间，若有疑问请联系群主');
           PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
           return
       end
       print("解散房间")
       logic:LeaveRoomIfNeedClose(isGameing);
       panelInGame.myseflDissolveTimes = panelInGame.myseflDissolveTimes + 1;
   else
       this.OnClicButtonLeaveRoom()
   end
   PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClicButtonLeaveRoom(go)
	print("离开房间")
	logic:LeaveRoomIfNeedClose()
	panelInGame.fanHuiRoomNumber = nil
end

function this.OnClickHide(go)
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnBackgroundChange(go)
    local num = tonumber(go.gameObject.name)
    UnityEngine.PlayerPrefs.SetInt("GameBackground_BBTZ", num)
    EventDispatcher.Instance:DispatchEvent("GameBackgroundChange", num)
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

function this.Update()
end




function this.SetPlayerInfo()
    for i = 1, 4 do
        local player = logic:GetPlayerDataByUIIdex(i);
        local realIndex = this.GetUIIndex(i,roomData.setting.size);
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

--通过playerSize 将UI上的index转换成特殊的UI上的index
function this.GetUIIndex(index,playerSize)
    if playerSize == 3 then
        if index == 2 then
            return 3;
        elseif index == 3 then
            return 4;
        elseif index == 4 then
            return 2;
        else
            return index;
        end
    else
        return index;
    end
end


function this.OnApplicationFocus()

end


function this.Start()

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



