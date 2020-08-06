require("class");
local TestTypeBase              = class();
local panelCreateRoom_XPLPType  = class(TestTypeBase);
subWinCreate_XPLP               = panelCreateRoom_XPLPType.New();
require("proxy_pb")
local json = require("json")
local this = subWinCreate_XPLP;
local message;
local gameObject;
local XPLP_View = {}
local XPLP_Data = {}
local payLabel;

function this.Init(go,messageObj)
    print("Awake was called");
    gameObject                                 = go;
	message                                    = messageObj;
    payLabel 							       = message.transform:Find('diamond/pay_label')
    local XPLPPanel                            = gameObject.transform:Find("table");
    --局数选择         
    XPLP_View.Round6Toggle                     = XPLPPanel.transform:Find("ToggleRoundGroup/ToggleRound6");
    XPLP_View.Round8Toggle                     = XPLPPanel.transform:Find("ToggleRoundGroup/ToggleRound8");
    XPLP_View.Round12Toggle                    = XPLPPanel.transform:Find("ToggleRoundGroup/ToggleRound12");
    XPLP_View.Round16Toggle                    = XPLPPanel.transform:Find("ToggleRoundGroup1/ToggleRound16");
    --人数选择             
    XPLP_View.P2Toggle                         = XPLPPanel.transform:Find("TogglePeopleGroup/Toggle2P");
    XPLP_View.P3Toggle                         = XPLPPanel.transform:Find("TogglePeopleGroup/Toggle3P");
    XPLP_View.P4Toggle                         = XPLPPanel.transform:Find("TogglePeopleGroup/Toggle4P");
    --开房模式             
    XPLP_View.MasterPayToggle                  = XPLPPanel.transform:Find('TogglePayTypeGroup/ToggleMasterPay');
    XPLP_View.WinnerPayToggle                  = XPLPPanel.transform:Find('TogglePayTypeGroup/ToggleWinnerPay');
    --坐庄规则     
    XPLP_View.ToggleFirstRandomBanker          = XPLPPanel.transform:Find('ToggleBankTypeGroup/ToggleFirstRandomBanker');
    XPLP_View.ToggleFirstIsBanker              = XPLPPanel.transform:Find('ToggleBankTypeGroup/ToggleFirstIsBanker');
    --胡牌方式             
    XPLP_View.ToggleMustSelfMo                 = XPLPPanel.transform:Find('ToggleWinTypeGroup/ToggleMustSelfMo');
    XPLP_View.ToggleCanDianPao                 = XPLPPanel.transform:Find('ToggleWinTypeGroup/ToggleCanDianPao');
    --个性玩法             
    XPLP_View.ToggleWithFlower                 = XPLPPanel.transform:Find("TogglePlayTypeGroup/ToggleWithFlower");
    XPLP_View.ToggleZhuangXian                 = XPLPPanel.transform:Find("TogglePlayTypeGroup/ToggleZhuangXian");
    XPLP_View.ToggleYHBH                       = XPLPPanel.transform:Find("TogglePlayTypeGroup/ToggleYHBH");
    XPLP_View.TogglePengThenNoSame             = XPLPPanel.transform:Find("TogglePlayTypeGroup1/TogglePengThenNoSame");
    XPLP_View.ToggleCPNeedSure                 = XPLPPanel.transform:Find("TogglePlayTypeGroup1/ToggleCPNeedSure");
    XPLP_View.ToggleNoChi                      = XPLPPanel.transform:Find("TogglePlayTypeGroup1/ToggleNoChi");
    XPLP_View.ToggleChiThenNoSame              = XPLPPanel.transform:Find("TogglePlayTypeGroup2/ToggleChiThenNoSame");
    XPLP_View.ToggleGuChou                     = XPLPPanel.transform:Find("TogglePlayTypeGroup2/ToggleGuChou");
    --冲分选择     
    XPLP_View.ToggleNoRushScore                = XPLPPanel.transform:Find("ToggleRushScoreTypeGroup/ToggleNoRushScore");
    XPLP_View.ToggleCanRushScore               = XPLPPanel.transform:Find("ToggleRushScoreTypeGroup/ToggleCanRushScore");
    XPLP_View.ToggleMustRushScore              = XPLPPanel.transform:Find("ToggleRushScoreTypeGroup/ToggleMustRushScore");
    XPLP_View.ToggleMustThenCanRushScore       = XPLPPanel.transform:Find("ToggleRushScoreTypeGroup1/ToggleMustThenCanRushScore");
    XPLP_View.ToggleRushWithUpButDownScore     = XPLPPanel.transform:Find("ToggleRushScoreTypeGroup1/ToggleRushWithUpButDownScore");
    --冲分分数 
    XPLP_View.ToggleRush1234                   = XPLPPanel.transform:Find("ToggleRushTypeGroup/ToggleRush1234");
    XPLP_View.ToggleRush2468                   = XPLPPanel.transform:Find("ToggleRushTypeGroup/ToggleRush2468");
    --冲分分数选择 
    XPLP_View.RushScore1                       = XPLPPanel.transform:Find("ToggleRushScoreGroup/RushScore1");
    XPLP_View.RushScore2                       = XPLPPanel.transform:Find("ToggleRushScoreGroup/RushScore2");
    XPLP_View.RushScore3                       = XPLPPanel.transform:Find("ToggleRushScoreGroup/RushScore3");
    XPLP_View.RushScore4                       = XPLPPanel.transform:Find("ToggleRushScoreGroup/RushScore4");
    --算分方式 
    XPLP_View.ToggleRushAdd                    = XPLPPanel.transform:Find("ToggleCaculateGroup/ToggleRushAdd");
    XPLP_View.ToggleRushMulti                  = XPLPPanel.transform:Find("ToggleCaculateGroup/ToggleRushMulti");
    --是否抽牌 
    XPLP_View.ToggleNoExtract                  = XPLPPanel.transform:Find("ToggleExtractPlateGroup/ToggleNoExtract");
    XPLP_View.ToggleExtract22                  = XPLPPanel.transform:Find("ToggleExtractPlateGroup/ToggleExtract22");
    XPLP_View.ToggleExtract32                  = XPLPPanel.transform:Find("ToggleExtractPlateGroup/ToggleExtract32");
    --翻倍选择 
    XPLP_View.ToggleNoDouble                   = XPLPPanel.transform:Find("ToggleDoubleChooseGroup/ToggleNoDouble");
    XPLP_View.ToggleDouble                     = XPLPPanel.transform:Find("ToggleDoubleChooseGroup/ToggleDouble");
    XPLP_View.ToggleDoubleScoreTxt             = XPLPPanel.transform:Find("ToggleDoubleChooseGroup/DoubleWhenLess/Value")
	XPLP_View.ToggleDoubleAddButton            = XPLPPanel.transform:Find("ToggleDoubleChooseGroup/DoubleWhenLess/AddButton")
	XPLP_View.ToggleDoubleSubtractButton       = XPLPPanel.transform:Find("ToggleDoubleChooseGroup/DoubleWhenLess/SubtractButton")
    --倍数选
    XPLP_View.Toggle2Times                     = XPLPPanel.transform:Find("ToggleTimesofDoubleGroup/Toggle2Times");
    XPLP_View.Toggle3Times                     = XPLPPanel.transform:Find("ToggleTimesofDoubleGroup/Toggle3Times");
    XPLP_View.Toggle4Times                     = XPLPPanel.transform:Find("ToggleTimesofDoubleGroup/Toggle4Times");
     --2人结算低于多少分加分   
    XPLP_View.ToggleSettlementScoreSelect      = XPLPPanel:Find('settlementScore/select')
	XPLP_View.ToggleFewerScoreTxt              = XPLPPanel:Find('settlementScore/fewerValue/Value')
	XPLP_View.ToggleFewerAddButton             = XPLPPanel:Find('settlementScore/fewerValue/AddButton')
	XPLP_View.ToggleFewerSubtractButton        = XPLPPanel:Find('settlementScore/fewerValue/SubtractButton')
	XPLP_View.ToggleAddScoreTxt                = XPLPPanel:Find('settlementScore/addValue/Value')
	XPLP_View.ToggleAddAddButton               = XPLPPanel:Find('settlementScore/addValue/AddButton')
    XPLP_View.ToggleAddSubtractButton          = XPLPPanel:Find('settlementScore/addValue/SubtractButton')

    --底分选
    XPLP_View.ToggleBaseScoreTxt               = XPLPPanel:Find('BaseScroeGroup/scoreValue/Value')
	XPLP_View.ToggleBaseScroeAddButton         = XPLPPanel:Find('BaseScroeGroup/scoreValue/AddButton')
	XPLP_View.ToggleBaseScroeSubtractButton    = XPLPPanel:Find('BaseScroeGroup/scoreValue/SubtractButton')
    XPLP_View.ToggleTrusteeshipNo              = XPLPPanel.transform:Find('ToggleTrusteeship/ToggleNo');
	XPLP_View.ToggleTrusteeship1               = XPLPPanel.transform:Find('ToggleTrusteeship/Toggle1Minute');
	XPLP_View.ToggleTrusteeship2               = XPLPPanel.transform:Find('ToggleTrusteeship/Toggle2Minute');
	XPLP_View.ToggleTrusteeship3               = XPLPPanel.transform:Find('ToggleTrusteeship/Toggle3Minute');
	XPLP_View.ToggleTrusteeship5               = XPLPPanel.transform:Find('ToggleTrusteeship1/Toggle5Minute');
	XPLP_View.ToggleTrusteeshipAll             = XPLPPanel.transform:Find('ToggleTrusteeshipType/ToggleAll');
    XPLP_View.ToggleTrusteeshipOne             = XPLPPanel.transform:Find('ToggleTrusteeshipType/ToggleOne');
    XPLP_View.ToggleTrusteeshipThree           = XPLPPanel.transform:Find('ToggleTrusteeshipType/ToggleThree');
    XPLP_View.ToggleIPcheck                    = XPLPPanel.transform:Find('PreventCheat/IPcheck')
	XPLP_View.ToggleGPScheck                   = XPLPPanel.transform:Find('PreventCheat/GPScheck')

    message:AddClick(XPLP_View.Round6Toggle.gameObject,                 this.OnClickRound);
    message:AddClick(XPLP_View.Round8Toggle.gameObject,                 this.OnClickRound);
    message:AddClick(XPLP_View.Round12Toggle.gameObject,                this.OnClickRound);
    message:AddClick(XPLP_View.Round16Toggle.gameObject,                this.OnClickRound);

    message:AddClick(XPLP_View.P2Toggle.gameObject,                     this.OnClickPeople);
    message:AddClick(XPLP_View.P3Toggle.gameObject,                     this.OnClickPeople);
    message:AddClick(XPLP_View.P4Toggle.gameObject,                     this.OnClickPeople);

    message:AddClick(XPLP_View.MasterPayToggle.gameObject,              this.OnClickPayType);
    message:AddClick(XPLP_View.WinnerPayToggle.gameObject,              this.OnClickPayType);

    message:AddClick(XPLP_View.ToggleFirstIsBanker.gameObject,          this.OnClickBankerType);
    message:AddClick(XPLP_View.ToggleFirstRandomBanker.gameObject,      this.OnClickBankerType);

    message:AddClick(XPLP_View.ToggleMustSelfMo.gameObject,             this.OnClikWinType);
    message:AddClick(XPLP_View.ToggleCanDianPao.gameObject,             this.OnClikWinType);

    message:AddClick(XPLP_View.ToggleNoChi.gameObject,                  this.OnClikNoChi);

    message:AddClick(XPLP_View.ToggleNoRushScore.gameObject,            this.OnClickRushScoreType);
    message:AddClick(XPLP_View.ToggleCanRushScore.gameObject,           this.OnClickRushScoreType);
    message:AddClick(XPLP_View.ToggleMustRushScore.gameObject,          this.OnClickRushScoreType);
    message:AddClick(XPLP_View.ToggleMustThenCanRushScore.gameObject,   this.OnClickRushScoreType);
    message:AddClick(XPLP_View.ToggleRushWithUpButDownScore.gameObject, this.OnClickRushScoreType);

    message:AddClick(XPLP_View.ToggleRush1234.gameObject,               this.OnClickRushType);
    message:AddClick(XPLP_View.ToggleRush2468.gameObject,               this.OnClickRushType);

    message:AddClick(XPLP_View.RushScore1.gameObject,                   this.OnClickRushScore);
    message:AddClick(XPLP_View.RushScore2.gameObject,                   this.OnClickRushScore);
    message:AddClick(XPLP_View.RushScore3.gameObject,                   this.OnClickRushScore);
    message:AddClick(XPLP_View.RushScore4.gameObject,                   this.OnClickRushScore);

    message:AddClick(XPLP_View.ToggleRushAdd.gameObject,                this.OnClickCalculateType);
    message:AddClick(XPLP_View.ToggleRushMulti.gameObject,              this.OnClickCalculateType);

    message:AddClick(XPLP_View.ToggleNoExtract.gameObject,              this.OnClickIfExtractPlate);
    message:AddClick(XPLP_View.ToggleExtract22.gameObject,              this.OnClickIfExtractPlate);
    message:AddClick(XPLP_View.ToggleExtract32.gameObject,              this.OnClickIfExtractPlate);

    message:AddClick(XPLP_View.ToggleNoDouble.gameObject,               this.OnClickDoubleChoose);
    message:AddClick(XPLP_View.ToggleDouble.gameObject,                 this.OnClickDoubleChoose);

    message:AddClick(XPLP_View.ToggleDoubleAddButton.gameObject,        this.OnClickDoubleChangeChoose);
    message:AddClick(XPLP_View.ToggleDoubleSubtractButton.gameObject,   this.OnClickDoubleChangeChoose);

    message:AddClick(XPLP_View.Toggle2Times.gameObject,                 this.OnClickDoubleTimes);
    message:AddClick(XPLP_View.Toggle3Times.gameObject,                 this.OnClickDoubleTimes);
    message:AddClick(XPLP_View.Toggle4Times.gameObject,                 this.OnClickDoubleTimes);


    message:AddClick(XPLP_View.ToggleSettlementScoreSelect.gameObject,  this.OnClickSettlementScoreSelect)
	message:AddClick(XPLP_View.ToggleFewerAddButton.gameObject,         this.OnClickFewerButton)
	message:AddClick(XPLP_View.ToggleFewerSubtractButton.gameObject,    this.OnClickFewerButton)
	message:AddClick(XPLP_View.ToggleAddAddButton.gameObject,           this.OnClickAddButton)
    message:AddClick(XPLP_View.ToggleAddSubtractButton.gameObject,      this.OnClickAddButton)
    
    message:AddClick(XPLP_View.ToggleBaseScroeAddButton.gameObject,     this.OnClickBaseScoreButton);
	message:AddClick(XPLP_View.ToggleBaseScroeSubtractButton.gameObject,this.OnClickBaseScoreButton);
    
 
    message:AddClick(XPLP_View.ToggleTrusteeshipNo.gameObject,          this.OnClickTrusteeshipTime)
	message:AddClick(XPLP_View.ToggleTrusteeship1.gameObject,           this.OnClickTrusteeshipTime)
	message:AddClick(XPLP_View.ToggleTrusteeship2.gameObject,           this.OnClickTrusteeshipTime)
	message:AddClick(XPLP_View.ToggleTrusteeship3.gameObject,           this.OnClickTrusteeshipTime)
	message:AddClick(XPLP_View.ToggleTrusteeship5.gameObject,           this.OnClickTrusteeshipTime)
	message:AddClick(XPLP_View.ToggleTrusteeshipOne.gameObject,         this.OnClickTrusteeshipType)
    message:AddClick(XPLP_View.ToggleTrusteeshipAll.gameObject,         this.OnClickTrusteeshipType)
    message:AddClick(XPLP_View.ToggleTrusteeshipThree.gameObject,       this.OnClickTrusteeshipType)
    message:AddClick(XPLP_View.ToggleIPcheck.gameObject,                this.OnClickPreventCheat)
	message:AddClick(XPLP_View.ToggleGPScheck.gameObject,               this.OnClickPreventCheat)
end


function this.Refresh()

    print("OnEnable was called");
    this.GetDataPrefab()

    XPLP_View.Round6Toggle:GetComponent("UIToggle"):Set(XPLP_Data.rounds == 6);
    XPLP_View.Round8Toggle:GetComponent("UIToggle"):Set(XPLP_Data.rounds == 8);
    XPLP_View.Round12Toggle:GetComponent("UIToggle"):Set(XPLP_Data.rounds == 12);
    XPLP_View.Round16Toggle:GetComponent("UIToggle"):Set(XPLP_Data.rounds == 16);

    XPLP_View.P2Toggle:GetComponent("UIToggle"):Set(XPLP_Data.size == 2);
    XPLP_View.P3Toggle:GetComponent("UIToggle"):Set(XPLP_Data.size == 3);
    XPLP_View.P4Toggle:GetComponent("UIToggle"):Set(XPLP_Data.size == 4);
    print("XPLP_Data.paymentType="..XPLP_Data.paymentType);
    XPLP_View.MasterPayToggle:GetComponent("UIToggle"):Set(XPLP_Data.paymentType == 0)
    XPLP_View.WinnerPayToggle:GetComponent("UIToggle"):Set(XPLP_Data.paymentType == 2)

    XPLP_View.ToggleFirstRandomBanker:GetComponent("UIToggle"):Set(XPLP_Data.bankerRule);
    XPLP_View.ToggleFirstIsBanker:GetComponent("UIToggle"):Set(not XPLP_Data.bankerRule);
 
    XPLP_View.ToggleMustSelfMo:GetComponent("UIToggle"):Set(XPLP_Data.huPattern);
    XPLP_View.ToggleCanDianPao:GetComponent("UIToggle"):Set(not XPLP_Data.huPattern);
    --个性玩法
    XPLP_View.ToggleWithFlower:GetComponent("UIToggle"):Set(XPLP_Data.takeMask);
    XPLP_View.ToggleZhuangXian:GetComponent("UIToggle"):Set(XPLP_Data.bankerPlayer);
    XPLP_View.ToggleYHBH:GetComponent("UIToggle"):Set(XPLP_Data.huMust);
    XPLP_View.TogglePengThenNoSame:GetComponent("UIToggle"):Set(XPLP_Data.pengNoChu);
    XPLP_View.ToggleCPNeedSure:GetComponent("UIToggle"):Set(XPLP_Data.operateConfirm);
    XPLP_View.ToggleNoChi:GetComponent("UIToggle"):Set(XPLP_Data.chiNo);
    XPLP_View.ToggleChiThenNoSame:GetComponent("UIToggle"):Set(XPLP_Data.chiNoChu and (not XPLP_Data.chiNo));
    XPLP_View.ToggleGuChou:GetComponent("UIToggle"):Set(XPLP_Data.guChou and XPLP_Data.size > 2);
    XPLP_View.ToggleGuChou.gameObject:SetActive(XPLP_Data.size > 2);
    XPLP_View.ToggleChiThenNoSame.gameObject:SetActive(not XPLP_Data.chiNo);
    --冲分选择
    XPLP_View.ToggleNoRushScore:GetComponent("UIToggle"):Set(XPLP_Data.chong == 0);
    XPLP_View.ToggleCanRushScore:GetComponent("UIToggle"):Set(XPLP_Data.chong == 1);
    XPLP_View.ToggleMustRushScore:GetComponent("UIToggle"):Set(XPLP_Data.chong == 2);
    XPLP_View.ToggleMustThenCanRushScore:GetComponent("UIToggle"):Set(XPLP_Data.chong == 3);
    XPLP_View.ToggleRushWithUpButDownScore:GetComponent("UIToggle"):Set(XPLP_Data.chong == 4);
    --冲分分数
    XPLP_View.ToggleRush1234:GetComponent("UIToggle"):Set(XPLP_Data.chongType == 1);
    XPLP_View.ToggleRush2468:GetComponent("UIToggle"):Set(XPLP_Data.chongType == 2);
    XPLP_View.ToggleRush1234.parent.gameObject:SetActive(XPLP_Data.chong > 0);
    --分数选择
    XPLP_View.RushScore1:GetComponent("UIToggle"):Set(XPLP_Data.chongNum == 1);
    XPLP_View.RushScore2:GetComponent("UIToggle"):Set(XPLP_Data.chongNum == 2);
    XPLP_View.RushScore3:GetComponent("UIToggle"):Set(XPLP_Data.chongNum == 3);
    XPLP_View.RushScore4:GetComponent("UIToggle"):Set(XPLP_Data.chongNum == 4);
    XPLP_View.RushScore1:Find("Label"):GetComponent("UILabel").text = XPLP_Data.chongType == 1 and "1分" or "2分";
    XPLP_View.RushScore2:Find("Label"):GetComponent("UILabel").text = XPLP_Data.chongType == 1 and "2分" or "4分";
    XPLP_View.RushScore3:Find("Label"):GetComponent("UILabel").text = XPLP_Data.chongType == 1 and "3分" or "6分";
    XPLP_View.RushScore4:Find("Label"):GetComponent("UILabel").text = XPLP_Data.chongType == 1 and "4分" or "8分";
    XPLP_View.RushScore1.parent.gameObject:SetActive(XPLP_Data.chong > 0);
    --算分方式
    XPLP_View.ToggleRushAdd:GetComponent("UIToggle"):Set(XPLP_Data.chongMode == 1); 
    XPLP_View.ToggleRushMulti:GetComponent("UIToggle"):Set(XPLP_Data.chongMode == 2); 
    XPLP_View.ToggleRushAdd.parent.gameObject:SetActive(XPLP_Data.chong > 0);
    --是否抽牌
    XPLP_View.ToggleNoExtract:GetComponent("UIToggle"):Set(XPLP_Data.chouCards == 0)
    XPLP_View.ToggleExtract22:GetComponent("UIToggle"):Set(XPLP_Data.chouCards == 22)
    XPLP_View.ToggleExtract32:GetComponent("UIToggle"):Set(XPLP_Data.chouCards == 32)
    XPLP_View.ToggleNoExtract.parent.gameObject:SetActive(XPLP_Data.size == 2);

    --翻倍选择
    XPLP_View.ToggleNoDouble:GetComponent("UIToggle"):Set(not XPLP_Data.choiceDouble);
    XPLP_View.ToggleDouble:GetComponent("UIToggle"):Set(XPLP_Data.choiceDouble);
    XPLP_View.ToggleDoubleScoreTxt.parent.gameObject:SetActive(XPLP_Data.choiceDouble);
    XPLP_View.ToggleDoubleScoreTxt:GetComponent("UILabel").text = XPLP_Data.doubleScore == 0 and "不限制" or ("小于"..XPLP_Data.doubleScore.."分");
    XPLP_View.ToggleNoDouble.parent.gameObject:SetActive(XPLP_Data.size == 2);
    --倍数选择
    XPLP_View.Toggle2Times:GetComponent("UIToggle"):Set(XPLP_Data.multiple == 2);
    XPLP_View.Toggle3Times:GetComponent("UIToggle"):Set(XPLP_Data.multiple == 3);
    XPLP_View.Toggle4Times:GetComponent("UIToggle"):Set(XPLP_Data.multiple == 4);
    XPLP_View.Toggle2Times.parent.gameObject:SetActive(XPLP_Data.size == 2 and XPLP_Data.choiceDouble);
    

    XPLP_View.ToggleSettlementScoreSelect.parent.gameObject:SetActive(XPLP_Data.size==2)
    XPLP_View.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(XPLP_Data.isSettlementScore)
	XPLP_View.ToggleFewerScoreTxt:GetComponent('UILabel').text = XPLP_Data.fewerValue
    XPLP_View.ToggleAddScoreTxt:GetComponent('UILabel').text = XPLP_Data.addValue
    XPLP_View.ToggleBaseScoreTxt:GetComponent('UILabel').text = XPLP_Data.baseScore.."分"


    XPLP_View.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(XPLP_Data.trusteeship == 0)
	XPLP_View.ToggleTrusteeship1:GetComponent('UIToggle'):Set(XPLP_Data.trusteeship == 1)
	XPLP_View.ToggleTrusteeship2:GetComponent('UIToggle'):Set(XPLP_Data.trusteeship == 2)
	XPLP_View.ToggleTrusteeship3:GetComponent('UIToggle'):Set(XPLP_Data.trusteeship == 3)
	XPLP_View.ToggleTrusteeship5:GetComponent('UIToggle'):Set(XPLP_Data.trusteeship == 5)

	XPLP_View.ToggleTrusteeshipOne.parent.gameObject:SetActive(XPLP_Data.trusteeship ~= 0)
    XPLP_View.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not XPLP_Data.trusteeshipDissolve and XPLP_Data.trusteeshipRound == 0)
    XPLP_View.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(XPLP_Data.trusteeshipDissolve == true)
    XPLP_View.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(XPLP_Data.trusteeshipRound == 3);
    XPLP_View.ToggleTrusteeshipOne.parent.gameObject:SetActive(XPLP_Data.trusteeship ~= 0)
    XPLP_View.ToggleIPcheck:GetComponent('UIToggle'):Set(XPLP_Data.openIp)
    XPLP_View.ToggleGPScheck:GetComponent('UIToggle'):Set(XPLP_Data.openGps)
    XPLP_View.ToggleIPcheck.parent.gameObject:SetActive(XPLP_Data.size > 2)
    payLabel:GetComponent("UILabel").text = "0";
    local XPLPPanel= gameObject.transform:Find("table");
    XPLPPanel:GetComponent('UIGrid'):Reposition();
end

function this.GetDataPrefab()
    XPLP_Data.rounds                = UnityEngine.PlayerPrefs.GetInt("XPLP_Rounds", 6);
    -- print("XPLP_Data.rounds:"..XPLP_Data.rounds);
    XPLP_Data.size                  = UnityEngine.PlayerPrefs.GetInt("XPLP_Size", 2);
    XPLP_Data.paymentType           = UnityEngine.PlayerPrefs.GetInt("XPLP_PayType", 0);
    XPLP_Data.bankerRule            = UnityEngine.PlayerPrefs.GetInt("XPLP_bankerRule",1) == 1;
    XPLP_Data.huPattern             = UnityEngine.PlayerPrefs.GetInt("XPLP_huPattern",1) == 1;
    XPLP_Data.takeMask              = UnityEngine.PlayerPrefs.GetInt("XPLP_takeMask",1) == 1;
    XPLP_Data.bankerPlayer          = UnityEngine.PlayerPrefs.GetInt("XPLP_bankerPlayer",1) == 1;
    XPLP_Data.huMust                = UnityEngine.PlayerPrefs.GetInt("XPLP_huMust",0) == 1;
    XPLP_Data.pengNoChu             = UnityEngine.PlayerPrefs.GetInt("XPLP_pengNoChu",0) == 1;
    XPLP_Data.operateConfirm        = UnityEngine.PlayerPrefs.GetInt("XPLP_operateConfirm",0) == 1;
    XPLP_Data.chiNo                 = UnityEngine.PlayerPrefs.GetInt("XPLP_chiNo",0) == 1;
    XPLP_Data.chiNoChu              = UnityEngine.PlayerPrefs.GetInt("XPLP_chiNoChu",0) == 1;
    XPLP_Data.guChou                = UnityEngine.PlayerPrefs.GetInt("XPLP_guChou",0) == 1;
    
    XPLP_Data.chong                 = UnityEngine.PlayerPrefs.GetInt("XPLP_chong",0);
    XPLP_Data.chongType             = UnityEngine.PlayerPrefs.GetInt("XPLP_chongType",1);
    XPLP_Data.chongNum              = UnityEngine.PlayerPrefs.GetInt("XPLP_chongNum",1);
    XPLP_Data.chongMode             = UnityEngine.PlayerPrefs.GetInt("XPLP_chongMode",1);

    XPLP_Data.chouCards             = UnityEngine.PlayerPrefs.GetInt("XPLP_chouCards",0);

    XPLP_Data.choiceDouble          = UnityEngine.PlayerPrefs.GetInt("XPLP_choiceDouble",0) == 1;
    XPLP_Data.doubleScore           = UnityEngine.PlayerPrefs.GetInt("XPLP_doubleScore",10);
    XPLP_Data.multiple              = UnityEngine.PlayerPrefs.GetInt("XPLP_multiple",2);

    XPLP_Data.isSettlementScore     = UnityEngine.PlayerPrefs.GetInt('XPLP_isSettlementScore', 0) == 1;
    XPLP_Data.fewerValue            = UnityEngine.PlayerPrefs.GetInt('XPLP_fewerValue', 10);
	XPLP_Data.addValue              = UnityEngine.PlayerPrefs.GetInt('XPLP_addValue', 10);
	XPLP_Data.baseScore             = UnityEngine.PlayerPrefs.GetInt('XPLP_baseScore', 1);
    XPLP_Data.trusteeship           = UnityEngine.PlayerPrefs.GetInt("XPLP_trusteeshipTime",0);
    XPLP_Data.trusteeshipDissolve   = UnityEngine.PlayerPrefs.GetInt("XPLP_trusteeshipType",0) == 1;
    XPLP_Data.trusteeshipRound      = UnityEngine.PlayerPrefs.GetInt("XPLP_trusteeshipRound",0);
    XPLP_Data.openGps               = UnityEngine.PlayerPrefs.GetInt("XPLP_openGps",0) == 1;  
    XPLP_Data.openIp                = UnityEngine.PlayerPrefs.GetInt("XPLP_openIp",0) == 1;
end

function this.OnClickRound(go)
    
    AudioManager.Instance:PlayAudio('btn');
    if go.gameObject == XPLP_View.Round8Toggle.gameObject then
        XPLP_Data.rounds = 8;
    elseif go.gameObject == XPLP_View.Round12Toggle.gameObject then
        XPLP_Data.rounds = 12;
    elseif go.gameObject == XPLP_View.Round6Toggle.gameObject then 
        XPLP_Data.rounds = 6;
    elseif go.gameObject == XPLP_View.Round16Toggle.gameObject then 
        XPLP_Data.rounds = 16;
    end
    UnityEngine.PlayerPrefs.SetInt("XPLP_Rounds", XPLP_Data.rounds);
end

function this.OnClickPeople(go)
    AudioManager.Instance:PlayAudio('btn');
    if go.gameObject == XPLP_View.P2Toggle.gameObject then
        XPLP_Data.size = 2;
    elseif go.gameObject == XPLP_View.P3Toggle.gameObject then
        XPLP_Data.size = 3;
    elseif go.gameObject == XPLP_View.P4Toggle.gameObject then 
        XPLP_Data.size = 4;
    end
    XPLP_View.ToggleIPcheck.parent.gameObject:SetActive(XPLP_Data.size > 2)
    UnityEngine.PlayerPrefs.SetInt("XPLP_Size", XPLP_Data.size)
    XPLP_View.ToggleSettlementScoreSelect.parent.gameObject:SetActive(XPLP_Data.size==2);
    XPLP_View.ToggleNoExtract.parent.gameObject:SetActive(XPLP_Data.size == 2);
    XPLP_View.ToggleGuChou.gameObject:SetActive(XPLP_Data.size > 2);
    XPLP_View.ToggleNoDouble.parent.gameObject:SetActive(XPLP_Data.size == 2);
    XPLP_View.Toggle2Times.parent.gameObject:SetActive(XPLP_Data.size == 2 and XPLP_Data.choiceDouble);
	gameObject:Find('table'):GetComponent('UIGrid'):Reposition();
end

function this.OnClickPayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if go.gameObject == XPLP_View.MasterPayToggle.gameObject then
        XPLP_Data.paymentType = 0
    elseif go.gameObject == XPLP_View.WinnerPayToggle.gameObject then
        XPLP_Data.paymentType = 2
    end
    UnityEngine.PlayerPrefs.SetInt("XPLP_PayType", XPLP_Data.paymentType)
end

function this.OnClikWinType(go)
    AudioManager.Instance:PlayAudio('btn')
    if go == XPLP_View.ToggleMustSelfMo.gameObject then 
        XPLP_Data.huPattern = true;
    elseif go == XPLP_View.ToggleCanDianPao.gameObject then 
        XPLP_Data.huPattern = false;
    end
    UnityEngine.PlayerPrefs.SetInt("XPLP_huPattern", XPLP_Data.huPattern and 1 or 0);
end


function this.OnClickBankerType(go)
    AudioManager.Instance:PlayAudio('btn');
    if go == XPLP_View.ToggleFirstRandomBanker.gameObject then 
        XPLP_Data.bankerRule = true;
    elseif go == XPLP_View.ToggleFirstIsBanker.gameObject then 
        XPLP_Data.bankerRule = false;
    end
    UnityEngine.PlayerPrefs.SetInt("XPLP_bankerRule", XPLP_Data.bankerRule and 1 or 0);

end







function this.OnClickTrusteeshipTime(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == XPLP_View.ToggleTrusteeshipNo.gameObject then
		XPLP_Data.trusteeship = 0
	elseif go == XPLP_View.ToggleTrusteeship1.gameObject then
        XPLP_Data.trusteeship = 1
    elseif go == XPLP_View.ToggleTrusteeship2.gameObject then
		XPLP_Data.trusteeship = 2
	elseif go == XPLP_View.ToggleTrusteeship3.gameObject then
		XPLP_Data.trusteeship = 3
	elseif go == XPLP_View.ToggleTrusteeship5.gameObject then
		XPLP_Data.trusteeship = 5
    end
    UnityEngine.PlayerPrefs.SetInt("XPLP_trusteeshipTime", XPLP_Data.trusteeship)
    XPLP_View.ToggleTrusteeshipOne.parent.gameObject:SetActive(XPLP_Data.trusteeship ~= 0)
    gameObject.transform:Find("table"):GetComponent("UIGrid"):Reposition();
end

function this.OnClickTrusteeshipType(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == XPLP_View.ToggleTrusteeshipAll.gameObject then
        XPLP_Data.trusteeshipDissolve = false;
        XPLP_Data.trusteeshipRound = 0;
	elseif go == XPLP_View.ToggleTrusteeshipOne.gameObject then
        XPLP_Data.trusteeshipDissolve = true;
        XPLP_Data.trusteeshipRound = 0;
    elseif go == XPLP_View.ToggleTrusteeshipThree.gameObject then 
        XPLP_Data.trusteeshipDissolve = false;
        XPLP_Data.trusteeshipRound = 3;
    end
    UnityEngine.PlayerPrefs.SetInt("XPLP_trusteeshipType",XPLP_Data.trusteeshipDissolve and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("XPLP_trusteeshipRound",XPLP_Data.trusteeshipRound);
end
function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if XPLP_View.ToggleIPcheck.gameObject == go then
		XPLP_Data.openIp = XPLP_View.ToggleIPcheck:GetComponent('UIToggle').value
	elseif XPLP_View.ToggleGPScheck.gameObject == go then
		XPLP_Data.openGps = XPLP_View.ToggleGPScheck:GetComponent('UIToggle').value
    end
    UnityEngine.PlayerPrefs.SetInt("XPLP_openIp",XPLP_Data.openIp and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("XPLP_openGps",XPLP_Data.openGps and 1 or 0);
end
function this.GetConfig()
    
    local moneyLess             = false;
    XPLP_Data.takeMask          = XPLP_View.ToggleWithFlower:GetComponent("UIToggle").value;
    XPLP_Data.bankerPlayer      = XPLP_View.ToggleZhuangXian:GetComponent("UIToggle").value;
    XPLP_Data.huMust            = XPLP_View.ToggleYHBH:GetComponent("UIToggle").value;
    XPLP_Data.pengNoChu         = XPLP_View.TogglePengThenNoSame:GetComponent("UIToggle").value;
    XPLP_Data.operateConfirm    = XPLP_View.ToggleCPNeedSure:GetComponent("UIToggle").value;
    XPLP_Data.chiNo             = XPLP_View.ToggleNoChi:GetComponent("UIToggle").value;
    XPLP_Data.chiNoChu          = (XPLP_View.ToggleChiThenNoSame:GetComponent("UIToggle").value and (not XPLP_Data.chiNo));
    XPLP_Data.guChou            = (XPLP_View.ToggleGuChou:GetComponent("UIToggle").value and XPLP_Data.size > 2);

    UnityEngine.PlayerPrefs.SetInt("XPLP_takeMask",         XPLP_Data.takeMask and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("XPLP_bankerPlayer",     XPLP_Data.bankerPlayer and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("XPLP_huMust",           XPLP_Data.huMust and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("XPLP_pengNoChu",        XPLP_Data.pengNoChu and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("XPLP_operateConfirm",  XPLP_Data.operateConfirm and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("XPLP_chiNo",            XPLP_Data.chiNo and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("XPLP_chiNoChu",         XPLP_Data.chiNoChu and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("XPLP_guChou",           XPLP_Data.guChou and 1 or 0);
   

    local settings                  = {}
    settings.roomType               = proxy_pb.XPLPM;
    settings.rounds                 = XPLP_Data.rounds;
    settings.size                   = XPLP_Data.size;
    settings.paymentType            = XPLP_Data.paymentType;
    settings.bankerRule             = XPLP_Data.bankerRule;  
    settings.huPattern              = XPLP_Data.huPattern;   
    settings.takeMask               = XPLP_Data.takeMask;
    settings.bankerPlayer           = XPLP_Data.bankerPlayer;
    settings.huMust                 = XPLP_Data.huMust;
    settings.pengNoChu              = XPLP_Data.pengNoChu;
    settings.operateConfirm         = XPLP_Data.operateConfirm;
    settings.chiNo                  = XPLP_Data.chiNo;
    settings.chiNoChu               = XPLP_Data.chiNoChu;
    settings.guChou                 = XPLP_Data.guChou;
    settings.chong                  = XPLP_Data.chong;
    settings.chongType              = XPLP_Data.chong == 0 and 0 or XPLP_Data.chongType;
    settings.chongNum               = XPLP_Data.chong == 0 and 0 or XPLP_Data.chongNum;
    settings.chongMode              = XPLP_Data.chong == 0 and 0 or XPLP_Data.chongMode;
    settings.chouCards              = XPLP_Data.size > 2 and 0 or XPLP_Data.chouCards;
    settings.choiceDouble           = XPLP_Data.choiceDouble and XPLP_Data.size == 2;
    settings.doubleScore            = (XPLP_Data.choiceDouble and XPLP_Data.size == 2) and XPLP_Data.doubleScore or 0;--2人局并且要开启了翻倍，否传0
    settings.multiple               = (XPLP_Data.choiceDouble and XPLP_Data.size == 2) and XPLP_Data.multiple or 0;--2人局并且要开启了翻倍，否传0
    settings.resultScore            = this.getResultScore(XPLP_Data);
    settings.resultLowerScore       = this.getResultLowerScore(XPLP_Data);
    settings.resultAddScore         = this.getResultAddScore(XPLP_Data);
    settings.baseScore              = XPLP_Data.baseScore;
    settings.trusteeship            = XPLP_Data.trusteeship * 60;
    settings.trusteeshipDissolve    = XPLP_Data.trusteeshipDissolve;
    settings.trusteeshipRound       = XPLP_Data.trusteeshipRound;
    settings.openIp                 = XPLP_Data.openIp;
    settings.openGps                = XPLP_Data.openGps;
    if XPLP_Data.size == 2 then
        settings.openIp =false;
        settings.openGps = false;
    end
    -- print("settings--");
    -- print_r(settings);
    return moneyLess,settings;
    
end


function this.getResultScore(XPLP_Data)
    if XPLP_Data.size == 2 then 
        return XPLP_Data.isSettlementScore;
    end
    return nil;
end

function this.getResultLowerScore(XPLP_Data)
    if XPLP_Data.size == 2 then 
        if XPLP_Data.isSettlementScore then 
            return XPLP_Data.fewerValue;
        end
    end
    
    return nil;
end

function this.getResultAddScore(XPLP_Data)
    if XPLP_Data.size == 2 then 
        if XPLP_Data.isSettlementScore then 
            return XPLP_Data.addValue;
        end
    end
    
    return nil;
end


function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    XPLP_Data.isSettlementScore= XPLP_View.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt("XPLP_isSettlementScore", XPLP_Data.isSettlementScore and 1 or 0)
end

function this.OnClickDoubleChangeChoose(go)
    AudioManager.Instance:PlayAudio('btn');
    if go == XPLP_View.ToggleDoubleAddButton.gameObject then 
        if XPLP_Data.doubleScore >= 5 then 
            XPLP_Data.doubleScore = XPLP_Data.doubleScore + 1;
        end
        if XPLP_Data.doubleScore > 100  then 
            XPLP_Data.doubleScore = 0;
            XPLP_View.ToggleDoubleScoreTxt:GetComponent("UILabel").text = "不限制";
        elseif XPLP_Data.doubleScore ~= 0 then 
            XPLP_View.ToggleDoubleScoreTxt:GetComponent("UILabel").text = "小于"..XPLP_Data.doubleScore.."分";
        end
    elseif go == XPLP_View.ToggleDoubleSubtractButton.gameObject then 
        if XPLP_Data.doubleScore == 0 then 
            XPLP_Data.doubleScore = 100;
        else
            XPLP_Data.doubleScore = XPLP_Data.doubleScore - 1;
        end

        if XPLP_Data.doubleScore < 5 then 
            XPLP_Data.doubleScore = 5;
        end
        XPLP_View.ToggleDoubleScoreTxt:GetComponent("UILabel").text = "小于"..XPLP_Data.doubleScore.."分";
    end
    UnityEngine.PlayerPrefs.SetInt("XPLP_doubleScore", XPLP_Data.doubleScore)
end



function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if XPLP_View.ToggleFewerAddButton.gameObject == go then
		XPLP_Data.fewerValue = XPLP_Data.fewerValue + 1
		if XPLP_Data.fewerValue > 100 then
			XPLP_Data.fewerValue = 100
		end
    elseif XPLP_View.ToggleFewerSubtractButton.gameObject == go then
		XPLP_Data.fewerValue = XPLP_Data.fewerValue - 1
		if XPLP_Data.fewerValue < 10 then
			XPLP_Data.fewerValue = 10
		end
	end
	XPLP_View.ToggleFewerScoreTxt:GetComponent('UILabel').text = XPLP_Data.fewerValue
	UnityEngine.PlayerPrefs.SetInt("XPLP_fewerValue", XPLP_Data.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if XPLP_View.ToggleAddAddButton.gameObject == go then
		XPLP_Data.addValue = XPLP_Data.addValue + 1
		if XPLP_Data.addValue > 100 then
			XPLP_Data.addValue = 100
		end
    elseif XPLP_View.ToggleAddSubtractButton.gameObject == go then
		XPLP_Data.addValue = XPLP_Data.addValue - 1
		if XPLP_Data.addValue < 10 then
			XPLP_Data.addValue = 10
		end
	end
	XPLP_View.ToggleAddScoreTxt:GetComponent('UILabel').text = XPLP_Data.addValue
	UnityEngine.PlayerPrefs.SetInt("XPLP_addValue", XPLP_Data.addValue)
end


function this.OnClickBaseScoreButton(go)
    AudioManager.Instance:PlayAudio('btn')
    if XPLP_View.ToggleBaseScroeAddButton.gameObject == go then
		XPLP_Data.baseScore = XPLP_Data.baseScore + 1
		if XPLP_Data.baseScore > 10 then
			XPLP_Data.baseScore = 10
		end
    elseif XPLP_View.ToggleBaseScroeSubtractButton.gameObject == go then
		XPLP_Data.baseScore = XPLP_Data.baseScore - 1
		if XPLP_Data.baseScore < 1 then
			XPLP_Data.baseScore = 1
		end
	end
	XPLP_View.ToggleBaseScoreTxt:GetComponent('UILabel').text = XPLP_Data.baseScore.."分";
	UnityEngine.PlayerPrefs.SetInt("XPLP_baseScore", XPLP_Data.baseScore);
end


function this.OnClikNoChi(go)
    AudioManager.Instance:PlayAudio('btn');
    XPLP_View.ToggleChiThenNoSame.gameObject:SetActive(not XPLP_View.ToggleNoChi:GetComponent("UIToggle").value);
end

function this.OnClickRushScoreType(go)
    AudioManager.Instance:PlayAudio('btn');
    local XPLPPanel = gameObject.transform:Find("table");
    if go == XPLP_View.ToggleNoRushScore.gameObject then 
        XPLPPanel.transform:Find("ToggleRushTypeGroup").gameObject:SetActive(false);
        XPLPPanel.transform:Find("ToggleRushScoreGroup").gameObject:SetActive(false);
        XPLPPanel.transform:Find("ToggleCaculateGroup").gameObject:SetActive(false);
        XPLP_Data.chong = 0;
    else
        XPLPPanel.transform:Find("ToggleRushTypeGroup").gameObject:SetActive(true);
        XPLPPanel.transform:Find("ToggleRushScoreGroup").gameObject:SetActive(true);
        XPLPPanel.transform:Find("ToggleCaculateGroup").gameObject:SetActive(true);
        if go == XPLP_View.ToggleCanRushScore.gameObject then 
            XPLP_Data.chong = 1;
        elseif go == XPLP_View.ToggleMustRushScore.gameObject then 
            XPLP_Data.chong = 2;
        elseif go == XPLP_View.ToggleMustThenCanRushScore.gameObject then 
            XPLP_Data.chong = 3;
        elseif go == XPLP_View.ToggleRushWithUpButDownScore.gameObject then 
            XPLP_Data.chong = 4;
        end
    end
    UnityEngine.PlayerPrefs.SetInt("XPLP_chong", XPLP_Data.chong);
    gameObject.transform:Find("table"):GetComponent("UIGrid"):Reposition();
end

function this.OnClickRushType(go)
    AudioManager.Instance:PlayAudio('btn');
    if go == XPLP_View.ToggleRush1234.gameObject then 
        XPLP_View.RushScore1:Find("Label"):GetComponent("UILabel").text = "1分";
        XPLP_View.RushScore2:Find("Label"):GetComponent("UILabel").text = "2分";
        XPLP_View.RushScore3:Find("Label"):GetComponent("UILabel").text = "3分";
        XPLP_View.RushScore4:Find("Label"):GetComponent("UILabel").text = "4分";
        XPLP_Data.chongType = 1;
    elseif go == XPLP_View.ToggleRush2468.gameObject then 
        XPLP_View.RushScore1:Find("Label"):GetComponent("UILabel").text = "2分";
        XPLP_View.RushScore2:Find("Label"):GetComponent("UILabel").text = "4分";
        XPLP_View.RushScore3:Find("Label"):GetComponent("UILabel").text = "6分";
        XPLP_View.RushScore4:Find("Label"):GetComponent("UILabel").text = "8分";
        XPLP_Data.chongType = 2;
    end
    UnityEngine.PlayerPrefs.SetInt("XPLP_chongType", XPLP_Data.chongType);
end

function this.OnClickRushScore(go)
    AudioManager.Instance:PlayAudio('btn');
    if go == XPLP_View.RushScore1.gameObject then 
        XPLP_Data.chongNum = 1;
    elseif go == XPLP_View.RushScore2.gameObject then 
        XPLP_Data.chongNum = 2;
    elseif go == XPLP_View.RushScore3.gameObject then 
        XPLP_Data.chongNum = 3;
    elseif go == XPLP_View.RushScore4.gameObject then 
        XPLP_Data.chongNum = 4;
    end
    UnityEngine.PlayerPrefs.SetInt("XPLP_chongNum", XPLP_Data.chongNum);
end

function this.OnClickCalculateType(go)
    AudioManager.Instance:PlayAudio('btn');
    if go == XPLP_View.ToggleRushAdd.gameObject then 
        XPLP_Data.chongMode = 1;
    elseif go == XPLP_View.ToggleRushMulti.gameObject then 
        XPLP_Data.chongMode = 2;
    end
    UnityEngine.PlayerPrefs.SetInt("XPLP_chongMode", XPLP_Data.chongMode);

end

function this.OnClickIfExtractPlate(go)
    AudioManager.Instance:PlayAudio('btn');
    if go == XPLP_View.ToggleNoExtract.gameObject then 
        XPLP_Data.chouCards = 0;
    elseif go == XPLP_View.ToggleExtract22.gameObject then 
        XPLP_Data.chouCards = 22;
    elseif go == XPLP_View.ToggleExtract32.gameObject then 
        XPLP_Data.chouCards = 32;
    end
    UnityEngine.PlayerPrefs.SetInt("XPLP_chouCards", XPLP_Data.chouCards);

end


function this.OnClickDoubleChoose(go)
    AudioManager.Instance:PlayAudio('btn');
    if go == XPLP_View.ToggleNoDouble.gameObject then 
        XPLP_Data.choiceDouble = false;
        XPLP_View.Toggle2Times.parent.gameObject:SetActive(false);
        XPLP_View.ToggleDoubleScoreTxt.parent.gameObject:SetActive(false);
    elseif go == XPLP_View.ToggleDouble.gameObject then
        XPLP_View.ToggleDoubleScoreTxt.parent.gameObject:SetActive(true);
        XPLP_Data.choiceDouble = true;
        XPLP_View.Toggle2Times.parent.gameObject:SetActive(true);
    end
    UnityEngine.PlayerPrefs.SetInt("XPLP_choiceDouble", XPLP_Data.choiceDouble == true and 1 or 0);
    gameObject.transform:Find("table"):GetComponent("UIGrid"):Reposition();
end

function this.OnClickDoubleTimes(go)
    AudioManager.Instance:PlayAudio('btn');
    if go == XPLP_View.Toggle2Times.gameObject then 
        XPLP_Data.multiple = 2;
    elseif go == XPLP_View.Toggle3Times.gameObject then 
        XPLP_Data.multiple = 3;
    elseif go == XPLP_View.Toggle4Times.gameObject then 
        XPLP_Data.multiple = 4;
    end
    UnityEngine.PlayerPrefs.SetInt("XPLP_multiple", XPLP_Data.multiple);
end

return this;

