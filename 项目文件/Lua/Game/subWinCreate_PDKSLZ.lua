local this = {}

local PDKSLZ
local payLabel

local pdkslz = {
	paymentType=0, --支付类型
	size=2,  --人数
	rounds=10, -- 局数
	showCount=true, -- 显示牌数量
	firstPlay=1, -- 谁先出
	bichu3=false,
	remainBanker=true ,-- 连庄规则
	bombSplit=true, -- 炸弹可拆
	bombBelt=true, -- 炸弹可带3
	bombBelt2=true ,-- 炸弹可带2
	bomb3a=false ,-- 3a当炸弹
	singleProtect=false, -- 单张全关保护
	preventJointly=true, -- 防合手
	floatScore=false , --飘分
	redTen=0 ,--红10玩法

	speed=1,
	trusteeshipTime=0,
	trusteeshipType=true,
	trusteeshipRound=0,

	isSettlementScore=false,
	fewerValue=10,
	addValue=10,

	niao = false,
	niaoValue = 10,

	choiceDouble = false,
	doubleScore = 10,
	multiple = 2,

	ToggleRound8=nil, --8局
	ToggleRound10=nil, --10局
	ToggleRound20=nil, --20局
	TogglePeopleNum3=nil, -- 3人
	TogglePeopleNum2=nil, -- 2人
	ToggleMasterPay=nil, -- 房主支付  
	ToggleWinnerPay=nil, -- 赢家支付 
	ToggleFanPai=nil, --幸运翻牌
	ToggleBlack3=nil, --黑3
	Toggle3=nil, --3首出
	ToggleWinnerZhuang=nil, -- 赢家为庄
	ToggleLastZhuang=nil, --延续首轮抢庄规则
	TogglePiaoFen=nil, -- 飘分
	ToggleBaoHu=nil, --单张全关保护
	ToggleShowCard=nil, --显示牌数
	ToggleZhaDan=nil, --炸弹可拆
	Toggle4d3=nil, -- 四带三
	Toggle4d2=nil, -- 四带三
	Toggle3a=nil, -- 3a当炸弹
	ToggleFanHeShou=nil ,-- 防合手
	ToggleFanBei=nil, --翻倍
	Togglefast=nil,
	Toggleslow=nil,

	ToggleMultiple2=nil,
	ToggleMultiple3=nil,
	ToggleMultiple4=nil,

	ToggleChoiceDouble=nil,
	ToggleNoChoiceDouble=nil,
	DoubleScoreText=nil,
	AddDoubleScoreButton=nil,
	SubtractDoubleScoreButton=nil,

	ToggleTrusteeshipNo=nil,
	ToggleTrusteeship1=nil,
	ToggleTrusteeship2=nil,
	ToggleTrusteeship3=nil,
	ToggleTrusteeship5=nil,

	ToggleTrusteeshipAll=nil,
	ToggleTrusteeshipOne=nil,
	ToggleTrusteeshipThree=nil,
	
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
	print('Init_PDKSLZ')
	PDKSLZ = grid
	payLabel = message.transform:Find('diamond/pay_label')

	pdkslz.ToggleRound8 = PDKSLZ:Find('table/round/round8');
	pdkslz.ToggleRound10 = PDKSLZ:Find('table/round/round10');
	pdkslz.ToggleRound20 = PDKSLZ:Find('table/round/round20');

	pdkslz.TogglePeopleNum2 = PDKSLZ:Find('table/num/num2');
	pdkslz.TogglePeopleNum3 = PDKSLZ:Find('table/num/num3');

	pdkslz.ToggleMasterPay = PDKSLZ:Find('table/pay/master');
	pdkslz.ToggleWinnerPay = PDKSLZ:Find('table/pay/win');
	
	pdkslz.ToggleFanPai = PDKSLZ:Find('table/QiangZhuang/ToggleFanPai');
	pdkslz.ToggleBlack3 = PDKSLZ:Find('table/QiangZhuang/ToggleBlack3');
	pdkslz.Toggle3 = PDKSLZ:Find('table/QiangZhuang/Toggle3');

	pdkslz.ToggleWinnerZhuang = PDKSLZ:Find('table/ToggleLunZhuang/ToggleWinnerZhuang');
	pdkslz.ToggleLastZhuang = PDKSLZ:Find('table/ToggleLunZhuang/ToggleLastZhuang');

	pdkslz.ToggleZhaDan = PDKSLZ:Find('table/ToggleZhanDan/ToggleZhaDan');
	pdkslz.Toggle4d3 = PDKSLZ:Find('table/ToggleZhanDan/Toggle4d3');
	pdkslz.Toggle4d2 = PDKSLZ:Find('table/ToggleZhanDan/Toggle4d2');

	pdkslz.TogglePiaoFen = PDKSLZ:Find('table/ToggleGeXing/TogglePiaoFen');
	pdkslz.ToggleBaoHu = PDKSLZ:Find('table/ToggleGeXing/ToggleBaoHu');
	pdkslz.ToggleShowCard = PDKSLZ:Find('table/ToggleGeXing/ToggleShowCard');
	pdkslz.ToggleFanHeShou = PDKSLZ:Find('table/ToggleGeXing/ToggleFanHeShou');
	pdkslz.ToggleFanBei = PDKSLZ:Find('table/ToggleGeXing/ToggleFanBei');
	pdkslz.Toggle3a = PDKSLZ:Find('table/ToggleGeXing/Toggle3a');

	pdkslz.ToggleOnNiao = PDKSLZ:Find('table/niao/OnNiao');
	pdkslz.ToggleOffNiao = PDKSLZ:Find('table/niao/OffNiao');
	pdkslz.NiaoValueText = PDKSLZ:Find('table/niao/NiaoValue/Value');
	pdkslz.AddButtonNiao = PDKSLZ:Find('table/niao/NiaoValue/AddButton')
	pdkslz.SubtractButtonNiao = PDKSLZ:Find('table/niao/NiaoValue/SubtractButton')

	pdkslz.ToggleOnTen         = PDKSLZ:Find('table/RedTen/OnTen');
	pdkslz.ToggleOffTen        = PDKSLZ:Find('table/RedTen/OffTen');
	pdkslz.TenValueText        = PDKSLZ:Find('table/RedTen/TenValue/Value');
	pdkslz.AddButtonTen        = PDKSLZ:Find('table/RedTen/TenValue/AddButton')
	pdkslz.SubtractButtonTen   = PDKSLZ:Find('table/RedTen/TenValue/SubtractButton')

	pdkslz.Togglefast = PDKSLZ:Find('table/ToggleSpeed/Togglefast')
	pdkslz.Toggleslow = PDKSLZ:Find('table/ToggleSpeed/Toggleslow')

	pdkslz.ToggleTrusteeshipNo = PDKSLZ:Find('table/DelegateChoose/NoDelegate')
	pdkslz.ToggleTrusteeship1 = PDKSLZ:Find('table/DelegateChoose/Delegate1')
	pdkslz.ToggleTrusteeship2 = PDKSLZ:Find('table/DelegateChoose/Delegate2')
	pdkslz.ToggleTrusteeship3 = PDKSLZ:Find('table/DelegateChoose/Delegate3')
	pdkslz.ToggleTrusteeship5 = PDKSLZ:Find('table/DelegateChoose/Delegate5')

	pdkslz.ToggleTrusteeshipAll = PDKSLZ:Find('table/DelegateCancel/FullRound')
	pdkslz.ToggleTrusteeshipOne = PDKSLZ:Find('table/DelegateCancel/ThisRound')
	pdkslz.ToggleTrusteeshipThree = PDKSLZ:Find('table/DelegateCancel/ThreeRound')

	pdkslz.ToggleSettlementScoreSelect=PDKSLZ:Find('table/settlementScore/select')
	pdkslz.ToggleFewerScoreTxt=PDKSLZ:Find('table/settlementScore/fewerValue/Value')
	pdkslz.ToggleFewerAddButton=PDKSLZ:Find('table/settlementScore/fewerValue/AddButton')
	pdkslz.ToggleFewerSubtractButton=PDKSLZ:Find('table/settlementScore/fewerValue/SubtractButton')
	pdkslz.ToggleAddScoreTxt=PDKSLZ:Find('table/settlementScore/addValue/Value')
	pdkslz.ToggleAddAddButton=PDKSLZ:Find('table/settlementScore/addValue/AddButton')
	pdkslz.ToggleAddSubtractButton=PDKSLZ:Find('table/settlementScore/addValue/SubtractButton')
	
	pdkslz.ToggleIPcheck = PDKSLZ:Find('table/PreventCheat/IPcheck')
	pdkslz.ToggleGPScheck = PDKSLZ:Find('table/PreventCheat/GPScheck')
	
    pdkslz.ToggleMultiple2 = PDKSLZ:Find('table/multiple/2')
	pdkslz.ToggleMultiple3 = PDKSLZ:Find('table/multiple/3')
	pdkslz.ToggleMultiple4 = PDKSLZ:Find('table/multiple/4')

	pdkslz.ToggleChoiceDouble          = PDKSLZ:Find('table/choiceDouble/On')
	pdkslz.ToggleNoChoiceDouble        = PDKSLZ:Find('table/choiceDouble/Off')
	pdkslz.DoubleScoreText             = PDKSLZ:Find('table/choiceDouble/doubleScore/Value')
	pdkslz.AddDoubleScoreButton        = PDKSLZ:Find('table/choiceDouble/doubleScore/AddButton')
	pdkslz.SubtractDoubleScoreButton   = PDKSLZ:Find('table/choiceDouble/doubleScore/SubtractButton')

	message:AddClick(pdkslz.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(pdkslz.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(pdkslz.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(pdkslz.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)

	message:AddClick(pdkslz.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(pdkslz.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(pdkslz.ToggleMultiple4.gameObject, this.OnClickMultiple)

	message:AddClick(pdkslz.ToggleRound8.gameObject, this.OnClickToggleRound)
	message:AddClick(pdkslz.ToggleRound10.gameObject, this.OnClickToggleRound)
	message:AddClick(pdkslz.ToggleRound20.gameObject, this.OnClickToggleRound)
	
	message:AddClick(pdkslz.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(pdkslz.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)

	message:AddClick(pdkslz.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(pdkslz.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)

	message:AddClick(pdkslz.ToggleFanPai.gameObject, this.OnClickToggleQiangZhuang)
	message:AddClick(pdkslz.ToggleBlack3.gameObject, this.OnClickToggleQiangZhuang)
	message:AddClick(pdkslz.Toggle3.gameObject, this.OnClickToggle3)

	message:AddClick(pdkslz.ToggleWinnerZhuang.gameObject, this.OnClickToggleLunZhuang)
	message:AddClick(pdkslz.ToggleLastZhuang.gameObject, this.OnClickToggleLunZhuang)

	message:AddClick(pdkslz.TogglePiaoFen.gameObject, this.OnClickTogglePiaoFen)
	message:AddClick(pdkslz.ToggleBaoHu.gameObject, this.OnClickToggleBaoHu)
	message:AddClick(pdkslz.ToggleShowCard.gameObject, this.OnClickToggleShowCard)
	message:AddClick(pdkslz.ToggleZhaDan.gameObject, this.OnClickToggleZhaDan)
	message:AddClick(pdkslz.Toggle4d3.gameObject, this.OnClickToggle4d3)
	message:AddClick(pdkslz.Toggle4d2.gameObject, this.OnClickToggle4d2)
	message:AddClick(pdkslz.Toggle3a.gameObject, this.OnClickToggle3a)
	message:AddClick(pdkslz.ToggleFanHeShou.gameObject, this.OnClickToggleFanHeShou)
	message:AddClick(pdkslz.ToggleFanBei.gameObject, this.OnClickToggleRed10)

	message:AddClick(pdkslz.ToggleOnNiao.gameObject, this.OnClickNiao)
	message:AddClick(pdkslz.ToggleOffNiao.gameObject, this.OnClickNiao)
	message:AddClick(pdkslz.AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(pdkslz.SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)

	message:AddClick(pdkslz.ToggleOnTen.gameObject, this.OnClickTen)
	message:AddClick(pdkslz.ToggleOffTen.gameObject, this.OnClickTen)
	message:AddClick(pdkslz.AddButtonTen.gameObject, this.OnClickChangeTenValue)
	message:AddClick(pdkslz.SubtractButtonTen.gameObject, this.OnClickChangeTenValue)

	message:AddClick(pdkslz.Togglefast.gameObject, this.OnClickToggleSpeed)
	message:AddClick(pdkslz.Toggleslow.gameObject, this.OnClickToggleSpeed)

	message:AddClick(pdkslz.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pdkslz.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pdkslz.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pdkslz.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pdkslz.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pdkslz.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(pdkslz.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(pdkslz.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)

	message:AddClick(pdkslz.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(pdkslz.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(pdkslz.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(pdkslz.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(pdkslz.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)
	
	message:AddClick(pdkslz.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(pdkslz.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end
function this.Refresh()
	print('Refresh_PDKSLZ')
	pdkslz.paymentType = UnityEngine.PlayerPrefs.GetInt('NewPDKSLZpaymentType', 0) --支付类型 0
	pdkslz.size = UnityEngine.PlayerPrefs.GetInt('NewPDKSLZsize', 3)  --人数 2
	pdkslz.rounds = UnityEngine.PlayerPrefs.GetInt('NewPDKSLZrounds', 10) -- 局数 10
	pdkslz.showCount = UnityEngine.PlayerPrefs.GetInt('NewPDKSLZshowCount', 1) == 1  -- 显示牌数量true 
	pdkslz.bichu3 = UnityEngine.PlayerPrefs.GetInt('NewPDKSLZbichu3', 0)==1
	pdkslz.firstPlay = UnityEngine.PlayerPrefs.GetInt('NewPDKSLZfirstPlay', 2)
	pdkslz.remainBanker = UnityEngine.PlayerPrefs.GetInt('NewPDKSLZremainBanker', 1) == 1 -- 连庄规则 true
	
	pdkslz.bombSplit = UnityEngine.PlayerPrefs.GetInt('NewPDKSLZbombSplit', 1) == 1 -- 炸弹可拆 true
	pdkslz.bombBelt = UnityEngine.PlayerPrefs.GetInt('NewPDKSLZbombBelt', 1) == 1 -- 炸弹可带3 true
	pdkslz.bombBelt2 = UnityEngine.PlayerPrefs.GetInt('NewPDKSLZbombBelt2', 1) == 1 -- 炸弹可带2 true
	pdkslz.bomb3a = UnityEngine.PlayerPrefs.GetInt('NewPDKSLZbomb3a', 1) == 1 -- 3a当炸弹
	pdkslz.singleProtect = UnityEngine.PlayerPrefs.GetInt('NewPDKSLZsingleProtect', 0) ~= 0  -- 单张全关保护 false
	pdkslz.preventJointly = UnityEngine.PlayerPrefs.GetInt('NewPDKSLZpreventJointly', 1) ~= 0  -- 防合手 true
	pdkslz.floatScore = UnityEngine.PlayerPrefs.GetInt('NewPDKSLZfloatScore', 0) ~= 0  --飘分 false
	pdkslz.redTen = UnityEngine.PlayerPrefs.GetInt('NewPDKSLZredTen', 0) --红10玩法 false -1
	pdkslz.speed = UnityEngine.PlayerPrefs.GetInt('NewPDKSLZspeed', 1) --pdkslz.speed 
	pdkslz.trusteeshipTime = UnityEngine.PlayerPrefs.GetInt('NewPDKSLZtrusteeshipTime', 0)
	pdkslz.trusteeshipType = UnityEngine.PlayerPrefs.GetInt('NewPDKSLZtrusteeshipTime', 0) == 1
	pdkslz.trusteeshipRound = UnityEngine.PlayerPrefs.GetInt("NewPDKSLZtrusteeshipRound",0)
	pdkslz.niao =  UnityEngine.PlayerPrefs.GetInt('NewPDKSLZniao', 0) == 1
	pdkslz.niaoValue = UnityEngine.PlayerPrefs.GetInt('NewPDKSLZniaoValue', 10)

	pdkslz.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewPDKSLZisSettlementScore', 0)==1
	pdkslz.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewPDKSLZfewerValue', 10)
	pdkslz.addValue=UnityEngine.PlayerPrefs.GetInt('NewPDKSLZaddValue', 10)
	
	pdkslz.openIp=UnityEngine.PlayerPrefs.GetInt('NewPDKSLZcheckIP', 0)==1
	pdkslz.openGps=UnityEngine.PlayerPrefs.GetInt('NewPDKSLZcheckGPS', 0)==1

	pdkslz.choiceDouble             = UnityEngine.PlayerPrefs.GetInt("NewPDKSLZchoiceDouble", 0)==1;
    pdkslz.doubleScore      		= UnityEngine.PlayerPrefs.GetInt("NewPDKSLZdoubleScore", 10)
    pdkslz.multiple      			= UnityEngine.PlayerPrefs.GetInt("NewPDKSLZmultiple", 2)

	pdkslz.ToggleChoiceDouble.parent.gameObject:SetActive(pdkslz.size==2)
    pdkslz.ToggleMultiple2.parent.gameObject:SetActive(pdkslz.size==2 and pdkslz.choiceDouble)
    
	pdkslz.ToggleMultiple2:GetComponent('UIToggle'):Set(pdkslz.multiple == 2)
	pdkslz.ToggleMultiple3:GetComponent('UIToggle'):Set(pdkslz.multiple == 3)
	pdkslz.ToggleMultiple4:GetComponent('UIToggle'):Set(pdkslz.multiple == 4)

	pdkslz.ToggleChoiceDouble:GetComponent('UIToggle'):Set(pdkslz.choiceDouble)
	pdkslz.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not pdkslz.choiceDouble)
	pdkslz.DoubleScoreText.parent.gameObject:SetActive(pdkslz.choiceDouble)
	if pdkslz.doubleScore == 0 then
		pdkslz.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		pdkslz.DoubleScoreText:GetComponent('UILabel').text = '小于'..pdkslz.doubleScore..'分'
	end

	pdkslz.ToggleRound8:GetComponent('UIToggle'):Set(pdkslz.rounds == 8)
	pdkslz.ToggleRound10:GetComponent('UIToggle'):Set(pdkslz.rounds == 10)
	pdkslz.ToggleRound20:GetComponent('UIToggle'):Set(pdkslz.rounds == 20)

	pdkslz.TogglePeopleNum2:GetComponent('UIToggle'):Set(pdkslz.size == 2)
    pdkslz.TogglePeopleNum3:GetComponent('UIToggle'):Set(pdkslz.size == 3)
	
	pdkslz.ToggleMasterPay:GetComponent('UIToggle'):Set(pdkslz.paymentType == 0)
	pdkslz.ToggleWinnerPay:GetComponent('UIToggle'):Set(pdkslz.paymentType == 2)

	pdkslz.ToggleWinnerZhuang:GetComponent('UIToggle'):Set(pdkslz.remainBanker)
	pdkslz.ToggleLastZhuang:GetComponent('UIToggle'):Set(not pdkslz.remainBanker)

	pdkslz.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(pdkslz.trusteeshipTime == 0)
	pdkslz.ToggleTrusteeship1:GetComponent('UIToggle'):Set(pdkslz.trusteeshipTime == 1)
	pdkslz.ToggleTrusteeship2:GetComponent('UIToggle'):Set(pdkslz.trusteeshipTime == 2)
	pdkslz.ToggleTrusteeship3:GetComponent('UIToggle'):Set(pdkslz.trusteeshipTime == 3)
	pdkslz.ToggleTrusteeship5:GetComponent('UIToggle'):Set(pdkslz.trusteeshipTime == 5)
	pdkslz.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(pdkslz.trusteeshipType and pdkslz.trusteeshipRound == 0)
	pdkslz.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not pdkslz.trusteeshipType and pdkslz.trusteeshipRound == 0 )
	pdkslz.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(pdkslz.trusteeshipRound == 3);
	pdkslz.ToggleTrusteeshipOne.parent.gameObject:SetActive( pdkslz.trusteeshipTime ~= 0)

	pdkslz.ToggleZhaDan:GetComponent('UIToggle'):Set(pdkslz.bombSplit)
	pdkslz.Toggle4d3:GetComponent('UIToggle'):Set(pdkslz.bombBelt and pdkslz.bombSplit)
	pdkslz.Toggle4d2:GetComponent('UIToggle'):Set(pdkslz.bombBelt2 and pdkslz.bombSplit)
	pdkslz.ToggleBaoHu:GetComponent('UIToggle'):Set(pdkslz.singleProtect)
	pdkslz.ToggleFanHeShou:GetComponent('UIToggle'):Set(pdkslz.preventJointly)
	pdkslz.ToggleBaoHu.gameObject:SetActive(pdkslz.size == 3)
	pdkslz.ToggleFanHeShou.gameObject:SetActive(pdkslz.size == 3)
	pdkslz.TogglePiaoFen:GetComponent('UIToggle'):Set(pdkslz.floatScore)
	pdkslz.ToggleFanBei:GetComponent('UIToggle'):Set(-1 == pdkslz.redTen)
	pdkslz.ToggleShowCard:GetComponent('UIToggle'):Set(pdkslz.showCount)
	pdkslz.Toggle3a:GetComponent('UIToggle'):Set(pdkslz.bomb3a)

	pdkslz.ToggleIPcheck.parent.gameObject:SetActive(pdkslz.size > 2 and CONST.IPcheckOn)
	pdkslz.ToggleSettlementScoreSelect.parent.gameObject:SetActive(pdkslz.size==2)
	pdkslz.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(pdkslz.isSettlementScore)
	pdkslz.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	pdkslz.ToggleFewerScoreTxt:GetComponent('UILabel').text = pdkslz.fewerValue
	pdkslz.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	pdkslz.ToggleAddScoreTxt:GetComponent('UILabel').text = pdkslz.addValue

	pdkslz.ToggleOnNiao:GetComponent('UIToggle'):Set(pdkslz.niao)
	pdkslz.ToggleOffNiao:GetComponent('UIToggle'):Set(not pdkslz.niao)
	pdkslz.NiaoValueText.parent.gameObject:SetActive(pdkslz.niao)
	pdkslz.NiaoValueText:GetComponent('UILabel').text = pdkslz.niaoValue.."分"

	pdkslz.ToggleOnTen:GetComponent("UIToggle"):Set(pdkslz.redTen >0);
	pdkslz.ToggleOffTen:GetComponent("UIToggle"):Set(pdkslz.redTen == 0 or pdkslz.redTen == -1);
	pdkslz.TenValueText.parent.gameObject:SetActive(pdkslz.redTen > 0);
	pdkslz.TenValueText:GetComponent("UILabel").text = pdkslz.redTen.."分";

	if pdkslz.niao then
		pdkslz.floatScore = false
		UnityEngine.PlayerPrefs.SetInt('NewPDKSLZfloatScore', pdkslz.floatScore and 1 or 0)
		pdkslz.TogglePiaoFen:GetComponent('UIToggle'):Set(pdkslz.floatScore)
	end
	if pdkslz.floatScore == 1 then
		pdkslz.niao = false
		UnityEngine.PlayerPrefs.SetInt('NewPDKSLZniao', pdkslz.niao and 1 or 0)
		pdkslz.NiaoValueText.parent.gameObject:SetActive(pdkslz.niao)
		pdkslz.ToggleOffNiao:GetComponent('UIToggle'):Set(true)
		pdkslz.ToggleOnNiao:GetComponent('UIToggle'):Set(false)
	end
	if pdkslz.size == 2 then
		pdkslz.firstPlay = 2
	elseif pdkslz.size == 3 then
		pdkslz.firstPlay = 1
	end
	pdkslz.Toggle3:GetComponent('UIToggle'):Set(pdkslz.bichu3)
	pdkslz.Toggle3.gameObject:SetActive(pdkslz.firstPlay == 2)
	UnityEngine.PlayerPrefs.SetInt('NewPDKSLZfirstPlay', pdkslz.firstPlay)
	pdkslz.ToggleFanPai:GetComponent('UIToggle'):Set(pdkslz.firstPlay == 1)
	pdkslz.ToggleBlack3:GetComponent('UIToggle'):Set(pdkslz.firstPlay == 2)

	pdkslz.Togglefast:GetComponent('UIToggle'):Set(0 == pdkslz.speed)
	pdkslz.Toggleslow:GetComponent('UIToggle'):Set(1 == pdkslz.speed)
	
	pdkslz.ToggleIPcheck:GetComponent('UIToggle'):Set(pdkslz.openIp)
	pdkslz.ToggleGPScheck:GetComponent('UIToggle'):Set(pdkslz.openGps)
	
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.PDKSLZ,pdkslz.rounds,nil,nil)
	PDKSLZ:Find('table'):GetComponent('UIGrid'):Reposition()
end
--获取当前设置
function this.GetConfig()
    local moneyLess = false
    if ((pdkslz.rounds == 10 or pdkslz.rounds == 8) and info_login.balance < 2) or
        (pdkslz.rounds == 20 and info_login.balance < 4 ) then
        moneyLess = true
    end
    local body = {}
    body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.PDKSLZ)
	body.rounds = pdkslz.rounds
    body.size = pdkslz.size
    body.paymentType = pdkslz.paymentType
    body.remainBanker = pdkslz.remainBanker
    body.trusteeship = pdkslz.trusteeshipTime*60;
    body.trusteeshipDissolve = pdkslz.trusteeshipRound == 0 and pdkslz.trusteeshipType or  false;
	body.trusteeshipRound = pdkslz.trusteeshipRound;
	
	if pdkslz.size == 2 then
		body.resultScore = pdkslz.isSettlementScore
		if pdkslz.isSettlementScore then
			body.resultLowerScore=pdkslz.fewerValue
			body.resultAddScore=pdkslz.addValue
		end
		pdkslz.openIp=false
		pdkslz.openGps=false
		body.choiceDouble = pdkslz.choiceDouble
		body.doubleScore = pdkslz.doubleScore
		body.multiple = pdkslz.multiple
	end
	
    body.cardCount = 16
    body.showCount = pdkslz.showCount
    if pdkslz.firstPlay == 1 then
        body.firstPlay  = "RANDOM" 
    elseif pdkslz.firstPlay == 2 then
        if pdkslz.bichu3 then
            body.firstPlay  = "S3_IN" 
        else
            body.firstPlay  = "S3" 
        end
    end
    body.bombAAA = pdkslz.bomb3a
    body.bombSplit = pdkslz.bombSplit
    body.bombBelt = pdkslz.bombBelt
    body.bombBeltTwo = pdkslz.bombBelt2
    
    body.singleProtect = pdkslz.singleProtect
    body.preventJointly = pdkslz.preventJointly
    body.floatScore = pdkslz.floatScore
    body.hitBird = pdkslz.niao and pdkslz.niaoValue or 0;

    body.redTen = pdkslz.redTen
    body.speed = pdkslz.speed
	body.openIp	 = pdkslz.openIp
	body.openGps = pdkslz.openGps

    return moneyLess,body;
end

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
    if pdkslz.ToggleRound8.gameObject == go then
        pdkslz.rounds = 8
	elseif pdkslz.ToggleRound10.gameObject == go then
        pdkslz.rounds = 10
    elseif pdkslz.ToggleRound20.gameObject == go then
        pdkslz.rounds = 20
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.PDKSLZ,pdkslz.rounds,nil,nil)
    UnityEngine.PlayerPrefs.SetInt('NewPDKSLZrounds', pdkslz.rounds)
end

function this.OnClickTogglePlayerNum(go)
    AudioManager.Instance:PlayAudio('btn')
	if pdkslz.TogglePeopleNum2.gameObject == go then
        pdkslz.size = 2
        pdkslz.firstPlay = 2
    elseif pdkslz.TogglePeopleNum3.gameObject == go then
        pdkslz.size = 3
        pdkslz.firstPlay = 1
	end
	pdkslz.ToggleIPcheck.parent.gameObject:SetActive(pdkslz.size > 2 and CONST.IPcheckOn)
	pdkslz.ToggleBaoHu.gameObject:SetActive(pdkslz.size == 3)
	pdkslz.ToggleFanHeShou.gameObject:SetActive(pdkslz.size == 3)
    pdkslz.Toggle3:GetComponent('UIToggle'):Set(pdkslz.bichu3)
    pdkslz.Toggle3.gameObject:SetActive(pdkslz.firstPlay == 2)
    UnityEngine.PlayerPrefs.SetInt('NewPDKSLZfirstPlay', pdkslz.firstPlay)
    pdkslz.ToggleFanPai:GetComponent('UIToggle'):Set(pdkslz.firstPlay == 1)
    pdkslz.ToggleBlack3:GetComponent('UIToggle'):Set(pdkslz.firstPlay == 2)
    UnityEngine.PlayerPrefs.SetInt('NewPDKSLZsize', pdkslz.size)
	pdkslz.ToggleSettlementScoreSelect.parent.gameObject:SetActive(pdkslz.size==2)
	
	pdkslz.ToggleChoiceDouble.parent.gameObject:SetActive(pdkslz.size == 2)
	pdkslz.ToggleMultiple2.parent.gameObject:SetActive(pdkslz.size == 2 and pdkslz.choiceDouble)
	PDKSLZ:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if pdkslz.ToggleMasterPay.gameObject == go then
        pdkslz.paymentType=0
    elseif pdkslz.ToggleWinnerPay then
        pdkslz.paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewPDKSLZpaymentType', pdkslz.paymentType)
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if pdkslz.ToggleTrusteeshipNo.gameObject == go then
        pdkslz.trusteeshipTime = 0
    elseif pdkslz.ToggleTrusteeship1.gameObject == go then
        pdkslz.trusteeshipTime = 1
	elseif pdkslz.ToggleTrusteeship2.gameObject == go then
		pdkslz.trusteeshipTime = 2
	elseif pdkslz.ToggleTrusteeship3.gameObject == go then
        pdkslz.trusteeshipTime = 3
    elseif pdkslz.ToggleTrusteeship5.gameObject == go then
        pdkslz.trusteeshipTime = 5
    end
    UnityEngine.PlayerPrefs.SetInt('NewPDKSLZtrusteeshipTime', pdkslz.trusteeshipTime)
	pdkslz.ToggleTrusteeshipOne.parent.gameObject:SetActive(pdkslz.trusteeshipTime ~= 0)
	PDKSLZ:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if pdkslz.ToggleTrusteeshipOne.gameObject == go then
        pdkslz.trusteeshipType = true
		pdkslz.trusteeshipRound = 0;
    elseif pdkslz.ToggleTrusteeshipAll.gameObject == go then
        pdkslz.trusteeshipType = false
		pdkslz.trusteeshipRound = 0;
	elseif pdkslz.ToggleTrusteeshipThree.gameObject == go then
		pdkslz.trusteeshipRound = 3;
		pdkslz.trusteeshipType = false;
    end
    UnityEngine.PlayerPrefs.SetInt('NewPDKSLZtrusteeshipType',pdkslz.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewPDKSLZtrusteeshipRound',pdkslz.trusteeshipRound)
end

function this.OnClickNiao(go)
	AudioManager.Instance:PlayAudio('btn')
	if pdkslz.ToggleOnNiao.gameObject == go then
		pdkslz.niao = true
		pdkslz.floatScore = false
		UnityEngine.PlayerPrefs.SetInt('NewPDKSLZfloatScore', pdkslz.floatScore and 1 or 0)
		pdkslz.TogglePiaoFen:GetComponent('UIToggle'):Set(pdkslz.floatScore)
	elseif pdkslz.ToggleOffNiao.gameObject == go then
		pdkslz.niao = false
	end
	pdkslz.NiaoValueText.parent.gameObject:SetActive(pdkslz.niao)
	UnityEngine.PlayerPrefs.SetInt('NewPDKSLZniao', pdkslz.niao and 1 or 0)
end


function this.OnClickTen(go)
	AudioManager.Instance:PlayAudio('btn')
	if pdkslz.ToggleOnTen.gameObject == go then
		pdkslz.redTen = UnityEngine.PlayerPrefs.GetInt("NewPDKSLZredTen",5);
		if pdkslz.redTen <= 0 then
			pdkslz.redTen = 5;
		end
		pdkslz.ToggleFanBei:GetComponent("UIToggle"):Set(false);
		pdkslz.TenValueText:GetComponent("UILabel").text = pdkslz.redTen.."分";

		pdkslz.TenValueText.parent.gameObject:SetActive(true);
	elseif pdkslz.ToggleOffTen.gameObject == go then

		pdkslz.TenValueText.parent.gameObject:SetActive(false);
		if pdkslz.ToggleFanBei:GetComponent("UIToggle").value == false then
			pdkslz.redTen = 0;
		else
			pdkslz.redTen = -1;
		end
	end
	UnityEngine.PlayerPrefs.SetInt('NewPDKSLZredTen', pdkslz.redTen);

end



function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if pdkslz.AddButtonNiao.gameObject == go then
		pdkslz.niaoValue = pdkslz.niaoValue + 10
		if pdkslz.niaoValue > 100 then
			pdkslz.niaoValue = 100
		end
	elseif pdkslz.SubtractButtonNiao.gameObject == go then
		pdkslz.niaoValue = pdkslz.niaoValue - 10
		if pdkslz.niaoValue < 10 then
			pdkslz.niaoValue = 10
		end
	end
	pdkslz.NiaoValueText:GetComponent('UILabel').text = pdkslz.niaoValue.."分"
	UnityEngine.PlayerPrefs.SetInt('NewPDKSLZniaoValue', pdkslz.niaoValue)
end


function this.OnClickChangeTenValue(go)
	AudioManager.Instance:PlayAudio('btn');
	if pdkslz.AddButtonTen.gameObject == go then
		pdkslz.redTen = pdkslz.redTen + 5;
		if pdkslz.redTen > 50 then
			pdkslz.redTen = 50;
		end
	elseif pdkslz.SubtractButtonTen.gameObject == go then
		pdkslz.redTen = pdkslz.redTen - 5;
		if pdkslz.redTen < 5 then
			pdkslz.redTen = 5;
		end
	end

	pdkslz.TenValueText:GetComponent("UILabel").text = pdkslz.redTen.."分";

	UnityEngine.PlayerPrefs.SetInt('NewPDKSLZredTen', pdkslz.redTen);
end



function this.OnClickToggleQiangZhuang(go)
	AudioManager.Instance:PlayAudio('btn')
	if pdkslz.ToggleFanPai.gameObject == go then
		pdkslz.firstPlay = 1
	else
		pdkslz.firstPlay = 2
	end
	pdkslz.Toggle3.gameObject:SetActive(pdkslz.firstPlay == 2)
	UnityEngine.PlayerPrefs.SetInt('NewPDKSLZfirstPlay', pdkslz.firstPlay)
end

function  this.OnClickToggle3(go)
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		pdkslz.bichu3 = true
		UnityEngine.PlayerPrefs.SetInt('NewPDKSLZbichu3', pdkslz.bichu3 and 1 or 0)
	else
		pdkslz.bichu3 = false
		UnityEngine.PlayerPrefs.SetInt('NewPDKSLZbichu3', pdkslz.bichu3 and 1 or 0)
	end
end

function this.OnClickToggleLunZhuang(go)  --轮庄方式
	AudioManager.Instance:PlayAudio('btn')
	if pdkslz.ToggleWinnerZhuang.gameObject == go then
		pdkslz.remainBanker = true
	else
		pdkslz.remainBanker = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewPDKSLZremainBanker', pdkslz.remainBanker and 1 or 0)
end

function this.OnClickTogglePiaoFen(go)  --飘分
	AudioManager.Instance:PlayAudio('btn')
    if go:GetComponent('UIToggle').value == true then
        pdkslz.floatScore = true
        pdkslz.niao = false
        UnityEngine.PlayerPrefs.SetInt('NewPDKSLZniao', pdkslz.niao and 1 or 0)
        pdkslz.NiaoValueText.parent.gameObject:SetActive(pdkslz.niao)
        pdkslz.ToggleOffNiao:GetComponent('UIToggle'):Set(true)
        pdkslz.ToggleOnNiao:GetComponent('UIToggle'):Set(false)
    else
        pdkslz.floatScore = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewPDKSLZfloatScore', pdkslz.floatScore and 1 or 0)
end

function this.OnClickToggleBaoHu(go)  --单张全关保护
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		pdkslz.singleProtect = true
	else
		pdkslz.singleProtect = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewPDKSLZsingleProtect', pdkslz.singleProtect and 1 or 0)
end

function this.OnClickToggleShowCard(go)  --显示剩余牌数量
	AudioManager.Instance:PlayAudio('btn')
	if createRoomType == 31  then
		if go:GetComponent('UIToggle').value == true then
			pdkslz.showCount = true
		else
			pdkslz.showCount = false
		end
		UnityEngine.PlayerPrefs.SetInt('NewPDKSLZshowCount', pdkslz.showCount and 1 or 0)
	end
	
end
function this.OnClickToggleZhaDan(go)  --炸弹可拆
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		pdkslz.bombSplit = true
	else
		pdkslz.bombSplit = false
		pdkslz.bombBelt = false
		pdkslz.bombBelt2 = false
		pdkslz.Toggle4d3:GetComponent('UIToggle').value = pdkslz.bombBelt
		pdkslz.Toggle4d2:GetComponent('UIToggle').value = pdkslz.bombBelt2
		UnityEngine.PlayerPrefs.SetInt('NewPDKSLZbombBelt', pdkslz.bombBelt and 1 or 0)
		UnityEngine.PlayerPrefs.SetInt('NewPDKSLZbombBelt2', pdkslz.bombBelt2 and 1 or 0)
	end
	UnityEngine.PlayerPrefs.SetInt('NewPDKSLZbombSplit', pdkslz.bombSplit and 1 or 0)
end

function this.OnClickToggle4d3(go)  --炸弹4带3
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		pdkslz.bombBelt = true
		pdkslz.bombSplit = true
		pdkslz.ToggleZhaDan:GetComponent('UIToggle').value = pdkslz.bombSplit
		UnityEngine.PlayerPrefs.SetInt('NewPDKSLZbombSplit', pdkslz.bombSplit and 1 or 0)
	else
		pdkslz.bombBelt = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewPDKSLZbombBelt', pdkslz.bombBelt and 1 or 0)
end

function this.OnClickToggle4d2(go)  --炸弹4带2
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		pdkslz.bombBelt2 = true
		pdkslz.bombSplit = true
		pdkslz.ToggleZhaDan:GetComponent('UIToggle').value = pdkslz.bombSplit
		UnityEngine.PlayerPrefs.SetInt('NewPDKSLZbombSplit', pdkslz.bombSplit and 1 or 0)
	else
		pdkslz.bombBelt2 = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewPDKSLZbombBelt2', pdkslz.bombBelt2 and 1 or 0)
end

function this.OnClickToggle3a(go)  --3a当炸弹
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		pdkslz.bomb3a = true
	else
		pdkslz.bomb3a = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewPDKSLZbomb3a', pdkslz.bomb3a and 1 or 0)
end

function this.OnClickToggleFanHeShou(go)  --防合手
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		pdkslz.preventJointly = true
	else
		pdkslz.preventJointly = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewPDKSLZpreventJointly', pdkslz.preventJointly and 1 or 0)
end

function this.OnClickToggleRed10(go)  --红十玩法
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		pdkslz.redTen = -1
		pdkslz.ToggleOffTen:GetComponent("UIToggle"):Set(true);
		pdkslz.ToggleOnTen:GetComponent("UIToggle"):Set(false);
		pdkslz.TenValueText.parent.gameObject:SetActive(false);
	else
		pdkslz.redTen = 0
	end
	UnityEngine.PlayerPrefs.SetInt('NewPDKSLZredTen', pdkslz.redTen)
end

function this.OnClickToggleSpeed(go)
	AudioManager.Instance:PlayAudio('btn')
	if pdkslz.Togglefast.gameObject == go then
		pdkslz.speed = 1
	elseif pdkslz.Toggleslow.gameObject == go then
		pdkslz.speed = 0
	end
	UnityEngine.PlayerPrefs.SetInt('NewPDKSLZspeed', pdkslz.speed)
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    pdkslz.isSettlementScore= pdkslz.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewPDKSLZisSettlementScore', pdkslz.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if pdkslz.ToggleFewerAddButton.gameObject == go then
		pdkslz.fewerValue = pdkslz.fewerValue + 1
		if pdkslz.fewerValue > 100 then
			pdkslz.fewerValue = 100
		end
    elseif pdkslz.ToggleFewerSubtractButton.gameObject == go then
		pdkslz.fewerValue = pdkslz.fewerValue - 1
		if pdkslz.fewerValue < 1 then
			pdkslz.fewerValue = 1
		end
	end
	pdkslz.ToggleFewerScoreTxt:GetComponent('UILabel').text = pdkslz.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewPDKSLZfewerValue', pdkslz.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if pdkslz.ToggleAddAddButton.gameObject == go then
		pdkslz.addValue = pdkslz.addValue + 1
		if pdkslz.addValue > 100 then
			pdkslz.addValue = 100
		end
    elseif pdkslz.ToggleAddSubtractButton.gameObject == go then
		pdkslz.addValue = pdkslz.addValue - 1
		if pdkslz.addValue < 1 then
			pdkslz.addValue = 1
		end
	end
	pdkslz.ToggleAddScoreTxt:GetComponent('UILabel').text = pdkslz.addValue
	UnityEngine.PlayerPrefs.SetInt('NewPDKSLZaddValue', pdkslz.addValue)
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if pdkslz.ToggleIPcheck.gameObject == go then
		pdkslz.openIp = pdkslz.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('NewPDKSLZcheckIP', pdkslz.openIp and 1 or 0)
	elseif pdkslz.ToggleGPScheck.gameObject == go then
		pdkslz.openGps = pdkslz.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewPDKSLZcheckGPS', pdkslz.openGps and 1 or 0)
	end
end

function this.OnClickChoiceDouble(go)
    AudioManager.Instance:PlayAudio('btn')
	if pdkslz.ToggleChoiceDouble.gameObject == go then
		pdkslz.choiceDouble = true
	else
		pdkslz.choiceDouble = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewPDKSLZchoiceDouble', pdkslz.choiceDouble and 1 or 0)
	pdkslz.DoubleScoreText.parent.gameObject:SetActive(pdkslz.choiceDouble)
    pdkslz.ToggleMultiple2.parent.gameObject:SetActive(pdkslz.choiceDouble)
    PDKSLZ:Find('table'):GetComponent('UIGrid'):Reposition()
	if pdkslz.choiceDouble then
		pdkslz.ToggleMultiple2:GetComponent('UIToggle'):Set(pdkslz.multiple == 2)
		pdkslz.ToggleMultiple3:GetComponent('UIToggle'):Set(pdkslz.multiple == 3)
		pdkslz.ToggleMultiple4:GetComponent('UIToggle'):Set(pdkslz.multiple == 4)
	end
end

function this.OnClickChangeDoubleScore(go)
    AudioManager.Instance:PlayAudio('btn')
    local label_= pdkslz.DoubleScoreText:GetComponent('UILabel').text
    if label_=='不限分' then
        pdkslz.doubleScore=0
    else
        pdkslz.doubleScore=tonumber(string.sub(label_,7,-4))    
    end
	if pdkslz.AddDoubleScoreButton.gameObject == go then
		if pdkslz.doubleScore ~= 0 then
			pdkslz.doubleScore = pdkslz.doubleScore + 1
			if pdkslz.doubleScore > 100 then
				pdkslz.doubleScore = 0
			end
		end
	else
		if pdkslz.doubleScore == 0 then
			pdkslz.doubleScore = 100
		else
			pdkslz.doubleScore = pdkslz.doubleScore - 1
			if pdkslz.doubleScore < 1 then
				pdkslz.doubleScore = 1
			end
		end
	end

	if pdkslz.doubleScore == 0 then
		pdkslz.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		pdkslz.DoubleScoreText:GetComponent('UILabel').text = '小于'..pdkslz.doubleScore..'分'
	end
	UnityEngine.PlayerPrefs.SetInt('NewPDKSLZdoubleScore', pdkslz.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
	pdkslz.multiple = tonumber(go.name)
	print('倍数：'..pdkslz.multiple)
	UnityEngine.PlayerPrefs.SetInt('NewPDKSLZmultiple', pdkslz.multiple)
end

return this