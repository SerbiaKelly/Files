require("class")
local TestTypeBase = class()
local panelCreateBBTZSet_Type = class(TestTypeBase)
panelCreateBBTZSet = panelCreateBBTZSet_Type.New()


require("proxy_pb")
local json = require("json")
-- panelCreateRoom_BBTZ = {}
local this = panelCreateBBTZSet

local message;
local gameObject;
local BBTZPanel

local BBTZ_View = {}
local BBTZ_Data = {}

function this.Awake(go)
    gameObject = go;
    message = gameObject:GetComponent('LuaBehaviour');
    BBTZ_View.wanFaTitle = gameObject.transform:Find("title/Label");

    BBTZ_View.RuleButton = gameObject.transform:Find('RuleButton')

    BBTZPanel = gameObject.transform:Find("BBTZPanel/table")
    BBTZ_View.Round8Toggle = BBTZPanel.transform:Find("ToggleRound/ToggleRound8")
    BBTZ_View.Round12Toggle = BBTZPanel.transform:Find("ToggleRound/ToggleRound12")


    BBTZ_View.P2Toggle = BBTZPanel.transform:Find("TogglePeople/Toggle2P")
    BBTZ_View.P3Toggle = BBTZPanel.transform:Find("TogglePeople/Toggle3P")

    BBTZ_View.MasterPayToggle = BBTZPanel.transform:Find('TogglePayType/ToggleMasterPay');
    BBTZ_View.WinnerPayToggle = BBTZPanel.transform:Find('TogglePayType/ToggleWinnerPay');

    BBTZ_View.RoundOutToggle = BBTZPanel.transform:Find('ToggleOut/ToggleRandom');
    BBTZ_View.Black3OutToggle = BBTZPanel.transform:Find('ToggleOut/ToggleBlack3');

    BBTZ_View.BetweenColorToggle = BBTZPanel.transform:Find("TogglePlayType/ToggleBetweenColor")
    BBTZ_View.ShowLeftCardToggle = BBTZPanel.transform:Find("TogglePlayType/ToggleShowLeftCard")
    BBTZ_View.CanHammerToggle = BBTZPanel.transform:Find("TogglePlayType/ToggleCanHammer")
    BBTZ_View.Can4n3Toggle = BBTZPanel.transform:Find("TogglePlayType/Toggle4n3")
    BBTZ_View.HelpSteepToggle = BBTZPanel.transform:Find("TogglePlayType/ToggleHelpSteep")
    BBTZ_View.KingToggle = BBTZPanel.transform:Find("TogglePlayType/ToggleKing")

    BBTZ_View.ToggleTrusteeshipNo = BBTZPanel.transform:Find('ToggleTrusteeship/ToggleNo')
    BBTZ_View.ToggleTrusteeship1 = BBTZPanel.transform:Find('ToggleTrusteeship/Toggle1Minute')
    BBTZ_View.ToggleTrusteeship3 = BBTZPanel.transform:Find('ToggleTrusteeship/Toggle3Minute')
    BBTZ_View.ToggleTrusteeship5 = BBTZPanel.transform:Find('ToggleTrusteeship/Toggle5Minute')
    BBTZ_View.ToggleTrusteeshipAll = BBTZPanel.transform:Find('ToggleTrusteeshipType/ToggleAll')
    BBTZ_View.ToggleTrusteeshipOne = BBTZPanel.transform:Find('ToggleTrusteeshipType/ToggleOne')
    BBTZ_View.ToggleTrusteeshipThree = BBTZPanel.transform:Find('ToggleTrusteeshipType/ToggleThree')
	
	BBTZ_View.ToggleIPcheck = BBTZPanel:Find('PreventCheat/IPcheck')
	BBTZ_View.ToggleGPScheck = BBTZPanel:Find('PreventCheat/GPScheck')

    message:AddClick(BBTZ_View.Round8Toggle.gameObject, this.OnClickRound)
    message:AddClick(BBTZ_View.Round12Toggle.gameObject, this.OnClickRound)
    message:AddClick(BBTZ_View.P2Toggle.gameObject, this.OnClickPeople)
    message:AddClick(BBTZ_View.P3Toggle.gameObject, this.OnClickPeople)
    message:AddClick(BBTZ_View.MasterPayToggle.gameObject, this.OnClickPayType)
    message:AddClick(BBTZ_View.WinnerPayToggle.gameObject, this.OnClickPayType)
    message:AddClick(BBTZ_View.RoundOutToggle.gameObject, this.OnClickOutType)
    message:AddClick(BBTZ_View.Black3OutToggle.gameObject, this.OnClickOutType)
    message:AddClick(BBTZ_View.BetweenColorToggle.gameObject, this.OnClickPlay)
    message:AddClick(BBTZ_View.ShowLeftCardToggle.gameObject, this.OnClickPlay)
    message:AddClick(BBTZ_View.CanHammerToggle.gameObject, this.OnClickPlay)
    message:AddClick(BBTZ_View.Can4n3Toggle.gameObject, this.OnClickPlay)
    message:AddClick(BBTZ_View.HelpSteepToggle.gameObject, this.OnClickPlay)
    message:AddClick(BBTZ_View.KingToggle.gameObject, this.OnClickPlay)
    message:AddClick(BBTZ_View.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
    message:AddClick(BBTZ_View.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
    message:AddClick(BBTZ_View.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
    message:AddClick(BBTZ_View.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
    message:AddClick(BBTZ_View.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
    message:AddClick(BBTZ_View.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
    message:AddClick(BBTZ_View.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType);
    message:AddClick(BBTZ_View.RuleButton.gameObject, this.OnShowRuleInfo);
	
	message:AddClick(BBTZ_View.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(BBTZ_View.ToggleGPScheck.gameObject, this.OnClickPreventCheat)


    local closeBtn = gameObject.transform:Find("BaseContent/ButtonClose")
    message:AddClick(closeBtn.gameObject, function(go)
        PanelManager.Instance:HideWindow(gameObject.name)
    end)

    local buttonOK = gameObject.transform:Find("ButtonOK/Background")
    message:AddClick(buttonOK.gameObject, this.OnClickOk)
end

local optionData = {};
local curSelectPlay = {}

function this.WhoShow(data)
    if data.optionData ~= nil then
        optionData           = data.optionData;
        optionData.playId    = data.playId;
        optionData.ruleId    = data.ruleId;
    end

    this.OnEnableRefresh(data);

end

function this.OnEnableRefresh(data)
    local titleStr = ''
    curSelectPlay = {}
    if optionData.addRule or optionData.addPlay then
        titleStr = '当前玩法：'..'半边天炸'
        curSelectPlay = BBTZ_Data;
    elseif not optionData.addPlay and not optionData.addRule then
        curSelectPlay = json:decode(data.settings)
        titleStr = '当前规则：'..GetBBTZRuleString(curSelectPlay, false, false);

        if curSelectPlay.trusteeship == nil then
            curSelectPlay.trusteeship = 0
        end
        curSelectPlay.trusteeship = curSelectPlay.trusteeship / 60

        if curSelectPlay.trusteeshipDissolve == nil then
            curSelectPlay.trusteeshipDissolve = true
        end
        if curSelectPlay.trusteeshipRound == nil then
            curSelectPlay.trusteeshipRound = 0;
        end
    end

    BBTZ_View.wanFaTitle:GetComponent('UILabel').text = titleStr;
    this.SetPreSetting(curSelectPlay);
end

function this.SetPreSetting(settings)
    BBTZ_View.Round8Toggle:GetComponent("UIToggle"):Set(settings.rounds == 8)
    BBTZ_View.Round12Toggle:GetComponent("UIToggle"):Set(settings.rounds == 12)
    BBTZ_View.P2Toggle:GetComponent("UIToggle"):Set(settings.size == 2)
    BBTZ_View.P3Toggle:GetComponent("UIToggle"):Set(settings.size == 3)
    BBTZ_View.MasterPayToggle:GetComponent("UIToggle"):Set(settings.paymentType == 0)
    BBTZ_View.WinnerPayToggle:GetComponent("UIToggle"):Set(settings.paymentType == 2)
    BBTZ_View.Black3OutToggle:GetComponent("UIToggle"):Set(settings.san)
    BBTZ_View.RoundOutToggle:GetComponent("UIToggle"):Set(settings.san == false)
    BBTZ_View.BetweenColorToggle:GetComponent("UIToggle"):Set(settings.mask)
    BBTZ_View.ShowLeftCardToggle:GetComponent("UIToggle"):Set(settings.show)
    BBTZ_View.CanHammerToggle:GetComponent("UIToggle"):Set(settings.hammer)
    BBTZ_View.Can4n3Toggle:GetComponent("UIToggle"):Set(settings.betSan)

    BBTZ_View.KingToggle.gameObject:SetActive(true)
    BBTZ_View.KingToggle:GetComponent("UIToggle"):Set(settings.king)
    BBTZ_View.KingToggle.gameObject:SetActive(settings.size == 2)

    BBTZ_View.HelpSteepToggle.gameObject:SetActive(true)
    BBTZ_View.HelpSteepToggle:GetComponent("UIToggle"):Set(settings.steep)
    BBTZ_View.HelpSteepToggle.gameObject:SetActive(settings.size == 3)

    BBTZ_View.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(settings.trusteeship == 0)
    BBTZ_View.ToggleTrusteeship1:GetComponent('UIToggle'):Set(settings.trusteeship == 1)
    BBTZ_View.ToggleTrusteeship3:GetComponent('UIToggle'):Set(settings.trusteeship == 3)
    BBTZ_View.ToggleTrusteeship5:GetComponent('UIToggle'):Set(settings.trusteeship == 5)

    BBTZ_View.ToggleTrusteeshipOne.parent.gameObject:SetActive(settings.trusteeship ~= 0)
    BBTZ_View.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not settings.trusteeshipDissolve and settings.trusteeshipRound == 0)
    BBTZ_View.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(settings.trusteeshipDissolve == true)
    BBTZ_View.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(settings.trusteeshipRound == 3);
    BBTZ_View.ToggleTrusteeshipOne.parent.gameObject:SetActive(settings.trusteeship ~= 0)
	
	BBTZ_View.ToggleIPcheck.parent.gameObject:SetActive(settings.size > 2 and CONST.IPcheckOn)
	BBTZ_View.ToggleIPcheck:GetComponent('UIToggle'):Set(settings.openIp)
	BBTZ_View.ToggleGPScheck:GetComponent('UIToggle'):Set(settings.openGps)
end

function this.OnEnable()
    this.GetDataPrefab()
end

function this.GetDataPrefab()
    BBTZ_Data.rounds                = 8
    BBTZ_Data.size                  = 2
    BBTZ_Data.paymentType           = 0
    BBTZ_Data.san                   = false
    BBTZ_Data.mask                  = true
    BBTZ_Data.show                  = true
    BBTZ_Data.hammer                = true
    BBTZ_Data.steep                 = false
    BBTZ_Data.betSan                = false
    BBTZ_Data.king                  = false
    BBTZ_Data.trusteeship           = 0
    BBTZ_Data.trusteeshipDissolve   = false
    BBTZ_Data.trusteeshipRound      = 0
	BBTZ_Data.openIp				= false
	BBTZ_Data.openGps				= false
end

function this.OnClickRound(go)
    if go.gameObject == BBTZ_View.Round8Toggle.gameObject then
        BBTZ_Data.rounds = 8
    elseif go.gameObject == BBTZ_View.Round12Toggle.gameObject then
        BBTZ_Data.rounds = 12
    end
end

function this.OnClickPeople(go)
    if go.gameObject == BBTZ_View.P2Toggle.gameObject then
        BBTZ_Data.size = 2
    elseif go.gameObject == BBTZ_View.P3Toggle.gameObject then
        BBTZ_Data.size = 3
    end

	BBTZ_View.ToggleIPcheck.parent.gameObject:SetActive(BBTZ_Data.size > 2 and CONST.IPcheckOn)
    BBTZ_View.KingToggle.gameObject:SetActive(BBTZ_Data.size == 2)
    BBTZ_View.HelpSteepToggle.gameObject:SetActive(BBTZ_Data.size == 3)
	BBTZPanel:GetComponent('UIGrid'):Reposition()
end

function this.OnClickPayType(go)
    if go.gameObject == BBTZ_View.MasterPayToggle.gameObject then
        BBTZ_Data.paymentType = 0
    elseif go.gameObject == BBTZ_View.WinnerPayToggle.gameObject then
        BBTZ_Data.paymentType = 2
    end
end

function this.OnClickOutType(go)
    if go.gameObject == BBTZ_View.Black3OutToggle.gameObject then
        BBTZ_Data.san = true
    elseif go.gameObject == BBTZ_View.RoundOutToggle.gameObject then
        BBTZ_Data.san = false
    end
end

function this.OnClickPlay(go)
    if go.gameObject == BBTZ_View.BetweenColorToggle.gameObject then
        BBTZ_Data.mask = BBTZ_View.BetweenColorToggle:GetComponent("UIToggle").value
    elseif go.gameObject == BBTZ_View.ShowLeftCardToggle.gameObject then
        BBTZ_Data.show = BBTZ_View.ShowLeftCardToggle:GetComponent("UIToggle").value
    elseif go.gameObject == BBTZ_View.CanHammerToggle.gameObject then
        BBTZ_Data.hammer = BBTZ_View.CanHammerToggle:GetComponent("UIToggle").value
    elseif go.gameObject == BBTZ_View.HelpSteepToggle.gameObject then
        BBTZ_Data.steep = BBTZ_View.HelpSteepToggle:GetComponent("UIToggle").value
    elseif go.gameObject == BBTZ_View.Can4n3Toggle.gameObject then
        BBTZ_Data.betSan = BBTZ_View.Can4n3Toggle:GetComponent("UIToggle").value
    elseif go.gameObject == BBTZ_View.KingToggle.gameObject then
        BBTZ_Data.king = BBTZ_View.KingToggle:GetComponent("UIToggle").value
    end
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if go == BBTZ_View.ToggleTrusteeshipNo.gameObject then
        BBTZ_Data.trusteeship = 0
    elseif go == BBTZ_View.ToggleTrusteeship1.gameObject then
        BBTZ_Data.trusteeship = 1
    elseif go == BBTZ_View.ToggleTrusteeship3.gameObject then
        BBTZ_Data.trusteeship = 3
    elseif go == BBTZ_View.ToggleTrusteeship5.gameObject then
        BBTZ_Data.trusteeship = 5
    end
    BBTZ_View.ToggleTrusteeshipOne.parent.gameObject:SetActive(BBTZ_Data.trusteeship ~= 0)
	BBTZPanel:GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if go == BBTZ_View.ToggleTrusteeshipAll.gameObject then
        BBTZ_Data.trusteeshipDissolve = false;
        BBTZ_Data.trusteeshipRound = 0;
    elseif go == BBTZ_View.ToggleTrusteeshipOne.gameObject then
        BBTZ_Data.trusteeshipDissolve = true;
        BBTZ_Data.trusteeshipRound = 0;
    elseif go == BBTZ_View.ToggleTrusteeshipThree.gameObject then
        BBTZ_Data.trusteeshipDissolve = false;
        BBTZ_Data.trusteeshipRound = 3;
    end
end

function this.OnApplicationFocus()

end

function this.OnClickOk(go)

    if optionData.addPlay == true then
        optionData.currentOption = "addPlay";
        local msg           = Message.New();
        msg.type            = proxy_pb.CREATE_CLUB_PLAY;
        local bigbody       = proxy_pb.PCreateClubPlay();
        bigbody.gameType    = proxy_pb.BBTZ
        bigbody.roomType    = proxy_pb.PKBBTZ;
        bigbody.name        = '半边天炸';
        bigbody.clubId      = panelClub.clubInfo.clubId;
        local settings      = this.GetSettings();
        bigbody.settings    = json:encode(settings);
        msg.body            = bigbody:SerializeToString();
        SendProxyMessage(msg, this.OnCreateClubPlayResult);
        print('add_BBTZ_Play');

    elseif optionData.addRule == true then
        optionData.currentOption = "addRule";
        local msg           = Message.New();
        msg.type            = proxy_pb.CREATE_PLAY_RULE;
        local bigbody       = proxy_pb.PCreatePlayRule();
        bigbody.gameType    = proxy_pb.BBTZ
        bigbody.playId      = optionData.playId;
        bigbody.clubId      = panelClub.clubInfo.clubId;
        local settings      = this.GetSettings();
        bigbody.settings    = json:encode(settings);
        msg.body            = bigbody:SerializeToString();
        SendProxyMessage(msg, this.OnCreateClubPlayResult);
        print('add_BBTZ_Rule');
    else
        optionData.currentOption    = "updateRule";
        local msg                   = Message.New();
        msg.type                    = proxy_pb.UPDATE_PLAY_RULE;
        local bigbody               = proxy_pb.PUpdatePlayRule();
        bigbody.playId              = optionData.playId;
        bigbody.ruleId              = optionData.ruleId;
        bigbody.clubId              = panelClub.clubInfo.clubId;
        local settings              = this.GetSettings();
        bigbody.settings            = json:encode(settings);
        msg.body                    = bigbody:SerializeToString();
        SendProxyMessage(msg, this.OnCreateClubPlayResult);
        print('update_BBTZ_Rule')
    end
end

function this.GetSettings()
    local settings          = {}
    settings.rounds         = BBTZ_Data.rounds
    settings.size           = BBTZ_Data.size
    settings.paymentType    = 3
    settings.san            = BBTZ_Data.san
    settings.mask           = BBTZ_Data.mask
    settings.show           = BBTZ_Data.show
    settings.hammer         = BBTZ_Data.hammer
    settings.betSan         = BBTZ_Data.betSan
    if BBTZ_Data.size == 3 then
        settings.king   = true
        settings.steep  = BBTZ_Data.steep
    else
        settings.steep  = false
        settings.king   = BBTZ_Data.king
    end
    settings.trusteeship            = BBTZ_Data.trusteeship * 60
    settings.trusteeshipDissolve    = BBTZ_Data.trusteeshipDissolve
    settings.trusteeshipRound       = BBTZ_Data.trusteeshipRound
	settings.openIp	 = BBTZ_Data.openIp
	settings.openGps = BBTZ_Data.openGps
	if settings.size == 2 then
		settings.openIp=false
		settings.openGps=false
	end
    print("------------------------------------------");
    print_r(settings)

    return settings;
end

function this.OnCreateRoomResult(msg)
    print('OnCreateRoomResult')
    local b = proxy_pb.RCreateRoom();
    b:ParseFromString(msg.body);
    roomInfo.host = b.host
    roomInfo.port = b.port
    roomInfo.token = b.token
    roomInfo.roomNumber = b.roomNumber

    PanelManager.Instance:ShowWindow("panelInGame_bbtz", gameObject.name)
end

function this.Update()
end

function this.OnCreateClubPlayResult(msg)
    PanelManager.Instance:HideWindow(gameObject.name);
    if optionData.currentOption == "addPlay" then
        panelMessageTip.SetParamers('添加玩法成功', 1.5);
    elseif optionData.currentOption == "addRule" then
        panelMessageTip.SetParamers('添加规则成功', 1.5);
    elseif optionData.currentOption == "updateRule" then
        panelMessageTip.SetParamers('更新规则成功', 1.5);
    end

    PanelManager.Instance:ShowWindow('panelMessageTip');
end

function this.OnShowRuleInfo(go)
    PanelManager.Instance:ShowWindow('panelHelp', 37);
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if BBTZ_View.ToggleIPcheck.gameObject == go then
		BBTZ_Data.openIp = BBTZ_View.ToggleIPcheck:GetComponent('UIToggle').value 
	elseif BBTZ_View.ToggleGPScheck.gameObject == go then
		BBTZ_Data.openGps = BBTZ_View.ToggleGPScheck:GetComponent('UIToggle').value
	end
end