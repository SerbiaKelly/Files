local proxy_pb = require 'proxy_pb'
local json = require 'json'
panelRecord = {}
replayData = {}

local this=panelRecord
local RecordList={}
local message;
local gameObject;
local mask
local Grid
local prefabItem
local buttonClose
local tip

local title1
local title2
local title3

local nowtimeChuo = os.time()
local nowtime = os.date('%Y/%m/%d', nowtimeChuo)

--查询的条件
local startTime--开始时间
local endTime--结束时间
local page=1--页数 从1开始
local pageSize=20--每页个数
local userId=nil--玩家id
local playId=nil--玩法id
local clubId=0--牌友群id
local valid=nil--0=无效 1=有效 空为全部

local listTimeItem={}

local times
local PlaybackyardsPanel
local PlaybackyardsButton

local isNotDownload=true
local isFinish=false

local MemberListGO={}

local selectPlayerReplay
local selectPlayerReplayPlayerInfo
local selectPlayerReplayGameType
local selectPlayerReplayRoomType;

--启动事件--
function this.Awake(obj)
    gameObject = obj;
	message = gameObject:GetComponent('LuaBehaviour');

    title1 = gameObject.transform:Find('BaseContent/bg/Label1');
    title2 = gameObject.transform:Find('BaseContent/bg/Label2');
    title3 = gameObject.transform:Find('BaseContent/bg/Label3');

    mask = gameObject.transform:Find('BaseContent/mask');
    Grid = gameObject.transform:Find('Grid');
	buttonClose = gameObject.transform:Find('BaseContent/ButtonClose');
	tip = gameObject.transform:Find('tip');
    prefabItem = gameObject.transform:Find('item');

    times = gameObject.transform:Find('Times')
    for i=0, 2 do
        message:AddClick(times.transform:GetChild(i).gameObject, this.OnClickSelctTime)
    end
	
    message:AddClick(times.transform:Find('AdvancedQuery').gameObject, this.OnClickSelectAdvanced)

    PlaybackyardsPanel = gameObject.transform:Find('PlaybackyardsPanel')
    PlaybackyardsButton = gameObject.transform:Find('PlaybackyardsButton')
	
	selectPlayerReplay = gameObject.transform:Find('selectPlayerReplay')
	message:AddClick(selectPlayerReplay:Find('BaseContent/ButtonClose').gameObject, function (go)
        selectPlayerReplay.gameObject:SetActive(false)
    end)
	selectPlayerReplayPlayerInfo = gameObject.transform:Find('selectPlayerReplay/play')
	for i=0,selectPlayerReplayPlayerInfo.childCount-1 do
		message:AddClick(selectPlayerReplayPlayerInfo:GetChild(i):Find('BtnOK').gameObject,this.OnClickSelectPlayerReplayOK)
	end
	
    local PlaybackyardsPanelCloseBtn = PlaybackyardsPanel:Find('BaseContent/ButtonClose')
    local PlaybackyardsPanelOkBtn = PlaybackyardsPanel:Find('ButtonOK')
    
    message:AddClick(PlaybackyardsButton.gameObject, this.OnClickPlaybackyardsButton)
    message:AddClick(PlaybackyardsPanelOkBtn.gameObject, this.OnClickPlay)
    message:AddClick(PlaybackyardsPanelCloseBtn.gameObject, function (go)
        PlaybackyardsPanel.gameObject:SetActive(false)
    end)
	
	
    Grid:GetComponent('UIScrollView').onMomentumMove = this.OnScroll
    --UIEventListener.Get(Grid.gameObject).OnPress = this.OnScroll
    --message:AddClick(mask.gameObject, this.OnClickMask);
	message:AddClick(buttonClose.gameObject, this.OnClickMask);
end

function this.Update()
   
end
function this.Start()

end

function this.OnEnable()
    print('enable')
end

function this.WhoShow(data)
    print('roomRecord')

    if data == 'panelLobby' then
        startTime = nowtimeChuo
        endTime = nowtimeChuo
        userId = userInfo.id
        this.setTitle('个人战绩')

        this.initAll()
        this.sendMSG()
    end

    PanelManager.Instance:HideWindow(data)
	PlaybackyardsPanel.gameObject:SetActive(false)
	selectPlayerReplay.gameObject:SetActive(false)
    times:Find('0'):GetComponent('UIToggle'):Set(true)
end

function this.OnScroll()
    if isNotDownload==true and isFinish==false and Grid:GetComponent('SpringPanel')~=nil then
        print('到底了')
        UnityEngine.Object.Destroy(Grid:GetComponent('SpringPanel'))
        this.sendMSG()
    end
end

--初始化所有
function this.initAll()
    this.initData()
    this.initGrid()
    -- body
end
--初始化滑动界面
function this.initGrid()
    Util.ClearChild(Grid)
    --Grid.localPosition=Vector3(0,142,0)
    --Grid:GetComponent('UIPanel').clipOffset=Vector2(0,95.4)
    Grid:GetComponent('UIGrid'):Reposition()
end
--初始化数据
function this.initData()
    nowtimeChuo = os.time()
    isFinish=false
    page=1
    --isNotDownload=true
end

function this.OnClickSelctTime(go)
    AudioManager.Instance:PlayAudio('btn')

    local new = os.time()
    startTime = (new - 86400 * (tonumber(go.name)))
    endTime = (new - 86400 * (tonumber(go.name)))
    startTime = os.time({year=os.date('%Y', startTime),month=os.date('%m', startTime),day=os.date('%d', startTime),hour='0',min='0'});
    endTime = os.time({year=os.date('%Y', endTime),month=os.date('%m', endTime),day=os.date('%d', endTime),hour='23',min='59'});
    this.initAll()
    this.sendMSG()
end

function this.OnClickSelectAdvanced(go)
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:ShowWindow('panelSelectTime',gameObject.name)
end

function this.onSelectTime(sTime, eTime)
    startTime = sTime
    endTime = eTime

    this.initAll()
    this.sendMSG()

    for i=0, 2 do
        times.transform:GetChild(i):GetComponent('UIToggle'):Set(false)
    end
end

function this.setTitle(str)
    title1:GetComponent('UILabel').text = str
    title2:GetComponent('UILabel').text = str
    title3:GetComponent('UILabel').text = str
end

function this.ButtonSound(go)
    AudioManager.Instance:PlayAudio('btn')
end

function this.OnClickGetRecord(go)
    AudioManager.Instance:PlayAudio('btn')
    local st= ButtonStartTime:Find('Label'):GetComponent('UILabel').text
    local ed= ButtonEndTime:Find('Label'):GetComponent('UILabel').text
    print("开始时间："..st.."，结束时间："..ed)
    startTime = os.time({year=string.sub (st, 1,4),month=string.sub (st, 6,7),day=string.sub (st, 9,10)});
    endTime = os.time({year=string.sub (ed, 1,4),month=string.sub (ed, 6,7),day=string.sub (ed, 9,10)});
    this.initAll()
    this.sendMSG()
end

--单击事件--
function this.OnClickMask(go)
	AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:ShowWindow('panelLobby')
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnGetRecord(msg)
    local b = proxy_pb.RUserClubRecord()
    b:ParseFromString(msg.body);
    RecordList = b
    this.Refresh()
end

function this.Refresh()
    tip.gameObject:SetActive(false)
    if page==1 then
        if #RecordList.datas == 0 then
            tip:GetComponent('UILabel').text='当前还没有记录'
            tip.gameObject:SetActive(true)
        end
    elseif #RecordList.datas == 0 then
        panelMessageTip.SetParamers('没有更多了', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        isFinish=true
    end
    MemberListGO={}
    
    print('数据条数'..#RecordList.datas)
    local nowNum=Grid.childCount
	for i=1,#RecordList.datas do
        local userGO = {}
        userGO.GO = NGUITools.AddChild(Grid.gameObject, prefabItem.gameObject)
        userGO.GO.transform.localPosition = Vector3(0, -(i+nowNum)*Grid:GetComponent('UIGrid').cellHeight, 0)
        --userGO.userId = RecordList.rooms[i].userId
        --print("排序"..tostring(RecordList.rooms[i].enterCount))
        SetUserData(userGO.GO, RecordList.datas[i])
        MemberListGO[i]=userGO
        -- print('房间号：'..RecordList.datas[i].roomNumber)
        -- print('名称：'..RecordList.datas[i].playName)
        -- print('消耗钻石：'..RecordList.datas[i].diamonds)
        userGO.GO.transform:Find('roomid'):GetComponent('UILabel').text='房间号：'..RecordList.datas[i].roomNumber
        userGO.GO.transform:Find('time'):GetComponent('UILabel').text=os.date('时间：%Y.%m.%d %H:%M', RecordList.datas[i].time)

        local playName = RecordList.datas[i].playName
        if playName == '' then
            playName = GameTypeString[RecordList.datas[i].gameType]
        end
        userGO.GO.transform:Find('nameid'):GetComponent('UILabel').text = '名称：'..playName
        userGO.GO.transform:Find('consumediamand'):GetComponent('UILabel').text = '消耗钻石：'..RecordList.datas[i].diamonds
		userGO.GO.transform:Find('dismiss'):GetComponent('UISprite').spriteName = ByDissolutionTypeGetSpriteName(RecordList.datas[i].dissolutionType)
        local maxIndex = 1
        local maxScore = 0
        for j = 1, #RecordList.datas[i].players do
            if maxScore < RecordList.datas[i].players[j].score then
                maxScore = RecordList.datas[i].players[j].score
                maxIndex = j
            end
        end
        print('maxIndex : '..maxIndex)
        if not this.IsAllZero(RecordList.datas[i].players) then
            userGO.GO.transform:Find('playerName'..maxIndex):Find('winner').gameObject:SetActive(true)
        end
        for j = 1, 4 do
             if j <= #RecordList.datas[i].players then
                local player=userGO.GO.transform:Find('playerName'..j)
                coroutine.start(LoadPlayerIcon, player:Find('TX'):GetComponent('UITexture'), RecordList.datas[i].players[j].icon)
                player:GetComponent('UILabel').text=RecordList.datas[i].players[j].nickname
                player:Find('num'):GetComponent('UILabel').text=RecordList.datas[i].players[j].score
                userGO.GO.transform:Find('playerName'..j).gameObject:SetActive(true)
                print("name:"..RecordList.datas[i].players[j].nickname..",player.score="..RecordList.datas[i].players[j].score);
            else
                userGO.GO.transform:Find('playerName'..j).gameObject:SetActive(false)
            end
           
        end
        userGO.ButtonLook=userGO.GO.transform:Find('ButtonLook')
        message:AddClick(userGO.ButtonLook.gameObject, this.lookOnclick)
        userGO.GO:SetActive(true)
    end
    Grid:GetComponent('UIGrid'):Reposition()
    if page==1 then
        Grid:GetComponent('UIScrollView'):ResetPosition()
    end
    print('当前页数'..page)
    page=RecordList.page
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

--发送获取战绩的命令
function this.sendMSG()
    if isNotDownload==false then
        return
    end
    isNotDownload=false
    PanelManager.Instance:ShowWindow('panelNetWaitting')
    local msg = Message.New()
    msg.type = proxy_pb.USER_CLUB_RECORD;
    local body = proxy_pb.PUserClubRecord();
    if clubId~=0 then
        body.clubId=clubId
    end
    body.userId=userId
    print('开始时间'..startTime..'结束时间'..endTime)
    body.startTime=startTime
    body.endTime=endTime
    body.page=tostring(page)
    body.pageSize=tostring(pageSize)
    msg.body = body:SerializeToString()
	SendProxyMessage(msg, this.OnGetRecord);
end

function this.lookOnclick(go)
    AudioManager.Instance:PlayAudio('btn')
    print("go.transform.parent.gameObject",go.transform.parent.gameObject.name)
    local myData={}
	myData.roomId = GetUserData(go.transform.parent.gameObject).roomId
	myData.roomNumber = GetUserData(go.transform.parent.gameObject).roomNumber
    myData.name=gameObject.name
    PanelManager.Instance:ShowWindow('panelRecordDetail',myData)
end

function this.OnClickPlaybackyardsButton(go)
    PlaybackyardsPanel.gameObject:SetActive(true)
end

function this.OnClickPlay(go)
    local playCode = PlaybackyardsPanel:Find('input'):GetComponent('UIInput').value

    if playCode == '' then
        return 
    end

    local copyPlayCode = playCode
    local index = string.find(copyPlayCode, '回放码：')
    if index ~= nil then
        copyPlayCode = string.sub(copyPlayCode, index)
        index = string.find(copyPlayCode, '：')
        playCode = string.sub(copyPlayCode, index + 3)

        print(copyPlayCode)
    end

    PanelManager.Instance:ShowWindow('panelNetWaitting')
    local msg = Message.New()
    msg.type = proxy_pb.ROOM_ROUND_PLAYBACK
    local body = proxy_pb.PRoomRoundPlayback()
    body.playCode = playCode
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RRoomRoundPlayback()
        b:ParseFromString(msg.body);
        PanelManager.Instance:HideWindow('panelNetWaitting')
        if b.roomId == '-1' then
            panelMessageTip.SetParamers('回放码错误！', 1)
            PanelManager.Instance:ShowWindow('panelMessageTip')
            return 
        end
        replayData.roomId = b.roomId
        replayData.round = b.round
        replayData.roomNumber = b.roomNumber
        selectPlayerReplayGameType = b.gameType
        if selectPlayerReplayGameType == proxy_pb.MJ or selectPlayerReplayGameType == proxy_pb.HNM then 
            selectPlayerReplayRoomType = json:decode(b.settings).roomType;
            replayData.roomType = selectPlayerReplayRoomType;
        end
		this.ShowSelectPlayerReplay(b)
    end)

    -- local gameType = tonumber(string.sub(playCode, 1, 1)) - 1
    -- local round = tonumber(string.sub(playCode, 2, 3))
    -- local roundId = string.sub(playCode, 4)

    -- if gameType < 0 or gameType > 3 then
    --     return 
    -- end

    -- local msg = Message.New()
    -- msg.type = proxy_pb.ROUND_RECORDS
    -- local body = proxy_pb.PRoundRecords()
    -- body.roomId = roundId
	-- body.round = round
	-- body.gameType = gameType
    -- if gameType < 0 or gameType > 3 then
    --     return 
    -- end
    -- msg.body = body:SerializeToString()

    -- replayData.roomId = roundId
    -- replayData.round = round

    -- SendProxyMessage(msg, function (msg)
    --     if msg.body == nil then

    --         return 
    --     end
    --     if gameType == proxy_pb.PDK then
    --         PanelManager.Instance:ShowWindow('panelReplay_pdk', {name = gameObject.name, isNeedRequest = false})
    --         panelReplay_pdk.OnGetRoundDetail(msg)
    --     elseif gameType == proxy_pb.PHZ then
    --         PanelManager.Instance:ShowWindow('panelReplay', {name = gameObject.name, isNeedRequest = false})
    --         panelReplay.OnGetRoundDetail(msg)
    --     elseif gameType == proxy_pb.MJ then
    --         PanelManager.Instance:ShowWindow('panelReplay_mj', {name = gameObject.name, isNeedRequest = false})
    --         panelReplay_mj.OnGetRoundDetail(msg)
    --     end

    --     PlaybackyardsPanel.gameObject:SetActive(false)
    -- end)
end

function this.ShowSelectPlayerReplay(data)
	selectPlayerReplay.gameObject:SetActive(true)
	for i=0,selectPlayerReplayPlayerInfo.transform.childCount-1 do
		selectPlayerReplayPlayerInfo.transform:GetChild(i).gameObject:SetActive(false)
	end
	for i=1,#data.roundPlayer do
		local obj = selectPlayerReplayPlayerInfo.transform:GetChild(i-1).gameObject
		SetUserData(obj,data.roundPlayer[i])
		this.updataPlayerInfo(obj,data.roundPlayer[i])
	end
end

function this.updataPlayerInfo(play,data)
	play:SetActive(true)
	play.transform:Find('name'):GetComponent('UILabel').text = data.nickName
	play.transform:Find('id'):GetComponent('UILabel').text = data.userId
	coroutine.start(LoadPlayerIcon, play.transform:Find('head'):GetComponent('UITexture'), data.icon)
end

function this.OnClickSelectPlayerReplayOK(go)
	AudioManager.Instance:PlayAudio('btn')
	local data = {}
	data.name = gameObject.name
	data.isNeedRequest = true
	data.mySeat = GetUserData(go.transform.parent.gameObject).seat
	data.isSelectSeat = true
	print('OnClickSelectPlayerReplayOK ..'..'data.mySeat : '..data.mySeat..'  selectPlayerReplayGameType : '..tostring(selectPlayerReplayGameType))
	if selectPlayerReplayGameType == proxy_pb.PDK then
		PanelManager.Instance:ShowWindow('panelReplay_pdk',data)
	elseif selectPlayerReplayGameType == proxy_pb.PHZ then
		PanelManager.Instance:ShowWindow('panelReplay',data)
	elseif selectPlayerReplayGameType == proxy_pb.MJ then
		PanelManager.Instance:ShowWindow('panelReplay_mj',data)
	elseif selectPlayerReplayGameType == proxy_pb.XHZD then
		PanelManager.Instance:ShowWindow('panelReplay_xhzd',data)
	elseif selectPlayerReplayGameType == proxy_pb.DTZ then
		PanelManager.Instance:ShowWindow('panelReplay_dtz',data)
	elseif selectPlayerReplayGameType == proxy_pb.BBTZ then
		PanelManager.Instance:ShowWindow('panelReplay_bbtz',data)
	elseif selectPlayerReplayGameType == proxy_pb.XPLP then
        PanelManager.Instance:ShowWindow('panelReplay_xplp',data)
    elseif selectPlayerReplayGameType == proxy_pb.HNM and replayData.roomType == "HNHSM" then
        PanelManager.Instance:ShowWindow('panelReplay_hnhsm',data)
    elseif selectPlayerReplayGameType == proxy_pb.HNM and replayData.roomType == "HNZZM" then
        PanelManager.Instance:ShowWindow('panelReplay_hnzzm',data)
    elseif selectPlayerReplayGameType == proxy_pb.YJQF then
        PanelManager.Instance:ShowWindow("panelReplay_yjqf",data)
    elseif selectPlayerReplayGameType == proxy_pb.DZM and replayData.roomType == "DZAHM" then
        PanelManager.Instance:ShowWindow('panelReplay_dzahmm',data)
    end
    
	selectPlayerReplay.gameObject:SetActive(false)
	PlaybackyardsPanel.gameObject:SetActive(false)
	gameObject:SetActive(false)
end