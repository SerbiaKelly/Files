local this = {}

local HSPHZ
local payLabel

local hsphzObj = {}
local hsphzData = {}

function this.Init(grid,message)
	print('Init_HSPHZ')
	HSPHZ = grid
	payLabel = message.transform:Find('diamond/pay_label')

	hsphzObj.ToggleRound6 = HSPHZ:Find('table/round/round6')
	hsphzObj.ToggleRound8 = HSPHZ:Find('table/round/round8')
	hsphzObj.ToggleRound10 = HSPHZ:Find('table/round/round10')
	hsphzObj.ToggleRound16 = HSPHZ:Find('table/round/round16')
	message:AddClick(hsphzObj.ToggleRound6.gameObject, this.OnClickToggleRound)
	message:AddClick(hsphzObj.ToggleRound8.gameObject, this.OnClickToggleRound)
	message:AddClick(hsphzObj.ToggleRound10.gameObject, this.OnClickToggleRound)
	message:AddClick(hsphzObj.ToggleRound16.gameObject, this.OnClickToggleRound)

	hsphzObj.TogglePeopleNum2 = HSPHZ:Find('table/num/num2')
	hsphzObj.TogglePeopleNum3 = HSPHZ:Find('table/num/num3')
	message:AddClick(hsphzObj.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(hsphzObj.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)

	hsphzObj.ToggleMasterPay = HSPHZ:Find('table/pay/master')
	hsphzObj.ToggleWinnerPay = HSPHZ:Find('table/pay/win')
	message:AddClick(hsphzObj.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(hsphzObj.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)

	hsphzObj.ToggleRandomBanker = HSPHZ:Find('table/randomBanker/Auto')
	hsphzObj.ToggleBankerFrist = HSPHZ:Find('table/randomBanker/Frist')
	message:AddClick(hsphzObj.ToggleRandomBanker.gameObject, this.OnClickRandomBanker)
	message:AddClick(hsphzObj.ToggleBankerFrist.gameObject, this.OnClickRandomBanker)

	hsphzObj.AddBtnQiHuTun = HSPHZ:Find('table/qiHu/qiHuScore/AddButton')
	hsphzObj.SubtractBtnQiHuTun = HSPHZ:Find('table/qiHu/qiHuScore/SubtractButton')
	hsphzObj.QiHuTunValue = HSPHZ:Find('table/qiHu/qiHuScore/Value')
	message:AddClick(hsphzObj.AddBtnQiHuTun.gameObject, this.OnClickChangeQiHuTunValue)
	message:AddClick(hsphzObj.SubtractBtnQiHuTun.gameObject, this.OnClickChangeQiHuTunValue)

	hsphzObj.ToggleWuDui = HSPHZ:Find('table/play/wuDui')
	hsphzObj.ToggleHongDui = HSPHZ:Find('table/play/hongDui')
	hsphzObj.ToggleJiaHongDui = HSPHZ:Find('table/play/jiaHongDui')
	message:AddClick(hsphzObj.ToggleWuDui.gameObject, this.OnClickToggleWuDui)
	message:AddClick(hsphzObj.ToggleHongDui.gameObject, this.OnClickToggleHongDui)
	message:AddClick(hsphzObj.ToggleJiaHongDui.gameObject, this.OnClickToggleJiaHongDui)

	hsphzObj.ToggleWinBanker = HSPHZ:Find('table/selectBanker/winBanker')
	hsphzObj.ToggleLoopBanker = HSPHZ:Find('table/selectBanker/loopBanker')
	message:AddClick(hsphzObj.ToggleWinBanker.gameObject, this.OnClickSelectBanker)
	message:AddClick(hsphzObj.ToggleLoopBanker.gameObject, this.OnClickSelectBanker)

	hsphzObj.AddBtnFengDing = HSPHZ:Find('table/fengDing/fengDingScore/AddButton')
	hsphzObj.SubtractBtnFengDing = HSPHZ:Find('table/fengDing/fengDingScore/SubtractButton')
	hsphzObj.FengDingValue = HSPHZ:Find('table/fengDing/fengDingScore/Value')
	message:AddClick(hsphzObj.AddBtnFengDing.gameObject, this.OnClickChangeFengDingValue)
	message:AddClick(hsphzObj.SubtractBtnFengDing.gameObject, this.OnClickChangeFengDingValue)
	
	hsphzObj.AddBtnHuangZhuangKouFen = HSPHZ:Find('table/huangZhuangKouFen/kouScore/AddButton')
	hsphzObj.SubtractBtnHuangZhuangKouFen = HSPHZ:Find('table/huangZhuangKouFen/kouScore/SubtractButton')
	hsphzObj.HuangZhuangKouFenValue = HSPHZ:Find('table/huangZhuangKouFen/kouScore/Value')
	message:AddClick(hsphzObj.AddBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)
	message:AddClick(hsphzObj.SubtractBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)
	
	hsphzObj.ToggleChou0 = HSPHZ:Find('table/chouCard/chouCard0')
	hsphzObj.ToggleChou10 = HSPHZ:Find('table/chouCard/chouCard10')
	hsphzObj.ToggleChou20 = HSPHZ:Find('table/chouCard/chouCard20')
	message:AddClick(hsphzObj.ToggleChou0.gameObject, this.OnClickToggleChou)
	message:AddClick(hsphzObj.ToggleChou10.gameObject, this.OnClickToggleChou)
	message:AddClick(hsphzObj.ToggleChou20.gameObject, this.OnClickToggleChou)

	hsphzObj.ToggleOnNiao = HSPHZ:Find('table/niao/OnNiao')
	hsphzObj.ToggleOffNiao = HSPHZ:Find('table/niao/OffNiao')
	hsphzObj.NiaoValueText = HSPHZ:Find('table/niao/NiaoValue/Value')
	hsphzObj.AddButtonNiao = HSPHZ:Find('table/niao/NiaoValue/AddButton')
	hsphzObj.SubtractButtonNiao = HSPHZ:Find('table/niao/NiaoValue/SubtractButton')
	message:AddClick(hsphzObj.ToggleOnNiao.gameObject, this.OnClickNiao)
	message:AddClick(hsphzObj.ToggleOffNiao.gameObject, this.OnClickNiao)
	message:AddClick(hsphzObj.AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(hsphzObj.SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)

	hsphzObj.ToggleSettlementScoreSelect=HSPHZ:Find('table/settlementScore/select')
	hsphzObj.ToggleFewerScoreTxt=HSPHZ:Find('table/settlementScore/fewerValue/Value')
	hsphzObj.ToggleFewerAddButton=HSPHZ:Find('table/settlementScore/fewerValue/AddButton')
	hsphzObj.ToggleFewerSubtractButton=HSPHZ:Find('table/settlementScore/fewerValue/SubtractButton')
	hsphzObj.ToggleAddScoreTxt=HSPHZ:Find('table/settlementScore/addValue/Value')
	hsphzObj.ToggleAddAddButton=HSPHZ:Find('table/settlementScore/addValue/AddButton')
	hsphzObj.ToggleAddSubtractButton=HSPHZ:Find('table/settlementScore/addValue/SubtractButton')
	message:AddClick(hsphzObj.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(hsphzObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(hsphzObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(hsphzObj.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(hsphzObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)

	hsphzObj.ToggleChoiceDouble = HSPHZ:Find('table/choiceDouble/On')
	hsphzObj.ToggleNoChoiceDouble = HSPHZ:Find('table/choiceDouble/Off')
	hsphzObj.DoubleScoreText = HSPHZ:Find('table/choiceDouble/doubleScore/Value')
	hsphzObj.AddDoubleScoreButton = HSPHZ:Find('table/choiceDouble/doubleScore/AddButton')
	hsphzObj.SubtractDoubleScoreButton = HSPHZ:Find('table/choiceDouble/doubleScore/SubtractButton')
	hsphzObj.ToggleMultiple2 = HSPHZ:Find('table/multiple/2')
	hsphzObj.ToggleMultiple3 = HSPHZ:Find('table/multiple/3')
	hsphzObj.ToggleMultiple4 = HSPHZ:Find('table/multiple/4')
	message:AddClick(hsphzObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(hsphzObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(hsphzObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(hsphzObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(hsphzObj.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(hsphzObj.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(hsphzObj.ToggleMultiple4.gameObject, this.OnClickMultiple)

	hsphzObj.ToggleTrusteeshipNo = HSPHZ:Find('table/DelegateChoose/NoDelegate')
	hsphzObj.ToggleTrusteeship1 = HSPHZ:Find('table/DelegateChoose/Delegate1')
	hsphzObj.ToggleTrusteeship2 = HSPHZ:Find('table/DelegateChoose/Delegate2')
	hsphzObj.ToggleTrusteeship3 = HSPHZ:Find('table/DelegateChoose/Delegate3')
	hsphzObj.ToggleTrusteeship5 = HSPHZ:Find('table/DelegateChoose1/Delegate5')
	hsphzObj.ToggleTrusteeshipAll = HSPHZ:Find('table/DelegateCancel/FullRound')
	hsphzObj.ToggleTrusteeshipOne = HSPHZ:Find('table/DelegateCancel/ThisRound')
	hsphzObj.ToggleTrusteeshipThree = HSPHZ:Find('table/DelegateCancel/ThreeRound')
	message:AddClick(hsphzObj.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(hsphzObj.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(hsphzObj.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(hsphzObj.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(hsphzObj.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(hsphzObj.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(hsphzObj.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(hsphzObj.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)

	hsphzObj.ToggleIPcheck = HSPHZ:Find('table/PreventCheat/IPcheck')
	hsphzObj.ToggleGPScheck = HSPHZ:Find('table/PreventCheat/GPScheck')
	message:AddClick(hsphzObj.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(hsphzObj.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end
function this.Refresh()
	print('Refresh_HSPHZ')
	hsphzData.rounds=UnityEngine.PlayerPrefs.GetInt('NewHSPHZrounds', 8)
	hsphzObj.ToggleRound6:GetComponent('UIToggle'):Set(hsphzData.rounds == 6)
	hsphzObj.ToggleRound8:GetComponent('UIToggle'):Set(hsphzData.rounds == 8)
	hsphzObj.ToggleRound10:GetComponent('UIToggle'):Set(hsphzData.rounds == 10)
	hsphzObj.ToggleRound16:GetComponent('UIToggle'):Set(hsphzData.rounds == 16)

	hsphzData.size=UnityEngine.PlayerPrefs.GetInt('NewHSPHZsize', 2)
	hsphzObj.TogglePeopleNum2:GetComponent('UIToggle'):Set(hsphzData.size == 2)
    hsphzObj.TogglePeopleNum3:GetComponent('UIToggle'):Set(hsphzData.size == 3)
	
	hsphzData.paymentType=UnityEngine.PlayerPrefs.GetInt('NewHSPHZpaymentType', 0)
	hsphzObj.ToggleMasterPay:GetComponent('UIToggle'):Set(hsphzData.paymentType == 0)
	hsphzObj.ToggleWinnerPay:GetComponent('UIToggle'):Set(hsphzData.paymentType == 2)

	hsphzData.randomBanker=UnityEngine.PlayerPrefs.GetInt('NewHSPHZrandomBanker', 0)==1
	hsphzObj.ToggleRandomBanker:GetComponent('UIToggle'):Set(hsphzData.randomBanker)
	hsphzObj.ToggleBankerFrist:GetComponent('UIToggle'):Set(not hsphzData.randomBanker)

	hsphzData.qiHuTun=UnityEngine.PlayerPrefs.GetInt('NewHSPHZqiHuTun', 1)
	hsphzObj.QiHuTunValue:GetComponent("UILabel").text = '倒'..hsphzData.qiHuTun
	
	hsphzData.maxHuXi=UnityEngine.PlayerPrefs.GetInt('NewHSPHZmaxHuXi', 0)
	hsphzObj.FengDingValue:GetComponent("UILabel").text = hsphzData.maxHuXi == 0 and '不封顶' or hsphzData.maxHuXi..'分'

	hsphzData.huangZhuangFen=UnityEngine.PlayerPrefs.GetInt('NewHSPHZhuangZhuangFen', 0) 
	hsphzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = hsphzData.huangZhuangFen == 0 and '不扣分' or '扣'..hsphzData.huangZhuangFen..'分'

	hsphzData.wuDuiHu = UnityEngine.PlayerPrefs.GetInt('NewHSPHZwuDuiHu', 0)==1
	hsphzObj.ToggleWuDui:GetComponent('UIToggle'):Set(hsphzData.wuDuiHu)

	hsphzData.hongDuiHu = UnityEngine.PlayerPrefs.GetInt('NewHSPHZhongDuiHu', 0)==1
	hsphzObj.ToggleHongDui:GetComponent('UIToggle'):Set(hsphzData.hongDuiHu)
	
	hsphzData.jiaHongDui = UnityEngine.PlayerPrefs.GetInt('NewHSPHZjiaHongDui', 0)==1
	hsphzObj.ToggleJiaHongDui:GetComponent('UIToggle'):Set(hsphzData.jiaHongDui)

	hsphzData.choiceBanker = UnityEngine.PlayerPrefs.GetInt('NewHSPHZchoiceBanker', 0)
	hsphzObj.ToggleWinBanker:GetComponent('UIToggle'):Set(hsphzData.choiceBanker == 0)
	hsphzObj.ToggleLoopBanker:GetComponent('UIToggle'):Set(hsphzData.choiceBanker == 1)

	hsphzData.chou = UnityEngine.PlayerPrefs.GetInt('NewHSPHZchou', 20)
	hsphzObj.ToggleChou0:GetComponent('UIToggle'):Set(hsphzData.chou == 0)
	hsphzObj.ToggleChou10:GetComponent('UIToggle'):Set(hsphzData.chou == 10)
	hsphzObj.ToggleChou20:GetComponent('UIToggle'):Set(hsphzData.chou == 20)
	hsphzObj.ToggleChou0.parent.gameObject:SetActive(hsphzData.size == 2)

	hsphzData.niao=UnityEngine.PlayerPrefs.GetInt('NewHSPHZniao', 0)==1
	hsphzData.niaoValue=UnityEngine.PlayerPrefs.GetInt('NewHSPHZniaoValue', 10)
	hsphzObj.ToggleOnNiao:GetComponent('UIToggle'):Set(hsphzData.niao)
	hsphzObj.ToggleOffNiao:GetComponent('UIToggle'):Set(not hsphzData.niao)
	hsphzObj.NiaoValueText.parent.gameObject:SetActive(hsphzData.niao)
    hsphzObj.NiaoValueText:GetComponent('UILabel').text = hsphzData.niaoValue.."分"

	hsphzData.choiceDouble=UnityEngine.PlayerPrefs.GetInt('NewHSPHZchoiceDouble', 0)==1
	hsphzData.doubleScore=UnityEngine.PlayerPrefs.GetInt('NewHSPHZdoubleScore', 10)
	hsphzData.multiple=UnityEngine.PlayerPrefs.GetInt('NewHSPHZmultiple', 2)
	hsphzObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(hsphzData.choiceDouble)
	hsphzObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not hsphzData.choiceDouble)
	hsphzObj.DoubleScoreText.parent.gameObject:SetActive(hsphzData.choiceDouble)
	if hsphzData.doubleScore == 0 then
		hsphzObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		hsphzObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..hsphzData.doubleScore..'分'
	end
	hsphzObj.ToggleChoiceDouble.parent.gameObject:SetActive(hsphzData.size == 2)
	hsphzObj.ToggleMultiple2:GetComponent('UIToggle'):Set(hsphzData.multiple == 2)
	hsphzObj.ToggleMultiple3:GetComponent('UIToggle'):Set(hsphzData.multiple == 3)
	hsphzObj.ToggleMultiple4:GetComponent('UIToggle'):Set(hsphzData.multiple == 4)
	hsphzObj.ToggleMultiple2.parent.gameObject:SetActive(hsphzData.choiceDouble and  hsphzData.size == 2)

	hsphzData.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewHSPHZisSettlementScore', 0)==1
	hsphzData.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewHSPHZfewerValue', 10)
	hsphzData.addValue=UnityEngine.PlayerPrefs.GetInt('NewHSPHZaddValue', 10)
	hsphzObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(hsphzData.size==2)
	hsphzObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(hsphzData.isSettlementScore)
	hsphzObj.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	hsphzObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = hsphzData.fewerValue
	hsphzObj.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	hsphzObj.ToggleAddScoreTxt:GetComponent('UILabel').text = hsphzData.addValue

	hsphzData.trusteeshipTime=UnityEngine.PlayerPrefs.GetInt('NewHSPHZtrusteeshipTime', 0)
	hsphzData.trusteeshipType = UnityEngine.PlayerPrefs.GetInt('NewHSPHZtrusteeshipType', 0) == 1
	hsphzData.trusteeshipRound = UnityEngine.PlayerPrefs.GetInt('NewHSPHZtrusteeshipRound', 0)
	hsphzObj.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(hsphzData.trusteeshipTime == 0)
	hsphzObj.ToggleTrusteeship1:GetComponent('UIToggle'):Set(hsphzData.trusteeshipTime == 1)
	hsphzObj.ToggleTrusteeship2:GetComponent('UIToggle'):Set(hsphzData.trusteeshipTime == 2)
	hsphzObj.ToggleTrusteeship3:GetComponent('UIToggle'):Set(hsphzData.trusteeshipTime == 3)
	hsphzObj.ToggleTrusteeship5:GetComponent('UIToggle'):Set(hsphzData.trusteeshipTime == 5)
	hsphzObj.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(hsphzData.trusteeshipType)
	hsphzObj.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not hsphzData.trusteeshipType and hsphzData.trusteeshipRound == 0)
	hsphzObj.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(hsphzData.trusteeshipRound == 3)
	hsphzObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(hsphzData.trusteeshipTime ~= 0)

	hsphzData.openIp=UnityEngine.PlayerPrefs.GetInt('HSPHZcheckIP', 0)==1
	hsphzData.openGps=UnityEngine.PlayerPrefs.GetInt('HSPHZcheckGPS', 0)==1
	hsphzObj.ToggleIPcheck.parent.gameObject:SetActive(hsphzData.size > 2 and CONST.IPcheckOn)
	hsphzObj.ToggleIPcheck:GetComponent('UIToggle'):Set(hsphzData.openIp)
	hsphzObj.ToggleGPScheck:GetComponent('UIToggle'):Set(hsphzData.openGps)

	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.HSPHZ,hsphzData.rounds,nil,nil)
	HSPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end
--获取当前设置
function this.GetConfig()
	local moneyLess = false
	if ((hsphzData.rounds == 6 or hsphzData.rounds == 8 or hsphzData.rounds == 10) and info_login.balance < 2) or
        (hsphzData.rounds == 16 and info_login.balance < 3) then
        moneyLess = true
    end
    local body = {}
    body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.HSPHZ)
	body.rounds = hsphzData.rounds
    body.size = hsphzData.size
    body.paymentType = hsphzData.paymentType
    body.randomBanker = hsphzData.randomBanker
    body.trusteeship = hsphzData.trusteeshipTime*60;
    body.trusteeshipDissolve = hsphzData.trusteeshipType;
    body.trusteeshipRound = hsphzData.trusteeshipRound;

	body.niao = hsphzData.niao
	body.niaoValue =  hsphzData.niao and hsphzData.niaoValue or 0
	
	if hsphzData.size == 2 then
		body.resultScore = hsphzData.isSettlementScore
		if hsphzData.isSettlementScore then
			body.resultLowerScore=hsphzData.fewerValue
			body.resultAddScore=hsphzData.addValue
		end
		body.choiceDouble = hsphzData.choiceDouble
        body.doubleScore = hsphzData.doubleScore
        body.multiple = hsphzData.multiple
		hsphzData.openIp=false
		hsphzData.openGps=false
	end

	body.qiHuTun = hsphzData.qiHuTun
	body.hongDuiHu = hsphzData.hongDuiHu
	body.jiaHongDui = hsphzData.jiaHongDui
	body.wuDuiHu = hsphzData.wuDuiHu
	body.choiceBanker = hsphzData.choiceBanker
	body.maxHuXi = hsphzData.maxHuXi
	body.huangZhuangFen = hsphzData.huangZhuangFen

	body.chou = hsphzData.size == 2 and hsphzData.chou or 0
	body.fanXing = false
	body.qiHuHuXi = 15
	body.openIp	 = hsphzData.openIp
	body.openGps = hsphzData.openGps
    return moneyLess,body;
end

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
    if hsphzObj.ToggleRound6.gameObject == go then
        hsphzData.rounds = 6
	elseif hsphzObj.ToggleRound8.gameObject == go then
        hsphzData.rounds = 8
    elseif hsphzObj.ToggleRound10.gameObject == go then
        hsphzData.rounds = 10
    else
        hsphzData.rounds = 16
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.HSPHZ,hsphzData.rounds,nil,nil)
    UnityEngine.PlayerPrefs.SetInt('NewHSPHZrounds', hsphzData.rounds)
end

function this.OnClickTogglePlayerNum(go)
	AudioManager.Instance:PlayAudio('btn')
    if hsphzObj.TogglePeopleNum2.gameObject == go then
        hsphzData.size = 2
    elseif hsphzObj.TogglePeopleNum3.gameObject == go then
        hsphzData.size = 3
    end
	hsphzObj.ToggleIPcheck.parent.gameObject:SetActive(hsphzData.size > 2 and CONST.IPcheckOn)
	UnityEngine.PlayerPrefs.SetInt('NewHSPHZsize', hsphzData.size)
	hsphzObj.ToggleChou0.parent.gameObject:SetActive(hsphzData.size == 2)
	hsphzObj.ToggleNoChoiceDouble.parent.gameObject:SetActive(hsphzData.size==2)
	hsphzObj.ToggleMultiple2.parent.gameObject:SetActive(hsphzData.choiceDouble and  hsphzData.size == 2)
	hsphzObj.DoubleScoreText.parent.gameObject:SetActive(hsphzData.choiceDouble)
	hsphzObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(hsphzData.size==2)
    HSPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if hsphzObj.ToggleMasterPay.gameObject == go then
        hsphzData.paymentType=0
    elseif hsphzObj.ToggleWinnerPay.gameObject == go then
        hsphzData.paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewHSPHZpaymentType', hsphzData.paymentType)
end

function this.OnClickRandomBanker(go)
    AudioManager.Instance:PlayAudio('btn')
    if hsphzObj.ToggleRandomBanker.gameObject == go then
        hsphzData.randomBanker = true
    elseif hsphzObj.ToggleBankerFrist.gameObject == go then
        hsphzData.randomBanker = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewHSPHZrandomBanker', hsphzData.randomBanker and 1 or 0)
end

function this.OnClickNiao(go)
	AudioManager.Instance:PlayAudio('btn')
	if hsphzObj.ToggleOnNiao.gameObject == go then
		hsphzData.niao = true
	elseif hsphzObj.ToggleOffNiao.gameObject == go then
		hsphzData.niao = false
	end
	hsphzObj.NiaoValueText.parent.gameObject:SetActive(hsphzData.niao)
	UnityEngine.PlayerPrefs.SetInt('NewHSPHZniao', hsphzData.niao and 1 or 0)
	
end

function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if hsphzObj.AddButtonNiao.gameObject == go then
		hsphzData.niaoValue = hsphzData.niaoValue + 10
		if hsphzData.niaoValue > 100 then
			hsphzData.niaoValue = 100
		end
	elseif hsphzObj.SubtractButtonNiao.gameObject == go then
		hsphzData.niaoValue = hsphzData.niaoValue - 10
		if hsphzData.niaoValue < 10 then
			hsphzData.niaoValue = 10
		end
	end
	hsphzObj.NiaoValueText:GetComponent('UILabel').text = hsphzData.niaoValue.."分"
	UnityEngine.PlayerPrefs.SetInt('NewHSPHZniaoValue', hsphzData.niaoValue)
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if hsphzObj.ToggleTrusteeshipNo.gameObject == go then
        hsphzData.trusteeshipTime = 0
    elseif hsphzObj.ToggleTrusteeship1.gameObject == go then
        hsphzData.trusteeshipTime = 1
	elseif hsphzObj.ToggleTrusteeship2.gameObject == go then
		hsphzData.trusteeshipTime = 2
    elseif hsphzObj.ToggleTrusteeship3.gameObject == go then
        hsphzData.trusteeshipTime = 3
    elseif hsphzObj.ToggleTrusteeship5.gameObject == go then
        hsphzData.trusteeshipTime = 5
	end
    UnityEngine.PlayerPrefs.SetInt('NewHSPHZtrusteeshipTime', hsphzData.trusteeshipTime)
	hsphzObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(hsphzData.trusteeshipTime ~= 0)
	HSPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if hsphzObj.ToggleTrusteeshipOne.gameObject == go then
        hsphzData.trusteeshipType = true
		hsphzData.trusteeshipRound = 0;
    elseif hsphzObj.ToggleTrusteeshipAll.gameObject == go then
        hsphzData.trusteeshipType = false
		hsphzData.trusteeshipRound = 0;
	elseif hsphzObj.ToggleTrusteeshipThree.gameObject == go then
		hsphzData.trusteeshipType = false;
		hsphzData.trusteeshipRound = 3;
    end
    UnityEngine.PlayerPrefs.SetInt('NewHSPHZtrusteeshipType',hsphzData.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewHSPHZtrusteeshipRound',hsphzData.trusteeshipRound )
end
function this.OnClickChangeQiHuTunValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if hsphzObj.AddBtnQiHuTun.gameObject == go then
		hsphzData.qiHuTun = hsphzData.qiHuTun + 1
		if hsphzData.qiHuTun > 10 then
			hsphzData.qiHuTun = 10
		end
    else
		hsphzData.qiHuTun = hsphzData.qiHuTun - 1
		if hsphzData.qiHuTun < 1 then
			hsphzData.qiHuTun = 1
		end
    end
	hsphzObj.QiHuTunValue:GetComponent("UILabel").text = '倒'..hsphzData.qiHuTun
    UnityEngine.PlayerPrefs.SetInt('NewHSPHZqiHuTun', hsphzData.qiHuTun)
end

function this.OnClickChangeFengDingValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if hsphzObj.AddBtnFengDing.gameObject == go then
        if hsphzData.maxHuXi ~= 0 then
            hsphzData.maxHuXi = hsphzData.maxHuXi + 10
            if hsphzData.maxHuXi > 80 then
                hsphzData.maxHuXi = 0
            end
        end
    else
        if hsphzData.maxHuXi == 0 then
            hsphzData.maxHuXi = 80
        else
            hsphzData.maxHuXi = hsphzData.maxHuXi - 10
            if hsphzData.maxHuXi < 10 then
                hsphzData.maxHuXi = 10
            end
        end
    end
	hsphzObj.FengDingValue:GetComponent("UILabel").text = hsphzData.maxHuXi == 0 and '不封顶' or hsphzData.maxHuXi..'分'
	UnityEngine.PlayerPrefs.SetInt('NewHSPHZmaxHuXi', hsphzData.maxHuXi)
end

function this.OnClickChangeHuangZhuangKouFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if hsphzObj.AddBtnHuangZhuangKouFen.gameObject == go then
		hsphzData.huangZhuangFen = hsphzData.huangZhuangFen + 1
		if hsphzData.huangZhuangFen > 10 then
			hsphzData.huangZhuangFen = 10
		end
    else
		hsphzData.huangZhuangFen = hsphzData.huangZhuangFen - 1
		if hsphzData.huangZhuangFen < 0 then
			hsphzData.huangZhuangFen = 0
		end
    end
	hsphzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = hsphzData.huangZhuangFen == 0 and '不扣分' or '扣'..hsphzData.huangZhuangFen..'分'
	UnityEngine.PlayerPrefs.SetInt('NewHSPHZhuangZhuangFen', hsphzData.huangZhuangFen)
end

function this.OnClickToggleWuDui(go)
	AudioManager.Instance:PlayAudio('btn')
	hsphzData.wuDuiHu = hsphzObj.ToggleWuDui:GetComponent('UIToggle').value
	UnityEngine.PlayerPrefs.SetInt('NewHSPHZwuDuiHu', hsphzData.wuDuiHu and 1 or 0)
end

function this.OnClickToggleHongDui(go)
	AudioManager.Instance:PlayAudio('btn')
	hsphzData.hongDuiHu = hsphzObj.ToggleHongDui:GetComponent('UIToggle').value
	UnityEngine.PlayerPrefs.SetInt('NewHSPHZhongDuiHu', hsphzData.hongDuiHu and 1 or 0)
end
function this.OnClickToggleJiaHongDui(go)
	AudioManager.Instance:PlayAudio('btn')
	hsphzData.jiaHongDui = hsphzObj.ToggleJiaHongDui:GetComponent('UIToggle').value
	UnityEngine.PlayerPrefs.SetInt('NewHSPHZjiaHongDui', hsphzData.jiaHongDui and 1 or 0)
end

function this.OnClickSelectBanker(go)
	AudioManager.Instance:PlayAudio('btn')
	if hsphzObj.ToggleWinBanker.gameObject == go then
        hsphzData.choiceBanker=0
    elseif hsphzObj.ToggleLoopBanker.gameObject == go then
        hsphzData.choiceBanker=1
	end
	UnityEngine.PlayerPrefs.SetInt('NewHSPHZchoiceBanker', hsphzData.choiceBanker)
end
function this.OnClickToggleChou(go)
	AudioManager.Instance:PlayAudio('btn')
	if hsphzObj.ToggleChou0.gameObject == go then
        hsphzData.chou=0
    elseif hsphzObj.ToggleChou10.gameObject == go then
        hsphzData.chou=10
    elseif hsphzObj.ToggleChou20.gameObject == go then
        hsphzData.chou=20
	end
	UnityEngine.PlayerPrefs.SetInt('NewHSPHZchou', hsphzData.chou)
end

function this.OnClickChoiceDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if hsphzObj.ToggleChoiceDouble.gameObject == go then
        hsphzData.choiceDouble = true
    elseif hsphzObj.ToggleNoChoiceDouble.gameObject == go then
        hsphzData.choiceDouble = false
    end
    hsphzObj.DoubleScoreText.parent.gameObject:SetActive(hsphzData.choiceDouble)
    hsphzObj.ToggleMultiple2.parent.gameObject:SetActive(hsphzData.choiceDouble)
    HSPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
    UnityEngine.PlayerPrefs.SetInt('NewHSPHZchoiceDouble', hsphzData.choiceDouble and 1 or 0)
end

function this.OnClickChangeDoubleScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if hsphzObj.AddDoubleScoreButton.gameObject == go then
        if hsphzData.doubleScore ~= 0 then
            hsphzData.doubleScore = hsphzData.doubleScore + 1
            if hsphzData.doubleScore > 100 then
                hsphzData.doubleScore = 0
            end
        end
    else
        if hsphzData.doubleScore == 0 then
            hsphzData.doubleScore = 100
        else
            hsphzData.doubleScore = hsphzData.doubleScore - 1
            if hsphzData.doubleScore < 1 then
                hsphzData.doubleScore = 1
            end
        end
    end
    if hsphzData.doubleScore == 0 then
        hsphzObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
    else
        hsphzObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..hsphzData.doubleScore..'分'
    end
    UnityEngine.PlayerPrefs.SetInt('NewHSPHZdoubleScore', hsphzData.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
    if hsphzObj.ToggleMultiple2.gameObject == go then
        hsphzData.multiple=2
    elseif hsphzObj.ToggleMultiple3.gameObject == go then
        hsphzData.multiple=3
    elseif hsphzObj.ToggleMultiple4.gameObject == go then
        hsphzData.multiple=4
    end
    UnityEngine.PlayerPrefs.SetInt('NewHSPHZmultiple', hsphzData.multiple)
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    hsphzData.isSettlementScore= hsphzObj.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewHSPHZisSettlementScore', hsphzData.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if hsphzObj.ToggleFewerAddButton.gameObject == go then
		hsphzData.fewerValue = hsphzData.fewerValue + 1
		if hsphzData.fewerValue > 100 then
			hsphzData.fewerValue = 100
		end
    elseif hsphzObj.ToggleFewerSubtractButton.gameObject == go then
		hsphzData.fewerValue = hsphzData.fewerValue - 1
		if hsphzData.fewerValue < 1 then
			hsphzData.fewerValue = 1
		end
	end
	hsphzObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = hsphzData.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewHSPHZfewerValue', hsphzData.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if hsphzObj.ToggleAddAddButton.gameObject == go then
		hsphzData.addValue = hsphzData.addValue + 1
		if hsphzData.addValue > 100 then
			hsphzData.addValue = 100
		end
    elseif hsphzData.ToggleAddSubtractButton.gameObject == go then
		hsphzData.addValue = hsphzData.addValue - 1
		if hsphzData.addValue < 1 then
			hsphzData.addValue = 1
		end
	end
	hsphzObj.ToggleAddScoreTxt:GetComponent('UILabel').text = hsphzData.addValue
	UnityEngine.PlayerPrefs.SetInt('NewHSPHZaddValue', hsphzData.addValue)
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if hsphzObj.ToggleIPcheck.gameObject == go then
		hsphzData.openIp = hsphzObj.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('HSPHZcheckIP', hsphzData.openIp and 1 or 0)
	elseif hsphzObj.ToggleGPScheck.gameObject == go then
		hsphzData.openGps = hsphzObj.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('HSPHZcheckGPS', hsphzData.openGps and 1 or 0)
	end
end

return this