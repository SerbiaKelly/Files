local proxy_pb = require 'proxy_pb'
local json = require 'json'

panelRecordDetail = {}


local this = panelRecordDetail;
local roomRecordData = {}
local RecordList = {}

local message;
local gameObject;

local mask
local Grid
local ButtonBack
local prefabItem

local title1
local title2

local whoShow

local PlayCodePanel
local PlayCodeCopyButton


--启动事件--
function this.Awake(obj)
    gameObject = obj;

    mask = gameObject.transform:Find('BaseContent/mask');
    Grid = gameObject.transform:Find('Grid');

    title1 = gameObject.transform:Find('bg/Label1');
    title2 = gameObject.transform:Find('bg/Label2');
    ButtonBack = gameObject.transform:Find('BaseContent/ButtonClose');
    prefabItem = gameObject.transform:Find('item');
    message = gameObject:GetComponent('LuaBehaviour');


    PlayCodePanel = gameObject.transform:Find('PlayCodePanel')
    PlayCodeCopyButton = gameObject.transform:Find('PlayCodePanel/ButtonOK')

    --message:AddClick(mask.gameObject, this.OnClickMask);
    message:AddClick(ButtonBack.gameObject, this.OnClickButtonBack);
    message:AddClick(PlayCodeCopyButton.gameObject, this.OnClickCopyPlayCode)
    message:AddClick(PlayCodePanel.transform:Find('BaseContent/ButtonClose').gameObject, this.OnClickClosePlayCodePanel)
end

function this.Start()

end
function this.Update()

end
function this.OnEnable()

end

--单击事件--
function this.OnClickMask(go)
    if whoShow~='panelMenberRecord' then
        PanelManager.Instance:ShowWindow(whoShow)
	elseif whoShow~='panelMenber' then
		local data = {}
		data.index = 3
		data.playerIDFuFeeValue = 0
		PanelManager.Instance:ShowWindow(whoShow,data)
    end
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickButtonBack(go)
    AudioManager.Instance:PlayAudio('btn')
	if whoShow=='panelMenber' then
		local data = {}
		data.index = 3
		data.playerIDFuFeeValue = 0
		PanelManager.Instance:ShowWindow(whoShow,data)
		PanelManager.Instance:ShowWindow('panelClub')
	else
		PanelManager.Instance:ShowWindow(whoShow)
    end
    PanelManager.Instance:HideWindow(gameObject.name)
end


function this.OnClickRePlay(go)
    replayData = {}
    replayData.roomId = roomRecordData.roomId
    replayData.round = GetUserData(go.transform.parent.gameObject).round
    replayData.roomNumber = roomRecordData.roomNumber
    print("回放数据详情  ",roomRecordData.gameType,"  __  ",replayData.round,"  __  ",replayData.roomNumber);

    --print('playCode:'..tostring(GetUserData(go.transform.parent.gameObject).playCode))
    -- local playCode = GetUserData(go.transform.parent.gameObject).playCode
    -- local gameType = tonumber(string.sub(playCode, 1, 2)) - 1
    -- local round = string.sub(playCode, 2, 4)
    -- local roundId = string.sub(playCode, 4)

    -- if (panelInGame and panelInGame.fanHuiRoomNumber) then
    --     panelMessageBox.SetParamers(ONLY_OK, nil, nil, '您当前已在游戏中！请退出或解散游戏后再操作。')
    --     PanelManager.Instance:ShowWindow('panelMessageBox')
    --     return 
    -- end

    if roomRecordData.gameType == proxy_pb.PDK then
        PanelManager.Instance:ShowWindow('panelReplay_pdk', {name = gameObject.name, isNeedRequest = true})
    elseif roomRecordData.gameType == proxy_pb.PHZ then
        PanelManager.Instance:ShowWindow('panelReplay', {name = gameObject.name, isNeedRequest = true})
    elseif roomRecordData.gameType == proxy_pb.MJ then
        PanelManager.Instance:ShowWindow('panelReplay_mj', {name = gameObject.name, isNeedRequest = true})
    elseif roomRecordData.gameType == proxy_pb.XHZD then
        PanelManager.Instance:ShowWindow('panelReplay_xhzd', {name = gameObject.name, isNeedRequest = true})
    elseif roomRecordData.gameType == proxy_pb.DTZ then
        PanelManager.Instance:ShowWindow('panelReplay_dtz', {name = gameObject.name, isNeedRequest = true})
    elseif roomRecordData.gameType == proxy_pb.BBTZ then
        PanelManager.Instance:ShowWindow('panelReplay_bbtz', {name = gameObject.name, isNeedRequest = true})
    elseif roomRecordData.gameType == proxy_pb.XPLP then
        PanelManager.Instance:ShowWindow('panelReplay_xplp', {name = gameObject.name, isNeedRequest = true})
    elseif roomRecordData.gameType == proxy_pb.HNM and roomRecordData.roomType == proxy_pb.HNHSM then
        PanelManager.Instance:ShowWindow('panelReplay_hnhsm', {name = gameObject.name, isNeedRequest = true})
    elseif roomRecordData.gameType == proxy_pb.HNM and roomRecordData.roomType == proxy_pb.HNZZM then
        PanelManager.Instance:ShowWindow('panelReplay_hnzzm', {name = gameObject.name, isNeedRequest = true})
    elseif roomRecordData.gameType == proxy_pb.YJQF then
        PanelManager.Instance:ShowWindow("panelReplay_yjqf",{name = gameObject.name, isNeedRequest = true})
    elseif roomRecordData.gameType == proxy_pb.DZM and roomRecordData.roomType == proxy_pb.DZAHM then
        PanelManager.Instance:ShowWindow("panelReplay_dzahm",{name = gameObject.name, isNeedRequest = true})
    end
end

function this.OnGetRecord(msg)
    local b = proxy_pb.RRoundList()
    b:ParseFromString(msg.body);
	roomRecordData.roomType = b.roomType
	roomRecordData.gameType = b.gameType
	roomRecordData.diamonds = b.diamonds
    roomRecordData.playName = b.playName
    if b.gameType == proxy_pb.HNM or b.gameType == proxy_pb.DZM or b.gameType == proxy_pb.MJ then 
        print("set room type --------------->");
        print("settings:"..b.settings);
        if json:decode(b.settings).roomType == "HNHSM" then 
            roomRecordData.roomType = proxy_pb.HNHSM;
        end
        if json:decode(b.settings).roomType == "HNZZM" then 
            roomRecordData.roomType = proxy_pb.HNZZM;
        end
        if json:decode(b.settings).roomType == "DZAHM" then 
            roomRecordData.roomType = proxy_pb.DZAHM;
        end
    end
    RecordList = b
    this.Refresh()
end
local MemberListGO = {}
function this.Refresh()
    Util.ClearChild(Grid)
    MemberListGO = {}

    gameObject.transform:Find('title/Label'):GetComponent('UILabel').text = '房间号：' .. roomRecordData.roomNumber
    gameObject.transform:Find('title/Label2'):GetComponent('UILabel').text = '' --'名称：' .. playName
    gameObject.transform:Find('title/Label3'):GetComponent('UILabel').text = '消耗钻石：' .. roomRecordData.diamonds
    print("RecordList.settings",json:decode(RecordList.settings))
    print("RecordList.gameType",RecordList.gameType)
    if roomRecordData.gameType == proxy_pb.PDK then
        gameObject.transform:Find('Rule/Label'):GetComponent('UILabel').text = '当前规则：'..getWanFaText_pdk(json:decode(RecordList.settings),false, false, true)
    elseif roomRecordData.gameType == proxy_pb.PHZ then
        gameObject.transform:Find('Rule/Label'):GetComponent('UILabel').text = '当前规则：'..getWanFaText(json:decode(RecordList.settings), true, false, true)
    elseif roomRecordData.gameType == proxy_pb.XHZD then
        gameObject.transform:Find('Rule/Label'):GetComponent('UILabel').text = '当前规则：'..getXHZDRuleString(json:decode(RecordList.settings), false, true, true)
    elseif roomRecordData.gameType == proxy_pb.MJ then
        gameObject.transform:Find('Rule/Label'):GetComponent('UILabel').text = '当前规则：'..GetMJRuleText(json:decode(RecordList.settings), false, false, true)
    elseif roomRecordData.gameType == proxy_pb.DTZ then
        gameObject.transform:Find('Rule/Label'):GetComponent('UILabel').text = '当前规则：'..GetDTZRuleString(json:decode(RecordList.settings), false, false, true);
    elseif roomRecordData.gameType == proxy_pb.BBTZ then
        gameObject.transform:Find('Rule/Label'):GetComponent('UILabel').text = '当前规则：'..GetBBTZRuleString(json:decode(RecordList.settings), false, false, true);
    elseif roomRecordData.gameType == proxy_pb.XPLP then
        gameObject.transform:Find('Rule/Label'):GetComponent('UILabel').text = '当前规则：'..GetXPLPRuleText(json:decode(RecordList.settings), false, false, true);
    elseif roomRecordData.gameType == proxy_pb.HNM and roomRecordData.roomType == proxy_pb.HNHSM then
        gameObject.transform:Find('Rule/Label'):GetComponent('UILabel').text = '当前规则：'..GetHNHSMRuleText(json:decode(RecordList.settings), false, false, true);
    elseif roomRecordData.gameType == proxy_pb.HNM and roomRecordData.roomType == proxy_pb.HNZZM then
        gameObject.transform:Find('Rule/Label'):GetComponent('UILabel').text = '当前规则：'..GetHNZZMRuleText(json:decode(RecordList.settings), false, false, true);
    elseif roomRecordData.gameType == proxy_pb.YJQF then
        gameObject.transform:Find('Rule/Label'):GetComponent('UILabel').text = '当前规则：'..getYJQFRuleString(json:decode(RecordList.settings))
    elseif roomRecordData.gameType == proxy_pb.DZM and roomRecordData.roomType == proxy_pb.DZAHM then
        gameObject.transform:Find('Rule/Label'):GetComponent('UILabel').text = '当前规则：'..GetDZAHMRuleText(json:decode(RecordList.settings), false, false, true);
    end
    for i = 1, #RecordList.rounds do
        local userGO = {}
        userGO.GO = NGUITools.AddChild(Grid.gameObject, prefabItem.gameObject)
        userGO.GO.name = 'item' .. RecordList.rounds[i].round
        SetUserData(userGO.GO, RecordList.rounds[i])
        MemberListGO[i] = userGO
        userGO.GO.transform:Find('order/order'):GetComponent('UILabel').text = RecordList.rounds[i].round..'/'..#RecordList.rounds
        userGO.GO.transform:Find('time'):GetComponent('UILabel').text = os.date('%Y-%m-%d %H:%M:%S', RecordList.rounds[i].time)

        for j=1,4 do
            if j <= #RecordList.rounds[i].players then
                local player = userGO.GO.transform:Find('playerName' .. j)
                coroutine.start(LoadPlayerIcon, player:Find('TX'):GetComponent('UITexture'), RecordList.rounds[i].players[j].icon)
                player:GetComponent('UILabel').text = RecordList.rounds[i].players[j].name
                player:Find('num'):GetComponent('UILabel').text = RecordList.rounds[i].players[j].score
                userGO.GO.transform:Find('playerName' .. j).gameObject:SetActive(true)
            else
                userGO.GO.transform:Find('playerName' .. j).gameObject:SetActive(false)
            end
        end
        
        if IsAppleReview() then
            userGO.ButtonLook.gameObject:SetActive(false)
        else
            userGO.ButtonLook = userGO.GO.transform:Find('ButtonLook')
            userGO.ButtonShare = userGO.GO.transform:Find('ButtonShare')
            message:AddClick(userGO.ButtonShare.gameObject, this.OnSharePlayCode)
            message:AddClick(userGO.ButtonLook.gameObject, this.OnClickRePlay)
        end
        userGO.GO:SetActive(true)

        print('playCode:'..tostring(RecordList.rounds[i].playCode))
    end

    Grid:GetComponent('UIGrid'):Reposition()
    Grid:GetComponent('UIScrollView'):ResetPosition()
end

local curRecord
function this.OnSharePlayCode(go)
    -- local playCode = GetUserData(go.transform.parent.gameObject).playCode
    -- Util.CopyToSystemClipbrd(playCode)
    -- panelMessageTip.SetParamers('复制成功', 1.5)
    -- PanelManager.Instance:ShowWindow('panelMessageTip')	
    curRecord = GetUserData(go.transform.parent.gameObject)
    
    PlayCodePanel.transform:Find('PlayCode'):GetComponent('UILabel').text = curRecord.playCode
    
    PlayCodePanel.gameObject:SetActive(true)
end

function this.OnClickClosePlayCodePanel(go)
    PlayCodePanel.gameObject:SetActive(false)
end

function this.OnClickCopyPlayCode(go)
    local playCode = PlayCodePanel.transform:Find('PlayCode'):GetComponent('UILabel').text
    local playName = ''
    if roomRecordData.playName == '' then
        playName = GameTypeString[roomRecordData.gameType]
    else
        playName = roomRecordData.playName
    end
    local str = '房间号：'..roomRecordData.roomNumber..'\n'..
                '局数：'..curRecord.round..'/'..#RecordList.rounds..'\n'..
                '玩法：'..playName..'\n'..
                '回放码：'..playCode
    
    Util.CopyToSystemClipbrd(str)
    panelMessageTip.SetParamers('复制成功', 1.5)
    PanelManager.Instance:ShowWindow('panelMessageTip')	
end

function this.WhoShow(myData)
    whoShow=myData.name
	roomRecordData.roomId = myData.roomId
	roomRecordData.roomNumber = myData.roomNumber
	print('myData.roomNumber : '..myData.roomNumber)
    this.sendMSG(myData)
    PanelManager.Instance:HideWindow(myData.name)
end

--发送获取战绩的命令
function this.sendMSG(data)
    local msg = Message.New()
    msg.type = proxy_pb.ROUND_LIST;
    local body = proxy_pb.PRoundList();
    body.roomId = data.roomId
    --print('房间号'..data.roomNumber)
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, this.OnGetRecord);
end

function this.setTitle(str)
    title1:GetComponent('UILabel').text = str
    title2:GetComponent('UILabel').text = str
end

