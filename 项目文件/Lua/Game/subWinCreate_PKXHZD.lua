local this = {}

local PKXHZD
local payLabel
local tishi

local paymentType=0 --支付类型
local size=4  --人数
local rounds=8 -- 局数
local happyScoreAdd=false -- 喜分运算选择：true 加法、 false 乘法
local canStraight=false --true：可出顺子， false：不可用出顺子
local bomb3AsHappy=false	--true：三个炸弹(除牌2之外的四个牌的炸弹)算一个喜分
local difen=1--基础底分
local niao = false
local niaoValue = 5
local isGan=0-- 0无全干和半干，1半干，2，全干
local trusteeshipTime=0
local trusteeshipType=true
local trusteeshipRound=0
local openIp=false
local openGps=false

--local ToggleRound4=nil
local ToggleRound8=nil
local ToggleRound16=nil
local TogglePeopleNum2=nil
local TogglePeopleNum4=nil
local ToggleMasterPay=nil
local ToggleWinnerPay=nil
local ToggleAdd=nil
local ToggleMultiply=nil
local ToggleShunZi=nil
local ToggleThreeZD=nil
local ToggleSubtractDiFen=nil
local ToggleAddDiFen=nil
local DiFenValue=nil
local ToggleOnNiao=nil
local ToggleOffNiao=nil
local NiaoValueText=nil
local AddButtonNiao=nil
local SubtractButtonNiao=nil
local ToggleNoGan=nil
local ToggleBanGan=nil
local ToggleQuanGan=nil

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

function this.Init(grid,message)
	print('Init_PKXHZD')
	PKXHZD = grid
    payLabel = message.transform:Find('diamond/pay_label')
	tishi = message.transform:Find('tishi')
	
	--ToggleRound4 = PKXHZD:Find('table/ToggleRound/ToggleRound4');
	ToggleRound8 = PKXHZD:Find('table/ToggleRound/ToggleRound8');
	ToggleRound16 = PKXHZD:Find('table/ToggleRound/ToggleRound16');
	TogglePeopleNum4 = PKXHZD:Find('table/TogglePeople/Toggle4P');
	TogglePeopleNum2 = PKXHZD:Find('table/TogglePeople/Toggle2P');
	ToggleMasterPay = PKXHZD:Find('table/TogglePayType/ToggleMasterPay');
	ToggleWinnerPay = PKXHZD:Find('table/TogglePayType/ToggleWinnerPay');
	ToggleAdd = PKXHZD:Find('table/ToggleXiFen/ToggleAdd');
	ToggleMultiply = PKXHZD:Find('table/ToggleXiFen/ToggleMultiply');
	ToggleShunZi = PKXHZD:Find('table/ToggleGeXing/ToggleShunZi');
	ToggleThreeZD = PKXHZD:Find('table/ToggleGeXing/ToggleThreeZD');

	ToggleSubtractDiFen=PKXHZD:Find('table/ToggleFenZhi/SubtractButton');
	ToggleAddDiFen=PKXHZD:Find('table/ToggleFenZhi/AddButton');
	DiFenValue=PKXHZD:Find('table/ToggleFenZhi/Value');

	ToggleOnNiao = PKXHZD:Find('table/niao/OnNiao');
	ToggleOffNiao = PKXHZD:Find('table/niao/OffNiao');
	NiaoValueText = PKXHZD:Find('table/niao/NiaoValue/Value');
	AddButtonNiao = PKXHZD:Find('table/niao/NiaoValue/AddButton')
	SubtractButtonNiao = PKXHZD:Find('table/niao/NiaoValue/SubtractButton')

	ToggleNoGan=PKXHZD:Find('table/ToggleQuanGanBanGan/ToggleNoGan');
	ToggleBanGan=PKXHZD:Find('table/ToggleQuanGanBanGan/ToggleBanGan');
	ToggleQuanGan=PKXHZD:Find('table/ToggleQuanGanBanGan/ToggleQuanGan');

	ToggleTrusteeshipNo = PKXHZD:Find('table/DelegateChoose/NoDelegate')
	ToggleTrusteeship1 = PKXHZD:Find('table/DelegateChoose/Delegate1')
	ToggleTrusteeship2 = PKXHZD:Find('table/DelegateChoose/Delegate2')
	ToggleTrusteeship3 = PKXHZD:Find('table/DelegateChoose/Delegate3')
	ToggleTrusteeship5 = PKXHZD:Find('table/DelegateChoose/Delegate5')
	ToggleTrusteeshipAll = PKXHZD:Find('table/DelegateCancel/FullRound')
	ToggleTrusteeshipOne = PKXHZD:Find('table/DelegateCancel/ThisRound')
	ToggleTrusteeshipThree = PKXHZD:Find('table/DelegateCancel/ThreeRound')
	
	ToggleIPcheck = PKXHZD:Find('table/PreventCheat/IPcheck')
	ToggleGPScheck = PKXHZD:Find('table/PreventCheat/GPScheck')

	--message:AddClick(ToggleRound4.gameObject, this.OnClickToggleRound);
	message:AddClick(ToggleRound8.gameObject, this.OnClickToggleRound);
	message:AddClick(ToggleRound16.gameObject, this.OnClickToggleRound);
	message:AddClick(TogglePeopleNum2.gameObject, this.OnClickTogglePlayerNum);
	message:AddClick(TogglePeopleNum4.gameObject, this.OnClickTogglePlayerNum);
	message:AddClick(ToggleMasterPay.gameObject, this.OnClickTogglePayType)
	message:AddClick(ToggleWinnerPay.gameObject, this.OnClickTogglePayType)

	message:AddClick(ToggleAdd.gameObject, this.OnClickToggleHappyScore)
	message:AddClick(ToggleMultiply.gameObject, this.OnClickToggleHappyScore)
	message:AddClick(ToggleShunZi.gameObject, this.OnClickToggleCanOutShunZi)
	message:AddClick(ToggleThreeZD.gameObject, this.OnClickToggleThreeBoomAsHappyScore)

	message:AddClick(ToggleSubtractDiFen.gameObject, this.OnClickChangeDiFenValue)
	message:AddClick(ToggleAddDiFen.gameObject, this.OnClickChangeDiFenValue)

	message:AddClick(ToggleOnNiao.gameObject, this.OnClickNiao)
	message:AddClick(ToggleOffNiao.gameObject, this.OnClickNiao)
	message:AddClick(AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)


	message:AddClick(ToggleNoGan.gameObject, this.OnClickToggleNoBanGanQuanGan)
	message:AddClick(ToggleBanGan.gameObject, this.OnClickToggleNoBanGanQuanGan)
	message:AddClick(ToggleQuanGan.gameObject, this.OnClickToggleNoBanGanQuanGan)

	message:AddClick(ToggleTrusteeshipNo.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ToggleTrusteeship1.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ToggleTrusteeship2.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ToggleTrusteeship3.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ToggleTrusteeship5.gameObject, this.OnClickTrusteeshipTime)
	message:AddClick(ToggleTrusteeshipOne.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(ToggleTrusteeshipAll.gameObject, this.OnClickTrusteeshipType)
	message:AddClick(ToggleTrusteeshipThree.gameObject, this.OnClickTrusteeshipType)
	
	message:AddClick(ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end
function this.Refresh()
	print('Refresh_PKXHZD')
	rounds= UnityEngine.PlayerPrefs.GetInt('NewPKXHZDrounds', 8)--4 -- 局数
	rounds=rounds==4 and 8 or rounds
	size= UnityEngine.PlayerPrefs.GetInt('NewPKXHZDsize', 4)--人数
	paymentType= UnityEngine.PlayerPrefs.GetInt('NewPKXHZDpaymentType', 0) --0 --支付类型

	happyScoreAdd= UnityEngine.PlayerPrefs.GetInt('NewPKXHZDHappyScoreAdd', 1) == 1--true-- 喜分运算选择：true 加法、 false 乘法
	canStraight= UnityEngine.PlayerPrefs.GetInt('NewPKXHZDCanStraight', 1) == 1--false--true：可出顺子， false：不可用出顺子
	bomb3AsHappy= UnityEngine.PlayerPrefs.GetInt('NewPKXHZDbomb3AsHappy', 1) == 1--false--true：三个炸弹(除牌2之外的四个牌的炸弹)算一个喜分
	difen=UnityEngine.PlayerPrefs.GetInt('NewPKXHZDdifen', 2)
	niao =  UnityEngine.PlayerPrefs.GetInt('NewPKXHZDniao', 0) == 1
	niaoValue = UnityEngine.PlayerPrefs.GetInt('NewPKXHZDniaoValue', 5)
	isGan=UnityEngine.PlayerPrefs.GetInt('NewPKXHZDisGan', 2)
	trusteeshipTime = UnityEngine.PlayerPrefs.GetInt('NewPKXHZDtrusteeshipTime', 0)
	trusteeshipType = UnityEngine.PlayerPrefs.GetInt('NewPKXHZDtrusteeshipType', 0) == 1
	trusteeshipRound = UnityEngine.PlayerPrefs.GetInt('NewPKXHZDtrusteeshipRound', 0)
	openIp=UnityEngine.PlayerPrefs.GetInt('PKXHZDcheckIP', 0)==1
	openGps=UnityEngine.PlayerPrefs.GetInt('PKXHZDcheckGPS', 0)==1

	--ToggleRound4:GetComponent('UIToggle'):Set(4 == rounds)
	ToggleRound8:GetComponent('UIToggle'):Set(8 == rounds)
	ToggleRound16:GetComponent('UIToggle'):Set(16 == rounds)
	TogglePeopleNum2:GetComponent('UIToggle'):Set(2 == size)
	TogglePeopleNum4:GetComponent('UIToggle'):Set(4 == size)
	ToggleMasterPay:GetComponent('UIToggle'):Set(0 == paymentType)
	ToggleWinnerPay:GetComponent('UIToggle'):Set(2 == paymentType)
	ToggleAdd:GetComponent('UIToggle'):Set(true == happyScoreAdd)
	ToggleMultiply:GetComponent('UIToggle'):Set(false == happyScoreAdd)
	ToggleShunZi:GetComponent('UIToggle'):Set(true == canStraight)
	ToggleThreeZD:GetComponent('UIToggle'):Set(true == bomb3AsHappy)

	DiFenValue:GetComponent('UILabel').text=tostring(difen)..'分'

	ToggleOnNiao:GetComponent('UIToggle'):Set(niao)
	ToggleOffNiao:GetComponent('UIToggle'):Set(not niao)
	NiaoValueText.parent.gameObject:SetActive(niao)
	NiaoValueText:GetComponent('UILabel').text = niaoValue.."分"

	ToggleNoGan:GetComponent('UIToggle'):Set(isGan == 0)
	ToggleBanGan:GetComponent('UIToggle'):Set(isGan == 1)
	ToggleQuanGan:GetComponent('UIToggle'):Set(isGan == 2)

	ToggleTrusteeshipNo:GetComponent('UIToggle'):Set(trusteeshipTime == 0)
	ToggleTrusteeship1:GetComponent('UIToggle'):Set(trusteeshipTime == 1)
	ToggleTrusteeship2:GetComponent('UIToggle'):Set(trusteeshipTime == 2)
	ToggleTrusteeship3:GetComponent('UIToggle'):Set(trusteeshipTime == 3)
	ToggleTrusteeship5:GetComponent('UIToggle'):Set(trusteeshipTime == 5)
	ToggleTrusteeshipOne:GetComponent('UIToggle'):Set(trusteeshipType)
	ToggleTrusteeshipAll:GetComponent('UIToggle'):Set(not trusteeshipType and trusteeshipRound == 0)
	ToggleTrusteeshipThree:GetComponent("UIToggle"):Set(trusteeshipRound == 3);
	ToggleTrusteeshipOne.parent.gameObject:SetActive(trusteeshipTime ~= 0)
	ToggleIPcheck.parent.gameObject:SetActive(size > 2 and CONST.IPcheckOn)

	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.PKXHZD,rounds,nil,nil)
	
	DiFenValue.parent.gameObject:SetActive(size == 2)
	ToggleNoGan.parent.gameObject:SetActive(size == 2)
	ToggleOffNiao.parent.gameObject:SetActive(size == 2)
	ToggleIPcheck:GetComponent('UIToggle'):Set(openIp)
	ToggleGPScheck:GetComponent('UIToggle'):Set(openGps)	

	PKXHZD:Find('table').transform:GetComponent('UIGrid'):Reposition()
end
--获取当前设置
function this.GetConfig()
	local moneyLess = false
    --[[if (rounds == 4 and info_login.balance < 4) or
		   (rounds == 8 and info_login.balance < 8) then
			moneyLess = true
		end]]
    local body = {}
    body.roomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', proxy_pb.PKXHZD)
	body.rounds = rounds
    body.size = size
    body.paymentType = paymentType
    body.trusteeship = trusteeshipTime*60;
    body.trusteeshipDissolve = trusteeshipType;
    body.trusteeshipRound = trusteeshipRound;

    body.canStraight = canStraight
    body.happyScoreAdd = happyScoreAdd
	body.bomb3AsHappy = bomb3AsHappy
	
	body.multiple = size == 4 and 0 or isGan
	body.baseScore = size == 4 and 0 or difen
	body.niao = size == 4 and 0 or (niao and niaoValue or 0)
	if size == 2 then
		openIp=false
		openGps=false
	end
	body.openIp	 = openIp
	body.openGps = openGps

    return moneyLess,body;
end

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
	if ToggleRound8.gameObject == go then
		rounds = 8
    elseif ToggleRound16.gameObject == go then
        rounds = 16
    end
	payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.PKXHZD,rounds,nil,nil)
    UnityEngine.PlayerPrefs.SetInt('NewPKXHZDrounds', rounds)
end

function this.OnClickTogglePlayerNum(go)
    AudioManager.Instance:PlayAudio('btn')
	if TogglePeopleNum4.gameObject == go then
		size = 4
	elseif TogglePeopleNum2.gameObject == go then
		size = 2
		tishi.gameObject:SetActive(true)
	end
	ToggleIPcheck.parent.gameObject:SetActive(size > 2 and CONST.IPcheckOn)
	DiFenValue.parent.gameObject:SetActive(size == 2)
	ToggleNoGan.parent.gameObject:SetActive(size == 2)
	ToggleOffNiao.parent.gameObject:SetActive(size == 2)
	PKXHZD:Find('table').transform:GetComponent('UIGrid'):Reposition()
	UnityEngine.PlayerPrefs.SetInt('NewPKXHZDsize', size)
end

function this.OnClickTogglePayType(go)
    AudioManager.Instance:PlayAudio('btn')
    if ToggleMasterPay.gameObject == go then
        paymentType=0
    elseif ToggleWinnerPay.gameObject == go then
        paymentType=2
    end
    UnityEngine.PlayerPrefs.SetInt('NewPKXHZDpaymentType', paymentType)
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
    UnityEngine.PlayerPrefs.SetInt('NewPKXHZDtrusteeshipTime', trusteeshipTime)
	ToggleTrusteeshipOne.parent.gameObject:SetActive(trusteeshipTime ~= 0)
	PKXHZD:Find('table').transform:GetComponent('UIGrid'):Reposition()
end

function this.OnClickTrusteeshipType(go)
    AudioManager.Instance:PlayAudio('btn')
    if ToggleTrusteeshipOne.gameObject == go then
        trusteeshipType = true;
		trusteeshipRound = 0;
    elseif ToggleTrusteeshipAll.gameObject == go then
        trusteeshipType = false
		trusteeshipRound = 0;
	elseif ToggleTrusteeshipThree.gameObject == go then
		trusteeshipRound = 3;
		trusteeshipType = false;
    end
    UnityEngine.PlayerPrefs.SetInt('NewPKXHZDtrusteeshipType',trusteeshipType and 1 or 0)
    UnityEngine.PlayerPrefs.SetInt('NewPKXHZDtrusteeshipRound',trusteeshipRound )
end

function this.OnClickToggleHappyScore(go)
	AudioManager.Instance:PlayAudio('btn')
	if ToggleAdd.gameObject == go then
		happyScoreAdd = true
    else
		happyScoreAdd = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewPKXHZDHappyScoreAdd', happyScoreAdd and 1 or 0)
	ToggleAdd:GetComponent('UIToggle'):Set(true == happyScoreAdd)
	ToggleMultiply:GetComponent('UIToggle'):Set(false == happyScoreAdd)
end

function this.OnClickToggleCanOutShunZi(go)
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		canStraight = true
	else
		canStraight = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewPKXHZDCanStraight', canStraight and 1 or 0)
end

function this.OnClickToggleThreeBoomAsHappyScore(go)
	AudioManager.Instance:PlayAudio('btn')
	if go:GetComponent('UIToggle').value == true then
		bomb3AsHappy = true
	else
		bomb3AsHappy = false
	end
	UnityEngine.PlayerPrefs.SetInt('NewPKXHZDbomb3AsHappy', bomb3AsHappy and 1 or 0)
end

function this.OnClickChangeDiFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if ToggleAddDiFen.gameObject == go then
		difen = difen + 1
		if difen > 10 then
			difen = 10
		end
	elseif ToggleSubtractDiFen.gameObject == go then
		difen = difen - 1
		if difen < 1 then
			difen = 1
		end
	end
	DiFenValue:GetComponent('UILabel').text = difen.."分"
	UnityEngine.PlayerPrefs.SetInt('NewPKXHZDdifen', difen)
end

function this.OnClickNiao(go)
	AudioManager.Instance:PlayAudio('btn')
    if ToggleOnNiao.gameObject == go then
        niao = true
    elseif ToggleOffNiao.gameObject == go then
        niao = false
    end
    NiaoValueText.parent.gameObject:SetActive(niao)
    UnityEngine.PlayerPrefs.SetInt('NewPKXHZDniao', niao and 1 or 0)
end

function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
    if AddButtonNiao.gameObject == go then
        niaoValue = niaoValue + 1
        if niaoValue > 50 then
            niaoValue = 50
        end
    elseif SubtractButtonNiao.gameObject == go then
        niaoValue = niaoValue - 1
        if niaoValue < 1 then
            niaoValue = 1
        end
    end
    NiaoValueText:GetComponent('UILabel').text = niaoValue.."分"
    UnityEngine.PlayerPrefs.SetInt('NewPKXHZDniaoValue', niaoValue)
end

function this.OnClickToggleNoBanGanQuanGan(go)
	AudioManager.Instance:PlayAudio('btn')
	if ToggleNoGan.gameObject == go then
		isGan = 0
    elseif ToggleBanGan.gameObject == go then
		isGan = 1
	elseif ToggleQuanGan.gameObject == go then
		isGan = 2
	end
	UnityEngine.PlayerPrefs.SetInt('NewPKXHZDisGan', isGan)
end

function this.OnClickPreventCheat(go)
	AudioManager.Instance:PlayAudio('btn')
	if ToggleIPcheck.gameObject == go then
		openIp = ToggleIPcheck:GetComponent('UIToggle').value 
		UnityEngine.PlayerPrefs.SetInt('PKXHZDcheckIP', openIp and 1 or 0)
	elseif ToggleGPScheck.gameObject == go then
		openGps = ToggleGPScheck:GetComponent('UIToggle').value
		UnityEngine.PlayerPrefs.SetInt('PKXHZDcheckGPS', openGps and 1 or 0)
	end
end

return this