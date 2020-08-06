
local proxy_pb = require 'proxy_pb'
local json = require 'json'
panelSetModify = {}
local this = panelSetModify

local message
local gameObject

local wanFaTitle
local payLabel
local ButtonOK
local ButtonClose
local mask
local optionTable

local phzObj = {}
local phzData = {}
local syzpObj = {}
local sybpObj = {}
local ahphzObj= {}
local ldfpfObj = {}
local hhhgwObj = {}
local csphzObj = {}
local cdphzObj = {}
local xxghzObj = {}
local hyshkObj = {}
local hylhqObj = {}
local lyzpObj = {}
local hsphzObj = {}
local cddhdObj = {}
local nxphzObj = {}
local xtphzObj = {}
local yxphzObj = {}
local yjghzObj = {}
local czzpObj = {}
local czzpData={}

local curSelectPlay = {}
local copyWanfa = {}

function this.Awake(obj)
	gameObject = obj
	message = gameObject:GetComponent('LuaBehaviour')
	wanFaTitle = gameObject.transform:Find('title/Label')
	payLabel = gameObject.transform:Find('pay_label')
	ButtonOK = gameObject.transform:Find('ButtonOK')
	message:AddClick(ButtonOK.gameObject, this.OnClickButtonOK)
	ButtonClose = gameObject.transform:Find('ButtonClose')
	message:AddClick(ButtonClose.gameObject, this.OnClickClose)
	optionTable = gameObject.transform:Find('scrollView/table')
	message:AddClick(gameObject.transform:Find('RuleButton').gameObject, this.ShowRuleInfo)
	this.InitPHZObj()
	this.InitSYZPObj()
	this.InitAHPHZObj()
	this.InitSYBPObj()
	this.InitCSPHZObj()
	this.InitCDPHZObj()
	this.InitHHHGWObj()
	this.InitXXGHZObj()
	this.InitHYSHKObj()
	this.InitHYLHQObj()
	this.InitLYZPObj()
	this.InitHSPHZObj()
	this.InitCDDHDObj()
	this.InitNXPHZObj()
	this.InitXTPHZObj()
	this.InitYXPHZObj()
	this.InitYJGHZObj()
	this.InitCZZPObj()
end
function this.Start()
end
function this.InitPHZObj()
	phzObj.ToggleRound1 = optionTable:Find('item0_round/grid/round1')
    phzObj.ToggleRound6 = optionTable:Find('item0_round/grid/round6')
	phzObj.ToggleRound8 = optionTable:Find('item0_round/grid/round8')
	phzObj.ToggleRound10 = optionTable:Find('item0_round/grid/round10')
	phzObj.ToggleRound16 = optionTable:Find('item0_round/grid/round16')
	message:AddClick(phzObj.ToggleRound1.gameObject, this.OnClickToggleRound)
	message:AddClick(phzObj.ToggleRound6.gameObject, this.OnClickToggleRound)
	message:AddClick(phzObj.ToggleRound8.gameObject, this.OnClickToggleRound)
    message:AddClick(phzObj.ToggleRound10.gameObject, this.OnClickToggleRound)
	message:AddClick(phzObj.ToggleRound16.gameObject, this.OnClickToggleRound)
	
	phzObj.TogglePlayer3 = optionTable:Find('item1_num/num3')
	phzObj.TogglePlayer4 = optionTable:Find('item1_num/num4')
	phzObj.TogglePlayer2 = optionTable:Find('item1_num/num2')
	message:AddClick(phzObj.TogglePlayer3.gameObject, this.OnClickTogglePlayerNum)
    message:AddClick(phzObj.TogglePlayer4.gameObject, this.OnClickTogglePlayerNum)
    message:AddClick(phzObj.TogglePlayer2.gameObject, this.OnClickTogglePlayerNum)

	phzObj.ToggleBankerAuto = optionTable:Find('item17_randomBanker/Auto')
	phzObj.ToggleBankerFrist = optionTable:Find('item17_randomBanker/Frist')
	message:AddClick(phzObj.ToggleBankerAuto.gameObject, this.OnClickRandomBanker)
	message:AddClick(phzObj.ToggleBankerFrist.gameObject, this.OnClickRandomBanker)

	phzObj.ToggleHuNum3 = optionTable:Find('item3_hu/gridhu/hu3')
	phzObj.ToggleHuNum6 = optionTable:Find('item3_hu/gridhu/hu6')
	phzObj.ToggleHuNum9 = optionTable:Find('item3_hu/gridhu/hu9')
	phzObj.ToggleHuNum10 = optionTable:Find('item3_hu/gridhu/hu10')
	phzObj.ToggleHuNum15 = optionTable:Find('item3_hu/gridhu/hu15')
	message:AddClick(phzObj.ToggleHuNum3.gameObject, this.OnClickToggleHuMinNum)
	message:AddClick(phzObj.ToggleHuNum6.gameObject, this.OnClickToggleHuMinNum)
	message:AddClick(phzObj.ToggleHuNum9.gameObject, this.OnClickToggleHuMinNum)
	message:AddClick(phzObj.ToggleHuNum10.gameObject, this.OnClickToggleHuMinNum)
	message:AddClick(phzObj.ToggleHuNum15.gameObject, this.OnClickToggleHuMinNum)

	phzObj.ToggleSanXiYiTun = optionTable:Find('suanFen/tunMode31')
	phzObj.ToggleYiXiYiTun = optionTable:Find('suanFen/tunMode11')
	phzObj.ToggleFengSanJinSan = optionTable:Find('suanFen/tunMode13')
	message:AddClick(phzObj.ToggleSanXiYiTun.gameObject, this.OnClickHuXiSuanFen)
	message:AddClick(phzObj.ToggleYiXiYiTun.gameObject, this.OnClickHuXiSuanFen)
	message:AddClick(phzObj.ToggleFengSanJinSan.gameObject, this.OnClickHuXiSuanFen)

	phzObj.AddBtnDiFen = optionTable:Find('diFen/diFenScore/AddButton')
	phzObj.SubtractBtnDiFen = optionTable:Find('diFen/diFenScore/SubtractButton')
	phzObj.DiFenTunValue = optionTable:Find('diFen/diFenScore/Value')
	message:AddClick(phzObj.AddBtnDiFen.gameObject, this.OnClickChangeDiFenValue)
	message:AddClick(phzObj.SubtractBtnDiFen.gameObject, this.OnClickChangeDiFenValue)

	phzObj.AddBtnHuangZhuangKouFen = optionTable:Find('huangZhuangFen/kouScore/AddButton')
	phzObj.SubtractBtnHuangZhuangKouFen = optionTable:Find('huangZhuangFen/kouScore/SubtractButton')
	phzObj.HuangZhuangKouFenValue = optionTable:Find('huangZhuangFen/kouScore/Value')
	phzObj.continueBanker = optionTable:Find('huangZhuangFen/continueBanker')
	message:AddClick(phzObj.AddBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)
	message:AddClick(phzObj.SubtractBtnHuangZhuangKouFen.gameObject, this.OnClickChangeHuangZhuangKouFenValue)

	phzObj.ToggleFengDingScore0 = optionTable:Find('item18_maxHuXi/maxHuXiGrid/0')
	phzObj.ToggleFengDingScore5 = optionTable:Find('item18_maxHuXi/maxHuXiGrid/5')
	phzObj.ToggleFengDingScore10 = optionTable:Find('item18_maxHuXi/maxHuXiGrid/10')
	phzObj.ToggleFengDingScore100 = optionTable:Find('item18_maxHuXi/maxHuXiGrid/100')
	phzObj.ToggleFengDingScore150 = optionTable:Find('item18_maxHuXi/maxHuXiGrid/150')
	phzObj.ToggleFengDingScore200 = optionTable:Find('item18_maxHuXi/maxHuXiGrid/200')
	phzObj.ToggleFengDingScore300 = optionTable:Find('item18_maxHuXi/maxHuXiGrid/300')
	phzObj.ToggleFengDingScore400 = optionTable:Find('item18_maxHuXi/maxHuXiGrid/400')
	message:AddClick(phzObj.ToggleFengDingScore0.gameObject, this.OnClickMaxHuXi)
	message:AddClick(phzObj.ToggleFengDingScore5.gameObject, this.OnClickMaxHuXi)
	message:AddClick(phzObj.ToggleFengDingScore10.gameObject, this.OnClickMaxHuXi)
	message:AddClick(phzObj.ToggleFengDingScore100.gameObject, this.OnClickMaxHuXi)
	message:AddClick(phzObj.ToggleFengDingScore150.gameObject, this.OnClickMaxHuXi)
	message:AddClick(phzObj.ToggleFengDingScore200.gameObject, this.OnClickMaxHuXi)
	message:AddClick(phzObj.ToggleFengDingScore300.gameObject, this.OnClickMaxHuXi)
	message:AddClick(phzObj.ToggleFengDingScore400.gameObject, this.OnClickMaxHuXi)

	phzObj.AddBtnZhaNiao = optionTable:Find('zhaNiao/zhaNiaoScore/AddButton')
	phzObj.SubtractBtnZhaNiao = optionTable:Find('zhaNiao/zhaNiaoScore/SubtractButton')
	phzObj.ZhaNiaoValue = optionTable:Find('zhaNiao/zhaNiaoScore/Value')
	message:AddClick(phzObj.AddBtnZhaNiao.gameObject, this.OnClickChangeZhaNiaoValue)
	message:AddClick(phzObj.SubtractBtnZhaNiao.gameObject, this.OnClickChangeZhaNiaoValue)

	phzObj.AddBtnFengDing = optionTable:Find('item_hsphz_fengDing/fengDingScore/AddButton')
	phzObj.SubtractBtnFengDing = optionTable:Find('item_hsphz_fengDing/fengDingScore/SubtractButton')
	phzObj.FengDingValue = optionTable:Find('item_hsphz_fengDing/fengDingScore/Value')
	message:AddClick(phzObj.AddBtnFengDing.gameObject, this.OnClickChangeFengDingValue)
	message:AddClick(phzObj.SubtractBtnFengDing.gameObject, this.OnClickChangeFengDingValue)

	phzObj.ToggleOnNiao = optionTable:Find('item14_niao/OnNiao')
	phzObj.ToggleOffNiao = optionTable:Find('item14_niao/OffNiao')
	phzObj.NiaoValueText = optionTable:Find('item14_niao/NiaoValue/Value')
	phzObj.AddButtonNiao = optionTable:Find('item14_niao/NiaoValue/AddButton')
	phzObj.SubtractButtonNiao = optionTable:Find('item14_niao/NiaoValue/SubtractButton')
	message:AddClick(phzObj.ToggleOnNiao.gameObject, this.OnClickNiao)
	message:AddClick(phzObj.ToggleOffNiao.gameObject, this.OnClickNiao)
	message:AddClick(phzObj.AddButtonNiao.gameObject, this.OnClickChangeNiaoValue)
	message:AddClick(phzObj.SubtractButtonNiao.gameObject, this.OnClickChangeNiaoValue)

	phzObj.ToggleMultiple2 = optionTable:Find('item16_multiple/2')
	phzObj.ToggleMultiple3 = optionTable:Find('item16_multiple/3')
	phzObj.ToggleMultiple4 = optionTable:Find('item16_multiple/4')
	message:AddClick(phzObj.ToggleMultiple2.gameObject, this.OnClickMultiple)
	message:AddClick(phzObj.ToggleMultiple3.gameObject, this.OnClickMultiple)
	message:AddClick(phzObj.ToggleMultiple4.gameObject, this.OnClickMultiple)

	phzObj.ToggleOneRoundDouble = optionTable:Find('item25_multipleend/oneRoundDouble')
	phzObj.ToggleAllRoundDouble = optionTable:Find('item25_multipleend/allRoundDouble')
	message:AddClick(phzObj.ToggleOneRoundDouble.gameObject, this.OnClickRoundDouble)
	message:AddClick(phzObj.ToggleAllRoundDouble.gameObject, this.OnClickRoundDouble)

	phzObj.ToggleChoiceDouble = optionTable:Find('item15_choiceDouble/On')
	phzObj.ToggleNoChoiceDouble = optionTable:Find('item15_choiceDouble/Off')
	phzObj.DoubleScoreText = optionTable:Find('item15_choiceDouble/doubleScore/Value')
	phzObj.AddDoubleScoreButton = optionTable:Find('item15_choiceDouble/doubleScore/AddButton')
	phzObj.SubtractDoubleScoreButton = optionTable:Find('item15_choiceDouble/doubleScore/SubtractButton')
	message:AddClick(phzObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(phzObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDouble)
	message:AddClick(phzObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)
	message:AddClick(phzObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScore)

	phzObj.ToggleNoChouPai = optionTable:Find('item24_choupai/grid/buchou')
	phzObj.ToggleChouPai10 = optionTable:Find('item24_choupai/grid/chou10')
	phzObj.ToggleChouPai14 = optionTable:Find('item24_choupai/grid/chou14')
	phzObj.ToggleChouPai20 = optionTable:Find('item24_choupai/grid/chou20')
	phzObj.ToggleChouPai28 = optionTable:Find('item24_choupai/grid/chou28')
	message:AddClick(phzObj.ToggleNoChouPai.gameObject, this.OnClickToggleChouPai)
	message:AddClick(phzObj.ToggleChouPai10.gameObject, this.OnClickToggleChouPai)
	message:AddClick(phzObj.ToggleChouPai14.gameObject, this.OnClickToggleChouPai)
	message:AddClick(phzObj.ToggleChouPai20.gameObject, this.OnClickToggleChouPai)
	message:AddClick(phzObj.ToggleChouPai28.gameObject, this.OnClickToggleChouPai)

	phzObj.ToggleSettlementScoreSelect=optionTable:Find('settlementScore/select')
	phzObj.ToggleFewerScoreTxt=optionTable:Find('settlementScore/fewerValue/Value')
	phzObj.ToggleFewerAddButton=optionTable:Find('settlementScore/fewerValue/AddButton')
	phzObj.ToggleFewerSubtractButton=optionTable:Find('settlementScore/fewerValue/SubtractButton')
	phzObj.ToggleAddScoreTxt=optionTable:Find('settlementScore/addValue/Value')
	phzObj.ToggleAddAddButton=optionTable:Find('settlementScore/addValue/AddButton')
	phzObj.ToggleAddSubtractButton=optionTable:Find('settlementScore/addValue/SubtractButton')
	message:AddClick(phzObj.ToggleSettlementScoreSelect.gameObject, this.OnClickSettlementScoreSelect)
	message:AddClick(phzObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButton)
	message:AddClick(phzObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButton)
	message:AddClick(phzObj.ToggleAddAddButton.gameObject, this.OnClickAddButton)
	message:AddClick(phzObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButton)
	
	phzObj.ToggleNoDelegate = optionTable:Find("DelegateChoose/NoDelegate")
	phzObj.ToggleDelegate1 = optionTable:Find("DelegateChoose/Delegate1")
	phzObj.ToggleDelegate2 = optionTable:Find("DelegateChoose/Delegate2")
	phzObj.ToggleDelegate3 = optionTable:Find("DelegateChoose/Delegate3")
	phzObj.ToggleDelegate5 = optionTable:Find("DelegateChoose1/Delegate5")
	phzObj.ToggleDelegateThisRound = optionTable:Find("DelegateCancel/ThisRound")
	phzObj.ToggleDelegateFullRound = optionTable:Find("DelegateCancel/FullRound")
	phzObj.ToggleDelegateThreeRound = optionTable:Find("DelegateCancel/ThreeRound")
	message:AddClick(phzObj.ToggleNoDelegate.gameObject, this.OnDelegateTimeClick)
	message:AddClick(phzObj.ToggleDelegate1.gameObject, this.OnDelegateTimeClick)
	message:AddClick(phzObj.ToggleDelegate2.gameObject, this.OnDelegateTimeClick)
	message:AddClick(phzObj.ToggleDelegate3.gameObject, this.OnDelegateTimeClick)
	message:AddClick(phzObj.ToggleDelegate5.gameObject, this.OnDelegateTimeClick)
	message:AddClick(phzObj.ToggleDelegateThisRound.gameObject, this.OnDelegateDissolveClick)
	message:AddClick(phzObj.ToggleDelegateFullRound.gameObject, this.OnDelegateDissolveClick)
	message:AddClick(phzObj.ToggleDelegateThreeRound.gameObject, this.OnDelegateDissolveClick)

	phzObj.ToggleIPcheck = optionTable:Find('PreventCheat/IPcheck')
	phzObj.ToggleGPScheck = optionTable:Find('PreventCheat/GPScheck')
	message:AddClick(phzObj.ToggleIPcheck.gameObject, this.OnClickPreventCheat)
	message:AddClick(phzObj.ToggleGPScheck.gameObject, this.OnClickPreventCheat)
end
function this.InitSYZPObj()
	syzpObj.ToggleHuStep5 = optionTable:Find('item4_hu_step/step5')
	syzpObj.ToggleHuStep3 = optionTable:Find('item4_hu_step/step3')
	syzpObj.ToggleHuStep1 = optionTable:Find('item4_hu_step/step1')
	message:AddClick(syzpObj.ToggleHuStep5.gameObject, this.OnClickToggleHuStep)
    message:AddClick(syzpObj.ToggleHuStep3.gameObject, this.OnClickToggleHuStep)
	message:AddClick(syzpObj.ToggleHuStep1.gameObject, this.OnClickToggleHuStep)

	syzpObj.ToggleFan = optionTable:Find('item5_xing/fan')
	syzpObj.ToggleGen = optionTable:Find('item5_xing/gen')
	message:AddClick(syzpObj.ToggleFan.gameObject, this.OnClickToggleXing)
	message:AddClick(syzpObj.ToggleGen.gameObject, this.OnClickToggleXing)

	syzpObj.ToggleTian = optionTable:Find('item6_hu_type/tian')
	syzpObj.ToggleHong = optionTable:Find('item6_hu_type/hong')
	syzpObj.ToggleZiMo10Hu = optionTable:Find('item6_hu_type/zimo10hu')
	message:AddClick(syzpObj.ToggleTian.gameObject, this.OnClickToggleHuTypeSYZP)
	message:AddClick(syzpObj.ToggleHong.gameObject, this.OnClickToggleHuTypeSYZP)
	message:AddClick(syzpObj.ToggleZiMo10Hu.gameObject, this.OnClickToggleHuTypeSYZP)
end
function this.InitSYBPObj()
	sybpObj.ToggleBpHong = optionTable:Find('item12_SYBPhu_type/BpHong')
	sybpObj.ToggleBpHongDian = optionTable:Find('item12_SYBPhu_type/BpHongDian')
	sybpObj.ToggleBpNone = optionTable:Find('item12_SYBPhu_type/BpNone')
	message:AddClick(sybpObj.ToggleBpHongDian.gameObject, this.OnClickBpHuType)
	message:AddClick(sybpObj.ToggleBpHong.gameObject, this.OnClickBpHuType)
	message:AddClick(sybpObj.ToggleBpNone.gameObject, this.OnClickBpHuType)

	sybpObj.ToggleSYBPZeroToTop = optionTable:Find('syzp_play/zeroToTop')
	sybpObj.Toggle1RoundEnd = optionTable:Find('syzp_play/1roundEnd')
	message:AddClick(sybpObj.Toggle1RoundEnd.gameObject, this.OnClickSYBPPlay)
end
function this.InitCSPHZObj()
	csphzObj.ToggleZiMoFan0 = optionTable:Find('item11_zimofan/zimofan0')
	csphzObj.ToggleZiMoFan1 = optionTable:Find('item11_zimofan/zimofan1')
	csphzObj.ToggleZiMoFan2 = optionTable:Find('item11_zimofan/zimofan2')
	message:AddClick(csphzObj.ToggleZiMoFan0.gameObject, this.OnClickToggleZiMoFan)
	message:AddClick(csphzObj.ToggleZiMoFan1.gameObject, this.OnClickToggleZiMoFan)
	message:AddClick(csphzObj.ToggleZiMoFan2.gameObject, this.OnClickToggleZiMoFan)
end
function this.InitCDPHZObj()
	cdphzObj.Toggleqmt = optionTable:Find('item2_mingtang/qmt')
	cdphzObj.Togglehhd = optionTable:Find('item2_mingtang/hhd')
	message:AddClick(cdphzObj.Toggleqmt.gameObject, this.OnClickToggleMingTang)
	message:AddClick(cdphzObj.Togglehhd.gameObject, this.OnClickToggleMingTang)

	cdphzObj.ToggleShuaHou = optionTable:Find('play1_cdphz/shuaHou')
	cdphzObj.ToggleDaTuanYuan = optionTable:Find('play1_cdphz/daTuanYuan')
	cdphzObj.ToggleTingHu = optionTable:Find('play1_cdphz/tingHu')
	cdphzObj.ToggleHangHangXi = optionTable:Find('play2_cdphz/hangHangXi')
	cdphzObj.ToggleHong47 = optionTable:Find('play2_cdphz/hong47')
	cdphzObj.ToggleHuangFan = optionTable:Find('play2_cdphz/huangFan')
	cdphzObj.ToggleJiaHangHang = optionTable:Find('play3_cdphz/jiaHangHang')
	cdphzObj.ToggleDuiDuiHu = optionTable:Find('play4_cdphz/duiDuiHu')
end
function this.InitAHPHZObj() 
	ahphzObj.ToggleHuStep3 = optionTable:Find('ahphz_hu_step/step3')
	ahphzObj.ToggleHuStep1 = optionTable:Find('ahphz_hu_step/step1') 
    message:AddClick(ahphzObj.ToggleHuStep3.gameObject, this.OnClickToggleHuStepAH)
	message:AddClick(ahphzObj.ToggleHuStep1.gameObject, this.OnClickToggleHuStepAH)
	
	ahphzObj.TogglePapo = optionTable:Find('ahphz_play1/paPo')
	ahphzObj.ToggleHong = optionTable:Find('ahphz_play1/honghei')
	ahphzObj.ToggleZiMoAdd1Tun = optionTable:Find('ahphz_play1/ziMoAddTun')
	ahphzObj.ToggleTian = optionTable:Find('ahphz_play2/tian')
	ahphzObj.ToggleDi = optionTable:Find('ahphz_play2/di')
	ahphzObj.ToggleHaiDi = optionTable:Find('ahphz_play2/haidi')
	message:AddClick(ahphzObj.TogglePapo.gameObject, this.OnClickTogglePlay)
	message:AddClick(ahphzObj.ToggleHong.gameObject, this.OnClickTogglePlay)
	message:AddClick(ahphzObj.ToggleZiMoAdd1Tun.gameObject, this.OnClickTogglePlay)
	message:AddClick(ahphzObj.ToggleTian.gameObject, this.OnClickTogglePlay)
	message:AddClick(ahphzObj.ToggleDi.gameObject, this.OnClickTogglePlay)
	message:AddClick(ahphzObj.ToggleHaiDi.gameObject, this.OnClickTogglePlay)
end
function this.InitHHHGWObj()
	hhhgwObj.ToggleOldMode = optionTable:Find('hhhgw_mode/oldMode')
	hhhgwObj.Toggle468Mode = optionTable:Find('hhhgw_mode/468Mode')
	message:AddClick(hhhgwObj.ToggleOldMode.gameObject, this.OnClickModeSetting)
	message:AddClick(hhhgwObj.Toggle468Mode.gameObject, this.OnClickModeSetting)

	hhhgwObj.ToggleZiMoHu15 = optionTable:Find('hhhgw_play1/ziMoKeHu15')
	hhhgwObj.ToggleZiMoFan2 = optionTable:Find('hhhgw_play1/ziMoFan2')
	hhhgwObj.ToggleLiangPaiKeHu21 = optionTable:Find('hhhgw_play1/liangPaiKeHu21')
	hhhgwObj.ToggleTianHuFan5 = optionTable:Find('hhhgw_play2/tianHuFan5')
	hhhgwObj.ToggleDiHuFan4 = optionTable:Find('hhhgw_play2/diHuFan4')
	hhhgwObj.Toggle18Da5Fan = optionTable:Find('hhhgw_play2/18Da5Fan')
	hhhgwObj.Toggle16Xiao5Fan = optionTable:Find('hhhgw_play3/16Xiao5Fan')
	message:AddClick(hhhgwObj.ToggleZiMoHu15.gameObject, this.OnClickTogglePlayHHHGW)
	message:AddClick(hhhgwObj.ToggleZiMoFan2.gameObject, this.OnClickTogglePlayHHHGW)
	message:AddClick(hhhgwObj.ToggleLiangPaiKeHu21.gameObject, this.OnClickTogglePlayHHHGW)
	message:AddClick(hhhgwObj.ToggleTianHuFan5.gameObject, this.OnClickTogglePlayHHHGW)
	message:AddClick(hhhgwObj.ToggleDiHuFan4.gameObject, this.OnClickTogglePlayHHHGW)
	message:AddClick(hhhgwObj.Toggle18Da5Fan.gameObject, this.OnClickTogglePlayHHHGW)
	message:AddClick(hhhgwObj.Toggle16Xiao5Fan.gameObject, this.OnClickTogglePlayHHHGW)
end
function this.InitXXGHZObj()
	xxghzObj.TogglePlayTuo = optionTable:Find('item19_tuo/PlayTuo')
	xxghzObj.ToggleNotTuo = optionTable:Find('item19_tuo/NotTuo')
	message:AddClick(xxghzObj.TogglePlayTuo.gameObject, this.OnClickPlayTuo)
	message:AddClick(xxghzObj.ToggleNotTuo.gameObject, this.OnClickPlayTuo)
end
function this.InitHYSHKObj()
	hyshkObj.ToggleBaseScore2 = optionTable:Find('item_hysfk_rule1/baseScore2')
	hyshkObj.Toggle1510 = optionTable:Find('item_hysfk_rule1/1-5-10')
	hyshkObj.TogglenoBomb = optionTable:Find('item_hysfk_rule1/noBomb')
	hyshkObj.TogglecantPassHu = optionTable:Find('item_hysfk_rule2/cantPassHu')
	hyshkObj.TogglepiaoHu = optionTable:Find('item_hysfk_rule2/piaoHu')
	hyshkObj.ToggletianDiHaiHu = optionTable:Find('item_hysfk_rule2/tianDiHaiHu')
	hyshkObj.TogglemingWei = optionTable:Find('item_hysfk_rule3/mingWei')
	hyshkObj.TogglexiaoHong3Fan = optionTable:Find('item_hysfk_rule3/xiaoHong3Fan')
	
	hyshkObj.ToggleFangPao1 = optionTable:Find('item_hysfk_fangpao/1')
	hyshkObj.ToggleFangPao2 = optionTable:Find('item_hysfk_fangpao/2')
	hyshkObj.ToggleFangPao3 = optionTable:Find('item_hysfk_fangpao/3')

	hyshkObj.ToggleFanHYSHK = optionTable:Find('item_hysfk_xing/fan')
	hyshkObj.ToggleGenHYSHK = optionTable:Find('item_hysfk_xing/gen')
	hyshkObj.ToggleNoHYSHK = optionTable:Find('item_hysfk_xing/no')
	

	message:AddClick(hyshkObj.ToggleBaseScore2.gameObject, this.OnClickToggleHuType)
    message:AddClick(hyshkObj.Toggle1510.gameObject, this.OnClickToggleHuType)
	message:AddClick(hyshkObj.TogglenoBomb.gameObject, this.OnClickToggleHuType)
	message:AddClick(hyshkObj.TogglecantPassHu.gameObject, this.OnClickToggleHuType)
	message:AddClick(hyshkObj.TogglepiaoHu.gameObject, this.OnClickToggleHuType)
	message:AddClick(hyshkObj.ToggletianDiHaiHu.gameObject, this.OnClickToggleHuType)
	message:AddClick(hyshkObj.TogglemingWei.gameObject, this.OnClickToggleHuType)
	message:AddClick(hyshkObj.TogglexiaoHong3Fan.gameObject, this.OnClickToggleHuType)
	
	message:AddClick(hyshkObj.ToggleFanHYSHK.gameObject, this.OnClickToggleFanType)
	message:AddClick(hyshkObj.ToggleGenHYSHK.gameObject, this.OnClickToggleFanType)
	message:AddClick(hyshkObj.ToggleNoHYSHK.gameObject, this.OnClickToggleFanType)

	message:AddClick(hyshkObj.ToggleFangPao1.gameObject, this.OnClickToggleFangPao)
	message:AddClick(hyshkObj.ToggleFangPao2.gameObject, this.OnClickToggleFangPao)
	message:AddClick(hyshkObj.ToggleFangPao3.gameObject, this.OnClickToggleFangPao)
end
function this.InitHYLHQObj()
	hylhqObj.ToggleQiHuHuXu6 = optionTable:Find('item_hylhq_qihuhuxu/6')
	hylhqObj.ToggleQiHuHuXu9 = optionTable:Find('item_hylhq_qihuhuxu/9')

	hylhqObj.ToggleBaseScore2HYLHQ = optionTable:Find('item_hylhq_rule1/baseScore2')
	hylhqObj.Toggle1510HYLHQ = optionTable:Find('item_hylhq_rule1/1-5-10')
	hylhqObj.TogglecantPassHuHYLHQ = optionTable:Find('item_hylhq_rule1/cantPassHu')
	hylhqObj.ToggleHongHeiDianHYLHQ = optionTable:Find('item_hylhq_rule2/hongheidian')
	hylhqObj.ToggletianDiHaiHuHYLHQ = optionTable:Find('item_hylhq_rule2/tianDiHaiHu')
	hylhqObj.TogglemingWeiHYLHQ = optionTable:Find('item_hylhq_rule2/mingWei')
	hylhqObj.ToggleLiangPaoHYLHQ = optionTable:Find('item_hylhq_rule3/liangpao')
	hylhqObj.ToggleYiHuYiTunHYLHQ = optionTable:Find('item_hylhq_rule3/yihuyitun')
	hylhqObj.Toggle21ZhangHYLHQ = optionTable:Find('item_hylhq_rule3/21zhang')
	
	hylhqObj.ToggleFanHYLHQ = optionTable:Find('item_hylhq_xing/fan')
	hylhqObj.ToggleGenHYLHQ = optionTable:Find('item_hylhq_xing/gen')
	hylhqObj.ToggleNoHYLHQ = optionTable:Find('item_hylhq_xing/no')

	message:AddClick(hylhqObj.ToggleQiHuHuXu6.gameObject, this.OnClickQiHuHuXu)
	message:AddClick(hylhqObj.ToggleQiHuHuXu9.gameObject, this.OnClickQiHuHuXu)

	message:AddClick(hylhqObj.ToggleBaseScore2HYLHQ.gameObject, this.OnClickToggleHuTypeHYLHQ)
    message:AddClick(hylhqObj.Toggle1510HYLHQ.gameObject, this.OnClickToggleHuTypeHYLHQ)
	message:AddClick(hylhqObj.TogglecantPassHuHYLHQ.gameObject, this.OnClickToggleHuTypeHYLHQ)
	message:AddClick(hylhqObj.ToggleHongHeiDianHYLHQ.gameObject, this.OnClickToggleHuTypeHYLHQ)
	message:AddClick(hylhqObj.ToggletianDiHaiHuHYLHQ.gameObject, this.OnClickToggleHuTypeHYLHQ)
	message:AddClick(hylhqObj.TogglemingWeiHYLHQ.gameObject, this.OnClickToggleHuTypeHYLHQ)
	message:AddClick(hylhqObj.ToggleLiangPaoHYLHQ.gameObject, this.OnClickToggleHuTypeHYLHQ)
	message:AddClick(hylhqObj.ToggleYiHuYiTunHYLHQ.gameObject, this.OnClickToggleHuTypeHYLHQ)
	message:AddClick(hylhqObj.Toggle21ZhangHYLHQ.gameObject, this.OnClickToggleHuTypeHYLHQ)
	
	message:AddClick(hylhqObj.ToggleFanHYLHQ.gameObject, this.OnClickToggleFanTypeHYLHQ)
	message:AddClick(hylhqObj.ToggleGenHYLHQ.gameObject, this.OnClickToggleFanTypeHYLHQ)
	message:AddClick(hylhqObj.ToggleNoHYLHQ.gameObject, this.OnClickToggleFanTypeHYLHQ)
end
function this.InitLYZPObj()
	lyzpObj.ToggleChoiceHu = optionTable:Find('lyzp_play/choiceHu')
	lyzpObj.ToggleMaoHu = optionTable:Find('lyzp_play/maoHu')
	lyzpObj.ToggleYiDianHong = optionTable:Find('lyzp_play/yiDianHong')
	lyzpObj.ToggleTiAddScore0 = optionTable:Find('tiAddScore/tiAddScore0')
	lyzpObj.ToggleTiAddScore1 = optionTable:Find('tiAddScore/tiAddScore1')
	lyzpObj.ToggleTiAddScore2 = optionTable:Find('tiAddScore/tiAddScore2')
	message:AddClick(lyzpObj.ToggleTiAddScore0.gameObject, this.OnClickToggleTiAddScore)
	message:AddClick(lyzpObj.ToggleTiAddScore1.gameObject, this.OnClickToggleTiAddScore)
	message:AddClick(lyzpObj.ToggleTiAddScore2.gameObject, this.OnClickToggleTiAddScore)
end
function this.InitHSPHZObj()
	hsphzObj.AddBtnQiHuTun = optionTable:Find('item_hsphz_qiHuTun/qiHuScore/AddButton')
	hsphzObj.SubtractBtnQiHuTun = optionTable:Find('item_hsphz_qiHuTun/qiHuScore/SubtractButton')
	hsphzObj.QiHuTunValue = optionTable:Find('item_hsphz_qiHuTun/qiHuScore/Value')
	message:AddClick(hsphzObj.AddBtnQiHuTun.gameObject, this.OnClickChangeQiHuTunValue)
	message:AddClick(hsphzObj.SubtractBtnQiHuTun.gameObject, this.OnClickChangeQiHuTunValue)

	hsphzObj.ToggleWuDui = optionTable:Find('item_hsphz_play/wuDui')
	hsphzObj.ToggleHongDui = optionTable:Find('item_hsphz_play/hongDui')
	hsphzObj.ToggleJiaHongDui = optionTable:Find('item_hsphz_play/jiaHongDui')
	message:AddClick(hsphzObj.ToggleWuDui.gameObject, this.OnClickToggleWuDui)
	message:AddClick(hsphzObj.ToggleHongDui.gameObject, this.OnClickToggleHongDui)
	message:AddClick(hsphzObj.ToggleJiaHongDui.gameObject, this.OnClickToggleJiaHongDui)

	hsphzObj.ToggleWinBanker = optionTable:Find('item_hsphz_selectBanker/winBanker')
	hsphzObj.ToggleLoopBanker = optionTable:Find('item_hsphz_selectBanker/loopBanker')
	message:AddClick(hsphzObj.ToggleWinBanker.gameObject, this.OnClickSelectBanker)
	message:AddClick(hsphzObj.ToggleLoopBanker.gameObject, this.OnClickSelectBanker)
end
function this.InitCDDHDObj()
	cddhdObj.ToggleTianHu = optionTable:Find('play1_cddhd/tianHu')
	cddhdObj.ToggleDiHu = optionTable:Find('play1_cddhd/diHu')
	cddhdObj.ToggleTingHu = optionTable:Find('play1_cddhd/tingHu')
	cddhdObj.ToggleHaiDiHu = optionTable:Find('play2_cddhd/haiDiHu')
	cddhdObj.ToggleHuangFan = optionTable:Find('play2_cddhd/huangFan')
end
function this.InitNXPHZObj()
	nxphzObj.ToggleZiMoFanBei = optionTable:Find('nxphz_play1/ziMoFanBei')
	nxphzObj.ToggleShiLiuXiao = optionTable:Find('nxphz_play1/shiLiuXiao')
	nxphzObj.ToggleHaiDiHu = optionTable:Find('nxphz_play1/haiDiHu')
	nxphzObj.ToggleShuaHou = optionTable:Find('nxphz_play2/shuaHou')
	nxphzObj.ToggleAdd1When27 = optionTable:Find('nxphz_play2/add1When27')
	nxphzObj.ToggleAddHongXiaoDa = optionTable:Find('nxphz_play2/addHongXiaoDa')
	message:AddClick(nxphzObj.ToggleZiMoFanBei.gameObject, this.OnClickToggleZiMoFanBei)
	message:AddClick(nxphzObj.ToggleShiLiuXiao.gameObject, this.OnClickToggleShiLiuXiao)
	message:AddClick(nxphzObj.ToggleHaiDiHu.gameObject, this.OnClickToggleHaiDiHu)
	message:AddClick(nxphzObj.ToggleShuaHou.gameObject, this.OnClickToggleShuaHou)
	message:AddClick(nxphzObj.ToggleAdd1When27.gameObject, this.OnClickToggleAdd1When27)
	message:AddClick(nxphzObj.ToggleAddHongXiaoDa.gameObject, this.OnClickToggleAddHongXiaoDa)

	nxphzObj.ToggleZiMoAddTun0 = optionTable:Find('ziMoAddTun/ziMoAddTun0')
	nxphzObj.ToggleZiMoAddTun1 = optionTable:Find('ziMoAddTun/ziMoAddTun1')
	nxphzObj.ToggleZiMoAddTun2 = optionTable:Find('ziMoAddTun/ziMoAddTun2')
	message:AddClick(nxphzObj.ToggleZiMoAddTun0.gameObject, this.OnClickToggleZiMoAddTun)
	message:AddClick(nxphzObj.ToggleZiMoAddTun1.gameObject, this.OnClickToggleZiMoAddTun)
	message:AddClick(nxphzObj.ToggleZiMoAddTun2.gameObject, this.OnClickToggleZiMoAddTun)
end
function this.InitXTPHZObj()
	xtphzObj.ToggleYiWuShi = optionTable:Find('xtphz_play1/yiWuShi')
	xtphzObj.ToggleShiZhongBuLiang = optionTable:Find('xtphz_play1/shiZhongBuLiang')
	xtphzObj.ToggleHu30FangBei = optionTable:Find('xtphz_play1/hu30FangBei')
	xtphzObj.ToggleTianDiHu = optionTable:Find('xtphz_play2/tianDiHu')
	xtphzObj.TogglePengPengHu = optionTable:Find('xtphz_play2/pengPengHu')
	xtphzObj.ToggleDaXiaoZiHu = optionTable:Find('xtphz_play2/daXiaoZiHu')
	xtphzObj.ToggleYiDianHong = optionTable:Find('xtphz_play3/yiDianHong')
	xtphzObj.ToggleHeiHongHu = optionTable:Find('xtphz_play3/heiHongHu')
	xtphzObj.ToggleHong13 = optionTable:Find('xtphz_play3/hong13')
	xtphzObj.ToggleCanHuZiMo = optionTable:Find('xtphz_play4/canHuZiMo')
	xtphzObj.ToggleCanAnWei = optionTable:Find('xtphz_play4/canAnWei')
	xtphzObj.ToggleChouWeiLiang = optionTable:Find('xtphz_play4/chouWeiLiang')
	message:AddClick(xtphzObj.ToggleYiWuShi.gameObject, this.OnClickToggleXTPHZPlay)
	message:AddClick(xtphzObj.ToggleShiZhongBuLiang.gameObject, this.OnClickToggleXTPHZPlay)
	message:AddClick(xtphzObj.ToggleHu30FangBei.gameObject, this.OnClickToggleXTPHZPlay)
	message:AddClick(xtphzObj.ToggleTianDiHu.gameObject, this.OnClickToggleXTPHZPlay)
	message:AddClick(xtphzObj.TogglePengPengHu.gameObject, this.OnClickToggleXTPHZPlay)
	message:AddClick(xtphzObj.ToggleDaXiaoZiHu.gameObject, this.OnClickToggleXTPHZPlay)
	message:AddClick(xtphzObj.ToggleYiDianHong.gameObject, this.OnClickToggleXTPHZPlay)
	message:AddClick(xtphzObj.ToggleHeiHongHu.gameObject, this.OnClickToggleXTPHZPlay)
	message:AddClick(xtphzObj.ToggleHong13.gameObject, this.OnClickToggleXTPHZPlay)
	message:AddClick(xtphzObj.ToggleCanHuZiMo.gameObject, this.OnClickToggleXTPHZPlay)
	message:AddClick(xtphzObj.ToggleCanAnWei.gameObject, this.OnClickToggleXTPHZPlay)
	message:AddClick(xtphzObj.ToggleChouWeiLiang.gameObject, this.OnClickToggleXTPHZPlay)

	xtphzObj.ToggleFanShuChen = optionTable:Find('xtphz_fanShu/fanShuChen')
	xtphzObj.ToggleFanShuJia = optionTable:Find('xtphz_fanShu/fanShuJia')
	xtphzObj.TogglefanShuYiBei = optionTable:Find('xtphz_fanShu/fanShuYiBei')
	message:AddClick(xtphzObj.ToggleFanShuChen.gameObject, this.OnClickToggleFanShuSuanFen)
	message:AddClick(xtphzObj.ToggleFanShuJia.gameObject, this.OnClickToggleFanShuSuanFen)
	message:AddClick(xtphzObj.TogglefanShuYiBei.gameObject, this.OnClickToggleFanShuSuanFen)
end
function this.InitYXPHZObj()
	yxphzObj.ToggleLianZhuang = optionTable:Find('yxphz_mode41/lianZhuang')
	yxphzObj.ToggleZhongZhuang = optionTable:Find('yxphz_mode41/zhongZhuang')
	message:AddClick(yxphzObj.ToggleLianZhuang.gameObject, this.OnClickModeSettingYXPHZ)
	message:AddClick(yxphzObj.ToggleZhongZhuang.gameObject, this.OnClickModeSettingYXPHZ)

	yxphzObj.ToggleYouHuBiHu = optionTable:Find('yxphz_play/youHuBiHu')
end
function this.InitYJGHZObj()
	yjghzObj.ToggleWai5Kan5 = optionTable:Find('yjghz_mode42/5')
	yjghzObj.ToggleWai10Kan10 = optionTable:Find('yjghz_mode42/10')
	message:AddClick(yjghzObj.ToggleWai5Kan5.gameObject, this.OnClickModeSettingYJGHZ)
	message:AddClick(yjghzObj.ToggleWai10Kan10.gameObject, this.OnClickModeSettingYJGHZ)

	yjghzObj.ToggleBuKePiao = optionTable:Find('yjghz_play1/buKePiao')
	yjghzObj.ToggleJiuDuiBan = optionTable:Find('yjghz_play1/jiuDuiBan')
	yjghzObj.ToggleWuXiPing = optionTable:Find('yjghz_play1/wuXiPing')
	yjghzObj.ToggleDiaoDiaoShou50Xi = optionTable:Find('yjghz_play2/diaoDiaoShou50Xi')
	yjghzObj.ToggleXingXingXi2Fan = optionTable:Find('yjghz_play2/xingXingXi2Fan')
	yjghzObj.ToggleTianHu = optionTable:Find('yjghz_play2/tianHu')
	yjghzObj.ToggleDiHu = optionTable:Find('yjghz_play3/diHu')
	yjghzObj.ToggleHaiDiHu = optionTable:Find('yjghz_play3/haiDiHu')
end
function this.InitCZZPObj()
	czzpObj.ToggleQiHu9Xi1Tun = optionTable:Find('czzp_qiHuTun43/qiHu9Xi1Tun')
	czzpObj.ToggleQiHu9Xi3Tun = optionTable:Find('czzp_qiHuTun43/qiHu9Xi3Tun')
	message:AddClick(czzpObj.ToggleQiHu9Xi1Tun.gameObject, this.OnClickQiHuTun)
	message:AddClick(czzpObj.ToggleQiHu9Xi3Tun.gameObject, this.OnClickQiHuTun)

	czzpObj.ToggleQClassic0 = optionTable:Find('czzp_classic44/0')
	czzpObj.ToggleQClassic1 = optionTable:Find('czzp_classic44/1')
	czzpObj.ToggleQClassic2 = optionTable:Find('czzp_classic44/2')
	message:AddClick(czzpObj.ToggleQClassic0.gameObject, this.OnClickClassic)
	message:AddClick(czzpObj.ToggleQClassic1.gameObject, this.OnClickClassic)
	message:AddClick(czzpObj.ToggleQClassic2.gameObject, this.OnClickClassic)

	czzpObj.ToggleZiMoFan = optionTable:Find('czzp_play1/ziMoFan')
	message:AddClick(czzpObj.ToggleZiMoFan.gameObject, this.OnClickToggleCZZPPlay)
	czzpObj.ToggleYouHuBiHu = optionTable:Find('czzp_play1/youHuBiHu')
	message:AddClick(czzpObj.ToggleYouHuBiHu.gameObject, this.OnClickToggleCZZPPlay)
	czzpObj.ToggleFangPaoBiHu = optionTable:Find('czzp_play1/fangPaoBiHu')
	message:AddClick(czzpObj.ToggleFangPaoBiHu.gameObject, this.OnClickToggleCZZPPlay)
	czzpObj.ToggleDaXiaoHongHu = optionTable:Find('czzp_play2/daXiaoHongHu')
	message:AddClick(czzpObj.ToggleDaXiaoHongHu.gameObject, this.OnClickToggleCZZPPlay)
	czzpObj.TogglePlay15 = optionTable:Find('czzp_play2/play15')
	message:AddClick(czzpObj.TogglePlay15.gameObject, this.OnClickToggleCZZPPlay)
	czzpObj.MaoHuLabel = optionTable:Find('czzp_play2/maoHu/maoHuLabel')
	czzpObj.MaoHuLabelBtn = optionTable:Find('czzp_play2/maoHu/maoHuLabel/bgBtn')
	czzpObj.maoHuType = optionTable:Find('czzp_play2/maoHu/maoHuType')
	czzpObj.maoHuTypeMask = optionTable:Find('czzp_play2/maoHu/maoHuType/MaskBtn')
	czzpObj.maoHuTypeGrid = optionTable:Find('czzp_play2/maoHu/maoHuType/grid')
	message:AddClick(czzpObj.MaoHuLabelBtn.gameObject, function (go)
		AudioManager.Instance:PlayAudio('btn')
		czzpObj.maoHuType.gameObject:SetActive(not czzpObj.maoHuType.gameObject.activeSelf)
	end)
	message:AddClick(czzpObj.maoHuTypeMask.gameObject, function (go)
		AudioManager.Instance:PlayAudio('btn')
		czzpObj.maoHuType.gameObject:SetActive(false)
	end)
	for i = 0, czzpObj.maoHuTypeGrid.childCount - 1 do
		message:AddClick(czzpObj.maoHuTypeGrid:GetChild(i).gameObject, this.OnClickMaoHuType)
	end

	czzpObj.TogglePiao0 = optionTable:Find('czzp_piaoFen45/0')
	czzpObj.TogglePiao1 = optionTable:Find('czzp_piaoFen45/1')
	czzpObj.TogglePiao2 = optionTable:Find('czzp_piaoFen45/2')
	czzpObj.TogglePiao3 = optionTable:Find('czzp_piaoFen45/3')
	message:AddClick(czzpObj.TogglePiao0.gameObject, this.OnClickTogglePiao)
	message:AddClick(czzpObj.TogglePiao1.gameObject, this.OnClickTogglePiao)
	message:AddClick(czzpObj.TogglePiao2.gameObject, this.OnClickTogglePiao)
	message:AddClick(czzpObj.TogglePiao3.gameObject, this.OnClickTogglePiao)
end
function this.WhoShow(data)
	curSelectPlay = data
	local wanFa
	ButtonClose.gameObject:SetActive(true)
	print('是不是跟新：'..tostring(curSelectPlay.optionData.addPlay))
	if not curSelectPlay.optionData.addPlay and not curSelectPlay.optionData.addRule then
		local wanFa = json:decode(curSelectPlay.settings)
		copyWanfa = curSelectPlay.settings
		wanFaTitle:GetComponent('UILabel').text='当前规则：'..getWanFaText(wanFa,true,false, true)
		ButtonOK.gameObject:SetActive(panelClub.clubInfo.userType~=proxy_pb.GENERAL)
		
		phzData.roomType = wanFa.roomType
		phzData.payType = 3
		if wanFa.roomType == proxy_pb.SYBP then
			if wanFa.rounds == nil then
				phzData.rounds = 0
			else
				phzData.rounds = wanFa.rounds
			end
		else
			phzData.rounds = ((wanFa.rounds ~= 0) and wanFa.rounds or 6)
		end
		
		if wanFa.roomType ~= proxy_pb.XXGHZ then
			phzData.niao = wanFa.niao
			phzData.niaoValue = wanFa.niaoValue == nil and 10 or wanFa.niaoValue
		end
		phzData.choiceDouble= wanFa.choiceDouble
		phzData.doubleScore = wanFa.choiceDouble and wanFa.doubleScore or 10
		phzData.multiple = wanFa.choiceDouble and wanFa.multiple or 2
		if wanFa.resultScore ~= nil then
			phzData.isSettlementScore=wanFa.resultScore
			phzData.fewerValue=wanFa.resultLowerScore
			phzData.addValue=wanFa.resultAddScore
		end
		if wanFa.chou ~= nil then
			phzData.choupai = wanFa.chou
		else
			if phzData.roomType == proxy_pb.HYLHQ or phzData.roomType == proxy_pb.HYSHK or phzData.roomType == proxy_pb.LYZP then
				phzData.choupai = 0
			elseif phzData.roomType == proxy_pb.YXPHZ then
				phzData.choupai = 28
			else
				phzData.choupai = 20
			end
		end
		--print("囤数："..wanFa.tunXi)
		if wanFa.roomType == proxy_pb.SYBP then
			phzData.tianDiHu = wanFa.tianDiHu
			phzData.heiHongHu = wanFa.heiHongHu
			phzData.tunXi = wanFa.tunXi
			phzData.xingType = wanFa.fanXing
			phzData.heiHongDian = wanFa.heiHongDian
			phzData.size = wanFa.size
			phzData.maxHuXi = wanFa.maxHuXi == nil and 0 or wanFa.maxHuXi
			phzData.randomBanker = wanFa.randomBanker
			phzData.zeroToTop = wanFa.zeroToTop
		elseif wanFa.roomType == proxy_pb.SYZP then
			phzData.qiHuHuXi = wanFa.qiHuHuXi
			if wanFa.tunXi == 0 then
				phzData.tunXi = 3
			else
				phzData.tunXi = wanFa.tunXi
			end
			phzData.xingType = wanFa.fanXing
			phzData.tianDiHu = wanFa.tianDiHu
			phzData.heiHongHu = wanFa.heiHongHu
			phzData.size = wanFa.size
			if wanFa.ziMoAddHu == nil then
				phzData.ziMoAddHu = 0
			else
				phzData.ziMoAddHu = wanFa.ziMoAddHu
			end
			if wanFa.bottomScore ~= nil then
				phzData.bottomScore = wanFa.bottomScore
			else
				phzData.bottomScore = 1
			end
		elseif wanFa.roomType == proxy_pb.HHHGW then
			phzData.tianDiHu = wanFa.tianDiHu
			phzData.heiHongHu = wanFa.heiHongHu
			phzData.tunXi = wanFa.tunXi
			phzData.xingType = wanFa.fanXing
			phzData.canHuZiMo = true--wanFa.canHuZiMo
			phzData.size = wanFa.size
			if wanFa.bottomScore ~= nil then
				phzData.bottomScore = wanFa.bottomScore
			else
				phzData.bottomScore = 1
			end
			if wanFa.mode ~= nil then
				phzData.mode = wanFa.mode
			else
				phzData.mode = 0
			end
			if wanFa.canHuZiMo ~= nil then
				phzData.canHuZiMo = wanFa.canHuZiMo
			else
				phzData.canHuZiMo = false
			end
			if wanFa.ziMoFan ~= nil then
				phzData.ziMoFan = wanFa.ziMoFan
			else
				phzData.ziMoFan = 0
			end
			if wanFa.shiZhongBuLiang ~= nil then
				phzData.shiZhongBuLiang = wanFa.shiZhongBuLiang
			else
				phzData.shiZhongBuLiang = false
			end
			if wanFa.tianHu5Fan ~= nil then
				phzData.tianHu5Fan = wanFa.tianHu5Fan
			else
				phzData.tianHu5Fan = false
			end
			if wanFa.diHu4Fan ~= nil then
				phzData.diHu4Fan = wanFa.diHu4Fan
			else
				phzData.diHu4Fan = false
			end
			if wanFa.da18Fan5 ~= nil then
				phzData.da18Fan5 = wanFa.da18Fan5
			else
				phzData.da18Fan5 = false
			end
			if wanFa.shiLiuXiao ~= nil then
				phzData.shiLiuXiao = wanFa.shiLiuXiao
			else
				phzData.shiLiuXiao = false
			end
			if wanFa.maxHuXi ~= nil then
				phzData.maxHuXi = wanFa.maxHuXi
			else
				phzData.maxHuXi = 0
			end
			if wanFa.huangZhuangFen ~= nil then
				phzData.huangZhuangFen = wanFa.huangZhuangFen
			else
				phzData.huangZhuangFen = 0
			end
		elseif wanFa.roomType == proxy_pb.LDFPF then
			phzData.tianDiHu = wanFa.tianDiHu
			phzData.heiHongHu = wanFa.heiHongHu
			phzData.tunXi = wanFa.tunXi
			phzData.xingType = wanFa.fanXing
			phzData.maxHuXi = wanFa.maxHuXi
			phzData.size = wanFa.size
		elseif wanFa.roomType == proxy_pb.CSPHZ then
			phzData.tianDiHu = wanFa.tianDiHu
			phzData.heiHongHu = wanFa.heiHongHu
			phzData.tunXi = wanFa.tunXi
			phzData.xingType = wanFa.fanXing
			if wanFa.bottomScore ~= nil then
				phzData.bottomScore = wanFa.bottomScore
			else
				phzData.bottomScore = 1
			end
			if wanFa.maxHuXi ~= nil then
				phzData.maxHuXi = wanFa.maxHuXi
			else
				if wanFa.limitFan ~= nil and wanFa.limitFan then
					phzData.maxHuXi = 5
				else
					phzData.maxHuXi = 0
				end
			end
			if wanFa.zhaNiao ~= nil then
				phzData.zhaNiao = wanFa.zhaNiao
			else
				phzData.zhaNiao = 0
			end
			if wanFa.huangZhuangFen ~= nil then
				phzData.huangZhuangFen = wanFa.huangZhuangFen	
			else
				phzData.huangZhuangFen = 0	
			end
			phzData.ziMoFan = wanFa.ziMoFan
			phzData.size = wanFa.size
		elseif wanFa.roomType == proxy_pb.CDPHZ then
			phzData.tianDiHu = wanFa.tianDiHu
			phzData.heiHongHu = wanFa.heiHongHu
			phzData.tunXi = wanFa.tunXi
			phzData.xingType = wanFa.fanXing
			phzData.quanMingTang = wanFa.quanMingTang

			if wanFa.shuaHou == nil then
				phzData.shuaHou = false
			else
				phzData.shuaHou = wanFa.shuaHou
			end
			if wanFa.daTuanYuan == nil then
				phzData.daTuanYuan = false
			else
				phzData.daTuanYuan = wanFa.daTuanYuan
			end
			if wanFa.tingHu == nil then
				phzData.tingHu = false
			else
				phzData.tingHu = wanFa.tingHu
			end
			if wanFa.hangHangXi == nil then
				phzData.hangHangXi = false
			else
				phzData.hangHangXi = wanFa.hangHangXi
			end
			if wanFa.jiaHangHang == nil then
				phzData.jiaHangHang = false
			else
				phzData.jiaHangHang = wanFa.jiaHangHang
			end
			if wanFa.hong47 == nil then
				phzData.hong47 = false
			else
				phzData.hong47 = wanFa.hong47
			end
			if wanFa.huangFan == nil then
				phzData.huangFan = false
			else
				phzData.huangFan = wanFa.huangFan
			end	
			if wanFa.duiDuiHu == nil then
				phzData.duiDuiHu = false
			else
				phzData.duiDuiHu = wanFa.duiDuiHu
			end
	
			phzData.size = wanFa.size
			if wanFa.bottomScore ~= nil then
				phzData.bottomScore = wanFa.bottomScore
			else
				phzData.bottomScore = 1
			end
			if wanFa.maxHuXi ~= nil then
				phzData.maxHuXi = wanFa.maxHuXi
			else
				phzData.maxHuXi = 0
			end
			if wanFa.huangZhuangFen ~= nil then
				phzData.huangZhuangFen = wanFa.huangZhuangFen	
			else
				phzData.huangZhuangFen = 0	
			end
		elseif wanFa.roomType == proxy_pb.XXGHZ then
			phzData.size = wanFa.size
			phzData.tuo = wanFa.tuo
			phzData.qiHuHuXi = wanFa.qiHuHuXi
		elseif wanFa.roomType == proxy_pb.HYSHK then
			phzData.size = wanFa.size
			phzData.randomBanker = wanFa.randomBanker
			phzData.isBaseSocre2 = wanFa.bottom2Score
			phzData.yiWuShi = wanFa.yiWuShi
			phzData.isNoBomb = not wanFa.fangPao
			phzData.isCantPassHu = wanFa.haveHuMustHu
			phzData.isPiaoHu = wanFa.canPiaoHu
			phzData.isTianDiHaiHu = wanFa.tianDiHaiHu
			phzData.canMingWei = wanFa.canMingWei
			phzData.isXiaoHong3Fan = wanFa.xiaoHong3Fan
			phzData.fangpao = phzData.isNoBomb and 0 or wanFa.fangPaoMultiple
			phzData.xingTypeHYSHK = wanFa.xing
			phzData.singleRoundDouble = wanFa.singleRoundDouble
		elseif wanFa.roomType == proxy_pb.HYLHQ then
			phzData.size = wanFa.size
			phzData.randomBanker = wanFa.randomBanker
			phzData.qihuhuxu = wanFa.qiHuHuXi
			phzData.isBaseSocre2 = wanFa.bottom2Score
			phzData.yiWuShi = wanFa.yiWuShi
			phzData.isCantPassHu = wanFa.haveHuMustHu
			phzData.isHongHeiDian = wanFa.heiHongDian
			phzData.isTianDiHaiHu = wanFa.tianDiHaiHu
			phzData.canMingWei = wanFa.canMingWei
			phzData.isLiangPao = wanFa.liangZhangDianPao
			phzData.isYiHYiTun = wanFa.oneHuOneTun
			phzData.xingTypeHYLHQ = wanFa.xing
			phzData.singleRoundDouble = wanFa.singleRoundDouble
			if wanFa.play21 == nil then
				phzData.play21 = false
			else
				phzData.play21 = wanFa.play21
			end
		elseif wanFa.roomType == proxy_pb.LYZP then
			phzData.size = wanFa.size
			phzData.randomBanker = wanFa.randomBanker
			phzData.choiceHu = wanFa.choiceHu
			phzData.maoHu = wanFa.maoHu
			phzData.yiDianHong = wanFa.yiDianHong
			phzData.tiAddScore = wanFa.tiAddScore
		elseif wanFa.roomType == proxy_pb.HSPHZ then
			phzData.size = wanFa.size
			phzData.randomBanker = wanFa.randomBanker
			phzData.qiHuTun = wanFa.qiHuTun
			phzData.hongDuiHu = wanFa.hongDuiHu
			phzData.wuDuiHu = wanFa.wuDuiHu
			phzData.jiaHongDui = wanFa.jiaHongDui
			phzData.choiceBanker = wanFa.choiceBanker
			phzData.maxHuXi = wanFa.maxHuXi
			phzData.huangZhuangFen = wanFa.huangZhuangFen
		elseif wanFa.roomType == proxy_pb.CDDHD then
			phzData.size = wanFa.size
			phzData.randomBanker = wanFa.randomBanker
			phzData.qiHuTun = wanFa.qiHuTun
			phzData.hongDuiHu = wanFa.hongDuiHu
			phzData.jiaHongDui = wanFa.jiaHongDui
			phzData.maxHuXi = wanFa.maxHuXi
			phzData.huangZhuangFen = wanFa.huangZhuangFen
			if wanFa.tianHu == nil then
				phzData.tianHu = false
			else
				phzData.tianHu = wanFa.tianHu
			end
			if wanFa.diHu == nil then
				phzData.diHu = false
			else
				phzData.diHu = wanFa.diHu
			end
			if wanFa.tingHu == nil then
				phzData.tingHu = false
			else
				phzData.tingHu = wanFa.tingHu
			end
			if wanFa.haiDiHu == nil then
				phzData.haiDiHu = false
			else
				phzData.haiDiHu = wanFa.haiDiHu
			end
			if wanFa.huangFan == nil then
				phzData.huangFan = false
			else
				phzData.huangFan = wanFa.huangFan
			end	
		elseif wanFa.roomType == proxy_pb.NXPHZ then
			phzData.size = wanFa.size
			phzData.randomBanker = wanFa.randomBanker
			phzData.qiHuHuXi = wanFa.qiHuHuXi
			phzData.bottomScore = wanFa.bottomScore
			phzData.ziMoFan = wanFa.ziMoFan
			phzData.shiLiuXiao = wanFa.shiLiuXiao
			phzData.haiDiHu = wanFa.haiDiHu
			phzData.shuaHou = wanFa.shuaHou
			phzData.add1When27 = wanFa.add1When27
			phzData.addHongXiaoDa = wanFa.addHongXiaoDa
			phzData.ziMoAddTun = wanFa.ziMoAddTun
			phzData.zhaNiao = wanFa.zhaNiao
			phzData.huangZhuangFen = wanFa.huangZhuangFen
			phzData.maxHuXi = wanFa.maxHuXi
		elseif wanFa.roomType == proxy_pb.XTPHZ then
			phzData.size = wanFa.size
			phzData.randomBanker = wanFa.randomBanker
			phzData.qiHuHuXi = wanFa.qiHuHuXi
			phzData.calculationTunMode = wanFa.calculationTunMode
			phzData.bottomScore = wanFa.bottomScore
			phzData.yiWuShi = wanFa.yiWuShi
			phzData.shiZhongBuLiang = wanFa.shiZhongBuLiang
			phzData.hu30FangBei = wanFa.hu30FangBei
			phzData.tianDiHu = wanFa.tianDiHu
			phzData.pengPengHu = wanFa.pengPengHu
			phzData.daXiaoZiHu = wanFa.daXiaoZiHu
			phzData.yiDianHong = wanFa.yiDianHong
			phzData.heiHongHu = wanFa.heiHongHu
			if phzData.heiHongHu then
				phzData.hong13 = wanFa.hong13
			else
				phzData.hong13 = false
			end
			phzData.canHuZiMo = wanFa.canHuZiMo
			phzData.canMingWei = wanFa.canMingWei
			if not wanFa.canMingWei then
				phzData.chouWeiLiang = wanFa.chouWeiLiang
			else
				phzData.chouWeiLiang = false
			end
			phzData.calculationFanMode = wanFa.calculationFanMode  
			phzData.maxHuXi = wanFa.maxHuXi
			phzData.huangZhuangFen = wanFa.huangZhuangFen
		elseif wanFa.roomType == proxy_pb.YXPHZ then
			phzData.size = wanFa.size
			phzData.randomBanker = wanFa.randomBanker
			phzData.mode = wanFa.mode
			phzData.haveHuMustHu = wanFa.haveHuMustHu
			phzData.huangZhuangFen = wanFa.huangZhuangFen
		elseif wanFa.roomType == proxy_pb.YJGHZ then
			phzData.size = wanFa.size
			phzData.randomBanker = wanFa.randomBanker
			phzData.mode = wanFa.mode
			phzData.piao = wanFa.piao
			phzData.jiuDuiBan = wanFa.jiuDuiBan
			phzData.wuXiPing = wanFa.wuXiPing
			phzData.diaoDiaoShou = wanFa.diaoDiaoShou
			phzData.hangHangXi2Fan = wanFa.hangHangXi2Fan
			phzData.tianHu = wanFa.tianHu
			phzData.diHu = wanFa.diHu
			phzData.haiDiHu = wanFa.haiDiHu
			phzData.maxHuXi = wanFa.maxHuXi
			phzData.huangZhuangFen = wanFa.huangZhuangFen
			phzData.huangKeepBanker = wanFa.huangKeepBanker
		elseif wanFa.roomType == proxy_pb.CZZP then
			phzData.size = wanFa.size
			phzData.randomBanker = wanFa.randomBanker
			phzData.qiHuHuXi = wanFa.qiHuHuXi
			phzData.calculationTunMode = wanFa.calculationTunMode
			phzData.calculationFanMode = wanFa.calculationFanMode
			phzData.classic = wanFa.classic
			phzData.ziMoFan = wanFa.ziMoFan
			phzData.choiceHu = wanFa.choiceHu
			phzData.daXiaoZiHu = wanFa.daXiaoZiHu
			phzData.play21 = wanFa.play21
			phzData.maoHuHuXi = wanFa.maoHuHuXi
			phzData.huangZhuangFen = wanFa.huangZhuangFen
			phzData.huangKeepBanker = wanFa.huangKeepBanker
			phzData.piao = wanFa.piao
		elseif wanFa.roomType == proxy_pb.AHPHZ then 
			phzData.size = wanFa.size
			phzData.rounds = wanFa.rounds 
			if wanFa.bottomScore ~= nil then
				phzData.bottomScore = wanFa.bottomScore
			else
				phzData.bottomScore = 1
			end
			phzData.randomBanker = wanFa.randomBanker   
			phzData.huangZhuangFen = wanFa.huangZhuangFen
			phzData.huangKeepBanker = wanFa.huangKeepBanker 
			phzData.tunXi = wanFa.tunXi 
			phzData.paPo = wanFa.paPo
			phzData.heiHongHu = wanFa.heiHongHu 
			phzData.ziMoAddTun = wanFa.ziMoAddTun
			phzData.tianHu = wanFa.tianhu
			phzData.diHu = wanFa.dihu
			phzData.haiDiHu = wanFa.haiDiHu 
		end
		phzData.openIp = wanFa.openIp
		phzData.openGps = wanFa.openGps
		phzData.trusteeship = wanFa.trusteeship
		phzData.trusteeshipDissolve = wanFa.trusteeshipDissolve
		phzData.trusteeshipRound = wanFa.trusteeshipRound == nil and 0 or wanFa.trusteeshipRound
	else
		phzData.roomType = data.roomType
		wanFaTitle:GetComponent('UILabel').text ="当前玩法："..data.name
		if phzData.roomType == proxy_pb.SYBP then
			phzData.rounds = 0
		elseif phzData.roomType == proxy_pb.YXPHZ or phzData.roomType == proxy_pb.YJGHZ or phzData.roomType == proxy_pb.CZZP or phzData.roomType == proxy_pb.AHPHZ then
				phzData.rounds = 8
		else
			phzData.rounds = 6
		end
		phzData.size = 2
		phzData.payType = 3
		phzData.randomBanker = false
		if phzData.roomType == proxy_pb.HYLHQ or phzData.roomType == proxy_pb.HYSHK or phzData.roomType == proxy_pb.LYZP then
			phzData.choupai = 0
		elseif phzData.roomType == proxy_pb.YXPHZ then
			phzData.choupai = 28
		else
			phzData.choupai = 20
		end
		phzData.trusteeshipDissolve = true
		phzData.trusteeshipRound = 0
		phzData.trusteeship = 0
		if phzData.roomType == proxy_pb.NXPHZ or phzData.roomType == proxy_pb.AHPHZ then
			phzData.qiHuHuXi = 15
		elseif phzData.roomType == proxy_pb.XXGHZ then
			phzData.qiHuHuXi = 6	
		elseif phzData.roomType == proxy_pb.SYZP or phzData.roomType == proxy_pb.XTPHZ then
			phzData.qiHuHuXi = 10
		elseif phzData.roomType == proxy_pb.CZZP then
			phzData.qiHuHuXi = 9
		end
		if phzData.roomType == proxy_pb.AHPHZ then 
			phzData.tunXi = 3
		else	
			phzData.tunXi = 5
		end
		if phzData.roomType == proxy_pb.LDFPF or phzData.roomType == proxy_pb.YJGHZ then
			phzData.maxHuXi = 200
		else
			phzData.maxHuXi = 0
		end
		phzData.xingType = true
		if phzData.roomType == proxy_pb.XTPHZ then
			phzData.tianDiHu = false
		else
			phzData.tianDiHu = true
		end
		if phzData.roomType == proxy_pb.AHPHZ then
			phzData.heiHongHu = true
		else
			phzData.heiHongHu = false
		end
		if phzData.roomType == proxy_pb.XTPHZ or phzData.roomType == proxy_pb.HHHGW then
			phzData.canHuZiMo = false
		else
			phzData.canHuZiMo = true
		end
		phzData.quanMingTang = true
		phzData.ziMoFan = 0
		phzData.heiHongDian = false
		phzData.niao = false
		phzData.niaoValue = 10
		phzData.choiceDouble = false
		phzData.doubleScore = 10
		phzData.multiple = 2
		phzData.singleRoundDouble = false
		phzData.tuo = true
		phzData.fangpao = 1
		phzData.isBaseSocre2 = true
		phzData.yiWuShi = false
		phzData.isNoBomb = false
		phzData.isCantPassHu = false
		phzData.isPiaoHu = false
		phzData.isTianDiHaiHu = false
		phzData.canMingWei = true
		phzData.isXiaoHong3Fan = false
		phzData.xingTypeHYSHK = 2
		phzData.isHongHeiDian = false
		phzData.isLiangPao = false
		phzData.isYiHYiTun = false
		phzData.xingTypeHYLHQ = 2
		phzData.qihuhuxu = 6
		phzData.isSettlementScore = false
		phzData.fewerValue = 10
		phzData.addValue = 10
		phzData.choiceHu = 0
		phzData.maoHu = true
		if phzData.roomType == proxy_pb.XTPHZ then
			phzData.yiDianHong = false
		else
			phzData.yiDianHong = true
		end
		phzData.tiAddScore = 2
		phzData.openIp = false
		phzData.openGps = false
		
		phzData.qiHuTun = 1
		phzData.hongDuiHu = false
		phzData.wuDuiHu = false
		phzData.jiaHongDui = false
		phzData.choiceBanker = 0
		phzData.bottomScore = 1
		phzData.shiLiuXiao = false
		if phzData.roomType == proxy_pb.YJGHZ or phzData.roomType == proxy_pb.AHPHZ then
			phzData.haiDiHu = false
		else
			phzData.haiDiHu = true
		end
		
		phzData.shuaHou = false
		phzData.add1When27 = true
		phzData.addHongXiaoDa = true
		phzData.ziMoAddTun = 1
		phzData.zhaNiao = 0
		phzData.huangZhuangFen = 0
		phzData.calculationTunMode = 0
		phzData.shiZhongBuLiang = false
		phzData.hu30FangBei = false
		phzData.pengPengHu = false
		phzData.daXiaoZiHu = false
		phzData.hong13 = false
		phzData.chouWeiLiang = false
		if phzData.roomType == proxy_pb.CZZP then
			phzData.calculationFanMode = 5
			phzData.piao = 0
		else
			phzData.calculationFanMode = 0
			phzData.piao = 1
		end
		phzData.mode = 0
		phzData.da18Fan5 = false
		phzData.tianHu5Fan = false
		phzData.diHu4Fan = false
		if phzData.roomType == proxy_pb.CZZP then
			phzData.play21 = true
		else
			phzData.play21 = false	
		end
		if phzData.roomType == proxy_pb.AHPHZ then
			phzData.ziMoAddHu = 1
		else
			phzData.ziMoAddHu = 0
		end
		phzData.jiuDuiBan = false
		phzData.wuXiPing = false
		phzData.diaoDiaoShou = false
		phzData.hangHangXi2Fan = false
		phzData.tianHu = false
		phzData.diHu = false
		phzData.huangKeepBanker = false
		phzData.classic = 2
		phzData.maoHuHuXi = 0 

		phzData.daTuanYuan = false
		phzData.tingHu = false
		phzData.hangHangXi = false
		phzData.jiaHangHang = false
		phzData.hong47 = false
		phzData.huangFan = false
		phzData.duiDuiHu = false
	end
	this.Refresh()
	optionTable.parent:GetComponent('UIScrollView'):ResetPosition()
end

function this.ShowRuleInfo(go)
	PanelManager.Instance:ShowWindow('panelHelp',phzData.roomType)
end
function this.Update() 
end
function this.OnEnable()	
end
function this.setToggleLabel(item,icon)
	item:Find('Label1'):GetComponent('UILabel').text = icon
	item:Find('highlight'):GetChild(0):GetComponent('UILabel').text = icon
	item:Find('highlight'):GetChild(1):GetComponent('UILabel').text = icon
end
function this.Refresh()
	for i=0,optionTable.childCount-1 do
		local item = optionTable:GetChild(i)
		item.gameObject:SetActive(false)
	end
	phzObj.ToggleFengDingScore0.gameObject:SetActive(false)
	phzObj.ToggleFengDingScore5.gameObject:SetActive(false)
	phzObj.ToggleFengDingScore10.gameObject:SetActive(false)
	phzObj.ToggleFengDingScore100.gameObject:SetActive(false)
	phzObj.ToggleFengDingScore150.gameObject:SetActive(false)
	phzObj.ToggleFengDingScore200.gameObject:SetActive(false)
	phzObj.ToggleFengDingScore300.gameObject:SetActive(false)
	phzObj.ToggleFengDingScore400.gameObject:SetActive(false)
	
	if phzData.roomType == proxy_pb.SYZP then
		this.InitSYZP()
	elseif phzData.roomType == proxy_pb.SYBP then
		this.InitSYBP()
	elseif phzData.roomType == proxy_pb.AHPHZ then
		this.InitAHPHZ()
	elseif phzData.roomType == proxy_pb.HHHGW then
		this.InitHHHGW()
	elseif phzData.roomType == proxy_pb.LDFPF then
		this.InitLDFPF()
	elseif phzData.roomType == proxy_pb.CSPHZ then
		this.InitCSPHZ()
	elseif phzData.roomType == proxy_pb.CDPHZ then
		this.InitCDPHZ()
	elseif phzData.roomType == proxy_pb.XXGHZ then
		this.InitXXGHZ()
	elseif phzData.roomType == proxy_pb.HYSHK then
		this.InitHYSHK()
	elseif phzData.roomType == proxy_pb.HYLHQ then
		this.InitHYLHQ()
	elseif phzData.roomType == proxy_pb.LYZP then
		this.InitLYZP()
	elseif phzData.roomType == proxy_pb.HSPHZ then
		this.InitHSPHZ()
	elseif phzData.roomType == proxy_pb.CDDHD then
		this.InitCDDHD()
	elseif phzData.roomType == proxy_pb.NXPHZ then
		this.InitNXPHZ()
	elseif phzData.roomType == proxy_pb.XTPHZ then
		this.InitXTPHZ()
	elseif phzData.roomType == proxy_pb.YXPHZ then
		this.InitYXPHZ()
	elseif phzData.roomType == proxy_pb.YJGHZ then
		this.InitYJGHZ()
	elseif phzData.roomType == proxy_pb.CZZP then
		this.InitCZZP()
	else
		print('unkown type')
	end
	
	if phzData.roomType ~= proxy_pb.SYBP 
	and phzData.roomType ~= proxy_pb.XXGHZ  
	and phzData.roomType ~= proxy_pb.AHPHZ
	and phzData.roomType ~= proxy_pb.LDFPF then
		phzObj.ToggleRound6.parent.parent.gameObject:SetActive(true)
	end
	if phzData.roomType == proxy_pb.AHPHZ then
		phzObj.ToggleRound8.parent.parent.gameObject:SetActive(true)
	end
	phzObj.ToggleRound1.gameObject:SetActive(phzData.roomType == proxy_pb.SYZP or phzData.roomType == proxy_pb.AHPHZ)
	phzObj.ToggleRound1:GetComponent('UIToggle'):Set(1 == phzData.rounds)
	phzObj.ToggleRound6:GetComponent('UIToggle'):Set(6 == phzData.rounds)
	phzObj.ToggleRound8:GetComponent('UIToggle'):Set(8 == phzData.rounds)
	phzObj.ToggleRound10:GetComponent('UIToggle'):Set(10 == phzData.rounds)
	phzObj.ToggleRound16:GetComponent('UIToggle'):Set(16 == phzData.rounds)
	phzObj.ToggleRound1.parent:GetComponent('UIGrid'):Reposition()

	if phzData.roomType == proxy_pb.HYLHQ 
	or phzData.roomType == proxy_pb.YXPHZ 
	or phzData.roomType == proxy_pb.CZZP then
		phzObj.TogglePlayer4.gameObject:SetActive(true)
	else
		phzObj.TogglePlayer4.gameObject:SetActive(false)
	end
	phzObj.TogglePlayer3.parent.gameObject:SetActive(true)
	phzObj.TogglePlayer3:GetComponent('UIToggle'):Set(3 == phzData.size)
	phzObj.TogglePlayer4:GetComponent('UIToggle'):Set(4 == phzData.size)
	phzObj.TogglePlayer2:GetComponent('UIToggle'):Set(2 == phzData.size)

	phzObj.ToggleBankerAuto.parent.gameObject:SetActive(true)
	phzObj.ToggleBankerAuto:GetComponent('UIToggle'):Set(phzData.randomBanker)
	phzObj.ToggleBankerFrist:GetComponent('UIToggle'):Set(not phzData.randomBanker)

	if phzData.roomType == proxy_pb.HYLHQ or phzData.roomType == proxy_pb.HYSHK then
		phzObj.ToggleOneRoundDouble.parent.gameObject:SetActive(phzData.size==2 and phzData.choiceDouble)
		phzObj.ToggleOneRoundDouble:GetComponent('UIToggle'):Set(phzData.singleRoundDouble)
		phzObj.ToggleAllRoundDouble:GetComponent('UIToggle'):Set(not phzData.singleRoundDouble)
	end

	if phzData.roomType == proxy_pb.YJGHZ or phzData.roomType == proxy_pb.CZZP or phzData.roomType == proxy_pb.AHPHZ then
		phzObj.continueBanker.gameObject:SetActive(true)	
	else
		phzObj.continueBanker.gameObject:SetActive(false)
	end
	
	phzObj.ToggleNoChouPai.parent.parent.gameObject:SetActive(phzData.size==2)
	phzObj.ToggleChouPai10.gameObject:SetActive(phzData.roomType ~= proxy_pb.YXPHZ)
	phzObj.ToggleChouPai14.gameObject:SetActive(phzData.roomType == proxy_pb.YXPHZ)
	phzObj.ToggleChouPai20.gameObject:SetActive(phzData.roomType ~= proxy_pb.YXPHZ)
	phzObj.ToggleChouPai28.gameObject:SetActive(phzData.roomType == proxy_pb.YXPHZ)
	phzObj.ToggleNoChouPai:GetComponent('UIToggle'):Set(0 == phzData.choupai)
	phzObj.ToggleChouPai10:GetComponent('UIToggle'):Set(10 == phzData.choupai)
	phzObj.ToggleChouPai14:GetComponent('UIToggle'):Set(14 == phzData.choupai)
	phzObj.ToggleChouPai20:GetComponent('UIToggle'):Set(20 == phzData.choupai)
	phzObj.ToggleChouPai28:GetComponent('UIToggle'):Set(28 == phzData.choupai)
	phzObj.ToggleNoChouPai.parent:GetComponent('UIGrid'):Reposition()

	if phzData.roomType ~= proxy_pb.XXGHZ then
		phzObj.ToggleOnNiao.parent.gameObject:SetActive(true)
		phzObj.ToggleOnNiao:GetComponent('UIToggle'):Set(phzData.niao)
		phzObj.ToggleOffNiao:GetComponent('UIToggle'):Set(not phzData.niao)
		phzObj.NiaoValueText.parent.gameObject:SetActive(phzData.niao)
		phzObj.NiaoValueText:GetComponent('UILabel').text = phzData.niaoValue.."分"
	end

	phzObj.ToggleChoiceDouble.parent.gameObject:SetActive(phzData.size==2)
	phzObj.ToggleMultiple2.parent.gameObject:SetActive(phzData.size==2 and phzData.choiceDouble)
	phzObj.ToggleMultiple2:GetComponent('UIToggle'):Set(phzData.multiple == 2)
	phzObj.ToggleMultiple3:GetComponent('UIToggle'):Set(phzData.multiple == 3)
	phzObj.ToggleMultiple4:GetComponent('UIToggle'):Set(phzData.multiple == 4)
	phzObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(phzData.choiceDouble)
	phzObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not phzData.choiceDouble)
	phzObj.DoubleScoreText.parent.gameObject:SetActive(phzData.choiceDouble)
	if phzData.doubleScore == 0 then
		phzObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		phzObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..phzData.doubleScore..'分'
	end

	phzObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(phzData.size==2)
	phzObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(phzData.isSettlementScore)
	phzObj.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	phzObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = phzData.fewerValue
	phzObj.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	phzObj.ToggleAddScoreTxt:GetComponent('UILabel').text = phzData.addValue
	
	phzObj.ToggleNoDelegate.parent.gameObject:SetActive(true)
	phzObj.ToggleNoDelegate:GetComponent('UIToggle'):Set(phzData.trusteeship == 0)
	phzObj.ToggleDelegate1:GetComponent('UIToggle'):Set(phzData.trusteeship == 60)
	phzObj.ToggleDelegate2:GetComponent('UIToggle'):Set(phzData.trusteeship == 120)
	phzObj.ToggleDelegate3:GetComponent('UIToggle'):Set(phzData.trusteeship == 180)
	phzObj.ToggleDelegate5.parent.gameObject:SetActive(true)
	phzObj.ToggleDelegate5:GetComponent('UIToggle'):Set(phzData.trusteeship == 300)

	phzObj.ToggleDelegateThisRound.parent.gameObject:SetActive(phzData.trusteeship ~= 0)
	phzObj.ToggleDelegateThisRound:GetComponent('UIToggle'):Set(phzData.trusteeshipDissolve)
	phzObj.ToggleDelegateFullRound:GetComponent('UIToggle'):Set(not phzData.trusteeshipDissolve and phzData.trusteeshipRound == 0)
	phzObj.ToggleDelegateThreeRound:GetComponent("UIToggle"):Set(phzData.trusteeshipRound == 3)
	
	phzObj.ToggleIPcheck.parent.gameObject:SetActive(phzData.size > 2 and CONST.IPcheckOn)
	phzObj.ToggleIPcheck:GetComponent('UIToggle'):Set(phzData.openIp)
	phzObj.ToggleGPScheck:GetComponent('UIToggle'):Set(phzData.openGps)	

	payLabel:GetComponent("UILabel").text = GetPayMun(phzData.roomType,phzData.rounds,phzData.size,nil)
	optionTable:GetComponent('UIGrid'):Reposition()
end
function this.InitSYBP()
	sybpObj.ToggleBpHongDian.parent.gameObject:SetActive(true)
	sybpObj.ToggleBpHongDian:GetComponent('UIToggle'):Set(phzData.heiHongDian == true)
	sybpObj.ToggleBpHong:GetComponent('UIToggle'):Set(phzData.heiHongHu == true)

	if (phzData.heiHongHu == false) and (phzData.heiHongDian == false) then
		sybpObj.ToggleBpNone:GetComponent('UIToggle'):Set(true)
	end

	phzObj.ToggleFengDingScore0.parent.parent.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore0.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore150.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore200.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore300.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore0:GetComponent('UIToggle'):Set(phzData.maxHuXi == 0)
	phzObj.ToggleFengDingScore150:GetComponent('UIToggle'):Set(phzData.maxHuXi == 150)
	phzObj.ToggleFengDingScore200:GetComponent('UIToggle'):Set(phzData.maxHuXi == 200)
	phzObj.ToggleFengDingScore300:GetComponent('UIToggle'):Set(phzData.maxHuXi == 300)
	phzObj.ToggleFengDingScore150:Find('Label'):GetComponent("UILabel").text = '150息'
	phzObj.ToggleFengDingScore200:Find('Label'):GetComponent("UILabel").text = '200息'
	phzObj.ToggleFengDingScore300:Find('Label'):GetComponent("UILabel").text = '300息'
	phzObj.ToggleFengDingScore0.parent:GetComponent('UIGrid'):Reposition()

	sybpObj.ToggleSYBPZeroToTop.parent.gameObject:SetActive(true)
	sybpObj.ToggleSYBPZeroToTop:GetComponent('UIToggle'):Set(phzData.zeroToTop)
	sybpObj.Toggle1RoundEnd:GetComponent('UIToggle'):Set(phzData.rounds == 1)
end
function this.InitSYZP()
	phzObj.ToggleHuNum3.gameObject:SetActive(phzData.roomType ~= proxy_pb.SYZP)
	phzObj.ToggleHuNum6.gameObject:SetActive(phzData.roomType ~= proxy_pb.SYZP)
	phzObj.ToggleHuNum9.gameObject:SetActive(phzData.roomType ~= proxy_pb.SYZP)
	phzObj.ToggleHuNum10.gameObject:SetActive(phzData.roomType == proxy_pb.SYZP)
	phzObj.ToggleHuNum15.gameObject:SetActive(phzData.roomType == proxy_pb.SYZP)
	phzObj.ToggleHuNum10.parent.parent.gameObject:SetActive(true)
	phzObj.ToggleHuNum10:GetComponent('UIToggle'):Set(10 == phzData.qiHuHuXi)
	phzObj.ToggleHuNum15:GetComponent('UIToggle'):Set(15 == phzData.qiHuHuXi)
	phzObj.ToggleHuNum10.parent:GetComponent('UIGrid'):Reposition()

	syzpObj.ToggleFan.parent.gameObject:SetActive(4 == phzData.size)
	syzpObj.ToggleTian.parent.gameObject:SetActive(true)

	syzpObj.ToggleHuStep5.parent.gameObject:SetActive(true)
	syzpObj.ToggleHuStep5:GetComponent('UIToggle'):Set(5 == phzData.tunXi)
	syzpObj.ToggleHuStep3:GetComponent('UIToggle'):Set(3 == phzData.tunXi)
	syzpObj.ToggleHuStep1:GetComponent('UIToggle'):Set(1 == phzData.tunXi)
	
	syzpObj.ToggleFan:GetComponent('UIToggle'):Set(phzData.xingType)
	syzpObj.ToggleGen:GetComponent('UIToggle'):Set(not phzData.xingType)
	
	syzpObj.ToggleTian:GetComponent('UIToggle'):Set(phzData.tianDiHu)
	syzpObj.ToggleHong:GetComponent('UIToggle'):Set(phzData.heiHongHu)
	syzpObj.ToggleZiMo10Hu:GetComponent('UIToggle'):Set(phzData.ziMoAddHu == 10)
	
	phzObj.DiFenTunValue.parent.parent.gameObject:SetActive(true)
	phzObj.DiFenTunValue:GetComponent("UILabel").text = phzData.bottomScore..'分'
end 
function this.InitAHPHZ() 
	ahphzObj.ToggleHuStep3.parent.gameObject:SetActive(true) 
	ahphzObj.ToggleHuStep3:GetComponent('UIToggle'):Set(3 == phzData.tunXi)
	ahphzObj.ToggleHuStep1:GetComponent('UIToggle'):Set(1 == phzData.tunXi)

	ahphzObj.TogglePapo.parent.gameObject:SetActive(true)
	ahphzObj.ToggleHaiDi.parent.gameObject:SetActive(true)
	ahphzObj.TogglePapo:GetComponent('UIToggle'):Set(phzData.paPo) 
	ahphzObj.ToggleHong:GetComponent('UIToggle'):Set(phzData.heiHongHu) 
	ahphzObj.ToggleZiMoAdd1Tun:GetComponent('UIToggle'):Set(phzData.ziMoAddTun == 1) 
	ahphzObj.ToggleTian:GetComponent('UIToggle'):Set(phzData.tianhu) 
	ahphzObj.ToggleDi:GetComponent('UIToggle'):Set(phzData.dihu) 
	ahphzObj.ToggleHaiDi:GetComponent('UIToggle'):Set(phzData.haiDiHu)
	
	phzObj.DiFenTunValue.parent.parent.gameObject:SetActive(true)
	phzObj.DiFenTunValue:GetComponent("UILabel").text = phzData.bottomScore..'分'
	
	phzObj.HuangZhuangKouFenValue.parent.parent.gameObject:SetActive(true)
	phzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = phzData.huangZhuangFen == 0 and '不扣分' or '扣'..phzData.huangZhuangFen..'分'
	phzObj.continueBanker:GetComponent('UIToggle'):Set(phzData.huangKeepBanker)
end
function this.InitXXGHZ()
	xxghzObj.TogglePlayTuo.parent.gameObject:SetActive(true)
	xxghzObj.TogglePlayTuo:GetComponent('UIToggle'):Set(phzData.tuo)
	xxghzObj.ToggleNotTuo:GetComponent('UIToggle'):Set(not phzData.tuo)

	phzObj.ToggleHuNum3.gameObject:SetActive(phzData.roomType ~= proxy_pb.XXGHZ)
	phzObj.ToggleHuNum6.gameObject:SetActive(phzData.roomType == proxy_pb.XXGHZ)
	phzObj.ToggleHuNum9.gameObject:SetActive(phzData.roomType ~= proxy_pb.XXGHZ)
	phzObj.ToggleHuNum10.gameObject:SetActive(phzData.roomType == proxy_pb.XXGHZ)
	phzObj.ToggleHuNum15.gameObject:SetActive(phzData.roomType == proxy_pb.XXGHZ)
	phzObj.ToggleHuNum6.parent.parent.gameObject:SetActive(true)
	phzObj.ToggleHuNum6:GetComponent('UIToggle'):Set(6 == phzData.qiHuHuXi)
	phzObj.ToggleHuNum10:GetComponent('UIToggle'):Set(10 == phzData.qiHuHuXi)
	phzObj.ToggleHuNum15:GetComponent('UIToggle'):Set(15 == phzData.qiHuHuXi)
	phzObj.ToggleHuNum6.parent:GetComponent('UIGrid'):Reposition()
end
function this.InitCDPHZ()
	cdphzObj.Togglehhd.parent.gameObject:SetActive(true)
	cdphzObj.Toggleqmt:GetComponent('UIToggle'):Set(phzData.quanMingTang)
	cdphzObj.Togglehhd:GetComponent('UIToggle'):Set(not phzData.quanMingTang)

	cdphzObj.ToggleShuaHou.parent.gameObject:SetActive(phzData.quanMingTang)
	cdphzObj.ToggleHangHangXi.parent.gameObject:SetActive(phzData.quanMingTang)
	cdphzObj.ToggleHuangFan.parent.gameObject:SetActive(phzData.quanMingTang)
	cdphzObj.ToggleDuiDuiHu.parent.gameObject:SetActive(not phzData.quanMingTang)

	cdphzObj.ToggleShuaHou:GetComponent('UIToggle'):Set(phzData.shuaHou)
	cdphzObj.ToggleDaTuanYuan:GetComponent('UIToggle'):Set(phzData.daTuanYuan)
	cdphzObj.ToggleTingHu:GetComponent('UIToggle'):Set(phzData.tingHu)
	cdphzObj.ToggleHangHangXi:GetComponent('UIToggle'):Set(phzData.hangHangXi)
	--cdphzObj.ToggleJiaHangHang:GetComponent('UIToggle'):Set(phzData.jiaHangHang)
	cdphzObj.ToggleHong47:GetComponent('UIToggle'):Set(phzData.hong47)
	cdphzObj.ToggleHuangFan:GetComponent('UIToggle'):Set(phzData.huangFan)
	cdphzObj.ToggleDuiDuiHu:GetComponent('UIToggle'):Set(phzData.duiDuiHu)

	phzObj.HuangZhuangKouFenValue.parent.parent.gameObject:SetActive(true)
	phzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = phzData.huangZhuangFen == 0 and '不扣分' or '扣'..phzData.huangZhuangFen..'分'

	phzObj.FengDingValue.parent.parent.gameObject:SetActive(true)
	phzObj.FengDingValue:GetComponent("UILabel").text = phzData.maxHuXi == 0 and '不封顶' or phzData.maxHuXi..'分'

	phzObj.DiFenTunValue.parent.parent.gameObject:SetActive(true)
	phzObj.DiFenTunValue:GetComponent("UILabel").text = phzData.bottomScore..'分'
end
function this.InitCSPHZ()
	csphzObj.ToggleZiMoFan0.parent.gameObject:SetActive(true)
	csphzObj.ToggleZiMoFan0:GetComponent('UIToggle'):Set(0 == phzData.ziMoFan)
	csphzObj.ToggleZiMoFan1:GetComponent('UIToggle'):Set(1 == phzData.ziMoFan)
	csphzObj.ToggleZiMoFan2:GetComponent('UIToggle'):Set(2 == phzData.ziMoFan)

	phzObj.ZhaNiaoValue.parent.parent.gameObject:SetActive(true)
	phzObj.ZhaNiaoValue:GetComponent("UILabel").text = phzData.zhaNiao == 0 and '不扎鸟' or (phzData.zhaNiao..'分')

	phzObj.ToggleFengDingScore0.parent.parent.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore0.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore5.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore10.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore0:GetComponent('UIToggle'):Set(phzData.maxHuXi == 0)
	phzObj.ToggleFengDingScore5:GetComponent('UIToggle'):Set(phzData.maxHuXi == 5)
	phzObj.ToggleFengDingScore10:GetComponent('UIToggle'):Set(phzData.maxHuXi == 10)

	phzObj.HuangZhuangKouFenValue.parent.parent.gameObject:SetActive(true)
	phzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = phzData.huangZhuangFen == 0 and '不扣分' or '扣'..phzData.huangZhuangFen..'分'

	phzObj.DiFenTunValue.parent.parent.gameObject:SetActive(true)
	phzObj.DiFenTunValue:GetComponent("UILabel").text = phzData.bottomScore..'分'
end
function this.InitHHHGW()
	phzObj.DiFenTunValue.parent.parent.gameObject:SetActive(true)
	phzObj.DiFenTunValue:GetComponent("UILabel").text = phzData.bottomScore..'分'

	phzObj.ToggleFengDingScore0.parent.parent.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore0.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore5.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore10.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore0:GetComponent('UIToggle'):Set(phzData.maxHuXi == 0)
	phzObj.ToggleFengDingScore5:GetComponent('UIToggle'):Set(phzData.maxHuXi == 5)
	phzObj.ToggleFengDingScore10:GetComponent('UIToggle'):Set(phzData.maxHuXi == 10)

	phzObj.HuangZhuangKouFenValue.parent.parent.gameObject:SetActive(true)
	phzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = phzData.huangZhuangFen == 0 and '不扣分' or '扣'..phzData.huangZhuangFen..'分'

	hhhgwObj.ToggleOldMode.parent.gameObject:SetActive(true)
	hhhgwObj.ToggleOldMode:GetComponent('UIToggle'):Set(phzData.mode == 0)
	hhhgwObj.Toggle468Mode:GetComponent('UIToggle'):Set(phzData.mode == 1)

	hhhgwObj.ToggleZiMoHu15.parent.gameObject:SetActive(true)
	hhhgwObj.ToggleZiMoHu15:GetComponent('UIToggle'):Set(phzData.canHuZiMo)
	hhhgwObj.ToggleZiMoFan2:GetComponent('UIToggle'):Set(phzData.ziMoFan == 2)
	hhhgwObj.ToggleLiangPaiKeHu21:GetComponent('UIToggle'):Set(phzData.shiZhongBuLiang)
	hhhgwObj.ToggleTianHuFan5.parent.gameObject:SetActive(phzData.mode == 0)
	hhhgwObj.Toggle16Xiao5Fan.parent.gameObject:SetActive(phzData.mode == 0)
	hhhgwObj.ToggleTianHuFan5:GetComponent('UIToggle'):Set(phzData.tianHu5Fan)
	hhhgwObj.ToggleDiHuFan4:GetComponent('UIToggle'):Set(phzData.diHu4Fan)
	hhhgwObj.Toggle18Da5Fan:GetComponent('UIToggle'):Set(phzData.da18Fan5)
	hhhgwObj.Toggle16Xiao5Fan:GetComponent('UIToggle'):Set(phzData.shiLiuXiao)
end
function this.InitLDFPF()
	phzObj.ToggleFengDingScore200.parent.parent.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore200.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore400.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore200:GetComponent('UIToggle'):Set(phzData.maxHuXi == 200)
	phzObj.ToggleFengDingScore400:GetComponent('UIToggle'):Set(phzData.maxHuXi == 400)
	phzObj.ToggleFengDingScore200:Find('Label'):GetComponent("UILabel").text = '200息'
	phzObj.ToggleFengDingScore400:Find('Label'):GetComponent("UILabel").text = '400息'
	phzObj.ToggleFengDingScore200.parent:GetComponent('UIGrid'):Reposition()
end
function this.InitHYSHK()
	hyshkObj.ToggleBaseScore2.parent.gameObject:SetActive(true)
	hyshkObj.TogglecantPassHu.parent.gameObject:SetActive(true)
	hyshkObj.TogglemingWei.parent.gameObject:SetActive(true)
	hyshkObj.ToggleFanHYSHK.parent.gameObject:SetActive(true)
	hyshkObj.ToggleFangPao1.parent.gameObject:SetActive(true)

	hyshkObj.ToggleFangPao1.parent.gameObject:SetActive(not phzData.isNoBomb)
	hyshkObj.ToggleFangPao1:GetComponent('UIToggle'):Set(1 == phzData.fangpao)
	hyshkObj.ToggleFangPao2:GetComponent('UIToggle'):Set(2 == phzData.fangpao)
	hyshkObj.ToggleFangPao3:GetComponent('UIToggle'):Set(3 == phzData.fangpao)

	hyshkObj.ToggleBaseScore2:GetComponent('UIToggle'):Set(phzData.isBaseSocre2)
	hyshkObj.Toggle1510:GetComponent('UIToggle'):Set(phzData.yiWuShi)
	hyshkObj.TogglenoBomb:GetComponent('UIToggle'):Set(phzData.isNoBomb)
	hyshkObj.TogglecantPassHu:GetComponent('UIToggle'):Set(phzData.isCantPassHu)
	hyshkObj.TogglepiaoHu:GetComponent('UIToggle'):Set(phzData.isPiaoHu)
	hyshkObj.ToggletianDiHaiHu:GetComponent('UIToggle'):Set(phzData.isTianDiHaiHu)
	hyshkObj.TogglemingWei:GetComponent('UIToggle'):Set(phzData.canMingWei)
	hyshkObj.TogglexiaoHong3Fan:GetComponent('UIToggle'):Set(phzData.isXiaoHong3Fan)

	hyshkObj.ToggleFanHYSHK:GetComponent('UIToggle'):Set(0 == phzData.xingTypeHYSHK)
	hyshkObj.ToggleGenHYSHK:GetComponent('UIToggle'):Set(1 == phzData.xingTypeHYSHK)
	hyshkObj.ToggleNoHYSHK:GetComponent('UIToggle'):Set(2 == phzData.xingTypeHYSHK)
end
function this.InitHYLHQ()
	hylhqObj.ToggleBaseScore2HYLHQ.parent.gameObject:SetActive(true)
	hylhqObj.ToggleHongHeiDianHYLHQ.parent.gameObject:SetActive(true)
	hylhqObj.ToggleLiangPaoHYLHQ.parent.gameObject:SetActive(true)
	hylhqObj.ToggleFanHYLHQ.parent.gameObject:SetActive(true)
	hylhqObj.ToggleQiHuHuXu6.parent.gameObject:SetActive(true)

	hylhqObj.ToggleQiHuHuXu6:GetComponent('UIToggle'):Set(phzData.qihuhuxu == 6)
	hylhqObj.ToggleQiHuHuXu9:GetComponent('UIToggle'):Set(phzData.qihuhuxu == 9)
	
	hylhqObj.ToggleBaseScore2HYLHQ:GetComponent('UIToggle'):Set(phzData.isBaseSocre2)
	hylhqObj.Toggle1510HYLHQ:GetComponent('UIToggle'):Set(phzData.yiWuShi)
	hylhqObj.TogglecantPassHuHYLHQ:GetComponent('UIToggle'):Set(phzData.isCantPassHu)
	hylhqObj.ToggleHongHeiDianHYLHQ:GetComponent('UIToggle'):Set(phzData.isHongHeiDian)
	hylhqObj.ToggletianDiHaiHuHYLHQ:GetComponent('UIToggle'):Set(phzData.isTianDiHaiHu)
	hylhqObj.TogglemingWeiHYLHQ:GetComponent('UIToggle'):Set(phzData.canMingWei)
	hylhqObj.ToggleLiangPaoHYLHQ:GetComponent('UIToggle'):Set(phzData.isLiangPao)
	hylhqObj.ToggleYiHuYiTunHYLHQ:GetComponent('UIToggle'):Set(phzData.isYiHYiTun)
	hylhqObj.Toggle21ZhangHYLHQ:GetComponent('UIToggle'):Set(phzData.play21)
	hylhqObj.Toggle21ZhangHYLHQ.gameObject:SetActive(2 == phzData.size or 3 == phzData.size)
	
	hylhqObj.ToggleFanHYLHQ:GetComponent('UIToggle'):Set(0 == phzData.xingTypeHYLHQ)
	hylhqObj.ToggleGenHYLHQ:GetComponent('UIToggle'):Set(1 == phzData.xingTypeHYLHQ)
	hylhqObj.ToggleNoHYLHQ:GetComponent('UIToggle'):Set(2 == phzData.xingTypeHYLHQ)
end
function this.InitLYZP()
	lyzpObj.ToggleChoiceHu.parent.gameObject:SetActive(true)
	lyzpObj.ToggleTiAddScore0.parent.gameObject:SetActive(true)

	lyzpObj.ToggleChoiceHu:GetComponent('UIToggle'):Set(phzData.choiceHu == 2)
	lyzpObj.ToggleMaoHu:GetComponent('UIToggle'):Set(not phzData.maoHu)
	lyzpObj.ToggleYiDianHong:GetComponent('UIToggle'):Set(not phzData.yiDianHong)

	lyzpObj.ToggleTiAddScore0:GetComponent('UIToggle'):Set(phzData.tiAddScore == 0)
	lyzpObj.ToggleTiAddScore1:GetComponent('UIToggle'):Set(phzData.tiAddScore == 1)
	lyzpObj.ToggleTiAddScore2:GetComponent('UIToggle'):Set(phzData.tiAddScore == 2)
end
function this.InitHSPHZ()
	hsphzObj.ToggleWinBanker.parent.gameObject:SetActive(true)
	hsphzObj.ToggleWinBanker:GetComponent('UIToggle'):Set(phzData.choiceBanker == 0)
	hsphzObj.ToggleLoopBanker:GetComponent('UIToggle'):Set(phzData.choiceBanker == 1)

	hsphzObj.QiHuTunValue.parent.parent.gameObject:SetActive(true)
	hsphzObj.QiHuTunValue:GetComponent("UILabel").text = '倒'..phzData.qiHuTun

	phzObj.HuangZhuangKouFenValue.parent.parent.gameObject:SetActive(true)
	phzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = phzData.huangZhuangFen == 0 and '不扣分' or '扣'..phzData.huangZhuangFen..'分'

	hsphzObj.ToggleWuDui.parent.gameObject:SetActive(true)
	hsphzObj.ToggleWuDui:Find('Label'):GetComponent('UILabel').text = '黑对胡'
	hsphzObj.ToggleWuDui:GetComponent('UIToggle'):Set(phzData.wuDuiHu)
	hsphzObj.ToggleJiaHongDui.gameObject:SetActive(true)
	hsphzObj.ToggleJiaHongDui:GetComponent('UIToggle'):Set(phzData.jiaHongDui)
	hsphzObj.ToggleHongDui:GetComponent('UIToggle'):Set(phzData.hongDuiHu)
	
	phzObj.FengDingValue.parent.parent.gameObject:SetActive(true)
	phzObj.FengDingValue:GetComponent("UILabel").text = phzData.maxHuXi == 0 and '不封顶' or phzData.maxHuXi..'分'
end
function this.InitCDDHD()
	hsphzObj.QiHuTunValue.parent.parent.gameObject:SetActive(true)
	hsphzObj.QiHuTunValue:GetComponent("UILabel").text = phzData.qiHuTun..'等'

	cddhdObj.ToggleTianHu.parent.gameObject:SetActive(true)
	cddhdObj.ToggleHaiDiHu.parent.gameObject:SetActive(true)
	cddhdObj.ToggleTianHu:GetComponent('UIToggle'):Set(phzData.tianHu)
	cddhdObj.ToggleDiHu:GetComponent('UIToggle'):Set(phzData.diHu)
	cddhdObj.ToggleTingHu:GetComponent('UIToggle'):Set(phzData.tingHu)
	cddhdObj.ToggleHaiDiHu:GetComponent('UIToggle'):Set(phzData.haiDiHu)
	cddhdObj.ToggleHuangFan:GetComponent('UIToggle'):Set(phzData.huangFan)

	phzObj.HuangZhuangKouFenValue.parent.parent.gameObject:SetActive(true)
	phzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = phzData.huangZhuangFen == 0 and '不扣分' or '扣'..phzData.huangZhuangFen..'分'
	
	phzObj.FengDingValue.parent.parent.gameObject:SetActive(true)
	phzObj.FengDingValue:GetComponent("UILabel").text = phzData.maxHuXi == 0 and '不封顶' or phzData.maxHuXi..'分'
end
function this.InitNXPHZ()
	phzObj.HuangZhuangKouFenValue.parent.parent.gameObject:SetActive(true)
	phzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = phzData.huangZhuangFen == 0 and '不扣分' or '扣'..phzData.huangZhuangFen..'分'

	phzObj.ToggleHuNum3.gameObject:SetActive(phzData.roomType ~= proxy_pb.NXPHZ)
	phzObj.ToggleHuNum6.gameObject:SetActive(phzData.roomType ~= proxy_pb.NXPHZ)
	phzObj.ToggleHuNum9.gameObject:SetActive(phzData.roomType == proxy_pb.NXPHZ)
	phzObj.ToggleHuNum10.gameObject:SetActive(phzData.roomType ~= proxy_pb.NXPHZ)
	phzObj.ToggleHuNum15.gameObject:SetActive(phzData.roomType == proxy_pb.NXPHZ)
	phzObj.ToggleHuNum9.parent.parent.gameObject:SetActive(true)
	phzObj.ToggleHuNum9:GetComponent('UIToggle'):Set(9 == phzData.qiHuHuXi)
	phzObj.ToggleHuNum15:GetComponent('UIToggle'):Set(15 == phzData.qiHuHuXi)
	phzObj.ToggleHuNum9.parent:GetComponent('UIGrid'):Reposition()

	phzObj.ToggleFengDingScore0.parent.parent.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore0.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore5.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore10.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore100.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore200.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore300.gameObject:SetActive(true)
	phzObj.ToggleFengDingScore0:GetComponent('UIToggle'):Set(phzData.maxHuXi == 0)
	phzObj.ToggleFengDingScore5:GetComponent('UIToggle'):Set(phzData.maxHuXi == 5)
	phzObj.ToggleFengDingScore10:GetComponent('UIToggle'):Set(phzData.maxHuXi == 10)
	phzObj.ToggleFengDingScore100:GetComponent('UIToggle'):Set(phzData.maxHuXi == 100)
	phzObj.ToggleFengDingScore200:GetComponent('UIToggle'):Set(phzData.maxHuXi == 200)
	phzObj.ToggleFengDingScore300:GetComponent('UIToggle'):Set(phzData.maxHuXi == 300)
	phzObj.ToggleFengDingScore200:Find('Label'):GetComponent("UILabel").text = '200封顶'
	phzObj.ToggleFengDingScore300:Find('Label'):GetComponent("UILabel").text = '300封顶'
	phzObj.ToggleFengDingScore0.parent:GetComponent('UIGrid'):Reposition()

	phzObj.ZhaNiaoValue.parent.parent.gameObject:SetActive(true)
	phzObj.ZhaNiaoValue:GetComponent("UILabel").text = phzData.zhaNiao == 0 and '不扎鸟' or (phzData.zhaNiao..'分')

	phzObj.DiFenTunValue.parent.parent.gameObject:SetActive(true)
	phzObj.DiFenTunValue:GetComponent("UILabel").text = phzData.bottomScore..'分'

	nxphzObj.ToggleZiMoFanBei.parent.gameObject:SetActive(true)
	nxphzObj.ToggleShuaHou.parent.gameObject:SetActive(true)
	nxphzObj.ToggleZiMoFanBei:GetComponent('UIToggle'):Set(phzData.ziMoFan == 2)
	nxphzObj.ToggleShiLiuXiao:GetComponent('UIToggle'):Set(phzData.shiLiuXiao)
	nxphzObj.ToggleHaiDiHu:GetComponent('UIToggle'):Set(phzData.haiDiHu)
	nxphzObj.ToggleShuaHou:GetComponent('UIToggle'):Set(phzData.shuaHou)
	nxphzObj.ToggleAdd1When27:GetComponent('UIToggle'):Set(phzData.add1When27)
	nxphzObj.ToggleAddHongXiaoDa:GetComponent('UIToggle'):Set(phzData.addHongXiaoDa)

	nxphzObj.ToggleZiMoAddTun0.parent.gameObject:SetActive(true)
	nxphzObj.ToggleZiMoAddTun0:GetComponent('UIToggle'):Set(phzData.ziMoAddTun == 0)
	nxphzObj.ToggleZiMoAddTun1:GetComponent('UIToggle'):Set(phzData.ziMoAddTun == 1)
	nxphzObj.ToggleZiMoAddTun2:GetComponent('UIToggle'):Set(phzData.ziMoAddTun == 2)
end
function this.InitXTPHZ()
	phzObj.ToggleHuNum3.gameObject:SetActive(phzData.roomType ~= proxy_pb.XTPHZ)
	phzObj.ToggleHuNum6.gameObject:SetActive(phzData.roomType ~= proxy_pb.XTPHZ)
	phzObj.ToggleHuNum9.gameObject:SetActive(phzData.roomType ~= proxy_pb.XTPHZ)
	phzObj.ToggleHuNum10.gameObject:SetActive(phzData.roomType == proxy_pb.XTPHZ)
	phzObj.ToggleHuNum15.gameObject:SetActive(phzData.roomType == proxy_pb.XTPHZ)
	phzObj.ToggleHuNum10.parent.parent.gameObject:SetActive(true)
	phzObj.ToggleHuNum10:GetComponent('UIToggle'):Set(10 == phzData.qiHuHuXi)
	phzObj.ToggleHuNum15:GetComponent('UIToggle'):Set(15 == phzData.qiHuHuXi)
	phzObj.ToggleHuNum9.parent:GetComponent('UIGrid'):Reposition()

	phzObj.DiFenTunValue.parent.parent.gameObject:SetActive(true)
	phzObj.DiFenTunValue:GetComponent("UILabel").text = phzData.bottomScore..'分'

	phzObj.FengDingValue.parent.parent.gameObject:SetActive(true)
	phzObj.FengDingValue:GetComponent("UILabel").text = phzData.maxHuXi == 0 and '不封顶' or phzData.maxHuXi..'分'

	phzObj.HuangZhuangKouFenValue.parent.parent.gameObject:SetActive(true)
	phzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = phzData.huangZhuangFen == 0 and '不扣分' or '扣'..phzData.huangZhuangFen..'分'
	
	phzObj.ToggleSanXiYiTun.parent.gameObject:SetActive(true)
	phzObj.ToggleFengSanJinSan.gameObject:SetActive(true)
	phzObj.ToggleSanXiYiTun:GetComponent('UIToggle'):Set(phzData.calculationTunMode == 0)
	phzObj.ToggleYiXiYiTun:GetComponent('UIToggle'):Set(phzData.calculationTunMode == 1)
	phzObj.ToggleFengSanJinSan:GetComponent('UIToggle'):Set(phzData.calculationTunMode == 2)

	xtphzObj.ToggleYiWuShi.parent.gameObject:SetActive(true)
	xtphzObj.ToggleYiWuShi:GetComponent('UIToggle'):Set(phzData.yiWuShi)
	xtphzObj.ToggleShiZhongBuLiang:GetComponent('UIToggle'):Set(phzData.shiZhongBuLiang)
	xtphzObj.ToggleHu30FangBei:GetComponent('UIToggle'):Set(phzData.hu30FangBei)

	xtphzObj.ToggleTianDiHu.parent.gameObject:SetActive(true)
	xtphzObj.ToggleTianDiHu:GetComponent('UIToggle'):Set(phzData.tianDiHu)
	xtphzObj.TogglePengPengHu:GetComponent('UIToggle'):Set(phzData.pengPengHu)
	xtphzObj.ToggleDaXiaoZiHu:GetComponent('UIToggle'):Set(phzData.daXiaoZiHu)

	xtphzObj.ToggleYiDianHong.parent.gameObject:SetActive(true)
	xtphzObj.ToggleYiDianHong:GetComponent('UIToggle'):Set(phzData.yiDianHong)
	xtphzObj.ToggleHeiHongHu:GetComponent('UIToggle'):Set(phzData.heiHongHu)
	xtphzObj.ToggleHong13.gameObject:SetActive(phzData.heiHongHu)
	xtphzObj.ToggleHong13:GetComponent('UIToggle'):Set(phzData.hong13)

	xtphzObj.ToggleCanHuZiMo.parent.gameObject:SetActive(true)
	xtphzObj.ToggleCanHuZiMo:GetComponent('UIToggle'):Set(phzData.canHuZiMo)
	xtphzObj.ToggleCanAnWei:GetComponent('UIToggle'):Set(not phzData.canMingWei)
	xtphzObj.ToggleChouWeiLiang.gameObject:SetActive(not phzData.canMingWei)
	xtphzObj.ToggleChouWeiLiang:GetComponent('UIToggle'):Set(phzData.chouWeiLiang)

	xtphzObj.ToggleFanShuChen.parent.gameObject:SetActive(true)
	xtphzObj.ToggleFanShuChen:GetComponent('UIToggle'):Set(phzData.calculationFanMode == 0)
	xtphzObj.ToggleFanShuJia:GetComponent('UIToggle'):Set(phzData.calculationFanMode == 1)
	xtphzObj.TogglefanShuYiBei:GetComponent('UIToggle'):Set(phzData.calculationFanMode == 2)
end
function this.InitYXPHZ()
	yxphzObj.ToggleLianZhuang.parent.gameObject:SetActive(true)
	yxphzObj.ToggleLianZhuang:GetComponent('UIToggle'):Set(phzData.mode == 0)
	yxphzObj.ToggleZhongZhuang:GetComponent('UIToggle'):Set(phzData.mode == 1)

	yxphzObj.ToggleYouHuBiHu.parent.gameObject:SetActive(true)
	yxphzObj.ToggleYouHuBiHu:GetComponent('UIToggle'):Set(phzData.haveHuMustHu)

	phzObj.HuangZhuangKouFenValue.parent.parent.gameObject:SetActive(true)
	phzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = phzData.huangZhuangFen == 0 and '不扣分' or '扣'..phzData.huangZhuangFen..'分'
end
function this.InitYJGHZ()
	yjghzObj.ToggleWai5Kan5.parent.gameObject:SetActive(true)
	yjghzObj.ToggleWai5Kan5:GetComponent('UIToggle'):Set(phzData.mode == 0)
	yjghzObj.ToggleWai10Kan10:GetComponent('UIToggle'):Set(phzData.mode == 1)

	
	yjghzObj.ToggleDiaoDiaoShou50Xi:Find('Label'):GetComponent("UILabel").text = phzData.mode == 0 and '吊吊手50息' or '吊吊手100息'
	yjghzObj.ToggleBuKePiao.parent.gameObject:SetActive(true)
	yjghzObj.ToggleBuKePiao:GetComponent('UIToggle'):Set(phzData.piao == 0)
	yjghzObj.ToggleJiuDuiBan:GetComponent('UIToggle'):Set(phzData.jiuDuiBan)
	yjghzObj.ToggleWuXiPing:GetComponent('UIToggle'):Set(phzData.wuXiPing)
	yjghzObj.ToggleDiaoDiaoShou50Xi.parent.gameObject:SetActive(true)
	yjghzObj.ToggleDiaoDiaoShou50Xi:GetComponent('UIToggle'):Set(phzData.diaoDiaoShou)
	yjghzObj.ToggleXingXingXi2Fan:GetComponent('UIToggle'):Set(phzData.hangHangXi2Fan)
	yjghzObj.ToggleTianHu:GetComponent('UIToggle'):Set(phzData.tianHu)
	yjghzObj.ToggleDiHu.parent.gameObject:SetActive(true)
	yjghzObj.ToggleDiHu:GetComponent('UIToggle'):Set(phzData.diHu)
	yjghzObj.ToggleHaiDiHu:GetComponent('UIToggle'):Set(phzData.haiDiHu)

	phzObj.FengDingValue.parent.parent.gameObject:SetActive(true)
	phzObj.FengDingValue:GetComponent("UILabel").text = phzData.maxHuXi..'分'

	phzObj.HuangZhuangKouFenValue.parent.parent.gameObject:SetActive(true)
	phzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = phzData.huangZhuangFen == 0 and '不扣分' or '扣'..phzData.huangZhuangFen..'分'
	phzObj.continueBanker:GetComponent('UIToggle'):Set(phzData.huangKeepBanker)
end
function this.InitCZZP()
	phzObj.ToggleHuNum3.gameObject:SetActive(phzData.roomType == proxy_pb.CZZP)
	phzObj.ToggleHuNum6.gameObject:SetActive(phzData.roomType == proxy_pb.CZZP)
	phzObj.ToggleHuNum9.gameObject:SetActive(phzData.roomType == proxy_pb.CZZP)
	phzObj.ToggleHuNum10.gameObject:SetActive(phzData.roomType ~= proxy_pb.CZZP)
	phzObj.ToggleHuNum15.gameObject:SetActive(phzData.roomType ~= proxy_pb.CZZP)
	phzObj.ToggleHuNum9.parent.parent.gameObject:SetActive(true)
	phzObj.ToggleHuNum3:GetComponent('UIToggle'):Set(3 == phzData.qiHuHuXi)
	phzObj.ToggleHuNum6:GetComponent('UIToggle'):Set(6 == phzData.qiHuHuXi)
	phzObj.ToggleHuNum9:GetComponent('UIToggle'):Set(9 == phzData.qiHuHuXi)
	phzObj.ToggleHuNum9.parent:GetComponent('UIGrid'):Reposition()

	phzObj.ToggleSanXiYiTun.parent.gameObject:SetActive(true)
	phzObj.ToggleFengSanJinSan.gameObject:SetActive(false)
	phzObj.ToggleSanXiYiTun:GetComponent('UIToggle'):Set(phzData.calculationTunMode == 0)
	phzObj.ToggleYiXiYiTun:GetComponent('UIToggle'):Set(phzData.calculationTunMode == 1)

	this.SetShowQiHuTun()
	local calculationFanMode = 0
	if phzData.calculationFanMode == 0 or phzData.calculationFanMode == 2 or phzData.calculationFanMode == 5 then
		calculationFanMode = 0
	else
		calculationFanMode = 1
	end
	czzpObj.ToggleQiHu9Xi1Tun.parent.gameObject:SetActive(true)
	czzpObj.ToggleQiHu9Xi1Tun:GetComponent('UIToggle'):Set(0 == calculationFanMode)
	czzpObj.ToggleQiHu9Xi3Tun:GetComponent('UIToggle'):Set(1 == calculationFanMode)

	czzpObj.ToggleQClassic0.parent.gameObject:SetActive(true)
	czzpObj.ToggleQClassic0:GetComponent('UIToggle'):Set(0 == phzData.classic)
	czzpObj.ToggleQClassic1:GetComponent('UIToggle'):Set(1 == phzData.classic)
	czzpObj.ToggleQClassic2:GetComponent('UIToggle'):Set(2 == phzData.classic)

	czzpObj.ToggleZiMoFan.parent.gameObject:SetActive(true)
	czzpObj.ToggleZiMoFan:GetComponent('UIToggle'):Set(2 == phzData.ziMoFan)
	czzpObj.ToggleYouHuBiHu:GetComponent('UIToggle'):Set(1 == phzData.choiceHu)
	czzpObj.ToggleFangPaoBiHu.gameObject:SetActive(1 ~= phzData.choiceHu)
	czzpObj.ToggleFangPaoBiHu:GetComponent('UIToggle'):Set(2 == phzData.choiceHu)
	czzpObj.ToggleDaXiaoHongHu.parent.gameObject:SetActive(true)
	czzpObj.ToggleDaXiaoHongHu.gameObject:SetActive(phzData.classic == 1)
	czzpObj.ToggleDaXiaoHongHu:GetComponent('UIToggle'):Set(phzData.daXiaoZiHu)
	czzpObj.TogglePlay15:GetComponent('UIToggle'):Set((not phzData.play21) or phzData.size ==4)
	czzpObj.TogglePlay15:GetComponent('BoxCollider').enabled = phzData.size ~=4
	local  maoHuHuXi = ''
	if phzData.maoHuHuXi == 0 then
		maoHuHuXi = '无毛胡'
	else
		maoHuHuXi = '毛胡'..phzData.maoHuHuXi..'胡'
	end
	czzpObj.MaoHuLabel:GetComponent('UILabel').text = maoHuHuXi
	
	phzObj.HuangZhuangKouFenValue.parent.parent.gameObject:SetActive(true)
	phzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = phzData.huangZhuangFen == 0 and '不扣分' or '扣'..phzData.huangZhuangFen..'分'
	phzObj.continueBanker:GetComponent('UIToggle'):Set(phzData.huangKeepBanker)

	czzpObj.TogglePiao0.parent.gameObject:SetActive(true)
	czzpObj.TogglePiao0:GetComponent('UIToggle'):Set(0 == phzData.piao)
	czzpObj.TogglePiao1:GetComponent('UIToggle'):Set(1 == phzData.piao)
	czzpObj.TogglePiao2:GetComponent('UIToggle'):Set(2 == phzData.piao)
	czzpObj.TogglePiao3:GetComponent('UIToggle'):Set(3 == phzData.piao)
end
function this.OnClickToggleXing(go)
	AudioManager.Instance:PlayAudio('btn')
    if go == syzpObj.ToggleFan.gameObject then
        phzData.xingType = true
     else
        phzData.xingType = false
    end
end

function this.OnClickToggleHuMinNum(go)
	AudioManager.Instance:PlayAudio('btn')
    if phzObj.ToggleHuNum3.gameObject == go then
		phzData.qiHuHuXi = 3
	elseif phzObj.ToggleHuNum6.gameObject == go then
		phzData.qiHuHuXi = 6
	elseif phzObj.ToggleHuNum9.gameObject == go then
		phzData.qiHuHuXi = 9
	elseif phzObj.ToggleHuNum10.gameObject == go then
		phzData.qiHuHuXi = 10
    elseif phzObj.ToggleHuNum15.gameObject == go then
		phzData.qiHuHuXi = 15
	end     
	if phzData.roomType == proxy_pb.CZZP then
		if phzData.roomType == proxy_pb.CZZP then
			this.SetShowQiHuTun()
			if phzData.qiHuHuXi == 3 and phzData.calculationTunMode == 0 then
				czzpObj.ToggleQiHu9Xi1Tun:GetComponent('UIToggle'):Set(true)
				czzpObj.ToggleQiHu9Xi3Tun:GetComponent('UIToggle'):Set(false)	
			end
		end
	else
		this.Refresh()
	end
end

function this.OnClickToggleHuStep(go)
	AudioManager.Instance:PlayAudio('btn')
    if syzpObj.ToggleHuStep5 ~= nil and syzpObj.ToggleHuStep5.gameObject == go then
        phzData.tunXi = 5
    elseif syzpObj.ToggleHuStep3.gameObject == go then
		phzData.tunXi = 3
	elseif syzpObj.ToggleHuStep1.gameObject == go then
        phzData.tunXi = 1
    end 
end 

function this.OnClickToggleHuStepAH(go)
	AudioManager.Instance:PlayAudio('btn') 
	if ahphzObj.ToggleHuStep3.gameObject == go then
		phzData.tunXi = 3
	elseif ahphzObj.ToggleHuStep1.gameObject == go then
        phzData.tunXi = 1
    end 
end 
 

function this.OnClickToggleRound(go)
	AudioManager.Instance:PlayAudio('btn')
    if phzObj.ToggleRound1.gameObject == go then
		phzData.rounds = 1
	elseif phzObj.ToggleRound6.gameObject == go then
        phzData.rounds = 6
    elseif phzObj.ToggleRound8.gameObject == go then
        phzData.rounds = 8
    elseif phzObj.ToggleRound10.gameObject == go then
        phzData.rounds = 10
	else
		phzData.rounds = 16
    end
	this.Refresh()
end

function this.OnClickTogglePlayerNum(go)
	AudioManager.Instance:PlayAudio('btn')
	if phzObj.TogglePlayer3.gameObject == go then
		phzData.size = 3
	elseif phzObj.TogglePlayer2.gameObject == go then
		phzData.size = 2
	elseif phzObj.TogglePlayer4.gameObject == go then
		phzData.size = 4
	end
	this.Refresh()
end

function this.OnClickToggleChouPai(go)
	AudioManager.Instance:PlayAudio('btn')
	if phzObj.ToggleNoChouPai.gameObject == go then
		phzData.choupai = 0
	elseif phzObj.ToggleChouPai10.gameObject == go then
		phzData.choupai = 10
	elseif phzObj.ToggleChouPai14.gameObject == go then
		phzData.choupai = 14
	elseif phzObj.ToggleChouPai20.gameObject == go then
		phzData.choupai = 20
	elseif phzObj.ToggleChouPai28.gameObject == go then
		phzData.choupai = 28
	end
end

function this.OnClickToggleHuTypeSYZP(go)
	AudioManager.Instance:PlayAudio('btn')
	if syzpObj.ToggleTian.gameObject == go then
		phzData.tianDiHu = syzpObj.ToggleTian:GetComponent('UIToggle').value
	elseif syzpObj.ToggleHong.gameObject == go then
		phzData.heiHongHu = syzpObj.ToggleHong:GetComponent('UIToggle').value
	elseif syzpObj.ToggleZiMo10Hu.gameObject == go then
		phzData.ziMoAddHu = syzpObj.ToggleZiMo10Hu:GetComponent('UIToggle').value and 10 or 0
	end
end

function this.OnClickTogglePlayHHHGW(go)
	AudioManager.Instance:PlayAudio('btn')
	if hhhgwObj.ToggleZiMoHu15.gameObject == go then
		phzData.canHuZiMo = hhhgwObj.ToggleZiMoHu15:GetComponent('UIToggle').value
	elseif hhhgwObj.ToggleZiMoFan2.gameObject == go then
		if hhhgwObj.ToggleZiMoFan2:GetComponent('UIToggle').value then
			phzData.ziMoFan = 2
		else
			phzData.ziMoFan = 0
		end
	elseif hhhgwObj.ToggleLiangPaiKeHu21.gameObject == go then
		phzData.shiZhongBuLiang = hhhgwObj.ToggleLiangPaiKeHu21:GetComponent('UIToggle').value
	elseif hhhgwObj.ToggleTianHuFan5.gameObject == go then
		phzData.tianHu5Fan = hhhgwObj.ToggleTianHuFan5:GetComponent('UIToggle').value
	elseif hhhgwObj.ToggleDiHuFan4.gameObject == go then
		phzData.diHu4Fan = hhhgwObj.ToggleDiHuFan4:GetComponent('UIToggle').value
	elseif hhhgwObj.Toggle18Da5Fan.gameObject == go then
		phzData.da18Fan5 = hhhgwObj.Toggle18Da5Fan:GetComponent('UIToggle').value
	elseif hhhgwObj.Toggle16Xiao5Fan.gameObject == go then
		phzData.shiLiuXiao = hhhgwObj.Toggle16Xiao5Fan:GetComponent('UIToggle').value
	end
end

function this.OnClickModeSetting(go)
	AudioManager.Instance:PlayAudio('btn')
    if hhhgwObj.ToggleOldMode.gameObject == go then
        phzData.mode = 0
	elseif hhhgwObj.Toggle468Mode.gameObject == go then
        phzData.mode = 1
	end
	hhhgwObj.ToggleTianHuFan5.parent.gameObject:SetActive(phzData.mode == 0)
	hhhgwObj.Toggle16Xiao5Fan.parent.gameObject:SetActive(phzData.mode == 0)
	optionTable:GetComponent('UIGrid'):Reposition()
end

function this.OnClickTogglePlay(go)
	AudioManager.Instance:PlayAudio('btn') 
	if go == ahphzObj.TogglePapo.gameObject then
		phzData.paPo = ahphzObj.TogglePapo:GetComponent('UIToggle').value 
	elseif go == ahphzObj.ToggleHong.gameObject then
		phzData.heiHongHu = ahphzObj.ToggleHong:GetComponent('UIToggle').value 
	elseif go == ahphzObj.ToggleZiMoAdd1Tun.gameObject then
		phzData.ziMoAddTun = ahphzObj.ToggleZiMoAdd1Tun:GetComponent('UIToggle').value and 1 or 0
	elseif go == ahphzObj.ToggleTian.gameObject then
		phzData.tianhu = ahphzObj.ToggleTian:GetComponent('UIToggle').value 
	elseif go == ahphzObj.ToggleDi.gameObject then
		phzData.dihu = ahphzObj.ToggleDi:GetComponent('UIToggle').value 
	elseif go == ahphzObj.ToggleHaiDi.gameObject then
		phzData.haiDiHu = ahphzObj.ToggleHaiDi:GetComponent('UIToggle').value 
	end
end

function this.OnClickToggleMingTang(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == cdphzObj.Toggleqmt.gameObject then
		phzData.quanMingTang = true
    else
        phzData.quanMingTang = false
	end
	cdphzObj.ToggleShuaHou.parent.gameObject:SetActive(phzData.quanMingTang)
	cdphzObj.ToggleHangHangXi.parent.gameObject:SetActive(phzData.quanMingTang)
	cdphzObj.ToggleHuangFan.parent.gameObject:SetActive(phzData.quanMingTang)
	cdphzObj.ToggleDuiDuiHu.parent.gameObject:SetActive(not phzData.quanMingTang)
	optionTable:GetComponent('UIGrid'):Reposition()
end

function this.OnClickToggleZiMoFan(go)
	AudioManager.Instance:PlayAudio('btn')
	if csphzObj.ToggleZiMoFan0.gameObject == go then
        phzData.ziMoFan = 0
    elseif csphzObj.ToggleZiMoFan1.gameObject == go then
        phzData.ziMoFan = 1
	else
		phzData.ziMoFan = 2
    end
end

function this.OnClickBpHuType(go)
	if sybpObj.ToggleBpHongDian.gameObject == go then
		phzData.heiHongDian = true
		phzData.heiHongHu = false
	elseif sybpObj.ToggleBpHong.gameObject == go then
		phzData.heiHongDian = false
		phzData.heiHongHu = true
	else
		phzData.heiHongDian = false
		phzData.heiHongHu = false
	end
end

function this.OnClickNiao(go)
	AudioManager.Instance:PlayAudio('btn')
	if phzObj.ToggleOnNiao.gameObject == go then
		phzData.niao = true
		if phzData.niaoValue==0 then
			phzData.niaoValue=10
		end
	else
		phzData.niao = false
		phzData.niaoValue=0
	end
	if phzData.niao and phzData.roomType == proxy_pb.CZZP then
		this.OnClickTogglePiao(czzpObj.TogglePiao0.gameObject)
		czzpObj.TogglePiao0:GetComponent('UIToggle'):Set(phzData.piao == 0)
		czzpObj.TogglePiao1:GetComponent('UIToggle'):Set(phzData.piao == 1)
		czzpObj.TogglePiao2:GetComponent('UIToggle'):Set(phzData.piao == 2)
		czzpObj.TogglePiao3:GetComponent('UIToggle'):Set(phzData.piao == 3)
	end
	phzObj.NiaoValueText:GetComponent('UILabel').text = phzData.niaoValue.."分"
	phzObj.NiaoValueText.parent.gameObject:SetActive(phzData.niao)
end

function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if phzObj.AddButtonNiao.gameObject == go then
		phzData.niaoValue = phzData.niaoValue + 10
		if phzData.niaoValue > 100 then
			phzData.niaoValue = 100
		end
	else
		phzData.niaoValue = phzData.niaoValue - 10
		if phzData.niaoValue < 10 then
			phzData.niaoValue = 10
		end
	end
	phzObj.NiaoValueText:GetComponent('UILabel').text = phzData.niaoValue.."分"
end

function this.OnClickChoiceDouble(go)
	AudioManager.Instance:PlayAudio('btn')
	if phzObj.ToggleChoiceDouble.gameObject == go then
		phzData.choiceDouble = true
	else
		phzData.choiceDouble = false
	end
	phzObj.DoubleScoreText.parent.gameObject:SetActive(phzData.choiceDouble)
	phzObj.ToggleMultiple2.parent.gameObject:SetActive(phzData.choiceDouble)
	if phzData.roomType == proxy_pb.HYLHQ or phzData.roomType == proxy_pb.HYSHK then
		phzObj.ToggleOneRoundDouble.parent.gameObject:SetActive(phzData.size==2 and phzData.choiceDouble)
		phzObj.ToggleOneRoundDouble:GetComponent('UIToggle'):Set(phzData.singleRoundDouble)
		phzObj.ToggleAllRoundDouble:GetComponent('UIToggle'):Set(not phzData.singleRoundDouble)
	end
	if phzData.choiceDouble then
		phzObj.ToggleMultiple2:GetComponent('UIToggle'):Set(phzData.multiple == 2)
		phzObj.ToggleMultiple3:GetComponent('UIToggle'):Set(phzData.multiple == 3)
		phzObj.ToggleMultiple4:GetComponent('UIToggle'):Set(phzData.multiple == 4)
	end
	optionTable:GetComponent('UIGrid'):Reposition()
end

function this.OnClickChangeDoubleScore(go)
	AudioManager.Instance:PlayAudio('btn')
	if phzObj.AddDoubleScoreButton.gameObject == go then
		if phzData.doubleScore ~= 0 then
			phzData.doubleScore = phzData.doubleScore + 1
			if phzData.doubleScore > 100 then
				phzData.doubleScore = 0
			end
		end
	else
		if phzData.doubleScore == 0 then
			phzData.doubleScore = 100
		else
			phzData.doubleScore = phzData.doubleScore - 1
			if phzData.doubleScore < 1 then
				phzData.doubleScore = 1
			end
		end
	end
	if phzData.doubleScore == 0 then
		phzObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		phzObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..phzData.doubleScore..'分'
	end
end

function this.OnClickMultiple(go)
	AudioManager.Instance:PlayAudio('btn')
	phzData.multiple = tonumber(go.name)
end

function this.OnClickRoundDouble(go)
	AudioManager.Instance:PlayAudio('btn')
    if phzObj.ToggleOneRoundDouble.gameObject == go then
        phzData.singleRoundDouble=true
    elseif phzObj.ToggleAllRoundDouble.gameObject == go then
		phzData.singleRoundDouble=false
    end
end

function this.OnClickMaxHuXi(go)
	AudioManager.Instance:PlayAudio('btn')
	phzData.maxHuXi = tonumber(go.name)
end

function this.OnClickRandomBanker(go)
	AudioManager.Instance:PlayAudio('btn')
	if phzObj.ToggleBankerAuto.gameObject == go then
		phzData.randomBanker = true
	else
		phzData.randomBanker = false	
	end
end

function this.OnClickPlayTuo(go)
	AudioManager.Instance:PlayAudio('btn')
	if xxghzObj.TogglePlayTuo.gameObject == go then
		phzData.tuo = true
	else
		phzData.tuo = false
	end
end

function this.OnClickToggleFangPao(go)
	AudioManager.Instance:PlayAudio('btn')
    if hyshkObj.ToggleFangPao1.gameObject == go then
		phzData.fangpao = 1
	elseif hyshkObj.ToggleFangPao2.gameObject == go then
		phzData.fangpao = 2
	elseif hyshkObj.ToggleFangPao3.gameObject == go then
		phzData.fangpao = 3
	end
end

function this.OnClickToggleHuType(go)
	AudioManager.Instance:PlayAudio('btn')
    if hyshkObj.ToggleBaseScore2.gameObject == go then
		phzData.isBaseSocre2 = hyshkObj.ToggleBaseScore2:GetComponent('UIToggle').value
    elseif hyshkObj.Toggle1510.gameObject == go then
		phzData.yiWuShi = hyshkObj.Toggle1510:GetComponent('UIToggle').value
	elseif hyshkObj.TogglenoBomb.gameObject == go then
		phzData.isNoBomb = hyshkObj.TogglenoBomb:GetComponent('UIToggle').value
		hyshkObj.ToggleFangPao1.parent.gameObject:SetActive(not phzData.isNoBomb)
		hyshkObj.ToggleFangPao1:GetComponent('UIToggle'):Set(1 == phzData.fangpao)
		hyshkObj.ToggleFangPao2:GetComponent('UIToggle'):Set(2 == phzData.fangpao)
		hyshkObj.ToggleFangPao3:GetComponent('UIToggle'):Set(3 == phzData.fangpao)
		optionTable:GetComponent('UIGrid'):Reposition()
	elseif hyshkObj.TogglecantPassHu.gameObject == go then
		phzData.isCantPassHu = hyshkObj.TogglecantPassHu:GetComponent('UIToggle').value
	elseif hyshkObj.TogglepiaoHu.gameObject == go then
		phzData.isPiaoHu = hyshkObj.TogglepiaoHu:GetComponent('UIToggle').value
	elseif hyshkObj.ToggletianDiHaiHu.gameObject == go then
		phzData.isTianDiHaiHu = hyshkObj.ToggletianDiHaiHu:GetComponent('UIToggle').value
	elseif hyshkObj.TogglemingWei.gameObject == go then
		phzData.canMingWei = hyshkObj.TogglemingWei:GetComponent('UIToggle').value
	elseif hyshkObj.TogglexiaoHong3Fan.gameObject == go then
		phzData.isXiaoHong3Fan = hyshkObj.TogglexiaoHong3Fan:GetComponent('UIToggle').value
	else
		print('unkown button')
    end
end

function this.OnClickToggleFanType(go)
	AudioManager.Instance:PlayAudio('btn')
    if hyshkObj.ToggleFanHYSHK.gameObject == go then
		phzData.xingTypeHYSHK = 0
	elseif hyshkObj.ToggleGenHYSHK.gameObject == go then
		phzData.xingTypeHYSHK = 1
	else
		phzData.xingTypeHYSHK = 2
	end
end

function this.OnClickToggleHuTypeHYLHQ(go)
	AudioManager.Instance:PlayAudio('btn')
    if hylhqObj.ToggleBaseScore2HYLHQ.gameObject == go then
		phzData.isBaseSocre2 = hylhqObj.ToggleBaseScore2HYLHQ:GetComponent('UIToggle').value
    elseif hylhqObj.Toggle1510HYLHQ.gameObject == go then
		phzData.yiWuShi = hylhqObj.Toggle1510HYLHQ:GetComponent('UIToggle').value
	elseif hylhqObj.TogglecantPassHuHYLHQ.gameObject == go then
		phzData.isCantPassHu = hylhqObj.TogglecantPassHuHYLHQ:GetComponent('UIToggle').value
	elseif hylhqObj.ToggleHongHeiDianHYLHQ.gameObject == go then
		phzData.isHongHeiDian = hylhqObj.ToggleHongHeiDianHYLHQ:GetComponent('UIToggle').value
	elseif hylhqObj.ToggletianDiHaiHuHYLHQ.gameObject == go then
		phzData.isTianDiHaiHu = hylhqObj.ToggletianDiHaiHuHYLHQ:GetComponent('UIToggle').value
	elseif hylhqObj.TogglemingWeiHYLHQ.gameObject == go then
		phzData.canMingWei = hylhqObj.TogglemingWeiHYLHQ:GetComponent('UIToggle').value
	elseif hylhqObj.ToggleLiangPaoHYLHQ.gameObject == go then
		phzData.isLiangPao = hylhqObj.ToggleLiangPaoHYLHQ:GetComponent('UIToggle').value
	elseif hylhqObj.ToggleYiHuYiTunHYLHQ.gameObject == go then
		phzData.isYiHYiTun = hylhqObj.ToggleYiHuYiTunHYLHQ:GetComponent('UIToggle').value
	elseif hylhqObj.Toggle21ZhangHYLHQ.gameObject == go then
		phzData.play21 = hylhqObj.Toggle21ZhangHYLHQ:GetComponent('UIToggle').value
	else
		print('unkown button')
    end
end

function this.OnClickToggleFanTypeHYLHQ(go)
	AudioManager.Instance:PlayAudio('btn')
    if hylhqObj.ToggleFanHYLHQ.gameObject == go then
		phzData.xingTypeHYLHQ = 0
	elseif hylhqObj.ToggleGenHYLHQ.gameObject == go then
		phzData.xingTypeHYLHQ = 1
	else
		phzData.xingTypeHYLHQ = 2
	end
end

function this.OnClickQiHuHuXu(go)
    AudioManager.Instance:PlayAudio('btn')
    if hylhqObj.ToggleQiHuHuXu6.gameObject == go then
        phzData.qihuhuxu = 6
    elseif hylhqObj.ToggleQiHuHuXu9.gameObject == go then
        phzData.qihuhuxu = 9
    end
end

function this.OnClickClose(go)
	AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickButtonOK(go)
	AudioManager.Instance:PlayAudio('btn')
	-- print('玩法ID：'..curSelectPlay.playId)
	-- print('玩法名字：'..curSelectPlay.name)
	local rule = {}
	rule.roomType=phzData.roomType
	rule.size = phzData.size
	rule.paymentType = phzData.payType
	rule.trusteeship = phzData.trusteeship;
	--rule.trusteeship = 15;--测试用的，可以删掉
	rule.trusteeshipDissolve = phzData.trusteeshipDissolve;
	rule.trusteeshipRound = phzData.trusteeshipRound;
	rule.randomBanker = phzData.randomBanker
	rule.resultScore = phzData.size==2 and phzData.isSettlementScore or false
	rule.resultLowerScore=phzData.fewerValue
	rule.resultAddScore=phzData.addValue
	if phzData.size == 2 then
		phzData.openIp=false
		phzData.openGps=false
	end
	rule.openIp=phzData.openIp
	rule.openGps=phzData.openGps
	if phzData.size == 3 then
		rule.choiceDouble = false
		rule.doubleScore =0
		rule.multiple=0
	elseif phzData.size == 2 then
		rule.choiceDouble=phzData.choiceDouble
		rule.doubleScore =phzData.choiceDouble and phzData.doubleScore or 0
		rule.multiple =phzData.choiceDouble and phzData.multiple or 0
		rule.singleRoundDouble = phzData.choiceDouble and phzData.singleRoundDouble
	end
	rule.chou = phzData.size == 2 and phzData.choupai or 0
	if phzData.roomType ~= proxy_pb.XXGHZ then
		rule.niao = phzData.niao 
		rule.niaoValue = phzData.niao and phzData.niaoValue or 0
	end
	if phzData.roomType == proxy_pb.SYBP then
		rule.rounds = phzData.rounds
		rule.tianDiHu = true
		rule.heiHongHu = phzData.heiHongHu
		rule.qiHuHuXi = 10
		rule.tunXi = 1
		rule.fanXing = false
		rule.heiHongDian = phzData.heiHongDian
		rule.maxHuXi = phzData.maxHuXi
		rule.zeroToTop = sybpObj.ToggleSYBPZeroToTop:GetComponent('UIToggle').value
	elseif phzData.roomType == proxy_pb.SYZP then
		rule.rounds = phzData.rounds
		rule.qiHuHuXi = phzData.qiHuHuXi
		rule.tunXi = phzData.tunXi
		rule.fanXing = phzData.xingType
		rule.tianDiHu = phzData.tianDiHu
		rule.heiHongHu = phzData.heiHongHu
		rule.bottomScore = phzData.bottomScore
		rule.ziMoAddHu = phzData.ziMoAddHu
	elseif phzData.roomType == proxy_pb.HHHGW then
		rule.rounds = phzData.rounds
		rule.qiHuHuXi = 15
		rule.tianDiHu = true
		rule.heiHongHu = true
		rule.tunXi = 3
		rule.fanXing = false
		rule.bottomScore = phzData.bottomScore
		rule.mode = phzData.mode
		rule.canHuZiMo = phzData.canHuZiMo
		rule.ziMoFan = phzData.ziMoFan
		rule.shiZhongBuLiang = phzData.shiZhongBuLiang
		if phzData.mode == 0 then
			rule.tianHu5Fan = phzData.tianHu5Fan
			rule.diHu4Fan = phzData.diHu4Fan
			rule.da18Fan5 = phzData.da18Fan5
			rule.shiLiuXiao = phzData.shiLiuXiao
		end
		rule.maxHuXi = phzData.maxHuXi
		rule.huangZhuangFen = phzData.huangZhuangFen
	elseif phzData.roomType == proxy_pb.AHPHZ then
		rule.rounds = phzData.rounds
		rule.qiHuHuXi = 15  
		rule.tunXi = phzData.tunXi
		rule.fanXing = false
		rule.bottomScore = phzData.bottomScore  
		rule.paPo = phzData.paPo
		rule.heiHongHu = phzData.heiHongHu
		rule.ziMoAddTun = phzData.ziMoAddTun
		rule.tianHu = phzData.tianhu
		rule.diHu = phzData.dihu
		rule.haiDiHu = phzData.haiDiHu  
		rule.huangZhuangFen = phzData.huangZhuangFen
		rule.huangKeepBanker = phzObj.continueBanker:GetComponent('UIToggle').value
	elseif phzData.roomType == proxy_pb.LDFPF then
		rule.rounds = 0
		rule.tianDiHu = phzData.tianDiHu
		rule.heiHongHu = phzData.heiHongHu
		rule.qiHuHuXi = 15
		rule.tunXi = 1
		rule.fanXing = false
		rule.maxHuXi = phzData.maxHuXi
	elseif phzData.roomType == proxy_pb.CSPHZ then
		rule.rounds = phzData.rounds
		rule.tianDiHu = phzData.tianDiHu
		rule.heiHongHu = phzData.heiHongHu
		rule.qiHuHuXi = 15
		rule.tunXi = 3
		rule.fanXing = false
		rule.ziMoFan = phzData.ziMoFan
		rule.zhaNiao = phzData.zhaNiao
		rule.maxHuXi = phzData.maxHuXi
		rule.huangZhuangFen = phzData.huangZhuangFen
		rule.bottomScore = phzData.bottomScore
	elseif phzData.roomType == proxy_pb.CDPHZ then
		rule.rounds = phzData.rounds
		rule.tianDiHu = phzData.tianDiHu
		rule.heiHongHu = phzData.heiHongHu
		rule.qiHuHuXi = 15
		rule.tunXi = 3
		rule.fanXing = false
		rule.maxHuXi = phzData.maxHuXi
		rule.huangZhuangFen = phzData.huangZhuangFen
		rule.bottomScore = phzData.bottomScore
		rule.quanMingTang = phzData.quanMingTang
		if rule.quanMingTang then
			rule.shuaHou =  cdphzObj.ToggleShuaHou:GetComponent('UIToggle').value
			rule.daTuanYuan = cdphzObj.ToggleDaTuanYuan:GetComponent('UIToggle').value
			rule.tingHu = cdphzObj.ToggleTingHu:GetComponent('UIToggle').value
			rule.hangHangXi = cdphzObj.ToggleHangHangXi:GetComponent('UIToggle').value
			--rule.jiaHangHang = cdphzObj.ToggleJiaHangHang:GetComponent('UIToggle').value		
			rule.hong47	= cdphzObj.ToggleHong47:GetComponent('UIToggle').value			
			rule.huangFan = cdphzObj.ToggleHuangFan:GetComponent('UIToggle').value
		else
			rule.duiDuiHu = cdphzObj.ToggleDuiDuiHu:GetComponent('UIToggle').value
		end
	elseif phzData.roomType == proxy_pb.XXGHZ then
		rule.rounds = 0
		rule.tuo = phzData.tuo
		rule.qiHuHuXi = phzData.qiHuHuXi
		rule.randomBanker = phzData.randomBanker
		print('是不是打坨'..tostring(phzData.tuo))
	elseif phzData.roomType == proxy_pb.HYSHK then
		rule.rounds = phzData.rounds
		rule.randomBanker = phzData.randomBanker
		rule.bottom2Score = phzData.isBaseSocre2
		rule.yiWuShi = phzData.yiWuShi
		rule.fangPao = not phzData.isNoBomb
		rule.haveHuMustHu = phzData.isCantPassHu
		rule.canPiaoHu = phzData.isPiaoHu
		rule.tianDiHaiHu = phzData.isTianDiHaiHu
		rule.canMingWei = phzData.canMingWei
		rule.xiaoHong3Fan = phzData.isXiaoHong3Fan
		rule.xing = phzData.xingTypeHYSHK
		rule.qiHuHuXi = 10
		rule.fangPaoMultiple = phzData.isNoBomb and 1 or phzData.fangpao
	elseif phzData.roomType == proxy_pb.HYLHQ then
		rule.rounds = phzData.rounds
		rule.randomBanker = phzData.randomBanker
		rule.bottom2Score = phzData.isBaseSocre2
		rule.yiWuShi = phzData.yiWuShi
		rule.haveHuMustHu = phzData.isCantPassHu
		rule.heiHongDian = phzData.isHongHeiDian
		rule.tianDiHaiHu = phzData.isTianDiHaiHu
		rule.canMingWei = phzData.canMingWei
		rule.oneHuOneTun = phzData.isYiHYiTun
		rule.liangZhangDianPao = phzData.isLiangPao
		if phzData.size == 4 then
			rule.play21 = false 
		else
			rule.play21 = phzData.play21
		end
		rule.xing = phzData.xingTypeHYLHQ
		rule.qiHuHuXi = phzData.qihuhuxu
	elseif phzData.roomType == proxy_pb.LYZP then
		rule.rounds = phzData.rounds
		rule.liangZhangDianPao = phzData.isLiangPao
		rule.qiHuHuXi = 10
		rule.choiceHu = lyzpObj.ToggleChoiceHu:GetComponent('UIToggle').value and 2 or 0
		rule.maoHu = not lyzpObj.ToggleMaoHu:GetComponent('UIToggle').value
		rule.yiDianHong = not lyzpObj.ToggleYiDianHong:GetComponent('UIToggle').value
		rule.tiAddScore = phzData.tiAddScore
		rule.fanXing = false
	elseif phzData.roomType == proxy_pb.HSPHZ then
		rule.rounds = phzData.rounds
		rule.qiHuHuXi = 15
		rule.qiHuTun = phzData.qiHuTun
		rule.hongDuiHu = phzData.hongDuiHu
		rule.wuDuiHu = phzData.wuDuiHu
		rule.jiaHongDui = phzData.jiaHongDui
		rule.choiceBanker = phzData.choiceBanker
		rule.maxHuXi = phzData.maxHuXi
		rule.huangZhuangFen = phzData.huangZhuangFen
		rule.fanXing = false
	elseif phzData.roomType == proxy_pb.CDDHD then
		rule.rounds = phzData.rounds
		rule.qiHuHuXi = 15
		rule.qiHuTun = phzData.qiHuTun

		rule.tianHu = cddhdObj.ToggleTianHu:GetComponent('UIToggle').value
		rule.diHu = cddhdObj.ToggleDiHu:GetComponent('UIToggle').value
		rule.tingHu = cddhdObj.ToggleTingHu:GetComponent('UIToggle').value
		rule.haiDiHu = cddhdObj.ToggleHaiDiHu:GetComponent('UIToggle').value	
		rule.huangFan = cddhdObj.ToggleHuangFan:GetComponent('UIToggle').value

		rule.maxHuXi = phzData.maxHuXi
		rule.huangZhuangFen = phzData.huangZhuangFen
		rule.fanXing = false
	elseif phzData.roomType == proxy_pb.NXPHZ then
		rule.rounds = phzData.rounds
		rule.qiHuHuXi = phzData.qiHuHuXi
		rule.bottomScore = phzData.bottomScore
		rule.ziMoFan = phzData.ziMoFan
		rule.shiLiuXiao = phzData.shiLiuXiao
		rule.haiDiHu = phzData.haiDiHu
		rule.shuaHou = phzData.shuaHou
		rule.add1When27 = phzData.add1When27
		rule.addHongXiaoDa = phzData.addHongXiaoDa
		rule.ziMoAddTun = phzData.ziMoAddTun
		rule.zhaNiao = phzData.zhaNiao
		rule.huangZhuangFen = phzData.huangZhuangFen
		rule.maxHuXi = phzData.maxHuXi
		rule.fanXing = false
	elseif phzData.roomType == proxy_pb.XTPHZ then
		rule.rounds = phzData.rounds
		rule.qiHuHuXi = phzData.qiHuHuXi
		rule.bottomScore = phzData.bottomScore
		rule.calculationTunMode = phzData.calculationTunMode
		rule.yiWuShi = phzData.yiWuShi
		rule.shiZhongBuLiang = phzData.shiZhongBuLiang
		rule.hu30FangBei = phzData.hu30FangBei
		rule.tianDiHu = phzData.tianDiHu
		rule.pengPengHu = phzData.pengPengHu
		rule.daXiaoZiHu = phzData.daXiaoZiHu
		rule.yiDianHong = phzData.yiDianHong
		rule.heiHongHu = phzData.heiHongHu
		if phzData.heiHongHu then
			rule.hong13 = phzData.hong13
		end
		rule.canHuZiMo = phzData.canHuZiMo
		rule.canMingWei = phzData.canMingWei
		if not phzData.canMingWei then
			rule.chouWeiLiang = phzData.chouWeiLiang
		end
		rule.calculationFanMode = phzData.calculationFanMode  
		rule.huangZhuangFen = phzData.huangZhuangFen
		rule.maxHuXi = phzData.maxHuXi
		rule.fanXing = false
	elseif phzData.roomType == proxy_pb.YXPHZ then
		rule.rounds = phzData.rounds
		rule.qiHuHuXi = 0
		rule.mode = phzData.mode
		rule.haveHuMustHu = yxphzObj.ToggleYouHuBiHu:GetComponent('UIToggle').value
		rule.huangZhuangFen = phzData.huangZhuangFen
		rule.fanXing = false
	elseif phzData.roomType == proxy_pb.YJGHZ then
		rule.rounds = phzData.rounds
		rule.qiHuHuXi = 5
		rule.mode = phzData.mode
		rule.piao = yjghzObj.ToggleBuKePiao:GetComponent('UIToggle').value and 0 or 1
		rule.jiuDuiBan = yjghzObj.ToggleJiuDuiBan:GetComponent('UIToggle').value
		rule.wuXiPing = yjghzObj.ToggleWuXiPing:GetComponent('UIToggle').value
		rule.diaoDiaoShou = yjghzObj.ToggleDiaoDiaoShou50Xi:GetComponent('UIToggle').value
		rule.hangHangXi2Fan = yjghzObj.ToggleXingXingXi2Fan:GetComponent('UIToggle').value
		rule.tianHu = yjghzObj.ToggleTianHu:GetComponent('UIToggle').value
		rule.diHu = yjghzObj.ToggleDiHu:GetComponent('UIToggle').value
		rule.haiDiHu = yjghzObj.ToggleHaiDiHu:GetComponent('UIToggle').value
		rule.maxHuXi = phzData.maxHuXi
		rule.huangZhuangFen = phzData.huangZhuangFen
		rule.huangKeepBanker = phzObj.continueBanker:GetComponent('UIToggle').value
		rule.fanXing = false
	elseif phzData.roomType == proxy_pb.CZZP then
		rule.rounds = phzData.rounds
		rule.qiHuHuXi = phzData.qiHuHuXi
		rule.calculationTunMode = phzData.calculationTunMode
		local calculationFanMode = 0
		local qihutun = czzpObj.ToggleQiHu9Xi1Tun:GetComponent('UIToggle').value and 0 or 1
		print('qihutun :'..qihutun)
		if phzData.qiHuHuXi == 3 then
			if phzData.calculationTunMode == 0 then
				calculationFanMode = 0
			elseif phzData.calculationTunMode == 1 then
				calculationFanMode = qihutun == 0 and 0 or 1
			end
		elseif phzData.qiHuHuXi == 6 then
			if phzData.calculationTunMode == 0 then
				calculationFanMode = qihutun == 0 and 2 or 4
			elseif phzData.calculationTunMode == 1 then
				calculationFanMode = qihutun == 0 and 2 or 3
			end
		elseif phzData.qiHuHuXi == 9 then	
			if phzData.calculationTunMode == 0 then
				calculationFanMode = qihutun == 0 and 5 or 6
			elseif phzData.calculationTunMode == 1 then
				calculationFanMode = qihutun == 0 and 5 or 7
			end
		end
		rule.calculationFanMode = calculationFanMode
		rule.classic = phzData.classic
		rule.ziMoFan = phzData.ziMoFan
		rule.choiceHu = phzData.choiceHu
		if rule.classic == 1 then
			rule.daXiaoZiHu = phzData.daXiaoZiHu
		else
			rule.daXiaoZiHu = false
		end
		rule.play21 = phzData.play21
		rule.maoHuHuXi = phzData.maoHuHuXi
		rule.huangZhuangFen = phzData.huangZhuangFen 
		rule.huangKeepBanker = phzObj.continueBanker:GetComponent('UIToggle').value
		rule.piao = phzData.piao
		if phzData.piao == 0 then
			rule.niao = phzData.niao
			rule.niaoValue =  phzData.niao and phzData.niaoValue or 0
		else
			rule.niao = false
			rule.niaoValue = 0
		end
		rule.fanXing = false
	end
	local str = 'rule======'
	for k,v in pairs(rule) do
		str = str .. k .. ':'..tostring(v)..breakString(true)
	end
	print(str)
	local msg = Message.New()
	if curSelectPlay.optionData.addPlay and not curSelectPlay.optionData.addRule then
		msg.type = proxy_pb.CREATE_CLUB_PLAY
		local body=proxy_pb.PCreateClubPlay()
		body.clubId = panelClub.clubInfo.clubId
		body.name = curSelectPlay.name
		body.gameType = curSelectPlay.gameType
		body.settings = json:encode(rule)
		body.roomType = phzData.roomType
		msg.body = body:SerializeToString()
		print('body.roomType '..body.roomType)
    	SendProxyMessage(msg, this.OnCreateClubPlay)
	elseif not curSelectPlay.optionData.addPlay and curSelectPlay.optionData.addRule then
		msg.type = proxy_pb.CREATE_PLAY_RULE
		local body = proxy_pb.PCreatePlayRule()
		body.playId = curSelectPlay.playId
		body.clubId = panelClub.clubInfo.clubId
		body.settings = json:encode(rule)
		body.gameType = proxy_pb.PHZ
		--print('PlayID:'..body.playId)
		msg.body = body:SerializeToString()
		SendProxyMessage(msg, this.OnCreateClubResult)
	elseif not curSelectPlay.optionData.addPlay and not curSelectPlay.optionData.addRule then	
		msg.type = proxy_pb.UPDATE_PLAY_RULE
		local body = proxy_pb.PUpdatePlayRule()
		body.playId = curSelectPlay.playId
		body.ruleId = curSelectPlay.ruleId
		body.clubId = panelClub.clubInfo.clubId
		body.settings = json:encode(rule)
		msg.body = body:SerializeToString()
		SendProxyMessage(msg, this.OnUpdateClubResult)
	end
end

function this.OnCreateClubPlay(msg)
    local b = proxy_pb.RCreateClubPlay()
	b:ParseFromString(msg.body)
	if b.playId ~= nil and b.playId ~= '' then
		PanelManager.Instance:HideWindow(gameObject.name)
        panelMessageTip.SetParamers('玩法创建成功', 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
		if panelSetPlay then
			panelSetPlay.PlayRuleInfos()
		end
	end
end

function this.OnCreateClubResult(msg)
	if panelClub.clubInfo.userType==proxy_pb.GENERAL then
		panelMessageTip.SetParamers('请联系管理员修改玩法', 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	else
		local b = proxy_pb.RResult()
		b:ParseFromString(msg.body)
		print("操作是否成功："..b.code..",消息："..b.msg)
		if b.code==1 then
			PanelManager.Instance:HideWindow(gameObject.name)
			panelMessageTip.SetParamers('规则创建成功', 1.5)
			PanelManager.Instance:ShowWindow('panelMessageTip')
			if panelSetPlay then
				panelSetPlay.PlayRuleInfos()
			end
		else
			panelMessageTip.SetParamers('修改失败，原因：'..b.msg, 1.5)
			PanelManager.Instance:ShowWindow('panelMessageTip')
		end
	end
end

function this.OnUpdateClubResult(msg)
	print('OnUpdateClubResult')
	if panelClub.clubInfo.userType==proxy_pb.GENERAL then
		panelMessageTip.SetParamers('请联系管理员修改玩法', 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	else
		local b = proxy_pb.RResult()
		b:ParseFromString(msg.body)
		print("操作是否成功："..b.code..",消息："..b.msg)
		if b.code==1 then
			PanelManager.Instance:HideWindow(gameObject.name)
			panelMessageTip.SetParamers('规则修改成功', 1.5)
			PanelManager.Instance:ShowWindow('panelMessageTip')
			if panelSetPlay then
				panelSetPlay.PlayRuleInfos()
			end
		else
			panelMessageTip.SetParamers('修改失败，原因：'..b.msg, 1.5)
			PanelManager.Instance:ShowWindow('panelMessageTip')
		end
	end
end

function this.OnClickSettlementScoreSelect(go)
	AudioManager.Instance:PlayAudio('btn')
    phzData.isSettlementScore= phzObj.ToggleSettlementScoreSelect:GetComponent('UIToggle').value
end

function this.OnClickFewerButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if phzObj.ToggleFewerAddButton.gameObject == go then
		phzData.fewerValue = phzData.fewerValue + 1
		if phzData.fewerValue > 100 then
			phzData.fewerValue = 100
		end
    elseif phzObj.ToggleFewerSubtractButton.gameObject == go then
		phzData.fewerValue = phzData.fewerValue - 1
		if phzData.fewerValue < 1 then
			phzData.fewerValue = 1
		end
	end
	phzObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = phzData.fewerValue
end

function this.OnClickAddButton(go)
	AudioManager.Instance:PlayAudio('btn')
    if phzObj.ToggleAddAddButton.gameObject == go then
		phzData.addValue = phzData.addValue + 1
		if phzData.addValue > 100 then
			phzData.addValue = 100
		end
    elseif phzObj.ToggleAddSubtractButton.gameObject == go then
		phzData.addValue = phzData.addValue - 1
		if phzData.addValue < 1 then
			phzData.addValue = 1
		end
	end
	phzObj.ToggleAddScoreTxt:GetComponent('UILabel').text = phzData.addValue
end

function this.OnDelegateTimeClick(go)
	if go == phzObj.ToggleNoDelegate.gameObject then
		phzData.trusteeship =0
	elseif go == phzObj.ToggleDelegate1.gameObject then
		phzData.trusteeship = 60
	elseif go == phzObj.ToggleDelegate2.gameObject then
		phzData.trusteeship = 120
	elseif go == phzObj.ToggleDelegate3.gameObject then
		phzData.trusteeship = 180
	elseif go == phzObj.ToggleDelegate5.gameObject then
		phzData.trusteeship = 300
	end
	phzObj.ToggleDelegateThisRound.parent.gameObject:SetActive(phzData.trusteeship ~= 0)
	optionTable:GetComponent('UIGrid'):Reposition()
end

function this.OnDelegateDissolveClick(go)
	if go == phzObj.ToggleDelegateThisRound.gameObject then
		phzData.trusteeshipDissolve = true
		phzData.trusteeshipRound = 0
	elseif go == phzObj.ToggleDelegateFullRound.gameObject then
		phzData.trusteeshipDissolve = false
		phzData.trusteeshipRound = 0
	elseif go == phzObj.ToggleDelegateThreeRound.gameObject then
		phzData.trusteeshipDissolve = false
		phzData.trusteeshipRound = 3
	end
end

function this.OnClickPreventCheat(go)
	if phzObj.ToggleIPcheck.gameObject == go then
		phzData.openIp = phzObj.ToggleIPcheck:GetComponent('UIToggle').value 
	elseif phzObj.ToggleGPScheck.gameObject == go then
		phzData.openGps = phzObj.ToggleGPScheck:GetComponent('UIToggle').value
	end
end

function this.OnClickToggleTiAddScore(go)
	AudioManager.Instance:PlayAudio('btn')
	if lyzpObj.ToggleTiAddScore0.gameObject == go then
        phzData.tiAddScore=0
    elseif lyzpObj.ToggleTiAddScore1.gameObject == go then
        phzData.tiAddScore=1
    elseif lyzpObj.ToggleTiAddScore2.gameObject == go then
        phzData.tiAddScore=2
	end
end

function this.OnClickChangeQiHuTunValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if hsphzObj.AddBtnQiHuTun.gameObject == go then
		phzData.qiHuTun = phzData.qiHuTun + 1
		if phzData.qiHuTun > 10 then
			phzData.qiHuTun = 10
		end
    else
		phzData.qiHuTun = phzData.qiHuTun - 1
		if phzData.qiHuTun < 1 then
			phzData.qiHuTun = 1
		end
	end
	if phzData.roomType == proxy_pb.HSPHZ then
		hsphzObj.QiHuTunValue:GetComponent("UILabel").text = '倒'..phzData.qiHuTun
	else
		hsphzObj.QiHuTunValue:GetComponent("UILabel").text = phzData.qiHuTun..'等'
	end
	
end

function this.OnClickChangeFengDingValue(go)
	AudioManager.Instance:PlayAudio('btn')
	local changeValue = 0
	local maxValue = 0
	local minValue = 0
	if phzData.roomType == proxy_pb.CDPHZ then
		changeValue = 50
		maxValue = 500
		minValue = 50
	elseif phzData.roomType == proxy_pb.HSPHZ then
		changeValue = 10
		maxValue = 80
		minValue = 10
	elseif phzData.roomType == proxy_pb.XTPHZ then
		changeValue = 100
		maxValue = 500
		minValue = 100
	elseif phzData.roomType == proxy_pb.YJGHZ then
		changeValue = 100
		maxValue = 800
		minValue = 100
	end
	if phzObj.AddBtnFengDing.gameObject == go then
		if phzData.maxHuXi ~= 0 then
			phzData.maxHuXi = phzData.maxHuXi + changeValue
			if phzData.maxHuXi > maxValue then
				if phzData.roomType == proxy_pb.YJGHZ then
					phzData.maxHuXi = maxValue
				else
					phzData.maxHuXi = 0
				end
			end
        end
    else
		if phzData.maxHuXi == 0 then
			phzData.maxHuXi = maxValue
		else
			phzData.maxHuXi = phzData.maxHuXi - changeValue
			if phzData.maxHuXi < minValue then
				phzData.maxHuXi = minValue
			end
        end
    end
	phzObj.FengDingValue:GetComponent("UILabel").text = phzData.maxHuXi == 0 and '不封顶' or phzData.maxHuXi..'分'
end

function this.OnClickChangeHuangZhuangKouFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	local changeValue = 0
	local maxValue = 0
	local minValue = 0
	if phzData.roomType == proxy_pb.YJGHZ then
		changeValue = 5
		maxValue = 100
		minValue = 10
	else
		changeValue = 1
		maxValue = 10
		minValue = 1
	end
	if phzObj.AddBtnHuangZhuangKouFen.gameObject == go then
		phzData.huangZhuangFen = phzData.huangZhuangFen + changeValue
		if phzData.huangZhuangFen > maxValue then
			phzData.huangZhuangFen = maxValue
		elseif phzData.huangZhuangFen == changeValue then
			phzData.huangZhuangFen = minValue
		end
    else
		phzData.huangZhuangFen = phzData.huangZhuangFen - changeValue
		if phzData.huangZhuangFen < minValue then
			phzData.huangZhuangFen = 0
		end
    end
	phzObj.HuangZhuangKouFenValue:GetComponent("UILabel").text = phzData.huangZhuangFen == 0 and '不扣分' or '扣'..phzData.huangZhuangFen..'分'
end

function this.OnClickSelectBanker(go)
	AudioManager.Instance:PlayAudio('btn')
	if hsphzObj.ToggleWinBanker.gameObject == go then
        phzData.choiceBanker = 0
    elseif hsphzObj.ToggleLoopBanker.gameObject == go then
        phzData.choiceBanker = 1
	end
end

function this.OnClickToggleWuDui(go)
	AudioManager.Instance:PlayAudio('btn')
	phzData.wuDuiHu = hsphzObj.ToggleWuDui:GetComponent('UIToggle').value
end

function this.OnClickToggleHongDui(go)
	AudioManager.Instance:PlayAudio('btn')
	phzData.hongDuiHu = hsphzObj.ToggleHongDui:GetComponent('UIToggle').value
end
function this.OnClickToggleJiaHongDui(go)
	AudioManager.Instance:PlayAudio('btn')
	phzData.jiaHongDui = hsphzObj.ToggleJiaHongDui:GetComponent('UIToggle').value
end

function this.OnClickChangeDiFenValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if phzObj.AddBtnDiFen.gameObject == go then
		phzData.bottomScore = phzData.bottomScore + 1
		if phzData.bottomScore > 10 then
			phzData.bottomScore = 10
		end
    elseif phzObj.SubtractBtnDiFen.gameObject == go then
        phzData.bottomScore = phzData.bottomScore - 1
		if phzData.bottomScore < 1 then
			phzData.bottomScore = 1
		end
	end
	phzObj.DiFenTunValue:GetComponent("UILabel").text = phzData.bottomScore..'分'
end

function this.OnClickToggleZiMoFanBei(go)
	AudioManager.Instance:PlayAudio('btn')
	if nxphzObj.ToggleZiMoFanBei:GetComponent('UIToggle').value then
		phzData.ziMoFan = 2
	else
		phzData.ziMoFan = 0
	end
end

function this.OnClickToggleShiLiuXiao(go)
	AudioManager.Instance:PlayAudio('btn')
	phzData.shiLiuXiao = nxphzObj.ToggleShiLiuXiao:GetComponent('UIToggle').value
end

function this.OnClickToggleHaiDiHu(go)
	AudioManager.Instance:PlayAudio('btn')
	phzData.haiDiHu = nxphzObj.ToggleHaiDiHu:GetComponent('UIToggle').value
end

function this.OnClickToggleShuaHou(go)
	AudioManager.Instance:PlayAudio('btn')
	phzData.shuaHou = nxphzObj.ToggleShuaHou:GetComponent('UIToggle').value
end

function this.OnClickToggleAdd1When27(go)
	AudioManager.Instance:PlayAudio('btn')
	phzData.add1When27 = nxphzObj.ToggleAdd1When27:GetComponent('UIToggle').value
end

function this.OnClickToggleAddHongXiaoDa(go)
	AudioManager.Instance:PlayAudio('btn')
	phzData.addHongXiaoDa = nxphzObj.ToggleAddHongXiaoDa:GetComponent('UIToggle').value
end

function this.OnClickToggleZiMoAddTun(go)
	AudioManager.Instance:PlayAudio('btn')
    if nxphzObj.ToggleZiMoAddTun0.gameObject == go then
        phzData.ziMoAddTun = 0
	elseif nxphzObj.ToggleZiMoAddTun1.gameObject == go then
        phzData.ziMoAddTun = 1
    elseif nxphzObj.ToggleZiMoAddTun2.gameObject == go then
        phzData.ziMoAddTun = 2
	end
end

function this.OnClickChangeZhaNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn')
	if phzObj.AddBtnZhaNiao.gameObject == go then
		phzData.zhaNiao = phzData.zhaNiao + 1
		if phzData.zhaNiao > 10 then
			phzData.zhaNiao = 10
		end
    else
		phzData.zhaNiao = phzData.zhaNiao - 1
		if phzData.zhaNiao < 0 then
			phzData.zhaNiao = 0
		end
    end
	phzObj.ZhaNiaoValue:GetComponent("UILabel").text = phzData.zhaNiao == 0 and '不扎鸟' or (phzData.zhaNiao..'分')
end

function this.OnClickHuXiSuanFen(go)
	AudioManager.Instance:PlayAudio('btn')
    if phzObj.ToggleSanXiYiTun.gameObject == go then
        phzData.calculationTunMode = 0
	elseif phzObj.ToggleYiXiYiTun.gameObject == go then
        phzData.calculationTunMode = 1
    elseif phzObj.ToggleFengSanJinSan.gameObject == go then
        phzData.calculationTunMode = 2
	end
	if phzData.roomType == proxy_pb.CZZP then
		this.SetShowQiHuTun()
		if phzData.qiHuHuXi == 3 and phzData.calculationTunMode == 0 then
			czzpObj.ToggleQiHu9Xi1Tun:GetComponent('UIToggle'):Set(true)
			czzpObj.ToggleQiHu9Xi3Tun:GetComponent('UIToggle'):Set(false)	
		end
	end
end
function this.OnClickToggleXTPHZPlay(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == xtphzObj.ToggleYiWuShi.gameObject then
		phzData.yiWuShi = xtphzObj.ToggleYiWuShi:GetComponent('UIToggle').value
	elseif go == xtphzObj.ToggleShiZhongBuLiang.gameObject then
		phzData.shiZhongBuLiang = xtphzObj.ToggleShiZhongBuLiang:GetComponent('UIToggle').value
	elseif go == xtphzObj.ToggleHu30FangBei.gameObject then
		phzData.hu30FangBei = xtphzObj.ToggleHu30FangBei:GetComponent('UIToggle').value
	elseif go == xtphzObj.ToggleTianDiHu.gameObject then
		phzData.tianDiHu = xtphzObj.ToggleTianDiHu:GetComponent('UIToggle').value
	elseif go == xtphzObj.TogglePengPengHu.gameObject then
		phzData.pengPengHu = xtphzObj.TogglePengPengHu:GetComponent('UIToggle').value
	elseif go == xtphzObj.ToggleDaXiaoZiHu.gameObject then
		phzData.daXiaoZiHu = xtphzObj.ToggleDaXiaoZiHu:GetComponent('UIToggle').value
	elseif go == xtphzObj.ToggleYiDianHong.gameObject then
		phzData.yiDianHong = xtphzObj.ToggleYiDianHong:GetComponent('UIToggle').value
	elseif go == xtphzObj.ToggleHeiHongHu.gameObject then
		phzData.heiHongHu = xtphzObj.ToggleHeiHongHu:GetComponent('UIToggle').value
		xtphzObj.ToggleHong13.gameObject:SetActive(phzData.heiHongHu)
	elseif go == xtphzObj.ToggleHong13.gameObject then
		phzData.hong13 = xtphzObj.ToggleHong13:GetComponent('UIToggle').value
	elseif go == xtphzObj.ToggleCanHuZiMo.gameObject then
		phzData.canHuZiMo = xtphzObj.ToggleCanHuZiMo:GetComponent('UIToggle').value
	elseif go == xtphzObj.ToggleCanAnWei.gameObject then
		phzData.canMingWei = not xtphzObj.ToggleCanAnWei:GetComponent('UIToggle').value
		xtphzObj.ToggleChouWeiLiang.gameObject:SetActive(not phzData.canMingWei)
	elseif go == xtphzObj.ToggleChouWeiLiang.gameObject then
		phzData.chouWeiLiang = xtphzObj.ToggleChouWeiLiang:GetComponent('UIToggle').value
	end
end

function this.OnClickToggleFanShuSuanFen(go)
	AudioManager.Instance:PlayAudio('btn')
    if xtphzObj.ToggleFanShuChen.gameObject == go then
        phzData.calculationFanMode = 0
    elseif xtphzObj.ToggleFanShuJia.gameObject == go then
		phzData.calculationFanMode = 1
	elseif xtphzObj.TogglefanShuYiBei.gameObject == go then
        phzData.calculationFanMode = 2
	end
end

function this.OnClickSYBPPlay(go)
	AudioManager.Instance:PlayAudio('btn')
	phzData.rounds = sybpObj.Toggle1RoundEnd:GetComponent('UIToggle').value and 1 or 0
	payLabel:GetComponent("UILabel").text = GetPayMun(phzData.roomType,phzData.rounds,phzData.size,nil)
end
function this.OnClickModeSettingYXPHZ(go)
	AudioManager.Instance:PlayAudio('btn')
    if yxphzObj.ToggleLianZhuang.gameObject == go then
        phzData.mode = 0
    elseif yxphzObj.ToggleZhongZhuang.gameObject == go then
        phzData.mode = 1
    end
end

function this.OnClickModeSettingYJGHZ(go)
	AudioManager.Instance:PlayAudio('btn')
    if yjghzObj.ToggleWai5Kan5.gameObject == go then
        phzData.mode = 0
    elseif yjghzObj.ToggleWai10Kan10.gameObject == go then
        phzData.mode = 1
	end
	yjghzObj.ToggleDiaoDiaoShou50Xi:Find('Label'):GetComponent("UILabel").text = phzData.mode == 0 and '吊吊手50息' or '吊吊手100息'
end
function this.SetShowQiHuTun()
	local str1 = ''
	local str2 = ''
	if phzData.qiHuHuXi == 3 then
		str1 = '起胡3息1囤'
		str2 = phzData.calculationTunMode == 0 and '' or '起胡3息3囤'
	elseif phzData.qiHuHuXi == 6 then
		str1 = '起胡6息1囤'
		str2 = phzData.calculationTunMode == 0 and '起胡6息2囤' or '起胡6息6囤'
	elseif phzData.qiHuHuXi == 9 then
		str1 = '起胡9息1囤'
		str2 = phzData.calculationTunMode == 0 and '起胡9息3囤' or '起胡9息9囤'
	end
	czzpObj.ToggleQiHu9Xi1Tun:Find('Label'):GetComponent('UILabel').text = str1
	czzpObj.ToggleQiHu9Xi3Tun:Find('Label'):GetComponent('UILabel').text = str2
	czzpObj.ToggleQiHu9Xi3Tun.gameObject:SetActive(not (phzData.qiHuHuXi == 3 and phzData.calculationTunMode == 0))
end

function this.OnClickClassic(go)
	AudioManager.Instance:PlayAudio('btn')
    if czzpObj.ToggleQClassic0.gameObject == go then
        phzData.classic = 0
    elseif czzpObj.ToggleQClassic1.gameObject == go then
		phzData.classic = 1
	elseif czzpObj.ToggleQClassic2.gameObject == go then
        phzData.classic = 2
	end
	czzpObj.ToggleDaXiaoHongHu.gameObject:SetActive(phzData.classic == 1)
end
function this.OnClickToggleCZZPPlay(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == czzpObj.ToggleZiMoFan.gameObject then
		phzData.ziMoFan = czzpObj.ToggleZiMoFan:GetComponent('UIToggle').value and 2 or 0
	elseif go == czzpObj.ToggleYouHuBiHu.gameObject then
		if czzpObj.ToggleYouHuBiHu:GetComponent('UIToggle').value then
			phzData.choiceHu = 1
		else
			if czzpObj.ToggleFangPaoBiHu:GetComponent('UIToggle').value then
				phzData.choiceHu = 2
			else
				phzData.choiceHu = 0
			end
		end
		czzpObj.ToggleFangPaoBiHu.gameObject:SetActive(phzData.choiceHu ~= 1)
	elseif go == czzpObj.ToggleFangPaoBiHu.gameObject then
		phzData.choiceHu = czzpObj.ToggleFangPaoBiHu:GetComponent('UIToggle').value and 2 or 0
	elseif go == czzpObj.ToggleDaXiaoHongHu.gameObject then
		phzData.daXiaoZiHu = czzpObj.ToggleDaXiaoHongHu:GetComponent('UIToggle').value
	elseif go == czzpObj.TogglePlay15.gameObject then
		phzData.play21 = not czzpObj.TogglePlay15:GetComponent('UIToggle').value
	end
end
function this.OnClickMaoHuType(go)
	AudioManager.Instance:PlayAudio('btn')
	phzData.maoHuHuXi = tonumber(go.name)
	local maoHuHuXi = ''
	if phzData.maoHuHuXi == 0 then
		maoHuHuXi = '无毛胡'
	else
		maoHuHuXi = '毛胡'..phzData.maoHuHuXi..'胡'
	end
	czzpObj.MaoHuLabel:GetComponent('UILabel').text = maoHuHuXi
	czzpObj.maoHuType.gameObject:SetActive(false)
end

function this.OnClickTogglePiao(go)
	AudioManager.Instance:PlayAudio('btn')
	phzData.piao=tonumber(go.name)
	if phzData.piao ~= 0 then
		this.OnClickNiao(phzObj.ToggleOffNiao.gameObject)
		phzObj.ToggleOnNiao:GetComponent('UIToggle'):Set(phzData.niao)
		phzObj.ToggleOffNiao:GetComponent('UIToggle'):Set(not phzData.niao)
	end
end

