require("GameLogic");
require("HNHSM_RePlayUILayer");
require("FsmMachine");
local json          = require("json");
local hnm_pb        = nil;
HNHSM_RePlayLogic   = {};
HNHSM_RePlayLogic   = class(GameLogic);
local this          = nil;
local message       = nil;
local c_MaxSize     = 4;--最大人数
local playerSize    = c_MaxSize;--当前游戏人数
local replayUILayer = nil;


function HNHSM_RePlayLogic:ctor(gameView, game_pb, gameType, obj)
    this            = self;
    hnm_pb          = game_pb;
    replayUILayer   = HNHSM_RePlayUILayer.New(obj,this,hnm_pb);
end



function HNHSM_RePlayLogic:GetUILayer()
    return replayUILayer;
end
function HNHSM_RePlayLogic:GetMaxPlayerSize()
    return c_MaxSize;
end

--通过游戏中的参与人数，选择恰当位置的UI分配给不同座位上的人，比如两个人时，座位号0，1对应人物头像1，3这两个游戏UI
--三个人时，座位号0，1，2对应人物头像1，2，4这三个游戏UI，四个人时，才会出现座位号跟头像UI一 一 对应的情况，座位号0，1，2，3对应人物头像1，2，3，4
function HNHSM_RePlayLogic:GetCorrectUIIndex(index)
    -- print("self.totalSize:"..self.totalSize);
    if self.totalSize == 2 then 
        if index == 2 then 
            return 3;
        else
            return index;
        end
    elseif self.totalSize == 3 then 
        if index == 3 then 
            return 4;
        else
            return index;
        end
    else
        return index;
    end
end

function HNHSM_RePlayLogic:GetPlayerViewBySeat(seat)
    local realIndex = self:GetCorrectUIIndex(self:GetPlayerViewIndexBySeat(seat));
    return self.playerViews[realIndex];
end


--玩家摸牌
function HNHSM_RePlayLogic:OnPlayerMoPai(data)
    print("OnPlayerMoPai--------->was called");
    local playerData            = self:GetPlayerDataBySeat(data.seat);
    playerData.moMahjong        = data.mahjong;
    self.roomData.surplus       = self.roomData.surplus -1;
    self.roomData.activeSeat    = data.seat;
    -- print("seat="..data.seat..",after.mahjongCount:"..playerData.mahjongCount);
    replayUILayer:SetPlayerMoPai(data);
end

--玩家出牌
function HNHSM_RePlayLogic:OnPlayerChuPai(data)
    local playerData        = self:GetPlayerDataBySeat(data.seat);
    --如果出的牌不是摸牌，则要把存在的摸牌放到手牌中
    print("data.mahjong:"..data.mahjong..",playerData.moMahjong:"..playerData.moMahjong);
    if playerData.moMahjong ~= -1 then --摸牌的时候出牌
        if data.mahjong ~= playerData.moMahjong then --肯定是打出了手上的牌，把摸牌放到手牌中,并且删掉手上刚刚打出去的牌
            tableRemovePlate(playerData.mahjongs,data.mahjong);
            table.insert( playerData.mahjongs,playerData.moMahjong);
        end
    else--碰别人的牌出牌
        tableRemovePlate(playerData.mahjongs,data.mahjong);
    end
    
    playerData.moMahjong = -1;
    playerData.mahjongCount = #playerData.mahjongs;
    -- print("OnPlayerChuPai,operations.length"..#data.operations);
    table.insert(playerData.paiHe,data.mahjong);
    replayUILayer:SetPlayerChuPai(data);
end

--玩家吃牌
function HNHSM_RePlayLogic:OnPlayerChiPai(data)
    self.roomData.activeSeat = data.seat;
    local playerData = self:GetPlayerDataBySeat(data.seat);
    for i=1,#data.others do
        tableRemovePlate(playerData.mahjongs,data.others[i]);
    end
    playerData.mahjongCount = #playerData.mahjongs;
    table.insert(playerData.operationCards,{operation = hnm_pb.SORT_CHI,cards = {data.others[1],data.mahjong,data.others[2]}});
    --删掉被吃的人打出的被吃的那张牌
    local playerData = self:GetPlayerDataBySeat(data.outSeat);
    tableRemovePlate(playerData.paiHe,data.mahjong);
    replayUILayer:SetPlayerChiPai(data);
end

--玩家碰牌
function HNHSM_RePlayLogic:OnPlayerPengPai(data)
    local playerData            = self:GetPlayerDataBySeat(data.seat);
    self.roomData.activeSeat    = data.seat;
    table.insert( playerData.operationCards, {operation = hnm_pb.SORT_PENG,cards = {data.mahjong}} );
    local pengPlates = {data.mahjong,data.mahjong};
    for i=1,#pengPlates do
        tableRemovePlate(playerData.mahjongs,pengPlates[i]);
    end
    playerData.mahjongCount = #playerData.mahjongs;
    -- print("mymahjongs.length:"..#playerData.mahjongs..",myMahJongCount="..playerData.mahjongCount);
    local outPlayerData = self:GetPlayerDataBySeat(data.outSeat);
    -- print("outPlayerData.paiHe.length"..#outPlayerData.paiHe..",data.mahjong:"..tostring(data.mahjong));
    tableRemovePlate(outPlayerData.paiHe,data.mahjong);
    replayUILayer:SetPlayerPengPai(data);
end

--玩家杠牌
function HNHSM_RePlayLogic:OnPlayerGangPai(data)
    self.roomData.activeSeat    = data.seat;
    local playerData            = self:GetPlayerDataBySeat(data.seat);
    print("OnPlayerGangPai,data.mahjongs.length="..#data.mahjongs);
    
   
    if data.outSeat and (data.gangType == hnm_pb.MING) then --明杠，杠了别人打出的牌
        print("ming gang and remove paiHe--------------------->");
        local outPlayerData = self:GetPlayerDataBySeat(data.outSeat);
        tableRemovePlate(outPlayerData.paiHe,data.mahjong);
    end
    
    --更新喜牌数据
    if data.gangType == hnm_pb.MING then 
        table.insert(playerData.operationCards,{operation = hnm_pb.SORT_MING,cards = {data.mahjong}});
        for i=1,3 do
            tableRemovePlate(playerData.mahjongs,data.mahjong);
        end
    elseif data.gangType == hnm_pb.AN then
        table.insert(playerData.operationCards,{operation = hnm_pb.SORT_DARK,cards = {data.mahjong}});
        for i=1,3 do
            tableRemovePlate(playerData.mahjongs,data.mahjong);
        end
    elseif data.gangType == hnm_pb.DIAN then 
        table.insert(playerData.operationCards,{operation = hnm_pb.SORT_DIAN,cards = {data.mahjong}});
    end
    --如果是杠的碰牌,那么原来的碰的牌就被杠的牌代替了
    for i=1,#playerData.operationCards do
		if playerData.operationCards[i].operation == hnm_pb.SORT_PENG then
			if playerData.operationCards[i].cards[1] == data.mahjong then
				table.remove(playerData.operationCards,i);
				break;
			end
		end
    end
    playerData.mahjongCount = #playerData.mahjongs;
    replayUILayer:SetPlayerGangPai(data);
end

--玩家补牌(呼市麻将没有补的操作)
function HNHSM_RePlayLogic:OnPlayerBuPai(data)
    replayUILayer:SetPlayerBuPai(data);
end

--玩家过牌
function HNHSM_RePlayLogic:OnPlayerGuoPai(data)
    print("OnPlayerGuoPai was called------------->");
    replayUILayer:SetPlayerGuoPai(data);
end

--玩家胡牌
function HNHSM_RePlayLogic:OnPlayerHuPai(data)
    replayUILayer:SetPlayerHuPai(data);
end



function HNHSM_RePlayLogic:AutoRegisterPlayerDatas(playerDatas,resetView)
    self.super.AutoRegisterPlayerDatas(self,playerDatas,resetView);
end



--开局倒计时自动解散的
function HNHSM_RePlayLogic:CheckAutoDissolutionState()

end

function HNHSM_RePlayLogic:OnJoinRoom(data)
    print("OnJoinRoom was called----------------------------->");
    self.roomData           = data;
    self.RoundAllData       = {};
    self.RoundAllData.over  = false;
    self.roomData.surplus   = self:GetInitSurplus(self.roomData);
    print("RemoveAllPlayerData---------------is nil:"..tostring(self.RemoveAllPlayerData == nil));
    print("self == nil:"..tostring(self == nil));
    print("table.self="..tostring(self));
    self:RemoveAllPlayerData();
    self:AutoRegisterPlayerDatas(data.players,true);
    self:SetMySeat(data.mySeat,self.roomData.setting.size);
    self:OnInitView();
    replayUILayer:InitUILayer(self.roomData);
    self:ForeachPlayerDatas(function(playerView,playerData) 
        playerView:SetGameRoomData(self.roomData);
        self.playerViews[self:GetCorrectUIIndex(self:GetPlayerViewIndexBySeat(playerData.seat))]:ResetView(playerData);
    end);

end

function HNHSM_RePlayLogic:GetInitSurplus(roomData)
    if not roomData.setting.takeFeng then 
        roomData.surplus = roomData.surplus + 28;
    elseif roomData.setting.variableHongZhong then
        roomData.surplus = roomData.surplus + 4;
    end
    return roomData.surplus;
end

--玩家加入
function HNHSM_RePlayLogic:OnPlayerJoin(data)
    print("-----------------OnPlayerJoin---------------")
    replayUILayer:RefreshGpsView()
    self:ForeachPlayerDatas(function(playerView,playerData) 
        playerView:SetGameRoomData(self.roomData);
        -- print("index:"..self:GetPlayerViewIndexBySeat(playerData.seat));
        -- print("realIndex:"..self:GetCorrectUIIndex(self:GetPlayerViewIndexBySeat(playerData.seat)));
        self.playerViews[self:GetCorrectUIIndex(self:GetPlayerViewIndexBySeat(playerData.seat))]:ResetView(playerData);
    end);
    if data.seat == this.mySeat then
        this:RestoreGameScene()--重建
    end
end

function HNHSM_RePlayLogic:OnInitView(data)
    self:RemoveAllPlayerView(true);
end

function HNHSM_RePlayLogic:OnPlayerLeave(seat)
    print("座位号："..seat.."玩家，离开房间")
    replayUILayer:RefreshGpsView();
end


function HNHSM_RePlayLogic:OnPlayerDisconnected(seat) 
    print("座位号："..seat.."玩家，断开连接") 
end

function HNHSM_RePlayLogic:OnGameRoundStart(data)
    print("OnGameRoundStart-----------------")
    self.roomData.state         = hnm_pb.GAMING;
    self.roomData.bankerSeat    = data.bankerSeat;
    self.roomData.surplus       = self.roomData.surplus - #data.mahjongs;
    local playerData            = self:GetPlayerDataBySeat(data.seat);
    playerData.mahjongs         = data.mahjongs;
    playerData.mahjongCount     = #playerData.mahjongs;
    replayUILayer:SetRoundStart(self.roomData);
    replayUILayer:SetInviteVisiable(false);
end


function HNHSM_RePlayLogic:OnGameRoundEnd(data)
    print("OnGameRoundEnd-----------------")
    self.RoundData              = {};
    self.RoundData.data         = data;
    self.RoundData.mySeat       = self.mySeat;
    self.RoundData.playerData   = self:GetPlayerDatas();
    self.roomData.state         = hnm_pb.GAMING;
    self.RoundData.isInGame     = false;
    self.hasStageClear          = true;
    self.RoundData.over         = true;
    
    local sometime = 1.5;
    coroutine.start(function()
        coroutine.wait(sometime);
        stageRoomInfo 		        = {};
		stageRoomInfo.roomNumber 	= roomInfo.roomNumber;
		stageRoomInfo.RoundData 	= self.RoundData;
        stageRoomInfo.RoundAllData 	= self.RoundAllData;
        stageRoomInfo.roomData      = self.roomData;
        replayUILayer:SetGameRoundEnd(stageRoomInfo);
    end);
    self:ClearGameStates();
end

--清除一些游戏状态
function HNHSM_RePlayLogic:ClearGameStates()
    --1.清除准备状态
    self:ForeachPlayerDatas(function(_,playerData) 
        playerData.ready = false;
        playerData.mahjongs = {};
        playerData.moMahjong = -1;
        playerData.paiHe = {};
    
    end);
end

function HNHSM_RePlayLogic:GetCorrectRound()
    if self.roomData.setting.rounds >= self.roomData.round then 
        self.roomData.round = self.roomData.round + 1;
    end
    return self.roomData.round;
end

function HNHSM_RePlayLogic:OnGameRoundOver(data)
    print("-----------------OnGameRoundOver-----------------")
    self.RoundAllData                   = {};
    self.RoundAllData.data              = data;
    self.RoundAllData.mySeat            = this.mySeat;
    self.RoundAllData.playerData        = this:GetPlayerDatas();
    self.RoundAllData.isTrusteeships    = replayUILayer:GetOverTrusteeship();
    self.RoundAllData.roomData          = self.roomData;
    self.RoundAllData.over              = true;
    self.RoundAllData.playName          = self.roomData.playName;
    self.hasStageClear                  = self.hasStageClear == nil and false;
    replayUILayer:SetGameRoundOver(self.RoundAllData);
    
end

function HNHSM_RePlayLogic:OnGameDestroy(data)
    print("-----------------OnGameDestroy-----------------")
    self.super.OnGameDestroy(self, data);
    panelInGame.fanHuiRoomNumber = nil
    PanelManager.Instance:HideWindow("panelDestroyRoom");
    replayUILayer:SetGameDestroy(self.roomData);
   
end



function HNHSM_RePlayLogic:RestoreGameScene()
    replayUILayer:RefreshAllUI();
end

function HNHSM_RePlayLogic:ResetRoundStartState()
    self:ForeachPlayerDatas(function(playerView,_) playerView:ResetRoundStartState() end);
    PanelManager.Instance:HideWindow("panelStageClear_hnhsm");
end

function HNHSM_RePlayLogic:ResetGameState()
    self:ForeachPlayerDatas(function(playerView,_) playerView:ResetGameState() end)
end


function HNHSM_RePlayLogic:ChangePaiSize(hnhsmPaiSize)
    self.hnhsmPaiSize = hnhsmPaiSize;
    replayUILayer:ChangePaiSize(hnhsmPaiSize);
end

function HNHSM_RePlayLogic:IsGaming(logic, roomData)
    return logic:IsAllReaded() or not IsGameReadState(self.roomData) or self.roomData.round > 1
end


--刷新庄家位置
function HNHSM_RePlayLogic:OnRefreshBanker(data)
    print("OnRefreshBanker---------------------------->");
    self.roomData.bankerSeat = data.seat;

end

--设置玩家抓鱼分数
function HNHSM_RePlayLogic:OnSetPlayerFish(data)

    if data == nil or data.fishScoreBoard==nil then 
        return;
    end
    for i=1,#data.fishScoreBoard do
        local playerData = self:GetPlayerDataBySeat(data.fishScoreBoard[i].seat);
        playerData.yuScore = data.fishScoreBoard[i].score;
    end
    replayUILayer:SetPlayerFish(data);
end

--设置玩家分数
function HNHSM_RePlayLogic:OnPlayerScore(data)
    replayUILayer:SetPlayerScore(data);
end








--播放记录
function HNHSM_RePlayLogic:OnPlayerPlay(record)
    print("record.c"..record.c);
    self:InitPlayerExtraInfo(record);
    local noError = true;
	if record.c == "CBu" then  --补牌
		self:OnPlayerBuPai(record)
	elseif record.c == "CChi" then  --吃牌 
		self:OnPlayerChiPai(record)
	elseif record.c == "CChu" then  --出牌 
		self:OnPlayerChuPai(record)
	elseif record.c == "CGang" then  --扛牌
		self:OnPlayerGangPai(record)
	elseif record.c == "CHu" then  --胡牌
		self:OnPlayerHuPai(record)
	elseif record.c == "CMo" then  --摸牌  -1
		self:OnPlayerMoPai(record)
	elseif record.c == "CPeng" then  -- 碰牌
		self:OnPlayerPengPai(record)	
    elseif record.c == "CStart" then  --给他发牌
		self:OnGameRoundStart(record)
	elseif record.c == "CGuo" then --玩家过牌
        self:OnPlayerGuoPai(record);
    elseif record.c == "CFish" then --更新玩家抓鱼数据
        self:OnSetPlayerFish(record);
    elseif record.c == "CScore" then --更新玩家分数
        self:OnPlayerScore(record);
	else
        print('unkown operation:'..record.operation)
        noError = false;
    end

end

function HNHSM_RePlayLogic:InitPlayerExtraInfo(record)
    if record.c ~= "CGuo" then 
        local playerData =  self:GetPlayerDataBySeat(record.seat);
        local realIndex = self:GetCorrectUIIndex(self:GetPlayerViewIndexBySeat(record.seat));
        local playerView = self.playerViews[realIndex];
        -- print("------------------------------------------------------------------------------------------------")
        -- print("record.offline:"..tostring(record.offline));
        --玩家离线标志
        playerData.connected = not record.offline;
        --玩家托管标志
        playerData.trusteeship = record.trusteeship;
        playerView:SetOnlyOfflineFlag(not playerData.connected);
        playerView:SetTrusteeship(playerData.trusteeship);
        -- print("player.name="..playerData.name.." InitPlayerExtraInfo playerData.trusteeship="..tostring(playerData.trusteeship))
    end
end

