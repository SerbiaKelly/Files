local json = require 'json'
panelCreateYJQFSet = {}
local this = panelCreateYJQFSet

local message
local gameObject
local wanFaTitle --玩法
local payLabel
local ButtonOK
local PKYJQF
local pkyjqfObj = {}
local pkyjqfData = {}

local roomType
local optionData = {}
local curSelectPlay = {}
--启动事件--
function this.Awake(obj)
	gameObject = obj
	message = gameObject:GetComponent('LuaBehaviour')

	wanFaTitle = gameObject.transform:Find('title/Label')
	payLabel = gameObject.transform:Find('pay_label')

	PKYJQF = gameObject.transform:Find('scorllView')
	message:AddClick(gameObject.transform:Find('ButtonClose').gameObject, function (go)
		AudioManager.Instance:PlayAudio('btn')
    	PanelManager.Instance:HideWindow(gameObject.name)
	end)
	ButtonOK = gameObject.transform:Find('ButtonOK/Background')
	message:AddClick(ButtonOK.gameObject, this.OnClickButtonOK)

	message:AddClick(gameObject.transform:Find('RuleButton').gameObject, function (go)
		AudioManager.Instance:PlayAudio('btn')
    	PanelManager.Instance:ShowWindow("panelHelp", proxy_pb.PKYJQF)
	end)

	pkyjqfObj.TogglePeopleNum2 = PKYJQF:Find('table/num/2')
	pkyjqfObj.TogglePeopleNum3 = PKYJQF:Find('table/num/3')
	message:AddClick(pkyjqfObj.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(pkyjqfObj.TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum)
	
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

function this.Start()
end

function this.Update()
end


function this.WhoShow(data)
	roomType = data.roomType
	wanFaTitle:GetComponent("UILabel").text = "当前玩法:"..data.name
	if data.optionData ~=nil then 
		optionData 			= data.optionData
		optionData.playId 	= data.playId
		optionData.ruleId 	= data.ruleId
	end
	curSelectPlay = {}
	if not data.optionData.addPlay and not data.optionData.addRule then
		curSelectPlay = json:decode(data.settings)
	end
	this.OnEnableRefresh()
end

function this.OnEnableRefresh()
	if optionData.addRule or optionData.addPlay then
		pkyjqfData.size = 2
		pkyjqfData.happly = false
		pkyjqfData.rewardScore = 100
		pkyjqfData.retainCard = false
		pkyjqfData.bonusScore = 1
		pkyjqfData.choiceDouble = false
		pkyjqfData.doubleScore = 100
		pkyjqfData.multiple = 2
		pkyjqfData.isSettlementScore = false
		pkyjqfData.fewerValue = 100
		pkyjqfData.addValue = 100
		pkyjqfData.trusteeshipTime = 0
		pkyjqfData.trusteeshipType = false
		pkyjqfData.trusteeshipRound = 0
		pkyjqfData.openIp = false
		pkyjqfData.openGps = false
	elseif not optionData.addPlay and not optionData.addRule then
		pkyjqfData.size = curSelectPlay.size
		pkyjqfData.happly = curSelectPlay.happly
		pkyjqfData.rewardScore = curSelectPlay.rewardScore
		pkyjqfData.retainCard = curSelectPlay.retainCard
		pkyjqfData.bonusScore = curSelectPlay.bonusScore
		
		if curSelectPlay.resultScore then
			pkyjqfData.isSettlementScore = curSelectPlay.resultScore
			pkyjqfData.fewerValue = curSelectPlay.resultLowerScore
			pkyjqfData.addValue = curSelectPlay.resultAddScore
		else
			pkyjqfData.fewerValue = 100
			pkyjqfData.addValue = 100
		end
		if curSelectPlay.choiceDouble ~= nil then
			pkyjqfData.choiceDouble = curSelectPlay.choiceDouble
			pkyjqfData.doubleScore = curSelectPlay.doubleScore
			pkyjqfData.multiple = curSelectPlay.multiple
		else
			pkyjqfData.choiceDouble = false
			pkyjqfData.doubleScore = 100
			pkyjqfData.multiple = 2
		end
		pkyjqfData.trusteeshipTime = (curSelectPlay.trusteeship/60)
		pkyjqfData.trusteeshipType = curSelectPlay.trusteeshipDissolve
		pkyjqfData.trusteeshipRound = curSelectPlay.trusteeshipRound
		pkyjqfData.openIp = curSelectPlay.openIp
		pkyjqfData.openGps = curSelectPlay.openGps
	end
	pkyjqfObj.TogglePeopleNum2:GetComponent('UIToggle'):Set(pkyjqfData.size == 2)
	pkyjqfObj.TogglePeopleNum3:GetComponent('UIToggle'):Set(pkyjqfData.size == 3)

	pkyjqfObj.ToggleHappyAdd:GetComponent('UIToggle'):Set(not pkyjqfData.happly)
	pkyjqfObj.ToggleHappyMultiply:GetComponent('UIToggle'):Set(pkyjqfData.happly)

	pkyjqfObj.RewardScoreValue:GetComponent("UILabel").text = pkyjqfData.rewardScore..'分'

	pkyjqfObj.ToggleRetainCard:GetComponent('UIToggle'):Set(pkyjqfData.retainCard)
	
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

	pkyjqfObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(pkyjqfData.size==2)
	pkyjqfObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(pkyjqfData.isSettlementScore)
	pkyjqfObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = pkyjqfData.fewerValue
	pkyjqfObj.ToggleAddScoreTxt:GetComponent('UILabel').text = pkyjqfData.addValue

	pkyjqfObj.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(pkyjqfData.trusteeshipTime == 0)
	pkyjqfObj.ToggleTrusteeship1:GetComponent('UIToggle'):Set(pkyjqfData.trusteeshipTime == 1)
	pkyjqfObj.ToggleTrusteeship2:GetComponent('UIToggle'):Set(pkyjqfData.trusteeshipTime == 2)
	pkyjqfObj.ToggleTrusteeship3:GetComponent('UIToggle'):Set(pkyjqfData.trusteeshipTime == 3)
	pkyjqfObj.ToggleTrusteeship5:GetComponent('UIToggle'):Set(pkyjqfData.trusteeshipTime == 5)
	pkyjqfObj.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(pkyjqfData.trusteeshipType)
	pkyjqfObj.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not pkyjqfData.trusteeshipType and pkyjqfData.trusteeshipRound == 0)
	pkyjqfObj.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(pkyjqfData.trusteeshipRound == 3)
	pkyjqfObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(pkyjqfData.trusteeshipTime ~= 0)

	pkyjqfObj.ToggleIPcheck.parent.gameObject:SetActive(pkyjqfData.size > 2 and CONST.IPcheckOn)
	pkyjqfObj.ToggleIPcheck:GetComponent('UIToggle'):Set(pkyjqfData.openIp)
	pkyjqfObj.ToggleGPScheck:GetComponent('UIToggle'):Set(pkyjqfData.openGps)

	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.PKYJQF,nil,pkyjqfData.size,nil)
	PKYJQF:Find('table'):GetComponent('UIGrid'):Reposition()
	PKYJQF:GetComponent('UIScrollView'):ResetPosition()
end

function this.OnClickButtonOK(go)
	local body = {}
	body.paymentType = 3
	body.roomType = proxy_pb.PKYJQF
    body.size = pkyjqfData.size
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
	
	for k, v in pairs(body) do
		print(k,v)
	end
	--判断是增加，修改还是删除
	if optionData.addPlay == true then 
		optionData.currentOption = "addPlay"
		local msg 			= Message.New()
		msg.type 			= proxy_pb.CREATE_CLUB_PLAY
		local bigbody 		= proxy_pb.PCreateClubPlay()
		bigbody.gameType 	= proxy_pb.YJQF
		bigbody.roomType    = proxy_pb.PKYJQF
		bigbody.name 		= '沅江千分'
		bigbody.clubId 		= panelClub.clubInfo.clubId
		bigbody.settings 	= json:encode(body)
		msg.body 			= bigbody:SerializeToString()
		SendProxyMessage(msg, this.OnCreateClubPlayResult)
	elseif optionData.addRule == true then
		optionData.currentOption = "addRule"
		local msg 			= Message.New()
		msg.type 			= proxy_pb.CREATE_PLAY_RULE
		local bigbody 		= proxy_pb.PCreatePlayRule()
		bigbody.gameType    = proxy_pb.YJQF
		bigbody.playId 		= optionData.playId
		bigbody.clubId 		= panelClub.clubInfo.clubId
		bigbody.settings 	= json:encode(body)
		msg.body 			= bigbody:SerializeToString()
		SendProxyMessage(msg, this.OnCreateClubPlayResult)
	else
		optionData.currentOption = "updateRule"
		local msg 			= Message.New()
		msg.type 			= proxy_pb.UPDATE_PLAY_RULE
		local bigbody 		= proxy_pb.PUpdatePlayRule()
		bigbody.playId 		= optionData.playId
		bigbody.ruleId 		= optionData.ruleId
		bigbody.clubId 		= panelClub.clubInfo.clubId
		bigbody.settings 	= json:encode(body)
		msg.body 			= bigbody:SerializeToString()
		SendProxyMessage(msg, this.OnCreateClubPlayResult)
	end
	
	PanelManager.Instance:HideWindow(gameObject.name)
end
function this.OnCreateClubPlayResult(msg)
	print('OnCreateClubPlayResult was called')
	PanelManager.Instance:HideWindow(gameObject.name)
	if optionData.currentOption == "addPlay" then 
		panelMessageTip.SetParamers('添加玩法成功', 1.5)
	elseif optionData.currentOption == "addRule" then 
		panelMessageTip.SetParamers('添加规则成功', 1.5)
	elseif optionData.currentOption == "updateRule" then 
		panelMessageTip.SetParamers('更新规则成功', 1.5)
	end
	PanelManager.Instance:ShowWindow('panelMessageTip')
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
    pkyjqfObj.ToggleMultiple2.parent.gameObject:SetActive(pkyjqfData.choiceDouble and pkyjqfData.size==2)
	pkyjqfObj.DoubleScoreText.parent.gameObject:SetActive(pkyjqfData.choiceDouble)
	pkyjqfObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(pkyjqfData.size==2)
	pkyjqfObj.ToggleIPcheck.parent.gameObject:SetActive(pkyjqfData.size > 2 and CONST.IPcheckOn)
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.PKYJQF,pkyjqfData.rounds,nil,nil)
    PKYJQF:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickToggleHappyType(go)
	AudioManager.Instance:PlayAudio('btn')
    if pkyjqfObj.ToggleHappyAdd.gameObject == go then
        pkyjqfData.happly=false
    elseif pkyjqfObj.ToggleHappyMultiply.gameObject == go then
        pkyjqfData.happly=true
	end
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
end

function this.OnClickTogglePlay(go)
	AudioManager.Instance:PlayAudio('btn')
	pkyjqfData.retainCard = pkyjqfObj.ToggleRetainCard:GetComponent('UIToggle').value
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
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    pkyjqfData.isSettlementScore= pkyjqfObj.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
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
	print('pkyjqfData.trusteeshipTime = 5 :'..pkyjqfData.trusteeshipTime)
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
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if pkyjqfObj.ToggleIPcheck.gameObject == go then
		pkyjqfData.openIp = pkyjqfObj.ToggleIPcheck:GetComponent('UIToggle').value 
	elseif pkyjqfObj.ToggleGPScheck.gameObject == go then
		pkyjqfData.openGps = pkyjqfObj.ToggleGPScheck:GetComponent('UIToggle').value
	end
end