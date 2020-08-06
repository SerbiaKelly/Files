local this = {}
local SYBP
local payLabel

local sybpObj = {}
local sybpData = {}

function this.Init(grid,message)
	print('Init_SYBP')
	SYBP = grid
	payLabel = message.transform:Find('diamond/pay_label')
	
	sybpObj.TogglePeopleNum2 = SYBP:Find('table/num/num2')
	sybpObj.TogglePeopleNum3 = SYBP:Find('table/num/num3')
	message:AddClick(sybpObj.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
    message:AddClick(sybpObj.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)
	
	sybpObj.ToggleMasterPay = SYBP:Find('table/pay/master')
	sybpObj.ToggleWinnerPay = SYBP:Find('table/pay/win')
	message:AddClick(sybpObj.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(sybpObj.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)
	
	sybpObj.ToggleRandomBanker = SYBP:Find('table/randomBanker/Auto')
	sybpObj.ToggleBankerFrist = SYBP:Find('table/randomBanker/Frist')
	message:AddClick(sybpObj.ToggleRandomBanker.gameObject, this.OnClickRandomBanker)
	message:AddClick(sybpObj.ToggleBankerFrist.gameObject, this.OnClickRandomBanker)

	sybpObj.ToggleHongHeiHu = SYBP:Find('table/hutype/BpHong')
	sybpObj.ToggleHongHeiDian = SYBP:Find('table/hutype/BpHongDian')
	sybpObj.ToggleNoHongHei = SYBP:Find('table/hutype/BpNone')
	message:AddClick(sybpObj.ToggleHongHeiHu.gameObject, this.OnClickBpHuType)
	message:AddClick(sybpObj.ToggleHongHeiDian.gameObject, this.OnClickBpHuType)
	message:AddClick(sybpObj.ToggleNoHongHei.gameObject, this.OnClickBpHuType)

	sybpObj.ToggleFengDing0 = SYBP:Find('table/maxHuXi/0')
	sybpObj.ToggleFengDing150 = SYBP:Find('table/maxHuXi/150')
	sybpObj.ToggleFengDing200 = SYBP:Find('table/maxHuXi/200')
	sybpObj.ToggleFengDing300 = SYBP:Find('table/maxHuXi/300')
	message:AddClick(sybpObj.ToggleFengDing0.gameObject, this.OnClickSYBPMaxHuXi)
	message:AddClick(sybpObj.ToggleFengDing150.gameObject, this.OnClickSYBPMaxHuXi)
	message:AddClick(sybpObj.ToggleFengDing200.gameObject, this.OnClickSYBPMaxHuXi)
	message:AddClick(sybpObj.ToggleFengDing300.gameObject, this.OnClickSYBPMaxHuXi)

	sybpObj.ToggleChou0 = SYBP:Find('table/chouCard/chouCard0')
	sybpObj.ToggleChou10 = SYBP:Find('table/chouCard/chouCard10')
	sybpObj.ToggleChou20 = SYBP:Find('table/chouCard/chouCard20')
	message:AddClick(sybpObj.ToggleChou0.gameObject, this.OnClickToggleChou)
	message:AddClick(sybpObj.ToggleChou10.gameObject, this.OnClickToggleChou)
	message:AddClick(sybpObj.ToggleChou20.gameObject, this.OnClickToggleChou)

	sybpObj.ToggleZeroToTop = SYBP:Find('table/play/zeroToTop')
	sybpObj.Toggle1RoundEnd = SYBP:Find('table/play/1roundEnd')
	message:AddClick(sybpObj.ToggleZeroToTop.gameObject, this.OnClickTogglePlay)
	message:AddClick(sybpObj.Toggle1RoundEnd.gameObject, this.OnClickTogglePlay)

	sybpObj.ToggleOnNiao = SYBP:Find('table/niao/OnNiao')
	sybpObj.ToggleOffNiao = SYBP:Find('table/niao/OffNiao')
	sybpObj.NiaoValueText = SYBP:Find('table/niao/NiaoValue/Value')
	sybpObj.AddButtonNiao = SYBP:Find('table/niao/NiaoValue/AddButton')
	sybpObj.SubtractButtonNiao = SYBP:Find('table/niao/NiaoValue/SubtractButton')
	message:AddClick(sybpObj.ToggleOnNiao.gameObject, this.OnClickNiao)
	message:AddClick(sybpObj.ToggleOffNiao.gameObject, this.OnClickNiao)
	message:AddClick(sybpObj.AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(sybpObj.SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)

	sybpObj.ToggleChoiceDouble = SYBP:Find('table/choiceDouble/On')
	sybpObj.ToggleNoChoiceDouble = SYBP:Find('table/choiceDouble/Off')
	sybpObj.DoubleScoreText = SYBP:Find('table/choiceDouble/doubleScore/Value')
	sybpObj.AddDoubleScoreButton = SYBP:Find('table/choiceDouble/doubleScore/AddButton')
	sybpObj.SubtractDoubleScoreButton = SYBP:Find('table/choiceDouble/doubleScore/SubtractButton')
	sybpObj.ToggleMultiple2 = SYBP:Find('table/multiple/2')
	sybpObj.ToggleMultiple3 = SYBP:Find('table/multiple/3')
	sybpObj.ToggleMultiple4 = SYBP:Find('table/multiple/4')
	message:AddClick(sybpObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(sybpObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(sybpObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(sybpObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(sybpObj.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(sybpObj.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(sybpObj.ToggleMultiple4.gameObject, this.OnClickMultiple)

	sybpObj.ToggleSettlementScoreSelect=SYBP:Find('table/settlementScore/select')
	sybpObj.ToggleFewerScoreTxt=SYBP:Find('table/settlementScore/fewerValue/Value')
	sybpObj.ToggleFewerAddButton=SYBP:Find('table/settlementScore/fewerValue/AddButton')
	sybpObj.ToggleFewerSubtractButton=SYBP:Find('table/settlementScore/fewerValue/SubtractButton')
	sybpObj.ToggleAddScoreTxt=SYBP:Find('table/settlementScore/addValue/Value')
	sybpObj.ToggleAddAddButton=SYBP:Find('table/settlementScore/addValue/AddButton')
	sybpObj.ToggleAddSubtractButton=SYBP:Find('table/settlementScore/addValue/SubtractButton')
	message:AddClick(sybpObj.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(sybpObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(sybpObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(sybpObj.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(sybpObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)

	sybpObj.ToggleTrusteeshipNo = SYBP:Find('table/DelegateChoose/NoDelegate')
	sybpObj.ToggleTrusteeship1 = SYBP:Find('table/DelegateChoose/Delegate1')
	sybpObj.ToggleTrusteeship2 = SYBP:Find('table/DelegateChoose/Delegate2')
	sybpObj.ToggleTrusteeship3 = SYBP:Find('table/DelegateChoose/Delegate3')
	sybpObj.ToggleTrusteeship5 = SYBP:Find('table/DelegateChoose/Delegate5')
	sybpObj.ToggleTrusteeshipAll = SYBP:Find('table/DelegateCancel/FullRound')
	sybpObj.ToggleTrusteeshipOne = SYBP:Find('table/DelegateCancel/ThisRound')
	sybpObj.ToggleTrusteeshipThree = SYBP:Find('table/DelegateCancel/ThreeRound')
	message:AddClick(sybpObj.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(sybpObj.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(sybpObj.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(sybpObj.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(sybpObj.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(sybpObj.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(sybpObj.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(sybpObj.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)

	sybpObj.ToggleIPcheck = SYBP:Find('table/PreventCheat/IPcheck')
	sybpObj.ToggleGPScheck = SYBP:Find('table/PreventCheat/GPScheck')
	message:AddClick(sybpObj.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(sybpObj.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end
function this.Refresh()
	print('Refresh_SYBP')
	sybpData.size=UnityEngine.PlayerPrefs.GetInt('NewSYBPsize', 2)
	sybpObj.TogglePeopleNum2:GetComponent('UIToggle'):Set(sybpData.size == 2)
    sybpObj.TogglePeopleNum3:GetComponent('UIToggle'):Set(sybpData.size == 3)

	sybpData.paymentType=UnityEngine.PlayerPrefs.GetInt('NewSYBPpaymentType', 0)
	sybpObj.ToggleMasterPay:GetComponent('UIToggle'):Set(sybpData.paymentType == 0)
	sybpObj.ToggleWinnerPay:GetComponent('UIToggle'):Set(sybpData.paymentType == 2)

	sybpData.randomBanker=UnityEngine.PlayerPrefs.GetInt('NewSYBPrandomBanker', 0)==1
	sybpObj.ToggleRandomBanker:GetComponent('UIToggle'):Set(sybpData.randomBanker)
	sybpObj.ToggleBankerFrist:GetComponent('UIToggle'):Set(not sybpData.randomBanker)
	
	sybpData.heiHongDian=UnityEngine.PlayerPrefs.GetInt('NewSYBPheiHongDian', 0)
	sybpObj.ToggleHongHeiHu:GetComponent('UIToggle'):Set(sybpData.heiHongDian == 0)
	sybpObj.ToggleHongHeiDian:GetComponent('UIToggle'):Set(sybpData.heiHongDian == 1)
	sybpObj.ToggleNoHongHei:GetComponent('UIToggle'):Set(sybpData.heiHongDian == 2)

	sybpData.maxHuXi=UnityEngine.PlayerPrefs.GetInt('NewSYBPmaxHuXi', 0)
	sybpObj.ToggleFengDing0:GetComponent('UIToggle'):Set(sybpData.maxHuXi == 0)
	sybpObj.ToggleFengDing150:GetComponent('UIToggle'):Set(sybpData.maxHuXi == 150)
	sybpObj.ToggleFengDing200:GetComponent('UIToggle'):Set(sybpData.maxHuXi == 200)
	sybpObj.ToggleFengDing300:GetComponent('UIToggle'):Set(sybpData.maxHuXi == 300)
	
	sybpData.chou = UnityEngine.PlayerPrefs.GetInt('NewSYBPchou', 20)
	sybpObj.ToggleChou0:GetComponent('UIToggle'):Set(sybpData.chou == 0)
	sybpObj.ToggleChou10:GetComponent('UIToggle'):Set(sybpData.chou == 10)
	sybpObj.ToggleChou20:GetComponent('UIToggle'):Set(sybpData.chou == 20)
	sybpObj.ToggleChou0.parent.gameObject:SetActive(sybpData.size == 2)

	sybpData.zeroToTop = UnityEngine.PlayerPrefs.GetInt('NewSYBPzeroToTop', 0) == 1
	sybpObj.ToggleZeroToTop:GetComponent('UIToggle'):Set(sybpData.zeroToTop)

	sybpData.rounds = UnityEngine.PlayerPrefs.GetInt('NewSYBProunds', 0)
	sybpObj.Toggle1RoundEnd:GetComponent('UIToggle'):Set(sybpData.rounds == 1)

	sybpData.niao=UnityEngine.PlayerPrefs.GetInt('NewSYBPniao', 0)==1
	sybpData.niaoValue=UnityEngine.PlayerPrefs.GetInt('NewSYBPniaoValue', 10)
	sybpObj.ToggleOnNiao:GetComponent('UIToggle'):Set(sybpData.niao)
	sybpObj.ToggleOffNiao:GetComponent('UIToggle'):Set(not sybpData.niao)
	sybpObj.NiaoValueText.parent.gameObject:SetActive(sybpData.niao)
    sybpObj.NiaoValueText:GetComponent('UILabel').text = sybpData.niaoValue.."分"

	sybpData.choiceDouble=UnityEngine.PlayerPrefs.GetInt('NewSYBPchoiceDouble', 0)==1
	sybpData.doubleScore=UnityEngine.PlayerPrefs.GetInt('NewSYBPdoubleScore', 10)
	sybpData.multiple=UnityEngine.PlayerPrefs.GetInt('NewSYBPmultiple', 2)
	sybpObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(sybpData.choiceDouble)
	sybpObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not sybpData.choiceDouble)
	sybpObj.DoubleScoreText.parent.gameObject:SetActive(sybpData.choiceDouble)
	if sybpData.doubleScore == 0 then
		sybpObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		sybpObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..sybpData.doubleScore..'分'
	end
	sybpObj.ToggleChoiceDouble.parent.gameObject:SetActive(sybpData.size == 2)
	sybpObj.ToggleMultiple2:GetComponent('UIToggle'):Set(sybpData.multiple == 2)
	sybpObj.ToggleMultiple3:GetComponent('UIToggle'):Set(sybpData.multiple == 3)
	sybpObj.ToggleMultiple4:GetComponent('UIToggle'):Set(sybpData.multiple == 4)
	sybpObj.ToggleMultiple2.parent.gameObject:SetActive(sybpData.choiceDouble and  sybpData.size == 2)

	sybpData.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewSYBPisSettlementScore', 0)==1
	sybpData.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewSYBPfewerValue', 10)
	sybpData.addValue=UnityEngine.PlayerPrefs.GetInt('NewSYBPaddValue', 10)
	sybpObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(sybpData.size==2)
	sybpObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(sybpData.isSettlementScore)
	sybpObj.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	sybpObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = sybpData.fewerValue
	sybpObj.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	sybpObj.ToggleAddScoreTxt:GetComponent('UILabel').text = sybpData.addValue

	sybpData.trusteeshipTime=UnityEngine.PlayerPrefs.GetInt('NewSYBPtrusteeshipTime', 0)
	sybpData.trusteeshipType = UnityEngine.PlayerPrefs.GetInt('NewSYBPtrusteeshipType', 0) == 1
	sybpData.trusteeshipRound = UnityEngine.PlayerPrefs.GetInt('NewSYBPtrusteeshipRound', 0)
	sybpObj.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(sybpData.trusteeshipTime == 0)
	sybpObj.ToggleTrusteeship1:GetComponent('UIToggle'):Set(sybpData.trusteeshipTime == 1)
	sybpObj.ToggleTrusteeship2:GetComponent('UIToggle'):Set(sybpData.trusteeshipTime == 2)
	sybpObj.ToggleTrusteeship3:GetComponent('UIToggle'):Set(sybpData.trusteeshipTime == 3)
	sybpObj.ToggleTrusteeship5:GetComponent('UIToggle'):Set(sybpData.trusteeshipTime == 5)
	sybpObj.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(sybpData.trusteeshipType)
	sybpObj.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not sybpData.trusteeshipType and sybpData.trusteeshipRound == 0)
	sybpObj.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(sybpData.trusteeshipRound == 3);
	sybpObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(sybpData.trusteeshipTime ~= 0)

	sybpData.openIp=UnityEngine.PlayerPrefs.GetInt('SYBPcheckIP', 0)==1
	sybpData.openGps=UnityEngine.PlayerPrefs.GetInt('SYBPcheckGPS', 0)==1
	sybpObj.ToggleIPcheck.parent.gameObject:SetActive(sybpData.size > 2 and CONST.IPcheckOn)
	sybpObj.ToggleIPcheck:GetComponent('UIToggle'):Set(sybpData.openIp)
	sybpObj.ToggleGPScheck:GetComponent('UIToggle'):Set(sybpData.openGps)
    payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.SYBP,sybpData.rounds,sybpData.size,nil)
	SYBP:Find('table'):GetComponent('UIGrid'):Reposition()
end
--获取当前设置
function this.GetConfig()
	local moneyLess = false
	if (sybpData.size == 2 and info_login.balance < 2) or
	   (sybpData.size == 3 and info_login.balance < 3) then
			moneyLess = true
	end
	local body = {}
	
	body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.SYBP)
    body.rounds = sybpData.rounds
	body.size = sybpData.size
	body.paymentType = sybpData.paymentType
	body.randomBanker = sybpData.randomBanker
	body.trusteeship = sybpData.trusteeshipTime*60;
	body.trusteeshipDissolve = sybpData.trusteeshipType;
	body.trusteeshipRound = sybpData.trusteeshipRound;
	body.tianDiHu = true
	body.qiHuHuXi = 10
	body.tunXi = 1
	body.fanXing = false
	body.niao = sybpData.niao
	body.niaoValue = sybpData.niaoValue

	if sybpData.size == 2 then
		body.choiceDouble = sybpData.choiceDouble
        body.doubleScore = sybpData.doubleScore
        body.multiple = sybpData.multiple
		body.resultScore = sybpData.isSettlementScore
		if sybpData.isSettlementScore then
			body.resultLowerScore=sybpData.fewerValue
			body.resultAddScore=sybpData.addValue
		end
		sybpData.openIp=false
		sybpData.openGps=false
	end
	body.chou = sybpData.size == 2 and sybpData.chou or 0
	body.heiHongHu = sybpData.heiHongDian == 0
	body.heiHongDian = sybpData.heiHongDian == 1
	body.maxHuXi = sybpData.maxHuXi
	body.openIp	 = sybpData.openIp
	body.openGps = sybpData.openGps
	body.zeroToTop = sybpData.zeroToTop
    return moneyLess,body;
end

function this.OnClickTogglePlayerNum(go)
	AudioManager.Instance:PlayAudio('btn')
    if sybpObj.TogglePeopleNum2.gameObject == go then
        sybpData.size = 2
    elseif sybpObj.TogglePeopleNum3.gameObject == go then
        sybpData.size = 3
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.SYBP,sybpData.rounds,sybpData.size,nil)
	sybpObj.ToggleIPcheck.parent.gameObject:SetActive(sybpData.size > 2 and CONST.IPcheckOn)
	UnityEngine.PlayerPrefs.SetInt('NewSYBPsize', sybpData.size)
	sybpObj.ToggleNoChoiceDouble.parent.gameObject:SetActive(sybpData.size==2)
    sybpObj.ToggleMultiple2.parent.gameObject:SetActive(sybpData.choiceDouble and sybpData.size==2)
	sybpObj.DoubleScoreText.parent.gameObject:SetActive(sybpData.choiceDouble)
	sybpObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(sybpData.size==2)
	sybpObj.ToggleChou0.parent.gameObject:SetActive(sybpData.size == 2)
    SYBP:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePayType(go)
	AudioManager.Instance:PlayAudio('btn')
    if sybpObj.ToggleMasterPay.gameObject == go then
        sybpData.paymentType=0
    elseif sybpObj.ToggleWinnerPay.gameObject == go then
        sybpData.paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewSYBPpaymentType', sybpData.paymentType)
end

function this.OnClickRandomBanker(go)
	AudioManager.Instance:PlayAudio('btn')
    if sybpObj.ToggleRandomBanker.gameObject == go then
        sybpData.randomBanker = true
    elseif sybpObj.ToggleBankerFrist.gameObject == go then
        sybpData.randomBanker = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewSYBPrandomBanker', sybpData.randomBanker and 1 or 0)
end

function this.OnClickTrusteeshipTime(go)
	AudioManager.Instance:PlayAudio('btn')
    if sybpObj.ToggleTrusteeshipNo.gameObject == go then
        sybpData.trusteeshipTime = 0
    elseif sybpObj.ToggleTrusteeship1.gameObject == go then
        sybpData.trusteeshipTime = 1
	elseif sybpObj.ToggleTrusteeship2.gameObject == go then
		sybpData.trusteeshipTime = 2
	elseif sybpObj.ToggleTrusteeship3.gameObject == go then
        sybpData.trusteeshipTime = 3
    elseif sybpObj.ToggleTrusteeship5.gameObject == go then
        sybpData.trusteeshipTime = 5
    end
    UnityEngine.PlayerPrefs.SetInt('NewSYBPtrusteeshipTime', sybpData.trusteeshipTime)
	sybpObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(sybpData.trusteeshipTime ~= 0)
	SYBP:Find('table'):GetComponent('UIGrid'):Reposition()
end
function this.OnClickTrusteeshipType(go)
	AudioManager.Instance:PlayAudio('btn')
	if sybpObj.ToggleTrusteeshipOne.gameObject == go then
		sybpData.trusteeshipType = true
		sybpData.trusteeshipRound = 0;
	elseif sybpObj.ToggleTrusteeshipAll.gameObject == go then
		sybpData.trusteeshipType = false
		sybpData.trusteeshipRound = 0;
	elseif sybpObj.ToggleTrusteeshipThree .gameObject == go then
		sybpData.trusteeshipRound = 3;
		sybpData.trusteeshipType = false;
	end
    UnityEngine.PlayerPrefs.SetInt('NewSYBPtrusteeshipType',sybpData.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewSYBPtrusteeshipRound',sybpData.trusteeshipRound)
end

function this.OnClickNiao(go)
	AudioManager.Instance:PlayAudio('btn')
	if sybpObj.ToggleOnNiao.gameObject == go then
		sybpData.niao = true
	elseif sybpObj.ToggleOffNiao.gameObject == go then
		sybpData.niao = false
	end
	sybpObj.NiaoValueText.parent.gameObject:SetActive(sybpData.niao)
	UnityEngine.PlayerPrefs.SetInt('NewSYBPniao', sybpData.niao and 1 or 0)
	
end

function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if sybpObj.AddButtonNiao.gameObject == go then
		sybpData.niaoValue = sybpData.niaoValue + 10
		if sybpData.niaoValue > 100 then
			sybpData.niaoValue = 100
		end
	elseif sybpObj.SubtractButtonNiao.gameObject == go then
		sybpData.niaoValue = sybpData.niaoValue - 10
		if sybpData.niaoValue < 10 then
			sybpData.niaoValue = 10
		end
	end
	sybpObj.NiaoValueText:GetComponent('UILabel').text = sybpData.niaoValue.."分"
	UnityEngine.PlayerPrefs.SetInt('NewSYBPniaoValue', sybpData.niaoValue)
end

function this.OnClickBpHuType(go)
	AudioManager.Instance:PlayAudio('btn')
	if sybpObj.ToggleHongHeiHu.gameObject == go then
		sybpData.heiHongDian = 0
	elseif sybpObj.ToggleHongHeiDian.gameObject == go then
		sybpData.heiHongDian = 1
	elseif sybpObj.ToggleNoHongHei.gameObject == go then
		sybpData.heiHongDian = 2
	end
	UnityEngine.PlayerPrefs.SetInt('NewSYBPheiHongDian', sybpData.heiHongDian)
end

function this.OnClickSYBPMaxHuXi(go)
	AudioManager.Instance:PlayAudio('btn')
	if sybpObj.ToggleFengDing0.gameObject == go then
		sybpData.maxHuXi = 0
	elseif sybpObj.ToggleFengDing150.gameObject == go then
		sybpData.maxHuXi = 150
	elseif sybpObj.ToggleFengDing200.gameObject == go then
		sybpData.maxHuXi = 200
	elseif sybpObj.ToggleFengDing300.gameObject == go then
		sybpData.maxHuXi = 300
	end
	UnityEngine.PlayerPrefs.SetInt('NewSYBPmaxHuXi',sybpData.maxHuXi)
end

function this.OnClickChoiceDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if sybpObj.ToggleChoiceDouble.gameObject == go then
        sybpData.choiceDouble = true
    elseif sybpObj.ToggleNoChoiceDouble.gameObject == go then
        sybpData.choiceDouble = false
    end
    sybpObj.DoubleScoreText.parent.gameObject:SetActive(sybpData.choiceDouble)
    sybpObj.ToggleMultiple2.parent.gameObject:SetActive(sybpData.choiceDouble)
    SYBP:Find('table'):GetComponent('UIGrid'):Reposition()
    UnityEngine.PlayerPrefs.SetInt('NewSYBPchoiceDouble', sybpData.choiceDouble and 1 or 0)
end

function this.OnClickChangeDoubleScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if sybpObj.AddDoubleScoreButton.gameObject == go then
        if sybpData.doubleScore ~= 0 then
            sybpData.doubleScore = sybpData.doubleScore + 1
            if sybpData.doubleScore > 100 then
                sybpData.doubleScore = 0
            end
        end
    else
        if sybpData.doubleScore == 0 then
            sybpData.doubleScore = 100
        else
            sybpData.doubleScore = sybpData.doubleScore - 1
            if sybpData.doubleScore < 1 then
                sybpData.doubleScore = 1
            end
        end
    end
    if sybpData.doubleScore == 0 then
        sybpObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
    else
        sybpObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..sybpData.doubleScore..'分'
    end
    UnityEngine.PlayerPrefs.SetInt('NewSYBPdoubleScore', sybpData.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
    if sybpObj.ToggleMultiple2.gameObject == go then
        sybpData.multiple=2
    elseif sybpObj.ToggleMultiple3.gameObject == go then
        sybpData.multiple=3
    elseif sybpObj.ToggleMultiple4.gameObject == go then
		sybpData.multiple=4
    end
    UnityEngine.PlayerPrefs.SetInt('NewSYBPmultiple', sybpData.multiple)
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    sybpData.isSettlementScore= sybpObj.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewSYBPisSettlementScore', sybpData.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if sybpObj.ToggleFewerAddButton.gameObject == go then
		sybpData.fewerValue = sybpData.fewerValue + 1
		if sybpData.fewerValue > 100 then
			sybpData.fewerValue = 100
		end
    elseif sybpObj.ToggleFewerSubtractButton.gameObject == go then
		sybpData.fewerValue = sybpData.fewerValue - 1
		if sybpData.fewerValue < 1 then
			sybpData.fewerValue = 1
		end
	end
	sybpObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = sybpData.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewSYBPfewerValue', sybpData.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if sybpObj.ToggleAddAddButton.gameObject == go then
		sybpData.addValue = sybpData.addValue + 1
		if sybpData.addValue > 100 then
			sybpData.addValue = 100
		end
    elseif sybpObj.ToggleAddSubtractButton.gameObject == go then
		sybpData.addValue = sybpData.addValue - 1
		if sybpData.addValue < 1 then
			sybpData.addValue = 1
		end
	end
	sybpObj.ToggleAddScoreTxt:GetComponent('UILabel').text = sybpData.addValue
	UnityEngine.PlayerPrefs.SetInt('NewSYBPaddValue', sybpData.addValue)
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if sybpObj.ToggleIPcheck.gameObject == go then
		sybpData.openIp = sybpObj.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('SYBPcheckIP', sybpData.openIp and 1 or 0)
	elseif sybpObj.ToggleGPScheck.gameObject == go then
		sybpData.openGps = sybpObj.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('SYBPcheckGPS', sybpData.openGps and 1 or 0)
	end
end

function this.OnClickToggleChou(go)
	AudioManager.Instance:PlayAudio('btn')
	if sybpObj.ToggleChou0.gameObject == go then
        sybpData.chou=0
    elseif sybpObj.ToggleChou10.gameObject == go then
        sybpData.chou=10
    elseif sybpObj.ToggleChou20.gameObject == go then
        sybpData.chou=20
	end
	UnityEngine.PlayerPrefs.SetInt('NewSYBPchou', sybpData.chou)
end

function this.OnClickTogglePlay(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == sybpObj.ToggleZeroToTop.gameObject then
		sybpData.zeroToTop = sybpObj.ToggleZeroToTop:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewSYBPzeroToTop', sybpData.zeroToTop and 1 or 0)
	elseif go == sybpObj.Toggle1RoundEnd.gameObject then
		sybpData.rounds = sybpObj.Toggle1RoundEnd:GetComponent('UIToggle').value and 1 or 0
		UnityEngine.PlayerPrefs.SetInt('NewSYBProunds', sybpData.rounds)
		payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.SYBP,sybpData.rounds,sybpData.size,nil)
	end
end
return this