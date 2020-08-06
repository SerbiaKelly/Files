
require("GPSTool");
require("GameLogic");
require("HNZZM_Player");
require("HNZZM_UILayer");
require("FsmMachine");
require("HNZZM_PlayLogic");
local json          = require("json");
local hnm_pb        = nil;
HNZZM_Logic         = {};
HNZZM_Logic         = class(GameLogic);
local this          = nil;
local message       = nil;
local c_MaxSize     = 4;--最大人数
local playerSize    = c_MaxSize;--当前游戏人数
local uiLayer       = nil;


function HNZZM_Logic:ctor(gameView, game_pb, gameType, obj)
    this = self;
    hnm_pb = game_pb;
    uiLayer = HNZZM_UILayer.New(obj,this,hnm_pb);

    self:InitStateMachine();
    self:RegisterGameCallBack();

end

function HNZZM_Logic:InitStateMachine()

end

function HNZZM_Logic:GetUILayer()
    return uiLayer;
end


function HNZZM_Logic:RegisterGameCallBack()
    RegisterGameCallBack(hnm_pb.MOPAI,                  function(msg) self:OnPlayerMoPai(msg)           end);
    RegisterGameCallBack(hnm_pb.CHUPAI,                 function(msg) self:OnPlayerChuPai(msg)          end);
    RegisterGameCallBack(hnm_pb.CHIPAI,                 function(msg) self:OnPlayerChiPai(msg)          end);
    RegisterGameCallBack(hnm_pb.PENGPAI,                function(msg) self:OnPlayerPengPai(msg)         end);
    RegisterGameCallBack(hnm_pb.GANGPAI,                function(msg) self:OnPlayerGangPai(msg)         end);
    RegisterGameCallBack(hnm_pb.BUPAI,                  function(msg) self:OnPlayerBuPai(msg)           end);
    RegisterGameCallBack(hnm_pb.FOLD,                   function(msg) self:OnPlayerGuoPai(msg)          end);
    RegisterGameCallBack(hnm_pb.HUPAI,                  function(msg) self:OnPlayerHuPai(msg)           end);
    RegisterGameCallBack(hnm_pb.FLUSH_BANKER,           function(msg) self:OnRefreshBanker(msg)         end);
    RegisterGameCallBack(hnm_pb.ERROR_INFO,             function(msg) self:OnGameError(msg)             end);
    RegisterGameCallBack(hnm_pb.SELECT_PAO,             function(msg) self:OnPlayerSelectPao(msg)       end);
    RegisterGameCallBack(hnm_pb.SELECT_PAO_WAIT,        function(msg) self:OnPlayerPao(msg)             end);
end

function HNZZM_Logic:GetMaxPlayerSize()
    return c_MaxSize;
end

--通过游戏中的参与人数，选择恰当位置的UI分配给不同座位上的人，比如两个人时，座位号0，1对应人物头像1，3这两个游戏UI
--三个人时，座位号0，1，2对应人物头像1，2，4这三个游戏UI，四个人时，才会出现座位号跟头像UI一 一 对应的情况，座位号0，1，2，3对应人物头像1，2，3，4
function HNZZM_Logic:GetCorrectUIIndex(index)
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

function HNZZM_Logic:GetPlayerViewBySeat(seat)
    local realIndex = self:GetCorrectUIIndex(self:GetPlayerViewIndexBySeat(seat));
    return self.playerViews[realIndex];
end


--玩家摸牌
function HNZZM_Logic:OnPlayerMoPai(msg)
    
    -- print("OnPlayerMoPai--------->was called");
    local data              = self:GetMesaageData(hnm_pb.RMoPai(),msg);
    local playerData        = self:GetPlayerDataBySeat(data.seat);
    playerData.sealPai      = data.sealPai;
    playerData.moMahjong    = data.mahjong;
    self.roomData.surplus   = data.surplus;
    self.roomData.activeSeat= data.seat;
    playerData.mahjongCount = data.mahjongCount;
    self.needChuPai         = data.seat == self.mySeat;--自己摸了牌之后也要出牌
    -- print("seat="..data.seat..",before.mahjongCount:"..playerData.mahjongCount);
    tableClear(playerData.operations);
    tableClear(playerData.tingTip);
    tableClear(playerData.mahjongs);
    tableRemovePlate(data.mahjongs,data.mahjong);
    tableAdd(playerData.operations,data.operations);
    -- print("OnPlayerMoPai,data.operations.length:"..#data.operations);
    -- print("OnPlayerMoPai,data.tingTip.length:"..#data.tingTip);
    tableAdd(playerData.tingTip,data.tingTip);
    tableAdd(playerData.mahjongs,data.mahjongs);
    if data.seat == self.mySeat then 
        playerData.mahjongCount = #playerData.mahjongs;
    else
        playerData.mahjongCount = playerData.mahjongCount - 1;
    end
    -- print("seat="..data.seat..",after.mahjongCount:"..playerData.mahjongCount);

    uiLayer:SetPlayerMoPai(data);

    -- DelayMsgDispatch(self.connect,0.5);
end

--玩家出牌
function HNZZM_Logic:OnPlayerChuPai(msg)
    local data              = self:GetMesaageData(hnm_pb.RChuPai(),msg);
    local playerData        = self:GetPlayerDataBySeat(data.seat);
    playerData.mahjongCount = data.handCount;
    local myData            = self:GetPlayerDataBySeat(self.mySeat);
    self.needChuPai         = data.seat ~= self.mySeat;--如果自己出牌了之后就不用再出牌了，当然不是自己位置的时候也不一定是自己出牌，但是还有一个activeSeat可以参考
    playerData.moMahjong    = -1;
    -- print("OnPlayerChuPai,operations.length"..#data.operations);
    table.insert(playerData.paiHe,data.mahjong);
    tableClear(myData.operations);
    tableAdd(myData.operations,data.operations);
    tableClear(playerData.tingMahjongs);
    tableAdd(playerData.tingMahjongs,data.tingMahjongs);
    uiLayer:SetPlayerChuPai(data);

    -- DelayMsgDispatch(self.connect,0.5);
    
end

--玩家吃牌
function HNZZM_Logic:OnPlayerChiPai(msg)
    local data = self:GetMesaageData(hnm_pb.RChiPai(),msg);
    self.roomData.activeSeat = data.seat;
    self.needChuPai = data.seat == self.mySeat;--自己吃牌之后要出牌
    if data.seat == self.mySeat then 
        local myData = self:GetPlayerDataBySeat(self.mySeat);
        tableClear(myData.operations);
        tableClear(myData.tingTip);
        tableAdd(myData.operations,data.operations);
        tableAdd(myData.tingTip,data.tingTip);
        --喜牌中加入吃的这个牌
        table.insert(myData.operationCards,{operation = hnm_pb.SORT_CHI,cards = {data.others[1],data.mahjong,data.others[2]}});
        --手牌删掉吃的牌
        for i=1,#data.others do
            tableRemovePlate(myData.mahjongs,data.others[i]);
        end
        myData.mahjongCount = #myData.mahjongs;
    else
        local playerData = self:GetPlayerDataBySeat(data.seat);
        playerData.mahjongCount = playerData.mahjongCount - 2;
    end
    --删掉被吃的人打出的被吃的那张牌
    local playerData = self:GetPlayerDataBySeat(data.outSeat);
    tableRemovePlate(playerData.paiHe,data.mahjong);
    

    uiLayer:SetPlayerChiPai(data);

    -- DelayMsgDispatch(self.connect,0.5);

end

--玩家碰牌
function HNZZM_Logic:OnPlayerPengPai(msg)
    local data                  = self:GetMesaageData(hnm_pb.RPengPai(),msg);
    local playerData            = self:GetPlayerDataBySeat(data.seat);
    self.needChuPai             = data.seat == self.mySeat;--自己碰牌之后要出牌
    self.roomData.activeSeat    = data.seat;
    local myData                = self:GetPlayerDataBySeat(self.mySeat);
    print("OnPlayerPengPai:operations.length:"..#data.operations);
    tableClear(myData.operations);
    tableClear(myData.tingTip);
    tableAdd(myData.operations,data.operations);
    tableAdd(myData.tingTip,data.tingTip);
    table.insert( playerData.operationCards, {operation = hnm_pb.SORT_PENG,cards = {data.mahjong}} );
    if data.seat == self.mySeat then 
        local pengPlates = {data.mahjong,data.mahjong};
        for i=1,#pengPlates do
            tableRemovePlate(playerData.mahjongs,pengPlates[i]);
        end
        playerData.mahjongCount = #playerData.mahjongs;
        print("mymahjongs.length:"..#playerData.mahjongs..",myMahJongCount="..playerData.mahjongCount);
    else
        playerData.mahjongCount = playerData.mahjongCount - 2;
    end
    local outPlayerData = self:GetPlayerDataBySeat(data.outSeat);
    tableRemovePlate(outPlayerData.paiHe,data.mahjong);
    uiLayer:SetPlayerPengPai(data);

    -- DelayMsgDispatch(self.connect,0.5);
end

--玩家杠牌
function HNZZM_Logic:OnPlayerGangPai(msg)
    local data                  = self:GetMesaageData(hnm_pb.RGangPai(),msg);
    self.roomData.activeSeat    = data.seat;
    local playerData            = self:GetPlayerDataBySeat(data.seat);
    local myData                = self:GetPlayerDataBySeat(self.mySeat);
    self.needChuPai             = false;--这里设置成false是因为抢杠胡，正常情况下杠牌后会摸牌，摸牌的时候会解除出牌限制
    tableClear(myData.operations); 
    tableClear(myData.tingMahjongs); 
    tableAdd(myData.operations,         data.operations);
    tableAdd(myData.tingMahjongs,       data.tingMahjongs);
    tableAdd(playerData.tingMahjongs,   data.tingMahjongs);
    print("OnPlayerGangPai,data.mahjongs.length="..#data.mahjongs);
    print("data.operations.length="..#data.operations);
    if data.seat == self.mySeat then
        tableClear(playerData.mahjongs); 
        tableAdd(playerData.mahjongs,data.mahjongs);
    end
    playerData.mahjongCount = data.mahjongCount;
    if data.outSeat and data.gangType == hnm_pb.MING  then --明杠，杠了别人打出的牌
        local outPlayerData = self:GetPlayerDataBySeat(data.outSeat);
        tableRemovePlate(outPlayerData.paiHe,data.mahjong);
    end
    --更新喜牌数据
    if data.gangType == hnm_pb.MING then 
        table.insert(playerData.operationCards,{operation = hnm_pb.SORT_MING,cards = {data.mahjong}});
    elseif data.gangType == hnm_pb.AN then
        table.insert(playerData.operationCards,{operation = hnm_pb.SORT_DARK,cards = {data.mahjong}});
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
    uiLayer:SetPlayerGangPai(data);

    -- DelayMsgDispatch(self.connect,0.5);
end

--玩家补牌(呼市麻将没有补的操作)
function HNZZM_Logic:OnPlayerBuPai(msg)
    local data = self:GetMesaageData(hnm_pb.RBuPai(),msg);
    self.needChuPai = data.seat == self.mySeat;--自己补牌之后要出牌
    uiLayer:SetPlayerBuPai(data);
    -- DelayMsgDispatch(self.connect,0.5);
end


function HNZZM_Logic:CanChuPai()
    print("CanChuPai was called---------self.needChuPai="..tostring(self.needChuPai)..",self.roomData.activeSeat="..self.roomData.activeSeat..",self.mySeat="..self.mySeat)
    return self.needChuPai and (self.roomData.activeSeat == self.mySeat);
end



--玩家过牌
function HNZZM_Logic:OnPlayerGuoPai(msg)
    -- print("OnPlayerGuoPai was called------------->");
    local data = self:GetMesaageData(hnm_pb.RSeat(),msg);
     --如果是自摸过牌，那么就是轮到自己出牌，
    -- if data.seat == self.mySeat then 
    --     local playerData = self:GetPlayerDataBySeat(self.mySeat);
    --     if playerData.moMahjong ~= -1 then --说明这个过牌是由自己摸了一张牌后引起的，这种情况目前只有自摸胡牌，那么过了之后要出牌
    --         self.needChuPai = true;
    --     else
    --         self.needChuPai = false;
    --     end
    -- end
    uiLayer:SetPlayerGuoPai(data);
    -- DelayMsgDispatch(self.connect,0.5);
end

--玩家胡牌
function HNZZM_Logic:OnPlayerHuPai(msg)
    local data  = self:GetMesaageData(hnm_pb.RWin(),msg);
    for i=1,#data.winPlayers do
        local winPlayerData = data.winPlayers[i];
        -- print("OnPlayerHuPai------>winPlayerData.mahjongs.length="..#winPlayerData.mahjongs);
        -- print("winPlayerData.huItems.length="..#winPlayerData.huItems);
        if #winPlayerData.huItems > 0 then 
            local playerData = self:GetPlayerDataBySeat(winPlayerData.seat);
            tableClear(playerData.mahjongs);
            tableAdd(playerData.mahjongs,winPlayerData.mahjongs);
            if winPlayerData.selfMo then 
                -- print("winPlayerData.selfMo-------------------->");
                playerData.moMahjong = winPlayerData.huItems[1].huMahjong;
            end
            self:CheckPlayerDatas(playerData);
        end
    end
    uiLayer:SetPlayerHuPai(data);
    -- DelayMsgDispatch(self.connect,0.5);
end

--获得想要解散房间的玩家信息
function HNZZM_Logic:GetDissolutions()
    local dissolution       = {}
	dissolution.acceptors   = {}
    dissolution.remainMs    = 0;
    self:ForeachPlayerDatas(function(playerView,playerData) 
        if playerData.thinkTime > 0 and playerData.decision then 
            dissolution.remainMs = playerData.thinkTime;
            if playerData.decision == hnm_pb.APPLY then
                dissolution.applicant = playerData.seat; 
            elseif playerData.decision == hnm_pb.AGREE then 
                table.insert( dissolution.acceptors,playerData.seat );
            end
        end
    end)

    return dissolution;
end

function HNZZM_Logic:AutoRegisterPlayerDatas(playerDatas,resetView)
    self.super.AutoRegisterPlayerDatas(self,playerDatas,resetView);
end

--检查用户数据
function HNZZM_Logic:CheckPlayerDatas(playerData)
    --检查麻将子，如果是自己的数据，平且自己有摸牌，那么要从手中删掉该摸牌

    if playerData.mahjongs and #playerData.mahjongs>0 and playerData.moMahjong ~= -1 then 
        tableRemovePlate(playerData.mahjongs,playerData.moMahjong);
        -- print("CheckPlayerDatas remove moMahjong,playerData.mahjongs.length="..(#playerData.mahjongs))
        playerData.mahjongCount = #playerData.mahjongs;
    end
    if playerData.seat ~= self.mySeat then 
        if playerData.moMahjong == -2 then 
            playerData.mahjongCount = playerData.mahjongCount -1 ;
        end
    end
end




--开局倒计时自动解散的
function HNZZM_Logic:CheckAutoDissolutionState()

end

function HNZZM_Logic:OnJoinRoom(data)
    print("OnJoinRoom was called----------------------------->");
    self.roomData           = data.room;
    self.RoundAllData       = {};
    self.RoundData          = {};
    self.RoundAllData.over  = false;
    panelInGame.needXiPai   = false;
    self:SetMySeat(data.seat,self.roomData.setting.size);
    --玩家能否出牌
    self.needChuPai         = self.roomData.activeSeat == self.mySeat and (not self.roomData.waitOperate);
    self:ForeachPlayerDatas(function(playerView,playerData) 
        self:CheckPlayerDatas(playerData);
    end);
    uiLayer:InitUILayer(self.roomData);
   

end

--玩家加入
function HNZZM_Logic:OnPlayerJoin(data)
    -- print("-----------------OnPlayerJoin---------------")
    uiLayer:RefreshGpsView()
    self:ForeachPlayerDatas(function(playerView,playerData) 
        playerView:SetGameRoomData(self.roomData);
        -- print("index:"..self:GetPlayerViewIndexBySeat(playerData.seat));
        -- print("realIndex:"..self:GetCorrectUIIndex(self:GetPlayerViewIndexBySeat(playerData.seat)));
        self.playerViews[self:GetCorrectUIIndex(self:GetPlayerViewIndexBySeat(playerData.seat))]:ResetView(playerData);
    end);
    if data.seat == this.mySeat then
        this:RestoreGameScene()--重建
    end
    uiLayer:OnPlayerJoin(data);
end


function HNZZM_Logic:OnLeaveRoom()
    --print("-----------------OnLeaveRoom-----------------")
    panelInGame.fanHuiRoomNumber = nil
	PanelManager.Instance:HideWindow('panelDestroyRoom');
    uiLayer:SetLeaveRoom();
end

function HNZZM_Logic:OnInitView(data)
    self:RemoveAllPlayerView(true);
    self:RemoveAllPlayerData(true);
    self:ForeachPlayerDatas(function(playerView,_) playerView:CleanView() end);
    self:EnterGameServer(roomInfo.host, roomInfo.port);
end

function HNZZM_Logic:OnPlayerLeave(seat)
    print("座位号："..seat.."玩家，离开房间")
    uiLayer:RefreshGpsView();
end


function HNZZM_Logic:OnLordDissolve()
    panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '该房间已被群主或管理员解散')
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
    panelInGame.fanHuiRoomNumber = nil;
    -- DelayMsgDispatch(self.connect,0.5);
end

function HNZZM_Logic:OnAutoDissolve(data)
    DestroyRoomData.roomData = self.roomData;
    PanelManager.Instance:ShowWindow('panelAutoDissolve', data);
end

function HNZZM_Logic:OnRoomCannotDissolve()
    panelMessageBox.SetParamers(ONLY_OK,nil,nil,"房间设置为不能解散");
	PanelManager.Instance:ShowWindow("panelMessageBox");
end

function HNZZM_Logic:OnRoomDissolveLimit5()
    panelMessageBox.SetParamers(ONLY_OK,nil,nil,"每局解散最大申请次数不能超过5次");
	PanelManager.Instance:ShowWindow("panelMessageBox");
end


function HNZZM_Logic:OnPlayerDisconnected(seat) 
    print("座位号："..seat.."玩家，断开连接") 
end

--玩家准备
function HNZZM_Logic:OnPlayerReady(seat)
    -- print("-----------------OnReady-----------------")
    this:GetPlayerDataBySeat(seat).ready = true;
    uiLayer:RefreshPlayer();
    -- DelayMsgDispatch(self.connect,0.5);
end

function HNZZM_Logic:OnGameRoundStart(data)
    -- print("-----------------OnGameRoundStart-----------------")
    self.roomData.round         = data.round;
    self.roomData.state         = hnm_pb.GAMING;
    self.roomData.activeSeat    = data.bankerSeat;
    self.roomData.surplus       = data.surplus;
    self.hasStageClear          = self.hasStageClear == nil and false;
    if self.roomData.round == 1 and (not (self.roomData.setting.size == 2)) then
		local datas = {}
		for i = 0, self.roomData.setting.size - 1 do
			datas[i] = self:GetPlayerDataBySeat(i)
		end
        InspectIPAndGPS(datas,self.roomData.setting.size == 3 and pos3 or pos4,function()
            local msg       = Message.New()
            msg.type        = hnm_pb.DISSOLVE
            local body      = hnm_pb.PDissolve()
            body.decision   = hnm_pb.APPLY
            msg.body        = body:SerializeToString()
            SendGameMessage(msg, nil)
        end)   
    end
    if panelInGame.needXiPai == true then 
        panelInGame.needXiPai = false;
        self.connect.IsZanTing = true;
        local data = {};
        data.diceOnePoints = diceOnePoints;
        data.diceTwoPoints = diceTwoPoints;
        data.fuc = function()
            uiLayer:SetRoundStart(data);
            uiLayer:SetInviteVisiable(false);
			self.connect.IsZanTing=false
        end;
        PanelManager.Instance:ShowWindow('panelXiPai_dice',data);
    else
        uiLayer:SetRoundStart(data);
        uiLayer:SetInviteVisiable(false);
    end
   
    
    
end


function HNZZM_Logic:OnGameRoundEnd(data)
    -- print("-----------------OnGameRoundEnd-----------------")
    self.RoundData.data         = data;
    self.RoundData.mySeat       = this.mySeat;
    self.RoundData.playerData   = self:GetPlayerDatas();
    -- print("self.roomData.round :".. tostring( self.roomData.round ));
    self.roomData.round         = self:GetCorrectRound();
    self.roomData.state         = hnm_pb.READYING;
    self.RoundData.isInGame     = true;
    self.hasStageClear          = true;
    self.RoundData.over         = true;
    
    local sometime = 1.0;
    coroutine.start(function()
        coroutine.wait(sometime);
        stageRoomInfo 		        = {};
		stageRoomInfo.roomNumber 	= roomInfo.roomNumber;
		stageRoomInfo.RoundData 	= self.RoundData;
        stageRoomInfo.RoundAllData 	= self.RoundAllData;
        stageRoomInfo.roomData      = self.roomData;
        uiLayer:SetGameRoundEnd(stageRoomInfo);
    end);
    self:ClearGameStates();
    local myData = self:GetPlayerDataBySeat(self.mySeat);
    if not myData.trusteeship then 
        uiLayer:CheckPlayerOtherTrustesship(self.roomData.setting.trusteeship,true);
    end
    -- DelayMsgDispatch(self.connect,1.5);
end

--清除一些游戏状态
function HNZZM_Logic:ClearGameStates()
    --1.清除准备状态
    self:ForeachPlayerDatas(function(_,playerData) 
         playerData.ready = false;
    end);
    --.清除胡牌前的操作列表
    tableClear(self:GetPlayerDataBySeat(self.mySeat).operations);
    --清除听牌提示标志
    tableClear(self:GetPlayerDataBySeat(self.mySeat).tingTip);
    --清除玩家的蹲拉跑和财神数据
    self:ForeachPlayerDatas(function(_,playerData)
        playerData.yuScore = 0;
        --清除听牌数据
        tableClear(playerData.tingMahjongs);
    end);
    --重新设置底牌的张数
    self.roomData.surplus = self:GetDefaultSurplus();

    
end

function HNZZM_Logic:GetCorrectRound()
    if self.roomData.setting.rounds > self.roomData.round then 
        self.roomData.round = self.roomData.round + 1;
    end
    return self.roomData.round;
end

function HNZZM_Logic:OnGameRoundOver(data)
    -- print("-----------------OnGameRoundOver-----------------")
    self.RoundAllData.data              = data;
    self.RoundAllData.mySeat            = this.mySeat;
    self.RoundAllData.playerData        = this:GetPlayerDatas();
    self.RoundAllData.isTrusteeships    = uiLayer:GetOverTrusteeship();
    self.RoundAllData.roomData          = self.roomData;
    self.RoundAllData.over              = true;
    self.RoundAllData.playName          = self.roomData.playName;
    
    uiLayer:SetGameRoundOver(self.RoundAllData);
    -- DelayMsgDispatch(self.connect,0.5);
    
end

function HNZZM_Logic:OnGameDestroy(data)
    -- print("-----------------OnGameDestroy-----------------")
    self.super.OnGameDestroy(self, data);
    panelInGame.fanHuiRoomNumber = nil
    PanelManager.Instance:HideWindow("panelDestroyRoom");
    uiLayer:SetGameDestroy(self.roomData);
    -- DelayMsgDispatch(self.connect,0.5);
end

function HNZZM_Logic:OnDissolve(data)
    uiLayer:SetDissolve(data);
    -- DelayMsgDispatch(self.connect,0.5);
end

function HNZZM_Logic:RestoreGameScene()
    uiLayer:RefreshAllUI();
end

function HNZZM_Logic:ResetRoundStartState()
    self:ForeachPlayerDatas(function(playerView,_) playerView:ResetRoundStartState() end);
    PanelManager.Instance:HideWindow("panelStageClear_hnzzm");
end

function HNZZM_Logic:ResetGameState()
    self:ForeachPlayerDatas(function(playerView,_) playerView:ResetGameState() end)
end


function HNZZM_Logic:ChangePaiSize(hnzzmPaiSize)
    self.hnzzmPaiSize = hnzzmPaiSize;
    uiLayer:ChangePaiSize(hnzzmPaiSize);
end

function HNZZM_Logic:IsGaming(logic, roomData)
    return logic:IsAllReaded() or not IsGameReadState(self.roomData) or self.roomData.round > 1
end

function HNZZM_Logic:IsAllSquatPullRuned()
    local isAllSPR = true;
    self:ForeachPlayerDatas(function(playerView,playerData) 
        if playerData.completeChooce ~= 2 then 
            isAllSPR = false;
        end
    end );
    return isAllSPR;
end


function HNZZM_Logic:GetDefaultSurplus()
    return self.roomData.setting.playStorm and 144 or 116;
end

--刷新庄家位置
function HNZZM_Logic:OnRefreshBanker(msg)
    -- print("OnRefreshBanker---------------------------->");
    local data = this:GetMesaageData(hnm_pb.RSeat(),msg);
    self.roomData.bankerSeat = data.seat;

end




--托管
--seat 托管玩家的座位号
--enable 是否开启托管
--GameLogic中并没有考虑到座位号跟PlayerView的对应关系，所以先清除GameLogic中设置的托管标识
function HNZZM_Logic:OnPlayerTrustesship(seat,enable)
    --1.清除GameLogic中设置的默认托管标识，
    self:ForeachPlayerDatas(function(playerView,_) 
        playerView:SetTrusteeship(false);
    end);
    self:ForeachPlayerDatas(function(_,playerData)
        local realIndex = self:GetCorrectUIIndex(self:GetPlayerViewIndexBySeat(playerData.seat));
        self.playerViews[realIndex]:SetTrusteeship(playerData.trusteeship);
    end);
    --2.设置正确的玩家托管标识
    uiLayer:SetPlayerTrustesship(seat,enable);
    -- DelayMsgDispatch(self.connect,0.5);
end

--游戏错误，主要是申请5次
function HNZZM_Logic:OnGameError(msg)
    -- print("OnGameError------------------------>");
    local data = this:GetMesaageData(hnm_pb.RError(),msg);
    panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, data.info);
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi');
end


--房间不存在
function HNZZM_Logic:OnRoomNoExist()
    uiLayer:SetRoomNoExist();
end

--房间在规定时间没有开始，自动解散
function HNZZM_Logic:OnRoomDissolveIn5Seconds()
    panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '规定时间内房间未开始已自动解散')
	PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

--推送跑分选项
function HNZZM_Logic:OnPlayerPao(msg)
    print("OnPlayerPao--------------------------");
    local data = this:GetMesaageData(hnm_pb.RSelectPaoWait(),msg);
    uiLayer:SetPlayerPao(data);
end

--玩家选择跑分的服务器返回
function HNZZM_Logic:OnPlayerSelectPao(msg)
    local data = this:GetMesaageData(hnm_pb.RSelectPao(),msg);
    local playerData = self:GetPlayerDataBySeat(data.seat);
    playerData.paoScore = data.score;
    uiLayer:SetPlayerSelectPao(data);
end

--是否应该显示跑分按钮
function HNZZM_Logic:NeedShowRunScore()
    local myData = self:GetPlayerDataBySeat(self.mySeat);
    if self.roomData.state == hnm_pb.READYING and self:IsAllReaded() then 
        if self.roomData.setting.selectPao == -1 then 
            return myData.paoScore == -1;
        else
            return false;
        end
    else
        return false;
    end
end

--跑分过程是否已经结束
function HNZZM_Logic:IsRunScoreFinished()
    if self.roomData.setting.selectPao ~= -1 then 
        return true;
    else
        local finished = true;
        for i = 0, self.roomData.setting.size - 1 do
            local playerData = self:GetPlayerDataBySeat(i)
            if playerData and playerData.selectPao == -1 then 
                finished = false;
                break;
            end
        end
    end
    return finished;
end

--是否应该展示混牌
function HNZZM_Logic:NeedShowHun()
    return self.roomData.setting.takeHun and self.roomData.state == hnm_pb.GAMING ;
end

