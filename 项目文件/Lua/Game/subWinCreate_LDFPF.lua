local this = {}

local LDFPF
local payLabel

local ldfpfObj = {}
local ldfpfData = {}

function this.Init(grid,message)
	print('Init_LDFPF')
	LDFPF = grid
	payLabel = message.transform:Find('diamond/pay_label')

	ldfpfObj.TogglePeopleNum2 = LDFPF:Find('table/num/num2')
	ldfpfObj.TogglePeopleNum3 = LDFPF:Find('table/num/num3')
	message:AddClick(ldfpfObj.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
    message:AddClick(ldfpfObj.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)
	
	ldfpfObj.ToggleMasterPay = LDFPF:Find('table/pay/master')
	ldfpfObj.ToggleWinnerPay = LDFPF:Find('table/pay/win')
	message:AddClick(ldfpfObj.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(ldfpfObj.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)
	
	ldfpfObj.ToggleRandomBanker = LDFPF:Find('table/randomBanker/Auto')
	ldfpfObj.ToggleBankerFrist = LDFPF:Find('table/randomBanker/Frist')
	message:AddClick(ldfpfObj.ToggleRandomBanker.gameObject, this.OnClickRandomBanker)
	message:AddClick(ldfpfObj.ToggleBankerFrist.gameObject, this.OnClickRandomBanker)

	ldfpfObj.ToggleHuXi200 = LDFPF:Find('table/huxi/huxi200')
	ldfpfObj.ToggleHuXi400 = LDFPF:Find('table/huxi/huxi400')
	message:AddClick(ldfpfObj.ToggleHuXi200.gameObject, this.OnClickToggleHuXi)
	message:AddClick(ldfpfObj.ToggleHuXi400.gameObject, this.OnClickToggleHuXi)

	ldfpfObj.ToggleNoChouPai = LDFPF:Find('table/choupai/buchou')
	ldfpfObj.ToggleChouPai10 = LDFPF:Find('table/choupai/chou10')
	ldfpfObj.ToggleChouPai20 = LDFPF:Find('table/choupai/chou20')
	message:AddClick(ldfpfObj.ToggleNoChouPai.gameObject, this.OnClickToggleChouPai)
	message:AddClick(ldfpfObj.ToggleChouPai10.gameObject, this.OnClickToggleChouPai)
	message:AddClick(ldfpfObj.ToggleChouPai20.gameObject, this.OnClickToggleChouPai)

	ldfpfObj.ToggleOnNiao = LDFPF:Find('table/niao/OnNiao')
	ldfpfObj.ToggleOffNiao = LDFPF:Find('table/niao/OffNiao')
	ldfpfObj.NiaoValueText = LDFPF:Find('table/niao/NiaoValue/Value')
	ldfpfObj.AddButtonNiao = LDFPF:Find('table/niao/NiaoValue/AddButton')
	ldfpfObj.SubtractButtonNiao = LDFPF:Find('table/niao/NiaoValue/SubtractButton')
	message:AddClick(ldfpfObj.ToggleOnNiao.gameObject, this.OnClickNiao)
	message:AddClick(ldfpfObj.ToggleOffNiao.gameObject, this.OnClickNiao)
	message:AddClick(ldfpfObj.AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(ldfpfObj.SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)

	ldfpfObj.ToggleChoiceDouble = LDFPF:Find('table/choiceDouble/On')
	ldfpfObj.ToggleNoChoiceDouble = LDFPF:Find('table/choiceDouble/Off')
	ldfpfObj.DoubleScoreText = LDFPF:Find('table/choiceDouble/doubleScore/Value')
	ldfpfObj.AddDoubleScoreButton = LDFPF:Find('table/choiceDouble/doubleScore/AddButton')
	ldfpfObj.SubtractDoubleScoreButton = LDFPF:Find('table/choiceDouble/doubleScore/SubtractButton')
	ldfpfObj.ToggleMultiple2 = LDFPF:Find('table/multiple/2')
	ldfpfObj.ToggleMultiple3 = LDFPF:Find('table/multiple/3')
	ldfpfObj.ToggleMultiple4 = LDFPF:Find('table/multiple/4')
	message:AddClick(ldfpfObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(ldfpfObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(ldfpfObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(ldfpfObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(ldfpfObj.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(ldfpfObj.ToggleMultiple3.gameObject, this.OnClickMultiple)
    message:AddClick(ldfpfObj.ToggleMultiple4.gameObject, this.OnClickMultiple)

    ldfpfObj.ToggleSettlementScoreSelect=LDFPF:Find('table/settlementScore/select')
	ldfpfObj.ToggleFewerScoreTxt=LDFPF:Find('table/settlementScore/fewerValue/Value')
	ldfpfObj.ToggleFewerAddButton=LDFPF:Find('table/settlementScore/fewerValue/AddButton')
	ldfpfObj.ToggleFewerSubtractButton=LDFPF:Find('table/settlementScore/fewerValue/SubtractButton')
	ldfpfObj.ToggleAddScoreTxt=LDFPF:Find('table/settlementScore/addValue/Value')
	ldfpfObj.ToggleAddAddButton=LDFPF:Find('table/settlementScore/addValue/AddButton')
	ldfpfObj.ToggleAddSubtractButton=LDFPF:Find('table/settlementScore/addValue/SubtractButton')
	message:AddClick(ldfpfObj.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(ldfpfObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(ldfpfObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(ldfpfObj.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(ldfpfObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)
	
	ldfpfObj.ToggleTrusteeshipNo = LDFPF:Find('table/DelegateChoose/NoDelegate')
	ldfpfObj.ToggleTrusteeship1 = LDFPF:Find('table/DelegateChoose/Delegate1')
	ldfpfObj.ToggleTrusteeship2 = LDFPF:Find('table/DelegateChoose/Delegate2')
	ldfpfObj.ToggleTrusteeship3 = LDFPF:Find('table/DelegateChoose/Delegate3')
	ldfpfObj.ToggleTrusteeship5 = LDFPF:Find('table/DelegateChoose/Delegate5')
	ldfpfObj.ToggleTrusteeshipAll = LDFPF:Find('table/DelegateCancel/FullRound')
	ldfpfObj.ToggleTrusteeshipOne = LDFPF:Find('table/DelegateCancel/ThisRound')
	ldfpfObj.ToggleTrusteeshipThree = LDFPF:Find('table/DelegateCancel/ThreeRound')
	message:AddClick(ldfpfObj.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ldfpfObj.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ldfpfObj.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ldfpfObj.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ldfpfObj.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ldfpfObj.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(ldfpfObj.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
    message:AddClick(ldfpfObj.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)
	
	ldfpfObj.ToggleIPcheck = LDFPF:Find('table/PreventCheat/IPcheck')
	ldfpfObj.ToggleGPScheck = LDFPF:Find('table/PreventCheat/GPScheck')
	message:AddClick(ldfpfObj.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(ldfpfObj.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end
function this.Refresh()
	print('Refresh_LDFPF')
	ldfpfData.size=UnityEngine.PlayerPrefs.GetInt('NewLDFPFsize', 2)
	ldfpfObj.TogglePeopleNum2:GetComponent('UIToggle'):Set(ldfpfData.size == 2)
	ldfpfObj.TogglePeopleNum3:GetComponent('UIToggle'):Set(ldfpfData.size == 3)
	
	ldfpfData.paymentType=UnityEngine.PlayerPrefs.GetInt('NewLDFPFpaymentType', 0)
	ldfpfObj.ToggleMasterPay:GetComponent('UIToggle'):Set(ldfpfData.paymentType == 0)
	ldfpfObj.ToggleWinnerPay:GetComponent('UIToggle'):Set(ldfpfData.paymentType == 2)

	ldfpfData.randomBanker=UnityEngine.PlayerPrefs.GetInt('NewLDFPFrandomBanker', 0)==1
	ldfpfObj.ToggleRandomBanker:GetComponent('UIToggle'):Set(ldfpfData.randomBanker)
	ldfpfObj.ToggleBankerFrist:GetComponent('UIToggle'):Set(not ldfpfData.randomBanker)

	ldfpfData.maxHuXi=UnityEngine.PlayerPrefs.GetInt('NewLDFPFmaxHuXi', 200)
	ldfpfObj.ToggleHuXi200:GetComponent('UIToggle'):Set(ldfpfData.maxHuXi == 200)
	ldfpfObj.ToggleHuXi400:GetComponent('UIToggle'):Set(ldfpfData.maxHuXi == 400)
	
	ldfpfData.choupai=UnityEngine.PlayerPrefs.GetInt('NewLDFPFchoupai', 20)
	ldfpfObj.ToggleNoChouPai.parent.gameObject:SetActive(ldfpfData.size==2)
	ldfpfObj.ToggleNoChouPai:GetComponent('UIToggle'):Set(ldfpfData.choupai == 0)
	ldfpfObj.ToggleChouPai10:GetComponent('UIToggle'):Set(ldfpfData.choupai == 10)
	ldfpfObj.ToggleChouPai20:GetComponent('UIToggle'):Set(ldfpfData.choupai == 20)

	ldfpfData.niao=UnityEngine.PlayerPrefs.GetInt('NewLDFPFniao', 0)==1
	ldfpfData.niaoValue=UnityEngine.PlayerPrefs.GetInt('NewLDFPFniaoValue', 10)
	ldfpfObj.ToggleOnNiao:GetComponent('UIToggle'):Set(ldfpfData.niao)
	ldfpfObj.ToggleOffNiao:GetComponent('UIToggle'):Set(not ldfpfData.niao)
	ldfpfObj.NiaoValueText.parent.gameObject:SetActive(ldfpfData.niao)
	ldfpfObj.NiaoValueText:GetComponent('UILabel').text = ldfpfData.niaoValue.."分"

	ldfpfData.choiceDouble=UnityEngine.PlayerPrefs.GetInt('NewLDFPFchoiceDouble', 0)==1
	ldfpfData.doubleScore=UnityEngine.PlayerPrefs.GetInt('NewLDFPFdoubleScore', 10)
	ldfpfData.multiple=UnityEngine.PlayerPrefs.GetInt('NewLDFPFmultiple', 2)
	ldfpfObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(ldfpfData.choiceDouble)
	ldfpfObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not ldfpfData.choiceDouble)
	ldfpfObj.DoubleScoreText.parent.gameObject:SetActive(ldfpfData.choiceDouble)
	if ldfpfData.doubleScore == 0 then
		ldfpfObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		ldfpfObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..ldfpfData.doubleScore..'分'
	end
	ldfpfObj.ToggleChoiceDouble.parent.gameObject:SetActive(ldfpfData.size == 2)
	ldfpfObj.ToggleMultiple2:GetComponent('UIToggle'):Set(ldfpfData.multiple == 2)
	ldfpfObj.ToggleMultiple3:GetComponent('UIToggle'):Set(ldfpfData.multiple == 3)
	ldfpfObj.ToggleMultiple4:GetComponent('UIToggle'):Set(ldfpfData.multiple == 4)
	ldfpfObj.ToggleMultiple2.parent.gameObject:SetActive(ldfpfData.choiceDouble and  ldfpfData.size == 2)

    ldfpfData.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewLDFPFisSettlementScore', 0)==1
	ldfpfData.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewLDFPFfewerValue', 10)
	ldfpfData.addValue=UnityEngine.PlayerPrefs.GetInt('NewLDFPFaddValue', 10)
	ldfpfObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(ldfpfData.size==2)
    ldfpfObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(ldfpfData.isSettlementScore)
	ldfpfObj.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	ldfpfObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = ldfpfData.fewerValue
	ldfpfObj.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	ldfpfObj.ToggleAddScoreTxt:GetComponent('UILabel').text = ldfpfData.addValue
	
	ldfpfData.trusteeshipTime=UnityEngine.PlayerPrefs.GetInt('NewLDFPFtrusteeshipTime', 0)
	ldfpfData.trusteeshipType = UnityEngine.PlayerPrefs.GetInt('NewLDFPFtrusteeshipType', 0) == 1
    ldfpfData.trusteeshipRound = UnityEngine.PlayerPrefs.GetInt('NewLDFPFtrusteeshipRound', 0)
	ldfpfObj.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(ldfpfData.trusteeshipTime == 0)
	ldfpfObj.ToggleTrusteeship1:GetComponent('UIToggle'):Set(ldfpfData.trusteeshipTime == 1)
	ldfpfObj.ToggleTrusteeship2:GetComponent('UIToggle'):Set(ldfpfData.trusteeshipTime == 2)
	ldfpfObj.ToggleTrusteeship3:GetComponent('UIToggle'):Set(ldfpfData.trusteeshipTime == 3)
	ldfpfObj.ToggleTrusteeship5:GetComponent('UIToggle'):Set(ldfpfData.trusteeshipTime == 5)
	ldfpfObj.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(ldfpfData.trusteeshipType)
	ldfpfObj.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not ldfpfData.trusteeshipType and ldfpfData.trusteeshipRound == 0)
    ldfpfObj.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(ldfpfData.trusteeshipRound == 3)
	ldfpfObj.ToggleTrusteeshipOne.parent.gameObject:SetActive( ldfpfData.trusteeshipTime ~= 0)

	ldfpfData.openIp=UnityEngine.PlayerPrefs.GetInt('LDFPFcheckIP', 0)==1
	ldfpfData.openGps=UnityEngine.PlayerPrefs.GetInt('LDFPFcheckGPS', 0)==1
	ldfpfObj.ToggleIPcheck:GetComponent('UIToggle'):Set(ldfpfData.openIp)
	ldfpfObj.ToggleGPScheck:GetComponent('UIToggle'):Set(ldfpfData.openGps)
	ldfpfObj.ToggleIPcheck.parent.gameObject:SetActive(ldfpfData.size > 2 and CONST.IPcheckOn)
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.LDFPF,nil,nil,nil)
	LDFPF:Find('table'):GetComponent('UIGrid'):Reposition()
end
--获取当前设置
function this.GetConfig()
	local moneyLess = false
	if info_login.balance < 2 then
        moneyLess = true
    end
    local body = {}
    body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.LDFPF)
    body.rounds = 0
    body.size = ldfpfData.size
    body.paymentType = ldfpfData.paymentType
    body.randomBanker = ldfpfData.randomBanker
    body.trusteeship = ldfpfData.trusteeshipTime*60;
    body.trusteeshipDissolve = ldfpfData.trusteeshipType;
    body.trusteeshipRound = ldfpfData.trusteeshipRound;

    body.tianDiHu = true
    body.heiHongHu = true
    body.qiHuHuXi = 15
    body.tunXi = 1
    body.fanXing = false
    body.maxHuXi = ldfpfData.maxHuXi
    body.niao = ldfpfData.niao
    body.niaoValue = ldfpfData.niaoValue
	body.chou = ldfpfData.size == 2 and ldfpfData.choupai or 0

    if ldfpfData.size == 2 then
		body.resultScore = ldfpfData.isSettlementScore
		if ldfpfData.isSettlementScore then
			body.resultLowerScore=ldfpfData.fewerValue
			body.resultAddScore=ldfpfData.addValue
		end
	end

    if ldfpfData.size == 2 then
        body.choiceDouble = ldfpfData.choiceDouble
        body.doubleScore = ldfpfData.doubleScore
        body.multiple = ldfpfData.multiple
		ldfpfData.openIp=false
		ldfpfData.openGps=false
    end
	body.openIp	 = ldfpfData.openIp
	body.openGps = ldfpfData.openGps
	
    return moneyLess,body;
end

function this.OnClickTogglePlayerNum(go)
	AudioManager.Instance:PlayAudio('btn')
    if ldfpfObj.TogglePeopleNum2.gameObject == go then
        ldfpfData.size = 2
    elseif ldfpfObj.TogglePeopleNum3.gameObject == go then
        ldfpfData.size = 3
    end
	ldfpfObj.ToggleNoChouPai.parent.gameObject:SetActive(ldfpfData.size==2)
	ldfpfObj.ToggleNoChouPai:GetComponent('UIToggle'):Set(ldfpfData.choupai == 0)
	ldfpfObj.ToggleChouPai10:GetComponent('UIToggle'):Set(ldfpfData.choupai == 10)
	ldfpfObj.ToggleChouPai20:GetComponent('UIToggle'):Set(ldfpfData.choupai == 20)
	ldfpfObj.ToggleIPcheck.parent.gameObject:SetActive(ldfpfData.size > 2 and CONST.IPcheckOn)
    UnityEngine.PlayerPrefs.SetInt('NewLDFPFsize', ldfpfData.size)
    ldfpfObj.ToggleNoChoiceDouble.parent.gameObject:SetActive(ldfpfData.size==2)
    ldfpfObj.ToggleMultiple2.parent.gameObject:SetActive(ldfpfData.choiceDouble and ldfpfData.size==2)
    ldfpfObj.DoubleScoreText.parent.gameObject:SetActive(ldfpfData.choiceDouble)
    ldfpfObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(ldfpfData.size==2)
    LDFPF:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if ldfpfObj.ToggleMasterPay.gameObject == go then
        ldfpfData.paymentType=0
    elseif ldfpfObj.ToggleWinnerPay.gameObject == go then
        ldfpfData.paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewLDFPFpaymentType', ldfpfData.paymentType)
end

function this.OnClickRandomBanker(go)
    AudioManager.Instance:PlayAudio('btn')
    if ldfpfObj.ToggleRandomBanker.gameObject == go then
        ldfpfData.randomBanker = true
    elseif ldfpfObj.ToggleBankerFrist.gameObject == go then
        ldfpfData.randomBanker = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewLDFPFrandomBanker', ldfpfData.randomBanker and 1 or 0)
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if ldfpfObj.ToggleTrusteeshipNo.gameObject == go then
        ldfpfData.trusteeshipTime = 0
    elseif ldfpfObj.ToggleTrusteeship1.gameObject == go then
        ldfpfData.trusteeshipTime = 1
    elseif ldfpfObj.ToggleTrusteeship2.gameObject == go then
        ldfpfData.trusteeshipTime = 2
    elseif ldfpfObj.ToggleTrusteeship3.gameObject == go then
        ldfpfData.trusteeshipTime = 3
    elseif ldfpfObj.ToggleTrusteeship5.gameObject == go then
        ldfpfData.trusteeshipTime = 5
    end
    UnityEngine.PlayerPrefs.SetInt('NewLDFPFtrusteeshipTime', ldfpfData.trusteeshipTime)
    ldfpfObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(ldfpfData.trusteeshipTime ~= 0)
    LDFPF:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if ldfpfObj.ToggleTrusteeshipOne.gameObject == go then
        ldfpfData.trusteeshipType = true
        ldfpfData.trusteeshipRound = 0;
    elseif ldfpfObj.ToggleTrusteeshipAll.gameObject == go then
        ldfpfData.trusteeshipType = false
        ldfpfData.trusteeshipRound = 0;
    elseif ldfpfObj.ToggleTrusteeshipThree.gameObject == go then
        ldfpfData.trusteeshipType = false;
        ldfpfData.trusteeshipRound = 3;
    end
    UnityEngine.PlayerPrefs.SetInt('NewLDFPFtrusteeshipType',ldfpfData.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewLDFPFtrusteeshipRound',ldfpfData.trusteeshipRound )
end

function this.OnClickToggleHuXi(go)
	AudioManager.Instance:PlayAudio('btn')
	if ldfpfObj.ToggleHuXi200.gameObject == go then 
		ldfpfData.maxHuXi = 200
	elseif ldfpfObj.ToggleHuXi400.gameObject == go then 
		ldfpfData.maxHuXi = 400
	end
	UnityEngine.PlayerPrefs.SetInt('NewLDFPFmaxHuXi', ldfpfData.maxHuXi)
end 
function this.OnClickNiao(go)
	AudioManager.Instance:PlayAudio('btn')
    if ldfpfObj.ToggleOnNiao.gameObject == go then
        ldfpfData.niao = true
    elseif ldfpfObj.ToggleOffNiao.gameObject == go then
        ldfpfData.niao = false
    end
    ldfpfObj.NiaoValueText.parent.gameObject:SetActive(ldfpfData.niao)
    UnityEngine.PlayerPrefs.SetInt('NewLDFPFniao', ldfpfData.niao and 1 or 0)
end
function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
    if ldfpfObj.AddButtonNiao.gameObject == go then
        ldfpfData.niaoValue = ldfpfData.niaoValue + 10
        if ldfpfData.niaoValue > 100 then
            ldfpfData.niaoValue = 100
        end
    elseif ldfpfObj.SubtractButtonNiao.gameObject == go then
        ldfpfData.niaoValue = ldfpfData.niaoValue - 10
        if ldfpfData.niaoValue < 10 then
            ldfpfData.niaoValue = 10
        end
    end
    ldfpfObj.NiaoValueText:GetComponent('UILabel').text = ldfpfData.niaoValue.."分"
    UnityEngine.PlayerPrefs.SetInt('NewLDFPFniaoValue', ldfpfData.niaoValue)
end

function this.OnClickChoiceDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if ldfpfObj.ToggleChoiceDouble.gameObject == go then
        ldfpfData.choiceDouble = true
    elseif ldfpfObj.ToggleNoChoiceDouble.gameObject == go then
        ldfpfData.choiceDouble = false
    end
    ldfpfObj.DoubleScoreText.parent.gameObject:SetActive(ldfpfData.choiceDouble)
    ldfpfObj.ToggleMultiple2.parent.gameObject:SetActive(ldfpfData.choiceDouble)
    LDFPF:Find('table'):GetComponent('UIGrid'):Reposition()
    UnityEngine.PlayerPrefs.SetInt('NewLDFPFchoiceDouble', ldfpfData.choiceDouble and 1 or 0)
end

function this.OnClickChangeDoubleScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if ldfpfObj.AddDoubleScoreButton.gameObject == go then
        if ldfpfData.doubleScore ~= 0 then
            ldfpfData.doubleScore = ldfpfData.doubleScore + 1
            if ldfpfData.doubleScore > 100 then
                ldfpfData.doubleScore = 0
            end
        end
    else
        if ldfpfData.doubleScore == 0 then
            ldfpfData.doubleScore = 100
        else
            ldfpfData.doubleScore = ldfpfData.doubleScore - 1
            if ldfpfData.doubleScore < 1 then
                ldfpfData.doubleScore = 1
            end
        end
    end
    if ldfpfData.doubleScore == 0 then
        ldfpfObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
    else
        ldfpfObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..ldfpfData.doubleScore..'分'
    end
    UnityEngine.PlayerPrefs.SetInt('NewLDFPFdoubleScore', ldfpfData.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
    if ldfpfObj.ToggleMultiple2.gameObject == go then
        ldfpfData.multiple=2
    elseif ldfpfObj.ToggleMultiple3.gameObject == go then
        ldfpfData.multiple=3
    elseif ldfpfObj.ToggleMultiple4.gameObject == go then
        ldfpfData.multiple=4
    end
    UnityEngine.PlayerPrefs.SetInt('NewLDFPFmultiple', ldfpfData.multiple)
end

function this.OnClickToggleChouPai(go)
	AudioManager.Instance:PlayAudio('btn')
	if ldfpfObj.ToggleNoChouPai.gameObject == go then
		ldfpfData.choupai = 0
	elseif ldfpfObj.ToggleChouPai10.gameObject == go then
		ldfpfData.choupai = 10
	elseif ldfpfObj.ToggleChouPai20.gameObject == go then
		ldfpfData.choupai = 20
	end
	UnityEngine.PlayerPrefs.SetInt('NewLDFPFchoupai', ldfpfData.choupai)
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    ldfpfData.isSettlementScore= ldfpfObj.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewLDFPFisSettlementScore', ldfpfData.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if ldfpfObj.ToggleFewerAddButton.gameObject == go then
		ldfpfData.fewerValue = ldfpfData.fewerValue + 1
		if ldfpfData.fewerValue > 100 then
			ldfpfData.fewerValue = 100
		end
    elseif ldfpfObj.ToggleFewerSubtractButton.gameObject == go then
		ldfpfData.fewerValue = ldfpfData.fewerValue - 1
		if ldfpfData.fewerValue < 1 then
			ldfpfData.fewerValue = 1
		end
	end
	ldfpfObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = ldfpfData.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewLDFPFfewerValue', ldfpfData.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if ldfpfObj.ToggleAddAddButton.gameObject == go then
		ldfpfData.addValue = ldfpfData.addValue + 1
		if ldfpfData.addValue > 100 then
			ldfpfData.addValue = 100
		end
    elseif ldfpfObj.ToggleAddSubtractButton.gameObject == go then
		ldfpfData.addValue = ldfpfData.addValue - 1
		if ldfpfData.addValue < 1 then
			ldfpfData.addValue = 1
		end
	end
	ldfpfObj.ToggleAddScoreTxt:GetComponent('UILabel').text = ldfpfData.addValue
	UnityEngine.PlayerPrefs.SetInt('NewLDFPFaddValue', ldfpfData.addValue)
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if ldfpfObj.ToggleIPcheck.gameObject == go then
		ldfpfData.openIp = ldfpfObj.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('LDFPFcheckIP', ldfpfData.openIp and 1 or 0)
	elseif ldfpfObj.ToggleGPScheck.gameObject == go then
		ldfpfData.openGps = ldfpfObj.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('LDFPFcheckGPS', ldfpfData.openGps and 1 or 0)
	end
end

return this