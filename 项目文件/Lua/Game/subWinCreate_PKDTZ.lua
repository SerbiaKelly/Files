local this = {}

local PKDTZ
local payLabel

local scoreSelect=0
local size=4
local paymentType=0
local trusteeshipTime=0
local trusteeshipType=true
local trusteeshipRound = 0--3局解散

local cardCount=3
local lastBonus=0
local canisterBonus=1
local dark=false
local show=false
local san=false
local radom=false
local autoRun=false
local guan=false
local dissolveCalcSocre=false
local openIp=false
local openGps=false
local choiceDouble = false
local doubleScore = 100
local multiple = 2

local tableObj=nil
local ToggleRound600=nil
local ToggleRound1000=nil
local TogglePeopleNum2=nil
local TogglePeopleNum3=nil
local TogglePeopleNum4=nil
local ToggleMasterPay=nil
local ToggleWinnerPay=nil
local ToggleMultiple2
local ToggleMultiple3
local ToggleMultiple4

local ToggleChoiceDouble
local ToggleNoChoiceDouble
local DoubleScoreText
local AddDoubleScoreButton
local SubtractDoubleScoreButton

local ToggleTrusteeshipNo=nil
local ToggleTrusteeship1=nil
local ToggleTrusteeship2=nil
local ToggleTrusteeship3=nil
local ToggleTrusteeship5=nil
local ToggleTrusteeshipAll=nil
local ToggleTrusteeshipOne=nil
local ToggleTrusteeshipThree=nil

local ToggleIPcheck=nil		--防作弊，IP检测
local ToggleGPScheck=nil	--防作弊，GPS检测

local TogglePair3=nil
local TogglePair4=nil
local ToggleHaiPi4Xi=nil

local EndBonusPop=nil
local EndBonusPopPanel=nil
local EndBonusPopLable=nil
local endBonusItem1=nil
local endBonusItem2=nil
local endBonusItem3=nil
local endBonusItem4=nil
local endBonusItem5=nil
local TZBonusPop=nil
local TZBonusPopPanel=nil
local TZBonusPopLable=nil
local tzBonusItem1=nil
local tzBonusItem2=nil
local tzBonusItem3=nil

local ToggleShowLeftCard=nil
local ToggleCan3With2=nil
local ToggleAn8=nil
local ToggleRandom=nil
local ToggleAutoRun=nil
local ToggleBiGuan=nil
local ToggleSuddenQuit=nil

function this.Init(grid,message)
	print('Init_PKDTZ')
	PKDTZ = grid
    payLabel = message.transform:Find('diamond/pay_label')
    
	tableObj = PKDTZ:Find("table")
    ToggleRound600 = PKDTZ:Find("table/ToggleScore/ToggleRound600");
    ToggleRound1000 = PKDTZ:Find("table/ToggleScore/ToggleRound1000");
    TogglePeopleNum2 = PKDTZ:Find("table/TogglePeople/Toggle2P");
    TogglePeopleNum3 = PKDTZ:Find("table/TogglePeople/Toggle3P");
    TogglePeopleNum4 = PKDTZ:Find("table/TogglePeople/Toggle4P");
    ToggleMasterPay = PKDTZ:Find("table/TogglePayType/ToggleMasterPay");
	ToggleWinnerPay = PKDTZ:Find("table/TogglePayType/ToggleWinnerPay");
	
	ToggleTrusteeshipNo = PKDTZ:Find('table/DelegateChoose/NoDelegate')
	ToggleTrusteeship1 = PKDTZ:Find('table/DelegateChoose/Delegate1')
	ToggleTrusteeship2 = PKDTZ:Find('table/DelegateChoose/Delegate2')
	ToggleTrusteeship3 = PKDTZ:Find('table/DelegateChoose/Delegate3')
	ToggleTrusteeship5 = PKDTZ:Find('table/DelegateChoose/Delegate5')
	ToggleTrusteeshipAll = PKDTZ:Find('table/DelegateCancel/FullRound')
	ToggleTrusteeshipOne = PKDTZ:Find('table/DelegateCancel/ThisRound')
	ToggleTrusteeshipThree = PKDTZ:Find('table/DelegateCancel/ThreeRound')

    TogglePair3 = PKDTZ:Find("table/ToggleCardPair/TogglePair3");
	TogglePair4 = PKDTZ:Find("table/ToggleCardPair/TogglePair4");
	ToggleHaiPi4Xi = PKDTZ:Find("table/ToggleCardPair/ToggleHaiPi4Xi");

	EndBonusPop = PKDTZ:Find("table/ToggleEndBonus/EndBonusPop");
	EndBonusPopPanel = PKDTZ:Find("table/ToggleEndBonus/gridPanel");
	EndBonusPopLable = PKDTZ:Find("table/ToggleEndBonus/EndBonusPop/SelectLabel");
	endBonusItem1 = EndBonusPopPanel:Find("EndBonusGrid/endBonusItem1");
	endBonusItem2 = EndBonusPopPanel:Find("EndBonusGrid/endBonusItem2");
	endBonusItem3 = EndBonusPopPanel:Find("EndBonusGrid/endBonusItem3");
	endBonusItem4 = EndBonusPopPanel:Find("EndBonusGrid/endBonusItem4");
	endBonusItem5 = EndBonusPopPanel:Find("EndBonusGrid/endBonusItem5");
	
	TZBonusPop = PKDTZ:Find("table/ToggleEndBonus/TZBonusPop");
	TZBonusPopPanel = PKDTZ:Find("table/ToggleEndBonus/gridPanelTZ");
	TZBonusPopLable = PKDTZ:Find("table/ToggleEndBonus/TZBonusPop/SelectLabel");
	tzBonusItem1=TZBonusPopPanel:Find("TZBonussGrid/tzBonusItem1");
	tzBonusItem2=TZBonusPopPanel:Find("TZBonussGrid/tzBonusItem2");
	tzBonusItem3=TZBonusPopPanel:Find("TZBonussGrid/tzBonusItem3");

    ToggleShowLeftCard = PKDTZ:Find("table/TogglePlayType/ToggleShowLeftCard");
    ToggleCan3With2 = PKDTZ:Find("table/TogglePlayType/ToggleCan3With2");
    ToggleAn8 = PKDTZ:Find("table/TogglePlayType/ToggleAn8");
    ToggleRandom = PKDTZ:Find("table/TogglePlayType/ToggleRandom");
    ToggleAutoRun = PKDTZ:Find("table/TogglePlayType/ToggleAutoRun");
	ToggleBiGuan = PKDTZ:Find("table/TogglePlayType/ToggleBiGuan");
	ToggleSuddenQuit = PKDTZ:Find("table/TogglePlayType/ToggleSuddenQuit");
	
	ToggleIPcheck = PKDTZ:Find('table/PreventCheat/IPcheck')
	ToggleGPScheck = PKDTZ:Find('table/PreventCheat/GPScheck')

    ToggleMultiple2 = PKDTZ:Find('table/multiple/2')
	ToggleMultiple3 = PKDTZ:Find('table/multiple/3')
	ToggleMultiple4 = PKDTZ:Find('table/multiple/4')

	ToggleChoiceDouble          = PKDTZ:Find('table/choiceDouble/On')
	ToggleNoChoiceDouble        = PKDTZ:Find('table/choiceDouble/Off')
	DoubleScoreText             = PKDTZ:Find('table/choiceDouble/doubleScore/Value')
	AddDoubleScoreButton        = PKDTZ:Find('table/choiceDouble/doubleScore/AddButton')
	SubtractDoubleScoreButton   = PKDTZ:Find('table/choiceDouble/doubleScore/SubtractButton')

	for i = 0, tableObj.childCount-1 do
		local obj =  tableObj.transform:GetChild(i)
		message:AddClick(obj.transform:Find("Texture").gameObject, this.OnClickHidePopPanel);
	end
	
	message:AddClick(ToggleRound600.gameObject, this.OnClickToggleRoundScore);
	message:AddClick(ToggleRound1000.gameObject, this.OnClickToggleRoundScore);

	message:AddClick(TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum);
	message:AddClick(TogglePeopleNum3.gameObject, this.OnClickTogglePlayerNum);
	message:AddClick(TogglePeopleNum4.gameObject, this.OnClickTogglePlayerNum);

	message:AddClick(ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(ToggleWinnerPay.gameObject, this.OnClickTogglePayType)

	message:AddClick(ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)

	message:AddClick(TogglePair3.gameObject, this.OnClickToggleCardNum)
	message:AddClick(TogglePair4.gameObject, this.OnClickToggleCardNum)
	message:AddClick(ToggleHaiPi4Xi.gameObject, this.OnClickToggleCardNum)

	message:AddClick(EndBonusPop.gameObject, this.OnClickEndBonusPop)
	message:AddClick(TZBonusPop.gameObject, this.OnClickTZBonusPop)

	message:AddClick(endBonusItem1.gameObject, this.OnClickEndBonusItem)
	message:AddClick(endBonusItem2.gameObject, this.OnClickEndBonusItem)
	message:AddClick(endBonusItem3.gameObject, this.OnClickEndBonusItem)
	message:AddClick(endBonusItem4.gameObject, this.OnClickEndBonusItem)
	message:AddClick(endBonusItem5.gameObject, this.OnClickEndBonusItem)

	message:AddClick(tzBonusItem1.gameObject, this.OnClickTZBonusItem)
	message:AddClick(tzBonusItem2.gameObject, this.OnClickTZBonusItem)
	message:AddClick(tzBonusItem3.gameObject, this.OnClickTZBonusItem)

	message:AddClick(ToggleShowLeftCard.gameObject, this.OnClickToggleShowLeftCard)
	message:AddClick(ToggleCan3With2.gameObject, this.OnClickToggleCan3With2)
	message:AddClick(ToggleAn8.gameObject, this.OnClickToggleAn8)
	message:AddClick(ToggleRandom.gameObject, this.OnClickToggleRandom)
	message:AddClick(ToggleAutoRun.gameObject, this.OnClickToggleAutoRun)
	message:AddClick(ToggleBiGuan.gameObject, this.OnClickToggleBiGuan)
	message:AddClick(ToggleSuddenQuit.gameObject, this.OnClickToggleSuddenQuit)
	
	message:AddClick(ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(ToggleGPScheck.gameObject, this.OnClickPreventCheat)

	message:AddClick(ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)

	message:AddClick(ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(ToggleMultiple4.gameObject, this.OnClickMultiple)
end
function this.Refresh()
	print('Refresh_PKDTZ')
	scoreSelect = UnityEngine.PlayerPrefs.GetInt("NewPKDTZscoreSelect ",0);
    size = UnityEngine.PlayerPrefs.GetInt("NewPKDTZsize",4);
	paymentType= UnityEngine.PlayerPrefs.GetInt("NewPKDTZpaymentType",0);

	trusteeshipTime = UnityEngine.PlayerPrefs.GetInt('NewPKDTZtrusteeshipTime', 0)
	trusteeshipType = UnityEngine.PlayerPrefs.GetInt('NewPKDTZtrusteeshipType', 0) == 1
	trusteeshipRound = UnityEngine.PlayerPrefs.GetInt('NewPKDTZtrusteeshipRound', 0);

    cardCount= UnityEngine.PlayerPrefs.GetInt("NewPKDTZcardCount",3)
    lastBonus  = UnityEngine.PlayerPrefs.GetInt("NewPKDTZlastBonus",0)
	canisterBonus          = UnityEngine.PlayerPrefs.GetInt("NewPKDTZcanisterBonus",1);
    dark  = UnityEngine.PlayerPrefs.GetInt("NewPKDTZdark",1)==1
    show = UnityEngine.PlayerPrefs.GetInt("NewPKDTZshow",1)==1
    san   = UnityEngine.PlayerPrefs.GetInt("NewPKDTZsan",0)==1
    radom  = UnityEngine.PlayerPrefs.GetInt("NewPKDTZradom ",0)==1
    autoRun  = UnityEngine.PlayerPrefs.GetInt("NewPKDTZautoRun",1)==1
	guan   = UnityEngine.PlayerPrefs.GetInt("NewPKDTZguan",0)==1
	dissolveCalcSocre  = UnityEngine.PlayerPrefs.GetInt("NewPKDTZdissolveCalcSocre",0)==1
	openIp=UnityEngine.PlayerPrefs.GetInt('PKDTZcheckIP', 0)==1
	openGps=UnityEngine.PlayerPrefs.GetInt('PKDTZcheckGPS', 0)==1
	choiceDouble = UnityEngine.PlayerPrefs.GetInt('PKDTZchoiceDouble', 0)==1
	doubleScore = UnityEngine.PlayerPrefs.GetInt('PKDTZdoubleScore', 100)
	multiple = UnityEngine.PlayerPrefs.GetInt('PKDTZmultiple', 2)

	ToggleChoiceDouble.parent.gameObject:SetActive(size==2)
    ToggleMultiple2.parent.gameObject:SetActive(size==2 and choiceDouble)
    
	ToggleMultiple2:GetComponent('UIToggle'):Set(multiple == 2)
	ToggleMultiple3:GetComponent('UIToggle'):Set(multiple == 3)
	ToggleMultiple4:GetComponent('UIToggle'):Set(multiple == 4)

	ToggleChoiceDouble:GetComponent('UIToggle'):Set(choiceDouble)
	ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not choiceDouble)
	DoubleScoreText.parent.gameObject:SetActive(choiceDouble)
	if doubleScore == 0 then
		DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		DoubleScoreText:GetComponent('UILabel').text = '小于'..doubleScore..'分'
	end
	
	ToggleRound600:GetComponent('UIToggle'):Set(scoreSelect == 0)
	ToggleRound1000:GetComponent('UIToggle'):Set(scoreSelect == 1)

	TogglePeopleNum2:GetComponent('UIToggle'):Set(size == 2)
	TogglePeopleNum3:GetComponent('UIToggle'):Set(size == 3)
	TogglePeopleNum4:GetComponent('UIToggle'):Set(size == 4)
	
	ToggleMasterPay:GetComponent('UIToggle'):Set(paymentType == 0)
	ToggleWinnerPay:GetComponent('UIToggle'):Set(paymentType == 2)

	TogglePair3:GetComponent('UIToggle'):Set(cardCount == 3)
	TogglePair4:GetComponent('UIToggle'):Set(cardCount == 4)
	ToggleHaiPi4Xi:GetComponent('UIToggle'):Set(cardCount == 5)

	ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(trusteeshipTime == 0)
	ToggleTrusteeship1:GetComponent('UIToggle'):Set(trusteeshipTime == 1)
	ToggleTrusteeship2:GetComponent('UIToggle'):Set(trusteeshipTime == 2)
	ToggleTrusteeship3:GetComponent('UIToggle'):Set(trusteeshipTime == 3)
	ToggleTrusteeship5:GetComponent('UIToggle'):Set(trusteeshipTime == 5)
	ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(trusteeshipType)
	ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not trusteeshipType and trusteeshipRound == 0)
	ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(trusteeshipRound == 3);
	ToggleTrusteeshipOne.parent.gameObject:SetActive( trusteeshipTime ~= 0)

	ToggleShowLeftCard:GetComponent('UIToggle'):Set(show)
	ToggleCan3With2:GetComponent('UIToggle'):Set(san)
	if size == 4 and cardCount ~= 5 then
		ToggleAn8:GetComponent('UIToggle'):Set(dark)
	else
		UnityEngine.PlayerPrefs.SetInt('NewPKDTZdark',1)
		ToggleAn8:GetComponent('UIToggle'):Set(true)
	end
	ToggleRandom:GetComponent('UIToggle'):Set(radom)
	ToggleAutoRun:GetComponent('UIToggle'):Set(autoRun)
	ToggleBiGuan:GetComponent('UIToggle'):Set(guan)
	ToggleSuddenQuit:GetComponent('UIToggle'):Set(dissolveCalcSocre)

	ToggleIPcheck.parent.gameObject:SetActive(size > 2 and CONST.IPcheckOn)
	TZBonusPop.gameObject:SetActive(cardCount == 3)
	
	ToggleIPcheck:GetComponent('UIToggle'):Set(openIp)
	ToggleGPScheck:GetComponent('UIToggle'):Set(openGps)
	
	EndBonusPopLable:GetComponent("UILabel").text = this.GetEndBonusString(lastBonus)
	TZBonusPopLable:GetComponent("UILabel").text = this.GetTZBonusString(canisterBonus)
	local str
	if cardCount == 3 then
		if size == 2 then
			str = '暗66张'
		elseif size == 3 then
			str = '暗9张'
		elseif size == 4 then
			str = '暗8张'
		end
	elseif cardCount == 4 then
		if size == 2 then
			str = '暗96张'
		elseif size == 3 then
			str = '暗52张'
		elseif size == 4 then
			str = '暗8张'
		end
	elseif cardCount == 5 then
		if size == 2 then
			str = '暗88张'
		elseif size == 3 then
			str = '暗66张'
		elseif size == 4 then
			str = '无暗牌'
		end
	end
	ToggleAn8:Find('Label'):GetComponent('UILabel').text = str
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.PKDTZ,nil,nil,scoreSelect)
	ToggleRandom.gameObject:SetActive(size~=4)
	ToggleAutoRun.gameObject:SetActive(size==4)
	tableObj:GetComponent('UIGrid'):Reposition()
end

function this.GetEndBonusString(lastBonus)
    if lastBonus == 0 then
        return "无奖励"
    elseif lastBonus == 1 then
        return "100分"
    elseif lastBonus == 2 then
        return "200分"
    elseif lastBonus == 3 then
        return "300分"
    elseif lastBonus == 4 then
        return "500分"
    else
        return "非法值"
    end
end

function this.GetTZBonusString(canisterBonus)
    if canisterBonus == 0 then
        return "无奖励";
    elseif canisterBonus == 1 then
        return "K筒子奖励100";
    elseif canisterBonus == 2 then
        return "J-K筒子奖励100";
    elseif canisterBonus == 3 then
        return "5-K筒子奖励100"
    else
        return "非法值"
    end
end
--获取当前设置
function this.GetConfig()
    local moneyLess = false
    
    local body = {}
    body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.PKDTZ)
	body.scoreSelect = scoreSelect
    body.size = size
    body.paymentType = paymentType
    body.trusteeship = trusteeshipTime*60;
    body.trusteeshipDissolve = trusteeshipType;
    body.trusteeshipRound = trusteeshipRound;
    print(cardCount)
    body.cardCount      = cardCount;
    body.lastBonus      = lastBonus;
    if cardCount ~= 3 then
        body.canisterBonus  = 0;
    else
        body.canisterBonus  = canisterBonus;
    end
    if size == 4 and cardCount==5 then
        body.dark           = false
    else
        body.dark           = dark;
    end
    
    body.show           = show;
    body.san            = san;
    body.radom          = size ~= 4 and radom or false;
    body.autoRun        = size == 4 and autoRun or false;
    body.guan           = guan;
    body.dissolveCalcSocre  = dissolveCalcSocre
	if size == 2 then
		openIp=false
		openGps=false
		
		body.choiceDouble = choiceDouble
		body.doubleScore = doubleScore
		body.multiple = multiple
	end
	body.openIp	 = openIp
	body.openGps = openGps
    return moneyLess,body;
end

function this.OnClickTogglePlayerNum(go)
    AudioManager.Instance:PlayAudio('btn')
	local str = ''
	if TogglePeopleNum2.gameObject == go then
		size = 2
		if cardCount == 5 then
			str ='暗88张'
		elseif cardCount == 4 then
			str ='暗96张'
		elseif cardCount == 3 then
			str ='暗66张'
		end
	elseif TogglePeopleNum3.gameObject == go then
		size = 3
		if cardCount == 5 then
			str ='暗44张'
		elseif cardCount == 4 then
			str ='暗52张'
		elseif cardCount == 3 then
			str ='暗9张'
		end
	elseif TogglePeopleNum4.gameObject == go then
		size = 4
		if cardCount == 5 then
			str ='无暗牌'
		elseif cardCount == 4 then
			str ='暗8张'
		elseif cardCount == 3 then
			str ='暗8张'
		end
	end
	ToggleRandom.gameObject:SetActive(size~=4)
	ToggleAutoRun.gameObject:SetActive(size==4)
	
	ToggleChoiceDouble.parent.gameObject:SetActive(size == 2)
	ToggleMultiple2.parent.gameObject:SetActive(size == 2 and choiceDouble)
	if size ~= 4 or cardCount == 5 then
		dark = true
	end
	ToggleIPcheck.parent.gameObject:SetActive(size > 2 and CONST.IPcheckOn)
	ToggleAn8:GetComponent('UIToggle'):Set(dark)
	UnityEngine.PlayerPrefs.SetInt('NewPKDTZdark', dark and 1 or 0)
	ToggleAn8:Find('Label'):GetComponent('UILabel').text = str
	UnityEngine.PlayerPrefs.SetInt('NewPKDTZsize', size)
	this.OnClickHidePopPanel()
	tableObj:GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if ToggleMasterPay.gameObject == go then
        paymentType=0
    elseif ToggleWinnerPay.gameObject == go then
        paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewPKDTZpaymentType', paymentType)
    this.OnClickHidePopPanel()
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    if ToggleTrusteeshipNo.gameObject == go then
        trusteeshipTime = 0
    elseif ToggleTrusteeship1.gameObject == go then
        trusteeshipTime = 1
	elseif ToggleTrusteeship2.gameObject == go then
		trusteeshipTime = 2
	elseif ToggleTrusteeship3.gameObject == go then
        trusteeshipTime = 3
    elseif ToggleTrusteeship5.gameObject == go then
        trusteeshipTime = 5
    end
    UnityEngine.PlayerPrefs.SetInt('NewPKDTZtrusteeshipTime', trusteeshipTime)
    ToggleTrusteeshipOne.parent.gameObject:SetActive(trusteeshipTime ~= 0)
	tableObj:GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if ToggleTrusteeshipOne.gameObject == go then
        trusteeshipType = true
		trusteeshipRound = 0;
    elseif ToggleTrusteeshipAll.gameObject == go then
        trusteeshipType = false
		trusteeshipRound = 0;
	elseif ToggleTrusteeshipThree.gameObject == go then
		trusteeshipType = false;
		trusteeshipRound = 3;
    end
    UnityEngine.PlayerPrefs.SetInt('NewPKDTZtrusteeshipType',trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewPKDTZtrusteeshipRound',trusteeshipRound);
end

function this.OnClickToggleRoundScore(go)
	if ToggleRound600.gameObject == go then
		scoreSelect = 0
		UnityEngine.PlayerPrefs.SetInt("NewPKDTZscoreSelect ",0);
	elseif ToggleRound1000.gameObject == go then
		scoreSelect = 1
		UnityEngine.PlayerPrefs.SetInt("NewPKDTZscoreSelect ",1);
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.PKDTZ,nil,nil,scoreSelect)
	this.OnClickHidePopPanel()
end

function this.OnClickHidePopPanel(go)
	if EndBonusPopPanel.gameObject.activeSelf then
		EndBonusPopPanel.gameObject:SetActive(false)
	end
	if TZBonusPopPanel.gameObject.activeSelf then
		TZBonusPopPanel.gameObject:SetActive(false)
	end
end

function this.OnClickEndBonusPop(go)
	if EndBonusPopPanel.gameObject.activeSelf then
		EndBonusPopPanel.gameObject:SetActive(false)
	else
		EndBonusPopPanel.gameObject:SetActive(true)
	end
end

function this.OnClickTZBonusPop(go)
	if TZBonusPopPanel.gameObject.activeSelf then
		TZBonusPopPanel.gameObject:SetActive(false)
	else
		TZBonusPopPanel.gameObject:SetActive(true)
	end
end

function this.OnClickToggleCardNum(go)
	local str
	if TogglePair3.gameObject == go then
		cardCount = 3
		if size == 2 then
			str = '暗66张'
		elseif size == 3 then
			str = '暗9张'
		elseif size == 4 then
			str = '暗8张'
		end
	elseif TogglePair4.gameObject == go then
		cardCount = 4
		if size == 2 then
			str = '暗96张'
		elseif size == 3 then
			str = '暗52张'
		elseif size == 4 then
			str = '暗8张'
		end
	elseif ToggleHaiPi4Xi.gameObject == go then
		cardCount = 5
		if size == 2 then
			str = '暗88张'
		elseif size == 3 then
			str = '暗44张'
		elseif size == 4 then
			str = '无暗牌'
		end
	end
	if size ~= 4 or cardCount == 5 then
		dark = true
	end
	UnityEngine.PlayerPrefs.SetInt('NewPKDTZdark', dark and 1 or 0)
	ToggleAn8:GetComponent('UIToggle'):Set(dark)
	ToggleAn8:Find('Label'):GetComponent('UILabel').text = str
	UnityEngine.PlayerPrefs.SetInt("NewPKDTZcardCount",cardCount)
	TZBonusPop.gameObject:SetActive(cardCount == 3)
	EndBonusPopLable:GetComponent("UILabel").text = this.GetEndBonusString(lastBonus)
	TZBonusPopLable:GetComponent("UILabel").text = this.GetTZBonusString(canisterBonus)
	this.OnClickHidePopPanel()
end

function this.OnClickEndBonusItem(go)
	if endBonusItem1.gameObject == go then
		lastBonus = 0
	elseif endBonusItem2.gameObject == go then
		lastBonus = 1
	elseif endBonusItem3.gameObject == go then
		lastBonus = 2
	elseif endBonusItem4.gameObject == go then
		lastBonus = 3
	elseif endBonusItem5.gameObject == go then
		lastBonus = 4
	end
	UnityEngine.PlayerPrefs.SetInt("NewPKDTZlastBonus",lastBonus);
	EndBonusPopPanel.gameObject:SetActive(false)
	EndBonusPopLable:GetComponent("UILabel").text = this.GetEndBonusString(lastBonus)
end

function this.OnClickTZBonusItem(go)
	if tzBonusItem1.gameObject == go then
		canisterBonus = 1
	elseif tzBonusItem2.gameObject == go then
		canisterBonus = 2
	elseif tzBonusItem3.gameObject == go then
		canisterBonus = 3
	end
	UnityEngine.PlayerPrefs.SetInt("NewPKDTZcanisterBonus",canisterBonus);
	TZBonusPopPanel.gameObject:SetActive(false)
	TZBonusPopLable:GetComponent("UILabel").text = this.GetTZBonusString(canisterBonus)
end

function this.OnClickToggleShowLeftCard(go)
	if go:GetComponent('UIToggle').value == true then
		show = true
	else
		show = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewPKDTZshow', show and 1 or 0)
	this.OnClickHidePopPanel()
end
function this.OnClickToggleCan3With2(go)
	if go:GetComponent('UIToggle').value == true then
		san = true
	else
		san = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewPKDTZsan', san and 1 or 0)
	this.OnClickHidePopPanel()
end
function this.OnClickToggleAn8(go)
	if go:GetComponent('UIToggle').value == true then
		dark = true
	else
		dark = false
	end
	if size ~= 4 or cardCount == 5 then
		dark = true
	end
	ToggleAn8:GetComponent('UIToggle'):Set(dark)
	UnityEngine.PlayerPrefs.SetInt('NewPKDTZdark', dark and 1 or 0)
	this.OnClickHidePopPanel()
end
function this.OnClickToggleRandom(go)
	if go:GetComponent('UIToggle').value == true then
		radom = true
	else
		radom = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewPKDTZradom', radom and 1 or 0)
	this.OnClickHidePopPanel()
end
function this.OnClickToggleAutoRun(go)
	if go:GetComponent('UIToggle').value == true then
		autoRun = true
	else
		autoRun = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewPKDTZautoRun', autoRun and 1 or 0)
	this.OnClickHidePopPanel()
end
function this.OnClickToggleBiGuan(go)
	if go:GetComponent('UIToggle').value == true then
		guan = true
	else
		guan = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewPKDTZguan', guan and 1 or 0)
	this.OnClickHidePopPanel()
end
function this.OnClickToggleSuddenQuit(go)
	if go:GetComponent('UIToggle').value == true then
		dissolveCalcSocre = true
	else
		dissolveCalcSocre = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewPKDTZdissolveCalcSocre', dissolveCalcSocre and 1 or 0)
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if ToggleIPcheck.gameObject == go then
		openIp = ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('PKDTZcheckIP', openIp and 1 or 0)
	elseif ToggleGPScheck.gameObject == go then
		openGps = ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('PKDTZcheckGPS', openGps and 1 or 0)
	end
end

function this.OnClickChoiceDouble(go)
    AudioManager.Instance:PlayAudio('btn')
	if ToggleChoiceDouble.gameObject == go then
		choiceDouble = true
	else
		choiceDouble = false
	end
	UnityEngine.PlayerPrefs.SetInt('PKDTZchoiceDouble', choiceDouble and 1 or 0)
	DoubleScoreText.parent.gameObject:SetActive(choiceDouble)
    ToggleMultiple2.parent.gameObject:SetActive(choiceDouble)
    tableObj:GetComponent('UIGrid'):Reposition()
	if choiceDouble then
		ToggleMultiple2:GetComponent('UIToggle'):Set(multiple == 2)
		ToggleMultiple3:GetComponent('UIToggle'):Set(multiple == 3)
		ToggleMultiple4:GetComponent('UIToggle'):Set(multiple == 4)
	end
end

function this.OnClickChangeDoubleScore(go)
    AudioManager.Instance:PlayAudio('btn')
    local label_= DoubleScoreText:GetComponent('UILabel').text
    if label_=='不限分' then
        doubleScore=0
    else
        doubleScore=tonumber(string.sub(label_,7,-4))    
    end
	if AddDoubleScoreButton.gameObject == go then
		if doubleScore ~= 0 then
			doubleScore = doubleScore + 100
			if doubleScore > 1000 then
				doubleScore = 0
			end
		end
	else
		if doubleScore == 0 then
			doubleScore = 1000
		else
			doubleScore = doubleScore - 100
			if doubleScore < 100 then
				doubleScore = 100
			end
		end
	end

	if doubleScore == 0 then
		DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		DoubleScoreText:GetComponent('UILabel').text = '小于'..doubleScore..'分'
	end
	UnityEngine.PlayerPrefs.SetInt('PKDTZdoubleScore', doubleScore)
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
	multiple = tonumber(go.name)
	print('倍数：'..multiple)
	UnityEngine.PlayerPrefs.SetInt('PKDTZmultiple', multiple)
end

return this