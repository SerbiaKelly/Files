panelStageClear_xplp = {}
local this = panelStageClear_xplp

local message
local gameObject

local mask
local names={}
local userids = {};
local scores={}
local icons={}
local shouPai={}
local paiXing={}
local playerGridHand={}
local playerGridXi={}
local playerHuGrid={}
local huItem = {}--胡牌的预制
local handItem = {};
local xiItem  = {};
local masterIcon = {} --庄家
local fangPaoIcon = {} --点炮
local playerHuIcon = {} --玩家胡标志
local playerGuChou = {};
local playerChong = {};

-----
local score_Hu = {}
local score_Chong = {}
local score_ChongT = {};


-----
local ButtonOK
local ButtonShare
local ButtonXiPai;
local gameRound;--多少局了
local roomNum;--房间号

local winOrloseWord2

local stageRoomInfo -- 房间结束信息
local RoundData;
local RoundAllData;
local cardText;
local bgColor ;
local uiLayer;


--启动事件--
function this.Awake(obj)
	gameObject 	= obj;
    ButtonOK 	= gameObject.transform:Find('ButtonOK')
	ButtonShare = gameObject.transform:Find('ButtonShare')
	ButtonXiPai = gameObject.transform:Find('ButtonXiPai')
	message 	= gameObject:GetComponent('LuaBehaviour')


	roomNum 	= gameObject.transform:Find('roundInfo/roomNum');
	gameRound 	= gameObject.transform:Find('roundInfo/round');

	print("roomNum:"..tostring(roomNum));
	print("gameRound:"..tostring(gameRound));

    message:AddClick(ButtonOK.gameObject, this.OnClickButtonOK)
	message:AddClick(ButtonShare.gameObject, this.onClickButtonShare)
	message:AddClick(ButtonXiPai.gameObject, this.OnClickButtonXiPai)

    for i=1,4 do
		names[i] 			= gameObject.transform:Find('playerScrollView/playerGrid/Player'..i..'/HeadImage/Name')
		userids[i] 			= gameObject.transform:Find('playerScrollView/playerGrid/Player'..i..'/HeadImage/ID')
		scores[i] 			= gameObject.transform:Find('playerScrollView/playerGrid/Player'..i..'/Score');
		icons[i] 			= gameObject.transform:Find('playerScrollView/playerGrid/Player'..i..'/HeadImage/HeadIcon')
		paiXing[i] 			= gameObject.transform:Find('playerScrollView/playerGrid/Player'..i..'/PaixingLabel')
		masterIcon[i] 		= gameObject.transform:Find('playerScrollView/playerGrid/Player'..i..'/Zhuang');
		fangPaoIcon[i] 		= gameObject.transform:Find('playerScrollView/playerGrid/Player'..i..'/sp_pao');
		playerHuIcon[i] 	= gameObject.transform:Find('playerScrollView/playerGrid/Player'..i..'/sp_hu');
		playerGuChou[i] 	= gameObject.transform:Find('playerScrollView/playerGrid/Player'..i..'/sp_guChou');
		playerChong[i] 		= gameObject.transform:Find('playerScrollView/playerGrid/Player'..i..'/chong/Label');
		playerGridHand[i] 	= gameObject.transform:Find('playerScrollView/playerGrid/Player'..i..'/player_mj/GridHand')
		playerGridXi[i] 	= gameObject.transform:Find('playerScrollView/playerGrid/Player'..i..'/player_mj/GridXi')
		playerHuGrid[i] 	= gameObject.transform:Find('playerScrollView/playerGrid/Player'..i..'/player_mj/GridHu')
		huItem[i] 			= gameObject.transform:Find('playerScrollView/playerGrid/Player'..i..'/player_mj/huItem')
		handItem[i] 		= gameObject.transform:Find('playerScrollView/playerGrid/Player'..i..'/player_mj/handItem')
		xiItem[i] 			= gameObject.transform:Find('playerScrollView/playerGrid/Player'..i..'/player_mj/xiItem')
		score_Hu[i] 		= gameObject.transform:Find('playerScrollView/playerGrid/Player'..i..'/decScore/LabelT_HuS/Label_HuS');
		score_Chong[i] 		= gameObject.transform:Find('playerScrollView/playerGrid/Player'..i..'/decScore/LabelT_chong/Label_chong');
		score_ChongT[i] 	= gameObject.transform:Find('playerScrollView/playerGrid/Player'..i..'/decScore/LabelT_chong');
	
    end

	


	
end

function this.Start()
end

function this.OnEnable()

end

function this.Update()

end

function this.OnApplicationFocus()
	
end


function this.WhoShow(data)
	--print("panelStageClear_mj WhoShow was called");
	RoundData 		= data.RoundData;
	RoundAllData 	= data.RoundAllData;
	stageRoomInfo 	= data;
	uiLayer  		= data.uiLayer
	roomNum:GetComponent("UILabel").text = data.roomNumber;
	gameRound:GetComponent("UILabel").text = (data.roomData.round-1)..'/'..data.roomData.setting.rounds;
	RegisterGameCallBack(xplp_pb.SHUFFLE, this.onGetXiPaiResult)
	this.Refresh();
	this.RefreshMahjons();
	this.setButtonsStatus()

end

function this.onGetXiPaiResult(msg)
    local b = xplp_pb.RShuffle()
    b:ParseFromString(msg.body)
    if b.seat== RoundData.mySeat then
        --错误码 83:洗牌成功  84:洗牌失败非疲劳值不足  85:洗牌失败疲劳值不足  86:重复洗牌
        if b.code==83 then
			ButtonXiPai:Find('Label'):GetComponent('UILabel').text='已打骰'
			local msg = Message.New()
			msg.type = xplp_pb.READY
			SendGameMessage(msg, nil)
			this.OnClickButtonOK(ButtonOK.gameObject);
			if RoundData.isInGame then
				uiLayer.XPLP_Logic.hasStageClear = false;
			end
			PanelManager.Instance:HideWindow(gameObject.name)
        elseif  b.code==84 then
            ButtonXiPai:GetComponent('UIButton').isEnabled=true
            panelMessageBox.SetParamers(ONLY_OK, nil, nil, '暂时不能打骰')
            PanelManager.Instance:ShowWindow('panelMessageBox')
        elseif  b.code==85 then
            ButtonXiPai:GetComponent('UIButton').isEnabled=true
            panelMessageBox.SetParamers(ONLY_OK, nil, nil, '疲劳值不足')
            PanelManager.Instance:ShowWindow('panelMessageBox')
        elseif  b.code==86 then
            ButtonXiPai:GetComponent('UIButton').isEnabled=true
            panelMessageBox.SetParamers(ONLY_OK, nil, nil, '请勿重复点击')
            PanelManager.Instance:ShowWindow('panelMessageBox')
        else
            ButtonXiPai:GetComponent('UIButton').isEnabled=true
            panelMessageBox.SetParamers(ONLY_OK, nil, nil, '打骰未知错误')
            PanelManager.Instance:ShowWindow('panelMessageBox')
        end
    end
    if panelInGame.needXiPai==false and b.code==83 then
		panelInGame.needXiPai=true
	end
	if b.diceOnePoints then
		diceOnePoints=b.diceOnePoints
		diceTwoPoints=b.diceTwoPoints
	end
end

function this.setButtonsStatus(hideXiPai)
	print("hideXiPai="..tostring(hideXiPai).."|stageRoomInfo.roomData.setting.openShuffle="..tostring(stageRoomInfo.roomData.setting.openShuffle).."|RoundData.isInGame="..tostring(RoundData.isInGame).."|RoundData.data.gameOver="..tostring(RoundData.data.gameOver));
    if hideXiPai==nil and stageRoomInfo.roomData.setting.openShuffle==true and RoundData.isInGame==true and RoundData.data.gameOver==false then
        ButtonXiPai.gameObject:SetActive(true)
        ButtonXiPai:Find('Label'):GetComponent('UILabel').text='打骰'
        ButtonXiPai:GetComponent('UIButton').isEnabled=true
    else
        ButtonXiPai.gameObject:SetActive(false)
    end
end

function this.OnClickButtonXiPai(go)
    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
        ButtonXiPai:GetComponent('UIButton').isEnabled=false
        AudioManager.Instance:PlayAudio('btn')
        local msg = Message.New()
        msg.type = xplp_pb.SHUFFLE;
        SendGameMessage(msg, nil)
    end, nil, '打骰会消耗'..stageRoomInfo.roomData.setting.shuffleFee..'疲劳值，是否确认打骰？(确认洗牌后将自动进入下一局)')
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

--单击事件--
function this.OnClickMask(go)
	print("OnClickMask was called--------------->");
    PanelManager.Instance:HideWindow(gameObject.name)
	if RoundData.isInGame then
		uiLayer.XPLP_Logic.hasStageClear=false
		print("OnClickMask.stageRoomInfo.isInGame------------------>");
	end
end

function this.Refresh()
	--print(#RoundData.data.players)
	local liu = RoundData.data.wasteland;
	local myRes = nil
	local huPlayers = {};

	--先隐藏全部
	for i=1,4 do
		scores[i].parent.gameObject:SetActive(false);
	end


	for i=1,#RoundData.data.players do
		scores[i].parent.gameObject:SetActive(true);
		local player = RoundData.data.players[i];
		print("player.win="..tostring(player.win));
		print("player.huItems="..tostring(#player.huItems));
		local logic = uiLayer.XPLP_Logic == nil and uiLayer.XPLP_RePlayLogic or uiLayer.XPLP_Logic;
		if #player.huItems > 0 then
			table.insert( huPlayers, player);
			if player.seat == logic.mySeat then 
				myRes = player;
			end
		end
		local pData = RoundData.playerData[player.seat];
		--print('player seat:'..player.seat)
		names[i]:GetComponent('UILabel').text = pData.name;
		--获取分数要进行颜色判断
		scores[i]:GetComponent('UILabel').text = player.win..'';
		--设置胡牌的玩家
		playerHuIcon[i].gameObject:SetActive((#player.huItems) > 0);
		--设置封顶标志 暂时去除封顶
		--scoreRoof[i].gameObject:SetActive(player.win > 0);
		if player.win >=0 then
			scores[i]:GetComponent('UILabel').text = '+'..player.win;

			scores[i]:GetComponent('UILabel').color = Color(208/255,42/255,54/255);
		else
			scores[i]:GetComponent('UILabel').color = Color(6/255,68/255,176/255);
		end
		userids[i]:GetComponent('UILabel').text = pData.id..'';
		coroutine.start(LoadPlayerIcon, icons[i]:GetComponent('UITexture'), pData.icon)

		--Color(255/255,222/255,84/255);  Color(255/255,255/255,255/255);
		--设置玩家中的鸟牌
		-------------
		score_Hu[i]:GetComponent('UILabel').text 		= player.endBaseScore;
		score_Chong[i]:GetComponent('UILabel').text 	= player.endFloatScore;
		playerChong[i]:GetComponent("UILabel").text 	= "冲"..player.chongScore;

		playerGuChou[i].gameObject:SetActive(player.guChou);
		
		-------------
		paiXing[i].gameObject:SetActive(false);
		-- print("player.huScore is nil:"..tostring(player.huScore == nil));
		-- print("player.huScore.length:"..#player.huScore);
		--设置庄家
		masterIcon[i].gameObject:SetActive(player.seat == RoundData.data.bankerSeat);
		--设置放炮
		if RoundData.data.wasteland then
			fangPaoIcon[i].gameObject:SetActive(false);
		else
			fangPaoIcon[i].gameObject:SetActive(player.seat == RoundData.data.seat);
		end
		--UnityEngine.Color

		
	end


	
end


--展示胡牌的麻将
function this.RefreshMahjons()
	for i=1,#RoundData.data.players do
		local player = RoundData.data.players[i];
		local pData = RoundData.playerData[player.seat];
		local leftCards = { }
		for firdex=1,#player.chis,3 do
			table.insert(leftCards, {operation = xplp_pb.CHI, plates={player.chis[firdex], player.chis[firdex+1], player.chis[firdex+2]}})
		end
		
		for firdex=1,#player.pengs do
			table.insert(leftCards, {operation = xplp_pb.PENG, plates={player.pengs[firdex], player.pengs[firdex], player.pengs[firdex]}})
		end
		
		--吃碰等牌
		for j=playerGridXi[i].childCount,#leftCards-1 do
			local obj = NGUITools.AddChild(playerGridXi[i].gameObject, xiItem[i].gameObject);
		end

		--先隐藏
		for firdex = 0,playerGridXi[i].childCount-1 do 
			playerGridXi[i]:GetChild(firdex).gameObject:SetActive(false);
		end

		for firdex=1,#leftCards do
			local cardItem = playerGridXi[i]:GetChild(firdex-1);
			for secdex=1,#leftCards[firdex].plates do
				cardItem:Find("card"..secdex):Find("card"):GetComponent("UISprite").spriteName = tostring(leftCards[firdex].plates[secdex]);
			end
			cardItem.gameObject:SetActive(true);
		end

		playerGridXi[i]:GetComponent('UIGrid'):Reposition();

		--设置位置关系
		local pos = playerGridHand[i].localPosition
		local gridcellWidth = playerGridXi[i]:GetComponent('UIGrid').cellWidth;
		local gridcellHeight = playerGridXi[i]:GetComponent('UIGrid').cellHeight;
		if #leftCards > 0 then
			pos.x = playerGridXi[i].localPosition.x +  gridcellWidth* #leftCards -60;
		else
			pos.x = playerGridXi[i].localPosition.x-52.71;
		end

		playerGridHand[i].localPosition = pos;
		
		--设置手牌
		print("players["..i.."] majongs:"..(#player.mahjongs));
		for firdex=playerGridHand[i].childCount,#player.mahjongs-1 do
			local obj = NGUITools.AddChild(playerGridHand[i].gameObject, handItem[i].gameObject);
		end
		for firdex=0,playerGridHand[i].childCount-1 do
			if firdex < #player.mahjongs then
				local item = playerGridHand[i]:GetChild(firdex);
				item.gameObject:SetActive(true);
				item:Find('card'):GetComponent('UISprite').spriteName = uiLayer:GetCardTextName(player.mahjongs[firdex+1],uiLayer:getcardText());
			else
				playerGridHand[i]:GetChild(firdex).gameObject:SetActive(false);
			end
		end
		playerGridHand[i]:GetComponent('UIGrid').repositionNow = true;

		--设置胡牌
		playerHuGrid[i].gameObject:SetActive(#player.huItems > 0);
		local pos = playerGridHand[i].localPosition;
		local cellWidth = playerGridHand[i]:GetComponent('UIGrid').cellWidth;
		playerHuGrid[i].localPosition = Vector3.New(pos.x + cellWidth*(#player.mahjongs)+30, pos.y, pos.z)
		if #player.huItems > 0 then
			print("player "..i.."has huItems.length:"..(#player.huItems));
			for firdex = 1, playerHuGrid[i].childCount do
				playerHuGrid[i]:GetChild(firdex -1).gameObject:SetActive(false);
			end
			
			for firdex = 1,#player.huItems do
				local hupai = nil;
				if firdex > playerHuGrid[i].childCount then
					hupai =  NGUITools.AddChild(playerHuGrid[i].gameObject,huItem[i].gameObject);
				else
					hupai = playerHuGrid[i]:GetChild(firdex-1).gameObject;
				end
				hupai.gameObject:SetActive(true);
				hupai.transform:Find("card"):GetComponent('UISprite').spriteName = uiLayer:GetCardTextName(player.huItems[firdex].huMahjong,uiLayer:getcardText());
				hupai.transform:Find("huTip").gameObject:SetActive(true);
			end
			playerHuGrid[i]:GetComponent("UIGrid"):Reposition();
			
		end

		playerHuGrid[i]:GetComponent("UIGrid"):Reposition();

	end
end

function this.OnClickButtonOK(go)
	AudioManager.Instance:PlayAudio('btn')
	-- print("OnClickButtonOK was called---------->stageRoomInfo.isInGame:"..tostring(stageRoomInfo.isInGame));
	if RoundData.isInGame then
		print("RoundData.over:"..tostring(RoundData.over)..",RoundAllData.over:"..tostring(RoundAllData.over));
		if RoundData.over and RoundAllData.over then
			local overData = {};
			overData.RoundAllData = RoundAllData;
			overData.roomInfo = roomInfo;
			PanelManager.Instance:ShowWindow('panelStageClearAll_xplp',overData)
		else
			local msg = Message.New()
			msg.type = xplp_pb.READY;
			SendGameMessage(msg, nil)
			print("send read to server");
			uiLayer:InitUILayer(uiLayer.roomData);
		end
	end 
	this.OnClickMask(go)
	print("path----------->1");
	if uiLayer.TrusteeshipFsmMachine ~= nil then 
		uiLayer.TrusteeshipFsmMachine:Switch(uiLayer:GetTrusteeShipStates().TrusteeShipEnd);
	end
end

function this.onClickButtonShare(go)
	if not RoundData.isInGame then
		return
	end
	local data = {}
    data.showName = 'JieTuShare'
    PanelManager.Instance:ShowWindow('panelShared', data)
end