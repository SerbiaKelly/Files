panelSearch = {}
local this = panelSearch;

local message
local gameObject

--查询的条件
local startTime--开始时间
local endTime--结束时间
local page=1--页数 从1开始
local pageSize=20--每页个数
local userId=nil--玩家id
local playId=nil--玩法id
local roomNumber=nil--房间号


local ButtonStartTime
local ButtonEndTime
local selectTime
local selectTimeText
local selectTimeGrid
local selectTimeItem
local selectTimeMask

local listTimeItem={}

local SelectPlay--选择玩法按钮
local playPanel--玩法的选择界面
local playGrid--玩法的布局
local playItem--玩法的预制体
local nowtimeChuo = os.time()
local nowtime = os.date('%Y/%m/%d', nowtimeChuo)

local ButtonClose
local ButtonSure

local startTime--开始时间
local endTime--结束时间


local managerPlayer
local mamberPlayer
local MenberListData
local managerListData

local roomNumberInput

function this.Update()
   
end

--���¼�--
function this.Awake(obj)
	gameObject = obj;
	message = gameObject:GetComponent('LuaBehaviour');
	ButtonClose = gameObject.transform:Find('BaseContent/ButtonClose');
	message:AddClick(ButtonClose.gameObject, this.OnClickClose);
	
	ButtonSure = gameObject.transform:Find('OkButton');
	message:AddClick(ButtonSure.gameObject, this.OnClickSure);

    ButtonStartTime = gameObject.transform:Find('ButtonStartTime');
    ButtonStartTime:Find('Label'):GetComponent('UILabel').text = nowtime
    ButtonEndTime = gameObject.transform:Find('ButtonEndTime');
    ButtonEndTime:Find('Label'):GetComponent('UILabel').text = nowtime
    selectTime = gameObject.transform:Find('selecTime');
    selectTimeText = selectTime:Find('Label');
    selectTimeGrid = selectTime:Find('TimeGrid');
    selectTimeItem = selectTime:Find('item');
    selectTimeMask = selectTime.transform:Find('BaseContent/mask');
    
    roomNumberInput = gameObject.transform:Find('roomNumber')
    
    SelectPlay = gameObject.transform:Find('SelectPlay')
    message:AddClick(SelectPlay.gameObject, this.GetPlay)
    
    playPanel = gameObject.transform:Find('panel')
    playGrid=playPanel:Find('Scroll View/Grid')
    playItem=playPanel:Find('Item')
    message:AddClick(playPanel:Find('Sprite').gameObject, this.closePlayPanel)
	 
    message:AddClick(ButtonStartTime.gameObject, this.OnClickStartTime);
    message:AddClick(ButtonEndTime.gameObject, this.OnClickEndTime);
    message:AddClick(selectTimeMask.gameObject, this.OnClickTimeMask);

    managerPlayer = gameObject.transform:Find('Player1/Input')
    mamberPlayer = gameObject.transform:Find('Player2/Input')
    
    
    for i = 1, 2 do
        local button = gameObject.transform:Find('Player'..i..'/SelButton')
        local input = gameObject.transform:Find('Player'..i..'/Input')
        if i==1 then
            message:AddClick(input.gameObject, function (go)
                this.SelctPlayer(managerListData,function (userId)
                    input:Find('Label'):GetComponent('UILabel').text = userId
                end)
            end)
            message:AddClick(button.transform.gameObject, function (go)
                this.SelctPlayer(managerListData,function (userId)
                    input:Find('Label'):GetComponent('UILabel').text = userId
                end)
            end)
        else
            message:AddClick(input.gameObject, function (go)
                userId=nil
                gameObject.transform:Find('Player2/Input/Label'):GetComponent('UILabel').text='  请输入成员ID'
                this.SelctPlayer(MenberListData,function (userId)
                    input:Find('Label'):GetComponent('UILabel').text = panelSelMenber.dictionary[userId]
                    SetUserData(gameObject.transform:Find('Player2/Input/Label').gameObject, userId)
                end)
            end)
            message:AddClick(button.transform.gameObject, function (go)
                userId=nil
                gameObject.transform:Find('Player2/Input/Label'):GetComponent('UILabel').text='  请输入成员ID'
                this.SelctPlayer(MenberListData,function (userId)
                    input:Find('Label'):GetComponent('UILabel').text = panelSelMenber.dictionary[userId]
                    SetUserData(gameObject.transform:Find('Player2/Input/Label').gameObject, userId)
                end)
            end)
        end
    end
end
function this.SelctPlayer(MemberList, func)
    local data = {}
    data.func = func
    data.MemberList = MemberList
    PanelManager.Instance:ShowWindow('panelSelMenber',data)
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
    for j = 1, #panelClub.clubInfo.plays do
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



function this.OnClickClose(go)
	AudioManager.Instance:PlayAudio('btn')
    
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickTimeMask(go)
    AudioManager.Instance:PlayAudio('btn')
    selectTime.gameObject:SetActive(false)
end

function this.OnClickStartTime(go)
    AudioManager.Instance:PlayAudio('btn')
    Util.ClearChild(selectTimeGrid)
    for i=#listTimeItem,1,-1 do
        table.remove(listTimeItem,i)
    end
    selectTime.gameObject:SetActive(true)
    selectTimeText:GetComponent('UILabel').text = '选择开始时间'
    for i=1,7 do
        local item = {}
        item.GO = NGUITools.AddChild(selectTimeGrid.gameObject, selectTimeItem.gameObject)
        item.GO:SetActive(true)
        item.GO.name = 'item'..i
        item.timeChou = nowtimeChuo-86400*(i-1)
        local timeToggle = item.GO.transform:Find('ButtonTime'):GetComponent('UIToggle')
        message:AddClick(item.GO.transform:Find('ButtonTime'):GetComponent('UIButton').gameObject, this.ButtonSound);
        if ButtonStartTime:Find('Label'):GetComponent('UILabel').text==os.date('%Y/%m/%d', item.timeChou) then
            timeToggle.value=true
        else
            timeToggle.value=false
        end
        item.GO.transform:Find('ButtonTime/Label'):GetComponent('UILabel').text = os.date('%Y/%m/%d', item.timeChou)
        listTimeItem[i]=item
    end
    selectTimeGrid:GetComponent('UIGrid'):Reposition()
end

function this.OnClickEndTime(go)
    AudioManager.Instance:PlayAudio('btn')
    Util.ClearChild(selectTimeGrid)
    for i=#listTimeItem,1,-1 do
        table.remove(listTimeItem,i)
    end
    selectTime.gameObject:SetActive(true)
    selectTimeText:GetComponent('UILabel').text = '选择结束时间'
    local needMoRen=false
    for i=1,7 do
        local item = {}
        item.GO = NGUITools.AddChild(selectTimeGrid.gameObject, selectTimeItem.gameObject)
        
        item.GO.name = 'item'..i
        item.timeChou = nowtimeChuo-86400*(i-1)
        local timeToggle = item.GO.transform:Find('ButtonTime'):GetComponent('UIToggle')
        message:AddClick(item.GO.transform:Find('ButtonTime'):GetComponent('UIButton').gameObject, this.ButtonSound);
        if ButtonStartTime:Find('Label'):GetComponent('UILabel').text>os.date('%Y/%m/%d', item.timeChou) then
            item.GO:SetActive(false)
            timeToggle.value=false
            if ButtonEndTime:Find('Label'):GetComponent('UILabel').text==os.date('%Y/%m/%d', item.timeChou) then
                needMoRen=true
            end
        else
            item.GO:SetActive(true)
            if ButtonEndTime:Find('Label'):GetComponent('UILabel').text==os.date('%Y/%m/%d', item.timeChou) then
                timeToggle.value=true
            else
                timeToggle.value=false
            end
        end
        
        item.GO.transform:Find('ButtonTime/Label'):GetComponent('UILabel').text = os.date('%Y/%m/%d', item.timeChou)
        listTimeItem[i]=item
    end
    if needMoRen then
        selectTimeGrid:Find('item1/ButtonTime'):GetComponent('UIToggle'):Set(true)
    end
    selectTimeGrid:GetComponent('UIGrid'):Reposition()
end

function this.ButtonSound(go)
	AudioManager.Instance:PlayAudio('btn')
	selectTime.gameObject:SetActive(false)
    for i=1,#listTimeItem do
        if listTimeItem[i].GO.transform:Find('ButtonTime'):GetComponent('UIToggle').value then
            if selectTimeText:GetComponent('UILabel').text == '选择开始时间' then
                ButtonStartTime:Find('Label'):GetComponent('UILabel').text = os.date('%Y/%m/%d', listTimeItem[i].timeChou)
                break
            else
                ButtonEndTime:Find('Label'):GetComponent('UILabel').text = os.date('%Y/%m/%d', listTimeItem[i].timeChou)
                break
            end
        end
    end
end

local whoShow
function this.WhoShow(data)
	whoShow=data
	-- if whoShow=='panelMenberRecord' then
	-- 	ButtonDelete.parent.localPosition=Vector3(-287,110,0)
	-- elseif whoShow=='panelRoomRecord' then
	-- 	ButtonDelete.parent.localPosition=Vector3(238,135,0)
	-- elseif whoShow == 'panelSelMenber' then
	-- 	ButtonDelete.parent.localPosition=Vector3(238,179,0)
	-- end
end



function this.OnClickSure(go)
	AudioManager.Instance:PlayAudio('btn')
    local st= ButtonStartTime:Find('Label'):GetComponent('UILabel').text
    local ed= ButtonEndTime:Find('Label'):GetComponent('UILabel').text
    print("开始时间："..st.."，结束时间："..ed)
    startTime = os.time({year=string.sub (st, 1,4),month=string.sub (st, 6,7),day=string.sub (st, 9,10)});
    endTime = os.time({year=string.sub (ed, 1,4),month=string.sub (ed, 6,7),day=string.sub (ed, 9,10)});
    
    -- local manageid= gameObject.transform:Find('Player2/Input/Label'):GetComponent('UILabel').text
    local memberid= GetUserData(gameObject.transform:Find('Player2/Input/Label').gameObject)
    if memberid==nil then
        userId=nil
    else
        userId=memberid
    end
    -- if manageid=='  请输入管理员ID' then
    --     userId=nil
    -- else
    --     userId=manageid
    -- end

    local playdata=GetUserData(SelectPlay.gameObject)
    if playdata==nil then
        playId=nil
    else
        playId=playdata.playId
    end

    local roominput=roomNumberInput:Find('Input'):GetComponent('UIInput').value
    if roominput~='' and string.len(roominput)==5 then
		roomNumber=roominput
    else
        roomNumber=nil
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
    body.page=tostring(page)
    body.pageSize=tostring(pageSize)
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RRoomList()
        b:ParseFromString(msg.body);
        panelMenberRecord.initAll()
        panelMenberRecord.setSearchData(startTime,endTime)
        panelMenberRecord.RefreshRoomList(b)
    end)
   
	PanelManager.Instance:HideWindow(gameObject.name)
end



function this.Start()
	-- gameObject.transform.parent = panelLobby.gameObject.transform
end

function this.OnEnable()
    this.GetMenberData()
end


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
        MenberListData = b.users
        managerListData={}
        for i=1,#b.users do
            if b.users[i].userType==proxy_pb.MANAGER then
                table.insert(managerListData,b.users[i])
            end
        end
        print('管理员人数'..#managerListData)
        PanelManager.Instance:HideWindow('panelNetWaitting')
    end)
end