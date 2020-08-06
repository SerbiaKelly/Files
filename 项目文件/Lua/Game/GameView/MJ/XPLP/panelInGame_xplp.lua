require("GameMode.XPLP.XPLP_Logic");
require("XPLP_EventBind");
local xplp_pb = require("xplp_pb");
local EventDispatcher = require("Event.EventDispatcher");

panelInGame_xplp    = {};
local this          = panelInGame_xplp;
local XPLP_logic    = nil;
local message       = nil;
local gameObject    = nil;
this.myseflDissolveTimes = 0

function this.Awake( go )
    print("panelInGame_xplp.Awake");
    -- body
    gameObject  = go;
    message     = gameObject.transform:GetComponent('LuaBehaviour');
    
    
end

function this.Start(go)
    
end

function this.WhoShow(data)
    print("XPLP WhoShow--------------")
    panelInGame.fanHuiRoomNumber = roomInfo.roomNumber;
    PanelManager.Instance:HideAllWindow();
    PanelManager.Instance:ShowWindow(gameObject.name);
    XPLP_logic  = XPLP_Logic.New(panelInGame_xplp,xplp_pb,proxy_pb.XPLP,gameObject);
    XPLP_logic:Init();
    --千万要放在logic实例化之后再改变背景呀
    local bgColor 	= UnityEngine.PlayerPrefs.GetInt('bgColor_xplp', 1);
    this.ChooseBG(bgColor);
    
end

function this.OnEnable()
    panelInGame = panelInGame_xplp;
    panelInGame.needXiPai=false
    AudioManager.Instance:StopMusic();
    AudioManager.Instance:PlayMusic('ZD_Bgm', true);
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
    return XPLP_logic:GetPlayerDataBySeat(seat)
end

function this.ChangePaiSize(xplpPaiSize)
    if XPLP_logic then 
        XPLP_logic:ChangePaiSize(xplpPaiSize);
    end
end

function this.GetCardTextName(plateIndex,cardTextIndex)
    return XPLP_logic:GetUILayer():GetCardTextName(plateIndex,cardTextIndex);
end

function this.getColorCardName(name,colorIndex)
    return XPLP_logic:GetUILayer():getColorCardName(name,colorIndex);
end

function this.GetCardColor()
    return XPLP_logic:GetUILayer():getCardColor();
end

function this.SendMsg(chiIndex,OperationData)
    XPLP_EventBind.SendMsg(chiIndex,OperationData);
end

function this.SetCardColor(colorNum)
    XPLP_logic:GetUILayer():SetCardColor(colorNum);
end

function this.SetCardText(textNum)
    XPLP_logic:GetUILayer():SetCardText(textNum);
end

function this.SetLanguage(languageNum)
    XPLP_logic:GetUILayer():SetLanguage(languageNum);
end

function this.ChooseBG(bgNum)
    XPLP_logic:GetUILayer():ChooseBG(bgNum);
end

function this.SetOutPlateType(outPlateType)
    XPLP_logic:GetUILayer():SetOutPlateType(outPlateType);
end