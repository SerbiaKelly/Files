local this = {}

local HYLHQ
local payLabel

local hylhqObj={}
local hylhqData={}

function this.Init(grid,message)
	print('Init_HYLHQ')
	HYLHQ = grid
	payLabel = message.transform:Find('diamond/pay_label')

	hylhqObj.ToggleRound6 = HYLHQ:Find('table/round/round6')
	hylhqObj.ToggleRound8 = HYLHQ:Find('table/round/round8')
	hylhqObj.ToggleRound10 = HYLHQ:Find('table/round/round10')
	hylhqObj.ToggleRound16 = HYLHQ:Find('table/round/round16')

	hylhqObj.TogglePeopleNum2 = HYLHQ:Find('table/num/num2')
	hylhqObj.TogglePeopleNum3 = HYLHQ:Find('table/num/num3')
	hylhqObj.TogglePeopleNum4 = HYLHQ:Find('table/num/num4')

	hylhqObj.ToggleMasterPay = HYLHQ:Find('table/pay/master')
	hylhqObj.ToggleWinnerPay = HYLHQ:Find('table/pay/win')

	hylhqObj.ToggleRandomBanker = HYLHQ:Find('table/randomBanker/Auto')
	hylhqObj.ToggleBankerFrist = HYLHQ:Find('table/randomBanker/Frist')

	hylhqObj.ToggleQiHuHuXu6 = HYLHQ:Find('table/qihuhuxu/6')
	hylhqObj.ToggleQiHuHuXu9 = HYLHQ:Find('table/qihuhuxu/9')

	hylhqObj.ToggleBaseScore2 = HYLHQ:Find('table/hutype1/difen2')
	hylhqObj.Toggle1510 = HYLHQ:Find('table/hutype1/yiwushi')
	hylhqObj.TogglecantPassHu = HYLHQ:Find('table/hutype1/youhubihu')
	hylhqObj.ToggleHongHeiDian = HYLHQ:Find('table/hutype2/hongheidian')
	hylhqObj.ToggletianDiHaiHu = HYLHQ:Find('table/hutype2/tiandihaihu')
	hylhqObj.TogglemingWei = HYLHQ:Find('table/hutype2/mingwei')
	hylhqObj.ToggleLiangPao = HYLHQ:Find('table/hutype3/liangpao')
	hylhqObj.ToggleYiHuYiTun = HYLHQ:Find('table/hutype3/yihuyitun')
	hylhqObj.Toggle21Zhang = HYLHQ:Find('table/hutype3/21zhang')

	hylhqObj.ToggleOnNiao = HYLHQ:Find('table/niao/OnNiao')
	hylhqObj.ToggleOffNiao = HYLHQ:Find('table/niao/OffNiao')
	hylhqObj.NiaoValueText = HYLHQ:Find('table/niao/NiaoValue/Value')
	hylhqObj.AddButtonNiao = HYLHQ:Find('table/niao/NiaoValue/AddButton')
	hylhqObj.SubtractButtonNiao = HYLHQ:Find('table/niao/NiaoValue/SubtractButton')

	hylhqObj.ToggleFan = HYLHQ:Find('table/xing/fan')
	hylhqObj.ToggleGen = HYLHQ:Find('table/xing/gen')
	hylhqObj.ToggleNo = HYLHQ:Find('table/xing/no')

	hylhqObj.ToggleChoiceDouble = HYLHQ:Find('table/choiceDouble/On')
	hylhqObj.ToggleNoChoiceDouble = HYLHQ:Find('table/choiceDouble/Off')
	hylhqObj.DoubleScoreText = HYLHQ:Find('table/choiceDouble/doubleScore/Value')
	hylhqObj.AddDoubleScoreButton = HYLHQ:Find('table/choiceDouble/doubleScore/AddButton')
	hylhqObj.SubtractDoubleScoreButton = HYLHQ:Find('table/choiceDouble/doubleScore/SubtractButton')

	hylhqObj.ToggleNoChouPai = HYLHQ:Find('table/choupai/buchou')
	hylhqObj.ToggleChouPai10 = HYLHQ:Find('table/choupai/chou10')
	hylhqObj.ToggleChouPai20 = HYLHQ:Find('table/choupai/chou20')

	hylhqObj.ToggleMultiple2 = HYLHQ:Find('table/multiple/2')
	hylhqObj.ToggleMultiple3 = HYLHQ:Find('table/multiple/3')
	hylhqObj.ToggleMultiple4 = HYLHQ:Find('table/multiple/4')

	hylhqObj.ToggleSettlementScoreSelect=HYLHQ:Find('table/settlementScore/select')
	hylhqObj.ToggleFewerScoreTxt=HYLHQ:Find('table/settlementScore/fewerValue/Value')
	hylhqObj.ToggleFewerAddButton=HYLHQ:Find('table/settlementScore/fewerValue/AddButton')
	hylhqObj.ToggleFewerSubtractButton=HYLHQ:Find('table/settlementScore/fewerValue/SubtractButton')
	hylhqObj.ToggleAddScoreTxt=HYLHQ:Find('table/settlementScore/addValue/Value')
	hylhqObj.ToggleAddAddButton=HYLHQ:Find('table/settlementScore/addValue/AddButton')
	hylhqObj.ToggleAddSubtractButton=HYLHQ:Find('table/settlementScore/addValue/SubtractButton')

	hylhqObj.ToggleOneRoundDouble = HYLHQ:Find('table/multipleEnd/oneRoundDouble')
	hylhqObj.ToggleAllRoundDouble = HYLHQ:Find('table/multipleEnd/allRoundDouble')

	hylhqObj.ToggleTrusteeshipNo = HYLHQ:Find('table/DelegateChoose/NoDelegate')
	hylhqObj.ToggleTrusteeship1 = HYLHQ:Find('table/DelegateChoose/Delegate1')
	hylhqObj.ToggleTrusteeship2 = HYLHQ:Find('table/DelegateChoose/Delegate2')
	hylhqObj.ToggleTrusteeship3 = HYLHQ:Find('table/DelegateChoose/Delegate3')
	hylhqObj.ToggleTrusteeship5 = HYLHQ:Find('table/DelegateChoose/Delegate5')

	hylhqObj.ToggleTrusteeshipAll = HYLHQ:Find('table/DelegateCancel/FullRound')
	hylhqObj.ToggleTrusteeshipOne = HYLHQ:Find('table/DelegateCancel/ThisRound')
	hylhqObj.ToggleTrusteeshipThree = HYLHQ:Find('table/DelegateCancel/ThreeRound')
	
	hylhqObj.ToggleIPcheck = HYLHQ:Find('table/PreventCheat/IPcheck')
	hylhqObj.ToggleGPScheck = HYLHQ:Find('table/PreventCheat/GPScheck')

	message:AddClick(hylhqObj.ToggleRound6.gameObject, this.OnClickToggleRound)
	message:AddClick(hylhqObj.ToggleRound8.gameObject, this.OnClickToggleRound)
	message:AddClick(hylhqObj.ToggleRound10.gameObject, this.OnClickToggleRound)
	message:AddClick(hylhqObj.ToggleRound16.gameObject, this.OnClickToggleRound)

	message:AddClick(hylhqObj.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(hylhqObj.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(hylhqObj.TogglePeopleNum4.gameObject, this.OnClickTogglePlayerNum)

	message:AddClick(hylhqObj.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(hylhqObj.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)

	message:AddClick(hylhqObj.ToggleRandomBanker.gameObject, this.OnClickRandomBanker)
	message:AddClick(hylhqObj.ToggleBankerFrist.gameObject, this.OnClickRandomBanker)

	message:AddClick(hylhqObj.ToggleQiHuHuXu6.gameObject, this.OnClickQiHuHuXu)
	message:AddClick(hylhqObj.ToggleQiHuHuXu9.gameObject, this.OnClickQiHuHuXu)

	message:AddClick(hylhqObj.ToggleBaseScore2.gameObject, this.OnClickToggleHuType)
    message:AddClick(hylhqObj.Toggle1510.gameObject, this.OnClickToggleHuType)
	message:AddClick(hylhqObj.TogglecantPassHu.gameObject, this.OnClickToggleHuType)
	message:AddClick(hylhqObj.ToggleHongHeiDian.gameObject, this.OnClickToggleHuType)
	message:AddClick(hylhqObj.ToggletianDiHaiHu.gameObject, this.OnClickToggleHuType)
	message:AddClick(hylhqObj.TogglemingWei.gameObject, this.OnClickToggleHuType)
	message:AddClick(hylhqObj.ToggleLiangPao.gameObject, this.OnClickToggleHuType)
	message:AddClick(hylhqObj.ToggleYiHuYiTun.gameObject, this.OnClickToggleHuType)
	message:AddClick(hylhqObj.Toggle21Zhang.gameObject, this.OnClickToggleHuType)

	message:AddClick(hylhqObj.ToggleOnNiao.gameObject, this.OnClickNiao)
	message:AddClick(hylhqObj.ToggleOffNiao.gameObject, this.OnClickNiao)
	message:AddClick(hylhqObj.AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(hylhqObj.SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)

	message:AddClick(hylhqObj.ToggleNoChouPai.gameObject, this.OnClickToggleChouPai)
	message:AddClick(hylhqObj.ToggleChouPai10.gameObject, this.OnClickToggleChouPai)
	message:AddClick(hylhqObj.ToggleChouPai20.gameObject, this.OnClickToggleChouPai)

	message:AddClick(hylhqObj.ToggleFan.gameObject, this.OnClickToggleFanType)
	message:AddClick(hylhqObj.ToggleGen.gameObject, this.OnClickToggleFanType)
	message:AddClick(hylhqObj.ToggleNo.gameObject, this.OnClickToggleFanType)

	message:AddClick(hylhqObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(hylhqObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(hylhqObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(hylhqObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)

	message:AddClick(hylhqObj.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(hylhqObj.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(hylhqObj.ToggleMultiple4.gameObject, this.OnClickMultiple)

	message:AddClick(hylhqObj.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(hylhqObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(hylhqObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(hylhqObj.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(hylhqObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)

	message:AddClick(hylhqObj.ToggleOneRoundDouble.gameObject, this.OnClickRoundDouble)
	message:AddClick(hylhqObj.ToggleAllRoundDouble.gameObject, this.OnClickRoundDouble)

	message:AddClick(hylhqObj.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(hylhqObj.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(hylhqObj.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(hylhqObj.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(hylhqObj.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(hylhqObj.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(hylhqObj.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(hylhqObj.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)
	
	message:AddClick(hylhqObj.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(hylhqObj.ToggleGPScheck.gameObject, this.OnClickPreventCheat)

end
function this.Refresh()
	print('Refresh_HYLHQ')
	hylhqData.rounds=UnityEngine.PlayerPrefs.GetInt('NewHYLHQrounds', 10)
	hylhqData.size=UnityEngine.PlayerPrefs.GetInt('NewHYLHQsize', 2)
	hylhqData.paymentType=UnityEngine.PlayerPrefs.GetInt('NewHYLHQpaymentType', 0)
	hylhqData.randomBanker=UnityEngine.PlayerPrefs.GetInt('NewHYLHQrandomBanker', 0)==1
	hylhqData.qihuhuxu=UnityEngine.PlayerPrefs.GetInt('NewHYLHQqihuhuxu', 6)

	hylhqData.difen2fen=UnityEngine.PlayerPrefs.GetInt('NewHYLHQdifen2fen', 1)==1
	hylhqData.yiwushi=UnityEngine.PlayerPrefs.GetInt('NewHYLHQyiwushi', 0)==1
	hylhqData.youhubihu=UnityEngine.PlayerPrefs.GetInt('NewHYLHQyouhubihu', 0)==1
	hylhqData.hongheidian=UnityEngine.PlayerPrefs.GetInt('NewHYLHQhongheidian', 0)==1
	hylhqData.tiandihaihu=UnityEngine.PlayerPrefs.GetInt('NewHYLHQtiandihaihu', 0)==1
	hylhqData.mingwei=UnityEngine.PlayerPrefs.GetInt('NewHYLHQmingwei', 0)==1
	hylhqData.liangpao=UnityEngine.PlayerPrefs.GetInt('NewHYLHQliangpao', 0)==1
	hylhqData.yihuyitun=UnityEngine.PlayerPrefs.GetInt('NewHYLHQyihuyitun', 0)==1
	hylhqData.play21=UnityEngine.PlayerPrefs.GetInt('NewHYLHQplay21', 0)==1
	hylhqData.choupai=UnityEngine.PlayerPrefs.GetInt('NewHYLHQchoupai', 20)

	hylhqData.niao=UnityEngine.PlayerPrefs.GetInt('NewHYLHQniao', 0) == 1
	hylhqData.niaoValue=UnityEngine.PlayerPrefs.GetInt('NewHYLHQniaoValue', 10)

	hylhqData.xingType=UnityEngine.PlayerPrefs.GetInt('NewHYLHQxingType', 2)

	hylhqData.choiceDouble=UnityEngine.PlayerPrefs.GetInt('NewHYLHQchoiceDouble', 0)==1
	hylhqData.doubleScore=UnityEngine.PlayerPrefs.GetInt('NewHYLHQdoubleScore', 10)
	hylhqData.multiple=UnityEngine.PlayerPrefs.GetInt('NewHYLHQmultiple', 2)
	hylhqData.singleRoundDouble=UnityEngine.PlayerPrefs.GetInt('NewHYLHQsingleRoundDouble', 0)==1

	hylhqData.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewHYLHQisSettlementScore', 0)==1
	hylhqData.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewHYLHQfewerValue', 10)
	hylhqData.addValue=UnityEngine.PlayerPrefs.GetInt('NewHYLHQaddValue', 10)

	hylhqData.trusteeshipTime=UnityEngine.PlayerPrefs.GetInt('NewHYLHQtrusteeshipTime', 0)
	hylhqData.trusteeshipType = UnityEngine.PlayerPrefs.GetInt('NewHYLHQtrusteeshipType', 0) == 1
	hylhqData.trusteeshipRound = UnityEngine.PlayerPrefs.GetInt('NewHYLHQtrusteeshipRound', 0)
	
	hylhqData.openIp=UnityEngine.PlayerPrefs.GetInt('HYLHQcheckIP', 0)==1
	hylhqData.openGps=UnityEngine.PlayerPrefs.GetInt('HYLHQcheckGPS', 0)==1

	hylhqObj.ToggleRound6:GetComponent('UIToggle'):Set(hylhqData.rounds == 6)
	hylhqObj.ToggleRound8:GetComponent('UIToggle'):Set(hylhqData.rounds == 8)
	hylhqObj.ToggleRound10:GetComponent('UIToggle'):Set(hylhqData.rounds == 10)
	hylhqObj.ToggleRound16:GetComponent('UIToggle'):Set(hylhqData.rounds == 16)

	hylhqObj.TogglePeopleNum2:GetComponent('UIToggle'):Set(hylhqData.size == 2)
    hylhqObj.TogglePeopleNum3:GetComponent('UIToggle'):Set(hylhqData.size == 3)
	hylhqObj.TogglePeopleNum4:GetComponent('UIToggle'):Set(hylhqData.size == 4)

	hylhqObj.ToggleMasterPay:GetComponent('UIToggle'):Set(hylhqData.paymentType == 0)
	hylhqObj.ToggleWinnerPay:GetComponent('UIToggle'):Set(hylhqData.paymentType == 2)

	hylhqObj.ToggleRandomBanker:GetComponent('UIToggle'):Set(hylhqData.randomBanker)
	hylhqObj.ToggleBankerFrist:GetComponent('UIToggle'):Set(not hylhqData.randomBanker)

	hylhqObj.ToggleQiHuHuXu6:GetComponent('UIToggle'):Set(hylhqData.qihuhuxu == 6)
	hylhqObj.ToggleQiHuHuXu9:GetComponent('UIToggle'):Set(hylhqData.qihuhuxu == 9)

	hylhqObj.ToggleBaseScore2:GetComponent('UIToggle'):Set(hylhqData.difen2fen)
	hylhqObj.Toggle1510:GetComponent('UIToggle'):Set(hylhqData.yiwushi)
	hylhqObj.TogglecantPassHu:GetComponent('UIToggle'):Set(hylhqData.youhubihu)
	hylhqObj.ToggleHongHeiDian:GetComponent('UIToggle'):Set(hylhqData.hongheidian)
	hylhqObj.ToggletianDiHaiHu:GetComponent('UIToggle'):Set(hylhqData.tiandihaihu)
	hylhqObj.TogglemingWei:GetComponent('UIToggle'):Set(hylhqData.mingwei)
	hylhqObj.ToggleLiangPao:GetComponent('UIToggle'):Set(hylhqData.liangpao)
	hylhqObj.ToggleYiHuYiTun:GetComponent('UIToggle'):Set(hylhqData.yihuyitun)
	hylhqObj.Toggle21Zhang:GetComponent('UIToggle'):Set(hylhqData.play21)
	hylhqObj.Toggle21Zhang.gameObject:SetActive(hylhqData.size==2 or hylhqData.size==3)

	hylhqObj.ToggleNoChouPai.parent.gameObject:SetActive(hylhqData.size==2)
	hylhqObj.ToggleNoChouPai:GetComponent('UIToggle'):Set(hylhqData.choupai == 0)
	hylhqObj.ToggleChouPai10:GetComponent('UIToggle'):Set(hylhqData.choupai == 10)
	hylhqObj.ToggleChouPai20:GetComponent('UIToggle'):Set(hylhqData.choupai == 20)

	hylhqObj.ToggleOnNiao:GetComponent('UIToggle'):Set(hylhqData.niao)
	hylhqObj.ToggleOffNiao:GetComponent('UIToggle'):Set(not hylhqData.niao)
	hylhqObj.NiaoValueText.parent.gameObject:SetActive(hylhqData.niao)
	hylhqObj.NiaoValueText:GetComponent('UILabel').text = hylhqData.niaoValue.."分"

	hylhqObj.ToggleFan:GetComponent('UIToggle'):Set(0 == hylhqData.xingType)
	hylhqObj.ToggleGen:GetComponent('UIToggle'):Set(1 == hylhqData.xingType)
	hylhqObj.ToggleNo:GetComponent('UIToggle'):Set(2 == hylhqData.xingType)

	hylhqObj.ToggleChoiceDouble.parent.gameObject:SetActive(hylhqData.size==2)
	hylhqObj.ToggleMultiple2.parent.gameObject:SetActive(hylhqData.size==2 and hylhqData.choiceDouble)
	hylhqObj.ToggleOneRoundDouble.parent.gameObject:SetActive(hylhqData.size==2 and hylhqData.choiceDouble)

	hylhqObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(hylhqData.choiceDouble)
	hylhqObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not hylhqData.choiceDouble)

	hylhqObj.DoubleScoreText.parent.gameObject:SetActive(hylhqData.choiceDouble)
	hylhqObj.ToggleIPcheck:GetComponent('UIToggle'):Set(hylhqData.openIp)
	hylhqObj.ToggleGPScheck:GetComponent('UIToggle'):Set(hylhqData.openGps)
	
	if hylhqData.doubleScore == 0 then
		hylhqObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		hylhqObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..hylhqData.doubleScore..'分'
	end

	hylhqObj.ToggleMultiple2:GetComponent('UIToggle'):Set(hylhqData.multiple == 2)
	hylhqObj.ToggleMultiple3:GetComponent('UIToggle'):Set(hylhqData.multiple == 3)
	hylhqObj.ToggleMultiple4:GetComponent('UIToggle'):Set(hylhqData.multiple == 4)

	hylhqObj.ToggleIPcheck.parent.gameObject:SetActive(hylhqData.size > 2 and CONST.IPcheckOn)
	hylhqObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(hylhqData.size==2)
	hylhqObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(hylhqData.isSettlementScore)
	hylhqObj.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	hylhqObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = hylhqData.fewerValue
	hylhqObj.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	hylhqObj.ToggleAddScoreTxt:GetComponent('UILabel').text = hylhqData.addValue

	hylhqObj.ToggleOneRoundDouble:GetComponent('UIToggle'):Set(hylhqData.singleRoundDouble)
	hylhqObj.ToggleAllRoundDouble:GetComponent('UIToggle'):Set(not hylhqData.singleRoundDouble)

	hylhqObj.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(hylhqData.trusteeshipTime == 0)
	hylhqObj.ToggleTrusteeship1:GetComponent('UIToggle'):Set(hylhqData.trusteeshipTime == 1)
	hylhqObj.ToggleTrusteeship2:GetComponent('UIToggle'):Set(hylhqData.trusteeshipTime == 2)
	hylhqObj.ToggleTrusteeship3:GetComponent('UIToggle'):Set(hylhqData.trusteeshipTime == 3)
	hylhqObj.ToggleTrusteeship5:GetComponent('UIToggle'):Set(hylhqData.trusteeshipTime == 5)
	hylhqObj.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(hylhqData.trusteeshipType)
	hylhqObj.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not hylhqData.trusteeshipType and hylhqData.trusteeshipRound == 0)
	hylhqObj.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(hylhqData.trusteeshipRound == 3);
	hylhqObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(hylhqData.trusteeshipTime ~= 0)

	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.HYLHQ,hylhqData.rounds,nil,nil)
	HYLHQ:Find('table'):GetComponent('UIGrid'):Reposition()
end
--获取当前设置
function this.GetConfig()
	local moneyLess = false
	if (hylhqData.rounds < 16 and info_login.balance < 2) or
        (hylhqData.rounds == 16 and info_login.balance < 3) then
        moneyLess = true
    end
    local body = {}
    body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.HYLHQ)
	body.rounds = hylhqData.rounds
    body.size = hylhqData.size
    body.paymentType = hylhqData.paymentType
	body.randomBanker = hylhqData.randomBanker
	body.bottom2Score = hylhqData.difen2fen
	body.yiWuShi = hylhqData.yiwushi
	body.haveHuMustHu = hylhqData.youhubihu
	body.heiHongDian = hylhqData.hongheidian
	body.tianDiHaiHu = hylhqData.tiandihaihu
	body.canMingWei = hylhqData.mingwei
	body.oneHuOneTun = hylhqData.yihuyitun
	if hylhqData.size == 4 then
		body.play21 = false 
	else
		body.play21 = hylhqData.play21
	end
	body.liangZhangDianPao = hylhqData.liangpao
	body.chou = hylhqData.size == 2 and hylhqData.choupai or 0
	if hylhqData.size == 3 then
		body.choiceDouble = false
		body.doubleScore =0
		body.multiple=0
	elseif hylhqData.size == 2 then
		body.choiceDouble=hylhqData.choiceDouble
		body.doubleScore =hylhqData.choiceDouble and hylhqData.doubleScore or 0
		body.multiple =hylhqData.choiceDouble and hylhqData.multiple or 0
		body.singleRoundDouble = hylhqData.choiceDouble and hylhqData.singleRoundDouble
	end

	if hylhqData.size == 2 then
		body.resultScore = hylhqData.isSettlementScore
		if hylhqData.isSettlementScore then
			body.resultLowerScore=hylhqData.fewerValue
			body.resultAddScore=hylhqData.addValue
		end
		hylhqData.openIp=false
		hylhqData.openGps=false
	end
	
	body.qiHuHuXi = hylhqData.qihuhuxu
	body.niao = hylhqData.niao 
	body.niaoValue = hylhqData.niao and hylhqData.niaoValue or 0
	body.xing = hylhqData.xingType
    body.trusteeship = hylhqData.trusteeshipTime*60;
    body.trusteeshipDissolve = hylhqData.trusteeshipType
    body.trusteeshipRound = hylhqData.trusteeshipRound
	body.openIp	 = hylhqData.openIp
	body.openGps = hylhqData.openGps
	
    return moneyLess,body
end

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
    if hylhqObj.ToggleRound6.gameObject == go then
        hylhqData.rounds = 6
	elseif hylhqObj.ToggleRound8.gameObject == go then
        hylhqData.rounds = 8
    elseif hylhqObj.ToggleRound10.gameObject == go then
        hylhqData.rounds = 10
    else
        hylhqData.rounds = 16
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.HYLHQ,hylhqData.rounds,nil,nil)
    UnityEngine.PlayerPrefs.SetInt('NewHYLHQrounds', hylhqData.rounds)
end

function this.OnClickTogglePlayerNum(go)
	AudioManager.Instance:PlayAudio('btn')
    if hylhqObj.TogglePeopleNum2.gameObject == go then
        hylhqData.size = 2
    elseif hylhqObj.TogglePeopleNum3.gameObject == go then
		hylhqData.size = 3
	elseif hylhqObj.TogglePeopleNum4.gameObject == go then
        hylhqData.size = 4
	end

	hylhqObj.ToggleIPcheck.parent.gameObject:SetActive(hylhqData.size > 2 and CONST.IPcheckOn)
	hylhqObj.ToggleChoiceDouble.parent.gameObject:SetActive(hylhqData.size==2)
	hylhqObj.ToggleMultiple2.parent.gameObject:SetActive(hylhqData.size==2 and hylhqData.choiceDouble)
	hylhqObj.DoubleScoreText.parent.gameObject:SetActive(hylhqData.choiceDouble)
	hylhqObj.ToggleOneRoundDouble.parent.gameObject:SetActive(hylhqData.size==2 and hylhqData.choiceDouble)

	hylhqObj.Toggle21Zhang.gameObject:SetActive(hylhqData.size==2 or hylhqData.size==3)
	hylhqObj.ToggleNoChouPai.parent.gameObject:SetActive(hylhqData.size==2)
	hylhqObj.ToggleNoChouPai:GetComponent('UIToggle'):Set(hylhqData.choupai == 0)
	hylhqObj.ToggleChouPai10:GetComponent('UIToggle'):Set(hylhqData.choupai == 10)
	hylhqObj.ToggleChouPai20:GetComponent('UIToggle'):Set(hylhqData.choupai == 20)

	hylhqObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(hylhqData.size==2)

	HYLHQ:Find('table'):GetComponent('UIGrid'):Reposition()
	UnityEngine.PlayerPrefs.SetInt('NewHYLHQsize', hylhqData.size)
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if hylhqObj.ToggleMasterPay.gameObject == go then
        hylhqData.paymentType=0
    elseif hylhqObj.ToggleWinnerPay.gameObject == go then
		hylhqData.paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewHYLHQpaymentType', hylhqData.paymentType)
end

function this.OnClickRandomBanker(go)
    AudioManager.Instance:PlayAudio('btn')
    if hylhqObj.ToggleRandomBanker.gameObject == go then
        hylhqData.randomBanker = true
    elseif hylhqObj.ToggleBankerFrist.gameObject == go then
        hylhqData.randomBanker = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewHYLHQrandomBanker', hylhqData.randomBanker and 1 or 0)
end

function this.OnClickQiHuHuXu(go)
    AudioManager.Instance:PlayAudio('btn')
    if hylhqObj.ToggleQiHuHuXu6.gameObject == go then
        hylhqData.qihuhuxu = 6
    elseif hylhqObj.ToggleQiHuHuXu9.gameObject == go then
        hylhqData.qihuhuxu = 9
    end
    UnityEngine.PlayerPrefs.SetInt('NewHYLHQqihuhuxu', hylhqData.qihuhuxu)
end

function this.OnClickToggleHuType(go)
	AudioManager.Instance:PlayAudio('btn')
    if hylhqObj.ToggleBaseScore2.gameObject == go then
		hylhqData.difen2fen = hylhqObj.ToggleBaseScore2:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewHYLHQdifen2fen', hylhqData.difen2fen and 1 or 0)
    elseif hylhqObj.Toggle1510.gameObject == go then
		hylhqData.yiwushi = hylhqObj.Toggle1510:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewHYLHQyiwushi', hylhqData.yiwushi and 1 or 0)
	elseif hylhqObj.TogglecantPassHu.gameObject == go then
		hylhqData.youhubihu = hylhqObj.TogglecantPassHu:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewHYLHQyouhubihu', hylhqData.youhubihu and 1 or 0)
	elseif hylhqObj.ToggleHongHeiDian.gameObject == go then
		hylhqData.hongheidian = hylhqObj.ToggleHongHeiDian:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewHYLHQhongheidian', hylhqData.hongheidian and 1 or 0)
	elseif hylhqObj.ToggletianDiHaiHu.gameObject == go then
		hylhqData.tiandihaihu = hylhqObj.ToggletianDiHaiHu:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewHYLHQtiandihaihu', hylhqData.tiandihaihu and 1 or 0)
	elseif hylhqObj.TogglemingWei.gameObject == go then
		hylhqData.mingwei = hylhqObj.TogglemingWei:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewHYLHQmingwei', hylhqData.mingwei and 1 or 0)
	elseif hylhqObj.ToggleLiangPao.gameObject == go then
		hylhqData.liangpao = hylhqObj.ToggleLiangPao:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewHYLHQliangpao', hylhqData.liangpao and 1 or 0)
	elseif hylhqObj.ToggleYiHuYiTun.gameObject == go then
		hylhqData.yihuyitun = hylhqObj.ToggleYiHuYiTun:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewHYLHQyihuyitun', hylhqData.yihuyitun and 1 or 0)
	elseif hylhqObj.Toggle21Zhang.gameObject == go then
		hylhqData.play21 = hylhqObj.Toggle21Zhang:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('NewHYLHQplay21', hylhqData.play21 and 1 or 0)
	else
		Debugger.log('unkown button')
    end
end

function this.OnClickToggleChouPai(go)
	AudioManager.Instance:PlayAudio('btn')
	if hylhqObj.ToggleNoChouPai.gameObject == go then
		hylhqData.choupai = 0
	elseif hylhqObj.ToggleChouPai10.gameObject == go then
		hylhqData.choupai = 10
	elseif hylhqObj.ToggleChouPai20.gameObject == go then
		hylhqData.choupai = 20
	end
	UnityEngine.PlayerPrefs.SetInt('NewHYLHQchoupai', hylhqData.choupai)
end

function this.OnClickNiao(go)
	AudioManager.Instance:PlayAudio('btn')
    if hylhqObj.ToggleOnNiao.gameObject == go then
		hylhqData.niao = true
		if hylhqData.niaoValue==0 then
			hylhqData.niaoValue=10
		end
    elseif hylhqObj.ToggleOffNiao.gameObject == go then
		hylhqData.niao = false
		hylhqData.niaoValue=0
	end
	hylhqObj.NiaoValueText:GetComponent('UILabel').text = hylhqData.niaoValue.."分"
    hylhqObj.NiaoValueText.parent.gameObject:SetActive(hylhqData.niao)
    UnityEngine.PlayerPrefs.SetInt('NewHYLHQniao', hylhqData.niao and 1 or 0)
end

function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
    if hylhqObj.AddButtonNiao.gameObject == go then
        hylhqData.niaoValue = hylhqData.niaoValue + 10
        if hylhqData.niaoValue > 100 then
            hylhqData.niaoValue = 100
        end
    elseif hylhqObj.SubtractButtonNiao.gameObject == go then
        hylhqData.niaoValue = hylhqData.niaoValue - 10
        if hylhqData.niaoValue < 10 then
            hylhqData.niaoValue = 10
        end
    end
    hylhqObj.NiaoValueText:GetComponent('UILabel').text = hylhqData.niaoValue.."分"
    UnityEngine.PlayerPrefs.SetInt('NewHYLHQniaoValue', hylhqData.niaoValue)
end

function this.OnClickToggleFanType(go)
	AudioManager.Instance:PlayAudio('btn')
    if hylhqObj.ToggleFan.gameObject == go then
		hylhqData.xingType = 0
	elseif hylhqObj.ToggleGen.gameObject == go then
		hylhqData.xingType = 1
	else
		hylhqData.xingType = 2
	end
	UnityEngine.PlayerPrefs.SetInt('NewHYLHQxingType', hylhqData.xingType)
end

function this.OnClickChoiceDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if hylhqObj.ToggleChoiceDouble.gameObject == go then
        hylhqData.choiceDouble = true
    elseif hylhqObj.ToggleNoChoiceDouble.gameObject == go then
        hylhqData.choiceDouble = false
    end
    hylhqObj.DoubleScoreText.parent.gameObject:SetActive(hylhqData.choiceDouble)
	hylhqObj.ToggleMultiple2.parent.gameObject:SetActive(hylhqData.choiceDouble)
	hylhqObj.ToggleOneRoundDouble.parent.gameObject:SetActive(hylhqData.choiceDouble)
    HYLHQ:Find('table'):GetComponent('UIGrid'):Reposition()
    UnityEngine.PlayerPrefs.SetInt('NewHYLHQchoiceDouble', hylhqData.choiceDouble and 1 or 0)
end

function this.OnClickChangeDoubleScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if hylhqObj.AddDoubleScoreButton.gameObject == go then
        if hylhqData.doubleScore ~= 0 then
            hylhqData.doubleScore = hylhqData.doubleScore + 1
            if hylhqData.doubleScore > 100 then
				hylhqData.doubleScore = 0
            end
        end
    else
        if hylhqData.doubleScore == 0 then
            hylhqData.doubleScore = 100
        else
            hylhqData.doubleScore = hylhqData.doubleScore - 1
            if hylhqData.doubleScore < 1 then
                hylhqData.doubleScore = 1
            end
        end
    end
    if hylhqData.doubleScore == 0 then
        hylhqObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
    else
        hylhqObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..hylhqData.doubleScore..'分'
    end
    UnityEngine.PlayerPrefs.SetInt('NewHYLHQdoubleScore',hylhqData.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
    if hylhqObj.ToggleMultiple2.gameObject == go then
        hylhqData.multiple=2
    elseif hylhqObj.ToggleMultiple3.gameObject == go then
        hylhqData.multiple=3
    elseif hylhqObj.ToggleMultiple4.gameObject == go then
		hylhqData.multiple=4
    end
    UnityEngine.PlayerPrefs.SetInt('NewHYLHQmultiple', hylhqData.multiple)
end

function this.OnClickRoundDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if hylhqObj.ToggleOneRoundDouble.gameObject == go then
        hylhqData.singleRoundDouble=true
    elseif hylhqObj.ToggleAllRoundDouble.gameObject == go then
		hylhqData.singleRoundDouble=false
    end
    UnityEngine.PlayerPrefs.SetInt('NewHYLHQsingleRoundDouble', hylhqData.singleRoundDouble and 1 or 0)
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if hylhqObj.ToggleTrusteeshipNo.gameObject == go then
        hylhqData.trusteeshipTime = 0
    elseif hylhqObj.ToggleTrusteeship1.gameObject == go then
        hylhqData.trusteeshipTime = 1
	elseif hylhqObj.ToggleTrusteeship2.gameObject == go then
		hylhqData.trusteeshipTime = 2
	elseif hylhqObj.ToggleTrusteeship3.gameObject == go then
        hylhqData.trusteeshipTime = 3
    elseif hylhqObj.ToggleTrusteeship5.gameObject == go then
        hylhqData.trusteeshipTime = 5
	end
    UnityEngine.PlayerPrefs.SetInt('NewHYLHQtrusteeshipTime', hylhqData.trusteeshipTime)
	hylhqObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(hylhqData.trusteeshipTime ~= 0)
	HYLHQ:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if hylhqObj.ToggleTrusteeshipOne.gameObject == go then
        hylhqData.trusteeshipType = true
		hylhqData.trusteeshipRound =0;
    elseif hylhqObj.ToggleTrusteeshipAll.gameObject == go then
        hylhqData.trusteeshipType = false
		hylhqData.trusteeshipRound = 0;
	elseif hylhqObj.ToggleTrusteeshipThree.gameObject == go then
		hylhqData.trusteeshipType = false;
		hylhqData.trusteeshipRound = 3;
    end
    UnityEngine.PlayerPrefs.SetInt('NewHYLHQtrusteeshipType',hylhqData.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewHYLHQtrusteeshipRound',hylhqData.trusteeshipRound)
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    hylhqData.isSettlementScore= hylhqObj.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewHYLHQisSettlementScore', hylhqData.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if hylhqObj.ToggleFewerAddButton.gameObject == go then
		hylhqData.fewerValue = hylhqData.fewerValue + 1
		if hylhqData.fewerValue > 100 then
			hylhqData.fewerValue = 100
		end
    elseif hylhqObj.ToggleFewerSubtractButton.gameObject == go then
		hylhqData.fewerValue = hylhqData.fewerValue - 1
		if hylhqData.fewerValue < 1 then
			hylhqData.fewerValue = 1
		end
	end
	hylhqObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = hylhqData.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewHYLHQfewerValue', hylhqData.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if hylhqObj.ToggleAddAddButton.gameObject == go then
		hylhqData.addValue = hylhqData.addValue + 1
		if hylhqData.addValue > 100 then
			hylhqData.addValue = 100
		end
    elseif hylhqObj.ToggleAddSubtractButton.gameObject == go then
		hylhqData.addValue = hylhqData.addValue - 1
		if hylhqData.addValue < 1 then
			hylhqData.addValue = 1
		end
	end
	hylhqObj.ToggleAddScoreTxt:GetComponent('UILabel').text = hylhqData.addValue
	UnityEngine.PlayerPrefs.SetInt('NewHYLHQaddValue', hylhqData.addValue)
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if hylhqObj.ToggleIPcheck.gameObject == go then
		hylhqData.openIp = hylhqObj.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('HYLHQcheckIP', hylhqData.openIp and 1 or 0)
	elseif hylhqObj.ToggleGPScheck.gameObject == go then
		hylhqData.openGps = hylhqObj.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('HYLHQcheckGPS', hylhqData.openGps and 1 or 0)
	end
end

return this