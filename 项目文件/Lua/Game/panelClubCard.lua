panelClubCard = {};
local this = panelClubCard;

local message;
local gameObject;

local ClubInfo = {}
local PlayerInfo = {}

local RecordGrid
local NoRecordDataText

local myInfo={}

function this.Awake(obj)
    gameObject = obj
    message = gameObject:GetComponent('LuaBehaviour');
    
    ClubInfo.ClubName = gameObject.transform:Find('ClubInfo/ClubName'):GetComponent('UILabel')
    ClubInfo.LordID = gameObject.transform:Find('ClubInfo/ClubID/Label'):GetComponent('UILabel')
    ClubInfo.LordName = gameObject.transform:Find('ClubInfo/LordName/Label'):GetComponent('UILabel')

    PlayerInfo.Icon = gameObject.transform:Find('PlayInfo/Icon'):GetComponent('UITexture')
    PlayerInfo.Name = gameObject.transform:Find('PlayInfo/Name/Label'):GetComponent('UILabel')
    PlayerInfo.UserID = gameObject.transform:Find('PlayInfo/ID/Label'):GetComponent('UILabel')
    PlayerInfo.FeeBalance = gameObject.transform:Find('PlayInfo/feeBalance/Label'):GetComponent('UILabel')

    RecordGrid = gameObject.transform:Find('Records/Scroll View/Grid')
    NoRecordDataText = gameObject.transform:Find('Records/NoData')

    message:AddClick(gameObject.transform:Find('copyLinkButton').gameObject, this.OnClickcopyLinkButton)
    message:AddClick(gameObject.transform:Find('ButtonClose').gameObject, this.OnClickClose)
    message:AddClick(gameObject.transform:Find('btnGrid/InviteButton').gameObject, this.OnClickshareCardButton)
    message:AddClick(gameObject.transform:Find('btnGrid/DataStatisticsBtn').gameObject, this.OnClickDataStatisticsButton)
    message:AddClick(gameObject.transform:Find('PlayInfo/Details').gameObject, this.OnClickDetailsBtn)

    message:AddClick(gameObject.transform:Find('GiveSettigBtn').gameObject, this.OnClickGiveSettigBtn)
end

function this.WhoShow(data)
    ClubInfo.ClubName.text = data.clubName;
    ClubInfo.LordID.text = data.clubID;
    ClubInfo.LordName.text = data.lordNickname;
    --coroutine.start(LoadPlayerIcon, leaderIcon, data.clubLeaderIcon);
end

function this.Start()

end

function this.Update()

end

function this.OnEnable()
    PlayerInfo.Name.text = info_login.nickname
    PlayerInfo.UserID.text = info_login.id
    coroutine.start(LoadPlayerIcon, PlayerInfo.Icon, info_login.icon)
    this.getInfo(info_login.id, function (msg)
        local b = proxy_pb.RMyInfoCard();
        b:ParseFromString(msg.body);
        PlayerInfo.FeeBalance.text = b.feeBalance
        myInfo = b
    end)
    this.GetRecords()
    gameObject.transform:Find('btnGrid/InviteButton').gameObject:SetActive(panelClub.clubInfo.userType ~= proxy_pb.GENERAL)
    gameObject.transform:Find('btnGrid/DataStatisticsBtn').gameObject:SetActive(panelClub.clubInfo.userType ~= proxy_pb.VICE_PRESIDENT and panelClub.clubInfo.userType ~= proxy_pb.GENERAL and panelClub.clubInfo.gameMode)
    gameObject.transform:Find('btnGrid'):GetComponent('UIGrid'):Reposition()
    gameObject.transform:Find('GiveSettigBtn').gameObject:SetActive(panelClub.clubInfo.userType ~= proxy_pb.GENERAL and panelClub.clubInfo.gameMode)
end


function this.OnClickcopyLinkButton(obj)
    AudioManager.Instance:PlayAudio('btn');
    print("OnClickcopyLinkButton was called");
    --http://zj.17hiya.net
    Util.CopyToSystemClipbrd("http://zj.17hiya.net");
    panelMessageTip.SetParamers('复制成功', 1.5);
	PanelManager.Instance:ShowWindow('panelMessageTip');
end

function this.OnClickClose(obj)
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name);
end

function this.OnClickshareCardButton(obj)
    -- print("OnClickshareCardButton was called");
    -- PlatformManager.Instance:ShareScreenshot('群名片分享',false,0);
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
	local data = {}
    data.index = 5
    data.playerIDFuFeeValue = 0
    PanelManager.Instance:ShowWindow('panelMenber', data)
end

function this.OnClickDataStatisticsButton(go)
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:ShowWindow('panelDataStatistics')
end
function this.OnClickGiveSettigBtn(go)
    AudioManager.Instance:PlayAudio('btn')
    if myInfo.operatorFeePrecent ~= 0 then
        panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '您的分配比已启用，需要归零后才能使用赠送设置')
        PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
        return
    end
    if myInfo.feePrecent ~= 0 then
        panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '您与【'..myInfo.nickname..'】的疲劳值分配比不为0%，通过修改权限，设置为0%后，才能进行赠送设置')
        PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
        return
    end
    PanelManager.Instance:ShowWindow('panelGiveSetting', myInfo)
end
function this.OnClickDetailsBtn(go)

    -- if panelClub.clubInfo.gameMode then
    --     panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
    --         PlatformManager.Instance:ShareLink('http://zj.17hiya.net', '嗨皮湖南棋牌', '群战绩中心', 0)
    --     end, nil, '请通过战绩链接中心查看  链接地址：http://zj.17hiya.net')
    --     PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
    --     return 
    -- end

    if panelClub.clubInfo.gameMode then
        PanelManager.Instance:ShowWindow('panelMatchFeeBillRecord', 
            {pageIndex = 2, userId = info_login.id, nickname = info_login.nickname, icon = info_login.icon, userType = panelClub.clubInfo.userType,isShowGiveFatigue = panelClub.clubInfo.userType ~= proxy_pb.LORD})
        
        PanelManager.Instance:HideWindow(gameObject.name)
        return 
    end

    local shuju={}
    shuju.data = {userId = info_login.id, nickname = info_login.nickname}
    shuju.GO=go
    shuju.ShowName = gameObject.name
    PanelManager.Instance:ShowWindow('panelFeeBillRecord',shuju)
end

function this.getInfo(userId, func)
    local msg = Message.New()
    msg.type = proxy_pb.MY_INFO_CARD
    local body = proxy_pb.PMyInfoCard()
    body.userId = userId
    body.clubId = panelClub.clubInfo.clubId
    print('拉取用户名片id：'..body.userId..", 俱乐部id："..body.clubId)
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, func)
end


function this.GetRecords()
    local msg = Message.New()
    msg.type = proxy_pb.MY_STANDINGS_STATISTICS
    local body = proxy_pb.PMyStandingsStatistics()
    body.clubId = panelClub.clubInfo.clubId
    msg.body = body:SerializeToString()
    PanelManager.Instance:ShowWindow('panelNetWaitting')
    SendProxyMessage(msg, function (data)
        local b = proxy_pb.RMyStandingsStatistics();
        b:ParseFromString(data.body);
        PanelManager.Instance:HideWindow('panelNetWaitting')
        this.RefreshRecords(b.datas)
    end)
    --RMyStandingsStatistics
end

function this.RefreshRecords(records)

    print('records count:'..#records)
    local NeedCount = #records - RecordGrid.transform.childCount
    local StartIndex = #records
    local EndIndex = (-NeedCount + StartIndex) - 1
    print('StartIndex:'..StartIndex..' EndIndex:'..EndIndex..' NeedCount:'..NeedCount)
    for i= StartIndex, EndIndex do
        local obj = RecordGrid.transform:GetChild(i)
        obj.gameObject:SetActive(false)
    end

    --print_r(records)

    if(#records <= 0)then
        NoRecordDataText.gameObject:SetActive(true)
        RecordGrid.transform.parent.gameObject:SetActive(false)
        return 
    end

    RecordGrid.transform.parent.gameObject:SetActive(true)

    for i=1, #records do
        print('time:'..records[i].time)
        print('score:'..records[i].score)
        local obj = RecordGrid.transform:GetChild(i - 1)
        obj.gameObject:SetActive(true)
        obj.transform:Find('Time'):GetComponent('UILabel').text = os.date('%m-%d',records[i].time) 
        obj.transform:Find('Total'):GetComponent('UILabel').text = records[i].count
        obj.transform:Find('Grade'):GetComponent('UILabel').text = records[i].score
        obj.transform:Find('Fee'):GetComponent('UILabel').text = records[i].fee
    end

    RecordGrid.transform.parent:GetComponent('UIScrollView'):ResetPosition()
end