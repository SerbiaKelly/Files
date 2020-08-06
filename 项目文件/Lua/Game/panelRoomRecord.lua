local proxy_pb = require 'proxy_pb'

panelRoomRecord = {}

local this=panelRoomRecord
local RecordList={}
local message;
local gameObject;
local mask
local Grid
local prefabItem
local buttonClose
local tip

local SearchInput
local SearchButton

local clubName
local clubID
local juShu
local consume

local ButtonStartTime
local ButtonEndTime
local selectTime
local selectTimeText
local selectTimeGrid
local selectTimeItem
local selectTimeSure
local selectTimeMask

local ButtonGetRecord

local nowtimeChuo = os.time()
local nowtime = os.date('%Y/%m/%d', nowtimeChuo)
local listTimeItem={}
--启动事件--
function this.Awake(obj)
    gameObject = obj;
	message = gameObject:GetComponent('LuaBehaviour');

    mask = gameObject.transform:Find('BaseContent/mask');
    Grid = gameObject.transform:Find('Grid');
	buttonClose = gameObject.transform:Find('BaseContent/ButtonClose');
	tip = gameObject.transform:Find('tip');
    prefabItem = gameObject.transform:Find('item');
    
    clubID = gameObject.transform:Find('Top/clubID');
    clubName = gameObject.transform:Find('Top/clubName');
    juShu = gameObject.transform:Find('Top/juShu');
    consume = gameObject.transform:Find('Top/consume');

    
    SearchInput = gameObject.transform:Find('input');
    SearchButton = gameObject.transform:Find('ButtonSearch');

    ButtonGetRecord = gameObject.transform:Find('ButtonGetRecord');
    ButtonStartTime = gameObject.transform:Find('ButtonStartTime');
    ButtonStartTime:Find('Label'):GetComponent('UILabel').text = nowtime
    ButtonEndTime = gameObject.transform:Find('ButtonEndTime');
    ButtonEndTime:Find('Label'):GetComponent('UILabel').text = nowtime
    selectTime = gameObject.transform:Find('selecTime');
    selectTimeText = selectTime:Find('Label');
    selectTimeGrid = selectTime:Find('TimeGrid');
    selectTimeItem = selectTime:Find('item');
    selectTimeSure = selectTime.transform:Find('ButtonSure');
    selectTimeMask = selectTime.transform:Find('mask');

    message:AddClick(ButtonGetRecord.gameObject, this.OnClickGetRecord);
    message:AddClick(ButtonStartTime.gameObject, this.OnClickStartTime);
    message:AddClick(ButtonEndTime.gameObject, this.OnClickEndTime);
    message:AddClick(selectTimeSure.gameObject, this.OnClickTimeSure);
    message:AddClick(selectTimeMask.gameObject, this.OnClickTimeMask);
    message:AddClick(SearchInput.gameObject, this.OnClickSearch);
    -- message:AddOnChange(SearchInput.gameObject, this.OnClickSearch)

    --message:AddClick(mask.gameObject, this.OnClickMask);
	message:AddClick(buttonClose.gameObject, this.OnClickMask);
end

local MemberListGO={}
function this.setSearchInput(str)
    SearchInput:GetComponent('UILabel').text=str
    this.OnSearch(str)
end
function this.OnClickSearch(go)
    PanelManager.Instance:ShowWindow('keyborad', gameObject.name)
end
function this.OnSearch(data)
    local num=0
    for i=1,#MemberListGO do
        -- if string.find(MemberListGO[i].userId[1],data)==nil
        -- and string.find(MemberListGO[i].userId[2],data)==nil
        -- and string.find(MemberListGO[i].userId[3],data)==nil then
        --     MemberListGO[i].GO:SetActive(false)
        -- else
        --     MemberListGO[i].GO:SetActive(true)
        --     num=num+1
        -- end

        for j = 1, #MemberListGO[i].userId do
            if string.find(MemberListGO[i].userId[j],data)==nil then
                MemberListGO[i].GO:SetActive(false)
            else
                MemberListGO[i].GO:SetActive(true)
                num=num+1
            end
        end
    end
    Grid:GetComponent('UIGrid').repositionNow = true
    Grid:GetComponent('UIGrid'):Reposition()
    Grid:GetComponent('UIScrollView'):ResetPosition()
    if num==0 then
        tip:GetComponent('UILabel').text='没有该玩家'
		tip.gameObject:SetActive(true)
    else
        tip.gameObject:SetActive(false)
    end
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

function this.ButtonSound(go)
    AudioManager.Instance:PlayAudio('btn')
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

function this.OnClickTimeSure(go)
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

function this.OnClickGetRecord(go)
    AudioManager.Instance:PlayAudio('btn')
    local st= ButtonStartTime:Find('Label'):GetComponent('UILabel').text
    local ed= ButtonEndTime:Find('Label'):GetComponent('UILabel').text
    local startTime = os.time({year=string.sub (st, 1,4),month=string.sub (st, 6,7),day=string.sub (st, 9,10)});
    local endTime = os.time({year=string.sub (ed, 1,4),month=string.sub (ed, 6,7),day=string.sub (ed, 9,10)});
    this.sendMSG(startTime,endTime)
end

function this.OnClickTimeMask(go)
    AudioManager.Instance:PlayAudio('btn')
    selectTime.gameObject:SetActive(false)
end


function this.Update()
   
end
function this.Start()

end

function this.OnEnable()
    local startTime, endTime

    startTime = nowtimeChuo
    endTime = nowtimeChuo

    ButtonStartTime:Find('Label'):GetComponent('UILabel').text=os.date('%Y/%m/%d',startTime)
    ButtonEndTime:Find('Label'):GetComponent('UILabel').text=os.date('%Y/%m/%d',endTime)
    this.sendMSG(startTime,endTime)

    SearchInput:GetComponent('UILabel').text=""
end
--发送获取战绩的命令
function this.sendMSG(startTime,endTime)
    print('获取房间记录'..startTime..'到'..endTime)
    local msg = Message.New()
    msg.type = proxy_pb.CLUB_ROOM_LIST;
    local body = proxy_pb.PClubRoomList();
    body.clubId=panelClub.clubInfo.clubId
    body.startTime=startTime
    body.endTime=endTime
    msg.body = body:SerializeToString()
	SendProxyMessage(msg, this.OnGetRecord);
end

--单击事件--
function this.OnClickMask(go)
	AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
end



function this.OnGetRecord(msg)
    local b = proxy_pb.RClubRoomList()
    b:ParseFromString(msg.body);
    RecordList = b
    this.Refresh()
end
function this.Refresh()
    Util.ClearChild(Grid)
    MemberListGO={}
    tip.gameObject:SetActive(false)
    if #RecordList.rooms == 0 then
        tip:GetComponent('UILabel').text='当前还没有记录'
		tip.gameObject:SetActive(true)
	end
    clubName:GetComponent('UILabel').text='群：'..panelClub.clubInfo.name
    clubID:GetComponent('UILabel').text='群ID：'..RecordList.clubId
    juShu:GetComponent('UILabel').text='总局数：'..RecordList.rounds
    consume:GetComponent('UILabel').text='消耗钻石：'..RecordList.diamonds
    juShu.gameObject:SetActive(panelClub.clubInfo.userType~=proxy_pb.GENERAL)
    consume.gameObject:SetActive(panelClub.clubInfo.userType~=proxy_pb.GENERAL)
    for i=1,#RecordList.rooms do
        local userGO = {}
        userGO.GO = NGUITools.AddChild(Grid.gameObject, prefabItem.gameObject)
        userGO.GO.name='item'..i
        userGO.userId = {}
        -- --print("排序"..tostring(RecordList.rooms[i].enterCount))
        SetUserData(userGO.GO, RecordList.rooms[i])
        MemberListGO[i]=userGO
        print("游戏名字："..RecordList.rooms[i].playName)
        userGO.GO.transform:Find('roomid'):GetComponent('UILabel').text='房间号：'..RecordList.rooms[i].roomNumber
        userGO.GO.transform:Find('nameid'):GetComponent('UILabel').text = '名称：'..RecordList.rooms[i].playName
        userGO.GO.transform:Find('consumediamand'):GetComponent('UILabel').text = '消耗钻石：'..RecordList.rooms[i].diamonds
        userGO.GO.transform:Find('time'):GetComponent('UILabel').text=os.date('时间：%Y.%m.%d %H:%M', RecordList.rooms[i].time)
        
        local maxIndex = 1
        --local maxScore=math.max(RecordList.rooms[i].players[1].score,RecordList.rooms[i].players[2].score,RecordList.rooms[i].players[3].score)
        local maxScore = 0
        for j = 1, #RecordList.rooms[i].players do
            if maxScore < RecordList.rooms[i].players[j].score then
                maxScore = RecordList.rooms[i].players[j].score
            end
        end

        -- for j=1,#RecordList.rooms[i].players do
        --     userGO.userId[j]=RecordList.rooms[i].players[j].id
        --     local player=userGO.GO.transform:Find('playerName'..j)
        --     coroutine.start(LoadPlayerIcon, player.transform:Find('TX'):GetComponent('UITexture'), RecordList.rooms[i].players[j].icon)
        --     player:GetComponent('UILabel').text=RecordList.rooms[i].players[j].name
        --     player:Find('num'):GetComponent('UILabel').text=RecordList.rooms[i].players[j].score
        --     if maxScore==RecordList.rooms[i].players[j].score then
        --         --player:Find('winner').gameObject:SetActive(true)
        --         maxIndex = j
        --     end
        -- end

        for j = 1, 3 do
            if j <= #RecordList.rooms[i].players then
                userGO.userId[j]=RecordList.rooms[i].players[j].id
                local player=userGO.GO.transform:Find('playerName'..j)
                coroutine.start(LoadPlayerIcon, player.transform:Find('TX'):GetComponent('UITexture'), RecordList.rooms[i].players[j].icon)
                player:GetComponent('UILabel').text=RecordList.rooms[i].players[j].name
                player:Find('num'):GetComponent('UILabel').text=RecordList.rooms[i].players[j].score
                if maxScore==RecordList.rooms[i].players[j].score then
                    --player:Find('winner').gameObject:SetActive(true)
                    maxIndex = j
                end
            else
                userGO.GO.transform:Find('playerName'..j).gameObject:SetActive(false)
            end
        end

        userGO.GO:SetActive(true)

        if not this.IsAllZero(RecordList.rooms[i].players) then
            userGO.GO.transform:Find('playerName'..maxIndex):Find('winner').gameObject:SetActive(true)
        end
    end

    Grid:GetComponent('UIGrid'):Reposition()
    Grid:GetComponent('UIScrollView'):ResetPosition()
end

function this.IsAllZero(players)
    for i=1,#players do
        if players[i].score ~= 0 then
            return false
        end
    end

    return true
end
