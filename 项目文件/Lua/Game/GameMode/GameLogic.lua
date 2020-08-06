require("class")
require("FsmMachine")
proxy_pb        = require("proxy_pb");
GameLogic       = {};
GameLogic       = class()
GameLogic.State = {
    InitView    = "InitView",
    Gameing     = "Gameing",
    GameEnd     = "GameEnd",
    GameOver    = "GameOver",
    Destroy     = "Destroy"
}


--不要修改父类文件  如果需要自己继承实现
function GameLogic:ctor(gameView, game_pb, gameType, gameObject)
    self.mySeat         = 0;
    self.totalSize      = 0;
    self.game_pb        = game_pb
    self.gameType       = gameType
    self.gameObject     = gameObject
    self.playerViews    = {}
    self.playerDatas    = {}
    self.networkLatency = 0
    self.gameView       = gameView
    self.roomInfo       = roomInfo
    self.gameView.UploadReccordFileComplete     = function(fileid) self:UploadReccordFileComplete(fileid) end
    self.gameView.DownloadRecordFileComplete    = function(fileid) self:DownloadRecordFileComplete(fileid) end
    self.gameView.PlayRecordFilComplete         = function(fileid) self:PlayRecordFilComplete(fileid) end

    self.JoinRoom           = event("JoinRoom",             true)
    self.PlayerJoin         = event("PlayerJoin",           true)
    self.PlayerLeave        = event("PlayerLeave",          true)
    self.PlayerReady        = event("PlayerReady",          true)
    self.PlayerDisconnected = event("PlayerDisconnected",   true)
    self.RoundStart         = event("RoundStart",           true)
    self.RoundEnd           = event("RoundEnd",             true)
    self.RoundOver          = event("RoundOver",            true)
    self.GameDestroy        = event("GameDestroy",          true)
    self.InitView           = event("InitView",             true)
    self.Trusteeship        = event("Trusteeship",          true)

    self._machice = FsmMachine:New()
    self._machice:Add(GameLogic.State.InitView,     function(o) self:OnInitView(o)          end)
    self._machice:Add(GameLogic.State.Gameing,      function(o) self:OnGameRoundStart(o)    end)
    self._machice:Add(GameLogic.State.GameEnd,      function(o) self:OnGameRoundEnd(o)      end)
    self._machice:Add(GameLogic.State.GameOver,     function(o) self:OnGameRoundOver(o)     end)
    self._machice:Add(GameLogic.State.Destroy,      function(o) self:OnGameDestroy(o)       end)



    
end

function GameLogic:Init()
    -- print("Gamelogic Init------------------>")
    isIngame=true
    self.InitView();
    self:VoiceCoroutineInit();
    self:SwitchState(GameLogic.State.InitView, nil);
    self:RegisterGamepb(self.game_pb);
    self:RegisterGameCallBack();
end

function GameLogic:SwitchState(state, data)
    self._machice:Switch(state, data)
end

function GameLogic:SetMySeat(seat, totalCount)
    if seat == nil then seat = 0 end
    self.mySeat     = seat;
    self.totalSize  = totalCount;
end

function GameLogic:GetNetworkLatencyLevel()
    if self.networkLatency < 100 then
        return 3
    elseif self.networkLatency < 200 then
        return 2
    else
        return 1
    end
end

--从1开始，分别是1，2，3，4这个四个位置，并且是逆时针方向
function GameLogic:GetPlayerViewIndexBySeat(seat)
    local index = (self.totalSize - self.mySeat + seat) % self.totalSize
    return index + 1;
end

function GameLogic:GetDataSeatByUIIndex(index)
    if index > self.totalSize then return -1 end
    local dataIndex = ((index - 1) + self.mySeat) % self.totalSize
    return dataIndex;
end


function GameLogic:RegisterPlayerView(playerView)
    playerView:CleanView()
    table.insert(self.playerViews, playerView)
end

function GameLogic:GetPlayerViewBySeat(seat)
    local index = self:GetPlayerViewIndexBySeat(seat)

    return self.playerViews[index]
end

function GameLogic:RemoveAllPlayerView(resetView)
    for i = 1, #self.playerViews do
        if resetView then
            self.playerViews[i]:CleanView()
        end
    end
    self.playerViews = {}
end

function GameLogic:GetPlayerDataLength()
    local length = 0
    for k,v in pairs(self.playerDatas) do
        length = length + 1
    end
    return length
end

function GameLogic:RegisterPlayerData(playerData, resetView)
    --用户既然能够进来，那肯定是在线的
    self.playerDatas[playerData.seat] = playerData
    print(playerData.minorityValue)
    if resetView then
        local view = self:GetPlayerViewBySeat(playerData.seat)
        if view ~= nil then 
            view:ResetView(playerData) 
        end
    end
end

function GameLogic:AutoRegisterPlayerDatas(playerDatas, resetView)
    for i = 1, #playerDatas do
        local playerData = playerDatas[i]
        self:RegisterPlayerData(playerData, resetView)
    end
end

function GameLogic:GetPlayerDatas(eq)
    local tmep = {}
    for k,v in pairs(self.playerDatas) do
        if eq ~= nil and eq(v) then
            tmep[v.seat] = v
        elseif eq == nil then
            tmep[v.seat] = v
        end
    end
    return tmep
end

function GameLogic:ForeachPlayerDatas(action)
    assert(action, "ForeachPlayerDatas(action)不能为空")
    for k,v in pairs(self.playerDatas) do
        action(self:GetPlayerViewBySeat(k), v)
    end
end

function GameLogic:GetPlayerDataByUIIdex(index)
    local seat = self:GetDataSeatByUIIndex(index)
    return self.playerDatas[seat]
end


function GameLogic:GetPlayerDataBySeat(seat)
    return self.playerDatas[seat]
end

function GameLogic:ResetAllPlayerView()
    for i = 1, self.totalSize do
        local data = self:GetPlayerDataByUIIdex(i)
        if data ~= nil then
            local view = self:GetPlayerViewBySeat(data.seat)
            if view ~= nil then view:ResetView(data) end
        else
            self:GetPlayerViewBySeat(self:GetDataSeatByUIIndex(i)):CleanView()
        end
    end
end

function GameLogic:RemovePlayerData(seat, resetView)
    self.playerDatas[seat] = nil
    local view = self:GetPlayerViewBySeat(seat)
    if resetView and view then
        self:GetPlayerViewBySeat(seat):CleanView()
    end
end

function GameLogic:RemoveAllPlayerData(resetView)
    for i = 1, #self.playerDatas do
        self:RemovePlayerData(self.playerDatas[i].seat, resetView)
    end
    self.playerDatas = {}
end

function GameLogic:DownImage(url, image)
    coroutine.start(LoadPlayerIcon, image.gameObject:GetComponent('UITexture'), url);
end


--界面打开时自动调用  子类自行实现
function GameLogic:OnInitView(data)end

function GameLogic:OnJoinRoom(data)end

function GameLogic:OnPlayerJoin(data)end

function GameLogic:OnLeaveRoom()end

function GameLogic:OnDissolve(data) end;

function GameLogic:OnLordDissolve() end;

function GameLogic:OnAutoDissolve() end;

function GameLogic:OnRoomError() end;

function GameLogic:OnRoomNoExist() end;

function GameLogic:OnPlayerLeave(seat)end

function GameLogic:OnPlayerDisconnected(seat)end

function GameLogic:OnRoomCannotDissolve()end

function GameLogic:OnRoomDissolveLimit5()end

function GameLogic:OnRoomDissolveIn5Seconds()end

function GameLogic:OnPlayerReady(seat)end

--游戏状态切换到游戏中时自动调用  子类自行实现
function GameLogic:OnGameRoundStart(data)end

--游戏状态切换到小局游戏结束时自动调用  子类自行实现
function GameLogic:OnGameRoundEnd(data)end

--游戏状态切换到游戏结束时自动调用  子类自行实现
function GameLogic:OnGameRoundOver(data)end

--游戏状态切换到游戏结束时自动调用  子类自行实现 并调用父类
function GameLogic:OnGameDestroy(data)end

function GameLogic:OnPlayerMagicEmoji(data)
    local animName, inx, soundName = "", 0, ""
	if data.index == 1 then
		animName = 'emoji_zhadan'
		inx = 13
		soundName = 'bombVoice'
	elseif data.index == 2 then
		animName = 'emoji_jidan'
		inx = 11
		soundName = 'eggVoice'
	elseif data.index == 3 then
		animName = 'emoji_pijiu'
		inx = 13
		soundName = 'cheersVoice'
	elseif data.index == 4 then
		animName = 'emoji_hongchun'
		inx = 17
		soundName = 'voiceLove'
	elseif data.index == 5 then
		animName = 'emoji_xianhua'
		inx = 3
		soundName = 'flowerVoice'
	elseif data.index == 6 then
		animName = 'emoji_dianzan'
		inx = 3
		soundName = 'zan'
    end
    print(data.rseat, data.seat, animName);
    local positionFrom = self:GetPlayerViewBySeat(data.seat).image.position
    local positionTo = self:GetPlayerViewBySeat(data.rseat).image.position
    self:GetPlayerViewBySeat(data.seat):SetMagicEmoji(positionFrom, positionTo, animName, inx, soundName)
end

function GameLogic:OnPlayChat(data)
    self:GetPlayerViewBySeat(data.seat):SetChat(data)
end

function GameLogic:OnPlayerVoice(seat, voiceId)
    print("座位："..seat.."Voice："..voiceId)
    self:GetPlayerDataBySeat(seat).voiceId = voiceId
    NGCloudVoice.Instance:Click_btnDownloadFile(voiceId)
end

function GameLogic:OnPlayerTrustesship(seat, enable) end

function GameLogic:EnterGameServer(ip, port)
    print("GameLogi------------------------EnterGameServer,ip:"..ip.."port:"..port);
    self.connect = NetWorkManager.Instance:CreateConnect('game')
    self.connect.IP = GetServerIPorTag(false, ip)
    self.connect.Port = port
    self.connect.GroupName = ConfigManager.getProperty('ProxyServer', 'GroupName', '');
    self.connect.rspCallBackLua = receiveGameMessage;
    self.connect.heartBeatInterval = 5;
    self.connect.reConnectNum = ConfigManager.getIntProperty('Setting', 'ReconnectNum', 5)

    self.connect.onConnectLua = function() self:OnEnteredGameServer() end
    self.connect.disConnectLua = function() self:OnDisconnectGameServer() end

    self.connect:Connect();
end

local function RequestJoinGame(logic, callBack)
    local msg = logic.game_pb.PJoinRoom()
    msg.roomNumber = roomInfo.roomNumber
	msg.token 		= roomInfo.token
	msg.longitude 	= tonumber(UnityEngine.PlayerPrefs.GetFloat("longitude",0))
    msg.latitude 	= tonumber(UnityEngine.PlayerPrefs.GetFloat("latitude",0))
    msg.address 	= UnityEngine.PlayerPrefs.GetString("address","")
    
    logic:SendGameMsg(logic.game_pb.JOIN_ROOM, msg:SerializeToString(), function(msg)
        local body = logic.game_pb.RJoinRoom()
        body:ParseFromString(msg.body)
        logic.roomData = body.room;
        if callBack then callBack(body) end
    end)
end

--连接到游戏服务调用  子类实现
function GameLogic:OnEnteredGameServer()
    PanelManager.Instance:HideWindow("panelGameNetWaitting")
    RequestJoinGame(self, function(body)
        
        self:RemoveAllPlayerData();
        self:AutoRegisterPlayerDatas(body.room.players, true)
        self:OnJoinRoom(body)
        self.JoinRoom(body)
    end)
end

--从游戏服务断开连接调用  子类实现
function GameLogic:OnDisconnectGameServer()
    PanelManager.Instance:ShowWindow("panelGameNetWaitting")
end

function GameLogic:GetMesaageData(body, msg)
    body:ParseFromString(msg.body)
    return body
end

function GameLogic:SendGameMsg(msgType, package, callBack)
    local msg = Message.New()
    msg.type = msgType
    if package then msg.body = package end
    SendGameMessage(msg, callBack)
end



function GameLogic:Ready()
    self:SendGameMsg(self.game_pb.READY, nil)
end

function GameLogic:LeaveRoomIfNeedClose(isGaming)
    if self.mySeat ~= 0 and (not isGaming) then
        self:SendGameMsg(self.game_pb.LEAVE_ROOM, nil, nil)
    else
       local b = self.game_pb.PDissolve()
       b.decision = self.game_pb.APPLY
       self:SendGameMsg(self.game_pb.DISSOLVE, b:SerializeToString(), nil)
    end
end

--是否所有人都准备好了
function GameLogic:IsAllReaded()
    for i = 0, self.roomData.setting.size - 1 do
        local playerData = self:GetPlayerDataBySeat(i)
        if playerData == nil or playerData.ready ~= true then
            return false
        end
    end
    return true
end

--自己是否时房主
function GameLogic:IsBanker()
    -- print("self.roomData.banker:"..tostring(self.roomData.banker));
    if self.roomData.bankerSeat  then 
      
        return self.roomData.bankerSeat == self.mySeat;
    elseif self.roomData.banker then 
       
        return self.roomData.banker == self.mySeat;
    end
    return self.roomData.bankerSeat and self.roomData.bankerSeat == self.mySeat or (self.roomData.banker>=0) ;
end

function GameLogic:VoiceCoroutineInit()
    print("VoiceCoroutineInit")
	if GvoiceCor then
        coroutine.stop(GvoiceCor)
        GvoiceCor = nil
	end
    GvoiceCor = coroutine.start(function()
        while self.gameObject.activeSelf do
            NGCloudVoice.Instance:Poll()
            coroutine.wait(0.03)
        end
    end)
	NGCloudVoice.Instance:ApplyMessageKey()
end

function GameLogic:RequestRecord()
    AudioManager.Instance.AudioOn = false
    AudioManager.Instance.MusicOn = false
    if not self.voiceProcess then
        NGCloudVoice.Instance:Click_btnStopPlayRecordFile();
        coroutine.start(function()
            NGCloudVoice.Instance:Click_btnStartRecord();
        end)
    end
end

function GameLogic:ResponseRecord(needUpload)
    AudioManager.Instance.AudioOn = UnityEngine.PlayerPrefs.GetInt('audio_on', 1) ~= 0
    AudioManager.Instance.MusicOn = UnityEngine.PlayerPrefs.GetInt('music_on', 1) ~= 0
    NGCloudVoice.Instance:Click_btnStopRecord();
    if needUpload then
        NGCloudVoice.Instance:Click_btnUploadFile();
    end
end

function GameLogic:UploadReccordFileComplete(fileid)
    print("--------------------语音上传完成--------------------")
    local body = self.game_pb.PVoiceMember()
    body.voiceId = fileid
    self:SendGameMsg(self.game_pb.VOICE_MEMBER, body:SerializeToString())
end

function GameLogic:DownloadRecordFileComplete(fileid)
    print("--------------------语音下载完成--------------------")
    AudioManager.Instance.AudioOn = false;
    AudioManager.Instance.MusicOn = false;
    for k,v in pairs(self:GetPlayerDatas(function(playerData) return playerData.voiceId == fileid end)) do
        self:GetPlayerViewBySeat(k):SetVoiceFlag(true)
    end
    self.voiceProcess = true;
end

function GameLogic:PlayRecordFilComplete(fileid)
    print("--------------------语音播放完成--------------------")
    AudioManager.Instance.AudioOn = UnityEngine.PlayerPrefs.GetInt('audio_on', 1) ~= 0
    AudioManager.Instance.MusicOn = UnityEngine.PlayerPrefs.GetInt('music_on', 1) ~= 0
    for k,v in pairs(self:GetPlayerDatas(function(playerData) return playerData.voiceId == fileid end)) do
        self:GetPlayerViewBySeat(k):SetVoiceFlag(false)
    end
    self.voiceProcess = false;
end

do --不要动
    local function OnPlayerEnter(logic, msg)
        local body = logic.game_pb.RPlayer()
        body:ParseFromString(msg.body)
        logic:RegisterPlayerData(body, true)
    end

    local function OnLordDissolve(logic ,msg)
        -- print("OnLordDissolve --------------------------------------->")
        logic:OnLordDissolve()
    end

    local function OnDissolve(logic,msg)
        local data = logic:GetMesaageData(logic.game_pb.RDissolve(),msg);
        logic:OnDissolve(data);
    end

    local function OnAutoDissolve(logic,msg)
        local body = logic.game_pb.RAutoDissolve();
        body:ParseFromString(msg.body);
        logic:OnAutoDissolve(body);
    end

    local function OnRoomCannotDissolve(logic,msg)
        logic:OnRoomCannotDissolve();
    end

    local function OnRoomDissolveLimit5(logic,msg)
        logic:OnRoomDissolveLimit5();
    end

    local function OnRoomDissolveIn5Seconds(logic,msg)
        logic:OnRoomDissolveIn5Seconds();
    end

    --牌型错误，输入了游戏中不存在的牌型
    local function OnPlayCategoryError(logic,msg )
        -- body
        logic:OnPlayCategoryError();
    end

    --出了不存在的牌（服务器中没有的牌），数据残留
    local function OnPlayOutOfCardsError(logic,msg)
        logic:OnPlayOutOfCardsError();
    end
    
    --打出了比上家要小的牌，这是不正常的
    local function OnPlayCompareError(logic,msg)
        logic:OnPlayCompareError();
    end

    local function OnPlayerJoin(logic, msg)
        local body  = logic.game_pb.RPlayerJoin()
        body:ParseFromString(msg.body)
        local pData     = logic:GetPlayerDataBySeat(body.seat);
        pData.connected = true
        pData.ip        = body.ip;
        pData.ready     = body.ready;
        pData.disconnectTimes = 0
        if body.longitude and body.longitude ~= 0 then
            pData.longitude, pData.latitude	= body.longitude, body.latitude
        else
            pData.longitude, pData.latitude = 0, 0
        end
        if body.address and body.address ~= "" then
            pData.address = body.address
        else
            pData.address = "未获取到该玩家位置"
        end
        logic:OnPlayerJoin(body)
        logic.PlayerJoin(pData)
    end

    local function OnLeaveRoom(logic, msg)
        panelLogin.HideGameNetWaitting();
        NetWorkManager.Instance:DeleteConnect('game');
        logic:OnLeaveRoom()
        logic:PlayerLeave(logic.mySeat)
    end

    local function OnPlayerLeave(logic, msg)
        --兼容以前的麻将协议
        local body = logic.game_pb.RPlayerLeave and logic.game_pb.RPlayerLeave() or logic.game_pb.RSeat();
        body:ParseFromString(msg.body)
        logic:OnPlayerLeave(body.seat)
        logic:PlayerLeave(body.seat)
        logic:RemovePlayerData(body.seat, true)
    end

    local function OnPlayerDisconnected(logic, msg)
        local body = logic.game_pb.RSeat()
        body:ParseFromString(msg.body)
        logic:GetPlayerViewBySeat(body.seat):SetOffineFlag(true, 0)
        logic:OnPlayerDisconnected(body.seat)
        logic.PlayerDisconnected(body.seat)
    end

    local function OnPlayerReady(logic, msg)
        --兼容以前的麻将协议
        local body = logic.game_pb.RReady and logic.game_pb.RReady() or logic.game_pb.RSeat();
        body:ParseFromString(msg.body);
        logic:GetPlayerViewBySeat(body.seat):SetReady(true);
        logic:OnPlayerReady(body.seat);
        logic.PlayerReady(body.seat);
    end

    local function OnRounStart(logic, msg)
        local body = logic.game_pb.RRoundStart()
        -- print("OnRounStart>>>>>>>");

        body:ParseFromString(msg.body)
        logic:RemoveAllPlayerData()
        logic:AutoRegisterPlayerDatas(body.players, true);
        logic:SwitchState(GameLogic.State.Gameing, body)
        logic.RoundStart(body)
    end

    local function OnRoundEnd(logic, msg)
        local body = logic.game_pb.RRoundEnd and logic.game_pb.RRoundEnd() or logic.game_pb.REnd();
        body:ParseFromString(msg.body)
        logic:SwitchState(GameLogic.State.GameEnd, body)
        logic.RoundEnd(body)
    end

    local function OnRoundOver(logic, msg)
        local body = logic:GetMesaageData(logic.game_pb.ROver(), msg)
        logic:SwitchState(GameLogic.State.GameOver, body)
        logic.RoundOver(body)
    end

    local function OnDestroy(logic, msg)
        NetWorkManager.Instance:DeleteConnect('game');
        logic:SwitchState(GameLogic.State.Destroy)
        logic.GameDestroy()
        logic:RemoveAllPlayerView()
        logic:RemoveAllPlayerData()
    end

    local function OnPlayerMagicEmoji(logic, msg)
        local body = logic:GetMesaageData(logic.game_pb.RGift(), msg)
        logic:OnPlayerMagicEmoji(body)
    end

    local function OnPlayChat(logic, msg)
        local data = logic:GetMesaageData(logic.game_pb.RChat(), msg)
        logic:OnPlayChat(data)
    end

    local function OnVoiceMember(logic, msg)
        local data = logic:GetMesaageData(logic.game_pb.RVoiceMember(), msg)
        logic:OnPlayerVoice(data.seat, data.voiceId)
    end

    local function OnPlayerTrustesship(logic, msg)
        local data = logic:GetMesaageData(logic.game_pb.RTrusteeship(), msg)
        --print("OnPlayerTrustesship was called. seat:"..data.seat.."| enable:"..tostring(data.enable));
        logic:GetPlayerDataBySeat(data.seat).trusteeship = data.enable
        logic:GetPlayerViewBySeat(data.seat):SetTrusteeship(data.enable)
        logic:OnPlayerTrustesship(data.seat, data.enable)
        logic.Trusteeship(data.seat, data.enable)
    end

    local function OnPong(logic, msg)
        local connect = NetWorkManager.Instance:FindConnet('game')
        if connect then
            logic.networkLatency = int64.tonum2(Util.GetTime()) - int64.tonum2(connect.LastHeartBeatTime)
        end
    end

    local function OnRoomError(logic,msg)
        logic:OnRoomError()
    end

    local function OnRoomNoExist(logic,msg)
        logic:OnRoomNoExist();
        NetWorkManager.Instance:DeleteConnect('game');
    end

    function GameLogic:RegisterGamepb(game_pb)
        ClearGameCallBack()
        self.game_pb = game_pb;
        RegisterGameCallBack(self.game_pb.PLAYER_ENTER,                 function(msg) OnPlayerEnter(self, msg) end)
        RegisterGameCallBack(self.game_pb.PLAYER_JOIN,                  function(msg) OnPlayerJoin(self, msg) end)
        RegisterGameCallBack(self.game_pb.LEAVE_ROOM,                   function(msg) OnLeaveRoom(self, msg) end)
        RegisterGameCallBack(self.game_pb.PLAYER_LEAVE,                 function(msg) OnPlayerLeave(self, msg) end)
        RegisterGameCallBack(self.game_pb.DISCONNECTED,                 function(msg) OnPlayerDisconnected(self, msg) end)
        RegisterGameCallBack(self.game_pb.READY,                        function(msg) OnPlayerReady(self, msg) end)
        RegisterGameCallBack(self.game_pb.ROUND_START,                  function(msg) OnRounStart(self, msg) end)
        RegisterGameCallBack(self.game_pb.ROUND_END,                    function(msg) OnRoundEnd(self, msg) end)
        RegisterGameCallBack(self.game_pb.GAME_OVER,                    function(msg) OnRoundOver(self, msg) end)
        RegisterGameCallBack(self.game_pb.SEND_CHAT,                    function(msg) OnPlayChat(self, msg) end)
        RegisterGameCallBack(self.game_pb.GIFT,                         function(msg) OnPlayerMagicEmoji(self, msg) end)
        RegisterGameCallBack(self.game_pb.DESTROY,                      function(msg) OnDestroy(self, msg) end)
        RegisterGameCallBack(self.game_pb.VOICE_MEMBER,                 function(msg) OnVoiceMember(self, msg) end)
        RegisterGameCallBack(self.game_pb.TRUSTEESHIP,                  function(msg) OnPlayerTrustesship(self, msg) end)
        RegisterGameCallBack(self.game_pb.PONG,                         function(msg) OnPong(self, msg) end)
        RegisterGameCallBack(self.game_pb.DISSOLVE,                     function(msg) OnDissolve(self, msg) end)
        RegisterGameCallBack(self.game_pb.LORD_DISSOLVE,                function(msg) OnLordDissolve(self, msg) end)
        RegisterGameCallBack(self.game_pb.AUTO_DISSOLVE,                function(msg) OnAutoDissolve(self, msg) end)
        RegisterGameCallBack(self.game_pb.DISSOLVE_UNABLE_ERROR,        function(msg) OnRoomCannotDissolve(self, msg) end)
        RegisterGameCallBack(self.game_pb.DISSOLVE_LIMIT_TIMES_ERROR,   function(msg) OnRoomDissolveLimit5(self, msg) end)
        RegisterGameCallBack(self.game_pb.DISSOLVE_LIMIT_SECONDS_ERROR, function(msg) OnRoomDissolveIn5Seconds(self, msg) end)
        RegisterGameCallBack(self.game_pb.OVERTIME_DISSOLVE,            function(msg) OnRoomDissolveIn5Seconds(self, msg) end)
        RegisterGameCallBack(self.game_pb.PLAY_CATEGORY_ERROR,          function(msg) OnPlayCategoryError(self, msg) end)
        RegisterGameCallBack(self.game_pb.PLAY_OUT_OF_CARDS_ERROR,      function(msg) OnPlayOutOfCardsError(self, msg) end)
        RegisterGameCallBack(self.game_pb.PLAY_COMPARE_ERROR,           function(msg) OnPlayCompareError(self, msg) end)
        RegisterGameCallBack(self.game_pb.ENTER_ERROR,                  function(msg) OnRoomError(self, msg) end)
	    RegisterGameCallBack(self.game_pb.NO_ROOM, 						function(msg) OnRoomNoExist(self, msg) end)
    end

    function GameLogic:RegisterGameCallBack()
    end
end