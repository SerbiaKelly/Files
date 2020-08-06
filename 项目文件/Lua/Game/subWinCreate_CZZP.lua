local this = {}

local CZZP
local payLabel

local czzpData = {}
local czzpObj = {}

function this.Init(grid,message)
	print('Init_CZZP')
	CZZP = grid
	payLabel = message.transform:Find('diamond/pay_label')

	czzpObj.ToggleRound6 = CZZP:Find('table/round/round6')
	czzpObj.ToggleRound8 = CZZP:Find('table/round/round8')
	czzpObj.ToggleRound10 = CZZP:Find('table/round/round10')
	czzpObj.ToggleRound16 = CZZP:Find('table/round/round16')
	message:AddClick(czzpObj.ToggleRound6.gameObject, this.OnClickToggleRound)
	message:AddClick(czzpObj.ToggleRound8.gameObject, this.OnClickToggleRound)
	message:AddClick(czzpObj.ToggleRound10.gameObject, this.OnClickToggleRound)
	message:AddClick(czzpObj.ToggleRound16.gameObject, this.OnClickToggleRound)

	czzpObj.TogglePeopleNum2 = CZZP:Find('table/num/num2')
	czzpObj.TogglePeopleNum3 = CZZP:Find('table/num/num3')
	czzpObj.TogglePeopleNum4 = CZZP:Find('table/num/num4')
	message:AddClick(czzpObj.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(czzpObj.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(czzpObj.TogglePeopleNum4.gameObject, this.OnClickTogglePlayerNum)

	czzpObj.ToggleMasterPay = CZZP:Find('table/pay/master')
	czzpObj.ToggleWinnerPay = CZZP:Find('table/pay/win')
	message:AddClick(czzpObj.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(czzpObj.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)

	czzpObj.ToggleRandomBanker = CZZP:Find('table/randomBanker/Auto')
	czzpObj.ToggleBankerFrist = CZZP:Find('table/randomBanker/Frist')
	message:AddClick(czzpObj.ToggleRandomBanker.gameObject, this.OnClickRandomBanker)
	message:AddClick(czzpObj.ToggleBankerFrist.gameObject, this.OnClickRandomBanker)

	czzpObj.ToggleQiHu3 = CZZP:Find('table/qiHu/qiHu3')
	czzpObj.ToggleQiHu6 = CZZP:Find('table/qiHu/qiHu6')
	czzpObj.ToggleQiHu9 = CZZP:Find('table/qiHu/qiHu9')
	message:AddClick(czzpObj.ToggleQiHu3.gameObject, this.OnClickQiHuScore)
	message:AddClick(czzpObj.ToggleQiHu6.gameObject, this.OnClickQiHuScore)
	message:AddClick(czzpObj.ToggleQiHu9.gameObject, this.OnClickQiHuScore)

	czzpObj.ToggleSanXiYiTun = CZZP:Find('table/suanFen/tunMode31')
	czzpObj.ToggleYiXiYiTun = CZZP:Find('table/suanFen/tunMode11')
	message:AddClick(czzpObj.ToggleSanXiYiTun.gameObject, this.OnClickHuXiSuanFen)
	message:AddClick(czzpObj.ToggleYiXiYiTun.gameObject, this.OnClickHuXiSuanFen)

	czzpObj.ToggleQiHu9Xi1Tun = CZZP:Find('table/qiHuTun/qiHu9Xi1Tun')
	czzpObj.ToggleQiHu9Xi3Tun = CZZP:Find('table/qiHuTun/qiHu9Xi3Tun')
	message:AddClick(czzpObj.ToggleQiHu9Xi1Tun.gameObject, this.OnClickQiHuTun)
	message:AddClick(czzpObj.ToggleQiHu9Xi3Tun.gameObject, this.OnClickQiHuTun)

	czzpObj.ToggleQClassic0 = CZZP:Find('table/classic/0')
	czzpObj.ToggleQClassic1 = CZZP:Find('table/classic/1')
	czzpObj.ToggleQClassic2 = CZZP:Find('table/classic/2')
	message:AddClick(czzpObj.ToggleQClassic0.gameObject, this.OnClickClassic)
	message:AddClick(czzpObj.ToggleQClassic1.gameObject, this.OnClickClassic)
	message:AddClick(czzpObj.ToggleQClassic2.gameObject, this.OnClickClassic)

	czzpObj.ToggleZiMoFan = CZZP:Find('table/play1/ziMoFan')
	message:AddClick(czzpObj.ToggleZiMoFan.gameObject, this.OnClickToggleCZZPPlay)
	czzpObj.ToggleYouHuBiHu = CZZP:Find('table/play1/youHuBiHu')
	message:AddClick(czzpObj.ToggleYouHuBiHu.gameObject, this.OnClickToggleCZZPPlay)
	czzpObj.ToggleFangPaoBiHu = CZZP:Find('table/play1/fangPaoBiHu')
	message:AddClick(czzpObj.ToggleFangPaoBiHu.gameObject, this.OnClickToggleCZZPPlay)
	czzpObj.ToggleDaXiaoHongHu = CZZP:Find('table/play2/daXiaoHongHu')
	message:AddClick(czzpObj.ToggleDaXiaoHongHu.gameObject, this.OnClickToggleCZZPPlay)
	czzpObj.TogglePlay15 = CZZP:Find('table/play2/play15')
	message:AddClick(czzpObj.TogglePlay15.gameObject, this.OnClickToggleCZZPPlay)
	czzpObj.MaoHuLabel = CZZP:Find('table/play2/maoHu/maoHuLabel')
	czzpObj.MaoHuLabelBtn = CZZP:Find('table/play2/maoHu/maoHuLabel/bgBtn')
	czzpObj.maoHuType = CZZP:Find('table/play2/maoHu/maoHuType')
	czzpObj.maoHuTypeMask = CZZP:Find('table/play2/maoHu/maoHuType/MaskBtn')
	czzpObj.maoHuTypeGrid = CZZP:Find('table/play2/maoHu/maoHuType/grid')
	message:AddClick(czzpObj.MaoHuLabelBtn.gameObject, function (go)
		AudioManager.Instance:PlayAudio('btn')
		czzpObj.maoHuType.gameObject:SetActive(not czzpObj.maoHuType.gameObject.activeSelf)
	end)
	message:AddClick(czzpObj.maoHuTypeMask.gameObject, function (go)
		AudioManager.Instance:PlayAudio('btn')
		czzpObj.maoHuType.gameObject:SetActive(false)
	end)
	for i = 0, czzpObj.maoHuTypeGrid.childCount - 1 do
		message:AddClick(czzpObj.maoHuTypeGrid:GetChild(i).gameObject, this.OnClickMaoHuType)
	end

	czzpObj.AddBtnHuangZhuangKouFen = CZZP:Find('table/huangZhuangKouFen/kouScore/AddButton')
	czzpObj.SubtractBtnHuangZhuangKouFen = CZZP:Find('table/huangZhuangKouFen/kouScore/SubtractButton')
	czzpObj.HuangZhuangKouFenValue = CZZP:Find('table/huangZhuangKouFen/kouScore/Value')
	message:AddClick(czzpObj.AddBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)
	message:AddClick(czzpObj.SubtractBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)
	czzpObj.ContinueBanker = CZZP:Find('table/huangZhuangKouFen/continueBanker')
	message:AddClick(czzpObj.ContinueBanker.gameObject, this.OnClickContinueBanker)

	czzpObj.ToggleChou0 = CZZP:Find('table/chouCard/chouCard0')
	czzpObj.ToggleChou10 = CZZP:Find('table/chouCard/chouCard10')
	czzpObj.ToggleChou20 = CZZP:Find('table/chouCard/chouCard20')
	message:AddClick(czzpObj.ToggleChou0.gameObject, this.OnClickToggleChou)
	message:AddClick(czzpObj.ToggleChou10.gameObject, this.OnClickToggleChou)
	message:AddClick(czzpObj.ToggleChou20.gameObject, this.OnClickToggleChou)

	czzpObj.TogglePiao0 = CZZP:Find('table/piao/0')
	czzpObj.TogglePiao1 = CZZP:Find('table/piao/1')
	czzpObj.TogglePiao2 = CZZP:Find('table/piao/2')
	czzpObj.TogglePiao3 = CZZP:Find('table/piao/3')
	message:AddClick(czzpObj.TogglePiao0.gameObject, this.OnClickTogglePiao)
	message:AddClick(czzpObj.TogglePiao1.gameObject, this.OnClickTogglePiao)
	message:AddClick(czzpObj.TogglePiao2.gameObject, this.OnClickTogglePiao)
	message:AddClick(czzpObj.TogglePiao3.gameObject, this.OnClickTogglePiao)

	czzpObj.ToggleOnNiao = CZZP:Find('table/niao/OnNiao')
	czzpObj.ToggleOffNiao = CZZP:Find('table/niao/OffNiao')
	czzpObj.NiaoValueText = CZZP:Find('table/niao/NiaoValue/Value')
	czzpObj.AddButtonNiao = CZZP:Find('table/niao/NiaoValue/AddButton')
	czzpObj.SubtractButtonNiao = CZZP:Find('table/niao/NiaoValue/SubtractButton')
	message:AddClick(czzpObj.ToggleOnNiao.gameObject, this.OnClickNiao)
	message:AddClick(czzpObj.ToggleOffNiao.gameObject, this.OnClickNiao)
	message:AddClick(czzpObj.AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(czzpObj.SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)

	czzpObj.ToggleChoiceDouble = CZZP:Find('table/choiceDouble/On')
	czzpObj.ToggleNoChoiceDouble = CZZP:Find('table/choiceDouble/Off')
	czzpObj.DoubleScoreText = CZZP:Find('table/choiceDouble/doubleScore/Value')
	czzpObj.AddDoubleScoreButton = CZZP:Find('table/choiceDouble/doubleScore/AddButton')
	czzpObj.SubtractDoubleScoreButton = CZZP:Find('table/choiceDouble/doubleScore/SubtractButton')
	czzpObj.ToggleMultiple2 = CZZP:Find('table/multiple/2')
	czzpObj.ToggleMultiple3 = CZZP:Find('table/multiple/3')
	czzpObj.ToggleMultiple4 = CZZP:Find('table/multiple/4')
	message:AddClick(czzpObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(czzpObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(czzpObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(czzpObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(czzpObj.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(czzpObj.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(czzpObj.ToggleMultiple4.gameObject, this.OnClickMultiple)

	czzpObj.ToggleSettlementScoreSelect=CZZP:Find('table/settlementScore/select')
	czzpObj.ToggleFewerScoreTxt=CZZP:Find('table/settlementScore/fewerValue/Value')
	czzpObj.ToggleFewerAddButton=CZZP:Find('table/settlementScore/fewerValue/AddButton')
	czzpObj.ToggleFewerSubtractButton=CZZP:Find('table/settlementScore/fewerValue/SubtractButton')
	czzpObj.ToggleAddScoreTxt=CZZP:Find('table/settlementScore/addValue/Value')
	czzpObj.ToggleAddAddButton=CZZP:Find('table/settlementScore/addValue/AddButton')
	czzpObj.ToggleAddSubtractButton=CZZP:Find('table/settlementScore/addValue/SubtractButton')
	message:AddClick(czzpObj.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(czzpObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(czzpObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(czzpObj.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(czzpObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)
	
	czzpObj.ToggleTrusteeshipNo = CZZP:Find('table/DelegateChoose/NoDelegate')
	czzpObj.ToggleTrusteeship1 = CZZP:Find('table/DelegateChoose/Delegate1')
	czzpObj.ToggleTrusteeship2 = CZZP:Find('table/DelegateChoose/Delegate2')
	czzpObj.ToggleTrusteeship3 = CZZP:Find('table/DelegateChoose/Delegate3')
	czzpObj.ToggleTrusteeship5 = CZZP:Find('table/DelegateChoose1/Delegate5')
	message:AddClick(czzpObj.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(czzpObj.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(czzpObj.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(czzpObj.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(czzpObj.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)

	czzpObj.ToggleTrusteeshipAll = CZZP:Find('table/DelegateCancel/FullRound')
	czzpObj.ToggleTrusteeshipOne = CZZP:Find('table/DelegateCancel/ThisRound')
	czzpObj.ToggleTrusteeshipThree = CZZP:Find('table/DelegateCancel/ThreeRound')
	message:AddClick(czzpObj.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(czzpObj.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(czzpObj.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)
	
	czzpObj.ToggleIPcheck = CZZP:Find('table/PreventCheat/IPcheck')
	czzpObj.ToggleGPScheck = CZZP:Find('table/PreventCheat/GPScheck')
	message:AddClick(czzpObj.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(czzpObj.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end
function this.Refresh()
	print('Refresh_CZZP')
	czzpData.rounds=UnityEngine.PlayerPrefs.GetInt('NewCZZProunds', 8)
	czzpObj.ToggleRound6:GetComponent('UIToggle'):Set(czzpData.rounds == 6)
	czzpObj.ToggleRound8:GetComponent('UIToggle'):Set(czzpData.rounds == 8)
	czzpObj.ToggleRound10:GetComponent('UIToggle'):Set(czzpData.rounds == 10)
	czzpObj.ToggleRound16:GetComponent('UIToggle'):Set(czzpData.rounds == 16)

	czzpData.size=UnityEngine.PlayerPrefs.GetInt('NewCZZPsize', 2)
	czzpObj.TogglePeopleNum2:GetComponent('UIToggle'):Set(czzpData.size == 2)
	czzpObj.TogglePeopleNum3:GetComponent('UIToggle'):Set(czzpData.size == 3)
	czzpObj.TogglePeopleNum4:GetComponent('UIToggle'):Set(czzpData.size == 4)

	czzpData.paymentType=UnityEngine.PlayerPrefs.GetInt('NewCZZPpaymentType', 0)
	czzpObj.ToggleMasterPay:GetComponent('UIToggle'):Set(czzpData.paymentType == 0)
	czzpObj.ToggleWinnerPay:GetComponent('UIToggle'):Set(czzpData.paymentType == 2)

	czzpData.randomBanker=UnityEngine.PlayerPrefs.GetInt('NewCZZPrandomBanker', 0)==1
	czzpObj.ToggleRandomBanker:GetComponent('UIToggle'):Set(czzpData.randomBanker)
	czzpObj.ToggleBankerFrist:GetComponent('UIToggle'):Set(not czzpData.randomBanker)

	czzpData.qiHuHuXi=UnityEngine.PlayerPrefs.GetInt('NewCZZPqiHuHuXi', 9)
	czzpObj.ToggleQiHu3:GetComponent('UIToggle'):Set(czzpData.qiHuHuXi == 3)
	czzpObj.ToggleQiHu6:GetComponent('UIToggle'):Set(czzpData.qiHuHuXi == 6)
	czzpObj.ToggleQiHu9:GetComponent('UIToggle'):Set(czzpData.qiHuHuXi == 9)

	czzpData.calculationTunMode =UnityEngine.PlayerPrefs.GetInt('NewCZZPcalculationTunMode', 0)
	czzpObj.ToggleSanXiYiTun:GetComponent('UIToggle'):Set(czzpData.calculationTunMode == 0)
	czzpObj.ToggleYiXiYiTun:GetComponent('UIToggle'):Set(czzpData.calculationTunMode == 1)
	
	this.SetShowQiHuTun()
	czzpData.calculationFanMode =UnityEngine.PlayerPrefs.GetInt('NewCZZPcalculationFanMode', 0)
	czzpObj.ToggleQiHu9Xi1Tun:GetComponent('UIToggle'):Set(czzpData.calculationFanMode == 0)
	czzpObj.ToggleQiHu9Xi3Tun:GetComponent('UIToggle'):Set(czzpData.calculationFanMode == 1)

	czzpData.classic =UnityEngine.PlayerPrefs.GetInt('NewCZZPclassic', 2)
	czzpObj.ToggleQClassic0:GetComponent('UIToggle'):Set(czzpData.classic == 0)
	czzpObj.ToggleQClassic1:GetComponent('UIToggle'):Set(czzpData.classic == 1)
	czzpObj.ToggleQClassic2:GetComponent('UIToggle'):Set(czzpData.classic == 2)

	czzpData.ziMoFan=UnityEngine.PlayerPrefs.GetInt('NewCZZPziMoFan', 0)
	czzpObj.ToggleZiMoFan:GetComponent('UIToggle'):Set(czzpData.ziMoFan == 2 )

	czzpData.choiceHu=UnityEngine.PlayerPrefs.GetInt('NewCZZPchoiceHu', 0)
	czzpObj.ToggleYouHuBiHu:GetComponent('UIToggle'):Set(czzpData.choiceHu == 1)
	czzpObj.ToggleFangPaoBiHu:GetComponent('UIToggle'):Set(czzpData.choiceHu == 2)
	czzpObj.ToggleFangPaoBiHu.gameObject:SetActive(czzpData.choiceHu ~= 1)

	czzpData.daXiaoZiHu=UnityEngine.PlayerPrefs.GetInt('NewCZZPdaXiaoZiHu', 0)==1
	czzpObj.ToggleDaXiaoHongHu.gameObject:SetActive(czzpData.classic == 1)
	czzpObj.ToggleDaXiaoHongHu:GetComponent('UIToggle'):Set(czzpData.daXiaoZiHu)

	czzpData.play15=UnityEngine.PlayerPrefs.GetInt('NewCZZPplay15', 0)==1
	czzpObj.TogglePlay15:GetComponent('UIToggle'):Set(czzpData.play15 or czzpData.size ==4)
	czzpObj.TogglePlay15:GetComponent('BoxCollider').enabled = czzpData.size ~=4

	czzpData.maoHuHuXi=UnityEngine.PlayerPrefs.GetInt('NewCZZPmaoHuHuXi', 0)
	local maoHuHuXi = ''
	if czzpData.maoHuHuXi == 0 then
		maoHuHuXi = '无毛胡'
	else
		maoHuHuXi = '毛胡'..czzpData.maoHuHuXi..'胡'
	end
	czzpObj.MaoHuLabel:GetComponent('UILabel').text = maoHuHuXi
	czzpObj.maoHuType.gameObject:SetActive(false)

	czzpData.huangZhuangFen=UnityEngine.PlayerPrefs.GetInt('NewCZZPhuangZhuangFen', 0) 
	czzpObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = czzpData.huangZhuangFen == 0 and '不扣分' or '扣'..czzpData.huangZhuangFen..'分'
	czzpData.huangKeepBanker=UnityEngine.PlayerPrefs.GetInt('NewYJGHZhuangKeepBanker', 0) == 1
	czzpObj.ContinueBanker:GetComponent('UIToggle'):Set(czzpData.huangKeepBanker)

	czzpData.chou = UnityEngine.PlayerPrefs.GetInt('NewCZZPchou', 20)
	czzpObj.ToggleChou0:GetComponent('UIToggle'):Set(czzpData.chou == 0)
	czzpObj.ToggleChou10:GetComponent('UIToggle'):Set(czzpData.chou == 10)
	czzpObj.ToggleChou20:GetComponent('UIToggle'):Set(czzpData.chou == 20)
	czzpObj.ToggleChou0.parent.gameObject:SetActive(czzpData.size == 2)

	czzpData.piao = UnityEngine.PlayerPrefs.GetInt('NewCZZPpiao', 0)
	czzpObj.TogglePiao0:GetComponent('UIToggle'):Set(czzpData.piao == 0)
	czzpObj.TogglePiao1:GetComponent('UIToggle'):Set(czzpData.piao == 1)
	czzpObj.TogglePiao2:GetComponent('UIToggle'):Set(czzpData.piao == 2)
	czzpObj.TogglePiao3:GetComponent('UIToggle'):Set(czzpData.piao == 3)

	czzpData.niao=UnityEngine.PlayerPrefs.GetInt('NewCZZPniao', 0)==1
	czzpData.niaoValue=UnityEngine.PlayerPrefs.GetInt('NewCZZPniaoValue', 10)
	czzpObj.ToggleOnNiao:GetComponent('UIToggle'):Set(czzpData.niao)
	czzpObj.ToggleOffNiao:GetComponent('UIToggle'):Set(not czzpData.niao)
	czzpObj.NiaoValueText.parent.gameObject:SetActive(czzpData.niao)
    czzpObj.NiaoValueText:GetComponent('UILabel').text = czzpData.niaoValue.."分"

	czzpData.choiceDouble=UnityEngine.PlayerPrefs.GetInt('NewCZZPchoiceDouble', 0)==1
	czzpData.doubleScore=UnityEngine.PlayerPrefs.GetInt('NewCZZPdoubleScore', 10)
	czzpData.multiple=UnityEngine.PlayerPrefs.GetInt('NewCZZPmultiple', 2)
	czzpObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(czzpData.choiceDouble)
	czzpObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not czzpData.choiceDouble)
	czzpObj.DoubleScoreText.parent.gameObject:SetActive(czzpData.choiceDouble)
	if czzpData.doubleScore == 0 then
		czzpObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		czzpObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..czzpData.doubleScore..'分'
	end
	czzpObj.ToggleChoiceDouble.parent.gameObject:SetActive(czzpData.size == 2)
	czzpObj.ToggleMultiple2:GetComponent('UIToggle'):Set(czzpData.multiple == 2)
	czzpObj.ToggleMultiple3:GetComponent('UIToggle'):Set(czzpData.multiple == 3)
	czzpObj.ToggleMultiple4:GetComponent('UIToggle'):Set(czzpData.multiple == 4)
	czzpObj.ToggleMultiple2.parent.gameObject:SetActive(czzpData.choiceDouble and  czzpData.size == 2)

	czzpData.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewCZZPisSettlementScore', 0)==1
	czzpData.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewCZZPfewerValue', 10)
	czzpData.addValue=UnityEngine.PlayerPrefs.GetInt('NewCZZPaddValue', 10)
	czzpObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(czzpData.size==2)
	czzpObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(czzpData.isSettlementScore)
	czzpObj.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	czzpObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = czzpData.fewerValue
	czzpObj.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	czzpObj.ToggleAddScoreTxt:GetComponent('UILabel').text = czzpData.addValue

	czzpData.trusteeshipTime=UnityEngine.PlayerPrefs.GetInt('NewCZZPtrusteeshipTime', 0)
	czzpData.trusteeshipType = UnityEngine.PlayerPrefs.GetInt('NewCZZPtrusteeshipType', 0) == 1
	czzpData.trusteeshipRound = UnityEngine.PlayerPrefs.GetInt('NewCZZPtrusteeshipRound', 0)
	czzpObj.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(czzpData.trusteeshipTime == 0)
	czzpObj.ToggleTrusteeship1:GetComponent('UIToggle'):Set(czzpData.trusteeshipTime == 1)
	czzpObj.ToggleTrusteeship2:GetComponent('UIToggle'):Set(czzpData.trusteeshipTime == 2)
	czzpObj.ToggleTrusteeship3:GetComponent('UIToggle'):Set(czzpData.trusteeshipTime == 3)
	czzpObj.ToggleTrusteeship5:GetComponent('UIToggle'):Set(czzpData.trusteeshipTime == 5)
	czzpObj.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(czzpData.trusteeshipType)
	czzpObj.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not czzpData.trusteeshipType and czzpData.trusteeshipRound == 0)
	czzpObj.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(czzpData.trusteeshipRound == 3);
	czzpObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(czzpData.trusteeshipTime ~= 0)
	
	czzpData.openIp=UnityEngine.PlayerPrefs.GetInt('CZZPcheckIP', 0)==1
	czzpData.openGps=UnityEngine.PlayerPrefs.GetInt('CZZPcheckGPS', 0)==1
	czzpObj.ToggleIPcheck:GetComponent('UIToggle'):Set(czzpData.openIp)
	czzpObj.ToggleGPScheck:GetComponent('UIToggle'):Set(czzpData.openGps)
	czzpObj.ToggleIPcheck.parent.gameObject:SetActive(czzpData.size > 2 and CONST.IPcheckOn)

	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.CZZP,czzpData.rounds,nil,nil)

	CZZP:Find('table'):GetComponent('UIGrid'):Reposition()
end
--获取当前设置
function this.GetConfig()
	local moneyLess = false
	if ((czzpData.rounds == 6 or czzpData.rounds == 8) and info_login.balance < 2) 
	or (czzpData.rounds == 10 and info_login.balance < 3)
	or (czzpData.rounds == 16 and info_login.balance < 4) then
        moneyLess = true
    end
    local body = {}
    body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.CZZP)
	body.rounds = czzpData.rounds
    body.size = czzpData.size
    body.paymentType = czzpData.paymentType
	body.randomBanker = czzpData.randomBanker
	body.qiHuHuXi = czzpData.qiHuHuXi
	body.calculationTunMode = czzpData.calculationTunMode
	local calculationFanMode = 0
	if czzpData.qiHuHuXi == 3 then
		if czzpData.calculationTunMode == 0 then
			calculationFanMode = 0
		elseif czzpData.calculationTunMode == 1 then
			calculationFanMode = czzpData.calculationFanMode == 0 and 0 or 1
		end
	elseif czzpData.qiHuHuXi == 6 then
		if czzpData.calculationTunMode == 0 then
			calculationFanMode = czzpData.calculationFanMode == 0 and 2 or 4
		elseif czzpData.calculationTunMode == 1 then
			calculationFanMode = czzpData.calculationFanMode == 0 and 2 or 3
		end
	elseif czzpData.qiHuHuXi == 9 then	
		if czzpData.calculationTunMode == 0 then
			calculationFanMode = czzpData.calculationFanMode == 0 and 5 or 6
		elseif czzpData.calculationTunMode == 1 then
			calculationFanMode = czzpData.calculationFanMode == 0 and 5 or 7
		end
	end
	body.calculationFanMode = calculationFanMode  
	body.classic = czzpData.classic
	body.ziMoFan = czzpData.ziMoFan
	body.choiceHu = czzpData.choiceHu
	if body.classic == 1 then
		body.daXiaoZiHu = czzpData.daXiaoZiHu
	else
		body.daXiaoZiHu = false
	end
	body.play21 = not czzpData.play15
	body.maoHuHuXi = czzpData.maoHuHuXi
	body.huangZhuangFen = czzpData.huangZhuangFen
	body.huangKeepBanker = czzpData.huangKeepBanker
	body.chou = czzpData.size == 2 and czzpData.chou or 0
	body.piao = czzpData.piao
	if czzpData.piao == 0 then
		body.niao = czzpData.niao
		body.niaoValue =  czzpData.niao and czzpData.niaoValue or 0
	else
		body.niao = false
		body.niaoValue = 0
	end
	body.openIp	 = czzpData.openIp
	body.openGps = czzpData.openGps
	if czzpData.size == 2 then
		body.resultScore = czzpData.isSettlementScore
		if czzpData.isSettlementScore then
			body.resultLowerScore=czzpData.fewerValue
			body.resultAddScore=czzpData.addValue
		end
		body.choiceDouble = czzpData.choiceDouble
        body.doubleScore = czzpData.doubleScore
        body.multiple = czzpData.multiple
		body.openIp=false
		body.openGps=false
	end
    body.trusteeship = czzpData.trusteeshipTime*60
    body.trusteeshipDissolve = czzpData.trusteeshipType
    body.trusteeshipRound = czzpData.trusteeshipRound
	body.fanXing = false
    return moneyLess,body
end

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
    if czzpObj.ToggleRound6.gameObject == go then
        czzpData.rounds = 6
	elseif czzpObj.ToggleRound8.gameObject == go then
        czzpData.rounds = 8
    elseif czzpObj.ToggleRound10.gameObject == go then
        czzpData.rounds = 10
    else
        czzpData.rounds = 16
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.CZZP,czzpData.rounds,nil,nil)
    UnityEngine.PlayerPrefs.SetInt('NewCZZProunds', czzpData.rounds)
end

function this.OnClickTogglePlayerNum(go)
	AudioManager.Instance:PlayAudio('btn')
    if czzpObj.TogglePeopleNum2.gameObject == go then
        czzpData.size = 2
    elseif czzpObj.TogglePeopleNum3.gameObject == go then
		czzpData.size = 3
	elseif czzpObj.TogglePeopleNum4.gameObject == go then
        czzpData.size = 4
    end
	czzpObj.ToggleChou0.parent.gameObject:SetActive(czzpData.size == 2)
	czzpObj.ToggleNoChoiceDouble.parent.gameObject:SetActive(czzpData.size==2)
	czzpObj.ToggleMultiple2.parent.gameObject:SetActive(czzpData.choiceDouble and czzpData.size == 2)
	czzpObj.DoubleScoreText.parent.gameObject:SetActive(czzpData.choiceDouble)
	czzpObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(czzpData.size==2)
	czzpObj.ToggleIPcheck.parent.gameObject:SetActive(czzpData.size > 2 and CONST.IPcheckOn)
	if czzpData.size == 4 then
		czzpData.play15 = true
		UnityEngine.PlayerPrefs.SetInt('NewCZZPplay15', czzpData.play15 and 1 or 0)
		czzpObj.TogglePlay15:GetComponent('UIToggle'):Set(true)
	end
	czzpObj.TogglePlay15:GetComponent('BoxCollider').enabled = czzpData.size ~=4
	UnityEngine.PlayerPrefs.SetInt('NewCZZPsize', czzpData.size)
    CZZP:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if czzpObj.ToggleMasterPay.gameObject == go then
        czzpData.paymentType=0
    elseif czzpObj.ToggleWinnerPay.gameObject == go then
        czzpData.paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewCZZPpaymentType', czzpData.paymentType)
end

function this.OnClickRandomBanker(go)
    AudioManager.Instance:PlayAudio('btn')
    if czzpObj.ToggleRandomBanker.gameObject == go then
        czzpData.randomBanker = true
    elseif czzpObj.ToggleBankerFrist.gameObject == go then
        czzpData.randomBanker = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewCZZPrandomBanker', czzpData.randomBanker and 1 or 0)
end
function this.OnClickQiHuScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if czzpObj.ToggleQiHu3.gameObject == go then
        czzpData.qiHuHuXi = 3
    elseif czzpObj.ToggleQiHu6.gameObject == go then
		czzpData.qiHuHuXi = 6
	elseif czzpObj.ToggleQiHu9.gameObject == go then
        czzpData.qiHuHuXi = 9
	end
	this.SetShowQiHuTun()
	if czzpData.qiHuHuXi == 3 and czzpData.calculationTunMode == 0 then
		this.OnClickQiHuTun(czzpObj.ToggleQiHu9Xi1Tun.gameObject)
		czzpObj.ToggleQiHu9Xi1Tun:GetComponent('UIToggle'):Set(true)
		czzpObj.ToggleQiHu9Xi3Tun:GetComponent('UIToggle'):Set(false)	
	end
    UnityEngine.PlayerPrefs.SetInt('NewCZZPqiHuHuXi', czzpData.qiHuHuXi)
end

function this.OnClickHuXiSuanFen(go)
	AudioManager.Instance:PlayAudio('btn')
    if czzpObj.ToggleSanXiYiTun.gameObject == go then
        czzpData.calculationTunMode = 0
	elseif czzpObj.ToggleYiXiYiTun.gameObject == go then
        czzpData.calculationTunMode = 1
	end
	this.SetShowQiHuTun()
	if czzpData.qiHuHuXi == 3 and czzpData.calculationTunMode == 0 then
		this.OnClickQiHuTun(czzpObj.ToggleQiHu9Xi1Tun.gameObject)
		czzpObj.ToggleQiHu9Xi1Tun:GetComponent('UIToggle'):Set(true)
		czzpObj.ToggleQiHu9Xi3Tun:GetComponent('UIToggle'):Set(false)	
	end
    UnityEngine.PlayerPrefs.SetInt('NewCZZPcalculationTunMode', czzpData.calculationTunMode)
end

function this.SetShowQiHuTun()
	local str1 = ''
	local str2 = ''
	if czzpData.qiHuHuXi == 3 then
		str1 = '起胡3息1囤'
		str2 = czzpData.calculationTunMode == 0 and '' or '起胡3息3囤'
	elseif czzpData.qiHuHuXi == 6 then
		str1 = '起胡6息1囤'
		str2 = czzpData.calculationTunMode == 0 and '起胡6息2囤' or '起胡6息6囤'
	elseif czzpData.qiHuHuXi == 9 then
		str1 = '起胡9息1囤'
		str2 = czzpData.calculationTunMode == 0 and '起胡9息3囤' or '起胡9息9囤'
	end
	czzpObj.ToggleQiHu9Xi1Tun:Find('Label'):GetComponent('UILabel').text = str1
	czzpObj.ToggleQiHu9Xi3Tun:Find('Label'):GetComponent('UILabel').text = str2
	czzpObj.ToggleQiHu9Xi3Tun.gameObject:SetActive(not (czzpData.qiHuHuXi == 3 and czzpData.calculationTunMode == 0))
end

function this.OnClickQiHuTun(go)
	AudioManager.Instance:PlayAudio('btn')
    if czzpObj.ToggleQiHu9Xi1Tun.gameObject == go then
        czzpData.calculationFanMode = 0
    elseif czzpObj.ToggleQiHu9Xi3Tun.gameObject == go then
		czzpData.calculationFanMode = 1
	end
    UnityEngine.PlayerPrefs.SetInt('NewCZZPcalculationFanMode', czzpData.calculationFanMode)
end

function this.OnClickClassic(go)
	AudioManager.Instance:PlayAudio('btn')
    if czzpObj.ToggleQClassic0.gameObject == go then
        czzpData.classic = 0
    elseif czzpObj.ToggleQClassic1.gameObject == go then
		czzpData.classic = 1
	elseif czzpObj.ToggleQClassic2.gameObject == go then
        czzpData.classic = 2
	end
	czzpObj.ToggleDaXiaoHongHu.gameObject:SetActive(czzpData.classic == 1)
    UnityEngine.PlayerPrefs.SetInt('NewCZZPclassic', czzpData.classic)
end

function this.OnClickToggleCZZPPlay(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == czzpObj.ToggleZiMoFan.gameObject then
		czzpData.ziMoFan = czzpObj.ToggleZiMoFan:GetComponent('UIToggle').value and 2 or 0
		UnityEngine.PlayerPrefs.SetInt('NewCZZPziMoFan', czzpData.ziMoFan)
	elseif go == czzpObj.ToggleYouHuBiHu.gameObject then
		if czzpObj.ToggleYouHuBiHu:GetComponent('UIToggle').value then
			czzpData.choiceHu = 1
		else
			if czzpObj.ToggleFangPaoBiHu:GetComponent('UIToggle').value then
				czzpData.choiceHu = 2
			else
				czzpData.choiceHu = 0
			end
		end
		czzpObj.ToggleFangPaoBiHu.gameObject:SetActive(czzpData.choiceHu ~= 1)
		UnityEngine.PlayerPrefs.SetInt('NewCZZPchoiceHu', czzpData.choiceHu)
	elseif go == czzpObj.ToggleFangPaoBiHu.gameObject then
		czzpData.choiceHu = czzpObj.ToggleFangPaoBiHu:GetComponent('UIToggle').value and 2 or 0
		UnityEngine.PlayerPrefs.SetInt('NewCZZPchoiceHu', czzpData.choiceHu)
	elseif go == czzpObj.ToggleDaXiaoHongHu.gameObject then
		czzpData.daXiaoZiHu = czzpObj.ToggleDaXiaoHongHu:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewCZZPdaXiaoZiHu', czzpData.daXiaoZiHu and 1 or 0)
	elseif go == czzpObj.TogglePlay15.gameObject then
		czzpData.play15 = czzpObj.TogglePlay15:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewCZZPplay15', czzpData.play15 and 1 or 0)
	end
end

function this.OnClickMaoHuType(go)
	AudioManager.Instance:PlayAudio('btn')
	czzpData.maoHuHuXi = tonumber(go.name)
	local maoHuHuXi = ''
	if czzpData.maoHuHuXi == 0 then
		maoHuHuXi = '无毛胡'
	else
		maoHuHuXi = '毛胡'..czzpData.maoHuHuXi..'胡'
	end
	czzpObj.MaoHuLabel:GetComponent('UILabel').text = maoHuHuXi
	czzpObj.maoHuType.gameObject:SetActive(false)
    UnityEngine.PlayerPrefs.SetInt('NewCZZPmaoHuHuXi', czzpData.maoHuHuXi)
end

function this.OnClickChangeHuangZhuangKouFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if czzpObj.AddBtnHuangZhuangKouFen.gameObject == go then
		czzpData.huangZhuangFen = czzpData.huangZhuangFen + 1
		if czzpData.huangZhuangFen > 10 then
			czzpData.huangZhuangFen = 10
		end
    else
		czzpData.huangZhuangFen = czzpData.huangZhuangFen - 1
		if czzpData.huangZhuangFen < 0 then
			czzpData.huangZhuangFen = 0
		end
    end
	czzpObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = czzpData.huangZhuangFen == 0 and '不扣分' or '扣'..czzpData.huangZhuangFen..'分'
	UnityEngine.PlayerPrefs.SetInt('NewCZZPhuangZhuangFen', czzpData.huangZhuangFen)
end

function this.OnClickContinueBanker(go)
	czzpData.huangKeepBanker = czzpObj.ContinueBanker:GetComponent('UIToggle').value
	UnityEngine.PlayerPrefs.SetInt('NewYJGHZhuangKeepBanker', czzpData.huangKeepBanker and 1 or 0)
end

function this.OnClickToggleChou(go)
	AudioManager.Instance:PlayAudio('btn')
	if czzpObj.ToggleChou0.gameObject == go then
        czzpData.chou=0
    elseif czzpObj.ToggleChou10.gameObject == go then
        czzpData.chou=10
    elseif czzpObj.ToggleChou20.gameObject == go then
        czzpData.chou=20
	end
	UnityEngine.PlayerPrefs.SetInt('NewCZZPchou', czzpData.chou)
end

function this.OnClickTogglePiao(go)
	AudioManager.Instance:PlayAudio('btn')
	czzpData.piao=tonumber(go.name)
	if czzpData.piao ~= 0 then
		this.OnClickNiao(czzpObj.ToggleOffNiao.gameObject)
		czzpObj.ToggleOnNiao:GetComponent('UIToggle'):Set(czzpData.niao)
		czzpObj.ToggleOffNiao:GetComponent('UIToggle'):Set(not czzpData.niao)
	end
	UnityEngine.PlayerPrefs.SetInt('NewCZZPpiao', czzpData.piao)
end

function this.OnClickNiao(go)
	AudioManager.Instance:PlayAudio('btn')
	if czzpObj.ToggleOnNiao.gameObject == go then
		czzpData.niao = true
	elseif czzpObj.ToggleOffNiao.gameObject == go then
		czzpData.niao = false
	end
	if czzpData.niao then
		this.OnClickTogglePiao(czzpObj.TogglePiao0.gameObject)
		czzpObj.TogglePiao0:GetComponent('UIToggle'):Set(czzpData.piao == 0)
		czzpObj.TogglePiao1:GetComponent('UIToggle'):Set(czzpData.piao == 1)
		czzpObj.TogglePiao2:GetComponent('UIToggle'):Set(czzpData.piao == 2)
		czzpObj.TogglePiao3:GetComponent('UIToggle'):Set(czzpData.piao == 3)
	end
	czzpObj.NiaoValueText.parent.gameObject:SetActive(czzpData.niao)
	UnityEngine.PlayerPrefs.SetInt('NewCZZPniao', czzpData.niao and 1 or 0)
end

function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if czzpObj.AddButtonNiao.gameObject == go then
		czzpData.niaoValue = czzpData.niaoValue + 10
		if czzpData.niaoValue > 100 then
			czzpData.niaoValue = 100
		end
	elseif czzpObj.SubtractButtonNiao.gameObject == go then
		czzpData.niaoValue = czzpData.niaoValue - 10
		if czzpData.niaoValue < 10 then
			czzpData.niaoValue = 10
		end
	end
	czzpObj.NiaoValueText:GetComponent('UILabel').text = czzpData.niaoValue.."分"
	UnityEngine.PlayerPrefs.SetInt('NewCZZPniaoValue', czzpData.niaoValue)
end

function this.OnClickChoiceDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if czzpObj.ToggleChoiceDouble.gameObject == go then
        czzpData.choiceDouble = true
    elseif czzpObj.ToggleNoChoiceDouble.gameObject == go then
        czzpData.choiceDouble = false
    end
    czzpObj.DoubleScoreText.parent.gameObject:SetActive(czzpData.choiceDouble)
    czzpObj.ToggleMultiple2.parent.gameObject:SetActive(czzpData.choiceDouble)
    CZZP:Find('table'):GetComponent('UIGrid'):Reposition()
    UnityEngine.PlayerPrefs.SetInt('NewCZZPchoiceDouble', czzpData.choiceDouble and 1 or 0)
end

function this.OnClickChangeDoubleScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if czzpObj.AddDoubleScoreButton.gameObject == go then
        if czzpData.doubleScore ~= 0 then
            czzpData.doubleScore = czzpData.doubleScore + 1
            if czzpData.doubleScore > 100 then
                czzpData.doubleScore = 0
            end
        end
    else
        if czzpData.doubleScore == 0 then
            czzpData.doubleScore = 100
        else
            czzpData.doubleScore = czzpData.doubleScore - 1
            if czzpData.doubleScore < 1 then
                czzpData.doubleScore = 1
            end
        end
    end
    if czzpData.doubleScore == 0 then
        czzpObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
    else
        czzpObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..czzpData.doubleScore..'分'
    end
    UnityEngine.PlayerPrefs.SetInt('NewCZZPdoubleScore', czzpData.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
    if czzpObj.ToggleMultiple2.gameObject == go then
        czzpData.multiple=2
    elseif czzpObj.ToggleMultiple3.gameObject == go then
        czzpData.multiple=3
    elseif czzpObj.ToggleMultiple4.gameObject == go then
        czzpData.multiple=4
    end
    UnityEngine.PlayerPrefs.SetInt('NewCZZPmultiple', czzpData.multiple)
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    czzpData.isSettlementScore= czzpObj.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewCZZPisSettlementScore', czzpData.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if czzpObj.ToggleFewerAddButton.gameObject == go then
		czzpData.fewerValue = czzpData.fewerValue + 1
		if czzpData.fewerValue > 100 then
			czzpData.fewerValue = 100
		end
    elseif czzpObj.ToggleFewerSubtractButton.gameObject == go then
		czzpData.fewerValue = czzpData.fewerValue - 1
		if czzpData.fewerValue < 1 then
			czzpData.fewerValue = 1
		end
	end
	czzpObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = czzpData.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewCZZPfewerValue', czzpData.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if czzpObj.ToggleAddAddButton.gameObject == go then
		czzpData.addValue = czzpData.addValue + 1
		if czzpData.addValue > 100 then
			czzpData.addValue = 100
		end
    elseif czzpObj.ToggleAddSubtractButton.gameObject == go then
		czzpData.addValue = czzpData.addValue - 1
		if czzpData.addValue < 1 then
			czzpData.addValue = 1
		end
	end
	czzpObj.ToggleAddScoreTxt:GetComponent('UILabel').text = czzpData.addValue
	UnityEngine.PlayerPrefs.SetInt('NewCZZPaddValue', czzpData.addValue)
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if czzpObj.ToggleTrusteeshipNo.gameObject == go then
        czzpData.trusteeshipTime = 0
    elseif czzpObj.ToggleTrusteeship1.gameObject == go then
        czzpData.trusteeshipTime = 1
	elseif czzpObj.ToggleTrusteeship2.gameObject == go then
		czzpData.trusteeshipTime = 2
    elseif czzpObj.ToggleTrusteeship3.gameObject == go then
        czzpData.trusteeshipTime = 3
    elseif czzpObj.ToggleTrusteeship5.gameObject == go then
        czzpData.trusteeshipTime = 5
	end
    UnityEngine.PlayerPrefs.SetInt('NewCZZPtrusteeshipTime', czzpData.trusteeshipTime)
	czzpObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(czzpData.trusteeshipTime ~= 0)
	CZZP:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if czzpObj.ToggleTrusteeshipOne.gameObject == go then
        czzpData.trusteeshipType = true
		czzpData.trusteeshipRound = 0;
    elseif czzpObj.ToggleTrusteeshipAll.gameObject == go then
        czzpData.trusteeshipType = false
		czzpData.trusteeshipRound = 0;
	elseif czzpObj.ToggleTrusteeshipThree.gameObject == go then
		czzpData.trusteeshipType = false;
		czzpData.trusteeshipRound = 3;
    end
    UnityEngine.PlayerPrefs.SetInt('NewCZZPtrusteeshipType',czzpData.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewCZZPtrusteeshipRound',czzpData.trusteeshipRound )
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if czzpObj.ToggleIPcheck.gameObject == go then
		czzpData.openIp = czzpObj.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('CZZPcheckIP', czzpData.openIp and 1 or 0)
	elseif czzpObj.ToggleGPScheck.gameObject == go then
		czzpData.openGps = czzpObj.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('CZZPcheckGPS', czzpData.openGps and 1 or 0)
	end
end

return this