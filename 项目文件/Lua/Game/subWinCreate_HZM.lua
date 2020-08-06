local this = {}

local HZM
local payLabel

local hzm = {
	rounds=8, -- 局数
	size=2,--人数
	minorityMode=false,--true开启了少人模式，false未开启少人模式（默认false）
	paymentType=0, --支付类型
	trusteeshipTime=0,--0不托管，1托管1分钟，3托管3分钟，5托管5分钟
	trusteeshipType=true,--false满局结算，true本局结算
	trusteeshipRound = 0,--3局解散

	dianpaohu=false,
	zhuangxianfen=false,
	kehuqidui=false,
	youhubihu=false,
	piaofen=false,
	nohongzhongdouble=false,
	scoreHongZhongNonNiaoBanker=false,
	huangzhuanggang=false,
	youhongzhongnopao=false,

	birdType=0,--0不抓鸟，2 159抓鸟，3庄家方位，4赢家方位，1一鸟全中
	birdNum=2,
	birdscore=1,

	HongZhongNum=4,
	GangMoPaoNo=0,--0无，1抢杠算自摸，2抢杠算点炮

	QiangGangQuanBao=false,
	HongzhongQiangGang=false,

	isSettlementScore=false,
	fewerValue=10,
	addValue=10,

	choiceDouble = false,
	doubleScore = 10,
	multiple = 2,
	baseScore = 1,
	scoreMingGangInc = false,

	ToggleRound8=nil,--10局
	ToggleRound16=nil,--16局

	TogglePeopleNum2=nil,--2人
	TogglePeopleNum3=nil,--3人
	TogglePeopleNum4=nil,--3人
	ToggleLessPlayerStart=nil,--可少人开局

	ToggleMasterPay=nil, -- 房主支付  
	ToggleWinnerPay=nil, -- 赢家支付 

	ToggleTrusteeshipNo=nil,--不托管
	ToggleTrusteeship1=nil,--托管1分钟
	ToggleTrusteeship2=nil,--托管1分钟
	ToggleTrusteeship3=nil,--托管3分钟
	ToggleTrusteeship5=nil,--托管4分钟

	ToggleTrusteeshipOne=nil,--本局结算
	ToggleTrusteeshipAll=nil,--满局结算
	ToggleTrusteeshipThree=nil,--3局结算
	
	ToggleIPcheck=nil,		--防作弊，IP检测
	ToggleGPScheck=nil,		--防作弊，GPS检测

	ToggleDianPaoHu=nil,
	ToggleZhuangXianFen=nil,
	ToggleKeHuQiDui=nil,
	ToggleYouHuBiHu=nil,
	TogglePiaoFen=nil,
	ToggleNoHongZhongDouble=nil,
	ToggleAllDouble=nil,
	ToggleHuangZhuangGang=nil,
	ToggleYouHongZhongNoPao=nil,
	ToggleScoreGangInc=nil,

	ToggleHit159Niao=nil,
	ToggleDealerNiao=nil,
	ToggleWinNiao=nil,
	ToggleAllNiao=nil,
	ToggleNoNiao=nil,
	ToggleNiao2=nil,
	ToggleNiao4=nil,
	ToggleNiao6=nil,
	ToggleNiao1Score=nil,
	ToggleNiao2Score=nil,

	ToggleHongZhong4=nil,
	ToggleHongZhong8=nil,

	ToggleGangMo=nil,
	ToggleGangPao=nil,
	ToggleGangNothing=nil,

	ToggleQiangGangQuanBao=nil,
	ToggleHongzhongQiangGang=nil,

	ToggleSettlementScoreSelect=nil,
	ToggleFewerScoreTxt=nil,
	ToggleFewerAddButton=nil,
	ToggleFewerSubtractButton=nil,
	ToggleAddScoreTxt=nil,
	ToggleAddAddButton=nil,
	ToggleAddSubtractButton=nil,

	ToggleMultiple2=nil,
	ToggleMultiple3=nil,
	ToggleMultiple4=nil,

	ToggleChoiceDouble=nil,
	ToggleNoChoiceDouble=nil,
	DoubleScoreText=nil,
	AddDoubleScoreButton=nil,
	SubtractDoubleScoreButton=nil,

	AddBtnDiFen = nil,
	SubtractBtnDiFen = nil,
	DiFenTunValue = nil,
}

function this.Init(grid,message)
	print('Init_HZM')
	HZM = grid
    payLabel = message.transform:Find('diamond/pay_label')
    
    hzm.ToggleRound8 = HZM:Find("table/ToggleRound/ToggleRound8");
    hzm.ToggleRound16 = HZM:Find("table/ToggleRound/ToggleRound16");
    hzm.TogglePeopleNum2 = HZM:Find("table/TogglePeople/Toggle2P");
    hzm.TogglePeopleNum3 = HZM:Find("table/TogglePeople/Toggle3P");
    hzm.TogglePeopleNum4 = HZM:Find("table/TogglePeople/Toggle4P");
	hzm.ToggleLessPlayerStart = HZM:Find("table/TogglePeople/lessPlayerStart");
	hzm.ToggleMasterPay = HZM:Find("table/TogglePayType/ToggleMasterPay");
	hzm.ToggleWinnerPay = HZM:Find("table/TogglePayType/ToggleWinnerPay");
	hzm.ToggleTrusteeshipNo = HZM:Find('table/DelegateChoose/NoDelegate')
	hzm.ToggleTrusteeship1 = HZM:Find('table/DelegateChoose/Delegate1')
	hzm.ToggleTrusteeship2 = HZM:Find('table/DelegateChoose/Delegate2')
	hzm.ToggleTrusteeship3 = HZM:Find('table/DelegateChoose/Delegate3')
	hzm.ToggleTrusteeship5 = HZM:Find('table/DelegateChoose/Delegate5')
	hzm.ToggleTrusteeshipAll = HZM:Find('table/DelegateCancel/FullRound')
	hzm.ToggleTrusteeshipOne = HZM:Find('table/DelegateCancel/ThisRound')
	hzm.ToggleTrusteeshipThree = HZM:Find('table/DelegateCancel/ThreeRound')

	hzm.ToggleDianPaoHu = HZM:Find('table/ToggleCapping/DianPaoHu')
	hzm.ToggleZhuangXianFen = HZM:Find('table/ToggleCapping/ZhuangShuYing')
	hzm.ToggleKeHuQiDui = HZM:Find('table/ToggleCapping/KeHuQiDui')
	hzm.ToggleYouHuBiHu = HZM:Find('table/ToggleCapping/YouHuBiHu')
	hzm.TogglePiaoFen = HZM:Find('table/ToggleCapping/PiaoFen')
	hzm.ToggleNoHongZhongDouble = HZM:Find('table/ToggleCapping/HongzhongDouble')
	hzm.ToggleAllDouble = HZM:Find('table/ToggleCapping/AllDouble')
	hzm.ToggleHuangZhuangGang = HZM:Find('table/ToggleCapping/HuangZhuangHuangGang')
	hzm.ToggleYouHongZhongNoPao = HZM:Find('table/ToggleCapping/YouHongZhongNoPao')

	hzm.ToggleHit159Niao = HZM:Find('table/ToggleNiaoType/hit159Niao')
	hzm.ToggleDealerNiao = HZM:Find('table/ToggleNiaoType/dealerNiao')
	hzm.ToggleWinNiao = HZM:Find('table/ToggleNiaoType/winNiao')
	hzm.ToggleAllNiao = HZM:Find('table/ToggleNiaoType/AllNiao')
	hzm.ToggleNoNiao = HZM:Find('table/ToggleNiaoType/NoNiao')

	hzm.ToggleNiao2 = HZM:Find('table/ToggleNiaoNum/Niao2')
	hzm.ToggleNiao4 = HZM:Find('table/ToggleNiaoNum/Niao4')
	hzm.ToggleNiao6 = HZM:Find('table/ToggleNiaoNum/Niao6')

	hzm.ToggleNiao1Score = HZM:Find('table/ToggleNiaoScore/Niao1Score')
	hzm.ToggleNiao2Score = HZM:Find('table/ToggleNiaoScore/Niao2Score')

	hzm.ToggleHongZhong4 = HZM:Find('table/ToggleHongZhongChoose/HongZhong4')
	hzm.ToggleHongZhong8 = HZM:Find('table/ToggleHongZhongChoose/HongZhong8')

	hzm.ToggleGangMo = HZM:Find('table/ToggleCatchGang/GangMo')
	hzm.ToggleGangPao = HZM:Find('table/ToggleCatchGang/GangPao')
	hzm.ToggleGangNothing = HZM:Find('table/ToggleCatchGang/Nothing')

	hzm.ToggleQiangGangQuanBao = HZM:Find('table/ToggleCatchGang/GangQuanBao')
	hzm.ToggleHongzhongQiangGang = HZM:Find('table/ToggleCatchGang/HongzhongQiangGang')

	hzm.ToggleSettlementScoreSelect=HZM:Find('table/settlementScore/select')
	hzm.ToggleFewerScoreTxt=HZM:Find('table/settlementScore/fewerValue/Value')
	hzm.ToggleFewerAddButton=HZM:Find('table/settlementScore/fewerValue/AddButton')
	hzm.ToggleFewerSubtractButton=HZM:Find('table/settlementScore/fewerValue/SubtractButton')
	hzm.ToggleAddScoreTxt=HZM:Find('table/settlementScore/addValue/Value')
	hzm.ToggleAddAddButton=HZM:Find('table/settlementScore/addValue/AddButton')
	hzm.ToggleAddSubtractButton=HZM:Find('table/settlementScore/addValue/SubtractButton')
	
	hzm.ToggleIPcheck = HZM:Find('table/PreventCheat/IPcheck')
	hzm.ToggleGPScheck = HZM:Find('table/PreventCheat/GPScheck')

	hzm.ToggleMultiple2 = HZM:Find('table/multiple/2')
	hzm.ToggleMultiple3 = HZM:Find('table/multiple/3')
	hzm.ToggleMultiple4 = HZM:Find('table/multiple/4')

	hzm.ToggleChoiceDouble  = HZM:Find('table/choiceDouble/On')
	hzm.ToggleNoChoiceDouble = HZM:Find('table/choiceDouble/Off')
	hzm.DoubleScoreText = HZM:Find('table/choiceDouble/doubleScore/Value')
	hzm.AddDoubleScoreButton = HZM:Find('table/choiceDouble/doubleScore/AddButton')
	hzm.SubtractDoubleScoreButton = HZM:Find('table/choiceDouble/doubleScore/SubtractButton')

	message:AddClick(hzm.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(hzm.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(hzm.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(hzm.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)

	message:AddClick(hzm.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(hzm.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(hzm.ToggleMultiple4.gameObject, this.OnClickMultiple)

	message:AddClick(hzm.ToggleRound8.gameObject, this.OnClickToggleRound)
	message:AddClick(hzm.ToggleRound16.gameObject, this.OnClickToggleRound)

	message:AddClick(hzm.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(hzm.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(hzm.TogglePeopleNum4.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(hzm.ToggleLessPlayerStart.gameObject, this.OnClickToggleLessPlayerStart)

	message:AddClick(hzm.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(hzm.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)

	message:AddClick(hzm.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(hzm.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(hzm.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(hzm.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(hzm.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(hzm.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(hzm.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(hzm.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)

	message:AddClick(hzm.ToggleDianPaoHu.gameObject, this.OnClickToggleDianPaoHu)
	message:AddClick(hzm.ToggleZhuangXianFen.gameObject, this.OnClickToggleZhuangXianFen)
	message:AddClick(hzm.ToggleKeHuQiDui.gameObject, this.OnClickToggleKeHuQiDui)
	message:AddClick(hzm.ToggleYouHuBiHu.gameObject, this.OnClickToggleYouHuBiHu)
	message:AddClick(hzm.TogglePiaoFen.gameObject, this.OnClickTogglePiaoFen)
	message:AddClick(hzm.ToggleNoHongZhongDouble.gameObject, this.OnClickToggleNoHongZhongDouble)
	message:AddClick(hzm.ToggleAllDouble.gameObject, this.OnClickToggleAllDouble)
	message:AddClick(hzm.ToggleHuangZhuangGang.gameObject, this.OnClickToggleHuangZhuangGang)
	message:AddClick(hzm.ToggleYouHongZhongNoPao.gameObject, this.OnClickToggleYouHongZhongNoPao)

	message:AddClick(hzm.ToggleHit159Niao.gameObject, this.OnClickToggleNiaoTypeHZM)
	message:AddClick(hzm.ToggleDealerNiao.gameObject, this.OnClickToggleNiaoTypeHZM)
	message:AddClick(hzm.ToggleWinNiao.gameObject, this.OnClickToggleNiaoTypeHZM)
	message:AddClick(hzm.ToggleAllNiao.gameObject, this.OnClickToggleNiaoTypeHZM)
	message:AddClick(hzm.ToggleNoNiao.gameObject, this.OnClickToggleNiaoTypeHZM)

	message:AddClick(hzm.ToggleNiao2.gameObject, this.OnClickToggleNiaoNumHZM)
	message:AddClick(hzm.ToggleNiao4.gameObject, this.OnClickToggleNiaoNumHZM)
	message:AddClick(hzm.ToggleNiao6.gameObject, this.OnClickToggleNiaoNumHZM)

	message:AddClick(hzm.ToggleNiao1Score.gameObject, this.OnClickToggleNiaoScoreHZM)
	message:AddClick(hzm.ToggleNiao2Score.gameObject, this.OnClickToggleNiaoScoreHZM)

	message:AddClick(hzm.ToggleHongZhong4.gameObject, this.OnClickToggleHongZhongNum)
	message:AddClick(hzm.ToggleHongZhong8.gameObject, this.OnClickToggleHongZhongNum)
	
	message:AddClick(hzm.ToggleGangMo.gameObject, this.OnClickToggleToggleGangMoPaoNo)
	message:AddClick(hzm.ToggleGangPao.gameObject, this.OnClickToggleToggleGangMoPaoNo)
	message:AddClick(hzm.ToggleGangNothing.gameObject, this.OnClickToggleToggleGangMoPaoNo)

	message:AddClick(hzm.ToggleQiangGangQuanBao.gameObject, this.OnClickToggleQiangGangQuanBao)
	message:AddClick(hzm.ToggleHongzhongQiangGang.gameObject, this.OnClickToggleHongzhongQiangGang)

	message:AddClick(hzm.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(hzm.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(hzm.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(hzm.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(hzm.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)
	
	message:AddClick(hzm.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(hzm.ToggleGPScheck.gameObject, this.OnClickPreventCheat)

	hzm.AddBtnDiFen = HZM:Find('table/diFen/diFenScore/AddButton')
	hzm.SubtractBtnDiFen = HZM:Find('table/diFen/diFenScore/SubtractButton')
	hzm.DiFenTunValue = HZM:Find('table/diFen/diFenScore/Value')
	message:AddClick(hzm.AddBtnDiFen.gameObject, this.OnClickChangeDiFenValue)
	message:AddClick(hzm.SubtractBtnDiFen.gameObject, this.OnClickChangeDiFenValue)

	hzm.ToggleScoreGangInc = HZM:Find('table/dianGangSuanFen3/scoreGangInc')
	message:AddClick(hzm.ToggleScoreGangInc.gameObject, this.OnClickToggleScoreGangInc)
end
function this.Refresh()
	print('Refresh_HZM')
	hzm.rounds = UnityEngine.PlayerPrefs.GetInt('NewHZMrounds', 8)
	hzm.size = UnityEngine.PlayerPrefs.GetInt('NewHZMsize', 2)
	hzm.minorityMode=UnityEngine.PlayerPrefs.GetInt('NewHZMminorityMode', 0)==1
	hzm.paymentType = UnityEngine.PlayerPrefs.GetInt('NewHZMpaymentType', 0)
	hzm.trusteeshipTime=UnityEngine.PlayerPrefs.GetInt('NewHZMtrusteeshipTime', 0)
	hzm.trusteeshipType=UnityEngine.PlayerPrefs.GetInt('NewHZMtrusteeshipType', 0)==1
	hzm.trusteeshipRound=UnityEngine.PlayerPrefs.GetInt('NewHZMtrusteeshipRound', 0)

	hzm.dianpaohu=UnityEngine.PlayerPrefs.GetInt('NewHZMdianpaohu', 0)==1
	hzm.zhuangxianfen=UnityEngine.PlayerPrefs.GetInt('NewHZMzhuangxianfen', 0)==1
	hzm.kehuqidui=UnityEngine.PlayerPrefs.GetInt('NewHZMkehuqidui', 0)==1
	hzm.youhubihu=UnityEngine.PlayerPrefs.GetInt('NewHZMyouhubihu', 0)==1
	hzm.piaofen=UnityEngine.PlayerPrefs.GetInt('NewHZMpiaofen', 0)==1
	hzm.nohongzhongdouble=UnityEngine.PlayerPrefs.GetInt('NewHZMnohongzhongdouble', 0)==1
	hzm.scoreHongZhongNonNiaoBanker=UnityEngine.PlayerPrefs.GetInt('NewHZMallDouble', 0)==1
	hzm.huangzhuanggang=UnityEngine.PlayerPrefs.GetInt('NewHZMhuangzhuanggang', 0)==1
	hzm.youhongzhongnopao=UnityEngine.PlayerPrefs.GetInt('NewHZMyouhongzhongnopao', 0)==1

	hzm.birdType = UnityEngine.PlayerPrefs.GetInt('NewHZMbirdType', 0)
	hzm.birdNum = UnityEngine.PlayerPrefs.GetInt('NewHZMbirdNum', 2)
	hzm.birdscore = UnityEngine.PlayerPrefs.GetInt('NewHZMbirdscore', 1)

	hzm.HongZhongNum = UnityEngine.PlayerPrefs.GetInt('NewHZMHongZhongNum', 4)
	hzm.GangMoPaoNo = UnityEngine.PlayerPrefs.GetInt('NewHZMGangMoPaoNo', 0)

	hzm.QiangGangQuanBao = UnityEngine.PlayerPrefs.GetInt('NewHZMQiangGangQuanBao', 0)==1
	hzm.HongzhongQiangGang = UnityEngine.PlayerPrefs.GetInt('NewHZMHongzhongQiangGang', 0)==1

	hzm.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewHZMisSettlementScore', 0)==1
	hzm.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewHZMfewerValue', 10)
	hzm.addValue=UnityEngine.PlayerPrefs.GetInt('NewHZMaddValue', 10)

	hzm.openIp=UnityEngine.PlayerPrefs.GetInt('HZMcheckIP', 0)==1
	hzm.openGps=UnityEngine.PlayerPrefs.GetInt('HZMcheckGPS', 0)==1

	hzm.choiceDouble = UnityEngine.PlayerPrefs.GetInt("NewHZMchoiceDouble", 0)==1
    hzm.doubleScore = UnityEngine.PlayerPrefs.GetInt("NewHZMdoubleScore", 10)
    hzm.multiple = UnityEngine.PlayerPrefs.GetInt("NewHZMmultiple", 2)

	hzm.baseScore=UnityEngine.PlayerPrefs.GetInt('NewHZMbaseScore', 1)
	hzm.scoreMingGangInc=UnityEngine.PlayerPrefs.GetInt('NewHZMscoreMingGangInc', 0)==1
	this.SetPreSetting()
end

function this.SetPreSetting()
	this.SetSubSetting1()
	hzm.ToggleHit159Niao:GetComponent('UIToggle'):Set(hzm.birdType == 2)
	hzm.ToggleDealerNiao:GetComponent('UIToggle'):Set(hzm.birdType == 3)
	hzm.ToggleWinNiao:GetComponent('UIToggle'):Set(hzm.birdType == 4)
	hzm.ToggleAllNiao:GetComponent('UIToggle'):Set(hzm.birdType == 1)
	hzm.ToggleNoNiao:GetComponent('UIToggle'):Set(hzm.birdType == 0)

	hzm.ToggleNiao2:GetComponent('UIToggle'):Set(hzm.birdType ~= 0 and hzm.birdType ~= 1 and hzm.birdNum == 2)
	hzm.ToggleNiao4:GetComponent('UIToggle'):Set(hzm.birdType ~= 0 and hzm.birdType ~= 1 and hzm.birdNum == 4)
	hzm.ToggleNiao6:GetComponent('UIToggle'):Set(hzm.birdType ~= 0 and hzm.birdType ~= 1 and hzm.birdNum == 6)

	hzm.ToggleNiao2:GetComponent("BoxCollider").enabled = (hzm.birdType ~= 0 and hzm.birdType ~= 1)
	hzm.ToggleNiao4:GetComponent("BoxCollider").enabled = (hzm.birdType ~= 0 and hzm.birdType ~= 1)
	hzm.ToggleNiao6:GetComponent("BoxCollider").enabled = (hzm.birdType ~= 0 and hzm.birdType ~= 1)

	hzm.ToggleNiao1Score:GetComponent('UIToggle'):Set(hzm.birdType ~= 0 and hzm.birdscore == 1)
	hzm.ToggleNiao2Score:GetComponent('UIToggle'):Set(hzm.birdType ~= 0 and hzm.birdscore == 2)

	hzm.ToggleNiao1Score:GetComponent("BoxCollider").enabled = hzm.birdType ~= 0
	hzm.ToggleNiao2Score:GetComponent("BoxCollider").enabled = hzm.birdType ~= 0

	hzm.ToggleHongZhong4:GetComponent('UIToggle'):Set(hzm.HongZhongNum == 4)
	hzm.ToggleHongZhong8:GetComponent('UIToggle'):Set(hzm.HongZhongNum == 8)

	hzm.ToggleGangNothing:GetComponent('UIToggle'):Set(hzm.GangMoPaoNo == 0)
	hzm.ToggleGangMo:GetComponent('UIToggle'):Set(hzm.GangMoPaoNo == 1)
	hzm.ToggleGangPao:GetComponent('UIToggle'):Set(hzm.GangMoPaoNo == 2)

	hzm.ToggleQiangGangQuanBao:GetComponent('UIToggle'):Set(hzm.QiangGangQuanBao)
	hzm.ToggleHongzhongQiangGang:GetComponent('UIToggle'):Set(hzm.HongzhongQiangGang)
	hzm.ToggleQiangGangQuanBao.gameObject:SetActive(hzm.GangMoPaoNo==1)
	hzm.ToggleHongzhongQiangGang.gameObject:SetActive(hzm.GangMoPaoNo == 2)

	hzm.ToggleIPcheck.parent.gameObject:SetActive(hzm.size > 2 and CONST.IPcheckOn)
	hzm.ToggleSettlementScoreSelect.parent.gameObject:SetActive(hzm.size==2 or hzm.minorityMode)
	hzm.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(hzm.isSettlementScore)
	hzm.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	hzm.ToggleFewerScoreTxt:GetComponent('UILabel').text = hzm.fewerValue
	hzm.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	hzm.ToggleAddScoreTxt:GetComponent('UILabel').text = hzm.addValue
	
	hzm.ToggleIPcheck:GetComponent('UIToggle'):Set(hzm.openIp)
	hzm.ToggleGPScheck:GetComponent('UIToggle'):Set(hzm.openGps)

	hzm.ToggleChoiceDouble.parent.gameObject:SetActive(hzm.size==2 or hzm.minorityMode)
    hzm.ToggleMultiple2.parent.gameObject:SetActive((hzm.size==2 or hzm.minorityMode) and hzm.choiceDouble)
    
	hzm.ToggleMultiple2:GetComponent('UIToggle'):Set(hzm.multiple == 2)
	hzm.ToggleMultiple3:GetComponent('UIToggle'):Set(hzm.multiple == 3)
	hzm.ToggleMultiple4:GetComponent('UIToggle'):Set(hzm.multiple == 4)

	hzm.ToggleChoiceDouble:GetComponent('UIToggle'):Set(hzm.choiceDouble)
	hzm.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not hzm.choiceDouble)
	hzm.DoubleScoreText.parent.gameObject:SetActive(hzm.choiceDouble)
	if hzm.doubleScore == 0 then
		hzm.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		hzm.DoubleScoreText:GetComponent('UILabel').text = '小于'..hzm.doubleScore..'分'
	end
	hzm.DiFenTunValue:GetComponent("UILabel").text = hzm.baseScore..'分'
	hzm.ToggleScoreGangInc.parent.gameObject:SetActive(hzm.size ~= 4 or hzm.minorityMode)
	hzm.ToggleScoreGangInc:GetComponent('UIToggle'):Set(hzm.scoreMingGangInc)

	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.HZM,hzm.rounds,nil,nil)
	HZM:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.SetSubSetting1()
	hzm.ToggleRound8:GetComponent('UIToggle'):Set(hzm.rounds == 8)
	hzm.ToggleRound16:GetComponent('UIToggle'):Set(hzm.rounds == 16)

	hzm.TogglePeopleNum2:GetComponent('UIToggle'):Set(hzm.size == 2)
	hzm.TogglePeopleNum3:GetComponent('UIToggle'):Set(hzm.size == 3)
	hzm.TogglePeopleNum4:GetComponent('UIToggle'):Set(hzm.size == 4)

	hzm.ToggleLessPlayerStart:GetComponent('UIToggle'):Set(hzm.minorityMode)
	hzm.ToggleMasterPay:GetComponent('UIToggle'):Set(hzm.paymentType == 0)
	hzm.ToggleWinnerPay:GetComponent('UIToggle'):Set(hzm.paymentType == 2)

	hzm.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(hzm.trusteeshipTime == 0)
	hzm.ToggleTrusteeship1:GetComponent('UIToggle'):Set(hzm.trusteeshipTime == 1)
	hzm.ToggleTrusteeship2:GetComponent('UIToggle'):Set(hzm.trusteeshipTime == 2)
	hzm.ToggleTrusteeship3:GetComponent('UIToggle'):Set(hzm.trusteeshipTime == 3)
	hzm.ToggleTrusteeship5:GetComponent('UIToggle'):Set(hzm.trusteeshipTime == 5)
	hzm.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not hzm.trusteeshipType and hzm.trusteeshipRound == 0)
	hzm.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(hzm.trusteeshipType)
	hzm.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(hzm.trusteeshipRound == 3)
	hzm.ToggleTrusteeshipOne.parent.gameObject:SetActive(hzm.trusteeshipTime ~= 0)

	hzm.ToggleDianPaoHu:GetComponent('UIToggle'):Set(hzm.dianpaohu)
	hzm.ToggleZhuangXianFen:GetComponent('UIToggle'):Set(hzm.zhuangxianfen)
	hzm.ToggleKeHuQiDui:GetComponent('UIToggle'):Set(hzm.kehuqidui)
	hzm.ToggleYouHuBiHu:GetComponent('UIToggle'):Set(hzm.youhubihu)
	hzm.TogglePiaoFen:GetComponent('UIToggle'):Set(hzm.piaofen)
	hzm.ToggleNoHongZhongDouble:GetComponent('UIToggle'):Set(hzm.nohongzhongdouble)
	hzm.ToggleAllDouble:GetComponent('UIToggle'):Set(hzm.scoreHongZhongNonNiaoBanker)
	hzm.ToggleHuangZhuangGang:GetComponent('UIToggle'):Set(hzm.huangzhuanggang)
	hzm.ToggleYouHongZhongNoPao:GetComponent('UIToggle'):Set(hzm.youhongzhongnopao)
end
--获取当前设置
function this.GetConfig()
	local moneyLess = false
    
    if (hzm.rounds == 8 and info_login.balance < 2) or
		   (hzm.rounds == 16 and info_login.balance < 4 ) then
			moneyLess = true
		end
    local body 						= {}
    body.roomType 					= UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.HZM)
	body.rounds 					= hzm.rounds
    body.size 						= hzm.size
    body.minorityMode 				= hzm.minorityMode
    body.paymentType 				= hzm.paymentType
    body.trusteeship 				= hzm.trusteeshipTime*60;
    body.trusteeshipDissolve 		= hzm.trusteeshipType;
    body.trusteeshipRound 			= hzm.trusteeshipRound;
    body.dianPaoHu 					= hzm.dianpaohu
    body.bankerAddOne 				= hzm.zhuangxianfen
    body.huSevenPairs 				= hzm.kehuqidui
    body.huangZhuangHuangGang 		= hzm.huangzhuanggang
    body.mustHu 					= hzm.youhubihu
    body.floatScore 				= hzm.piaofen
    body.scoreHongZhongNon 			= hzm.nohongzhongdouble
	if body.scoreHongZhongNon then
		body.scoreHongZhongNonNiaoBanker 	= hzm.scoreHongZhongNonNiaoBanker
	end
    body.hongZhongNonJiePao 		= hzm.youhongzhongnopao
    body.birdAllHit 				= hzm.birdType==1
    body.birdBankerStart 			= hzm.birdType==3
    body.birdWinStart 			    = hzm.birdType==4
    body.bird159 			    	= hzm.birdType==2
    body.bird 						= hzm.birdNum
    body.scoreBird					= hzm.birdscore
    body.hongZhongCount 			= hzm.HongZhongNum
    body.scoreQiangGangMo 			= hzm.GangMoPaoNo==1;
    body.scoreQiangGangInc 			= hzm.QiangGangQuanBao and hzm.GangMoPaoNo==1;
    body.scoreQiangGangJiePao 		= hzm.GangMoPaoNo==2;
	body.scoreQiangGangHongZhong	= body.scoreQiangGangMo and true or (hzm.HongzhongQiangGang and hzm.GangMoPaoNo==2);
	if hzm.size == 2 or hzm.minorityMode then
		body.resultScore = hzm.isSettlementScore
		if hzm.isSettlementScore then
			body.resultLowerScore=hzm.fewerValue
			body.resultAddScore=hzm.addValue
		end
		body.choiceDouble = hzm.choiceDouble
		body.doubleScore = hzm.doubleScore
		body.multiple = hzm.multiple
	end
	body.openIp	 = (hzm.size == 2) and false or hzm.openIp
	body.openGps = (hzm.size == 2) and false or hzm.openGps
	if hzm.size ~= 4 or hzm.minorityMode then
		body.scoreMingGangInc = hzm.scoreMingGangInc
	end
	body.baseScore = hzm.baseScore
	print("setting------------------->")
	print(tostring(body));
    return moneyLess,body;
end

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
    if hzm.ToggleRound8.gameObject == go then
		hzm.rounds = 8
	elseif hzm.ToggleRound16.gameObject == go then
		hzm.rounds = 16
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.HZM,hzm.rounds,nil,nil)
	UnityEngine.PlayerPrefs.SetInt('NewHZMrounds', hzm.rounds)
end

function this.OnClickTogglePlayerNum(go)
    AudioManager.Instance:PlayAudio('btn')
	if hzm.TogglePeopleNum2.gameObject == go then
		hzm.size = 2
	elseif hzm.TogglePeopleNum3.gameObject == go then
		hzm.size = 3
	elseif hzm.TogglePeopleNum4.gameObject == go then
		hzm.size = 4
	end
	hzm.ToggleIPcheck.parent.gameObject:SetActive(hzm.size > 2 and CONST.IPcheckOn)
	UnityEngine.PlayerPrefs.SetInt('NewHZMsize', hzm.size)

	hzm.minorityMode=hzm.size~=2
	hzm.ToggleLessPlayerStart:GetComponent("UIToggle"):Set(hzm.minorityMode)
	UnityEngine.PlayerPrefs.SetInt('NewHZMminorityMode',hzm.minorityMode and 1 or 0)

	hzm.ToggleSettlementScoreSelect.parent.gameObject:SetActive(hzm.size==2 or hzm.minorityMode)
	hzm.ToggleChoiceDouble.parent.gameObject:SetActive(hzm.size == 2 or hzm.minorityMode)
	hzm.ToggleMultiple2.parent.gameObject:SetActive((hzm.size == 2 or hzm.minorityMode) and hzm.choiceDouble)
	hzm.ToggleScoreGangInc.parent.gameObject:SetActive(hzm.size ~= 4 or hzm.minorityMode)
	HZM:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickToggleLessPlayerStart(go)
	AudioManager.Instance:PlayAudio('btn')
	hzm.minorityMode=hzm.ToggleLessPlayerStart:GetComponent("UIToggle").value
	UnityEngine.PlayerPrefs.SetInt('NewHZMminorityMode',hzm.minorityMode and 1 or 0)

	hzm.ToggleSettlementScoreSelect.parent.gameObject:SetActive(hzm.minorityMode)
	hzm.ToggleChoiceDouble.parent.gameObject:SetActive(hzm.minorityMode)
	hzm.ToggleMultiple2.parent.gameObject:SetActive(hzm.minorityMode and hzm.choiceDouble)
	hzm.ToggleScoreGangInc.parent.gameObject:SetActive(hzm.minorityMode)
	HZM:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if hzm.ToggleMasterPay.gameObject == go then
		hzm.paymentType=0
	elseif hzm.ToggleWinnerPay.gameObject == go then
		hzm.paymentType=2
	end
	UnityEngine.PlayerPrefs.SetInt('NewHZMpaymentType', hzm.paymentType)
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if hzm.ToggleTrusteeshipNo.gameObject == go then
		hzm.trusteeshipTime = 0
	elseif hzm.ToggleTrusteeship1.gameObject == go then
		hzm.trusteeshipTime = 1
	elseif hzm.ToggleTrusteeship2.gameObject == go then
		hzm.trusteeshipTime = 2;
	elseif hzm.ToggleTrusteeship3.gameObject == go then
		hzm.trusteeshipTime = 3
	elseif hzm.ToggleTrusteeship5.gameObject == go then
		hzm.trusteeshipTime = 5
	end
	UnityEngine.PlayerPrefs.SetInt('NewHZMtrusteeshipTime', hzm.trusteeshipTime)
	hzm.ToggleTrusteeshipOne.parent.gameObject:SetActive(hzm.trusteeshipTime ~= 0)
	HZM:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if hzm.ToggleTrusteeshipOne.gameObject == go then
		hzm.trusteeshipType = true
		hzm.trusteeshipRound = 0;
	elseif hzm.ToggleTrusteeshipAll.gameObject == go then
		hzm.trusteeshipType = false
		hzm.trusteeshipRound = 0;
	elseif hzm.ToggleTrusteeshipThree.gameObject == go then
		hzm.trusteeshipRound = 3;
		hzm.trusteeshipType = false;
	end
	UnityEngine.PlayerPrefs.SetInt('NewHZMtrusteeshipType',hzm.trusteeshipType and 1 or 0)
	UnityEngine.PlayerPrefs.SetInt('NewHZMtrusteeshipRound',hzm.trusteeshipRound)
end

function this.OnClickTogglePiaoFen(go)  --飘分
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		hzm.piaofen = true
	else
		hzm.piaofen = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewHZMpiaofen', hzm.piaofen and 1 or 0)
end

function this.OnClickToggleDianPaoHu(go)
	if go:GetComponent('UIToggle').value == true then
		hzm.dianpaohu = true
	else
		hzm.dianpaohu = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewHZMdianpaohu', hzm.dianpaohu and 1 or 0)
end
function this.OnClickToggleZhuangXianFen(go)
	if go:GetComponent('UIToggle').value == true then
		hzm.zhuangxianfen = true
	else
		hzm.zhuangxianfen = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewHZMzhuangxianfen', hzm.zhuangxianfen and 1 or 0)
end
function this.OnClickToggleKeHuQiDui(go)
	if go:GetComponent('UIToggle').value == true then
		hzm.kehuqidui = true
	else
		hzm.kehuqidui = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewHZMkehuqidui', hzm.kehuqidui and 1 or 0)
end

function this.OnClickToggleYouHuBiHu(go)
	if go:GetComponent('UIToggle').value == true then
		hzm.youhubihu = true
	else
		hzm.youhubihu = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewHZMyouhubihu', hzm.youhubihu and 1 or 0)
end

function this.OnClickToggleNoHongZhongDouble(go)
	if go:GetComponent('UIToggle').value == true then
		hzm.nohongzhongdouble = true
	else
		hzm.nohongzhongdouble = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewHZMnohongzhongdouble', hzm.nohongzhongdouble and 1 or 0)
end

function this.OnClickToggleAllDouble(go)
	if go:GetComponent('UIToggle').value == true then
		hzm.scoreHongZhongNonNiaoBanker = true
	else
		hzm.scoreHongZhongNonNiaoBanker = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewHZMallDouble', hzm.scoreHongZhongNonNiaoBanker and 1 or 0)
end

function this.OnClickToggleHuangZhuangGang(go)
	if go:GetComponent('UIToggle').value == true then
		hzm.huangzhuanggang = true
	else
		hzm.huangzhuanggang = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewHZMhuangzhuanggang', hzm.huangzhuanggang and 1 or 0)
end
function this.OnClickToggleYouHongZhongNoPao(go)
	if go:GetComponent('UIToggle').value == true then
		hzm.youhongzhongnopao = true
	else
		hzm.youhongzhongnopao = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewHZMyouhongzhongnopao', hzm.youhongzhongnopao and 1 or 0)
end

function this.OnClickToggleNiaoTypeHZM(go)
	if hzm.ToggleHit159Niao.gameObject == go then
		hzm.birdType=2
	elseif hzm.ToggleDealerNiao.gameObject == go then
		hzm.birdType=3
	elseif hzm.ToggleWinNiao.gameObject == go then
		hzm.birdType=4
	elseif hzm.ToggleAllNiao.gameObject == go then
		hzm.birdType=1
	elseif hzm.ToggleNoNiao.gameObject == go then
		hzm.birdType=0
	end
	UnityEngine.PlayerPrefs.SetInt('NewHZMbirdType', hzm.birdType)
	hzm.ToggleNiao2:GetComponent('UIToggle'):Set(hzm.birdType ~= 0 and hzm.birdType ~= 1 and hzm.birdNum == 2)
	hzm.ToggleNiao4:GetComponent('UIToggle'):Set(hzm.birdType ~= 0 and hzm.birdType ~= 1 and hzm.birdNum == 4)
	hzm.ToggleNiao6:GetComponent('UIToggle'):Set(hzm.birdType ~= 0 and hzm.birdType ~= 1 and hzm.birdNum == 6)

	hzm.ToggleNiao2:GetComponent("BoxCollider").enabled = (hzm.birdType ~= 0 and hzm.birdType ~= 1)
	hzm.ToggleNiao4:GetComponent("BoxCollider").enabled = (hzm.birdType ~= 0 and hzm.birdType ~= 1)
	hzm.ToggleNiao6:GetComponent("BoxCollider").enabled = (hzm.birdType ~= 0 and hzm.birdType ~= 1)

	hzm.ToggleNiao1Score:GetComponent('UIToggle'):Set(hzm.birdType ~= 0 and hzm.birdscore == 1)
	hzm.ToggleNiao2Score:GetComponent('UIToggle'):Set(hzm.birdType ~= 0 and hzm.birdscore == 2)

	hzm.ToggleNiao1Score:GetComponent("BoxCollider").enabled = hzm.birdType ~= 0
	hzm.ToggleNiao2Score:GetComponent("BoxCollider").enabled = hzm.birdType ~= 0
	HZM:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickToggleNiaoNumHZM(go)
	if hzm.ToggleNiao2.gameObject == go then
		hzm.birdNum=2
	elseif hzm.ToggleNiao4.gameObject == go then
		hzm.birdNum=4
	elseif hzm.ToggleNiao6.gameObject == go then
		hzm.birdNum=6
	end
	UnityEngine.PlayerPrefs.SetInt('NewHZMbirdNum', hzm.birdNum)
end

function this.OnClickToggleNiaoScoreHZM(go)
	if hzm.ToggleNiao1Score.gameObject == go then
		hzm.birdscore=1
	elseif hzm.ToggleNiao2Score.gameObject == go then
		hzm.birdscore=2
	end
	UnityEngine.PlayerPrefs.SetInt('NewHZMbirdscore', hzm.birdscore)
end

function this.OnClickToggleHongZhongNum(go)
	if hzm.ToggleHongZhong4.gameObject == go then
		hzm.HongZhongNum=4
	elseif hzm.ToggleHongZhong8.gameObject == go then
		hzm.HongZhongNum=8
	end
	UnityEngine.PlayerPrefs.SetInt('NewHZMHongZhongNum',hzm.HongZhongNum)
end

function this.OnClickToggleToggleGangMoPaoNo(go)
	if hzm.ToggleGangMo.gameObject == go then
		hzm.GangMoPaoNo=1
	elseif hzm.ToggleGangPao.gameObject == go then
		hzm.GangMoPaoNo=2
	elseif hzm.ToggleGangNothing.gameObject == go then
		hzm.GangMoPaoNo=0
	end
	UnityEngine.PlayerPrefs.SetInt('NewHZMGangMoPaoNo', hzm.GangMoPaoNo)
	hzm.ToggleQiangGangQuanBao.gameObject:SetActive(hzm.GangMoPaoNo==1)
	hzm.ToggleHongzhongQiangGang.gameObject:SetActive(hzm.GangMoPaoNo==2)
end

function this.OnClickToggleQiangGangQuanBao(go)
	if go:GetComponent('UIToggle').value == true then
		hzm.QiangGangQuanBao = true
	else
		hzm.QiangGangQuanBao = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewHZMQiangGangQuanBao', hzm.QiangGangQuanBao and 1 or 0)
end

function this.OnClickToggleHongzhongQiangGang(go)
	if go:GetComponent('UIToggle').value == true then
		hzm.HongzhongQiangGang = true
	else
		hzm.HongzhongQiangGang = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewHZMHongzhongQiangGang', hzm.HongzhongQiangGang and 1 or 0)
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    hzm.isSettlementScore= hzm.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewHZMisSettlementScore', hzm.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if hzm.ToggleFewerAddButton.gameObject == go then
		hzm.fewerValue = hzm.fewerValue + 1
		if hzm.fewerValue > 100 then
			hzm.fewerValue = 100
		end
    elseif hzm.ToggleFewerSubtractButton.gameObject == go then
		hzm.fewerValue = hzm.fewerValue - 1
		if hzm.fewerValue < 1 then
			hzm.fewerValue = 1
		end
	end
	hzm.ToggleFewerScoreTxt:GetComponent('UILabel').text = hzm.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewHZMfewerValue', hzm.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if hzm.ToggleAddAddButton.gameObject == go then
		hzm.addValue = hzm.addValue + 1
		if hzm.addValue > 100 then
			hzm.addValue = 100
		end
    elseif hzm.ToggleAddSubtractButton.gameObject == go then
		hzm.addValue = hzm.addValue - 1
		if hzm.addValue < 1 then
			hzm.addValue = 1
		end
	end
	hzm.ToggleAddScoreTxt:GetComponent('UILabel').text = hzm.addValue
	UnityEngine.PlayerPrefs.SetInt('NewHZMaddValue', hzm.addValue)
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if hzm.ToggleIPcheck.gameObject == go then
		hzm.openIp = hzm.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('HZMcheckIP', hzm.openIp and 1 or 0)
	elseif hzm.ToggleGPScheck.gameObject == go then
		hzm.openGps = hzm.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('HZMcheckGPS', hzm.openGps and 1 or 0)
	end
end
function this.OnClickChoiceDouble(go)
    AudioManager.Instance:PlayAudio('btn')
	if hzm.ToggleChoiceDouble.gameObject == go then
		hzm.choiceDouble = true
	else
		hzm.choiceDouble = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewHZMchoiceDouble', hzm.choiceDouble and 1 or 0)
	hzm.DoubleScoreText.parent.gameObject:SetActive(hzm.choiceDouble)
	hzm.ToggleMultiple2.parent.gameObject:SetActive(hzm.choiceDouble)
	if hzm.choiceDouble then
		hzm.ToggleMultiple2:GetComponent('UIToggle'):Set(hzm.multiple == 2)
		hzm.ToggleMultiple3:GetComponent('UIToggle'):Set(hzm.multiple == 3)
		hzm.ToggleMultiple4:GetComponent('UIToggle'):Set(hzm.multiple == 4)
	end
    HZM:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickChangeDoubleScore(go)
    AudioManager.Instance:PlayAudio('btn')
    local label_= hzm.DoubleScoreText:GetComponent('UILabel').text
    if label_=='不限分' then
        hzm.doubleScore=0
    else
        hzm.doubleScore=tonumber(string.sub(label_,7,-4))    
    end
	if hzm.AddDoubleScoreButton.gameObject == go then
		if hzm.doubleScore ~= 0 then
			hzm.doubleScore = hzm.doubleScore + 1
			if hzm.doubleScore > 100 then
				hzm.doubleScore = 0
			end
		end
	else
		if hzm.doubleScore == 0 then
			hzm.doubleScore = 100
		else
			hzm.doubleScore = hzm.doubleScore - 1
			if hzm.doubleScore < 1 then
				hzm.doubleScore = 1
			end
		end
	end

	if hzm.doubleScore == 0 then
		hzm.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		hzm.DoubleScoreText:GetComponent('UILabel').text = '小于'..hzm.doubleScore..'分'
	end
	UnityEngine.PlayerPrefs.SetInt('NewHZMdoubleScore', hzm.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
	hzm.multiple = tonumber(go.name)
	print('倍数：'..hzm.multiple)
	UnityEngine.PlayerPrefs.SetInt('NewHZMmultiple', hzm.multiple)
end

function this.OnClickChangeDiFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if hzm.AddBtnDiFen.gameObject == go then
		hzm.baseScore = hzm.baseScore + 1
		if hzm.baseScore > 10 then
			hzm.baseScore = 10
		end
    elseif hzm.SubtractBtnDiFen.gameObject == go then
        hzm.baseScore = hzm.baseScore - 1
		if hzm.baseScore < 1 then
			hzm.baseScore = 1
		end
	end
	hzm.DiFenTunValue:GetComponent("UILabel").text = hzm.baseScore..'分'
    UnityEngine.PlayerPrefs.SetInt('NewHZMbaseScore', hzm.baseScore)
end

function this.OnClickToggleScoreGangInc(go)
	AudioManager.Instance:PlayAudio('btn')
	hzm.scoreMingGangInc = hzm.ToggleScoreGangInc:GetComponent('UIToggle').value 
	UnityEngine.PlayerPrefs.SetInt('NewHZMscoreMingGangInc', hzm.scoreMingGangInc and 1 or 0)
end

return this