local this = {}

local CSM
local payLabel

local csm = {
	rounds=8, -- 局数
	size=2,--人数
	minorityMode=false,--true开启了少人模式，false未开启少人模式（默认false）
	paymentType=0, --支付类型
	trusteeshipTime=0,--0不托管，1托管1分钟，3托管3分钟，5托管5分钟
	trusteeshipType=true,--false满局结算，true本局结算
	trusteeshipRound = 0,--3局解散

	isSettlementScore=false,
	fewerValue=10,
	addValue=10,

	bankerAddOne=false,
	floatScore=false,
	tianDiHu=false,
	quanQiuRen=false,
	menQing=false,
	menQingZiMo=false,
	shQueYiSe=false,
	shBanBanHu=false,
	shJieJieGao=false,
	shYiZhiHua=false,
	shSanTong=false,
	shJinTongYuNv=false,
	shDaSiXi=false,
	shLiuLiuShun=false,
	ztDaSiXi=false,
	ztLiuLiuShun=false,
	gangMahjongCount=2,

	birdNum=4,
	birdType=0,
	bridAlgorithm=2,

	choiceDouble = false,
	doubleScore = 10,
	multiple = 2,

	cappingScore = 0,
	queYiMen = false,
	missGuoHu = false,

	ToggleRound8=nil,--10局
	ToggleRound16=nil,--16局

	TogglePeopleNum2=nil,--2人
	TogglePeopleNum3=nil,--3人
	TogglePeopleNum4=nil,--3人
	ToggleLessPlayerStart=nil,--可少人开局

	ToggleMasterPay=nil, -- 房主支付  
	ToggleWinnerPay=nil, -- 赢家支付 

	ToggleSettlementScoreSelect=nil,
	ToggleFewerScoreTxt=nil,
	ToggleFewerAddButton=nil,
	ToggleFewerSubtractButton=nil,
	ToggleAddScoreTxt=nil,
	ToggleAddAddButton=nil,
	ToggleAddSubtractButton=nil,

	ToggleRegularScoreOffButton=nil,--不固定飘分
	ToggleRegularScoreOnButton=nil,--固定飘分
	RegularScoreTxt=nil,
	RegularAddButton=nil,
	RegularSubtractButton=nil,

	choiceRegular = false,
	regularScore = 1,

	ToggleTrusteeshipNo=nil,--不托管
	ToggleTrusteeship1=nil,--托管1分钟
	ToggleTrusteeship2=nil,--托管2分钟
	ToggleTrusteeship3=nil,--托管3分钟
	ToggleTrusteeship5=nil,--托管4分钟

	ToggleTrusteeshipOne=nil,--本局结算
	ToggleTrusteeshipAll=nil,--满局结算
	ToggleTrusteeshipThree=nil,--满局结算
	
	ToggleIPcheck=nil,		--防作弊，IP检测
	ToggleGPScheck=nil,		--防作弊，GPS检测

	changshaCustomizeZhuangxian = nil,
	changshaCustomizePiaofen = nil,
	changshaCustomizeTiandihu = nil,
	changshaCustomizeQuanqiuren = nil,
	changshaCustomizeMenQing = nil,
	changshaCustomizeMenQingZiMo = nil,
	changshaCustomizeMissGuoHu = nil,
	changshaQueyise = nil,
	changshaBanbanhu = nil,
	changshaJiejiegao = nil,
	changshaYizhihua = nil,
	changshaSantong = nil,
	changshaJintongyunv = nil,
	changshaDasixi = nil,
	changshaLiuliushun = nil,
	changshaZhongtudasixi = nil,
	changshaZhongtuliuliushun = nil,

	changshaKaigang2 = nil,
	changshaKaigang4 = nil,

	changshaCatchBirdDouble = nil,
	changshaCatchBirdYiFen = nil,
	changshaNiao1 = nil,
	changshaNiao2 = nil,
	changshaNiao4 = nil,
	changshaNiao6 = nil,
	
	ToggleMultiple2=nil,
	ToggleMultiple3=nil,
	ToggleMultiple4=nil,

	ToggleChoiceDouble=nil,
	ToggleNoChoiceDouble=nil,
	DoubleScoreText=nil,
	AddDoubleScoreButton=nil,
	SubtractDoubleScoreButton=nil,

	ToggleCappingScore0=nil,
	ToggleCappingScore15=nil,
	ToggleCappingScore21=nil,
	ToggleCappingScore42=nil,
	ToggleQueYiMen=nil,
}

function this.Init(grid,message)
	print('Init_CSM')
	CSM = grid
    payLabel = message.transform:Find('diamond/pay_label')
    
    csm.ToggleRound8 = CSM:Find("table/ToggleRound/ToggleRound8")
	csm.ToggleRound16 = CSM:Find("table/ToggleRound/ToggleRound16")
	message:AddClick(csm.ToggleRound8.gameObject, this.OnClickToggleRound)
	message:AddClick(csm.ToggleRound16.gameObject, this.OnClickToggleRound)

    csm.TogglePeopleNum2 = CSM:Find("table/TogglePeople/Toggle2P")
    csm.TogglePeopleNum3 = CSM:Find("table/TogglePeople/Toggle3P")
	csm.TogglePeopleNum4 = CSM:Find("table/TogglePeople/Toggle4P")
	csm.ToggleLessPlayerStart = CSM:Find("table/TogglePeople/lessPlayerStart")
	message:AddClick(csm.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(csm.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(csm.TogglePeopleNum4.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(csm.ToggleLessPlayerStart.gameObject, this.OnClickToggleLessPlayerStart)

    csm.ToggleMasterPay = CSM:Find("table/TogglePayType/ToggleMasterPay")
	csm.ToggleWinnerPay = CSM:Find("table/TogglePayType/ToggleWinnerPay")
	message:AddClick(csm.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(csm.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)
	
    csm.changshaCustomizeZhuangxian = CSM:Find("table/TogglePlay1/Zhuanxian")
    csm.changshaCustomizePiaofen = CSM:Find("table/TogglePlay1/Piaofen")
	csm.changshaCustomizeTiandihu = CSM:Find("table/TogglePlay1/TianDiHu")
	csm.changshaCustomizeQuanqiuren = CSM:Find("table/TogglePlay2/Quanqiuren")
	csm.changshaCustomizeMenQing = CSM:Find("table/TogglePlay2/MenQing")
	csm.changshaCustomizeMenQingZiMo = CSM:Find("table/TogglePlay2/MenQingZiMo")
	csm.changshaCustomizeMissGuoHu = CSM:Find("table/TogglePlay3/missGuoHu")
	csm.ToggleQueYiMen = CSM:Find("table/TogglePlay3/queYiMen")
	message:AddClick(csm.changshaCustomizeZhuangxian.gameObject, this.OnClickToggleZhuangxian)
	message:AddClick(csm.changshaCustomizePiaofen.gameObject, this.OnClickTogglePiaoFen)
	message:AddClick(csm.changshaCustomizeTiandihu.gameObject, this.OnClickToggleTiandihu)
	message:AddClick(csm.changshaCustomizeQuanqiuren.gameObject, this.OnClickToggleQuanQiuRen)
	message:AddClick(csm.changshaCustomizeMenQing.gameObject, this.OnClickToggleMenQing)
	message:AddClick(csm.changshaCustomizeMenQingZiMo.gameObject, this.OnClickToggleMenQingZiMo)
	message:AddClick(csm.changshaCustomizeMissGuoHu.gameObject, this.OnClickToggleMissHu)
	message:AddClick(csm.ToggleQueYiMen.gameObject, this.OnClickQueYiMen)
	
	csm.changshaQueyise = CSM:Find("table/ToggleCapping1/Queyise")
	csm.changshaBanbanhu = CSM:Find("table/ToggleCapping1/Banbanhu")
	csm.changshaDasixi = CSM:Find("table/ToggleCapping1/Dasixi")
	csm.changshaLiuliushun = CSM:Find("table/ToggleCapping2/Liuliushun")
	csm.changshaJiejiegao = CSM:Find("table/ToggleCapping2/Jiejiegao")
	csm.changshaYizhihua = CSM:Find("table/ToggleCapping2/Yizhihua")
	csm.changshaSantong = CSM:Find("table/ToggleCapping3/SanTong")
	csm.changshaJintongyunv = CSM:Find("table/ToggleCapping3/JinTongYunv")
	csm.changshaZhongtudasixi = CSM:Find("table/ToggleCapping3/ZhongtuDasixi")
	csm.changshaZhongtuliuliushun = CSM:Find("table/ToggleCapping4/ZHongtuLiuLiu")
	message:AddClick(csm.changshaQueyise.gameObject, this.OnClickToggleQueyise)
	message:AddClick(csm.changshaBanbanhu.gameObject, this.OnClickToggleBanbanhu)
	message:AddClick(csm.changshaJiejiegao.gameObject, this.OnClickToggleJiejiegao)
	message:AddClick(csm.changshaYizhihua.gameObject, this.OnClickToggleYizhihua)
	message:AddClick(csm.changshaSantong.gameObject, this.OnClickToggleSantong)
	message:AddClick(csm.changshaJintongyunv.gameObject, this.OnClickToggleJintongyunv)
	message:AddClick(csm.changshaDasixi.gameObject, this.OnClickToggleDasixi)
	message:AddClick(csm.changshaLiuliushun.gameObject, this.OnClickToggleLiuliushun)
	message:AddClick(csm.changshaZhongtudasixi.gameObject, this.OnClickToggleZhongtudasixi)
	message:AddClick(csm.changshaZhongtuliuliushun.gameObject, this.OnClickToggleZhongtuliuliushun)
	
	csm.changshaKaigang2 = CSM:Find("table/ToggleKaiGang/Gang2")
	csm.changshaKaigang4 = CSM:Find("table/ToggleKaiGang/Gang4")
	message:AddClick(csm.changshaKaigang2.gameObject, this.OnClickToggleKaigang)
	message:AddClick(csm.changshaKaigang4.gameObject, this.OnClickToggleKaigang)

	csm.ToggleWinPos = CSM:Find("table/ToggleNiaoType/winPos")
	csm.Toggle13579Bird = CSM:Find("table/ToggleNiaoType/13579Bird")
	csm.ToggleNoBird = CSM:Find("table/ToggleNiaoType/noBird")
	message:AddClick(csm.ToggleWinPos.gameObject, this.OnClickToggleNiaoType)
	message:AddClick(csm.Toggle13579Bird.gameObject, this.OnClickToggleNiaoType)
	message:AddClick(csm.ToggleNoBird.gameObject, this.OnClickToggleNiaoType)

	csm.changshaCatchBirdDouble = CSM:Find("table/ToggleCatchAlgorithm/GangDouble")
	csm.changshaCatchBirdYiFen = CSM:Find("table/ToggleCatchAlgorithm/GangYifen")
	message:AddClick(csm.changshaCatchBirdDouble.gameObject, this.OnClickButtonZhuaNiaoCSM)
	message:AddClick(csm.changshaCatchBirdYiFen.gameObject, this.OnClickButtonZhuaNiaoCSM)

	csm.changshaNiao1 = CSM:Find("table/ToggleCatchBird/Niao1")
	csm.changshaNiao2 = CSM:Find("table/ToggleCatchBird/Niao2")
	csm.changshaNiao4 = CSM:Find("table/ToggleCatchBird/Niao4")
	csm.changshaNiao6 = CSM:Find("table/ToggleCatchBird/Niao6")
	message:AddClick(csm.changshaNiao1.gameObject, this.OnClickButtonNiaoNumCSM)
	message:AddClick(csm.changshaNiao2.gameObject, this.OnClickButtonNiaoNumCSM)
	message:AddClick(csm.changshaNiao4.gameObject, this.OnClickButtonNiaoNumCSM)
	message:AddClick(csm.changshaNiao6.gameObject, this.OnClickButtonNiaoNumCSM)
	
	csm.ToggleRegularScoreOnButton  = CSM:Find('table/regularScore/On')
	csm.ToggleRegularScoreOffButton = CSM:Find('table/regularScore/Off')
	csm.RegularScoreTxt = CSM:Find('table/regularScore/Score/Value')
	csm.RegularAddButton = CSM:Find('table/regularScore/Score/AddButton')
	csm.RegularSubtractButton = CSM:Find('table/regularScore/Score/SubtractButton')
	message:AddClick(csm.ToggleRegularScoreOnButton.gameObject, this.OnClickRegularScore)
	message:AddClick(csm.ToggleRegularScoreOffButton.gameObject, this.OnClickRegularScore)
	message:AddClick(csm.RegularAddButton.gameObject, this.OnClickChangeRegularScore)
	message:AddClick(csm.RegularSubtractButton.gameObject, this.OnClickChangeRegularScore)

	csm.ToggleCappingScore0 = CSM:Find('table/cappingScore/0')
	csm.ToggleCappingScore15 = CSM:Find('table/cappingScore/15')
	csm.ToggleCappingScore21 = CSM:Find('table/cappingScore/21')
	csm.ToggleCappingScore42 = CSM:Find('table/cappingScore/42')
	message:AddClick(csm.ToggleCappingScore0.gameObject, this.OnClickToggleCappingScoreCSM)
	message:AddClick(csm.ToggleCappingScore15.gameObject, this.OnClickToggleCappingScoreCSM)
	message:AddClick(csm.ToggleCappingScore21.gameObject, this.OnClickToggleCappingScoreCSM)
	message:AddClick(csm.ToggleCappingScore42.gameObject, this.OnClickToggleCappingScoreCSM)

	csm.ToggleChoiceDouble  = CSM:Find('table/choiceDouble/On')
	csm.ToggleNoChoiceDouble = CSM:Find('table/choiceDouble/Off')
	csm.DoubleScoreText = CSM:Find('table/choiceDouble/doubleScore/Value')
	csm.AddDoubleScoreButton = CSM:Find('table/choiceDouble/doubleScore/AddButton')
	csm.SubtractDoubleScoreButton = CSM:Find('table/choiceDouble/doubleScore/SubtractButton')
	csm.ToggleMultiple2 = CSM:Find('table/multiple/2')
	csm.ToggleMultiple3 = CSM:Find('table/multiple/3')
	csm.ToggleMultiple4 = CSM:Find('table/multiple/4')
	message:AddClick(csm.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(csm.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(csm.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(csm.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(csm.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(csm.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(csm.ToggleMultiple4.gameObject, this.OnClickMultiple)

	csm.ToggleSettlementScoreSelect=CSM:Find('table/settlementScore/select')
	csm.ToggleFewerScoreTxt=CSM:Find('table/settlementScore/fewerValue/Value')
	csm.ToggleFewerAddButton=CSM:Find('table/settlementScore/fewerValue/AddButton')
	csm.ToggleFewerSubtractButton=CSM:Find('table/settlementScore/fewerValue/SubtractButton')
	csm.ToggleAddScoreTxt=CSM:Find('table/settlementScore/addValue/Value')
	csm.ToggleAddAddButton=CSM:Find('table/settlementScore/addValue/AddButton')
	csm.ToggleAddSubtractButton=CSM:Find('table/settlementScore/addValue/SubtractButton')
	message:AddClick(csm.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(csm.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(csm.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(csm.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(csm.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)

	csm.ToggleTrusteeshipNo = CSM:Find('table/DelegateChoose/NoDelegate')
	csm.ToggleTrusteeship1 = CSM:Find('table/DelegateChoose/Delegate1')
	csm.ToggleTrusteeship2 = CSM:Find('table/DelegateChoose/Delegate2')
	csm.ToggleTrusteeship3 = CSM:Find('table/DelegateChoose/Delegate3')
	csm.ToggleTrusteeship5 = CSM:Find('table/DelegateChoose1/Delegate5')
	csm.ToggleTrusteeshipAll = CSM:Find('table/DelegateCancel/FullRound')
	csm.ToggleTrusteeshipOne = CSM:Find('table/DelegateCancel/ThisRound')
	csm.ToggleTrusteeshipThree = CSM:Find('table/DelegateCancel/ThreeRound')
	message:AddClick(csm.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(csm.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(csm.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(csm.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(csm.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(csm.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(csm.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(csm.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)

	csm.ToggleIPcheck = CSM:Find('table/PreventCheat/IPcheck')
	csm.ToggleGPScheck = CSM:Find('table/PreventCheat/GPScheck')
	message:AddClick(csm.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(csm.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end
function this.Refresh()
	print('Refresh_CSM')
	csm.rounds = UnityEngine.PlayerPrefs.GetInt('NewCSMrounds', 8)
	csm.size = UnityEngine.PlayerPrefs.GetInt('NewCSMsize', 2)
	csm.minorityMode=UnityEngine.PlayerPrefs.GetInt('NewCSMminorityMode', 0)==1
	csm.paymentType = UnityEngine.PlayerPrefs.GetInt('NewCSMpaymentType', 0)
	csm.trusteeshipTime=UnityEngine.PlayerPrefs.GetInt('NewCSMtrusteeshipTime', 0)
	csm.trusteeshipType=UnityEngine.PlayerPrefs.GetInt('NewCSMtrusteeshipType', 0)==1
	csm.trusteeshipRound=UnityEngine.PlayerPrefs.GetInt('NewCSMtrusteeshipRound', 0);

	csm.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewCSMisSettlementScore', 0)==1
	csm.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewCSMfewerValue', 10)
	csm.addValue=UnityEngine.PlayerPrefs.GetInt('NewCSMaddValue', 10)

	csm.bankerAddOne=UnityEngine.PlayerPrefs.GetInt('NewCSMbankerAddOne', 0)==1
	csm.floatScore=UnityEngine.PlayerPrefs.GetInt('NewCSMfloatScore', 0)==1
	csm.tianDiHu=UnityEngine.PlayerPrefs.GetInt('NewCSMtianDiHu', 0)==1
	csm.quanQiuRen=UnityEngine.PlayerPrefs.GetInt('NewCSMquanQiuren', 1)==1
	csm.menQing=UnityEngine.PlayerPrefs.GetInt('NewCSMmenQing', 0)==1
	csm.menQingZiMo=UnityEngine.PlayerPrefs.GetInt('NewCSMmenQingZiMo', 0)==1
	csm.queYiMen=UnityEngine.PlayerPrefs.GetInt('NewCSMqueYiMen', 0)==1

	csm.shQueYiSe=UnityEngine.PlayerPrefs.GetInt('NewCSMshQueYiSe', 1)==1
	csm.shBanBanHu=UnityEngine.PlayerPrefs.GetInt('NewCSMshBanBanHu', 1)==1
	csm.shJieJieGao=UnityEngine.PlayerPrefs.GetInt('NewCSMshJieJieGao', 0)==1
	csm.shYiZhiHua=UnityEngine.PlayerPrefs.GetInt('NewCSMshYiZhiHua', 0)==1
	csm.shSanTong=UnityEngine.PlayerPrefs.GetInt('NewCSMshSanTong', 0)==1
	csm.shJinTongYuNv=UnityEngine.PlayerPrefs.GetInt('NewCSMshJinTongYuNv', 0)==1
	csm.shDaSiXi=UnityEngine.PlayerPrefs.GetInt('NewCSMshDaSiXi', 1)==1
	csm.shLiuLiuShun=UnityEngine.PlayerPrefs.GetInt('NewCSMshLiuLiuShun', 1)==1
	csm.ztDaSiXi=UnityEngine.PlayerPrefs.GetInt('NewCSMztDaSiXi', 0)==1
	csm.ztLiuLiuShun=UnityEngine.PlayerPrefs.GetInt('NewCSMztLiuLiuShun', 0)==1

	csm.gangMahjongCount=UnityEngine.PlayerPrefs.GetInt('NewCSMgangMahjongCount', 2)

	csm.birdType=UnityEngine.PlayerPrefs.GetInt('NewCSMbirdType', 0)
	csm.bridAlgorithm=UnityEngine.PlayerPrefs.GetInt('NewCSMbridAlgorithm', 2)
	csm.birdNum=UnityEngine.PlayerPrefs.GetInt('NewCSMbirdNum',4)

	csm.choiceDouble = UnityEngine.PlayerPrefs.GetInt("NewCSMchoiceDouble", 0)==1
    csm.doubleScore = UnityEngine.PlayerPrefs.GetInt("NewCSMdoubleScore", 10)
    csm.multiple = UnityEngine.PlayerPrefs.GetInt("NewCSMmultiple", 2)
	csm.cappingScore = UnityEngine.PlayerPrefs.GetInt("NewCSMcappingScore", 0)
	
	csm.choiceRegular = UnityEngine.PlayerPrefs.GetInt("NewCSMchoiceRegular", 0)==1
	csm.regularScore = UnityEngine.PlayerPrefs.GetInt("NewCSMregularScore", 1)
	
	csm.missGuoHu = UnityEngine.PlayerPrefs.GetInt("NewCSMmissGuoHu", 0)==1

	csm.openIp=UnityEngine.PlayerPrefs.GetInt('CSMcheckIP', 0)==1
	csm.openGps=UnityEngine.PlayerPrefs.GetInt('CSMcheckGPS', 0)==1
	this.SetPreSetting()
end

function this.SetPreSetting()
	csm.ToggleRound8:GetComponent('UIToggle'):Set(csm.rounds == 8)
	csm.ToggleRound16:GetComponent('UIToggle'):Set(csm.rounds == 16)

	csm.TogglePeopleNum2:GetComponent('UIToggle'):Set(csm.size == 2)
	csm.TogglePeopleNum3:GetComponent('UIToggle'):Set(csm.size == 3)
	csm.TogglePeopleNum4:GetComponent('UIToggle'):Set(csm.size == 4)
	csm.ToggleLessPlayerStart:GetComponent('UIToggle'):Set(csm.minorityMode)

	csm.ToggleMasterPay:GetComponent('UIToggle'):Set(csm.paymentType == 0)
	csm.ToggleWinnerPay:GetComponent('UIToggle'):Set(csm.paymentType == 2)
	
	csm.changshaCustomizeZhuangxian:GetComponent('UIToggle'):Set(csm.bankerAddOne)
	csm.changshaCustomizePiaofen:GetComponent('UIToggle'):Set(csm.floatScore)
	csm.changshaCustomizeTiandihu:GetComponent('UIToggle'):Set(csm.tianDiHu)
	csm.changshaCustomizeQuanqiuren:GetComponent('UIToggle'):Set(csm.quanQiuRen)
	csm.changshaCustomizeMenQing:GetComponent('UIToggle'):Set(csm.menQing)
	csm.changshaCustomizeMenQingZiMo:GetComponent('UIToggle'):Set(csm.menQingZiMo)
	csm.changshaCustomizeMissGuoHu:GetComponent('UIToggle'):Set(csm.missGuoHu)
	csm.ToggleQueYiMen:GetComponent('UIToggle'):Set(csm.queYiMen)
	csm.ToggleQueYiMen.gameObject:SetActive(csm.size == 2 or csm.minorityMode)
	csm.changshaQueyise.gameObject:SetActive(not (csm.ToggleQueYiMen:GetComponent("UIToggle").value and (csm.size == 2 or csm.minorityMode)))
	
	csm.changshaQueyise:GetComponent('UIToggle'):Set(csm.shQueYiSe)
	csm.changshaBanbanhu:GetComponent('UIToggle'):Set(csm.shBanBanHu)
	csm.changshaJiejiegao:GetComponent('UIToggle'):Set(csm.shJieJieGao)
	csm.changshaYizhihua:GetComponent('UIToggle'):Set(csm.shYiZhiHua)
	csm.changshaSantong:GetComponent('UIToggle'):Set(csm.shSanTong)
	csm.changshaJintongyunv:GetComponent('UIToggle'):Set(csm.shJinTongYuNv)
	csm.changshaDasixi:GetComponent('UIToggle'):Set(csm.shDaSiXi)
	csm.changshaLiuliushun:GetComponent('UIToggle'):Set(csm.shLiuLiuShun)
	csm.changshaZhongtudasixi:GetComponent('UIToggle'):Set(csm.ztDaSiXi)
	csm.changshaZhongtuliuliushun:GetComponent('UIToggle'):Set(csm.ztLiuLiuShun)
	
	csm.changshaKaigang2:GetComponent('UIToggle'):Set(csm.gangMahjongCount == 2)
	csm.changshaKaigang4:GetComponent('UIToggle'):Set(csm.gangMahjongCount == 4)

	csm.ToggleWinPos:GetComponent('UIToggle'):Set(csm.birdType == 2)
	csm.Toggle13579Bird:GetComponent('UIToggle'):Set(csm.birdType == 1)
	csm.ToggleNoBird:GetComponent('UIToggle'):Set(csm.birdType == 0)

	csm.changshaCatchBirdDouble:GetComponent('UIToggle'):Set(csm.bridAlgorithm==1)
	csm.changshaCatchBirdYiFen:GetComponent('UIToggle'):Set(csm.bridAlgorithm==2)
	csm.changshaCatchBirdDouble.parent.gameObject:SetActive(csm.birdType~=0)
	
	csm.changshaNiao1:GetComponent('UIToggle'):Set(csm.birdNum==1)
	csm.changshaNiao2:GetComponent('UIToggle'):Set(csm.birdNum==2)
	csm.changshaNiao4:GetComponent('UIToggle'):Set(csm.birdNum==4)
	csm.changshaNiao6:GetComponent('UIToggle'):Set(csm.birdNum==6)
	csm.changshaNiao1.parent.gameObject:SetActive(csm.birdType~=0)

	csm.ToggleRegularScoreOnButton:GetComponent('UIToggle'):Set(csm.choiceRegular)
	csm.ToggleRegularScoreOffButton:GetComponent('UIToggle'):Set(not csm.choiceRegular)
	csm.RegularScoreTxt:GetComponent('UILabel').text = csm.regularScore..'分'
	csm.RegularScoreTxt.parent.gameObject:SetActive(csm.choiceRegular)
	
	csm.ToggleCappingScore0:GetComponent('UIToggle'):Set(csm.cappingScore == 0)
	csm.ToggleCappingScore15:GetComponent('UIToggle'):Set(csm.cappingScore == 15)
	csm.ToggleCappingScore21:GetComponent('UIToggle'):Set(csm.cappingScore == 21)
	csm.ToggleCappingScore42:GetComponent('UIToggle'):Set(csm.cappingScore == 42)

	csm.ToggleChoiceDouble.parent.gameObject:SetActive(csm.size==2 or csm.minorityMode)
    csm.ToggleMultiple2.parent.gameObject:SetActive((csm.size==2 or csm.minorityMode) and csm.choiceDouble)
    
	csm.ToggleMultiple2:GetComponent('UIToggle'):Set(csm.multiple == 2)
	csm.ToggleMultiple3:GetComponent('UIToggle'):Set(csm.multiple == 3)
	csm.ToggleMultiple4:GetComponent('UIToggle'):Set(csm.multiple == 4)
	
	csm.ToggleChoiceDouble:GetComponent('UIToggle'):Set(csm.choiceDouble)
	csm.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not csm.choiceDouble)
	csm.DoubleScoreText.parent.gameObject:SetActive(csm.choiceDouble)
	if csm.doubleScore == 0 then
		csm.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		csm.DoubleScoreText:GetComponent('UILabel').text = '小于'..csm.doubleScore..'分'
	end
	
	csm.ToggleSettlementScoreSelect.parent.gameObject:SetActive(csm.size==2 or csm.minorityMode)
	csm.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(csm.isSettlementScore)
	csm.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	csm.ToggleFewerScoreTxt:GetComponent('UILabel').text = csm.fewerValue
	csm.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	csm.ToggleAddScoreTxt:GetComponent('UILabel').text = csm.addValue

	csm.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(csm.trusteeshipTime == 0)
	csm.ToggleTrusteeship1:GetComponent('UIToggle'):Set(csm.trusteeshipTime == 1)
	csm.ToggleTrusteeship2:GetComponent('UIToggle'):Set(csm.trusteeshipTime == 2)
	csm.ToggleTrusteeship3:GetComponent('UIToggle'):Set(csm.trusteeshipTime == 3)
	csm.ToggleTrusteeship5:GetComponent('UIToggle'):Set(csm.trusteeshipTime == 5)
	csm.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not csm.trusteeshipType and csm.trusteeshipRound ==0)
	csm.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(csm.trusteeshipType)
	csm.ToggleTrusteeshipThree:GetComponent('UIToggle'):Set(csm.trusteeshipRound == 3)
	csm.ToggleTrusteeshipOne.parent.gameObject:SetActive(csm.trusteeshipTime ~= 0)

	csm.ToggleIPcheck.parent.gameObject:SetActive(csm.size > 2 and CONST.IPcheckOn)
	csm.ToggleIPcheck:GetComponent('UIToggle'):Set(csm.openIp)
	csm.ToggleGPScheck:GetComponent('UIToggle'):Set(csm.openGps)
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.CSM,csm.rounds,nil,nil)
	StartCoroutine(function()
		WaitForEndOfFrame()
		CSM:Find('table'):GetComponent('UIGrid'):Reposition()
	end)
end

--获取当前设置
function this.GetConfig()
	local moneyLess = false
    
    if (csm.rounds == 8 and info_login.balance < 2) or
		(csm.rounds == 16 and info_login.balance < 4 ) then
		 moneyLess = true
     end
     
    local body = {}
    body.roomType 				= UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.CSM)
	body.rounds 				= csm.rounds
    body.size 					= csm.size
	body.minorityMode 			= csm.minorityMode
	print('是否发送了少人开局',body.minorityMode)
    body.paymentType 			= csm.paymentType
    body.trusteeship 			= csm.trusteeshipTime*60;
    body.trusteeshipDissolve 	= csm.trusteeshipType;
    body.trusteeshipRound 		= csm.trusteeshipRound;

	if csm.size == 2 or csm.minorityMode then
		body.resultScore = csm.isSettlementScore
		if csm.isSettlementScore then
			body.resultLowerScore=csm.fewerValue
			body.resultAddScore=csm.addValue
		end
		body.choiceDouble = csm.choiceDouble
		body.doubleScore = csm.doubleScore
		body.multiple = csm.multiple
	end
	if csm.choiceRegular then
		body.fixedFloatScore=csm.regularScore
	else
		body.fixedFloatScore=0
	end
    body.bankerAddOne 			= csm.bankerAddOne
    body.floatScore 			= csm.floatScore
    body.tianDiHu 				= csm.tianDiHu
    body.quanQiuRen 			= csm.quanQiuRen
	body.menQing 				= csm.menQing
	if body.menQing then
		body.menQingZiMo 		= csm.menQingZiMo 
	end
	body.queYiMen 				= (csm.size == 2 or csm.minorityMode) and csm.queYiMen or false
	body.shQueYiSe 				= (not body.queYiMen) and csm.shQueYiSe or false
    body.shBanBanHu 			= csm.shBanBanHu
    body.shJieJieGao 			= csm.shJieJieGao
    body.shYiZhiHua 			= csm.shYiZhiHua
    body.shSanTong 				= csm.shSanTong
    body.shJinTongYuNv 			= csm.shJinTongYuNv
    body.shDaSiXi 				= csm.shDaSiXi
    body.shLiuLiuShun 			= csm.shLiuLiuShun
    body.ztDaSiXi 				= csm.ztDaSiXi
    body.ztLiuLiuShun 			= csm.ztLiuLiuShun
	body.gangMahjongCount 		= csm.gangMahjongCount
	
	body.birdWinStart = csm.birdType == 2
	body.bird13579 = csm.birdType == 1
	body.birdCompute = csm.birdType ~= 0 and csm.bridAlgorithm == 1
    body.bird = csm.birdType == 0 and 0 or csm.birdNum
	body.scoreBird = body.birdCompute and 0 or 1

	body.openIp	 = (csm.size == 2) and false or csm.openIp
	body.openGps = (csm.size == 2) and false or csm.openGps
	body.cappingScore = csm.cappingScore

	--body.bird13579 = csm.bird13579
	body.missGuoHu = csm.missGuoHu
    return moneyLess,body;
end

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
    if csm.ToggleRound8.gameObject == go then
        csm.rounds = 8
    elseif csm.ToggleRound16.gameObject == go then
        csm.rounds = 16
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.CSM,csm.rounds,nil,nil)
    UnityEngine.PlayerPrefs.SetInt('NewCSMrounds', csm.rounds)
end

function this.OnClickTogglePlayerNum(go)
    AudioManager.Instance:PlayAudio('btn')
	if csm.TogglePeopleNum2.gameObject == go then
        csm.size = 2
    elseif csm.TogglePeopleNum3.gameObject == go then
        csm.size = 3
    elseif csm.TogglePeopleNum4.gameObject == go then
        csm.size = 4
    end
	csm.ToggleIPcheck.parent.gameObject:SetActive(csm.size > 2 and CONST.IPcheckOn)
	UnityEngine.PlayerPrefs.SetInt('NewCSMsize', csm.size)

	csm.minorityMode=csm.size ~= 2
	csm.ToggleLessPlayerStart:GetComponent("UIToggle"):Set(csm.minorityMode)
	UnityEngine.PlayerPrefs.SetInt('NewCSMminorityMode',csm.minorityMode and 1 or 0)

	csm.ToggleSettlementScoreSelect.parent.gameObject:SetActive(csm.size==2 or csm.minorityMode)
	csm.ToggleChoiceDouble.parent.gameObject:SetActive(csm.size == 2 or csm.minorityMode)
	csm.ToggleMultiple2.parent.gameObject:SetActive((csm.size == 2 or csm.minorityMode) and csm.choiceDouble)
	csm.ToggleQueYiMen.gameObject:SetActive(csm.size == 2 or csm.minorityMode)
	csm.changshaQueyise.gameObject:SetActive(not (csm.ToggleQueYiMen:GetComponent("UIToggle").value and (csm.size == 2 or csm.minorityMode)))
	CSM:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickToggleLessPlayerStart(go)
	AudioManager.Instance:PlayAudio('btn')
	csm.minorityMode=csm.ToggleLessPlayerStart:GetComponent("UIToggle").value
	UnityEngine.PlayerPrefs.SetInt('NewCSMminorityMode',csm.minorityMode and 1 or 0)

	csm.ToggleSettlementScoreSelect.parent.gameObject:SetActive(csm.minorityMode)
	csm.ToggleChoiceDouble.parent.gameObject:SetActive(csm.minorityMode)
	csm.ToggleMultiple2.parent.gameObject:SetActive(csm.minorityMode and csm.choiceDouble)
	csm.ToggleQueYiMen.gameObject:SetActive(csm.minorityMode)
	csm.changshaQueyise.gameObject:SetActive(not (csm.ToggleQueYiMen:GetComponent("UIToggle").value and csm.minorityMode))
	CSM:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if csm.ToggleMasterPay.gameObject == go then
        csm.paymentType=0
    elseif csm.ToggleWinnerPay.gameObject == go then
        csm.paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewCSMpaymentType', csm.paymentType)
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if csm.ToggleTrusteeshipNo.gameObject == go then
        csm.trusteeshipTime = 0
    elseif csm.ToggleTrusteeship1.gameObject == go then
        csm.trusteeshipTime = 1
	elseif csm.ToggleTrusteeship2.gameObject == go then
		csm.trusteeshipTime = 2
    elseif csm.ToggleTrusteeship3.gameObject == go then
        csm.trusteeshipTime = 3
    elseif csm.ToggleTrusteeship5.gameObject == go then
        csm.trusteeshipTime = 5
    end
    UnityEngine.PlayerPrefs.SetInt('NewCSMtrusteeshipTime', csm.trusteeshipTime)
    csm.ToggleTrusteeshipOne.parent.gameObject:SetActive(csm.trusteeshipTime ~= 0)
	CSM:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if csm.ToggleTrusteeshipOne.gameObject == go then
        csm.trusteeshipType = true;
		csm.trusteeshipRound = 0;
    elseif csm.ToggleTrusteeshipAll.gameObject == go then
        csm.trusteeshipType = false;
		csm.trusteeshipRound = 0;
	elseif csm.ToggleTrusteeshipThree.gameObject == go then
		csm.trusteeshipRound = 3;
		csm.trusteeshipType = false;
    end
    UnityEngine.PlayerPrefs.SetInt('NewCSMtrusteeshipType',csm.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewCSMtrusteeshipRound',csm.trusteeshipRound);
end

function this.OnClickToggleNiaoType(go)
	AudioManager.Instance:PlayAudio('btn')
	if csm.ToggleWinPos.gameObject == go then
		csm.birdType = 2
	elseif csm.Toggle13579Bird.gameObject == go then
		csm.birdType = 1
	elseif csm.ToggleNoBird.gameObject == go then
		csm.birdType = 0
	end
	UnityEngine.PlayerPrefs.SetInt('NewCSMbirdType',csm.birdType)
	csm.changshaNiao1.parent.gameObject:SetActive(csm.birdType~=0)
	csm.changshaCatchBirdDouble.parent.gameObject:SetActive(csm.birdType~=0)
	CSM:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePiaoFen(go)  --飘分
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		csm.ToggleRegularScoreOffButton:GetComponent('UIToggle'):Set(true)
		csm.ToggleRegularScoreOnButton:GetComponent('UIToggle'):Set(false)
		csm.choiceRegular = false
		UnityEngine.PlayerPrefs.SetInt('NewCSMchoiceRegular', 0)
		csm.RegularScoreTxt.parent.gameObject:SetActive(false)
        csm.floatScore = true
    else
        csm.floatScore = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewCSMfloatScore', csm.floatScore and 1 or 0)
end

function this.OnClickToggleZhuangxian(go)
	if go:GetComponent('UIToggle').value == true then
		csm.bankerAddOne = true
	else
		csm.bankerAddOne = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewCSMbankerAddOne', csm.bankerAddOne and 1 or 0)
end

function this.OnClickToggleTiandihu(go)
	if go:GetComponent('UIToggle').value == true then
		csm.tianDiHu = true
	else
		csm.tianDiHu = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewCSMtianDiHu', csm.tianDiHu and 1 or 0)
end

function this.OnClickToggleQuanQiuRen(go)
	if go:GetComponent("UIToggle").value == true then
		csm.quanQiuRen = true;
	else
		csm.quanQiuRen = false;
	end
	UnityEngine.PlayerPrefs.SetInt('NewCSMquanQiuren', csm.quanQiuRen and 1 or 0);
end

function this.OnClickToggleMenQing(go)
	if go:GetComponent("UIToggle").value == true then
		csm.menQing = true;
	else
		csm.menQing = false;
	end
	UnityEngine.PlayerPrefs.SetInt('NewCSMmenQing', csm.menQing and 1 or 0);
	CSM:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickToggleMenQingZiMo(go)
	if go:GetComponent("UIToggle").value == true then
		csm.menQingZiMo = true;
	else
		csm.menQingZiMo = false;
	end
	UnityEngine.PlayerPrefs.SetInt('NewCSMmenQingZiMo', csm.menQingZiMo and 1 or 0);
end


function this.OnClickToggleMissHu(go)
	if go:GetComponent("UIToggle").value == true then
		csm.missGuoHu = true;
	else
		csm.missGuoHu = false;
	end
	UnityEngine.PlayerPrefs.SetInt('NewCSMmissGuoHu', csm.missGuoHu and 1 or 0);
end

function this.OnClickQueYiMen(go)
	if go:GetComponent("UIToggle").value == true then
		csm.queYiMen = true;
	else
		csm.queYiMen = false;
	end
	csm.changshaQueyise.gameObject:SetActive(not csm.queYiMen)
	UnityEngine.PlayerPrefs.SetInt('NewCSMqueYiMen', csm.queYiMen and 1 or 0);
end

function this.OnClickToggleQueyise(go)
	if go:GetComponent('UIToggle').value == true then
		csm.shQueYiSe = true
	else
		csm.shQueYiSe = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewCSMshQueYiSe', csm.shQueYiSe and 1 or 0)
end

function this.OnClickToggleBanbanhu(go)
	if go:GetComponent('UIToggle').value == true then
		csm.shBanBanHu = true
	else
		csm.shBanBanHu = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewCSMshBanBanHu', csm.shBanBanHu and 1 or 0)
end

function this.OnClickToggleJiejiegao(go)
	if go:GetComponent('UIToggle').value == true then
		csm.shJieJieGao = true
	else
		csm.shJieJieGao = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewCSMshJieJieGao', csm.shJieJieGao and 1 or 0)
end
function this.OnClickToggleYizhihua(go)
	if go:GetComponent('UIToggle').value == true then
		csm.shYiZhiHua = true
	else
		csm.shYiZhiHua = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewCSMshYiZhiHua', csm.shYiZhiHua and 1 or 0)
end
function this.OnClickToggleSantong(go)
	if go:GetComponent('UIToggle').value == true then
		csm.shSanTong = true
	else
		csm.shSanTong = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewCSMshSanTong', csm.shSanTong and 1 or 0)
end
function this.OnClickToggleJintongyunv(go)
	if go:GetComponent('UIToggle').value == true then
		csm.shJinTongYuNv = true
	else
		csm.shJinTongYuNv = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewCSMshJinTongYuNv', csm.shJinTongYuNv and 1 or 0)
end
function this.OnClickToggleDasixi(go)
	if go:GetComponent('UIToggle').value == true then
		csm.shDaSiXi = true
	else
		csm.shDaSiXi = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewCSMshDaSiXi', csm.shDaSiXi and 1 or 0)
end
function this.OnClickToggleLiuliushun(go)
	if go:GetComponent('UIToggle').value == true then
		csm.shLiuLiuShun = true
	else
		csm.shLiuLiuShun = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewCSMshLiuLiuShun', csm.shLiuLiuShun and 1 or 0)
end
function this.OnClickToggleZhongtudasixi(go)
	if go:GetComponent('UIToggle').value == true then
		csm.ztDaSiXi = true
	else
		csm.ztDaSiXi = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewCSMztDaSiXi', csm.ztDaSiXi and 1 or 0)
end
function this.OnClickToggleZhongtuliuliushun(go)
	if go:GetComponent('UIToggle').value == true then
		csm.ztLiuLiuShun = true
	else
		csm.ztLiuLiuShun = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewCSMztLiuLiuShun', csm.ztLiuLiuShun and 1 or 0)
end
function this.OnClickToggleKaigang(go)
	if csm.changshaKaigang2.gameObject == go then
		csm.gangMahjongCount = 2
	elseif csm.changshaKaigang4.gameObject == go then
		csm.gangMahjongCount = 4
	end
	UnityEngine.PlayerPrefs.SetInt("NewCSMgangMahjongCount",csm.gangMahjongCount);
end

function this.OnClickButtonZhuaNiaoCSM(go)
	if csm.changshaCatchBirdDouble.gameObject == go then
		csm.bridAlgorithm  = 1
	elseif csm.changshaCatchBirdYiFen.gameObject == go then
		csm.bridAlgorithm = 2
	end
	UnityEngine.PlayerPrefs.SetInt("NewCSMbridAlgorithm",csm.bridAlgorithm)
end

function this.OnClickButtonNiaoNumCSM(go)
	if csm.changshaNiao1.gameObject == go then
		csm.birdNum = 1
	elseif csm.changshaNiao2.gameObject == go then
		csm.birdNum = 2
	elseif csm.changshaNiao4.gameObject == go then
		csm.birdNum = 4
	elseif csm.changshaNiao6.gameObject == go then
		csm.birdNum = 6
	end
	UnityEngine.PlayerPrefs.SetInt("NewCSMbirdNum",csm.birdNum);
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    csm.isSettlementScore= csm.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewCSMisSettlementScore', csm.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if csm.ToggleFewerAddButton.gameObject == go then
		csm.fewerValue = csm.fewerValue + 1
		if csm.fewerValue > 100 then
			csm.fewerValue = 100
		end
    elseif csm.ToggleFewerSubtractButton.gameObject == go then
		csm.fewerValue = csm.fewerValue - 1
		if csm.fewerValue < 1 then
			csm.fewerValue = 1
		end
	end
	csm.ToggleFewerScoreTxt:GetComponent('UILabel').text = csm.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewCSMfewerValue', csm.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if csm.ToggleAddAddButton.gameObject == go then
		csm.addValue = csm.addValue + 1
		if csm.addValue > 100 then
			csm.addValue = 100
		end
    elseif csm.ToggleAddSubtractButton.gameObject == go then
		csm.addValue = csm.addValue - 1
		if csm.addValue < 1 then
			csm.addValue = 1
		end
	end
	csm.ToggleAddScoreTxt:GetComponent('UILabel').text = csm.addValue
	UnityEngine.PlayerPrefs.SetInt('NewCSMaddValue', csm.addValue)
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if csm.ToggleIPcheck.gameObject == go then
		csm.openIp = csm.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('CSMcheckIP', csm.openIp and 1 or 0)
	elseif csm.ToggleGPScheck.gameObject == go then
		csm.openGps = csm.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('CSMcheckGPS', csm.openGps and 1 or 0)
	end
end
function this.OnClickChoiceDouble(go)
    AudioManager.Instance:PlayAudio('btn')
	if csm.ToggleChoiceDouble.gameObject == go then
		csm.choiceDouble = true
	else
		csm.choiceDouble = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewCSMchoiceDouble', csm.choiceDouble and 1 or 0)
	csm.DoubleScoreText.parent.gameObject:SetActive(csm.choiceDouble)
	csm.ToggleMultiple2.parent.gameObject:SetActive(csm.choiceDouble)
	if csm.choiceDouble then
		csm.ToggleMultiple2:GetComponent('UIToggle'):Set(csm.multiple == 2)
		csm.ToggleMultiple3:GetComponent('UIToggle'):Set(csm.multiple == 3)
		csm.ToggleMultiple4:GetComponent('UIToggle'):Set(csm.multiple == 4)
	end
    CSM:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickChangeDoubleScore(go)
    AudioManager.Instance:PlayAudio('btn')
    local label_= csm.DoubleScoreText:GetComponent('UILabel').text
    if label_=='不限分' then
        csm.doubleScore=0
    else
        csm.doubleScore=tonumber(string.sub(label_,7,-4))    
    end
	if csm.AddDoubleScoreButton.gameObject == go then
		if csm.doubleScore ~= 0 then
			csm.doubleScore = csm.doubleScore + 1
			if csm.doubleScore > 100 then
				csm.doubleScore = 0
			end
		end
	else
		if csm.doubleScore == 0 then
			csm.doubleScore = 100
		else
			csm.doubleScore = csm.doubleScore - 1
			if csm.doubleScore < 1 then
				csm.doubleScore = 1
			end
		end
	end

	if csm.doubleScore == 0 then
		csm.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		csm.DoubleScoreText:GetComponent('UILabel').text = '小于'..csm.doubleScore..'分'
	end
	UnityEngine.PlayerPrefs.SetInt('NewCSMdoubleScore', csm.doubleScore)
end

function this.OnClickRegularScore(go)
    AudioManager.Instance:PlayAudio('btn')
	if csm.ToggleRegularScoreOnButton.gameObject == go then
		csm.changshaCustomizePiaofen:GetComponent('UIToggle'):Set(false)
		csm.floatScore = false
    	UnityEngine.PlayerPrefs.SetInt('NewCSMfloatScore', 0)
		csm.choiceRegular = true
	else
		csm.choiceRegular = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewCSMchoiceRegular', csm.choiceRegular and 1 or 0)
	csm.RegularScoreTxt.parent.gameObject:SetActive(csm.choiceRegular)
end

function this.OnClickChangeRegularScore(go)
    AudioManager.Instance:PlayAudio('btn')
    local label_= csm.RegularScoreTxt:GetComponent('UILabel').text
    csm.regularScore=tonumber(string.sub(label_,1,-4))
	if csm.RegularAddButton.gameObject == go then
		csm.regularScore = csm.regularScore + 1
		if csm.regularScore > 10 then
			csm.regularScore = 1
		end
	else
		csm.regularScore = csm.regularScore - 1
		if csm.regularScore < 1 then
			csm.regularScore = 10
		end
	end

	csm.RegularScoreTxt:GetComponent('UILabel').text = csm.regularScore..'分'
	UnityEngine.PlayerPrefs.SetInt('NewCSMregularScore', csm.regularScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
	csm.multiple = tonumber(go.name)
	print('倍数：'..csm.multiple)
	UnityEngine.PlayerPrefs.SetInt('NewCSMmultiple', csm.multiple)
end

function this.OnClickToggleCappingScoreCSM(go)
	AudioManager.Instance:PlayAudio('btn')
	csm.cappingScore = tonumber(go.name)
	print('封顶：'..csm.cappingScore)
	UnityEngine.PlayerPrefs.SetInt('NewCSMcappingScore', csm.cappingScore)
end
return this