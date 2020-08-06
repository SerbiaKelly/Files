
local proxy_pb = require 'proxy_pb'
local pdk_pb = require 'pdk_pb'
local json = require 'json'

panelCreateMJSet = {}
local this = panelCreateMJSet;

local message;
local gameObject;

local wanFaTitle --玩法

local tip -- 提示

local ButtonOK
local ButtonClose
local mask

local bird = 0
local niaoValue = 100;

local QiaoMaCon
local ZhuanMaCon
local HongZhongMaCon

local dragPanelZhuan
local dragPanelHongZhong
local dragPanelChangsha

local CSM = 50; 	-- 长沙麻将
local ZZM = 51; 	-- 转转麻将
local HZM = 52; 	-- 红中麻将

local QiaoMaType = 0
local ZhuanMaType = 1
local HongZhongMaType = 2--红中麻将
local roomType = ZhuanMaType
local birds = 0
local rounds = 0
local gameName;  	--游戏名字
local payLabel

local numberOfPeople = 2; -- 麻将的人数

local curSelectPlay = {}

--长沙麻将
local csmObj = {}
--转转麻将
local zzmObj = {}
--红中麻将
local hzmObj={}
--启动事件--
function this.Awake(obj)
	gameObject 			= obj;
	wanFaTitle 			= gameObject.transform:Find('title/Label')

	QiaoMaCon                  = gameObject.transform:Find('Content/QiaoMa')
	ZhuanMaCon                 = gameObject.transform:Find('Content/ZhuanMa')
	HongZhongMaCon				= gameObject.transform:Find('Content/HongZhongMa')

	dragPanelZhuan				= gameObject.transform:Find('Content/dragPanel_0')
	dragPanelHongZhong			= gameObject.transform:Find('Content/dragPanel_1')
	dragPanelChangsha 			= gameObject.transform:Find('Content/dragPanel_2')
	
	this.GetChangShaMaObj();
	this.GetZhuanZhuanMaObj();
	this.GetHongzhongMaObj();


	payLabel 			= gameObject.transform:Find('pay_label');
	ButtonClose 		= gameObject.transform:Find('ButtonClose');
	tip 				= gameObject.transform:Find('tip');
    ButtonOK 			= gameObject.transform:Find('ButtonOK/Background');
    mask 				= gameObject.transform:Find('mask');
	message 			= gameObject:GetComponent('LuaBehaviour');


	--长沙麻将
	this.BindChangShaEvents();

	--转转麻将
	this.BindZhuanEvents();

	--红中麻将
	this.BindHongZhongEvents();

	--通用
    message:AddClick(ButtonOK.gameObject, this.OnClickButtonOK);
	message:AddClick(ButtonClose.gameObject, this.OnClickMask);
	message:AddClick(gameObject.transform:Find('RuleButton').gameObject, this.ShowRuleInfo)
end
function this.Start()
end

function this.Update()
end

function this.BindChangShaEvents()
	message:AddClick(csmObj.PeopleNumber2.gameObject, this.OnClickCSPeopleChoose)
	message:AddClick(csmObj.PeopleNumber3.gameObject, this.OnClickCSPeopleChoose)
	message:AddClick(csmObj.PeopleNumber4.gameObject, this.OnClickCSPeopleChoose)
	message:AddClick(csmObj.lessPlayerStart.gameObject, this.OnClickCSLessPlayerStart)

	message:AddClick(csmObj.ToggleRound8.gameObject, this.UpdatePlayLab)
	message:AddClick(csmObj.ToggleRound16.gameObject, this.UpdatePlayLab)

	message:AddClick(csmObj.ToggleWinPos.gameObject, this.OnClickToggleNiaoType)
	message:AddClick(csmObj.Toggle13579Bird.gameObject, this.OnClickToggleNiaoType)
	message:AddClick(csmObj.ToggleNoBird.gameObject, this.OnClickToggleNiaoType)

	message:AddClick(csmObj.NoDelegateTime.gameObject,this.OnClickDelegateButton)
	message:AddClick(csmObj.DelegateTime1.gameObject,this.OnClickDelegateButton)
	message:AddClick(csmObj.DelegateTime2.gameObject,this.OnClickDelegateButton)
	message:AddClick(csmObj.DelegateTime3.gameObject,this.OnClickDelegateButton)
	message:AddClick(csmObj.DelegateTime5.gameObject,this.OnClickDelegateButton)

	message:AddClick(csmObj.CustomizePiaofen.gameObject,this.OnClickPiaoFen)

	message:AddClick(csmObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButtonCSM)
	message:AddClick(csmObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButtonCSM)
	message:AddClick(csmObj.ToggleAddAddButton.gameObject, this.OnClickAddButtonCSM)
	message:AddClick(csmObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButtonCSM)

	message:AddClick(csmObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDoubleCSM)
	message:AddClick(csmObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDoubleCSM)
	message:AddClick(csmObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScoreCSM)
	message:AddClick(csmObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScoreCSM)

	message:AddClick(csmObj.ToggleMultiple2.gameObject, this.OnClickMultipleCSM)
	message:AddClick(csmObj.ToggleMultiple3.gameObject, this.OnClickMultipleCSM)
	message:AddClick(csmObj.ToggleMultiple4.gameObject, this.OnClickMultipleCSM)

	message:AddClick(csmObj.QueYiMen.gameObject, this.OnClickQueYiMenCSM)
	

	message:AddClick(csmObj.ToggleRegularScoreOnButton.gameObject, this.OnClickRegularScore)
	message:AddClick(csmObj.ToggleRegularScoreOffButton.gameObject, this.OnClickRegularScore)
	message:AddClick(csmObj.RegularAddButton.gameObject, this.OnClickChangeRegularScore)
	message:AddClick(csmObj.RegularSubtractButton.gameObject, this.OnClickChangeRegularScore)
end

function this.BindHongZhongEvents()

	message:AddClick( hzmObj.hit159bird.gameObject,this.OnClickButtonZhuaNiao_HongZhong);
	message:AddClick( hzmObj.Winbird.gameObject,this.OnClickButtonZhuaNiao_HongZhong);
	message:AddClick( hzmObj.BirdOneShoot.gameObject,this.OnClickButtonZhuaNiao_HongZhong);
	message:AddClick( hzmObj.Nobird.gameObject,this.OnClickButtonZhuaNiao_HongZhong);
	message:AddClick( hzmObj.DealerBird.gameObject,this.OnClickButtonZhuaNiao_HongZhong);

	message:AddClick( hzmObj.QiangGangEqualDianPao.gameObject,this.OnClickButtonQiangGang);
	message:AddClick( hzmObj.Nothing.gameObject,this.OnClickButtonQiangGang);
	message:AddClick( hzmObj.GangEqualZimo.gameObject,this.OnClickButtonQiangGang);

	message:AddClick( hzmObj.People2.gameObject, this.OnClickPeopleChooseHZM)
	message:AddClick( hzmObj.People4.gameObject, this.OnClickPeopleChooseHZM)
	message:AddClick( hzmObj.People3.gameObject, this.OnClickPeopleChooseHZM)
	message:AddClick( hzmObj.lessPlayerStart.gameObject, this.OnClickHZLessPlayerStart)

	message:AddClick( hzmObj.Round4.gameObject, this.UpdatePlayLab)
	message:AddClick( hzmObj.Round8.gameObject, this.UpdatePlayLab)
	message:AddClick( hzmObj.Round16.gameObject, this.UpdatePlayLab)

	message:AddClick( hzmObj.NoDelegateTime.gameObject,this.OnClickDelegateButton);
	message:AddClick( hzmObj.DelegateTime1.gameObject,this.OnClickDelegateButton);
	message:AddClick( hzmObj.DelegateTime2.gameObject,this.OnClickDelegateButton);
	message:AddClick( hzmObj.DelegateTime3.gameObject,this.OnClickDelegateButton);
	message:AddClick( hzmObj.DelegateTime5.gameObject,this.OnClickDelegateButton);

	message:AddClick( hzmObj.ToggleOnNiao.gameObject,this.OnClickChooseNiao);
	message:AddClick( hzmObj.ToggleOffNiao.gameObject,this.OnClickChooseNiao);
	message:AddClick( hzmObj.AddButtonNiao.gameObject,this.OnClickChangeNiaoValue);
	message:AddClick( hzmObj.SubtractButtonNiao.gameObject,this.OnClickChangeNiaoValue);

	message:AddClick( hzmObj.PiaoFen.gameObject,this.OnClickPiaoFen);

	message:AddClick( hzmObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButtonHZM)
	message:AddClick( hzmObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButtonHZM)
	message:AddClick( hzmObj.ToggleAddAddButton.gameObject, this.OnClickAddButtonHZM)
	message:AddClick( hzmObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButtonHZM)
	

	message:AddClick( hzmObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDoubleHZM)
	message:AddClick( hzmObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDoubleHZM)
	message:AddClick( hzmObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScoreHZM)
	message:AddClick( hzmObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScoreHZM)

	message:AddClick( hzmObj.ToggleMultiple2.gameObject, this.OnClickMultipleHZM)
	message:AddClick( hzmObj.ToggleMultiple3.gameObject, this.OnClickMultipleHZM)
	message:AddClick( hzmObj.ToggleMultiple4.gameObject, this.OnClickMultipleHZM)
	message:AddClick(hzmObj.AddBtnDiFen.gameObject, this.OnClickChangeDiFenValueHZM)
	message:AddClick(hzmObj.SubtractBtnDiFen.gameObject, this.OnClickChangeDiFenValueHZM)
end

function this.BindZhuanEvents()
	message:AddClick(zzmObj.DianPaoHu.gameObject, function() tip:GetComponent('UILabel').text = '可以放炮、接炮，可以抢杠胡。' end )
	--message:AddClick(zzmObj.ZiMoHu.gameObject, function() tip:GetComponent('UILabel').text = '不能放炮、接炮，只能自摸胡。' end )
	message:AddClick(zzmObj.ZhuangShuYing.gameObject, function() tip:GetComponent('UILabel').text = '庄家输赢都额外加1分。' end )
	message:AddClick(zzmObj.KeHuQiDui.gameObject, function() tip:GetComponent('UILabel').text = '可以胡七个对子组成的牌型。' end )
	message:AddClick(zzmObj.HuangZhuangHuangGang.gameObject, function() tip:GetComponent('UILabel').text = '当出现流局的时候，开的杠不算分数。' end )
	message:AddClick(zzmObj.PeopleNumber2.gameObject, this.OnClickPeopleChoose)
	message:AddClick(zzmObj.PeopleNumber3.gameObject, this.OnClickPeopleChoose)
	message:AddClick(zzmObj.PeopleNumber4.gameObject, this.OnClickPeopleChoose)
	message:AddClick(zzmObj.lessPlayerStart.gameObject, this.OnClickZZLessPlayerStart)

	message:AddClick(zzmObj.ToggleRound8.gameObject, this.UpdatePlayLab)
	message:AddClick(zzmObj.ToggleRound16.gameObject, this.UpdatePlayLab)

	message:AddClick(zzmObj.hit159bird.gameObject,this.OnClickButtonZhuaNiao_Zhuan);
	message:AddClick(zzmObj.Winbird.gameObject,this.OnClickButtonZhuaNiao_Zhuan);
	message:AddClick(zzmObj.BirdOneShoot.gameObject,this.OnClickButtonZhuaNiao_Zhuan);
	message:AddClick(zzmObj.Nobird.gameObject,this.OnClickButtonZhuaNiao_Zhuan);
	message:AddClick(zzmObj.DealerBird.gameObject,this.OnClickButtonZhuaNiao_Zhuan);

	message:AddClick(zzmObj.NoDelegateTime.gameObject,this.OnClickDelegateButton);
	message:AddClick(zzmObj.DelegateTime1.gameObject,this.OnClickDelegateButton);
	message:AddClick(zzmObj.DelegateTime2.gameObject,this.OnClickDelegateButton);
	message:AddClick(zzmObj.DelegateTime3.gameObject,this.OnClickDelegateButton);
	message:AddClick(zzmObj.DelegateTime5.gameObject,this.OnClickDelegateButton);

	message:AddClick(zzmObj.ToggleOnNiao.gameObject,this.OnClickChooseNiao);
	message:AddClick(zzmObj.ToggleOffNiao.gameObject,this.OnClickChooseNiao);
	message:AddClick(zzmObj.AddButtonNiao.gameObject,this.OnClickChangeNiaoValue);
	message:AddClick(zzmObj.SubtractButtonNiao.gameObject,this.OnClickChangeNiaoValue);

	message:AddClick(zzmObj.PiaoFen.gameObject,this.OnClickPiaoFen);

	message:AddClick(zzmObj.ToggleFewerAddButton.gameObject, this.OnClickFewerButtonZZM)
	message:AddClick(zzmObj.ToggleFewerSubtractButton.gameObject, this.OnClickFewerButtonZZM)
	message:AddClick(zzmObj.ToggleAddAddButton.gameObject, this.OnClickAddButtonZZM)
	message:AddClick(zzmObj.ToggleAddSubtractButton.gameObject, this.OnClickAddButtonZZM)

	message:AddClick(zzmObj.ToggleChoiceDouble.gameObject, this.OnClickChoiceDoubleZZM)
	message:AddClick(zzmObj.ToggleNoChoiceDouble.gameObject, this.OnClickChoiceDoubleZZM)
	message:AddClick(zzmObj.AddDoubleScoreButton.gameObject, this.OnClickChangeDoubleScoreZZM)
	message:AddClick(zzmObj.SubtractDoubleScoreButton.gameObject, this.OnClickChangeDoubleScoreZZM)

	message:AddClick(zzmObj.ToggleMultiple2.gameObject, this.OnClickMultipleZZM)
	message:AddClick(zzmObj.ToggleMultiple3.gameObject, this.OnClickMultipleZZM)
	message:AddClick(zzmObj.ToggleMultiple4.gameObject, this.OnClickMultipleZZM)

	message:AddClick(zzmObj.AddBtnDiFen.gameObject, this.OnClickChangeDiFenValueZZM)
	message:AddClick(zzmObj.SubtractBtnDiFen.gameObject, this.OnClickChangeDiFenValueZZM)
end

function this.GetChangShaMaObj()
	csmObj.ToggleRound8 			= gameObject.transform:Find('Content/QiaoMa/table/NumberOfBoard/Board8')
	csmObj.ToggleRound16 			= gameObject.transform:Find('Content/QiaoMa/table/NumberOfBoard/Board16')

	csmObj.PeopleNumber2 			= gameObject.transform:Find('Content/QiaoMa/table/NumberOfPeople/CSPeopleNumber2')
	csmObj.PeopleNumber3 			= gameObject.transform:Find('Content/QiaoMa/table/NumberOfPeople/CSPeopleNumber3')
	csmObj.PeopleNumber4 			= gameObject.transform:Find('Content/QiaoMa/table/NumberOfPeople/CSPeopleNumber4')
	csmObj.lessPlayerStart 			= gameObject.transform:Find('Content/QiaoMa/table/NumberOfPeople/lessPlayerStart')

	csmObj.CustomizeZhuangxian 		= gameObject.transform:Find('Content/QiaoMa/table/TogglePlay1/Zhuanxian')
	csmObj.CustomizePiaofen 		= gameObject.transform:Find('Content/QiaoMa/table/TogglePlay1/Piaofen')
	csmObj.CustomizeTiandihu 		= gameObject.transform:Find('Content/QiaoMa/table/TogglePlay1/TianDiHu')
	csmObj.CustomizeQuanqiuren 		= gameObject.transform:Find('Content/QiaoMa/table/TogglePlay2/Quanqiuren')
	csmObj.CustomizeMenQing 		= gameObject.transform:Find('Content/QiaoMa/table/TogglePlay2/MenQing')
	csmObj.CustomizeMenQingZiMo 	= gameObject.transform:Find('Content/QiaoMa/table/TogglePlay2/MenQingZiMo')
	csmObj.ToggleMissGuoHu			= gameObject.transform:Find('Content/QiaoMa/table/TogglePlay3/missGuoHu')
	csmObj.QueYiMen 				= gameObject.transform:Find('Content/QiaoMa/table/TogglePlay3/queYiMen')

	csmObj.Queyise 					= gameObject.transform:Find('Content/QiaoMa/table/ToggleCapping1/Queyise')
	csmObj.Banbanhu 				= gameObject.transform:Find('Content/QiaoMa/table/ToggleCapping1/Banbanhu')
	csmObj.Dasixi 					= gameObject.transform:Find('Content/QiaoMa/table/ToggleCapping1/Dasixi')
	csmObj.Liuliushun 				= gameObject.transform:Find('Content/QiaoMa/table/ToggleCapping2/Liuliushun')
	csmObj.Jiejiegao 				= gameObject.transform:Find('Content/QiaoMa/table/ToggleCapping2/Jiejiegao')
	csmObj.Yizhihua 				= gameObject.transform:Find('Content/QiaoMa/table/ToggleCapping2/Yizhihua')
	csmObj.Santong 					= gameObject.transform:Find('Content/QiaoMa/table/ToggleCapping3/SanTong')
	csmObj.Jintongyunv 				= gameObject.transform:Find('Content/QiaoMa/table/ToggleCapping3/JinTongYunv')
	csmObj.Zhongtudasixi 			= gameObject.transform:Find('Content/QiaoMa/table/ToggleCapping3/ZhongtuDasixi')
    csmObj.Zhongtuliuliushun 		= gameObject.transform:Find('Content/QiaoMa/table/ToggleCapping4/ZHongtuLiuLiu')

	csmObj.Kaigang2 				= gameObject.transform:Find('Content/QiaoMa/table/KaiGang/Gang2')
	csmObj.Kaigang4 				= gameObject.transform:Find('Content/QiaoMa/table/KaiGang/Gang4')
	
	csmObj.ToggleWinPos 			= gameObject.transform:Find('Content/QiaoMa/table/ToggleNiaoType/winPos')
	csmObj.Toggle13579Bird 			= gameObject.transform:Find('Content/QiaoMa/table/ToggleNiaoType/13579Bird')
	csmObj.ToggleNoBird 			= gameObject.transform:Find('Content/QiaoMa/table/ToggleNiaoType/noBird')

	csmObj.CatchBirdDouble 			= gameObject.transform:Find('Content/QiaoMa/table/CatchAlgorithm/GangDouble')
	csmObj.CatchBirdYiFen 			= gameObject.transform:Find('Content/QiaoMa/table/CatchAlgorithm/GangYifen')

	csmObj.Niao1 					= gameObject.transform:Find('Content/QiaoMa/table/CatchBird/Niao1')
	csmObj.Niao2 					= gameObject.transform:Find('Content/QiaoMa/table/CatchBird/Niao2')
	csmObj.Niao4 					= gameObject.transform:Find('Content/QiaoMa/table/CatchBird/Niao4')
	csmObj.Niao6 					= gameObject.transform:Find('Content/QiaoMa/table/CatchBird/Niao6')

	csmObj.ToggleCappingScore0 		= gameObject.transform:Find('Content/QiaoMa/table/cappingScore/0')
	csmObj.ToggleCappingScore15 	= gameObject.transform:Find('Content/QiaoMa/table/cappingScore/15')
	csmObj.ToggleCappingScore21 	= gameObject.transform:Find('Content/QiaoMa/table/cappingScore/21')
	csmObj.ToggleCappingScore42 	= gameObject.transform:Find('Content/QiaoMa/table/cappingScore/42')
	
	csmObj.ToggleRegularScoreOffButton=gameObject.transform:Find('Content/QiaoMa/table/regularScore/Off')      
	csmObj.ToggleRegularScoreOnButton=gameObject.transform:Find('Content/QiaoMa/table/regularScore/On')    
	csmObj.RegularScoreTxt=gameObject.transform:Find('Content/QiaoMa/table/regularScore/Score/Value')   
	csmObj.RegularAddButton=gameObject.transform:Find('Content/QiaoMa/table/regularScore/Score/AddButton')      
	csmObj.RegularSubtractButton=gameObject.transform:Find('Content/QiaoMa/table/regularScore/Score/SubtractButton')  

	csmObj.ToggleChoiceDouble = gameObject.transform:Find('Content/QiaoMa/table/choiceDouble/On')    
	csmObj.ToggleNoChoiceDouble = gameObject.transform:Find('Content/QiaoMa/table/choiceDouble/Off')      
	csmObj.DoubleScoreText = gameObject.transform:Find('Content/QiaoMa/table/choiceDouble/doubleScore/Value')        
	csmObj.AddDoubleScoreButton = gameObject.transform:Find('Content/QiaoMa/table/choiceDouble/doubleScore/AddButton')       
	csmObj.SubtractDoubleScoreButton = gameObject.transform:Find('Content/QiaoMa/table/choiceDouble/doubleScore/SubtractButton')  
	csmObj.ToggleMultiple2 = gameObject.transform:Find('Content/QiaoMa/table/multiple/2')
	csmObj.ToggleMultiple3 = gameObject.transform:Find('Content/QiaoMa/table/multiple/3')
	csmObj.ToggleMultiple4 = gameObject.transform:Find('Content/QiaoMa/table/multiple/4')

	csmObj.ToggleSettlementScoreSelect = gameObject.transform:Find('Content/QiaoMa/table/settlementScore/select')
	csmObj.ToggleFewerScoreTxt = gameObject.transform:Find('Content/QiaoMa/table/settlementScore/fewerValue/Value')
	csmObj.ToggleFewerAddButton = gameObject.transform:Find('Content/QiaoMa/table/settlementScore/fewerValue/AddButton')
	csmObj.ToggleFewerSubtractButton = gameObject.transform:Find('Content/QiaoMa/table/settlementScore/fewerValue/SubtractButton')
	csmObj.ToggleAddScoreTxt = gameObject.transform:Find('Content/QiaoMa/table/settlementScore/addValue/Value')
	csmObj.ToggleAddAddButton = gameObject.transform:Find('Content/QiaoMa/table/settlementScore/addValue/AddButton')
	csmObj.ToggleAddSubtractButton = gameObject.transform:Find('Content/QiaoMa/table/settlementScore/addValue/SubtractButton')
	
	csmObj.NoDelegateTime			= gameObject.transform:Find('Content/QiaoMa/table/DelegateChoose/NoDelegate')
	csmObj.DelegateTime1			= gameObject.transform:Find('Content/QiaoMa/table/DelegateChoose/Delegate1')
	csmObj.DelegateTime2			= gameObject.transform:Find('Content/QiaoMa/table/DelegateChoose/Delegate2')
	csmObj.DelegateTime3			= gameObject.transform:Find('Content/QiaoMa/table/DelegateChoose/Delegate3')
	csmObj.DelegateTime5			= gameObject.transform:Find('Content/QiaoMa/table/DelegateChoose/Delegate5')
	csmObj.DelegateFullRoundCancel = gameObject.transform:Find('Content/QiaoMa/table/DelegateCancel/FullRoundCancel')
	csmObj.DelegateThisRoundCancel = gameObject.transform:Find('Content/QiaoMa/table/DelegateCancel/ThisRoundCancel')
	csmObj.DelegateThreeRoundCancel = gameObject.transform:Find('Content/QiaoMa/table/DelegateCancel/ThreeRoundCancel')
	csmObj.ToggleIPcheck			= gameObject.transform:Find('Content/QiaoMa/table/PreventCheat/IPcheck')
	csmObj.ToggleGPScheck			= gameObject.transform:Find('Content/QiaoMa/table/PreventCheat/GPScheck')
end

function this.GetZhuanZhuanMaObj()
	--转转麻将
	zzmObj.ToggleRound8          	= gameObject.transform:Find('Content/ZhuanMa/table/round/8')
	zzmObj.ToggleRound16         	= gameObject.transform:Find('Content/ZhuanMa/table/round/16')

	zzmObj.PeopleNumber2 				= gameObject.transform:Find('Content/ZhuanMa/table/num/2')
	zzmObj.PeopleNumber3 				= gameObject.transform:Find('Content/ZhuanMa/table/num/3')
	zzmObj.PeopleNumber4 				= gameObject.transform:Find('Content/ZhuanMa/table/num/4')

	zzmObj.lessPlayerStart 				= gameObject.transform:Find('Content/ZhuanMa/table/num/lessPlayerStart')
	zzmObj.AddBtnDiFen = gameObject.transform:Find('Content/ZhuanMa/table/diFen/diFenScore/AddButton')
	zzmObj.SubtractBtnDiFen = gameObject.transform:Find('Content/ZhuanMa/table/diFen/diFenScore/SubtractButton')
	zzmObj.DiFenTunValue = gameObject.transform:Find('Content/ZhuanMa/table/diFen/diFenScore/Value')

	zzmObj.DianPaoHu             	= gameObject.transform:Find('Content/ZhuanMa/table/CappingType/DianPaoHu')
	zzmObj.ZhuangShuYing         	= gameObject.transform:Find('Content/ZhuanMa/table/CappingType/ZhuangShuYing')
	zzmObj.KeHuQiDui             	= gameObject.transform:Find('Content/ZhuanMa/table/CappingType/KeHuQiDui')
	zzmObj.HuangZhuangHuangGang  	= gameObject.transform:Find('Content/ZhuanMa/table/CappingType/HuangZhuangHuangGang')
	zzmObj.PiaoFen 					= gameObject.transform:Find('Content/ZhuanMa/table/CappingType/ZhuanPiaoFen')
	zzmObj.ToggleScoreGangInc 		= gameObject.transform:Find('Content/ZhuanMa/table/CappingType/scoreGangInc')
	
	zzmObj.hit159bird				= gameObject.transform:Find("Content/ZhuanMa/table/zhuaNiaoType/hit159Niao")
	zzmObj.Winbird					= gameObject.transform:Find("Content/ZhuanMa/table/zhuaNiaoType/winNiao")
	zzmObj.Nobird 					= gameObject.transform:Find("Content/ZhuanMa/table/zhuaNiaoType/NoNiao")
	zzmObj.BirdOneShoot 				= gameObject.transform:Find("Content/ZhuanMa/table/zhuaNiaoType/AllNiao")
	zzmObj.DealerBird 				= gameObject.transform:Find("Content/ZhuanMa/table/zhuaNiaoType/dealerNiao")
	zzmObj.Bird2                 	= gameObject.transform:Find('Content/ZhuanMa/table/niaoNum/Niao2')
	zzmObj.Bird4                 	= gameObject.transform:Find('Content/ZhuanMa/table/niaoNum/Niao4')
	zzmObj.Bird6                 	= gameObject.transform:Find('Content/ZhuanMa/table/niaoNum/Niao6')

	zzmObj.ToggleOnNiao 				= gameObject.transform:Find('Content/ZhuanMa/table/ToggleNiao/OnNiao');
	zzmObj.ToggleOffNiao 				= gameObject.transform:Find('Content/ZhuanMa/table/ToggleNiao/OffNiao');
	zzmObj.NiaoValueText 				= gameObject.transform:Find('Content/ZhuanMa/table/ToggleNiao/NiaoValue/Value');
	zzmObj.AddButtonNiao 				= gameObject.transform:Find('Content/ZhuanMa/table/ToggleNiao/NiaoValue/AddButton');
	zzmObj.SubtractButtonNiao 		= gameObject.transform:Find('Content/ZhuanMa/table/ToggleNiao/NiaoValue/SubtractButton');

	zzmObj.ToggleChoiceDouble = gameObject.transform:Find('Content/ZhuanMa/table/choiceDouble/On')    
	zzmObj.ToggleNoChoiceDouble = gameObject.transform:Find('Content/ZhuanMa/table/choiceDouble/Off')      
	zzmObj.DoubleScoreText = gameObject.transform:Find('Content/ZhuanMa/table/choiceDouble/doubleScore/Value')        
	zzmObj.AddDoubleScoreButton = gameObject.transform:Find('Content/ZhuanMa/table/choiceDouble/doubleScore/AddButton')       
	zzmObj.SubtractDoubleScoreButton = gameObject.transform:Find('Content/ZhuanMa/table/choiceDouble/doubleScore/SubtractButton') 

	zzmObj.ToggleMultiple2 = gameObject.transform:Find('Content/ZhuanMa/table/multiple/2')
	zzmObj.ToggleMultiple3 = gameObject.transform:Find('Content/ZhuanMa/table/multiple/3')
	zzmObj.ToggleMultiple4 = gameObject.transform:Find('Content/ZhuanMa/table/multiple/4')

	zzmObj.ToggleSettlementScoreSelect = gameObject.transform:Find('Content/ZhuanMa/table/settlementScore/select');
	zzmObj.ToggleFewerScoreTxt = gameObject.transform:Find('Content/ZhuanMa/table/settlementScore/fewerValue/Value');
	zzmObj.ToggleFewerAddButton = gameObject.transform:Find('Content/ZhuanMa/table/settlementScore/fewerValue/AddButton');
	zzmObj.ToggleFewerSubtractButton = gameObject.transform:Find('Content/ZhuanMa/table/settlementScore/fewerValue/SubtractButton');
	zzmObj.ToggleAddScoreTxt = gameObject.transform:Find('Content/ZhuanMa/table/settlementScore/addValue/Value');
	zzmObj.ToggleAddAddButton = gameObject.transform:Find('Content/ZhuanMa/table/settlementScore/addValue/AddButton');
	zzmObj.ToggleAddSubtractButton = gameObject.transform:Find('Content/ZhuanMa/table/settlementScore/addValue/SubtractButton')

	zzmObj.NoDelegateTime				= gameObject.transform:Find('Content/ZhuanMa/table/DelegateChoose/NoDelegate');
	zzmObj.DelegateTime1				= gameObject.transform:Find('Content/ZhuanMa/table/DelegateChoose/Delegate1');
	zzmObj.DelegateTime2				= gameObject.transform:Find('Content/ZhuanMa/table/DelegateChoose/Delegate2');
	zzmObj.DelegateTime3				= gameObject.transform:Find('Content/ZhuanMa/table/DelegateChoose/Delegate3');
	zzmObj.DelegateTime5				= gameObject.transform:Find('Content/ZhuanMa/table/DelegateChoose/Delegate5');
	zzmObj.DelegateFullRoundCancel 	= gameObject.transform:Find('Content/ZhuanMa/table/DelegateCancel/FullRoundCancel');
	zzmObj.DelegateThisRoundCancel 	= gameObject.transform:Find('Content/ZhuanMa/table/DelegateCancel/ThisRoundCancel');
	zzmObj.DelegateThreeRoundCancel 	= gameObject.transform:Find('Content/ZhuanMa/table/DelegateCancel/ThreeRoundCancel');

	zzmObj.ToggleIPcheck				= gameObject.transform:Find('Content/ZhuanMa/table/PreventCheat/IPcheck')
	zzmObj.ToggleGPScheck				= gameObject.transform:Find('Content/ZhuanMa/table/PreventCheat/GPScheck')
end

function this.GetHongzhongMaObj()
	--红中麻将
	 hzmObj.Round4 					= gameObject.transform:Find("Content/HongZhongMa/table/NumberOfBoard/Groups/Board4");
	 hzmObj.Round8 					= gameObject.transform:Find("Content/HongZhongMa/table/NumberOfBoard/Groups/Board8");
	 hzmObj.Round16 					= gameObject.transform:Find("Content/HongZhongMa/table/NumberOfBoard/Groups/Board16");

	 hzmObj.People2 					= gameObject.transform:Find("Content/HongZhongMa/table/NumberOfPeople/Groups/PeopleNumber2");
	 hzmObj.People3 					= gameObject.transform:Find("Content/HongZhongMa/table/NumberOfPeople/Groups/PeopleNumber3");
	 hzmObj.People4 					= gameObject.transform:Find("Content/HongZhongMa/table/NumberOfPeople/Groups/PeopleNumber4");

	 hzmObj.lessPlayerStart 			= gameObject.transform:Find("Content/HongZhongMa/table/NumberOfPeople/Groups/lessPlayerStart");
	 hzmObj.DianPaoHu 					= gameObject.transform:Find("Content/HongZhongMa/table/Capping/c1/DianPaoHu");
	 hzmObj.Zhuangxian 				= gameObject.transform:Find("Content/HongZhongMa/table/Capping/c3/ZhuangShuYing");
	 hzmObj.KeHuQiDui 					= gameObject.transform:Find("Content/HongZhongMa/table/Capping/c4/KeHuQiDui");
	 hzmObj.YouHuBiHu 					= gameObject.transform:Find("Content/HongZhongMa/table/Capping/c7/HongzhongBuJiePao");
	 hzmObj.PiaoFen 					= gameObject.transform:Find("Content/HongZhongMa/table/Capping/c2/PiaoFen");
	 hzmObj.Double 					= gameObject.transform:Find("Content/HongZhongMa/table/Capping/c5/HongzhongDouble");
	 hzmObj.AllDouble 					= gameObject.transform:Find("Content/HongZhongMa/table/Capping/c9/AllDouble");
	 hzmObj.BuJiePao 					= gameObject.transform:Find("Content/HongZhongMa/table/Capping/c6/DianGangGangKai");
	 hzmObj.HuangZhuangHuangGang		= gameObject.transform:Find('Content/HongZhongMa/table/Capping/c8/HuangZhuangHuangGang')

	 hzmObj.hit159bird					= gameObject.transform:Find("Content/HongZhongMa/table/CanChoose/Groups/hit159Niao");
	 hzmObj.Winbird					= gameObject.transform:Find("Content/HongZhongMa/table/CanChoose/Groups/winNiao");
	 hzmObj.Nobird 					= gameObject.transform:Find("Content/HongZhongMa/table/CanChoose/Groups/NoNiao");
	 hzmObj.BirdOneShoot 				= gameObject.transform:Find("Content/HongZhongMa/table/CanChoose/Groups/AllNiao");
	 hzmObj.DealerBird 				= gameObject.transform:Find("Content/HongZhongMa/table/CanChoose/Groups/dealerNiao");
	 hzmObj.Bird2 						= gameObject.transform:Find("Content/HongZhongMa/table/CanChoose/Groups/Niao2");
	 hzmObj.Bird4 						= gameObject.transform:Find("Content/HongZhongMa/table/CanChoose/Groups/Niao4");
	 hzmObj.Bird6 						= gameObject.transform:Find("Content/HongZhongMa/table/CanChoose/Groups/Niao6");
	 hzmObj.Bird1Score 				= gameObject.transform:Find("Content/HongZhongMa/table/CanChoose/Groups/Niao1Score");
	 hzmObj.Bird2Score 				= gameObject.transform:Find("Content/HongZhongMa/table/CanChoose/Groups/Niao2Score");

	 hzmObj.Number4 					= gameObject.transform:Find("Content/HongZhongMa/table/HongZhongChoose/Groups/HongZhong4");
	 hzmObj.Number8 					= gameObject.transform:Find("Content/HongZhongMa/table/HongZhongChoose/Groups/HongZhong8");

	 hzmObj.GangEqualZimo 				= gameObject.transform:Find("Content/HongZhongMa/table/CatchGang/GangMo");
	 hzmObj.QiangQuanBao 				= gameObject.transform:Find("Content/HongZhongMa/table/CatchGang/GangQuanBao");
	 hzmObj.QiangGangEqualDianPao 		= gameObject.transform:Find("Content/HongZhongMa/table/CatchGang/GangPao");
	 hzmObj.CanQiangGangHu 			= gameObject.transform:Find("Content/HongZhongMa/table/CatchGang/HongzhongQiangGang");
	 hzmObj.Nothing 					= gameObject.transform:Find("Content/HongZhongMa/table/CatchGang/Nothing");

	 hzmObj.NoDelegateTime				= gameObject.transform:Find('Content/HongZhongMa/table/DelegateChoose/Groups/NoDelegate');
	 hzmObj.DelegateTime1				= gameObject.transform:Find('Content/HongZhongMa/table/DelegateChoose/Groups/Delegate1');
	 hzmObj.DelegateTime2				= gameObject.transform:Find('Content/HongZhongMa/table/DelegateChoose/Groups/Delegate2');
	 hzmObj.DelegateTime3				= gameObject.transform:Find('Content/HongZhongMa/table/DelegateChoose/Groups/Delegate3');
	 hzmObj.DelegateTime5				= gameObject.transform:Find('Content/HongZhongMa/table/DelegateChoose/Groups/Delegate5');
	 hzmObj.DelegateFullRoundCancel 	= gameObject.transform:Find('Content/HongZhongMa/table/DelegateCancel/Groups/FullRoundCancel');
	 hzmObj.DelegateThisRoundCancel 	= gameObject.transform:Find('Content/HongZhongMa/table/DelegateCancel/Groups/ThisRoundCancel');
	 hzmObj.DelegateThreeRoundCancel 	= gameObject.transform:Find('Content/HongZhongMa/table/DelegateCancel/Groups/ThreeRoundCancel');

	 hzmObj.ToggleOnNiao 				= gameObject.transform:Find('Content/HongZhongMa/table/ToggleNiao/OnNiao');
	 hzmObj.ToggleOffNiao 				= gameObject.transform:Find('Content/HongZhongMa/table/ToggleNiao/OffNiao');
	 hzmObj.NiaoValueText 				= gameObject.transform:Find('Content/HongZhongMa/table/ToggleNiao/NiaoValue/Value');
	 hzmObj.AddButtonNiao 				= gameObject.transform:Find('Content/HongZhongMa/table/ToggleNiao/NiaoValue/AddButton');
	 hzmObj.SubtractButtonNiao 		= gameObject.transform:Find('Content/HongZhongMa/table/ToggleNiao/NiaoValue/SubtractButton');

	 hzmObj.ToggleSettlementScoreSelect = gameObject.transform:Find('Content/HongZhongMa/table/settlementScore/select');
	 hzmObj.ToggleFewerScoreTxt = gameObject.transform:Find('Content/HongZhongMa/table/settlementScore/fewerValue/Value');
	 hzmObj.ToggleFewerAddButton = gameObject.transform:Find('Content/HongZhongMa/table/settlementScore/fewerValue/AddButton');
	 hzmObj.ToggleFewerSubtractButton = gameObject.transform:Find('Content/HongZhongMa/table/settlementScore/fewerValue/SubtractButton');
	 hzmObj.ToggleAddScoreTxt = gameObject.transform:Find('Content/HongZhongMa/table/settlementScore/addValue/Value');
	 hzmObj.ToggleAddAddButton = gameObject.transform:Find('Content/HongZhongMa/table/settlementScore/addValue/AddButton');
	 hzmObj.ToggleAddSubtractButton = gameObject.transform:Find('Content/HongZhongMa/table/settlementScore/addValue/SubtractButton');
	
	 hzmObj.ToggleIPcheck				= gameObject.transform:Find('Content/HongZhongMa/table/PreventCheat/IPcheck')
	 hzmObj.ToggleGPScheck				= gameObject.transform:Find('Content/HongZhongMa/table/PreventCheat/GPScheck')

	 hzmObj.ToggleMultiple2 = gameObject.transform:Find('Content/HongZhongMa/table/multiple/2')
	 hzmObj.ToggleMultiple3 = gameObject.transform:Find('Content/HongZhongMa/table/multiple/3')
	 hzmObj.ToggleMultiple4 = gameObject.transform:Find('Content/HongZhongMa/table/multiple/4')

	 hzmObj.ToggleChoiceDouble = gameObject.transform:Find('Content/HongZhongMa/table/choiceDouble/On')    
	 hzmObj.ToggleNoChoiceDouble = gameObject.transform:Find('Content/HongZhongMa/table/choiceDouble/Off')      
	 hzmObj.DoubleScoreText = gameObject.transform:Find('Content/HongZhongMa/table/choiceDouble/doubleScore/Value')        
	 hzmObj.AddDoubleScoreButton = gameObject.transform:Find('Content/HongZhongMa/table/choiceDouble/doubleScore/AddButton')       
	 hzmObj.SubtractDoubleScoreButton = gameObject.transform:Find('Content/HongZhongMa/table/choiceDouble/doubleScore/SubtractButton')  

	 hzmObj.AddBtnDiFen = gameObject.transform:Find('Content/HongZhongMa/table/diFen/diFenScore/AddButton')
	 hzmObj.SubtractBtnDiFen = gameObject.transform:Find('Content/HongZhongMa/table/diFen/diFenScore/SubtractButton')
	 hzmObj.DiFenTunValue = gameObject.transform:Find('Content/HongZhongMa/table/diFen/diFenScore/Value')
	 hzmObj.ToggleScoreGangInc 		= gameObject.transform:Find('Content/HongZhongMa/table/scoreMingGangInc/scoreGangInc')
end

function this.UpdatePlayLab(go)  --更新所需钻石数  类型
	local rounds = 0
	if roomType == QiaoMaType then
		if csmObj.ToggleRound8:GetComponent('UIToggle').value then
			rounds = 8
		else
			rounds = 16
		end
		payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.CSM,rounds,nil,nil)
	elseif roomType == ZhuanMaType then
		if zzmObj.ToggleRound8:GetComponent('UIToggle').value then
			rounds = 8
		else
			rounds = 16
		end
		payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.ZZM,rounds,nil,nil)
	elseif roomType == HongZhongMaType then
		if  hzmObj.Round8:GetComponent("UIToggle").value then
			rounds = 8;
		elseif  hzmObj.Round16:GetComponent("UIToggle").value then
			rounds = 16;
		end
		payLabel:GetComponent("UILabel").text = GetPayMun(proxy_pb.HZM,rounds,nil,nil)
	end
end

function this.Refresh(type)
	--roomType = UnityEngine.PlayerPrefs.GetInt("mj_type", 0)
	roomType = type
	if roomType==nil then 
		roomType = 1;
	end
	print("showPanle  ",roomType)
	QiaoMaCon.gameObject:SetActive(false)
	ZhuanMaCon.gameObject:SetActive(false)
	HongZhongMaCon.gameObject:SetActive(false)
	dragPanelZhuan.gameObject:SetActive(false)
	dragPanelHongZhong.gameObject:SetActive(false)
    dragPanelChangsha.gameObject:SetActive(false)
	if(roomType == 1)then
		ZhuanMaCon.gameObject:SetActive(true)
		dragPanelZhuan.gameObject:SetActive(true)
		this.SetZhuanZhuanPreSetting(curSelectPlay);
	elseif roomType == 2 then 
		HongZhongMaCon.gameObject:SetActive(true)
		dragPanelHongZhong.gameObject:SetActive(true)
		this.SetHongZhongPreSetting(curSelectPlay);
	elseif roomType == 0 then
		QiaoMaCon.gameObject:SetActive(true);
		dragPanelChangsha.gameObject:SetActive(true);
		this.SetChangShaPreSetting(curSelectPlay);
	end

	tip:GetComponent('UILabel').text=''
	
	this.UpdatePlayLab(nil)
end

local optionData = {};

function this.WhoShow(data)
	print(" WhoShow roomType ",data.roomType);
	local gameIndex = 0
	if data.roomType == CSM then
		gameIndex = 0
	elseif data.roomType == ZZM then
		gameIndex = 1
	else
		gameIndex = 2
	end
	if data.optionData ~=nil then 
		optionData 			= data.optionData;
		optionData.playId 	= data.playId;
		optionData.ruleId 	= data.ruleId;
	end
	
	curSelectPlay = {}
	print('data.addPlay:'..tostring(data.optionData.addPlay).. "data.addRule:"..tostring(data.optionData.addRule))
	if not data.optionData.addPlay and not data.optionData.addRule then--编辑玩法
		curSelectPlay = json:decode(data.settings)
		if curSelectPlay.resultScore == nil then
			curSelectPlay.resultScore =false
			curSelectPlay.resultLowerScore = 10
			curSelectPlay.resultAddScore = 10
		end
		if gameIndex == 1 or gameIndex == 2 then
			if curSelectPlay.baseScore == nil then
				curSelectPlay.baseScore = 1
			end
			if curSelectPlay.scoreMingGangInc == nil then
				curSelectPlay.scoreMingGangInc = false
			end
			print('curSelectPlay.baseScore : '..curSelectPlay.baseScore)
		end
		--print_r(curSelectPlay)
	else --添加玩法
		curSelectPlay = this.GetSaveSettingByType(gameIndex);
	end

	gameName 			= data.name;
	this.clubInfo 		= data.clubInfo;

	UnityEngine.PlayerPrefs.SetString('gameName', data.name);

	this.SetTitleInfo(optionData,gameName);
	
	print('麻将的Item项点击 :'..gameIndex)
	this.Refresh(gameIndex)
end

function this.GetSaveSettingByType(type)
	if type == ZhuanMaType then 
		return this.GetZhuanZhuanSaveSetting()
	elseif type == HongZhongMaType then 
		return this.GetHongZhongSaveSetting()
	elseif type == QiaoMaType then
		return this.GetChangShaSaveSetting()
	end
end

function this.GetChangShaSaveSetting()
	local settings = {}
	settings.paymentType 			= 0
	settings.size 					= 2
	settings.minorityMode 			= false
	settings.rounds 				= 8
	
	settings.gangMahjongCount 		= 2
	settings.trusteeship			= 0
	settings.bankerAddOne 			= false
	settings.floatScore 			= false
	settings.tianDiHu 				= false
	settings.quanQiuRen 			= true
	settings.shQueYiSe 				= true
	settings.shBanBanHu 			= true
	settings.shJieJieGao 			= false
	settings.shYiZhiHua 			= false
	settings.shSanTong 				= false
	settings.shJinTongYuNv 			= false
	settings.shDaSiXi 				= true
	settings.shLiuLiuShun 			= true
	
	settings.ztDaSiXi 				= false
	settings.ztLiuLiuShun 			= false
	settings.trusteeshipDissolve 	= true
	settings.trusteeshipRound 		= 0

	settings.fixedFloatScore		= 0
	settings.resultScore 			= false
	settings.resultLowerScore 		= 10
	settings.resultAddScore 		= 10
	
	settings.openIp					= false
	settings.openGps				= false
	settings.choiceDouble 			= false
	settings.doubleScore			= 10
	settings.multiple				= 2
	settings.cappingScore			= 0
	settings.queYiMen				= false
	settings.missGuoHu				= false

	settings.bird 					= 0
	settings.birdCompute 			= true
	return settings
end

--设置长沙麻将预设（上次的选择);
function this.SetChangShaPreSetting(settings)
	csmObj.ToggleRound8:GetComponent('UIToggle'):Set(8 == settings.rounds)
	csmObj.ToggleRound16:GetComponent('UIToggle'):Set(16 == settings.rounds)
	csmObj.PeopleNumber2:GetComponent("UIToggle"):Set(settings.size == 2);
	csmObj.PeopleNumber3:GetComponent("UIToggle"):Set(settings.size == 3);
	csmObj.PeopleNumber4:GetComponent("UIToggle"):Set(settings.size == 4);
	csmObj.lessPlayerStart:GetComponent("UIToggle"):Set(settings.minorityMode)

	csmObj.CustomizeZhuangxian:GetComponent("UIToggle"):Set(settings.bankerAddOne);
	csmObj.CustomizePiaofen:GetComponent("UIToggle"):Set(settings.floatScore);
	csmObj.CustomizeTiandihu:GetComponent("UIToggle"):Set(settings.tianDiHu);
	csmObj.CustomizeQuanqiuren:GetComponent("UIToggle"):Set(settings.quanQiuRen);
	csmObj.CustomizeMenQing:GetComponent("UIToggle"):Set(settings.menQing);
	csmObj.CustomizeMenQingZiMo:GetComponent("UIToggle"):Set(settings.menQingZiMo);

	csmObj.ToggleMissGuoHu:GetComponent("UIToggle"):Set(settings.missGuoHu)

	csmObj.QueYiMen.parent.gameObject:SetActive(settings.size ==2 or settings.minorityMode)
	csmObj.QueYiMen:GetComponent("UIToggle"):Set(settings.queYiMen);
	csmObj.Queyise.gameObject:SetActive(not (csmObj.QueYiMen:GetComponent("UIToggle").value and (settings.size == 2 or settings.minorityMode)))
	csmObj.Queyise:GetComponent("UIToggle"):Set(settings.shQueYiSe);
	csmObj.Banbanhu:GetComponent("UIToggle"):Set(settings.shBanBanHu);
	csmObj.Jiejiegao:GetComponent("UIToggle"):Set(settings.shJieJieGao);
	csmObj.Yizhihua:GetComponent("UIToggle"):Set(settings.shYiZhiHua);
	csmObj.Santong:GetComponent("UIToggle"):Set(settings.shSanTong);
	csmObj.Jintongyunv:GetComponent("UIToggle"):Set(settings.shJinTongYuNv);
	csmObj.Dasixi:GetComponent("UIToggle"):Set(settings.shDaSiXi);
	csmObj.Liuliushun:GetComponent("UIToggle"):Set(settings.shLiuLiuShun);

	csmObj.Kaigang2:GetComponent("UIToggle"):Set(settings.gangMahjongCount == 2)
	csmObj.Kaigang4:GetComponent("UIToggle"):Set(settings.gangMahjongCount == 4)
	
	if settings.bird == 0 then
		csmObj.ToggleWinPos:GetComponent("UIToggle"):Set(false)
		csmObj.Toggle13579Bird:GetComponent("UIToggle"):Set(false)
		csmObj.ToggleNoBird:GetComponent("UIToggle"):Set(true)
		csmObj.CatchBirdDouble:GetComponent("UIToggle"):Set(false)
		csmObj.CatchBirdYiFen:GetComponent("UIToggle"):Set(true)
		csmObj.Niao1:GetComponent('UIToggle'):Set(false)
		csmObj.Niao2:GetComponent('UIToggle'):Set(false)
		csmObj.Niao4:GetComponent('UIToggle'):Set(true)
		csmObj.Niao6:GetComponent('UIToggle'):Set(false)
	else
		if settings.bird13579 == nil then
			csmObj.ToggleWinPos:GetComponent("UIToggle"):Set(true)
			csmObj.Toggle13579Bird:GetComponent("UIToggle"):Set(false)
			csmObj.ToggleNoBird:GetComponent("UIToggle"):Set(false)
		else
			csmObj.ToggleWinPos:GetComponent("UIToggle"):Set(settings.birdWinStart)
			csmObj.Toggle13579Bird:GetComponent("UIToggle"):Set(settings.bird13579)
			csmObj.ToggleNoBird:GetComponent("UIToggle"):Set(false)
		end
		csmObj.CatchBirdDouble:GetComponent("UIToggle"):Set(settings.birdCompute)
		csmObj.CatchBirdYiFen:GetComponent("UIToggle"):Set(not settings.birdCompute)
		csmObj.Niao1:GetComponent('UIToggle'):Set(settings.bird == 1)
		csmObj.Niao2:GetComponent('UIToggle'):Set(settings.bird == 2)
		csmObj.Niao4:GetComponent('UIToggle'):Set(settings.bird == 4)
		csmObj.Niao6:GetComponent('UIToggle'):Set(settings.bird == 6)
	end
	csmObj.CatchBirdDouble.parent.gameObject:SetActive(settings.bird~=0)
	csmObj.Niao1.parent.gameObject:SetActive(settings.bird~=0)

    csmObj.Zhongtudasixi:GetComponent("UIToggle"):Set(settings.ztDaSiXi)
    csmObj.Zhongtuliuliushun:GetComponent("UIToggle"):Set(settings.ztLiuLiuShun)
	--托管
	csmObj.NoDelegateTime:GetComponent('UIToggle'):Set(settings.trusteeship == 0)
	csmObj.DelegateTime1:GetComponent('UIToggle'):Set(settings.trusteeship == 60)
	csmObj.DelegateTime2:GetComponent('UIToggle'):Set(settings.trusteeship == 120)
	csmObj.DelegateTime3:GetComponent('UIToggle'):Set(settings.trusteeship == 180)
	csmObj.DelegateTime5:GetComponent('UIToggle'):Set(settings.trusteeship == 300)
	csmObj.DelegateThisRoundCancel:GetComponent('UIToggle'):Set(settings.trusteeshipDissolve)
	csmObj.DelegateFullRoundCancel:GetComponent('UIToggle'):Set(not settings.trusteeshipDissolve and settings.trusteeshipRound == 0)
	csmObj.DelegateThreeRoundCancel:GetComponent("UIToggle"):Set(settings.trusteeshipRound == 3)
	csmObj.DelegateThisRoundCancel.parent.gameObject:SetActive(settings.trusteeship ~= 0)

	 csmObj.ToggleIPcheck:GetComponent("UIToggle"):Set(settings.openIp)
	 csmObj.ToggleGPScheck:GetComponent("UIToggle"):Set(settings.openGps)
	 csmObj.ToggleIPcheck.parent.gameObject:SetActive(settings.size>2 and CONST.IPcheckOn)

	 csmObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(settings.size==2 or settings.minorityMode)
	 csmObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(settings.resultScore)
	csmObj.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	csmObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = settings.resultLowerScore
	csmObj.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	csmObj.ToggleAddScoreTxt:GetComponent('UILabel').text = settings.resultAddScore

	if settings.choiceDouble == nil then
		settings.choiceDouble= false
		settings.doubleScore=10
		settings.multiple=2
	end
	csmObj.ToggleChoiceDouble.parent.gameObject:SetActive(settings.size==2 or settings.minorityMode)
    csmObj.ToggleMultiple2.parent.gameObject:SetActive((settings.size==2 or settings.minorityMode) and settings.choiceDouble)
    
	csmObj.ToggleMultiple2:GetComponent('UIToggle'):Set(settings.multiple == 2)
	csmObj.ToggleMultiple3:GetComponent('UIToggle'):Set(settings.multiple == 3)
	csmObj.ToggleMultiple4:GetComponent('UIToggle'):Set(settings.multiple == 4)

	csmObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(settings.choiceDouble)
	csmObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not settings.choiceDouble)
	csmObj.DoubleScoreText.parent.gameObject:SetActive(settings.choiceDouble)
	if settings.doubleScore == 0 then
		csmObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		csmObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..settings.doubleScore..'分'
	end

	if settings.fixedFloatScore then
		csmObj.ToggleRegularScoreOnButton:GetComponent('UIToggle'):Set(settings.fixedFloatScore~=0)
		csmObj.ToggleRegularScoreOffButton:GetComponent('UIToggle'):Set(settings.fixedFloatScore==0)
		csmObj.RegularScoreTxt:GetComponent('UILabel').text = settings.fixedFloatScore==0 and '1分' or settings.fixedFloatScore..'分'
		csmObj.RegularScoreTxt.parent.gameObject:SetActive(settings.fixedFloatScore~=0)
	else
		csmObj.ToggleRegularScoreOnButton:GetComponent('UIToggle'):Set(false)
		csmObj.ToggleRegularScoreOffButton:GetComponent('UIToggle'):Set(true)
		csmObj.RegularScoreTxt:GetComponent('UILabel').text = '1分'
		csmObj.RegularScoreTxt.parent.gameObject:SetActive(false)
	end

	csmObj.ToggleCappingScore0:GetComponent('UIToggle'):Set(settings.cappingScore == 0)
	csmObj.ToggleCappingScore15:GetComponent('UIToggle'):Set(settings.cappingScore == 15)
	csmObj.ToggleCappingScore21:GetComponent('UIToggle'):Set(settings.cappingScore == 21)
	csmObj.ToggleCappingScore42:GetComponent('UIToggle'):Set(settings.cappingScore == 42)

	QiaoMaCon:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.GetZhuanZhuanSaveSetting()
	local settings = {}
	settings.paymentType 			= 0
	settings.size 					= 2
	settings.minorityMode 			= false
	settings.roomType 				= proxy_pb.ZZM
	settings.huAsBanker 			= false
	settings.rounds 				= 8
	settings.bird 					= 2
	settings.trusteeship 			= 0

	settings.dianPaoHu 				= true
	settings.bankerAddOne 			= true
	settings.huSevenPairs 			= true
	settings.huangZhuangHuangGang 	= true
	settings.floatScore 			= false
	settings.birdAllHit 			= false
	settings.birdBankerStart 		= false
	settings.birdWinStart 			= false
	settings.bird159 			    = false
	settings.trusteeshipDissolve 	= false
	settings.trusteeshipRound 		= 0

	settings.resultScore 			= false
	settings.resultLowerScore 		= 10
	settings.resultAddScore 		= 10
	
	settings.openIp					= false
	settings.openGps				= false
	settings.choiceDouble 			= false
	settings.doubleScore 			= 10
	settings.multiple				= 2
	settings.baseScore 				= 1
	settings.scoreMingGangInc 			= false
	return settings
end

--设置转转麻将预设
function this.SetZhuanZhuanPreSetting(settings)
	zzmObj.ToggleRound8:GetComponent('UIToggle'):Set(8 == settings.rounds)
	zzmObj.ToggleRound16:GetComponent('UIToggle'):Set(16 == settings.rounds)

	zzmObj.PeopleNumber2:GetComponent("UIToggle"):Set(settings.size ==2)
	zzmObj.PeopleNumber3:GetComponent("UIToggle"):Set(settings.size ==3)
	zzmObj.PeopleNumber4:GetComponent("UIToggle"):Set(settings.size ==4)
	zzmObj.lessPlayerStart:GetComponent("UIToggle"):Set(settings.minorityMode)
	
	zzmObj.DianPaoHu:GetComponent('UIToggle'):Set(settings.dianPaoHu)
	zzmObj.ZhuangShuYing:GetComponent('UIToggle'):Set(settings.bankerAddOne)
	zzmObj.KeHuQiDui:GetComponent('UIToggle'):Set(settings.huSevenPairs)
	zzmObj.HuangZhuangHuangGang:GetComponent('UIToggle'):Set(settings.huangZhuangHuangGang)
	zzmObj.PiaoFen:GetComponent("UIToggle"):Set(settings.floatScore)
	zzmObj.ToggleScoreGangInc.gameObject:SetActive(settings.size ~= 4 or settings.minorityMode)
	zzmObj.ToggleScoreGangInc:GetComponent('UIToggle'):Set(settings.scoreMingGangInc)
	zzmObj.DiFenTunValue:GetComponent("UILabel").text = settings.baseScore..'分'

	zzmObj.hit159bird:GetComponent("UIToggle"):Set(settings.bird159);
	zzmObj.Winbird:GetComponent("UIToggle"):Set(settings.birdWinStart);	
	zzmObj.BirdOneShoot:GetComponent("UIToggle"):Set(settings.birdAllHit);
	zzmObj.DealerBird:GetComponent("UIToggle"):Set(settings.birdBankerStart);
	local isHaveBird = (
		zzmObj.hit159bird:GetComponent("UIToggle").value or 	  
		zzmObj.Winbird:GetComponent("UIToggle").value or 
		zzmObj.BirdOneShoot:GetComponent("UIToggle").value or 
		zzmObj.DealerBird:GetComponent("UIToggle").value 
					)
	zzmObj.Nobird:GetComponent("UIToggle"):Set(not isHaveBird)
	
	if zzmObj.Nobird:GetComponent("UIToggle").value or zzmObj.BirdOneShoot:GetComponent("UIToggle").value then 
		zzmObj.Bird2.parent.gameObject:SetActive(false)
	else
		zzmObj.Bird2.parent.gameObject:SetActive(true)
	end
	zzmObj.Bird2:GetComponent("UIToggle"):Set(settings.bird == 2)
	zzmObj.Bird4:GetComponent("UIToggle"):Set(settings.bird == 4)
	zzmObj.Bird6:GetComponent("UIToggle"):Set(settings.bird == 6)

	--托管
	zzmObj.NoDelegateTime:GetComponent('UIToggle'):Set(settings.trusteeship == 0)
	zzmObj.DelegateTime1:GetComponent('UIToggle'):Set(settings.trusteeship == 60)
	zzmObj.DelegateTime2:GetComponent('UIToggle'):Set(settings.trusteeship == 120)
	zzmObj.DelegateTime3:GetComponent('UIToggle'):Set(settings.trusteeship == 180)
	zzmObj.DelegateTime5:GetComponent('UIToggle'):Set(settings.trusteeship == 300)
	zzmObj.DelegateThisRoundCancel:GetComponent('UIToggle'):Set(settings.trusteeshipDissolve)
	zzmObj.DelegateFullRoundCancel:GetComponent('UIToggle'):Set(not settings.trusteeshipDissolve and settings.trusteeshipRound == 0)
	zzmObj.DelegateThreeRoundCancel:GetComponent("UIToggle"):Set(settings.trusteeshipRound == 3)
	zzmObj.DelegateThisRoundCancel.parent.gameObject:SetActive(settings.trusteeship ~= 0)
	
	zzmObj.ToggleIPcheck:GetComponent("UIToggle"):Set(settings.openIp)
	zzmObj.ToggleGPScheck:GetComponent("UIToggle"):Set(settings.openGps)
	zzmObj.ToggleIPcheck.parent.gameObject:SetActive(settings.size>2 and CONST.IPcheckOn)
	zzmObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(settings.size==2 or settings.minorityMode)
	
	zzmObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(settings.resultScore)
	zzmObj.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	zzmObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = settings.resultLowerScore
	zzmObj.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	zzmObj.ToggleAddScoreTxt:GetComponent('UILabel').text = settings.resultAddScore
	if settings.choiceDouble == nil then
		settings.choiceDouble= false
		settings.doubleScore=10
		settings.multiple=2
	end
	zzmObj.ToggleChoiceDouble.parent.gameObject:SetActive(settings.size==2 or settings.minorityMode)
    zzmObj.ToggleMultiple2.parent.gameObject:SetActive((settings.size==2 or settings.minorityMode) and settings.choiceDouble)
    
	zzmObj.ToggleMultiple2:GetComponent('UIToggle'):Set(settings.multiple == 2)
	zzmObj.ToggleMultiple3:GetComponent('UIToggle'):Set(settings.multiple == 3)
	zzmObj.ToggleMultiple4:GetComponent('UIToggle'):Set(settings.multiple == 4)

	zzmObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(settings.choiceDouble)
	zzmObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not settings.choiceDouble)
	zzmObj.DoubleScoreText.parent.gameObject:SetActive(settings.choiceDouble)
	if settings.doubleScore == 0 then
		zzmObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		zzmObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..settings.doubleScore..'分'
	end
	ZhuanMaCon:Find('table'):GetComponent('UIGrid'):Reposition()   
end

function this.GetHongZhongSaveSetting()
	local settings ={}
	settings.rounds 					= 8
	settings.size 						= 2
	settings.minorityMode 			= false
	settings.bird 						= 2
	settings.paymentType 				= 0
	settings.hongZhongCount 			= 4
	settings.trusteeship 				= 0

	settings.dianPaoHu 					= false
	settings.bankerAddOne 				= false
	settings.huSevenPairs 				= false
	settings.mustHu 					= false
	settings.floatScore 				= false
	settings.scoreHongZhongNon 			= false
	settings.scoreHongZhongNonNiaoBanker= false
	settings.hongZhongNonJiePao 		= false
	settings.birdAllHit 				= false
	settings.birdBankerStart 			= false
	settings.birdWinStart 			    = false
	settings.bird159 			    	= false
	settings.scoreQiangGangMo 			= false
	settings.scoreQiangGangInc 			= false
	settings.scoreQiangGangJiePao 		= false
	settings.scoreQiangGangHongZhong	= false
	settings.scoreBird					= true
	settings.trusteeshipDissolve		= true
	settings.trusteeshipRound			= 0

	settings.resultScore 				= false
	settings.resultLowerScore			= 10
	settings.resultAddScore				= 10
	
	settings.openIp						= false
	settings.openGps					= false
	settings.choiceDouble 				= false
	settings.doubleScore				= 10
	settings.multiple					= 2
	settings.baseScore 				= 1
	settings.scoreMingGangInc 			= false
	return settings
end

--设置红中麻将预设
function this.SetHongZhongPreSetting(settings)

	-- for k, v in pairs(settings) do
	-- 	print("___  **^^  __  ",k,v);
	-- end

	 hzmObj.Round4:GetComponent('UIToggle'):Set(4 ==settings.rounds)
	 hzmObj.Round8:GetComponent('UIToggle'):Set(8 == settings.rounds)
	 hzmObj.Round16:GetComponent('UIToggle'):Set(16 == settings.rounds)

	 hzmObj.People2:GetComponent('UIToggle'):Set(2 == settings.size)
	 hzmObj.People3:GetComponent('UIToggle'):Set(3 == settings.size)
	 hzmObj.People4:GetComponent('UIToggle'):Set(4 == settings.size)
	 hzmObj.lessPlayerStart:GetComponent("UIToggle"):Set(settings.minorityMode)
	 hzmObj.Number4:GetComponent('UIToggle'):Set(4 == settings.hongZhongCount)
	 hzmObj.Number8:GetComponent('UIToggle'):Set(8 == settings.hongZhongCount)
	--print("UnityEngine.PlayerPrefs.GetInt(\"hongzhong_dianPaoHu\",0):"..tostring(UnityEngine.PlayerPrefs.GetInt("hongzhong_dianPaoHu",0)));
	 hzmObj.DianPaoHu:GetComponent("UIToggle"):Set(settings.dianPaoHu);
	 hzmObj.Zhuangxian:GetComponent("UIToggle"):Set(settings.bankerAddOne);
	 hzmObj.KeHuQiDui:GetComponent("UIToggle"):Set(settings.huSevenPairs);
	 hzmObj.YouHuBiHu:GetComponent("UIToggle"):Set(settings.mustHu );
	 hzmObj.PiaoFen:GetComponent("UIToggle"):Set(settings.floatScore);
	 hzmObj.Double:GetComponent("UIToggle"):Set(settings.scoreHongZhongNon);
	 hzmObj.AllDouble:GetComponent("UIToggle"):Set(settings.scoreHongZhongNonNiaoBanker);
	 hzmObj.BuJiePao:GetComponent("UIToggle"):Set(settings.hongZhongNonJiePao);
	 hzmObj.HuangZhuangHuangGang:GetComponent('UIToggle'):Set(settings.huangZhuangHuangGang)
	 hzmObj.ToggleScoreGangInc.parent.gameObject:SetActive(settings.size ~= 4 or settings.minorityMode)
	 hzmObj.ToggleScoreGangInc:GetComponent('UIToggle'):Set(settings.scoreMingGangInc)
	 hzmObj.DiFenTunValue:GetComponent("UILabel").text = settings.baseScore..'分'

	 hzmObj.hit159bird:GetComponent("UIToggle"):Set(settings.bird159);
	 hzmObj.Winbird:GetComponent("UIToggle"):Set(settings.birdWinStart);	
	 hzmObj.BirdOneShoot:GetComponent("UIToggle"):Set(settings.birdAllHit);
	 hzmObj.DealerBird:GetComponent("UIToggle"):Set(settings.birdBankerStart);
	 hzmObj.GangEqualZimo:GetComponent("UIToggle"):Set(settings.scoreQiangGangMo);
	 hzmObj.QiangQuanBao:GetComponent("UIToggle"):Set(settings.scoreQiangGangInc);
	 hzmObj.QiangGangEqualDianPao:GetComponent("UIToggle"):Set(settings.scoreQiangGangJiePao);
	 hzmObj.CanQiangGangHu:GetComponent("UIToggle"):Set(settings.scoreQiangGangHongZhong);

	local isHaveBird = (
		 hzmObj.hit159bird:GetComponent("UIToggle").value or 	  
		 hzmObj.Winbird:GetComponent("UIToggle").value or 
		 hzmObj.BirdOneShoot:GetComponent("UIToggle").value or 
		 hzmObj.DealerBird:GetComponent("UIToggle").value 
					)
	 hzmObj.Nobird:GetComponent("UIToggle"):Set(not isHaveBird)
	--or  hzmObj.BirdOneShoot:GetComponent("UIToggle").value;

	--print("hongzhong_birdAllHit:"..settings.birdAllHit);
	--print("hongzhong_birdBankerStart:"..settings.birdBankerStart);

	 hzmObj.Bird2:GetComponent("UIToggle"):Set(settings.bird == 2);
	 hzmObj.Bird4:GetComponent("UIToggle"):Set(settings.bird == 4);
	 hzmObj.Bird6:GetComponent("UIToggle"):Set(settings.bird == 6);
	 hzmObj.Bird1Score:GetComponent("UIToggle"):Set(settings.scoreBird == 1);
	 hzmObj.Bird2Score:GetComponent("UIToggle"):Set(settings.scoreBird == 2);

	local isSeBird
	local isSeScore
	if  hzmObj.Nobird:GetComponent("UIToggle").value then --不抓鸟的情况下
		--	禁用跟抓鸟有关的点击
		 hzmObj.Bird2:GetComponent("BoxCollider").enabled = false;
		 hzmObj.Bird4:GetComponent("BoxCollider").enabled = false;
		 hzmObj.Bird6:GetComponent("BoxCollider").enabled = false;
		 hzmObj.Bird1Score:GetComponent("BoxCollider").enabled = false;
		 hzmObj.Bird2Score:GetComponent("BoxCollider").enabled = false;
		 hzmObj.Bird1Score:GetComponent("UIToggle"):Set(false);
		 hzmObj.Bird2Score:GetComponent("UIToggle"):Set(false);
		 hzmObj.Bird2:GetComponent("UIToggle"):Set(false);
		 hzmObj.Bird4:GetComponent("UIToggle"):Set(false);
		 hzmObj.Bird6:GetComponent("UIToggle"):Set(false);
	elseif  hzmObj.BirdOneShoot:GetComponent("UIToggle").value then --一鸟全中的情况下
		--	禁用跟抓鸟有关的点击
		 hzmObj.Bird2:GetComponent("BoxCollider").enabled = false;
		 hzmObj.Bird4:GetComponent("BoxCollider").enabled = false;
		 hzmObj.Bird6:GetComponent("BoxCollider").enabled = false;
		 hzmObj.Bird1Score:GetComponent("BoxCollider").enabled = true;
		 hzmObj.Bird2Score:GetComponent("BoxCollider").enabled = true;
		 hzmObj.Bird2:GetComponent("UIToggle"):Set(false);
		 hzmObj.Bird4:GetComponent("UIToggle"):Set(false);
		 hzmObj.Bird6:GetComponent("UIToggle"):Set(false);
		isSeScore = (
			 hzmObj.Bird1Score:GetComponent("UIToggle").value or
			 hzmObj.Bird2Score:GetComponent("UIToggle").value)
		if not isSeScore then 
			 hzmObj.Bird1Score:GetComponent("UIToggle"):Set(true);
		end
	else
		 hzmObj.Bird2:GetComponent("BoxCollider").enabled = true;
		 hzmObj.Bird4:GetComponent("BoxCollider").enabled = true;
		 hzmObj.Bird6:GetComponent("BoxCollider").enabled = true;
		 hzmObj.Bird1Score:GetComponent("BoxCollider").enabled = true;
		 hzmObj.Bird2Score:GetComponent("BoxCollider").enabled = true;

		isSeBird = (
			 hzmObj.Bird2:GetComponent("UIToggle").value or
			 hzmObj.Bird4:GetComponent("UIToggle").value or
			 hzmObj.Bird6:GetComponent("UIToggle").value
					)
		if not isSeBird then 
			 hzmObj.Bird4:GetComponent("UIToggle"):Set(true);
		end
		isSeScore = (
			 hzmObj.Bird1Score:GetComponent("UIToggle").value or
			 hzmObj.Bird2Score:GetComponent("UIToggle").value)
		if not isSeScore then 
			 hzmObj.Bird1Score:GetComponent("UIToggle"):Set(true);
		end
	end

	if (not  hzmObj.GangEqualZimo:GetComponent("UIToggle").value) and (not  hzmObj.QiangGangEqualDianPao:GetComponent("UIToggle").value) then
		 hzmObj.Nothing:GetComponent("UIToggle"):Set(true);
		 hzmObj.GangEqualZimo:GetComponent("UIToggle"):Set(false);
		 hzmObj.QiangGangEqualDianPao:GetComponent("UIToggle"):Set(false);

		 hzmObj.QiangQuanBao.gameObject:SetActive(false);
		 hzmObj.CanQiangGangHu.gameObject:SetActive(false);
	else
		 hzmObj.QiangQuanBao.gameObject:SetActive( hzmObj.GangEqualZimo:GetComponent("UIToggle").value);
		 hzmObj.CanQiangGangHu.gameObject:SetActive( hzmObj.QiangGangEqualDianPao:GetComponent("UIToggle").value);
	end

	--托管
	hzmObj.NoDelegateTime:GetComponent('UIToggle'):Set(settings.trusteeship == 0)
	hzmObj.DelegateTime1:GetComponent('UIToggle'):Set(settings.trusteeship == 60)
	hzmObj.DelegateTime2:GetComponent('UIToggle'):Set(settings.trusteeship == 120)
	hzmObj.DelegateTime3:GetComponent('UIToggle'):Set(settings.trusteeship == 180)
	hzmObj.DelegateTime5:GetComponent('UIToggle'):Set(settings.trusteeship == 300)
	hzmObj.DelegateThisRoundCancel:GetComponent('UIToggle'):Set(settings.trusteeshipDissolve)
	hzmObj.DelegateFullRoundCancel:GetComponent('UIToggle'):Set(not settings.trusteeshipDissolve and settings.trusteeshipRound == 0)
	hzmObj.DelegateThreeRoundCancel:GetComponent("UIToggle"):Set(settings.trusteeshipRound == 3)
	hzmObj.DelegateThisRoundCancel.parent.parent.gameObject:SetActive(settings.trusteeship ~= 0)

	 hzmObj.ToggleIPcheck:GetComponent("UIToggle"):Set(settings.openIp)
	 hzmObj.ToggleGPScheck:GetComponent("UIToggle"):Set(settings.openGps)
	 hzmObj.ToggleIPcheck.parent.gameObject:SetActive(settings.size>2 and CONST.IPcheckOn)

	 hzmObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(settings.size==2 or settings.minorityMode)
	 hzmObj.ToggleSettlementScoreSelect:GetComponent('UIToggle'):Set(settings.resultScore)
	 hzmObj.ToggleFewerScoreTxt:GetComponent('UILabel').fontSize=36
	 hzmObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = settings.resultLowerScore
	 hzmObj.ToggleAddScoreTxt:GetComponent('UILabel').fontSize=36
	 hzmObj.ToggleAddScoreTxt:GetComponent('UILabel').text = settings.resultAddScore
	if settings.choiceDouble == nil then
		settings.choiceDouble= false
		settings.doubleScore=10
		settings.multiple=2
	end
	 hzmObj.ToggleChoiceDouble.parent.gameObject:SetActive(settings.size==2 or settings.minorityMode)
     hzmObj.ToggleMultiple2.parent.gameObject:SetActive((settings.size==2 or settings.minorityMode) and settings.choiceDouble)
    
	 hzmObj.ToggleMultiple2:GetComponent('UIToggle'):Set(settings.multiple == 2)
	 hzmObj.ToggleMultiple3:GetComponent('UIToggle'):Set(settings.multiple == 3)
	 hzmObj.ToggleMultiple4:GetComponent('UIToggle'):Set(settings.multiple == 4)

	 hzmObj.ToggleChoiceDouble:GetComponent('UIToggle'):Set(settings.choiceDouble)
	 hzmObj.ToggleNoChoiceDouble:GetComponent('UIToggle'):Set(not settings.choiceDouble)
	 hzmObj.DoubleScoreText.parent.gameObject:SetActive(settings.choiceDouble)
	if settings.doubleScore == 0 then
		 hzmObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		 hzmObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..settings.doubleScore..'分'
	end
	HongZhongMaCon:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickMask(go)
	AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickPeopleChoose(go)
	AudioManager.Instance:PlayAudio('btn')
	if go.name == "2" then 
		numberOfPeople = 2
	elseif go.name == "3" then 
		numberOfPeople = 3
	elseif go.name == "4" then 
		numberOfPeople = 4
	else
		numberOfPeople = 2
	end  
	zzmObj.ToggleIPcheck.parent.gameObject:SetActive(numberOfPeople>2 and CONST.IPcheckOn)
	
	local minorityMode_=numberOfPeople~=2
	zzmObj.lessPlayerStart:GetComponent("UIToggle"):Set(minorityMode_)

	zzmObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(numberOfPeople==2 or minorityMode_) 
	zzmObj.ToggleChoiceDouble.parent.gameObject:SetActive(numberOfPeople == 2 or minorityMode_)
	zzmObj.ToggleMultiple2.parent.gameObject:SetActive((numberOfPeople == 2 or minorityMode_) and zzmObj.ToggleChoiceDouble:GetComponent("UIToggle").value)
	zzmObj.ToggleScoreGangInc.gameObject:SetActive(numberOfPeople ~= 4 or minorityMode_)
	ZhuanMaCon:Find('table'):GetComponent('UIGrid'):Reposition()  
end

function this.OnClickPeopleChooseHZM(go)
	AudioManager.Instance:PlayAudio('btn')
	if go.name == "PeopleNumber2" then 
		numberOfPeople = 2;
	elseif go.name == "PeopleNumber3" then 
		numberOfPeople = 3;
	elseif go.name == "PeopleNumber4" then 
		numberOfPeople = 4;
	else
		numberOfPeople = 2;
	end
	hzmObj.ToggleIPcheck.parent.gameObject:SetActive(numberOfPeople>2 and CONST.IPcheckOn)
	
	local minorityMode_=numberOfPeople~=2
	hzmObj.lessPlayerStart:GetComponent("UIToggle"):Set(minorityMode_)

	hzmObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(numberOfPeople==2 or minorityMode_)
	hzmObj.ToggleChoiceDouble.parent.gameObject:SetActive(numberOfPeople == 2 or minorityMode_)
	hzmObj.ToggleMultiple2.parent.gameObject:SetActive((numberOfPeople == 2 or minorityMode_) and hzmObj.ToggleChoiceDouble:GetComponent("UIToggle").value)
	hzmObj.ToggleScoreGangInc.parent.gameObject:SetActive(numberOfPeople ~= 4 or minorityMode_)
	HongZhongMaCon:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickCSPeopleChoose(go)
	AudioManager.Instance:PlayAudio('btn')
	print("OnClickCSPeopleChoose was called,go:"..tostring(go));
	if go.name == "CSPeopleNumber2" then 
		numberOfPeople = 2;
	elseif go.name == "CSPeopleNumber3" then 
		numberOfPeople = 3;
	elseif go.name == "CSPeopleNumber4" then 
		numberOfPeople = 4;
	else
		numberOfPeople = 2;
	end
	csmObj.ToggleIPcheck.parent.gameObject:SetActive(numberOfPeople>2 and CONST.IPcheckOn)
	
	local minorityMode_=numberOfPeople~=2
	csmObj.lessPlayerStart:GetComponent("UIToggle"):Set(minorityMode_)

	csmObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(numberOfPeople==2 or minorityMode_)
	csmObj.ToggleChoiceDouble.parent.gameObject:SetActive(numberOfPeople == 2 or minorityMode_)
	csmObj.ToggleMultiple2.parent.gameObject:SetActive((numberOfPeople == 2 or minorityMode_) and csmObj.ToggleChoiceDouble:GetComponent("UIToggle").value)
	csmObj.QueYiMen.parent.gameObject:SetActive(numberOfPeople ==2 or minorityMode_)
	csmObj.Queyise.gameObject:SetActive(not (csmObj.QueYiMen:GetComponent("UIToggle").value and (numberOfPeople ==2 or minorityMode_)))
	QiaoMaCon:Find('table'):GetComponent('UIGrid'):Reposition()     
end

function this.OnClickCSLessPlayerStart(go)
	AudioManager.Instance:PlayAudio('btn')
	local minorityMode_=csmObj.lessPlayerStart:GetComponent("UIToggle").value
	
	csmObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(minorityMode_)
	csmObj.ToggleChoiceDouble.parent.gameObject:SetActive(minorityMode_)
	csmObj.ToggleMultiple2.parent.gameObject:SetActive(minorityMode_ and csmObj.ToggleChoiceDouble:GetComponent("UIToggle").value)
	csmObj.QueYiMen.parent.gameObject:SetActive(minorityMode_)
	csmObj.Queyise.gameObject:SetActive(not (csmObj.QueYiMen:GetComponent("UIToggle").value and minorityMode_))
	QiaoMaCon:Find('table'):GetComponent('UIGrid'):Reposition()   
end

function this.OnClickZZLessPlayerStart(go)
	AudioManager.Instance:PlayAudio('btn')
	local minorityMode_=zzmObj.lessPlayerStart:GetComponent("UIToggle").value
	
	zzmObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(minorityMode_) 
	zzmObj.ToggleChoiceDouble.parent.gameObject:SetActive(minorityMode_)
	zzmObj.ToggleMultiple2.parent.gameObject:SetActive(minorityMode_ and zzmObj.ToggleChoiceDouble:GetComponent("UIToggle").value)
	zzmObj.ToggleScoreGangInc.gameObject:SetActive(minorityMode_)
	ZhuanMaCon:Find('table'):GetComponent('UIGrid'):Reposition()  
end

function this.OnClickHZLessPlayerStart(go)
	AudioManager.Instance:PlayAudio('btn')
	local minorityMode_=hzmObj.lessPlayerStart:GetComponent("UIToggle").value
	
	hzmObj.ToggleSettlementScoreSelect.parent.gameObject:SetActive(minorityMode_)
	hzmObj.ToggleChoiceDouble.parent.gameObject:SetActive(minorityMode_)
	hzmObj.ToggleMultiple2.parent.gameObject:SetActive(minorityMode_ and hzmObj.ToggleChoiceDouble:GetComponent("UIToggle").value)
	hzmObj.ToggleScoreGangInc.parent.gameObject:SetActive(minorityMode_)
	HongZhongMaCon:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.ShowRuleInfo(go)
	PanelManager.Instance:ShowWindow('panelHelp',roomType + 50)
end
function this.SetTitleInfo(optionData,gameName)
	wanFaTitle:GetComponent("UILabel").text = "当前玩法:"..gameName
end

function this.OnClickMask(go)
	AudioManager.Instance:PlayAudio('btn')
	PanelManager.Instance:HideWindow(gameObject.name);
	PanelManager.Instance:ShowWindow("panelSetPlay");
end

function this.OnClickButtonOK(go)
	AudioManager.Instance:PlayAudio('btn')
	
    local settings = {};
	
	print("roomType:"..roomType);

	if roomType == QiaoMaType then
		settings = this.GetChangShaMSetting();
	elseif roomType == ZhuanMaType then
		settings = this.GetZhuanZhuanMSetting();
	elseif roomType == HongZhongMaType then
		settings = this.GetHongZhongMSetting();
	end
	settings.paymentType = 3
	print("创建规则  MJ~~~  --------------------------");
	for k, v in pairs(settings) do
		print("Data__-  ",k,v)
	end
	print("----------------------------------------");
	--SendProxyMessage(msg, this.OnCreateClubPlayResult);
	this.CheckPlayWay(settings);
	PanelManager.Instance:HideWindow(gameObject.name);
end

function this.CheckPlayWay(body)
	--判断是增加，修改还是删除
	if optionData.addPlay == true then 
		optionData.currentOption = "addPlay";
		local msg 			= Message.New();
		msg.type 			= proxy_pb.CREATE_CLUB_PLAY;
		local bigbody 		= proxy_pb.PCreateClubPlay();
		bigbody.gameType 	= proxy_pb.MJ
		bigbody.roomType    = body.roomType
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
		bigbody.gameType    = proxy_pb.MJ
		bigbody.playId 		= optionData.playId;
		bigbody.settings 	= json:encode(body);
		bigbody.clubId = panelClub.clubInfo.clubId;
		msg.body 			= bigbody:SerializeToString();
		SendProxyMessage(msg, this.OnCreateClubPlayResult);
	else
		optionData.currentOption = "updateRule";
		local msg 			= Message.New();
		msg.type 			= proxy_pb.UPDATE_PLAY_RULE;
		local bigbody 		= proxy_pb.PUpdatePlayRule();
		bigbody.playId 		= optionData.playId;
		bigbody.clubId 		= panelClub.clubInfo.clubId;
		bigbody.ruleId 		= optionData.ruleId;
		bigbody.settings 	= json:encode(body);
		msg.body 			= bigbody:SerializeToString();
		SendProxyMessage(msg, this.OnCreateClubPlayResult);
	end
end
--获得红中麻将的设置
function this.GetHongZhongMSetting()

	local settings = {};
	settings.roomType 		= proxy_pb.HZM;
	print("proxy_pb.HZM:"..proxy_pb.HZM);
	local rounds = 8;
	if  hzmObj.Round4:GetComponent("UIToggle").value then
		rounds = 4;
	elseif  hzmObj.Round8:GetComponent("UIToggle").value then
		rounds = 8;
	elseif  hzmObj.Round16:GetComponent("UIToggle").value then
		rounds = 16;
	end

	local size = 2;
	if  hzmObj.People2:GetComponent("UIToggle").value then
		size = 2;
	elseif  hzmObj.People3:GetComponent("UIToggle").value then
		size = 3;
	elseif  hzmObj.People4:GetComponent("UIToggle").value then
		size = 4;
	end

	local bird = 2;
	if  hzmObj.Bird2:GetComponent("UIToggle").value then
		bird = 2;
	elseif  hzmObj.Bird4:GetComponent("UIToggle").value then
		bird = 4;
	elseif  hzmObj.Bird6:GetComponent("UIToggle").value then
		bird = 6
	end

	local hongZhongCount = 4;
	if  hzmObj.Number4:GetComponent("UIToggle").value then
		hongZhongCount = 4;
	else
		hongZhongCount = 8;
	end

	local scoreBird = 1;
	if  hzmObj.Bird1Score:GetComponent("UIToggle").value then
		scoreBird =  1;
	else
		scoreBird =  2;
	end

	local trusteeship = 0;
	if  hzmObj.NoDelegateTime:GetComponent("UIToggle").value then
		trusteeship = 0;
	elseif  hzmObj.DelegateTime1:GetComponent("UIToggle").value then
		trusteeship = 60;
	elseif  hzmObj.DelegateTime2:GetComponent("UIToggle").value then
		trusteeship = 120;
	elseif  hzmObj.DelegateTime3:GetComponent("UIToggle").value then
		trusteeship = 180;
	else
		trusteeship = 300;
	end

	local dianPaoHu 				=  hzmObj.DianPaoHu:GetComponent("UIToggle").value;
	local bankerAddOne 				=  hzmObj.Zhuangxian:GetComponent("UIToggle").value;
	local huSevenPairs 				=  hzmObj.KeHuQiDui:GetComponent("UIToggle").value;
	local mustHu 					=  hzmObj.YouHuBiHu:GetComponent("UIToggle").value;
	local floatScore 				=  hzmObj.PiaoFen:GetComponent("UIToggle").value;
	local scoreHongZhongNon 		=  hzmObj.Double:GetComponent("UIToggle").value;
	local scoreHongZhongNonNiaoBanker=  hzmObj.AllDouble:GetComponent("UIToggle").value;
	local hongZhongNonJiePao 		=  hzmObj.BuJiePao:GetComponent("UIToggle").value;
	local birdAllHit 				=  hzmObj.BirdOneShoot:GetComponent("UIToggle").value;
	local birdBankerStart 			=  hzmObj.DealerBird:GetComponent("UIToggle").value;
	local birdWinStart 			    =  hzmObj.Winbird:GetComponent("UIToggle").value;
	local bird159 			    	=  hzmObj.hit159bird:GetComponent("UIToggle").value;
	local scoreQiangGangMo 			=  hzmObj.GangEqualZimo:GetComponent("UIToggle").value;
	local scoreQiangGangInc 		=  hzmObj.QiangQuanBao:GetComponent("UIToggle").value;
	local scoreQiangGangJiePao 		=  hzmObj.QiangGangEqualDianPao:GetComponent("UIToggle").value;
	local scoreQiangGangHongZhong 	=  hzmObj.CanQiangGangHu:GetComponent("UIToggle").value;
	local trusteeshipDissolve		=  hzmObj.DelegateThisRoundCancel:GetComponent("UIToggle").value;
	local trusteeshipRound			=  hzmObj.DelegateThreeRoundCancel:GetComponent("UIToggle").value and 3 or 0;
	if settings.size ~= 4 or settings.minorityMode then
		settings.scoreMingGangInc	= hzmObj.ToggleScoreGangInc:GetComponent("UIToggle").value	
	end

	settings.rounds 					= rounds;
	settings.size 						= size;
	settings.minorityMode				= hzmObj.lessPlayerStart:GetComponent("UIToggle").value;
	settings.bird 						= bird;
	settings.paymentType 				= 3;
	settings.hongZhongCount 			= hongZhongCount;
	settings.dianPaoHu 					= dianPaoHu;
	settings.bankerAddOne 				= bankerAddOne;
	settings.huSevenPairs 				= huSevenPairs;
	settings.mustHu 					= mustHu;
	settings.trusteeship				= trusteeship;
	settings.huangZhuangHuangGang 		=  hzmObj.HuangZhuangHuangGang:GetComponent('UIToggle').value
	settings.floatScore 				= floatScore;
	settings.scoreHongZhongNon 			= scoreHongZhongNon;
	if settings.scoreHongZhongNon then
		settings.scoreHongZhongNonNiaoBanker= scoreHongZhongNonNiaoBanker
	end
	settings.hongZhongNonJiePao 		= hongZhongNonJiePao;
	settings.birdAllHit 				= birdAllHit;
	settings.birdBankerStart 			= birdBankerStart;
	settings.birdWinStart 			    = birdWinStart;
	settings.bird159 			    	= bird159;
	settings.scoreQiangGangMo 			= scoreQiangGangMo;
	settings.scoreQiangGangInc 			= scoreQiangGangInc;
	settings.scoreQiangGangJiePao 		= scoreQiangGangJiePao;
	settings.scoreQiangGangHongZhong	= settings.scoreQiangGangMo and true or (scoreQiangGangHongZhong and settings.scoreQiangGangJiePao);
	settings.scoreBird					= scoreBird;
	settings.trusteeshipDissolve		= trusteeshipDissolve;
	settings.trusteeshipRound			= trusteeshipRound;
	
	local resultScore =  hzmObj.ToggleSettlementScoreSelect:GetComponent("UIToggle").value
	local resultLowerScore = tonumber( hzmObj.ToggleFewerScoreTxt:GetComponent('UILabel').text)
	local resultAddScore = tonumber( hzmObj.ToggleAddScoreTxt:GetComponent('UILabel').text)
	settings.resultScore = (settings.size == 2 or settings.minorityMode) and resultScore or false
	settings.resultLowerScore=resultLowerScore
	settings.resultAddScore=resultAddScore
	settings.openIp						=  (settings.size == 2) and false or hzmObj.ToggleIPcheck:GetComponent("UIToggle").value
	settings.openGps					=  (settings.size == 2) and false or hzmObj.ToggleGPScheck:GetComponent("UIToggle").value

	local label1= hzmObj.DiFenTunValue:GetComponent('UILabel').text
	settings.baseScore=tonumber(string.match(label1, "%d+")) 
	if settings.size == 2 or settings.minorityMode then
		settings.choiceDouble= hzmObj.ToggleChoiceDouble:GetComponent("UIToggle").value
        local label_=  hzmObj.DoubleScoreText:GetComponent('UILabel').text
        if label_=='不限分' then
            settings.doubleScore=0
        else
            settings.doubleScore=tonumber(string.sub(label_,7,-4))    
        end
        if  hzmObj.ToggleMultiple2:GetComponent('UIToggle').value then
            settings.multiple=2
        elseif  hzmObj.ToggleMultiple3:GetComponent('UIToggle').value then
            settings.multiple=3
        else
            settings.multiple=4
		end
	end
	
	return settings;
end
--获得长沙麻将的设置
function this.GetChangShaMSetting()
	local settings = {}
	local rounds = 8
	if csmObj.ToggleRound8:GetComponent("UIToggle").value then
		rounds = 8
	else
		rounds = 16
	end
	if  csmObj.PeopleNumber2:GetComponent("UIToggle").value then
		numberOfPeople = 2
	elseif csmObj.PeopleNumber3:GetComponent("UIToggle").value then
		numberOfPeople = 3
	elseif csmObj.PeopleNumber4:GetComponent("UIToggle").value then
		numberOfPeople = 4
	else
		numberOfPeople = 2
	end

	local gangCount = 2
	if csmObj.Kaigang2:GetComponent("UIToggle").value then
		gangCount = 2
	else
		gangCount = 4
	end

	local trusteeship = 0 ;
	if csmObj.NoDelegateTime:GetComponent("UIToggle").value then
		trusteeship = 0 ;
	elseif csmObj.DelegateTime1:GetComponent("UIToggle").value then
		trusteeship = 60;
	elseif csmObj.DelegateTime2:GetComponent("UIToggle").value then
		trusteeship = 120;
	elseif csmObj.DelegateTime3:GetComponent("UIToggle").value then
		trusteeship = 180;
	else
		trusteeship = 300;
	end

	settings.paymentType 			= 3
	settings.size 					= numberOfPeople
	settings.minorityMode			= csmObj.lessPlayerStart:GetComponent("UIToggle").value
	settings.roomType 				= proxy_pb.CSM
	settings.rounds 				= rounds
	settings.gangMahjongCount 		= gangCount
	settings.trusteeship			= trusteeship
	settings.bankerAddOne 			= csmObj.CustomizeZhuangxian:GetComponent("UIToggle").value
	settings.floatScore 			= csmObj.CustomizePiaofen:GetComponent("UIToggle").value
	settings.tianDiHu 				= csmObj.CustomizeTiandihu:GetComponent("UIToggle").value
	settings.quanQiuRen 			= csmObj.CustomizeQuanqiuren:GetComponent("UIToggle").value
	settings.missGuoHu 				= csmObj.ToggleMissGuoHu:GetComponent("UIToggle").value
	settings.menQing				= csmObj.CustomizeMenQing:GetComponent("UIToggle").value
	if settings.menQing then
		settings.menQingZiMo			= csmObj.CustomizeMenQingZiMo:GetComponent("UIToggle").value
	end
	settings.queYiMen				= (settings.size == 2 or settings.minorityMode) and csmObj.QueYiMen:GetComponent("UIToggle").value or false

	settings.shQueYiSe 				= (not settings.queYiMen) and csmObj.Queyise:GetComponent("UIToggle").value or false
	settings.shBanBanHu 			= csmObj.Banbanhu:GetComponent("UIToggle").value
	settings.shJieJieGao 			= csmObj.Jiejiegao:GetComponent("UIToggle").value
	settings.shYiZhiHua 			= csmObj.Yizhihua:GetComponent("UIToggle").value
	settings.shSanTong 				= csmObj.Santong:GetComponent("UIToggle").value
	settings.shJinTongYuNv 			= csmObj.Jintongyunv:GetComponent("UIToggle").value
	settings.shDaSiXi 				= csmObj.Dasixi:GetComponent("UIToggle").value
	settings.shLiuLiuShun 			= csmObj.Liuliushun:GetComponent("UIToggle").value
    settings.ztDaSiXi 				= csmObj.Zhongtudasixi:GetComponent("UIToggle").value
    settings.ztLiuLiuShun 			= csmObj.Zhongtuliuliushun:GetComponent("UIToggle").value
	settings.trusteeshipDissolve 	= csmObj.DelegateThisRoundCancel:GetComponent("UIToggle").value
	settings.trusteeshipRound 		= csmObj.DelegateThreeRoundCancel:GetComponent("UIToggle").value and 3 or 0

	local birdType = 0
	local bridAlgorithm = 2
	local birdNum = 4
	if csmObj.ToggleWinPos:GetComponent("UIToggle").value then
		birdType = 2
	elseif csmObj.Toggle13579Bird:GetComponent("UIToggle").value then
		birdType = 1
	elseif csmObj.ToggleNoBird:GetComponent("UIToggle").value then
		birdType = 0
	end
	if csmObj.CatchBirdDouble:GetComponent("UIToggle").value then
		bridAlgorithm = 1
	elseif csmObj.CatchBirdYiFen:GetComponent("UIToggle").value then
		bridAlgorithm = 2
	end
	if csmObj.Niao1:GetComponent("UIToggle").value then
		birdNum = 1
	elseif csmObj.Niao2:GetComponent("UIToggle").value then
		birdNum = 2
	elseif csmObj.Niao4:GetComponent("UIToggle").value then
		birdNum = 4
	elseif csmObj.Niao6:GetComponent("UIToggle").value then
		birdNum = 6
	end
	settings.birdWinStart = birdType == 2
	settings.bird13579 = birdType == 1
	settings.birdCompute = birdType ~= 0 and bridAlgorithm == 1
    settings.bird = birdType == 0 and 0 or birdNum
	settings.scoreBird = settings.birdCompute and 0 or 1

	if csmObj.ToggleRegularScoreOnButton:GetComponent("UIToggle").value then
		settings.fixedFloatScore=tonumber(string.sub(csmObj.RegularScoreTxt:GetComponent('UILabel').text,1,-4))
	else
		settings.fixedFloatScore=0
	end
	
	local resultScore =  csmObj.ToggleSettlementScoreSelect:GetComponent("UIToggle").value
	local resultLowerScore = tonumber( csmObj.ToggleFewerScoreTxt:GetComponent('UILabel').text)
	local resultAddScore = tonumber( csmObj.ToggleAddScoreTxt:GetComponent('UILabel').text)
	settings.resultScore = (settings.size == 2 or settings.minorityMode) and resultScore or false
	settings.resultLowerScore=resultLowerScore
	settings.resultAddScore=resultAddScore
	settings.openIp					= (settings.size == 2) and false or csmObj.ToggleIPcheck:GetComponent("UIToggle").value
	settings.openGps				= (settings.size == 2) and false or csmObj.ToggleGPScheck:GetComponent("UIToggle").value
	if settings.size == 2 or settings.minorityMode then
		settings.choiceDouble=csmObj.ToggleChoiceDouble:GetComponent("UIToggle").value
        local label_= csmObj.DoubleScoreText:GetComponent('UILabel').text
        if label_=='不限分' then
            settings.doubleScore=0
        else
            settings.doubleScore=tonumber(string.sub(label_,7,-4))    
        end
        if csmObj.ToggleMultiple2:GetComponent('UIToggle').value then
            settings.multiple=2
        elseif csmObj.ToggleMultiple3:GetComponent('UIToggle').value then
            settings.multiple=3
        else
            settings.multiple=4
        end
	end
	local cappingScore = 0
	if csmObj.ToggleCappingScore0:GetComponent('UIToggle').value then
		cappingScore = 0
	elseif csmObj.ToggleCappingScore15:GetComponent('UIToggle').value then
		cappingScore = 15
	elseif csmObj.ToggleCappingScore21:GetComponent('UIToggle').value then
		cappingScore = 21
	elseif csmObj.ToggleCappingScore42:GetComponent('UIToggle').value then
		cappingScore = 42
	end
	settings.cappingScore=cappingScore
	return settings
end
--获得转转麻将的设置
function this.GetZhuanZhuanMSetting()
	local settings = {};
	local rounds = 8;

	if zzmObj.ToggleRound8:GetComponent('UIToggle').value then
		rounds = 8
	else
		rounds = 16
	end
	if zzmObj.Bird2:GetComponent('UIToggle').value then
		bird = 2
	elseif zzmObj.Bird4:GetComponent('UIToggle').value then
		bird = 4
	else
		bird = 6
	end

	if  zzmObj.PeopleNumber2:GetComponent("UIToggle").value then
		numberOfPeople = 2;
	elseif zzmObj.PeopleNumber3:GetComponent("UIToggle").value then
		numberOfPeople = 3;
	elseif zzmObj.PeopleNumber4:GetComponent("UIToggle").value then
		numberOfPeople = 4;
	else
		numberOfPeople = 2;
	end

	local trusteeship = 0;
	if zzmObj.NoDelegateTime:GetComponent("UIToggle").value then
		trusteeship = 0;
	elseif zzmObj.DelegateTime1:GetComponent("UIToggle").value then
		trusteeship = 60;
	elseif zzmObj.DelegateTime2:GetComponent("UIToggle").value then
		trusteeship = 120;
	elseif zzmObj.DelegateTime3:GetComponent("UIToggle").value then
		trusteeship = 180;
	else
		trusteeship = 300;
	end

	local floatScore 				= zzmObj.PiaoFen:GetComponent("UIToggle").value;
	local birdAllHit 				= zzmObj.BirdOneShoot:GetComponent("UIToggle").value;
	local birdBankerStart 			= zzmObj.DealerBird:GetComponent("UIToggle").value;
	local birdWinStart 			    = zzmObj.Winbird:GetComponent("UIToggle").value;
	local bird159 			    	= zzmObj.hit159bird:GetComponent("UIToggle").value;

	settings.paymentType 			= 3;
	settings.size 					= numberOfPeople;
	settings.minorityMode			= zzmObj.lessPlayerStart:GetComponent("UIToggle").value;
	settings.roomType 				= proxy_pb.ZZM
	settings.huAsBanker 			= false;
	settings.rounds 				= rounds;
	settings.bird 					= bird;
	settings.trusteeship			=trusteeship;
	settings.dianPaoHu 				= zzmObj.DianPaoHu:GetComponent('UIToggle').value
	settings.bankerAddOne 			= zzmObj.ZhuangShuYing:GetComponent('UIToggle').value
	settings.huSevenPairs 			= zzmObj.KeHuQiDui:GetComponent('UIToggle').value
	settings.huangZhuangHuangGang 	= zzmObj.HuangZhuangHuangGang:GetComponent('UIToggle').value
	settings.floatScore 			= zzmObj.PiaoFen:GetComponent("UIToggle").value
	if settings.size ~= 4 or settings.minorityMode then
		settings.scoreMingGangInc			= zzmObj.ToggleScoreGangInc:GetComponent("UIToggle").value	
	end
	
	
	settings.birdAllHit 			= birdAllHit;
	settings.birdBankerStart 		= birdBankerStart;
	settings.birdWinStart 			 = birdWinStart;
	settings.bird159 			    = bird159;
	settings.trusteeshipDissolve	= zzmObj.DelegateThisRoundCancel:GetComponent("UIToggle").value;
	settings.trusteeshipRound		= zzmObj.DelegateThreeRoundCancel:GetComponent("UIToggle").value and 3 or 0

	local resultScore =  zzmObj.ToggleSettlementScoreSelect:GetComponent("UIToggle").value
	local resultLowerScore = tonumber(zzmObj.ToggleFewerScoreTxt:GetComponent('UILabel').text)
	local resultAddScore = tonumber(zzmObj.ToggleAddScoreTxt:GetComponent('UILabel').text)
	settings.resultScore = (settings.size == 2 or settings.minorityMode) and resultScore or false 
	settings.resultLowerScore=resultLowerScore
	settings.resultAddScore=resultAddScore
	settings.openIp					= (settings.size == 2) and false or zzmObj.ToggleIPcheck:GetComponent("UIToggle").value
	settings.openGps				= (settings.size == 2) and false or zzmObj.ToggleGPScheck:GetComponent("UIToggle").value

	local label1= zzmObj.DiFenTunValue:GetComponent('UILabel').text
	settings.baseScore=tonumber(string.match(label1, "%d+")) 
	if settings.size == 2 or settings.minorityMode then
		settings.choiceDouble=zzmObj.ToggleChoiceDouble:GetComponent("UIToggle").value
        local label_= zzmObj.DoubleScoreText:GetComponent('UILabel').text
        if label_=='不限分' then
            settings.doubleScore=0
        else
            settings.doubleScore=tonumber(string.sub(label_,7,-4))    
        end
        if zzmObj.ToggleMultiple2:GetComponent('UIToggle').value then
            settings.multiple=2
        elseif zzmObj.ToggleMultiple3:GetComponent('UIToggle').value then
            settings.multiple=3
        else
            settings.multiple=4
        end
	end

	return settings;
end

function this.getIntByBoolean(value)
	if value then
		return 1;
	else
		return 0;
	end
end

function this.GetBooleanByInt(value)
	if value == 1 then
		return true;
	else
		return false;
	end
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

--抢杠
function this.OnClickButtonQiangGang(obj)
	AudioManager.Instance:PlayAudio('btn')
	if obj ==  hzmObj.GangEqualZimo.gameObject then
		 hzmObj.QiangQuanBao.gameObject:SetActive(true);
		 hzmObj.CanQiangGangHu.gameObject:SetActive(false);
	elseif obj ==  hzmObj.QiangGangEqualDianPao.gameObject then
		 hzmObj.QiangQuanBao.gameObject:SetActive(false);
		 hzmObj.CanQiangGangHu.gameObject:SetActive(true);
	else
		 hzmObj.QiangQuanBao.gameObject:SetActive(false);
		 hzmObj.CanQiangGangHu.gameObject:SetActive(false);
	end
end

--抓鸟
function this.OnClickButtonZhuaNiao_HongZhong(obj)
	AudioManager.Instance:PlayAudio('btn')
	local isSeBird
	local isSeScore
	if obj ==  hzmObj.Nobird.gameObject then   --不抓鸟的情况下
		--	禁用跟抓鸟有关的点击
		 hzmObj.Bird2:GetComponent("BoxCollider").enabled = false;
		 hzmObj.Bird4:GetComponent("BoxCollider").enabled = false;
		 hzmObj.Bird6:GetComponent("BoxCollider").enabled = false;
		 hzmObj.Bird1Score:GetComponent("BoxCollider").enabled = false;
		 hzmObj.Bird2Score:GetComponent("BoxCollider").enabled = false;
		 hzmObj.Bird1Score:GetComponent("UIToggle"):Set(false);
		 hzmObj.Bird2Score:GetComponent("UIToggle"):Set(false);
		 hzmObj.Bird2:GetComponent("UIToggle"):Set(false);
		 hzmObj.Bird4:GetComponent("UIToggle"):Set(false);
		 hzmObj.Bird6:GetComponent("UIToggle"):Set(false);
	elseif obj ==  hzmObj.BirdOneShoot.gameObject then   --一鸟全中的情况下
		--	禁用跟抓鸟有关的点击
		 hzmObj.Bird2:GetComponent("BoxCollider").enabled = false;
		 hzmObj.Bird4:GetComponent("BoxCollider").enabled = false;
		 hzmObj.Bird6:GetComponent("BoxCollider").enabled = false;
		 hzmObj.Bird2:GetComponent("UIToggle"):Set(false);
		 hzmObj.Bird4:GetComponent("UIToggle"):Set(false);
		 hzmObj.Bird6:GetComponent("UIToggle"):Set(false);
		 hzmObj.Bird1Score:GetComponent("BoxCollider").enabled = true;
		 hzmObj.Bird2Score:GetComponent("BoxCollider").enabled = true;
		isSeScore = (
			 hzmObj.Bird1Score:GetComponent("UIToggle").value or
			 hzmObj.Bird2Score:GetComponent("UIToggle").value)
		if not isSeScore then 
			 hzmObj.Bird1Score:GetComponent("UIToggle"):Set(true);
		end
	else
		 hzmObj.Bird2:GetComponent("BoxCollider").enabled = true;
		 hzmObj.Bird4:GetComponent("BoxCollider").enabled = true;
		 hzmObj.Bird6:GetComponent("BoxCollider").enabled = true;
		 hzmObj.Bird1Score:GetComponent("BoxCollider").enabled = true;
		 hzmObj.Bird2Score:GetComponent("BoxCollider").enabled = true;

		isSeBird = (
			 hzmObj.Bird2:GetComponent("UIToggle").value or
			 hzmObj.Bird4:GetComponent("UIToggle").value or
			 hzmObj.Bird6:GetComponent("UIToggle").value
					)
		if not isSeBird then 
			 hzmObj.Bird4:GetComponent("UIToggle"):Set(true);
		end
		isSeScore = (
			 hzmObj.Bird1Score:GetComponent("UIToggle").value or
			 hzmObj.Bird2Score:GetComponent("UIToggle").value)
		if not isSeScore then 
			 hzmObj.Bird1Score:GetComponent("UIToggle"):Set(true);
		end
	end
end

function this.OnClickButtonZhuaNiao_Zhuan(obj)
	AudioManager.Instance:PlayAudio('btn')
	local isSeBird
	if obj == zzmObj.Nobird.gameObject or obj == zzmObj.BirdOneShoot.gameObject then 
		zzmObj.Bird2.parent.gameObject:SetActive(false)
	else
		zzmObj.Bird2.parent.gameObject:SetActive(true)
	end
	ZhuanMaCon:Find('table'):GetComponent('UIGrid'):Reposition() 
end

function this.OnClickDelegateButton(go)
	if roomType == 0 then
		--长沙麻将
		csmObj.DelegateThisRoundCancel.parent.gameObject:SetActive(not csmObj.NoDelegateTime:GetComponent("UIToggle").value)
		QiaoMaCon:Find('table'):GetComponent('UIGrid'):Reposition()
	elseif roomType == 1 then
		--转转麻将
		zzmObj.DelegateThisRoundCancel.parent.gameObject:SetActive(not zzmObj.NoDelegateTime:GetComponent("UIToggle").value)
		ZhuanMaCon:Find('table'):GetComponent('UIGrid'):Reposition()
	elseif roomType == 2 then
		--红中麻将
		hzmObj.DelegateThisRoundCancel.parent.parent.gameObject:SetActive(not  hzmObj.NoDelegateTime:GetComponent("UIToggle").value)
		HongZhongMaCon:Find('table'):GetComponent('UIGrid'):Reposition()
	end
end
--选择打鸟或否
function this.OnClickChooseNiao(go)
	AudioManager.Instance:PlayAudio('btn');
	if go == zzmObj.ToggleOnNiao.gameObject or go == zzmObj.ToggleOffNiao.gameObject then
		if go == zzmObj.ToggleOnNiao.gameObject then
			zzmObj.PiaoFen:GetComponent("UIToggle"):Set(false);
		end
		zzmObj.NiaoValueText.parent.gameObject:SetActive(zzmObj.ToggleOnNiao:GetComponent("UIToggle").value);

	elseif go ==  hzmObj.ToggleOnNiao.gameObject or go ==  hzmObj.ToggleOffNiao.gameObject then
		if go ==  hzmObj.ToggleOnNiao.gameObject then
			 hzmObj.PiaoFen:GetComponent("UIToggle"):Set(false);
		end
		 hzmObj.NiaoValueText.parent.gameObject:SetActive( hzmObj.ToggleOnNiao:GetComponent("UIToggle").value);
	end
end
--打鸟分数
function this.OnClickChangeNiaoValue(go)
	AudioManager.Instance:PlayAudio('btn');
	if go == csmObj.AddButtonNiao.gameObject or go == zzmObj.AddButtonNiao.gameObject or go ==  hzmObj.AddButtonNiao.gameObject then
		niaoValue = niaoValue + 10;
		if niaoValue > 100 then
			niaoValue = 100;
		end
	else
		niaoValue = niaoValue - 10;
		if niaoValue < 10 then
			niaoValue = 10;
		end
	end
	if go == csmObj.AddButtonNiao.gameObject or go == csmObj.SubtractButtonNiao.gameObject then
		csmObj.NiaoValueText:GetComponent("UILabel").text = niaoValue.."分";
	elseif go == zzmObj.AddButtonNiao.gameObject or go == zzmObj.SubtractButtonNiao.gameObject then
		zzmObj.NiaoValueText:GetComponent("UILabel").text = niaoValue.."分";
	elseif go ==  hzmObj.AddButtonNiao.gameObject or go ==  hzmObj.SubtractButtonNiao.gameObject then
		 hzmObj.NiaoValueText:GetComponent("UILabel").text = niaoValue .. "分";
	end
end
--飘分选择
function this.OnClickPiaoFen(go)
	AudioManager.Instance:PlayAudio('btn')
	if go == csmObj.CustomizePiaofen.gameObject then
		if go:GetComponent("UIToggle").value == true then
			csmObj.ToggleOffNiao:GetComponent("UIToggle"):Set(true);
			csmObj.NiaoValueText.parent.gameObject:SetActive(false);
			csmObj.ToggleRegularScoreOffButton:GetComponent('UIToggle'):Set(true)
			csmObj.ToggleRegularScoreOnButton:GetComponent('UIToggle'):Set(false)
			csmObj.RegularScoreTxt.parent.gameObject:SetActive(false)
		end
	elseif go == zzmObj.PiaoFen.gameObject then
		if go:GetComponent("UIToggle").value == true then
			zzmObj.ToggleOffNiao:GetComponent("UIToggle"):Set(true);
			zzmObj.NiaoValueText.parent.gameObject:SetActive(false);
		end
	elseif go ==  hzmObj.PiaoFen.gameObject then
		if go:GetComponent("UIToggle").value == true then
			 hzmObj.ToggleOffNiao:GetComponent("UIToggle"):Set(true);
			 hzmObj.NiaoValueText.parent.gameObject:SetActive(false);
		end
	end
end

function this.OnClickQueYiMenCSM(go)
	csmObj.Queyise.gameObject:SetActive(not csmObj.QueYiMen:GetComponent("UIToggle").value)
end
function this.OnClickFewerButtonCSM(go)
	AudioManager.Instance:PlayAudio('btn')
	local fewerValue=tonumber(csmObj.ToggleFewerScoreTxt:GetComponent('UILabel').text)
    if csmObj.ToggleFewerAddButton.gameObject == go then
		fewerValue = fewerValue + 1
		if fewerValue > 100 then
			fewerValue = 100
		end
    elseif csmObj.ToggleFewerSubtractButton.gameObject == go then
		fewerValue = fewerValue - 1
		if fewerValue < 1 then
			fewerValue = 1
		end
	end
	csmObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = fewerValue
end

function this.OnClickAddButtonCSM(go)
	AudioManager.Instance:PlayAudio('btn')
	local addValue = tonumber(csmObj.ToggleAddScoreTxt:GetComponent('UILabel').text)
    if csmObj.ToggleAddAddButton.gameObject == go then
		addValue = addValue + 1
		if addValue > 100 then
			addValue = 100
		end
    elseif csmObj.ToggleAddSubtractButton.gameObject == go then
		addValue = addValue - 1
		if addValue < 1 then
			addValue = 1
		end
	end
	csmObj.ToggleAddScoreTxt:GetComponent('UILabel').text = addValue
end

function this.OnClickFewerButtonZZM(go)
	AudioManager.Instance:PlayAudio('btn')
	local fewerValue=tonumber(zzmObj.ToggleFewerScoreTxt:GetComponent('UILabel').text)
    if zzmObj.ToggleFewerAddButton.gameObject == go then
		fewerValue = fewerValue + 1
		if fewerValue > 100 then
			fewerValue = 100
		end
    elseif zzmObj.ToggleFewerSubtractButton.gameObject == go then
		fewerValue = fewerValue - 1
		if fewerValue < 1 then
			fewerValue = 1
		end
	end
	zzmObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = fewerValue
end

function this.OnClickAddButtonZZM(go)
	AudioManager.Instance:PlayAudio('btn')
	local addValue = tonumber(zzmObj.ToggleAddScoreTxt:GetComponent('UILabel').text)
    if zzmObj.ToggleAddAddButton.gameObject == go then
		addValue = addValue + 1
		if addValue > 100 then
			addValue = 100
		end
    elseif zzmObj.ToggleAddSubtractButton.gameObject == go then
		addValue = addValue - 1
		if addValue < 1 then
			addValue = 1
		end
	end
	zzmObj.ToggleAddScoreTxt:GetComponent('UILabel').text = addValue
end

function this.OnClickFewerButtonHZM(go)
	AudioManager.Instance:PlayAudio('btn')
	local fewerValue=tonumber( hzmObj.ToggleFewerScoreTxt:GetComponent('UILabel').text)
    if  hzmObj.ToggleFewerAddButton.gameObject == go then
		fewerValue = fewerValue + 1
		if fewerValue > 100 then
			fewerValue = 100
		end
    elseif  hzmObj.ToggleFewerSubtractButton.gameObject == go then
		fewerValue = fewerValue - 1
		if fewerValue < 1 then
			fewerValue = 1
		end
	end
	 hzmObj.ToggleFewerScoreTxt:GetComponent('UILabel').text = fewerValue
end

function this.OnClickAddButtonHZM(go)
	AudioManager.Instance:PlayAudio('btn')
	local addValue = tonumber( hzmObj.ToggleAddScoreTxt:GetComponent('UILabel').text)
    if  hzmObj.ToggleAddAddButton.gameObject == go then
		addValue = addValue + 1
		if addValue > 100 then
			addValue = 100
		end
    elseif  hzmObj.ToggleAddSubtractButton.gameObject == go then
		addValue = addValue - 1
		if addValue < 1 then
			addValue = 1
		end
	end
	 hzmObj.ToggleAddScoreTxt:GetComponent('UILabel').text = addValue
end

function this.OnClickChoiceDoubleCSM(go)
	AudioManager.Instance:PlayAudio('btn')
    local choiceDouble
	if csmObj.ToggleChoiceDouble.gameObject == go then
		choiceDouble = true
	else
		choiceDouble = false
	end
	csmObj.DoubleScoreText.parent.gameObject:SetActive(choiceDouble)
    csmObj.ToggleMultiple2.parent.gameObject:SetActive(choiceDouble)
    QiaoMaCon:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickChangeDoubleScoreCSM(go)
	AudioManager.Instance:PlayAudio('btn')
    local doubleScore
    local label_= csmObj.DoubleScoreText:GetComponent('UILabel').text
    if label_=='不限分' then
        doubleScore=0
    else
        doubleScore=tonumber(string.sub(label_,7,-4))    
    end
	if csmObj.AddDoubleScoreButton.gameObject == go then
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
		csmObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		csmObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..doubleScore..'分'
	end
end

function this.OnClickRegularScore(go)
	AudioManager.Instance:PlayAudio('btn')
	local choiceRegular
	if csmObj.ToggleRegularScoreOnButton.gameObject == go then
		csmObj.CustomizePiaofen:GetComponent('UIToggle'):Set(false)
		choiceRegular = true
	else
		choiceRegular = false
	end
	csmObj.RegularScoreTxt.parent.gameObject:SetActive(choiceRegular)
end

function this.OnClickChangeRegularScore(go)
    AudioManager.Instance:PlayAudio('btn')
    local label_= csmObj.RegularScoreTxt:GetComponent('UILabel').text
    local regularScore=tonumber(string.sub(label_,1,-4))
	if csmObj.RegularAddButton.gameObject == go then
		regularScore = regularScore + 1
		if regularScore > 10 then
			regularScore = 1
		end
	else
		regularScore = regularScore - 1
		if regularScore < 1 then
			regularScore = 10
		end
	end

	csmObj.RegularScoreTxt:GetComponent('UILabel').text = regularScore..'分'
end

function this.OnClickChoiceDoubleZZM(go)
	AudioManager.Instance:PlayAudio('btn')
    local choiceDouble
	if zzmObj.ToggleChoiceDouble.gameObject == go then
		choiceDouble = true
	else
		choiceDouble = false
	end
	zzmObj.DoubleScoreText.parent.gameObject:SetActive(choiceDouble)
    zzmObj.ToggleMultiple2.parent.gameObject:SetActive(choiceDouble)
    ZhuanMaCon:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickChangeDoubleScoreZZM(go)
	AudioManager.Instance:PlayAudio('btn')
    local doubleScore
    local label_= zzmObj.DoubleScoreText:GetComponent('UILabel').text
    if label_=='不限分' then
        doubleScore=0
    else
        doubleScore=tonumber(string.sub(label_,7,-4))    
    end
	if zzmObj.AddDoubleScoreButton.gameObject == go then
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
		zzmObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		zzmObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..doubleScore..'分'
	end
end

function this.OnClickChoiceDoubleHZM(go)
	AudioManager.Instance:PlayAudio('btn')
    local choiceDouble
	if  hzmObj.ToggleChoiceDouble.gameObject == go then
		choiceDouble = true
	else
		choiceDouble = false
	end
	 hzmObj.DoubleScoreText.parent.gameObject:SetActive(choiceDouble)
     hzmObj.ToggleMultiple2.parent.gameObject:SetActive(choiceDouble)
    HongZhongMaCon:Find('table'):GetComponent('UIGrid'):Reposition()
end

function this.OnClickChangeDoubleScoreHZM(go)
	AudioManager.Instance:PlayAudio('btn')
    local doubleScore
    local label_=  hzmObj.DoubleScoreText:GetComponent('UILabel').text
    if label_=='不限分' then
        doubleScore=0
    else
        doubleScore=tonumber(string.sub(label_,7,-4))    
    end
	if hzmObj.AddDoubleScoreButton.gameObject == go then
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
		 hzmObj.DoubleScoreText:GetComponent('UILabel').text = '不限分'
	else
		 hzmObj.DoubleScoreText:GetComponent('UILabel').text = '小于'..doubleScore..'分'
	end
end

function this.OnClickChangeDiFenValueZZM(go)
	AudioManager.Instance:PlayAudio('btn')
	local label_= zzmObj.DiFenTunValue:GetComponent('UILabel').text
	local baseScore = tonumber(string.match(label_, "%d+")) 
	if zzmObj.AddBtnDiFen.gameObject == go then
		baseScore = baseScore + 1
		if baseScore > 10 then
			baseScore = 10
		end
    elseif zzmObj.SubtractBtnDiFen.gameObject == go then
        baseScore = baseScore - 1
		if baseScore < 1 then
			baseScore = 1
		end
	end
	zzmObj.DiFenTunValue:GetComponent("UILabel").text = baseScore..'分'
end

function this.OnClickChangeDiFenValueHZM(go)
	AudioManager.Instance:PlayAudio('btn')
	local label_= hzmObj.DiFenTunValue:GetComponent('UILabel').text
	local baseScore = tonumber(string.match(label_, "%d+")) 
	if hzmObj.AddBtnDiFen.gameObject == go then
		baseScore = baseScore + 1
		if baseScore > 10 then
			baseScore = 10
		end
    elseif hzmObj.SubtractBtnDiFen.gameObject == go then
        baseScore = baseScore - 1
		if baseScore < 1 then
			baseScore = 1
		end
	end
	hzmObj.DiFenTunValue:GetComponent("UILabel").text = baseScore..'分'
end

function this.OnClickToggleNiaoType(go)
	AudioManager.Instance:PlayAudio('btn')
	local birdType = 0
	if csmObj.ToggleWinPos.gameObject == go then
		birdType = 2
	elseif csmObj.Toggle13579Bird.gameObject == go then
		birdType = 1
	elseif csmObj.ToggleNoBird.gameObject == go then
		birdType = 0
	end
	csmObj.CatchBirdDouble.parent.gameObject:SetActive(birdType~=0)
	csmObj.Niao1.parent.gameObject:SetActive(birdType~=0)
	QiaoMaCon:Find('table'):GetComponent('UIGrid'):Reposition()
end