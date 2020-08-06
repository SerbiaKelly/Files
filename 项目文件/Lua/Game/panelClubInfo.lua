local json = require 'json'

panelClubInfo = {}
local this = panelClubInfo

local message
local gameObject

local buttonCopy
local buttonClose
local StartMatchButton
local CancelButton
local ConfirmButton

local toggle1
local toggle2
local toggle3

local clubInfo

function this.Awake(go)
    gameObject = go
    message = gameObject:GetComponent('LuaBehaviour')

    clubInfo = gameObject.transform:Find('scrollView/grid')

    buttonCopy = gameObject.transform:Find('ButtonCopy')
    buttonClose = gameObject.transform:Find('ButtonClose')
    StartMatchButton = clubInfo:Find('StartMatchButton')

    toggle1 = clubInfo:Find('1or2or3/1')
    toggle2 = clubInfo:Find('1or2or3/2')
    toggle3 = clubInfo:Find('1or2or3/3')

    CancelButton = gameObject.transform:Find('CancelButton')
    ConfirmButton = gameObject.transform:Find('ConfirmButton')

    message:AddClick(buttonCopy.gameObject, function (go)
        AudioManager.Instance:PlayAudio('btn')
        local copyString = '牌友群：'..panelClub.clubInfo.name..'\n'..'牌友群ID：'..panelClub.clubInfo.clubId
        Util.CopyToSystemClipbrd(copyString)
        panelMessageTip.SetParamers('复制成功', 1.5)
        PanelManager.Instance:ShowWindow('panelMessageTip')
    end)

    message:AddClick(buttonClose.gameObject, this.OnClickClose)
    message:AddClick(CancelButton.gameObject, this.OnClickClose)
    message:AddClick(ConfirmButton.gameObject, this.OnClickConfirm)
    message:AddClick(StartMatchButton.gameObject, this.OnClickStartMatch)
end

function this.OnEnable()
    clubInfo.transform:Find('ClubName/Label'):GetComponent('UILabel').text = panelClub.clubInfo.name
    clubInfo.transform:Find('ClubID/Label'):GetComponent('UILabel').text = panelClub.clubInfo.clubId
    clubInfo.transform:Find('ClubCreateTime').gameObject:SetActive(false)
    clubInfo.transform:Find('ClubCreateTime/Label'):GetComponent('UILabel').text = os.date('%Y/%m/%d %X', panelClub.clubInfo.createTime)
    toggle1.parent.gameObject:SetActive(panelClub.clubInfo.userType == proxy_pb.LORD)
    local msg = Message.New()
    msg.type = proxy_pb.CLUB_USER_LIST
    local body = proxy_pb.PClubUserList()
    body.clubId = panelClub.clubInfo.clubId
    body.page = 1
    body.pageSize = 1
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RClubUserList()
        b:ParseFromString(msg.body);
        clubInfo.transform:Find('ClubMember/Label'):GetComponent('UILabel').text = b.onlineNum..' / '..b.count
    end)

    StartMatchButton.transform:GetComponent('UIToggle'):Set(panelClub.clubInfo.gameMode)
    toggle1.transform:GetComponent('UIToggle'):Set(not panelClub.clubInfo.showJoinTime)
    toggle2.transform:GetComponent('UIToggle'):Set(not panelClub.clubInfo.showPlayTime)
    toggle3.transform:GetComponent('UIToggle'):Set(not panelClub.clubInfo.showOtherTime)

    ConfirmButton.gameObject:SetActive(panelClub.clubInfo.userType == proxy_pb.LORD)
    CancelButton.gameObject:SetActive(panelClub.clubInfo.userType == proxy_pb.LORD)
    print('userInfo.userType : '..userInfo.userType)
    StartMatchButton.gameObject:SetActive(panelClub.clubInfo.userType == proxy_pb.LORD)-- and userInfo.userType ~= 0)
    clubInfo.transform:Find('ClubMember').gameObject:SetActive(panelClub.clubInfo.userType == proxy_pb.LORD)
    clubInfo:GetComponent('UIGrid'):Reposition()
    clubInfo.parent:GetComponent('UIScrollView'):ResetPosition()
end

function this.OnClickStartMatch(go)
    AudioManager.Instance:PlayAudio('btn')
    local isStarted = go.transform:GetComponent('UIToggle').value
    if not isStarted then
        print('userInfo.userType : '..tostring(userInfo.userType))
        if userInfo.userType == 0 then
            panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '未开通代理，无权限开通比赛场！')
            PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
            return 
        end
        panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
            go.transform:GetComponent('UIToggle'):Set(not isStarted)
        end, nil, '若开启了比赛场模式，则已经产生的玩家的剩余疲劳值将会清零重新开始计算，是否确认开启？')
        PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
        return 
    end
end

function this.OnClickConfirm(go)
    local isStarted = StartMatchButton.transform:GetComponent('UIToggle').value
    this.SetGameMatch(isStarted)
end

function this.SetGameMatch(isStart)
    local msg = Message.New()
    msg.type = proxy_pb.UPDATE_CLUB
    local body = proxy_pb.PUpdateClub()
    body.clubId = panelClub.clubInfo.clubId
    body.gameMode = isStart
    print('是否是开启比赛场：'..tostring(body.gameMode))
    body.showJoinTime = not toggle1.transform:GetComponent('UIToggle').value
    body.showPlayTime = not toggle2.transform:GetComponent('UIToggle').value
    body.showOtherTime = not toggle3.transform:GetComponent('UIToggle').value
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RResult()
        b:ParseFromString(msg.body)
        if b.code == 1 then
            panelMessageTip.SetParamers('修改成功', 1.5)
            PanelManager.Instance:ShowWindow('panelMessageTip')
            PanelManager.Instance:HideWindow(gameObject.name)
        end
    end)
end

function this.OnClickClose(go)
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.Update()
end