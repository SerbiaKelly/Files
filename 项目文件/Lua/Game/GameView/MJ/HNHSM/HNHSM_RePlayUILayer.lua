require("HNHSM_Player");
require("HNHSM_GridTool");
require("HNHSM_PlayLogic");
require("HNHSM_RePlayEventBind");
require("HNHSM_Tools");
require("const");
require("effManger");
local gameUIObjects         = require("HNHSM_GameObjs");
local json                  = require("json");
HNHSM_RePlayUILayer          = class();


local cardColorNum = 2;--牌色的数量
local BgColorNum = 3;--背景颜色的数量

local bgColor;--牌色的索引
local cardColor;--背景的颜色索引1.蓝色 2.绿色
local cardText;--背景的字体索引
local language;--语言设置
local HongzhongPlateValue = 31;--红中麻将的值
local dragDepthOffset = 100;
local dragCardFrameDepth = 0;
local dragCardDepth = 0;
local tingTipDepth = 0;
DestroyRoomData = {};
local this = nil;






function HNHSM_RePlayUILayer:ctor(gameObject,HNHSM_RePlayLogic,game_pb)
    this                        = self;
    self.HNHSM_RePlayLogic      = HNHSM_RePlayLogic;
    self.nmm_pb                 = game_pb;
    self.gameObject             = gameObject;
    self.isPause                = false
    self.playInterval           = 1.5
    self.playIndex              = 1
    self.rawSpeed               = self.playInterval;
    self.cutTime                = 0.25
    self.playCoroutine          = nil;
    self.HongzhongPlateValue    = HongzhongPlateValue;
    self:GetUIS(self.gameObject);
    

end

function HNHSM_RePlayUILayer:GetGameLogic()
    return self.HNHSM_RePlayLogic;
end


function HNHSM_RePlayUILayer:GetUIS(gameObject)
    gameUIObjects.CleanObjs();
    self:GetPlayersUI(gameObject);      --获得人物相关的UI
    self:GetRoomInfoUI(gameObject);     --房间信息
    self:GetButtons(gameObject);        --获得游戏中的各种按钮
    self:GetESWNUI(gameObject);         --房间信息self:GetESWNUI(gameObject);--获得桌子上东南西北那些UI
    
end

function HNHSM_RePlayUILayer:GetPlayersUI(gameObject)
    local maxPlayerSize = self.HNHSM_RePlayLogic:GetMaxPlayerSize();
    local gamers = gameObject.transform:Find("Gamers");
    for i=1,maxPlayerSize do
        local objectStr             = "Player"..i;
        local obj                   = gamers:Find(objectStr);
        local gridHand              = gameObject.transform:Find(objectStr.."_mj/GridHand");
        local gridXi                = gameObject.transform:Find(objectStr.."_mj/GridXi");
        local gridThrow             = gameObject.transform:Find(objectStr.."_mj/TabelThrow");
        local gridMo                = gameObject.transform:Find(objectStr.."_mj/MoPaiGrid");
        local chuPaiShow            = gameObject.transform:Find(objectStr.."_mj/chuPaiShow");
        local HNHSM_GridTool        = HNHSM_GridTool.New(gridHand,gridXi,gridThrow,gridMo,chuPaiShow,(i-1),nil,{uiLayer = self});
        local playerView            = HNHSM_Player.New(obj.gameObject,gameObject);
        local RoundDetail           = {};
        RoundDetail.openUserCard    = true;
        RoundDetail.isLord          = true;
        playerView:SetGameLogic(self.HNHSM_RePlayLogic):SetMJGridTool(HNHSM_GridTool,self.HNHSM_RePlayLogic,self);
        playerView:SetRoundDetail(RoundDetail);
        table.insert(gameUIObjects.playerViews, playerView);

        gameUIObjects.playerMoPaiPos[i]             = gameObject.transform:Find("playerOperationEffect/"..objectStr.."/mopai_pos");
        gameUIObjects.playerOperationEffectPos[i]   = gameObject.transform:Find("playerOperationEffect/"..objectStr.."/operation_pos");
        gameUIObjects.effectCategories              = gameObject.transform:Find("effectCategories/cate"..i);
        if gameUIObjects.playerHupaiPos[i] == nil then 
            gameUIObjects.playerHupaiPos[i]         = gameUIObjects.playerOperationEffectPos[i].position;
        end
        if gameUIObjects.playerTableThrowGridPos[i] == nil then 
            gameUIObjects.playerTableThrowGridPos[i] = gridThrow.localPosition;
            -- print("set gameUIObjects.playerTableThrowGridPos["..i.."]="..tostring(gameUIObjects.playerTableThrowGridPos[i]));
        end
        if gameUIObjects.playerHandGridPos[i] == nil then 
            gameUIObjects.playerHandGridPos[i] = gridHand.localPosition;
        end
        
    end
    
end



function HNHSM_RePlayUILayer:GetButtons(gameObject)
    gameUIObjects.ButtonHu 				= gameUIObjects.operation_send:Find('Button2Hu');
    gameUIObjects.ButtonGang 			= gameUIObjects.operation_send:Find('Button3Gang');
	gameUIObjects.ButtonPeng 			= gameUIObjects.operation_send:Find('Button5Peng');
	gameUIObjects.ButtonChi 			= gameUIObjects.operation_send:Find('Button6Chi');
	gameUIObjects.ButtonGuo 			= gameUIObjects.operation_send:Find('Button1Guo');
    gameUIObjects.ButtonBu 				= gameUIObjects.operation_send:Find('Button4Bu');
	
end

function HNHSM_RePlayUILayer:GetRoomInfoUI(gameObject)
    gameUIObjects.roomRound             = gameObject.transform:Find('DiPai/frame/round');
    gameUIObjects.roomID                = gameObject.transform:Find('stateBar/room/ID');
    gameUIObjects.waitRoomID            = gameObject.transform:Find('setting/roominfo/waitRoomID');
    gameUIObjects.roomTime 	            = gameObject.transform:Find('stateBar/time');
    gameUIObjects.batteryLevel          = gameObject.transform:Find('stateBar/battery/level'):GetComponent('UISprite');
    gameUIObjects.network               = gameObject.transform:Find('stateBar/network'):GetComponent('UISprite');
    gameUIObjects.pingLabel             = gameObject.transform:Find('stateBar/ping'):GetComponent('UILabel');
    gameUIObjects.roomSetting 	        = gameObject.transform:Find('setting');
    gameUIObjects.gameTypeobj 	        = gameObject.transform:Find('type');
    gameUIObjects.kaiBao 	            = gameObject.transform:Find('KaiBao');
    gameUIObjects.line 			        = gameObject.transform:Find('line');
    gameUIObjects.operation_send        = gameObject.transform:Find('Operation/operation_send');
    gameUIObjects.curOperatPlateEffect 	= gameObject.transform:Find('curOperatPlateEffect');
    gameUIObjects.operation_mask		= gameObject.transform:Find("operationMask");
    gameUIObjects.dismissTypeTip		= gameObject.transform:Find("dismissTypeTip");
    gameUIObjects.ButtonSlow 		    = gameObject.transform:Find('control/ButtonSlow')
	gameUIObjects.SlowLabel 		    = gameObject.transform:Find('control/ButtonSlow/Label')
    gameUIObjects.ButtonPause 			= gameObject.transform:Find('control/ButtonPause');
    gameUIObjects.ButtonFast 		    = gameObject.transform:Find('control/ButtonFast');
	gameUIObjects.FastLabel 		    = gameObject.transform:Find('control/ButtonFast/Label')
	gameUIObjects.ButtonBack 		    = gameObject.transform:Find('control/ButtonBack')
	gameUIObjects.ButtondismissBackType = gameObject.transform:Find('dismissTypeTip/Tip/dismissTypeTipBtn')
	gameUIObjects.ButtondismissPopType  = gameObject.transform:Find('dismissTypeTip/dismissTypeTipBtn')
	
end

function HNHSM_RePlayUILayer:GetESWNUI(gameObject)
    gameUIObjects.dipai 			    = gameObject.transform:Find('DiPai');
    for i=1,self.HNHSM_RePlayLogic:GetMaxPlayerSize() do
        gameUIObjects.ActivePlayerESWN[i] = gameObject.transform:Find("DiPai/DeskTimerIndex"..i);
    end
end

function HNHSM_RePlayUILayer:InitUILayer(roomData)
    print("InitUILayer was called----->.roomData.state"..tostring(roomData.state))
    self.roomData = roomData;
     print("InitUILayer,roomData.surplus"..tostring(roomData.surplus));
     -- 人物信息
    self:InitPlayerInfo(self.roomData);
    -- 房间信息
    self:InitRoomInfo(self.roomData);
    -- 手牌信息
    self:InitAllGrids(self.roomData);
    --东南西北
    self:InitESWNInfo(self.roomData);

    HNHSM_RePlayEventBind.Init(self,gameUIObjects,self.HNHSM_RePlayLogic);--绑定事件
    self:InitControls();
    self:StartPlay();--开始播放


end

function HNHSM_RePlayUILayer:InitRoomInfo(roomData)
    --获取主题颜色
	bgColor 	= UnityEngine.PlayerPrefs.GetInt('bgColor_hnhsm', 1);
	cardColor 	= UnityEngine.PlayerPrefs.GetInt('cardColor_hnhsm', 1);
    cardText 	= UnityEngine.PlayerPrefs.GetInt('cardText_hnhsm', 1);
    language 	= UnityEngine.PlayerPrefs.GetInt('language_hnhsm', 1);
    coroutine.start(RefreshTime,gameUIObjects.roomTime:GetComponent("UILabel"),60);
    coroutine.start(RefreshPhoneState,self.gameObject,self.HNHSM_RePlayLogic,gameUIObjects.batteryLevel,gameUIObjects.network);
    gameUIObjects.roomID:GetComponent("UILabel").text                       = self.roomData.roomNumber;
    gameUIObjects.waitRoomID:GetComponent("UILabel").text                   = self.roomData.roomNumber;
    gameUIObjects.roomSetting:Find('Label'):GetComponent('UILabel').text    = GetHNHSMRuleText(roomData.setting,false,false);
    gameUIObjects.gameTypeobj:Find("playName"):GetComponent("UILabel").text = roomData.playName;
    self:SetInviteVisiable(false);
    self:HideWaittingUI();
    print("roomData.waitOperate"..tostring(self.roomData.waitOperate));
    --游戏开始时是否显示蹲拉跑
    -- print("mySeat:"..self.HNHSM_RePlayLogic.mySeat);
    -- print("completeChooce:"..self.HNHSM_RePlayLogic:GetPlayerDataBySeat(self.HNHSM_RePlayLogic.mySeat).completeChooce);
    -- print("bankerSeat:"..self.roomData.bankerSeat)
    -- if self.HNHSM_RePlayLogic:GetPlayerDataBySeat(self.HNHSM_RePlayLogic.mySeat).completeChooce == 1 then 
    --     PanelManager.Instance:ShowWindow("panelBetOn",{seat = self.HNHSM_RePlayLogic.mySeat,isBanker = self.HNHSM_RePlayLogic:IsBanker()})
    -- end 
    gameUIObjects.curOperatPlateEffect.gameObject:SetActive(false);


end


function HNHSM_RePlayUILayer:InitPlayerInfo(roomData)
    -- print("InitPlayerInfo------------------------------------>");
    self:AutoRegisterPlayerView(roomData.seat,roomData.setting.size);
    self:SetPlayerPos(roomData);
    DestroyRoomData.roomData 	    = roomData;
    DestroyRoomData.playerData      = self.HNHSM_RePlayLogic:GetPlayerDatas();
    DestroyRoomData.mySeat 		    = self.HNHSM_RePlayLogic.mySeat;

end

function HNHSM_RePlayUILayer:InitAllGrids(roomData)
    --隐藏所有的grid
    for i=1,#gameUIObjects.playerViews do
        gameUIObjects.playerViews[i].hnhsm_GridTool:HideAllGrid();
    end

    if self.roomData.state == self.nmm_pb.GAMING then 
        self:RefreshAllGrid();
        self:SetActivePlayer(self.roomData);
        self:SetGameTypePos();
    end
    --显示玩家的操作
    -- print("mySeat:"..tostring(self.HNHSM_RePlayLogic.mySeat));
    -- print("playerdatas.length:"..self.HNHSM_RePlayLogic:GetPlayerDataLength());
    local myData = self.HNHSM_RePlayLogic:GetPlayerDataBySeat(self.HNHSM_RePlayLogic.mySeat);
    -- print("myoperations.length:"..#myData.operations);
    self:RefreshOperationSend(myData.operations,myData);
    --处理听牌
    local myData        = self.HNHSM_RePlayLogic:GetPlayerDataBySeat(self.HNHSM_RePlayLogic.mySeat);
    local myRealIndex   = self.HNHSM_RePlayLogic:GetCorrectUIIndex(self.HNHSM_RePlayLogic:GetPlayerViewIndexBySeat(myData.seat));
    local myPlayerView  = gameUIObjects.playerViews[myRealIndex];
   

end

function HNHSM_RePlayUILayer:SetGameTypePos()
	if gameUIObjects.roomSetting.gameObject.activeSelf then
		gameUIObjects.roomSetting.localPosition = Vector3.New(-4,141,0);
	else
		gameUIObjects.roomSetting.localPosition = Vector3.New(-4,102,0);
	end
end

function HNHSM_RePlayUILayer:InitESWNInfo(roomData)
    gameUIObjects.dipai.gameObject:SetActive(false);
    self:SetDipaiNum(roomData.surplus);
    self:SetRoundNum(roomData.round);
    gameUIObjects.dipai.gameObject:SetActive(HNHSM_PlayLogic.NeedShowDiPai(self.roomData,self.HNHSM_RePlayLogic));
    gameUIObjects.roomRound.gameObject:SetActive(HNHSM_PlayLogic.NeedShowDiPai(self.roomData,self.HNHSM_RePlayLogic));
    self:SetActivePlayer(self.roomData);
end


function HNHSM_RePlayUILayer:SetPlayerPos(roomData)
    --设置座位位置
    for i=1,#gameUIObjects.playerViews do
        local playerView =  gameUIObjects.playerViews[i];
        playerView:SetPos(roomData.state  ~= self.nmm_pb.GAMING and (self.HNHSM_RePlayLogic.totalSize < roomData.setting.size or roomData.round == 1) );
        playerView:NeedHideSelf(roomData.setting.size);
    end
end


--刷新所有grid
function HNHSM_RePlayUILayer:RefreshAllGrid( )
    -- body
    -- print("RefreshAllGrid------------->")
    self.HNHSM_RePlayLogic:ForeachPlayerDatas(function(playerView,_) 
        playerView.hnhsm_GridTool:SetLayOut();
    end);
    self:RefreshAllGridXi();
    self:RefreshAllGridHand();
    self:RefreshAllGridMoPai();
    self:RefreshAllGridThrow();
end

--刷新手牌
function HNHSM_RePlayUILayer:RefreshAllGridHand()
    -- print("RefreshAllGridHand----------->")
    self.HNHSM_RePlayLogic:ForeachPlayerDatas(function(playerView,playerData) 
        -- print("playerName:"..playerData.name..",seat:"..playerData.seat..",mahjongs.length:"..(#playerData.mahjongs));
        playerView.hnhsm_GridTool.gridHand.gameObject:SetActive(true);
        playerView.hnhsm_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
        playerView.hnhsm_GridTool:GridHandPlatesDown(playerData.mahjongs,playerData.mahjongs);
    end);
end

--刷新喜牌
function HNHSM_RePlayUILayer:RefreshAllGridXi()
    -- print("RefreshAllGridXi----------->")
    self.HNHSM_RePlayLogic:ForeachPlayerDatas(function(playerView,playerData) 
        playerView.hnhsm_GridTool.gridXi.gameObject:SetActive(true);
        playerView.hnhsm_GridTool:RefreshGridXi(playerData.operationCards);
    end);
end

--刷新带出去的牌
function HNHSM_RePlayUILayer:RefreshAllGridThrow()
    -- print("RefreshAllGridThrow----------->")
    self.HNHSM_RePlayLogic:ForeachPlayerDatas(function(playerView,playerData) 
        playerView.hnhsm_GridTool.gridThrow.gameObject:SetActive(true);
        playerView.hnhsm_GridTool:RefreshGridThrow(playerData.paiHe);
    end);
end

--刷新摸牌
function HNHSM_RePlayUILayer:RefreshAllGridMoPai()
    -- print("RefreshAllGridMoPai----------->")
    self.HNHSM_RePlayLogic:ForeachPlayerDatas(function(_,playerData) 
        local playerView = gameUIObjects.playerViews[self.HNHSM_RePlayLogic:GetCorrectUIIndex(self.HNHSM_RePlayLogic:GetPlayerViewIndexBySeat(playerData.seat))];
        playerView.hnhsm_GridTool.gridMo.gameObject:SetActive(playerData.moMahjong ~= -1);
        playerView.hnhsm_GridTool:RefreshMoPai(playerData.moMahjong);
    end);
end

function HNHSM_RePlayUILayer:AutoRegisterPlayerView(mySeat, size)
     for i = 1, self.HNHSM_RePlayLogic:GetMaxPlayerSize() do
        gameUIObjects.playerViews[i]:OpenView();
        self.HNHSM_RePlayLogic:RegisterPlayerView(gameUIObjects.playerViews[i]);
    end
    self.HNHSM_RePlayLogic:ResetAllPlayerView();
end

function HNHSM_RePlayUILayer:SetRoundStart( data )
    -- body
    -- print("SetRoundStart was called");
    self:RefreshAllGrid();
    self:RefreshPlayer();
    self:SetRoomInfo(self.roomData);
    self:SetActivePlayer(self.roomData);
    self:SetPlayerPos(self.roomData);
    self:SetInviteVisiable(false);
    self:HideWaittingUI();
    
end

function HNHSM_RePlayUILayer:SetRoomInfo(roomData)
    self:SetDipaiNum(roomData.surplus);
    self:SetRoundNum(roomData.round);
end
function HNHSM_RePlayUILayer:SetGameRoundEnd( RoundEndData )
    -- body
    RoundEndData.uiLayer = self;
    PanelManager.Instance:ShowWindow("panelStageClear_hnhsm",RoundEndData)
    PanelManager.Instance:HideWindow("panelChat");
    PanelManager.Instance:HideWindow("panelGameSetting_hnhsm");
    self.HNHSM_RePlayLogic:ResetGameState();
    self:SetDipaiNum(self.roomData.surplus);
    self:SetRoundNum(self.roomData.round);
    self:ClearUI();
end

--清除一些UI上的状态
function HNHSM_RePlayUILayer:ClearUI()
    -- body
    --1.时钟
    gameUIObjects.dipai:Find("timer"):GetComponent("UILabel").text = 0;
    HNHSM_Tools.StopCount(gameUIObjects.dipai:Find("timer"));
    --2.操作列表
    gameUIObjects.operation_send.gameObject:SetActive(false);
end

--刷新所有UI
function HNHSM_RePlayUILayer:RefreshAllUI()

end

function HNHSM_RePlayUILayer:RefreshPlayer()
    self.HNHSM_RePlayLogic:ForeachPlayerDatas(function(_,playerData)
        local playerView = gameUIObjects.playerViews[self.HNHSM_RePlayLogic:GetCorrectUIIndex(self.HNHSM_RePlayLogic:GetPlayerViewIndexBySeat(playerData.seat))]; 
        playerView:SetReady(playerData.ready and self.roomData.state == self.nmm_pb.WAITING);
        playerView:ResetView(playerData);
        playerView:SetOnlyOfflineFlag(not playerData.connected);
    end);
    
end



function HNHSM_RePlayUILayer:SetActivePlayer(roomData)
    self:ShowWaitOpreatEffect(roomData.activeSeat,roomData.state == self.nmm_pb.GAMING);
    for i=1,#gameUIObjects.playerViews do
        gameUIObjects.playerViews[i]:SetActiveFlag(false);
    end
    local playerView = gameUIObjects.playerViews[self.HNHSM_RePlayLogic:GetCorrectUIIndex(self.HNHSM_RePlayLogic:GetPlayerViewIndexBySeat(roomData.activeSeat))];
    playerView:SetActiveFlag(true and roomData.state == self.nmm_pb.GAMING);
end

function HNHSM_RePlayUILayer:GetOverTrusteeship()
    local Trusteeships={}
    for i = 0, self.roomData.setting.size-1 do
        local playerView = gameUIObjects.playerViews[self.HNHSM_RePlayLogic:GetCorrectUIIndex(self.HNHSM_RePlayLogic:GetPlayerViewIndexBySeat(i))];
        Trusteeships[i] = playerView.trusteeshipFlag.gameObject.activeSelf;
    end
    return Trusteeships;
end

function HNHSM_RePlayUILayer:ChangePaiSize(hnhsmPaiSize)

end


function HNHSM_RePlayUILayer:SetGameRoundOver(RoundAllData)

    local overData = {};
    overData.RoundAllData   = RoundAllData;
    overData.roomInfo       = roomInfo;
    -- print("RoundAllData.data.complete:"..tostring(RoundAllData.data.complete)..",self.HNHSM_RePlayLogic.hasStageClear:"..tostring(self.HNHSM_RePlayLogic.hasStageClear));
    if not RoundAllData.data.complete and not self.HNHSM_RePlayLogic.hasStageClear then 
        PanelManager.Instance:ShowWindow("panelStageClearAll_hnhsm",overData);
        PanelManager.Instance:HideWindow("panelChat");
        PanelManager.Instance:HideWindow("panelGameSetting_hnhsm");
    end
    self:ClearUI();
end


function HNHSM_RePlayUILayer.Update(obj)
    -- print("Update-------------------->");
   
end

--玩家摸牌
function HNHSM_RePlayUILayer:SetPlayerMoPai(moData)
    --先隐藏所有的摸牌的grid
    for i=1,#gameUIObjects.playerViews do
        gameUIObjects.playerViews[i].hnhsm_GridTool:SetGridMoVisible(false);
    end
    local playerView = gameUIObjects.playerViews[self.HNHSM_RePlayLogic:GetCorrectUIIndex(self.HNHSM_RePlayLogic:GetPlayerViewIndexBySeat(moData.seat))];
    local playerData = self.HNHSM_RePlayLogic:GetPlayerDataBySeat(moData.seat);
    --显示当前玩家的摸牌的grid
    playerView.hnhsm_GridTool:SetGridMoVisible(true);
    self:SetDipaiNum(self.roomData.surplus);
    playerView.hnhsm_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
    playerView.hnhsm_GridTool:GridHandPlatesDown(playerData.mahjongs,playerData.mahjongs);
    playerView.hnhsm_GridTool:RefreshMoPai(playerData.moMahjong);
    playerView.hnhsm_GridTool:MoPaiDown(playerData.moMahjong,playerData.mahjongCount);
   
    self:SetActivePlayer(self.roomData);
    if moData.operation and #moData.operation>0 then 
        for i=1,#moData.operation do
            if moData.operation[i].seat == self.HNHSM_RePlayLogic.mySeat then 
                self:RefreshOperationSend(moData.operation[i].operation,playerData);
            end
        end
    end
    
end

--玩家出牌
function HNHSM_RePlayUILayer:SetPlayerChuPai(chuData)
    -- print("player.seat"..chuData.seat.." chu pai,plate="..chuData.mahjong);
    local playerView    = gameUIObjects.playerViews[self.HNHSM_RePlayLogic:GetCorrectUIIndex(self.HNHSM_RePlayLogic:GetPlayerViewIndexBySeat(chuData.seat))];
    local playerData    = self.HNHSM_RePlayLogic:GetPlayerDataBySeat(chuData.seat);
    local myData        = self.HNHSM_RePlayLogic:GetPlayerDataBySeat(self.HNHSM_RePlayLogic.mySeat);
    playerView.hnhsm_GridTool:RefreshGridThrow(playerData.paiHe);
    playerView.hnhsm_GridTool:SetGridMoVisible(false);
    self:SetPlayerChuPaiShow(chuData.seat,chuData.mahjong);
    self:SetLastPlayerChuPaiEffect(chuData.seat);
    if chuData.seat == self.HNHSM_RePlayLogic.mySeat then 
        playerView.hnhsm_GridTool:SetGridMoVisible(false);
    end
    playerView.hnhsm_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
    playerView.hnhsm_GridTool:GridHandPlatesDown(playerData.mahjongs,playerData.mahjongs);
    AudioManager.Instance:PlayAudio(self:GetAudioPrefix()..(playerData.sex==1 and 'man' or 'woman')..math.floor(chuData.mahjong / 9 + 1)..(chuData.mahjong % 9 + 1))
    if chuData.operation and #chuData.operation>0 then 
        for i=1,#chuData.operation do
            if chuData.operation[i].seat == self.HNHSM_RePlayLogic.mySeat then 
                self:RefreshOperationSend(chuData.operation[i].operation,playerData);
            end
        end
    end
    
end

--玩家吃牌
function HNHSM_RePlayUILayer:SetPlayerChiPai(chiData)
    --1.显示特效
    local realIndex     = self.HNHSM_RePlayLogic:GetCorrectUIIndex(self.HNHSM_RePlayLogic:GetPlayerViewIndexBySeat(chiData.seat));
    local outRealIndex  = self.HNHSM_RePlayLogic:GetCorrectUIIndex(self.HNHSM_RePlayLogic:GetPlayerViewIndexBySeat(chiData.outSeat));
    local playerView    = gameUIObjects.playerViews[realIndex];
    local playerData    = self.HNHSM_RePlayLogic:GetPlayerDataBySeat(chiData.seat);
    local outPlayerData = self.HNHSM_RePlayLogic:GetPlayerDataBySeat(chiData.outSeat);
    local outPlayerView = gameUIObjects.playerViews[outRealIndex];
    effManger.ShowEffect(self.gameObject,"chi",gameUIObjects.playerHupaiPos[realIndex]);
    --2.刷新喜牌
    playerView.hnhsm_GridTool:RefreshGridXi(playerData.operationCards);
    --3.刷新牌桌上的牌
    outPlayerView.hnhsm_GridTool:RefreshGridThrow(outPlayerData.paiHe);
    --4.刷新手牌
    playerView.hnhsm_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
    --8.刷新当前出牌玩家
    self:SetActivePlayer(self.roomData);
    AudioManager.Instance:PlayAudio(self:GetAudioPrefix()..(playerData.sex==1 and 'man' or 'woman').."_chi");
    --9.隐藏最后出牌的指示器
    gameUIObjects.curOperatPlateEffect.gameObject:SetActive(false);
end

--玩家碰牌
function HNHSM_RePlayUILayer:SetPlayerPengPai(pengData)
    local realIndex     = self.HNHSM_RePlayLogic:GetCorrectUIIndex(self.HNHSM_RePlayLogic:GetPlayerViewIndexBySeat(pengData.seat));
    local outRealIndex  = self.HNHSM_RePlayLogic:GetCorrectUIIndex(self.HNHSM_RePlayLogic:GetPlayerViewIndexBySeat(pengData.outSeat));
    local playerView    = gameUIObjects.playerViews[realIndex];
    local playerData    = self.HNHSM_RePlayLogic:GetPlayerDataBySeat(pengData.seat);
    local outPlayerData = self.HNHSM_RePlayLogic:GetPlayerDataBySeat(pengData.outSeat);
    local outPlayerView = gameUIObjects.playerViews[outRealIndex];
    --显示特效
    effManger.ShowEffect(self.gameObject,"peng",gameUIObjects.playerHupaiPos[realIndex]);
    playerView.hnhsm_GridTool:RefreshGridXi(playerData.operationCards);
    outPlayerView.hnhsm_GridTool:RefreshGridThrow(outPlayerData.paiHe);
    playerView.hnhsm_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
    playerView.hnhsm_GridTool:GridHandPlatesDown(playerData.mahjongs,playerData.mahjongs);
    
    self:SetActivePlayer(self.roomData);
    AudioManager.Instance:PlayAudio(self:GetAudioPrefix()..(playerData.sex==1 and 'man' or 'woman').."_peng");
    gameUIObjects.curOperatPlateEffect.gameObject:SetActive(false);

    if pengData.seat == self.HNHSM_RePlayLogic.mySeat then 
        self:PlayerSelectOperation("peng");
    else
        self:PlayerSelectOperation("guo");
    end

    if pengData.operation and #pengData.operation > 0 then 
        for i=1,#pengData.operation do
            if pengData.operation[i].seat == self.HNHSM_RePlayLogic.mySeat then 
                self:RefreshOperationSend(pengData.operation[i].operation,playerData);
            end
        end
    end
end

--玩家杠牌
function HNHSM_RePlayUILayer:SetPlayerGangPai(gangData)
    --显示特效
    -- print("SetPlayerGangPai was called------------------------------");
    local realIndex     = self.HNHSM_RePlayLogic:GetCorrectUIIndex(self.HNHSM_RePlayLogic:GetPlayerViewIndexBySeat(gangData.seat));
    local playerView    = gameUIObjects.playerViews[realIndex];
    local playerData    = self.HNHSM_RePlayLogic:GetPlayerDataBySeat(gangData.seat);
    effManger.ShowEffect(self.gameObject,self:GetGangEffectString(gangData.gangType),gameUIObjects.playerHupaiPos[realIndex]);
    playerView.hnhsm_GridTool:RefreshGridXi(playerData.operationCards);
    playerView.hnhsm_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
    playerView.hnhsm_GridTool:GridHandPlatesDown(playerData.mahjongs,playerData.mahjongs);
    if gangData.outSeat then 
        local outPlayerData = self.HNHSM_RePlayLogic:GetPlayerDataBySeat(gangData.outSeat);
        local outRealIndex  = self.HNHSM_RePlayLogic:GetCorrectUIIndex(self.HNHSM_RePlayLogic:GetPlayerViewIndexBySeat(gangData.outSeat));
        local outPlayerView = gameUIObjects.playerViews[outRealIndex];
        outPlayerView.hnhsm_GridTool:RefreshGridThrow(outPlayerData.paiHe);
    end
    playerView.hnhsm_GridTool:SetGridMoVisible(false);
    self:SetActivePlayer(self.roomData);
    AudioManager.Instance:PlayAudio(self:GetAudioPrefix()..(playerData.sex==1 and 'man' or 'woman').."_gang");
    gameUIObjects.curOperatPlateEffect.gameObject:SetActive(false);

    if gangData.seat == self.HNHSM_RePlayLogic.mySeat then 
        self:PlayerSelectOperation("gang");
    else
        self:PlayerSelectOperation("guo");
    end

    if gangData.operation and #gangData.operation > 0 then 
        for i=1,#gangData.operation do
            if gangData.operation[i].seat == self.HNHSM_RePlayLogic.mySeat then 
                self:RefreshOperationSend(gangData.operation[i].operation,playerData);
            end
        end
    end

end

--获取杠牌特效字符串
function HNHSM_RePlayUILayer:GetGangEffectString(gangType)
    if gangType == self.nmm_pb.MING then 
        return "mg";
    elseif gangType == self.nmm_pb.AN then 
        return "ag";
    elseif gangType == self.nmm_pb.DIAN then 
        return "gang";
    end
    return "unknow";
end

--玩家补牌
function HNHSM_RePlayUILayer:SetPlayerBuPai(buData)
    -- print("SetPlayerBuPai was called----------------------->");
end

--玩家过牌
function HNHSM_RePlayUILayer:SetPlayerGuoPai(guoData)
    -- print("SetPlayerGuoPai was called------------------------>");
    -- if guoData.seat == self.HNHSM_RePlayLogic.mySeat then 
       
    -- end
    self:PlayerSelectOperation("guo");

end

--玩家胡牌
function HNHSM_RePlayUILayer:SetPlayerHuPai(huData)
    -- print("SetPlayerHuPai was called-------------------------->");
    local realIndex = self.HNHSM_RePlayLogic:GetCorrectUIIndex(self.HNHSM_RePlayLogic:GetPlayerViewIndexBySeat(huData.seat));
    local playerView = gameUIObjects.playerViews[realIndex];
    local playerData = self.HNHSM_RePlayLogic:GetPlayerDataBySeat(huData.seat);
    -- print("huData.seat:"..huData.seat..",huData.outSeat:"..huData.outSeat);
    if huData.seat == huData.outSeat then 
        AudioManager.Instance:PlayAudio(self:GetAudioPrefix()..(playerData.sex == 1 and "man_" or "woman_").."zimo");
	    effManger.ShowEffect(self.gameObject, 'zm', gameUIObjects.playerHupaiPos[realIndex]);
    else
        AudioManager.Instance:PlayAudio(self:GetAudioPrefix()..(playerData.sex == 1 and "man_" or "woman_").."hu");
        effManger.ShowEffect(self.gameObject, 'hu', gameUIObjects.playerHupaiPos[realIndex]);
        self:SetPao(huData);
    end

    playerView.hnhsm_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
    playerView.hnhsm_GridTool:GridHandPlatesDown(playerData.mahjongs,playerData.mahjongs);
    if huData.seat == huData.outSeat then 
        playerView.hnhsm_GridTool:RefreshMoPai(playerData.moMahjong);
        playerView.hnhsm_GridTool:MoPaiDown(playerData.moMahjong,playerData.mahjongCount);
    end
    -- print("huData.seat:"..huData.seat..",self.HNHSM_RePlayLogic.mySeat:"..self.HNHSM_RePlayLogic.mySeat);
    if huData.seat == self.HNHSM_RePlayLogic.mySeat then 
        self:PlayerSelectOperation("hu");
    else
        self:PlayerSelectOperation("guo");
    end
end


function HNHSM_RePlayUILayer:SetPao(winData)
    -- print("SetPao was called------------->");
	if winData.outSeat < 0 then
		return;
    end
    local isFangPao = true;
    local winCount = 0;
    for i=1,#self.roomData.roundEnd.players do
        local playerData = self.roomData.roundEnd.players[i];
        if playerData.endBaseScore > 0 then 
            winCount = winCount + 1;
        end
    end
    -- print("SetPao---------->winCount:"..winCount);
    isFangPao = winCount < 2 ;
    local realIndex = self.HNHSM_RePlayLogic:GetCorrectUIIndex(self.HNHSM_RePlayLogic:GetPlayerViewIndexBySeat(winData.outSeat));
	if isFangPao  then -- 放炮
        -- print("fp-------------->1");
		effManger.ShowEffect(self.gameObject, 'fp', gameUIObjects.playerHupaiPos[realIndex]);
	else -- 通炮
		-- print("tp-------------->2");
		effManger.ShowEffect(self.gameObject, 'tp', gameUIObjects.playerHupaiPos[realIndex]);
    end
end

function HNHSM_RePlayUILayer:GetgameUIObjects()
    return gameUIObjects;
end


--根据背景设置文字颜色
function HNHSM_RePlayUILayer:SetGameColor(bgIndex)
    gameUIObjects.dipai:Find("frame/roundHead"):GetComponent("UILabel").color           = self:getAccorColor(color);
	gameUIObjects.dipai:Find("frame/roundHead/roundTail"):GetComponent("UILabel").color = self:getAccorColor(color);
	gameUIObjects.roomRound:GetComponent("UILabel").color                               = self:getNumColor(color);
	gameUIObjects.dipai:Find("frame/leftHead"):GetComponent("UILabel").color            = self:getAccorColor(color);
	gameUIObjects.dipai:Find("frame/leftHead/leftTail"):GetComponent("UILabel").color   = self:getAccorColor(color);
	gameUIObjects.dipai:Find('frame/leftCard'):GetComponent('UILabel').color            = self:getNumColor(color);
end

function HNHSM_RePlayUILayer:getAccorColor(color)
	if color == 1 then
		return Color.New(57/255,123/255,174/255);
	else
		return Color.New(52/255,209/255,186/255);
	end
end

function HNHSM_RePlayUILayer:getNumColor(color)
	if color == 1 then
		return Color.New(76/255,189/255,197/255);
	else
		return Color.New(205/255,220/255,114/255);
	end
end

--选择背景
function HNHSM_RePlayUILayer:ChooseBG(bgIndex)
    -- print("ChooseBG:"..bgIndex);
    for i = 1,BgColorNum do
		local bg = self.gameObject.transform:Find('gameBGs/bg'..i);
		if bgIndex == i then 
			bg.gameObject:SetActive(true);
		else
			bg.gameObject:SetActive(false);
		end
	end
	self:SetGameColor(bgIndex);
end


--设置东南西北旁边的局数数目
function HNHSM_RePlayUILayer:SetRoundNum(num)
    -- print("SetRoundNum------------------>was called,num:"..tostring(num));
    gameUIObjects.roomRound:GetComponent("UILabel").text = num..'/'..self.roomData.setting.rounds;
end

--设置底牌的剩余数目
function HNHSM_RePlayUILayer:SetDipaiNum(num)
    gameUIObjects.dipai:Find('frame/leftCard'):GetComponent('UILabel').text = string.format('%d', num);
end

--设置邀请好友，解散房间，分享按钮的显示和隐藏
function HNHSM_RePlayUILayer:SetInviteVisiable(show)
    if not PlatformManager.Instance:IsWXAppInstalled() then
		show = false
    end
end

--显示出牌的状态，东西南北，哪个该出牌了
--当前该出牌的玩家
function HNHSM_RePlayUILayer:ShowWaitOpreatEffect(activeSeat,show)
    -- print("ShowWaitOpreatEffect,activeSeat="..tostring(activeSeat)..",show="..tostring(show));
    --先隐藏所有
    for i=1,self.HNHSM_RePlayLogic:GetMaxPlayerSize() do
        self:SetESWNState(i,false);
    end
    
    for i=1,self.HNHSM_RePlayLogic.totalSize do
        local index = self.HNHSM_RePlayLogic:GetPlayerViewIndexBySeat(activeSeat);
        self:SetESWNState(self.HNHSM_RePlayLogic:GetCorrectUIIndex(index),show);
    end
    --倒计时
    if show then 
        HNHSM_Tools.CountDown(gameUIObjects.dipai:Find("timer"),15,0);
    end
end


function HNHSM_RePlayUILayer:SetESWNState(index,show)	gameUIObjects.ActivePlayerESWN[index]:Find('select').gameObject:SetActive(show);
   gameUIObjects.ActivePlayerESWN[index]:Find('frame').gameObject:SetActive(show);
   gameUIObjects.ActivePlayerESWN[index]:Find('unselect').gameObject:SetActive(not show);
   gameUIObjects.playerViews[index]:SetActiveFlag(show);
   
end


--显示等待的时候需要显示的UI，隐藏游戏进行中的UI
function HNHSM_RePlayUILayer:ShowWaittingUI()
    -- print("ShowWaittingUI-------------->was called");
    gameUIObjects.dipai.gameObject:SetActive(HNHSM_PlayLogic.NeedShowDiPai(self.roomData,self.HNHSM_RePlayLogic));
    gameUIObjects.roomSetting.gameObject:SetActive(true);
    gameUIObjects.roomSetting:Find("roominfo").gameObject:SetActive(false);
    gameUIObjects.roomRound.gameObject:SetActive(HNHSM_PlayLogic.NeedShowDiPai(self.roomData,self.HNHSM_RePlayLogic));
    self:SetGameTypePos();
end

--隐藏等待时显示的UI，显示游戏进行中的UI
function HNHSM_RePlayUILayer:HideWaittingUI()
    -- print("HideWaittingUI---------------was called");
    -- print("NeedShowDiPai:"..tostring(HNHSM_PlayLogic.NeedShowDiPai(self.roomData,self.HNHSM_RePlayLogic)));
    gameUIObjects.roomSetting.gameObject:SetActive(true);
    gameUIObjects.roomSetting:Find("roominfo").gameObject:SetActive(false);
    gameUIObjects.dipai.gameObject:SetActive(HNHSM_PlayLogic.NeedShowDiPai(self.roomData,self.HNHSM_RePlayLogic));
    gameUIObjects.roomRound.gameObject:SetActive(HNHSM_PlayLogic.NeedShowDiPai(self.roomData,self.HNHSM_RePlayLogic));
    self:SetGameTypePos();
end




function HNHSM_RePlayUILayer:getCardColor()
    return cardColor;
end

function HNHSM_RePlayUILayer:getcardText()
    return cardText;
end

function HNHSM_RePlayUILayer:GetAudioPrefix()
    return language == 1 and "" or "fy_";
end

----根据颜色值获取麻将背板图片
function HNHSM_RePlayUILayer:getColorCardName(name,colorIndex)
    if colorIndex == 1 then --绿色
		return name;
	elseif colorIndex == 2 then --黄色
		return name..'y';
	end
end

--根据用户选择选择麻将的牌面
function HNHSM_RePlayUILayer:GetCardTextName(plateIndex,cardTextIndex)
    return tostring(plateIndex);
end

--根据用户的选择选择牌面大小
function HNHSM_RePlayUILayer:GetCardPlateSize(plateIndex,cardTextIndex)
    -- print("GetCardPlateSize------was called,plateIndex="..tostring(plateIndex)..",cardTextIndex="..cardTextIndex);
    if cardTextIndex == 2 then 
		return CONST.cardStandWanScaleWidth[2];
	else
		if plateIndex <= 8 then 
			return CONST.cardStandWanScaleWidth[1];
		else
			return CONST.cardStandTongTiaoScaleWidth[1];
		end
	end
end

function HNHSM_RePlayUILayer:SetPlateColor(throwItemobj,showColor)
    if showColor then
		throwItemobj:GetComponent("UISprite").color = Color(255/255,222/255,84/255);
	else
		throwItemobj:GetComponent("UISprite").color = Color(255/255,255/255,255/255);
	end
end

--设置玩家出牌展示
function HNHSM_RePlayUILayer:SetPlayerChuPaiShow(seat,mahjong)
     local playerView = gameUIObjects.playerViews[self.HNHSM_RePlayLogic:GetCorrectUIIndex(self.HNHSM_RePlayLogic:GetPlayerViewIndexBySeat(seat))];
     playerView.hnhsm_GridTool:RefreshChuPai(mahjong);
end

--设置箭头指向最后一个玩家出的牌
function HNHSM_RePlayUILayer:SetLastPlayerChuPaiEffect(seat)
    local playerView = gameUIObjects.playerViews[self.HNHSM_RePlayLogic:GetCorrectUIIndex(self.HNHSM_RePlayLogic:GetPlayerViewIndexBySeat(seat))];
    local playerData = self.HNHSM_RePlayLogic:GetPlayerDataBySeat(seat);
    gameUIObjects.curOperatPlateEffect.gameObject:SetActive(true);
    StartCoroutine(function() 
        WaitForEndOfFrame();
         gameUIObjects.curOperatPlateEffect.position = playerView.hnhsm_GridTool.gridThrow:GetChild(#playerData.paiHe-1).position;
    end);

end

--刷新玩家吃碰杠补等操作
function HNHSM_RePlayUILayer:RefreshOperationSend(operations,playerData)
    if operations == nil or playerData == nil then 
        return;
    end
    if self.optionCoroutine ~= nil then 
        StopCoroutine(self.optionCoroutine);
        self.optionCoroutine = nil;
    end
    self:ResetOperationTween();
    --1.刷新该显示的按钮
    self:SetOperationButtons(operations);
end

--设置操作按钮的显示
function HNHSM_RePlayUILayer:SetOperationButtons(operations)
    gameUIObjects.operation_send.gameObject:SetActive(#operations ~= 0);
    gameUIObjects.ButtonHu.gameObject:SetActive(false);
	gameUIObjects.ButtonGang.gameObject:SetActive(false);
	gameUIObjects.ButtonPeng.gameObject:SetActive(false);
	gameUIObjects.ButtonChi.gameObject:SetActive(false);
	gameUIObjects.ButtonGuo.gameObject:SetActive(true);
    gameUIObjects.ButtonBu.gameObject:SetActive(false);
    for i=1,#operations do
        if operations[i] == self.nmm_pb.CHI then 
            gameUIObjects.ButtonChi.gameObject:SetActive(true);
        elseif operations[i] == self.nmm_pb.PENG then
            gameUIObjects.ButtonPeng.gameObject:SetActive(true); 
        elseif operations[i] == self.nmm_pb.GANG then 
            gameUIObjects.ButtonGang.gameObject:SetActive(true);
        elseif operations[i] == self.nmm_pb.BU then 
            gameUIObjects.ButtonBu.gameObject:SetActive(true);
        elseif operations[i] == self.nmm_pb.HU then 
            gameUIObjects.ButtonHu.gameObject:SetActive(true);
        end
    end
    gameUIObjects.operation_send:GetComponent("UIGrid"):Reposition();
end

--玩家从操作列表中选择了操作
function HNHSM_RePlayUILayer:PlayerSelectOperation(operate)
	-- print("you choose "..operate);
	local tweenColor = nil;
	local tweenScale = nil;

	self:ResetOperationTween();
	local needWaitGuoHu = false;
	--1.播放选择动画
	if operate == "chi" then 
		tweenColor = gameUIObjects.ButtonChi:GetComponent("TweenColor");
		tweenScale = gameUIObjects.ButtonChi:GetComponent("TweenScale");
	elseif operate == "peng" then 
		tweenColor = gameUIObjects.ButtonPeng:GetComponent("TweenColor");
		tweenScale = gameUIObjects.ButtonPeng:GetComponent("TweenScale");
    elseif operate == "gang" then 
        print("Tween gang------------->");
		tweenColor = gameUIObjects.ButtonGang:GetComponent("TweenColor");
		tweenScale = gameUIObjects.ButtonGang:GetComponent("TweenScale");
	elseif operate == "bu" then 
		tweenColor = gameUIObjects.ButtonBu:GetComponent("TweenColor");
		tweenScale = gameUIObjects.ButtonBu:GetComponent("TweenScale");
	elseif operate == "hu" then 
		tweenColor = gameUIObjects.ButtonHu:GetComponent("TweenColor");
		tweenScale = gameUIObjects.ButtonHu:GetComponent("TweenScale");
	elseif operate == "guo" then 
		--过胡的时候要显示弹窗
		if gameUIObjects.ButtonHu.gameObject.activeInHierarchy then
			needWaitGuoHu = true;
		end
		tweenColor = gameUIObjects.ButtonGuo:GetComponent("TweenColor");
		tweenScale = gameUIObjects.ButtonGuo:GetComponent("TweenScale");
	end

	tweenColor.enabled = true;
	tweenScale.enabled = true;
	tweenColor:ResetToBeginning();
	tweenScale:ResetToBeginning();
	tweenColor:PlayForward();
    tweenScale:PlayForward();
    
    print("tweenColor.GameObject:"..tostring(tweenColor.gameObject));
    print("tweenScale.GameObject:"..tostring(tweenScale.gameObject));
    print("tweenScale.duration:"..tweenScale.duration);
    print("tweenScale.duration:"..tweenScale.duration);

	--2.关闭操作界面
	if self.optionCoroutine ~= nil then 
        StopCoroutine(self.optionCoroutine);
        self.optionCoroutine = nil;
	end
	self.optionCoroutine = StartCoroutine(function() 
		WaitForSeconds(tweenColor.duration+0.1);
		gameUIObjects.operation_send.gameObject:SetActive(false);
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
		panelMessageBox.VirtualOKClick(self.playInterval);
		coroutine.wait(self.playInterval);
	end
end

function HNHSM_RePlayUILayer:ResetOperationTween( )
	gameUIObjects.ButtonChi:GetComponent("TweenColor"):ResetToBeginning();
	gameUIObjects.ButtonChi:GetComponent("TweenScale"):ResetToBeginning();
	gameUIObjects.ButtonChi:GetComponent("TweenScale").enabled = false;
	gameUIObjects.ButtonChi:GetComponent("TweenColor").enabled = false;

	gameUIObjects.ButtonPeng:GetComponent("TweenColor"):ResetToBeginning();
	gameUIObjects.ButtonPeng:GetComponent("TweenScale"):ResetToBeginning();
	gameUIObjects.ButtonPeng:GetComponent("TweenScale").enabled = false;
	gameUIObjects.ButtonPeng:GetComponent("TweenColor").enabled = false;


	gameUIObjects.ButtonGang:GetComponent("TweenColor"):ResetToBeginning();
	gameUIObjects.ButtonGang:GetComponent("TweenScale"):ResetToBeginning();
	gameUIObjects.ButtonGang:GetComponent("TweenScale").enabled = false;
	gameUIObjects.ButtonGang:GetComponent("TweenColor").enabled = false;


	gameUIObjects.ButtonBu:GetComponent("TweenColor"):ResetToBeginning();
	gameUIObjects.ButtonBu:GetComponent("TweenScale"):ResetToBeginning();
	gameUIObjects.ButtonBu:GetComponent("TweenScale").enabled = false;
	gameUIObjects.ButtonBu:GetComponent("TweenColor").enabled = false;


	gameUIObjects.ButtonHu:GetComponent("TweenColor"):ResetToBeginning();
	gameUIObjects.ButtonHu:GetComponent("TweenScale"):ResetToBeginning();
	gameUIObjects.ButtonHu:GetComponent("TweenScale").enabled = false;
	gameUIObjects.ButtonHu:GetComponent("TweenColor").enabled = false;


	gameUIObjects.ButtonGuo:GetComponent("TweenColor"):ResetToBeginning();
	gameUIObjects.ButtonGuo:GetComponent("TweenScale"):ResetToBeginning();
	gameUIObjects.ButtonGuo:GetComponent("TweenScale").enabled = false;
	gameUIObjects.ButtonGuo:GetComponent("TweenColor").enabled = false;

	
end

function HNHSM_RePlayUILayer:StartPlay()
    -- print("start play records----------------->");
    if not self.roomData.records or #self.roomData.records == 0 then 
        -- print("not records to play");
        return;
    end
    if self.playCoroutine ~= nil then 
        coroutine.stop(self.playCoroutine);
    end
    
    self.playCoroutine = coroutine.start(function() 
        while self.gameObject.activeSelf do 
            -- print("di di di");
            if not self.isPause then 
                local record = self.roomData.records[self.playIndex];
                if self.playIndex > #self.roomData.records then
                    break;
                end 
                self.HNHSM_RePlayLogic:OnPlayerPlay(record);
                self.playIndex = self.playIndex + 1;
                print("当前进度 ",self.playIndex,"/",#self.roomData.records);
                if self.roomData.roundEnd and self.roomData.roundEnd~=nil then 
                    if self.playIndex > #self.roomData.records and #self.roomData.roundEnd.players > 0 then 
                        print(" replay round end!");
                        coroutine.wait(0.5);
                        self.HNHSM_RePlayLogic:OnGameRoundEnd(self.roomData.roundEnd);
                        break;
                    end
                end
                coroutine.wait(self.playInterval);
            else
                coroutine.wait(0.5);--这里之所以等待，是因为按了暂停键如果不等待，while循环会卡死
            end
        end

    end)

end

--初始化播放控件
function HNHSM_RePlayUILayer:InitControls()
    self.isPause            = false;
    self.playInterval       = 1.5;
    self.playIndex          = 1;
    self.rawSpeed           = self.playInterval;
    self.cutTime            = 0.25;
    gameUIObjects.ButtonPause:GetComponent('UIButton').normalSprite = 'zanting'
	gameUIObjects.FastLabel:GetComponent('UILabel').text = ''
    gameUIObjects.SlowLabel:GetComponent('UILabel').text = ''
end

function HNHSM_RePlayUILayer:PlaySlow()
    if self.playInterval + self.cutTime <= 2 then 
        self.playInterval = self.playInterval + self.cutTime;
    end
    local num = (self.rawSpeed - self.playInterval)/self.cutTime
	if num > 0 then
		gameUIObjects.FastLabel:GetComponent('UILabel').text = 'x'..num
		gameUIObjects.SlowLabel:GetComponent('UILabel').text = ''
	elseif num < 0 then
		gameUIObjects.FastLabel:GetComponent('UILabel').text = ''
		gameUIObjects.SlowLabel:GetComponent('UILabel').text = 'x'..math.abs(num)
	else 
		gameUIObjects.FastLabel:GetComponent('UILabel').text = ''
		gameUIObjects.SlowLabel:GetComponent('UILabel').text = ''
	end
end

function HNHSM_RePlayUILayer:PlayFast()
	if self.playInterval - self.cutTime >= 0.5 then
		self.playInterval = self.playInterval - self.cutTime
	end
	
	local num = (self.rawSpeed - self.playInterval)/self.cutTime
	if num > 0 then
		gameUIObjects.FastLabel:GetComponent('UILabel').text = 'x'..num
		gameUIObjects.SlowLabel:GetComponent('UILabel').text = ''
	elseif num <0 then
		gameUIObjects.FastLabel:GetComponent('UILabel').text = ''
		gameUIObjects.SlowLabel:GetComponent('UILabel').text = 'x'..math.abs(num)
	else 
		gameUIObjects.FastLabel:GetComponent('UILabel').text = ''
		gameUIObjects.SlowLabel:GetComponent('UILabel').text = ''
	end
end

function HNHSM_RePlayUILayer:PlayPause()
    self.isPause = not self.isPause
	if self.isPause then
		gameUIObjects.ButtonPause:GetComponent('UIButton').normalSprite = 'bofang'
	else
		gameUIObjects.ButtonPause:GetComponent('UIButton').normalSprite = 'zanting'
	end
end

function HNHSM_RePlayUILayer:ExitPlay()
    coroutine.stop(self.playCoroutine);
    self.playCoroutine = nil;
    self.HNHSM_RePlayLogic:ForeachPlayerDatas(function(playerView,playerData) 
        playerView:CloseView(); 
        playerView.hnhsm_GridTool:HideAllGrid();
    end);
    
    PanelManager.Instance:ShowWindow(self.roomData.backWinName);
	PanelManager.Instance:HideWindow(self.gameObject.name)
	PanelManager.Instance:HideWindow("panelStageClear_hnhsm");
	PanelManager.Instance:HideWindow("panelBetOn");
    AudioManager.Instance:PlayMusic('MainBG', true);
    self:InitControls();
end

function HNHSM_RePlayUILayer:SetDismissType(go)
    if go == gameUIObjects.ButtondismissBackType.gameObject then 
        gameUIObjects.dismissTypeTip:Find("Tip").gameObject:SetActive(false);
        gameUIObjects.ButtondismissPopType.gameObject:SetActive(true);
    elseif go == gameUIObjects.ButtondismissPopType.gameObject then 
        gameUIObjects.dismissTypeTip:Find("Tip/text"):GetComponent("UILabel").text = self.roomData.diss;
        gameUIObjects.dismissTypeTip:Find("Tip").gameObject:SetActive(true);
        gameUIObjects.ButtondismissPopType.gameObject:SetActive(false);
    end
end

--设置玩家的抓鱼分数
function HNHSM_RePlayUILayer:SetPlayerFish(data)
    if data.fishScoreBoard == nil then 
        print("fishScoreBoard--------is nil");
        return ;
    end
    -- print("data.fishScoreBoard.length"..#data.fishScoreBoard);
    for i=1,#data.fishScoreBoard do
        local realIndex = self.HNHSM_RePlayLogic:GetCorrectUIIndex(self.HNHSM_RePlayLogic:GetPlayerViewIndexBySeat(data.fishScoreBoard[i].seat));
        local playerView = gameUIObjects.playerViews[realIndex];
        local playerData = self.HNHSM_RePlayLogic:GetPlayerDataBySeat(data.fishScoreBoard[i].seat);
        -- print("player:"..playerData.name..".yuScore="..playerData.yuScore);
        playerView:SetFish(playerData.yuScore);
    end
end

--设置玩家分数
function HNHSM_RePlayUILayer:SetPlayerScore(data)
    if data.scoreBoard == nil then 
        print("scoreBoard---------is nil");
        return ;
    end
    -- print("data.scoreBoard.length="..#data.scoreBoard);
    --先清空之前的分数
    self.HNHSM_RePlayLogic:ForeachPlayerDatas(function(playerView,playerData) 
        local playerView = gameUIObjects.playerViews[self.HNHSM_RePlayLogic:GetCorrectUIIndex(self.HNHSM_RePlayLogic:GetPlayerViewIndexBySeat(playerData.seat))];
        playerView:UpdateScore(0);
    end);

    for i=1,#data.scoreBoard do
        local playerData    = self.HNHSM_RePlayLogic:GetPlayerDataBySeat(data.scoreBoard[i].seat);
        local realIndex     = self.HNHSM_RePlayLogic:GetCorrectUIIndex(self.HNHSM_RePlayLogic:GetPlayerViewIndexBySeat(data.scoreBoard[i].seat));
        local playerView    = gameUIObjects.playerViews[realIndex];
        playerData.score    = data.scoreBoard[i].score;
        -- print("data.scoreBoard["..i.."].score="..data.scoreBoard[i].score);
        playerView:UpdateScore(data.scoreBoard[i].score);
    end
end







