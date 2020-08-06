local proxy_pb = require 'proxy_pb'
local csm_pb = require 'csm_pb'
require 'const'

panelReplay_mj = {}
local this = panelReplay_mj

local message
local gameObject

local roomRound
local roomID
local waitRoomID --等待时房间号
local roomTime
local batteryLevel
local network
local pingLabel
local roomSetting
local line
local operation_send
local dipai
local curOperatPlateEffect
local kaiBao
local playerBrid
local cardText;
local gameTypeObj;

local playerName={}
local playerIcon={}
local playerScore={}
local playerMaster={}
local playerSound={}
local playerOffline={}
local playerGridXi={}
local playerThrow={}
local playerReady={}
local playerOperationEffectPos={}
local playerMoPaiPos={}
local playerCurMoPi={}
local playerGridHand={}
local curActivePlayerIcon={}
local playerHandGridPos ={};--每个玩家手牌grid的原始位置信息
local playerTableThrowGridPos = {};--牌桌上的牌的grid的初始位置
local playerHupaiPos = {};
local playerTrusteeship={}
local playerOfflineTime={}
local effectGangPos = {};

local moHandDefPos = {};

local playerPiaoFen={}
local playerChuPaiShows = {}--出牌时展示动画

local effectGang;--杠牌特效
local effectCategories = {};--特效位置

local playerDi
local roomSetting
local curOperatPlateEffect

local ButtonSlow
local ButtonPause
local ButtonFast
local FastLabel
local ButtonBack
local SlowLabel

local ButtonHu
local ButtonGang
local ButtonPeng
local ButtonChi
local ButtonGuo
local ButtonBu

local RoundDetail
local playerData={}
local roomData={}
local dissolution={}
local mySeat
local needChuPai = false
local dargObj = nil
local paiAnimations={}
local needChuPaiBefroeHu = false
local rollResult

local isPause = false
local playInterval = 1.5
local playIndex = 1
local rawSpeed
local lastOperat={}
local dipaiNum = 19
local cutTime = 0.25
local curniaoIndex = 0;

local playerSize = 4
local bankerSeat
local birdsSeat
local curmahjongCount = 0;

local cardColorNum = 2;--牌色的数量
local BgColorNum = 3;--背景颜色的数量

local bgColor;--牌色的索引
local cardColor;--背景的颜色索引

local conFun
local conTime
local operation_mask;--操作屏蔽按钮

local bg
local dismissTypeTip
local optionCoroutine = nil;

--启动事件--
function this.Awake(obj)
	gameObject 				= obj;
	message 				= gameObject:GetComponent('LuaBehaviour');

    bg 						= gameObject.transform:Find('Bg');
    ButtonSlow 				= gameObject.transform:Find('control/ButtonSlow')
	SlowLabel 				= gameObject.transform:Find('control/ButtonSlow/Label')
    ButtonPause 			= gameObject.transform:Find('control/ButtonPause');
    ButtonFast 				= gameObject.transform:Find('control/ButtonFast');
	FastLabel 				= gameObject.transform:Find('control/ButtonFast/Label')
	ButtonBack 				= gameObject.transform:Find('control/ButtonBack')
	gameTypeObj				= gameObject.transform:Find("type");
	roomID 					= gameObject.transform:Find('stateBar/room/ID');
	waitRoomID 				= gameObject.transform:Find('setting/roominfo/waitRoomID');
	roomTime 				= gameObject.transform:Find('stateBar/time');
	roomRound 				= gameObject.transform:Find('DiPai/frame/round');
	roomSetting 			= gameObject.transform:Find('setting')
	line 					= gameObject.transform:Find('line')
	operation_send 			= gameObject.transform:Find('Operation/operation_send')
	ButtonHu 				= operation_send:Find('Button2Hu')
	ButtonGang 				= operation_send:Find('Button3Gang')
	ButtonPeng 				= operation_send:Find('Button5Peng')
	ButtonChi 				= operation_send:Find('Button6Chi')
	ButtonGuo 				= operation_send:Find('Button1Guo')
	ButtonBu 				= operation_send:Find('Button4Bu')
	dipai 					= gameObject.transform:Find('DiPai')
	kaiBao 					= gameObject.transform:Find('KaiBao')
	curOperatPlateEffect 	= gameObject.transform:Find('curOperatPlateEffect')
	playerBrid 				= gameObject.transform:Find('Birds')
	operation_mask			= gameObject.transform:Find("operationMask");
	curOperatPlateEffect 	= gameObject.transform:Find('curOperatPlateEffect')
	effectGang				= gameObject.transform:Find("effectGang");

	for i=1,4 do
		if effectGangPos[i] == nil then 
			effectGangPos[i] = effectGang:GetChild(i-1).position;
		end
	end

    message:AddClick(ButtonSlow.gameObject, this.OnClickButtonSlow);
    message:AddClick(ButtonPause.gameObject, this.OnClickButtonPause);
    message:AddClick(ButtonFast.gameObject, this.OnClickButtonFast);
    message:AddClick(ButtonBack.gameObject, this.OnClickButtonBack);
	for i = 0, 3 do
        message:AddClick(gameObject.transform:Find('player'..i..'/Texture').gameObject, this.OnClickPlayerIcon)
    end
	dipai = gameObject.transform:Find('DiPai')
	
	playerDi = gameObject.transform:Find('player0/TableDi')
	
	batteryLevel = gameObject.transform:Find('stateBar/battery/level'):GetComponent('UISprite')
	network = gameObject.transform:Find('stateBar/network'):GetComponent('UISprite')
	pingLabel = gameObject.transform:Find('stateBar/ping'):GetComponent('UILabel')
	
	dismissTypeTip = gameObject.transform:Find('dismissTypeTip/Tip/text')
	message:AddClick(gameObject.transform:Find('dismissTypeTip/Tip/dismissTypeTipBtn').gameObject, function (go)
		gameObject.transform:Find('dismissTypeTip/Tip').gameObject:SetActive(false)
		gameObject.transform:Find('dismissTypeTip/dismissTypeTipBtn').gameObject:SetActive(true)
	end)
	message:AddClick(gameObject.transform:Find('dismissTypeTip/dismissTypeTipBtn').gameObject, function (go)
		gameObject.transform:Find('dismissTypeTip/Tip').gameObject:SetActive(true)
		gameObject.transform:Find('dismissTypeTip/dismissTypeTipBtn').gameObject:SetActive(false)
	end)
	
	this.GetPlayerUI()
	rawSpeed = playInterval
end

function this.Start()

end
function this.Update()
   
end

function this.GetPlayerUI()
	for i=0,3 do
		playerName[i] = gameObject.transform:Find('player'..i..'/name')
		playerIcon[i] = gameObject.transform:Find('player'..i..'/Texture')
		playerScore[i] = gameObject.transform:Find('player'..i..'/score')
		playerMaster[i] = gameObject.transform:Find('player'..i..'/master')
		playerSound[i] = gameObject.transform:Find('player'..i..'/sound')
		playerOffline[i] = gameObject.transform:Find('player'..i..'/offline')
		playerReady[i] = gameObject.transform:Find('player'..i..'/ready')
		playerSound[i] = gameObject.transform:Find('player'..i..'/sound')
		playerOperationEffectPos[i] = gameObject.transform:Find('player'..i..'/operation_pos')
		playerMoPaiPos[i] = gameObject.transform:Find('player'..i..'/mopai_pos')
		playerPiaoFen[i] = gameObject.transform:Find("player"..i.."/piaofen");

		effectCategories[i] = gameObject.transform:Find('effectCategories/cate'..i);

		playerThrow[i] = gameObject.transform:Find('player'..i..'_mj/TabelThrow')
		if playerHupaiPos[i] == nil then
			playerHupaiPos[i] = playerOperationEffectPos[i].position;
		end
		if playerTableThrowGridPos[i] == nil then
			playerTableThrowGridPos[i] = playerThrow[i].localPosition;
		end
		playerGridXi[i] = gameObject.transform:Find('player'..i..'_mj/GridXi')
		playerGridHand[i] = gameObject.transform:Find('player'..i..'_mj/GridHand')
		playerChuPaiShows[i] = gameObject.transform:Find('player'..i..'_mj/chuPaiShow')
		--如果以获取初始位置就不用再获取了
		-- --print("#playerHandGridPos.."..(#playerHandGridPos));
		if playerHandGridPos[i] == nil then
			playerHandGridPos[i] = playerGridHand[i].localPosition;
		end
		playerCurMoPi[i] = gameObject.transform:Find('player'..i..'_mj/MoPaiGrid')
		curActivePlayerIcon[i] = gameObject.transform:Find('DiPai/DeskTimerIndex'..i)

		playerTrusteeship[i] = gameObject.transform:Find('player'..i..'/trusteeship')
		playerOfflineTime[i] = gameObject.transform:Find('player'..i..'/offlineTime')
	end
end

function this.Reset()
    playInterval 	= 1.5
    isPause 		= false
    playIndex 		= 1
	mySeat 			= 0
	curniaoIndex 	= 0
	birdsSeat 		= {}
	ButtonPause:GetComponent('UIButton').normalSprite = 'zanting'
	FastLabel:GetComponent('UILabel').text = ''
	SlowLabel:GetComponent('UILabel').text = ''
	
	for i=0,3 do
		playerGridHand[i].gameObject:SetActive(false)
		playerGridXi[i].gameObject:SetActive(false)
		playerThrow[i].gameObject:SetActive(false)
		playerTrusteeship[i].gameObject:SetActive(false)
		playerOfflineTime[i].gameObject:SetActive(false)
	end
	curOperatPlateEffect.gameObject:SetActive(false)
	this.HideAllBirds()
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
    local msg = Message.New()
	local b = proxy_pb.PRoundRecords()
	b.roomId = replayData.roomId
	b.round = replayData.round
	b.gameType = proxy_pb.MJ
    msg.type = proxy_pb.ROUND_RECORDS
    msg.body = b:SerializeToString()
    SendProxyMessage(msg, this.OnGetRoundDetail);
	gameObject.transform:Find('Mask').gameObject:SetActive(false)
	operation_send.gameObject:SetActive(false);
	PanelManager.Instance:HideWindow('panelRecordDetail')
	LuaManager.Instance:DoFile('effManger.lua')
end

function this.OnEnable()
	panelInGame = panelReplay_mj;
	AudioManager.Instance:PlayMusic('GameBG', true);
	cardText 	= UnityEngine.PlayerPrefs.GetInt('cardText_mj', 1);
	--获取主题颜色
	bgColor 	= UnityEngine.PlayerPrefs.GetInt('bgColor_mj', 1);
	cardColor 	= UnityEngine.PlayerPrefs.GetInt('cardColor_mj', 1);
	this.ChooseBG(bgColor);
	gameObject.transform:Find('dismissTypeTip/Tip').gameObject:SetActive(false)
	gameObject.transform:Find('dismissTypeTip/dismissTypeTipBtn').gameObject:SetActive(true)
end

function this.HideAllBirds()
	for i=0,playerBrid.childCount-1 do
		playerBrid:GetChild(i).gameObject:SetActive(false)
	end
end

function this.SettingText()

	print("SettingText was called");

	roomSetting:Find('Label'):GetComponent('UILabel').text = GetMJRuleText(roomData.setting,false);
	if roomData.setting.roomTypeValue == proxy_pb.CSM then
		gameTypeObj:Find("playName"):GetComponent("UILabel").text = "长沙麻将";
	elseif roomData.setting.roomTypeValue == proxy_pb.ZZM then
		gameTypeObj:Find("playName"):GetComponent("UILabel").text = "转转麻将";
	elseif roomData.setting.roomTypeValue == proxy_pb.HZM then
		gameTypeObj:Find("playName"):GetComponent("UILabel").text = "红中麻将";
	end
end

function this.OnGetRoundDetail(msg)
    print('OnGetRoundDetail')
    local b = csm_pb.RRoundRecords()
	b:ParseFromString(msg.body)
    RoundDetail = b
	bankerSeat = RoundDetail.bankerSeat --#RoundDetail.records > 0 and RoundDetail.records[1].seat or 0
	roomData={}
	roomData.setting = RoundDetail.setting
	roomData.round = replayData.round
	roomData.bankerSeat = RoundDetail.bankerSeat
	curmahjongCount = RoundDetail.mahjongCount
	--print("__mahjongCount__  ",RoundDetail.mahjongCount)
	dismissTypeTip:GetComponent("UILabel").text = b.diss
	playerSize 	= roomData.setting.size;

	print("服务器发的当局详情：")

	dipaiNum = 108
	playerData={}
	for i=1, #RoundDetail.players do
		local player = {}
        local p = RoundDetail.players[i]
		p.sex = p.sex == 0 and 1 or p.sex
		if p.id == info_login.id then
			mySeat = p.seat
		end
		table.insert(playerData,this.GetAinitPlayer(p))
	end
	if whoShow.isSelectSeat then
		mySeat = whoShow.mySeat
	end
	this.GetPlayerUI(roomData.setting.size)
	this.SettingText()
	
	print('playerData num:'..#playerData..' mySeat:'..mySeat)
    this.RefreshRoom()
    conFun = coroutine.start(this.AutoPlay)
end

function this.GetAinitPlayer(p)
	local player ={}
	player.seat = p.seat
	player.name = p.name
	player.icon = p.icon
	player.sex = p.sex
	player.id = p.id
	player.mahjongs = {}
	player.ip = p.ip
	player.fee = p.fee
	player.chi = {}
	player.peng = {}
	player.mingGang = {}
	player.dianGang = {}
	player.anGang = {}
	player.mahjongCount = -1
	player.floatScore = -1
	player.paiHe = {}
	return player
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

--通过playerSize 将UI上的index转换成特殊的UI上的index
function this.GetUIIndex(index,playerSize)
	if playerSize == 2 then
		if index ==1 then
			return 2;
		else
			return index;
		end
	elseif playerSize == 3 then
		if index == 2 then
			return 3;
		else
			return index;
		end
	else
		return index;
	end

end

function this.GetPlayerDataBySeat(seat)
	for i=1,#playerData do
		if playerData[i].seat == seat then
			return playerData[i]
		end
	end
	return nil
end

function this.RefreshRoom()
	print("RefreshRoom was called");
	--print(replayData.roomNumber)
    gameObject.transform:Find('stateBar/room/ID'):GetComponent("UILabel").text = replayData.roomNumber;
    gameObject.transform:Find('stateBar/round/num'):GetComponent("UILabel").text = replayData.round..'/'..RoundDetail.setting.rounds;
    gameObject.transform:Find('DiPai/frame/round'):GetComponent("UILabel").text = replayData.round..'/'..RoundDetail.setting.rounds;
	waitRoomID:GetComponent('UILabel').text = roomInfo.roomNumber;
	conTime = coroutine.start(RefreshTime, gameObject.transform:Find('stateBar/time'):GetComponent("UILabel"), 1)
	--roomSetting:Find('type'):GetComponent('UISprite').spriteName = RoundDetail.setting.roomType == proxy_pb.SYZP and 'word_syzp' or 'word_sybp'
	--dipai:Find('Label'):GetComponent('UILabel').text = string.format('剩%d张', dipaiNum)
	if(curmahjongCount)then 
		this.SetDipaiNum(curmahjongCount)
	end
	for i = 0, 3 do
		playerGridHand[i].gameObject:SetActive(false)
		playerGridXi[i].gameObject:SetActive(false)
		playerThrow[i].gameObject:SetActive(false);
		playerCurMoPi[i].gameObject:SetActive(false);

		if not moHandDefPos[i] then 
			moHandDefPos[i]= playerGridHand[i].localPosition
		else 
			playerGridHand[i].localPosition = moHandDefPos[i]
		end
		--moPaiDefPos

		-- if playerGridHand[i].childCount >0 then
		-- 	for j = playerGridHand[i].childCount-1,0,-1 do
		-- 		UnityEngine.Object.Destroy(playerGridHand[i]:GetChild(j).gameObject)
		-- 	end
		-- end
	end
	this.RefreshAllGridHand()
	this.RefreshAllGridXi()
	this.RefreshAllTabelThrow()
	this.RefreshAllCurMoPai()
	this.RefreshPlayer()
	this.SetPlayerPos(csm_pb.GAMING)
end

function this.SetRoundNum(num)
	roomRound:GetComponent('UILabel').text = num..'/'..roomData.setting.rounds;
end

function this.SetDipaiNum(num)
	dipai:Find('frame/leftCard'):GetComponent('UILabel').text = string.format('%d', num);
end


function this.RefreshGridHandByIndex(index, uiIndex, plates, mahjongCount, isReplay, moMahjong, DownCards)
	this.RefreshGridHand(playerGridHand[this.GetUIIndex(index,playerSize)], this.GetUIIndex(index,playerSize), plates, mahjongCount, isReplay, moMahjong, DownCards);

end


function this.GetCardColor()
	return cardColor;
end

--刷新手中的牌
function this.RefreshGridHand(GridHand, uiIndex, plates, mahjongCount, isReplay, moMahjong, DownCards)
	if uiIndex == 0 then
		table.sort(plates, tableSortDesc);
	else
		table.sort(plates, tableSortAsc);
	end

	local down = true--#DownCards > 0
	
	if moMahjong ~= -1 then
		if uiIndex == 0 then
			for i=1,#plates do
				if moMahjong == plates[i] then
					plates:remove(i)
					break
				end
			end
		else
			mahjongCount = mahjongCount-1
		end
	end
	--if uiIndex == 0 or isReplay then
		mahjongCount = #plates
	--end

	local prefabName = CONST.cardPrefabHand_Replay[uiIndex+1]

	-- --print('hand plates num:'..#plates..' mahjongCount:'..mahjongCount..' prefabName:'..prefabName..' DownCards:'..#DownCards)
	for j=GridHand.childCount,mahjongCount-1 do
		local cardGroupHand = ResourceManager.Instance:LoadAssetSync(prefabName)
		local obj = NGUITools.AddChild(GridHand.gameObject, cardGroupHand)
		obj.name = prefabName
		if uiIndex == 1 then
			obj:GetComponent('UISprite').depth = 20-j
			obj.transform:Find('card'):GetComponent('UISprite').depth = 20-j+1
		end
	end
	
	local itemSp,itemChilSp
	for i=0,GridHand.childCount-1 do
		if i < mahjongCount then
			local item = GridHand:GetChild(i)
			item.name = prefabName..i
			item.gameObject:SetActive(true);
			itemSp = item:GetComponent('UISprite');
			itemChilSp = item:Find('card'):GetComponent('UISprite');
			itemSp.spriteName = this.getColorCardName(CONST.cardPrefabHandDownBg[uiIndex+1],cardColor);
			itemChilSp.gameObject:SetActive(true)
			
			itemChilSp.gameObject:SetActive(true)
			itemChilSp.spriteName = this.GetCardTextName(plates[i+1],cardText);
			SetUserData(item.gameObject, plates[i+1])
			itemChilSp.transform.localPosition = CONST.cardPrefabHandDownOffset[uiIndex+1]
			itemSp.width = CONST.cardDownSize[uiIndex+1].x;
			itemSp.height = CONST.cardDownSize[uiIndex+1].y;

			if GridHand == playerGridHand[0] then 
				--设置牌面值
				itemChilSp.transform:GetComponent("UISprite").width = this.GetCardPlateSize(plates[i+1],cardText).x;
				itemChilSp.transform:GetComponent("UISprite").height = this.GetCardPlateSize(plates[i+1],cardText).y;
			end

		else
			GridHand:GetChild(i).gameObject:SetActive(false)
		end
	end
	if isReplay then 
		GridHand:GetComponent('UIGrid').cellWidth = CONST.cardPrefabHandDownGridCell_Replay[uiIndex+1].x
		GridHand:GetComponent('UIGrid').cellHeight = CONST.cardPrefabHandDownGridCell_Replay[uiIndex+1].y
	elseif not down then 
		GridHand:GetComponent('UIGrid').cellWidth = CONST.cardPrefabHandStandGridCell[uiIndex+1].x
		GridHand:GetComponent('UIGrid').cellHeight = CONST.cardPrefabHandStandGridCell[uiIndex+1].y
	else 	
		GridHand:GetComponent('UIGrid').cellWidth = CONST.cardPrefabHandDownGridCell[uiIndex+1].x
		GridHand:GetComponent('UIGrid').cellHeight = CONST.cardPrefabHandDownGridCell[uiIndex+1].y
	end

	StartCoroutine(function()
		WaitForSeconds(0.02);
		--WaitForEndOfFrame();
		--GridHand:GetComponent('UIGrid'):Reposition();
		GridHand:GetComponent('UIGrid').repositionNow = true;
	end);
	--GridHand:GetComponent('UIGrid').repositionNow = true
	
	local pos = GridHand.localPosition;
	local gridcellWidth = GridHand:GetComponent('UIGrid').cellWidth
	local gridcellHeight = GridHand:GetComponent('UIGrid').cellHeight
	--print('gridcellWidth:'..gridcellWidth..' gridcellHeight:'..gridcellHeight,mahjongCount)
	if uiIndex == 0 then
		--pos.x = GridHand.localPosition.x + (gridcellWidth * mahjongCount) - gridcellWidth*0.5 +75;
		pos.y = GridHand.localPosition.y;
		pos.x = playerCurMoPi[uiIndex].localPosition.x;
	elseif uiIndex == 1 then
		pos.y = GridHand.localPosition.y - (gridcellHeight * mahjongCount) + gridcellHeight*0.5  + 50
	elseif uiIndex == 2 then
		pos.x = GridHand.localPosition.x - (gridcellWidth * mahjongCount) + gridcellWidth*0.5 - 20
	else
		pos.y = GridHand.localPosition.y - (gridcellHeight * mahjongCount) + gridcellHeight*0.5 - 50
	end
	playerCurMoPi[uiIndex].localPosition = pos;
	
	if moMahjong ~= -1 then
		if uiIndex == 0 then
			table.insert(plates, moMahjong)
		else
			mahjongCount = mahjongCount+1
		end
	end
end

--填充座位上的玩家数据
function this.RefreshPlayer()

	function SetPlayerState(index,p)
		playerName[index].gameObject:SetActive(true)
		playerName[index]:GetComponent('UILabel').text = p.name;
        coroutine.start(LoadPlayerIcon, playerIcon[index]:GetComponent('UITexture'), p.icon);
		SetUserData(playerIcon[index].gameObject, p);
		playerScore[index].gameObject:SetActive(true);
		--playerScore[index]:GetComponent('UILabel').text = p.score;
		playerMaster[index].gameObject:SetActive(roomData.bankerSeat == p.seat);

		--设置飘分
		playerPiaoFen[index].gameObject:SetActive(true);

		if roomData.setting.floatScore then
			print("player["..index.."] playerScore:"..p.floatScore);

			if p.floatScore == -1 then
				playerPiaoFen[index]:GetComponent('UILabel').text = "";
			elseif p.floatScore == 0 then
				playerPiaoFen[index]:GetComponent('UILabel').text = "不飘分";
			else
				playerPiaoFen[index]:GetComponent('UILabel').text = "飘"..p.floatScore.."分"
			end

		else
			playerPiaoFen[index]:GetComponent('UILabel').text = ""
		end


	end

	function hidePlayerState(index,p)
		print("hidePlayerState was called: index:"..index);
		playerName[index].gameObject:SetActive(false)
		playerIcon[index]:GetComponent('UITexture').mainTexture = nil
		playerScore[index].gameObject:SetActive(false)
		playerMaster[index].gameObject:SetActive(false)
		playerPiaoFen[index].gameObject:SetActive(false);
		playerPiaoFen[index]:GetComponent('UILabel').text = "";
		playerOffline[index].gameObject:SetActive(false)
		SetUserData(playerIcon[index].gameObject, nil)
	end

	function hideSoundState(index)
		playerSound[index].gameObject:SetActive(false)
		playerMoPaiPos[index].gameObject:SetActive(false)
	end

	for i = 0, 3 do
		playerName[i].parent.gameObject:SetActive(false)
	end

	for i=0,playerSize-1 do
		local p = this.GetPlayerDataByUIIndex(i)
		--print(p,"_______________________________")
		if p then
			playerName[this.GetUIIndex(i,playerSize)].parent.gameObject:SetActive(true)
			SetPlayerState(this.GetUIIndex(i,playerSize),p);

		else
			--print("此人不在线  ~~");
			--playerName[i].parent.gameObject:SetActive(false)
			hidePlayerState(this.GetUIIndex(i,playerSize),p);
		end
		hideSoundState(this.GetUIIndex(i,playerSize));
	end
end


function this.RefreshAllGridHand()
	--print("RefreshAllGridHand was called")
	for i=0,playerSize -1 do
		--把手牌的grid位置还原
		-- playerGridHand[i].localPosition = playerHandGridPos[i];
		local pData = this.GetPlayerDataByUIIndex(i)
		if pData and i < playerSize then
			
			local cards = {}
			-- for i = 1, #pData.categories do
			-- 	----print('aaaaa:'..table.concat(pData.categories[i].mahjongs, ','))
			-- 	if pData.categories[i].category == 3 or pData.categories[i].category == 4 then
			-- 		cards = tableClone(pData.categories[i].mahjongs)
			-- 	elseif #cards < 14 then
			-- 		tableMerge(cards, pData.categories[i].mahjongs)
			-- 	end
			-- end
			this.RefreshGridHand(playerGridHand[this.GetUIIndex(i,playerSize)], this.GetUIIndex(i,playerSize), pData.mahjongs, #pData.mahjongs, true, -1, {});
			playerGridHand[this.GetUIIndex(i,playerSize)].gameObject:SetActive(true);

		else
			playerGridHand[this.GetUIIndex(i,playerSize)].gameObject:SetActive(false);

		end
	end
end

--刷新玩家手上的摸牌
function this.RefreshAllCurMoPai()
	--print("RefreshAllCurMoPai was called!");
	local index = -1
	local mahjong = -1
	-- for i=0,playerSize-1 do
	-- 	local pData = this.GetPlayerDataByUIIndex(i)
	-- 	if pData and i < playerSize-1 and pData.moMahjong ~= -1 then
	-- 		--print('RefreshAllCurMoPai player:'..pData.name..' mopai:'..pData.moMahjong)
	-- 		index = i
	-- 		mahjong = pData.moMahjong
	-- 		if pData.seat ~= mySeat then
	-- 			table.insert(pData.mahjongs, pData.moMahjong)
	-- 		end
	-- 		break
	-- 	end
	-- end
	--print("RefreshCurMoPai before,index:"..index.." playerSize:"..playerSize);
	this.RefreshCurMoPai(index, mahjong,true);
end

function this.RefreshCurMoPai(index, plate, down)
	--print("RefreshCurMoPai was called index:"..index.." plate:"..plate.." down:"..tostring(down).." playerSize:"..playerSize);
	--print("findbefore--->GetUIIndex:"..this.GetUIIndex(index,playerSize));
	local itemSp 
	local itemChilSp
	for i=0,playerSize-1 do
		if i == index then
			--print("find--->GetUIIndex:"..this.GetUIIndex(index,playerSize));
			this.SetCurMoPai(this.GetUIIndex(index,playerSize),this.GetUIIndex(index,playerSize),plate,down);

		else
			playerCurMoPi[this.GetUIIndex(i,playerSize)].gameObject:SetActive(false);
		end
	end
end

--设置当前的摸牌
--down表示是否是展示：比如胡牌的时候，down=true
function this.SetCurMoPai(i,index,plate,down)
	playerCurMoPi[i].gameObject:SetActive(true);
	local itemSp = playerCurMoPi[i]:GetChild(0):GetComponent('UISprite');
	local itemChilSp = playerCurMoPi[i]:GetChild(0):Find('card'):GetComponent('UISprite');
	itemChilSp.gameObject:SetActive(true);--摸牌只能自己看到 down or i == 0
	if not down then
		itemSp.spriteName = this.getColorCardName(CONST.cardPrefabHandStandBg_Replay[i+1],cardColor);
		if i == 0 then
			itemChilSp.spriteName = this.GetCardTextName(plate,cardText);
			SetUserData(itemSp.gameObject, plate);
			itemChilSp.width = this.GetCardPlateSize(plate,cardText).x;
			itemChilSp.height = this.GetCardPlateSize(plate,cardText).y;
		end
		itemChilSp.transform.localPosition = CONST.cardPrefabHandStandOffset[i+1];

	else
		itemSp.spriteName = this.getColorCardName(CONST.cardPrefabHandDownBg[i+1],cardColor);
		itemChilSp.spriteName = this.GetCardTextName(plate,cardText);
		itemChilSp.transform.localPosition = CONST.cardPrefabHandDownOffset[i+1];
		if i == 0 then
			itemChilSp.width = this.GetCardPlateSize(plate,cardText).x;
			itemChilSp.height = this.GetCardPlateSize(plate,cardText).y;
		end
	end
	if index ~= 0 then
		--itemSp:MakePixelPerfect()
		--itemChilSp:MakePixelPerfect()
	end

	--itemSp.width = CONST.cardDownSize[index+1].x;
	--itemSp.height = CONST.cardDownSize[index+1].y;
end


--根据颜色值获取麻将牌的名称
function this.getColorCardName(name,colorIndex)
	if colorIndex == 1 then --绿色
		return name;
	elseif colorIndex == 2 then --黄色
		return name..'y';
	end
end

--刷新用户该有的操作
function this.RefreshOperationSend(operations)
	-- print("RefreshOperationSend was called");
	-- body
	if optionCoroutine ~= nil then 
		StopCoroutine(optionCoroutine);
	end
	operation_send.gameObject:SetActive(#operations ~= 0);
	ButtonHu.gameObject:SetActive(false);
	ButtonGang.gameObject:SetActive(false);
	ButtonPeng.gameObject:SetActive(false);
	ButtonChi.gameObject:SetActive(false);
	ButtonGuo.gameObject:SetActive(true);
	ButtonBu.gameObject:SetActive(false);
	-- 显示用户可以有哪些操作
	for i=1,#operations do
		if operations[i] == csm_pb.CHI then
			ButtonChi.gameObject:SetActive(true)
		elseif operations[i] == csm_pb.PENG then
			ButtonPeng.gameObject:SetActive(true)
		elseif operations[i] == csm_pb.GANG then
			ButtonGang.gameObject:SetActive(true);
		elseif operations[i]== csm_pb.BU then
			this.SetOpertionByGameType(operations[i]);
		elseif operations[i] == csm_pb.HU then
			ButtonHu.gameObject:SetActive(true);
		elseif operations[i] == csm_pb.LAO then
			--捞海底暂时先不处理
		elseif operations[i] == csm_pb.ZTHU then--中途起手胡
			ButtonHu.gameObject:SetActive(true);
		else
			Debugger.LogError('RereshOperationSend unkown type {0}', tostring(operations[i].operation))
		end
	end

	operation_send:GetComponent('UIGrid'):Reposition();

end

--根据麻将类新的不同，转换操作显示
function this.SetOpertionByGameType(operation)
	-- print("SetOpertionByGameType was called,operation:"..operation);
	--1.长沙麻将 正常
	--2.转转红中 传过来的是补，表现为杠
	if roomData.setting.roomTypeValue == proxy_pb.CSM then
		ButtonBu.gameObject:SetActive(operation == csm_pb.BU);
	else
		ButtonBu.gameObject:SetActive(false);
		ButtonGang.gameObject:SetActive(true);
	end

end


--玩家从操作列表中选择了操作
function this.PlayerSelectOperation( operate )
	print("you choose "..operate);
	local tweenColor = nil;
	local tweenScale = nil;

	this.ResetOperationTween();
	local needWaitGuoHu = false;
	--1.播放选择动画
	if operate == "chi" then 
		tweenColor = ButtonChi:GetComponent("TweenColor");
		tweenScale = ButtonChi:GetComponent("TweenScale");
	elseif operate == "peng" then 
		tweenColor = ButtonPeng:GetComponent("TweenColor");
		tweenScale = ButtonPeng:GetComponent("TweenScale");
	elseif operate == "gang" then 
		tweenColor = ButtonGang:GetComponent("TweenColor");
		tweenScale = ButtonGang:GetComponent("TweenScale");
	elseif operate == "bu" then 
		tweenColor = ButtonBu:GetComponent("TweenColor");
		tweenScale = ButtonBu:GetComponent("TweenScale");
	elseif operate == "hu" then 
		tweenColor = ButtonHu:GetComponent("TweenColor");
		tweenScale = ButtonHu:GetComponent("TweenScale");
	elseif operate == "guo" then 
		--过胡的时候要显示弹窗
		if ButtonHu.gameObject.activeInHierarchy then
			needWaitGuoHu = true;
		end
		tweenColor = ButtonGuo:GetComponent("TweenColor");
		tweenScale = ButtonGuo:GetComponent("TweenScale");
	end

	tweenColor.enabled = true;
	tweenScale.enabled = true;
	tweenColor:ResetToBeginning();
	tweenScale:ResetToBeginning();
	
	-- tweenColor.from = Color.white;
	-- tweenColor.to = Color.New(183/255,163/255,123/255);
	tweenColor:PlayForward();
	tweenScale:PlayForward();

	--2.关闭操作界面
	if optionCoroutine ~= nil then 
		StopCoroutine(optionCoroutine);
	end
	optionCoroutine = StartCoroutine(function() 
		WaitForSeconds(tweenColor.duration+0.1);
		operation_send.gameObject:SetActive(false);
		tweenColor:ResetToBeginning();
		tweenScale:ResetToBeginning();
		tweenColor.enabled = false;
		tweenScale.enabled = false;
	end);
	
	if needWaitGuoHu then 
		panelMessageBox.SetParamers(OK_CANCLE,
		nil,
		nil, 
		'是否确定放弃胡牌？'); 
		coroutine.wait(tweenColor.duration+0.1);
		PanelManager.Instance:ShowWindow('panelMessageBox');
		panelMessageBox.VirtualOKClick(playInterval);
		coroutine.wait(playInterval);
	end
end

function this.ResetOperationTween( )
	ButtonChi:GetComponent("TweenColor"):ResetToBeginning();
	ButtonChi:GetComponent("TweenScale"):ResetToBeginning();
	ButtonChi:GetComponent("TweenScale").enabled = false;
	ButtonChi:GetComponent("TweenColor").enabled = false;

	ButtonPeng:GetComponent("TweenColor"):ResetToBeginning();
	ButtonPeng:GetComponent("TweenScale"):ResetToBeginning();
	ButtonPeng:GetComponent("TweenScale").enabled = false;
	ButtonPeng:GetComponent("TweenColor").enabled = false;


	ButtonGang:GetComponent("TweenColor"):ResetToBeginning();
	ButtonGang:GetComponent("TweenScale"):ResetToBeginning();
	ButtonGang:GetComponent("TweenScale").enabled = false;
	ButtonGang:GetComponent("TweenColor").enabled = false;


	ButtonBu:GetComponent("TweenColor"):ResetToBeginning();
	ButtonBu:GetComponent("TweenScale"):ResetToBeginning();
	ButtonBu:GetComponent("TweenScale").enabled = false;
	ButtonBu:GetComponent("TweenColor").enabled = false;


	ButtonHu:GetComponent("TweenColor"):ResetToBeginning();
	ButtonHu:GetComponent("TweenScale"):ResetToBeginning();
	ButtonHu:GetComponent("TweenScale").enabled = false;
	ButtonHu:GetComponent("TweenColor").enabled = false;


	ButtonGuo:GetComponent("TweenColor"):ResetToBeginning();
	ButtonGuo:GetComponent("TweenScale"):ResetToBeginning();
	ButtonGuo:GetComponent("TweenScale").enabled = false;
	ButtonGuo:GetComponent("TweenColor").enabled = false;

	
end

function this.RefreshGridXiByIndex(index,chi, peng, mingGang, anGang,dianGang)
	this.RefreshGridXi(playerGridXi[this.GetUIIndex(index,playerSize)],chi, peng, mingGang, anGang,dianGang);

end

function this.RefreshGridXi(grid, chi, peng, mingGang, anGang,dianGang)
	local prefabName = 'cardZuoButtom';
	local downSpriteName = 'mj_04';
	local upSpriteName = 'mj_01';
	local uiIndex = 0
	if grid == playerGridXi[0] then
		prefabName = 'cardZuoButtom'
		uiIndex = 0
		upSpriteName = 'mj_01';
		downSpriteName = 'mj_04';
	elseif grid == playerGridXi[1]  then
		prefabName = 'cardZuoRight'
		uiIndex = 1
		upSpriteName = 'mj_07';
		downSpriteName = 'mj_08';
	elseif grid == playerGridXi[2]  then
		prefabName = 'cardZuoTop'
		uiIndex = 2
		upSpriteName = 'mj_09';
		downSpriteName = 'mj_04';
	else
		prefabName = 'cardZuoLeft'
		uiIndex = 3
		upSpriteName = 'mj_07';
		downSpriteName = 'mj_08';
	end
	----print(string.format('this.RefreshGridXi:%s prefabName:%s' ,grid.parent.gameObject.name, prefabName))
	----print('chi:'..table.concat(chi, ','))
	----print('peng:'..table.concat(peng, ','))
	----print('mingGang:'..table.concat(mingGang, ','))
	----print('anGang:'..table.concat(anGang, ','))
	local leftCards = { }
	for i=1,#chi,3 do
		table.insert(leftCards, {operation = csm_pb.CHI, plates={chi[i], chi[i+1], chi[i+2]}})
	end
	for i=1,#peng do
		table.insert(leftCards, {operation = csm_pb.PENG, plates={peng[i], peng[i], peng[i]}})
	end

	for i=1,#mingGang do
		table.insert(leftCards, {operation = csm_pb.GANG, plates={mingGang[i], mingGang[i], mingGang[i], mingGang[i]}, state = csm_pb.MING})
	end
	for i=1,#anGang do
		table.insert(leftCards, {operation = csm_pb.GANG, plates={anGang[i], anGang[i], anGang[i], anGang[i]}, state = csm_pb.AN})
	end
	for i=1,#dianGang do
		table.insert(leftCards, {operation = csm_pb.GANG, plates={dianGang[i], dianGang[i], dianGang[i], dianGang[i]}, state = csm_pb.DIAN})
	end

	for j=grid.childCount, #leftCards-1 do
		local cardGroupXi = ResourceManager.Instance:LoadAssetSync(prefabName)
		local obj = NGUITools.AddChild(grid.gameObject, cardGroupXi)
	end
	for i=0,grid.childCount-1 do
		if i < #leftCards then
			local group = leftCards[i+1]
			local item = grid:GetChild(i)
			for j=0,item.childCount-1 do
				if j < #group.plates then
					local show = true --明杠：下面三张，上面一张，四张全部正面朝上 点杠：下面三张朝上，上面一张朝下 暗杠：下面三张朝下，上面一张朝上
					if j < 3  then
						if group.state == csm_pb.AN then
							show = false
						end
					else
						if group.state == csm_pb.DIAN then
							show = false;
						end
					end
					if not show then
						item:GetChild(j):GetComponent('UISprite').spriteName = this.getColorCardName(downSpriteName,cardColor);
						item:GetChild(j):GetChild(0).gameObject:SetActive(false)
					else
						item:GetChild(j):GetComponent('UISprite').spriteName = this.getColorCardName(upSpriteName,cardColor);
						item:GetChild(j):GetChild(0):GetComponent('UISprite').spriteName = this.GetCardTextName(group.plates[j+1],cardText);
						item:GetChild(j):GetChild(0).gameObject:SetActive(true)
					end
					item:GetChild(j).gameObject:SetActive(true)
				else
					item:GetChild(j).gameObject:SetActive(false)
				end
			end
			item.gameObject:SetActive(true)
		else
			grid:GetChild(i).gameObject:SetActive(false)
		end
	end
	grid:GetComponent('UIGrid'):Reposition()
	--
	local pos = playerGridHand[uiIndex].localPosition;
	local gridcellWidth = grid:GetComponent('UIGrid').cellWidth
	local gridcellHeight = grid:GetComponent('UIGrid').cellHeight
    if uiIndex == 0 then
        --if #leftCards > 0 then --有碰吃杠的时候才通过下面逻辑来对齐
        --    pos.x = grid.localPosition.x + (#leftCards > 0 and  gridcellWidth * (#leftCards - 0.5) + 50 or -50)
        --else
        --    -- pos.x = 601;--暂时这样设置TODO（后面需要修改）
        --    pos = playerHandGridPos[uiIndex];
        --end
    elseif uiIndex == 1 then
        if #leftCards > 0 then
            pos.y = grid.localPosition.y + (gridcellHeight * #leftCards) - gridcellHeight*0.5 + 20
        else
            pos = playerHandGridPos[uiIndex];
        end
    elseif uiIndex == 2 then
        if #leftCards > 0 then
            pos.x = grid.localPosition.x -  gridcellWidth * #leftCards + 110;
        else
            pos = playerHandGridPos[uiIndex];
        end

    else
        if #leftCards > 0 then
            pos.y = grid.localPosition.y - (gridcellHeight * #leftCards) + gridcellHeight*0.5 - 45
        else
            pos = playerHandGridPos[uiIndex];
        end

    end
	if uiIndex ~=0 then
		playerGridHand[uiIndex].localPosition = pos;
	end


end

function this.RefreshAllGridXi()
	-- --print("RefreshAllGridXi was called");
	for i=0,playerSize-1 do
		local pData = this.GetPlayerDataByUIIndex(i)
		--this.RefreshGridXi(playerGridXi[this.GetUIIndex(i,playerSize)], {},{},{},{});
		if pData then
			this.RefreshGridXi(playerGridXi[this.GetUIIndex(i,playerSize)], pData.chi, pData.peng, pData.mingGang, pData.anGang,pData.dianGang)
			playerGridXi[this.GetUIIndex(i,playerSize)].gameObject:SetActive(true);
		else
			this.RefreshGridXi(playerGridXi[this.GetUIIndex(i,playerSize)], {},{},{},{});
			playerGridXi[this.GetUIIndex(i,playerSize)].gameObject:SetActive(false);
		end

	end

	
end

function this.RefreshTabelThrowByIndex(index, plates, seat)
	--print("RefreshTabelThrowByIndex:index:"..index..",seat:"..seat);
	this.RefreshTabelThrow(playerThrow[this.GetUIIndex(index,playerSize)], plates, seat);


end
	

function this.RefreshTabelThrow(UItabel, plates, seat)
	-- --print("RefreshTabelThrow was called,cardColor:"..cardColor);
	local prefabName = 'cardPaiHeButtom'
	local throwCardIndex = 1;
	if UItabel == playerThrow[0] then
		prefabName = 'cardPaiHeButtom';
		throwCardIndex = 1;
	elseif UItabel == playerThrow[1]  then
		prefabName = 'cardPaiHeRight';
		throwCardIndex = 2;
	elseif UItabel == playerThrow[2]  then
		prefabName = 'cardPaiHeTop';
		throwCardIndex = 3;
	else
		prefabName = 'cardPaiHeLeft'
		throwCardIndex = 4;
	end
	--print(string.format('RefreshTabelThrow:%s num:%d prefabName:%s' ,UItabel.parent.gameObject.name, #plates, prefabName))
	for j=UItabel.childCount,#plates-1 do
		local card = ResourceManager.Instance:LoadAssetSync(prefabName)
		local rot = card.transform.localRotation
		local obj = NGUITools.AddChild(UItabel.gameObject, card)
		obj.transform.localRotation = rot;
	end


	--如果是两个人打，那么牌桌上的牌20张再换行
	if prefabName == 'cardPaiHeTop' then
		local tableGrid = UItabel:GetComponent('UIGrid');
		if playerSize == 2 then

			tableGrid.maxPerLine = 20;
			UItabel.localPosition.x = 424;
			UItabel.localPosition = Vector3(424,196,0);
		else
			tableGrid.maxPerLine = 12;
			UItabel.localPosition = playerTableThrowGridPos[2];
		end
	elseif prefabName == 'cardPaiHeButtom' then
		local tableGrid = UItabel:GetComponent('UIGrid');
		if playerSize == 2 then
			tableGrid.maxPerLine = 20;
			UItabel.localPosition.x = -501;
			UItabel.localPosition = Vector3(-501,UItabel.localPosition.y,0);
		else
			tableGrid.maxPerLine = 12;
			UItabel.localPosition = playerTableThrowGridPos[0];
		end
	end

	for i=0,UItabel.childCount-1 do
		if i < #plates then
			local item = UItabel:GetChild(i);
			item:GetComponent('UISprite').spriteName = this.getColorCardName(CONST.cardPrefabHandDownBg[throwCardIndex],cardColor);
			item:Find('card'):GetComponent('UISprite').spriteName = this.GetCardTextName(plates[i+1],cardText);
			SetUserData(item.gameObject, plates[i+1])


			if prefabName == 'cardPaiHeRight' then
				item:GetComponent('UISprite').depth = 50-i-1
				item:Find('card'):GetComponent('UISprite').depth = 50-i
			elseif prefabName == 'cardPaiHeLeft' then
				item:GetComponent('UISprite').depth = i+2;
				item:Find('card'):GetComponent('UISprite').depth = i+3;
			elseif prefabName == 'cardPaiHeButtom'   then
				if i > UItabel:GetComponent('UIGrid').maxPerLine-1 then
					local maxPerLine = UItabel:GetComponent('UIGrid').maxPerLine;
					--print("maxPerLine:"..maxPerLine);
					--print("before item.depth"..(item:GetComponent('UISprite').depth));
					item:GetComponent('UISprite').depth = 5- math.floor(i/maxPerLine);
					--print("after item.depth"..(item:GetComponent('UISprite').depth));


				else
					item:GetComponent('UISprite').depth = 5;
				end

			end
		
			item.gameObject:SetActive(true);

		else
			UItabel:GetChild(i).gameObject:SetActive(false)
		end
	end

	
	UItabel:GetComponent('UIGrid'):Reposition();


end

function this.SetPlateEffectShowByIndex(index,plates, seat)
	this.SetPlateEffectShow(playerThrow[this.GetUIIndex(index,playerSize)], plates, seat);

end

function this.SetPlateEffectShow(UItabel, plates, seat)
	if seat == lastOperat.seat and plates[#plates] == lastOperat.plate[1] then
		curOperatPlateEffect.gameObject:SetActive(true)
		curOperatPlateEffect.position = UItabel:GetChild(#plates-1).position;

		StartCoroutine(function ()
			WaitForEndOfFrame();
			local itemPos = UItabel:GetChild(#plates-1).position;
			if math.abs(curOperatPlateEffect.position.x - itemPos.x)>3 then
				curOperatPlateEffect.position = itemPos;
			end
			if math.abs(curOperatPlateEffect.position.y - itemPos.y)>3 then
				curOperatPlateEffect.position = itemPos;
			end
		end);
		
		----print('seat:'..seat..' plate:'..plates[#plates])
		----print('plate pos:'..UItabel:GetChild(#plates-1).localPosition.x..' '..UItabel:GetChild(#plates-1).localPosition.y..' '..UItabel:GetChild(#plates-1).localPosition.z)
	end	
end

function this.RefreshAllTabelThrow()
	-- --print("RefreshAllTabelThrow was called");
	for i=0,playerSize-1 do
		local pData = this.GetPlayerDataByUIIndex(i)
		--playerThrow[this.GetUIIndex(i,playerSize)].gameObject:SetActive(false);
		if pData and i < playerSize then

			playerThrow[this.GetUIIndex(i,playerSize)].gameObject:SetActive(true);
			this.RefreshTabelThrow(playerThrow[this.GetUIIndex(i,playerSize)], pData.paiHe, pData.seat);
			--this.SetPlateEffectShow(playerThrow[this.GetUIIndex(i,playerSize)], pData.paiHe, pData.seat);
		else
			playerThrow[this.GetUIIndex(i,playerSize)].gameObject:SetActive(false);

		end
	end
end


function this.AutoPlay()
    Debugger.Log('replay start', nil)
	if #RoundDetail.records == 0 then
		print('no records!')
		return
	end
	
	coroutine.wait(1)
	--playIndex = 60
    local lastSeat = RoundDetail.records[1].seat -1
    while gameObject.activeSelf do
        if not isPause then
			local d = RoundDetail.records[playIndex]
			if not d then
				break
			end
			-- local action = csm_pb.RPlayRecord()
			-- action:ParseFromString(d.body)
			this.OnPlayerPlay(d)
			-- print("record.version:"..tostring(RoundDetail.version))
			-- print("have operations.length:"..#d.operation);
			playIndex = playIndex+1
			print("当前进度 ",playIndex,"/",#RoundDetail.records)
			if RoundDetail.roundEnd and RoundDetail.roundEnd~=nil then 
				if playIndex > #RoundDetail.records and #RoundDetail.roundEnd.players > 0 then
					Debugger.Log('replay end', nil)
					if #RoundDetail.roundEnd.players > 0 then 
						--等待抓鸟动画播放完再弹出小结算
						coroutine.wait(0.5);
						this.OnRoundEnd(RoundDetail.roundEnd);
					end
					break
				end
			end
            
			coroutine.wait(playInterval)
		else
			coroutine.wait(0.5)
        end
    end
end


function this.OnRoundEnd( b )
	local RoundData 			= {};
	RoundData.data 				= b;
	RoundData.mySeat 			= mySeat;
	RoundData.playerData 		= playerData;
	stageRoomInfo 				= {};
	stageRoomInfo.roomNumber 	= replayData.roomNumber;
	stageRoomInfo.roomData 		= roomData;
	stageRoomInfo.roomData.round 		= roomData.round+1;
	stageRoomInfo.cardColor 	= cardColor;
	stageRoomInfo.cardText 		= cardText;
	stageRoomInfo.RoundData 	= RoundData;
	stageRoomInfo.RoundAllData 	= RoundAllData;
	stageRoomInfo.isInGame =false
	PanelManager.Instance:ShowWindow('panelStageClear_mj', stageRoomInfo);

	print("panelIngame:"..tostring(panelInGamemj));
end

function this.OnPlayerPlay(record)
	-- print("record.c"..record.c);
	if record.c == "CBu" then  --补牌
		this.OnPlayerBuPai(record)
	elseif record.c == "CChi" then  --吃牌 
		this.OnPlayerChiPai(record)
	elseif record.c == "CChu" then  --出牌 
		this.OnPlayerChuPai(record)
	elseif record.c == "CFloatScore" then --飘分
		this.OnShowPiaoFen(record)
	elseif record.c == "CGang" then  --扛牌
		this.OnPlayerGangPai(record)
	elseif record.c == "CHu" then  --胡牌
		this.OnPlayerHuPai(record)
	elseif record.c == "CLao" then  -- 海底捞
		this.OnPlayerLaoHaiDi(record)
	elseif record.c == "CMo" then  --摸牌  -1
		this.OnPlayerMoPai(record)
	elseif record.c == "CPeng" then  -- 碰牌
		this.OnPlayerPengPai(record)	
	elseif record.c == "CStart" then  --给他发牌
		this.OnPlayerStart(record)
	elseif record.c == "CZha" then  --扎鸟
		this.OnPlayerZha(record)
	elseif record.c == "CZhi" then  --掷骰子
		this.OnPlayerZhiShaiZi(record)
	elseif record.c == "CStartHu" then --起手胡
		this.OnPlayerStartHu(record);
	elseif record.c == "CZtHu" then--中途起手胡
		this.OnPlayerZhongtuHu(record);
	elseif record.c == "CGuo" then 
		this.OnPlayerGuo(record);
	elseif record.c == "CScore" then 
		if record.simpleHuScoreBoard then
			for i=1,#record.simpleHuScoreBoard do
				local uiindex = this.GetUIIndex(this.GetUIIndexBySeat(record.simpleHuScoreBoard[i].seat),playerSize)
				playerScore[uiindex]:GetComponent('UILabel').text = record.simpleHuScoreBoard[i].score;
			end
		end
	else
		print('unkown operation:'..record.operation)
	end
	local index = this.GetUIIndex(this.GetUIIndexBySeat(record.seat),playerSize)
	--托管离线标识
	playerOfflineTime[index].gameObject:SetActive(record.offline == true)
	playerTrusteeship[index].gameObject:SetActive(record.trusteeship == true)
end

function this.OnPlayerStart(b)
	local index = this.GetUIIndexBySeat(b.seat);
	--this.RefreshGridHand(playerGridHand[this.GetUIIndex(index,playerSize)], this.GetUIIndex(index,playerSize), b.mahjongs, #b.mahjongs, true, -1, {}) --pData.moMahjong,
	if(curmahjongCount)then 
		curmahjongCount=curmahjongCount - #b.mahjongs
		this.SetDipaiNum(curmahjongCount)
	end
	this.RefreshGridHandByIndex(this.GetUIIndex(index,playerSize),this.GetUIIndex(index,playerSize),b.mahjongs, #b.mahjongs, true, -1,{});-- tableClone(b.mahjongs)

	local pData = this.GetPlayerDataBySeat(b.seat)  --初始化他的手牌
	pData.mahjongs = b.mahjongs
end

function this.OnPlayerZha(b)
	print("扎鸟动画")
	local duration = 0.4
	--这里要重新封装一下鸟数据的数据结构，改的跟小结算中的一样
	for i = 1, #b.birdDetails do
		print("birdDetails "..i.." seat:"..b.birdDetails[i].seat);
	end

	local Birds = this.RefactBirdsData(b.birdDetails);

	for i = 1, #Birds do
		local pData = this.GetPlayerDataBySeat(Birds[i].seat);
		if pData then
			this.FlyBirds(Birds[i].seat,Birds[i].mahjongs,Birds[i].count,duration);
		end
	end
	--local index = this.GetUIIndexBySeat(b.seat)
end

function this.RefactBirdsData(oldbirdsData)
	local newBirdsData = {};
	local tempBirdData = {};
	for i = 1, #oldbirdsData do
		if tempBirdData[oldbirdsData[i].seat] == nil then
			tempBirdData[oldbirdsData[i].seat] = {};
			tempBirdData[oldbirdsData[i].seat].mahjongs = {};
			tempBirdData[oldbirdsData[i].seat].count = 0;
		end
		tempBirdData[oldbirdsData[i].seat].seat = oldbirdsData[i].seat;
		table.insert(tempBirdData[oldbirdsData[i].seat].mahjongs,oldbirdsData[i].mahjong);
		tempBirdData[oldbirdsData[i].seat].count = tempBirdData[oldbirdsData[i].seat].count + 1;
	end
	for key, value in pairs(tempBirdData) do
		table.insert(newBirdsData,value);
	end
	return newBirdsData;
end


function this.FlyBirds(seat, value, count, duration)
	print(string.format("扎鸟, seat = %d, count = %d ", seat, count))
	local index = this.GetUIIndexBySeat(seat)
	local t = this.GetFreeBirds(count)
	print("t.length:"..tostring(#t));
	for i=1,count do
		t[i].gameObject:SetActive(true);
		t[i].localPosition = Vector3.zero
		local tweenPos = t[i]:GetComponent('TweenPosition');
		tweenPos:ResetToBeginning();
		tweenPos.worldSpace = false;
		tweenPos.from = Vector3.New(0,0,0);
		local realIndex = this.GetUIIndex(index,playerSize);
		local posIndex = count == 1 and (realIndex==3 and i or i + 1) or i;
		--print("fly realIndex:"..realIndex.."|count:"..count.."|posIndex:"..posIndex);
		tweenPos.to = CONST.birdPos[this.GetUIIndex(index,playerSize)+1][posIndex];
		tweenPos.duration = duration;
		tweenPos:PlayForward();
		StartCoroutine(function()
			tweenPos.value.y = tweenPos.value.y+0.1;
		end);
		--print("after:"..tostring(t[i]:GetComponent('SpringPosition').target));
		t[i]:Find('Pai'):GetComponent('UISprite').spriteName = this.GetCardTextName(value[i],cardText);

	end
	AudioManager.Instance:PlayAudio("audio_bird");
end

function this.GetFreeBirds(count)
	local t = {}
	local item 
	for i=0,playerBrid.childCount-1 do
		item = playerBrid:GetChild(i)
		if not item.gameObject.activeSelf and #t < count then
			table.insert(t, item)
		end
	end
	
	for i=#t,count do
		local perfab = ResourceManager.Instance:LoadAssetSync('Bird')
		local e = NGUITools.AddChild(playerBrid.gameObject, perfab)
		e.gameObject:SetActive(false)
		table.insert(t, e.transform)
	end
	return t
end

function this.OnPlayerLaoHaiDi(action)
	print("OnPlayerLaoHaiDi ---------------------->");
	local b = this.GetFreeBirds(0)
	if #b > 0 then
		b[1]:GetComponent('UIWidget').alpha = 1
		b[1]:Find('Pai'):GetComponent('UISprite').spriteName = this.GetCardTextName(action.mahjong,cardText);
		b[1].gameObject:SetActive(true);
	else
		--print('get birds error')
	end
end

function this.OnShowPiaoFen(b)
	local i = this.GetUIIndexBySeat(b.seat);
	playerPiaoFen[this.GetUIIndex(i,playerSize)].gameObject:SetActive(true)
	if b.floatScore == 0 then
		playerPiaoFen[this.GetUIIndex(i,playerSize)]:GetComponent('UILabel').text = "不飘分"
	else
		playerPiaoFen[this.GetUIIndex(i,playerSize)]:GetComponent('UILabel').text = "飘"..b.floatScore.."分"
	end
end


function this.OnPlayerMoPai(b)
	local index = this.GetUIIndexBySeat(b.seat)
	local pData = this.GetPlayerDataBySeat(b.seat)
	--this.GetPlayerDataBySeat(mySeat).haveStartHu = b.haveStartHu
	pData.moMahjong = -1
	this.RefreshGridHand(playerGridHand[this.GetUIIndex(index,playerSize)], this.GetUIIndex(index,playerSize), pData.mahjongs, pData.mahjongCount, pData.moMahjong, -1, {}) 
	pData.moMahjong = b.mahjong
	this.RefreshCurMoPai(index, b.mahjong,true);
	curmahjongCount=b.surplus
	this.SetDipaiNum(curmahjongCount)
	
	if b.seat == mySeat then

		if index == 0 then

		else
			print("insert mopai,index:"..index);
			--table.insert(pData.mahjongs, b.mahjong)
		end
		needChuPai = true
	else
		--pData.mahjongCount = b.mahjongCount;
		needChuPai = false
	end
	table.insert(pData.mahjongs, b.mahjong)
	
	this.ShowWaitOpreatEffect(b.seat, true)
	lastOperat.op = csm_pb.MOPAI
	lastOperat.plate = {b.mahjong}
	lastOperat.seat = b.seat
	--设置用户操作
	if RoundDetail.version == 1 then 
		if b.operation and #b.operation > 0  then 
			for i=1,#b.operation do
				if b.operation[i].seat == mySeat then 
					this.RefreshOperationSend(b.operation[i].operation);
				end
			end
		end
	end
end

local swcor = nil
--显示出牌的状态，东西南北，哪个该出牌了
function this.ShowWaitOpreatEffect(seat, show)
	coroutine.stop(swcor);
	local index = this.GetUIIndexBySeat(seat)
	function showState(index,show)
		curActivePlayerIcon[index]:Find('frame').gameObject:SetActive(show);
		curActivePlayerIcon[index]:Find('select').gameObject:SetActive(show);
		curActivePlayerIcon[index]:Find('unselect').gameObject:SetActive(not show);
	end
	--先隐藏所有
	for i=0,3 do
		showState(i,not show);
	end
	for i=0,playerSize-1 do
		if index == i then
			showState(this.GetUIIndex(i,playerSize),show);
			if show then
				swcor = coroutine.start(
						function()
							local t = 10
							while t >= 0 do
								dipai:Find('timer'):GetComponent('UILabel').text = string.format('%02d', t)
								t = t -1
								coroutine.wait(1)
							end
						end
				)
			end
		else
			showState(this.GetUIIndex(i,playerSize),not show);
		end
	end
	----print('ShowWaitOpreatEffect seat:'..seat..' show:'..tostring(show))
end

function this.OnPlayerPengPai(b)
	print("pengPai seat:"..b.seat);
	this.RefreshCurMoPai(-1, b.mahjong)
	local pData = this.GetPlayerDataBySeat(b.seat)
	local i = this.GetUIIndexBySeat(b.seat)
	--显示特效
	effManger.ShowEffect(gameObject,"peng",playerHupaiPos[this.GetUIIndex(i,playerSize)]);

	table.insert(pData.peng, b.mahjong)
	this.RefreshGridXiByIndex(i,pData.chi, pData.peng, pData.mingGang, pData.anGang,pData.dianGang);
	this.DoRemovePlates(b.seat, {b.mahjong, b.mahjong}, false)
	if b.seat == mySeat then
		needChuPai = true
	else
		needChuPai = false
	end
	if b:HasField('outSeat') then
		local pData_out = this.GetPlayerDataBySeat(b.outSeat)
		local i_out = this.GetUIIndexBySeat(b.outSeat)
		for i=#pData_out.paiHe,1,-1 do
			if pData_out.paiHe[i] == b.mahjong then
				table.remove(pData_out.paiHe, i)
				--pData_out.paiHe:remove(i)
				break
			end
		end
		this.RefreshTabelThrowByIndex(i_out, pData_out.paiHe, b.outSeat);
		curOperatPlateEffect.gameObject:SetActive(false)
	end
	this.ShowWaitOpreatEffect(b.seat, true)

	lastOperat.op = csm_pb.PENGPAI
	lastOperat.plate = {}
	lastOperat.seat = b.seat
	if RoundDetail.setting.roomType == proxy_pb.CSM then
		AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(pData.sex==1 and 'man_' or 'woman_')..'peng')
	else
		AudioManager.Instance:PlayAudio((pData.sex==1 and 'man_' or 'woman_').."peng")
	end
	--设置用户操作
	if RoundDetail.version == 1 then 
		if b.seat == mySeat then 
			this.PlayerSelectOperation("peng");
		else--不是轮到自己，点过
			this.PlayerSelectOperation("guo");
		end
		--这里需要先设置操作特效，再检查还有哪些操作，这个步骤不能错，因为自己操作完可能又是自己操作，这样可以保证不被覆盖
		if b.operation and #b.operation > 0  then 
			for i=1,#b.operation do
				print("b.operation[i].seat:"..b.operation[i].seat.."|mySeat:"..mySeat);
				if b.operation[i].seat == mySeat then 
					this.RefreshOperationSend(b.operation[i].operation);
				end
			end
		end
	end
end

function this.OnPlayerGuo( b )
	print("OnPlayerGuo-------------------------------------->")
	if RoundDetail.version == 1 then 
		print("b.seat:"..b.seat.."|myseat:"..mySeat)
		--if b.seat == mySeat then 
		this.PlayerSelectOperation("guo")
		--end
	end
end

function this.OnPlayerChuPai(b)
	local pData = this.GetPlayerDataBySeat(b.seat);
	--print("player sex:"..pData.sex);
	local index = this.GetUIIndexBySeat(b.seat);
	--刷新出牌
	this.RefreshCurMoPai(-1, b.mahjong,true);
	table.insert(pData.paiHe,b.mahjong)
	--刷新打出到牌桌上的牌
	--print("remove plate:"..b.mahjong);
	playerChuPaiShows[this.GetUIIndex(index,playerSize)].gameObject:SetActive(true);
	local showSpriteName = playerChuPaiShows[this.GetUIIndex(index,playerSize)]:GetComponent("UISprite").spriteName;
    playerChuPaiShows[this.GetUIIndex(index,playerSize)]:GetComponent("UISprite").spriteName = this.getColorCardName("mj_02",cardColor);
	playerChuPaiShows[this.GetUIIndex(index,playerSize)]:Find("card"):GetComponent("UISprite").spriteName = this.GetCardTextName(b.mahjong,cardText);
	playerChuPaiShows[this.GetUIIndex(index,playerSize)]:Find("card"):GetComponent("UISprite").width  =this.GetCardPlateSize(b.mahjong,cardText).x;
	playerChuPaiShows[this.GetUIIndex(index,playerSize)]:Find("card"):GetComponent("UISprite").height =this.GetCardPlateSize(b.mahjong,cardText).y;
	this.RefreshTabelThrowByIndex(index,  pData.paiHe, b.seat);

	StartCoroutine(function ()
		WaitForSeconds(1);
		--播放出牌动画
		playerChuPaiShows[this.GetUIIndex(index,playerSize)].gameObject:SetActive(false);
	end)

	--自己的牌单独处理
	--if b.seat ~= mySeat then
		this.DoRemovePlates(b.seat, {b.mahjong}, false);
	--end
	needChuPai = false
	pData.moMahjong = -1

	lastOperat.op 		= csm_pb.CHUPAI
	lastOperat.plate 	= {b.mahjong}
	lastOperat.seat 	= b.seat

	StartCoroutine(function ()
		WaitForEndOfFrame();
		this.SetPlateEffectShowByIndex(index,pData.paiHe, b.seat);
	end);
	if RoundDetail.setting.roomType == proxy_pb.CSM then
		AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(pData.sex==1 and 'man' or 'woman')..math.floor(b.mahjong / 9 + 1)..(b.mahjong % 9 + 1))
	else
		AudioManager.Instance:PlayAudio((pData.sex==1 and 'man' or 'woman')..math.floor(b.mahjong / 9 + 1)..(b.mahjong % 9 + 1))
	end
	--设置用户操作
	if RoundDetail.version == 1 then 
		if b.operation and #b.operation > 0  then 
			for i=1,#b.operation do
				if b.operation[i].seat == mySeat then 
					this.RefreshOperationSend(b.operation[i].operation);
				end
			end
			
		end
	end
end

function this.OnPlayerChiPai(b)
	this.RefreshCurMoPai(-1, b.mahjong)
	local pData = this.GetPlayerDataBySeat(b.seat)
	local i = this.GetUIIndexBySeat(b.seat)

	--显示特效
	effManger.ShowEffect(gameObject,"chi",playerHupaiPos[this.GetUIIndex(i,playerSize)]);

	table.insert(pData.chi, b.mahjong)
	table.insert(pData.chi, b.others[1])
	table.insert(pData.chi, b.others[2])
	this.RefreshGridXiByIndex(i,pData.chi, pData.peng, pData.mingGang, pData.anGang,pData.dianGang);
	this.DoRemovePlates(b.seat, b.others, false)
	if b.seat == mySeat then
		needChuPai = true
	else
		needChuPai = false
	end
	if b:HasField('outSeat') then
		local pData_out = this.GetPlayerDataBySeat(b.outSeat)
		local i_out = this.GetUIIndexBySeat(b.outSeat)
		for i=#pData_out.paiHe,1,-1 do
			if pData_out.paiHe[i] == b.mahjong then
				table.remove(pData_out.paiHe, i)
				--pData_out.paiHe:remove(i)
				break
			end
		end
		this.RefreshTabelThrowByIndex(i_out, pData_out.paiHe, b.outSeat);
		curOperatPlateEffect.gameObject:SetActive(false)
	end
	this.ShowWaitOpreatEffect(b.seat, true)
	
	lastOperat.op = csm_pb.CHIPAI
	lastOperat.plate = {b.mahjong}
	lastOperat.seat = b.seat
	if RoundDetail.setting.roomType == proxy_pb.CSM then
		AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(pData.sex==1 and 'man_' or 'woman_')..'chi')
	else
		AudioManager.Instance:PlayAudio((pData.sex==1 and 'man_' or 'woman_').."chi")
	end

	--设置用户操作
	if RoundDetail.version == 1 then 
		print("chi-------------b.operation.leng")
		if b.seat == mySeat then 
			this.PlayerSelectOperation("chi");
		else--不是轮到自己，点过
			this.PlayerSelectOperation("guo");
		end

		if b.operation and #b.operation > 0  then 
			for i=1,#b.operation do
				if b.operation[i].seat == mySeat then 
					this.RefreshOperationSend(b.operation[i].operation);
				end
			end
		end
		
	end
end

function this.OnApplicationFocus(  )
	-- body
end

function this.SetPlayerPos(state)

	--设置座位位置
	local localPos = nil
	for i=0,3 do
		if state  ~= csm_pb.GAMING and (#playerData < roomData.setting.size or roomData.round == 1) then
			if i == 0 then
				localPos = Vector3.New(0,-119,0)
			elseif i == 1 then
				localPos = Vector3.New(395,55,0)
			elseif i == 2 then
				localPos = Vector3.New(0,271,0)
			else
				localPos = Vector3.New(-393,55,0)
			end
		else
			if i == 0 then
				localPos = Vector3.New(-611,-168,0)
			elseif i == 1 then
				localPos = Vector3.New(610,180,0)
			elseif i == 2 then
				localPos = Vector3.New(316.8,298.1,0)
			else
				localPos = Vector3.New(-611,177.5,0)
			end
		end
		playerName[i].parent.localPosition = localPos
	end

	--两人局
	if roomData.setting.size == 2 then
		playerName[0].parent.gameObject:SetActive(true);
		playerName[1].parent.gameObject:SetActive(false);
		playerName[2].parent.gameObject:SetActive(true);
		playerName[3].parent.gameObject:SetActive(false);
	--三人局
	elseif roomData.setting.size == 3 then
		playerName[0].parent.gameObject:SetActive(true);
		playerName[1].parent.gameObject:SetActive(true);
		playerName[2].parent.gameObject:SetActive(false);
		playerName[3].parent.gameObject:SetActive(true);
	--四人局
	elseif roomData.setting.size == 4 then
		playerName[0].parent.gameObject:SetActive(true);
		playerName[1].parent.gameObject:SetActive(true);
		playerName[2].parent.gameObject:SetActive(true);
		playerName[3].parent.gameObject:SetActive(true);
	end
	
end

function this.OnPlayerBuPai(b)
	local pData = this.GetPlayerDataBySeat(b.seat)
	local i = this.GetUIIndexBySeat(b.seat)
	----print('hand mahjongs:'..table.concat(pData.mahjongs, ','))
	----print('hand mahjongCount:'..pData.mahjongCount)

	local plates={b.mahjong, b.mahjong, b.mahjong}
	--if b.gangType == csm_pb.MING then
	--	table.insert(pData.mingGang, b.mahjong)
	--else
	--	table.insert(pData.anGang, b.mahjong)
	--	table.insert(plates, b.mahjong)
	--end
	if b.gangType == csm_pb.MING then
		table.insert(pData.mingGang, b.mahjong)
	elseif b.gangType == csm_pb.AN then
		table.insert(pData.anGang, b.mahjong)
		table.insert(plates, b.mahjong)
	elseif b.gangType == csm_pb.DIAN then
		table.insert(pData.dianGang, b.mahjong)
		table.insert(plates, b.mahjong)
	end
	for i=1,#pData.peng do
		if pData.peng[i] == b.mahjong then
				local plates={b.mahjong}
				table.remove(pData.peng, i)
				--pData.peng:remove(i)
			break
		end
	end
	this.RefreshGridXiByIndex(i,pData.chi, pData.peng, pData.mingGang, pData.anGang,pData.dianGang);

	--显示特效
	function getEffectStringByRoomType(roomType)
		if roomType == proxy_pb.CSM then
			return "bu";
		elseif roomType == proxy_pb.ZZM or roomType == proxy_pb.HZM then
			return "gang";
		end
	end
	effManger.ShowEffect(gameObject,getEffectStringByRoomType(roomData.setting.roomTypeValue),playerHupaiPos[this.GetUIIndex(i,playerSize)]);
	
	--点杠只删除一张牌
	if b.gangType == csm_pb.DIAN then
		this.DoRemovePlates(b.seat, {b.mahjong}, false)
	else
		this.DoRemovePlates(b.seat, plates, false)
	end
	if b.seat == mySeat then
		needChuPai = true
	else
		needChuPai = false
	end
	
	if b:HasField('outSeat') and b.gangType == csm_pb.MING then
		local pData_out = this.GetPlayerDataBySeat(b.outSeat)
		local i_out = this.GetUIIndexBySeat(b.outSeat)
		for i=#pData_out.paiHe,1,-1 do
			if pData_out.paiHe[i] == b.mahjong then
				table.remove(pData_out.paiHe, i)
				--pData_out.paiHe:remove(i)
				break
			end
		end
		this.RefreshTabelThrowByIndex(i_out,pData_out.paiHe, b.outSeat);
		curOperatPlateEffect.gameObject:SetActive(false)
	end
	
	this.ShowWaitOpreatEffect(b.seat, true)
	if RoundDetail.setting.roomType == proxy_pb.CSM then
		AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(pData.sex==1 and 'man_' or 'woman_')..'bu')
	else
		AudioManager.Instance:PlayAudio((pData.sex==1 and 'man_' or 'woman_').."gang")
	end

	--设置用户操作
	if RoundDetail.version == 1 then 
		if b.seat == mySeat then 
			this.PlayerSelectOperation("bu");
		else--不是轮到自己，点过
			this.PlayerSelectOperation("guo");
		end

		if b.operation and #b.operation > 0  then 
			for i=1,#b.operation do
				if b.operation[i].seat == mySeat then 
					this.RefreshOperationSend(b.operation[i].operation);
				end
			end
		end
		
	end

end

function this.OnPlayerGangPai(b)
	print("OnPlayerGangPai was called");
	rollResult = nil
	local pData = this.GetPlayerDataBySeat(b.seat)
	local i = this.GetUIIndexBySeat(b.seat)

	local effectString = "";
	local plates={b.mahjong, b.mahjong, b.mahjong}
	if b.gangType == csm_pb.MING then
		print("player ming gang-------->");

		table.insert(pData.mingGang,b.mahjong);
		--pData.mingGang:append(b.mahjong)
		if RoundDetail.setting.roomType == proxy_pb.CSM then
			AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(pData.sex==1 and 'man_' or 'woman_')..'gang')
		else
			AudioManager.Instance:PlayAudio((pData.sex==1 and 'man_' or 'woman_').."gang")
		end
		effectString = "mg";
	elseif b.gangType == csm_pb.AN then
		print("player an gang-------->");
		table.insert(pData.anGang,b.mahjong);
		--pData.anGang:append(b.mahjong)
		table.insert(plates, b.mahjong)
		if RoundDetail.setting.roomType == proxy_pb.CSM then
			AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(pData.sex==1 and 'man_' or 'woman_')..'gang')
		else
			AudioManager.Instance:PlayAudio((pData.sex==1 and 'man_' or 'woman_').."gang")
		end
		effectString = "ag";
	elseif b.gangType == csm_pb.DIAN then
		print("player dian gang-------->");
		table.insert(pData.dianGang,b.mahjong);
		--pData.dianGang:append(b.mahjong);
		table.insert(plates, b.mahjong)
		if RoundDetail.setting.roomType == proxy_pb.CSM then
			AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(pData.sex==1 and 'man_' or 'woman_')..'gang')
		else
			AudioManager.Instance:PlayAudio((pData.sex==1 and 'man_' or 'woman_').."gang")
		end
		effectString = "gang";
	end
	for i=1,#pData.peng do
		if pData.peng[i] == b.mahjong then
				local plates={b.mahjong}
				table.remove(pData.peng, i)
				--pData.peng:remove(i)
			break
		end
	end

	--显示特效
	effManger.ShowEffect(gameObject,effectString,playerHupaiPos[this.GetUIIndex(i,playerSize)]);

	this.RefreshGridXiByIndex(i,pData.chi, pData.peng, pData.mingGang, pData.anGang,pData.dianGang);
	this.DoRemovePlates(b.seat, plates, false)
	needChuPai = false
	
	if b:HasField('outSeat') and b.gangType == csm_pb.MING then
		local pData_out = this.GetPlayerDataBySeat(b.outSeat)
		local i_out = this.GetUIIndexBySeat(b.outSeat)
		for i=#pData_out.paiHe,1,-1 do
			if pData_out.paiHe[i] == b.mahjong then
				table.remove(pData_out.paiHe, i)
				--pData_out.paiHe:remove(i)
				break
			end
		end
		this.RefreshTabelThrowByIndex(i_out,pData_out.paiHe, b.outSeat);
		curOperatPlateEffect.gameObject:SetActive(false)
	end
	this.RefreshCurMoPai(-1, b.mahjong)
	
	--coroutine.start(this.Roll, 1, b.firstDice, b.secondDice, .2, b.seat, b.outRange)

	lastOperat.op = csm_pb.GANGPAI
	lastOperat.plate = {}
	lastOperat.seat = b.seat
	if RoundDetail.setting.roomType == proxy_pb.CSM then
		AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(pData.sex==1 and 'man_' or 'woman_')..'gang')
	else
		AudioManager.Instance:PlayAudio((pData.sex==1 and 'man_' or 'woman_').."gang")
	end


	--设置用户操作
	if RoundDetail.version == 1 then 
		if b.seat == mySeat then 
			this.PlayerSelectOperation("gang");
		else--不是轮到自己，点过
			this.PlayerSelectOperation("guo");
		end
		if b.operation and #b.operation > 0  then 
			for i=1,#b.operation do
				if b.operation[i].seat == mySeat then 
					this.RefreshOperationSend(b.operation[i].operation);
				end
			end
		end

		
	end
end

function this.Roll(duration, value1, value2, lifetime, clientseat, isChujie)
	if not lifetime then
		lifetime = 3
	end
	kaiBao:Find('ShaiZiAnimation').gameObject:SetActive(true)
	AudioManager.Instance:PlayAudio('audio_shaizi')
	coroutine.wait(duration)
	if value1 and value2 then
		kaiBao:Find('ShaiZiGroups/ShaiZi1'):GetComponent('UISprite').spriteName = 'shaizi'..value1
		kaiBao:Find('ShaiZiGroups/ShaiZi2'):GetComponent('UISprite').spriteName = 'shaizi'..value2
	else
		--self.kaiBao:Object():ShowShaiZi()
		--print('roll no value')
	end
	coroutine.wait(lifetime)
	kaiBao:Find('ShaiZiAnimation').gameObject:SetActive(false)

	if isChujie then
		effManger.ShowEffect(gameObject, 'chujie', Vector3.zero)
	else
		if rollResult then
			coroutine.start(this.OnRollEnd, rollResult.firstMahjong, rollResult.secondMahjong, 2)
		end
	end
end

function this.OnRollEnd(value1, value2, lifetime)
	local b = this.GetFreeBirds(2)
	
	b[1].gameObject:SetActive(true)
	b[2].gameObject:SetActive(true)
	b[1]:GetComponent('UIWidget').alpha = 1
	b[1]:Find('Pai'):GetComponent('UISprite').spriteName = this.GetCardTextName(value1,cardText);
	b[1].localPosition = Vector3.New(-150, 0, 0)

	b[2]:GetComponent('UIWidget').alpha = 1
	b[2]:Find('Pai'):GetComponent('UISprite').spriteName = this.GetCardTextName(value2,cardText);
	b[2].localPosition = Vector3.New(150, 0, 0)
	
	coroutine.wait(lifetime)
	b[1].gameObject:SetActive(false)
	b[2].gameObject:SetActive(false)
end

function this.OnPlayerHuPai(b)
	local index = this.GetUIIndexBySeat(b.seat);
	local p = this.GetPlayerDataBySeat(b.seat)
	if b.outSeat == b.seat then  --自摸
		if RoundDetail.setting.roomType == proxy_pb.CSM then
			AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(p.sex==1 and 'man_' or 'woman_')..'zimo')
		else
			AudioManager.Instance:PlayAudio((p.sex==1 and 'man_' or 'woman_').."zimo")
		end
		effManger.ShowEffect(gameObject, 'zm', playerHupaiPos[this.GetUIIndex(this.GetUIIndexBySeat(b.seat),playerSize)])
	else
		if RoundDetail.setting.roomType == proxy_pb.CSM then
			AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(p.sex==1 and 'man_' or 'woman_')..'hu')
		else
			AudioManager.Instance:PlayAudio((p.sex==1 and 'man_' or 'woman_').."hu")
		end
		effManger.ShowEffect(gameObject, 'hu', playerHupaiPos[this.GetUIIndex(this.GetUIIndexBySeat(b.seat),playerSize)]);
	end
	--this.RefreshCurMoPai(index, b.mahjong, true);
	this.RefreshGridHandByIndex(this.GetUIIndex(index,playerSize),this.GetUIIndex(index,playerSize),p.mahjongs, #p.mahjongs, true, -1, tableClone(p.mahjongs));
	this.RefreshAllCurMoPai()

	if b.seat == mySeat then 
		this.PlayerSelectOperation("hu");
	else--不是轮到自己，点过
		this.PlayerSelectOperation("guo");
	end
end

function this.DoRemovePlates(seat, plates, ignoreUI)
	local pData = this.GetPlayerDataBySeat(seat)
	if not pData then
		--print('pData is nil')
		return
	end
	
	local index = this.GetUIIndexBySeat(seat)
	for i=1,#plates do
		local p = plates[i]
		for j=#pData.mahjongs,1,-1 do
			if pData.mahjongs[j] == p then
				pData.mahjongs:remove(j)
				break
			end
		end
	end
	pData.mahjongCount = #pData.mahjongs
	
	if not ignoreUI then
		--print("刷新手牌 ~~",#pData.mahjongs,index)
		this.RefreshGridHandByIndex(index,index, pData.mahjongs, #pData.mahjongs, true, -1, {});
	end
end

function this.SetPlateEffectShow(UItabel, plates, seat)
	if seat == lastOperat.seat and plates[#plates] == lastOperat.plate then
		curOperatPlateEffect.gameObject:SetActive(true)
		curOperatPlateEffect.position = UItabel:GetChild(#plates-1).position
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
	print('OnClickButtonSlow playInterval:'..playInterval)
end

function this.OnClickButtonPause(go)
	AudioManager.Instance:PlayAudio('btn')
    isPause = not isPause
	if isPause then
		ButtonPause:GetComponent('UIButton').normalSprite = 'bofang'
	else
		ButtonPause:GetComponent('UIButton').normalSprite = 'zanting'
	end
	print('isPause:'..tostring(isPause))
end

function this.OnClickButtonFast(go)
	AudioManager.Instance:PlayAudio('btn')

	if playInterval - cutTime >= 0.5 then
		playInterval = playInterval - cutTime
	end
	
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
	print('OnClickButtonFast playInterval:'..playInterval)
end

function this.OnClickButtonBack(go)
	AudioManager.Instance:PlayAudio('btn')
    coroutine.stop(conFun)
    coroutine.stop(conTime)
	
    PanelManager.Instance:ShowWindow(whoShow.name)
	PanelManager.Instance:HideWindow(gameObject.name)
	PanelManager.Instance:HideWindow("panelStageClear_mj");
	PanelManager.Instance:HideWindow("panelStageClearAll_mj");
	PanelManager.Instance:HideWindow("panelSuddenEffect");
	PanelManager.Instance:HideWindow("panelStartHu");
	AudioManager.Instance:PlayMusic('MainBG', true);
end


function this.OnPlayerStartHu(record)

	if RoundDetail.version == 0 then --老版本用旧的起手胡
		for i = 1, #record.huCategories do
			local uiIndex = this.GetUIIndex(this.GetUIIndexBySeat(record.seat),playerSize);
			effManger.ShowCategorieEffect(effectCategories[uiIndex].gameObject, record.huCategories[i], effectCategories[uiIndex].position);
			--print("record.huCategories[i].category:"..record.huCategories[i].category);
		end
		if RoundDetail.setting.roomType == proxy_pb.CSM then
			AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(this.GetPlayerDataBySeat(record.seat).sex==1 and 'man_' or 'woman_')..'qishouhu')
		else
			AudioManager.Instance:PlayAudio((this.GetPlayerDataBySeat(record.seat).sex==1 and 'man_' or 'woman_').."hu")
		end
	elseif RoundDetail.version == 1 then --新版本用新的起手胡
		local find = false;
		for i=1,#record.startHu do
			if record.startHu[i].seat == mySeat then 
				this.PlayerSelectOperation("hu");
				find = true;
			end
		end

		if not find then 
			this.PlayerSelectOperation("guo");
		end
		
		coroutine.wait(0.2);
		local data = {};
		data.roomData = roomData;
		data.startHu = record.startHu;
		--起手胡的时候要暂停一下，播放完起手胡动画再继续播放
		isPause = true;
		data.fuc=function()
			--coroutine.wait(7-playInterval);
			isPause = false;
		end
		PanelManager.Instance:ShowWindow("panelStartHu",data);
		for i = 1, #record.startHu do
			local pData = this.GetPlayerDataBySeat(record.startHu[i].seat);
			if RoundDetail.setting.roomType == proxy_pb.CSM then
				AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(pData.sex==1 and 'man_' or 'woman_')..'qishouhu')
			else
				AudioManager.Instance:PlayAudio((pData.sex==1 and 'man_' or 'woman_').."hu")
			end
		end

		if record.operation and #record.operation > 0  then 
			for i=1,#record.operation do
				if record.operation[i].seat == mySeat then 
					this.RefreshOperationSend(record.operation[i].operation);
				end
			end
		end
	end
end

function this.OnPlayerZhiShaiZi(record)

	local pData = this.GetPlayerDataBySeat(record.seat)
	local index = this.GetUIIndexBySeat(record.seat);
	for i = 1, #record.zhiMahjongs do
		table.insert(pData.paiHe,record.zhiMahjongs[i]);
		--pData.paiHe:append(record.zhiMahjongs[i]);
	end
	this.RefreshTabelThrowByIndex(index,pData.paiHe, pData.seat);

	this.SetDipaiNum(record.surplus)

	--1.获得要出的几个牌的游戏对象
	local effobjs = {};
	--2.获得要出的几个牌的位置
	local fromPos = {};
	local toPos = {};
	for i = 1, #record.zhiMahjongs do
		print("i-------->"..i);
		effobjs[i] = effectGang:GetChild(i-1);
		--设置牌的值
		effobjs[i]:Find("Pai"):GetComponent("UISprite").spriteName = this.GetCardTextName(pData.paiHe[#pData.paiHe - #record.zhiMahjongs + i],cardText);
		fromPos[i] = effectGangPos[i];
		toPos[i] = playerThrow[this.GetUIIndex(index,playerSize)]:GetChild(#pData.paiHe - #record.zhiMahjongs + i -1).position;

	end
	--播放掷色子动画
	effManger.ShowZhiShaiziEffect(fromPos,toPos,effobjs,0.2*playInterval);

	--设置用户操作
	if RoundDetail.version == 1 then 
		if record.operation and #record.operation > 0  then 
			for i=1,#record.operation do
				if record.operation[i].seat == mySeat then 
					this.RefreshOperationSend(record.operation[i].operation);
				end
			end
		end
	end
end



--中途起手胡
function this.OnPlayerZhongtuHu(record)
	local suddenData  = {};
	table.insert(suddenData,{seat = record.seat,categories = {record.huCategorie},plates = this.GenerateZTHuPlates(record)});
	PanelManager.Instance:ShowWindow("panelSuddenEffect",suddenData);

	local pData = this.GetPlayerDataBySeat(record.seat)
	if roomData.roomType == proxy_pb.CSM then
		local str = ''
		if reciveMsg.huCategory == 26 then
			str = 'zhongtusixi'
		elseif reciveMsg.huCategory == 27 then
			str = 'zhongtuliuliushun'
		else
			str = 'hu'
		end
		AudioManager.Instance:PlayAudio((UnityEngine.PlayerPrefs.GetInt('csmplayerSound', 1)==0 and 'csmfy_' or '')..(pData.sex==1 and 'man_' or 'woman_')..str)
	else
		AudioManager.Instance:PlayAudio((pData.sex == 1 and "man_" or "woman_").."hu")
	end
	if RoundDetail.version == 1 then 
		if record.seat == mySeat then 
			this.PlayerSelectOperation("hu");
		else--不是轮到自己，点过
			this.PlayerSelectOperation("guo");
		end
	end
	

end


function this.GenerateZTHuPlates(record)
	local catePrefab = GetCategoryPrefabStr();
	local plates = {};
	if catePrefab[record.huCategorie+1] == "ztsx" then --中途四喜
		for i = 1, 4 do
			table.insert(plates,record.mahjong);
		end
	elseif catePrefab[record.huCategorie +1] == "ztlls" then --中途六六顺
		for i = 1, 3 do
			table.insert(plates,record.mahjong);
		end
		for i = 1, 3 do
			table.insert(plates,record.opMahjong);
		end
	end
	return plates;
end


function this.GetPlayerSize()
	return playerSize;
end


--更具用户选择选择麻将的牌面
function this.GetCardTextName(plateIndex,cardTextIndex)
	--这里需要说明：换牌面只换“万”字，从一万到9万[已废弃]
	--print("plateIndex:"..plateIndex);
	--print("cardTextIndex:"..cardTextIndex);
	return tostring(plateIndex);
end

--根据用户的选择选择牌面大小
function this.GetCardPlateSize(plateIndex,cardTextIndex)
	-- print("plateIndex:"..plateIndex.."|cardTextIndex:"..cardTextIndex);
	if cardTextIndex == 2 then 
		return CONST.cardStandWanScaleWidth[2];
	else
		if plateIndex <=8 then 
			return CONST.cardStandWanScaleWidth[1];
		else
			return CONST.cardStandTongTiaoScaleWidth[1];
		end
	end
end



function this.getAccorColor(color)
	if color == 1 then
		return Color.New(57/255,123/255,174/255);
	else
		return Color.New(52/255,209/255,186/255);
	end
end

function this.getNumColor(color)
	if color == 1 then
		return Color.New(76/255,189/255,197/255);
	else
		return Color.New(205/255,220/255,114/255);
	end
end

function this.SetGameColor(color)
	dipai:Find("frame/roundHead"):GetComponent("UILabel").color = this.getAccorColor(color);
	dipai:Find("frame/roundHead/roundTail"):GetComponent("UILabel").color = this.getAccorColor(color);
	roomRound:GetComponent("UILabel").color = this.getNumColor(color);
	dipai:Find("frame/leftHead"):GetComponent("UILabel").color = this.getAccorColor(color);
	dipai:Find("frame/leftHead/leftTail"):GetComponent("UILabel").color = this.getAccorColor(color);
	dipai:Find('frame/leftCard'):GetComponent('UILabel').color = this.getNumColor(color);
end


--设置游戏背景
function this.ChooseBG(bgIndex)
	print("ChooseBG:"..bgIndex);

	for i = 1,BgColorNum do
		local bg = gameObject.transform:Find('gameBGs/bg'..i);
		if bgIndex == i then
			bg.gameObject:SetActive(true);
		else
			bg.gameObject:SetActive(false);
		end
	end

	this.SetGameColor(bgIndex);
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
		print('pData.fee : '..pData.fee..' pData.id : '..pData.id)
		userData.fee = pData.fee
		PanelManager.Instance:ShowWindow('panelPlayerInfo', userData)
	end
end