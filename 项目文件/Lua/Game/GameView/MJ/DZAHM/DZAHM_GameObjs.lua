
DZAHM_GameObjs = {};
local this = DZAHM_GameObjs;

DZAHM_GameObjs.gameObject = nil;
DZAHM_GameObjs.roomRound = nil;
DZAHM_GameObjs.roomID = nil;
DZAHM_GameObjs.waitRoomID = nil;
DZAHM_GameObjs.roomTime = nil;
DZAHM_GameObjs.batteryLevel = nil;
DZAHM_GameObjs.network = nil;
DZAHM_GameObjs.pingLabel = nil;
DZAHM_GameObjs.roomSetting = nil;
DZAHM_GameObjs.line = nil;
DZAHM_GameObjs.operation_send = nil;
DZAHM_GameObjs.dipai = nil;
DZAHM_GameObjs.curOperatPlateEffect = nil;
DZAHM_GameObjs.DelegatePanel = nil;
DZAHM_GameObjs.RestTime = nil;
DZAHM_GameObjs.DelegateTime = nil;
DZAHM_GameObjs.GpsView = nil;
DZAHM_GameObjs.gameTypeobj = nil;
DZAHM_GameObjs.kaiBao = nil;
DZAHM_GameObjs.playerViews = {};
DZAHM_GameObjs.distances = {};
DZAHM_GameObjs.gpsPlayers = {};

DZAHM_GameObjs.ButtonSetting = nil;
DZAHM_GameObjs.ButtonChat = nil;
DZAHM_GameObjs.ButtonSound = nil;
DZAHM_GameObjs.ButtonInvite = nil;
DZAHM_GameObjs.ButtonCloseRoom = nil;
DZAHM_GameObjs.ButtonExitRoom = nil;
DZAHM_GameObjs.ButtonNext = nil;
DZAHM_GameObjs.ButtonReady = nil;

DZAHM_GameObjs.ButtonHu = nil;
DZAHM_GameObjs.ButtonGang = nil;
DZAHM_GameObjs.ButtonPeng = nil;
DZAHM_GameObjs.ButtonChi = nil;
DZAHM_GameObjs.ButtonGuo = nil;
DZAHM_GameObjs.ButtonBu = nil;
DZAHM_GameObjs.ButtonGPS = nil;
DZAHM_GameObjs.ButtonRule = nil;--玩法按钮
DZAHM_GameObjs.ButtonMore = nil;--更多按钮
DZAHM_GameObjs.playerTingButton = nil;--玩家的听牌按钮
DZAHM_GameObjs.newTingOperation = nil;--玩家新的听牌界面
DZAHM_GameObjs.lessPlayerStartView = nil;--少人模式
DZAHM_GameObjs.lessPlayerStartToggle = nil;

DZAHM_GameObjs.ButtonRefresh = nil;--刷新游戏
DZAHM_GameObjs.effectGang = nil;
DZAHM_GameObjs.RecordTiShi = nil;
DZAHM_GameObjs.TingItemPrefab = nil;
DZAHM_GameObjs.panelShare = nil;
DZAHM_GameObjs.waitopTip = nil;
DZAHM_GameObjs.operation_mask = nil;
DZAHM_GameObjs.runScoreOperation = nil;
DZAHM_GameObjs.hunPanel = nil;

--托管的UI
DZAHM_GameObjs.TrusteeShipTip = nil;--托管倒计时
DZAHM_GameObjs.TrusteeShipPanel = nil;--托管界面
DZAHM_GameObjs.TrusteeShipCancelButton = nil;--托管取消按钮

DZAHM_GameObjs.playerOperationEffectPos = {};
DZAHM_GameObjs.playerMoPaiPos = {};--摸牌位置
DZAHM_GameObjs.playerHandGridPos = {};--每个玩家手牌grid的原始位置信息
DZAHM_GameObjs.playerTableThrowGridPos = {};--牌桌上的牌的grid的初始位置
DZAHM_GameObjs.playerHupaiPos = {};--播放玩家操作特效的位置，（吃碰杠补胡牌等等）
DZAHM_GameObjs.effectCategories = {};----特效位置
DZAHM_GameObjs.ActivePlayerESWN = {};--东南西北的UI对象
DZAHM_GameObjs.playerChuPaiShows = {};--玩家出牌的展示


--如果是存储为table类型的，应该使用这个lua文件的时候要清除一次该对象
function this.CleanObjs()
    -- body
    DZAHM_GameObjs.playerViews               = {};
    DZAHM_GameObjs.distances                 = {};
    DZAHM_GameObjs.gpsPlayers                = {};
    DZAHM_GameObjs.effectCategories          = {};----特效位置
    DZAHM_GameObjs.ActivePlayerESWN          = {};--东南西北的UI对象
    DZAHM_GameObjs.playerChuPaiShows         = {};--玩家出牌的展示
    --TODO 为什么位置相关的不清除，是因为现在的麻将位置都是通用的位置，如果要修改，那么在每个麻将的预制体上新建一个空对象，把初始位置放到那里，在每次游戏开始的时候在读取

end


return DZAHM_GameObjs;