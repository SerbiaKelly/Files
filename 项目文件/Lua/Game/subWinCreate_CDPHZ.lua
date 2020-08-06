local this = {}

local CDPHZ
local payLabel

local cdphzObj ={}
local cdphzData ={}

function this.Init(grid,message)
	print('Init_CDPHZ')
	CDPHZ = grid
	payLabel = message.transform:Find('diamond/pay_label')

	cdphzObj.ToggleRound6 = CDPHZ:Find('table/round/round6')
	cdphzObj.ToggleRound8 = CDPHZ:Find('table/round/round8')
	cdphzObj.ToggleRound10 = CDPHZ:Find('table/round/round10')
	cdphzObj.ToggleRound16 = CDPHZ:Find('table/round/round16')
	message:AddClick(cdphzObj.ToggleRound6.gameObject, this.OnClickToggleRound)
	message:AddClick(cdphzObj.ToggleRound8.gameObject, this.OnClickToggleRound)
    message:AddClick(cdphzObj.ToggleRound10.gameObject, this.OnClickToggleRound)
	message:AddClick(cdphzObj.ToggleRound16.gameObject, this.OnClickToggleRound)

	cdphzObj.TogglePeopleNum2 = CDPHZ:Find('table/num/num2')
	cdphzObj.TogglePeopleNum3 = CDPHZ:Find('table/num/num3')
	message:AddClick(cdphzObj.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(cdphzObj.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)
	
	cdphzObj.ToggleMasterPay = CDPHZ:Find('table/pay/master')
	cdphzObj.ToggleWinnerPay = CDPHZ:Find('table/pay/win')
	message:AddClick(cdphzObj.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(cdphzObj.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)

	cdphzObj.ToggleRandomBanker = CDPHZ:Find('table/randomBanker/Auto')
	cdphzObj.ToggleBankerFrist = CDPHZ:Find('table/randomBanker/Frist')
	message:AddClick(cdphzObj.ToggleRandomBanker.gameObject, this.OnClickRandomBanker)
	message:AddClick(cdphzObj.ToggleBankerFrist.gameObject, this.OnClickRandomBanker)

	cdphzObj.Toggleqmt = CDPHZ:Find('table/mingtang/qmt')
	cdphzObj.Togglehhd = CDPHZ:Find('table/mingtang/hhd')
	message:AddClick(cdphzObj.Toggleqmt.gameObject, this.OnClickToggleMingTang)
	message:AddClick(cdphzObj.Togglehhd.gameObject, this.OnClickToggleMingTang)

	cdphzObj.ToggleShuaHou = CDPHZ:Find('table/play1/shuaHou')
	message:AddClick(cdphzObj.ToggleShuaHou.gameObject, this.OnClickTogglePlayCDPHZ)
	cdphzObj.ToggleDaTuanYuan = CDPHZ:Find('table/play1/daTuanYuan')
	message:AddClick(cdphzObj.ToggleDaTuanYuan.gameObject, this.OnClickTogglePlayCDPHZ)
	cdphzObj.ToggleTingHu = CDPHZ:Find('table/play1/tingHu')
	message:AddClick(cdphzObj.ToggleTingHu.gameObject, this.OnClickTogglePlayCDPHZ)
	cdphzObj.ToggleHangHangXi = CDPHZ:Find('table/play2/hangHangXi')
	message:AddClick(cdphzObj.ToggleHangHangXi.gameObject, this.OnClickTogglePlayCDPHZ)
	cdphzObj.ToggleHong47 = CDPHZ:Find('table/play2/hong47')
	message:AddClick(cdphzObj.ToggleHong47.gameObject, this.OnClickTogglePlayCDPHZ)
	cdphzObj.ToggleHuangFan = CDPHZ:Find('table/play2/huangFan')
	message:AddClick(cdphzObj.ToggleHuangFan.gameObject, this.OnClickTogglePlayCDPHZ)
	cdphzObj.ToggleJiaHangHang = CDPHZ:Find('table/play3/jiaHangHang')
	message:AddClick(cdphzObj.ToggleJiaHangHang.gameObject, this.OnClickTogglePlayCDPHZ)
	cdphzObj.ToggleDuiDuiHu = CDPHZ:Find('table/play4/duiDuiHu')
	message:AddClick(cdphzObj.ToggleDuiDuiHu.gameObject, this.OnClickTogglePlayCDPHZ)

	cdphzObj.AddBtnDiFen = CDPHZ:Find('table/diFen/diFenScore/AddButton')
	cdphzObj.SubtractBtnDiFen = CDPHZ:Find('table/diFen/diFenScore/SubtractButton')
	cdphzObj.DiFenTunValue = CDPHZ:Find('table/diFen/diFenScore/Value')
	message:AddClick(cdphzObj.AddBtnDiFen.gameObject, this.OnClickChangeDiFenValue)
	message:AddClick(cdphzObj.SubtractBtnDiFen.gameObject, this.OnClickChangeDiFenValue)

	cdphzObj.AddBtnFengDing = CDPHZ:Find('table/fengDing/fengDingScore/AddButton')
	cdphzObj.SubtractBtnFengDing = CDPHZ:Find('table/fengDing/fengDingScore/SubtractButton')
	cdphzObj.FengDingValue = CDPHZ:Find('table/fengDing/fengDingScore/Value')
	message:AddClick(cdphzObj.AddBtnFengDing.gameObject, this.OnClickChangeFengDingValue)
	message:AddClick(cdphzObj.SubtractBtnFengDing.gameObject, this.OnClickChangeFengDingValue)

	cdphzObj.AddBtnHuangZhuangKouFen = CDPHZ:Find('table/huangZhuangKouFen/kouScore/AddButton')
	cdphzObj.SubtractBtnHuangZhuangKouFen = CDPHZ:Find('table/huangZhuangKouFen/kouScore/SubtractButton')
	cdphzObj.HuangZhuangKouFenValue = CDPHZ:Find('table/huangZhuangKouFen/kouScore/Value')
	message:AddClick(cdphzObj.AddBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)
	message:AddClick(cdphzObj.SubtractBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)

	cdphzObj.ToggleChou0 = CDPHZ:Find('table/chouCard/chouCard0')
	cdphzObj.ToggleChou10 = CDPHZ:Find('table/chouCard/chouCard10')
	cdphzObj.ToggleChou20 = CDPHZ:Find('table/chouCard/chouCard20')
	message:AddClick(cdphzObj.ToggleChou0.gameObject, this.OnClickToggleChou)
	message:AddClick(cdphzObj.ToggleChou10.gameObject, this.OnClickToggleChou)
	message:AddClick(cdphzObj.ToggleChou20.gameObject, this.OnClickToggleChou)

	cdphzObj.ToggleOnNiao = CDPHZ:Find('table/niao/OnNiao')
	cdphzObj.ToggleOffNiao = CDPHZ:Find('table/niao/OffNiao')
	cdphzObj.NiaoValueText = CDPHZ:Find('table/niao/NiaoValue/Value')
	cdphzObj.AddButtonNiao = CDPHZ:Find('table/niao/NiaoValue/AddButton')
	cdphzObj.SubtractButtonNiao = CDPHZ:Find('table/niao/NiaoValue/SubtractButton')
	message:AddClick(cdphzObj.ToggleOnNiao.gameObject, this.OnClickNiao)
	message:AddClick(cdphzObj.ToggleOffNiao.gameObject, this.OnClickNiao)
	message:AddClick(cdphzObj.AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(cdphzObj.SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)

	cdphzObj.ToggleChoiceDouble = CDPHZ:Find('table/choiceDouble/On')
	cdphzObj.ToggleNoChoiceDouble = CDPHZ:Find('table/choiceDouble/Off')
	cdphzObj.DoubleScoreText = CDPHZ:Find('table/choiceDouble/doubleScore/Value')
	cdphzObj.AddDoubleScoreButton = CDPHZ:Find('table/choiceDouble/doubleScore/AddButton')
	cdphzObj.SubtractDoubleScoreButton = CDPHZ:Find('table/choiceDouble/doubleScore/SubtractButton')
	cdphzObj.ToggleMultiple2 = CDPHZ:Find('table/multiple/2')
	cdphzObj.ToggleMultiple3 = CDPHZ:Find('table/multiple/3')
	cdphzObj.ToggleMultiple4 = CDPHZ:Find('table/multiple/4')
	message:AddClick(cdphzObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(cdphzObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(cdphzObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(cdphzObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(cdphzObj.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(cdphzObj.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(cdphzObj.ToggleMultiple4.gameObject, this.OnClickMultiple)

	cdphzObj.ToggleSettlementScoreSelect=CDPHZ:Find('table/settlementScore/select')
	cdphzObj.ToggleFewerScoreTxt=CDPHZ:Find('table/settlementScore/fewerValue/Value')
	cdphzObj.ToggleFewerAddButton=CDPHZ:Find('table/settlementScore/fewerValue/AddButton')
	cdphzObj.ToggleFewerSubtractButton=CDPHZ:Find('table/settlementScore/fewerValue/SubtractButton')
	cdphzObj.ToggleAddScoreTxt=CDPHZ:Find('table/settlementScore/addValue/Value')
	cdphzObj.ToggleAddAddButton=CDPHZ:Find('table/settlementScore/addValue/AddButton')
	cdphzObj.ToggleAddSubtractButton=CDPHZ:Find('table/settlementScore/addValue/SubtractButton')
	message:AddClick(cdphzObj.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(cdphzObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(cdphzObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(cdphzObj.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(cdphzObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)

	cdphzObj.ToggleTrusteeshipNo = CDPHZ:Find('table/DelegateChoose/NoDelegate')
	cdphzObj.ToggleTrusteeship1 = CDPHZ:Find('table/DelegateChoose/Delegate1')
	cdphzObj.ToggleTrusteeship2 = CDPHZ:Find('table/DelegateChoose/Delegate2')
	cdphzObj.ToggleTrusteeship3 = CDPHZ:Find('table/DelegateChoose/Delegate3')
	cdphzObj.ToggleTrusteeship5 = CDPHZ:Find('table/DelegateChoose/Delegate5')
	cdphzObj.ToggleTrusteeshipAll = CDPHZ:Find('table/DelegateCancel/FullRound')
	cdphzObj.ToggleTrusteeshipOne = CDPHZ:Find('table/DelegateCancel/ThisRound')
	cdphzObj.ToggleTrusteeshipThree = CDPHZ:Find('table/DelegateCancel/ThreeRound')
	message:AddClick(cdphzObj.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(cdphzObj.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(cdphzObj.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(cdphzObj.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(cdphzObj.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(cdphzObj.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(cdphzObj.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(cdphzObj.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)

	cdphzObj.ToggleIPcheck = CDPHZ:Find('table/PreventCheat/IPcheck')
	cdphzObj.ToggleGPScheck = CDPHZ:Find('table/PreventCheat/GPScheck')
	message:AddClick(cdphzObj.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(cdphzObj.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end
function this.Refresh()
	print('Refresh_CDPHZ')
	cdphzData.rounds=UnityEngine.PlayerPrefs.GetInt('NewCDPHZrounds', 6)
	cdphzObj.ToggleRound6:GetComponent('UIToggle'):Set(cdphzData.rounds == 6)
	cdphzObj.ToggleRound8:GetComponent('UIToggle'):Set(cdphzData.rounds == 8)
	cdphzObj.ToggleRound10:GetComponent('UIToggle'):Set(cdphzData.rounds == 10)
	cdphzObj.ToggleRound16:GetComponent('UIToggle'):Set(cdphzData.rounds == 16)

	cdphzData.size=UnityEngine.PlayerPrefs.GetInt('NewCDPHZsize', 3)
	cdphzObj.TogglePeopleNum2:GetComponent('UIToggle'):Set(cdphzData.size == 2)
    cdphzObj.TogglePeopleNum3:GetComponent('UIToggle'):Set(cdphzData.size == 3)

	cdphzData.paymentType=UnityEngine.PlayerPrefs.GetInt('NewCDPHZpaymentType', 0)
	cdphzObj.ToggleMasterPay:GetComponent('UIToggle'):Set(cdphzData.paymentType == 0)
	cdphzObj.ToggleWinnerPay:GetComponent('UIToggle'):Set(cdphzData.paymentType == 2)

	cdphzData.randomBanker=UnityEngine.PlayerPrefs.GetInt('NewCDPHZrandomBanker', 0)==1
	cdphzObj.ToggleRandomBanker:GetComponent('UIToggle'):Set(cdphzData.randomBanker)
	cdphzObj.ToggleBankerFrist:GetComponent('UIToggle'):Set(not cdphzData.randomBanker)

	cdphzData.quanMingTang=UnityEngine.PlayerPrefs.GetInt('NewCDPHZquanMingTang', 1)==1
	cdphzObj.Toggleqmt:GetComponent('UIToggle'):Set(cdphzData.quanMingTang)
	cdphzObj.Togglehhd:GetComponent('UIToggle'):Set(not cdphzData.quanMingTang)

	cdphzObj.ToggleShuaHou.parent.gameObject:SetActive(cdphzData.quanMingTang)
	cdphzObj.ToggleHangHangXi.parent.gameObject:SetActive(cdphzData.quanMingTang)
	cdphzObj.ToggleHuangFan.parent.gameObject:SetActive(cdphzData.quanMingTang)
	cdphzObj.ToggleDuiDuiHu.parent.gameObject:SetActive(not cdphzData.quanMingTang)

	cdphzData.shuaHou=UnityEngine.PlayerPrefs.GetInt('NewCDPHZshuaHou', 0)==1
	cdphzObj.ToggleShuaHou:GetComponent('UIToggle'):Set(cdphzData.shuaHou)
	cdphzData.daTuanYuan=UnityEngine.PlayerPrefs.GetInt('NewCDPHZdaTuanYuan', 0)==1
	cdphzObj.ToggleDaTuanYuan:GetComponent('UIToggle'):Set(cdphzData.daTuanYuan)
	cdphzData.tingHu=UnityEngine.PlayerPrefs.GetInt('NewCDPHZtingHu', 0)==1
	cdphzObj.ToggleTingHu:GetComponent('UIToggle'):Set(cdphzData.tingHu)
	cdphzData.hangHangXi=UnityEngine.PlayerPrefs.GetInt('NewCDPHZhangHangXi', 0)==1
	cdphzObj.ToggleHangHangXi:GetComponent('UIToggle'):Set(cdphzData.hangHangXi)
	cdphzObj.ToggleJiaHangHang.parent.gameObject:SetActive(false)
	cdphzData.jiaHangHang=UnityEngine.PlayerPrefs.GetInt('NewCDPHZjiaHangHang', 0)==1
	cdphzObj.ToggleJiaHangHang:GetComponent('UIToggle'):Set(cdphzData.jiaHangHang)
	cdphzData.hong47=UnityEngine.PlayerPrefs.GetInt('NewCDPHZhong47', 0)==1
	cdphzObj.ToggleHong47:GetComponent('UIToggle'):Set(cdphzData.hong47)
	cdphzData.huangFan=UnityEngine.PlayerPrefs.GetInt('NewCDPHZhuangFan', 0)==1
	cdphzObj.ToggleHuangFan:GetComponent('UIToggle'):Set(cdphzData.huangFan)
	cdphzData.duiDuiHu=UnityEngine.PlayerPrefs.GetInt('NewCDPHZduiDuiHu', 0)==1
	cdphzObj.ToggleDuiDuiHu:GetComponent('UIToggle'):Set(cdphzData.duiDuiHu)

	cdphzData.bottomScore=UnityEngine.PlayerPrefs.GetInt('NewCDPHZbottomScore', 1)
	cdphzObj.DiFenTunValue:GetComponent("UILabel").text = cdphzData.bottomScore..'分'

	cdphzData.maxHuXi=UnityEngine.PlayerPrefs.GetInt('NewCDPHZmaxHuXi', 0)
	cdphzObj.FengDingValue:GetComponent("UILabel").text = cdphzData.maxHuXi == 0 and '不封顶' or cdphzData.maxHuXi..'分'

	cdphzData.huangZhuangFen=UnityEngine.PlayerPrefs.GetInt('NewCDPHZhuangZhuangFen', 0) 
	cdphzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = cdphzData.huangZhuangFen == 0 and '不扣分' or '扣'..cdphzData.huangZhuangFen..'分'

	cdphzData.chou = UnityEngine.PlayerPrefs.GetInt('NewCDPHZchou', 20)
	cdphzObj.ToggleChou0:GetComponent('UIToggle'):Set(cdphzData.chou == 0)
	cdphzObj.ToggleChou10:GetComponent('UIToggle'):Set(cdphzData.chou == 10)
	cdphzObj.ToggleChou20:GetComponent('UIToggle'):Set(cdphzData.chou == 20)
	cdphzObj.ToggleChou0.parent.gameObject:SetActive(cdphzData.size == 2)
	
	cdphzData.niao=UnityEngine.PlayerPrefs.GetInt('NewCDPHZniao', 0)==1
	cdphzData.niaoValue=UnityEngine.PlayerPrefs.GetInt('NewCDPHZniaoValue', 10)
	cdphzObj.ToggleOnNiao:GetComponent('UIToggle'):Set(cdphzData.niao)
	cdphzObj.ToggleOffNiao:GetComponent('UIToggle'):Set(not cdphzData.niao)
	cdphzObj.NiaoValueText.parent.gameObject:SetActive(cdphzData.niao)
    cdphzObj.NiaoValueText:GetComponent('UILabel').text = cdphzData.niaoValue.."分"

	cdphzData.choiceDouble=UnityEngine.PlayerPrefs.GetInt('NewCDPHZchoiceDouble', 0)==1
	cdphzData.doubleScore=UnityEngine.PlayerPrefs.GetInt('NewCDPHZdoubleScore', 10)
	cdphzData.multiple=UnityEngine.PlayerPrefs.GetInt('NewCDPcdphzultiple', 2)
	cdphzObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(cdphzData.choiceDouble)
	cdphzObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not cdphzData.choiceDouble)
	cdphzObj.DoubleScoreText.parent.gameObject:SetActive(cdphzData.choiceDouble)
	if cdphzData.doubleScore == 0 then
		cdphzObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		cdphzObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..cdphzData.doubleScore..'分'
	end
	cdphzObj.ToggleChoiceDouble.parent.gameObject:SetActive(cdphzData.size == 2)
	cdphzObj.ToggleMultiple2:GetComponent('UIToggle'):Set(cdphzData.multiple == 2)
	cdphzObj.ToggleMultiple3:GetComponent('UIToggle'):Set(cdphzData.multiple == 3)
	cdphzObj.ToggleMultiple4:GetComponent('UIToggle'):Set(cdphzData.multiple == 4)
	cdphzObj.ToggleMultiple2.parent.gameObject:SetActive(cdphzData.choiceDouble and  cdphzData.size == 2)

	cdphzData.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewCDPHZisSettlementScore', 0)==1
	cdphzData.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewCDPHZfewerValue', 10)
	cdphzData.addValue=UnityEngine.PlayerPrefs.GetInt('NewCDPHZaddValue', 10)
	cdphzObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(cdphzData.size==2)
	cdphzObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(cdphzData.isSettlementScore)
	cdphzObj.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	cdphzObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = cdphzData.fewerValue
	cdphzObj.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	cdphzObj.ToggleAddScoreTxt:GetComponent('UILabel').text = cdphzData.addValue

	cdphzData.trusteeshipTime=UnityEngine.PlayerPrefs.GetInt('NewCDPHZtrusteeshipTime', 0)
	cdphzData.trusteeshipType = UnityEngine.PlayerPrefs.GetInt('NewCDPHZtrusteeshipType', 0) == 1
	cdphzData.trusteeshipRound = UnityEngine.PlayerPrefs.GetInt('NewCDPHZtrusteeshipRound', 0)
	cdphzObj.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(cdphzData.trusteeshipTime == 0)
	cdphzObj.ToggleTrusteeship1:GetComponent('UIToggle'):Set(cdphzData.trusteeshipTime == 1)
	cdphzObj.ToggleTrusteeship2:GetComponent('UIToggle'):Set(cdphzData.trusteeshipTime == 2)
	cdphzObj.ToggleTrusteeship3:GetComponent('UIToggle'):Set(cdphzData.trusteeshipTime == 3)
	cdphzObj.ToggleTrusteeship5:GetComponent('UIToggle'):Set(cdphzData.trusteeshipTime == 5)
	cdphzObj.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(cdphzData.trusteeshipType)
	cdphzObj.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not cdphzData.trusteeshipType and cdphzData.trusteeshipRound == 0)
	cdphzObj.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(cdphzData.trusteeshipRound == 3)
	cdphzObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(cdphzData.trusteeshipTime ~= 0)

	cdphzData.openIp=UnityEngine.PlayerPrefs.GetInt('CDPHZcheckIP', 0)==1
	cdphzData.openGps=UnityEngine.PlayerPrefs.GetInt('CDPHZcheckGPS', 0)==1
	cdphzObj.ToggleIPcheck.parent.gameObject:SetActive(cdphzData.size > 2 and CONST.IPcheckOn)
	cdphzObj.ToggleIPcheck:GetComponent('UIToggle'):Set(cdphzData.openIp)
	cdphzObj.ToggleGPScheck:GetComponent('UIToggle'):Set(cdphzData.openGps)

	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.CDPHZ,cdphzData.rounds,nil,nil)
	CDPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end
--获取当前设置
function this.GetConfig()
	local moneyLess = false
    
    if ((cdphzData.rounds == 6 or cdphzData.rounds == 8) and info_login.balance < 2) or
		   (cdphzData.rounds == 10 and info_login.balance < 3 )  or 
		   (cdphzData.rounds == 16 and info_login.balance < 4 ) then
			moneyLess = true
		end
    local body = {}
    body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.CDPHZ)
	body.rounds = cdphzData.rounds
    body.size = cdphzData.size
    body.paymentType = cdphzData.paymentType
	body.randomBanker = cdphzData.randomBanker
	body.niao = cdphzData.niao
	body.niaoValue =  cdphzData.niao and cdphzData.niaoValue or 0

	if cdphzData.size == 2 then
        body.choiceDouble = cdphzData.choiceDouble
        body.doubleScore = cdphzData.doubleScore
        body.multiple = cdphzData.multiple
	end
	if cdphzData.size == 2 then
		body.resultScore = cdphzData.isSettlementScore
		if cdphzData.isSettlementScore then
			body.resultLowerScore=cdphzData.fewerValue
			body.resultAddScore=cdphzData.addValue
		end
		cdphzData.openIp=false
		cdphzData.openGps=false
	end
    body.trusteeship = cdphzData.trusteeshipTime*60;
    body.trusteeshipDissolve = cdphzData.trusteeshipType;
	body.trusteeshipRound = cdphzData.trusteeshipRound;
	
	body.maxHuXi = cdphzData.maxHuXi
	body.huangZhuangFen = cdphzData.huangZhuangFen
	body.chou = cdphzData.size == 2 and cdphzData.chou or 0

    body.tianDiHu = true
    body.heiHongHu = true
    body.qiHuHuXi = 15
    body.tunXi = 3
    body.fanXing = false
	body.quanMingTang = cdphzData.quanMingTang
	if body.quanMingTang then
		body.shuaHou = cdphzData.shuaHou
		body.daTuanYuan = cdphzData.daTuanYuan
		body.tingHu = cdphzData.tingHu
		body.hangHangXi = cdphzData.hangHangXi
		--body.jiaHangHang = cdphzData.jiaHangHang		
		body.hong47	= cdphzData.hong47			
		body.huangFan = cdphzData.huangFan
	else
		body.duiDuiHu = cdphzData.duiDuiHu
	end
	body.bottomScore = cdphzData.bottomScore
	body.openIp	 = cdphzData.openIp
	body.openGps = cdphzData.openGps
	
    return moneyLess,body;
end

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
    if cdphzObj.ToggleRound6.gameObject == go then
		cdphzData.rounds = 6
	elseif cdphzObj.ToggleRound8.gameObject == go then
        cdphzData.rounds = 8
    elseif cdphzObj.ToggleRound10.gameObject == go then
        cdphzData.rounds = 10
    elseif cdphzObj.ToggleRound16.gameObject == go then
        cdphzData.rounds = 16
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.CDPHZ,cdphzData.rounds,nil,nil)
    UnityEngine.PlayerPrefs.SetInt('NewCDPHZrounds', cdphzData.rounds)
end

function this.OnClickTogglePlayerNum(go)
	AudioManager.Instance:PlayAudio('btn')
    if cdphzObj.TogglePeopleNum2.gameObject == go then
        cdphzData.size = 2
    elseif cdphzObj.TogglePeopleNum3.gameObject == go then
        cdphzData.size = 3
	end
	cdphzObj.ToggleIPcheck.parent.gameObject:SetActive(cdphzData.size > 2 and CONST.IPcheckOn)
	UnityEngine.PlayerPrefs.SetInt('NewCDPHZsize', cdphzData.size)
	cdphzObj.ToggleNoChoiceDouble.parent.gameObject:SetActive(cdphzData.size==2)
    cdphzObj.ToggleMultiple2.parent.gameObject:SetActive(cdphzData.choiceDouble and cdphzData.size==2)
	cdphzObj.DoubleScoreText.parent.gameObject:SetActive(cdphzData.choiceDouble)
	cdphzObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(cdphzData.size==2)
	cdphzObj.ToggleChou0.parent.gameObject:SetActive(cdphzData.size==2)
    CDPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if cdphzObj.ToggleMasterPay.gameObject == go then
        cdphzData.paymentType=0
    elseif cdphzObj.ToggleWinnerPay.gameObject == go then
		cdphzData.paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewCDPHZpaymentType', cdphzData.paymentType)
end

function this.OnClickRandomBanker(go)
    AudioManager.Instance:PlayAudio('btn')
    if cdphzObj.ToggleRandomBanker.gameObject == go then
        cdphzData.randomBanker = true
    elseif cdphzObj.ToggleBankerFrist.gameObject == go then
        cdphzData.randomBanker = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewCDPHZrandomBanker', cdphzData.randomBanker and 1 or 0)
end

function this.OnClickToggleMingTang(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == cdphzObj.Toggleqmt.gameObject then
		cdphzData.quanMingTang = true
    else
        cdphzData.quanMingTang = false
	end
	cdphzObj.ToggleShuaHou.parent.gameObject:SetActive(cdphzData.quanMingTang)
	cdphzObj.ToggleHangHangXi.parent.gameObject:SetActive(cdphzData.quanMingTang)
	cdphzObj.ToggleHuangFan.parent.gameObject:SetActive(cdphzData.quanMingTang)
	cdphzObj.ToggleDuiDuiHu.parent.gameObject:SetActive(not cdphzData.quanMingTang)
	CDPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
	UnityEngine.PlayerPrefs.SetInt('NewCDPHZquanMingTang', cdphzData.quanMingTang and 1 or 0)
end



function this.OnClickTogglePlayCDPHZ(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == cdphzObj.ToggleShuaHou.gameObject then
		cdphzData.shuaHou = cdphzObj.ToggleShuaHou:GetComponent('UIToggle').value and 1 or 0
		UnityEngine.PlayerPrefs.SetInt('NewCDPHZshuaHou', cdphzData.shuaHou)
	elseif go == cdphzObj.ToggleDaTuanYuan.gameObject then
		cdphzData.daTuanYuan = cdphzObj.ToggleDaTuanYuan:GetComponent('UIToggle').value and 1 or 0
		UnityEngine.PlayerPrefs.SetInt('NewCDPHZdaTuanYuan', cdphzData.daTuanYuan)
	elseif go == cdphzObj.ToggleTingHu.gameObject then
		cdphzData.tingHu = cdphzObj.ToggleTingHu:GetComponent('UIToggle').value and 1 or 0
		UnityEngine.PlayerPrefs.SetInt('NewCDPHZtingHu', cdphzData.tingHu)
	elseif go == cdphzObj.ToggleHangHangXi.gameObject then
		cdphzData.hangHangXi = cdphzObj.ToggleHangHangXi:GetComponent('UIToggle').value and 1 or 0
		UnityEngine.PlayerPrefs.SetInt('NewCDPHZhangHangXi', cdphzData.hangHangXi)
	elseif go == cdphzObj.ToggleJiaHangHang.gameObject then
		cdphzData.jiaHangHang = cdphzObj.ToggleJiaHangHang:GetComponent('UIToggle').value and 1 or 0
		UnityEngine.PlayerPrefs.SetInt('NewCDPHZjiaHangHang', cdphzData.jiaHangHang)
	elseif go == cdphzObj.ToggleHong47.gameObject then
		cdphzData.hong47 = cdphzObj.ToggleHong47:GetComponent('UIToggle').value and 1 or 0
		UnityEngine.PlayerPrefs.SetInt('NewCDPHZhong47', cdphzData.hong47)
	elseif go == cdphzObj.ToggleHuangFan.gameObject then
		cdphzData.huangFan = cdphzObj.ToggleHuangFan:GetComponent('UIToggle').value and 1 or 0
		UnityEngine.PlayerPrefs.SetInt('NewCDPHZhuangFan', cdphzData.huangFan)
	elseif go == cdphzObj.ToggleDuiDuiHu.gameObject then
		cdphzData.duiDuiHu = cdphzObj.ToggleDuiDuiHu:GetComponent('UIToggle').value and 1 or 0
		UnityEngine.PlayerPrefs.SetInt('NewCDPHZduiDuiHu', cdphzData.duiDuiHu)
	end
end

function this.OnClickChangeDiFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if cdphzObj.AddBtnDiFen.gameObject == go then
		cdphzData.bottomScore = cdphzData.bottomScore + 1
		if cdphzData.bottomScore > 10 then
			cdphzData.bottomScore = 10
		end
    elseif cdphzObj.SubtractBtnDiFen.gameObject == go then
        cdphzData.bottomScore = cdphzData.bottomScore - 1
		if cdphzData.bottomScore < 1 then
			cdphzData.bottomScore = 1
		end
	end
	cdphzObj.DiFenTunValue:GetComponent("UILabel").text = cdphzData.bottomScore..'分'
    UnityEngine.PlayerPrefs.SetInt('NewCDPHZbottomScore', cdphzData.bottomScore)
end

function this.OnClickChangeFengDingValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if cdphzObj.AddBtnFengDing.gameObject == go then
        if cdphzData.maxHuXi ~= 0 then
            cdphzData.maxHuXi = cdphzData.maxHuXi + 50
            if cdphzData.maxHuXi > 500 then
                cdphzData.maxHuXi = 0
            end
        end
    else
        if cdphzData.maxHuXi == 0 then
            cdphzData.maxHuXi = 500
        else
            cdphzData.maxHuXi = cdphzData.maxHuXi - 50
            if cdphzData.maxHuXi < 50 then
                cdphzData.maxHuXi = 50
            end
        end
    end
	cdphzObj.FengDingValue:GetComponent("UILabel").text = cdphzData.maxHuXi == 0 and '不封顶' or cdphzData.maxHuXi..'分'
	UnityEngine.PlayerPrefs.SetInt('NewCDPHZmaxHuXi', cdphzData.maxHuXi)
end

function this.OnClickChangeHuangZhuangKouFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if cdphzObj.AddBtnHuangZhuangKouFen.gameObject == go then
		cdphzData.huangZhuangFen = cdphzData.huangZhuangFen + 1
		if cdphzData.huangZhuangFen > 10 then
			cdphzData.huangZhuangFen = 10
		end
    else
		cdphzData.huangZhuangFen = cdphzData.huangZhuangFen - 1
		if cdphzData.huangZhuangFen < 0 then
			cdphzData.huangZhuangFen = 0
		end
    end
	cdphzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = cdphzData.huangZhuangFen == 0 and '不扣分' or '扣'..cdphzData.huangZhuangFen..'分'
	UnityEngine.PlayerPrefs.SetInt('NewCDPHZhuangZhuangFen', cdphzData.huangZhuangFen)
end

function this.OnClickToggleChou(go)
	AudioManager.Instance:PlayAudio('btn')
	if cdphzObj.ToggleChou0.gameObject == go then
        cdphzData.chou=0
    elseif cdphzObj.ToggleChou10.gameObject == go then
        cdphzData.chou=10
    elseif cdphzObj.ToggleChou20.gameObject == go then
        cdphzData.chou=20
	end
	UnityEngine.PlayerPrefs.SetInt('NewCDPHZchou', cdphzData.chou)
end

function this.OnClickNiao(go)
	AudioManager.Instance:PlayAudio('btn')
	if cdphzObj.ToggleOnNiao.gameObject == go then
		cdphzData.niao = true
	elseif cdphzObj.ToggleOffNiao.gameObject == go then
		cdphzData.niao = false
	end
	cdphzObj.NiaoValueText.parent.gameObject:SetActive(cdphzData.niao)
	UnityEngine.PlayerPrefs.SetInt('NewCDPHZniao', cdphzData.niao and 1 or 0)
end

function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if cdphzObj.AddButtonNiao.gameObject == go then
		cdphzData.niaoValue = cdphzData.niaoValue + 10
		if cdphzData.niaoValue > 100 then
			cdphzData.niaoValue = 100
		end
	elseif cdphzObj.SubtractButtonNiao.gameObject == go then
		cdphzData.niaoValue = cdphzData.niaoValue - 10
		if cdphzData.niaoValue < 10 then
			cdphzData.niaoValue = 10
		end
	end
	cdphzObj.NiaoValueText:GetComponent('UILabel').text = cdphzData.niaoValue.."分"
	UnityEngine.PlayerPrefs.SetInt('NewCDPHZniaoValue', cdphzData.niaoValue)
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if cdphzObj.ToggleTrusteeshipNo.gameObject == go then
        cdphzData.trusteeshipTime = 0
    elseif cdphzObj.ToggleTrusteeship1.gameObject == go then
        cdphzData.trusteeshipTime = 1
	elseif cdphzObj.ToggleTrusteeship2.gameObject == go then
		cdphzData.trusteeshipTime = 2
	elseif cdphzObj.ToggleTrusteeship3.gameObject == go then
        cdphzData.trusteeshipTime = 3
    elseif cdphzObj.ToggleTrusteeship5.gameObject == go then
        cdphzData.trusteeshipTime = 5
    end
    UnityEngine.PlayerPrefs.SetInt('NewCDPHZtrusteeshipTime', cdphzData.trusteeshipTime)
	cdphzObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(cdphzData.trusteeshipTime ~= 0)
	CDPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if cdphzObj.ToggleTrusteeshipOne.gameObject == go then
        cdphzData.trusteeshipType = true
		cdphzData.trusteeshipRound = 0;
    elseif cdphzObj.ToggleTrusteeshipAll.gameObject == go then
        cdphzData.trusteeshipType = false
		cdphzData.trusteeshipRound = 0;
	elseif cdphzObj.ToggleTrusteeshipThree.gameObject == go then
		cdphzData.trusteeshipRound = 3;
		cdphzData.trusteeshipType = false;
    end
    UnityEngine.PlayerPrefs.SetInt('NewCDPHZtrusteeshipType',cdphzData.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewCDPHZtrusteeshipRound',cdphzData.trusteeshipRound)
end

function this.OnClickChoiceDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if cdphzObj.ToggleChoiceDouble.gameObject == go then
        cdphzData.choiceDouble = true
    elseif cdphzObj.ToggleNoChoiceDouble.gameObject == go then
        cdphzData.choiceDouble = false
    end
    cdphzObj.DoubleScoreText.parent.gameObject:SetActive(cdphzData.choiceDouble)
    cdphzObj.ToggleMultiple2.parent.gameObject:SetActive(cdphzData.choiceDouble)
    CDPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
    UnityEngine.PlayerPrefs.SetInt('NewCDPHZchoiceDouble', cdphzData.choiceDouble and 1 or 0)
end

function this.OnClickChangeDoubleScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if cdphzObj.AddDoubleScoreButton.gameObject == go then
        if cdphzData.doubleScore ~= 0 then
            cdphzData.doubleScore = cdphzData.doubleScore + 1
            if cdphzData.doubleScore > 100 then
                cdphzData.doubleScore = 0
            end
        end
    else
        if cdphzData.doubleScore == 0 then
            cdphzData.doubleScore = 100
        else
            cdphzData.doubleScore = cdphzData.doubleScore - 1
            if cdphzData.doubleScore < 1 then
                cdphzData.doubleScore = 1
            end
        end
    end
    if cdphzData.doubleScore == 0 then
        cdphzObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
    else
        cdphzObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..cdphzData.doubleScore..'分'
    end
    UnityEngine.PlayerPrefs.SetInt('NewCDPHZdoubleScore', cdphzData.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
    if cdphzObj.ToggleMultiple2.gameObject == go then
        cdphzData.multiple=2
    elseif cdphzObj.ToggleMultiple3.gameObject == go then
        cdphzData.multiple=3
    elseif cdphzObj.ToggleMultiple4.gameObject == go then
        cdphzData.multiple=4
    end
    UnityEngine.PlayerPrefs.SetInt('NewCDPcdphzultiple', cdphzData.multiple)
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    cdphzData.isSettlementScore= cdphzObj.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewCDPHZisSettlementScore', cdphzData.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if cdphzObj.ToggleFewerAddButton.gameObject == go then
		cdphzData.fewerValue = cdphzData.fewerValue + 1
		if cdphzData.fewerValue > 100 then
			cdphzData.fewerValue = 100
		end
    elseif cdphzObj.ToggleFewerSubtractButton.gameObject == go then
		cdphzData.fewerValue = cdphzData.fewerValue - 1
		if cdphzData.fewerValue < 1 then
			cdphzData.fewerValue = 1
		end
	end
	cdphzObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = cdphzData.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewCDPHZfewerValue', cdphzData.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if cdphzObj.ToggleAddAddButton.gameObject == go then
		cdphzData.addValue = cdphzData.addValue + 1
		if cdphzData.addValue > 100 then
			cdphzData.addValue = 100
		end
    elseif cdphzObj.ToggleAddSubtractButton.gameObject == go then
		cdphzData.addValue = cdphzData.addValue - 1
		if cdphzData.addValue < 1 then
			cdphzData.addValue = 1
		end
	end
	cdphzObj.ToggleAddScoreTxt:GetComponent('UILabel').text = cdphzData.addValue
	UnityEngine.PlayerPrefs.SetInt('NewCDPHZaddValue', cdphzData.addValue)
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if cdphzObj.ToggleIPcheck.gameObject == go then
		cdphzData.openIp = cdphzObj.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('CDPHZcheckIP', cdphzData.openIp and 1 or 0)
	elseif cdphzObj.ToggleGPScheck.gameObject == go then
		cdphzData.openGps = cdphzObj.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('CDPHZcheckGPS', cdphzData.openGps and 1 or 0)
	end
end

return this