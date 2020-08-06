local json = require 'json'
panelCreateHSTHSet = {}
local this = panelCreateHSTHSet

local message
local gameObject
local wanFaTitle --玩法
local payLabel
local ButtonOK
local PKHSTH
local pkhsthObj = {}
local pkhsthData = {}

local roomType
local optionData = {}
local curSelectPlay = {}
--启动事件--
function this.Awake(obj)
	gameObject = obj
	message = gameObject:GetComponent('LuaBehaviour')

	wanFaTitle = gameObject.transform:Find('title/Label')
	payLabel = gameObject.transform:Find('pay_label')

	PKHSTH = gameObject.transform:Find('scorllView')
	message:AddClick(gameObject.transform:Find('ButtonClose').gameObject, function (go)
		AudioManager.Instance:PlayAudio('btn')
    	PanelManager.Instance:HideWindow(gameObject.name)
	end)
	ButtonOK = gameObject.transform:Find('ButtonOK/Background')
	message:AddClick(ButtonOK.gameObject, this.OnClickButtonOK)

	message:AddClick(gameObject.transform:Find('RuleButton').gameObject, function (go)
		AudioManager.Instance:PlayAudio('btn')
    	PanelManager.Instance:ShowWindow("panelHelp", proxy_pb.PKHSTH)
	end)
	
	pkhsthObj.ToggleRound1 = PKHSTH:Find('table/round/1')
	pkhsthObj.ToggleRound2 = PKHSTH:Find('table/round/2')
	pkhsthObj.ToggleRound4 = PKHSTH:Find('table/round/4')
	pkhsthObj.ToggleRound8 = PKHSTH:Find('table/round/8')
	message:AddClick(pkhsthObj.ToggleRound1.gameObject, this.OnClickToggleRound)
	message:AddClick(pkhsthObj.ToggleRound2.gameObject, this.OnClickToggleRound)
	message:AddClick(pkhsthObj.ToggleRound4.gameObject, this.OnClickToggleRound)
	message:AddClick(pkhsthObj.ToggleRound8.gameObject, this.OnClickToggleRound)

	pkhsthObj.TogglePeopleNum2 = PKHSTH:Find('table/num/2')
	pkhsthObj.TogglePeopleNum4 = PKHSTH:Find('table/num/4')
	pkhsthObj.TogglePeopleNum6 = PKHSTH:Find('table/num/6')
	message:AddClick(pkhsthObj.TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(pkhsthObj.TogglePeopleNum4.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(pkhsthObj.TogglePeopleNum6.gameObject, this.OnClickTogglePlayerNum)
	
	pkhsthObj.ToggleCardCount0 = PKHSTH:Find('table/cardNum/0')
	pkhsthObj.ToggleCardCount1 = PKHSTH:Find('table/cardNum/1')
	pkhsthObj.ToggleCardCount2 = PKHSTH:Find('table/cardNum/2')
	pkhsthObj.ToggleCardCount3 = PKHSTH:Find('table/cardNum/3')
	message:AddClick(pkhsthObj.ToggleCardCount0.gameObject, this.OnClickToggleCardCount)
	message:AddClick(pkhsthObj.ToggleCardCount1.gameObject, this.OnClickToggleCardCount)
	message:AddClick(pkhsthObj.ToggleCardCount2.gameObject, this.OnClickToggleCardCount)
	message:AddClick(pkhsthObj.ToggleCardCount3.gameObject, this.OnClickToggleCardCount)

	pkhsthObj.ToggleSinkKill1 = PKHSTH:Find('table/chenSi/1')
	pkhsthObj.ToggleSinkKill2 = PKHSTH:Find('table/chenSi/2')
	message:AddClick(pkhsthObj.ToggleSinkKill1.gameObject, this.OnClickToggleSinkKill)
	message:AddClick(pkhsthObj.ToggleSinkKill2.gameObject, this.OnClickToggleSinkKill)

	pkhsthObj.ToggleSettlement1 = PKHSTH:Find('table/settlementMethod/1')
	pkhsthObj.ToggleSettlement2 = PKHSTH:Find('table/settlementMethod/2')
	message:AddClick(pkhsthObj.ToggleSettlement1.gameObject, this.OnClickToggleSettlement)
	message:AddClick(pkhsthObj.ToggleSettlement2.gameObject, this.OnClickToggleSettlement)

	pkhsthObj.ToggleTongHua1 = PKHSTH:Find('table/tongHua/1')
	pkhsthObj.ToggleTongHua2 = PKHSTH:Find('table/tongHua/2')
	pkhsthObj.ToggleTong9Add = PKHSTH:Find('table/tongHua/tong9Add')
	message:AddClick(pkhsthObj.ToggleTongHua1.gameObject, this.OnClickToggleTongHua)
	message:AddClick(pkhsthObj.ToggleTongHua2.gameObject, this.OnClickToggleTongHua)
	message:AddClick(pkhsthObj.ToggleTong9Add.gameObject, this.OnClickToggleTong9Add)

	pkhsthObj.ToggleShowCardNum = PKHSTH:Find('table/play1/showCardNum')
	message:AddClick(pkhsthObj.ToggleShowCardNum.gameObject, this.OnClickTogglePlay)
	pkhsthObj.ToggleTongSplit = PKHSTH:Find('table/play1/tongHuaBuChai')
	message:AddClick(pkhsthObj.ToggleTongSplit.gameObject, this.OnClickTogglePlay)
	pkhsthObj.ToggleRemoveRank = PKHSTH:Find('table/play1/no8')
	message:AddClick(pkhsthObj.ToggleRemoveRank.gameObject, this.OnClickTogglePlay)
	pkhsthObj.ToggleFriendVoice = PKHSTH:Find('table/play2/friendVoice')
	message:AddClick(pkhsthObj.ToggleFriendVoice.gameObject, this.OnClickTogglePlay)

	pkhsthObj.AddBtnRewardScore = PKHSTH:Find('table/rewardScore/score/AddButton')
	pkhsthObj.SubtractBtnRewardScore = PKHSTH:Find('table/rewardScore/score/SubtractButton')
	pkhsthObj.RewardScoreValue = PKHSTH:Find('table/rewardScore/score/Value')
	message:AddClick(pkhsthObj.AddBtnRewardScore.gameObject, this.OnClickChangeRewardScoreValue)
	message:AddClick(pkhsthObj.SubtractBtnRewardScore.gameObject, this.OnClickChangeRewardScoreValue)

	pkhsthObj.ToggleGrouping1 = PKHSTH:Find('table/organizeTeam/1')
	pkhsthObj.ToggleGrouping2 = PKHSTH:Find('table/organizeTeam/2')
	message:AddClick(pkhsthObj.ToggleGrouping1.gameObject, this.OnClickToggleGrouping)
	message:AddClick(pkhsthObj.ToggleGrouping2.gameObject, this.OnClickToggleGrouping)

	pkhsthObj.ToggleChoiceDouble = PKHSTH:Find('table/choiceDouble/On')
	pkhsthObj.ToggleNoChoiceDouble = PKHSTH:Find('table/choiceDouble/Off')
	pkhsthObj.DoubleScoreText = PKHSTH:Find('table/choiceDouble/doubleScore/Value')
	pkhsthObj.AddDoubleScoreButton = PKHSTH:Find('table/choiceDouble/doubleScore/AddButton')
	pkhsthObj.SubtractDoubleScoreButton = PKHSTH:Find('table/choiceDouble/doubleScore/SubtractButton')
	pkhsthObj.ToggleMultiple2 = PKHSTH:Find('table/multiple/2')
	pkhsthObj.ToggleMultiple3 = PKHSTH:Find('table/multiple/3')
	pkhsthObj.ToggleMultiple4 = PKHSTH:Find('table/multiple/4')
	message:AddClick(pkhsthObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(pkhsthObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(pkhsthObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(pkhsthObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(pkhsthObj.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(pkhsthObj.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(pkhsthObj.ToggleMultiple4.gameObject, this.OnClickMultiple)
	
	pkhsthObj.ToggleSettlementScoreSelect=PKHSTH:Find('table/settlementScore/select')
	pkhsthObj.ToggleFewerScoreTxt=PKHSTH:Find('table/settlementScore/fewerValue/Value')
	pkhsthObj.ToggleFewerAddButton=PKHSTH:Find('table/settlementScore/fewerValue/AddButton')
	pkhsthObj.ToggleFewerSubtractButton=PKHSTH:Find('table/settlementScore/fewerValue/SubtractButton')
	pkhsthObj.ToggleAddScoreTxt=PKHSTH:Find('table/settlementScore/addValue/Value')
	pkhsthObj.ToggleAddAddButton=PKHSTH:Find('table/settlementScore/addValue/AddButton')
	pkhsthObj.ToggleAddSubtractButton=PKHSTH:Find('table/settlementScore/addValue/SubtractButton')
	message:AddClick(pkhsthObj.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(pkhsthObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(pkhsthObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(pkhsthObj.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(pkhsthObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)
	
	pkhsthObj.ToggleTrusteeshipNo = PKHSTH:Find('table/DelegateChoose/NoDelegate')
	pkhsthObj.ToggleTrusteeship1 = PKHSTH:Find('table/DelegateChoose/Delegate1')
	pkhsthObj.ToggleTrusteeship2 = PKHSTH:Find('table/DelegateChoose/Delegate2')
	pkhsthObj.ToggleTrusteeship3 = PKHSTH:Find('table/DelegateChoose/Delegate3')
	pkhsthObj.ToggleTrusteeship5 = PKHSTH:Find('table/DelegateChoose1/Delegate5')
	pkhsthObj.ToggleTrusteeshipAll = PKHSTH:Find('table/DelegateCancel/FullRound')
	pkhsthObj.ToggleTrusteeshipOne = PKHSTH:Find('table/DelegateCancel/ThisRound')
	pkhsthObj.ToggleTrusteeshipThree = PKHSTH:Find('table/DelegateCancel/ThreeRound')
	message:AddClick(pkhsthObj.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pkhsthObj.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pkhsthObj.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pkhsthObj.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pkhsthObj.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pkhsthObj.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(pkhsthObj.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(pkhsthObj.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)

	pkhsthObj.ToggleIPcheck = PKHSTH:Find('table/PreventCheat/IPcheck')
	pkhsthObj.ToggleGPScheck = PKHSTH:Find('table/PreventCheat/GPScheck')
	message:AddClick(pkhsthObj.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(pkhsthObj.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
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
		pkhsthData.rounds = 1
		pkhsthData.size = 2
		pkhsthData.cardCount = 0
		pkhsthData.sinkKill = 1
		pkhsthData.settlement = 2
		pkhsthData.tong = 1
		pkhsthData.showCards = true
		pkhsthData.tongSplit = true
		pkhsthData.removeRank = true
		pkhsthData.lastBonus = 0
		pkhsthData.grouping = 1
		pkhsthData.teamVoice = true
		pkhsthData.choiceDouble = false
		pkhsthData.doubleScore = 100
		pkhsthData.multiple = 2
		pkhsthData.isSettlementScore = false
		pkhsthData.fewerValue = 100
		pkhsthData.addValue = 100
		pkhsthData.trusteeshipTime = 0
		pkhsthData.trusteeshipType = false
		pkhsthData.trusteeshipRound = 0
		pkhsthData.openIp = false
		pkhsthData.openGps = false
	elseif not optionData.addPlay and not optionData.addRule then
		pkhsthData.rounds = curSelectPlay.rounds
		pkhsthData.size = curSelectPlay.size
		if pkhsthData.size ~= 6 then
			if curSelectPlay.cardCount == 10 then
				pkhsthData.cardCount = 0
			elseif curSelectPlay.cardCount == 12 then
				pkhsthData.cardCount = 1
			elseif curSelectPlay.cardCount == 13 then
				pkhsthData.cardCount = 2
			elseif curSelectPlay.cardCount == 14 then
				pkhsthData.cardCount = 2
			end
		else
			if curSelectPlay.cardCount == 12 then
				pkhsthData.cardCount = 0
			elseif curSelectPlay.cardCount == 15 then
				pkhsthData.cardCount = 1
			elseif curSelectPlay.cardCount == 18 then
				pkhsthData.cardCount = 2
			elseif curSelectPlay.cardCount == 21 then
				pkhsthData.cardCount = 2
			end
		end
		pkhsthData.sinkKill = curSelectPlay.sinkKill
		pkhsthData.settlement = curSelectPlay.settlement
		pkhsthData.tong = curSelectPlay.tong
		pkhsthData.showCards = curSelectPlay.showCards
		pkhsthData.tongSplit = curSelectPlay.tongSplit
		pkhsthData.removeRank = curSelectPlay.removeRank
		pkhsthData.lastBonus = curSelectPlay.lastBonus
		pkhsthData.grouping = curSelectPlay.grouping
		pkhsthData.teamVoice = curSelectPlay.teamVoice
		
		if curSelectPlay.resultScore then
			pkhsthData.isSettlementScore = curSelectPlay.resultScore
			pkhsthData.fewerValue = curSelectPlay.resultLowerScore
			pkhsthData.addValue = curSelectPlay.resultAddScore
		else
			pkhsthData.fewerValue = 100
			pkhsthData.addValue = 100
		end
		if curSelectPlay.choiceDouble ~= nil then
			pkhsthData.choiceDouble = curSelectPlay.choiceDouble
			pkhsthData.doubleScore = curSelectPlay.doubleScore
			pkhsthData.multiple = curSelectPlay.multiple
		else
			pkhsthData.choiceDouble = false
			pkhsthData.doubleScore = 100
			pkhsthData.multiple = 2
		end
		pkhsthData.trusteeshipTime = (curSelectPlay.trusteeship/60)
		pkhsthData.trusteeshipType = curSelectPlay.trusteeshipDissolve
		pkhsthData.trusteeshipRound = curSelectPlay.trusteeshipRound
		pkhsthData.openIp = curSelectPlay.openIp
		pkhsthData.openGps = curSelectPlay.openGps
	end
	
	pkhsthObj.ToggleRound1:GetComponent('UIToggle'):Set(pkhsthData.rounds == 1)
	pkhsthObj.ToggleRound2:GetComponent('UIToggle'):Set(pkhsthData.rounds == 2)
	pkhsthObj.ToggleRound4:GetComponent('UIToggle'):Set(pkhsthData.rounds == 4)
	pkhsthObj.ToggleRound8:GetComponent('UIToggle'):Set(pkhsthData.rounds == 8)

	pkhsthObj.TogglePeopleNum2:GetComponent('UIToggle'):Set(pkhsthData.size == 2)
	pkhsthObj.TogglePeopleNum4:GetComponent('UIToggle'):Set(pkhsthData.size == 4)
	pkhsthObj.TogglePeopleNum6:GetComponent('UIToggle'):Set(pkhsthData.size == 6)

	pkhsthObj.ToggleCardCount0:Find('Label'):GetComponent('UILabel').text = pkhsthData.size ~= 6 and '10副' or '12副'
	pkhsthObj.ToggleCardCount1:Find('Label'):GetComponent('UILabel').text = pkhsthData.size ~= 6 and '12副' or '15副'
	pkhsthObj.ToggleCardCount2:Find('Label'):GetComponent('UILabel').text = pkhsthData.size ~= 6 and '13副' or '18副'
	pkhsthObj.ToggleCardCount3:Find('Label'):GetComponent('UILabel').text = pkhsthData.size ~= 6 and '14副' or '21副'
	pkhsthObj.ToggleCardCount0:GetComponent('UIToggle'):Set(pkhsthData.cardCount == 0)
	pkhsthObj.ToggleCardCount1:GetComponent('UIToggle'):Set(pkhsthData.cardCount == 1)
	pkhsthObj.ToggleCardCount2:GetComponent('UIToggle'):Set(pkhsthData.cardCount == 2)
	pkhsthObj.ToggleCardCount3:GetComponent('UIToggle'):Set(pkhsthData.cardCount == 3)

	pkhsthObj.ToggleSinkKill1:GetComponent('UIToggle'):Set(pkhsthData.sinkKill == 1)
	pkhsthObj.ToggleSinkKill2:GetComponent('UIToggle'):Set(pkhsthData.sinkKill == 2)

	pkhsthObj.ToggleSettlement1:GetComponent('UIToggle'):Set(pkhsthData.settlement == 1)
	pkhsthObj.ToggleSettlement2:GetComponent('UIToggle'):Set(pkhsthData.settlement == 2)

	pkhsthObj.ToggleTongHua1:GetComponent('UIToggle'):Set(pkhsthData.tong == 1)
	pkhsthObj.ToggleTongHua2:GetComponent('UIToggle'):Set(pkhsthData.tong == 2 or pkhsthData.tong == 3)
	pkhsthObj.ToggleTong9Add.gameObject:SetActive(pkhsthData.tong == 2 or pkhsthData.tong == 3)
	pkhsthObj.ToggleTong9Add:GetComponent('UIToggle'):Set(pkhsthData.tong == 3)

	pkhsthObj.ToggleShowCardNum:GetComponent('UIToggle'):Set(pkhsthData.showCards)
	pkhsthObj.ToggleTongSplit:GetComponent('UIToggle'):Set(pkhsthData.tongSplit)
	pkhsthObj.ToggleRemoveRank:GetComponent('UIToggle'):Set(pkhsthData.removeRank)
	pkhsthObj.ToggleFriendVoice:GetComponent('UIToggle'):Set(pkhsthData.teamVoice)

	if pkhsthData.lastBonus == 0 then
		pkhsthObj.RewardScoreValue:GetComponent('UILabel').text = '无奖励'
	else
		pkhsthObj.RewardScoreValue:GetComponent("UILabel").text = pkhsthData.lastBonus..'分'
	end
	
	pkhsthObj.ToggleGrouping1:GetComponent('UIToggle'):Set(pkhsthData.grouping == 1)
	pkhsthObj.ToggleGrouping2:GetComponent('UIToggle'):Set(pkhsthData.grouping == 2)

	
	pkhsthObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(pkhsthData.choiceDouble)
	pkhsthObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not pkhsthData.choiceDouble)
	pkhsthObj.DoubleScoreText.parent.gameObject:SetActive(pkhsthData.choiceDouble)
	if pkhsthData.doubleScore == 0 then
		pkhsthObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		pkhsthObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..pkhsthData.doubleScore..'分'
	end
	pkhsthObj.ToggleChoiceDouble.parent.gameObject:SetActive(pkhsthData.size == 2)
	pkhsthObj.ToggleMultiple2:GetComponent('UIToggle'):Set(pkhsthData.multiple == 2)
	pkhsthObj.ToggleMultiple3:GetComponent('UIToggle'):Set(pkhsthData.multiple == 3)
	pkhsthObj.ToggleMultiple4:GetComponent('UIToggle'):Set(pkhsthData.multiple == 4)
	pkhsthObj.ToggleMultiple2.parent.gameObject:SetActive(pkhsthData.choiceDouble and  pkhsthData.size == 2)

	pkhsthObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(pkhsthData.size==2)
	pkhsthObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(pkhsthData.isSettlementScore)
	pkhsthObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = pkhsthData.fewerValue
	pkhsthObj.ToggleAddScoreTxt:GetComponent('UILabel').text = pkhsthData.addValue

	pkhsthObj.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(pkhsthData.trusteeshipTime == 0)
	pkhsthObj.ToggleTrusteeship1:GetComponent('UIToggle'):Set(pkhsthData.trusteeshipTime == 1)
	pkhsthObj.ToggleTrusteeship2:GetComponent('UIToggle'):Set(pkhsthData.trusteeshipTime == 2)
	pkhsthObj.ToggleTrusteeship3:GetComponent('UIToggle'):Set(pkhsthData.trusteeshipTime == 3)
	pkhsthObj.ToggleTrusteeship5:GetComponent('UIToggle'):Set(pkhsthData.trusteeshipTime == 5)
	pkhsthObj.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(pkhsthData.trusteeshipType)
	pkhsthObj.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not pkhsthData.trusteeshipType and pkhsthData.trusteeshipRound == 0)
	pkhsthObj.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(pkhsthData.trusteeshipRound == 3)
	pkhsthObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(pkhsthData.trusteeshipTime ~= 0)

	pkhsthObj.ToggleIPcheck.parent.gameObject:SetActive(pkhsthData.size > 2 and CONST.IPcheckOn)
	pkhsthObj.ToggleIPcheck:GetComponent('UIToggle'):Set(pkhsthData.openIp)
	pkhsthObj.ToggleGPScheck:GetComponent('UIToggle'):Set(pkhsthData.openGps)

	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.PKHSTH,pkhsthData.rounds,nil,nil)
	PKHSTH:Find('table'):GetComponent('UIGrid'):Reposition()
	PKHSTH:GetComponent('UIScrollView'):ResetPosition()
end

function this.OnClickButtonOK(go)
	local body = {}
	body.paymentType = 3
	body.roomType = proxy_pb.PKHSTH
	body.rounds = pkhsthData.rounds
    body.size = pkhsthData.size
	local cardCount = 10
	if pkhsthData.cardCount == 0 then
		cardCount = pkhsthData.size ~= 6 and 10 or 12
	elseif pkhsthData.cardCount == 1 then
		cardCount = pkhsthData.size ~= 6 and 12 or 15
	elseif pkhsthData.cardCount == 2 then
		cardCount = pkhsthData.size ~= 6 and 13 or 18
	elseif pkhsthData.cardCount == 3 then
		cardCount = pkhsthData.size ~= 6 and 14 or 21
	end
	body.cardCount = cardCount
	body.sinkKill = pkhsthData.sinkKill
	body.settlement = pkhsthData.settlement
	body.tong = pkhsthData.tong
	body.showCards = pkhsthData.showCards
	body.tongSplit = pkhsthData.tongSplit
	body.removeRank = pkhsthData.removeRank
	body.lastBonus = pkhsthData.lastBonus
	body.grouping = pkhsthData.grouping
	body.teamVoice = pkhsthData.teamVoice
	if pkhsthData.size == 2 then
		body.resultScore = pkhsthData.isSettlementScore
		if pkhsthData.isSettlementScore then
			body.resultLowerScore=pkhsthData.fewerValue
			body.resultAddScore=pkhsthData.addValue
		end
		body.choiceDouble = pkhsthData.choiceDouble
        body.doubleScore = pkhsthData.doubleScore
        body.multiple = pkhsthData.multiple
		pkhsthData.openIp=false
		pkhsthData.openGps=false
	end
    body.trusteeship = pkhsthData.trusteeshipTime*60
    body.trusteeshipDissolve = pkhsthData.trusteeshipType
    body.trusteeshipRound = pkhsthData.trusteeshipRound
	body.openIp	 = pkhsthData.openIp
	body.openGps = pkhsthData.openGps
	
	for k, v in pairs(body) do
		print(k,v)
	end
	--判断是增加，修改还是删除
	if optionData.addPlay == true then 
		optionData.currentOption = "addPlay"
		local msg 			= Message.New()
		msg.type 			= proxy_pb.CREATE_CLUB_PLAY
		local bigbody 		= proxy_pb.PCreateClubPlay()
		bigbody.gameType 	= proxy_pb.HSTH
		bigbody.roomType    = proxy_pb.PKHSTH
		bigbody.name 		= '衡山同花'
		bigbody.clubId 		= panelClub.clubInfo.clubId
		bigbody.settings 	= json:encode(body)
		msg.body 			= bigbody:SerializeToString()
		SendProxyMessage(msg, this.OnCreateClubPlayResult)
	elseif optionData.addRule == true then
		optionData.currentOption = "addRule"
		local msg 			= Message.New()
		msg.type 			= proxy_pb.CREATE_PLAY_RULE
		local bigbody 		= proxy_pb.PCreatePlayRule()
		bigbody.gameType    = proxy_pb.HSTH
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

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
	pkhsthData.rounds = tonumber(go.name)
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.PKHSTH,pkhsthData.rounds,nil,nil)
end

function this.OnClickTogglePlayerNum(go)
	AudioManager.Instance:PlayAudio('btn')
	pkhsthData.size = tonumber(go.name)
	pkhsthObj.ToggleCardCount0:Find('Label'):GetComponent('UILabel').text = pkhsthData.size ~= 6 and '10副' or '12副'
	pkhsthObj.ToggleCardCount1:Find('Label'):GetComponent('UILabel').text = pkhsthData.size ~= 6 and '12副' or '15副'
	pkhsthObj.ToggleCardCount2:Find('Label'):GetComponent('UILabel').text = pkhsthData.size ~= 6 and '13副' or '18副'
	pkhsthObj.ToggleCardCount3:Find('Label'):GetComponent('UILabel').text = pkhsthData.size ~= 6 and '14副' or '21副'

	pkhsthObj.ToggleNoChoiceDouble.parent.gameObject:SetActive(pkhsthData.size==2)
    pkhsthObj.ToggleMultiple2.parent.gameObject:SetActive(pkhsthData.choiceDouble and pkhsthData.size == 2)
	pkhsthObj.DoubleScoreText.parent.gameObject:SetActive(pkhsthData.choiceDouble)
	pkhsthObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(pkhsthData.size==2)
	pkhsthObj.ToggleIPcheck.parent.gameObject:SetActive(pkhsthData.size > 2 and CONST.IPcheckOn)
    PKHSTH:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickToggleCardCount(go)
	AudioManager.Instance:PlayAudio('btn')
	pkhsthData.cardCount = tonumber(go.name)
end

function this.OnClickToggleSinkKill(go)
	AudioManager.Instance:PlayAudio('btn')
	pkhsthData.sinkKill = tonumber(go.name)
end
function this.OnClickToggleSettlement(go)
	AudioManager.Instance:PlayAudio('btn')
	pkhsthData.settlement = tonumber(go.name)
end
function this.OnClickToggleTongHua(go)
	AudioManager.Instance:PlayAudio('btn')
	pkhsthData.tong = tonumber(go.name)
	pkhsthObj.ToggleTong9Add.gameObject:SetActive(pkhsthData.tong == 2)
	if pkhsthData.tong == 2 and pkhsthObj.ToggleTong9Add:GetComponent('UIToggle').value then
		pkhsthData.tong = 3
	end
end

function this.OnClickToggleTong9Add(go)
	AudioManager.Instance:PlayAudio('btn')
	if pkhsthObj.ToggleTong9Add:GetComponent('UIToggle').value then
		pkhsthData.tong = 3
	else 
		pkhsthData.tong = 2
	end
end

function this.OnClickTogglePlay(go)
	AudioManager.Instance:PlayAudio('btn')
	if pkhsthObj.ToggleShowCardNum.gameObject == go then
		pkhsthData.showCards = pkhsthObj.ToggleShowCardNum:GetComponent('UIToggle').value
	elseif pkhsthObj.ToggleTongSplit.gameObject == go then
		pkhsthData.tongSplit = pkhsthObj.ToggleTongSplit:GetComponent('UIToggle').value
	elseif pkhsthObj.ToggleRemoveRank.gameObject == go then
		pkhsthData.removeRank = pkhsthObj.ToggleRemoveRank:GetComponent('UIToggle').value
	elseif pkhsthObj.ToggleFriendVoice.gameObject == go then
		pkhsthData.teamVoice = pkhsthObj.ToggleFriendVoice:GetComponent('UIToggle').value
	end
end

function this.OnClickChangeRewardScoreValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if pkhsthObj.AddBtnRewardScore.gameObject == go then
		pkhsthData.lastBonus = pkhsthData.lastBonus + 100
		if pkhsthData.lastBonus > 500 then
			pkhsthData.lastBonus = 0
		end
	elseif pkhsthObj.SubtractBtnRewardScore.gameObject == go then
		if pkhsthData.lastBonus == 0 then
            pkhsthData.lastBonus = 500
        else
            pkhsthData.lastBonus = pkhsthData.lastBonus - 100
			if pkhsthData.lastBonus < 100 then
				pkhsthData.lastBonus = 100
			end
        end
	end
	if pkhsthData.lastBonus == 0 then
        pkhsthObj.RewardScoreValue:GetComponent('UILabel').text = '无奖励'
    else
        pkhsthObj.RewardScoreValue:GetComponent('UILabel').text = pkhsthData.lastBonus..'分'
    end
end

function this.OnClickToggleGrouping(go)
	AudioManager.Instance:PlayAudio('btn')
	pkhsthData.grouping = tonumber(go.name)
end

function this.OnClickChoiceDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if pkhsthObj.ToggleChoiceDouble.gameObject == go then
        pkhsthData.choiceDouble = true
    elseif pkhsthObj.ToggleNoChoiceDouble.gameObject == go then
        pkhsthData.choiceDouble = false
    end
    pkhsthObj.DoubleScoreText.parent.gameObject:SetActive(pkhsthData.choiceDouble)
    pkhsthObj.ToggleMultiple2.parent.gameObject:SetActive(pkhsthData.choiceDouble)
    PKHSTH:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickChangeDoubleScore(go)
	AudioManager.Instance:PlayAudio('btn')
    if pkhsthObj.AddDoubleScoreButton.gameObject == go then
        if pkhsthData.doubleScore ~= 0 then
            pkhsthData.doubleScore = pkhsthData.doubleScore + 100
            if pkhsthData.doubleScore > 1000 then
                pkhsthData.doubleScore = 0
            end
        end
    else
        if pkhsthData.doubleScore == 0 then
            pkhsthData.doubleScore = 1000
        else
            pkhsthData.doubleScore = pkhsthData.doubleScore - 100
            if pkhsthData.doubleScore < 100 then
                pkhsthData.doubleScore = 100
            end
        end
    end
    if pkhsthData.doubleScore == 0 then
        pkhsthObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
    else
        pkhsthObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..pkhsthData.doubleScore..'分'
    end
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
    if pkhsthObj.ToggleMultiple2.gameObject == go then
        pkhsthData.multiple=2
    elseif pkhsthObj.ToggleMultiple3.gameObject == go then
        pkhsthData.multiple=3
    elseif pkhsthObj.ToggleMultiple4.gameObject == go then
        pkhsthData.multiple=4
    end
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    pkhsthData.isSettlementScore= pkhsthObj.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if pkhsthObj.ToggleFewerAddButton.gameObject == go then
		pkhsthData.fewerValue = pkhsthData.fewerValue + 100
		if pkhsthData.fewerValue > 1000 then
			pkhsthData.fewerValue = 1000
		end
    elseif pkhsthObj.ToggleFewerSubtractButton.gameObject == go then
		pkhsthData.fewerValue = pkhsthData.fewerValue - 100
		if pkhsthData.fewerValue < 100 then
			pkhsthData.fewerValue = 100
		end
	end
	pkhsthObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = pkhsthData.fewerValue
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if pkhsthObj.ToggleAddAddButton.gameObject == go then
		pkhsthData.addValue = pkhsthData.addValue + 100
		if pkhsthData.addValue > 1000 then
			pkhsthData.addValue = 1000
		end
    elseif pkhsthObj.ToggleAddSubtractButton.gameObject == go then
		pkhsthData.addValue = pkhsthData.addValue - 100
		if pkhsthData.addValue < 100 then
			pkhsthData.addValue = 100
		end
	end
	pkhsthObj.ToggleAddScoreTxt:GetComponent('UILabel').text = pkhsthData.addValue
end


function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if pkhsthObj.ToggleTrusteeshipNo.gameObject == go then
        pkhsthData.trusteeshipTime = 0
    elseif pkhsthObj.ToggleTrusteeship1.gameObject == go then
        pkhsthData.trusteeshipTime = 1
	elseif pkhsthObj.ToggleTrusteeship2.gameObject == go then
		pkhsthData.trusteeshipTime = 2
    elseif pkhsthObj.ToggleTrusteeship3.gameObject == go then
        pkhsthData.trusteeshipTime = 3
    elseif pkhsthObj.ToggleTrusteeship5.gameObject == go then
        pkhsthData.trusteeshipTime = 5
    end
	pkhsthObj.ToggleTrusteeshipOne.parent.gameObject:SetActive(pkhsthData.trusteeshipTime ~= 0)
	PKHSTH:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if pkhsthObj.ToggleTrusteeshipOne.gameObject == go then
        pkhsthData.trusteeshipType = true
		pkhsthData.trusteeshipRound = 0
    elseif pkhsthObj.ToggleTrusteeshipAll.gameObject == go then
        pkhsthData.trusteeshipType = false
		pkhsthData.trusteeshipRound = 0
	elseif pkhsthObj.ToggleTrusteeshipThree.gameObject == go then
		pkhsthData.trusteeshipType = false
		pkhsthData.trusteeshipRound = 3
    end
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if pkhsthObj.ToggleIPcheck.gameObject == go then
		pkhsthData.openIp = pkhsthObj.ToggleIPcheck:GetComponent('UIToggle').value 
	elseif pkhsthObj.ToggleGPScheck.gameObject == go then
		pkhsthData.openGps = pkhsthObj.ToggleGPScheck:GetComponent('UIToggle').value
	end
end
