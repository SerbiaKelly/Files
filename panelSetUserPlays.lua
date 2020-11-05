local proxy_pb = require 'proxy_pb'

panelSetUserPlays = {}
local this = panelSetUserPlays
local json = require 'json'
local cs = require 'const'

local message
local gameObject
local ButtonClose
local tableGrid
local contentGrid
local tableItem
local contentItem
local pnaelDetailed
local pnaelDetailedMsg
local tip
local title

local buttonSave
local buttonSelectAll
local buttonInvertSelect

local curAllPlays
local curSelectAllPlays--当前所有已选的

local isSetUserPlays
local CurOperationPlayer = {}
local TogglePlays = {}

function this.Awake(go)
    gameObject = go
    message = gameObject:GetComponent('LuaBehaviour')

    tableGrid = gameObject.transform:Find("gridBtn/grid")
    contentGrid = gameObject.transform:Find("Content/Grid")
    tableItem = gameObject.transform:Find("Prefab/tableItem")
    contentItem = gameObject.transform:Find("Prefab/contentItem")
    pnaelDetailed = gameObject.transform:Find("pnaelDetailed")
    pnaelDetailedMsg = gameObject.transform:Find("pnaelDetailed/message"):GetComponent("UILabel")
    tip = gameObject.transform:Find("bg/tip"):GetComponent("UILabel")
    title = gameObject.transform:Find("bg/title"):GetComponent("UILabel")
    
    buttonSave = gameObject.transform:Find("Bottom/Buttons/ButtonSave")
    buttonSelectAll = gameObject.transform:Find("Bottom/Buttons/ButtonSelectAll")
    buttonInvertSelect = gameObject.transform:Find("Bottom/Buttons/ButtonInvertSelect")
    message:AddClick(buttonSave.gameObject, this.OnClickButtonSave)
    message:AddClick(buttonSelectAll.gameObject, this.OnClickButtonSelectAll)
    message:AddClick(buttonInvertSelect.gameObject, this.OnClickButtonInvertSelect)

    message:AddClick(gameObject.transform:Find("ButtonClose").gameObject, function() PanelManager.Instance:HideWindow(gameObject.name) end)
    message:AddClick(gameObject.transform:Find("pnaelDetailed/ButtonClose").gameObject, function() pnaelDetailed.gameObject:SetActive(false) end)
    message:AddClick(gameObject.transform:Find("pnaelDetailed/ButtonOK").gameObject, function() pnaelDetailed.gameObject:SetActive(false) end)
end

function this.Update() end
function this.Start() end

function this.WhoShow(data)
    gameObject.transform:Find('tip').gameObject:SetActive(not panelClub.playInfo.playId)
    if not panelClub.playInfo.playId then
        return
    end
    
    CurOperationPlayer = data
    isSetUserPlays = data ~= "ClubSetPlaysToggle"
    title.text = isSetUserPlays and "玩法限制" or "玩法显示"
    tip.text = isSetUserPlays and "注:未选中的玩法该成员将无法在牌友群看见" or "注:未选中的玩法将不会显示"
    if isSetUserPlays then
        this.RequestUserPlaysData()
        return
    end

    local msg = Message.New()
    msg.type = proxy_pb.CLUB_PLAY_LIST
    local body = proxy_pb.PClubPlaySetting()
    body.clubId = panelClub.clubInfo.clubId
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local data = proxy_pb.RClubPlayList()
        data:ParseFromString(msg.body)
        TogglePlays = {}
        for i=1, #data.plays do
            table.insert(TogglePlays, data.plays[i])
        end
        this.RefreshList(TogglePlays)
    end)
end

function this.RequestUserPlaysData()
    local msg = Message.New()
    msg.type = proxy_pb.JUNIOR_PLAY_LIST
    local body = proxy_pb.PJuniorPlayList()
    body.clubId = panelClub.clubInfo.clubId
    body.userId = CurOperationPlayer.userId
    print('拉取用户玩法设置 useid:'..CurOperationPlayer.userId .. '俱乐部id：'..body.clubId)
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RJuniorPlayList()
        b:ParseFromString(msg.body)
        this.Refresh(b.plays)
    end)
end

function this.GetPlays(tbl, gameName)
    for _, v in pairs(tbl) do
        if v.gameName == gameName then
            return v
        end
    end
end

function this.SetPlay(plays)
    local tbl = {}
    for i = 1, #plays do
        local play = plays[i]
        local playInfo = panelClub.GetGameTyeByPlay(play.playId)
        if playInfo then
            local gameName = cs.GetGameDataByroomType(playInfo.roomType).gameName
            local playTbl = this.GetPlays(tbl, gameName)
            if not playTbl then
                table.insert(tbl, {gameType = playInfo.gameType, plays = {play}, roomType = playInfo.roomType, gameName = gameName,})
            else
                table.insert(playTbl.plays, play)
            end
        end
    end
    local temp = {}
    for i,v in ipairs(plays) do
        table.insert(temp,v)
    end
    table.insert( tbl,1,{plays = temp})--第一项全部玩法

    return tbl
end

function this.GetDetailed(play, gameType, roomType)
    local settings = json:decode(play.settings)
    local text = ""

    if not settings then
        text = "网络有点小问题，退出刷新重进"
        return
    end
   
    if gameType == proxy_pb.PHZ then 
        text = getWanFaText(settings, true)
    elseif gameType == proxy_pb.PDK then 
        text = getWanFaText_pdk(settings)
    elseif gameType == proxy_pb.MJ then 
        text = GetMJRuleText(settings)
    elseif gameType == proxy_pb.XHZD then 
        text = getXHZDRuleString(settings)
    elseif gameType == proxy_pb.DTZ then
        text = GetDTZRuleString(settings)
    elseif gameType == proxy_pb.BBTZ then 
        text = GetBBTZRuleString(settings)
    elseif gameType == proxy_pb.XPLP then 
        text = GetXPLPRuleText(settings)
    elseif gameType == proxy_pb.HNM and roomType == proxy_pb.HNHSM then 
        text = GetHNHSMRuleText(settings)
    elseif gameType == proxy_pb.HNM and roomType == proxy_pb.HNZZM then 
        text = GetHNZZMRuleText(settings)
    elseif gameType == proxy_pb.YJQF then 
        text = getYJQFRuleString(settings)
    elseif gameType == proxy_pb.DZM and roomType == proxy_pb.DZAHM then 
        text = GetDZAHMRuleText(settings)
    elseif gameType == proxy_pb.DZM and roomType == proxy_pb.DZSYM then 
        text = GetDZSYMRuleText(settings)
    elseif gameType == proxy_pb.DZM and roomType == proxy_pb.DZHSM then 
        text = GetDZHSMRuleText(settings)
    elseif gameType == proxy_pb.DDZ then
        text = getWanFaText_ddz(settings)
    elseif gameType == proxy_pb.HSTH then
        text = getHSTHRuleString(settings)
    end

    return text
end

function this.SelectPlay(go)
    --local data = GetUserData(go.transform.parent.gameObject)
    this.SetPlaySelectState(go.transform.parent,not go.transform.parent:Find("Select").gameObject.activeSelf)
end

function this.OnSelectTableItem(go)
    local playTbl = GetUserData(go)
    --本地缓存的游戏显示记录
    curAllPlays = {}
    local setUserPlaysJson = #playTbl.plays > 0 and panelClub.GetTogglesPlaysTable() or {}
    for i = 0, #playTbl.plays - 1 do
        local obj
        if i <= contentGrid.childCount - 1 then
            obj = contentGrid:GetChild(i).gameObject
        else
            obj = NGUITools.AddChild(contentGrid.gameObject, contentItem.gameObject)
            message:AddClick(obj.transform:Find("Bg").gameObject, this.SelectPlay)
            message:AddClick(obj.transform:Find("Detailed").gameObject, function(go)
                local data = GetUserData(go.transform.parent.gameObject)
                pnaelDetailedMsg.text = data.play.name .. "：" .. this.GetDetailed(data.play, data.gameType, data.roomType)
                pnaelDetailed.gameObject:SetActive(true)
            end)
        end

        local play = playTbl.plays[i + 1]
        table.insert(curAllPlays, play)
        local playInfo = panelClub.GetGameTyeByPlay(play.playId)
        SetUserData(obj, {play = play, gameType = playInfo.gameType, roomType = playInfo.roomType, playId = play.playId})

        obj.transform:Find("PlayName"):GetComponent('UILabel').text = play.name
        obj.transform:Find('PlayRule'):GetComponent('UILabel').text = "规则：" .. this.GetDetailed(play, playTbl.gameType, playTbl.roomType)
       
        local state
        if isSetUserPlays then
            state = playTbl.plays[i+1].assigned
        else
            state = not setUserPlaysJson[playTbl.plays[i+1].playId] or setUserPlaysJson[playTbl.plays[i+1].playId] == 1
        end
        obj.transform:Find("Select").gameObject:SetActive(state)
        obj.transform:Find("Bg"):GetComponent("UISprite").spriteName = state and "牌友群大厅_设置玩法_框1" or "游戏大弹窗_内容描边框"
        obj.gameObject:SetActive(true)
    end

    if contentGrid.childCount > #playTbl.plays then
        for i = #playTbl.plays + 1, contentGrid.childCount do
            contentGrid:GetChild(i - 1).gameObject:SetActive(false)
        end
    end

    contentGrid:GetComponent('UIGrid').repositionNow = true
    contentGrid:GetComponent('UIGrid'):Reposition()
    contentGrid.parent:GetComponent('UIScrollView'):ResetPosition()
end

function this.RefreshPlays()
    
end

function this.RefreshList(plays)
    for i = 0, tableGrid.childCount - 1 do
        tableGrid:GetChild(i).gameObject:SetActive(false)
    end
    for i = 0, contentGrid.childCount - 1 do
        contentGrid:GetChild(i).gameObject:SetActive(false)
    end

    --分类整理
    local tbl = this.SetPlay(plays)
    for i, playTbl in ipairs(tbl) do
        local obj
        if i <= tableGrid.childCount then
            obj = tableGrid:GetChild(i - 1).gameObject
        else
            obj = NGUITools.AddChild(tableGrid.gameObject, tableItem.gameObject)
            local toggle = obj.transform:GetComponent("UIToggle")
            EventDelegate.AddForLua(toggle.onChange, function()
                if not toggle.value then
                    return
                end
                this.OnSelectTableItem(obj) 
            end)
        end

        SetUserData(obj, playTbl)
        local gameName = playTbl.roomType and cs.GetGameDataByroomType(playTbl.roomType).gameName or "全部"
        obj.transform:Find("highlight/Label1"):GetComponent("UILabel").text = gameName
        obj.transform:Find("Sprite/Label1"):GetComponent("UILabel").text = gameName
       
        obj:SetActive(true)
        obj.transform:GetComponent("UIToggle"):Set(false)
    end

    local obj = tableGrid:GetChild(0).gameObject
    this.OnSelectTableItem(obj)
    obj.transform:GetComponent("UIToggle"):Set(true)
    tip.gameObject:SetActive(false)

    if tableGrid.childCount > #tbl then
        for i = #tbl + 1, tableGrid.childCount do
            tableGrid:GetChild(i - 1).gameObject:SetActive(false)
        end
    end

    tableGrid:GetComponent('UIGrid').repositionNow = true
    tableGrid:GetComponent('UIGrid'):Reposition()
    tableGrid.parent:GetComponent('UIScrollView'):ResetPosition()
end

function this.OnClickButtonSave(go)
    if isSetUserPlays then
        local msg = Message.New()
        msg.type = proxy_pb.ASSIGN_PLAY
        local body = proxy_pb.PAssignPlay()
        body.clubId = panelClub.clubInfo.clubId
        body.userId = CurOperationPlayer.userId
        for i = 0, contentGrid.childCount-1 do
            if contentGrid:GetChild(i).gameObject.transform:Find("Select").gameObject.activeSelf then
                table.insert(body.playIds, GetUserData(contentGrid:GetChild(i).gameObject).playId)
            end
        end
        
        if #body.playIds == 0 then
            panelMessageTip.SetParamers("请最少保留一个玩法",1,nil)
            PanelManager.Instance:ShowWindow('panelMessageTip')
            return
        end
        msg.body = body:SerializeToString()
        Debugger.LogError("限制保存")
        SendProxyMessage(msg, this.AssignPlayRes)
        return
    end
    
    --之前的记录+新设置的记录
    local tbl = {}
    local togglePlays = panelClub.GetTogglesPlaysTable()
    for k,v in pairs(togglePlays) do
        tbl[k] = v
    end
    for i = 0, contentGrid.childCount-1 do
        if i + 1 <= #TogglePlays then
            local obj = contentGrid:GetChild(i).gameObject
            if obj.activeSelf then
                local state = obj.transform:Find("Select").gameObject.activeSelf
                tbl[GetUserData(obj).playId] = state and 1 or 0
            end
        end
    end
    panelClub.SetTogglesPlaysTable(tbl)

    panelClub.shuaXinPlays(panelClub.clubInfo.clubId, panelClub.clubInfo.playId)
    panelMessageTip.SetParamers("修改成功",1,nil)
    PanelManager.Instance:ShowWindow('panelMessageTip')
end

function this.OnClickButtonSelectAll(go)
    for i = 0, contentGrid.childCount-1 do
        local obj = contentGrid:GetChild(i).gameObject
        if obj.activeSelf then
            this.SetPlaySelectState(obj,true)
        end
    end
end

function this.OnClickButtonInvertSelect(go)
    for i = 0, contentGrid.childCount-1 do
        local obj = contentGrid:GetChild(i).gameObject
        if obj.activeSelf then
            if obj.transform:Find("Select").gameObject.activeSelf then
                this.SetPlaySelectState(obj,false)
            else
                this.SetPlaySelectState(obj,true)
            end
        end
    end
end

function this.AssignPlayRes(msg)
    local data = proxy_pb.RResult()
    data:ParseFromString(msg.body)
    if data.code == 1 then
        panelMessageTip.SetParamers("修改成功",1,nil)
    else
        panelMessageTip.SetParamers("修改失败",1,nil)
        print('修改失败 error='..data.msg)
    end
    PanelManager.Instance:ShowWindow('panelMessageTip')
end

function this.SetPlaySelectState(obj,state)
    obj.transform:Find("Select").gameObject:SetActive(state)
    obj.transform:Find("Bg"):GetComponent("UISprite").spriteName = state and "牌友群大厅_设置玩法_框1" or "游戏大弹窗_内容描边框"
end