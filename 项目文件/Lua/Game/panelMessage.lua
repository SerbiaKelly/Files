require "Game.Tools.UITools"

panelMessage={}
local this = panelMessage;

local message
local gameObject

local CloseButton

local Toggles
local ToggleClubMessage
local clubMessageSign
local ToggleJoinMessage
local ToggleQuitMessage
local ToggleClubNotice
local ToggleAlertMessage
local alertbMessageSign

local Pages
local MessagesPage
local MessagesPageScrollView
local MessageItemPrefab
local MessageManagerBtn
local MessageDeletBtn
local MessageSelectAllBtn
local MessageObjects = {}

local ClubNoticePage
local SubmissionButton

local fuFeeValueTiShi
local playerIDFuFeeValueTiShi
local roomNumFuFeeValueTiShi
local isSelfFuFeeValueTiShi
local feeNumFuFeeValueTiShi
local fuFeeValueTiShiData

local Remind = 0
local warn = 1
local answer = 2
local join = 3
local quit = 4
local fuFee = 5
local blackRoom = 6
local giveFee = 7
local alert = 8
local forbid = 9
local freeze = 10
function this.Awake(go)
    gameObject = go;
    message = gameObject:GetComponent('LuaBehaviour');
    
    CloseButton = gameObject.transform:Find('BaseContent/ButtonClose')

    Toggles = gameObject.transform:Find('Toggles')
	ToggleClubMessage = Toggles.transform:Find('ToggleClubMessage')
	clubMessageSign = ToggleClubMessage.transform:Find('dian')
    ToggleJoinMessage = Toggles.transform:Find('ToggleJoinMessage')
	ToggleQuitMessage = Toggles.transform:Find('ToggleQuitMessage')
	ToggleClubNotice = Toggles.transform:Find('ToggleClubNotice')
	ToggleAlertMessage = Toggles.transform:Find('ToggleAlertMessage')
	alertbMessageSign  = ToggleAlertMessage.transform:Find('dian')
	
    Pages = gameObject.transform:Find('Pages')
    MessagesPage = Pages.transform:Find('MessagesPage')
    MessagesPageScrollView = MessagesPage.transform:Find('Scroll View')
    MessageManagerBtn = MessagesPage.transform:Find('ManageButton')
    MessageItemPrefab = gameObject.transform:Find('Prefabs/MessageItem')

    MessageDeletBtn = MessagesPage.transform:Find('Operation/DeletButton')
    MessageSelectAllBtn = MessagesPage.transform:Find('Operation/SeletAllButton')

    for i = 0, Toggles.transform.childCount - 2 do
        message:AddClick(Toggles.transform:GetChild(i).gameObject, this.OnClickToggles)
    end

    MessagesPageScrollView:GetComponent('UIScrollView').onDragFinished = this.OnScrollViewMove

    ClubNoticePage = Pages.transform:Find('ClubNoticePage')
    SubmissionButton = ClubNoticePage.transform:Find('SubmissionButton')

	fuFeeValueTiShi = gameObject.transform:Find('fuFeeValueTiShi')
	playerIDFuFeeValueTiShi = fuFeeValueTiShi:Find('message/playerID')
	roomNumFuFeeValueTiShi = fuFeeValueTiShi:Find('message/roomNum')
	isSelfFuFeeValueTiShi = fuFeeValueTiShi:Find('message/isSelf')
	feeNumFuFeeValueTiShi = fuFeeValueTiShi:Find('message/feeNum')

	message:AddClick(playerIDFuFeeValueTiShi.gameObject, this.OnClickPlayerID)
	message:AddClick(roomNumFuFeeValueTiShi.gameObject, this.OnClickRoomNum)
	message:AddClick(fuFeeValueTiShi:Find('ButtonClose').gameObject, function (go)
        fuFeeValueTiShi.gameObject:SetActive(false)
	end)
	message:AddClick(fuFeeValueTiShi:Find('ButtonOK').gameObject, function (go)
        fuFeeValueTiShi.gameObject:SetActive(false)
    end)

    message:AddClick(CloseButton.gameObject, this.CloseButton)
    message:AddClick(MessageManagerBtn.gameObject, this.OnClickManager)
    message:AddClick(MessageSelectAllBtn.gameObject, this.OnClickSeletAll)
    message:AddClick(MessageDeletBtn.gameObject, this.OnDeletClubMessage)
	message:AddClick(SubmissionButton.gameObject, this.OnClickSubmissionButton)
	message:AddClick(ToggleClubNotice.gameObject, this.GetClubNotice)
	message:AddClick(ToggleAlertMessage.gameObject, this.OnClickToggleAlertMessage)
end

function this.OnEnable()
	ToggleClubMessage:GetComponent('UIToggle'):Set(true)
	ToggleJoinMessage:GetComponent('UIToggle'):Set(false)
	ToggleQuitMessage:GetComponent('UIToggle'):Set(false)
	ToggleClubNotice:GetComponent('UIToggle'):Set(false)
	ToggleAlertMessage:GetComponent('UIToggle'):Set(false)
	if ToggleClubNotice:GetComponent('UIToggle').value then
		this.InitClubNotice()
	else
		this.AutoRequestMessage(true)
	end
	fuFeeValueTiShi.gameObject:SetActive(false)
	MessagesPage.gameObject:SetActive(not ToggleClubNotice:GetComponent('UIToggle').value)
	ToggleAlertMessage.gameObject:SetActive(panelClub.clubInfo.userType ~= proxy_pb.GENERAL)
	Toggles:GetComponent('UIGrid'):Reposition()
end

function this.OnClickToggles(go)
    AudioManager.Instance:PlayAudio('btn')
    this.RsetSendData()
    this.RequestMessage(this.GetMessageType())
end

function this.GetMessageType()
    local activeToggle = nil
    for i = 0, Toggles.childCount - 1 do
        if Toggles:GetChild(i):GetComponent('UIToggle').value then
            activeToggle = Toggles:GetChild(i)
            break
        end
    end

    local types = {}
	if ToggleClubMessage == activeToggle then
        table.insert(types, Remind)
        table.insert(types, warn)
		table.insert(types, answer)
		table.insert(types, fuFee)
		table.insert(types, blackRoom)
		table.insert(types, giveFee)
    elseif ToggleJoinMessage == activeToggle then
        table.insert(types, join)
    elseif ToggleQuitMessage == activeToggle then
        table.insert(types, quit)
	elseif ToggleAlertMessage == activeToggle then
        table.insert(types, alert)
        table.insert(types, forbid)
        table.insert(types, freeze)
    end

    return types
end

local CurPageIndex = 1
local ConstPageSize = 10
local IsResetData = true --是否还数据
local isSendedRequest = false;
local IsInManager = false
function this.RsetSendData()
    CurPageIndex = 1
    MessageObjects = {}
	IsInManager = false
	IsResetData = true
	MessagesPageScrollView:GetComponent('UIScrollView').verticalScrollBar.value = 0
    MessageDeletBtn.parent.gameObject:SetActive(false)
	MessagesPageScrollView.transform:GetComponent('UIScrollView'):ResetPosition()
	Util.ClearChild(MessagesPageScrollView:Find('Grid'))
end

function this.AutoRequestMessage(isRest)
    local types = this.GetMessageType()
	
    if isRest then
        this.RsetSendData()
    end
	print('verticalScrollBar : '..MessagesPageScrollView:GetComponent('UIScrollView').verticalScrollBar.value)
    this.RequestMessage(types)
end

function this.RequestMessage(types)
    local msg = Message.New()
    msg.type = proxy_pb.CLUB_MESSAGE;
    local body = proxy_pb.PClubMessage()
	body.clubId = panelClub.clubInfo.clubId
	print('CurPageIndex : '..tostring(CurPageIndex))
    body.page = CurPageIndex
    body.pageSize = ConstPageSize
    for i = 1, #types do
        body.messageType:append(types[i])
    end
    msg.body = body:SerializeToString()
    isSendedRequest = true
    PanelManager.Instance:ShowWindow('panelNetWaitting')
    SendProxyMessage(msg, this.OnReturnMessage)
end

function this.OnReturnMessage(msg)
    local data = proxy_pb.RClubMessageList()
    data:ParseFromString(msg.body)
    isSendedRequest = false
	PanelManager.Instance:HideWindow('panelNetWaitting')
	clubMessageSign.gameObject:SetActive(panelClub.clubInfo.realMsg.remindCount~=0)
	alertbMessageSign.gameObject:SetActive(panelClub.clubInfo.realMsg.alertCount~=0)
	if CurPageIndex == 1 then
		print('置顶数据')
        MessagesPageScrollView.transform:GetComponent('UIScrollView'):ResetPosition()
    end

	if #data.messages < 10 then
		IsResetData = false
	end
    if #data.messages == 0 then
		if CurPageIndex == 1 then
            --NoData.gameObject:SetActive(true)
            MessagesPage.transform:Find('NoData').gameObject:SetActive(true)
		end
		return 
    end
	
    CurPageIndex = data.page;
    MessagesPage.transform:Find('NoData').gameObject:SetActive(false)
    this.RefreshMessagePage(data.messages)
end

function this.RefreshMessagePage(messages)
    local Grid = MessagesPageScrollView:Find('Grid'):GetComponent('UIGrid')
	print('ssssssssssssssssssssssssss #messages : '..tostring(#messages))
    for i = 1, #messages do
        local obj = NGUITools.AddChild(Grid.gameObject, MessageItemPrefab.gameObject)
        SetUserData(obj.gameObject, messages[i])

        obj.transform:Find('View/Time'):GetComponent('UILabel').text=os.date('%Y.%m.%d %H:%M:%S', messages[i].time)
		--obj.transform:Find('View/Message'):GetComponent('UILabel').text = messages[i].content
		if messages[i].type == 6 then
			obj.transform:Find('View/Message'):GetComponent('UILabel').text = '小黑屋消息'
		elseif messages[i].type == 8 then
			obj.transform:Find('View/Message'):GetComponent('UILabel').text = '预警消息'
		elseif messages[i].type == 9 then
			obj.transform:Find('View/Message'):GetComponent('UILabel').text = '限制消息'
		elseif messages[i].type == 10 then
			obj.transform:Find('View/Message'):GetComponent('UILabel').text = '暂停消息'
		else
			obj.transform:Find('View/Message'):GetComponent('UILabel').text = messages[i].content
		end
        
		local DetailsButton = obj.transform:Find('DetailsButton')
        local FeeOperation = obj.transform:Find('FeeOperation')
        
        DetailsButton.gameObject:SetActive(true)

        if messages[i].flag  then
			DetailsButton.transform:GetComponent('UISprite').spriteName = '界面-蓝色按钮 - 灰色状态'
		end

        if messages[i].type == 2 then
			if messages[i].result ~= '0' then
				FeeOperation.transform:Find('Label').gameObject:SetActive(true)
				FeeOperation.transform:Find('Label'):GetComponent('UILabel').text = messages[i].result == '1' and '已同意' or '已拒绝' 
			else
				FeeOperation.transform:Find('Operation').gameObject:SetActive(true)
			end
        end
        
        coroutine.start(LoadPlayerIcon, obj.transform:Find('View/Image'):GetComponent('UITexture'), messages[i].picture)

        obj.gameObject:SetActive(true)
        table.insert(MessageObjects, obj)
        message:AddClick(DetailsButton.gameObject, this.OnClickDetails)
        message:AddClick(FeeOperation:Find('Operation'):Find('AgreeButton').gameObject, this.OnClickFeeOperation)
		message:AddClick(FeeOperation:Find('Operation'):Find('RefuseButton').gameObject, this.OnClickFeeOperation)
    end
    Grid.transform:GetComponent('UIGrid'):Reposition()
end

function this.OnScrollViewMove()
	local pos = MessagesPageScrollView:GetComponent('UIScrollView').verticalScrollBar.value
	print(' isSendedRequest : '..tostring(isSendedRequest)..' pos : '..tostring(pos)..' IsResetData : '..tostring(IsResetData)..' IsInManager : '..tostring(IsInManager))
	if (not isSendedRequest) and (pos >= 1) and not IsInManager then
		if IsResetData then
			this.AutoRequestMessage()
		else
			panelMessageTip.SetParamers('没有更多了', 1)
            PanelManager.Instance:ShowWindow('panelMessageTip')
		end
	end
end

function this.OnClickDetails(go)
	AudioManager.Instance:PlayAudio('btn')
	local data = GetUserData(go.transform.parent.gameObject)
	if data.type == 5 then
		this.SetFuFeeTiShi(data)
	else
		local str = data.content
		if data.type == 6 then 
			local msg = SplitString(data.content,'|')
			str = '玩家'..msg[1]..'，同一天有'..msg[2]..'次对局中作为赢家，让输家的负疲劳值达到了群主设置的负疲劳值数'..msg[3]..'，已被限制减疲劳值，且被系统自动拉小黑屋，不可进入游戏。如有疑问，请联系群主！'
		end
		panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, str)
		PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
	end
	this.ReadMessage(data.id, function ()
		go:SetActive(false)
		go.transform:GetComponent('UISprite').spriteName = '界面-蓝色按钮 - 灰色状态'
		go:SetActive(true)
		this.AutoRequestMessage()
	end)
end

function this.SetFuFeeTiShi(data)
	fuFeeValueTiShiData = data
	fuFeeValueTiShi.gameObject:SetActive(true)
	playerIDFuFeeValueTiShi:GetComponent('UILabel').text = data.userId
	roomNumFuFeeValueTiShi:GetComponent('UILabel').text = data.lossNumber
	isSelfFuFeeValueTiShi:GetComponent('UILabel').text = '负疲劳值大于等于'..(data.lossOnwerFee and '群主' or '你')..'设置的负疲劳'
	feeNumFuFeeValueTiShi:GetComponent('UILabel').text = data.lossFee 
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
			--this.SubtractMsgCount(1)
		end
	end)
end

function this.OnClickFeeOperation(go)
	local data = GetUserData(go.transform.parent.parent.parent.gameObject)
	local FeeOperation = go.transform.parent.parent.parent:Find('FeeOperation')
	local isTrue = go.name == 'AgreeButton'
	panelClub.SetFeeNotice(data.id, isTrue, true, function ()
		FeeOperation.transform:Find('Operation').gameObject:SetActive(false)
		FeeOperation.transform:Find('Label').gameObject:SetActive(true)
		FeeOperation.transform:Find('Label'):GetComponent('UILabel').text = isTrue and '已同意' or '已拒绝' 
	end)
	--this.ReadMessage(data.id)
end

function this.CloseButton(go)
    AudioManager.Instance:PlayAudio('btn')
	PanelManager.Instance:HideWindow(gameObject.name)
	if not PanelManager.Instance:IsActive('panelClub') then
		local data={}
        data.name=gameObject.name
		PanelManager.Instance:ShowWindow('panelClub',data)
	else
		panelClub.shuaXinClub()
	end
	
end

function this.OnClickManager(go)
	AudioManager.Instance:PlayAudio('btn')
	IsInManager = not IsInManager 
	for i=1,#MessageObjects do
		MessageDeletBtn.parent.gameObject:SetActive(IsInManager)
		this.SetInManager(MessageObjects[i])
	end
end

function this.SetInManager(obj)
	local choiceToggle = obj.transform:Find('ChoiceToggle')
	choiceToggle.gameObject:SetActive(IsInManager)
	if (not IsInManager) then
		choiceToggle.transform:GetComponent('UIToggle'):Set(false)
	end
	obj.transform:Find('View').localPosition = IsInManager and Vector3(60,0,0) or Vector3(0,0,0)  
end

function this.OnClickSeletAll(go)
	AudioManager.Instance:PlayAudio('btn')
    for i=1, #MessageObjects do
        local ChoiceToggle = MessageObjects[i].transform:Find('ChoiceToggle'):GetComponent('UIToggle')
		ChoiceToggle:Set(not ChoiceToggle.value)
	end
end

function this.OnDeletClubMessage(go)
	AudioManager.Instance:PlayAudio('btn')
	local choiceIds = {}
	for i=1,#MessageObjects do
		local isChoice = MessageObjects[i].transform:Find('ChoiceToggle'):GetComponent('UIToggle').value
		if isChoice then
			local data = GetUserData(MessageObjects[i])
			table.insert(choiceIds, data.id)
		end
	end

	this.DeletMessage(choiceIds, function ()
		this.AutoRequestMessage(true)
		MessageDeletBtn.parent.gameObject:SetActive(false)
	end)
end

function this.DeletMessage(ids, func)
	local msg = Message.New()
	msg.type = proxy_pb.DELETE_CLUB_MESSAGE;
	local body=proxy_pb.PDeleteClubMessage()
	body.clubId = panelClub.clubInfo.clubId
	for i = 1, #ids do
		body.ids:append(ids[i])
	end
	msg.body = body:SerializeToString()
	SendProxyMessage(msg, function (msg)
		local b = proxy_pb.RResult();
		b:ParseFromString(msg.body);
		if b.code == 1 then
			func()
			--this.SubtractMsgCount(#ids)
		end
	end)
end


--[ 
function this.InitClubNotice()
    this.GetClubNotice()
end

function this.GetClubNotice(go)
	AudioManager.Instance:PlayAudio('btn')
	local msg = Message.New()
	msg.type = proxy_pb.CLUB_NOTICE;
	local body=proxy_pb.PClubNotice()
	body.clubId=panelClub.clubInfo.clubId
	msg.body = body:SerializeToString()
	SendProxyMessage(msg, this.OnGetClubNotice);
end

function this.OnGetClubNotice(msg)
	local b = proxy_pb.RClubNotice();
    b:ParseFromString(msg.body);
    this.SetClubNotice(b)
end

function this.SetClubNotice(data)
	local str
	if data.content ~= '' then
		str = data.content
	else
		if data.canEdit then
			str = '输入公告内容'
		else
			str = '暂无公告'
		end
	end
    
    ClubNoticePage.transform:Find('Label'):GetComponent('UIInput').value = str
    ClubNoticePage.transform:Find('Label'):GetComponent('BoxCollider').enabled = IsCanSetGonggao()
	SubmissionButton.gameObject:SetActive(IsCanSetGonggao())
end

function this.OnClickSubmissionButton(go)
	AudioManager.Instance:PlayAudio('btn')
	local wenBen = ClubNoticePage.transform:Find('Label'):GetComponent('UIInput').value

	local msg = Message.New()
	msg.type = proxy_pb.EDIT_CLUB_NOTICE;
	local body=proxy_pb.PEditClubNotice()
	body.clubId=panelClub.clubInfo.clubId
	body.content=wenBen
	msg.body = body:SerializeToString()
	SendProxyMessage(msg, this.editResult);
end

function this.editResult(msg)
	local b = proxy_pb.RResult()
	b:ParseFromString(msg.body)
	if b.code == 1 then
		panelClub.NoticeContent = ClubNoticePage.transform:Find('Label'):GetComponent('UIInput').value
		panelClub.OnGetNotice()
        panelMessageTip.SetParamers('修改成功', 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	end
end
--]
function this.OnClickPlayerID(go)
	AudioManager.Instance:PlayAudio('btn')
	fuFeeValueTiShi.gameObject:SetActive(false)
	PanelManager.Instance:HideWindow(gameObject.name)
	local data = {}
    data.index = 1
    data.playerIDFuFeeValue = fuFeeValueTiShiData.userId
	PanelManager.Instance:ShowWindow('panelMenber', data)
end

function this.OnClickRoomNum(go)
	AudioManager.Instance:PlayAudio('btn')
	fuFeeValueTiShi.gameObject:SetActive(false)
	PanelManager.Instance:HideWindow(gameObject.name)
	local data = {}
	data.name = gameObject.name
	data.roomNumFuFeeValue = fuFeeValueTiShiData.lossNumber
	data.userId = fuFeeValueTiShiData.userId
	print('data.userId : '..data.userId)
	PanelManager.Instance:ShowWindow('panelMenberRecord',data)
end

function this.Update()
end
