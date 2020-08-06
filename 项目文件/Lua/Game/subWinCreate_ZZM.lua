local this = {}

local ZZM
local payLabel

local zzm = {
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

	birdType=0,--0不抓鸟，1 159抓鸟，2庄家方位，3赢家方位，4一鸟全中
	birdNum=2,
	bankerAddOne=false,
	dianPaoHu=false,
	huQiDui=false,
	huangZhuangHuangGang=false,
	floatScore=false,

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

	hit159Niao = nil,
	dealerNiao = nil,
	winNiao = nil,
	AllNiao = nil,
	NoNiao = nil,
	Niao2 = nil,
	Niao4 = nil,
	Niao6 = nil,

	CustomizeZhuangxian = nil,
	DianPaoHu = nil,
	KeHuQiDui = nil,
	HuangZhuangGang = nil,
	CustomizePiaofen = nil,

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

	ToggleScoreGangInc=nil,
	AddBtnDiFen = nil,
	SubtractBtnDiFen = nil,
	DiFenTunValue = nil,
}

function this.Init(grid,message)
	print('Init_ZZM')
	ZZM = grid
    payLabel = message.transform:Find('diamond/pay_label')
    
    zzm.ToggleRound8 = ZZM:Find("table/ToggleRound/ToggleRound8");
    zzm.ToggleRound16 = ZZM:Find("table/ToggleRound/ToggleRound16");
    zzm.TogglePeopleNum2 = ZZM:Find("table/TogglePeople/Toggle2P");
	zzm.TogglePeopleNum3 = ZZM:Find("table/TogglePeople/Toggle3P");
    zzm.TogglePeopleNum4 = ZZM:Find("table/TogglePeople/Toggle4P");
    zzm.ToggleLessPlayerStart = ZZM:Find("table/TogglePeople/lessPlayerStart");
    zzm.ToggleMasterPay = ZZM:Find("table/TogglePayType/ToggleMasterPay");
	zzm.ToggleWinnerPay = ZZM:Find("table/TogglePayType/ToggleWinnerPay");
	zzm.ToggleTrusteeshipNo = ZZM:Find('table/DelegateChoose/NoDelegate')
	zzm.ToggleTrusteeship1 = ZZM:Find('table/DelegateChoose/Delegate1')
	zzm.ToggleTrusteeship2 = ZZM:Find('table/DelegateChoose/Delegate2')
	zzm.ToggleTrusteeship3 = ZZM:Find('table/DelegateChoose/Delegate3')
	zzm.ToggleTrusteeship5 = ZZM:Find('table/DelegateChoose/Delegate5')
	zzm.ToggleTrusteeshipAll = ZZM:Find('table/DelegateCancel/FullRound')
	zzm.ToggleTrusteeshipOne = ZZM:Find('table/DelegateCancel/ThisRound')
	zzm.ToggleTrusteeshipThree = ZZM:Find('table/DelegateCancel/ThreeRound')

	zzm.hit159Niao = ZZM:Find('table/ToggleNiaoType/hit159Niao')
	zzm.dealerNiao = ZZM:Find('table/ToggleNiaoType/dealerNiao')
	zzm.winNiao = ZZM:Find('table/ToggleNiaoType/winNiao')
	zzm.AllNiao = ZZM:Find('table/ToggleNiaoType/AllNiao')
	zzm.NoNiao = ZZM:Find('table/ToggleNiaoType/NoNiao')

	zzm.Niao2 = ZZM:Find('table/ToggleNiaoNum/Niao2')
	zzm.Niao4 = ZZM:Find('table/ToggleNiaoNum/Niao4')
	zzm.Niao6 = ZZM:Find('table/ToggleNiaoNum/Niao6')

	zzm.CustomizeZhuangxian = ZZM:Find('table/ToggleCapping/ZhuangShuYing')
	zzm.DianPaoHu = ZZM:Find('table/ToggleCapping/DianPaoHu')
	zzm.KeHuQiDui = ZZM:Find('table/ToggleCapping/KeHuQiDui')
	zzm.HuangZhuangGang = ZZM:Find('table/ToggleCapping/HuangZhuangHuangGang')
	zzm.CustomizePiaofen = ZZM:Find('table/ToggleCapping/ZhuanPiaoFen')

	zzm.ToggleSettlementScoreSelect=ZZM:Find('table/settlementScore/select')
	zzm.ToggleFewerScoreTxt=ZZM:Find('table/settlementScore/fewerValue/Value')
	zzm.ToggleFewerAddButton=ZZM:Find('table/settlementScore/fewerValue/AddButton')
	zzm.ToggleFewerSubtractButton=ZZM:Find('table/settlementScore/fewerValue/SubtractButton')
	zzm.ToggleAddScoreTxt=ZZM:Find('table/settlementScore/addValue/Value')
	zzm.ToggleAddAddButton=ZZM:Find('table/settlementScore/addValue/AddButton')
	zzm.ToggleAddSubtractButton=ZZM:Find('table/settlementScore/addValue/SubtractButton')
	
	zzm.ToggleIPcheck = ZZM:Find('table/PreventCheat/IPcheck')
	zzm.ToggleGPScheck = ZZM:Find('table/PreventCheat/GPScheck')

	zzm.ToggleMultiple2 = ZZM:Find('table/multiple/2')
	zzm.ToggleMultiple3 = ZZM:Find('table/multiple/3')
	zzm.ToggleMultiple4 = ZZM:Find('table/multiple/4')

	zzm.ToggleChoiceDouble  = ZZM:Find('table/choiceDouble/On')
	zzm.ToggleNoChoiceDouble = ZZM:Find('table/choiceDouble/Off')
	zzm.DoubleScoreText = ZZM:Find('table/choiceDouble/doubleScore/Value')
	zzm.AddDoubleScoreButton = ZZM:Find('table/choiceDouble/doubleScore/AddButton')
	zzm.SubtractDoubleScoreButton = ZZM:Find('table/choiceDouble/doubleScore/SubtractButton')

	message:AddClick(zzm.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(zzm.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(zzm.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(zzm.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)

	message:AddClick(zzm.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(zzm.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(zzm.ToggleMultiple4.gameObject, this.OnClickMultiple)

	message:AddClick(zzm.ToggleRound8.gameObject, this.OnClickToggleRound)
	message:AddClick(zzm.ToggleRound16.gameObject, this.OnClickToggleRound)

	message:AddClick(zzm.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(zzm.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(zzm.TogglePeopleNum4.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(zzm.ToggleLessPlayerStart.gameObject, this.OnClickToggleLessPlayerStart)

	message:AddClick(zzm.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(zzm.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)

	message:AddClick(zzm.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(zzm.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(zzm.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(zzm.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(zzm.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(zzm.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(zzm.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(zzm.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)

	message:AddClick(zzm.hit159Niao.gameObject, this.OnClickButtonZhuaNiaoZZM)
	message:AddClick(zzm.dealerNiao.gameObject, this.OnClickButtonZhuaNiaoZZM)
	message:AddClick(zzm.winNiao.gameObject, this.OnClickButtonZhuaNiaoZZM)
	message:AddClick(zzm.AllNiao.gameObject, this.OnClickButtonZhuaNiaoZZM)
	message:AddClick(zzm.NoNiao.gameObject, this.OnClickButtonZhuaNiaoZZM)

	message:AddClick(zzm.Niao2.gameObject, this.OnClickButtonNiaoNumZZM)
	message:AddClick(zzm.Niao4.gameObject, this.OnClickButtonNiaoNumZZM)
	message:AddClick(zzm.Niao6.gameObject, this.OnClickButtonNiaoNumZZM)

	message:AddClick(zzm.CustomizeZhuangxian.gameObject, this.OnClickButtonCustomizeZhuangxian)
	message:AddClick(zzm.DianPaoHu.gameObject, this.OnClickButtonDianPaoHu)
	message:AddClick(zzm.KeHuQiDui.gameObject, this.OnClickButtonKeHuQiDui)
	message:AddClick(zzm.HuangZhuangGang.gameObject, this.OnClickButtonHuangZhuangGang)
	message:AddClick(zzm.CustomizePiaofen.gameObject, this.OnClickButtonCustomizePiaofen)

	message:AddClick(zzm.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(zzm.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(zzm.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(zzm.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(zzm.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)
	
	message:AddClick(zzm.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(zzm.ToggleGPScheck.gameObject, this.OnClickPreventCheat)

	zzm.AddBtnDiFen = ZZM:Find('table/diFen/diFenScore/AddButton')
	zzm.SubtractBtnDiFen = ZZM:Find('table/diFen/diFenScore/SubtractButton')
	zzm.DiFenTunValue = ZZM:Find('table/diFen/diFenScore/Value')
	message:AddClick(zzm.AddBtnDiFen.gameObject, this.OnClickChangeDiFenValue)
	message:AddClick(zzm.SubtractBtnDiFen.gameObject, this.OnClickChangeDiFenValue)

	zzm.ToggleScoreGangInc = ZZM:Find('table/ToggleCapping/scoreGangInc')
	message:AddClick(zzm.ToggleScoreGangInc.gameObject, this.OnClickToggleScoreGangInc)
end

function this.Refresh()
	print('Refresh_ZZM')
	zzm.rounds = UnityEngine.PlayerPrefs.GetInt('NewZZMrounds', 8)
	zzm.size = UnityEngine.PlayerPrefs.GetInt('NewZZMsize', 2)
	zzm.minorityMode=UnityEngine.PlayerPrefs.GetInt('NewZZMminorityMode', 0)==1
	zzm.paymentType = UnityEngine.PlayerPrefs.GetInt('NewZZMpaymentType', 0)
	zzm.trusteeshipTime=UnityEngine.PlayerPrefs.GetInt('NewZZMtrusteeshipTime', 0)
	zzm.trusteeshipType=UnityEngine.PlayerPrefs.GetInt('NewZZMtrusteeshipType', 0)==1
	zzm.trusteeshipRound=UnityEngine.PlayerPrefs.GetInt('NewZZMtrusteeshipRound', 0)

	zzm.birdType = UnityEngine.PlayerPrefs.GetInt('NewZZMbirdType', 0)
	zzm.birdNum = UnityEngine.PlayerPrefs.GetInt('NewZZMbirdNum', 2)

	zzm.bankerAddOne=UnityEngine.PlayerPrefs.GetInt('NewZZMbankerAddOne', 0)==1
	zzm.dianPaoHu=UnityEngine.PlayerPrefs.GetInt('NewZZMdianPaoHu', 0)==1
	zzm.huQiDui=UnityEngine.PlayerPrefs.GetInt('NewZZMhuQiDui', 0)==1
	zzm.huangZhuangHuangGang=UnityEngine.PlayerPrefs.GetInt('NewZZMhuangZhuangHuangGang', 0)==1
	zzm.floatScore=UnityEngine.PlayerPrefs.GetInt('NewZZMfloatScore', 0)==1

	zzm.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewZZMisSettlementScore', 0)==1
	zzm.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewZZMfewerValue', 10)
	zzm.addValue=UnityEngine.PlayerPrefs.GetInt('NewZZMaddValue', 10)
	zzm.openIp=UnityEngine.PlayerPrefs.GetInt('ZZMcheckIP', 0)==1
	zzm.openGps=UnityEngine.PlayerPrefs.GetInt('ZZMcheckGPS', 0)==1
	
	zzm.choiceDouble = UnityEngine.PlayerPrefs.GetInt("NewZZMchoiceDouble", 0)==1
    zzm.doubleScore = UnityEngine.PlayerPrefs.GetInt("NewZZMdoubleScore", 10)
    zzm.multiple = UnityEngine.PlayerPrefs.GetInt("NewZZMmultiple", 2)

	zzm.baseScore=UnityEngine.PlayerPrefs.GetInt('NewZZMbaseScore', 1)
	zzm.scoreMingGangInc=UnityEngine.PlayerPrefs.GetInt('NewZZMscoreMingGangInc', 0)==1
	this.SetPreSetting();

end

function this.SetPreSetting()

	this.SetSubSetting1();
	zzm.ToggleIPcheck.parent.gameObject:SetActive(zzm.size > 2 and CONST.IPcheckOn)
	zzm.ToggleSettlementScoreSelect.parent.gameObject:SetActive(zzm.size==2 or zzm.minorityMode)
	zzm.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(zzm.isSettlementScore)
	zzm.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	zzm.ToggleFewerScoreTxt:GetComponent('UILabel').text = zzm.fewerValue
	zzm.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	zzm.ToggleAddScoreTxt:GetComponent('UILabel').text = zzm.addValue

	zzm.hit159Niao:GetComponent('UIToggle'):Set(zzm.birdType == 2)
	zzm.dealerNiao:GetComponent('UIToggle'):Set(zzm.birdType == 3)
	zzm.winNiao:GetComponent('UIToggle'):Set(zzm.birdType == 4)
	zzm.AllNiao:GetComponent('UIToggle'):Set(zzm.birdType ==1)
	zzm.NoNiao:GetComponent('UIToggle'):Set(zzm.birdType == 0)

	zzm.Niao2:GetComponent('UIToggle'):Set(zzm.birdNum == 2)
	zzm.Niao4:GetComponent('UIToggle'):Set(zzm.birdNum == 4)
	zzm.Niao6:GetComponent('UIToggle'):Set(zzm.birdNum == 6)
	if zzm.birdType ==0 or zzm.birdType == 1 then
		zzm.Niao2:GetComponent("BoxCollider").enabled = false
		zzm.Niao4:GetComponent("BoxCollider").enabled = false
		zzm.Niao6:GetComponent("BoxCollider").enabled = false
		zzm.Niao2:GetComponent('UIToggle'):Set(false)
		zzm.Niao4:GetComponent('UIToggle'):Set(false)
		zzm.Niao6:GetComponent('UIToggle'):Set(false)
	end

	zzm.CustomizeZhuangxian:GetComponent('UIToggle'):Set(zzm.bankerAddOne)
	zzm.DianPaoHu:GetComponent('UIToggle'):Set(zzm.dianPaoHu)
	zzm.KeHuQiDui:GetComponent('UIToggle'):Set(zzm.huQiDui)
	zzm.HuangZhuangGang:GetComponent('UIToggle'):Set(zzm.huangZhuangHuangGang)
	zzm.CustomizePiaofen:GetComponent('UIToggle'):Set(zzm.floatScore)
	zzm.ToggleIPcheck:GetComponent('UIToggle'):Set(zzm.openIp)
	zzm.ToggleGPScheck:GetComponent('UIToggle'):Set(zzm.openGps)

	zzm.ToggleChoiceDouble.parent.gameObject:SetActive(zzm.size==2 or zzm.minorityMode)
    zzm.ToggleMultiple2.parent.gameObject:SetActive((zzm.size==2 or zzm.minorityMode) and zzm.choiceDouble)
    
	zzm.ToggleMultiple2:GetComponent('UIToggle'):Set(zzm.multiple == 2)
	zzm.ToggleMultiple3:GetComponent('UIToggle'):Set(zzm.multiple == 3)
	zzm.ToggleMultiple4:GetComponent('UIToggle'):Set(zzm.multiple == 4)

	zzm.ToggleChoiceDouble:GetComponent('UIToggle'):Set(zzm.choiceDouble)
	zzm.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not zzm.choiceDouble)
	zzm.DoubleScoreText.parent.gameObject:SetActive(zzm.choiceDouble)
	if zzm.doubleScore == 0 then
		zzm.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		zzm.DoubleScoreText:GetComponent('UILabel').text = '小于'..zzm.doubleScore..'分'
	end
	zzm.DiFenTunValue:GetComponent("UILabel").text = zzm.baseScore..'分'
	zzm.ToggleScoreGangInc.gameObject:SetActive(zzm.size ~= 4 or zzm.minorityMode)
	zzm.ToggleScoreGangInc:GetComponent('UIToggle'):Set(zzm.scoreMingGangInc)
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.ZZM,zzm.rounds,nil,nil)
	ZZM:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.SetSubSetting1()
	zzm.ToggleRound8:GetComponent('UIToggle'):Set(zzm.rounds == 8)
	zzm.ToggleRound16:GetComponent('UIToggle'):Set(zzm.rounds == 16)
	
	zzm.TogglePeopleNum2:GetComponent('UIToggle'):Set(zzm.size == 2)
	zzm.TogglePeopleNum3:GetComponent('UIToggle'):Set(zzm.size == 3)
	zzm.TogglePeopleNum4:GetComponent('UIToggle'):Set(zzm.size == 4)

	zzm.ToggleLessPlayerStart:GetComponent('UIToggle'):Set(zzm.minorityMode)
	zzm.ToggleMasterPay:GetComponent('UIToggle'):Set(zzm.paymentType == 0)
	zzm.ToggleWinnerPay:GetComponent('UIToggle'):Set(zzm.paymentType == 2)

	zzm.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(zzm.trusteeshipTime == 0)
	zzm.ToggleTrusteeship1:GetComponent('UIToggle'):Set(zzm.trusteeshipTime == 1)
	zzm.ToggleTrusteeship2:GetComponent('UIToggle'):Set(zzm.trusteeshipTime == 2)
	zzm.ToggleTrusteeship3:GetComponent('UIToggle'):Set(zzm.trusteeshipTime == 3)
	zzm.ToggleTrusteeship5:GetComponent('UIToggle'):Set(zzm.trusteeshipTime == 5)
	if zzm.trusteeshipType then
		zzm.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(true)
		zzm.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(true)
		zzm.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(true)
	end
	zzm.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not zzm.trusteeshipType and zzm.trusteeshipRound ==0)
	zzm.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(zzm.trusteeshipType)
	zzm.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(zzm.trusteeshipRound == 3)
	zzm.ToggleTrusteeshipOne.parent.gameObject:SetActive(zzm.trusteeshipTime ~= 0)
end
--获取当前设置
function this.GetConfig()
	local moneyLess = false
    if (zzm.rounds == 8 and info_login.balance < 2) or
        (zzm.rounds == 16 and info_login.balance < 4 ) then
        moneyLess = true
    end
    local body = {}
    body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.ZZM)
	body.rounds = zzm.rounds
    body.size = zzm.size
    body.minorityMode = zzm.minorityMode
    body.paymentType = zzm.paymentType
    body.trusteeship = zzm.trusteeshipTime*60;
    body.trusteeshipDissolve = zzm.trusteeshipType;
    body.trusteeshipRound = zzm.trusteeshipRound;
    body.huAsBanker 			= false;
    
    body.dianPaoHu 				= zzm.dianPaoHu
    body.bankerAddOne 			= zzm.bankerAddOne
    body.huSevenPairs 			= zzm.huQiDui
    body.huangZhuangHuangGang 	= zzm.huangZhuangHuangGang
    body.floatScore 			= zzm.floatScore

	if zzm.size == 2 or zzm.minorityMode then
		body.resultScore = zzm.isSettlementScore
		if zzm.isSettlementScore then
			body.resultLowerScore=zzm.fewerValue
			body.resultAddScore=zzm.addValue
		end
		body.choiceDouble = zzm.choiceDouble
		body.doubleScore = zzm.doubleScore
		body.multiple = zzm.multiple
	end

    body.birdAllHit 			= zzm.birdType==1;
    body.birdBankerStart 		= zzm.birdType==3
    body.birdWinStart 			= zzm.birdType==4
    body.bird159 			    = zzm.birdType==2
    body.bird 					= zzm.birdNum;
	body.openIp					= (zzm.size == 2) and false or zzm.openIp
	body.openGps				= (zzm.size == 2) and false or zzm.openGps
	if zzm.size ~= 4 or zzm.minorityMode then
		body.scoreMingGangInc = zzm.scoreMingGangInc
	end
	body.baseScore = zzm.baseScore
    return moneyLess,body;
end

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
    if zzm.ToggleRound8.gameObject == go then
        zzm.rounds = 8
    elseif zzm.ToggleRound16.gameObject == go then
        zzm.rounds = 16
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.ZZM,zzm.rounds,nil,nil)
    UnityEngine.PlayerPrefs.SetInt('NewZZMrounds', zzm.rounds)
end

function this.OnClickTogglePlayerNum(go)
    AudioManager.Instance:PlayAudio('btn')
	if zzm.TogglePeopleNum2.gameObject == go then
        zzm.size = 2
    elseif zzm.TogglePeopleNum3.gameObject == go then
        zzm.size = 3
    elseif zzm.TogglePeopleNum4.gameObject == go then
        zzm.size = 4
	end
	zzm.ToggleIPcheck.parent.gameObject:SetActive(zzm.size > 2 and CONST.IPcheckOn)
	UnityEngine.PlayerPrefs.SetInt('NewZZMsize', zzm.size)

	zzm.minorityMode=zzm.size~=2
	zzm.ToggleLessPlayerStart:GetComponent("UIToggle"):Set(zzm.minorityMode)
	UnityEngine.PlayerPrefs.SetInt('NewZZMminorityMode',zzm.minorityMode and 1 or 0)

	zzm.ToggleSettlementScoreSelect.parent.gameObject:SetActive(zzm.size==2 or zzm.minorityMode)
	zzm.ToggleChoiceDouble.parent.gameObject:SetActive(zzm.size == 2 or zzm.minorityMode)
	zzm.ToggleMultiple2.parent.gameObject:SetActive((zzm.size == 2 or zzm.minorityMode) and zzm.choiceDouble)
	zzm.ToggleScoreGangInc.gameObject:SetActive(zzm.size ~= 4 or zzm.minorityMode)
	ZZM:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickToggleLessPlayerStart(go)
	AudioManager.Instance:PlayAudio('btn')
	zzm.minorityMode=zzm.ToggleLessPlayerStart:GetComponent("UIToggle").value
	UnityEngine.PlayerPrefs.SetInt('NewZZMminorityMode',zzm.minorityMode and 1 or 0)
	
	zzm.ToggleSettlementScoreSelect.parent.gameObject:SetActive(zzm.minorityMode)
	zzm.ToggleChoiceDouble.parent.gameObject:SetActive(zzm.minorityMode)
	zzm.ToggleMultiple2.parent.gameObject:SetActive(zzm.minorityMode and zzm.choiceDouble)
	zzm.ToggleScoreGangInc.gameObject:SetActive(zzm.minorityMode)
	ZZM:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if zzm.ToggleMasterPay.gameObject == go then
		zzm.paymentType=0
    elseif zzm.ToggleWinnerPay.gameObject == go then
        zzm.paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewZZMpaymentType', zzm.paymentType)
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if zzm.ToggleTrusteeshipNo.gameObject == go then
        zzm.trusteeshipTime = 0
    elseif zzm.ToggleTrusteeship1.gameObject == go then
        zzm.trusteeshipTime = 1
	elseif zzm.ToggleTrusteeship2.gameObject == go then
		zzm.trusteeshipTime = 2
    elseif zzm.ToggleTrusteeship3.gameObject == go then
        zzm.trusteeshipTime = 3
    elseif zzm.ToggleTrusteeship5.gameObject == go then
        zzm.trusteeshipTime = 5
    end
    UnityEngine.PlayerPrefs.SetInt('NewZZMtrusteeshipTime', zzm.trusteeshipTime)
    zzm.ToggleTrusteeshipOne.parent.gameObject:SetActive(zzm.trusteeshipTime ~= 0)
	ZZM:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if zzm.ToggleTrusteeshipOne.gameObject == go then
		zzm.trusteeshipType = true
		zzm.trusteeshipRound  = 0;
    elseif zzm.ToggleTrusteeshipAll.gameObject == go then
        zzm.trusteeshipType = false
		zzm.trusteeshipRound = 0;
	elseif zzm.ToggleTrusteeshipThree.gameObject == go then
		zzm.trusteeshipRound = 3;
		zzm.trusteeshipType = false;
    end
    UnityEngine.PlayerPrefs.SetInt('NewZZMtrusteeshipType',zzm.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewZZMtrusteeshipRound',zzm.trusteeshipRound);
end

function this.OnClickButtonZhuaNiaoZZM(go)
	if zzm.hit159Niao.gameObject == go then
		zzm.birdType = 2
	elseif zzm.dealerNiao.gameObject == go then
		zzm.birdType = 3
	elseif zzm.winNiao.gameObject == go then
		zzm.birdType = 4
	elseif zzm.AllNiao.gameObject == go then
		zzm.birdType = 1
	elseif zzm.NoNiao.gameObject == go then
		zzm.birdType = 0
	end
	UnityEngine.PlayerPrefs.SetInt("NewZZMbirdType",zzm.birdType);
	zzm.Niao2:GetComponent('UIToggle'):Set(zzm.birdType ~= 0 and zzm.birdType ~= 1 and zzm.birdNum == 2)
	zzm.Niao4:GetComponent('UIToggle'):Set(zzm.birdType ~= 0 and zzm.birdType ~= 1 and zzm.birdNum == 4)
	zzm.Niao6:GetComponent('UIToggle'):Set(zzm.birdType ~= 0 and zzm.birdType ~= 1 and zzm.birdNum == 6)

	zzm.Niao2:GetComponent("BoxCollider").enabled = (zzm.birdType ~= 0 and zzm.birdType ~= 1)
	zzm.Niao4:GetComponent("BoxCollider").enabled = (zzm.birdType ~= 0 and zzm.birdType ~= 1)
	zzm.Niao6:GetComponent("BoxCollider").enabled = (zzm.birdType ~= 0 and zzm.birdType ~= 1)
	ZZM:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickButtonNiaoNumZZM(go)
	if zzm.Niao2.gameObject == go then
		zzm.birdNum = 2
	elseif zzm.Niao4.gameObject == go then
		zzm.birdNum = 4
	elseif zzm.Niao6.gameObject == go then
		zzm.birdNum = 6
	end
	UnityEngine.PlayerPrefs.SetInt("NewZZMbirdNum",zzm.birdNum);
end

function this.OnClickButtonCustomizeZhuangxian(go)
	if go:GetComponent('UIToggle').value == true then
		zzm.bankerAddOne = true
	else
		zzm.bankerAddOne = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewZZMbankerAddOne', zzm.bankerAddOne and 1 or 0)
end

function this.OnClickButtonDianPaoHu(go)
	if go:GetComponent('UIToggle').value == true then
		zzm.dianPaoHu = true
	else
		zzm.dianPaoHu = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewZZMdianPaoHu', zzm.dianPaoHu and 1 or 0)
end

function this.OnClickButtonKeHuQiDui(go)
	if go:GetComponent('UIToggle').value == true then
		zzm.huQiDui = true
	else
		zzm.huQiDui = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewZZMhuQiDui', zzm.huQiDui and 1 or 0)
end

function this.OnClickButtonHuangZhuangGang(go)
	if go:GetComponent('UIToggle').value == true then
		zzm.huangZhuangHuangGang = true
	else
		zzm.huangZhuangHuangGang = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewZZMhuangZhuangHuangGang', zzm.huangZhuangHuangGang and 1 or 0)
end

function this.OnClickButtonCustomizePiaofen(go)
	if go:GetComponent('UIToggle').value == true then
		zzm.floatScore = true
	else
		zzm.floatScore = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewZZMfloatScore', zzm.floatScore and 1 or 0)
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    zzm.isSettlementScore= zzm.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewZZMisSettlementScore', zzm.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if zzm.ToggleFewerAddButton.gameObject == go then
		zzm.fewerValue = zzm.fewerValue + 1
		if zzm.fewerValue > 100 then
			zzm.fewerValue = 100
		end
    elseif zzm.ToggleFewerSubtractButton.gameObject == go then
		zzm.fewerValue = zzm.fewerValue - 1
		if zzm.fewerValue < 1 then
			zzm.fewerValue = 1
		end
	end
	zzm.ToggleFewerScoreTxt:GetComponent('UILabel').text = zzm.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewZZMfewerValue', zzm.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if zzm.ToggleAddAddButton.gameObject == go then
		zzm.addValue = zzm.addValue + 1
		if zzm.addValue > 100 then
			zzm.addValue = 100
		end
    elseif zzm.ToggleAddSubtractButton.gameObject == go then
		zzm.addValue = zzm.addValue - 1
		if zzm.addValue < 1 then
			zzm.addValue = 1
		end
	end
	zzm.ToggleAddScoreTxt:GetComponent('UILabel').text = zzm.addValue
	UnityEngine.PlayerPrefs.SetInt('NewZZMaddValue', zzm.addValue)
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if zzm.ToggleIPcheck.gameObject == go then
		zzm.openIp = zzm.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('ZZMcheckIP', zzm.openIp and 1 or 0)
	elseif zzm.ToggleGPScheck.gameObject == go then
		zzm.openGps = zzm.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('ZZMcheckGPS', zzm.openGps and 1 or 0)
	end
end
function this.OnClickChoiceDouble(go)
    AudioManager.Instance:PlayAudio('btn')
	if zzm.ToggleChoiceDouble.gameObject == go then
		zzm.choiceDouble = true
	else
		zzm.choiceDouble = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewZZMchoiceDouble', zzm.choiceDouble and 1 or 0)
	zzm.DoubleScoreText.parent.gameObject:SetActive(zzm.choiceDouble)
	zzm.ToggleMultiple2.parent.gameObject:SetActive(zzm.choiceDouble)
	if zzm.choiceDouble then
		zzm.ToggleMultiple2:GetComponent('UIToggle'):Set(zzm.multiple == 2)
		zzm.ToggleMultiple3:GetComponent('UIToggle'):Set(zzm.multiple == 3)
		zzm.ToggleMultiple4:GetComponent('UIToggle'):Set(zzm.multiple == 4)
	end
    ZZM:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickChangeDoubleScore(go)
    AudioManager.Instance:PlayAudio('btn')
    local label_= zzm.DoubleScoreText:GetComponent('UILabel').text
    if label_=='不限分' then
        zzm.doubleScore=0
    else
        zzm.doubleScore=tonumber(string.sub(label_,7,-4))    
    end
	if zzm.AddDoubleScoreButton.gameObject == go then
		if zzm.doubleScore ~= 0 then
			zzm.doubleScore = zzm.doubleScore + 1
			if zzm.doubleScore > 100 then
				zzm.doubleScore = 0
			end
		end
	else
		if zzm.doubleScore == 0 then
			zzm.doubleScore = 100
		else
			zzm.doubleScore = zzm.doubleScore - 1
			if zzm.doubleScore < 1 then
				zzm.doubleScore = 1
			end
		end
	end

	if zzm.doubleScore == 0 then
		zzm.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		zzm.DoubleScoreText:GetComponent('UILabel').text = '小于'..zzm.doubleScore..'分'
	end
	UnityEngine.PlayerPrefs.SetInt('NewZZMdoubleScore', zzm.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
	zzm.multiple = tonumber(go.name)
	print('倍数：'..zzm.multiple)
	UnityEngine.PlayerPrefs.SetInt('NewZZMmultiple', zzm.multiple)
end

function this.OnClickChangeDiFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if zzm.AddBtnDiFen.gameObject == go then
		zzm.baseScore = zzm.baseScore + 1
		if zzm.baseScore > 10 then
			zzm.baseScore = 10
		end
    elseif zzm.SubtractBtnDiFen.gameObject == go then
        zzm.baseScore = zzm.baseScore - 1
		if zzm.baseScore < 1 then
			zzm.baseScore = 1
		end
	end
	zzm.DiFenTunValue:GetComponent("UILabel").text = zzm.baseScore..'分'
    UnityEngine.PlayerPrefs.SetInt('NewZZMbaseScore', zzm.baseScore)
end

function this.OnClickToggleScoreGangInc(go)
	AudioManager.Instance:PlayAudio('btn')
	zzm.scoreMingGangInc = zzm.ToggleScoreGangInc:GetComponent('UIToggle').value 
	UnityEngine.PlayerPrefs.SetInt('NewZZMscoreMingGangInc', zzm.scoreMingGangInc and 1 or 0)
end

return this