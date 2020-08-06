
local proxy_pb = require 'proxy_pb'
local pdk_pb = require 'pdk_pb'
local json = require 'json'

panelCreatePDKSet = {}
local this = panelCreatePDKSet;

local message
local gameObject

local pdk = {}

local tip -- 提示
local ButtonOK
local ButtonClose
local mask
local payLabel
local wanFaTitle 

local paymentType = 3; --支付类型(0:房主支付,2:由赢家支付,3.由群主支付)
local size  --人数
local rounds -- 局数
local cardCount  -- 牌数
local showCount -- 显示牌数量
local firstPlay -- 谁先出
local remainBanker -- 连庄规则
local bombSplit -- 炸弹可拆
local bombBelt -- 炸弹可带3
local bombBelt2 -- 炸弹可带2
local bomb3a 
local singleProtect -- 单张全关保护
local preventJointly -- 防合手
local floatScore  --飘分
local redTen = -1 --红10玩法

local PDK15 = 30; 	--跑的快15张
local PDK16 = 31; 	--跑得快16张

local gameName;  	--游戏名字


local PDKspeed --游戏速度

local trusteeshipTime
local trusteeshipType
local trusteeshipRound=0

local openIp=false
local openGps=false

local choiceDouble = false
local doubleScore = 10
local multiple = 2

local isSettlementScore=false
local fewerValue=10
local addValue=10

local niao = false
local niaoValue = 10

local roomType
local optionData = {}
local curSelectPlay = {}
--启动事件--
function this.Awake(obj)
	gameObject 					= obj
	message 					= gameObject:GetComponent('LuaBehaviour')

	pdk.TogglePlate16 				= gameObject.transform:Find('gird/TogglePlay16')
	pdk.TogglePlate15 				= gameObject.transform:Find('gird/TogglePlay15')
	pdk.ToggleRound8				= gameObject.transform:Find('scroll/table/ToggleRound/ToggleRound8')
    pdk.ToggleRound10 				= gameObject.transform:Find('scroll/table/ToggleRound/ToggleRound10')
	pdk.ToggleRound20 				= gameObject.transform:Find('scroll/table/ToggleRound/ToggleRound20')
	pdk.Toggle3P 					= gameObject.transform:Find('scroll/table/TogglePeople/Toggle3P')
	pdk.Toggle2P 					= gameObject.transform:Find('scroll/table/TogglePeople/Toggle2P')
	pdk.ToggleFanPai 				= gameObject.transform:Find('scroll/table/ToggleQiangZhuang/ToggleFanPai')
	pdk.ToggleBlack3 				= gameObject.transform:Find('scroll/table/ToggleQiangZhuang/ToggleBlack3')
	pdk.Toggle3 					= gameObject.transform:Find('scroll/table/ToggleQiangZhuang/Toggle3')
	pdk.ToggleWinnerZhuang 			= gameObject.transform:Find('scroll/table/ToggleLunZhuang/ToggleWinnerZhuang')
	pdk.ToggleLastZhuang 			= gameObject.transform:Find('scroll/table/ToggleLunZhuang/ToggleLastZhuang')
	pdk.TogglePiaoFen 				= gameObject.transform:Find('scroll/table/ToggleGeXing/TogglePiaoFen')
	pdk.ToggleBaoHu 				= gameObject.transform:Find('scroll/table/ToggleGeXing/ToggleBaoHu')
	pdk.ToggleShowCard 				= gameObject.transform:Find('scroll/table/ToggleGeXing/ToggleShowCard')
	pdk.ToggleZhaDan 				= gameObject.transform:Find('scroll/table/ToggleZhanDan/ToggleZhaDan')
	pdk.Toggle4d3 					= gameObject.transform:Find('scroll/table/ToggleZhanDan/Toggle4d3')
	pdk.Toggle4d2 					= gameObject.transform:Find('scroll/table/ToggleZhanDan/Toggle4d2')
	pdk.Toggle3a 					= gameObject.transform:Find('scroll/table/ToggleGeXing/Toggle3a')
	pdk.ToggleFanHeShou 			= gameObject.transform:Find('scroll/table/ToggleGeXing/ToggleFanHeShou')
	pdk.Toggle2Fen 					= gameObject.transform:Find('scroll/table/ToggleZhanDan/Toggle2Fen')
	pdk.Toggle3Fen 					= gameObject.transform:Find('scroll/table/ToggleZhanDan/Toggle3Fen')
	pdk.Toggle5Fen 					= gameObject.transform:Find('scroll/table/ToggleZhanDan/Toggle5Fen')
	pdk.Toggle10Fen 				= gameObject.transform:Find('scroll/table/ToggleZhanDan/Toggle10Fen')
	pdk.ToggleFanBei 				= gameObject.transform:Find('scroll/table/ToggleGeXing/ToggleFanBei')
	
	pdk.Togglefast 					= gameObject.transform:Find('scroll/table/ToggleSpeed/Togglefast')
	pdk.Toggleslow 					= gameObject.transform:Find('scroll/table/ToggleSpeed/Toggleslow')
	pdk.ToggleTrusteeshipNo 		= gameObject.transform:Find('scroll/table/ToggleTrusteeship/ToggleNo')
	pdk.ToggleTrusteeship1 			= gameObject.transform:Find('scroll/table/ToggleTrusteeship/Toggle1Minute')
	pdk.ToggleTrusteeship2 			= gameObject.transform:Find('scroll/table/ToggleTrusteeship/Toggle2Minute')
	pdk.ToggleTrusteeship3 			= gameObject.transform:Find('scroll/table/ToggleTrusteeship/Toggle3Minute')
	pdk.ToggleTrusteeship5 			= gameObject.transform:Find('scroll/table/ToggleTrusteeship/Toggle5Minute')
	pdk.ToggleTrusteeshipAll 		= gameObject.transform:Find('scroll/table/ToggleTrusteeshipType/ToggleAll')
	pdk.ToggleTrusteeshipOne 		= gameObject.transform:Find('scroll/table/ToggleTrusteeshipType/ToggleOne')
	pdk.ToggleTrusteeshipThree 		= gameObject.transform:Find('scroll/table/ToggleTrusteeshipType/ToggleThree')

	pdk.ToggleOnNiao 				= gameObject.transform:Find('scroll/table/ToggleNiao/OnNiao')
	pdk.ToggleOffNiao 				= gameObject.transform:Find('scroll/table/ToggleNiao/OffNiao')
	pdk.NiaoValueText 				= gameObject.transform:Find('scroll/table/ToggleNiao/NiaoValue/Value')
	pdk.AddButtonNiao 				= gameObject.transform:Find('scroll/table/ToggleNiao/NiaoValue/AddButton')
	pdk.SubtractButtonNiao 			= gameObject.transform:Find('scroll/table/ToggleNiao/NiaoValue/SubtractButton')

	pdk.ToggleOnTen         		= gameObject.transform:Find('scroll/table/RedTen/OnTen')
	pdk.ToggleOffTen        		= gameObject.transform:Find('scroll/table/RedTen/OffTen')
	pdk.TenValueText        		= gameObject.transform:Find('scroll/table/RedTen/TenValue/Value')
	pdk.AddButtonTen        		= gameObject.transform:Find('scroll/table/RedTen/TenValue/AddButton')
	pdk.SubtractButtonTen   		= gameObject.transform:Find('scroll/table/RedTen/TenValue/SubtractButton')
	 
	pdk.ToggleIPcheck 				= gameObject.transform:Find('scroll/table/PreventCheat/IPcheck')
	pdk.ToggleGPScheck 				= gameObject.transform:Find('scroll/table/PreventCheat/GPScheck')

	pdk.ToggleSettlementScoreSelect=gameObject.transform:Find('scroll/table/settlementScore/select')
	pdk.ToggleFewerScoreTxt=gameObject.transform:Find('scroll/table/settlementScore/fewerValue/Value')
	pdk.ToggleFewerAddButton=gameObject.transform:Find('scroll/table/settlementScore/fewerValue/AddButton')
	pdk.ToggleFewerSubtractButton=gameObject.transform:Find('scroll/table/settlementScore/fewerValue/SubtractButton')
	pdk.ToggleAddScoreTxt=gameObject.transform:Find('scroll/table/settlementScore/addValue/Value')
	pdk.ToggleAddAddButton=gameObject.transform:Find('scroll/table/settlementScore/addValue/AddButton')
	pdk.ToggleAddSubtractButton=gameObject.transform:Find('scroll/table/settlementScore/addValue/SubtractButton')

	this.GetPrefabUI()
end

function this.GetPrefabUI()
	
	payLabel 					= gameObject.transform:Find('pay_label')
	ButtonClose 				= gameObject.transform:Find('ButtonClose')
	tip 						= gameObject.transform:Find('tip')
    ButtonOK 					= gameObject.transform:Find('ButtonOK/Background')
    mask 						= gameObject.transform:Find('mask')
	wanFaTitle 					= gameObject.transform:Find('title/Label')

	
	pdk.ToggleMultiple2 = gameObject.transform:Find('scroll/table/multiple/2')
	pdk.ToggleMultiple3 = gameObject.transform:Find('scroll/table/multiple/3')
	pdk.ToggleMultiple4 = gameObject.transform:Find('scroll/table/multiple/4')

	pdk.ToggleChoiceDouble          = gameObject.transform:Find('scroll/table/choiceDouble/On')
	pdk.ToggleNoChoiceDouble        = gameObject.transform:Find('scroll/table/choiceDouble/Off')
	pdk.DoubleScoreText             = gameObject.transform:Find('scroll/table/choiceDouble/doubleScore/Value')
	pdk.AddDoubleScoreButton        = gameObject.transform:Find('scroll/table/choiceDouble/doubleScore/AddButton')
	pdk.SubtractDoubleScoreButton   = gameObject.transform:Find('scroll/table/choiceDouble/doubleScore/SubtractButton')

	message:AddClick(pdk.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(pdk.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(pdk.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(pdk.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)

	message:AddClick(pdk.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(pdk.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(pdk.ToggleMultiple4.gameObject, this.OnClickMultiple)

    message:AddClick(pdk.TogglePlate16.gameObject, this.OnClickTogglePlate)
	message:AddClick(pdk.TogglePlate15.gameObject, this.OnClickTogglePlate)
	message:AddClick(pdk.ToggleRound8.gameObject, this.OnClickToggleRound)
    message:AddClick(pdk.ToggleRound10.gameObject, this.OnClickToggleRound)
	message:AddClick(pdk.ToggleRound20.gameObject, this.OnClickToggleRound)
	message:AddClick(pdk.Toggle3P.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(pdk.Toggle2P.gameObject, this.OnClickTogglePlayerNum)
	message:AddClick(pdk.ToggleFanPai.gameObject, this.OnClickToggleQiangZhuang)
	message:AddClick(pdk.ToggleBlack3.gameObject, this.OnClickToggleQiangZhuang)
	message:AddClick(pdk.Toggle3.gameObject, this.OnClickToggle3)
	message:AddClick(pdk.ToggleWinnerZhuang.gameObject, this.OnClickToggleLunZhuang)
	message:AddClick(pdk.ToggleLastZhuang.gameObject, this.OnClickToggleLunZhuang)
	message:AddClick(pdk.TogglePiaoFen.gameObject, this.OnClickTogglePiaoFen)
	message:AddClick(pdk.ToggleBaoHu.gameObject, this.OnClickToggleBaoHu)
	message:AddClick(pdk.ToggleShowCard.gameObject, this.OnClickToggleShowCard)
	message:AddClick(pdk.ToggleZhaDan.gameObject, this.OnClickToggleZhaDan)
	message:AddClick(pdk.Toggle4d3.gameObject, this.OnClickToggle4d3)
	message:AddClick(pdk.Toggle4d2.gameObject, this.OnClickToggle4d2)
	message:AddClick(pdk.Toggle3a.gameObject, this.OnClickToggle3a)
	message:AddClick(pdk.ToggleFanHeShou.gameObject, this.OnClickToggleFanHeShou)
	message:AddClick(pdk.Toggle2Fen.gameObject, this.OnClickToggleRed10)
	message:AddClick(pdk.Toggle3Fen.gameObject, this.OnClickToggleRed10)
	message:AddClick(pdk.Toggle5Fen.gameObject, this.OnClickToggleRed10)
	message:AddClick(pdk.Toggle10Fen.gameObject, this.OnClickToggleRed10)
	message:AddClick(pdk.ToggleFanBei.gameObject, this.OnClickToggleRed10)
    message:AddClick(ButtonOK.gameObject, this.OnClickButtonOK);
	message:AddClick(ButtonClose.gameObject, this.OnClickMask);
	message:AddClick(pdk.Togglefast.gameObject, this.OnClickToggleSpeed)
	message:AddClick(pdk.Toggleslow.gameObject, this.OnClickToggleSpeed)
	message:AddClick(gameObject.transform:Find('RuleButton').gameObject, this.ShowRuleInfo)
	message:AddClick(pdk.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pdk.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pdk.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pdk.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pdk.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(pdk.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(pdk.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(pdk.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)

	message:AddClick(pdk.ToggleOnNiao.gameObject, this.OnClickChooseNiao)
	message:AddClick(pdk.ToggleOffNiao.gameObject, this.OnClickChooseNiao)
	message:AddClick(pdk.AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(pdk.SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)

	message:AddClick(pdk.ToggleOnTen.gameObject, this.OnClickTen)
	message:AddClick(pdk.ToggleOffTen.gameObject, this.OnClickTen)
	message:AddClick(pdk.AddButtonTen.gameObject, this.OnClickChangeTenValue)
	message:AddClick(pdk.SubtractButtonTen.gameObject, this.OnClickChangeTenValue)

	message:AddClick(pdk.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(pdk.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(pdk.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(pdk.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(pdk.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)
	
	message:AddClick(pdk.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(pdk.ToggleGPScheck.gameObject, this.OnClickPreventCheat)

	if IsAppleReview() then
        pdk.ToggleRound10.gameObject.transform:Find('Label'):Find('Label').gameObject:SetActive(false)
        pdk.ToggleRound20.gameObject.transform:Find('Label'):Find('Label').gameObject:SetActive(false)
	end
end
function this.Start()
end


function this.Update()
   
end

function this.WhoShow(data)
	roomType = data.roomType
	if data.roomType == PDK16 then
		cardCount = 16
		tip:GetComponent('UILabel').text='一副牌去掉双王、3个2、1个A，剩下48张牌，每人16张'
		pdk.Toggle3a.gameObject:SetActive(true)
	else
        cardCount = 15
		tip:GetComponent('UILabel').text='一副牌去掉双王、3个2、3个A、1个K，剩下45张牌，每人15张'
		bomb3a = false
		pdk.Toggle3a:GetComponent('UIToggle'):Set(bomb3a)
		pdk.Toggle3a.gameObject:SetActive(false)
		print('bomb3a:',bomb3a)
	end
	if data.optionData ~=nil then 
		optionData 			= data.optionData;
		optionData.playId 	= data.playId;
		optionData.ruleId 	= data.ruleId;
	end
	
	curSelectPlay = {}
	print('data.addPlay:'..tostring(data.optionData.addPlay).. "data.addRule:"..tostring(data.optionData.addRule))
	if not data.optionData.addPlay and not data.optionData.addRule then
		curSelectPlay = json:decode(data.settings)
		--print_r(curSelectPlay)
	end

	gameName 			= data.name;
	this.clubInfo 		= data.clubInfo
	UnityEngine.PlayerPrefs.SetString('gameName', data.name)

	this.SetTitleInfo(optionData,gameName);
	
	print('cardCount:'..cardCount)
	this.OnEnableRefresh()
end

function this.ShowRuleInfo(go)
	PanelManager.Instance:ShowWindow('panelHelp',roomType)
end
function this.SetTitleInfo(optionData,gameName)
	local panelTitle1 		= gameObject.transform:Find('bg/Label1'):GetComponent('UILabel');
	local panelTitle2 		= gameObject.transform:Find('bg/Label2'):GetComponent('UILabel');
	local panelTitle3 		= gameObject.transform:Find('bg/Label3'):GetComponent('UILabel');
	local saveButtonLabel 	=  gameObject.transform:Find('ButtonOK/Background/Label1'):GetComponent('UILabel');
	-- if optionData.addPlay == true then --增加玩法
	-- 	panelTitle1.text 		= "增加玩法";
	-- 	panelTitle2.text 		= "增加玩法";
	-- 	panelTitle3.text 		= "增加玩法";
	-- 	saveButtonLabel.text 	= "增加玩法";
	-- elseif optionData.addRule == true then --增加规则
	-- 	panelTitle1.text 		= "增加规则";
	-- 	panelTitle2.text 		= "增加规则";
	-- 	panelTitle3.text 		= "增加规则";
	-- 	saveButtonLabel.text 	= "增加规则";

	-- else --修改规则
	-- 	panelTitle1.text 		= "修改规则";
	-- 	panelTitle2.text 		= "修改规则";
	-- 	panelTitle3.text 		= "修改规则";
	-- 	saveButtonLabel.text 	= "修改规则";

	-- end
	wanFaTitle:GetComponent("UILabel").text = "当前玩法:"..gameName;
	
end


--选择速度
function this.OnClickToggleSpeed(go)
	AudioManager.Instance:PlayAudio('btn')
    if pdk.Togglefast.gameObject == go then
		PDKspeed = 0
    else
		PDKspeed = 1
	end
end

function this.OnEnableRefresh()
	PDKspeed = 1
	if optionData.addRule or optionData.addPlay then
		PDKspeed = 1
		size = 2
		rounds = 10
		showCount = true
		firstPlay  = "S3_IN"
		remainBanker = true
		bombSplit = true
		bombBelt = true
		bombBelt2 = true
		bomb3a = false
		singleProtect = false
		preventJointly = true
		floatScore = false
		redTen = -1
		trusteeshipTime = 0
		trusteeshipType = true
		trusteeshipRound = 0;
		niao = false
		niaoValue = 10
		isSettlementScore=false
		fewerValue=10
		addValue=10
		openIp=false
		openGps=false
		choiceDouble=false
		doubleScore=10
		multiple=2
	elseif not optionData.addPlay and not optionData.addRule then
		size 		= curSelectPlay.size  --人数
		rounds 		= curSelectPlay.rounds -- 局数
		cardCount  	= curSelectPlay.cardCount -- 牌数
		showCount 	= curSelectPlay.showCount -- 显示牌数量
		PDKspeed 	= curSelectPlay.speed --speed
		if curSelectPlay.firstPlay == 'RANDOM' then
			firstPlay  = "RANDOM" -- 谁先出
		elseif  curSelectPlay.firstPlay == 'S3' then
			firstPlay  = "S3" -- 谁先出
		elseif curSelectPlay.firstPlay == 'S3_IN' then
			firstPlay  = "S3_IN" -- 谁先出
		end
		remainBanker 	= curSelectPlay.remainBanker-- 连庄规则
		bombSplit 		= curSelectPlay.bombSplit-- 炸弹可拆
		bombBelt 		= curSelectPlay.bombBelt-- 炸弹可带3
		bombBelt2 		= curSelectPlay.bombBeltTwo-- 炸弹可带2
		bomb3a 			= curSelectPlay.bombAAA-- "AAA"可作炸弹
		singleProtect 	= curSelectPlay.singleProtect -- 单张全关保护
		preventJointly 	= curSelectPlay.preventJointly  -- 防合手
		floatScore 		= curSelectPlay.floatScore  --飘分
		redTen 			= tonumber(curSelectPlay.redTen) --红10玩法
		trusteeshipTime = curSelectPlay.trusteeship and (curSelectPlay.trusteeship / 60) or 0
		trusteeshipType = curSelectPlay.trusteeshipDissolve == nil and true or curSelectPlay.trusteeshipDissolve
		trusteeshipRound = curSelectPlay.trusteeshipRound
		openGps=curSelectPlay.openGps
		openIp=curSelectPlay.openIp
		niao = (curSelectPlay.hitBird ~= nil and curSelectPlay.hitBird ~= 0)
		niaoValue = (curSelectPlay.hitBird ~= nil and curSelectPlay.hitBird ~= 0) and curSelectPlay.hitBird or 10
		if curSelectPlay.resultScore ~= nil then
			isSettlementScore=curSelectPlay.resultScore
			fewerValue=curSelectPlay.resultLowerScore
			addValue=curSelectPlay.resultAddScore
		end
		if curSelectPlay.choiceDouble ~= nil then
			choiceDouble= curSelectPlay.choiceDouble
			doubleScore=curSelectPlay.doubleScore
			multiple=curSelectPlay.multiple
		else
			choiceDouble= false
			doubleScore=10
			multiple=2
		end
		print('redTen: '..tostring(redTen))
		print("firstPlay: "..tostring((curSelectPlay.firstPlay)))
		print('是不是3三首出：'..tostring((curSelectPlay.firstPlay == 'S3_IN')))
	end
	if PDKspeed == nil then
		PDKspeed = UnityEngine.PlayerPrefs.GetInt('PDKspeed', 1)
	end
	this.SetPreSetting();
end


function this.SetPreSetting()
	payLabel:GetComponent("UILabel").text = GetPayMun(roomType,rounds,nil,nil)
	pdk.Togglefast:GetComponent('UIToggle'):Set(0 == PDKspeed);
	pdk.Toggleslow:GetComponent('UIToggle'):Set(1 == PDKspeed);
	pdk.Toggle3P:GetComponent('UIToggle'):Set(3 == size)
	pdk.Toggle2P:GetComponent('UIToggle'):Set(2 == size)
	pdk.ToggleRound8:GetComponent('UIToggle'):Set(8 == rounds)
	pdk.ToggleRound10:GetComponent('UIToggle'):Set(10 == rounds)
	pdk.ToggleRound20:GetComponent('UIToggle'):Set(20 == rounds)
	pdk.TogglePlate16:GetComponent('UIToggle'):Set(16 == cardCount)
	pdk.TogglePlate15:GetComponent('UIToggle'):Set(15 == cardCount)
	--print('roomType:'..roomType)
	if cardCount == 15 then
		bomb3a = false
		pdk.Toggle3a:GetComponent('UIToggle'):Set(bomb3a)
		pdk.Toggle3a.gameObject:SetActive(false)
		print('bomb3a:',bomb3a)
	else
		pdk.Toggle3a.gameObject:SetActive(true)
	end
	pdk.ToggleShowCard:GetComponent('UIToggle'):Set(showCount)
	print("firstPlay1111",firstPlay)
	if size == 2 then
		--pdk.ToggleFanPai:GetComponent('UIToggle'):Set(false)

		pdk.ToggleFanHeShou.gameObject:SetActive(false)
		--pdk.ToggleFanHeShou:GetComponent('UIToggle'):Set(false)

		pdk.ToggleBaoHu.gameObject:SetActive(false)
		--pdk.ToggleBaoHu:GetComponent('UIToggle'):Set(false)
		pdk.Toggle3.gameObject:SetActive(true)
	else
		pdk.ToggleFanHeShou.gameObject:SetActive(true)
		pdk.ToggleBaoHu.gameObject:SetActive(true)
	end

	pdk.ToggleChoiceDouble.parent.gameObject:SetActive(size==2)
    pdk.ToggleMultiple2.parent.gameObject:SetActive(size==2 and choiceDouble)
    
	pdk.ToggleMultiple2:GetComponent('UIToggle'):Set(multiple == 2)
	pdk.ToggleMultiple3:GetComponent('UIToggle'):Set(multiple == 3)
	pdk.ToggleMultiple4:GetComponent('UIToggle'):Set(multiple == 4)

	pdk.ToggleChoiceDouble:GetComponent('UIToggle'):Set(choiceDouble)
	pdk.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not choiceDouble)
	pdk.DoubleScoreText.parent.gameObject:SetActive(choiceDouble)
	if doubleScore == 0 then
		pdk.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		pdk.DoubleScoreText:GetComponent('UILabel').text = '小于'..doubleScore..'分'
	end
	print('firstPlay  == RANDOM: '..tostring(firstPlay  == "RANDOM"))
	this.SubSetPreSetting();
end

function this.SubSetPreSetting()
	pdk.ToggleBlack3.gameObject:SetActive(true)
	pdk.Toggle3.gameObject:SetActive(true)
	pdk.ToggleBlack3:GetComponent('UIToggle'):Set(firstPlay  == "S3" or firstPlay  == "S3_IN")
	pdk.Toggle3:GetComponent('UIToggle'):Set(firstPlay  == "S3_IN")
	pdk.ToggleFanPai:GetComponent('UIToggle'):Set(firstPlay  == "RANDOM")
	pdk.Toggle3.gameObject:SetActive(firstPlay  == "S3" or firstPlay  == "S3_IN")
	if remainBanker then
		pdk.ToggleWinnerZhuang:GetComponent('UIToggle'):Set(true)
		pdk.ToggleLastZhuang:GetComponent('UIToggle'):Set(false)
	else
		pdk.ToggleLastZhuang:GetComponent('UIToggle'):Set(true)
		pdk.ToggleWinnerZhuang:GetComponent('UIToggle'):Set(false)
	end
	pdk.ToggleZhaDan:GetComponent('UIToggle'):Set(bombSplit)
	pdk.Toggle4d3:GetComponent('UIToggle'):Set(bombBelt)
	pdk.Toggle4d2:GetComponent('UIToggle'):Set(bombBelt2)
	pdk.Toggle3a:GetComponent('UIToggle'):Set(bomb3a)
	pdk.ToggleBaoHu:GetComponent('UIToggle'):Set(singleProtect)
	pdk.ToggleFanHeShou:GetComponent('UIToggle'):Set(preventJointly)
	pdk.TogglePiaoFen:GetComponent('UIToggle'):Set(floatScore)
	pdk.Toggle2Fen:GetComponent('UIToggle'):Set(2 == redTen)
	pdk.Toggle3Fen:GetComponent('UIToggle'):Set(3 == redTen)
	pdk.Toggle5Fen:GetComponent('UIToggle'):Set(5 == redTen)
	pdk.Toggle10Fen:GetComponent('UIToggle'):Set(10 == redTen)
	pdk.ToggleFanBei:GetComponent('UIToggle'):Set(-1 == redTen)

	pdk.ToggleOnTen:GetComponent("UIToggle"):Set(redTen >0);
	pdk.ToggleOffTen:GetComponent("UIToggle"):Set(redTen == 0 or redTen == -1);
	pdk.TenValueText.parent.gameObject:SetActive(redTen > 0);
	pdk.TenValueText:GetComponent("UILabel").text = redTen.."分";

	pdk.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(trusteeshipTime == 0)
	pdk.ToggleTrusteeship1:GetComponent('UIToggle'):Set(trusteeshipTime == 1)
	pdk.ToggleTrusteeship2:GetComponent('UIToggle'):Set(trusteeshipTime == 2)
	pdk.ToggleTrusteeship3:GetComponent('UIToggle'):Set(trusteeshipTime == 3)
	pdk.ToggleTrusteeship5:GetComponent('UIToggle'):Set(trusteeshipTime == 5)

	pdk.ToggleTrusteeshipOne.parent.gameObject:SetActive(true)
	pdk.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(trusteeshipType == false and trusteeshipRound == 0)
	pdk.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(trusteeshipType == true)
	pdk.ToggleTrusteeshipThree:GetComponent('UIToggle'):Set(trusteeshipRound == 3)
	pdk.ToggleTrusteeshipOne.parent.gameObject:SetActive(trusteeshipTime ~= 0)
	
	pdk.ToggleIPcheck.parent.gameObject:SetActive(size > 2 and CONST.IPcheckOn)
	pdk.ToggleIPcheck:GetComponent('UIToggle'):Set(openIp)
	pdk.ToggleGPScheck:GetComponent('UIToggle'):Set(openGps)

	pdk.ToggleOnNiao:GetComponent('UIToggle'):Set(niao)
	pdk.ToggleOffNiao:GetComponent('UIToggle'):Set(not niao)
	pdk.NiaoValueText.parent.gameObject:SetActive(niao)
	pdk.NiaoValueText:GetComponent('UILabel').text = niaoValue.."分"

	tip:GetComponent('UILabel').text=''
	pdk.ToggleSettlementScoreSelect.parent.gameObject:SetActive(size==2)
	pdk.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(isSettlementScore)
	pdk.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	pdk.ToggleFewerScoreTxt:GetComponent('UILabel').text = fewerValue
	pdk.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	pdk.ToggleAddScoreTxt:GetComponent('UILabel').text = addValue
	gameObject.transform:Find('scroll/table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePlate(go)
	AudioManager.Instance:PlayAudio('btn')
end

function this.OnClickToggleFunction(go)
	AudioManager.Instance:PlayAudio('btn')
    if ToggleFunctionShow.gameObject == go then
        plateShow = true
		tip:GetComponent('UILabel').text='显示玩家的剩余牌数'
    else
        plateShow = false
		tip:GetComponent('UILabel').text='不会显示玩家的剩余牌数'
    end     
	print('plateShow:'..tostring(plateShow))
end


function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
    if pdk.ToggleRound8.gameObject == go then
		rounds = 8
	elseif pdk.ToggleRound10.gameObject == go then
		rounds = 10
    elseif pdk.ToggleRound20.gameObject == go then
		rounds = 20
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(roomType,rounds,nil,nil)
end

function this.OnClickTogglePlayerNum(go)
	AudioManager.Instance:PlayAudio('btn')
	if pdk.Toggle3P.gameObject == go then
		size = 3
	else
		size = 2
	end
	if size == 2 then
		pdk.ToggleFanHeShou.gameObject:SetActive(false)
		pdk.ToggleFanHeShou:GetComponent('UIToggle'):Set(false)
		preventJointly = false

		pdk.ToggleBaoHu.gameObject:SetActive(false)
		pdk.ToggleBaoHu:GetComponent('UIToggle'):Set(false)
		singleProtect = false

		pdk.ToggleBlack3:GetComponent('UIToggle'):Set(true)
		pdk.Toggle3.gameObject:SetActive(true)
		pdk.Toggle3:GetComponent('UIToggle'):Set(true)
		firstPlay = "S3_IN"
	else
		pdk.ToggleFanHeShou.gameObject:SetActive(true)
		pdk.ToggleBaoHu.gameObject:SetActive(true)
	end
	pdk.ToggleIPcheck.parent.gameObject:SetActive(size>2 and CONST.IPcheckOn)
	pdk.ToggleSettlementScoreSelect.parent.gameObject:SetActive(size==2)
	pdk.ToggleChoiceDouble.parent.gameObject:SetActive(size == 2)
	pdk.ToggleMultiple2.parent.gameObject:SetActive(size == 2 and choiceDouble)
	gameObject.transform:Find('scroll/table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickToggleQiangZhuang(go)  --抢庄方式
	AudioManager.Instance:PlayAudio('btn')
	local type = 1
	if pdk.ToggleFanPai.gameObject == go then
		firstPlay = "RANDOM"
		type = 1
		tip:GetComponent('UILabel').text='由房主支付开房钻石'
		pdk.Toggle3.gameObject:SetActive(false)
	else
		if pdk.Toggle3:GetComponent('UIToggle').value == true then
			firstPlay = "S3_IN"
			type = 3
			tip:GetComponent('UILabel').text='首局必须出带有黑桃3的牌型'
		else
			firstPlay = "S3"
			type = 2
			tip:GetComponent('UILabel').text='首局黑桃3先出，可出任意牌型'
		end
		pdk.Toggle3.gameObject:SetActive(true)
	end
end
function  this.OnClickToggle3(go)
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		firstPlay = "S3_IN"
		tip:GetComponent('UILabel').text='首局必须出带有黑桃3的牌型'
	else
		firstPlay = "S3"
		tip:GetComponent('UILabel').text='首局黑桃3先出，可出任意牌型'
	end
end
function this.OnClickToggleLunZhuang(go)  --轮庄方式
	AudioManager.Instance:PlayAudio('btn')
	if pdk.ToggleWinnerZhuang.gameObject == go then
		remainBanker = true
		--tip:GetComponent('UILabel').text='由房主支付开房钻石'
	else
		remainBanker = false
		--tip:GetComponent('UILabel').text='首局必须出带有黑桃3的牌型'
	end
	print('remainBanker:', remainBanker)
end

function this.OnClickTogglePiaoFen(go)  --飘分
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		floatScore = true
		niao = false
		pdk.NiaoValueText.parent.gameObject:SetActive(niao)
		pdk.ToggleOffNiao:GetComponent('UIToggle'):Set(true)
		--tip:GetComponent('UILabel').text='由房主支付开房钻石'
	else
		floatScore = false
		--tip:GetComponent('UILabel').text='首局必须出带有黑桃3的牌型'
	end
	print('floatScore:',floatScore)
end

function this.OnClickToggleBaoHu(go)  --单张全关保护
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		singleProtect = true
		--tip:GetComponent('UILabel').text='由房主支付开房钻石'
	else
		singleProtect = false
		--tip:GetComponent('UILabel').text='首局必须出带有黑桃3的牌型'
	end
	print('singleProtect:',singleProtect)
end

function this.OnClickToggleShowCard(go)  --显示剩余牌数量
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		showCount = true
		--tip:GetComponent('UILabel').text='由房主支付开房钻石'
	else
		showCount = false
		--tip:GetComponent('UILabel').text='首局必须出带有黑桃3的牌型'
	end
	print('showCount:',showCount)
end

function this.OnClickToggleZhaDan(go)  --炸弹可拆
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		bombSplit = true
		--tip:GetComponent('UILabel').text='由房主支付开房钻石'
	else
		bombSplit = false
		bombBelt = false
		bombBelt2 = false
		pdk.Toggle4d3:GetComponent('UIToggle').value = bombBelt
		pdk.Toggle4d2:GetComponent('UIToggle').value = bombBelt2
		--tip:GetComponent('UILabel').text='首局必须出带有黑桃3的牌型'
	end
	print('bombSplit:',bombSplit)
end

function this.OnClickToggle4d3(go)  --炸弹4带3
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		bombBelt = true 
		--tip:GetComponent('UILabel').text='由房主支付开房钻石'
		bombSplit = true
		pdk.ToggleZhaDan:GetComponent('UIToggle').value = bombSplit
	else
		bombBelt = false
		--tip:GetComponent('UILabel').text='首局必须出带有黑桃3的牌型'
	end
	print('bombBelt:',bombBelt)
end
function this.OnClickToggle4d2(go)  --炸弹4带3
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		bombBelt2 = true
		--tip:GetComponent('UILabel').text='由房主支付开房钻石'
		bombSplit = true
		pdk.ToggleZhaDan:GetComponent('UIToggle').value = bombSplit
	else
		bombBelt2 = false
		--tip:GetComponent('UILabel').text='首局必须出带有黑桃3的牌型'
	end
	print('bombBelt:',bombBelt)
end
function this.OnClickToggle3a(go)  --炸弹4带3
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		bomb3a = true
		--tip:GetComponent('UILabel').text='由房主支付开房钻石'
	else
		bomb3a = false
		--tip:GetComponent('UILabel').text='首局必须出带有黑桃3的牌型'
	end
	print('bomb3a:',bomb3a)
end

function this.OnClickToggleFanHeShou(go)  --防合手
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		preventJointly = true
		--tip:GetComponent('UILabel').text='由房主支付开房钻石'
	else
		preventJointly = false
		--tip:GetComponent('UILabel').text='首局必须出带有黑桃3的牌型'
	end
	print('preventJointly:',preventJointly)
end

function this.OnClickToggleRed10(go)  --红十玩法
	AudioManager.Instance:PlayAudio('btn')

	if go:GetComponent('UIToggle').value == true then
		redTen = -1
		--tip:GetComponent('UILabel').text='由房主支付开房钻石'
		pdk.ToggleOffTen:GetComponent("UIToggle"):Set(true);
		pdk.ToggleOnTen:GetComponent("UIToggle"):Set(false);
		pdk.TenValueText.parent.gameObject:SetActive(false);
	else
		redTen = 0
		--tip:GetComponent('UILabel').text='首局必须出带有黑桃3的牌型'
	end
	print('redTen:'..redTen)
end

function this.OnClickTrusteeshipTime(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == pdk.ToggleTrusteeshipNo.gameObject then
		trusteeshipTime = 0
	elseif go == pdk.ToggleTrusteeship1.gameObject then
		trusteeshipTime = 1
	elseif go == pdk.ToggleTrusteeship2.gameObject then
		trusteeshipTime = 2
	elseif go == pdk.ToggleTrusteeship3.gameObject then
		trusteeshipTime = 3
	elseif go == pdk.ToggleTrusteeship5.gameObject then
		trusteeshipTime = 5
	end

	pdk.ToggleTrusteeshipOne.parent.gameObject:SetActive(trusteeshipTime ~= 0)
	gameObject.transform:Find('scroll/table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == pdk.ToggleTrusteeshipAll.gameObject then
		trusteeshipType = false
		trusteeshipRound = 0;
	elseif go == pdk.ToggleTrusteeshipOne.gameObject then
		trusteeshipType = true
		trusteeshipRound = 0;
	elseif go == pdk.ToggleTrusteeshipThree.gameObject then
		trusteeshipRound = 3;
		trusteeshipType = false;
	end
end

function this.OnClickChooseNiao(go)
	AudioManager.Instance:PlayAudio('btn')

	local isChooseNiao = false
	if go == pdk.ToggleOnNiao.gameObject then
		isChooseNiao = true
	end

	if isChooseNiao then
		floatScore = false
		pdk.TogglePiaoFen:GetComponent('UIToggle'):Set(floatScore)
	end
	niao = isChooseNiao
	pdk.NiaoValueText.parent.gameObject:SetActive(niao)
end


function this.OnClickTen(go)
	AudioManager.Instance:PlayAudio('btn')
	if pdk.ToggleOnTen.gameObject == go then
		redTen = UnityEngine.PlayerPrefs.GetInt("PDKredTen",5);
		if redTen <= 0 then
			redTen = 5;
		end
		pdk.ToggleFanBei:GetComponent("UIToggle"):Set(false);
		pdk.TenValueText:GetComponent("UILabel").text = redTen.."分";

		pdk.TenValueText.parent.gameObject:SetActive(true);
	elseif pdk.ToggleOffTen.gameObject == go then

		pdk.TenValueText.parent.gameObject:SetActive(false);
		if pdk.ToggleFanBei:GetComponent("UIToggle").value == false then
			redTen = 0;
		else
			redTen = -1;
		end
	end
end



function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if pdk.AddButtonNiao.gameObject == go then
		niaoValue = niaoValue + 10
		if niaoValue > 100 then
			niaoValue = 100
		end
	else
		niaoValue = niaoValue - 10
		if niaoValue < 10 then
			niaoValue = 10
		end
	end

	pdk.NiaoValueText:GetComponent('UILabel').text = niaoValue.."分"
end


function this.OnClickChangeTenValue(go)
	AudioManager.Instance:PlayAudio('btn');
	if pdk.AddButtonTen.gameObject == go then
		redTen = redTen + 5;
		if redTen > 50 then
			redTen = 50;
		end
	elseif pdk.SubtractButtonTen.gameObject == go then
		redTen = redTen - 5;
		if redTen < 5 then
			redTen = 5;
		end
	end
	pdk.TenValueText:GetComponent("UILabel").text = redTen.."分"
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    isSettlementScore= pdk.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if pdk.ToggleFewerAddButton.gameObject == go then
		fewerValue = fewerValue + 1
		if fewerValue > 100 then
			fewerValue = 100
		end
    elseif pdk.ToggleFewerSubtractButton.gameObject == go then
		fewerValue = fewerValue - 1
		if fewerValue < 1 then
			fewerValue = 1
		end
	end
	pdk.ToggleFewerScoreTxt:GetComponent('UILabel').text = fewerValue
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if pdk.ToggleAddAddButton.gameObject == go then
		addValue = addValue + 1
		if addValue > 100 then
			addValue = 100
		end
    elseif pdk.ToggleAddSubtractButton.gameObject == go then
		addValue = addValue - 1
		if addValue < 1 then
			addValue = 1
		end
	end
	pdk.ToggleAddScoreTxt:GetComponent('UILabel').text = addValue
end

function this.OnClickMask(go)
	AudioManager.Instance:PlayAudio('btn')
	PanelManager.Instance:HideWindow(gameObject.name);
	PanelManager.Instance:ShowWindow("panelSetPlay");
end

function this.OnClickButtonOK(go)
	print("sure to create runfast game rule!");
	AudioManager.Instance:PlayAudio('btn');
    -- if (rounds == 10 and info_login.balance < 3) or  (rounds == 20 and info_login.balance < 6 ) then
	-- 	panelMessageTip.SetParamers('钻石不够啦！赶紧去购买钻石吧', 2)
	-- 	PanelManager.Instance:ShowWindow('panelMessageTip')
    --     return
    -- end

	
	local body 			= {};
	body.paymentType 	= 3;
	body.size 			= size;
	body.rounds 		= rounds;
	body.cardCount 		= cardCount;
	body.showCount 		= showCount;
	body.firstPlay 		= firstPlay;
	body.remainBanker 	= remainBanker;
	body.bombSplit 		= bombSplit;
	body.bombBelt 		= bombBelt;
	body.bombBeltTwo 	= bombBelt2;
	body.bombAAA 		= bomb3a;
	body.singleProtect 	= singleProtect;
	body.preventJointly = preventJointly;
	body.floatScore 	= floatScore;
	body.redTen 		= redTen;
	body.roomType       = roomType;
	body.speed 			= PDKspeed
	body.trusteeship = trusteeshipTime * 60
	body.trusteeshipDissolve = trusteeshipRound == 0 and trusteeshipType or false;
	body.trusteeshipRound = trusteeshipRound
	body.hitBird = niao and niaoValue or 0
	print('firstPlay : '..firstPlay)
	body.resultScore = size==2 and isSettlementScore or false
	body.resultLowerScore=fewerValue
	body.resultAddScore=addValue
	if size == 2 then
		openIp=false
		openGps=false
		body.choiceDouble=choiceDouble
		body.doubleScore=doubleScore
		body.multiple=multiple
	end
	body.openIp			= openIp
	body.openGps 		= openGps
	
	local str = 'rule======'
	for k,v in pairs(body) do
		str = str .. k .. ':'..tostring(v)..' '
	end
	print(str)
	--判断是增加，修改还是删除
	if optionData.addPlay == true then 
		optionData.currentOption = "addPlay";
		local msg 			= Message.New();
		msg.type 			= proxy_pb.CREATE_CLUB_PLAY;
		local bigbody 		= proxy_pb.PCreateClubPlay();
		bigbody.gameType 	= proxy_pb.PDK
		bigbody.roomType    = roomType
		bigbody.name 		= gameName;
		bigbody.clubId 		= panelClub.clubInfo.clubId;
		bigbody.settings 	= json:encode(body);
		msg.body 			= bigbody:SerializeToString();
		SendProxyMessage(msg, this.OnCreateClubPlayResult);
	elseif optionData.addRule == true then
		optionData.currentOption = "addRule";

		local msg 			= Message.New();
		msg.type 			= proxy_pb.CREATE_PLAY_RULE;
		local bigbody 		= proxy_pb.PCreatePlayRule();
		bigbody.gameType    = proxy_pb.PDK
		bigbody.playId 		= optionData.playId;
		bigbody.clubId 		= panelClub.clubInfo.clubId;
		bigbody.settings 	= json:encode(body);
		msg.body 			= bigbody:SerializeToString();
		SendProxyMessage(msg, this.OnCreateClubPlayResult);
	else
		optionData.currentOption = "updateRule";

		local msg 			= Message.New();
		msg.type 			= proxy_pb.UPDATE_PLAY_RULE;
		local bigbody 		= proxy_pb.PUpdatePlayRule();
		bigbody.playId 		= optionData.playId;
		bigbody.ruleId 		= optionData.ruleId;
		bigbody.clubId 		= panelClub.clubInfo.clubId;
		bigbody.settings 	= json:encode(body);
		msg.body 			= bigbody:SerializeToString();
		SendProxyMessage(msg, this.OnCreateClubPlayResult);

	end
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

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if pdk.ToggleIPcheck.gameObject == go then
		openIp = pdk.ToggleIPcheck:GetComponent('UIToggle').value
	elseif pdk.ToggleGPScheck.gameObject == go then
		openGps = pdk.ToggleGPScheck:GetComponent('UIToggle').value
	end
end

function this.OnClickChoiceDouble(go)
    AudioManager.Instance:PlayAudio('btn')
	if pdk.ToggleChoiceDouble.gameObject == go then
		choiceDouble = true
	else
		choiceDouble = false
	end
	
	pdk.DoubleScoreText.parent.gameObject:SetActive(choiceDouble)
    pdk.ToggleMultiple2.parent.gameObject:SetActive(choiceDouble)
	gameObject.transform:Find('scroll/table'):GetComponent('UIGrid'):Reposition()
	if choiceDouble then
		pdk.ToggleMultiple2:GetComponent('UIToggle'):Set(multiple == 2)
		pdk.ToggleMultiple3:GetComponent('UIToggle'):Set(multiple == 3)
		pdk.ToggleMultiple4:GetComponent('UIToggle'):Set(multiple == 4)
	end
end

function this.OnClickChangeDoubleScore(go)
    AudioManager.Instance:PlayAudio('btn')
    local label_= pdk.DoubleScoreText:GetComponent('UILabel').text
    if label_=='不限分' then
        doubleScore=0
    else
        doubleScore=tonumber(string.sub(label_,7,-4))    
    end
	if pdk.AddDoubleScoreButton.gameObject == go then
		if doubleScore ~= 0 then
			doubleScore = doubleScore + 1
			if doubleScore > 100 then
				doubleScore = 0
			end
		end
	else
		if doubleScore == 0 then
			doubleScore = 100
		else
			doubleScore = doubleScore - 1
			if doubleScore < 1 then
				doubleScore = 1
			end
		end
	end

	if doubleScore == 0 then
		pdk.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		pdk.DoubleScoreText:GetComponent('UILabel').text = '小于'..doubleScore..'分'
	end
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
	multiple = tonumber(go.name)
	print('倍数：'..multiple)
end