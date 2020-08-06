
panelCreateHNHSMSet              = {}
require("proxy_pb")
local json = require("json")
local this = panelCreateHNHSMSet;
local message;
local gameObject;
local payLabel
local HNHSM_View = {}
local HNHSM_Data = {}
local optionData = {};
local curSelectPlay = {}

function this.Awake(go)
    print("Awake was called");
    gameObject                              = go;
    message                                 = gameObject:GetComponent('LuaBehaviour');
    payLabel                                = gameObject.transform:Find('pay_label'):GetComponent('UILabel')

    HNHSM_View.RuleButton                   = gameObject.transform:Find('RuleButton');
    local HNHSMPanel                        = gameObject.transform:Find("HNHSMPanel/table");
    HNHSM_View.wanFaTitle                   = gameObject.transform:Find("title/Label");

    --局数选择             
    HNHSM_View.Round6Toggle                 = HNHSMPanel.transform:Find("ToggleRoundGroup/ToggleRound6");
    HNHSM_View.Round8Toggle                 = HNHSMPanel.transform:Find("ToggleRoundGroup/ToggleRound8");
    HNHSM_View.Round12Toggle                = HNHSMPanel.transform:Find("ToggleRoundGroup/ToggleRound12");
    HNHSM_View.Round16Toggle                = HNHSMPanel.transform:Find("ToggleRoundGroup1/ToggleRound16");
    --人数选择             
    HNHSM_View.P2Toggle                     = HNHSMPanel.transform:Find("TogglePeopleGroup/Toggle2P");
    HNHSM_View.P3Toggle                     = HNHSMPanel.transform:Find("TogglePeopleGroup/Toggle3P");
    HNHSM_View.P4Toggle                     = HNHSMPanel.transform:Find("TogglePeopleGroup/Toggle4P");
    --开房模式             
    HNHSM_View.MasterPayToggle              = HNHSMPanel.transform:Find('TogglePayTypeGroup/ToggleMasterPay');
    HNHSM_View.WinnerPayToggle              = HNHSMPanel.transform:Find('TogglePayTypeGroup/ToggleWinnerPay');
    --坐庄规则  
    HNHSM_View.ToggleFirstRandomBanker      = HNHSMPanel.transform:Find('ToggleBankTypeGroup/ToggleFirstRandomBanker');
    HNHSM_View.ToggleFirstIsBanker          = HNHSMPanel.transform:Find('ToggleBankTypeGroup/ToggleFirstIsBanker');
    --胡牌方式          
    HNHSM_View.ToggleMustSelfMo             = HNHSMPanel.transform:Find('ToggleWinTypeGroup/ToggleMustSelfMo');
    HNHSM_View.ToggleCanDianPao             = HNHSMPanel.transform:Find('ToggleWinTypeGroup/ToggleCanDianPao');
    --个性玩法          
    HNHSM_View.ToggleWithOutWind               = HNHSMPanel.transform:Find("TogglePlayTypeGroup/ToggleWithOutWind")
	HNHSM_View.ToggleQYS					   = HNHSMPanel.transform:Find("TogglePlayTypeGroup/ToggleQingYiShe")
	HNHSM_View.ToggleDPDG3					   = HNHSMPanel.transform:Find("TogglePlayTypeGroup/TogglDianPaoGang3")
	
	HNHSM_View.ToggleHZFB                      = HNHSMPanel.transform:Find("TogglePlayTypeGroup1/ToggleHunagZhuangFanBei")
	HNHSM_View.ToggleHongzhongLZ               = HNHSMPanel.transform:Find("TogglePlayTypeGroup1/ToggleHongzhongLZ")
	HNHSM_View.ToggleLZRYD                     = HNHSMPanel.transform:Find("TogglePlayTypeGroup1/ToggleLZRYD")
	
    HNHSM_View.ToggleHZBHG               	   = HNHSMPanel.transform:Find("TogglePlayTypeGroup2/ToggleBuHuangGang")
    HNHSM_View.ToggleGenZhuang                 = HNHSMPanel.transform:Find("TogglePlayTypeGroup2/ToggleGenZhuang")
    HNHSM_View.ToggleQGH                       = HNHSMPanel.transform:Find("TogglePlayTypeGroup2/ToggleQGH")
	
    HNHSM_View.ToggleMissHuOnlySelfMo          = HNHSMPanel.transform:Find("TogglePlayTypeGroup3/ToggleMissHuOnlySelfMo")
    --抓鱼  
    HNHSM_View.ToggleNoZhuayu               = HNHSMPanel.transform:Find("ToggleZhuaYuGroup/ToggleNoZhuayu");
    HNHSM_View.ToggleZhuayu                 = HNHSMPanel.transform:Find("ToggleZhuaYuGroup/ToggleZhuayu");
	HNHSM_View.zhuayuScoreText              = HNHSMPanel.transform:Find('ToggleZhuaYuGroup/zhuayuScore/Value')
	HNHSM_View.AddzhuayuScoreButton         = HNHSMPanel.transform:Find('ToggleZhuaYuGroup/zhuayuScore/AddButton')
    HNHSM_View.SubtractzhuayuScoreButton    = HNHSMPanel.transform:Find('ToggleZhuaYuGroup/zhuayuScore/SubtractButton')

    --流局结算         
    HNHSM_View.Togglepeigang                = HNHSMPanel.transform:Find("ToggleLiuJuGroup/Togglepeigang");
    HNHSM_View.ToggleJieSuanGang            = HNHSMPanel.transform:Find("ToggleLiuJuGroup/ToggleJieSuanGang");
    HNHSM_View.ToggleNoJieSuanGang          = HNHSMPanel.transform:Find("ToggleLiuJuGroup/ToggleNoJieSuanGang");
    --2人结算低于多少分加
    HNHSM_View.ToggleSettlementScoreSelect  = HNHSMPanel:Find('settlementScore/select')
	HNHSM_View.ToggleFewerScoreTxt          = HNHSMPanel:Find('settlementScore/fewerValue/Value')
	HNHSM_View.ToggleFewerAddButton         = HNHSMPanel:Find('settlementScore/fewerValue/AddButton')
	HNHSM_View.ToggleFewerSubtractButton    = HNHSMPanel:Find('settlementScore/fewerValue/SubtractButton')
	HNHSM_View.ToggleAddScoreTxt            = HNHSMPanel:Find('settlementScore/addValue/Value')
	HNHSM_View.ToggleAddAddButton           = HNHSMPanel:Find('settlementScore/addValue/AddButton')
	HNHSM_View.ToggleAddSubtractButton      = HNHSMPanel:Find('settlementScore/addValue/SubtractButton')
    HNHSM_View.ToggleTrusteeshipNo          = HNHSMPanel.transform:Find('ToggleTrusteeship/ToggleNo');
	HNHSM_View.ToggleTrusteeship1           = HNHSMPanel.transform:Find('ToggleTrusteeship/Toggle1Minute');
	HNHSM_View.ToggleTrusteeship2           = HNHSMPanel.transform:Find('ToggleTrusteeship/Toggle2Minute');
	HNHSM_View.ToggleTrusteeship3           = HNHSMPanel.transform:Find('ToggleTrusteeship/Toggle3Minute');
	HNHSM_View.ToggleTrusteeship5           = HNHSMPanel.transform:Find('ToggleTrusteeship1/Toggle5Minute');
	HNHSM_View.ToggleTrusteeshipAll         = HNHSMPanel.transform:Find('ToggleTrusteeshipType/ToggleAll');
    HNHSM_View.ToggleTrusteeshipOne         = HNHSMPanel.transform:Find('ToggleTrusteeshipType/ToggleOne');
    HNHSM_View.ToggleTrusteeshipThree       = HNHSMPanel.transform:Find('ToggleTrusteeshipType/ToggleThree');
    HNHSM_View.ToggleIPcheck                = HNHSMPanel.transform:Find('PreventCheat/IPcheck')
    HNHSM_View.ToggleGPScheck               = HNHSMPanel.transform:Find('PreventCheat/GPScheck')
    --2人翻倍
    HNHSM_View.ToggleMultiple2              = HNHSMPanel.transform:Find('multiple/2')
	HNHSM_View.ToggleMultiple3              = HNHSMPanel.transform:Find('multiple/3')
	HNHSM_View.ToggleMultiple4              = HNHSMPanel.transform:Find('multiple/4')

	HNHSM_View.ToggleChoiceDouble            = HNHSMPanel.transform:Find('choiceDouble/On')
	HNHSM_View.ToggleNoChoiceDouble          = HNHSMPanel.transform:Find('choiceDouble/Off')
	HNHSM_View.DoubleScoreText               = HNHSMPanel.transform:Find('choiceDouble/doubleScore/Value')
	HNHSM_View.AddDoubleScoreButton          = HNHSMPanel.transform:Find('choiceDouble/doubleScore/AddButton')
    HNHSM_View.SubtractDoubleScoreButton     = HNHSMPanel.transform:Find('choiceDouble/doubleScore/SubtractButton')

    message:AddClick(HNHSM_View.ToggleChoiceDouble.gameObject,          this.OnClickChoiceDouble)
	message:AddClick(HNHSM_View.ToggleNoChoiceDouble.gameObject,        this.OnClickChoiceDouble)
	message:AddClick(HNHSM_View.AddDoubleScoreButton.gameObject,        this.OnClickChangeDoubleScore)
	message:AddClick(HNHSM_View.SubtractDoubleScoreButton.gameObject,   this.OnClickChangeDoubleScore)

	message:AddClick(HNHSM_View.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(HNHSM_View.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(HNHSM_View.ToggleMultiple4.gameObject, this.OnClickMultiple)
    
    message:AddClick(HNHSM_View.Round6Toggle.gameObject,     this.OnClickRound);
    message:AddClick(HNHSM_View.Round8Toggle.gameObject,     this.OnClickRound);
    message:AddClick(HNHSM_View.Round12Toggle.gameObject,    this.OnClickRound);
    message:AddClick(HNHSM_View.Round16Toggle.gameObject,    this.OnClickRound);
    
    message:AddClick(HNHSM_View.P2Toggle.gameObject,     this.OnClickPeople);
    message:AddClick(HNHSM_View.P3Toggle.gameObject,     this.OnClickPeople);
    message:AddClick(HNHSM_View.P4Toggle.gameObject,     this.OnClickPeople);

    message:AddClick(HNHSM_View.MasterPayToggle.gameObject,  this.OnClickPayType);
    message:AddClick(HNHSM_View.WinnerPayToggle.gameObject,  this.OnClickPayType);

    message:AddClick(HNHSM_View.ToggleFirstIsBanker.gameObject,      this.OnClickBankerType);
    message:AddClick(HNHSM_View.ToggleFirstRandomBanker.gameObject,  this.OnClickBankerType);

    message:AddClick(HNHSM_View.ToggleMustSelfMo.gameObject,     this.OnClikWinType);
    message:AddClick(HNHSM_View.ToggleCanDianPao.gameObject,     this.OnClikWinType);
	
	message:AddClick(HNHSM_View.ToggleHongzhongLZ.gameObject,     this.OnClikLZType);

    message:AddClick(HNHSM_View.ToggleNoZhuayu.gameObject,              this.OnClickZhuayu);
    message:AddClick(HNHSM_View.ToggleZhuayu.gameObject,                this.OnClickZhuayu);
    message:AddClick(HNHSM_View.AddzhuayuScoreButton.gameObject,        this.OnClickChangeZhuayuScore);
    message:AddClick(HNHSM_View.SubtractzhuayuScoreButton.gameObject,   this.OnClickChangeZhuayuScore);
   

    message:AddClick(HNHSM_View.ToggleSettlementScoreSelect.gameObject,  this.OnClickSettlementScoreSelect)
	message:AddClick(HNHSM_View.ToggleFewerAddButton.gameObject,         this.OnClickFewerButton)
	message:AddClick(HNHSM_View.ToggleFewerSubtractButton.gameObject,    this.OnClickFewerButton)
	message:AddClick(HNHSM_View.ToggleAddAddButton.gameObject,           this.OnClickAddButton)
	message:AddClick(HNHSM_View.ToggleAddSubtractButton.gameObject,      this.OnClickAddButton)
    
 
    message:AddClick(HNHSM_View.ToggleTrusteeshipNo.gameObject,          this.OnClickTrusteeshipTime)
	message:AddClick(HNHSM_View.ToggleTrusteeship1.gameObject,           this.OnClickTrusteeshipTime)
	message:AddClick(HNHSM_View.ToggleTrusteeship2.gameObject,           this.OnClickTrusteeshipTime)
	message:AddClick(HNHSM_View.ToggleTrusteeship3.gameObject,           this.OnClickTrusteeshipTime)
	message:AddClick(HNHSM_View.ToggleTrusteeship5.gameObject,           this.OnClickTrusteeshipTime)
	message:AddClick(HNHSM_View.ToggleTrusteeshipOne.gameObject,         this.OnClickTrusteeshipType)
    message:AddClick(HNHSM_View.ToggleTrusteeshipAll.gameObject,         this.OnClickTrusteeshipType)
    message:AddClick(HNHSM_View.ToggleTrusteeshipThree.gameObject,       this.OnClickTrusteeshipType)

    message:AddClick(HNHSM_View.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(HNHSM_View.ToggleGPScheck.gameObject, this.OnClickPreventCheat)

    message:AddClick(HNHSM_View.RuleButton.gameObject, this.OnShowRuleInfo);

    local closeBtn = gameObject.transform:Find("BaseContent/ButtonClose");
    message:AddClick(closeBtn.gameObject, function(go) 
        AudioManager.Instance:PlayAudio('btn');
        PanelManager.Instance:HideWindow(gameObject.name);
    end)

    local buttonOK = gameObject.transform:Find("ButtonOK/Background");
    message:AddClick(buttonOK.gameObject, this.OnClickOk)
end

function this.Update()
            
end

function this.Start()

end



function this.WhoShow(data)
    print("panelCreateHNHSMSet's WhoShow was called----------->");
    if data.optionData ~= nil then
        optionData           = data.optionData;
        optionData.playId    = data.playId;
        optionData.ruleId    = data.ruleId;
    end
    local HNHSMPanel         = gameObject.transform:Find("HNHSMPanel");
    this.OnEnableRefresh(data);
    HNHSMPanel:Find("table"):GetComponent("UIGrid"):Reposition();
    HNHSMPanel:GetComponent("UIScrollView"):ResetPosition();
end

function this.OnEnableRefresh(data)
    local titleStr = ''
    curSelectPlay = {}
    
    if optionData.addRule or optionData.addPlay then
        titleStr = '当前玩法：'..'划水麻将';
        curSelectPlay = HNHSM_Data;
        print("path--------->1");
    elseif not optionData.addPlay and not optionData.addRule then
        print("path---------->2");
        print("data.settings------>:"..data.settings);
        curSelectPlay = json:decode(data.settings)
        titleStr = '当前规则：'..GetHNHSMRuleText(curSelectPlay, false, false);
        if curSelectPlay.trusteeship == nil then
            curSelectPlay.trusteeship = 0
        end
        if curSelectPlay.trusteeshipDissolve == nil then
            curSelectPlay.trusteeshipDissolve = true
        end
        if curSelectPlay.trusteeshipRound == nil then
            curSelectPlay.trusteeshipRound = 0;
        end

        if curSelectPlay.resultScore == nil or curSelectPlay.resultScore == false then
			curSelectPlay.resultScore =false
			curSelectPlay.resultLowerScore = 10
            curSelectPlay.resultAddScore = 10
        end
        this.SetSetting(curSelectPlay);

    end

    HNHSM_View.wanFaTitle:GetComponent('UILabel').text = titleStr;
    print("HNHSM_View.wanFaTitle----->"..tostring(HNHSM_View.wanFaTitle));

    this.SetPreSetting(curSelectPlay)
    payLabel.text = GetPayMun(proxy_pb.HNHSM,curSelectPlay.rounds,curSelectPlay.size,nil)
end

function this.SetPreSetting(settings)
    HNHSM_View.Round6Toggle:GetComponent("UIToggle"):Set(settings.rounds == 6);
    HNHSM_View.Round8Toggle:GetComponent("UIToggle"):Set(settings.rounds == 8);
    HNHSM_View.Round12Toggle:GetComponent("UIToggle"):Set(settings.rounds == 12);
    HNHSM_View.Round16Toggle:GetComponent("UIToggle"):Set(settings.rounds == 16);

    HNHSM_View.P2Toggle:GetComponent("UIToggle"):Set(settings.size == 2);
    HNHSM_View.P3Toggle:GetComponent("UIToggle"):Set(settings.size == 3);
    HNHSM_View.P4Toggle:GetComponent("UIToggle"):Set(settings.size == 4);

    HNHSM_View.MasterPayToggle:GetComponent("UIToggle"):Set(settings.paymentType == 0)
    HNHSM_View.WinnerPayToggle:GetComponent("UIToggle"):Set(settings.paymentType == 2)

    HNHSM_View.ToggleFirstRandomBanker:GetComponent("UIToggle"):Set(settings.bankerRule);
    HNHSM_View.ToggleFirstIsBanker:GetComponent("UIToggle"):Set(not settings.bankerRule);

    HNHSM_View.ToggleMustSelfMo:GetComponent("UIToggle"):Set(settings.huPattern);
    HNHSM_View.ToggleCanDianPao:GetComponent("UIToggle"):Set(not settings.huPattern);

    HNHSM_View.ToggleWithOutWind:GetComponent("UIToggle"):Set(HNHSM_Data.takeFeng)
	HNHSM_View.ToggleQYS:GetComponent("UIToggle"):Set(HNHSM_Data.qys)
	HNHSM_View.ToggleDPDG3:GetComponent("UIToggle"):Set(HNHSM_Data.dpdg3)
	
	HNHSM_View.ToggleHZFB:GetComponent("UIToggle"):Set(HNHSM_Data.hzfb)
    HNHSM_View.ToggleHongzhongLZ:GetComponent("UIToggle"):Set(HNHSM_Data.variableHongZhong)
	HNHSM_View.ToggleLZRYD:GetComponent("UIToggle"):Set(HNHSM_Data.lzryd)
	
	HNHSM_View.ToggleHZBHG:GetComponent("UIToggle"):Set(HNHSM_Data.hzbhg)
    HNHSM_View.ToggleGenZhuang:GetComponent("UIToggle"):Set(HNHSM_Data.openGenBanker)
    HNHSM_View.ToggleQGH:GetComponent("UIToggle"):Set(HNHSM_Data.qiangGangHu)
	
    HNHSM_View.ToggleMissHuOnlySelfMo:GetComponent("UIToggle"):Set(HNHSM_Data.flodHuNoJiePao)
	
    HNHSM_View.ToggleQGH.gameObject:SetActive(not settings.huPattern);
    HNHSM_View.ToggleMissHuOnlySelfMo.gameObject:SetActive(not settings.huPattern);

    HNHSM_View.ToggleNoZhuayu:GetComponent("UIToggle"):Set(settings.zhuaYu == 0);
    HNHSM_View.ToggleZhuayu:GetComponent("UIToggle"):Set(settings.zhuaYu > 0);
    HNHSM_View.zhuayuScoreText:GetComponent("UILabel").text = "抓"..settings.zhuaYu.."条鱼";
    HNHSM_View.zhuayuScoreText.parent.gameObject:SetActive(settings.zhuaYu ~= 0);


    HNHSM_View.ToggleSettlementScoreSelect.parent.gameObject:SetActive(settings.size==2)
    HNHSM_View.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(settings.resultScore)
	HNHSM_View.ToggleFewerScoreTxt:GetComponent('UILabel').text = settings.resultLowerScore.."分"
	HNHSM_View.ToggleAddScoreTxt:GetComponent('UILabel').text = settings.resultAddScore.."分"


    HNHSM_View.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(settings.trusteeship == 0)
	HNHSM_View.ToggleTrusteeship1:GetComponent('UIToggle'):Set(settings.trusteeship == 60)
	HNHSM_View.ToggleTrusteeship2:GetComponent('UIToggle'):Set(settings.trusteeship == 120)
	HNHSM_View.ToggleTrusteeship3:GetComponent('UIToggle'):Set(settings.trusteeship == 180)
	HNHSM_View.ToggleTrusteeship5:GetComponent('UIToggle'):Set(settings.trusteeship == 300)

	HNHSM_View.ToggleTrusteeshipOne.parent.gameObject:SetActive(settings.trusteeship ~= 0)
    HNHSM_View.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not settings.trusteeshipDissolve and settings.trusteeshipRound == 0)
    HNHSM_View.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(settings.trusteeshipDissolve == true)
    HNHSM_View.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(settings.trusteeshipRound == 3);
    HNHSM_View.ToggleTrusteeshipOne.parent.gameObject:SetActive(settings.trusteeship ~= 0)
    HNHSM_View.ToggleIPcheck:GetComponent('UIToggle'):Set(settings.openIp)
    HNHSM_View.ToggleGPScheck:GetComponent('UIToggle'):Set(settings.openGps)
    HNHSM_View.ToggleIPcheck.parent.gameObject:SetActive(settings.size > 2)

    if settings.choiceDouble == nil then
        settings.choiceDouble = false
        settings.doubleScore = 10
        settings.multiple = 2
    end

    HNHSM_View.ToggleChoiceDouble.parent.gameObject:SetActive(settings.size==2)
    HNHSM_View.ToggleMultiple2.parent.gameObject:SetActive(settings.size==2 and settings.choiceDouble)
    
	HNHSM_View.ToggleMultiple2:GetComponent('UIToggle'):Set(settings.multiple == 2)
	HNHSM_View.ToggleMultiple3:GetComponent('UIToggle'):Set(settings.multiple == 3)
	HNHSM_View.ToggleMultiple4:GetComponent('UIToggle'):Set(settings.multiple == 4)

	HNHSM_View.ToggleChoiceDouble:GetComponent('UIToggle'):Set(settings.choiceDouble)
	HNHSM_View.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not settings.choiceDouble)
	HNHSM_View.DoubleScoreText.parent.gameObject:SetActive(settings.choiceDouble)
	if settings.doubleScore == 0 then
		HNHSM_View.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		HNHSM_View.DoubleScoreText:GetComponent('UILabel').text = '小于'..settings.doubleScore..'分'
	end
end

function this.OnEnable()
    print("OnEnable was called");
    this.GetDataPrefab()
end

function this.GetDataPrefab()
    print("GetDataPrefab------ was called");
    HNHSM_Data.rounds                = UnityEngine.PlayerPrefs.GetInt("CLBHNHSM_Rounds", 8);
    HNHSM_Data.size                  = UnityEngine.PlayerPrefs.GetInt("CLBHNHSM_Size", 3);
    HNHSM_Data.paymentType           = UnityEngine.PlayerPrefs.GetInt("CLBHNHSM_PayType", 0);
    HNHSM_Data.bankerRule            = UnityEngine.PlayerPrefs.GetInt("CLBHNHSM_bankerRule",1) == 1;
    HNHSM_Data.huPattern             = UnityEngine.PlayerPrefs.GetInt("CLBHNHSM_huPattern",1) == 1;
    HNHSM_Data.takeFeng              = UnityEngine.PlayerPrefs.GetInt("HNHSM_takeFeng",0) == 1;
	HNHSM_Data.qys					 = UnityEngine.PlayerPrefs.GetInt("HNHSM_qys",0) == 1;
	HNHSM_Data.dpdg3				 = UnityEngine.PlayerPrefs.GetInt("HNHSM_dpdg3",0) == 1;
	HNHSM_Data.hzfb					 = UnityEngine.PlayerPrefs.GetInt("HNHSM_hzfb",0) == 1;
    HNHSM_Data.variableHongZhong     = UnityEngine.PlayerPrefs.GetInt("HNHSM_variableHongZhong",1) == 1;
	HNHSM_Data.lzryd				 = UnityEngine.PlayerPrefs.GetInt("HNHSM_lzryd",1) == 1;
	HNHSM_Data.hzbhg				 = UnityEngine.PlayerPrefs.GetInt("HNHSM_hzbhg",1) == 1;
    HNHSM_Data.openGenBanker         = UnityEngine.PlayerPrefs.GetInt("CLBHNHSM_openGenBanker",1) == 1;
    HNHSM_Data.qiangGangHu           = UnityEngine.PlayerPrefs.GetInt("CLBHNHSM_qiangGangHu",0) == 1;
    HNHSM_Data.flodHuNoJiePao        = UnityEngine.PlayerPrefs.GetInt("CLBHNHSM_flodHuNoJiePao",0) == 1;
    HNHSM_Data.zhuaYu                = UnityEngine.PlayerPrefs.GetInt("CLBHNHSM_zhuaYu",0);
    HNHSM_Data.resultScore           = UnityEngine.PlayerPrefs.GetInt("CLBHNHSM_resultScore", 0) == 1;
    HNHSM_Data.resultLowerScore      = UnityEngine.PlayerPrefs.GetInt("CLBHNHSM_resultLowerScore", 10);
    HNHSM_Data.resultAddScore        = UnityEngine.PlayerPrefs.GetInt("CLBHNHSM_resultAddScore", 10);
    HNHSM_Data.trusteeship           = UnityEngine.PlayerPrefs.GetInt("CLBHNHSM_trusteeshipTime",0);
    HNHSM_Data.trusteeshipDissolve   = UnityEngine.PlayerPrefs.GetInt("CLBHNHSM_trusteeshipType",0) == 1;
    HNHSM_Data.trusteeshipRound      = UnityEngine.PlayerPrefs.GetInt("CLBHNHSM_trusteeshipRound",0);
    HNHSM_Data.openGps               = UnityEngine.PlayerPrefs.GetInt("CLBHNHSM_openGps",0) == 1;
    HNHSM_Data.openIp                = UnityEngine.PlayerPrefs.GetInt("CLBHNHSM_openIp",0) == 1; 
    HNHSM_Data.choiceDouble          = UnityEngine.PlayerPrefs.GetInt("CLBHNHSM_choiceDouble",0) == 1
    HNHSM_Data.doubleScore           = UnityEngine.PlayerPrefs.GetInt("CLBHNHSM_doubleScore",10)
    HNHSM_Data.multiple              = UnityEngine.PlayerPrefs.GetInt("CLBHNHSM_multiple",2)
end

function this.SetSetting(settings)
    HNHSM_Data.rounds                = settings.rounds;              
    HNHSM_Data.size                  = settings.size ;               
    HNHSM_Data.paymentType           = settings.paymentType;         
    HNHSM_Data.bankerRule            = settings.bankerRule;          
    HNHSM_Data.playChoose            = settings.playChoose;          
    HNHSM_Data.huPattern             = settings.huPattern;           
    HNHSM_Data.takeFeng              = settings.takeFeng  
	HNHSM_Data.qys					 = settings.qingYiSe
	HNHSM_Data.dpdg3				 = settings.scoreMingGangInc
	HNHSM_Data.hzfb					 = settings.huangZhuangJiaBei
    HNHSM_Data.variableHongZhong     = settings.variableHongZhong
	HNHSM_Data.lzryd				 = settings.variableHongZhongAll
	HNHSM_Data.hzbhg				 = settings.huangZhuangHuangGang
    HNHSM_Data.openGenBanker         = settings.openGenBanker    
    HNHSM_Data.qiangGangHu           = settings.qiangGangHu      
    HNHSM_Data.flodHuNoJiePao        = settings.flodHuNoJiePao   
    HNHSM_Data.zhuaYu                = settings.zhuaYu             
    HNHSM_Data.resultScore           = settings.resultScore;         
    HNHSM_Data.resultLowerScore      = settings.resultLowerScore;    
	HNHSM_Data.resultAddScore        = settings.resultAddScore;      
    HNHSM_Data.trusteeship           = settings.trusteeship;         
    HNHSM_Data.trusteeshipDissolve   = settings.trusteeshipDissolve; 
    HNHSM_Data.trusteeshipRound      = settings.trusteeshipRound;   
    HNHSM_Data.openGps               = settings.openGps;   
    HNHSM_Data.openIp                = settings.openIp;   
    if settings.choiceDouble == nil then
        HNHSM_Data.choiceDouble          = false
        HNHSM_Data.doubleScore           = 10
        HNHSM_Data.multiple              = 2
    else
        HNHSM_Data.choiceDouble          = settings.choiceDouble; 
        HNHSM_Data.doubleScore           = settings.doubleScore; 
        HNHSM_Data.multiple              = settings.multiple; 
    end
end

function this.OnClickRound(go)
    
    AudioManager.Instance:PlayAudio('btn');
    if go.gameObject == HNHSM_View.Round8Toggle.gameObject then
        HNHSM_Data.rounds = 8;
    elseif go.gameObject == HNHSM_View.Round12Toggle.gameObject then
        HNHSM_Data.rounds = 12;
    elseif go.gameObject == HNHSM_View.Round6Toggle.gameObject then 
        HNHSM_Data.rounds = 6;
    elseif go.gameObject == HNHSM_View.Round16Toggle.gameObject then 
        HNHSM_Data.rounds = 16;
    end
    payLabel.text = GetPayMun(proxy_pb.HNHSM,HNHSM_Data.rounds,HNHSM_Data.size,nil)
    UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_Rounds", HNHSM_Data.rounds);
end

function this.OnClickPeople(go)
    AudioManager.Instance:PlayAudio('btn');
    if go.gameObject == HNHSM_View.P2Toggle.gameObject then
        HNHSM_Data.size = 2;
    elseif go.gameObject == HNHSM_View.P3Toggle.gameObject then
        HNHSM_Data.size = 3;
    elseif go.gameObject == HNHSM_View.P4Toggle.gameObject then 
        HNHSM_Data.size = 4;
    end
    payLabel.text = GetPayMun(proxy_pb.HNHSM,HNHSM_Data.rounds,HNHSM_Data.size,nil)
    HNHSM_View.ToggleIPcheck.parent.gameObject:SetActive(HNHSM_Data.size > 2)
    UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_Size", HNHSM_Data.size)
    HNHSM_View.ToggleSettlementScoreSelect.parent.gameObject:SetActive(HNHSM_Data.size==2);
    HNHSM_View.ToggleChoiceDouble.parent.gameObject:SetActive(HNHSM_Data.size==2)
    HNHSM_View.ToggleMultiple2.parent.gameObject:SetActive(HNHSM_Data.size==2 and HNHSM_Data.choiceDouble)
	gameObject.transform:Find('HNHSMPanel/table'):GetComponent('UIGrid'):Reposition();
end

function this.OnClickPayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if go.gameObject == HNHSM_View.MasterPayToggle.gameObject then
        HNHSM_Data.paymentType = 0
    elseif go.gameObject == HNHSM_View.WinnerPayToggle.gameObject then
        HNHSM_Data.paymentType = 2
    end
    UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_PayType", HNHSM_Data.paymentType)
end

function this.OnClikWinType(go)
    AudioManager.Instance:PlayAudio('btn')
    if go == HNHSM_View.ToggleMustSelfMo.gameObject then 
        HNHSM_Data.huPattern = true;
        HNHSM_View.ToggleQGH.gameObject:SetActive(false);
        HNHSM_View.ToggleMissHuOnlySelfMo.gameObject:SetActive(false);
    elseif go == HNHSM_View.ToggleCanDianPao.gameObject then 
        HNHSM_Data.huPattern = false;
        HNHSM_View.ToggleQGH.gameObject:SetActive(true);
        HNHSM_View.ToggleMissHuOnlySelfMo.gameObject:SetActive(true);
    end
    UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_huPattern", HNHSM_Data.huPattern and 1 or 0);
end

function this.OnClikLZType(go)
	AudioManager.Instance:PlayAudio('btn')
	HNHSM_View.ToggleLZRYD.gameObject:SetActive(HNHSM_View.ToggleHongzhongLZ:GetComponent("UIToggle").value)
end

function this.OnClickBankerType(go)
    AudioManager.Instance:PlayAudio('btn');
    if go == HNHSM_View.ToggleFirstRandomBanker.gameObject then 
        HNHSM_Data.bankerRule = true;
    elseif go == HNHSM_View.ToggleFirstIsBanker.gameObject then 
        HNHSM_Data.bankerRule = false;
    end

    UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_bankerRule", HNHSM_Data.bankerRule and 1 or 0);

end

function this.OnClickZhuayu(go)
    AudioManager.Instance:PlayAudio('btn');
    print("HNHSM_View.zhuayuScoreText="..tostring(HNHSM_View.zhuayuScoreText));
    if go == HNHSM_View.ToggleNoZhuayu.gameObject then 
        HNHSM_Data.zhuaYu = 0;
        HNHSM_View.zhuayuScoreText.parent.gameObject:SetActive(false);
    elseif go == HNHSM_View.ToggleZhuayu.gameObject then 
        HNHSM_Data.zhuaYu =  HNHSM_Data.zhuaYu == 0 and 8 or HNHSM_Data.zhuaYu;
        print("path-----------1");
        print("HNHSM_Data.zhuaYu="..HNHSM_Data.zhuaYu);
        HNHSM_View.zhuayuScoreText.parent.gameObject:SetActive(true);
    end
    print("path-----------2");
    print("HNHSM_Data.zhuaYu="..HNHSM_Data.zhuaYu);

    UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_zhuaYu", HNHSM_Data.zhuaYu);
    HNHSM_View.zhuayuScoreText:GetComponent("UILabel").text = "抓"..HNHSM_Data.zhuaYu.."条鱼";
end


function this.OnClickChangeZhuayuScore(go)
     AudioManager.Instance:PlayAudio('btn');
     if go == HNHSM_View.AddzhuayuScoreButton.gameObject then 
        HNHSM_Data.zhuaYu = HNHSM_Data.zhuaYu + 1;
        if HNHSM_Data.zhuaYu > 20 then 
            HNHSM_Data.zhuaYu = 20;
        end
     elseif go == HNHSM_View.SubtractzhuayuScoreButton.gameObject then 
        HNHSM_Data.zhuaYu = HNHSM_Data.zhuaYu - 1;
        if HNHSM_Data.zhuaYu < 1 then 
            HNHSM_Data.zhuaYu = 1;
        end
     end
     UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_zhuaYu", HNHSM_Data.zhuaYu);
     HNHSM_View.zhuayuScoreText:GetComponent("UILabel").text = "抓"..HNHSM_Data.zhuaYu.."条鱼";
end





function this.OnClickTrusteeshipTime(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == HNHSM_View.ToggleTrusteeshipNo.gameObject then
		HNHSM_Data.trusteeship = 0
	elseif go == HNHSM_View.ToggleTrusteeship1.gameObject then
        HNHSM_Data.trusteeship = 60
    elseif go == HNHSM_View.ToggleTrusteeship2.gameObject then
		HNHSM_Data.trusteeship = 120
	elseif go == HNHSM_View.ToggleTrusteeship3.gameObject then
		HNHSM_Data.trusteeship = 180
	elseif go == HNHSM_View.ToggleTrusteeship5.gameObject then
		HNHSM_Data.trusteeship = 300
    end
    UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_trusteeshipTime", HNHSM_Data.trusteeship)
    HNHSM_View.ToggleTrusteeshipOne.parent.gameObject:SetActive(HNHSM_Data.trusteeship ~= 0)
    gameObject.transform:Find('HNHSMPanel/table'):GetComponent('UIGrid'):Reposition();
end

function this.OnClickTrusteeshipType(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == HNHSM_View.ToggleTrusteeshipAll.gameObject then
        HNHSM_Data.trusteeshipDissolve = false;
        HNHSM_Data.trusteeshipRound = 0;
	elseif go == HNHSM_View.ToggleTrusteeshipOne.gameObject then
        HNHSM_Data.trusteeshipDissolve = true;
        HNHSM_Data.trusteeshipRound = 0;
    elseif go == HNHSM_View.ToggleTrusteeshipThree.gameObject then 
        HNHSM_Data.trusteeshipDissolve = false;
        HNHSM_Data.trusteeshipRound = 3;
    end
    UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_trusteeshipType",HNHSM_Data.trusteeshipDissolve and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_trusteeshipRound",HNHSM_Data.trusteeshipRound);
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if HNHSM_View.ToggleIPcheck.gameObject == go then
		HNHSM_Data.openIp = HNHSM_View.ToggleIPcheck:GetComponent('UIToggle').value
	elseif HNHSM_View.ToggleGPScheck.gameObject == go then
		HNHSM_Data.openGps = HNHSM_View.ToggleGPScheck:GetComponent('UIToggle').value
	end
end

function this.GetConfig()
    
    HNHSM_Data.takeFeng             = HNHSM_View.ToggleWithOutWind:GetComponent("UIToggle").value;
	HNHSM_Data.qys					= HNHSM_View.ToggleQYS:GetComponent("UIToggle").value;
	HNHSM_Data.dpdg3				= HNHSM_View.ToggleDPDG3:GetComponent("UIToggle").value;
	HNHSM_Data.hzfb					= HNHSM_View.ToggleHZFB:GetComponent("UIToggle").value;
    HNHSM_Data.variableHongZhong    = HNHSM_View.ToggleHongzhongLZ:GetComponent("UIToggle").value;
	HNHSM_Data.lzryd				= HNHSM_View.ToggleLZRYD:GetComponent("UIToggle").value;
	HNHSM_Data.hzbhg				= HNHSM_View.ToggleHZBHG:GetComponent("UIToggle").value;
    HNHSM_Data.openGenBanker        = HNHSM_View.ToggleGenZhuang:GetComponent("UIToggle").value;
    HNHSM_Data.qiangGangHu          = HNHSM_View.ToggleQGH:GetComponent("UIToggle").value;
    HNHSM_Data.flodHuNoJiePao       = HNHSM_View.ToggleMissHuOnlySelfMo:GetComponent("UIToggle").value;
    

    UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_takeFeng",            HNHSM_Data.takeFeng and 1 or 0);
	UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_qys",					HNHSM_Data.qys and 1 or 0)
	UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_dpdg3",				HNHSM_Data.dpdg3 and 1 or 0)
	UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_hzfb",				HNHSM_Data.hzfb and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_variableHongZhong",   HNHSM_Data.variableHongZhong and 1 or 0);
	UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_lzryd",				HNHSM_Data.lzryd and 1 or 0)
	UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_hzbhg",				HNHSM_Data.hzbhg and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_openGenBanker",       HNHSM_Data.openGenBanker and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_qiangGangHu",         HNHSM_Data.qiangGangHu and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_flodHuNoJiePao",      HNHSM_Data.flodHuNoJiePao and 1 or 0);

    local settings                  = {}
    settings.roomType               = proxy_pb.HNHSM;
    settings.rounds                 = HNHSM_Data.rounds;
    settings.size                   = HNHSM_Data.size;
    settings.paymentType            = 3;
    settings.bankerRule             = HNHSM_Data.bankerRule;  
    settings.huPattern              = HNHSM_Data.huPattern;   
    settings.takeFeng               = HNHSM_Data.takeFeng;   
	settings.qingYiSe				= HNHSM_Data.qys
	settings.scoreMingGangInc		= HNHSM_Data.dpdg3
	settings.huangZhuangJiaBei		= HNHSM_Data.hzfb
    settings.variableHongZhong      = HNHSM_Data.variableHongZhong;  
	settings.variableHongZhongAll	= HNHSM_Data.lzryd and settings.variableHongZhong
	settings.huangZhuangHuangGang	= HNHSM_Data.hzbhg 
    settings.openGenBanker          = HNHSM_Data.openGenBanker;   
    settings.qiangGangHu            = HNHSM_Data.qiangGangHu and (not settings.huPattern);   
    settings.flodHuNoJiePao         = HNHSM_Data.flodHuNoJiePao and (not settings.huPattern);   
    settings.zhuaYu                 = HNHSM_Data.zhuaYu;   
    settings.resultScore            = this.getResultScore(HNHSM_Data);
    settings.resultLowerScore       = this.getResultLowerScore(HNHSM_Data);
    settings.resultAddScore         = this.getResultAddScore(HNHSM_Data);
    settings.trusteeship            = HNHSM_Data.trusteeship;
    settings.trusteeshipDissolve    = HNHSM_Data.trusteeshipDissolve;
    settings.trusteeshipRound       = HNHSM_Data.trusteeshipRound;
    settings.openIp                 = HNHSM_Data.openIp;
    settings.openGps                = HNHSM_Data.openGps;
    if HNHSM_Data.size == 2 then
        settings.openIp =false;
        settings.openGps = false;
        settings.choiceDouble       = HNHSM_Data.choiceDouble; 
        settings.doubleScore        = HNHSM_Data.doubleScore; 
        settings.multiple           = HNHSM_Data.multiple; 
    end
    return settings;
    
end

function this.OnClickOk(go)
    if optionData.addPlay == true then
        optionData.currentOption = "addPlay";
        local msg           = Message.New();
        msg.type            = proxy_pb.CREATE_CLUB_PLAY;
        local bigbody       = proxy_pb.PCreateClubPlay();
        bigbody.gameType    = proxy_pb.HNM
        bigbody.roomType    = proxy_pb.HNHSM;
        bigbody.name        = '划水麻将';
        bigbody.clubId      = panelClub.clubInfo.clubId;
        local settings      = this.GetConfig();
        bigbody.settings    = json:encode(settings);
        print("bigbody.settings"..bigbody.settings);
        msg.body            = bigbody:SerializeToString();
        SendProxyMessage(msg, this.OnCreateClubPlayResult);
        print('add_HNHSM_Play');

    elseif optionData.addRule == true then
        optionData.currentOption = "addRule";
        local msg           = Message.New();
        msg.type            = proxy_pb.CREATE_PLAY_RULE;
        local bigbody       = proxy_pb.PCreatePlayRule();
        bigbody.gameType    = proxy_pb.HNM;
        bigbody.playId      = optionData.playId;
        bigbody.clubId      = panelClub.clubInfo.clubId;
        local settings      = this.GetConfig();
        bigbody.settings    = json:encode(settings);
        msg.body            = bigbody:SerializeToString();
        SendProxyMessage(msg, this.OnCreateClubPlayResult);
        print('add_HNHSM_Rule');
    else
        optionData.currentOption    = "updateRule";
        local msg                   = Message.New();
        msg.type                    = proxy_pb.UPDATE_PLAY_RULE;
        local bigbody               = proxy_pb.PUpdatePlayRule();
        bigbody.playId              = optionData.playId;
        bigbody.ruleId              = optionData.ruleId;
        bigbody.clubId              = panelClub.clubInfo.clubId;
        local settings              = this.GetConfig();
        bigbody.settings            = json:encode(settings);
        msg.body                    = bigbody:SerializeToString();
        SendProxyMessage(msg, this.OnCreateClubPlayResult);
        print('update_HNHSM_Rule')
    end
end

function this.OnCreateRoomResult(msg)
	print('OnCreateRoomResult')
	local b = proxy_pb.RCreateRoom();
    b:ParseFromString(msg.body);
	roomInfo.host       = b.host;
	roomInfo.port       = b.port;
	roomInfo.token      = b.token;
    roomInfo.roomNumber = b.roomNumber;
    roomInfo.roomType   = b.roomType;
    roomInfo.gameType   = b.gameType;

    -- print("show---------------------->before");
    PanelManager.Instance:ShowWindow("panelInGame_hnhsm", gameObject.name);
    -- print("show---------------------->after");
    
end

function this.OnApplicationFocus()

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
    PanelManager.Instance:ShowWindow('panelHelp', proxy_pb.HNHSM);
end


function this.getResultScore(HNHSM_Data)
    if HNHSM_Data.size == 2 then 
        return HNHSM_Data.resultScore;
    end
    return nil;
end

function this.getResultLowerScore(HNHSM_Data)
    if HNHSM_Data.size == 2 then 
        if HNHSM_Data.resultScore then 
            return HNHSM_Data.resultLowerScore;
        end
    end
    
    return nil;
end

function this.getResultAddScore(HNHSM_Data)
    if HNHSM_Data.size == 2 then 
        if HNHSM_Data.resultScore then 
            return HNHSM_Data.resultAddScore;
        end
    end
    
    return nil;
end


function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    HNHSM_Data.resultScore= HNHSM_View.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_resultScore", HNHSM_Data.resultScore and 1 or 0)
end


function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if HNHSM_View.ToggleFewerAddButton.gameObject == go then
		HNHSM_Data.resultLowerScore = HNHSM_Data.resultLowerScore + 1
		if HNHSM_Data.resultLowerScore > 100 then
			HNHSM_Data.resultLowerScore = 100
		end
    elseif HNHSM_View.ToggleFewerSubtractButton.gameObject == go then
		HNHSM_Data.resultLowerScore = HNHSM_Data.resultLowerScore - 1
		if HNHSM_Data.resultLowerScore < 1 then
			HNHSM_Data.resultLowerScore = 1
		end
	end
	HNHSM_View.ToggleFewerScoreTxt:GetComponent('UILabel').text = HNHSM_Data.resultLowerScore.."分";
	UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_resultLowerScore", HNHSM_Data.resultLowerScore)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if HNHSM_View.ToggleAddAddButton.gameObject == go then
		HNHSM_Data.resultAddScore = HNHSM_Data.resultAddScore + 1
		if HNHSM_Data.resultAddScore > 100 then
			HNHSM_Data.resultAddScore = 100
		end
    elseif HNHSM_View.ToggleAddSubtractButton.gameObject == go then
		HNHSM_Data.resultAddScore = HNHSM_Data.resultAddScore - 1
		if HNHSM_Data.resultAddScore < 1 then
			HNHSM_Data.resultAddScore = 1
		end
	end
	HNHSM_View.ToggleAddScoreTxt:GetComponent('UILabel').text = HNHSM_Data.resultAddScore.."分";
	UnityEngine.PlayerPrefs.SetInt("CLBHNHSM_resultAddScore", HNHSM_Data.resultAddScore)
end

function this.OnClickChoiceDouble(go)
    AudioManager.Instance:PlayAudio('btn')
	if HNHSM_View.ToggleChoiceDouble.gameObject == go then
		HNHSM_Data.choiceDouble = true
	else
		HNHSM_Data.choiceDouble = false
	end
	HNHSM_View.DoubleScoreText.parent.gameObject:SetActive(HNHSM_Data.choiceDouble)
    HNHSM_View.ToggleMultiple2.parent.gameObject:SetActive(HNHSM_Data.choiceDouble)
    if HNHSM_Data.choiceDouble then
		HNHSM_View.ToggleMultiple2:GetComponent('UIToggle'):Set(HNHSM_Data.multiple == 2)
		HNHSM_View.ToggleMultiple3:GetComponent('UIToggle'):Set(HNHSM_Data.multiple == 3)
		HNHSM_View.ToggleMultiple4:GetComponent('UIToggle'):Set(HNHSM_Data.multiple == 4)
	end
	gameObject.transform:Find('HNHSMPanel/table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickChangeDoubleScore(go)
    AudioManager.Instance:PlayAudio('btn')
    local label_= HNHSM_View.DoubleScoreText:GetComponent('UILabel').text
    if label_=='不限分' then
        HNHSM_Data.doubleScore=0
    else
        HNHSM_Data.doubleScore=tonumber(string.sub(label_,7,-4))    
    end
	if HNHSM_View.AddDoubleScoreButton.gameObject == go then
		if HNHSM_Data.doubleScore ~= 0 then
			HNHSM_Data.doubleScore = HNHSM_Data.doubleScore + 1
			if HNHSM_Data.doubleScore > 100 then
				HNHSM_Data.doubleScore = 0
			end
		end
	else
		if HNHSM_Data.doubleScore == 0 then
			HNHSM_Data.doubleScore = 100
		else
			HNHSM_Data.doubleScore = HNHSM_Data.doubleScore - 1
			if HNHSM_Data.doubleScore < 1 then
				HNHSM_Data.doubleScore = 1
			end
		end
	end

	if HNHSM_Data.doubleScore == 0 then
		HNHSM_View.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		HNHSM_View.DoubleScoreText:GetComponent('UILabel').text = '小于'..HNHSM_Data.doubleScore..'分'
	end
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
	HNHSM_Data.multiple = tonumber(go.name)
	print('倍数：'..HNHSM_Data.multiple)
end