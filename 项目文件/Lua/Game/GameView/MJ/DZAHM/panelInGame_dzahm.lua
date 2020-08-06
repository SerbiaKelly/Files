require("DZAHM_Logic");
require("DZAHM_EventBind");
local dzm_pb = require("dzm_pb");
local EventDispatcher = require("Event.EventDispatcher");

panelInGame_dzahm   = {};
local this          = panelInGame_dzahm;
local dzahm_logic   = nil;
local message       = nil;
local gameObject    = nil;
this.myseflDissolveTimes = 0

function this.Awake( go )
    print("panelInGame_dzahm.Awake");
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
    dzahm_logic  = DZAHM_Logic.New(panelInGame_dzahm,dzm_pb,proxy_pb.DZM,gameObject);
    dzahm_logic:Init();
    --千万要放在logic实例化之后再改变背景呀
    local bgColor 	= UnityEngine.PlayerPrefs.GetInt('bgColor_dzahm', 1);
    print("dzahm_logic="..tostring(dzahm_logic));
    this.ChooseBG(bgColor);
    
end

function this.OnEnable()
    panelInGame = panelInGame_dzahm;
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
    return dzahm_logic:GetPlayerDataBySeat(seat)
end

function this.ChangePaiSize(dzahmPaiSize)
    if dzahm_logic then 
        dzahm_logic:ChangePaiSize(dzahmPaiSize);
    end
end

function this.GetCardTextName(plateIndex,cardTextIndex)
    return dzahm_logic:GetUILayer():GetCardTextName(plateIndex,cardTextIndex);
end

function this.getColorCardName(name,colorIndex)
    return dzahm_logic:GetUILayer():getColorCardName(name,colorIndex);
end

function this.GetCardColor()
    return dzahm_logic:GetUILayer():getCardColor();
end

function this.SendMsg(chiIndex,OperationData)
    DZAHM_EventBind.SendMsg(chiIndex,OperationData);
end

function this.SetCardColor(colorNum)
    dzahm_logic:GetUILayer():SetCardColor(colorNum);
end

function this.SetCardText(textNum)
    dzahm_logic:GetUILayer():SetCardText(textNum);
end

function this.SetLanguage(languageNum)
    dzahm_logic:GetUILayer():SetLanguage(languageNum);
end

function this.ChooseBG(bgNum)
    dzahm_logic:GetUILayer():ChooseBG(bgNum);
end

function this.SetOutPlateType(outPlateType)
    dzahm_logic:GetUILayer():SetOutPlateType(outPlateType);
end