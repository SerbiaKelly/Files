ClubLogic = {} 
local this = ClubLogic

local members = {}

local curClubId
local curPageIndex
local curPageSize

local function SetMembers(index, pageSize, datas, totalCount)

    local difference = totalCount - #members
    if difference < 0 then
        local startIndex = totalCount + 1
        local NeedClearCount = -1 * difference + totalCount
        for i = NeedClearCount, startIndex, -1 do
            table.remove(members, i)
        end
    end

    for i = 1, #datas do
        members[(index - 1) * pageSize + i] = datas[i]
    end

    return members
end

function this.InitMember(clubId, pageSize, func)
    members = {}
    curClubId = clubId
    curPageSize = pageSize
    curPageIndex = 0
    this.GetMembers(1, false, nil, nil, function (members, onlineNum, count)
        if func then
            func(members, onlineNum, count)
        end
    end)
end

--刷新指定page下的成员  如果上次和的出现的page一样就不会像服务器请求
function this.GetMembers(index, myChild, managerId, memberId, func)
    print("curPageIndex", curPageIndex)
    if curPageIndex == index then
        return
    end
    this.GetMembersForce(index, myChild, managerId, memberId, func)
end

function this.GetMembersForce(index, myChild, managerId, memberId, func)
    curPageIndex = index
    local msg = this.GetMessaageHead(proxy_pb.CLUB_USER_LIST)
    local body = proxy_pb.PClubUserList()
    body.clubId = curClubId
    body.page = index
    body.pageSize = curPageSize
    body.myChild = myChild == true
    if managerId ~= nil and managerId ~= '' then
        body.managerId = managerId
    end
    if memberId ~= nil and memberId ~= '' then
        body.userId = memberId
    end

    msg.body = body:SerializeToString()
    print('拉取成员：', curClubId, index, curPageSize, tostring(myChild), tostring(managerId), tostring(memberId))
    SendProxyMessage(msg, function (msg)
        local body = proxy_pb.RClubUserList()
        body:ParseFromString(msg.body)
        local members = SetMembers(index, curPageSize, body.users, body.count)
        if func then
            func(members)
        end
    end)
end

function this.GetMessaageHead(operationCode)
    local msg = Message.New()
    msg.type = operationCode

    return msg
end

local userType = {}
userType[proxy_pb.GENERAL]          = "玩家"
userType[proxy_pb.ASSISTANT]        = '副馆长'
userType[proxy_pb.VICE_MANAGER]     = "馆长"
userType[proxy_pb.MANAGER]          = '管理员'
userType[proxy_pb.LORD]             = '群主'
userType[proxy_pb.PRESIDENT]        = '会长'
userType[proxy_pb.VICE_PRESIDENT]   = '副会长'

function this.GetUserTypeString(type)
    return userType[type]
end