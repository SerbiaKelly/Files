local this = {}

local XTPHZ
local payLabel

local xtphzData = {}
local xtphzObj = {}

function this.Init(grid,message)
	print('Init_XTPHZ')
	XTPHZ = grid
	payLabel = message.transform:Find('diamond/pay_label')

	xtphzObj.ToggleRound6 = XTPHZ:Find('table/round/round6')
	xtphzObj.ToggleRound8 = XTPHZ:Find('table/round/round8')
	xtphzObj.ToggleRound10 = XTPHZ:Find('table/round/round10')
	xtphzObj.ToggleRound16 = XTPHZ:Find('table/round/round16')
	message:AddClick(xtphzObj.ToggleRound6.gameObject, this.OnClickToggleRound)
	message:AddClick(xtphzObj.ToggleRound8.gameObject, this.OnClickToggleRound)
	message:AddClick(xtphzObj.ToggleRound10.gameObject, this.OnClickToggleRound)
	message:AddClick(xtphzObj.ToggleRound16.gameObject, this.OnClickToggleRound)

	xtphzObj.TogglePeopleNum2 = XTPHZ:Find('table/num/num2')
	xtphzObj.TogglePeopleNum3 = XTPHZ:Find('table/num/num3')
	message:AddClick(xtphzObj.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(xtphzObj.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)

	xtphzObj.ToggleMasterPay = XTPHZ:Find('table/pay/master')
	xtphzObj.ToggleWinnerPay = XTPHZ:Find('table/pay/win')
	message:AddClick(xtphzObj.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(xtphzObj.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)

	xtphzObj.ToggleRandomBanker = XTPHZ:Find('table/randomBanker/Auto')
	xtphzObj.ToggleBankerFrist = XTPHZ:Find('table/randomBanker/Frist')
	message:AddClick(xtphzObj.ToggleRandomBanker.gameObject, this.OnClickRandomBanker)
	message:AddClick(xtphzObj.ToggleBankerFrist.gameObject, this.OnClickRandomBanker)

	xtphzObj.ToggleQiHu10 = XTPHZ:Find('table/qiHu/qiHu10')
	xtphzObj.ToggleQiHu15 = XTPHZ:Find('table/qiHu/qiHu15')
	message:AddClick(xtphzObj.ToggleQiHu10.gameObject, this.OnClickQiHuScore)
	message:AddClick(xtphzObj.ToggleQiHu15.gameObject, this.OnClickQiHuScore)

	xtphzObj.ToggleSanXiYiTun = XTPHZ:Find('table/suanFen/tunMode31')
	xtphzObj.ToggleYiXiYiTun = XTPHZ:Find('table/suanFen/tunMode11')
	xtphzObj.ToggleFengSanJinSan = XTPHZ:Find('table/suanFen/tunMode13')
	message:AddClick(xtphzObj.ToggleSanXiYiTun.gameObject, this.OnClickHuXiSuanFen)
	message:AddClick(xtphzObj.ToggleYiXiYiTun.gameObject, this.OnClickHuXiSuanFen)
	message:AddClick(xtphzObj.ToggleFengSanJinSan.gameObject, this.OnClickHuXiSuanFen)

	xtphzObj.AddBtnDiFen = XTPHZ:Find('table/diFen/diFenScore/AddButton')
	xtphzObj.SubtractBtnDiFen = XTPHZ:Find('table/diFen/diFenScore/SubtractButton')
	xtphzObj.DiFenTunValue = XTPHZ:Find('table/diFen/diFenScore/Value')
	message:AddClick(xtphzObj.AddBtnDiFen.gameObject, this.OnClickChangeDiFenValue)
	message:AddClick(xtphzObj.SubtractBtnDiFen.gameObject, this.OnClickChangeDiFenValue)

	xtphzObj.ToggleYiWuShi = XTPHZ:Find('table/play1/yiWuShi')
	xtphzObj.ToggleShiZhongBuLiang = XTPHZ:Find('table/play1/shiZhongBuLiang')
	xtphzObj.ToggleHu30FangBei = XTPHZ:Find('table/play1/hu30FangBei')
	xtphzObj.ToggleTianDiHu = XTPHZ:Find('table/play2/tianDiHu')
	xtphzObj.TogglePengPengHu = XTPHZ:Find('table/play2/pengPengHu')
	xtphzObj.ToggleDaXiaoZiHu = XTPHZ:Find('table/play2/daXiaoZiHu')
	xtphzObj.ToggleYiDianHong = XTPHZ:Find('table/play3/yiDianHong')
	xtphzObj.ToggleHeiHongHu = XTPHZ:Find('table/play3/heiHongHu')
	xtphzObj.ToggleHong13 = XTPHZ:Find('table/play3/hong13')
	xtphzObj.ToggleCanHuZiMo = XTPHZ:Find('table/play4/canHuZiMo')
	xtphzObj.ToggleCanAnWei = XTPHZ:Find('table/play4/canAnWei')
	xtphzObj.ToggleChouWeiLiang = XTPHZ:Find('table/play4/chouWeiLiang')
	message:AddClick(xtphzObj.ToggleYiWuShi.gameObject, this.OnClickToggleXTPHZPlay)
	message:AddClick(xtphzObj.ToggleShiZhongBuLiang.gameObject, this.OnClickToggleXTPHZPlay)
	message:AddClick(xtphzObj.ToggleHu30FangBei.gameObject, this.OnClickToggleXTPHZPlay)
	message:AddClick(xtphzObj.ToggleTianDiHu.gameObject, this.OnClickToggleXTPHZPlay)
	message:AddClick(xtphzObj.TogglePengPengHu.gameObject, this.OnClickToggleXTPHZPlay)
	message:AddClick(xtphzObj.ToggleDaXiaoZiHu.gameObject, this.OnClickToggleXTPHZPlay)
	message:AddClick(xtphzObj.ToggleYiDianHong.gameObject, this.OnClickToggleXTPHZPlay)
	message:AddClick(xtphzObj.ToggleHeiHongHu.gameObject, this.OnClickToggleXTPHZPlay)
	message:AddClick(xtphzObj.ToggleHong13.gameObject, this.OnClickToggleXTPHZPlay)
	message:AddClick(xtphzObj.ToggleCanHuZiMo.gameObject, this.OnClickToggleXTPHZPlay)
	message:AddClick(xtphzObj.ToggleCanAnWei.gameObject, this.OnClickToggleXTPHZPlay)
	message:AddClick(xtphzObj.ToggleChouWeiLiang.gameObject, this.OnClickToggleXTPHZPlay)

	xtphzObj.ToggleFanShuChen = XTPHZ:Find('table/fanShu/fanShuChen')
	xtphzObj.ToggleFanShuJia = XTPHZ:Find('table/fanShu/fanShuJia')
	xtphzObj.TogglefanShuYiBei = XTPHZ:Find('table/fanShu/fanShuYiBei')
	message:AddClick(xtphzObj.ToggleFanShuChen.gameObject, this.OnClickToggleFanShuSuanFen)
	message:AddClick(xtphzObj.ToggleFanShuJia.gameObject, this.OnClickToggleFanShuSuanFen)
	message:AddClick(xtphzObj.TogglefanShuYiBei.gameObject, this.OnClickToggleFanShuSuanFen)

	xtphzObj.AddBtnFengDing = XTPHZ:Find('table/fengDing/fengDingScore/AddButton')
	xtphzObj.SubtractBtnFengDing = XTPHZ:Find('table/fengDing/fengDingScore/SubtractButton')
	xtphzObj.FengDingValue = XTPHZ:Find('table/fengDing/fengDingScore/Value')
	message:AddClick(xtphzObj.AddBtnFengDing.gameObject, this.OnClickChangeFengDingValue)
	message:AddClick(xtphzObj.SubtractBtnFengDing.gameObject, this.OnClickChangeFengDingValue)

	xtphzObj.AddBtnHuangZhuangKouFen = XTPHZ:Find('table/huangZhuangKouFen/kouScore/AddButton')
	xtphzObj.SubtractBtnHuangZhuangKouFen = XTPHZ:Find('table/huangZhuangKouFen/kouScore/SubtractButton')
	xtphzObj.HuangZhuangKouFenValue = XTPHZ:Find('table/huangZhuangKouFen/kouScore/Value')
	message:AddClick(xtphzObj.AddBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)
	message:AddClick(xtphzObj.SubtractBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)

	xtphzObj.ToggleChou0 = XTPHZ:Find('table/chouCard/chouCard0')
	xtphzObj.ToggleChou10 = XTPHZ:Find('table/chouCard/chouCard10')
	xtphzObj.ToggleChou20 = XTPHZ:Find('table/chouCard/chouCard20')
	message:AddClick(xtphzObj.ToggleChou0.gameObject, this.OnClickToggleChou)
	message:AddClick(xtphzObj.ToggleChou10.gameObject, this.OnClickToggleChou)
	message:AddClick(xtphzObj.ToggleChou20.gameObject, this.OnClickToggleChou)

	xtphzObj.ToggleOnNiao = XTPHZ:Find('table/niao/OnNiao')
	xtphzObj.ToggleOffNiao = XTPHZ:Find('table/niao/OffNiao')
	xtphzObj.NiaoValueText = XTPHZ:Find('table/niao/NiaoValue/Value')
	xtphzObj.AddButtonNiao = XTPHZ:Find('table/niao/NiaoValue/AddButton')
	xtphzObj.SubtractButtonNiao = XTPHZ:Find('table/niao/NiaoValue/SubtractButton')
	message:AddClick(xtphzObj.ToggleOnNiao.gameObject, this.OnClickNiao)
	message:AddClick(xtphzObj.ToggleOffNiao.gameObject, this.OnClickNiao)
	message:AddClick(xtphzObj.AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(xtphzObj.SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)

	xtphzObj.ToggleChoiceDouble = XTPHZ:Find('table/choiceDouble/On')
	xtphzObj.ToggleNoChoiceDouble = XTPHZ:Find('table/choiceDouble/Off')
	xtphzObj.DoubleScoreText = XTPHZ:Find('table/choiceDouble/doubleScore/Value')
	xtphzObj.AddDoubleScoreButton = XTPHZ:Find('table/choiceDouble/doubleScore/AddButton')
	xtphzObj.SubtractDoubleScoreButton = XTPHZ:Find('table/choiceDouble/doubleScore/SubtractButton')
	xtphzObj.ToggleMultiple2 = XTPHZ:Find('table/multiple/2')
	xtphzObj.ToggleMultiple3 = XTPHZ:Find('table/multiple/3')
	xtphzObj.ToggleMultiple4 = XTPHZ:Find('table/multiple/4')
	message:AddClick(xtphzObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(xtphzObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(xtphzObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(xtphzObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(xtphzObj.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(xtphzObj.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(xtphzObj.ToggleMultiple4.gameObject, this.OnClickMultiple)

	xtphzObj.ToggleSettlementScoreSelect=XTPHZ:Find('table/settlementScore/select')
	xtphzObj.ToggleFewerScoreTxt=XTPHZ:Find('table/settlementScore/fewerValue/Value')
	xtphzObj.ToggleFewerAddButton=XTPHZ:Find('table/settlementScore/fewerValue/AddButton')
	xtphzObj.ToggleFewerSubtractButton=XTPHZ:Find('table/settlementScore/fewerValue/SubtractButton')
	xtphzObj.ToggleAddScoreTxt=XTPHZ:Find('table/settlementScore/addValue/Value')
	xtphzObj.ToggleAddAddButton=XTPHZ:Find('table/settlementScore/addValue/AddButton')
	xtphzObj.ToggleAddSubtractButton=XTPHZ:Find('table/settlementScore/addValue/SubtractButton')
	
	message:AddClick(xtphzObj.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(xtphzObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(xtphzObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(xtphzObj.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(xtphzObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)
	
	xtphzObj.ToggleTrusteeshipNo = XTPHZ:Find('table/DelegateChoose/NoDelegate')
	xtphzObj.ToggleTrusteeship1 = XTPHZ:Find('table/DelegateChoose/Delegate1')
	xtphzObj.ToggleTrusteeship2 = XTPHZ:Find('table/DelegateChoose/Delegate2')
	xtphzObj.ToggleTrusteeship3 = XTPHZ:Find('table/DelegateChoose/Delegate3')
	xtphzObj.ToggleTrusteeship5 = XTPHZ:Find('table/DelegateChoose1/Delegate5')
	message:AddClick(xtphzObj.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(xtphzObj.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(xtphzObj.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(xtphzObj.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(xtphzObj.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)

	xtphzObj.ToggleTrusteeshipAll = XTPHZ:Find('table/DelegateCancel/FullRound')
	xtphzObj.ToggleTrusteeshipOne = XTPHZ:Find('table/DelegateCancel/ThisRound')
	xtphzObj.ToggleTrusteeshipThree = XTPHZ:Find('table/DelegateCancel/ThreeRound')
	message:AddClick(xtphzObj.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(xtphzObj.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(xtphzObj.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)
	
	xtphzObj.ToggleIPcheck = XTPHZ:Find('table/PreventCheat/IPcheck')
	xtphzObj.ToggleGPScheck = XTPHZ:Find('table/PreventCheat/GPScheck')
	message:AddClick(xtphzObj.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(xtphzObj.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end
function this.Refresh()
	print('Refresh_XTPHZ')
	xtphzData.rounds=UnityEngine.PlayerPrefs.GetInt('NewXTPHZrounds', 8)
	xtphzObj.ToggleRound6:GetComponent('UIToggle'):Set(xtphzData.rounds == 6)
	xtphzObj.ToggleRound8:GetComponent('UIToggle'):Set(xtphzData.rounds == 8)
	xtphzObj.ToggleRound10:GetComponent('UIToggle'):Set(xtphzData.rounds == 10)
	xtphzObj.ToggleRound16:GetComponent('UIToggle'):Set(xtphzData.rounds == 16)

	xtphzData.size=UnityEngine.PlayerPrefs.GetInt('NewXTPHZsize', 2)
	xtphzObj.TogglePeopleNum2:GetComponent('UIToggle'):Set(xtphzData.size == 2)
    xtphzObj.TogglePeopleNum3:GetComponent('UIToggle'):Set(xtphzData.size == 3)

	xtphzData.paymentType=UnityEngine.PlayerPrefs.GetInt('NewXTPHZpaymentType', 0)
	xtphzObj.ToggleMasterPay:GetComponent('UIToggle'):Set(xtphzData.paymentType == 0)
	xtphzObj.ToggleWinnerPay:GetComponent('UIToggle'):Set(xtphzData.paymentType == 2)

	xtphzData.randomBanker=UnityEngine.PlayerPrefs.GetInt('NewXTPHZrandomBanker', 0)==1
	xtphzObj.ToggleRandomBanker:GetComponent('UIToggle'):Set(xtphzData.randomBanker)
	xtphzObj.ToggleBankerFrist:GetComponent('UIToggle'):Set(not xtphzData.randomBanker)

	xtphzData.qiHuHuXi=UnityEngine.PlayerPrefs.GetInt('NewXTPHZqiHuHuXi', 10)
	xtphzObj.ToggleQiHu10:GetComponent('UIToggle'):Set(xtphzData.qiHuHuXi == 10)
	xtphzObj.ToggleQiHu15:GetComponent('UIToggle'):Set(xtphzData.qiHuHuXi == 15)

	xtphzData.calculationTunMode =UnityEngine.PlayerPrefs.GetInt('NewXTPHZcalculationTunMode', 0)
	xtphzObj.ToggleSanXiYiTun:GetComponent('UIToggle'):Set(xtphzData.calculationTunMode == 0)
	xtphzObj.ToggleYiXiYiTun:GetComponent('UIToggle'):Set(xtphzData.calculationTunMode == 1)
	xtphzObj.ToggleFengSanJinSan:GetComponent('UIToggle'):Set(xtphzData.calculationTunMode == 2)

	xtphzData.bottomScore=UnityEngine.PlayerPrefs.GetInt('NewXTPHZbottomScore', 1)
	xtphzObj.DiFenTunValue:GetComponent("UILabel").text = xtphzData.bottomScore..'分'

	xtphzData.yiWuShi=UnityEngine.PlayerPrefs.GetInt('NewXTPHZyiWuShi', 0)==1
	xtphzObj.ToggleYiWuShi:GetComponent('UIToggle'):Set(xtphzData.yiWuShi)
	xtphzData.shiZhongBuLiang=UnityEngine.PlayerPrefs.GetInt('NewXTPHZshiZhongBuLiang', 0)==1
	xtphzObj.ToggleShiZhongBuLiang:GetComponent('UIToggle'):Set(xtphzData.shiZhongBuLiang)
	xtphzData.hu30FangBei=UnityEngine.PlayerPrefs.GetInt('NewXTPHZhu30FangBei', 0)==1
	xtphzObj.ToggleHu30FangBei:GetComponent('UIToggle'):Set(xtphzData.hu30FangBei)
	xtphzData.tianDiHu=UnityEngine.PlayerPrefs.GetInt('NewXTPHZtianDiHu', 0)==1
	xtphzObj.ToggleTianDiHu:GetComponent('UIToggle'):Set(xtphzData.tianDiHu)
	xtphzData.pengPengHu=UnityEngine.PlayerPrefs.GetInt('NewXTPHZpengPengHu', 0)==1
	xtphzObj.TogglePengPengHu:GetComponent('UIToggle'):Set(xtphzData.pengPengHu)
	xtphzData.daXiaoZiHu=UnityEngine.PlayerPrefs.GetInt('NewXTPHZdaXiaoZiHu', 0)==1
	xtphzObj.ToggleDaXiaoZiHu:GetComponent('UIToggle'):Set(xtphzData.daXiaoZiHu)
	xtphzData.yiDianHong=UnityEngine.PlayerPrefs.GetInt('NewXTPHZyiDianHong', 0)==1
	xtphzObj.ToggleYiDianHong:GetComponent('UIToggle'):Set(xtphzData.yiDianHong)
	xtphzData.heiHongHu=UnityEngine.PlayerPrefs.GetInt('NewXTPHZheiHongHu', 0)==1
	xtphzObj.ToggleHeiHongHu:GetComponent('UIToggle'):Set(xtphzData.heiHongHu)
	xtphzData.hong13=UnityEngine.PlayerPrefs.GetInt('NewXTPHZhong13', 0)==1
	xtphzObj.ToggleHong13.gameObject:SetActive(xtphzData.heiHongHu)
	xtphzObj.ToggleHong13:GetComponent('UIToggle'):Set(xtphzData.hong13)
	xtphzData.canHuZiMo =UnityEngine.PlayerPrefs.GetInt('NewXTPHZcanHuZiMo', 0)==1
	xtphzObj.ToggleCanHuZiMo:GetComponent('UIToggle'):Set(xtphzData.canHuZiMo)
	xtphzData.canMingWei=UnityEngine.PlayerPrefs.GetInt('NewXTPHZcanMingWei', 1)==1
	xtphzObj.ToggleCanAnWei:GetComponent('UIToggle'):Set(not xtphzData.canMingWei)
	xtphzData.chouWeiLiang=UnityEngine.PlayerPrefs.GetInt('NewXTPHZchouWeiLiang', 0)==1
	xtphzObj.ToggleChouWeiLiang.gameObject:SetActive(not xtphzData.canMingWei)
	xtphzObj.ToggleChouWeiLiang:GetComponent('UIToggle'):Set(xtphzData.chouWeiLiang)

	xtphzData.calculationFanMode =UnityEngine.PlayerPrefs.GetInt('NewXTPHZcalculationFanMode', 0)
	xtphzObj.ToggleFanShuChen:GetComponent('UIToggle'):Set(xtphzData.calculationFanMode == 0)
	xtphzObj.ToggleFanShuJia:GetComponent('UIToggle'):Set(xtphzData.calculationFanMode == 1)
	xtphzObj.TogglefanShuYiBei:GetComponent('UIToggle'):Set(xtphzData.calculationFanMode == 2)

	xtphzData.maxHuXi=UnityEngine.PlayerPrefs.GetInt('NewXTPHZmaxHuXi', 0)
	xtphzObj.FengDingValue:GetComponent("UILabel").text = xtphzData.maxHuXi == 0 and '不封顶' or xtphzData.maxHuXi..'分'

	xtphzData.huangZhuangFen=UnityEngine.PlayerPrefs.GetInt('NewXTPHZhuangZhuangFen', 0) 
	xtphzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = xtphzData.huangZhuangFen == 0 and '不扣分' or '扣'..xtphzData.huangZhuangFen..'分'

	xtphzData.chou = UnityEngine.PlayerPrefs.GetInt('NewXTPHZchou', 20)
	xtphzObj.ToggleChou0:GetComponent('UIToggle'):Set(xtphzData.chou == 0)
	xtphzObj.ToggleChou10:GetComponent('UIToggle'):Set(xtphzData.chou == 10)
	xtphzObj.ToggleChou20:GetComponent('UIToggle'):Set(xtphzData.chou == 20)
	xtphzObj.ToggleChou0.parent.gameObject:SetActive(xtphzData.size == 2)

	xtphzData.niao=UnityEngine.PlayerPrefs.GetInt('NewXTPHZniao', 0)==1
	xtphzData.niaoValue=UnityEngine.PlayerPrefs.GetInt('NewXTPHZniaoValue', 10)
	xtphzObj.ToggleOnNiao:GetComponent('UIToggle'):Set(xtphzData.niao)
	xtphzObj.ToggleOffNiao:GetComponent('UIToggle'):Set(not xtphzData.niao)
	xtphzObj.NiaoValueText.parent.gameObject:SetActive(xtphzData.niao)
    xtphzObj.NiaoValueText:GetComponent('UILabel').text = xtphzData.niaoValue.."分"

	xtphzData.choiceDouble=UnityEngine.PlayerPrefs.GetInt('NewXTPHZchoiceDouble', 0)==1
	xtphzData.doubleScore=UnityEngine.PlayerPrefs.GetInt('NewXTPHZdoubleScore', 10)
	xtphzData.multiple=UnityEngine.PlayerPrefs.GetInt('NewXTPHZmultiple', 2)
	xtphzObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(xtphzData.choiceDouble)
	xtphzObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not xtphzData.choiceDouble)
	xtphzObj.DoubleScoreText.parent.gameObject:SetActive(xtphzData.choiceDouble)
	if xtphzData.doubleScore == 0 then
		xtphzObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		xtphzObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..xtphzData.doubleScore..'分'
	end
	xtphzObj.ToggleChoiceDouble.parent.gameObject:SetActive(xtphzData.size == 2)
	xtphzObj.ToggleMultiple2:GetComponent('UIToggle'):Set(xtphzData.multiple == 2)
	xtphzObj.ToggleMultiple3:GetComponent('UIToggle'):Set(xtphzData.multiple == 3)
	xtphzObj.ToggleMultiple4:GetComponent('UIToggle'):Set(xtphzData.multiple == 4)
	xtphzObj.ToggleMultiple2.parent.gameObject:SetActive(xtphzData.choiceDouble and  xtphzData.size == 2)

	xtphzData.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewXTPHZisSettlementScore', 0)==1
	xtphzData.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewXTPHZfewerValue', 10)
	xtphzData.addValue=UnityEngine.PlayerPrefs.GetInt('NewXTPHZaddValue', 10)
	xtphzObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(xtphzData.size==2)
	xtphzObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(xtphzData.isSettlementScore)
	xtphzObj.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	xtphzObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = xtphzData.fewerValue
	xtphzObj.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	xtphzObj.ToggleAddScoreTxt:GetComponent('UILabel').text = xtphzData.addValue

	xtphzData.trusteeshipTime=UnityEngine.PlayerPrefs.GetInt('NewXTPHZtrusteeshipTime', 0)
	xtphzData.trusteeshipType = UnityEngine.PlayerPrefs.GetInt('NewXTPHZtrusteeshipType', 0) == 1
	xtphzData.trusteeshipRound = UnityEngine.PlayerPrefs.GetInt('NewXTPHZtrusteeshipRound', 0)
	xtphzObj.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(xtphzData.trusteeshipTime == 0)
	xtphzObj.ToggleTrusteeship1:GetComponent('UIToggle'):Set(xtphzData.trusteeshipTime == 1)
	xtphzObj.ToggleTrusteeship2:GetComponent('UIToggle'):Set(xtphzData.trusteeshipTime == 2)
	xtphzObj.ToggleTrusteeship3:GetComponent('UIToggle'):Set(xtphzData.trusteeshipTime == 3)
	xtphzObj.ToggleTrusteeship5:GetComponent('UIToggle'):Set(xtphzData.trusteeshipTime == 5)
	xtphzObj.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(xtphzData.trusteeshipType)
	xtphzObj.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not xtphzData.trusteeshipType and xtphzData.trusteeshipRound == 0)
	xtphzObj.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(xtphzData.trusteeshipRound == 3);
	xtphzObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(xtphzData.trusteeshipTime ~= 0)
	
	xtphzData.openIp=UnityEngine.PlayerPrefs.GetInt('XTPHZcheckIP', 0)==1
	xtphzData.openGps=UnityEngine.PlayerPrefs.GetInt('XTPHZcheckGPS', 0)==1
	xtphzObj.ToggleIPcheck:GetComponent('UIToggle'):Set(xtphzData.openIp)
	xtphzObj.ToggleGPScheck:GetComponent('UIToggle'):Set(xtphzData.openGps)
	xtphzObj.ToggleIPcheck.parent.gameObject:SetActive(xtphzData.size > 2 and CONST.IPcheckOn)

	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.XTPHZ,xtphzData.rounds,nil,nil)

	XTPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end
--获取当前设置
function this.GetConfig()
	local moneyLess = false
	if ((xtphzData.rounds == 6 or xtphzData.rounds == 8) and info_login.balance < 2) 
	or (xtphzData.rounds == 10 and info_login.balance < 3)
	or (xtphzData.rounds == 16 and info_login.balance < 5) then
        moneyLess = true
    end
    local body = {}
    body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.XTPHZ)
	body.rounds = xtphzData.rounds
    body.size = xtphzData.size
    body.paymentType = xtphzData.paymentType
	body.randomBanker = xtphzData.randomBanker
	body.qiHuHuXi = xtphzData.qiHuHuXi
	body.calculationTunMode = xtphzData.calculationTunMode
	body.bottomScore = xtphzData.bottomScore
	body.yiWuShi = xtphzData.yiWuShi
	body.shiZhongBuLiang = xtphzData.shiZhongBuLiang
	body.hu30FangBei = xtphzData.hu30FangBei
	body.tianDiHu = xtphzData.tianDiHu
	body.pengPengHu = xtphzData.pengPengHu
	body.daXiaoZiHu = xtphzData.daXiaoZiHu
	body.yiDianHong = xtphzData.yiDianHong
	body.heiHongHu = xtphzData.heiHongHu
	if xtphzData.heiHongHu then
		body.hong13 = xtphzData.hong13
	end
	body.canHuZiMo = xtphzData.canHuZiMo
	body.canMingWei = xtphzData.canMingWei
	if not xtphzData.canMingWei then
		body.chouWeiLiang = xtphzData.chouWeiLiang
	end
	body.calculationFanMode = xtphzData.calculationFanMode  
	body.maxHuXi = xtphzData.maxHuXi
	body.huangZhuangFen = xtphzData.huangZhuangFen
	body.chou = xtphzData.size == 2 and xtphzData.chou or 0
	body.niao = xtphzData.niao
	body.niaoValue =  xtphzData.niao and xtphzData.niaoValue or 0
	body.openIp	 = xtphzData.openIp
	body.openGps = xtphzData.openGps
	if xtphzData.size == 2 then
		body.resultScore = xtphzData.isSettlementScore
		if xtphzData.isSettlementScore then
			body.resultLowerScore=xtphzData.fewerValue
			body.resultAddScore=xtphzData.addValue
		end
		body.choiceDouble = xtphzData.choiceDouble
        body.doubleScore = xtphzData.doubleScore
        body.multiple = xtphzData.multiple
		xtphzData.openIp=false
		xtphzData.openGps=false
	end
    body.trusteeship = xtphzData.trusteeshipTime*60
    body.trusteeshipDissolve = xtphzData.trusteeshipType
    body.trusteeshipRound = xtphzData.trusteeshipRound
	body.fanXing = false
    return moneyLess,body
end

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
    if xtphzObj.ToggleRound6.gameObject == go then
        xtphzData.rounds = 6
	elseif xtphzObj.ToggleRound8.gameObject == go then
        xtphzData.rounds = 8
    elseif xtphzObj.ToggleRound10.gameObject == go then
        xtphzData.rounds = 10
    else
        xtphzData.rounds = 16
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.XTPHZ,xtphzData.rounds,nil,nil)
    UnityEngine.PlayerPrefs.SetInt('NewXTPHZrounds', xtphzData.rounds)
end

function this.OnClickTogglePlayerNum(go)
	AudioManager.Instance:PlayAudio('btn')
    if xtphzObj.TogglePeopleNum2.gameObject == go then
        xtphzData.size = 2
    elseif xtphzObj.TogglePeopleNum3.gameObject == go then
        xtphzData.size = 3
    end
	xtphzObj.ToggleChou0.parent.gameObject:SetActive(xtphzData.size == 2)
	xtphzObj.ToggleNoChoiceDouble.parent.gameObject:SetActive(xtphzData.size==2)
	xtphzObj.ToggleMultiple2.parent.gameObject:SetActive(xtphzData.choiceDouble and xtphzData.size == 2)
	xtphzObj.DoubleScoreText.parent.gameObject:SetActive(xtphzData.choiceDouble)
	xtphzObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(xtphzData.size==2)
	xtphzObj.ToggleIPcheck.parent.gameObject:SetActive(xtphzData.size > 2 and CONST.IPcheckOn)
	UnityEngine.PlayerPrefs.SetInt('NewXTPHZsize', xtphzData.size)
    XTPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if xtphzObj.ToggleMasterPay.gameObject == go then
        xtphzData.paymentType=0
    elseif xtphzObj.ToggleWinnerPay.gameObject == go then
        xtphzData.paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewXTPHZpaymentType', xtphzData.paymentType)
end

function this.OnClickRandomBanker(go)
    AudioManager.Instance:PlayAudio('btn')
    if xtphzObj.ToggleRandomBanker.gameObject == go then
        xtphzData.randomBanker = true
    elseif xtphzObj.ToggleBankerFrist.gameObject == go then
        xtphzData.randomBanker = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewXTPHZrandomBanker', xtphzData.randomBanker and 1 or 0)
end
function this.OnClickQiHuScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if xtphzObj.ToggleQiHu10.gameObject == go then
        xtphzData.qiHuHuXi = 10
    elseif xtphzObj.ToggleQiHu15.gameObject == go then
        xtphzData.qiHuHuXi = 15
    end
    UnityEngine.PlayerPrefs.SetInt('NewXTPHZqiHuHuXi', xtphzData.qiHuHuXi)
end

function this.OnClickHuXiSuanFen(go)
	AudioManager.Instance:PlayAudio('btn')
    if xtphzObj.ToggleSanXiYiTun.gameObject == go then
        xtphzData.calculationTunMode = 0
	elseif xtphzObj.ToggleYiXiYiTun.gameObject == go then
        xtphzData.calculationTunMode = 1
    elseif xtphzObj.ToggleFengSanJinSan.gameObject == go then
        xtphzData.calculationTunMode = 2
	end
    UnityEngine.PlayerPrefs.SetInt('NewXTPHZcalculationTunMode', xtphzData.calculationTunMode)
end

function this.OnClickChangeDiFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if xtphzObj.AddBtnDiFen.gameObject == go then
		xtphzData.bottomScore = xtphzData.bottomScore + 1
		if xtphzData.bottomScore > 10 then
			xtphzData.bottomScore = 10
		end
    elseif xtphzObj.SubtractBtnDiFen.gameObject == go then
        xtphzData.bottomScore = xtphzData.bottomScore - 1
		if xtphzData.bottomScore < 1 then
			xtphzData.bottomScore = 1
		end
	end
	xtphzObj.DiFenTunValue:GetComponent("UILabel").text = xtphzData.bottomScore..'分'
    UnityEngine.PlayerPrefs.SetInt('NewXTPHZbottomScore', xtphzData.bottomScore)
end

function this.OnClickToggleXTPHZPlay(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == xtphzObj.ToggleYiWuShi.gameObject then
		xtphzData.yiWuShi = xtphzObj.ToggleYiWuShi:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewXTPHZyiWuShi', xtphzData.yiWuShi and 1 or 0)
	elseif go == xtphzObj.ToggleShiZhongBuLiang.gameObject then
		xtphzData.shiZhongBuLiang = xtphzObj.ToggleShiZhongBuLiang:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewXTPHZshiZhongBuLiang', xtphzData.shiZhongBuLiang and 1 or 0)
	elseif go == xtphzObj.ToggleHu30FangBei.gameObject then
		xtphzData.hu30FangBei = xtphzObj.ToggleHu30FangBei:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewXTPHZhu30FangBei', xtphzData.hu30FangBei and 1 or 0)
	elseif go == xtphzObj.ToggleTianDiHu.gameObject then
		xtphzData.tianDiHu = xtphzObj.ToggleTianDiHu:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewXTPHZtianDiHu', xtphzData.tianDiHu and 1 or 0)
	elseif go == xtphzObj.TogglePengPengHu.gameObject then
		xtphzData.pengPengHu = xtphzObj.TogglePengPengHu:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewXTPHZpengPengHu', xtphzData.pengPengHu and 1 or 0)
	elseif go == xtphzObj.ToggleDaXiaoZiHu.gameObject then
		xtphzData.daXiaoZiHu = xtphzObj.ToggleDaXiaoZiHu:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewXTPHZdaXiaoZiHu', xtphzData.daXiaoZiHu and 1 or 0)
	elseif go == xtphzObj.ToggleYiDianHong.gameObject then
		xtphzData.yiDianHong = xtphzObj.ToggleYiDianHong:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewXTPHZyiDianHong', xtphzData.yiDianHong and 1 or 0)
	elseif go == xtphzObj.ToggleHeiHongHu.gameObject then
		xtphzData.heiHongHu = xtphzObj.ToggleHeiHongHu:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewXTPHZheiHongHu', xtphzData.heiHongHu and 1 or 0)
		xtphzObj.ToggleHong13.gameObject:SetActive(xtphzData.heiHongHu)
	elseif go == xtphzObj.ToggleHong13.gameObject then
		xtphzData.hong13 = xtphzObj.ToggleHong13:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewXTPHZhong13', xtphzData.hong13 and 1 or 0)
	elseif go == xtphzObj.ToggleCanHuZiMo.gameObject then
		xtphzData.canHuZiMo = xtphzObj.ToggleCanHuZiMo:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewXTPHZcanHuZiMo', xtphzData.canHuZiMo and 1 or 0)
	elseif go == xtphzObj.ToggleCanAnWei.gameObject then
		xtphzData.canMingWei = not xtphzObj.ToggleCanAnWei:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewXTPHZcanMingWei', xtphzData.canMingWei and 1 or 0)
		xtphzObj.ToggleChouWeiLiang.gameObject:SetActive(not xtphzData.canMingWei)
	elseif go == xtphzObj.ToggleChouWeiLiang.gameObject then
		xtphzData.chouWeiLiang = xtphzObj.ToggleChouWeiLiang:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewXTPHZchouWeiLiang', xtphzData.chouWeiLiang and 1 or 0)
	end
end

function this.OnClickToggleFanShuSuanFen(go)
	AudioManager.Instance:PlayAudio('btn')
    if xtphzObj.ToggleFanShuChen.gameObject == go then
        xtphzData.calculationFanMode = 0
    elseif xtphzObj.ToggleFanShuJia.gameObject == go then
		xtphzData.calculationFanMode = 1
	elseif xtphzObj.TogglefanShuYiBei.gameObject == go then
        xtphzData.calculationFanMode = 2
	end
    UnityEngine.PlayerPrefs.SetInt('NewXTPHZcalculationFanMode', xtphzData.calculationFanMode)
end

function this.OnClickChangeFengDingValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if xtphzObj.AddBtnFengDing.gameObject == go then
        if xtphzData.maxHuXi ~= 0 then
            xtphzData.maxHuXi = xtphzData.maxHuXi + 100
            if xtphzData.maxHuXi > 500 then
                xtphzData.maxHuXi = 0
            end
        end
    else
        if xtphzData.maxHuXi == 0 then
            xtphzData.maxHuXi = 500
        else
            xtphzData.maxHuXi = xtphzData.maxHuXi - 100
            if xtphzData.maxHuXi < 100 then
                xtphzData.maxHuXi = 100
            end
        end
    end
	xtphzObj.FengDingValue:GetComponent("UILabel").text = xtphzData.maxHuXi == 0 and '不封顶' or xtphzData.maxHuXi..'分'
	UnityEngine.PlayerPrefs.SetInt('NewXTPHZmaxHuXi', xtphzData.maxHuXi)
end

function this.OnClickChangeHuangZhuangKouFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if xtphzObj.AddBtnHuangZhuangKouFen.gameObject == go then
		xtphzData.huangZhuangFen = xtphzData.huangZhuangFen + 1
		if xtphzData.huangZhuangFen > 10 then
			xtphzData.huangZhuangFen = 10
		end
    else
		xtphzData.huangZhuangFen = xtphzData.huangZhuangFen - 1
		if xtphzData.huangZhuangFen < 0 then
			xtphzData.huangZhuangFen = 0
		end
    end
	xtphzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = xtphzData.huangZhuangFen == 0 and '不扣分' or '扣'..xtphzData.huangZhuangFen..'分'
	UnityEngine.PlayerPrefs.SetInt('NewXTPHZhuangZhuangFen', xtphzData.huangZhuangFen)
end

function this.OnClickToggleChou(go)
	AudioManager.Instance:PlayAudio('btn')
	if xtphzObj.ToggleChou0.gameObject == go then
        xtphzData.chou=0
    elseif xtphzObj.ToggleChou10.gameObject == go then
        xtphzData.chou=10
    elseif xtphzObj.ToggleChou20.gameObject == go then
        xtphzData.chou=20
	end
	UnityEngine.PlayerPrefs.SetInt('NewXTPHZchou', xtphzData.chou)
end

function this.OnClickNiao(go)
	AudioManager.Instance:PlayAudio('btn')
	if xtphzObj.ToggleOnNiao.gameObject == go then
		xtphzData.niao = true
	elseif xtphzObj.ToggleOffNiao.gameObject == go then
		xtphzData.niao = false
	end
	xtphzObj.NiaoValueText.parent.gameObject:SetActive(xtphzData.niao)
	UnityEngine.PlayerPrefs.SetInt('NewXTPHZniao', xtphzData.niao and 1 or 0)
end

function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if xtphzObj.AddButtonNiao.gameObject == go then
		xtphzData.niaoValue = xtphzData.niaoValue + 10
		if xtphzData.niaoValue > 100 then
			xtphzData.niaoValue = 100
		end
	elseif xtphzObj.SubtractButtonNiao.gameObject == go then
		xtphzData.niaoValue = xtphzData.niaoValue - 10
		if xtphzData.niaoValue < 10 then
			xtphzData.niaoValue = 10
		end
	end
	xtphzObj.NiaoValueText:GetComponent('UILabel').text = xtphzData.niaoValue.."分"
	UnityEngine.PlayerPrefs.SetInt('NewXTPHZniaoValue', xtphzData.niaoValue)
end

function this.OnClickChoiceDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if xtphzObj.ToggleChoiceDouble.gameObject == go then
        xtphzData.choiceDouble = true
    elseif xtphzObj.ToggleNoChoiceDouble.gameObject == go then
        xtphzData.choiceDouble = false
    end
    xtphzObj.DoubleScoreText.parent.gameObject:SetActive(xtphzData.choiceDouble)
    xtphzObj.ToggleMultiple2.parent.gameObject:SetActive(xtphzData.choiceDouble)
    XTPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
    UnityEngine.PlayerPrefs.SetInt('NewXTPHZchoiceDouble', xtphzData.choiceDouble and 1 or 0)
end

function this.OnClickChangeDoubleScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if xtphzObj.AddDoubleScoreButton.gameObject == go then
        if xtphzData.doubleScore ~= 0 then
            xtphzData.doubleScore = xtphzData.doubleScore + 1
            if xtphzData.doubleScore > 100 then
                xtphzData.doubleScore = 0
            end
        end
    else
        if xtphzData.doubleScore == 0 then
            xtphzData.doubleScore = 100
        else
            xtphzData.doubleScore = xtphzData.doubleScore - 1
            if xtphzData.doubleScore < 1 then
                xtphzData.doubleScore = 1
            end
        end
    end
    if xtphzData.doubleScore == 0 then
        xtphzObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
    else
        xtphzObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..xtphzData.doubleScore..'分'
    end
    UnityEngine.PlayerPrefs.SetInt('NewXTPHZdoubleScore', xtphzData.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
    if xtphzObj.ToggleMultiple2.gameObject == go then
        xtphzData.multiple=2
    elseif xtphzObj.ToggleMultiple3.gameObject == go then
        xtphzData.multiple=3
    elseif xtphzObj.ToggleMultiple4.gameObject == go then
        xtphzData.multiple=4
    end
    UnityEngine.PlayerPrefs.SetInt('NewXTPHZmultiple', xtphzData.multiple)
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    xtphzData.isSettlementScore= xtphzObj.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewXTPHZisSettlementScore', xtphzData.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if xtphzObj.ToggleFewerAddButton.gameObject == go then
		xtphzData.fewerValue = xtphzData.fewerValue + 1
		if xtphzData.fewerValue > 100 then
			xtphzData.fewerValue = 100
		end
    elseif xtphzObj.ToggleFewerSubtractButton.gameObject == go then
		xtphzData.fewerValue = xtphzData.fewerValue - 1
		if xtphzData.fewerValue < 1 then
			xtphzData.fewerValue = 1
		end
	end
	xtphzObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = xtphzData.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewXTPHZfewerValue', xtphzData.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if xtphzObj.ToggleAddAddButton.gameObject == go then
		xtphzData.addValue = xtphzData.addValue + 1
		if xtphzData.addValue > 100 then
			xtphzData.addValue = 100
		end
    elseif xtphzObj.ToggleAddSubtractButton.gameObject == go then
		xtphzData.addValue = xtphzData.addValue - 1
		if xtphzData.addValue < 1 then
			xtphzData.addValue = 1
		end
	end
	xtphzObj.ToggleAddScoreTxt:GetComponent('UILabel').text = xtphzData.addValue
	UnityEngine.PlayerPrefs.SetInt('NewXTPHZaddValue', xtphzData.addValue)
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if xtphzObj.ToggleTrusteeshipNo.gameObject == go then
        xtphzData.trusteeshipTime = 0
    elseif xtphzObj.ToggleTrusteeship1.gameObject == go then
        xtphzData.trusteeshipTime = 1
	elseif xtphzObj.ToggleTrusteeship2.gameObject == go then
		xtphzData.trusteeshipTime = 2
    elseif xtphzObj.ToggleTrusteeship3.gameObject == go then
        xtphzData.trusteeshipTime = 3
    elseif xtphzObj.ToggleTrusteeship5.gameObject == go then
        xtphzData.trusteeshipTime = 5
	end
    UnityEngine.PlayerPrefs.SetInt('NewXTPHZtrusteeshipTime', xtphzData.trusteeshipTime)
	xtphzObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(xtphzData.trusteeshipTime ~= 0)
	XTPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if xtphzObj.ToggleTrusteeshipOne.gameObject == go then
        xtphzData.trusteeshipType = true
		xtphzData.trusteeshipRound = 0;
    elseif xtphzObj.ToggleTrusteeshipAll.gameObject == go then
        xtphzData.trusteeshipType = false
		xtphzData.trusteeshipRound = 0;
	elseif xtphzObj.ToggleTrusteeshipThree.gameObject == go then
		xtphzData.trusteeshipType = false;
		xtphzData.trusteeshipRound = 3;
    end
    UnityEngine.PlayerPrefs.SetInt('NewXTPHZtrusteeshipType',xtphzData.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewXTPHZtrusteeshipRound',xtphzData.trusteeshipRound )
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if xtphzObj.ToggleIPcheck.gameObject == go then
		xtphzData.openIp = xtphzObj.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('XTPHZcheckIP', xtphzData.openIp and 1 or 0)
	elseif xtphzObj.ToggleGPScheck.gameObject == go then
		xtphzData.openGps = xtphzObj.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('XTPHZcheckGPS', xtphzData.openGps and 1 or 0)
	end
end

return this