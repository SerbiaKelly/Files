require("HNHSM_RePlayLogic");
local hnm_pb            = require("hnm_pb");
local proxy_pb          = require("proxy_pb")
panelReplay_hnhsm       = {};
local this              = panelReplay_hnhsm;
local RePlayLogic       = nil;
local message           = nil;
local gameObject        = nil;
local whoShowData       = nil;

function this.Awake( go )
    -- body
    print("panelReplay_hnhsm.Awake was called");
    gameObject = go;
    message = gameObject.transform:GetComponent('LuaBehaviour');
    

end

function this.Start( go )
    -- body
end

function this.WhoShow( data )
    -- body
    panelLogin.HideNetWaitting();
    whoShowData = data;
    if not data.isNeedRequest then 
        return ;
    end

    local msg   = Message.New()
	local b     = proxy_pb.PRoundRecords()
	b.roomId    = replayData.roomId;
	b.round     = replayData.round;
	b.gameType  = proxy_pb.HNM;
    msg.type    = proxy_pb.ROUND_RECORDS;
    msg.body    = b:SerializeToString()
    RePlayLogic = HNHSM_RePlayLogic.New(panelReplay_hnhsm,hnm_pb,proxy_pb.HNM,gameObject);
    ClearGameCallBack();--不是在游戏中,清除掉消息接收协议
    print("请求战绩详情"..replayData.roomId, replayData.round)
    SendProxyMessage(msg, this.OnGetRoundDetail);
    local bgColor = UnityEngine.PlayerPrefs.GetInt('bgColor_hnhsm', 1);
    RePlayLogic:GetUILayer():ChooseBG(bgColor);
    PanelManager.Instance:HideWindow('panelRecordDetail');
	PanelManager.Instance:HideWindow('panelRecord');
	PanelManager.Instance:HideWindow('panelLobby');
    PanelManager.Instance:HideWindow('panelClub');

end

function this.OnEnable( go )
    -- body
    AudioManager.Instance:PlayMusic('nmmj_BGM', true);
end

function this.OnApplicationFocus()
    
end

function this.OnApplicationFocus( go )
    -- body
end

function this.Update( go )
    -- body
end


function this.OnGetRoundDetail(msg)
    print('OnGetRoundDetail');
    local RoundDetail = hnm_pb.RRoundRecords();
    RoundDetail:ParseFromString(msg.body);
    local roomData = this.InitRoomData(RoundDetail);
    RePlayLogic:OnJoinRoom(roomData);
    print("OnGetRoundDetail RePlayLogic==nil"..tostring(RePlayLogic == nil));
    -- print_r(RePlayLogic);
    print("table.RePlayLogic="..tostring(RePlayLogic));
   
end

function this.InitRoomData(RoundDetail)
    local roomData          = {};
    roomData.setting        = RoundDetail.setting;
    roomData.round          = replayData.round;
    roomData.bankerSeat     = RoundDetail.bankerSeat;
    roomData.diss           = RoundDetail.diss;
    roomData.surplus        = 108;
    roomData.state          = hnm_pb.GAMING;
    roomData.version        = RoundDetail.version;
    roomData.roundEnd       = RoundDetail.roundEnd;
    roomData.openUserCard   = RoundDetail.openUserCard;
    roomData.isLord         = RoundDetail.isLord;
    roomData.players        = this.GetInitPlayerDatas(RoundDetail.players);
    roomData.records        = RoundDetail.records;
    roomData.mySeat         = this.GetMySeat(roomData.players);
    roomData.backWinName    = whoShowData.name;
    roomData.activeSeat     = 0;
    roomData.roomNumber     = replayData.roomNumber;
    return roomData;
end


function this.GetInitPlayerDatas(originPlayerDatas)
    local playerData = {};
    for i=1,#originPlayerDatas do
        table.insert( playerData, this.Get_A_InitPlayer(originPlayerDatas[i]));
    end
    return playerData;
end

function this.Get_A_InitPlayer(p)
	local player            = {}
	player.seat             = p.seat
	player.name             = p.name
	player.icon             = p.icon
	player.sex              = p.sex
	player.id               = p.id
	player.mahjongs         = {}
	player.ip               = p.ip
	player.fee              = p.fee
	player.chi              = {}
	player.peng             = {}
	player.mingGang         = {}
	player.dianGang         = {}
	player.anGang           = {}
	player.mahjongCount     = 0
    player.paiHe            = {}
    player.moMahjong        = -1;
    player.connected        = true;
    player.operationCards   = {};
    player.score            = 0;
    player.yuScore          = 0;
	return player;
end

function this.GetMySeat(players)
    local mySeat = nil;
    for i=1, #players do
		local player = {};
        local p = players[i];
		p.sex = p.sex == 0 and 1 or p.sex
		if p.id == info_login.id then
            mySeat = p.seat;
            break;
		end
	end
	if whoShowData.isSelectSeat then
		mySeat = whoShowData.mySeat;
    end
    return mySeat;
end



