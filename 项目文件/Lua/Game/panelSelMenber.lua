panelSelMenber = {}
local this = panelSelMenber
this.dictionary={}--id  昵称 键值对

local ScrollView
local searchTitle


local message
local gameObject
local loginTimeButton
function this.Awake(go)
    gameObject = go
    message = gameObject:GetComponent('LuaBehaviour');  
    ScrollView = gameObject.transform:Find('Menbers/Scroll View')
    searchTitle = gameObject.transform:Find('input')
    loginTimeButton = gameObject.transform:Find('Top/LoginTime')
    message:AddClick(searchTitle.gameObject, function (go)
        PanelManager.Instance:ShowWindow('keyborad', gameObject.name)
    end)
    message:AddClick(gameObject.transform:Find('BaseContent/ButtonClose').gameObject, function (go)
        PanelManager.Instance:HideWindow(gameObject.name)
    end)
    message:AddClick(loginTimeButton.gameObject, this.OnTimeSort)
end

function this.Update()
   
end
function this.Start()

end

local selFunc
local MemberList

local MenberObjData ={}
local CopyMenberData = {}
function this.WhoShow(data)
    selFunc = nil
    MemberList = nil
    selFunc = data.func
    MemberList = data.MemberList

    MenberObjData = {}
    CopyMenberData = {}

    this.refresh()
end

function this.refresh()
    local Index = 1;
    local itemPrefab = gameObject.transform:Find('Item')
    local Grid = ScrollView:Find('Grid');
    Util.ClearChild(Grid)
    for i = 1, #MemberList do
        if MemberList[i].status ~= 0 then
            this.dictionary[MemberList[i].userId]=MemberList[i].nickname

            local obj = NGUITools.AddChild(Grid.gameObject, itemPrefab.gameObject)
            obj.gameObject:SetActive(true)
            SetUserData(obj.gameObject, MemberList[i])
            local player = obj.transform:Find('payer')

            local isManager = proxy_pb.MANAGER == panelClub.clubInfo.userType
            local userid = IsCanOperatingMenber() and MemberList[i].userId or string.sub (MemberList[i].userId, 1,4).."***"
            if (MemberList[i].userId == info_login.id) or (isManager and MemberList[i].managerId == info_login.id)  then
                userid = MemberList[i].userId
            end

            player:Find('id'):GetComponent('UILabel').text = "ID:"..userid
            player:Find('name'):GetComponent('UILabel').text = MemberList[i].nickname
            coroutine.start(LoadPlayerIcon, player:Find('tx'):GetComponent('UITexture'), MemberList[i].icon)
            obj.transform:Find('bianHao'):GetComponent('UILabel').text = Index
            Index = Index + 1

            player:Find('State'):GetChild(MemberList[i].userType + 1).gameObject:SetActive(true)

            if MemberList[i].status == 3 then
                obj.transform:Find('time'):GetComponent('UILabel').text = '游戏中'
            elseif MemberList[i].status == 2 then
                obj.transform:Find('time'):GetComponent('UILabel').text = '空闲'
            elseif MemberList[i].status == 1 then
                obj.transform:Find('time'):GetComponent('UILabel').text = GetLastActive(os.time(), MemberList[i].time)
            end

            local manager = obj.transform:Find('manager')
            if MemberList[i].managerId ~= nil and MemberList[i].managerId ~= '' then
                local managerid = (MemberList[i].managerId == info_login.id or proxy_pb.LORD == panelClub.clubInfo.userType or IsCanOperatingMenber() ) and MemberList[i].managerId or  string.sub (MemberList[i].managerId, 1,4).."***"
                manager:Find('id'):GetComponent('UILabel').text = 'ID:'..managerid
                manager:Find('name'):GetComponent('UILabel').text = MemberList[i].managerNickname
                coroutine.start(LoadPlayerIcon, manager:Find('tx'):GetComponent('UITexture'), MemberList[i].managerIcon)
            else
                if proxy_pb.MANAGER == MemberList[i].userType then
                    local managerId = (MemberList[i].managerId == info_login.id or proxy_pb.LORD == panelClub.clubInfo.userType or IsCanOperatingMenber() ) and panelClub.clubInfo.lordId or  string.sub (panelClub.clubInfo.lordId, 1,4).."***"
                    manager:Find('id'):GetComponent('UILabel').text = 'ID:'..managerId
                    manager:Find('name'):GetComponent('UILabel').text = panelClub.clubInfo.lordNickname
                    coroutine.start(LoadPlayerIcon, manager:Find('tx'):GetComponent('UITexture'), panelClub.clubInfo.clubLeaderIcon)
                else
                    manager.gameObject:SetActive(false)
                end
            end

            message:AddClick(obj.transform:Find('SelButton').gameObject, this.OnClickSelct)

            table.insert(MenberObjData, obj)
            table.insert(CopyMenberData, MemberList[i])
            obj.transform.localPosition = Vector3(0, -10 * i, 0)
        end
    end

    Grid:GetComponent('UIGrid'):Reposition()
end

function this.OnClickSelct(go)
    local userdata=GetUserData(go.transform.parent.gameObject)
    selFunc(userdata.userId)
    
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.setSearchInput(strNum)
    local Grid = ScrollView:Find('Grid');
    for i = 0, Grid.transform.childCount - 1 do
        local obj = Grid.transform:GetChild(i)
        local data = GetUserData(obj.gameObject)
        if string.find(data.userId,strNum)==nil then
            obj.gameObject:SetActive(false)
        else
            obj.gameObject:SetActive(true)
        end
    end
    searchTitle.transform:GetComponent('UILabel').text = strNum
    Grid:GetComponent('UIGrid').repositionNow = true
    Grid:GetComponent('UIGrid'):Reposition()
end

function this.OnTimeSort(go)
    local As = go.transform:Find(1);
    local Ds = go.transform:Find(-1);

    local sort
    if As.gameObject.activeSelf then
        sort = tonumber(Ds.gameObject.name) 
        Ds.gameObject:SetActive(true)
        As.gameObject:SetActive(false)
    else
        sort = tonumber(As.gameObject.name) 
        As.gameObject:SetActive(true)
        Ds.gameObject:SetActive(false)
    end

    
    for i=1, #MenberObjData do
        MenberObjData[i].transform.localPosition = Vector3(0, -(CopyMenberData[i].time / 10000) * sort, 0)
    end

    ScrollView:Find('Grid'):GetComponent('UIGrid'):Reposition()
    ScrollView:GetComponent('UIScrollView'):ResetPosition()
end