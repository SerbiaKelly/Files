local this = {}

local HHHGW
local payLabel

local hhhgwObj = {}
local hhhgwData = {}

function this.Init(grid,message)
	print('Init_HHHGW')
	HHHGW = grid
	payLabel = message.transform:Find('diamond/pay_label')

	hhhgwObj.ToggleRound6 = HHHGW:Find('table/round/round6')
	hhhgwObj.ToggleRound8 = HHHGW:Find('table/round/round8')
	hhhgwObj.ToggleRound10 = HHHGW:Find('table/round/round10')
	hhhgwObj.ToggleRound16 = HHHGW:Find('table/round/round16')
	message:AddClick(hhhgwObj.ToggleRound6.gameObject, this.OnClickToggleRound)
	message:AddClick(hhhgwObj.ToggleRound8.gameObject, this.OnClickToggleRound)
    message:AddClick(hhhgwObj.ToggleRound10.gameObject, this.OnClickToggleRound)
	message:AddClick(hhhgwObj.ToggleRound16.gameObject, this.OnClickToggleRound)

    hhhgwObj.TogglePeopleNum2 = HHHGW:Find('table/num/num2')
	hhhgwObj.TogglePeopleNum3 = HHHGW:Find('table/num/num3')
	message:AddClick(hhhgwObj.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
    message:AddClick(hhhgwObj.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)

	hhhgwObj.ToggleMasterPay = HHHGW:Find('table/pay/master')
	hhhgwObj.ToggleWinnerPay = HHHGW:Find('table/pay/win')
	message:AddClick(hhhgwObj.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(hhhgwObj.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)

	hhhgwObj.ToggleRandomBanker = HHHGW:Find('table/randomBanker/Auto')
	hhhgwObj.ToggleBankerFrist = HHHGW:Find('table/randomBanker/Frist')
	message:AddClick(hhhgwObj.ToggleRandomBanker.gameObject, this.OnClickRandomBanker)
	message:AddClick(hhhgwObj.ToggleBankerFrist.gameObject, this.OnClickRandomBanker)
	
	hhhgwObj.AddBtnDiFen = HHHGW:Find('table/diFen/diFenScore/AddButton')
	hhhgwObj.SubtractBtnDiFen = HHHGW:Find('table/diFen/diFenScore/SubtractButton')
	hhhgwObj.DiFenTunValue = HHHGW:Find('table/diFen/diFenScore/Value')
	message:AddClick(hhhgwObj.AddBtnDiFen.gameObject, this.OnClickChangeDiFenValue)
	message:AddClick(hhhgwObj.SubtractBtnDiFen.gameObject, this.OnClickChangeDiFenValue)

	hhhgwObj.ToggleOldMode = HHHGW:Find('table/mode/oldMode')
	hhhgwObj.Toggle468Mode = HHHGW:Find('table/mode/468Mode')
	message:AddClick(hhhgwObj.ToggleOldMode.gameObject, this.OnClickModeSetting)
	message:AddClick(hhhgwObj.Toggle468Mode.gameObject, this.OnClickModeSetting)

	hhhgwObj.ToggleZiMoHu15 = HHHGW:Find('table/play1/ziMoKeHu15')
	hhhgwObj.ToggleZiMoFan2 = HHHGW:Find('table/play1/ziMoFan2')
	hhhgwObj.ToggleLiangPaiKeHu21 = HHHGW:Find('table/play1/liangPaiKeHu21')
	hhhgwObj.ToggleTianHuFan5 = HHHGW:Find('table/play2/tianHuFan5')
	hhhgwObj.ToggleDiHuFan4 = HHHGW:Find('table/play2/diHuFan4')
	hhhgwObj.Toggle18Da5Fan = HHHGW:Find('table/play2/18Da5Fan')
	hhhgwObj.Toggle16Xiao5Fan = HHHGW:Find('table/play3/16Xiao5Fan')
	message:AddClick(hhhgwObj.ToggleZiMoHu15.gameObject, this.OnClickTogglePlay)
	message:AddClick(hhhgwObj.ToggleZiMoFan2.gameObject, this.OnClickTogglePlay)
	message:AddClick(hhhgwObj.ToggleLiangPaiKeHu21.gameObject, this.OnClickTogglePlay)
	message:AddClick(hhhgwObj.ToggleTianHuFan5.gameObject, this.OnClickTogglePlay)
	message:AddClick(hhhgwObj.ToggleDiHuFan4.gameObject, this.OnClickTogglePlay)
	message:AddClick(hhhgwObj.Toggle18Da5Fan.gameObject, this.OnClickTogglePlay)
	message:AddClick(hhhgwObj.Toggle16Xiao5Fan.gameObject, this.OnClickTogglePlay)

	hhhgwObj.ToggleFengDingScore0 = HHHGW:Find('table/fengDing/fengDingScore0')
	hhhgwObj.ToggleFengDingScore5 = HHHGW:Find('table/fengDing/fengDingScore5')
	hhhgwObj.ToggleFengDingScore10 = HHHGW:Find('table/fengDing/fengDingScore10')
	message:AddClick(hhhgwObj.ToggleFengDingScore0.gameObject, this.OnClickToggleFengDingScore)
	message:AddClick(hhhgwObj.ToggleFengDingScore5.gameObject, this.OnClickToggleFengDingScore)
	message:AddClick(hhhgwObj.ToggleFengDingScore10.gameObject, this.OnClickToggleFengDingScore)

	hhhgwObj.AddBtnHuangZhuangKouFen = HHHGW:Find('table/huangZhuangKouFen/kouScore/AddButton')
	hhhgwObj.SubtractBtnHuangZhuangKouFen = HHHGW:Find('table/huangZhuangKouFen/kouScore/SubtractButton')
	hhhgwObj.HuangZhuangKouFenValue = HHHGW:Find('table/huangZhuangKouFen/kouScore/Value')
	message:AddClick(hhhgwObj.AddBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)
	message:AddClick(hhhgwObj.SubtractBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)

	hhhgwObj.ToggleChou0 = HHHGW:Find('table/chouCard/chouCard0')
	hhhgwObj.ToggleChou10 = HHHGW:Find('table/chouCard/chouCard10')
	hhhgwObj.ToggleChou20 = HHHGW:Find('table/chouCard/chouCard20')
	message:AddClick(hhhgwObj.ToggleChou0.gameObject, this.OnClickToggleChou)
	message:AddClick(hhhgwObj.ToggleChou10.gameObject, this.OnClickToggleChou)
	message:AddClick(hhhgwObj.ToggleChou20.gameObject, this.OnClickToggleChou)

    hhhgwObj.ToggleOnNiao = HHHGW:Find('table/niao/OnNiao')
	hhhgwObj.ToggleOffNiao = HHHGW:Find('table/niao/OffNiao')
	hhhgwObj.NiaoValueText = HHHGW:Find('table/niao/NiaoValue/Value')
	hhhgwObj.AddButtonNiao = HHHGW:Find('table/niao/NiaoValue/AddButton')
	hhhgwObj.SubtractButtonNiao = HHHGW:Find('table/niao/NiaoValue/SubtractButton')
	message:AddClick(hhhgwObj.ToggleOnNiao.gameObject, this.OnClickNiao)
	message:AddClick(hhhgwObj.ToggleOffNiao.gameObject, this.OnClickNiao)
	message:AddClick(hhhgwObj.AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(hhhgwObj.SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)


	hhhgwObj.ToggleChoiceDouble = HHHGW:Find('table/choiceDouble/On')
	hhhgwObj.ToggleNoChoiceDouble = HHHGW:Find('table/choiceDouble/Off')
	hhhgwObj.DoubleScoreText = HHHGW:Find('table/choiceDouble/doubleScore/Value')
	hhhgwObj.AddDoubleScoreButton = HHHGW:Find('table/choiceDouble/doubleScore/AddButton')
	hhhgwObj.SubtractDoubleScoreButton = HHHGW:Find('table/choiceDouble/doubleScore/SubtractButton')
	hhhgwObj.ToggleMultiple2 = HHHGW:Find('table/multiple/2')
	hhhgwObj.ToggleMultiple3 = HHHGW:Find('table/multiple/3')
	hhhgwObj.ToggleMultiple4 = HHHGW:Find('table/multiple/4')
	message:AddClick(hhhgwObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(hhhgwObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(hhhgwObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(hhhgwObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(hhhgwObj.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(hhhgwObj.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(hhhgwObj.ToggleMultiple4.gameObject, this.OnClickMultiple)

	hhhgwObj.ToggleTrusteeshipNo = HHHGW:Find('table/DelegateChoose/NoDelegate')
	hhhgwObj.ToggleTrusteeship1 = HHHGW:Find('table/DelegateChoose/Delegate1')
	hhhgwObj.ToggleTrusteeship2 = HHHGW:Find('table/DelegateChoose/Delegate2')
	hhhgwObj.ToggleTrusteeship3 = HHHGW:Find('table/DelegateChoose/Delegate3')
	hhhgwObj.ToggleTrusteeship5 = HHHGW:Find('table/DelegateChoose/Delegate5')
	hhhgwObj.ToggleTrusteeshipAll = HHHGW:Find('table/DelegateCancel/FullRound')
	hhhgwObj.ToggleTrusteeshipOne = HHHGW:Find('table/DelegateCancel/ThisRound')
	hhhgwObj.ToggleTrusteeshipThree = HHHGW:Find('table/DelegateCancel/ThreeRound')
	message:AddClick(hhhgwObj.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(hhhgwObj.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(hhhgwObj.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(hhhgwObj.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(hhhgwObj.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(hhhgwObj.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(hhhgwObj.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(hhhgwObj.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)
	
	hhhgwObj.ToggleSettlementScoreSelect=HHHGW:Find('table/settlementScore/select')
	hhhgwObj.ToggleFewerScoreTxt=HHHGW:Find('table/settlementScore/fewerValue/Value')
	hhhgwObj.ToggleFewerAddButton=HHHGW:Find('table/settlementScore/fewerValue/AddButton')
	hhhgwObj.ToggleFewerSubtractButton=HHHGW:Find('table/settlementScore/fewerValue/SubtractButton')
	hhhgwObj.ToggleAddScoreTxt=HHHGW:Find('table/settlementScore/addValue/Value')
	hhhgwObj.ToggleAddAddButton=HHHGW:Find('table/settlementScore/addValue/AddButton')
	hhhgwObj.ToggleAddSubtractButton=HHHGW:Find('table/settlementScore/addValue/SubtractButton')
	message:AddClick(hhhgwObj.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(hhhgwObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(hhhgwObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(hhhgwObj.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(hhhgwObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)

	hhhgwObj.ToggleIPcheck = HHHGW:Find('table/PreventCheat/IPcheck')
	hhhgwObj.ToggleGPScheck = HHHGW:Find('table/PreventCheat/GPScheck')
	message:AddClick(hhhgwObj.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(hhhgwObj.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end
function this.Refresh()
	print('Refresh_HHHGW')
	hhhgwData.rounds=UnityEngine.PlayerPrefs.GetInt('NewHHHGWrounds', 6)
	hhhgwObj.ToggleRound6:GetComponent('UIToggle'):Set(hhhgwData.rounds == 6)
	hhhgwObj.ToggleRound8:GetComponent('UIToggle'):Set(hhhgwData.rounds == 8)
	hhhgwObj.ToggleRound10:GetComponent('UIToggle'):Set(hhhgwData.rounds == 10)
	hhhgwObj.ToggleRound16:GetComponent('UIToggle'):Set(hhhgwData.rounds == 16)

	hhhgwData.size=UnityEngine.PlayerPrefs.GetInt('NewHHHGWsize', 3)
	hhhgwObj.TogglePeopleNum2:GetComponent('UIToggle'):Set(hhhgwData.size == 2)
    hhhgwObj.TogglePeopleNum3:GetComponent('UIToggle'):Set(hhhgwData.size == 3)

	hhhgwData.paymentType=UnityEngine.PlayerPrefs.GetInt('NewHHHGWpaymentType', 0)
	hhhgwObj.ToggleMasterPay:GetComponent('UIToggle'):Set(hhhgwData.paymentType == 0)
	hhhgwObj.ToggleWinnerPay:GetComponent('UIToggle'):Set(hhhgwData.paymentType == 2)
	
	hhhgwData.randomBanker=UnityEngine.PlayerPrefs.GetInt('NewHHHGWrandomBanker', 0)==1
	hhhgwObj.ToggleRandomBanker:GetComponent('UIToggle'):Set(hhhgwData.randomBanker)
	hhhgwObj.ToggleBankerFrist:GetComponent('UIToggle'):Set(not hhhgwData.randomBanker)

	hhhgwData.bottomScore=UnityEngine.PlayerPrefs.GetInt('NewHHHGWbottomScore', 1)
	hhhgwObj.DiFenTunValue:GetComponent("UILabel").text = hhhgwData.bottomScore..'分'

	hhhgwData.mode=UnityEngine.PlayerPrefs.GetInt('NewHHHGWmode', 0)
	hhhgwObj.ToggleOldMode:GetComponent('UIToggle'):Set(hhhgwData.mode == 0)
	hhhgwObj.Toggle468Mode:GetComponent('UIToggle'):Set(hhhgwData.mode == 1)

	hhhgwData.canHuZiMo=UnityEngine.PlayerPrefs.GetInt('NewHHHGWcanHuZiMo', 0) == 1
	hhhgwObj.ToggleZiMoHu15:GetComponent('UIToggle'):Set(hhhgwData.canHuZiMo)
	hhhgwData.ziMoFan=UnityEngine.PlayerPrefs.GetInt('NewHHHGWziMoFan', 0)
	hhhgwObj.ToggleZiMoFan2:GetComponent('UIToggle'):Set(hhhgwData.ziMoFan == 2)
	hhhgwData.shiZhongBuLiang=UnityEngine.PlayerPrefs.GetInt('NewHHHGWshiZhongBuLiang', 0) == 1
	hhhgwObj.ToggleLiangPaiKeHu21:GetComponent('UIToggle'):Set(hhhgwData.shiZhongBuLiang)
	hhhgwObj.ToggleTianHuFan5.parent.gameObject:SetActive(hhhgwData.mode == 0)
	hhhgwObj.Toggle16Xiao5Fan.parent.gameObject:SetActive(hhhgwData.mode == 0)
	hhhgwData.tianHu5Fan=UnityEngine.PlayerPrefs.GetInt('NewHHHGWtianHu5Fan', 0) == 1
	hhhgwObj.ToggleTianHuFan5:GetComponent('UIToggle'):Set(hhhgwData.tianHu5Fan)
	hhhgwData.diHu4Fan=UnityEngine.PlayerPrefs.GetInt('NewHHHGWdiHu4Fan', 0) == 1
	hhhgwObj.ToggleDiHuFan4:GetComponent('UIToggle'):Set(hhhgwData.diHu4Fan)
	hhhgwData.da18Fan5=UnityEngine.PlayerPrefs.GetInt('NewHHHGWda18Fan5', 0) == 1
	hhhgwObj.Toggle18Da5Fan:GetComponent('UIToggle'):Set(hhhgwData.da18Fan5)
	hhhgwData.shiLiuXiao=UnityEngine.PlayerPrefs.GetInt('NewHHHGWshiLiuXiao', 0) == 1
	hhhgwObj.Toggle16Xiao5Fan:GetComponent('UIToggle'):Set(hhhgwData.shiLiuXiao)

	hhhgwData.maxHuXi =UnityEngine.PlayerPrefs.GetInt('NewHHHGWmaxHuXi', 0)
	hhhgwObj.ToggleFengDingScore0:GetComponent('UIToggle'):Set(hhhgwData.maxHuXi == 0)
	hhhgwObj.ToggleFengDingScore5:GetComponent('UIToggle'):Set(hhhgwData.maxHuXi == 5)
	hhhgwObj.ToggleFengDingScore10:GetComponent('UIToggle'):Set(hhhgwData.maxHuXi == 10)

	hhhgwData.huangZhuangFen=UnityEngine.PlayerPrefs.GetInt('NewHHHGWhuangZhuangFen', 0) 
	hhhgwObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = hhhgwData.huangZhuangFen == 0 and '不扣分' or '扣'..hhhgwData.huangZhuangFen..'分'
	
	hhhgwData.chou = UnityEngine.PlayerPrefs.GetInt('NewHHHGWchou', 20)
	hhhgwObj.ToggleChou0:GetComponent('UIToggle'):Set(hhhgwData.chou == 0)
	hhhgwObj.ToggleChou10:GetComponent('UIToggle'):Set(hhhgwData.chou == 10)
	hhhgwObj.ToggleChou20:GetComponent('UIToggle'):Set(hhhgwData.chou == 20)
	hhhgwObj.ToggleChou0.parent.gameObject:SetActive(hhhgwData.size == 2)

    hhhgwData.niao=UnityEngine.PlayerPrefs.GetInt('NewHHHGWniao', 0)==1
	hhhgwData.niaoValue=UnityEngine.PlayerPrefs.GetInt('NewHHHGWniaoValue', 10)
	hhhgwObj.ToggleOnNiao:GetComponent('UIToggle'):Set(hhhgwData.niao)
	hhhgwObj.ToggleOffNiao:GetComponent('UIToggle'):Set(not hhhgwData.niao)
	hhhgwObj.NiaoValueText.parent.gameObject:SetActive(hhhgwData.niao)
    hhhgwObj.NiaoValueText:GetComponent('UILabel').text = hhhgwData.niaoValue.."分"

	hhhgwData.choiceDouble=UnityEngine.PlayerPrefs.GetInt('NewHHHGWchoiceDouble', 0)==1
	hhhgwData.doubleScore=UnityEngine.PlayerPrefs.GetInt('NewHHHGWdoubleScore', 10)
	hhhgwData.multiple=UnityEngine.PlayerPrefs.GetInt('NewHHHGWmultiple', 2)
	hhhgwObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(hhhgwData.choiceDouble)
	hhhgwObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not hhhgwData.choiceDouble)
	hhhgwObj.DoubleScoreText.parent.gameObject:SetActive(hhhgwData.choiceDouble)
	if hhhgwData.doubleScore == 0 then
		hhhgwObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		hhhgwObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..hhhgwData.doubleScore..'分'
	end
	hhhgwObj.ToggleChoiceDouble.parent.gameObject:SetActive(hhhgwData.size == 2)
	hhhgwObj.ToggleMultiple2:GetComponent('UIToggle'):Set(hhhgwData.multiple == 2)
	hhhgwObj.ToggleMultiple3:GetComponent('UIToggle'):Set(hhhgwData.multiple == 3)
	hhhgwObj.ToggleMultiple4:GetComponent('UIToggle'):Set(hhhgwData.multiple == 4)
	hhhgwObj.ToggleMultiple2.parent.gameObject:SetActive(hhhgwData.choiceDouble and  hhhgwData.size == 2)

    hhhgwData.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewHHHGWisSettlementScore', 0)==1
	hhhgwData.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewHHHGWfewerValue', 10)
	hhhgwData.addValue=UnityEngine.PlayerPrefs.GetInt('NewHHHGWaddValue', 10)
	hhhgwObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(hhhgwData.size==2)
    hhhgwObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(hhhgwData.isSettlementScore)
	hhhgwObj.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	hhhgwObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = hhhgwData.fewerValue
	hhhgwObj.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	hhhgwObj.ToggleAddScoreTxt:GetComponent('UILabel').text = hhhgwData.addValue

	hhhgwData.trusteeshipTime=UnityEngine.PlayerPrefs.GetInt('NewHHHGWtrusteeshipTime', 0)
	hhhgwData.trusteeshipType = UnityEngine.PlayerPrefs.GetInt('NewHHHGWtrusteeshipType', 0) == 1
	hhhgwData.trusteeshipRound = UnityEngine.PlayerPrefs.GetInt('NewHHHGWtrusteeshipRound', 0)
	hhhgwObj.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(hhhgwData.trusteeshipTime == 0)
	hhhgwObj.ToggleTrusteeship1:GetComponent('UIToggle'):Set(hhhgwData.trusteeshipTime == 1)
	hhhgwObj.ToggleTrusteeship2:GetComponent('UIToggle'):Set(hhhgwData.trusteeshipTime == 2)
	hhhgwObj.ToggleTrusteeship3:GetComponent('UIToggle'):Set(hhhgwData.trusteeshipTime == 3)
	hhhgwObj.ToggleTrusteeship5:GetComponent('UIToggle'):Set(hhhgwData.trusteeshipTime == 5)
	hhhgwObj.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(hhhgwData.trusteeshipType)
	hhhgwObj.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not hhhgwData.trusteeshipType and hhhgwData.trusteeshipRound == 0)
    hhhgwObj.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(hhhgwData.trusteeshipRound == 3);
	hhhgwObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(hhhgwData.trusteeshipTime ~= 0)

	hhhgwData.openIp=UnityEngine.PlayerPrefs.GetInt('HHHGWcheckIP', 0)==1
	hhhgwData.openGps=UnityEngine.PlayerPrefs.GetInt('HHHGWcheckGPS', 0)==1
	hhhgwObj.ToggleIPcheck.parent.gameObject:SetActive(hhhgwData.size > 2 and CONST.IPcheckOn)
	hhhgwObj.ToggleIPcheck:GetComponent('UIToggle'):Set(hhhgwData.openIp)
	hhhgwObj.ToggleGPScheck:GetComponent('UIToggle'):Set(hhhgwData.openGps)

	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.HHHGW,hhhgwData.rounds,nil,nil)
    HHHGW:Find('table'):GetComponent('UIGrid'):Reposition()
end
--获取当前设置
function this.GetConfig()
	local moneyLess = false
    if ((hhhgwData.rounds == 6 or hhhgwData.rounds == 8) and info_login.balance < 2) or
        (hhhgwData.rounds == 10 and info_login.balance < 3 )  or 
        (hhhgwData.rounds == 16 and info_login.balance < 4 ) then
        moneyLess = true
    end
    local body = {}
    body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.HHHGW)
    body.rounds = hhhgwData.rounds
    body.size = hhhgwData.size
    body.paymentType = hhhgwData.paymentType
    body.randomBanker = hhhgwData.randomBanker
    body.qiHuHuXi = 15
    body.tianDiHu = true
    body.heiHongHu = true
    body.tunXi = 3
	body.fanXing = false
	body.bottomScore = hhhgwData.bottomScore
	body.mode = hhhgwData.mode
	body.canHuZiMo = hhhgwData.canHuZiMo
	body.ziMoFan = hhhgwData.ziMoFan
	body.shiZhongBuLiang = hhhgwData.shiZhongBuLiang
	if hhhgwData.mode == 0 then
		body.tianHu5Fan = hhhgwData.tianHu5Fan
		body.diHu4Fan = hhhgwData.diHu4Fan
		body.da18Fan5 = hhhgwData.da18Fan5
		body.shiLiuXiao = hhhgwData.shiLiuXiao
	end
	body.maxHuXi = hhhgwData.maxHuXi
	body.huangZhuangFen = hhhgwData.huangZhuangFen
	body.niao = hhhgwData.niao
    body.niaoValue =  hhhgwData.niao and hhhgwData.niaoValue or 0
	if hhhgwData.size == 2 then
		body.choiceDouble = hhhgwData.choiceDouble
        body.doubleScore = hhhgwData.doubleScore
        body.multiple = hhhgwData.multiple
		body.resultScore = hhhgwData.isSettlementScore
		if hhhgwData.isSettlementScore then
			body.resultLowerScore=hhhgwData.fewerValue
			body.resultAddScore=hhhgwData.addValue
		end
		hhhgwData.openIp=false
		hhhgwData.openGps=false
	end
	body.chou = hhhgwData.size == 2 and hhhgwData.chou or 0
	body.trusteeship = hhhgwData.trusteeshipTime*60
    body.trusteeshipDissolve = hhhgwData.trusteeshipType
    body.trusteeshipRound = hhhgwData.trusteeshipRound
	body.openIp	 = hhhgwData.openIp
	body.openGps = hhhgwData.openGps
	
    return moneyLess,body;
end

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
    if hhhgwObj.ToggleRound6.gameObject == go then
		hhhgwData.rounds = 6
	elseif hhhgwObj.ToggleRound8.gameObject == go then
        hhhgwData.rounds = 8
    elseif hhhgwObj.ToggleRound10.gameObject == go then
        hhhgwData.rounds = 10
    elseif hhhgwObj.ToggleRound16.gameObject == go then
        hhhgwData.rounds = 16
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.HHHGW,hhhgwData.rounds,nil,nil)
    UnityEngine.PlayerPrefs.SetInt('NewHHHGWrounds', hhhgwData.rounds)
end

function this.OnClickTogglePlayerNum(go)
	AudioManager.Instance:PlayAudio('btn')
    if hhhgwObj.TogglePeopleNum2.gameObject == go then
        hhhgwData.size = 2
    elseif hhhgwObj.TogglePeopleNum3.gameObject == go then
        hhhgwData.size = 3
	end
	hhhgwObj.ToggleIPcheck.parent.gameObject:SetActive(hhhgwData.size > 2 and CONST.IPcheckOn)
	UnityEngine.PlayerPrefs.SetInt('NewHHHGWsize', hhhgwData.size)
	hhhgwObj.ToggleNoChoiceDouble.parent.gameObject:SetActive(hhhgwData.size==2)
    hhhgwObj.ToggleMultiple2.parent.gameObject:SetActive(hhhgwData.choiceDouble and hhhgwData.size==2)
    hhhgwObj.DoubleScoreText.parent.gameObject:SetActive(hhhgwData.choiceDouble)
	hhhgwObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(hhhgwData.size==2)
	hhhgwObj.ToggleChou0.parent.gameObject:SetActive(hhhgwData.size==2)
    HHHGW:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if hhhgwObj.ToggleMasterPay.gameObject == go then
        hhhgwData.paymentType=0
    elseif hhhgwObj.ToggleWinnerPay.gameObject == go then
        hhhgwData.paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewHHHGWpaymentType', hhhgwData.paymentType)
end

function this.OnClickRandomBanker(go)
    AudioManager.Instance:PlayAudio('btn')
    if hhhgwObj.ToggleRandomBanker.gameObject == go then
        hhhgwData.randomBanker = true
    elseif hhhgwObj.ToggleBankerFrist.gameObject == go then
        hhhgwData.randomBanker = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewHHHGWrandomBanker', hhhgwData.randomBanker and 1 or 0)
end

function this.OnClickChangeDiFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if hhhgwObj.AddBtnDiFen.gameObject == go then
		hhhgwData.bottomScore = hhhgwData.bottomScore + 1
		if hhhgwData.bottomScore > 10 then
			hhhgwData.bottomScore = 10
		end
    elseif hhhgwObj.SubtractBtnDiFen.gameObject == go then
        hhhgwData.bottomScore = hhhgwData.bottomScore - 1
		if hhhgwData.bottomScore < 1 then
			hhhgwData.bottomScore = 1
		end
	end
	hhhgwObj.DiFenTunValue:GetComponent("UILabel").text = hhhgwData.bottomScore..'分'
    UnityEngine.PlayerPrefs.SetInt('NewHHHGWbottomScore', hhhgwData.bottomScore)
end

function this.OnClickModeSetting(go)
	AudioManager.Instance:PlayAudio('btn')
    if hhhgwObj.ToggleOldMode.gameObject == go then
        hhhgwData.mode = 0
	elseif hhhgwObj.Toggle468Mode.gameObject == go then
        hhhgwData.mode = 1
	end
	hhhgwObj.ToggleTianHuFan5.parent.gameObject:SetActive(hhhgwData.mode == 0)
	hhhgwObj.Toggle16Xiao5Fan.parent.gameObject:SetActive(hhhgwData.mode == 0)
	HHHGW:Find('table'):GetComponent('UIGrid'):Reposition()
	UnityEngine.PlayerPrefs.SetInt('NewHHHGWmode', hhhgwData.mode)
end

function this.OnClickTogglePlay(go)
	AudioManager.Instance:PlayAudio('btn')
	if hhhgwObj.ToggleZiMoHu15.gameObject == go then
		hhhgwData.canHuZiMo = hhhgwObj.ToggleZiMoHu15:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewHHHGWcanHuZiMo', hhhgwData.canHuZiMo and 1 or 0)
	elseif hhhgwObj.ToggleZiMoFan2.gameObject == go then
		if hhhgwObj.ToggleZiMoFan2:GetComponent('UIToggle').value then
			hhhgwData.ziMoFan = 2
		else
			hhhgwData.ziMoFan = 0
		end
		UnityEngine.PlayerPrefs.SetInt('NewHHHGWziMoFan', hhhgwData.ziMoFan)
	elseif hhhgwObj.ToggleLiangPaiKeHu21.gameObject == go then
		hhhgwData.shiZhongBuLiang = hhhgwObj.ToggleLiangPaiKeHu21:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewHHHGWshiZhongBuLiang', hhhgwData.shiZhongBuLiang and 1 or 0)
	elseif hhhgwObj.ToggleTianHuFan5.gameObject == go then
		hhhgwData.tianHu5Fan = hhhgwObj.ToggleTianHuFan5:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewHHHGWtianHu5Fan', hhhgwData.tianHu5Fan and 1 or 0)
	elseif hhhgwObj.ToggleDiHuFan4.gameObject == go then
		hhhgwData.diHu4Fan = hhhgwObj.ToggleDiHuFan4:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewHHHGWdiHu4Fan', hhhgwData.diHu4Fan and 1 or 0)
	elseif hhhgwObj.Toggle18Da5Fan.gameObject == go then
		hhhgwData.da18Fan5 = hhhgwObj.Toggle18Da5Fan:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewHHHGWda18Fan5', hhhgwData.da18Fan5 and 1 or 0)
	elseif hhhgwObj.Toggle16Xiao5Fan.gameObject == go then
		hhhgwData.shiLiuXiao = hhhgwObj.Toggle16Xiao5Fan:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewHHHGWshiLiuXiao', hhhgwData.shiLiuXiao and 1 or 0)
	end
end
	
function this.OnClickToggleFengDingScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if hhhgwObj.ToggleFengDingScore0.gameObject == go then
        hhhgwData.maxHuXi = 0
	elseif hhhgwObj.ToggleFengDingScore5.gameObject == go then
        hhhgwData.maxHuXi = 5
    elseif hhhgwObj.ToggleFengDingScore10.gameObject == go then
		hhhgwData.maxHuXi = 10
	end
	UnityEngine.PlayerPrefs.SetInt('NewHHHGWmaxHuXi', hhhgwData.maxHuXi)
end

function this.OnClickChangeHuangZhuangKouFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if hhhgwObj.AddBtnHuangZhuangKouFen.gameObject == go then
		hhhgwData.huangZhuangFen = hhhgwData.huangZhuangFen + 1
		if hhhgwData.huangZhuangFen > 10 then
			hhhgwData.huangZhuangFen = 10
		end
    else
		hhhgwData.huangZhuangFen = hhhgwData.huangZhuangFen - 1
		if hhhgwData.huangZhuangFen < 0 then
			hhhgwData.huangZhuangFen = 0
		end
    end
	hhhgwObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = hhhgwData.huangZhuangFen == 0 and '不扣分' or '扣'..hhhgwData.huangZhuangFen..'分'
	UnityEngine.PlayerPrefs.SetInt('NewHHHGWhuangZhuangFen', hhhgwData.huangZhuangFen)
end

function this.OnClickToggleChou(go)
	AudioManager.Instance:PlayAudio('btn')
	if hhhgwObj.ToggleChou0.gameObject == go then
        hhhgwData.chou=0
    elseif hhhgwObj.ToggleChou10.gameObject == go then
        hhhgwData.chou=10
    elseif hhhgwObj.ToggleChou20.gameObject == go then
        hhhgwData.chou=20
	end
	UnityEngine.PlayerPrefs.SetInt('NewHHHGWchou', hhhgwData.chou)
end

function this.OnClickNiao(go)
	AudioManager.Instance:PlayAudio('btn')
	if hhhgwObj.ToggleOnNiao.gameObject == go then
		hhhgwData.niao = true
	elseif hhhgwObj.ToggleOffNiao.gameObject == go then
		hhhgwData.niao = false
	end
	hhhgwObj.NiaoValueText.parent.gameObject:SetActive(hhhgwData.niao)
	UnityEngine.PlayerPrefs.SetInt('NewHHHGWniao', hhhgwData.niao and 1 or 0)
	
end

function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if hhhgwObj.AddButtonNiao.gameObject == go then
		hhhgwData.niaoValue = hhhgwData.niaoValue + 10
		if hhhgwData.niaoValue > 100 then
			hhhgwData.niaoValue = 100
		end
	elseif hhhgwObj.SubtractButtonNiao.gameObject == go then
		hhhgwData.niaoValue = hhhgwData.niaoValue - 10
		if hhhgwData.niaoValue < 10 then
			hhhgwData.niaoValue = 10
		end
	end
	hhhgwObj.NiaoValueText:GetComponent('UILabel').text = hhhgwData.niaoValue.."分"
	UnityEngine.PlayerPrefs.SetInt('NewHHHGWniaoValue', hhhgwData.niaoValue)
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if hhhgwObj.ToggleTrusteeshipNo.gameObject == go then
        hhhgwData.trusteeshipTime = 0
    elseif hhhgwObj.ToggleTrusteeship1.gameObject == go then
        hhhgwData.trusteeshipTime = 1
    elseif hhhgwObj.ToggleTrusteeship2.gameObject == go then
        hhhgwData.trusteeshipTime = 2
    elseif hhhgwObj.ToggleTrusteeship3.gameObject == go then
        hhhgwData.trusteeshipTime = 3
    elseif hhhgwObj.ToggleTrusteeship5.gameObject == go then
        hhhgwData.trusteeshipTime = 5
    end
    UnityEngine.PlayerPrefs.SetInt('NewHHHGWtrusteeshipTime', hhhgwData.trusteeshipTime)
    hhhgwObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(hhhgwData.trusteeshipTime ~= 0)
    HHHGW:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if hhhgwObj.ToggleTrusteeshipOne.gameObject == go then
        hhhgwData.trusteeshipType = true
        hhhgwData.trusteeshipRound = 0;
    elseif hhhgwObj.ToggleTrusteeshipAll.gameObject == go then
        hhhgwData.trusteeshipType = false
        hhhgwData.trusteeshipRound = 0;
    elseif hhhgwObj.ToggleTrusteeshipThree.gameObject == go then
        hhhgwData.trusteeshipType = false;
        hhhgwData.trusteeshipRound = 3;
    end
    UnityEngine.PlayerPrefs.SetInt('NewHHHGWtrusteeshipType',hhhgwData.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewHHHGWtrusteeshipRound',hhhgwData.trusteeshipRound)
end

function this.OnClickChoiceDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if hhhgwObj.ToggleChoiceDouble.gameObject == go then
        hhhgwData.choiceDouble = true
    elseif hhhgwObj.ToggleNoChoiceDouble.gameObject == go then
        hhhgwData.choiceDouble = false
    end
    hhhgwObj.DoubleScoreText.parent.gameObject:SetActive(hhhgwData.choiceDouble)
    hhhgwObj.ToggleMultiple2.parent.gameObject:SetActive(hhhgwData.choiceDouble)
    HHHGW:Find('table'):GetComponent('UIGrid'):Reposition()
    UnityEngine.PlayerPrefs.SetInt('NewHHHGWchoiceDouble', hhhgwData.choiceDouble and 1 or 0)
end

function this.OnClickChangeDoubleScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if hhhgwObj.AddDoubleScoreButton.gameObject == go then
        if hhhgwData.doubleScore ~= 0 then
            hhhgwData.doubleScore = hhhgwData.doubleScore + 1
            if hhhgwData.doubleScore > 100 then
                hhhgwData.doubleScore = 0
            end
        end
    else
        if hhhgwData.doubleScore == 0 then
            hhhgwData.doubleScore = 100
        else
            hhhgwData.doubleScore = hhhgwData.doubleScore - 1
            if hhhgwData.doubleScore < 1 then
                hhhgwData.doubleScore = 1
            end
        end
    end
    if hhhgwData.doubleScore == 0 then
        hhhgwObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
    else
        hhhgwObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..hhhgwData.doubleScore..'分'
    end
    UnityEngine.PlayerPrefs.SetInt('NewHHHGWdoubleScore', hhhgwData.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
    if hhhgwObj.ToggleMultiple2.gameObject == go then
        hhhgwData.multiple=2
    elseif hhhgwObj.ToggleMultiple3.gameObject == go then
        hhhgwData.multiple=3
    elseif hhhgwObj.ToggleMultiple4.gameObject == go then
        hhhgwData.multiple=4
    end
    UnityEngine.PlayerPrefs.SetInt('NewHHHGWmultiple', hhhgwData.multiple)
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    hhhgwData.isSettlementScore= hhhgwObj.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewHHHGWisSettlementScore', hhhgwData.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if hhhgwObj.ToggleFewerAddButton.gameObject == go then
		hhhgwData.fewerValue = hhhgwData.fewerValue + 1
		if hhhgwData.fewerValue > 100 then
			hhhgwData.fewerValue = 100
		end
    elseif hhhgwObj.ToggleFewerSubtractButton.gameObject == go then
		hhhgwData.fewerValue = hhhgwData.fewerValue - 1
		if hhhgwData.fewerValue < 1 then
			hhhgwData.fewerValue = 1
		end
	end
	hhhgwObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = hhhgwData.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewHHHGWfewerValue', hhhgwData.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if hhhgwObj.ToggleAddAddButton.gameObject == go then
		hhhgwData.addValue = hhhgwData.addValue + 1
		if hhhgwData.addValue > 100 then
			hhhgwData.addValue = 100
		end
    elseif hhhgwObj.ToggleAddSubtractButton.gameObject == go then
		hhhgwData.addValue = hhhgwData.addValue - 1
		if hhhgwData.addValue < 1 then
			hhhgwData.addValue = 1
		end
	end
	hhhgwObj.ToggleAddScoreTxt:GetComponent('UILabel').text = hhhgwData.addValue
	UnityEngine.PlayerPrefs.SetInt('NewHHHGWaddValue', hhhgwData.addValue)
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if hhhgwObj.ToggleIPcheck.gameObject == go then
		hhhgwData.openIp = hhhgwObj.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('HHHGWcheckIP', hhhgwData.openIp and 1 or 0)
	elseif hhhgwObj.ToggleGPScheck.gameObject == go then
		hhhgwData.openGps = hhhgwObj.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('HHHGWcheckGPS', hhhgwData.openGps and 1 or 0)
	end
end

return this