panelMatchFeeBillRecord = {}
local this = panelMatchFeeBillRecord

local message;
local gameObject
local Toggles = {}

function this.Awake(obj)
    gameObject = obj
    message = gameObject:GetComponent('LuaBehaviour');

    message:AddClick(gameObject.transform:Find('BaseContent/ButtonClose').gameObject, this.OnClickCloseBtn)

    local toggles = gameObject.transform:Find('Toggles')
    for i = 1, toggles.childCount do
        local toggle = toggles.transform:Find(i)
        table.insert(Toggles, toggle)
        message:AddClick(toggle.gameObject, this.OnClickChangePanel)
    end

    this.InitFeeBillRecordPanel()
    this.InitOperationFatiguePanel()
    this.InitStatisticalPanel()
    this.InitChangedRecordPanel()
	this.InitGiveFatiguePanel()
end

function this.GetSelectPanel()
    for i=1,#Toggles do
        if Toggles[i].transform:GetComponent('UIToggle').value then
            return i;
        end
    end
end

function this.OnClickChangePanel(go)
    AudioManager.Instance:PlayAudio('btn')
    local index = tonumber(go.name)
    this.GetData(index)
end

function this.GetData(index)
    if index == 1 then
        this.RefreshOperationFatiguePanel()
    elseif index == 2 then
        this.GetFeeBillRecordData(true)
    elseif index == 3 then
        this.RefreshStatisticalPanel(true)
    elseif index == 4 then
        this.RefreshChangedRecordPanel(true)
	elseif index == 5 then
		this.RefreshGiveFatiguePanel()
    end    
end

local RecordList
local RecordItemPrefab
local RecordListScrollBar
local FeeBillRecordPanel
local TypePanel
local SelectType
function this.InitFeeBillRecordPanel()
    FeeBillRecordPanel = gameObject.transform:Find('FeeBillRecordPanel')
    RecordList = FeeBillRecordPanel.transform:Find('RecordList')
    RecordItemPrefab = RecordList.transform:Find('Item')
    RecordListScrollBar = RecordList.transform:Find('Scroll Bar')
    SelectType = FeeBillRecordPanel.transform:Find('SelectType')
    TypePanel = FeeBillRecordPanel.transform:Find('TypePanel')

    local times = FeeBillRecordPanel.transform:Find('Times')
    for i=0, 2 do
        message:AddClick(times.transform:GetChild(i).gameObject, this.OnClickTime)
    end

    local types = TypePanel.transform:Find('Scroll View/Grid')
    for i = 0, types.transform.childCount - 1 do
        message:AddClick(types.transform:GetChild(i).gameObject, this.OnClickSelecType)
    end

    message:AddClick(SelectType.gameObject, function (go)
        AudioManager.Instance:PlayAudio('btn')
        TypePanel.gameObject:SetActive(true)
    end)

    message:AddClick(times.transform:Find('AdvancedQuery').gameObject, this.OnClickSelectAdvanced)
    message:AddClick(TypePanel.transform:Find('Sprite').gameObject, function (go)
        TypePanel.gameObject:SetActive(false)
    end)
    RecordList.transform:Find('Scroll View'):GetComponent('UIScrollView').onDragFinished = this.OnMoveNextFeeRecord
end

local isCanOperatingFatigue = false
local CurSelctPlayer = {}
function  this.WhoShow(data)
    CurSelctPlayer = data
    local pageIndex = data.pageIndex
    isCanOperatingFatigue = isCanCleanAllFeeBalance() or 
        ((CurSelctPlayer.membership == 1) and isCanCleanMySelfFeeBalance()) or 
        (CurSelctPlayer.membership == 2 and isCanCleanMemangerFeeBalance())
    if not isCanOperatingFatigue then
        if pageIndex == 1 then
            pageIndex = 2
        end
    end
    this.Refresh(pageIndex)
end

function this.Refresh(pageIndex)
	print('pageIndex : '..pageIndex)
	local toggles = gameObject.transform:Find('Toggles')
    for i = 1, toggles.childCount do
        toggles.transform:Find(i):GetComponent('UIToggle'):Set(false)
    end
	toggles.transform:Find(1).gameObject:SetActive(isCanOperatingFatigue)
	toggles.transform:Find(5).gameObject:SetActive(CurSelctPlayer.isShowGiveFatigue)
	toggles.transform:Find(pageIndex):GetComponent('UIToggle'):Set(true)
    toggles.transform:GetComponent('UIGrid'):Reposition()
    this.GetData(pageIndex)
end

local pageSize = 10
local curPageIndex = 1
local IsResetData = true
local isSendedRequest = false
local startTime
local endTime
function this.GetFeeBillRecordData(rest)
    curPageIndex = 1
    IsResetData = true
    isSendedRequest = false
    if rest then
        startTime = os.time({year=os.date('%Y', os.time()),month=os.date('%m', os.time()),day=os.date('%d', os.time()),hour='0',min='0'})
        endTime = os.time({year=os.date('%Y', os.time()),month=os.date('%m', os.time()),day=os.date('%d', os.time()),hour='23',min='59'})
        this.SetSelectType(0)
        FeeBillRecordPanel.transform:Find('Times').transform:Find('0'):GetComponent('UIToggle'):Set(true)
        print('hahahahahahah')
    end
    
    RecordList.transform:Find('Scroll View'):GetComponent('UIScrollView'):ResetPosition()
    Util.ClearChild(RecordList.transform:Find('Scroll View/Grid'))

    local types = TypePanel.transform:Find('Scroll View/Grid')
    TypePanel.gameObject:SetActive(true)
    types.transform:GetComponent('UIGrid').repositionNow = true
    types.transform:Find('1002').gameObject:SetActive(CurSelctPlayer.userType ~= proxy_pb.GENERAL) --or CurSelctPlayer.userType == proxy_pb.LORD)
    types.transform:Find('2002').gameObject:SetActive(CurSelctPlayer.userType == proxy_pb.LORD)
    types.transform:Find('1001').gameObject:SetActive(CurSelctPlayer.userType == proxy_pb.LORD)
    types.transform:Find('1007').gameObject:SetActive(CurSelctPlayer.userType == proxy_pb.LORD)
    types.transform:Find('2003').gameObject:SetActive(CurSelctPlayer.userType == proxy_pb.LORD)
    types.transform:Find('2004').gameObject:SetActive(CurSelctPlayer.userType == proxy_pb.LORD)
    types.transform:Find('2005').gameObject:SetActive(CurSelctPlayer.userType == proxy_pb.LORD)
    types.transform:Find('2006').gameObject:SetActive(CurSelctPlayer.userType == proxy_pb.LORD)
    types.transform:Find('1006').gameObject:SetActive(CurSelctPlayer.userType == proxy_pb.LORD)
    types.transform:GetComponent('UIGrid'):Reposition()
    TypePanel.transform:Find('Scroll View'):GetComponent('UIScrollView'):ResetPosition()
    TypePanel.gameObject:SetActive(false)
    this.GetFeeRecord()
end

function this.GetFeeRecord()
    local msg = Message.New()
    msg.type = proxy_pb.SCORE_BILL_LIST
    local body = proxy_pb.PScoreBillList()
    body.clubId = panelClub.clubInfo.clubId
    body.userId = CurSelctPlayer.userId
    body.startTime = startTime
    body.endTime = endTime
    body.page = curPageIndex
    body.pageSize = pageSize
    local type = GetUserData(SelectType.gameObject)
    if type ~= nil then
        body.type =type
        print('type:'..body.type)
    end
    isSendedRequest = true;
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, this.OnGetFeeRecord) 
    PanelManager.Instance:ShowWindow('panelNetWaitting')
end

function this.OnGetFeeRecord(msg)
    local b = proxy_pb.RScoreBillList();
    b:ParseFromString(msg.body);
    isSendedRequest = false;
    PanelManager.Instance:HideWindow('panelNetWaitting')
    print('b.datas:'..#b.datas)

    if curPageIndex == 1 then
        print('b.amountTotal:'..tostring(b.amountTotal))
        FeeBillRecordPanel.transform:Find('FatigueValue/Label'):GetComponent('UILabel').text = b.amountTotal
    end

    if #b.datas == 0 then
        if curPageIndex ~= 1 then
            IsResetData = false
            panelMessageTip.SetParamers('没有更多了', 1)
			PanelManager.Instance:ShowWindow('panelMessageTip')
        end
        return 
    end

    curPageIndex = b.page;
    this.RefreshFeeRecord(b.datas)
end

function this.RefreshFeeRecord(datas)
    local Grid = RecordList.transform:Find('Scroll View/Grid')
    for i = 1, #datas do
        local obj = NGUITools.AddChild(Grid.gameObject, RecordItemPrefab.gameObject)
        SetUserData(obj.gameObject, datas[i])

        obj.transform:Find('Time'):GetComponent('UILabel').text = os.date('%Y.%m.%d %H:%M:%S', datas[i].createTime)
        obj.transform:Find('Change'):GetComponent('UILabel').text = datas[i].amount
        obj.transform:Find('Reset'):GetComponent('UILabel').text = datas[i].balance
        obj.transform:Find('Note'):GetComponent('UILabel').text = (datas[i].Note == '' or datas[i].remark == nil) and '无备注' or (string.gsub(datas[i].remark,'%s+', ''))
		local str = ''
		if datas[i].type == 1000 then 
			str = '加疲劳值'
		elseif datas[i].type == 2000 then 
			str = '减疲劳值'
		elseif datas[i].type == 2007 or datas[i].type == 1005 then 
			str = '赠送疲劳值'
		else
			str = this.GetStringFromType(datas[i].type)
		end
        obj.transform:Find('Type'):GetComponent('UILabel').text = str
        obj.gameObject:SetActive(true)
    end

    Grid.transform:GetComponent('UIGrid'):Reposition()
end

function this.OnMoveNextFeeRecord()
    print('准备拉取')
    local value = RecordListScrollBar:GetComponent('UIScrollBar').value
    if (not isSendedRequest) and (value >= 1) and IsResetData  then
		this.GetFeeRecord()
	end
end

function this.OnClickTime(go)
    AudioManager.Instance:PlayAudio('btn')
    local new = os.time()
    startTime = (new - 86400 * (tonumber(go.name)))
    endTime = (new - 86400 * (tonumber(go.name)))
    startTime = os.time({year=os.date('%Y', startTime),month=os.date('%m', startTime),day=os.date('%d', startTime),hour='0',min='0'});
    endTime = os.time({year=os.date('%Y', endTime),month=os.date('%m', endTime),day=os.date('%d', endTime),hour='23',min='59'});
    this.GetFeeBillRecordData(false)
end

function this.GetTiems()
    
end

function this.OnClickSelecType(go)
    AudioManager.Instance:PlayAudio('btn')
    local type = tonumber(go.name)
    this.SetSelectType(type)
    TypePanel.gameObject:SetActive(false)
    this.GetFeeBillRecordData(false)
end

local types = {}
types[0] = '全部'
types[1000] = '加减赠疲劳值'
types[1001] = '群主所得疲劳值'
types[1002] = '分配的疲劳值'
types[1006] = '洗牌所得疲劳值'
types[1007] = '无效场次疲劳值'
types[2000] = '减疲劳值'
types[2001] = '大赢家疲劳值'
types[2002] = '分配给管理员'
types[2003] = '分配给馆长'
types[2004] = '分配给副馆长'
types[2005] = '分配给会长'
types[2006] = '分配给副会长'
types[2008] = '洗牌所扣疲劳值'
types[3000] = '对局疲劳值'
function this.GetStringFromType(type)
    return types[type]
end

function this.SetSelectType(type)
    if type == 0 then
        SetUserData(SelectType.gameObject, nil)
    else
        SetUserData(SelectType.gameObject, type)
    end
    print('type:'..type)
    SelectType.transform:Find('Label'):GetComponent('UILabel').text = this.GetStringFromType(type)
end

function this.OnClickSelectAdvanced(go)
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:ShowWindow('panelSelectTime',gameObject.name)
end

local PlayerInfo = {}
local MyFatigueCount
local ChangeCountLabel
local ChangedCountLabel
local OperationFatiguePanel
local ToggleInc
local ToggleDec
local ConfirmButton
function this.InitOperationFatiguePanel()
    OperationFatiguePanel = gameObject.transform:Find('OperationFatiguePanel')

    ToggleInc = OperationFatiguePanel.transform:Find('Operation/ToggleInc')
    ToggleDec = OperationFatiguePanel.transform:Find('Operation/ToggleDec')

    MyFatigueCount = OperationFatiguePanel.transform:Find('MyFatigueCount/Label')

    PlayerInfo.Head = OperationFatiguePanel.transform:Find('PlayerInfo/Head')
    PlayerInfo.Name = OperationFatiguePanel.transform:Find('PlayerInfo/Name')
    PlayerInfo.ResidueFee = OperationFatiguePanel.transform:Find('PlayerInfo/ResidueFee/Label')

    ChangeCountLabel = OperationFatiguePanel.transform:Find('FatigueCount/Label')
    ChangedCountLabel = OperationFatiguePanel.transform:Find('FatigueCount/RestCount')

    ConfirmButton = OperationFatiguePanel.transform:Find('ConfirmButton')

    message:AddClick(ToggleInc.gameObject, this.OnClickOperation)
    message:AddClick(ToggleDec.gameObject, this.OnClickOperation)
    message:AddClick(ConfirmButton.gameObject, this.OnClickConfirmButton)
    message:AddOnChange(ChangeCountLabel.gameObject, this.OnChangeFatigue)
end

function this.RefreshOperationFatiguePanel()
    PlayerInfo.Name.transform:GetComponent('UILabel').text = CurSelctPlayer.nickname
    

    this.GetPlayerInfo(info_login.id, function (data)
        this.GetPlayerInfo(CurSelctPlayer.userId, function (data) 
            PlayerInfo.ResidueFee.transform:GetComponent('UILabel').text = data.feeBalance
            ChangedCountLabel.transform:GetComponent('UILabel').text = data.feeBalance
            print('data.feeBalance:'..data.feeBalance)
            coroutine.start(LoadPlayerIcon, PlayerInfo.Head.transform:GetComponent('UITexture'), data.icon)
        end)
        MyFatigueCount.transform:GetComponent('UILabel').text = data.feeBalance
        PanelManager.Instance:HideWindow('panelNetWaitting')
    end)

    ChangeCountLabel.transform:GetComponent('UIInput').value = ''
    
end

function this.OnClickOperation(go)
    AudioManager.Instance:PlayAudio('btn')
    this.OnChangeFatigue()
end

function this.OnChangeFatigue()
    local count = tonumber(PlayerInfo.ResidueFee.transform:GetComponent('UILabel').text) 
    count = count and count or 0 
    --限制只能输入小数点后2位
    LimitInputFloat(ChangeCountLabel.transform:GetComponent('UIInput'),2)
    --
    local changeCount = tonumber(ChangeCountLabel.transform:GetComponent('UIInput').value)
    local restCount = count - (changeCount and changeCount or 0)
    if ToggleInc.transform:GetComponent('UIToggle').value then
        restCount = count + (changeCount and changeCount or 0)
    end
    ChangedCountLabel.transform:GetComponent('UILabel').text = restCount
end

function this.OnClickConfirmButton(go)
    AudioManager.Instance:PlayAudio('btn')
    local msg = Message.New()
    msg.type = proxy_pb.SCORE_ADD_OR_SUB
    local body = proxy_pb.PScoreAddOrSub()
    body.userId = CurSelctPlayer.userId
    body.clubId = panelClub.clubInfo.clubId
    body.isAdd = ToggleInc.transform:GetComponent('UIToggle').value
    local amount = tonumber(ChangeCountLabel.transform:GetComponent('UIInput').value)
    body.amount = amount and amount or 0
    msg.body = body:SerializeToString()


    print('tonumber(body.amount) > 1000000：'..tostring(tonumber(body.amount) > 1000000))
    if body.amount == 0 or body.amount == nil or tonumber(body.amount) > 1000000 then
        panelMessageTip.SetParamers('请输入有效值', 1)
		PanelManager.Instance:ShowWindow('panelMessageTip')
        return 
    end

    --在游戏的情况
    if panelInGame and panelInGame.fanHuiRoomNumber and body.isAdd then
        local str = '您当前已进入房间，不可以操作增加疲劳值'
        panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, str)
		PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
        return 
    end

    local tip = '是否确认'..(body.isAdd and '增加' or '扣除')..'？\n'..
                '会员名：'..CurSelctPlayer.nickname..'\n'..
                (body.isAdd and '增加' or '扣除')..'数量：'..body.amount..'\n'..
                '处理后剩余疲劳值：'..string.format("%.2f", ChangedCountLabel.transform:GetComponent('UILabel').text)

    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
        SendProxyMessage(msg, function (msg)
            local b = proxy_pb.RResult();
            b:ParseFromString(msg.body);
            if b.code==1 then
                if not body.isAdd then
                    panelMessageTip.SetParamers('疲劳值减少成功', 2)
                else
                    panelMessageTip.SetParamers('疲劳值增加成功', 2)
                end
                PanelManager.Instance:ShowWindow('panelMessageTip')
                this.RefreshOperationFatiguePanel()
                if PanelManager.Instance:IsActive('panelMenber') then
                    panelMenber.RefreshMenber()
                end
            end
        end)
    end, nil, tip, nil, nil, 14)
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

local GiveFatiguePanel
local giveFatiguePlayerInfo = {}
local giveFatigueLabel
local leftoverFatigueLabel
local giveFatigueMyFatigueLabel
local giveFatigueConfirmButton

function this.InitGiveFatiguePanel()
    GiveFatiguePanel = gameObject.transform:Find('GiveFatiguePanel')
	giveFatiguePlayerInfo.Head = GiveFatiguePanel.transform:Find('PlayerInfo/Head')
    giveFatiguePlayerInfo.Name = GiveFatiguePanel.transform:Find('PlayerInfo/Name')
	giveFatigueLabel = GiveFatiguePanel.transform:Find('FatigueCount/Label')
    leftoverFatigueLabel = GiveFatiguePanel.transform:Find('FatigueCount/RestCount')
    giveFatigueMyFatigueLabel = GiveFatiguePanel.transform:Find('MyFatigueCount/Label')
    giveFatigueConfirmButton = GiveFatiguePanel.transform:Find('ConfirmButton')
	
    message:AddClick(giveFatigueConfirmButton.gameObject, this.OnClickGiveFatigueConfirmButton)
    message:AddOnChange(giveFatigueLabel.gameObject, this.OnChangeGiveFatigue)
end

function this.OnChangeGiveFatigue(go)
	AudioManager.Instance:PlayAudio('btn')
    --限制只能输入小数点后2位
    LimitInputFloat(giveFatigueLabel.transform:GetComponent('UIInput'),2)
    --
	giveFatigueLabel.transform:GetComponent('UIInput').value = string.gsub(giveFatigueLabel.transform:GetComponent('UIInput').value, "-", "") 
	
	local count = tonumber(giveFatigueMyFatigueLabel.transform:GetComponent('UILabel').text) 
    count = count and count or 0 
	local changeCount = tonumber(giveFatigueLabel.transform:GetComponent('UIInput').value)
    local restCount = count - (changeCount and changeCount or 0)
    leftoverFatigueLabel.transform:GetComponent('UILabel').text = restCount
end

function this.OnClickGiveFatigueConfirmButton(go)
	AudioManager.Instance:PlayAudio('btn')
	print('RefreshGiveFatiguePanel............')
	local msg = Message.New()
    msg.type = proxy_pb.UPDATE_MY_INFO_GIVE
    local body = proxy_pb.PUpdateMyInfoGive()
	local giveFee = tonumber(giveFatigueLabel.transform:GetComponent('UIInput').value)
	local myFee = tonumber(giveFatigueMyFatigueLabel.transform:GetComponent('UILabel').text)
    body.giveFee = giveFee and tostring(giveFee) or '0'
    body.clubId = panelClub.clubInfo.clubId
    msg.body = body:SerializeToString()
	if giveFee == 0 or giveFee == nil or giveFee > 1000000 then
        panelMessageTip.SetParamers('请输入有效值', 1)
		PanelManager.Instance:ShowWindow('panelMessageTip')
        return 
    end
	if giveFee > myFee then
        panelMessageTip.SetParamers('疲劳值不足', 1)
		PanelManager.Instance:ShowWindow('panelMessageTip')
        return 
    end
	if body.giveFee == 0 or body.giveFee == nil or tonumber(body.giveFee) > 1000000 then
        panelMessageTip.SetParamers('请输入有效值', 1)
		PanelManager.Instance:ShowWindow('panelMessageTip')
        return 
    end

    --在游戏的情况
    if panelInGame and panelInGame.fanHuiRoomNumber then
        local str = '您当前已进入房间，不可以操作增加疲劳值'
        panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, str)
		PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
        return 
    end
	
	local tip = '是否确认赠送？\n'..
                '上级管家：'..giveFatiguePlayerInfo.Name.transform:GetComponent('UILabel').text..'\n'..
                '赠送数量：'..body.giveFee..'\n'..
                '处理后剩余疲劳值：'..leftoverFatigueLabel.transform:GetComponent('UILabel').text
    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
        SendProxyMessage(msg, function (msg)
            local b = proxy_pb.RUpdateMyInfoGive()
            b:ParseFromString(msg.body)
			panelMessageTip.SetParamers('疲劳值赠送成功', 2)
			PanelManager.Instance:ShowWindow('panelMessageTip')
			this.RefreshGiveFatiguePanel()
			if PanelManager.Instance:IsActive('panelMenber') then
				panelMenber.RefreshMenber()
			end
        end)
    end, nil, tip, nil, nil, 14)
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.RefreshGiveFatiguePanel()
	print('RefreshGiveFatiguePanel............')
	local msg = Message.New()
    msg.type = proxy_pb.MY_INFO_GIVE
    local body = proxy_pb.PMyInfoGive()
    body.userId = CurSelctPlayer.userId
    body.clubId = panelClub.clubInfo.clubId
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local data = proxy_pb.RMyInfoGive()
        data:ParseFromString(msg.body);
        giveFatiguePlayerInfo.Name.transform:GetComponent('UILabel').text = data.nickName
		coroutine.start(LoadPlayerIcon, giveFatiguePlayerInfo.Head.transform:GetComponent('UITexture'), data.icon)
		giveFatigueMyFatigueLabel.transform:GetComponent('UILabel').text = data.myScore
		leftoverFatigueLabel.transform:GetComponent('UILabel').text = data.myScore
		giveFatigueLabel.transform:GetComponent('UIInput').value = ''
    end)
end

function this.GetPlayerInfo(userId, func)
    local msg = Message.New()
    msg.type = proxy_pb.MY_INFO_CARD
    local body = proxy_pb.PMyInfoCard()
    body.userId = userId
    body.clubId = panelClub.clubInfo.clubId
    print('拉取用户名片id：'..body.userId..", 俱乐部id："..body.clubId)
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RMyInfoCard();
        b:ParseFromString(msg.body);
        func(b)
    end)
end

local StatisticalPanel
local StatisticalRecordItem
local StatisticalRecordList
local StatisticalRecordListScrollBar
local StatisticalPanelOnlyMineToggle
function this.InitStatisticalPanel()
    StatisticalPanel = gameObject.transform:Find('StatisticalPanel')
    StatisticalRecordList = StatisticalPanel.transform:Find('RecordList')
    StatisticalRecordItem = StatisticalPanel.transform:Find('Item')
    StatisticalRecordListScrollBar = StatisticalRecordList.transform:Find('Scroll Bar')
    StatisticalPanelOnlyMineToggle = StatisticalPanel.transform:Find('onlyMine')
    --StatisticalPanelOnlyMineToggle.gameObject:SetActive(panelClub.clubInfo.userType == proxy_pb.LORD)

    local times = StatisticalPanel.transform:Find('Times')
    for i=0, 2 do
        message:AddClick(times.transform:GetChild(i).gameObject, this.OnClickStatisticalPanelSelctTime)
    end

    message:AddClick(times.transform:Find('AdvancedQuery').gameObject, this.OnClickSelectAdvanced)
    message:AddClick(StatisticalPanelOnlyMineToggle.gameObject, this.onlyMineOnclick)
end

function this.onlyMineOnclick(go)
    AudioManager.Instance:PlayAudio('btn')
end

function this.RefreshStatisticalPanel(rest)
    curPageIndex = 1
    if rest then
        startTime = os.time({year=os.date('%Y', os.time()),month=os.date('%m', os.time()),day=os.date('%d', os.time()),hour='0',min='0'})
        endTime = os.time({year=os.date('%Y', os.time()),month=os.date('%m', os.time()),day=os.date('%d', os.time()),hour='23',min='59'})
        this.SetSelectType(0)
        StatisticalPanel.transform:Find('Times').transform:Find('0'):GetComponent('UIToggle'):Set(true)
    end

    StatisticalRecordList.transform:Find('Scroll View'):GetComponent('UIScrollView'):ResetPosition()
    Util.ClearChild(StatisticalRecordList.transform:Find('Scroll View/Grid'))
    this.GetStatisticalData()
end

function this.GetStatisticalData()
    local msg = Message.New()
    msg.type = proxy_pb.SCORE_STATISTICS
    local body = proxy_pb.PScoreStatistics()
    body.clubId = panelClub.clubInfo.clubId
    body.userId = CurSelctPlayer.userId
    body.startTime = startTime
    body.endTime = endTime
    --body.showAddAmount = StatisticalPanelOnlyMineToggle:GetComponent('UIToggle').value
    msg.body = body:SerializeToString()
    PanelManager.Instance:ShowWindow('panelNetWaitting')
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RScoreStatistics()
        b:ParseFromString(msg.body)
        PanelManager.Instance:HideWindow('panelNetWaitting')
        this.RefreshStatisticalData(b, body.startTime, body.endTime)
    end)
end

function this.RefreshStatisticalData(statistics, startTime, endTime)
    local Grid = StatisticalRecordList.transform:Find('Scroll View/Grid')
    for i = 1, #statistics.datas do
        local obj = NGUITools.AddChild(Grid.gameObject, StatisticalRecordItem.gameObject)
		print('statistics.datas[i].type : '..statistics.datas[i].type)
		local str = ''
		if statistics.datas[i].type == 1000 then 
			str = '加疲劳值'
		elseif statistics.datas[i].type == 2000 then 
			str = '减疲劳值'
		elseif statistics.datas[i].type == 2007 or statistics.datas[i].type == 1005 then 
			str = '赠送疲劳值'
		else
			str = this.GetStringFromType(statistics.datas[i].type)
		end
        obj.transform:Find('Type'):GetComponent('UILabel').text = str
        obj.transform:Find('Count'):GetComponent('UILabel').text = statistics.datas[i].amount

        obj.transform:Find('StartTime'):GetComponent('UILabel').text = os.date('%Y.%m.%d', startTime)
        obj.transform:Find('EndTime'):GetComponent('UILabel').text = os.date('%Y.%m.%d', endTime)
        obj.gameObject:SetActive(true)
    end

    StatisticalPanel.transform:Find('Total/Label'):GetComponent('UILabel').text = statistics.total

    Grid.transform:GetComponent('UIGrid'):Reposition()
    StatisticalRecordList.transform:Find('Scroll View'):GetComponent('UIScrollView'):ResetPosition()
end

function this.OnClickStatisticalPanelSelctTime(go)
    AudioManager.Instance:PlayAudio('btn')
    local new = os.time()
    startTime = (new - 86400 * (tonumber(go.name)))
    endTime = (new - 86400 * (tonumber(go.name)))
    startTime = os.time({year=os.date('%Y', startTime),month=os.date('%m', startTime),day=os.date('%d', startTime),hour='0',min='0'});
    endTime = os.time({year=os.date('%Y', endTime),month=os.date('%m', endTime),day=os.date('%d', endTime),hour='23',min='59'});
    this.RefreshStatisticalPanel(false)
end

local ChangedRecordPanel
local ChangedRecordItem
local ChangedRecordList
local ChangedRecordListScrollBar
local ChangedRecordSelectType
local ChangedRecordTypePanel
function this.InitChangedRecordPanel()
    ChangedRecordPanel = gameObject.transform:Find('ChangedRecordPanel')
    ChangedRecordItem = ChangedRecordPanel.transform:Find('RecordList/Item')
    ChangedRecordList = ChangedRecordPanel.transform:Find('RecordList/Scroll View')
    ChangedRecordListScrollBar = ChangedRecordPanel.transform:Find('RecordList/Scroll Bar')
    ChangedRecordSelectType = ChangedRecordPanel.transform:Find('SelectType')
    ChangedRecordTypePanel = ChangedRecordPanel.transform:Find('TypePanel')

    local times = ChangedRecordPanel.transform:Find('Times')
    for i=0, 2 do
        message:AddClick(times.transform:GetChild(i).gameObject, this.OnClickChangedRecordPanelTime)
    end
    message:AddClick(times.transform:Find('AdvancedQuery').gameObject, this.OnClickSelectAdvanced)
    
    local types = ChangedRecordTypePanel.transform:Find('Scroll View/Grid')
    for i = 0, types.transform.childCount - 1 do
        message:AddClick(types.transform:GetChild(i).gameObject, this.OnClickChangedRecordType)
    end

    message:AddClick(ChangedRecordSelectType.gameObject, function (go)
        AudioManager.Instance:PlayAudio('btn')
        ChangedRecordTypePanel.gameObject:SetActive(true)
    end)

    message:AddClick(ChangedRecordTypePanel.transform:Find('Sprite').gameObject, function (go)
        ChangedRecordTypePanel.gameObject:SetActive(false)
    end)

    ChangedRecordList:GetComponent('UIScrollView').onDragFinished = this.OnMoveNextChangedRecord
end

function this.OnClickChangedRecordPanelTime(go)
    AudioManager.Instance:PlayAudio('btn')
    local new = os.time()
    startTime = (new - 86400 * (tonumber(go.name)))
    endTime = (new - 86400 * (tonumber(go.name)))
    startTime = os.time({year=os.date('%Y', startTime),month=os.date('%m', startTime),day=os.date('%d', startTime),hour='0',min='0'});
    endTime = os.time({year=os.date('%Y', endTime),month=os.date('%m', endTime),day=os.date('%d', endTime),hour='23',min='59'});
    this.RefreshChangedRecordPanel(false)
end

local ScoreBillStatus = {}
ScoreBillStatus[-1] = '全部'
ScoreBillStatus[0] = '待处理'
ScoreBillStatus[1] = '已同意'
ScoreBillStatus[2] = '已拒绝'
function this.RefreshChangedRecordPanel(rest)
    curPageIndex = 1
    IsResetData = true
    isSendedRequest =false
    if rest then
        startTime = os.time({year=os.date('%Y', os.time()),month=os.date('%m', os.time()),day=os.date('%d', os.time()),hour='0',min='0'})
        endTime = os.time({year=os.date('%Y', os.time()),month=os.date('%m', os.time()),day=os.date('%d', os.time()),hour='23',min='59'})
        this.SetChangedRecordType(-1)
        ChangedRecordPanel.transform:Find('Times').transform:Find('0'):GetComponent('UIToggle'):Set(true)
    end

    ChangedRecordList.transform:GetComponent('UIScrollView'):ResetPosition()
    Util.ClearChild(ChangedRecordList.transform:Find('Grid'))
    this.GetChangedRecordPanelData()
end

function this.GetChangedRecordPanelData()
    local msg = Message.New()
    msg.type = proxy_pb.SCORE_BILL_SUB_LIST
    local body = proxy_pb.PScoreBillSubList()
    body.clubId = panelClub.clubInfo.clubId
    body.userId = CurSelctPlayer.userId
    body.startTime = startTime;
    body.endTime = endTime
    body.page = curPageIndex
    body.pageSize = pageSize
    local type = GetUserData(ChangedRecordSelectType.gameObject)
    if type ~= nil then
        body.status = type
        print('type:'..body.status)
    end
    msg.body = body:SerializeToString()
    isSendedRequest = true;
    print('查询的页：'..tostring(proxy_pb.SCORE_BILL_SUB_LIST))
    SendProxyMessage(msg, this.OnGetChangedRecordPanelData)
    PanelManager.Instance:ShowWindow('panelNetWaitting')
end

function this.OnGetChangedRecordPanelData(msg)
    local b = proxy_pb.RScoreBillSubList()
    b:ParseFromString(msg.body)
    isSendedRequest = false
    PanelManager.Instance:HideWindow('panelNetWaitting')

    print('查询页的返回数据：'..tostring(#b.datas))

    if curPageIndex == 1 then
        ChangedRecordPanel.transform:Find('FatigueValue/Label'):GetComponent('UILabel').text = b.amountTotal
    end

    if #b.datas == 0 then
        if curPageIndex ~= 1 then
            IsResetData = false
            panelMessageTip.SetParamers('没有更多了', 1)
			PanelManager.Instance:ShowWindow('panelMessageTip')
        end
        return 
    end

    curPageIndex = b.page
    this.RefreshChangedRecordPanelData(b.datas)
end

function this.RefreshChangedRecordPanelData(datas)
    local Grid = ChangedRecordList.transform:Find('Grid')
    for i=1,#datas do
        local obj = NGUITools.AddChild(Grid.gameObject, ChangedRecordItem.gameObject)
        local player = obj.transform:Find('player')
        player.transform:Find('name'):GetComponent('UILabel').text = datas[i].nickname
        player.transform:Find('id'):GetComponent('UILabel').text = datas[i].userId
        coroutine.start(LoadPlayerIcon, player.transform:Find('tx'):GetComponent('UITexture'), datas[i].icon)
        
        local operator = obj.transform:Find('operator')
        operator.transform:Find('id'):GetComponent('UILabel').text = datas[i].operatorId;
        operator.transform:Find('name'):GetComponent('UILabel').text = datas[i].operatorNickname;
        coroutine.start(LoadPlayerIcon, operator.transform:Find('tx'):GetComponent('UITexture'), datas[i].operatorIcon)

        obj.transform:Find('Time'):GetComponent('UILabel').text = os.date('%Y.%m.%d %H:%M:%S', datas[i].createTime)
        obj.transform:Find('State'):GetComponent('UILabel').text = ScoreBillStatus[datas[i].status]
        obj.transform:Find('Change'):GetComponent('UILabel').text = datas[i].amount
        obj.transform:Find('Operation').gameObject:SetActive(datas[i].status == 0 and datas[i].userId == info_login.id)

        message:AddClick(obj.transform:Find('Operation/ButtonAgree').gameObject, this.OnClickOperationAgree)
        message:AddClick(obj.transform:Find('Operation/ButtonDisagree').gameObject, this.OnClickOperationAgree)

        obj.gameObject:SetActive(true)

        SetUserData(obj.gameObject, datas[i])
    end

    Grid.transform:GetComponent('UIGrid'):Reposition()
end

function this.OnClickOperationAgree(go)
    local isTrue = go.name == 'ButtonAgree'
    local data = GetUserData(go.transform.parent.parent.gameObject)
    local obj = go.transform.parent.parent.gameObject
    
    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
        panelClub.SetFeeNotice(data.number, isTrue, false, function ()
            obj.transform:Find('Operation').gameObject:SetActive(false)
            obj.transform:Find('State'):GetComponent('UILabel').text = isTrue and '已同意' or '已拒绝' 
        end)
    end, nil, '是否确认'..(isTrue and '同意' or '拒绝' )..'？')
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.OnMoveNextChangedRecord()
    print('准备拉取')
    local value = ChangedRecordListScrollBar:GetComponent('UIScrollBar').value
    if (not isSendedRequest) and (value >= 1) and IsResetData  then
		this.GetChangedRecordPanelData()
	end
end

function this.SetChangedRecordType(type)
    if type == -1 then
        SetUserData(ChangedRecordSelectType.gameObject, nil)
    else
        SetUserData(ChangedRecordSelectType.gameObject, type)
    end
    
    ChangedRecordSelectType.transform:Find('Label'):GetComponent('UILabel').text = ScoreBillStatus[type]
end

function this.OnClickChangedRecordType(go)
    AudioManager.Instance:PlayAudio('btn')
    local type = tonumber(go.name)
    this.SetChangedRecordType(type)
    ChangedRecordTypePanel.gameObject:SetActive(false)
    this.RefreshChangedRecordPanel(false)
end

function this.onSelectTime(startTimeNew, endTimeNew)
    startTime = startTimeNew
    endTime = endTimeNew

    local panel
    if this.GetSelectPanel() == 2 then
        panel = FeeBillRecordPanel
        this.GetFeeBillRecordData(false)
    elseif this.GetSelectPanel() == 3 then
        panel = StatisticalPanel
        this.RefreshStatisticalPanel(false)
    elseif this.GetSelectPanel() == 4 then
        panel = ChangedRecordPanel
        this.RefreshChangedRecordPanel(false)
    end

    local times = panel.transform:Find('Times')
    for i=0, 2 do
        times.transform:GetChild(i):GetComponent('UIToggle'):Set(false)
    end
end

function this.Update()
    
end

function this.OnClickCloseBtn(go)

    if CurSelctPlayer.fromWindow == "panelMatchMenberManager" then
        panelMatchMenberManager.RefrehBasicsInfoPage()
    end

    PanelManager.Instance:HideWindow(gameObject.name)
end