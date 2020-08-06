local this = {}

local CSPHZ
local payLabel

local csphzData = {}
local csphzObj= {}

function this.Init(grid,message)
	print('Init_CSPHZ')
	CSPHZ = grid
	payLabel = message.transform:Find('diamond/pay_label')

	csphzObj.ToggleRound6 = CSPHZ:Find('table/round/round6')
	csphzObj.ToggleRound8 = CSPHZ:Find('table/round/round8')
	csphzObj.ToggleRound10 = CSPHZ:Find('table/round/round10')
	csphzObj.ToggleRound16 = CSPHZ:Find('table/round/round16')
	message:AddClick(csphzObj.ToggleRound6.gameObject, this.OnClickToggleRound)
	message:AddClick(csphzObj.ToggleRound8.gameObject, this.OnClickToggleRound)
    message:AddClick(csphzObj.ToggleRound10.gameObject, this.OnClickToggleRound)
	message:AddClick(csphzObj.ToggleRound16.gameObject, this.OnClickToggleRound)

	csphzObj.TogglePeopleNum2 = CSPHZ:Find('table/num/num2')
	csphzObj.TogglePeopleNum3 = CSPHZ:Find('table/num/num3')
	message:AddClick(csphzObj.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
    message:AddClick(csphzObj.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)

	csphzObj.ToggleMasterPay = CSPHZ:Find('table/pay/master')
	csphzObj.ToggleWinnerPay = CSPHZ:Find('table/pay/win')
	message:AddClick(csphzObj.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(csphzObj.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)
	
	csphzObj.ToggleRandomBanker = CSPHZ:Find('table/randomBanker/Auto')
	csphzObj.ToggleBankerFrist = CSPHZ:Find('table/randomBanker/Frist')
	message:AddClick(csphzObj.ToggleRandomBanker.gameObject, this.OnClickRandomBanker)
	message:AddClick(csphzObj.ToggleBankerFrist.gameObject, this.OnClickRandomBanker)

	csphzObj.ToggleZiMoFan0 = CSPHZ:Find('table/zimofan/zimofan0')
	csphzObj.ToggleZiMoFan1 = CSPHZ:Find('table/zimofan/zimofan1')
	csphzObj.ToggleZiMoFan2 = CSPHZ:Find('table/zimofan/zimofan2')
	message:AddClick(csphzObj.ToggleZiMoFan0.gameObject, this.OnClickToggleZiMoFan)
	message:AddClick(csphzObj.ToggleZiMoFan1.gameObject, this.OnClickToggleZiMoFan)
	message:AddClick(csphzObj.ToggleZiMoFan2.gameObject, this.OnClickToggleZiMoFan)

	csphzObj.AddBtnDiFen = CSPHZ:Find('table/diFen/diFenScore/AddButton')
	csphzObj.SubtractBtnDiFen = CSPHZ:Find('table/diFen/diFenScore/SubtractButton')
	csphzObj.DiFenTunValue = CSPHZ:Find('table/diFen/diFenScore/Value')
	message:AddClick(csphzObj.AddBtnDiFen.gameObject, this.OnClickChangeDiFenValue)
	message:AddClick(csphzObj.SubtractBtnDiFen.gameObject, this.OnClickChangeDiFenValue)

	csphzObj.AddBtnZhaNiao = CSPHZ:Find('table/zhaNiao/zhaNiaoScore/AddButton')
	csphzObj.SubtractBtnZhaNiao = CSPHZ:Find('table/zhaNiao/zhaNiaoScore/SubtractButton')
	csphzObj.ZhaNiaoValue = CSPHZ:Find('table/zhaNiao/zhaNiaoScore/Value')
	message:AddClick(csphzObj.AddBtnZhaNiao.gameObject, this.OnClickChangeZhaNiaoValue)
	message:AddClick(csphzObj.SubtractBtnZhaNiao.gameObject, this.OnClickChangeZhaNiaoValue)

	csphzObj.ToggleFengDingScore0 = CSPHZ:Find('table/fengDing/0')
	csphzObj.ToggleFengDingScore5 = CSPHZ:Find('table/fengDing/5')
	csphzObj.ToggleFengDingScore10 = CSPHZ:Find('table/fengDing/10')
	message:AddClick(csphzObj.ToggleFengDingScore0.gameObject, this.OnClickToggleFengDingScore)
	message:AddClick(csphzObj.ToggleFengDingScore5.gameObject, this.OnClickToggleFengDingScore)
	message:AddClick(csphzObj.ToggleFengDingScore10.gameObject, this.OnClickToggleFengDingScore)

	csphzObj.AddBtnHuangZhuangKouFen = CSPHZ:Find('table/huangZhuangKouFen/kouScore/AddButton')
	csphzObj.SubtractBtnHuangZhuangKouFen = CSPHZ:Find('table/huangZhuangKouFen/kouScore/SubtractButton')
	csphzObj.HuangZhuangKouFenValue = CSPHZ:Find('table/huangZhuangKouFen/kouScore/Value')
	message:AddClick(csphzObj.AddBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)
	message:AddClick(csphzObj.SubtractBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)

	csphzObj.ToggleChou0 = CSPHZ:Find('table/chouCard/chouCard0')
	csphzObj.ToggleChou10 = CSPHZ:Find('table/chouCard/chouCard10')
	csphzObj.ToggleChou20 = CSPHZ:Find('table/chouCard/chouCard20')
	message:AddClick(csphzObj.ToggleChou0.gameObject, this.OnClickToggleChou)
	message:AddClick(csphzObj.ToggleChou10.gameObject, this.OnClickToggleChou)
	message:AddClick(csphzObj.ToggleChou20.gameObject, this.OnClickToggleChou)

	csphzObj.ToggleOnNiao = CSPHZ:Find('table/niao/OnNiao')
	csphzObj.ToggleOffNiao = CSPHZ:Find('table/niao/OffNiao')
	csphzObj.NiaoValueText = CSPHZ:Find('table/niao/NiaoValue/Value')
	csphzObj.AddButtonNiao = CSPHZ:Find('table/niao/NiaoValue/AddButton')
	csphzObj.SubtractButtonNiao = CSPHZ:Find('table/niao/NiaoValue/SubtractButton')
	message:AddClick(csphzObj.ToggleOnNiao.gameObject, this.OnClickNiao)
	message:AddClick(csphzObj.ToggleOffNiao.gameObject, this.OnClickNiao)
	message:AddClick(csphzObj.AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(csphzObj.SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)

	csphzObj.ToggleChoiceDouble = CSPHZ:Find('table/choiceDouble/On')
	csphzObj.ToggleNoChoiceDouble = CSPHZ:Find('table/choiceDouble/Off')
	csphzObj.DoubleScoreText = CSPHZ:Find('table/choiceDouble/doubleScore/Value')
	csphzObj.AddDoubleScoreButton = CSPHZ:Find('table/choiceDouble/doubleScore/AddButton')
	csphzObj.SubtractDoubleScoreButton = CSPHZ:Find('table/choiceDouble/doubleScore/SubtractButton')
	csphzObj.ToggleMultiple2 = CSPHZ:Find('table/multiple/2')
	csphzObj.ToggleMultiple3 = CSPHZ:Find('table/multiple/3')
	csphzObj.ToggleMultiple4 = CSPHZ:Find('table/multiple/4')
	message:AddClick(csphzObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(csphzObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(csphzObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(csphzObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(csphzObj.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(csphzObj.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(csphzObj.ToggleMultiple4.gameObject, this.OnClickMultiple)

	csphzObj.ToggleSettlementScoreSelect=CSPHZ:Find('table/settlementScore/select')
	csphzObj.ToggleFewerScoreTxt=CSPHZ:Find('table/settlementScore/fewerValue/Value')
	csphzObj.ToggleFewerAddButton=CSPHZ:Find('table/settlementScore/fewerValue/AddButton')
	csphzObj.ToggleFewerSubtractButton=CSPHZ:Find('table/settlementScore/fewerValue/SubtractButton')
	csphzObj.ToggleAddScoreTxt=CSPHZ:Find('table/settlementScore/addValue/Value')
	csphzObj.ToggleAddAddButton=CSPHZ:Find('table/settlementScore/addValue/AddButton')
	csphzObj.ToggleAddSubtractButton=CSPHZ:Find('table/settlementScore/addValue/SubtractButton')
	message:AddClick(csphzObj.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(csphzObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(csphzObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(csphzObj.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(csphzObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)

    csphzObj.ToggleTrusteeshipNo = CSPHZ:Find('table/DelegateChoose/NoDelegate')
	csphzObj.ToggleTrusteeship1 = CSPHZ:Find('table/DelegateChoose/Delegate1')
	csphzObj.ToggleTrusteeship2 = CSPHZ:Find('table/DelegateChoose/Delegate2')
	csphzObj.ToggleTrusteeship3 = CSPHZ:Find('table/DelegateChoose/Delegate3')
	csphzObj.ToggleTrusteeship5 = CSPHZ:Find('table/DelegateChoose1/Delegate5')
	csphzObj.ToggleTrusteeshipAll = CSPHZ:Find('table/DelegateCancel/FullRound')
	csphzObj.ToggleTrusteeshipOne = CSPHZ:Find('table/DelegateCancel/ThisRound')
	csphzObj.ToggleTrusteeshipThree = CSPHZ:Find('table/DelegateCancel/ThreeRound')
	message:AddClick(csphzObj.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(csphzObj.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(csphzObj.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(csphzObj.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(csphzObj.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(csphzObj.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(csphzObj.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(csphzObj.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)
	
	csphzObj.ToggleIPcheck = CSPHZ:Find('table/PreventCheat/IPcheck')
	csphzObj.ToggleGPScheck = CSPHZ:Find('table/PreventCheat/GPScheck')
	message:AddClick(csphzObj.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(csphzObj.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end
function this.Refresh()
	print('Refresh_CSPHZ')
	csphzData.rounds=UnityEngine.PlayerPrefs.GetInt('NewCSPHZrounds', 8)
	csphzObj.ToggleRound6:GetComponent('UIToggle'):Set(csphzData.rounds == 6)
	csphzObj.ToggleRound8:GetComponent('UIToggle'):Set(csphzData.rounds == 8)
	csphzObj.ToggleRound10:GetComponent('UIToggle'):Set(csphzData.rounds == 10)
	csphzObj.ToggleRound16:GetComponent('UIToggle'):Set(csphzData.rounds == 16)

	csphzData.size=UnityEngine.PlayerPrefs.GetInt('NewCSPHZsize', 3)
	csphzObj.TogglePeopleNum2:GetComponent('UIToggle'):Set(csphzData.size == 2)
	csphzObj.TogglePeopleNum3:GetComponent('UIToggle'):Set(csphzData.size == 3)
	
	csphzData.paymentType=UnityEngine.PlayerPrefs.GetInt('NewCSPHZpaymentType', 0)
	csphzObj.ToggleMasterPay:GetComponent('UIToggle'):Set(csphzData.paymentType == 0)
	csphzObj.ToggleWinnerPay:GetComponent('UIToggle'):Set(csphzData.paymentType == 2)

	csphzData.randomBanker=UnityEngine.PlayerPrefs.GetInt('NewCSPHZrandomBanker', 0)==1
	csphzObj.ToggleRandomBanker:GetComponent('UIToggle'):Set(csphzData.randomBanker)
	csphzObj.ToggleBankerFrist:GetComponent('UIToggle'):Set(not csphzData.randomBanker)

	csphzData.ziMoFan=UnityEngine.PlayerPrefs.GetInt('NewCSPHZziMoFan', 0)
	csphzObj.ToggleZiMoFan0:GetComponent('UIToggle'):Set(csphzData.ziMoFan == 0)
	csphzObj.ToggleZiMoFan1:GetComponent('UIToggle'):Set(csphzData.ziMoFan == 1)
	csphzObj.ToggleZiMoFan2:GetComponent('UIToggle'):Set(csphzData.ziMoFan == 2)

	csphzData.bottomScore=UnityEngine.PlayerPrefs.GetInt('NewCSPHZbottomScore', 1)
	csphzObj.DiFenTunValue:GetComponent("UILabel").text = csphzData.bottomScore..'分'

	csphzData.zhaNiao =UnityEngine.PlayerPrefs.GetInt('NewCSPHZzhaNiao', 0)
	csphzObj.ZhaNiaoValue:GetComponent("UILabel").text = csphzData.zhaNiao == 0 and '不扎鸟' or (csphzData.zhaNiao..'分')

	csphzData.maxHuXi =UnityEngine.PlayerPrefs.GetInt('NewCSPHZmaxHuXi', 0)
	csphzObj.ToggleFengDingScore0:GetComponent('UIToggle'):Set(csphzData.maxHuXi == 0)
	csphzObj.ToggleFengDingScore5:GetComponent('UIToggle'):Set(csphzData.maxHuXi == 5)
	csphzObj.ToggleFengDingScore10:GetComponent('UIToggle'):Set(csphzData.maxHuXi == 10)

	csphzData.huangZhuangFen=UnityEngine.PlayerPrefs.GetInt('NewCSPHZhuangZhuangFen', 0) 
	csphzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = csphzData.huangZhuangFen == 0 and '不扣分' or '扣'..csphzData.huangZhuangFen..'分'

	csphzData.chou = UnityEngine.PlayerPrefs.GetInt('NewCSPHZchou', 20)
	csphzObj.ToggleChou0:GetComponent('UIToggle'):Set(csphzData.chou == 0)
	csphzObj.ToggleChou10:GetComponent('UIToggle'):Set(csphzData.chou == 10)
	csphzObj.ToggleChou20:GetComponent('UIToggle'):Set(csphzData.chou == 20)
	csphzObj.ToggleChou0.parent.gameObject:SetActive(csphzData.size == 2)

	csphzData.niao=UnityEngine.PlayerPrefs.GetInt('NewCSPHZniao', 0)==1
	csphzData.niaoValue=UnityEngine.PlayerPrefs.GetInt('NewCSPHZniaoValue', 10)
	csphzObj.ToggleOnNiao:GetComponent('UIToggle'):Set(csphzData.niao)
	csphzObj.ToggleOffNiao:GetComponent('UIToggle'):Set(not csphzData.niao)
	csphzObj.NiaoValueText.parent.gameObject:SetActive(csphzData.niao)
	csphzObj.NiaoValueText:GetComponent('UILabel').text = csphzData.niaoValue.."分"

	csphzData.choiceDouble=UnityEngine.PlayerPrefs.GetInt('NewCSPHZchoiceDouble', 0)==1
	csphzData.doubleScore=UnityEngine.PlayerPrefs.GetInt('NewCSPHZdoubleScore', 10)
	csphzData.multiple=UnityEngine.PlayerPrefs.GetInt('NewCSPHZmultiple', 2)
	csphzObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(csphzData.choiceDouble)
	csphzObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not csphzData.choiceDouble)
	csphzObj.DoubleScoreText.parent.gameObject:SetActive(csphzData.choiceDouble)
	if csphzData.doubleScore == 0 then
		csphzObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		csphzObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..csphzData.doubleScore..'分'
	end
	csphzObj.ToggleChoiceDouble.parent.gameObject:SetActive(csphzData.size == 2)
	csphzObj.ToggleIPcheck.parent.gameObject:SetActive(csphzData.size > 2 and CONST.IPcheckOn)
	csphzObj.ToggleMultiple2:GetComponent('UIToggle'):Set(csphzData.multiple == 2)
	csphzObj.ToggleMultiple3:GetComponent('UIToggle'):Set(csphzData.multiple == 3)
	csphzObj.ToggleMultiple4:GetComponent('UIToggle'):Set(csphzData.multiple == 4)
	csphzObj.ToggleMultiple2.parent.gameObject:SetActive(csphzData.choiceDouble and  csphzData.size == 2)

	csphzData.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewCSPHZisSettlementScore', 0)==1
	csphzData.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewCSPHZfewerValue', 10)
	csphzData.addValue=UnityEngine.PlayerPrefs.GetInt('NewCSPHZaddValue', 10)
	csphzObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(csphzData.size==2)
	csphzObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(csphzData.isSettlementScore)
	csphzObj.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	csphzObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = csphzData.fewerValue
	csphzObj.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	csphzObj.ToggleAddScoreTxt:GetComponent('UILabel').text = csphzData.addValue

	csphzData.trusteeshipTime=UnityEngine.PlayerPrefs.GetInt('NewCSPHZtrusteeshipTime', 0)
	csphzData.trusteeshipType = UnityEngine.PlayerPrefs.GetInt('NewCSPHZtrusteeshipType', 0) == 1
	csphzData.trusteeshipRound = UnityEngine.PlayerPrefs.GetInt('NewCSPHZtrusteeshipRound', 0)
	csphzObj.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(csphzData.trusteeshipTime == 0)
	csphzObj.ToggleTrusteeship1:GetComponent('UIToggle'):Set(csphzData.trusteeshipTime == 1)
	csphzObj.ToggleTrusteeship2:GetComponent('UIToggle'):Set(csphzData.trusteeshipTime == 2)
	csphzObj.ToggleTrusteeship3:GetComponent('UIToggle'):Set(csphzData.trusteeshipTime == 3)
	csphzObj.ToggleTrusteeship5:GetComponent('UIToggle'):Set(csphzData.trusteeshipTime == 5)
	csphzObj.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(csphzData.trusteeshipType)
	csphzObj.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not csphzData.trusteeshipType and csphzData.trusteeshipRound == 0)
	csphzObj.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(csphzData.trusteeshipRound == 3)
	csphzObj.ToggleTrusteeshipOne.parent.gameObject:SetActive( csphzData.trusteeshipTime ~= 0)

	csphzData.openIp=UnityEngine.PlayerPrefs.GetInt('CSPHZcheckIP', 0)==1
	csphzData.openGps=UnityEngine.PlayerPrefs.GetInt('CSPHZcheckGPS', 0)==1
	csphzObj.ToggleIPcheck:GetComponent('UIToggle'):Set(csphzData.openIp)
	csphzObj.ToggleGPScheck:GetComponent('UIToggle'):Set(csphzData.openGps)

	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.CSPHZ,csphzData.rounds,nil,nil)
	CSPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end
--获取当前设置
function this.GetConfig()
	local moneyLess = false
    if ((csphzData.rounds == 6 or csphzData.rounds == 8) and info_login.balance < 2) or
        (csphzData.rounds == 10 and info_login.balance < 3 )  or 
        (csphzData.rounds == 16 and info_login.balance < 4 ) then
        moneyLess = true
    end

    local body = {}
    body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.CSPHZ)
	body.rounds = csphzData.rounds
    body.size = csphzData.size
    body.paymentType = csphzData.paymentType
	body.randomBanker = csphzData.randomBanker
	body.tianDiHu = true
	body.heiHongHu = true
	body.qiHuHuXi = 15
	body.tunXi = 3
	body.fanXing = false
	body.ziMoFan = csphzData.ziMoFan
	body.bottomScore = csphzData.bottomScore
	body.zhaNiao = csphzData.zhaNiao
	body.maxHuXi = csphzData.maxHuXi
	body.huangZhuangFen = csphzData.huangZhuangFen
	body.chou = csphzData.size == 2 and csphzData.chou or 0
	body.niao = csphzData.niao
	body.niaoValue =  csphzData.niao and csphzData.niaoValue or 0
	if csphzData.size == 2 then
        body.choiceDouble = csphzData.choiceDouble
        body.doubleScore = csphzData.doubleScore
        body.multiple = csphzData.multiple
    end
	if csphzData.size == 2 then
		body.resultScore = csphzData.isSettlementScore
		if csphzData.isSettlementScore then
			body.resultLowerScore=csphzData.fewerValue
			body.resultAddScore=csphzData.addValue
		end
		csphzData.openIp=false
		csphzData.openGps=false
	end
    body.trusteeship = csphzData.trusteeshipTime*60;
    body.trusteeshipDissolve = csphzData.trusteeshipType
    body.trusteeshipRound = csphzData.trusteeshipRound
	body.openIp	 = csphzData.openIp
	body.openGps = csphzData.openGps

    return moneyLess,body
end

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
    if csphzObj.ToggleRound6.gameObject == go then
		csphzData.rounds = 6
	elseif csphzObj.ToggleRound8.gameObject == go then
        csphzData.rounds = 8
    elseif csphzObj.ToggleRound10.gameObject == go then
        csphzData.rounds = 10
    elseif csphzObj.ToggleRound16.gameObject == go then
        csphzData.rounds = 16
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.CSPHZ,csphzData.rounds,nil,nil)
    UnityEngine.PlayerPrefs.SetInt('NewCSPHZrounds', csphzData.rounds)
end

function this.OnClickTogglePlayerNum(go)
	AudioManager.Instance:PlayAudio('btn')
    if csphzObj.TogglePeopleNum2.gameObject == go then
        csphzData.size = 2
    elseif csphzObj.TogglePeopleNum3.gameObject == go then
        csphzData.size = 3
	end
	csphzObj.ToggleIPcheck.parent.gameObject:SetActive(csphzData.size > 2 and CONST.IPcheckOn)
	UnityEngine.PlayerPrefs.SetInt('NewCSPHZsize', csphzData.size)
	csphzObj.ToggleNoChoiceDouble.parent.gameObject:SetActive(csphzData.size==2)
    csphzObj.ToggleMultiple2.parent.gameObject:SetActive(csphzData.choiceDouble and csphzData.size==2)
	csphzObj.DoubleScoreText.parent.gameObject:SetActive(csphzData.choiceDouble)
	csphzObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(csphzData.size==2)
	csphzObj.ToggleChou0.parent.gameObject:SetActive(csphzData.size == 2)
    CSPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if csphzObj.ToggleMasterPay.gameObject == go then
        csphzData.paymentType=0
    elseif csphzObj.ToggleWinnerPay.gameObject == go then
        csphzData.paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewCSPHZpaymentType', csphzData.paymentType)
end

function this.OnClickRandomBanker(go)
    AudioManager.Instance:PlayAudio('btn')
    if csphzObj.ToggleRandomBanker.gameObject == go then
        csphzData.randomBanker = true
    elseif csphzObj.ToggleBankerFrist.gameObject == go then
        csphzData.randomBanker = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewCSPHZrandomBanker', csphzData.randomBanker and 1 or 0)
end

function this.OnClickToggleZiMoFan(go)
	AudioManager.Instance:PlayAudio('btn')
	if csphzObj.ToggleZiMoFan0.gameObject == go then
        csphzData.ziMoFan = 0
    elseif csphzObj.ToggleZiMoFan1.gameObject == go then
        csphzData.ziMoFan = 1
	elseif csphzObj.ToggleZiMoFan2.gameObject == go then
		csphzData.ziMoFan = 2
    end
	UnityEngine.PlayerPrefs.SetInt('NewCSPHZziMoFan',csphzData.ziMoFan)
end

function this.OnClickChangeDiFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if csphzObj.AddBtnDiFen.gameObject == go then
		csphzData.bottomScore = csphzData.bottomScore + 1
		if csphzData.bottomScore > 10 then
			csphzData.bottomScore = 10
		end
    elseif csphzObj.SubtractBtnDiFen.gameObject == go then
        csphzData.bottomScore = csphzData.bottomScore - 1
		if csphzData.bottomScore < 1 then
			csphzData.bottomScore = 1
		end
	end
	csphzObj.DiFenTunValue:GetComponent("UILabel").text = csphzData.bottomScore..'分'
    UnityEngine.PlayerPrefs.SetInt('NewCSPHZbottomScore', csphzData.bottomScore)
end

function this.OnClickChangeZhaNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if csphzObj.AddBtnZhaNiao.gameObject == go then
		csphzData.zhaNiao = csphzData.zhaNiao + 1
		if csphzData.zhaNiao > 10 then
			csphzData.zhaNiao = 10
		end
    else
		csphzData.zhaNiao = csphzData.zhaNiao - 1
		if csphzData.zhaNiao < 0 then
			csphzData.zhaNiao = 0
		end
    end
	csphzObj.ZhaNiaoValue:GetComponent("UILabel").text = csphzData.zhaNiao == 0 and '不扎鸟' or (csphzData.zhaNiao..'分')
	UnityEngine.PlayerPrefs.SetInt('NewCSPHZzhaNiao', csphzData.zhaNiao)
end

function this.OnClickToggleFengDingScore(go)
	AudioManager.Instance:PlayAudio('btn')
	csphzData.maxHuXi = tonumber(go.name)
	UnityEngine.PlayerPrefs.SetInt('NewCSPHZmaxHuXi', csphzData.maxHuXi)
end

function this.OnClickChangeHuangZhuangKouFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if csphzObj.AddBtnHuangZhuangKouFen.gameObject == go then
		csphzData.huangZhuangFen = csphzData.huangZhuangFen + 1
		if csphzData.huangZhuangFen > 10 then
			csphzData.huangZhuangFen = 10
		end
    else
		csphzData.huangZhuangFen = csphzData.huangZhuangFen - 1
		if csphzData.huangZhuangFen < 0 then
			csphzData.huangZhuangFen = 0
		end
    end
	csphzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = csphzData.huangZhuangFen == 0 and '不扣分' or '扣'..csphzData.huangZhuangFen..'分'
	UnityEngine.PlayerPrefs.SetInt('NewCSPHZhuangZhuangFen', csphzData.huangZhuangFen)
end

function this.OnClickToggleChou(go)
	AudioManager.Instance:PlayAudio('btn')
	if csphzObj.ToggleChou0.gameObject == go then
        csphzData.chou=0
    elseif csphzObj.ToggleChou10.gameObject == go then
        csphzData.chou=10
    elseif csphzObj.ToggleChou20.gameObject == go then
        csphzData.chou=20
	end
	UnityEngine.PlayerPrefs.SetInt('NewCSPHZchou', csphzData.chou)
end

function this.OnClickNiao(go)
	AudioManager.Instance:PlayAudio('btn')
	if csphzObj.ToggleOnNiao.gameObject == go then
		csphzData.niao = true
	elseif csphzObj.ToggleOffNiao.gameObject == go then
		csphzData.niao = false
	end
	csphzObj.NiaoValueText.parent.gameObject:SetActive(csphzData.niao)
	UnityEngine.PlayerPrefs.SetInt('NewCSPHZniao', csphzData.niao and 1 or 0)
	
end

function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if csphzObj.AddButtonNiao.gameObject == go then
		csphzData.niaoValue = csphzData.niaoValue + 10
		if csphzData.niaoValue > 100 then
			csphzData.niaoValue = 100
		end
	elseif csphzObj.SubtractButtonNiao.gameObject == go then
		csphzData.niaoValue = csphzData.niaoValue - 10
		if csphzData.niaoValue < 10 then
			csphzData.niaoValue = 10
		end
	end
	csphzObj.NiaoValueText:GetComponent('UILabel').text = csphzData.niaoValue.."分"
	UnityEngine.PlayerPrefs.SetInt('NewCSPHZniaoValue', csphzData.niaoValue)
end

function this.OnClickChoiceDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if csphzObj.ToggleChoiceDouble.gameObject == go then
        csphzData.choiceDouble = true
    elseif csphzObj.ToggleNoChoiceDouble.gameObject == go then
        csphzData.choiceDouble = false
    end
    csphzObj.DoubleScoreText.parent.gameObject:SetActive(csphzData.choiceDouble)
    csphzObj.ToggleMultiple2.parent.gameObject:SetActive(csphzData.choiceDouble)
    CSPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
    UnityEngine.PlayerPrefs.SetInt('NewCSPHZchoiceDouble', csphzData.choiceDouble and 1 or 0)
end

function this.OnClickChangeDoubleScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if csphzObj.AddDoubleScoreButton.gameObject == go then
        if csphzData.doubleScore ~= 0 then
			csphzData.doubleScore = csphzData.doubleScore + 1
            if csphzData.doubleScore > 100 then
                csphzData.doubleScore = 0
            end
        end
    else
        if csphzData.doubleScore == 0 then
            csphzData.doubleScore = 100
        else
            csphzData.doubleScore = csphzData.doubleScore - 1
            if csphzData.doubleScore < 1 then
                csphzData.doubleScore = 1
            end
        end
    end
    if csphzData.doubleScore == 0 then
        csphzObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
    else
        csphzObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..csphzData.doubleScore..'分'
    end
    UnityEngine.PlayerPrefs.SetInt('NewCSPHZdoubleScore', csphzData.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
    if csphzObj.ToggleMultiple2.gameObject == go then
        csphzData.multiple=2
    elseif csphzObj.ToggleMultiple3.gameObject == go then
        csphzData.multiple=3
    elseif csphzObj.ToggleMultiple4.gameObject == go then
        csphzData.multiple=4
    end
    UnityEngine.PlayerPrefs.SetInt('NewCSPHZmultiple', csphzData.multiple)
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    csphzData.isSettlementScore= csphzObj.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewCSPHZisSettlementScore', csphzData.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if csphzObj.ToggleFewerAddButton.gameObject == go then
		csphzData.fewerValue = csphzData.fewerValue + 1
		if csphzData.fewerValue > 100 then
			csphzData.fewerValue = 100
		end
    elseif csphzObj.ToggleFewerSubtractButton.gameObject == go then
		csphzData.fewerValue = csphzData.fewerValue - 1
		if csphzData.fewerValue < 1 then
			csphzData.fewerValue = 1
		end
	end
	csphzObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = csphzData.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewCSPHZfewerValue', csphzData.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if csphzObj.ToggleAddAddButton.gameObject == go then
		csphzData.addValue = csphzData.addValue + 1
		if csphzData.addValue > 100 then
			csphzData.addValue = 100
		end
    elseif csphzObj.ToggleAddSubtractButton.gameObject == go then
		csphzData.addValue = csphzData.addValue - 1
		if csphzData.addValue < 1 then
			csphzData.addValue = 1
		end
	end
	csphzObj.ToggleAddScoreTxt:GetComponent('UILabel').text = csphzData.addValue
	UnityEngine.PlayerPrefs.SetInt('NewCSPHZaddValue', csphzData.addValue)
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if csphzObj.ToggleTrusteeshipNo.gameObject == go then
        csphzData.trusteeshipTime = 0
    elseif csphzObj.ToggleTrusteeship1.gameObject == go then
        csphzData.trusteeshipTime = 1
	elseif csphzObj.ToggleTrusteeship2.gameObject == go then
		csphzData.trusteeshipTime = 2
	elseif csphzObj.ToggleTrusteeship3.gameObject == go then
        csphzData.trusteeshipTime = 3
    elseif csphzObj.ToggleTrusteeship5.gameObject == go then
        csphzData.trusteeshipTime = 5
    end
    UnityEngine.PlayerPrefs.SetInt('NewCSPHZtrusteeshipTime', csphzData.trusteeshipTime)
	csphzObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(csphzData.trusteeshipTime ~= 0)
	CSPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if csphzObj.ToggleTrusteeshipOne.gameObject == go then
		csphzData.trusteeshipType = true
		csphzData.trusteeshipRound = 0;
    elseif csphzObj.ToggleTrusteeshipAll.gameObject == go then
        csphzData.trusteeshipType = false
		csphzData.trusteeshipRound = 0;
	elseif csphzObj.ToggleTrusteeshipThree.gameObject == go then
		csphzData.trusteeshipRound = 3;
		csphzData.trusteeshipType = false;
    end
    UnityEngine.PlayerPrefs.SetInt('NewCSPHZtrusteeshipType',csphzData.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewCSPHZtrusteeshipRound',csphzData.trusteeshipRound)
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if csphzObj.ToggleIPcheck.gameObject == go then
		csphzData.openIp = csphzObj.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('CSPHZcheckIP', csphzData.openIp and 1 or 0)
	elseif csphzObj.ToggleGPScheck.gameObject == go then
		csphzData.openGps = csphzObj.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('CSPHZcheckGPS', csphzData.openGps and 1 or 0)
	end
end

return this