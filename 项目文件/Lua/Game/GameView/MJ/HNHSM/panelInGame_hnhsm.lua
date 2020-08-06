require("HNHSM_Logic");
require("HNHSM_EventBind");
local hnm_pb = require("hnm_pb");
local EventDispatcher = require("Event.EventDispatcher");

panelInGame_hnhsm   = {};
local this          = panelInGame_hnhsm;
local hnhsm_logic   = nil;
local message       = nil;
local gameObject    = nil;
this.myseflDissolveTimes = 0

function this.Awake( go )
    print("panelInGame_hnhsm.Awake");
    -- body
    gameObject  = go;
    message     = gameObject.transform:GetComponent('LuaBehaviour');
    
    
end

function this.Start(go)
    
end

function this.WhoShow(data)
    panelInGame.fanHuiRoomNumber = roomInfo.roomNumber;
    PanelManager.Instance:HideAllWindow();
    PanelManager.Instance:ShowWindow(gameObject.name);
    hnhsm_logic  = HNHSM_Logic.New(panelInGame_hnhsm,hnm_pb,proxy_pb.HNM,gameObject);
    hnhsm_logic:Init();
    --千万要放在logic实例化之后再改变背景呀
    local bgColor 	= UnityEngine.PlayerPrefs.GetInt('bgColor_hnhsm', 1);
    print("hnhsm_logic="..tostring(hnhsm_logic));
    this.ChooseBG(bgColor);
    
end

function this.OnEnable()
    panelInGame = panelInGame_hnhsm;
    panelInGame.needXiPai=false
    AudioManager.Instance:StopMusic();
    AudioManager.Instance:PlayMusic('nmmj_BGM', true);
    LuaManager.Instance:DoFile('effManger.lua');
    UnityEngine.Screen.sleepTimeout = UnityEngine.SleepTimeout.NeverSleep;
    
end

function this.OnApplicationFocus()

end

function this.SetMyAlpha(alpha)
    -- body
end

function this.Update()

end

function this.GetPlayerDataBySeat(seat)
    return hnhsm_logic:GetPlayerDataBySeat(seat)
end

function this.ChangePaiSize(hnhsmPaiSize)
    if hnhsm_logic then 
        hnhsm_logic:ChangePaiSize(hnhsmPaiSize);
    end
end

function this.GetCardTextName(plateIndex,cardTextIndex)
    return hnhsm_logic:GetUILayer():GetCardTextName(plateIndex,cardTextIndex);
end

function this.getColorCardName(name,colorIndex)
    return hnhsm_logic:GetUILayer():getColorCardName(name,colorIndex);
end

function this.GetCardColor()
    return hnhsm_logic:GetUILayer():getCardColor();
end

function this.SendMsg(chiIndex,OperationData)
    HNHSM_EventBind.SendMsg(chiIndex,OperationData);
end

function this.SetCardColor(colorNum)
    hnhsm_logic:GetUILayer():SetCardColor(colorNum);
end

function this.SetCardText(textNum)
    hnhsm_logic:GetUILayer():SetCardText(textNum);
end

function this.SetLanguage(languageNum)
    hnhsm_logic:GetUILayer():SetLanguage(languageNum);
end

function this.ChooseBG(bgNum)
    hnhsm_logic:GetUILayer():ChooseBG(bgNum);
end

function this.SetOutPlateType(outPlateType)
    hnhsm_logic:GetUILayer():SetOutPlateType(outPlateType);
end