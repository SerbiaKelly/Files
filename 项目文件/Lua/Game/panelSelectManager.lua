panelSelectManager = {}
local this=panelSelectManager

local message
local gameObject

local ScrollView
local MemberPrefab
local NoData
local SelectTypeBtn
local TypePanel
local TypeGrid
local MaskBtn

local managerPage       = 1;
local managerPageSize   = 20;
local IsInBottom        = false
local isSendedRequest   = false;
local managerIndex      = 0;
local managerScrollBar  = nil;

local currentManagerType = nil;

local ManagerIndexObjData       = {};

local searchPlayerID
function this.Awake(go)
    gameObject          = go
    message             = gameObject:GetComponent('LuaBehaviour');

    ScrollView          = gameObject.transform:Find('MemberList/Scroll View')
    MemberPrefab        = gameObject.transform:Find('MemberList/Item')
    NoData              = gameObject.transform:Find('MemberList/NoData')
    SelectTypeBtn       = gameObject.transform:Find('SelectTypeBtn')
    TypePanel           = gameObject.transform:Find('TypePanel')
    TypeGrid            = TypePanel.transform:Find('Scroll View/Grid')
    MaskBtn             = gameObject.transform:Find('TypePanel/MaskBtn')
    managerScrollBar    = gameObject.transform:Find("MemberList/Scroll Bar"):GetComponent("UIScrollBar");

    message:AddClick(gameObject.transform:Find('ButtonSearch').gameObject, function ()
        IsInBottom          = false
        managerPage         = 1
        managerIndex        = 0
        ManagerIndexObjData = {}
        TypePanel.gameObject:SetActive(false)
        this.GetManagerList(currentManagerType)
    end)

    for i = 0, TypeGrid.transform.childCount - 1 do
        message:AddClick(TypeGrid.transform:GetChild(i).gameObject, this.OnClickTypeBtn)
    end
    searchPlayerID = gameObject.transform:Find('PlayerSearch'):GetComponent('UILabel')
    message:AddClick(gameObject.transform:Find('BaseContent/ButtonClose').gameObject, this.Close)
    message:AddClick(SelectTypeBtn.gameObject, this.OnClickSelectTypeBtn)
    message:AddClick(MaskBtn.gameObject, this.OnClickSelectTypeBtn)

    gameObject.transform:Find("MemberList/Scroll View"):GetComponent("UIScrollView").onDragFinished = this.OnManagerRequestNextPage;

end

function this.Close(go)
    --print('close')
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.Update()
   
end

function this.Start()

end

local selFunc
local assign = true
function this.WhoShow(data)
    selFunc = nil
    assign = data.assign == true
    selFunc = data.func

    
end

function this.OnEnable()
    IsInBottom = false;
    local types = this.GetType(panelClub.clubInfo.userType)
    currentManagerType = types[1];

    searchPlayerID.text = '请输入玩家ID'
    isSendedRequest   = false;
    managerIndex      = 0;
    ManagerIndexObjData = {};

    this.GetManagerList(types[1])

    for i = 0, TypeGrid.transform.childCount - 1 do
        local obj = TypeGrid.transform:GetChild(i)
        obj.gameObject:SetActive(false)
    end

    TypeGrid.transform.parent:GetComponent('UIScrollView'):ResetPosition()
    TypeGrid.transform:GetComponent('UIGrid').repositionNow = true
    for i = 1, #types do
        if proxy_pb.MANAGER == types[i] then
            TypeGrid.transform:Find('MANAGER').gameObject:SetActive(true)
        elseif proxy_pb.VICE_MANAGER == types[i] then
            TypeGrid.transform:Find('VICE_MANAGER').gameObject:SetActive(true)
        elseif proxy_pb.ASSISTANT == types[i] then
            TypeGrid.transform:Find('ASSISTANT').gameObject:SetActive(true)
        elseif proxy_pb.PRESIDENT == types[i] then
            TypeGrid.transform:Find("PRESIDENT").gameObject:SetActive(true);
        elseif proxy_pb.VICE_PRESIDENT == types[i] then
            TypeGrid.transform:Find("VICE_PRESIDENT").gameObject:SetActive(true);
        end
    end
    TypeGrid.transform:GetComponent('UIGrid'):Reposition()
    SelectTypeBtn.transform.gameObject:SetActive(panelClub.clubInfo.gameMode)
    SelectTypeBtn.transform:Find('Label'):GetComponent('UILabel').text = this.GetTypeString(types[1])
end

function this.GetType(userType)
    local userTypes = {}
    userTypes[proxy_pb.LORD]            = {proxy_pb.MANAGER,        proxy_pb.VICE_MANAGER,  proxy_pb.ASSISTANT,         proxy_pb.PRESIDENT,         proxy_pb.VICE_PRESIDENT}
    userTypes[proxy_pb.MANAGER]         = {proxy_pb.VICE_MANAGER,   proxy_pb.ASSISTANT,     proxy_pb.PRESIDENT,         proxy_pb.VICE_PRESIDENT}
    userTypes[proxy_pb.VICE_MANAGER]    = {proxy_pb.ASSISTANT,      proxy_pb.PRESIDENT,     proxy_pb.VICE_PRESIDENT}
    userTypes[proxy_pb.ASSISTANT]       = {proxy_pb.PRESIDENT,      proxy_pb.VICE_PRESIDENT}
    userTypes[proxy_pb.PRESIDENT]       = {proxy_pb.VICE_PRESIDENT}


    return userTypes[userType]
end

function this.GetTypeString(userType)
    local userTypes = {}
    userTypes[proxy_pb.GENERAL]         = '玩家'
    userTypes[proxy_pb.MANAGER]         = '管理员'
    userTypes[proxy_pb.LORD]            = '群主'
    userTypes[proxy_pb.VICE_MANAGER]    = '馆长'
    userTypes[proxy_pb.ASSISTANT]       = '副馆长'
    userTypes[proxy_pb.PRESIDENT]       = '会长'
    userTypes[proxy_pb.VICE_PRESIDENT]  = '副会长'

    return userTypes[userType]
end

function this.GetManagerList(type)
    local userId = ''
    if (searchPlayerID.text ~= '' and searchPlayerID.text ~= nil ) then
        if (string.match(searchPlayerID.text,"^[+-]?%d+$") == searchPlayerID.text) then
            userId = searchPlayerID.text
        elseif searchPlayerID.text == '请输入玩家ID' then  
            userId = ''
        else
            panelMessageTip.SetParamers('请输入正确的ID', 1.5)
            PanelManager.Instance:ShowWindow('panelMessageTip')
            return
        end
    end
    local msg       = Message.New()
    msg.type        = proxy_pb.MANAGER_LIST
    local body      = proxy_pb.PManagerList()
    body.clubId     = panelClub.clubInfo.clubId
    body.userType   = type
    body.assign     = true--panelClub.clubInfo.userType == proxy_pb.LORD and true or false;
    body.page       = managerPage;
    body.pageSize   = managerPageSize;
    body.userId = userId

    print("requst page:"..body.page);
    print("requst pageSize:"..body.pageSize);
    msg.body        = body:SerializeToString()

    print('请求的身份：'..tostring(body.userType))

    isSendedRequest = true;
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RManagerList()
        b:ParseFromString(msg.body)
        isSendedRequest = false;
        if b.manager ~= nil and #b.manager ~= 0 then
            NoData.gameObject:SetActive(false);
            Util.ClearChild(ScrollView:Find('Grid'));

            for i = 1, #b.manager do
                local managerData = {index = 0,data = nil};
                managerIndex = managerIndex + 1;
                managerData.index = managerIndex;
                managerData.data = b.manager[i];
                table.insert(ManagerIndexObjData,managerData);
            end

            this.InitListView(ManagerIndexObjData);
            IsInBottom = #b.manager < managerPageSize;
        else
            if #ManagerIndexObjData==0 then
                Util.ClearChild(ScrollView:Find('Grid'));
                NoData.gameObject:SetActive(true);
            end
            IsInBottom = true;

        end
    end)
end



function this.InitListView(datas)

    local Grid = ScrollView:Find('Grid')
    for i = 1, #datas do
        local obj = NGUITools.AddChild(Grid.gameObject, MemberPrefab.gameObject).transform
        SetUserData(obj.gameObject, datas[i].data)
        obj.gameObject:SetActive(true)

        local player = obj:Find('payer')
        player.transform:Find('id'):GetComponent('UILabel').text='id:'..datas[i].data.userId
        player.transform:Find('name'):GetComponent('UILabel').text=datas[i].data.nickname
        obj:Find('num'):GetComponent('UILabel').text = datas[i].data.memberSize
        obj:Find('bianHao'):GetComponent('UILabel').text = i
        coroutine.start(LoadPlayerIcon, player:Find('tx'):GetComponent('UITexture'), datas[i].data.icon)

        message:AddClick(obj:Find('ButtonSelct').gameObject, this.OnClickSelct)
    end

    Grid:GetComponent('UIGrid'):Reposition()
    --ScrollView:GetComponent('UIScrollView'):ResetPosition()
    if managerPage >1 then
    else
        ScrollView:GetComponent('UIScrollView'):ResetPosition();
    end
end

function this.OnClickSelct(go)
    local userdata=GetUserData(go.transform.parent.gameObject)

    if selFunc then
        selFunc(userdata)
    end

    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickSelectTypeBtn(go)
    AudioManager.Instance:PlayAudio('btn')
    TypePanel.gameObject:SetActive(not TypePanel.gameObject.activeSelf)
end

function this.OnClickTypeBtn(go)
    local type = 0

    if 'MANAGER' == go.name then
        type = proxy_pb.MANAGER
    elseif 'VICE_MANAGER' == go.name then
        type = proxy_pb.VICE_MANAGER
    elseif 'ASSISTANT' == go.name then
        type = proxy_pb.ASSISTANT
    elseif  go.name == "PRESIDENT" then
        type = proxy_pb.PRESIDENT;
    elseif go.name == "VICE_PRESIDENT" then
        type = proxy_pb.VICE_PRESIDENT;
    end

    currentManagerType  = type;
    IsInBottom          = false;
    managerPage         = 1;
    managerIndex        = 0;
    ManagerIndexObjData = {};

    SelectTypeBtn.transform:Find('Label'):GetComponent('UILabel').text = this.GetTypeString(type)
    this.OnClickSelectTypeBtn(go)
    this.GetManagerList(type)

end

function this.OnManagerRequestNextPage()
    --print("OnManagerRequestNextPage was called,value:"..managerScrollBar.value);
    --我们往上拖拽才拉取，不用考虑往下拖拽的情况了
    if (not isSendedRequest and managerScrollBar.value >=1) then
        --print("request page manager------------> IsResetData:"..tostring(IsInBottom));
        if not IsInBottom then
            managerPage = managerPage + 1;
            this.GetManagerList(currentManagerType);
        else
            panelMessageTip.SetParamers('没有更多了', 1)
            PanelManager.Instance:ShowWindow('panelMessageTip')
        end
    --elseif not isSendedRequest and  managerScrollBar.value <=0 then
    --    if managerPage > 1 then
    --        managerPage = managerPage - 1;
    --
    --        this.GetManagerList(currentManagerType);
    --    else
    --        panelMessageTip.SetParamers('没有更多了', 1)
    --        PanelManager.Instance:ShowWindow('panelMessageTip')
    --    end
    end

end