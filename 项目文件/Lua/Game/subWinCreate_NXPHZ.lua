local this = {}

local NXPHZ
local payLabel

local nxphzData = {}
local nxphzObj = {}

function this.Init(grid,message)
	print('Init_NXPHZ')
	NXPHZ = grid
	payLabel = message.transform:Find('diamond/pay_label')

	nxphzObj.ToggleRound6 = NXPHZ:Find('table/round/round6')
	nxphzObj.ToggleRound8 = NXPHZ:Find('table/round/round8')
	nxphzObj.ToggleRound10 = NXPHZ:Find('table/round/round10')
	nxphzObj.ToggleRound16 = NXPHZ:Find('table/round/round16')
	message:AddClick(nxphzObj.ToggleRound6.gameObject, this.OnClickToggleRound)
	message:AddClick(nxphzObj.ToggleRound8.gameObject, this.OnClickToggleRound)
	message:AddClick(nxphzObj.ToggleRound10.gameObject, this.OnClickToggleRound)
	message:AddClick(nxphzObj.ToggleRound16.gameObject, this.OnClickToggleRound)

	nxphzObj.TogglePeopleNum2 = NXPHZ:Find('table/num/num2')
	nxphzObj.TogglePeopleNum3 = NXPHZ:Find('table/num/num3')
	message:AddClick(nxphzObj.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(nxphzObj.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)

	nxphzObj.ToggleMasterPay = NXPHZ:Find('table/pay/master')
	nxphzObj.ToggleWinnerPay = NXPHZ:Find('table/pay/win')
	message:AddClick(nxphzObj.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(nxphzObj.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)

	nxphzObj.ToggleRandomBanker = NXPHZ:Find('table/randomBanker/Auto')
	nxphzObj.ToggleBankerFrist = NXPHZ:Find('table/randomBanker/Frist')
	message:AddClick(nxphzObj.ToggleRandomBanker.gameObject, this.OnClickRandomBanker)
	message:AddClick(nxphzObj.ToggleBankerFrist.gameObject, this.OnClickRandomBanker)

	nxphzObj.ToggleQiHu9 = NXPHZ:Find('table/qiHu/qiHu9')
	nxphzObj.ToggleQiHu15 = NXPHZ:Find('table/qiHu/qiHu15')
	message:AddClick(nxphzObj.ToggleQiHu9.gameObject, this.OnClickQiHuScore)
	message:AddClick(nxphzObj.ToggleQiHu15.gameObject, this.OnClickQiHuScore)

	nxphzObj.AddBtnDiFen = NXPHZ:Find('table/diFen/diFenScore/AddButton')
	nxphzObj.SubtractBtnDiFen = NXPHZ:Find('table/diFen/diFenScore/SubtractButton')
	nxphzObj.DiFenTunValue = NXPHZ:Find('table/diFen/diFenScore/Value')
	message:AddClick(nxphzObj.AddBtnDiFen.gameObject, this.OnClickChangeDiFenValue)
	message:AddClick(nxphzObj.SubtractBtnDiFen.gameObject, this.OnClickChangeDiFenValue)

	nxphzObj.ToggleZiMoFanBei = NXPHZ:Find('table/play1/ziMoFanBei')
	nxphzObj.ToggleShiLiuXiao = NXPHZ:Find('table/play1/shiLiuXiao')
	nxphzObj.ToggleHaiDiHu = NXPHZ:Find('table/play1/haiDiHu')
	nxphzObj.ToggleShuaHou = NXPHZ:Find('table/play2/shuaHou')
	nxphzObj.ToggleAdd1When27 = NXPHZ:Find('table/play2/add1When27')
	nxphzObj.ToggleAddHongXiaoDa = NXPHZ:Find('table/play2/addHongXiaoDa')
	message:AddClick(nxphzObj.ToggleZiMoFanBei.gameObject, this.OnClickToggleZiMoFanBei)
	message:AddClick(nxphzObj.ToggleShiLiuXiao.gameObject, this.OnClickToggleShiLiuXiao)
	message:AddClick(nxphzObj.ToggleHaiDiHu.gameObject, this.OnClickToggleHaiDiHu)
	message:AddClick(nxphzObj.ToggleShuaHou.gameObject, this.OnClickToggleShuaHou)
	message:AddClick(nxphzObj.ToggleAdd1When27.gameObject, this.OnClickToggleAdd1When27)
	message:AddClick(nxphzObj.ToggleAddHongXiaoDa.gameObject, this.OnClickToggleAddHongXiaoDa)

	nxphzObj.ToggleZiMoAddTun0 = NXPHZ:Find('table/ziMoAddTun/ziMoAddTun0')
	nxphzObj.ToggleZiMoAddTun1 = NXPHZ:Find('table/ziMoAddTun/ziMoAddTun1')
	nxphzObj.ToggleZiMoAddTun2 = NXPHZ:Find('table/ziMoAddTun/ziMoAddTun2')
	message:AddClick(nxphzObj.ToggleZiMoAddTun0.gameObject, this.OnClickToggleZiMoAddTun)
	message:AddClick(nxphzObj.ToggleZiMoAddTun1.gameObject, this.OnClickToggleZiMoAddTun)
	message:AddClick(nxphzObj.ToggleZiMoAddTun2.gameObject, this.OnClickToggleZiMoAddTun)

	nxphzObj.AddBtnZhaNiao = NXPHZ:Find('table/zhaNiao/zhaNiaoScore/AddButton')
	nxphzObj.SubtractBtnZhaNiao = NXPHZ:Find('table/zhaNiao/zhaNiaoScore/SubtractButton')
	nxphzObj.ZhaNiaoValue = NXPHZ:Find('table/zhaNiao/zhaNiaoScore/Value')
	message:AddClick(nxphzObj.AddBtnZhaNiao.gameObject, this.OnClickChangeZhaNiaoValue)
	message:AddClick(nxphzObj.SubtractBtnZhaNiao.gameObject, this.OnClickChangeZhaNiaoValue)

	nxphzObj.ToggleFengDingScore0 = NXPHZ:Find('table/fengDing/fengDingScore0')
	nxphzObj.ToggleFengDingScore5 = NXPHZ:Find('table/fengDing/fengDingScore5')
	nxphzObj.ToggleFengDingScore10 = NXPHZ:Find('table/fengDing/fengDingScore10')
	nxphzObj.ToggleFengDingScore100 = NXPHZ:Find('table/fengDing/fengDingScore100')
	nxphzObj.ToggleFengDingScore200 = NXPHZ:Find('table/fengDing1/fengDingScore200')
	nxphzObj.ToggleFengDingScore300 = NXPHZ:Find('table/fengDing1/fengDingScore300')
	message:AddClick(nxphzObj.ToggleFengDingScore0.gameObject, this.OnClickToggleFengDingScore)
	message:AddClick(nxphzObj.ToggleFengDingScore5.gameObject, this.OnClickToggleFengDingScore)
	message:AddClick(nxphzObj.ToggleFengDingScore10.gameObject, this.OnClickToggleFengDingScore)
	message:AddClick(nxphzObj.ToggleFengDingScore100.gameObject, this.OnClickToggleFengDingScore)
	message:AddClick(nxphzObj.ToggleFengDingScore200.gameObject, this.OnClickToggleFengDingScore)
	message:AddClick(nxphzObj.ToggleFengDingScore300.gameObject, this.OnClickToggleFengDingScore)

	nxphzObj.AddBtnHuangZhuangKouFen = NXPHZ:Find('table/huangZhuangKouFen/kouScore/AddButton')
	nxphzObj.SubtractBtnHuangZhuangKouFen = NXPHZ:Find('table/huangZhuangKouFen/kouScore/SubtractButton')
	nxphzObj.HuangZhuangKouFenValue = NXPHZ:Find('table/huangZhuangKouFen/kouScore/Value')
	message:AddClick(nxphzObj.AddBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)
	message:AddClick(nxphzObj.SubtractBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)

	nxphzObj.ToggleChou0 = NXPHZ:Find('table/chouCard/chouCard0')
	nxphzObj.ToggleChou10 = NXPHZ:Find('table/chouCard/chouCard10')
	nxphzObj.ToggleChou20 = NXPHZ:Find('table/chouCard/chouCard20')
	message:AddClick(nxphzObj.ToggleChou0.gameObject, this.OnClickToggleChou)
	message:AddClick(nxphzObj.ToggleChou10.gameObject, this.OnClickToggleChou)
	message:AddClick(nxphzObj.ToggleChou20.gameObject, this.OnClickToggleChou)

	nxphzObj.ToggleOnNiao = NXPHZ:Find('table/niao/OnNiao')
	nxphzObj.ToggleOffNiao = NXPHZ:Find('table/niao/OffNiao')
	nxphzObj.NiaoValueText = NXPHZ:Find('table/niao/NiaoValue/Value')
	nxphzObj.AddButtonNiao = NXPHZ:Find('table/niao/NiaoValue/AddButton')
	nxphzObj.SubtractButtonNiao = NXPHZ:Find('table/niao/NiaoValue/SubtractButton')
	message:AddClick(nxphzObj.ToggleOnNiao.gameObject, this.OnClickNiao)
	message:AddClick(nxphzObj.ToggleOffNiao.gameObject, this.OnClickNiao)
	message:AddClick(nxphzObj.AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(nxphzObj.SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)

	nxphzObj.ToggleChoiceDouble = NXPHZ:Find('table/choiceDouble/On')
	nxphzObj.ToggleNoChoiceDouble = NXPHZ:Find('table/choiceDouble/Off')
	nxphzObj.DoubleScoreText = NXPHZ:Find('table/choiceDouble/doubleScore/Value')
	nxphzObj.AddDoubleScoreButton = NXPHZ:Find('table/choiceDouble/doubleScore/AddButton')
	nxphzObj.SubtractDoubleScoreButton = NXPHZ:Find('table/choiceDouble/doubleScore/SubtractButton')
	nxphzObj.ToggleMultiple2 = NXPHZ:Find('table/multiple/2')
	nxphzObj.ToggleMultiple3 = NXPHZ:Find('table/multiple/3')
	nxphzObj.ToggleMultiple4 = NXPHZ:Find('table/multiple/4')
	message:AddClick(nxphzObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(nxphzObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(nxphzObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(nxphzObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(nxphzObj.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(nxphzObj.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(nxphzObj.ToggleMultiple4.gameObject, this.OnClickMultiple)

	nxphzObj.ToggleSettlementScoreSelect=NXPHZ:Find('table/settlementScore/select')
	nxphzObj.ToggleFewerScoreTxt=NXPHZ:Find('table/settlementScore/fewerValue/Value')
	nxphzObj.ToggleFewerAddButton=NXPHZ:Find('table/settlementScore/fewerValue/AddButton')
	nxphzObj.ToggleFewerSubtractButton=NXPHZ:Find('table/settlementScore/fewerValue/SubtractButton')
	nxphzObj.ToggleAddScoreTxt=NXPHZ:Find('table/settlementScore/addValue/Value')
	nxphzObj.ToggleAddAddButton=NXPHZ:Find('table/settlementScore/addValue/AddButton')
	nxphzObj.ToggleAddSubtractButton=NXPHZ:Find('table/settlementScore/addValue/SubtractButton')
	
	message:AddClick(nxphzObj.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(nxphzObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(nxphzObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(nxphzObj.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(nxphzObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)
	

	nxphzObj.ToggleTrusteeshipNo = NXPHZ:Find('table/DelegateChoose/NoDelegate')
	nxphzObj.ToggleTrusteeship1 = NXPHZ:Find('table/DelegateChoose/Delegate1')
	nxphzObj.ToggleTrusteeship2 = NXPHZ:Find('table/DelegateChoose/Delegate2')
	nxphzObj.ToggleTrusteeship3 = NXPHZ:Find('table/DelegateChoose/Delegate3')
	nxphzObj.ToggleTrusteeship5 = NXPHZ:Find('table/DelegateChoose1/Delegate5')
	message:AddClick(nxphzObj.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(nxphzObj.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(nxphzObj.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(nxphzObj.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(nxphzObj.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)

	nxphzObj.ToggleTrusteeshipAll = NXPHZ:Find('table/DelegateCancel/FullRound')
	nxphzObj.ToggleTrusteeshipOne = NXPHZ:Find('table/DelegateCancel/ThisRound')
	nxphzObj.ToggleTrusteeshipThree = NXPHZ:Find('table/DelegateCancel/ThreeRound')
	message:AddClick(nxphzObj.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(nxphzObj.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(nxphzObj.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)
	
	nxphzObj.ToggleIPcheck = NXPHZ:Find('table/PreventCheat/IPcheck')
	nxphzObj.ToggleGPScheck = NXPHZ:Find('table/PreventCheat/GPScheck')
	message:AddClick(nxphzObj.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(nxphzObj.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end
function this.Refresh()
	print('Refresh_NXPHZ')
	nxphzData.rounds=UnityEngine.PlayerPrefs.GetInt('NewNXPHZrounds', 8)
	nxphzObj.ToggleRound6:GetComponent('UIToggle'):Set(nxphzData.rounds == 6)
	nxphzObj.ToggleRound8:GetComponent('UIToggle'):Set(nxphzData.rounds == 8)
	nxphzObj.ToggleRound10:GetComponent('UIToggle'):Set(nxphzData.rounds == 10)
	nxphzObj.ToggleRound16:GetComponent('UIToggle'):Set(nxphzData.rounds == 16)

	nxphzData.size=UnityEngine.PlayerPrefs.GetInt('NewNXPHZsize', 2)
	nxphzObj.TogglePeopleNum2:GetComponent('UIToggle'):Set(nxphzData.size == 2)
    nxphzObj.TogglePeopleNum3:GetComponent('UIToggle'):Set(nxphzData.size == 3)

	nxphzData.paymentType=UnityEngine.PlayerPrefs.GetInt('NewNXPHZpaymentType', 0)
	nxphzObj.ToggleMasterPay:GetComponent('UIToggle'):Set(nxphzData.paymentType == 0)
	nxphzObj.ToggleWinnerPay:GetComponent('UIToggle'):Set(nxphzData.paymentType == 2)

	nxphzData.randomBanker=UnityEngine.PlayerPrefs.GetInt('NewNXPHZrandomBanker', 0)==1
	nxphzObj.ToggleRandomBanker:GetComponent('UIToggle'):Set(nxphzData.randomBanker)
	nxphzObj.ToggleBankerFrist:GetComponent('UIToggle'):Set(not nxphzData.randomBanker)

	nxphzData.qiHuHuXi=UnityEngine.PlayerPrefs.GetInt('NewNXPHZqiHuHuXi', 15)
	nxphzObj.ToggleQiHu9:GetComponent('UIToggle'):Set(nxphzData.qiHuHuXi == 9)
	nxphzObj.ToggleQiHu15:GetComponent('UIToggle'):Set(nxphzData.qiHuHuXi == 15)

	nxphzData.bottomScore=UnityEngine.PlayerPrefs.GetInt('NewNXPHZbottomScore', 1)
	nxphzObj.DiFenTunValue:GetComponent("UILabel").text = nxphzData.bottomScore..'分'

	nxphzData.ziMoFan=UnityEngine.PlayerPrefs.GetInt('NewNXPHZziMoFan', 0)
	nxphzObj.ToggleZiMoFanBei:GetComponent('UIToggle'):Set(nxphzData.ziMoFan == 2)
	nxphzData.shiLiuXiao=UnityEngine.PlayerPrefs.GetInt('NewNXPHZshiLiuXiao', 0)==1
	nxphzObj.ToggleShiLiuXiao:GetComponent('UIToggle'):Set(nxphzData.shiLiuXiao)
	nxphzData.haiDiHu=UnityEngine.PlayerPrefs.GetInt('NewNXPHZhaiDiHu', 1)==1
	nxphzObj.ToggleHaiDiHu:GetComponent('UIToggle'):Set(nxphzData.haiDiHu)
	nxphzData.shuaHou=UnityEngine.PlayerPrefs.GetInt('NewNXPHZshuaHou', 0)==1
	nxphzObj.ToggleShuaHou:GetComponent('UIToggle'):Set(nxphzData.shuaHou)
	nxphzData.add1When27=UnityEngine.PlayerPrefs.GetInt('NewNXPHZadd1When27', 1)==1
	nxphzObj.ToggleAdd1When27:GetComponent('UIToggle'):Set(nxphzData.add1When27)
	nxphzData.addHongXiaoDa=UnityEngine.PlayerPrefs.GetInt('NewNXPHZaddHongXiaoDa', 1)==1
	nxphzObj.ToggleAddHongXiaoDa:GetComponent('UIToggle'):Set(nxphzData.addHongXiaoDa)

	nxphzData.ziMoAddTun =UnityEngine.PlayerPrefs.GetInt('NewNXPHZziMoAddTun', 1)
	nxphzObj.ToggleZiMoAddTun0:GetComponent('UIToggle'):Set(nxphzData.ziMoAddTun == 0)
	nxphzObj.ToggleZiMoAddTun1:GetComponent('UIToggle'):Set(nxphzData.ziMoAddTun == 1)
	nxphzObj.ToggleZiMoAddTun2:GetComponent('UIToggle'):Set(nxphzData.ziMoAddTun == 2)

	nxphzData.zhaNiao =UnityEngine.PlayerPrefs.GetInt('NewNXPHZzhaNiao', 0)
	nxphzObj.ZhaNiaoValue:GetComponent("UILabel").text = nxphzData.zhaNiao == 0 and '不扎鸟' or (nxphzData.zhaNiao..'分')

	nxphzData.maxHuXi =UnityEngine.PlayerPrefs.GetInt('NewNXPHZmaxHuXi', 0)
	nxphzObj.ToggleFengDingScore0:GetComponent('UIToggle'):Set(nxphzData.maxHuXi == 0)
	nxphzObj.ToggleFengDingScore5:GetComponent('UIToggle'):Set(nxphzData.maxHuXi == 5)
	nxphzObj.ToggleFengDingScore10:GetComponent('UIToggle'):Set(nxphzData.maxHuXi == 10)
	nxphzObj.ToggleFengDingScore100:GetComponent('UIToggle'):Set(nxphzData.maxHuXi == 100)
	nxphzObj.ToggleFengDingScore200:GetComponent('UIToggle'):Set(nxphzData.maxHuXi == 200)
	nxphzObj.ToggleFengDingScore300:GetComponent('UIToggle'):Set(nxphzData.maxHuXi == 300)

	nxphzData.huangZhuangFen=UnityEngine.PlayerPrefs.GetInt('NewNXPHZhuangZhuangFen', 0) 
	nxphzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = nxphzData.huangZhuangFen == 0 and '不扣分' or '扣'..nxphzData.huangZhuangFen..'分'

	nxphzData.chou = UnityEngine.PlayerPrefs.GetInt('NewNXPHZchou', 20)
	nxphzObj.ToggleChou0:GetComponent('UIToggle'):Set(nxphzData.chou == 0)
	nxphzObj.ToggleChou10:GetComponent('UIToggle'):Set(nxphzData.chou == 10)
	nxphzObj.ToggleChou20:GetComponent('UIToggle'):Set(nxphzData.chou == 20)
	nxphzObj.ToggleChou0.parent.gameObject:SetActive(nxphzData.size == 2)

	nxphzData.niao=UnityEngine.PlayerPrefs.GetInt('NewNXPHZniao', 0)==1
	nxphzData.niaoValue=UnityEngine.PlayerPrefs.GetInt('NewNXPHZniaoValue', 10)
	nxphzObj.ToggleOnNiao:GetComponent('UIToggle'):Set(nxphzData.niao)
	nxphzObj.ToggleOffNiao:GetComponent('UIToggle'):Set(not nxphzData.niao)
	nxphzObj.NiaoValueText.parent.gameObject:SetActive(nxphzData.niao)
    nxphzObj.NiaoValueText:GetComponent('UILabel').text = nxphzData.niaoValue.."分"

	nxphzData.choiceDouble=UnityEngine.PlayerPrefs.GetInt('NewNXPHZchoiceDouble', 0)==1
	nxphzData.doubleScore=UnityEngine.PlayerPrefs.GetInt('NewNXPHZdoubleScore', 10)
	nxphzData.multiple=UnityEngine.PlayerPrefs.GetInt('NewNXPHZmultiple', 2)
	nxphzObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(nxphzData.choiceDouble)
	nxphzObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not nxphzData.choiceDouble)
	nxphzObj.DoubleScoreText.parent.gameObject:SetActive(nxphzData.choiceDouble)
	if nxphzData.doubleScore == 0 then
		nxphzObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		nxphzObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..nxphzData.doubleScore..'分'
	end
	nxphzObj.ToggleChoiceDouble.parent.gameObject:SetActive(nxphzData.size == 2)
	nxphzObj.ToggleMultiple2:GetComponent('UIToggle'):Set(nxphzData.multiple == 2)
	nxphzObj.ToggleMultiple3:GetComponent('UIToggle'):Set(nxphzData.multiple == 3)
	nxphzObj.ToggleMultiple4:GetComponent('UIToggle'):Set(nxphzData.multiple == 4)
	nxphzObj.ToggleMultiple2.parent.gameObject:SetActive(nxphzData.choiceDouble and  nxphzData.size == 2)

	nxphzData.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewNXPHZisSettlementScore', 0)==1
	nxphzData.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewNXPHZfewerValue', 10)
	nxphzData.addValue=UnityEngine.PlayerPrefs.GetInt('NewNXPHZaddValue', 10)
	nxphzObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(nxphzData.size==2)
	nxphzObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(nxphzData.isSettlementScore)
	nxphzObj.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	nxphzObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = nxphzData.fewerValue
	nxphzObj.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	nxphzObj.ToggleAddScoreTxt:GetComponent('UILabel').text = nxphzData.addValue

	nxphzData.trusteeshipTime=UnityEngine.PlayerPrefs.GetInt('NewNXPHZtrusteeshipTime', 0)
	nxphzData.trusteeshipType = UnityEngine.PlayerPrefs.GetInt('NewNXPHZtrusteeshipType', 0) == 1
	nxphzData.trusteeshipRound = UnityEngine.PlayerPrefs.GetInt('NewNXPHZtrusteeshipRound', 0)
	nxphzObj.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(nxphzData.trusteeshipTime == 0)
	nxphzObj.ToggleTrusteeship1:GetComponent('UIToggle'):Set(nxphzData.trusteeshipTime == 1)
	nxphzObj.ToggleTrusteeship2:GetComponent('UIToggle'):Set(nxphzData.trusteeshipTime == 2)
	nxphzObj.ToggleTrusteeship3:GetComponent('UIToggle'):Set(nxphzData.trusteeshipTime == 3)
	nxphzObj.ToggleTrusteeship5:GetComponent('UIToggle'):Set(nxphzData.trusteeshipTime == 5)
	nxphzObj.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(nxphzData.trusteeshipType)
	nxphzObj.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not nxphzData.trusteeshipType and nxphzData.trusteeshipRound == 0)
	nxphzObj.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(nxphzData.trusteeshipRound == 3);
	nxphzObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(nxphzData.trusteeshipTime ~= 0)
	
	nxphzData.openIp=UnityEngine.PlayerPrefs.GetInt('NXPHZcheckIP', 0)==1
	nxphzData.openGps=UnityEngine.PlayerPrefs.GetInt('NXPHZcheckGPS', 0)==1
	nxphzObj.ToggleIPcheck:GetComponent('UIToggle'):Set(nxphzData.openIp)
	nxphzObj.ToggleGPScheck:GetComponent('UIToggle'):Set(nxphzData.openGps)
	nxphzObj.ToggleIPcheck.parent.gameObject:SetActive(nxphzData.size > 2 and CONST.IPcheckOn)

	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.NXPHZ,nxphzData.rounds,nil,nil)

	NXPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end
--获取当前设置
function this.GetConfig()
	local moneyLess = false
	if ((nxphzData.rounds == 6 or nxphzData.rounds == 8) and info_login.balance < 2) 
	or (nxphzData.rounds == 10 and info_login.balance < 3)
	or (nxphzData.rounds == 16 and info_login.balance < 5) then
        moneyLess = true
    end
    local body = {}
    body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.NXPHZ)
	body.rounds = nxphzData.rounds
    body.size = nxphzData.size
    body.paymentType = nxphzData.paymentType
	body.randomBanker = nxphzData.randomBanker
	body.qiHuHuXi = nxphzData.qiHuHuXi
	body.bottomScore = nxphzData.bottomScore
	body.ziMoFan = nxphzData.ziMoFan
	body.shiLiuXiao = nxphzData.shiLiuXiao
	body.haiDiHu = nxphzData.haiDiHu
	body.shuaHou = nxphzData.shuaHou
	body.add1When27 = nxphzData.add1When27
	body.addHongXiaoDa = nxphzData.addHongXiaoDa
	body.ziMoAddTun = nxphzData.ziMoAddTun
	body.zhaNiao = nxphzData.zhaNiao
	body.maxHuXi = nxphzData.maxHuXi
	body.huangZhuangFen = nxphzData.huangZhuangFen
	body.chou = nxphzData.size == 2 and nxphzData.chou or 0
	body.niao = nxphzData.niao
	body.niaoValue =  nxphzData.niao and nxphzData.niaoValue or 0
	body.openIp	 = nxphzData.openIp
	body.openGps = nxphzData.openGps
	if nxphzData.size == 2 then
		body.resultScore = nxphzData.isSettlementScore
		if nxphzData.isSettlementScore then
			body.resultLowerScore=nxphzData.fewerValue
			body.resultAddScore=nxphzData.addValue
		end
		body.choiceDouble = nxphzData.choiceDouble
        body.doubleScore = nxphzData.doubleScore
        body.multiple = nxphzData.multiple
		nxphzData.openIp=false
		nxphzData.openGps=false
	end
    body.trusteeship = nxphzData.trusteeshipTime*60
    body.trusteeshipDissolve = nxphzData.trusteeshipType
    body.trusteeshipRound = nxphzData.trusteeshipRound
	body.fanXing = false
    return moneyLess,body
end

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
    if nxphzObj.ToggleRound6.gameObject == go then
        nxphzData.rounds = 6
	elseif nxphzObj.ToggleRound8.gameObject == go then
        nxphzData.rounds = 8
    elseif nxphzObj.ToggleRound10.gameObject == go then
        nxphzData.rounds = 10
    else
        nxphzData.rounds = 16
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.NXPHZ,nxphzData.rounds,nil,nil)
    UnityEngine.PlayerPrefs.SetInt('NewNXPHZrounds', nxphzData.rounds)
end

function this.OnClickTogglePlayerNum(go)
	AudioManager.Instance:PlayAudio('btn')
    if nxphzObj.TogglePeopleNum2.gameObject == go then
        nxphzData.size = 2
    elseif nxphzObj.TogglePeopleNum3.gameObject == go then
        nxphzData.size = 3
    end
	nxphzObj.ToggleChou0.parent.gameObject:SetActive(nxphzData.size == 2)
	nxphzObj.ToggleNoChoiceDouble.parent.gameObject:SetActive(nxphzData.size==2)
	nxphzObj.ToggleMultiple2.parent.gameObject:SetActive(nxphzData.choiceDouble and nxphzData.size == 2)
	nxphzObj.DoubleScoreText.parent.gameObject:SetActive(nxphzData.choiceDouble)
	nxphzObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(nxphzData.size==2)
	nxphzObj.ToggleIPcheck.parent.gameObject:SetActive(nxphzData.size > 2 and CONST.IPcheckOn)
	UnityEngine.PlayerPrefs.SetInt('NewNXPHZsize', nxphzData.size)
    NXPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if nxphzObj.ToggleMasterPay.gameObject == go then
        nxphzData.paymentType=0
    elseif nxphzObj.ToggleWinnerPay.gameObject == go then
        nxphzData.paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewNXPHZpaymentType', nxphzData.paymentType)
end

function this.OnClickRandomBanker(go)
    AudioManager.Instance:PlayAudio('btn')
    if nxphzObj.ToggleRandomBanker.gameObject == go then
        nxphzData.randomBanker = true
    elseif nxphzObj.ToggleBankerFrist.gameObject == go then
        nxphzData.randomBanker = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewNXPHZrandomBanker', nxphzData.randomBanker and 1 or 0)
end
function this.OnClickQiHuScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if nxphzObj.ToggleQiHu9.gameObject == go then
        nxphzData.qiHuHuXi = 9
    elseif nxphzObj.ToggleQiHu15.gameObject == go then
        nxphzData.qiHuHuXi = 15
    end
    UnityEngine.PlayerPrefs.SetInt('NewNXPHZqiHuHuXi', nxphzData.qiHuHuXi)
end

function this.OnClickChangeDiFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if nxphzObj.AddBtnDiFen.gameObject == go then
		nxphzData.bottomScore = nxphzData.bottomScore + 1
		if nxphzData.bottomScore > 10 then
			nxphzData.bottomScore = 10
		end
    elseif nxphzObj.SubtractBtnDiFen.gameObject == go then
        nxphzData.bottomScore = nxphzData.bottomScore - 1
		if nxphzData.bottomScore < 1 then
			nxphzData.bottomScore = 1
		end
	end
	nxphzObj.DiFenTunValue:GetComponent("UILabel").text = nxphzData.bottomScore..'分'
    UnityEngine.PlayerPrefs.SetInt('NewNXPHZbottomScore', nxphzData.bottomScore)
end

function this.OnClickToggleZiMoFanBei(go)
	AudioManager.Instance:PlayAudio('btn')
	if nxphzObj.ToggleZiMoFanBei:GetComponent('UIToggle').value then
		nxphzData.ziMoFan = 2
	else
		nxphzData.ziMoFan = 0
	end
	UnityEngine.PlayerPrefs.SetInt('NewNXPHZziMoFan', nxphzData.ziMoFan)
end

function this.OnClickToggleShiLiuXiao(go)
	AudioManager.Instance:PlayAudio('btn')
	nxphzData.shiLiuXiao = nxphzObj.ToggleShiLiuXiao:GetComponent('UIToggle').value
	UnityEngine.PlayerPrefs.SetInt('NewNXPHZshiLiuXiao', nxphzData.shiLiuXiao and 1 or 0)
end

function this.OnClickToggleHaiDiHu(go)
	AudioManager.Instance:PlayAudio('btn')
	nxphzData.haiDiHu = nxphzObj.ToggleHaiDiHu:GetComponent('UIToggle').value
	UnityEngine.PlayerPrefs.SetInt('NewNXPHZhaiDiHu', nxphzData.haiDiHu and 1 or 0)
end

function this.OnClickToggleShuaHou(go)
	AudioManager.Instance:PlayAudio('btn')
	nxphzData.shuaHou = nxphzObj.ToggleShuaHou:GetComponent('UIToggle').value
	UnityEngine.PlayerPrefs.SetInt('NewNXPHZshuaHou', nxphzData.shuaHou and 1 or 0)
end

function this.OnClickToggleAdd1When27(go)
	AudioManager.Instance:PlayAudio('btn')
	nxphzData.add1When27 = nxphzObj.ToggleAdd1When27:GetComponent('UIToggle').value
	UnityEngine.PlayerPrefs.SetInt('NewNXPHZadd1When27', nxphzData.add1When27 and 1 or 0)
end

function this.OnClickToggleAddHongXiaoDa(go)
	AudioManager.Instance:PlayAudio('btn')
	nxphzData.addHongXiaoDa = nxphzObj.ToggleAddHongXiaoDa:GetComponent('UIToggle').value
	UnityEngine.PlayerPrefs.SetInt('NewNXPHZaddHongXiaoDa', nxphzData.addHongXiaoDa and 1 or 0)
end

function this.OnClickToggleZiMoAddTun(go)
	AudioManager.Instance:PlayAudio('btn')
    if nxphzObj.ToggleZiMoAddTun0.gameObject == go then
        nxphzData.ziMoAddTun = 0
	elseif nxphzObj.ToggleZiMoAddTun1.gameObject == go then
        nxphzData.ziMoAddTun = 1
    elseif nxphzObj.ToggleZiMoAddTun2.gameObject == go then
        nxphzData.ziMoAddTun = 2
	end
    UnityEngine.PlayerPrefs.SetInt('NewNXPHZziMoAddTun', nxphzData.ziMoAddTun)
end

function this.OnClickChangeZhaNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if nxphzObj.AddBtnZhaNiao.gameObject == go then
		nxphzData.zhaNiao = nxphzData.zhaNiao + 1
		if nxphzData.zhaNiao > 10 then
			nxphzData.zhaNiao = 10
		end
    else
		nxphzData.zhaNiao = nxphzData.zhaNiao - 1
		if nxphzData.zhaNiao < 0 then
			nxphzData.zhaNiao = 0
		end
    end
	nxphzObj.ZhaNiaoValue:GetComponent("UILabel").text = nxphzData.zhaNiao == 0 and '不扎鸟' or (nxphzData.zhaNiao..'分')
	UnityEngine.PlayerPrefs.SetInt('NewNXPHZzhaNiao', nxphzData.zhaNiao)
end

function this.OnClickToggleFengDingScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if nxphzObj.ToggleFengDingScore0.gameObject == go then
        nxphzData.maxHuXi = 0
	elseif nxphzObj.ToggleFengDingScore5.gameObject == go then
        nxphzData.maxHuXi = 5
    elseif nxphzObj.ToggleFengDingScore10.gameObject == go then
		nxphzData.maxHuXi = 10
	elseif nxphzObj.ToggleFengDingScore100.gameObject == go then
        nxphzData.maxHuXi = 100
	elseif nxphzObj.ToggleFengDingScore200.gameObject == go then
        nxphzData.maxHuXi = 200
	elseif nxphzObj.ToggleFengDingScore300.gameObject == go then
        nxphzData.maxHuXi = 300
	end
	UnityEngine.PlayerPrefs.SetInt('NewNXPHZmaxHuXi', nxphzData.maxHuXi)
end

function this.OnClickChangeHuangZhuangKouFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if nxphzObj.AddBtnHuangZhuangKouFen.gameObject == go then
		nxphzData.huangZhuangFen = nxphzData.huangZhuangFen + 1
		if nxphzData.huangZhuangFen > 10 then
			nxphzData.huangZhuangFen = 10
		end
    else
		nxphzData.huangZhuangFen = nxphzData.huangZhuangFen - 1
		if nxphzData.huangZhuangFen < 0 then
			nxphzData.huangZhuangFen = 0
		end
    end
	nxphzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = nxphzData.huangZhuangFen == 0 and '不扣分' or '扣'..nxphzData.huangZhuangFen..'分'
	UnityEngine.PlayerPrefs.SetInt('NewNXPHZhuangZhuangFen', nxphzData.huangZhuangFen)
end

function this.OnClickToggleChou(go)
	AudioManager.Instance:PlayAudio('btn')
	if nxphzObj.ToggleChou0.gameObject == go then
        nxphzData.chou=0
    elseif nxphzObj.ToggleChou10.gameObject == go then
        nxphzData.chou=10
    elseif nxphzObj.ToggleChou20.gameObject == go then
        nxphzData.chou=20
	end
	UnityEngine.PlayerPrefs.SetInt('NewNXPHZchou', nxphzData.chou)
end

function this.OnClickNiao(go)
	AudioManager.Instance:PlayAudio('btn')
	if nxphzObj.ToggleOnNiao.gameObject == go then
		nxphzData.niao = true
	elseif nxphzObj.ToggleOffNiao.gameObject == go then
		nxphzData.niao = false
	end
	nxphzObj.NiaoValueText.parent.gameObject:SetActive(nxphzData.niao)
	UnityEngine.PlayerPrefs.SetInt('NewNXPHZniao', nxphzData.niao and 1 or 0)
end

function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if nxphzObj.AddButtonNiao.gameObject == go then
		nxphzData.niaoValue = nxphzData.niaoValue + 10
		if nxphzData.niaoValue > 100 then
			nxphzData.niaoValue = 100
		end
	elseif nxphzObj.SubtractButtonNiao.gameObject == go then
		nxphzData.niaoValue = nxphzData.niaoValue - 10
		if nxphzData.niaoValue < 10 then
			nxphzData.niaoValue = 10
		end
	end
	nxphzObj.NiaoValueText:GetComponent('UILabel').text = nxphzData.niaoValue.."分"
	UnityEngine.PlayerPrefs.SetInt('NewNXPHZniaoValue', nxphzData.niaoValue)
end

function this.OnClickChoiceDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if nxphzObj.ToggleChoiceDouble.gameObject == go then
        nxphzData.choiceDouble = true
    elseif nxphzObj.ToggleNoChoiceDouble.gameObject == go then
        nxphzData.choiceDouble = false
    end
    nxphzObj.DoubleScoreText.parent.gameObject:SetActive(nxphzData.choiceDouble)
    nxphzObj.ToggleMultiple2.parent.gameObject:SetActive(nxphzData.choiceDouble)
    NXPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
    UnityEngine.PlayerPrefs.SetInt('NewNXPHZchoiceDouble', nxphzData.choiceDouble and 1 or 0)
end

function this.OnClickChangeDoubleScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if nxphzObj.AddDoubleScoreButton.gameObject == go then
        if nxphzData.doubleScore ~= 0 then
            nxphzData.doubleScore = nxphzData.doubleScore + 1
            if nxphzData.doubleScore > 100 then
                nxphzData.doubleScore = 0
            end
        end
    else
        if nxphzData.doubleScore == 0 then
            nxphzData.doubleScore = 100
        else
            nxphzData.doubleScore = nxphzData.doubleScore - 1
            if nxphzData.doubleScore < 1 then
                nxphzData.doubleScore = 1
            end
        end
    end
    if nxphzData.doubleScore == 0 then
        nxphzObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
    else
        nxphzObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..nxphzData.doubleScore..'分'
    end
    UnityEngine.PlayerPrefs.SetInt('NewNXPHZdoubleScore', nxphzData.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
    if nxphzObj.ToggleMultiple2.gameObject == go then
        nxphzData.multiple=2
    elseif nxphzObj.ToggleMultiple3.gameObject == go then
        nxphzData.multiple=3
    elseif nxphzObj.ToggleMultiple4.gameObject == go then
        nxphzData.multiple=4
    end
    UnityEngine.PlayerPrefs.SetInt('NewNXPHZmultiple', nxphzData.multiple)
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    nxphzData.isSettlementScore= nxphzObj.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewNXPHZisSettlementScore', nxphzData.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if nxphzObj.ToggleFewerAddButton.gameObject == go then
		nxphzData.fewerValue = nxphzData.fewerValue + 1
		if nxphzData.fewerValue > 100 then
			nxphzData.fewerValue = 100
		end
    elseif nxphzObj.ToggleFewerSubtractButton.gameObject == go then
		nxphzData.fewerValue = nxphzData.fewerValue - 1
		if nxphzData.fewerValue < 1 then
			nxphzData.fewerValue = 1
		end
	end
	nxphzObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = nxphzData.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewNXPHZfewerValue', nxphzData.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if nxphzObj.ToggleAddAddButton.gameObject == go then
		nxphzData.addValue = nxphzData.addValue + 1
		if nxphzData.addValue > 100 then
			nxphzData.addValue = 100
		end
    elseif nxphzObj.ToggleAddSubtractButton.gameObject == go then
		nxphzData.addValue = nxphzData.addValue - 1
		if nxphzData.addValue < 1 then
			nxphzData.addValue = 1
		end
	end
	nxphzObj.ToggleAddScoreTxt:GetComponent('UILabel').text = nxphzData.addValue
	UnityEngine.PlayerPrefs.SetInt('NewNXPHZaddValue', nxphzData.addValue)
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if nxphzObj.ToggleTrusteeshipNo.gameObject == go then
        nxphzData.trusteeshipTime = 0
    elseif nxphzObj.ToggleTrusteeship1.gameObject == go then
        nxphzData.trusteeshipTime = 1
	elseif nxphzObj.ToggleTrusteeship2.gameObject == go then
		nxphzData.trusteeshipTime = 2
    elseif nxphzObj.ToggleTrusteeship3.gameObject == go then
        nxphzData.trusteeshipTime = 3
    elseif nxphzObj.ToggleTrusteeship5.gameObject == go then
        nxphzData.trusteeshipTime = 5
	end
    UnityEngine.PlayerPrefs.SetInt('NewNXPHZtrusteeshipTime', nxphzData.trusteeshipTime)
	nxphzObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(nxphzData.trusteeshipTime ~= 0)
	NXPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if nxphzObj.ToggleTrusteeshipOne.gameObject == go then
        nxphzData.trusteeshipType = true
		nxphzData.trusteeshipRound = 0;
    elseif nxphzObj.ToggleTrusteeshipAll.gameObject == go then
        nxphzData.trusteeshipType = false
		nxphzData.trusteeshipRound = 0;
	elseif nxphzObj.ToggleTrusteeshipThree.gameObject == go then
		nxphzData.trusteeshipType = false;
		nxphzData.trusteeshipRound = 3;
    end
    UnityEngine.PlayerPrefs.SetInt('NewNXPHZtrusteeshipType',nxphzData.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewNXPHZtrusteeshipRound',nxphzData.trusteeshipRound )
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if nxphzObj.ToggleIPcheck.gameObject == go then
		nxphzData.openIp = nxphzObj.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('NXPHZcheckIP', nxphzData.openIp and 1 or 0)
	elseif nxphzObj.ToggleGPScheck.gameObject == go then
		nxphzData.openGps = nxphzObj.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NXPHZcheckGPS', nxphzData.openGps and 1 or 0)
	end
end

return this