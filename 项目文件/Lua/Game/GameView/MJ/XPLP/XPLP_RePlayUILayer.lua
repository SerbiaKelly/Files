require("XPLP_Player");
require("XPLP_ReplayGridTool");
require("XPLP_PlayLogic");
require("XPLP_RePlayEventBind");
require("XPLP_Tools");
require("const");
require("effManger");
local gameUIObjects         = require("XPLP_GameObjs");
local json                  = require("json");
XPLP_RePlayUILayer          = class();


local cardColorNum = 2;--牌色的数量
local BgColorNum = 3;--背景颜色的数量

local bgColor;--牌色的索引
local cardColor;--背景的颜色索引1.蓝色 2.绿色
local cardText;--背景的字体索引
local language;--语言设置

local dragDepthOffset = 100;
local dragCardFrameDepth = 0;
local dragCardDepth = 0;
local tingTipDepth = 0;
DestroyRoomData = {};
local this = nil;






function XPLP_RePlayUILayer:ctor(gameObject,XPLP_RePlayLogic,game_pb)
    this                    = self;
    self.XPLP_RePlayLogic   = XPLP_RePlayLogic;
    self.xplp_pb            = game_pb;
    self.gameObject         = gameObject;
    self.isPause            = false
    self.playInterval       = 1.5
    self.playIndex          = 1
    self.rawSpeed           = self.playInterval;
    self.cutTime            = 0.25
    self.playCoroutine      = nil;

    self:GetUIS(self.gameObject);
    

end

function XPLP_RePlayUILayer:GetGameLogic()
    return self.XPLP_RePlayLogic;
end


function XPLP_RePlayUILayer:GetUIS(gameObject)
    gameUIObjects.CleanObjs();
    self:GetPlayersUI(gameObject);      --获得人物相关的UI
    self:GetRoomInfoUI(gameObject);     --房间信息
    self:GetButtons(gameObject);        --获得游戏中的各种按钮
    self:GetESWNUI(gameObject);         --房间信息self:GetESWNUI(gameObject);--获得桌子上东南西北那些UI
    
end

function XPLP_RePlayUILayer:GetPlayersUI(gameObject)
    local maxPlayerSize = self.XPLP_RePlayLogic:GetMaxPlayerSize();
    local gamers = gameObject.transform:Find("Gamers");
    for i=1,maxPlayerSize do
        local objectStr             = "Player"..i;
        local obj                   = gamers:Find(objectStr);
        local gridHand              = gameObject.transform:Find(objectStr.."_mj/GridHand");
        local gridXi                = gameObject.transform:Find(objectStr.."_mj/GridXi");
        local gridThrow             = gameObject.transform:Find(objectStr.."_mj/TabelThrow");
        local gridMo                = gameObject.transform:Find(objectStr.."_mj/MoPaiGrid");
        local chuPaiShow            = gameObject.transform:Find("playerOperationEffect/"..objectStr.."/outCardItem");
        local callBacktable         = self:GetPlatesCallBacks(i);
        local XPLP_ReplayGridTool   = XPLP_ReplayGridTool.New(gridHand,gridXi,gridThrow,gridMo,chuPaiShow,(i-1),callBacktable,{uiLayer = self});
        local playerView            = XPLP_Player.New(obj.gameObject,gameObject);
        local RoundDetail           = {};
        RoundDetail.openUserCard    = true;
        RoundDetail.isLord          = true;
        playerView:SetGameLogic(self.XPLP_RePlayLogic):SetMJGridTool(XPLP_ReplayGridTool,self.XPLP_RePlayLogic,self);
        playerView:SetRoundDetail(RoundDetail);
        table.insert(gameUIObjects.playerViews, playerView);
        gameUIObjects.playerOperationEffectPos[i]   = gameObject.transform:Find("playerOperationEffect/"..objectStr.."/operation_pos").position;
        if gameUIObjects.playerChuPaiPos[i] == nil then 
            gameUIObjects.playerChuPaiPos[i] =  gameObject.transform:Find("playerOperationEffect/"..objectStr.."/outCardItem").position;
        end
        if gameUIObjects.playerRePlayTableThrowGridPos[i] == nil then 
            gameUIObjects.playerRePlayTableThrowGridPos[i] = gridThrow.localPosition;
        end
        if gameUIObjects.playerGridHandPos[i] == nil then 
            gameUIObjects.playerGridHandPos[i]  = gridHand.localPosition;
        end
    end
    
end

function XPLP_RePlayUILayer:GetPlatesCallBacks(index)
    local callBacktable = {};
    callBacktable.OnClickOutMahjong         = XPLP_RePlayEventBind.OnClickOutMahjong;
    -- print("GetPlatesCallBacks.callBacktable");
    -- print_r(callBacktable);
    return callBacktable;
end



function XPLP_RePlayUILayer:GetButtons(gameObject)
    -- print("gameUIObjects.operation_send="..tostring(gameUIObjects.operation_send));
    gameUIObjects.ButtonHu 				= gameUIObjects.operation_send:Find('Button2Hu');
    gameUIObjects.ButtonGang 			= gameUIObjects.operation_send:Find('Button3Gang');
	gameUIObjects.ButtonPeng 			= gameUIObjects.operation_send:Find('Button5Peng');
	gameUIObjects.ButtonChi 			= gameUIObjects.operation_send:Find('Button6Chi');
	gameUIObjects.ButtonGuo 			= gameUIObjects.operation_send:Find('Button1Guo');
    gameUIObjects.ButtonBu 				= gameUIObjects.operation_send:Find('Button4Bu');
    -- print("gameUIObjects.ButtonChi="..tostring(gameUIObjects.ButtonChi));
	
end

function XPLP_RePlayUILayer:GetRoomInfoUI(gameObject)
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

function XPLP_RePlayUILayer:GetESWNUI(gameObject)
    gameUIObjects.dipai 			    = gameObject.transform:Find('DiPai');
    for i=1,self.XPLP_RePlayLogic:GetMaxPlayerSize() do
        gameUIObjects.ActivePlayerESWN[i] = gameObject.transform:Find("DiPai/DeskTimerIndex"..i);
    end
end

function XPLP_RePlayUILayer:InitUILayer(roomData)
    -- print("InitUILayer was called----->.roomData.state"..tostring(roomData.state))
    self.roomData = roomData;
    --  print("InitUILayer,roomData.surplus"..tostring(roomData.surplus));
     -- 人物信息
    self:InitPlayerInfo(self.roomData);
    -- 房间信息
    self:InitRoomInfo(self.roomData);
    -- 手牌信息
    self:InitAllGrids(self.roomData);
    --东南西北
    self:InitESWNInfo(self.roomData);

    XPLP_RePlayEventBind.Init(self,gameUIObjects,self.XPLP_RePlayLogic);--绑定事件
    self:InitControls();
    self:StartPlay();--开始播放


end

function XPLP_RePlayUILayer:InitRoomInfo(roomData)
    --获取主题颜色
	bgColor 	= UnityEngine.PlayerPrefs.GetInt('bgColor_xplp', 1);
	cardColor 	= UnityEngine.PlayerPrefs.GetInt('cardColor_xplp', 1);
    cardText 	= UnityEngine.PlayerPrefs.GetInt('cardText_xplp', 1);
    language 	= UnityEngine.PlayerPrefs.GetInt('language_xplp', 2);
    coroutine.start(RefreshTime,gameUIObjects.roomTime:GetComponent("UILabel"),60);
    coroutine.start(RefreshPhoneState,self.gameObject,self.XPLP_RePlayLogic,gameUIObjects.batteryLevel,gameUIObjects.network);
    gameUIObjects.roomID:GetComponent("UILabel").text                       = self.roomData.roomNumber;
    gameUIObjects.waitRoomID:GetComponent("UILabel").text                   = self.roomData.roomNumber;
    gameUIObjects.roomSetting:Find('Label'):GetComponent('UILabel').text    = GetXPLPRuleText(roomData.setting,false,false);
    gameUIObjects.gameTypeobj:Find("playName"):GetComponent("UILabel").text = roomData.playName;
    self:SetInviteVisiable(false);
    self:HideWaittingUI();
    gameUIObjects.curOperatPlateEffect.gameObject:SetActive(false);


end


function XPLP_RePlayUILayer:InitPlayerInfo(roomData)
    -- print("InitPlayerInfo------------------------------------>");
    self:AutoRegisterPlayerView(roomData.seat,roomData.setting.size);
    self:SetPlayerPos(roomData);
    DestroyRoomData.roomData 	    = roomData;
    DestroyRoomData.playerData      = self.XPLP_RePlayLogic:GetPlayerDatas();
    DestroyRoomData.mySeat 		    = self.XPLP_RePlayLogic.mySeat;

end

function XPLP_RePlayUILayer:InitAllGrids(roomData)
    --隐藏所有的grid
    for i=1,#gameUIObjects.playerViews do
        gameUIObjects.playerViews[i].xplp_GridTool:HideAllGrid();
    end

    if self.roomData.state == self.xplp_pb.GAMING then 
        self:RefreshAllGrid();
        self:SetActivePlayer(self.roomData);
        self:SetGameTypePos();
    end
    --显示玩家的操作
    -- print("mySeat:"..tostring(self.XPLP_RePlayLogic.mySeat));
    -- print("playerdatas.length:"..self.XPLP_RePlayLogic:GetPlayerDataLength());
    local myData = self.XPLP_RePlayLogic:GetPlayerDataBySeat(self.XPLP_RePlayLogic.mySeat);
    -- print("myoperations.length:"..#myData.operations);
    self:RefreshOperationSend(myData.operations,myData);
    --处理听牌
    local myData        = self.XPLP_RePlayLogic:GetPlayerDataBySeat(self.XPLP_RePlayLogic.mySeat);
    local myRealIndex   = self.XPLP_RePlayLogic:GetCorrectUIIndex(self.XPLP_RePlayLogic:GetPlayerViewIndexBySeat(myData.seat));
    local myPlayerView  = gameUIObjects.playerViews[myRealIndex];
   

end

function XPLP_RePlayUILayer:SetGameTypePos()
	if gameUIObjects.roomSetting.gameObject.activeSelf then
		gameUIObjects.roomSetting.localPosition = Vector3.New(-4,141,0);
	else
		gameUIObjects.roomSetting.localPosition = Vector3.New(-4,102,0);
	end
end

function XPLP_RePlayUILayer:InitESWNInfo(roomData)
    gameUIObjects.dipai.gameObject:SetActive(false);
    self:SetDipaiNum(roomData.surplus);
    self:SetRoundNum(roomData.round);
    gameUIObjects.dipai.gameObject:SetActive(XPLP_PlayLogic.NeedShowDiPai(self.roomData,self.XPLP_RePlayLogic));
    gameUIObjects.roomRound.gameObject:SetActive(XPLP_PlayLogic.NeedShowDiPai(self.roomData,self.XPLP_RePlayLogic));
    self:SetActivePlayer(self.roomData);
end


function XPLP_RePlayUILayer:SetPlayerPos(roomData)
    --设置座位位置
    for i=1,#gameUIObjects.playerViews do
        local playerView =  gameUIObjects.playerViews[i];
        playerView:NeedHideSelf(roomData.setting.size);
    end
end


--刷新所有grid
function XPLP_RePlayUILayer:RefreshAllGrid( )
    -- body
    -- print("RefreshAllGrid------------->")
    self.XPLP_RePlayLogic:ForeachPlayerDatas(function(playerView,_) 
        playerView.xplp_GridTool:SetLayOut();
    end);
    self:RefreshAllGridXi();
    self:RefreshAllGridHand();
    self:RefreshAllGridMoPai();
    self:RefreshAllGridThrow();
end

--刷新手牌
function XPLP_RePlayUILayer:RefreshAllGridHand()
    -- print("RefreshAllGridHand----------->")
    self.XPLP_RePlayLogic:ForeachPlayerDatas(function(playerView,playerData) 
        -- print("playerName:"..playerData.name..",seat:"..playerData.seat..",mahjongs.length:"..(#playerData.mahjongs));
        playerView.xplp_GridTool.gridHand.gameObject:SetActive(true);
        playerView.xplp_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
        local realIndex = self.XPLP_RePlayLogic:GetCorrectUIIndex(self.XPLP_RePlayLogic:GetPlayerViewIndexBySeat(playerData.seat));
        playerView.xplp_GridTool.gridHand.localPosition = gameUIObjects.playerGridHandPos[realIndex];
        
    end);
end

--刷新喜牌
function XPLP_RePlayUILayer:RefreshAllGridXi()
    -- print("RefreshAllGridXi----------->")
    self.XPLP_RePlayLogic:ForeachPlayerDatas(function(playerView,playerData) 
        playerView.xplp_GridTool:SetGridXiVisible(true);
        playerView.xplp_GridTool:RefreshGridXi(playerData.operationCards);
    end);
end

--刷新带出去的牌
function XPLP_RePlayUILayer:RefreshAllGridThrow()
    -- print("RefreshAllGridThrow----------->")
    self.XPLP_RePlayLogic:ForeachPlayerDatas(function(playerView,playerData) 
        playerView.xplp_GridTool:SetGridThrowVisible(true);
        playerView.xplp_GridTool:RefreshGridThrow(playerData.paiHe);
    end);
end

--刷新摸牌
function XPLP_RePlayUILayer:RefreshAllGridMoPai()
    -- print("RefreshAllGridMoPai----------->")
    self.XPLP_RePlayLogic:ForeachPlayerDatas(function(_,playerData) 
        local playerView = gameUIObjects.playerViews[self.XPLP_RePlayLogic:GetCorrectUIIndex(self.XPLP_RePlayLogic:GetPlayerViewIndexBySeat(playerData.seat))];
        playerView.xplp_GridTool:SetGridMoVisible(playerData.moMahjong ~= -1 and playerData.guChou ~= 1);
        playerView.xplp_GridTool:RefreshMoPai(playerData.moMahjong);
    end);
end

function XPLP_RePlayUILayer:AutoRegisterPlayerView(mySeat, size)
     for i = 1, self.XPLP_RePlayLogic:GetMaxPlayerSize() do
        gameUIObjects.playerViews[i]:OpenView();
        self.XPLP_RePlayLogic:RegisterPlayerView(gameUIObjects.playerViews[i]);
    end
    self.XPLP_RePlayLogic:ResetAllPlayerView();
end

function XPLP_RePlayUILayer:SetRoundStart( data )
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

function XPLP_RePlayUILayer:SetRoomInfo(roomData)
    self:SetDipaiNum(roomData.surplus);
    self:SetRoundNum(roomData.round);
end
function XPLP_RePlayUILayer:SetGameRoundEnd( RoundEndData )
    -- body
    RoundEndData.uiLayer = self;
    PanelManager.Instance:ShowWindow("panelStageClear_xplp",RoundEndData)
    PanelManager.Instance:HideWindow("panelChat");
    PanelManager.Instance:HideWindow("panelGameSetting_xplp");
    self.XPLP_RePlayLogic:ResetGameState();
    self:SetDipaiNum(self.roomData.surplus);
    self:SetRoundNum(self.roomData.round);
    self:ClearUI();
end

--清除一些UI上的状态
function XPLP_RePlayUILayer:ClearUI()
    -- body
    --1.时钟
    gameUIObjects.dipai:Find("timer"):GetComponent("UILabel").text = 0;
    XPLP_Tools.StopCount(gameUIObjects.dipai:Find("timer"));
    --2.操作列表
    gameUIObjects.operation_send.gameObject:SetActive(false);
end

--刷新所有UI
function XPLP_RePlayUILayer:RefreshAllUI()

end

function XPLP_RePlayUILayer:RefreshPlayer()
    self.XPLP_RePlayLogic:ForeachPlayerDatas(function(_,playerData)
        local playerView = gameUIObjects.playerViews[self.XPLP_RePlayLogic:GetCorrectUIIndex(self.XPLP_RePlayLogic:GetPlayerViewIndexBySeat(playerData.seat))]; 
        playerView:SetReady(playerData.ready and self.roomData.state == self.xplp_pb.WAITING);
        playerView:ResetView(playerData);--重新设置玩家的UI
        playerView:SetOnlyOfflineFlag(not playerData.connected);
    end);
    
end



function XPLP_RePlayUILayer:SetActivePlayer(roomData)
    self:ShowWaitOpreatEffect(roomData.activeSeat,roomData.state == self.xplp_pb.GAMING);
    for i=1,#gameUIObjects.playerViews do
        gameUIObjects.playerViews[i]:SetActiveFlag(false);
    end
    local playerView = gameUIObjects.playerViews[self.XPLP_RePlayLogic:GetCorrectUIIndex(self.XPLP_RePlayLogic:GetPlayerViewIndexBySeat(roomData.activeSeat))];
    playerView:SetActiveFlag(true and roomData.state == self.xplp_pb.GAMING);
end

function XPLP_RePlayUILayer:GetOverTrusteeship()
    local Trusteeships={}
    for i = 0, self.roomData.setting.size-1 do
        local playerView = gameUIObjects.playerViews[self.XPLP_RePlayLogic:GetCorrectUIIndex(self.XPLP_RePlayLogic:GetPlayerViewIndexBySeat(i))];
        Trusteeships[i] = playerView.trusteeshipFlag.gameObject.activeSelf;
    end
    return Trusteeships;
end

function XPLP_RePlayUILayer:ChangePaiSize(xplpPaiSize)

end


function XPLP_RePlayUILayer:SetGameRoundOver(RoundAllData)

    local overData = {};
    overData.RoundAllData   = RoundAllData;
    overData.roomInfo       = roomInfo;
    -- print("RoundAllData.data.complete:"..tostring(RoundAllData.data.complete)..",self.XPLP_RePlayLogic.hasStageClear:"..tostring(self.XPLP_RePlayLogic.hasStageClear));
    if not RoundAllData.data.complete and not self.XPLP_RePlayLogic.hasStageClear then 
        PanelManager.Instance:ShowWindow("panelStageClearAll_xplp",overData);
        PanelManager.Instance:HideWindow("panelChat");
        PanelManager.Instance:HideWindow("panelGameSetting_xplp");
    end
    self:ClearUI();
end


function XPLP_RePlayUILayer.Update(obj)
    -- print("Update-------------------->");
   
end

--玩家摸牌
function XPLP_RePlayUILayer:SetPlayerMoPai(moData)
    --先隐藏所有的摸牌的grid
    for i=1,#gameUIObjects.playerViews do
        gameUIObjects.playerViews[i].xplp_GridTool:SetGridMoVisible(false);
    end
    local playerView = gameUIObjects.playerViews[self.XPLP_RePlayLogic:GetCorrectUIIndex(self.XPLP_RePlayLogic:GetPlayerViewIndexBySeat(moData.seat))];
    local playerData = self.XPLP_RePlayLogic:GetPlayerDataBySeat(moData.seat);
    playerView.xplp_GridTool:SetGridMoVisible(playerData.guChou ~= 1);--如果玩家箍臭了，那么摸得牌直接放进手牌，并且不用展示摸牌了
    playerView.xplp_GridTool:RefreshMoPai(playerData.moMahjong);
   
    self:SetDipaiNum(self.roomData.surplus);
    playerView.xplp_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
    self:SetActivePlayer(self.roomData);
    if moData.operation and #moData.operation>0 then 
        for i=1,#moData.operation do
            if moData.operation[i].seat == self.XPLP_RePlayLogic.mySeat then 
                self:RefreshOperationSend(moData.operation[i].operation,playerData);
            end
        end
    end
    
end

--玩家出牌
function XPLP_RePlayUILayer:SetPlayerChuPai(chuData)
    -- print("player.seat"..chuData.seat.." chu pai,plate="..chuData.mahjong);
    local playerView    = gameUIObjects.playerViews[self.XPLP_RePlayLogic:GetCorrectUIIndex(self.XPLP_RePlayLogic:GetPlayerViewIndexBySeat(chuData.seat))];
    local playerData    = self.XPLP_RePlayLogic:GetPlayerDataBySeat(chuData.seat);
    local myData        = self.XPLP_RePlayLogic:GetPlayerDataBySeat(self.XPLP_RePlayLogic.mySeat);
    playerView.xplp_GridTool:RefreshGridThrow(playerData.paiHe);
    playerView.xplp_GridTool:SetGridMoVisible(false);
    self:SetPlayerChuPaiShow(chuData.seat,chuData.mahjong);
    self:SetLastPlayerChuPaiEffect(chuData.seat);
    if chuData.seat == self.XPLP_RePlayLogic.mySeat then 
        playerView.xplp_GridTool:SetGridMoVisible(false);
    end
    --出牌之后，手牌回到原来的位置，因为遮住的那张牌已经打出去了
    playerView.xplp_GridTool:SetGridHandPos(gameUIObjects.playerGridHandPos[self.XPLP_RePlayLogic:GetCorrectUIIndex(self.XPLP_RePlayLogic:GetPlayerViewIndexBySeat(chuData.seat))]);
    playerView.xplp_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
    --出牌后，手牌的grid回到原来的位置，不然就遮住摸牌了
    if chuData.seat ~= self.XPLP_RePlayLogic.mySeat then 
        playerView.xplp_GridTool:SetGridHandPos(CONST.XPLPNoGuChouGridPos[self.XPLP_RePlayLogic:GetCorrectUIIndex(self.XPLP_RePlayLogic:GetPlayerViewIndexBySeat(chuData.seat))]);
    end
    AudioManager.Instance:PlayAudio(self:GetAudioPrefix().."xplp_"..(playerData.sex==1 and 'man_' or 'woman_')..math.floor(chuData.mahjong / 9 + 1)..(chuData.mahjong % 9 + 1))
    if chuData.operation and #chuData.operation>0 then 
        for i=1,#chuData.operation do
            if chuData.operation[i].seat == self.XPLP_RePlayLogic.mySeat then 
                self:RefreshOperationSend(chuData.operation[i].operation,playerData);
            end
        end
    end
    
end

--玩家吃牌
function XPLP_RePlayUILayer:SetPlayerChiPai(chiData)
    --1.显示特效
    local realIndex     = self.XPLP_RePlayLogic:GetCorrectUIIndex(self.XPLP_RePlayLogic:GetPlayerViewIndexBySeat(chiData.seat));
    local outRealIndex  = self.XPLP_RePlayLogic:GetCorrectUIIndex(self.XPLP_RePlayLogic:GetPlayerViewIndexBySeat(chiData.outSeat));
    local playerView    = gameUIObjects.playerViews[realIndex];
    local playerData    = self.XPLP_RePlayLogic:GetPlayerDataBySeat(chiData.seat);
    local outPlayerData = self.XPLP_RePlayLogic:GetPlayerDataBySeat(chiData.outSeat);
    local outPlayerView = gameUIObjects.playerViews[outRealIndex];
    effManger.ShowEffect(self.gameObject,"chi",gameUIObjects.playerOperationEffectPos[realIndex]);
    --2.刷新喜牌
    playerView.xplp_GridTool:RefreshGridXi(playerData.operationCards);
    
    --3.刷新牌桌上的牌
    outPlayerView.xplp_GridTool:RefreshGridThrow(outPlayerData.paiHe);
    --4.刷新手牌
    playerView.xplp_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
    --手牌要移动一段距离[自己的位置不用移动,其他玩家需要]
    if chiData.seat ~= self.XPLP_RePlayLogic.mySeat then 
        playerView.xplp_GridTool:SetGridHandPos(self:GetGridHandMovedPos(playerView.xplp_GridTool));
    end
    --8.刷新当前出牌玩家
    self:SetActivePlayer(self.roomData);
    AudioManager.Instance:PlayAudio(self:GetAudioPrefix().."xplp_"..(playerData.sex==1 and 'man' or 'woman').."_chi");
    --9.隐藏最后出牌的指示器
    gameUIObjects.curOperatPlateEffect.gameObject:SetActive(false);

    if chiData.seat == self.XPLP_RePlayLogic.mySeat then 
        self:PlayerSelectOperation("chi");
    else
        self:PlayerSelectOperation("guo");
    end

    if chiData.operation and #chiData.operation > 0 then 
        for i=1,#chiData.operation do
            if chiData.operation[i].seat == self.XPLP_RePlayLogic.mySeat then 
                self:RefreshOperationSend(chiData.operation[i].operation,playerData);
            end
        end
    end
end

--玩家碰牌
function XPLP_RePlayUILayer:SetPlayerPengPai(pengData)
    local realIndex     = self.XPLP_RePlayLogic:GetCorrectUIIndex(self.XPLP_RePlayLogic:GetPlayerViewIndexBySeat(pengData.seat));
    local outRealIndex  = self.XPLP_RePlayLogic:GetCorrectUIIndex(self.XPLP_RePlayLogic:GetPlayerViewIndexBySeat(pengData.outSeat));
    local playerView    = gameUIObjects.playerViews[realIndex];
    local playerData    = self.XPLP_RePlayLogic:GetPlayerDataBySeat(pengData.seat);
    local outPlayerData = self.XPLP_RePlayLogic:GetPlayerDataBySeat(pengData.outSeat);
    local outPlayerView = gameUIObjects.playerViews[outRealIndex];
    --显示特效
    effManger.ShowEffect(self.gameObject,"peng",gameUIObjects.playerOperationEffectPos[realIndex]);
    playerView.xplp_GridTool:RefreshGridXi(playerData.operationCards);
    outPlayerView.xplp_GridTool:RefreshGridThrow(outPlayerData.paiHe);
    playerView.xplp_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
    --碰牌后需要把手牌移动一段距离,不然会遮住喜牌
    if pengData.seat ~= self.XPLP_RePlayLogic.mySeat then 
        playerView.xplp_GridTool:SetGridHandPos(self:GetGridHandMovedPos(playerView.xplp_GridTool));
    end
    
    self:SetActivePlayer(self.roomData);
    AudioManager.Instance:PlayAudio(self:GetAudioPrefix().."xplp_"..(playerData.sex==1 and 'man' or 'woman').."_peng");
    gameUIObjects.curOperatPlateEffect.gameObject:SetActive(false);

    if pengData.seat == self.XPLP_RePlayLogic.mySeat then 
        self:PlayerSelectOperation("peng");
    else
        self:PlayerSelectOperation("guo");
    end

    if pengData.operation and #pengData.operation > 0 then 
        for i=1,#pengData.operation do
            if pengData.operation[i].seat == self.XPLP_RePlayLogic.mySeat then 
                self:RefreshOperationSend(pengData.operation[i].operation,playerData);
            end
        end
    end
end



function XPLP_RePlayUILayer:GetGridHandMovedPos(gridTool)
    if gridTool == nil then 
        return Vector3.New(0,0,0);
    end
    local originPos = gridTool.gridHand.localPosition;
    local grid = gridTool.gridHand:GetComponent("UIGrid");
    if gridTool.posIndex == 0 then 
        return originPos;
    elseif gridTool.posIndex == 1 then 
        return Vector3.New(originPos.x,originPos.y+(grid.cellWidth*CONST.XPLPGridScale[gridTool.posIndex+1]),0);
    elseif gridTool.posIndex == 2 then 
        return Vector3.New(originPos.x - (grid.cellWidth*CONST.XPLPGridScale[gridTool.posIndex+1]),originPos.y,0);
    elseif gridTool.posIndex == 3 then 
        return Vector3.New(originPos.x,originPos.y-(grid.cellWidth*CONST.XPLPGridScale[gridTool.posIndex+1]),0);
    end
    return Vector3.New(0,0,0);
end



--玩家过牌
function XPLP_RePlayUILayer:SetPlayerGuoPai(guoData)
    self:PlayerSelectOperation("guo");
end

--玩家胡牌
function XPLP_RePlayUILayer:SetPlayerHuPai(huData)
    -- print("SetPlayerHuPai was called-------------------------->");
    local realIndex = self.XPLP_RePlayLogic:GetCorrectUIIndex(self.XPLP_RePlayLogic:GetPlayerViewIndexBySeat(huData.seat));
    local playerView = gameUIObjects.playerViews[realIndex];
    local playerData = self.XPLP_RePlayLogic:GetPlayerDataBySeat(huData.seat);
    -- print("huData.seat:"..huData.seat..",huData.outSeat:"..huData.outSeat);
    if huData.seat == huData.outSeat then 
        AudioManager.Instance:PlayAudio(self:GetAudioPrefix().."xplp_"..(playerData.sex == 1 and "man_" or "woman_").."zimo");
	    effManger.ShowEffect(self.gameObject, 'zm', gameUIObjects.playerOperationEffectPos[realIndex]);
    else
        AudioManager.Instance:PlayAudio(self:GetAudioPrefix().."xplp_"..(playerData.sex == 1 and "man_" or "woman_").."hu");
        effManger.ShowEffect(self.gameObject, 'hu', gameUIObjects.playerOperationEffectPos[realIndex]);
        self:SetPao(huData);
    end
    -- print("huData.seat:"..huData.seat..",self.XPLP_RePlayLogic.mySeat:"..self.XPLP_RePlayLogic.mySeat);
    if huData.seat == self.XPLP_RePlayLogic.mySeat then 
        self:PlayerSelectOperation("hu");
    else
        self:PlayerSelectOperation("guo");
    end
end


function XPLP_RePlayUILayer:SetPao(winData)
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
    local realIndex = self.XPLP_RePlayLogic:GetCorrectUIIndex(self.XPLP_RePlayLogic:GetPlayerViewIndexBySeat(winData.outSeat));
	if isFangPao  then -- 放炮
        -- print("fp-------------->1");
		effManger.ShowEffect(self.gameObject, 'fp', gameUIObjects.playerOperationEffectPos[realIndex]);
	else -- 通炮
		-- print("tp-------------->2");
		effManger.ShowEffect(self.gameObject, 'tp', gameUIObjects.playerOperationEffectPos[realIndex]);
    end
end

function XPLP_RePlayUILayer:GetgameUIObjects()
    return gameUIObjects;
end


--根据背景设置文字颜色
function XPLP_RePlayUILayer:SetGameColor(bgIndex)
    gameUIObjects.dipai:Find("frame/roundHead"):GetComponent("UILabel").color           = self:getAccorColor(color);
	gameUIObjects.dipai:Find("frame/roundHead/roundTail"):GetComponent("UILabel").color = self:getAccorColor(color);
	gameUIObjects.roomRound:GetComponent("UILabel").color                               = self:getNumColor(color);
	gameUIObjects.dipai:Find("frame/leftHead"):GetComponent("UILabel").color            = self:getAccorColor(color);
	gameUIObjects.dipai:Find("frame/leftHead/leftTail"):GetComponent("UILabel").color   = self:getAccorColor(color);
	gameUIObjects.dipai:Find('frame/leftCard'):GetComponent('UILabel').color            = self:getNumColor(color);
end

function XPLP_RePlayUILayer:getAccorColor(color)
	if color == 1 then
		return Color.New(57/255,123/255,174/255);
	else
		return Color.New(52/255,209/255,186/255);
	end
end

function XPLP_RePlayUILayer:getNumColor(color)
	if color == 1 then
		return Color.New(76/255,189/255,197/255);
	else
		return Color.New(205/255,220/255,114/255);
	end
end

--选择背景
function XPLP_RePlayUILayer:ChooseBG(bgIndex)
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
function XPLP_RePlayUILayer:SetRoundNum(num)
    -- print("SetRoundNum------------------>was called,num:"..tostring(num));
    gameUIObjects.roomRound:GetComponent("UILabel").text = num..'/'..self.roomData.setting.rounds;
end

--设置底牌的剩余数目
function XPLP_RePlayUILayer:SetDipaiNum(num)
    gameUIObjects.dipai:Find('frame/leftCard'):GetComponent('UILabel').text = string.format('%d', num);
end

--设置邀请好友，解散房间，分享按钮的显示和隐藏
function XPLP_RePlayUILayer:SetInviteVisiable(show)
    if not PlatformManager.Instance:IsWXAppInstalled() then
		show = false
    end
end

--显示出牌的状态，东西南北，哪个该出牌了
--当前该出牌的玩家
function XPLP_RePlayUILayer:ShowWaitOpreatEffect(activeSeat,show)
    -- print("ShowWaitOpreatEffect,activeSeat="..tostring(activeSeat)..",show="..tostring(show));
    --先隐藏所有
    for i=1,self.XPLP_RePlayLogic:GetMaxPlayerSize() do
        self:SetESWNState(i,false);
    end
    
    for i=1,self.XPLP_RePlayLogic.totalSize do
        local index = self.XPLP_RePlayLogic:GetPlayerViewIndexBySeat(activeSeat);
        self:SetESWNState(self.XPLP_RePlayLogic:GetCorrectUIIndex(index),show);
    end
    --倒计时
    if show then 
        XPLP_Tools.CountDown(gameUIObjects.dipai:Find("timer"),15,0);
    end
end


function XPLP_RePlayUILayer:SetESWNState(index,show)	gameUIObjects.ActivePlayerESWN[index]:Find('select').gameObject:SetActive(show);
   gameUIObjects.ActivePlayerESWN[index]:Find('frame').gameObject:SetActive(show);
   gameUIObjects.ActivePlayerESWN[index]:Find('unselect').gameObject:SetActive(not show);
   gameUIObjects.playerViews[index]:SetActiveFlag(show);
   
end


--显示等待的时候需要显示的UI，隐藏游戏进行中的UI
function XPLP_RePlayUILayer:ShowWaittingUI()
    -- print("ShowWaittingUI-------------->was called");
    gameUIObjects.dipai.gameObject:SetActive(XPLP_PlayLogic.NeedShowDiPai(self.roomData,self.XPLP_RePlayLogic));
    gameUIObjects.roomSetting.gameObject:SetActive(true);
    gameUIObjects.roomSetting:Find("roominfo").gameObject:SetActive(false);
    gameUIObjects.roomRound.gameObject:SetActive(XPLP_PlayLogic.NeedShowDiPai(self.roomData,self.XPLP_RePlayLogic));
    self:SetGameTypePos();
end

--隐藏等待时显示的UI，显示游戏进行中的UI
function XPLP_RePlayUILayer:HideWaittingUI()
    -- print("HideWaittingUI---------------was called");
    -- print("NeedShowDiPai:"..tostring(XPLP_PlayLogic.NeedShowDiPai(self.roomData,self.XPLP_RePlayLogic)));
    gameUIObjects.roomSetting.gameObject:SetActive(true);
    gameUIObjects.roomSetting:Find("roominfo").gameObject:SetActive(false);
    gameUIObjects.dipai.gameObject:SetActive(XPLP_PlayLogic.NeedShowDiPai(self.roomData,self.XPLP_RePlayLogic));
    gameUIObjects.roomRound.gameObject:SetActive(XPLP_PlayLogic.NeedShowDiPai(self.roomData,self.XPLP_RePlayLogic));
    self:SetGameTypePos();
end




function XPLP_RePlayUILayer:getCardColor()
    return cardColor;
end

function XPLP_RePlayUILayer:getcardText()
    return cardText;
end

function XPLP_RePlayUILayer:GetAudioPrefix()
    return language == 1 and "" or "fy_";
end

----根据颜色值获取溆浦老牌背板图片
function XPLP_RePlayUILayer:getColorCardName(name,colorIndex)
    if colorIndex == 1 then --绿色
		return name;
	elseif colorIndex == 2 then --黄色
		return name..'y';
	end
end

--根据用户选择选择已出牌的牌面
function XPLP_RePlayUILayer:GetOutCardTextName(plateIndex,cardTextIndex)
    --s60p 意思缩小60%的牌面
    return "s60p_"..tostring(plateIndex);
end

--根据用户选择选择溆浦老牌的牌面
function XPLP_RePlayUILayer:GetCardTextName(plateIndex,cardTextIndex)
    return tostring(plateIndex);
end


--获取游戏语言选择
function XPLP_RePlayUILayer:GetLanguage()
    return language;
end

--根据用户的选择选择牌面大小
function XPLP_RePlayUILayer:GetCardPlateSize(plateIndex,cardTextIndex)
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

function XPLP_RePlayUILayer:SetPlateColor(throwItemobj,showColor)
    if showColor then
		throwItemobj:GetComponent("UISprite").color = Color(255/255,222/255,84/255);
	else
		throwItemobj:GetComponent("UISprite").color = Color(255/255,255/255,255/255);
	end
end

--设置玩家出牌展示
function XPLP_RePlayUILayer:SetPlayerChuPaiShow(seat,mahjong)
     local playerView = gameUIObjects.playerViews[self.XPLP_RePlayLogic:GetCorrectUIIndex(self.XPLP_RePlayLogic:GetPlayerViewIndexBySeat(seat))];
     playerView.xplp_GridTool:RefreshChuPai(mahjong);
end

--设置箭头指向最后一个玩家出的牌
function XPLP_RePlayUILayer:SetLastPlayerChuPaiEffect(seat)
    local playerView = gameUIObjects.playerViews[self.XPLP_RePlayLogic:GetCorrectUIIndex(self.XPLP_RePlayLogic:GetPlayerViewIndexBySeat(seat))];
    local playerData = self.XPLP_RePlayLogic:GetPlayerDataBySeat(seat);
    gameUIObjects.curOperatPlateEffect.gameObject:SetActive(true);
    StartCoroutine(function() 
        WaitForEndOfFrame();
         gameUIObjects.curOperatPlateEffect.position = playerView.xplp_GridTool.gridThrow:GetChild(#playerData.paiHe-1).position;
    end);

end


--玩家选择冲分
function XPLP_RePlayUILayer:SetPlayerChongScore(data)
    local playerData = self.XPLP_RePlayLogic:GetPlayerDataBySeat(data.seat);
    local playerView = gameUIObjects.playerViews[self.XPLP_RePlayLogic:GetCorrectUIIndex(self.XPLP_RePlayLogic:GetPlayerViewIndexBySeat(data.seat))];
    playerView:SetPlayerChong(playerData.choiceRoundScore);
    --fy_xplp_woman_chong0
    AudioManager.Instance:PlayAudio(self:GetAudioPrefix().."xplp_"..(playerData.sex==1 and 'man_' or 'woman_').."chong"..playerData.choiceRoundScore);
end

--玩家箍臭选择
function XPLP_RePlayUILayer:SetPlayerGuChou(data)
    local playerData = self.XPLP_RePlayLogic:GetPlayerDataBySeat(data.seat);
    local realIndex = self.XPLP_RePlayLogic:GetCorrectUIIndex(self.XPLP_RePlayLogic:GetPlayerViewIndexBySeat(data.seat));
    local playerView = gameUIObjects.playerViews[realIndex];
    playerView.xplp_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
    playerView.xplp_GridTool:SetGridHandPos(playerData.guChou == 1 and CONST.XPLPGuChouHandGridPos[realIndex] or CONST.XPLPNoGuChouGridPos[realIndex]);
    playerView:SetPlayerGuChou(playerData.guChou == 1);
end

--刷新玩家吃碰杠补等操作
function XPLP_RePlayUILayer:RefreshOperationSend(operations,playerData)
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
function XPLP_RePlayUILayer:SetOperationButtons(operations)
    gameUIObjects.operation_send.gameObject:SetActive(#operations ~= 0);
    gameUIObjects.ButtonHu.gameObject:SetActive(false);
	gameUIObjects.ButtonGang.gameObject:SetActive(false);
	gameUIObjects.ButtonPeng.gameObject:SetActive(false);
	gameUIObjects.ButtonChi.gameObject:SetActive(false);
	gameUIObjects.ButtonGuo.gameObject:SetActive(true);
    gameUIObjects.ButtonBu.gameObject:SetActive(false);
    for i=1,#operations do
        if operations[i] == self.xplp_pb.CHI then 
            gameUIObjects.ButtonChi.gameObject:SetActive(true);
        elseif operations[i] == self.xplp_pb.PENG then
            gameUIObjects.ButtonPeng.gameObject:SetActive(true); 
        elseif operations[i] == self.xplp_pb.GANG then 
            gameUIObjects.ButtonGang.gameObject:SetActive(true);
        elseif operations[i] == self.xplp_pb.BU then 
            gameUIObjects.ButtonBu.gameObject:SetActive(true);
        elseif operations[i] == self.xplp_pb.HU then 
            gameUIObjects.ButtonHu.gameObject:SetActive(true);
        end
    end
    gameUIObjects.operation_send:GetComponent("UIGrid"):Reposition();
end

--玩家从操作列表中选择了操作
function XPLP_RePlayUILayer:PlayerSelectOperation(operate)
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
        -- print("Tween gang------------->");
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
    
    -- print("tweenColor.GameObject:"..tostring(tweenColor.gameObject));
    -- print("tweenScale.GameObject:"..tostring(tweenScale.gameObject));
    -- print("tweenScale.duration:"..tweenScale.duration);
    -- print("tweenScale.duration:"..tweenScale.duration);

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

function XPLP_RePlayUILayer:ResetOperationTween( )
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

function XPLP_RePlayUILayer:StartPlay()
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
                self.XPLP_RePlayLogic:OnPlayerPlay(record);
                self.playIndex = self.playIndex + 1;
                print("当前进度 ",self.playIndex,"/",#self.roomData.records);
                if self.roomData.roundEnd and self.roomData.roundEnd~=nil then 
                    if self.playIndex > #self.roomData.records and #self.roomData.roundEnd.players > 0 then 
                        print(" replay round end!");
                        coroutine.wait(0.5);
                        self.XPLP_RePlayLogic:OnGameRoundEnd(self.roomData.roundEnd);
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
function XPLP_RePlayUILayer:InitControls()
    self.isPause            = false;
    self.playInterval       = 1.5;
    self.playIndex          = 1;
    self.rawSpeed           = self.playInterval;
    self.cutTime            = 0.25;
    gameUIObjects.ButtonPause:GetComponent('UIButton').normalSprite = 'zanting'
	gameUIObjects.FastLabel:GetComponent('UILabel').text = ''
    gameUIObjects.SlowLabel:GetComponent('UILabel').text = ''
end

function XPLP_RePlayUILayer:PlaySlow()
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

function XPLP_RePlayUILayer:PlayFast()
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

function XPLP_RePlayUILayer:PlayPause(isPause)
    if isPause then 
        self.isPause = isPause;
    else
         self.isPause = not self.isPause
    end
	if self.isPause then
		gameUIObjects.ButtonPause:GetComponent('UIButton').normalSprite = 'bofang'
	else
		gameUIObjects.ButtonPause:GetComponent('UIButton').normalSprite = 'zanting'
	end
end

function XPLP_RePlayUILayer:ExitPlay()
    coroutine.stop(self.playCoroutine);
    self.playCoroutine = nil;
    self.XPLP_RePlayLogic:ForeachPlayerDatas(function(playerView,playerData) 
        playerView:CloseView(); 
        playerView.xplp_GridTool:HideAllGrid();
    end);
    
    PanelManager.Instance:ShowWindow(self.roomData.backWinName);
	PanelManager.Instance:HideWindow(self.gameObject.name)
	PanelManager.Instance:HideWindow("panelStageClear_xplp");
	PanelManager.Instance:HideWindow("panelBetOn");
    AudioManager.Instance:PlayMusic('MainBG', true);
    self:InitControls();
end

function XPLP_RePlayUILayer:SetDismissType(go)
    if go == gameUIObjects.ButtondismissBackType.gameObject then 
        gameUIObjects.dismissTypeTip:Find("Tip").gameObject:SetActive(false);
        gameUIObjects.ButtondismissPopType.gameObject:SetActive(true);
    elseif go == gameUIObjects.ButtondismissPopType.gameObject then 
        gameUIObjects.dismissTypeTip:Find("Tip/text"):GetComponent("UILabel").text = self.roomData.diss;
        gameUIObjects.dismissTypeTip:Find("Tip").gameObject:SetActive(true);
        gameUIObjects.ButtondismissPopType.gameObject:SetActive(false);
    end
end







