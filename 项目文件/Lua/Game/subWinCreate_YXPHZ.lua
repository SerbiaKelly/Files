local this = {}

local YXPHZ
local payLabel

local yxphzData = {}
local yxphzObj = {}

function this.Init(grid,message)
	print('Init_YXPHZ')
	YXPHZ = grid
	payLabel = message.transform:Find('diamond/pay_label')

	yxphzObj.ToggleRound6 = YXPHZ:Find('table/round/round6')
	yxphzObj.ToggleRound8 = YXPHZ:Find('table/round/round8')
	yxphzObj.ToggleRound10 = YXPHZ:Find('table/round/round10')
	yxphzObj.ToggleRound16 = YXPHZ:Find('table/round/round16')
	message:AddClick(yxphzObj.ToggleRound6.gameObject, this.OnClickToggleRound)
	message:AddClick(yxphzObj.ToggleRound8.gameObject, this.OnClickToggleRound)
	message:AddClick(yxphzObj.ToggleRound10.gameObject, this.OnClickToggleRound)
	message:AddClick(yxphzObj.ToggleRound16.gameObject, this.OnClickToggleRound)

	yxphzObj.TogglePeopleNum2 = YXPHZ:Find('table/num/num2')
	yxphzObj.TogglePeopleNum3 = YXPHZ:Find('table/num/num3')
	yxphzObj.TogglePeopleNum4 = YXPHZ:Find('table/num/num4')
	message:AddClick(yxphzObj.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(yxphzObj.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(yxphzObj.TogglePeopleNum4.gameObject, this.OnClickTogglePlayerNum)

	yxphzObj.ToggleMasterPay = YXPHZ:Find('table/pay/master')
	yxphzObj.ToggleWinnerPay = YXPHZ:Find('table/pay/win')
	message:AddClick(yxphzObj.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(yxphzObj.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)

	yxphzObj.ToggleRandomBanker = YXPHZ:Find('table/randomBanker/Auto')
	yxphzObj.ToggleBankerFrist = YXPHZ:Find('table/randomBanker/Frist')
	message:AddClick(yxphzObj.ToggleRandomBanker.gameObject, this.OnClickRandomBanker)
	message:AddClick(yxphzObj.ToggleBankerFrist.gameObject, this.OnClickRandomBanker)

	yxphzObj.ToggleLianZhuang = YXPHZ:Find('table/mode/lianZhuang')
	yxphzObj.ToggleZhongZhuang = YXPHZ:Find('table/mode/zhongZhuang')
	message:AddClick(yxphzObj.ToggleLianZhuang.gameObject, this.OnClickModeSetting)
	message:AddClick(yxphzObj.ToggleZhongZhuang.gameObject, this.OnClickModeSetting)

	yxphzObj.ToggleYouHuBiHu = YXPHZ:Find('table/play/youHuBiHu')
	message:AddClick(yxphzObj.ToggleYouHuBiHu.gameObject, this.OnClickToggleYouHuBiHu)

	yxphzObj.AddBtnHuangZhuangKouFen = YXPHZ:Find('table/huangZhuangKouFen/kouScore/AddButton')
	yxphzObj.SubtractBtnHuangZhuangKouFen = YXPHZ:Find('table/huangZhuangKouFen/kouScore/SubtractButton')
	yxphzObj.HuangZhuangKouFenValue = YXPHZ:Find('table/huangZhuangKouFen/kouScore/Value')
	message:AddClick(yxphzObj.AddBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)
	message:AddClick(yxphzObj.SubtractBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)

	yxphzObj.ToggleChou0 = YXPHZ:Find('table/chouCard/chouCard0')
	yxphzObj.ToggleChou14 = YXPHZ:Find('table/chouCard/chouCard14')
	yxphzObj.ToggleChou28 = YXPHZ:Find('table/chouCard/chouCard28')
	message:AddClick(yxphzObj.ToggleChou0.gameObject, this.OnClickToggleChou)
	message:AddClick(yxphzObj.ToggleChou14.gameObject, this.OnClickToggleChou)
	message:AddClick(yxphzObj.ToggleChou28.gameObject, this.OnClickToggleChou)

	yxphzObj.ToggleOnNiao = YXPHZ:Find('table/niao/OnNiao')
	yxphzObj.ToggleOffNiao = YXPHZ:Find('table/niao/OffNiao')
	yxphzObj.NiaoValueText = YXPHZ:Find('table/niao/NiaoValue/Value')
	yxphzObj.AddButtonNiao = YXPHZ:Find('table/niao/NiaoValue/AddButton')
	yxphzObj.SubtractButtonNiao = YXPHZ:Find('table/niao/NiaoValue/SubtractButton')
	message:AddClick(yxphzObj.ToggleOnNiao.gameObject, this.OnClickNiao)
	message:AddClick(yxphzObj.ToggleOffNiao.gameObject, this.OnClickNiao)
	message:AddClick(yxphzObj.AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(yxphzObj.SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)

	yxphzObj.ToggleChoiceDouble = YXPHZ:Find('table/choiceDouble/On')
	yxphzObj.ToggleNoChoiceDouble = YXPHZ:Find('table/choiceDouble/Off')
	yxphzObj.DoubleScoreText = YXPHZ:Find('table/choiceDouble/doubleScore/Value')
	yxphzObj.AddDoubleScoreButton = YXPHZ:Find('table/choiceDouble/doubleScore/AddButton')
	yxphzObj.SubtractDoubleScoreButton = YXPHZ:Find('table/choiceDouble/doubleScore/SubtractButton')
	yxphzObj.ToggleMultiple2 = YXPHZ:Find('table/multiple/2')
	yxphzObj.ToggleMultiple3 = YXPHZ:Find('table/multiple/3')
	yxphzObj.ToggleMultiple4 = YXPHZ:Find('table/multiple/4')
	message:AddClick(yxphzObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(yxphzObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(yxphzObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(yxphzObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(yxphzObj.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(yxphzObj.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(yxphzObj.ToggleMultiple4.gameObject, this.OnClickMultiple)

	yxphzObj.ToggleSettlementScoreSelect=YXPHZ:Find('table/settlementScore/select')
	yxphzObj.ToggleFewerScoreTxt=YXPHZ:Find('table/settlementScore/fewerValue/Value')
	yxphzObj.ToggleFewerAddButton=YXPHZ:Find('table/settlementScore/fewerValue/AddButton')
	yxphzObj.ToggleFewerSubtractButton=YXPHZ:Find('table/settlementScore/fewerValue/SubtractButton')
	yxphzObj.ToggleAddScoreTxt=YXPHZ:Find('table/settlementScore/addValue/Value')
	yxphzObj.ToggleAddAddButton=YXPHZ:Find('table/settlementScore/addValue/AddButton')
	yxphzObj.ToggleAddSubtractButton=YXPHZ:Find('table/settlementScore/addValue/SubtractButton')
	
	message:AddClick(yxphzObj.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(yxphzObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(yxphzObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(yxphzObj.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(yxphzObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)
	
	yxphzObj.ToggleTrusteeshipNo = YXPHZ:Find('table/DelegateChoose/NoDelegate')
	yxphzObj.ToggleTrusteeship1 = YXPHZ:Find('table/DelegateChoose/Delegate1')
	yxphzObj.ToggleTrusteeship2 = YXPHZ:Find('table/DelegateChoose/Delegate2')
	yxphzObj.ToggleTrusteeship3 = YXPHZ:Find('table/DelegateChoose/Delegate3')
	yxphzObj.ToggleTrusteeship5 = YXPHZ:Find('table/DelegateChoose1/Delegate5')
	message:AddClick(yxphzObj.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(yxphzObj.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(yxphzObj.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(yxphzObj.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(yxphzObj.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)

	yxphzObj.ToggleTrusteeshipAll = YXPHZ:Find('table/DelegateCancel/FullRound')
	yxphzObj.ToggleTrusteeshipOne = YXPHZ:Find('table/DelegateCancel/ThisRound')
	yxphzObj.ToggleTrusteeshipThree = YXPHZ:Find('table/DelegateCancel/ThreeRound')
	message:AddClick(yxphzObj.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(yxphzObj.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(yxphzObj.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)
	
	yxphzObj.ToggleIPcheck = YXPHZ:Find('table/PreventCheat/IPcheck')
	yxphzObj.ToggleGPScheck = YXPHZ:Find('table/PreventCheat/GPScheck')
	message:AddClick(yxphzObj.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(yxphzObj.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end
function this.Refresh()
	print('Refresh_YXPHZ')
	yxphzData.rounds=UnityEngine.PlayerPrefs.GetInt('NewYXPHZrounds', 8)
	yxphzObj.ToggleRound6:GetComponent('UIToggle'):Set(yxphzData.rounds == 6)
	yxphzObj.ToggleRound8:GetComponent('UIToggle'):Set(yxphzData.rounds == 8)
	yxphzObj.ToggleRound10:GetComponent('UIToggle'):Set(yxphzData.rounds == 10)
	yxphzObj.ToggleRound16:GetComponent('UIToggle'):Set(yxphzData.rounds == 16)

	yxphzData.size=UnityEngine.PlayerPrefs.GetInt('NewYXPHZsize', 2)
	yxphzObj.TogglePeopleNum2:GetComponent('UIToggle'):Set(yxphzData.size == 2)
	yxphzObj.TogglePeopleNum3:GetComponent('UIToggle'):Set(yxphzData.size == 3)
	yxphzObj.TogglePeopleNum4:GetComponent('UIToggle'):Set(yxphzData.size == 4)

	yxphzData.paymentType=UnityEngine.PlayerPrefs.GetInt('NewYXPHZpaymentType', 0)
	yxphzObj.ToggleMasterPay:GetComponent('UIToggle'):Set(yxphzData.paymentType == 0)
	yxphzObj.ToggleWinnerPay:GetComponent('UIToggle'):Set(yxphzData.paymentType == 2)

	yxphzData.randomBanker=UnityEngine.PlayerPrefs.GetInt('NewYXPHZrandomBanker', 0)==1
	yxphzObj.ToggleRandomBanker:GetComponent('UIToggle'):Set(yxphzData.randomBanker)
	yxphzObj.ToggleBankerFrist:GetComponent('UIToggle'):Set(not yxphzData.randomBanker)

	yxphzData.mode=UnityEngine.PlayerPrefs.GetInt('NewYXPHZmode', 0)
	yxphzObj.ToggleLianZhuang:GetComponent('UIToggle'):Set(yxphzData.mode == 0)
	yxphzObj.ToggleZhongZhuang:GetComponent('UIToggle'):Set(yxphzData.mode == 1)

	yxphzData.haveHuMustHu=UnityEngine.PlayerPrefs.GetInt('NewYXPHZhaveHuMustHu', 0) == 1
	yxphzObj.ToggleYouHuBiHu:GetComponent('UIToggle'):Set(yxphzData.haveHuMustHu)

	yxphzData.huangZhuangFen=UnityEngine.PlayerPrefs.GetInt('NewYXPHZhuangZhuangFen', 0) 
	yxphzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = yxphzData.huangZhuangFen == 0 and '不扣分' or '扣'..yxphzData.huangZhuangFen..'分'

	yxphzData.chou = UnityEngine.PlayerPrefs.GetInt('NewYXPHZchou', 28)
	yxphzObj.ToggleChou0:GetComponent('UIToggle'):Set(yxphzData.chou == 0)
	yxphzObj.ToggleChou14:GetComponent('UIToggle'):Set(yxphzData.chou == 14)
	yxphzObj.ToggleChou28:GetComponent('UIToggle'):Set(yxphzData.chou == 28)
	yxphzObj.ToggleChou0.parent.gameObject:SetActive(yxphzData.size == 2)

	yxphzData.niao=UnityEngine.PlayerPrefs.GetInt('NewYXPHZniao', 0)==1
	yxphzData.niaoValue=UnityEngine.PlayerPrefs.GetInt('NewYXPHZniaoValue', 10)
	yxphzObj.ToggleOnNiao:GetComponent('UIToggle'):Set(yxphzData.niao)
	yxphzObj.ToggleOffNiao:GetComponent('UIToggle'):Set(not yxphzData.niao)
	yxphzObj.NiaoValueText.parent.gameObject:SetActive(yxphzData.niao)
    yxphzObj.NiaoValueText:GetComponent('UILabel').text = yxphzData.niaoValue.."分"

	yxphzData.choiceDouble=UnityEngine.PlayerPrefs.GetInt('NewYXPHZchoiceDouble', 0)==1
	yxphzData.doubleScore=UnityEngine.PlayerPrefs.GetInt('NewYXPHZdoubleScore', 10)
	yxphzData.multiple=UnityEngine.PlayerPrefs.GetInt('NewYXPHZmultiple', 2)
	yxphzObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(yxphzData.choiceDouble)
	yxphzObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not yxphzData.choiceDouble)
	yxphzObj.DoubleScoreText.parent.gameObject:SetActive(yxphzData.choiceDouble)
	if yxphzData.doubleScore == 0 then
		yxphzObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		yxphzObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..yxphzData.doubleScore..'分'
	end
	yxphzObj.ToggleChoiceDouble.parent.gameObject:SetActive(yxphzData.size == 2)
	yxphzObj.ToggleMultiple2:GetComponent('UIToggle'):Set(yxphzData.multiple == 2)
	yxphzObj.ToggleMultiple3:GetComponent('UIToggle'):Set(yxphzData.multiple == 3)
	yxphzObj.ToggleMultiple4:GetComponent('UIToggle'):Set(yxphzData.multiple == 4)
	yxphzObj.ToggleMultiple2.parent.gameObject:SetActive(yxphzData.choiceDouble and  yxphzData.size == 2)

	yxphzData.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewYXPHZisSettlementScore', 0)==1
	yxphzData.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewYXPHZfewerValue', 10)
	yxphzData.addValue=UnityEngine.PlayerPrefs.GetInt('NewYXPHZaddValue', 10)
	yxphzObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(yxphzData.size==2)
	yxphzObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(yxphzData.isSettlementScore)
	yxphzObj.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	yxphzObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = yxphzData.fewerValue
	yxphzObj.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	yxphzObj.ToggleAddScoreTxt:GetComponent('UILabel').text = yxphzData.addValue

	yxphzData.trusteeshipTime=UnityEngine.PlayerPrefs.GetInt('NewYXPHZtrusteeshipTime', 0)
	yxphzData.trusteeshipType = UnityEngine.PlayerPrefs.GetInt('NewYXPHZtrusteeshipType', 0) == 1
	yxphzData.trusteeshipRound = UnityEngine.PlayerPrefs.GetInt('NewYXPHZtrusteeshipRound', 0)
	yxphzObj.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(yxphzData.trusteeshipTime == 0)
	yxphzObj.ToggleTrusteeship1:GetComponent('UIToggle'):Set(yxphzData.trusteeshipTime == 1)
	yxphzObj.ToggleTrusteeship2:GetComponent('UIToggle'):Set(yxphzData.trusteeshipTime == 2)
	yxphzObj.ToggleTrusteeship3:GetComponent('UIToggle'):Set(yxphzData.trusteeshipTime == 3)
	yxphzObj.ToggleTrusteeship5:GetComponent('UIToggle'):Set(yxphzData.trusteeshipTime == 5)
	yxphzObj.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(yxphzData.trusteeshipType)
	yxphzObj.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not yxphzData.trusteeshipType and yxphzData.trusteeshipRound == 0)
	yxphzObj.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(yxphzData.trusteeshipRound == 3);
	yxphzObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(yxphzData.trusteeshipTime ~= 0)
	
	yxphzData.openIp=UnityEngine.PlayerPrefs.GetInt('YXPHZcheckIP', 0)==1
	yxphzData.openGps=UnityEngine.PlayerPrefs.GetInt('YXPHZcheckGPS', 0)==1
	yxphzObj.ToggleIPcheck:GetComponent('UIToggle'):Set(yxphzData.openIp)
	yxphzObj.ToggleGPScheck:GetComponent('UIToggle'):Set(yxphzData.openGps)
	yxphzObj.ToggleIPcheck.parent.gameObject:SetActive(yxphzData.size > 2 and CONST.IPcheckOn)

	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.YXPHZ,yxphzData.rounds,nil,nil)

	YXPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end
--获取当前设置
function this.GetConfig()
	local moneyLess = false
	if ((yxphzData.rounds == 6 or yxphzData.rounds == 8) and info_login.balance < 2) 
	or (yxphzData.rounds == 10 and info_login.balance < 3)
	or (yxphzData.rounds == 16 and info_login.balance < 5) then
        moneyLess = true
    end
    local body = {}
    body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.YXPHZ)
	body.rounds = yxphzData.rounds
    body.size = yxphzData.size
    body.paymentType = yxphzData.paymentType
	body.randomBanker = yxphzData.randomBanker
	body.mode = yxphzData.mode
	body.haveHuMustHu = yxphzData.haveHuMustHu
	body.huangZhuangFen = yxphzData.huangZhuangFen
	body.chou = yxphzData.size == 2 and yxphzData.chou or 0
	body.niao = yxphzData.niao
	body.niaoValue =  yxphzData.niao and yxphzData.niaoValue or 0
	body.openIp	 = yxphzData.openIp
	body.openGps = yxphzData.openGps
	if yxphzData.size == 2 then
		body.resultScore = yxphzData.isSettlementScore
		if yxphzData.isSettlementScore then
			body.resultLowerScore=yxphzData.fewerValue
			body.resultAddScore=yxphzData.addValue
		end
		body.choiceDouble = yxphzData.choiceDouble
        body.doubleScore = yxphzData.doubleScore
        body.multiple = yxphzData.multiple
		body.openIp=false
		body.openGps=false
	end
    body.trusteeship = yxphzData.trusteeshipTime*60
    body.trusteeshipDissolve = yxphzData.trusteeshipType
    body.trusteeshipRound = yxphzData.trusteeshipRound
	body.fanXing = false
	body.qiHuHuXi = 0
    return moneyLess,body
end

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
    if yxphzObj.ToggleRound6.gameObject == go then
        yxphzData.rounds = 6
	elseif yxphzObj.ToggleRound8.gameObject == go then
        yxphzData.rounds = 8
    elseif yxphzObj.ToggleRound10.gameObject == go then
        yxphzData.rounds = 10
    else
        yxphzData.rounds = 16
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.YXPHZ,yxphzData.rounds,nil,nil)
    UnityEngine.PlayerPrefs.SetInt('NewYXPHZrounds', yxphzData.rounds)
end

function this.OnClickTogglePlayerNum(go)
	AudioManager.Instance:PlayAudio('btn')
    if yxphzObj.TogglePeopleNum2.gameObject == go then
        yxphzData.size = 2
    elseif yxphzObj.TogglePeopleNum3.gameObject == go then
		yxphzData.size = 3
	elseif yxphzObj.TogglePeopleNum4.gameObject == go then
        yxphzData.size = 4
    end
	yxphzObj.ToggleChou0.parent.gameObject:SetActive(yxphzData.size == 2)
	yxphzObj.ToggleNoChoiceDouble.parent.gameObject:SetActive(yxphzData.size==2)
	yxphzObj.ToggleMultiple2.parent.gameObject:SetActive(yxphzData.choiceDouble and yxphzData.size == 2)
	yxphzObj.DoubleScoreText.parent.gameObject:SetActive(yxphzData.choiceDouble)
	yxphzObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(yxphzData.size==2)
	yxphzObj.ToggleIPcheck.parent.gameObject:SetActive(yxphzData.size > 2 and CONST.IPcheckOn)
	UnityEngine.PlayerPrefs.SetInt('NewYXPHZsize', yxphzData.size)
    YXPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if yxphzObj.ToggleMasterPay.gameObject == go then
        yxphzData.paymentType=0
    elseif yxphzObj.ToggleWinnerPay.gameObject == go then
        yxphzData.paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewYXPHZpaymentType', yxphzData.paymentType)
end

function this.OnClickRandomBanker(go)
    AudioManager.Instance:PlayAudio('btn')
    if yxphzObj.ToggleRandomBanker.gameObject == go then
        yxphzData.randomBanker = true
    elseif yxphzObj.ToggleBankerFrist.gameObject == go then
        yxphzData.randomBanker = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewYXPHZrandomBanker', yxphzData.randomBanker and 1 or 0)
end
function this.OnClickModeSetting(go)
	AudioManager.Instance:PlayAudio('btn')
    if yxphzObj.ToggleLianZhuang.gameObject == go then
        yxphzData.mode = 0
    elseif yxphzObj.ToggleZhongZhuang.gameObject == go then
        yxphzData.mode = 1
    end
    UnityEngine.PlayerPrefs.SetInt('NewYXPHZmode', yxphzData.mode)
end

function this.OnClickToggleYouHuBiHu(go)
	AudioManager.Instance:PlayAudio('btn')
	yxphzData.haveHuMustHu = yxphzObj.ToggleYouHuBiHu:GetComponent('UIToggle').value
	UnityEngine.PlayerPrefs.SetInt('NewYXPHZhaveHuMustHu', yxphzData.haveHuMustHu and 1 or 0)
end

function this.OnClickChangeHuangZhuangKouFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if yxphzObj.AddBtnHuangZhuangKouFen.gameObject == go then
		yxphzData.huangZhuangFen = yxphzData.huangZhuangFen + 1
		if yxphzData.huangZhuangFen > 10 then
			yxphzData.huangZhuangFen = 10
		end
    else
		yxphzData.huangZhuangFen = yxphzData.huangZhuangFen - 1
		if yxphzData.huangZhuangFen < 0 then
			yxphzData.huangZhuangFen = 0
		end
    end
	yxphzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = yxphzData.huangZhuangFen == 0 and '不扣分' or '扣'..yxphzData.huangZhuangFen..'分'
	UnityEngine.PlayerPrefs.SetInt('NewYXPHZhuangZhuangFen', yxphzData.huangZhuangFen)
end

function this.OnClickToggleChou(go)
	AudioManager.Instance:PlayAudio('btn')
	if yxphzObj.ToggleChou0.gameObject == go then
        yxphzData.chou=0
    elseif yxphzObj.ToggleChou14.gameObject == go then
        yxphzData.chou=14
    elseif yxphzObj.ToggleChou28.gameObject == go then
        yxphzData.chou=28
	end
	UnityEngine.PlayerPrefs.SetInt('NewYXPHZchou', yxphzData.chou)
end

function this.OnClickNiao(go)
	AudioManager.Instance:PlayAudio('btn')
	if yxphzObj.ToggleOnNiao.gameObject == go then
		yxphzData.niao = true
	elseif yxphzObj.ToggleOffNiao.gameObject == go then
		yxphzData.niao = false
	end
	yxphzObj.NiaoValueText.parent.gameObject:SetActive(yxphzData.niao)
	UnityEngine.PlayerPrefs.SetInt('NewYXPHZniao', yxphzData.niao and 1 or 0)
end

function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if yxphzObj.AddButtonNiao.gameObject == go then
		yxphzData.niaoValue = yxphzData.niaoValue + 10
		if yxphzData.niaoValue > 100 then
			yxphzData.niaoValue = 100
		end
	elseif yxphzObj.SubtractButtonNiao.gameObject == go then
		yxphzData.niaoValue = yxphzData.niaoValue - 10
		if yxphzData.niaoValue < 10 then
			yxphzData.niaoValue = 10
		end
	end
	yxphzObj.NiaoValueText:GetComponent('UILabel').text = yxphzData.niaoValue.."分"
	UnityEngine.PlayerPrefs.SetInt('NewYXPHZniaoValue', yxphzData.niaoValue)
end

function this.OnClickChoiceDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if yxphzObj.ToggleChoiceDouble.gameObject == go then
        yxphzData.choiceDouble = true
    elseif yxphzObj.ToggleNoChoiceDouble.gameObject == go then
        yxphzData.choiceDouble = false
    end
    yxphzObj.DoubleScoreText.parent.gameObject:SetActive(yxphzData.choiceDouble)
    yxphzObj.ToggleMultiple2.parent.gameObject:SetActive(yxphzData.choiceDouble)
    YXPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
    UnityEngine.PlayerPrefs.SetInt('NewYXPHZchoiceDouble', yxphzData.choiceDouble and 1 or 0)
end

function this.OnClickChangeDoubleScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if yxphzObj.AddDoubleScoreButton.gameObject == go then
        if yxphzData.doubleScore ~= 0 then
            yxphzData.doubleScore = yxphzData.doubleScore + 1
            if yxphzData.doubleScore > 100 then
                yxphzData.doubleScore = 0
            end
        end
    else
        if yxphzData.doubleScore == 0 then
            yxphzData.doubleScore = 100
        else
            yxphzData.doubleScore = yxphzData.doubleScore - 1
            if yxphzData.doubleScore < 1 then
                yxphzData.doubleScore = 1
            end
        end
    end
    if yxphzData.doubleScore == 0 then
        yxphzObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
    else
        yxphzObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..yxphzData.doubleScore..'分'
    end
    UnityEngine.PlayerPrefs.SetInt('NewYXPHZdoubleScore', yxphzData.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
    if yxphzObj.ToggleMultiple2.gameObject == go then
        yxphzData.multiple=2
    elseif yxphzObj.ToggleMultiple3.gameObject == go then
        yxphzData.multiple=3
    elseif yxphzObj.ToggleMultiple4.gameObject == go then
        yxphzData.multiple=4
    end
    UnityEngine.PlayerPrefs.SetInt('NewYXPHZmultiple', yxphzData.multiple)
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    yxphzData.isSettlementScore= yxphzObj.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewYXPHZisSettlementScore', yxphzData.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if yxphzObj.ToggleFewerAddButton.gameObject == go then
		yxphzData.fewerValue = yxphzData.fewerValue + 1
		if yxphzData.fewerValue > 100 then
			yxphzData.fewerValue = 100
		end
    elseif yxphzObj.ToggleFewerSubtractButton.gameObject == go then
		yxphzData.fewerValue = yxphzData.fewerValue - 1
		if yxphzData.fewerValue < 1 then
			yxphzData.fewerValue = 1
		end
	end
	yxphzObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = yxphzData.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewYXPHZfewerValue', yxphzData.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if yxphzObj.ToggleAddAddButton.gameObject == go then
		yxphzData.addValue = yxphzData.addValue + 1
		if yxphzData.addValue > 100 then
			yxphzData.addValue = 100
		end
    elseif yxphzObj.ToggleAddSubtractButton.gameObject == go then
		yxphzData.addValue = yxphzData.addValue - 1
		if yxphzData.addValue < 1 then
			yxphzData.addValue = 1
		end
	end
	yxphzObj.ToggleAddScoreTxt:GetComponent('UILabel').text = yxphzData.addValue
	UnityEngine.PlayerPrefs.SetInt('NewYXPHZaddValue', yxphzData.addValue)
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if yxphzObj.ToggleTrusteeshipNo.gameObject == go then
        yxphzData.trusteeshipTime = 0
    elseif yxphzObj.ToggleTrusteeship1.gameObject == go then
        yxphzData.trusteeshipTime = 1
	elseif yxphzObj.ToggleTrusteeship2.gameObject == go then
		yxphzData.trusteeshipTime = 2
    elseif yxphzObj.ToggleTrusteeship3.gameObject == go then
        yxphzData.trusteeshipTime = 3
    elseif yxphzObj.ToggleTrusteeship5.gameObject == go then
        yxphzData.trusteeshipTime = 5
	end
    UnityEngine.PlayerPrefs.SetInt('NewYXPHZtrusteeshipTime', yxphzData.trusteeshipTime)
	yxphzObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(yxphzData.trusteeshipTime ~= 0)
	YXPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if yxphzObj.ToggleTrusteeshipOne.gameObject == go then
        yxphzData.trusteeshipType = true
		yxphzData.trusteeshipRound = 0;
    elseif yxphzObj.ToggleTrusteeshipAll.gameObject == go then
        yxphzData.trusteeshipType = false
		yxphzData.trusteeshipRound = 0;
	elseif yxphzObj.ToggleTrusteeshipThree.gameObject == go then
		yxphzData.trusteeshipType = false;
		yxphzData.trusteeshipRound = 3;
    end
    UnityEngine.PlayerPrefs.SetInt('NewYXPHZtrusteeshipType',yxphzData.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewYXPHZtrusteeshipRound',yxphzData.trusteeshipRound )
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if yxphzObj.ToggleIPcheck.gameObject == go then
		yxphzData.openIp = yxphzObj.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('YXPHZcheckIP', yxphzData.openIp and 1 or 0)
	elseif yxphzObj.ToggleGPScheck.gameObject == go then
		yxphzData.openGps = yxphzObj.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('YXPHZcheckGPS', yxphzData.openGps and 1 or 0)
	end
end

return this