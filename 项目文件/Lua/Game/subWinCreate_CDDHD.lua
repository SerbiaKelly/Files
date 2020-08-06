local this = {}

local CDDHD
local payLabel

local cddhdObj = {}
local cddhdData = {}

function this.Init(grid,message)
	print('Init_CDDHD')
	CDDHD = grid
	payLabel = message.transform:Find('diamond/pay_label')

	cddhdObj.ToggleRound6 = CDDHD:Find('table/round/round6')
	cddhdObj.ToggleRound8 = CDDHD:Find('table/round/round8')
	cddhdObj.ToggleRound10 = CDDHD:Find('table/round/round10')
	cddhdObj.ToggleRound16 = CDDHD:Find('table/round/round16')
	message:AddClick(cddhdObj.ToggleRound6.gameObject, this.OnClickToggleRound)
	message:AddClick(cddhdObj.ToggleRound8.gameObject, this.OnClickToggleRound)
	message:AddClick(cddhdObj.ToggleRound10.gameObject, this.OnClickToggleRound)
	message:AddClick(cddhdObj.ToggleRound16.gameObject, this.OnClickToggleRound)

	cddhdObj.TogglePeopleNum2 = CDDHD:Find('table/num/num2')
	cddhdObj.TogglePeopleNum3 = CDDHD:Find('table/num/num3')
	message:AddClick(cddhdObj.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(cddhdObj.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)

	cddhdObj.ToggleMasterPay = CDDHD:Find('table/pay/master')
	cddhdObj.ToggleWinnerPay = CDDHD:Find('table/pay/win')
	message:AddClick(cddhdObj.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(cddhdObj.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)

	cddhdObj.ToggleRandomBanker = CDDHD:Find('table/randomBanker/Auto')
	cddhdObj.ToggleBankerFrist = CDDHD:Find('table/randomBanker/Frist')
	message:AddClick(cddhdObj.ToggleRandomBanker.gameObject, this.OnClickRandomBanker)
	message:AddClick(cddhdObj.ToggleBankerFrist.gameObject, this.OnClickRandomBanker)

	cddhdObj.AddBtnQiHuTun = CDDHD:Find('table/qiHu/qiHuScore/AddButton')
	cddhdObj.SubtractBtnQiHuTun = CDDHD:Find('table/qiHu/qiHuScore/SubtractButton')
	cddhdObj.QiHuTunValue = CDDHD:Find('table/qiHu/qiHuScore/Value')
	message:AddClick(cddhdObj.AddBtnQiHuTun.gameObject, this.OnClickChangeQiHuTunValue)
	message:AddClick(cddhdObj.SubtractBtnQiHuTun.gameObject, this.OnClickChangeQiHuTunValue)

	cddhdObj.ToggleTianHu = CDDHD:Find('table/play1/tianHu')
	message:AddClick(cddhdObj.ToggleTianHu.gameObject, this.OnClickTogglePlayCDDHD)
	cddhdObj.ToggleDiHu = CDDHD:Find('table/play1/diHu')
	message:AddClick(cddhdObj.ToggleDiHu.gameObject, this.OnClickTogglePlayCDDHD)
	cddhdObj.ToggleTingHu = CDDHD:Find('table/play1/tingHu')
	message:AddClick(cddhdObj.ToggleTingHu.gameObject, this.OnClickTogglePlayCDDHD)
	cddhdObj.ToggleHaiDiHu = CDDHD:Find('table/play2/haiDiHu')
	message:AddClick(cddhdObj.ToggleHaiDiHu.gameObject, this.OnClickTogglePlayCDDHD)
	cddhdObj.ToggleHuangFan = CDDHD:Find('table/play2/huangFan')
	message:AddClick(cddhdObj.ToggleHuangFan.gameObject, this.OnClickTogglePlayCDDHD)
	

	cddhdObj.AddBtnFengDing = CDDHD:Find('table/fengDing/fengDingScore/AddButton')
	cddhdObj.SubtractBtnFengDing = CDDHD:Find('table/fengDing/fengDingScore/SubtractButton')
	cddhdObj.FengDingValue = CDDHD:Find('table/fengDing/fengDingScore/Value')
	message:AddClick(cddhdObj.AddBtnFengDing.gameObject, this.OnClickChangeFengDingValue)
	message:AddClick(cddhdObj.SubtractBtnFengDing.gameObject, this.OnClickChangeFengDingValue)
	
	cddhdObj.AddBtnHuangZhuangKouFen = CDDHD:Find('table/huangZhuangKouFen/kouScore/AddButton')
	cddhdObj.SubtractBtnHuangZhuangKouFen = CDDHD:Find('table/huangZhuangKouFen/kouScore/SubtractButton')
	cddhdObj.HuangZhuangKouFenValue = CDDHD:Find('table/huangZhuangKouFen/kouScore/Value')
	message:AddClick(cddhdObj.AddBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)
	message:AddClick(cddhdObj.SubtractBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)
	
	cddhdObj.ToggleChou0 = CDDHD:Find('table/chouCard/chouCard0')
	cddhdObj.ToggleChou10 = CDDHD:Find('table/chouCard/chouCard10')
	cddhdObj.ToggleChou20 = CDDHD:Find('table/chouCard/chouCard20')
	message:AddClick(cddhdObj.ToggleChou0.gameObject, this.OnClickToggleChou)
	message:AddClick(cddhdObj.ToggleChou10.gameObject, this.OnClickToggleChou)
	message:AddClick(cddhdObj.ToggleChou20.gameObject, this.OnClickToggleChou)

	cddhdObj.ToggleOnNiao = CDDHD:Find('table/niao/OnNiao')
	cddhdObj.ToggleOffNiao = CDDHD:Find('table/niao/OffNiao')
	cddhdObj.NiaoValueText = CDDHD:Find('table/niao/NiaoValue/Value')
	cddhdObj.AddButtonNiao = CDDHD:Find('table/niao/NiaoValue/AddButton')
	cddhdObj.SubtractButtonNiao = CDDHD:Find('table/niao/NiaoValue/SubtractButton')
	message:AddClick(cddhdObj.ToggleOnNiao.gameObject, this.OnClickNiao)
	message:AddClick(cddhdObj.ToggleOffNiao.gameObject, this.OnClickNiao)
	message:AddClick(cddhdObj.AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(cddhdObj.SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)

	cddhdObj.ToggleChoiceDouble = CDDHD:Find('table/choiceDouble/On')
	cddhdObj.ToggleNoChoiceDouble = CDDHD:Find('table/choiceDouble/Off')
	cddhdObj.DoubleScoreText = CDDHD:Find('table/choiceDouble/doubleScore/Value')
	cddhdObj.AddDoubleScoreButton = CDDHD:Find('table/choiceDouble/doubleScore/AddButton')
	cddhdObj.SubtractDoubleScoreButton = CDDHD:Find('table/choiceDouble/doubleScore/SubtractButton')
	cddhdObj.ToggleMultiple2 = CDDHD:Find('table/multiple/2')
	cddhdObj.ToggleMultiple3 = CDDHD:Find('table/multiple/3')
	cddhdObj.ToggleMultiple4 = CDDHD:Find('table/multiple/4')
	message:AddClick(cddhdObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(cddhdObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(cddhdObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(cddhdObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(cddhdObj.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(cddhdObj.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(cddhdObj.ToggleMultiple4.gameObject, this.OnClickMultiple)

	cddhdObj.ToggleTrusteeshipNo = CDDHD:Find('table/DelegateChoose/NoDelegate')
	cddhdObj.ToggleTrusteeship1 = CDDHD:Find('table/DelegateChoose/Delegate1')
	cddhdObj.ToggleTrusteeship2 = CDDHD:Find('table/DelegateChoose/Delegate2')
	cddhdObj.ToggleTrusteeship3 = CDDHD:Find('table/DelegateChoose/Delegate3')
	cddhdObj.ToggleTrusteeship5 = CDDHD:Find('table/DelegateChoose1/Delegate5')
	cddhdObj.ToggleTrusteeshipAll = CDDHD:Find('table/DelegateCancel/FullRound')
	cddhdObj.ToggleTrusteeshipOne = CDDHD:Find('table/DelegateCancel/ThisRound')
	cddhdObj.ToggleTrusteeshipThree = CDDHD:Find('table/DelegateCancel/ThreeRound')
	message:AddClick(cddhdObj.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(cddhdObj.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(cddhdObj.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(cddhdObj.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(cddhdObj.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(cddhdObj.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(cddhdObj.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(cddhdObj.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)

	cddhdObj.ToggleSettlementScoreSelect=CDDHD:Find('table/settlementScore/select')
	cddhdObj.ToggleFewerScoreTxt=CDDHD:Find('table/settlementScore/fewerValue/Value')
	cddhdObj.ToggleFewerAddButton=CDDHD:Find('table/settlementScore/fewerValue/AddButton')
	cddhdObj.ToggleFewerSubtractButton=CDDHD:Find('table/settlementScore/fewerValue/SubtractButton')
	cddhdObj.ToggleAddScoreTxt=CDDHD:Find('table/settlementScore/addValue/Value')
	cddhdObj.ToggleAddAddButton=CDDHD:Find('table/settlementScore/addValue/AddButton')
	cddhdObj.ToggleAddSubtractButton=CDDHD:Find('table/settlementScore/addValue/SubtractButton')
	message:AddClick(cddhdObj.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(cddhdObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(cddhdObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(cddhdObj.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(cddhdObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)
	
	cddhdObj.ToggleIPcheck = CDDHD:Find('table/PreventCheat/IPcheck')
	cddhdObj.ToggleGPScheck = CDDHD:Find('table/PreventCheat/GPScheck')
	message:AddClick(cddhdObj.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(cddhdObj.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end
function this.Refresh()
	print('Refresh_CDDHD')
	cddhdData.rounds=UnityEngine.PlayerPrefs.GetInt('NewCDDHDrounds', 8)
	cddhdObj.ToggleRound6:GetComponent('UIToggle'):Set(cddhdData.rounds == 6)
	cddhdObj.ToggleRound8:GetComponent('UIToggle'):Set(cddhdData.rounds == 8)
	cddhdObj.ToggleRound10:GetComponent('UIToggle'):Set(cddhdData.rounds == 10)
	cddhdObj.ToggleRound16:GetComponent('UIToggle'):Set(cddhdData.rounds == 16)

	cddhdData.size=UnityEngine.PlayerPrefs.GetInt('NewCDDHDsize', 2)
	cddhdObj.TogglePeopleNum2:GetComponent('UIToggle'):Set(cddhdData.size == 2)
	cddhdObj.TogglePeopleNum3:GetComponent('UIToggle'):Set(cddhdData.size == 3)
	
	cddhdData.paymentType=UnityEngine.PlayerPrefs.GetInt('NewCDDHDpaymentType', 0)
	cddhdObj.ToggleMasterPay:GetComponent('UIToggle'):Set(cddhdData.paymentType == 0)
	cddhdObj.ToggleWinnerPay:GetComponent('UIToggle'):Set(cddhdData.paymentType == 2)

	cddhdData.randomBanker=UnityEngine.PlayerPrefs.GetInt('NewCDDHDrandomBanker', 0)==1
	cddhdObj.ToggleRandomBanker:GetComponent('UIToggle'):Set(cddhdData.randomBanker)
	cddhdObj.ToggleBankerFrist:GetComponent('UIToggle'):Set(not cddhdData.randomBanker)

	cddhdData.qiHuTun=UnityEngine.PlayerPrefs.GetInt('NewCDDHDqiHuTun', 1)
	cddhdObj.QiHuTunValue:GetComponent("UILabel").text = cddhdData.qiHuTun..'等'

	cddhdData.maxHuXi=UnityEngine.PlayerPrefs.GetInt('NewCDDHDmaxHuXi', 0)
	cddhdObj.FengDingValue:GetComponent("UILabel").text = cddhdData.maxHuXi == 0 and '不封顶' or cddhdData.maxHuXi..'分'

	cddhdData.huangZhuangFen=UnityEngine.PlayerPrefs.GetInt('NewCDDHDhuangZhuangFen', 0) 
	cddhdObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = cddhdData.huangZhuangFen == 0 and '不扣分' or '扣'..cddhdData.huangZhuangFen..'分'

	cddhdData.tianHu = UnityEngine.PlayerPrefs.GetInt('NewCDDHDtianHu', 0)==1
	cddhdObj.ToggleTianHu:GetComponent('UIToggle'):Set(cddhdData.tianHu)
	cddhdData.diHu = UnityEngine.PlayerPrefs.GetInt('NewCDDHDdiHu', 0)==1
	cddhdObj.ToggleDiHu:GetComponent('UIToggle'):Set(cddhdData.diHu)
	cddhdData.tingHu = UnityEngine.PlayerPrefs.GetInt('NewCDDHDtingHu', 0)==1
	cddhdObj.ToggleTingHu:GetComponent('UIToggle'):Set(cddhdData.tingHu)
	cddhdData.haiDiHu = UnityEngine.PlayerPrefs.GetInt('NewCDDHDhaiDiHu', 0)==1
	cddhdObj.ToggleHaiDiHu:GetComponent('UIToggle'):Set(cddhdData.haiDiHu)
	cddhdData.huangFan = UnityEngine.PlayerPrefs.GetInt('NewCDDHDhuangFan', 0)==1
	cddhdObj.ToggleHuangFan:GetComponent('UIToggle'):Set(cddhdData.huangFan)

	cddhdData.chou = UnityEngine.PlayerPrefs.GetInt('NewCDDHDchou', 20)
	cddhdObj.ToggleChou0:GetComponent('UIToggle'):Set(cddhdData.chou == 0)
	cddhdObj.ToggleChou10:GetComponent('UIToggle'):Set(cddhdData.chou == 10)
	cddhdObj.ToggleChou20:GetComponent('UIToggle'):Set(cddhdData.chou == 20)
	cddhdObj.ToggleChou0.parent.gameObject:SetActive(cddhdData.size == 2)

	cddhdData.niao=UnityEngine.PlayerPrefs.GetInt('NewCDDHDniao', 0)==1
	cddhdData.niaoValue=UnityEngine.PlayerPrefs.GetInt('NewCDDHDniaoValue', 10)
	cddhdObj.ToggleOnNiao:GetComponent('UIToggle'):Set(cddhdData.niao)
	cddhdObj.ToggleOffNiao:GetComponent('UIToggle'):Set(not cddhdData.niao)
	cddhdObj.NiaoValueText.parent.gameObject:SetActive(cddhdData.niao)
    cddhdObj.NiaoValueText:GetComponent('UILabel').text = cddhdData.niaoValue.."分"

	cddhdData.choiceDouble=UnityEngine.PlayerPrefs.GetInt('NewCDDHDchoiceDouble', 0)==1
	cddhdData.doubleScore=UnityEngine.PlayerPrefs.GetInt('NewCDDHDdoubleScore', 10)
	cddhdData.multiple=UnityEngine.PlayerPrefs.GetInt('NewCDDHDmultiple', 2)
	cddhdObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(cddhdData.choiceDouble)
	cddhdObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not cddhdData.choiceDouble)
	cddhdObj.DoubleScoreText.parent.gameObject:SetActive(cddhdData.choiceDouble)
	if cddhdData.doubleScore == 0 then
		cddhdObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		cddhdObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..cddhdData.doubleScore..'分'
	end
	cddhdObj.ToggleChoiceDouble.parent.gameObject:SetActive(cddhdData.size == 2)
	cddhdObj.ToggleMultiple2:GetComponent('UIToggle'):Set(cddhdData.multiple == 2)
	cddhdObj.ToggleMultiple3:GetComponent('UIToggle'):Set(cddhdData.multiple == 3)
	cddhdObj.ToggleMultiple4:GetComponent('UIToggle'):Set(cddhdData.multiple == 4)
	cddhdObj.ToggleMultiple2.parent.gameObject:SetActive(cddhdData.choiceDouble and  cddhdData.size == 2)

	cddhdData.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewCDDHDisSettlementScore', 0)==1
	cddhdData.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewCDDHDfewerValue', 10)
	cddhdData.addValue=UnityEngine.PlayerPrefs.GetInt('NewCDDHDaddValue', 10)
	cddhdObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(cddhdData.size==2)
	cddhdObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(cddhdData.isSettlementScore)
	cddhdObj.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	cddhdObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = cddhdData.fewerValue
	cddhdObj.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	cddhdObj.ToggleAddScoreTxt:GetComponent('UILabel').text = cddhdData.addValue

	cddhdData.trusteeshipTime=UnityEngine.PlayerPrefs.GetInt('NewCDDHDtrusteeshipTime', 0)
	cddhdData.trusteeshipType = UnityEngine.PlayerPrefs.GetInt('NewCDDHDtrusteeshipType', 0) == 1
	cddhdData.trusteeshipRound = UnityEngine.PlayerPrefs.GetInt('NewCDDHDtrusteeshipRound', 0)
	cddhdObj.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(cddhdData.trusteeshipTime == 0)
	cddhdObj.ToggleTrusteeship1:GetComponent('UIToggle'):Set(cddhdData.trusteeshipTime == 1)
	cddhdObj.ToggleTrusteeship2:GetComponent('UIToggle'):Set(cddhdData.trusteeshipTime == 2)
	cddhdObj.ToggleTrusteeship3:GetComponent('UIToggle'):Set(cddhdData.trusteeshipTime == 3)
	cddhdObj.ToggleTrusteeship5:GetComponent('UIToggle'):Set(cddhdData.trusteeshipTime == 5)
	cddhdObj.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(cddhdData.trusteeshipType)
	cddhdObj.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not cddhdData.trusteeshipType and cddhdData.trusteeshipRound == 0)
	cddhdObj.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(cddhdData.trusteeshipRound == 3);
	cddhdObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(cddhdData.trusteeshipTime ~= 0)

	cddhdData.openIp=UnityEngine.PlayerPrefs.GetInt('CDDHDcheckIP', 0)==1
	cddhdData.openGps=UnityEngine.PlayerPrefs.GetInt('CDDHDcheckGPS', 0)==1
	cddhdObj.ToggleIPcheck.parent.gameObject:SetActive(cddhdData.size > 2 and CONST.IPcheckOn)
	cddhdObj.ToggleIPcheck:GetComponent('UIToggle'):Set(cddhdData.openIp)
	cddhdObj.ToggleGPScheck:GetComponent('UIToggle'):Set(cddhdData.openGps)

	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.CDDHD,cddhdData.rounds,nil,nil)
	CDDHD:Find('table'):GetComponent('UIGrid'):Reposition()
end
--获取当前设置
function this.GetConfig()
	local moneyLess = false
	if ((cddhdData.rounds == 6 or cddhdData.rounds == 8 or cddhdData.rounds == 10) and info_login.balance < 2) or
        (cddhdData.rounds == 16 and info_login.balance < 3) then
        moneyLess = true
    end
    local body = {}
    body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.CDDHD)
	body.rounds = cddhdData.rounds
    body.size = cddhdData.size
    body.paymentType = cddhdData.paymentType
    body.randomBanker = cddhdData.randomBanker
    body.trusteeship = cddhdData.trusteeshipTime*60;
    body.trusteeshipDissolve = cddhdData.trusteeshipType;
    body.trusteeshipRound = cddhdData.trusteeshipRound;

	body.niao = cddhdData.niao
	body.niaoValue =  cddhdData.niao and cddhdData.niaoValue or 0
	
	if cddhdData.size == 2 then
		body.resultScore = cddhdData.isSettlementScore
		if cddhdData.isSettlementScore then
			body.resultLowerScore=cddhdData.fewerValue
			body.resultAddScore=cddhdData.addValue
		end
		body.choiceDouble = cddhdData.choiceDouble
        body.doubleScore = cddhdData.doubleScore
        body.multiple = cddhdData.multiple
		cddhdData.openIp=false
		cddhdData.openGps=false
	end

	body.qiHuTun = cddhdData.qiHuTun
	body.tianHu = cddhdData.tianHu
	body.diHu = cddhdData.diHu
	body.tingHu = cddhdData.tingHu
	body.haiDiHu = cddhdData.haiDiHu	
	body.huangFan = cddhdData.huangFan
	body.maxHuXi = cddhdData.maxHuXi
	body.huangZhuangFen = cddhdData.huangZhuangFen

	body.chou = cddhdData.size == 2 and cddhdData.chou or 0
	body.fanXing = false
	body.qiHuHuXi = 15
	body.openIp	 = cddhdData.openIp
	body.openGps = cddhdData.openGps
    return moneyLess,body;
end

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
    if cddhdObj.ToggleRound6.gameObject == go then
        cddhdData.rounds = 6
	elseif cddhdObj.ToggleRound8.gameObject == go then
        cddhdData.rounds = 8
    elseif cddhdObj.ToggleRound10.gameObject == go then
        cddhdData.rounds = 10
    else
        cddhdData.rounds = 16
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.CDDHD,cddhdData.rounds,nil,nil)
    UnityEngine.PlayerPrefs.SetInt('NewCDDHDrounds', cddhdData.rounds)
end

function this.OnClickTogglePlayerNum(go)
	AudioManager.Instance:PlayAudio('btn')
    if cddhdObj.TogglePeopleNum2.gameObject == go then
        cddhdData.size = 2
    elseif cddhdObj.TogglePeopleNum3.gameObject == go then
        cddhdData.size = 3
    end
	cddhdObj.ToggleIPcheck.parent.gameObject:SetActive(cddhdData.size > 2 and CONST.IPcheckOn)
	UnityEngine.PlayerPrefs.SetInt('NewCDDHDsize', cddhdData.size)
	cddhdObj.ToggleChou0.parent.gameObject:SetActive(cddhdData.size == 2)
	cddhdObj.ToggleNoChoiceDouble.parent.gameObject:SetActive(cddhdData.size==2)
	cddhdObj.ToggleMultiple2.parent.gameObject:SetActive(cddhdData.choiceDouble and cddhdData.size == 2)
	cddhdObj.DoubleScoreText.parent.gameObject:SetActive(cddhdData.choiceDouble)
	cddhdObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(cddhdData.size==2)
    CDDHD:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if cddhdObj.ToggleMasterPay.gameObject == go then
        cddhdData.paymentType=0
    elseif cddhdObj.ToggleWinnerPay.gameObject == go then
        cddhdData.paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewCDDHDpaymentType', cddhdData.paymentType)
end

function this.OnClickRandomBanker(go)
    AudioManager.Instance:PlayAudio('btn')
    if cddhdObj.ToggleRandomBanker.gameObject == go then
        cddhdData.randomBanker = true
    elseif cddhdObj.ToggleBankerFrist.gameObject == go then
        cddhdData.randomBanker = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewCDDHDrandomBanker', cddhdData.randomBanker and 1 or 0)
end

function this.OnClickNiao(go)
	AudioManager.Instance:PlayAudio('btn')
	if cddhdObj.ToggleOnNiao.gameObject == go then
		cddhdData.niao = true
	elseif cddhdObj.ToggleOffNiao.gameObject == go then
		cddhdData.niao = false
	end
	cddhdObj.NiaoValueText.parent.gameObject:SetActive(cddhdData.niao)
	UnityEngine.PlayerPrefs.SetInt('NewCDDHDniao', cddhdData.niao and 1 or 0)
	
end

function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if cddhdObj.AddButtonNiao.gameObject == go then
		cddhdData.niaoValue = cddhdData.niaoValue + 10
		if cddhdData.niaoValue > 100 then
			cddhdData.niaoValue = 100
		end
	elseif cddhdObj.SubtractButtonNiao.gameObject == go then
		cddhdData.niaoValue = cddhdData.niaoValue - 10
		if cddhdData.niaoValue < 10 then
			cddhdData.niaoValue = 10
		end
	end
	cddhdObj.NiaoValueText:GetComponent('UILabel').text = cddhdData.niaoValue.."分"
	UnityEngine.PlayerPrefs.SetInt('NewCDDHDniaoValue', cddhdData.niaoValue)
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if cddhdObj.ToggleTrusteeshipNo.gameObject == go then
        cddhdData.trusteeshipTime = 0
    elseif cddhdObj.ToggleTrusteeship1.gameObject == go then
        cddhdData.trusteeshipTime = 1
	elseif cddhdObj.ToggleTrusteeship2.gameObject == go then
		cddhdData.trusteeshipTime = 2
    elseif cddhdObj.ToggleTrusteeship3.gameObject == go then
        cddhdData.trusteeshipTime = 3
    elseif cddhdObj.ToggleTrusteeship5.gameObject == go then
        cddhdData.trusteeshipTime = 5
	end
    UnityEngine.PlayerPrefs.SetInt('NewCDDHDtrusteeshipTime', cddhdData.trusteeshipTime)
	cddhdObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(cddhdData.trusteeshipTime ~= 0)
	CDDHD:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if cddhdObj.ToggleTrusteeshipOne.gameObject == go then
        cddhdData.trusteeshipType = true
		cddhdData.trusteeshipRound = 0;
    elseif cddhdObj.ToggleTrusteeshipAll.gameObject == go then
        cddhdData.trusteeshipType = false
		cddhdData.trusteeshipRound = 0;
	elseif cddhdObj.ToggleTrusteeshipThree.gameObject == go then
		cddhdData.trusteeshipType = false;
		cddhdData.trusteeshipRound = 3;
    end
    UnityEngine.PlayerPrefs.SetInt('NewCDDHDtrusteeshipType',cddhdData.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewCDDHDtrusteeshipRound',cddhdData.trusteeshipRound )
end
function this.OnClickChangeQiHuTunValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if cddhdObj.AddBtnQiHuTun.gameObject == go then
		cddhdData.qiHuTun = cddhdData.qiHuTun + 1
		if cddhdData.qiHuTun > 10 then
			cddhdData.qiHuTun = 10
		end
    else
		cddhdData.qiHuTun = cddhdData.qiHuTun - 1
		if cddhdData.qiHuTun < 1 then
			cddhdData.qiHuTun = 1
		end
    end
	cddhdObj.QiHuTunValue:GetComponent("UILabel").text = cddhdData.qiHuTun..'等'
    UnityEngine.PlayerPrefs.SetInt('NewCDDHDqiHuTun', cddhdData.qiHuTun)
end

function this.OnClickChangeFengDingValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if cddhdObj.AddBtnFengDing.gameObject == go then
        if cddhdData.maxHuXi ~= 0 then
            cddhdData.maxHuXi = cddhdData.maxHuXi + 10
            if cddhdData.maxHuXi > 80 then
                cddhdData.maxHuXi = 0
            end
        end
    else
        if cddhdData.maxHuXi == 0 then
            cddhdData.maxHuXi = 80
        else
            cddhdData.maxHuXi = cddhdData.maxHuXi - 10
            if cddhdData.maxHuXi < 10 then
                cddhdData.maxHuXi = 10
            end
        end
    end
	cddhdObj.FengDingValue:GetComponent("UILabel").text = cddhdData.maxHuXi == 0 and '不封顶' or cddhdData.maxHuXi..'分'
	UnityEngine.PlayerPrefs.SetInt('NewCDDHDmaxHuXi', cddhdData.maxHuXi)
end

function this.OnClickChangeHuangZhuangKouFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if cddhdObj.AddBtnHuangZhuangKouFen.gameObject == go then
		cddhdData.huangZhuangFen = cddhdData.huangZhuangFen + 1
		if cddhdData.huangZhuangFen > 10 then
			cddhdData.huangZhuangFen = 10
		end
    else
		cddhdData.huangZhuangFen = cddhdData.huangZhuangFen - 1
		if cddhdData.huangZhuangFen < 0 then
			cddhdData.huangZhuangFen = 0
		end
    end
	cddhdObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = cddhdData.huangZhuangFen == 0 and '不扣分' or '扣'..cddhdData.huangZhuangFen..'分'
	UnityEngine.PlayerPrefs.SetInt('NewCDDHDhuangZhuangFen', cddhdData.huangZhuangFen)
end

function this.OnClickTogglePlayCDDHD(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == cddhdObj.ToggleTianHu.gameObject then
		cddhdData.tianHu = cddhdObj.ToggleTianHu:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewCDDHDtianHu', cddhdData.tianHu and 1 or 0)
	elseif go == cddhdObj.ToggleDiHu.gameObject then
		cddhdData.diHu = cddhdObj.ToggleDiHu:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewCDDHDdiHu', cddhdData.diHu and 1 or 0)
	elseif go == cddhdObj.ToggleTingHu.gameObject then
		cddhdData.tingHu = cddhdObj.ToggleTingHu:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewCDDHDtingHu', cddhdData.tingHu and 1 or 0)
	elseif go == cddhdObj.ToggleHaiDiHu.gameObject then
		cddhdData.haiDiHu = cddhdObj.ToggleHaiDiHu:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewCDDHDhaiDiHu', cddhdData.haiDiHu and 1 or 0)
	elseif go == cddhdObj.ToggleHuangFan.gameObject then
		cddhdData.huangFan = cddhdObj.ToggleHuangFan:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewCDDHDhuangFan', cddhdData.huangFan and 1 or 0)
	end
end

function this.OnClickToggleChou(go)
	AudioManager.Instance:PlayAudio('btn')
	if cddhdObj.ToggleChou0.gameObject == go then
        cddhdData.chou=0
    elseif cddhdObj.ToggleChou10.gameObject == go then
        cddhdData.chou=10
    elseif cddhdObj.ToggleChou20.gameObject == go then
        cddhdData.chou=20
	end
	UnityEngine.PlayerPrefs.SetInt('NewCDDHDchou', cddhdData.chou)
end

function this.OnClickChoiceDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if cddhdObj.ToggleChoiceDouble.gameObject == go then
        cddhdData.choiceDouble = true
    elseif cddhdObj.ToggleNoChoiceDouble.gameObject == go then
        cddhdData.choiceDouble = false
    end
    cddhdObj.DoubleScoreText.parent.gameObject:SetActive(cddhdData.choiceDouble)
    cddhdObj.ToggleMultiple2.parent.gameObject:SetActive(cddhdData.choiceDouble)
    CDDHD:Find('table'):GetComponent('UIGrid'):Reposition()
    UnityEngine.PlayerPrefs.SetInt('NewCDDHDchoiceDouble', cddhdData.choiceDouble and 1 or 0)
end

function this.OnClickChangeDoubleScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if cddhdObj.AddDoubleScoreButton.gameObject == go then
        if cddhdData.doubleScore ~= 0 then
            cddhdData.doubleScore = cddhdData.doubleScore + 1
            if cddhdData.doubleScore > 100 then
                cddhdData.doubleScore = 0
            end
        end
    else
        if cddhdData.doubleScore == 0 then
            cddhdData.doubleScore = 100
        else
            cddhdData.doubleScore = cddhdData.doubleScore - 1
            if cddhdData.doubleScore < 1 then
                cddhdData.doubleScore = 1
            end
        end
    end
    if cddhdData.doubleScore == 0 then
        cddhdObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
    else
        cddhdObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..cddhdData.doubleScore..'分'
    end
    UnityEngine.PlayerPrefs.SetInt('NewCDDHDdoubleScore', cddhdData.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
    if cddhdObj.ToggleMultiple2.gameObject == go then
        cddhdData.multiple=2
    elseif cddhdObj.ToggleMultiple3.gameObject == go then
        cddhdData.multiple=3
    elseif cddhdObj.ToggleMultiple4.gameObject == go then
        cddhdData.multiple=4
    end
    UnityEngine.PlayerPrefs.SetInt('NewCDDHDmultiple', cddhdData.multiple)
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    cddhdData.isSettlementScore= cddhdObj.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewCDDHDisSettlementScore', cddhdData.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if cddhdObj.ToggleFewerAddButton.gameObject == go then
		cddhdData.fewerValue = cddhdData.fewerValue + 1
		if cddhdData.fewerValue > 100 then
			cddhdData.fewerValue = 100
		end
    elseif cddhdObj.ToggleFewerSubtractButton.gameObject == go then
		cddhdData.fewerValue = cddhdData.fewerValue - 1
		if cddhdData.fewerValue < 1 then
			cddhdData.fewerValue = 1
		end
	end
	cddhdObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = cddhdData.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewCDDHDfewerValue', cddhdData.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if cddhdObj.ToggleAddAddButton.gameObject == go then
		cddhdData.addValue = cddhdData.addValue + 1
		if cddhdData.addValue > 100 then
			cddhdData.addValue = 100
		end
    elseif cddhdObj.ToggleAddSubtractButton.gameObject == go then
		cddhdData.addValue = cddhdData.addValue - 1
		if cddhdData.addValue < 1 then
			cddhdData.addValue = 1
		end
	end
	cddhdObj.ToggleAddScoreTxt:GetComponent('UILabel').text = cddhdData.addValue
	UnityEngine.PlayerPrefs.SetInt('NewCDDHDaddValue', cddhdData.addValue)
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if cddhdObj.ToggleIPcheck.gameObject == go then
		cddhdData.openIp = cddhdObj.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('CDDHDcheckIP', cddhdData.openIp and 1 or 0)
	elseif cddhdObj.ToggleGPScheck.gameObject == go then
		cddhdData.openGps = cddhdObj.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('CDDHDcheckGPS', cddhdData.openGps and 1 or 0)
	end
end

return this