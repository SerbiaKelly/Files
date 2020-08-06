local json = require 'json'
require "Game.panelMessageBox"
require "Game.Tools.UITools"

panelClub = {}
local this = panelClub;

this.playInfo = {}--当前玩法所有信息
this.clubList = {}--牌友群列表信息
this.clubInfo = {}--当前牌友群信息
this.ruleInfo = {}--当前规则
this.isInClub=false--判断是不是在牌友群
local rule = {}--当前玩法table

local SYZP = 0	--邵阳字牌
local SYBP = 1	--邵阳剥皮
local HUAIHUA = 2 --怀化红拐弯
local LDFPF = 6 --娄底放炮罚
local CDPHZ = 7 --常德跑胡子
local CSPHZ = 9 --长沙跑胡子

local message;
local gameObject;

local DeskItemPrefab
local DesksCollection
local DesksCollectionGrid

local clubName
local manageDiamond
local clubID
local moneyNum

local buttonMessage--信息
local buttonHelp--帮助
local buttonSetting--设置
local buttonGroupCard --群名片
local ClubListView--牌友群列表
local buttonClubListMask--牌友群列表mask按钮
local buttonRecord--战绩
local buttonSecret--私密开房
local buttonPublic--公共开房
local buttonQuick--快速开房
local buttonMember--成员列表
local buttonRefresh--刷新
local buttonJiLu--查看房间记录
local buttonClose--退出club
local buttonRank--排行榜
local buttonClub--牌友群列表按钮
local buttonGuiZe--规则
local buttonPlaySetting--玩法设置按钮
local buttonMore--更多
local buttonSecletRule
local moreButtonView--更多button的界面
local playsToggles = {}--5个玩法的toggle
local buttonGongGaoOrWanFa--切换显示玩法或者公告
local CreateClub --创建牌友群
local clubLeaderIcon;
local clubLeaderName;
local clubLeaderID;

local daoJiShi = 600

local Grid
local prefabItem
local JoinButton

local marqueeLabel--公告

this.NoticeContent = ""

local maxPlayNum = 41--玩法最大数目
local maxTableNum = 50--桌子最大数目
local maxPlayerNum = 3--玩家最大数目

local myFeeLabel

local wenben = {}
local tableShuaXinTime = {}
local marqueeList = proxy_pb.RMarqueeList() --公告列表
local NotcieGunDongXC
local copyPlays = {}
local playSettingGuide
local playSettingGuideSetting

function this.Awake(obj)
    gameObject      = obj;
    this.gameObject = obj;
    message         = gameObject:GetComponent('LuaBehaviour')
    for i = 1, maxPlayNum do
        playsToggles[i]             = {}
        if i == 1 then
            playsToggles[i].transform = gameObject.transform:Find('WanFaToggle/ALL')
        else
            playsToggles[i].transform   = NGUITools.AddChild(gameObject.transform:Find('WanFaToggle/Scroll View/Grid').gameObject, gameObject.transform:Find('itemToggle').gameObject).transform
            playsToggles[i].transform.gameObject.name = i
            playsToggles[i].transform.gameObject:SetActive(false)
        end
        playsToggles[i].none        = playsToggles[i].transform:Find('none');
        playsToggles[i].Label1      = playsToggles[i].transform:Find('highlight/Label1');
        playsToggles[i].Label2      = playsToggles[i].transform:Find('back/Label1');
        message:AddClick(playsToggles[i].transform.gameObject, this.OnClickPlayButton);
    end
    for i = 1, maxPlayNum do
        playsToggles[i].Label1:GetComponent('UILabel').spacingY = 0
        playsToggles[i].Label2:GetComponent('UILabel').spacingY = 0
        playsToggles[i].Label1.localPosition = Vector3.zero
        playsToggles[i].Label2.localPosition = Vector3.zero
    end
    Grid                    = gameObject.transform:Find('clubList/panel/Scroll View/Grid');
    prefabItem              = gameObject.transform:Find('clubList/panel/Item');
    JoinButton              = gameObject.transform:Find('clubList/panel/join');
    --buttonGongGaoOrWanFa    = gameObject.transform:Find('top/gongGaoOrWanFa');
    clubID                  = gameObject.transform:Find('top/gropLeader/clubIdNum/leaderId');
    clubName                = gameObject.transform:Find('top/clubHeadbg/clubName');
	manageDiamond			= gameObject.transform:Find('top/clubHeadbg/manageDiamond');
    moneyNum                = gameObject.transform:Find('top/money/num');
    buttonHelp              = gameObject.transform:Find('top/di/panel/buttonHelp');
    buttonClose             = gameObject.transform:Find('top/di/buttonClose');
    buttonRank             = gameObject.transform:Find('top/di/buttonRank');
    buttonPlaySetting       = gameObject.transform:Find('WanFaToggle/Setting');
    buttonSetting           = gameObject.transform:Find('buttom/buttonSetting');
    buttonGroupCard         = gameObject.transform:Find('buttom/groupAssum');
    buttonRefresh           = gameObject.transform:Find('top/di/buttonRefresh')
    buttonGuiZe             = gameObject.transform:Find('clubList/panel/guize');
    buttonMessage           = gameObject.transform:Find('buttom/buttonMessage');
    buttonClubListMask      = gameObject.transform:Find('clubList/panel/Sprite');
    ClubListView            = gameObject.transform:Find('clubList');--牌友群列表
    buttonRecord            = gameObject.transform:Find('buttom/buttonCardRecord');
    CreateClub              = gameObject.transform:Find('clubList/panel/CreateClub')
    buttonSecret            = gameObject.transform:Find('buttom/buttonSecret');
    buttonPublic            = gameObject.transform:Find('buttom/buttonPublic');
    buttonQuick             = gameObject.transform:Find('buttom/buttonQuick');
    buttonMember            = gameObject.transform:Find('buttom/buttonMember')
    buttonJiLu              = gameObject.transform:Find('buttom/buttonRecord')
    buttonClub              = gameObject.transform:Find('top/buttonClub')
    buttonSecletRule        = gameObject.transform:Find('buttom/buttonSecletRule')
    marqueeLabel            = gameObject.transform:Find('top/Notcie/gongGao');
    buttonMore              = gameObject.transform:Find('top/buttonMore');
    clubLeaderIcon          = gameObject.transform:Find('top/gropLeader/headimage/Texture');
    clubLeaderName          = gameObject.transform:Find('top/gropLeader/leaderName');

    myFeeLabel = gameObject.transform:Find('myFee')
   
    playSettingGuide = gameObject.transform:Find('playSettingGuide');
    playSettingGuideSetting = gameObject.transform:Find('playSettingGuide/pos/Setting');

    message:AddClick(gameObject.transform:Find('playSettingGuide/ButtonKnow').gameObject, function (go)
        AudioManager.Instance:PlayAudio('btn')
        playSettingGuide.gameObject:SetActive(false)
        UnityEngine.PlayerPrefs.SetInt('playSettingGuide', 1)
    end)

    DesksCollection = gameObject.transform:Find('Desks')
    DeskItemPrefab = gameObject.transform:Find('Prefabs/table');
    DesksCollectionGrid = DesksCollection.transform:Find('GridWrapper'):GetComponent('SuperScrollListWrapper')
    DesksCollectionGrid:SetRefreshCallback(this.RefreshDeskItem)
    DesksCollectionGrid.onItemInstance = this.OnDeskItemInstance
    DesksCollectionGrid:SpawnNewList(DeskItemPrefab.gameObject, 0, 0)
    DesksCollectionGrid.transform.parent:GetComponent('UIScrollView'):ResetPosition()

    --message:AddClick(buttonGongGaoOrWanFa.gameObject, this.OnClickGongGaoOrWanFa);
    message:AddClick(JoinButton.gameObject, this.OnClickButtonJoin);
    message:AddClick(buttonRefresh.gameObject, this.OnClickButtonRefresh);
    message:AddClick(buttonClub.gameObject, this.OnClickClubList);
    message:AddClick(buttonJiLu.gameObject, this.OnClickButtonJiLu);
    message:AddClick(buttonSecret.gameObject, this.OnClickButtonSecret);
    message:AddClick(buttonPublic.gameObject, this.OnClickButtonPublic);
    message:AddClick(buttonQuick.gameObject, this.OnClickButtonQuick);
    -- message:AddClick(moreButtonView.gameObject, this.OnClickButtonMore);

    -- message:AddClick(buttonGuiZe.gameObject, this.OnClickGuiZe);
    message:AddClick(buttonMessage.gameObject, this.OnClickButtonMessage);
    -- message:AddClick(buttonHelp.gameObject, this.OnClickButtonHelp);
    message:AddClick(buttonSetting.gameObject, this.OnClickButtonSetting);
    message:AddClick(buttonGroupCard.gameObject, this.OnClickGroupCard);
    message:AddClick(buttonPlaySetting.gameObject, this.OnClickButtonPlaySetting);
    message:AddClick(buttonMember.gameObject, this.OnClickButtonMember);
    message:AddClick(buttonClose.gameObject, this.OnClickButtonClose);
    message:AddClick(buttonRank.gameObject, this.OnClickButtonRank);
    message:AddClick(buttonClubListMask.gameObject, this.OnClickClubList);
    message:AddClick(CreateClub.gameObject, this.OnCreateClub)
    message:AddClick(buttonSecletRule.gameObject, function (go)
        AudioManager.Instance:PlayAudio('btn')
        local data = {}
        data.needSelcted = true
        PanelManager.Instance:ShowWindow('panelSelctRule', data)
    end)
    message:AddClick(clubName.gameObject, function (go)
        AudioManager.Instance:PlayAudio('btn')
        PanelManager.Instance:ShowWindow('panelClubInfo')
    end)

    message:AddClick(buttonRecord.gameObject, this.OnClickButtonRecord);
    --message:AddClick(buttonShare.gameObject, this.OnClickButtonShare);
    if IsAppleReview() then
        --gameObject.transform:Find('top/money').gameObject:SetActive(false)
        --buttonShare.gameObject:SetActive(false)
    end

    if isShapedScreen  then
        -- local widget = gameObject.transform:Find('top'):GetComponent('UIWidget')
        -- widget.leftAnchor.absolute = ipxLiuHai
        -- widget.rightAnchor.absolute = -ipxLiuHai
        -- gameObject.transform:Find('clubList').transform.localPosition = Vector3(-ipxLiuHai,0,0)
        -- widget = gameObject.transform:Find('buttom'):GetComponent('UIWidget')
        -- widget.leftAnchor.absolute = ipxLiuHai
        -- local widget = gameObject.transform:Find('middle'):GetComponent('UIPanel')
        -- widget.leftAnchor.absolute = ipxLiuHai
        -- widget.rightAnchor.absolute = -ipxLiuHai
        --local pos = tableObj.transform.localPosition
        --tableObj.transform.localPosition = pos + Vector3(60, 0, 0)
    end

end

--创建牌友群
function this.OnCreateClub(go)
    PanelManager.Instance:ShowWindow('panelClubHome',gameObject.name)   
    ClubListView.gameObject:SetActive(false)
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickGongGaoOrWanFa(go)
    AudioManager.Instance:PlayAudio('btn')

end

function this.MarqueeListRes(msg)
    local b = proxy_pb.RMarqueeList()
    b:ParseFromString(msg.body)
    marqueeList = b
end

local IsRoll = false
-- --请求公告
-- function this.GetNotice()
--     local msg = Message.New()
-- 	msg.type = proxy_pb.CLUB_NOTICE;
-- 	local body=proxy_pb.PClubNotice()
-- 	body.clubId=panelClub.clubInfo.clubId
--     msg.body = body:SerializeToString()
--     IsRoll = false
-- 	SendProxyMessage(msg, this.OnGetNotice);
-- end
local noticeIsRoll=false
function this.OnGetNotice(msg)
	-- local b = proxy_pb.RClubNotice();
    -- b:ParseFromString(msg.body);
    -- this.NoticeContent = b.content;
    local label = marqueeLabel:GetComponent('UILabel');
    label.text = "";
    if this.NoticeContent == "" then
        marqueeLabel:GetComponent('UILabel').text = "请大家严格遵守我国法律法规，遵守社会公德，严禁利用本游戏进行赌博犯罪活动";
        -- return 
    else
        label.text = this.NoticeContent;
    end
    
    local marqueeBGWidth = gameObject.transform:Find('top/Notcie'):GetComponent('UIPanel').width;
    IsRoll = false
    if label.width > marqueeBGWidth then
        IsRoll = true
    end
    noticeIsRoll=false
    if NotcieGunDongXC then
        StopCoroutine(NotcieGunDongXC)
    end
    NotcieGunDongXC = nil
    NotcieGunDongXC = StartCoroutine(this.UpdateMarquee)
end

function this.UpdateMarquee()
    local marqueeBGWidth = gameObject.transform:Find('top/Notcie'):GetComponent('UIPanel').width;
    local noticeParent =  gameObject.transform:Find('top/Notcie');
    local label = marqueeLabel:GetComponent('UILabel')
    if IsRoll then
        noticeIsRoll=true
        while true do

            if not gameObject.activeSelf or not IsRoll or noticeIsRoll==false then
                noticeIsRoll=false
                break
            end

            local curPos = label.transform.localPosition;
            label.transform.localPosition = curPos - Vector3(1,0,0);
            curPos = label.transform.localPosition;
            if (label.width + marqueeBGWidth)/2 <= noticeParent.localPosition.x - label.transform.localPosition.x then
                label.transform.localPosition = Vector3(noticeParent.localPosition.x+(label.width+marqueeBGWidth)/2, 0, 0);
            end
            WaitForEndOfFrame()
        end
    else
        local noticFramePanel = gameObject.transform:Find('top/Notcie'):GetComponent('UIPanel');
        marqueeLabel.localPosition = Vector3(0,0,0);
    end
end

--是不是新创建的群
local isNewCreateClub = false
function this.WhoShow(data)
    isNewCreateClub = false
    PanelManager.Instance:ShowWindow('panelNetWaitting')
    if data.name == 'panelLobby' then
        local mdata = data.data
        if this.checkIsInRoom(mdata)==true then
            return
        end
        this.setClubInfoData(mdata.clubInfo)
        this.clubInfo.memberSize            = mdata.memberSize
        this.clubInfo.hasMessage            = mdata.hasMessage
        this.clubInfo.realMsg               = mdata.realMsg
        this.clubInfo.userType              = mdata.userType
        this.clubInfo.createTime            = mdata.time
        this.clubInfo.playId                = '-'..this.clubInfo.clubId--mdata.lastPlayId
        this.clubInfo.gameType              = mdata.lastGameType;
        this.clubInfo.privilege             = mdata.privilege
        this.clubInfo.refusedMsgs           = mdata.refusedMsgs
        this.NoticeContent                  = mdata.noticeContent
        this.clubInfo.displayCurrentPlay    = mdata.displayCurrentPlay
        this.clubInfo.displayAllPlay        = mdata.displayAllPlay
        this.clubInfo.itemPlayId            = mdata.itemPlayId
        this.clubInfo.scoreMsgs             = mdata.scoreMsgs
		this.clubInfo.lossFee               = mdata.lossFee
		this.clubInfo.lordBalance           = mdata.lordBalance
		print(' data.lossFee : '..mdata.lossFee..' lordBalance : '..tostring(mdata.lordBalance))
        if this.clubInfo.gameMode then
            myFeeLabel.gameObject:SetActive(true)
            myFeeLabel:GetComponent('UILabel').text=mdata.feeBalance
        else
            myFeeLabel.gameObject:SetActive(false)
        end
        --this.InsertAllDeductMessages(mdata.scoreMsgs)
        local msg                   = Message.New()
        msg.type                    = proxy_pb.MARQUEE_LIST
        SendProxyMessage(msg, this.MarqueeListRes)
        -- this.clubList.clubs         = mdata.clubs
        this.refresh(true)
    elseif data.name == 'panelClubHome' then
        this.shuaXinClub()
        isNewCreateClub = data.clubId ~= nil
        print(isNewCreateClub)
        print(data.clubId)
    else
        this.shuaXinClub()
        if panelMenber then
            panelMenber.onGetResult()
        end
    end

    if panelInGame and (data.name == 'panelInGameLand' or data.name == 'panelInGame_pdk' or data.name == 'panelInGamemj' or data.name == 'panelInGame_xhzd') then
        if panelInGame.gameObject.transform:GetComponent('UIPanel').alpha ~=0  then
            PanelManager.Instance:HideWindow(data.name)
        end
    elseif data.name~='moChuang' then
        PanelManager.Instance:HideWindow(data.name)
    end

    AudioManager.Instance:PlayMusic('MainBG', true)

    if panelInGame and panelInGame.fanHuiRoomNumber then
        panelInGame.OnRoundStarted = function ()
            panelMessageBox.SetParamers(ONLY_OK, this.OnClickButtonQuick, nil, '您加入的房间已开始游戏，请立刻进入房间', '返回房间')
            PanelManager.Instance:ShowWindow('panelMessageBox')
        end
        buttonQuick.transform:Find('textLabel'):GetComponent('UILabel').text = '返回房间'
    else
        buttonQuick.transform:Find('textLabel'):GetComponent('UILabel').text = '快速开始'
    end

    this.HideReplayWindows();
end
-- function this.OnClickGuiZe(go)
--     AudioManager.Instance:PlayAudio('btn')
--     PanelManager.Instance:ShowWindow('panelGuiZe')
-- end
function this.OnClickButtonJoin(go)
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:ShowWindow('panelClubApply')
end

local deskList={}--桌子实例的表  key是桌子的gameObject
local clubListMap={}--牌友群列表对象表 key是子项的gameObject
--[[    @desc: 刷新牌友群列表显示
    author:{author}
    time:2018-09-09 17:13:30
    @return:
]]
function this.clubListRefresh()
    if this.clubList ~= nil then
        for i=0,Grid.transform.childCount -1  do
            local obj = Grid.transform:GetChild(i)
            obj.gameObject:SetActive(false)
            SetUserData(obj.gameObject, nil);
            -- UnityEngine.Object.Destroy(obj.gameObject)
        end

        for i = 1, #this.clubList.clubs do
            local userGO = {}
            local clubItem
            if Grid.transform.childCount < i then 
                userGO.GO                       = NGUITools.AddChild(Grid.gameObject, prefabItem.gameObject);
                clubListMap[userGO.GO]          =   {}
                clubItem                        =   clubListMap[userGO.GO]
                clubItem.groupName              =   userGO.GO.transform:Find('groupName'):GetComponent('UILabel')
                clubItem.groupIDNum             =   userGO.GO.transform:Find('groupID/groupIDNum'):GetComponent('UILabel')
                clubItem.groupLevel             =   userGO.GO.transform:Find('groupName/groupLevel'):GetComponent('UILabel')
                clubItem.nickName               =   userGO.GO.transform:Find('groupLeaderName/nickName'):GetComponent('UILabel')
                clubItem.leaderIcon             =   userGO.GO.transform:Find('groupName/leaderIcon'):GetComponent('UITexture')
                clubItem.roomStateGroupIDNum    =   userGO.GO.transform:Find('roomState/groupIDNum'):GetComponent('UILabel')
                clubItem.onlineNum              =   userGO.GO.transform:Find('onlineMemeber/onlineNum'):GetComponent('UILabel')
                clubItem.totalNum               =   userGO.GO.transform:Find('onlineMemeber/totalNum'):GetComponent('UILabel')
                clubItem.selected               =   userGO.GO.transform:Find('selected')
                clubItem.MyFlag                 =   userGO.GO.transform:Find('MyFlag')

            
            else
                userGO.GO = Grid.transform:GetChild(i-1).gameObject;
            end
            clubItem                            =clubListMap[userGO.GO]
            --userGO.GO.transform.position = Vector3(0,-i,0)
            SetUserData(userGO.GO, this.clubList.clubs[i]);
            clubItem.groupName.text             = this.clubList.clubs[i].name;
            clubItem.groupIDNum.text            = this.clubList.clubs[i].clubId;
            clubItem.groupLevel.text            = "NO."..string.format("%02d",i);
            clubItem.nickName.text              = this.clubList.clubs[i].nickname;
            coroutine.start(LoadPlayerIcon, clubItem.leaderIcon, this.clubList.clubs[i].icon);

            local deskCount     = this.clubList.clubs[i].deskCount;
            local onlineCount   = this.clubList.clubs[i].onlineUser;
            local totalCount    = this.clubList.clubs[i].totalUser;

            local isHide        = false
            if not this.clubList.clubs[i].self or bit:_and(this.clubList.clubs[i].privilege, 1) == 1 then
                isHide          = true
            end

            --已开房
            clubItem.roomStateGroupIDNum.text = (isHide and this.clubList.clubs[i].deskCount > 20) and '20+' or  this.clubList.clubs[i].deskCount;
            --在线状态
            clubItem.onlineNum.text = (isHide and this.clubList.clubs[i].onlineUser > 50) and '50+' or this.clubList.clubs[i].onlineUser;
            clubItem.totalNum.text = (isHide and this.clubList.clubs[i].totalUser > 99) and '99+' or this.clubList.clubs[i].totalUser;

            --设置被选中状态
            clubItem.selected.gameObject:SetActive(this.clubList.clubs[i].choiced );
            clubItem.MyFlag.gameObject:SetActive(this.clubList.clubs[i].self);

           

            userGO.GO:SetActive(true);
            if userGO.GO.transform:GetComponent('UIEventListener') == nil then 
                message:AddClick(userGO.GO, this.OnClickButtonEnterClub);
            end
        end
        Grid:GetComponent('UIGrid'):Reposition();
        if this.ScrollViewActiveCount(Grid) < 3 then
            Grid.parent:GetComponent('UIScrollView'):ResetPosition()
        end
    end
end

--返回俱乐部中激活的child个数，这里设计时3个
function this.ScrollViewActiveCount(scrollView)
    local count = 0;
    for i = 1, scrollView.transform.childCount do
        if scrollView.transform:GetChild(i-1).gameObject.activeSelf then
            count = count +1
        end
    end
    return count;
end

local clubItemObj = nil;
function this.OnClickButtonEnterClub(go)
    AudioManager.Instance:PlayAudio('btn')
    
    if panelClub.clubInfo.clubId == GetUserData(go).clubId then
        return
    end

    PanelManager.Instance:ShowWindow('panelNetWaitting')
    --设置被选中状态
    for i=0,Grid.childCount -1  do
        Grid:GetChild(i):Find('selected').gameObject:SetActive(false);
    end
    go.transform:Find('selected').gameObject:SetActive(true);
    this.clubInfo.playId=nil
    this.shuaXinClub(GetUserData(go).clubId,nil,true);

     --刷新玩法的grid
     local wanfaGrid = gameObject.transform:Find('WanFaToggle/Scroll View');
     wanfaGrid.transform:GetComponent('UIScrollView'):ResetPosition()
end

function this.OnClickButtonRefresh(go)
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:ShowWindow('panelNetWaitting')
    this.shuaXinClub()
end
function this.OnClickButtonClose(go)
    AudioManager.Instance:PlayAudio('btn')
    local msg = Message.New()
    msg.type = proxy_pb.LEAVE_CLUB
    local body = proxy_pb.PLeaveClub();
    body.clubId = this.clubInfo.clubId
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, nil)
    PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
end
function this.Start()
    RegisterProxyCallBack(proxy_pb.ROOM_ROUND_START, this.onRoundRefresh)
    RegisterProxyCallBack(proxy_pb.CLUB_INFO, this.refreshClubBaseInfo);
    RegisterProxyCallBack(proxy_pb.ENTER_CLUB_PLAY, this.OnEnterClubPlayResult);
    RegisterProxyCallBack(proxy_pb.DEDUCT_SCORE_MESSAGE, this.OnDeductFeeNotice)
    RegisterProxyCallBack(proxy_pb.DEDUCT_SCORE_REFUSED_MESSAGE, this.OnDeductScoreRefusedMessage)
    RegisterProxyCallBack(proxy_pb.REAL_MESSAGE_COUNT, this.OnRealMessageCount)
end
function this.OnRealMessageCount(msg)
    local b = proxy_pb.RRealMessageCount()
    b:ParseFromString(msg.body)
    if b.clubId ~= nil then
        print('b.count : '..tostring(b.count)..'  b.clubId : '..tostring(b.clubId))
        this.clubInfo.realMsg = b
        local count=b.remindCount+b.alertCount
        buttonMessage:Find('dian').gameObject:SetActive(count ~= 0)
        buttonMessage:Find('dian/num'):GetComponent('UILabel').text = count ~= 0 and (count>99 and '99' or count) or ''
    end
end

--刷新牌友群基本信息
function this.refreshClubBaseInfo(msg)
    local b = proxy_pb.RClubInfo();
    b:ParseFromString(msg.body);
    this.setClubInfoData(b)
    this.setClubInfoView()
end
--获取玩家所持有的牌友群列表
function this.getClubList()
    local msg = Message.New()
    msg.type = proxy_pb.CLUB_LIST
    SendProxyMessage(msg, this.refreshClubList)
end
--刷新玩家所持有的牌友群列表
function this.refreshClubList(msg)
    local b = proxy_pb.RClubList();
    b:ParseFromString(msg.body);
    this.clubList.clubs = b.clubs
    this.clubListRefresh()
end
--刷新牌友群
function this.refreshClub(msg)
    print("refreshClub was called---------------------->");
    local b = proxy_pb.RRefresh();
    b:ParseFromString(msg.body);
    if b.operation == proxy_pb.REFRESH_USERS then
        if PanelManager.Instance:IsActive('panelMenber') then
            panelMenber.RefreshMenber()
        end
    elseif b.operation == proxy_pb.PASS_JOIN then
        if PanelManager.Instance:IsActive(gameObject.name)==true then
            this.shuaXinClub(nil, false)
        end
    elseif b.operation == proxy_pb.QUIT_CLUB then
        if this.clubInfo.clubCount==1 then
            PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
            PanelManager.Instance:HideWindow("panelClubManage")
        else
            this.shuaXinClub();   
        end
        panelMessageTip.SetParamers('退出牌友群成功', 1.5)
        PanelManager.Instance:ShowWindow('panelMessageTip')
    elseif b.operation == proxy_pb.BE_DELETE then
        if this.clubInfo.clubCount==1 then
            PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
            PanelManager.Instance:HideWindow('panelMenber')
            PanelManager.Instance:HideWindow("panelClubManage")
        else
            this.shuaXinClub();    
        end
	elseif b.operation == proxy_pb.REENTER_CLUB then
		if PanelManager.Instance:IsActive(gameObject.name)==true then
            this.shuaXinClub();
        end
    elseif b.operation == proxy_pb.APPLYING then
        if panelClub.clubInfo.userType==proxy_pb.LORD or panelClub.clubInfo.userType==proxy_pb.MANAGER then
            buttonMember:Find('dian').gameObject:SetActive(true)
        end
    end
end


function this.Update()
end
function this.OnEnable()
    isIngame = false
    this.isInClub=true
    RegisterProxyCallBack(proxy_pb.REFRESH, this.refreshClub);
    playSettingGuide.gameObject:SetActive(false)
end

function this.shuaXinClub(clubId, isNeedRefreshPlay, needRefreshClubList)
    print("shuaXinClub------------------------>");
    local msg = Message.New()
    msg.type = proxy_pb.ENTER_CLUB
    local body = proxy_pb.PEnterClub();
    if clubId ~= nil then
        body.clubId = clubId
    end
    msg.body = body:SerializeToString()

    SendProxyMessage(msg, function (msg)
        local data = proxy_pb.REnterClub();
        data:ParseFromString(msg.body);
        if this.checkIsInRoom(data)==true then
            return
        end
        this.NoticeContent          = data.noticeContent
        this.setClubInfoData(data.clubInfo)--牌友群基本信息赋值
        this.clubInfo.memberSize    = data.memberSize
        this.clubInfo.hasMessage    = data.hasMessage
        this.clubInfo.realMsg       = data.realMsg
        this.clubInfo.userType      = data.userType
        this.clubInfo.createTime    = data.time
        this.clubInfo.gameType      = data.lastGameType;
        this.clubInfo.displayCurrentPlay = data.displayCurrentPlay
        this.clubInfo.displayAllPlay = data.displayAllPlay
        this.clubInfo.itemPlayId = data.itemPlayId
		this.clubInfo.lossFee               = data.lossFee
		this.clubInfo.lordBalance = data.lordBalance
		print(' lossFee : '..data.lossFee..' lordBalance : '..tostring(data.lordBalance))
        if this.clubInfo.playId==nil then
            this.clubInfo.playId    = '-'..this.clubInfo.clubId--mdata.lastPlayId
        end
        this.clubInfo.scoreMsgs = data.scoreMsgs
        this.clubInfo.privilege     = data.privilege 
        this.clubInfo.refusedMsgs   = data.refusedMsgs
        this.clubInfo.clubCount     = data.clubCount
        if this.clubInfo.clubCount==0 then
            PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
            panelLogin.HideNetWaitting()
            panelMessageTip.SetParamers('您没有加入或创建过任何牌友群', 1)
            PanelManager.Instance:ShowWindow('panelMessageTip')
            return
        end
        if this.clubInfo.gameMode then
            myFeeLabel.gameObject:SetActive(true)
            myFeeLabel:GetComponent('UILabel').text=data.feeBalance
        else
            myFeeLabel.gameObject:SetActive(false)
        end

        if needRefreshClubList then
            this.getClubList()
        end

        local msg = Message.New();
        msg.type = proxy_pb.MARQUEE_LIST;
        SendProxyMessage(msg, this.MarqueeListRes);

        local needRefreshPlay = true
        if isNeedRefreshPlay ~= nil then
            needRefreshPlay = isNeedRefreshPlay
        end
        this.refresh(needRefreshPlay);
    end)
end
function this.checkIsInRoom(data)
    if data.queryRoom.existed then
        roomInfo.host = data.queryRoom.host
        roomInfo.port = data.queryRoom.port
        roomInfo.token = data.queryRoom.token
        roomInfo.gameType = data.queryRoom.gameType
        roomInfo.roomNumber = data.queryRoom.roomNumber
        
        if(panelInGame and not panelInGame.fanHuiRoomNumber) then
            if data.queryRoom.gameType == proxy_pb.PDK then
                PanelManager.Instance:ShowWindow('panelInGame_pdk',gameObject.name)
            elseif data.queryRoom.gameType == proxy_pb.PHZ then
                PanelManager.Instance:ShowWindow('panelInGameLand',gameObject.name)
            elseif data.queryRoom.gameType == proxy_pb.MJ then
                PanelManager.Instance:ShowWindow('panelInGamemj',gameObject.name)
            elseif data.queryRoom.gameType == proxy_pb.XHZD then
                PanelManager.Instance:ShowWindow('panelInGame_xhzd',gameObject.name)
            elseif data.queryRoom.gameType == proxy_pb.DTZ then
                PanelManager.Instance:ShowWindow('panelInGame_dtz',gameObject.name)
            elseif data.queryRoom.gameType == proxy_pb.BBTZ then
                PanelManager.Instance:ShowWindow('panelInGame_bbtz',gameObject.name)
            elseif data.queryRoom.gameType == proxy_pb.XPLP then 
                PanelManager.Instance:ShowWindow('panelInGame_xplp',gameObject.name)
            elseif data.queryRoom.gameType == proxy_pb.HNM and data.queryRoom.roomType == proxy_pb.HNHSM then 
                PanelManager.Instance:ShowWindow('panelInGame_hnhsm',gameObject.name)
            elseif data.queryRoom.gameType == proxy_pb.HNM and data.queryRoom.roomType == proxy_pb.HNZZM then 
                PanelManager.Instance:ShowWindow('panelInGame_hnzzm',gameObject.name)
		    elseif data.queryRoom.gameType == proxy_pb.YJQF then
                PanelManager.Instance:ShowWindow('panelInGame_yjqf',gameObject.name)
            elseif data.queryRoom.gameType == proxy_pb.HSTH then
                PanelManager.Instance:ShowWindow('panelInGame_hsth',gameObject.name)
            end
            return true
        end
    end
    return false
end
--设置牌友群基本信息数据
function this.setClubInfoData(data)
    this.clubInfo.clubId                = data.clubId
    this.clubInfo.name                  = data.name;
    this.clubInfo.lordId                = data.lordId;
    this.clubInfo.lordNickname          = data.nickname;
    this.clubInfo.clubLeaderIcon        = data.icon
    this.clubInfo.pauseRoom             = data.pauseRoom;
    this.clubInfo.pauseInfo             = data.pauseInfo;
    this.clubInfo.dissolveType          = data.dissolveType
    this.clubInfo.waitTime              = data.waitTime
    this.clubInfo.autoReady             = data.autoReady
    this.clubInfo.privateRoom           = data.privateRoom
    this.clubInfo.publicRoom            = data.publicRoom
    this.clubInfo.autoBlackHouse        = data.autoBlackHouse
    this.clubInfo.blackHouseValue       = data.blackHouseValue
    this.clubInfo.gameMode              = data.gameMode
    this.clubInfo.lobby                 = data.lobby
    this.clubInfo.quitAllowed           = data.quitAllowed
    this.clubInfo.sendMsgAllowed        = data.sendMsgAllowed
    this.clubInfo.sendVoiceAllowed      = data.sendVoiceAllowed
    this.clubInfo.phzAutoDissolve       = data.phzAutoDissolve
    print("enter club data.desks:"..tostring(data.desks))
    this.clubInfo.deskNum               = data.desks
    this.clubInfo.dissolveLimit         = data.dissolveLimit
    this.clubInfo.autoDissolveTime      = data.autoDissolveTime
    this.clubInfo.lossWin               = data.lossWin
	this.clubInfo.lossWinFee            = data.lossWinFee
    this.clubInfo.timesAllowed          = (bit:_and(data.privilegeRankList, 1)==1)
    this.clubInfo.validTimesAllowed     = (bit:_and(data.privilegeRankList, 2)==2)
    this.clubInfo.bigTimesAllowed       = (bit:_and(data.privilegeRankList, 4)==4)
    this.clubInfo.feeAllowed            = (bit:_and(data.privilegeRankList, 8)==8)
    this.clubInfo.butlerAllowed         = (bit:_and(data.privilegeRankList, 16)==16)
    this.clubInfo.myButlerAllowed       = (bit:_and(data.privilegeRankList, 32)==32)
    this.clubInfo.myUserAllowed         = (bit:_and(data.privilegeRankList, 64)==64)
    this.clubInfo.managerAllowed        = (bit:_and(data.privilegeRankList, 128)==128)
	print('timesAllowed : '..tostring(bit:_and(data.privilegeRankList, 1)==1)..' validTimesAllowed : '..tostring(bit:_and(data.privilegeRankList, 2)==2)..' bigTimesAllowed : '..tostring(bit:_and(data.privilegeRankList, 4)==4)..' feeAllowed : '..tostring(bit:_and(data.privilegeRankList, 8)==8)..' managerAllowed : '..tostring(bit:_and(data.privilegeRankList, 128)==128)..' butlerAllowed : '..tostring(bit:_and(data.privilegeRankList, 16)==16)..' myButlerAllowed : '..tostring(bit:_and(data.privilegeRankList, 32)==32)..' myUserAllowed : '..tostring(bit:_and(data.privilegeRankList, 64)==64))
    this.clubInfo.allowMinus            = data.allowMinus
    print('allowMinus : '..tostring(this.clubInfo.allowMinus)..' data.lossWin : '..data.lossWin..' data.lossWinFee : '..data.lossWinFee)
	this.clubInfo.deskDirect            = data.deskDirect
	this.clubInfo.showBigWin            = data.showBigWin
	this.clubInfo.showLordBalance       = data.showLordBalance
    this.clubInfo.applyClub             = data.applyClub
    this.clubInfo.noActive              = data.noActive
    this.clubInfo.deleteAllowed         = data.deleteAllowed
    this.clubInfo.generalExit           = data.generalExit
    this.clubInfo.managerExit           = data.managerExit
    this.clubInfo.playNotActive         = data.playNotActive
    this.clubInfo.generalNotPlay        = data.generalNotPlay
    this.clubInfo.managerNotPlay        = data.managerNotPlay
    this.clubInfo.ratioSetup            = data.ratioSetup
    this.clubInfo.showJoinTime          = data.showJoinTime
	this.clubInfo.showPlayTime          = data.showPlayTime
	this.clubInfo.showOtherTime         = data.showOtherTime
	print('data.deskDirect : '..tostring(data.deskDirect)..' data.showBigWin ：'..tostring(data.showBigWin)..'  data.showLordBalance : '..tostring(data.showLordBalance))
    -- this.checkClubIcon()
end
--检查牌友群内头像情况
function this.checkClubIcon()
    this.clubInfo.icons={}
    LocalDataManager.Instance:ReadFromLocal(this.clubInfo.icons,this.clubInfo.clubId)
    local iconNum=0
    for k,v in pairs(this.clubInfo.icons) do
        iconNum=iconNum+1
    end
    local msg = Message.New()
    msg.type = proxy_pb.CLUB_USER_PHOTO_LIST
    local body = proxy_pb.PClubUserPhoto();
    body.clubId = this.clubInfo.clubId;
    if iconNum==0 then
        body.flag = 1;--查询范围 0 = 查询上次查询之后的玩家  1 = 查询俱乐部所有用户
    else
        body.flag = 0;
    end
    msg.body = body:SerializeToString();
    SendProxyMessage(msg, this.OnCheckClubIconResult)
end
--检查头像的回复
function this.OnCheckClubIconResult(msg)
    local data = proxy_pb.RClubUserPhotoList();
    data:ParseFromString(msg.body);
    for i=1,#data.userPhoto do
        this.clubInfo.icons[data.userPhoto.userId]=data.userPhoto.icon
    end
    LocalDataManager.Instance:WriteToLocal(this.clubInfo.icons,this.clubInfo.clubId)
end
--设置牌友群基本信息界面
function this.setClubInfoView()
    if this.clubInfo ~= nil then
        clubName:GetComponent('UILabel').text = this.clubInfo.name
		if this.clubInfo.lordBalance and this.clubInfo.lordBalance ~= nil then 
			print('this.clubInfo.lordBalance : '..tostring(this.clubInfo.lordBalance)..' this.clubInfo.showLordBalance : '..tostring(this.clubInfo.showLordBalance))
			manageDiamond:GetComponent('UILabel').text = '（群主钻石：'..this.clubInfo.lordBalance..'）'
		else
			manageDiamond:GetComponent('UILabel').text = ''
		end
		if this.clubInfo.showLordBalance == 0 then
			manageDiamond.gameObject:SetActive(this.clubInfo.userType == proxy_pb.LORD)
		elseif this.clubInfo.showLordBalance == 1 then
			manageDiamond.gameObject:SetActive(this.clubInfo.userType == proxy_pb.LORD or (bit:_and(this.clubInfo.privilege, 1) == 1))
		elseif this.clubInfo.showLordBalance == 2 then
			manageDiamond.gameObject:SetActive(this.clubInfo.userType == proxy_pb.LORD or this.clubInfo.userType == proxy_pb.MANAGER)
		elseif this.clubInfo.showLordBalance == 3 then
			manageDiamond.gameObject:SetActive(this.clubInfo.userType == proxy_pb.LORD or this.clubInfo.userType == proxy_pb.MANAGER or this.clubInfo.userType == proxy_pb.VICE_MANAGER or this.clubInfo.userType == proxy_pb.ASSISTANT or this.clubInfo.userType == proxy_pb.PRESIDENT or this.clubInfo.userType == proxy_pb.VICE_PRESIDENT)
		else
			manageDiamond.gameObject:SetActive(false)    
		end
		local pos = clubName.localPosition
		pos.y = manageDiamond.gameObject.activeSelf and 5 or -3
		clubName.localPosition = pos
        if this.clubInfo.clubId ~= nil then
            clubID:GetComponent('UILabel').text = tostring(this.clubInfo.clubId);
        end

        --添加群主的信息
        clubLeaderName:GetComponent('UILabel').text = "群主："..this.clubInfo.lordNickname;
        coroutine.start(LoadPlayerIcon, clubLeaderIcon:GetComponent('UITexture'), this.clubInfo.clubLeaderIcon);
        local count=this.clubInfo.realMsg.remindCount+this.clubInfo.realMsg.alertCount
        print('this.clubInfo.realMsg.remindCount : '..this.clubInfo.realMsg.remindCount)
        print('this.clubInfo.realMsg.alertCount : '..this.clubInfo.realMsg.alertCount)
        buttonMessage:Find('dian').gameObject:SetActive(count ~= 0);
        buttonMessage:Find('dian/num'):GetComponent('UILabel').text = count ~= 0 and (count>99 and '99' or count) or ''
        
        if panelClub.clubInfo.userType==proxy_pb.LORD or panelClub.clubInfo.userType==proxy_pb.MANAGER then
            buttonMember:Find('dian').gameObject:SetActive(this.clubInfo.hasMessage)
        else
            buttonMember:Find('dian').gameObject:SetActive(false)
        end
    end

    if this.clubInfo.pauseRoom then
        gameObject.transform:Find('Stop').gameObject:SetActive(true)
        gameObject.transform:Find('Stop/Stop/Label'):GetComponent('UILabel').text = (this.clubInfo.pauseInfo ~= '') and this.clubInfo.pauseInfo 
            or '群主已暂停开房，若有需要请联系群主或管理员';  
    else
        gameObject.transform:Find('Stop').gameObject:SetActive(false)
    end
end
--进入牌友群的回调
function this.OnEnterClubResult(msg)
    
end

function this.initTable()
    for i = 1, #tableShuaXinTime do
        local cnt = tableShuaXinTime[i]
        coroutine.stop(cnt)
        cnt = nil
    end
    tableShuaXinTime = {}
end

--[[    @desc: 刷新牌友群界面
    author:{author}
    time:2018-09-09 17:16:35
    @return:
]]
function this.refresh(isNeedRefreshPlays)
    -- if this.clubList ~= nil then
    --     for i = 1, #this.clubList.clubs do
    --         if this.clubList.clubs[i].choiced then
    --             this.clubInfo.name = this.clubList.clubs[i].name;
    --             this.clubInfo.clubId = this.clubList.clubs[i].clubId;
    --             this.clubInfo.clubLeaderName = this.clubList.clubs[i].nickname;
    --             this.clubInfo.clubLeaderIcon = this.clubList.clubs[i].icon;
    --             if isNeedRefreshPlays then
    --                 this.shuaXinPlays(this.clubInfo.clubId,this.clubInfo.playId);
    --             end
    --             break
    --         end
    --     end
    -- end
    --print('data.scoreMsgs : '..#this.clubInfo.scoreMsgs)
    this.InsertAllDeductMessages(this.clubInfo.scoreMsgs)
    print('bit:_and(this.clubInfo.privilege, 2048) : '..tostring(bit:_and(this.clubInfo.privilege, 2048)))
    gameObject.transform:Find('WanFaToggle/Setting/back/Label1'):GetComponent('UILabel').text = (this.clubInfo.userType == proxy_pb.LORD or (bit:_and(this.clubInfo.privilege, 4) == 4)) and '玩法设置' or '显示设置'
    if this.clubInfo.gameMode and 
    (this.clubInfo.userType == proxy_pb.LORD 
    or (bit:_and(this.clubInfo.privilege, 2048) == 2048)
    or this.clubInfo.timesAllowed or this.clubInfo.validTimesAllowed or this.clubInfo.bigTimesAllowed or this.clubInfo.feeAllowed
    or (this.clubInfo.butlerAllowed and this.clubInfo.userType ~= proxy_pb.GENERAL)
    or (this.clubInfo.myButlerAllowed and this.clubInfo.userType ~= proxy_pb.GENERAL and this.clubInfo.userType ~= proxy_pb.VICE_PRESIDENT)
    or (this.clubInfo.myUserAllowed and this.clubInfo.userType ~= proxy_pb.GENERAL)
	or (this.clubInfo.managerAllowed and this.clubInfo.userType == proxy_pb.MANAGER)) then
        buttonRank.gameObject:SetActive(true)
    else
        buttonRank.gameObject:SetActive(false)
    end
    
    if this.clubInfo.userType ~= proxy_pb.LORD and  this.clubInfo.privilege~=4 and UnityEngine.PlayerPrefs.GetInt('playSettingGuide', 0) == 0 then
        playSettingGuide.gameObject:SetActive(true)
    end
    
    this.shuaXinPlays(this.clubInfo.clubId,this.clubInfo.playId);
    
    this.OnGetNotice()--公告赋值

    this.setClubInfoView()
end

function this.shuaXinPlays(clubId, playId)
    local msg = Message.New()
    msg.type = proxy_pb.ENTER_CLUB_PLAY
    local body = proxy_pb.PEnterClubPlay();
    body.clubId = clubId;
    body.playId = '-'..this.clubInfo.clubId
    msg.body = body:SerializeToString();
    SendProxyMessage(msg, this.OnEnterClubPlayResult)
end

function this.OnEnterClubPlayResult(msg)
    if this.clubInfo.clubId then
        local data = proxy_pb.REnterClubPlay();
        data:ParseFromString(msg.body);
        this.refreshPlay(data)
    end
end

function this.RefreshPlayText(rule)
    this.ruleInfo = rule;
end


function this.refreshPlay(data)
    this.clubInfo.plays = data.plays
    print('data.plays : '..#data.plays)
    this.playInfo.settings  = nil
    for i = 1, maxPlayNum do
       
        playsToggles[i].transform:GetComponent('UIToggle'):Set(false)
        playsToggles[i].transform:GetComponent('BoxCollider').enabled = false
        --playsToggles[i].none.gameObject:SetActive(true)
        playsToggles[i].Label1:GetComponent('UILabel').text = ''
        playsToggles[i].Label2:GetComponent('UILabel').text = ''
        SetUserData(playsToggles[i].transform.gameObject, nil)
    end
    
    this.initTable()

    copyPlays = {}
    for i=1, #data.plays do
        table.insert(copyPlays, data.plays[i]);
    end
    --隐藏空的玩法toggle
    if #copyPlays+1 <= maxPlayNum then 
        for i = #copyPlays+1, maxPlayNum do 
            playsToggles[i].transform.gameObject:SetActive(false);
        end
    end 
    print('#copyPlays :'..#copyPlays)
    for j = 1, #copyPlays do

        --playsToggles[j].none.gameObject:SetActive(false)
        if j<=maxPlayNum then
            playsToggles[j].transform.gameObject:SetActive(true)
            playsToggles[j].transform:GetComponent('BoxCollider').enabled = true;
            
            playsToggles[j].Label1:GetComponent('UILabel').fontSize = GetByteCount(copyPlays[j].name)> 12 and 26 or 30
            playsToggles[j].Label2:GetComponent('UILabel').fontSize = GetByteCount(copyPlays[j].name)> 12 and 26 or 30
            playsToggles[j].Label1:GetComponent('UILabel').text = copyPlays[j].name;
            playsToggles[j].Label2:GetComponent('UILabel').text = copyPlays[j].name;
            
            
            SetUserData(playsToggles[j].transform.gameObject, copyPlays[j])
        end
        
        --对于选中的玩法，在牌友群中创建桌子
		this.playInfo.name      = copyPlays[j].name;
		this.playInfo.playId    = copyPlays[j].playId;
		this.playInfo.gameType  = copyPlays[j].gameType;
		this.playInfo.roomType  = copyPlays[j].roomType
    end

    this.clubInfo.allDesks = data.desks;

    this.refreshTables(this.clubInfo.playId)
end



local CurAllDesks = {}
local CurPlayRules = {} --生成当前俱乐部 当前规则下的玩法
function this.GeneratePlayRules(playId)
    local playRuleItems = {};
    for	i =1,#this.clubInfo.plays do
        if #this.clubInfo.plays >1 and (i~=1) then
            local rules1 = this.clubInfo.plays[i].rules
            for j=1,#rules1 do
                if rules1[j].gameType == this.clubInfo.plays[i].gameType then
                    local playRuleItem          = {};
                    playRuleItem.gameType       = this.clubInfo.plays[i].gameType
                    playRuleItem.roomType       = this.clubInfo.plays[i].roomType
                    playRuleItem.ruleId         = rules1[j].ruleId
                    playRuleItem.rounds         = rules1[j].rounds
                    playRuleItem.size           = rules1[j].size
                    playRuleItem.trusteeship    = rules1[j].trusteeship
                    playRuleItem.phzConfig      = rules1[j].phzConfig
                    playRuleItem.pdkConfig      = rules1[j].pdkConfig
                    playRuleItem.mjConfig       = rules1[j].mjConfig
                    playRuleItem.xhzdConfig     = rules1[j].xhzdConfig
                    playRuleItem.dtzConfig      = rules1[j].dtzConfig
                    playRuleItem.bbtzConfig     = rules1[j].bbtzConfig
                    playRuleItem.xplpConfig     = rules1[j].xplpConfig
                    playRuleItem.hnmConfig      = rules1[j].hnmConfig
                    playRuleItem.yjqfConfig     = rules1[j].yjqfConfig
					playRuleItem.openGps        = rules1[j].openGps
					playRuleItem.openIp         = rules1[j].openIp
                    table.insert(playRuleItems,playRuleItem)
                end
            end
        end
    end
    
    this.clubInfo.playId=playId
    
    this.clubInfo.desks={}
    if playId=='-'..this.clubInfo.clubId then
        this.clubInfo.desks =   this.clubInfo.allDesks
    else
        for i=1,#this.clubInfo.allDesks do
            if this.clubInfo.allDesks[i].playId==playId then
                table.insert(this.clubInfo.desks,this.clubInfo.allDesks[i])
            end
        end
    end

    CurAllDesks = {}
    if (this.clubInfo.privateRoom == true or this.clubInfo.publicRoom == true) and (this.clubInfo.desks ~= nil and #this.clubInfo.desks ~= 0) then
        table.insert(CurAllDesks, {ruleId = '0000', IsOpenDesk = true} )
    end
    print('this.clubInfo.displayCurrentPlay : '..tostring(this.clubInfo.displayCurrentPlay)..' this.clubInfo.displayAllPlay : '..tostring(this.clubInfo.displayAllPlay)..' this.clubInfo.itemPlayId :'..tostring(this.clubInfo.itemPlayId))
    print(' #this.clubInfo.desks : '..#this.clubInfo.desks..' #copyPlays : '..#copyPlays)
    if playsToggles[1].transform:GetComponent('UIToggle').value then
        if this.clubInfo.displayCurrentPlay and this.clubInfo.displayAllPlay and this.clubInfo.itemPlayId ~= 0 then
            for i=1, #this.clubInfo.desks do
                if tonumber(this.clubInfo.desks[i].playId) == tonumber(this.clubInfo.itemPlayId) and #this.clubInfo.desks[i].players ==0 then
                    table.insert(CurAllDesks, this.clubInfo.desks[i])
                end
            end
            for i = 1, #copyPlays do
                for j = 1, #copyPlays[i].rules do
                    for k = 1, #this.clubInfo.desks do
                        if copyPlays[i].rules[j].ruleId == this.clubInfo.desks[k].ruleId then
                            if tonumber(this.clubInfo.desks[k].playId) == tonumber(this.clubInfo.itemPlayId) and #this.clubInfo.desks[k].players>0 and #this.clubInfo.desks[k].players~=copyPlays[i].rules[j].size then
                                table.insert(CurAllDesks, this.clubInfo.desks[k])
                            end
                        end
                    end
                end
            end
            for i = 1, #copyPlays do
                for j = 1, #copyPlays[i].rules do
                    for k = 1, #this.clubInfo.desks do
                        if copyPlays[i].rules[j].ruleId == this.clubInfo.desks[k].ruleId then
                            if tonumber(this.clubInfo.desks[k].playId) ~= tonumber(this.clubInfo.itemPlayId) and #this.clubInfo.desks[k].players>0 and #this.clubInfo.desks[k].players~=copyPlays[i].rules[j].size then
                                table.insert(CurAllDesks, this.clubInfo.desks[k])
                            end
                        end
                    end
                end
            end
        elseif this.clubInfo.displayCurrentPlay and (not this.clubInfo.displayAllPlay) and this.clubInfo.itemPlayId ~= 0 then
            for i=1, #this.clubInfo.desks do
                if tonumber(this.clubInfo.desks[i].playId) == tonumber(this.clubInfo.itemPlayId) and #this.clubInfo.desks[i].players ==0 then
                    table.insert(CurAllDesks, this.clubInfo.desks[i])
                end
            end
            for i = 1, #copyPlays do
                for j = 1, #copyPlays[i].rules do
                    for k = 1, #this.clubInfo.desks do
                        if copyPlays[i].rules[j].ruleId == this.clubInfo.desks[k].ruleId then
                            if tonumber(this.clubInfo.desks[k].playId) == tonumber(this.clubInfo.itemPlayId) and #this.clubInfo.desks[k].players>0 and #this.clubInfo.desks[k].players<copyPlays[i].rules[j].size then
                                table.insert(CurAllDesks, this.clubInfo.desks[k])
                            end
                        end
                    end
                end
            end
            for i = 1, #copyPlays do
                for j = 1, #copyPlays[i].rules do
                    for k = 1, #this.clubInfo.desks do
                        if copyPlays[i].rules[j].ruleId == this.clubInfo.desks[k].ruleId then
                            if tonumber(this.clubInfo.desks[k].playId) ~= tonumber(this.clubInfo.itemPlayId) and #this.clubInfo.desks[k].players>0 and #this.clubInfo.desks[k].players<copyPlays[i].rules[j].size then
                                table.insert(CurAllDesks, this.clubInfo.desks[k])
                            end
                        end
                    end
                end
            end
            for i = 1, #copyPlays do
                for j = 1, #copyPlays[i].rules do
                    for k = 1, #this.clubInfo.desks do
                        if copyPlays[i].rules[j].ruleId == this.clubInfo.desks[k].ruleId then
                            if #this.clubInfo.desks[k].players==copyPlays[i].rules[j].size then
                                table.insert(CurAllDesks, this.clubInfo.desks[k])
                            end
                        end
                    end
                end
            end
        elseif (not this.clubInfo.displayCurrentPlay) and this.clubInfo.displayAllPlay and this.clubInfo.itemPlayId ~= 0 then
            for i = 1, #copyPlays do
                for j = 1, #copyPlays[i].rules do
                    for k = 1, #this.clubInfo.desks do
                        if copyPlays[i].rules[j].ruleId == this.clubInfo.desks[k].ruleId then
                            if #this.clubInfo.desks[k].players==copyPlays[i].rules[j].size then
                            else
                                table.insert(CurAllDesks, this.clubInfo.desks[k])
                            end
                        end
                    end
                end
            end
        else
            for i=1, #this.clubInfo.desks do
                table.insert(CurAllDesks, this.clubInfo.desks[i])
            end
        end
    else
        if this.clubInfo.displayAllPlay then
            for i = 1, #copyPlays do
                for j = 1, #copyPlays[i].rules do
                    for k = 1, #this.clubInfo.desks do
                        if copyPlays[i].rules[j].ruleId == this.clubInfo.desks[k].ruleId then
                            if #this.clubInfo.desks[k].players==copyPlays[i].rules[j].size then
                            else
                                table.insert(CurAllDesks, this.clubInfo.desks[k])
                            end
                        end
                    end
                end
            end
        else
            for i=1, #this.clubInfo.desks do
                table.insert(CurAllDesks, this.clubInfo.desks[i])
            end
        end
    end
    
    CurPlayRules = {}
    for i=1, #playRuleItems do
        CurPlayRules[playRuleItems[i].ruleId] = playRuleItems[i]
    end
end

--通过ruleid 得到rule 里面有转换
function this.GetPlayRuleByRuleId(ruleId)
    local ruleTemp = {}
    local rule = CurPlayRules[ruleId]

    if rule.IsOpenDesk then
        return rule
    end

    ruleTemp.rounds         = rule.rounds;
    ruleTemp.size           = rule.size;
    ruleTemp.gameType       = rule.gameType;
    ruleTemp.trusteeship    = rule.trusteeship;
    ruleTemp.ruleId         =  rule.ruleId;
    ruleTemp.roomType       = rule.roomType;
	ruleTemp.openGps        = rule.openGps
	ruleTemp.openIp         = rule.openIp
    if rule.gameType == proxy_pb.PHZ then
        ruleTemp.qiHuHuXi           = rule.phzConfig.qiHuHuXi;
        ruleTemp.tianDiHu           = rule.phzConfig.tianDiHu;
        ruleTemp.heiHongHu          = rule.phzConfig.heiHongHu;
        ruleTemp.heiHongDian        = rule.phzConfig.heiHongDian;
        ruleTemp.maxHuXi            = rule.phzConfig.maxHuXi;
        ruleTemp.canHuZiMo          = rule.phzConfig.canHuZiMo;
        ruleTemp.limitFan           = rule.phzConfig.limitFan;
        ruleTemp.niao               = rule.phzConfig.niao;
        ruleTemp.tuo                = rule.phzConfig.tuo;
        ruleTemp.quanMingTang       = rule.phzConfig.quanMingTang;
        ruleTemp.fangPao            = rule.phzConfig.fangPao
        ruleTemp.haveHuMustHu       = rule.phzConfig.haveHuMustHu
        ruleTemp.xing               = rule.phzConfig.xing
        ruleTemp.choiceHu           = rule.phzConfig.choiceHu
        ruleTemp.calculationFanMode = rule.phzConfig.calculationFanMode
        ruleTemp.mode               = rule.phzConfig.mode
        ruleTemp.piao               = rule.phzConfig.piao
    end
    if rule.gameType == proxy_pb.PDK then
        ruleTemp.cardCount  = rule.pdkConfig.cardCount;
        ruleTemp.showCount  = rule.pdkConfig.showCount;
        ruleTemp.firstPlay  = rule.pdkConfig.firstPlay;
        ruleTemp.bombSplit  = rule.pdkConfig.bombSplit;
        ruleTemp.floatScore = rule.pdkConfig.floatScore;
        ruleTemp.hitBird    = rule.pdkConfig.hitBird;
    end
    if rule.gameType == proxy_pb.MJ then
        ruleTemp.bird               = rule.mjConfig.bird;
        ruleTemp.dianPaoHu          = rule.mjConfig.dianPaoHu;
        ruleTemp.floatScore         = rule.mjConfig.floatScore;
        ruleTemp.birdAllHit         = rule.mjConfig.birdAllHit;
        ruleTemp.birdBankerStart    = rule.mjConfig.birdBankerStart;
        ruleTemp.birdWinStart       = rule.mjConfig.birdWinStart;
        ruleTemp.bird159            = rule.mjConfig.bird159;
        ruleTemp.scoreBird          = rule.mjConfig.scoreBird;
        ruleTemp.hongZhongCount     = rule.mjConfig.hongZhongCount;
        ruleTemp.quanQiuRen         = false;--这里不用展示
    end
    if rule.gameType == proxy_pb.XPLP then 
        ruleTemp.huPattern  = rule.xplpConfig.huPattern;
        ruleTemp.huMust     = rule.xplpConfig.huMust;
        ruleTemp.chongMode  = rule.xplpConfig.chongMode;
    end
    if rule.gameType == proxy_pb.HNM and rule.roomType == proxy_pb.HNHSM then 
        ruleTemp.huPattern          = rule.hnmConfig.huPattern;
        ruleTemp.takeFeng           = rule.hnmConfig.takeFeng;
        ruleTemp.variableHongZhong  = rule.hnmConfig.variableHongZhong;
    end
    if rule.gameType == proxy_pb.HNM and rule.roomType == proxy_pb.HNZZM then 
        ruleTemp.huPattern          = rule.hnmConfig.huPattern;
        ruleTemp.takeFeng           = rule.hnmConfig.takeFeng;
        ruleTemp.takeHun            = rule.hnmConfig.takeHun;
        ruleTemp.selectPao          = rule.hnmConfig.selectPao;
    end
    if rule.gameType == proxy_pb.XHZD then
        ruleTemp.canStraight    = rule.xhzdConfig.canStraight;
        ruleTemp.happyScoreAdd  = rule.xhzdConfig.happyScoreAdd;
        ruleTemp.bomb3AsHappy   = rule.xhzdConfig.bomb3AsHappy;
        ruleTemp.multiple       = rule.xhzdConfig.multiple;
        ruleTemp.baseScore      = rule.xhzdConfig.baseScore;
        ruleTemp.niao           = rule.xhzdConfig.niao;
    end
    if rule.gameType == proxy_pb.DTZ then
        --ruleTemp.size = nil;
        ruleTemp.scoreSelect    = rule.dtzConfig.scoreSelect;
        ruleTemp.cardCount      = rule.dtzConfig.cardCount;
        ruleTemp.lastBonus      = rule.dtzConfig.lastBonus;
        --ruleTemp.canisterBonus = rule.dtzConfig.canisterBonus;
        --ruleTemp.dark = rule.dtzConfig.dark;
        --ruleTemp.show = rule.dtzConfig.show;
        ruleTemp.san            = rule.dtzConfig.san;
        ruleTemp.radom          = rule.dtzConfig.radom;
        ruleTemp.guan           = rule.dtzConfig.guan;
    end

    if rule.gameType == proxy_pb.BBTZ then
        ruleTemp.san    = rule.bbtzConfig.guan;
        ruleTemp.mask   = rule.bbtzConfig.mask;
        ruleTemp.show   = rule.bbtzConfig.show;
        ruleTemp.hammer = rule.bbtzConfig.hammer;
        ruleTemp.betSan = rule.bbtzConfig.betSan;
    end
    if rule.gameType == proxy_pb.YJQF then
        ruleTemp.happly = rule.yjqfConfig.happly
        ruleTemp.rewardScore = rule.yjqfConfig.rewardScore
        ruleTemp.retainCard = rule.yjqfConfig.retainCard
    end

    return ruleTemp
end

--刷新玩法的Toggle
function this.RefreshPlayToggle()
    if not gameObject.activeSelf then return end

    local panel = gameObject.transform:Find('WanFaToggle/Scroll View'):GetComponent('UIPanel')
    local Width = panel.transform:Find('Grid'):GetComponent('UIGrid').cellWidth
    local MaxShowCount =  math.modf(panel.transform.parent:GetComponent('UIWidget').width / Width) - 1
    local fillWidth = panel.transform.parent:GetComponent('UIWidget').width % Width

    if #copyPlays ~= 0 then
        if #copyPlays - 1 < MaxShowCount  then
            panel.rightAnchor.absolute = -((MaxShowCount - (#copyPlays - 1)) * Width + fillWidth) 
            buttonPlaySetting.transform.localPosition = Vector2(#copyPlays * Width, 0)
            playSettingGuideSetting.transform.localPosition = Vector2(#copyPlays * Width, 0)
        else
            panel.rightAnchor.absolute = -(Width)
            buttonPlaySetting.transform.localPosition = Vector2(MaxShowCount * Width + fillWidth, 0)
            playSettingGuideSetting.transform.localPosition = Vector2(MaxShowCount * Width + fillWidth, 0)
        end
        --panel.leftAnchor.absolute = 199
        panel.gameObject:SetActive(true)
    else
        --panel.leftAnchor.absolute = 0
        --panel.rightAnchor.absolute = - panel.transform.parent:GetComponent('UIWidget').width
        buttonPlaySetting.transform.localPosition = Vector2(0,0)
        playSettingGuideSetting.transform.localPosition = Vector2(0,0)
        panel.gameObject:SetActive(false)
    end

     --刷新玩法的grid
    local wanfaGrid = gameObject.transform:Find('WanFaToggle/Scroll View/Grid'):GetComponent('UIGrid');
    --wanfaGrid:Reposition();
    
    -- local clip = wanfaGrid.transform.parent:GetComponent('UIPanel').finalClipRegion
    -- print('clip:', tostring(clip.x), tostring(clip.y), tostring(clip.z), tostring(clip.w))
    wanfaGrid.transform.parent:GetComponent('UIScrollView'):InvalidateBounds()
    wanfaGrid.transform.parent:GetComponent('UIScrollView'):RestrictWithinBounds(true)
    if not UITools.ScrollViewCanMove(wanfaGrid.transform.parent:GetComponent('UIScrollView')) then
        wanfaGrid.transform.parent:GetComponent('UIScrollView'):ResetPosition()
    end
end

function this.RefreshDeskItem(obj, index)
    local deskInfo = CurAllDesks[index + 1]
    this.RefreshDeskObj(obj, deskInfo)
end

function this.OnDeskItemInstance(go)
    deskList[go]={}
    local desk = deskList[go];
    desk.Background=go.transform:Find("Background"):GetComponent('UISprite')
    desk.zhuoBu=go.transform:Find("Background/zhuoBu"):GetComponent('UISprite')
    desk.playName=go.transform:Find('playName'):GetComponent('UILabel')
    desk.Rule=go.transform:Find('Rule')
    desk.RulePanel=desk.Rule.transform:Find('Panel')
    desk.RuleLabel=desk.RulePanel:Find('Label'):GetComponent('UILabel')
    desk.OpenRoom=go.transform:Find('OpenRoom')
    desk.startedLabel=go.transform:Find('started'):GetComponent('UILabel')
    desk.Lock=go.transform:Find('Lock')
    desk.plays={}
    for i=1,4 do
        desk.plays[i]={}
        desk.plays[i].transform = go.transform:Find("Players/player"..i);
        desk.plays[i].empty = desk.plays[i].transform:Find("empty")
        desk.plays[i].tx = desk.plays[i].transform:Find('tx'):GetComponent('UITexture')
    end
    message:AddClick(go.gameObject, this.OnClickTable)
    message:AddClick(desk.Rule:Find('Bg').gameObject, this.OnClickTable)
end

function this.ClearDesk(deskObj)
    local desk = deskList[deskObj]
    if desk~=nil then
        desk.Rule.gameObject:SetActive(false)
        desk.startedLabel.gameObject:SetActive(false)
        desk.playName.gameObject:SetActive(false)
        desk.zhuoBu.gameObject:SetActive(false)
        for j=1,4 do
            desk.plays[j].transform.gameObject:SetActive(false)
            --player.transform:Find('tx'):GetComponent('UITexture').mainTexture = nil
        end
        desk.Lock.gameObject:SetActive(false)
        desk.OpenRoom.gameObject:SetActive(true)

        SetUserData(deskObj, nil)
    end
end 

function this.RefreshDeskObj(deskObj, deskRule)
    this.ClearDesk(deskObj)

    local desk = deskList[deskObj];

    SetUserData(deskObj, deskRule);--把服务器的数据挂在到桌子这个gameObject上

    if deskRule.IsOpenDesk then
        return
    end

    local rule = {};
    rule            = this.GetPlayRuleByRuleId(deskRule.ruleId)
    rule.roomNumber = deskRule.roomNumber;
    rule.open       = deskRule.open;
    rule.round      = deskRule.round;
    rule.players    = deskRule.players;
    if deskRule.round~=0 then
        rule.size=#rule.players
    end
    if rule.size == 2 then
        desk.Background.spriteName = '二人桌'
        this.SetPlaySet(2,desk, deskRule, rule);
    elseif rule.size == 3 then
        desk.Background.spriteName = '三人桌'
        this.SetPlaySet(3,desk, deskRule, rule);
    elseif rule.size == 4 then
        desk.Background.spriteName = '四人桌'
        this.SetPlaySet(4,desk, deskRule, rule);
    end
    desk.playName.gameObject:SetActive(true)
    desk.playName.text = this.GetGameTyeByPlay(deskRule.playId).name
    local needGameName = false
    if deskRule.round == 0 then
        desk.Rule.gameObject:SetActive(true);
        if rule.gameType == proxy_pb.PHZ then 
            this.ShowRule(desk, deskRule.playId, getWanFaText(rule, true, true, needGameName, true,true,true));
        elseif rule.gameType == proxy_pb.PDK then 
            this.ShowRule(desk, deskRule.playId, getWanFaText_pdk(rule,true,true,needGameName, true,true));
        elseif rule.gameType == proxy_pb.MJ then
            this.ShowRule(desk, deskRule.playId, GetMJRuleText(rule,true,false,needGameName, true,true));
        elseif rule.gameType == proxy_pb.XHZD then
            this.ShowRule(desk, deskRule.playId, getXHZDRuleString(rule,true,true,needGameName,true));
        elseif rule.gameType == proxy_pb.DTZ then
            this.ShowRule(desk, deskRule.playId, GetDTZRuleString(rule,true,false,needGameName, true,true));
        elseif rule.gameType == proxy_pb.BBTZ then
            this.ShowRule(desk, deskRule.playId, GetBBTZRuleString(rule,true,false,needGameName, true,true));
        elseif rule.gameType == proxy_pb.XPLP then 
            this.ShowRule(desk, deskRule.playId, GetXPLPRuleText(rule,true,false,needGameName, true,true));
        elseif rule.gameType == proxy_pb.HNM and rule.roomType == proxy_pb.HNHSM then 
            this.ShowRule(desk, deskRule.playId, GetHNHSMRuleText(rule,true,false,needGameName, true,true));
        elseif rule.gameType == proxy_pb.HNM and rule.roomType == proxy_pb.HNZZM then 
            this.ShowRule(desk, deskRule.playId, GetHNZZMRuleText(rule,true,false,needGameName, true,true));
        elseif rule.gameType == proxy_pb.YJQF then 
            this.ShowRule(desk, deskRule.playId, getYJQFRuleString(rule, true, true, needGameName,true))
        end
    else
        this.SetInStartedTable(desk, deskRule)
    end

    desk.Lock.gameObject:SetActive(not deskRule.open)
    desk.OpenRoom.gameObject:SetActive(false)
end

--刷新牌桌上的局数
function this.onRoundRefresh(msg)
    local b = proxy_pb.RRoomRoundStart()
    b:ParseFromString(msg.body)
    
    if not PanelManager.Instance:IsActive('panelClub') then
        return 
    end

    for i=1, #CurAllDesks do
        if CurAllDesks[i].roomNumber == b.roomNumber then
            CurAllDesks.round = b.round
        end

    end
    
    this.RefreshDesksCollectionGrid()
end

function this.RefreshDesksCollectionGrid(restPosition)
    -- print('this.clubInfo.desks:', #this.clubInfo.desks)
    -- print('CurAllDesks:', #CurAllDesks)
    DesksCollectionGrid:Resize(#CurAllDesks)
    if not UITools.ScrollViewCanMove(DesksCollectionGrid.transform.parent:GetComponent('UIScrollView')) or restPosition == true then
        DesksCollectionGrid.transform.parent:GetComponent('UIScrollView'):ResetPosition()
    end
    DesksCollectionGrid.transform.parent:GetComponent('UIScrollView'):Press(false)
end

--刷新入参玩法的桌子
function this.refreshTables(playId)
    if playId=='-'..this.clubInfo.clubId then
        for i = 1, maxPlayNum do
            playsToggles[i].transform:GetComponent('UIToggle'):Set(false)
        end
        playsToggles[1].transform:GetComponent('UIToggle'):Set(true)
    else
        local hasPlay=false
        for i = 1, maxPlayNum do
            if playsToggles[i].transform.gameObject.activeSelf and GetUserData(playsToggles[i].transform.gameObject).playId==playId then
                playsToggles[i].transform:GetComponent('UIToggle'):Set(true)
                hasPlay=true
            else
                playsToggles[i].transform:GetComponent('UIToggle'):Set(false)
            end
        end
        if hasPlay==false then
            playId='-'..this.clubInfo.clubId
            playsToggles[1].transform:GetComponent('UIToggle'):Set(true)
        end
    end

    local restPosition = this.clubInfo.playId ~= playId

    this.GeneratePlayRules(playId)
    this.RefreshPlayToggle()
    
    this.RefreshDesksCollectionGrid(restPosition)

    if this.clubInfo.playId ~= nil then --this.clubInfo.playId ~= nil and this.clubInfo.playId ~= tostring(-panelClub.clubInfo.clubId) then
        local msg = Message.New()
        msg.type = proxy_pb.PLAY_RULE_LIST;
        local body=proxy_pb.PPlayRuleList()
        body.playId = this.clubInfo.playId
        body.clubId = panelClub.clubInfo.clubId
        msg.body = body:SerializeToString()
        SendProxyMessage(msg, function (msg)
            local data = proxy_pb.RPlayRuleList()
            data:ParseFromString(msg.body)

            this.refreshPlayDisplay()
            panelLogin.HideNetWaitting()

            for i = 1, #data.rules do
                if data.rules[i].choiced then
                    this.RefreshPlayText(data.rules[i])
                    return 
                end
            end
        end);
    else
        this.refreshPlayDisplay()
        panelLogin.HideNetWaitting()
    end
    coroutine.start(function ()
        WaitForEndOfFrame();
        gameObject.transform:Find('NoPlays').gameObject:SetActive(IsCanSetPlay() and #this.clubInfo.plays == 0)
        this.ShowClubGuide()
    end)
    
end

function  this.SetTabelBackground(desk, gameType) --获取桌子预设项
    if gameType == proxy_pb.PHZ then 
        desk.zhuoBu.gameObject:SetActive(true)
        desk.zhuoBu.spriteName='跑胡子桌面'
    
    elseif gameType == proxy_pb.PDK then 
        desk.zhuoBu.gameObject:SetActive(true)
        desk.zhuoBu.spriteName='跑得快桌面'
    
    elseif gameType == proxy_pb.MJ then
        desk.zhuoBu.gameObject:SetActive(false)
    elseif gameType == proxy_pb.XHZD then

    elseif gameType == proxy_pb.DTZ then
    
    end 
end

--根据人数来设置座位
function this.SetPlaySet(playNum, desk, deskInfo, rule)

    for i = 1,4 do
        desk.plays[i].transform.gameObject:SetActive(false);
        desk.plays[i].empty.gameObject:SetActive(true);
    end
    
    this.SetTabelBackground(desk, deskInfo.gameType)

    if playNum == 0 then return end;

    if #deskInfo.players>0 then 
        for i = 1, #deskInfo.players do
        end
    end
    
    if playNum <= 4 and playNum >=1 then 

        if playNum == 2 then 
            desk.plays[2].transform.gameObject:SetActive(deskInfo.players[1] ~= nil);
            desk.plays[3].transform.gameObject:SetActive(deskInfo.players[2] ~= nil);

            --设置头像
            if deskInfo.players[1] ~= nil then 
                coroutine.start(LoadPlayerIcon, desk.plays[2].tx,deskInfo.players[1].icon);
                desk.plays[2].empty.gameObject:SetActive(false);
            end
            if deskInfo.players[2] ~= nil then 
                coroutine.start(LoadPlayerIcon, desk.plays[3].tx,deskInfo.players[2].icon);
                desk.plays[3].empty.gameObject:SetActive(false);
            end
            
        end

        if playNum == 3  or playNum == 4 then 
            for i = 1, playNum do 
                desk.plays[i].transform.gameObject:SetActive(deskInfo.players[i] ~= nil);
                
                if deskInfo.players[i] ~= nil then 
                    coroutine.start(LoadPlayerIcon, desk.plays[i].tx,deskInfo.players[i].icon);
                    desk.plays[i].empty.gameObject:SetActive(false);
                end
            end
        end
    end
end

function this.refreshPlayDisplay()

    if PanelManager.Instance:IsActive('panelSetPlay') then
        local msg = Message.New()
		msg.type = proxy_pb.CLUB_PLAY_LIST;
		local body=proxy_pb.PClubPlaySetting()
		body.clubId = panelClub.clubInfo.clubId
		msg.body = body:SerializeToString()
		SendProxyMessage(msg, function (msg)
			local data = proxy_pb.RClubPlayList()
            data:ParseFromString(msg.body)
            panelSetPlay.shuaXinList(data)
		end);
	end
end

function this.SetInStartedTable(desk, deskInfo)
    --local playerName = '[b]'..this.GetGameTyeByPlay(deskInfo.playId).name..'[/b]'
    desk.Rule.gameObject:SetActive(false)
    desk.OpenRoom.gameObject:SetActive(false)
    desk.startedLabel.gameObject:SetActive(true)
    -- obj.transform:Find('started/playName'):GetComponent('UILabel').text = playerName
    desk.startedLabel.text = '已开始\n第' .. deskInfo.round .. '局'
end

function this.ShowRule(desk, playId, rule)
    local height = 105

    desk.RuleLabel.text = rule
    desk.RulePanel:GetComponent('UIScrollView'):ResetPosition()
end

function this.RefreshTime(labelTime, timeChuo)
    while labelTime ~= nil and timeChuo>0 do
        labelTime.text = os.date("%M:%S", timeChuo)
        timeChuo = timeChuo + 1
        coroutine.wait(1)
    end
end
function this.OnGetMsgFirstRecharge(msg)
    local b = proxy_pb.RFirstRecharge()
    b:ParseFromString(msg.body)
    buttonShouChong.gameObject:SetActive(not b.haveRecharge)
end

function this.BalanceChangeRes(msg)
    local b = proxy_pb.RUserBalance()
    b:ParseFromString(msg.body)
    userInfo.balance = b.balance
    info_login.balance = b.balance
    moneyNum:GetComponent('UILabel').text = info_login.balance
    if panelBuyDiamond then
        panelBuyDiamond.setMoneyNum(info_login.balance)
    end
end

function this.SetBalance(Balance)
    moneyNum:GetComponent('UILabel').text = Balance
end

function this.OnSysmessage(msg)
    local b = proxy_pb.RSysMessage()
    b:ParseFromString(msg.body)
    panelMessageBox.SetParamers(ONLY_OK, nil, nil, b.message)
    PanelManager.Instance:ShowWindow('panelMessageBox')
end



--关闭或打开牌友群列表
function this.OnClickClubList(go)
    AudioManager.Instance:PlayAudio('btn')
    if not NGUITools.GetActive(ClubListView.gameObject) then
        ClubListView.gameObject:SetActive(true)
        this.getClubList()
    else
        ClubListView.gameObject:SetActive(false)
    end
end

function this.OnClickButtonMember(go)
    AudioManager.Instance:PlayAudio('btn')
    local data = {}
    data.index = 1
    data.playerIDFuFeeValue = 0
    PanelManager.Instance:ShowWindow('panelMenber', data)
end

function this.OnClickButtonMessage(go)
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:ShowWindow('panelMessage', 1)
end

function this.OnClickButtonPlaySetting(go)
    AudioManager.Instance:PlayAudio('btn');

    if not IsCanSetPlay() then
        PanelManager.Instance:ShowWindow('panelShowSetting')
        return
    end
	if #panelClub.clubInfo.plays ~= 0 then
		local msg = Message.New()
		msg.type = proxy_pb.CLUB_PLAY_LIST;
		local body=proxy_pb.PClubPlaySetting()
		body.clubId = panelClub.clubInfo.clubId
		msg.body = body:SerializeToString()
		SendProxyMessage(msg, function (msg)
			local data = proxy_pb.RClubPlayList()
			data:ParseFromString(msg.body)
			PanelManager.Instance:ShowWindow('panelSetPlay',data);
		end);
	end
end

function this.OnClickButtonSetting(go)
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:ShowWindow('panelClubManage')
end

function this.OnClickGroupCard(go)
    AudioManager.Instance:PlayAudio('btn')
    local data          = {};
    data.clubName       = this.clubInfo.name;
    data.clubID         = this.clubInfo.clubId;
    data.clubLeaderIcon = this.clubInfo.clubLeaderIcon;
    data.lordNickname = this.clubInfo.lordNickname
    PanelManager.Instance:ShowWindow('panelClubCard',data);
end

function this.OnClickButtonJiLu(go)
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:ShowWindow('panelRoomRecord')
end

function this.callLordOrCreate()
    if this.clubInfo.userType ~= proxy_pb.LORD then
        panelMessageTip.SetParamers('无玩法，请联系群主', 1.5)
        PanelManager.Instance:ShowWindow('panelMessageTip')
    else
        PanelManager.Instance:ShowWindow('panelSelctPlay')
    end
end

function this.OnClickButtonSecret(go)
    AudioManager.Instance:PlayAudio('btn')
    if this.clubInfo.pauseRoom==true then
        panelMessageTip.SetParamers('牌友群已暂停开房', 1.5)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        return 
    end
    if #this.clubInfo.plays == 0 then
        this.callLordOrCreate()
        return 
    end

    this.CreateRoom(false)
end

function this.OnClickButtonPublic(go)
    AudioManager.Instance:PlayAudio('btn')
    if this.clubInfo.pauseRoom==true then
        panelMessageTip.SetParamers('牌友群已暂停开房', 1.5)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        return 
    end
    if #this.clubInfo.plays == 0 then
        this.callLordOrCreate()
        return 
    end

    this.CreateRoom(true)
end

function this.OnClickButtonQuick(go)
    AudioManager.Instance:PlayAudio('btn')

    -- if true then
    --     panelMessageTip.SetParamers('快速开始，优化中，暂时不能使用', 1.5)
    --     PanelManager.Instance:ShowWindow('panelMessageTip')
    --     return
    -- end

    if (panelInGame and panelInGame.fanHuiRoomNumber) then
        if roomInfo.gameType == proxy_pb.PDK then
            PanelManager.Instance:ShowWindow('panelInGame_pdk',gameObject.name)
        elseif roomInfo.gameType == proxy_pb.PHZ then
            PanelManager.Instance:ShowWindow('panelInGameLand',gameObject.name)
        elseif roomInfo.gameType == proxy_pb.MJ then
            PanelManager.Instance:ShowWindow('panelInGamemj',gameObject.name)
        elseif roomInfo.gameType == proxy_pb.XHZD then
            PanelManager.Instance:ShowWindow('panelInGame_xhzd',gameObject.name)
        elseif roomInfo.gameType == proxy_pb.DTZ then
            PanelManager.Instance:ShowWindow('panelInGame_dtz',gameObject.name)
        elseif roomInfo.gameType == proxy_pb.BBTZ then
            PanelManager.Instance:ShowWindow('panelInGame_bbtz',gameObject.name)
        elseif roomInfo.gameType == proxy_pb.XPLP then 
            PanelManager.Instance:ShowWindow('panelInGame_xplp',gameObject.name)
        elseif roomInfo.gameType == proxy_pb.HNM and roomInfo.roomType == proxy_pb.HNHSM then 
            PanelManager.Instance:ShowWindow('panelInGame_hnhsm',gameObject.name)
        elseif roomInfo.gameType == proxy_pb.HNM and roomInfo.roomType == proxy_pb.HNZZM then 
            PanelManager.Instance:ShowWindow('panelInGame_hnzzm',gameObject.name)
        elseif roomInfo.gameType == proxy_pb.YJQF then
            PanelManager.Instance:ShowWindow('panelInGame_yjqf',gameObject.name)
        end
        return 
    end

    if #this.clubInfo.plays == 1 then
        this.callLordOrCreate()
        return 
    end
	
    local play = this.GetGameTyeByPlay(this.ruleInfo.playId)
    if this.ruleInfo==nil or this.ruleInfo.ruleId == nil or this.ruleInfo.ruleId == '' or not play then
        panelMessageTip.SetParamers('未选择玩法。', 1.5)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        return 
    end
	
	local ruleTemp = this.GetPlayRuleByRuleId(this.ruleInfo.ruleId)
	if not GpsCheck(ruleTemp) then
		return
	end

    PanelManager.Instance:ShowWindow('panelNetWaitting')
    AudioManager.Instance:PlayAudio('btn')
    local msg = Message.New()
    msg.type = proxy_pb.QUICK_MATCH;
    local body = proxy_pb.PQuickMatch();
    body.ruleId = this.ruleInfo.ruleId
    body.gameType = play.gameType
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, this.OnQuickMatchResult);
end

function this.OnClickPlayButton(go)
    AudioManager.Instance:PlayAudio('btn');
    -- PanelManager.Instance:ShowWindow('panelNetWaitting');
    --更新一下游戏类型
    --this.clubInfo.gameType = this.getCurrentGameTypePlay().gameType;
    this.clubInfo.gameType = GetUserData(go).gameType;

    --go.transform:GetComponent('UIToggle'):Set(true)

    --this.shuaXinPlays(this.clubInfo.clubId, GetUserData(go).playId)
    this.refreshTables(GetUserData(go).playId)
end

function this.OnClickButtonAddLink(go)
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:ShowWindow('panelBuyDiamond')
end

function this.OnClickButtonRecord(go)
    panelLogin.isLobbyRecord = false
    AudioManager.Instance:PlayAudio('btn')
    local data = {}
	data.name = gameObject.name
	data.roomNumFuFeeValue = 0
    PanelManager.Instance:ShowWindow('panelMenberRecord',data)
end

function this.OnClickButtonShare(go)
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:ShowWindow('panelActivity')
end

function this.buyCallBack(errcode, strData)
    if errcode ~= '0' then
        panelMessageBox.SetParamers(ONLY_OK, nil, nil, errcode == '1' and '该商品暂时无法购买' or '购买失败')
        PanelManager.Instance:ShowWindow('panelMessageBox')
    else
        local msg = Message.New()
        msg.type = proxy_pb.VALIDATE_RECEIPT
        local body = proxy_pb.PValidateReceipt()
        body.receipt = strData
        msg.body = body:SerializeToString()
        SendProxyMessage(msg, this.ValidateReceipt)
    end

    panelBuyDiamond.SetItemEnable(true)
end

function this.WXBuyCallBack(errcode)
    panelMessageTip.SetParamers(errcode == '0' and '购买成功' or '购买失败', 2)
    PanelManager.Instance:ShowWindow('panelMessageTip')
end

function this.ValidateReceipt(msg)
    local b = proxy_pb.RValidateReceipt()
    b:ParseFromString(msg.body)
    userInfo.balance = b.balance
    info_login.balance = b.balance
    moneyNum:GetComponent('UILabel').text = info_login.balance
    if panelBuyDiamond then
        panelBuyDiamond.setMoneyNum(info_login.balance)
    end
end

function this.getCurrentGameTypePlay()
    for i=1, #copyPlays do
        local go = playsToggles[i].transform.gameObject;
        if go.transform:GetComponent('UIToggle').value == true then 
            return GetUserData(go);
        end
    end

    return nil;

end

function this.IsInGame(desk)
    for i = 1, #desk.players do
        if desk.players[i].userId == info_login.id then
            return true
        end
    end
end

function this.OnClickTable(go)
    AudioManager.Instance:PlayAudio('btn')
    if this.clubInfo.pauseRoom==true then
        panelMessageTip.SetParamers('牌友群已暂停开房', 1.5)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        return 
    end
    if #this.clubInfo.plays == 0 then
        this.callLordOrCreate()
        return 
    end

    local currentPlayData=this.getCurrentGameTypePlay()
	local deskData = {}
    deskData.desk = GetUserData(go.transform.parent.parent.gameObject)
    if deskData.desk == nil then
        deskData.desk = GetUserData(go)
    end
    
    -- deskData.desk.IsOpenDesk 是用于第一张开发的空桌子
    if (panelInGame and panelInGame.fanHuiRoomNumber) then
        if deskData.desk and not deskData.desk.IsOpenDesk and this.IsInGame(deskData.desk) then
            this.OnClickButtonQuick()
        else
            panelMessageBox.SetParamers(ONLY_OK, this.OnClickButtonToRoom, nil, '您已经加入了一个房间，不可重复加入', '返回房间')
            PanelManager.Instance:ShowWindow('panelMessageBox')
        end
        return 
    end
    --if deskData.desk == nil and  go.name == 'table' then
    if deskData.desk.IsOpenDesk then
        PanelManager.Instance:ShowWindow('panelSelctRule', {needSelcted = false, currentGameType = currentPlayData})
    else
        local ruleTemp = this.GetPlayRuleByRuleId(deskData.desk.ruleId)
        deskData.rule = ruleTemp
        deskData.size = ruleTemp.size
        deskData.roomType = ruleTemp.roomType;
		deskData.playName = this.GetGameTyeByPlay(deskData.desk.playId).name
        if deskData.desk.roomNumber == '' then
            this.CreateRoom(deskData.desk, deskData.desk.open)
            return 
        end

        if deskData.desk.round~=0 then
            deskData.size=#deskData.desk.players
        end
        if IsCanOperatingMenber() or IsCanDestoryRoom() then
            PanelManager.Instance:ShowWindow('panelLookTable', deskData)
        else
            if deskData.desk.open then
                if #deskData.desk.players == deskData.size then
                    PanelManager.Instance:ShowWindow('panelLookTable', deskData)
                    return 
                end
                this.enterRoom(deskData.desk)
            else
                PanelManager.Instance:ShowWindow('panelJoinRoom')
            end
        end
    end
end

function this.enterRoom(data)
	local ruleTemp = this.GetPlayRuleByRuleId(data.ruleId)
	if not GpsCheck(ruleTemp) then
		return
	end
	
    local msg = Message.New()
    msg.type = proxy_pb.ENTER_ROOM
    local body = proxy_pb.PEnterRoom();
    body.roomNumber = data.roomNumber
	if UnityEngine.PlayerPrefs.HasKey("longitude") then
		body.longitude = UnityEngine.PlayerPrefs.GetFloat("longitude",0)
		body.latitude = UnityEngine.PlayerPrefs.GetFloat("latitude",0)
	end
    --body.seat= GetUserData(go)
    msg.body = body:SerializeToString();
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.REnterRoom();
        b:ParseFromString(msg.body);
        roomInfo.host       = b.host
        roomInfo.port       = b.port
        roomInfo.token      = b.token
        roomInfo.roomNumber = b.roomNumber
        roomInfo.gameType   = b.gameType
        roomInfo.roomType   = b.roomType
        if b.gameType==proxy_pb.PHZ then
            PanelManager.Instance:ShowWindow('panelInGameLand',gameObject.name)
        elseif b.gameType==proxy_pb.PDK then
            PanelManager.Instance:ShowWindow('panelInGame_pdk',gameObject.name)
	    elseif b.gameType == proxy_pb.MJ then
            PanelManager.Instance:ShowWindow('panelInGamemj',gameObject.name);
	    elseif b.gameType == proxy_pb.XHZD then
            PanelManager.Instance:ShowWindow('panelInGame_xhzd',gameObject.name);
        elseif b.gameType == proxy_pb.DTZ then
            PanelManager.Instance:ShowWindow('panelInGame_dtz', gameObject.name)
        elseif b.gameType == proxy_pb.BBTZ then
            PanelManager.Instance:ShowWindow('panelInGame_bbtz', gameObject.name)
        elseif b.gameType == proxy_pb.XPLP then 
            PanelManager.Instance:ShowWindow('panelInGame_xplp', gameObject.name)
        elseif b.gameType == proxy_pb.HNM and b.roomType == proxy_pb.HNHSM then 
            PanelManager.Instance:ShowWindow('panelInGame_hnhsm', gameObject.name)
        elseif b.gameType == proxy_pb.HNM and b.roomType == proxy_pb.HNZZM then 
            PanelManager.Instance:ShowWindow('panelInGame_hnzzm', gameObject.name)
        elseif b.gameType == proxy_pb.YJQF then
            PanelManager.Instance:ShowWindow('panelInGame_yjqf',gameObject.name)
        end
    end);
    PanelManager.Instance:ShowWindow('panelNetWaitting')
end


function this.isMeInTable()
    return false
end

local SYZP = 0	--邵阳字牌
local SYBP = 1	--邵阳剥皮
local HUAIHUA = 2 --怀化红拐弯
local LDFPF = 6 --娄底放炮罚
local CDPHZ = 7 --常德跑胡子
local CSPHZ = 9 --长沙跑胡子
function this.CreateRoom(data,isPulish)
	local ruleTemp = this.GetPlayRuleByRuleId(data.ruleId)
	if not GpsCheck(ruleTemp) then
		return
	end

    local msg       = Message.New();
    msg.type        = proxy_pb.CREATE_ROOM;
    local body      = proxy_pb.PCreateRoom();
    body.open       = isPulish;
    body.ruleId     = data.ruleId;
    body.gameType   = this.GetGameTyeByPlay(data.playId).gameType;
   -- local settingsJson = json:decode(data.settings);
    msg.body        = body:SerializeToString();
    PanelManager.Instance:ShowWindow("panelNetWaitting");
    SendProxyMessage(msg,function(msg)
        local msgRCreateRoom = proxy_pb.RCreateRoom();
       
        msgRCreateRoom:ParseFromString(msg.body);
        roomInfo.port       = msgRCreateRoom.port;
        roomInfo.host       = msgRCreateRoom.host;
        roomInfo.token      = msgRCreateRoom.token;
        roomInfo.roomNumber = msgRCreateRoom.roomNumber;
        roomInfo.gameType   = msgRCreateRoom.gameType;
        roomInfo.roomType   = msgRCreateRoom.roomType;

        local gameType = msgRCreateRoom.gameType;
        if gameType == proxy_pb.PHZ then 
            PanelManager.Instance:ShowWindow('panelInGameLand',gameObject.name);
        elseif gameType == proxy_pb.PDK then
            PanelManager.Instance:ShowWindow("panelInGame_pdk",gameObject.name);
        elseif gameType == proxy_pb.MJ then
            PanelManager.Instance:ShowWindow('panelInGamemj',gameObject.name);
	    elseif gameType == proxy_pb.XHZD then
            PanelManager.Instance:ShowWindow('panelInGame_xhzd',gameObject.name);
        elseif gameType == proxy_pb.DTZ then
            PanelManager.Instance:ShowWindow('panelInGame_dtz', gameObject.name)
        elseif gameType == proxy_pb.BBTZ then
            PanelManager.Instance:ShowWindow('panelInGame_bbtz', gameObject.name)
        elseif gameType == proxy_pb.XPLP then 
            PanelManager.Instance:ShowWindow('panelInGame_xplp', gameObject.name)
        elseif gameType == proxy_pb.HNM and roomInfo.roomType == proxy_pb.HNHSM then 
            PanelManager.Instance:ShowWindow('panelInGame_hnhsm', gameObject.name)
        elseif gameType == proxy_pb.HNM and roomInfo.roomType == proxy_pb.HNZZM then 
            PanelManager.Instance:ShowWindow('panelInGame_hnzzm', gameObject.name)
        elseif gameType == proxy_pb.YJQF then
            PanelManager.Instance:ShowWindow('panelInGame_yjqf',gameObject.name)
        end
    end
    );
    
end

function this.OnQuickMatchResult(msg)
    if panelInGame and panelInGame.fanHuiRoomNumber then
        panelMessageBox.SetParamers(ONLY_OK, this.OnClickButtonToRoom, nil, '您已经加入了一个房间，不可重复加入', '返回房间')
        PanelManager.Instance:ShowWindow('panelMessageBox')
    else
        QuickMatch(msg)
    end
end

function this.OnClickButtonToRoom()
    AudioManager.Instance:PlayAudio('btn')
    if panelInGame then
        panelInGame.SetMyAlpha(1)
    end
    if roomInfo.gameType==proxy_pb.PHZ then
        PanelManager.Instance:ShowWindow('panelInGameLand',gameObject.name)
    elseif roomInfo.gameType==proxy_pb.PDK then
        PanelManager.Instance:ShowWindow('panelInGame_pdk',gameObject.name)
    elseif roomInfo.gameType == proxy_pb.MJ then
        PanelManager.Instance:ShowWindow('panelInGamemj',gameObject.name)
    elseif roomInfo.gameType == proxy_pb.XHZD then
        PanelManager.Instance:ShowWindow('panelInGame_xhzd',gameObject.name)
    elseif roomInfo.gameType == proxy_pb.DTZ then
        PanelManager.Instance:ShowWindow('panelInGame_dtz',gameObject.name)
    elseif roomInfo.gameType == proxy_pb.BBTZ then
        PanelManager.Instance:ShowWindow('panelInGame_bbtz',gameObject.name)
    elseif roomInfo.gameType == proxy_pb.XPLP then
        PanelManager.Instance:ShowWindow('panelInGame_xplp',gameObject.name)
    elseif roomInfo.gameType == proxy_pb.HNM and roomInfo.roomType == proxy_pb.HNHSM then
        PanelManager.Instance:ShowWindow('panelInGame_hnhsm',gameObject.name)
    elseif roomInfo.gameType == proxy_pb.HNM and roomInfo.roomType == proxy_pb.HNZZM then
        PanelManager.Instance:ShowWindow('panelInGame_hnzzm',gameObject.name)
    elseif roomInfo.gameType == proxy_pb.YJQF then
        PanelManager.Instance:ShowWindow('panelInGame_yjqf',gameObject.name)
    end
end

function this.GetTabel()
    return DesksCollectionGrid.transform:GetChild(0);
end

function this.GetPlays()
    return gameObject.transform:Find('WanFaToggle');
end

function this.CloseClubListView()
    ClubListView.gameObject:SetActive(false)
end

local NewMessages = {}
local IsShowNewMessage = false;

function this.InsertAllDeductMessages(scoreMsgs)
    if scoreMsgs == nil or #scoreMsgs==0 then
        return 
    end

    for i = 1, #scoreMsgs do
        table.insert(NewMessages, scoreMsgs[i])
    end
    this.InsertDeductMessage(scoreMsgs[1])
end

function this.OnDeductFeeNotice(msg)
    local body = proxy_pb.RDeductScoreMessage()
    body:ParseFromString(msg.body)

    if not PanelManager.Instance:IsActive(gameObject.name) then
        return 
    end
    table.insert(NewMessages, body)
    this.InsertDeductMessage(body)
end

function this.InsertDeductMessage(data)
    if not PanelManager.Instance:IsActive('panelMessageBoxTiShi') then
        this.ShowMessage(this.GetMessageData())
    end
end

function this.ShowMessage(data)
    IsShowNewMessage = true
    local str = '疲劳值扣除提示'..
                '\n时间：'..os.date('%Y-%m-%d %H:%M:%S', data.time)..
                '\n操作人：'..data.operatorName..
                '\n扣除数量：'..data.score..'疲劳值'..
                '\n请您在下方【群名片】中查看剩余疲劳值'
    panelMessageBoxTiShi.SetParamers(ONLY_OK, function ()
        --this.SetFeeNotice(data.messageId, true, true)
        this.CheckNewMessages()
    end, nil, str, '知道了', '拒绝', 14, function ()
        this.CheckNewMessages()
    end)
    
    this.ReadMessage(data.messageId)
    PanelManager.Instance:HideWindow('panelMessageBoxTiShi')
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.CheckNewMessages()
    if #NewMessages ~= 0 then
        this.ShowMessage(this.GetMessageData())
    else
        IsShowNewMessage = false
    end
end

function this.GetMessageData()
    local data = NewMessages[1]
    table.remove(NewMessages, 1)
    return data
end

function this.SetFeeNotice(messageId, isTrue, isMsg, func)
    local msg = Message.New();
    msg.type = proxy_pb.SCORE_MESSAGE_AUDIT;
    local body = proxy_pb.PScoreMessageAudit()
    body.messageId = messageId
    body.result = isTrue
    body.isMsg = isMsg
    body.clubId = panelClub.clubInfo.clubId
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RResult();
		b:ParseFromString(msg.body);
		if b.code == 1 and func ~= nil then
            func()
        end
    end)
end

function this.ClearMessage()
    NewMessages = {}
end

function this.GetGameTyeByPlay(playId)
    for i = 1, #this.clubInfo.plays do
        if this.clubInfo.plays[i].playId == playId then
            return this.clubInfo.plays[i]
        end
    end
end

function this.HideNewMessage()
    buttonMessage:Find('dian').gameObject:SetActive(false);
end

function this.ReadMessage(id, func)
	local msg = Message.New()
	msg.type = proxy_pb.READ_MESSAGE;
	local body=proxy_pb.PReadMessage()
	body.clubId = panelClub.clubInfo.clubId
	body.messageId = id
    msg.body = body:SerializeToString()
	SendProxyMessage(msg, function (msg)
		local b = proxy_pb.RResult();
		b:ParseFromString(msg.body);
		if b.code == 1 and func ~= nil  then
			func()
			this.SubtractMsgCount(1)
		end
	end)
end

function this.ShowClubGuide()
    if #this.clubInfo.plays >= 1 and isNewCreateClub then
        PanelManager.Instance:ShowWindow('panelGuide', 'Club')
    end
end

function this.CurClubIsNewCreate()
    return isNewCreateClub == true
end


function this.HideReplayWindows()
    PanelManager.Instance:HideWindow("panelReplay_dtz")
    PanelManager.Instance:HideWindow("panelReplay_mj")
    PanelManager.Instance:HideWindow("panelReplay_pdk")
    PanelManager.Instance:HideWindow("panelReplay")
    PanelManager.Instance:HideWindow("panelReplay_xhzd")
    PanelManager.Instance:HideWindow("panelReplay_yjqf")
end

function this.OnClickButtonRank(go)
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:ShowWindow('panelRank')
end