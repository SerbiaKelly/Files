require("HNZZM_Logic");
require("HNZZM_EventBind");
local hnm_pb = require("hnm_pb");
local EventDispatcher = require("Event.EventDispatcher");

panelInGame_hnzzm   = {};
local this          = panelInGame_hnzzm;
local hnzzm_logic   = nil;
local message       = nil;
local gameObject    = nil;
this.myseflDissolveTimes = 0

function this.Awake( go )
    print("panelInGame_hnzzm.Awake");
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
    hnzzm_logic  = HNZZM_Logic.New(panelInGame_hnzzm,hnm_pb,proxy_pb.HNM,gameObject);
    hnzzm_logic:Init();
    --千万要放在logic实例化之后再改变背景呀
    local bgColor 	= UnityEngine.PlayerPrefs.GetInt('bgColor_hnzzm', 1);
    print("hnzzm_logic="..tostring(hnzzm_logic));
    this.ChooseBG(bgColor);
    
end

function this.OnEnable()
    panelInGame = panelInGame_hnzzm;
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
    return hnzzm_logic:GetPlayerDataBySeat(seat)
end

function this.ChangePaiSize(hnzzmPaiSize)
    if hnzzm_logic then 
        hnzzm_logic:ChangePaiSize(hnzzmPaiSize);
    end
end

function this.GetCardTextName(plateIndex,cardTextIndex)
    return hnzzm_logic:GetUILayer():GetCardTextName(plateIndex,cardTextIndex);
end

function this.getColorCardName(name,colorIndex)
    return hnzzm_logic:GetUILayer():getColorCardName(name,colorIndex);
end

function this.GetCardColor()
    return hnzzm_logic:GetUILayer():getCardColor();
end

function this.SendMsg(chiIndex,OperationData)
    HNZZM_EventBind.SendMsg(chiIndex,OperationData);
end

function this.SetCardColor(colorNum)
    hnzzm_logic:GetUILayer():SetCardColor(colorNum);
end

function this.SetCardText(textNum)
    hnzzm_logic:GetUILayer():SetCardText(textNum);
end

function this.SetLanguage(languageNum)
    hnzzm_logic:GetUILayer():SetLanguage(languageNum);
end

function this.ChooseBG(bgNum)
    hnzzm_logic:GetUILayer():ChooseBG(bgNum);
end

function this.SetOutPlateType(outPlateType)
    hnzzm_logic:GetUILayer():SetOutPlateType(outPlateType);
end