local dtz_pb 	= require 'dtz_pb'
local proxy_pb 	= require 'proxy_pb'
require "Lua.Game.GameLogic.dtz_Logic"

panelReplay_dtz = {}
local this = panelReplay_dtz
local gameObject
local message

local playerSize = 4;
local distances = {};--相隔距离游戏对象
local gpsPlayers = {};

local roomID
local roomTime
local roomRound
local ShowCardTip
local playerName={}
local playerIcon={}
local playerScore={}
local playerGroups ={}
local playerGridIn={}
local playerGridInCenter 	= {};
local playerGridOut={}
local playerRestCards	= {};--玩家剩余牌
local playerWarnning 	= {};
local playerRoomers 	= {};
local OutCardZhaDan={}
local OutCardZhaDanWenZi={}
local OutCardZhaDanWenZiBG={}
local OutCardFinish={}
local playerzi={}
local playerwenzi={}
local playerKuang={}
local roomSetting
local InCardItemPrefab;
local watchPlatesButtons = {};

local playerTrusteeship={}
local playerOfflineTime={}

local playerData={}
local mySeat;
local restTime;


local playerBonusScores = {};
local currentDeskScore = nil;
local roomData;
local bg
local bg1
local bg2
local bg3
local bg4
this.chatTexts = {}
this.fanHuiRoomNumber = nil
this.OnRoundStarted = nil
this.needCheckNet=true

local batteryLevel
local network
local pingLabel
local watchPanel;
local watchMask;
local watchGrid;
local watchPlatePrefab;



local scoreView={} --积分界面
local winSeat
local helpOutCardsIndex =1
local selectOutCardType
local selectOutCardTypeBG

local inCardColumLimit = 24;
local outCardColumLimit = 26;
local cutlimit = 15;

local overCenterCardCount = 24;--如果手牌低于这个数值，说明只有一行，要居中显示


local currentPlayState = nil;

local isPause = false
local playInterval = 1.5
local cutTime = 0.25;
local rawSpeed;
local playIndex = 1
local ButtonSlow
local ButtonPause
local ButtonFast
local FastLabel
local ButtonBack
local SlowLabel
local RoundDetail
local conFun;
local conTime;

local dtzPlateType = 1;--打筒子牌面类型

local dismissTypeTip

function this.Awake(obj)
	gameObject 			= obj;
    this.gameObject 	= obj
	message 			= gameObject:GetComponent('LuaBehaviour');
	roomID 				= gameObject.transform:Find('topbg/room/ID');
	roomTime 			= gameObject.transform:Find('time');
	roomRound 			= gameObject.transform:Find('topbg/round/num');
	ShowCardTip 		= gameObject.transform:Find('ShowCardTip');
	roomSetting 		= gameObject.transform:Find('setting');

	for i=0,3 do
		playerName[i] 				= gameObject.transform:Find('player'..i..'/info/name');
		playerIcon[i] 				= gameObject.transform:Find('player'..i..'/info/Texture');
		message:AddClick(playerIcon[i].gameObject, this.OnClickPlayerIcon)
		playerScore[i] 				= gameObject.transform:Find('player'..i..'/info/score');
		playerGroups[i] 			= gameObject.transform:Find('player'..i..'/info/group');
		playerGridIn[i] 			= gameObject.transform:Find('player'..i..'/GridIn');
		playerGridInCenter[i] 		= gameObject.transform:Find('player'..i..'/GridInCenter');
		playerGridOut[i] 			= gameObject.transform:Find('player'..i..'/Grid/GridOut');
		OutCardZhaDan[i] 			= gameObject.transform:Find('player'..i..'/Grid/zhadan');
		OutCardZhaDanWenZiBG[i] 	= gameObject.transform:Find('player'..i..'/Grid/zhadan/sp');
		OutCardZhaDanWenZi[i] 		= gameObject.transform:Find('player'..i..'/Grid/zhadan/lb');
		OutCardFinish[i] 			= gameObject.transform:Find('player'..i..'/info/OutCardFinish');
		playerzi[i] 				= gameObject.transform:Find('player'..i..'/texiaozi/pass')
		playerwenzi[i] 				= gameObject.transform:Find('player'..i..'/texiaozi/tishi')
		playerKuang[i] 				= gameObject.transform:Find('player'..i..'/info/kuang01');
		playerRoomers[i]			= gameObject.transform:Find('player'..i..'/info/roomer');
		playerTrusteeship[i] = gameObject.transform:Find('player'..i..'/info/trusteeship')
		playerOfflineTime[i] = gameObject.transform:Find('player'..i..'/info/offlineTime')
		if i > 0 then
			watchPlatesButtons[i]   = gameObject.transform:Find('player'..i..'/watchPlate');
			playerRestCards[i]		= gameObject.transform:Find('player'..i..'/restCards');
			playerWarnning[i]		= gameObject.transform:Find('player'..i..'/info/warnning');
			message:AddClick(watchPlatesButtons[i].gameObject,this.OnWatchPlateClick);
		end
	end
	bg 					= gameObject.transform:Find("bg")
	bg1 				= gameObject.transform:Find("bg1")
	bg2 				= gameObject.transform:Find("bg2")
	bg3 				= gameObject.transform:Find("bg3")
	bg4 				= gameObject.transform:Find("bg4")
	InCardItemPrefab  	= gameObject.transform:Find("player0/InCardItem");

	--积分界面
	scoreView 					= gameObject.transform:Find('scoreView');
	selectOutCardType 			= gameObject.transform:Find('selectOutCardType');
	selectOutCardTypeBG 		= gameObject.transform:Find('selectOutCardType/bg');
	this.changeBG(UnityEngine.PlayerPrefs.GetInt('ground_dtz', 1))
	this.Awake1()

	dismissTypeTip = gameObject.transform:Find('dismissTypeTip/Tip/text')
	message:AddClick(gameObject.transform:Find('dismissTypeTip/Tip/dismissTypeTipBtn').gameObject, function (go)
		gameObject.transform:Find('dismissTypeTip/Tip').gameObject:SetActive(false)
		gameObject.transform:Find('dismissTypeTip/dismissTypeTipBtn').gameObject:SetActive(true)
	end)
	message:AddClick(gameObject.transform:Find('dismissTypeTip/dismissTypeTipBtn').gameObject, function (go)
		gameObject.transform:Find('dismissTypeTip/Tip').gameObject:SetActive(true)
		gameObject.transform:Find('dismissTypeTip/dismissTypeTipBtn').gameObject:SetActive(false)
	end)

	rawSpeed = playInterval;
end

function this.Awake1()
	batteryLevel 	= gameObject.transform:Find('battery/level'):GetComponent('UISprite')
	network 		= gameObject.transform:Find('network'):GetComponent('UISprite')
	pingLabel 		= gameObject.transform:Find('ping'):GetComponent('UILabel')
	RegisterGameCallBack(dtz_pb.PONG, this.OnPong)
	message:AddPress(network.gameObject, function (go, state)
		pingLabel.gameObject:SetActive(state)
	end)

	for i = 0, 3 do
		playerBonusScores[i] = scoreView:Find("allScore/playerGrid/playItem"..i);
	end
	currentDeskScore = scoreView:Find("current5_10_KScore");

	ButtonSlow = gameObject.transform:Find('control/ButtonSlow')
	SlowLabel = gameObject.transform:Find('control/ButtonSlow/Label')
	ButtonPause = gameObject.transform:Find('control/ButtonPause');
	ButtonFast = gameObject.transform:Find('control/ButtonFast');
	FastLabel = gameObject.transform:Find('control/ButtonFast/Label')
	ButtonBack = gameObject.transform:Find('control/ButtonBack')
	watchPanel = gameObject.transform:Find("watchPanel");
	watchMask = gameObject.transform:Find("watchPanel/watchMask");
	watchGrid = gameObject.transform:Find("watchPanel/plateGrid");
	watchPlatePrefab = gameObject.transform:Find("watchPanel/card");


	message:AddClick(ButtonSlow.gameObject, 	this.OnClickButtonSlow);
	message:AddClick(ButtonPause.gameObject, 	this.OnClickButtonPause);
	message:AddClick(ButtonFast.gameObject, 	this.OnClickButtonFast);
	message:AddClick(ButtonBack.gameObject, 	this.OnClickButtonBack);
	message:AddClick(watchMask.gameObject, 		this.OnWatchMaskClick);
	--生成出牌
	for i = 0, 3 do
		playerGridOut[i].gameObject:SetActive(true)
		for j = 0, 51 do
			local obj =  NGUITools.AddChild(playerGridOut[i].gameObject, gameObject.transform:Find('outCardItem').gameObject)
			obj.name = j
			obj.transform.localScale = Vector3(0.58,0.58,0.58)
			obj.gameObject:SetActive(false)
		end
	end
	for i = 0, 3 do
		playerGridOut[i]:GetComponent('UIGrid'):Reposition()
	end
end
function this.Start()

end

function this.OnEnable()
	AudioManager.Instance:PlayMusic('ZD_Bgm', true);
	dtzPlateType = UnityEngine.PlayerPrefs.GetInt("dtzpaiSize", 1);
	gameObject.transform:Find('dismissTypeTip/Tip').gameObject:SetActive(false)
	gameObject.transform:Find('dismissTypeTip/dismissTypeTipBtn').gameObject:SetActive(true)
	print("dtzPlateType:"..dtzPlateType);
end

local whoShow
function this.WhoShow(data)
	panelLogin.HideNetWaitting()
	this.Reset()

	whoShow = data
	if not data.isNeedRequest then
		return
	end

	PanelManager.Instance:HideWindow('panelLobby')
	PanelManager.Instance:HideWindow('panelClub')
	local msg 	= Message.New();
	local b 	= proxy_pb.PRoundRecords()
	b.roomId 	= replayData.roomId;
	b.round 	= replayData.round;
	b.gameType 	= proxy_pb.DTZ;
	msg.type 	= proxy_pb.ROUND_RECORDS;
	msg.body 	= b:SerializeToString();
	SendProxyMessage(msg, this.OnGetRoundDetail);
	PanelManager.Instance:HideWindow('panelRecordDetail');
end

function this.Reset()
	playInterval 	= 1.5
	isPause 		= false
	playIndex 		= 1
	mySeat 			= -1

	ButtonPause:GetComponent('UIButton').normalSprite = 'zanting'
	FastLabel:GetComponent('UILabel').text = ''
	SlowLabel:GetComponent('UILabel').text = ''

	this.ClearRoom();

end


function this.InitPlayerData(serverData)
	--print("players.length:"..(#serverData.players))
	for i = 1, #serverData.players do
		local player = serverData.players[i];
		player.sex = player.sex == 0 and 1 or player.sex;
		if player.id == info_login.id then
			if mySeat == -1 then
				mySeat = player.seat
			else
				print('mySeat is not -1 mySeat:'..mySeat)
			end
		end
		table.insert(playerData,player);
	end
	--有可能时群主来看，他虽然不是参与者，但是也可以看
	if mySeat == -1 then
		mySeat = 0;
	end
	if whoShow.isSelectSeat then
		mySeat = whoShow.mySeat
	end
end


--填充座位上的玩家数据
function this.RefreshPlayer()
	function SetPlayerState(index,p)
		playerName[index].gameObject:SetActive(true)
		playerName[index]:GetComponent('UILabel').text = p.name;
		coroutine.start(LoadPlayerIcon, playerIcon[index]:GetComponent('UITexture'), p.icon);
		SetUserData(playerIcon[index].gameObject, p);
		playerRoomers[index].gameObject:SetActive(p.id == roomData.ownerId);
		if index > 0 then
			SetUserData(watchPlatesButtons[index].gameObject, p);
			--是否显示剩牌
			playerRestCards[index].gameObject:SetActive(roomData.setting.show);
		end
		playerIcon[index].gameObject:SetActive(true);
		playerScore[index].gameObject:SetActive(true);
		playerScore[index]:GetComponent('UILabel').text = p.score;

		if p.seat == 0 or p.seat == 2 then--A组
			playerGroups[index]:GetComponent("UISprite").spriteName = "扑克通用-A组标记";
		else
			playerGroups[index]:GetComponent("UISprite").spriteName = "扑克通用-B组标记";
		end
		playerGroups[index].gameObject:SetActive(playerSize == 4);

		playerScore[index]:GetComponent('UILabel').text = p.roundGrab and p.roundGrab or "0";
	end

	function hidePlayerState(index,p)
		playerName[index]:GetComponent('UILabel').text = '';
		playerIcon[index].gameObject:SetActive(true);
		playerIcon[index]:GetComponent('UITexture').mainTexture = nil;
		playerScore[index]:GetComponent('UILabel').text = '0';
		playerGridIn[index].gameObject:SetActive(false);
		playerGridInCenter[index].gameObject:SetActive(false);
		playerGridOut[index].gameObject:SetActive(false);
		OutCardZhaDan[index].gameObject:SetActive(false);
		playerGroups[index].gameObject:SetActive(false);
		playerRoomers[index].gameObject:SetActive(false);
		SetUserData(playerIcon[index].gameObject, nil);
	end



	for i=0,playerSize-1 do
		local p = this.GetPlayerDataByUIIndex(i)
		if p then
			SetPlayerState(this.GetUIIndex(i,playerSize),p);
			--设置离线状态
		else
			hidePlayerState(this.GetUIIndex(i,playerSize),p);
		end
	end

end


function this.OnGetRoundDetail(msg)
	local b = dtz_pb.RRoundRecords()
	b:ParseFromString(msg.body);
	print('b.setting.gameMode : '..tostring(b.setting.gameMode))
	dismissTypeTip:GetComponent("UILabel").text = b.diss
	RoundDetail 			= b;
	roomData				= {}
	roomData.setting 		= RoundDetail.setting;
	roomData.ownerId		= RoundDetail.ownerId;
	roomData.round 			= replayData.round;
	roomData.roomNumber 	= RoundDetail.roomNumber;
	playerSize 				= roomData.setting.size;
	conTime 				= coroutine.start(RefreshTime, roomTime:GetComponent("UILabel"), 1)
	this.InitPlayerData(RoundDetail);
	local setting_gound 	= GetDTZRuleString(roomData.setting);
	roomSetting:GetComponent('UILabel').text = setting_gound;
	roomSetting:GetChild(0):GetComponent('UILabel').text = setting_gound;
	
	this.SetRoomInfo(roomData);
	this.RefreshPlayer();
	this.RefreshMyGridIn();
	this.SetPlayerState();
	this.InitBonusScore();
	this.InitDeskScore();
	if #RoundDetail.records > 0 then
		this.RefreshBonusScore(RoundDetail.records[1].scoreBoards);
	end


	this.InitOutGridDepths();

	this.InitCardCounts();
	conFun = coroutine.start(this.AutoPlay);

end

--设置房间信息
function this.SetRoomInfo(roomData)

	--房间的玩法信息
	roomID:GetComponent("UILabel").text = roomData.roomNumber;
	local setting_gound = GetDTZRuleString(roomData.setting,false);
	this.SetRoundNum(roomData.round);
	roomSetting:GetComponent('UILabel').text 				= setting_gound;
	roomSetting:GetChild(0):GetComponent('UILabel').text 	= setting_gound;

end

function this.RefreshShangYouData(players)
	for i = 1, #players do
		local data = players[i];
		local index = this.GetUIIndex(this.GetUIIndexBySeat(data.seat),playerSize);

		local name ;
		OutCardFinish[index].gameObject:SetActive(data.roundOrder ~= -1);
		if data.roundOrder == 0 then
			name = '上游'
		elseif data.roundOrder == 1 then
			name = '二游'
		elseif data.roundOrder == 2 then
			name = '三游'
		elseif data.roundOrder == 3 then
			name = '下游'
		else
			name = ''
			OutCardFinish[index].gameObject:SetActive(false);
		end
		OutCardFinish[index]:GetComponent('UISprite').spriteName = name;
		if data.actionState == 2 then
			if roomData.activeSeat ~= data.seat then
				this.ShowVFX(index,true);
				local b = math.random(1, 3);
			end
		end
	end
end

function this.Update()

end


function this.SetPlayerState()

	--两人局
	if roomData.setting.size == 2 then
		playerName[0].parent.parent.gameObject:SetActive(true);
		playerName[1].parent.parent.gameObject:SetActive(true);
		playerName[2].parent.parent.gameObject:SetActive(false);
		playerName[3].parent.parent.gameObject:SetActive(false);
		--三人局
	elseif roomData.setting.size == 3 then
		playerName[0].parent.parent.gameObject:SetActive(true);
		playerName[1].parent.parent.gameObject:SetActive(true);
		playerName[2].parent.parent.gameObject:SetActive(false);
		playerName[3].parent.parent.gameObject:SetActive(true);
		--四人局
	elseif roomData.setting.size == 4 then
		playerName[0].parent.parent.gameObject:SetActive(true);
		playerName[1].parent.parent.gameObject:SetActive(true);
		playerName[2].parent.parent.gameObject:SetActive(true);
		playerName[3].parent.parent.gameObject:SetActive(true);
	end

end





function this.changeBG(ground)
	if ground == 1 then
		bg:GetComponent('UITexture').mainTexture = bg1:GetComponent('UITexture').mainTexture
	elseif ground == 2 then
		bg:GetComponent('UITexture').mainTexture = bg2:GetComponent('UITexture').mainTexture
	elseif ground == 3 then
		bg:GetComponent('UITexture').mainTexture = bg3:GetComponent('UITexture').mainTexture
	elseif ground == 4 then
		bg:GetComponent('UITexture').mainTexture = bg4:GetComponent('UITexture').mainTexture
	end
end


--通过UI上的index获取绑定再gameObject上的数据对象
function this.GetPlayerDataByUIIndex(index)
	local i = index + mySeat
	i = i % playerSize
	return this.GetPlayerDataBySeat(i)
end

--通过座位号返回再UI上的index
function this.GetUIIndexBySeat(seat)
	return (playerSize-mySeat+seat)%playerSize
end

function this.GetPlayerDataBySeat(seat)
	for i=1,#playerData do
		if playerData[i].seat == seat then
			return playerData[i]
		end
	end

	return nil
end

--通过playerSize 将UI上的index转换成特殊的UI上的index
function this.GetUIIndex(index,playerSize)
	if playerSize == 3 then
		if index == 2 then
			return 3;
		else
			return index;
		end
	else
		return index;
	end
end


--玩家出牌
function this.OnPlayerHand(seat, record)--显示其他玩家出的牌
	print('OnPlayerHand')
    for i=0,#playerGridOut do
		playerGridOut[i].gameObject:SetActive(false);
		playerwenzi[i].gameObject:SetActive(false);
		OutCardZhaDan[i].gameObject:SetActive(false);
    end
    if (not seat) or (not record) then
        return
	end
	local index = this.GetUIIndex(this.GetUIIndexBySeat(seat),playerSize);
	playerGridOut[index].gameObject:SetActive(true);
	this.RefreshOutGrid(playerGridOut[index],record,seat);
end

function this.RefreshMyGridIn()
	print('RefreshMyGridIn');
	for i=0,roomData.setting.size -1 do
        local pData = this.GetPlayerDataByUIIndex(i)
        if pData and pData.seat == mySeat then
			local centerGrid = playerGridInCenter[this.GetUIIndex(this.GetUIIndexBySeat(mySeat),playerSize)];
			local grid = playerGridIn[this.GetUIIndex(this.GetUIIndexBySeat(mySeat),playerSize)];
			local finalGrid = nil;
			print("mycard.length:"..tostring(#pData.cards));
			if #pData.cards > overCenterCardCount then
				finalGrid = grid;
				grid.gameObject:SetActive(true);
				centerGrid.gameObject:SetActive(false);
			else
				finalGrid = centerGrid;
				grid.gameObject:SetActive(false);
				centerGrid.gameObject:SetActive(true);
			end
			this.RefreshGrid(finalGrid, pData.cards);
        else
			playerGridInCenter[i].gameObject:SetActive(false);
			playerGridIn[i].gameObject:SetActive(false);
        end
    end
end


function this.RepositionGridIn()
	local index = this.GetUIIndex(this.GetUIIndexBySeat(mySeat),playerSize);
	local grid = playerGridIn[index].gameObject.activeSelf and playerGridIn[index] or playerGridInCenter[index];
	grid:GetComponent("UIGrid"):Reposition();

end


function this.OnPlayerPlay(record)
	print('OnPlayerPlay   玩家出牌了.........')

	this.OnPlayerHand(record.seat, record)
	print('当前玩家出的牌的个数 ：'..#record.cards)
	--scoreView.score.scoreLabel:GetComponent('UILabel').text=b.score and b.score or 0
	local pData = this.GetPlayerDataBySeat(record.seat);
	local index = this.GetUIIndex(this.GetUIIndexBySeat(record.seat),playerSize);
	--pData.cardCount = #b.hand.cards


	this.RemoveCards(record.cards,pData.cards);
	if mySeat == pData.seat then
		this.RefreshMyGridIn();
	else
		this.SetCardCounts(#pData.cards,record.seat);
	end
	this.HideAllVFX();
	this.PlayCardSound(record.cards,pData.sex,record.category,record.keyCount);
	this.SetOutCardFinish(record);
	this.RefreshBonusScore(record.scoreBoards);
	this.RefreshDeskScore(record);
	this.RefreshPlayerGrab(record);
	if record.audioScore then
		this.PlayerAddScroeAudio();
	end

end

function this.RemoveCards(outCards,HandCards)
	for i=1,#outCards do
		for j=1,#HandCards do
			if outCards[i] == HandCards[j] then
				table.remove(HandCards,j);
				break;
			end
		end
	end
end


function this.OnPlayerPass(record)
	print("玩家过牌。。。。。")

	local index = this.GetUIIndex(this.GetUIIndexBySeat(record.seat),playerSize);
	OutCardZhaDan[index].gameObject:SetActive(false);
	this.initOutCardGroup(playerGridOut[index])
	this.ShowVFX(index,true)
	AudioManager.Instance:PlayAudio(string.format('dtzpass_%d', this.GetPlayerDataBySeat(record.seat).sex));
	this.SetOutCardFinish(record);
	this.RefreshBonusScore(record.scoreBoards);
	this.RefreshDeskScore(record)
	this.RefreshPlayerGrab(record);
	if record.audioScore then
		this.PlayerAddScroeAudio();
	end


end


function this.SetOutCardFinish(record)

	local index = this.GetUIIndex(this.GetUIIndexBySeat(record.seat),playerSize);
	OutCardFinish[index].gameObject:SetActive(false);
	local name ;
	if record.roundOrder == 0 then
		name = '上游'
	elseif record.roundOrder == 1 then
		name = '二游'
	elseif record.roundOrder == 2 then
		name = '三游'
	elseif record.roundOrder == 3 then
		name = '下游'
	elseif record.roundOrder == -1 then
		name = ''
	end
	OutCardFinish[index]:GetComponent('UISprite').spriteName = name;
	OutCardFinish[index].gameObject:SetActive(record.roundOrder ~= -1 and #this.GetPlayerDataBySeat(record.seat).cards == 0);
	if record.roundOrder ~= -1 and #this.GetPlayerDataBySeat(record.seat).cards == 0 then
		AudioManager.Instance:PlayAudio('winerVoice');
	end
end


function this.PlayerAddScroeAudio()
	StartCoroutine(function ()
		WaitForSeconds(0.6);
		AudioManager.Instance:PlayAudio('addScore');
	end);
end



function this.PlayCardSound(cards,sex,category,keyCount)
	print("PlayCardSound:"..tostring(category));
	local soundName =''
	if category == 0 then
		soundName = string.format('dtzsingle_%d_%d', sex, this.ProcessCard(cards)[1].value);
	elseif category == 1 then	
		soundName = string.format('dtzdouble_%d_%d', sex, this.ProcessCard(cards)[1].value);
	elseif category == 2 then	
		local main,slave = dtz_Logic.SeperateMainAndSlave(this.ProcessCard(cards),category,roomData.setting.cardCount,keyCount);
		soundName = string.format('dtztriple_%d_%d', sex, main[1].value);
	elseif category == 3 then
		soundName = string.format('dtzliandui_%d', sex);
	elseif category == 4 then
		soundName = string.format('dtzwing_%d', sex);
	elseif category == 5 then
		soundName = string.format('dtzbomb_%d_%d', sex,#this.ProcessCard(cards));
		--this.PlayTailAudio("ZD_LittleBoom");
	elseif category == 6 then
		soundName = string.format('dtztongzi_%d_%d', sex,this.ProcessCard(cards)[1].value);
		--this.PlayTailAudio("ZD_LittleBoom");
	elseif category == 7 then
		soundName = string.format('ZD_LittleBoom');
	elseif category == 8 then
		soundName = string.format('dtzxi_%d_%d', sex,this.ProcessCard(cards)[1].value);
		--this.PlayTailAudio("ZD_LittleBoom");
	end
	print('声音 ：'..soundName)
	if soundName ~= nil then
		if category == 5 and #cards > 10 then
		else
			AudioManager.Instance:PlayAudio(soundName);
		end
	end
end

--播放尾音
function this.PlayTailAudio(soundName)
	StartCoroutine(function ()
		WaitForSeconds(0.5);
		AudioManager.Instance:PlayAudio(soundName);
	end);
end



--更新牌桌跟桌子上的数据
function this.OnRefreshBonusAndDesk(record)
	this.RefreshBonusScore(record.scoreBoards);
	this.RefreshDeskScore(record);
end

function this.ClearRoom()
	for i=0,3 do
		playerScore[i]:GetComponent('UILabel').text ='0'
		playerGroups[i].gameObject:SetActive(false);
		playerGridIn[i].gameObject:SetActive(false);
		playerGridOut[i].gameObject:SetActive(false);
		OutCardZhaDan[i].gameObject:SetActive(false);
		playerGridInCenter[i].gameObject:SetActive(false);
		playerzi[i].gameObject:SetActive(false);
		playerwenzi[i].gameObject:SetActive(false);
		OutCardFinish[i].gameObject:SetActive(false);
		playerKuang[i].gameObject:SetActive(false);
		playerTrusteeship[i].gameObject:SetActive(false);
		playerOfflineTime[i].gameObject:SetActive(false);
	end
	this.HideAllWarnning();
	this.HideAllVFX();

	tableClear(playerData);

end


function this.SetRoundNum(num)
	roomRound:GetComponent('UILabel').text = "第"..num..'局';
	--设置游戏规则面板
end

function this.SetSelectCard(chooseData)
	print("SetSelectCard was called,cards.length:"..#chooseData.cards);
	for i = 1, #chooseData.cards do
		print(' cards vaule：'.. chooseData.cards[i].value);
	end
	local grid = this.IsGridInNeedCenter() and playerGridInCenter[0] or playerGridIn[0];
	local setAlready = {};
	local countTable = {};

	for i = 0, grid.childCount - 1 do
		local card = grid:GetChild(i);
        this.SetCardSelectState(card.gameObject,false);
	end

	for i = 1, #chooseData.cards do
		for j = 0, grid.childCount-1 do
			local card = grid:GetChild(j);
			local uicardTrueValue = GetUserData(card.gameObject);

			if uicardTrueValue == chooseData.cards[i].trueValue and not setAlready[j] then
				if #countTable == #chooseData.cards then
					return ;
				end
				table.insert(countTable,j);
				setAlready[j] = j;
                this.SetCardSelectState(card.gameObject,true);
				break;
			end

		end
	end

	local m = 100;
end



function this.RefreshState()
    while gameObject.activeSelf do
        -- 修改电池电量
        batteryLevel.fillAmount =  UnityEngine.SystemInfo.batteryLevel

        -- 重设网络状态
        local networkType = PlatformManager.Instance:GetNetworkType()
        if networkType == 1 then
            network.spriteName = 'wifi' .. this.NetLevel()
        elseif networkType == 2 then
            network.spriteName = 'gprs' .. this.NetLevel()
        elseif string.find(network.spriteName, 'wifi') then
            network.spriteName = 'wifi0'
        else
            network.spriteName = 'gprs0'
        end

        coroutine.wait(10)
    end
end

function this.NetLevel()
    if string.len(pingLabel.text) == 0 then
        return 3
    end
    local ping = tonumber(pingLabel.text)
    if ping < 100 then
        return 3
    elseif ping < 200 then
        return 2
    else
        return 1
    end
end

function this.OnPong()
	local connect = NetWorkManager.Instance:FindConnet('game')
	if connect then
		pingLabel.text = Util.GetTime() - connect.LastHeartBeatTime
	else 
		pingLabel.text =  ''
	end
end


--给牌面赋值
function this.setPai(item,mycard)
	local t 		= item.transform:Find('type');
	local tSmall 	= item.transform:Find('typeSmall');
	local king1 	= item.transform:Find('king1');
	local king2 	= item.transform:Find('king2');
	local num 		= item.transform:Find('num');

	tSmall.gameObject:SetActive(false)
	king1.gameObject:SetActive(false)
	king2.gameObject:SetActive(false)
	num.gameObject:SetActive(false)
	t.gameObject:SetActive(false)
	SetUserData(item.gameObject, mycard);
	if mycard.trueValue == nil then
		print("trueValue is nil----------->");
		print("mycard.value:"..tostring(mycard.value));
		print("mycard.trueValue:"..tostring(mycard.trueValue));
		print("mycard.type:"..tostring(mycard.trueValue));
	end
	if mycard.trueValue < 52 then
		local strType
		local col = Color.white
		if mycard.type == 0 then
			strType='DiamondIcon1'
			col = Color.white
		elseif mycard.type == 1 then
			strType='ClubIcon'
			col.r = 51/255
			col.g = 52/255
			col.b = 57/255
		elseif mycard.type == 2 then
			strType='HeartIcon1'
			col = Color.white
		elseif mycard.type == 3 then
			strType='SpadeIcon'
			col.r = 51/255
			col.g = 52/255
			col.b = 57/255
		end
		if dtz_Logic.IsJocker(mycard) then
			king1:GetComponent("UISprite").spriteName = dtz_Logic.IsRedJocker(mycard) and "bJoker_1" or "xJoker_1"
			king1.gameObject:SetActive(true)
			king2:GetComponent("UISprite").spriteName = dtz_Logic.IsRedJocker(mycard) and "bJoker_2" or "xJoker_2"
			king2.gameObject:SetActive(true)
		else
			t.gameObject:SetActive(true)
			t:GetComponent('UISprite').spriteName		=tostring(strType);
			tSmall.gameObject:SetActive(true)
			tSmall:GetComponent('UISprite').spriteName	=tostring(strType);
			num.gameObject:SetActive(true)
			num:GetComponent('UISprite').spriteName 	= this.GetCardTypeString(mycard);
			num:GetComponent('UISprite').color=col
		end
	end
end



function this.GetCardTypeString(mycard)
	local typeString = "";
	if dtz_Logic.IsJocker(mycard) then
	else
		if dtzPlateType == 1 or dtzPlateType == 2 then
			typeString = 'card_'..mycard.value.."_1";
		else
			typeString = 'card_'..mycard.value
		end
	end

	return typeString;
end

--设置牌的depth
function this.setCardDepth(cardObj,depth)
	local t 		= cardObj.transform:Find('type');
	local tSmall 	= cardObj.transform:Find('typeSmall');
	local king1 	= cardObj.transform:Find('king1');
	local king2 	= cardObj.transform:Find('king2');
	local num 		= cardObj.transform:Find('num');
	local bg		= cardObj.transform:Find("bg");
	local xiordiZha = cardObj.transform:Find('xiordiZha');
	local tongzi 	= cardObj.transform:Find('tongzi');

	dtz_Logic.SetSpriteDepth(t:GetComponent("UISprite"),depth+1);
	dtz_Logic.SetSpriteDepth(tSmall:GetComponent("UISprite"),depth+1);
	dtz_Logic.SetSpriteDepth(king1:GetComponent("UISprite"),depth+1);
	dtz_Logic.SetSpriteDepth(king2:GetComponent("UISprite"),depth+1);
	dtz_Logic.SetSpriteDepth(num:GetComponent("UISprite"),depth+1);
	dtz_Logic.SetSpriteDepth(bg:GetComponent("UISprite"),depth-1);
	dtz_Logic.SetSpriteDepth(xiordiZha:GetComponent("UISprite"),depth);
	dtz_Logic.SetSpriteDepth(xiordiZha:Find("Sprite"):GetComponent("UISprite"),depth+1);
	dtz_Logic.SetSpriteDepth(tongzi:GetComponent("UISprite"),	depth);
	dtz_Logic.SetSpriteDepth(tongzi:Find("Sprite"):GetComponent("UISprite"),depth+1);
end

--分析数据
function this.ProcessCard(cards)
	local myList = {}
	if cards then
		for i = 1, #cards do
			local _type = GetPlateType(cards[i]);
			local _value = GetPlateNum(cards[i])+2;
			local _trueValue = cards[i];

			--大小王特殊处理
			if _value == 16 then
				if _type == 0 then--小王
					_value = 16;
				else
					_value = 17;
				end
			end

			table.insert(myList,{trueValue = _trueValue,type = _type,value = _value});
		end
	end
	return myList
end
--获取多张同值的牌型
function this.getMultipleCards(num,myList)
	local cardsGroup={}
	for i=5,15 do
		if myList[i] then
			if myList[i].num==num then
				table.insert(cardsGroup,myList[i])
			end
		end
	end
	return cardsGroup
end
--初始化手牌
function this.initCardGroup(grid)
	for i=0,grid.childCount-1 do 
		local card = grid:GetChild(i)
		card.gameObject:SetActive(false)
	end
end
--初始化出牌仓
function this.initOutCardGroup(grid)
	for i=0,grid.childCount-1 do
		grid:GetChild(i).gameObject:SetActive(false)
	end
end

local baseInCardDepth = 44;
--给手牌賦值
function this.refreshCardsValues(cardList, grid)
	print("refreshCardsValues----->");
	if #cardList <= inCardColumLimit then
		local depth = baseInCardDepth;
		for i = 1, #cardList do
			local card = nil;
			if i <= grid.childCount then
				card = grid.transform:GetChild(i-1).gameObject;
			else
				card = NGUITools.AddChild(grid.gameObject, InCardItemPrefab.gameObject);
				message:AddClick(card,this.OnClickCard);
                message:AddEventTrigger(card, this.OnMousePressHoverCard);
			end
			this.setPai(card,cardList[i]);
			this.setCardDepth(card,depth);
			this.SetMyGridInType(card);
			card.gameObject:SetActive(true);
			depth  = depth + 5;
		end

		--隐藏不需要的
		for i = #cardList, grid.childCount-1 do
			grid.transform:GetChild(i).gameObject:SetActive(false);
		end
	else
		local depth = baseInCardDepth;
		--第一排
		for i = 1, inCardColumLimit do
			local card = nil;
			if i <= grid.childCount then
				card = grid.transform:GetChild(i-1).gameObject;
			else
				card = NGUITools.AddChild(grid.gameObject, InCardItemPrefab.gameObject);
				message:AddClick(card,this.OnClickCard);
				message:AddEventTrigger(card, this.OnMousePressHoverCard);

			end
			this.setPai(card,cardList[i]);
			this.setCardDepth(card,depth);
			this.SetMyGridInType(card);
			card.gameObject:SetActive(true);
			depth = depth + 5;
		end

		--第二排
		depth = baseInCardDepth -20;
		for i = inCardColumLimit + 1, #cardList do
			local card = nil;
			if i <= grid.childCount then
				card = grid.transform:GetChild(i-1).gameObject;
			else
				card = NGUITools.AddChild(grid.gameObject, InCardItemPrefab.gameObject);
				message:AddClick(card,this.OnClickCard);
				message:AddEventTrigger(card, this.OnMousePressHoverCard);

			end
			this.setPai(card,cardList[i]);
			this.setCardDepth(card,depth);
			this.SetMyGridInType(card);
			card.gameObject:SetActive(true);
			depth = depth + 5;
		end

		--隐藏不显示的牌
		for i = #cardList, grid.childCount-1 do
			local card = grid.transform:GetChild(i);
			card.gameObject:SetActive(false);
		end
	end

	--全部置为未选择状态
	for i = 0, grid.childCount-1 do
		local card = grid.transform:GetChild(i);
		SetUserData(card:Find("bg").gameObject,false);
	end


	--标记地炸，筒子和喜牌，用颜色标记
	this.MarkSpecialByColor(grid);

	grid:GetComponent("UIGrid"):Reposition();
end

--给出牌赋值
function this.RefreshOutCards(mainCards,slaveCards,grid,layOutTable)

	--1.隐藏的
	for i = 1, #layOutTable.hideIndexs do
		grid.transform:GetChild(layOutTable.hideIndexs[i]-1).gameObject:SetActive(false);
	end

	--2.主牌
	for i = 1, #layOutTable.outCardIndex do
		local cardObj = grid.transform:GetChild(layOutTable.outCardIndex[i]-1).gameObject;
		cardObj:SetActive(true);
		this.setPai(cardObj,mainCards[i]);
		this.SetOutGridType(cardObj);
	end
	--3.带的牌
	for i = 1, #layOutTable.withCardsIndexs do
		local withCardObj = grid.transform:GetChild(layOutTable.withCardsIndexs[i]-1).gameObject;
		withCardObj:SetActive(true);
		this.setPai(withCardObj,slaveCards[i]);
		this.SetOutGridType(withCardObj);
	end
	--

end

--刷新出的牌
function this.RefreshOutGrid(grid, record,seat)
	print("RefreshOutGrid refreshGrid name "..grid.name..' card num:'..#record.cards)
	this.initOutCardGroup(grid)--初始化出牌仓
	local afterProscessCards = this.ProcessCard(record.cards);
	local mainCards,slaveCards = dtz_Logic.SeperateMainAndSlave(afterProscessCards,record.category,roomData.setting.cardCount,record.keyCount);
	local layOutTable = dtz_Logic.GetOutGridLayOut(outCardColumLimit,cutlimit,mainCards,slaveCards,this.GetUIIndex(this.GetUIIndexBySeat(seat),playerSize));
	this.RefreshOutCards(mainCards,slaveCards,grid,layOutTable)--给出牌赋值
end

function this.InitOutGridDepths()
	local baseDepth = 7;
	for i = 0, 3 do
		local grid = playerGridOut[i];

		for j = 1, outCardColumLimit do
			local item = grid:GetChild(j-1);
			item.transform:Find('type'):GetComponent("UISprite").depth 		= baseDepth + j*2;
			item.transform:Find('typeSmall'):GetComponent("UISprite").depth 	= baseDepth + j*2;
			item.transform:Find('king1'):GetComponent("UISprite").depth 		= baseDepth + j*2;
			item.transform:Find('king2'):GetComponent("UISprite").depth 		= baseDepth + j*2;
			item.transform:Find('num'):GetComponent("UISprite").depth 			= baseDepth + j*2;
			item.transform:Find('bg'):GetComponent("UISprite").depth 			= baseDepth + j*2 -1;
		end

		for j = outCardColumLimit + 1, 2* outCardColumLimit do
			local item = grid:GetChild(j-1);
			item.transform:Find('type'):GetComponent("UISprite").depth 		= baseDepth + (j-outCardColumLimit-5)*2;
			item.transform:Find('typeSmall'):GetComponent("UISprite").depth 	= baseDepth + (j-outCardColumLimit-5)*2;
			item.transform:Find('king1'):GetComponent("UISprite").depth 		= baseDepth + (j-outCardColumLimit-5)*2;
			item.transform:Find('king2'):GetComponent("UISprite").depth 		= baseDepth + (j-outCardColumLimit-5)*2;
			item.transform:Find('num'):GetComponent("UISprite").depth 			= baseDepth + (j-outCardColumLimit-5)*2;
			item.transform:Find('bg'):GetComponent("UISprite").depth 			= baseDepth + (j-outCardColumLimit-5)*2 -1;
		end


	end
end
--刷新自己手牌
function this.RefreshGrid(grid, cards)
	print("RefreshGrid refreshGrid name "..grid.name..' card num:'..#cards)
	local cardList = this.ProcessCard(cards)--分析数据  存到该表
    local args = {};
    args.cardCount = roomData.setting.cardCount;
    args.needCombination = false;
	cardList = dtz_Logic.InitDB(cardList,args);
	this.initCardGroup(grid)--初始化手牌
	this.refreshCardsValues(cardList,grid)--给手牌复制
end

--检测牌是否已经选择了
function this.CardBeenSelected(go)

	if not go then
		return false;
	end

	local isSelected = GetUserData(go.transform:Find("bg").gameObject);

	if not isSelected then
		return false;
	else
		return isSelected;
	end

end

--设置牌的选择状态
function this.SetCardSelectState(go,state)
	if not go then
		return;
	end;

	local isSelected = GetUserData(go.transform:Find("bg").gameObject);
	--1.这张牌还没有被设置过
	if isSelected == nil then
		SetUserData(go.transform:Find("bg").gameObject,state);
		if state then
			local pos = go.transform.localPosition;
			pos.y = pos.y + 30;
			go.transform.localPosition = pos;
		end
		--这张牌以前被设置过
	else
		if isSelected then
			--对于选择状态只处理将牌置为未选择状态
			if not state then
				SetUserData(go.transform:Find("bg").gameObject,state);
				local pos = go.transform.localPosition;
				pos.y = pos.y - 30;
				go.transform.localPosition = pos;
			end

		else
			--对于未选择状态值处理将牌置为选择状态
			if state then
				SetUserData(go.transform:Find("bg").gameObject,state);
				local pos = go.transform.localPosition;
				pos.y = pos.y + 30;
				go.transform.localPosition = pos;
			end
		end
	end
end


--更新历史得分，本局抓分，喜得分
function this.RefreshBonusScore(data)
	print("RefreshBonusScore was called");
	if #data == 0 or data == nil then
		print("invalid data in RefreshBonusScore !");
		return;
	end
	for i = 1, #data do
		local initItem = playerBonusScores[data[i].seat];
		initItem.gameObject:SetActive(true);
		initItem:Find("history"):GetComponent("UILabel").text 			= data[i].history;

		--玩家抓分后播放动画
		if tonumber(initItem:Find("now"):GetComponent("UILabel").text) ~= data[i].grab then
			local tw 	= initItem:Find("now"):GetComponent("TweenPosition");
			local twl 	= initItem:Find("now"):GetComponent("UILabel");
			local pos 	= initItem:Find("now").localPosition;
			tw.enabled 	= true;
			twl.color 	= Color.red;
			StartCoroutine(function ()
				WaitForSeconds(2);
				tw.enabled = false;
				twl.color = Color.white;
				initItem:Find("now").localPosition = pos;
			end);
		end
		initItem:Find("now"):GetComponent("UILabel").text 	= data[i].grab;
		initItem:Find("happyScore"):GetComponent("UILabel").text 	= (data[i].cycles + data[i].deep + data[i].happly);

	end

end

function this.SetBonusLayOut(playerSize)

	local bg = scoreView:Find("allScore");
	local grid = scoreView:Find("allScore/playerGrid");
	local finalHeight = 0;
	if playerSize == 4 then
		finalHeight = 30 + grid:GetComponent("UIGrid").cellHeight*2;
	else
		finalHeight = 30 + grid:GetComponent("UIGrid").cellHeight*playerSize;
	end
	bg:GetComponent("UISprite").height = finalHeight;
end


--初始化历史得分，本局抓分，喜得分
function this.InitBonusScore()

	if roomData.setting.cardCount == 3 then
		scoreView:Find("allScore/title/happyScore"):GetComponent("UILabel").text = "地炸/筒分";
	elseif roomData.setting.cardCount == 4 then
		scoreView:Find("allScore/title/happyScore"):GetComponent("UILabel").text = "喜总分";
    elseif roomData.setting.cardCount == 5 then
        scoreView:Find("allScore/title/happyScore"):GetComponent("UILabel").text = "喜/筒总分";
	end

	for i = 0, 3 do
		playerBonusScores[i].gameObject:SetActive(false);
	end

	--如果时4人，那么分A,B组
	if playerSize == 4 then
		playerBonusScores[0].gameObject:SetActive(true);
		playerBonusScores[1].gameObject:SetActive(true);
		playerBonusScores[2].gameObject:SetActive(false);
		playerBonusScores[3].gameObject:SetActive(false);
		playerBonusScores[0]:Find("groupA").gameObject:SetActive(true);
		playerBonusScores[1]:Find("groupB").gameObject:SetActive(true);
		playerBonusScores[0]:Find("name").gameObject:SetActive(false);
		playerBonusScores[1]:Find("name").gameObject:SetActive(false);

		for i = 0, playerSize-1 do
			local initItem = playerBonusScores[i];
			initItem:Find("history"):GetComponent("UILabel").text 		= "0";
			initItem:Find("now"):GetComponent("UILabel").text 			= "0";
			initItem:Find("happyScore"):GetComponent("UILabel").text 	= "0";
		end

	else
		playerBonusScores[0]:Find("groupA").gameObject:SetActive(false);
		playerBonusScores[1]:Find("groupB").gameObject:SetActive(false);
		playerBonusScores[0]:Find("name").gameObject:SetActive(true);
		playerBonusScores[1]:Find("name").gameObject:SetActive(true);
		for i = 0, playerSize-1 do
			local initItem = playerBonusScores[i];
			local player = this.GetPlayerDataBySeat(i);
			initItem:Find("name"):GetComponent("UILabel").text 		= "";
			initItem:Find("history"):GetComponent("UILabel").text 		= "";
			initItem:Find("now"):GetComponent("UILabel").text 			= "";
			initItem:Find("happyScore"):GetComponent("UILabel").text 	= "";
			if player then
				initItem.gameObject:SetActive(true);
				initItem:Find("name"):GetComponent("UILabel").text 		= player.name;
				initItem:Find("history"):GetComponent("UILabel").text 		= "0";
				initItem:Find("now"):GetComponent("UILabel").text 			= "0";
				initItem:Find("happyScore"):GetComponent("UILabel").text 	= "0";
			end
		end
	end
	this.SetBonusLayOut(playerSize);
	scoreView:Find("allScore/playerGrid"):GetComponent("UIGrid"):Reposition();


end

--更新牌桌分数
function this.RefreshDeskScore(data)
	if not data then
		return
	end;
	currentDeskScore:Find("5ScoreNum"):GetComponent("UILabel").text 		= data.deskHud.five/5;
	currentDeskScore:Find("10ScoreNum"):GetComponent("UILabel").text 		= data.deskHud.ten/10;
	currentDeskScore:Find("kScoreNum"):GetComponent("UILabel").text 		= data.deskHud.king/10;
	currentDeskScore:Find("totalScoreNum"):GetComponent("UILabel").text 	= data.deskHud.five + data.deskHud.ten + data.deskHud.king;

end


--更新玩家抓分
function this.RefreshPlayerGrab(data)
	playerScore[this.GetUIIndex(this.GetUIIndexBySeat(data.seat),playerSize)]:GetComponent("UILabel").text = data.grabScore;
end

--初始化牌桌分数
function this.InitDeskScore(roomData)

	if roomData then
		currentDeskScore:Find("5ScoreNum"):GetComponent("UILabel").text 		= roomData.five/5;
		currentDeskScore:Find("10ScoreNum"):GetComponent("UILabel").text 		= roomData.ten/10;
		currentDeskScore:Find("kScoreNum"):GetComponent("UILabel").text 		= roomData.king/10;
		currentDeskScore:Find("totalScoreNum"):GetComponent("UILabel").text 	= roomData.five + roomData.ten + roomData.king;
	else
		currentDeskScore:Find("5ScoreNum"):GetComponent("UILabel").text 		= "0";
		currentDeskScore:Find("10ScoreNum"):GetComponent("UILabel").text 		= "0";
		currentDeskScore:Find("kScoreNum"):GetComponent("UILabel").text 		= "0";
		currentDeskScore:Find("totalScoreNum"):GetComponent("UILabel").text 	= "0";
	end


end




--自动播放
function this.AutoPlay()
	Debugger.Log('replay start', nil);

	if #RoundDetail.records == 0 then
		--print('no records!')
		return
	end
	coroutine.wait(1)

	while gameObject.activeSelf do
		if not isPause then
			local d = RoundDetail.records[playIndex];
			this.OnDoPlayer(d)
			playIndex = playIndex+1
			print("当前进度 ",playIndex,"/",#RoundDetail.records)
			if RoundDetail.roundEnd and RoundDetail.roundEnd~=nil then 
				if playIndex > #RoundDetail.records  then
					if #RoundDetail.roundEnd.players > 0 then
						coroutine.wait(0.5)
						local stageRoomInfo 		= {}
						stageRoomInfo.roomNumber 	= replayData.roomNumber
						local roomData = {}
						roomData.round = replayData.round+1
						roomData.setting = RoundDetail.setting
						stageRoomInfo.roomData 		= roomData
						stageRoomInfo.playerDatas 	= RoundDetail.roundEnd.players
						stageRoomInfo.playerData 	= playerData
						stageRoomInfo.darkCards 	= RoundDetail.roundEnd.darkCards
						stageRoomInfo.isInGame = false
						PanelManager.Instance:ShowWindow('panelStageClear_dtz',stageRoomInfo)
					end
					return
				end
			end
			coroutine.wait(playInterval)
		else
			coroutine.wait(0.5)
		end
	end
end


function this.OnDoPlayer(record)
	if record.operate == 0 then--pass
		this.OnPlayerPass(record);
	elseif record.operate == 1 then--出牌
		this.OnPlayerPlay(record);
	elseif record.operate == 2 then--结算
		this.OnRefreshBonusAndDesk(record);
	end

	if record.operate ~= 2 then
        local index = this.GetUIIndex(this.GetUIIndexBySeat(record.seat),playerSize);
		playerOfflineTime[index].gameObject:SetActive(record.connected == false)
		playerTrusteeship[index].gameObject:SetActive(record.trusteeship == true)
    end
end

function this.RefreshTime(labelTime)
	while true do
		if restTime > 0 then
			labelTime.text = os.date("%M:%S", restTime) --getDaoJiShi(timeChuo)--os.date("%M:%S")
			restTime = restTime - 1
		end
		coroutine.wait(1)
	end
end

function this.OnClickButtonSlow(go)
	AudioManager.Instance:PlayAudio('btn')
	-- if rawSpeed > playInterval then
	-- 	playInterval = rawSpeed
	-- 	FastLabel:GetComponent('UILabel').text = ''
	-- else
	if playInterval + cutTime  <= 2 then
		playInterval = playInterval + cutTime
	end
	--end
	local num = (rawSpeed - playInterval)/cutTime
	if num > 0 then
		FastLabel:GetComponent('UILabel').text = 'x'..num
		SlowLabel:GetComponent('UILabel').text = ''
	elseif num <0 then
		FastLabel:GetComponent('UILabel').text = ''
		SlowLabel:GetComponent('UILabel').text = 'x'..math.abs(num)
	else
		FastLabel:GetComponent('UILabel').text = ''
		SlowLabel:GetComponent('UILabel').text = ''
	end
end

function this.OnClickButtonPause(go)
	AudioManager.Instance:PlayAudio('btn')
	isPause = not isPause
	if isPause then
		ButtonPause:GetComponent('UIButton').normalSprite = 'bofang'
	else
		ButtonPause:GetComponent('UIButton').normalSprite = 'zanting'
	end
end

function this.OnClickButtonFast(go)
	AudioManager.Instance:PlayAudio('btn')
	-- if playInterval > rawSpeed then
	-- 	playInterval = rawSpeed
	-- 	SlowLabel:GetComponent('UILabel').text = ''
	-- else
	if playInterval - cutTime >= 0.5 then
		playInterval = playInterval - cutTime
	end
	--end

	local num = (rawSpeed - playInterval)/cutTime
	if num > 0 then
		FastLabel:GetComponent('UILabel').text = 'x'..num
		SlowLabel:GetComponent('UILabel').text = ''
	elseif num <0 then
		FastLabel:GetComponent('UILabel').text = ''
		SlowLabel:GetComponent('UILabel').text = 'x'..math.abs(num)
	else
		FastLabel:GetComponent('UILabel').text = ''
		SlowLabel:GetComponent('UILabel').text = ''
	end
end

function this.OnClickButtonBack(go)
	AudioManager.Instance:PlayAudio('btn')
	coroutine.stop(conFun)
	coroutine.stop(conTime)

	PanelManager.Instance:ShowWindow(whoShow.name)
	PanelManager.Instance:HideWindow(gameObject.name)
	AudioManager.Instance:PlayMusic('MainBG', true);

end


--点击看牌按钮
function this.OnWatchPlateClick(go)
	--print("OnWatchPlateClick was called");
	--先暂停
    isPause  = false;
	this.OnClickButtonPause(ButtonPause.gameObject);

	--显示牌面窗口
	watchPanel.gameObject:SetActive(true);
	local seat = GetUserData(go).seat;
	this.SetWatchPlatesGrid(this.GetPlayerDataBySeat(seat).cards);

end


--点击空白处关闭看牌
function this.OnWatchMaskClick(go)
	--print("OnWatchMaskClick was called");
	--先播放
	this.OnClickButtonPause(ButtonPause.gameObject);
	--关闭牌面显示窗口
	watchPanel.gameObject:SetActive(false);
end


--设置查看的牌面
function this.SetWatchPlatesGrid(cards)
	--local card={trueValues={cards[i]},type={GetPlateType(cards[i])},value=GetPlateNum(cards[i])+2}
	--this.setPai(item,card,1)
	if not cards then
		return ;
	end



	for i = 0, watchGrid.childCount-1 do
		watchGrid:GetChild(i).gameObject:SetActive(false);
	end

	table.sort(cards,tableSortDesc);

	local processedCards = this.ProcessCard(cards);
	local args = {};
	args.needCombination =  false;
	args.cardCount = roomData.setting.cardCount;
	args.isWithPlate = roomData.setting.san;
	processedCards = dtz_Logic.InitDB(processedCards,args);
	local depth = baseInCardDepth;
	for i = 1, #cards do

		local cardItemObj = nil;
		if i <= watchGrid.childCount then
			cardItemObj = watchGrid:GetChild(i-1).gameObject;
		else
			cardItemObj = NGUITools.AddChild(watchGrid.gameObject,watchPlatePrefab.gameObject);
		end

		--设置牌面深度，

		this.setCardDepth(cardItemObj,depth);
		this.setPai(cardItemObj,processedCards[i]);
		this.SetWatchGridType(cardItemObj);
		cardItemObj:SetActive(true);
		depth = depth + 5;
	end

	----标记地炸，筒子和喜牌，用颜色标记
	this.MarkSpecialByColor(watchGrid);

	watchGrid:GetComponent("UIGrid"):Reposition();

end

--设置剩余牌
function this.SetCardCounts(cardLength,seat)
	print("SetCardCounts---------------------->");
	if seat ~= mySeat then
		local index = this.GetUIIndex(this.GetUIIndexBySeat(seat),playerSize);
		playerRestCards[index]:Find("num"):GetComponent("UILabel").text = cardLength;
		playerRestCards[index].gameObject:SetActive(cardLength > 0);
		local sex = this.GetPlayerDataBySeat(seat).sex;
		print("cardLength-------------------->"..cardLength..",seat:"..seat);
		if cardLength == 1 or cardLength == 2 then
			print("SetWarnnig was called,cardLength"..cardLength.."seat:"..seat);
			local soundName = cardLength == 1 and string.format("dtzbaodan_%d",sex) or string.format("dtzbaoshuang_%d",sex);
			print("soundName:"..soundName);
			StartCoroutine(function ()
				WaitForSeconds(0.6);
				AudioManager.Instance:PlayAudio(soundName);
			end);
			this.SetWarnnig(true,index);
		else
			this.SetWarnnig(false,index);
		end
	end
end

--设置警报
function this.SetWarnnig(show,index)
	print("SetWarnnig------------>show:"..tostring(show));
	playerWarnning[index].gameObject:SetActive(show);
end

function this.HideAllWarnning()
	for i = 1, 3 do
		playerWarnning[i].gameObject:SetActive(false);
	end
end


function this.InitCardCounts()

	for i = 1, 3 do
		playerRestCards[i].gameObject:SetActive(false);
	end
	for i = 1, #playerData do
		if playerData[i].seat ~= mySeat then
			local index = this.GetUIIndex(this.GetUIIndexBySeat(playerData[i].seat),playerSize);
			this.SetCardCounts(#playerData[i].cards,playerData[i].seat);
			playerRestCards[index].gameObject:SetActive(roomData.setting.show);
		end
	end
end


function this.HideAllVFX()
	for i = 0, 3 do
		playerzi[i].gameObject:SetActive(false);
		playerwenzi[i].gameObject:SetActive(false);
	end
end

function this.ShowVFX(index,show)
	playerzi[index].gameObject:GetComponent('UISprite').spriteName = 'pass_1';
	playerzi[index].gameObject:GetComponent('UISprite'):MakePixelPerfect();
	playerzi[index].gameObject:SetActive(show);
	--playerwenzi[index].gameObject:SetActive(show);
end


function this.SetMyGridInType(item)
	local t 		= item.transform:Find('type');
	local num 		= item.transform:Find('num');

	if dtzPlateType == 0 then
		num:GetComponent("UISprite").width = 41;
		num:GetComponent("UISprite").height = 49;
		t.localPosition = Vector3.New(-32.8,9.2,0);
		num.localPosition = Vector3.New(-31,51.4,0);

	elseif dtzPlateType == 1 then
		num:GetComponent("UISprite").width = 44;
		num:GetComponent("UISprite").height = 53;
		num.localPosition = Vector3.New(-33.2,47.1,0);
		t.localPosition = Vector3(-33.8,8.6,0);
	elseif dtzPlateType == 2 then
		num:GetComponent("UISprite").width = 40;
		num:GetComponent("UISprite").height = 48;
		num.localPosition = Vector3.New(-33,51.4,0);
		t.localPosition = Vector3.New(-33.8,16.5,0);
	end
end

function this.SetOutGridType(item)
	local t 		= item.transform:Find('type');
	local num 		= item.transform:Find('num');
	local bg 		= item.transform:Find('bg');

	if dtzPlateType == 0 then
		num:GetComponent("UISprite").width = 55;
		num:GetComponent("UISprite").height = 66;
		num.localPosition = Vector3.New(-44,75.3,0);
		t.localPosition = Vector3.New(-44.6,20.3,0);
	elseif dtzPlateType == 2 then
		num:GetComponent("UISprite").width = 58;
		num:GetComponent("UISprite").height = 70;
		num.localPosition = Vector3.New(-42.3,76.6,0);
		t.localPosition = Vector3.New(-44.2,29.2,0);
	elseif dtzPlateType == 1 then
		num:GetComponent("UISprite").width = 64;
		num:GetComponent("UISprite").height = 77;
		num.localPosition = Vector3.New(-43.5,71.9,0);
		t.localPosition = Vector3.New(-44.5,19.3,0);
	end
	bg:GetComponent("UISprite").width = 182;
end
function this.SetWatchGridType(item)
	local t 		= item.transform:Find('type');
	local num 		= item.transform:Find('num');

	if dtzPlateType == 0 then
		num:GetComponent("UISprite").width = 41;
		num:GetComponent("UISprite").height = 49;
		t.localPosition = Vector3.New(-32.8,4.8,0);
		num.localPosition = Vector3.New(-31.9,48,0);
	elseif dtzPlateType == 2 then
		num:GetComponent("UISprite").width = 44;
		num:GetComponent("UISprite").height = 53;
		num.localPosition = Vector3.New(-34.3,48,0);
		t.localPosition = Vector3.New(-34.8,11.5,0);
	elseif dtzPlateType == 1 then
		num:GetComponent("UISprite").width = 40;
		num:GetComponent("UISprite").height = 48;
		num.localPosition = Vector3.New(-27.4,48,0);
		t.localPosition = Vector3.New(-28,6,0);

	end
end


--手牌是否需要居中
function this.IsGridInNeedCenter()
	return #(this.GetPlayerDataBySeat(mySeat).cards) <= overCenterCardCount;
end


--用颜色标记地炸，筒子和喜
function this.MarkSpecialByColor(grid)
	local allTongzi 	= {};
	local allDiBombs 	= {};
	local allXi 		= {};
	if roomData.setting.cardCount == 3 then
		allDiBombs 	= dtz_Logic.GetAllDiBombs();
	else
		allXi 			= dtz_Logic.GetAllXi();
	end
	allTongzi 			= dtz_Logic.GetAllTongzi();
	--先把所有牌变成普通牌
	for i = 1, grid.childCount do
		local cardItem = grid:GetChild(i-1);
		if cardItem.gameObject.activeSelf then
			cardItem:Find("xiordiZha").gameObject:SetActive(false);
			cardItem:Find("tongzi").gameObject:SetActive(false);
		end
	end
	for i = 1, grid.childCount do
		local cardItem = grid:GetChild(i-1);
		if cardItem.gameObject.activeSelf then
			local card = GetUserData(cardItem.gameObject);
			--设置筒子牌的颜色
			for j = 1, #allTongzi do
				local canSet = true;
				--不能存在于喜中
				for k = 1, #allXi do
					if dtz_Logic.IsFindInTable(allXi[k],card,"db_id") then
						canSet = false;
						--print("allXi,can't set....db_id:"..card.db_id.."|value:"..card.value);
						break;
					end
				end
				--不能存在于地炸中
				for k = 1, #allDiBombs do
					if dtz_Logic.IsFindInTable(allDiBombs[k],card,"db_id") then
						canSet = false;
						--print("allDiBombs,can't set....db_id:"..card.db_id.."|value:"..card.value);

						break;
					end
				end
				if canSet and dtz_Logic.IsFindInTable(allTongzi[j],card,"db_id") then
					cardItem:Find("tongzi").gameObject:SetActive(true);
				end
			end
			--设置喜牌颜色
			for j = 1, #allXi do
				if dtz_Logic.IsFindInTable(allXi[j],card,"db_id") then
					cardItem:Find("xiordiZha").gameObject:SetActive(true);
				end
			end
			--设置所有地炸颜色
			for j = 1, #allDiBombs do
				if dtz_Logic.IsFindInTable(allDiBombs[j],card,"db_id") then
					cardItem:Find("xiordiZha").gameObject:SetActive(true);
				end
			end

		end
	end

end
function this.OnClickPlayerIcon(go)
	print(' RoundDetail.openUserCard : '..tostring(RoundDetail.openUserCard)..' RoundDetail.isLord : '..tostring(RoundDetail.isLord))
	if RoundDetail.openUserCard then
		local pData = GetUserData(go)
		if not pData then
			return
		end
		local userData = {}
		userData.rseat 		= pData.seat
		userData.mySeat		= mySeat
		userData.nickname   = pData.name
		userData.icon       = pData.icon
		userData.sex        = pData.sex
		userData.ip         = pData.ip
		userData.userId     = pData.id
		userData.gameType	= proxy_pb.PHZ
		userData.signature  = ''
		userData.imgUrl  = ''
		userData.sendMsgAllowed = roomData.setting.sendMsgAllowed
		userData.isRePlay = true
		if roomData.clubId ~= '0' then
			userData.gameMode = roomData.setting.gameMode
		end
		userData.isShowSomeID = not RoundDetail.isLord
		userData.fee = pData.fee
		PanelManager.Instance:ShowWindow('panelPlayerInfo', userData)
	end
end