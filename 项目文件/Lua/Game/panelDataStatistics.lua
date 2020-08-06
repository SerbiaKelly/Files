panelDataStatistics = {}
local this = panelDataStatistics
local message
local gameObject

local userTypeItem
local userTypeGrid
local userDataObj = {}
local userDataLongTime=7
local userTypeString={
    '管理员',
    '馆长',
    '副馆长',
    '会长',
    '副会长',
}
local ByUserTypeStringGetType={}
ByUserTypeStringGetType['管理员']=proxy_pb.MANAGER
ByUserTypeStringGetType['馆长']=proxy_pb.VICE_MANAGER
ByUserTypeStringGetType['副馆长']=proxy_pb.ASSISTANT
ByUserTypeStringGetType['会长']=proxy_pb.PRESIDENT
ByUserTypeStringGetType['副会长']=proxy_pb.VICE_PRESIDENT

local userType={}
local userTypeBtnObj={}

local curSelectClubUserType = proxy_pb.MANAGER
local curSelectTime = os.time()
local curPage = 1
local pageSize = 20
local userDatas = {}
local IsInBottom = false
local userDataSort = 0
local userDataOrder = ''
function this.Awake(obj)
    gameObject = obj
    message = gameObject:GetComponent('LuaBehaviour')

    userTypeItem = gameObject.transform:Find('userType/userTypeItem')
    userTypeGrid = gameObject.transform:Find('userType/userTypeGrid')

    userDataObj.obj = gameObject.transform:Find('userData')
    userDataObj.userDataItem = userDataObj.obj:Find('userDataItem')
    userDataObj.userDataScrollView = userDataObj.obj:Find('userDataScrollView')
    userDataObj.userDataGrid = userDataObj.obj:Find('userDataScrollView/userDataGrid')
    userDataObj.UIScrollBar = userDataObj.obj:Find('UIScrollBar'):GetComponent("UIScrollBar")
    userDataObj.userDataScrollView:GetComponent("UIScrollView").onDragFinished  = this.OnManagerRequestNextPage
    userDataObj.noUserData = userDataObj.obj:Find('noUserData')
    userDataObj.title = userDataObj.obj:Find('title')
    userDataObj.buttonSearch = userDataObj.title:Find('buttonSearch')
    userDataObj.manageID = userDataObj.title:Find('manageID')
    userDataObj.timeSourch = userDataObj.title:Find('timeSourch')

    userDataObj.zongFieldBtn = userDataObj.title:Find('tip/zongFieldBtn')
    message:AddClick(userDataObj.zongFieldBtn.gameObject, this.OnClickZongFieldBtnSort)
    userDataObj.youXiaoFieldBtn = userDataObj.title:Find('tip/youXiaoFieldBtn')
    message:AddClick(userDataObj.youXiaoFieldBtn.gameObject, this.OnClickYouXiaoFieldBtnSort)
    userDataObj.giveFeeBtn = userDataObj.title:Find('tip/giveFeeBtn')
    message:AddClick(userDataObj.giveFeeBtn.gameObject, this.OnClickGiveFeeBtnSort)
    userDataObj.feeBtn = userDataObj.title:Find('tip/feeBtn')
    message:AddClick(userDataObj.feeBtn.gameObject, this.OnClickFeeBtnSort)
    userDataObj.zongFeeBtn = userDataObj.title:Find('tip/zongFeeBtn')
    message:AddClick(userDataObj.zongFeeBtn.gameObject, this.OnClickZongFeeBtnSort)

    userDataObj.zongFieldData = userDataObj.title:Find('zongFieldData'):GetComponent('UILabel')
    userDataObj.youXiaoFieldData = userDataObj.title:Find('youXiaoFieldData'):GetComponent('UILabel')
    userDataObj.giveFeeData = userDataObj.title:Find('giveFeeData'):GetComponent('UILabel')
    userDataObj.feeData = userDataObj.title:Find('feeData'):GetComponent('UILabel')
    userDataObj.zongFeeData = userDataObj.title:Find('zongFeeData'):GetComponent('UILabel')

    userDataObj.selecTime = userDataObj.title:Find('selecTime')
    userDataObj.timeItem = userDataObj.selecTime:Find('timeItem')
    userDataObj.timeScrollView = userDataObj.selecTime:Find('timeScrollView')
    userDataObj.timeGrid = userDataObj.selecTime:Find('timeScrollView/timeGrid')
    userDataObj.timeMask = userDataObj.selecTime:Find('timeMask')

    message:AddClick(gameObject.transform:Find('buttonClose').gameObject, function (go)
        AudioManager.Instance:PlayAudio('btn')
        PanelManager.Instance:HideWindow(gameObject.name)
    end)
    message:AddClick(userDataObj.timeSourch.gameObject, this.OnClickTimeSourchBtn)
    message:AddClick(userDataObj.buttonSearch.gameObject, this.OnClickButtonSearch)
    message:AddClick(userDataObj.timeMask.gameObject, function (go)
        AudioManager.Instance:PlayAudio('btn')
        userDataObj.selecTime.gameObject:SetActive(false)
    end)
end

function this.Start()
end
function this.Update()
end
function this.OnEnable()
    this.GetUserTypeCount()
    this.InitUserType()
    userDataObj.manageID:GetComponent('UILabel').text = '请输入ID'
    this.InitSelecTime()
    curPage = 1
    userDatas={}
    IsInBottom=false
    userDataSort = 0
    userDataOrder = ''
    this.InitOtherBtnState()
    this.GetUserData()
    userDataObj.userDataGrid:GetComponent('UIGrid'):Reposition()
    userDataObj.userDataScrollView.gameObject:SetActive(#userDatas ~= 0)
    userDataObj.noUserData.gameObject:SetActive(#userDatas == 0)
end
function this.WhoShow()
end
function this.GetUserTypeCount()
    userType={}
    if panelClub.clubInfo.userType == proxy_pb.LORD then
        userType={proxy_pb.MANAGER,proxy_pb.VICE_MANAGER,proxy_pb.ASSISTANT,proxy_pb.PRESIDENT,proxy_pb.VICE_PRESIDENT}
    elseif panelClub.clubInfo.userType == proxy_pb.MANAGER then
        userType={proxy_pb.VICE_MANAGER,proxy_pb.ASSISTANT,proxy_pb.PRESIDENT,proxy_pb.VICE_PRESIDENT}
    elseif panelClub.clubInfo.userType == proxy_pb.VICE_MANAGER then
        userType={proxy_pb.ASSISTANT,proxy_pb.PRESIDENT,proxy_pb.VICE_PRESIDENT}
    elseif panelClub.clubInfo.userType == proxy_pb.ASSISTANT then
        userType={proxy_pb.PRESIDENT,proxy_pb.VICE_PRESIDENT}
    elseif panelClub.clubInfo.userType == proxy_pb.PRESIDENT then
        userType={proxy_pb.VICE_PRESIDENT}
    end  
end
function this.InitUserType()
    for i = 1, #userTypeString do
        if userTypeGrid.childCount<#userTypeString then
            local obj = NGUITools.AddChild(userTypeGrid.gameObject, userTypeItem.gameObject)
            obj.transform:Find('highlight/Label1'):GetComponent('UILabel').text = userTypeString[i]
            obj.transform:Find('Sprite/Label1'):GetComponent('UILabel').text = userTypeString[i]
			local data = {}
			data.obj = obj
			data.name = userTypeString[i]
            table.insert(userTypeBtnObj, data)
            message:AddClick(obj, this.OnClickUserTypeBtn)
        end
    end
    for i = 1, #userTypeBtnObj do
        userTypeBtnObj[i].obj.gameObject:SetActive(false)
        userTypeBtnObj[i].obj.transform:GetComponent('UIToggle'):Set(false)
		for j = 1, #userType do
			if userType[j] ==  ByUserTypeStringGetType[userTypeBtnObj[i].name] then
				userTypeBtnObj[i].obj.gameObject:SetActive(true)
			end
		end
    end
    for i = 1, #userTypeBtnObj do
        if userType[1] == ByUserTypeStringGetType[userTypeBtnObj[i].name] then
            curSelectClubUserType = userType[1]
			userTypeBtnObj[i].obj.transform:GetComponent('UIToggle'):Set(true)
		end
    end
    userTypeGrid:GetComponent('UIGrid'):Reposition()
end
function this.OnClickUserTypeBtn(go)
    AudioManager.Instance:PlayAudio('btn')
    userDataObj.manageID:GetComponent('UILabel').text = '请输入ID'
    curSelectClubUserType = ByUserTypeStringGetType[go.transform:Find('highlight/Label1'):GetComponent('UILabel').text]
    curSelectTime = os.time()
    userDataObj.timeSourch:GetComponent('UILabel').text = os.date('%Y/%m/%d', os.time())
    curPage = 1
    userDatas={}
    userDataSort = 0
    userDataOrder = ''
    this.InitOtherBtnState()
    this.GetUserData()
    userDataObj.userDataScrollView:GetComponent('UIScrollView'):ResetPosition()
end
function this.InitSelecTime()
    curSelectTime = os.time()
    userDataObj.timeSourch:GetComponent('UILabel').text = os.date('%Y/%m/%d', os.time())
    userDataObj.selecTime.gameObject:SetActive(false)
    for i=1,userDataLongTime do
        local obj = nil
        if userDataObj.timeGrid.childCount<userDataLongTime then
            obj = NGUITools.AddChild(userDataObj.timeGrid.gameObject, userDataObj.timeItem.gameObject)
            message:AddClick(obj, this.OnClickSelecTime)
            obj.name = i-1
            obj:SetActive(true)
        else
            obj=userDataObj.timeGrid:GetChild(i-1).gameObject
        end
        obj.transform:Find('Label'):GetComponent('UILabel').text = os.date('%Y/%m/%d', (os.time()-86400*(i-1)))
    end
end
function this.OnClickTimeSourchBtn(go)
    AudioManager.Instance:PlayAudio('btn')
    userDataObj.selecTime.gameObject:SetActive(true)
    for i=1,userDataLongTime do
        local obj = userDataObj.timeGrid:GetChild(i-1)
        local timeToggle = obj:GetComponent('UIToggle')
        if obj:Find('Label'):GetComponent('UILabel').text == go.transform:GetComponent('UILabel').text then
            timeToggle.value = true
        else
            timeToggle.value = false
        end
    end
end
function this.OnClickSelecTime(go)
    AudioManager.Instance:PlayAudio('btn')
    userDataObj.timeSourch:GetComponent('UILabel').text = go.transform:Find('Label'):GetComponent('UILabel').text
    userDataObj.selecTime.gameObject:SetActive(false)
    local startTime = (os.time() - 86400 * (tonumber(go.name)))
    curSelectTime = os.time({year=os.date('%Y', startTime),month=os.date('%m', startTime),day=os.date('%d', startTime)})
    curPage = 1
    userDatas={}
    userDataSort = 0
    userDataOrder = ''
    this.InitOtherBtnState()
    this.GetUserData()
    userDataObj.userDataScrollView:GetComponent('UIScrollView'):ResetPosition()
end

function this.OnClickButtonSearch(go)
    AudioManager.Instance:PlayAudio('btn')
    local str = userDataObj.manageID:GetComponent('UILabel').text
    if str == '' or str == '请输入ID' then
        panelMessageTip.SetParamers('请输入正确的ID', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        return
    end
    curPage = 1
    userDatas={}
    userDataSort = 0
    userDataOrder = ''
    this.GetUserData()
end
function this.OnManagerRequestNextPage()
    --我们往上拖拽才拉取，不用考虑往下拖拽的情况了
    if ( userDataObj.UIScrollBar.value >=0.99) then
        if not IsInBottom then
           this.GetUserData()
        else
            panelMessageTip.SetParamers('没有更多了', 1)
            PanelManager.Instance:ShowWindow('panelMessageTip')
        end
    end
end
function this.InitOtherBtnState()
    userDataObj.zongFieldBtn:Find(-1).gameObject:SetActive(false)
    userDataObj.zongFieldBtn:Find(1).gameObject:SetActive(false)
    userDataObj.youXiaoFieldBtn:Find(-1).gameObject:SetActive(false)
    userDataObj.youXiaoFieldBtn:Find(1).gameObject:SetActive(false)
    userDataObj.giveFeeBtn:Find(-1).gameObject:SetActive(false)
    userDataObj.giveFeeBtn:Find(1).gameObject:SetActive(false)
    userDataObj.feeBtn:Find(-1).gameObject:SetActive(false)
    userDataObj.feeBtn:Find(1).gameObject:SetActive(false)
    userDataObj.zongFeeBtn:Find(-1).gameObject:SetActive(false)
    userDataObj.zongFeeBtn:Find(1).gameObject:SetActive(false)
end
function this.OnClickZongFieldBtnSort(go)
    this.SetBtnStateAndGetData(go)
end
function this.OnClickYouXiaoFieldBtnSort(go)
    this.SetBtnStateAndGetData(go)
end
function this.OnClickGiveFeeBtnSort(go)
    this.SetBtnStateAndGetData(go)
end
function this.OnClickFeeBtnSort(go)
    this.SetBtnStateAndGetData(go)
end
function this.OnClickZongFeeBtnSort(go)
    this.SetBtnStateAndGetData(go)
end
function this.SetBtnStateAndGetData(go)
    AudioManager.Instance:PlayAudio('btn')
    if go.name == 'zongFieldBtn' then
        userDataOrder = 'times'
    elseif go.name == 'youXiaoFieldBtn' then 
        userDataOrder = 'validTimes'
    elseif go.name == 'giveFeeBtn' then 
        userDataOrder = 'assignScore'
    elseif go.name == 'feeBtn' then 
        userDataOrder = 'score'
    elseif go.name == 'zongFeeBtn' then 
        userDataOrder = 'totalScore'
    end
    local As = go.transform:Find(1)
    local Ds = go.transform:Find(-1)
    if As.gameObject.activeSelf then
        userDataSort = 0
        Ds.gameObject:SetActive(true)
        As.gameObject:SetActive(false)
    else
        userDataSort = 1 
        As.gameObject:SetActive(true)
        Ds.gameObject:SetActive(false)
    end
    userDataObj.manageID:GetComponent('UILabel').text = '请输入ID'
    curPage = 1
    userDatas={}
    this.GetUserData()
    userDataObj.userDataScrollView:GetComponent('UIScrollView'):ResetPosition()
end
function this.GetUserData()
    local msg = Message.New()
    msg.type = proxy_pb.BUTLER_SCORE_DAILY_STATS
    local body = proxy_pb.PButlerScoreDailyStats()
    body.clubId = panelClub.clubInfo.clubId
    body.clubUserType = curSelectClubUserType
    body.time = curSelectTime
    if userDataObj.manageID:GetComponent('UILabel').text == '' or userDataObj.manageID:GetComponent('UILabel').text == '请输入ID' then
        body.butlerId = ''
    else
        body.butlerId = userDataObj.manageID:GetComponent('UILabel').text
    end
    body.page = curPage
    body.pageSize = pageSize
    if userDataOrder ~= '' then
        body.order = userDataOrder
        body.sort = userDataSort
    end
    print('clubId: '..tostring(body.clubId))
    print('clubUserType: '..tostring(body.clubUserType))
    print('time: '..tostring(os.date('%Y/%m/%d', curSelectTime)))
    print('butlerId: '..tostring(body.butlerId))
    print('page: '..body.page)
    print('userDataOrder : '..tostring(userDataOrder))
    print('userDataSort : '..tostring(userDataSort))
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RButlerScoreDailyStats()
        b:ParseFromString(msg.body)
        print('#b.datas : '..#b.datas)
        if b.datas ~= nil and #b.datas ~= 0 then
            for i = 1, #b.datas do
                table.insert(userDatas,b.datas[i])
            end
            IsInBottom = #b.datas < pageSize
        else
            IsInBottom = true
        end
        print('#b.userDatas : '..#userDatas)
        this.SetUserData(b)
    end)
end
function this.SetUserData(data)
    if curPage == 1 then
        userDataObj.zongFieldData.text = data.timesStats
        userDataObj.youXiaoFieldData.text = data.validTimesStats
        userDataObj.giveFeeData.text = data.assignScoreStats
        userDataObj.feeData.text = data.scoreStats
        userDataObj.zongFeeData.text = data.totalScoreStats
    end
    curPage = data.page
    for i = 1, #userDatas do
        local obj = nil
        if userDataObj.userDataGrid.childCount < #userDatas then
            obj = NGUITools.AddChild(userDataObj.userDataGrid.gameObject, userDataObj.userDataItem.gameObject)
        else
            obj=userDataObj.userDataGrid:GetChild(i-1).gameObject
        end
        obj.name = i
        obj:SetActive(true)
        this.UpdateUserDataItem(obj,userDatas[i],i)
    end
    for i = 0, userDataObj.userDataGrid.childCount-1 do
        if i < #userDatas then
            userDataObj.userDataGrid:GetChild(i).gameObject:SetActive(true)
        else
            userDataObj.userDataGrid:GetChild(i).gameObject:SetActive(false)
        end
    end
    userDataObj.userDataGrid:GetComponent('UIGrid'):Reposition()
    userDataObj.userDataScrollView.gameObject:SetActive(#userDatas ~= 0)
    userDataObj.noUserData.gameObject:SetActive(#userDatas == 0)
end
function this.UpdateUserDataItem(obj,data,rank)
    obj:SetActive(true)
    local userType = obj.transform:Find('userType')
    for i = 0, userType.childCount-1 do
        userType:GetChild(i).gameObject:SetActive(false)
    end
    obj.transform:Find('bianHao'):GetComponent('UILabel').text = rank
    coroutine.start(LoadPlayerIcon, obj.transform:Find('TX'):GetComponent('UITexture'),data.icon)
    obj.transform:Find('userType/'..curSelectClubUserType).gameObject:SetActive(true)
    obj.transform:Find('name'):GetComponent('UILabel').text = data.nickname
    obj.transform:Find('ID'):GetComponent('UILabel').text = 'ID:'..data.userId
    obj.transform:Find('zongFieldNum'):GetComponent('UILabel').text = data.times
    obj.transform:Find('youXiaoFieldNum'):GetComponent('UILabel').text = data.validTimes
    obj.transform:Find('giveFeeNum'):GetComponent('UILabel').text = data.assignScore
    obj.transform:Find('feeNum'):GetComponent('UILabel').text = data.score
    obj.transform:Find('zongFeeNum'):GetComponent('UILabel').text = data.totalScore
end
