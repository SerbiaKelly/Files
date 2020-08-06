local json = require 'json'

panelCreateDTZSet = {}
local this = panelCreateDTZSet

local gameObject;
local message;

local wanFaTitle;
local payLabel
local RuleButton;

local ButtonClose;
local ButtonOK;

local ToggleRound600;
local ToggleRound1000;
local Toggle2P;
local Toggle3P;
local Toggle4P;
local ToggleMasterPay;
local ToggleWinnerPay;
local TogglePair3;
local TogglePair4;
local ToggleHappy4Xi;

local ToggleMultiple2
local ToggleMultiple3
local ToggleMultiple4

local ToggleChoiceDouble
local ToggleNoChoiceDouble
local DoubleScoreText
local AddDoubleScoreButton
local SubtractDoubleScoreButton

local ToggleShowLeftCard;
local ToggleCan3With2;
local ToggleAn8;
local ToggleRandom;
local ToggleAutoRun;
local ToggleBiGuan;
local gridEndBonusPanel;
local gridTZBonusPanel;
local EndBonusButton;
local TZBonusButton;
local ToggleSuddenQuit;

local EndBBonusLabel;
local TZBonusLabel;

local m_lastBonus;
local m_canisterBonus;

local ToggleTrusteeshipNo
local ToggleTrusteeship1
local ToggleTrusteeship2
local ToggleTrusteeship3
local ToggleTrusteeship5

local ToggleTrusteeshipAll
local ToggleTrusteeshipOne
local ToggleTrusteeshipThree

local tableObj
local ToggleIPcheck=nil		--防作弊，IP检测
local ToggleGPScheck=nil	--防作弊，GPS检测

function this.Awake(obj)
    gameObject = obj;
    message    = gameObject:GetComponent('LuaBehaviour');

    this.GetUIObjects();
    this.BindEvents();
end

function this.GetUIObjects()
    ButtonClose        = gameObject.transform:Find('ButtonClose');
    ButtonOK = gameObject.transform:Find('ButtonOK/Background');

    wanFaTitle = gameObject.transform:Find('title/Label');
    payLabel = gameObject.transform:Find('pay_label')
    RuleButton = gameObject.transform:Find('RuleButton')

	tableObj 		= gameObject.transform:Find("DTZPanel/table");
    ToggleRound600    = gameObject.transform:Find("DTZPanel/table/ToggleScore/ToggleRound600");
    ToggleRound1000    = gameObject.transform:Find("DTZPanel/table/ToggleScore/ToggleRound1000");
    Toggle2P            = gameObject.transform:Find("DTZPanel/table/TogglePeople/Toggle2P");
    Toggle3P            = gameObject.transform:Find("DTZPanel/table/TogglePeople/Toggle3P");
    Toggle4P            = gameObject.transform:Find("DTZPanel/table/TogglePeople/Toggle4P");
    ToggleMasterPay    = gameObject.transform:Find("DTZPanel/table/TogglePayType/ToggleMasterPay");
    ToggleWinnerPay    = gameObject.transform:Find("DTZPanel/table/TogglePayType/ToggleWinnerPay");
    TogglePair3        = gameObject.transform:Find("DTZPanel/table/ToggleCardPair/TogglePair3");
    TogglePair4        = gameObject.transform:Find("DTZPanel/table/ToggleCardPair/TogglePair4");
    ToggleHappy4Xi        = gameObject.transform:Find("DTZPanel/table/ToggleCardPair/ToggleHappy4Xi");

    ToggleShowLeftCard = gameObject.transform:Find("DTZPanel/table/TogglePlayType/ToggleShowLeftCard");
    ToggleCan3With2    = gameObject.transform:Find("DTZPanel/table/TogglePlayType/ToggleCan3With2");
    ToggleAn8        = gameObject.transform:Find("DTZPanel/table/TogglePlayType/ToggleAn8");
    ToggleRandom        = gameObject.transform:Find("DTZPanel/table/TogglePlayType/ToggleRandom");
    ToggleAutoRun        = gameObject.transform:Find("DTZPanel/table/TogglePlayType/ToggleAutoRun");
    ToggleBiGuan        = gameObject.transform:Find("DTZPanel/table/TogglePlayType/ToggleBiGuan");
    ToggleSuddenQuit        = gameObject.transform:Find("DTZPanel/table/TogglePlayType/ToggleSuddenQuit");
    gridEndBonusPanel = gameObject.transform:Find("DTZPanel/table/ToggleEndBonus/gridPanel");
    gridTZBonusPanel    = gameObject.transform:Find("DTZPanel/table/ToggleEndBonus/gridPanelTZ");
    EndBonusButton    = gameObject.transform:Find("DTZPanel/table/ToggleEndBonus/EndBonusPop");
    TZBonusButton    = gameObject.transform:Find("DTZPanel/table/ToggleEndBonus/TZBonusPop");
    EndBBonusLabel    = gameObject.transform:Find("DTZPanel/table/ToggleEndBonus/EndBonusPop/SelectLabel");
    TZBonusLabel        = gameObject.transform:Find("DTZPanel/table/ToggleEndBonus/TZBonusPop/SelectLabel");

    ToggleTrusteeshipNo = gameObject.transform:Find('DTZPanel/table/ToggleTrusteeship/ToggleNo')
	ToggleTrusteeship1 = gameObject.transform:Find('DTZPanel/table/ToggleTrusteeship/Toggle1Minute')
	ToggleTrusteeship2 = gameObject.transform:Find('DTZPanel/table/ToggleTrusteeship/Toggle2Minute')
	ToggleTrusteeship3 = gameObject.transform:Find('DTZPanel/table/ToggleTrusteeship/Toggle3Minute')
	ToggleTrusteeship5 = gameObject.transform:Find('DTZPanel/table/ToggleTrusteeship/Toggle5Minute')
	ToggleTrusteeshipAll = gameObject.transform:Find('DTZPanel/table/ToggleTrusteeshipType/ToggleAll')
	ToggleTrusteeshipOne = gameObject.transform:Find('DTZPanel/table/ToggleTrusteeshipType/ToggleOne')
    ToggleTrusteeshipThree = gameObject.transform:Find('DTZPanel/table/ToggleTrusteeshipType/ToggleThree')
    
    ToggleMultiple2 = gameObject.transform:Find('DTZPanel/table/multiple/2')
	ToggleMultiple3 = gameObject.transform:Find('DTZPanel/table/multiple/3')
	ToggleMultiple4 = gameObject.transform:Find('DTZPanel/table/multiple/4')

	ToggleChoiceDouble          = gameObject.transform:Find('DTZPanel/table/choiceDouble/On')
	ToggleNoChoiceDouble        = gameObject.transform:Find('DTZPanel/table/choiceDouble/Off')
	DoubleScoreText             = gameObject.transform:Find('DTZPanel/table/choiceDouble/doubleScore/Value')
	AddDoubleScoreButton        = gameObject.transform:Find('DTZPanel/table/choiceDouble/doubleScore/AddButton')
	SubtractDoubleScoreButton   = gameObject.transform:Find('DTZPanel/table/choiceDouble/doubleScore/SubtractButton')
	
	ToggleIPcheck = gameObject.transform:Find('DTZPanel/table/PreventCheat/IPcheck')
	ToggleGPScheck = gameObject.transform:Find('DTZPanel/table/PreventCheat/GPScheck')
end

function this.BindEvents()

    message:AddClick(EndBonusButton.gameObject, this.OnEndBonusButtonClick);
    message:AddClick(TZBonusButton.gameObject, this.OnTZBonusButtonClick);

    local endBonusGrid = gridEndBonusPanel:Find("EndBonusGrid");
    for i = 1, endBonusGrid.childCount do
        message:AddClick(endBonusGrid:GetChild(i - 1).gameObject, this.OnEndBonusItemClick);
    end

    local tzBonusGrid = gridTZBonusPanel:Find("TZBonussGrid");
    for i = 1, tzBonusGrid.childCount do
        message:AddClick(tzBonusGrid:GetChild(i - 1).gameObject, this.OnTZBonusItemClick);
    end
    message:AddClick(Toggle2P.gameObject, this.OnPeopleSizeClick);
    message:AddClick(Toggle3P.gameObject, this.OnPeopleSizeClick);
    message:AddClick(Toggle4P.gameObject, this.OnPeopleSizeClick);

    message:AddClick(ToggleRound600.gameObject, this.OnToggleRoundClick);
    message:AddClick(ToggleRound1000.gameObject, this.OnToggleRoundClick);

    message:AddClick(TogglePair3.gameObject, this.OnCardPairToggleClick);
    message:AddClick(TogglePair4.gameObject, this.OnCardPairToggleClick);
    message:AddClick(ToggleHappy4Xi.gameObject,this.OnCardPairToggleClick);

    message:AddClick(ButtonOK.gameObject, this.OnClickButtonOK);
    message:AddClick(ButtonClose.gameObject, this.OnClickClose)
    message:AddClick(RuleButton.gameObject, this.OnShowRuleInfo)

    message:AddClick(ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
    message:AddClick(ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)
    
	message:AddClick(ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)

	message:AddClick(ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(ToggleMultiple4.gameObject, this.OnClickMultiple)
end

local optionData = {};
local curSelectPlay = {}
function this.WhoShow(data)
    if data.optionData ~= nil then
        optionData            = data.optionData;
        optionData.playId    = data.playId;
        optionData.ruleId    = data.ruleId;
    end

    print('data.addPlay:' .. tostring(data.optionData.addPlay) .. "data.addRule:" .. tostring(data.optionData.addRule))
  
    this.OnEnableRefresh(data)
end


function this.GetPreSetting()
    local settings = {}
    settings.scoreSelect            = 0
    settings.size                   = 4
    settings.paymentType            = 0
    settings.cardCount              = 4
    settings.lastBonus              = 0
    settings.canisterBonus          = 1
    settings.dark                   = true
    settings.show                   = true
    settings.san                    = false
    settings.radom                  = false
    settings.autoRun                = false
    settings.guan                   = false
    settings.dissolveCalcSocre      = false
    settings.openIp      			= false
    settings.openGps      			= false

    settings.choiceDouble           = false
    settings.doubleScore      		= 100
    settings.multiple      			= 2

    settings.trusteeship = 0
    settings.trusteeshipDissolve = true
    settings.trusteeshipRound = 0

    return settings;
end

function this.OnEnableRefresh(data)
    curSelectPlay = {}
    local titleStr = ''

    if optionData.addRule or optionData.addPlay then
        curSelectPlay = this.GetPreSetting()
        titleStr = '当前玩法：'..'打筒子'
    elseif not optionData.addPlay and not optionData.addRule then
        curSelectPlay = json:decode(data.settings)
        titleStr = '当前规则：'..GetDTZRuleString(curSelectPlay, false, false);

        if curSelectPlay.trusteeship == nil then
            curSelectPlay.trusteeship = 0
        end
        curSelectPlay.trusteeship = curSelectPlay.trusteeship / 60

        if curSelectPlay.trusteeshipDissolve == nil then
            curSelectPlay.trusteeshipDissolve = true
        end
        if curSelectPlay.trusteeshipRound == nil then
            curSelectPlay.trusteeshipRound = 0;
        end

    end

    wanFaTitle:GetComponent('UILabel').text = titleStr;
    this.SetPreSetting(curSelectPlay)
end

function this.SetPreSetting(settings)

    if not settings then
        return;
    end
    if settings then
        
    end
    if settings.choiceDouble == nil then
        settings.choiceDouble= false
        settings.doubleScore=100
        settings.multiple=2
    end
	ToggleChoiceDouble.parent.gameObject:SetActive(settings.size==2)
    ToggleMultiple2.parent.gameObject:SetActive(settings.size==2 and settings.choiceDouble)
    
	ToggleMultiple2:GetComponent('UIToggle'):Set(settings.multiple == 2)
	ToggleMultiple3:GetComponent('UIToggle'):Set(settings.multiple == 3)
	ToggleMultiple4:GetComponent('UIToggle'):Set(settings.multiple == 4)

	ToggleChoiceDouble:GetComponent('UIToggle'):Set(settings.choiceDouble)
	ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not settings.choiceDouble)
	DoubleScoreText.parent.gameObject:SetActive(settings.choiceDouble)
	if settings.doubleScore == 0 then
		DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		DoubleScoreText:GetComponent('UILabel').text = '小于'..settings.doubleScore..'分'
	end

    ToggleRound600:GetComponent("UIToggle"):Set(settings.scoreSelect == 0);
    ToggleRound1000:GetComponent("UIToggle"):Set(settings.scoreSelect == 1);

    Toggle2P:GetComponent("UIToggle"):Set(settings.size == 2);
    Toggle3P:GetComponent("UIToggle"):Set(settings.size == 3);
    Toggle4P:GetComponent("UIToggle"):Set(settings.size == 4);

    ToggleMasterPay:GetComponent("UIToggle"):Set(settings.paymentType == 0);
    ToggleWinnerPay:GetComponent("UIToggle"):Set(settings.paymentType ~= 0);

    TogglePair3:GetComponent("UIToggle"):Set(settings.cardCount == 3);
    TogglePair4:GetComponent("UIToggle"):Set(settings.cardCount == 4);
    ToggleHappy4Xi:GetComponent("UIToggle"):Set(settings.cardCount == 5);

    EndBBonusLabel:GetComponent("UILabel").text = this.GetEndBonusString(settings.lastBonus);
    TZBonusLabel:GetComponent("UILabel").text = this.GetTZBonusString(settings.canisterBonus);
    m_lastBonus = settings.lastBonus;
    m_canisterBonus = settings.canisterBonus;

    ToggleAn8:GetComponent("UIToggle"):Set(settings.dark)

    ToggleShowLeftCard:GetComponent("UIToggle"):Set(settings.show);
    ToggleCan3With2:GetComponent("UIToggle"):Set(settings.san);
    ToggleRandom:GetComponent("UIToggle"):Set(settings.radom);
    ToggleBiGuan:GetComponent("UIToggle"):Set(settings.guan);
    ToggleSuddenQuit:GetComponent("UIToggle"):Set(settings.dissolveCalcSocre);

    ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(settings.trusteeship == 0)
	ToggleTrusteeship1:GetComponent('UIToggle'):Set(settings.trusteeship == 1)
	ToggleTrusteeship2:GetComponent('UIToggle'):Set(settings.trusteeship == 2)
	ToggleTrusteeship3:GetComponent('UIToggle'):Set(settings.trusteeship == 3)
	ToggleTrusteeship5:GetComponent('UIToggle'):Set(settings.trusteeship == 5)

	ToggleTrusteeshipOne.parent.gameObject:SetActive(true)
	ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(settings.trusteeshipDissolve == false and settings.trusteeshipRound == 0)
	ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(settings.trusteeshipDissolve == true)
    ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(settings.trusteeshipRound == 3);
    ToggleTrusteeshipOne.parent.gameObject:SetActive(settings.trusteeship ~= 0)
	
	ToggleIPcheck:GetComponent('UIToggle'):Set(settings.openIp)
	ToggleGPScheck:GetComponent('UIToggle'):Set(settings.openGps)
	ToggleIPcheck.parent.gameObject:SetActive(settings.size > 2 and CONST.IPcheckOn)

	TZBonusButton.gameObject:SetActive(settings.cardCount == 3)
	TZBonusLabel.gameObject:SetActive(settings.cardCount == 3)

    --4人玩法，暗牌可以取消选择，2人和3人必选
    if settings.size == 3 or settings.size == 2 then
        ToggleAn8:GetComponent("BoxCollider").enabled = false;

        ToggleAn8:GetComponent("UIToggle"):Set(true);
        ToggleAutoRun.gameObject:SetActive(false);
        ToggleAutoRun:GetComponent("UIToggle"):Set(false);
    else
        if settings.cardCount == 5 then
            ToggleAn8:GetComponent("BoxCollider").enabled = false;
            ToggleAn8:GetComponent("UIToggle"):Set(true);
        else
            ToggleAn8:GetComponent("BoxCollider").enabled = true;

        end
        ToggleAutoRun.gameObject:SetActive(true);
        ToggleAutoRun:GetComponent("UIToggle"):Set(settings.autoRun);
    end
    payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.PKDTZ,nil,nil,settings.scoreSelect)
    --暗牌文字控制
    this.SetAnCardString();
    tableObj:GetComponent('UIGrid'):Reposition()

end

function this.OnEndBonusButtonClick(go)
    --print("OnEndBonusButtonClick was called");
    gridEndBonusPanel.gameObject:SetActive(not gridEndBonusPanel.gameObject.activeSelf);
end

function this.OnTZBonusButtonClick(go)
    --print("OnTZBonusButtonClick was called");
    gridTZBonusPanel.gameObject:SetActive(not gridTZBonusPanel.gameObject.activeSelf);

end

function this.OnEndBonusItemClick(go)
    --print("OnEndBonusItemClick was called");
    m_lastBonus = this.GetEndBonus(go);
    EndBBonusLabel:GetComponent("UILabel").text = this.GetEndBonusString(this.GetEndBonus(go));
    gridEndBonusPanel.gameObject:SetActive(false);
end

function this.OnTZBonusItemClick(go)
    --print("OnTZBonusItemClick was called go"..tostring(go));
    m_canisterBonus = this.GetTZBonus(go);
    TZBonusLabel:GetComponent("UILabel").text = this.GetTZBonusString(this.GetTZBonus(go));
    gridTZBonusPanel.gameObject:SetActive(false);
end

--人数选择事件
function this.OnPeopleSizeClick(go)
    if go == Toggle2P.gameObject or go == Toggle3P.gameObject then
        ToggleRandom.gameObject:SetActive(true);
        ToggleAn8:GetComponent("BoxCollider").enabled = false;
        ToggleAn8:GetComponent("UIToggle"):Set(true);
        ToggleAutoRun.gameObject:SetActive(false);
        ToggleAutoRun:GetComponent("UIToggle"):Set(false);
    else
        if ToggleHappy4Xi:GetComponent("UIToggle").value then
            ToggleAn8:GetComponent("BoxCollider").enabled = false;
        else
            ToggleRandom.gameObject:SetActive(false);

            ToggleAn8:GetComponent("BoxCollider").enabled = true;

        end
        ToggleAutoRun.gameObject:SetActive(true);
    end
    ToggleChoiceDouble.parent.gameObject:SetActive(go == Toggle2P.gameObject)
	ToggleMultiple2.parent.gameObject:SetActive(go == Toggle2P.gameObject and ToggleChoiceDouble:GetComponent("UIToggle").value)
	ToggleIPcheck.parent.gameObject:SetActive(not Toggle2P:GetComponent("UIToggle").value and CONST.IPcheckOn)
    tableObj:GetComponent('UIGrid'):Reposition()
    this.SetAnCardString();
end

--点击3副牌4副牌
function this.OnCardPairToggleClick(go)


    if Toggle3P:GetComponent("UIToggle").value or Toggle2P:GetComponent("UIToggle").value then
        ToggleAn8:GetComponent("BoxCollider").enabled = false;
    else
        if go == ToggleHappy4Xi.gameObject then
            ToggleAn8:GetComponent("BoxCollider").enabled = false;
        else
            ToggleAn8:GetComponent("BoxCollider").enabled = true;
        end

    end

	TZBonusButton.gameObject:SetActive(go == TogglePair3.gameObject)
	TZBonusLabel.gameObject:SetActive(go == TogglePair3.gameObject)
    this.SetAnCardString();
end

function this.SetAnCardString()
    local AnLabel = ToggleAn8:Find("Label"):GetComponent("UILabel");
    if Toggle2P:GetComponent("UIToggle").value then
        if TogglePair3:GetComponent("UIToggle").value then
            AnLabel.text = "暗66张";
        elseif TogglePair4:GetComponent("UIToggle").value then
            AnLabel.text = "暗96张";
        elseif ToggleHappy4Xi:GetComponent("UIToggle").value then
            AnLabel.text = "暗88张";
        end
        ToggleRandom.gameObject:SetActive(true);
    elseif Toggle3P:GetComponent("UIToggle").value then
        if TogglePair3:GetComponent("UIToggle").value then
            AnLabel.text = "暗9张";
        elseif TogglePair4:GetComponent("UIToggle").value then
            AnLabel.text = "暗52张";
        elseif ToggleHappy4Xi:GetComponent("UIToggle").value then
            AnLabel.text = "暗44张";
        end
        ToggleRandom.gameObject:SetActive(true);
    elseif Toggle4P:GetComponent("UIToggle").value then

        if ToggleHappy4Xi:GetComponent("UIToggle").value then
            AnLabel.text = "无暗牌";
        else
            AnLabel.text = "暗8张";
        end
        ToggleRandom.gameObject:SetActive(false);
    end
end

--获得终局奖励数值
function this.GetEndBonus(go)
    if go.name == "endBonusItem1" then
        return 0;
    elseif go.name == "endBonusItem2" then
        return 1;
    elseif go.name == "endBonusItem3" then
        return 2;
    elseif go.name == "endBonusItem4" then
        return 3;
    elseif go.name == "endBonusItem5" then
        return 4;
    end
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

--获得筒子奖励数值
function this.GetTZBonus(go)
    if go.name == "tzBonusItem1" then
        return 1;
    elseif go.name == "tzBonusItem2" then
        return 2;
    elseif go.name == "tzBonusItem3" then
        return 3;
    end
end

function this.GetTZBonusString(canisterBonus)
    if canisterBonus == 0 then
        m_canisterBonus = 1
        return "K筒子奖励100";
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

function this.getBooleanByInt(value)
    if value == 1 then
        return true;
    else
        return false;
    end
end

function this.OnClickTrusteeshipTime(go)
    AudioManager.Instance:PlayAudio('btn')
    local trusteeshipTime = 0;
    
	if go == ToggleTrusteeshipNo.gameObject then
		trusteeshipTime = 0
	elseif go == ToggleTrusteeship1.gameObject then
		trusteeshipTime = 1
    elseif go == ToggleTrusteeship2.gameObject then
        trusteeshipTime = 2
	elseif go == ToggleTrusteeship3.gameObject then
		trusteeshipTime = 3
	elseif go == ToggleTrusteeship5.gameObject then
		trusteeshipTime = 5
	end

	ToggleTrusteeshipOne.parent.gameObject:SetActive(trusteeshipTime ~= 0)
	tableObj:GetComponent('UIGrid'):Reposition()
end

--获取当前设置
function this.GetSettings()
    local settings = {};

    local scoreSelect = 0
    if ToggleRound600:GetComponent("UIToggle").value then
        scoreSelect = 0;
    else
        scoreSelect = 1;
    end

    local size = 4;
    if Toggle4P:GetComponent("UIToggle").value then
        size = 4;
    elseif Toggle3P:GetComponent("UIToggle").value then
        size = 3;
    else
        size = 2;
    end

    local paymentType = 0;
    if ToggleMasterPay:GetComponent("UIToggle").value then
        paymentType = 0;
    else
        paymentType = 2;
    end

    local cardCount = 4;
    if TogglePair3:GetComponent("UIToggle").value then
        cardCount = 3;
    elseif TogglePair4:GetComponent("UIToggle").value then
        cardCount = 4;
    elseif ToggleHappy4Xi:GetComponent("UIToggle").value then
        cardCount = 5;
    end

    local trusteeshipTime = 0;
	if ToggleTrusteeshipNo:GetComponent("UIToggle").value then
		trusteeshipTime = 0
	elseif ToggleTrusteeship1:GetComponent("UIToggle").value then
		trusteeshipTime = 1 * 60
    elseif ToggleTrusteeship2:GetComponent("UIToggle").value then
        trusteeshipTime = 2 * 60
	elseif ToggleTrusteeship3:GetComponent("UIToggle").value then
		trusteeshipTime = 3 * 60
	elseif ToggleTrusteeship5:GetComponent("UIToggle").value then
		trusteeshipTime = 5 * 60
	end

    local trusteeshipType = ToggleTrusteeshipOne:GetComponent("UIToggle").value;
    local trusteeshipRound = ToggleTrusteeshipThree:GetComponent("UIToggle").value and 3 or 0;
	
	settings.openIp = ToggleIPcheck:GetComponent('UIToggle').value
	settings.openGps = ToggleGPScheck:GetComponent('UIToggle').value
	if size == 2 then
		settings.openGps=false
        settings.openIp=false
        settings.choiceDouble=ToggleChoiceDouble:GetComponent("UIToggle").value
        local label_= DoubleScoreText:GetComponent('UILabel').text
        if label_=='不限分' then
            settings.doubleScore=0
        else
            settings.doubleScore=tonumber(string.sub(label_,7,-4))    
        end
        if ToggleMultiple2:GetComponent('UIToggle').value then
            settings.multiple=2
        elseif ToggleMultiple3:GetComponent('UIToggle').value then
            settings.multiple=3
        else
            settings.multiple=4
        end
	end

    local dark            = ToggleAn8:GetComponent("UIToggle").value;
    if cardCount == 5 and size == 4 then
        dark = false;
    end
    local show            = ToggleShowLeftCard:GetComponent("UIToggle").value;
    local san            = ToggleCan3With2:GetComponent("UIToggle").value;
    local radom            = ToggleRandom:GetComponent("UIToggle").value;
    local autoRun            = ToggleAutoRun:GetComponent("UIToggle").value;
    local guan            = ToggleBiGuan:GetComponent("UIToggle").value;
    local dissolveCalcSocre  = ToggleSuddenQuit:GetComponent("UIToggle").value;
    settings.scoreSelect    = scoreSelect;
    settings.size        = size;
    settings.paymentType    = 3;
    settings.cardCount    = cardCount;
    settings.lastBonus    = m_lastBonus;
    if cardCount == 4 or cardCount == 5 then
        settings.canisterBonus = 0;
    else
        settings.canisterBonus = m_canisterBonus;
    end
    settings.dark                   = dark;
    settings.show                   = show;
    settings.san                    = san;
    settings.radom                  = radom;
    settings.autoRun                = autoRun;
    settings.guan                   = guan;
    settings.dissolveCalcSocre      = dissolveCalcSocre;
    settings.rounds                 = 0;
    settings.trusteeship            = trusteeshipTime
    settings.trusteeshipDissolve    = trusteeshipType
    settings.trusteeshipRound       = trusteeshipRound

    print("trusteeshipDissolve", trusteeshipType)
    return settings;

end

function this.OnClickButtonOK(go)
    --判断是增加，修改还是删除
    if optionData.addPlay == true then
        optionData.currentOption = "addPlay";
        local msg            = Message.New();
        msg.type            = proxy_pb.CREATE_CLUB_PLAY;
        local bigbody        = proxy_pb.PCreateClubPlay();
        bigbody.gameType    = proxy_pb.DTZ
        bigbody.roomType    = proxy_pb.PKDTZ
        bigbody.name        = '打筒子';
        bigbody.clubId        = panelClub.clubInfo.clubId;
        local settings = this.GetSettings();
        bigbody.settings = json:encode(settings);
        msg.body            = bigbody:SerializeToString();
        SendProxyMessage(msg, this.OnCreateClubPlayResult);
        print('addPlay')
    elseif optionData.addRule == true then
        optionData.currentOption = "addRule";

        local msg            = Message.New();
        msg.type            = proxy_pb.CREATE_PLAY_RULE;
        local bigbody        = proxy_pb.PCreatePlayRule();
        bigbody.gameType    = proxy_pb.DTZ
        bigbody.playId        = optionData.playId;
        bigbody.clubId        = panelClub.clubInfo.clubId;
        local settings = this.GetSettings();
        bigbody.settings = json:encode(settings);
        msg.body            = bigbody:SerializeToString();
        SendProxyMessage(msg, this.OnCreateClubPlayResult);
        print('addRule')
    else
        optionData.currentOption = "updateRule";

        local msg            = Message.New();
        msg.type            = proxy_pb.UPDATE_PLAY_RULE;
        local bigbody        = proxy_pb.PUpdatePlayRule();
        bigbody.playId        = optionData.playId;
        bigbody.ruleId        = optionData.ruleId;
        bigbody.clubId        = panelClub.clubInfo.clubId;
        local settings = this.GetSettings();
        bigbody.settings = json:encode(settings);
        msg.body            = bigbody:SerializeToString();
        SendProxyMessage(msg, this.OnCreateClubPlayResult);
        print('updateRule')
    end
    print_r(this.GetSettings())
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnCreateClubPlayResult(msg)
    print('OnCreateClubPlayResult was called');

    PanelManager.Instance:HideWindow(gameObject.name);
    if optionData.currentOption == "addPlay" then
        panelMessageTip.SetParamers('添加玩法成功', 1.5);
    elseif optionData.currentOption == "addRule" then
        panelMessageTip.SetParamers('添加规则成功', 1.5);
    elseif optionData.currentOption == "updateRule" then
        panelMessageTip.SetParamers('更新规则成功', 1.5);
    end

    PanelManager.Instance:ShowWindow('panelMessageTip');
end

function this.OnClickClose(go)
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnShowRuleInfo(go)
    PanelManager.Instance:ShowWindow('panelHelp', 36)
end

function this.Update()

end

function this.getIntByBoolean(value)
    if value then
        return 1;
    else
        return 0;
    end
end

function this.getBooleanByInt(value)
    if value == 1 then
        return true;
    else
        return false;
    end
end
function this.OnToggleRoundClick(go)
    local scoreSelect = 0
    if ToggleRound600:GetComponent("UIToggle").value then
        scoreSelect = 0;
    else
        scoreSelect = 1;
    end
    payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.PKDTZ,nil,nil,scoreSelect)
end

function this.OnClickChoiceDouble(go)
    AudioManager.Instance:PlayAudio('btn')
    local choiceDouble
	if ToggleChoiceDouble.gameObject == go then
		choiceDouble = true
	else
		choiceDouble = false
	end
	DoubleScoreText.parent.gameObject:SetActive(choiceDouble)
    ToggleMultiple2.parent.gameObject:SetActive(choiceDouble)
    tableObj:GetComponent('UIGrid'):Reposition()
	-- if choiceDouble then
	-- 	ToggleMultiple2:GetComponent('UIToggle'):Set(multiple == 2)
	-- 	ToggleMultiple3:GetComponent('UIToggle'):Set(multiple == 3)
	-- 	ToggleMultiple4:GetComponent('UIToggle'):Set(multiple == 4)
	-- end
end

function this.OnClickChangeDoubleScore(go)
    AudioManager.Instance:PlayAudio('btn')
    local doubleScore
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
end