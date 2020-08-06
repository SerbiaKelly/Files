panelOneClubRecord = {}
local this = panelOneClubRecord

local gameObject
local message

local MemberListPanel
local MemberScrollView
local RecordPrefab

local Grid

local ToggleLookValid--查看有效的场次（大赢家场次）

--查询的条件
local startTime--开始时间
local endTime--结束时间
local page=1--页数 从1开始
local pageSize=20--每页个数
local userId=nil--玩家id
local playId=nil--玩法id
local clubId=0--牌友群id
local valid=nil--false=无效 true=有效 空为全部

local whoshow
local mfunc--功能
function this.Awake(go)
    gameObject = go
    message = gameObject:GetComponent('LuaBehaviour');

    this.InitMemberListPanel()

    message:AddClick(gameObject.transform:Find('BaseContent/ButtonClose').gameObject, function (go)
        local data = {}
        data.name = gameObject.name
        data.roomNumFuFeeValue = 0
        PanelManager.Instance:ShowWindow('panelMenberRecord',data)
        PanelManager.Instance:HideWindow('panelOneClubRecord')
    end)
end

local isNotDownload=true
local isFinish=false
function this.OnScroll()
    if isNotDownload==true and isFinish==false and MemberScrollView:GetComponent('SpringPanel')~=nil then
        print('到底了')
        UnityEngine.Object.Destroy(MemberScrollView:GetComponent('SpringPanel'))
        PanelManager.Instance:ShowWindow('panelNetWaitting')
        if mfunc==proxy_pb.USER_CLUB_RECORD then--群战绩
            this.GetUserRecord()
        elseif mfunc==proxy_pb.MEMBERS_FEE_DETAIL then--群成员疲劳值详情
            this.GetMemberRecord()
        elseif mfunc==proxy_pb.LORD_MANAGER_DETAIL then--管理员的成员疲劳值详情
            this.GetManagerRecord()
        end
    end
end

function this.OnEnable()
   
end
--初始化界面
function this.InitView(index)
    userId=nil--玩家id
    playId=nil--玩法id
    MemberListPanel.transform:Find('Tip/enterCount/Label'):GetComponent('UILabel').text = ''
    MemberListPanel.transform:Find('Tip/winCount/Label'):GetComponent('UILabel').text = ''
    MemberListPanel.transform:Find('Tip/validCount/Label'):GetComponent('UILabel').text = ''
    MemberListPanel.transform:Find('Tip/fatigueCount/Label'):GetComponent('UILabel').text = ''


    ToggleLookValid:Find('Checkmark').gameObject:SetActive(false)
    valid=nil
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
    MemberScrollView.localPosition=Vector3(0,126,0)
    MemberScrollView:GetComponent('UIPanel').clipOffset=Vector2(0,-126)
    Grid:GetComponent('UIGrid'):Reposition()
end
--初始化数据
function this.initData()
    isFinish=false
    page=1
    --isNotDownload=true
end



function this.InitMemberListPanel()
    MemberListPanel = gameObject.transform:Find('MemberListPanel')
    

    ToggleLookValid  = MemberListPanel:Find('Tip/ToggleLookValid')
    message:AddClick(ToggleLookValid.gameObject, this.onclickLookValid)

    MemberScrollView = MemberListPanel:Find('Scroll View')
    Grid = MemberScrollView:Find('Grid')
    MemberScrollView:GetComponent('UIScrollView').onMomentumMove = this.OnScroll
    RecordPrefab = MemberListPanel:Find('item')
end

function this.onclickLookValid(go)
    AudioManager.Instance:PlayAudio('btn')
    if ToggleLookValid:Find('Checkmark').gameObject.activeSelf==true then
        ToggleLookValid:Find('Checkmark').gameObject:SetActive(false)
        valid=nil
        print('关')
    else
        ToggleLookValid:Find('Checkmark').gameObject:SetActive(true)
        valid=false
        print('开')
    end
    this.initAll()
    if mfunc==proxy_pb.USER_CLUB_RECORD then--群战绩
        this.GetUserRecord()
    elseif mfunc==proxy_pb.MEMBERS_FEE_DETAIL then--群成员疲劳值详情
        this.GetMemberRecord()
    elseif mfunc==proxy_pb.LORD_MANAGER_DETAIL then--管理员的成员疲劳值详情
        this.GetManagerRecord()
    end
end


function this.setTitle(str)
	for i=1,3 do
		gameObject.transform:Find('BaseContent/bg/Label'..i):GetComponent('UILabel').text=str
	end
end


local myData
function this.WhoShow(data)
    myData=nil
    whoshow=data.name
    if whoshow=='panelMenberRecord' then
        this.InitView()
        this.initAll()
        mfunc=data.fuc
        --PanelManager.Instance:HideWindow(data.name)
        startTime = data.startTime
        endTime = data.endTime
        myData = data.myData
        userId = myData.userId
        if data.playId~=nil then
            playId = data.playId
        end
        if data.fuc==proxy_pb.USER_CLUB_RECORD then--群战绩
            this.setTitle('查看个人群战绩')
            this.GetUserRecord()
        elseif data.fuc==proxy_pb.MEMBERS_FEE_DETAIL then--我的成员战绩
            this.setTitle('我的成员战绩')
            this.GetMemberRecord()
        elseif data.fuc==proxy_pb.LORD_MANAGER_DETAIL then--我的管理员统计
            this.setTitle('我的管理员统计')
            this.GetManagerRecord()
        end
    end
    PanelManager.Instance:HideWindow(whoshow)
end

function this.GetManagerRecord()
    if isNotDownload==false then
        return
    end
    isNotDownload=false
    local msg = Message.New()
    msg.type = proxy_pb.LORD_MANAGER_DETAIL;
    local body = proxy_pb.PUserClubRecord();
    body.clubId=panelClub.clubInfo.clubId
    body.userId=userId
    print('开始时间'..startTime..'结束时间'..endTime)
    body.startTime=startTime
    body.endTime=endTime
    if valid~=nil then
        body.valid = valid
    end
    body.page=tostring(page)
    body.pageSize=tostring(pageSize)
    
    msg.body = body:SerializeToString()
	SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RUserClubRecord()
        b:ParseFromString(msg.body);
        this.RefreshRecord(b,proxy_pb.LORD_MANAGER_DETAIL)
    end);
end
function this.GetMemberRecord()
    if isNotDownload==false then
        return
    end
    isNotDownload=false
    local msg = Message.New()
    msg.type = proxy_pb.MEMBERS_FEE_DETAIL;
    local body = proxy_pb.PUserClubRecord();
    body.clubId=panelClub.clubInfo.clubId
    body.userId=userId
    print('开始时间'..startTime..'结束时间'..endTime)
    body.startTime=startTime
    body.endTime=endTime
    if valid~=nil then
        body.valid = valid
    end
    body.page=tostring(page)
    body.pageSize=tostring(pageSize)
    
    msg.body = body:SerializeToString()
	SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RUserClubRecord()
        b:ParseFromString(msg.body);
        this.RefreshRecord(b,proxy_pb.MEMBERS_FEE_DETAIL)
    end);
end
function this.GetUserRecord()
    if isNotDownload==false then
        return
    end
    isNotDownload=false
    local msg = Message.New()
    msg.type = proxy_pb.USER_CLUB_RECORD;
    local body = proxy_pb.PUserClubRecord();
    body.clubId=panelClub.clubInfo.clubId
    body.userId=userId
    print('开始时间'..startTime..'结束时间'..endTime)
    body.startTime=startTime
    body.endTime=endTime
    if playId~=nil then
        body.playId = playId
    end
    if valid~=nil then
        body.valid = valid
    end
    body.page=tostring(page)
    body.pageSize=tostring(pageSize)
    msg.body = body:SerializeToString()
	SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RUserClubRecord()
        b:ParseFromString(msg.body);
        this.RefreshRecord(b,proxy_pb.USER_CLUB_RECORD)
    end);
end

local gameTypeName = {'麻将', '跑胡子', '跑得快'}

function this.RefreshRecord(data,type)
    if page~=1 and #data.datas == 0 then
        panelMessageTip.SetParamers('没有更多了', 1)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        isFinish=true
    end
    print('局数：'..#data.datas)
    local nowNum=Grid.childCount
    for i=1, #data.datas do
         local obj = NGUITools.AddChild(Grid.gameObject, RecordPrefab.gameObject)
         obj.transform:Find('bianHao'):GetComponent('UILabel').text = i+nowNum
         obj.transform.localPosition = Vector3(0, -(i+nowNum)*Grid:GetComponent('UIGrid').cellHeight, 0)
		 print('data.datas[i].dissolutionType : '..tostring(data.datas[i].dissolutionType))
		 obj.transform:Find('dismiss'):GetComponent('UISprite').spriteName = ByDissolutionTypeGetSpriteName(data.datas[i].dissolutionType)
         for j = 1, 4 do
             local player=obj.transform:Find('playerName'..j)
             if j <= #data.datas[i].players then
                player.gameObject:SetActive(true)
                coroutine.start(LoadPlayerIcon, player:Find('TX'):GetComponent('UITexture'), data.datas[i].players[j].icon)
                player:GetComponent('UILabel').text = data.datas[i].players[j].nickname
                player:Find('num'):GetComponent('UILabel').text = data.datas[i].players[j].score
                if type==proxy_pb.LORD_MANAGER_DETAIL then
                    player:Find('feiZhiShu').gameObject:SetActive(data.datas[i].players[j].flag=='2')
                else
                    player:Find('feiZhiShu').gameObject:SetActive(false)
                end
             else
                player.gameObject:SetActive(false)
             end
         end
       
         obj.transform:Find('roomid'):GetComponent('UILabel').text = "房号："..data.datas[i].roomNumber

         local name = ''
         if data.datas[i].playName == '' or data.datas[i].playName == nil then
             name = gameTypeName[data.datas[i].gameType]
         else
            name = data.datas[i].playName
         end

         obj.transform:Find('nameid'):GetComponent('UILabel').text = '名称：'..tostring(name)
         
         obj.transform:Find('consumediamand'):GetComponent('UILabel').text = '消耗钻石：'.. data.datas[i].diamonds
         obj.transform:Find('time'):GetComponent('UILabel').text = os.date('时间：%Y.%m.%d %H:%M', data.datas[i].time)
         obj.transform:Find('fee'):GetComponent('UILabel').text = panelClub.clubInfo.gameMode and '大赢家疲劳值：'.. data.datas[i].fee or '疲劳值：'.. data.datas[i].fee
		 
         obj.transform:Find('fee').localPosition=Vector3(66,41,0)
         
         if type~=proxy_pb.USER_CLUB_RECORD then
            obj.transform:Find('consumediamand').gameObject:SetActive(false)
            if type==proxy_pb.MEMBERS_FEE_DETAIL then
                obj.transform:Find('fee'):GetComponent('UILabel').text = panelClub.clubInfo.gameMode and '本局疲劳值/带来的疲劳值：'.. data.datas[i].fee..'/'..data.datas[i].returnFee or '本局疲劳值/分配的疲劳值：'.. data.datas[i].fee..'/'..data.datas[i].returnFee
            else
                obj.transform:Find('fee'):GetComponent('UILabel').text = '本局疲劳值/分配的疲劳值：'.. data.datas[i].fee..'/'..data.datas[i].returnFee            
            end
            
            obj.transform:Find('fee').localPosition=Vector3(-188,41,0)
         elseif type==proxy_pb.USER_CLUB_RECORD and panelClub.clubInfo.gameMode then
            obj.transform:Find('consumediamand'):GetComponent('UILabel').text =  data.datas[i].oneScoreFee..'疲劳值/分'
         end
         
         local maxScore, maxIndex = 0, 0
         for j = 1, #data.datas[i].players do
             if maxScore < data.datas[i].players[j].score then
                 maxScore = data.datas[i].players[j].score
                 maxIndex = j
             end
         end

        
        if not this.IsAllZero(data.datas[i].players) then
            obj.transform:Find('playerName'..maxIndex):Find('winner').gameObject:SetActive(true)
        end

        if type==proxy_pb.LORD_MANAGER_DETAIL then
            if data.datas[i].valid==false then
                obj.transform:Find('wuXiao').gameObject:SetActive(true)
            end
            obj.transform:Find('ButtonLook').gameObject:SetActive(false)
        else
            obj.transform:Find('ButtonLook').gameObject:SetActive(true)
        end
		local showBigWin = false
		 if panelClub.clubInfo.userType==proxy_pb.GENERAL then
			showBigWin = panelClub.clubInfo.showBigWin
		 else
			showBigWin = true
		 end
		 obj.transform:Find('fee').gameObject:SetActive(showBigWin)
         obj.gameObject:SetActive(true)
         SetUserData(obj.gameObject, data.datas[i])
         message:AddClick(obj.transform:Find('ButtonLook').gameObject, this.lookOnclick)
    end

    if page==1 then
        MemberListPanel.transform:Find('Tip/enterCount/Label'):GetComponent('UILabel').text = myData and myData.times or '0'

        if myData and myData.bigWinTimes then
            MemberListPanel.transform:Find('Tip/winCount/Label'):GetComponent('UILabel').text = myData.bigWinTimes
            MemberListPanel.transform:Find('Tip/winCount').gameObject:SetActive(true)
        else
            MemberListPanel.transform:Find('Tip/winCount').gameObject:SetActive(false)
        end

        MemberListPanel.transform:Find('Tip/winCount').gameObject:SetActive(type==proxy_pb.USER_CLUB_RECORD)
        if type==proxy_pb.LORD_MANAGER_DETAIL then
            MemberListPanel.transform:Find('Tip/validCount/Label'):GetComponent('UILabel').text = myData and myData.vaildTimes or '0'
            MemberListPanel.transform:Find('Tip/validCount').gameObject:SetActive(true)
        else
            MemberListPanel.transform:Find('Tip/validCount').gameObject:SetActive(false)
        end

        
        if type==proxy_pb.USER_CLUB_RECORD then
            MemberListPanel.transform:Find('Tip/fatigueCount'):GetComponent('UILabel').text= panelClub.clubInfo.gameMode and '大赢家疲劳值：' or '疲劳值：'
            MemberListPanel.transform:Find('Tip/fatigueCount/Label'):GetComponent('UILabel').text = myData.feeBalance--data.feeTotal
        else
            if type==proxy_pb.MEMBERS_FEE_DETAIL then
                MemberListPanel.transform:Find('Tip/fatigueCount'):GetComponent('UILabel').text = panelClub.clubInfo.gameMode and '带来的疲劳值：' or '分配的疲劳值：'
            elseif type==proxy_pb.LORD_MANAGER_DETAIL then
                MemberListPanel.transform:Find('Tip/fatigueCount'):GetComponent('UILabel').text= '分配的疲劳值：'
            end
            MemberListPanel.transform:Find('Tip/fatigueCount/Label'):GetComponent('UILabel').text = myData and myData.fee or '0'    
        end
        local showBigWin = false
		if panelClub.clubInfo.userType==proxy_pb.GENERAL then
			showBigWin = panelClub.clubInfo.showBigWin
		else
			showBigWin = true
		end
		MemberListPanel.transform:Find('Tip/fatigueCount').gameObject:SetActive(showBigWin)
    end
    

    Grid:GetComponent('UIGrid'):Reposition()
    if page==1 then
        MemberScrollView:GetComponent('UIScrollView'):ResetPosition()
    end
    print('当前页数'..page)
    page=data.page
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

function this.lookOnclick(go)
    AudioManager.Instance:PlayAudio('btn')
    local myData={}
    myData.roomId = GetUserData(go.transform.parent.gameObject).roomId
	myData.roomNumber = GetUserData(go.transform.parent.gameObject).roomNumber
    myData.name=gameObject.name
    PanelManager.Instance:ShowWindow('panelRecordDetail',myData)
end


function this.Update()
    -- body
end

