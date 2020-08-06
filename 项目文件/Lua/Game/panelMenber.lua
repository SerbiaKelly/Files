require("Lua.Game.Tools.SuperScrollList.InternalGrid")
require("Lua.Game.Tools.SuperScrollList.SuperScrollList")

panelMenber = {}
local this = panelMenber

local message;
local gameObject;

local Toggles = {}
local playerIDFuFeeValue=0
local isMessgeSkip = false
--成员
local MemberList
local MemberListBar
local MemberPrefab
local MeneberPanel
local MenberObjData = {}
local MenberListData
local TimeSortButton
local FatigueSortButton
local MemberSortToggles = {}
local ClearFeeBalanceBtn;
local superScrollList
local MyMemberToggle
local feeMemberToggle
--管家
local ManagerList
local ManagerPrefab
local ManagerPanel
local ManagerTypePanel;
local ManagerData = {}
local ManagerObjData = {}
local SortToggles = {}
local sortManage = 0
local sortManageType = 0

local managerPage               = 1;
local managerPageSize           = 20;
local IsInBottom                = false
local isManagerSendedRequest    = false;
local managerScrollBar          = nil;
local currentManagerType        = nil;
local managerIndex              = 0;
local ManagerIndexObjData       = {};
local ManagerFuFeeAveNum
local ManagerfuFeeValue

local tipMemberNum
local tipFeePrecent
local tipFuFeeMemberNum
local tipFuFeeValue

local BlackList
local BlackListItem
local BlackListPanel
local AddBlackPlayerButton
local AddPlayerInput
local AddBlackPlayerPanel
local CleanFatiguePanel
local FatigueInput
local blackListSystemPlayer
local blackListPlayerSearch
local tishiBlackList
local tishiRoomBlackListGrid
local messageItemBlackList

function this.Awake(go)
    gameObject = go;
    message = gameObject:GetComponent('LuaBehaviour');

    local toggles = gameObject.transform:Find('Toggles')
    for i = 1, 5 do
        local toggle = toggles.transform:Find(i)
        table.insert(Toggles, toggle)
        message:AddClick(toggle.gameObject, this.OnClickChangePanel)
    end

    message:AddClick(gameObject.transform:Find('BaseContent/ButtonClose').gameObject, this.ClosePanel)

    this.InitMeneberPanel()
    this.InitManagerPanel()
    this.InitBlackListPanel()
    this.InitMutexPanel()
    this.InitAddMenberPanel()
end

function this.OnClickChangePanel(go)
    AudioManager.Instance:PlayAudio('btn')
    local index = tonumber(go.name)
    if index == 1 then
        this.GetMenberData(true, true, true,true)
    elseif index == 2 then
        sortManage = 0
        sortManageType = 4
        for i=1, #SortToggles do
            SortToggles[i].transform:Find(1).gameObject:SetActive(true)
            SortToggles[i].transform:Find(-1).gameObject:SetActive(false)
        end
        this.GetManagerData(true,true);
    elseif index == 3 then
		blackListSystemPlayer:GetComponent('UIToggle'):Set(false)
        this.GetBlackLis()
    elseif index == 4 then
        this.GetMutexList()
    elseif index == 5 then
        this.RefreshAddMenberPanel()
    end
end

function this.GetSelectPanel()
    for i=1,#Toggles do
        if Toggles[i].transform:GetComponent('UIToggle').value then
            return i;
        end
    end
end

function this.InitMeneberPanel()
    MeneberPanel        = gameObject.transform:Find('MeneberPanel')
    MemberList          = MeneberPanel.transform:Find('MemberList/Scroll View')
    MemberListBar       = MeneberPanel.transform:Find('MemberList/Scroll Bar'):GetComponent('UIScrollBar')
    MemberPrefab        = gameObject.transform:Find('MeneberPanel/MemberList/Item')
    ClearFeeBalanceBtn  = MeneberPanel.transform:Find('ClearFeeBalanceBtn')

    MemberList:GetComponent('UIScrollView').onDragFinished = this.OnMemberMoveNext
    message:AddClick(ClearFeeBalanceBtn.gameObject, this.OnClearFeeBalanceBtn)
    MyMemberToggle = MeneberPanel.transform:Find('MyMember')
    feeMemberToggle = MeneberPanel.transform:Find('feeMember')
    local managerSearch = MeneberPanel.transform:Find('ManagerSearch')
    message:AddClick(managerSearch.gameObject, function (go)
        local func = function (data)
            managerSearch.transform:GetComponent('UILabel').text = data.userId
        end
        PanelManager.Instance:ShowWindow('panelSelectManager',  {assign = false, func = func})
        managerSearch.transform:GetComponent('UILabel').text = '请选择管理员'
        MyMemberToggle:GetComponent('UIToggle'):Set(false)
        --feeMemberToggle:GetComponent('UIToggle'):Set(false)
    end)

    local playerSearch = MeneberPanel.transform:Find('PlayerSearch')
    message:AddClick(playerSearch.gameObject, function (go)
        PanelManager.Instance:ShowWindow('keyborad',gameObject.name..'+Menber')
        MyMemberToggle:GetComponent('UIToggle'):Set(false)
        feeMemberToggle:GetComponent('UIToggle'):Set(false)
    end)

    local searchButton = MeneberPanel.transform:Find('ButtonSearch')
    message:AddClick(searchButton.gameObject, function (go)
        this.GetMenberData(true, false,false,true)
    end)

    TimeSortButton = MeneberPanel.transform:Find('MemberList/Tip/time')
    FatigueSortButton = MeneberPanel.transform:Find('MemberList/Tip/Fatigue')
    message:AddClick(FatigueSortButton.gameObject, this.OnMemberSort)
    message:AddClick(TimeSortButton.gameObject, this.OnMemberSort)

    table.insert(MemberSortToggles, TimeSortButton)
    table.insert(MemberSortToggles, FatigueSortButton)

    message:AddClick(MyMemberToggle.gameObject, this.OnClickMyMember)
    message:AddClick(feeMemberToggle.gameObject, this.OnClickFeeMember)
    superScrollList = SuperScrollList.New(MemberList:GetComponent('UIScrollView'), MemberList:Find('Grid').transform)
    superScrollList:SetCellSize(200, -110)
    superScrollList:SetRefreshCallback(this.RefreshMember)
    superScrollList:SetItemInstanceCallback(this.OnItemInstance)
    superScrollList:SpawnNewList(MemberPrefab.gameObject, 0)
end


function this.UpdateMemberItemType(userId,type)
    if tonumber(userId) and tonumber(type) then
        for i = 1, #MenberObjData do
            if MenberObjData[i].data.userId == userId then
                MenberObjData[i].data.userType = type;
            end
        end
        superScrollList:Resize(#MenberObjData);
        local managerSearch         = MeneberPanel.transform:Find('ManagerSearch');
        if tonumber(managerSearch:GetComponent("UILabel").text) then
            this.GetMenberData(true, false)
        end
        --MemberList:Find('Grid'):GetComponent('UIGrid'):Reposition();
        MemberList:GetComponent('UIScrollView'):ResetPosition();
    end
end

function this.setMenberSearch(str)
    local playerSearch = MeneberPanel.transform:Find('PlayerSearch')
    playerSearch.transform:GetComponent('UILabel').text = str == '' and '请输入玩家ID' or str

    local playerId = playerSearch.transform:GetComponent('UILabel').text
    local managerId = MeneberPanel.transform:Find('ManagerSearch').transform:GetComponent('UILabel').text
end

function this.OnClickMyMember(go)
    this.GetMenberData(true, true,false,true)
end

function this.OnClickFeeMember(go)
    this.GetMenberData(true, false,false,true)
end

local isFromMemberManangerPanel = false
function this.GetManagerMenber(managerId,isManageFuFee,isFromMemberMananger)
    local toggles = gameObject.transform:Find('Toggles')
    toggles.transform:Find('1'):GetComponent('UIToggle').value = true
    local managerSearch = MeneberPanel.transform:Find('ManagerSearch')
    managerSearch.transform:GetComponent('UILabel').text = managerId
    MyMemberToggle:GetComponent('UIToggle'):Set(false)
    feeMemberToggle:GetComponent('UIToggle'):Set(isManageFuFee)
    this.GetMenberData(true, false,false,isManageFuFee)
    isFromMemberManangerPanel = isFromMemberMananger
end

function this.OnClearFeeBalanceBtn(go)
    local msg = Message.New()
        msg.type = proxy_pb.FEE_RESET;
        local body = proxy_pb.PFeeReset();
        body.clubId = panelClub.clubInfo.clubId;
        body.startTime = os.time({day=17, month=5, year=2012, hour=0, minute=0, second=0});
        body.endTime = os.time();

        -- if not isCanCleanAllFeeBalance() and isCanCleanMySelfFeeBalance()  then
        --     body.managerId = info_login.id
        -- end

        msg.body = body:SerializeToString()
        panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
            SendProxyMessage(msg, this.ClearResult) 
        end, nil, '是否确认清除列表中共计'..MeneberPanel:Find('FatigueValue/Label'):GetComponent('UILabel').text..'疲劳值？')
        PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.ClearResult(msg)
    local b = proxy_pb.RResult()
    b:ParseFromString(msg.body)
    if b.code == 1 then
        this.Refresh()
    end
end

function this.OnClickMemberLook(go)
    AudioManager.Instance:PlayAudio('btn')
    local data={}
    data.userData=GetUserData(go.transform.parent.gameObject)
    if panelClub.clubInfo.gameMode then
        PanelManager.Instance:ShowWindow('panelMatchMenberManager', data)
    else
        PanelManager.Instance:ShowWindow('panelMenberManager', data)
    end
end

function this.InitManager(NeedInitSearch,NeedInitSort)
    local managerSearch = ManagerPanel.transform:Find('ManagerSearch')
    managerPage             = 1;
    managerIndex            = 0;
    isManagerSendedRequest  = false;
    IsInBottom              = false;
    ManagerIndexObjData     = {};
    ManagerFuFeeAveNum.parent.gameObject:SetActive(panelClub.clubInfo.gameMode)
    ManagerfuFeeValue.parent.gameObject:SetActive(panelClub.clubInfo.gameMode)
    managerSearch.gameObject:SetActive(panelClub.clubInfo.gameMode)
    tipFuFeeMemberNum.gameObject:SetActive(panelClub.clubInfo.gameMode)
    tipFuFeeValue.gameObject:SetActive(panelClub.clubInfo.gameMode)

    local pos1 = tipMemberNum.localPosition
    pos1.x = panelClub.clubInfo.gameMode and -72 or 245
    tipMemberNum.localPosition = pos1
    
    local pos2 = tipFeePrecent.localPosition
    pos2.x = panelClub.clubInfo.gameMode and -228 or -72
    tipFeePrecent.localPosition = pos2

    if NeedInitSearch then
        currentManagerType  = nil;
        managerSearch.transform:GetComponent('UILabel').text = '请选择管理员'
    end
    if NeedInitSort then
        sortManage = 0
        sortManageType = 0
        for i=1, #SortToggles do
            SortToggles[i].transform:Find(1).gameObject:SetActive(false)
            SortToggles[i].transform:Find(-1).gameObject:SetActive(false)
        end
    end
end



function this.InitManagerPanel()
    IsInBottom                  = false;
    ManagerPanel                = gameObject.transform:Find('ManagerPanel')
    ManagerList                 = ManagerPanel.transform:Find('MemberList/Scroll View')
    ManagerPrefab               = gameObject.transform:Find('ManagerPanel/MemberList/Item')
    managerScrollBar            = ManagerPanel.transform:Find("MemberList/Scroll Bar"):GetComponent("UIScrollBar")
    ManagerTypePanel            = ManagerPanel.transform:Find("TypePanel")
    local managerSearch         = ManagerPanel.transform:Find('ManagerSearch')
    ManagerList:GetComponent("UIScrollView").onDragFinished  = this.OnManagerRequestNextPage
    message:AddClick(managerSearch.gameObject, function (go)
        ManagerTypePanel.gameObject:SetActive(true);
        this.InitManagerTypePanel();
    end)
    ManagerFuFeeAveNum = ManagerPanel.transform:Find('MemberList/fuFeeAveNum/num')
    ManagerfuFeeValue = ManagerPanel.transform:Find('MemberList/fuFee/num')
    local searchButton = ManagerPanel.transform:Find('ButtonSearch')
    message:AddClick(searchButton.gameObject, function (go)
        --local managerId = managerSearch.transform:GetComponent('UILabel').text
        --this.GetManagerSreach(managerId);
        --this.GetManagerData(true,false);
    end)
    tipMemberNum = ManagerPanel.transform:Find('MemberList/Tip/memberNum')
    tipFeePrecent = ManagerPanel.transform:Find('MemberList/Tip/feePrecent')
    tipFuFeeMemberNum = ManagerPanel.transform:Find('MemberList/Tip/fuFeeMemberNum')
    tipFuFeeValue = ManagerPanel.transform:Find('MemberList/Tip/fuFeeValue')
    --table.insert(SortToggles, tipMemberNum)
    --table.insert(SortToggles, tipFeePrecent)
    --table.insert(SortToggles, tipFuFeeMemberNum)
    table.insert(SortToggles, tipFuFeeValue)
    for i = 1, #SortToggles do
        message:AddClick(SortToggles[i].gameObject, this.OnClickSortNum)
    end
    tipMemberNum.transform:Find(1).gameObject:SetActive(false)
    tipMemberNum.transform:Find(-1).gameObject:SetActive(false)
    tipMemberNum.transform:Find('bg').gameObject:SetActive(false)
    tipFeePrecent.transform:Find(1).gameObject:SetActive(false)
    tipFeePrecent.transform:Find(-1).gameObject:SetActive(false)
    tipFeePrecent.transform:Find('bg').gameObject:SetActive(false)
    tipFuFeeMemberNum.transform:Find(1).gameObject:SetActive(false)
    tipFuFeeMemberNum.transform:Find(-1).gameObject:SetActive(false)
    tipFuFeeMemberNum.transform:Find('bg').gameObject:SetActive(false)
    for i = 0, ManagerTypePanel:Find("Scroll View/Grid").childCount-1 do
        message:AddClick(ManagerTypePanel:Find("Scroll View/Grid"):GetChild(i).gameObject,this.OnClickManagerType);
    end

    message:AddClick(ManagerTypePanel:Find("MaskBtn").gameObject,this.OnClickSelectTypeBtn);

end


function this.OnClickManagerType(go)

    local searchManagerType = 0

    if 'MANAGER' == go.name then
        searchManagerType = proxy_pb.MANAGER
    elseif 'VICE_MANAGER' == go.name then
        searchManagerType = proxy_pb.VICE_MANAGER
    elseif 'ASSISTANT' == go.name then
        searchManagerType = proxy_pb.ASSISTANT
    elseif  go.name == "PRESIDENT" then
        searchManagerType = proxy_pb.PRESIDENT;
    elseif go.name == "VICE_PRESIDENT" then
        searchManagerType = proxy_pb.VICE_PRESIDENT;
    end

    currentManagerType = searchManagerType;


    ManagerPanel:Find("ManagerSearch"):GetComponent("UILabel").text = this.GetTypeString(searchManagerType);
    this.OnClickSelectTypeBtn(go);
    this.GetManagerData(true,false);


    managerPage             = 1;
    managerIndex            = 0;
    isManagerSendedRequest  = false;
    IsInBottom              = false;
    ManagerIndexObjData     = {};

end

function this.OnClickSelectTypeBtn()
    AudioManager.Instance:PlayAudio('btn');
    ManagerTypePanel.gameObject:SetActive(not ManagerTypePanel.gameObject.activeSelf);
end


function this.InitManagerTypePanel()

    local ManagerTypeGrid = ManagerTypePanel:Find("Scroll View/Grid");
    for i = 0, ManagerTypeGrid.childCount-1 do
        ManagerTypeGrid:GetChild(i).gameObject:SetActive(false);
    end
    ManagerTypeGrid.transform.parent:GetComponent('UIScrollView'):ResetPosition()
    ManagerTypeGrid.transform:GetComponent('UIGrid').repositionNow = true

    local types = this.GetType(panelClub.clubInfo.userType);

    for i = 1, #types do
        if proxy_pb.MANAGER == types[i] then
            ManagerTypeGrid.transform:Find('MANAGER').gameObject:SetActive(true)
        elseif proxy_pb.VICE_MANAGER == types[i] then
            ManagerTypeGrid.transform:Find('VICE_MANAGER').gameObject:SetActive(true)
        elseif proxy_pb.ASSISTANT == types[i] then
            ManagerTypeGrid.transform:Find('ASSISTANT').gameObject:SetActive(true)
        elseif proxy_pb.PRESIDENT == types[i] then
            ManagerTypeGrid.transform:Find("PRESIDENT").gameObject:SetActive(true);
        elseif proxy_pb.VICE_PRESIDENT == types[i] then
            ManagerTypeGrid.transform:Find("VICE_PRESIDENT").gameObject:SetActive(true);
        end
    end

    ManagerTypeGrid.transform:GetComponent('UIGrid'):Reposition()

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


function this.UpdateManagerItemType(userId,type)
    --print("UpdateManagerItemType was called------->");
    --print("userId:"..userId);
    --print("type:"..type);
    if tonumber(userId) and tonumber(type) then
        for i = 1, #ManagerIndexObjData do
            if ManagerIndexObjData[i].data.userId == userId then
                ManagerIndexObjData[i].data.userType = type;
            end
        end
        this.RefreshManagerList(ManagerIndexObjData);
        local managerSearch         = ManagerPanel.transform:Find('ManagerSearch');
        if tonumber(managerSearch:GetComponent("UILabel").text) then
            this.GetManagerSreach(userId);
        end
        ManagerList:Find('Grid'):GetComponent('UIGrid'):Reposition()
        ManagerList:GetComponent('UIScrollView'):ResetPosition()
    end
end


function this.OnManagerRequestNextPage()
    --print("OnManagerRequestNextPage was called,value:"..managerScrollBar.value);
    --我们往上拖拽才拉取，不用考虑往下拖拽的情况了
    print("request page manager------------> IsInBottom:"..tostring(IsInBottom).."|isManagerSendedRequest:"..tostring(isManagerSendedRequest).."|managerPage"..managerPage);
    if (not isManagerSendedRequest and managerScrollBar.value >=1) then
        --print("path---------------->1");
        if not IsInBottom then
            managerPage = managerPage + 1;
            this.GetManagerData();
            --print("path---------------->2");
        else
            panelMessageTip.SetParamers('没有更多了', 1)
            PanelManager.Instance:ShowWindow('panelMessageTip')
            --print("path---------------->3");
        end

    end

end


function this.setManagerSearch(str)
    local managerSearch = ManagerPanel.transform:Find('ManagerSearch')
    managerSearch.transform:GetComponent('UILabel').text = str
    this.GetManagerSreach(str)
end

function this.GetManagerSreach(managerId)
    if tonumber(managerId) then
        local findManager = false;
        for i=1,#ManagerObjData do
            ManagerObjData[i].gameObject:SetActive(true)
            local data = GetUserData(ManagerObjData[i].transform.gameObject)

            if string.find(data.userId, managerId) == nil then
                ManagerObjData[i].gameObject:SetActive(false)
            else
                findManager = true;
            end
        end
        ManagerList:Find('Grid'):GetComponent('UIGrid'):Reposition()
        ManagerList:GetComponent('UIScrollView'):ResetPosition()
    else

        panelMessageTip.SetParamers("请输入管理员id",1);
        PanelManager.Instance:ShowWindow('panelMessageTip')
    end

end

function this.OnClickSortNum(go)
    AudioManager.Instance:PlayAudio('btn')
    local As = go.transform:Find(1);
    local Ds = go.transform:Find(-1);
    if As.gameObject.activeSelf then
        sortManage = 1 
        Ds.gameObject:SetActive(true)
        As.gameObject:SetActive(false)
    else
        sortManage = 0
        As.gameObject:SetActive(true)
        Ds.gameObject:SetActive(false)
    end

    for i=1, #SortToggles do
        if SortToggles[i].gameObject ~= go then
            SortToggles[i].transform:Find(1).gameObject:SetActive(false)
            SortToggles[i].transform:Find(-1).gameObject:SetActive(false)
        end
    end

    if go.name == "memberNum" then
        sortManageType = 2
    elseif go.name == "feePrecent" then
        sortManageType = 1
    elseif go.name == "fuFeeMemberNum" then
        sortManageType = 3
    elseif go.name == "fuFeeValue" then
        sortManageType = 4
    end
    managerPage = 1
    managerIndex = 0
    this.GetManagerData(false,false,false,true)
end

function this.InitBlackListPanel()

    BlackListPanel = gameObject.transform:Find('BlackListPanel')
    BlackList =  BlackListPanel.transform:Find('MemberList/Scroll View')
    BlackListItem = gameObject.transform:Find('BlackListPanel/MemberList/Item')
    AddBlackPlayerPanel = BlackListPanel.transform:Find('AddPanel')
    AddPlayerInput = AddBlackPlayerPanel.transform:Find('Player1/Input')
	tishiBlackList = BlackListPanel.transform:Find('tishi')
	messageItemBlackList = tishiBlackList.transform:Find('messageItem')
	tishiRoomBlackListGrid = tishiBlackList.transform:Find('gridRoom')
	
    message:AddClick(BlackListPanel.transform:Find('AddtoButton').gameObject, function (go)
        AddBlackPlayerPanel.gameObject:SetActive(true)
        AddPlayerInput:GetComponent('UIInput').value = ''
    end)
    local closeBtn = BlackListPanel.transform:Find('AddPanel/BaseContent/ButtonClose')
    message:AddClick(closeBtn.gameObject, function (go)
        AddBlackPlayerPanel.gameObject:SetActive(false)
    end)
    local okButton = AddBlackPlayerPanel.transform:Find('OkButton')
    message:AddClick(okButton.gameObject, this.OnClickAddBlackPlayer)

    local selectBtn = AddBlackPlayerPanel.transform:Find('Player1/SelButton')
    message:AddClick(selectBtn.gameObject, function (go)
        local input = AddPlayerInput:GetComponent('UIInput')
        this.SelctPlayer(MenberListData,function (userId)
            if not this.IsOperationLord(userId) then
                input.value = userId
            end
        end)
    end)

    CleanFatiguePanel = BlackListPanel.transform:Find('CleanFatiguePanel');
    FatigueInput = BlackListPanel.transform:Find('CleanFatiguePanel/InputFatigue/Input')
    message:AddClick(BlackListPanel.transform:Find('CleanFatiguePanel/OkButton').gameObject, this.OnCleanFatigue)
    local closeButton = BlackListPanel.transform:Find('CleanFatiguePanel/BaseContent/ButtonClose')
    message:AddClick(closeButton.gameObject, function (go)
        CleanFatiguePanel.gameObject:SetActive(false)
    end)

    blackListSystemPlayer = BlackListPanel.transform:Find('systemPlayer')
	 message:AddClick(blackListSystemPlayer.gameObject, function (go)
        this.GetBlackLis()
    end)
	
    blackListPlayerSearch = BlackListPanel.transform:Find('PlayerSearch')
    local ButtonSearch = BlackListPanel.transform:Find('ButtonSearch')
    message:AddClick(blackListPlayerSearch.gameObject, function (go)
        PanelManager.Instance:ShowWindow('keyborad',gameObject.name..'+BlackList')
    end)

    message:AddClick(ButtonSearch.gameObject, function (go)
        this.GetBlackLis()
    end)
	message:AddClick(tishiBlackList.transform:Find('ButtonOK').gameObject, function (go)
        tishiBlackList.gameObject:SetActive(false)
    end)
	message:AddClick(tishiBlackList.transform:Find('ButtonClose').gameObject, function (go)
        tishiBlackList.gameObject:SetActive(false)
    end)
end

function this.setBlackListSearch(str)
    blackListPlayerSearch.transform:GetComponent('UILabel').text = str == '' and '请输入玩家ID' or str
end

function this.SelctPlayer(MemberList, func)
        local data = {}
        data.func = func
        data.MemberList = MemberList    
        PanelManager.Instance:ShowWindow('panelSelMenber',data)
end

function this.IsShowBackList()
    return this.GetSelectPanel() == 3
end

function this.OnClickAddBlackPlayer(go)
    AudioManager.Instance:PlayAudio('btn')
    local msg = Message.New()
    msg.type = proxy_pb.ADD_BLACK_PLAYER
    local body=proxy_pb.PAddBlackPlayer()
    body.clubId = panelClub.clubInfo.clubId
    body.userId = AddPlayerInput:GetComponent('UIInput').value

    if body.userId == info_login.id then
        panelMessageTip.SetParamers('无法自己添加自己进入小黑屋名单', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        return 
    elseif body.userId == '' then
        panelMessageTip.SetParamers('ID不能为空', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        return 
    end
 
    msg.body = body:SerializeToString()

    --local userName = panelSelMenber.dictionary[body.userId]
    local userName = body.userId
    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
        SendProxyMessage(msg, function (msgResult)
            local b = proxy_pb.RResult()
            b:ParseFromString(msgResult.body)
            print('请求添加玩家返回值code'..b.code)
            print('请求添加玩家返回值msg'..b.msg)
            if b.code == 1 then
                this.GetData(this.GetSelectPanel())
                panelMessageTip.SetParamers('添加成功。', 2)
                PanelManager.Instance:ShowWindow('panelMessageTip')
                AddBlackPlayerPanel.gameObject:SetActive(false)
            end
        end)
    end, nil, '是否确认将ID:“'..userName..'”加入小黑屋吗？ 若加入小黑屋，则玩家无法在本群进入任何房间；', '确 定')
	PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.OnClickRemoveBlackList(go)
    AudioManager.Instance:PlayAudio('btn')
    local data = GetUserData(go.gameObject)
    if data.operatorId ~= nil and data.operatorId ~= '' then
        this.RemoveFromBlackList(data.id, data.nickname)
    else
		if panelClub.clubInfo.gameMode then
			this.RemoveFromBlackList(data.id, data.nickname)
		else
			this.ShowCleanFatiguePanel(data)
		end
    end
end

function this.OnClickButtonRoom(go)
	AudioManager.Instance:PlayAudio('btn')
	local data = GetUserData(go.gameObject)
	local dataTime = os.date('%Y%m%d', data.time)
	local is7Day = false
	for i=0,6 do
		local newTime = os.date('%Y%m%d', os.time()-86400 *i)
		if newTime == dataTime then
			is7Day = true
		end
	end
	
	if is7Day then
		local content = SplitString(data.content,'|')
		local roomIDs = SplitString(content[1],',')
		local roomNums = SplitString(content[2],',')
		for i = 1 , #roomNums do
			local obj
			if tishiRoomBlackListGrid.childCount < #roomNums then
				obj = NGUITools.AddChild(tishiRoomBlackListGrid.gameObject, messageItemBlackList.gameObject)
				message:AddClick(obj.gameObject, function (go)
					AudioManager.Instance:PlayAudio('btn')
					PanelManager.Instance:ShowWindow('panelRecordDetail',GetUserData(go))
				end)
			else
				obj = tishiRoomBlackListGrid:GetChild(i-1).gameObject
			end
			local myData={}
			myData.roomId = roomIDs[i]
			myData.roomNumber = roomNums[i]
			myData.name=gameObject.name
			SetUserData(obj,myData)
			obj:GetComponent('UILabel').text = roomNums[i]..','
		end 
		for i = 0, tishiRoomBlackListGrid.childCount-1 do
            if i < #roomNums then
                tishiRoomBlackListGrid:GetChild(i).gameObject:SetActive(true)
            else
                tishiRoomBlackListGrid:GetChild(i).gameObject:SetActive(false)
            end
        end
		tishiBlackList.gameObject:SetActive(true)
		tishiRoomBlackListGrid:GetComponent('UIGrid'):Reposition()
	else
		panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '房间号只保存七天，该房间号已过期')
		PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
	end
end

function this.RemoveFromBlackList(id, nick)
    local msg = Message.New()
    msg.type = proxy_pb.DELETE_BLACK_PLAYER
    local body=proxy_pb.PDeleteBlackPlayer()
    body.id = id
    body.clubId = panelClub.clubInfo.clubId
    msg.body = body:SerializeToString()
    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
        SendProxyMessage(msg, function (msg)
            local b = proxy_pb.RResult()
            b:ParseFromString(msg.body)
            if b.code == 1 then
                panelMessageTip.SetParamers('删除成功。', 1)
                PanelManager.Instance:ShowWindow('panelMessageTip')
                this.GetData(this.GetSelectPanel())
            end
        end)
    end, nil, '是否将“'..nick..'”从小黑屋中移除', '确 定')
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.CleanFatigue(user, Fatigue)
    local msg = Message.New()
    msg.type = proxy_pb.FEE_DEDUCT;
    local body = proxy_pb.PFeeDeduct();
    body.clubId = panelClub.clubInfo.clubId;
    body.userId = user.userId;
    body.amount = tostring(Fatigue);
    msg.body = body:SerializeToString()
    print('扣除的：'..body.amount)
    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
        SendProxyMessage(msg, this.operationResult) 
    end, nil, '是否确定扣除玩家\"'..user.nickname..'\"'..Fatigue..'分疲劳值？')
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.operationResult(msg)
    local b = proxy_pb.RResult();
    b:ParseFromString(msg.body);
    if b.code==1 then
        this.Refresh()
        CleanFatiguePanel.gameObject:SetActive(false)
    end
end

local CurBlackListItem
function this.ShowCleanFatiguePanel(data)
    CurBlackListItem = data;
    FatigueInput:GetComponent('UIInput').value = data.feeBalance
    CleanFatiguePanel:Find('RestFatigue/Label'):GetComponent('UILabel').text = data.feeBalance
    CleanFatiguePanel.gameObject:SetActive(true)
end

function this.OnCleanFatigue(go)
    AudioManager.Instance:PlayAudio('btn')
    local value = tonumber(FatigueInput:GetComponent('UIInput').value)
    if value > tonumber(CurBlackListItem.feeBalance) or value < 0 then
        panelMessageTip.SetParamers('请输入0-'..CurBlackListItem.feeBalance..'之间的值', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        return 
    end

    this.CleanFatigue(CurBlackListItem, value)
end

local MutexList
local MutexPrefab
local MutexPanel
local AndMutexPanel
local AndMutexButton
local MutexPlayer1
local MutexPlayer2
function this.InitMutexPanel()
    MutexPanel = gameObject.transform:Find('MutexPanel')
    MutexList = MutexPanel.transform:Find('MemberList/Scroll View')
    MutexPrefab = gameObject.transform:Find('MutexPanel/MemberList/Item')
    AndMutexPanel = gameObject.transform:Find('MutexPanel/AddPanel')

    MutexPlayer1 = AndMutexPanel.transform:Find('Player1/Input')
    MutexPlayer2 = AndMutexPanel.transform:Find('Player2/Input')

    for i = 1, 2 do
        local button = AndMutexPanel.transform:Find('Player'..i..'/SelButton')
        local input = AndMutexPanel.transform:Find('Player'..i..'/Input'):GetComponent('UIInput')
        message:AddClick(button.transform.gameObject, function (go)
            this.SelctPlayer(MenberListData,function (userId)
                if not this.IsOperationLord(userId) then
                    input.value = userId
                end
            end)
        end)
    end

    message:AddClick(AndMutexPanel.transform:Find('BaseContent/ButtonClose').gameObject, function (go)
        AndMutexPanel.transform.gameObject:SetActive(false)
    end)

    message:AddClick(MutexPanel.transform:Find('AddtoButton').gameObject, function (go)
        AndMutexPanel.gameObject:SetActive(true)
        MutexPlayer1:GetComponent('UIInput').value = ''
        MutexPlayer2:GetComponent('UIInput').value = ''
    end)
    message:AddClick(AndMutexPanel.transform:Find('OkButton').gameObject, this.OnClickAddMutexPlayers)
end

function this.IsShowMutex()
    return this.GetSelectPanel() == 4
end

function this.OnClickAddMutexPlayers(go)
    AudioManager.Instance:PlayAudio('btn')
    local msg = Message.New()
    msg.type = proxy_pb.ADD_MUTEX_USERS
    local body=proxy_pb.PAddMutexUsers()
    body.clubId = panelClub.clubInfo.clubId
    body.userId = trim(MutexPlayer1:GetComponent('UIInput').value)
    body.otherUserId = trim(MutexPlayer2:GetComponent('UIInput').value)
    msg.body = body:SerializeToString()
    
    if body.userId == nil or body.userId == '' or body.otherUserId == nil or body.otherUserId == '' then
        panelMessageTip.SetParamers('请输入玩家ID', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        return 
    end

    if body.userId == body.otherUserId then
        panelMessageTip.SetParamers('不能添加同一个玩家为互斥名单', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        return 
    end

    -- if body.userId == info_login.id or body.otherUserId == info_login.id then
    --     panelMessageTip.SetParamers('无法自己添加自己进入互斥名单', 1)
    --     PanelManager.Instance:ShowWindow('panelMessageTip')
    --     return 
    -- end

    if string.len(body.userId) < 7 or string.len(body.otherUserId) < 7 then
        panelMessageTip.SetParamers('ID格式错误', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        return 
    end

    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RResult()
        b:ParseFromString(msg.body)
        if b.code == 1 then
            panelMessageTip.SetParamers('添加成功。', 1)
            PanelManager.Instance:ShowWindow('panelMessageTip')
            AndMutexPanel.gameObject:SetActive(false)
            this.GetData(this.GetSelectPanel())
        end
    end)
end

function this.OnRemoveMutexPlayers(go)
    local msg = Message.New()
    msg.type = proxy_pb.DELETE_MUTEX_USERS
    local body=proxy_pb.PDeleteMutexUsers()
    body.clubId = panelClub.clubInfo.clubId
    body.id = GetUserData(go.gameObject).id
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RResult()
        b:ParseFromString(msg.body)
        if b.code == 1 then
            panelMessageTip.SetParamers('删除成功。', 1)
            PanelManager.Instance:ShowWindow('panelMessageTip')
            AndMutexPanel.gameObject:SetActive(false)
            this.GetData(this.GetSelectPanel())
        end
    end)
end

local AddMenberPanel
local SharedUrl = ''
local XLSharedUrl = ''
local AddMenberInput
function this.InitAddMenberPanel()
    AddMenberPanel = gameObject.transform:Find('AddMenberPanel')

    AddMenberInput = AddMenberPanel.transform:Find('input')

    local wechat = AddMenberPanel.transform:Find('Wechat')
    message:AddClick(wechat.transform.gameObject, function (go)
        local content = this.GetShardLinkContent()
        print("content",content)
        PlatformManager.Instance:ShareLink(SharedUrl, '嗨皮湖南棋牌', content,0)
    end)

    local xianLiao = AddMenberPanel.transform:Find('XianLiao')
    message:AddClick(xianLiao.transform.gameObject, function (go)
        local content = this.GetShardLinkContent()
        print("content",content)
        PlatformManager.Instance:ShareLinkToXL(XLSharedUrl, '嗨皮湖南棋牌', content)
    end)

    message:AddClick(AddMenberPanel.transform:Find('ButtonOK').gameObject, this.OnClickAddMenber)
    message:AddSubmit(AddMenberInput.gameObject, function (go)
        this.GetPlayerInfo(false,AddMenberInput:GetComponent('UIInput').value, this.SetPlayInfo)
    end)
end

function this.GetShardLinkContent()
    local content = '【'..info_login.nickname..'】邀请您加入牌友群【'..panelClub.clubInfo.name..'】（ID:'..panelClub.clubInfo.clubId..'）。嗨皮游戏让您随时随地享受休闲快乐时光'

    return content;
end

function this.OnClickAddMenber(go)
    AudioManager.Instance:PlayAudio('btn')
    local msg       = Message.New()
    msg.type        = proxy_pb.CLUB_USER_MANAGE
    local body      = proxy_pb.PClubUserManage()
    body.clubId     = panelClub.clubInfo.clubId
    body.userId     = AddMenberInput:GetComponent('UIInput').value

    if AddMenberInput:GetComponent('UIInput').value == '' then
        panelMessageTip.SetParamers('ID不能为空', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        return 
    end

    body.operation=proxy_pb.ADD
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RResult()
        b:ParseFromString(msg.body)
        if b.code == 1 then
            this.GetData(this.GetSelectPanel())
            panelMessageTip.SetParamers('添加成功', 1)
            PanelManager.Instance:ShowWindow('panelMessageTip')
        else
            print('hjaahahahahah')
        end
    end)
end

function this.GetPlayerInfo(needClubId,userId, func)
    local msg = Message.New()
    msg.type = proxy_pb.MY_INFO_CARD
    local body = proxy_pb.PMyInfoCard()
    if userId == '' or userId == nil then
        return 
    end
    body.userId = userId
    if needClubId==true then
        body.clubId = panelClub.clubInfo.clubId
    end
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RMyInfoCard();
        b:ParseFromString(msg.body);
        func(b)
    end)
end

function this.SetPlayInfo(data)
    local player = AddMenberPanel.transform:Find('payer')
    player:Find('name'):GetComponent('UILabel').text = data.nickname
    coroutine.start(LoadPlayerIcon, player:Find('tx'):GetComponent('UITexture'), data.icon)
end

function this.WhoShow(data)
    playerIDFuFeeValue = data.playerIDFuFeeValue
    print('index : '..data.index)
    this.InitView()
    this.Refresh(data.index)
end

function this.OnEnable()
    IsInBottom = false;
    sortManage = 0
    sortManageType = 0
    MyMemberToggle:GetComponent('UIToggle'):Set(false)
    feeMemberToggle:GetComponent('UIToggle'):Set(false)
end

function this.Refresh(pageIndex)
    print("panelMenber.Refresh:"..panelClub.clubInfo.userType)

    -- for i=7,11 do
    --     gameObject.transform:GetChild(i).gameObject:SetActive(false)
    -- end
    local selectPageIndex;
    local toggles = gameObject.transform:Find('Toggles')
    for i = 1, 5 do
        local toggle = toggles.transform:Find(i)
        if toggle.transform:GetComponent('UIToggle').value then
            selectPageIndex = i
        end
        toggles.transform:Find(i).gameObject:SetActive(true)
    end

    if pageIndex == nil then
        pageIndex = selectPageIndex
    end

    --设置成员管理的表头，对应的角色显示对应的列
    toggles.transform:Find(pageIndex):GetComponent('UIToggle'):Set(true);
    if panelClub.clubInfo.userType == proxy_pb.MANAGER then
        toggles.transform:Find('2').gameObject:SetActive(panelClub.clubInfo.gameMode == true)
    elseif panelClub.clubInfo.userType == proxy_pb.VICE_MANAGER or
            panelClub.clubInfo.userType == proxy_pb.ASSISTANT  or
            panelClub.clubInfo.userType == proxy_pb.PRESIDENT or
            panelClub.clubInfo.userType == proxy_pb.VICE_PRESIDENT then
        toggles.transform:Find('3').gameObject:SetActive(false);
        toggles.transform:Find('4').gameObject:SetActive(false);
        toggles.transform:Find('2').gameObject:SetActive(panelClub.clubInfo.userType ~= proxy_pb.VICE_PRESIDENT)
    elseif panelClub.clubInfo.userType == proxy_pb.GENERAL then
        for i = 2, 5 do
            toggles.transform:Find(i).gameObject:SetActive(false)
        end
    end
    
    toggles.transform:GetComponent('UIGrid'):Reposition()
    this.GetData(pageIndex)
end

function this.ClosePanel(go)
    AudioManager.Instance:PlayAudio('btn')
    if not isMessgeSkip then
        if isFromMemberManangerPanel then
            isFromMemberManangerPanel = false
            if panelClub.clubInfo.gameMode then
                PanelManager.Instance:ShowWindow('panelMatchMenberManager')
            else
                PanelManager.Instance:ShowWindow('panelMenberManager')
            end
            this.GetMenberData(true, true)
            this.GetManagerData(true,true);
            return
        end
    else
        PanelManager.Instance:ShowWindow('panelMessage', 1)
    end
    isMessgeSkip = false
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.InitView()
    for i=1, #SortToggles do
        SortToggles[i].transform:Find(1).gameObject:SetActive(false)
        SortToggles[i].transform:Find(-1).gameObject:SetActive(false)
    end
    if panelClub.clubInfo.gameMode then
        MeneberPanel.transform:Find('ManagerSearch').gameObject:SetActive((proxy_pb.GENERAL ~= panelClub.clubInfo.userType 
        and panelClub.clubInfo.userType ~= proxy_pb.VICE_PRESIDENT));

        this.SetToggleName(Toggles[2], '管家列表')
        MeneberPanel.transform:Find('ManagerSearch/tiShi'):GetComponent('UILabel').text = '管家及成员：'
        ManagerPanel.transform:Find('ManagerSearch/tiShi'):GetComponent('UILabel').text = '管家类型：'
    else
        this.SetToggleName(Toggles[2], '管理员列表')
        MeneberPanel.transform:Find('ManagerSearch/tiShi'):GetComponent('UILabel').text = '管理员：'
        ManagerPanel.transform:Find('ManagerSearch/tiShi'):GetComponent('UILabel').text = '管理员：'

        MeneberPanel.transform:Find('ManagerSearch').gameObject:SetActive(panelClub.clubInfo.userType == proxy_pb.LORD)
    end
end

function this.Update()
    
end

function this.GetData(index)
    if index == 1 then
        this.GetMenberData(true, true, true)
    elseif index == 2 then
        this.GetManagerData(true,true,true);
    elseif index == 3 then
        this.GetBlackLis()
    elseif index == 4 then
        this.GetMutexList()
    elseif index == 5 then
        this.RefreshAddMenberPanel()
    end
    print(index)
end

local MemberPage = 1
local MemberPageSize = 20
local isSendedRequest = false
local IsResetData = true
local MemberIndex = 0
local SortType = ""
local SortMode = 0
function this.InitMember(NeedInitSearch, NeedInitSort)
    MemberPage = 1
    MemberIndex = 0
    IsResetData = true
    MenberObjData = {}
    -- local Grid = MemberList:Find('Grid')
    -- Util.ClearChild(Grid)
    if NeedInitSearch then
        local managerSearch = MeneberPanel.transform:Find('ManagerSearch')
        managerSearch.transform:GetComponent('UILabel').text = '请选择管理员'
        local playerSearch = MeneberPanel.transform:Find('PlayerSearch')
        playerSearch.transform:GetComponent('UILabel').text = '请输入玩家ID'
    end

    if NeedInitSort then
        SortType = ""
        SortMode = 0
        for i=1, #MemberSortToggles do
            MemberSortToggles[i].transform:Find(1).gameObject:SetActive(false)
            MemberSortToggles[i].transform:Find(-1).gameObject:SetActive(false)
        end
    end

    ClearFeeBalanceBtn.gameObject:SetActive(isCanCleanAllFeeBalance() and not panelClub.clubInfo.gameMode)
    if not panelClub.clubInfo.gameMode then
        MyMemberToggle.gameObject:SetActive(panelClub.clubInfo.userType ~= proxy_pb.GENERAL) --(panelClub.clubInfo.userType ~= proxy_pb.GENERAL)
    else
        MyMemberToggle.gameObject:SetActive(panelClub.clubInfo.userType ~= proxy_pb.GENERAL and panelClub.clubInfo.userType ~= proxy_pb.VICE_PRESIDENT)
    end
    MeneberPanel.transform:Find('fuFatigueValue').gameObject:SetActive(panelClub.clubInfo.gameMode and panelClub.clubInfo.userType ~= proxy_pb.GENERAL)
    feeMemberToggle.gameObject:SetActive(panelClub.clubInfo.gameMode and panelClub.clubInfo.userType ~= proxy_pb.GENERAL)
end

function this.RefreshMenber()
    if this.GetSelectPanel() == 1 then
        this.GetMenberData(true, true)
    else
        --this.GetMenberData(true, true)
    end
end

function this.onGetResult()
    isSendedRequest = false
    MyMemberToggle:GetComponent('UIToggle').enabled=true
    feeMemberToggle:GetComponent('UIToggle').enabled=true
end

function this.GetMenberData(NeedInit, NeedInitSearch, NeedInitSort,isFuFeeMember)
    if isSendedRequest==true then
        return
    end
    isSendedRequest = true
    if NeedInit then
        this.InitMember(NeedInitSearch, NeedInitSort)
    end
    if playerIDFuFeeValue ~= 0 then
        MeneberPanel.transform:Find('PlayerSearch'):GetComponent('UILabel').text = playerIDFuFeeValue
        playerIDFuFeeValue=0
        isMessgeSkip = true
    end
    local userId = tonumber(MeneberPanel.transform:Find('PlayerSearch'):GetComponent('UILabel').text)
    local managerId = tonumber(MeneberPanel.transform:Find('ManagerSearch').transform:GetComponent('UILabel').text)
    local isMyMember = MyMemberToggle:GetComponent('UIToggle').value
    MyMemberToggle:GetComponent('UIToggle').enabled=false
    feeMemberToggle:GetComponent('UIToggle').enabled=false
    --MenberObjData = {}
    print('拉取玩家 ..... userId : '..tostring(userId))
    local msg       = Message.New()
    msg.type        = proxy_pb.CLUB_USER_LIST
    local body      = proxy_pb.PClubUserList()
    body.clubId     = panelClub.clubInfo.clubId
    body.page       = MemberPage
    body.pageSize   = MemberPageSize
    body.myChild    = isMyMember
    if isFuFeeMember then
        body.myLossFee = feeMemberToggle:GetComponent('UIToggle').value
    end
    if managerId ~= nil and managerId ~= '' then
        body.managerId = managerId
    end
    if userId ~= nil and userId ~= '' then
        body.userId = userId
    end
    if SortType ~= '' then
        body.order = SortType
        body.sort = SortMode
    end
    print('当前页：'..body.page)
    print('当前页大小：'..body.pageSize)
    print('搜索的管理员：'..body.managerId)
    print('搜索的成员：'..body.userId)
    print('排序类型：'..body.order)
    print('排序方式：'..body.sort)
    msg.body = body:SerializeToString()
    PanelManager.Instance:ShowWindow('panelNetWaitting')
    SendProxyMessage(msg, function (msg)
        this.onGetResult()
        local b = proxy_pb.RClubUserList()
        b:ParseFromString(msg.body);
        PanelManager.Instance:HideWindow('panelNetWaitting')
        
        --MemberIndex = 0
        this.RefreshMemberList(b)

        MeneberPanel.transform:Find('FatigueValue/Label'):GetComponent('UILabel').text = b.balanceTotal
        MeneberPanel.transform:Find('fuFatigueValue/Label'):GetComponent('UILabel').text = b.balanceLossTotal

        MeneberPanel.transform:Find('PlayerNum'):GetComponent('UILabel').text = '在线： '.. b.onlineNum..'/'..b.count
        MeneberPanel.transform:Find('PlayerNum').gameObject:SetActive(panelClub.clubInfo.userType == proxy_pb.LORD)

        if #b.users == 0 then
            IsResetData = false
        end

        if NeedInit then
            MemberList:GetComponent('UIScrollView'):ResetPosition()
        end
    end)
end

function this.RefreshMember(go, index)
    --print('需要刷新的下标：'..index)

    if MenberObjData[index + 1] == nil or MenberObjData[index + 1].data == nil then
        return
    end

    SetUserData(go.gameObject, nil)
    SetUserData(go.gameObject, MenberObjData[index + 1].data)
    this.SetMemberListItemView(go, MenberObjData[index + 1])
end

function this.RefreshMemberList(b)
    local users = b.users
    print('MenberCount:'..#users)
    for i=1, #users do
        local userData = {index = 0, data = nil}
        if users[i].status ~= 0 then
            MemberIndex = MemberIndex + 1
            userData.index = MemberIndex
        end
        userData.data = users[i]
        table.insert(MenberObjData, userData)
        --MenberObjData[i] = userData
    end

    superScrollList:Resize(#MenberObjData)
end

function this.OnMemberMoveNext()
    --print('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh')

    local page, value = math.modf(MemberListBar.value / (1 / MemberPage))
    print(page, value)

    if value > 0 and value < 0.3 then
        print("请求上一页")
    elseif value < 1 and value > 0.7 then
        print("请求下一页")
    else
        -- no do 
    end

    if (not isSendedRequest) and (MemberListBar.value >= 1) then
        print("准备请求")
        if IsResetData then
            MemberPage = MemberPage + 1
		    this.GetMenberData(false,false,false,true)
        else
            panelMessageTip.SetParamers('没有更多了', 1)
            PanelManager.Instance:ShowWindow('panelMessageTip')
        end
	end
end

function this.OnItemInstance(obj)
    message:AddClick(obj.transform:Find('Fatigue').gameObject, this.OnClickFatigue)
    message:AddClick(obj.transform:Find('ButtonAgree').gameObject, this.OnClickAgreOrDisagreeButton)
    message:AddClick(obj.transform:Find('ButtonDisagree').gameObject, this.OnClickAgreOrDisagreeButton)
    message:AddClick(obj.transform:Find('ButtonManage').gameObject, this.OnClickMemberLook)
end

function this.SetMemberListItemView(obj, userData)
    this.RestMemberItem(obj)
    local data = userData.data
    SetUserData(obj.gameObject, data)
    obj.gameObject:SetActive(true)
    obj.transform:GetComponent('UISprite').enabled = data.status == 0
    obj.transform:Find('ButtonAgree').gameObject:SetActive(data.status == 0)
    obj.transform:Find('ButtonDisagree').gameObject:SetActive(data.status == 0)

    -- local userid = string.sub (data.userId, 1,4).."***"
    -- if IsCanOperatingMenber() or (data.userId == info_login.id) or (data.managerId == info_login.id) or isCanCleanAllFeeBalance()  then
    --     userid = data.userId
    --     obj.transform:Find('Fatigue').gameObject:SetActive(not (data.status == 0))
    -- end

    local player = obj.transform:Find('payer')
    player:Find('id'):GetComponent('UILabel').text = "ID:"..data.userId
    player:Find('name'):GetComponent('UILabel').text = data.nickname
    obj.transform:Find('Fatigue').gameObject:SetActive(not (data.status == 0))
    obj.transform:Find('Fatigue'):GetComponent('UILabel').text = data.feeBalance == '' and '0' or data.feeBalance
    coroutine.start(LoadPlayerIcon, player:Find('tx'):GetComponent('UITexture'), data.icon)

    local manager = obj.transform:Find('manager')
    --print('data.superiorId：'..tostring(data.superiorId))
    if data.superiorId ~= nil and data.superiorId ~= '' then
        manager.gameObject:SetActive(true)
        manager:Find('id'):GetComponent('UILabel').text = 'ID:'..data.superiorId
        manager:Find('name'):GetComponent('UILabel').text = data.superiorNickname
        coroutine.start(LoadPlayerIcon, manager:Find('tx'):GetComponent('UITexture'), data.superiorIcon)
    else
        manager.gameObject:SetActive(false)
    end
    

    -- if data.managerId ~= nil and data.managerId ~= '' then
    --     local managerid = (data.managerId == info_login.id or proxy_pb.LORD == panelClub.clubInfo.userType or IsCanOperatingMenber() ) and data.managerId or  string.sub (data.managerId, 1,4).."***"
    --     manager:Find('id'):GetComponent('UILabel').text = 'ID:'..managerid
    --     manager:Find('name'):GetComponent('UILabel').text = data.managerNickname
    --     coroutine.start(LoadPlayerIcon, manager:Find('tx'):GetComponent('UITexture'), data.managerIcon)
    -- else
    --     if proxy_pb.MANAGER == data.userType then
    --         local managerId = (data.managerId == info_login.id or proxy_pb.LORD == panelClub.clubInfo.userType or IsCanOperatingMenber() ) and panelClub.clubInfo.lordId or  string.sub (panelClub.clubInfo.lordId, 1,4).."***"
    --         manager:Find('id'):GetComponent('UILabel').text = 'ID:'..managerId
    --         manager:Find('name'):GetComponent('UILabel').text = panelClub.clubInfo.lordNickname
    --         coroutine.start(LoadPlayerIcon, manager:Find('tx'):GetComponent('UITexture'), panelClub.clubInfo.clubLeaderIcon)
    --     else
    --         manager.gameObject:SetActive(false)
    --     end
    -- end

    if data.status == 0 then
        player:Find('State'):GetChild(0).gameObject:SetActive(true)
    else
        player:Find('State'):Find(data.userType).gameObject:SetActive(true)
    end

    if data.status == 3 then
        obj.transform:Find('time'):GetComponent('UILabel').text = '游戏中'
    elseif data.status == 2 then
        obj.transform:Find('time'):GetComponent('UILabel').text = '空闲'
    elseif data.status == 1 then
        obj.transform:Find('time'):GetComponent('UILabel').text = GetLastActive(os.time(), data.time)
    end

    if data.status ~= 0 then
        obj.transform:Find('bianHao'):GetComponent('UILabel').text = userData.index
    else
        obj.transform:Find('bianHao').gameObject:SetActive(false)
    end

    obj.transform:Find('ButtonManage').gameObject:SetActive(data.status ~= 0)
end

function this.RestMemberItem(obj)
    SetUserData(obj.gameObject, nil)

    local player = obj.transform:Find('payer')
    local state = player:Find('State')
    for i = 0, state.transform.childCount - 1 do
        state.transform:GetChild(i).gameObject:SetActive(false)
    end
    player:Find('tx'):GetComponent('UITexture').mainTexture = nil

    local manager = obj.transform:Find('manager')
    manager:Find('id'):GetComponent('UILabel').text = ''
    manager:Find('name'):GetComponent('UILabel').text = ''
    manager:Find('tx'):GetComponent('UITexture').mainTexture = nil

    obj.transform:Find('time'):GetComponent('UILabel').text = ''
    obj.transform:Find('Fatigue').gameObject:SetActive(false)
    obj.transform:Find('Fatigue'):GetComponent('UILabel').text = '0'
    obj.transform:Find('bianHao').gameObject:SetActive(true)
end

function this.OnClickAgreOrDisagreeButton(go)
    AudioManager.Instance:PlayAudio('btn')
    local msg = Message.New()
    msg.type = proxy_pb.CLUB_USER_MANAGE
    local body = proxy_pb.PClubUserManage()
    body.clubId = panelClub.clubInfo.clubId
    body.userId = GetUserData(go.transform.parent.gameObject).userId
    if go.name == "ButtonAgree" then
        body.operation=proxy_pb.PASS
    else
        body.operation=proxy_pb.REFUSE
    end
    
    print('同意加入'..body.userId)
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RResult()
        b:ParseFromString(msg.body)
        if b.code == 1 then
            this.RefreshMenber()
        end
    end)
end

function this.OnClickFatigue(go)
    AudioManager.Instance:PlayAudio('btn')
    local data = GetUserData(go.transform.parent.gameObject)
    
    if panelClub.clubInfo.gameMode then
        PanelManager.Instance:ShowWindow("panelNetWaitting")
        this.GetPlayerInfo(true,data.userId, function (info)
            PanelManager.Instance:HideWindow("panelNetWaitting")
			local showGiveFatigue = false
			if panelClub.clubInfo.userType ~= proxy_pb.LORD and data.userId == info_login.id then
				showGiveFatigue = true
			end
            PanelManager.Instance:ShowWindow('panelMatchFeeBillRecord', 
                {pageIndex = 1, userId = data.userId, nickname = data.nickname, icon = data.icon, manageId = data.superiorId, userType = data.userType, membership = info.membership ,isShowGiveFatigue=showGiveFatigue})
        end)
        return 
    end

    if IsCanOperatingMenber() or (data.managerId == info_login.id) then
        local shuju={}
        shuju.data = data
        shuju.GO=go
        PanelManager.Instance:ShowWindow('panelFeeBillRecord',shuju)
    else
        panelMessageTip.SetParamers('无法操作自己', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
    end
end

function this.OnMemberSort(go)
    print("OnMemberSort was called");
    local As = go.transform:Find(1);
    local Ds = go.transform:Find(-1);

    local sort
    if As.gameObject.activeSelf then
        sort = true
        Ds.gameObject:SetActive(true)
        As.gameObject:SetActive(false)
    else
        sort = false 
        As.gameObject:SetActive(true)
        Ds.gameObject:SetActive(false)
    end

    for i=1, #MemberSortToggles do
        if MemberSortToggles[i].gameObject ~= go then
            MemberSortToggles[i].transform:Find(1).gameObject:SetActive(false)
            MemberSortToggles[i].transform:Find(-1).gameObject:SetActive(false)
        end
    end

    if go.name == 'Fatigue' then
        SortType = 'balance'
        SortMode = sort and 1 or 0
    elseif go.name == "time" then
        SortMode = sort and 0 or 1
        SortType = "last_login_time";
    end

    this.GetMenberData(true, false, false,true)
end

function this.GetManagerData(NeedInit,NeedInitSearch,NeedInitSort,isSort)
    print('拉取管理员')

    if NeedInit then
        this.InitManager(NeedInitSearch,NeedInitSort);
    end
    local msg       = Message.New()
    msg.type        = proxy_pb.MANAGER_LIST
    local body      = proxy_pb.PManagerList()
    body.clubId     = panelClub.clubInfo.clubId
    body.assign     = false;

    body.page       = managerPage;
    body.pageSize   = managerPageSize;
    print("managerPage:"..managerPage);
    print("managerPageSize:"..managerPageSize);
    print("userType:"..tostring(searchManagerType));
    if currentManagerType then
        body.userType = currentManagerType;
    end
    print('sortManage : '..sortManage..'  sortManageType : '..sortManageType)
    body.sort  = sortManage
    body.column = sortManageType
    msg.body        = body:SerializeToString()
    isManagerSendedRequest = true;
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RManagerList()
        isManagerSendedRequest = false;
        b:ParseFromString(msg.body)
        print('b.lossFeeTotal : '..b.lossFeeTotal)
        print('b.lossFeeTotalScore : '..b.lossFeeTotalScore)
        ManagerFuFeeAveNum:GetComponent('UILabel').text = b.lossFeeTotal..'人'
        ManagerfuFeeValue:GetComponent('UILabel').text = b.lossFeeTotalScore
        if b.manager ~= nil and #b.manager ~= 0 then
            Util.ClearChild(ManagerList:Find('Grid'))
            if isSort then
                ManagerIndexObjData= {}
            end
            print(' #b.manager : '..#b.manager)
            for i = 1, #b.manager do
                local managerData = {index = 0,data = nil};
                managerIndex = managerIndex + 1;
                managerData.index = managerIndex;
                managerData.data = b.manager[i];
                table.insert(ManagerIndexObjData,managerData);
            end

            this.RefreshManagerList(ManagerIndexObjData)
            IsInBottom = #b.manager < managerPageSize;
            --print("set IsInBottom path------------------>1 IsInBottom:"..tostring(IsInBottom));
        else
            if #ManagerIndexObjData == 0 then
                Util.ClearChild(ManagerList:Find('Grid'));
            end

            IsInBottom = true;
        end
    end)
end

function this.RefreshManagerList(datas)
    ManagerObjData = {}
    for i = 1, #datas do
        table.insert(ManagerData,datas[i].data);
    end
    local Grid = ManagerList:Find('Grid')
    Util.ClearChild(Grid)
    print('#datas :'..#datas)
    for i = 1, #datas do
        local obj = NGUITools.AddChild(Grid.gameObject, ManagerPrefab.gameObject).transform
        SetUserData(obj.gameObject, datas[i].data)
        obj:Find('fuFeeMemberNums').gameObject:SetActive(panelClub.clubInfo.gameMode)
        obj:Find('fuFeeValue').gameObject:SetActive(panelClub.clubInfo.gameMode)
        local pos1 = obj:Find('num').localPosition
        pos1.x = panelClub.clubInfo.gameMode and -72 or 245
        obj:Find('num').localPosition = pos1

        local pos2 = obj:Find('feePrecent').localPosition
        pos2.x = panelClub.clubInfo.gameMode and -228 or -72
        obj:Find('feePrecent').localPosition = pos2

        obj.gameObject:SetActive(true)
        
        local player = obj:Find('payer')

        player.transform:Find('id'):GetComponent('UILabel').text        ='id:'..datas[i].data.userId
        player.transform:Find('name'):GetComponent('UILabel').text      =datas[i].data.nickname
        player:Find('State'):Find(datas[i].data.userType).gameObject:SetActive(true)
        obj:Find('num'):GetComponent('UILabel').text                    = datas[i].data.memberSize
        obj:Find('bianHao'):GetComponent('UILabel').text                = i
        obj:Find('feePrecent'):GetComponent('UILabel').text             = datas[i].data.feePrecent..'%'
        coroutine.start(LoadPlayerIcon, player:Find('tx'):GetComponent('UITexture'), datas[i].data.icon)
        message:AddClick(obj:Find('LookInfoBtn').gameObject, this.OnClickManagerLook)

        obj:Find('fuFeeMemberNums'):GetComponent('UILabel').text                    = datas[i].data.lossFeeCount
        obj:Find('fuFeeValue'):GetComponent('UILabel').text                    = datas[i].data.lossFeeScore

        message:AddClick(obj:Find('fuFeeValue').gameObject, this.OnClickManageFuFeeValue)
        obj.transform.localPosition                                     = Vector3(0, -10 * i, 0)
        table.insert(ManagerObjData, obj)
    end

    Grid:GetComponent('UIGrid'):Reposition()

    if managerPage > 1 then
    else
        ManagerList:GetComponent('UIScrollView'):ResetPosition()
    end
end

function this.OnClickManagerLook(go)
    AudioManager.Instance:PlayAudio('btn')
    local data={}
    data.managerData=GetUserData(go.transform.parent.gameObject)
    if panelClub.clubInfo.gameMode then
        PanelManager.Instance:ShowWindow('panelMatchMenberManager', data)
    else
        PanelManager.Instance:ShowWindow('panelMenberManager', data)
    end
end

function this.GetManagerMenaMeneber(go)
    local msg = Message.New()
    msg.type = proxy_pb.MANAGER_MEMBERS
    local body = proxy_pb.PManagerMembers()
    body.clubId = panelClub.clubInfo.clubId
    body.managerId = GetUserData(go.transform.parent.gameObject).userId
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RManagerMembers()
        b:ParseFromString(msg.body)
    
        if b.users ~= nil and #b.users ~= 0 then
            local data={}
            data.MemberList = b.users
            PanelManager.Instance:ShowWindow('panelSelMenber', data)
        else
            panelMessageBoxTiShi.SetParamers(OK_CANCLE, nil, nil, '当前管理员手下并无成员')
            PanelManager.Instance:ShowWindow("panelMessageBoxTiShi")
        end
    end)
end

function this.GetBlackLis()
    print('拉取黑名单')
    local msg = Message.New()
    msg.type = proxy_pb.BLACK_HOUSE_LIST
    local body = proxy_pb.PBlackHouseList()
    body.clubId = panelClub.clubInfo.clubId
	body.userId = blackListPlayerSearch.transform:GetComponent('UILabel').text == '请输入玩家ID' and '' or blackListPlayerSearch.transform:GetComponent('UILabel').text
	body.lossWin = blackListSystemPlayer:GetComponent('UIToggle').value
    msg.body = body:SerializeToString()
    Util.ClearChild(BlackList:Find('Grid'))
    SendProxyMessage(msg, function (msg)
        local data = proxy_pb.RBlackHouseList()
        data:ParseFromString(msg.body);
        this.RefreshBlackList(data.players)
    end)
end

function this.RefreshBlackList(datas)
    print("黑名单人数："..#datas)
    local Grid = BlackList:Find('Grid')
    Util.ClearChild(Grid)
    BlackListPanel.transform:Find('MemberList/Tip/Time').gameObject:SetActive(panelClub.clubInfo.showOtherTime)
    for i=#datas,1,-1 do
        local obj = NGUITools.AddChild(Grid.gameObject, BlackListItem.gameObject)
        obj.transform:Find('Time').gameObject:SetActive(panelClub.clubInfo.showOtherTime)
        obj.transform:Find('Time'):GetComponent('UILabel').text = os.date("%Y.%m.%d %H:%M:%S", datas[i].time)
        coroutine.start(LoadPlayerIcon, obj.transform:Find('Player1/tx'):GetComponent('UITexture'), datas[i].icon)
        obj.transform:Find('Player1/Name'):GetComponent('UILabel').text = datas[i].nickname
        obj.transform:Find('Player1/ID'):GetComponent('UILabel').text = 'ID:'..datas[i].userId
		obj.transform:Find('ButtonRoom').gameObject:SetActive(panelClub.clubInfo.gameMode and datas[i].type == 1)
		
		local str = ''
		obj.transform:Find('Reason/Label'):GetComponent('UILabel').text =  str
		if panelClub.clubInfo.gameMode then 
			if datas[i].type == 1 then
				local content = SplitString(datas[i].content,'|')
				str = '同一天有'..content[3]..'次对局中作为赢家，让输家的负疲劳值达到了群主设置的负疲劳值数'..content[4]..'，被系统自动拉入小黑屋'
			else
				if datas[i].operatorId ~= nil and datas[i].operatorId ~= '' then
					if datas[i].operatorId == panelClub.clubInfo.lordId then
						str = "由群主拉入。"
					else
						str = "由ID："..datas[i].operatorId.." 管理员拉入。"
					end
				end
			end
		else
			str = "剩余疲劳值超出设定最高值。"
			if datas[i].operatorId ~= nil and datas[i].operatorId ~= '' then
				if datas[i].operatorId == panelClub.clubInfo.lordId then
					str = "由群主拉入。"
				else
					str = "由ID："..datas[i].operatorId.." 管理员拉入。"
				end
			end
		end
        obj.transform:Find('Reason/Label'):GetComponent('UILabel').text =  str
        
        obj.gameObject:SetActive(true)
        SetUserData(obj.transform:Find('Button').gameObject, datas[i])
		obj.transform:Find('Button').localPosition = (panelClub.clubInfo.gameMode and datas[i].type == 1) and Vector3(383,13,0) or Vector3(455,13,0)
        message:AddClick(obj.transform:Find('Button').gameObject, this.OnClickRemoveBlackList)
		SetUserData(obj.transform:Find('ButtonRoom').gameObject, datas[i])
		message:AddClick(obj.transform:Find('ButtonRoom').gameObject, this.OnClickButtonRoom)
    end

    Grid:GetComponent('UIGrid'):Reposition()
    BlackList:GetComponent('UIScrollView'):ResetPosition()
end

function this.GetMutexList()
    print('拉取互斥名单')
    local msg = Message.New()
    msg.type = proxy_pb.MUTEX_LIST
    local body=proxy_pb.PMutexList()
	body.clubId=panelClub.clubInfo.clubId
    msg.body = body:SerializeToString()
    Util.ClearChild(MutexList:Find('Grid'))
    SendProxyMessage(msg, function (msg)
        local data = proxy_pb.RMutexList();
        data:ParseFromString(msg.body);
        this.RefreshMutexList(data.players)
    end);
end

function this.RefreshMutexList(datas)
    MutexPanel.transform:Find('MemberList/Tip/Time').gameObject:SetActive(panelClub.clubInfo.showOtherTime)
    local Grid = MutexList:Find('Grid')
    Util.ClearChild(Grid)
    for i = 1, #datas do
        local obj = NGUITools.AddChild(Grid.gameObject, MutexPrefab.gameObject)
        obj.transform:Find('Time').gameObject:SetActive(panelClub.clubInfo.showOtherTime)
        obj.transform:Find('Time'):GetComponent('UILabel').text = os.date("%Y.%m.%d %H:%M:%S", datas[i].time)
        coroutine.start(LoadPlayerIcon, obj.transform:Find('Player1'):GetComponent('UITexture'), datas[i].icon1)
        coroutine.start(LoadPlayerIcon, obj.transform:Find('Player2'):GetComponent('UITexture'), datas[i].icon2)
        obj.transform:Find('Player1/Name'):GetComponent('UILabel').text = datas[i].name1
        obj.transform:Find('Player1/ID'):GetComponent('UILabel').text = 'ID:'..datas[i].userId
        obj.transform:Find('Player2/Name'):GetComponent('UILabel').text = datas[i].name2
        obj.transform:Find('Player2/ID'):GetComponent('UILabel').text = 'ID:'..datas[i].otherUserId
        SetUserData(obj.transform:Find('Button').gameObject, datas[i])
        message:AddClick(obj.transform:Find('Button').gameObject, this.OnRemoveMutexPlayers)
        obj.gameObject:SetActive(true)
    end

    Grid:GetComponent('UIGrid'):Reposition()
    MutexList:GetComponent('UIScrollView'):ResetPosition()
end
--测试服闲聊分享链接
--加入房间 http://t.gzrt8.cn/share/xl/jionRoom.html?roomId={0}&gameType={1} 
--加入俱乐部 http://t.gzrt8.cn/share/xl/jionClub.html?clubId={0}&shareId={1}
function this.RefreshAddMenberPanel()
    SharedUrl= 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx2fbcad4519a7f98f&redirect_uri=http%3A%2F%2F'
    ..panelLogin.HttpUrl..'%2Fshare.html&appType=1&response_type=code&scope=snsapi_userinfo&state='.. userInfo.id ..'|'.. panelClub.clubInfo.clubId..'#wechat_redirect'

    XLSharedUrl='http://'..panelLogin.HttpUrl..'/share/xl/jionClub.html?clubId='..panelClub.clubInfo.clubId..'&shareId='..info_login.id..'&appType=1'
    print('微信分享链接是'..SharedUrl)
    print('闲聊分享链接是'..XLSharedUrl)
    AddMenberInput:GetComponent('UILabel').text = ''
end

function this.IsOperationLord(id)
    if id == panelClub.clubInfo.lordId then
        panelMessageTip.SetParamers('无法操作群主', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        return true
    end

    return false
end

function this.SetToggleName(toggle, text)
    toggle.transform:Find('N/Label'):GetComponent('UILabel').text = text
    toggle.transform:Find('Y/Label'):GetComponent('UILabel').text = text
end

function this.OnClickManageFuFeeValue(go)
    AudioManager.Instance:PlayAudio('btn')
    local data = GetUserData(go.transform.parent.gameObject)
    this.GetManagerMenber(data.userId,true,false)
end