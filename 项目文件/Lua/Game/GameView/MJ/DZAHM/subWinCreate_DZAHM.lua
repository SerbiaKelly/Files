
DZAHM_EventBind_DZAHM   = {};
require("proxy_pb")
local json = require("json")
local this = DZAHM_EventBind_DZAHM;
local message;
local gameObject;
local DZAHM_View = {}
local DZAHM_Data = {}
local payLabel;

function this.Init(go,messageObj)
    print("Awake was called");
    gameObject                                  = go;
	message                                     = messageObj;
    payLabel 							        = message.transform:Find('diamond/pay_label'):GetComponent('UILabel')
    local DZAHMPanel                            = gameObject.transform:Find("table");
    --局数选择              
    DZAHM_View.Round6Toggle                     = DZAHMPanel.transform:Find("ToggleRound/ToggleRound6");
    DZAHM_View.Round8Toggle                     = DZAHMPanel.transform:Find("ToggleRound/ToggleRound8");
    DZAHM_View.Round12Toggle                    = DZAHMPanel.transform:Find("ToggleRound/ToggleRound12");
    DZAHM_View.Round16Toggle                    = DZAHMPanel.transform:Find("ToggleRound/ToggleRound16");
    --人数选择              
    DZAHM_View.P2Toggle                         = DZAHMPanel.transform:Find("TogglePeople/Toggle2P");
    DZAHM_View.P3Toggle                         = DZAHMPanel.transform:Find("TogglePeople/Toggle3P");
    DZAHM_View.P4Toggle                         = DZAHMPanel.transform:Find("TogglePeople/Toggle4P");
    DZAHM_View.ToggleLessPlayerStart            = DZAHMPanel.transform:Find("TogglePeople/lessPlayerStart");
    --开房模式              
    DZAHM_View.MasterPayToggle                  = DZAHMPanel.transform:Find('TogglePayType/ToggleMasterPay');
    DZAHM_View.WinnerPayToggle                  = DZAHMPanel.transform:Find('TogglePayType/ToggleWinnerPay');
    --坐庄规则      
    DZAHM_View.ToggleFirstRandomBanker          = DZAHMPanel.transform:Find('ToggleBankTypeGroup/ToggleFirstRandomBanker');
    DZAHM_View.ToggleFirstIsBanker              = DZAHMPanel.transform:Find('ToggleBankTypeGroup/ToggleFirstIsBanker');
    --底分
    DZAHM_View.AddBtnDiFen                      = DZAHMPanel:Find('diFen/diFenScore/AddButton')
    DZAHM_View.SubtractBtnDiFen                 = DZAHMPanel:Find('diFen/diFenScore/SubtractButton')
    DZAHM_View.DiFenTunValue                    = DZAHMPanel:Find('diFen/diFenScore/Value')
	message:AddClick(DZAHM_View.AddBtnDiFen.gameObject, this.OnClickChangeDiFenValue)
	message:AddClick(DZAHM_View.SubtractBtnDiFen.gameObject, this.OnClickChangeDiFenValue)
    --个性玩法              
    DZAHM_View.ToggleQianganhu                  = DZAHMPanel.transform:Find("TogglePlay1/Qianganhu");
    DZAHM_View.TogglePiaofen                    = DZAHMPanel.transform:Find("TogglePlay1/Piaofen");
    DZAHM_View.ToggleWangDai                   = DZAHMPanel.transform:Find("TogglePlay1/WangDai");
    DZAHM_View.ToggleYipaoduoxiang              = DZAHMPanel.transform:Find("TogglePlay2/Yipaoduoxiang");
    DZAHM_View.ToggleGangshanpao             = DZAHMPanel.transform:Find("TogglePlay2/Gangshanpao");
    message:AddClick(DZAHM_View.ToggleQianganhu.gameObject, this.OnClickWanFa)
    message:AddClick(DZAHM_View.TogglePiaofen.gameObject, this.OnClickWanFa)
    message:AddClick(DZAHM_View.ToggleWangDai.gameObject, this.OnClickWanFa)
    message:AddClick(DZAHM_View.ToggleYipaoduoxiang.gameObject, this.OnClickWanFa)
    message:AddClick(DZAHM_View.ToggleGangshanpao.gameObject, this.OnClickWanFa)
    --飘分
    DZAHM_View.ToggleFreeChoice                 = DZAHMPanel.transform:Find('regularScore/Off') 
    DZAHM_View.ToggleSteadyChoice               = DZAHMPanel.transform:Find('regularScore/On') 
    DZAHM_View.ToggleRegularScoreOnButton  = DZAHMPanel:Find('regularScore/On')
	DZAHM_View.ToggleRegularScoreOffButton = DZAHMPanel:Find('regularScore/Off')
	DZAHM_View.RegularScoreTxt = DZAHMPanel:Find('regularScore/Score/Value')
	DZAHM_View.RegularAddButton = DZAHMPanel:Find('regularScore/Score/AddButton')
	DZAHM_View.RegularSubtractButton = DZAHMPanel:Find('regularScore/Score/SubtractButton')
	message:AddClick(DZAHM_View.ToggleRegularScoreOnButton.gameObject, this.OnClickRegularScore)
	message:AddClick(DZAHM_View.ToggleRegularScoreOffButton.gameObject, this.OnClickRegularScore)
	message:AddClick(DZAHM_View.RegularAddButton.gameObject, this.OnClickChangeRegularScore)
    message:AddClick(DZAHM_View.RegularSubtractButton.gameObject, this.OnClickChangeRegularScore)
    
    --抓鸟
    DZAHM_View.ToggleWinPos = DZAHMPanel:Find("ToggleNiaoType/winPos")
	DZAHM_View.Toggle159Bird = DZAHMPanel:Find("ToggleNiaoType/159Bird")
	DZAHM_View.ToggleNoBird = DZAHMPanel:Find("ToggleNiaoType/noBird")
	DZAHM_View.TogglebankerPos= DZAHMPanel:Find("ToggleNiaoType/bankerPos")
	DZAHM_View.ToggleCatchBird= DZAHMPanel:Find("ToggleCatchBird")
	message:AddClick(DZAHM_View.ToggleWinPos.gameObject, this.OnClickToggleNiaoType)
	message:AddClick(DZAHM_View.Toggle159Bird.gameObject, this.OnClickToggleNiaoType)
	message:AddClick(DZAHM_View.ToggleNoBird.gameObject, this.OnClickToggleNiaoType)
    message:AddClick(DZAHM_View.TogglebankerPos.gameObject, this.OnClickToggleNiaoType)
    DZAHM_View.changshaNiao1 = DZAHMPanel:Find("ToggleCatchBird/Niao1")
	DZAHM_View.changshaNiao2 = DZAHMPanel:Find("ToggleCatchBird/Niao2")
	DZAHM_View.changshaNiao4 = DZAHMPanel:Find("ToggleCatchBird/Niao4")
	DZAHM_View.changshaNiao6 = DZAHMPanel:Find("ToggleCatchBird/Niao6")
	message:AddClick(DZAHM_View.changshaNiao1.gameObject, this.OnClickButtonNiaoNumDZAHM_View)
	message:AddClick(DZAHM_View.changshaNiao2.gameObject, this.OnClickButtonNiaoNumDZAHM_View)
	message:AddClick(DZAHM_View.changshaNiao4.gameObject, this.OnClickButtonNiaoNumDZAHM_View)
    message:AddClick(DZAHM_View.changshaNiao6.gameObject, this.OnClickButtonNiaoNumDZAHM_View)
    --王 4 7
    DZAHM_View.ToggleKing4 = DZAHMPanel:Find("ToggleKingNum/4king")
    DZAHM_View.ToggleKing7 = DZAHMPanel:Find("ToggleKingNum/7king")
    message:AddClick(DZAHM_View.ToggleKing4.gameObject, this.OnClickButtonKing)
    message:AddClick(DZAHM_View.ToggleKing7.gameObject, this.OnClickButtonKing)
    --杠牌个数
    DZAHM_View.changshaKaigang2 = DZAHMPanel:Find("ToggleKaiGang/Gang2")
    DZAHM_View.changshaKaigang3 = DZAHMPanel:Find("ToggleKaiGang/Gang3")
    DZAHM_View.changshaKaigang4 = DZAHMPanel:Find("ToggleKaiGang/Gang4")
    message:AddClick(DZAHM_View.changshaKaigang2.gameObject, this.OnClickToggleKaigang)
    message:AddClick(DZAHM_View.changshaKaigang3.gameObject, this.OnClickToggleKaigang)
    message:AddClick(DZAHM_View.changshaKaigang4.gameObject, this.OnClickToggleKaigang)
    
    --2人结算低于多少分加
    DZAHM_View.ToggleSettlementScoreSelect      = DZAHMPanel:Find('settlementScore/select')
	DZAHM_View.ToggleFewerScoreTxt              = DZAHMPanel:Find('settlementScore/fewerValue/Value')
	DZAHM_View.ToggleFewerAddButton             = DZAHMPanel:Find('settlementScore/fewerValue/AddButton')
	DZAHM_View.ToggleFewerSubtractButton        = DZAHMPanel:Find('settlementScore/fewerValue/SubtractButton')
	DZAHM_View.ToggleAddScoreTxt                = DZAHMPanel:Find('settlementScore/addValue/Value')
	DZAHM_View.ToggleAddAddButton               = DZAHMPanel:Find('settlementScore/addValue/AddButton')
	DZAHM_View.ToggleAddSubtractButton          = DZAHMPanel:Find('settlementScore/addValue/SubtractButton')
    DZAHM_View.ToggleTrusteeshipNo              = DZAHMPanel.transform:Find('ToggleTrusteeship/ToggleNo');
	DZAHM_View.ToggleTrusteeship1               = DZAHMPanel.transform:Find('ToggleTrusteeship/Toggle1Minute');
	DZAHM_View.ToggleTrusteeship2               = DZAHMPanel.transform:Find('ToggleTrusteeship/Toggle2Minute');
	DZAHM_View.ToggleTrusteeship3               = DZAHMPanel.transform:Find('ToggleTrusteeship/Toggle3Minute');
	DZAHM_View.ToggleTrusteeship5               = DZAHMPanel.transform:Find('ToggleTrusteeship1/Toggle5Minute');
	DZAHM_View.ToggleTrusteeshipAll             = DZAHMPanel.transform:Find('ToggleTrusteeshipType/ToggleAll');
    DZAHM_View.ToggleTrusteeshipOne             = DZAHMPanel.transform:Find('ToggleTrusteeshipType/ToggleOne');
    DZAHM_View.ToggleTrusteeshipThree           = DZAHMPanel.transform:Find('ToggleTrusteeshipType/ToggleThree');
    DZAHM_View.ToggleIPcheck                    = DZAHMPanel.transform:Find('PreventCheat/IPcheck')
    DZAHM_View.ToggleGPScheck                   = DZAHMPanel.transform:Find('PreventCheat/GPScheck')
    --2人翻倍
    DZAHM_View.ToggleMultiple2                  = DZAHMPanel.transform:Find('multiple/2')
	DZAHM_View.ToggleMultiple3                  = DZAHMPanel.transform:Find('multiple/3')
	DZAHM_View.ToggleMultiple4                  = DZAHMPanel.transform:Find('multiple/4')

	DZAHM_View.ToggleChoiceDouble               = DZAHMPanel.transform:Find('choiceDouble/On')
	DZAHM_View.ToggleNoChoiceDouble             = DZAHMPanel.transform:Find('choiceDouble/Off')
	DZAHM_View.DoubleScoreText                  = DZAHMPanel.transform:Find('choiceDouble/doubleScore/Value')
	DZAHM_View.AddDoubleScoreButton             = DZAHMPanel.transform:Find('choiceDouble/doubleScore/AddButton')
    DZAHM_View.SubtractDoubleScoreButton        = DZAHMPanel.transform:Find('choiceDouble/doubleScore/SubtractButton')

    message:AddClick(DZAHM_View.ToggleChoiceDouble.gameObject,          this.OnClickChoiceDouble)
	message:AddClick(DZAHM_View.ToggleNoChoiceDouble.gameObject,        this.OnClickChoiceDouble)
	message:AddClick(DZAHM_View.AddDoubleScoreButton.gameObject,        this.OnClickChangeDoubleScore)
	message:AddClick(DZAHM_View.SubtractDoubleScoreButton.gameObject,   this.OnClickChangeDoubleScore)

	message:AddClick(DZAHM_View.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(DZAHM_View.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(DZAHM_View.ToggleMultiple4.gameObject, this.OnClickMultiple)
    
    message:AddClick(DZAHM_View.Round6Toggle.gameObject,     this.OnClickRound);
    message:AddClick(DZAHM_View.Round8Toggle.gameObject,     this.OnClickRound);
    message:AddClick(DZAHM_View.Round12Toggle.gameObject,    this.OnClickRound);
    message:AddClick(DZAHM_View.Round16Toggle.gameObject,    this.OnClickRound);
    message:AddClick(DZAHM_View.ToggleLessPlayerStart.gameObject, this.OnClickToggleLessPlayerStart)
    
    message:AddClick(DZAHM_View.P2Toggle.gameObject,     this.OnClickPeople);
    message:AddClick(DZAHM_View.P3Toggle.gameObject,     this.OnClickPeople);
    message:AddClick(DZAHM_View.P4Toggle.gameObject,     this.OnClickPeople);

    message:AddClick(DZAHM_View.MasterPayToggle.gameObject,  this.OnClickPayType);
    message:AddClick(DZAHM_View.WinnerPayToggle.gameObject,  this.OnClickPayType);

    message:AddClick(DZAHM_View.ToggleFirstIsBanker.gameObject,      this.OnClickBankerType);
    message:AddClick(DZAHM_View.ToggleFirstRandomBanker.gameObject,  this.OnClickBankerType);

    message:AddClick(DZAHM_View.ToggleSettlementScoreSelect.gameObject,  this.OnClickSettlementScoreSelect)
	message:AddClick(DZAHM_View.ToggleFewerAddButton.gameObject,         this.OnClickFewerButton)
	message:AddClick(DZAHM_View.ToggleFewerSubtractButton.gameObject,    this.OnClickFewerButton)
	message:AddClick(DZAHM_View.ToggleAddAddButton.gameObject,           this.OnClickAddButton)
	message:AddClick(DZAHM_View.ToggleAddSubtractButton.gameObject,      this.OnClickAddButton)
    
 
    message:AddClick(DZAHM_View.ToggleTrusteeshipNo.gameObject,          this.OnClickTrusteeshipTime)
	message:AddClick(DZAHM_View.ToggleTrusteeship1.gameObject,           this.OnClickTrusteeshipTime)
	message:AddClick(DZAHM_View.ToggleTrusteeship2.gameObject,           this.OnClickTrusteeshipTime)
	message:AddClick(DZAHM_View.ToggleTrusteeship3.gameObject,           this.OnClickTrusteeshipTime)
	message:AddClick(DZAHM_View.ToggleTrusteeship5.gameObject,           this.OnClickTrusteeshipTime)
	message:AddClick(DZAHM_View.ToggleTrusteeshipOne.gameObject,         this.OnClickTrusteeshipType)
    message:AddClick(DZAHM_View.ToggleTrusteeshipAll.gameObject,         this.OnClickTrusteeshipType)
    message:AddClick(DZAHM_View.ToggleTrusteeshipThree.gameObject,       this.OnClickTrusteeshipType)

    message:AddClick(DZAHM_View.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(DZAHM_View.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end


function this.Refresh()
    print("OnEnable was called")
    this.GetDataPrefab()
    DZAHM_View.Round6Toggle:GetComponent("UIToggle"):Set(DZAHM_Data.rounds == 6);
    DZAHM_View.Round8Toggle:GetComponent("UIToggle"):Set(DZAHM_Data.rounds == 8);
    DZAHM_View.Round12Toggle:GetComponent("UIToggle"):Set(DZAHM_Data.rounds == 12);
    DZAHM_View.Round16Toggle:GetComponent("UIToggle"):Set(DZAHM_Data.rounds == 16);

    DZAHM_View.P2Toggle:GetComponent("UIToggle"):Set(DZAHM_Data.size == 2);
    DZAHM_View.P3Toggle:GetComponent("UIToggle"):Set(DZAHM_Data.size == 3);
    DZAHM_View.P4Toggle:GetComponent("UIToggle"):Set(DZAHM_Data.size == 4);
    DZAHM_View.ToggleLessPlayerStart:GetComponent("UIToggle"):Set(DZAHM_Data.minorityMode);

    DZAHM_View.MasterPayToggle:GetComponent("UIToggle"):Set(DZAHM_Data.paymentType == 0)
    DZAHM_View.WinnerPayToggle:GetComponent("UIToggle"):Set(DZAHM_Data.paymentType == 2)

    DZAHM_View.ToggleFirstRandomBanker:GetComponent("UIToggle"):Set(DZAHM_Data.bankerRule);
    DZAHM_View.ToggleFirstIsBanker:GetComponent("UIToggle"):Set(not DZAHM_Data.bankerRule);

    DZAHM_View.DiFenTunValue:GetComponent("UILabel").text = DZAHM_Data.bottomScore .. "分"

    --玩法
    DZAHM_View.ToggleQianganhu:GetComponent("UIToggle"):Set(DZAHM_Data.Qianganhu)
    DZAHM_View.TogglePiaofen:GetComponent("UIToggle"):Set(DZAHM_Data.floatScore)
    DZAHM_View.ToggleWangDai:GetComponent("UIToggle"):Set(DZAHM_Data.WangDai)
    DZAHM_View.ToggleYipaoduoxiang:GetComponent("UIToggle"):Set(DZAHM_Data.Yipaoduoxiang)
    DZAHM_View.ToggleGangshanpao:GetComponent("UIToggle"):Set(DZAHM_Data.Gangshanpao)

    --飘分
    DZAHM_View.ToggleRegularScoreOnButton:GetComponent("UIToggle"):Set(DZAHM_Data.choiceRegular)
	DZAHM_View.ToggleRegularScoreOffButton:GetComponent("UIToggle"):Set(not DZAHM_Data.choiceRegular)
    DZAHM_View.RegularScoreTxt:GetComponent('UILabel').text = DZAHM_Data.regularScore .. "分"
    DZAHM_View.RegularScoreTxt.parent.gameObject:SetActive(DZAHM_Data.choiceRegular)
    
    --抓鸟
    DZAHM_View.ToggleWinPos:GetComponent("UIToggle"):Set(DZAHM_Data.birdType == 2)
    DZAHM_View.Toggle159Bird:GetComponent("UIToggle"):Set(DZAHM_Data.birdType == 0)
    DZAHM_View.ToggleNoBird:GetComponent("UIToggle"):Set(DZAHM_Data.birdType == 3)
    DZAHM_View.TogglebankerPos:GetComponent("UIToggle"):Set(DZAHM_Data.birdType == 1)
    DZAHM_View.changshaNiao1:GetComponent("UIToggle"):Set(DZAHM_Data.birdNum == 1)
	DZAHM_View.changshaNiao2:GetComponent("UIToggle"):Set(DZAHM_Data.birdNum == 2)
	DZAHM_View.changshaNiao4:GetComponent("UIToggle"):Set(DZAHM_Data.birdNum == 4)
    DZAHM_View.changshaNiao6:GetComponent("UIToggle"):Set(DZAHM_Data.birdNum == 6)
    DZAHM_View.ToggleCatchBird.gameObject:SetActive(DZAHM_Data.birdType~=3)
    
    --王
    DZAHM_View.ToggleKing4:GetComponent("UIToggle"):Set(DZAHM_Data.King == 4)
    DZAHM_View.ToggleKing7:GetComponent("UIToggle"):Set(DZAHM_Data.King == 7)

    --杠牌个数
    DZAHM_View.changshaKaigang2:GetComponent("UIToggle"):Set(DZAHM_Data.gangMahjongCount == 2)
    DZAHM_View.changshaKaigang3:GetComponent("UIToggle"):Set(DZAHM_Data.gangMahjongCount == 3)
    DZAHM_View.changshaKaigang4:GetComponent("UIToggle"):Set(DZAHM_Data.gangMahjongCount == 4)

    --结算
    DZAHM_View.ToggleSettlementScoreSelect.parent.gameObject:SetActive(DZAHM_Data.size==2)
    DZAHM_View.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(DZAHM_Data.isSettlementScore)
	DZAHM_View.ToggleFewerScoreTxt:GetComponent('UILabel').text = DZAHM_Data.fewerValue;
	DZAHM_View.ToggleAddScoreTxt:GetComponent('UILabel').text = DZAHM_Data.addValue;

    DZAHM_View.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(DZAHM_Data.trusteeship == 0)
	DZAHM_View.ToggleTrusteeship1:GetComponent('UIToggle'):Set(DZAHM_Data.trusteeship == 1)
	DZAHM_View.ToggleTrusteeship2:GetComponent('UIToggle'):Set(DZAHM_Data.trusteeship == 2)
	DZAHM_View.ToggleTrusteeship3:GetComponent('UIToggle'):Set(DZAHM_Data.trusteeship == 3)
	DZAHM_View.ToggleTrusteeship5:GetComponent('UIToggle'):Set(DZAHM_Data.trusteeship == 5)

	DZAHM_View.ToggleTrusteeshipOne.parent.gameObject:SetActive(DZAHM_Data.trusteeship ~= 0)
    DZAHM_View.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not DZAHM_Data.trusteeshipDissolve and DZAHM_Data.trusteeshipRound == 0)
    DZAHM_View.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(DZAHM_Data.trusteeshipDissolve == true)
    DZAHM_View.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(DZAHM_Data.trusteeshipRound == 3);
    DZAHM_View.ToggleTrusteeshipOne.parent.gameObject:SetActive(DZAHM_Data.trusteeship ~= 0)
    DZAHM_View.ToggleIPcheck:GetComponent('UIToggle'):Set(DZAHM_Data.openIp)
    DZAHM_View.ToggleGPScheck:GetComponent('UIToggle'):Set(DZAHM_Data.openGps)
    DZAHM_View.ToggleIPcheck.parent.gameObject:SetActive(DZAHM_Data.size > 2)

    DZAHM_View.ToggleChoiceDouble.parent.gameObject:SetActive(DZAHM_Data.size==2)
    DZAHM_View.ToggleMultiple2.parent.gameObject:SetActive(DZAHM_Data.size==2 and DZAHM_Data.choiceDouble)
    
	DZAHM_View.ToggleMultiple2:GetComponent('UIToggle'):Set(DZAHM_Data.multiple == 2)
	DZAHM_View.ToggleMultiple3:GetComponent('UIToggle'):Set(DZAHM_Data.multiple == 3)
	DZAHM_View.ToggleMultiple4:GetComponent('UIToggle'):Set(DZAHM_Data.multiple == 4)

	DZAHM_View.ToggleChoiceDouble:GetComponent('UIToggle'):Set(DZAHM_Data.choiceDouble)
	DZAHM_View.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not DZAHM_Data.choiceDouble)
	DZAHM_View.DoubleScoreText.parent.gameObject:SetActive(DZAHM_Data.choiceDouble)
	if DZAHM_Data.doubleScore == 0 then
		DZAHM_View.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		DZAHM_View.DoubleScoreText:GetComponent('UILabel').text = '小于'..DZAHM_Data.doubleScore..'分'
	end
    payLabel.text = GetPayMun(proxy_pb.DZAHM,DZAHM_Data.rounds,DZAHM_Data.size,nil)
    gameObject.transform:Find("table"):GetComponent("UIGrid"):Reposition();
end

function this.GetDataPrefab()
    DZAHM_Data.rounds               = UnityEngine.PlayerPrefs.GetInt("DZAHM_Rounds", 8);
    DZAHM_Data.size                 = UnityEngine.PlayerPrefs.GetInt("DZAHM_Size", 2);
    DZAHM_Data.minorityMode         = UnityEngine.PlayerPrefs.GetInt("DZAHM_minorityMode", 1) == 1;
    DZAHM_Data.paymentType          = UnityEngine.PlayerPrefs.GetInt("DZAHM_PayType", 0);
    DZAHM_Data.bankerRule           = UnityEngine.PlayerPrefs.GetInt("DZAHM_bankerRule",0) == 1;
    DZAHM_Data.bottomScore          = UnityEngine.PlayerPrefs.GetInt('DZAHM_bottomScore', 1)
    
    DZAHM_Data.Qianganhu            = UnityEngine.PlayerPrefs.GetInt("DZAHM_Qianganhu",1) == 1;
    DZAHM_Data.floatScore              = UnityEngine.PlayerPrefs.GetInt("DZAHM_floatScore",0) == 1;
    DZAHM_Data.WangDai              = UnityEngine.PlayerPrefs.GetInt("DZAHM_WangDai",1) == 1;
    DZAHM_Data.Yipaoduoxiang        = UnityEngine.PlayerPrefs.GetInt("DZAHM_Yipaoduoxiang",0) == 1;
    DZAHM_Data.Gangshanpao          = UnityEngine.PlayerPrefs.GetInt("DZAHM_Gangshanpao",1) == 1;

    --固定飘分
    DZAHM_Data.choiceRegular = UnityEngine.PlayerPrefs.GetInt("DZAHM_choiceRegular", 0)==1
	DZAHM_Data.regularScore = UnityEngine.PlayerPrefs.GetInt("DZAHM_regularScore", 1)

    --抓鸟
    DZAHM_Data.birdType                   = UnityEngine.PlayerPrefs.GetInt("DZAHM_birdType",0);
    DZAHM_Data.birdNum                    = UnityEngine.PlayerPrefs.GetInt("DZAHM_birdNum",1);
    
    --王
    DZAHM_Data.King                    = UnityEngine.PlayerPrefs.GetInt("DZAHM_King",4);
    
    --杠牌个数
    DZAHM_Data.gangMahjongCount      = UnityEngine.PlayerPrefs.GetInt("DZAHM_gangMahjongCount",3);
    
    --结算 托管
    DZAHM_Data.isSettlementScore    = UnityEngine.PlayerPrefs.GetInt('DZAHM_isSettlementScore', 0) == 1;
    DZAHM_Data.fewerValue           = UnityEngine.PlayerPrefs.GetInt('DZAHM_fewerValue', 10);
	DZAHM_Data.addValue             = UnityEngine.PlayerPrefs.GetInt('DZAHM_addValue', 10);
    DZAHM_Data.trusteeship          = UnityEngine.PlayerPrefs.GetInt("DZAHM_trusteeshipTime",0);
    DZAHM_Data.trusteeshipDissolve  = UnityEngine.PlayerPrefs.GetInt("DZAHM_trusteeshipType",0) == 1;
    DZAHM_Data.trusteeshipRound     = UnityEngine.PlayerPrefs.GetInt("DZAHM_trusteeshipRound",0);
    DZAHM_Data.openGps              = UnityEngine.PlayerPrefs.GetInt("DZAHM_openGps",0) == 1;
    DZAHM_Data.openIp               = UnityEngine.PlayerPrefs.GetInt("DZAHM_openIp",0) == 1; 
    --翻倍
    DZAHM_Data.choiceDouble         = UnityEngine.PlayerPrefs.GetInt("DZAHM_choiceDouble",0) == 1
    DZAHM_Data.doubleScore          = UnityEngine.PlayerPrefs.GetInt("DZAHM_doubleScore",10)
    DZAHM_Data.multiple             = UnityEngine.PlayerPrefs.GetInt("DZAHM_multiple",2)
end

function this.OnClickRound(go)
    AudioManager.Instance:PlayAudio('btn')
    if go.gameObject == DZAHM_View.Round8Toggle.gameObject then
        DZAHM_Data.rounds = 8;
    elseif go.gameObject == DZAHM_View.Round12Toggle.gameObject then
        DZAHM_Data.rounds = 12;
    elseif go.gameObject == DZAHM_View.Round6Toggle.gameObject then 
        DZAHM_Data.rounds = 6;
    elseif go.gameObject == DZAHM_View.Round16Toggle.gameObject then 
        DZAHM_Data.rounds = 16;
    end
    payLabel.text = GetPayMun(proxy_pb.DZAHM,DZAHM_Data.rounds,DZAHM_Data.size,nil)
    UnityEngine.PlayerPrefs.SetInt("DZAHM_Rounds", DZAHM_Data.rounds);
end

--少人模式
function this.OnClickToggleLessPlayerStart(go)
	AudioManager.Instance:PlayAudio('btn')
	DZAHM_Data.minorityMode=DZAHM_View.ToggleLessPlayerStart:GetComponent("UIToggle").value
	UnityEngine.PlayerPrefs.SetInt('DZAHM_minorityMode',DZAHM_Data.minorityMode and 1 or 0)

	DZAHM_View.ToggleSettlementScoreSelect.parent.gameObject:SetActive(DZAHM_Data.minorityMode)
	DZAHM_View.ToggleChoiceDouble.parent.gameObject:SetActive(DZAHM_Data.minorityMode)
	DZAHM_View.ToggleMultiple2.parent.gameObject:SetActive(DZAHM_Data.minorityMode and DZAHM_Data.choiceDouble)
	gameObject:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickPeople(go)
    AudioManager.Instance:PlayAudio('btn');
    if go.gameObject == DZAHM_View.P2Toggle.gameObject then
        DZAHM_Data.size = 2;
    elseif go.gameObject == DZAHM_View.P3Toggle.gameObject then
        DZAHM_Data.size = 3;
    elseif go.gameObject == DZAHM_View.P4Toggle.gameObject then 
        DZAHM_Data.size = 4;
    end
    payLabel.text = GetPayMun(proxy_pb.DZAHM,DZAHM_Data.rounds,DZAHM_Data.size,nil)
    DZAHM_View.ToggleIPcheck.parent.gameObject:SetActive(DZAHM_Data.size > 2)
    UnityEngine.PlayerPrefs.SetInt("DZAHM_Size", DZAHM_Data.size)
    DZAHM_View.ToggleSettlementScoreSelect.parent.gameObject:SetActive(DZAHM_Data.size==2);
    DZAHM_View.ToggleChoiceDouble.parent.gameObject:SetActive(DZAHM_Data.size==2)
    DZAHM_View.ToggleMultiple2.parent.gameObject:SetActive(DZAHM_Data.size==2 and DZAHM_Data.choiceDouble)
	gameObject:Find('table'):GetComponent('UIGrid'):Reposition();
end

function this.OnClickPayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if go.gameObject == DZAHM_View.MasterPayToggle.gameObject then
        DZAHM_Data.paymentType = 0
    elseif go.gameObject == DZAHM_View.WinnerPayToggle.gameObject then
        DZAHM_Data.paymentType = 2
    end
    UnityEngine.PlayerPrefs.SetInt("DZAHM_PayType", DZAHM_Data.paymentType)
end

function this.OnClickBankerType(go)
    AudioManager.Instance:PlayAudio('btn');
    if go == DZAHM_View.ToggleFirstRandomBanker.gameObject then 
        DZAHM_Data.bankerRule = true;
    elseif go == DZAHM_View.ToggleFirstIsBanker.gameObject then 
        DZAHM_Data.bankerRule = false;
    end

    UnityEngine.PlayerPrefs.SetInt("DZAHM_bankerRule", DZAHM_Data.bankerRule and 1 or 0);

end



function this.OnClickTrusteeshipTime(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == DZAHM_View.ToggleTrusteeshipNo.gameObject then
		DZAHM_Data.trusteeship = 0
	elseif go == DZAHM_View.ToggleTrusteeship1.gameObject then
        DZAHM_Data.trusteeship = 1
    elseif go == DZAHM_View.ToggleTrusteeship2.gameObject then
		DZAHM_Data.trusteeship = 2
	elseif go == DZAHM_View.ToggleTrusteeship3.gameObject then
		DZAHM_Data.trusteeship = 3
	elseif go == DZAHM_View.ToggleTrusteeship5.gameObject then
		DZAHM_Data.trusteeship = 5
    end
    UnityEngine.PlayerPrefs.SetInt("DZAHM_trusteeshipTime", DZAHM_Data.trusteeship)
    DZAHM_View.ToggleTrusteeshipOne.parent.gameObject:SetActive(DZAHM_Data.trusteeship ~= 0)
    gameObject.transform:Find("table"):GetComponent("UIGrid"):Reposition();
end

function this.OnClickTrusteeshipType(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == DZAHM_View.ToggleTrusteeshipAll.gameObject then
        DZAHM_Data.trusteeshipDissolve = false;
        DZAHM_Data.trusteeshipRound = 0;
	elseif go == DZAHM_View.ToggleTrusteeshipOne.gameObject then
        DZAHM_Data.trusteeshipDissolve = true;
        DZAHM_Data.trusteeshipRound = 0;
    elseif go == DZAHM_View.ToggleTrusteeshipThree.gameObject then 
        DZAHM_Data.trusteeshipDissolve = false;
        DZAHM_Data.trusteeshipRound = 3;
    end
    UnityEngine.PlayerPrefs.SetInt("DZAHM_trusteeshipType",DZAHM_Data.trusteeshipDissolve and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("DZAHM_trusteeshipRound",DZAHM_Data.trusteeshipRound);
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if DZAHM_View.ToggleIPcheck.gameObject == go then
		DZAHM_Data.openIp = DZAHM_View.ToggleIPcheck:GetComponent('UIToggle').value
	elseif DZAHM_View.ToggleGPScheck.gameObject == go then
		DZAHM_Data.openGps = DZAHM_View.ToggleGPScheck:GetComponent('UIToggle').value
    end
    UnityEngine.PlayerPrefs.SetInt("DZAHM_openIp",DZAHM_Data.openIp and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("DZAHM_openGps",DZAHM_Data.openGps and 1 or 0);
end

function this.GetConfig()
	
	local moneyLess = false;
    DZAHM_Data.Qianganhu               = DZAHM_View.ToggleQianganhu:GetComponent("UIToggle").value;
    DZAHM_Data.floatScore              = DZAHM_View.TogglePiaofen:GetComponent("UIToggle").value;
    DZAHM_Data.WangDai                 = DZAHM_View.ToggleWangDai:GetComponent("UIToggle").value;
    DZAHM_Data.Yipaoduoxiang           = DZAHM_View.ToggleYipaoduoxiang:GetComponent("UIToggle").value;
    DZAHM_Data.Gangshanpao             = DZAHM_View.ToggleGangshanpao:GetComponent("UIToggle").value;
    

    UnityEngine.PlayerPrefs.SetInt("DZAHM_Qianganhu",            DZAHM_Data.Qianganhu and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("DZAHM_floatScore",             DZAHM_Data.floatScore and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("DZAHM_WangDai",          DZAHM_Data.WangDai and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("DZAHM_Yipaoduoxiang",  DZAHM_Data.Yipaoduoxiang and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("DZAHM_Gangshanpao",         DZAHM_Data.Gangshanpao and 1 or 0);

    local settings                  = {}
    settings.roomType               = proxy_pb.DZAHM;
    settings.rounds                 = DZAHM_Data.rounds;
    settings.minorityMode 			= DZAHM_Data.minorityMode
    settings.size                   = DZAHM_Data.size;
    settings.paymentType            = DZAHM_Data.paymentType;
    settings.anBankerRule           = DZAHM_Data.bankerRule;  
    settings.ahBaseScore            = DZAHM_Data.bottomScore; 

    

    settings.ahQiangGangHu          = DZAHM_Data.Qianganhu;   
    settings.ahFloatScore           = DZAHM_Data.floatScore;   
    settings.ahStoreBanker          = DZAHM_Data.WangDai;   
    settings.ahHuMultiple           = DZAHM_Data.Yipaoduoxiang;   
    settings.ahGangShangPaoHu       = DZAHM_Data.Gangshanpao; 

    settings.ahFixedFloat           = DZAHM_Data.choiceRegular and DZAHM_Data.regularScore or 0; 
    
    settings.ahBird                 = DZAHM_Data.birdNum; 
    settings.ahBird159              = DZAHM_Data.birdType == 0; 
    settings.ahBirdBankerStart      = DZAHM_Data.birdType == 1; 
    settings.ahBirdWinStart         = DZAHM_Data.birdType == 2; 

    settings.ahKingCount            = DZAHM_Data.King; 
    settings.ahGangMahjongCount     = DZAHM_Data.gangMahjongCount; 
    
    settings.resultScore            = this.getResultScore(DZAHM_Data);
    settings.resultLowerScore       = this.getResultLowerScore(DZAHM_Data);
    settings.resultAddScore         = this.getResultAddScore(DZAHM_Data);
    settings.trusteeship            = DZAHM_Data.trusteeship * 60;
    settings.trusteeshipDissolve    = DZAHM_Data.trusteeshipDissolve;
    settings.trusteeshipRound       = DZAHM_Data.trusteeshipRound;
    settings.openIp                 = DZAHM_Data.openIp;
    settings.openGps                = DZAHM_Data.openGps;
    if DZAHM_Data.size == 2 then
        settings.openIp =false;
        settings.openGps = false;
    end
    if DZAHM_Data.size == 2 or DZAHM_Data.minorityMode then
		settings.resultScore = DZAHM_Data.isSettlementScore
		if DZAHM_Data.isSettlementScore then
			settings.resultLowerScore=DZAHM_Data.fewerValue
			settings.resultAddScore=DZAHM_Data.addValue
		end
		settings.choiceDouble = DZAHM_Data.choiceDouble
		settings.doubleScore = DZAHM_Data.doubleScore
		settings.multiple = DZAHM_Data.multiple
	end
    print("settings------");
    print_r(settings);
    return moneyLess,settings;
    
end

function this.getResultScore(DZAHM_Data)
    if DZAHM_Data.size == 2 then 
        return DZAHM_Data.isSettlementScore;
    end
    return nil;
end

function this.getResultLowerScore(DZAHM_Data)
    if DZAHM_Data.size == 2 then 
        if DZAHM_Data.isSettlementScore then 
            return DZAHM_Data.fewerValue;
        end
    end
    
    return nil;
end

function this.getResultAddScore(DZAHM_Data)
    if DZAHM_Data.size == 2 then 
        if DZAHM_Data.isSettlementScore then 
            return DZAHM_Data.addValue;
        end
    end
    
    return nil;
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    DZAHM_Data.isSettlementScore= DZAHM_View.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt("DZAHM_isSettlementScore", DZAHM_Data.isSettlementScore and 1 or 0)
end


function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if DZAHM_View.ToggleFewerAddButton.gameObject == go then
		DZAHM_Data.fewerValue = DZAHM_Data.fewerValue + 1
		if DZAHM_Data.fewerValue > 100 then
			DZAHM_Data.fewerValue = 100
		end
    elseif DZAHM_View.ToggleFewerSubtractButton.gameObject == go then
		DZAHM_Data.fewerValue = DZAHM_Data.fewerValue - 1
		if DZAHM_Data.fewerValue < 1 then
			DZAHM_Data.fewerValue = 1
		end
	end
	DZAHM_View.ToggleFewerScoreTxt:GetComponent('UILabel').text = DZAHM_Data.fewerValue;
	UnityEngine.PlayerPrefs.SetInt("DZAHM_fewerValue", DZAHM_Data.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if DZAHM_View.ToggleAddAddButton.gameObject == go then
		DZAHM_Data.addValue = DZAHM_Data.addValue + 1
		if DZAHM_Data.addValue > 100 then
			DZAHM_Data.addValue = 100
		end
    elseif DZAHM_View.ToggleAddSubtractButton.gameObject == go then
		DZAHM_Data.addValue = DZAHM_Data.addValue - 1
		if DZAHM_Data.addValue < 1 then
			DZAHM_Data.addValue = 1
		end
	end
	DZAHM_View.ToggleAddScoreTxt:GetComponent('UILabel').text = DZAHM_Data.addValue;
	UnityEngine.PlayerPrefs.SetInt("DZAHM_addValue", DZAHM_Data.addValue)
end

function this.OnClickChoiceDouble(go)
    AudioManager.Instance:PlayAudio('btn')
	if DZAHM_View.ToggleChoiceDouble.gameObject == go then
		DZAHM_Data.choiceDouble = true
	else
		DZAHM_Data.choiceDouble = false
	end
	DZAHM_View.DoubleScoreText.parent.gameObject:SetActive(DZAHM_Data.choiceDouble)
    DZAHM_View.ToggleMultiple2.parent.gameObject:SetActive(DZAHM_Data.choiceDouble)
    if DZAHM_Data.choiceDouble then
		DZAHM_View.ToggleMultiple2:GetComponent('UIToggle'):Set(DZAHM_Data.multiple == 2)
		DZAHM_View.ToggleMultiple3:GetComponent('UIToggle'):Set(DZAHM_Data.multiple == 3)
		DZAHM_View.ToggleMultiple4:GetComponent('UIToggle'):Set(DZAHM_Data.multiple == 4)
	end
    gameObject:Find('table'):GetComponent('UIGrid'):Reposition();
    UnityEngine.PlayerPrefs.SetInt("DZAHM_choiceDouble", DZAHM_Data.choiceDouble and 1 or 0)
end

function this.OnClickChangeDoubleScore(go)
    AudioManager.Instance:PlayAudio('btn')
    local label_= DZAHM_View.DoubleScoreText:GetComponent('UILabel').text
    if label_=='不限分' then
        DZAHM_Data.doubleScore=0
    else
        DZAHM_Data.doubleScore=tonumber(string.sub(label_,7,-4))    
    end
	if DZAHM_View.AddDoubleScoreButton.gameObject == go then
		if DZAHM_Data.doubleScore ~= 0 then
			DZAHM_Data.doubleScore = DZAHM_Data.doubleScore + 1
			if DZAHM_Data.doubleScore > 100 then
				DZAHM_Data.doubleScore = 0
			end
		end
	else
		if DZAHM_Data.doubleScore == 0 then
			DZAHM_Data.doubleScore = 100
		else
			DZAHM_Data.doubleScore = DZAHM_Data.doubleScore - 1
			if DZAHM_Data.doubleScore < 1 then
				DZAHM_Data.doubleScore = 1
			end
		end
	end

	if DZAHM_Data.doubleScore == 0 then
		DZAHM_View.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		DZAHM_View.DoubleScoreText:GetComponent('UILabel').text = '小于'..DZAHM_Data.doubleScore..'分'
    end
    UnityEngine.PlayerPrefs.SetInt("DZAHM_doubleScore", DZAHM_Data.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
    DZAHM_Data.multiple = tonumber(go.name)
    UnityEngine.PlayerPrefs.SetInt("DZAHM_multiple", DZAHM_Data.multiple)
end

--底分
function this.OnClickChangeDiFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if DZAHM_View.AddBtnDiFen.gameObject == go then
		DZAHM_Data.bottomScore = DZAHM_Data.bottomScore + 1
		if DZAHM_Data.bottomScore > 10 then
			DZAHM_Data.bottomScore = 10
		end
    elseif DZAHM_View.SubtractBtnDiFen.gameObject == go then
        DZAHM_Data.bottomScore = DZAHM_Data.bottomScore - 1
		if DZAHM_Data.bottomScore < 1 then
			DZAHM_Data.bottomScore = 1
		end
	end
	DZAHM_View.DiFenTunValue:GetComponent("UILabel").text = DZAHM_Data.bottomScore..'分'
    UnityEngine.PlayerPrefs.SetInt('DZAHM_bottomScore', DZAHM_Data.bottomScore)
end

--飘分
function this.OnClickRegularScore(go)
    AudioManager.Instance:PlayAudio('btn')
	if DZAHM_View.ToggleRegularScoreOnButton.gameObject == go then
		DZAHM_View.TogglePiaofen:GetComponent('UIToggle'):Set(false)
		DZAHM_Data.floatScore = false
    	UnityEngine.PlayerPrefs.SetInt('DZAHM_floatScore', 0)
		DZAHM_Data.choiceRegular = true
	else
        DZAHM_Data.choiceRegular = false
	end
	UnityEngine.PlayerPrefs.SetInt('DZAHM_choiceRegular', DZAHM_Data.choiceRegular and 1 or 0)
    DZAHM_View.RegularScoreTxt.parent.gameObject:SetActive(DZAHM_Data.choiceRegular)
end

--飘分增减
function this.OnClickChangeRegularScore(go)
    AudioManager.Instance:PlayAudio('btn')
    local label_= DZAHM_View.RegularScoreTxt:GetComponent('UILabel').text
    DZAHM_Data.regularScore=tonumber(string.sub(label_,1,-4))
	if DZAHM_View.RegularAddButton.gameObject == go then
		DZAHM_Data.regularScore = DZAHM_Data.regularScore + 1
		if DZAHM_Data.regularScore > 10 then
			DZAHM_Data.regularScore = 1
		end
	else
		DZAHM_Data.regularScore = DZAHM_Data.regularScore - 1
		if DZAHM_Data.regularScore < 1 then
			DZAHM_Data.regularScore = 10
		end
	end

	DZAHM_View.RegularScoreTxt:GetComponent('UILabel').text = DZAHM_Data.regularScore..'分'
	UnityEngine.PlayerPrefs.SetInt('DZAHM_regularScore', DZAHM_Data.regularScore)
end

--抓鸟
function this.OnClickToggleNiaoType(go)
	AudioManager.Instance:PlayAudio('btn')
	if DZAHM_View.ToggleWinPos.gameObject == go then
		DZAHM_Data.birdType = 2
	elseif DZAHM_View.Toggle159Bird.gameObject == go then
		DZAHM_Data.birdType = 0
	elseif DZAHM_View.ToggleNoBird.gameObject == go then
        DZAHM_Data.birdType = 3
    elseif DZAHM_View.TogglebankerPos.gameObject == go then
		DZAHM_Data.birdType = 1
	end
	UnityEngine.PlayerPrefs.SetInt('DZAHM_birdType',DZAHM_Data.birdType)
	DZAHM_View.ToggleCatchBird.gameObject:SetActive(DZAHM_Data.birdType~=3)
	gameObject.transform:Find("table"):GetComponent('UIGrid'):Reposition()
end
--抓鸟1246
function this.OnClickButtonNiaoNumDZAHM_View(go)
	if DZAHM_View.changshaNiao1.gameObject == go then
		DZAHM_View.birdNum = 1
	elseif DZAHM_View.changshaNiao2.gameObject == go then
		DZAHM_View.birdNum = 2
	elseif DZAHM_View.changshaNiao4.gameObject == go then
		DZAHM_View.birdNum = 4
	elseif DZAHM_View.changshaNiao6.gameObject == go then
		DZAHM_View.birdNum = 6
	end
	UnityEngine.PlayerPrefs.SetInt("DZAHM_birdNum",DZAHM_View.birdNum);
end
--王 4 7
function this.OnClickButtonKing(go)
    if DZAHM_View.ToggleKing4.gameObject == go then
		DZAHM_Data.King = 4
	elseif DZAHM_View.ToggleKing7.gameObject == go then
        DZAHM_Data.King = 7
    end
    UnityEngine.PlayerPrefs.SetInt("DZAHM_King", DZAHM_Data.King)
end
--杠牌个数
function this.OnClickToggleKaigang(go)
	if DZAHM_View.changshaKaigang2.gameObject == go then
		DZAHM_Data.gangMahjongCount = 2
	elseif DZAHM_View.changshaKaigang3.gameObject == go then
		DZAHM_Data.gangMahjongCount = 3
	elseif DZAHM_View.changshaKaigang4.gameObject == go then
		DZAHM_Data.gangMahjongCount = 4
	end
	UnityEngine.PlayerPrefs.SetInt("DZAHM_gangMahjongCount",DZAHM_Data.gangMahjongCount);
end

--玩法方法
function this.OnClickWanFa(go)
    local value = go.transform:GetComponent("UIToggle").value
    local intValue = value and 1 or 0
    local key
    if DZAHM_View.ToggleQianganhu.gameObject == go then
        key = "DZAHM_Qianganhu"
    elseif DZAHM_View.TogglePiaofen.gameObject == go then--飘分
        key = "DZAHM_floatScore"
        if go:GetComponent('UIToggle').value == true then
            DZAHM_View.ToggleRegularScoreOffButton:GetComponent('UIToggle'):Set(true)
            DZAHM_View.ToggleRegularScoreOnButton:GetComponent('UIToggle'):Set(false)
            DZAHM_Data.choiceRegular = false
            UnityEngine.PlayerPrefs.SetInt('DZAHM_choiceRegular', 0)
            DZAHM_View.RegularScoreTxt.parent.gameObject:SetActive(false)
            DZAHM_Data.floatScore = true
        else
            DZAHM_Data.floatScore = false
        end
    elseif DZAHM_View.ToggleWangDai.gameObject == go then
        key = "DZAHM_WangDai"
    elseif DZAHM_View.ToggleYipaoduoxiang.gameObject == go then
        key = "DZAHM_Yipaoduoxiang"
    elseif DZAHM_View.ToggleGangshanpao.gameObject == go then
        key = "DZAHM_Gangshanpao"
    end
    UnityEngine.PlayerPrefs.SetInt(key, intValue);
end

return this;

