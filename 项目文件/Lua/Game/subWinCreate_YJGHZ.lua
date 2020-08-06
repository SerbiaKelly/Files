local this = {}

local YJGHZ
local payLabel

local yjghzData = {}
local yjghzObj = {}

function this.Init(grid,message)
	print('Init_YJGHZ')
	YJGHZ = grid
	payLabel = message.transform:Find('diamond/pay_label')

	yjghzObj.ToggleRound6 = YJGHZ:Find('table/round/round6')
	yjghzObj.ToggleRound8 = YJGHZ:Find('table/round/round8')
	yjghzObj.ToggleRound10 = YJGHZ:Find('table/round/round10')
	yjghzObj.ToggleRound16 = YJGHZ:Find('table/round/round16')
	message:AddClick(yjghzObj.ToggleRound6.gameObject, this.OnClickToggleRound)
	message:AddClick(yjghzObj.ToggleRound8.gameObject, this.OnClickToggleRound)
	message:AddClick(yjghzObj.ToggleRound10.gameObject, this.OnClickToggleRound)
	message:AddClick(yjghzObj.ToggleRound16.gameObject, this.OnClickToggleRound)

	yjghzObj.TogglePeopleNum2 = YJGHZ:Find('table/num/num2')
	yjghzObj.TogglePeopleNum3 = YJGHZ:Find('table/num/num3')
	message:AddClick(yjghzObj.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(yjghzObj.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)

	yjghzObj.ToggleMasterPay = YJGHZ:Find('table/pay/master')
	yjghzObj.ToggleWinnerPay = YJGHZ:Find('table/pay/win')
	message:AddClick(yjghzObj.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(yjghzObj.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)

	yjghzObj.ToggleRandomBanker = YJGHZ:Find('table/randomBanker/Auto')
	yjghzObj.ToggleBankerFrist = YJGHZ:Find('table/randomBanker/Frist')
	message:AddClick(yjghzObj.ToggleRandomBanker.gameObject, this.OnClickRandomBanker)
	message:AddClick(yjghzObj.ToggleBankerFrist.gameObject, this.OnClickRandomBanker)

	yjghzObj.ToggleWai5Kan5 = YJGHZ:Find('table/mode/5')
	yjghzObj.ToggleWai10Kan10 = YJGHZ:Find('table/mode/10')
	message:AddClick(yjghzObj.ToggleWai5Kan5.gameObject, this.OnClickModeSetting)
	message:AddClick(yjghzObj.ToggleWai10Kan10.gameObject, this.OnClickModeSetting)

	yjghzObj.ToggleBuKePiao = YJGHZ:Find('table/play1/buKePiao')
	yjghzObj.ToggleJiuDuiBan = YJGHZ:Find('table/play1/jiuDuiBan')
	yjghzObj.ToggleWuXiPing = YJGHZ:Find('table/play1/wuXiPing')
	yjghzObj.ToggleDiaoDiaoShou50Xi = YJGHZ:Find('table/play2/diaoDiaoShou50Xi')
	yjghzObj.ToggleXingXingXi2Fan = YJGHZ:Find('table/play2/xingXingXi2Fan')
	yjghzObj.ToggleTianHu = YJGHZ:Find('table/play2/tianHu')
	yjghzObj.ToggleDiHu = YJGHZ:Find('table/play3/diHu')
	yjghzObj.ToggleHaiDiHu = YJGHZ:Find('table/play3/haiDiHu')
	message:AddClick(yjghzObj.ToggleBuKePiao.gameObject, this.OnClickTogglePlay)
	message:AddClick(yjghzObj.ToggleJiuDuiBan.gameObject, this.OnClickTogglePlay)
	message:AddClick(yjghzObj.ToggleWuXiPing.gameObject, this.OnClickTogglePlay)
	message:AddClick(yjghzObj.ToggleDiaoDiaoShou50Xi.gameObject, this.OnClickTogglePlay)
	message:AddClick(yjghzObj.ToggleXingXingXi2Fan.gameObject, this.OnClickTogglePlay)
	message:AddClick(yjghzObj.ToggleTianHu.gameObject, this.OnClickTogglePlay)
	message:AddClick(yjghzObj.ToggleDiHu.gameObject, this.OnClickTogglePlay)
	message:AddClick(yjghzObj.ToggleHaiDiHu.gameObject, this.OnClickTogglePlay)

	yjghzObj.AddBtnFengDing = YJGHZ:Find('table/fengDing/fengDingScore/AddButton')
	yjghzObj.SubtractBtnFengDing = YJGHZ:Find('table/fengDing/fengDingScore/SubtractButton')
	yjghzObj.FengDingValue = YJGHZ:Find('table/fengDing/fengDingScore/Value')
	message:AddClick(yjghzObj.AddBtnFengDing.gameObject, this.OnClickChangeFengDingValue)
	message:AddClick(yjghzObj.SubtractBtnFengDing.gameObject, this.OnClickChangeFengDingValue)

	yjghzObj.AddBtnHuangZhuangKouFen = YJGHZ:Find('table/huangZhuangKouFen/kouScore/AddButton')
	yjghzObj.SubtractBtnHuangZhuangKouFen = YJGHZ:Find('table/huangZhuangKouFen/kouScore/SubtractButton')
	yjghzObj.HuangZhuangKouFenValue = YJGHZ:Find('table/huangZhuangKouFen/kouScore/Value')
	message:AddClick(yjghzObj.AddBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)
	message:AddClick(yjghzObj.SubtractBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)
	yjghzObj.ContinueBanker = YJGHZ:Find('table/huangZhuangKouFen/continueBanker')
	message:AddClick(yjghzObj.ContinueBanker.gameObject, this.OnClickContinueBanker)

	yjghzObj.ToggleChou0 = YJGHZ:Find('table/chouCard/chouCard0')
	yjghzObj.ToggleChou10 = YJGHZ:Find('table/chouCard/chouCard10')
	yjghzObj.ToggleChou20 = YJGHZ:Find('table/chouCard/chouCard20')
	message:AddClick(yjghzObj.ToggleChou0.gameObject, this.OnClickToggleChou)
	message:AddClick(yjghzObj.ToggleChou10.gameObject, this.OnClickToggleChou)
	message:AddClick(yjghzObj.ToggleChou20.gameObject, this.OnClickToggleChou)

	yjghzObj.ToggleOnNiao = YJGHZ:Find('table/niao/OnNiao')
	yjghzObj.ToggleOffNiao = YJGHZ:Find('table/niao/OffNiao')
	yjghzObj.NiaoValueText = YJGHZ:Find('table/niao/NiaoValue/Value')
	yjghzObj.AddButtonNiao = YJGHZ:Find('table/niao/NiaoValue/AddButton')
	yjghzObj.SubtractButtonNiao = YJGHZ:Find('table/niao/NiaoValue/SubtractButton')
	message:AddClick(yjghzObj.ToggleOnNiao.gameObject, this.OnClickNiao)
	message:AddClick(yjghzObj.ToggleOffNiao.gameObject, this.OnClickNiao)
	message:AddClick(yjghzObj.AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(yjghzObj.SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)

	yjghzObj.ToggleChoiceDouble = YJGHZ:Find('table/choiceDouble/On')
	yjghzObj.ToggleNoChoiceDouble = YJGHZ:Find('table/choiceDouble/Off')
	yjghzObj.DoubleScoreText = YJGHZ:Find('table/choiceDouble/doubleScore/Value')
	yjghzObj.AddDoubleScoreButton = YJGHZ:Find('table/choiceDouble/doubleScore/AddButton')
	yjghzObj.SubtractDoubleScoreButton = YJGHZ:Find('table/choiceDouble/doubleScore/SubtractButton')
	yjghzObj.ToggleMultiple2 = YJGHZ:Find('table/multiple/2')
	yjghzObj.ToggleMultiple3 = YJGHZ:Find('table/multiple/3')
	yjghzObj.ToggleMultiple4 = YJGHZ:Find('table/multiple/4')
	message:AddClick(yjghzObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(yjghzObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(yjghzObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(yjghzObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(yjghzObj.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(yjghzObj.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(yjghzObj.ToggleMultiple4.gameObject, this.OnClickMultiple)

	yjghzObj.ToggleSettlementScoreSelect=YJGHZ:Find('table/settlementScore/select')
	yjghzObj.ToggleFewerScoreTxt=YJGHZ:Find('table/settlementScore/fewerValue/Value')
	yjghzObj.ToggleFewerAddButton=YJGHZ:Find('table/settlementScore/fewerValue/AddButton')
	yjghzObj.ToggleFewerSubtractButton=YJGHZ:Find('table/settlementScore/fewerValue/SubtractButton')
	yjghzObj.ToggleAddScoreTxt=YJGHZ:Find('table/settlementScore/addValue/Value')
	yjghzObj.ToggleAddAddButton=YJGHZ:Find('table/settlementScore/addValue/AddButton')
	yjghzObj.ToggleAddSubtractButton=YJGHZ:Find('table/settlementScore/addValue/SubtractButton')
	
	message:AddClick(yjghzObj.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(yjghzObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(yjghzObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(yjghzObj.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(yjghzObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)
	
	yjghzObj.ToggleTrusteeshipNo = YJGHZ:Find('table/DelegateChoose/NoDelegate')
	yjghzObj.ToggleTrusteeship1 = YJGHZ:Find('table/DelegateChoose/Delegate1')
	yjghzObj.ToggleTrusteeship2 = YJGHZ:Find('table/DelegateChoose/Delegate2')
	yjghzObj.ToggleTrusteeship3 = YJGHZ:Find('table/DelegateChoose/Delegate3')
	yjghzObj.ToggleTrusteeship5 = YJGHZ:Find('table/DelegateChoose1/Delegate5')
	message:AddClick(yjghzObj.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(yjghzObj.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(yjghzObj.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(yjghzObj.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(yjghzObj.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)

	yjghzObj.ToggleTrusteeshipAll = YJGHZ:Find('table/DelegateCancel/FullRound')
	yjghzObj.ToggleTrusteeshipOne = YJGHZ:Find('table/DelegateCancel/ThisRound')
	yjghzObj.ToggleTrusteeshipThree = YJGHZ:Find('table/DelegateCancel/ThreeRound')
	message:AddClick(yjghzObj.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(yjghzObj.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(yjghzObj.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)
	
	yjghzObj.ToggleIPcheck = YJGHZ:Find('table/PreventCheat/IPcheck')
	yjghzObj.ToggleGPScheck = YJGHZ:Find('table/PreventCheat/GPScheck')
	message:AddClick(yjghzObj.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(yjghzObj.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end
function this.Refresh()
	print('Refresh_YJGHZ')
	yjghzData.rounds=UnityEngine.PlayerPrefs.GetInt('NewYJGHZrounds', 8)
	yjghzObj.ToggleRound6:GetComponent('UIToggle'):Set(yjghzData.rounds == 6)
	yjghzObj.ToggleRound8:GetComponent('UIToggle'):Set(yjghzData.rounds == 8)
	yjghzObj.ToggleRound10:GetComponent('UIToggle'):Set(yjghzData.rounds == 10)
	yjghzObj.ToggleRound16:GetComponent('UIToggle'):Set(yjghzData.rounds == 16)

	yjghzData.size=UnityEngine.PlayerPrefs.GetInt('NewYJGHZsize', 2)
	yjghzObj.TogglePeopleNum2:GetComponent('UIToggle'):Set(yjghzData.size == 2)
	yjghzObj.TogglePeopleNum3:GetComponent('UIToggle'):Set(yjghzData.size == 3)

	yjghzData.paymentType=UnityEngine.PlayerPrefs.GetInt('NewYJGHZpaymentType', 0)
	yjghzObj.ToggleMasterPay:GetComponent('UIToggle'):Set(yjghzData.paymentType == 0)
	yjghzObj.ToggleWinnerPay:GetComponent('UIToggle'):Set(yjghzData.paymentType == 2)

	yjghzData.randomBanker=UnityEngine.PlayerPrefs.GetInt('NewYJGHZrandomBanker', 0)==1
	yjghzObj.ToggleRandomBanker:GetComponent('UIToggle'):Set(yjghzData.randomBanker)
	yjghzObj.ToggleBankerFrist:GetComponent('UIToggle'):Set(not yjghzData.randomBanker)

	yjghzData.mode=UnityEngine.PlayerPrefs.GetInt('NewYJGHZmode', 0)
	yjghzObj.ToggleWai5Kan5:GetComponent('UIToggle'):Set(yjghzData.mode == 0)
	yjghzObj.ToggleWai10Kan10:GetComponent('UIToggle'):Set(yjghzData.mode == 1)

	yjghzObj.ToggleDiaoDiaoShou50Xi:Find('Label'):GetComponent("UILabel").text = yjghzData.mode == 0 and '吊吊手50息' or '吊吊手100息'
	yjghzData.nopiao=UnityEngine.PlayerPrefs.GetInt('NewYJGHZnopiao', 1)
	yjghzObj.ToggleBuKePiao:GetComponent('UIToggle'):Set(yjghzData.nopiao == 0)
	yjghzData.duiban=UnityEngine.PlayerPrefs.GetInt('NewYJGHZduiban', 0) == 1
	yjghzObj.ToggleJiuDuiBan:GetComponent('UIToggle'):Set(yjghzData.duiban)
	yjghzData.wuxiping=UnityEngine.PlayerPrefs.GetInt('NewYJGHZwuxiping', 0) == 1
	yjghzObj.ToggleWuXiPing:GetComponent('UIToggle'):Set(yjghzData.wuxiping)
	yjghzData.diaodiaoshou=UnityEngine.PlayerPrefs.GetInt('NewYJGHZdiaodiaoshou', 0) == 1
	yjghzObj.ToggleDiaoDiaoShou50Xi:GetComponent('UIToggle'):Set(yjghzData.diaodiaoshou)
	yjghzData.xingxingxi=UnityEngine.PlayerPrefs.GetInt('NewYJGHZxingxingxi', 0) == 1
	yjghzObj.ToggleXingXingXi2Fan:GetComponent('UIToggle'):Set(yjghzData.xingxingxi)
	yjghzData.tianhu=UnityEngine.PlayerPrefs.GetInt('NewYJGHZtianhu', 0) == 1
	yjghzObj.ToggleTianHu:GetComponent('UIToggle'):Set(yjghzData.tianhu)
	yjghzData.dihu=UnityEngine.PlayerPrefs.GetInt('NewYJGHZdihu', 0) == 1
	yjghzObj.ToggleDiHu:GetComponent('UIToggle'):Set(yjghzData.dihu)
	yjghzData.haiDiHu=UnityEngine.PlayerPrefs.GetInt('NewYJGHZhaiDiHu', 0) == 1
	yjghzObj.ToggleHaiDiHu:GetComponent('UIToggle'):Set(yjghzData.haiDiHu)

	yjghzData.maxHuXi=UnityEngine.PlayerPrefs.GetInt('NewYJGHZmaxHuXi', 200)
	yjghzObj.FengDingValue:GetComponent("UILabel").text = yjghzData.maxHuXi..'分'

	yjghzData.huangZhuangFen=UnityEngine.PlayerPrefs.GetInt('NewYJGHZhuangZhuangFen', 0) 
	yjghzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = yjghzData.huangZhuangFen == 0 and '不扣分' or '扣'..yjghzData.huangZhuangFen..'分'
	yjghzData.huangKeepBanker=UnityEngine.PlayerPrefs.GetInt('NewYJGHZhuangKeepBanker', 0) == 1
	yjghzObj.ContinueBanker:GetComponent('UIToggle'):Set(yjghzData.huangKeepBanker)

	yjghzData.chou = UnityEngine.PlayerPrefs.GetInt('NewYJGHZchou', 20)
	yjghzObj.ToggleChou0:GetComponent('UIToggle'):Set(yjghzData.chou == 0)
	yjghzObj.ToggleChou10:GetComponent('UIToggle'):Set(yjghzData.chou == 10)
	yjghzObj.ToggleChou20:GetComponent('UIToggle'):Set(yjghzData.chou == 20)
	yjghzObj.ToggleChou0.parent.gameObject:SetActive(yjghzData.size == 2)

	yjghzData.niao=UnityEngine.PlayerPrefs.GetInt('NewYJGHZniao', 0)==1
	yjghzData.niaoValue=UnityEngine.PlayerPrefs.GetInt('NewYJGHZniaoValue', 10)
	yjghzObj.ToggleOnNiao:GetComponent('UIToggle'):Set(yjghzData.niao)
	yjghzObj.ToggleOffNiao:GetComponent('UIToggle'):Set(not yjghzData.niao)
	yjghzObj.NiaoValueText.parent.gameObject:SetActive(yjghzData.niao)
    yjghzObj.NiaoValueText:GetComponent('UILabel').text = yjghzData.niaoValue.."分"

	yjghzData.choiceDouble=UnityEngine.PlayerPrefs.GetInt('NewYJGHZchoiceDouble', 0)==1
	yjghzData.doubleScore=UnityEngine.PlayerPrefs.GetInt('NewYJGHZdoubleScore', 10)
	yjghzData.multiple=UnityEngine.PlayerPrefs.GetInt('NewYJGHZmultiple', 2)
	yjghzObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(yjghzData.choiceDouble)
	yjghzObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not yjghzData.choiceDouble)
	yjghzObj.DoubleScoreText.parent.gameObject:SetActive(yjghzData.choiceDouble)
	if yjghzData.doubleScore == 0 then
		yjghzObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		yjghzObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..yjghzData.doubleScore..'分'
	end
	yjghzObj.ToggleChoiceDouble.parent.gameObject:SetActive(yjghzData.size == 2)
	yjghzObj.ToggleMultiple2:GetComponent('UIToggle'):Set(yjghzData.multiple == 2)
	yjghzObj.ToggleMultiple3:GetComponent('UIToggle'):Set(yjghzData.multiple == 3)
	yjghzObj.ToggleMultiple4:GetComponent('UIToggle'):Set(yjghzData.multiple == 4)
	yjghzObj.ToggleMultiple2.parent.gameObject:SetActive(yjghzData.choiceDouble and  yjghzData.size == 2)

	yjghzData.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewYJGHZisSettlementScore', 0)==1
	yjghzData.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewYJGHZfewerValue', 10)
	yjghzData.addValue=UnityEngine.PlayerPrefs.GetInt('NewYJGHZaddValue', 10)
	yjghzObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(yjghzData.size==2)
	yjghzObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(yjghzData.isSettlementScore)
	yjghzObj.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	yjghzObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = yjghzData.fewerValue
	yjghzObj.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	yjghzObj.ToggleAddScoreTxt:GetComponent('UILabel').text = yjghzData.addValue

	yjghzData.trusteeshipTime=UnityEngine.PlayerPrefs.GetInt('NewYJGHZtrusteeshipTime', 0)
	yjghzData.trusteeshipType = UnityEngine.PlayerPrefs.GetInt('NewYJGHZtrusteeshipType', 0) == 1
	yjghzData.trusteeshipRound = UnityEngine.PlayerPrefs.GetInt('NewYJGHZtrusteeshipRound', 0)
	yjghzObj.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(yjghzData.trusteeshipTime == 0)
	yjghzObj.ToggleTrusteeship1:GetComponent('UIToggle'):Set(yjghzData.trusteeshipTime == 1)
	yjghzObj.ToggleTrusteeship2:GetComponent('UIToggle'):Set(yjghzData.trusteeshipTime == 2)
	yjghzObj.ToggleTrusteeship3:GetComponent('UIToggle'):Set(yjghzData.trusteeshipTime == 3)
	yjghzObj.ToggleTrusteeship5:GetComponent('UIToggle'):Set(yjghzData.trusteeshipTime == 5)
	yjghzObj.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(yjghzData.trusteeshipType)
	yjghzObj.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not yjghzData.trusteeshipType and yjghzData.trusteeshipRound == 0)
	yjghzObj.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(yjghzData.trusteeshipRound == 3);
	yjghzObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(yjghzData.trusteeshipTime ~= 0)
	
	yjghzData.openIp=UnityEngine.PlayerPrefs.GetInt('YJGHZcheckIP', 0)==1
	yjghzData.openGps=UnityEngine.PlayerPrefs.GetInt('YJGHZcheckGPS', 0)==1
	yjghzObj.ToggleIPcheck:GetComponent('UIToggle'):Set(yjghzData.openIp)
	yjghzObj.ToggleGPScheck:GetComponent('UIToggle'):Set(yjghzData.openGps)
	yjghzObj.ToggleIPcheck.parent.gameObject:SetActive(yjghzData.size > 2 and CONST.IPcheckOn)

	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.YJGHZ,yjghzData.rounds,nil,nil)

	YJGHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end
--获取当前设置
function this.GetConfig()
	local moneyLess = false
	if ((yjghzData.rounds == 6 or yjghzData.rounds == 8) and info_login.balance < 2) 
	or (yjghzData.rounds == 10 and info_login.balance < 3)
	or (yjghzData.rounds == 16 and info_login.balance < 4) then
        moneyLess = true
    end
    local body = {}
    body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.YJGHZ)
	body.rounds = yjghzData.rounds
    body.size = yjghzData.size
    body.paymentType = yjghzData.paymentType
	body.randomBanker = yjghzData.randomBanker
	body.mode = yjghzData.mode
	body.piao = yjghzData.nopiao
	body.jiuDuiBan = yjghzData.duiban
	body.wuXiPing = yjghzData.wuxiping
	body.diaoDiaoShou = yjghzData.diaodiaoshou
	body.hangHangXi2Fan = yjghzData.xingxingxi
	body.tianHu = yjghzData.tianhu
	body.diHu = yjghzData.dihu
	body.haiDiHu = yjghzData.haiDiHu
	body.maxHuXi = yjghzData.maxHuXi
	body.huangZhuangFen = yjghzData.huangZhuangFen
	body.huangKeepBanker = yjghzData.huangKeepBanker
	body.chou = yjghzData.size == 2 and yjghzData.chou or 0
	body.niao = yjghzData.niao
	body.niaoValue =  yjghzData.niao and yjghzData.niaoValue or 0
	body.openIp	 = yjghzData.openIp
	body.openGps = yjghzData.openGps
	if yjghzData.size == 2 then
		body.resultScore = yjghzData.isSettlementScore
		if yjghzData.isSettlementScore then
			body.resultLowerScore=yjghzData.fewerValue
			body.resultAddScore=yjghzData.addValue
		end
		body.choiceDouble = yjghzData.choiceDouble
        body.doubleScore = yjghzData.doubleScore
        body.multiple = yjghzData.multiple
		body.openIp=false
		body.openGps=false
	end
    body.trusteeship = yjghzData.trusteeshipTime*60
    body.trusteeshipDissolve = yjghzData.trusteeshipType
    body.trusteeshipRound = yjghzData.trusteeshipRound
	body.fanXing = false
	body.qiHuHuXi = 5
    return moneyLess,body
end

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
    if yjghzObj.ToggleRound6.gameObject == go then
        yjghzData.rounds = 6
	elseif yjghzObj.ToggleRound8.gameObject == go then
        yjghzData.rounds = 8
    elseif yjghzObj.ToggleRound10.gameObject == go then
        yjghzData.rounds = 10
    else
        yjghzData.rounds = 16
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.YJGHZ,yjghzData.rounds,nil,nil)
    UnityEngine.PlayerPrefs.SetInt('NewYJGHZrounds', yjghzData.rounds)
end

function this.OnClickTogglePlayerNum(go)
	AudioManager.Instance:PlayAudio('btn')
    if yjghzObj.TogglePeopleNum2.gameObject == go then
        yjghzData.size = 2
    elseif yjghzObj.TogglePeopleNum3.gameObject == go then
		yjghzData.size = 3
    end
	yjghzObj.ToggleChou0.parent.gameObject:SetActive(yjghzData.size == 2)
	yjghzObj.ToggleNoChoiceDouble.parent.gameObject:SetActive(yjghzData.size==2)
	yjghzObj.ToggleMultiple2.parent.gameObject:SetActive(yjghzData.choiceDouble and yjghzData.size == 2)
	yjghzObj.DoubleScoreText.parent.gameObject:SetActive(yjghzData.choiceDouble)
	yjghzObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(yjghzData.size==2)
	yjghzObj.ToggleIPcheck.parent.gameObject:SetActive(yjghzData.size > 2 and CONST.IPcheckOn)
	UnityEngine.PlayerPrefs.SetInt('NewYJGHZsize', yjghzData.size)
    YJGHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if yjghzObj.ToggleMasterPay.gameObject == go then
        yjghzData.paymentType=0
    elseif yjghzObj.ToggleWinnerPay.gameObject == go then
        yjghzData.paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewYJGHZpaymentType', yjghzData.paymentType)
end

function this.OnClickRandomBanker(go)
    AudioManager.Instance:PlayAudio('btn')
    if yjghzObj.ToggleRandomBanker.gameObject == go then
        yjghzData.randomBanker = true
    elseif yjghzObj.ToggleBankerFrist.gameObject == go then
        yjghzData.randomBanker = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewYJGHZrandomBanker', yjghzData.randomBanker and 1 or 0)
end
function this.OnClickModeSetting(go)
	AudioManager.Instance:PlayAudio('btn')
    if yjghzObj.ToggleWai5Kan5.gameObject == go then
        yjghzData.mode = 0
    elseif yjghzObj.ToggleWai10Kan10.gameObject == go then
        yjghzData.mode = 1
	end
	yjghzObj.ToggleDiaoDiaoShou50Xi:Find('Label'):GetComponent("UILabel").text = yjghzData.mode == 0 and '吊吊手50息' or '吊吊手100息'
    UnityEngine.PlayerPrefs.SetInt('NewYJGHZmode', yjghzData.mode)
end

function this.OnClickTogglePlay(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == yjghzObj.ToggleBuKePiao.gameObject then
		yjghzData.nopiao = yjghzObj.ToggleBuKePiao:GetComponent('UIToggle').value and 0 or 1
		UnityEngine.PlayerPrefs.SetInt('NewYJGHZnopiao', yjghzData.nopiao)
	elseif go == yjghzObj.ToggleJiuDuiBan.gameObject then
		yjghzData.duiban = yjghzObj.ToggleJiuDuiBan:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewYJGHZduiban', yjghzData.duiban and 1 or 0)
	elseif go == yjghzObj.ToggleWuXiPing.gameObject then
		yjghzData.wuxiping = yjghzObj.ToggleWuXiPing:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewYJGHZwuxiping', yjghzData.wuxiping and 1 or 0)
	elseif go == yjghzObj.ToggleDiaoDiaoShou50Xi.gameObject then
		yjghzData.diaodiaoshou = yjghzObj.ToggleDiaoDiaoShou50Xi:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewYJGHZdiaodiaoshou', yjghzData.diaodiaoshou and 1 or 0)
	elseif go == yjghzObj.ToggleXingXingXi2Fan.gameObject then
		yjghzData.xingxingxi = yjghzObj.ToggleXingXingXi2Fan:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewYJGHZxingxingxi', yjghzData.xingxingxi and 1 or 0)
	elseif go == yjghzObj.ToggleTianHu.gameObject then
		yjghzData.tianhu = yjghzObj.ToggleTianHu:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewYJGHZtianhu', yjghzData.tianhu and 1 or 0)
	elseif go == yjghzObj.ToggleDiHu.gameObject then
		yjghzData.dihu = yjghzObj.ToggleDiHu:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewYJGHZdihu', yjghzData.dihu and 1 or 0)
	elseif go == yjghzObj.ToggleHaiDiHu.gameObject then
		yjghzData.haiDiHu = yjghzObj.ToggleHaiDiHu:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewYJGHZhaiDiHu', yjghzData.haiDiHu and 1 or 0)
	end
end

function this.OnClickChangeFengDingValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if yjghzObj.AddBtnFengDing.gameObject == go then
		yjghzData.maxHuXi = yjghzData.maxHuXi + 100
		if yjghzData.maxHuXi > 800 then
			yjghzData.maxHuXi = 800
		end
    else
		yjghzData.maxHuXi = yjghzData.maxHuXi - 100
		if yjghzData.maxHuXi < 100 then
			yjghzData.maxHuXi = 100
		end
    end
	yjghzObj.FengDingValue:GetComponent("UILabel").text = yjghzData.maxHuXi..'分'
	UnityEngine.PlayerPrefs.SetInt('NewYJGHZmaxHuXi', yjghzData.maxHuXi)
end

function this.OnClickChangeHuangZhuangKouFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if yjghzObj.AddBtnHuangZhuangKouFen.gameObject == go then
		yjghzData.huangZhuangFen = yjghzData.huangZhuangFen + 5
		if yjghzData.huangZhuangFen > 100 then
			yjghzData.huangZhuangFen = 100
		elseif yjghzData.huangZhuangFen == 5 then
			yjghzData.huangZhuangFen = 10
		end
    else
		yjghzData.huangZhuangFen = yjghzData.huangZhuangFen - 5
		if yjghzData.huangZhuangFen < 10 then
			yjghzData.huangZhuangFen = 0
		end
    end
	yjghzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = yjghzData.huangZhuangFen == 0 and '不扣分' or '扣'..yjghzData.huangZhuangFen..'分'
	UnityEngine.PlayerPrefs.SetInt('NewYJGHZhuangZhuangFen', yjghzData.huangZhuangFen)
end

function this.OnClickContinueBanker(go)
	yjghzData.huangKeepBanker = yjghzObj.ContinueBanker:GetComponent('UIToggle').value
	UnityEngine.PlayerPrefs.SetInt('NewYJGHZhuangKeepBanker', yjghzData.huangKeepBanker and 1 or 0)
end

function this.OnClickToggleChou(go)
	AudioManager.Instance:PlayAudio('btn')
	if yjghzObj.ToggleChou0.gameObject == go then
        yjghzData.chou=0
    elseif yjghzObj.ToggleChou10.gameObject == go then
        yjghzData.chou=10
    elseif yjghzObj.ToggleChou20.gameObject == go then
        yjghzData.chou=20
	end
	UnityEngine.PlayerPrefs.SetInt('NewYJGHZchou', yjghzData.chou)
end

function this.OnClickNiao(go)
	AudioManager.Instance:PlayAudio('btn')
	if yjghzObj.ToggleOnNiao.gameObject == go then
		yjghzData.niao = true
	elseif yjghzObj.ToggleOffNiao.gameObject == go then
		yjghzData.niao = false
	end
	yjghzObj.NiaoValueText.parent.gameObject:SetActive(yjghzData.niao)
	UnityEngine.PlayerPrefs.SetInt('NewYJGHZniao', yjghzData.niao and 1 or 0)
end

function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if yjghzObj.AddButtonNiao.gameObject == go then
		yjghzData.niaoValue = yjghzData.niaoValue + 10
		if yjghzData.niaoValue > 100 then
			yjghzData.niaoValue = 100
		end
	elseif yjghzObj.SubtractButtonNiao.gameObject == go then
		yjghzData.niaoValue = yjghzData.niaoValue - 10
		if yjghzData.niaoValue < 10 then
			yjghzData.niaoValue = 10
		end
	end
	yjghzObj.NiaoValueText:GetComponent('UILabel').text = yjghzData.niaoValue.."分"
	UnityEngine.PlayerPrefs.SetInt('NewYJGHZniaoValue', yjghzData.niaoValue)
end

function this.OnClickChoiceDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if yjghzObj.ToggleChoiceDouble.gameObject == go then
        yjghzData.choiceDouble = true
    elseif yjghzObj.ToggleNoChoiceDouble.gameObject == go then
        yjghzData.choiceDouble = false
    end
    yjghzObj.DoubleScoreText.parent.gameObject:SetActive(yjghzData.choiceDouble)
    yjghzObj.ToggleMultiple2.parent.gameObject:SetActive(yjghzData.choiceDouble)
    YJGHZ:Find('table'):GetComponent('UIGrid'):Reposition()
    UnityEngine.PlayerPrefs.SetInt('NewYJGHZchoiceDouble', yjghzData.choiceDouble and 1 or 0)
end

function this.OnClickChangeDoubleScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if yjghzObj.AddDoubleScoreButton.gameObject == go then
        if yjghzData.doubleScore ~= 0 then
            yjghzData.doubleScore = yjghzData.doubleScore + 1
            if yjghzData.doubleScore > 100 then
                yjghzData.doubleScore = 0
            end
        end
    else
        if yjghzData.doubleScore == 0 then
            yjghzData.doubleScore = 100
        else
            yjghzData.doubleScore = yjghzData.doubleScore - 1
            if yjghzData.doubleScore < 1 then
                yjghzData.doubleScore = 1
            end
        end
    end
    if yjghzData.doubleScore == 0 then
        yjghzObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
    else
        yjghzObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..yjghzData.doubleScore..'分'
    end
    UnityEngine.PlayerPrefs.SetInt('NewYJGHZdoubleScore', yjghzData.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
    if yjghzObj.ToggleMultiple2.gameObject == go then
        yjghzData.multiple=2
    elseif yjghzObj.ToggleMultiple3.gameObject == go then
        yjghzData.multiple=3
    elseif yjghzObj.ToggleMultiple4.gameObject == go then
        yjghzData.multiple=4
    end
    UnityEngine.PlayerPrefs.SetInt('NewYJGHZmultiple', yjghzData.multiple)
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    yjghzData.isSettlementScore= yjghzObj.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewYJGHZisSettlementScore', yjghzData.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if yjghzObj.ToggleFewerAddButton.gameObject == go then
		yjghzData.fewerValue = yjghzData.fewerValue + 1
		if yjghzData.fewerValue > 100 then
			yjghzData.fewerValue = 100
		end
    elseif yjghzObj.ToggleFewerSubtractButton.gameObject == go then
		yjghzData.fewerValue = yjghzData.fewerValue - 1
		if yjghzData.fewerValue < 1 then
			yjghzData.fewerValue = 1
		end
	end
	yjghzObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = yjghzData.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewYJGHZfewerValue', yjghzData.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if yjghzObj.ToggleAddAddButton.gameObject == go then
		yjghzData.addValue = yjghzData.addValue + 1
		if yjghzData.addValue > 100 then
			yjghzData.addValue = 100
		end
    elseif yjghzObj.ToggleAddSubtractButton.gameObject == go then
		yjghzData.addValue = yjghzData.addValue - 1
		if yjghzData.addValue < 1 then
			yjghzData.addValue = 1
		end
	end
	yjghzObj.ToggleAddScoreTxt:GetComponent('UILabel').text = yjghzData.addValue
	UnityEngine.PlayerPrefs.SetInt('NewYJGHZaddValue', yjghzData.addValue)
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if yjghzObj.ToggleTrusteeshipNo.gameObject == go then
        yjghzData.trusteeshipTime = 0
    elseif yjghzObj.ToggleTrusteeship1.gameObject == go then
        yjghzData.trusteeshipTime = 1
	elseif yjghzObj.ToggleTrusteeship2.gameObject == go then
		yjghzData.trusteeshipTime = 2
    elseif yjghzObj.ToggleTrusteeship3.gameObject == go then
        yjghzData.trusteeshipTime = 3
    elseif yjghzObj.ToggleTrusteeship5.gameObject == go then
        yjghzData.trusteeshipTime = 5
	end
    UnityEngine.PlayerPrefs.SetInt('NewYJGHZtrusteeshipTime', yjghzData.trusteeshipTime)
	yjghzObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(yjghzData.trusteeshipTime ~= 0)
	YJGHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if yjghzObj.ToggleTrusteeshipOne.gameObject == go then
        yjghzData.trusteeshipType = true
		yjghzData.trusteeshipRound = 0;
    elseif yjghzObj.ToggleTrusteeshipAll.gameObject == go then
        yjghzData.trusteeshipType = false
		yjghzData.trusteeshipRound = 0;
	elseif yjghzObj.ToggleTrusteeshipThree.gameObject == go then
		yjghzData.trusteeshipType = false;
		yjghzData.trusteeshipRound = 3;
    end
    UnityEngine.PlayerPrefs.SetInt('NewYJGHZtrusteeshipType',yjghzData.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewYJGHZtrusteeshipRound',yjghzData.trusteeshipRound )
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if yjghzObj.ToggleIPcheck.gameObject == go then
		yjghzData.openIp = yjghzObj.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('YJGHZcheckIP', yjghzData.openIp and 1 or 0)
	elseif yjghzObj.ToggleGPScheck.gameObject == go then
		yjghzData.openGps = yjghzObj.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('YJGHZcheckGPS', yjghzData.openGps and 1 or 0)
	end
end

return this