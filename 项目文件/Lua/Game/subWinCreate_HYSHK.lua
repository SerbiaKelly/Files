
local this = {}

local  optionTable
local payLabel

local hyshkObj={}
local hyshkData={}
function this.Init(scrollviewZiPai, message)
	optionTable = scrollviewZiPai.transform:Find('table')
	payLabel = message.transform:Find('diamond/pay_label')
	
	hyshkObj.ToggleRound6 = optionTable.transform:Find('round/round6')
	hyshkObj.ToggleRound8 = optionTable.transform:Find('round/round8')
	hyshkObj.ToggleRound10 = optionTable.transform:Find('round/round10')
	hyshkObj.ToggleRound16 = optionTable.transform:Find('round/round16')
	message:AddClick(hyshkObj.ToggleRound6.gameObject, this.OnClickToggleRound)
	message:AddClick(hyshkObj.ToggleRound8.gameObject, this.OnClickToggleRound)
    message:AddClick(hyshkObj.ToggleRound10.gameObject, this.OnClickToggleRound)
	message:AddClick(hyshkObj.ToggleRound16.gameObject, this.OnClickToggleRound)

	hyshkObj.TogglePlayer2 = optionTable.transform:Find('num/num2')
	hyshkObj.TogglePlayer3 = optionTable.transform:Find('num/num3')
	message:AddClick(hyshkObj.TogglePlayer3.gameObject, this.OnClickTogglePlayerNum)
    message:AddClick(hyshkObj.TogglePlayer2.gameObject, this.OnClickTogglePlayerNum)
	
	hyshkObj.ToggleMasterPay = optionTable.transform:Find('pay/master')
	hyshkObj.ToggleWinnerPay = optionTable.transform:Find('pay/win')
	message:AddClick(hyshkObj.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(hyshkObj.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)

	hyshkObj.ToggleRandomBanker = optionTable.transform:Find('randomBanker/Auto')
	hyshkObj.ToggleBankerFrist = optionTable.transform:Find('randomBanker/Frist')
	message:AddClick(hyshkObj.ToggleRandomBanker.gameObject, this.OnClickRandomBanker)
	message:AddClick(hyshkObj.ToggleBankerFrist.gameObject, this.OnClickRandomBanker)
	
	hyshkObj.ToggleBaseScore2 = optionTable.transform:Find('rule1/baseScore2')
	hyshkObj.Toggle1510 = optionTable.transform:Find('rule1/1-5-10')
	hyshkObj.TogglenoBomb = optionTable.transform:Find('rule1/noBomb')
	hyshkObj.TogglecantPassHu = optionTable.transform:Find('rule2/cantPassHu')
	hyshkObj.TogglepiaoHu = optionTable.transform:Find('rule2/piaoHu')
	hyshkObj.ToggletianDiHaiHu = optionTable.transform:Find('rule2/tianDiHaiHu')
	hyshkObj.TogglemingWei = optionTable.transform:Find('rule3/mingWei')
	hyshkObj.TogglexiaoHong3Fan = optionTable.transform:Find('rule3/xiaoHong3Fan')
	message:AddClick(hyshkObj.ToggleBaseScore2.gameObject, this.OnClickToggleHuType)
    message:AddClick(hyshkObj.Toggle1510.gameObject, this.OnClickToggleHuType)
	message:AddClick(hyshkObj.TogglenoBomb.gameObject, this.OnClickToggleHuType)
	message:AddClick(hyshkObj.TogglecantPassHu.gameObject, this.OnClickToggleHuType)
	message:AddClick(hyshkObj.TogglepiaoHu.gameObject, this.OnClickToggleHuType)
	message:AddClick(hyshkObj.ToggletianDiHaiHu.gameObject, this.OnClickToggleHuType)
	message:AddClick(hyshkObj.TogglemingWei.gameObject, this.OnClickToggleHuType)
	message:AddClick(hyshkObj.TogglexiaoHong3Fan.gameObject, this.OnClickToggleHuType)
	
	hyshkObj.ToggleNoChouPai = optionTable.transform:Find('choupai/buchou')
	hyshkObj.ToggleChouPai10 = optionTable.transform:Find('choupai/chou10')
	hyshkObj.ToggleChouPai20 = optionTable.transform:Find('choupai/chou20')
	message:AddClick(hyshkObj.ToggleNoChouPai.gameObject, this.OnClickToggleChouPai)
	message:AddClick(hyshkObj.ToggleChouPai10.gameObject, this.OnClickToggleChouPai)
	message:AddClick(hyshkObj.ToggleChouPai20.gameObject, this.OnClickToggleChouPai)

	hyshkObj.ToggleFan = optionTable.transform:Find('xing/fan')
	hyshkObj.ToggleGen = optionTable.transform:Find('xing/gen')
	hyshkObj.ToggleNo = optionTable.transform:Find('xing/no')
	message:AddClick(hyshkObj.ToggleFan.gameObject, this.OnClickToggleFanType)
	message:AddClick(hyshkObj.ToggleGen.gameObject, this.OnClickToggleFanType)
	message:AddClick(hyshkObj.ToggleNo.gameObject, this.OnClickToggleFanType)

	hyshkObj.ToggleFangPao1 = optionTable.transform:Find('fangpao/1')
	hyshkObj.ToggleFangPao2 = optionTable.transform:Find('fangpao/2')
	hyshkObj.ToggleFangPao3 = optionTable.transform:Find('fangpao/3')
	message:AddClick(hyshkObj.ToggleFangPao1.gameObject, this.OnClickToggleFangPao)
	message:AddClick(hyshkObj.ToggleFangPao2.gameObject, this.OnClickToggleFangPao)
	message:AddClick(hyshkObj.ToggleFangPao3.gameObject, this.OnClickToggleFangPao)

	hyshkObj.ToggleOneRoundDouble = optionTable.transform:Find('multipleEnd/oneRoundDouble')
	hyshkObj.ToggleAllRoundDouble = optionTable.transform:Find('multipleEnd/allRoundDouble')
	message:AddClick(hyshkObj.ToggleOneRoundDouble.gameObject, this.OnClickRoundDouble)
	message:AddClick(hyshkObj.ToggleAllRoundDouble.gameObject, this.OnClickRoundDouble)

	hyshkObj.ToggleOnNiao = optionTable.transform:Find('niao/OnNiao')
	hyshkObj.ToggleOffNiao = optionTable.transform:Find('niao/OffNiao')
	hyshkObj.NiaoValueText = optionTable.transform:Find('niao/NiaoValue/Value')
	hyshkObj.AddButtonNiao = optionTable.transform:Find('niao/NiaoValue/AddButton')
	hyshkObj.SubtractButtonNiao = optionTable.transform:Find('niao/NiaoValue/SubtractButton')
	message:AddClick(hyshkObj.ToggleOnNiao.gameObject, this.OnClickNiao)
	message:AddClick(hyshkObj.ToggleOffNiao.gameObject, this.OnClickNiao)
	message:AddClick(hyshkObj.AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(hyshkObj.SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)

	hyshkObj.ToggleChoiceDouble = optionTable.transform:Find('choiceDouble/On')
	hyshkObj.ToggleNoChoiceDouble = optionTable.transform:Find('choiceDouble/Off')
	hyshkObj.DoubleScoreText = optionTable.transform:Find('choiceDouble/doubleScore/Value')
	hyshkObj.AddDoubleScoreButton = optionTable.transform:Find('choiceDouble/doubleScore/AddButton')
	hyshkObj.SubtractDoubleScoreButton = optionTable.transform:Find('choiceDouble/doubleScore/SubtractButton')
	hyshkObj.ToggleMultiple2 = optionTable.transform:Find('multiple/2')
	hyshkObj.ToggleMultiple3 = optionTable.transform:Find('multiple/3')
	hyshkObj.ToggleMultiple4 = optionTable.transform:Find('multiple/4')
	message:AddClick(hyshkObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(hyshkObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(hyshkObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(hyshkObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(hyshkObj.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(hyshkObj.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(hyshkObj.ToggleMultiple4.gameObject, this.OnClickMultiple)

	hyshkObj.ToggleSettlementScoreSelect=optionTable.transform:Find('settlementScore/select')
	hyshkObj.ToggleFewerScoreTxt=optionTable.transform:Find('settlementScore/fewerValue/Value')
	hyshkObj.ToggleFewerAddButton=optionTable.transform:Find('settlementScore/fewerValue/AddButton')
	hyshkObj.ToggleFewerSubtractButton=optionTable.transform:Find('settlementScore/fewerValue/SubtractButton')
	hyshkObj.ToggleAddScoreTxt=optionTable.transform:Find('settlementScore/addValue/Value')
	hyshkObj.ToggleAddAddButton=optionTable.transform:Find('settlementScore/addValue/AddButton')
	hyshkObj.ToggleAddSubtractButton=optionTable.transform:Find('settlementScore/addValue/SubtractButton')
	message:AddClick(hyshkObj.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(hyshkObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(hyshkObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(hyshkObj.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(hyshkObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)

	hyshkObj.ToggleTrusteeshipNo = optionTable.transform:Find('DelegateChoose/NoDelegate')
	hyshkObj.ToggleTrusteeship1 = optionTable.transform:Find('DelegateChoose/Delegate1')
	hyshkObj.ToggleTrusteeship2 = optionTable.transform:Find('DelegateChoose/Delegate2')
	hyshkObj.ToggleTrusteeship3 = optionTable.transform:Find('DelegateChoose/Delegate3')
	hyshkObj.ToggleTrusteeship5 = optionTable.transform:Find('DelegateChoose/Delegate5')
	hyshkObj.ToggleTrusteeshipAll = optionTable.transform:Find('DelegateCancel/FullRound')
	hyshkObj.ToggleTrusteeshipOne = optionTable.transform:Find('DelegateCancel/ThisRound')
	hyshkObj.ToggleTrusteeshipThree = optionTable.transform:Find('DelegateCancel/ThreeRound')
	message:AddClick(hyshkObj.ToggleTrusteeshipNo.gameObject, this.OnDelegateTimeClick)
	message:AddClick(hyshkObj.ToggleTrusteeship1.gameObject, this.OnDelegateTimeClick)
	message:AddClick(hyshkObj.ToggleTrusteeship2.gameObject, this.OnDelegateTimeClick)
	message:AddClick(hyshkObj.ToggleTrusteeship3.gameObject, this.OnDelegateTimeClick)
	message:AddClick(hyshkObj.ToggleTrusteeship5.gameObject, this.OnDelegateTimeClick)
	message:AddClick(hyshkObj.ToggleTrusteeshipOne.gameObject, this.OnDelegateDissolveClick)
	message:AddClick(hyshkObj.ToggleTrusteeshipAll.gameObject, this.OnDelegateDissolveClick)
	message:AddClick(hyshkObj.ToggleTrusteeshipThree.gameObject, this.OnDelegateDissolveClick)

	hyshkObj.ToggleIPcheck = optionTable.transform:Find('PreventCheat/IPcheck')
	hyshkObj.ToggleGPScheck = optionTable.transform:Find('PreventCheat/GPScheck')
	message:AddClick(hyshkObj.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(hyshkObj.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
	print('HYSFK Init')
end

function this.Refresh()
	hyshkData.rounds = UnityEngine.PlayerPrefs.GetInt('hyshk_rounds', 6)
	hyshkObj.ToggleRound6:GetComponent('UIToggle'):Set(6 == hyshkData.rounds)
	hyshkObj.ToggleRound8:GetComponent('UIToggle'):Set(8 == hyshkData.rounds)
	hyshkObj.ToggleRound10:GetComponent('UIToggle'):Set(10 == hyshkData.rounds)
	hyshkObj.ToggleRound16:GetComponent('UIToggle'):Set(16 == hyshkData.rounds)
		 
	hyshkData.playerNum = UnityEngine.PlayerPrefs.GetInt('hyshk_playerNum', 3)
	hyshkObj.TogglePlayer2:GetComponent('UIToggle'):Set(2 == hyshkData.playerNum)
	hyshkObj.TogglePlayer3:GetComponent('UIToggle'):Set(3 == hyshkData.playerNum)

	hyshkData.payType = UnityEngine.PlayerPrefs.GetInt('hyshk_payType', 0)
	hyshkObj.ToggleMasterPay:GetComponent('UIToggle'):Set(0 == hyshkData.payType)
	hyshkObj.ToggleWinnerPay:GetComponent('UIToggle'):Set(2 == hyshkData.payType)

	hyshkData.randomBanker = UnityEngine.PlayerPrefs.GetInt('hyshk_randomBanker', 0) == 1
	hyshkObj.ToggleRandomBanker:GetComponent('UIToggle'):Set(hyshkData.randomBanker) 
	hyshkObj.ToggleBankerFrist:GetComponent('UIToggle'):Set(not hyshkData.randomBanker)
	
	hyshkData.isBaseSocre2 = UnityEngine.PlayerPrefs.GetInt('hyshk_baseSocre2', 1) == 1
	hyshkData.is1510 = UnityEngine.PlayerPrefs.GetInt('hyshk_1510', 0) == 1
	hyshkData.isNoBomb = UnityEngine.PlayerPrefs.GetInt('hyshk_noBomb', 0) == 1
	hyshkData.isCantPassHu = UnityEngine.PlayerPrefs.GetInt('hyshk_cantPassHu', 0) == 1
	hyshkData.isPiaoHu = UnityEngine.PlayerPrefs.GetInt('hyshk_piaoHu', 0) == 1
	hyshkData.isTianDiHaiHu = UnityEngine.PlayerPrefs.GetInt('hyshk_tianDiHaiHu', 0) == 1
	hyshkData.isMingWei = UnityEngine.PlayerPrefs.GetInt('hyshk_mingWei', 0) == 1
	hyshkData.isXiaoHong3Fan = UnityEngine.PlayerPrefs.GetInt('hyshk_xiaoHong3Fan', 0) == 1
	hyshkObj.ToggleBaseScore2:GetComponent('UIToggle'):Set(hyshkData.isBaseSocre2)
	hyshkObj.Toggle1510:GetComponent('UIToggle'):Set(hyshkData.is1510)
	hyshkObj.TogglenoBomb:GetComponent('UIToggle'):Set(hyshkData.isNoBomb)
	hyshkObj.TogglecantPassHu:GetComponent('UIToggle'):Set(hyshkData.isCantPassHu)
	hyshkObj.TogglepiaoHu:GetComponent('UIToggle'):Set(hyshkData.isPiaoHu)
	hyshkObj.ToggletianDiHaiHu:GetComponent('UIToggle'):Set(hyshkData.isTianDiHaiHu)
	hyshkObj.TogglemingWei:GetComponent('UIToggle'):Set(hyshkData.isMingWei)
	hyshkObj.TogglexiaoHong3Fan:GetComponent('UIToggle'):Set(hyshkData.isXiaoHong3Fan)
	
	hyshkData.xingType = UnityEngine.PlayerPrefs.GetInt('hyshk_xingType', 2)
	hyshkObj.ToggleFan:GetComponent('UIToggle'):Set(0 == hyshkData.xingType)
	hyshkObj.ToggleGen:GetComponent('UIToggle'):Set(1 == hyshkData.xingType)
	hyshkObj.ToggleNo:GetComponent('UIToggle'):Set(2 == hyshkData.xingType)
	
	hyshkData.fangpao = UnityEngine.PlayerPrefs.GetInt('hyshk_fangpao', 1)
	hyshkObj.ToggleFangPao1.parent.gameObject:SetActive(not hyshkData.isNoBomb)
	hyshkObj.ToggleFangPao1:GetComponent('UIToggle'):Set(1 == hyshkData.fangpao)
	hyshkObj.ToggleFangPao2:GetComponent('UIToggle'):Set(2 == hyshkData.fangpao)
	hyshkObj.ToggleFangPao3:GetComponent('UIToggle'):Set(3 == hyshkData.fangpao)

	hyshkData.singleRoundDouble=UnityEngine.PlayerPrefs.GetInt('hyshk_singleRoundDouble', 0)==1
	hyshkObj.ToggleOneRoundDouble:GetComponent('UIToggle'):Set(hyshkData.singleRoundDouble)
	hyshkObj.ToggleAllRoundDouble:GetComponent('UIToggle'):Set(not hyshkData.singleRoundDouble)

	hyshkData.choupai = UnityEngine.PlayerPrefs.GetInt('hyshk_choupai', 20)
	hyshkObj.ToggleNoChouPai.parent.gameObject:SetActive(hyshkData.playerNum==2)
	hyshkObj.ToggleNoChouPai:GetComponent('UIToggle'):Set(hyshkData.choupai == 0)
	hyshkObj.ToggleChouPai10:GetComponent('UIToggle'):Set(hyshkData.choupai == 10)
	hyshkObj.ToggleChouPai20:GetComponent('UIToggle'):Set(hyshkData.choupai == 20)

	hyshkData.niao = UnityEngine.PlayerPrefs.GetInt('hyshk_niao', 0) == 1
	hyshkData.niaoValue = UnityEngine.PlayerPrefs.GetInt('hyshk_niaoValue', 10)
	hyshkObj.ToggleOnNiao:GetComponent('UIToggle'):Set(hyshkData.niao)
	hyshkObj.ToggleOffNiao:GetComponent('UIToggle'):Set(not hyshkData.niao)
	hyshkObj.NiaoValueText.parent.gameObject:SetActive(hyshkData.niao)
	hyshkObj.NiaoValueText:GetComponent('UILabel').text = hyshkData.niaoValue.."分"

	hyshkData.choiceDouble = UnityEngine.PlayerPrefs.GetInt('hyshk_choiceDouble', 0)==1
	hyshkData.doubleScore = UnityEngine.PlayerPrefs.GetInt('hyshk_doubleScore', 10)
	hyshkData.multiple = UnityEngine.PlayerPrefs.GetInt('hyshk_multiple', 2)
	hyshkObj.ToggleChoiceDouble.parent.gameObject:SetActive(hyshkData.playerNum==2)
	hyshkObj.ToggleMultiple2.parent.gameObject:SetActive(hyshkData.playerNum==2 and hyshkData.choiceDouble)
	hyshkObj.ToggleOneRoundDouble.parent.gameObject:SetActive(hyshkData.playerNum==2 and hyshkData.choiceDouble)
	hyshkObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(hyshkData.choiceDouble)
	hyshkObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not hyshkData.choiceDouble)
	hyshkObj.DoubleScoreText.parent.gameObject:SetActive(hyshkData.choiceDouble)
	if hyshkData.doubleScore == 0 then
		hyshkObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		hyshkObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..hyshkData.doubleScore..'分'
	end
	hyshkObj.ToggleMultiple2:GetComponent('UIToggle'):Set(hyshkData.multiple == 2)
	hyshkObj.ToggleMultiple3:GetComponent('UIToggle'):Set(hyshkData.multiple == 3)
	hyshkObj.ToggleMultiple4:GetComponent('UIToggle'):Set(hyshkData.multiple == 4)

	hyshkData.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('hyshk_isSettlementScore', 0)==1
	hyshkData.fewerValue=UnityEngine.PlayerPrefs.GetInt('hyshk_fewerValue', 10)
	hyshkData.addValue=UnityEngine.PlayerPrefs.GetInt('hyshk_addValue', 10)
	hyshkObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(hyshkData.playerNum==2)
	hyshkObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(hyshkData.isSettlementScore)
	hyshkObj.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	hyshkObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = hyshkData.fewerValue
	hyshkObj.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	hyshkObj.ToggleAddScoreTxt:GetComponent('UILabel').text = hyshkData.addValue

	hyshkData.trusteeshipTime=UnityEngine.PlayerPrefs.GetInt('hyshk_trusteeshipTime', 0)
	hyshkData.trusteeshipType = UnityEngine.PlayerPrefs.GetInt('hyshk_trusteeshipType', 0) == 1
	hyshkData.trusteeshipRound = UnityEngine.PlayerPrefs.GetInt('hyshk_trusteeshipRound', 0)
	hyshkObj.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(hyshkData.trusteeshipTime == 0)
	hyshkObj.ToggleTrusteeship1:GetComponent('UIToggle'):Set(hyshkData.trusteeshipTime == 1)
	hyshkObj.ToggleTrusteeship2:GetComponent('UIToggle'):Set(hyshkData.trusteeshipTime == 2)
	hyshkObj.ToggleTrusteeship3:GetComponent('UIToggle'):Set(hyshkData.trusteeshipTime == 3)
	hyshkObj.ToggleTrusteeship5:GetComponent('UIToggle'):Set(hyshkData.trusteeshipTime == 5)
	hyshkObj.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(hyshkData.trusteeshipType)
	hyshkObj.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not hyshkData.trusteeshipType and hyshkData.trusteeshipRound == 0)
	hyshkObj.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(hyshkData.trusteeshipRound == 3)
	hyshkObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(hyshkData.trusteeshipTime ~= 0)

	hyshkData.openIp=UnityEngine.PlayerPrefs.GetInt('hyshk_checkIP', 0)==1
	hyshkData.openGps=UnityEngine.PlayerPrefs.GetInt('hyshk_checkGPS', 0)==1
	hyshkObj.ToggleIPcheck.parent.gameObject:SetActive(hyshkData.playerNum > 2 and CONST.IPcheckOn)
	hyshkObj.ToggleIPcheck:GetComponent('UIToggle'):Set(hyshkData.openIp)
	hyshkObj.ToggleGPScheck:GetComponent('UIToggle'):Set(hyshkData.openGps)
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.HYSHK,hyshkData.rounds,nil,nil)
	optionTable:GetComponent('UIGrid'):Reposition()
	print('HYSFK Refresh')
end

function this.GetConfig()
	local moneyLess = false
	if (hyshkData.rounds < 16 and info_login.balance < 2) or
        (hyshkData.rounds == 16 and info_login.balance < 3) then
        moneyLess = true
    end
    
	local body 					= {}
	body.roomType 				= UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.HYSHK)
	body.rounds 				= hyshkData.rounds
	body.size 					= hyshkData.playerNum
	body.paymentType 			= hyshkData.payType
	body.randomBanker 			= hyshkData.randomBanker
	body.bottom2Score 			= hyshkData.isBaseSocre2
	body.yiWuShi 				= hyshkData.is1510
	body.fangPao 				= not hyshkData.isNoBomb
	body.haveHuMustHu 			= hyshkData.isCantPassHu
	body.canPiaoHu 				= hyshkData.isPiaoHu
	body.tianDiHaiHu 			= hyshkData.isTianDiHaiHu
	body.canMingWei 			= hyshkData.isMingWei
	body.xiaoHong3Fan 			= hyshkData.isXiaoHong3Fan
	body.xing 					= hyshkData.xingType
	body.qiHuHuXi 				= 10
	body.niao 					= hyshkData.niao
	body.niaoValue 				= hyshkData.niao and hyshkData.niaoValue or 0
	body.trusteeship            = hyshkData.trusteeshipTime*60
    body.trusteeshipDissolve    = hyshkData.trusteeshipType
    body.trusteeshipRound       = hyshkData.trusteeshipRound
	body.fangPaoMultiple 		= hyshkData.isNoBomb and 1 or hyshkData.fangpao
	body.chou 					= hyshkData.playerNum == 2 and hyshkData.choupai or 0
	body.openIp	 				= hyshkData.openIp
	body.openGps 				= hyshkData.openGps
	if hyshkData.playerNum == 3 then
		body.choiceDouble 	= false
		body.doubleScore 	=0
		body.multiple		=0
	elseif hyshkData.playerNum == 2 then
		body.choiceDouble	=hyshkData.choiceDouble
		body.doubleScore 	=hyshkData.choiceDouble and hyshkData.doubleScore or 0
		body.multiple 		=hyshkData.choiceDouble and hyshkData.multiple or 0
		body.singleRoundDouble = hyshkData.choiceDouble and hyshkData.singleRoundDouble
	end
	
	if body.size == 2 then
		body.resultScore = hyshkData.isSettlementScore
		if hyshkData.isSettlementScore then
			body.resultLowerScore=hyshkData.fewerValue
			body.resultAddScore=hyshkData.addValue
		end
		body.openIp	 = false
		body.openGps = false
	end

	return moneyLess,body;
end

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
    if hyshkObj.ToggleRound6.gameObject == go then
        hyshkData.rounds = 6
	elseif hyshkObj.ToggleRound8.gameObject == go then
        hyshkData.rounds = 8
    elseif hyshkObj.ToggleRound10.gameObject == go then
        hyshkData.rounds = 10
	else
		hyshkData.rounds = 16
    end
	UnityEngine.PlayerPrefs.SetInt('hyshk_rounds', hyshkData.rounds)
	this.Refresh()
end

function this.OnClickTogglePlayerNum(go)
	AudioManager.Instance:PlayAudio('btn')
	if hyshkObj.TogglePlayer3.gameObject == go then
		hyshkData.playerNum = 3
	else
		hyshkData.playerNum = 2
	end
	hyshkObj.ToggleIPcheck.parent.gameObject:SetActive(hyshkData.playerNum > 2 and CONST.IPcheckOn)
	hyshkObj.ToggleChoiceDouble.parent.gameObject:SetActive(hyshkData.playerNum==2)
	hyshkObj.ToggleMultiple2.parent.gameObject:SetActive(hyshkData.playerNum==2 and hyshkData.choiceDouble)
	hyshkObj.ToggleOneRoundDouble.parent.gameObject:SetActive(hyshkData.playerNum==2 and hyshkData.choiceDouble)
	hyshkObj.DoubleScoreText.parent.gameObject:SetActive(hyshkData.choiceDouble)
	hyshkObj.ToggleNoChouPai.parent.gameObject:SetActive(hyshkData.playerNum==2)
	hyshkObj.ToggleNoChouPai:GetComponent('UIToggle'):Set(hyshkData.choupai == 0)
	hyshkObj.ToggleChouPai10:GetComponent('UIToggle'):Set(hyshkData.choupai == 10)
	hyshkObj.ToggleChouPai20:GetComponent('UIToggle'):Set(hyshkData.choupai == 20)
	hyshkObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(hyshkData.playerNum==2)
	optionTable:GetComponent('UIGrid'):Reposition()
	UnityEngine.PlayerPrefs.SetInt('hyshk_playerNum', hyshkData.playerNum)
end

function this.OnClickTogglePayType(go)
	AudioManager.Instance:PlayAudio('btn')
	if hyshkObj.ToggleMasterPay.gameObject == go then
		hyshkData.payType = 0
	else
		hyshkData.payType = 2
	end
	UnityEngine.PlayerPrefs.SetInt('hyshk_payType', hyshkData.payType)
end

function this.OnClickRandomBanker(go)
	AudioManager.Instance:PlayAudio('btn')
	if hyshkObj.ToggleRandomBanker.gameObject == go then
		hyshkData.randomBanker = true
	else
		hyshkData.randomBanker = false	
	end
	UnityEngine.PlayerPrefs.SetInt('hyshk_randomBanker', hyshkData.randomBanker and 1 or 0)
end

function this.OnClickToggleHuType(go)
	AudioManager.Instance:PlayAudio('btn')
    if hyshkObj.ToggleBaseScore2.gameObject == go then
		hyshkData.isBaseSocre2 = hyshkObj.ToggleBaseScore2:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('hyshk_baseSocre2', hyshkData.isBaseSocre2 and 1 or 0)
    elseif hyshkObj.Toggle1510.gameObject == go then
		hyshkData.is1510 = hyshkObj.Toggle1510:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('hyshk_1510', hyshkData.is1510 and 1 or 0)
	elseif hyshkObj.TogglenoBomb.gameObject == go then
		hyshkData.isNoBomb = hyshkObj.TogglenoBomb:GetComponent('UIToggle').value
		hyshkObj.ToggleFangPao1.parent.gameObject:SetActive(not hyshkData.isNoBomb)
		hyshkObj.ToggleFangPao1:GetComponent('UIToggle'):Set(1 == hyshkData.fangpao)
		hyshkObj.ToggleFangPao2:GetComponent('UIToggle'):Set(2 == hyshkData.fangpao)
		hyshkObj.ToggleFangPao3:GetComponent('UIToggle'):Set(3 == hyshkData.fangpao)
		optionTable:GetComponent('UIGrid'):Reposition()
		UnityEngine.PlayerPrefs.SetInt('hyshk_noBomb', hyshkData.isNoBomb and 1 or 0)
	elseif hyshkObj.TogglecantPassHu.gameObject == go then
		hyshkData.isCantPassHu = hyshkObj.TogglecantPassHu:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('hyshk_cantPassHu', hyshkData.isCantPassHu and 1 or 0)
	elseif hyshkObj.TogglepiaoHu.gameObject == go then
		hyshkData.isPiaoHu = hyshkObj.TogglepiaoHu:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('hyshk_piaoHu', hyshkData.isPiaoHu and 1 or 0)
	elseif hyshkObj.ToggletianDiHaiHu.gameObject == go then
		hyshkData.isTianDiHaiHu = hyshkObj.ToggletianDiHaiHu:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('hyshk_tianDiHaiHu', hyshkData.isTianDiHaiHu and 1 or 0)
	elseif hyshkObj.TogglemingWei.gameObject == go then
		hyshkData.isMingWei = hyshkObj.TogglemingWei:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('hyshk_mingWei', hyshkData.isMingWei and 1 or 0)
	elseif hyshkObj.TogglexiaoHong3Fan.gameObject == go then
		hyshkData.isXiaoHong3Fan = hyshkObj.TogglexiaoHong3Fan:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('hyshk_xiaoHong3Fan', hyshkData.isXiaoHong3Fan and 1 or 0)
	else
		Debugger.log('unkown button')
    end
end

function this.OnClickToggleChouPai(go)
	AudioManager.Instance:PlayAudio('btn')
	if hyshkObj.ToggleNoChouPai.gameObject == go then
		hyshkData.choupai = 0
	elseif hyshkObj.ToggleChouPai10.gameObject == go then
		hyshkData.choupai = 10
	elseif hyshkObj.ToggleChouPai20.gameObject == go then
		hyshkData.choupai = 20
	end
	UnityEngine.PlayerPrefs.SetInt('hyshk_choupai', hyshkData.choupai)
end

function this.OnClickToggleFanType(go)
	AudioManager.Instance:PlayAudio('btn')
    if hyshkObj.ToggleFan.gameObject == go then
		hyshkData.xingType = 0
	elseif hyshkObj.ToggleGen.gameObject == go then
		hyshkData.xingType = 1
	else
		hyshkData.xingType = 2
	end
	UnityEngine.PlayerPrefs.SetInt('hyshk_xingType', hyshkData.xingType)
end

function this.OnClickToggleFangPao(go)
	AudioManager.Instance:PlayAudio('btn')
    if hyshkObj.ToggleFangPao1.gameObject == go then
		hyshkData.fangpao = 1
	elseif hyshkObj.ToggleFangPao2.gameObject == go then
		hyshkData.fangpao = 2
	elseif hyshkObj.ToggleFangPao3.gameObject == go then
		hyshkData.fangpao = 3
	end
	UnityEngine.PlayerPrefs.SetInt('hyshk_fangpao', hyshkData.fangpao)
end

function this.OnClickNiao(go)
	AudioManager.Instance:PlayAudio('btn')
    if hyshkObj.ToggleOnNiao.gameObject == go then
		hyshkData.niao = true
		if hyshkData.niaoValue==0 then
			hyshkData.niaoValue=10
		end
    elseif hyshkObj.ToggleOffNiao.gameObject == go then
		hyshkData.niao = false
		hyshkData.niaoValue=0
	end
	hyshkObj.NiaoValueText:GetComponent('UILabel').text = hyshkData.niaoValue.."分"
    hyshkObj.NiaoValueText.parent.gameObject:SetActive(hyshkData.niao)
    UnityEngine.PlayerPrefs.SetInt('hyshk_niao', hyshkData.niao and 1 or 0)
end

function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
    if hyshkObj.AddButtonNiao.gameObject == go then
        hyshkData.niaoValue = hyshkData.niaoValue + 10
        if hyshkData.niaoValue > 100 then
            hyshkData.niaoValue = 100
        end
    elseif hyshkObj.SubtractButtonNiao.gameObject == go then
        hyshkData.niaoValue = hyshkData.niaoValue - 10
        if hyshkData.niaoValue < 10 then
            hyshkData.niaoValue = 10
        end
    end
    hyshkObj.NiaoValueText:GetComponent('UILabel').text = hyshkData.niaoValue.."分"
    UnityEngine.PlayerPrefs.SetInt('hyshk_niaoValue', hyshkData.niaoValue)
end

function this.OnClickChoiceDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if hyshkObj.ToggleChoiceDouble.gameObject == go then
        hyshkData.choiceDouble = true
    elseif hyshkObj.ToggleNoChoiceDouble.gameObject == go then
        hyshkData.choiceDouble = false
    end
    hyshkObj.DoubleScoreText.parent.gameObject:SetActive(hyshkData.choiceDouble)
	hyshkObj.ToggleMultiple2.parent.gameObject:SetActive(hyshkData.choiceDouble)
	hyshkObj.ToggleOneRoundDouble.parent.gameObject:SetActive(hyshkData.choiceDouble)
    optionTable:GetComponent('UIGrid'):Reposition()
    UnityEngine.PlayerPrefs.SetInt('hyshk_choiceDouble', hyshkData.choiceDouble and 1 or 0)
end

function this.OnClickChangeDoubleScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if hyshkObj.AddDoubleScoreButton.gameObject == go then
        if hyshkData.doubleScore ~= 0 then
            hyshkData.doubleScore = hyshkData.doubleScore + 1
            if hyshkData.doubleScore > 100 then
                hyshkData.doubleScore = 0
            end
        end
    else
        if hyshkData.doubleScore == 0 then
			hyshkData.doubleScore = 100
        else
            hyshkData.doubleScore = hyshkData.doubleScore - 1
            if hyshkData.doubleScore < 1 then
				hyshkData.doubleScore = 1
            end
        end
    end
    if hyshkData.doubleScore == 0 then
        hyshkObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
    else
        hyshkObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..hyshkData.doubleScore..'分'
    end
    UnityEngine.PlayerPrefs.SetInt('hyshk_doubleScore', hyshkData.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
    if hyshkObj.ToggleMultiple2.gameObject == go then
        hyshkData.multiple=2
    elseif hyshkObj.ToggleMultiple3.gameObject == go then
        hyshkData.multiple=3
    elseif hyshkObj.ToggleMultiple4.gameObject == go then
        hyshkData.multiple=4
    end
    UnityEngine.PlayerPrefs.SetInt('hyshk_multiple', hyshkData.multiple)
end

function this.OnClickRoundDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if hyshkObj.ToggleOneRoundDouble.gameObject == go then
        hyshkData.singleRoundDouble=true
    elseif hyshkObj.ToggleAllRoundDouble.gameObject == go then
		hyshkData.singleRoundDouble=false
    end
    UnityEngine.PlayerPrefs.SetInt('hyshk_singleRoundDouble', hyshkData.singleRoundDouble and 1 or 0)
end

function this.OnDelegateTimeClick(go)
	AudioManager.Instance:PlayAudio('btn')
    if hyshkObj.ToggleTrusteeshipNo.gameObject == go then
        hyshkData.trusteeshipTime = 0
    elseif hyshkObj.ToggleTrusteeship1.gameObject == go then
        hyshkData.trusteeshipTime = 1
	elseif hyshkObj.ToggleTrusteeship2.gameObject == go then
		hyshkData.trusteeshipTime = 2
	elseif hyshkObj.ToggleTrusteeship3.gameObject == go then
        hyshkData.trusteeshipTime = 3
    elseif hyshkObj.ToggleTrusteeship5.gameObject == go then
        hyshkData.trusteeshipTime = 5
	end
    UnityEngine.PlayerPrefs.SetInt('hyshk_trusteeshipTime', hyshkData.trusteeshipTime)
	hyshkObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(hyshkData.trusteeshipTime ~= 0)
	optionTable:GetComponent('UIGrid'):Reposition()
end

function this.OnDelegateDissolveClick(go)
	AudioManager.Instance:PlayAudio('btn')
    if hyshkObj.ToggleTrusteeshipOne.gameObject == go then
        hyshkData.trusteeshipType = true
		hyshkData.trusteeshipRound =0;
    elseif hyshkObj.ToggleTrusteeshipAll.gameObject == go then
        hyshkData.trusteeshipType = false
		hyshkData.trusteeshipRound = 0;
	elseif hyshkObj.ToggleTrusteeshipThree.gameObject == go then
		hyshkData.trusteeshipType = false;
		hyshkData.trusteeshipRound = 3;
    end
    UnityEngine.PlayerPrefs.SetInt('hyshk_trusteeshipType',hyshkData.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('hyshk_trusteeshipRound',hyshkData.trusteeshipRound)
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    hyshkData.isSettlementScore= hyshkObj.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('hyshk_isSettlementScore', hyshkData.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if hyshkObj.ToggleFewerAddButton.gameObject == go then
		hyshkData.fewerValue = hyshkData.fewerValue + 1
		if hyshkData.fewerValue > 100 then
			hyshkData.fewerValue = 100
		end
    elseif hyshkObj.ToggleFewerSubtractButton.gameObject == go then
		hyshkData.fewerValue = hyshkData.fewerValue - 1
		if hyshkData.fewerValue < 1 then
			hyshkData.fewerValue = 1
		end
	end
	hyshkObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = hyshkData.fewerValue
	UnityEngine.PlayerPrefs.SetInt('hyshk_fewerValue', hyshkData.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if hyshkObj.ToggleAddAddButton.gameObject == go then
		hyshkData.addValue = hyshkData.addValue + 1
		if hyshkData.addValue > 100 then
			hyshkData.addValue = 100
		end
    elseif hyshkObj.ToggleAddSubtractButton.gameObject == go then
		hyshkData.addValue = hyshkData.addValue - 1
		if hyshkData.addValue < 1 then
			hyshkData.addValue = 1
		end
	end
	hyshkObj.ToggleAddScoreTxt:GetComponent('UILabel').text = hyshkData.addValue
	UnityEngine.PlayerPrefs.SetInt('hyshk_addValue', hyshkData.addValue)
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if hyshkObj.ToggleIPcheck.gameObject == go then
		hyshkData.openIp = hyshkObj.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('hyshk_checkIP', hyshkData.openIp and 1 or 0)
	elseif hyshkObj.ToggleGPScheck.gameObject == go then
		hyshkData.openGps = hyshkObj.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('hyshk_checkGPS', hyshkData.openGps and 1 or 0)
	end
end

return this