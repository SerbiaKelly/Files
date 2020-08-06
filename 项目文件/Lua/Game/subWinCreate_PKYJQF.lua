local this = {}

local PKYJQF
local payLabel

local pkyjqfObj = {}
local pkyjqfData = {}

function this.Init(grid,message)
	print('Init_PKYJQF')
	PKYJQF = grid
	payLabel = message.transform:Find('diamond/pay_label')

	pkyjqfObj.TogglePeopleNum2 = PKYJQF:Find('table/num/2')
	pkyjqfObj.TogglePeopleNum3 = PKYJQF:Find('table/num/3')
	message:AddClick(pkyjqfObj.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(pkyjqfObj.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)

	pkyjqfObj.ToggleMasterPay = PKYJQF:Find('table/pay/master')
	pkyjqfObj.ToggleWinnerPay = PKYJQF:Find('table/pay/win')
	message:AddClick(pkyjqfObj.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(pkyjqfObj.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)
	
	pkyjqfObj.ToggleHappyAdd = PKYJQF:Find('table/happly/add')
	pkyjqfObj.ToggleHappyMultiply = PKYJQF:Find('table/happly/multiply')
	message:AddClick(pkyjqfObj.ToggleHappyAdd.gameObject, this.OnClickToggleHappyType)
	message:AddClick(pkyjqfObj.ToggleHappyMultiply.gameObject, this.OnClickToggleHappyType)

	pkyjqfObj.AddBtnRewardScore = PKYJQF:Find('table/rewardScore/score/AddButton')
	pkyjqfObj.SubtractBtnRewardScore = PKYJQF:Find('table/rewardScore/score/SubtractButton')
	pkyjqfObj.RewardScoreValue = PKYJQF:Find('table/rewardScore/score/Value')
	message:AddClick(pkyjqfObj.AddBtnRewardScore.gameObject, this.OnClickChangeRewardScoreValue)
	message:AddClick(pkyjqfObj.SubtractBtnRewardScore.gameObject, this.OnClickChangeRewardScoreValue)

	pkyjqfObj.ToggleRetainCard = PKYJQF:Find('table/play/retainCard')
	message:AddClick(pkyjqfObj.ToggleRetainCard.gameObject, this.OnClickTogglePlay)

	pkyjqfObj.bonusScore1 = PKYJQF:Find('table/bonusScore1/1')
	pkyjqfObj.bonusScore2 = PKYJQF:Find('table/bonusScore2/2')
	pkyjqfObj.bonusScore3 = PKYJQF:Find('table/bonusScore3/3')
	message:AddClick(pkyjqfObj.bonusScore1.gameObject, this.OnClickToggleBonusScore)
	message:AddClick(pkyjqfObj.bonusScore2.gameObject, this.OnClickToggleBonusScore)
	message:AddClick(pkyjqfObj.bonusScore3.gameObject, this.OnClickToggleBonusScore)

	pkyjqfObj.ToggleChoiceDouble = PKYJQF:Find('table/choiceDouble/On')
	pkyjqfObj.ToggleNoChoiceDouble = PKYJQF:Find('table/choiceDouble/Off')
	pkyjqfObj.DoubleScoreText = PKYJQF:Find('table/choiceDouble/doubleScore/Value')
	pkyjqfObj.AddDoubleScoreButton = PKYJQF:Find('table/choiceDouble/doubleScore/AddButton')
	pkyjqfObj.SubtractDoubleScoreButton = PKYJQF:Find('table/choiceDouble/doubleScore/SubtractButton')
	pkyjqfObj.ToggleMultiple2 = PKYJQF:Find('table/multiple/2')
	pkyjqfObj.ToggleMultiple3 = PKYJQF:Find('table/multiple/3')
	pkyjqfObj.ToggleMultiple4 = PKYJQF:Find('table/multiple/4')
	message:AddClick(pkyjqfObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(pkyjqfObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(pkyjqfObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(pkyjqfObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(pkyjqfObj.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(pkyjqfObj.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(pkyjqfObj.ToggleMultiple4.gameObject, this.OnClickMultiple)
	
	pkyjqfObj.ToggleSettlementScoreSelect=PKYJQF:Find('table/settlementScore/select')
	pkyjqfObj.ToggleFewerScoreTxt=PKYJQF:Find('table/settlementScore/fewerValue/Value')
	pkyjqfObj.ToggleFewerAddButton=PKYJQF:Find('table/settlementScore/fewerValue/AddButton')
	pkyjqfObj.ToggleFewerSubtractButton=PKYJQF:Find('table/settlementScore/fewerValue/SubtractButton')
	pkyjqfObj.ToggleAddScoreTxt=PKYJQF:Find('table/settlementScore/addValue/Value')
	pkyjqfObj.ToggleAddAddButton=PKYJQF:Find('table/settlementScore/addValue/AddButton')
	pkyjqfObj.ToggleAddSubtractButton=PKYJQF:Find('table/settlementScore/addValue/SubtractButton')
	message:AddClick(pkyjqfObj.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(pkyjqfObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(pkyjqfObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(pkyjqfObj.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(pkyjqfObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)
	
	pkyjqfObj.ToggleTrusteeshipNo = PKYJQF:Find('table/DelegateChoose/NoDelegate')
	pkyjqfObj.ToggleTrusteeship1 = PKYJQF:Find('table/DelegateChoose/Delegate1')
	pkyjqfObj.ToggleTrusteeship2 = PKYJQF:Find('table/DelegateChoose/Delegate2')
	pkyjqfObj.ToggleTrusteeship3 = PKYJQF:Find('table/DelegateChoose/Delegate3')
	pkyjqfObj.ToggleTrusteeship5 = PKYJQF:Find('table/DelegateChoose1/Delegate5')
	pkyjqfObj.ToggleTrusteeshipAll = PKYJQF:Find('table/DelegateCancel/FullRound')
	pkyjqfObj.ToggleTrusteeshipOne = PKYJQF:Find('table/DelegateCancel/ThisRound')
	pkyjqfObj.ToggleTrusteeshipThree = PKYJQF:Find('table/DelegateCancel/ThreeRound')
	message:AddClick(pkyjqfObj.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pkyjqfObj.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pkyjqfObj.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pkyjqfObj.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pkyjqfObj.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pkyjqfObj.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(pkyjqfObj.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(pkyjqfObj.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)

	pkyjqfObj.ToggleIPcheck = PKYJQF:Find('table/PreventCheat/IPcheck')
	pkyjqfObj.ToggleGPScheck = PKYJQF:Find('table/PreventCheat/GPScheck')
	message:AddClick(pkyjqfObj.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(pkyjqfObj.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end
function this.Refresh()
	print('Refresh_PKYJQF')
	pkyjqfData.size=UnityEngine.PlayerPrefs.GetInt('NewPKYJQFsize', 2)
	pkyjqfObj.TogglePeopleNum2:GetComponent('UIToggle'):Set(pkyjqfData.size == 2)
	pkyjqfObj.TogglePeopleNum3:GetComponent('UIToggle'):Set(pkyjqfData.size == 3)
	
	pkyjqfData.paymentType=UnityEngine.PlayerPrefs.GetInt('NewPKYJQFpaymentType', 0)
	pkyjqfObj.ToggleMasterPay:GetComponent('UIToggle'):Set(pkyjqfData.paymentType == 0)
	pkyjqfObj.ToggleWinnerPay:GetComponent('UIToggle'):Set(pkyjqfData.paymentType == 2)

	pkyjqfData.happly=UnityEngine.PlayerPrefs.GetInt('NewPKYJQFhapply', 0)==1
	pkyjqfObj.ToggleHappyAdd:GetComponent('UIToggle'):Set(not pkyjqfData.happly)
	pkyjqfObj.ToggleHappyMultiply:GetComponent('UIToggle'):Set(pkyjqfData.happly)

	pkyjqfData.rewardScore=UnityEngine.PlayerPrefs.GetInt('NewPKYJQFrewardScore', 100)
	pkyjqfObj.RewardScoreValue:GetComponent("UILabel").text = pkyjqfData.rewardScore..'分'

	pkyjqfData.retainCard=UnityEngine.PlayerPrefs.GetInt('NewPKYJQFretainCard', 0)==1
	pkyjqfObj.ToggleRetainCard:GetComponent('UIToggle'):Set(pkyjqfData.retainCard)
	
	pkyjqfData.bonusScore = UnityEngine.PlayerPrefs.GetInt('NewPKYJQFbonusScore', 1)
	pkyjqfObj.bonusScore1:GetComponent('UIToggle'):Set(pkyjqfData.bonusScore == 1)
	pkyjqfObj.bonusScore2:GetComponent('UIToggle'):Set(pkyjqfData.bonusScore == 2)
	pkyjqfObj.bonusScore3:GetComponent('UIToggle'):Set(pkyjqfData.bonusScore == 3)
	pkyjqfObj.bonusScore3.parent.gameObject:SetActive(pkyjqfData.size ~= 2)
	if pkyjqfData.size == 2 then
		pkyjqfObj.bonusScore1:Find('Label'):GetComponent('UILabel').text = '第一名奖60分，第二名扣60分'
		pkyjqfObj.bonusScore2:Find('Label'):GetComponent('UILabel').text = '第一名奖40分，第二名扣40分'
	else
		pkyjqfObj.bonusScore1:Find('Label'):GetComponent('UILabel').text = '第一名奖100分，第二名扣40分，第三名扣60分'
		pkyjqfObj.bonusScore2:Find('Label'):GetComponent('UILabel').text = '第一名奖100分，第二名扣30分，第三名扣70分'
		pkyjqfObj.bonusScore3:Find('Label'):GetComponent('UILabel').text = '第一名奖40分，第二名不扣分，第三名扣40分'
	end

	pkyjqfData.choiceDouble=UnityEngine.PlayerPrefs.GetInt('NewPKYJQFchoiceDouble', 0)==1
	pkyjqfData.doubleScore=UnityEngine.PlayerPrefs.GetInt('NewPKYJQFdoubleScore', 100)
	pkyjqfData.multiple=UnityEngine.PlayerPrefs.GetInt('NewPKYJQFmultiple', 2)
	pkyjqfObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(pkyjqfData.choiceDouble)
	pkyjqfObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not pkyjqfData.choiceDouble)
	pkyjqfObj.DoubleScoreText.parent.gameObject:SetActive(pkyjqfData.choiceDouble)
	if pkyjqfData.doubleScore == 0 then
		pkyjqfObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		pkyjqfObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..pkyjqfData.doubleScore..'分'
	end
	pkyjqfObj.ToggleChoiceDouble.parent.gameObject:SetActive(pkyjqfData.size == 2)
	pkyjqfObj.ToggleMultiple2:GetComponent('UIToggle'):Set(pkyjqfData.multiple == 2)
	pkyjqfObj.ToggleMultiple3:GetComponent('UIToggle'):Set(pkyjqfData.multiple == 3)
	pkyjqfObj.ToggleMultiple4:GetComponent('UIToggle'):Set(pkyjqfData.multiple == 4)
	pkyjqfObj.ToggleMultiple2.parent.gameObject:SetActive(pkyjqfData.choiceDouble and  pkyjqfData.size == 2)

	pkyjqfData.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewPKYJQFisSettlementScore', 0)==1
	pkyjqfData.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewPKYJQFfewerValue', 100)
	pkyjqfData.addValue=UnityEngine.PlayerPrefs.GetInt('NewPKYJQFaddValue', 100)
	pkyjqfObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(pkyjqfData.size==2)
	pkyjqfObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(pkyjqfData.isSettlementScore)
	pkyjqfObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = pkyjqfData.fewerValue
	pkyjqfObj.ToggleAddScoreTxt:GetComponent('UILabel').text = pkyjqfData.addValue

	pkyjqfData.trusteeshipTime=UnityEngine.PlayerPrefs.GetInt('NewPKYJQFtrusteeshipTime', 0)
	pkyjqfData.trusteeshipType = UnityEngine.PlayerPrefs.GetInt('NewPKYJQFtrusteeshipType', 0) == 1
	pkyjqfData.trusteeshipRound = UnityEngine.PlayerPrefs.GetInt('NewPKYJQFtrusteeshipRound', 0)
	pkyjqfObj.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(pkyjqfData.trusteeshipTime == 0)
	pkyjqfObj.ToggleTrusteeship1:GetComponent('UIToggle'):Set(pkyjqfData.trusteeshipTime == 1)
	pkyjqfObj.ToggleTrusteeship2:GetComponent('UIToggle'):Set(pkyjqfData.trusteeshipTime == 2)
	pkyjqfObj.ToggleTrusteeship3:GetComponent('UIToggle'):Set(pkyjqfData.trusteeshipTime == 3)
	pkyjqfObj.ToggleTrusteeship5:GetComponent('UIToggle'):Set(pkyjqfData.trusteeshipTime == 5)
	pkyjqfObj.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(pkyjqfData.trusteeshipType)
	pkyjqfObj.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not pkyjqfData.trusteeshipType and pkyjqfData.trusteeshipRound == 0)
	pkyjqfObj.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(pkyjqfData.trusteeshipRound == 3)
	pkyjqfObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(pkyjqfData.trusteeshipTime ~= 0)

	pkyjqfData.openIp=UnityEngine.PlayerPrefs.GetInt('PKYJQFcheckIP', 0)==1
	pkyjqfData.openGps=UnityEngine.PlayerPrefs.GetInt('PKYJQFcheckGPS', 0)==1
	pkyjqfObj.ToggleIPcheck.parent.gameObject:SetActive(pkyjqfData.size > 2 and CONST.IPcheckOn)
	pkyjqfObj.ToggleIPcheck:GetComponent('UIToggle'):Set(pkyjqfData.openIp)
	pkyjqfObj.ToggleGPScheck:GetComponent('UIToggle'):Set(pkyjqfData.openGps)

	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.PKYJQF,nil,pkyjqfData.size,nil)
	PKYJQF:Find('table'):GetComponent('UIGrid'):Reposition()
end
--获取当前设置
function this.GetConfig()
	local moneyLess = false
	
    local body = {}
    body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.PKYJQF)
    body.size = pkyjqfData.size
	body.paymentType = pkyjqfData.paymentType
	body.happly = pkyjqfData.happly
	body.rewardScore = pkyjqfData.rewardScore
	body.retainCard = pkyjqfData.retainCard
	body.bonusScore = pkyjqfData.bonusScore
	if pkyjqfData.size == 2 then
		body.resultScore = pkyjqfData.isSettlementScore
		if pkyjqfData.isSettlementScore then
			body.resultLowerScore=pkyjqfData.fewerValue
			body.resultAddScore=pkyjqfData.addValue
		end
		body.choiceDouble = pkyjqfData.choiceDouble
        body.doubleScore = pkyjqfData.doubleScore
        body.multiple = pkyjqfData.multiple
		pkyjqfData.openIp=false
		pkyjqfData.openGps=false
	end
    body.trusteeship = pkyjqfData.trusteeshipTime*60
    body.trusteeshipDissolve = pkyjqfData.trusteeshipType
    body.trusteeshipRound = pkyjqfData.trusteeshipRound
	body.openIp	 = pkyjqfData.openIp
	body.openGps = pkyjqfData.openGps
    return moneyLess,body
end

function this.OnClickTogglePlayerNum(go)
	AudioManager.Instance:PlayAudio('btn')
    if pkyjqfObj.TogglePeopleNum2.gameObject == go then
        pkyjqfData.size = 2
    elseif pkyjqfObj.TogglePeopleNum3.gameObject == go then
        pkyjqfData.size = 3
    end
	pkyjqfObj.bonusScore3.parent.gameObject:SetActive(pkyjqfData.size ~= 2)
	if pkyjqfData.size == 2 then
		pkyjqfObj.bonusScore1:Find('Label'):GetComponent('UILabel').text = '第一名奖60分，第二名扣60分'
		pkyjqfObj.bonusScore2:Find('Label'):GetComponent('UILabel').text = '第一名奖40分，第二名扣40分'
		if pkyjqfData.bonusScore == 3 then
			this.OnClickToggleBonusScore(pkyjqfObj.bonusScore1.gameObject)
			pkyjqfObj.bonusScore1:GetComponent('UIToggle'):Set(pkyjqfData.bonusScore == 1)
			pkyjqfObj.bonusScore2:GetComponent('UIToggle'):Set(pkyjqfData.bonusScore == 2)
			pkyjqfObj.bonusScore3:GetComponent('UIToggle'):Set(pkyjqfData.bonusScore == 3)
		end
	else
		pkyjqfObj.bonusScore1:Find('Label'):GetComponent('UILabel').text = '第一名奖100分，第二名扣40分，第三名扣60分'
		pkyjqfObj.bonusScore2:Find('Label'):GetComponent('UILabel').text = '第一名奖100分，第二名扣30分，第三名扣70分'
		pkyjqfObj.bonusScore3:Find('Label'):GetComponent('UILabel').text = '第一名奖40分，第二名不扣分，第三名扣40分'
	end
	pkyjqfObj.ToggleNoChoiceDouble.parent.gameObject:SetActive(pkyjqfData.size==2)
    pkyjqfObj.ToggleMultiple2.parent.gameObject:SetActive(pkyjqfData.choiceDouble and pkyjqfData.size == 2)
	pkyjqfObj.DoubleScoreText.parent.gameObject:SetActive(pkyjqfData.choiceDouble)
	pkyjqfObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(pkyjqfData.size==2)
	pkyjqfObj.ToggleIPcheck.parent.gameObject:SetActive(pkyjqfData.size > 2 and CONST.IPcheckOn)
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.PKYJQF,pkyjqfData.rounds,nil,nil)
	UnityEngine.PlayerPrefs.SetInt('NewPKYJQFsize', pkyjqfData.size)
    PKYJQF:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if pkyjqfObj.ToggleMasterPay.gameObject == go then
        pkyjqfData.paymentType=0
    elseif pkyjqfObj.ToggleWinnerPay.gameObject == go then
        pkyjqfData.paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewPKYJQFpaymentType', pkyjqfData.paymentType)
end
function this.OnClickToggleHappyType(go)
	AudioManager.Instance:PlayAudio('btn')
    if pkyjqfObj.ToggleHappyAdd.gameObject == go then
        pkyjqfData.happly=false
    elseif pkyjqfObj.ToggleHappyMultiply.gameObject == go then
        pkyjqfData.happly=true
	end
	UnityEngine.PlayerPrefs.SetInt('NewPKYJQFhapply', pkyjqfData.happly and 1 or 0)
end

function this.OnClickChangeRewardScoreValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if pkyjqfObj.AddBtnRewardScore.gameObject == go then
		pkyjqfData.rewardScore = pkyjqfData.rewardScore + 100
		if pkyjqfData.rewardScore > 500 then
			pkyjqfData.rewardScore = 500
		end
    elseif pkyjqfObj.SubtractBtnRewardScore.gameObject == go then
        pkyjqfData.rewardScore = pkyjqfData.rewardScore - 100
		if pkyjqfData.rewardScore < 100 then
			pkyjqfData.rewardScore = 100
		end
	end
	pkyjqfObj.RewardScoreValue:GetComponent("UILabel").text = pkyjqfData.rewardScore..'分'
    UnityEngine.PlayerPrefs.SetInt('NewPKYJQFrewardScore', pkyjqfData.rewardScore)
end

function this.OnClickTogglePlay(go)
	AudioManager.Instance:PlayAudio('btn')
	pkyjqfData.retainCard = pkyjqfObj.ToggleRetainCard:GetComponent('UIToggle').value
	UnityEngine.PlayerPrefs.SetInt('NewPKYJQFretainCard', pkyjqfData.retainCard and 1 or 0)
end

function this.OnClickToggleBonusScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if pkyjqfObj.bonusScore1.gameObject == go then
        pkyjqfData.bonusScore = 1
    elseif pkyjqfObj.bonusScore2.gameObject == go then
        pkyjqfData.bonusScore = 2
	elseif pkyjqfObj.bonusScore3.gameObject == go then
		pkyjqfData.bonusScore = 3
    end
	UnityEngine.PlayerPrefs.SetInt('NewPKYJQFbonusScore', pkyjqfData.bonusScore)
end

function this.OnClickChoiceDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if pkyjqfObj.ToggleChoiceDouble.gameObject == go then
        pkyjqfData.choiceDouble = true
    elseif pkyjqfObj.ToggleNoChoiceDouble.gameObject == go then
        pkyjqfData.choiceDouble = false
    end
    pkyjqfObj.DoubleScoreText.parent.gameObject:SetActive(pkyjqfData.choiceDouble)
    pkyjqfObj.ToggleMultiple2.parent.gameObject:SetActive(pkyjqfData.choiceDouble)
    PKYJQF:Find('table'):GetComponent('UIGrid'):Reposition()
    UnityEngine.PlayerPrefs.SetInt('NewPKYJQFchoiceDouble', pkyjqfData.choiceDouble and 1 or 0)
end

function this.OnClickChangeDoubleScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if pkyjqfObj.AddDoubleScoreButton.gameObject == go then
        if pkyjqfData.doubleScore ~= 0 then
            pkyjqfData.doubleScore = pkyjqfData.doubleScore + 100
            if pkyjqfData.doubleScore > 1000 then
                pkyjqfData.doubleScore = 0
            end
        end
    else
        if pkyjqfData.doubleScore == 0 then
            pkyjqfData.doubleScore = 1000
        else
            pkyjqfData.doubleScore = pkyjqfData.doubleScore - 100
            if pkyjqfData.doubleScore < 100 then
                pkyjqfData.doubleScore = 100
            end
        end
    end
    if pkyjqfData.doubleScore == 0 then
        pkyjqfObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
    else
        pkyjqfObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..pkyjqfData.doubleScore..'分'
    end
    UnityEngine.PlayerPrefs.SetInt('NewPKYJQFdoubleScore', pkyjqfData.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
    if pkyjqfObj.ToggleMultiple2.gameObject == go then
        pkyjqfData.multiple=2
    elseif pkyjqfObj.ToggleMultiple3.gameObject == go then
        pkyjqfData.multiple=3
    elseif pkyjqfObj.ToggleMultiple4.gameObject == go then
        pkyjqfData.multiple=4
    end
    UnityEngine.PlayerPrefs.SetInt('NewPKYJQFmultiple', pkyjqfData.multiple)
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    pkyjqfData.isSettlementScore= pkyjqfObj.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewPKYJQFisSettlementScore', pkyjqfData.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if pkyjqfObj.ToggleFewerAddButton.gameObject == go then
		pkyjqfData.fewerValue = pkyjqfData.fewerValue + 100
		if pkyjqfData.fewerValue > 1000 then
			pkyjqfData.fewerValue = 1000
		end
    elseif pkyjqfObj.ToggleFewerSubtractButton.gameObject == go then
		pkyjqfData.fewerValue = pkyjqfData.fewerValue - 100
		if pkyjqfData.fewerValue < 100 then
			pkyjqfData.fewerValue = 100
		end
	end
	pkyjqfObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = pkyjqfData.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewPKYJQFfewerValue', pkyjqfData.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if pkyjqfObj.ToggleAddAddButton.gameObject == go then
		pkyjqfData.addValue = pkyjqfData.addValue + 100
		if pkyjqfData.addValue > 1000 then
			pkyjqfData.addValue = 1000
		end
    elseif pkyjqfObj.ToggleAddSubtractButton.gameObject == go then
		pkyjqfData.addValue = pkyjqfData.addValue - 100
		if pkyjqfData.addValue < 100 then
			pkyjqfData.addValue = 100
		end
	end
	pkyjqfObj.ToggleAddScoreTxt:GetComponent('UILabel').text = pkyjqfData.addValue
	UnityEngine.PlayerPrefs.SetInt('NewPKYJQFaddValue', pkyjqfData.addValue)
end


function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if pkyjqfObj.ToggleTrusteeshipNo.gameObject == go then
        pkyjqfData.trusteeshipTime = 0
    elseif pkyjqfObj.ToggleTrusteeship1.gameObject == go then
        pkyjqfData.trusteeshipTime = 1
	elseif pkyjqfObj.ToggleTrusteeship2.gameObject == go then
		pkyjqfData.trusteeshipTime = 2
    elseif pkyjqfObj.ToggleTrusteeship3.gameObject == go then
        pkyjqfData.trusteeshipTime = 3
    elseif pkyjqfObj.ToggleTrusteeship5.gameObject == go then
        pkyjqfData.trusteeshipTime = 5
    end
    UnityEngine.PlayerPrefs.SetInt('NewPKYJQFtrusteeshipTime', pkyjqfData.trusteeshipTime)
	pkyjqfObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(pkyjqfData.trusteeshipTime ~= 0)
	PKYJQF:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if pkyjqfObj.ToggleTrusteeshipOne.gameObject == go then
        pkyjqfData.trusteeshipType = true
		pkyjqfData.trusteeshipRound = 0
    elseif pkyjqfObj.ToggleTrusteeshipAll.gameObject == go then
        pkyjqfData.trusteeshipType = false
		pkyjqfData.trusteeshipRound = 0
	elseif pkyjqfObj.ToggleTrusteeshipThree.gameObject == go then
		pkyjqfData.trusteeshipType = false
		pkyjqfData.trusteeshipRound = 3
    end
    UnityEngine.PlayerPrefs.SetInt('NewPKYJQFtrusteeshipType',pkyjqfData.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewPKYJQFtrusteeshipRound',pkyjqfData.trusteeshipRound )
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if pkyjqfObj.ToggleIPcheck.gameObject == go then
		pkyjqfData.openIp = pkyjqfObj.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('PKYJQFcheckIP', pkyjqfData.openIp and 1 or 0)
	elseif pkyjqfObj.ToggleGPScheck.gameObject == go then
		pkyjqfData.openGps = pkyjqfObj.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('PKYJQFcheckGPS', pkyjqfData.openGps and 1 or 0)
	end
end

return this