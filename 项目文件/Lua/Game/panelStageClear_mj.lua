local csm_pb = require 'csm_pb'
local proxy_pb = require "proxy_pb"

panelStageClear_mj = {}
local this = panelStageClear_mj

local message
local gameObject

local mask
local names={}
local userids = {};
local scores={}
local icons={}
local shouPai={}
local luckyBird={}--中鸟次数
local birds={}
local paiXing={}
local playerGridHand={}
local playerGridZuo={}
local playerGridBird={};
local playerHuGrid={}
local huCard = {}--胡牌的预制
local birdCard = {}--鸟牌的预制
local handCard = {};
local zuoCard  = {};
local masterIcon = {} --庄家
local fangPaoIcon = {} --点炮
local playerHuIcon = {} --玩家胡标志
local scoreRoof = {} --积分封顶标志

-----
local score_Piao = {}
local score_Hu = {}
local score_Gang = {}
local score_GangT = {};
local score_Niao = {}
-----
local ButtonOK
local ButtonShare
local ButtonXiPai
local gameRound;--多少局了
local roomNum;--房间号

local winSprite;
local loseSprite;
local messSprite;

local winOrloseWord2

local stageRoomInfo -- 房间结束信息
local RoundData;
local RoundAllData;
local cardText;

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
		names[i] 			= gameObject.transform:Find('Group/Player'..i..'/HeadImage/Name')
		userids[i] 			= gameObject.transform:Find('Group/Player'..i..'/HeadImage/ID')
		birdCard[i]			= gameObject.transform:Find('Group/Player'..i..'/player_mj/birdPai')
        scores[i] 			= gameObject.transform:Find('Group/Player'..i..'/Score')
		icons[i] 			= gameObject.transform:Find('Group/Player'..i..'/HeadImage/HeadIcon')
		scoreRoof[i] 			= gameObject.transform:Find('Group/Player'..i..'/scoreRoof')
		luckyBird[i] 		= gameObject.transform:Find('Group/Player'..i..'/luckyBird');

		paiXing[i] 			= gameObject.transform:Find('Group/Player'..i..'/PaixingLabel')
		masterIcon[i] 		= gameObject.transform:Find('Group/Player'..i..'/Zhuang');
		fangPaoIcon[i] 		= gameObject.transform:Find('Group/Player'..i..'/sp_pao');
		playerHuIcon[i] 	= gameObject.transform:Find('Group/Player'..i..'/sp_hu');
		playerGridHand[i] 	= gameObject.transform:Find('Group/Player'..i..'/player_mj/GridHand')
		playerGridZuo[i] 	= gameObject.transform:Find('Group/Player'..i..'/player_mj/GridZuo')
		playerHuGrid[i] 		= gameObject.transform:Find('Group/Player'..i..'/player_mj/GridHu')
		huCard[i] 			= gameObject.transform:Find('Group/Player'..i..'/player_mj/huPai')
		handCard[i] 			= gameObject.transform:Find('Group/Player'..i..'/player_mj/cardHand')
		zuoCard[i] 			= gameObject.transform:Find('Group/Player'..i..'/player_mj/cardZuo')
		playerGridBird[i] 	= gameObject.transform:Find('Group/Player'..i..'/player_mj/GridBird')
		

		score_Piao[i] = gameObject.transform:Find('Group/Player'..i..'/decScore/Label_FlyS')
		score_Hu[i] = gameObject.transform:Find('Group/Player'..i..'/decScore/Label_HuS')
		score_Gang[i] = gameObject.transform:Find('Group/Player'..i..'/decScore/Label_GangS')
		score_GangT[i] = gameObject.transform:Find('Group/Player'..i..'/decScore/LabelT_GangS')
		score_Niao[i] = gameObject.transform:Find('Group/Player'..i..'/decScore/Label_BridS')
    end

	for i = 1, 8 do
		birds[i] 			= gameObject.transform:Find('bird/grid/brid'..i);
	end
	
	winSprite 	= gameObject.transform:Find('winIcon');
	loseSprite 	= gameObject.transform:Find('loseIcon');
	messSprite 	= gameObject.transform:Find('messIcon');
	roomNum 	= gameObject.transform:Find('roundInfo/roomNum');
	gameRound 	= gameObject.transform:Find('roundInfo/round');

	
end

function this.Start()
end

function this.setButtonsStatus(hideXiPai)
    if hideXiPai==nil and stageRoomInfo.roomData.setting.openShuffle==true and stageRoomInfo.isInGame==true and stageRoomInfo.gameOver==false then
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
        msg.type = csm_pb.SHUFFLE
        SendGameMessage(msg, nil)
    end, nil, '打骰会消耗'..stageRoomInfo.roomData.setting.shuffleFee..'疲劳值，是否确认打骰？(确认洗牌后将自动进入下一局)')
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.onGetXiPaiResult(msg)
    local b = csm_pb.RShuffle()
    b:ParseFromString(msg.body)
    if b.seat==stageRoomInfo.RoundData.mySeat then
        --错误码 83:洗牌成功  84:洗牌失败非疲劳值不足  85:洗牌失败疲劳值不足  86:重复洗牌
        if b.code==83 then
			ButtonXiPai:Find('Label'):GetComponent('UILabel').text='已打骰'
			local msg = Message.New()
			msg.type = csm_pb.READY
			SendGameMessage(msg, nil)
			panelInGamemj.RsetWhenStart()
			panelInGamemj.RsetWhenClickNextRound()
			if stageRoomInfo.isInGame then
				panelInGamemj.hasStageClear=false
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
		panelInGamemj.diceOnePoints=b.diceOnePoints
		panelInGamemj.diceTwoPoints=b.diceTwoPoints
	end
end

function this.OnEnable()

end

function this.Update()

end


function this.WhoShow(data)
	if data.isInGame then
		data.fuc()
	end
	--print("panelStageClear_mj WhoShow was called");
	cardText = UnityEngine.PlayerPrefs.GetInt('cardText_mj', 1);
	RoundData = data.RoundData;
	RoundAllData = data.RoundAllData;
	stageRoomInfo = data;
	roomNum:GetComponent("UILabel").text = data.roomNumber;
	gameRound:GetComponent("UILabel").text = (data.roomData.round-1)..'/'..data.roomData.setting.rounds;

	this.Refresh();
	this.RefreshMahjons();
    RegisterGameCallBack(csm_pb.SHUFFLE, this.onGetXiPaiResult)
    this.setButtonsStatus()

end

--单击事件--
function this.OnClickMask(go)
    PanelManager.Instance:HideWindow(gameObject.name)
	if stageRoomInfo.isInGame then
		panelInGamemj.hasStageClear=false
	end
end

local 	Results = {	"平胡", "大四喜", "六六顺", "板板胡", "缺一色", "天胡", "地胡", "碰碰胡", "将将胡", "清一色", "小七对", "豪华小七对", "双豪华小七对", "三豪华小七对", "杠上开花", "抢杠胡", "海底捞月", "全求人", "点杠胡", "杠上炮","节节高","一枝花","三同","金童玉女","海底炮","中途四喜","中途六六顺","门清" }


function this.Refresh()
	--print(#RoundData.data.players)
	local liu = RoundData.data.wasteland;
	local myRes = nil

	--先隐藏全部
	for i=1,4 do
		scores[i].parent.gameObject:SetActive(false);
	end

	local birdsSeat = RoundData.data.birds;
	local myLockbirds = {} --我中的鸟

	for i=1,#RoundData.data.players do
		scores[i].parent.gameObject:SetActive(true);
		local player = RoundData.data.players[i];
		if player.seat == RoundData.mySeat then
			myRes = player;
		end
		local pData = panelInGame.GetPlayerDataBySeat(player.seat)
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
		luckyBird[i].gameObject:SetActive(false);
		playerGridBird[i].gameObject:SetActive(false);

		-------------
		score_Piao[i]:GetComponent('UILabel').text = player.endFloatScore;
		score_Hu[i]:GetComponent('UILabel').text = player.endBaseScore;
		score_Gang[i]:GetComponent('UILabel').text = player.endGangScore;
		score_Niao[i]:GetComponent('UILabel').text = player.endBirdScore;
		-------------

		--长沙麻将没有杠分，其他的有
		if stageRoomInfo.roomData.setting.roomTypeValue == proxy_pb.CSM then
			score_Gang[i].gameObject:SetActive(false);
			score_GangT[i].gameObject:SetActive(false);
		else
			score_Gang[i].gameObject:SetActive(true);
			score_GangT[i].gameObject:SetActive(true);
		end


		for secdex = 1, #birdsSeat do
			if birdsSeat[secdex] then
				if player.seat == birdsSeat[secdex].seat and player.seat == RoundData.mySeat then
					for k=1,#birdsSeat[secdex].mahjongs do
						table.insert(myLockbirds, birdsSeat[secdex].mahjongs[k])
					end

				end
			end

		end

		StartCoroutine(function ()
			WaitForEndOfFrame();
			playerGridBird[i]:GetComponent('UIGrid'):Reposition();
		end);

		paiXing[i].gameObject:SetActive(true);--这里要显示，因为起手胡不管是输赢都要显示



        --大胡
		local totalHuCategorys = {};
		for k = 1, #player.huItems do
			print("huitem:"..k);
            tableMerge(totalHuCategorys,player.huItems[k].huCategorys);
		end

        --起手胡
		-- print("player ["..i.."],startHuItems.length:"..#player.startHuItems);
        -- for k = 1, #player.startHuItems do
        --     table.insert(totalHuCategorys,player.startHuItems[k]);
        -- end

        local showHuCategorys = this.CombineHuItems(totalHuCategorys);

		--只有长沙麻将有牌型
		paiXing[i]:GetComponent("UILabel").text = GetMJWinResult(showHuCategorys,stageRoomInfo.roomData.setting);
		--paiXing[i].gameObject:SetActive(false);


		local text = ''
		for j=1, #player.huItems do
			for huCategory=1, #player.huItems[j].huCategorys do
				text = text .. Results[huCategory+1] .. " "
			end

		end


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
	
	--设置左下角的鸟牌
	for i=1,8 do
		print("set bird disactive:"..i);
		birds[i].gameObject:SetActive(false);
	end

	for i=1,#RoundData.data.birdMahjongs do
		birds[i].gameObject:SetActive(true);
		birds[i]:GetComponent("UISprite").spriteName = panelInGame.getColorCardName("mj_01",stageRoomInfo.cardColor);
		birds[i]:Find('card'):GetComponent('UISprite').spriteName = panelInGame.GetCardTextName(RoundData.data.birdMahjongs[i],cardText);
		local bShow = false;
		for k = 1, #myLockbirds do
			if RoundData.data.birdMahjongs[i] == myLockbirds[k] then 
				bShow = true;
				table.remove(myLockbirds, k)
				break;
			end
		end
		if bShow then --颜色显示
			birds[i]:GetComponent("UISprite").color = Color(255/255,222/255,84/255);
		else 
			birds[i]:GetComponent("UISprite").color = Color(255/255,255/255,255/255);
		end
	end

	winSprite.gameObject:SetActive(false);
	loseSprite.gameObject:SetActive(false);
	messSprite.gameObject:SetActive(false);
	
	if myRes then 
		
		if myRes.win == 0 then
			if liu then
				messSprite.gameObject:SetActive(true);
			else
				-- sp = 'igic025'
			end
			--AudioManager.Instance:PlayAudio('audio_liuju')
		elseif myRes.win > 0 then

			--AudioManager.Instance:PlayAudio('audio_win')
			winSprite.gameObject:SetActive(true);
		else
			-- sp = 'igic026'
			loseSprite.gameObject:SetActive(true);
			--AudioManager.Instance:PlayAudio('audio_lost')
		end
		-- winOrlose:GetComponent('UISprite').spriteName = sp
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
		local pData = panelInGame.GetPlayerDataBySeat(player.seat)
		local leftCards = { }
		for i=1,#player.chis,3 do
			table.insert(leftCards, {operation = csm_pb.CHI, plates={player.chis[i], player.chis[i+1], player.chis[i+2]}})
		end
		
		for i=1,#player.pengs do
			table.insert(leftCards, {operation = csm_pb.PENG, plates={player.pengs[i], player.pengs[i], player.pengs[i]}})
		end
		for i=1,#player.mingGangs do
			table.insert(leftCards, {operation = csm_pb.GANG, plates={player.mingGangs[i], player.mingGangs[i], player.mingGangs[i], player.mingGangs[i]}, state = csm_pb.MING})
		end
		for i=1,#player.anGangs do
			table.insert(leftCards, {operation = csm_pb.GANG, plates={player.anGangs[i], player.anGangs[i], player.anGangs[i], player.anGangs[i]}, state = csm_pb.AN})
		end
		for i=1,#player.dianGangs do
			table.insert(leftCards, {operation = csm_pb.DIAN, plates={player.dianGangs[i], player.dianGangs[i], player.dianGangs[i], player.dianGangs[i]}, state = csm_pb.DIAN})
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
							if group.state == csm_pb.AN then
								show = false
							end
						else
							if group.state == csm_pb.MING then
								show = false;
							end
						end
						if not show then
							item:GetChild(j):GetComponent('UISprite').spriteName = panelInGame.getColorCardName('mj_04',stageRoomInfo.cardColor);
							item:GetChild(j):GetChild(0).gameObject:SetActive(false)
						else
							item:GetChild(j):GetComponent('UISprite').spriteName =panelInGame.getColorCardName('mj_01',stageRoomInfo.cardColor);
							item:GetChild(j):GetChild(0):GetComponent('UISprite').spriteName = panelInGame.GetCardTextName(group.plates[j+1],cardText);
							item:GetChild(j):GetChild(0).gameObject:SetActive(true)
						end
						
						item:GetChild(j).gameObject:SetActive(true)
					else
						item:GetChild(j).gameObject:SetActive(false)
					end
				end

				local gangStr = ""
				if group.state == csm_pb.MING then 
					gangStr = "点杠"
				elseif group.state == csm_pb.AN then 
					gangStr = "暗杠"
				elseif group.state == csm_pb.DIAN then 
					gangStr = "明杠"
				end
				--print("item.childCount  ",item.childCount);
				if(item.childCount>3 and item:GetChild(3).childCount>1)then
					--print("item.childCount  ",item:GetChild(3).childCount);
					local gangLabel = item:GetChild(3):GetChild(1):GetComponent('UILabel');
					gangLabel.text = gangStr;
					--目前不需要，先隐藏
					if stageRoomInfo.roomData.setting.roomTypeValue == proxy_pb.CSM then
						gangLabel.gameObject:SetActive(false);
					else
						gangLabel.gameObject:SetActive(true);
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
				item:GetComponent("UISprite").spriteName = panelInGame.getColorCardName("mj_01",stageRoomInfo.cardColor);
				item:Find('card'):GetComponent('UISprite').spriteName = panelInGame.GetCardTextName(player.mahjongs[j+1],cardText);
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
				hupai.transform:GetComponent("UISprite").spriteName = panelInGame.getColorCardName("mj_01",stageRoomInfo.cardColor);
				hupai.transform:Find("card"):GetComponent('UISprite').spriteName = panelInGame.GetCardTextName(player.huItems[j].huMahjong,cardText);
			end
			playerHuGrid[i]:GetComponent("UIGrid"):Reposition();
			
		end

		playerHuGrid[i]:GetComponent("UIGrid"):Reposition();

		--设置中鸟grid的位置
		-- if #player.huItems > 0 then 
		-- 	local pos = playerHuGrid[i].localPosition;
		-- 	local huCellWidth = playerHuGrid[i]:GetComponent("UIGrid").cellWidth;
		-- 	playerGridBird[i].localPosition = Vector3.New(pos.x + huCellWidth*(#player.huItems)+25,pos.y,pos.z);
		-- end
		
	end
end

function this.OnClickButtonOK(go)
	AudioManager.Instance:PlayAudio('btn')
	if stageRoomInfo.isInGame then
		if RoundData.over and RoundAllData.over then
			local overData = {};
			overData.RoundAllData = RoundAllData;
			overData.roomInfo = roomInfo;
			PanelManager.Instance:ShowWindow('panelStageClearAll_mj',overData)
		else
			local msg = Message.New()
			msg.type = csm_pb.READY
			SendGameMessage(msg, nil)
		end
		panelInGamemj.RsetWhenStart()
		panelInGamemj.RsetWhenClickNextRound()
	end 
	this.OnClickMask(go)
end

function this.onClickButtonShare(go)
	if not stageRoomInfo.isInGame then
		return
	end
	local data = {}
    data.showName = 'JieTuShare'
    PanelManager.Instance:ShowWindow('panelShared', data)
end