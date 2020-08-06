local this = {}

local PDKSWZ
local payLabel

local pdkswz = {
	rounds=10, -- 局数
	size=2 , --人数
	paymentType=0, --支付类型
	trusteeshipTime=0,
	trusteeshipType=true,
	trusteeshipRound=0,

	firstPlay=1, -- 谁先出
	bichu3=false,
	remainBanker=true ,-- 连庄规则
	bombSplit=true ,-- 炸弹可拆
	bombBelt=true, -- 炸弹可带3
	bombBelt2=true, -- 炸弹可带2
	floatScore=false,  --飘分
	showCount=true, -- 显示牌数量
	preventJointly=true, -- 防合手
	redTen=0, --红10玩法
	singleProtect=false, -- 单张全关保护

	niao = false,
	niaoValue = 10,
	speed=1,

	isSettlementScore=false,
	fewerValue=10,
	addValue=10,

	choiceDouble = false,
	doubleScore = 10,
	multiple = 2,

	ToggleMultiple2=nil,
	ToggleMultiple3=nil,
	ToggleMultiple4=nil,

	ToggleChoiceDouble=nil,
	ToggleNoChoiceDouble=nil,
	DoubleScoreText=nil,
	AddDoubleScoreButton=nil,
	SubtractDoubleScoreButton=nil,

	ToggleRound8=nil, --8局
	ToggleRound10=nil, --10局
	ToggleRound20=nil ,--20局
	TogglePeopleNum3=nil, -- 3人
	TogglePeopleNum2=nil ,-- 2人
	ToggleMasterPay=nil ,-- 房主支付  
	ToggleWinnerPay=nil ,-- 赢家支付 

	ToggleTrusteeshipNo=nil,
	ToggleTrusteeship1=nil,
	ToggleTrusteeship2=nil,
	ToggleTrusteeship3=nil,
	ToggleTrusteeship5=nil,

	ToggleTrusteeshipAll=nil,
	ToggleTrusteeshipOne=nil,
	ToggleTrusteeshipThree=nil,
	ToggleFanPai=nil ,--幸运翻牌
	ToggleBlack3=nil ,--黑3
	Toggle3=nil, --3首出
	ToggleWinnerZhuang=nil, -- 赢家为庄
	ToggleLastZhuang=nil, --延续首轮抢庄规则
	TogglePiaoFen=nil, -- 飘分
	ToggleBaoHu=nil, --单张全关保护
	ToggleShowCard=nil, --显示牌数
	ToggleZhaDan=nil, --炸弹可拆
	Toggle4d3=nil ,-- 四带三
	Toggle4d2=nil, -- 四带三
	ToggleFanHeShou=nil, -- 防合手
	ToggleFanBei=nil ,--翻倍
	Togglefast=nil,
	Toggleslow=nil,
	
	ToggleIPcheck=nil,		--防作弊，IP检测
	ToggleGPScheck=nil,		--防作弊，GPS检测

	ToggleOnNiao=nil,
	ToggleOffNiao=nil,
	NiaoValueText=nil,
	AddButtonNiao=nil,
	SubtractButtonNiao=nil,

	ToggleOnTen=nil,
	ToggleOffTen=nil,
	TenValueText=nil,
	AddButtonTen=nil,
	SubtractButtonTen=nil,

	ToggleSettlementScoreSelect=nil,
	ToggleFewerScoreTxt=nil,
	ToggleFewerAddButton=nil,
	ToggleFewerSubtractButton=nil,
	ToggleAddScoreTxt=nil,
	ToggleAddAddButton=nil,
	ToggleAddSubtractButton=nil
}

function this.Init(grid,message)
	print('Init_PDKSWZ')
	PDKSWZ = grid
	payLabel = message.transform:Find('diamond/pay_label')

	pdkswz.ToggleRound8 = PDKSWZ:Find('table/round/round8');
	pdkswz.ToggleRound10 = PDKSWZ:Find('table/round/round10');
	pdkswz.ToggleRound20 = PDKSWZ:Find('table/round/round20');

	pdkswz.TogglePeopleNum2 = PDKSWZ:Find('table/num/num2');
	pdkswz.TogglePeopleNum3 = PDKSWZ:Find('table/num/num3');

	pdkswz.ToggleMasterPay = PDKSWZ:Find('table/pay/master');
	pdkswz.ToggleWinnerPay = PDKSWZ:Find('table/pay/win');
	
	pdkswz.ToggleFanPai = PDKSWZ:Find('table/QiangZhuang/ToggleFanPai');
	pdkswz.ToggleBlack3 = PDKSWZ:Find('table/QiangZhuang/ToggleBlack3');
	pdkswz.Toggle3 = PDKSWZ:Find('table/QiangZhuang/Toggle3');

	pdkswz.ToggleWinnerZhuang = PDKSWZ:Find('table/ToggleLunZhuang/ToggleWinnerZhuang');
	pdkswz.ToggleLastZhuang = PDKSWZ:Find('table/ToggleLunZhuang/ToggleLastZhuang');

	pdkswz.ToggleZhaDan = PDKSWZ:Find('table/ToggleZhanDan/ToggleZhaDan');
	pdkswz.Toggle4d3 = PDKSWZ:Find('table/ToggleZhanDan/Toggle4d3');
	pdkswz.Toggle4d2 = PDKSWZ:Find('table/ToggleZhanDan/Toggle4d2');

	pdkswz.TogglePiaoFen = PDKSWZ:Find('table/ToggleGeXing/TogglePiaoFen');
	pdkswz.ToggleBaoHu = PDKSWZ:Find('table/ToggleGeXing/ToggleBaoHu');
	pdkswz.ToggleShowCard = PDKSWZ:Find('table/ToggleGeXing/ToggleShowCard');
	pdkswz.ToggleFanHeShou = PDKSWZ:Find('table/ToggleGeXing/ToggleFanHeShou');
	pdkswz.ToggleFanBei = PDKSWZ:Find('table/ToggleGeXing/ToggleFanBei');

	pdkswz.ToggleOnNiao = PDKSWZ:Find('table/niao/OnNiao');
	pdkswz.ToggleOffNiao = PDKSWZ:Find('table/niao/OffNiao');
	pdkswz.NiaoValueText = PDKSWZ:Find('table/niao/NiaoValue/Value');
	pdkswz.AddButtonNiao = PDKSWZ:Find('table/niao/NiaoValue/AddButton')
	pdkswz.SubtractButtonNiao = PDKSWZ:Find('table/niao/NiaoValue/SubtractButton')

    pdkswz.ToggleOnTen         = PDKSWZ:Find('table/RedTen/OnTen');
    pdkswz.ToggleOffTen        = PDKSWZ:Find('table/RedTen/OffTen');
    pdkswz.TenValueText        = PDKSWZ:Find('table/RedTen/TenValue/Value');
    pdkswz.AddButtonTen        = PDKSWZ:Find('table/RedTen/TenValue/AddButton')
    pdkswz.SubtractButtonTen   = PDKSWZ:Find('table/RedTen/TenValue/SubtractButton')

	pdkswz.Togglefast = PDKSWZ:Find('table/ToggleSpeed/Togglefast')
	pdkswz.Toggleslow = PDKSWZ:Find('table/ToggleSpeed/Toggleslow')

	pdkswz.ToggleTrusteeshipNo = PDKSWZ:Find('table/DelegateChoose/NoDelegate')
	pdkswz.ToggleTrusteeship1 = PDKSWZ:Find('table/DelegateChoose/Delegate1')
	pdkswz.ToggleTrusteeship2 = PDKSWZ:Find('table/DelegateChoose/Delegate2')
	pdkswz.ToggleTrusteeship3 = PDKSWZ:Find('table/DelegateChoose/Delegate3')
	pdkswz.ToggleTrusteeship5 = PDKSWZ:Find('table/DelegateChoose/Delegate5')

	pdkswz.ToggleTrusteeshipAll = PDKSWZ:Find('table/DelegateCancel/FullRound')
	pdkswz.ToggleTrusteeshipOne = PDKSWZ:Find('table/DelegateCancel/ThisRound')
	pdkswz.ToggleTrusteeshipThree = PDKSWZ:Find('table/DelegateCancel/ThreeRound')

	pdkswz.ToggleSettlementScoreSelect=PDKSWZ:Find('table/settlementScore/select')
	pdkswz.ToggleFewerScoreTxt=PDKSWZ:Find('table/settlementScore/fewerValue/Value')
	pdkswz.ToggleFewerAddButton=PDKSWZ:Find('table/settlementScore/fewerValue/AddButton')
	pdkswz.ToggleFewerSubtractButton=PDKSWZ:Find('table/settlementScore/fewerValue/SubtractButton')
	pdkswz.ToggleAddScoreTxt=PDKSWZ:Find('table/settlementScore/addValue/Value')
	pdkswz.ToggleAddAddButton=PDKSWZ:Find('table/settlementScore/addValue/AddButton')
	pdkswz.ToggleAddSubtractButton=PDKSWZ:Find('table/settlementScore/addValue/SubtractButton')
	
	pdkswz.ToggleIPcheck = PDKSWZ:Find('table/PreventCheat/IPcheck')
	pdkswz.ToggleGPScheck = PDKSWZ:Find('table/PreventCheat/GPScheck')
	
	pdkswz.ToggleMultiple2 = PDKSWZ:Find('table/multiple/2')
	pdkswz.ToggleMultiple3 = PDKSWZ:Find('table/multiple/3')
	pdkswz.ToggleMultiple4 = PDKSWZ:Find('table/multiple/4')

	pdkswz.ToggleChoiceDouble          = PDKSWZ:Find('table/choiceDouble/On')
	pdkswz.ToggleNoChoiceDouble        = PDKSWZ:Find('table/choiceDouble/Off')
	pdkswz.DoubleScoreText             = PDKSWZ:Find('table/choiceDouble/doubleScore/Value')
	pdkswz.AddDoubleScoreButton        = PDKSWZ:Find('table/choiceDouble/doubleScore/AddButton')
	pdkswz.SubtractDoubleScoreButton   = PDKSWZ:Find('table/choiceDouble/doubleScore/SubtractButton')

	message:AddClick(pdkswz.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(pdkswz.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(pdkswz.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(pdkswz.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)

	message:AddClick(pdkswz.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(pdkswz.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(pdkswz.ToggleMultiple4.gameObject, this.OnClickMultiple)

	message:AddClick(pdkswz.ToggleRound8.gameObject, this.OnClickToggleRound)
	message:AddClick(pdkswz.ToggleRound10.gameObject, this.OnClickToggleRound)
	message:AddClick(pdkswz.ToggleRound20.gameObject, this.OnClickToggleRound)
	
	message:AddClick(pdkswz.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(pdkswz.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)

	message:AddClick(pdkswz.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(pdkswz.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)

	message:AddClick(pdkswz.ToggleFanPai.gameObject, this.OnClickToggleQiangZhuang)
	message:AddClick(pdkswz.ToggleBlack3.gameObject, this.OnClickToggleQiangZhuang)
	message:AddClick(pdkswz.Toggle3.gameObject, this.OnClickToggle3)

	message:AddClick(pdkswz.ToggleWinnerZhuang.gameObject, this.OnClickToggleLunZhuang)
	message:AddClick(pdkswz.ToggleLastZhuang.gameObject, this.OnClickToggleLunZhuang)

	message:AddClick(pdkswz.TogglePiaoFen.gameObject, this.OnClickTogglePiaoFen)
	message:AddClick(pdkswz.ToggleBaoHu.gameObject, this.OnClickToggleBaoHu)
	message:AddClick(pdkswz.ToggleShowCard.gameObject, this.OnClickToggleShowCard)
	message:AddClick(pdkswz.ToggleZhaDan.gameObject, this.OnClickToggleZhaDan)
	message:AddClick(pdkswz.Toggle4d3.gameObject, this.OnClickToggle4d3)
	message:AddClick(pdkswz.Toggle4d2.gameObject, this.OnClickToggle4d2)
	message:AddClick(pdkswz.ToggleFanHeShou.gameObject, this.OnClickToggleFanHeShou)
	message:AddClick(pdkswz.ToggleFanBei.gameObject, this.OnClickToggleRed10)

	message:AddClick(pdkswz.ToggleOnNiao.gameObject, this.OnClickNiao)
	message:AddClick(pdkswz.ToggleOffNiao.gameObject, this.OnClickNiao)
	message:AddClick(pdkswz.AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(pdkswz.SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)

	message:AddClick(pdkswz.ToggleOnTen.gameObject, this.OnClickTen)
	message:AddClick(pdkswz.ToggleOffTen.gameObject, this.OnClickTen)
	message:AddClick(pdkswz.AddButtonTen.gameObject, this.OnClickChangeTenValue)
	message:AddClick(pdkswz.SubtractButtonTen.gameObject, this.OnClickChangeTenValue)

	message:AddClick(pdkswz.Togglefast.gameObject, this.OnClickToggleSpeed)
	message:AddClick(pdkswz.Toggleslow.gameObject, this.OnClickToggleSpeed)

	message:AddClick(pdkswz.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pdkswz.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pdkswz.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pdkswz.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pdkswz.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pdkswz.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(pdkswz.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(pdkswz.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)

	message:AddClick(pdkswz.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(pdkswz.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(pdkswz.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(pdkswz.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(pdkswz.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)
	
	message:AddClick(pdkswz.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(pdkswz.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end
function this.Refresh()
	print('Refresh_PDKSWZ')
	pdkswz.rounds = UnityEngine.PlayerPrefs.GetInt('NewPDKSWZrounds', 10) -- 局数 10
	pdkswz.size = UnityEngine.PlayerPrefs.GetInt('NewPDKSWZsize', 3)  --人数 2
	pdkswz.paymentType = UnityEngine.PlayerPrefs.GetInt('NewPDKSWZpaymentType', 0) --支付类型 0
	pdkswz.remainBanker = UnityEngine.PlayerPrefs.GetInt('NewPDKSWZremainBanker', 1) == 1 -- 连庄规则 true
	pdkswz.trusteeshipTime = UnityEngine.PlayerPrefs.GetInt('NewPDKSWZtrusteeshipTime', 0)
	pdkswz.trusteeshipType = UnityEngine.PlayerPrefs.GetInt('NewPDKSWZtrusteeshipType', 0) == 1
	pdkswz.trusteeshipRound = UnityEngine.PlayerPrefs.GetInt("NewPDKSWZtrusteeshipRound",0)
	pdkswz.firstPlay = UnityEngine.PlayerPrefs.GetInt('NewPDKSWZfirstPlay', 2)
	pdkswz.bichu3 = UnityEngine.PlayerPrefs.GetInt('NewPDKSWZbichu3', 0)==1
	pdkswz.showCount = UnityEngine.PlayerPrefs.GetInt('NewPDKSWZshowCount', 1) == 1  -- 显示牌数量true 
	pdkswz.bombSplit = UnityEngine.PlayerPrefs.GetInt('NewPDKSWZbombSplit', 1) == 1 -- 炸弹可拆 true
	pdkswz.bombBelt = UnityEngine.PlayerPrefs.GetInt('NewPDKSWZbombBelt', 1) == 1 -- 炸弹可带3 true
	pdkswz.bombBelt2 = UnityEngine.PlayerPrefs.GetInt('NewPDKSWZbombBelt2', 1) == 1 -- 炸弹可带2 true
	pdkswz.singleProtect = UnityEngine.PlayerPrefs.GetInt('NewPDKSWZsingleProtect', 0) ~= 0  -- 单张全关保护 false
	pdkswz.preventJointly = UnityEngine.PlayerPrefs.GetInt('NewPDKSWZpreventJointly', 1) ~= 0  -- 防合手 true
	pdkswz.floatScore = UnityEngine.PlayerPrefs.GetInt('NewPDKSWZfloatScore', 0) ~= 0  --飘分 false
	pdkswz.redTen = UnityEngine.PlayerPrefs.GetInt('NewPDKSWZredTen', 0) --红10玩法 false -1
	pdkswz.speed = UnityEngine.PlayerPrefs.GetInt('NewPDKSWZspeed', 1) --pdkswz.speed 
	
	pdkswz.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewPDKSWZisSettlementScore', 0)==1
	pdkswz.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewPDKSWZfewerValue', 10)
	pdkswz.addValue=UnityEngine.PlayerPrefs.GetInt('NewPDKSWZaddValue', 10)

	pdkswz.niao =  UnityEngine.PlayerPrefs.GetInt('NewPDKSWZniao', 0) == 1
	pdkswz.niaoValue = UnityEngine.PlayerPrefs.GetInt('NewPDKSWZniaoValue', 10)
	
	pdkswz.openIp=UnityEngine.PlayerPrefs.GetInt('PDKSWZcheckIP', 0)==1
	pdkswz.openGps=UnityEngine.PlayerPrefs.GetInt('PDKSWZcheckGPS', 0)==1

	pdkswz.choiceDouble             = UnityEngine.PlayerPrefs.GetInt("NewPDKSWZchoiceDouble", 0)==1;
    pdkswz.doubleScore      		= UnityEngine.PlayerPrefs.GetInt("NewPDKSWZdoubleScore", 10)
    pdkswz.multiple      			= UnityEngine.PlayerPrefs.GetInt("NewPDKSWZmultiple", 2)

	pdkswz.ToggleChoiceDouble.parent.gameObject:SetActive(pdkswz.size==2)
    pdkswz.ToggleMultiple2.parent.gameObject:SetActive(pdkswz.size==2 and pdkswz.choiceDouble)
    
	pdkswz.ToggleMultiple2:GetComponent('UIToggle'):Set(pdkswz.multiple == 2)
	pdkswz.ToggleMultiple3:GetComponent('UIToggle'):Set(pdkswz.multiple == 3)
	pdkswz.ToggleMultiple4:GetComponent('UIToggle'):Set(pdkswz.multiple == 4)

	pdkswz.ToggleChoiceDouble:GetComponent('UIToggle'):Set(pdkswz.choiceDouble)
	pdkswz.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not pdkswz.choiceDouble)
	pdkswz.DoubleScoreText.parent.gameObject:SetActive(pdkswz.choiceDouble)
	if pdkswz.doubleScore == 0 then
		pdkswz.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		pdkswz.DoubleScoreText:GetComponent('UILabel').text = '小于'..pdkswz.doubleScore..'分'
	end

	pdkswz.ToggleRound8:GetComponent('UIToggle'):Set(pdkswz.rounds == 8)
	pdkswz.ToggleRound10:GetComponent('UIToggle'):Set(pdkswz.rounds == 10)
	pdkswz.ToggleRound20:GetComponent('UIToggle'):Set(pdkswz.rounds == 20)

	pdkswz.TogglePeopleNum2:GetComponent('UIToggle'):Set(pdkswz.size == 2)
    pdkswz.TogglePeopleNum3:GetComponent('UIToggle'):Set(pdkswz.size == 3)
	
	pdkswz.ToggleMasterPay:GetComponent('UIToggle'):Set(pdkswz.paymentType == 0)
	pdkswz.ToggleWinnerPay:GetComponent('UIToggle'):Set(pdkswz.paymentType == 2)

	pdkswz.ToggleWinnerZhuang:GetComponent('UIToggle'):Set(pdkswz.remainBanker)
	pdkswz.ToggleLastZhuang:GetComponent('UIToggle'):Set(not pdkswz.remainBanker)

	pdkswz.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(pdkswz.trusteeshipTime == 0)
	pdkswz.ToggleTrusteeship1:GetComponent('UIToggle'):Set(pdkswz.trusteeshipTime == 1)
	pdkswz.ToggleTrusteeship2:GetComponent('UIToggle'):Set(pdkswz.trusteeshipTime == 2)
	pdkswz.ToggleTrusteeship3:GetComponent('UIToggle'):Set(pdkswz.trusteeshipTime == 3)
	pdkswz.ToggleTrusteeship5:GetComponent('UIToggle'):Set(pdkswz.trusteeshipTime == 5)

	pdkswz.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(pdkswz.trusteeshipType and pdkswz.trusteeshipRound ==0)
	pdkswz.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not pdkswz.trusteeshipType and pdkswz.trusteeshipRound == 0)
	pdkswz.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(pdkswz.trusteeshipRound == 3)
	pdkswz.ToggleTrusteeshipOne.parent.gameObject:SetActive( pdkswz.trusteeshipTime ~= 0)

	pdkswz.ToggleZhaDan:GetComponent('UIToggle'):Set(pdkswz.bombSplit)
	pdkswz.Toggle4d3:GetComponent('UIToggle'):Set(pdkswz.bombBelt and pdkswz.bombSplit)
	pdkswz.Toggle4d2:GetComponent('UIToggle'):Set(pdkswz.bombBelt2 and pdkswz.bombSplit)
	pdkswz.ToggleBaoHu:GetComponent('UIToggle'):Set(pdkswz.singleProtect)
	pdkswz.ToggleFanHeShou:GetComponent('UIToggle'):Set(pdkswz.preventJointly)
	pdkswz.TogglePiaoFen:GetComponent('UIToggle'):Set(pdkswz.floatScore)
	pdkswz.ToggleFanBei:GetComponent('UIToggle'):Set(-1 == pdkswz.redTen)
	pdkswz.ToggleShowCard:GetComponent('UIToggle'):Set(pdkswz.showCount)

	pdkswz.ToggleIPcheck.parent.gameObject:SetActive(pdkswz.size > 2 and CONST.IPcheckOn)
	pdkswz.ToggleSettlementScoreSelect.parent.gameObject:SetActive(pdkswz.size==2)
	pdkswz.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(pdkswz.isSettlementScore)
	pdkswz.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	pdkswz.ToggleFewerScoreTxt:GetComponent('UILabel').text = pdkswz.fewerValue
	pdkswz.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	pdkswz.ToggleAddScoreTxt:GetComponent('UILabel').text = pdkswz.addValue

	pdkswz.ToggleOnNiao:GetComponent('UIToggle'):Set(pdkswz.niao)
	pdkswz.ToggleOffNiao:GetComponent('UIToggle'):Set(not pdkswz.niao)
	pdkswz.NiaoValueText.parent.gameObject:SetActive(pdkswz.niao)
	pdkswz.NiaoValueText:GetComponent('UILabel').text = pdkswz.niaoValue.."分"

	pdkswz.ToggleOnTen:GetComponent("UIToggle"):Set(pdkswz.redTen >0);
	pdkswz.ToggleOffTen:GetComponent("UIToggle"):Set(pdkswz.redTen == 0 or pdkswz.redTen == -1);
	pdkswz.TenValueText.parent.gameObject:SetActive(pdkswz.redTen > 0);
	pdkswz.TenValueText:GetComponent("UILabel").text = pdkswz.redTen.."分";

	if pdkswz.niao then
		pdkswz.floatScore = false
		UnityEngine.PlayerPrefs.SetInt('NewPDKSWZfloatScore', pdkswz.floatScore and 1 or 0)
		pdkswz.TogglePiaoFen:GetComponent('UIToggle'):Set(pdkswz.floatScore)
	end
	if pdkswz.floatScore == 1 then
		pdkswz.niao = false
		UnityEngine.PlayerPrefs.SetInt('NewPDKSWZniao', pdkswz.niao and 1 or 0)
		pdkswz.NiaoValueText.parent.gameObject:SetActive(pdkswz.niao)
		pdkswz.ToggleOffNiao:GetComponent('UIToggle'):Set(true)
		pdkswz.ToggleOnNiao:GetComponent('UIToggle'):Set(false)
	end
	pdkswz.Togglefast:GetComponent('UIToggle'):Set(0 == pdkswz.speed)
	pdkswz.Toggleslow:GetComponent('UIToggle'):Set(1 == pdkswz.speed)

	pdkswz.ToggleFanHeShou.gameObject:SetActive(pdkswz.size == 3)
	pdkswz.ToggleBaoHu.gameObject:SetActive(pdkswz.size == 3)

	if pdkswz.size == 2 then
		pdkswz.firstPlay = 2
	elseif pdkswz.size == 3 then
		pdkswz.firstPlay = 1
	end
	pdkswz.Toggle3:GetComponent('UIToggle'):Set(pdkswz.bichu3)
	pdkswz.Toggle3.gameObject:SetActive(pdkswz.firstPlay == 2)
	UnityEngine.PlayerPrefs.SetInt('NewPDKSWZfirstPlay', pdkswz.firstPlay)
	pdkswz.ToggleFanPai:GetComponent('UIToggle'):Set(pdkswz.firstPlay == 1)
	pdkswz.ToggleBlack3:GetComponent('UIToggle'):Set(pdkswz.firstPlay == 2)
	
	pdkswz.ToggleIPcheck:GetComponent('UIToggle'):Set(pdkswz.openIp)
	pdkswz.ToggleGPScheck:GetComponent('UIToggle'):Set(pdkswz.openGps)

	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.PDKSWZ,pdkswz.rounds,nil,nil)
end
--获取当前设置
function this.GetConfig()
	local moneyLess = false
    if ((pdkswz.rounds == 10 or pdkswz.rounds == 8) and info_login.balance < 2) or
        (pdkswz.rounds == 20 and info_login.balance < 4 ) then
        moneyLess = true
    end
    
    local body = {}
    body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.PDKSWZ)
	body.rounds = pdkswz.rounds
	body.size = pdkswz.size
	body.paymentType = pdkswz.paymentType
	body.remainBanker = pdkswz.remainBanker
	body.trusteeship = pdkswz.trusteeshipTime*60;
	body.trusteeshipDissolve = pdkswz.trusteeshipRound == 0 and pdkswz.trusteeshipType or false;
	body.trusteeshipRound = pdkswz.trusteeshipRound;
	body.cardCount = 15
	body.showCount = pdkswz.showCount
	if pdkswz.firstPlay == 1 then
		body.firstPlay  = "RANDOM"
	elseif pdkswz.firstPlay == 2 then
		if pdkswz.bichu3 then
			body.firstPlay  = "S3_IN"
		else
			body.firstPlay  = "S3"
		end
	end

	if pdkswz.size == 2 then
		body.resultScore = pdkswz.isSettlementScore
		if pdkswz.isSettlementScore then
			body.resultLowerScore=pdkswz.fewerValue
			body.resultAddScore=pdkswz.addValue
		end
		pdkswz.openIp=false
		pdkswz.openGps=false
		body.choiceDouble = pdkswz.choiceDouble
		body.doubleScore = pdkswz.doubleScore
		body.multiple = pdkswz.multiple
	end

	body.bombSplit = pdkswz.bombSplit
	body.bombBelt = pdkswz.bombBelt
	body.bombBeltTwo = pdkswz.bombBelt2

	body.singleProtect = pdkswz.singleProtect
	body.preventJointly = pdkswz.preventJointly
	body.floatScore = pdkswz.floatScore
	body.hitBird = pdkswz.niao and pdkswz.niaoValue or 0;
	body.redTen = pdkswz.redTen
	body.speed = pdkswz.speed
	body.openIp	 = pdkswz.openIp
	body.openGps = pdkswz.openGps
	
    return moneyLess,body;
end

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
    if pdkswz.ToggleRound8.gameObject == go then
        pdkswz.rounds = 8
	elseif pdkswz.ToggleRound10.gameObject == go then
        pdkswz.rounds = 10
    elseif pdkswz.ToggleRound20.gameObject == go then
        pdkswz.rounds = 20
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.PDKSWZ,pdkswz.rounds,nil,nil)
    UnityEngine.PlayerPrefs.SetInt('NewPDKSWZrounds', pdkswz.rounds)
end

function this.OnClickTogglePlayerNum(go)
    AudioManager.Instance:PlayAudio('btn')
	if pdkswz.TogglePeopleNum2.gameObject == go then
        pdkswz.size = 2
        pdkswz.firstPlay = 2
    elseif pdkswz.TogglePeopleNum3.gameObject == go then
        pdkswz.size = 3
        pdkswz.firstPlay = 1
	end
	pdkswz.ToggleIPcheck.parent.gameObject:SetActive(pdkswz.size > 2 and CONST.IPcheckOn)
	pdkswz.ToggleFanHeShou.gameObject:SetActive(pdkswz.size == 3)
	pdkswz.ToggleBaoHu.gameObject:SetActive(pdkswz.size == 3)
    pdkswz.Toggle3:GetComponent('UIToggle'):Set(pdkswz.bichu3)
    pdkswz.Toggle3.gameObject:SetActive(pdkswz.firstPlay == 2)
    UnityEngine.PlayerPrefs.SetInt('NewPDKSWZfirstPlay', pdkswz.firstPlay)
    pdkswz.ToggleFanPai:GetComponent('UIToggle'):Set(pdkswz.firstPlay == 1)
    pdkswz.ToggleBlack3:GetComponent('UIToggle'):Set(pdkswz.firstPlay == 2)
    UnityEngine.PlayerPrefs.SetInt('NewPDKSWZsize', pdkswz.size)
	pdkswz.ToggleSettlementScoreSelect.parent.gameObject:SetActive(pdkswz.size==2)
	pdkswz.ToggleChoiceDouble.parent.gameObject:SetActive(pdkswz.size == 2)
	pdkswz.ToggleMultiple2.parent.gameObject:SetActive(pdkswz.size == 2 and pdkswz.choiceDouble)
	PDKSWZ:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if pdkswz.ToggleMasterPay.gameObject == go then
        pdkswz.paymentType=0
    elseif pdkswz.ToggleWinnerPay.gameObject == go then
        pdkswz.paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewPDKSWZpaymentType', pdkswz.paymentType)
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if pdkswz.ToggleTrusteeshipNo.gameObject == go then
        pdkswz.trusteeshipTime = 0
    elseif pdkswz.ToggleTrusteeship1.gameObject == go then
        pdkswz.trusteeshipTime = 1
	elseif pdkswz.ToggleTrusteeship2.gameObject == go then
		pdkswz.trusteeshipTime = 2
    elseif pdkswz.ToggleTrusteeship3.gameObject == go then
        pdkswz.trusteeshipTime = 3
    elseif pdkswz.ToggleTrusteeship5.gameObject == go then
        pdkswz.trusteeshipTime = 5
    end
    UnityEngine.PlayerPrefs.SetInt('NewPDKSWZtrusteeshipTime', pdkswz.trusteeshipTime)
	pdkswz.ToggleTrusteeshipOne.parent.gameObject:SetActive(pdkswz.trusteeshipTime ~= 0)
	PDKSWZ:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if pdkswz.ToggleTrusteeshipOne.gameObject == go then
        pdkswz.trusteeshipType = true
		pdkswz.trusteeshipRound = 0;
    elseif pdkswz.ToggleTrusteeshipAll.gameObject == go then
        pdkswz.trusteeshipType = false
		pdkswz.trusteeshipRound = 0;
	elseif pdkswz.ToggleTrusteeshipThree.gameObject then
		pdkswz.trusteeshipRound = 3;
		pdkswz.trusteeshipType = false;
	end
    UnityEngine.PlayerPrefs.SetInt('NewPDKSWZtrusteeshipType',pdkswz.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewPDKSWZtrusteeshipRound',pdkswz.trusteeshipRound)
end

function this.OnClickNiao(go)
	AudioManager.Instance:PlayAudio('btn')
    if pdkswz.ToggleOnNiao.gameObject == go then
        pdkswz.niao = true
        pdkswz.floatScore = false
        UnityEngine.PlayerPrefs.SetInt('NewPDKSWZfloatScore', pdkswz.floatScore and 1 or 0)
        pdkswz.TogglePiaoFen:GetComponent('UIToggle'):Set(pdkswz.floatScore)
    elseif pdkswz.ToggleOffNiao.gameObject == go then
        pdkswz.niao = false
    end
    pdkswz.NiaoValueText.parent.gameObject:SetActive(pdkswz.niao)
    UnityEngine.PlayerPrefs.SetInt('NewPDKSWZniao', pdkswz.niao and 1 or 0)
end

function this.OnClickTen(go)
	AudioManager.Instance:PlayAudio('btn')
	if pdkswz.ToggleOnTen.gameObject == go then
		pdkswz.redTen = UnityEngine.PlayerPrefs.GetInt("NewPDKSWZredTen",5);
		if pdkswz.redTen <= 0 then
			pdkswz.redTen = 5;
		end
		pdkswz.ToggleFanBei:GetComponent("UIToggle"):Set(false);
		pdkswz.TenValueText:GetComponent("UILabel").text = pdkswz.redTen.."分";

		pdkswz.TenValueText.parent.gameObject:SetActive(true);
	elseif pdkswz.ToggleOffTen.gameObject == go then

		pdkswz.TenValueText.parent.gameObject:SetActive(false);
		if pdkswz.ToggleFanBei:GetComponent("UIToggle").value == false then
			pdkswz.redTen = 0;
		else
			pdkswz.redTen = -1;
		end
	end
	UnityEngine.PlayerPrefs.SetInt('NewPDKSWZredTen', pdkswz.redTen);

end

function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
    if pdkswz.AddButtonNiao.gameObject == go then
        pdkswz.niaoValue = pdkswz.niaoValue + 10
        if pdkswz.niaoValue > 100 then
            pdkswz.niaoValue = 100
        end
    elseif pdkswz.SubtractButtonNiao.gameObject == go then
        pdkswz.niaoValue = pdkswz.niaoValue - 10
        if pdkswz.niaoValue < 10 then
            pdkswz.niaoValue = 10
        end
    end
    pdkswz.NiaoValueText:GetComponent('UILabel').text = pdkswz.niaoValue.."分"
    UnityEngine.PlayerPrefs.SetInt('NewPDKSWZniaoValue', pdkswz.niaoValue)
end


function this.OnClickChangeTenValue(go)
	AudioManager.Instance:PlayAudio('btn');
	if pdkswz.AddButtonTen.gameObject == go then
		pdkswz.redTen = pdkswz.redTen + 5;
		if pdkswz.redTen > 50 then
			pdkswz.redTen = 50;
		end
	elseif pdkswz.SubtractButtonTen.gameObject == go then
		pdkswz.redTen = pdkswz.redTen - 5;
		if pdkswz.redTen < 5 then
			pdkswz.redTen = 5;
		end
	end

	pdkswz.TenValueText:GetComponent("UILabel").text = pdkswz.redTen.."分";

	UnityEngine.PlayerPrefs.SetInt('NewPDKSWZredTen', pdkswz.redTen);
end

function this.OnClickToggleQiangZhuang(go)
	AudioManager.Instance:PlayAudio('btn')
    if pdkswz.ToggleFanPai.gameObject == go then
        pdkswz.firstPlay = 1
    else
        pdkswz.firstPlay = 2
    end
    pdkswz.Toggle3.gameObject:SetActive(pdkswz.firstPlay == 2)
    UnityEngine.PlayerPrefs.SetInt('NewPDKSWZfirstPlay', pdkswz.firstPlay)
end

function  this.OnClickToggle3(go)
	AudioManager.Instance:PlayAudio('btn')
    if go:GetComponent('UIToggle').value == true then
        pdkswz.bichu3 = true
        UnityEngine.PlayerPrefs.SetInt('NewPDKSWZbichu3', pdkswz.bichu3 and 1 or 0)
    else
        pdkswz.bichu3 = false
        UnityEngine.PlayerPrefs.SetInt('NewPDKSWZbichu3', pdkswz.bichu3 and 1 or 0)
    end
end

function this.OnClickToggleLunZhuang(go)  --轮庄方式
	AudioManager.Instance:PlayAudio('btn')
    if pdkswz.ToggleWinnerZhuang.gameObject == go then
        pdkswz.remainBanker = true
    else
        pdkswz.remainBanker = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewPDKSWZremainBanker', pdkswz.remainBanker and 1 or 0)
end

function this.OnClickTogglePiaoFen(go)  --飘分
	AudioManager.Instance:PlayAudio('btn')
	print('OnClickTogglePiaoFen')
    if go:GetComponent('UIToggle').value == true then
        pdkswz.floatScore = true
        pdkswz.niao = false
        UnityEngine.PlayerPrefs.SetInt('NewPDKSWZniao', pdkswz.niao and 1 or 0)
        pdkswz.NiaoValueText.parent.gameObject:SetActive(pdkswz.niao)
        pdkswz.ToggleOffNiao:GetComponent('UIToggle'):Set(true)
        pdkswz.ToggleOnNiao:GetComponent('UIToggle'):Set(false)
    else
        pdkswz.floatScore = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewPDKSWZfloatScore', pdkswz.floatScore and 1 or 0)
end

function this.OnClickToggleBaoHu(go)  --单张全关保护
	AudioManager.Instance:PlayAudio('btn')
    if go:GetComponent('UIToggle').value == true then
        pdkswz.singleProtect = true
    else
        pdkswz.singleProtect = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewPDKSWZsingleProtect', pdkswz.singleProtect and 1 or 0)

end

function this.OnClickToggleShowCard(go)  --显示剩余牌数量
	AudioManager.Instance:PlayAudio('btn')
    if go:GetComponent('UIToggle').value == true then
        pdkswz.showCount = true
    else
        pdkswz.showCount = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewPDKSWZshowCount', pdkswz.showCount and 1 or 0)
end

function this.OnClickToggleZhaDan(go)  --炸弹可拆
	AudioManager.Instance:PlayAudio('btn')
    if go:GetComponent('UIToggle').value == true then
        pdkswz.bombSplit = true
    else
        pdkswz.bombSplit = false
        pdkswz.bombBelt = false
        pdkswz.bombBelt2 = false
        pdkswz.Toggle4d3:GetComponent('UIToggle').value = pdkswz.bombBelt
        pdkswz.Toggle4d2:GetComponent('UIToggle').value = pdkswz.bombBelt2
        UnityEngine.PlayerPrefs.SetInt('NewPDKSWZbombBelt', pdkswz.bombBelt and 1 or 0)
        UnityEngine.PlayerPrefs.SetInt('NewPDKSWZbombBelt2', pdkswz.bombBelt2 and 1 or 0)
    end
    UnityEngine.PlayerPrefs.SetInt('NewPDKSWZbombSplit', pdkswz.bombSplit and 1 or 0)
end

function this.OnClickToggle4d3(go)  --炸弹4带3
	AudioManager.Instance:PlayAudio('btn')
    if go:GetComponent('UIToggle').value == true then
        pdkswz.bombBelt = true
        pdkswz.bombSplit = true
        pdkswz.ToggleZhaDan:GetComponent('UIToggle').value = pdkswz.bombSplit
        UnityEngine.PlayerPrefs.SetInt('NewPDKSWZbombSplit', pdkswz.bombSplit and 1 or 0)
    else
        pdkswz.bombBelt = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewPDKSWZbombBelt', pdkswz.bombBelt and 1 or 0)
end

function this.OnClickToggle4d2(go)  --炸弹4带2
	AudioManager.Instance:PlayAudio('btn')
    if go:GetComponent('UIToggle').value == true then
        pdkswz.bombBelt2 = true
        pdkswz.bombSplit = true
        pdkswz.ToggleZhaDan:GetComponent('UIToggle').value = pdkswz.bombSplit
        UnityEngine.PlayerPrefs.SetInt('NewPDKSWZbombSplit', pdkswz.bombSplit and 1 or 0)
    else
        pdkswz.bombBelt2 = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewPDKSWZbombBelt2', pdkswz.bombBelt2 and 1 or 0)
end

function this.OnClickToggleFanHeShou(go)  --防合手
	AudioManager.Instance:PlayAudio('btn')
    if go:GetComponent('UIToggle').value == true then
        pdkswz.preventJointly = true
    else
        pdkswz.preventJointly = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewPDKSWZpreventJointly', pdkswz.preventJointly and 1 or 0)
end

function this.OnClickToggleRed10(go)  --红十玩法
	AudioManager.Instance:PlayAudio('btn')
    if go:GetComponent('UIToggle').value == true then
        pdkswz.redTen = -1
		pdkswz.ToggleOffTen:GetComponent("UIToggle"):Set(true);
		pdkswz.ToggleOnTen:GetComponent("UIToggle"):Set(false);
		pdkswz.TenValueText.parent.gameObject:SetActive(false);
    else
        pdkswz.redTen = 0
    end
    UnityEngine.PlayerPrefs.SetInt('NewPDKSWZredTen', pdkswz.redTen)
end

function this.OnClickToggleSpeed(go)
	AudioManager.Instance:PlayAudio('btn')
    if pdkswz.Togglefast.gameObject == go then
        pdkswz.speed = 1
    elseif pdkswz.Toggleslow.gameObject == go then
        pdkswz.speed = 0
    end
    UnityEngine.PlayerPrefs.SetInt('NewPDKSWZspeed', pdkswz.speed)
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    pdkswz.isSettlementScore= pdkswz.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewPDKSWZisSettlementScore', pdkswz.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if pdkswz.ToggleFewerAddButton.gameObject == go then
		pdkswz.fewerValue = pdkswz.fewerValue + 1
		if pdkswz.fewerValue > 100 then
			pdkswz.fewerValue = 100
		end
    elseif pdkswz.ToggleFewerSubtractButton.gameObject == go then
		pdkswz.fewerValue = pdkswz.fewerValue - 1
		if pdkswz.fewerValue < 1 then
			pdkswz.fewerValue = 1
		end
	end
	pdkswz.ToggleFewerScoreTxt:GetComponent('UILabel').text = pdkswz.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewPDKSWZfewerValue', pdkswz.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if pdkswz.ToggleAddAddButton.gameObject == go then
		pdkswz.addValue = pdkswz.addValue + 1
		if pdkswz.addValue > 100 then
			pdkswz.addValue = 100
		end
    elseif pdkswz.ToggleAddSubtractButton.gameObject == go then
		pdkswz.addValue = pdkswz.addValue - 1
		if pdkswz.addValue < 1 then
			pdkswz.addValue = 1
		end
	end
	pdkswz.ToggleAddScoreTxt:GetComponent('UILabel').text = pdkswz.addValue
	UnityEngine.PlayerPrefs.SetInt('NewPDKSWZaddValue', pdkswz.addValue)
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if pdkswz.ToggleIPcheck.gameObject == go then
		pdkswz.openIp = pdkswz.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('PDKSWZcheckIP', pdkswz.openIp and 1 or 0)
	elseif pdkswz.ToggleGPScheck.gameObject == go then
		pdkswz.openGps = pdkswz.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('PDKSWZcheckGPS', pdkswz.openGps and 1 or 0)
	end
end

function this.OnClickChoiceDouble(go)
    AudioManager.Instance:PlayAudio('btn')
	if pdkswz.ToggleChoiceDouble.gameObject == go then
		pdkswz.choiceDouble = true
	else
		pdkswz.choiceDouble = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewPDKSWZchoiceDouble', pdkswz.choiceDouble and 1 or 0)
	pdkswz.DoubleScoreText.parent.gameObject:SetActive(pdkswz.choiceDouble)
    pdkswz.ToggleMultiple2.parent.gameObject:SetActive(pdkswz.choiceDouble)
    PDKSWZ:Find('table'):GetComponent('UIGrid'):Reposition()
	if pdkswz.choiceDouble then
		pdkswz.ToggleMultiple2:GetComponent('UIToggle'):Set(pdkswz.multiple == 2)
		pdkswz.ToggleMultiple3:GetComponent('UIToggle'):Set(pdkswz.multiple == 3)
		pdkswz.ToggleMultiple4:GetComponent('UIToggle'):Set(pdkswz.multiple == 4)
	end
end

function this.OnClickChangeDoubleScore(go)
    AudioManager.Instance:PlayAudio('btn')
    local label_= pdkswz.DoubleScoreText:GetComponent('UILabel').text
    if label_=='不限分' then
        pdkswz.doubleScore=0
    else
        pdkswz.doubleScore=tonumber(string.sub(label_,7,-4))    
    end
	if pdkswz.AddDoubleScoreButton.gameObject == go then
		if pdkswz.doubleScore ~= 0 then
			pdkswz.doubleScore = pdkswz.doubleScore + 1
			if pdkswz.doubleScore > 100 then
				pdkswz.doubleScore = 0
			end
		end
	else
		if pdkswz.doubleScore == 0 then
			pdkswz.doubleScore = 100
		else
			pdkswz.doubleScore = pdkswz.doubleScore - 1
			if pdkswz.doubleScore < 1 then
				pdkswz.doubleScore = 1
			end
		end
	end

	if pdkswz.doubleScore == 0 then
		pdkswz.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		pdkswz.DoubleScoreText:GetComponent('UILabel').text = '小于'..pdkswz.doubleScore..'分'
	end
	UnityEngine.PlayerPrefs.SetInt('NewPDKSWZdoubleScore', pdkswz.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
	pdkswz.multiple = tonumber(go.name)
	print('倍数：'..pdkswz.multiple)
	UnityEngine.PlayerPrefs.SetInt('NewPDKSWZmultiple', pdkswz.multiple)
end

return this