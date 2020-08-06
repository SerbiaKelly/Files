require("class")
local TestTypeBase = class()
local panelCreateRoom_BBTZType = class(TestTypeBase)
panelCreateRoom_BBTZ = panelCreateRoom_BBTZType.New()


require("proxy_pb")
local json = require("json")
-- panelCreateRoom_BBTZ = {}
local this = panelCreateRoom_BBTZ;

local message;
local gameObject;
local payLabel;
local BBTZPanel

local BBTZ_View = {}
local BBTZ_Data = {}

function this.Init(go,messageObj)
    gameObject = go;
    message = messageObj;
    payLabel = message.transform:Find('diamond/pay_label')

    BBTZPanel = gameObject.transform:Find("table");
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
    BBTZ_View.ToggleTrusteeship2 = BBTZPanel.transform:Find('ToggleTrusteeship/Toggle2Minute')
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
    message:AddClick(BBTZ_View.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
    message:AddClick(BBTZ_View.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
    message:AddClick(BBTZ_View.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
    message:AddClick(BBTZ_View.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
    message:AddClick(BBTZ_View.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
    message:AddClick(BBTZ_View.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)

	message:AddClick(BBTZ_View.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(BBTZ_View.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end

function this.Refresh()
    this.GetDataPrefab()

    BBTZ_View.Round8Toggle:GetComponent("UIToggle"):Set(BBTZ_Data.rounds == 8)
    BBTZ_View.Round12Toggle:GetComponent("UIToggle"):Set(BBTZ_Data.rounds == 12)
    BBTZ_View.P2Toggle:GetComponent("UIToggle"):Set(BBTZ_Data.size == 2)
    BBTZ_View.P3Toggle:GetComponent("UIToggle"):Set(BBTZ_Data.size == 3)
    BBTZ_View.MasterPayToggle:GetComponent("UIToggle"):Set(BBTZ_Data.paymentType == 0)
    BBTZ_View.WinnerPayToggle:GetComponent("UIToggle"):Set(BBTZ_Data.paymentType == 2)
    BBTZ_View.Black3OutToggle:GetComponent("UIToggle"):Set(BBTZ_Data.san)
    BBTZ_View.RoundOutToggle:GetComponent("UIToggle"):Set(BBTZ_Data.san == false)
    BBTZ_View.BetweenColorToggle:GetComponent("UIToggle"):Set(BBTZ_Data.mask)
    BBTZ_View.ShowLeftCardToggle:GetComponent("UIToggle"):Set(BBTZ_Data.show)
    BBTZ_View.CanHammerToggle:GetComponent("UIToggle"):Set(BBTZ_Data.hammer)
    BBTZ_View.Can4n3Toggle:GetComponent("UIToggle"):Set(BBTZ_Data.betSan)

    BBTZ_View.KingToggle.gameObject:SetActive(true)
    BBTZ_View.KingToggle:GetComponent("UIToggle"):Set(BBTZ_Data.king)
    BBTZ_View.KingToggle.gameObject:SetActive(BBTZ_Data.size == 2)

    BBTZ_View.HelpSteepToggle.gameObject:SetActive(true)
    BBTZ_View.HelpSteepToggle:GetComponent("UIToggle"):Set(BBTZ_Data.steep)
    BBTZ_View.HelpSteepToggle.gameObject:SetActive(BBTZ_Data.size == 3)

    BBTZ_View.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(BBTZ_Data.trusteeship == 0)
    BBTZ_View.ToggleTrusteeship1:GetComponent('UIToggle'):Set(BBTZ_Data.trusteeship == 1)
    BBTZ_View.ToggleTrusteeship2:GetComponent('UIToggle'):Set(BBTZ_Data.trusteeship == 2)
    BBTZ_View.ToggleTrusteeship3:GetComponent('UIToggle'):Set(BBTZ_Data.trusteeship == 3)
    BBTZ_View.ToggleTrusteeship5:GetComponent('UIToggle'):Set(BBTZ_Data.trusteeship == 5)

	BBTZ_View.ToggleIPcheck.parent.gameObject:SetActive(BBTZ_Data.size > 2 and CONST.IPcheckOn)
    BBTZ_View.ToggleTrusteeshipOne.parent.gameObject:SetActive(BBTZ_Data.trusteeship ~= 0)
    BBTZ_View.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not BBTZ_Data.trusteeshipDissolve and BBTZ_Data.trusteeshipRound == 0)
    BBTZ_View.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(BBTZ_Data.trusteeshipDissolve == true)
    BBTZ_View.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(BBTZ_Data.trusteeshipRound == 3);
    BBTZ_View.ToggleTrusteeshipOne.parent.gameObject:SetActive(BBTZ_Data.trusteeship ~= 0)
	
	BBTZ_View.ToggleIPcheck:GetComponent('UIToggle'):Set(BBTZ_Data.openIp)
	BBTZ_View.ToggleGPScheck:GetComponent('UIToggle'):Set(BBTZ_Data.openGps)

    payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.PKBBTZ,nil,nil,nil)
end

function this.GetDataPrefab()
    BBTZ_Data.rounds                = UnityEngine.PlayerPrefs.GetInt("BBTZ_Rounds", 8)
    BBTZ_Data.size                  = UnityEngine.PlayerPrefs.GetInt("BBTZ_Size", 2)
    BBTZ_Data.paymentType           = UnityEngine.PlayerPrefs.GetInt("BBTZ_PayType", 0)
    BBTZ_Data.san                   = UnityEngine.PlayerPrefs.GetInt("BBTZ_San", 0) == 1
    BBTZ_Data.mask                  = UnityEngine.PlayerPrefs.GetInt("BBTZ_Mask", 1) == 1
    BBTZ_Data.show                  = UnityEngine.PlayerPrefs.GetInt("BBTZ_Show", 1) == 1
    BBTZ_Data.hammer                = UnityEngine.PlayerPrefs.GetInt("BBTZ_Hammer", 1) == 1
    BBTZ_Data.steep                 = UnityEngine.PlayerPrefs.GetInt("BBTZ_Steep", 0) == 1
    BBTZ_Data.betSan                = UnityEngine.PlayerPrefs.GetInt("BBTZ_BetSan", 0) == 1
    BBTZ_Data.king                  = UnityEngine.PlayerPrefs.GetInt("NewPKBBTZKing",0) == 1
    BBTZ_Data.trusteeship           = UnityEngine.PlayerPrefs.GetInt("NewPKBBTZtrusteeshipTime",0)
    BBTZ_Data.trusteeshipDissolve   = UnityEngine.PlayerPrefs.GetInt("NewPKBBTZtrusteeshipType",0) == 1;
    BBTZ_Data.trusteeshipRound      = UnityEngine.PlayerPrefs.GetInt("NewPKBBTZtrusteeshipRound",0)
	BBTZ_Data.openIp				=UnityEngine.PlayerPrefs.GetInt('BBTZ_checkIP', 0)==1
	BBTZ_Data.openGps				=UnityEngine.PlayerPrefs.GetInt('BBTZ_checkGPS', 0)==1
end

function this.OnClickRound(go)
    if go.gameObject == BBTZ_View.Round8Toggle.gameObject then
        BBTZ_Data.rounds = 8
    elseif go.gameObject == BBTZ_View.Round12Toggle.gameObject then
        BBTZ_Data.rounds = 12
    end
    UnityEngine.PlayerPrefs.SetInt("BBTZ_Rounds", BBTZ_Data.rounds)
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
    UnityEngine.PlayerPrefs.SetInt("BBTZ_Size", BBTZ_Data.size)
	BBTZPanel:GetComponent('UIGrid'):Reposition()
end

function this.OnClickPayType(go)
    if go.gameObject == BBTZ_View.MasterPayToggle.gameObject then
        BBTZ_Data.paymentType = 0
    elseif go.gameObject == BBTZ_View.WinnerPayToggle.gameObject then
        BBTZ_Data.paymentType = 2
    end
    UnityEngine.PlayerPrefs.SetInt("BBTZ_PayType", BBTZ_Data.paymentType)
end

function this.OnClickOutType(go)
    if go.gameObject == BBTZ_View.Black3OutToggle.gameObject then
        BBTZ_Data.san = true
    elseif go.gameObject == BBTZ_View.RoundOutToggle.gameObject then
        BBTZ_Data.san = false
    end
    UnityEngine.PlayerPrefs.SetInt("BBTZ_San", BBTZ_Data.san and 1 or 0)
end

function this.OnClickPlay(go)
    if go.gameObject == BBTZ_View.BetweenColorToggle.gameObject then
        BBTZ_Data.mask = BBTZ_View.BetweenColorToggle:GetComponent("UIToggle").value
        UnityEngine.PlayerPrefs.SetInt("BBTZ_Mask", BBTZ_Data.mask and 1 or 0)
    elseif go.gameObject == BBTZ_View.ShowLeftCardToggle.gameObject then
        BBTZ_Data.show = BBTZ_View.ShowLeftCardToggle:GetComponent("UIToggle").value
        UnityEngine.PlayerPrefs.SetInt("BBTZ_Show", BBTZ_Data.show and 1 or 0)
    elseif go.gameObject == BBTZ_View.CanHammerToggle.gameObject then
        BBTZ_Data.hammer = BBTZ_View.CanHammerToggle:GetComponent("UIToggle").value
        UnityEngine.PlayerPrefs.SetInt("BBTZ_Hammer", BBTZ_Data.hammer and 1 or 0)
    elseif go.gameObject == BBTZ_View.HelpSteepToggle.gameObject then
        BBTZ_Data.steep = BBTZ_View.HelpSteepToggle:GetComponent("UIToggle").value
        UnityEngine.PlayerPrefs.SetInt("BBTZ_Steep", BBTZ_Data.steep and 1 or 0)
    elseif go.gameObject == BBTZ_View.Can4n3Toggle.gameObject then
        BBTZ_Data.betSan = BBTZ_View.Can4n3Toggle:GetComponent("UIToggle").value
        UnityEngine.PlayerPrefs.SetInt("BBTZ_BetSan", BBTZ_Data.betSan and 1 or 0)
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
    elseif go == BBTZ_View.ToggleTrusteeship2.gameObject then
        BBTZ_Data.trusteeship = 2
    elseif go == BBTZ_View.ToggleTrusteeship3.gameObject then
        BBTZ_Data.trusteeship = 3
    elseif go == BBTZ_View.ToggleTrusteeship5.gameObject then
        BBTZ_Data.trusteeship = 5
    end
    UnityEngine.PlayerPrefs.SetInt('NewPKBBTZtrusteeshipTime', BBTZ_Data.trusteeship)
    BBTZ_View.ToggleTrusteeshipOne.parent.gameObject:SetActive(BBTZ_Data.trusteeship ~= 0)
	BBTZPanel:GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if go == BBTZ_View.ToggleTrusteeshipAll.gameObject then
        BBTZ_Data.trusteeshipDissolve = false
        BBTZ_Data.trusteeshipRound = 0;
    elseif go == BBTZ_View.ToggleTrusteeshipOne.gameObject then
        BBTZ_Data.trusteeshipDissolve = true
        BBTZ_Data.trusteeshipRound = 0;
    elseif go == BBTZ_View.ToggleTrusteeshipThree.gameObject then
        BBTZ_Data.trusteeshipDissolve = false;
        BBTZ_Data.trusteeshipRound = 3;
    end


    UnityEngine.PlayerPrefs.SetInt('NewPKBBTZtrusteeshipType',BBTZ_Data.trusteeshipDissolve and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewPKBBTZtrusteeshipRound',BBTZ_Data.trusteeshipRound);
end

function this.GetConfig()
    local moneyLess = false

    local body          = {}
    body.roomType       = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.PKBBTZ)
    body.rounds         = BBTZ_Data.rounds
    body.size           = BBTZ_Data.size
    body.paymentType    = BBTZ_Data.paymentType
    body.san            = BBTZ_Data.san
    body.mask           = BBTZ_Data.mask
    body.show           = BBTZ_Data.show
    body.hammer         = BBTZ_Data.hammer
    body.betSan         = BBTZ_Data.betSan
	body.openIp	 		= BBTZ_Data.openIp
	body.openGps 		= BBTZ_Data.openGps
	
    if BBTZ_Data.size == 3 then
        body.king       = true
        body.steep = BBTZ_Data.steep
    else
        body.steep      = false
        body.king = BBTZ_Data.king
    end
    body.trusteeship            = BBTZ_Data.trusteeship * 60
    body.trusteeshipDissolve    = BBTZ_Data.trusteeshipDissolve;
    body.trusteeshipRound       = BBTZ_Data.trusteeshipRound;
	if BBTZ_Data.size == 2 then
		body.openIp=false
		body.openGps=false
	end
	
    this.SetOtherPrefs();
    return moneyLess,body;

end


function this.SetOtherPrefs()
    UnityEngine.PlayerPrefs.SetInt('NewPKBBTZKing',BBTZ_Data.king and 1 or 0);
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if BBTZ_View.ToggleIPcheck.gameObject == go then
		BBTZ_Data.openIp = BBTZ_View.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('BBTZ_checkIP', BBTZ_Data.openIp and 1 or 0)
	elseif BBTZ_View.ToggleGPScheck.gameObject == go then
		BBTZ_Data.openGps = BBTZ_View.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('BBTZ_checkGPS', BBTZ_Data.openGps and 1 or 0)
	end
end


return this;