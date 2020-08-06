--麻将的一些常量
CONST = {}
this = CONST

this.IPcheckOn=true
this.showAllGame=true

this.cardPrefabHand={
	'cardHandButtom',
	'cardHandRight',
	'cardHandTop',
	'cardHandLeft'
}

this.cardPrefabHand_Replay={
	'cardHandButtomNone',
	'cardPaiDownRight',
	'cardHandTop',
	'cardPaiDownLeft'
}

this.cardPrefabHandStandBg_Replay={
	'mj_01',
	'mj_07',
	'mj_09',
	'mj_07'
}

this.cardPrefabHandDownGridCell_Replay={
	Vector3.New(-90,70,0),
	Vector3.New(70,-26,0),
	Vector3.New(45,70,0),
	Vector3.New(70,26,0)
}

this.cardPrefabHandStandBg={
	'mj_02',
	'mj_05',
	'mj_03',
	'mj_05'
}

this.cardPrefabHandDownBg={
	'mj_01',
	'mj_07',
	'mj_09',
	'mj_07'
}

this.cardPrefabHandStandOffset={
	Vector3.New(1, -9.18, 0),
	Vector3.New(0, 0, 0),
	Vector3.New(0, 5, 0),
	Vector3.New(0, 0, 0)
}

this.cardPrefabHandDownOffset={
	Vector3.New(0, 13, 0),
	Vector3.New(0.8, 5.7, 0),
	Vector3.New(0.3, 7, 0),
	Vector3.New(0, 5.7, 0)
}

this.cardPrefabHandStandGridCell={
	Vector3.New(-90,70,0),
	Vector3.New(70,-29,0),
	Vector3.New(42,70,0),
	Vector3.New(70,29,0)
}




this.cardPrefabHandDownGridCell={
	Vector3.New(-87,70,0),
	Vector3.New(70,-26,0),
	Vector3.New(45,70,0),
	Vector3.New(70,26,0)
}

this.cardStandWanScaleWidth = 
{
	Vector3.New(98,143,0),
	Vector3.New(82,120,0)
	
}

this.cardStandTongTiaoScaleWidth = 
{
	Vector3.New(98,143,0),
	Vector3.New(82,120,0)
}

this.cardDownSize = {

	Vector3.New(98,142,0);
	Vector3.New(45,36,0);
	Vector3.New(50,70,0);
	Vector3.New(45,36,0);

}

this.TingFrameWidth = Vector3.New(780,170,0);

--鸟的出现位置
this.birdPos =
{
	{
		Vector3.New(-165,-139,0),
		Vector3.New(-55,-139,0),
		Vector3.New(55,-139,0),
		Vector3.New(165,-139,0),
		Vector3.New(-165,-279,0),
		Vector3.New(-55,-279,0),
		Vector3.New(55,-279,0),
		Vector3.New(165,-279,0),

	},
	{
		Vector3.New(275,-86,0),
		Vector3.New(275,54,0),
		Vector3.New(385,-86,0),
		Vector3.New(385,54,0),
		Vector3.New(496,-86,0),
		Vector3.New(496,54,0),
		Vector3.New(606,-86,0),
		Vector3.New(606,54,0),
	},
	{
		Vector3.New(-165,150,0),
		Vector3.New(-55,150,0),
		Vector3.New(55,150,0),
		Vector3.New(165,150,0),
		Vector3.New(-165,290,0),
		Vector3.New(-55,290,0),
		Vector3.New(55,290,0),
		Vector3.New(165,290,0),
	},
	{
		Vector3.New(-275,54,0),
		Vector3.New(-275,-86,0),
		Vector3.New(-385,54,0),
		Vector3.New(-385,-86,0),
		Vector3.New(-496,54,0),
		Vector3.New(-496,-86,0),
		Vector3.New(-606,54,0),
		Vector3.New(-606,-86,0),
	},
}


--溆浦老牌的一些常量
--手牌预制体名称
this.XPLPCardhandPrefabName = 
{	
	"xplpCardItem",
	"xplpCardItem",
	"xplpCardItem",
	"xplpCardItem",
}

--喜牌预制体名称
this.XPLPXiPrefabName = 
{
	'xplpXiBottomItem',
	'xplpXiRightItem',
	'xplpXiTopItem',
	'xplpXiLeftItem',
}

--出的牌预制体名称
this.XPLPThrowPrefabName = 
{
	'xplpThrowItem',
	'xplpThrowItem',
	'xplpThrowItem',
	'xplpThrowItem',
}


--溆浦老牌回放界面中，箍臭时，手牌grid的位置信息[这个grid是手牌的grid]
this.XPLPGuChouHandGridPos = 
{
	Vector3.New(382,-274,0),
	Vector3.New(504,312,0),
	Vector3.New(-384,297.8,0),
	Vector3.New(-505,-146.5,0),
}
--溆浦老牌回放界面中，不箍臭时，手牌grid的位置信息[这个grid是手牌的grid]
this.XPLPNoGuChouGridPos = 
{
	Vector3.New(382,-274,0),
	Vector3.New(504,312,0),
	Vector3.New(-380,297.8,0),
	Vector3.New(-505,-146.5,0),
}

--溆浦老牌回放界面中，界面缩放信息[自己的不缩放，其余三人都有缩放]
this.XPLPGridScale = 
{
	0.9,
	0.5,
	0.65,
	0.5,
}

--溆浦老牌回放中，喜牌的预制体名称
this.XPLPReplayXiPrefabName = 
{
	'xplpXiBottomItem',
	'xplpXiBottomItem',
	'xplpXiBottomItem',
	'xplpXiBottomItem',
}
