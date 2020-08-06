
panelCreateDZAHMSet = {}
require("proxy_pb")
local json = require("json")
local this = panelCreateDZAHMSet;
local message;
local gameObject;
local payLabel
local DZAHM_View = {}
local DZAHM_Data = {}
local optionData = {};
local curSelectPlay = {}
local DZAHMPanel

function this.Awake(go)
    print("Awake was called");
    gameObject                              = go;
    message                                 = gameObject:GetComponent('LuaBehaviour');
    payLabel                                = gameObject.transform:Find('pay_label'):GetComponent('UILabel')

    DZAHM_View.RuleButton                   = gameObject.transform:Find('RuleButton');
    DZAHMPanel                              = gameObject.transform:Find("DZAHMPanel/table");
    DZAHM_View.wanFaTitle                   = gameObject.transform:Find("title/Label");

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

    message:AddClick(DZAHM_View.RuleButton.gameObject, this.OnShowRuleInfo);

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
    print("panelCreateDZAHMSet's WhoShow was called----------->");
    if data.optionData ~= nil then
        optionData           = data.optionData;
        optionData.playId    = data.playId;
        optionData.ruleId    = data.ruleId;
    end
    DZAHMPanel         = gameObject.transform:Find("DZAHMPanel");
    this.OnEnableRefresh(data);
    DZAHMPanel:Find("table"):GetComponent("UIGrid"):Reposition();
    DZAHMPanel:GetComponent("UIScrollView"):ResetPosition();
end

function this.OnEnableRefresh(data)
    local titleStr = ''
    curSelectPlay = {}
    
    if optionData.addRule or optionData.addPlay then
        titleStr = '当前玩法：'..'安化麻将';
        curSelectPlay = DZAHM_Data;
        print("path--------->1");
    elseif not optionData.addPlay and not optionData.addRule then
        print("path---------->2");
        print("data.settings------>:"..data.settings);
        curSelectPlay = json:decode(data.settings)
        titleStr = '当前规则：'..GetDZAHMRuleText(curSelectPlay, false, false);
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

    DZAHM_View.wanFaTitle:GetComponent('UILabel').text = titleStr;
    print("DZAHM_View.wanFaTitle----->"..tostring(DZAHM_View.wanFaTitle));

    this.SetPreSetting(curSelectPlay)
    payLabel.text = GetPayMun(proxy_pb.DZAHM,curSelectPlay.rounds,curSelectPlay.size,nil)
end

function this.SetPreSetting()
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
    DZAHMPanel:Find("table"):GetComponent("UIGrid"):Reposition();
end

function this.OnEnable()
    print("OnEnable was called");
    this.GetDataPrefab()
end

function this.GetDataPrefab()
    DZAHM_Data.rounds               = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_Rounds", 8);
    DZAHM_Data.size                 = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_Size", 2);
    DZAHM_Data.minorityMode         = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_minorityMode", 1) == 1;
    DZAHM_Data.paymentType          = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_PayType", 0);
    DZAHM_Data.bankerRule           = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_bankerRule",0) == 1;
    DZAHM_Data.bottomScore          = UnityEngine.PlayerPrefs.GetInt('CLBDZAHM_bottomScore', 1)
    
    DZAHM_Data.Qianganhu            = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_Qianganhu",1) == 1;
    DZAHM_Data.floatScore              = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_floatScore",0) == 1;
    DZAHM_Data.WangDai              = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_WangDai",1) == 1;
    DZAHM_Data.Yipaoduoxiang        = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_Yipaoduoxiang",0) == 1;
    DZAHM_Data.Gangshanpao          = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_Gangshanpao",1) == 1;

    --固定飘分
    DZAHM_Data.choiceRegular = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_choiceRegular", 0)==1
	DZAHM_Data.regularScore = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_regularScore", 1)

    --抓鸟
    DZAHM_Data.birdType                   = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_birdType",0);
    DZAHM_Data.birdNum                    = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_birdNum",1);
    
    --王
    DZAHM_Data.King                    = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_King",4);
    
    --杠牌个数
    DZAHM_Data.gangMahjongCount      = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_gangMahjongCount",3);
    
    --结算 托管
    DZAHM_Data.isSettlementScore    = UnityEngine.PlayerPrefs.GetInt('CLBDZAHM_isSettlementScore', 0) == 1;
    DZAHM_Data.fewerValue           = UnityEngine.PlayerPrefs.GetInt('CLBDZAHM_fewerValue', 10);
	DZAHM_Data.addValue             = UnityEngine.PlayerPrefs.GetInt('CLBDZAHM_addValue', 10);
    DZAHM_Data.trusteeship          = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_trusteeshipTime",0);
    DZAHM_Data.trusteeshipDissolve  = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_trusteeshipType",0) == 1;
    DZAHM_Data.trusteeshipRound     = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_trusteeshipRound",0);
    DZAHM_Data.openGps              = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_openGps",0) == 1;
    DZAHM_Data.openIp               = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_openIp",0) == 1; 
    --翻倍
    DZAHM_Data.choiceDouble         = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_choiceDouble",0) == 1
    DZAHM_Data.doubleScore          = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_doubleScore",10)
    DZAHM_Data.multiple             = UnityEngine.PlayerPrefs.GetInt("CLBDZAHM_multiple",2)
end

function this.SetSetting(settings)
    DZAHM_Data.rounds                = settings.rounds;              
    DZAHM_Data.size                  = settings.size ;               
    DZAHM_Data.paymentType           = settings.paymentType;         
    DZAHM_Data.bankerRule            = settings.bankerRule;          
    DZAHM_Data.playChoose            = settings.playChoose;          
    DZAHM_Data.huPattern             = settings.huPattern;           
    DZAHM_Data.takeFeng              = settings.takeFeng           
    DZAHM_Data.gangPao               = settings.gangPao           
    DZAHM_Data.bankerBase            = settings.bankerBase        
    DZAHM_Data.gangShangHuaJiaBei    = settings.gangShangHuaJiaBei
    DZAHM_Data.qiDuiJiaBei           = settings.qiDuiJiaBei       
    DZAHM_Data.takHunMode            = settings.takHunMode        
    DZAHM_Data.selectPao             = settings.selectPao         
    DZAHM_Data.selectPaoScore        = settings.selectPaoScore    
    DZAHM_Data.resultScore           = settings.resultScore;         
    DZAHM_Data.resultLowerScore      = settings.resultLowerScore;    
	DZAHM_Data.resultAddScore        = settings.resultAddScore;      
    DZAHM_Data.trusteeship           = settings.trusteeship;         
    DZAHM_Data.trusteeshipDissolve   = settings.trusteeshipDissolve; 
    DZAHM_Data.trusteeshipRound      = settings.trusteeshipRound;   
    DZAHM_Data.openGps               = settings.openGps;   
    DZAHM_Data.openIp                = settings.openIp;   
    if settings.choiceDouble == nil then
        DZAHM_Data.choiceDouble          = false
        DZAHM_Data.doubleScore           = 10
        DZAHM_Data.multiple              = 2
    else
        DZAHM_Data.choiceDouble          = settings.choiceDouble; 
        DZAHM_Data.doubleScore           = settings.doubleScore; 
        DZAHM_Data.multiple              = settings.multiple; 
    end
end

function this.OnClickRound(go)
    
    AudioManager.Instance:PlayAudio('btn');
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
    UnityEngine.PlayerPrefs.SetInt("CLBDZAHM_Rounds", DZAHM_Data.rounds);
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
    UnityEngine.PlayerPrefs.SetInt("CLBDZAHM_Size", DZAHM_Data.size)
    DZAHM_View.ToggleSettlementScoreSelect.parent.gameObject:SetActive(DZAHM_Data.size==2);
    DZAHM_View.ToggleChoiceDouble.parent.gameObject:SetActive(DZAHM_Data.size==2)
    DZAHM_View.ToggleMultiple2.parent.gameObject:SetActive(DZAHM_Data.size==2 and DZAHM_Data.choiceDouble)
	DZAHMPanel:Find("table"):GetComponent("UIGrid"):Reposition();
end

--少人模式
function this.OnClickToggleLessPlayerStart(go)
	AudioManager.Instance:PlayAudio('btn')
	DZAHM_Data.minorityMode=DZAHM_View.ToggleLessPlayerStart:GetComponent("UIToggle").value
	UnityEngine.PlayerPrefs.SetInt('CLBDZAHM_minorityMode',DZAHM_Data.minorityMode and 1 or 0)

	DZAHM_View.ToggleSettlementScoreSelect.parent.gameObject:SetActive(DZAHM_Data.minorityMode)
	DZAHM_View.ToggleChoiceDouble.parent.gameObject:SetActive(DZAHM_Data.minorityMode)
	DZAHM_View.ToggleMultiple2.parent.gameObject:SetActive(DZAHM_Data.minorityMode and DZAHM_Data.choiceDouble)
	DZAHMPanel:Find("table"):GetComponent("UIGrid"):Reposition();
end

function this.OnClickPayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if go.gameObject == DZAHM_View.MasterPayToggle.gameObject then
        DZAHM_Data.paymentType = 0
    elseif go.gameObject == DZAHM_View.WinnerPayToggle.gameObject then
        DZAHM_Data.paymentType = 2
    end
    UnityEngine.PlayerPrefs.SetInt("CLBDZAHM_PayType", DZAHM_Data.paymentType)
end

function this.OnClikWinType(go)
    AudioManager.Instance:PlayAudio('btn')
    if go == DZAHM_View.ToggleMustSelfMo.gameObject then 
        DZAHM_Data.huPattern = true;
    elseif go == DZAHM_View.ToggleCanDianPao.gameObject then 
        DZAHM_Data.huPattern = false;
    end
    UnityEngine.PlayerPrefs.SetInt("CLBDZAHM_huPattern", DZAHM_Data.huPattern and 1 or 0);
end

function this.OnClickBankerType(go)
    AudioManager.Instance:PlayAudio('btn');
    if go == DZAHM_View.ToggleFirstRandomBanker.gameObject then 
        DZAHM_Data.bankerRule = true;
    elseif go == DZAHM_View.ToggleFirstIsBanker.gameObject then 
        DZAHM_Data.bankerRule = false;
    end
    UnityEngine.PlayerPrefs.SetInt("CLBDZAHM_bankerRule", DZAHM_Data.bankerRule and 1 or 0);

end


function this.OnClickTrusteeshipTime(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == DZAHM_View.ToggleTrusteeshipNo.gameObject then
		DZAHM_Data.trusteeship = 0
	elseif go == DZAHM_View.ToggleTrusteeship1.gameObject then
        DZAHM_Data.trusteeship = 60
    elseif go == DZAHM_View.ToggleTrusteeship2.gameObject then
		DZAHM_Data.trusteeship = 120
	elseif go == DZAHM_View.ToggleTrusteeship3.gameObject then
		DZAHM_Data.trusteeship = 180
	elseif go == DZAHM_View.ToggleTrusteeship5.gameObject then
		DZAHM_Data.trusteeship = 300
    end
    UnityEngine.PlayerPrefs.SetInt("CLBDZAHM_trusteeshipTime", DZAHM_Data.trusteeship)
    DZAHM_View.ToggleTrusteeshipOne.parent.gameObject:SetActive(DZAHM_Data.trusteeship ~= 0)
    DZAHMPanel:Find("table"):GetComponent("UIGrid"):Reposition();
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
    UnityEngine.PlayerPrefs.SetInt("CLBDZAHM_trusteeshipType",DZAHM_Data.trusteeshipDissolve and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("CLBDZAHM_trusteeshipRound",DZAHM_Data.trusteeshipRound);
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if DZAHM_View.ToggleIPcheck.gameObject == go then
		DZAHM_Data.openIp = DZAHM_View.ToggleIPcheck:GetComponent('UIToggle').value
	elseif DZAHM_View.ToggleGPScheck.gameObject == go then
		DZAHM_Data.openGps = DZAHM_View.ToggleGPScheck:GetComponent('UIToggle').value
	end
end

function this.GetConfig()
    
    DZAHM_Data.Qianganhu               = DZAHM_View.ToggleQianganhu:GetComponent("UIToggle").value;
    DZAHM_Data.floatScore              = DZAHM_View.TogglePiaofen:GetComponent("UIToggle").value;
    DZAHM_Data.WangDai                 = DZAHM_View.ToggleWangDai:GetComponent("UIToggle").value;
    DZAHM_Data.Yipaoduoxiang           = DZAHM_View.ToggleYipaoduoxiang:GetComponent("UIToggle").value;
    DZAHM_Data.Gangshanpao             = DZAHM_View.ToggleGangshanpao:GetComponent("UIToggle").value;
    

    UnityEngine.PlayerPrefs.SetInt("CLBDZAHM_Qianganhu",            DZAHM_Data.Qianganhu and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("CLBDZAHM_floatScore",             DZAHM_Data.floatScore and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("CLBDZAHM_WangDai",          DZAHM_Data.WangDai and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("CLBDZAHM_Yipaoduoxiang",  DZAHM_Data.Yipaoduoxiang and 1 or 0);
    UnityEngine.PlayerPrefs.SetInt("CLBDZAHM_Gangshanpao",         DZAHM_Data.Gangshanpao and 1 or 0);

    local settings                  = {}
    settings.roomType               = proxy_pb.DZAHM;
    settings.rounds                 = DZAHM_Data.rounds;
    settings.minorityMode 			= DZAHM_Data.minorityMode
    settings.size                   = DZAHM_Data.size;
    settings.paymentType            = 3;
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
    return settings;
end

function this.OnClickOk(go)
    if optionData.addPlay == true then
        optionData.currentOption = "addPlay";
        local msg           = Message.New();
        msg.type            = proxy_pb.CREATE_CLUB_PLAY;
        local bigbody       = proxy_pb.PCreateClubPlay();
        bigbody.gameType    = proxy_pb.DZM
        bigbody.roomType    = proxy_pb.DZAHM;
        bigbody.name        = '安化麻将';
        bigbody.clubId      = panelClub.clubInfo.clubId;
        local settings      = this.GetConfig();
        bigbody.settings    = json:encode(settings);
        print("bigbody.settings"..bigbody.settings);
        msg.body            = bigbody:SerializeToString();
        SendProxyMessage(msg, this.OnCreateClubPlayResult);
        print('add_DZAHM_Play');

    elseif optionData.addRule == true then
        optionData.currentOption = "addRule";
        local msg           = Message.New();
        msg.type            = proxy_pb.CREATE_PLAY_RULE;
        local bigbody       = proxy_pb.PCreatePlayRule();
        bigbody.gameType    = proxy_pb.DZM;
        bigbody.playId      = optionData.playId;
        bigbody.clubId      = panelClub.clubInfo.clubId;
        local settings      = this.GetConfig();
        bigbody.settings    = json:encode(settings);
        msg.body            = bigbody:SerializeToString();
        SendProxyMessage(msg, this.OnCreateClubPlayResult);
        print('add_DZAHM_Rule');
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
        print('update_DZAHM_Rule')
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
    PanelManager.Instance:ShowWindow("panelInGame_dzahm", gameObject.name);
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
    PanelManager.Instance:ShowWindow('panelHelp', proxy_pb.DZAHM);
end


function this.getResultScore(DZAHM_Data)
    if DZAHM_Data.size == 2 then 
        return DZAHM_Data.resultScore;
    end
    return nil;
end

function this.getResultLowerScore(DZAHM_Data)
    if DZAHM_Data.size == 2 then 
        if DZAHM_Data.resultScore then 
            return DZAHM_Data.resultLowerScore;
        end
    end
    
    return nil;
end

function this.getResultAddScore(DZAHM_Data)
    if DZAHM_Data.size == 2 then 
        if DZAHM_Data.resultScore then 
            return DZAHM_Data.resultAddScore;
        end
    end
    
    return nil;
end


function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    DZAHM_Data.resultScore= DZAHM_View.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt("CLBDZAHM_resultScore", DZAHM_Data.resultScore and 1 or 0)
end


function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if DZAHM_View.ToggleFewerAddButton.gameObject == go then
		DZAHM_Data.resultLowerScore = DZAHM_Data.resultLowerScore + 1
		if DZAHM_Data.resultLowerScore > 100 then
			DZAHM_Data.resultLowerScore = 100
		end
    elseif DZAHM_View.ToggleFewerSubtractButton.gameObject == go then
		DZAHM_Data.resultLowerScore = DZAHM_Data.resultLowerScore - 1
		if DZAHM_Data.resultLowerScore < 1 then
			DZAHM_Data.resultLowerScore = 1
		end
	end
	DZAHM_View.ToggleFewerScoreTxt:GetComponent('UILabel').text = DZAHM_Data.resultLowerScore;
	UnityEngine.PlayerPrefs.SetInt("CLBDZAHM_resultLowerScore", DZAHM_Data.resultLowerScore)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if DZAHM_View.ToggleAddAddButton.gameObject == go then
		DZAHM_Data.resultAddScore = DZAHM_Data.resultAddScore + 1
		if DZAHM_Data.resultAddScore > 100 then
			DZAHM_Data.resultAddScore = 100
		end
    elseif DZAHM_View.ToggleAddSubtractButton.gameObject == go then
		DZAHM_Data.resultAddScore = DZAHM_Data.resultAddScore - 1
		if DZAHM_Data.resultAddScore < 1 then
			DZAHM_Data.resultAddScore = 1
		end
	end
	DZAHM_View.ToggleAddScoreTxt:GetComponent('UILabel').text = DZAHM_Data.resultAddScore;
	UnityEngine.PlayerPrefs.SetInt("CLBDZAHM_resultAddScore", DZAHM_Data.resultAddScore)
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
	DZAHMPanel:Find("table"):GetComponent("UIGrid"):Reposition();
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
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
	DZAHM_Data.multiple = tonumber(go.name)
	print('倍数：'..DZAHM_Data.multiple)
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
    UnityEngine.PlayerPrefs.SetInt('CLBDZAHM_bottomScore', DZAHM_Data.bottomScore)
end

--飘分
function this.OnClickRegularScore(go)
    AudioManager.Instance:PlayAudio('btn')
	if DZAHM_View.ToggleRegularScoreOnButton.gameObject == go then
		DZAHM_View.TogglePiaofen:GetComponent('UIToggle'):Set(false)
		DZAHM_Data.floatScore = false
    	UnityEngine.PlayerPrefs.SetInt('CLBDZAHM_floatScore', 0)
		DZAHM_Data.choiceRegular = true
	else
        DZAHM_Data.choiceRegular = false
	end
	UnityEngine.PlayerPrefs.SetInt('CLBDZAHM_choiceRegular', DZAHM_Data.choiceRegular and 1 or 0)
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
	UnityEngine.PlayerPrefs.SetInt('CLBDZAHM_regularScore', DZAHM_Data.regularScore)
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
	UnityEngine.PlayerPrefs.SetInt('CLBDZAHM_birdType',DZAHM_Data.birdType)
	DZAHM_View.ToggleCatchBird.gameObject:SetActive(DZAHM_Data.birdType~=3)
	DZAHMPanel:Find("table"):GetComponent("UIGrid"):Reposition();
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
	UnityEngine.PlayerPrefs.SetInt("CLBDZAHM_birdNum",DZAHM_View.birdNum);
end
--王 4 7
function this.OnClickButtonKing(go)
    if DZAHM_View.ToggleKing4.gameObject == go then
		DZAHM_Data.King = 4
	elseif DZAHM_View.ToggleKing7.gameObject == go then
        DZAHM_Data.King = 7
    end
    UnityEngine.PlayerPrefs.SetInt("CLBDZAHM_King", DZAHM_Data.King)
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
	UnityEngine.PlayerPrefs.SetInt("CLBDZAHM_gangMahjongCount",DZAHM_Data.gangMahjongCount);
end

--玩法方法
function this.OnClickWanFa(go)
    local value = go.transform:GetComponent("UIToggle").value
    local intValue = value and 1 or 0
    local key
    if DZAHM_View.ToggleQianganhu.gameObject == go then
        key = "CLBDZAHM_Qianganhu"
    elseif DZAHM_View.TogglePiaofen.gameObject == go then--飘分
        key = "CLBDZAHM_floatScore"
        if go:GetComponent('UIToggle').value == true then
            DZAHM_View.ToggleRegularScoreOffButton:GetComponent('UIToggle'):Set(true)
            DZAHM_View.ToggleRegularScoreOnButton:GetComponent('UIToggle'):Set(false)
            DZAHM_Data.choiceRegular = false
            UnityEngine.PlayerPrefs.SetInt('CLBDZAHM_choiceRegular', 0)
            DZAHM_View.RegularScoreTxt.parent.gameObject:SetActive(false)
            DZAHM_Data.floatScore = true
        else
            DZAHM_Data.floatScore = false
        end
    elseif DZAHM_View.ToggleWangDai.gameObject == go then
        key = "CLBDZAHM_WangDai"
    elseif DZAHM_View.ToggleYipaoduoxiang.gameObject == go then
        key = "CLBDZAHM_Yipaoduoxiang"
    elseif DZAHM_View.ToggleGangshanpao.gameObject == go then
        key = "CLBDZAHM_Gangshanpao"
    end
    UnityEngine.PlayerPrefs.SetInt(key, intValue);
end