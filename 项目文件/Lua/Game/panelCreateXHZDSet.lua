
local proxy_pb = require 'proxy_pb'
local xhzd_pb = require 'xhzd_pb'
local json = require 'json'

panelCreateXHZDSet = {}
local this = panelCreateXHZDSet;

local message;
local gameObject;
local wanFaTitle --玩法
local payLabel
local ButtonClose
local ButtonOK
local mask
local RuleButton
local tishi
local gameName;  	--游戏名字
local XHZD = 
{
	--数据
	paymentType=3, --支付类型
	size=4,  --人数
	rounds=8, -- 局数
	happyScoreAdd=true, -- 喜分运算选择：true 加法、 false 乘法
	canStraight=false, --true：可出顺子， false：不可用出顺子
	bomb3AsHappy=false,	--true：三个炸弹(除牌2之外的四个牌的炸弹)算一个喜分
	difen=1,--基础底分
	niao=true,
	niaoValue=5,
	isGan=0,-- 0无全干和半干，1半干，2，全干
	trusteeshipTime=0,
	trusteeshipType=true,
	trusteeshipRound = 0,
	--界面
	transform=nil,
	--ToggleRound4=nil,
	ToggleRound8=nil,
	ToggleRound16=nil,
	Toggle2P=nil, 
	Toggle4P=nil,  
	ToggleAdd=nil, 
	ToggleMultiply =nil,
	ToggleShunZi=nil, 
	ToggleThreeZD =nil,

	ToggleSubtractDiFen=nil,
	ToggleAddDiFen=nil,
	DiFenValue=nil,

	ToggleOnNiao=nil,
	ToggleOffNiao=nil,
	NiaoValueText=nil,
	AddButtonNiao=nil,
	SubtractButtonNiao=nil,

	ToggleNoGan=nil,
	ToggleBanGan=nil,
	ToggleQuanGan=nil,

	ToggleTrusteeshipNo=nil,
	ToggleTrusteeship1=nil,
	ToggleTrusteeship2=nil,
	ToggleTrusteeship3=nil,
	ToggleTrusteeship5=nil,
	ToggleTrusteeshipAll=nil,
	ToggleTrusteeshipThree=nil,
	ToggleTrusteeshipOne=nil
}

--启动事件--
function this.Awake(obj)
	gameObject 			= obj;
	wanFaTitle 			= gameObject.transform:Find('title/Label')
	payLabel 			= gameObject.transform:Find('pay_label')
	ButtonClose 		= gameObject.transform:Find('ButtonClose')
	ButtonOK 			= gameObject.transform:Find('ButtonOK/Background')
	mask 				= gameObject.transform:Find('mask')
	RuleButton			= gameObject.transform:Find('RuleButton')
	message 			= gameObject:GetComponent('LuaBehaviour')

	tishi = gameObject.transform:Find('tishi')

	XHZD.transform = gameObject.transform:Find('XHZD')
	--XHZD.ToggleRound4 = XHZD.transform:Find('grid/ToggleRound/ToggleRound4')
	XHZD.ToggleRound8 = XHZD.transform:Find('grid/ToggleRound/ToggleRound8')
	XHZD.ToggleRound16 = XHZD.transform:Find('grid/ToggleRound/ToggleRound16')
	XHZD.Toggle2P = XHZD.transform:Find('grid/TogglePeople/Toggle2P')
	XHZD.Toggle4P = XHZD.transform:Find('grid/TogglePeople/Toggle4P')
	XHZD.ToggleAdd = XHZD.transform:Find('grid/ToggleXiFen/ToggleAdd')
	XHZD.ToggleMultiply = XHZD.transform:Find('grid/ToggleXiFen/ToggleMultiply')
	XHZD.ToggleShunZi = XHZD.transform:Find('grid/ToggleGeXing/ToggleShunZi')
	XHZD.ToggleThreeZD = XHZD.transform:Find('grid/ToggleGeXing/ToggleThreeZD')

	XHZD.ToggleSubtractDiFen=XHZD.transform:Find('grid/ToggleFenZhi/SubtractButton')
	XHZD.ToggleAddDiFen=XHZD.transform:Find('grid/ToggleFenZhi/AddButton')
	XHZD.DiFenValue=XHZD.transform:Find('grid/ToggleFenZhi/Value')

	XHZD.ToggleOnNiao = XHZD.transform:Find('grid/niao/OnNiao');
	XHZD.ToggleOffNiao = XHZD.transform:Find('grid/niao/OffNiao');
	XHZD.NiaoValueText = XHZD.transform:Find('grid/niao/NiaoValue/Value');
	XHZD.AddButtonNiao = XHZD.transform:Find('grid/niao/NiaoValue/AddButton')
	XHZD.SubtractButtonNiao = XHZD.transform:Find('grid/niao/NiaoValue/SubtractButton')

	XHZD.ToggleNoGan=XHZD.transform:Find('grid/ToggleQuanGanBanGan/ToggleNoGan')
	XHZD.ToggleBanGan=XHZD.transform:Find('grid/ToggleQuanGanBanGan/ToggleBanGan')
	XHZD.ToggleQuanGan=XHZD.transform:Find('grid/ToggleQuanGanBanGan/ToggleQuanGan')

	XHZD.ToggleTrusteeshipNo = XHZD.transform:Find('grid/ToggleTrusteeship/ToggleNo')
	XHZD.ToggleTrusteeship1 = XHZD.transform:Find('grid/ToggleTrusteeship/Toggle1Minute')
	XHZD.ToggleTrusteeship2 = XHZD.transform:Find('grid/ToggleTrusteeship/Toggle2Minute')
	XHZD.ToggleTrusteeship3 = XHZD.transform:Find('grid/ToggleTrusteeship/Toggle3Minute')
	XHZD.ToggleTrusteeship5 = XHZD.transform:Find('grid/ToggleTrusteeship/Toggle5Minute')
	XHZD.ToggleTrusteeshipAll = XHZD.transform:Find('grid/ToggleTrusteeshipType/ToggleAll')
	XHZD.ToggleTrusteeshipOne = XHZD.transform:Find('grid/ToggleTrusteeshipType/ToggleOne')
	XHZD.ToggleTrusteeshipThree = XHZD.transform:Find('grid/ToggleTrusteeshipType/ToggleThree')
	
	XHZD.ToggleIPcheck = XHZD.transform:Find('grid/PreventCheat/IPcheck')
	XHZD.ToggleGPScheck = XHZD.transform:Find('grid/PreventCheat/GPScheck')

	--message:AddClick(XHZD.ToggleRound4.gameObject, this.OnClickToggleRound);
	message:AddClick(XHZD.ToggleRound8.gameObject, this.OnClickToggleRound);
	message:AddClick(XHZD.ToggleRound16.gameObject, this.OnClickToggleRound);
	message:AddClick(XHZD.Toggle2P.gameObject, this.OnClickTogglePlayerNum);
	message:AddClick(XHZD.Toggle4P.gameObject, this.OnClickTogglePlayerNum);
	message:AddClick(XHZD.ToggleAdd.gameObject, this.OnClickToggleHappyScore)
	message:AddClick(XHZD.ToggleMultiply.gameObject, this.OnClickToggleHappyScore)
	message:AddClick(XHZD.ToggleShunZi.gameObject, this.OnClickToggleCanOutShunZi)
	message:AddClick(XHZD.ToggleThreeZD.gameObject, this.OnClickToggleThreeBoomAsHappyScore)

	message:AddClick(XHZD.ToggleSubtractDiFen.gameObject, this.OnClickChangeDiFenValue)
	message:AddClick(XHZD.ToggleAddDiFen.gameObject, this.OnClickChangeDiFenValue)

	message:AddClick(XHZD.ToggleOnNiao.gameObject, this.OnClickNiao)
	message:AddClick(XHZD.ToggleOffNiao.gameObject, this.OnClickNiao)
	message:AddClick(XHZD.AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(XHZD.SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)

	message:AddClick(XHZD.ToggleNoGan.gameObject, this.OnClickToggleNoBanGanQuanGan)
	message:AddClick(XHZD.ToggleBanGan.gameObject, this.OnClickToggleNoBanGanQuanGan)
	message:AddClick(XHZD.ToggleQuanGan.gameObject, this.OnClickToggleNoBanGanQuanGan)

	message:AddClick(XHZD.ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(XHZD.ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(XHZD.ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(XHZD.ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(XHZD.ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(XHZD.ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(XHZD.ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(XHZD.ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)

	message:AddClick(ButtonOK.gameObject, this.OnClickButtonOK);
	message:AddClick(ButtonClose.gameObject, this.OnClickClose);
	message:AddClick(RuleButton.gameObject, this.OnClickRuleButton)
	message:AddClick(XHZD.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(XHZD.ToggleGPScheck.gameObject, this.OnClickPreventCheat)

	message:AddClick(tishi.transform:Find('ButtonOK').gameObject, this.OnClickTiShiButtonOK)
	message:AddClick(tishi.transform:Find('BaseContent/ButtonClose').gameObject, this.OnClickTiShiButtonOK)
	message:AddClick(tishi.transform:Find('BaseContent/mask').gameObject, this.OnClickTiShiButtonOK)
end

function this.Start()
end

function this.Update()
end

local roomType;
local optionData = {};
local curSelectPlay = {}
function this.WhoShow(data)
	roomType = data.roomType
	wanFaTitle:GetComponent("UILabel").text = "当前玩法:"..data.name;
	if data.optionData ~=nil then 
		optionData 			= data.optionData;
		optionData.playId 	= data.playId;
		optionData.ruleId 	= data.ruleId;
	end
	curSelectPlay = {}
	if not data.optionData.addPlay and not data.optionData.addRule then
		curSelectPlay = json:decode(data.settings)
	end
	gameName 			= data.name;
	UnityEngine.PlayerPrefs.SetString('gameName', data.name);
	this.OnEnableRefresh()
	tishi.gameObject:SetActive(false)
end

function this.OnEnableRefresh()
	if optionData.addRule or optionData.addPlay then
		XHZD.size = 4
		XHZD.rounds = 8
		XHZD.happyScoreAdd  = true
		XHZD.canStraight =false
		XHZD.bomb3AsHappy = false
		XHZD.difen=2
		XHZD.niao = false
		XHZD.niaoValue = 5
		XHZD.isGan=2
		XHZD.trusteeshipTime = 0
		XHZD.trusteeshipType = true
		XHZD.trusteeshipRound = 0;
		XHZD.openGps=false
		XHZD.openIp=false
	elseif not optionData.addPlay and not optionData.addRule then
		XHZD.size = curSelectPlay.size
		XHZD.rounds = curSelectPlay.rounds
		XHZD.happyScoreAdd = curSelectPlay.happyScoreAdd
		XHZD.canStraight =curSelectPlay.canStraight
		XHZD.bomb3AsHappy = curSelectPlay.bomb3AsHappy
		XHZD.baseScore=curSelectPlay.baseScore
		XHZD.multiple=curSelectPlay.multiple
		XHZD.openGps=curSelectPlay.openGps
		XHZD.openIp=curSelectPlay.openIp
		XHZD.niao = (curSelectPlay.niao ~= nil and curSelectPlay.niao ~= 0)
		XHZD.niaoValue = (curSelectPlay.niao ~= nil and curSelectPlay.niao ~= 0) and curSelectPlay.niao or 5
		if curSelectPlay.trusteeship and curSelectPlay.trusteeship>0 then
			XHZD.trusteeshipTime = curSelectPlay.trusteeship/60
		else
			XHZD.trusteeshipTime = 0
		end
		XHZD.trusteeshipType = curSelectPlay.trusteeshipDissolve
		XHZD.trusteeshipRound = curSelectPlay.trusteeshipRound == nil and 0 or curSelectPlay.trusteeshipRound
	end
	XHZD.Toggle4P:GetComponent('UIToggle'):Set(4 == XHZD.size)
	XHZD.Toggle2P:GetComponent('UIToggle'):Set(2 == XHZD.size)
	--XHZD.ToggleRound4:GetComponent('UIToggle'):Set(4 == XHZD.rounds)
	XHZD.ToggleRound8:GetComponent('UIToggle'):Set(8 == XHZD.rounds)
	XHZD.ToggleRound16:GetComponent('UIToggle'):Set(16 == XHZD.rounds)
	XHZD.ToggleAdd:GetComponent('UIToggle'):Set(XHZD.happyScoreAdd)
	XHZD.ToggleMultiply:GetComponent('UIToggle'):Set(not XHZD.happyScoreAdd)
	XHZD.ToggleShunZi:GetComponent('UIToggle'):Set(XHZD.canStraight)
	XHZD.ToggleThreeZD:GetComponent('UIToggle'):Set(XHZD.bomb3AsHappy)

	XHZD.DiFenValue:GetComponent('UILabel').text=tostring(XHZD.difen)..'分'

	XHZD.ToggleNoGan:GetComponent('UIToggle'):Set(XHZD.isGan == 0)
	XHZD.ToggleBanGan:GetComponent('UIToggle'):Set(XHZD.isGan == 1)
	XHZD.ToggleQuanGan:GetComponent('UIToggle'):Set(XHZD.isGan == 2)

	XHZD.ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(XHZD.trusteeshipTime == 0)
	XHZD.ToggleTrusteeship1:GetComponent('UIToggle'):Set(XHZD.trusteeshipTime == 1)
	XHZD.ToggleTrusteeship2:GetComponent('UIToggle'):Set(XHZD.trusteeshipTime == 2)
	XHZD.ToggleTrusteeship3:GetComponent('UIToggle'):Set(XHZD.trusteeshipTime == 3)
	XHZD.ToggleTrusteeship5:GetComponent('UIToggle'):Set(XHZD.trusteeshipTime == 5)

	XHZD.ToggleTrusteeshipOne.parent.gameObject:SetActive(true)
	XHZD.ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not XHZD.trusteeshipType and XHZD.trusteeshipRound == 0)
	XHZD.ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(XHZD.trusteeshipRound == 3)
	XHZD.ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(XHZD.trusteeshipType)
	XHZD.ToggleTrusteeshipOne.parent.gameObject:SetActive(XHZD.trusteeshipTime ~= 0)

	XHZD.ToggleOnNiao:GetComponent('UIToggle'):Set(XHZD.niao)
	XHZD.ToggleOffNiao:GetComponent('UIToggle'):Set(not XHZD.niao)
	XHZD.NiaoValueText.parent.gameObject:SetActive(XHZD.niao)
	XHZD.NiaoValueText:GetComponent('UILabel').text = XHZD.niaoValue.."分"

	XHZD.DiFenValue.parent.gameObject:SetActive(XHZD.size == 2)
	XHZD.ToggleNoGan.parent.gameObject:SetActive(XHZD.size == 2)
	XHZD.ToggleOffNiao.parent.gameObject:SetActive(XHZD.size == 2)
	
	XHZD.ToggleIPcheck:GetComponent('UIToggle'):Set(XHZD.openIp)
	XHZD.ToggleGPScheck:GetComponent('UIToggle'):Set(XHZD.openGps)
	XHZD.ToggleIPcheck.parent.gameObject:SetActive(XHZD.size > 2 and CONST.IPcheckOn)

	payLabel:GetComponent("UILabel").text = GetPayMun(roomType,XHZD.rounds,nil,nil)
	XHZD.transform:Find('grid').transform:GetComponent('UIGrid'):Reposition()
	XHZD.transform:GetComponent('UIScrollView'):ResetPosition()
end
function this.ShowRuleInfo(go)
	PanelManager.Instance:ShowWindow('panelHelp',roomType)
end

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
	if XHZD.ToggleRound8.gameObject==go then
		XHZD.rounds = 8
	elseif XHZD.ToggleRound16.gameObject==go then
		XHZD.rounds = 16
	end
	payLabel:GetComponent("UILabel").text = GetPayMun(roomType,XHZD.rounds,nil,nil)
end

function this.OnClickTogglePlayerNum(go)
	AudioManager.Instance:PlayAudio('btn')
	if XHZD.Toggle4P.gameObject == go then
		XHZD.size = 4
	else
		XHZD.size = 2
		tishi.gameObject:SetActive(true)
	end
	XHZD.ToggleIPcheck.parent.gameObject:SetActive(XHZD.size > 2 and CONST.IPcheckOn)
	XHZD.DiFenValue.parent.gameObject:SetActive(XHZD.size == 2)
	XHZD.ToggleNoGan.parent.gameObject:SetActive(XHZD.size == 2)
	XHZD.ToggleOffNiao.parent.gameObject:SetActive(XHZD.size == 2)
	XHZD.NiaoValueText:GetComponent('UILabel').text = XHZD.niaoValue.."分"
	XHZD.transform:Find('grid').transform:GetComponent('UIGrid'):Reposition()
end

function this.OnClickToggleHappyScore(go)
	AudioManager.Instance:PlayAudio('btn')
	if XHZD.ToggleAdd.gameObject == go then
		XHZD.happyScoreAdd = true
    else
		XHZD.happyScoreAdd = false
	end
 end

 function this.OnClickToggleCanOutShunZi(go)
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		XHZD.canStraight = true
    else
		XHZD.canStraight = false
	end
 end

 function this.OnClickToggleThreeBoomAsHappyScore(go)
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		XHZD.bomb3AsHappy = true
    else
		XHZD.bomb3AsHappy = false
	end
 end

function this.OnClickChangeDiFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if XHZD.ToggleAddDiFen.gameObject == go then
		XHZD.difen = XHZD.difen + 1
		if XHZD.difen > 10 then
			XHZD.difen = 10
		end
	elseif XHZD.ToggleSubtractDiFen.gameObject == go then
		XHZD.difen = XHZD.difen - 1
		if XHZD.difen < 1 then
			XHZD.difen = 1
		end
	end
	XHZD.DiFenValue:GetComponent('UILabel').text = XHZD.difen.."分"
end

function this.OnClickNiao(go)
	AudioManager.Instance:PlayAudio('btn')
	if XHZD.ToggleOnNiao.gameObject == go then
		XHZD.niao = true
	elseif XHZD.ToggleOffNiao.gameObject == go then
		XHZD.niao = false
	end
	XHZD.NiaoValueText.parent.gameObject:SetActive(XHZD.niao)
end

function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if XHZD.AddButtonNiao.gameObject == go then
		XHZD.niaoValue = XHZD.niaoValue + 1
		if XHZD.niaoValue > 50 then
			XHZD.niaoValue = 50
		end
	elseif XHZD.SubtractButtonNiao.gameObject == go then
		XHZD.niaoValue = XHZD.niaoValue - 1
		if XHZD.niaoValue < 1 then
			XHZD.niaoValue = 1
		end
	end
	XHZD.NiaoValueText:GetComponent('UILabel').text = XHZD.niaoValue.."分"
end

function this.OnClickToggleNoBanGanQuanGan(go)
	print('go : '..go.name)
	AudioManager.Instance:PlayAudio('btn')
	if XHZD.ToggleNoGan.gameObject == go then
		XHZD.isGan = 0
	elseif XHZD.ToggleBanGan.gameObject == go then
		XHZD.isGan = 1
	elseif XHZD.ToggleQuanGan.gameObject == go then
		XHZD.isGan = 2
	end
end

function this.OnClickTrusteeshipTime(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == XHZD.ToggleTrusteeshipNo.gameObject then
		XHZD.trusteeshipTime = 0
	elseif go == XHZD.ToggleTrusteeship1.gameObject then
		XHZD.trusteeshipTime = 1
	elseif go == XHZD.ToggleTrusteeship2.gameObject then
		XHZD.trusteeshipTime = 2
	elseif go == XHZD.ToggleTrusteeship3.gameObject then
		XHZD.trusteeshipTime = 3
	elseif go == XHZD.ToggleTrusteeship5.gameObject then
		XHZD.trusteeshipTime = 5
	end
	XHZD.ToggleTrusteeshipOne.parent.gameObject:SetActive(XHZD.trusteeshipTime ~= 0)
	XHZD.transform:Find('grid').transform:GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == XHZD.ToggleTrusteeshipAll.gameObject then
		XHZD.trusteeshipType = false
		XHZD.trusteeshipRound = 0;
	elseif go == XHZD.ToggleTrusteeshipOne.gameObject then
		XHZD.trusteeshipType = true
		XHZD.trusteeshipRound = 0;
	elseif go == XHZD.ToggleTrusteeshipThree.gameObject then
		XHZD.trusteeshipRound = 3;
		XHZD.trusteeshipType = false;
	end
end

function this.OnClickButtonOK(go)
	local body 			= {};
	body.paymentType 	= 3;
	body.size 			= XHZD.size;
	body.rounds 		= XHZD.rounds;
	body.happyScoreAdd  = XHZD.happyScoreAdd
	body.canStraight 		= XHZD.canStraight
	body.bomb3AsHappy 		= XHZD.bomb3AsHappy
	body.roomType       = roomType;

	body.multiple = XHZD.size == 4 and 0 or XHZD.isGan
	body.niao = XHZD.size == 4 and 0 or (XHZD.niao and XHZD.niaoValue or 0)
	body.baseScore = XHZD.size == 4 and 0 or XHZD.difen
	body.trusteeship = XHZD.trusteeshipTime*60
	body.trusteeshipDissolve = XHZD.trusteeshipType
	body.trusteeshipRound = XHZD.trusteeshipRound
	if body.size == 2 then
		XHZD.openGps=false
		XHZD.openIp=false
	end
	body.openGps = XHZD.openGps
	body.openIp = XHZD.openIp
	
	for k, v in pairs(body) do
		print(k,v)
	end
	--判断是增加，修改还是删除
	if optionData.addPlay == true then 
		optionData.currentOption = "addPlay";
		local msg 			= Message.New();
		msg.type 			= proxy_pb.CREATE_CLUB_PLAY;
		local bigbody 		= proxy_pb.PCreateClubPlay();
		bigbody.gameType 	= proxy_pb.XHZD
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
		bigbody.gameType    = proxy_pb.XHZD
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

function this.OnClickClose(go)
	AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickRuleButton(go)
	PanelManager.Instance:ShowWindow("panelHelp", 35)
end

function this.OnClickTiShiButtonOK(go)
	AudioManager.Instance:PlayAudio('btn')
	tishi.gameObject:SetActive(false)
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if XHZD.ToggleIPcheck.gameObject == go then
		XHZD.openIp = XHZD.ToggleIPcheck:GetComponent('UIToggle').value
	elseif XHZD.ToggleGPScheck.gameObject == go then
		XHZD.openGps = XHZD.ToggleGPScheck:GetComponent('UIToggle').value
	end
end