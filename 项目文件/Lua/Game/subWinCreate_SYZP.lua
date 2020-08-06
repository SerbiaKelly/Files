local this = {}

local SYZP
local payLabel

local syzpObj = {}
local syzpData = {}

function this.Init(grid,message)
	print('Init_SYZP')
	SYZP = grid
	payLabel = message.transform:Find('diamond/pay_label')

	syzpObj.ToggleRound1 = SYZP:Find('table/round/grid/round1')
	syzpObj.ToggleRound6 = SYZP:Find('table/round/grid/round6')
	syzpObj.ToggleRound8 = SYZP:Find('table/round/grid/round8')
	syzpObj.ToggleRound10 = SYZP:Find('table/round/grid/round10')
	syzpObj.ToggleRound16 = SYZP:Find('table/round/grid/round16')
	message:AddClick(syzpObj.ToggleRound1.gameObject, this.OnClickToggleRound)
	message:AddClick(syzpObj.ToggleRound6.gameObject, this.OnClickToggleRound)
	message:AddClick(syzpObj.ToggleRound8.gameObject, this.OnClickToggleRound)
	message:AddClick(syzpObj.ToggleRound10.gameObject, this.OnClickToggleRound)
	message:AddClick(syzpObj.ToggleRound16.gameObject, this.OnClickToggleRound)

	syzpObj.TogglePeopleNum2 = SYZP:Find('table/num/num2')
	syzpObj.TogglePeopleNum3 = SYZP:Find('table/num/num3')
	message:AddClick(syzpObj.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(syzpObj.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)

	syzpObj.ToggleMasterPay = SYZP:Find('table/pay/master')
	syzpObj.ToggleWinnerPay = SYZP:Find('table/pay/win')
	message:AddClick(syzpObj.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(syzpObj.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)

	syzpObj.ToggleRandomBanker = SYZP:Find('table/randomBanker/Auto')
	syzpObj.ToggleBankerFrist = SYZP:Find('table/randomBanker/Frist')
	message:AddClick(syzpObj.ToggleRandomBanker.gameObject, this.OnClickRandomBanker)
	message:AddClick(syzpObj.ToggleBankerFrist.gameObject, this.OnClickRandomBanker)
	
	syzpObj.ToggleQiHu10 = SYZP:Find('table/hu/hu10')
	syzpObj.ToggleQiHu15 = SYZP:Find('table/hu/hu15')
	message:AddClick(syzpObj.ToggleQiHu10.gameObject, this.OnClickToggleHuMinNum)
	message:AddClick(syzpObj.ToggleQiHu15.gameObject, this.OnClickToggleHuMinNum)

	syzpObj.ToggleHuStep5 = SYZP:Find('table/hustep/step5')
	syzpObj.ToggleHuStep3 = SYZP:Find('table/hustep/step3')
	syzpObj.ToggleHuStep1 = SYZP:Find('table/hustep/step1')
	message:AddClick(syzpObj.ToggleHuStep5.gameObject, this.OnClickToggleHuStep)
	message:AddClick(syzpObj.ToggleHuStep3.gameObject, this.OnClickToggleHuStep)
	message:AddClick(syzpObj.ToggleHuStep1.gameObject, this.OnClickToggleHuStep)

	syzpObj.AddBtnDiFen = SYZP:Find('table/diFen/diFenScore/AddButton')
	syzpObj.SubtractBtnDiFen = SYZP:Find('table/diFen/diFenScore/SubtractButton')
	syzpObj.DiFenTunValue = SYZP:Find('table/diFen/diFenScore/Value')
	message:AddClick(syzpObj.AddBtnDiFen.gameObject, this.OnClickChangeDiFenValue)
	message:AddClick(syzpObj.SubtractBtnDiFen.gameObject, this.OnClickChangeDiFenValue)

	syzpObj.ToggleTian = SYZP:Find('table/hutype/tian')
	syzpObj.ToggleHong = SYZP:Find('table/hutype/hong')
	syzpObj.ToggleZiMo10Hu = SYZP:Find('table/hutype/zimo10hu')
	message:AddClick(syzpObj.ToggleTian.gameObject, this.OnClickToggleHuType)
	message:AddClick(syzpObj.ToggleHong.gameObject, this.OnClickToggleHuType)
	message:AddClick(syzpObj.ToggleZiMo10Hu.gameObject, this.OnClickToggleHuType)

	syzpObj.ToggleChou0 = SYZP:Find('table/chouCard/chouCard0')
	syzpObj.ToggleChou10 = SYZP:Find('table/chouCard/chouCard10')
	syzpObj.ToggleChou20 = SYZP:Find('table/chouCard/chouCard20')
	message:AddClick(syzpObj.ToggleChou0.gameObject, this.OnClickToggleChou)
	message:AddClick(syzpObj.ToggleChou10.gameObject, this.OnClickToggleChou)
	message:AddClick(syzpObj.ToggleChou20.gameObject, this.OnClickToggleChou)

	syzpObj.ToggleOnNiao = SYZP:Find('table/niao/OnNiao')
	syzpObj.ToggleOffNiao = SYZP:Find('table/niao/OffNiao')
	syzpObj.NiaoValueText = SYZP:Find('table/niao/NiaoValue/Value')
	syzpObj.AddButtonNiao = SYZP:Find('table/niao/NiaoValue/AddButton')
	syzpObj.SubtractButtonNiao = SYZP:Find('table/niao/NiaoValue/SubtractButton')
	message:AddClick(syzpObj.ToggleOnNiao.gameObject, this.OnClickNiao)
	message:AddClick(syzpObj.ToggleOffNiao.gameObject, this.OnClickNiao)
	message:AddClick(syzpObj.AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(syzpObj.SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)

	syzpObj.ToggleChoiceDouble = SYZP:Find('table/choiceDouble/On')
	syzpObj.ToggleNoChoiceDouble = SYZP:Find('table/choiceDouble/Off')
	syzpObj.DoubleScoreText = SYZP:Find('table/choiceDouble/doubleScore/Value')
	syzpObj.AddDoubleScoreButton = SYZP:Find('table/choiceDouble/doubleScore/AddButton')
	syzpObj.SubtractDoubleScoreButton = SYZP:Find('table/choiceDouble/doubleScore/SubtractButton')
	syzpObj.ToggleMultiple2 = SYZP:Find('table/multiple/2')
	syzpObj.ToggleMultiple3 = SYZP:Find('table/multiple/3')
	syzpObj.ToggleMultiple4 = SYZP:Find('table/multiple/4')
	message:AddClick(syzpObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(syzpObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(syzpObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(syzpObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(syzpObj.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(syzpObj.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(syzpObj.ToggleMultiple4.gameObject, this.OnClickMultiple)
	
	syzpObj.ToggleSettlementScoreSelect=SYZP:Find('table/settlementScore/select')
	syzpObj.ToggleFewerScoreTxt=SYZP:Find('table/settlementScore/fewerValue/Value')
	syzpObj.ToggleFewerAddButton=SYZP:Find('table/settlementScore/fewerValue/AddButton')
	syzpObj.ToggleFewerSubtractButton=SYZP:Find('table/settlementScore/fewerValue/SubtractButton')
	syzpObj.ToggleAddScoreTxt=SYZP:Find('table/settlementScore/addValue/Value')
	syzpObj.ToggleAddAddButton=SYZP:Find('table/settlementScore/addValue/AddButton')
	syzpObj.ToggleAddSubtractButton=SYZP:Find('table/settlementScore/addValue/SubtractButton')
	message:AddClick(syzpObj.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(syzpObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(syzpObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(syzpObj.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(syzpObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)
	
	syzpObj.ToggleTrusteeshipNo = SYZP:Find('table/DelegateChoose/NoDelegate')
	syzpObj.ToggleTrusteeship1 = SYZP:Find('table/DelegateChoose/Delegate1')
	syzpObj.ToggleTrusteeship2 = SYZP:Find('table/DelegateChoose/Delegate2')
	syzpObj.ToggleTrusteeship3 = SYZP:Find('table/DelegateChoose/Delegate3')
	syzpObj.ToggleTrusteeship5 = SYZP:Find('table/DelegateChoose/Delegate5')
	syzpObj.ToggleTrusteeshipAll = SYZP:Find('table/DelegateCancel/FullRound')
	syzpObj.ToggleTrusteeshipOne = SYZP:Find('table/DelegateCancel/ThisRound')
	syzpObj.ToggleTrusteeshipThree = SYZP:Find('table/DelegateCancel/ThreeRound')
	message:AddClick(syzpObj.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(syzpObj.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(syzpObj.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(syzpObj.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(syzpObj.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(syzpObj.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(syzpObj.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(syzpObj.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)

	syzpObj.ToggleIPcheck = SYZP:Find('table/PreventCheat/IPcheck')
	syzpObj.ToggleGPScheck = SYZP:Find('table/PreventCheat/GPScheck')
	message:AddClick(syzpObj.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(syzpObj.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end
function this.Refresh()
	print('Refresh_SYZP')
	syzpData.rounds=UnityEngine.PlayerPrefs.GetInt('NewSYZProunds', 6)
	syzpObj.ToggleRound1:GetComponent('UIToggle'):Set(syzpData.rounds == 1)
	syzpObj.ToggleRound6:GetComponent('UIToggle'):Set(syzpData.rounds == 6)
	syzpObj.ToggleRound8:GetComponent('UIToggle'):Set(syzpData.rounds == 8)
	syzpObj.ToggleRound10:GetComponent('UIToggle'):Set(syzpData.rounds == 10)
	syzpObj.ToggleRound16:GetComponent('UIToggle'):Set(syzpData.rounds == 16)

	syzpData.size=UnityEngine.PlayerPrefs.GetInt('NewSYZPsize', 2)
	syzpObj.TogglePeopleNum2:GetComponent('UIToggle'):Set(syzpData.size == 2)
	syzpObj.TogglePeopleNum3:GetComponent('UIToggle'):Set(syzpData.size == 3)
	
	syzpData.paymentType=UnityEngine.PlayerPrefs.GetInt('NewSYZPpaymentType', 0)
	syzpObj.ToggleMasterPay:GetComponent('UIToggle'):Set(syzpData.paymentType == 0)
	syzpObj.ToggleWinnerPay:GetComponent('UIToggle'):Set(syzpData.paymentType == 2)

	syzpData.randomBanker=UnityEngine.PlayerPrefs.GetInt('NewSYZPrandomBanker', 0)==1
	syzpObj.ToggleRandomBanker:GetComponent('UIToggle'):Set(syzpData.randomBanker)
	syzpObj.ToggleBankerFrist:GetComponent('UIToggle'):Set(not syzpData.randomBanker)

	syzpData.huMinNum=UnityEngine.PlayerPrefs.GetInt('NewSYZPhuMinNum', 10)
	syzpObj.ToggleQiHu10:GetComponent('UIToggle'):Set(syzpData.huMinNum == 10)
	syzpObj.ToggleQiHu15:GetComponent('UIToggle'):Set(syzpData.huMinNum == 15)

	syzpData.huStepNum=UnityEngine.PlayerPrefs.GetInt('NewSYZPhuStepNum', 5)
	syzpObj.ToggleHuStep5:GetComponent('UIToggle'):Set(syzpData.huStepNum == 5)
	syzpObj.ToggleHuStep3:GetComponent('UIToggle'):Set(syzpData.huStepNum == 3)
	syzpObj.ToggleHuStep1:GetComponent('UIToggle'):Set(syzpData.huStepNum == 1)

	syzpData.bottomScore=UnityEngine.PlayerPrefs.GetInt('NewSYZPbottomScore', 1)
	syzpObj.DiFenTunValue:GetComponent("UILabel").text = syzpData.bottomScore..'分'

	syzpData.tianHu=UnityEngine.PlayerPrefs.GetInt('NewSYZPtianHu', 0)==1
	syzpData.hongHu=UnityEngine.PlayerPrefs.GetInt('NewSYZPhongHu', 0)==1
	syzpData.ziMoAddHu=UnityEngine.PlayerPrefs.GetInt('NewSYZPziMoAddHu', 0)
	syzpObj.ToggleTian:GetComponent('UIToggle'):Set(syzpData.tianHu)
	syzpObj.ToggleHong:GetComponent('UIToggle'):Set(syzpData.hongHu)
	syzpObj.ToggleZiMo10Hu:GetComponent('UIToggle'):Set(syzpData.ziMoAddHu == 10)
	
	syzpData.chou = UnityEngine.PlayerPrefs.GetInt('NewSYZPchou', 20)
	syzpObj.ToggleChou0:GetComponent('UIToggle'):Set(syzpData.chou == 0)
	syzpObj.ToggleChou10:GetComponent('UIToggle'):Set(syzpData.chou == 10)
	syzpObj.ToggleChou20:GetComponent('UIToggle'):Set(syzpData.chou == 20)
	syzpObj.ToggleChou0.parent.gameObject:SetActive(syzpData.size == 2)

	syzpData.niao=UnityEngine.PlayerPrefs.GetInt('NewSYZPniao', 0)==1
	syzpData.niaoValue=UnityEngine.PlayerPrefs.GetInt('NewSYZPniaoValue', 10)
	syzpObj.ToggleOnNiao:GetComponent('UIToggle'):Set(syzpData.niao)
	syzpObj.ToggleOffNiao:GetComponent('UIToggle'):Set(not syzpData.niao)
	syzpObj.NiaoValueText.parent.gameObject:SetActive(syzpData.niao)
    syzpObj.NiaoValueText:GetComponent('UILabel').text = syzpData.niaoValue.."分"

	syzpData.choiceDouble=UnityEngine.PlayerPrefs.GetInt('NewSYZPchoiceDouble', 0)==1
	syzpData.doubleScore=UnityEngine.PlayerPrefs.GetInt('NewSYZPdoubleScore', 10)
	syzpData.multiple=UnityEngine.PlayerPrefs.GetInt('NewSYZPmultiple', 2)
	syzpObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(syzpData.choiceDouble)
	syzpObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not syzpData.choiceDouble)
	syzpObj.DoubleScoreText.parent.gameObject:SetActive(syzpData.choiceDouble)
	if syzpData.doubleScore == 0 then
		syzpObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		syzpObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..syzpData.doubleScore..'分'
	end
	syzpObj.ToggleChoiceDouble.parent.gameObject:SetActive(syzpData.size == 2)
	syzpObj.ToggleMultiple2:GetComponent('UIToggle'):Set(syzpData.multiple == 2)
	syzpObj.ToggleMultiple3:GetComponent('UIToggle'):Set(syzpData.multiple == 3)
	syzpObj.ToggleMultiple4:GetComponent('UIToggle'):Set(syzpData.multiple == 4)
	syzpObj.ToggleMultiple2.parent.gameObject:SetActive(syzpData.choiceDouble and  syzpData.size == 2)

	syzpData.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewSYZPisSettlementScore', 0)==1
	syzpData.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewSYZPfewerValue', 10)
	syzpData.addValue=UnityEngine.PlayerPrefs.GetInt('NewSYZPaddValue', 10)
	syzpObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(syzpData.size==2)
	syzpObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(syzpData.isSettlementScore)
	syzpObj.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	syzpObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = syzpData.fewerValue
	syzpObj.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	syzpObj.ToggleAddScoreTxt:GetComponent('UILabel').text = syzpData.addValue

	syzpData.trusteeshipTime=UnityEngine.PlayerPrefs.GetInt('NewSYZPtrusteeshipTime', 0)
	syzpData.trusteeshipType = UnityEngine.PlayerPrefs.GetInt('NewSYZPtrusteeshipType', 0) == 1
	syzpData.trusteeshipRound = UnityEngine.PlayerPrefs.GetInt('NewSYZPtrusteeshipRound', 0)
	syzpObj.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(syzpData.trusteeshipTime == 0)
	syzpObj.ToggleTrusteeship1:GetComponent('UIToggle'):Set(syzpData.trusteeshipTime == 1)
	syzpObj.ToggleTrusteeship2:GetComponent('UIToggle'):Set(syzpData.trusteeshipTime == 2)
	syzpObj.ToggleTrusteeship3:GetComponent('UIToggle'):Set(syzpData.trusteeshipTime == 3)
	syzpObj.ToggleTrusteeship5:GetComponent('UIToggle'):Set(syzpData.trusteeshipTime == 5)
	syzpObj.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(syzpData.trusteeshipType)
	syzpObj.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not syzpData.trusteeshipType and syzpData.trusteeshipRound == 0)
	syzpObj.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(syzpData.trusteeshipRound == 3);
	syzpObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(syzpData.trusteeshipTime ~= 0)

	syzpData.openIp=UnityEngine.PlayerPrefs.GetInt('SYZPcheckIP', 0)==1
	syzpData.openGps=UnityEngine.PlayerPrefs.GetInt('SYZPcheckGPS', 0)==1
	syzpObj.ToggleIPcheck.parent.gameObject:SetActive(syzpData.size > 2 and CONST.IPcheckOn)
	syzpObj.ToggleIPcheck:GetComponent('UIToggle'):Set(syzpData.openIp)
	syzpObj.ToggleGPScheck:GetComponent('UIToggle'):Set(syzpData.openGps)

	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.SYZP,syzpData.rounds,nil,nil)
	SYZP:Find('table'):GetComponent('UIGrid'):Reposition()
end
--获取当前设置
function this.GetConfig()
	local moneyLess = false
	if ((syzpData.rounds == 6 or syzpData.rounds == 8) and info_login.balance < 2) or
        (syzpData.rounds == 10 and info_login.balance < 3)  or 
        (syzpData.rounds == 16 and info_login.balance < 5) then
        moneyLess = true
    end
    local body = {}
    body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.SYZP)
	body.rounds = syzpData.rounds
    body.size = syzpData.size
    body.paymentType = syzpData.paymentType
    body.randomBanker = syzpData.randomBanker
    body.trusteeship = syzpData.trusteeshipTime*60
    body.trusteeshipDissolve = syzpData.trusteeshipType
    body.trusteeshipRound = syzpData.trusteeshipRound
	body.bottomScore = syzpData.bottomScore
	body.niao = syzpData.niao
	body.niaoValue =  syzpData.niao and syzpData.niaoValue or 0
	body.ziMoAddHu = syzpData.ziMoAddHu
	if syzpData.size == 2 then
		body.resultScore = syzpData.isSettlementScore
		if syzpData.isSettlementScore then
			body.resultLowerScore=syzpData.fewerValue
			body.resultAddScore=syzpData.addValue
		end
		body.choiceDouble = syzpData.choiceDouble
        body.doubleScore = syzpData.doubleScore
        body.multiple = syzpData.multiple
		syzpData.openIp=false
		syzpData.openGps=false
	end
	body.chou = syzpData.size == 2 and syzpData.chou or 0
    body.qiHuHuXi = syzpData.huMinNum
    body.tunXi = syzpData.huStepNum
    body.fanXing = false
    body.tianDiHu = syzpData.tianHu
    body.heiHongHu = syzpData.hongHu
	body.openIp	 = syzpData.openIp
	body.openGps = syzpData.openGps
    return moneyLess,body;
end

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
    if syzpObj.ToggleRound1.gameObject == go then
		syzpData.rounds = 1
	elseif syzpObj.ToggleRound6.gameObject == go then
        syzpData.rounds = 6
	elseif syzpObj.ToggleRound8.gameObject == go then
        syzpData.rounds = 8
    elseif syzpObj.ToggleRound10.gameObject == go then
        syzpData.rounds = 10
    else
        syzpData.rounds = 16
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.SYZP,syzpData.rounds,nil,nil)
    UnityEngine.PlayerPrefs.SetInt('NewSYZProunds', syzpData.rounds)
end

function this.OnClickTogglePlayerNum(go)
	AudioManager.Instance:PlayAudio('btn')
    if syzpObj.TogglePeopleNum2.gameObject == go then
        syzpData.size = 2
    elseif syzpObj.TogglePeopleNum3.gameObject == go then
        syzpData.size = 3
    end
	syzpObj.ToggleIPcheck.parent.gameObject:SetActive(syzpData.size > 2 and CONST.IPcheckOn)
	UnityEngine.PlayerPrefs.SetInt('NewSYZPsize', syzpData.size)
	syzpObj.ToggleNoChoiceDouble.parent.gameObject:SetActive(syzpData.size==2)
    syzpObj.ToggleMultiple2.parent.gameObject:SetActive(syzpData.choiceDouble and syzpData.size==2)
	syzpObj.DoubleScoreText.parent.gameObject:SetActive(syzpData.choiceDouble)
	syzpObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(syzpData.size==2)
	syzpObj.ToggleChou0.parent.gameObject:SetActive(syzpData.size == 2)

    SYZP:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if syzpObj.ToggleMasterPay.gameObject == go then
        syzpData.paymentType=0
    elseif syzpObj.ToggleWinnerPay.gameObject == go then
        syzpData.paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewSYZPpaymentType', syzpData.paymentType)
end

function this.OnClickRandomBanker(go)
    AudioManager.Instance:PlayAudio('btn')
    if syzpObj.ToggleRandomBanker.gameObject == go then
        syzpData.randomBanker = true
    elseif syzpObj.ToggleBankerFrist.gameObject == go then
        syzpData.randomBanker = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewSYZPrandomBanker', syzpData.randomBanker and 1 or 0)
end

function this.OnClickChangeDiFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if syzpObj.AddBtnDiFen.gameObject == go then
		syzpData.bottomScore = syzpData.bottomScore + 1
		if syzpData.bottomScore > 10 then
			syzpData.bottomScore = 10
		end
    elseif syzpObj.SubtractBtnDiFen.gameObject == go then
        syzpData.bottomScore = syzpData.bottomScore - 1
		if syzpData.bottomScore < 1 then
			syzpData.bottomScore = 1
		end
	end
	syzpObj.DiFenTunValue:GetComponent("UILabel").text = syzpData.bottomScore..'分'
    UnityEngine.PlayerPrefs.SetInt('NewSYZPbottomScore', syzpData.bottomScore)
end

function this.OnClickNiao(go)
	AudioManager.Instance:PlayAudio('btn')
	if syzpObj.ToggleOnNiao.gameObject == go then
		syzpData.niao = true
	elseif syzpObj.ToggleOffNiao.gameObject == go then
		syzpData.niao = false
	end
	syzpObj.NiaoValueText.parent.gameObject:SetActive(syzpData.niao)
	UnityEngine.PlayerPrefs.SetInt('NewSYZPniao', syzpData.niao and 1 or 0)
	
end

function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if syzpObj.AddButtonNiao.gameObject == go then
		syzpData.niaoValue = syzpData.niaoValue + 10
		if syzpData.niaoValue > 100 then
			syzpData.niaoValue = 100
		end
	elseif syzpObj.SubtractButtonNiao.gameObject == go then
		syzpData.niaoValue = syzpData.niaoValue - 10
		if syzpData.niaoValue < 10 then
			syzpData.niaoValue = 10
		end
	end
	syzpObj.NiaoValueText:GetComponent('UILabel').text = syzpData.niaoValue.."分"
	UnityEngine.PlayerPrefs.SetInt('NewSYZPniaoValue', syzpData.niaoValue)
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if syzpObj.ToggleTrusteeshipNo.gameObject == go then
        syzpData.trusteeshipTime = 0
    elseif syzpObj.ToggleTrusteeship1.gameObject == go then
        syzpData.trusteeshipTime = 1
	elseif syzpObj.ToggleTrusteeship2.gameObject then
		syzpData.trusteeshipTime = 2;
    elseif syzpObj.ToggleTrusteeship3.gameObject == go then
        syzpData.trusteeshipTime = 3
    elseif syzpObj.ToggleTrusteeship5.gameObject == go then
        syzpData.trusteeshipTime = 5
    end
    UnityEngine.PlayerPrefs.SetInt('NewSYZPtrusteeshipTime', syzpData.trusteeshipTime)
	syzpObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(syzpData.trusteeshipTime ~= 0)
	SYZP:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if syzpObj.ToggleTrusteeshipOne.gameObject == go then
        syzpData.trusteeshipType = true
		syzpData.trusteeshipRound = 0;
    elseif syzpObj.ToggleTrusteeshipAll.gameObject == go then
        syzpData.trusteeshipType = false
		syzpData.trusteeshipRound = 0;
	elseif syzpObj.ToggleTrusteeshipThree.gameObject == go then
		syzpData.trusteeshipType = false;
		syzpData.trusteeshipRound = 3;
    end
    UnityEngine.PlayerPrefs.SetInt('NewSYZPtrusteeshipType',syzpData.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewSYZPtrusteeshipRound',syzpData.trusteeshipRound )
end

function this.OnClickToggleHuMinNum(go)
	AudioManager.Instance:PlayAudio('btn')
    if syzpObj.ToggleQiHu10.gameObject == go then
        syzpData.huMinNum = 10
    elseif syzpObj.ToggleQiHu15.gameObject == go then
		syzpData.huMinNum = 15
	end 
	UnityEngine.PlayerPrefs.SetInt('NewSYZPhuMinNum', syzpData.huMinNum)
end
	
function this.OnClickToggleHuStep(go)
	AudioManager.Instance:PlayAudio('btn')
    if syzpObj.ToggleHuStep5.gameObject == go then
        syzpData.huStepNum = 5
    elseif syzpObj.ToggleHuStep3.gameObject == go then
        syzpData.huStepNum = 3
	elseif syzpObj.ToggleHuStep1.gameObject == go then
		syzpData.huStepNum = 1
    end
	UnityEngine.PlayerPrefs.SetInt('NewSYZPhuStepNum', syzpData.huStepNum)
end

function this.OnClickToggleHuType(go)
	AudioManager.Instance:PlayAudio('btn')
	if syzpObj.ToggleTian.gameObject == go then
		syzpData.tianHu = syzpObj.ToggleTian:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewSYZPtianHu', syzpData.tianHu and 1 or 0)
	elseif syzpObj.ToggleHong.gameObject == go then
		syzpData.hongHu = syzpObj.ToggleHong:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewSYZPhongHu', syzpData.hongHu and 1 or 0)
	elseif syzpObj.ToggleZiMo10Hu.gameObject == go then
		syzpData.ziMoAddHu = syzpObj.ToggleZiMo10Hu:GetComponent('UIToggle').value and 10 or 0
		UnityEngine.PlayerPrefs.SetInt('NewSYZPziMoAddHu', syzpData.ziMoAddHu)
	end
end

function this.OnClickChoiceDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if syzpObj.ToggleChoiceDouble.gameObject == go then
        syzpData.choiceDouble = true
    elseif syzpObj.ToggleNoChoiceDouble.gameObject == go then
        syzpData.choiceDouble = false
    end
    syzpObj.DoubleScoreText.parent.gameObject:SetActive(syzpData.choiceDouble)
    syzpObj.ToggleMultiple2.parent.gameObject:SetActive(syzpData.choiceDouble)
    SYZP:Find('table'):GetComponent('UIGrid'):Reposition()
    UnityEngine.PlayerPrefs.SetInt('NewSYZPchoiceDouble', syzpData.choiceDouble and 1 or 0)
end

function this.OnClickChangeDoubleScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if syzpObj.AddDoubleScoreButton.gameObject == go then
        if syzpData.doubleScore ~= 0 then
            syzpData.doubleScore = syzpData.doubleScore + 1
            if syzpData.doubleScore > 100 then
                syzpData.doubleScore = 0
            end
        end
    else
        if syzpData.doubleScore == 0 then
            syzpData.doubleScore = 100
        else
            syzpData.doubleScore = syzpData.doubleScore - 1
            if syzpData.doubleScore < 1 then
                syzpData.doubleScore = 1
            end
        end
    end
    if syzpData.doubleScore == 0 then
        syzpObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
    else
        syzpObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..syzpData.doubleScore..'分'
    end
    UnityEngine.PlayerPrefs.SetInt('NewSYZPdoubleScore', syzpData.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
    if syzpObj.ToggleMultiple2.gameObject == go then
        syzpData.multiple=2
    elseif syzpObj.ToggleMultiple3.gameObject == go then
        syzpData.multiple=3
    elseif syzpObj.ToggleMultiple4.gameObject == go then
        syzpData.multiple=4
    end
    UnityEngine.PlayerPrefs.SetInt('NewSYZPmultiple', syzpData.multiple)
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    syzpData.isSettlementScore= syzpObj.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewSYZPisSettlementScore', syzpData.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if syzpObj.ToggleFewerAddButton.gameObject == go then
		syzpData.fewerValue = syzpData.fewerValue + 1
		if syzpData.fewerValue > 100 then
			syzpData.fewerValue = 100
		end
    elseif syzpObj.ToggleFewerSubtractButton.gameObject == go then
		syzpData.fewerValue = syzpData.fewerValue - 1
		if syzpData.fewerValue < 1 then
			syzpData.fewerValue = 1
		end
	end
	syzpObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = syzpData.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewSYZPfewerValue', syzpData.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if syzpObj.ToggleAddAddButton.gameObject == go then
		syzpData.addValue = syzpData.addValue + 1
		if syzpData.addValue > 100 then
			syzpData.addValue = 100
		end
    elseif syzpObj.ToggleAddSubtractButton.gameObject == go then
		syzpData.addValue = syzpData.addValue - 1
		if syzpData.addValue < 1 then
			syzpData.addValue = 1
		end
	end
	syzpObj.ToggleAddScoreTxt:GetComponent('UILabel').text = syzpData.addValue
	UnityEngine.PlayerPrefs.SetInt('NewSYZPaddValue', syzpData.addValue)
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if syzpObj.ToggleIPcheck.gameObject == go then
		syzpData.openIp = syzpObj.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('SYZPcheckIP', syzpData.openIp and 1 or 0)
	elseif syzpObj.ToggleGPScheck.gameObject == go then
		syzpData.openGps = syzpObj.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('SYZPcheckGPS', syzpData.openGps and 1 or 0)
	end
end

function this.OnClickToggleChou(go)
	AudioManager.Instance:PlayAudio('btn')
	if syzpObj.ToggleChou0.gameObject == go then
        syzpData.chou=0
    elseif syzpObj.ToggleChou10.gameObject == go then
        syzpData.chou=10
    elseif syzpObj.ToggleChou20.gameObject == go then
        syzpData.chou=20
	end
	UnityEngine.PlayerPrefs.SetInt('NewSYZPchou', syzpData.chou)
end

return this