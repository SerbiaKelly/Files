local this = {}

local AHPHZ
local payLabel

local ahphzObj = {}
local ahphzData = {}
 
function this.Init(grid,message)
	print('Init_AHPHZ')
	AHPHZ = grid
	payLabel = message.transform:Find('diamond/pay_label')
	--局数
	ahphzObj.ToggleRound1 = AHPHZ:Find('table/round/grid/round1')
	ahphzObj.ToggleRound6 = AHPHZ:Find('table/round/grid/round6')
	ahphzObj.ToggleRound8 = AHPHZ:Find('table/round/grid/round8')
	ahphzObj.ToggleRound10 = AHPHZ:Find('table/round/grid/round10')
	ahphzObj.ToggleRound16 = AHPHZ:Find('table/round/grid/round16')
	message:AddClick(ahphzObj.ToggleRound1.gameObject, this.OnClickToggleRound)
	message:AddClick(ahphzObj.ToggleRound6.gameObject, this.OnClickToggleRound)
	message:AddClick(ahphzObj.ToggleRound8.gameObject, this.OnClickToggleRound)
	message:AddClick(ahphzObj.ToggleRound10.gameObject, this.OnClickToggleRound)
	message:AddClick(ahphzObj.ToggleRound16.gameObject, this.OnClickToggleRound)
	--玩家个数
	ahphzObj.TogglePeopleNum2 = AHPHZ:Find('table/num/num2')
	ahphzObj.TogglePeopleNum3 = AHPHZ:Find('table/num/num3')
	message:AddClick(ahphzObj.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(ahphzObj.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)
	--支付方式
	ahphzObj.ToggleMasterPay = AHPHZ:Find('table/pay/master')
	ahphzObj.ToggleWinnerPay = AHPHZ:Find('table/pay/win')
	message:AddClick(ahphzObj.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(ahphzObj.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)
	--坐庄
	ahphzObj.ToggleRandomBanker = AHPHZ:Find('table/randomBanker/Auto')
	ahphzObj.ToggleBankerFrist = AHPHZ:Find('table/randomBanker/Frist')
	message:AddClick(ahphzObj.ToggleRandomBanker.gameObject, this.OnClickRandomBanker)
	message:AddClick(ahphzObj.ToggleBankerFrist.gameObject, this.OnClickRandomBanker)
	--算分 
	ahphzObj.ToggleHuStep3 = AHPHZ:Find('table/hustep/step3')
	ahphzObj.ToggleHuStep1 = AHPHZ:Find('table/hustep/step1') 
	message:AddClick(ahphzObj.ToggleHuStep3.gameObject, this.OnClickToggleHuStep)
	message:AddClick(ahphzObj.ToggleHuStep1.gameObject, this.OnClickToggleHuStep)
	--底分
	ahphzObj.AddBtnDiFen = AHPHZ:Find('table/diFen/diFenScore/AddButton')
	ahphzObj.SubtractBtnDiFen = AHPHZ:Find('table/diFen/diFenScore/SubtractButton')
	ahphzObj.DiFenTunValue = AHPHZ:Find('table/diFen/diFenScore/Value')
	message:AddClick(ahphzObj.AddBtnDiFen.gameObject, this.OnClickChangeDiFenValue)
	message:AddClick(ahphzObj.SubtractBtnDiFen.gameObject, this.OnClickChangeDiFenValue)
	--玩法
	ahphzObj.TogglePapo = AHPHZ:Find('table/hutype/paPo')
	ahphzObj.ToggleHong = AHPHZ:Find('table/hutype/honghei')
	ahphzObj.ToggleZiMoAdd1Tun = AHPHZ:Find('table/hutype/ziMoAddTun')
	ahphzObj.ToggleTian = AHPHZ:Find('table/hutype/tian')
	ahphzObj.ToggleDi = AHPHZ:Find('table/hutype/di')
	ahphzObj.ToggleHaiDi = AHPHZ:Find('table/hutype/haidi')
	message:AddClick(ahphzObj.TogglePapo.gameObject, this.OnClickTogglePlay)
	message:AddClick(ahphzObj.ToggleHong.gameObject, this.OnClickTogglePlay)
	message:AddClick(ahphzObj.ToggleZiMoAdd1Tun.gameObject, this.OnClickTogglePlay)
	message:AddClick(ahphzObj.ToggleTian.gameObject, this.OnClickTogglePlay)
	message:AddClick(ahphzObj.ToggleDi.gameObject, this.OnClickTogglePlay)
	message:AddClick(ahphzObj.ToggleHaiDi.gameObject, this.OnClickTogglePlay)
	--荒庄
	ahphzObj.AddBtnHuangZhuangKouFen = AHPHZ:Find('table/huangZhuangKouFen/kouScore/AddButton')
	ahphzObj.SubtractBtnHuangZhuangKouFen = AHPHZ:Find('table/huangZhuangKouFen/kouScore/SubtractButton')
	ahphzObj.HuangZhuangKouFenValue = AHPHZ:Find('table/huangZhuangKouFen/kouScore/Value')
	message:AddClick(ahphzObj.AddBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)
	message:AddClick(ahphzObj.SubtractBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)
	ahphzObj.ContinueBanker = AHPHZ:Find('table/huangZhuangKouFen/continueBanker')
	message:AddClick(ahphzObj.ContinueBanker.gameObject, this.OnClickContinueBanker)
	--抽牌 
	ahphzObj.ToggleChou0 = AHPHZ:Find('table/chouCard/chouCard0')
	ahphzObj.ToggleChou10 = AHPHZ:Find('table/chouCard/chouCard10')
	ahphzObj.ToggleChou20 = AHPHZ:Find('table/chouCard/chouCard20')
	message:AddClick(ahphzObj.ToggleChou0.gameObject, this.OnClickToggleChou)
	message:AddClick(ahphzObj.ToggleChou10.gameObject, this.OnClickToggleChou)
	message:AddClick(ahphzObj.ToggleChou20.gameObject, this.OnClickToggleChou) 
	--打鸟
	ahphzObj.ToggleOnNiao = AHPHZ:Find('table/niao/OnNiao')
	ahphzObj.ToggleOffNiao = AHPHZ:Find('table/niao/OffNiao')
	ahphzObj.NiaoValueText = AHPHZ:Find('table/niao/NiaoValue/Value')
	ahphzObj.AddButtonNiao = AHPHZ:Find('table/niao/NiaoValue/AddButton')
	ahphzObj.SubtractButtonNiao = AHPHZ:Find('table/niao/NiaoValue/SubtractButton')
	message:AddClick(ahphzObj.ToggleOnNiao.gameObject, this.OnClickNiao)
	message:AddClick(ahphzObj.ToggleOffNiao.gameObject, this.OnClickNiao)
	message:AddClick(ahphzObj.AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(ahphzObj.SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	--翻倍
	ahphzObj.ToggleChoiceDouble = AHPHZ:Find('table/choiceDouble/On')
	ahphzObj.ToggleNoChoiceDouble = AHPHZ:Find('table/choiceDouble/Off')
	ahphzObj.DoubleScoreText = AHPHZ:Find('table/choiceDouble/doubleScore/Value')
	ahphzObj.AddDoubleScoreButton = AHPHZ:Find('table/choiceDouble/doubleScore/AddButton')
	ahphzObj.SubtractDoubleScoreButton = AHPHZ:Find('table/choiceDouble/doubleScore/SubtractButton')
	ahphzObj.ToggleMultiple2 = AHPHZ:Find('table/multiple/2')
	ahphzObj.ToggleMultiple3 = AHPHZ:Find('table/multiple/3')
	ahphzObj.ToggleMultiple4 = AHPHZ:Find('table/multiple/4')
	message:AddClick(ahphzObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(ahphzObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(ahphzObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(ahphzObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(ahphzObj.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(ahphzObj.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(ahphzObj.ToggleMultiple4.gameObject, this.OnClickMultiple)
	--结算
	ahphzObj.ToggleSettlementScoreSelect=AHPHZ:Find('table/settlementScore/select')
	ahphzObj.ToggleFewerScoreTxt=AHPHZ:Find('table/settlementScore/fewerValue/Value')
	ahphzObj.ToggleFewerAddButton=AHPHZ:Find('table/settlementScore/fewerValue/AddButton')
	ahphzObj.ToggleFewerSubtractButton=AHPHZ:Find('table/settlementScore/fewerValue/SubtractButton')
	ahphzObj.ToggleAddScoreTxt=AHPHZ:Find('table/settlementScore/addValue/Value')
	ahphzObj.ToggleAddAddButton=AHPHZ:Find('table/settlementScore/addValue/AddButton')
	ahphzObj.ToggleAddSubtractButton=AHPHZ:Find('table/settlementScore/addValue/SubtractButton')
	message:AddClick(ahphzObj.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(ahphzObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(ahphzObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(ahphzObj.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(ahphzObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)
	--托管
	ahphzObj.ToggleTrusteeshipNo = AHPHZ:Find('table/DelegateChoose/NoDelegate')
	ahphzObj.ToggleTrusteeship1 = AHPHZ:Find('table/DelegateChoose/Delegate1')
	ahphzObj.ToggleTrusteeship2 = AHPHZ:Find('table/DelegateChoose/Delegate2')
	ahphzObj.ToggleTrusteeship3 = AHPHZ:Find('table/DelegateChoose/Delegate3')
	ahphzObj.ToggleTrusteeship5 = AHPHZ:Find('table/DelegateChoose/Delegate5')
	ahphzObj.ToggleTrusteeshipAll = AHPHZ:Find('table/DelegateCancel/FullRound')
	ahphzObj.ToggleTrusteeshipOne = AHPHZ:Find('table/DelegateCancel/ThisRound')
	ahphzObj.ToggleTrusteeshipThree = AHPHZ:Find('table/DelegateCancel/ThreeRound')
	message:AddClick(ahphzObj.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ahphzObj.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ahphzObj.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ahphzObj.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ahphzObj.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ahphzObj.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(ahphzObj.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(ahphzObj.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)
	--地址检测
	ahphzObj.ToggleIPcheck = AHPHZ:Find('table/PreventCheat/IPcheck')
	ahphzObj.ToggleGPScheck = AHPHZ:Find('table/PreventCheat/GPScheck')
	message:AddClick(ahphzObj.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(ahphzObj.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end


function this.Refresh()
	print('Refresh_AHPHZ')
	ahphzData.rounds=UnityEngine.PlayerPrefs.GetInt('NewAHPHZrounds', 8)
	ahphzObj.ToggleRound1:GetComponent('UIToggle'):Set(ahphzData.rounds == 1)
	ahphzObj.ToggleRound6:GetComponent('UIToggle'):Set(ahphzData.rounds == 6)
	ahphzObj.ToggleRound8:GetComponent('UIToggle'):Set(ahphzData.rounds == 8)
	ahphzObj.ToggleRound10:GetComponent('UIToggle'):Set(ahphzData.rounds == 10)
	ahphzObj.ToggleRound16:GetComponent('UIToggle'):Set(ahphzData.rounds == 16)

	ahphzData.size=UnityEngine.PlayerPrefs.GetInt('NewAHPHZsize', 2)
	ahphzObj.TogglePeopleNum2:GetComponent('UIToggle'):Set(ahphzData.size == 2)
	ahphzObj.TogglePeopleNum3:GetComponent('UIToggle'):Set(ahphzData.size == 3)
	
	ahphzData.paymentType=UnityEngine.PlayerPrefs.GetInt('NewAHPHZpaymentType', 0)
	ahphzObj.ToggleMasterPay:GetComponent('UIToggle'):Set(ahphzData.paymentType == 0)
	ahphzObj.ToggleWinnerPay:GetComponent('UIToggle'):Set(ahphzData.paymentType == 2)

	ahphzData.randomBanker=UnityEngine.PlayerPrefs.GetInt('NewAHPHZrandomBanker', 0)==1
	ahphzObj.ToggleRandomBanker:GetComponent('UIToggle'):Set(ahphzData.randomBanker)
	ahphzObj.ToggleBankerFrist:GetComponent('UIToggle'):Set(not ahphzData.randomBanker)
	
	ahphzData.huStepNum=UnityEngine.PlayerPrefs.GetInt('NewAHPHZhuStepNum', 3) 
	ahphzObj.ToggleHuStep3:GetComponent('UIToggle'):Set(ahphzData.huStepNum == 3)
	ahphzObj.ToggleHuStep1:GetComponent('UIToggle'):Set(ahphzData.huStepNum == 1)
	
	ahphzData.bottomScore=UnityEngine.PlayerPrefs.GetInt('NewAHPHZbottomScore', 1)
	ahphzObj.DiFenTunValue:GetComponent("UILabel").text = ahphzData.bottomScore..'分'
	
	--玩法
	ahphzData.paPo=UnityEngine.PlayerPrefs.GetInt('NewAHPHZpaPo', 0) == 1
	ahphzObj.TogglePapo:GetComponent('UIToggle'):Set(ahphzData.paPo)
	ahphzData.hong=UnityEngine.PlayerPrefs.GetInt('NewAHPHZhong', 1) == 1
	ahphzObj.ToggleHong:GetComponent('UIToggle'):Set(ahphzData.hong)
	ahphzData.ziMoAddTun=UnityEngine.PlayerPrefs.GetInt('NewAHPHZziMoAddTun', 1) == 1
	ahphzObj.ToggleZiMoAdd1Tun:GetComponent('UIToggle'):Set(ahphzData.ziMoAddTun)
	ahphzData.tianhu=UnityEngine.PlayerPrefs.GetInt('NewAHPHZtianhu', 0) == 1
	ahphzObj.ToggleTian:GetComponent('UIToggle'):Set(ahphzData.tianhu)
	ahphzData.dihu=UnityEngine.PlayerPrefs.GetInt('NewAHPHZdihu', 0) == 1 
	ahphzObj.ToggleDi:GetComponent('UIToggle'):Set(ahphzData.dihu)
	ahphzData.haiDiHu=UnityEngine.PlayerPrefs.GetInt('NewAHPHZhaiDiHu', 0) == 1
	ahphzObj.ToggleHaiDi:GetComponent('UIToggle'):Set(ahphzData.haiDiHu)
	--荒庄
	ahphzData.huangZhuangFen=UnityEngine.PlayerPrefs.GetInt('NewAHPHZhuangZhuangFen', 0) 
	ahphzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = ahphzData.huangZhuangFen == 0 and '不扣分' or '扣'..ahphzData.huangZhuangFen..'分'
	ahphzData.huangKeepBanker=UnityEngine.PlayerPrefs.GetInt('NewAHPHZhuangKeepBanker', 0) == 1
	ahphzObj.ContinueBanker:GetComponent('UIToggle'):Set(ahphzData.huangKeepBanker)
	
	ahphzData.chou = UnityEngine.PlayerPrefs.GetInt('NewAHPHZchou', 20)
	ahphzObj.ToggleChou0:GetComponent('UIToggle'):Set(ahphzData.chou == 0)
	ahphzObj.ToggleChou10:GetComponent('UIToggle'):Set(ahphzData.chou == 10)
	ahphzObj.ToggleChou20:GetComponent('UIToggle'):Set(ahphzData.chou == 20)
	ahphzObj.ToggleChou0.parent.gameObject:SetActive(ahphzData.size == 2)

	ahphzData.niao=UnityEngine.PlayerPrefs.GetInt('NewAHPHZniao', 0)==1
	ahphzData.niaoValue=UnityEngine.PlayerPrefs.GetInt('NewAHPHZniaoValue', 10)
	ahphzObj.ToggleOnNiao:GetComponent('UIToggle'):Set(ahphzData.niao)
	ahphzObj.ToggleOffNiao:GetComponent('UIToggle'):Set(not ahphzData.niao)
	ahphzObj.NiaoValueText.parent.gameObject:SetActive(ahphzData.niao)
    ahphzObj.NiaoValueText:GetComponent('UILabel').text = ahphzData.niaoValue.."分"

	ahphzData.choiceDouble=UnityEngine.PlayerPrefs.GetInt('NewAHPHZchoiceDouble', 0)==1
	ahphzData.doubleScore=UnityEngine.PlayerPrefs.GetInt('NewAHPHZdoubleScore', 10)
	ahphzData.multiple=UnityEngine.PlayerPrefs.GetInt('NewAHPHZmultiple', 2)
	ahphzObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(ahphzData.choiceDouble)
	ahphzObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not ahphzData.choiceDouble)
	ahphzObj.DoubleScoreText.parent.gameObject:SetActive(ahphzData.choiceDouble)
	if ahphzData.doubleScore == 0 then
		ahphzObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		ahphzObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..ahphzData.doubleScore..'分'
	end
	ahphzObj.ToggleChoiceDouble.parent.gameObject:SetActive(ahphzData.size == 2)
	ahphzObj.ToggleMultiple2:GetComponent('UIToggle'):Set(ahphzData.multiple == 2)
	ahphzObj.ToggleMultiple3:GetComponent('UIToggle'):Set(ahphzData.multiple == 3)
	ahphzObj.ToggleMultiple4:GetComponent('UIToggle'):Set(ahphzData.multiple == 4)
	ahphzObj.ToggleMultiple2.parent.gameObject:SetActive(ahphzData.choiceDouble and  ahphzData.size == 2)

	ahphzData.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewAHPHZisSettlementScore', 0)==1
	ahphzData.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewAHPHZfewerValue', 10)
	ahphzData.addValue=UnityEngine.PlayerPrefs.GetInt('NewAHPHZaddValue', 10)
	ahphzObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(ahphzData.size==2)
	ahphzObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(ahphzData.isSettlementScore)
	ahphzObj.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	ahphzObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = ahphzData.fewerValue
	ahphzObj.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	ahphzObj.ToggleAddScoreTxt:GetComponent('UILabel').text = ahphzData.addValue

	ahphzData.trusteeshipTime=UnityEngine.PlayerPrefs.GetInt('NewAHPHZtrusteeshipTime', 0)
	ahphzData.trusteeshipType = UnityEngine.PlayerPrefs.GetInt('NewAHPHZtrusteeshipType', 0) == 1
	ahphzData.trusteeshipRound = UnityEngine.PlayerPrefs.GetInt('NewAHPHZtrusteeshipRound', 0)
	ahphzObj.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(ahphzData.trusteeshipTime == 0)
	ahphzObj.ToggleTrusteeship1:GetComponent('UIToggle'):Set(ahphzData.trusteeshipTime == 1)
	ahphzObj.ToggleTrusteeship2:GetComponent('UIToggle'):Set(ahphzData.trusteeshipTime == 2)
	ahphzObj.ToggleTrusteeship3:GetComponent('UIToggle'):Set(ahphzData.trusteeshipTime == 3)
	ahphzObj.ToggleTrusteeship5:GetComponent('UIToggle'):Set(ahphzData.trusteeshipTime == 5)
	ahphzObj.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(ahphzData.trusteeshipType)
	ahphzObj.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not ahphzData.trusteeshipType and ahphzData.trusteeshipRound == 0)
	ahphzObj.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(ahphzData.trusteeshipRound == 3);
	ahphzObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(ahphzData.trusteeshipTime ~= 0)

	ahphzData.openIp=UnityEngine.PlayerPrefs.GetInt('AHPHZcheckIP', 0)==1
	ahphzData.openGps=UnityEngine.PlayerPrefs.GetInt('AHPHZcheckGPS', 0)==1
	ahphzObj.ToggleIPcheck.parent.gameObject:SetActive(ahphzData.size > 2 and CONST.IPcheckOn)
	ahphzObj.ToggleIPcheck:GetComponent('UIToggle'):Set(ahphzData.openIp)
	ahphzObj.ToggleGPScheck:GetComponent('UIToggle'):Set(ahphzData.openGps)

	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.AHPHZ,ahphzData.rounds,nil,nil)
	AHPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end

--获取当前设置
function this.GetConfig()
	local moneyLess = false
	if ((ahphzData.rounds == 6 or ahphzData.rounds == 8) and info_login.balance < 2) or
        (ahphzData.rounds == 10 and info_login.balance < 3)  or 
        (ahphzData.rounds == 16 and info_login.balance < 5) then
        moneyLess = true
    end
    local body = {}
    body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.AHPHZ)
	body.rounds = ahphzData.rounds
    body.size = ahphzData.size
    body.paymentType = ahphzData.paymentType
    body.randomBanker = ahphzData.randomBanker
    body.trusteeship = ahphzData.trusteeshipTime*60
    body.trusteeshipDissolve = ahphzData.trusteeshipType
    body.trusteeshipRound = ahphzData.trusteeshipRound
	body.bottomScore = ahphzData.bottomScore 
	body.niao = ahphzData.niao
	body.niaoValue =  ahphzData.niao and ahphzData.niaoValue or 0
	--body.ziMoAddHu = ahphzData.ziMoAddHu
	if ahphzData.size == 2 then
		body.resultScore = ahphzData.isSettlementScore
		if ahphzData.isSettlementScore then
			body.resultLowerScore=ahphzData.fewerValue
			body.resultAddScore=ahphzData.addValue
		end
		body.choiceDouble = ahphzData.choiceDouble
        body.doubleScore = ahphzData.doubleScore
        body.multiple = ahphzData.multiple
		ahphzData.openIp=false
		ahphzData.openGps=false
	end
	body.chou = ahphzData.size == 2 and ahphzData.chou or 0
    body.qiHuHuXi = 15
    body.tunXi = ahphzData.huStepNum
    body.fanXing = false
	body.huangZhuangFen = ahphzData.huangZhuangFen
	body.huangKeepBanker = ahphzData.huangKeepBanker
	body.paPo = ahphzData.paPo
	body.heiHongHu = ahphzData.hong
	body.ziMoAddTun = ahphzData.ziMoAddTun
	body.tianHu = ahphzData.tianhu
	body.diHu = ahphzData.dihu
	body.haiDiHu = ahphzData.haiDiHu
	body.openIp	 = ahphzData.openIp
	body.openGps = ahphzData.openGps
	 
    return moneyLess,body;
end
--局数
function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
    if ahphzObj.ToggleRound1.gameObject == go then
		ahphzData.rounds = 1
	elseif ahphzObj.ToggleRound6.gameObject == go then
        ahphzData.rounds = 6
	elseif ahphzObj.ToggleRound8.gameObject == go then
        ahphzData.rounds = 8
    elseif ahphzObj.ToggleRound10.gameObject == go then
        ahphzData.rounds = 10
    else
        ahphzData.rounds = 16
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.AHPHZ,ahphzData.rounds,nil,nil)  
    UnityEngine.PlayerPrefs.SetInt('NewAHPHZrounds', ahphzData.rounds)
end
--玩家个数
function this.OnClickTogglePlayerNum(go)
	AudioManager.Instance:PlayAudio('btn')
    if ahphzObj.TogglePeopleNum2.gameObject == go then
        ahphzData.size = 2
    elseif ahphzObj.TogglePeopleNum3.gameObject == go then
        ahphzData.size = 3
    end
	ahphzObj.ToggleIPcheck.parent.gameObject:SetActive(ahphzData.size > 2 and CONST.IPcheckOn)
	UnityEngine.PlayerPrefs.SetInt('NewAHPHZsize', ahphzData.size)
	ahphzObj.ToggleNoChoiceDouble.parent.gameObject:SetActive(ahphzData.size==2)
    ahphzObj.ToggleMultiple2.parent.gameObject:SetActive(ahphzData.choiceDouble and ahphzData.size==2)
	ahphzObj.DoubleScoreText.parent.gameObject:SetActive(ahphzData.choiceDouble)
	ahphzObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(ahphzData.size==2)
	ahphzObj.ToggleChou0.parent.gameObject:SetActive(ahphzData.size == 2)
    AHPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end
--支付方式
function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if ahphzObj.ToggleMasterPay.gameObject == go then
        ahphzData.paymentType=0
    elseif ahphzObj.ToggleWinnerPay.gameObject == go then
        ahphzData.paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewAHPHZpaymentType', ahphzData.paymentType)
end
--坐庄
function this.OnClickRandomBanker(go)
    AudioManager.Instance:PlayAudio('btn')
    if ahphzObj.ToggleRandomBanker.gameObject == go then
        ahphzData.randomBanker = true
    elseif ahphzObj.ToggleBankerFrist.gameObject == go then
        ahphzData.randomBanker = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewAHPHZrandomBanker', ahphzData.randomBanker and 1 or 0)
end
--算分
function this.OnClickToggleHuStep(go)
	AudioManager.Instance:PlayAudio('btn') 
    if ahphzObj.ToggleHuStep3.gameObject == go then
        ahphzData.huStepNum = 3
	elseif ahphzObj.ToggleHuStep1.gameObject == go then
		ahphzData.huStepNum = 1
    end
	UnityEngine.PlayerPrefs.SetInt('NewAHPHZhuStepNum', ahphzData.huStepNum)
end
--底分
function this.OnClickChangeDiFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if ahphzObj.AddBtnDiFen.gameObject == go then
		ahphzData.bottomScore = ahphzData.bottomScore + 1
		if ahphzData.bottomScore > 10 then
			ahphzData.bottomScore = 10
		end
    elseif ahphzObj.SubtractBtnDiFen.gameObject == go then
        ahphzData.bottomScore = ahphzData.bottomScore - 1
		if ahphzData.bottomScore < 1 then
			ahphzData.bottomScore = 1
		end
	end
	ahphzObj.DiFenTunValue:GetComponent("UILabel").text = ahphzData.bottomScore..'分'
    UnityEngine.PlayerPrefs.SetInt('NewAHPHZbottomScore', ahphzData.bottomScore)
end
--玩法
function this.OnClickTogglePlay(go)
	AudioManager.Instance:PlayAudio('btn') 
	if go == ahphzObj.TogglePapo.gameObject then
		ahphzData.paPo = ahphzObj.TogglePapo:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewAHPHZpaPo', ahphzData.paPo and 1 or 0) 
	elseif go == ahphzObj.ToggleHong.gameObject then
		ahphzData.hong = ahphzObj.ToggleHong:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewAHPHZhong', ahphzData.hong and 1 or 0) 
	elseif go == ahphzObj.ToggleZiMoAdd1Tun.gameObject then
		ahphzData.ziMoAddTun = ahphzObj.ToggleZiMoAdd1Tun:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewAHPHZziMoAddTun', ahphzData.ziMoAddTun and 1 or 0) 
	elseif go == ahphzObj.ToggleTian.gameObject then
		ahphzData.tianhu = ahphzObj.ToggleTian:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewAHPHZtianhu', ahphzData.tianhu and 1 or 0)
	elseif go == ahphzObj.ToggleDi.gameObject then
		ahphzData.dihu = ahphzObj.ToggleDi:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewAHPHZdihu', ahphzData.dihu and 1 or 0)
	elseif go == ahphzObj.ToggleHaiDi.gameObject then
		ahphzData.haiDiHu = ahphzObj.ToggleHaiDi:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewAHPHZhaiDiHu', ahphzData.haiDiHu and 1 or 0)
	end
end
--荒庄
function this.OnClickContinueBanker(go)
	ahphzData.huangKeepBanker = ahphzObj.ContinueBanker:GetComponent('UIToggle').value
	UnityEngine.PlayerPrefs.SetInt('NewAHPHZhuangKeepBanker', ahphzData.huangKeepBanker and 1 or 0)
end
function this.OnClickChangeHuangZhuangKouFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if ahphzObj.AddBtnHuangZhuangKouFen.gameObject == go then
		ahphzData.huangZhuangFen = ahphzData.huangZhuangFen + 1
		if ahphzData.huangZhuangFen > 10 then
			ahphzData.huangZhuangFen = 10 
		end
    else
		ahphzData.huangZhuangFen = ahphzData.huangZhuangFen - 1
		if ahphzData.huangZhuangFen < 0 then
			ahphzData.huangZhuangFen = 0
		end
    end
	ahphzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = ahphzData.huangZhuangFen == 0 and '不扣分' or '扣'..ahphzData.huangZhuangFen..'分'
	UnityEngine.PlayerPrefs.SetInt('NewAHPHZhuangZhuangFen', ahphzData.huangZhuangFen)
end
--抽牌
function this.OnClickToggleChou(go)
	AudioManager.Instance:PlayAudio('btn')
	if ahphzObj.ToggleChou0.gameObject == go then
        ahphzData.chou=0
    elseif ahphzObj.ToggleChou10.gameObject == go then
        ahphzData.chou=10
    elseif ahphzObj.ToggleChou20.gameObject == go then
        ahphzData.chou=20
	end
	UnityEngine.PlayerPrefs.SetInt('NewAHPHZchou', ahphzData.chou)
end
--打鸟
function this.OnClickNiao(go)
	AudioManager.Instance:PlayAudio('btn')
	if ahphzObj.ToggleOnNiao.gameObject == go then
		ahphzData.niao = true
	elseif ahphzObj.ToggleOffNiao.gameObject == go then
		ahphzData.niao = false
	end
	ahphzObj.NiaoValueText.parent.gameObject:SetActive(ahphzData.niao)
	UnityEngine.PlayerPrefs.SetInt('NewAHPHZniao', ahphzData.niao and 1 or 0)	
end 
function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if ahphzObj.AddButtonNiao.gameObject == go then
		ahphzData.niaoValue = ahphzData.niaoValue + 10
		if ahphzData.niaoValue > 100 then
			ahphzData.niaoValue = 100
		end
	elseif ahphzObj.SubtractButtonNiao.gameObject == go then
		ahphzData.niaoValue = ahphzData.niaoValue - 10
		if ahphzData.niaoValue < 10 then
			ahphzData.niaoValue = 10
		end
	end
	ahphzObj.NiaoValueText:GetComponent('UILabel').text = ahphzData.niaoValue.."分"
	UnityEngine.PlayerPrefs.SetInt('NewAHPHZniaoValue', ahphzData.niaoValue)
end
--翻倍
function this.OnClickChoiceDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if ahphzObj.ToggleChoiceDouble.gameObject == go then
        ahphzData.choiceDouble = true
    elseif ahphzObj.ToggleNoChoiceDouble.gameObject == go then
        ahphzData.choiceDouble = false
    end
    ahphzObj.DoubleScoreText.parent.gameObject:SetActive(ahphzData.choiceDouble)
    ahphzObj.ToggleMultiple2.parent.gameObject:SetActive(ahphzData.choiceDouble)
    AHPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
    UnityEngine.PlayerPrefs.SetInt('NewAHPHZchoiceDouble', ahphzData.choiceDouble and 1 or 0)
end
function this.OnClickChangeDoubleScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if ahphzObj.AddDoubleScoreButton.gameObject == go then
        if ahphzData.doubleScore ~= 0 then
            ahphzData.doubleScore = ahphzData.doubleScore + 1
            if ahphzData.doubleScore > 100 then
                ahphzData.doubleScore = 0
            end
        end
    else
        if ahphzData.doubleScore == 0 then
            ahphzData.doubleScore = 100
        else
            ahphzData.doubleScore = ahphzData.doubleScore - 1
            if ahphzData.doubleScore < 1 then
                ahphzData.doubleScore = 1
            end
        end
    end
    if ahphzData.doubleScore == 0 then
        ahphzObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
    else
        ahphzObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..ahphzData.doubleScore..'分'
    end
    UnityEngine.PlayerPrefs.SetInt('NewAHPHZdoubleScore', ahphzData.doubleScore)
end
function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
    if ahphzObj.ToggleMultiple2.gameObject == go then
        ahphzData.multiple=2
    elseif ahphzObj.ToggleMultiple3.gameObject == go then
        ahphzData.multiple=3
    elseif ahphzObj.ToggleMultiple4.gameObject == go then
        ahphzData.multiple=4
    end
    UnityEngine.PlayerPrefs.SetInt('NewAHPHZmultiple', ahphzData.multiple)
end
--结算
function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    ahphzData.isSettlementScore= ahphzObj.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewAHPHZisSettlementScore', ahphzData.isSettlementScore and 1 or 0)
end
function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if ahphzObj.ToggleFewerAddButton.gameObject == go then
		ahphzData.fewerValue = ahphzData.fewerValue + 1
		if ahphzData.fewerValue > 100 then
			ahphzData.fewerValue = 100
		end
    elseif ahphzObj.ToggleFewerSubtractButton.gameObject == go then
		ahphzData.fewerValue = ahphzData.fewerValue - 1
		if ahphzData.fewerValue < 1 then
			ahphzData.fewerValue = 1
		end
	end
	ahphzObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = ahphzData.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewAHPHZfewerValue', ahphzData.fewerValue)
end
function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if ahphzObj.ToggleAddAddButton.gameObject == go then
		ahphzData.addValue = ahphzData.addValue + 1
		if ahphzData.addValue > 100 then
			ahphzData.addValue = 100
		end
    elseif ahphzObj.ToggleAddSubtractButton.gameObject == go then
		ahphzData.addValue = ahphzData.addValue - 1
		if ahphzData.addValue < 1 then
			ahphzData.addValue = 1
		end
	end
	ahphzObj.ToggleAddScoreTxt:GetComponent('UILabel').text = ahphzData.addValue
	UnityEngine.PlayerPrefs.SetInt('NewAHPHZaddValue', ahphzData.addValue)
end
--托管
function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if ahphzObj.ToggleTrusteeshipNo.gameObject == go then
        ahphzData.trusteeshipTime = 0
    elseif ahphzObj.ToggleTrusteeship1.gameObject == go then
        ahphzData.trusteeshipTime = 1
	elseif ahphzObj.ToggleTrusteeship2.gameObject then
		ahphzData.trusteeshipTime = 2;
    elseif ahphzObj.ToggleTrusteeship3.gameObject == go then
        ahphzData.trusteeshipTime = 3
    elseif ahphzObj.ToggleTrusteeship5.gameObject == go then
        ahphzData.trusteeshipTime = 5
    end
    UnityEngine.PlayerPrefs.SetInt('NewAHPHZtrusteeshipTime', ahphzData.trusteeshipTime)
	ahphzObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(ahphzData.trusteeshipTime ~= 0)
	AHPHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end
function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if ahphzObj.ToggleTrusteeshipOne.gameObject == go then
        ahphzData.trusteeshipType = true
		ahphzData.trusteeshipRound = 0;
    elseif ahphzObj.ToggleTrusteeshipAll.gameObject == go then
        ahphzData.trusteeshipType = false
		ahphzData.trusteeshipRound = 0;
	elseif ahphzObj.ToggleTrusteeshipThree.gameObject == go then
		ahphzData.trusteeshipType = false;
		ahphzData.trusteeshipRound = 3;
    end
    UnityEngine.PlayerPrefs.SetInt('NewAHPHZtrusteeshipType',ahphzData.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewAHPHZtrusteeshipRound',ahphzData.trusteeshipRound )
end
--检测
function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if ahphzObj.ToggleIPcheck.gameObject == go then
		ahphzData.openIp = ahphzObj.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('AHPHZcheckIP', ahphzData.openIp and 1 or 0)
	elseif ahphzObj.ToggleGPScheck.gameObject == go then
		ahphzData.openGps = ahphzObj.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('AHPHZcheckGPS', ahphzData.openGps and 1 or 0)
	end
end

return this
