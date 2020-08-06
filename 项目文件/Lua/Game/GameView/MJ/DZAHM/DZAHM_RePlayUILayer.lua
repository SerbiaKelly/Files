require("DZAHM_Player");
require("DZAHM_GridTool");
require("DZAHM_PlayLogic");
require("DZAHM_RePlayEventBind");
require("DZAHM_Tools");
require("const");
require("effManger");
local gameUIObjects         = require("DZAHM_GameObjs");
local json                  = require("json");
DZAHM_RePlayUILayer         = class();


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






function DZAHM_RePlayUILayer:ctor(gameObject,DZAHM_RePlayLogic,game_pb)
    this                        = self;
    self.DZAHM_RePlayLogic      = DZAHM_RePlayLogic;
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

function DZAHM_RePlayUILayer:GetGameLogic()
    return self.DZAHM_RePlayLogic;
end


function DZAHM_RePlayUILayer:GetUIS(gameObject)
    gameUIObjects.CleanObjs();
    self:GetPlayersUI(gameObject);      --获得人物相关的UI
    self:GetRoomInfoUI(gameObject);     --房间信息
    self:GetButtons(gameObject);        --获得游戏中的各种按钮
    self:GetESWNUI(gameObject);         --房间信息self:GetESWNUI(gameObject);--获得桌子上东南西北那些UI
    
end

function DZAHM_RePlayUILayer:GetPlayersUI(gameObject)
    local maxPlayerSize = self.DZAHM_RePlayLogic:GetMaxPlayerSize();
    local gamers = gameObject.transform:Find("Gamers");
    for i=1,maxPlayerSize do
        local objectStr             = "Player"..i;
        local obj                   = gamers:Find(objectStr);
        local gridHand              = gameObject.transform:Find(objectStr.."_mj/GridHand");
        local gridXi                = gameObject.transform:Find(objectStr.."_mj/GridXi");
        local gridThrow             = gameObject.transform:Find(objectStr.."_mj/TabelThrow");
        local gridMo                = gameObject.transform:Find(objectStr.."_mj/MoPaiGrid");
        local chuPaiShow            = gameObject.transform:Find(objectStr.."_mj/chuPaiShow");
        local DZAHM_GridTool        = DZAHM_GridTool.New(gridHand,gridXi,gridThrow,gridMo,chuPaiShow,(i-1),nil,{uiLayer = self});
        local playerView            = DZAHM_Player.New(obj.gameObject,gameObject);
        local RoundDetail           = {};
        RoundDetail.openUserCard    = true;
        RoundDetail.isLord          = true;
        playerView:SetGameLogic(self.DZAHM_RePlayLogic):SetMJGridTool(DZAHM_GridTool,self.DZAHM_RePlayLogic,self);
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



function DZAHM_RePlayUILayer:GetButtons(gameObject)
    gameUIObjects.ButtonHu 				= gameUIObjects.operation_send:Find('Button2Hu');
    gameUIObjects.ButtonGang 			= gameUIObjects.operation_send:Find('Button3Gang');
	gameUIObjects.ButtonPeng 			= gameUIObjects.operation_send:Find('Button5Peng');
	gameUIObjects.ButtonChi 			= gameUIObjects.operation_send:Find('Button6Chi');
	gameUIObjects.ButtonGuo 			= gameUIObjects.operation_send:Find('Button1Guo');
    gameUIObjects.ButtonBu 				= gameUIObjects.operation_send:Find('Button4Bu');
	
end

function DZAHM_RePlayUILayer:GetRoomInfoUI(gameObject)
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
    gameUIObjects.hunPanel              = gameObject.transform:Find('hunPanel');
	
end

function DZAHM_RePlayUILayer:GetESWNUI(gameObject)
    gameUIObjects.dipai 			    = gameObject.transform:Find('DiPai');
    for i=1,self.DZAHM_RePlayLogic:GetMaxPlayerSize() do
        gameUIObjects.ActivePlayerESWN[i] = gameObject.transform:Find("DiPai/DeskTimerIndex"..i);
    end
end

function DZAHM_RePlayUILayer:InitUILayer(roomData)
    print("InitUILayer was called----->.roomData.state"..tostring(roomData.state))
    self.roomData = roomData;
     print("InitUILayer,roomData.surplus"..tostring(roomData.surplus));
     -- 房间信息
     self:InitRoomInfo(self.roomData);
     -- 人物信息
    self:InitPlayerInfo(self.roomData);
    -- 手牌信息
    self:InitAllGrids(self.roomData);
    --东南西北
    self:InitESWNInfo(self.roomData);

    DZAHM_RePlayEventBind.Init(self,gameUIObjects,self.DZAHM_RePlayLogic);--绑定事件
    self:InitControls();
    self:StartPlay();--开始播放


end

function DZAHM_RePlayUILayer:InitRoomInfo(roomData)
    --获取主题颜色
	bgColor 	= UnityEngine.PlayerPrefs.GetInt('bgColor_dzahm', 1);
	cardColor 	= UnityEngine.PlayerPrefs.GetInt('cardColor_dzahm', 1);
    cardText 	= UnityEngine.PlayerPrefs.GetInt('cardText_dzahm', 1);
    language 	= UnityEngine.PlayerPrefs.GetInt('language_dzahm', 1);
    coroutine.start(RefreshTime,gameUIObjects.roomTime:GetComponent("UILabel"),60);
    coroutine.start(RefreshPhoneState,self.gameObject,self.DZAHM_RePlayLogic,gameUIObjects.batteryLevel,gameUIObjects.network);
    gameUIObjects.roomID:GetComponent("UILabel").text                       = self.roomData.roomNumber;
    gameUIObjects.waitRoomID:GetComponent("UILabel").text                   = self.roomData.roomNumber;
    gameUIObjects.roomSetting:Find('Label'):GetComponent('UILabel').text    = GetDZAHMRuleText(roomData.setting,false,false);
    gameUIObjects.gameTypeobj:Find("playName"):GetComponent("UILabel").text = roomData.playName;
    self:SetInviteVisiable(false);
    self:HideWaittingUI();
    print("roomData.waitOperate"..tostring(self.roomData.waitOperate));
    --游戏开始时是否显示蹲拉跑
    -- print("mySeat:"..self.DZAHM_RePlayLogic.mySeat);
    -- print("completeChooce:"..self.DZAHM_RePlayLogic:GetPlayerDataBySeat(self.DZAHM_RePlayLogic.mySeat).completeChooce);
    -- print("bankerSeat:"..self.roomData.bankerSeat)
    -- if self.DZAHM_RePlayLogic:GetPlayerDataBySeat(self.DZAHM_RePlayLogic.mySeat).completeChooce == 1 then 
    --     PanelManager.Instance:ShowWindow("panelBetOn",{seat = self.DZAHM_RePlayLogic.mySeat,isBanker = self.DZAHM_RePlayLogic:IsBanker()})
    -- end 
    gameUIObjects.curOperatPlateEffect.gameObject:SetActive(false);
    gameUIObjects.hunPanel.gameObject:SetActive(false);


end


function DZAHM_RePlayUILayer:InitPlayerInfo(roomData)
    -- print("InitPlayerInfo------------------------------------>");
    self:AutoRegisterPlayerView(roomData.seat,roomData.setting.size);
    self:SetPlayerPos(roomData);
    DestroyRoomData.roomData 	    = roomData;
    DestroyRoomData.playerData      = self.DZAHM_RePlayLogic:GetPlayerDatas();
    DestroyRoomData.mySeat 		    = self.DZAHM_RePlayLogic.mySeat;

end

function DZAHM_RePlayUILayer:InitAllGrids(roomData)
    --隐藏所有的grid
    for i=1,#gameUIObjects.playerViews do
        gameUIObjects.playerViews[i].dzahm_GridTool:HideAllGrid();
    end

    if self.roomData.state == self.nmm_pb.GAMING then 
        self:RefreshAllGrid();
        self:SetActivePlayer(self.roomData);
        self:SetGameTypePos();
    end
    --显示玩家的操作
    -- print("mySeat:"..tostring(self.DZAHM_RePlayLogic.mySeat));
    -- print("playerdatas.length:"..self.DZAHM_RePlayLogic:GetPlayerDataLength());
    local myData = self.DZAHM_RePlayLogic:GetPlayerDataBySeat(self.DZAHM_RePlayLogic.mySeat);
    -- print("myoperations.length:"..#myData.operations);
    self:RefreshOperationSend(myData.operations,myData);
    --处理听牌
    local myData        = self.DZAHM_RePlayLogic:GetPlayerDataBySeat(self.DZAHM_RePlayLogic.mySeat);
    local myRealIndex   = self.DZAHM_RePlayLogic:GetCorrectUIIndex(self.DZAHM_RePlayLogic:GetPlayerViewIndexBySeat(myData.seat));
    local myPlayerView  = gameUIObjects.playerViews[myRealIndex];
   

end

function DZAHM_RePlayUILayer:SetGameTypePos()
	if gameUIObjects.roomSetting.gameObject.activeSelf then
		gameUIObjects.roomSetting.localPosition = Vector3.New(-4,141,0);
	else
		gameUIObjects.roomSetting.localPosition = Vector3.New(-4,102,0);
	end
end

function DZAHM_RePlayUILayer:InitESWNInfo(roomData)
    gameUIObjects.dipai.gameObject:SetActive(false);
    self:SetDipaiNum(roomData.surplus);
    self:SetRoundNum(roomData.round);
    gameUIObjects.dipai.gameObject:SetActive(DZAHM_PlayLogic.NeedShowDiPai(self.roomData,self.DZAHM_RePlayLogic));
    gameUIObjects.roomRound.gameObject:SetActive(DZAHM_PlayLogic.NeedShowDiPai(self.roomData,self.DZAHM_RePlayLogic));
    self:SetActivePlayer(self.roomData);
end


function DZAHM_RePlayUILayer:SetPlayerPos(roomData)
    --设置座位位置
    for i=1,#gameUIObjects.playerViews do
        local playerView =  gameUIObjects.playerViews[i];
        playerView:SetPos(roomData.state  ~= self.nmm_pb.GAMING and (self.DZAHM_RePlayLogic.totalSize < roomData.setting.size or roomData.round == 1) );
        playerView:NeedHideSelf(roomData.setting.size);
    end
end


--刷新所有grid
function DZAHM_RePlayUILayer:RefreshAllGrid( )
    -- body
    -- print("RefreshAllGrid------------->")
    self.DZAHM_RePlayLogic:ForeachPlayerDatas(function(playerView,_) 
        playerView.dzahm_GridTool:SetLayOut();
    end);
    self:RefreshAllGridXi();
    self:RefreshAllGridHand();
    self:RefreshAllGridMoPai();
    self:RefreshAllGridThrow();
end

--刷新手牌
function DZAHM_RePlayUILayer:RefreshAllGridHand()
    -- print("RefreshAllGridHand----------->")
    self.DZAHM_RePlayLogic:ForeachPlayerDatas(function(playerView,playerData) 
        -- print("playerName:"..playerData.name..",seat:"..playerData.seat..",mahjongs.length:"..(#playerData.mahjongs));
        playerView.dzahm_GridTool.gridHand.gameObject:SetActive(true);
        playerView.dzahm_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
        playerView.dzahm_GridTool:GridHandPlatesDown(playerData.mahjongs,playerData.mahjongs);
    end);
end

--刷新喜牌
function DZAHM_RePlayUILayer:RefreshAllGridXi()
    -- print("RefreshAllGridXi----------->")
    self.DZAHM_RePlayLogic:ForeachPlayerDatas(function(playerView,playerData) 
        playerView.dzahm_GridTool.gridXi.gameObject:SetActive(true);
        playerView.dzahm_GridTool:RefreshGridXi(playerData.operationCards);
    end);
end

--刷新带出去的牌
function DZAHM_RePlayUILayer:RefreshAllGridThrow()
    -- print("RefreshAllGridThrow----------->")
    self.DZAHM_RePlayLogic:ForeachPlayerDatas(function(playerView,playerData) 
        playerView.dzahm_GridTool.gridThrow.gameObject:SetActive(true);
        playerView.dzahm_GridTool:RefreshGridThrow(playerData.paiHe);
    end);
end

--刷新摸牌
function DZAHM_RePlayUILayer:RefreshAllGridMoPai()
    -- print("RefreshAllGridMoPai----------->")
    self.DZAHM_RePlayLogic:ForeachPlayerDatas(function(_,playerData) 
        local playerView = gameUIObjects.playerViews[self.DZAHM_RePlayLogic:GetCorrectUIIndex(self.DZAHM_RePlayLogic:GetPlayerViewIndexBySeat(playerData.seat))];
        playerView.dzahm_GridTool.gridMo.gameObject:SetActive(playerData.moMahjong ~= -1);
        playerView.dzahm_GridTool:RefreshMoPai(playerData.moMahjong);
    end);
end

function DZAHM_RePlayUILayer:AutoRegisterPlayerView(mySeat, size)
     for i = 1, self.DZAHM_RePlayLogic:GetMaxPlayerSize() do
        gameUIObjects.playerViews[i]:OpenView();
        self.DZAHM_RePlayLogic:RegisterPlayerView(gameUIObjects.playerViews[i]);
    end
    self.DZAHM_RePlayLogic:ResetAllPlayerView();
end

function DZAHM_RePlayUILayer:SetRoundStart( data )
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

function DZAHM_RePlayUILayer:SetRoomInfo(roomData)
    self:SetDipaiNum(roomData.surplus);
    self:SetRoundNum(roomData.round);
end
function DZAHM_RePlayUILayer:SetGameRoundEnd( RoundEndData )
    -- body
    RoundEndData.uiLayer = self;
    PanelManager.Instance:ShowWindow("panelStageClear_dzahm",RoundEndData)
    PanelManager.Instance:HideWindow("panelChat");
    PanelManager.Instance:HideWindow("panelGameSetting_dzahm");
    self.DZAHM_RePlayLogic:ResetGameState();
    self:SetDipaiNum(self.roomData.surplus);
    self:SetRoundNum(self.roomData.round);
    self:ClearUI();
end

--清除一些UI上的状态
function DZAHM_RePlayUILayer:ClearUI()
    -- body
    --1.时钟
    gameUIObjects.dipai:Find("timer"):GetComponent("UILabel").text = 0;
    DZAHM_Tools.StopCount(gameUIObjects.dipai:Find("timer"));
    --2.操作列表
    gameUIObjects.operation_send.gameObject:SetActive(false);
end

--刷新所有UI
function DZAHM_RePlayUILayer:RefreshAllUI()

end

function DZAHM_RePlayUILayer:RefreshPlayer()
    self.DZAHM_RePlayLogic:ForeachPlayerDatas(function(_,playerData)
        local playerView = gameUIObjects.playerViews[self.DZAHM_RePlayLogic:GetCorrectUIIndex(self.DZAHM_RePlayLogic:GetPlayerViewIndexBySeat(playerData.seat))]; 
        playerView:SetReady(playerData.ready and self.roomData.state == self.nmm_pb.WAITING);
        playerView:ResetView(playerData);
        playerView:SetOnlyOfflineFlag(not playerData.connected);
    end);
    
end



function DZAHM_RePlayUILayer:SetActivePlayer(roomData)
    self:ShowWaitOpreatEffect(roomData.activeSeat,roomData.state == self.nmm_pb.GAMING);
    for i=1,#gameUIObjects.playerViews do
        gameUIObjects.playerViews[i]:SetActiveFlag(false);
    end
    local playerView = gameUIObjects.playerViews[self.DZAHM_RePlayLogic:GetCorrectUIIndex(self.DZAHM_RePlayLogic:GetPlayerViewIndexBySeat(roomData.activeSeat))];
    playerView:SetActiveFlag(true and roomData.state == self.nmm_pb.GAMING);
end

function DZAHM_RePlayUILayer:GetOverTrusteeship()
    local Trusteeships={}
    for i = 0, self.roomData.setting.size-1 do
        local playerView = gameUIObjects.playerViews[self.DZAHM_RePlayLogic:GetCorrectUIIndex(self.DZAHM_RePlayLogic:GetPlayerViewIndexBySeat(i))];
        Trusteeships[i] = playerView.trusteeshipFlag.gameObject.activeSelf;
    end
    return Trusteeships;
end

function DZAHM_RePlayUILayer:ChangePaiSize(dzahmPaiSize)

end


function DZAHM_RePlayUILayer:SetGameRoundOver(RoundAllData)

    local overData = {};
    overData.RoundAllData   = RoundAllData;
    overData.roomInfo       = roomInfo;
    -- print("RoundAllData.data.complete:"..tostring(RoundAllData.data.complete)..",self.DZAHM_RePlayLogic.hasStageClear:"..tostring(self.DZAHM_RePlayLogic.hasStageClear));
    if not RoundAllData.data.complete and not self.DZAHM_RePlayLogic.hasStageClear then 
        PanelManager.Instance:ShowWindow("panelStageClearAll_dzahm",overData);
        PanelManager.Instance:HideWindow("panelChat");
        PanelManager.Instance:HideWindow("panelGameSetting_dzahm");
    end
    self:ClearUI();
end


function DZAHM_RePlayUILayer.Update(obj)
    -- print("Update-------------------->");
   
end

--玩家摸牌
function DZAHM_RePlayUILayer:SetPlayerMoPai(moData)
    --先隐藏所有的摸牌的grid
    for i=1,#gameUIObjects.playerViews do
        gameUIObjects.playerViews[i].dzahm_GridTool:SetGridMoVisible(false);
    end
    local playerView = gameUIObjects.playerViews[self.DZAHM_RePlayLogic:GetCorrectUIIndex(self.DZAHM_RePlayLogic:GetPlayerViewIndexBySeat(moData.seat))];
    local playerData = self.DZAHM_RePlayLogic:GetPlayerDataBySeat(moData.seat);
    --显示当前玩家的摸牌的grid
    playerView.dzahm_GridTool:SetGridMoVisible(true);
    self:SetDipaiNum(self.roomData.surplus);
    playerView.dzahm_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
    playerView.dzahm_GridTool:GridHandPlatesDown(playerData.mahjongs,playerData.mahjongs);
    playerView.dzahm_GridTool:RefreshMoPai(playerData.moMahjong);
    playerView.dzahm_GridTool:MoPaiDown(playerData.moMahjong,playerData.mahjongCount);
   
    self:SetActivePlayer(self.roomData);
    if moData.operation and #moData.operation>0 then 
        for i=1,#moData.operation do
            if moData.operation[i].seat == self.DZAHM_RePlayLogic.mySeat then 
                self:RefreshOperationSend(moData.operation[i].operation,playerData);
            end
        end
    end
    
end

--玩家出牌
function DZAHM_RePlayUILayer:SetPlayerChuPai(chuData)
    -- print("player.seat"..chuData.seat.." chu pai,plate="..chuData.mahjong);
    local playerView    = gameUIObjects.playerViews[self.DZAHM_RePlayLogic:GetCorrectUIIndex(self.DZAHM_RePlayLogic:GetPlayerViewIndexBySeat(chuData.seat))];
    local playerData    = self.DZAHM_RePlayLogic:GetPlayerDataBySeat(chuData.seat);
    local myData        = self.DZAHM_RePlayLogic:GetPlayerDataBySeat(self.DZAHM_RePlayLogic.mySeat);
    playerView.dzahm_GridTool:RefreshGridThrow(playerData.paiHe);
    playerView.dzahm_GridTool:SetGridMoVisible(false);
    self:SetPlayerChuPaiShow(chuData.seat,chuData.mahjong);
    self:SetLastPlayerChuPaiEffect(chuData.seat);
    if chuData.seat == self.DZAHM_RePlayLogic.mySeat then 
        playerView.dzahm_GridTool:SetGridMoVisible(false);
    end
    playerView.dzahm_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
    playerView.dzahm_GridTool:GridHandPlatesDown(playerData.mahjongs,playerData.mahjongs);
    AudioManager.Instance:PlayAudio(self:GetAudioPrefix()..(playerData.sex==1 and 'man' or 'woman')..math.floor(chuData.mahjong / 9 + 1)..(chuData.mahjong % 9 + 1))
    if chuData.operation and #chuData.operation>0 then 
        for i=1,#chuData.operation do
            if chuData.operation[i].seat == self.DZAHM_RePlayLogic.mySeat then 
                self:RefreshOperationSend(chuData.operation[i].operation,playerData);
            end
        end
    end
    
end

--玩家吃牌
function DZAHM_RePlayUILayer:SetPlayerChiPai(chiData)
    --1.显示特效
    local realIndex     = self.DZAHM_RePlayLogic:GetCorrectUIIndex(self.DZAHM_RePlayLogic:GetPlayerViewIndexBySeat(chiData.seat));
    local outRealIndex  = self.DZAHM_RePlayLogic:GetCorrectUIIndex(self.DZAHM_RePlayLogic:GetPlayerViewIndexBySeat(chiData.outSeat));
    local playerView    = gameUIObjects.playerViews[realIndex];
    local playerData    = self.DZAHM_RePlayLogic:GetPlayerDataBySeat(chiData.seat);
    local outPlayerData = self.DZAHM_RePlayLogic:GetPlayerDataBySeat(chiData.outSeat);
    local outPlayerView = gameUIObjects.playerViews[outRealIndex];
    effManger.ShowEffect(self.gameObject,"chi",gameUIObjects.playerHupaiPos[realIndex]);
    --2.刷新喜牌
    playerView.dzahm_GridTool:RefreshGridXi(playerData.operationCards);
    --3.刷新牌桌上的牌
    outPlayerView.dzahm_GridTool:RefreshGridThrow(outPlayerData.paiHe);
    --4.刷新手牌
    playerView.dzahm_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
    --8.刷新当前出牌玩家
    self:SetActivePlayer(self.roomData);
    AudioManager.Instance:PlayAudio(self:GetAudioPrefix()..(playerData.sex==1 and 'man' or 'woman').."_chi");
    --9.隐藏最后出牌的指示器
    gameUIObjects.curOperatPlateEffect.gameObject:SetActive(false);
end

--玩家碰牌
function DZAHM_RePlayUILayer:SetPlayerPengPai(pengData)
    local realIndex     = self.DZAHM_RePlayLogic:GetCorrectUIIndex(self.DZAHM_RePlayLogic:GetPlayerViewIndexBySeat(pengData.seat));
    local outRealIndex  = self.DZAHM_RePlayLogic:GetCorrectUIIndex(self.DZAHM_RePlayLogic:GetPlayerViewIndexBySeat(pengData.outSeat));
    local playerView    = gameUIObjects.playerViews[realIndex];
    local playerData    = self.DZAHM_RePlayLogic:GetPlayerDataBySeat(pengData.seat);
    local outPlayerData = self.DZAHM_RePlayLogic:GetPlayerDataBySeat(pengData.outSeat);
    local outPlayerView = gameUIObjects.playerViews[outRealIndex];
    --显示特效
    effManger.ShowEffect(self.gameObject,"peng",gameUIObjects.playerHupaiPos[realIndex]);
    playerView.dzahm_GridTool:RefreshGridXi(playerData.operationCards);
    outPlayerView.dzahm_GridTool:RefreshGridThrow(outPlayerData.paiHe);
    playerView.dzahm_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
    playerView.dzahm_GridTool:GridHandPlatesDown(playerData.mahjongs,playerData.mahjongs);
    
    self:SetActivePlayer(self.roomData);
    AudioManager.Instance:PlayAudio(self:GetAudioPrefix()..(playerData.sex==1 and 'man' or 'woman').."_peng");
    gameUIObjects.curOperatPlateEffect.gameObject:SetActive(false);

    if pengData.seat == self.DZAHM_RePlayLogic.mySeat then 
        self:PlayerSelectOperation("peng");
    else
        self:PlayerSelectOperation("guo");
    end

    if pengData.operation and #pengData.operation > 0 then 
        for i=1,#pengData.operation do
            if pengData.operation[i].seat == self.DZAHM_RePlayLogic.mySeat then 
                self:RefreshOperationSend(pengData.operation[i].operation,playerData);
            end
        end
    end
end

--玩家杠牌
function DZAHM_RePlayUILayer:SetPlayerGangPai(gangData)
    --显示特效
    -- print("SetPlayerGangPai was called------------------------------");
    local realIndex     = self.DZAHM_RePlayLogic:GetCorrectUIIndex(self.DZAHM_RePlayLogic:GetPlayerViewIndexBySeat(gangData.seat));
    local playerView    = gameUIObjects.playerViews[realIndex];
    local playerData    = self.DZAHM_RePlayLogic:GetPlayerDataBySeat(gangData.seat);
    effManger.ShowEffect(self.gameObject,self:GetGangEffectString(gangData.gangType),gameUIObjects.playerHupaiPos[realIndex]);
    playerView.dzahm_GridTool:RefreshGridXi(playerData.operationCards);
    playerView.dzahm_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
    playerView.dzahm_GridTool:GridHandPlatesDown(playerData.mahjongs,playerData.mahjongs);
    if gangData.outSeat then 
        local outPlayerData = self.DZAHM_RePlayLogic:GetPlayerDataBySeat(gangData.outSeat);
        local outRealIndex  = self.DZAHM_RePlayLogic:GetCorrectUIIndex(self.DZAHM_RePlayLogic:GetPlayerViewIndexBySeat(gangData.outSeat));
        local outPlayerView = gameUIObjects.playerViews[outRealIndex];
        outPlayerView.dzahm_GridTool:RefreshGridThrow(outPlayerData.paiHe);
    end
    playerView.dzahm_GridTool:SetGridMoVisible(false);
    self:SetActivePlayer(self.roomData);
    AudioManager.Instance:PlayAudio(self:GetAudioPrefix()..(playerData.sex==1 and 'man' or 'woman').."_gang");
    gameUIObjects.curOperatPlateEffect.gameObject:SetActive(false);

    if gangData.seat == self.DZAHM_RePlayLogic.mySeat then 
        self:PlayerSelectOperation("gang");
    else
        self:PlayerSelectOperation("guo");
    end

    if gangData.operation and #gangData.operation > 0 then 
        for i=1,#gangData.operation do
            if gangData.operation[i].seat == self.DZAHM_RePlayLogic.mySeat then 
                self:RefreshOperationSend(gangData.operation[i].operation,playerData);
            end
        end
    end

end

--获取杠牌特效字符串
function DZAHM_RePlayUILayer:GetGangEffectString(gangType)
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
function DZAHM_RePlayUILayer:SetPlayerBuPai(buData)
    -- print("SetPlayerBuPai was called----------------------->");
end

--玩家过牌
function DZAHM_RePlayUILayer:SetPlayerGuoPai(guoData)
    -- print("SetPlayerGuoPai was called------------------------>");
    -- if guoData.seat == self.DZAHM_RePlayLogic.mySeat then 
       
    -- end
    self:PlayerSelectOperation("guo");

end

--玩家胡牌
function DZAHM_RePlayUILayer:SetPlayerHuPai(huData)
    -- print("SetPlayerHuPai was called-------------------------->");
    local realIndex = self.DZAHM_RePlayLogic:GetCorrectUIIndex(self.DZAHM_RePlayLogic:GetPlayerViewIndexBySeat(huData.seat));
    local playerView = gameUIObjects.playerViews[realIndex];
    local playerData = self.DZAHM_RePlayLogic:GetPlayerDataBySeat(huData.seat);
    -- print("huData.seat:"..huData.seat..",huData.outSeat:"..huData.outSeat);
    if huData.seat == huData.outSeat then 
        AudioManager.Instance:PlayAudio(self:GetAudioPrefix()..(playerData.sex == 1 and "man_" or "woman_").."zimo");
	    effManger.ShowEffect(self.gameObject, 'zm', gameUIObjects.playerHupaiPos[realIndex]);
    else
        AudioManager.Instance:PlayAudio(self:GetAudioPrefix()..(playerData.sex == 1 and "man_" or "woman_").."hu");
        effManger.ShowEffect(self.gameObject, 'hu', gameUIObjects.playerHupaiPos[realIndex]);
        self:SetPao(huData);
    end

    playerView.dzahm_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
    playerView.dzahm_GridTool:GridHandPlatesDown(playerData.mahjongs,playerData.mahjongs);
    if huData.seat == huData.outSeat then 
        playerView.dzahm_GridTool:RefreshMoPai(playerData.moMahjong);
        playerView.dzahm_GridTool:MoPaiDown(playerData.moMahjong,playerData.mahjongCount);
    end
    -- print("huData.seat:"..huData.seat..",self.DZAHM_RePlayLogic.mySeat:"..self.DZAHM_RePlayLogic.mySeat);
    if huData.seat == self.DZAHM_RePlayLogic.mySeat then 
        self:PlayerSelectOperation("hu");
    else
        self:PlayerSelectOperation("guo");
    end
end


function DZAHM_RePlayUILayer:SetPao(winData)
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
    local realIndex = self.DZAHM_RePlayLogic:GetCorrectUIIndex(self.DZAHM_RePlayLogic:GetPlayerViewIndexBySeat(winData.outSeat));
	if isFangPao  then -- 放炮
        -- print("fp-------------->1");
		effManger.ShowEffect(self.gameObject, 'fp', gameUIObjects.playerHupaiPos[realIndex]);
	else -- 通炮
		-- print("tp-------------->2");
		effManger.ShowEffect(self.gameObject, 'tp', gameUIObjects.playerHupaiPos[realIndex]);
    end
end

function DZAHM_RePlayUILayer:GetgameUIObjects()
    return gameUIObjects;
end


--根据背景设置文字颜色
function DZAHM_RePlayUILayer:SetGameColor(bgIndex)
    gameUIObjects.dipai:Find("frame/roundHead"):GetComponent("UILabel").color           = self:getAccorColor(color);
	gameUIObjects.dipai:Find("frame/roundHead/roundTail"):GetComponent("UILabel").color = self:getAccorColor(color);
	gameUIObjects.roomRound:GetComponent("UILabel").color                               = self:getNumColor(color);
	gameUIObjects.dipai:Find("frame/leftHead"):GetComponent("UILabel").color            = self:getAccorColor(color);
	gameUIObjects.dipai:Find("frame/leftHead/leftTail"):GetComponent("UILabel").color   = self:getAccorColor(color);
	gameUIObjects.dipai:Find('frame/leftCard'):GetComponent('UILabel').color            = self:getNumColor(color);
end

function DZAHM_RePlayUILayer:getAccorColor(color)
	if color == 1 then
		return Color.New(57/255,123/255,174/255);
	else
		return Color.New(52/255,209/255,186/255);
	end
end

function DZAHM_RePlayUILayer:getNumColor(color)
	if color == 1 then
		return Color.New(76/255,189/255,197/255);
	else
		return Color.New(205/255,220/255,114/255);
	end
end

--选择背景
function DZAHM_RePlayUILayer:ChooseBG(bgIndex)
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
function DZAHM_RePlayUILayer:SetRoundNum(num)
    -- print("SetRoundNum------------------>was called,num:"..tostring(num));
    gameUIObjects.roomRound:GetComponent("UILabel").text = num..'/'..self.roomData.setting.rounds;
end

--设置底牌的剩余数目
function DZAHM_RePlayUILayer:SetDipaiNum(num)
    gameUIObjects.dipai:Find('frame/leftCard'):GetComponent('UILabel').text = string.format('%d', num);
end

--设置邀请好友，解散房间，分享按钮的显示和隐藏
function DZAHM_RePlayUILayer:SetInviteVisiable(show)
    if not PlatformManager.Instance:IsWXAppInstalled() then
		show = false
    end
end

--显示出牌的状态，东西南北，哪个该出牌了
--当前该出牌的玩家
function DZAHM_RePlayUILayer:ShowWaitOpreatEffect(activeSeat,show)
    -- print("ShowWaitOpreatEffect,activeSeat="..tostring(activeSeat)..",show="..tostring(show));
    --先隐藏所有
    for i=1,self.DZAHM_RePlayLogic:GetMaxPlayerSize() do
        self:SetESWNState(i,false);
    end
    
    for i=1,self.DZAHM_RePlayLogic.totalSize do
        local index = self.DZAHM_RePlayLogic:GetPlayerViewIndexBySeat(activeSeat);
        self:SetESWNState(self.DZAHM_RePlayLogic:GetCorrectUIIndex(index),show);
    end
    --倒计时
    if show then 
        DZAHM_Tools.CountDown(gameUIObjects.dipai:Find("timer"),15,0);
    end
end


function DZAHM_RePlayUILayer:SetESWNState(index,show)	gameUIObjects.ActivePlayerESWN[index]:Find('select').gameObject:SetActive(show);
   gameUIObjects.ActivePlayerESWN[index]:Find('frame').gameObject:SetActive(show);
   gameUIObjects.ActivePlayerESWN[index]:Find('unselect').gameObject:SetActive(not show);
   gameUIObjects.playerViews[index]:SetActiveFlag(show);
   
end


--显示等待的时候需要显示的UI，隐藏游戏进行中的UI
function DZAHM_RePlayUILayer:ShowWaittingUI()
    -- print("ShowWaittingUI-------------->was called");
    gameUIObjects.dipai.gameObject:SetActive(DZAHM_PlayLogic.NeedShowDiPai(self.roomData,self.DZAHM_RePlayLogic));
    gameUIObjects.roomSetting.gameObject:SetActive(true);
    gameUIObjects.roomSetting:Find("roominfo").gameObject:SetActive(false);
    gameUIObjects.roomRound.gameObject:SetActive(DZAHM_PlayLogic.NeedShowDiPai(self.roomData,self.DZAHM_RePlayLogic));
    self:SetGameTypePos();
end

--隐藏等待时显示的UI，显示游戏进行中的UI
function DZAHM_RePlayUILayer:HideWaittingUI()
    -- print("HideWaittingUI---------------was called");
    -- print("NeedShowDiPai:"..tostring(DZAHM_PlayLogic.NeedShowDiPai(self.roomData,self.DZAHM_RePlayLogic)));
    gameUIObjects.roomSetting.gameObject:SetActive(true);
    gameUIObjects.roomSetting:Find("roominfo").gameObject:SetActive(false);
    gameUIObjects.dipai.gameObject:SetActive(DZAHM_PlayLogic.NeedShowDiPai(self.roomData,self.DZAHM_RePlayLogic));
    gameUIObjects.roomRound.gameObject:SetActive(DZAHM_PlayLogic.NeedShowDiPai(self.roomData,self.DZAHM_RePlayLogic));
    self:SetGameTypePos();
end




function DZAHM_RePlayUILayer:getCardColor()
    return cardColor;
end

function DZAHM_RePlayUILayer:getcardText()
    return cardText;
end

function DZAHM_RePlayUILayer:GetAudioPrefix()
    return language == 1 and "" or "fy_";
end

----根据颜色值获取麻将背板图片
function DZAHM_RePlayUILayer:getColorCardName(name,colorIndex)
    if colorIndex == 1 then --绿色
		return name;
	elseif colorIndex == 2 then --黄色
		return name..'y';
	end
end

--根据用户选择选择麻将的牌面
function DZAHM_RePlayUILayer:GetCardTextName(plateIndex,cardTextIndex)
    return tostring(plateIndex);
end

--根据用户的选择选择牌面大小
function DZAHM_RePlayUILayer:GetCardPlateSize(plateIndex,cardTextIndex)
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

function DZAHM_RePlayUILayer:SetPlateColor(throwItemobj,showColor)
    if showColor then
		throwItemobj:GetComponent("UISprite").color = Color(255/255,222/255,84/255);
	else
		throwItemobj:GetComponent("UISprite").color = Color(255/255,255/255,255/255);
	end
end

--设置玩家出牌展示
function DZAHM_RePlayUILayer:SetPlayerChuPaiShow(seat,mahjong)
     local playerView = gameUIObjects.playerViews[self.DZAHM_RePlayLogic:GetCorrectUIIndex(self.DZAHM_RePlayLogic:GetPlayerViewIndexBySeat(seat))];
     playerView.dzahm_GridTool:RefreshChuPai(mahjong);
end

--设置箭头指向最后一个玩家出的牌
function DZAHM_RePlayUILayer:SetLastPlayerChuPaiEffect(seat)
    local playerView = gameUIObjects.playerViews[self.DZAHM_RePlayLogic:GetCorrectUIIndex(self.DZAHM_RePlayLogic:GetPlayerViewIndexBySeat(seat))];
    local playerData = self.DZAHM_RePlayLogic:GetPlayerDataBySeat(seat);
    gameUIObjects.curOperatPlateEffect.gameObject:SetActive(true);
    StartCoroutine(function() 
        WaitForEndOfFrame();
         gameUIObjects.curOperatPlateEffect.position = playerView.dzahm_GridTool.gridThrow:GetChild(#playerData.paiHe-1).position;
    end);

end

--刷新玩家吃碰杠补等操作
function DZAHM_RePlayUILayer:RefreshOperationSend(operations,playerData)
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
function DZAHM_RePlayUILayer:SetOperationButtons(operations)
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
function DZAHM_RePlayUILayer:PlayerSelectOperation(operate)
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

function DZAHM_RePlayUILayer:ResetOperationTween( )
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

function DZAHM_RePlayUILayer:StartPlay()
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
                self.DZAHM_RePlayLogic:OnPlayerPlay(record);
                self.playIndex = self.playIndex + 1;
                print("当前进度 ",self.playIndex,"/",#self.roomData.records);
                if self.roomData.roundEnd and self.roomData.roundEnd~=nil then 
                    if self.playIndex > #self.roomData.records and #self.roomData.roundEnd.players > 0 then 
                        print(" replay round end!");
                        coroutine.wait(0.5);
                        self.DZAHM_RePlayLogic:OnGameRoundEnd(self.roomData.roundEnd);
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
function DZAHM_RePlayUILayer:InitControls()
    self.isPause            = false;
    self.playInterval       = 1.5;
    self.playIndex          = 1;
    self.rawSpeed           = self.playInterval;
    self.cutTime            = 0.25;
    gameUIObjects.ButtonPause:GetComponent('UIButton').normalSprite = 'zanting'
	gameUIObjects.FastLabel:GetComponent('UILabel').text = ''
    gameUIObjects.SlowLabel:GetComponent('UILabel').text = ''
end

function DZAHM_RePlayUILayer:PlaySlow()
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

function DZAHM_RePlayUILayer:PlayFast()
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

function DZAHM_RePlayUILayer:PlayPause()
    self.isPause = not self.isPause
	if self.isPause then
		gameUIObjects.ButtonPause:GetComponent('UIButton').normalSprite = 'bofang'
	else
		gameUIObjects.ButtonPause:GetComponent('UIButton').normalSprite = 'zanting'
	end
end

function DZAHM_RePlayUILayer:ExitPlay()
    coroutine.stop(self.playCoroutine);
    self.playCoroutine = nil;
    self.DZAHM_RePlayLogic:ForeachPlayerDatas(function(playerView,playerData) 
        playerView:CloseView(); 
        playerView.dzahm_GridTool:HideAllGrid();
    end);
    
    PanelManager.Instance:ShowWindow(self.roomData.backWinName);
	PanelManager.Instance:HideWindow(self.gameObject.name)
	PanelManager.Instance:HideWindow("panelStageClear_dzahm");
    AudioManager.Instance:PlayMusic('MainBG', true);
    self:InitControls();
end

function DZAHM_RePlayUILayer:SetDismissType(go)
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
function DZAHM_RePlayUILayer:SetPlayerFish(data)
    if data.fishScoreBoard == nil then 
        print("fishScoreBoard--------is nil");
        return ;
    end
    -- print("data.fishScoreBoard.length"..#data.fishScoreBoard);
    for i=1,#data.fishScoreBoard do
        local realIndex = self.DZAHM_RePlayLogic:GetCorrectUIIndex(self.DZAHM_RePlayLogic:GetPlayerViewIndexBySeat(data.fishScoreBoard[i].seat));
        local playerView = gameUIObjects.playerViews[realIndex];
        local playerData = self.DZAHM_RePlayLogic:GetPlayerDataBySeat(data.fishScoreBoard[i].seat);
        -- print("player:"..playerData.name..".yuScore="..playerData.yuScore);
        playerView:SetFish(playerData.yuScore);
    end
end

--设置玩家分数
function DZAHM_RePlayUILayer:SetPlayerScore(data)
    if data.scoreBoard == nil then 
        print("scoreBoard---------is nil");
        return ;
    end
    -- print("data.scoreBoard.length="..#data.scoreBoard);
    --先清空之前的分数
    self.DZAHM_RePlayLogic:ForeachPlayerDatas(function(playerView,playerData) 
        local playerView = gameUIObjects.playerViews[self.DZAHM_RePlayLogic:GetCorrectUIIndex(self.DZAHM_RePlayLogic:GetPlayerViewIndexBySeat(playerData.seat))];
        playerView:UpdateScore(0);
    end);

    for i=1,#data.scoreBoard do
        local playerData    = self.DZAHM_RePlayLogic:GetPlayerDataBySeat(data.scoreBoard[i].seat);
        local realIndex     = self.DZAHM_RePlayLogic:GetCorrectUIIndex(self.DZAHM_RePlayLogic:GetPlayerViewIndexBySeat(data.scoreBoard[i].seat));
        local playerView    = gameUIObjects.playerViews[realIndex];
        playerData.score    = data.scoreBoard[i].score;
        -- print("data.scoreBoard["..i.."].score="..data.scoreBoard[i].score);
        playerView:UpdateScore(data.scoreBoard[i].score);
    end
end

function DZAHM_RePlayUILayer:SetPlayerHunPlates(hunPlates)
    self:HunPlatesAnimation(hunPlates);
end


--播放混牌的动画
function DZAHM_RePlayUILayer:HunPlatesAnimation(hunPlates)
    print("HunPlatesAnimation was called");
    if hunPlates == nil or #hunPlates == 0 then 
        return;
    end
    gameUIObjects.hunPanel.gameObject:SetActive(true);
    local hunPlate = gameUIObjects.hunPanel:Find("hunPlate");
    local hunGrid = gameUIObjects.hunPanel:Find("hunGrid");
    if self.hunPlateCor ~= nil then 
        StopCoroutine(self.hunPlateCor);
        self.hunPlateCor = nil;
    end
    local myData = self.DZAHM_RePlayLogic:GetPlayerDataBySeat(self.DZAHM_RePlayLogic.mySeat);
    print("myData.hunMahjong="..tostring(myData.hunMahjong));
    self.hunPlateCor = StartCoroutine(function()
        --初始化
        hunPlate.gameObject:SetActive(true);
        hunGrid.gameObject:SetActive(false);
        local cardItemBG                = hunPlate:GetComponent("UISprite");
        local cardItemPlate             = hunPlate:Find("card"):GetComponent("UISprite");
        cardItemBG.transform.position   = gameUIObjects.hunPanel:Find("frompos").position;
        cardItemBG.transform:Find("card").gameObject:SetActive(false);
        cardItemBG.spriteName = self:getColorCardName("mj_01_back",self:getCardColor());
        local tweenScale    = hunPlate:GetComponent("TweenScale");
        local tweenPosition = hunPlate:GetComponent("TweenPosition");
       
        tweenScale:ResetToBeginning();
        tweenPosition:ResetToBeginning();
        tweenPosition.worldSpace = true;
        tweenScale.from     = Vector3.New(1.0,1.0,1.0);
        tweenScale.to       = Vector3.New(0.5,0.5,1.0);
        tweenPosition.from  = gameUIObjects.hunPanel:Find("frompos").position;
        tweenPosition.to    = gameUIObjects.hunPanel:Find("topos").position;
        
        --1.翻牌动画
        WaitForSeconds(0.4);
        cardItemBG.spriteName                   = self:getColorCardName(CONST.cardPrefabHandStandBg[1],self:getCardColor());
        cardItemPlate.spriteName                = self:GetCardTextName(myData.hunMahjong,self:getcardText());
        cardItemPlate.transform.localPosition   = CONST.cardPrefabHandStandOffset[1];
        cardItemPlate.width                     = self:GetCardPlateSize(myData.hunMahjong,self:getcardText()).x;
        cardItemPlate.height                    = self:GetCardPlateSize(myData.hunMahjong,self:getcardText()).y;
        cardItemPlate.gameObject:SetActive(true);
        --2.飞牌动画
        WaitForSeconds(0.2);
        tweenScale.enabled = true;
        tweenPosition.enabled = true;
        tweenScale:PlayForward();
        tweenPosition:PlayForward();
        --3.展示混牌
        WaitForSeconds(tweenPosition.duration);
        hunPlate.gameObject:SetActive(false);
        hunGrid.gameObject:SetActive(true);
        tweenScale.enabled = false;
        tweenPosition.enabled = false;
        self:SetHunPlates(hunPlates);
       
    end);
end

--设置展示的混牌
function DZAHM_RePlayUILayer:SetHunPlates(hunPlates)
    local hunGrid = gameUIObjects.hunPanel:Find("hunGrid");
    hunGrid.gameObject:SetActive(true);
    for i=0,hunGrid.childCount -1 do 
        hunGrid:GetChild(i).gameObject:SetActive(false);
    end
    for i=1,#hunPlates do
        local cardItem                          = hunGrid:GetChild(i-1);
        cardItem.gameObject:SetActive(true);
        local cardItemBG                        = cardItem:GetComponent("UISprite");
        local cardItemPlate                     = cardItem:Find("card"):GetComponent("UISprite");
        cardItemBG.spriteName                   = self:getColorCardName(CONST.cardPrefabHandStandBg[1],self:getCardColor());
        print("cardItemBG.spriteName ="..cardItemBG.spriteName );
        cardItemPlate.spriteName                = self:GetCardTextName(hunPlates[i],self:getcardText());
        print("cardItemPlate.spriteName ="..cardItemPlate.spriteName );
        cardItemPlate.transform.localPosition   = CONST.cardPrefabHandStandOffset[1];
        cardItemPlate.width                     = self:GetCardPlateSize(hunPlates[i],self:getcardText()).x;
        cardItemPlate.height                    = self:GetCardPlateSize(hunPlates[i],self:getcardText()).y;
        cardItemPlate.gameObject:SetActive(true);
    end

    hunGrid:GetComponent("UIGrid"):Reposition();

end

--获取游戏中的混牌
function DZAHM_RePlayUILayer:GetHunPlates()
    return self.DZAHM_RePlayLogic.variableMahjong
end


function DZAHM_RePlayUILayer:SetPlayerSelectPao()
    self.DZAHM_RePlayLogic:ForeachPlayerDatas(function(_,playerData) 
        local realIndex = self.DZAHM_RePlayLogic:GetCorrectUIIndex(self.DZAHM_RePlayLogic:GetPlayerViewIndexBySeat(playerData.seat));
        local playerView = gameUIObjects.playerViews[realIndex];
        playerView:SetRunScore(playerData.paoScore);
    end);
end










