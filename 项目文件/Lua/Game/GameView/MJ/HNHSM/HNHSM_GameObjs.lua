
HNHSM_GameObjs = {};
local this = HNHSM_GameObjs;

HNHSM_GameObjs.gameObject = nil;
HNHSM_GameObjs.roomRound = nil;
HNHSM_GameObjs.roomID = nil;
HNHSM_GameObjs.waitRoomID = nil;
HNHSM_GameObjs.roomTime = nil;
HNHSM_GameObjs.batteryLevel = nil;
HNHSM_GameObjs.network = nil;
HNHSM_GameObjs.pingLabel = nil;
HNHSM_GameObjs.roomSetting = nil;
HNHSM_GameObjs.line = nil;
HNHSM_GameObjs.operation_send = nil;
HNHSM_GameObjs.dipai = nil;
HNHSM_GameObjs.curOperatPlateEffect = nil;
HNHSM_GameObjs.DelegatePanel = nil;
HNHSM_GameObjs.RestTime = nil;
HNHSM_GameObjs.DelegateTime = nil;
HNHSM_GameObjs.GpsView = nil;
HNHSM_GameObjs.gameTypeobj = nil;
HNHSM_GameObjs.kaiBao = nil;
HNHSM_GameObjs.playerViews = {};
HNHSM_GameObjs.distances = {};
HNHSM_GameObjs.gpsPlayers = {};

HNHSM_GameObjs.ButtonSetting = nil;
HNHSM_GameObjs.ButtonChat = nil;
HNHSM_GameObjs.ButtonSound = nil;
HNHSM_GameObjs.ButtonInvite = nil;
HNHSM_GameObjs.ButtonCloseRoom = nil;
HNHSM_GameObjs.ButtonExitRoom = nil;
HNHSM_GameObjs.ButtonNext = nil;
HNHSM_GameObjs.ButtonReady = nil;

HNHSM_GameObjs.ButtonHu = nil;
HNHSM_GameObjs.ButtonGang = nil;
HNHSM_GameObjs.ButtonPeng = nil;
HNHSM_GameObjs.ButtonChi = nil;
HNHSM_GameObjs.ButtonGuo = nil;
HNHSM_GameObjs.ButtonBu = nil;
HNHSM_GameObjs.ButtonGPS = nil;
HNHSM_GameObjs.ButtonRule = nil;--玩法按钮
HNHSM_GameObjs.ButtonMore = nil;--更多按钮
HNHSM_GameObjs.playerTingButton = nil;--玩家的听牌按钮
HNHSM_GameObjs.newTingOperation = nil;--玩家新的听牌界面

HNHSM_GameObjs.ButtonRefresh = nil;--刷新游戏
HNHSM_GameObjs.effectGang = nil;
HNHSM_GameObjs.RecordTiShi = nil;
HNHSM_GameObjs.TingItemPrefab = nil;
HNHSM_GameObjs.panelShare = nil;
HNHSM_GameObjs.waitopTip = nil;
HNHSM_GameObjs.operation_mask = nil;

--托管的UI
HNHSM_GameObjs.TrusteeShipTip = nil;--托管倒计时
HNHSM_GameObjs.TrusteeShipPanel = nil;--托管界面
HNHSM_GameObjs.TrusteeShipCancelButton = nil;--托管取消按钮

HNHSM_GameObjs.playerOperationEffectPos = {};
HNHSM_GameObjs.playerMoPaiPos = {};--摸牌位置
HNHSM_GameObjs.playerHandGridPos = {};--每个玩家手牌grid的原始位置信息
HNHSM_GameObjs.playerTableThrowGridPos = {};--牌桌上的牌的grid的初始位置
HNHSM_GameObjs.playerHupaiPos = {};--播放玩家操作特效的位置，（吃碰杠补胡牌等等）
HNHSM_GameObjs.effectCategories = {};----特效位置
HNHSM_GameObjs.ActivePlayerESWN = {};--东南西北的UI对象
HNHSM_GameObjs.playerChuPaiShows = {};--玩家出牌的展示


--如果是存储为table类型的，应该使用这个lua文件的时候要清除一次该对象
function this.CleanObjs()
    -- body
    HNHSM_GameObjs.playerViews               = {};
    HNHSM_GameObjs.distances                 = {};
    HNHSM_GameObjs.gpsPlayers                = {};
    HNHSM_GameObjs.effectCategories          = {};----特效位置
    HNHSM_GameObjs.ActivePlayerESWN          = {};--东南西北的UI对象
    HNHSM_GameObjs.playerChuPaiShows         = {};--玩家出牌的展示
    --TODO 为什么位置相关的不清除，是因为现在的麻将位置都是通用的位置，如果要修改，那么在每个麻将的预制体上新建一个空对象，把初始位置放到那里，在每次游戏开始的时候在读取

end


return HNHSM_GameObjs;