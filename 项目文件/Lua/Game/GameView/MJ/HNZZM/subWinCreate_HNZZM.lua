
subWinCreate_HNZZM   = {};
require("proxy_pb")
local json = require("json")
local this = subWinCreate_HNZZM;
local message;
local gameObject;
local HNZZM_View = {}
local HNZZM_Data = {}
local payLabel;

function this.Init(go,messageObj)
    print("Awake was called");
    gameObject                                  = go;
	message                                     = messageObj;
    payLabel 							        = message.transform:Find('diamond/pay_label'):GetComponent('UILabel')
    local HNZZMPanel                            = gameObject.transform:Find("table");
    --局数选择              
    HNZZM_View.Round6Toggle                     = HNZZMPanel.transform:Find("ToggleRoundGroup/ToggleRound6");
    HNZZM_View.Round8Toggle                     = HNZZMPanel.transform:Find("ToggleRoundGroup/ToggleRound8");
    HNZZM_View.Round12Toggle                    = HNZZMPanel.transform:Find("ToggleRoundGroup/ToggleRound12");
    HNZZM_View.Round16Toggle                    = HNZZMPanel.transform:Find("ToggleRoundGroup1/ToggleRound16");
    --人数选择              
    HNZZM_View.P2Toggle                         = HNZZMPanel.transform:Find("TogglePeopleGroup/Toggle2P");
    HNZZM_View.P3Toggle                         = HNZZMPanel.transform:Find("TogglePeopleGroup/Toggle3P");
    HNZZM_View.P4Toggle                         = HNZZMPanel.transform:Find("TogglePeopleGroup/Toggle4P");
    --开房模式              
    HNZZM_View.MasterPayToggle                  = HNZZMPanel.transform:Find('TogglePayTypeGroup/ToggleMasterPay');
    HNZZM_View.WinnerPayToggle                  = HNZZMPanel.transform:Find('TogglePayTypeGroup/ToggleWinnerPay');
    --坐庄规则      
    HNZZM_View.ToggleFirstRandomBanker          = HNZZMPanel.transform:Find('ToggleBankTypeGroup/ToggleFirstRandomBanker');
    HNZZM_View.ToggleFirstIsBanker              = HNZZMPanel.transform:Find('ToggleBankTypeGroup/ToggleFirstIsBanker');

    --胡牌方式              
    HNZZM_View.ToggleMustSelfMo                 = HNZZMPanel.transform:Find('ToggleWinTypeGroup/ToggleMustSelfMo');
    HNZZM_View.ToggleCanDianPao                 = HNZZMPanel.transform:Find('ToggleWinTypeGroup/ToggleCanDianPao');
    --个性玩法              
    HNZZM_View.ToggleWithOutWind                = HNZZMPanel.transform:Find("TogglePlayTypeGroup/ToggleWithOutWind");
    HNZZM_View.ToggleTakeHun                    = HNZZMPanel.transform:Find("TogglePlayTypeGroup/ToggleTakeHun");
    HNZZM_View.ToggleGangAndRun                 = HNZZMPanel.transform:Find("TogglePlayTypeGroup/ToggleGangAndRun");
    HNZZM_View.ToggleZhuangAddBase              = HNZZMPanel.transform:Find("TogglePlayTypeGroup1/ToggleZhuangAddBase");
    HNZZM_View.ToggleGangHuaDouble              = HNZZMPanel.transform:Find("TogglePlayTypeGroup1/ToggleGangHuaDouble");
    HNZZM_View.ToggleQiduiDouble                = HNZZMPanel.transform:Find("TogglePlayTypeGroup1/ToggleQiduiDouble");
    --带混选择      
    HNZZM_View.ToggleUPHun                      = HNZZMPanel.transform:Find("ToggleTakeHunGroup/ToggleUPHun");
    HNZZM_View.ToggleMidHun                     = HNZZMPanel.transform:Find("ToggleTakeHunGroup/ToggleMidHun");
	HNZZM_View.ToggleDownHun                    = HNZZMPanel.transform:Find('ToggleTakeHunGroup/ToggleDownHun')
    HNZZM_View.ToggleDoubleHun                  = HNZZMPanel.transform:Find('ToggleTakeHunGroup/ToggleDoubleHun') 
    --跑分方式
    HNZZM_View.ToggleFreeChoice                 = HNZZMPanel.transform:Find('ToggleScoreRunTypeGroup/ToggleFreeChoice') 
    HNZZM_View.ToggleSteadyChoice               = HNZZMPanel.transform:Find('ToggleScoreRunTypeGroup/ToggleSteadyChoice') 
    --跑分分数
    HNZZM_View.ToggleRunScore1_3                = HNZZMPanel.transform:Find('ToggleScoreRunGroup/ToggleRunScore1_3') 
    HNZZM_View.ToggleRunScore1_5                = HNZZMPanel.transform:Find('ToggleScoreRunGroup/ToggleRunScore1_5') 
    HNZZM_View.RunScoreTxt                      = HNZZMPanel.transform:Find('ToggleScoreRunGroup/RunScore/Value') 
    HNZZM_View.RunScoreAddButton                = HNZZMPanel.transform:Find('ToggleScoreRunGroup/RunScore/AddButton') 
    HNZZM_View.RunScoreSubtractButton           = HNZZMPanel.transform:Find('ToggleScoreRunGroup/RunScore/SubtractButton') 
    
    --2人结算低于多少分加
    HNZZM_View.ToggleSettlementScoreSelect      = HNZZMPanel:Find('settlementScore/select')
	HNZZM_View.ToggleFewerScoreTxt              = HNZZMPanel:Find('settlementScore/fewerValue/Value')
	HNZZM_View.ToggleFewerAddButton             = HNZZMPanel:Find('settlementScore/fewerValue/AddButton')
	HNZZM_View.ToggleFewerSubtractButton        = HNZZMPanel:Find('settlementScore/fewerValue/SubtractButton')
	HNZZM_View.ToggleAddScoreTxt                = HNZZMPanel:Find('settlementScore/addValue/Value')
	HNZZM_View.ToggleAddAddButton               = HNZZMPanel:Find('settlementScore/addValue/AddButton')
	HNZZM_View.ToggleAddSubtractButton          = HNZZMPanel:Find('settlementScore/addValue/SubtractButton')
    HNZZM_View.ToggleTrusteeshipNo              = HNZZMPanel.transform:Find('ToggleTrusteeship/ToggleNo');
	HNZZM_View.ToggleTrusteeship1               = HNZZMPanel.transform:Find('ToggleTrusteeship/Toggle1Minute');
	HNZZM_View.ToggleTrusteeship2               = HNZZMPanel.transform:Find('ToggleTrusteeship/Toggle2Minute');
	HNZZM_View.ToggleTrusteeship3               = HNZZMPanel.transform:Find('ToggleTrusteeship/Toggle3Minute');
	HNZZM_View.ToggleTrusteeship5               = HNZZMPanel.transform:Find('ToggleTrusteeship1/Toggle5Minute');
	HNZZM_View.ToggleTrusteeshipAll             = HNZZMPanel.transform:Find('ToggleTrusteeshipType/ToggleAll');
    HNZZM_View.ToggleTrusteeshipOne             = HNZZMPanel.transform:Find('ToggleTrusteeshipType/ToggleOne');
    HNZZM_View.ToggleTrusteeshipThree           = HNZZMPanel.transform:Find('ToggleTrusteeshipType/ToggleThree');
    HNZZM_View.ToggleIPcheck                    = HNZZMPanel.transform:Find('PreventCheat/IPcheck')
    HNZZM_View.ToggleGPScheck                   = HNZZMPanel.transform:Find('PreventCheat/GPScheck')
    --2人翻倍
    HNZZM_View.ToggleMultiple2                  = HNZZMPanel.transform:Find('multiple/2')
	HNZZM_View.ToggleMultiple3                  = HNZZMPanel.transform:Find('multiple/3')
	HNZZM_View.ToggleMultiple4                  = HNZZMPanel.transform:Find('multiple/4')

	HNZZM_View.ToggleChoiceDouble               = HNZZMPanel.transform:Find('choiceDouble/On')
	HNZZM_View.ToggleNoChoiceDouble             = HNZZMPanel.transform:Find('choiceDouble/Off')
	HNZZM_View.DoubleScoreText                  = HNZZMPanel.transform:Find('choiceDouble/doubleScore/Value')
	HNZZM_View.AddDoubleScoreButton             = HNZZMPanel.transform:Find('choiceDouble/doubleScore/AddButton')
    HNZZM_View.SubtractDoubleScoreButton        = HNZZMPanel.transform:Find('choiceDouble/doubleScore/SubtractButton')

    message:AddClick(HNZZM_View.ToggleChoiceDouble.gameObject,          this.OnClickChoiceDouble)
	message:AddClick(HNZZM_View.ToggleNoChoiceDouble.gameObject,        this.OnClickChoiceDouble)
	message:AddClick(HNZZM_View.AddDoubleScoreButton.gameObject,        this.OnClickChangeDoubleScore)
	message:AddClick(HNZZM_View.SubtractDoubleScoreButton.gameObject,   this.OnClickChangeDoubleScore)

	message:AddClick(HNZZM_View.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(HNZZM_View.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(HNZZM_View.ToggleMultiple4.gameObject, this.OnClickMultiple)
    
    message:AddClick(HNZZM_View.Round6Toggle.gameObject,     this.OnClickRound);
    message:AddClick(HNZZM_View.Round8Toggle.gameObject,     this.OnClickRound);
    message:AddClick(HNZZM_View.Round12Toggle.gameObject,    this.OnClickRound);
    message:AddClick(HNZZM_View.Round16Toggle.gameObject,    this.OnClickRound);
    
    message:AddClick(HNZZM_View.P2Toggle.gameObject,     this.OnClickPeople);
    message:AddClick(HNZZM_View.P3Toggle.gameObject,     this.OnClickPeople);
    message:AddClick(HNZZM_View.P4Toggle.gameObject,     this.OnClickPeople);

    message:AddClick(HNZZM_View.MasterPayToggle.gameObject,  this.OnClickPayType);
    message:AddClick(HNZZM_View.WinnerPayToggle.gameObject,  this.OnClickPayType);

    message:AddClick(HNZZM_View.ToggleFirstIsBanker.gameObject,      this.OnClickBankerType);
    message:AddClick(HNZZM_View.ToggleFirstRandomBanker.gameObject,  this.OnClickBankerType);

    message:AddClick(HNZZM_View.ToggleMustSelfMo.gameObject,     this.OnClikWinType);
    message:AddClick(HNZZM_View.ToggleCanDianPao.gameObject,     this.OnClikWinType);

    message:AddClick(HNZZM_View.ToggleTakeHun.gameObject,       this.OnClikTakeHun);

    message:AddClick(HNZZM_View.ToggleUPHun.gameObject,         this.OnClickHunChoice);
    message:AddClick(HNZZM_View.ToggleMidHun.gameObject,        this.OnClickHunChoice);
    message:AddClick(HNZZM_View.ToggleDownHun.gameObject,       this.OnClickHunChoice);
    message:AddClick(HNZZM_View.ToggleDoubleHun.gameObject,     this.OnClickHunChoice);

    message:AddClick(HNZZM_View.ToggleFreeChoice.gameObject,        this.OnClickRunScoreType);
    message:AddClick(HNZZM_View.ToggleSteadyChoice.gameObject,      this.OnClickRunScoreType);

    message:AddClick(HNZZM_View.ToggleRunScore1_3.gameObject,      this.OnClickRunScoreChoice);
    message:AddClick(HNZZM_View.ToggleRunScore1_5.gameObject,      this.OnClickRunScoreChoice);

    message:AddClick(HNZZM_View.RunScoreAddButton.gameObject,      this.OnClickRunScoreChange);
    message:AddClick(HNZZM_View.RunScoreSubtractButton.gameObject, this.OnClickRunScoreChange);


    message:AddClick(HNZZM_View.ToggleSettlementScoreSelect.gameObject,  this.OnClickSettlementScoreSelect)
	message:AddClick(HNZZM_View.ToggleFewerAddButton.gameObject,         this.OnClickFewerButton)
	message:AddClick(HNZZM_View.ToggleFewerSubtractButton.gameObject,    this.OnClickFewerButton)
	message:AddClick(HNZZM_View.ToggleAddAddButton.gameObject,           this.OnClickAddButton)
	message:AddClick(HNZZM_View.ToggleAddSubtractButton.gameObject,      this.OnClickAddButton)
    
 
    message:AddClick(HNZZM_View.ToggleTrusteeshipNo.gameObject,          this.OnClickTrusteeshipTime)
	message:AddClick(HNZZM_View.ToggleTrusteeship1.gameObject,           this.OnClickTrusteeshipTime)
	message:AddClick(HNZZM_View.ToggleTrusteeship2.gameObject,           this.OnClickTrusteeshipTime)
	message:AddClick(HNZZM_View.ToggleTrusteeship3.gameObject,           this.OnClickTrusteeshipTime)
	message:AddClick(HNZZM_View.ToggleTrusteeship5.gameObject,           this.OnClickTrusteeshipTime)
	message:AddClick(HNZZM_View.ToggleTrusteeshipOne.gameObject,         this.OnClickTrusteeshipType)
    message:AddClick(HNZZM_View.ToggleTrusteeshipAll.gameObject,         this.OnClickTrusteeshipType)
    message:AddClick(HNZZM_View.ToggleTrusteeshipThree.gameObject,       this.OnClickTrusteeshipType)

    message:AddClick(HNZZM_View.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(HNZZM_View.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end


function this.Refresh()
    print("OnEnable was called")
    this.GetDataPrefab()
    HNZZM_View.Round6Toggle:GetComponent("UIToggle"):Set(HNZZM_Data.rounds == 6);
    HNZZM_View.Round8Toggle:GetComponent("UIToggle"):Set(HNZZM_Data.rounds == 8);
    HNZZM_View.Round12Toggle:GetComponent("UIToggle"):Set(HNZZM_Data.rounds == 12);
    HNZZM_View.Round16Toggle:GetComponent("UIToggle"):Set(HNZZM_Data.rounds == 16);

    HNZZM_View.P2Toggle:GetComponent("UIToggle"):Set(HNZZM_Data.size == 2);
    HNZZM_View.P3Toggle:GetComponent("UIToggle"):Set(HNZZM_Data.size == 3);
    HNZZM_View.P4Toggle:GetComponent("UIToggle"):Set(HNZZM_Data.size == 4);

    HNZZM_View.MasterPayToggle:GetComponent("UIToggle"):Set(HNZZM_Data.paymentType == 0)
    HNZZM_View.WinnerPayToggle:GetComponent("UIToggle"):Set(HNZZM_Data.paymentType == 2)

    HNZZM_View.ToggleFirstRandomBanker:GetComponent("UIToggle"):Set(HNZZM_Data.bankerRule);
    HNZZM_View.ToggleFirstIsBanker:GetComponent("UIToggle"):Set(not HNZZM_Data.bankerRule);

    HNZZM_View.ToggleMustSelfMo:GetComponent("UIToggle"):Set(HNZZM_Data.huPattern);
    HNZZM_View.ToggleCanDianPao:GetComponent("UIToggle"):Set(not HNZZM_Data.huPattern);

    HNZZM_View.ToggleWithOutWind:GetComponent("UIToggle"):Set(HNZZM_Data.takeFeng);
    HNZZM_View.ToggleTakeHun:GetComponent("UIToggle"):Set(HNZZM_Data.takeHun);
    HNZZM_View.ToggleGangAndRun:GetComponent("UIToggle"):Set(HNZZM_Data.gangPao );
    HNZZM_View.ToggleZhuangAddBase:GetComponent("UIToggle"):Set(HNZZM_Data.bankerBase);
    HNZZM_View.ToggleGangHuaDouble:GetComponent("UIToggle"):Set(HNZZM_Data.gangShangHuaJiaBei)
    HNZZM_View.ToggleQiduiDouble:GetComponent("UIToggle"):Set(HNZZM_Data.qiDuiJiaBei)

    HNZZM_View.ToggleUPHun:GetComponent("UIToggle"):Set(HNZZM_Data.takHunMode == 1);
    HNZZM_View.ToggleMidHun:GetComponent("UIToggle"):Set(HNZZM_Data.takHunMode == 2);
    HNZZM_View.ToggleDownHun:GetComponent("UIToggle"):Set(HNZZM_Data.takHunMode == 3);
    HNZZM_View.ToggleDoubleHun:GetComponent("UIToggle"):Set(HNZZM_Data.takHunMode == 4);
    HNZZM_View.ToggleUPHun.parent.gameObject:SetActive(HNZZM_Data.takeHun);

    HNZZM_View.ToggleFreeChoice:GetComponent("UIToggle"):Set(HNZZM_Data.selectPao == -1);
    HNZZM_View.ToggleSteadyChoice:GetComponent("UIToggle"):Set(HNZZM_Data.selectPao >= 0);
    HNZZM_View.ToggleRunScore1_3:GetComponent("UIToggle"):Set(HNZZM_Data.selectPaoScore == 1 and HNZZM_Data.selectPao == -1);
    HNZZM_View.ToggleRunScore1_5:GetComponent("UIToggle"):Set(HNZZM_Data.selectPaoScore == 2 and HNZZM_Data.selectPao == -1);
    HNZZM_View.ToggleRunScore1_3.gameObject:SetActive(HNZZM_Data.selectPao == -1);
    HNZZM_View.ToggleRunScore1_5.gameObject:SetActive(HNZZM_Data.selectPao == -1);
    HNZZM_View.RunScoreTxt.parent.gameObject:SetActive(HNZZM_Data.selectPao >= 0);
    HNZZM_View.RunScoreTxt:GetComponent("UILabel").text = HNZZM_Data.selectPao < 0 and "" or (HNZZM_Data.selectPao == 0 and "不跑" or "跑"..HNZZM_Data.selectPao);
    


    HNZZM_View.ToggleSettlementScoreSelect.parent.gameObject:SetActive(HNZZM_Data.size==2)
    HNZZM_View.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(HNZZM_Data.isSettlementScore)
	HNZZM_View.ToggleFewerScoreTxt:GetComponent('UILabel').text = HNZZM_Data.fewerValue.."分";
	HNZZM_View.ToggleAddScoreTxt:GetComponent('UILabel').text = HNZZM_Data.addValue.."分";


    HNZZM_View.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(HNZZM_Data.trusteeship == 0)
	HNZZM_View.ToggleTrusteeship1:GetComponent('UIToggle'):Set(HNZZM_Data.trusteeship == 1)
	HNZZM_View.ToggleTrusteeship2:GetComponent('UIToggle'):Set(HNZZM_Data.trusteeship == 2)
	HNZZM_View.ToggleTrusteeship3:GetComponent('UIToggle'):Set(HNZZM_Data.trusteeship == 3)
	HNZZM_View.ToggleTrusteeship5:GetComponent('UIToggle'):Set(HNZZM_Data.trusteeship == 5)

	HNZZM_View.ToggleTrusteeshipOne.parent.gameObject:SetActive(HNZZM_Data.trusteeship ~= 0)
    HNZZM_View.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not HNZZM_Data.trusteeshipDissolve and HNZZM_Data.trusteeshipRound == 0)
    HNZZM_View.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(HNZZM_Data.trusteeshipDissolve == true)
    HNZZM_View.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(HNZZM_Data.trusteeshipRound == 3);
    HNZZM_View.ToggleTrusteeshipOne.parent.gameObject:SetActive(HNZZM_Data.trusteeship ~= 0)
    HNZZM_View.ToggleIPcheck:GetComponent('UIToggle'):Set(HNZZM_Data.openIp)
    HNZZM_View.ToggleGPScheck:GetComponent('UIToggle'):Set(HNZZM_Data.openGps)
    HNZZM_View.ToggleIPcheck.parent.gameObject:SetActive(HNZZM_Data.size > 2)

    HNZZM_View.ToggleChoiceDouble.parent.gameObject:SetActive(HNZZM_Data.size==2)
    HNZZM_View.ToggleMultiple2.parent.gameObject:SetActive(HNZZM_Data.size==2 and HNZZM_Data.choiceDouble)
    
	HNZZM_View.ToggleMultiple2:GetComponent('UIToggle'):Set(HNZZM_Data.multiple == 2)
	HNZZM_View.ToggleMultiple3:GetComponent('UIToggle'):Set(HNZZM_Data.multiple == 3)
	HNZZM_View.ToggleMultiple4:GetComponent('UIToggle'):Set(HNZZM_Data.multiple == 4)

	HNZZM_View.ToggleChoiceDouble:GetComponent('UIToggle'):Set(HNZZM_Data.choiceDouble)
	HNZZM_View.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not HNZZM_Data.choiceDouble)
	HNZZM_View.DoubleScoreText.parent.gameObject:SetActive(HNZZM_Data.choiceDouble)
	if HNZZM_Data.doubleScore == 0 then
		HNZZM_View.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		HNZZM_View.DoubleScoreText:GetComponent('UILabel').text = '小于'..HNZZM_Data.doubleScore..'分'
	end
    payLabel.text = GetPayMun(proxy_pb.HNZZM,HNZZM_Data.rounds,HNZZM_Data.size,nil)
    gameObject.transform:Find("table"):GetComponent("UIGrid"):Reposition();
end

function this.GetDataPrefab()
    HNZZM_Data.rounds               = UnityEngine.PlayerPrefs.GetInt("HNZZM_Rounds", 8);
    HNZZM_Data.size                 = UnityEngine.PlayerPrefs.GetInt("HNZZM_Size", 3);
    HNZZM_Data.paymentType          = UnityEngine.PlayerPrefs.GetInt("HNZZM_PayType", 0);
    HNZZM_Data.bankerRule           = UnityEngine.PlayerPrefs.GetInt("HNZZM_bankerRule",1) == 1;
    HNZZM_Data.huPattern            = UnityEngine.PlayerPrefs.GetInt("HNZZM_huPattern",1) == 1;
    HNZZM_Data.takeFeng             = UnityEngine.PlayerPrefs.GetInt("HNZZM_takeFeng",0) == 1;
    HNZZM_Data.takeHun              = UnityEngine.PlayerPrefs.GetInt("HNZZM_takeHun",1) == 1;
    HNZZM_Data.gangPao              = UnityEngine.PlayerPrefs.GetInt("HNZZM_gangPao",0) == 1;
    HNZZM_Data.bankerBase           = UnityEngine.PlayerPrefs.GetInt("HNZZM_bankerBase",0) == 1;
    HNZZM_Data.gangShangHuaJiaBei   = UnityEngine.PlayerPrefs.GetInt("HNZZM_gangShangHuaJiaBei",0) == 1;
    HNZZM_Data.qiDuiJiaBei          = UnityEngine.PlayerPrefs.GetInt("HNZZM_qiDuiJiaBei",0) == 1;
    HNZZM_Data.takHunMode           = UnityEngine.PlayerPrefs.GetInt("HNZZM_takHunMode",3);
    HNZZM_Data.selectPao            = UnityEngine.PlayerPrefs.GetInt("HNZZM_selectPao",-1);
    HNZZM_Data.selectPaoScore       = UnityEngine.PlayerPrefs.GetInt("HNZZM_selectPaoScore",2);


    HNZZM_Data.isSettlementScore    = UnityEngine.PlayerPrefs.GetInt('HNZZM_isSettlementScore', 0) == 1;
    HNZZM_Data.fewerValue           = UnityEngine.PlayerPrefs.GetInt('HNZZM_fewerValue', 10);
	HNZZM_Data.addValue             = UnityEngine.PlayerPrefs.GetInt('HNZZM_addValue', 10);
    HNZZM_Data.trusteeship          = UnityEngine.PlayerPrefs.GetInt("HNZZM_trusteeshipTime",0);
    HNZZM_Data.trusteeshipDissolve  = UnityEngine.PlayerPrefs.GetInt("HNZZM_trusteeshipType",0) == 1;
    HNZZM_Data.trusteeshipRound     = UnityEngine.PlayerPrefs.GetInt("HNZZM_trusteeshipRound",0);
    HNZZM_Data.openGps              = UnityEngine.PlayerPrefs.GetInt("HNZZM_openGps",0) == 1;
    HNZZM_Data.openIp               = UnityEngine.PlayerPrefs.GetInt("HNZZM_openIp",0) == 1; 
    HNZZM_Data.choiceDouble         = UnityEngine.PlayerPrefs.GetInt("HNZZM_choiceDouble",0) == 1
    HNZZM_Data.doubleScore          = UnityEngine.PlayerPrefs.GetInt("HNZZM_doubleScore",10)
    HNZZM_Data.multiple             = UnityEngine.PlayerPrefs.GetInt("HNZZM_multiple",2)
end

function this.OnClickRound(go)
    AudioManager.Instance:PlayAudio('btn')
    if go.gameObject == HNZZM_View.Round8Toggle.gameObject then
        HNZZM_Data.rounds = 8;
    elseif go.gameObject == HNZZM_View.Round12Toggle.gameObject then
        HNZZM_Data.rounds = 12;
    elseif go.gameObject == HNZZM_View.Round6Toggle.gameObject then 
        HNZZM_Data.rounds = 6;
    elseif go.gameObject == HNZZM_View.Round16Toggle.gameObject then 
        HNZZM_Data.rounds = 16;
    end
    payLabel.text = GetPayMun(proxy_pb.HNZZM,HNZZM_Data.rounds,HNZZM_Data.size,nil)
    UnityEngine.PlayerPrefs.SetInt("HNZZM_Rounds", HNZZM_Data.rounds);
end

function this.OnClickPeople(go)
    AudioManager.Instance:PlayAudio('btn');
    if go.gameObject == HNZZM_View.P2Toggle.gameObject then
        HNZZM_Data.size = 2;
    elseif go.gameObject == HNZZM_View.P3Toggle.gameObject then
        HNZZM_Data.size = 3;
    elseif go.gameObject == HNZZM_View.P4Toggle.gameObject then 
        HNZZM_Data.size = 4;
    end
    payLabel.text = GetPayMun(proxy_pb.HNZZM,HNZZM_Data.rounds,HNZZM_Data.size,nil)
    HNZZM_View.ToggleIPcheck.parent.gameObject:SetActive(HNZZM_Data.size > 2)
    UnityEngine.PlayerPrefs.SetInt("HNZZM_Size", HNZZM_Data.size)
    HNZZM_View.ToggleSettlementScoreSelect.parent.gameObject:SetActive(HNZZM_Data.size==2);
    HNZZM_View.ToggleChoiceDouble.parent.gameObject:SetActive(HNZZM_Data.size==2)
    HNZZM_View.ToggleMultiple2.parent.gameObject:SetActive(HNZZM_Data.size==2 and HNZZM_Data.choiceDouble)
	gameObject:Find('table'):GetComponent('UIGrid'):Reposition();
end

function this.OnClickPayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if go.gameObject == HNZZM_View.MasterPayToggle.gameObject then
        HNZZM_Data.paymentType = 0
    elseif go.gameObject == HNZZM_View.WinnerPayToggle.gameObject then
        HNZZM_Data.paymentType = 2
    end
    UnityEngine.PlayerPrefs.SetInt("HNZZM_PayType", HNZZM_Data.paymentType)
end

function this.OnClikWinType(go)
    AudioManager.Instance:PlayAudio('btn')
    if go == HNZZM_View.ToggleMustSelfMo.gameObject then 
        HNZZM_Data.huPattern = true;
    elseif go == HNZZM_View.ToggleCanDianPao.gameObject then 
        HNZZM_Data.huPattern = false;
    end
    UnityEngine.PlayerPrefs.SetInt("HNZZM_huPattern", HNZZM_Data.huPattern and 1 or 0);
end



function this.OnClickBankerType(go)
    AudioManager.Instance:PlayAudio('btn');
    if go == HNZZM_View.ToggleFirstRandomBanker.gameObject then 
        HNZZM_Data.bankerRule = true;
    elseif go == HNZZM_View.ToggleFirstIsBanker.gameObject then 
        HNZZM_Data.bankerRule = false;
    end

    UnityEngine.PlayerPrefs.SetInt("HNZZM_bankerRule", HNZZM_Data.bankerRule and 1 or 0);

end



function this.OnClickTrusteeshipTime(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == HNZZM_View.ToggleTrusteeshipNo.gameObject then
		HNZZM_Data.trusteeship = 0
	elseif go == HNZZM_View.ToggleTrusteeship1.gameObject then
        HNZZM_Data.trusteeship = 1
    elseif go == HNZZM_View.ToggleTrusteeship2.gameObject then
		HNZZM_Data.trusteeship = 2
	elseif go == HNZZM_View.ToggleTrusteeship3.gameObject then
		HNZZM_Data.trusteeship = 3
	elseif go == HNZZM_View.ToggleTrusteeship5.gameObject then
		HNZZM_Data.trusteeship = 5
    end
    UnityEngine.PlayerPrefs.SetInt("HNZZM_trusteeshipTime", HNZZM_Data.trusteeship)
    HNZZM_View.ToggleTrusteeshipOne.parent.gameObject:SetActive(HNZZM_Data.trusteeship ~= 0)
    gameObject.transform:Find("table"):GetComponent("UIGrid"):Reposition();
end

function this.OnClickTrusteeshipType(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == HNZZM_View.ToggleTrusteeshipAll.gameObject then
        HNZZM_Data.trusteeshipDissolve = false;
        HNZZM_Data.trusteeshipRound = 0;
	elseif go == HNZZM_View.ToggleTrusteeshipOne.gameObject then
        HNZZM_Data.trusteeshipDissolve = true;
        HNZZM_Data.trusteeshipRound = 0;
    elseif go == HNZZM_View.ToggleTrusteeshipThree.gameObject then 
        HNZZM_Data.trusteeshipDissolve = false;
        HNZZM_Data.trusteeshipRound = 3;
    end
    UnityEngine.PlayerPrefs.SetInt("HNZZM_trusteeshipType",HNZZM_Data.trusteeshipDissolve and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("HNZZM_trusteeshipRound",HNZZM_Data.trusteeshipRound);
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if HNZZM_View.ToggleIPcheck.gameObject == go then
		HNZZM_Data.openIp = HNZZM_View.ToggleIPcheck:GetComponent('UIToggle').value
	elseif HNZZM_View.ToggleGPScheck.gameObject == go then
		HNZZM_Data.openGps = HNZZM_View.ToggleGPScheck:GetComponent('UIToggle').value
    end
    UnityEngine.PlayerPrefs.SetInt("HNZZM_openIp",HNZZM_Data.openIp and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("HNZZM_openGps",HNZZM_Data.openGps and 1 or 0);
end

function this.GetConfig()
	
	local moneyLess = false;
    HNZZM_Data.takeFeng             = HNZZM_View.ToggleWithOutWind:GetComponent("UIToggle").value;
    HNZZM_Data.takeHun              = HNZZM_View.ToggleTakeHun:GetComponent("UIToggle").value;
    HNZZM_Data.gangPao              = HNZZM_View.ToggleGangAndRun:GetComponent("UIToggle").value;
    HNZZM_Data.bankerBase           = HNZZM_View.ToggleZhuangAddBase:GetComponent("UIToggle").value;
    HNZZM_Data.gangShangHuaJiaBei   = HNZZM_View.ToggleGangHuaDouble:GetComponent("UIToggle").value;
    HNZZM_Data.qiDuiJiaBei          = HNZZM_View.ToggleQiduiDouble:GetComponent("UIToggle").value;
    

    UnityEngine.PlayerPrefs.SetInt("HNZZM_takeFeng",            HNZZM_Data.takeFeng and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("HNZZM_takeHun",             HNZZM_Data.takeHun and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("HNZZM_gangPao",             HNZZM_Data.gangPao and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("HNZZM_bankerBase",          HNZZM_Data.bankerBase and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("HNZZM_gangShangHuaJiaBei",  HNZZM_Data.gangShangHuaJiaBei and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("HNZZM_qiDuiJiaBei",         HNZZM_Data.qiDuiJiaBei and 1 or 0);

    local settings                  = {}
    settings.roomType               = proxy_pb.HNZZM;
    settings.rounds                 = HNZZM_Data.rounds;
    settings.size                   = HNZZM_Data.size;
    settings.paymentType            = HNZZM_Data.paymentType;
    settings.bankerRule             = HNZZM_Data.bankerRule;  
    settings.huPattern              = HNZZM_Data.huPattern;   
    settings.takeFeng               = HNZZM_Data.takeFeng;   
    settings.takeHun                = HNZZM_Data.takeHun;   
    settings.gangPao                = HNZZM_Data.gangPao;   
    settings.bankerBase             = HNZZM_Data.bankerBase;   
    settings.gangShangHuaJiaBei     = HNZZM_Data.gangShangHuaJiaBei;   
    settings.qiDuiJiaBei            = HNZZM_Data.qiDuiJiaBei; 
    settings.takHunMode             = HNZZM_Data.takeHun and HNZZM_Data.takHunMode or 0;   
    settings.selectPao              = HNZZM_Data.selectPao;
    settings.selectPaoScore         = HNZZM_Data.selectPao == -1 and HNZZM_Data.selectPaoScore or 0;
    
    settings.resultScore            = this.getResultScore(HNZZM_Data);
    settings.resultLowerScore       = this.getResultLowerScore(HNZZM_Data);
    settings.resultAddScore         = this.getResultAddScore(HNZZM_Data);
    settings.trusteeship            = HNZZM_Data.trusteeship * 60;
    settings.trusteeshipDissolve    = HNZZM_Data.trusteeshipDissolve;
    settings.trusteeshipRound       = HNZZM_Data.trusteeshipRound;
    settings.openIp                 = HNZZM_Data.openIp;
    settings.openGps                = HNZZM_Data.openGps;
    if HNZZM_Data.size == 2 then
        settings.openIp =false;
        settings.openGps = false;
        settings.choiceDouble          = HNZZM_Data.choiceDouble; 
        settings.doubleScore           = HNZZM_Data.doubleScore; 
        settings.multiple              = HNZZM_Data.multiple; 
    end
    print("settings------");
    print_r(settings);
    return moneyLess,settings;
    
end

function this.getResultScore(HNZZM_Data)
    if HNZZM_Data.size == 2 then 
        return HNZZM_Data.isSettlementScore;
    end
    return nil;
end

function this.getResultLowerScore(HNZZM_Data)
    if HNZZM_Data.size == 2 then 
        if HNZZM_Data.isSettlementScore then 
            return HNZZM_Data.fewerValue;
        end
    end
    
    return nil;
end

function this.getResultAddScore(HNZZM_Data)
    if HNZZM_Data.size == 2 then 
        if HNZZM_Data.isSettlementScore then 
            return HNZZM_Data.addValue;
        end
    end
    
    return nil;
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    HNZZM_Data.isSettlementScore= HNZZM_View.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt("HNZZM_isSettlementScore", HNZZM_Data.isSettlementScore and 1 or 0)
end


function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if HNZZM_View.ToggleFewerAddButton.gameObject == go then
		HNZZM_Data.fewerValue = HNZZM_Data.fewerValue + 1
		if HNZZM_Data.fewerValue > 100 then
			HNZZM_Data.fewerValue = 100
		end
    elseif HNZZM_View.ToggleFewerSubtractButton.gameObject == go then
		HNZZM_Data.fewerValue = HNZZM_Data.fewerValue - 1
		if HNZZM_Data.fewerValue < 1 then
			HNZZM_Data.fewerValue = 1
		end
	end
	HNZZM_View.ToggleFewerScoreTxt:GetComponent('UILabel').text = HNZZM_Data.fewerValue.."分";
	UnityEngine.PlayerPrefs.SetInt("HNZZM_fewerValue", HNZZM_Data.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if HNZZM_View.ToggleAddAddButton.gameObject == go then
		HNZZM_Data.addValue = HNZZM_Data.addValue + 1
		if HNZZM_Data.addValue > 100 then
			HNZZM_Data.addValue = 100
		end
    elseif HNZZM_View.ToggleAddSubtractButton.gameObject == go then
		HNZZM_Data.addValue = HNZZM_Data.addValue - 1
		if HNZZM_Data.addValue < 1 then
			HNZZM_Data.addValue = 1
		end
	end
	HNZZM_View.ToggleAddScoreTxt:GetComponent('UILabel').text = HNZZM_Data.addValue.."分";
	UnityEngine.PlayerPrefs.SetInt("HNZZM_addValue", HNZZM_Data.addValue)
end

function this.OnClickChoiceDouble(go)
    AudioManager.Instance:PlayAudio('btn')
	if HNZZM_View.ToggleChoiceDouble.gameObject == go then
		HNZZM_Data.choiceDouble = true
	else
		HNZZM_Data.choiceDouble = false
	end
	HNZZM_View.DoubleScoreText.parent.gameObject:SetActive(HNZZM_Data.choiceDouble)
    HNZZM_View.ToggleMultiple2.parent.gameObject:SetActive(HNZZM_Data.choiceDouble)
    if HNZZM_Data.choiceDouble then
		HNZZM_View.ToggleMultiple2:GetComponent('UIToggle'):Set(HNZZM_Data.multiple == 2)
		HNZZM_View.ToggleMultiple3:GetComponent('UIToggle'):Set(HNZZM_Data.multiple == 3)
		HNZZM_View.ToggleMultiple4:GetComponent('UIToggle'):Set(HNZZM_Data.multiple == 4)
	end
    gameObject:Find('table'):GetComponent('UIGrid'):Reposition();
    UnityEngine.PlayerPrefs.SetInt("HNZZM_choiceDouble", HNZZM_Data.choiceDouble and 1 or 0)
end

function this.OnClickChangeDoubleScore(go)
    AudioManager.Instance:PlayAudio('btn')
    local label_= HNZZM_View.DoubleScoreText:GetComponent('UILabel').text
    if label_=='不限分' then
        HNZZM_Data.doubleScore=0
    else
        HNZZM_Data.doubleScore=tonumber(string.sub(label_,7,-4))    
    end
	if HNZZM_View.AddDoubleScoreButton.gameObject == go then
		if HNZZM_Data.doubleScore ~= 0 then
			HNZZM_Data.doubleScore = HNZZM_Data.doubleScore + 1
			if HNZZM_Data.doubleScore > 100 then
				HNZZM_Data.doubleScore = 0
			end
		end
	else
		if HNZZM_Data.doubleScore == 0 then
			HNZZM_Data.doubleScore = 100
		else
			HNZZM_Data.doubleScore = HNZZM_Data.doubleScore - 1
			if HNZZM_Data.doubleScore < 1 then
				HNZZM_Data.doubleScore = 1
			end
		end
	end

	if HNZZM_Data.doubleScore == 0 then
		HNZZM_View.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		HNZZM_View.DoubleScoreText:GetComponent('UILabel').text = '小于'..HNZZM_Data.doubleScore..'分'
    end
    UnityEngine.PlayerPrefs.SetInt("HNZZM_doubleScore", HNZZM_Data.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
    HNZZM_Data.multiple = tonumber(go.name)
    UnityEngine.PlayerPrefs.SetInt("HNZZM_multiple", HNZZM_Data.multiple)
end

function this.OnClikTakeHun(go)
    HNZZM_View.ToggleUPHun.parent.gameObject:SetActive(go.transform:GetComponent("UIToggle").value);
    gameObject.transform:Find("table"):GetComponent("UIGrid"):Reposition();
end

function this.OnClickHunChoice(go)
    AudioManager.Instance:PlayAudio('btn');
    if go == HNZZM_View.ToggleUPHun.gameObject then 
        HNZZM_Data.takHunMode = 1;
    elseif go == HNZZM_View.ToggleMidHun.gameObject then 
        HNZZM_Data.takHunMode = 2;
    elseif go == HNZZM_View.ToggleDownHun.gameObject then 
        HNZZM_Data.takHunMode = 3;
    elseif go == HNZZM_View.ToggleDoubleHun.gameObject then 
        HNZZM_Data.takHunMode = 4;
    end
    UnityEngine.PlayerPrefs.SetInt("HNZZM_takHunMode", HNZZM_Data.takHunMode);
    
end

function this.OnClickRunScoreType(go)
    if go == HNZZM_View.ToggleFreeChoice.gameObject then 
        HNZZM_View.ToggleRunScore1_3.gameObject:SetActive(true);
        HNZZM_View.ToggleRunScore1_5.gameObject:SetActive(true);
        HNZZM_View.RunScoreTxt.parent.gameObject:SetActive(false);
        HNZZM_Data.selectPaoScore = HNZZM_Data.selectPaoScore == 0 and 1 or HNZZM_Data.selectPaoScore;
        HNZZM_View.ToggleRunScore1_3:GetComponent("UIToggle"):Set(HNZZM_Data.selectPaoScore == 1);
        HNZZM_View.ToggleRunScore1_5:GetComponent("UIToggle"):Set(HNZZM_Data.selectPaoScore == 2);
        HNZZM_Data.selectPao = -1;
    elseif go == HNZZM_View.ToggleSteadyChoice.gameObject then 
        HNZZM_View.ToggleRunScore1_3.gameObject:SetActive(false);
        HNZZM_View.ToggleRunScore1_5.gameObject:SetActive(false);
        HNZZM_View.RunScoreTxt.parent.gameObject:SetActive(true);
        HNZZM_Data.selectPao = HNZZM_Data.selectPao == -1 and 0 or HNZZM_Data.selectPao;
        HNZZM_View.RunScoreTxt:GetComponent("UILabel").text = HNZZM_Data.selectPao == 0 and "不跑" or "跑"..HNZZM_Data.selectPao;
        
    end
    UnityEngine.PlayerPrefs.SetInt("HNZZM_selectPao", HNZZM_Data.selectPao)
    UnityEngine.PlayerPrefs.SetInt("HNZZM_selectPaoScore", HNZZM_Data.selectPaoScore)
end

function this.OnClickRunScoreChoice(go)
    if go == HNZZM_View.ToggleRunScore1_3.gameObject then 
        HNZZM_Data.selectPaoScore = 1;
    elseif go == HNZZM_View.ToggleRunScore1_5.gameObject then 
        HNZZM_Data.selectPaoScore = 2;
    end
    UnityEngine.PlayerPrefs.SetInt("HNZZM_selectPaoScore", HNZZM_Data.selectPaoScore)
end

function this.OnClickRunScoreChange(go)
    if go == HNZZM_View.RunScoreAddButton.gameObject then 
        HNZZM_Data.selectPao = HNZZM_Data.selectPao + 1;
        if HNZZM_Data.selectPao > 10 then 
            HNZZM_Data.selectPao = 10;
        end
    elseif go == HNZZM_View.RunScoreSubtractButton.gameObject then 
        HNZZM_Data.selectPao = HNZZM_Data.selectPao - 1;
        if HNZZM_Data.selectPao < 0 then 
            HNZZM_Data.selectPao = 0;
        end
    end
    HNZZM_View.RunScoreTxt:GetComponent("UILabel").text = HNZZM_Data.selectPao == 0 and "不跑" or "跑"..HNZZM_Data.selectPao
    UnityEngine.PlayerPrefs.SetInt("HNZZM_selectPao", HNZZM_Data.selectPao)
end

return this;

