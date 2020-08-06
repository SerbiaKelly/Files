panelMenberRecord = {}
local this = panelMenberRecord;

local gameObject
local message


local nowtimeChuo
local nowtime

local mainTips--主标签栏

this.MenberListData={}--成员数据列表
this.managerListData={}--管理员员数据列表
--查询的条件
local startTime--开始时间
local endTime--结束时间
local page=1--页数 从1开始
local pageSize=20--每页个数
local userId=nil--玩家id
local managerId=nil--管理员id
local playId=nil--玩法id
local roomNumber=nil--房间号
local valid=nil--false=无效 true=有效 空为全部

function this.setSearchData(startT,endT)
    startTime=startT--开始时间
    endTime=endT--结束时间
end

local tipLabel

local recordList----------------群战绩的界面
local ButtonClear--清除疲劳值按钮
local ButtonSearch--高级查询按钮
local ButtonGetRecord--查询按钮
local AdvancedQuery--自定义按钮
local SelectPlay--选择玩法按钮
local SelectMenber--输入成员按钮
local SelectManager--选择管理员按钮
local playPanel--玩法的选择界面
local playGrid--玩法的布局
local playItem--玩法的预制体
local times--时间选择界面
local Tip--标签栏
local objList = {}
local dataList = {}
local sortToggles = {}
local ScrollView--滚动界面
local MemberPrefab--预制体
local recordTime

local recordSortParameter =
{
    type        = "",
    sortType    = nil,
    isRecordInSortState = false,
}

local roomList--------------------------------房间记录界面
local roomListButtonGetRecord--查询按钮
local roomListScrollView--滚动界面
local roomListMemberPrefab--预制体
local roomListToggleLookValid--查看无效场次按钮
local roomListAdvancedQuery--自定义按钮
local roomListSelectPlay--选择玩法按钮
local roomListSelectMenber--输入成员按钮
local roomListSelectRoomID--输入房间号按钮
local roomListPlayPanel--玩法的选择界面
local roomListPlayGrid--玩法的布局
local roomListPlayItem--玩法的预制体
local roomListTimes--时间选择界面

local myFeeList---------------------------我的疲劳值统计
local myFeeListButtonGetRecord--查询按钮
local myFeeListAdvancedQuery--自定义按钮
local myFeeListSelectMenber--输入成员按钮
local myFeeListTimes--时间选择界面
local myFeeListTip--标签栏
local myFeeListObjList = {}
local myFeeListDataList = {}
local myFeeListSortToggles = {}
local myFeeListScrollView--滚动界面
local myFeeListMemberPrefab--预制体
local myFeeListMemberTypePrefab--我的疲劳值统计，成员类型item
local myFeeListPanelMember--我的疲劳值统计，成员类型Grid panel
local myFeeListSelectMemberType--选择成员类型
local myFeeListMemberTypeItemAll;
local myFeeListMemberTypeItemAdmin;
local myFeeListMemberTypeItemViAdmin;
local myFeeListMemberTypeItemAssis;
local myFeeListMemberTypeItemPresident
local myFeeListMemberTypeItemViPresident
local myFeeListMemberTypeItemMember;
local myFeeListSort;
local myFeeListSortType;
local myFeeTime

local managerList----------------管家疲劳值统计
local managerListButtonClear--清除疲劳值按钮
local managerListButtonGetRecord--查询按钮
local managerListAdvancedQuery--自定义按钮
local managerListSelectMenber--输入成员按钮
local managerListTimes--时间选择界面
local managerListTip--标签栏
local managerListObjList = {}
local managerListDataList = {}
local managerListSortToggles = {}
local managerListScrollView--滚动界面
local managerListMemberPrefab--预制体
local managerListMemeberType;--成员类型选择框
local managerListPanelMember;--成员类型弹出框
local managerListTypeItemAll;
local managerListTypeItemAdmin;
local managerListTypeItemViAdmin;
local managerListTypeItemAssis;
local managerListTypeItemPresident
local managerListTypeItemViPresident
local managerListSort
local managerListSortType
local managerTime

local applyList---------------------------申请记录界面
local applyListButtonGetRecord--查询按钮
local applyListAdvancedQuery--自定义按钮
local applyListSelectMenber--输入成员按钮
local applyListTimes--时间选择界面managerList
local applyListScrollView--滚动界面
local applyListMemberPrefab--预制体

local feeBillList---------------------------疲劳值结算界面
local feeBillListScrollView--滚动界面
local feeBillListMemberPrefab--预制体
local feeBillListBillButton--结算按钮
local feeBillListPanelBill--结算界面
local feeBillListPanelBillCloseButton--结算界面关闭按钮
local feeBillListPanelBillAllButton--结算界面allin按钮
local feeBillListPanelBillOkButton--结算界面allin按钮
local feeBillListPanelBillInput--结算界面输入框

local recordData
function this.Awake(obj)
    gameObject = obj;
    message = gameObject:GetComponent('LuaBehaviour');

    mainTips=gameObject.transform:Find('Tips')
    message:AddOnValueChange(mainTips:Find('zhanJiButton').gameObject, this.zhanJiOnclick)
    message:AddOnValueChange(mainTips:Find('roomButton').gameObject, this.roomOnclick)
    message:AddOnValueChange(mainTips:Find('myFeeButton').gameObject, this.myFeeOnclick)
    message:AddOnValueChange(mainTips:Find('feeBillButton').gameObject, this.feeBillOnclick)
    message:AddOnValueChange(mainTips:Find('manageButton').gameObject, this.manageOnclick)
    message:AddOnValueChange(mainTips:Find('applyButton').gameObject, this.applyOnclick)

    recordList = gameObject.transform:Find('recordList')
    roomList = gameObject.transform:Find('roomList')
    myFeeList = gameObject.transform:Find('myFeeList')
    feeBillList = gameObject.transform:Find('feeBillList')
    managerList = gameObject.transform:Find('managerList')
    applyList = gameObject.transform:Find('applyList')
    this.initRecordList()
    this.initRoomList()
    this.initMyFeeListList()
    this.initFeeBillList()
    this.initManagerList()
    this.initApplyList()

    tipLabel = gameObject.transform:Find('tip')

    message:AddClick(gameObject.transform:Find('BaseContent/ButtonClose').gameObject, function (go)
        AudioManager.Instance:PlayAudio('btn')
        local data={}
        data.name=gameObject.name
        for i=0,mainTips.childCount-1 do
            mainTips:GetChild(i):GetComponent('UIToggle'):Set(false)
        end
        if recordData.roomNumFuFeeValue == 0 then
            PanelManager.Instance:ShowWindow('panelClub',data)
        else
            PanelManager.Instance:ShowWindow('panelMessage', 1)
        end
        PanelManager.Instance:HideWindow(gameObject.name)
    end)
end

function this.Update()
    
end

function this.OnEnable()
    print('OnEnable')
    --this.GetMenberData()
    if (not panelClub.clubInfo.gameMode) and panelClub.clubInfo.userType==proxy_pb.LORD then
        this.applyListNum()
    end
end

function this.WhoShow(data)
    recordData = data
    if data.name=='panelClub' then
        print('牌友群打开的')
        this.InitView(0)
        this.initAll()
    elseif data.name=='panelMessage' then
        this.InitView(1)
        this.initAll()
    end
    PanelManager.Instance:HideWindow(data.name)
end

function this.initFeeBillList()

    feeBillListScrollView = feeBillList:Find('Scroll View')
    feeBillListScrollView:GetComponent('UIScrollView').onDragFinished = this.feeBillListOnScroll
    feeBillListMemberPrefab = feeBillList:Find('item')

    feeBillListPanelBill = feeBillList:Find('panelBill')
    feeBillListPanelBillCloseButton = feeBillListPanelBill:Find('BaseContent/ButtonClose')
    message:AddClick(feeBillListPanelBillCloseButton.gameObject, function()
        AudioManager.Instance:PlayAudio('btn')
        feeBillListPanelBill.gameObject:SetActive(false)
    end)
    feeBillListPanelBillAllButton = feeBillListPanelBill:Find('allButton')
    message:AddClick(feeBillListPanelBillAllButton.gameObject, function()
        AudioManager.Instance:PlayAudio('btn')
        feeBillListPanelBillInput:GetComponent('UIInput').value=GetUserData(feeBillListBillButton.gameObject).balanceTotal
    end)

    feeBillListPanelBillOkButton = feeBillListPanelBill:Find('OkButton')
    message:AddClick(feeBillListPanelBillOkButton.gameObject, function()
        local data= GetUserData(feeBillListBillButton.gameObject)
        local value= feeBillListPanelBillInput:GetComponent('UIInput').value
        if data~=nil and value~='' and tonumber(value)>0 then
            AudioManager.Instance:PlayAudio('btn')
            local msg = Message.New()
            msg.type = proxy_pb.MANAGER_SEND_FEE;
            local body = proxy_pb.PManagerSendFee();
            body.clubId = panelClub.clubInfo.clubId;
            body.amount = value;
            msg.body = body:SerializeToString()
            panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
                SendProxyMessage(msg, this.sendFeeResult) 
            end, nil, '确定向群主结算\"'..value..'\"疲劳值？')
            PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
        else
            panelMessageTip.SetParamers('请输入大于0的数值', 1.5)
            PanelManager.Instance:ShowWindow('panelMessageTip')
        end
    end)

    feeBillListPanelBillInput = feeBillListPanelBill:Find('number/Input')

    feeBillListBillButton = feeBillList:Find('billButton')
    message:AddClick(feeBillListBillButton.gameObject, function()
        if feeBillList:Find('Total/lastFatigueNum/Label'):GetComponent('UILabel').text~=''
        and tonumber(feeBillList:Find('Total/lastFatigueNum/Label'):GetComponent('UILabel').text)>0 then
            AudioManager.Instance:PlayAudio('btn')
            feeBillListPanelBill:Find('lastNum/Label'):GetComponent('UILabel').text=GetUserData(feeBillListBillButton.gameObject).balanceTotal
            feeBillListPanelBillInput:GetComponent('UIInput').value=''
            feeBillListPanelBill.gameObject:SetActive(true)
        else
            panelMessageTip.SetParamers('当前剩余分配的疲劳值为0', 1.5)
            PanelManager.Instance:ShowWindow('panelMessageTip')
        end
    end)
end

--操作结果
function this.sendFeeResult(msg)
    local b = proxy_pb.RResult();
    b:ParseFromString(msg.body);
    if b.code==1 then
        this.initAll()
        this.GetFeeBillListDatas()
        feeBillListPanelBill.gameObject:SetActive(false)
		panelMessageTip.SetParamers('发起结算成功', 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	else
		panelMessageTip.SetParamers('发起结算失败'..b.msg, 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	end
end

function this.initApplyList()

    applyListScrollView = applyList:Find('Scroll View')
    applyListScrollView:GetComponent('UIScrollView').onDragFinished = this.applyListOnScroll
    applyListMemberPrefab = applyList:Find('item')

    applyListSelectMenber = applyList:Find('SelectMenber')
    -- message:AddClick(applyListSelectMenber.gameObject, function()
    --     userId=nil
    --     applyListSelectMenber:Find('Label'):GetComponent('UILabel').text='输入成员ID'
    --     this.SelctPlayer(this.MenberListData,function (userId)
    --         applyListSelectMenber:Find('Label'):GetComponent('UILabel').text = panelSelMenber.dictionary[userId]
    --         SetUserData(applyListSelectMenber:Find('Label').gameObject, userId)
    --     end)
    -- end)

    applyListButtonGetRecord = applyList:Find('ButtonGetRecord')
    message:AddClick(applyListButtonGetRecord.gameObject, function()
        this.initAll()
        this.GetApplyListDatas()
    end)

    applyListTimes = applyList:Find('Times')
    applyListAdvancedQuery = applyListTimes:Find('AdvancedQuery')
    message:AddClick(applyListAdvancedQuery.gameObject, this.applyListSelectTime)
    for i=0,2 do
        local toggle = applyListTimes.transform:Find(i):GetComponent('UIToggle')
        message:AddClick(toggle.gameObject,this.applyListOnClickTime)
    end
end

function this.initManagerList()
    managerListTip = managerList:Find('Tip')
    for i=0, 3 do
        local Toggle = managerListTip.transform:Find('table/'..i)
        table.insert(managerListSortToggles, Toggle)
        message:AddClick(Toggle.gameObject, this.managerListOnClickSort)
    end
    managerTime = managerList:Find('Total/time')
    managerListMemeberType      = managerList:Find("SelectMemberType");
    managerListPanelMember      = managerList:Find("panelMemberType");
    managerListTypeItemAll      = managerListPanelMember:Find("Scroll View/Grid/ItemAll");
    managerListTypeItemAdmin    = managerListPanelMember:Find("Scroll View/Grid/Itemadmin");
    managerListTypeItemViAdmin  = managerListPanelMember:Find("Scroll View/Grid/Itemviadmin");
    managerListTypeItemAssis    = managerListPanelMember:Find("Scroll View/Grid/Itemassis");
    managerListTypeItemPresident = managerListPanelMember:Find("Scroll View/Grid/Itempresident");
    managerListTypeItemViPresident = managerListPanelMember:Find("Scroll View/Grid/Itemvicepresident");

    message:AddClick(managerListMemeberType.gameObject,                     this.OnClickManagerListSelectMemberType);
    message:AddClick(managerListPanelMember:Find("Sprite").gameObject, this.OnCloseManagerListMemberTypePanel);
    message:AddClick(managerListTypeItemAll.gameObject,                     this.OnSelectMemberTypeItem);
    message:AddClick(managerListTypeItemAdmin.gameObject,                   this.OnSelectMemberTypeItem);
    message:AddClick(managerListTypeItemViAdmin.gameObject,                 this.OnSelectMemberTypeItem);
    message:AddClick(managerListTypeItemAssis.gameObject,                   this.OnSelectMemberTypeItem);
    message:AddClick(managerListTypeItemPresident.gameObject,                   this.OnSelectMemberTypeItem);
    message:AddClick(managerListTypeItemViPresident.gameObject,                   this.OnSelectMemberTypeItem);
    
    managerListButtonClear = managerList:Find('ButtonClear')
    message:AddClick(managerListButtonClear.gameObject, this.managerListClearFee)

    managerListScrollView = managerList:Find('Scroll View')
    managerListScrollView:GetComponent('UIScrollView').onDragFinished = this.managerListOnScroll
    managerListMemberPrefab = managerList:Find('item')

    managerListSelectMenber = managerList:Find('SelectMenber')
    -- message:AddClick(managerListSelectMenber.gameObject, function()
    --     userId=nil
    --     managerListSelectMenber:Find('Label'):GetComponent('UILabel').text='输入成员ID'
    --     this.SelctPlayer(this.MenberListData,function (userId)
    --         managerListSelectMenber:Find('Label'):GetComponent('UILabel').text = panelSelMenber.dictionary[userId]
    --         SetUserData(managerListSelectMenber:Find('Label').gameObject, userId)
    --     end)
    -- end)

    managerListButtonGetRecord = managerList:Find('ButtonGetRecord')
    message:AddClick(managerListButtonGetRecord.gameObject,function()
        this.initAll()
        this.GetManagerListDatas(nil, nil, true)
    end)

    managerListTimes = managerList:Find('Times')
    managerListAdvancedQuery = managerListTimes:Find('AdvancedQuery')
    message:AddClick(managerListAdvancedQuery.gameObject, this.managerListSelectTime)
    for i=0,2 do
        local toggle = managerListTimes.transform:Find(i):GetComponent('UIToggle')
        message:AddClick(toggle.gameObject,this.managerListOnClickTime)
    end
end

function this.initMyFeeListList()
    myFeeListTip = myFeeList:Find('Tip')
    for i=0, 2 do
        local Toggle = myFeeListTip.transform:Find('table/'..i)
        table.insert(myFeeListSortToggles, Toggle)
        message:AddClick(Toggle.gameObject, this.myFeeListOnClickSort)
    end
    myFeeTime = myFeeList:Find('Total/time')
    myFeeListScrollView = myFeeList:Find('Scroll View')
    myFeeListScrollView:GetComponent('UIScrollView').onDragFinished = this.myFeeListOnScroll
    myFeeListMemberPrefab = myFeeList:Find('item')

    myFeeListSelectMenber = myFeeList:Find('SelectMenber')
    -- message:AddClick(myFeeListSelectMenber.gameObject, function()
    --     userId=nil
    --     myFeeListSelectMenber:Find('Label'):GetComponent('UILabel').text='请选择成员'
    --     this.SelctPlayer(this.MenberListData,function (userId)
    --         myFeeListSelectMenber:Find('Label'):GetComponent('UILabel').text = panelSelMenber.dictionary[userId]
    --         SetUserData(myFeeListSelectMenber:Find('Label').gameObject, userId)
    --     end)
    -- end)

    myFeeListButtonGetRecord = myFeeList:Find('ButtonGetRecord')
    message:AddClick(myFeeListButtonGetRecord.gameObject, function()
        this.initAll()
        this.GetMyFeeListDatas(nil, nil, true)
    end)

    myFeeListTimes = myFeeList:Find('Times')
    myFeeListAdvancedQuery = myFeeListTimes:Find('AdvancedQuery')
    message:AddClick(myFeeListAdvancedQuery.gameObject, this.myFeeListSelectTime)
    for i=0,2 do
        local toggle = myFeeListTimes.transform:Find(i):GetComponent('UIToggle')
        message:AddClick(toggle.gameObject,this.myFeeListOnClickTime)
    end

    myFeeListMemberTypePrefab       = myFeeList:Find("panelMemberType/Item");
    myFeeListPanelMember            = myFeeList:Find("panelMemberType");
    myFeeListSelectMemberType       = myFeeList:Find("SelectMemberType");
    myFeeListMemberTypeItemAll      = myFeeListPanelMember:Find("Scroll View/Grid/ItemAll");
    myFeeListMemberTypeItemAdmin    = myFeeListPanelMember:Find("Scroll View/Grid/Itemadmin");
    myFeeListMemberTypeItemViAdmin  = myFeeListPanelMember:Find("Scroll View/Grid/Itemviadmin");
    myFeeListMemberTypeItemAssis    = myFeeListPanelMember:Find("Scroll View/Grid/Itemassis");
    myFeeListMemberTypeItemPresident = myFeeListPanelMember:Find("Scroll View/Grid/Itempresident")
    myFeeListMemberTypeItemViPresident = myFeeListPanelMember:Find("Scroll View/Grid/Itemvicepresident")
    myFeeListMemberTypeItemMember   = myFeeListPanelMember:Find("Scroll View/Grid/Itemmember");

    message:AddClick(myFeeListSelectMemberType.gameObject,                   this.OnClickMyFeeListSelectMemBerType);
    message:AddClick(myFeeListPanelMember:Find("Sprite").gameObject,    this.OnCloseMyFeeListMemberTypePanel);
    message:AddClick(myFeeListMemberTypeItemAll.gameObject,                  this.OnSelectMemberTypeItem);
    message:AddClick(myFeeListMemberTypeItemAdmin.gameObject,                this.OnSelectMemberTypeItem);
    message:AddClick(myFeeListMemberTypeItemViAdmin.gameObject,              this.OnSelectMemberTypeItem);
    message:AddClick(myFeeListMemberTypeItemAssis.gameObject,                this.OnSelectMemberTypeItem);
    message:AddClick(myFeeListMemberTypeItemPresident.gameObject,            this.OnSelectMemberTypeItem);
    message:AddClick(myFeeListMemberTypeItemViPresident.gameObject,          this.OnSelectMemberTypeItem);
    message:AddClick(myFeeListMemberTypeItemMember.gameObject,               this.OnSelectMemberTypeItem);
end

function this.initRoomList()
    roomListScrollView = roomList:Find('Grid')
    roomListScrollView:GetComponent('UIScrollView').onDragFinished = this.OnRoomListScroll
    roomListMemberPrefab = roomList:Find('item')

    roomListButtonGetRecord = roomList:Find('ButtonGetRecord')
    message:AddClick(roomListButtonGetRecord.gameObject, function()
        this.initAll()
        userId=nil--玩家id
        playId=nil--玩法id
        roomNumber=nil--房间号
        this.GetRoomDatas()
    end)
    roomListToggleLookValid = roomList:Find('Total/ToggleLookValid')
    
    message:AddClick(roomListToggleLookValid.gameObject, this.onclickLookValid)

    roomListSelectPlay = roomList:Find('SelectPlay')
    message:AddClick(roomListSelectPlay.gameObject, this.roomListGetPlay)
    
    roomListSelectMenber = roomList:Find('SelectMenber')
    -- message:AddClick(roomListSelectMenber.gameObject, function()
    --     userId=nil
    --     roomListSelectMenber:Find('Label'):GetComponent('UILabel').text='请选择成员'
    --     this.SelctPlayer(this.MenberListData,function (userId)
    --         roomListSelectMenber:Find('Label'):GetComponent('UILabel').text = panelSelMenber.dictionary[userId]
    --         SetUserData(roomListSelectMenber:Find('Label').gameObject, userId)
    --     end)
    -- end)

    roomListSelectRoomID = roomList:Find('SelectRoomID')
    message:AddClick(roomListSelectRoomID.gameObject, this.GetRoomID)

    roomListPlayPanel = roomList:Find('panel')
    roomListPlayGrid=roomListPlayPanel:Find('Scroll View/Grid')
    roomListPlayItem=roomListPlayPanel:Find('Item')
    message:AddClick(roomListPlayPanel:Find('Sprite').gameObject, this.roomListClosePlayPanel)

    roomListTimes = roomList:Find('Times')
    AdvancedQuery = roomListTimes:Find('AdvancedQuery')
    message:AddClick(AdvancedQuery.gameObject, this.roomListSelectTime)
    for i=0,2 do
        local toggle = roomListTimes.transform:Find(i):GetComponent('UIToggle')
        message:AddClick(toggle.gameObject,this.roomListOnClickTime)
    end
end

function this.GetRoomID(go)
    PanelManager.Instance:ShowWindow('keyborad', gameObject.name)
end
--[[
    @desc: 键盘的回调
    author:{author}
    time:2018-11-21 16:51:06
    --@strNum: 输入的数字
    @return:
]]
function this.setSearchInput(strNum)
    print('输入了'..strNum)
    if strNum~='' then
        roomListSelectRoomID:Find('Label'):GetComponent('UILabel').text=strNum
    else
        roomListSelectRoomID:Find('Label'):GetComponent('UILabel').text='请输入房间号'
    end
end

function this.SelctPlayer(MemberList, func)
    local data = {}
    data.func = func
    data.MemberList = MemberList
    PanelManager.Instance:ShowWindow('panelSelMenber',data)
end

function this.onclickLookValid(go)
    AudioManager.Instance:PlayAudio('btn')
    if roomListToggleLookValid:Find('Checkmark').gameObject.activeSelf==true then
        roomListToggleLookValid:Find('Checkmark').gameObject:SetActive(false)
        valid=nil
        print('关')
    else
        roomListToggleLookValid:Find('Checkmark').gameObject:SetActive(true)
        valid=false
        print('开')
    end
    this.initAll()
    this.GetRoomDatas()
end

--群战绩统计
function this.zhanJiOnclick(go)
    print('按钮触发')
    AudioManager.Instance:PlayAudio('btn')
    this.InitView(0)
    this.initAll()
    this.GetDatas()
end
--房间记录
function this.roomOnclick(go)
    AudioManager.Instance:PlayAudio('btn')
    this.InitView(1)
    this.initAll()
    this.GetRoomDatas()
end
--我的成员疲劳值
function this.myFeeOnclick(go)
    AudioManager.Instance:PlayAudio('btn')
    this.InitView(2)
    this.initAll()
    this.GetMyFeeListDatas(nil, nil, true)
end
--疲劳值结算
function this.feeBillOnclick(go)
    AudioManager.Instance:PlayAudio('btn')
    this.InitView(3)
    this.initAll()
    this.GetFeeBillListDatas()
end
--管理员的成员统计
function this.manageOnclick(go)
    AudioManager.Instance:PlayAudio('btn')
    this.InitView(4)
    this.initAll()
    this.GetManagerListDatas(nil, nil, true)
end
--申请记录
function this.applyOnclick(go)
    AudioManager.Instance:PlayAudio('btn')
    this.InitView(5)
    this.initAll()
    this.GetApplyListDatas()
end

local isNotDownload=true
local isFinish=false
--战绩滑动回调
function this.OnScroll()
    if isNotDownload==true and isFinish==false and ScrollView:GetComponent('UIScrollView').verticalScrollBar.value==1 then
        print('到底了')
        PanelManager.Instance:ShowWindow('panelNetWaitting')
        this.GetDatas()
    end
end
--房间记录滑动回调
function this.OnRoomListScroll()
    if isNotDownload==true and isFinish==false and roomListScrollView:GetComponent('UIScrollView').verticalScrollBar.value==1 then
        print('到底了')
        PanelManager.Instance:ShowWindow('panelNetWaitting')
        this.GetRoomDatas()
    end
end
--我的成员疲劳值滑动回调
function this.myFeeListOnScroll()
    if isNotDownload==true and isFinish==false and myFeeListScrollView:GetComponent('UIScrollView').verticalScrollBar.value==1 then
        print('到底了')
        PanelManager.Instance:ShowWindow('panelNetWaitting')
        this.GetMyFeeListDatas()
    end
end
--管理员的成员统计滑动回调
function this.managerListOnScroll()
    if isNotDownload==true and isFinish==false and managerListScrollView:GetComponent('UIScrollView').verticalScrollBar.value==1 then
        print('到底了')
        PanelManager.Instance:ShowWindow('panelNetWaitting')
        this.GetManagerListDatas()
    end
end
--申请记录界面滑动回调
function this.applyListOnScroll()
    if isNotDownload==true and isFinish==false and applyListScrollView:GetComponent('UIScrollView').verticalScrollBar.value==1 then
        print('到底了')
        PanelManager.Instance:ShowWindow('panelNetWaitting')
        this.GetApplyListDatas()
    end
end
--结算疲劳值界面滑动回调
function this.feeBillListOnScroll()
    if isNotDownload==true and isFinish==false and feeBillListScrollView:GetComponent('UIScrollView').verticalScrollBar.value==1 then
        print('到底了')
        PanelManager.Instance:ShowWindow('panelNetWaitting')
        this.GetFeeBillListDatas()
    end
end

--初始化所有滑动相关
function this.initAll()
    this.initData()
    this.initGrid()
    this.initRoomListGrid()
    this.initMyFeeListGrid()
    this.initFeeBillListGrid()
    this.initManagerListGrid()
    this.initApplyListGrid()
end
--初始化战绩滑动界面
function this.initGrid()
    Util.ClearChild(ScrollView:Find('Grid'))
    ScrollView.localPosition=Vector3(0,6.7,0)
    ScrollView:GetComponent('UIPanel').clipOffset=Vector2(0,-6)
    ScrollView:Find('Grid'):GetComponent('UIGrid'):Reposition()
end
--初始化房间记录滑动界面
function this.initRoomListGrid()
    Util.ClearChild(roomListScrollView)
    roomListScrollView.localPosition=Vector3(0,82,0)
    roomListScrollView:GetComponent('UIPanel').clipOffset=Vector2(0,156)
    roomListScrollView:GetComponent('UIGrid'):Reposition()
end
--初始化我的成员疲劳值滑动界面
function this.initMyFeeListGrid()
    Util.ClearChild(myFeeListScrollView:Find('Grid'))
    myFeeListScrollView.localPosition=Vector3(0,6.7,0)
    myFeeListScrollView:GetComponent('UIPanel').clipOffset=Vector2(0,-6)
    myFeeListScrollView:Find('Grid'):GetComponent('UIGrid'):Reposition()
end
--初始化结算疲劳值滑动界面
function this.initFeeBillListGrid()
    Util.ClearChild(feeBillListScrollView:Find('Grid'))
    feeBillListScrollView.localPosition=Vector3(0,6.7,0)
    feeBillListScrollView:GetComponent('UIPanel').clipOffset=Vector2(0,-6)
    feeBillListScrollView:Find('Grid'):GetComponent('UIGrid'):Reposition()
end
--初始化管理员的成员疲劳值滑动界面
function this.initManagerListGrid()
    Util.ClearChild(managerListScrollView:Find('Grid'))
    managerListScrollView.localPosition=Vector3(0,6.7,0)
    managerListScrollView:GetComponent('UIPanel').clipOffset=Vector2(0,-6)
    managerListScrollView:Find('Grid'):GetComponent('UIGrid'):Reposition()
end
--初始化申请记录滑动界面
function this.initApplyListGrid()
    Util.ClearChild(applyListScrollView:Find('Grid'))
    applyListScrollView.localPosition=Vector3(0,6.7,0)
    applyListScrollView:GetComponent('UIPanel').clipOffset=Vector2(0,-6)
    applyListScrollView:Find('Grid'):GetComponent('UIGrid'):Reposition()
end
--初始化滑动相关数据
function this.initData()
    isFinish=false
    page=1
    --isNotDownload=true
    recordSortParameter.sortType = nil;
    recordSortParameter.type = "";
    recordSortParameter.isRecordInSortState = false;
end

function this.initRecordList()
    Tip = recordList:Find('Tip')
    for i=0, 6 do
        local Toggle = Tip.transform:Find('table/'..i)
        table.insert(sortToggles, Toggle)
        message:AddClick(Toggle.gameObject, this.OnClickSort)
    end
    recordTime = recordList:Find('Total/time')
    ScrollView = recordList:Find('Scroll View')
    ScrollView:GetComponent('UIScrollView').onDragFinished = this.OnScroll
    MemberPrefab = recordList:Find('item')

    ButtonClear = recordList:Find('ButtonClear')
    message:AddClick(ButtonClear.gameObject, this.ClearFee)

    
    ButtonSearch = recordList:Find('ButtonSearch')
    message:AddClick(ButtonSearch.gameObject, function()
        AudioManager.Instance:PlayAudio('btn')
        PanelManager.Instance:ShowWindow('panelSearch')
    end)
    
    ButtonGetRecord = recordList:Find('ButtonGetRecord')
    message:AddClick(ButtonGetRecord.gameObject, function()
        this.initAll()
        this.GetDatas()
    end)

    SelectPlay = recordList:Find('SelectPlay')
    message:AddClick(SelectPlay.gameObject, this.GetPlay)
    
    SelectMenber = recordList:Find('SelectMenber')
    -- message:AddClick(SelectMenber.gameObject, function()
    --     userId=nil
    --     SelectMenber:Find('Label'):GetComponent('UILabel').text='请选择成员'
    --     this.SelctPlayer(this.MenberListData,function (userId)
    --         SelectMenber:Find('Label'):GetComponent('UILabel').text = panelSelMenber.dictionary[userId]
    --         SetUserData(SelectMenber:Find('Label').gameObject, userId)
    --     end)
    -- end)

    SelectManager = recordList:Find('SelectManager')
    message:AddClick(SelectManager.gameObject, this.OnClickSelectManager)

    playPanel = recordList:Find('panel')
    playGrid=playPanel:Find('Scroll View/Grid')
    playItem=playPanel:Find('Item')
    message:AddClick(playPanel:Find('Sprite').gameObject, this.closePlayPanel)

    times = recordList:Find('Times')
    AdvancedQuery = times:Find('AdvancedQuery')
    message:AddClick(AdvancedQuery.gameObject, this.selectTime)
    for i=0,2 do
        local toggle = times.transform:Find(i):GetComponent('UIToggle')
        message:AddClick(toggle.gameObject,this.OnClickTime)
    end
end

function this.OnClickSelectManager(go)
    managerId=nil
    SelectManager:Find('Label'):GetComponent('UILabel').text='请选择管理员'
    local func = function (data)
        managerId=data.userId
        SelectManager:Find('Label'):GetComponent('UILabel').text=data.nickname
    end
    PanelManager.Instance:ShowWindow('panelSelectManager',  {assign = true, func = func})
end

--管理员的成员清除疲劳值
function this.managerListClearFee(go)
    AudioManager.Instance:PlayAudio('btn')
    if managerListScrollView:Find('Grid').childCount>0 then
        local msg = Message.New()
        msg.type = proxy_pb.FEE_RESET;
        local body = proxy_pb.PFeeReset();
        body.clubId = panelClub.clubInfo.clubId;
        body.startTime = startTime;
        body.endTime = endTime;
        if userId~=nil then
            body.userId=userId
        end
        if playId~=nil then
            body.playId=playId
        end
        msg.body = body:SerializeToString()
        panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
            SendProxyMessage(msg, this.managerListClearResult) 
        end, nil, '是否确认清除列表中'..#managerListDataList..'人共计'..managerList:Find('Total/surplusFatigueNum'):GetComponent('UILabel').text..'疲劳值？')
        PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
    else
        panelMessageTip.SetParamers('当前列表没有需要清除的疲劳值', 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
    end
end
--管理员的成员清除结果
function this.managerListClearResult(msg)
    print('managerListClearResult')
	local b = proxy_pb.RResult()
	b:ParseFromString(msg.body)
    if b.code == 1 then
        this.initAll()
        this.GetManagerListDatas()
		panelMessageTip.SetParamers('清除成功', 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	else
		panelMessageTip.SetParamers(b.msg, 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	end
end

--清除疲劳值
function this.ClearFee(go)
    AudioManager.Instance:PlayAudio('btn')
    if ScrollView:Find('Grid').childCount>0 then
        local msg = Message.New()
        msg.type = proxy_pb.FEE_RESET;
        local body = proxy_pb.PFeeReset();
        body.clubId = panelClub.clubInfo.clubId;
        body.startTime = startTime;
        body.endTime = endTime;
        if userId~=nil then
            body.userId=userId
        end
        if playId~=nil then
            body.playId=playId
        end
        msg.body = body:SerializeToString()
        panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
            SendProxyMessage(msg, this.clearResult) 
        end, nil, '是否确认清除列表中'..#dataList..'人共计'..recordList:Find('Total/surplusFatigueNum'):GetComponent('UILabel').text..'疲劳值？')
        PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
    else
        panelMessageTip.SetParamers('当前列表没有需要清除的疲劳值', 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
    end
end

--清除结果
function this.clearResult(msg)
    print('clearResult')
	local b = proxy_pb.RResult()
	b:ParseFromString(msg.body)
    if b.code == 1 then
        this.initAll()
        this.GetDatas()
		panelMessageTip.SetParamers('清除成功', 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	else
		panelMessageTip.SetParamers(b.msg, 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	end
end

--房间记录关闭玩法选择
function this.roomListClosePlayPanel(go)
    roomListPlayPanel.gameObject:SetActive(false)
    Util.ClearChild(roomListPlayGrid)
end
--房间记录选择玩法界面显示
function this.roomListGetPlay(go)
    AudioManager.Instance:PlayAudio('btn')
    roomListSelectPlay:Find('Label'):GetComponent('UILabel').text='请选择玩法'
    playId=nil

    local all = NGUITools.AddChild(roomListPlayGrid.gameObject, roomListPlayItem.gameObject)
    all.transform:Find('Label'):GetComponent('UILabel').text='全部'
    all.transform.gameObject:SetActive(true);
    SetUserData(all.transform.gameObject, '全部')
    message:AddClick(all.gameObject, this.roomListOnclickPlay)

    roomListPlayPanel.gameObject:SetActive(true)
    local index = panelClub.clubInfo.lobby and 2 or 1
    for j = index, #panelClub.clubInfo.plays do
        local obj = NGUITools.AddChild(roomListPlayGrid.gameObject, roomListPlayItem.gameObject)
        obj.transform:Find('Label'):GetComponent('UILabel').text=panelClub.clubInfo.plays[j].name
        obj.transform.gameObject:SetActive(true);
        SetUserData(obj.transform.gameObject, panelClub.clubInfo.plays[j])
        message:AddClick(obj.gameObject, this.roomListOnclickPlay)
    end
    roomListPlayGrid:GetComponent('UIGrid'):Reposition()
    roomListPlayGrid.parent:GetComponent('UIScrollView'):ResetPosition()
end
--房间记录点击玩法
function this.roomListOnclickPlay(go)
    AudioManager.Instance:PlayAudio('btn')
    SetUserData(roomListSelectPlay.gameObject, nil)
    local data = GetUserData(go)
    if data=='全部' then
        roomListSelectPlay:Find('Label'):GetComponent('UILabel').text='全部'
        SetUserData(roomListSelectPlay.gameObject, nil)
    else
        roomListSelectPlay:Find('Label'):GetComponent('UILabel').text=data.name
        SetUserData(roomListSelectPlay.gameObject, data)
    end
    this.roomListClosePlayPanel(go)
end

--关闭玩法选择
function this.closePlayPanel(go)
    playPanel.gameObject:SetActive(false)
    Util.ClearChild(playGrid)
end
--选择玩法界面显示
function this.GetPlay(go)
    SelectPlay:Find('Label'):GetComponent('UILabel').text='请选择玩法'
    playId=nil

    local all = NGUITools.AddChild(playGrid.gameObject, playItem.gameObject)
    all.transform:Find('Label'):GetComponent('UILabel').text='全部'
    all.transform.gameObject:SetActive(true);
    SetUserData(all.transform.gameObject, '全部')
    message:AddClick(all.gameObject, this.onclickPlay)

    playPanel.gameObject:SetActive(true)
    local index = panelClub.clubInfo.lobby and 2 or 1
    for j = index, #panelClub.clubInfo.plays do
        local obj = NGUITools.AddChild(playGrid.gameObject, playItem.gameObject)
        obj.transform:Find('Label'):GetComponent('UILabel').text=panelClub.clubInfo.plays[j].name
        obj.transform.gameObject:SetActive(true);
        SetUserData(obj.transform.gameObject, panelClub.clubInfo.plays[j])
        message:AddClick(obj.gameObject, this.onclickPlay)
    end
    playGrid:GetComponent('UIGrid'):Reposition()
    playGrid.parent:GetComponent('UIScrollView'):ResetPosition()
end
--点击玩法
function this.onclickPlay(go)
    AudioManager.Instance:PlayAudio('btn')
    SetUserData(SelectPlay.gameObject, nil)
    local data = GetUserData(go)
    if data=='全部' then
        SelectPlay:Find('Label'):GetComponent('UILabel').text='全部'
        SetUserData(SelectPlay.gameObject, nil)
    else
        SelectPlay:Find('Label'):GetComponent('UILabel').text=data.name
        SetUserData(SelectPlay.gameObject, data)
    end
    this.closePlayPanel(go)
end

local target=0
--选择自定义时间
function this.selectTime(go)
    target=0
    AudioManager.Instance:PlayAudio('btn')
    for i=0,2 do
        times.transform:Find(i):GetComponent('UIToggle'):Set(false)
    end
    PanelManager.Instance:ShowWindow('panelSelectTime',gameObject.name)
end
--选择自定义时间
function this.myFeeListSelectTime(go)
    target=1
    AudioManager.Instance:PlayAudio('btn')
    for i=0,2 do
        myFeeListTimes.transform:Find(i):GetComponent('UIToggle'):Set(false)
    end
    PanelManager.Instance:ShowWindow('panelSelectTime',gameObject.name)
end
--选择自定义时间
function this.managerListSelectTime(go)
    target=2
    AudioManager.Instance:PlayAudio('btn')
    for i=0,2 do
        managerListTimes.transform:Find(i):GetComponent('UIToggle'):Set(false)
    end
    PanelManager.Instance:ShowWindow('panelSelectTime',gameObject.name)
end
--选择自定义时间
function this.applyListSelectTime(go)
    target=3
    AudioManager.Instance:PlayAudio('btn')
    for i=0,2 do
        applyListTimes.transform:Find(i):GetComponent('UIToggle'):Set(false)
    end
    PanelManager.Instance:ShowWindow('panelSelectTime',gameObject.name)
end
--选择自定义时间
function this.roomListSelectTime(go)
    target=4
    AudioManager.Instance:PlayAudio('btn')
    for i=0,2 do
        roomListTimes.transform:Find(i):GetComponent('UIToggle'):Set(false)
    end
    PanelManager.Instance:ShowWindow('panelSelectTime',gameObject.name)
end
--获取到自定义选择的时间
function this.onSelectTime(startT,endT)
    print('选择了'..startT..'和'..endT)
    startTime=startT
    endTime=endT
    this.initAll()
    local time = os.date('%Y/%m/%d', startTime)..'~'..os.date('%Y/%m/%d', endTime)
    if target==0 then
        recordTime:GetComponent('UILabel').text = panelClub.clubInfo.gameMode and time or ''
        this.GetDatas()
    elseif target==1 then
        myFeeTime:GetComponent('UILabel').text = panelClub.clubInfo.gameMode and time or ''
        this.GetMyFeeListDatas()
    elseif target==2 then
        managerTime:GetComponent('UILabel').text = panelClub.clubInfo.gameMode and time or ''
        this.GetManagerListDatas()
    elseif target==3 then
        this.GetApplyListDatas()
    elseif target==4 then
        this.GetRoomDatas()
    end

end
--拉取玩家
function this.GetMenberData()
    print('拉取玩家')
    PanelManager.Instance:ShowWindow('panelNetWaitting')
    local msg = Message.New()
    msg.type = proxy_pb.CLUB_USER_LIST
    local body = proxy_pb.PClubUserList()
    body.clubId = panelClub.clubInfo.clubId
    body.belongToMe = false 
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RClubUserList()
        b:ParseFromString(msg.body);
        this.MenberListData = b.users
        this.managerListData={}
        for i=1,#b.users do
            if b.users[i].userType==proxy_pb.MANAGER then
                table.insert(this.managerListData,b.users[i])
            end
        end
        print('管理员人数'..#this.managerListData)
        PanelManager.Instance:HideWindow('panelNetWaitting')
    end)
end

--初始化界面
function this.InitView(index)
    nowtimeChuo = os.time()
    nowtime = os.date('%Y/%m/%d', nowtimeChuo)
    roomNumber=nil--房间号
    roomListSelectRoomID:Find('Label'):GetComponent('UILabel').text='请输入房间号'
    userId=nil--玩家id
    SelectMenber:Find('Label'):GetComponent('UILabel').text='输入成员ID'
    myFeeListSelectMenber:Find('Label'):GetComponent('UILabel').text='输入成员ID'
    managerListSelectMenber:Find('Label'):GetComponent('UILabel').text='输入成员ID'
    applyListSelectMenber:Find('Label'):GetComponent('UILabel').text='输入成员ID'
    roomListSelectMenber:Find('Label'):GetComponent('UILabel').text='输入成员ID'
    if recordData.roomNumFuFeeValue ~= 0 then
        roomListSelectRoomID:Find('Label'):GetComponent('UILabel').text = recordData.roomNumFuFeeValue
		roomListSelectMenber:Find('Label'):GetComponent('UILabel').text = recordData.userId
    end
    managerId=nil--管理员id
    SelectManager:Find('Label'):GetComponent('UILabel').text='请选择管理员'
    playId=nil--玩法id
    SelectPlay:Find('Label'):GetComponent('UILabel').text='全部'
    SetUserData(SelectPlay.gameObject, nil)
    roomListSelectPlay:Find('Label'):GetComponent('UILabel').text='全部'
    SetUserData(roomListSelectPlay.gameObject, nil)
    startTime = os.time({year=os.date('%Y', nowtimeChuo),month=os.date('%m', nowtimeChuo),day=os.date('%d', nowtimeChuo),hour='0',min='0'});
    endTime = os.time({year=os.date('%Y', nowtimeChuo),month=os.date('%m', nowtimeChuo),day=os.date('%d', nowtimeChuo),hour='23',min='59'});

    myFeeListSelectMemberType:Find('Label'):GetComponent('UILabel').text='全部';
    managerListMemeberType:Find("Label"):GetComponent("UILabel").text = "全部";

    for i=0,2 do
        times.transform:Find(i):GetComponent('UIToggle'):Set(i==0)
        roomListTimes.transform:Find(i):GetComponent('UIToggle'):Set(i==0)
        myFeeListTimes.transform:Find(i):GetComponent('UIToggle'):Set(i==0)
        managerListTimes.transform:Find(i):GetComponent('UIToggle'):Set(i==0)
        applyListTimes.transform:Find(i):GetComponent('UIToggle'):Set(i==0)
    end
    for i=1, #sortToggles do
        sortToggles[i].transform:Find(1).gameObject:SetActive(false)
        sortToggles[i].transform:Find(-1).gameObject:SetActive(false)
    end
    roomListToggleLookValid:Find('Checkmark').gameObject:SetActive(false)
    valid=nil

    SetUserData(SelectPlay.gameObject,nil)
    SetUserData(feeBillListBillButton.gameObject,nil)

    -- ButtonSearch.gameObject:SetActive(panelClub.clubInfo.userType==proxy_pb.GENERAL)
    if panelClub.clubInfo.userType==proxy_pb.LORD or IsCanOperatingMenber() then
        SelectManager.gameObject:SetActive(true)
        ButtonGetRecord.localPosition=Vector3(-35,196,0)
    else
        SelectManager.gameObject:SetActive(false)
        ButtonGetRecord.localPosition=Vector3(-325,196,0)

    end

    for i=0,mainTips.childCount-1 do
        mainTips:GetChild(i):GetComponent('UIToggle'):Set(i==index)
    end
    local time = nowtime..'~'..nowtime
    recordTime:GetComponent('UILabel').text = panelClub.clubInfo.gameMode and (index == 0 and time or '') or ''
    myFeeTime:GetComponent('UILabel').text = panelClub.clubInfo.gameMode and (index == 2 and time or '') or ''
    managerTime:GetComponent('UILabel').text = panelClub.clubInfo.gameMode and (index == 4 and time or '') or ''
    if panelClub.clubInfo.userType==proxy_pb.GENERAL then --普通玩家
        ButtonClear.gameObject:SetActive(false)
        mainTips:Find('myFeeButton').gameObject:SetActive(false)
        mainTips:Find('feeBillButton').gameObject:SetActive(false)
        mainTips:Find('applyButton').gameObject:SetActive(false)
    elseif panelClub.clubInfo.userType==proxy_pb.MANAGER then -- 管理员
        ButtonClear.gameObject:SetActive(true)
        mainTips:Find('myFeeButton').gameObject:SetActive(true)
        mainTips:Find('feeBillButton').gameObject:SetActive(not panelClub.clubInfo.gameMode)
        mainTips:Find('applyButton').gameObject:SetActive(false)
    elseif panelClub.clubInfo.userType==proxy_pb.LORD then  --群主
        ButtonClear.gameObject:SetActive(true)
        mainTips:Find('myFeeButton').gameObject:SetActive(true)
        mainTips:Find('feeBillButton').gameObject:SetActive(false)
        mainTips:Find('applyButton').gameObject:SetActive(not panelClub.clubInfo.gameMode)
    elseif panelClub.clubInfo.userType == proxy_pb.VICE_MANAGER 
    or panelClub.clubInfo.userType == proxy_pb.ASSISTANT
    or panelClub.clubInfo.userType == proxy_pb.PRESIDENT 
    or panelClub.clubInfo.userType == proxy_pb.VICE_PRESIDENT then--馆长，副馆长，会长，副会长
        mainTips:Find('feeBillButton').gameObject:SetActive(false)
        mainTips:Find('myFeeButton').gameObject:SetActive(panelClub.clubInfo.gameMode);
        mainTips:Find('applyButton').gameObject:SetActive(not panelClub.clubInfo.gameMode)
    end

    this.SetMyFeeListMemberTypeVisibleByType(panelClub.clubInfo.userType);
    this.SetManagerListMemberTypeVisibleByType(panelClub.clubInfo.userType);
    
    if panelClub.clubInfo.gameMode then
        if panelClub.clubInfo.userType == proxy_pb.GENERAL or panelClub.clubInfo.userType == proxy_pb.VICE_PRESIDENT then
            mainTips:Find('manageButton').gameObject:SetActive(false);
        else
            mainTips:Find('manageButton').gameObject:SetActive(true);
        end
    else
        mainTips:Find('manageButton').gameObject:SetActive(panelClub.clubInfo.userType==proxy_pb.LORD);
    end

    myFeeList:Find('Total/xiPai').gameObject:SetActive(panelClub.clubInfo.gameMode and panelClub.clubInfo.userType==proxy_pb.LORD);
    myFeeList:Find('Total/fatigueNum/totalNum'):GetComponent('UILabel').text = panelClub.clubInfo.gameMode and '带来疲劳值：' or '疲劳值：'
    myFeeListTip:Find('table/2'):GetComponent('UILabel').text = panelClub.clubInfo.gameMode and '带来疲劳值' or '分配的疲劳值'
    mainTips:Find('myFeeButton/Y/Label'):GetComponent('UILabel').text = panelClub.clubInfo.gameMode and '我的疲劳值统计' or '我的成员疲劳值'
    mainTips:Find('myFeeButton/N/Label'):GetComponent('UILabel').text = panelClub.clubInfo.gameMode and '我的疲劳值统计' or '我的成员疲劳值'

    managerList:Find('Total/surplusFatigueNum').gameObject:SetActive(not panelClub.clubInfo.gameMode)
    managerList:Find('Total/fatigueNum/totalNum'):GetComponent('UILabel').text = panelClub.clubInfo.gameMode and '分配的疲劳值：' or '疲劳值：'
    managerList.transform:Find('Tip/table/3').gameObject:SetActive(not panelClub.clubInfo.gameMode)
    managerList.transform:Find('Tip/member'):GetComponent('UILabel').text = panelClub.clubInfo.gameMode and '管家' or '管理员'
    mainTips:Find('manageButton/Y/Label'):GetComponent('UILabel').text = panelClub.clubInfo.gameMode and '管家疲劳值统计' or '管理员的\n成员统计'
    mainTips:Find('manageButton/N/Label'):GetComponent('UILabel').text = panelClub.clubInfo.gameMode and '管家疲劳值统计' or '管理员的\n成员统计'

    ButtonClear.gameObject:SetActive(false)
    mainTips:GetComponent('UIGrid'):Reposition()
end

--请求列表数据
function this.GetDatas(go)
    print('isNotDownload : '..tostring(isNotDownload))
    if isNotDownload==false then
        return
    end
    isNotDownload=false
    registerProxyReceive(this.onGetProxyRequest())
    PanelManager.Instance:ShowWindow('panelNetWaitting')
    local userIdLabel=SelectMenber:Find('Label'):GetComponent('UILabel').text
    if userIdLabel=='输入成员ID' then
        userId=nil
    else
        userId=userIdLabel
    end

    local playdata=GetUserData(SelectPlay.gameObject)
    if playdata==nil then
        playId=nil
    else
        playId=playdata.playId
    end

    if not recordSortParameter.isRecordInSortState then
        for i=1, #sortToggles do
            sortToggles[i].transform:Find(1).gameObject:SetActive(false)
            sortToggles[i].transform:Find(-1).gameObject:SetActive(false)
        end
    end

    local msg = Message.New()
    msg.type = proxy_pb.CLUB_RECORD;
    local body = proxy_pb.PClubRecord();
    body.clubId = panelClub.clubInfo.clubId;
    body.startTime = startTime;
    body.endTime = endTime;
    if userId~=nil then
        body.userId=userId
    end
    if managerId~=nil then
        body.managerId=managerId
    end
    if playId~=nil then
        body.playId=playId
    end
    body.page=tostring(page)
    body.pageSize=tostring(pageSize)
    print("page"..page);
    print("pageSize"..pageSize);
    print("recordSortParameter.type:"..tostring(recordSortParameter.type).."|recordSortParameter.sortType"..tostring(recordSortParameter.sortType));

    if recordSortParameter.isRecordInSortState then
        body.order = this.getRecordSortString(recordSortParameter.type);
        body.sort = this.getRecordSortType( recordSortParameter.sortType);
    end

    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RClubRecord()
        b:ParseFromString(msg.body);
        this.RefreshList(b)
    end)
end
--刷新列表
function this.RefreshList(list)
    Tip:Find('table/1').gameObject:SetActive(false)--(list.userType~=proxy_pb.GENERAL)
    Tip:Find('table/2').gameObject:SetActive(false)--(list.userType==proxy_pb.GENERAL)
    Tip:Find('table/5').gameObject:SetActive(false)--(list.userType~=proxy_pb.GENERAL)
    Tip:Find('table'):GetComponent('UIGrid'):Reposition()
    tipLabel.gameObject:SetActive(false)
    if page==1 then
        if #list.datas == 0 then
            tipLabel.gameObject:SetActive(true)
        end
        objList = {}
        dataList = {}
    elseif #list.datas == 0 then
        panelMessageTip.SetParamers('没有更多了', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        isFinish=true
    end
    
    print('s收到长度'..#list.datas)
    local Grid = ScrollView:Find('Grid')
    
    local nowNum=Grid.childCount
    
    for i=1,#list.datas do
        local obj = NGUITools.AddChild(Grid.gameObject, MemberPrefab.gameObject)
        obj.transform:Find('bianHao'):GetComponent('UILabel').text = i+nowNum
        obj.transform:Find('playerName1'):GetComponent('UILabel').text = list.datas[i].nickname
        obj.transform:Find('playerName1/ID'):GetComponent('UILabel').text = 'ID:'..list.datas[i].userId
        coroutine.start(LoadPlayerIcon, obj.transform:Find('playerName1/TX'):GetComponent('UITexture'), list.datas[i].icon)
        obj.transform:Find('table/allNum'):GetComponent('UILabel').text = list.datas[i].times
        -- if  list.userType~=proxy_pb.GENERAL then
        --     local lastFeeNum=obj.transform:Find('table/lastFeeNum')
        --     lastFeeNum.gameObject:SetActive(true)
        --     message:AddClick(lastFeeNum.gameObject,this.lastFeeNumOnclick)
        --     -- obj.transform:Find('table/vaildNum'):GetComponent('UILabel').text = list.datas[i].vaildTimes
        --     lastFeeNum:GetComponent('UILabel').text = list.datas[i].feeBalance
        --     -- obj.transform:Find('table/vaildNum').gameObject:SetActive(true)
        --     obj.transform:Find('table/winNum').gameObject:SetActive(false)
        -- else
            obj.transform:Find('table/winNum'):GetComponent('UILabel').text = list.datas[i].winTimes
            obj.transform:Find('table/vaildNum').gameObject:SetActive(false)
            obj.transform:Find('table/winNum').gameObject:SetActive(false)
            obj.transform:Find('table/lastFeeNum').gameObject:SetActive(false)
        --end
        obj.transform:Find('table/allScore'):GetComponent('UILabel').text = list.datas[i].scores
        obj.transform:Find('table/bigWinNum'):GetComponent('UILabel').text = list.datas[i].bigWinTimes
        obj.transform:Find('table/feeNum'):GetComponent('UILabel').text = list.datas[i].fee

        obj.transform:Find("playerName1/status").gameObject:SetActive(list.datas[i].status==2);
        obj.transform:Find("playerName1/roleLoard").gameObject:SetActive(list.datas[i].userType == proxy_pb.LORD and list.datas[i].status~=2);
        obj.transform:Find("playerName1/roleadmin").gameObject:SetActive(list.datas[i].userType == proxy_pb.MANAGER and list.datas[i].status~=2);
        obj.transform:Find("playerName1/roleviadmin").gameObject:SetActive(list.datas[i].userType == proxy_pb.VICE_MANAGER and list.datas[i].status~=2);
        obj.transform:Find("playerName1/roleassis").gameObject:SetActive(list.datas[i].userType == proxy_pb.ASSISTANT and list.datas[i].status~=2);
        obj.transform:Find("playerName1/rolepresident").gameObject:SetActive(list.datas[i].userType == proxy_pb.PRESIDENT and list.datas[i].status~=2);
        obj.transform:Find("playerName1/rolevipresident").gameObject:SetActive(list.datas[i].userType == proxy_pb.VICE_PRESIDENT and list.datas[i].status~=2);

        SetUserData(obj.gameObject, list.datas[i])
        
        table.insert(objList, obj)
        table.insert(dataList, list.datas[i])
        obj.gameObject:SetActive(true)
        message:AddClick(obj.transform:Find('ButtonLook').gameObject, this.LookData)
        obj.transform:Find('table'):GetComponent('UIGrid'):Reposition()
    end
    for i=0,Grid.childCount-1 do
        Grid:GetChild(i).localPosition = Vector3(0, -(i+nowNum)*Grid:GetComponent('UIGrid').cellHeight, 0)
    end

    local Total = recordList:Find('Total')
    -- if list.userType~=proxy_pb.GENERAL then
    --     Total.transform:Find('bigWinNum').localPosition=Vector3(562,0,0)
    --     Total.transform:Find('fatigueNum').localPosition=Vector3(712,0,0)
    -- else
    --     Total.transform:Find('bigWinNum').localPosition=Vector3(712,0,0)
    --     Total.transform:Find('fatigueNum').localPosition=Vector3(866,0,0)
    -- end
    
    if page==1 then
        Total.transform:Find('userNumTotal'):GetComponent('UILabel').text = list.count..'人'
        -- if list.userType~=proxy_pb.GENERAL then
        --     Total.transform:Find('surplusFatigueNum'):GetComponent('UILabel').text = list.feeBalanceTotal
        --     Total.transform:Find('surplusFatigueNum').gameObject:SetActive(true)
        -- else
        --     Total.transform:Find('surplusFatigueNum').gameObject:SetActive(false)
        -- end
        -- Total.transform:Find('surplusFatigueNum').gameObject:SetActive(list.userType~=proxy_pb.GENERAL)
        Total.transform:Find('bigWinNum'):GetComponent('UILabel').text = this.DefaultString(list.bigWinTimesTotal)
        Total.transform:Find('fatigueNum'):GetComponent('UILabel').text = list.feeTotal
        Total.transform:Find('surplusFatigueNum'):GetComponent('UILabel').text = list.feeBalanceTotal
        Total.transform:Find('totalNum'):GetComponent('UILabel').text = list.times
    end
   

    Grid:GetComponent('UIGrid'):Reposition()
    if page==1 then
        ScrollView:GetComponent('UIScrollView'):ResetPosition()
    end
    print('当前页数'..page)
    page=list.page
    print('下一页'..page)
    PanelManager.Instance:HideWindow('panelNetWaitting')
    isNotDownload=true
    
end

function this.lastFeeNumOnclick(go)
    local shuju={}
    shuju.data=GetUserData(go.transform.parent.parent.gameObject)
    shuju.GO=go
    PanelManager.Instance:ShowWindow('panelFeeBillRecord',shuju)

end

--请求房间记录列表数据
function this.GetRoomDatas(go)
    if isNotDownload==false then
        return
    end
    isNotDownload=false
    registerProxyReceive(this.onGetProxyRequest())
    PanelManager.Instance:ShowWindow('panelNetWaitting')
    local userIdLabel=roomListSelectMenber:Find('Label'):GetComponent('UILabel').text
    if userIdLabel=='输入成员ID' then
        userId=nil
    else
        userId=userIdLabel
    end
    local roomIdLabel=roomListSelectRoomID:Find('Label'):GetComponent('UILabel').text
    if roomIdLabel=='请输入房间号' then
        roomNumber=nil
    else
        roomNumber=roomIdLabel
    end
    local playData=GetUserData(roomListSelectPlay.gameObject)
    if playData==nil then
        playId=nil
    else
        playId=playData.playId
    end
    

    local msg = Message.New()
    msg.type = proxy_pb.ROOM_LIST;
    local body = proxy_pb.PRoomList();
    body.clubId = panelClub.clubInfo.clubId;
    body.startTime = startTime;
    body.endTime = endTime;
    if userId~=nil then
        body.userId=userId
    end
    if playId~=nil then
        body.playId=playId
    end
    if roomNumber~=nil then
        body.roomNumber=roomNumber
    end
    if valid~=nil then
        body.valid = valid
    end
    body.page=tostring(page)
    print('房间记录查询页数'..body.page)
    body.pageSize=tostring(pageSize)
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RRoomList()
        b:ParseFromString(msg.body);
        this.RefreshRoomList(b)
    end)
end
--刷新房间记录列表
function this.RefreshRoomList(list)
    tipLabel.gameObject:SetActive(false)
    if page==1 then
        if #list.rooms == 0 then
            tipLabel.gameObject:SetActive(true)
        end
    elseif #list.rooms == 0 then
        panelMessageTip.SetParamers('没有更多了', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        isFinish=true
    end
    
    print('s收到长度'..#list.rooms)
    local Grid = roomListScrollView

    local nowNum=Grid.childCount
    
    for i=1,#list.rooms do
        local obj = NGUITools.AddChild(Grid.gameObject, roomListMemberPrefab.gameObject)
        obj.transform:Find('bianHao'):GetComponent('UILabel').text = i+nowNum
        obj.transform:Find('roomid'):GetComponent('UILabel').text = '房间号：'..list.rooms[i].roomNumber
        obj.transform:Find('nameid'):GetComponent('UILabel').text = '玩法：'..list.rooms[i].playName
        obj.transform:Find('consumediamand'):GetComponent('UILabel').text = '消耗钻石：'..list.rooms[i].diamonds
        obj.transform:Find('feeNum'):GetComponent('UILabel').text = panelClub.clubInfo.gameMode and '大赢家疲劳值：'..list.rooms[i].fee or '疲劳值：'..list.rooms[i].fee
		local showBigWin = false
		if panelClub.clubInfo.userType==proxy_pb.GENERAL then
			showBigWin = panelClub.clubInfo.showBigWin
		else
			showBigWin = true
		end
		obj.transform:Find('feeNum').gameObject:SetActive(showBigWin)
        obj.transform:Find('time'):GetComponent('UILabel').text = os.date('时间：%Y/%m/%d %H:%M', list.rooms[i].time);
		
		obj.transform:Find('dismiss'):GetComponent('UISprite').spriteName = ByDissolutionTypeGetSpriteName(list.rooms[i].dissolutionType)


        local maxIndex = 1
        --local maxScore=math.max(RecordList.rooms[i].players[1].score,RecordList.rooms[i].players[2].score,RecordList.rooms[i].players[3].score)
        local maxScore = 0
        for j = 1, #list.rooms[i].players do
            if maxScore < list.rooms[i].players[j].score then
                maxScore = list.rooms[i].players[j].score
                maxIndex = j
            end
        end

        for j = 1, 4 do
            if j <= #list.rooms[i].players then
               local player=obj.transform:Find('playerName'..j)
               coroutine.start(LoadPlayerIcon, player:Find('TX'):GetComponent('UITexture'), list.rooms[i].players[j].icon)
               player:GetComponent('UILabel').text=list.rooms[i].players[j].name
               player:Find('num'):GetComponent('UILabel').text=list.rooms[i].players[j].score
               if tonumber(list.rooms[i].players[j].score)<0 then
                    player:Find('num'):GetComponent('UILabel').color=Color(3/255,68/255,176/255)
                else
                    player:Find('num'):GetComponent('UILabel').color=Color(214/255,18/255,0/255)
               end
            --    if maxScore==list.rooms[i].score then
            --         --player:Find('winner').gameObject:SetActive(true)
            --         maxIndex = j
            --    end
           else
                obj.transform:Find('playerName'..j).gameObject:SetActive(false)
           end
       end

        SetUserData(obj.gameObject, list.rooms[i])
        
        
        obj.gameObject:SetActive(true)
        message:AddClick(obj.transform:Find('ButtonLook').gameObject, this.roomListLookData)
        
        if not this.IsAllZero(list.rooms[i].players) then
            obj.transform:Find('playerName'..maxIndex):Find('winner').gameObject:SetActive(true)
        end
    end
    for i=0,Grid.childCount-1 do
        Grid:GetChild(i).localPosition = Vector3(0, -(i+nowNum)*Grid:GetComponent('UIGrid').cellHeight, 0)
    end

    print('总场次'..list.count)
    print('有效场次'..list.validCount)
    print('消耗总钻石'..list.diamondTotal)
    print('总疲劳值'..list.feeTotal)
    local Total = roomList:Find('Total')
    if page==1 then
        Total.transform:Find('totalNum'):GetComponent('UILabel').text = list.count
        Total.transform:Find('validNum'):GetComponent('UILabel').text = list.validCount
        Total.transform:Find('xiaoHaoNum'):GetComponent('UILabel').text = list.diamondTotal
		local showBigWin = false
		if panelClub.clubInfo.userType==proxy_pb.GENERAL then
			showBigWin = panelClub.clubInfo.showBigWin
		else
			showBigWin = true
		end
		Total.transform:Find('fatigueNum').gameObject:SetActive(showBigWin)
        Total.transform:Find('fatigueNum'):GetComponent('UILabel').text = list.feeTotal
    end
    

    Grid:GetComponent('UIGrid'):Reposition()
    if page==1 then
        roomListScrollView:GetComponent('UIScrollView'):ResetPosition()
    end
    print('当前页数'..page)
    page=list.page
    print('下一页'..page)
    PanelManager.Instance:HideWindow('panelNetWaitting')
    isNotDownload=true
end

function this.IsAllZero(players)
    for i=1,#players do
        if players[i].score ~= 0 then
            return false
        end
    end

    return true
end
--获取待结算的申请记录条数
function this.applyListNum()
    local msg = Message.New()
    msg.type = proxy_pb.FEE_NEED_CLEAR_AMOUNT;
    local body = proxy_pb.PFeeNeedClearAmount();
    body.clubId = panelClub.clubInfo.clubId;
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, this.applyListResult)
end

--获取到的申请记录条数
function this.applyListResult(msg)
    local b = proxy_pb.RFeeNeedClearAmount()
    b:ParseFromString(msg.body);
    print('获取到的申请记录条数'..b.amount)
    local diandian=mainTips:Find('applyButton/num')
    if b.amount==0 then
        diandian.gameObject:SetActive(false)
    else
        diandian:GetComponent('UILabel').text=b.amount
        diandian.gameObject:SetActive(true)
    end
end

--管理员查看疲劳值结算申请记录
function this.GetFeeBillListDatas(go)
    if isNotDownload==false then
        return
    end
    isNotDownload=false
    registerProxyReceive(this.onGetProxyRequest())
    PanelManager.Instance:ShowWindow('panelNetWaitting')
    local msg = Message.New()
    msg.type = proxy_pb.MANAGER_FEE_RECORD;
    local body = proxy_pb.PClubUserFeeBill();
    body.clubId = panelClub.clubInfo.clubId;
    body.type = '2002';   -- 1000: "下级玩家贡献" 1001, "玩家自己贡献给自己" 2001: "管理员扣减" 2002: "群主结算"       疲劳值结算和申请记录都是2002     扣除记录是2001
    body.page=tostring(page)
    body.pageSize=tostring(pageSize)
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RClubUserFeeBillList()
        b:ParseFromString(msg.body);
        this.RefreshFeeBillList(b)
    end)
end
--刷新列表
function this.RefreshFeeBillList(list)
    tipLabel.gameObject:SetActive(false)
    if page==1 then
        if #list.datas == 0 then
            tipLabel.gameObject:SetActive(true)
        end
    elseif #list.datas == 0 then
        panelMessageTip.SetParamers('没有更多了', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        isFinish=true
    end
    
    print('s收到长度'..#list.datas)
    SetUserData(feeBillListBillButton.gameObject, list)
    local Grid = feeBillListScrollView:Find('Grid')
    
    local nowNum=Grid.childCount
    
    for i=1,#list.datas do
        local obj = NGUITools.AddChild(Grid.gameObject, feeBillListMemberPrefab.gameObject)
        obj.transform:Find('time'):GetComponent('UILabel').text = os.date('%Y.%m.%d\n%H:%M', list.datas[i].createTime)
        obj.transform:Find('playerName1'):GetComponent('UILabel').text = list.datas[i].nickname
        obj.transform:Find('playerName1/ID'):GetComponent('UILabel').text = list.datas[i].userId
        coroutine.start(LoadPlayerIcon, obj.transform:Find('playerName1/TX'):GetComponent('UITexture'), list.datas[i].icon)

        obj.transform:Find('table/feeNum'):GetComponent('UILabel').text = list.datas[i].amount
        obj.transform:Find('table/lastFee'):GetComponent('UILabel').text = list.datas[i].balance
        if list.datas[i].status=='1' then
            obj.transform:Find('table/state'):GetComponent('UILabel').text = '已结算'
            obj.transform:Find('table/state'):GetComponent('UILabel').color = Color(3/255,68/255,176/255)
        else
            obj.transform:Find('table/state'):GetComponent('UILabel').text = '未结算'
            obj.transform:Find('table/state'):GetComponent('UILabel').color = Color(211/255,17/255,2/255)
        end

        
        obj.gameObject:SetActive(true)
    end
    for i=0,Grid.childCount-1 do
        Grid:GetChild(i).localPosition = Vector3(0, -(i+nowNum)*Grid:GetComponent('UIGrid').cellHeight, 0)
    end

    local Total = feeBillList:Find('Total')
    if page==1 then
        Total.transform:Find('fatigueNum/Label'):GetComponent('UILabel').text = list.sendTotal
        Total.transform:Find('lastFatigueNum/Label'):GetComponent('UILabel').text = list.balanceTotal
    end
    

    Grid:GetComponent('UIGrid'):Reposition()
    if page==1 then
        feeBillListScrollView:GetComponent('UIScrollView'):ResetPosition()
    end
    print('当前页数'..page)
    page=list.page
    print('下一页'..page)
    PanelManager.Instance:HideWindow('panelNetWaitting')
    isNotDownload=true
end

--群主查看疲劳值结算申请记录
function this.GetApplyListDatas(go)
    if isNotDownload==false then
        return
    end
    isNotDownload=false
    registerProxyReceive(this.onGetProxyRequest())
    PanelManager.Instance:ShowWindow('panelNetWaitting')
    local userIdLabel=applyListSelectMenber:Find('Label'):GetComponent('UILabel').text
    if userIdLabel=='输入成员ID' then
        userId=nil
    else
        userId=userIdLabel
    end

    local msg = Message.New()
    msg.type = proxy_pb.LORD_CLEAR_RECORD;
    local body = proxy_pb.PClubUserFeeBill();
    body.clubId = panelClub.clubInfo.clubId;
    body.type = '2002';   -- 1000: "下级玩家贡献" 1001, "玩家自己贡献给自己" 2001: "管理员扣减" 2002: "群主结算"       疲劳值结算和申请记录都是2002     扣除记录是2001
    body.page=tostring(page)
    body.pageSize=tostring(pageSize)
    if userId~=nil then
        body.userId=userId
    end
    body.startTime=startTime
    body.endTime=endTime
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RClubUserFeeBillList()
        b:ParseFromString(msg.body);
        this.RefreshApplyList(b)
    end)
end
--刷新列表
function this.RefreshApplyList(list)
    tipLabel.gameObject:SetActive(false)
    if page==1 then
        if #list.datas == 0 then
            tipLabel.gameObject:SetActive(true)
        end
    elseif #list.datas == 0 then
        panelMessageTip.SetParamers('没有更多了', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        isFinish=true
    end
    
    print('s收到长度'..#list.datas)
    local Grid = applyListScrollView:Find('Grid')
    
    local nowNum=Grid.childCount
    
    for i=1,#list.datas do
        local obj = NGUITools.AddChild(Grid.gameObject, applyListMemberPrefab.gameObject)
        obj.transform:Find('bianHao'):GetComponent('UILabel').text = i+nowNum
        obj.transform:Find('time'):GetComponent('UILabel').text = os.date('%Y.%m.%d\n%H:%M', list.datas[i].createTime)
        obj.transform:Find('playerName1'):GetComponent('UILabel').text = list.datas[i].nickname
        obj.transform:Find('playerName1/ID'):GetComponent('UILabel').text = list.datas[i].userId
        coroutine.start(LoadPlayerIcon, obj.transform:Find('playerName1/TX'):GetComponent('UITexture'), list.datas[i].icon)

        obj.transform:Find('table/feeNum'):GetComponent('UILabel').text = list.datas[i].amount

        if list.datas[i].status=='1' then
            obj.transform:Find('table/state'):GetComponent('UILabel').text = '已结算'
            obj.transform:Find('ButtonLook').gameObject:SetActive(false)
        else
            obj.transform:Find('table/state'):GetComponent('UILabel').text = '未结算'
            obj.transform:Find('ButtonLook').gameObject:SetActive(true)
            message:AddClick(obj.transform:Find('ButtonLook').gameObject, this.applyListLookData)
        end

        SetUserData(obj.gameObject, list.datas[i])
        
        obj.gameObject:SetActive(true)
    end
    for i=0,Grid.childCount-1 do
        Grid:GetChild(i).localPosition = Vector3(0, -(i+nowNum)*Grid:GetComponent('UIGrid').cellHeight, 0)
    end

    local Total = applyList:Find('Total')
    if page==1 then
        Total.transform:Find('fatigueNum'):GetComponent('UILabel').text = list.sendTotal
    end
    

    Grid:GetComponent('UIGrid'):Reposition()
    if page==1 then
        applyListScrollView:GetComponent('UIScrollView'):ResetPosition()
    end
    print('当前页数'..page)
    page=list.page
    print('下一页'..page)
    PanelManager.Instance:HideWindow('panelNetWaitting')
    isNotDownload=true
end
--请求管理员的成员疲劳值列表数据
function this.GetManagerListDatas(sort, sortType, needInit)
    if isNotDownload==false then
        return
    end
    isNotDownload=false
    registerProxyReceive(this.onGetProxyRequest())
    PanelManager.Instance:ShowWindow('panelNetWaitting')


    local userIdLabel=managerListSelectMenber:Find('Label'):GetComponent('UILabel').text
    if userIdLabel=='输入成员ID' then
        userId=nil
    else
        userId=userIdLabel
    end

    if needInit then
        for i=1, #managerListSortToggles do
            managerListSortToggles[i].transform:Find(1).gameObject:SetActive(false)
            managerListSortToggles[i].transform:Find(-1).gameObject:SetActive(false)
        end
        managerListSort = nil
        managerListSortType = nil
    end

    if sort ~= nil then
        managerListSort = sort
    end

    if sortType ~= nil then
        managerListSortType = sortType
    end

    local questUserTypeString = managerListMemeberType:Find("Label"):GetComponent("UILabel").text;
    local questUserType = nil;
    if questUserTypeString == "管理" then questUserType = proxy_pb.MANAGER end;
    if questUserTypeString == "馆长" then questUserType = proxy_pb.VICE_MANAGER end;
    if questUserTypeString == "副馆长" then questUserType = proxy_pb.ASSISTANT end;
    if questUserTypeString == "会长" then questUserType = proxy_pb.PRESIDENT end;
    if questUserTypeString == "副会长" then questUserType = proxy_pb.VICE_PRESIDENT end;

    local msg = Message.New()
    msg.type = proxy_pb.LORD_MANAGER_FEE;
    local body = proxy_pb.PClubRecord();
    body.clubId = panelClub.clubInfo.clubId;
    body.startTime =startTime
    body.endTime =endTime
    if userId~=nil then
        body.userId=userId
    end
    if questUserType ~= nil then
        body.clubUserType = questUserType;
    end

    if managerListSort ~= nil then
        body.order = managerListSort
        body.sort = managerListSortType

        print('body.order', body.order, 'body.sort', body.sort)
    end

    body.page=tostring(page)
    body.pageSize=tostring(pageSize)
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RClubRecord()
        b:ParseFromString(msg.body);
        this.RefreshManagerList(b)
    end)
end
--刷新列表
function this.RefreshManagerList(list)
    tipLabel.gameObject:SetActive(false)
    if page==1 then
        if #list.datas == 0 then
            tipLabel.gameObject:SetActive(true)
        end
        managerListObjList = {}
        managerListDataList = {}
    elseif #list.datas == 0 then
        panelMessageTip.SetParamers('没有更多了', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        isFinish=true
    end
    
    print('s收到长度'..#list.datas)
    local Grid = managerListScrollView:Find('Grid')
    
    local nowNum=Grid.childCount
    
    for i=1,#list.datas do
        local obj = NGUITools.AddChild(Grid.gameObject, managerListMemberPrefab.gameObject)
        obj.transform:Find('bianHao'):GetComponent('UILabel').text = i+nowNum
        obj.transform:Find('playerName1'):GetComponent('UILabel').text = list.datas[i].nickname
        obj.transform:Find('playerName1/ID'):GetComponent('UILabel').text = list.datas[i].userId
        coroutine.start(LoadPlayerIcon, obj.transform:Find('playerName1/TX'):GetComponent('UITexture'), list.datas[i].icon)

        obj.transform:Find('table/allNum'):GetComponent('UILabel').text = list.datas[i].times
        obj.transform:Find('table/vaildNum'):GetComponent('UILabel').text = list.datas[i].vaildTimes
        obj.transform:Find('table/feeNum'):GetComponent('UILabel').text = list.datas[i].fee
        obj.transform:Find('table/lastFeeNum'):GetComponent('UILabel').text = list.datas[i].feeBalance

        -- 设置用户角色
        obj.transform:Find("playerName1/status").gameObject:SetActive(list.datas[i].status==2);
        obj.transform:Find("playerName1/roleLoard").gameObject:SetActive(list.datas[i].userType == proxy_pb.LORD and list.datas[i].status~=2);
        obj.transform:Find("playerName1/roleadmin").gameObject:SetActive(list.datas[i].userType == proxy_pb.MANAGER and list.datas[i].status~=2);
        obj.transform:Find("playerName1/roleviadmin").gameObject:SetActive(list.datas[i].userType == proxy_pb.VICE_MANAGER and list.datas[i].status~=2);
        obj.transform:Find("playerName1/roleassis").gameObject:SetActive(list.datas[i].userType == proxy_pb.ASSISTANT and list.datas[i].status~=2);
        obj.transform:Find("playerName1/rolepresident").gameObject:SetActive(list.datas[i].userType == proxy_pb.PRESIDENT and list.datas[i].status~=2);
        obj.transform:Find("playerName1/rolevipresident").gameObject:SetActive(list.datas[i].userType == proxy_pb.VICE_PRESIDENT and list.datas[i].status~=2);

        if panelClub.clubInfo.gameMode then
            obj.transform:Find('table/lastFeeNum').gameObject:SetActive(false)
        end

        -- message:AddClick(obj.transform:Find('table/lastFeeNum').gameObject,this.lastFeeNumOnclick)

        SetUserData(obj.gameObject, list.datas[i])
        
        table.insert(managerListObjList, obj)
        table.insert(managerListDataList, list.datas[i])
        obj.gameObject:SetActive(true)
        message:AddClick(obj.transform:Find('ButtonLook').gameObject, this.managerListLookData)
    end
    for i=0,Grid.childCount-1 do
        Grid:GetChild(i).localPosition = Vector3(0, -(i+nowNum)*Grid:GetComponent('UIGrid').cellHeight, 0)
    end

    local Total = managerList:Find('Total')
    if page==1 then
        Total.transform:Find('fatigueNum'):GetComponent('UILabel').text = list.feeTotal
        Total.transform:Find('surplusFatigueNum'):GetComponent('UILabel').text = list.feeBalanceTotal
        
        Total.transform:Find('peopleNum'):GetComponent('UILabel').text = list.count..'人'
        Total.transform:Find('totalNum'):GetComponent('UILabel').text = list.times
        Total.transform:Find('fieldNum'):GetComponent('UILabel').text = list.validTimesTotal
    end
    

    Grid:GetComponent('UIGrid'):Reposition()
    if page==1 then
        managerListScrollView:GetComponent('UIScrollView'):ResetPosition()
    end
    print('当前页数'..page)
    page=list.page
    print('下一页'..page)
    PanelManager.Instance:HideWindow('panelNetWaitting')
    isNotDownload=true
end
--请求我的成员疲劳值列表数据
function this.GetMyFeeListDatas(sort, sortType, needInit)
    if isNotDownload==false then
        return
    end
    isNotDownload=false
    registerProxyReceive(this.onGetProxyRequest())
    PanelManager.Instance:ShowWindow('panelNetWaitting')
    local userIdLabel= myFeeListSelectMenber:Find('Label'):GetComponent('UILabel').text
    if userIdLabel=='输入成员ID' then
        userId=nil
    else
        userId=userIdLabel
    end
    if needInit then
        for i=1, #myFeeListSortToggles do
            myFeeListSortToggles[i].transform:Find(1).gameObject:SetActive(false)
            myFeeListSortToggles[i].transform:Find(-1).gameObject:SetActive(false)
        end
        myFeeListSort = nil
        myFeeListSortType = nil
    end

    if sort ~= nil then
        myFeeListSort = sort
    end

    if sortType ~= nil then
        myFeeListSortType = sortType
    end

    local questUserTypeString = myFeeListSelectMemberType:Find("Label"):GetComponent("UILabel").text;
    local questUserType = nil;
    if questUserTypeString == "管理" then questUserType = proxy_pb.MANAGER end;
    if questUserTypeString == "馆长" then questUserType = proxy_pb.VICE_MANAGER end;
    if questUserTypeString == "副馆长" then questUserType = proxy_pb.ASSISTANT end;
    if questUserTypeString == "会长" then questUserType = proxy_pb.PRESIDENT end;
    if questUserTypeString == "副会长" then questUserType = proxy_pb.VICE_PRESIDENT end;
    if questUserTypeString == "成员" then questUserType = proxy_pb.GENERAL end;

    local msg = Message.New()
    msg.type = proxy_pb.MEMBERS_FEE;
    local body = proxy_pb.PClubRecord();
    body.clubId = panelClub.clubInfo.clubId;
    body.startTime =startTime
    body.endTime =endTime

    if myFeeListSort ~= nil then
        body.order = myFeeListSort
        body.sort = myFeeListSortType

        print('body.order', body.order, 'body.sort', body.sort)
    end

    if userId~=nil then
        body.userId=userId
    end
    -- 服务端现在还没有接口
    if questUserType ~= nil then
        body.clubUserType = questUserType;
    end

    body.page=tostring(page)
    body.pageSize=tostring(pageSize)
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RClubRecord()
        b:ParseFromString(msg.body);
        this.RefreshMyFeeList(b)
    end)
end
--刷新列表
function this.RefreshMyFeeList(list)
    tipLabel.gameObject:SetActive(false)
    if page==1 then
        if #list.datas == 0 then
            tipLabel.gameObject:SetActive(true)
        end
        myFeeListObjList = {}
        myFeeListDataList = {}
    elseif #list.datas == 0 then
        panelMessageTip.SetParamers('没有更多了', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        isFinish=true
    end
    
    print('s收到长度'..#list.datas)
    local Grid = myFeeListScrollView:Find('Grid')
    
    local nowNum=Grid.childCount
    
    for i=1,#list.datas do
        local obj = NGUITools.AddChild(Grid.gameObject, myFeeListMemberPrefab.gameObject)
        obj.transform:Find('bianHao'):GetComponent('UILabel').text = i+nowNum
        obj.transform:Find('playerName1'):GetComponent('UILabel').text = list.datas[i].nickname
        obj.transform:Find('playerName1/ID'):GetComponent('UILabel').text = 'ID:'..list.datas[i].userId
        coroutine.start(LoadPlayerIcon, obj.transform:Find('playerName1/TX'):GetComponent('UITexture'), list.datas[i].icon)

        obj.transform:Find('table/allNum'):GetComponent('UILabel').text = list.datas[i].times
        obj.transform:Find('table/vaildNum'):GetComponent('UILabel').text = list.datas[i].vaildTimes
        obj.transform:Find('table/feeNum'):GetComponent('UILabel').text = list.datas[i].fee

        -- 设置用户角色
        obj.transform:Find("playerName1/status").gameObject:SetActive(list.datas[i].status==2);
        obj.transform:Find("playerName1/roleLoard").gameObject:SetActive(list.datas[i].userType == proxy_pb.LORD and list.datas[i].status~=2 );
        obj.transform:Find("playerName1/roleadmin").gameObject:SetActive(list.datas[i].userType == proxy_pb.MANAGER and list.datas[i].status~=2);
        obj.transform:Find("playerName1/roleviadmin").gameObject:SetActive(list.datas[i].userType == proxy_pb.VICE_MANAGER and list.datas[i].status~=2);
        obj.transform:Find("playerName1/roleassis").gameObject:SetActive(list.datas[i].userType == proxy_pb.ASSISTANT and list.datas[i].status~=2);
        obj.transform:Find("playerName1/rolepresident").gameObject:SetActive(list.datas[i].userType == proxy_pb.PRESIDENT and list.datas[i].status~=2);
        obj.transform:Find("playerName1/rolevipresident").gameObject:SetActive(list.datas[i].userType == proxy_pb.VICE_PRESIDENT and list.datas[i].status~=2);

        SetUserData(obj.gameObject, list.datas[i])
        
        table.insert(myFeeListObjList, obj)
        table.insert(myFeeListDataList, list.datas[i])
        obj.gameObject:SetActive(true)
        message:AddClick(obj.transform:Find('ButtonLook').gameObject, this.myFeeListLookData)
    end
    for i=0,Grid.childCount-1 do
        Grid:GetChild(i).localPosition = Vector3(0, -(i+nowNum)*Grid:GetComponent('UIGrid').cellHeight, 0)
    end

    local Total = myFeeList:Find('Total')
    if page==1 then
        Total.transform:Find('userNumTotal'):GetComponent('UILabel').text = list.count..'人'
        Total.transform:Find('fatigueNum'):GetComponent('UILabel').text = list.feeTotal
        Total.transform:Find('totalNum'):GetComponent('UILabel').text = list.times
        Total.transform:Find('fieldNum'):GetComponent('UILabel').text = list.validTimesTotal
        if panelClub.clubInfo.userType == proxy_pb.LORD then
            Total.transform:Find('xiPai'):GetComponent('UILabel').text = list.addshuffleFee and list.addshuffleFee or '0.00'
        end
    end
    

    Grid:GetComponent('UIGrid'):Reposition()
    if page==1 then
        myFeeListScrollView:GetComponent('UIScrollView'):ResetPosition()
    end
    print('当前页数'..page)
    page=list.page
    print('下一页'..page)
    PanelManager.Instance:HideWindow('panelNetWaitting')
    isNotDownload=true
end

--点击时间按钮
function this.OnClickTime(go)
    AudioManager.Instance:PlayAudio('btn')
    startTime = (nowtimeChuo - 86400 * (tonumber(go.name)))
    endTime = (nowtimeChuo - 86400 * (tonumber(go.name)))
    startTime = os.time({year=os.date('%Y', startTime),month=os.date('%m', startTime),day=os.date('%d', startTime),hour='0',min='0'});
    endTime = os.time({year=os.date('%Y', endTime),month=os.date('%m', endTime),day=os.date('%d', endTime),hour='23',min='59'});
    local time = os.date('%Y/%m/%d', startTime)..'~'..os.date('%Y/%m/%d', endTime)
    recordTime:GetComponent('UILabel').text = panelClub.clubInfo.gameMode and time or ''
    this.initAll()
    this.GetDatas()
end
--点击房间记录时间按钮
function this.roomListOnClickTime(go)
    AudioManager.Instance:PlayAudio('btn')
    startTime = (nowtimeChuo - 86400 * (tonumber(go.name)))
    endTime = (nowtimeChuo - 86400 * (tonumber(go.name)))
    startTime = os.time({year=os.date('%Y', startTime),month=os.date('%m', startTime),day=os.date('%d', startTime),hour='0',min='0'});
    endTime = os.time({year=os.date('%Y', endTime),month=os.date('%m', endTime),day=os.date('%d', endTime),hour='23',min='59'});
    this.initAll()
    this.GetRoomDatas()
end
--点击申请列表界面时间按钮
function this.applyListOnClickTime(go)
    AudioManager.Instance:PlayAudio('btn')
    
    startTime = (nowtimeChuo - 86400 * (tonumber(go.name)))
    endTime = (nowtimeChuo - 86400 * (tonumber(go.name)))
    startTime = os.time({year=os.date('%Y', startTime),month=os.date('%m', startTime),day=os.date('%d', startTime),hour='0',min='0'});
    endTime = os.time({year=os.date('%Y', endTime),month=os.date('%m', endTime),day=os.date('%d', endTime),hour='23',min='59'});
    this.initAll()
    this.GetApplyListDatas()
end
--点击管理员的成员贡献界面时间按钮
function this.managerListOnClickTime(go)
    AudioManager.Instance:PlayAudio('btn')
    startTime = (nowtimeChuo - 86400 * (tonumber(go.name)))
    endTime = (nowtimeChuo - 86400 * (tonumber(go.name)))
    startTime = os.time({year=os.date('%Y', startTime),month=os.date('%m', startTime),day=os.date('%d', startTime),hour='0',min='0'});
    endTime = os.time({year=os.date('%Y', endTime),month=os.date('%m', endTime),day=os.date('%d', endTime),hour='23',min='59'});
    local time = os.date('%Y/%m/%d', startTime)..'~'..os.date('%Y/%m/%d', endTime)
    managerTime:GetComponent('UILabel').text = panelClub.clubInfo.gameMode and time or ''
    this.initAll()
    this.GetManagerListDatas()
end
--点击我的成员贡献界面时间按钮
function this.myFeeListOnClickTime(go)
    AudioManager.Instance:PlayAudio('btn')
    startTime = (nowtimeChuo - 86400 * (tonumber(go.name)))
    endTime = (nowtimeChuo - 86400 * (tonumber(go.name)))
    startTime = os.time({year=os.date('%Y', startTime),month=os.date('%m', startTime),day=os.date('%d', startTime),hour='0',min='0'});
    endTime = os.time({year=os.date('%Y', endTime),month=os.date('%m', endTime),day=os.date('%d', endTime),hour='23',min='59'});
    local time = os.date('%Y/%m/%d', startTime)..'~'..os.date('%Y/%m/%d', endTime)
    myFeeTime:GetComponent('UILabel').text = panelClub.clubInfo.gameMode and time or ''
    this.initAll()
    this.GetMyFeeListDatas()
end
--战绩查看大局战绩
function this.LookData(go)
    AudioManager.Instance:PlayAudio('btn')
    local data = {}
    data.name=gameObject.name
    data.startTime = startTime
    data.endTime = endTime
    if playId~=nil then
        data.playId = playId
    end
    data.fuc=proxy_pb.USER_CLUB_RECORD
    data.myData = GetUserData(go.transform.parent.gameObject)
    PanelManager.Instance:ShowWindow('panelOneClubRecord',data)
end
--房间记录查看单条详情
function this.roomListLookData(go)
    AudioManager.Instance:PlayAudio('btn')
    local myData={}
    myData.roomId = GetUserData(go.transform.parent.gameObject).roomId
	myData.roomNumber = GetUserData(go.transform.parent.gameObject).roomNumber
    myData.name=gameObject.name
    PanelManager.Instance:ShowWindow('panelRecordDetail',myData)
end
--我的成员疲劳值查看大局
function this.myFeeListLookData(go)
    AudioManager.Instance:PlayAudio('btn')
    local data = {}
    data.name=gameObject.name
    data.startTime = startTime
    data.endTime = endTime
    -- if playId~=nil then
    --     data.playId = playId
    -- end
    data.fuc=proxy_pb.MEMBERS_FEE_DETAIL
    data.myData = GetUserData(go.transform.parent.gameObject)
    PanelManager.Instance:ShowWindow('panelOneClubRecord',data)
end
--管理的成员疲劳值查看大局
function this.managerListLookData(go)
    AudioManager.Instance:PlayAudio('btn')
    local data = {}
    data.name=gameObject.name
    data.startTime = startTime
    data.endTime = endTime
    -- if playId~=nil then
    --     data.playId = playId
    -- end
    data.fuc=proxy_pb.LORD_MANAGER_DETAIL
    data.myData = GetUserData(go.transform.parent.gameObject)
    PanelManager.Instance:ShowWindow('panelOneClubRecord',data)
end
--群主结算申请记录操作
function this.applyListLookData(go)
    AudioManager.Instance:PlayAudio('btn')
    local data =GetUserData(go.transform.parent.gameObject)
    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
        this.lordBill(data.feeId)
    end, nil, '是否确认结算\"'..data.nickname..'\"的'..data.amount..'疲劳值？')
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end
--群主结算（接收疲劳值）
function this.lordBill(feeId)
    local msg = Message.New()
    msg.type = proxy_pb.RECEIVE_FEE;
    local body = proxy_pb.PReceiveFee();
    body.feeId = feeId;
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, this.operationResult)
end
--操作结果
function this.operationResult(msg)
    local b = proxy_pb.RResult();
    b:ParseFromString(msg.body);
    if b.code==1 then
        this.initAll()
        this.GetApplyListDatas()
        this.applyListNum()
		panelMessageTip.SetParamers('结算成功', 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	else
		panelMessageTip.SetParamers('结算失败'..b.msg, 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	end
end


--战绩点击排序
function this.OnClickSort(go)
    local As = go.transform:Find(1);
    local Ds = go.transform:Find(-1);

    local sort
    if As.gameObject.activeSelf then
        sort = Ds
        Ds.gameObject:SetActive(true)
        As.gameObject:SetActive(false)
    else
        sort = As
        As.gameObject:SetActive(true)
        Ds.gameObject:SetActive(false)
    end

    for i=1, #sortToggles do
        if sortToggles[i].gameObject ~= go then
            sortToggles[i].transform:Find(1).gameObject:SetActive(false)
            sortToggles[i].transform:Find(-1).gameObject:SetActive(false)
        else
            print("fund tip------->i:"..i);
        end
    end
    print('tonumber(go.name) : '..tonumber(go.name)..' tonumber(sort.gameObject.name) : '..tonumber(sort.gameObject.name))
    this.SortList(tonumber(go.name),tonumber(sort.gameObject.name))
end

--我的成员疲劳值点击排序
function this.myFeeListOnClickSort(go)
    local As = go.transform:Find(1);
    local Ds = go.transform:Find(-1);

    local sort
    if As.gameObject.activeSelf then
        sort = Ds
        Ds.gameObject:SetActive(true)
        As.gameObject:SetActive(false)
    else
        sort = As
        As.gameObject:SetActive(true)
        Ds.gameObject:SetActive(false)
    end

    for i=1, #myFeeListSortToggles do
        if myFeeListSortToggles[i].gameObject ~= go then
            myFeeListSortToggles[i].transform:Find(1).gameObject:SetActive(false)
            myFeeListSortToggles[i].transform:Find(-1).gameObject:SetActive(false)
        end
    end
   
    this.myFeeListSortList(tonumber(go.name),tonumber(sort.gameObject.name))
end
--管理员的成员疲劳值点击排序
function this.managerListOnClickSort(go)
    local As = go.transform:Find(1);
    local Ds = go.transform:Find(-1);

    local sort
    if As.gameObject.activeSelf then
        sort = Ds
        Ds.gameObject:SetActive(true)
        As.gameObject:SetActive(false)
    else
        sort = As
        As.gameObject:SetActive(true)
        Ds.gameObject:SetActive(false)
    end

    for i=1, #managerListSortToggles do
        if managerListSortToggles[i].gameObject ~= go then
            managerListSortToggles[i].transform:Find(1).gameObject:SetActive(false)
            managerListSortToggles[i].transform:Find(-1).gameObject:SetActive(false)
        end
    end
    this.managerListSortList(tonumber(go.name),tonumber(sort.gameObject.name))
end
--管理员的的成员疲劳值排序接口
function this.managerListSortList(type, sortType)
    local Grid = managerListScrollView:Find('Grid')
    print("type:"..type.." ,sortType:"..sortType)
    
    local sortString = {}
    sortString[0] = 'times'
    sortString[1] = 'validTimes'
    sortString[2] = 'sendFee'
    this.initData();
    this.initManagerListGrid();
    this.GetManagerListDatas(sortString[type], this.getRecordSortType(sortType))
end

--我的成员疲劳值排序接口
function this.myFeeListSortList(type, sortType)
    local Grid = myFeeListScrollView:Find('Grid')
    print("type:"..type.." ,sortType:"..sortType)
    
    local sortString = {}
    sortString[0] = 'times'
    sortString[1] = 'validTimes'
    sortString[2] = 'bringFee'

    this.initData();
    this.initMyFeeListGrid();
    this.GetMyFeeListDatas(sortString[type], this.getRecordSortType(sortType))
end
--战绩排序接口
function this.SortList(type, sortType)
    local Grid = ScrollView:Find('Grid')
    print("type:"..type.." ,sortType:"..sortType)
    if type == 0 or type == 4 then
        this.initData();
        this.initGrid();
        this.RequestSortData(type,sortType);
    end
end

function this.getRecordSortType(_sortType)
    if _sortType == 1 then
        return 0;
    elseif _sortType == -1 then
        return 1;
    end

    return 0;
end

function this.getRecordSortString(_type)
    if _type == 0 then
        return "times";
    elseif _type == 4 then
        return "fee";
    end

    return nil;
end


--从服务器获取排序数据
function this.RequestSortData(type,sortType)
    if isNotDownload==false then
        return
    end
    isNotDownload=false
    registerProxyReceive(this.onGetProxyRequest())
    print("RequestSortData was called");
    recordSortParameter.type = type;
    recordSortParameter.sortType = sortType;
    recordSortParameter.isRecordInSortState = true;
    PanelManager.Instance:ShowWindow('panelNetWaitting')
    local userIdLabel=SelectMenber:Find('Label'):GetComponent('UILabel').text
    if userIdLabel=='输入成员ID' then
        userId=nil
    else
        userId=userIdLabel
    end

    local playdata=GetUserData(SelectPlay.gameObject)
    if playdata==nil then
        playId=nil
    else
        playId=playdata.playId
    end


    local msg = Message.New()
    msg.type = proxy_pb.CLUB_RECORD;
    local body = proxy_pb.PClubRecord();
    body.clubId = panelClub.clubInfo.clubId;
    body.startTime = startTime;
    body.endTime = endTime;
    body.order = this.getRecordSortString(type);
    body.sort = this.getRecordSortType(sortType);
    if userId~=nil then
        body.userId=userId
    end
    if managerId~=nil then
        body.managerId=managerId
    end
    if playId~=nil then
        body.playId=playId
    end
    body.page=tostring(page)
    body.pageSize= tostring(pageSize)
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        print("get sort data from server------> ");
        local b = proxy_pb.RClubRecord()
        b:ParseFromString(msg.body);
        this.RefreshList(b)
    end)
end

function this.DefaultString(str)
    if str == nil or tonumber(str) == nil  then
        return 0
    end
    
    return str
end

--选择成员类型
function this.OnClickMyFeeListSelectMemBerType(go)
    print("OnClickSelectMemBerType was called");
    myFeeListPanelMember.gameObject:SetActive(true);
end

--关闭成员类型弹出框
function this.OnCloseMyFeeListMemberTypePanel(go)
    print("OnCloseMemberTypePanel was calld");
    myFeeListPanelMember.gameObject:SetActive(false);
end


--管家疲劳值，点击管家类型
function this.OnClickManagerListSelectMemberType(go)
    managerListPanelMember.gameObject:SetActive(true);
end

--关闭管家疲劳值 类型弹窗
function this.OnCloseManagerListMemberTypePanel(go)
    managerListPanelMember.gameObject:SetActive(false);
end

--我的成员疲劳值 选择某个成员类型
function this.OnSelectMemberTypeItem(go)
    print("OnSelectMemberTypeItem was called");
    local memberTypeLabel = nil;
    if go.transform.parent.parent.parent.gameObject == myFeeListPanelMember.gameObject then
        memberTypeLabel = myFeeListSelectMemberType:Find("Label"):GetComponent("UILabel");
    elseif go.transform.parent.parent.parent.gameObject == managerListPanelMember.gameObject then
        memberTypeLabel = managerListMemeberType:Find("Label"):GetComponent("UILabel");
    end
    if go.name == "ItemAll" then
        memberTypeLabel.text = "全部";
    end
    if go.name == "Itemadmin" then
        memberTypeLabel.text = "管理员";
    end

    if go.name == "Itemviadmin" then
        memberTypeLabel.text = "馆长";
    end

    if go.name == "Itemassis" then
        memberTypeLabel.text = "副馆长";
    end

    if go.name == "Itempresident" then
        memberTypeLabel.text = "会长";
    end

    if go.name == "Itemvicepresident" then
        memberTypeLabel.text = "副会长";
    end

    if go.name == "Itemmember" then
        memberTypeLabel.text = "成员";
    end
    myFeeListPanelMember.gameObject:SetActive(false)
    managerListPanelMember.gameObject:SetActive(false)
end

function this.SetMyFeeListMemberTypeVisibleByType(userType)
    myFeeListMemberTypeItemAdmin.gameObject:SetActive(false);
    myFeeListMemberTypeItemViAdmin.gameObject:SetActive(false);
    myFeeListMemberTypeItemAssis.gameObject:SetActive(false);
    myFeeListMemberTypeItemPresident.gameObject:SetActive(false);
    myFeeListMemberTypeItemViPresident.gameObject:SetActive(false);
    myFeeListMemberTypeItemMember.gameObject:SetActive(false);

    local judgeItemAdmin        = userType == proxy_pb.LORD;
    local judgeItemViAdmin      = userType == proxy_pb.LORD or userType == proxy_pb.MANAGER;
    local judgeItemAssis        = userType == proxy_pb.LORD or userType == proxy_pb.MANAGER or userType == proxy_pb.VICE_MANAGER;
    local judgeItemPresident    = userType == proxy_pb.LORD or userType == proxy_pb.MANAGER or userType == proxy_pb.VICE_MANAGER or userType == proxy_pb.ASSISTANT
    local judgeItemViPresident  = userType == proxy_pb.LORD or userType == proxy_pb.MANAGER or userType == proxy_pb.VICE_MANAGER or userType == proxy_pb.ASSISTANT or userType == proxy_pb.PRESIDENT
    local judgeItemMember       = userType == proxy_pb.LORD or userType == proxy_pb.MANAGER or userType == proxy_pb.VICE_MANAGER or userType == proxy_pb.ASSISTANT or userType == proxy_pb.PRESIDENT or userType == proxy_pb.VICE_PRESIDENT
    
    myFeeListMemberTypeItemAdmin.gameObject:SetActive(judgeItemAdmin);
    myFeeListMemberTypeItemViAdmin.gameObject:SetActive(judgeItemViAdmin);
    myFeeListMemberTypeItemAssis.gameObject:SetActive(judgeItemAssis);
    myFeeListMemberTypeItemPresident.gameObject:SetActive(judgeItemPresident);
    myFeeListMemberTypeItemViPresident.gameObject:SetActive(judgeItemViPresident);
    myFeeListMemberTypeItemMember.gameObject:SetActive(judgeItemMember);

    myFeeListPanelMember:Find("Scroll View/Grid"):GetComponent("UIGrid"):Reposition();

end


function this.SetManagerListMemberTypeVisibleByType(userType)

    managerListTypeItemAdmin.gameObject:SetActive(false);
    managerListTypeItemViAdmin.gameObject:SetActive(false);
    managerListTypeItemAssis.gameObject:SetActive(false);

    local judgeItemAdmin        = userType == proxy_pb.LORD;
    local judgeItemViAdmin      = userType == proxy_pb.LORD or userType == proxy_pb.MANAGER;
    local judgeItemAssis        = userType == proxy_pb.LORD or userType == proxy_pb.MANAGER or userType == proxy_pb.VICE_MANAGER;
    local judgeItemPresident    = userType == proxy_pb.LORD or userType == proxy_pb.MANAGER or userType == proxy_pb.VICE_MANAGER or userType == proxy_pb.ASSISTANT
    local judgeItemViPresident  = userType == proxy_pb.LORD or userType == proxy_pb.MANAGER or userType == proxy_pb.VICE_MANAGER or userType == proxy_pb.ASSISTANT or userType == proxy_pb.PRESIDENT


    managerListTypeItemAdmin.gameObject:SetActive(judgeItemAdmin);
    managerListTypeItemViAdmin.gameObject:SetActive(judgeItemViAdmin);
    managerListTypeItemAssis.gameObject:SetActive(judgeItemAssis);
    managerListTypeItemPresident.gameObject:SetActive(judgeItemPresident);
    managerListTypeItemViPresident.gameObject:SetActive(judgeItemViPresident);

    managerListPanelMember:Find("Scroll View/Grid"):GetComponent("UIGrid"):Reposition();

end

function this.onGetProxyRequest()
    isNotDownload=true
end