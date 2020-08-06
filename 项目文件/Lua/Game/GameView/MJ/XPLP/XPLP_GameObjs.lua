
XPLP_GameObjs = {};
local this = XPLP_GameObjs;

XPLP_GameObjs.gameObject = nil;
XPLP_GameObjs.roomRound = nil;
XPLP_GameObjs.roomID = nil;
XPLP_GameObjs.waitRoomID = nil;
XPLP_GameObjs.roomTime = nil;
XPLP_GameObjs.batteryLevel = nil;
XPLP_GameObjs.network = nil;
XPLP_GameObjs.pingLabel = nil;
XPLP_GameObjs.roomSetting = nil;
XPLP_GameObjs.line = nil;
XPLP_GameObjs.operation_send = nil;
XPLP_GameObjs.dipai = nil;
XPLP_GameObjs.curOperatPlateEffect = nil;
XPLP_GameObjs.DelegatePanel = nil;
XPLP_GameObjs.RestTime = nil;
XPLP_GameObjs.DelegateTime = nil;
XPLP_GameObjs.GpsView = nil;
XPLP_GameObjs.gameTypeobj = nil;
XPLP_GameObjs.kaiBao = nil;
XPLP_GameObjs.playerViews = {};
XPLP_GameObjs.distances = {};
XPLP_GameObjs.gpsPlayers = {};

XPLP_GameObjs.ButtonSetting = nil;
XPLP_GameObjs.ButtonChat = nil;
XPLP_GameObjs.ButtonSound = nil;
XPLP_GameObjs.ButtonInvite = nil;
XPLP_GameObjs.ButtonCloseRoom = nil;
XPLP_GameObjs.ButtonExitRoom = nil;
XPLP_GameObjs.ButtonNext = nil;
XPLP_GameObjs.ButtonReady = nil;
XPLP_GameObjs.ButtonPlatesRecord = nil;--出牌统计按钮
XPLP_GameObjs.ButtonHu = nil;
XPLP_GameObjs.ButtonGang = nil;
XPLP_GameObjs.ButtonPeng = nil;
XPLP_GameObjs.ButtonChi = nil;
XPLP_GameObjs.ButtonGuo = nil;
XPLP_GameObjs.ButtonBu = nil;
XPLP_GameObjs.ButtonGPS = nil;
XPLP_GameObjs.ButtonRule = nil;--玩法按钮
XPLP_GameObjs.ButtonMore = nil;--更多按钮
XPLP_GameObjs.playerTingButton = nil;--玩家的听牌按钮
XPLP_GameObjs.newTingOperation = nil;--玩家新的听牌界面

XPLP_GameObjs.ButtonRefresh = nil;--刷新游戏
XPLP_GameObjs.RecordTiShi = nil;
XPLP_GameObjs.TingItemPrefab = nil;
XPLP_GameObjs.panelShare = nil;
XPLP_GameObjs.waitopTip = nil;
XPLP_GameObjs.operation_mask = nil;
XPLP_GameObjs.chongOperation = nil;--冲分界面
XPLP_GameObjs.guChouButtons = nil;--箍臭界面
XPLP_GameObjs.guchouTip = nil;--箍臭提示
XPLP_GameObjs.ButtonGuChou = nil;--箍臭
XPLP_GameObjs.ButtonNoGuChou = nil --不箍臭
--托管的UI
XPLP_GameObjs.TrusteeShipTip = nil;--托管倒计时
XPLP_GameObjs.TrusteeShipPanel = nil;--托管界面
XPLP_GameObjs.TrusteeShipCancelButton = nil;--托管取消按钮

XPLP_GameObjs.playerOperationEffectPos = {};--出牌特效位置
XPLP_GameObjs.playerTableThrowGridPos = {};--出牌grid的位置
XPLP_GameObjs.ActivePlayerESWN = {};--东南西北的UI对象
XPLP_GameObjs.playerChuPaiPos = {};--玩家出牌的位置
XPLP_GameObjs.playerGridHandPos = {};--玩家手牌的初始位置
XPLP_GameObjs.playerRePlayTableThrowGridPos   = {};--回放出牌grid的位置


--如果是存储为table类型的，应该使用这个lua文件的时候要清除一次该对象
function this.CleanObjs()
    -- body
    XPLP_GameObjs.playerViews               = {};
    XPLP_GameObjs.distances                 = {};
    XPLP_GameObjs.gpsPlayers                = {};
    XPLP_GameObjs.ActivePlayerESWN          = {};--东南西北的UI对象
    XPLP_GameObjs.playerChuPaiPos           = {};
    XPLP_GameObjs.playerGridHandPos         = {};
    

end


return XPLP_GameObjs;