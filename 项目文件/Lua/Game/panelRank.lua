panelRank = {}
local this = panelRank
local message
local gameObject

local downArrow
local buttonClose
local rankTypeItem
local rankTypeScrollView
local rankTypeGrid
local rankData
local buttonSearch
local playerNameSelect
local playerNameSelectBtn
local rankingSelect
local rankingSelectBtn
local panelSelect
local panelSelectDataItem
local panelSelectDataScrollView
local panelSelectDataGrid
local panelSelectDataMask
local rankDataSortBtn
local rankDataItem
local rankDataScrollView
local rankDataGrid
local usefulFieldRankSort
local fuFeeRankSort
local noRankData
local noBtnBox
--数据
local rankTypeBtnObj={}
local currentSelectRankType=1
local currentSelectRoomType = -1
local currentSelectRankNum = 50
local startTime
local endTime
local rankDataSort = false
local isSelectPlayerName = false
local selectPlayNameString={}
local selectPlayName={}
local selectRanking={}
local isSendedRequest=false
local rankTypeString={
    '总场次排行',
    '有效场次排行',
    '大赢家排行',
    '疲劳值排行',
    '管理所有场次',
    '管家直属场次',
    '我的管家场次',
    '我的成员场次',
}
local ByRankTypeStringGetType={}
ByRankTypeStringGetType['总场次排行']=1
ByRankTypeStringGetType['有效场次排行']=2
ByRankTypeStringGetType['大赢家排行']=3
ByRankTypeStringGetType['疲劳值排行']=4
ByRankTypeStringGetType['管理所有场次']=8
ByRankTypeStringGetType['管家直属场次']=5
ByRankTypeStringGetType['我的管家场次']=6
ByRankTypeStringGetType['我的成员场次']=7
local rankType={}
function this.Awake(obj)
    gameObject = obj
    message = gameObject:GetComponent('LuaBehaviour')
    downArrow = gameObject.transform:Find('downArrow')
    buttonClose = gameObject.transform:Find('buttonClose')

    rankTypeItem = gameObject.transform:Find('rankType/rankTypeItem')
    rankTypeScrollView = gameObject.transform:Find('rankType/rankTypeScrollView')
    rankTypeGrid = gameObject.transform:Find('rankType/rankTypeScrollView/rankTypeGrid')

    rankData = gameObject.transform:Find('rankData')
    buttonSearch = rankData.transform:Find('buttonSearch')

    playerNameSelect = rankData.transform:Find('playerSelect/playerName')
    playerNameSelectBtn = rankData.transform:Find('playerSelect/Sprite')

    rankingSelect = rankData.transform:Find('rankingSelect/ranking')
    rankingSelectBtn = rankData.transform:Find('rankingSelect/Sprite')

    panelSelect = rankData.transform:Find('panelSelect')
    panelSelectDataItem = panelSelect.transform:Find('selectDataItem')
    panelSelectDataScrollView = panelSelect.transform:Find('selectDataScrollView')
    panelSelectDataGrid = panelSelectDataScrollView.transform:Find('selectDataGrid')
    panelSelectDataMask = panelSelect.transform:Find('mask')

    rankDataSortBtn = rankData.transform:Find('Tip/4')

    rankDataItem = rankData.transform:Find('rankDataItem')
    rankDataScrollView = rankData.transform:Find('rankDataScrollView')
    rankDataGrid = rankDataScrollView.transform:Find('rankDataGrid')

    usefulFieldRankSort = rankData.transform:Find('usefulFieldRank')
    fuFeeRankSort = rankData.transform:Find('fuFeeRank')

    noRankData = rankData.transform:Find('noRankData')
	noBtnBox = gameObject.transform:Find('box')
    message:AddClick(buttonClose.gameObject,this.OnClickClose)
    message:AddClick(buttonSearch.gameObject,this.OnClickSearch)
    message:AddClick(playerNameSelectBtn.gameObject,this.OnClickPlayerNameSelect)
    message:AddClick(rankingSelectBtn.gameObject,this.OnClickRankingSelect)
    message:AddClick(panelSelectDataMask.gameObject, this.OnClickPanelSelectDataMask)
    for i=0,1 do
        message:AddClick(rankData.transform:Find('times/'..i).gameObject,this.OnClickTime)
    end
    message:AddClick(rankData.transform:Find('times/AdvancedQuery').gameObject,this.OnClickSelectTime)

    message:AddClick(rankDataSortBtn.gameObject, this.OnClickRankDataSort)
    message:AddClick(usefulFieldRankSort.gameObject, this.OnClickUsefulFieldRankSort)
    message:AddClick(fuFeeRankSort.gameObject, this.OnClickFuFeeRankSort)
end

function this.Start()
end
function this.Update()
end
function this.OnEnable()
    this.GetRankTypeCount()
    this.InitRankType()
    this.InitRankData()
    this.GetRankData()
end
function this.WhoShow()
end

function this.OnClickClose(go)
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickSearch(go)
    AudioManager.Instance:PlayAudio('btn')
    this.GetRankData()
end

function this.OnClickPlayerNameSelect(go)
    AudioManager.Instance:PlayAudio('btn')
    isSelectPlayerName=true
    panelSelect.localPosition=Vector3(-220,30,0)
    this.GetPlayNameSelectCount()
    this.GetSelectSearchBtnObj()
end

function this.OnClickRankingSelect(go)
    AudioManager.Instance:PlayAudio('btn')
    isSelectPlayerName=false
    panelSelect.localPosition=Vector3(30,30,0)
    this.GetRankingSelectCount()
    this.GetSelectSearchBtnObj()
end

function this.OnClickSelectSearchBtn(go)
    AudioManager.Instance:PlayAudio('btn')
    local str = go.transform:Find('Label'):GetComponent('UILabel').text
    if isSelectPlayerName then
        for i = 1, #selectPlayName do
            if selectPlayName[i].name == str then
                currentSelectRoomType = selectPlayName[i].num
            end
        end
        playerNameSelect:GetComponent('UILabel').text = str
    else
        currentSelectRankNum = tonumber(string.match(str,"%d+"))
        rankingSelect:GetComponent('UILabel').text = str
    end
    panelSelect.gameObject:SetActive(false)
end

function this.OnClickPanelSelectDataMask(go)
    AudioManager.Instance:PlayAudio('btn')
    panelSelect.gameObject:SetActive(false)
    for i = 1, #selectPlayName do
        if selectPlayName[i].name == playerNameSelect:GetComponent('UILabel').text then
            currentSelectRoomType = selectPlayName[i].num
        end
    end
    currentSelectRankNum = tonumber(string.match(rankingSelect:GetComponent('UILabel').text,"%d+"))
end

function this.OnClickTime(go)
    AudioManager.Instance:PlayAudio('btn')
    local time = os.time() - 86400 * (tonumber(go.name))
    startTime = os.time({year=os.date('%Y',time),month=os.date('%m',time),day=os.date('%d',time),hour='00',min='00'})
    endTime = os.time({year=os.date('%Y',time),month=os.date('%m',time),day=os.date('%d',time),hour='23',min='59'})
    this.GetRankData()
end

function this.OnClickSelectTime(go)
    AudioManager.Instance:PlayAudio('btn')
    for i=0,1 do
        rankData.transform:Find('times/'..i):GetComponent('UIToggle'):Set(false)
    end
    PanelManager.Instance:ShowWindow('panelSelectTime',gameObject.name)
end

function this.OnClickRankDataSort(go)
    AudioManager.Instance:PlayAudio('btn')
    local As = go.transform:Find(1)
    local Ds = go.transform:Find(-1)
    if As.gameObject.activeSelf then
        rankDataSort = false
        Ds.gameObject:SetActive(true)
        As.gameObject:SetActive(false)
    else
        rankDataSort = true 
        As.gameObject:SetActive(true)
        Ds.gameObject:SetActive(false)
    end
    this.GetRankData()
end

function this.OnClickUsefulFieldRankSort(go)
    AudioManager.Instance:PlayAudio('btn')
    this.GetRankData()
end

function this.OnClickFuFeeRankSort(go)
    AudioManager.Instance:PlayAudio('btn')
    if fuFeeRankSort:GetComponent('UIToggle').value then
        rankDataSortBtn.transform:Find(1).gameObject:SetActive(true)
        rankDataSortBtn.transform:Find(-1).gameObject:SetActive(false)
        rankDataSort = true 
    else
        rankDataSortBtn.transform:Find(1).gameObject:SetActive(false)
        rankDataSortBtn.transform:Find(-1).gameObject:SetActive(true)
        rankDataSort = false 
    end
    this.GetRankData()
end

function this.OnClickRankTypeBtn(go)
    AudioManager.Instance:PlayAudio('btn')
    this.InitRankData()
    this.GetRankData()
end

function this.GetRankTypeCount()
    rankType={}
    if bit:_and(panelClub.clubInfo.privilege, 2048) == 2048 or panelClub.clubInfo.userType == proxy_pb.LORD then
        rankType={1,2,3,4,8,5,6,7}
    else
        if panelClub.clubInfo.timesAllowed then
            table.insert(rankType,1)
        end
        if panelClub.clubInfo.validTimesAllowed then
            table.insert(rankType,2)
        end
        if panelClub.clubInfo.bigTimesAllowed then
            table.insert(rankType,3)
        end
        if panelClub.clubInfo.feeAllowed then
            table.insert(rankType,4)
        end
		if panelClub.clubInfo.managerAllowed and panelClub.clubInfo.userType == proxy_pb.MANAGER then
            table.insert(rankType,8)
        end
        if panelClub.clubInfo.butlerAllowed and panelClub.clubInfo.userType ~= proxy_pb.GENERAL then
            table.insert(rankType,5)
        end
        if panelClub.clubInfo.myButlerAllowed and panelClub.clubInfo.userType ~= proxy_pb.GENERAL and panelClub.clubInfo.userType ~= proxy_pb.VICE_PRESIDENT then
            table.insert(rankType,6)
        end
        if panelClub.clubInfo.myUserAllowed and panelClub.clubInfo.userType ~= proxy_pb.GENERAL then
            table.insert(rankType,7)
        end
    end  
end

function this.InitRankType()
    downArrow.gameObject:SetActive(#rankType>6)
	this.IsShowBox(false)
    for i = 1, #rankTypeString do
        if rankTypeGrid.childCount<#rankTypeString then
            local obj = NGUITools.AddChild(rankTypeGrid.gameObject, rankTypeItem.gameObject)
            obj.transform:Find('highlight/Label1'):GetComponent('UILabel').text = rankTypeString[i]
            obj.transform:Find('Sprite/Label1'):GetComponent('UILabel').text = rankTypeString[i]
			local data = {}
			data.obj = obj
			data.name = rankTypeString[i]
            table.insert(rankTypeBtnObj, data)
            message:AddClick(obj, this.OnClickRankTypeBtn)
        end
    end
    for i = 1, #rankTypeBtnObj do
        rankTypeBtnObj[i].obj.gameObject:SetActive(false)
        rankTypeBtnObj[i].obj.transform:GetComponent('UIToggle'):Set(false)
		for j = 1, #rankType do
			if rankType[j] ==  ByRankTypeStringGetType[rankTypeBtnObj[i].name] then
				rankTypeBtnObj[i].obj.gameObject:SetActive(true)
			end
		end
    end
    for i = 1, #rankTypeBtnObj do
		if rankType[1] == ByRankTypeStringGetType[rankTypeBtnObj[i].name] then
			rankTypeBtnObj[i].obj.transform:GetComponent('UIToggle'):Set(true)
		end
    end
    
    rankTypeGrid:GetComponent('UIGrid'):Reposition()
    rankTypeScrollView:GetComponent('UIScrollView'):ResetPosition()
end

function this.InitRankData()
    currentSelectRankType = rankType[1]-1
    currentSelectRoomType = -1
    currentSelectRankNum = 50
    local time = os.time()
    startTime = os.time({year=os.date('%Y',time),month=os.date('%m',time),day=os.date('%d',time),hour='00',min='00'})
    endTime = os.time({year=os.date('%Y',time),month=os.date('%m',time),day=os.date('%d',time),hour='23',min='59'})
    rankDataSort = false 
    playerNameSelect:GetComponent('UILabel').text = '全部'
    rankingSelect:GetComponent('UILabel').text = '前50名'
    rankData.transform:Find('times/0'):GetComponent('UIToggle'):Set(true)
    rankData.transform:Find('times/1'):GetComponent('UIToggle'):Set(false)
    usefulFieldRankSort:GetComponent('UIToggle'):Set(false)
    fuFeeRankSort:GetComponent('UIToggle'):Set(false)
    rankDataSortBtn.transform:Find(1).gameObject:SetActive(false)
    rankDataSortBtn.transform:Find(-1).gameObject:SetActive(true)
    for i = 1, #rankTypeString do
        if rankTypeBtnObj[i].obj.transform:GetComponent('UIToggle').value == true then
			local inx = ByRankTypeStringGetType[rankTypeBtnObj[i].name] 
            local str=''
            if inx==1 or inx == 5 or inx == 6 or inx == 7 or inx == 8 then
                str = '总场次'
            elseif inx==2 then
                str = '有效场次'
            elseif inx==3 then
                str = '大赢家'
            elseif inx==4 then
                str = '疲劳值'
            end
            currentSelectRankType=inx-1
            rankDataSortBtn:GetComponent('UILabel').text = str
            usefulFieldRankSort.gameObject:SetActive(inx == 5 or inx == 6 or inx == 7 or inx == 8 )
            fuFeeRankSort.gameObject:SetActive(inx==4)
        end
    end
    print('currentSelectRankType : '..currentSelectRankType)
end
function this.IsShowBox()
	isSendedRequest = false
	noBtnBox.gameObject:SetActive(false)
end 
function this.GetRankData()
	if isSendedRequest==true then
        return
    end
	isSendedRequest = true
	noBtnBox.gameObject:SetActive(true)
	registerProxyReceive(this.IsShowBox())
	
    local msg = Message.New()
    msg.type = proxy_pb.CLUB_USER_RANK_LIST
    local body = proxy_pb.PRankList()
    body.clubId = panelClub.clubInfo.clubId
    body.type = currentSelectRankType
    body.roomType = currentSelectRoomType
    body.number = currentSelectRankNum
    body.startTime = startTime
    body.endTime = endTime
    if currentSelectRankType==3 and fuFeeRankSort:GetComponent('UIToggle').value then
        body.sortRule = not rankDataSort 
    else
        body.sortRule = rankDataSort
    end
    
    if currentSelectRankType==3 then
        body.rule = fuFeeRankSort:GetComponent('UIToggle').value
    elseif currentSelectRankType==4 or currentSelectRankType==5 or currentSelectRankType==6 or currentSelectRankType==7 then
        body.rule = usefulFieldRankSort:GetComponent('UIToggle').value
    else
        body.rule =false
    end
    print('clubId : '..body.clubId..' roomType : '..body.roomType..' type : '..body.type..' sortRule : '..tostring(body.sortRule)..' rule : '..tostring(body.rule))
    PanelManager.Instance:ShowWindow('panelNetWaitting')
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
		isSendedRequest = false
		noBtnBox.gameObject:SetActive(false)
        local data = proxy_pb.RRankList()
        data:ParseFromString(msg.body)
        PanelManager.Instance:HideWindow('panelNetWaitting')
        print('#data.users : '..#data.users)
        local rankdata = {}
       -- if currentSelectRankType == 3 and fuFeeRankSort:GetComponent('UIToggle').value then
            --for i = #data.users, 1,-1 do
                --table.insert(rankdata,data.users[i])
            --end
       -- else
            rankdata = data.users
       -- end
        for i = 1, #rankdata do
            local obj
            if rankDataGrid.childCount < #rankdata then
                obj = NGUITools.AddChild(rankDataGrid.gameObject, rankDataItem.gameObject)
            else
                obj = rankDataGrid:GetChild(i-1).gameObject
            end
            
           -- local index = rankDataSort and (#rankdata+1-i) or i
            --if currentSelectRankType == 3 and fuFeeRankSort:GetComponent('UIToggle').value then
                --this.UpdateRankDataItem(obj.transform,rankdata[index],rankDataSort and i or (#rankdata+1-i))
            --else
                if currentSelectRankType == 3 and fuFeeRankSort:GetComponent('UIToggle').value then
                    this.UpdateRankDataItem(obj.transform,rankdata[i],rankDataSort and i or (#rankdata+1-i))
                else
                    this.UpdateRankDataItem(obj.transform,rankdata[i],rankDataSort and (#rankdata+1-i) or i)
                end
                
            --end
        end
        for i = 0, rankDataGrid.childCount-1 do
            if i < #rankdata then
                rankDataGrid:GetChild(i).gameObject:SetActive(true)
            else
                rankDataGrid:GetChild(i).gameObject:SetActive(false)
            end
        end
        rankDataGrid:GetComponent('UIGrid'):Reposition()
        rankDataScrollView:GetComponent('UIScrollView'):ResetPosition()
        rankDataScrollView.gameObject:SetActive(#rankdata ~= 0)
        noRankData.gameObject:SetActive(#rankdata == 0)
    end)
end

function this.UpdateRankDataItem(obj,data,rank)
    obj.gameObject:SetActive(true)
    local userType = obj:Find('userType')
    for i = 0, userType.childCount-1 do
        userType:GetChild(i).gameObject:SetActive(false)
    end
    obj:Find('bianHao'):GetComponent('UILabel').text = rank
    obj:Find('bianHao').gameObject:SetActive(rank>3)
    obj:Find('bianHaoSp').gameObject:SetActive(rank<=3)
    obj:Find('bianHaoSp'):GetComponent('UISprite').spriteName = '排行榜—0'..rank
    coroutine.start(LoadPlayerIcon, obj:Find('TX'):GetComponent('UITexture'),data.icon)
    obj:Find('userType/'..data.userType).gameObject:SetActive(true)
    obj:Find('name'):GetComponent('UILabel').text = data.nickName
    local _id = ''
    if currentSelectRankType == 5 or currentSelectRankType == 6 then
        _id = data.userId
    else
        if panelClub.clubInfo.userType == proxy_pb.LORD or (bit:_and(panelClub.clubInfo.privilege, 1) == 1) then
            _id = data.userId
        else
            _id = HideIDNumber(data.userId)
        end
    end
	local isShowPost = false
	if currentSelectRankType == 0 or currentSelectRankType == 1 or currentSelectRankType == 2 or currentSelectRankType == 3 then 
		if panelClub.clubInfo.userType == proxy_pb.LORD or (bit:_and(panelClub.clubInfo.privilege, 1) == 1) then
			isShowPost = true
		else
			isShowPost = false
		end
	else
		isShowPost = true
	end
	obj:Find('userType').gameObject:SetActive(isShowPost)
    obj:Find('ID'):GetComponent('UILabel').text = 'id:'.._id
    obj:Find('fieldNum'):GetComponent('UILabel').text = data.objValue
	print('rank : '..rank..' data.objValue : '..data.objValue)
    obj:Find('time'):GetComponent('UILabel').text = '[9C4031]'..os.date('%Y%m%d,%H:%M', startTime)..'\n[401F1B]至[9C4031]'..os.date('%Y%m%d,%H:%M',endTime)
end

function this.GetPlayNameSelectCount()
    selectPlayName={}

    local data1={}
    data1.name='全部'
    data1.num = -1
    print('#panelClub.clubInfo.plays : '..#panelClub.clubInfo.plays)
    table.insert(selectPlayName,data1)
    local index = panelClub.clubInfo.lobby and 2 or 1
    local tableRoomType = {}
    for i = index, #panelClub.clubInfo.plays do
        table.insert(tableRoomType,panelClub.clubInfo.plays[i].roomType)
    end
    local neWTableRoomType = DeleteEqualElement(tableRoomType)
    for i = 1, #neWTableRoomType do
        local data={}
        data.name=playTypeString[neWTableRoomType[i]]
        data.num = neWTableRoomType[i]
        table.insert(selectPlayName,data)
    end
end

function this.GetRankingSelectCount()
    selectRanking={}
    local rank = 0
    for i = 1, 10 do
        local data = {}
        rank = rank+10
        data.name = '前'..rank..'名'
        data.num = rank
        table.insert(selectRanking,data)
    end
end
function this.GetSelectSearchBtnObj()
    selectPlayNameString={}
    selectPlayNameString = isSelectPlayerName and selectPlayName or selectRanking
    print('#selectPlayNameString : '..#selectPlayNameString)
    for i = 1, #selectPlayNameString do
        if panelSelectDataGrid.childCount < #selectPlayNameString then
            local obj = NGUITools.AddChild(panelSelectDataGrid.gameObject, panelSelectDataItem.gameObject)
            message:AddClick(obj, this.OnClickSelectSearchBtn)
        end
    end
    for i = 0, panelSelectDataGrid.childCount-1 do
        if i>#selectPlayNameString-1 then
            panelSelectDataGrid:GetChild(i).gameObject:SetActive(false)
        else
            panelSelectDataGrid:GetChild(i):Find('Label'):GetComponent('UILabel').text = selectPlayNameString[i+1].name
            panelSelectDataGrid:GetChild(i).gameObject:SetActive(true)
        end
    end
    panelSelect.gameObject:SetActive(true)
    panelSelectDataGrid:GetComponent('UIGrid'):Reposition()
    panelSelectDataScrollView:GetComponent('UIScrollView'):ResetPosition()
end

function this.onSelectTime(startT,endT)
    startTime=startT
    endTime=endT
    this.GetRankData()
end