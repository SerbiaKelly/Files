require("GPSTool");
require("HNZZM_GridTool");
require("HNZZM_PlayLogic");
require("HNZZM_EventBind");
require("HNZZM_Tools");
require("GameTools");
require("const");
require("effManger");
local gameUIObjects     = require("HNZZM_GameObjs");
local json              = require("json");
HNZZM_UILayer           = {};
HNZZM_UILayer           = class();


local cardColorNum = 2;--牌色的数量
local BgColorNum = 3;--背景颜色的数量

local bgColor;          --牌色的索引
local cardColor;        --背景的颜色索引1.蓝色 2.绿色
local cardText;         --背景的字体索引
local language;         --语言设置
local outPlateType;     --单击出牌选项，是单击出牌还是双击出牌
local HongzhongPlateValue = 31;--红中麻将的值

local dragDepthOffset = 100;
local dragCardFrameDepth = 0;
local dragCardDepth = 0;
dragmarkFrameDepth =0;
dragmarkDepth = 0;      
local tingTipDepth = 0;
DestroyRoomData = {};
local this = nil;
local TrusteeShipStates = 
{
    TrusteeShipCountting    = 0,--托管倒计时
    TrusteeShipping         = 1,--托管中
    TrusteeShipEnd          = 2,--结束托管
};


function HNZZM_UILayer:ctor(gameObject,HNZZM_Logic,game_pb)
    this                = self;
    self.HNZZM_Logic    = HNZZM_Logic;
    self.hnm_pb         = game_pb;
    self.gameObject     = gameObject;
    self:GetUIS(self.gameObject);
    local inGameUpdate  = panelInGame_hnzzm.Update;
    panelInGame_hnzzm.Update = function(obj) 
        inGameUpdate(obj);
        this.Update(obj);
    end ;
    self.TrusteeshipFsmMachine = FsmMachine:New();
    self.HongzhongPlateValue = HongzhongPlateValue;
end

function HNZZM_UILayer:GetGameLogic()
    return self.HNZZM_Logic;
end


function HNZZM_UILayer:GetTrusteeShipStates()
    return TrusteeShipStates;
end


function HNZZM_UILayer:GetUIS(gameObject)
    gameUIObjects.CleanObjs();
    self:GetPlayersUI(gameObject);      --获得人物相关的UI
    self:GetGPSUI(gameObject);          --获得GPS相关的UI
    self:GetRoomInfoUI(gameObject);     --房间信息
    self:GetButtons(gameObject);        --获得游戏中的各种按钮
    self:GetESWNUI(gameObject);         --房间信息self:GetESWNUI(gameObject);--获得桌子上东南西北那些UI
    
end

function HNZZM_UILayer:GetPlayersUI(gameObject)
    local maxPlayerSize = self.HNZZM_Logic:GetMaxPlayerSize();
    local gamers = gameObject.transform:Find("Gamers");
    for i=1,maxPlayerSize do
        local objectStr             = "Player"..i;
        local obj                   = gamers:Find(objectStr);
        local gridHand              = gameObject.transform:Find(objectStr.."_mj/GridHand");
        local gridXi                = gameObject.transform:Find(objectStr.."_mj/GridXi");
        local gridThrow             = gameObject.transform:Find(objectStr.."_mj/TabelThrow");
        local gridMo                = gameObject.transform:Find(objectStr.."_mj/MoPaiGrid");
        local chuPaiShow            = gameObject.transform:Find(objectStr.."_mj/chuPaiShow");
        local callBacktable         = self:GetPlatesCallBacks(i);
        local hnzzm_GridTool        = HNZZM_GridTool.New(gridHand,gridXi,gridThrow,gridMo,chuPaiShow,(i-1),callBacktable,{uiLayer = self});
        local playerView            = HNZZM_Player.New(obj.gameObject,gameObject);
        local RoundDetail           = {};
        RoundDetail.openUserCard    = true;
        RoundDetail.isLord          = true;
        playerView:SetGameLogic(self.HNZZM_Logic):SetMJGridTool(hnzzm_GridTool,self.HNZZM_Logic,self);
        playerView:SetRoundDetail(RoundDetail);
        hnzzm_GridTool:HideAllGrid();
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

function HNZZM_UILayer:GetPlatesCallBacks(index)
    local callBacktable = nil;
    if index == 1 then 
        callBacktable = {};
        callBacktable.OnDragStartPlate      = this.OnDragStartPlate;   
        callBacktable.OnDragEndtPlate       = this.OnDragEndtPlate;
        callBacktable.OnDoubleClickPlate    = this.OnDoubleClickPlate;
        callBacktable.OnClickMahjong        = this.OnClickMahjong;
        callBacktable.OnDragging            = this.OnDragging;
        callBacktable.OnPressMahJong        = this.OnPressMahJong;
    end
    return callBacktable;
end



function HNZZM_UILayer:GetGPSUI(gameObject)
    -- print("gameObject:"..tostring(gameObject));
    gameUIObjects.GpsView = gameObject.transform:Find("GPS");
    for i = 1, 6 do
        gameUIObjects.distances[i] = gameUIObjects.GpsView:Find("Distance/distance"..i);
    end

    for i = 1, 4 do
        gameUIObjects.gpsPlayers[i] = gameUIObjects.GpsView:Find("Players/Player"..i);
    end

end


function HNZZM_UILayer:GetButtons(gameObject)
    gameUIObjects.ButtonSetting 		= gameObject.transform:Find('morePanel/ButtonSetting');
	gameUIObjects.ButtonChat	 		= gameObject.transform:Find('ButtonChat');
	gameUIObjects.ButtonSound 			= gameObject.transform:Find('ButtonSound');
	gameUIObjects.ButtonInvite 			= gameObject.transform:Find('bottomButtons/ButtonInvite');
	gameUIObjects.ButtonCloseRoom 		= gameObject.transform:Find('bottomButtons/ButtonCloseRoom');
	gameUIObjects.ButtonExitRoom 		= gameObject.transform:Find('bottomButtons/ButtonExitRoom');
	gameUIObjects.ButtonNext 			= gameObject.transform:Find('ButtonNext');
	gameUIObjects.ButtonReady 			= gameObject.transform:Find('ButtonReady');
    gameUIObjects.ButtonRefresh 		= gameObject.transform:Find('ButtonRefresh');
    gameUIObjects.ButtonHu 				= gameUIObjects.operation_send:Find('Button2Hu');
	gameUIObjects.ButtonGang 			= gameUIObjects.operation_send:Find('Button3Gang');
	gameUIObjects.ButtonPeng 			= gameUIObjects.operation_send:Find('Button5Peng');
	gameUIObjects.ButtonChi 			= gameUIObjects.operation_send:Find('Button6Chi');
	gameUIObjects.ButtonGuo 			= gameUIObjects.operation_send:Find('Button1Guo');
    gameUIObjects.ButtonBu 				= gameUIObjects.operation_send:Find('Button4Bu');
    gameUIObjects.ButtonGPS				= gameObject.transform:Find("morePanel/ButtonGPS");
	gameUIObjects.ButtonMore			= gameObject.transform:Find("ButtonMore");
    gameUIObjects.ButtonRule			= gameObject.transform:Find("morePanel/ButtonRules");
    gameUIObjects.playerTingButton 		= gameObject.transform:Find("tingOperation");

	
end

function HNZZM_UILayer:GetRoomInfoUI(gameObject)
    gameUIObjects.roomRound                 = gameObject.transform:Find('DiPai/frame/round');
    gameUIObjects.roomID                    = gameObject.transform:Find('stateBar/room/ID');
    gameUIObjects.waitRoomID                = gameObject.transform:Find('setting/roominfo/waitRoomID');
    gameUIObjects.roomTime 	                = gameObject.transform:Find('stateBar/time');
    gameUIObjects.batteryLevel              = gameObject.transform:Find('stateBar/battery/level'):GetComponent('UISprite');
    gameUIObjects.network                   = gameObject.transform:Find('stateBar/network'):GetComponent('UISprite');
    gameUIObjects.pingLabel                 = gameObject.transform:Find('stateBar/ping'):GetComponent('UILabel');
    gameUIObjects.roomSetting 	            = gameObject.transform:Find('setting');
    gameUIObjects.gameTypeobj 	            = gameObject.transform:Find('type');
    gameUIObjects.line 			            = gameObject.transform:Find('line');
    gameUIObjects.operation_send            = gameObject.transform:Find('operation_send');

    gameUIObjects.curOperatPlateEffect 	    = gameObject.transform:Find('curOperatPlateEffect');
    gameUIObjects.RestTime				    = gameObject.transform:Find("RestTime");
    gameUIObjects.operation_mask		    = gameObject.transform:Find("operationMask");
    gameUIObjects.RecordTiShi			    = gameObject.transform:Find('RecordTiShi');
    gameUIObjects.TingItemPrefab 		    = gameObject.transform:Find("tingOperation/cardItem");
    gameUIObjects.panelShare                = gameObject.transform:Find('panelShare');
    gameUIObjects.waitopTip                 = gameObject.transform:Find('waitopTip');

    gameUIObjects.TrusteeShipTip            = gameObject.transform:Find('TrusteeshipTip');
    gameUIObjects.TrusteeShipPanel          = gameObject.transform:Find('TrusteeshipPanel');
    gameUIObjects.TrusteeShipCancelButton   = gameObject.transform:Find('TrusteeshipPanel/CancelTrusteeshipBtn');
    gameUIObjects.newTingOperation          = gameObject.transform:Find('newTingOperation');
    gameUIObjects.runScoreOperation         = gameObject.transform:Find('runScoreOperation');
    gameUIObjects.hunPanel                  = gameObject.transform:Find('hunPanel');
    

end

function HNZZM_UILayer:GetESWNUI(gameObject)
    gameUIObjects.dipai 			    = gameObject.transform:Find('DiPai');
    for i=1,self.HNZZM_Logic:GetMaxPlayerSize() do
        gameUIObjects.ActivePlayerESWN[i] = gameObject.transform:Find("DiPai/DeskTimerIndex"..i);
    end
end

function HNZZM_UILayer:InitUILayer(roomData)
    -- print("InitUILayer was called----->.roomData.state"..tostring(roomData.state))
    self.roomData = self.HNZZM_Logic.roomData;
    self:InitTrusteeMachine();
    -- 房间信息
    self:InitRoomInfo(roomData);
     -- 人物信息
    self:InitPlayerInfo(roomData);
    -- 手牌信息
    self:InitAllGrids(roomData);
    -- GPS
    self:InitGPSInfo(roomData);
    --东南西北
    self:InitESWNInfo(roomData);


    HNZZM_EventBind.Init(self,gameUIObjects,self.HNZZM_Logic);--绑定事件

end

function HNZZM_UILayer:InitRoomInfo(roomData)
    --获取主题颜色
	bgColor 	    = UnityEngine.PlayerPrefs.GetInt('bgColor_hnzzm', 1);
	cardColor 	    = UnityEngine.PlayerPrefs.GetInt('cardColor_hnzzm', 1);
	cardText 	    = UnityEngine.PlayerPrefs.GetInt('cardText_hnzzm', 1);
	language 	    = UnityEngine.PlayerPrefs.GetInt('language_hnzzm', 1);
	outPlateType 	= UnityEngine.PlayerPrefs.GetInt('outPlateType_hnzzm', 0);
    coroutine.start(RefreshTime,gameUIObjects.roomTime:GetComponent("UILabel"),60);
    coroutine.start(RefreshPhoneState,self.gameObject,self.HNZZM_Logic,gameUIObjects.batteryLevel,gameUIObjects.network);
    gameUIObjects.roomID:GetComponent("UILabel").text                       = roomInfo.roomNumber;
    gameUIObjects.waitRoomID:GetComponent("UILabel").text                   = roomInfo.roomNumber;
    gameUIObjects.roomSetting:Find('Label'):GetComponent('UILabel').text    = self.roomData.clubId ~= "0" and GetHNZZMRuleText(roomData.setting,false,false) or GetHNZZMRuleText(roomData.setting,false,true);
    gameUIObjects.gameTypeobj:Find("playName"):GetComponent("UILabel").text = roomData.playName;
    print("self.roomData.state-----------------"..self.roomData.state);
    if self.roomData.state == self.hnm_pb.GAMING then --已在游戏中了，那肯定时隐藏的
        self:SetInviteVisiable(false);
        self:HideWaittingUI();
    else
        if self.roomData.round > 1 then --不是第一局了，肯定也是隐藏的
            self:SetInviteVisiable(false);
        else
            --房间还没有满员，自己没有准备，有人没有准备这三个条件满足其中一个，都需要显示
            self:SetInviteVisiable(self.HNZZM_Logic:GetPlayerDataLength() ~= self.roomData.setting.size or 
            ((not self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat).ready) or (not self.HNZZM_Logic:IsAllReaded()) ));

        end
        if self.roomData.state == self.hnm_pb.READYING then 
            if self.roomData.round == 1 then 
                self:ShowWaittingUI();
            else
                self:HideWaittingUI();
            end
            
        end
    end
   
    gameUIObjects.curOperatPlateEffect.gameObject:SetActive(false);
    self:ChooseBG(bgColor);

    panelInGame.fanHuiRoomNumber = roomInfo.roomNumber;--俱乐部里面，当游戏开始的时候，用来通知玩家返回房间
    self.overNeedWait = false;

    --房间创建多久会被解散
    self:SetRoomRestTime();
end

function HNZZM_UILayer:SetRoomRestTime()
    if self.roomData.state == self.hnm_pb.READYING and self.roomData.clubId ~= "0" and self.roomData.round == 1 then
        if self.roomRestTimeCor ~= nil then 
            coroutine.stop(self.roomRestTimeCor);
        end 
        gameUIObjects.RestTime.gameObject:SetActive(true);
        gameUIObjects.RestTime:Find("Time"):GetComponent("UILabel").text = os.date("%M:%S",self.roomData.time/1000)
        self.roomRestTimeCor =  HNZZM_Tools.RefreshRoomRestTime(self.roomData.time/1000,
        function(time)
            gameUIObjects.RestTime:Find("Time"):GetComponent("UILabel").text = os.date("%M:%S",time);
        end,
        function() 
            if self.roomRestTimeCor ~= nil then 
                coroutine.stop(self.roomRestTimeCor);
            end
            gameUIObjects.RestTime.gameObject:SetActive(false);
        end
    );

    else
        gameUIObjects.RestTime.gameObject:SetActive(false);
    end
end


function HNZZM_UILayer:InitPlayerInfo(roomData)
    self:AutoRegisterPlayerView(roomData.seat,roomData.setting.size);
    self:SetPlayerPos(roomData);
    DestroyRoomData.roomData 	    = roomData;
    DestroyRoomData.playerData      = self.HNZZM_Logic:GetPlayerDatas();
    DestroyRoomData.mySeat 		    = self.HNZZM_Logic.mySeat;
    local dissolution               = self.HNZZM_Logic:GetDissolutions();
    panelInGame.myseflDissolveTimes = 0;
    if dissolution.remainMs > 0 then 
        DestroyRoomData.roomData.dissolution.remainMs = getIntPart(dissolution.remainMs/1000);
        self:SetDestoryPanelShow();
    else
        PanelManager.Instance:HideWindow('panelDestroyRoom')
    end
    
    if self.roomData.state == self.hnm_pb.GAMING then 
        self:SetActivePlayer(self.roomData);
        if self.roomData.trusteeshipRemainMs > 0 then 
            self:SetCountDown(self.roomData.trusteeshipRemainMs);
        end
    end

    --重新登录的时候，是否显示跑分
    local myData = self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat);
    if self.HNZZM_Logic:NeedShowRunScore() then 
        gameUIObjects.runScoreOperation.gameObject:SetActive(true);
        self:SetPlayerPao({score = myData.selectPao});
    else
        gameUIObjects.runScoreOperation.gameObject:SetActive(false);
    end

    --重新登录是否显示混牌
    gameUIObjects.hunPanel.gameObject:SetActive(false);
    if self.HNZZM_Logic:NeedShowHun() then 
        gameUIObjects.hunPanel.gameObject:SetActive(true);
        gameUIObjects.hunPanel:Find("hunPlate").gameObject:SetActive(false);
        self:SetHunPlates(myData.hunMahjongs);
    end

    --设置托管
    self:SetPlayerTrustesship(self.HNZZM_Logic.mySeat,self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat).trusteeship);
    --如果开启了托管，如果当前出牌玩家是自己，就要开始开始倒计时托管了
    print("self.roomData.trusteeshipRemainMs:"..self.roomData.trusteeshipRemainMs);
    print("self.roomData.setting.trusteeship:"..self.roomData.setting.trusteeship);
    self:CheckPlayerTrustesship(self.roomData.trusteeshipRemainMs);
   
end

function HNZZM_UILayer:InitAllGrids(roomData)
    --隐藏所有的grid
    for i=1,#gameUIObjects.playerViews do
        gameUIObjects.playerViews[i].hnzzm_GridTool:HideAllGrid();
    end

    if self.roomData.state == self.hnm_pb.GAMING then 
        self:RefreshAllGrid();
       
        self:SetGameTypePos();
    end

    --显示玩家的操作
    local myData = self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat);
    self:RefreshOperationSend(myData.operations,myData);
    self:OperationForbidden(myData.sealPai);

    --处理听牌
    local myData        = self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat);
    local myRealIndex   = self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(myData.seat));
    local myPlayerView  = gameUIObjects.playerViews[myRealIndex];
    -- print("myData.tingMahjongs:"..#myData.tingMahjongs);
    self:InitTingButton();

    if #myData.tingTip>0 then 
        self:SetTiPlateMark(myPlayerView.hnzzm_GridTool.gridHand,myData.mahjongs,myData.tingTip,myData);
        self:SetTiPlateMark(myPlayerView.hnzzm_GridTool.gridMo,{myData.moMahjong},myData.tingTip,myData);
        
    end
end

function HNZZM_UILayer:InitGPSInfo(roomData)
    gameUIObjects.GpsView.gameObject:SetActive(false);
end

function HNZZM_UILayer:InitESWNInfo(roomData)
    gameUIObjects.dipai.gameObject:SetActive(false);
    self:SetDipaiNum(roomData.surplus);
    self:SetRoundNum(roomData.round);
    gameUIObjects.dipai.gameObject:SetActive(HNZZM_PlayLogic.NeedShowDiPai(self.roomData,self.HNZZM_Logic));
    gameUIObjects.roomRound.gameObject:SetActive(HNZZM_PlayLogic.NeedShowDiPai(self.roomData,self.HNZZM_Logic));
end


function HNZZM_UILayer:SetPlayerPos(roomData)
    --设置座位位置
    for i=1,#gameUIObjects.playerViews do
        local playerView =  gameUIObjects.playerViews[i];
        playerView:SetPos(roomData.state  ~= self.hnm_pb.GAMING and (self.HNZZM_Logic.totalSize < roomData.setting.size or roomData.round == 1) );
        playerView:NeedHideSelf(roomData.setting.size);
    end

    --设置语音，聊天，还有听牌按钮
    gameUIObjects.ButtonSound.localPosition                     = HNZZM_Tools.IfNeedAutoLayOut() and Vector3(700,55,0) or Vector3(617,55,0);
    gameUIObjects.ButtonChat.localPosition                      = HNZZM_Tools.IfNeedAutoLayOut() and Vector3(700,-41.9,0) or Vector3(617,-55,0);
    gameUIObjects.playerTingButton.localPosition                = HNZZM_Tools.IfNeedAutoLayOut() and Vector3(709.8,-153.2,0) or Vector3(625,-178,0);
    gameUIObjects.newTingOperation.localPosition                = HNZZM_Tools.IfNeedAutoLayOut() and Vector3(-363,-177,0) or Vector3(-363,-200,0);
    gameUIObjects.playerTingButton:Find("frame").localPosition  = HNZZM_Tools.IfNeedAutoLayOut() and Vector3(-724.8,64,0) or Vector3(-642,64,0);

    
	
end

function HNZZM_UILayer:InitTingButton()
    local myData = self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat);
    
    if myData.tingMahjongs and #myData.tingMahjongs > 0 and #myData.tingTip == 0 then 
        gameUIObjects.playerTingButton.gameObject:SetActive(true);
        SetUserData(gameUIObjects.playerTingButton.gameObject,myData.tingMahjongs);
        gameUIObjects.playerTingButton:Find("frame").gameObject:SetActive(false);
        -- print("SetUserData on playerTingButton,tingMahjongs.length:"..#myData.tingMahjongs..",playerTingButton="..tostring(gameUIObjects.playerTingButton.gameObject))
        this:SetNewTingScrollView(myData.tingMahjongs);
        gameUIObjects.newTingOperation.gameObject:SetActive(true);
    else
        gameUIObjects.playerTingButton.gameObject:SetActive(false);
    end

    
end




--刷新所有grid
function HNZZM_UILayer:RefreshAllGrid( )
    -- body
    -- print("RefreshAllGrid------------->")
    
    self.HNZZM_Logic:ForeachPlayerDatas(function(playerView,_) 
        playerView.hnzzm_GridTool:SetLayOut();
    end);
    self:RefreshAllGridXi();
    self:RefreshAllGridHand();
    self:RefreshAllGridMoPai();
    self:RefreshAllGridThrow();

    self:InitTingButton();

end

--刷新手牌
function HNZZM_UILayer:RefreshAllGridHand()
    -- print("RefreshAllGridHand----------->")
    self.HNZZM_Logic:ForeachPlayerDatas(function(playerView,playerData) 
        -- print("playerName:"..playerData.name..",seat:"..playerData.seat..",mahjongs.length:"..(#playerData.mahjongs));
        playerView.hnzzm_GridTool.gridHand.gameObject:SetActive(true);
        playerView.hnzzm_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);

    end);
end

--刷新喜牌
function HNZZM_UILayer:RefreshAllGridXi()
    -- print("RefreshAllGridXi----------->")
    self.HNZZM_Logic:ForeachPlayerDatas(function(playerView,playerData) 
        playerView.hnzzm_GridTool.gridXi.gameObject:SetActive(true);
        playerView.hnzzm_GridTool:RefreshGridXi(playerData.operationCards);
    end);
end

--刷新带出去的牌
function HNZZM_UILayer:RefreshAllGridThrow()
    -- print("RefreshAllGridThrow----------->")
    
    self.HNZZM_Logic:ForeachPlayerDatas(function(playerView,playerData) 
        playerView.hnzzm_GridTool.gridThrow.gameObject:SetActive(true);
        playerView.hnzzm_GridTool:RefreshGridThrow(playerData.paiHe);
    end);
end

--刷新摸牌
function HNZZM_UILayer:RefreshAllGridMoPai()
    -- print("RefreshAllGridMoPai----------->")
    self.HNZZM_Logic:ForeachPlayerDatas(function(_,playerData) 
        local playerView = gameUIObjects.playerViews[self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(playerData.seat))];
        playerView.hnzzm_GridTool.gridMo.gameObject:SetActive(playerData.moMahjong ~= -1);
        playerView.hnzzm_GridTool:RefreshMoPai(playerData.moMahjong);
    end);
end

--盖住所有出的牌
function HNZZM_UILayer:CoverAllGridThrow()
    -- print("CoverAllGridThrow was called-------------->");
    self.HNZZM_Logic:ForeachPlayerDatas(function(_,playerData) 
        local playerView = gameUIObjects.playerViews[self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(playerData.seat))];
        playerView.hnzzm_GridTool:CoverGridThrow();
    end);
end

--取消盖住所有出的牌
function HNZZM_UILayer:UnCoverAllGridThrow()
    -- print("UnCoverAllGridThrow was called-------------->");
    self:RefreshAllGridThrow();
end

function HNZZM_UILayer:AutoRegisterPlayerView(mySeat, size)
    for i = 1, self.HNZZM_Logic:GetMaxPlayerSize() do
        gameUIObjects.playerViews[i]:OpenView();
        self.HNZZM_Logic:RegisterPlayerView(gameUIObjects.playerViews[i]);
    end
    self.HNZZM_Logic:ResetAllPlayerView();
end

function HNZZM_UILayer:SetRoundStart( data )
    -- body
    print("setin -------------------->SetRoundStart");
    self:RefreshAllGrid();
    self:RefreshPlayer();
    self:SetRoomInfo(self.roomData);
    self:SetActivePlayer(self.roomData);
    self:SetPlayerPos(self.roomData);
    self:SetInviteVisiable(false);
    self:HideWaittingUI();
    
    
    
    local myData = self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat);
    
    print("myData.hunMahjongs.length="..#myData.hunMahjongs);
   
    self:HunPlatesAnimation(myData.hunMahjongs);
    -- print(" myData.trusteeship-------------------"..tostring( myData.trusteeship));
    if myData.trusteeship then --如果是托管状态，那么在游戏开始时就应该隐藏小结算
        coroutine.start(function()
            coroutine.wait(0.8);
             PanelManager.Instance:HideWindow("panelStageClear_hnzzm");
        end);
    end

    self:SetRoomRestTime();
    
end

function HNZZM_UILayer:SetRoomInfo(roomData)
    self:SetDipaiNum(roomData.surplus);
    self:SetRoundNum(roomData.round);
    gameUIObjects.runScoreOperation.gameObject:SetActive(self.HNZZM_Logic:NeedShowRunScore());

end
function HNZZM_UILayer:SetGameRoundEnd( RoundEndData )
    -- body
    RoundEndData.uiLayer = self;
    PanelManager.Instance:ShowWindow("panelStageClear_hnzzm",RoundEndData)
    PanelManager.Instance:HideWindow("panelChat");
    PanelManager.Instance:HideWindow("panelGameSetting_hnzzm");
    self.HNZZM_Logic:ResetGameState();
    self:SetDipaiNum(self.roomData.surplus);
    self:SetRoundNum(self.roomData.round);
    self:ClearUI();
    
    
end

--清除一些UI上的状态
function HNZZM_UILayer:ClearUI( ... )
    -- body
    --1.时钟
    gameUIObjects.dipai:Find("timer"):GetComponent("UILabel").text = 0;
    HNZZM_Tools.StopCount(gameUIObjects.dipai:Find("timer"));
    --2.操作列表
    gameUIObjects.operation_send.gameObject:SetActive(false);
    --3.提牌标志
    local myPlayerView = gameUIObjects.playerViews[self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(self.HNZZM_Logic.mySeat))];
    self:HideTiMark(myPlayerView.hnzzm_GridTool.gridHand);
    self:HideTiMark(myPlayerView.hnzzm_GridTool.gridMo);
    --隐藏玩家的听牌按钮
    gameUIObjects.playerTingButton.gameObject:SetActive(false);
    gameUIObjects.newTingOperation.gameObject:SetActive(false);
    --5.聊天界面.
    PanelManager.Instance:HideWindow("panelChat");
    PanelManager.Instance:HideWindow("panelGameSetting_hnzzm");
    --6.隐藏房间解散倒计时
    gameUIObjects.RestTime.gameObject:SetActive(false);
    if self.roomRestTimeCor then 
        coroutine.stop(self.roomRestTimeCor);
        self.roomRestTimeCor = nil;
    end
    --7.如果有打开的界面，则要关闭界面（如果A玩家申请解散，B玩家切到后台，等申请时间到了后，B回到游戏，申请解散界面未消失）
    PanelManager.Instance:HideWindow("panelDestroyRoom")
    --8.跑分
    self.HNZZM_Logic:ForeachPlayerDatas(function(_,playerData) 
        local realIndex = self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(playerData.seat));
        local playerView = gameUIObjects.playerViews[realIndex];
        playerData.paoScore = -1;
        playerView:CleanView();
    end);
end

--刷新所有UI
function HNZZM_UILayer:RefreshAllUI()

end

--玩家再游戏期间申请解散
function HNZZM_UILayer:SetDissolve(dissolveData)
    DestroyRoomData.playerData 	= self.HNZZM_Logic:GetPlayerDatas();
	if dissolveData.decision == self.hnm_pb.APPLY then--申请解散
		DestroyRoomData.roomData.dissolution.applicant = dissolveData.seat;
		while #DestroyRoomData.roomData.dissolution.acceptors > 0 do
			table.remove(DestroyRoomData.roomData.dissolution.acceptors, #DestroyRoomData.roomData.dissolution.acceptors)
		end
		if dissolveData.remainMs and dissolveData.remainMs > 0 then
			DestroyRoomData.roomData.dissolution.remainMs = dissolveData.remainMs/1000;
		else
			DestroyRoomData.roomData.dissolution.remainMs = 300;
		end
		self:SetDestoryPanelShow();
	elseif dissolveData.decision == self.hnm_pb.AGREE then
		table.insert(DestroyRoomData.roomData.dissolution.acceptors, dissolveData.seat);
		panelDestroyRoom.Refresh();
	elseif dissolveData.decision == self.hnm_pb.AGAINST then
		panelDestroyRoom.Refresh(dissolveData.seat)
	else
		Debugger.LogError('decision unkown type:'..dissolveData.decision, nil);
	end
end

function HNZZM_UILayer:SetDestoryPanelShow()
    PanelManager.Instance:HideWindow('panelDestroyRoom');
    PanelManager.Instance:ShowWindow('panelDestroyRoom');
    PanelManager.Instance:HideWindow("panelChat");
    PanelManager.Instance:HideWindow("panelGameSetting_hnzzm");
end

function HNZZM_UILayer:RefreshGpsView()
    if self.roomData.state ~= hnm_pb.READYING then 
        gameUIObjects.GpsView.gameObject:SetActive(false);
        return ;
    end
    gameUIObjects.GpsView.gameObject:SetActive(self.roomData.state == hnm_pb.READYING and self.roomData.round == 1);
   
    if self.gpsTool == nil then 
        self.gpsTool = GPSTool.New(self.HNZZM_Logic,self.roomData,gameUIObjects.distances,gameUIObjects.gpsPlayers);
    end
    self.gpsTool:Refresh(self.HNZZM_Logic,self.roomData);
end

function HNZZM_UILayer:RefreshPlayer()
    self.HNZZM_Logic:ForeachPlayerDatas(function(_,playerData)
        local playerView = gameUIObjects.playerViews[self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(playerData.seat))]; 
        -- print("self.roomData.state:"..self.roomData.state);
        playerView:SetReady(playerData.ready and self.roomData.state == self.hnm_pb.WAITING);
        playerView:ResetView(playerData);
    end);
    --如果自己准备好了，就隐藏准备按钮
    gameUIObjects.ButtonReady.gameObject:SetActive(not self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat).ready);
     --设置托管
    self:SetPlayerTrustesship(self.HNZZM_Logic.mySeat,self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat).trusteeship);
    self:NotifyGameStart();
    if self.HNZZM_Logic:IsAllReaded() then 
        self:SetInviteVisiable(false);
    end
     --如果所有人都准备了，那么要隐藏解散房间倒计时
    if self.roomData.clubId ~= 0 and self.HNZZM_Logic:IsAllReaded() then 
        if self.roomRestTimeCor ~= nil then 
            coroutine.stop(self.roomRestTimeCor);
            self.roomRestTimeCor = nil;
        end

        gameUIObjects.RestTime.gameObject:SetActive(false);
    end
end

--有玩家加入
function HNZZM_UILayer:OnPlayerJoin(data)
    self:NotifyGameStart();
end



function HNZZM_UILayer:SetActivePlayer(roomData)
    self:ShowWaitOpreatEffect(roomData.activeSeat,roomData.state == self.hnm_pb.GAMING);
    for i=1,#gameUIObjects.playerViews do
        gameUIObjects.playerViews[i]:SetActiveFlag(false);
    end
    local playerView = gameUIObjects.playerViews[self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(roomData.activeSeat))];
    playerView:SetActiveFlag(true and roomData.state == self.hnm_pb.GAMING);
end

function HNZZM_UILayer:GetOverTrusteeship()
    local Trusteeships={}
    for i = 0, self.roomData.setting.size-1 do
        local playerView = gameUIObjects.playerViews[self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(i))];
        Trusteeships[i] = playerView.trusteeshipFlag.gameObject.activeSelf;
    end
    return Trusteeships;
end

function HNZZM_UILayer:ChangePaiSize(hnzzmPaiSize)

end


function HNZZM_UILayer:SetGameRoundOver(RoundAllData)

    local overData = {};
    overData.RoundAllData   = RoundAllData;
    overData.roomInfo       = roomInfo;
    -- print("RoundAllData.data.complete:"..tostring(RoundAllData.data.complete)..",self.HNZZM_Logic.hasStageClear:"..tostring(self.HNZZM_Logic.hasStageClear));
    if not RoundAllData.data.complete and not self.HNZZM_Logic.hasStageClear then 
        PanelManager.Instance:ShowWindow("panelStageClearAll_hnzzm",overData);
        PanelManager.Instance:HideWindow("panelChat");
        PanelManager.Instance:HideWindow("panelGameSetting_hnzzm");
    end
    self.overNeedWait = true;
end

function HNZZM_UILayer:SetGameDestroy(roomData)
    -- 清理UI
    self:ClearUI();
    panelInGame.fanHuiRoomNumber = nil;
    --隐藏打骰子
    if panelStageClear_hnzzm then 
        panelStageClear_hnzzm.setButtonsStatus(true);
    end
    -- 返回大厅或者俱乐部
    panelInGame.HideCoroutine = StartCoroutine(function()
        if self.overNeedWait then 
              WaitForSeconds(1.0);
        end
        if roomData.clubId ~= '0' then
            PanelManager.Instance:ShowWindow('panelClub', {name = 'panelInGame_hnzzm'});
        else
            PanelManager.Instance:ShowWindow('panelLobby',self.gameObject.name);
        end
    end);
    StopTrusteeshipVerification(self.trusteeShipCoroutine);
    self.TrusteeshipFsmMachine:Switch(TrusteeShipStates.TrusteeShipEnd);--取消托管状态
    
end



function HNZZM_UILayer.Update(obj)
    -- print("Update-------------------->");
    if this.IsMoPaiDrag then 
        this.DraggingMoPai(this.draggingObject);
    end

end

function HNZZM_UILayer.OnDragStartPlate(obj)
    -- print("OnDragStartPlate------------------->"..tostring(obj));
    dragCardFrameDepth  = obj:GetComponent("UISprite").depth;
    dragCardDepth       = obj.transform:Find("card"):GetComponent("UISprite").depth;
    dragmarkFrameDepth  = obj.transform:Find("mark"):GetComponent("UISprite").depth;
    dragmarkDepth       = obj.transform:Find("mark/marklabel"):GetComponent("UILabel").depth;
    this.StartDragMoPai(obj);
    local tingTip = obj.transform:Find("tingTip");
    if tingTip then 
        tingTipDepth = tingTip:GetComponent("UISprite").depth ;
		tingTip:GetComponent("UISprite").depth = dragDepthOffset + 2;
    end

    obj:GetComponent("UISprite").depth = dragDepthOffset;
    obj.transform:Find("card"):GetComponent("UISprite").depth = dragDepthOffset + 1;
    obj.transform:Find("mark"):GetComponent("UISprite").depth = dragDepthOffset + 2;
    obj.transform:Find("mark/marklabel"):GetComponent("UILabel").depth = dragDepthOffset + 3;

    if tingTip then 
        local tingMahjongs = GetUserData(tingTip.gameObject);
        if tingMahjongs then 
            gameUIObjects.playerTingButton.gameObject:SetActive(true);
            local bgFrame = gameUIObjects.playerTingButton:Find("frame");
            bgFrame.gameObject:SetActive(true);
            gameUIObjects.newTingOperation.gameObject:SetActive(false);
            this:SetTingScrollView(tingMahjongs);
            this:SetNewTingScrollView(tingMahjongs);
            this.needDisappearDragEnd = true;
        end
    end
    
end 

function HNZZM_UILayer.OnDragEndtPlate(obj)
    -- print("OnDragEndtPlate------------------->"..tostring(obj));
    obj:GetComponent("UISprite").depth = dragCardFrameDepth;
    obj.transform:Find("card"):GetComponent("UISprite").depth = dragCardDepth;
    obj.transform:Find("mark"):GetComponent("UISprite").depth = dragmarkFrameDepth;
    obj.transform:Find("mark/marklabel"):GetComponent("UILabel").depth = dragmarkDepth;
    local tingTip = obj.transform:Find("tingTip");
    if tingTip then 
        obj.transform:Find("tingTip"):GetComponent("UISprite").depth = tingTipDepth;
    end
    local myData     = this.HNZZM_Logic:GetPlayerDataBySeat(this.HNZZM_Logic.mySeat);
    local playerView = gameUIObjects.playerViews[this.HNZZM_Logic:GetCorrectUIIndex(this.HNZZM_Logic:GetPlayerViewIndexBySeat(myData.seat))];
    --能出牌的条件，1.轮到自己出牌，2.没有封牌，3.在线状态,4.牌拖到了出牌位置
    if this.HNZZM_Logic:CanChuPai() and this.HNZZM_Logic.connect.IsConnect and (not this.HNZZM_Logic:GetPlayerDataBySeat(this.HNZZM_Logic.mySeat).sealPai ) then 
        
        if UICamera.currentTouch.dragged.transform.position.y >  gameUIObjects.line.position.y then 
            local plate = GetUserData(UICamera.currentTouch.dragged);
            --如果拖拽的时手牌，需要从手牌中移除麻将，如果拖拽的时摸的牌，则不用
            if obj ~= playerView.hnzzm_GridTool.gridMo:GetChild(0).gameObject then 
                
                tableRemovePlate(myData.mahjongs,plate);
                if myData.moMahjong and myData.moMahjong ~= -1 then 
                    table.insert( myData.mahjongs, myData.moMahjong );
                    -- print("OnDragEndtPlate want insert mopai to hand---------------> ");
                    myData.moMahjong = -1;
                end
            end
            print("出的牌是:"..plate);
            this:SendChuPaiMsg(plate,UICamera.currentTouch.dragged);
            obj:SetActive(false);
            this.HNZZM_Logic.needChuPai = false;
        else--没有拖拽到出牌的位置
            obj:SetActive(true);
            if tingTip then 
                this:SetTiPlateMark(playerView.hnzzm_GridTool.gridHand,myData.mahjongs,myData.tingTip,myData);
            end

        end
        this.lastSelectmahjong = nil;
    end
    this.DragEndMoPai(obj);

    playerView.hnzzm_GridTool:RefreshGridXi(myData.operationCards);
    playerView.hnzzm_GridTool:RefreshGridHand(myData.mahjongs,#myData.mahjongs);

    if this.needDisappearDragEnd then 
        gameUIObjects.playerTingButton.gameObject:SetActive(false);
		local bgFrame = gameUIObjects.playerTingButton:Find("frame");
		bgFrame.gameObject:SetActive(false);
		this.needDisappearDragEnd = false;
    end

end 



function HNZZM_UILayer.OnDoubleClickPlate(obj)
   
    -- print("OnDoubleClickPlate------------------->"..tostring(obj));
    local myData     = this.HNZZM_Logic:GetPlayerDataBySeat(this.HNZZM_Logic.mySeat);
    local playerView = gameUIObjects.playerViews[this.HNZZM_Logic:GetCorrectUIIndex(this.HNZZM_Logic:GetPlayerViewIndexBySeat(myData.seat))];
    if this.HNZZM_Logic:CanChuPai() and this.HNZZM_Logic.connect.IsConnect and (not this.HNZZM_Logic:GetPlayerDataBySeat(this.HNZZM_Logic.mySeat).sealPai) then 
      
        local plate = GetUserData(obj);
        if obj ~= playerView.hnzzm_GridTool.gridMo:GetChild(0).gameObject then 
            tableRemovePlate(myData.mahjongs,plate);
            if myData.moMahjong and myData.moMahjong ~= -1 then 
                table.insert( myData.mahjongs, myData.moMahjong );
                myData.moMahjong = -1;
            end
            print("出的牌是:"..plate);
        end
        this:SendChuPaiMsg(plate,obj);
        obj:SetActive(false);
        this.HNZZM_Logic.needChuPai = false;
    end
    StartCoroutine(function()
        WaitForSeconds(0.2);
        playerView.hnzzm_GridTool:RefreshGridHand(myData.mahjongs,#myData.mahjongs);
    end);
end

function HNZZM_UILayer.OnClickMahjong(obj)
    -- print("OnClickMahjong------------------->"..tostring(obj));
    print("OnClickMahjong,outPlateType="..outPlateType);
    if outPlateType == 1 then 
        --先做一个麻将抬起的动画，再出出去
        StartCoroutine(function()
            local pos = obj.transform.localPosition;
            obj.transform.localPosition = Vector3.New(pos.x,pos.y+20,pos.z);
            WaitForSeconds(0.03);
            this.OnDoubleClickPlate(obj);
        end)
        return;
    end
    this.posOffset = 30;
    local needTiTip = false;--是否需要弹出
	local plate = GetUserData(obj);
	if this.lastSelectmahjong == nil then--第一次点击或者上一次点击的牌打出去了
		local pos = obj.transform.localPosition;
		if pos.y > 10 then
			pos.y = pos.y-this.posOffset;
		else
			pos.y = pos.y+this.posOffset;
		end

		obj.transform.localPosition = pos;
		needTiTip = true;
	else
		local pos = this.lastSelectmahjong.transform.localPosition;
		if obj == this.lastSelectmahjong then--若上次跟当前点的是同一个对象
			if pos.y > 10 then
				this.lastSelectmahjong.transform.localPosition = Vector3.New(pos.x,pos.y-this.posOffset,0);
				needTiTip = false;
			else
				this.lastSelectmahjong.transform.localPosition = Vector3.New(pos.x,pos.y+this.posOffset,0);
				needTiTip = true;
			end
		else
			if pos.y> 10 then
				this.lastSelectmahjong.transform.localPosition = Vector3.New(pos.x,pos.y-this.posOffset,0);
			end
			local currentPos = obj.transform.localPosition;
			obj.transform.localPosition = Vector3.New(currentPos.x,currentPos.y+this.posOffset,0);
			needTiTip = true;
		end
    end
    -- print("this.activeSeat:"..this.roomData.activeSeat);
    -- print("this.HNZZM_Logic.mySeat:"..this.HNZZM_Logic.mySeat);
	if this.lastSelectmahjong then--选择的是同一个，相当于选中，再点击同一个取消选择
		local lastPlate = GetUserData(this.lastSelectmahjong);
        HNZZM_PlayLogic.CheckPlateState(lastPlate,false,this,this.HNZZM_Logic);
        if this.roomData.activeSeat == this.HNZZM_Logic.mySeat then 
             gameUIObjects.playerTingButton.gameObject:SetActive(false);
        end
        local bgFrame = gameUIObjects.playerTingButton:Find("frame");
		bgFrame.gameObject:SetActive(false);
        this.needDisappearDragEnd = false;
	end
	HNZZM_PlayLogic.CheckPlateState(plate,needTiTip,this,this.HNZZM_Logic);
    if needTiTip then
		--显示提牌
		local tingTip = obj.transform:Find("tingTip");
		if tingTip then
			--print("process ti plate------->")

			--拿到听牌集
			local tingMahjongs = GetUserData(tingTip.gameObject);
			if tingMahjongs then
				--print("get user's tingMahjongs--->");
				gameUIObjects.playerTingButton.gameObject:SetActive(true);
				local bgFrame = gameUIObjects.playerTingButton:Find("frame");
				bgFrame.gameObject:SetActive(true);
                this:SetTingScrollView(tingMahjongs);
                this:SetNewTingScrollView(tingMahjongs);
                this.needDisappearDragEnd = true;
                gameUIObjects.newTingOperation.gameObject:SetActive(false);
			end
		end
    else
        if this.roomData.activeSeat == this.HNZZM_Logic.mySeat then 
            gameUIObjects.playerTingButton.gameObject:SetActive(false);
        end
		local bgFrame = gameUIObjects.playerTingButton:Find("frame");
		bgFrame.gameObject:SetActive(false);
		this.needDisappearDragEnd = false;

	end

	this.lastSelectmahjong = obj;

end

function HNZZM_UILayer.OnDragging(obj)
    -- print("OnDragging------------------->"..tostring(obj));

end

function HNZZM_UILayer.OnPressMahJong(obj,state)
    print("OnPressMahJong was called----------------->state="..tostring(state));
    if outPlateType == 1 then 
        if state then 
            local pos = obj.transform.localPosition;
            obj.transform.localPosition = Vector3.New(pos.x,20,pos.z);
            --显示提牌
		    local tingTip = obj.transform:Find("tingTip");
		    if tingTip then
		    	--print("process ti plate------->")

		    	--拿到听牌集
		    	local tingMahjongs = GetUserData(tingTip.gameObject);
		    	if tingMahjongs then
		    		--print("get user's tingMahjongs--->");
		    		gameUIObjects.playerTingButton.gameObject:SetActive(true);
		    		local bgFrame = gameUIObjects.playerTingButton:Find("frame");
		    		bgFrame.gameObject:SetActive(true);
                    this:SetTingScrollView(tingMahjongs);
                    this:SetNewTingScrollView(tingMahjongs);
                    this.needDisappearDragEnd = true;
                    gameUIObjects.newTingOperation.gameObject:SetActive(false);
		    	end
		    end
        else
            local pos = obj.transform.localPosition;
            obj.transform.localPosition = Vector3.New(pos.x,0,pos.z);
             --显示提牌
		    local tingTip = obj.transform:Find("tingTip");
		    if tingTip then
		    	--print("process ti plate------->")

		    	--拿到听牌集
		    	local tingMahjongs = GetUserData(tingTip.gameObject);
		    	if tingMahjongs then
		    		--print("get user's tingMahjongs--->");
		    		gameUIObjects.playerTingButton.gameObject:SetActive(false);
		    		local bgFrame = gameUIObjects.playerTingButton:Find("frame");
		    		bgFrame.gameObject:SetActive(false);
                    this:SetTingScrollView(tingMahjongs);
                    this:SetNewTingScrollView(tingMahjongs);
                    this.needDisappearDragEnd = false;
                    gameUIObjects.newTingOperation.gameObject:SetActive(false);
		    	end
		    end
        end
        
    end
end


--填充听牌提示的内容
function HNZZM_UILayer:SetTingScrollView(tingMahjongs)
	if not tingMahjongs then return end;
	local bgFrame = gameUIObjects.playerTingButton:Find("frame");
	--print("tingMahjongs.length:",#tingMahjongs);
	local tingScrollView = gameUIObjects.playerTingButton:Find("frame/TingScrollView");
	tingScrollView.gameObject:SetActive(true);
	local tingGrid = gameUIObjects.playerTingButton:Find("frame/TingScrollView/Grid");
	--先隐藏
	for i = 0, tingGrid.childCount-1 do
		tingGrid:GetChild(i).gameObject:SetActive(false);
	end

	--print("tingGrid.childCount:"..tingGrid.childCount);
	--计算宽度

	local realWidth = #tingMahjongs * tingGrid:GetComponent("UIGrid").cellWidth;
	local maxWidth = CONST.TingFrameWidth.x;
	--print("realWidth",realWidth);
	--print("maxWidth",maxWidth);
	if maxWidth < realWidth then
		tingScrollView:GetComponent("UIPanel").baseClipRegion = Vector4.New(0,0,maxWidth,CONST.TingFrameWidth.y);
		bgFrame:GetComponent("UISprite").width = CONST.TingFrameWidth.x + 80;
	else
		tingScrollView:GetComponent("UIPanel").baseClipRegion = Vector4.New(0,0,realWidth+10,CONST.TingFrameWidth.y);
		bgFrame:GetComponent("UISprite").width = realWidth + 100;
    end
    local hunPlates = this:GetHunPlates();
	for firdex = 1, #tingMahjongs do
		if firdex > tingGrid.childCount then
			local cardItem = NGUITools.AddChild(tingGrid.gameObject,gameUIObjects.TingItemPrefab.gameObject);
			--print("add child obj!");
			cardItem:SetActive(true);
		end

		local obj = tingGrid:GetChild(firdex -1);
		obj.gameObject:SetActive(true);
		--print("obj:"..tostring(obj));
		SetUserData(obj.gameObject,tingMahjongs[firdex]);
		obj:GetComponent("UISprite").spriteName = self:getColorCardName(CONST.cardPrefabHandStandBg[1],cardColor);
		obj:Find("card"):GetComponent("UISprite").spriteName = self:GetCardTextName(tingMahjongs[firdex].mahjong,cardText);
		UIEventListener.Get(obj.gameObject).onClick = HNZZM_EventBind.OnClickButtonTingItem;

		--统计张数
		obj:Find("num"):GetComponent("UILabel").text =  HNZZM_PlayLogic.GetTingPaiCount(tingMahjongs[firdex].mahjong,self.HNZZM_Logic,self);
		-- obj:Find("fan"):GetComponent("UILabel").text  = tingMahjongs[firdex].fan .. "番";
		obj:Find("fan"):GetComponent("UILabel").text  = "";

        --检查混牌
        local cardItem = obj
        local cardMark = cardItem.transform:Find("mark");
        cardMark.gameObject:SetActive(false);
        for j=1,#hunPlates do
            if tingMahjongs[firdex].mahjong == hunPlates[j] then
                cardMark.gameObject:SetActive(this.roomData.setting.takeHun);
                cardMark:Find("marklabel"):GetComponent("UILabel").text = "混";
                break
            end
        end
	end

	tingScrollView:GetComponent("UIScrollView"):ResetPosition();
	tingGrid:GetComponent("UIGrid"):Reposition();

end


function HNZZM_UILayer:SetNewTingScrollView(tingMahjongs)
    if not tingMahjongs then return end;
    local bg        = gameUIObjects.newTingOperation:Find("bg");
    local tingGrid  = gameUIObjects.newTingOperation:Find("Grid");
    --先隐藏
    for i=0,tingGrid.childCount-1 do
        tingGrid:GetChild(i).gameObject:SetActive(false);
    end

    local realWidth = #tingMahjongs * tingGrid:GetComponent("UIGrid").cellWidth;
    local itemPrefab = gameUIObjects.newTingOperation:Find("cardItem");
    if #tingMahjongs >= 21 then 
        bg:GetComponent("UISprite").width = 1482;
    else
        bg:GetComponent("UISprite").width = realWidth + 110;
    end
    local hunPlates = this:GetHunPlates();
    for i=1,#tingMahjongs do
        local cardItem = nil;
        if i > tingGrid.childCount then 
            cardItem = NGUITools.AddChild(tingGrid.gameObject,itemPrefab.gameObject);
        else
            cardItem = tingGrid:GetChild(i-1).gameObject;
        end
        cardItem:SetActive(true);
        SetUserData(cardItem.gameObject,tingMahjongs[i]);
        local cardBg = cardItem.transform:GetComponent("UISprite");
        local cardPlate = cardItem.transform:Find("card"):GetComponent("UISprite");
        cardBg.spriteName = self:getColorCardName(CONST.cardPrefabHandStandBg[1],cardColor);
        cardPlate.spriteName = self:GetCardTextName(tingMahjongs[i].mahjong,cardText);

        --检查混牌
        local cardMark = cardItem.transform:Find("mark");
        cardMark.gameObject:SetActive(false);
        for j=1,#hunPlates do
            if tingMahjongs[i].mahjong == hunPlates[j] then
                cardMark.gameObject:SetActive(this.roomData.setting.takeHun);
                cardMark:Find("marklabel"):GetComponent("UILabel").text = "混";
                break
            end
        end
    end

    tingGrid:GetComponent('UIPanel').clipOffset=Vector2(0,0)
	tingGrid.localPosition=Vector3(-56,0,0)
    tingGrid:GetComponent("UIGrid"):Reposition();
	tingGrid:GetComponent('UIScrollView'):ResetPosition()

end

function HNZZM_UILayer.StartDragMoPai(obj)
    this.originDragPos  = obj.transform.localPosition;
    this.IsMoPaiDrag    = true;
    this.draggingObject = obj;
end

function HNZZM_UILayer.DragEndMoPai(obj)
    this.IsMoPaiDrag = false;
    obj.transform.localPosition = this.originDragPos;
    this.draggingObject = nil;
end

function HNZZM_UILayer.DraggingMoPai(obj)
    obj.transform.localPosition = this.MousePosition();
end

function HNZZM_UILayer.MousePosition()
    local playerView = gameUIObjects.playerViews[this.HNZZM_Logic:GetCorrectUIIndex(this.HNZZM_Logic:GetPlayerViewIndexBySeat(this.HNZZM_Logic.mySeat))];
    local mousePosition = UnityEngine.Input.mousePosition;
	local wroldPosition = UICamera.mainCamera:ScreenToWorldPoint(mousePosition);
    local grid = nil;
	if this.draggingObject == playerView.hnzzm_GridTool.gridMo:GetChild(0).gameObject then--是摸牌那个位置的游戏对象
        grid = playerView.hnzzm_GridTool.gridMo;
	else--是手牌中的某个对象
        grid = playerView.hnzzm_GridTool.gridHand;
    end
	local nguiPosition = grid:InverseTransformPoint(wroldPosition);
	return nguiPosition;
end



function HNZZM_UILayer:SendChuPaiMsg(plate,dragObj)
    local msg       = Message.New();
	msg.type        = self.hnm_pb.CHUPAI;
	local body      = self.hnm_pb.POperation();
	body.mahjong    = plate;
	msg.body        = body:SerializeToString()
	SendGameMessage(msg, nil)
    --出牌之后隐藏提牌标识
    local playerView = gameUIObjects.playerViews[self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(self.HNZZM_Logic.mySeat))];
    -- print("playerView.hnzzm_GridTool.gridHand:"..tostring(playerView.hnzzm_GridTool.gridHand));
    -- print("playerView.hnzzm_GridTool.gridMo:"..tostring(playerView.hnzzm_GridTool.gridMo));
	self:HideTiMark(playerView.hnzzm_GridTool.gridHand);
    self:HideTiMark(playerView.hnzzm_GridTool.gridMo);
    self.TrusteeshipFsmMachine:Switch(TrusteeShipStates.TrusteeShipEnd);--取消托管状态
end

--玩家摸牌
function HNZZM_UILayer:SetPlayerMoPai(moData)
    -- print("SetPlayerMoPai was called---------------------------------->moData.sealPai:"..tostring(moData.sealPai));
    --先隐藏所有的摸牌的grid
    for i=1,#gameUIObjects.playerViews do
        gameUIObjects.playerViews[i].hnzzm_GridTool:SetGridMoVisible(false);
    end
    local playerView = gameUIObjects.playerViews[self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(moData.seat))];
    local playerData = self.HNZZM_Logic:GetPlayerDataBySeat(moData.seat);
    --显示当前玩家的摸牌的grid
    playerView.hnzzm_GridTool:SetGridMoVisible(true);
    self:SetDipaiNum(self.roomData.surplus);
    playerView.hnzzm_GridTool:RefreshMoPai(playerData.moMahjong);
    playerView.hnzzm_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
    if moData.seat == self.HNZZM_Logic.mySeat then 
        gameUIObjects.playerTingButton.gameObject:SetActive(false);
        gameUIObjects.playerTingButton:Find("frame").gameObject:SetActive(false);
        gameUIObjects.newTingOperation.gameObject:SetActive(false);
        local myData = self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat);
        self:OperationForbidden(moData.sealPai);
        self:SetTiPlateMark(playerView.hnzzm_GridTool.gridHand,myData.mahjongs,myData.tingTip,myData);
        self:SetTiPlateMark(playerView.hnzzm_GridTool.gridMo,{moData.mahjong},myData.tingTip,myData);
        self:SetWaitOpTip(myData.waitOperate,"请等待其他玩家操作");
        self:RefreshOperationSend(playerData.operations,playerData);
      
    else
        local myData = self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat);
        self:RefreshOperationSend({},myData);
    end

    self:SetActivePlayer(self.roomData);
    self:CheckPlayerTrustesship(self.roomData.setting.trusteeship);
end

--玩家出牌
function HNZZM_UILayer:SetPlayerChuPai(chuData)
    -- print("player.seat"..chuData.seat.." chu pai,plate="..chuData.mahjong.."chuData.sealPai="..tostring(chuData.sealPai));
    local playerView    = gameUIObjects.playerViews[self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(chuData.seat))];
    local playerData    = self.HNZZM_Logic:GetPlayerDataBySeat(chuData.seat);
    local myData        = self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat);
    playerView.hnzzm_GridTool:RefreshGridThrow(playerData.paiHe);
    playerView.hnzzm_GridTool:SetGridMoVisible(false);
    -- print("seat:"..playerData.seat.."chupai.operations.length:"..#playerData.operations..",myData.tingMahjongs.length:"..#myData.tingMahjongs);
    self:SetPlayerChuPaiShow(chuData.seat,chuData.mahjong);
    self:SetLastPlayerChuPaiEffect(chuData.seat);
    SetUserData(gameUIObjects.playerTingButton.gameObject,myData.tingMahjongs);
    gameUIObjects.playerTingButton.gameObject:SetActive(#myData.tingMahjongs > 0);
    gameUIObjects.newTingOperation.gameObject:SetActive(#myData.tingMahjongs > 0);
    gameUIObjects.playerTingButton:Find("frame").gameObject:SetActive(false);
    if #myData.tingMahjongs > 0 then 
        self:SetNewTingScrollView(myData.tingMahjongs);
    end
    self:OperationForbidden(myData.sealPai);
    self:SetPlateUIColor(playerView.hnzzm_GridTool.gridHand,{},false);
    if chuData.seat == self.HNZZM_Logic.mySeat then 
        self:HideTiMark(playerView.hnzzm_GridTool.gridHand);
        self:HideTiMark(playerView.hnzzm_GridTool.gridMo);
        playerView.hnzzm_GridTool:SetGridMoVisible(false);
    end
    self:RefreshOperationSend(myData.operations,myData);
    playerView.hnzzm_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
    if self.gameObject.activeSelf then 
        local audioString = self:GetAudioPrefix()..(playerData.sex==1 and 'man' or 'woman')..math.floor(chuData.mahjong / 9 + 1)..(chuData.mahjong % 9 + 1);
        print("audioString:"..audioString);
        AudioManager.Instance:PlayAudio(audioString);
    end
    if chuData.seat ~= self.HNZZM_Logic.mySeat then --要判断别人出的牌，自己是否能操作，如果自己有操作却没有操作，也要进入托管
        self:CheckPlayerTrustesship(self.roomData.setting.trusteeship);
    end
    if chuData.seat == self.HNZZM_Logic.mySeat then
        self:SetCountDown();
    end
end

--玩家吃牌
function HNZZM_UILayer:SetPlayerChiPai(chiData)
    --1.显示特效
    local realIndex     = self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(chiData.seat));
    local outRealIndex  = self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(chiData.outSeat));
    local playerView    = gameUIObjects.playerViews[realIndex];
    local playerData    = self.HNZZM_Logic:GetPlayerDataBySeat(chiData.seat);
    local outPlayerData = self.HNZZM_Logic:GetPlayerDataBySeat(chiData.outSeat);
    local outPlayerView = gameUIObjects.playerViews[outRealIndex];
    effManger.ShowEffect(self.gameObject,"chi",gameUIObjects.playerHupaiPos[realIndex]);
    --2.刷新喜牌
    playerView.hnzzm_GridTool:RefreshGridXi(playerData.operationCards);
    --3.刷新牌桌上的牌
    outPlayerView.hnzzm_GridTool:RefreshGridThrow(outPlayerData.paiHe);
    --4.刷新手牌
    playerView.hnzzm_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
    if chiData.seat == self.HNZZM_Logic.mySeat then 
        gameUIObjects.newTingOperation.gameObject:SetActive(false);
        gameUIObjects.playerTingButton.gameObject:SetActive(false);
        --5.清除牌的高亮标记
        self:SetPlateUIColor(playerView.hnzzm_GridTool.gridHand,{},false);
        --6.刷新新的操作
        self:RefreshOperationSend(playerData.operations,playerData);
        --7.处理提牌,吃牌只是动了手牌，摸牌就不用更新提牌操作了
        self:SetTiPlateMark(playerView.hnzzm_GridTool.gridHand,playerData.mahjongs,playerData.tingTip,myData);
        self:SetPlayerCPT(playerData.tingTip);
    end
    --8.刷新当前出牌玩家
    self:SetActivePlayer(self.roomData);
    if self.gameObject.activeSelf then 
        AudioManager.Instance:PlayAudio(self:GetAudioPrefix()..(playerData.sex==1 and 'man' or 'woman').."_chi");
    end
    --9.隐藏最后出牌的指示器
    gameUIObjects.curOperatPlateEffect.gameObject:SetActive(false);
    self:CheckPlayerTrustesship(self.roomData.setting.trusteeship);
    
end

--玩家碰牌
function HNZZM_UILayer:SetPlayerPengPai(pengData)
    local realIndex     = self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(pengData.seat));
    local outRealIndex  = self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(pengData.outSeat));
    local myRealIndex   = self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(self.HNZZM_Logic.mySeat));
    local playerView    = gameUIObjects.playerViews[realIndex];
    local myPlayerView  = gameUIObjects.playerViews[myRealIndex];
    local playerData    = self.HNZZM_Logic:GetPlayerDataBySeat(pengData.seat);
    local myData        = self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat);
    local outPlayerData = self.HNZZM_Logic:GetPlayerDataBySeat(pengData.outSeat);
    local outPlayerView = gameUIObjects.playerViews[outRealIndex];
    --显示特效
    effManger.ShowEffect(self.gameObject,"peng",gameUIObjects.playerHupaiPos[realIndex]);
    playerView.hnzzm_GridTool:RefreshGridXi(playerData.operationCards);
    outPlayerView.hnzzm_GridTool:RefreshGridThrow(outPlayerData.paiHe);
    playerView.hnzzm_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
    -- print("pengData.seat:"..pengData.seat..",mySeat:"..self.HNZZM_Logic.mySeat);
    if pengData.seat == self.HNZZM_Logic.mySeat then 
        gameUIObjects.newTingOperation.gameObject:SetActive(false);
        gameUIObjects.playerTingButton.gameObject:SetActive(false);
        self:SetPlateUIColor(playerView.hnzzm_GridTool.gridHand,{},false);
        self:SetPlateUIColor(playerView.hnzzm_GridTool.gridMo,{},false);
        self:RefreshOperationSend(myData.operations,myData);
        self:SetTiPlateMark(myPlayerView.hnzzm_GridTool.gridHand,myData.mahjongs,myData.tingTip,myData);
    end
    self:SetActivePlayer(self.roomData);
    if self.gameObject.activeSelf then 
        AudioManager.Instance:PlayAudio(self:GetAudioPrefix()..(playerData.sex==1 and 'man' or 'woman').."_peng");
    end
    gameUIObjects.curOperatPlateEffect.gameObject:SetActive(false);
    self:CheckPlayerTrustesship(self.roomData.setting.trusteeship);
    
end

--玩家杠牌
function HNZZM_UILayer:SetPlayerGangPai(gangData)
    --显示特效
    local realIndex     = self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(gangData.seat));
    local myRealIndex   = self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(self.HNZZM_Logic.mySeat));
    local playerView    = gameUIObjects.playerViews[realIndex];
    local playerData    = self.HNZZM_Logic:GetPlayerDataBySeat(gangData.seat);
    local myData        = self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat);
    local myPlayerView  = gameUIObjects.playerViews[myRealIndex];
    effManger.ShowEffect(self.gameObject,self:GetGangEffectString(gangData.gangType),gameUIObjects.playerHupaiPos[realIndex]);
    playerView.hnzzm_GridTool:RefreshGridXi(playerData.operationCards);
    playerView.hnzzm_GridTool:RefreshGridHand(playerData.mahjongs,playerData.mahjongCount);
    self:HideTiMark(myPlayerView.hnzzm_GridTool.gridHand);
    self:HideTiMark(myPlayerView.hnzzm_GridTool.gridMo);
    if gangData.outSeat then 
        local outPlayerData = self.HNZZM_Logic:GetPlayerDataBySeat(gangData.outSeat);
        local outRealIndex  = self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(gangData.outSeat));
        local outPlayerView = gameUIObjects.playerViews[outRealIndex];
        outPlayerView.hnzzm_GridTool:RefreshGridThrow(outPlayerData.paiHe);
    end
    playerView.hnzzm_GridTool:SetGridMoVisible(false);
    self:SetActivePlayer(self.roomData);
    if gangData.seat == self.HNZZM_Logic.mySeat then 
        gameUIObjects.newTingOperation.gameObject:SetActive(false);
        gameUIObjects.playerTingButton.gameObject:SetActive(false);
        self:SetPlateUIColor(playerView.hnzzm_GridTool.gridHand,{},false);
        self:SetPlateUIColor(playerView.hnzzm_GridTool.gridMo,{},false);
        
    end
    self:RefreshOperationSend(myData.operations,myData);
    SetUserData(gameUIObjects.playerTingButton.gameObject,myData.tingMahjongs);
    if self.gameObject.activeSelf then 
        AudioManager.Instance:PlayAudio(self:GetAudioPrefix()..(playerData.sex==1 and 'man' or 'woman').."_gang");
    end
    gameUIObjects.curOperatPlateEffect.gameObject:SetActive(false);
    self:CheckPlayerTrustesship(self.roomData.setting.trusteeship);
end

--获取杠牌特效字符串
function HNZZM_UILayer:GetGangEffectString(gangType)
    if gangType == self.hnm_pb.MING then 
        return "mg";
    elseif gangType == self.hnm_pb.AN then 
        return "ag";
    elseif gangType == self.hnm_pb.DIAN then 
        return "gang";
    end
    return "unknow";
end

--玩家补牌
function HNZZM_UILayer:SetPlayerBuPai(buData)
    print("SetPlayerBuPai was called----------------------->");
end

--玩家过牌
function HNZZM_UILayer:SetPlayerGuoPai(guoData)
    print("SetPlayerGuoPai was called------------------------>");
    if guoData.seat == self.HNZZM_Logic.mySeat then 
        local myData        = self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat);
        local playerView    = gameUIObjects.playerViews[self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(self.HNZZM_Logic.mySeat))];
        self:OperationForbidden(myData.sealPai);
        self:SetPlateUIColor(playerView.hnzzm_GridTool.gridHand,{},false);--清空牌的颜色
        -- self:HideTiMark(playerView.hnzzm_GridTool.gridHand);
        -- self:HideTiMark(playerView.hnzzm_GridTool.gridMo);
        self:CheckPlayerTrustesship(self.roomData.setting.trusteeship);
    else
        self:SetCountDown();
    end

end

--玩家胡牌
function HNZZM_UILayer:SetPlayerHuPai(huData)
    -- print("SetPlayerHuPai was called-------------------------->");
    gameUIObjects.operation_send.gameObject:SetActive(false);
    local realIndex     = self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(huData.outSeat));
    local playerView    = gameUIObjects.playerViews[realIndex];
    local playerData    = self.HNZZM_Logic:GetPlayerDataBySeat(huData.outSeat);
    local myPlayerView  = gameUIObjects.playerViews[self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(self.HNZZM_Logic.mySeat))];
    self:SetPlateUIColor(myPlayerView.hnzzm_GridTool.gridHand,{},false);
    self:HideTiMark(myPlayerView.hnzzm_GridTool.gridHand);
    self:HideTiMark(myPlayerView.hnzzm_GridTool.gridMo);
    print("huData.winPlayers.length="..tostring(#huData.winPlayers));
    for i=1,#huData.winPlayers do
        local winRealIndex  = self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(huData.winPlayers[i].seat));
        local winPlayerData = self.HNZZM_Logic:GetPlayerDataBySeat(huData.winPlayers[i].seat);
        print("huData.winPlayers[i].huItems.length="..#huData.winPlayers[i].huItems);
		if #huData.winPlayers[i].huItems > 0 then
            if huData.winPlayers[i].selfMo then
                if self.gameObject.activeSelf then 
                    AudioManager.Instance:PlayAudio(self:GetAudioPrefix()..(winPlayerData.sex == 1 and "man_" or "woman_").."zimo");
                end
				effManger.ShowEffect(self.gameObject, 'zm', gameUIObjects.playerHupaiPos[winRealIndex]);
            else
                if self.gameObject.activeSelf then 
                    AudioManager.Instance:PlayAudio(self:GetAudioPrefix()..(winPlayerData.sex == 1 and "man_" or "woman_").."hu");
                end
				effManger.ShowEffect(self.gameObject, 'hu', gameUIObjects.playerHupaiPos[winRealIndex]);
			end
        end
		coroutine.start(  --延时摊牌
		function()
            coroutine.wait(0.2);
            local winPlayerView = gameUIObjects.playerViews[winRealIndex];
            -- print("player hand plates donw---------");
            -- print("huData.winPlayers[i].selfMo="..tostring(huData.winPlayers[i].selfMo));
            winPlayerView.hnzzm_GridTool:GridHandPlatesDown(winPlayerData.mahjongs,winPlayerData.mahjongs);	
			--自摸的话，显示手上的牌，因为RefreshGridHandByIndex会隐藏掉手上的牌，需要再显示
			if #huData.winPlayers[i].huItems > 0 then
				if huData.winPlayers[i].selfMo then
                    winPlayerView.hnzzm_GridTool:RefreshMoPai(winPlayerData.moMahjong);
                    winPlayerView.hnzzm_GridTool:MoPaiDown(winPlayerData.moMahjong,winPlayerData.mahjongCount);
				end
			end
		end
        );
    end
    self:SetPao(huData);
    gameUIObjects.operation_send.gameObject:SetActive(false);

end


function HNZZM_UILayer:SetPao(winData)
    -- print("SetPao was called------------->");
	if winData.outSeat < 0 then
		return;
	end
	local isFangPao = true
	local winSeat = -1;
	for i = 1, #winData.winPlayers do
		if(winSeat == -1) then
			winSeat = winData.winPlayers[i].seat
		elseif winSeat ~= winData.winPlayers[i].seat then
			isFangPao = false;
			break;
		end
    end
    local realIndex = self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(winData.outSeat));
	if isFangPao  then -- 放炮
        -- print("tp-------------->1");
		effManger.ShowEffect(self.gameObject, 'fp', gameUIObjects.playerHupaiPos[realIndex]);
	else -- 通炮
		-- print("fp-------------->2");
		effManger.ShowEffect(self.gameObject, 'tp', gameUIObjects.playerHupaiPos[realIndex]);
    end
    -- print("self.gameObject:"..tostring(self.gameObject));

end

function HNZZM_UILayer:GetgameUIObjects()
    return gameUIObjects;
end


--根据背景设置文字颜色
function HNZZM_UILayer:SetGameColor(bgIndex)
    gameUIObjects.dipai:Find("frame/roundHead"):GetComponent("UILabel").color           = self:getAccorColor(color);
	gameUIObjects.dipai:Find("frame/roundHead/roundTail"):GetComponent("UILabel").color = self:getAccorColor(color);
	gameUIObjects.roomRound:GetComponent("UILabel").color                               = self:getNumColor(color);
	gameUIObjects.dipai:Find("frame/leftHead"):GetComponent("UILabel").color            = self:getAccorColor(color);
	gameUIObjects.dipai:Find("frame/leftHead/leftTail"):GetComponent("UILabel").color   = self:getAccorColor(color);
	gameUIObjects.dipai:Find('frame/leftCard'):GetComponent('UILabel').color            = self:getNumColor(color);
end



function HNZZM_UILayer:getAccorColor(color)
	if color == 1 then
		return Color.New(57/255,123/255,174/255);
	else
		return Color.New(52/255,209/255,186/255);
	end
end

function HNZZM_UILayer:getNumColor(color)
	if color == 1 then
		return Color.New(76/255,189/255,197/255);
	else
		return Color.New(205/255,220/255,114/255);
	end
end

--选择背景
function HNZZM_UILayer:ChooseBG(bgIndex)
    -- print("ChooseBG:"..bgIndex);
    for i = 1,BgColorNum do
		local bg = self.gameObject.transform:Find('gameBGs/bg'..i);
		if bgIndex == i then 
			bg.gameObject:SetActive(true);
		else
			bg.gameObject:SetActive(false);
		end
    end
    bgColor = bgIndex;
	self:SetGameColor(bgIndex);
end


--设置东南西北旁边的局数数目
function HNZZM_UILayer:SetRoundNum(num)
    -- print("SetRoundNum------------------>was called,num:"..tostring(num));
    gameUIObjects.roomRound:GetComponent("UILabel").text = num..'/'..self.roomData.setting.rounds;
end

--设置底牌的剩余数目
function HNZZM_UILayer:SetDipaiNum(num)
    -- print("SetDipaiNum------------------------------>num="..tostring(num));
    gameUIObjects.dipai:Find('frame/leftCard'):GetComponent('UILabel').text = string.format('%d', num);
end

--设置邀请好友，解散房间，分享按钮的显示和隐藏
function HNZZM_UILayer:SetInviteVisiable(show)
    gameUIObjects.ButtonCloseRoom.gameObject:SetActive(show);
    gameUIObjects.ButtonExitRoom.gameObject:SetActive(show);
    gameUIObjects.GpsView.gameObject:SetActive(show);
    if not PlatformManager.Instance:IsWXAppInstalled() then
		show = false
    end
    gameUIObjects.ButtonInvite.gameObject:SetActive(show);

    if self.HNZZM_Logic.mySeat == self.roomData.bankerSeat then 
        gameUIObjects.ButtonCloseRoom:Find('Label'):GetComponent("UILabel").text = "解散房间";
    else
        gameUIObjects.ButtonCloseRoom:Find('Label'):GetComponent("UILabel").text = "退出房间"
    end
    gameUIObjects.ButtonInvite.parent:GetComponent("UIGrid"):Reposition();
end

--显示出牌的状态，东西南北，哪个该出牌了
--当前该出牌的玩家
function HNZZM_UILayer:ShowWaitOpreatEffect(activeSeat,show)
    -- print("ShowWaitOpreatEffect,activeSeat="..tostring(activeSeat)..",show="..tostring(show));
    --先隐藏所有
    for i=1,self.HNZZM_Logic:GetMaxPlayerSize() do
        self:SetESWNState(i,false);
    end
    
    for i=1,self.HNZZM_Logic.totalSize do
        local index = self.HNZZM_Logic:GetPlayerViewIndexBySeat(activeSeat);
        self:SetESWNState(self.HNZZM_Logic:GetCorrectUIIndex(index),show);
    end
    --倒计时
    if show then 
        print("ShowWaitOpreatEffect-------------->SetCountDown");
        self:SetCountDown();
    end
end

--设置倒计时
function HNZZM_UILayer:SetCountDown(trusteeShipTime)
    --如果选择了托管，那么倒计时就已托管的时间开始计时
    if self.roomData.setting.trusteeship > 0 then 
        HNZZM_Tools.CountDown(gameUIObjects.dipai:Find("timer"),(trusteeShipTime and trusteeShipTime or self.roomData.setting.trusteeship),0);
    else
        HNZZM_Tools.CountDown(gameUIObjects.dipai:Find("timer"),15,0);
    end
end



--设置等待其他玩家操作的提示
function HNZZM_UILayer:SetWaitOpTip(show,tipString)
    if self.waitTipCoroutine then 
        coroutine.stop(self.waitTipCoroutine);
    end

    if show then 
        self.waitTipCoroutine = coroutine.start(function()
            coroutine.wait(1);--这里之所以等待，是为了截图等待其他玩家操作的提示一闪而过的问题
            self:SetTip(show,tipString);
        end);
    else
        self:SetTip(show,tipString);
    end
end

--玩家禁止操作
function HNZZM_UILayer:OperationForbidden(isForbidden)
    -- print("OperationForbidden,isForbidden="..tostring(isForbidden));
    gameUIObjects.operation_mask.gameObject:SetActive(isForbidden);
	local myData = self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat);
	myData.sealPai = isForbidden;
end

--提牌标记
function HNZZM_UILayer:SetTiPlateMark(gridHand,mahjongs,tingTips,playerData)
    -- print("SetTiPlateMark was called,gridHand="..tostring(gridHand)..",mahjongs.length="..#mahjongs..",tingTips.length:"..#tingTips);
  
	--1.先隐藏所有提牌标识
	for i = 0, gridHand.childCount-1 do
		local tingTip = gridHand:GetChild(i):Find("tingTip");
        tingTip.gameObject:SetActive(false);
		--清空数据
		SetUserData(tingTip.gameObject,nil);
	end
	--2.显示新的标识
	local posKeyDatas = GetMJTingPosKey(mahjongs,tingTips);
	-- print("posKeyDatas.length:"..(#posKeyDatas));
	for i = 1, #posKeyDatas do
		local cardItem = gridHand:GetChild(posKeyDatas[i].posKey-1);
		-- print("set ting data pos:"..posKeyDatas[i].posKey);
		local tingTip = cardItem:Find("tingTip");
        tingTip.gameObject:SetActive(true);
		SetUserData(tingTip.gameObject, posKeyDatas[i].tingMahjongs);
		-- print("ti data length:"..(#posKeyDatas[i].tingMahjongs));

	end
end

--隐藏提牌标识
function HNZZM_UILayer:HideTiMark(grid)
    -- print("HideTiMark:grid="..tostring(grid)..",grid.childCount"..grid.childCount);
    for i = 0, grid.childCount -1 do
        local cardItem = grid:GetChild(i);
        -- print("cardItem="..tostring(cardItem));
		local tingTip = cardItem:Find("tingTip");
		tingTip.gameObject:SetActive(false);
		SetUserData(tingTip.gameObject,nil);
	end
end


function HNZZM_UILayer:SetESWNState(index,show)	gameUIObjects.ActivePlayerESWN[index]:Find('select').gameObject:SetActive(show);
   gameUIObjects.ActivePlayerESWN[index]:Find('frame').gameObject:SetActive(show);
   gameUIObjects.ActivePlayerESWN[index]:Find('unselect').gameObject:SetActive(not show);
   gameUIObjects.playerViews[index]:SetActiveFlag(show);
   
end

function HNZZM_UILayer:SetTip(argShow,argTipString)
   gameUIObjects.waitopTip:Find("danTip"):GetComponent("UILabel").text = argTipString;
   gameUIObjects.waitopTip.gameObject:SetActive(argShow and not gameUIObjects.ButtonHu.gameObject.activeInHierarchy);
end

function HNZZM_UILayer:SetGameTypePos()
	if gameUIObjects.roomSetting.gameObject.activeSelf then
		gameUIObjects.gameTypeobj.localPosition = Vector3.New(-4,171,0);
	else
		gameUIObjects.gameTypeobj.localPosition = Vector3.New(-4,102,0);
	end
end

--显示等待的时候需要显示的UI，隐藏游戏进行中的UI
function HNZZM_UILayer:ShowWaittingUI()
    -- print("ShowWaittingUI-------------->was called");
    gameUIObjects.dipai.gameObject:SetActive(HNZZM_PlayLogic.NeedShowDiPai(self.roomData,self.HNZZM_Logic));
    gameUIObjects.roomSetting.gameObject:SetActive(true);
    gameUIObjects.ButtonReady.gameObject:SetActive(not self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat).ready);
    gameUIObjects.roomRound.gameObject:SetActive(HNZZM_PlayLogic.NeedShowDiPai(self.roomData,self.HNZZM_Logic));
    self:SetGameTypePos();
end

--隐藏等待时显示的UI，显示游戏进行中的UI
function HNZZM_UILayer:HideWaittingUI()
    -- print("HideWaittingUI---------------was called");
    -- print("NeedShowDiPai:"..tostring(HNZZM_PlayLogic.NeedShowDiPai(self.roomData,self.HNZZM_Logic)));
    gameUIObjects.roomSetting.gameObject:SetActive(false);
    gameUIObjects.dipai.gameObject:SetActive(HNZZM_PlayLogic.NeedShowDiPai(self.roomData,self.HNZZM_Logic));
    gameUIObjects.roomRound.gameObject:SetActive(HNZZM_PlayLogic.NeedShowDiPai(self.roomData,self.HNZZM_Logic));
    self:SetGameTypePos();
end





--玩家离开房间
function HNZZM_UILayer:SetLeaveRoom()
   
    if self.roomData.clubId ~= '0' then 
        PanelManager.Instance:ShowWindow("panelClub",{name = "panelInGame_hnzzm"});
    else
        PanelManager.Instance:ShowWindow("panelLobby",self.gameObject.name);
    end
end



function HNZZM_UILayer:getCardColor()
    return cardColor;
end

function HNZZM_UILayer:getcardText()
    return cardText;
end

function HNZZM_UILayer:GetAudioPrefix()
    return language == 1 and "" or "fy_";
end

function HNZZM_UILayer:OutPlateType()
    return outPlateType;
end

----根据颜色值获取麻将背板图片
function HNZZM_UILayer:getColorCardName(name,colorIndex)
    if colorIndex == 1 then --绿色
		return name;
	elseif colorIndex == 2 then --黄色
		return name..'y';
	end
end

--根据用户选择选择麻将的牌面
function HNZZM_UILayer:GetCardTextName(plateIndex,cardTextIndex)
    return tostring(plateIndex);
end

--获取游戏语言选择
function HNZZM_UILayer:GetLanguage()
    return language;
end

--根据用户的选择选择牌面大小
function HNZZM_UILayer:GetCardPlateSize(plateIndex,cardTextIndex)
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

function HNZZM_UILayer:SetPlateColor(throwItemobj,showColor)
    if showColor then
		throwItemobj:GetComponent("UISprite").color = Color(255/255,222/255,84/255);
	else
		throwItemobj:GetComponent("UISprite").color = Color(255/255,255/255,255/255);
	end
end

--设置玩家出牌展示
function HNZZM_UILayer:SetPlayerChuPaiShow(seat,mahjong)
     local playerView = gameUIObjects.playerViews[self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(seat))];
     playerView.hnzzm_GridTool:RefreshChuPai(mahjong);
end

--设置箭头指向最后一个玩家出的牌
function HNZZM_UILayer:SetLastPlayerChuPaiEffect(seat)
    local playerView = gameUIObjects.playerViews[self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(seat))];
    local playerData = self.HNZZM_Logic:GetPlayerDataBySeat(seat);
    gameUIObjects.curOperatPlateEffect.gameObject:SetActive(true);
    StartCoroutine(function() 
        WaitForEndOfFrame();
         gameUIObjects.curOperatPlateEffect.position = playerView.hnzzm_GridTool.gridThrow:GetChild(#playerData.paiHe-1).position;
    end);

end

--刷新玩家吃碰杠补等操作
function HNZZM_UILayer:RefreshOperationSend(operations,playerData)
    -- print("RefreshOperationSend.operations.length:"..#operations..",playerData.seat:"..playerData.seat);
    self.relevantOpTable = nil;
    --1.刷新该显示的按钮
    self:SetOperationButtons(operations);
    --2.设置相关牌的颜色
    local OpTable, relevantPlates   = HNZZM_PlayLogic.GetRelevantPlates(operations,playerData.mahjongs,playerData.operationCards);
    self.relevantOpTable            = OpTable;
    local realIndex                 = self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(playerData.seat));
    local playerView                = gameUIObjects.playerViews[realIndex];
    -- print("playerView.hnzzm_GridTool.gridHand.childCount:"..playerView.hnzzm_GridTool.gridHand.childCount..",realIndex:"..realIndex);
    self:SetPlateUIColor(playerView.hnzzm_GridTool.gridHand,relevantPlates,true);
    
end

--设置操作按钮的显示
function HNZZM_UILayer:SetOperationButtons(operations)
    -- print("SetOperationButtons.operations.length="..#operations);
    gameUIObjects.operation_send.gameObject:SetActive(#operations ~= 0);
    gameUIObjects.ButtonHu.gameObject:SetActive(false);
	gameUIObjects.ButtonGang.gameObject:SetActive(false);
	gameUIObjects.ButtonPeng.gameObject:SetActive(false);
	gameUIObjects.ButtonChi.gameObject:SetActive(false);
	gameUIObjects.ButtonGuo.gameObject:SetActive(true);
    gameUIObjects.ButtonBu.gameObject:SetActive(false);
    PanelManager.Instance:HideWindow('panelChiPai_mj');

    for i=1,#operations do
        -- print("operations[i].operation="..operations[i].operation);
        if operations[i].operation == self.hnm_pb.CHI then 
            gameUIObjects.ButtonChi.gameObject:SetActive(true);
        elseif operations[i].operation == self.hnm_pb.PENG then
            gameUIObjects.ButtonPeng.gameObject:SetActive(true); 
        elseif operations[i].operation == self.hnm_pb.GANG then 
            gameUIObjects.ButtonGang.gameObject:SetActive(true);
        elseif operations[i].operation == self.hnm_pb.BU then 
            gameUIObjects.ButtonBu.gameObject:SetActive(true);
        elseif operations[i].operation == self.hnm_pb.HU then 
            gameUIObjects.ButtonHu.gameObject:SetActive(true);
        end
    end

    gameUIObjects.operation_send:GetComponent("UIGrid"):Reposition();

end

--设置相关牌的颜色高亮
function HNZZM_UILayer:SetPlateUIColor(grid,relevantPlates,dark)
    -- print("grid:"..tostring(grid)..",grid.childCount:"..grid.childCount..",relevantPlates.length:"..tableCount(relevantPlates)..",dark:"..tostring(dark));
    if dark and  tableCount(relevantPlates) > 0 then --
        for i=1,grid.childCount do
            local item = grid:GetChild(i-1);
            local checkPlate = GetUserData(item.gameObject);
            -- print("checkPlate:"..checkPlate..",relevantPlate:"..tostring(relevantPlates[checkPlate]));
            if not relevantPlates[checkPlate] then --不是相关的牌，则变成灰色
                item:GetComponent('UISprite').color = Color.gray;
				item:GetChild(0):GetComponent('UISprite').color = Color.gray;
            else--相关的牌则变成高亮
                item:GetComponent('UISprite').color = Color.white;
				item:GetChild(0):GetComponent('UISprite').color = Color.white;
            end
        end
    else
        for i=1,grid.childCount do
            local item = grid:GetChild(i-1);
            item:GetComponent('UISprite').color = Color.white;
			item:GetChild(0):GetComponent('UISprite').color = Color.white;
        end
    end
end


function HNZZM_UILayer:SetCardColor(colorNum)
    cardColor = colorNum;
    self:RefreshAllGrid();
end

function HNZZM_UILayer:SetCardText(textNum)
    -- print("SetCardText was called--------------->");
    cardText = textNum;
    self:RefreshAllGridHand();
    self:RefreshAllGridMoPai();
end

function HNZZM_UILayer:SetLanguage(languageNum)
    language = languageNum;
end

function HNZZM_UILayer:SetOutPlateType(Type)
    print("SetOutPlateType---->"..Type);
    outPlateType = Type;
end


function HNZZM_UILayer:NotifyGameStart()
    if  (self.HNZZM_Logic:GetPlayerDataLength() == self.roomData.setting.size and 
        self.roomData.round == 1 and 
        self.roomData.state ~= self.hnm_pb.GAMING) and 
        not self.gameObject.activeSelf then 
        if panelInGame.OnRoundStarted ~= nil then 
            panelInGame.OnRoundStarted();
        end
    end
end

--设置玩家的托管
function HNZZM_UILayer:SetPlayerTrustesship(seat,enabled)
    -- print("player has been trusteehiped----------------------------->");
    -- print("seat:"..tostring(seat));
    -- print("enabled:"..tostring(enabled));
    local playerView = gameUIObjects.playerViews[self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(seat))];
    playerView:SetTrusteeship(enabled);
    if seat == self.HNZZM_Logic.mySeat then --进入托管
        if enabled then --1.进入托管
            self.TrusteeshipFsmMachine:Switch(TrusteeShipStates.TrusteeShipping);
        else--2.取消托管
            self.TrusteeshipFsmMachine:Switch(TrusteeShipStates.TrusteeShipEnd);
            self:CheckPlayerTrustesship(self.roomData.setting.trusteeship);
        end
    end
  
end
--检查托管的状态
function HNZZM_UILayer:CheckPlayerTrustesship(trusteeShipTime)
    local operations = self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat).operations;
    -- print("operations.length="..#operations);
    if  self.roomData.setting.trusteeship > 0 and 
        (#operations > 0 or self.roomData.activeSeat == self.HNZZM_Logic.mySeat) and 
        self.roomData.state == self.hnm_pb.GAMING then 
        local myData = self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat);
        --如果自己不处于托管状态，那么当满足上面的条件，就应该开始走托管流程
        -- print("myData.trusteeship----------->"..tostring(myData.trusteeship));
        if not myData.trusteeship then 
            -- print("CheckPlayerTrustesship it was trusteeshiped,self.roomData.trusteeshipRemainMs"..trusteeShipTime);
            self.TrusteeshipFsmMachine:Switch(TrusteeShipStates.TrusteeShipCountting,{trusteeshipRemainMs = trusteeShipTime});
            -- print("CheckPlayerTrustesship-------------->SetCountDown");
            self:SetCountDown(trusteeShipTime);
        end
    else
        
    end
end
--检查非游戏中流程中的托管状态，现在小结算中也需要托管倒计时
--trusteeShipTime 托管倒计时
--isRoundEndCheck 是否是小结算托管检测
function HNZZM_UILayer:CheckPlayerOtherTrustesship(trusteeShipTime,isRoundEndCheck)
    print("CheckPlayerOtherTrustesship-----------------trusteeShipTime="..trusteeShipTime..",isRoundEndCheck="..tostring(isRoundEndCheck));
    local myData = self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat);
    
    print("myData.completeChooce="..tostring(myData.completeChooce));
    if not isRoundEndCheck then 
        if not myData.trusteeship and self.roomData.setting.trusteeship>0 then 
            self.TrusteeshipFsmMachine:Switch(TrusteeShipStates.TrusteeShipCountting,{trusteeshipRemainMs = trusteeShipTime});
        end
    else
        -- print("path----------------------->1");
        if  self.roomData.setting.trusteeship>0 then 
            self.TrusteeshipFsmMachine:Switch(TrusteeShipStates.TrusteeShipCountting,{trusteeshipRemainMs = trusteeShipTime});
        end
    end
   
end


--初始化托管状态机
function HNZZM_UILayer:InitTrusteeMachine()
    -- print("InitTrusteeMachine-------------------------->");
    self.TrusteeshipFsmMachine:Add(TrusteeShipStates.TrusteeShipCountting,function(extraParameter)
        gameUIObjects.TrusteeShipPanel.gameObject:SetActive(false);
        StopTrusteeshipVerification(self.trusteeShipCoroutine);
        self.trusteeShipCoroutine = StartTrusteeshipVerification(extraParameter.trusteeshipRemainMs,
        --倒计时
        function(time) 
            print("剩余时间---"..time);
            gameUIObjects.TrusteeShipTip.gameObject:SetActive(true);
            gameUIObjects.TrusteeShipTip:Find("Time"):GetComponent("UILabel").text = time;
        end,
        --倒计时结束,进入托管状态
        function()
            self.TrusteeshipFsmMachine:Switch(TrusteeShipStates.TrusteeShipping);
        end)
    end);

    self.TrusteeshipFsmMachine:Add(TrusteeShipStates.TrusteeShipping,function(extraParameter)
        if self.trusteeShipCoroutine then 
            StopTrusteeshipVerification(self.trusteeShipCoroutine);
        end
        gameUIObjects.TrusteeShipTip.gameObject:SetActive(false);
        gameUIObjects.TrusteeShipPanel.gameObject:SetActive(true);
    end);

    self.TrusteeshipFsmMachine:Add(TrusteeShipStates.TrusteeShipEnd,function(extraParameter)
        print("---------------------TrusteeShipStates.TrusteeShipEnd------------------------------------")
        if self.trusteeShipCoroutine then 
            StopTrusteeshipVerification(self.trusteeShipCoroutine);
        end
        gameUIObjects.TrusteeShipTip.gameObject:SetActive(false);
        gameUIObjects.TrusteeShipPanel.gameObject:SetActive(false);
       
    end);
end

function HNZZM_UILayer:SetRoomNoExist()
    panelMessageTip.SetParamers('房间已解散', 2)
    PanelManager.Instance:ShowWindow('panelMessageTip')
    coroutine.start(
        function()
            coroutine.wait(2)
            panelLogin.HideGameNetWaitting();
            self:SetGameDestroy(self.roomData);
            self.roomData.clubId = '0'
        end
    );
end

function HNZZM_UILayer:SetPlayerPao(data)
    if data == nil or #data.score == 0 then 
        return;
    end
    local myData = self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat);
    gameUIObjects.runScoreOperation.gameObject:SetActive(self.HNZZM_Logic:NeedShowRunScore());
    --先隐藏
    for i=1,5 do
        gameUIObjects.runScoreOperation:Find("run"..i).gameObject:SetActive(false);
    end

    for i = 1,#data.score do 
        gameUIObjects.runScoreOperation:Find("run"..i).gameObject:SetActive(true);
    end
	gameUIObjects.runScoreOperation:GetComponent("UIGrid"):Reposition()
end

function HNZZM_UILayer:SetPlayerSelectPao(data)
    if data == nil  then 
        return;
    end
    if data.seat == self.HNZZM_Logic.mySeat then 
        gameUIObjects.runScoreOperation.gameObject:SetActive(false);
    end
    local realIndex = self.HNZZM_Logic:GetCorrectUIIndex(self.HNZZM_Logic:GetPlayerViewIndexBySeat(data.seat));
    gameUIObjects.playerViews[realIndex]:SetRunScore(data.score);
end

--播放混牌的动画
function HNZZM_UILayer:HunPlatesAnimation(hunPlates)
    print("HunPlatesAnimation was called");
    if not self.roomData.setting.takeHun or hunPlates == nil or #hunPlates == 0 then 
        return;
    end
    gameUIObjects.hunPanel.gameObject:SetActive(true);
    local hunPlate = gameUIObjects.hunPanel:Find("hunPlate");
    local hunGrid = gameUIObjects.hunPanel:Find("hunGrid");
    if self.hunPlateCor ~= nil then 
        StopCoroutine(self.hunPlateCor);
        self.hunPlateCor = nil;
    end
    local myData = self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat);
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
function HNZZM_UILayer:SetHunPlates(hunPlates)
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
function HNZZM_UILayer:GetHunPlates()
    return self.HNZZM_Logic:GetPlayerDataBySeat(self.HNZZM_Logic.mySeat).hunMahjongs;
end












