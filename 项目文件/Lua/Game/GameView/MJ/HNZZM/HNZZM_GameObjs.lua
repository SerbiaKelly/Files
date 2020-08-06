
HNZZM_GameObjs = {};
local this = HNZZM_GameObjs;

HNZZM_GameObjs.gameObject = nil;
HNZZM_GameObjs.roomRound = nil;
HNZZM_GameObjs.roomID = nil;
HNZZM_GameObjs.waitRoomID = nil;
HNZZM_GameObjs.roomTime = nil;
HNZZM_GameObjs.batteryLevel = nil;
HNZZM_GameObjs.network = nil;
HNZZM_GameObjs.pingLabel = nil;
HNZZM_GameObjs.roomSetting = nil;
HNZZM_GameObjs.line = nil;
HNZZM_GameObjs.operation_send = nil;
HNZZM_GameObjs.dipai = nil;
HNZZM_GameObjs.curOperatPlateEffect = nil;
HNZZM_GameObjs.DelegatePanel = nil;
HNZZM_GameObjs.RestTime = nil;
HNZZM_GameObjs.DelegateTime = nil;
HNZZM_GameObjs.GpsView = nil;
HNZZM_GameObjs.gameTypeobj = nil;
HNZZM_GameObjs.kaiBao = nil;
HNZZM_GameObjs.playerViews = {};
HNZZM_GameObjs.distances = {};
HNZZM_GameObjs.gpsPlayers = {};

HNZZM_GameObjs.ButtonSetting = nil;
HNZZM_GameObjs.ButtonChat = nil;
HNZZM_GameObjs.ButtonSound = nil;
HNZZM_GameObjs.ButtonInvite = nil;
HNZZM_GameObjs.ButtonCloseRoom = nil;
HNZZM_GameObjs.ButtonExitRoom = nil;
HNZZM_GameObjs.ButtonNext = nil;
HNZZM_GameObjs.ButtonReady = nil;

HNZZM_GameObjs.ButtonHu = nil;
HNZZM_GameObjs.ButtonGang = nil;
HNZZM_GameObjs.ButtonPeng = nil;
HNZZM_GameObjs.ButtonChi = nil;
HNZZM_GameObjs.ButtonGuo = nil;
HNZZM_GameObjs.ButtonBu = nil;
HNZZM_GameObjs.ButtonGPS = nil;
HNZZM_GameObjs.ButtonRule = nil;--玩法按钮
HNZZM_GameObjs.ButtonMore = nil;--更多按钮
HNZZM_GameObjs.playerTingButton = nil;--玩家的听牌按钮
HNZZM_GameObjs.newTingOperation = nil;--玩家新的听牌界面

HNZZM_GameObjs.ButtonRefresh = nil;--刷新游戏
HNZZM_GameObjs.effectGang = nil;
HNZZM_GameObjs.RecordTiShi = nil;
HNZZM_GameObjs.TingItemPrefab = nil;
HNZZM_GameObjs.panelShare = nil;
HNZZM_GameObjs.waitopTip = nil;
HNZZM_GameObjs.operation_mask = nil;
HNZZM_GameObjs.runScoreOperation = nil;
HNZZM_GameObjs.hunPanel = nil;

--托管的UI
HNZZM_GameObjs.TrusteeShipTip = nil;--托管倒计时
HNZZM_GameObjs.TrusteeShipPanel = nil;--托管界面
HNZZM_GameObjs.TrusteeShipCancelButton = nil;--托管取消按钮

HNZZM_GameObjs.playerOperationEffectPos = {};
HNZZM_GameObjs.playerMoPaiPos = {};--摸牌位置
HNZZM_GameObjs.playerHandGridPos = {};--每个玩家手牌grid的原始位置信息
HNZZM_GameObjs.playerTableThrowGridPos = {};--牌桌上的牌的grid的初始位置
HNZZM_GameObjs.playerHupaiPos = {};--播放玩家操作特效的位置，（吃碰杠补胡牌等等）
HNZZM_GameObjs.effectCategories = {};----特效位置
HNZZM_GameObjs.ActivePlayerESWN = {};--东南西北的UI对象
HNZZM_GameObjs.playerChuPaiShows = {};--玩家出牌的展示


--如果是存储为table类型的，应该使用这个lua文件的时候要清除一次该对象
function this.CleanObjs()
    -- body
    HNZZM_GameObjs.playerViews               = {};
    HNZZM_GameObjs.distances                 = {};
    HNZZM_GameObjs.gpsPlayers                = {};
    HNZZM_GameObjs.effectCategories          = {};----特效位置
    HNZZM_GameObjs.ActivePlayerESWN          = {};--东南西北的UI对象
    HNZZM_GameObjs.playerChuPaiShows         = {};--玩家出牌的展示
    --TODO 为什么位置相关的不清除，是因为现在的麻将位置都是通用的位置，如果要修改，那么在每个麻将的预制体上新建一个空对象，把初始位置放到那里，在每次游戏开始的时候在读取

end


return HNZZM_GameObjs;