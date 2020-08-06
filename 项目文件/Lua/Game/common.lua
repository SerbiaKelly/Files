local protocol_pb = require 'protocol_pb'
local json = require 'json'
require 'panelMessageBox'
require 'panelMessageBoxTiShi'
require 'panelMessageTip'
require "pdk_pb"
require "proxy_pb"
require "Game.bitlogic"
require 'const'

local proxyCallback = {}
local onProxyReceive = nil
local gameCallback = {}

local pcallLocationFun, err = pcall(function() PlatformManager.Instance:HasLocationPermissions() end)

PLAYER_SESSION_ID = 'PLAYER_SESSION_ID'
PLAYER_NOT_SHIELD_VOICE = 'playerSound'
PLAYER_UUID = 'PLAYER_UUID'

--Header.status，状态值
local SUCCESS = 0;        -- 成功
local ERROR = 1;          -- 任何未知错误
local UNAVAILABLE = 2;    -- 由于服务器维护或者过载，无法处理请求
local UNAUTHORIZED = 3;   -- 当前请求需要用户验证
local LOCKED = 4;         -- 当前请求所需要的数据被锁定（一种可能是GM正在修改数据）
local REQUEST_REJECT = 5; -- 请求被拒绝，暂时由于请求速度过快
local LESS_DIAMOND = 6;   -- 创建房间时，钻石不足
local IN_ROOM = 7;        -- 玩家已在房间中
local ROOM_NOT_EXISTED = 8;   -- 房间不存在
local ROOM_FULL = 9;      -- 房间已满
local USER_NOT_EXISTED = 10;  -- 玩家不存在
local USER_INVITED = 11;  -- 玩家已经完成邀请
local INVITATION_CODE_ERROR = 12; -- 邀请码错误（即，该ID对应的玩家不存在）
local IAP_VALIDATE_ERROR = 13; --苹果In-App验证错误
local BANNED = 14;        -- 被禁止登录（如被放入黑名单）
local INVITATION_BINDING_ERROR = 15; -- 不能绑定下级的邀请码（不能绑定下级和下下级的邀请码）
local CLUB_NOT_EXISTED = 16;     -- 牌友群不存在
local CLUB_USER_EXISTED = 17;     -- 玩家已存在某个牌友群
local LORD_LESS_DIAMOND = 18;     -- 玩家在牌友群创建房间时，群主的钻石不足
local CLUB_ROOM_FULL = 19;     -- 牌友群可创建的牌桌已满
local USER_HAVE_PHONE = 20;     -- 玩家已经绑定过手机号码
local PHONE_EXISTED = 21;         -- 该手机号码已存在（已被其他玩家绑定）
local OBTAIN_SMS_COUNT_EXCEED = 22;     -- 获取短信验证码的次数超额
local USER_NOT_IN_CLUB = 23;     -- 玩家不在牌友群中（不能加入牌友群中的牌桌)
local SEAT_HAVE_SEIZE = 24;      --位置已被其他玩家占领
local NOT_AGENT_CODE = 25;       --非代理邀请码（只能绑定代理的邀请码）
local CREATE_CLUB_LESS_DIAMONDS = 26;      --创建牌友群玩家钻石不足（最低100个）
local CLUB_PLAY_ID_IS_NULL = 27;      --创建牌友群房间时，玩法id为空
local CLUB_PLAY_FULL = 28;        --单个牌友群的玩法已满，已达20个
local CLUB_USER_FULL = 29;        --单个牌友群的玩家已满，已达200个
local CLUB_ROOM_IS_PAUSE = 30;    --牌友群已暂停开房
local SMS_VERIFY_CODE_ERROR = 31;    --短信验证码错误
local HAVE_MUTEX_PLAYER = 32;     --房间里有互斥的玩家，不允许加入
local WECHAT_ALREADY_EXISTS = 33;     --微信号已被其他玩家绑定
local UPLOAD_USER_PHOTO_FAIL = 34;     -- 上传用户风采照失败
local BLACK_PLAYER_EXISTED = 35;       --  玩家已存在小黑屋，不用重复添加
local BLACK_PLAYER_CANNOT_PLAY = 36;    --玩家在俱乐部小黑屋中，不能在俱乐部中玩游戏
local NO_PERMISSION = 37;             --当前没有权限执行当前的操作
local RULE_HAVE_ROOM = 38;            --当前规则有开了房间，不能删除该规则
local FEE_BALANCE_NOT_ENOUGH = 39;    --当前疲劳值余额不足
local SYSTEM_MAINTENANCE_ENABLED = 40 --系统维护已启动，当前禁止开房操作
local UNABLE_DISSOLVE = 41 --该俱乐部不能申请解散房间
local PLAYER_AUTO_BLACK_HOUSE = 42 --玩家被系统自动拉入小黑屋
local VP_UNDER_ROOM_MIN_VALUE = 43; -- 疲劳值低于加入房间所需的最低值
local OPERATION_REPEATED = 44; --不可重复操作
local USER_NOW_IN_ROOM = 45; --玩家正在游戏房间中，不可进行疲劳值扣除操作
local AMOUNT_OUT_OF_RANGE = 46; --数额超出范围
local VP_NOT_ZERO_UNABLE_QUIT_CLUB = 47; --玩家疲劳值不为0，不能退出俱乐部
local MEMBERS_HAS_VP_UNABLE_QUIT_CLUB = 48; --管理员有成员的疲劳值不为0，不能退出俱乐部
local CLUB_PLAY_NON_EXISTENT = 49; --玩法不存在
local MANAGER_HAVE_PERCENT_VP = 50  --管理员分配了大赢家百分比，不允许再分配疲劳值
local MANAGER_HAVE_ASSIGN_VP = 51 --管理员分配了疲劳值，不允许再分配大赢家疲劳值百分比
local ASSIGN_VP_VALUE_NO_VALID = 52 --分配的疲劳值不合法（大小不合规则）
local BIG_WINNER_VP_NO_VALID = 53 --有玩家分配的疲劳值大于当前群主设置的大赢家疲劳值
local NOTHING_CHANGED = 54 --无数据改动
local DISSOLVE_TIMES_LACK = 55 -- 群主已设置最多申请解散5次，如有疑问请联系群主
local CLUB_PLAY_RULE_FULL = 56 -- 单个玩法的规则已满，已达10个
local QUIT_CLUB_NOT_ALLOWED = 57 -- 群主已禁止群成员退出牌友群，如有疑问请联系群主
local LOGIN_PWD_ERROR = 58 -- 登录密码错误
local PHONE_NOT_BIND = 59 -- 手机号码未绑定，请先使用微信登录绑定
local PHONE_FORMAT_ERROR = 60 -- 请输入正确的手机号码
local PASSWORD_FORMAT_ERROR = 61 -- 请输入8-20位的数字和字母组合
local TRANSFER_HAS_USER_GAMING = 62 --转让时有玩家正在游戏中，不能转入
local LINK_SYS_MANAGER = 63;                  -- 请联系系统管理员
local RECEIVE_CLUB_LORD_NOT_AGENT = 64;       -- 转入的俱乐部群主未开通代理，不能转入
local RECEIVE_CLUB_NOT_GAME_MODE = 65;        -- 转入的俱乐部未开启比赛场模式，不能转入
local RECEIVE_CLUB_HAVE_USER = 66;            -- 转入的俱乐部已有成员，不能转入
local RECEIVE_CLUB_HAVE_PLAY = 67;            -- 转入的俱乐部已有玩法，不能转入
local RECEIVE_CLUB_LORD_HAVE_FEE = 68;        -- 转入的俱乐部群主已有疲劳值，不能转入
local RECEIVE_LORD_IS_ORIGIN_MEMBER = 69;     -- 转入的俱乐部群主是当前转让群的成员，不能转入
local USER_IS_LOCK = 70;     -- 用户已锁定
local CLUB_USER_IN_AUDIT = 72 -- 你已申请该牌友群，请勿重复申请
local CLUB_USER_NOT_ACCESS_RANK = 73;   --不能访问排行榜
local CLUB_USER_IN_BLACK_HOUSE = 74;   --俱乐部用户因 达到群主所设置的赢家负疲劳值次数,无法增减或者减少疲劳值,请先移除小黑屋
local CLUB_USER_LOSS_FEE_ERROR = 75;			--负疲劳值设置参数异常
local MY_INFO_GIVE_BLANK = 76;				--MY_INFO_GIVE 赠送直接上级疲劳值: 传值为空
local MY_INFO_GIVE_NUMBER = 77;				--MY_INFO_GIVE 赠送直接上级疲劳值: 非法数值
local MY_INFO_GIVE_LORD = 78;				--MY_INFO_GIVE 赠送直接上级疲劳值: 群主无赠送功能
local MY_INFO_GIVE_START_MODE = 79;			--MY_INFO_GIVE 赠送直接上级疲劳值: 未开启比赛场模式
local MY_INFO_GIVE_NOT_CLUB = 80;			--MY_INFO_GIVE 赠送直接上级疲劳值: 俱乐部用户不存在
local MY_INFO_GIVE_BLACK_HOUSE=81;			--MY_INFO_GIVE 赠送直接上级疲劳值: 您可能已经违反了群主设置，已被系统自动拉入小黑屋，不可操作疲劳值
local ENTER_ERROR_IP_CHECK_FAILED = 87;		--进入房间失败，未通过IP检查（房间有其他玩家ip和当前玩家ip一致）
local ENTER_ERROR_GPS_CHECK_FAILED = 88;	--进入房间失败，未通过GPS的检查（玩家未开启GPS）
local PASSWORD_ARE_INCONSISTENT = 89		--注册时密码不一致
local CANNOT_CREATE_MANY_ACCOUNT = 90		--不能创建多个账号

local ROOM_ROUND_PLAYBACK_BLANK = 10400;   --输入的回放码为空
local ROOM_ROUND_PLAYBACK_MIN_LENGTH = 10401;  --输入的回放码不符合最小长度
local ROOM_ROUND_PLAYBACK_NOT_FOUND = 10402;  --找不到对局记录
local ENTER_ROOM_IP_ACCESS_PERMISSION = 800;		--进入房间,该房间开启了IP检测,当前IP不可用
local JOIN_CLUB_NOT_APPLY_CLUB = 3000;			--群主关闭了申请加入俱乐部
local CLUB_USER_MANAGE_DELETE_CLOSE = 3400;		--群主已禁止删除成员，如有疑问请联系群主
local ADD_MUTEX_USERS_EXISTS = 5700;			--添加俱乐部互斥玩家,玩家已经存在
local MY_INFO_ALERT_ERROR = 12700;         --非法参数
local MY_INFO_ALERT_PERMISSION = 12702;    --非法操作
local MY_INFO_RELIEVE_ERROR = 12800;              --非法参数
local MY_INFO_RELIEVE_PERMISSION = 12801;         --非法操作
local MY_INFO_UPDATE_ALERT_ERROR = 12900;         --非法参数
local MY_INFO_UPDATE_ALERT_PERMISSION = 12901;    --非法操作
local CREATE_ROOM_ALERT_SELF_FREEZE = 700;             --创建房间失败,自己已经进入暂停
local CREATE_ROOM_ALERT_SUPER_FREEZE = 701;            --创建房间失败,上级管家已进入暂停
local ENTER_ROOM_ALERT_SELF_FREEZE = 800;              --进入房间失败,自己已经进入暂停
local ENTER_ROOM_ALERT_SUPER_FREEZE = 801;             --进入房间失败,上级管家已经进入暂停
local MY_INFO_GIVE_SUPER_FORBID = 12600;             --赠送疲劳值失败,上级已被限制疲劳值操作
local MY_INFO_GIVE_SUPER_FREEZE = 12601;             --赠送疲劳值失败,上级已经被暂停
local SCORE_ADD_OR_SUB_TARGET_NOT_EXISTS = 9900;        --疲劳值增加与扣除:目标用户不存在俱乐部
local SCORE_ADD_OR_SUB_SELF_FORBID = 9901;              --自己已经被限制疲劳值操作,不能增减疲劳值
local SCORE_ADD_OR_SUB_SELF_FREEZE = 9902;              --自己已经被暂停操作,不能增减疲劳
local SCORE_ADD_OR_SUB_SUPER_FREEZE = 9903;             --上级管家及以上管家被暂停疲劳值操作
local errorMsg = {}
errorMsg[ERROR] = '系统繁忙，请稍后再试'
errorMsg[UNAVAILABLE] = '服务器维护中，请稍后...'
errorMsg[UNAUTHORIZED] = '当前请求需要用户验证'
errorMsg[LOCKED] = '当前请求所需要的数据被锁定'
errorMsg[REQUEST_REJECT] = '请求速度过快,请求被拒绝'
errorMsg[LESS_DIAMOND] = '您的钻石不足，请及时充值~'
errorMsg[IN_ROOM] = '您已在房间中'
errorMsg[ROOM_NOT_EXISTED] = '房间已解散'
errorMsg[ROOM_FULL] = '房间人数已满'
errorMsg[USER_NOT_EXISTED] = '玩家不存在'
errorMsg[USER_INVITED] = '您已经完成绑定'
errorMsg[INVITATION_CODE_ERROR] = '邀请码错误'
errorMsg[IAP_VALIDATE_ERROR] = '苹果In-App验证错误'
errorMsg[BANNED] = ' 被禁止登录'
errorMsg[INVITATION_BINDING_ERROR] = '不能绑定下级的邀请码'
errorMsg[CLUB_NOT_EXISTED] = '牌友群不存在'
errorMsg[CLUB_USER_EXISTED] = '该玩家已在牌友群！'
errorMsg[LORD_LESS_DIAMOND] = '群主钻石不足，请联系群主充值~'
errorMsg[CLUB_ROOM_FULL] = '牌友群可创建的牌桌已满'
errorMsg[USER_HAVE_PHONE] = '玩家已经绑定过手机号码'
errorMsg[PHONE_EXISTED] = '该手机号码已存在（已被其他玩家绑定）'
errorMsg[OBTAIN_SMS_COUNT_EXCEED] = '获取短信验证码的次数超额'
errorMsg[USER_NOT_IN_CLUB] = '该玩家不在牌友群~'
errorMsg[SEAT_HAVE_SEIZE] = '位置已被其他玩家占领'
errorMsg[NOT_AGENT_CODE] = '非代理邀请码（只能绑定代理的邀请码）'
errorMsg[CREATE_CLUB_LESS_DIAMONDS] = '创建牌友群玩家钻石不足（最低100个）'
errorMsg[CLUB_PLAY_ID_IS_NULL] = '玩法id为空'
errorMsg[CLUB_PLAY_FULL] = '单个牌友群的玩法已满，已达40个'
errorMsg[CLUB_USER_FULL] = '单个牌友群的玩家已满，已达200个'
errorMsg[CLUB_ROOM_IS_PAUSE] = '牌友群已暂停开房'
errorMsg[SMS_VERIFY_CODE_ERROR] = '短信验证码错误'
errorMsg[HAVE_MUTEX_PLAYER] = '您与当前牌桌的玩家存在互斥关系，请联系群主或管家'
errorMsg[WECHAT_ALREADY_EXISTS] = '微信号已被其他玩家绑定'
errorMsg[UPLOAD_USER_PHOTO_FAIL] = '上传用户风采照失败'
errorMsg[BLACK_PLAYER_EXISTED] = '玩家已存在小黑屋，不用重复添加'
errorMsg[BLACK_PLAYER_CANNOT_PLAY] = '您已被拉入小黑屋，请联系群主或管家'
errorMsg[NO_PERMISSION] = '当前没有权限执行当前的操作'
errorMsg[RULE_HAVE_ROOM] = '当前规则有玩家正在游戏，无法删除，请稍后再试'
errorMsg[FEE_BALANCE_NOT_ENOUGH] = '当前疲劳值余额不足'
errorMsg[SYSTEM_MAINTENANCE_ENABLED] = '系统维护已启动，当前禁止开房操作'
errorMsg[UNABLE_DISSOLVE] = '该俱乐部不能申请解散房间'
errorMsg[PLAYER_AUTO_BLACK_HOUSE] = '您可能已经违反了群主设置，已被系统自动拉入小黑屋，请联系群主'
errorMsg[VP_UNDER_ROOM_MIN_VALUE] = '疲劳值低于加入房间所需的最低值！'
errorMsg[OPERATION_REPEATED] = '不可重复操作'
errorMsg[USER_NOW_IN_ROOM] = '玩家正在游戏房间中，不可进行疲劳值扣除操作'
errorMsg[AMOUNT_OUT_OF_RANGE] = '数额超出范围'
errorMsg[VP_NOT_ZERO_UNABLE_QUIT_CLUB] = '您还有剩余疲劳值未清零，为了保障您的权益，请先联系管理员清零后再退出'
errorMsg[MEMBERS_HAS_VP_UNABLE_QUIT_CLUB] = '当前管理员或他的直属玩家还有剩余疲劳值未清零，为了保障你的权益，请先联系他'
errorMsg[CLUB_PLAY_NON_EXISTENT] = '玩法不存在'
errorMsg[MANAGER_HAVE_PERCENT_VP] = '管理员分配了大赢家百分比，不允许再分配疲劳值'
errorMsg[MANAGER_HAVE_ASSIGN_VP] = '管理员分配了疲劳值，不允许再分配大赢家疲劳值百分比'
errorMsg[ASSIGN_VP_VALUE_NO_VALID] = '分配的疲劳值不合法'
errorMsg[BIG_WINNER_VP_NO_VALID] = '有玩家分配的疲劳值大于当前群主设置的大赢家疲劳值'
errorMsg[NOTHING_CHANGED] = '无数据改动'
errorMsg[DISSOLVE_TIMES_LACK] = '群主已设置最多申请解散5次，如有疑问请联系群主'
errorMsg[CLUB_PLAY_RULE_FULL] = '单个玩法最多添加10个玩法规则'
errorMsg[QUIT_CLUB_NOT_ALLOWED] = '群主已禁止群成员退出牌友群，如有疑问请联系群主'

errorMsg[LOGIN_PWD_ERROR] = '登录密码错误'
errorMsg[PHONE_NOT_BIND] = '手机号码未绑定，请先使用微信登录绑定'
errorMsg[PHONE_FORMAT_ERROR] = '请输入正确的手机号码'
errorMsg[PASSWORD_FORMAT_ERROR] = '请输入8-20位的数字和字母组合'

errorMsg[TRANSFER_HAS_USER_GAMING] = '本群未暂停开房或牌友群还有已开房间未解散'
errorMsg[LINK_SYS_MANAGER] = '转让次数过多，请联系客服'
errorMsg[RECEIVE_CLUB_LORD_NOT_AGENT] = '该群群主没有开通代理不可转入群，请先联系开通代理'
errorMsg[RECEIVE_CLUB_NOT_GAME_MODE] = '该群未开启比赛场，请先联系开启比赛场'
errorMsg[RECEIVE_CLUB_HAVE_USER] = '该群已有群成员不可转入群，请先联系删除'
errorMsg[RECEIVE_CLUB_HAVE_PLAY] = '该群已创建玩法不可转入群，请先联系删除'
errorMsg[RECEIVE_CLUB_LORD_HAVE_FEE] = '该群群主疲劳值不为0，请先联系清除'
errorMsg[RECEIVE_LORD_IS_ORIGIN_MEMBER] = '转入的群群主是当前群的群成员，不可转入群，请先删除'
errorMsg[USER_IS_LOCK] = '你已违反游戏规定，已被系统封号！'
errorMsg[CLUB_USER_IN_AUDIT] = '你已申请该牌友群，请勿重复申请'
errorMsg[CLUB_USER_NOT_ACCESS_RANK]= '没有操作权限'
errorMsg[CLUB_USER_IN_BLACK_HOUSE] = '该玩家因违反群主设置，已被限制减疲劳值，且被系统自动拉小黑屋，不可进入游戏。如有疑问，请联系群主！'
errorMsg[CLUB_USER_LOSS_FEE_ERROR] = '负疲劳值设置参数异常'
errorMsg[MY_INFO_GIVE_BLANK] = '传值为空'
errorMsg[MY_INFO_GIVE_NUMBER] = '非法数值'
errorMsg[MY_INFO_GIVE_LORD] = '群主无赠送功能'
errorMsg[MY_INFO_GIVE_START_MODE] = '未开启比赛场模式'
errorMsg[MY_INFO_GIVE_NOT_CLUB] = '俱乐部用户不存在'
errorMsg[MY_INFO_GIVE_BLACK_HOUSE] = '您可能已经违反了群主设置，已被系统自动拉入小黑屋，不可操作疲劳值'
errorMsg[ROOM_ROUND_PLAYBACK_BLANK] = '输入的回放码为空'
errorMsg[ROOM_ROUND_PLAYBACK_MIN_LENGTH] = '输入的回放码不符合最小长度'
errorMsg[ROOM_ROUND_PLAYBACK_NOT_FOUND] = '找不到对局记录'
errorMsg[ENTER_ERROR_IP_CHECK_FAILED] = '该房间设置了IP地址检测，禁止同IP进入同一房间'
errorMsg[ENTER_ERROR_GPS_CHECK_FAILED] = pcallLocationFun and '该房间开启了GPS检测，请在游戏大厅“设置”中开启定位功能' or '该房间开启了GPS检测，请在手机“设置”中开启定位功能并允许游戏获取定位'
errorMsg[PASSWORD_ARE_INCONSISTENT] = '注册时密码不一致'
errorMsg[CANNOT_CREATE_MANY_ACCOUNT] = '不能创建多个账号'

errorMsg[JOIN_CLUB_NOT_APPLY_CLUB] = '群主关闭了申请加入俱乐部'
errorMsg[CLUB_USER_MANAGE_DELETE_CLOSE] = '群主已禁止删除成员，如有疑问请联系群主'
errorMsg[ADD_MUTEX_USERS_EXISTS] = '添加俱乐部互斥玩家,玩家已经存在'
errorMsg[MY_INFO_ALERT_ERROR] = '非法参数'
errorMsg[MY_INFO_ALERT_PERMISSION] = '非法操作'
errorMsg[MY_INFO_RELIEVE_ERROR] = '非法参数'
errorMsg[MY_INFO_RELIEVE_PERMISSION] = '非法操作'
errorMsg[MY_INFO_UPDATE_ALERT_ERROR] = '非法参数'
errorMsg[MY_INFO_UPDATE_ALERT_PERMISSION] = '非法操作'
errorMsg[CREATE_ROOM_ALERT_SELF_FREEZE] = '创建房间失败，您已经被暂停'
errorMsg[CREATE_ROOM_ALERT_SUPER_FREEZE] = '创建房间失败，您的上级管家可能已经被暂停'
errorMsg[ENTER_ROOM_ALERT_SELF_FREEZE] = '进入房间失败，您已经被暂停'
errorMsg[ENTER_ROOM_ALERT_SUPER_FREEZE] = '进入房间失败，您的上级管家可能已经被暂停'
errorMsg[MY_INFO_GIVE_SUPER_FORBID] = '您的管家可能已被限制疲劳值操作，如有疑问请联系管家'
errorMsg[MY_INFO_GIVE_SUPER_FREEZE] = '您的管家可能已被暂停，如有疑问请联系管家'
errorMsg[SCORE_ADD_OR_SUB_TARGET_NOT_EXISTS] = '疲劳值增加或扣除失败，目标用户不存在牌友群'
errorMsg[SCORE_ADD_OR_SUB_SELF_FORBID] = '您已被限制疲劳值操作，如有疑问请联系管家'
errorMsg[SCORE_ADD_OR_SUB_SELF_FREEZE] = '您已被暂停，如有疑问请联系管家'
errorMsg[SCORE_ADD_OR_SUB_SUPER_FREEZE] = '您的管家可能已被暂停，如有疑问请联系管家'
pingTime = 0
local DISSOLVE_TIMES_LACK = 55
gameErrorMsg = {}
gameErrorMsg[DISSOLVE_TIMES_LACK] = '群主已设置最多申请解散5次，如有疑问请联系群主'
XIAO1 = 0  --小一
XIAO2 = 1  --小二
XIAO3 = 2  --小三
XIAO4 = 3  --小四
XIAO5 = 4  --小五
XIAO6 = 5  --小六
XIAO7 = 6  --小七
XIAO8 = 7  --小八
XIAO9 = 8  --小九
XIAO10 = 9  --小十
DA1 = 10  --大壹
DA2 = 11  --大貮
DA3 = 12  --大叁
DA4 = 13  --大肆
DA5 = 14  --大伍
DA6 = 15  --大陸
DA7 = 16  --大柒
DA8 = 17  --大玐
DA9 = 18  --大玖
DA10 = 19 --大拾

playType = {}
playType['沅江鬼胡子'] = 18
playType['攸县碰胡'] = 17
playType['宁乡跑胡子'] = 16
playType['湘潭跑胡子'] = 15
playType['安乡偎麻雀'] = 14
playType['常德多红对'] = 13
playType['汉寿跑胡子'] = 12
playType['湘乡告胡子'] = 11
playType['郴州字牌'] = 10
playType['长沙跑胡子'] = 9
playType['耒阳字牌'] = 8
playType['常德跑胡子'] = 7
playType['娄底放炮罚'] = 6
playType['常宁六胡抢'] = 5
playType['衡阳十胡卡'] = 4
playType['衡阳六胡抢'] = 3
playType['怀化红拐弯'] = 2
playType['邵阳剥皮'] = 1
playType['邵阳字牌'] = 0
playType['安化跑胡子'] = 19

playType['跑得快15张'] = 30
playType['跑得快16张'] = 31
playType['新化炸弹'] = 35
playType['打筒子'] = 36
playType['半边天炸'] = 37
playType['打大A'] = 38
playType['沅江千分'] = 40
playType['衡山同花'] = 41

playType['长沙麻将'] = 50   -- 麻将
playType['转转麻将'] = 51		
playType['红中麻将'] = 52
playType['呼市麻将'] = 53
playType['乌兰察布麻将'] = 54
playType['溆浦老牌'] = 55
playType['划水麻将'] = 56
playType['郑州麻将'] = 57
playType['安化麻将'] = 58 

playTypeString={}
playTypeString[18] = '沅江鬼胡子'
playTypeString[17] = '攸县碰胡'
playTypeString[16] = '宁乡跑胡子'
playTypeString[15] = '湘潭跑胡子'
playTypeString[14] = '安乡偎麻雀'
playTypeString[13] = '常德多红对'
playTypeString[12] = '汉寿跑胡子'
playTypeString[11] = '湘乡告胡子'
playTypeString[10] = '郴州字牌'
playTypeString[9] = '长沙跑胡子'
playTypeString[8] = '耒阳字牌'
playTypeString[7] = '常德跑胡子'
playTypeString[6] = '娄底放炮罚'
playTypeString[5] = '常宁六胡抢'
playTypeString[4] = '衡阳十胡卡'
playTypeString[3] = '衡阳六胡抢'
playTypeString[2] = '怀化红拐弯'
playTypeString[1] = '邵阳剥皮'
playTypeString[0] = '邵阳字牌'
playTypeString[19] = '安化跑胡子'

playTypeString[30] = '跑得快15张'
playTypeString[31] = '跑得快16张'
playTypeString[35] = '新化炸弹'
playTypeString[36] = '打筒子'
playTypeString[37] = '半边天炸'
playTypeString[38] = '打大A'
playTypeString[40] = '沅江千分'
playTypeString[41] = '衡山同花'

playTypeString[50] = '长沙麻将'
playTypeString[51] = '转转麻将'
playTypeString[52] = '红中麻将'
playTypeString[53] = '呼市麻将'
playTypeString[54] = '乌兰察布麻将'
playTypeString[55] = '溆浦老牌'
playTypeString[56] = '划水麻将'
playTypeString[57] = '郑州麻将'
playTypeString[58] = '安化麻将'

GameTypeString={}
GameTypeString[0] = '麻将'
GameTypeString[1] = '跑胡子'
GameTypeString[2] = '跑得快'
GameTypeString[3] = '新化炸弹'
GameTypeString[4] = '打筒子'
GameTypeString[5] = '半边天炸'
GameTypeString[6] = '打大A'
GameTypeString[7] = '内蒙麻将'
GameTypeString[8] = '斗地主'
GameTypeString[9] = '溆浦老牌'
GameTypeString[10] = '河南麻将'
GameTypeString[11] = '沅江千分'
GameTypeString[12] = '衡山同花'

RoundData = {}
RoundAllData={}
DestroyRoomData={}

local gameObjectDataMap={}
function SetUserData(go,data)
    gameObjectDataMap[go:GetInstanceID()]=data
end
function GetUserData(go)
    return gameObjectDataMap[go:GetInstanceID()]
end

local iconPool = {}

function SendProxyMessage(msg, callback)
    if not msg then
        Debugger.Log('msg is null', nil)
        return
    end

    if callback then
        proxyCallback[msg.type] = callback
    end

    local con = NetWorkManager.Instance:FindConnet('proxy')
    if con then
        con:SendMessage(msg)
    end
end

function RegisterProxyCallBack(msgType, callback)
    if callback and msgType then
        proxyCallback[msgType] = callback
        --print('register callback type is:'..msgType)
    end
end

function receiveProxyMessage(msg)
    local h = nil
    if msg.HeaderLength > 0 then
        h = protocol_pb.Header();
        h:ParseFromString(msg.header);
    end
   
    --print('receiveProxyMessage type is '..msg.type)
    if h and h.status > 0 then
        print('代理服收到错误码 ' .. h.status)
        if UNAUTHORIZED == h.status then
            Debugger.LogError('msg is null', nil)
            return
        end

        if panelLogin then
            panelLogin.HideAllNetWaitting()
        end
	
        if h.status == ROOM_NOT_EXISTED or h.status == LESS_DIAMOND then
            panelMessageTip.SetParamers(errorMsg[h.status], 2)
            PanelManager.Instance:ShowWindow('panelMessageTip')
            if h.status == ROOM_NOT_EXISTED then
                if panelInGame then
                    panelInGame.Destroy()
                end
            end
        -- elseif h.status == INVITATION_CODE_ERROR then
        --     if panelActivity then
        --         panelActivity.OnBindFail()
        --     end
        -- elseif h.status == INVITATION_BINDING_ERROR then
        --     if panelActivity then
        --         panelActivity.OnNotBindDownInviterId()
        --     end
        elseif h.status == LORD_LESS_DIAMOND then
            local str = '您的钻石不足，请及时充值！'
            if panelClub.clubInfo.lordId ~= info_login.id then
                str = '群主钻石不足，请联系群主充值！'
            end
            panelMessageTip.SetParamers(str, 1)
            PanelManager.Instance:ShowWindow('panelMessageTip')
        elseif h.status == SYSTEM_MAINTENANCE_ENABLED then
            GetUpdateNotice(false)
        elseif h.status == CLUB_USER_EXISTED and PanelManager.Instance:IsActive('panelClubApply') then
            panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '您已在该牌友群')
            PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
        elseif h.status == CLUB_USER_IN_AUDIT and PanelManager.Instance:IsActive('panelClubApply') then
            panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '你已申请该牌友群，请勿重复申请')
            PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
        elseif h.status == VP_UNDER_ROOM_MIN_VALUE then
            local result = GetResult(msg)
            local str = '您当前疲劳值低于该房间进房最低值'..result.msg
            panelMessageBox.SetParamers(ONLY_OK, nil, nil, str)
            PanelManager.Instance:ShowWindow('panelMessageBox')
        elseif h.status == TRANSFER_HAS_USER_GAMING 
            or h.status == LINK_SYS_MANAGER
            or  h.status == RECEIVE_CLUB_LORD_NOT_AGENT
            or  h.status == CLUB_NOT_EXISTED
            or  h.status == RECEIVE_CLUB_NOT_GAME_MODE
            or  h.status == RECEIVE_CLUB_HAVE_USER
            or  h.status == RECEIVE_CLUB_HAVE_PLAY
            or  h.status == RECEIVE_CLUB_LORD_HAVE_FEE 
            or  h.status == RECEIVE_LORD_IS_ORIGIN_MEMBER then
            if panelChangPool then
                panelChangPool.issendmsg=false
                panelChangPool.ischangsus=false   
                panelChangPool.refreshTiShiTxt(errorMsg[h.status],true,true,false)
            else
                if h.status == CLUB_NOT_EXISTED then
                    panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, errorMsg[h.status])
                    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
                end
            end
        else
            if h.status == 42 or h.status == 74 or h.status == 81 then
                panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, errorMsg[h.status])
                PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
            else
                panelMessageBox.SetParamers(ONLY_OK, nil, nil, errorMsg[h.status])
                PanelManager.Instance:ShowWindow('panelMessageBox')
            end
            if panelChangPool then
                panelChangPool.issendmsg=false
                panelChangPool.ischangsus=false 
                panelChangPool.HideTiShi()
            end
        end
        return
    end

    if proxyCallback[msg.type] then
        proxyCallback[msg.type](msg)
    elseif msg.type ~= 1 then
        Debugger.Log("no register proxy type {0}", msg.type)
    else
        --print('receiveProxy PONG')
    end
    if onProxyReceive~=nil and msg.type ~= 1 then
        onProxyReceive()
        registerProxyReceive(nil)
    end
end

function registerProxyReceive(fuc)
    onProxyReceive=fuc
end

function SendGameMessage(msg, callback)
    if not msg then
        Debugger.Log('msg is null', nil)
        return
    end

    if callback then
        gameCallback[msg.type] = callback
    end

    local con = NetWorkManager.Instance:FindConnet('game')
    if con then
        con:SendMessage(msg)
    end
end


function GetResult(msg)
    local result = proxy_pb.RResult()
    result:ParseFromString(msg.body)
    return  result
end

function RegisterGameCallBack(msgType, callback)
    if callback and msgType then
        gameCallback[msgType] = callback
    end
end

function ClearGameCallBack()
    gameCallback = {}
end

--用于protobuf生成的元素为简单数据类型的TABLE
function tableClear(tab)
	for i=#tab,1,-1 do
		table.remove(tab,i);
	end
end

--用于protobuf生成的元素为简单数据类型的TABLE
function tableAdd(tab, eles)
	for i=1,#eles do
		--tab:append(eles[i])
        table.insert(tab,eles[i]);
	end
end

function getRemoveKeys(removeTalbe)
    local removeKeys = {};
    for key,value in pairs(removeTalbe) do
        removeKeys[value] = true;
    end

    return removeKeys;
end

function tableRemoveByKeys(removeTable, removeKeys)
    print("tableRemoveByKeys was called");
    for i = #removeTable,1,-1 do
        if removeKeys[removeTable[i]] then
            table.remove(removeTable,i);
        end
    end
end

--删除麻将特定的牌
function tableRemovePlate(removeTable,plate)
    if plate ~= -1 then
        local removePos = -1;
        for j = 1,#removeTable do
            if removeTable[j] == plate then
                removePos = j;
                break;
            end
        end
        if removePos ~= -1 then
            table.remove(removeTable,removePos);
            return true
        else
            return false;
        end
    else
        return false;
    end
end
function tableRemoveSameEle(tab, saveCount)
	local temp = {}
	if not saveCount or saveCount < 1 then
		saveCount = 1
	end
	for i=#tab,1,-1 do
		if not temp[tab[i]] then
			temp[tab[i]] = 1
		elseif temp[tab[i]] < saveCount then
			temp[tab[i]] = temp[tab[i]] + 1
		else
			table.remove(tab, i)
		end
	end
end

function tableClone(tab)
	local c = {}
	for i=1,#tab do
		table.insert(c, tab[i])
	end
	return c
end



function tableMerge(tabTarget, tabOrigin)
	for i=1,#tabOrigin do
		table.insert(tabTarget, tabOrigin[i])
	end
end


function receiveGameMessage(msg)
    local h = nil
    if msg.HeaderLength > 0 then
        h = protocol_pb.Header();
        h:ParseFromString(msg.header);
    end

    -- print('receiveGameMessage type is '..msg.type)
    if h and h.status > 0 then
        print('receiveGameError type is ' .. h.status)
        if UNAUTHORIZED == h.status then
            Debugger.LogError('msg is null', nil)
            return
        end

        panelMessageBox.SetParamers(ONLY_OK, nil, nil, errorMsg[h.status])
        PanelManager.Instance:ShowWindow('panelMessageBox')
        return
    end

    if gameCallback[msg.type] then
        gameCallback[msg.type](msg)
    elseif msg.type ~= 1 then
        Debugger.Log("no register game type {0}", msg.type)
    else
        --print('receiveGame PONG')
    end
end

function RefreshPhoneState(gameView, logic, batteryLevel, network)
    while gameView.activeSelf do
        -- 修改电池电量
        local level = PlatformManager.Instance:GetBatteryLevel()
        local width = level / 100
        
        batteryLevel.fillAmount =  width

        -- 重设网络状态
        local networkType = PlatformManager.Instance:GetNetworkType()
        if networkType == 1 then
            network.spriteName = 'wifi' .. logic:GetNetworkLatencyLevel()
        elseif networkType == 2 then
            network.spriteName = 'gprs' .. logic:GetNetworkLatencyLevel()
        elseif string.find(network.spriteName, 'wifi') then
            network.spriteName = 'wifi0'
        else
            network.spriteName = 'gprs0'
        end

        coroutine.wait(30)
    end
end

function RefreshTime(labelTime, interval)
    if interval < 0 then
        interval = 1
    end

    while true do
        labelTime.text = os.date("%H:%M")
        coroutine.wait(interval)
    end
end

function LoadPlayerIcon(texCom, fileName)
    if iconPool[fileName] then
        texCom.mainTexture = iconPool[fileName]
        return
    end
    texCom.mainTexture = nil
    LocalDataManager.Instance:DownLoadIcons(fileName,texCom,iconPool)
end

local fengCaiZhaoPool = {}
function LoadFengCaiZhao(texCom, url)
    if fengCaiZhaoPool[url] then
        texCom.mainTexture = fengCaiZhaoPool[url]
        return
    end
    texCom.mainTexture = nil
    local www = UnityEngine.WWW(url)
    coroutine.www(www)
    if www.error~=nil and www.error~='' then
        print('download url'..tostring(url)..' error '..www.error)
    elseif www.bytesDownloaded > 0 then
        texCom.mainTexture = www.texture
        fengCaiZhaoPool[url] = www.texture
    else
        print('download url'..tostring(url)..' 是空的 ')    
    end
end

--升序
function tableSortAsc(a, b)
    return a < b
end

--降序
function tableSortDesc(a, b)
    return a > b
end

--table升序
function tableSortAscBySubtable(a, b)
    return a[1] < b[1]
end

--table降序
function tableSortDescBySubtable(a, b)
    return a[1] > b[1]
end

function IsAppleReview()
    return ConfigManager.getBoolProperty('Setting', 'AppleReview', true)
end
pos2 = {
    {0,2}
}
pos3 = {
    { 0, 1 },
    { 1, 2 },
    { 2, 0 }
}
pos4 = {
    { 0, 2 },
    { 2, 3 },
    { 3, 0 },
    { 0, 1 },
    { 1, 2 },
    { 3, 1 }
}
--定位
function SetGPSInfo(GPS,pos,data,size)
	print('SetGPSInfo .................'..' pos length :'..#pos)
	for i = 0, #GPS.distance do
        GPS.distance[i].length:GetComponent('UILabel').text = ''
        GPS.distance[i].transform.gameObject:SetActive(i<#pos)
    end
    for i = 0, #GPS.playerGPS do
        GPS.playerGPS[i].transform.gameObject:SetActive(false)
		GPS.playerGPS[i].name:GetComponent("UILabel").text = ''
		if GPS.playerGPS[i].icon ~= nil then
			GPS.playerGPS[i].icon:GetComponent('UITexture').mainTexture = nil
		end
		GPS.playerGPS[i].dingwei:GetComponent("UISprite").color = Color.New(0,0,0)
    end
    for i = 0, size-1 do
        GPS.playerGPS[i].transform.gameObject:SetActive(true)
    end
	local dis = {}
    for i = 0, #pos - 1 do
		local p1 = data[pos[i+1][1]]
        local p2 = data[pos[i+1][2]]
		if p1 ~= nil and p1.longitude ~= nil and p2 ~= nil and p2.longitude then
			dis[i] = GetDistance(p1.longitude, p1.latitude, p2.longitude, p2.latitude)
		else
			dis[i] = '无'
		end
	end
    for i = 0, #dis do
		if dis[i] ~= nil and dis[i] ~= '无' then
			GPS.distance[i].length:GetComponent('UILabel').text = dis[i]
		end
	end
	for i = 0, #GPS.playerGPS do
        if data[i] ~= nil then
			GPS.playerGPS[i].name:GetComponent("UILabel").text = data[i].name
			if GPS.playerGPS[i].icon ~= nil then
				coroutine.start(LoadPlayerIcon,GPS.playerGPS[i].icon:GetComponent('UITexture'),data[i].icon)
			end
			GPS.playerGPS[i].dingwei:GetComponent("UISprite").color = Color.New(1,1,1)
		end
	end
end
--定位end
function GetDistance(lng1, lat1, lng2, lat2)
    local d = '0'
    if lng1 == 0 or lat1 == 0 or lng2 == 0 or lat2 == 0 then
        return '定位失败'
    else
        local R = 6378137
        local radLat1 = Mathf.Deg2Rad * lat1
        local radLat2 = Mathf.Deg2Rad * lat2
        local radlng1 = Mathf.Deg2Rad * lng1
        local radlng2 = Mathf.Deg2Rad * lng2
        local x1 = R * Mathf.Cos(radlng1) * Mathf.Sin(radLat2)
        local y1 = R * Mathf.Sin(radlng1) * Mathf.Sin(radLat2)
        local z1 = R * Mathf.Cos(radLat1)
        local x2 = R * Mathf.Cos(radlng2) * Mathf.Sin(radLat2)
        local y2 = R * Mathf.Sin(radlng2) * Mathf.Sin(radLat2)
        local z2 = R * Mathf.Cos(radLat2)
        local a = Mathf.Sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2) + (z1 - z2) * (z1 - z2))
        local b = Mathf.Acos((R * R + R * R - a * a) / (2 * R * R))
        local s = b * R
        if math.ceil(s) < 1000 then
            d = math.ceil(tostring(s)) .. 'm'
        else
            s = math.ceil(s / 1000)
            d = tostring(s) .. 'km'
        end
        return d
    end
end

function GetDistanceNum(lng1, lat1, lng2, lat2)
    local d = 0
    if lng1 == 0 or lat1 == 0 or lng2 == 0 or lat2 == 0 then
        return 0
    else
        local R = 6378137
        local radLat1 = Mathf.Deg2Rad * lat1
        local radLat2 = Mathf.Deg2Rad * lat2
        local radlng1 = Mathf.Deg2Rad * lng1
        local radlng2 = Mathf.Deg2Rad * lng2
        local x1 = R * Mathf.Cos(radlng1) * Mathf.Sin(radLat2)
        local y1 = R * Mathf.Sin(radlng1) * Mathf.Sin(radLat2)
        local z1 = R * Mathf.Cos(radLat1)
        local x2 = R * Mathf.Cos(radlng2) * Mathf.Sin(radLat2)
        local y2 = R * Mathf.Sin(radlng2) * Mathf.Sin(radLat2)
        local z2 = R * Mathf.Cos(radLat2)
        local a = Mathf.Sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2) + (z1 - z2) * (z1 - z2))
        local b = Mathf.Acos((R * R + R * R - a * a) / (2 * R * R))
        local s = b * R
        return s;
    end
end
function InspectIPAndGPS(data,pos,fuc)
    print('InspectIPAndGPS :..................... ')
    local ipGroup = {}
    local nameGroup = {}
    local names = ""
    local lenALL = {}
    local name = {}
    local mingzi = {}
    local latitude = {}
    local nameAll = ''
    local needShowTip = false
    for i = 0,#data do
        local same = false
        for j = 1, #ipGroup do
            if ipGroup[j][1] == data[i].ip then
                same = true
                table.insert(ipGroup[j], data[i].ip)
                table.insert(nameGroup[j], data[i].name)
                break
            end
        end
        if not same and #data[i].ip > 0 then
            table.insert(ipGroup, { data[i].ip })
            table.insert(nameGroup, { data[i].name })
        end
    end
    for i = 1, #nameGroup do
        if #nameGroup[i] > 1 then
            for j = 1, #nameGroup[i] do
                names = names .. nameGroup[i][j]
                if j ~= #nameGroup[i] then
                    names = names .. '、'
                end
            end
            names = names .. 'IP地址相同\n'
        end
    end
    for i = 0, #data do
        mingzi[i] = data[i].name
        latitude[i] = data[i].latitude
        if latitude[i] == 0 then
            nameAll = nameAll .. mingzi[i] .. '没有开启位置信息\n'
        end
    end
    for i = 1, #pos do
        table.insert(name,mingzi[pos[i][1]]..'、'..mingzi[pos[i][2]])
    end
    print("长度：" .. #name)
    print(nameAll)
    for i = 1, #name do
        local p1 = data[pos[i][1]]
        local p2 = data[pos[i][2]]
        if p1.longitude ~= 0 and p2.longitude ~= 0 then
            lenALL[i] = GetDistance(p1.longitude, p1.latitude, p2.longitude, p2.latitude)
            nameAll = nameAll .. name[i] .. '相距' .. lenALL[i] .. '\n'
        end
    end
    local Name = names .. nameAll
    for i = 1, #name do
        local p1 = data[pos[i][1]]
        local p2 = data[pos[i][2]]
        if p1.longitude ~= 0 and p2.longitude ~= 0 then
           local distanceBetween = GetDistanceNum(p1.longitude, p1.latitude, p2.longitude, p2.latitude)
           print("distanceBetween:"..distanceBetween)
           --找到了两者相距小于1KM的玩家对
           if distanceBetween < 1000 then 
                needShowTip = true
                break
           end
        end
    end
    coroutine.start(
    function()
        coroutine.wait(1)
        if needShowTip then
            panelMessageBoxTiShi.SetParamers(OK_CANCLE,fuc, nil,  Name, '解 散', '继 续', 20)
            PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
        end
    end
    )
end
local screenCor = nil
function SetScreenLayout(land, uiRoot)
    -- uiRoot:GetComponent('UIRoot').manualWidth = land and 1334 or 750
    -- uiRoot:GetComponent('UIRoot').manualHeight = land and 750 or 1334
    -- UnityEngine.Screen.orientation = land and UnityEngine.ScreenOrientation.LandscapeLeft or UnityEngine.ScreenOrientation.Portrait
--[[UnityEngine.Screen.autorotateToLandscapeLeft = land and true or false  
	UnityEngine.Screen.autorotateToLandscapeRight = land and true or false  
	UnityEngine.Screen.autorotateToPortrait = (not land) and true or false
	UnityEngine.Screen.autorotateToPortraitUpsideDown = (not land) and true or false
	coroutine.stop(screenCor)
	screenCor = coroutine.start(
		function()
			coroutine.wait(0.1)
			UnityEngine.Screen.orientation = land and UnityEngine.ScreenOrientation.LandscapeLeft or UnityEngine.ScreenOrientation.Portrait
			coroutine.wait(1)
			UnityEngine.Screen.orientation = UnityEngine.ScreenOrientation.AutoRotation
		end
	)]]
    --
end

function breakString(needBreak)
    if needBreak then
        return '\n'
    else
        return ','
    end
end
--[[    @desc: 
    author:{author}
    time:2018-07-30 21:07:34
    --@setting:玩法设置
	--@NoNeedPay: 需不需要显示支付信息 true为不需要
    @return:
]]
function getWanFaText(setting, NoNeedPayInfo, needBreak, needGameName ,NoNeedPlayerNum,isShowPlay,isNoShowGps)
    local msg = ''

    local roomType
    if setting.roomType~=nil and setting.roomType~='' then
        roomType=setting.roomType
    else
        if setting.roomTypeValue ~= nil then
            roomType=setting.roomTypeValue 
        end
    end
    if needGameName and roomType ~= nil and playTypeString[roomType] ~= nil then
        msg = msg..playTypeString[roomType]..breakString(needBreak)
    end

    if NoNeedPlayerNum then
    else
        if setting.size ~= nil then
            if setting.size == 3 then
                msg = msg ..'3人玩'..breakString(needBreak)
            elseif setting.size == 2 then
                msg = msg ..'2人玩'..breakString(needBreak)
            elseif setting.size == 4 then
                msg = msg ..'4人玩'..breakString(needBreak)
            end
        end
    end
   
    if setting.rounds ~= nil then
        if roomType ~= proxy_pb.SYBP 
        and roomType ~= proxy_pb.LDFPF
        and roomType ~= proxy_pb.XXGHZ  then
            msg = msg  .. setting.rounds .. '局'.. breakString(needBreak)
        end
    end
    if NoNeedPayInfo==true then
        -- body
    else
        if setting.paymentType ~= nil then
            if setting.paymentType == 0 then
                msg = msg ..'房主支付'.. breakString(needBreak)
            elseif setting.paymentType == 1 then
                msg = msg ..'AA支付'.. breakString(needBreak)
            elseif setting.paymentType == 2 then
                msg = msg ..'赢家支付'.. breakString(needBreak)
            end
        end
    end

    if setting.randomBanker ~= nil then
        msg = msg .. (setting.randomBanker==true and '首局随机坐庄' or '先进房坐庄').. breakString(needBreak) 
    end

    if roomType == proxy_pb.SYZP or roomType == 'SYZP' then
        if setting.qiHuHuXi ~= nil then
            if setting.qiHuHuXi == 10 then
                msg = msg ..'10胡起胡'.. breakString(needBreak)
            else
                msg = msg ..'15胡起胡'.. breakString(needBreak)
            end
        end
        if setting.tunXi ~= nil then
            if setting.tunXi == 1 then
                msg = msg ..'1胡一囤'..breakString(needBreak)
            elseif setting.tunXi == 3 or setting.tunXi == 0 then
                msg = msg ..'3胡一囤'..breakString(needBreak)
            elseif setting.tunXi == 5 then
                msg = msg ..'5胡一囤'..breakString(needBreak)
            end
        end
        if setting.bottomScore ~= nil then
            msg = msg ..'底分'..setting.bottomScore..'分'.. breakString(needBreak)
        end
        if setting.size ~= nil and setting.size == 4 and setting.fanXing~=nil then
            msg = msg .. (setting.fanXing==true and '翻醒' or '跟醒')..breakString(needBreak)
        end
        if setting.tianDiHu~=nil and setting.tianDiHu==true then
            msg = msg..'天地胡' .. breakString(needBreak)
        end
        if setting.heiHongHu~=nil and setting.heiHongHu==true then
            msg = msg ..'红黑胡'..breakString(needBreak)
        end
        if setting.ziMoAddHu~=nil and setting.ziMoAddHu==10 then
            msg = msg ..'自摸10胡'..breakString(needBreak)
        end 
	elseif roomType == proxy_pb.AHPHZ or roomType == 'AHPHZ' then 
		if setting.bottomScore ~= nil then
                msg = msg ..'底分'..setting.bottomScore..'分'.. breakString(needBreak)
            end
		if setting.tunXi ~= nil then
            if setting.tunXi == 1 then
                msg = msg ..'1胡一囤'..breakString(needBreak)
            elseif setting.tunXi == 3 or setting.tunXi == 0 then
                msg = msg ..'3胡一囤'..breakString(needBreak) 
            end
        end
		if setting.paPo ~= nil and setting.paPo then
            msg = msg ..'爬坡'.. breakString(needBreak)
        end 
        if setting.heiHongHu~=nil and setting.heiHongHu==true then
            msg = msg ..'红黑胡'..breakString(needBreak)
        end 
		if setting.ziMoAddTun ~= nil then
            if setting.ziMoAddTun ~= 0 then
                msg = msg ..'自摸加'..setting.ziMoAddTun..'囤'.. breakString(needBreak)
            end
        end
		if setting.tianHu ~= nil and setting.tianHu then
            msg = msg ..'天胡'.. breakString(needBreak)
        end
        if setting.diHu ~= nil and setting.diHu then
            msg = msg ..'地胡'.. breakString(needBreak)
        end
		if setting.haiDiHu ~= nil and setting.haiDiHu then
            msg = msg ..'海底胡'.. breakString(needBreak)
        end
		 if setting.huangZhuangFen ~= nil then
            if setting.huangZhuangFen == 0 then
                msg = msg .. '荒庄不扣分'.. breakString(needBreak)
            else
                msg = msg .. '荒庄扣'..setting.huangZhuangFen..'分'.. breakString(needBreak)
            end
        end
		if setting.huangKeepBanker ~= nil and setting.huangKeepBanker then
            msg = msg ..'荒庄继续坐庄'.. breakString(needBreak)
        end
    elseif roomType == proxy_pb.SYBP or roomType == 'SYBP' then
        if setting.tianDiHu~=nil and setting.tianDiHu==true then
            msg = msg..'天地胡' .. breakString(needBreak)
        end
        if setting.heiHongHu~=nil and setting.heiHongHu==true then
            msg = msg ..'红黑胡'..breakString(needBreak)
        end
        if setting.heiHongDian~=nil and setting.heiHongDian==true then
            msg = msg ..'红黑点'.. breakString(needBreak)
        end
        if setting.maxHuXi ~= nil and setting.maxHuXi ~= 0 then
            msg = msg  .. setting.maxHuXi .. '胡封顶'.. breakString(needBreak)
        end
        if setting.zeroToTop then
            msg = msg .. '0分上告封顶'.. breakString(needBreak)
        end
        if setting.rounds ~= nil and setting.rounds == 1 then
            msg = msg .. '1局结束'.. breakString(needBreak)
        end
    elseif roomType == proxy_pb.HHHGW or roomType == 'HHHGW' then
        if not isShowPlay then
            if setting.bottomScore ~= nil then
                msg = msg ..'底分'..setting.bottomScore..'分'.. breakString(needBreak)
            end
        end
        if setting.mode == 0 then
            msg = msg .. '经典模式'.. breakString(needBreak)
        elseif setting.mode == 1 then
            msg = msg .. '468番模式'.. breakString(needBreak)
        end
        if not isShowPlay then
            if setting.canHuZiMo then
                msg = msg .. '15胡自摸可胡'.. breakString(needBreak)
            end
            if setting.ziMoFan == 2 then
                msg = msg .. '自摸2番'.. breakString(needBreak)
            end
            if setting.shiZhongBuLiang then
                msg = msg .. '21张亮牌可胡'.. breakString(needBreak)
            end
            if setting.tianHu5Fan then
                msg = msg .. '天胡5番'.. breakString(needBreak)
            end
            if setting.diHu4Fan then
                msg = msg .. '地胡4番'.. breakString(needBreak)
            end
            if setting.da18Fan5 then
                msg = msg .. '18大5番起'.. breakString(needBreak)
            end
            if setting.shiLiuXiao then
                msg = msg .. '16小5番起'.. breakString(needBreak)
            end
        end
        if setting.maxHuXi ~= nil then
            if setting.maxHuXi == 0 then
                msg = msg .. '不封顶'.. breakString(needBreak)
            else
                msg = msg .. '封顶'..setting.maxHuXi..'番'.. breakString(needBreak)
            end
        end
        if not isShowPlay then
            if setting.huangZhuangFen ~= nil then
                if setting.huangZhuangFen == 0 then
                    msg = msg .. '荒庄不扣分'.. breakString(needBreak)
                else
                    msg = msg .. '荒庄扣'..setting.huangZhuangFen..'分'.. breakString(needBreak)
                end
            end
        end
    elseif roomType == proxy_pb.LDFPF or roomType == 'LDFPF' then
        if setting.maxHuXi~=nil then
            msg = msg  .. setting.maxHuXi .. '胡封顶'..breakString(needBreak)
        end
    elseif roomType == proxy_pb.CSPHZ or roomType == 'CSPHZ' then
        if setting.ziMoFan ~= nil and setting.ziMoFan then
            msg = msg .. '自摸' .. setting.ziMoFan .. '番'.. breakString(needBreak) 
        end
        if setting.bottomScore ~= nil then
            msg = msg ..'底分'..setting.bottomScore..'分'.. breakString(needBreak)
        end
        if setting.zhaNiao ~= nil then
            if setting.zhaNiao == 0 then
                msg = msg .. '不扎鸟'.. breakString(needBreak)
            else
                msg = msg .. '扎鸟'..setting.zhaNiao..'分'.. breakString(needBreak)
            end
        end
        if setting.maxHuXi ~= nil then
            if setting.maxHuXi == 0 then
                msg = msg .. '不封顶'.. breakString(needBreak)
            else
                msg = msg .. '封顶'..setting.maxHuXi..'番'.. breakString(needBreak)
            end
        else
            if setting.limitFan~=nil then
                if setting.limitFan==true then
                    msg = msg ..'5番封顶'.. breakString(needBreak)
                else
                    msg = msg..'不封顶' .. breakString(needBreak)
                end
            end
        end
        if setting.huangZhuangFen ~= nil then
            if setting.huangZhuangFen == 0 then
                msg = msg .. '荒庄不扣分'.. breakString(needBreak)
            else
                msg = msg .. '荒庄扣'..setting.huangZhuangFen..'分'.. breakString(needBreak)
            end
        end
        
    elseif roomType == proxy_pb.CDPHZ  or roomType == 'CDPHZ' then
        if setting.quanMingTang~=nil then
            if setting.quanMingTang==true then
                msg = msg ..'全名堂'.. breakString(needBreak)
            else
                msg = msg ..'红黑点'.. breakString(needBreak)
            end
        end
        if setting.shuaHou~=nil then
            if setting.shuaHou==true then
                msg = msg ..'耍猴'.. breakString(needBreak)
            end
        end
        if setting.daTuanYuan~=nil then
            if setting.daTuanYuan==true then
                msg = msg ..'大团圆'.. breakString(needBreak)
            end
        end
        if setting.tingHu~=nil then
            if setting.tingHu==true then
                msg = msg ..'听胡'.. breakString(needBreak)
            end
        end
        if setting.hangHangXi~=nil then
            if setting.hangHangXi==true then
                msg = msg ..'行行息'.. breakString(needBreak)
            end
        end
        if setting.jiaHangHang~=nil then
            if setting.jiaHangHang==true then
                msg = msg ..'假行行'.. breakString(needBreak)
            end
        end
        if setting.hong47~=nil then
            if setting.hong47==true then
                msg = msg ..'47红'.. breakString(needBreak)
            end
        end	
        if setting.huangFan~=nil then
            if setting.huangFan==true then
                msg = msg ..'黄番'.. breakString(needBreak)
            end
        end
        if setting.duiDuiHu~=nil then
            if setting.duiDuiHu==true then
                msg = msg ..'对对胡'.. breakString(needBreak)
            end
        end
        if setting.bottomScore ~= nil then
            msg = msg ..'底分'..setting.bottomScore..'分'.. breakString(needBreak)
        end
        if setting.maxHuXi ~= nil then
            if setting.maxHuXi == 0 then
                msg = msg .. '不封顶'.. breakString(needBreak)
            else
                msg = msg .. '封顶'..setting.maxHuXi..'分'.. breakString(needBreak)
            end
        end
        if setting.huangZhuangFen ~= nil then
            if setting.huangZhuangFen == 0 then
                msg = msg .. '荒庄不扣分'.. breakString(needBreak)
            else
                msg = msg .. '荒庄扣'..setting.huangZhuangFen..'分'.. breakString(needBreak)
            end
        end
    elseif roomType == proxy_pb.XXGHZ or roomType == 'XXGHZ' then
        if setting.tuo~=nil then
            msg = msg .. (setting.tuo==true and '打坨' or '不打坨').. breakString(needBreak)
        end
        if setting.qiHuHuXi ~= nil and setting.qiHuHuXi then
            msg = msg ..setting.qiHuHuXi..'胡起胡'..  breakString(needBreak)
        end
    elseif roomType == proxy_pb.HYSHK or roomType == 'HYSHK' then
        if isShowPlay==true then
        else
            if setting.bottom2Score ~= nil and setting.bottom2Score then
                msg = msg .. '底分2分'.. breakString(needBreak)
            end
            if setting.yiWuShi ~= nil and setting.yiWuShi then
                msg = msg .. '一五十'.. breakString(needBreak)
            end
        end
       
		if setting.fangPao ~= nil and not setting.fangPao then
			msg = msg .. '不可以放炮'.. breakString(needBreak)
        end
		if setting.haveHuMustHu ~= nil and setting.haveHuMustHu then
			msg = msg .. '有胡必胡'.. breakString(needBreak)
        end
        if isShowPlay==true then
        else
            if setting.canPiaoHu ~= nil and setting.canPiaoHu then
                msg = msg .. '飘胡'.. breakString(needBreak)
            end
            if setting.tianDiHaiHu ~= nil and setting.tianDiHaiHu then
                msg = msg .. '天地海胡'.. breakString(needBreak)
            end
            if setting.canMingWei ~= nil and setting.canMingWei then
                msg = msg .. '明偎'.. breakString(needBreak)
            end
            if setting.xiaoHong3Fan ~= nil and setting.xiaoHong3Fan then
                msg = msg .. '小红3番'.. breakString(needBreak)
            end
        end
        if isShowPlay==true then
        else
            if setting.fangPao ~= nil and setting.fangPao then
                if setting.fangPaoMultiple~=nil then
                    if setting.fangPaoMultiple == 0 then
                    else
                        msg = msg .. '放炮'..setting.fangPaoMultiple..'倍'..breakString(needBreak)
                    end
                end  
            end
        end
		if setting.xing ~= nil then
            if setting.xing == 0 then
                msg = msg .. '翻醒'.. breakString(needBreak)
            elseif setting.xing == 1 then
                msg = msg .. '跟醒'.. breakString(needBreak)
            else
                msg = msg .. '不带醒'.. breakString(needBreak)
            end 
        end
    elseif roomType == proxy_pb.HYLHQ or roomType == 'HYLHQ' then
        if isShowPlay==true then
        else
            if setting.qiHuHuXi~=nil and setting.qiHuHuXi then
                msg = msg ..setting.qiHuHuXi..'胡起胡'..  breakString(needBreak)
            end
            if setting.bottom2Score ~= nil and setting.bottom2Score then
                msg = msg .. '底分2分'.. breakString(needBreak)
            end
            if setting.yiWuShi ~= nil and setting.yiWuShi then
                msg = msg .. '一五十'.. breakString(needBreak)
            end
        end
		
		if setting.haveHuMustHu ~= nil and setting.haveHuMustHu then
			msg = msg .. '有胡必胡'.. breakString(needBreak)
        end
		if setting.heiHongDian ~= nil and setting.heiHongDian then
			msg = msg .. '红黑点'.. breakString(needBreak)
        end
        if isShowPlay==true then
        else
            if setting.tianDiHaiHu ~= nil and setting.tianDiHaiHu then
                msg = msg .. '天地海胡'.. breakString(needBreak)
            end
            if setting.canMingWei ~= nil and setting.canMingWei then
                msg = msg .. '明偎'.. breakString(needBreak)
            end
            if setting.liangZhangDianPao~=nil and  setting.liangZhangDianPao then
                msg = msg .. '亮张算点炮'.. breakString(needBreak)
            end
            if setting.oneHuOneTun~=nil and setting.oneHuOneTun then
                msg = msg .. '一胡一囤'.. breakString(needBreak)
            end
            if setting.play21~=nil and setting.play21 then
                msg = msg .. '21张玩法'.. breakString(needBreak)
            end
        end

		if setting.xing ~= nil then
            if setting.xing == 0 then
                msg = msg .. '翻醒'.. breakString(needBreak)
            elseif setting.xing == 1 then
                msg = msg .. '跟醒'.. breakString(needBreak)
            else
                msg = msg .. '不带醒'.. breakString(needBreak)
            end 
        end
    elseif roomType == proxy_pb.LYZP or roomType == 'LYZP' then
        if setting.choiceHu ~= nil and setting.choiceHu == 2 then
            msg = msg .. '放炮必胡'.. breakString(needBreak)
        end
        if isShowPlay==true then
        else
            if not setting.maoHu then
                msg = msg .. '不带无胡'.. breakString(needBreak)
            end
            if not setting.yiDianHong then
                msg = msg .. '不带一点红'.. breakString(needBreak)
            end
            if setting.tiAddScore ~= nil then
                if setting.tiAddScore == 0 then
                    msg = msg .. '提龙不加分'.. breakString(needBreak)
                elseif setting.tiAddScore == 1 then
                    msg = msg .. '提小龙1分大龙2分'.. breakString(needBreak)
                elseif setting.tiAddScore == 2 then
                    msg = msg .. '提小龙2分大龙4分'.. breakString(needBreak)
                end
            end
        end
    elseif roomType == proxy_pb.HSPHZ or roomType == 'HSPHZ' then
        if setting.qiHuTun ~= nil then
            msg = msg ..'起胡倒'..setting.qiHuTun.. breakString(needBreak)
        end
        if setting.hongDuiHu then
            msg = msg .. '红对胡'.. breakString(needBreak)
        end
        if setting.wuDuiHu then
            msg = msg .. '乌对胡'.. breakString(needBreak)
        end
        if setting.jiaHongDui then
            msg = msg .. '夹红对'.. breakString(needBreak)
        end
        if setting.choiceBanker ~= nil then
            if setting.choiceBanker == 0 then
                msg = msg .. '赢家为庄'.. breakString(needBreak)
            else
                msg = msg .. '轮流坐庄'.. breakString(needBreak)
            end
        end
        if setting.maxHuXi ~= nil then
            if setting.maxHuXi == 0 then
                msg = msg .. '不封顶'.. breakString(needBreak)
            else
                msg = msg .. '封顶'..setting.maxHuXi..'分'.. breakString(needBreak)
            end
        end
        if setting.huangZhuangFen ~= nil then
            if setting.huangZhuangFen == 0 then
                msg = msg .. '荒庄不扣分'.. breakString(needBreak)
            else
                msg = msg .. '荒庄扣'..setting.huangZhuangFen..'分'.. breakString(needBreak)
            end
        end
    elseif roomType == proxy_pb.CDDHD or roomType == 'CDDHD' then
        if setting.qiHuTun ~= nil then
            msg = msg ..'起胡'..setting.qiHuTun..'等'.. breakString(needBreak)
        end
        if setting.tianHu~=nil then
            if setting.tianHu==true then
                msg = msg ..'天胡'.. breakString(needBreak)
            end
        end
        if setting.diHu~=nil then
            if setting.diHu==true then
                msg = msg ..'地胡'.. breakString(needBreak)
            end
        end
        if setting.tingHu~=nil then
            if setting.tingHu==true then
                msg = msg ..'听胡'.. breakString(needBreak)
            end
        end
        if setting.haiDiHu~=nil then
            if setting.haiDiHu==true then
                msg = msg ..'海底胡'.. breakString(needBreak)
            end
        end	
        if setting.huangFan~=nil then
            if setting.huangFan==true then
                msg = msg ..'黄番'.. breakString(needBreak)
            end
        end
        if setting.maxHuXi ~= nil then
            if setting.maxHuXi == 0 then
                msg = msg .. '不封顶'.. breakString(needBreak)
            else
                msg = msg .. '封顶'..setting.maxHuXi..'分'.. breakString(needBreak)
            end
        end
        if setting.huangZhuangFen ~= nil then
            if setting.huangZhuangFen == 0 then
                msg = msg .. '荒庄不扣分'.. breakString(needBreak)
            else
                msg = msg .. '荒庄扣'..setting.huangZhuangFen..'分'.. breakString(needBreak)
            end
        end
    elseif roomType == proxy_pb.NXPHZ or roomType == 'NXPHZ' then
        if setting.qiHuHuXi ~= nil then
            msg = msg..setting.qiHuHuXi..'胡起胡'.. breakString(needBreak)
        end
        if setting.bottomScore ~= nil then
            msg = msg ..'底分'..setting.bottomScore..'分'.. breakString(needBreak)
        end
        if setting.ziMoFan ~= nil then
            if setting.ziMoFan == 2 then
                msg = msg ..'自摸翻倍'.. breakString(needBreak)
            end
        end
        if setting.shiLiuXiao then
            msg = msg .. '十六小'.. breakString(needBreak)
        end
        if setting.haiDiHu then
            msg = msg .. '海底胡'.. breakString(needBreak)
        end
        if setting.shuaHou then
            msg = msg .. '耍猴'.. breakString(needBreak)
        end
        if setting.add1When27 then
            msg = msg .. '27胡加1分'.. breakString(needBreak)
        end
        if setting.addHongXiaoDa then
            msg = msg .. '加红加大加小'.. breakString(needBreak)
        end
        if setting.ziMoAddTun ~= nil then
            if setting.ziMoAddTun ~= 0 then
                msg = msg ..'自摸加'..setting.ziMoAddTun..'囤'.. breakString(needBreak)
            end
        end
       
        if setting.zhaNiao ~= nil then
            if setting.zhaNiao == 0 then
                msg = msg .. '不扎鸟'.. breakString(needBreak)
            else
                msg = msg .. '扎鸟'..setting.zhaNiao..'分'.. breakString(needBreak)
            end
        end
        if setting.maxHuXi ~= nil then
            if setting.maxHuXi == 0 then
                msg = msg .. '不封顶'.. breakString(needBreak)
            elseif setting.maxHuXi == 5 or setting.maxHuXi == 10 then
                msg = msg .. '封顶'..setting.maxHuXi..'番'.. breakString(needBreak)
            else
                msg = msg .. '封顶'..setting.maxHuXi..'分'.. breakString(needBreak)
            end
        end
        if setting.huangZhuangFen ~= nil then
            if setting.huangZhuangFen == 0 then
                msg = msg .. '荒庄不扣分'.. breakString(needBreak)
            else
                msg = msg .. '荒庄扣'..setting.huangZhuangFen..'分'.. breakString(needBreak)
            end
        end
    elseif roomType == proxy_pb.XTPHZ or roomType == 'XTPHZ' then
        if setting.qiHuHuXi ~= nil then
            msg = msg..setting.qiHuHuXi..'胡起胡'.. breakString(needBreak)
        end
        if not isShowPlay then
            if setting.calculationTunMode ~= nil then
                if setting.calculationTunMode == 0 then
                    msg = msg..'3息1囤'.. breakString(needBreak)
                elseif setting.calculationTunMode == 1 then
                    msg = msg..'1息1囤'.. breakString(needBreak)
                elseif setting.calculationTunMode == 2 then
                    msg = msg..'1息1囤(逢3进3)'.. breakString(needBreak)
                end
            end
            if setting.bottomScore ~= nil then
                msg = msg ..'底分'..setting.bottomScore..'分'.. breakString(needBreak)
            end
            if setting.yiWuShi then
                msg = msg .. '一五十'.. breakString(needBreak)
            end
            if setting.shiZhongBuLiang then
                msg = msg .. '示众牌不亮张'.. breakString(needBreak)
            end
            if setting.hu30FangBei then
                msg = msg .. '30胡翻倍'.. breakString(needBreak)
            end
            if setting.tianDiHu then
                msg = msg .. '天地胡'.. breakString(needBreak)
            end
            if setting.pengPengHu then
                msg = msg .. '碰碰胡'.. breakString(needBreak)
            end
            if setting.daXiaoZiHu then
                msg = msg .. '大小字胡'.. breakString(needBreak)
            end
            if setting.yiDianHong then
                msg = msg .. '一点红'.. breakString(needBreak)
            end
            if setting.heiHongHu then
                msg = msg .. '红黑胡'.. breakString(needBreak)
            end
            if setting.hong13 then
                msg = msg .. '13红'.. breakString(needBreak)
            end
            if setting.canHuZiMo then
                msg = msg .. '自摸胡'.. breakString(needBreak)
            end
            if not setting.canMingWei then
                msg = msg .. '暗偎'.. breakString(needBreak)
            end
            if setting.chouWeiLiang then
                msg = msg .. '臭偎亮牌'.. breakString(needBreak)
            end
        end
        if setting.calculationFanMode ~= nil then
            if setting.calculationFanMode == 0 then
                msg = msg..'番数累乘'.. breakString(needBreak)
            elseif setting.calculationFanMode == 1 then
                msg = msg..'番数累加'.. breakString(needBreak)
            elseif setting.calculationFanMode == 2 then
                msg = msg..'只翻一倍'.. breakString(needBreak)
            end
        end
        if setting.maxHuXi ~= nil then
            if setting.maxHuXi == 0 then
                msg = msg .. '不封顶'.. breakString(needBreak)
            else
                msg = msg .. '封顶'..setting.maxHuXi..'分'.. breakString(needBreak)
            end
        end
        if not isShowPlay then
            if setting.huangZhuangFen ~= nil then
                if setting.huangZhuangFen == 0 then
                    msg = msg .. '荒庄不扣分'.. breakString(needBreak)
                else
                    msg = msg .. '荒庄扣'..setting.huangZhuangFen..'分'.. breakString(needBreak)
                end
            end
        end
    elseif roomType == proxy_pb.YXPHZ or roomType == 'YXPHZ' then
        if setting.mode ~= nil then
            msg = msg..(setting.mode == 0 and '连庄' or '中庄x2').. breakString(needBreak)
        end
        if setting.haveHuMustHu ~= nil and setting.haveHuMustHu then
            msg = msg ..'有胡必胡'.. breakString(needBreak)
        end
        if not isShowPlay then
            if setting.huangZhuangFen ~= nil then
                if setting.huangZhuangFen == 0 then
                    msg = msg .. '荒庄不扣分'.. breakString(needBreak)
                else
                    msg = msg .. '荒庄扣'..setting.huangZhuangFen..'分'.. breakString(needBreak)
                end
            end 
        end
    elseif roomType == proxy_pb.YJGHZ or roomType == 'YJGHZ' then
        if isShowPlay==true then
        else
            if setting.mode ~= nil then
                msg = msg..(setting.mode == 0 and '歪5坎5' or '歪10坎10').. breakString(needBreak)
            end
        end
        
        if setting.piao ~= nil and setting.piao == 0 then
            msg = msg ..'不可漂'.. breakString(needBreak)
        end

        if setting.jiuDuiBan ~= nil and setting.jiuDuiBan then
            msg = msg ..'九对半'.. breakString(needBreak)
        end

        if setting.wuXiPing ~= nil and setting.wuXiPing then
            msg = msg ..'无息平'.. breakString(needBreak)
        end
        if setting.diaoDiaoShou ~= nil and setting.diaoDiaoShou then
            msg = msg..(setting.mode == 0 and '吊吊手50息' or '吊吊手100息').. breakString(needBreak)
        end

        if setting.hangHangXi2Fan ~= nil and setting.hangHangXi2Fan then
            msg = msg ..'行行息2番'.. breakString(needBreak)
        end
        if setting.tianHu ~= nil and setting.tianHu then
            msg = msg ..'天胡'.. breakString(needBreak)
        end
        if setting.diHu ~= nil and setting.diHu then
            msg = msg ..'地胡'.. breakString(needBreak)
        end
        if setting.haiDiHu then
            msg = msg .. '海底胡'.. breakString(needBreak)
        end
        if setting.maxHuXi ~= nil then
            if setting.maxHuXi == 0 then
                msg = msg .. '不封顶'.. breakString(needBreak)
            else
                msg = msg .. '封顶'..setting.maxHuXi..'分'.. breakString(needBreak)
            end
        end

        if setting.huangZhuangFen ~= nil then
            if setting.huangZhuangFen == 0 then
                msg = msg .. '荒庄不扣分'.. breakString(needBreak)
            else
                msg = msg .. '荒庄扣'..setting.huangZhuangFen..'分'.. breakString(needBreak)
            end
        end 
        if setting.huangKeepBanker ~= nil and setting.huangKeepBanker then
            msg = msg ..'荒庄继续坐庄'.. breakString(needBreak)
        end
    elseif roomType == proxy_pb.CZZP or roomType == 'CZZP' then
        if setting.qiHuHuXi ~= nil then
            msg = msg..setting.qiHuHuXi..'胡起胡'.. breakString(needBreak)
        end
        if setting.calculationTunMode ~= nil then
            if setting.calculationTunMode == 0 then
                msg = msg..'3息1囤'.. breakString(needBreak)
            elseif setting.calculationTunMode == 1 then
                msg = msg..'1息1囤'.. breakString(needBreak)
            end
        end
        if not isShowPlay then
            if setting.calculationFanMode ~= nil then
                if setting.calculationFanMode == 0 then
                    msg = msg..'起胡3息1囤'.. breakString(needBreak)
                elseif setting.calculationFanMode == 1 then
                    msg = msg..'起胡3息3囤'.. breakString(needBreak)
                elseif setting.calculationFanMode == 2 then
                    msg = msg..'起胡6息1囤'.. breakString(needBreak)
                elseif setting.calculationFanMode == 3 then
                    msg = msg..'起胡6息6囤'.. breakString(needBreak)
                elseif setting.calculationFanMode == 4 then
                    msg = msg..'起胡6息2囤'.. breakString(needBreak)
                elseif setting.calculationFanMode == 5 then
                    msg = msg..'起胡9息1囤'.. breakString(needBreak)
                elseif setting.calculationFanMode == 6 then
                    msg = msg..'起胡9息3囤'.. breakString(needBreak)
                elseif setting.calculationFanMode == 7 then
                    msg = msg..'起胡9息9囤'.. breakString(needBreak)
                end
            end
        end
        
        if setting.classic ~= nil then
            if setting.classic == 0 then
                msg = msg..'平胡'.. breakString(needBreak)
            elseif setting.classic == 1 then
                msg = msg..'红黑点'.. breakString(needBreak)
            elseif setting.classic == 2 then
                msg = msg..'红黑点2番'.. breakString(needBreak)
            end
        end
        if setting.ziMoFan ~= nil then
            if setting.ziMoFan == 2 then
                msg = msg..'自摸2番'.. breakString(needBreak)
            end
        end
        if setting.choiceHu ~= nil then
            if setting.choiceHu == 1 then
                msg = msg..'有胡必胡'.. breakString(needBreak)
            end
            if not isShowPlay then
                if setting.choiceHu == 2 then
                    msg = msg..'放炮必胡'.. breakString(needBreak)
                end
            end
        end
        if setting.daXiaoZiHu ~= nil then
            if setting.daXiaoZiHu then
                msg = msg..'大小红胡'.. breakString(needBreak)
            end
        end
        if setting.play21 ~= nil then
            if not setting.play21 then
                msg = msg..'15张玩法'.. breakString(needBreak)
            end
        end
        if setting.maoHuHuXi ~= nil then
            if setting.maoHuHuXi == 0 then
                msg = msg..'无毛胡'.. breakString(needBreak)
            else
                msg = msg..'毛胡'..setting.maoHuHuXi..'胡'.. breakString(needBreak)
            end
        end
        if setting.huangZhuangFen ~= nil then
            if setting.huangZhuangFen == 0 then
                msg = msg .. '荒庄不扣分'.. breakString(needBreak)
            else
                msg = msg .. '荒庄扣'..setting.huangZhuangFen..'分'.. breakString(needBreak)
            end
        end
        if setting.huangKeepBanker ~= nil and setting.huangKeepBanker then
            msg = msg ..'荒庄继续坐庄'.. breakString(needBreak)
        end
    end
    if setting.size ~= nil and setting.size == 2 then
        if setting.chou ~= nil then
            if setting.chou == 0 then
                msg = msg .. '不抽牌'.. breakString(needBreak)
            else
                msg = msg .. '抽'..setting.chou..'张'.. breakString(needBreak)
            end
        end
    end
    if roomType == proxy_pb.CZZP or roomType == 'CZZP' then
        if setting.piao~=nil then
            if setting.piao == 0 then
                msg = msg .. '不飘分'.. breakString(needBreak)
            elseif setting.piao == 1 then
                msg = msg .. '飘1/2/3'.. breakString(needBreak)
            elseif setting.piao == 2 then
                msg = msg .. '飘2/3/5'.. breakString(needBreak)
            elseif setting.piao == 3 then
                msg = msg .. '飘3/5/10'.. breakString(needBreak)
            end
        end
    end
    if roomType == proxy_pb.XXGHZ or roomType == 'XXGHZ' then
    else
        if setting.niao~=nil then
            if setting.niao==true then
                if setting.niaoValue ~= nil then
                    msg = msg..'打鸟'..setting.niaoValue..'分'..breakString(needBreak)
                else
                    msg = msg..'打鸟'..breakString(needBreak)
                end
            end
        end
    end

    if isShowPlay==true then
    else
        if setting.size ~= nil and setting.size == 2 then
            if setting.choiceDouble ~= nil then
                if setting.choiceDouble then
                    if setting.doubleScore ~= nil then
                        if setting.doubleScore == 0 then
                            if setting.multiple ~= nil then
                                msg = msg ..'不限分,翻'..setting.multiple..'倍'.. breakString(needBreak)
                            end
                        else
                            if setting.multiple ~= nil then
                                msg = msg ..'小于'..setting.doubleScore..'分,翻'..setting.multiple..'倍'.. breakString(needBreak)
                            end
                        end
                    end
                    if roomType == proxy_pb.HYLHQ or roomType == proxy_pb.HYSHK then
                        if setting.singleRoundDouble then
                            msg = msg..'单局翻倍'..breakString(needBreak)
                        else
                            msg = msg..'满局翻倍'..breakString(needBreak)
                        end
                    end
                else
                    msg = msg..'不翻倍'..breakString(needBreak)
                end
            end
        end
    end
    if setting.size ~= nil and setting.size == 2 then
        if setting.resultScore ~= nil and setting.resultScore then
            if setting.resultLowerScore ~= nil and setting.resultAddScore ~= nil then
                msg = msg.."低于"..setting.resultLowerScore..'分'..'加'..setting.resultAddScore..'分'..breakString(needBreak) 
            end
        end
    end
    if setting.trusteeship ~= nil then
        if setting.trusteeship == 0 then
           -- msg = msg .. "不托管"--..breakString(needBreak);
        else
            msg = msg..(setting.trusteeship/60).."分钟后托管"--..breakString(needBreak);
            if setting.trusteeshipDissolve~=nil then
                if setting.trusteeshipDissolve==true then
                    msg = msg .. breakString(needBreak) .. "本局解散"..breakString(needBreak);
                elseif setting.trusteeshipDissolve == false and setting.trusteeshipRound ~= nil and setting.trusteeshipRound == 0 then
                    msg = msg .. breakString(needBreak) .. "满局解散"..breakString(needBreak);
                elseif setting.trusteeshipRound ~= nil and setting.trusteeshipRound == 3 then
                    msg = msg .. breakString(needBreak) .. "3局解散"..breakString(needBreak);
                end
            end
        end
    end
	if isNoShowGps then
    else
        if setting.openIp then
            msg = msg .. "ip检测" .. breakString(needBreak) 
        end
        if setting.openGps then
            msg = msg .. "gps检测"
        end
    end
	if string.sub(msg, -1) == breakString(needBreak) then
		msg = string.sub(msg, 1, string.len(msg)-1)
	end

    return msg
end

function getWanFaText_pdk(setting, NoNeedPayInfo,needBreak,needGameName,NoNeedPlayerNum,isNoShowGps)
    local msg = ''
    if needGameName and setting.cardCount ~= nil then
        msg = msg .. '跑得快'..setting.cardCount..'张'..breakString(needBreak)
    end
    if NoNeedPlayerNum then
    else 
        if setting.size ~= nil then
            if setting.size == 3 then
                msg = msg .. '3人玩'..breakString(needBreak)
            else
                msg = msg .. '2人玩'..breakString(needBreak)
            end
        end
    end
    if setting.rounds ~= nil then
        msg = msg .. setting.rounds .. '局'..breakString(needBreak)
    end
   
    if NoNeedPayInfo==true then
        -- body
    else
        if setting.paymentType ~= nil then
            if setting.paymentType == 0 then
                msg = msg..' 房主支付'..breakString(needBreak)
            elseif setting.paymentType == 1 then
                msg = msg..' AA支付'..breakString(needBreak)
            elseif setting.paymentType == 2 then
                msg = msg..' 赢家支付'..breakString(needBreak)
            end
        end
    end
    --[[if setting.showCount~=nil then
        if setting.showCount==true then
            msg = msg..' 显示牌数'..breakString(needBreak)
        else
            msg = msg..' 不显示牌数'..breakString(needBreak)
        end
    end--]]
    if setting.firstPlay ~= nil then
        if setting.firstPlay == pdk_pb.OWNER or setting.firstPlay == 'OWNER' then --pdk_pb.OWNER then
            msg = msg..' 首局房主先出'..breakString(needBreak)
        elseif setting.firstPlay == pdk_pb.S3 or setting.firstPlay == 'S3' then --pdk_pb.S3 then
            msg = msg..' 黑桃三先出'..breakString(needBreak)
        elseif setting.firstPlay == pdk_pb.S3_IN or setting.firstPlay == 'S3_IN' then --pdk_pb.S3_IN then
            msg = msg..' 黑桃三必先出'..breakString(needBreak)
        else
            msg = msg..'首局随机先出'..breakString(needBreak)
        end
    end
    if setting.remainBanker~=nil then
        if setting.remainBanker==true then
            msg = msg..' 赢家为庄'..breakString(needBreak)
        else
            msg = msg..' 延续首轮抢庄规则'..breakString(needBreak)
        end
    end
    if setting.bombSplit~=nil then
        if setting.bombSplit==true then
            msg = msg..' 炸弹可拆'..breakString(needBreak)
        else
            msg = msg..' 炸弹不可拆'..breakString(needBreak)
        end
    end
    if setting.bombBelt~=nil then
        if setting.bombBelt==true then
            msg = msg..' 炸弹四带三'..breakString(needBreak)
        else
            --setting_text = setting_text..' 炸弹不可四带三'
        end
    end
    if setting.bombBeltTwo~=nil then
        if setting.bombBeltTwo==true then
            msg = msg..' 炸弹四带二'..breakString(needBreak)
        else
            --setting_text = setting_text..' 炸弹不可四带三'
        end
    end
    if setting.bombAAA~=nil then
        if setting.bombAAA==true then
            msg = msg..' 3A当炸弹'..breakString(needBreak)
        else
            --setting_text = setting_text..' 炸弹不可四带三'
        end
    end
    if setting.singleProtect~=nil then
        if setting.singleProtect==true then
            msg = msg..' 单张全关保护'..breakString(needBreak)
        else
            --setting_text = setting_text..' 不单张全关保护'
        end
    end
    if setting.preventJointly~=nil then
        if setting.preventJointly==true then
            msg = msg..' 防合手'..breakString(needBreak)
        else
            --setting_text = setting_text..' 不防合手'
        end
    end
    if setting.floatScore~=nil then
        if setting.floatScore==true then
            msg = msg..' 飘分'..breakString(needBreak)
        else
            --setting_text = setting_text..' 不飘分'
        end
    end
	
    --print("roomData.setting.redTen",roomData.setting.redTen)
    if setting.redTen ~= nil then
        if setting.redTen == -1 then
            msg = msg..' 红十翻倍'..breakString(needBreak)
        elseif setting.redTen > 0 then
            msg = msg..' 红十加'..setting.redTen..'分'..breakString(needBreak)
        end
    end
	
    if setting.hitBird ~=nil then
        if setting.hitBird == 0 then
            --msg = msg .. "不打鸟"..breakString(needBreak);
        else
            msg = msg.."打鸟"..setting.hitBird..'分'..breakString(needBreak);
        end
    end
    
    if setting.size ~= nil and setting.size == 2 then
        if setting.resultScore ~= nil and setting.resultScore then
            if setting.resultLowerScore ~= nil and setting.resultAddScore ~= nil then
                msg = msg.."低于"..setting.resultLowerScore..'分'..'加'..setting.resultAddScore..'分'..breakString(needBreak) 
            end
        end
    end

    if setting.choiceDouble then
        if setting.doubleScore == 0 then
            msg = msg .. '不限分,翻'..setting.multiple..'倍'..breakString(needBreak);
        else
            msg = msg .. '小于'..setting.doubleScore..'分,翻'..setting.multiple..'倍'..breakString(needBreak);
        end
    end

    if setting.trusteeship ~= nil then
        if setting.trusteeship == 0 then
           -- msg = msg .. "不托管"--..breakString(needBreak);
        else
            msg = msg..(setting.trusteeship/60).."分钟后托管"--..breakString(needBreak);
            if setting.trusteeshipDissolve~=nil then
                if setting.trusteeshipDissolve==true then
                    msg = msg .. breakString(needBreak) .. "本局解散"..breakString(needBreak);
                elseif setting.trusteeshipDissolve == false and setting.trusteeshipRound ~= nil and setting.trusteeshipRound == 0 then
                    msg = msg .. breakString(needBreak) .. "满局解散"..breakString(needBreak);
                elseif setting.trusteeshipRound ~= nil and setting.trusteeshipRound == 3 then
                    msg = msg .. breakString(needBreak) .. "3局解散"..breakString(needBreak);
                end
            end
        end
    end
	
	if isNoShowGps then
    else
        if setting.openIp then
            msg = msg .. "ip检测" .. breakString(needBreak) 
        end
        if setting.openGps then
            msg = msg .. "gps检测"
        end
    end
	if string.sub(msg, -1) == breakString(needBreak) then
		msg = string.sub(msg, 1, string.len(msg)-1)
	end

    return msg
end


--获得麻将规则字符串
function GetMJRuleText(setting,needBreak,NoNeedPayInfo, needGameName,NoNeedPlayerNum,isNoShowGps)
    local ruleStr = ''
    local roomType
    if setting.roomType~=nil and setting.roomType~='' then
        roomType=setting.roomType
    else
        if setting.roomTypeValue ~= nil then
            roomType=setting.roomTypeValue
        end
    end
    if needGameName and roomType ~= nil then
        if roomType == proxy_pb.ZZM then
            ruleStr = ruleStr..'转转麻将'..breakString(needBreak)
        elseif roomType == proxy_pb.HZM then
            ruleStr = ruleStr..'红中麻将'..breakString(needBreak)
        elseif roomType == proxy_pb.CSM then
            ruleStr = ruleStr..'长沙麻将'..breakString(needBreak)
        end
    end
    if roomType == proxy_pb.ZZM or roomType == 'ZZM' then
        if NoNeedPlayerNum then
        else
            if setting.size ~= nil then
                ruleStr = ruleStr .. setting.size..'人'..breakString(needBreak);
            end
            
        end
        if setting.rounds ~= nil then
            ruleStr = ruleStr .. setting.rounds..'局'..breakString(needBreak);
        end

        if NoNeedPayInfo then
        else
            if setting.paymentType ~= nil then
                if setting.paymentType == 0 then
                    ruleStr = ruleStr..' 房主支付'..breakString(needBreak)
                elseif setting.paymentType == 1 then
                    ruleStr = ruleStr..' AA支付'..breakString(needBreak)
                elseif setting.paymentType == 2 then
                    ruleStr = ruleStr..' 赢家支付'..breakString(needBreak)
                end
            end
        end


        if setting.baseScore ~= nil then
            ruleStr = ruleStr ..'底分'..setting.baseScore..'分'.. breakString(needBreak)
        end
        --
        --if setting.huAsBanker then
        --    ruleStr = ruleStr.."胡牌为庄"..breakString(needBreak);
        --else
        --    ruleStr = ruleStr.."非胡牌为庄"..breakString(needBreak);
        --end
        if setting.bird159~=nil and setting.bird159==true then
            ruleStr = ruleStr.."159抓鸟"..breakString(needBreak);
            if setting.bird then
                ruleStr = ruleStr.."抓"..setting.bird.."鸟"..breakString(needBreak);
            end
        elseif setting.birdBankerStart~=nil and setting.birdBankerStart==true then
            ruleStr = ruleStr.."庄家方位"..breakString(needBreak);
            if setting.bird then
                ruleStr = ruleStr.."抓"..setting.bird.."鸟"..breakString(needBreak);
            end
        elseif setting.birdWinStart~=nil and setting.birdWinStart==true then
            ruleStr = ruleStr.."赢家方位"..breakString(needBreak);
            if setting.bird then
                ruleStr = ruleStr.."抓"..setting.bird.."鸟"..breakString(needBreak);
            end
        elseif setting.birdAllHit~=nil and setting.birdAllHit==true then
            ruleStr = ruleStr.."一鸟全中"..breakString(needBreak);
        else
            ruleStr = ruleStr.."不抓鸟"..breakString(needBreak);
        end

        if setting.dianPaoHu~=nil then
            if setting.dianPaoHu==true then
                ruleStr = ruleStr.."可点炮胡"..breakString(needBreak);
            else
                ruleStr = ruleStr.."不可点炮胡"..breakString(needBreak);
            end
        end
        if setting.bankerAddOne~=nil then
            if  setting.bankerAddOne==true then
                ruleStr = ruleStr.."庄闲"..breakString(needBreak);
            end
        end
        if setting.huSevenPairs~=nil then
            if setting.huSevenPairs==true then
                ruleStr = ruleStr.."可胡七对"..breakString(needBreak);
            end
        end
        if setting.huangZhuangHuangGang~=nil then
            if setting.huangZhuangHuangGang==true then
                ruleStr = ruleStr.."荒庄荒杠"..breakString(needBreak);
                -- else
                --    ruleStr = ruleStr.."点杠杠开不包三家"..breakString(needBreak);
            end
        end




        --
        --if setting.jiaJiangHu then
        --    ruleStr = ruleStr.."开启假将胡"..breakString(needBreak);
        --else
        --    ruleStr = ruleStr.."禁止假将胡"..breakString(needBreak);
        --end
        if setting.floatScore~=nil then
            if setting.floatScore==true then
                ruleStr = ruleStr.."飘分"..breakString(needBreak);
                -- else
                --    ruleStr = ruleStr.."禁止假将胡"..breakString(needBreak);
            end
        end
        if setting.scoreMingGangInc~=nil then
            if setting.scoreMingGangInc==true then
                ruleStr = ruleStr.."点杠算3分"..breakString(needBreak);
            end
        end

    elseif roomType == proxy_pb.CSM or roomType == 'CSM' then
        if setting.rounds ~= nil then
            ruleStr = ruleStr .. setting.rounds..'局'..breakString(needBreak); 
        end
        
        if NoNeedPlayerNum then
        else
            if setting.size ~= nil then
                ruleStr = ruleStr .. setting.size..'人'..breakString(needBreak);
            end
            
        end
        if setting.paymentType ~= nil then
            if setting.paymentType == 0 then
                ruleStr = ruleStr.."房主支付"..breakString(needBreak);
            elseif setting.paymentType == 2 then
                ruleStr = ruleStr.."赢家支付"..breakString(needBreak);
            end
        end

        if setting.bird ~= nil then
            if setting.bird == 0 then
                ruleStr = ruleStr.."不抓鸟"..breakString(needBreak);
            else
                if setting.birdWinStart ~= nil then
                    if setting.birdWinStart==true then
                        ruleStr = ruleStr.."赢家方位"..breakString(needBreak)
                    end
                end
                if setting.bird13579 ~= nil then
                    if setting.bird13579==true then
                        ruleStr = ruleStr.."13579抓鸟"..breakString(needBreak)
                    end
                end
                if setting.birdCompute~=nil then
                    if setting.birdCompute==true then
                        ruleStr = ruleStr.."中鸟加倍"..breakString(needBreak);
                    else
                        ruleStr = ruleStr.."一鸟一分"..breakString(needBreak);
                    end
                end
                ruleStr = ruleStr.."抓"..setting.bird.."鸟"..breakString(needBreak);
            end
        end

        if setting.bankerAddOne~=nil then
            if  setting.bankerAddOne==true then
                ruleStr = ruleStr.."庄闲"..breakString(needBreak);
            end
        end

        if setting.tianDiHu~=nil then
            if setting.tianDiHu==true then
                ruleStr = ruleStr.."天地胡"..breakString(needBreak);
            end
        end
        print("setting.quanQiuRen:"..tostring(setting.quanQiuRen));
        if setting.quanQiuRen ~= nil then
            if setting.quanQiuRen == true then
                ruleStr = ruleStr.."全求人"..breakString(needBreak);
            end
        else
            ruleStr = ruleStr.."全求人"..breakString(needBreak);
        end

        if setting.menQing ~= nil then
            if setting.menQing == true then
                if setting.menQingZiMo ~= nil and setting.menQingZiMo == true then
                    ruleStr = ruleStr.."门清自摸"..breakString(needBreak);
                else  
                    ruleStr = ruleStr.."门清"..breakString(needBreak);  
                end
            end
        end

        if setting.mustHu ~= nil then
            if setting.mustHu == true then
                ruleStr = ruleStr.."有胡必胡"..breakString(needBreak);
            end
        end
        if setting.missGuoHu ~= nil then
            if setting.missGuoHu == true then
                ruleStr = ruleStr.."不过手不能胡"..breakString(needBreak);
            end
        end
        if setting.bird13579 ~= nil then
            if setting.bird13579 == true then
                ruleStr = ruleStr.."13579中鸟"..breakString(needBreak);
            end
        end

        if setting.queYiMen ~= nil then
            if setting.queYiMen == true then
                ruleStr = ruleStr.."缺一门"..breakString(needBreak);
            end
        end

        if setting.floatScore~=nil then
            if setting.floatScore==true then
                ruleStr = ruleStr.."飘分"..breakString(needBreak);
            end
        end
        if setting.fixedFloatScore~=nil then
            if setting.fixedFloatScore~=0 then
                ruleStr = ruleStr.."固定飘"..setting.fixedFloatScore.."分"..breakString(needBreak);
            end
        end
        
        if setting.shQueYiSe~=nil then
            if setting.shQueYiSe==true then
                ruleStr = ruleStr.."缺一色"..breakString(needBreak);
            end
        end
        if setting.shBanBanHu~=nil then
            if setting.shBanBanHu==true then
                ruleStr = ruleStr.."板板胡"..breakString(needBreak);
            end
        end
        if setting.shJieJieGao~=nil then
            if setting.shJieJieGao==true then
                ruleStr = ruleStr.."节节高"..breakString(needBreak);
            end
        end
        if setting.shYiZhiHua~=nil then
            if setting.shYiZhiHua then
                ruleStr = ruleStr.."一枝花"..breakString(needBreak);
            end
        end
        if setting.shSanTong~=nil then
            if setting.shSanTong==true then
                ruleStr = ruleStr.."三同"..breakString(needBreak);
            end
        end
        if setting.shJinTongYuNv~=nil then
            if setting.shJinTongYuNv==true then
                ruleStr = ruleStr.."金童玉女"..breakString(needBreak);
            end
        end
        if setting.shDaSiXi~=nil then
            if setting.shDaSiXi==true then
                ruleStr = ruleStr.."大四喜"..breakString(needBreak);
            end
        end
        if setting.shLiuLiuShun~=nil then
            if setting.shLiuLiuShun==true then
                ruleStr = ruleStr.."六六顺"..breakString(needBreak);
            end
        end
        if setting.ztDaSiXi~=nil then
            if setting.ztDaSiXi==true then
                print("setting.ztDaSiXi:"..tostring(setting.ztDaSiXi));
                ruleStr = ruleStr.."中途大四喜"..breakString(needBreak);
            end
        end
        if setting.ztLiuLiuShun~=nil then
            if setting.ztLiuLiuShun==true then
                print("setting.ztLiuLiuShun:"..tostring(setting.ztLiuLiuShun));
                ruleStr = ruleStr.."中途六六顺"..breakString(needBreak);
            end
        end
        if setting.gangMahjongCount~=nil then
            if setting.gangMahjongCount==true then
                ruleStr = ruleStr.."开杠牌数"..setting.gangMahjongCount..breakString(needBreak);
            end
        end
        if setting.cappingScore~=nil then
            if setting.cappingScore==0 then
                ruleStr = ruleStr.."不封顶"..breakString(needBreak);
            else
                ruleStr = ruleStr..setting.cappingScore.."分封顶"..breakString(needBreak);
            end
        end
    elseif roomType == proxy_pb.HZM or roomType == 'HZM' then
        if setting.rounds ~= nil then
            ruleStr = ruleStr .. setting.rounds..'局'..breakString(needBreak);
        end
        
        if NoNeedPlayerNum then
        else
            if setting.size ~= nil then
                ruleStr = ruleStr .. setting.size..'人'..breakString(needBreak);
            end
           
        end
        if setting.paymentType ~= nil then
            if setting.paymentType == 0 then
                ruleStr = ruleStr.."房主支付"..breakString(needBreak);
            elseif setting.paymentType == 2 then
                ruleStr = ruleStr.."赢家支付"..breakString(needBreak);
            end
        end
        if setting.baseScore ~= nil then
            ruleStr = ruleStr ..'底分'..setting.baseScore..'分'.. breakString(needBreak)
        end
        if setting.hongZhongCount ~= nil then
            ruleStr = ruleStr..setting.hongZhongCount.."红中"..breakString(needBreak);
        end

        if setting.dianPaoHu ~= nil then 
            if setting.dianPaoHu == true then 
                ruleStr = ruleStr.."可点炮胡"..breakString(needBreak);
            end
        end

        if setting.huSevenPairs~=nil then
            if setting.huSevenPairs==true then
                ruleStr = ruleStr.."可胡七对"..breakString(needBreak);
            end
        end
        if setting.huangZhuangHuangGang~=nil then
            if setting.huangZhuangHuangGang==true then
                ruleStr = ruleStr.."荒庄荒杠"..breakString(needBreak);
                -- else
                --    ruleStr = ruleStr.."点杠杠开不包三家"..breakString(needBreak);
            end
        end
        if setting.bankerAddOne~=nil then
            if  setting.bankerAddOne==true then
                ruleStr = ruleStr.."庄闲"..breakString(needBreak);
            end
        end
        if setting.mustHu~=nil then
            if setting.mustHu==true then
                ruleStr = ruleStr.."有胡必胡"..breakString(needBreak);
            end
        end
        if setting.floatScore~=nil then
            if setting.floatScore==true then
                ruleStr = ruleStr.."飘分"..breakString(needBreak);
            end
        end
        if setting.scoreHongZhongNon~=nil then
            if setting.scoreHongZhongNon==true then
                ruleStr = ruleStr.."无红中加倍"..breakString(needBreak);
                if setting.scoreHongZhongNonNiaoBanker~=nil then
                    if setting.scoreHongZhongNonNiaoBanker==true then
                        ruleStr = ruleStr.."加倍所有分"..breakString(needBreak);
                    end
                end
            end
        end
        if setting.hongZhongNonJiePao~=nil then
            if setting.hongZhongNonJiePao==true then
                ruleStr = ruleStr.."有红中不接炮"..breakString(needBreak);
            end
        end

        if setting.scoreMingGangInc~=nil then
            if setting.scoreMingGangInc==true then
                ruleStr = ruleStr.."点杠算3分"..breakString(needBreak);
            end
        end

        if setting.birdAllHit~=nil and setting.birdAllHit==true then
            ruleStr = ruleStr.."一鸟全中"..breakString(needBreak);
            ruleStr = ruleStr.."抓鸟"..setting.scoreBird.."分"..breakString(needBreak);
        elseif setting.birdBankerStart~=nil and setting.birdBankerStart==true then
            ruleStr = ruleStr.."庄家方位"..breakString(needBreak);
            ruleStr = ruleStr..setting.bird.."鸟"..breakString(needBreak);
            ruleStr = ruleStr.."抓鸟"..setting.scoreBird.."分"..breakString(needBreak);
        elseif setting.birdWinStart~=nil and setting.birdWinStart==true then
            ruleStr = ruleStr.."赢家方位"..breakString(needBreak);
            ruleStr = ruleStr..setting.bird.."鸟"..breakString(needBreak);
            ruleStr = ruleStr.."抓鸟"..setting.scoreBird.."分"..breakString(needBreak);
        elseif setting.bird159~=nil and setting.bird159==true then
            ruleStr = ruleStr.."159抓鸟"..breakString(needBreak);
            ruleStr = ruleStr..setting.bird.."鸟"..breakString(needBreak);
            ruleStr = ruleStr.."抓鸟"..setting.scoreBird.."分"..breakString(needBreak);
        else
            ruleStr = ruleStr.."不抓鸟"..breakString(needBreak);
        end

        if setting.scoreQiangGangMo~=nil and setting.scoreQiangGangMo==true then
            ruleStr = ruleStr.."抢杠算自摸"..breakString(needBreak);
            if setting.scoreQiangGangInc~=nil and setting.scoreQiangGangInc==true then
                ruleStr = ruleStr.."抢杠全包"..breakString(needBreak);
            end
        end

        if setting.scoreQiangGangJiePao~=nil and setting.scoreQiangGangJiePao==true then
            ruleStr = ruleStr.."抢杠算点炮"..breakString(needBreak);
            if setting.scoreQiangGangHongZhong~=nil and setting.scoreQiangGangHongZhong==true then
                ruleStr = ruleStr.."有红中可抢杠"..breakString(needBreak);
            end
        end
    end

    if (setting.size ~= nil and setting.size == 2) or (setting.minorityMode~=nil and setting.minorityMode==true) then
        if setting.choiceDouble then
            if setting.doubleScore == 0 then
                ruleStr = ruleStr .. '不限分,翻'..setting.multiple..'倍'..breakString(needBreak);
            else
                ruleStr = ruleStr .. '小于'..setting.doubleScore..'分,翻'..setting.multiple..'倍'..breakString(needBreak)
            end
        end
        if setting.resultScore ~= nil and setting.resultScore then
            if setting.resultLowerScore ~= nil and setting.resultAddScore ~= nil then
                ruleStr = ruleStr.."低于"..setting.resultLowerScore..'分'..'加'..setting.resultAddScore..'分'..breakString(needBreak) 
            end
        end
    end

    if setting.trusteeship ~= nil then
        if setting.trusteeship == 0 then
           -- msg = msg .. "不托管"--..breakString(needBreak);
        else
            ruleStr = ruleStr..(setting.trusteeship/60).."分钟后托管"--..breakString(needBreak);
            if setting.trusteeshipDissolve~=nil then
                if setting.trusteeshipDissolve==true then
                    ruleStr = ruleStr .. breakString(needBreak) .. "本局解散"..breakString(needBreak);
                elseif setting.trusteeshipDissolve == false and setting.trusteeshipRound ~= nil and setting.trusteeshipRound == 0 then
                    ruleStr = ruleStr .. breakString(needBreak) .. "满局解散"..breakString(needBreak);
                elseif setting.trusteeshipRound ~= nil and setting.trusteeshipRound == 3 then
                    ruleStr = ruleStr .. breakString(needBreak) .. "3局解散"..breakString(needBreak);
                end
            end
        end
    end
	if isNoShowGps then
    else
        if setting.openIp then
            ruleStr = ruleStr .. "ip检测" .. breakString(needBreak) 
        end
        if setting.openGps then
            ruleStr = ruleStr .. "gps检测"
        end
	end
    return ruleStr;
end

--获得新化炸弹的玩法规则描述
--setting 设置的json对象
--needBreak 是否需要换行
function getXHZDRuleString(setting,needBreak,NoNeedPayInfo, needGameName,isNoShowGps)
    local msg = "";
    
    if needGameName then
        msg = msg .. '新化炸弹'..breakString(needBreak)
    end
    if NoNeedPayInfo then
    else
        if setting.size ~= nil then
            if setting.size == 2 then 
                msg = msg .. '2人玩'..breakString(needBreak);
            else
                msg = msg .. '4人玩'..breakString(needBreak);
            end
        end
    end
    
    if setting.rounds~=nil then
        if setting.rounds == 4 then 
            msg  = msg..'4局'..breakString(needBreak);
        elseif setting.rounds == 8 then 
            msg = msg.."8局"..breakString(needBreak);
        elseif setting.rounds == 16 then 
            msg = msg.."16局"..breakString(needBreak);
        end
    end

    if NoNeedPayInfo then
    else
        if setting.paymentType ~= nil then
            print('setting.paymentType : '..setting.paymentType)
            if setting.paymentType == 0 then
                msg = msg..' 房主支付'..breakString(needBreak)
            elseif setting.paymentType == 1 then
                msg = msg..' AA支付'..breakString(needBreak)
            elseif setting.paymentType == 2 then
                msg = msg..' 赢家支付'..breakString(needBreak)
            end
        end
    end

    if setting.happyScoreAdd~=nil then
        if setting.happyScoreAdd==true then
            msg = msg..'喜分算加分'..breakString(needBreak);
        else
            msg = msg..'喜分算乘分'..breakString(needBreak);
        end
    end

    if NoNeedPayInfo then
    else
        if setting.canStraight~=nil then
            if setting.canStraight == true then 
                msg = msg.."可打顺子"..breakString(needBreak);
                UnityEngine.PlayerPrefs.SetInt('XHZDcanStraight', 1)
            else
                UnityEngine.PlayerPrefs.SetInt('XHZDcanStraight', 0)
            end
        end
    end
    
    if setting.bomb3AsHappy~=nil then
        if setting.bomb3AsHappy == true then 
            msg = msg.."三个炸弹算一个喜分"..breakString(needBreak);
        end
    end

    if setting.size == 2 then
        if setting.baseScore~=nil and setting.baseScore ~=0 then
            msg = msg.."底分"..setting.baseScore..'分'..breakString(needBreak);
        end
    
        if setting.niao ~=nil then
            if setting.niao == 0 then
            else
                msg = msg.."打鸟"..setting.niao..'分'..breakString(needBreak);
            end
        end

        if NoNeedPayInfo then
        else
            if setting.multiple~=nil then
                if setting.multiple == 1 then 
                    msg = msg.."半干"..breakString(needBreak);
                elseif setting.multiple == 2 then 
                    msg = msg.."全干"..breakString(needBreak);
                elseif setting.multiple == 0  then 
                    msg = msg.."无全干半干"..breakString(needBreak);
                end
            end
        end
    end
    if setting.trusteeship ~= nil then
        if setting.trusteeship == 0 then
           -- msg = msg .. "不托管"--..breakString(needBreak);
        else
            msg = msg..(setting.trusteeship/60).."分钟后托管"--..breakString(needBreak);
            if setting.trusteeshipDissolve~=nil then
                if setting.trusteeshipDissolve==true then
                    msg = msg .. breakString(needBreak) .. "本局解散"..breakString(needBreak);
                elseif setting.trusteeshipDissolve == false and setting.trusteeshipRound ~= nil and setting.trusteeshipRound == 0 then
                    msg = msg .. breakString(needBreak) .. "满局解散"..breakString(needBreak);
                elseif setting.trusteeshipRound ~= nil and setting.trusteeshipRound == 3 then
                    msg = msg .. breakString(needBreak) .. "3局解散"..breakString(needBreak);
                end
            end
        end
    end
	if isNoShowGps then
    else
        if setting.openIp then
            msg = msg .. "ip检测" .. breakString(needBreak) 
        end
        if setting.openGps then
            msg = msg .. "gps检测"
        end
    end
	if string.sub(msg, -1) == breakString(needBreak) then
		msg = string.sub(msg, 1, string.len(msg)-1)
	end

    return msg;
end

--获取溆浦老牌的设置字符串
function GetXPLPRuleText(setting, needBreak, NoNeedPayInfo,  needGameName, NoNeedPlayerNum,isNoShowGps)
    local ruleString = "";
    if needGameName then
        ruleString = ruleString .. "溆浦老牌"..breakString(needBreak);
    end

    if not NoNeedPlayerNum and setting.size ~= nil then
        ruleString = ruleString .. setting.size.. "人"..breakString(needBreak);
    end

    if setting.rounds~=nil then
        if setting.rounds == 6 then 
            ruleString  = ruleString..'6局'..breakString(needBreak);
        elseif setting.rounds == 8 then 
            ruleString = ruleString.."8局"..breakString(needBreak);
        elseif setting.rounds == 12 then 
            ruleString = ruleString.."12局"..breakString(needBreak);
        elseif setting.rounds == 16 then 
            ruleString = ruleString.."16局"..breakString(needBreak);
        end
    end

    if NoNeedPayInfo == true then
        if setting.paymentType ~= nil and setting.paymentType == 0 then
            ruleString = ruleString .."房主支付"..breakString(needBreak);
        else
            ruleString = ruleString .. "赢家支付"..breakString(needBreak);
        end
    end

    if setting.bankerRule ~= nil then 
        if setting.bankerRule == true then 
            ruleString = ruleString .."首局随机坐庄"..breakString(needBreak);
        else
            ruleString = ruleString .."先进房先坐庄"..breakString(needBreak);
        end
    end

    if setting.baseScore ~= nil then 
        ruleString = ruleString .."底分"..setting.baseScore.."分"..breakString(needBreak);
    end

    if setting.huPattern ~= nil then 
        if setting.huPattern == true then 
            ruleString = ruleString .."必须自摸"..breakString(needBreak);
        else
            ruleString = ruleString .."可点炮"..breakString(needBreak);
        end
    end
    if setting.takeMask ~= nil then 
        if setting.takeMask then 
            ruleString = ruleString.."带花"..breakString(needBreak);
        end
    end

    if setting.bankerPlayer ~= nil then 
        if setting.bankerPlayer then 
            ruleString = ruleString.."庄闲"..breakString(needBreak);
        end
    end
   
    if setting.huMust ~= nil then 
        if setting.huMust then 
            ruleString = ruleString.."有胡必胡"..breakString(needBreak);
        end
    end
    if setting.pengNoChu ~= nil then 
        if setting.pengNoChu then 
            ruleString = ruleString.."碰牌后不可出同张"..breakString(needBreak);
        end
    end
    if setting.operateConfirm ~= nil then 
        if setting.operateConfirm then 
            ruleString = ruleString.."吃碰确认"..breakString(needBreak);
        end
    end
    if setting.chiNo ~= nil then 
        if setting.chiNo then 
            ruleString = ruleString.."不可吃牌"..breakString(needBreak);
        end
    end

    if setting.chiNoChu ~= nil then 
        if (not setting.chiNo) and setting.chiNoChu then 
            ruleString = ruleString.."吃牌后不可出同张"..breakString(needBreak);
        end
    end

    if setting.guChou ~= nil then 
        if (setting.size > 2) and setting.guChou then 
            ruleString = ruleString.."可箍臭"..breakString(needBreak);
        end
    end

    if setting.chong ~= nil then 
        if setting.chong == 0 then 
            ruleString = ruleString.."不可冲"..breakString(needBreak);
        elseif setting.chong == 1 then 
            ruleString = ruleString.."可冲"..breakString(needBreak);
        elseif setting.chong == 2 then 
            ruleString = ruleString.."必冲"..breakString(needBreak);
        elseif setting.chong == 3 then 
            ruleString = ruleString.."必须冲后可冲"..breakString(needBreak);
        elseif setting.chong == 4 then 
            ruleString = ruleString.."冲上不冲下"..breakString(needBreak);
        end
    end

    if setting.chongType ~= nil then 
        if setting.chong~=0 and setting.chongType == 1 then 
            ruleString = ruleString .."冲1234"..breakString(needBreak);
        elseif setting.chong~=0 and setting.chongType == 2 then
            ruleString = ruleString .."冲2468"..breakString(needBreak);
        end
    end

    if setting.chongNum ~= nil then 
        if setting.chong ~= 0 then 
            ruleString = ruleString ..(setting.chongType*setting.chongNum).."分起"..breakString(needBreak);
        end
    end

    if setting.chongMode ~= nil then 
        if setting.chong~=0 and setting.chongMode == 1 then 
            ruleString = ruleString .."底分加算冲分"..breakString(needBreak);
        elseif setting.chong~=0 and setting.chongMode == 2 then
            ruleString = ruleString .."底分乘算冲分"..breakString(needBreak);
        end
    end

    if setting.chouCards ~= nil then 
        if setting.size == 2 and setting.chouCards == 0 then 
            ruleString = ruleString .."不抽牌"..breakString(needBreak);
        elseif setting.size == 2 then
            ruleString = ruleString .."抽"..setting.chouCards.."张"..breakString(needBreak);
        end
    end

    if setting.choiceDouble ~= nil then 
        if setting.size == 2 and setting.choiceDouble == false then 
            ruleString = ruleString .."不翻倍"..breakString(needBreak);
        elseif setting.size == 2 and setting.choiceDouble == true then
            ruleString = ruleString .."翻倍"..breakString(needBreak);
            if setting.doubleScore == 0 then 
                ruleString = ruleString .."不限制,".."翻"..setting.multiple.."倍"..breakString(needBreak);
            else
                ruleString = ruleString .."低于"..setting.doubleScore.."分,".."翻"..setting.multiple.."倍"..breakString(needBreak);
            end
            
        end
    end

    if setting.resultScore ~= nil and setting.resultScore and  setting.size == 2 then
        if setting.resultLowerScore ~= nil and setting.resultAddScore ~= nil then
            ruleString = ruleString.."低于"..setting.resultLowerScore..'分'..'加'..setting.resultAddScore..'分'..breakString(needBreak) 
        end
    end
    

    if setting.trusteeship then
        if setting.trusteeship == 0 then
            --ruleString = ruleString .. "不托管"--..breakString(needBreak);
        else
            ruleString = ruleString..(setting.trusteeship/60).."分钟后托管"..breakString(needBreak);
            if setting.trusteeshipDissolve~=nil then
                if setting.trusteeshipDissolve==true then
                    ruleString = ruleString.."本局解散"..breakString(needBreak);
                elseif setting.trusteeshipDissolve == false and setting.trusteeshipRound == 0 then
                    ruleString = ruleString.."满局解散"..breakString(needBreak);
                else
                    ruleString = ruleString.."3局解散"..breakString(needBreak);
                end
            end
        end
    end

    if isNoShowGps then
    else
        if setting.openIp then
            ruleString = ruleString .. "ip检测" .. breakString(needBreak) 
        end
        if setting.openGps then
            ruleString = ruleString .. "gps检测"
        end
    end
	if string.sub(ruleString, -1) == breakString(needBreak) then
		ruleString = string.sub(ruleString, 1, string.len(ruleString)-1)
    end
    
    return ruleString;
end

--获取划水麻将的设置字符串
function GetHNHSMRuleText(setting, needBreak, NoNeedPayInfo,  needGameName, NoNeedPlayerNum,isNoShowGps)
    local ruleString = "";
    if needGameName then
        ruleString = ruleString .. "划水麻将"..breakString(needBreak);
    end

    if not NoNeedPlayerNum and setting.size ~= nil then
        ruleString = ruleString .. setting.size.. "人"..breakString(needBreak);
    end

    if setting.rounds~=nil then
        if setting.rounds == 6 then 
            ruleString  = ruleString..'6局'..breakString(needBreak);
        elseif setting.rounds == 8 then 
            ruleString = ruleString.."8局"..breakString(needBreak);
        elseif setting.rounds == 12 then 
            ruleString = ruleString.."12局"..breakString(needBreak);
        elseif setting.rounds == 16 then 
            ruleString = ruleString.."16局"..breakString(needBreak);
        end
    end

    if NoNeedPayInfo == true then
        if setting.paymentType ~= nil and setting.paymentType == 0 then
            ruleString = ruleString .."房主支付"..breakString(needBreak);
        else
            ruleString = ruleString .. "赢家支付"..breakString(needBreak);
        end
    end

    if setting.bankerRule ~= nil then 
        if setting.bankerRule == true then 
            ruleString = ruleString .."首局随机坐庄"..breakString(needBreak);
        else
            ruleString = ruleString .."先进房先坐庄"..breakString(needBreak);
        end
    end

    if setting.huPattern ~= nil then 
        if setting.huPattern == true then 
            ruleString = ruleString .."必须自摸"..breakString(needBreak);
        else
            ruleString = ruleString .."可点炮"..breakString(needBreak);
        end
    end
    if setting.takeFeng ~= nil then 
        if setting.takeFeng then 
            ruleString = ruleString.."不带风"..breakString(needBreak);
        end
    end
	
    if setting.qingYiSe ~= nil then 
        if setting.qingYiSe then 
            ruleString = ruleString.."清一色"..breakString(needBreak);
        end
    end
	
    if setting.scoreMingGangInc ~= nil then 
        if setting.scoreMingGangInc then 
            ruleString = ruleString.."点炮点杠算3分"..breakString(needBreak);
        end
    end
	
    if setting.huangZhuangJiaBei ~= nil then 
        if setting.huangZhuangJiaBei then 
            ruleString = ruleString.."荒庄下局翻倍"..breakString(needBreak);
        end
    end

    if setting.variableHongZhong ~= nil then 
        if setting.variableHongZhong then 
            ruleString = ruleString.."红中赖子"..breakString(needBreak);
        end
    end
	
    if setting.variableHongZhongAll ~= nil then 
        if setting.variableHongZhongAll then 
            ruleString = ruleString.."赖子可任意代"..breakString(needBreak);
        end
    end
	
    if setting.huangZhuangHuangGang ~= nil then 
        if setting.huangZhuangHuangGang then 
            ruleString = ruleString.."荒庄不荒杠"..breakString(needBreak);
        end
    end

    if setting.openGenBanker ~= nil then 
        if setting.openGenBanker then 
            ruleString = ruleString.."带跟庄"..breakString(needBreak);
        end
    end
   
    if setting.qiangGangHu ~= nil then 
        if setting.qiangGangHu then 
            ruleString = ruleString.."抢杠胡"..breakString(needBreak);
        end
    end
    if setting.flodHuNoJiePao ~= nil then 
        if setting.flodHuNoJiePao then 
            ruleString = ruleString.."过胡只能自摸胡"..breakString(needBreak);
        end
    end
    
    if setting.zhuaYu ~= nil then 
        if setting.zhuaYu == 0  then 
            ruleString = ruleString.."不抓鱼"..breakString(needBreak);
        else
            ruleString = ruleString.."抓"..setting.zhuaYu.."条鱼"..breakString(needBreak);
        end
    end
   

    if setting.choiceDouble ~= nil then 
        if setting.size == 2 and setting.choiceDouble == false then 
            ruleString = ruleString .."不翻倍"..breakString(needBreak);
        elseif setting.size == 2 and setting.choiceDouble == true then
            ruleString = ruleString .."翻倍"..breakString(needBreak);
            if setting.doubleScore == 0 then 
                ruleString = ruleString .."不限制,".."翻"..setting.multiple.."倍"..breakString(needBreak);
            else
                ruleString = ruleString .."低于"..setting.doubleScore.."分,".."翻"..setting.multiple.."倍"..breakString(needBreak);
            end
            
        end
    end

    if setting.resultScore ~= nil and setting.resultScore and  setting.size == 2 then
        if setting.resultLowerScore ~= nil and setting.resultAddScore ~= nil then
            ruleString = ruleString.."低于"..setting.resultLowerScore..'分'..'加'..setting.resultAddScore..'分'..breakString(needBreak) 
        end
    end
    

    if setting.trusteeship then
        if setting.trusteeship == 0 then
            --ruleString = ruleString .. "不托管"--..breakString(needBreak);
        else
            ruleString = ruleString..(setting.trusteeship/60).."分钟后托管"..breakString(needBreak);
            if setting.trusteeshipDissolve~=nil then
                if setting.trusteeshipDissolve==true then
                    ruleString = ruleString.."本局解散"..breakString(needBreak);
                elseif setting.trusteeshipDissolve == false and setting.trusteeshipRound == 0 then
                    ruleString = ruleString.."满局解散"..breakString(needBreak);
                else
                    ruleString = ruleString.."3局解散"..breakString(needBreak);
                end
            end
        end
    end

    if isNoShowGps then
    else
        if setting.openIp then
            ruleString = ruleString .. "ip检测" .. breakString(needBreak) 
        end
        if setting.openGps then
            ruleString = ruleString .. "gps检测"
        end
    end
	if string.sub(ruleString, -1) == breakString(needBreak) then
		ruleString = string.sub(ruleString, 1, string.len(ruleString)-1)
    end
    
    return ruleString;
end

--获取郑州麻将的设置字符串
function GetHNZZMRuleText(setting, needBreak, NoNeedPayInfo,  needGameName, NoNeedPlayerNum,isNoShowGps)
    local ruleString = "";
    if needGameName then
        ruleString = ruleString .. "郑州麻将"..breakString(needBreak);
    end

    if not NoNeedPlayerNum and setting.size ~= nil then
        ruleString = ruleString .. setting.size.. "人"..breakString(needBreak);
    end

    if setting.rounds~=nil then
        if setting.rounds == 6 then 
            ruleString  = ruleString..'6局'..breakString(needBreak);
        elseif setting.rounds == 8 then 
            ruleString = ruleString.."8局"..breakString(needBreak);
        elseif setting.rounds == 12 then 
            ruleString = ruleString.."12局"..breakString(needBreak);
        elseif setting.rounds == 16 then 
            ruleString = ruleString.."16局"..breakString(needBreak);
        end
    end

    if NoNeedPayInfo == true then
        if setting.paymentType ~= nil and setting.paymentType == 0 then
            ruleString = ruleString .."房主支付"..breakString(needBreak);
        else
            ruleString = ruleString .. "赢家支付"..breakString(needBreak);
        end
    end

    if setting.bankerRule ~= nil then 
        if setting.bankerRule == true then 
            ruleString = ruleString .."首局随机坐庄"..breakString(needBreak);
        else
            ruleString = ruleString .."先进房先坐庄"..breakString(needBreak);
        end
    end

    if setting.huPattern ~= nil then 
        if setting.huPattern == true then 
            ruleString = ruleString .."必须自摸"..breakString(needBreak);
        else
            ruleString = ruleString .."可点炮"..breakString(needBreak);
        end
    end
    if setting.takeFeng ~= nil then 
        if setting.takeFeng then 
            ruleString = ruleString.."不带风"..breakString(needBreak);
        end
    end

    if setting.takeHun ~= nil then 
        if setting.takeHun then 
            ruleString = ruleString.."带混"..breakString(needBreak);
        end
    end

    if setting.gangPao ~= nil then 
        if setting.gangPao then 
            ruleString = ruleString.."杠跑"..breakString(needBreak);
        end
    end
   
    if setting.qiangGangHu ~= nil then 
        if setting.qiangGangHu then 
            ruleString = ruleString.."抢杠胡"..breakString(needBreak);
        end
    end
    if setting.bankerBase ~= nil then 
        if setting.bankerBase then 
            ruleString = ruleString.."庄家加底"..breakString(needBreak);
        end
    end

    if setting.gangShangHuaJiaBei ~= nil then 
        if setting.gangShangHuaJiaBei then 
            ruleString = ruleString.."杠上花加倍"..breakString(needBreak);
        end
    end

    if setting.qiDuiJiaBei ~= nil then 
        if setting.qiDuiJiaBei then 
            ruleString = ruleString.."七对加倍"..breakString(needBreak);
        end
    end
    
    if setting.takeHun ~= nil then 
        if setting.takeHun then 
            if setting.takHunMode ~= nil then 
                if setting.takHunMode == 1 then 
                    ruleString = ruleString.."上混"..breakString(needBreak);
                elseif setting.takHunMode == 2 then 
                    ruleString = ruleString.."中混"..breakString(needBreak);
                elseif setting.takHunMode == 3 then 
                    ruleString = ruleString.."下混"..breakString(needBreak);
                elseif setting.takHunMode == 4 then 
                    ruleString = ruleString.."双混"..breakString(needBreak);
                end
            end
        end
    end
   
    if setting.selectPao ~= nil then 
        if setting.selectPao == -1 then 
            ruleString = ruleString.."自由选跑"..breakString(needBreak);
            if setting.selectPaoScore ~= nil then 
                if setting.selectPaoScore == 1 then
                    ruleString = ruleString.."下跑1~3分"..breakString(needBreak);
                elseif setting.selectPaoScore == 2 then 
                    ruleString = ruleString.."下跑1~5分"..breakString(needBreak);
                end
            end
        elseif setting.selectPao == 0 then 
            ruleString = ruleString.."固定选跑"..breakString(needBreak);
            ruleString = ruleString.."不跑分"..breakString(needBreak);
        elseif setting.selectPao > 0 then 
            ruleString = ruleString.."固定选跑"..breakString(needBreak);
            ruleString = ruleString.."跑"..setting.selectPao.."分"..breakString(needBreak);
        end
    end

    if setting.choiceDouble ~= nil then 
        if setting.size == 2 and setting.choiceDouble == false then 
            ruleString = ruleString .."不翻倍"..breakString(needBreak);
        elseif setting.size == 2 and setting.choiceDouble == true then
            ruleString = ruleString .."翻倍"..breakString(needBreak);
            if setting.doubleScore == 0 then 
                ruleString = ruleString .."不限制,".."翻"..setting.multiple.."倍"..breakString(needBreak);
            else
                ruleString = ruleString .."低于"..setting.doubleScore.."分,".."翻"..setting.multiple.."倍"..breakString(needBreak);
            end
            
        end
    end

    if setting.resultScore ~= nil and setting.resultScore and  setting.size == 2 then
        if setting.resultLowerScore ~= nil and setting.resultAddScore ~= nil then
            ruleString = ruleString.."低于"..setting.resultLowerScore..'分'..'加'..setting.resultAddScore..'分'..breakString(needBreak) 
        end
    end
    

    if setting.trusteeship then
        if setting.trusteeship == 0 then
            --ruleString = ruleString .. "不托管"--..breakString(needBreak);
        else
            ruleString = ruleString..(setting.trusteeship/60).."分钟后托管"..breakString(needBreak);
            if setting.trusteeshipDissolve~=nil then
                if setting.trusteeshipDissolve==true then
                    ruleString = ruleString.."本局解散"..breakString(needBreak);
                elseif setting.trusteeshipDissolve == false and setting.trusteeshipRound == 0 then
                    ruleString = ruleString.."满局解散"..breakString(needBreak);
                else
                    ruleString = ruleString.."3局解散"..breakString(needBreak);
                end
            end
        end
    end

    if isNoShowGps then
    else
        if setting.openIp then
            ruleString = ruleString .. "ip检测" .. breakString(needBreak) 
        end
        if setting.openGps then
            ruleString = ruleString .. "gps检测"
        end
    end
	if string.sub(ruleString, -1) == breakString(needBreak) then
		ruleString = string.sub(ruleString, 1, string.len(ruleString)-1)
    end
    
    return ruleString;
end

--获取安化麻将的设置字符串
function GetDZAHMRuleText(setting, needBreak, NoNeedPayInfo,  needGameName, NoNeedPlayerNum,isNoShowGps)
    local ruleString = "";
    if needGameName then
        ruleString = ruleString .. "安化麻将"..breakString(needBreak);
    end

    if not NoNeedPlayerNum and setting.size ~= nil then
        ruleString = ruleString .. setting.size.. "人"..breakString(needBreak);
    end

    if setting.rounds~=nil then
        if setting.rounds == 6 then 
            ruleString  = ruleString..'6局'..breakString(needBreak);
        elseif setting.rounds == 8 then 
            ruleString = ruleString.."8局"..breakString(needBreak);
        elseif setting.rounds == 12 then 
            ruleString = ruleString.."12局"..breakString(needBreak);
        elseif setting.rounds == 16 then 
            ruleString = ruleString.."16局"..breakString(needBreak);
        end
    end

    if NoNeedPayInfo == true then
        if setting.paymentType ~= nil and setting.paymentType == 0 then
            ruleString = ruleString .."房主支付"..breakString(needBreak);
        else
            ruleString = ruleString .. "赢家支付"..breakString(needBreak);
        end
    end

    if setting.anBankerRule ~= nil then 
        if setting.anBankerRule == true then 
            ruleString = ruleString .."首局随机坐庄"..breakString(needBreak);
        else
            ruleString = ruleString .."先进房先坐庄"..breakString(needBreak);
        end
    end

    if setting.ahBaseScore ~= nil then
        ruleString = ruleString ..'底分'..setting.ahBaseScore..'分'.. breakString(needBreak)
    end

    if setting.paymentType ~= nil then 
        if setting.paymentType == 0 then 
            ruleString = ruleString .."房主支付"..breakString(needBreak);
        elseif setting.paymentType == 2 then
            ruleString = ruleString .."赢家支付"..breakString(needBreak);
        end
    end

    if setting.ahQiangGangHu ~= nil then 
        if setting.ahQiangGangHu == true then 
            ruleString = ruleString .."可抢杠胡"..breakString(needBreak);
        end
    end

    if setting.ahFloatScore~=nil then
        if setting.ahFloatScore == true then
            ruleString = ruleString.."飘分"..breakString(needBreak);
        end
    end

    if setting.ahStoreBanker ~= nil then 
        if setting.ahStoreBanker then 
            ruleString = ruleString.."王代本身是硬庄"..breakString(needBreak);
        end
    end

    if setting.ahHuMultiple ~= nil then 
        if setting.ahHuMultiple then 
            ruleString = ruleString.."一炮多响"..breakString(needBreak);
        end
    end
   
    if setting.ahGangShangPaoHu ~= nil then 
        if setting.ahGangShangPaoHu then 
            ruleString = ruleString.."杠上炮算单大胡"..breakString(needBreak);
        end
    end

    if setting.ahKingCount ~= nil then 
        if setting.ahKingCount == 4 then 
            ruleString = ruleString.."四王"..breakString(needBreak);
        elseif setting.ahKingCount == 7 then
            ruleString = ruleString.."七王"..breakString(needBreak);
        end
    end

    if setting.ahGangMahjongCount ~= nil then 
        ruleString = ruleString.."杠"..setting.ahGangMahjongCount.."张"..breakString(needBreak);
    end

    --if setting.ahBird ~= nil then 
        if setting.ahBird == 0 then 
            ruleString = ruleString.."不抓鸟"..breakString(needBreak);
        elseif setting.ahBird159 then
            ruleString = ruleString.."159抓鸟"..breakString(needBreak);
            ruleString = ruleString.. "抓" .. setting.ahBird .. "鸟" ..breakString(needBreak);
        elseif setting.ahBirdBankerStart then
            ruleString = ruleString.."庄家方位抓鸟"..breakString(needBreak);
            ruleString = ruleString.. "抓" .. setting.ahBird .. "鸟" ..breakString(needBreak);
        elseif setting.ahBirdWinStart then
            ruleString = ruleString.."赢家方位抓鸟"..breakString(needBreak);
            ruleString = ruleString.. "抓" .. setting.ahBird .. "鸟" ..breakString(needBreak);
        else
            ruleString = ruleString.."不抓鸟"..breakString(needBreak);
        end
    --end

    if setting.choiceDouble ~= nil then 
        if setting.size == 2 and setting.choiceDouble == false then 
            ruleString = ruleString .."不翻倍"..breakString(needBreak);
        elseif setting.size == 2 and setting.choiceDouble == true then
            ruleString = ruleString .."翻倍"..breakString(needBreak);
            if setting.doubleScore == 0 then 
                ruleString = ruleString .."不限制,".."翻"..setting.multiple.."倍"..breakString(needBreak);
            else
                ruleString = ruleString .."低于"..setting.doubleScore.."分,".."翻"..setting.multiple.."倍"..breakString(needBreak);
            end
            
        end
    end

    if setting.resultScore ~= nil and setting.resultScore and  setting.size == 2 then
        if setting.resultLowerScore ~= nil and setting.resultAddScore ~= nil then
            ruleString = ruleString.."低于"..setting.resultLowerScore..'分'..'加'..setting.resultAddScore..'分'..breakString(needBreak) 
        end
    end
    

    if setting.trusteeship then
        if setting.trusteeship == 0 then
            --ruleString = ruleString .. "不托管"--..breakString(needBreak);
        else
            ruleString = ruleString..(setting.trusteeship/60).."分钟后托管"..breakString(needBreak);
            if setting.trusteeshipDissolve~=nil then
                if setting.trusteeshipDissolve==true then
                    ruleString = ruleString.."本局解散"..breakString(needBreak);
                elseif setting.trusteeshipDissolve == false and setting.trusteeshipRound == 0 then
                    ruleString = ruleString.."满局解散"..breakString(needBreak);
                else
                    ruleString = ruleString.."3局解散"..breakString(needBreak);
                end
            end
        end
    end

    if isNoShowGps then
    else
        if setting.openIp then
            ruleString = ruleString .. "ip检测" .. breakString(needBreak) 
        end
        if setting.openGps then
            ruleString = ruleString .. "gps检测"
        end
    end
	if string.sub(ruleString, -1) == breakString(needBreak) then
		ruleString = string.sub(ruleString, 1, string.len(ruleString)-1)
    end
    
    return ruleString;
end

--获取打筒子的设置字符串
function GetDTZRuleString(setting, needBreak, NoNeedPayInfo,  needGameName, NoNeedPlayerNum,isNoShowGps)
    local ruleString = "";
    if needGameName then
        ruleString = ruleString .. "打筒子"..breakString(needBreak);
    end

    if setting.scoreSelect ~= nil then
        if setting.scoreSelect == 0 then
            ruleString = ruleString .. "600分"..breakString(needBreak);
        else
            ruleString = ruleString .. "1000分"..breakString(needBreak);
        end
    end

    if not NoNeedPlayerNum and setting.size ~= nil then
        ruleString = ruleString .. setting.size.. "人"..breakString(needBreak);
    end

    if NoNeedPayInfo == true then
        if setting.paymentType ~= nil and setting.paymentType == 0 then
            ruleString = ruleString .."房主支付"..breakString(needBreak);
        else
            ruleString = ruleString .. "赢家支付"..breakString(needBreak);
        end
    end
   
    if setting.cardCount ~= nil then
        if setting.cardCount == 3 or setting.cardCount == 4 then
            ruleString = ruleString .. setting.cardCount.. "副牌"..breakString(needBreak);
        elseif setting.cardCount == 5 then
            --嗨皮四喜
            ruleString = ruleString .."嗨皮四喜"..breakString(needBreak);
        end
    end
    if setting.lastBonus ~= nil then
        if setting.lastBonus == 0 then
            ruleString = ruleString .. "终局无奖励"..breakString(needBreak);
        elseif setting.lastBonus == 1 then
            ruleString = ruleString .. "终局奖励100分"..breakString(needBreak);
        elseif setting.lastBonus == 2 then
            ruleString = ruleString .. "终局奖励200分"..breakString(needBreak);
        elseif setting.lastBonus == 3 then
            ruleString = ruleString .. "终局奖励300分"..breakString(needBreak);
        elseif setting.lastBonus == 4 then
            ruleString = ruleString .. "终局奖励500分"..breakString(needBreak);
        end
    end
   
    if setting.cardCount ~= nil and setting.cardCount == 3 then
        if setting.canisterBonus ~= nil then
            if setting.canisterBonus == 0 then
                ruleString = ruleString .. "筒子无奖励"..breakString(needBreak);
            elseif setting.canisterBonus == 1 then
                ruleString = ruleString .. "K筒子奖励100分"..breakString(needBreak);
            elseif setting.canisterBonus == 2 then
                ruleString = ruleString .. "J-K筒子奖励100分"..breakString(needBreak);
            elseif setting.canisterBonus == 3 then
                ruleString = ruleString .. "5-K 筒子奖励100分"..breakString(needBreak);
            end
        end
       
    end

    if setting.dark ~= nil and setting.dark then
        if setting.darkCount ~= nil then
            ruleString = ruleString .. "暗牌"..setting.darkCount.."张"..breakString(needBreak);
        else
            ruleString = ruleString .. "有暗牌"..breakString(needBreak);
        end

    end

    if setting.show ~= nil and setting.show then
        ruleString = ruleString ..(setting.show and "显" or "不显").. "示剩牌"..breakString(needBreak);
    end

    if setting.san ~= nil and setting.san then
        ruleString = ruleString .. (setting.san and "可" or "不可").."三带二"..breakString(needBreak);
    end

    if setting.dissolveCalcSocre ~= nil and setting.dissolveCalcSocre then
        ruleString = ruleString .. "中途解散手牌地炸/喜/筒子算分"..breakString(needBreak);
    end

    if setting.size ~= nil then
        if setting.size == 2 or setting.size == 3 then
            if setting.radom ~= nil and setting.radom then
                ruleString = ruleString .. "随机先出"..breakString(needBreak);
            end
        else
            if setting.autoRun ~= nil and setting.autoRun then
                ruleString = ruleString .. "自动开始"..breakString(needBreak);
            end
        end
    end
    if setting.guan ~= nil and setting.guan then
        ruleString = ruleString .. "有牌必管"..breakString(needBreak);
    end


    if setting.choiceDouble then
        if setting.doubleScore == 0 then
            ruleString = ruleString .. '不限分,翻'..setting.multiple..'倍'..breakString(needBreak);
        else
            ruleString = ruleString .. '小于'..setting.doubleScore..'分,翻'..setting.multiple..'倍'..breakString(needBreak);
        end
    end

    if setting.trusteeship ~= nil then
        if setting.trusteeship == 0 then
           -- msg = msg .. "不托管"--..breakString(needBreak);
        else
            ruleString = ruleString..(setting.trusteeship/60).."分钟后托管"--..breakString(needBreak);
            if setting.trusteeshipDissolve~=nil then
                if setting.trusteeshipDissolve==true then
                    ruleString = ruleString .. breakString(needBreak) .. "本局解散"..breakString(needBreak);
                elseif setting.trusteeshipDissolve == false and setting.trusteeshipRound ~= nil and setting.trusteeshipRound == 0 then
                    ruleString = ruleString .. breakString(needBreak) .. "满局解散"..breakString(needBreak);
                elseif setting.trusteeshipRound ~= nil and setting.trusteeshipRound == 3 then
                    ruleString = ruleString .. breakString(needBreak) .. "3局解散"..breakString(needBreak);
                end
            end
        end
    end
	if isNoShowGps then
    else
        if setting.openIp then
            ruleString = ruleString .. "ip检测" .. breakString(needBreak) 
        end
        if setting.openGps then
            ruleString = ruleString .. "gps检测"
        end
    end
	if string.sub(ruleString, -1) == breakString(needBreak) then
		ruleString = string.sub(ruleString, 1, string.len(ruleString)-1)
	end

    return ruleString
end

function GetBBTZRuleString(setting, needBreak, NoNeedPayInfo, needGameName, NoNeedPlayerNum,isNoShowGps)
    local ruleString = ""
    if needGameName then
        ruleString = ruleString .. "半边天炸"..breakString(needBreak);
    end

    if setting.rounds ~= nil then
        ruleString = ruleString .. setting.rounds.."局"..breakString(needBreak);
    end

    if not NoNeedPlayerNum and setting.size ~= nil then
        ruleString = ruleString .. setting.size.. "人"..breakString(needBreak);
    end

    if NoNeedPayInfo == true and setting.paymentType ~= nil then
        if setting.paymentType == 0 then
            ruleString = ruleString .."房主支付"..breakString(needBreak);
        else
            ruleString = ruleString .. "赢家支付"..breakString(needBreak);
        end
    end

    if setting.san ~= nil then
        ruleString = ruleString..(setting.san and "黑桃三先出" or "随机先出")..breakString(needBreak)
    end

    if setting.mask ~= nil then
        ruleString = ruleString..(setting.mask and "正五十K区分花色"..breakString(needBreak) or "") --"正五十K不区份花色")
    end

    if setting.show ~= nil then
        ruleString = ruleString..(setting.show and "显示剩余牌"..breakString(needBreak) or "")--"隐藏剩余牌")
    end

    if setting.hammer ~= nil then
        ruleString = ruleString..(setting.hammer and "可锤"..breakString(needBreak) or "")--"不可锤")
    end

    if setting.steep ~= nil then
        ruleString = ruleString..(setting.steep and "可陡"..breakString(needBreak) or "")--"不陡")
    end

    if setting.betSan ~= nil then
        ruleString = ruleString..(setting.betSan and "四带三"..breakString(needBreak) or "")--"不可四带三")
    end

    if setting.king ~= nil then
        ruleString = ruleString..(setting.king and "有大王"..breakString(needBreak) or "")--"无大王")
    end

    if setting.trusteeship ~= nil then
        if setting.trusteeship == 0 then
           -- msg = msg .. "不托管"--..breakString(needBreak);
        else
            ruleString = ruleString..(setting.trusteeship/60).."分钟后托管"--..breakString(needBreak);
            if setting.trusteeshipDissolve~=nil then
                if setting.trusteeshipDissolve==true then
                    ruleString = ruleString .. breakString(needBreak) .. "本局解散"..breakString(needBreak);
                elseif setting.trusteeshipDissolve == false and setting.trusteeshipRound ~= nil and setting.trusteeshipRound == 0 then
                    ruleString = ruleString .. breakString(needBreak) .. "满局解散"..breakString(needBreak);
                elseif setting.trusteeshipRound ~= nil and setting.trusteeshipRound == 3 then
                    ruleString = ruleString .. breakString(needBreak) .. "3局解散"..breakString(needBreak);
                end
            end
        end
    end
	if isNoShowGps then
    else
        if setting.openIp then
            ruleString = ruleString .. "ip检测" .. breakString(needBreak) 
        end
        if setting.openGps then
            ruleString = ruleString .. "gps检测"
        end
    end
	if string.sub(ruleString, -1) == breakString(needBreak) then
		ruleString = string.sub(ruleString, 1, string.len(ruleString)-1)
	end


    return ruleString;
end
function getYJQFRuleString(setting, needBreak, NoNeedPayInfo, needGameName,isNoShowGps)
    local msg = "";
    
    if needGameName then
        msg = msg .. '沅江千分'..breakString(needBreak)
    end
    if NoNeedPayInfo then
    else
		if setting.size ~= nil then
			if setting.size == 2 then 
				msg = msg .. '2人玩'..breakString(needBreak);
			else
				msg = msg .. '3人玩'..breakString(needBreak);
			end
		end
	end
    if NoNeedPayInfo then
    else
        if setting.paymentType ~= nil then
            print('setting.paymentType : '..setting.paymentType)
            if setting.paymentType == 0 then
                msg = msg..' 房主支付'..breakString(needBreak)
            elseif setting.paymentType == 1 then
                msg = msg..' AA支付'..breakString(needBreak)
            elseif setting.paymentType == 2 then
                msg = msg..' 赢家支付'..breakString(needBreak)
            end
        end
    end
    if setting.happly~=nil then
        if setting.happly==false then
            msg = msg..'喜分算加分'..breakString(needBreak)
        else
            msg = msg..'喜分算乘分'..breakString(needBreak)
        end
    end
    
    if setting.rewardScore~=nil then
        if setting.rewardScore ~= 0 then 
            msg = msg.."结算奖励"..setting.rewardScore..'分'..breakString(needBreak)
        end
    end
    
    if setting.retainCard~=nil then
        if setting.retainCard == true then 
            msg = msg.."保留6和7"..breakString(needBreak)
        else
            msg = msg.."删除6和7"..breakString(needBreak)
        end
    end

    if setting.bonusScore ~= nil then
        if  setting.bonusScore == 1 then
            msg = msg..(setting.size == 2 and '第一名奖60分，第二名扣60分' or '第一名奖100分，第二名扣40分，第三名扣60分')..breakString(needBreak)
        elseif  setting.bonusScore == 2 then
            msg = msg..(setting.size == 2 and '第一名奖40分，第二名扣40分' or '第一名奖100分，第二名扣30分，第三名扣70分')..breakString(needBreak)
        elseif  setting.bonusScore == 3 then
            msg = msg.."第一名奖40分，第二名不扣分，第三名扣40分"..breakString(needBreak)
        end
    end
   
    if setting.size ~= nil and setting.size == 2 then
        if setting.choiceDouble ~= nil then
            if setting.choiceDouble then
                if setting.doubleScore ~= nil then
                    if setting.doubleScore == 0 then
                        if setting.multiple ~= nil then
                            msg = msg ..'不限分,翻'..setting.multiple..'倍'.. breakString(needBreak)
                        end
                    else
                        if setting.multiple ~= nil then
                            msg = msg ..'小于'..setting.doubleScore..'分,翻'..setting.multiple..'倍'.. breakString(needBreak)
                        end
                    end
                end
            else
                msg = msg..'不翻倍'..breakString(needBreak)
            end
        end
    end
    if setting.size ~= nil and setting.size == 2 then
        if setting.resultScore ~= nil and setting.resultScore then
            if setting.resultLowerScore ~= nil and setting.resultAddScore ~= nil then
                msg = msg.."低于"..setting.resultLowerScore..'分'..'加'..setting.resultAddScore..'分'..breakString(needBreak) 
            end
        end
    end
    if setting.trusteeship ~= nil then
        if setting.trusteeship == 0 then
           -- msg = msg .. "不托管"--..breakString(needBreak);
        else
            msg = msg..(setting.trusteeship/60).."分钟后托管"--..breakString(needBreak);
            if setting.trusteeshipDissolve~=nil then
                if setting.trusteeshipDissolve==true then
                    msg = msg .. breakString(needBreak) .. "本局解散"..breakString(needBreak);
                elseif setting.trusteeshipDissolve == false and setting.trusteeshipRound ~= nil and setting.trusteeshipRound == 0 then
                    msg = msg .. breakString(needBreak) .. "满局解散"..breakString(needBreak);
                elseif setting.trusteeshipRound ~= nil and setting.trusteeshipRound == 3 then
                    msg = msg .. breakString(needBreak) .. "3局解散"..breakString(needBreak);
                end
            end
        end
    end
	if isNoShowGps then
    else
        if setting.openIp then
            msg = msg .. "ip检测" .. breakString(needBreak) 
        end
        if setting.openGps then
            msg = msg .. "gps检测"
        end
    end
	if string.sub(msg, -1) == breakString(needBreak) then
		msg = string.sub(msg, 1, string.len(msg)-1)
	end

    return msg;
end
function getIntPart(x)
    if x <= 0 then
        return math.ceil(x)
    end

    if math.ceil(x) == x then
        x = math.ceil(x)
    else
        x = math.ceil(x) - 1
    end
    return x
end

mark = {}
function dump(data, showMetatable, lastCount)
    if type(data) ~= "table" then
        --Value
        if type(data) == "string" then
            io.write("\"", data, "\"")
        else
            io.write(tostring(data))
        end
    else
        --Format
        local count = lastCount or 0
        count = count + 1
        io.write("{\n")
        --Metatable
        if showMetatable then
            for i = 1, count do io.write("\t") end
            local mt = getmetatable(data)
            io.write("\"__metatable\" = ")
            dump(mt, showMetatable, count)    -- 如果不想看到元表的元表，可将showMetatable处填nil
            io.write(",\n")        --如果不想在元表后加逗号，可以删除这里的逗号
        end
        --Key
        for key, value in pairs(data) do
            if not mark[value] then
                mark[value] = true
                for i = 1, count do io.write("\t") end
                if type(key) == "string" then
                    io.write("\"", key, "\" = ")
                elseif type(key) == "number" then
                    io.write("[", key, "] = ")
                else
                    io.write(tostring(key))
                end
                dump(value, showMetatable, count)    -- 如果不想看到子table的元表，可将showMetatable处填nil
                io.write(",\n")        --如果不想在table的每一个item后加逗号，可以删除这里的逗号
            else
                print('*REF*')
                return
            end
        end
        --Format
        for i = 1, lastCount or 0 do io.write("\t") end
        io.write("}")
    end
    --Format
    if not lastCount then
        io.write("\n")
    end
end

function trim(str)
    return (string.gsub(str, "^%s*(.-)%s*$", "%1"))
 end

function GetPayMun(roomType,rounds,size,scoreSelect)
    print('roomType : '..roomType)
    if roomType == proxy_pb.SYZP 
    or roomType == proxy_pb.HHHGW 
	or roomType == proxy_pb.AHPHZ
    or roomType == proxy_pb.CSPHZ
    or roomType == proxy_pb.CDPHZ
    or roomType == proxy_pb.HSPHZ 
    or roomType == proxy_pb.CDDHD
    or roomType == proxy_pb.NXPHZ
    or roomType == proxy_pb.XTPHZ
    or roomType == proxy_pb.YXPHZ
    or roomType == proxy_pb.YJGHZ
    or roomType == proxy_pb.CZZP then
		if 6 == rounds or 8 == rounds then
			return '2'
		elseif 10 == rounds then
			return '3'
		elseif 16 == rounds then
            return '4'
        elseif 1 == rounds then
            return '1'
		end
    elseif roomType == proxy_pb.SYBP then
        if rounds == 1 then
            return '1'
        else
            if size == 2 then
                return '2'
            elseif size == 3 then
                return '3'
            elseif size == 4 then
                return '3'
            end
        end
	elseif roomType == proxy_pb.LDFPF or roomType == proxy_pb.XXGHZ then
        return '2'
    elseif roomType == proxy_pb.HYLHQ 
    or roomType == proxy_pb.HYSHK 
    or roomType == proxy_pb.LYZP  then
        if rounds == 16 then
            return '3'
        else
            return '2'
        end
    elseif roomType == proxy_pb.PDKSWZ or roomType == proxy_pb.PDKSLZ then
        if rounds == 10 or rounds == 8 then
             return '2'
        elseif rounds == 20 then
            return '4'
        end
    elseif roomType == proxy_pb.PKXHZD then
        if rounds == 16 then
            return '4'
        else
            return '2'
        end
    elseif roomType == proxy_pb.PKDTZ then
        if scoreSelect == 0 then
            return '2'
        else
            return '3'
        end
    elseif roomType == proxy_pb.PKBBTZ then
        return '0'
    elseif roomType == proxy_pb.PKDDA then
        if rounds == 4 then
            return "2"
        elseif rounds == 8 then
            return "3"
        elseif rounds == 12 then
            return "6"
        end
    elseif roomType == proxy_pb.CSM then
        if rounds == 8 then
            return '2'
        else
            return '4'
        end
	elseif roomType == proxy_pb.ZZM or roomType == proxy_pb.HZM then
		if UnityEngine.Application.identifier == 'com.neimeng.ball' then
			if rounds == 8 then
				return '3'
			else
				return '6'
			end
		else
			if rounds == 8 then
				return '2'
			else
				return '4'
			end
		end

    elseif roomType == proxy_pb.HSM or roomType == proxy_pb.WLCBM then
        if rounds == 6 or rounds == 8 then
            if size == 2 then
                return '2'
            else
                return '3'
            end
        elseif rounds == 12 then
            if size == 2 then
                return '3'
            else
                return '5'
            end
        elseif rounds == 16 then
            if size == 2 then
                return '4'
            else
                return '6'
            end
        end
    elseif roomType == proxy_pb.HNHSM then 
        if rounds == 6 or rounds == 8 then
            return '3'
        elseif rounds == 12 or rounds == 16 then
            return '6'
        end
    elseif roomType == proxy_pb.HNZZM then
        if rounds == 6 or rounds == 8 then
            return '3'
        elseif rounds == 12 or rounds == 16 then
            return '6'
        end
    elseif roomType == proxy_pb.PKYJQF then 
        return "3"
    elseif roomType == proxy_pb.PKHSTH then
        if rounds == 1 or rounds == 2 then
            return "1"
        elseif rounds == 4 then
            return "2"
        elseif rounds == 8 then
            return "4"
        end
    elseif roomType == proxy_pb.DZAHM then
        if rounds == 6 or rounds == 8 then
            return '2'
        elseif rounds == 12 or rounds == 16 then
            return '4'
        end
    else
        print("未知类型", nil)
        return '0'
    end
end

function GetRoomType(settings, gameType)
    
    if gameType == proxy_pb.PDK then
        return settings.cardCount == 15 and 20 or 21 
    end

    return settings.roomType
end

function hasNotchInScreen()
end

DAN=0        --单牌
DUI=1        --对子
SAN=2        --三不带
SAN_YI=3     --三带一
SAN_ER=4     --三带二
SHUN=5       --顺子
LIAN_DUI=6   --连对，点数相连的2个及以上的对子
SAN_SHUN=7   --三顺，点数相连的2个及以上的3同张
FEI_YI=8     --飞机带一张
FEI_ER=9     --飞机带两张
ZHA_DAN=10     --炸弹
SI = 11
SI_YI = 12
SI_ER = 13
SI_SAN = 14
SI_SHUN = 15
SI_FEI_ER = 16
SI_FEI_SAN = 17
function reverseTable(tab)  
    local tmp = {}  
    local copy = {}
    for k = 1, #tab do
        copy[k] = tab[k]
    end
    for i = 1, #copy do  
        local key = #copy  
        tmp[i] = table.remove(copy)  
    end
    return tmp
end
function RefreshGrid(grid, cards, isReplay)
    print("refreshGrid name "..grid.name..' card num:'..#cards)
    local cardcopy = cards
    if grid.name == "GridIn" and grid.transform.parent.gameObject.name == "player0" then
    else
        --print("进入倒叙排列")
        --if grid.name == "GridOut" and grid.transform.parent.gameObject.name == "player0" then
        --else
            local copy = {}
            for k = 1, #cards do
                copy[k] = cards[k]
            end
            table.sort(copy, tableSortDesc)
            local cardGroups = GetCardsGroup(copy)
            local group4 = GetGroupByID(4, cardGroups)
            local group3 = GetGroupByID(3, cardGroups)
            if #group4 > 0 or #group3 > 0 then
            else
                cardcopy = reverseTable(cards)
            end
            
        --end
        --table.sort(cards,tableSortAsc)
    end
	for i=0,grid.transform.childCount-1 do
		local item = grid.transform:GetChild(i)
		if i < #cardcopy then
			item.gameObject:SetActive(true)
			local t = item:Find('type')
			local tSmall = item:Find('typeSmall')
			local tBig = item:Find('typeBig')
            local num = item:Find('num')

            local card = cardcopy[i+1]
            if card == SPADE_THREE  and roomData.setting.firstPlay == pdk_pb.S3_IN  and grid.name == "GridIn" and grid.transform.parent.gameObject.name == "player0" and not isReplay then
                if roomData.setting.remainBanker and roomData.round > 1 then --and roomData.round == 1
                    local shouchu = item:Find('shouchu')
                    shouchu.gameObject:SetActive(false)
                else
                    local shouchu = item:Find('shouchu')
                    shouchu.gameObject:SetActive(true)
                end
            elseif grid.name == "GridIn" and grid.transform.parent.gameObject.name == "player0" then
                local shouchu = item:Find('shouchu')
                if shouchu ~= nil then
                    shouchu.gameObject:SetActive(false)
                end
            end
			tSmall.gameObject:SetActive(false)
			tBig.gameObject:SetActive(false)
			num.gameObject:SetActive(false)
			t.gameObject:SetActive(false)
            SetUserData(item.gameObject, card)
            if grid.transform.parent.gameObject.name == "player0" then
                if grid.name == "GridIn" or grid.transform.parent.parent.gameObject.name == "panelReplay_pdk" then
                    item:GetComponent('UIPanel').depth = i+11
                end
            elseif grid.transform.parent.gameObject.name == "player1" then
                 if grid.transform.parent.parent.gameObject.name == "panelReplay_pdk" then
                    if i>=8  then
                        item:GetComponent('UIPanel').depth = i+10--40-i
                    else
                        item:GetComponent('UIPanel').depth = i+10--20-i
                    end
                else
                    if i>=10  then
                       -- item:GetComponent('UIPanel').depth = i+3--40-i
                    else
                        --item:GetComponent('UIPanel').depth = i+3--20-i
                    end
                end
            else
                if grid.transform.parent.parent.gameObject.name == "panelReplay_pdk" and grid.gameObject.name == "GridIn" then
                    if i>=8  then
                        item:GetComponent('UIPanel').depth = 40+i ----i+3
                    else
                        item:GetComponent('UIPanel').depth = 20+i ----i+3
                    end
                elseif grid.transform.parent.parent.gameObject.name == "panelReplay_pdk" and grid.gameObject.name == "GridOut" then
                    if i>=10  then
                        item:GetComponent('UIPanel').depth = 20+i ----i+3
                    else
                        item:GetComponent('UIPanel').depth = 10+i ----i+3
                    end
                end
            end
			
            if card < 52 then
                local plateType = card%4
                local plateNum = getIntPart(card/4)+3
                local strType=''
				local col = Color.white
                if plateType == 0 then
                    strType='DiamondIcon2'
					col = Color.white
                elseif plateType == 1 then
                    strType='ClubIcon2'
					col.r = 51/255
					col.g = 52/255
					col.b = 57/255
                elseif plateType == 2 then
                    strType='HeartIcon2'
					col = Color.white
                else
                    strType='SpadeIcon2'
					col.r = 51/255
					col.g = 52/255
					col.b = 57/255
                end
				
				t.gameObject:SetActive(true)
                t:GetComponent('UISprite').spriteName=strType   --.."1"
                --t:GetComponent('UISprite'):MakePixelPerfect()
				
                if plateNum >10 and plateNum < 14 and false then
                    tBig.gameObject:SetActive(true)
					if plateNum == 11 then
						tBig:GetComponent('UISprite').spriteName='JackIcon'
					elseif plateNum == 12 then
						tBig:GetComponent('UISprite').spriteName='QueenIcon'
					else
						tBig:GetComponent('UISprite').spriteName='KingIcon'
					end
                else
                    tSmall:GetComponent('UISprite').spriteName=strType
					tSmall:GetComponent('UISprite').color=col
                    tSmall.gameObject:SetActive(true)
                    --tSmall:GetComponent('UISprite'):MakePixelPerfect()
                end
                num.gameObject:SetActive(true)
                if UnityEngine.PlayerPrefs.GetInt("pdkpaiSize", 0) == 0 or grid.parent.parent.gameObject.name == "panelReplay_pdk" then
                    num:GetComponent('UISprite').spriteName = 'card_'..plateNum..'_2'
                else
                    num:GetComponent('UISprite').spriteName = 'bcard_'..plateNum..'_2'
                end
                num:GetComponent('UISprite').color=col
                --num:GetComponent('UISprite'):MakePixelPerfect()
            else
                tBig.gameObject:SetActive(true)
				tBig:GetComponent('UISprite').spriteName='JokerIcon'
            end
		else
			item.gameObject:SetActive(false)
		end
    end
    if grid.name == "GridIn" and grid.transform.parent.gameObject.name == "player0"  then
        if #cardcopy == 16 then
            grid:GetComponent('UIGrid').cellWidth = 75
        elseif #cardcopy == 15 then
            grid:GetComponent('UIGrid').cellWidth = 75
        else
            grid:GetComponent('UIGrid').cellWidth = 78
        end
        if #cards <= 15 then
            grid:GetComponent('UIGrid').cellWidth = 80.5
        else
            grid:GetComponent('UIGrid').cellWidth = 75
        end
    end
    --grid.gameObject:SetActive(false)
    --grid.gameObject:SetActive(true)
    --grid:GetComponent('UIGrid').enabled = false
    --grid:GetComponent('UIGrid').enabled = true
    grid:GetComponent('UIGrid'):Reposition()
    if grid.name == "GridOut" and grid.transform.parent.gameObject.name ~= "player0" then
        if grid.transform.parent.gameObject.name == "player1" then
            if #cardcopy > 10 then
                grid.transform.localPosition = Vector3(grid.transform.localPosition.x,-107,0)
            else
                grid.transform.localPosition = Vector3(grid.transform.localPosition.x,-35,0)
            end
        else
            -- if #cardcopy > 10 then
            --    grid.transform.localPosition = Vector3(grid.transform.localPosition.x,17,0)
            -- else
               grid.transform.localPosition = Vector3(grid.transform.localPosition.x,-35,0)
            -- end
        end
    end
end
function GetPlateNum(card)
    return getIntPart(card/4)+3
end

function GetPlateType(card)
    return getIntPart(card%4)
end

function FindAllCanPlayCards(myCards, otherCategory, otherCards, otherHasOneCard)
	print('FindAllCanPlayCards'..' otherCategory:'..otherCategory)

    local ret = {}
    if not myCards or (not otherCards) then
        Debugger.Log('param error', nil)
        return ret
    else
		local cardGroups = GetCardsGroup(myCards)
        local plateNum
        if otherCategory == DAN then
            local otherPlateNum = GetPlateNum(otherCards[1])
            for i=#myCards,1,-1 do
                    plateNum = GetPlateNum(myCards[i])
                if plateNum > otherPlateNum then
                    table.insert(ret, myCards[i])
					if otherHasOneCard then
                        ret[1] = myCards[1]
                        --table.insert(ret, myCards[1])
					end
                    --return ret,otherCategory
                end
            end
        elseif otherCategory == DUI then
            local group2 = GetGroupByID(2, cardGroups)
            local group3 = GetGroupByID(3, cardGroups)
            local all = {}

            for i=1,#group2 do
                table.insert(all, group2[i])
            end
            for i=1,#group3 do
                local tempGroup = {}
                table.insert(tempGroup, group3[i][1])
                table.insert(tempGroup, group3[i][2])
                table.insert(all, tempGroup)
            end

            table.sort(all, tableSortDescBySubtable)
            table.sort(otherCards, tableSortDesc)
            local otherPlateNum = GetPlateNum(otherCards[1])
            for i=#all,1,-1 do
                plateNum = GetPlateNum(all[i][1])
                if plateNum > otherPlateNum then
                    table.insert(ret, all[i])
                    --return all[i],otherCategory
                end
            end
		elseif otherCategory == SAN  or otherCategory == SAN_YI or otherCategory == SAN_ER then
			local group3 = GetGroupByID(3, cardGroups)
            local other_cardGroups = GetCardsGroup(otherCards)
            local other_group3 = GetGroupByID(3, other_cardGroups)
            local otherPlateNum = GetPlateNum(other_group3[1][1])
            for i=#group3,1,-1 do
                plateNum = GetPlateNum(group3[i][1])
                if plateNum > otherPlateNum then
                    table.insert(ret, group3[i])
                    --return group3[i],otherCategory
                end
            end
		elseif otherCategory == SHUN then
			local t = {}
			local delRepeat = {}
			for i=1,#myCards do
				plateNum = GetPlateNum(myCards[i])
				if not t[plateNum] and plateNum ~= 15 then
					table.insert(delRepeat, myCards[i])
					t[plateNum] = 1
				end
			end
			table.sort(delRepeat, tableSortDesc)
			table.sort(otherCards, tableSortDesc)
            local otherPlateNum = GetPlateNum(otherCards[1])
			if #delRepeat >= #otherCards and GetPlateNum(delRepeat[1]) > otherPlateNum then
				for i=#delRepeat+1-#otherCards, 1, -1 do
                    local minPlateNum = GetPlateNum(delRepeat[i+#otherCards-1])
                    plateNum = GetPlateNum(delRepeat[i])
                    if plateNum > otherPlateNum and (plateNum - minPlateNum) == #otherCards-1 then
                        for j=i,i+#otherCards-1 do
                            table.insert(ret, delRepeat[j])
                        end
						--return ret,otherCategory
					end
				end
			end
		elseif otherCategory == LIAN_DUI then
            local group2 = GetGroupByID(2, cardGroups)
            local group3 = GetGroupByID(3, cardGroups)
            local all = {}

            for i=1,#group2 do
                table.insert(all, group2[i])
            end
            for i=1,#group3 do
                local tempGroup = {}
                table.insert(tempGroup, group3[i][1])
                table.insert(tempGroup, group3[i][2])
                table.insert(all, tempGroup)
            end

            table.sort(all, tableSortDescBySubtable)
            table.sort(otherCards, tableSortDesc)
            local duiNum = getIntPart(#otherCards/2)
            if #all >= duiNum then
				local my_MaxNum = GetPlateNum(all[1][1])
				local other_MaxNum = GetPlateNum(otherCards[1])
				if my_MaxNum > other_MaxNum then
					for i=#all+1-duiNum,1,-1 do
						local minPlateNum = GetPlateNum(all[i+duiNum-1][1])
						plateNum = GetPlateNum(all[i][1])
						if plateNum > other_MaxNum and (plateNum - minPlateNum) == duiNum-1 then
							for j=i,i+duiNum-1 do
								table.insert(ret, all[j][1])
								table.insert(ret, all[j][2])
							end
							--return ret,otherCategory
						end
					end
				end
            end
		elseif otherCategory == SAN_SHUN or otherCategory == FEI_YI or otherCategory == FEI_ER then
            local group3 = GetGroupByID(3, cardGroups)
            local other_cardGroups = GetCardsGroup(otherCards)
            local other_group3 = GetGroupByID(3, other_cardGroups)

            table.sort(other_group3, tableSortDescBySubtable)

            if #group3 >= #other_group3 then
				local my_MaxNum = GetPlateNum(group3[1][1])
				local other_MaxNum = GetPlateNum(other_group3[1][1])
				if my_MaxNum > other_MaxNum then
					for i=#group3+1-#other_group3,1,-1 do
						local minPlateNum = GetPlateNum(group3[i+#other_group3-1][1])
						plateNum = GetPlateNum(group3[i][1])
						if plateNum > other_MaxNum and (plateNum - minPlateNum) == #other_group3-1 then
							for j=i,i+#other_group3-1 do
								table.insert(ret, group3[j][1])
								table.insert(ret, group3[j][2])
								table.insert(ret, group3[j][3])
							end
							--return ret,otherCategory
						end
					end
				end
            end
        elseif otherCategory == SI_ER then
            local group4 = GetGroupByID(4, cardGroups)
            if (#ret == 0) and (#group4 > 0) then
                ret = group4[#group4]
                --otherCategory = ZHA_DA
                --return ret,ZHA_DA
            end
            if roomData.setting.bombAAA  then
                local group3 = GetGroupByID(3, cardGroups)
                for i=#group3,1,-1 do
                    plateNum = GetPlateNum(group3[i][1])
                    if plateNum == 14 then
                        --ret = group3[i]
                        table.insert(ret, group3[i])
                        --otherCategory = ZHA_DA
                        --return ret,ZHA_DA
                    end
                end
            end
            --return ret
        elseif otherCategory == SI_SAN then
            local group4 = GetGroupByID(4, cardGroups)
            if (#ret == 0) and (#group4 > 0) then
                ret = group4[#group4]
                --otherCategory = ZHA_DA
                --return ret,ZHA_DA
            end
            if roomData.setting.bombAAA  then
                local group3 = GetGroupByID(3, cardGroups)
                for i=#group3,1,-1 do
                    plateNum = GetPlateNum(group3[i][1])
                    if plateNum == 14 then
                        --ret = group3[i]
                        table.insert(ret, group3[i])
                        --otherCategory = ZHA_DA
                        --return ret,ZHA_DA
                    end
                end
            end
			--return ret
        elseif otherCategory == ZHA_DA then
            print("别人出炸弹得情况")
            local group4 = GetGroupByID(4, cardGroups)
            local other_MaxNum = GetPlateNum(otherCards[1])
            for i=#group4,1,-1 do
                plateNum = GetPlateNum(group4[i][1])
                if plateNum > other_MaxNum then
                    --ret = group4[i]
                    table.insert(ret, group4[i])
                    --return ret,ZHA_DA
                end
            end
            if roomData.setting.bombAAA then
                local group3 = GetGroupByID(3, cardGroups)
                for i=#group3,1,-1 do
                    plateNum = GetPlateNum(group3[i][1])
                    if plateNum == 14 then
                        --ret = group3[i]
                        table.insert(ret, group3[i])
                        --return ret,ZHA_DA
                    end
                end
            end
            --return ret
        else
            print('unkown type')
            return ret
        end

        if otherCategory ~= ZHA_DA then
            local group4 = GetGroupByID(4, cardGroups)
            local other_MaxNum = GetPlateNum(otherCards[1])
            for i=#group4,1,-1 do
                plateNum = GetPlateNum(group4[i][1])
                if plateNum > other_MaxNum then
                    --ret = group4[i]
                    table.insert(ret, group4[i])
                    --return ret,ZHA_DA
                end
            end

            if roomData.setting.bombAAA then
                local group3 = GetGroupByID(3, cardGroups)
                for i=#group3,1,-1 do
                    plateNum = GetPlateNum(group3[i][1])
                    if plateNum == 14 then
                        --ret = group3[i]
                        table.insert(ret, group3[i])
                        --return ret --,ZHA_DA
                    end
                end
            end
        end
        -- if (#ret == 0) and (#group4 > 0) then
		-- 	ret = group4[#group4]
        --     return ret,ZHA_DA
        -- end
       return ret
    end
end


function FindCanPlayCards(myCards, otherCategory, otherCards, otherHasOneCard)
	print('FindCanPlayCards'..' otherCategory:'..otherCategory)

    local ret = {}
    if not myCards or (not otherCards) then
        Debugger.Log('param error', nil)
        return ret
    else
		local cardGroups = GetCardsGroup(myCards)
        local plateNum
        if otherCategory == DAN then
            local otherPlateNum = GetPlateNum(otherCards[1])
            for i=#myCards,1,-1 do
                plateNum = GetPlateNum(myCards[i])
                local group4 = GetGroupByID(4, cardGroups)
                local inbomb = false
                if roomData.setting.bombSplit == false then
                    for k = 1, #group4 do
                        for j = 1, #group4[k] do
                            if myCards[i] == group4[k][j] then
                                inbomb = true
                            end
                        end
                    end
                end
                if plateNum > otherPlateNum and inbomb == false then
                    table.insert(ret, myCards[i])
					if otherHasOneCard then
						ret[1] = myCards[1]
					end
                    return ret,otherCategory
                end
            end
        elseif otherCategory == DUI then
            local group2 = GetGroupByID(2, cardGroups)
            local group3 = GetGroupByID(3, cardGroups)
            local all = {}

            for i=1,#group2 do
                table.insert(all, group2[i])
            end
            for i=1,#group3 do
                local tempGroup = {}
                table.insert(tempGroup, group3[i][1])
                table.insert(tempGroup, group3[i][2])
                table.insert(all, tempGroup)
            end

            table.sort(all, tableSortDescBySubtable)
            table.sort(otherCards, tableSortDesc)
            local otherPlateNum = GetPlateNum(otherCards[1])
            for i=#all,1,-1 do
                plateNum = GetPlateNum(all[i][1])
                if plateNum > otherPlateNum then
                    return all[i],otherCategory
                end
            end
		elseif otherCategory == SAN  or otherCategory == SAN_YI or otherCategory == SAN_ER then
			local group3 = GetGroupByID(3, cardGroups)
            local other_cardGroups = GetCardsGroup(otherCards)
            local other_group3 = GetGroupByID(3, other_cardGroups)
            local otherPlateNum = GetPlateNum(other_group3[1][1])
            for i=#group3,1,-1 do
                plateNum = GetPlateNum(group3[i][1])
                if plateNum > otherPlateNum then
                    return group3[i],otherCategory
                end
            end
		elseif otherCategory == SHUN then
			local t = {}
			local delRepeat = {}
			for i=1,#myCards do
                plateNum = GetPlateNum(myCards[i])
                local group4 = GetGroupByID(4, cardGroups)
                local inbomb = false
                if roomData.setting.bombSplit == false then
                    for k = 1, #group4 do
                        for j = 1, #group4[k] do
                            if myCards[i] == group4[k][j] then
                                inbomb = true
                            end
                        end
                    end
                end
				if not t[plateNum] and plateNum ~= 15 and inbomb == false then
					table.insert(delRepeat, myCards[i])
					t[plateNum] = 1
				end
			end
			table.sort(delRepeat, tableSortDesc)
			table.sort(otherCards, tableSortDesc)
            local otherPlateNum = GetPlateNum(otherCards[1])
			if #delRepeat >= #otherCards and GetPlateNum(delRepeat[1]) > otherPlateNum then
				for i=#delRepeat+1-#otherCards, 1, -1 do
                    local minPlateNum = GetPlateNum(delRepeat[i+#otherCards-1])
                    plateNum = GetPlateNum(delRepeat[i])
                    if plateNum > otherPlateNum and (plateNum - minPlateNum) == #otherCards-1 then
                        for j=i,i+#otherCards-1 do
                            table.insert(ret, delRepeat[j])
                        end
						return ret,otherCategory
					end
				end
			end
		elseif otherCategory == LIAN_DUI then
            local group2 = GetGroupByID(2, cardGroups)
            local group3 = GetGroupByID(3, cardGroups)
            local all = {}

            for i=1,#group2 do
                table.insert(all, group2[i])
            end
            for i=1,#group3 do
                local tempGroup = {}
                table.insert(tempGroup, group3[i][1])
                table.insert(tempGroup, group3[i][2])
                table.insert(all, tempGroup)
            end

            table.sort(all, tableSortDescBySubtable)
            table.sort(otherCards, tableSortDesc)
            local duiNum = getIntPart(#otherCards/2)
            if #all >= duiNum then
				local my_MaxNum = GetPlateNum(all[1][1])
				local other_MaxNum = GetPlateNum(otherCards[1])
				if my_MaxNum > other_MaxNum then
					for i=#all+1-duiNum,1,-1 do
						local minPlateNum = GetPlateNum(all[i+duiNum-1][1])
						plateNum = GetPlateNum(all[i][1])
						if plateNum > other_MaxNum and (plateNum - minPlateNum) == duiNum-1 then
							for j=i,i+duiNum-1 do
								table.insert(ret, all[j][1])
								table.insert(ret, all[j][2])
							end
							return ret,otherCategory
						end
					end
				end
            end
		elseif otherCategory == SAN_SHUN or otherCategory == FEI_YI or otherCategory == FEI_ER then
            local group3 = GetGroupByID(3, cardGroups)
            local other_cardGroups = GetCardsGroup(otherCards)
            local other_group3 = GetGroupByID(3, other_cardGroups)

            table.sort(other_group3, tableSortDescBySubtable)
            --print("@@@@@@@@@@@@@@@#other_group3",#other_group3,GetPlateNum(other_group3[1][1]))
            if #other_group3 == 3 and (GetPlateNum(other_group3[1][1]) - GetPlateNum(other_group3[2][1]) ~= 1) then
                table.remove(other_group3,1)
                -- for i = 1,#other_group3  do
                --     for k = 1,#other_group3[i]  do
                --         print(other_group3[i][k])
                --         print(GetPlateNum(other_group3[i][k]))
                --     end
                -- end
            end
            --print("#############other_group3",#other_group3,GetPlateNum(other_group3[1][1]))
            if #group3 >= #other_group3 then
				local my_MaxNum = GetPlateNum(group3[1][1])
				local other_MaxNum = GetPlateNum(other_group3[1][1])
				if my_MaxNum > other_MaxNum then
					for i=#group3+1-#other_group3,1,-1 do
						local minPlateNum = GetPlateNum(group3[i+#other_group3-1][1])
						plateNum = GetPlateNum(group3[i][1])
						if plateNum > other_MaxNum and (plateNum - minPlateNum) == #other_group3-1 then
							for j=i,i+#other_group3-1 do
								table.insert(ret, group3[j][1])
								table.insert(ret, group3[j][2])
								table.insert(ret, group3[j][3])
							end
							return ret,otherCategory
						end
					end
				end
            end
        elseif otherCategory == SI_ER then
            local group4 = GetGroupByID(4, cardGroups)
            if (#ret == 0) and (#group4 > 0) then
                ret = group4[#group4]
                return ret,ZHA_DA
            end
            if roomData.setting.bombAAA  then
                local group3 = GetGroupByID(3, cardGroups)
                for i=#group3,1,-1 do
                    plateNum = GetPlateNum(group3[i][1])
                    if plateNum == 14 then
                        ret = group3[i]
                        return ret,ZHA_DA
                    end
                end
            end
            return ret
        elseif otherCategory == SI_SAN then
            local group4 = GetGroupByID(4, cardGroups)
            if (#ret == 0) and (#group4 > 0) then
                ret = group4[#group4]
                return ret,ZHA_DA
            end
            if roomData.setting.bombAAA  then
                local group3 = GetGroupByID(3, cardGroups)
                for i=#group3,1,-1 do
                    plateNum = GetPlateNum(group3[i][1])
                    if plateNum == 14 then
                        ret = group3[i]
                        return ret,ZHA_DA
                    end
                end
            end
			return ret
        elseif otherCategory == ZHA_DA then
            print("别人出炸弹得情况")
            local group4 = GetGroupByID(4, cardGroups)
            local other_MaxNum = GetPlateNum(otherCards[1])
            for i=#group4,1,-1 do
                plateNum = GetPlateNum(group4[i][1])
                if plateNum > other_MaxNum then
                    ret = group4[i]
                    return ret,ZHA_DA
                end
            end
            if roomData.setting.bombAAA then
                local group3 = GetGroupByID(3, cardGroups)
                for i=#group3,1,-1 do
                    plateNum = GetPlateNum(group3[i][1])
                    if plateNum == 14 then
                        ret = group3[i]
                        return ret,ZHA_DA
                    end
                end
            end
            return ret
        else
            print('unkown type')
            return ret
        end

        local group4 = GetGroupByID(4, cardGroups)
        if (#ret == 0) and (#group4 > 0) then
			ret = group4[#group4]
            return ret,ZHA_DA
        end

        if roomData.setting.bombAAA then
            local group3 = GetGroupByID(3, cardGroups)
            for i=#group3,1,-1 do
                plateNum = GetPlateNum(group3[i][1])
                if plateNum == 14 then
                    ret = group3[i]
                    return ret,ZHA_DA
                end
            end
        end

       return ret
    end
end

function CheckCanPlay(myChooseCards, myCards, otherCategory, otherCards, otherHasOneCard)
	if otherCards then
		print('CheckCanPlay otherCards:'..#otherCards..' otherCategory:'..otherCategory..' otherHasOneCard:'..tostring(otherHasOneCard))
	else
		print('CheckCanPlay otherCards:nil otherHasOneCard:'..tostring(otherHasOneCard))
	end
	
    table.sort(myChooseCards, tableSortDesc)
    local cardGroups = GetCardsGroup(myChooseCards)
    local group4 = GetGroupByID(4, cardGroups)
    local group3 = GetGroupByID(3, cardGroups)
    local group2 = GetGroupByID(2, cardGroups)
    local group1 = GetGroupByID(1, cardGroups)
    -- for k, v in pairs(group4) do
    --     print("group4",k,v)
    -- end
    -- for k, v in pairs(group3) do
    --     print("group3",k,v)
    -- end
    -- for k, v in pairs(group2) do
    --     print("group2",k,v)
    -- end
    -- for k, v in pairs(group1) do
    --     print("group1",k,v)
    -- end
    table.sort(myCards, tableSortDesc)
    local myCardGroups = GetCardsGroup(myCards)
    local myZhaDanGroup = GetGroupByID(4, myCardGroups)
    -- for k, v in pairs(myZhaDanGroup) do
    --     print("myZhaDanGroup",k,v)
    -- end
    local isClearHand = false
    isClearHand = #myChooseCards == #myCards
    if #group4 > 0 then
        -- print("#group4 * 4",#group4 * 4)
        -- print("#myChooseCards",#myChooseCards)
        -- print(#group4 * 4 ~=  #myChooseCards)
        -- print("roomData.setting.bombSplit",roomData.setting.bombSplit)
        -- print("roomData.setting.bombBelt",roomData.setting.bombBelt)
        -- print("roomData.setting.bombBelt",roomData.setting.bombBeltTwo)
        local g1 = false
        local g2 = false
        local g3 = false
        local g4 = false
        local g5 = false
        local g6 = false
        if roomData.setting.bombBelt and roomData.setting.bombBeltTwo then
            if #myChooseCards ~= 4 then  -- #group4 * 4 
                g1 = false 
            else
                g1 = true
                --return false
            end
            if  #myChooseCards ~=  6  then -- #group4 * 4 
                g2 = false
            else
                g2 = true
            end
            if  #myChooseCards ~=  7  then -- #group4 * 4 
                g3 = false
            else
                g3 = true
            end
            if roomData.setting.bombSplit == true then
                local vv = {}
                for i = 1, #myChooseCards do
                    vv[i] = myChooseCards[i]
                end
                table.sort(vv, tableSortDesc)
                for x = 1, #group4 do
                    for i = 1, #vv do
                        if vv[i] == group4[x][1] then
                            table.remove(vv,i)
                            break
                        end
                    end
                end
                local cardGroups = GetCardsGroup(vv)
                local vvgroup3 = GetGroupByID(3, cardGroups)
                local ishavesanlian = false
                for k = 1, #vvgroup3 do
                    if k+2 <= #vvgroup3 then
                        if GetPlateNum(vvgroup3[k][1]) - GetPlateNum(vvgroup3[k+2][1]) == 2 then
                            ishavesanlian = true
                        end
                    end
                end
                if isClearHand then
                    if ishavesanlian  == true and #myChooseCards < 16 then
                        g6 = true
                    else
                        g6 = false
                    end
                else
                    if ishavesanlian  == true and #myChooseCards == 15 then
                        g6 = true
                    else
                        g6 = false
                    end
                end
            end
            if isClearHand then
                if #myChooseCards ~= 5 then  -- #group4 * 4 
                    g4 = false
                else
                    g4 = true
                end
                if g1 == false and  g2 == false and  g3 == false  and g4 == false and g6 == false then
                    return  false
                end
            else
                if g1 == false and  g2 == false and g3 == false and g6 == false then
                    return  false
                end
            end
        elseif roomData.setting.bombBelt == false and roomData.setting.bombBeltTwo then
            if #myChooseCards ~= 4 then  -- #group4 * 4 
                g1 = false 
            else
                g1 = true
                --return false
            end
            if  #myChooseCards ~=  6  then -- #group4 * 4 
                g2 = false
            else
                g2 = true
            end
            if roomData.setting.bombSplit == true then
                local vv = {}
                for i = 1, #myChooseCards do
                    vv[i] = myChooseCards[i]
                end
                table.sort(vv, tableSortDesc)
                for x = 1, #group4 do
                    for i = 1, #vv do
                        if vv[i] == group4[x][1] then
                            table.remove(vv,i)
                            break
                        end
                    end
                end
                local cardGroups = GetCardsGroup(vv)
                local vvgroup3 = GetGroupByID(3, cardGroups)
                local ishavesanlian = false
                for k = 1, #vvgroup3 do
                    if k+2 <= #vvgroup3 then
                        if GetPlateNum(vvgroup3[k][1]) - GetPlateNum(vvgroup3[k+2][1]) == 2 then
                            ishavesanlian = true
                        end
                    end
                end
                if isClearHand then
                    if ishavesanlian  == true and #myChooseCards < 16 then
                        g6 = true
                    else
                        g6 = false
                    end
                else
                    if ishavesanlian  == true and #myChooseCards == 15 then
                        g6 = true
                    else
                        g6 = false
                    end
                end
            end
            if isClearHand then
                if #myChooseCards ~= 5 then  -- #group4 * 4 
                    g3 = false
                else
                    g3 = true
                end
                if g1 == false and  g2 == false and  g3 == false  and g6 == false then
                    return  false
                end
            else
                if g1 == false and  g2 == false and g6 == false then
                    return  false
                end
            end
        elseif roomData.setting.bombBelt  and roomData.setting.bombBeltTwo == false then
            if #myChooseCards ~= 4 then  -- #group4 * 4 
                g1 = false 
            else
                g1 = true
                --return false
            end
            if  #myChooseCards ~=  7  then -- #group4 * 4 
                g2 = false
            else
                g2 = true
            end
            if roomData.setting.bombSplit == true then
                local vv = {}
                for i = 1, #myChooseCards do
                    vv[i] = myChooseCards[i]
                end
                table.sort(vv, tableSortDesc)
                for x = 1, #group4 do
                    for i = 1, #vv do
                        if vv[i] == group4[x][1] then
                            table.remove(vv,i)
                            break
                        end
                    end
                end
                local cardGroups = GetCardsGroup(vv)
                local vvgroup3 = GetGroupByID(3, cardGroups)
                local ishavesanlian = false
                for k = 1, #vvgroup3 do
                    if k+2 <= #vvgroup3 then
                        if GetPlateNum(vvgroup3[k][1]) - GetPlateNum(vvgroup3[k+2][1]) == 2 then
                            ishavesanlian = true
                        end
                    end
                end
                if isClearHand then
                    if ishavesanlian  == true and #myChooseCards < 16 then
                        g6 = true
                    else
                        g6 = false
                    end
                else
                    if ishavesanlian  == true and #myChooseCards == 15 then
                        g6 = true
                    else
                        g6 = false
                    end
                end
            end
            if isClearHand then
                if #myChooseCards ~= 5 then  -- #group4 * 4 
                    g3 = false
                else
                    g3 = true
                end
                if #myChooseCards ~= 6 then  -- #group4 * 4 
                    g4 = false
                else
                    g4 = true
                end

                if g1 == false and  g2 == false and  g3 == false and  g4 == false  and g6 == false then
                    return  false
                end
            else
                if g1 == false and  g2 == false and g6 == false then
                    return  false
                end
            end
        elseif roomData.setting.bombBelt == false and roomData.setting.bombBeltTwo == false then
            if roomData.setting.bombSplit == true then
                local vv = {}
                for i = 1, #myChooseCards do
                    vv[i] = myChooseCards[i]
                end
                table.sort(vv, tableSortDesc)
                for x = 1, #group4 do
                    for i = 1, #vv do
                        if vv[i] == group4[x][1] then
                            table.remove(vv,i)
                            break
                        end
                    end
                end
                local cardGroups = GetCardsGroup(vv)
                local vvgroup3 = GetGroupByID(3, cardGroups)
                local ishavesanlian = false
                for k = 1, #vvgroup3 do
                    if k+2 <= #vvgroup3 then
                        if GetPlateNum(vvgroup3[k][1]) - GetPlateNum(vvgroup3[k+2][1]) == 2 then
                            ishavesanlian = true
                        end
                    end
                end
                if isClearHand then
                    if ishavesanlian  == true and #myChooseCards < 16 then
                        g6 = true
                    else
                        g6 = false
                    end
                else
                    if ishavesanlian  == true and #myChooseCards == 15 then
                        g6 = true
                    else
                        g6 = false
                    end
                end
            end
            if #myChooseCards ~= 4 and g6 == false then  -- #group4 * 4 
                --print('CheckCanPlay5')
                return false
            end
        end
        if roomData.setting.bombSplit == false then
            if #group3 > 0 then
                for i = 1, #group3[1] do
                    for k = 1, #myZhaDanGroup do
                        for j = 1, #myZhaDanGroup[k] do
                            if group3[1][i] == myZhaDanGroup[k][j] then
                                return false
                            end
                        end
                    end
                end
            end
            if #group2 > 0 then
                for i = 1, #group2[1] do
                    for k = 1, #myZhaDanGroup do
                        for j = 1, #myZhaDanGroup[k] do
                            if group2[1][i] == myZhaDanGroup[k][j] then
                                return false
                            end
                        end
                    end
                end
            end
            if #group1 > 0 then
                for i = 1, #group1 do
                    for k = 1, #myZhaDanGroup do
                        for j = 1, #myZhaDanGroup[k] do
                            if group1[i][1] == myZhaDanGroup[k][j] then
                                return false
                            end
                        end
                    end
                end
            end
        end
    elseif #group3 > 0 then
        --isClearHand = #myChooseCards == #myCards
        if roomData.setting.bombAAA  then
            if #myChooseCards == 3 then
                --print("GetPlateNum(group3[1][1])",GetPlateNum(group3[1][1]),"isClearHand",isClearHand)
                if GetPlateNum(group3[1][1]) ~= 14 and not isClearHand then
                    return false
                end
            else
                local num = GroupInOrderForSanDai(group3)
                if not isClearHand and (#myChooseCards ~= (num)*3 + (num)*2) then
                    --print('CheckCanPlay1')
                    return false
                elseif isClearHand and (#myChooseCards > (num)*3 + (num)*2) then
                    --print('CheckCanPlay1-2')
                    return false
                end
        
                if not GroupInOrderForSanDai1(group3) then
                    --print('CheckCanPlay2')
                    return false
                end
                if roomData.setting.bombSplit == false then
                    for i = 1, #myChooseCards do
                        for k = 1, #myZhaDanGroup do
                            print("myChooseCards",myChooseCards[i])
                            for j = 1, #myZhaDanGroup[k] do
                                print("myZhaDanGroup[k][j]",myZhaDanGroup[k][j])
                                if myChooseCards[i] == myZhaDanGroup[k][j] then
                                    return false
                                end
                            end
                        end
                    end
                end
                print("group3全部满足")
            end
        else
            local num = GroupInOrderForSanDai(group3)
            print("实际连着的三带数量为",num)
            if not isClearHand and (#myChooseCards ~= (num)*3 + (num)*2) then --(#group3)*3 + (#group3)*2)
                print('不是净手不符合规则')
                return false
            elseif isClearHand and (#myChooseCards > (num)*3 + (num)*2) then --(#group3)*3 + (#group3)*2)
                print('净手并且不符合规则')
                return false
            end
    
            if not GroupInOrderForSanDai1(group3) then
                print('不是连着的三个')
                return false
            end
            if roomData.setting.bombSplit == false then
                for i = 1, #myChooseCards do
                    for k = 1, #myZhaDanGroup do
                        --print("myChooseCards",myChooseCards[i])
                        for j = 1, #myZhaDanGroup[k] do
                            --print("myZhaDanGroup[k][j]",myZhaDanGroup[k][j])
                            if myChooseCards[i] == myZhaDanGroup[k][j] then
                                return false
                            end
                        end
                    end
                end
            end
        end
    elseif #group2 > 0 then
        if #group2 * 2 ~=  #myChooseCards then
			--print('CheckCanPlay3')
            return false
        end
        
        if not GroupInOrder(group2) then
			--print('CheckCanPlay4')
            return false
        end
        if roomData.setting.bombSplit == false then
            for i = 1, #myChooseCards do
                for k = 1, #myZhaDanGroup do
                    --print("myChooseCards",myChooseCards[i])
                    for j = 1, #myZhaDanGroup[k] do
                        --print("myZhaDanGroup[k][j]",myZhaDanGroup[k][j])
                        if myChooseCards[i] == myZhaDanGroup[k][j] then
                            return false
                        end
                    end
                end
            end
        end
    elseif #group1 >0 then
        if not GroupInOrder(group1) or (#group1 > 1 and #group1 < 5) or (#group1 > 1 and GetPlateNum(myChooseCards[1]) == 15) then
			--print('CheckCanPlay6')
            return false
        end
		if #group1 == 1 and otherHasOneCard then
			local my_maxNum = GetPlateNum(myChooseCards[1])
            local maxNumHave = GetPlateNum(myCards[1])
            if my_maxNum ~= maxNumHave then
				--print('CheckCanPlay6-1')
                return false
            end
        end
        if roomData.setting.bombSplit == false then
            for i = 1, #myChooseCards do
                for k = 1, #myZhaDanGroup do
                    --print("myChooseCards",myChooseCards[i])
                    for j = 1, #myZhaDanGroup[k] do
                        --print("myZhaDanGroup[k][j]",myZhaDanGroup[k][j])
                        if myChooseCards[i] == myZhaDanGroup[k][j] then
                            return false
                        end
                    end
                end
            end
        end
                    -- for i = 1, #group1 do
            --     for k = 1, #myZhaDanGroup do
            --         print("group1[i][1]",group1[i][1])
            --         for j = 1, #myZhaDanGroup[k] do
            --             print("myZhaDanGroup[k][j]",myZhaDanGroup[k][j])
            --             if group1[i][1] == myZhaDanGroup[k][j] then
            --                 return false
            --             end
            --         end
            --     end
            -- end
    else
		print('myChooseCards is 0, or group error!')
        return false
    end
    --print("otherCards",otherCards)
    --print("otherCategory",otherCategory)
    if (not otherCards) or (not otherCategory) then
		print("可以出这个牌")
        return true
    end

	--与别人牌型比较
    table.sort(otherCards, tableSortDesc)
    local my_maxNum = GetPlateNum(myChooseCards[1])
    local other_maxNum = GetPlateNum(otherCards[1])
	local otherGroup = GetCardsGroup(otherCards)
    --炸弹只需关心别人也出炸弹的情况
    if roomData.setting.bombAAA then
        if  #group3 == 1 and GetPlateNum(group3[1][1])  == 14 and #myChooseCards == 3 then
            return true
        end
    end
    if #group4 > 0 then
        if otherCategory == ZHA_DA then
            if #myChooseCards ~= 4 then
                return  false
            end
            if my_maxNum <= other_maxNum then
                print('CheckCanPlay7')
                print("不可以炸他")
                return false
            end
        elseif otherCategory == SI_ER then
            if isClearHand  then
                if #myChooseCards ~= 6 and #myChooseCards ~= 5 and  #myChooseCards ~= 4 then
                    print("bumanzu11111111111")
                    return  false
                end
            else
                if #myChooseCards ~= 6 and  #myChooseCards ~= 4 then
                    print("bumanzu22222222222")
                    return  false
                end
            end
            local otherGroup4 = GetGroupByID(4, otherGroup)
            my_maxNum = GetPlateNum(group4[1][1])
            other_maxNum = GetPlateNum(otherGroup4[1][1])
            if #myChooseCards == 4 then
                --if my_maxNum <= other_maxNum then
                    print("直接炸死")
                    return true
                --end
            else
                if my_maxNum <= other_maxNum then
                    print("四代二得炸弹小于别人得炸弹")
                    return false
                end
            end
            return  true
        elseif otherCategory == SI_SAN then
            if isClearHand  then
                if #myChooseCards ~= 7 and #myChooseCards ~= 6 and #myChooseCards ~= 5 and  #myChooseCards ~= 4 then
                    print("bumanzu11111111111")
                    return  false
                end
            else
                if #myChooseCards ~= 7  and  #myChooseCards ~= 4 then
                    print("bumanzu22222222222")
                    return  false
                end
            end
            local otherGroup4 = GetGroupByID(4, otherGroup)
            my_maxNum = GetPlateNum(group4[1][1])
            other_maxNum = GetPlateNum(otherGroup4[1][1])
            if #myChooseCards == 4 then
                --if my_maxNum <= other_maxNum then
                    print("直接炸死")
                    return true
                --end
            else
                if my_maxNum <= other_maxNum then
                    print("四代三得炸弹小于别人得炸弹")
                    return false
                end
            end
            return  true
        else
            if #myChooseCards > 4 then
                print("4d几不可以炸他")
                return false
            end
            print("可以炸他")
            return true
        end
    else
        if otherCategory == ZHA_DA or otherCategory == SI_ER or otherCategory == SI_ER  then
            return false
        end
    end

	--单牌要考虑下家是否报单的情况
    if otherCategory == DAN then
        if otherHasOneCard then
            local maxNumHave = GetPlateNum(myCards[1])
            if my_maxNum ~= maxNumHave then
				--print('CheckCanPlay8')
                return false
            end
        end
	elseif otherCategory == DUI or otherCategory == LIAN_DUI then
		local otherGroup2 = GetGroupByID(2, otherGroup)
		if #group2 ~= #otherGroup2 then
			--print('CheckCanPlay8-1')
            return false
		end
	--如果是三带几只考虑主牌大小和数量
	elseif otherCategory == SAN  or otherCategory == SAN_YI or otherCategory == SAN_ER or otherCategory == SAN_SHUN or otherCategory == FEI_YI or otherCategory == FEI_ER then
        local otherGroup3 = GetGroupByID(3, otherGroup)
        --table.sort(otherGroup3, tableSortDescBySubtable)
        --print("@@@@@@@@@@@@@@@#other_group3",#otherGroup3,GetPlateNum(otherGroup3[1][1]))
        if #otherGroup3 == 3 and (GetPlateNum(otherGroup3[1][1]) - GetPlateNum(otherGroup3[2][1]) ~= 1) then
            table.remove(otherGroup3,1)
        end
        --print("#############other_group3",#otherGroup3,GetPlateNum(otherGroup3[1][1]))

        -- local DebugStr = ""
        -- for key, value in pairs(group3) do
        --     DebugStr = DebugStr..'"'..json:encode(key)..'":'..json:encode(value).."|"
        -- end
        -- print("牌的数量类型："..DebugStr)

        -- print('测试：'..tostring(GetGroup3(#otherGroup3, group3)))
        print('#group3: '..tostring(#group3)..'#otherGroup3：'..tostring(#otherGroup3))
        if #group3 ~= #otherGroup3 then
            print("进到了这里")
			return false
        end
        
        -- if #group3 == #otherGroup3 then
        --     return true
        -- elseif GetGroup3(#otherGroup3, group3) then
        --     return true
        -- else
        --     return false
        -- end

		my_maxNum = GetPlateNum(group3[1][1])
		other_maxNum = GetPlateNum(otherGroup3[1][1])
		if my_maxNum <= other_maxNum then
			--print('CheckCanPlay9')
			return false
		end
		--净手情况特殊
		if isClearHand then
			return true
		end
	elseif otherCategory == SHUN then
		local otherGroup1 = GetGroupByID(1, otherGroup)
		if #group1 ~= #otherGroup1 then
			--print('CheckCanPlay9-1')
			return false
		end
	end
	
	--其它情况都必需数量相同并且大于上家出牌
	if my_maxNum <= other_maxNum then
		--print('CheckCanPlay110')
        return false
    end
	if #myChooseCards ~= #otherCards then
		--print('CheckCanPlay11')
        return false
    end
	
	return true
end

function GetCardsGroup(myCards)
    local cardGroups={}
    local cardFlag={}
    table.sort(myCards, tableSortDesc)
    for i=1,#myCards do
        if not cardFlag[myCards[i]] or cardFlag[myCards[i]] == false then
            local group = {}
            table.insert(group, myCards[i])
            cardFlag[myCards[i]] = true
            local plateNumI = GetPlateNum(myCards[i])

            for j=i+1,#myCards do
                local plateNumJ = GetPlateNum(myCards[j])
                if plateNumI == plateNumJ then
                    table.insert(group, myCards[j])
                    cardFlag[myCards[j]] = true 
                else
                    cardFlag[myCards[j]] = false
                end
            end
            if not cardGroups[#group] then  
                cardGroups[#group] = {}
            end
            table.insert(cardGroups[#group], group)
		end
	end
	return cardGroups
end

function GetGroupByID(groupID, cardGroup)
    if cardGroup[groupID] then
        return cardGroup[groupID]
    else
        return {}
    end
end

function GroupInOrderForSanDai(group)
    local num = 1
    for i = 1, #group do
        if i < #group then
            if GetPlateNum(group[i][1]) - GetPlateNum(group[i+1][1]) == 1 then
                num = num + 1
            end
        end
    end
    return num
end
function GroupInOrderForSanDai1(group)
    if #group > 1  then
        for i = 1, #group do
            if i < #group then
                if GetPlateNum(group[i][1]) - GetPlateNum(group[i+1][1]) == 1 then
                    return  true
                end
            end
        end
        return false
    else
        return true
    end
end

function GroupInOrder(group)
    if #group > 1 then
        local maxNum = GetPlateNum(group[1][1])
        local minNum = GetPlateNum(group[#group][1])
        if maxNum - minNum ~= #group-1 then
			print('GroupInOrder maxNum:'..maxNum..' minNum:'..minNum..' groupNum:'..#group)
            return false
        end
    end

    return true
end

function GetGroup3(count, group3)

    if #group3 < count then
        return false
    end

    if #group3 == count  then
        return true
    end

    local copyGroup3 = {}
    for i=2,#group3 do
        table.insert(copyGroup3, group3[i])
    end

    local cur = GetPlateNum(group3[1][1])
    for i = 1, #copyGroup3 do
        print('1:'..tostring(GetPlateNum(copyGroup3[i][1]))..'2：'..tostring((cur - i)))
        if GetPlateNum(copyGroup3[i][1]) == (cur - i) then
            if (i + 1) >= count then
                return true
            end
        end
    end

    return false
end

function GetUpdateNotice(isGongGao)
	local msg = Message.New()
	msg.type = proxy_pb.MAINTAIN_NOTICE
    SendProxyMessage(msg, function (msg)
		local b = proxy_pb.RMaintainNotice()
		b:ParseFromString(msg.body)
		local data = {}
		data.isGongGao = isGongGao
		data.info = b
		if b.status == 1 then
			PanelManager.Instance:ShowWindow('panelUpdateNotice', data)
		end
	end);
end

function GetLastActive(newTime, lastTime)

    local time = newTime - lastTime
    local hour = tonumber(string.format("%d", time / 3600))
    local day = tonumber(string.format("%d", hour / 24))
    local month = tonumber(string.format("%d", day / 30))
    local year = tonumber(string.format("%d", month / 12))
    
    -- print(time)
    -- print(os.date("%c", lastTime).."年："..(month / 12)..",月："..(day / 30)..",天："..(hour / 24)..",小时："..(time / 3600))

    if year >= 1 then
        return year..'年前'
    else
        if month >= 1 then
            return '1月前'--month..'月前'
        else
            if day >= 1 then
                return day..'天前'
            else
                if hour >= 1 then
                    return hour..'小时前'
                else
                    return '一小时内'
                end
            end
        end
    end
end

function isNullPrivilege()
  
    if panelClub.clubInfo.userType == proxy_pb.GENERAL then
        return false;
    end

    if (panelClub.clubInfo.privilege == nil or panelClub.clubInfo.privilege == 0) then
        return false;
    end
end

function IsCanSetPlay()
    
    if panelClub.clubInfo.userType == proxy_pb.LORD then
        return true
    end

    if isNullPrivilege() then
        return false;
    end

    return bit:_and(panelClub.clubInfo.privilege, 4) == 4
end


function IsCanSetGonggao()

    if panelClub.clubInfo.userType == proxy_pb.LORD then
        return true
    end

    if isNullPrivilege() then
        return false;
    end

    return bit:_and(panelClub.clubInfo.privilege, 32) == 32
end

function IsCanDestoryRoom()
    if panelClub.clubInfo.userType == proxy_pb.LORD then
        return true
    end

    if isNullPrivilege() then
        return false;
    end

    return bit:_and(panelClub.clubInfo.privilege, 2) == 2
end

function IsCanOperatingMenber()
    if panelClub.clubInfo.userType == proxy_pb.LORD then
        return true
    end

    if isNullPrivilege() then
        return false;
    end

    return bit:_and(panelClub.clubInfo.privilege, 1) == 1
end

function IsCanOperatingRemoveMenber()
    if panelClub.clubInfo.userType == proxy_pb.LORD then
        return true
    end

    if isNullPrivilege() then
        return false;
    end

    return bit:_and(panelClub.clubInfo.privilege, 1024) == 1024
end

function IsCanStopRoom()
    if panelClub.clubInfo.userType == proxy_pb.LORD then
        return true
    end

    if isNullPrivilege() then
        return false;
    end

    return bit:_and(panelClub.clubInfo.privilege, 8) == 8
end

function isCanCleanMySelfFeeBalance()
    if panelClub.clubInfo.userType == proxy_pb.LORD then
        return true
    end

    if isNullPrivilege() then
        return false;
    end

    return bit:_and(panelClub.clubInfo.privilege, 64) == 64 or bit:_and(panelClub.clubInfo.privilege, 4096) == 4096 or bit:_and(panelClub.clubInfo.privilege, 8192) == 8192
end

function isCanCleanAllFeeBalance()
    if panelClub.clubInfo.userType == proxy_pb.LORD then
        return true
    end

    if isNullPrivilege() then
        return false;
    end

    return bit:_and(panelClub.clubInfo.privilege, 128) == 128 or bit:_and(panelClub.clubInfo.privilege, 65536) == 65536 or bit:_and(panelClub.clubInfo.privilege, 131072) == 131072
end

function isCanCleanMemangerFeeBalance()
    if panelClub.clubInfo.userType == proxy_pb.LORD then
        return true
    end

    if isNullPrivilege() then
        return false;
    end

    return bit:_and(panelClub.clubInfo.privilege,256) == 256 or bit:_and(panelClub.clubInfo.privilege,16384) == 16384 or bit:_and(panelClub.clubInfo.privilege,32768) == 32768
end

function IsGuideCompleted()
    return UnityEngine.PlayerPrefs.GetInt('GuideCompleted', 0) == 1
end

function print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end



function tableCount(countTable)
    local count = 0;
    for i, v in pairs(countTable) do
        count = count+1;
    end
    return count;
end


--胡牌类型-------->胡牌预制名称
local Category_Prefab =
{
    "jiajh","hu","dsx","lls","bbh","queys","th","dihu","pph","jjh","qingys","qxd","hqxd","cqxd","cqxd","gskh","qgh","hdly","qqr","gh","gsp","jjg","yzh","sant","jtyn","hdp","ztsx","ztlls"
}

--胡牌类型--------->胡牌类型的名字
local Category_Name =
{
    "假将胡","平胡", "大四喜", "六六顺", "板板胡", "缺一色", "天胡", "地胡", "碰碰胡", "将将胡", "清一色", "小七对", "豪华小七对", "双豪华小七对", "三豪华小七对", "杠上开花", "抢杠胡", "海底捞月", "全求人", "点杠胡", "杠上炮","节节高","一枝花","三同","金童玉女","海底炮","中途四喜","中途六六顺","门清"
}

function GetCategoryPrefabStr()
    return Category_Prefab;
end

function GetCategoryNameStr()
    return Category_Name;
end

--获得胡牌的结果字符串
function GetMJWinResult(huCategories,setting)
    if(huCategories == nil) then
        return "";
    end

    local resultString = "";
    function getCategoryName(key,value)
        if value.num > 1 then
            return Category_Name[key+1].."X"..value.num..",";
        else
            return Category_Name[key+1]..",";
        end
    end

    for key, value in pairs(huCategories) do

        if setting.roomTypeValue == proxy_pb.CSM then
            if value.category ~= 0 and value.category ~= 1 then
                resultString = resultString .. getCategoryName(value.category,value);
            end
        else
            if value.category >= 11 and value.category <= 14  then
                resultString = resultString .. getCategoryName(value.category,value);
            end
        end
    end

    return resultString;
end

--获得该牌再Table中的个数
function GetMJPlateCount(mahjongs,plate)
    local count = 0;
    for i = 1, #mahjongs do
        if mahjongs[i] == plate then
            count = count+1;
        end
    end

    return count;
end

--获得听牌的牌在手牌中的位置
function GetMJTingPosKey(mahjongs,tingTips)
    if not mahjongs or not tingTips then return -1 end;

    local posKey = {};
    for firdex = 1, #mahjongs do

        for secdex = 1, #tingTips do
            if mahjongs[firdex] == tingTips[secdex].mahjong then
                local data = {};
                data.posKey = firdex;
                data.tingMahjongs = tingTips[secdex].tingMahjongs;
                table.insert(posKey,data);
            end
        end

    end

    return posKey;
end

--[[
    @desc: 检查是否为整数
    author:{author}
    time:2019-02-01 15:05:48
    --@text:整个字符串
	--@pos:索引
	--@ch: 字符
    @return:
]]
function checkInteger(text, pos, ch)
    if tonumber(ch)>=48 and tonumber(ch)<=57 then return ch end
    if tonumber(ch)==45 and pos == 0 and string.find(text,'-')==nil then return ch end
    return '0'
end

--[[
    @desc: 检查是否为浮点数
    author:{author}
    time:2019-02-01 15:05:48
    --@text:整个字符串
	--@pos:索引
	--@ch: 字符
    @return:
]]
function checkFloat(text, pos, ch)
    if tonumber(ch)>=48 and tonumber(ch)<=57 then return ch end
    if tonumber(ch)==45 and pos == 0 and string.find(text,'-')==nil then return ch end
    if tonumber(ch)==46 and string.find(text,'%.')==nil then return ch end
    return '0'
end

--url编码
function urlEncode(s)
	s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
   return string.gsub(s, " ", "+")
end
--url解码
function urlDecode(s)
   s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
   return s
end
--四舍五入保留两位小数
function keepTwoDecimalPlaces(decimal)
    decimal = math.floor((decimal * 100)+0.5)*0.01       
    return  decimal
end

-- 查看某值是否为表tbl中的key值
function tableHasKey(tbl, key)
    if tbl == nil then
        return false
    end
    for k, v in pairs(tbl) do
        if k == key then
            return true
        end
    end
    return false
end
    
-- 查看某值是否为表tbl中的value值
function tableHasValue(tbl, value)
    if tbl == nil then
        return false
    end

    for k, v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

--获取随机数
function GetRandom(start_num,end_num)
    math.randomseed(os.time());
    return math.random(start_num, end_num);
end

function GetByteCount(str)
    local sTable = {}
    local len = 0
    local charLen = 0
    for utfChar in string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(sTable, utfChar)
    end
    for i=1,#sTable do
        local utfCharLen = string.len(sTable[i])
        if utfCharLen > 1 then
            charLen = 2  
        else
            charLen = 1
        end
        len = len + charLen
    end
    return len
end
--删除table中相同的元素
function DeleteEqualElement(tab)
    local exist = {}
    --把相同的元素覆盖掉
    for v, k in pairs(tab) do
        exist[k] = true
    end
    --重新排序表
    local newTable = {}
    for v, k in pairs(exist) do
        table.insert(newTable, v)
    end
    return newTable
end
--隐藏ID ,5位数后面的数字
function HideIDNumber(idnum)
    local id={}
    for word in string.gmatch(idnum, "%d") do
        table.insert(id,word)
    end
    for i = (#id>5 and 5 or 1), #id do
        id[i]='*'
    end
    local _id=''
    for i = 1, #id do
        _id=_id..id[i]
    end
    return _id
end
--通过指定的字符切割字符串，str被切割的字符串，reps切割的字符
function SplitString( str,reps )
    local resultStrList = {}
    string.gsub(str,'[^'..reps..']+',function ( w )
        table.insert(resultStrList,w)
    end)
    return resultStrList
end

function ByDissolutionTypeGetSpriteName(dissolutionType)
	print('dissolutionType : '..dissolutionType)
	local strName = 'nil'
	--0:此值无效  1000:群主解散  1001:管理员解散 1002:系统解散 1003:疲劳值不足解散 1004:托管解散 1005:申请解散 1006:牌局正常结束
	if dissolutionType == 1000 then
		strName = '查看个人群战绩-群主解散'
	elseif dissolutionType == 1001 then 
		strName = '查看个人群战绩-管理解散'
	elseif dissolutionType == 1003 or dissolutionType == 1007 then 
		strName = '查看个人群战绩-疲劳不足'
	elseif dissolutionType == 1004 or dissolutionType == 1008 or dissolutionType == 1009 or dissolutionType == 1010 or dissolutionType == 1012 then 
		strName = '查看个人群战绩-托管解散'
	elseif dissolutionType == 1005 then 
		strName = '查看个人群战绩-申请解散'
	elseif dissolutionType == 1011 then 
		strName = '查看个人群战绩-荒庄解散'
	end
	return strName
end

--判断unity对象是否是空值
function IsNil(uobj)
	return uobj == nil or uobj:Equals(nil)
end

--gps检测，如果没有开启定位或还没获得定位都返回失败
function GpsCheck(roomRule) 
	local longitude = UnityEngine.PlayerPrefs.GetFloat("longitude",0)
	local latitude = UnityEngine.PlayerPrefs.GetFloat("latitude",0)

	if CONST.IPcheckOn and roomRule.openGps and longitude == 0 and latitude == 0 then
		local status, err = pcall(function() PlatformManager.Instance:HasLocationPermissions() end)
		if status then
			if not PlatformManager.Instance:HasLocationPermissions() or not PlatformManager.Instance:GPSisOpen() then
				PanelManager.Instance:ShowWindow('panelSettingGPS')
				return false
			end
		else
			panelMessageBox.SetParamers(ONLY_OK, nil, nil, '该房间开启了GPS检测，请在手机“设置”中开启定位功能并允许游戏获取定位')
            PanelManager.Instance:ShowWindow('panelMessageBox')
			return false
		end
	end
	return true
end

--延迟连接的消息分发
function DelayMsgDispatch(connect, dealyTime)
	coroutine.start(
		function()
			if not IsNil(connect) and dealyTime > 0 then
				connect.IsZanTing=true
				coroutine.wait(dealyTime)
				connect.IsZanTing=false
			end
		end
	)
end

function GetServerIPorTag(isPorxy, gameServerHost)
	if Util.GetPlatformStr() ~= 'win' and ConfigManager.getBoolProperty('GameShield', 'IsUserShield', false) then
		return isPorxy and ConfigManager.getProperty('ProxyServer', 'ShieldTag', '') or ConfigManager.getProperty('gameServer', 'ShieldTag', '')
	else
		return isPorxy and ConfigManager.getProperty('ProxyServer', 'serverIP', '') or gameServerHost
	end
end

function QuickMatch(msg)
    local b = proxy_pb.RQuickMatch()
    b:ParseFromString(msg.body)
    if b.newCreate then
        roomInfo.host       = b.createRoom.host
        roomInfo.port       = b.createRoom.port
        roomInfo.token      = b.createRoom.token
        roomInfo.roomNumber = b.createRoom.roomNumber
        roomInfo.gameType   = b.createRoom.gameType
        roomInfo.roomType   = b.createRoom.roomType
    else
        roomInfo.host       = b.enterRoom.host
        roomInfo.port       = b.enterRoom.port
        roomInfo.token      = b.enterRoom.token
        roomInfo.gameType   = b.enterRoom.gameType
        roomInfo.roomType   = b.enterRoom.roomType
        roomInfo.roomNumber = b.enterRoom.roomNumber
    end
    
    if roomInfo.gameType==proxy_pb.PHZ then
        PanelManager.Instance:ShowWindow('panelInGameLand',"name")
    elseif roomInfo.gameType==proxy_pb.PDK then
        PanelManager.Instance:ShowWindow('panelInGame_pdk',"name")
    elseif roomInfo.gameType == proxy_pb.MJ then
        PanelManager.Instance:ShowWindow('panelInGamemj',"name")
    elseif roomInfo.gameType == proxy_pb.XHZD then
        PanelManager.Instance:ShowWindow('panelInGame_xhzd',"name")
    elseif roomInfo.gameType == proxy_pb.DTZ then
        PanelManager.Instance:ShowWindow('panelInGame_dtz', "name")
    elseif roomInfo.gameType == proxy_pb.BBTZ then
        PanelManager.Instance:ShowWindow('panelInGame_bbtz', "name")
    elseif roomInfo.gameType == proxy_pb.XPLP then
        PanelManager.Instance:ShowWindow('panelInGame_xplp', "name")
    elseif roomInfo.gameType == proxy_pb.HNM and roomInfo.roomType == proxy_pb.HNHSM then
        PanelManager.Instance:ShowWindow('panelInGame_hnhsm', "name")
    elseif roomInfo.gameType == proxy_pb.HNM and roomInfo.roomType == proxy_pb.HNZZM then
        PanelManager.Instance:ShowWindow('panelInGame_hnzzm', "name")
    elseif roomInfo.gameType == proxy_pb.YJQF  then 
        PanelManager.Instance:ShowWindow('panelInGame_yjqf', 'name')
    elseif roomInfo.gameType == proxy_pb.HSTH  then 
        PanelManager.Instance:ShowWindow('panelInGame_hsth', 'name')
    end
end

local curr_value
--num限制只能输入小数点后多少位
function LimitInputFloat(inputObj,num)
    if inputObj.value ~= '' then
        if string.find(inputObj.value,'%p',1) then
            local aaa,bbb,ccc,ddd = string.find(inputObj.value,"(%d+).(%d+)", 1)
            if ddd~=nil and #ddd > num then
                inputObj.value = curr_value
                return 
            end
        end
        curr_value = inputObj.value
    end
end