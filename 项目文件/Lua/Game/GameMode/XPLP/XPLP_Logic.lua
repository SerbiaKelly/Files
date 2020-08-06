require("GameLogic");
require("GPSTool");
require("XPLP_Player");
require("XPLP_UILayer");
require("FsmMachine");
require("XPLP_PlayLogic");
local json          = require("json");
local xplp_pb       = nil;
XPLP_Logic          = {};
XPLP_Logic          = class(GameLogic);
local this          = nil;
local message       = nil;
local c_MaxSize     = 4;--最大人数
local playerSize    = c_MaxSize;--当前游戏人数
local uiLayer       = nil;


function XPLP_Logic:ctor(gameView, game_pb, gameType, obj)
    this = self;
    xplp_pb = game_pb;
    uiLayer = XPLP_UILayer.New(obj,this,xplp_pb);

    self:InitStateMachine();
    self:RegisterGameCallBack();

end

function XPLP_Logic:InitStateMachine()

end

function XPLP_Logic:GetUILayer()
    return uiLayer;
end


function XPLP_Logic:RegisterGameCallBack()
    RegisterGameCallBack(xplp_pb.MOPAI,                     function(msg) self:OnPlayerMoPai(msg)       end);
    RegisterGameCallBack(xplp_pb.CHUPAI,                    function(msg) self:OnPlayerChuPai(msg)      end);
    RegisterGameCallBack(xplp_pb.CHIPAI,                    function(msg) self:OnPlayerChiPai(msg)      end);
    RegisterGameCallBack(xplp_pb.PENGPAI,                   function(msg) self:OnPlayerPengPai(msg)     end);
    RegisterGameCallBack(xplp_pb.FOLD,                      function(msg) self:OnPlayerGuoPai(msg)      end);
    RegisterGameCallBack(xplp_pb.HUPAI,                     function(msg) self:OnPlayerHuPai(msg)       end);
    RegisterGameCallBack(xplp_pb.FLUSH_BANKER,              function(msg) self:OnRefreshBanker(msg)     end);
    RegisterGameCallBack(xplp_pb.ERROR_INFO,                function(msg) self:OnGameError(msg)         end);
    RegisterGameCallBack(xplp_pb.GU_CHOU,                   function(msg) self:OnPlayerGuChou(msg)      end);
    RegisterGameCallBack(xplp_pb.GU_CHOU_WAIT,              function(msg) self:OnPlayerGuChouWait(msg)  end);
    RegisterGameCallBack(xplp_pb.CHONG_WAIT,                function(msg) self:OnPlayerChongWait(msg)   end);
    RegisterGameCallBack(xplp_pb.CHONG_SCORE,               function(msg) self:OnPlayerChongScore(msg)  end);
end

function XPLP_Logic:GetMaxPlayerSize()
    return c_MaxSize;
end

--通过游戏中的参与人数，选择恰当位置的UI分配给不同座位上的人，比如两个人时，座位号0，1对应人物头像1，3这两个游戏UI
--三个人时，座位号0，1，2对应人物头像1，2，4这三个游戏UI，四个人时，才会出现座位号跟头像UI一 一 对应的情况，座位号0，1，2，3对应人物头像1，2，3，4
function XPLP_Logic:GetCorrectUIIndex(index)
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

--根据玩家最终的UIIndex[就是GetCorrectUIIndex转换后的index]，返回玩家的初始UIIndex
function XPLP_Logic:GetCorrectUIIndexByRealUIIndex(correctIndex)
    if self.totalSize == 3 then 
        if correctIndex == 4 then 
            return 3;
        end
    elseif self.totalSize == 2 then 
        if correctIndex == 3 then 
            return 2;
        end
    end
    return correctIndex;
end

function XPLP_Logic:GetPlayerViewBySeat(seat)
    local realIndex = self:GetCorrectUIIndex(self:GetPlayerViewIndexBySeat(seat));
    return self.playerViews[realIndex];
end


--玩家摸牌
function XPLP_Logic:OnPlayerMoPai(msg)
    
    -- print("OnPlayerMoPai--------->was called");
    local data              = self:GetMesaageData(xplp_pb.RMoPai(),msg);
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
        if playerData.guChou == 1 then 
        else
            playerData.mahjongCount = #playerData.mahjongs;--当不是箍臭的时候，摸牌已经放到player.moMahjong上去了，所以这里要-1
        end
        
    else
        if playerData.guChou ~= 1 then 
            playerData.mahjongCount = playerData.mahjongCount - 1;--当不是箍臭的时候，摸牌已经放到player.moMahjong上去了，所以这里要-1，但减不减都不影响，因为其他玩家的摸牌不会显示出来
        end
    end
    -- print("seat="..data.seat..",after.mahjongCount:"..playerData.mahjongCount);

    uiLayer:SetPlayerMoPai(data);

    -- DelayMsgDispatch(self.connect,0.5);
end

--玩家出牌
function XPLP_Logic:OnPlayerChuPai(msg)
    local data              = self:GetMesaageData(xplp_pb.RChuPai(),msg);
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
function XPLP_Logic:OnPlayerChiPai(msg)
    local data = self:GetMesaageData(xplp_pb.RChiPai(),msg);
    self.roomData.activeSeat = data.seat;
    self.needChuPai = data.seat == self.mySeat;--自己吃牌之后要出牌
    local playerData = self:GetPlayerDataBySeat(data.seat);
    --喜牌中加入吃的这个牌
    table.insert(playerData.operationCards,{operation = xplp_pb.SORT_CHI,cards = {data.mahjong,data.others[1],data.others[2]}});
    if data.seat == self.mySeat then 
        local myData = self:GetPlayerDataBySeat(self.mySeat);
        tableClear(myData.operations);
        tableClear(myData.tingTip);
        tableAdd(myData.operations,data.operations);
        tableAdd(myData.tingTip,data.tingTip);
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
function XPLP_Logic:OnPlayerPengPai(msg)
    local data                  = self:GetMesaageData(xplp_pb.RPengPai(),msg);
    local playerData            = self:GetPlayerDataBySeat(data.seat);
    self.needChuPai             = data.seat == self.mySeat;--自己碰牌之后要出牌
    self.roomData.activeSeat    = data.seat;
    local myData                = self:GetPlayerDataBySeat(self.mySeat);
    print("OnPlayerPengPai:operations.length:"..#data.operations);
    tableClear(myData.operations);
    tableClear(myData.tingTip);
    tableAdd(myData.operations,data.operations);
    tableAdd(myData.tingTip,data.tingTip);
    table.insert( playerData.operationCards, {operation = xplp_pb.SORT_PENG,cards = {data.mahjong}} );
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




function XPLP_Logic:CanChuPai()
    -- print("CanChuPai was called---------self.needChuPai="..tostring(self.needChuPai)..",self.roomData.activeSeat="..self.roomData.activeSeat..",self.mySeat="..self.mySeat)
    return self.needChuPai and (self.roomData.activeSeat == self.mySeat);
end



--玩家过牌
function XPLP_Logic:OnPlayerGuoPai(msg)
    -- print("OnPlayerGuoPai was called------------->");
    local data = self:GetMesaageData(xplp_pb.RSeat(),msg);
     --如果是自摸过牌，那么就是轮到自己出牌，
    uiLayer:SetPlayerGuoPai(data);
end

--玩家胡牌
function XPLP_Logic:OnPlayerHuPai(msg)
    local data  = self:GetMesaageData(xplp_pb.RWin(),msg);
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
function XPLP_Logic:GetDissolutions()
    local dissolution       = {}
	dissolution.acceptors   = {}
    dissolution.remainMs    = 0;
    self:ForeachPlayerDatas(function(playerView,playerData) 
        if playerData.thinkTime > 0 and playerData.decision then 
            dissolution.remainMs = playerData.thinkTime;
            if playerData.decision == xplp_pb.APPLY then
                dissolution.applicant = playerData.seat; 
            elseif playerData.decision == xplp_pb.AGREE then 
                table.insert( dissolution.acceptors,playerData.seat );
            end
        end
    end)

    return dissolution;
end

function XPLP_Logic:AutoRegisterPlayerDatas(playerDatas,resetView)
    self.super.AutoRegisterPlayerDatas(self,playerDatas,resetView);
end

--检查用户数据
function XPLP_Logic:CheckPlayerDatas(playerData)
    --检查麻将子，如果是自己的数据，并且自己有摸牌，那么要从手中删掉该摸牌
    if playerData.guChou ~= 1 then 
        if playerData.mahjongs and #playerData.mahjongs>0 and playerData.moMahjong ~= -1 then 
            tableRemovePlate(playerData.mahjongs,playerData.moMahjong);
            -- print("CheckPlayerDatas remove moMahjong,playerData.mahjongs.length="..(#playerData.mahjongs))
            playerData.mahjongCount = #playerData.mahjongs;
        end
        -- if playerData.seat ~= self.mySeat then 
        --     if playerData.moMahjong == -2 then 
        --         playerData.mahjongCount = playerData.mahjongCount -1 ;
        --     end
        -- end
    end
   
end




--开局倒计时自动解散的
function XPLP_Logic:CheckAutoDissolutionState()

end

function XPLP_Logic:OnJoinRoom(data)
    print("OnJoinRoom was called----------------------------->");
    self.roomData           = data.room;
    print("OnJoinRoom self.roomData is nil:"..tostring(self.roomData==nil));
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
function XPLP_Logic:OnPlayerJoin(data)
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



function XPLP_Logic:OnLeaveRoom()
    print("-----------------OnLeaveRoom-----------------")
    panelInGame.fanHuiRoomNumber = nil
	PanelManager.Instance:HideWindow('panelDestroyRoom');
    uiLayer:SetLeaveRoom();
end

function XPLP_Logic:OnInitView(data)
    -- print("OnInitView ------------------------- XPLP_Logic")
    self:RemoveAllPlayerView(true);
    self:RemoveAllPlayerData(true);
    self:ForeachPlayerDatas(function(playerView,_) playerView:CleanView() end);
    self:EnterGameServer(roomInfo.host, roomInfo.port);
end

function XPLP_Logic:OnPlayerLeave(seat)
    print("座位号："..seat.."玩家，离开房间")
    uiLayer:RefreshGpsView();
end


function XPLP_Logic:OnLordDissolve()
    panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '该房间已被群主或管理员解散')
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
    panelInGame.fanHuiRoomNumber = nil;
    -- DelayMsgDispatch(self.connect,0.5);
end

function XPLP_Logic:OnAutoDissolve(data)
    DestroyRoomData.roomData = self.roomData;
    PanelManager.Instance:ShowWindow('panelAutoDissolve', data);
end

function XPLP_Logic:OnRoomCannotDissolve()
    panelMessageBox.SetParamers(ONLY_OK,nil,nil,"房间设置为不能解散");
	PanelManager.Instance:ShowWindow("panelMessageBox");
end

function XPLP_Logic:OnRoomDissolveLimit5()
    panelMessageBox.SetParamers(ONLY_OK,nil,nil,"每局解散最大申请次数不能超过5次");
	PanelManager.Instance:ShowWindow("panelMessageBox");
end


function XPLP_Logic:OnPlayerDisconnected(seat) 
    print("座位号："..seat.."玩家，断开连接") 
end

--玩家准备
function XPLP_Logic:OnPlayerReady(seat)
    -- print("-----------------OnReady-----------------")
    this:GetPlayerDataBySeat(seat).ready = true;
    uiLayer:RefreshPlayer();
    -- DelayMsgDispatch(self.connect,0.5);
end

function XPLP_Logic:OnGameRoundStart(data)
    -- print("-----------------OnGameRoundStart-----------------")
    self.roomData.round         = data.round;
    self.roomData.state         = xplp_pb.GAMING;
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
            msg.type        = xplp_pb.DISSOLVE
            local body      = xplp_pb.PDissolve()
            body.decision   = xplp_pb.APPLY
            msg.body        = body:SerializeToString()
            SendGameMessage(msg, nil)
        end)   
    end
    if panelInGame.needXiPai == true then 
        panelInGame.needXiPai = false;
        self.connect.IsZanTing = true;
        local xipaiData = {};
        xipaiData.needChangeAtlas = true;
        xipaiData.atlasName = "ingamexplp";
        xipaiData.spriteName = "溆浦老牌-牌面_背面";
        xipaiData.finishedFun = function()
            uiLayer:SetRoundStart(data);
            uiLayer:SetInviteVisiable(false);
			self.connect.IsZanTing=false
        end
        PanelManager.Instance:ShowWindow('panelXiPai_ziPai',xipaiData);
    else
        uiLayer:SetRoundStart(data);
        uiLayer:SetInviteVisiable(false);
    end
   
    
    
end


function XPLP_Logic:OnGameRoundEnd(data)
    print("-----------------OnGameRoundEnd-----------------")
    self.RoundData.data         = data;
    self.RoundData.mySeat       = this.mySeat;
    self.RoundData.playerData   = self:GetPlayerDatas();
    -- print("self.roomData.round :".. tostring( self.roomData.round ));
    self.roomData.round         = self:GetCorrectRound();
    self.roomData.state         = xplp_pb.READYING;
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
function XPLP_Logic:ClearGameStates()
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
        --清除听牌数据
        tableClear(playerData.tingMahjongs);
    end);
    --重新设置底牌的张数
    self.roomData.surplus = self:GetDefaultSurplus();

    
end

function XPLP_Logic:GetCorrectRound()
    if self.roomData.setting.rounds > self.roomData.round then 
        self.roomData.round = self.roomData.round + 1;
    end
    return self.roomData.round;
end

function XPLP_Logic:OnGameRoundOver(data)
    print("-----------------OnGameRoundOver-----------------")
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

function XPLP_Logic:OnGameDestroy(data)
    print("-----------------OnGameDestroy-----------------")
    self.super.OnGameDestroy(self, data);
    panelInGame.fanHuiRoomNumber = nil
    PanelManager.Instance:HideWindow("panelDestroyRoom");
    uiLayer:SetGameDestroy(self.roomData);
    -- DelayMsgDispatch(self.connect,0.5);
end

function XPLP_Logic:RegisterPlayerData(playerData, resetView)
   
    self.super.RegisterPlayerData(self,playerData,resetView);
    XPLP_Tools.SortOperationCards(playerData.operationCards);
end

function XPLP_Logic:OnDissolve(data)
    uiLayer:SetDissolve(data);
    -- DelayMsgDispatch(self.connect,0.5);
end

function XPLP_Logic:RestoreGameScene()
    uiLayer:RefreshAllUI();
end

function XPLP_Logic:ResetRoundStartState()
    self:ForeachPlayerDatas(function(playerView,_) playerView:ResetRoundStartState() end);
    PanelManager.Instance:HideWindow("panelStageClear_xplp");
end

function XPLP_Logic:ResetGameState()
    self:ForeachPlayerDatas(function(playerView,_) playerView:ResetGameState() end)
end


function XPLP_Logic:ChangePaiSize(xplpPaiSize)
    self.xplpPaiSize = xplpPaiSize;
    uiLayer:ChangePaiSize(xplpPaiSize);
end

--是否应该显示冲分UI
function XPLP_Logic:NeedShowChongUI()
    local myData = self:GetPlayerDataBySeat(self.mySeat);
    if self.roomData.state == xplp_pb.GAMING then --再游戏中是不能显示的
        return false;
    else
        if self:IsAllReaded() then 
            if self.roomData.setting.chong == 0 then --不可冲:如果设置里面是不冲，那么肯定不显示
                return false;
            elseif self.roomData.setting.chong == 1 then --可冲:如果可冲，选择后，每小局开始时，每个闲家可不冲，庄家必须冲与上局相等的冲分或更高的分
                return myData.choiceRoundScore == -1;--等于-1表示玩家还未选过冲分，否则就是一个>=0的数
            elseif self.roomData.setting.chong == 2 then --.必冲:选择后，大局开始后，默认每个玩家自动冲相应分数，每小局不用选择冲分或不冲
                return false;
            elseif self.roomData.setting.chong == 3 then --必冲后可冲:选择后，大局开始后，默认每个玩家自动冲相应分数，同时玩家还可以自己选择冲分，且只能冲比必冲分或上一小局冲分相等或更大的分数，不可以不冲
                return myData.choiceRoundScore == -1;
            elseif self.roomData.setting.chong == 4 then --冲上不冲下：选择后，每小局开始，必须冲分，且只能冲比上一小局冲分相等或更大的分数
                return myData.choiceRoundScore == -1;
            else
                return true;
            end
        else
            return false;
        end
    end
end

--是否应该显示箍臭UI
function XPLP_Logic:NeedShowGuChouUI()
    local myData = self:GetPlayerDataBySeat(self.mySeat);
    if self.roomData.state == xplp_pb.GAMING then 
        if self.roomData.setting.size > 2 then 
            if self.roomData.setting.guChou then 
                return myData.guChou == 0 and self.mySeat ~= self.roomData.bankerSeat;--箍臭 0:未选择过  1:同意箍臭  2:拒绝箍臭
            else
                return false;
            end
        else--箍臭只有3-4人才有
            return false;
        end
    else
        return false;
    end
end

--箍臭过程是否已经结束
function XPLP_Logic:IsGuChouFinished()
    if self.roomData.setting.size == 2 then 
        return true;
    end
    if self.roomData.setting.guChou == false then 
        return true;
    end
    --如果是庄家，肯定不用箍臭了
    if self.roomData.bankerSeat == self.mySeat then 
        return true;
    end

    --只能有一个玩家箍臭，如果有人箍臭，那么整个箍臭过程结束
    for i = 0, self.roomData.setting.size - 1 do
        local playerData = self:GetPlayerDataBySeat(i)
        if playerData and playerData.guChou == 1 then 
            return true;
        end
    end

    --如果所有人都选择不箍臭【除了庄家，庄家不能选择箍臭】,那么整个箍臭过程也结束了
    local count = 0;
    for i = 0, self.roomData.setting.size - 1 do
        if i ~= self.roomData.bankerSeat then 
            local playerData = self:GetPlayerDataBySeat(i)
            if playerData and playerData.guChou == 2 then 
                count = count + 1 ;
            end
        end
    end
    if count == (self.roomData.setting.size -1) then 
        return true;
    end
    return false;
end

--获取冲分各个按钮的状态
function XPLP_Logic:GetChongButtonsState(scores)
    local chongButtonStates = {};
    for i=0,4 do
        local state = {};
        if i>0 then 
            state.score = self.roomData.setting.chongType*i;
        end
        for j=1,#scores do
            if scores[j] == self.roomData.setting.chongType*i then 
                state.enable = true;
                find = true;
                break;
            else
                state.enable = false;
            end
        end
        table.insert( chongButtonStates,state);
    end
    return chongButtonStates;
end



function XPLP_Logic:GetDefaultSurplus()
    return self.roomData.setting.playStorm and 144 or 116;
end

--刷新庄家位置
function XPLP_Logic:OnRefreshBanker(msg)
    print("OnRefreshBanker---------------------------->");
    local data = this:GetMesaageData(xplp_pb.RSeat(),msg);
    self.roomData.bankerSeat = data.seat;
    self:ForeachPlayerDatas(function(playerView,playerData) 
        playerView:SetMaster(playerData.seat == self.roomData.bankerSeat);
    end);
end


--托管
--seat 托管玩家的座位号
--enable 是否开启托管
--GameLogic中并没有考虑到座位号跟PlayerView的对应关系，所以先清除GameLogic中设置的托管标识
function XPLP_Logic:OnPlayerTrustesship(seat,enable)
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
function XPLP_Logic:OnGameError(msg)
    -- print("OnGameError------------------------>");
    local data = this:GetMesaageData(xplp_pb.RError(),msg);
    panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, data.info);
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi');
end


--房间不存在
function XPLP_Logic:OnRoomNoExist()
    uiLayer:SetRoomNoExist();
end

--房间在规定时间没有开始，自动解散
function XPLP_Logic:OnRoomDissolveIn5Seconds()
    panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '规定时间内房间未开始已自动解散')
	PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

--玩家箍臭选择
function XPLP_Logic:OnPlayerGuChou(msg)
    local data          = this:GetMesaageData(xplp_pb.RGuChou(),msg);
    local playerData    = self:GetPlayerDataBySeat(data.seat);
    playerData.sealPai  = data.apply;
    playerData.guChou   = data.apply and 1 or 2;
    uiLayer:SetPlayerGuChou(data);
end

--通知玩家箍臭
function XPLP_Logic:OnPlayerGuChouWait(msg)
    local data = self:GetMesaageData(xplp_pb.RGuChouWait(),msg);
    uiLayer:SetPlayerGuChouWait(data);
end

--玩家等待冲分
function XPLP_Logic:OnPlayerChongWait(msg)
   
    local data          = this:GetMesaageData(xplp_pb.RChongWait(),msg);
    local playerData    = self:GetPlayerDataBySeat(data.seat);
    tableClear(playerData.choiceScore);
    tableAdd(playerData.choiceScore,data.scores);
    print("data.scores.length="..#data.scores);
    for i=1,#data.scores do
        print("scores["..i.."]="..data.scores[i]);
    end
    uiLayer:SetPlayerChongWait(data);
end

--玩家选择冲分
function XPLP_Logic:OnPlayerChongScore(msg)
    local data                  = this:GetMesaageData(xplp_pb.RChongScore(),msg);
    local playerData            = self:GetPlayerDataBySeat(data.seat);
    playerData.choiceRoundScore = data.score;
    uiLayer:SetPlayerChongScore(data);
end

--是否处于碰或者吃后不可出同张的状态
function XPLP_Logic:IsInChiPengThenNoSame()
    print("IsInChiPengThenNoSame self.roomData is nil:"..tostring(self.roomData == nil));
    if self.roomData.setting.pengNoChu or self.roomData.setting.chiNoChu then 
        local myData = self:GetPlayerDataBySeat(self.mySeat);
        if myData.operationCards == nil or #myData.operationCards == 0 then 
            return false;
        else
            local length = #myData.operationCards;
            local lastOperationCard = myData.operationCards[length];
            return (self.roomData.activeSeat == self.mySeat and 
                    myData.moMahjong == -1 and
                    (lastOperationCard.operation == xplp_pb.SORT_CHI or lastOperationCard.operation == xplp_pb.SORT_PENG )
                ); 
        end
    else
        return false;
    end
end



