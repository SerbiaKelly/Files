local this = {}

local LYZP
local payLabel

local lyzpObj = {}
local lyzpData = {}

function this.Init(grid,message)
	print('Init_LYZP')
	LYZP = grid
	payLabel = message.transform:Find('diamond/pay_label')

	lyzpObj.ToggleRound6 = LYZP:Find('table/round/round6')
	lyzpObj.ToggleRound8 = LYZP:Find('table/round/round8')
	lyzpObj.ToggleRound10 = LYZP:Find('table/round/round10')
	lyzpObj.ToggleRound16 = LYZP:Find('table/round/round16')
	message:AddClick(lyzpObj.ToggleRound6.gameObject, this.OnClickToggleRound)
	message:AddClick(lyzpObj.ToggleRound8.gameObject, this.OnClickToggleRound)
	message:AddClick(lyzpObj.ToggleRound10.gameObject, this.OnClickToggleRound)
	message:AddClick(lyzpObj.ToggleRound16.gameObject, this.OnClickToggleRound)

	lyzpObj.TogglePeopleNum2 = LYZP:Find('table/num/num2')
	lyzpObj.TogglePeopleNum3 = LYZP:Find('table/num/num3')
	message:AddClick(lyzpObj.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(lyzpObj.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)

	lyzpObj.ToggleMasterPay = LYZP:Find('table/pay/master')
	lyzpObj.ToggleWinnerPay = LYZP:Find('table/pay/win')
	message:AddClick(lyzpObj.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(lyzpObj.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)

	lyzpObj.ToggleRandomBanker = LYZP:Find('table/randomBanker/Auto')
	lyzpObj.ToggleBankerFrist = LYZP:Find('table/randomBanker/Frist')
	message:AddClick(lyzpObj.ToggleRandomBanker.gameObject, this.OnClickRandomBanker)
	message:AddClick(lyzpObj.ToggleBankerFrist.gameObject, this.OnClickRandomBanker)

	lyzpObj.ToggleChoiceHu = LYZP:Find('table/play/choiceHu')
	lyzpObj.ToggleMaoHu = LYZP:Find('table/play/maoHu')
	lyzpObj.ToggleYiDianHong = LYZP:Find('table/play/yiDianHong')
	message:AddClick(lyzpObj.ToggleChoiceHu.gameObject, this.OnClickToggleChoiceHu)
	message:AddClick(lyzpObj.ToggleMaoHu.gameObject, this.OnClickToggleMaoHu)
	message:AddClick(lyzpObj.ToggleYiDianHong.gameObject, this.OnClickToggleYiDianHong)
	
	lyzpObj.ToggleChou0 = LYZP:Find('table/chouCard/chouCard0')
	lyzpObj.ToggleChou10 = LYZP:Find('table/chouCard/chouCard10')
	lyzpObj.ToggleChou20 = LYZP:Find('table/chouCard/chouCard20')
	message:AddClick(lyzpObj.ToggleChou0.gameObject, this.OnClickToggleChou)
	message:AddClick(lyzpObj.ToggleChou10.gameObject, this.OnClickToggleChou)
	message:AddClick(lyzpObj.ToggleChou20.gameObject, this.OnClickToggleChou)
	
	lyzpObj.ToggleTiAddScore0 = LYZP:Find('table/tiAddScore/tiAddScore0')
	lyzpObj.ToggleTiAddScore1 = LYZP:Find('table/tiAddScore/tiAddScore1')
	lyzpObj.ToggleTiAddScore2 = LYZP:Find('table/tiAddScore/tiAddScore2')
	message:AddClick(lyzpObj.ToggleTiAddScore0.gameObject, this.OnClickToggleTiAddScore)
	message:AddClick(lyzpObj.ToggleTiAddScore1.gameObject, this.OnClickToggleTiAddScore)
	message:AddClick(lyzpObj.ToggleTiAddScore2.gameObject, this.OnClickToggleTiAddScore)

	lyzpObj.ToggleOnNiao = LYZP:Find('table/niao/OnNiao')
	lyzpObj.ToggleOffNiao = LYZP:Find('table/niao/OffNiao')
	lyzpObj.NiaoValueText = LYZP:Find('table/niao/NiaoValue/Value')
	lyzpObj.AddButtonNiao = LYZP:Find('table/niao/NiaoValue/AddButton')
	lyzpObj.SubtractButtonNiao = LYZP:Find('table/niao/NiaoValue/SubtractButton')
	message:AddClick(lyzpObj.ToggleOnNiao.gameObject, this.OnClickNiao)
	message:AddClick(lyzpObj.ToggleOffNiao.gameObject, this.OnClickNiao)
	message:AddClick(lyzpObj.AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(lyzpObj.SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)

	lyzpObj.ToggleChoiceDouble = LYZP:Find('table/choiceDouble/On')
	lyzpObj.ToggleNoChoiceDouble = LYZP:Find('table/choiceDouble/Off')
	lyzpObj.DoubleScoreText = LYZP:Find('table/choiceDouble/doubleScore/Value')
	lyzpObj.AddDoubleScoreButton = LYZP:Find('table/choiceDouble/doubleScore/AddButton')
	lyzpObj.SubtractDoubleScoreButton = LYZP:Find('table/choiceDouble/doubleScore/SubtractButton')
	lyzpObj.ToggleMultiple2 = LYZP:Find('table/multiple/2')
	lyzpObj.ToggleMultiple3 = LYZP:Find('table/multiple/3')
	lyzpObj.ToggleMultiple4 = LYZP:Find('table/multiple/4')
	message:AddClick(lyzpObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(lyzpObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(lyzpObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(lyzpObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(lyzpObj.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(lyzpObj.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(lyzpObj.ToggleMultiple4.gameObject, this.OnClickMultiple)

	lyzpObj.ToggleSettlementScoreSelect=LYZP:Find('table/settlementScore/select')
	lyzpObj.ToggleFewerScoreTxt=LYZP:Find('table/settlementScore/fewerValue/Value')
	lyzpObj.ToggleFewerAddButton=LYZP:Find('table/settlementScore/fewerValue/AddButton')
	lyzpObj.ToggleFewerSubtractButton=LYZP:Find('table/settlementScore/fewerValue/SubtractButton')
	lyzpObj.ToggleAddScoreTxt=LYZP:Find('table/settlementScore/addValue/Value')
	lyzpObj.ToggleAddAddButton=LYZP:Find('table/settlementScore/addValue/AddButton')
	lyzpObj.ToggleAddSubtractButton=LYZP:Find('table/settlementScore/addValue/SubtractButton')
	message:AddClick(lyzpObj.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(lyzpObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(lyzpObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(lyzpObj.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(lyzpObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)
	
	lyzpObj.ToggleTrusteeshipNo = LYZP:Find('table/DelegateChoose/NoDelegate')
	lyzpObj.ToggleTrusteeship1 = LYZP:Find('table/DelegateChoose/Delegate1')
	lyzpObj.ToggleTrusteeship2 = LYZP:Find('table/DelegateChoose/Delegate2')
	lyzpObj.ToggleTrusteeship3 = LYZP:Find('table/DelegateChoose/Delegate3')
	lyzpObj.ToggleTrusteeship5 = LYZP:Find('table/DelegateChoose/Delegate5')
	lyzpObj.ToggleTrusteeshipAll = LYZP:Find('table/DelegateCancel/FullRound')
	lyzpObj.ToggleTrusteeshipOne = LYZP:Find('table/DelegateCancel/ThisRound')
	lyzpObj.ToggleTrusteeshipThree = LYZP:Find('table/DelegateCancel/ThreeRound')
	message:AddClick(lyzpObj.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(lyzpObj.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(lyzpObj.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(lyzpObj.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(lyzpObj.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(lyzpObj.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(lyzpObj.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(lyzpObj.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)

	lyzpObj.ToggleIPcheck = LYZP:Find('table/PreventCheat/IPcheck')
	lyzpObj.ToggleGPScheck = LYZP:Find('table/PreventCheat/GPScheck')
	message:AddClick(lyzpObj.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(lyzpObj.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end
function this.Refresh()
	print('Refresh_LYZP')
	lyzpData.rounds=UnityEngine.PlayerPrefs.GetInt('NewLYZProunds', 6)
	lyzpObj.ToggleRound6:GetComponent('UIToggle'):Set(lyzpData.rounds == 6)
	lyzpObj.ToggleRound8:GetComponent('UIToggle'):Set(lyzpData.rounds == 8)
	lyzpObj.ToggleRound10:GetComponent('UIToggle'):Set(lyzpData.rounds == 10)
	lyzpObj.ToggleRound16:GetComponent('UIToggle'):Set(lyzpData.rounds == 16)

	lyzpData.size=UnityEngine.PlayerPrefs.GetInt('NewLYZPsize', 2)
	lyzpObj.TogglePeopleNum2:GetComponent('UIToggle'):Set(lyzpData.size == 2)
	lyzpObj.TogglePeopleNum3:GetComponent('UIToggle'):Set(lyzpData.size == 3)
	
	lyzpData.paymentType=UnityEngine.PlayerPrefs.GetInt('NewLYZPpaymentType', 0)
	lyzpObj.ToggleMasterPay:GetComponent('UIToggle'):Set(lyzpData.paymentType == 0)
	lyzpObj.ToggleWinnerPay:GetComponent('UIToggle'):Set(lyzpData.paymentType == 2)
	
	lyzpData.randomBanker=UnityEngine.PlayerPrefs.GetInt('NewLYZPrandomBanker', 0)==1
	lyzpObj.ToggleRandomBanker:GetComponent('UIToggle'):Set(lyzpData.randomBanker)
	lyzpObj.ToggleBankerFrist:GetComponent('UIToggle'):Set(not lyzpData.randomBanker)

	lyzpData.choiceHu = UnityEngine.PlayerPrefs.GetInt('NewLYZPchoiceHu', 0)
	lyzpObj.ToggleChoiceHu:GetComponent('UIToggle'):Set(lyzpData.choiceHu == 2)
	
	lyzpData.maoHu = UnityEngine.PlayerPrefs.GetInt('NewLYZPmaoHu', 1)==1
	lyzpObj.ToggleMaoHu:GetComponent('UIToggle'):Set(not lyzpData.maoHu)

	lyzpData.yiDianHong = UnityEngine.PlayerPrefs.GetInt('NewLYZPyiDianHong', 1)==1
	lyzpObj.ToggleYiDianHong:GetComponent('UIToggle'):Set(not lyzpData.yiDianHong)

	lyzpData.chou = UnityEngine.PlayerPrefs.GetInt('NewLYZPchou', 0)
	lyzpObj.ToggleChou0:GetComponent('UIToggle'):Set(lyzpData.chou == 0)
	lyzpObj.ToggleChou10:GetComponent('UIToggle'):Set(lyzpData.chou == 10)
	lyzpObj.ToggleChou20:GetComponent('UIToggle'):Set(lyzpData.chou == 20)
	lyzpObj.ToggleChou0.parent.gameObject:SetActive(lyzpData.size == 2)

	lyzpData.tiAddScore = UnityEngine.PlayerPrefs.GetInt('NewLYZPtiAddScore', 2)
	lyzpObj.ToggleTiAddScore0:GetComponent('UIToggle'):Set(lyzpData.tiAddScore == 0)
	lyzpObj.ToggleTiAddScore1:GetComponent('UIToggle'):Set(lyzpData.tiAddScore == 1)
	lyzpObj.ToggleTiAddScore2:GetComponent('UIToggle'):Set(lyzpData.tiAddScore == 2)

	lyzpData.niao=UnityEngine.PlayerPrefs.GetInt('NewLYZPniao', 0)==1
	lyzpData.niaoValue=UnityEngine.PlayerPrefs.GetInt('NewLYZPniaoValue', 10)
	lyzpObj.ToggleOnNiao:GetComponent('UIToggle'):Set(lyzpData.niao)
	lyzpObj.ToggleOffNiao:GetComponent('UIToggle'):Set(not lyzpData.niao)
	lyzpObj.NiaoValueText.parent.gameObject:SetActive(lyzpData.niao)
    lyzpObj.NiaoValueText:GetComponent('UILabel').text = lyzpData.niaoValue.."分"

	lyzpData.choiceDouble=UnityEngine.PlayerPrefs.GetInt('NewLYZPchoiceDouble', 0)==1
	lyzpData.doubleScore=UnityEngine.PlayerPrefs.GetInt('NewLYZPdoubleScore', 10)
	lyzpData.multiple=UnityEngine.PlayerPrefs.GetInt('NewLYZPmultiple', 2)
	lyzpObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(lyzpData.choiceDouble)
	lyzpObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not lyzpData.choiceDouble)
	lyzpObj.DoubleScoreText.parent.gameObject:SetActive(lyzpData.choiceDouble)
	if lyzpData.doubleScore == 0 then
		lyzpObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		lyzpObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..lyzpData.doubleScore..'分'
	end
	lyzpObj.ToggleChoiceDouble.parent.gameObject:SetActive(lyzpData.size == 2)
	lyzpObj.ToggleMultiple2:GetComponent('UIToggle'):Set(lyzpData.multiple == 2)
	lyzpObj.ToggleMultiple3:GetComponent('UIToggle'):Set(lyzpData.multiple == 3)
	lyzpObj.ToggleMultiple4:GetComponent('UIToggle'):Set(lyzpData.multiple == 4)
	lyzpObj.ToggleMultiple2.parent.gameObject:SetActive(lyzpData.choiceDouble and  lyzpData.size == 2)

	lyzpData.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewLYZPisSettlementScore', 0)==1
	lyzpData.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewLYZPfewerValue', 10)
	lyzpData.addValue=UnityEngine.PlayerPrefs.GetInt('NewLYZPaddValue', 10)
	lyzpObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(lyzpData.size==2)
	lyzpObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(lyzpData.isSettlementScore)
	lyzpObj.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	lyzpObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = lyzpData.fewerValue
	lyzpObj.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	lyzpObj.ToggleAddScoreTxt:GetComponent('UILabel').text = lyzpData.addValue
	
	lyzpData.trusteeshipTime=UnityEngine.PlayerPrefs.GetInt('NewLYZPtrusteeshipTime', 0)
	lyzpData.trusteeshipType = UnityEngine.PlayerPrefs.GetInt('NewLYZPtrusteeshipType', 0) == 1
	lyzpData.trusteeshipRound = UnityEngine.PlayerPrefs.GetInt('NewLYZPtrusteeshipRound', 0)
	lyzpObj.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(lyzpData.trusteeshipTime == 0)
	lyzpObj.ToggleTrusteeship1:GetComponent('UIToggle'):Set(lyzpData.trusteeshipTime == 1)
	lyzpObj.ToggleTrusteeship2:GetComponent('UIToggle'):Set(lyzpData.trusteeshipTime == 2)
	lyzpObj.ToggleTrusteeship3:GetComponent('UIToggle'):Set(lyzpData.trusteeshipTime == 3)
	lyzpObj.ToggleTrusteeship5:GetComponent('UIToggle'):Set(lyzpData.trusteeshipTime == 5)
	lyzpObj.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(lyzpData.trusteeshipType)
	lyzpObj.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not lyzpData.trusteeshipType and lyzpData.trusteeshipRound == 0)
	lyzpObj.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(lyzpData.trusteeshipRound == 3)
	lyzpObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(lyzpData.trusteeshipTime ~= 0)

	lyzpData.openIp=UnityEngine.PlayerPrefs.GetInt('LYZPcheckIP', 0)==1
	lyzpData.openGps=UnityEngine.PlayerPrefs.GetInt('LYZPcheckGPS', 0)==1
	lyzpObj.ToggleIPcheck:GetComponent('UIToggle'):Set(lyzpData.openIp)
	lyzpObj.ToggleGPScheck:GetComponent('UIToggle'):Set(lyzpData.openGps)
	lyzpObj.ToggleIPcheck.parent.gameObject:SetActive(lyzpData.size > 2 and CONST.IPcheckOn)
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.LYZP,lyzpData.rounds,nil,nil)
	LYZP:Find('table'):GetComponent('UIGrid'):Reposition()
end
--获取当前设置
function this.GetConfig()
	local moneyLess = false
	if ((lyzpData.rounds == 6 or lyzpData.rounds == 8 or lyzpData.rounds == 10) and info_login.balance < 2) or
        (lyzpData.rounds == 16 and info_login.balance < 3) then
        moneyLess = true
    end
    local body = {}
    body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.LYZP)
	body.rounds = lyzpData.rounds
    body.size = lyzpData.size
    body.paymentType = lyzpData.paymentType
    body.randomBanker = lyzpData.randomBanker
    body.trusteeship = lyzpData.trusteeshipTime*60;
    body.trusteeshipDissolve = lyzpData.trusteeshipType;
    body.trusteeshipRound = lyzpData.trusteeshipRound;

	body.niao = lyzpData.niao
	body.niaoValue =  lyzpData.niao and lyzpData.niaoValue or 0
	
	if lyzpData.size == 2 then
		body.resultScore = lyzpData.isSettlementScore
		if lyzpData.isSettlementScore then
			body.resultLowerScore=lyzpData.fewerValue
			body.resultAddScore=lyzpData.addValue
		end
		body.choiceDouble = lyzpData.choiceDouble
        body.doubleScore = lyzpData.doubleScore
        body.multiple = lyzpData.multiple
		lyzpData.openIp=false
		lyzpData.openGps=false
	end
	body.choiceHu = lyzpData.choiceHu
	body.maoHu = not lyzpObj.ToggleMaoHu:GetComponent('UIToggle').value
	body.yiDianHong = not lyzpObj.ToggleYiDianHong:GetComponent('UIToggle').value
	body.chou = lyzpData.size == 2 and lyzpData.chou or 0
	body.tiAddScore = lyzpData.tiAddScore
	body.fanXing = false
	body.qiHuHuXi = 10
	body.openIp	 = lyzpData.openIp
	body.openGps = lyzpData.openGps
    return moneyLess,body;
end

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
    if lyzpObj.ToggleRound6.gameObject == go then
        lyzpData.rounds = 6
	elseif lyzpObj.ToggleRound8.gameObject == go then
        lyzpData.rounds = 8
    elseif lyzpObj.ToggleRound10.gameObject == go then
        lyzpData.rounds = 10
    else
        lyzpData.rounds = 16
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.LYZP,lyzpData.rounds,nil,nil)
    UnityEngine.PlayerPrefs.SetInt('NewLYZProunds', lyzpData.rounds)
end

function this.OnClickTogglePlayerNum(go)
	AudioManager.Instance:PlayAudio('btn')
    if lyzpObj.TogglePeopleNum2.gameObject == go then
        lyzpData.size = 2
    elseif lyzpObj.TogglePeopleNum3.gameObject == go then
        lyzpData.size = 3
    end
	lyzpObj.ToggleIPcheck.parent.gameObject:SetActive(lyzpData.size > 2 and CONST.IPcheckOn)
	UnityEngine.PlayerPrefs.SetInt('NewLYZPsize', lyzpData.size)
	lyzpObj.ToggleChou0.parent.gameObject:SetActive(lyzpData.size == 2)
	lyzpObj.ToggleNoChoiceDouble.parent.gameObject:SetActive(lyzpData.size==2)
	lyzpObj.ToggleMultiple2.parent.gameObject:SetActive(lyzpData.choiceDouble and  lyzpData.size == 2)
	lyzpObj.DoubleScoreText.parent.gameObject:SetActive(lyzpData.choiceDouble)
	lyzpObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(lyzpData.size==2)
    LYZP:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if lyzpObj.ToggleMasterPay.gameObject == go then
        lyzpData.paymentType=0
    elseif lyzpObj.ToggleWinnerPay.gameObject == go then
        lyzpData.paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewLYZPpaymentType', lyzpData.paymentType)
end

function this.OnClickRandomBanker(go)
    AudioManager.Instance:PlayAudio('btn')
    if lyzpObj.ToggleRandomBanker.gameObject == go then
        lyzpData.randomBanker = true
    elseif lyzpObj.ToggleBankerFrist.gameObject == go then
        lyzpData.randomBanker = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewLYZPrandomBanker', lyzpData.randomBanker and 1 or 0)
end

function this.OnClickNiao(go)
	AudioManager.Instance:PlayAudio('btn')
	if lyzpObj.ToggleOnNiao.gameObject == go then
		lyzpData.niao = true
	elseif lyzpObj.ToggleOffNiao.gameObject == go then
		lyzpData.niao = false
	end
	lyzpObj.NiaoValueText.parent.gameObject:SetActive(lyzpData.niao)
	UnityEngine.PlayerPrefs.SetInt('NewLYZPniao', lyzpData.niao and 1 or 0)
	
end

function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if lyzpObj.AddButtonNiao.gameObject == go then
		lyzpData.niaoValue = lyzpData.niaoValue + 10
		if lyzpData.niaoValue > 100 then
			lyzpData.niaoValue = 100
		end
	elseif lyzpObj.SubtractButtonNiao.gameObject == go then
		lyzpData.niaoValue = lyzpData.niaoValue - 10
		if lyzpData.niaoValue < 10 then
			lyzpData.niaoValue = 10
		end
	end
	lyzpObj.NiaoValueText:GetComponent('UILabel').text = lyzpData.niaoValue.."分"
	UnityEngine.PlayerPrefs.SetInt('NewLYZPniaoValue', lyzpData.niaoValue)
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if lyzpObj.ToggleTrusteeshipNo.gameObject == go then
        lyzpData.trusteeshipTime = 0
    elseif lyzpObj.ToggleTrusteeship1.gameObject == go then
        lyzpData.trusteeshipTime = 1
	elseif lyzpObj.ToggleTrusteeship2.gameObject == go then
		lyzpData.trusteeshipTime = 2
    elseif lyzpObj.ToggleTrusteeship3.gameObject == go then
        lyzpData.trusteeshipTime = 3
    elseif lyzpObj.ToggleTrusteeship5.gameObject == go then
        lyzpData.trusteeshipTime = 5
	end
    UnityEngine.PlayerPrefs.SetInt('NewLYZPtrusteeshipTime', lyzpData.trusteeshipTime)
	lyzpObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(lyzpData.trusteeshipTime ~= 0)
	LYZP:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if lyzpObj.ToggleTrusteeshipOne.gameObject == go then
        lyzpData.trusteeshipType = true
		lyzpData.trusteeshipRound = 0;
    elseif lyzpObj.ToggleTrusteeshipAll.gameObject == go then
        lyzpData.trusteeshipType = false
		lyzpData.trusteeshipRound = 0;
	elseif lyzpObj.ToggleTrusteeshipThree.gameObject == go then
		lyzpData.trusteeshipType = false;
		lyzpData.trusteeshipRound = 3;
    end
    UnityEngine.PlayerPrefs.SetInt('NewLYZPtrusteeshipType',lyzpData.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewLYZPtrusteeshipRound',lyzpData.trusteeshipRound )
end
function this.OnClickToggleChoiceHu(go)
	AudioManager.Instance:PlayAudio('btn')
	if lyzpObj.ToggleChoiceHu:GetComponent('UIToggle').value then
		lyzpData.choiceHu = 2
	else
		lyzpData.choiceHu = 0
	end
	UnityEngine.PlayerPrefs.SetInt('NewLYZPchoiceHu', lyzpData.choiceHu)
end

function this.OnClickToggleMaoHu(go)
	AudioManager.Instance:PlayAudio('btn')
	lyzpData.maoHu = lyzpObj.ToggleMaoHu:GetComponent('UIToggle').value
	UnityEngine.PlayerPrefs.SetInt('NewLYZPmaoHu', lyzpData.maoHu and 1 or 0)
end
function this.OnClickToggleYiDianHong(go)
	AudioManager.Instance:PlayAudio('btn')
	lyzpData.yiDianHong = lyzpObj.ToggleYiDianHong:GetComponent('UIToggle').value
	UnityEngine.PlayerPrefs.SetInt('NewLYZPyiDianHong', lyzpData.yiDianHong and 1 or 0)
end

function this.OnClickToggleChou(go)
	AudioManager.Instance:PlayAudio('btn')
	if lyzpObj.ToggleChou0.gameObject == go then
        lyzpData.chou=0
    elseif lyzpObj.ToggleChou10.gameObject == go then
        lyzpData.chou=10
    elseif lyzpObj.ToggleChou20.gameObject == go then
        lyzpData.chou=20
	end
	UnityEngine.PlayerPrefs.SetInt('NewLYZPchou', lyzpData.chou)
end

function this.OnClickToggleTiAddScore(go)
	AudioManager.Instance:PlayAudio('btn')
	if lyzpObj.ToggleTiAddScore0.gameObject == go then
        lyzpData.tiAddScore=0
    elseif lyzpObj.ToggleTiAddScore1.gameObject == go then
        lyzpData.tiAddScore=1
    elseif lyzpObj.ToggleTiAddScore2.gameObject == go then
        lyzpData.tiAddScore=2
	end
	UnityEngine.PlayerPrefs.SetInt('NewLYZPtiAddScore', lyzpData.tiAddScore)
end

function this.OnClickChoiceDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if lyzpObj.ToggleChoiceDouble.gameObject == go then
        lyzpData.choiceDouble = true
    elseif lyzpObj.ToggleNoChoiceDouble.gameObject == go then
        lyzpData.choiceDouble = false
    end
    lyzpObj.DoubleScoreText.parent.gameObject:SetActive(lyzpData.choiceDouble)
    lyzpObj.ToggleMultiple2.parent.gameObject:SetActive(lyzpData.choiceDouble)
    LYZP:Find('table'):GetComponent('UIGrid'):Reposition()
    UnityEngine.PlayerPrefs.SetInt('NewLYZPchoiceDouble', lyzpData.choiceDouble and 1 or 0)
end

function this.OnClickChangeDoubleScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if lyzpObj.AddDoubleScoreButton.gameObject == go then
        if lyzpData.doubleScore ~= 0 then
            lyzpData.doubleScore = lyzpData.doubleScore + 1
            if lyzpData.doubleScore > 100 then
                lyzpData.doubleScore = 0
            end
        end
    else
        if lyzpData.doubleScore == 0 then
            lyzpData.doubleScore = 100
        else
            lyzpData.doubleScore = lyzpData.doubleScore - 1
            if lyzpData.doubleScore < 1 then
                lyzpData.doubleScore = 1
            end
        end
    end
    if lyzpData.doubleScore == 0 then
        lyzpObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
    else
        lyzpObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..lyzpData.doubleScore..'分'
    end
    UnityEngine.PlayerPrefs.SetInt('NewLYZPdoubleScore', lyzpData.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
    if lyzpObj.ToggleMultiple2.gameObject == go then
        lyzpData.multiple=2
    elseif lyzpObj.ToggleMultiple3.gameObject == go then
        lyzpData.multiple=3
    elseif lyzpObj.ToggleMultiple4.gameObject == go then
        lyzpData.multiple=4
    end
    UnityEngine.PlayerPrefs.SetInt('NewLYZPmultiple', lyzpData.multiple)
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    lyzpData.isSettlementScore= lyzpObj.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewLYZPisSettlementScore', lyzpData.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if lyzpObj.ToggleFewerAddButton.gameObject == go then
		lyzpData.fewerValue = lyzpData.fewerValue + 1
		if lyzpData.fewerValue > 100 then
			lyzpData.fewerValue = 100
		end
    elseif lyzpObj.ToggleFewerSubtractButton.gameObject == go then
		lyzpData.fewerValue = lyzpData.fewerValue - 1
		if lyzpData.fewerValue < 1 then
			lyzpData.fewerValue = 1
		end
	end
	lyzpObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = lyzpData.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewLYZPfewerValue', lyzpData.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if lyzpObj.ToggleAddAddButton.gameObject == go then
		lyzpData.addValue = lyzpData.addValue + 1
		if lyzpData.addValue > 100 then
			lyzpData.addValue = 100
		end
    elseif lyzpObj.ToggleAddSubtractButton.gameObject == go then
		lyzpData.addValue = lyzpData.addValue - 1
		if lyzpData.addValue < 1 then
			lyzpData.addValue = 1
		end
	end
	lyzpObj.ToggleAddScoreTxt:GetComponent('UILabel').text = lyzpData.addValue
	UnityEngine.PlayerPrefs.SetInt('NewLYZPaddValue', lyzpData.addValue)
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if lyzpObj.ToggleIPcheck.gameObject == go then
		lyzpData.openIp = lyzpObj.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('LYZPcheckIP', lyzpData.openIp and 1 or 0)
	elseif lyzpObj.ToggleGPScheck.gameObject == go then
		lyzpData.openGps = lyzpObj.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('LYZPcheckGPS', lyzpData.openGps and 1 or 0)
	end
end

return this