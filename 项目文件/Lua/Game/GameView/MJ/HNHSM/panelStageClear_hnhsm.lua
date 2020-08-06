local hnm_pb = require 'hnm_pb'
local proxy_pb = require "proxy_pb"

panelStageClear_hnhsm = {}
local this = panelStageClear_hnhsm

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
local playerGridZuo={}
local playerHuGrid={}
local huCard = {}--胡牌的预制
local handCard = {};
local zuoCard  = {};
local masterIcon = {} --庄家
local fangPaoIcon = {} --点炮
local playerHuIcon = {} --玩家胡标志

-----
local score_Hu = {}
local score_Gang = {}
local score_GangT = {};
local score_xiayu = {};--下鱼
local score_genzhuang = {};--跟庄

-----
local ButtonOK
local ButtonShare
local gameRound;--多少局了
local roomNum;--房间号
local ButtonXiPai;--洗牌按钮

local winSprite;
local loseSprite;
local messSprite;

local winOrloseWord2

local stageRoomInfo -- 房间结束信息
local RoundData;
local RoundAllData;
local cardText;
local bgColor ;
local uiLayer;


--启动事件--
function this.Awake(obj)
	gameObject = obj;

    ButtonOK = gameObject.transform:Find('Group/ButtonOK')
	ButtonShare = gameObject.transform:Find('Group/ButtonShare')
	ButtonXiPai = gameObject.transform:Find('Group/ButtonXiPai')

	message = gameObject:GetComponent('LuaBehaviour')
    message:AddClick(ButtonOK.gameObject, this.OnClickButtonOK)
	message:AddClick(ButtonShare.gameObject, this.onClickButtonShare)
	message:AddClick(ButtonXiPai.gameObject, this.OnClickButtonXiPai)
	

    for i=1,4 do
		names[i] 			= gameObject.transform:Find('Group/playerGrid/Player'..i..'/HeadImage/Name')
		userids[i] 			= gameObject.transform:Find('Group/playerGrid/Player'..i..'/HeadImage/ID')
        scores[i] 			= gameObject.transform:Find('Group/playerGrid/Player'..i..'/Score')
		icons[i] 			= gameObject.transform:Find('Group/playerGrid/Player'..i..'/HeadImage/HeadIcon')

		paiXing[i] 			= gameObject.transform:Find('Group/playerGrid/Player'..i..'/PaixingLabel')
		masterIcon[i] 		= gameObject.transform:Find('Group/playerGrid/Player'..i..'/Zhuang');
		fangPaoIcon[i] 		= gameObject.transform:Find('Group/playerGrid/Player'..i..'/sp_pao');
		playerHuIcon[i] 	= gameObject.transform:Find('Group/playerGrid/Player'..i..'/sp_hu');
		playerGridHand[i] 	= gameObject.transform:Find('Group/playerGrid/Player'..i..'/player_mj/GridHand')
		playerGridZuo[i] 	= gameObject.transform:Find('Group/playerGrid/Player'..i..'/player_mj/GridZuo')
		playerHuGrid[i] 	= gameObject.transform:Find('Group/playerGrid/Player'..i..'/player_mj/GridHu')
		huCard[i] 			= gameObject.transform:Find('Group/playerGrid/Player'..i..'/player_mj/huPai')
		handCard[i] 		= gameObject.transform:Find('Group/playerGrid/Player'..i..'/player_mj/cardHand')
		zuoCard[i] 			= gameObject.transform:Find('Group/playerGrid/Player'..i..'/player_mj/cardZuo')
		

		score_Hu[i] 		= gameObject.transform:Find('Group/playerGrid/Player'..i..'/decScore/LabelT_HuS/Label_HuS');
		score_Gang[i] 		= gameObject.transform:Find('Group/playerGrid/Player'..i..'/decScore/LabelT_GangS/Label_GangS');
		score_GangT[i] 		= gameObject.transform:Find('Group/playerGrid/Player'..i..'/decScore/LabelT_GangS');
		score_xiayu[i] 		= gameObject.transform:Find('Group/playerGrid/Player'..i..'/decScore/LabelT_xiayu/Label_xiayu');
		score_genzhuang[i] 	= gameObject.transform:Find('Group/playerGrid/Player'..i..'/decScore/LabelT_genzhuang/Label_genzhuang')
    end

	
	winSprite 	= gameObject.transform:Find('winIcon');
	loseSprite 	= gameObject.transform:Find('loseIcon');
	messSprite 	= gameObject.transform:Find('messIcon');
	roomNum 	= gameObject.transform:Find('roundInfo/roomNum');
	gameRound 	= gameObject.transform:Find('roundInfo/round');

	
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
	if RoundData.isInGame then 
		uiLayer.HNHSM_Logic.connect.IsZanTing = false;
	end

	this.Refresh();
	this.RefreshMahjons();
	RegisterGameCallBack(hnm_pb.SHUFFLE, this.onGetXiPaiResult)
	this.setButtonsStatus()

end

function this.onGetXiPaiResult(msg)
    local b = hnm_pb.RShuffle()
    b:ParseFromString(msg.body)
    if b.seat== RoundData.mySeat then
        --错误码 83:洗牌成功  84:洗牌失败非疲劳值不足  85:洗牌失败疲劳值不足  86:重复洗牌
        if b.code==83 then
			ButtonXiPai:Find('Label'):GetComponent('UILabel').text='已打骰'
			local msg = Message.New()
			msg.type = hnm_pb.READY
			SendGameMessage(msg, nil)
			this.OnClickButtonOK(ButtonOK.gameObject);
			if RoundData.isInGame then
				uiLayer.HNHSM_Logic.hasStageClear = false;
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
        msg.type = hnm_pb.SHUFFLE
        SendGameMessage(msg, nil)
    end, nil, '打骰会消耗'..stageRoomInfo.roomData.setting.shuffleFee..'疲劳值，是否确认打骰？(确认洗牌后将自动进入下一局)')
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

--单击事件--
function this.OnClickMask(go)
	print("OnClickMask was called--------------->");
    PanelManager.Instance:HideWindow(gameObject.name)
	if RoundData.isInGame then
		uiLayer.HNHSM_Logic.hasStageClear=false
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
		local logic = uiLayer.HNHSM_Logic == nil and uiLayer.HNHSM_RePlayLogic or uiLayer.HNHSM_Logic;
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
		-- score_Gang[i]:GetComponent('UILabel').text 		= player.endGangScore;
		score_xiayu[i]:GetComponent('UILabel').text 	= player.endFloatScore;
		score_genzhuang[i]:GetComponent('UILabel').text = player.endBankerScore;
		-------------
		paiXing[i].gameObject:SetActive(true);
		
		paiXing[i]:GetComponent("UILabel").text = HNHSM_Tools.GetMJWinResult(player.huScore);
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

	winSprite.gameObject:SetActive(false);
	loseSprite.gameObject:SetActive(false);
	messSprite.gameObject:SetActive(false);

	print("huPlayers.length="..#huPlayers);
	if #huPlayers == 0 then --没有赢家，流局
		messSprite.gameObject:SetActive(true);
	else
		if myRes == nil then --有赢家，但不是玩家自己，输了
			loseSprite.gameObject:SetActive(true);
		else
			winSprite.gameObject:SetActive(true);
		end
	end
	
end


function this.CombineHuItems(categories)
    local showHuCategories = {};
	for i = 1, #categories do
		local find = false;
		local findPos = -1;
		for j = 1, #showHuCategories do
			if showHuCategories[j].category == categories[i] then
				find = true;
				findPos = j;
				break;
			end
		end

		if find then
			showHuCategories[findPos].num = showHuCategories[findPos].num + 1;
		else
			table.insert(showHuCategories,{category = categories[i],num = 1});
		end
	end

    return showHuCategories;
end

--展示胡牌的麻将
function this.RefreshMahjons()
	for i=1,#RoundData.data.players do
		local player = RoundData.data.players[i];
		local pData = RoundData.playerData[player.seat];
		local leftCards = { }
		for i=1,#player.chis,3 do
			table.insert(leftCards, {operation = hnm_pb.CHI, plates={player.chis[i], player.chis[i+1], player.chis[i+2]}})
		end
		
		for i=1,#player.pengs do
			table.insert(leftCards, {operation = hnm_pb.PENG, plates={player.pengs[i], player.pengs[i], player.pengs[i]}})
		end
		for i=1,#player.mingGangs do
			table.insert(leftCards, {operation = hnm_pb.GANG, plates={player.mingGangs[i], player.mingGangs[i], player.mingGangs[i], player.mingGangs[i]}, state = hnm_pb.MING})
		end
		for i=1,#player.anGangs do
			table.insert(leftCards, {operation = hnm_pb.GANG, plates={player.anGangs[i], player.anGangs[i], player.anGangs[i], player.anGangs[i]}, state = hnm_pb.AN})
		end
		for i=1,#player.dianGangs do
			table.insert(leftCards, {operation = hnm_pb.DIAN, plates={player.dianGangs[i], player.dianGangs[i], player.dianGangs[i], player.dianGangs[i]}, state = hnm_pb.DIAN})
		end
		
		--吃碰杠等牌
		for j=playerGridZuo[i].childCount,#leftCards-1 do
			local obj = NGUITools.AddChild(playerGridZuo[i].gameObject, zuoCard[i].gameObject);
		end
		for ii=0,playerGridZuo[i].childCount-1 do
			if ii < #leftCards then
				local group = leftCards[ii+1]
				local item = playerGridZuo[i]:GetChild(ii)
				for j=0,item.childCount-1 do
					if j < #group.plates then
						local show = true
						if j < 3  then
							if group.state == hnm_pb.AN then
								show = false
							end
						else
							if group.state == hnm_pb.MING then
								show = false;
							end
						end
						if not show then
							item:GetChild(j):GetComponent('UISprite').spriteName = uiLayer:getColorCardName('mj_04',uiLayer:getCardColor());
							item:GetChild(j):GetChild(0).gameObject:SetActive(false)
						else
							item:GetChild(j):GetComponent('UISprite').spriteName =uiLayer:getColorCardName('mj_01',uiLayer:getCardColor());
							item:GetChild(j):GetChild(0):GetComponent('UISprite').spriteName = uiLayer:GetCardTextName(group.plates[j+1],uiLayer:getcardText());
							item:GetChild(j):GetChild(0).gameObject:SetActive(true)
						end
						
						item:GetChild(j).gameObject:SetActive(true)
					else
						item:GetChild(j).gameObject:SetActive(false)
					end
				end
				item.gameObject:SetActive(true)
			else
				playerGridZuo[i]:GetChild(ii).gameObject:SetActive(false)
			end
		end

		playerGridZuo[i]:GetComponent('UIGrid'):Reposition();

		--设置位置关系
		local pos = playerGridHand[i].localPosition
		local gridcellWidth = playerGridZuo[i]:GetComponent('UIGrid').cellWidth;
		local gridcellHeight = playerGridZuo[i]:GetComponent('UIGrid').cellHeight;
		if #leftCards > 0 then
			pos.x = playerGridZuo[i].localPosition.x +  gridcellWidth* #leftCards -60;
		else
			pos.x = playerGridZuo[i].localPosition.x-60;
		end

		playerGridHand[i].localPosition = pos;
		
		--设置手牌
		local player = RoundData.data.players[i];
		print("players["..i.."] majongs:"..(#player.mahjongs));
		for j=playerGridHand[i].childCount,#player.mahjongs-1 do

			local obj = NGUITools.AddChild(playerGridHand[i].gameObject, handCard[i].gameObject);
		end
		for j=0,playerGridHand[i].childCount-1 do
			if j < #player.mahjongs then
				local item = playerGridHand[i]:GetChild(j)
				item.gameObject:SetActive(true);
				item:GetComponent("UISprite").spriteName = uiLayer:getColorCardName("mj_01",uiLayer:getCardColor());
				item:Find('card'):GetComponent('UISprite').spriteName = uiLayer:GetCardTextName(player.mahjongs[j+1],uiLayer:getcardText());
				--赖子检测
				if player.mahjongs[j+1] == uiLayer.HongzhongPlateValue then 
					item:Find("mark").gameObject:SetActive(uiLayer.roomData.setting.variableHongZhong);
				else
					item:Find("mark").gameObject:SetActive(false);
				end
			else
				playerGridHand[i]:GetChild(j).gameObject:SetActive(false)
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

			for j = 1, playerHuGrid[i].childCount do
				playerHuGrid[i]:GetChild(j -1).gameObject:SetActive(false);
			end

			for j = 1,#player.huItems do
				local hupai = nil;
				if j > playerHuGrid[i].childCount then
					hupai =  NGUITools.AddChild(playerHuGrid[i].gameObject,huCard[i].gameObject);
				else
					hupai = playerHuGrid[i]:GetChild(j-1).gameObject;
				end
				hupai.gameObject:SetActive(true);
				hupai.transform:GetComponent("UISprite").spriteName = uiLayer:getColorCardName("mj_01",uiLayer:getCardColor());
				hupai.transform:Find("card"):GetComponent('UISprite').spriteName = uiLayer:GetCardTextName(player.huItems[j].huMahjong,uiLayer:getcardText());
				if player.huItems[j].huMahjong == uiLayer.HongzhongPlateValue then 
					hupai.transform:Find("mark").gameObject:SetActive(uiLayer.roomData.setting.variableHongZhong);
				else
					hupai.transform:Find("mark").gameObject:SetActive(false);
				end
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
			PanelManager.Instance:ShowWindow('panelStageClearAll_hnhsm',overData)
		else
			local msg = Message.New()
			msg.type = hnm_pb.READY;
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