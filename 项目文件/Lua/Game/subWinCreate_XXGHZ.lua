local this = {}

local XXGHZ
local payLabel

local xxghzObj={}
local xxghzData={}
function this.Init(grid,message)
	print('Init_XXGHZ')
	XXGHZ = grid
    payLabel = message.transform:Find('diamond/pay_label')

	xxghzObj.TogglePeopleNum2 = XXGHZ:Find('table/num/num2');
	xxghzObj.TogglePeopleNum3 = XXGHZ:Find('table/num/num3');

	xxghzObj.ToggleMasterPay = XXGHZ:Find('table/pay/master');
	xxghzObj.ToggleWinnerPay = XXGHZ:Find('table/pay/win');
	
	xxghzObj.ToggleRandomBanker = XXGHZ:Find('table/randomBanker/Auto');
	xxghzObj.ToggleBankerFrist = XXGHZ:Find('table/randomBanker/Frist');

	xxghzObj.TogglePlayTuo = XXGHZ:Find('table/tuo/PlayTuo');
	xxghzObj.ToggleNotTuo = XXGHZ:Find('table/tuo/NotTuo');

	xxghzObj.ToggleXXGHZQiHu6 = XXGHZ:Find('table/QiHu/6');
	xxghzObj.ToggleXXGHZQiHu10 = XXGHZ:Find('table/QiHu/10');
	xxghzObj.ToggleXXGHZQiHu15 = XXGHZ:Find('table/QiHu/15');

	xxghzObj.ToggleChou0 = XXGHZ:Find('table/chouCard/chouCard0')
	xxghzObj.ToggleChou10 = XXGHZ:Find('table/chouCard/chouCard10')
	xxghzObj.ToggleChou20 = XXGHZ:Find('table/chouCard/chouCard20')

	xxghzObj.ToggleChoiceDouble = XXGHZ:Find('table/choiceDouble/On');
	xxghzObj.ToggleNoChoiceDouble = XXGHZ:Find('table/choiceDouble/Off');
	xxghzObj.DoubleScoreText = XXGHZ:Find('table/choiceDouble/doubleScore/Value');
	xxghzObj.AddDoubleScoreButton = XXGHZ:Find('table/choiceDouble/doubleScore/AddButton')
	xxghzObj.SubtractDoubleScoreButton = XXGHZ:Find('table/choiceDouble/doubleScore/SubtractButton')

	xxghzObj.ToggleMultiple2 = XXGHZ:Find('table/multiple/2');
	xxghzObj.ToggleMultiple3 = XXGHZ:Find('table/multiple/3');
	xxghzObj.ToggleMultiple4 = XXGHZ:Find('table/multiple/4');

	xxghzObj.ToggleTrusteeshipNo = XXGHZ:Find('table/DelegateChoose/NoDelegate')
	xxghzObj.ToggleTrusteeship1 = XXGHZ:Find('table/DelegateChoose/Delegate1')
	xxghzObj.ToggleTrusteeship2 = XXGHZ:Find('table/DelegateChoose/Delegate2')
	xxghzObj.ToggleTrusteeship3 = XXGHZ:Find('table/DelegateChoose/Delegate3')
	xxghzObj.ToggleTrusteeship5 = XXGHZ:Find('table/DelegateChoose/Delegate5')

	xxghzObj.ToggleTrusteeshipAll = XXGHZ:Find('table/DelegateCancel/FullRound')
	xxghzObj.ToggleTrusteeshipOne = XXGHZ:Find('table/DelegateCancel/ThisRound')
	xxghzObj.ToggleTrusteeshipThree = XXGHZ:Find('table/DelegateCancel/ThreeRound')

	xxghzObj.ToggleSettlementScoreSelect=XXGHZ:Find('table/settlementScore/select')
	xxghzObj.ToggleFewerScoreTxt=XXGHZ:Find('table/settlementScore/fewerValue/Value')
	xxghzObj.ToggleFewerAddButton=XXGHZ:Find('table/settlementScore/fewerValue/AddButton')
	xxghzObj.ToggleFewerSubtractButton=XXGHZ:Find('table/settlementScore/fewerValue/SubtractButton')
	xxghzObj.ToggleAddScoreTxt=XXGHZ:Find('table/settlementScore/addValue/Value')
	xxghzObj.ToggleAddAddButton=XXGHZ:Find('table/settlementScore/addValue/AddButton')
	xxghzObj.ToggleAddSubtractButton=XXGHZ:Find('table/settlementScore/addValue/SubtractButton')
	
	xxghzObj.ToggleIPcheck = XXGHZ:Find('table/PreventCheat/IPcheck')
	xxghzObj.ToggleGPScheck = XXGHZ:Find('table/PreventCheat/GPScheck')

	message:AddClick(xxghzObj.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
    message:AddClick(xxghzObj.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)
	
	message:AddClick(xxghzObj.ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(xxghzObj.ToggleWinnerPay.gameObject, this.OnClickTogglePayType)

	message:AddClick(xxghzObj.ToggleRandomBanker.gameObject, this.OnClickRandomBanker)
	message:AddClick(xxghzObj.ToggleBankerFrist.gameObject, this.OnClickRandomBanker)

	message:AddClick(xxghzObj.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(xxghzObj.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(xxghzObj.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(xxghzObj.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(xxghzObj.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(xxghzObj.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(xxghzObj.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(xxghzObj.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)

	message:AddClick(xxghzObj.TogglePlayTuo.gameObject, this.OnClickPlayTuo)
	message:AddClick(xxghzObj.ToggleNotTuo.gameObject, this.OnClickPlayTuo)

	message:AddClick(xxghzObj.ToggleXXGHZQiHu6.gameObject, this.OnClickXXGHZQiHu)
	message:AddClick(xxghzObj.ToggleXXGHZQiHu10.gameObject, this.OnClickXXGHZQiHu)
	message:AddClick(xxghzObj.ToggleXXGHZQiHu15.gameObject, this.OnClickXXGHZQiHu)
	
	message:AddClick(xxghzObj.ToggleChou0.gameObject, this.OnClickToggleChou)
	message:AddClick(xxghzObj.ToggleChou10.gameObject, this.OnClickToggleChou)
	message:AddClick(xxghzObj.ToggleChou20.gameObject, this.OnClickToggleChou)

	message:AddClick(xxghzObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(xxghzObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(xxghzObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(xxghzObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)

	message:AddClick(xxghzObj.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(xxghzObj.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(xxghzObj.ToggleMultiple4.gameObject, this.OnClickMultiple)

	message:AddClick(xxghzObj.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(xxghzObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(xxghzObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(xxghzObj.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(xxghzObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)
	
	message:AddClick(xxghzObj.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(xxghzObj.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end
function this.Refresh()
	print('Refresh_XXGHZ')
	xxghzData.size=UnityEngine.PlayerPrefs.GetInt('NewXXGHZsize', 2)
	xxghzData.paymentType=UnityEngine.PlayerPrefs.GetInt('NewXXGHZpaymentType', 0)
	xxghzData.randomBanker=UnityEngine.PlayerPrefs.GetInt('NewXXGHZrandomBanker', 0)==1
	xxghzData.trusteeshipTime=UnityEngine.PlayerPrefs.GetInt('NewXXGHZtrusteeshipTime', 0)
	xxghzData.trusteeshipType = UnityEngine.PlayerPrefs.GetInt('NewXXGHZtrusteeshipType', 0) == 1
	xxghzData.trusteeshipRound = UnityEngine.PlayerPrefs.GetInt('NewXXGHZtrusteeshipRound', 0)

	xxghzData.tuo=UnityEngine.PlayerPrefs.GetInt('NewXXGHZtuo', 0)==1
	xxghzData.qihu=UnityEngine.PlayerPrefs.GetInt('NewXXGHZqihu', 6)
	xxghzData.choiceDouble=UnityEngine.PlayerPrefs.GetInt('NewXXGHZchoiceDouble', 0)==1
	xxghzData.doubleScore=UnityEngine.PlayerPrefs.GetInt('NewXXGHZdoubleScore', 10)
	xxghzData.multiple=UnityEngine.PlayerPrefs.GetInt('NewXXGHZmultiple', 2)

	xxghzData.isSettlementScore=UnityEngine.PlayerPrefs.GetInt('NewXXGHZisSettlementScore', 0)==1
	xxghzData.fewerValue=UnityEngine.PlayerPrefs.GetInt('NewXXGHZfewerValue', 10)
	xxghzData.addValue=UnityEngine.PlayerPrefs.GetInt('NewXXGHZaddValue', 10)
	xxghzData.openIp=UnityEngine.PlayerPrefs.GetInt('XXGHZcheckIP', 0)==1
	xxghzData.openGps=UnityEngine.PlayerPrefs.GetInt('XXGHZcheckGPS', 0)==1

	xxghzData.chou = UnityEngine.PlayerPrefs.GetInt('NewXXGHZchou', 20)
	xxghzObj.ToggleChou0:GetComponent('UIToggle'):Set(xxghzData.chou == 0)
	xxghzObj.ToggleChou10:GetComponent('UIToggle'):Set(xxghzData.chou == 10)
	xxghzObj.ToggleChou20:GetComponent('UIToggle'):Set(xxghzData.chou == 20)
	xxghzObj.ToggleChou0.parent.gameObject:SetActive(xxghzData.size == 2)

	xxghzObj.TogglePeopleNum2:GetComponent('UIToggle'):Set(xxghzData.size == 2)
    xxghzObj.TogglePeopleNum3:GetComponent('UIToggle'):Set(xxghzData.size == 3)
	
	xxghzObj.ToggleMasterPay:GetComponent('UIToggle'):Set(xxghzData.paymentType == 0)
	xxghzObj.ToggleWinnerPay:GetComponent('UIToggle'):Set(xxghzData.paymentType == 2)

	xxghzObj.ToggleRandomBanker:GetComponent('UIToggle'):Set(xxghzData.randomBanker)
	xxghzObj.ToggleBankerFrist:GetComponent('UIToggle'):Set(not xxghzData.randomBanker)

	xxghzObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(xxghzData.size==2)
	xxghzObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(xxghzData.isSettlementScore)
	xxghzObj.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	xxghzObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = xxghzData.fewerValue
	xxghzObj.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	xxghzObj.ToggleAddScoreTxt:GetComponent('UILabel').text = xxghzData.addValue

	xxghzObj.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(xxghzData.trusteeshipTime == 0)
	xxghzObj.ToggleTrusteeship1:GetComponent('UIToggle'):Set(xxghzData.trusteeshipTime == 1)
	xxghzObj.ToggleTrusteeship2:GetComponent('UIToggle'):Set(xxghzData.trusteeshipTime == 2)
	xxghzObj.ToggleTrusteeship3:GetComponent('UIToggle'):Set(xxghzData.trusteeshipTime == 3)
	xxghzObj.ToggleTrusteeship5:GetComponent('UIToggle'):Set(xxghzData.trusteeshipTime == 5)
	xxghzObj.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(xxghzData.trusteeshipType)
	xxghzObj.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not xxghzData.trusteeshipType and xxghzData.trusteeshipRound == 0)
	xxghzObj.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(xxghzData.trusteeshipRound == 3);
	xxghzObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(xxghzData.trusteeshipTime ~= 0)
	xxghzObj.ToggleIPcheck.parent.gameObject:SetActive(xxghzData.size > 2 and CONST.IPcheckOn)

	xxghzObj.TogglePlayTuo:GetComponent('UIToggle'):Set(xxghzData.tuo)
	xxghzObj.ToggleNotTuo:GetComponent('UIToggle'):Set(not xxghzData.tuo)
	xxghzObj.ToggleXXGHZQiHu6:GetComponent('UIToggle'):Set(xxghzData.qihu == 6)
	xxghzObj.ToggleXXGHZQiHu10:GetComponent('UIToggle'):Set(xxghzData.qihu == 10)
	xxghzObj.ToggleXXGHZQiHu15:GetComponent('UIToggle'):Set(xxghzData.qihu == 15)

	xxghzObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(xxghzData.choiceDouble)
	xxghzObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not xxghzData.choiceDouble)
	xxghzObj.DoubleScoreText.parent.gameObject:SetActive(xxghzData.choiceDouble)
	if xxghzData.doubleScore == 0 then
		xxghzObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		xxghzObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..xxghzData.doubleScore..'分'
	end
	xxghzObj.ToggleChoiceDouble.parent.gameObject:SetActive(xxghzData.size == 2)

	xxghzObj.ToggleMultiple2:GetComponent('UIToggle'):Set(xxghzData.multiple == 2)
	xxghzObj.ToggleMultiple3:GetComponent('UIToggle'):Set(xxghzData.multiple == 3)
	xxghzObj.ToggleMultiple4:GetComponent('UIToggle'):Set(xxghzData.multiple == 4)
	xxghzObj.ToggleMultiple2.parent.gameObject:SetActive(xxghzData.choiceDouble and xxghzData.size == 2)
	xxghzObj.ToggleIPcheck:GetComponent('UIToggle'):Set(xxghzData.openIp)
	xxghzObj.ToggleGPScheck:GetComponent('UIToggle'):Set(xxghzData.openGps)

	XXGHZ:Find('table'):GetComponent('UIGrid'):Reposition()
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.XXGHZ,nil,nil,nil)
end
--获取当前设置
function this.GetConfig()
	local moneyLess = false
    if info_login.balance < 2 then
        moneyLess = true
    end
    local body = {}
    body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.XXGHZ)
	body.rounds = 0
    body.size = xxghzData.size
    body.paymentType = xxghzData.paymentType
    body.randomBanker = xxghzData.randomBanker
    body.trusteeship = xxghzData.trusteeshipTime*60;
    body.trusteeshipDissolve = xxghzData.trusteeshipType;
    body.trusteeshipRound = xxghzData.trusteeshipRound;

	if xxghzData.size == 2 then
		body.resultScore = xxghzData.isSettlementScore
		if xxghzData.isSettlementScore then
			body.resultLowerScore=xxghzData.fewerValue
			body.resultAddScore=xxghzData.addValue
		end
	end
	body.chou = xxghzData.size == 2 and xxghzData.chou or 0
    body.tuo = xxghzData.tuo
    body.qiHuHuXi = xxghzData.qihu
    if xxghzData.size == 2 then
        body.choiceDouble = xxghzData.choiceDouble
        body.doubleScore = xxghzData.doubleScore
        body.multiple = xxghzData.multiple
		xxghzData.openIp=false
		xxghzData.openGps=false
    end
	body.openIp	 = xxghzData.openIp
	body.openGps = xxghzData.openGps
    return moneyLess,body;
end

function this.OnClickTogglePlayerNum(go)
    AudioManager.Instance:PlayAudio('btn')
	if xxghzObj.TogglePeopleNum2.gameObject == go then
        xxghzData.size = 2
    elseif xxghzObj.TogglePeopleNum3.gameObject == go then
        xxghzData.size = 3
    end
	xxghzObj.ToggleIPcheck.parent.gameObject:SetActive(xxghzData.size > 2 and CONST.IPcheckOn)
    UnityEngine.PlayerPrefs.SetInt('NewXXGHZsize', xxghzData.size)
    xxghzObj.ToggleNoChoiceDouble.parent.gameObject:SetActive(xxghzData.size==2)
    xxghzObj.ToggleMultiple2.parent.gameObject:SetActive(xxghzData.choiceDouble and xxghzData.size==2)
	xxghzObj.DoubleScoreText.parent.gameObject:SetActive(xxghzData.choiceDouble)
	xxghzObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(xxghzData.size==2)
	xxghzObj.ToggleChou0.parent.gameObject:SetActive(xxghzData.size==2)
    XXGHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if xxghzObj.ToggleMasterPay.gameObject == go then
        xxghzData.paymentType=0
    elseif xxghzObj.ToggleWinnerPay.gameObject == go then
        xxghzData.paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewXXGHZpaymentType', xxghzData.paymentType)
end

function this.OnClickRandomBanker(go)
    AudioManager.Instance:PlayAudio('btn')
    if xxghzObj.ToggleRandomBanker.gameObject == go then
        xxghzData.randomBanker = true
    elseif xxghzObj.ToggleBankerFrist.gameObject == go then
        xxghzData.randomBanker = false
    end
    UnityEngine.PlayerPrefs.SetInt('NewXXGHZrandomBanker', xxghzData.randomBanker and 1 or 0)
end

function this.OnClickToggleChou(go)
	AudioManager.Instance:PlayAudio('btn')
	if xxghzObj.ToggleChou0.gameObject == go then
        xxghzData.chou=0
    elseif xxghzObj.ToggleChou10.gameObject == go then
        xxghzData.chou=10
    elseif xxghzObj.ToggleChou20.gameObject == go then
        xxghzData.chou=20
	end
	UnityEngine.PlayerPrefs.SetInt('NewXXGHZchou', xxghzData.chou)
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if xxghzObj.ToggleTrusteeshipNo.gameObject == go then
        xxghzData.trusteeshipTime = 0
    elseif xxghzObj.ToggleTrusteeship1.gameObject == go then
        xxghzData.trusteeshipTime = 1
	elseif xxghzObj.ToggleTrusteeship2.gameObject == go then
		xxghzData.trusteeshipTime = 2
	elseif xxghzObj.ToggleTrusteeship3.gameObject == go then
        xxghzData.trusteeshipTime = 3
    elseif xxghzObj.ToggleTrusteeship5.gameObject == go then
        xxghzData.trusteeshipTime = 5
    end
    UnityEngine.PlayerPrefs.SetInt('NewXXGHZtrusteeshipTime', xxghzData.trusteeshipTime)
	xxghzObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(xxghzData.trusteeshipTime ~= 0)
	XXGHZ:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if xxghzObj.ToggleTrusteeshipOne.gameObject == go then
		xxghzData.trusteeshipType = true
		xxghzData.trusteeshipRound = 0;
    elseif xxghzObj.ToggleTrusteeshipAll.gameObject == go then
        xxghzData.trusteeshipType = false
		xxghzData.trusteeshipRound = 0;
	elseif xxghzObj.ToggleTrusteeshipThree.gameObject == go then
		xxghzData.trusteeshipType = false;
		xxghzData.trusteeshipRound = 3;
    end
    UnityEngine.PlayerPrefs.SetInt('NewXXGHZtrusteeshipType',xxghzData.trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewXXGHZtrusteeshipRound',xxghzData.trusteeshipRound )
end

function this.OnClickChoiceDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if xxghzObj.ToggleChoiceDouble.gameObject == go then
        xxghzData.choiceDouble = true
    elseif xxghzObj.ToggleNoChoiceDouble.gameObject == go then
        xxghzData.choiceDouble = false
    end
    xxghzObj.DoubleScoreText.parent.gameObject:SetActive(xxghzData.choiceDouble)
    xxghzObj.ToggleMultiple2.parent.gameObject:SetActive(xxghzData.choiceDouble)
    XXGHZ:Find('table'):GetComponent('UIGrid'):Reposition()
    UnityEngine.PlayerPrefs.SetInt('NewXXGHZchoiceDouble', xxghzData.choiceDouble and 1 or 0)
end

function this.OnClickChangeDoubleScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if xxghzObj.AddDoubleScoreButton.gameObject == go then
        if xxghzData.doubleScore ~= 0 then
            xxghzData.doubleScore = xxghzData.doubleScore + 1
            if xxghzData.doubleScore > 100 then
                xxghzData.doubleScore = 0
            end
        end
    else
        if xxghzData.doubleScore == 0 then
            xxghzData.doubleScore = 100
        else
            xxghzData.doubleScore = xxghzData.doubleScore - 1
            if xxghzData.doubleScore < 1 then
                xxghzData.doubleScore = 1
            end
        end
    end
    if xxghzData.doubleScore == 0 then
        xxghzObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
    else
        xxghzObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..xxghzData.doubleScore..'分'
    end
    UnityEngine.PlayerPrefs.SetInt('NewXXGHZdoubleScore', xxghzData.doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
	if createRoomType == 11 then	
		if xxghzObj.ToggleMultiple2.gameObject == go then
			xxghzData.multiple=2
		elseif xxghzObj.ToggleMultiple3.gameObject == go then
			xxghzData.multiple=3
		elseif xxghzObj.ToggleMultiple4.gameObject == go then
			xxghzData.multiple=4
		end
		UnityEngine.PlayerPrefs.SetInt('NewXXGHZmultiple', xxghzData.multiple)
	end
end

function this.OnClickPlayTuo(go)
	AudioManager.Instance:PlayAudio('btn')
	if xxghzObj.TogglePlayTuo.gameObject == go then
		xxghzData.tuo = true
	elseif xxghzObj.ToggleNotTuo.gameObject == go then
		xxghzData.tuo = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewXXGHZtuo', xxghzData.tuo and 1 or 0)
end

function this.OnClickXXGHZQiHu(go)
	AudioManager.Instance:PlayAudio('btn')
	if xxghzObj.ToggleXXGHZQiHu6.gameObject == go then
		xxghzData.qihu=6
	elseif xxghzObj.ToggleXXGHZQiHu10.gameObject == go then
		xxghzData.qihu=10
	elseif xxghzObj.ToggleXXGHZQiHu15.gameObject == go then
		xxghzData.qihu=15
	end
	UnityEngine.PlayerPrefs.SetInt('NewXXGHZqihu',xxghzData.qihu)
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    xxghzData.isSettlementScore= xxghzObj.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
    UnityEngine.PlayerPrefs.SetInt('NewXXGHZisSettlementScore', xxghzData.isSettlementScore and 1 or 0)
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if xxghzObj.ToggleFewerAddButton.gameObject == go then
		xxghzData.fewerValue = xxghzData.fewerValue + 1
		if xxghzData.fewerValue > 100 then
			xxghzData.fewerValue = 100
		end
    elseif xxghzObj.ToggleFewerSubtractButton.gameObject == go then
		xxghzData.fewerValue = xxghzData.fewerValue - 1
		if xxghzData.fewerValue < 1 then
			xxghzData.fewerValue = 1
		end
	end
	xxghzObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = xxghzData.fewerValue
	UnityEngine.PlayerPrefs.SetInt('NewXXGHZfewerValue', xxghzData.fewerValue)
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if xxghzObj.ToggleAddAddButton.gameObject == go then
		xxghzData.addValue = xxghzData.addValue + 1
		if xxghzData.addValue > 100 then
			xxghzData.addValue = 100
		end
    elseif xxghzObj.ToggleAddSubtractButton.gameObject == go then
		xxghzData.addValue = xxghzData.addValue - 1
		if xxghzData.addValue < 1 then
			xxghzData.addValue = 1
		end
	end
	xxghzObj.ToggleAddScoreTxt:GetComponent('UILabel').text = xxghzData.addValue
	UnityEngine.PlayerPrefs.SetInt('NewXXGHZaddValue', xxghzData.addValue)
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if xxghzObj.ToggleIPcheck.gameObject == go then
		xxghzData.openIp = xxghzObj.ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('XXGHZcheckIP', xxghzData.openIp and 1 or 0)
	elseif xxghzObj.ToggleGPScheck.gameObject == go then
		xxghzData.openGps = xxghzObj.ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('XXGHZcheckGPS', xxghzData.openGps and 1 or 0)
	end
end

return this