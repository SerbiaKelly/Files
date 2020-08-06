local proxy_pb = require 'proxy_pb'
local json = require 'json'
local stringTool = require 'stringTool'

panelSetPlay = {}
local this=panelSetPlay
local RecordList={}
local message;
local gameObject;
local mask
local ScrollView
local Tabel
local prefabItem
local buttonClose
local tip

local ButtonNew
local PlayRules = {}
local playRuleInfos={}
local EditPanel
local NameInput
local WinPlayInput
local FFInput
local smallWinerInput
local smallWinerFeeInput
local ToggleAAPay
local EnterMinFeeInput
local OneScoreFeeInput
local AutoDissolveInput
local AutoDissolveToggle
local AutoDissolveTipBtn
local InputCollection
local ToggleOnlyPlay
local ToggleHidePlay
local AllowXiPaiInput
local AllowXiPaiToggle
local AllowXiPaiTipBtn

local curEditPlay
--启动事件--
function this.Awake(obj)
    gameObject = obj;
	message = gameObject:GetComponent('LuaBehaviour');

    mask = gameObject.transform:Find('mask');
    ScrollView = gameObject.transform:Find('Scroll View');
    Tabel = gameObject.transform:Find('Scroll View/Tabel')
	buttonClose = gameObject.transform:Find('ButtonBack');
	tip = gameObject.transform:Find('tip');
    prefabItem = gameObject.transform:Find('item');

    ButtonNew = gameObject.transform:Find('ButtonNew');

    EditPanel = gameObject.transform:Find('EditPanel')
    InputCollection = EditPanel.transform:Find('InputCollection')
    NameInput = InputCollection.transform:Find('name/nameInput')
    EventDelegate.AddForLua(NameInput:GetComponent('UIInput').onChange, this.OnInputChangeNameInput)
    WinPlayInput = InputCollection.transform:Find('winPlayLow/WinPlayInput')
    FFInput = InputCollection.transform:Find('winPlayLow/FFInput')

    smallWinerInput = InputCollection.transform:Find('winPlaySmall/smallInput')
    smallWinerFeeInput = InputCollection.transform:Find('winPlaySmall/smallFeeInput')
    EventDelegate.AddForLua(smallWinerFeeInput:GetComponent('UIInput').onChange, this.OnInputChangeWinDeductFee)
    ToggleAAPay = InputCollection.transform:Find('winPlaySmall/AAPay')
	--只有得得包显示
	ToggleAAPay.gameObject:SetActive(false)

    EnterMinFeeInput = InputCollection.transform:Find('EnterMinFeeInput')
    OneScoreFeeInput = InputCollection.transform:Find('OneScoreFeeInput')
    AutoDissolveInput = InputCollection.transform:Find('AutoDissolveInput')
    AutoDissolveTipBtn = AutoDissolveInput.transform:Find('TipBtn')
    AutoDissolveToggle = AutoDissolveInput.transform:Find('Toggle')
    AllowXiPaiInput = InputCollection.transform:Find('AllowXiPaiInput')
    AllowXiPaiTipBtn = AllowXiPaiInput.transform:Find('TipBtn')
    AllowXiPaiToggle = AllowXiPaiInput.transform:Find('Toggle')

    ToggleOnlyPlay = gameObject.transform:Find('Toggle/onlyPlay')
    ToggleHidePlay = gameObject.transform:Find('Toggle/hidePlay')

    message:AddClick(ButtonNew.gameObject, this.OnClickNew);
    message:AddClick(buttonClose.gameObject, this.OnClickMask);
    message:AddClick(EditPanel.transform:Find('ButtonOK').gameObject, this.OnClickUpdatePlay)
    message:AddClick(EditPanel.transform:Find('BaseContent/ButtonClose').gameObject, function (go)
        EditPanel.transform.gameObject:SetActive(false)
    end)
   
    message:AddClick(AutoDissolveTipBtn.gameObject, function (go)
        gameObject.transform:Find('TipPanel').gameObject:SetActive(true)
        gameObject.transform:Find('TipPanel/message'):GetComponent('UILabel').text=[[1.每一小局结束后，系统都会判断该房间中的所有玩家的剩余疲劳值是否足以进行后续的牌局，若有一人不足，则该房间自动解散，直接进行大结算

        2.触发自动解散条件：设置的自动解散疲劳值>某玩家剩余疲劳值-（小结算累计分数*疲劳值换算比）
        
        3.自动解散值默认为0，群主和管理员可以设置为正负整数
        
        4.该值只能设置为整数，默认不开启]]
    end)
    message:AddClick(AllowXiPaiTipBtn.gameObject, function (go)
        gameObject.transform:Find('TipPanel').gameObject:SetActive(true)
        gameObject.transform:Find('TipPanel/message'):GetComponent('UILabel').text=[[1.该功能，默认不开启

        2.该功能开启后，每一小局小结算会显示出“洗牌”按钮，玩家可以点击洗牌按钮为下一局进行洗牌
        
        3.玩家点击洗牌按钮后，会提示玩家洗牌需要多少疲劳值，是否确定洗牌，如果玩家确定洗牌，则扣除玩家相应疲劳值点数
        
        4.每小局洗牌疲劳值默认为0，群主和有权限的管理员可以设置，只能是正数，最多保留两位小数]]
    end)
    message:AddClick(gameObject.transform:Find('TipPanel/BaseContent/ButtonClose').gameObject, function (go)
        gameObject.transform:Find('TipPanel').gameObject:SetActive(false)
    end)
    
    message:AddClick(gameObject.transform:Find('Toggle/onlyPlay/onlyPlayHelpBtn').gameObject, function (go)
        panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '选择后，只显示当前选择的玩法所有空桌，隐藏其他玩法没有人的空桌')
        PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
    end)

    message:AddClick(gameObject.transform:Find('Toggle/hidePlay/hidePlayHelpBtn').gameObject, function (go)
        panelMessageBoxTiShi.SetParamers(ONLY_OK, nil, nil, '选择后，隐藏所有玩法已开始的牌桌')
        PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
    end)

    WinPlayInput:GetComponent('UIInput').onValidate=checkInteger
    FFInput:GetComponent('UIInput').onValidate=checkFloat
    EnterMinFeeInput:GetComponent('UIInput').onValidate=checkFloat
    OneScoreFeeInput:GetComponent('UIInput').onValidate=checkFloat
    AllowXiPaiInput:GetComponent('UIInput').onValidate=checkFloat
    --RegisterProxyCallBack(60, this.GetPlayRuleList)
end

function this.OnClickNew(go)
    AudioManager.Instance:PlayAudio('btn')
    print('playRuleInfos: '..#playRuleInfos)
    if #playRuleInfos>=40 then
        panelMessageBox.SetParamers(ONLY_OK,nil,nil,"新增玩法已达上限，每个牌友群最多只能新增40种玩法")
        PanelManager.Instance:ShowWindow("panelMessageBox")
        return 
    end
    PanelManager.Instance:ShowWindow('panelSelctPlay',panelClub.clubInfo)
end

function this.Update()
   
end
function this.Start()
    
end

function this.OnApplicationFocus()
    
end

function this.WhoShow(data)
	playRuleInfos={};
	for i=1,#data.plays do
		table.insert(playRuleInfos,i,data.plays[i]);
    end
    print('panelClub.clubInfo.displayCurrentPlay : '..tostring(panelClub.clubInfo.displayCurrentPlay)..' panelClub.clubInfo.displayAllPlay :'..tostring(panelClub.clubInfo.displayAllPlay))
    ToggleOnlyPlay:GetComponent('UIToggle'):Set(panelClub.clubInfo.displayCurrentPlay)
    ToggleHidePlay:GetComponent('UIToggle'):Set(panelClub.clubInfo.displayAllPlay)
    smallWinerInput.parent.gameObject:SetActive(panelClub.clubInfo.gameMode)
    this.Refresh()
end

function this.shuaXinList(data)
    playRuleInfos={};
	for i=1,#data.plays do
		table.insert(playRuleInfos,i,data.plays[i]);
    end
    this.Refresh()
end

function this.OnEnable()
    --this.Refresh()
    
    ScrollView:GetComponent('UIScrollView'):ResetPosition()
end

function this.OnDisable()
    PlayRules={}
	playRuleInfos={}
    Util.ClearChild(Tabel)
end

--关闭按钮--
function this.OnClickMask(go)
	AudioManager.Instance:PlayAudio('btn');
    PanelManager.Instance:HideWindow(gameObject.name)
    if #panelClub.clubInfo.plays ~= 0 and (not IsGuideCompleted())  then
        panelClub.ShowClubGuide()
    end
	local msg = Message.New()
    msg.type = proxy_pb.UPDATE_CLUB_USER_DISPLAY_PLAY
    local body = proxy_pb.PUpdateUserDisplayPlay()
    body.clubId = panelClub.clubInfo.clubId
    body.displayCurrentPlay = ToggleOnlyPlay:GetComponent("UIToggle").value
    body.displayAllPlay = ToggleHidePlay:GetComponent("UIToggle").value
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, nil)
end

--刷新整个玩法
function this.Refresh()
    PanelManager.Instance:HideWindow('panelNetWaitting')
    gameObject.transform:Find('Top/OneScoreFee').gameObject:SetActive(panelClub.clubInfo.gameMode)
    for i = #PlayRules, 1, -1 do
        local exist = false
        for j = 1, #panelClub.clubInfo.plays do
            if PlayRules[i].playId == panelClub.clubInfo.plays[j].playId then
                exist = true
                break
            end
        end
        if not exist then
            PlayRules[i].obj.gameObject:SetActive(false)
            UnityEngine.Object.Destroy(PlayRules[i].obj.gameObject)
            table.remove(PlayRules, i)
        end
    end

    ButtonNew.gameObject:SetActive(IsCanSetPlay())

    local isTourist = panelClub.clubInfo.userType==proxy_pb.GENERAL

    if #panelClub.clubInfo.plays == 0 then
        tip:GetComponent('UILabel').text='当前还没有玩法'
        tip.gameObject:SetActive(not IsCanSetPlay())
        gameObject.transform:Find('NoPlays').gameObject:SetActive(IsCanSetPlay())
    else
        tip.gameObject:SetActive(false)
        gameObject.transform:Find('NoPlays').gameObject:SetActive(false)
        local startIndex = panelClub.clubInfo.lobby and 2 or 1 
        for i=startIndex,#panelClub.clubInfo.plays do
            local fristOne = (i == startIndex)
            local data = this.GetData(PlayRules, panelClub.clubInfo.plays[i].playId)
            local playObj = nil
            if data ~= nil then
                playObj = data.obj
            else
                playObj = this.InstantiatePlayItem();
                table.insert(PlayRules,{obj = playObj, playId = panelClub.clubInfo.plays[i].playId})
            end

            playObj.gameObject:SetActive(true)
            SetUserData(playObj, panelClub.clubInfo.plays[i])

            for j=1 , #playRuleInfos do
                if playRuleInfos[j].playId == panelClub.clubInfo.plays[i].playId then
                    this.SetPlayRuleInfo(playObj, playRuleInfos[j],fristOne);
                end
            end

            playObj.transform:SetSiblingIndex(i)

            if playObj.transform:Find('Rules').gameObject.activeSelf then
                local msg = Message.New()
                msg.type = proxy_pb.PLAY_RULE_LIST;
                local body=proxy_pb.PPlayRuleList()
                body.clubId = panelClub.clubInfo.clubId
                body.playId = panelClub.clubInfo.plays[i].playId
                msg.body = body:SerializeToString()
                SendProxyMessage(msg, this.GetPlayRuleList);
            end
        end
    end

    if panelClub.CurClubIsNewCreate() and #panelClub.clubInfo.plays > 1 then
        PanelManager.Instance:ShowWindow('panelGuide', 'Play')
    end

    Tabel:GetComponent('UITable'):Reposition()
end

function this.InstantiatePlayItem()
    local obj = NGUITools.AddChild(Tabel.gameObject, prefabItem.gameObject)
    local buttonMore = obj.transform:Find('ButtonMore')
    local ButtonAdd = obj.transform:Find('ButtonAdd')
    local moveUpButton = obj.transform:Find('MoveupButton')
    message:AddClick(ButtonAdd.gameObject, this.OnClickAddRule)
    message:AddClick(buttonMore.gameObject, function (go)
        AudioManager.Instance:PlayAudio('btn')
        this.ShowEditPanel(GetUserData(go.transform.parent.gameObject))
    end)
    message:AddClick(obj.transform:Find('ruleSize').gameObject, function (go)
        AudioManager.Instance:PlayAudio('btn')
        if not IsCanSetPlay() then
            return 
        end
        this.ShowEditPanel(GetUserData(go.transform.parent.gameObject))
    end)
    message:AddClick(obj, this.OnClickPlay)
    message:AddClick(moveUpButton.gameObject, this.OnClickMoveupPlay)

    return obj
end

function this.SetPlayRuleInfo(obj, play, fristOne)
	if obj ~= nil then
		obj.transform:Find('name'):GetComponent('UILabel').text = play.name
		obj.transform:Find('ruleSize'):GetComponent('UILabel').text = play.size
		obj.transform:Find('winnerScore'):GetComponent('UILabel').text = play.lowScore
		obj.transform:Find('fee'):GetComponent('UILabel').text = play.lowFee

		local canSetPlay = IsCanSetPlay()
		local buttonMore = obj.transform:Find('ButtonMore');
        local ButtonAdd = obj.transform:Find('ButtonAdd')
        local moveUpButton = obj.transform:Find('MoveupButton')
		buttonMore.gameObject:SetActive(canSetPlay)
        ButtonAdd.gameObject:SetActive(canSetPlay)
        moveUpButton.gameObject:SetActive(false)
        moveUpButton.gameObject:SetActive(canSetPlay and (not fristOne))

		obj.transform:Find('oneScoreFee').gameObject:SetActive(panelClub.clubInfo.gameMode)
		obj.transform:Find('oneScoreFee'):GetComponent('UILabel').text = play.oneScoreFee
	end
end

--点击单个玩法
local selctPlay
function this.OnClickPlay(go)
    AudioManager.Instance:PlayAudio('btn')
    local isOpened = go.transform:Find('Rules').gameObject.activeSelf

    if isOpened then
        print("关闭")
        this.hideRuleListView(go)
        selctPlay = nil
    else
        print("打开")
        local msg = Message.New()
        msg.type = proxy_pb.PLAY_RULE_LIST;
        local body=proxy_pb.PPlayRuleList()
        body.clubId = panelClub.clubInfo.clubId
        body.playId = GetUserData(go.gameObject).playId
        msg.body = body:SerializeToString()
        --print("开始查询规则id："..body.playId..'是否有更新');
        SendProxyMessage(msg, this.GetPlayRuleList);
        selctPlay = body.playId
    end
end


--获取每一个玩法的规则
function this.GetPlayRuleList(msg)
    local data = proxy_pb.RPlayRuleList()
    data:ParseFromString(msg.body);
    if data.rules ~= nil and #data.rules ~= 0 then
        this.showRuleListView(data.playId, data.rules)
    else
		panelMessageTip.SetParamers('规则为空', 1.5)
    end
end

function this.showRuleListView(playId, rules)
    local go = this.GetData(PlayRules, playId).obj;
    this.hideRuleListView(go)
    local ruleGrid = go.transform:Find('Rules/Grid');
    local itemPrefab = gameObject.transform:Find('rule');
    for i = 1, #rules do
        local obj       = NGUITools.AddChild(ruleGrid.gameObject, itemPrefab.gameObject);
        local data      = {};
        data.playId     = GetUserData(go).playId;
        data.name       = GetUserData(go).name;
        data.ruleId     = rules[i].ruleId;
        data.settings   = rules[i].settings;
        data.clubId   = panelClub.clubInfo.clubId;
        data.roomType = GetUserData(go).roomType
        SetUserData(obj, data);

        local clubPlay = GetUserData(ruleGrid.parent.parent.gameObject);
        
        --local Index = (#rules - (i - 1));
        obj.transform:Find('paly'):GetComponent('UILabel').text = "规则 "..i
        print('rules[i].settings : '..GetUserData(go).roomType)
        local ruleSettings = json:decode(rules[i].settings)
        if GetUserData(go).roomType == proxy_pb.PKDTZ then
            obj.transform:Find('num'):GetComponent('UILabel').text = "钻石："..GetPayMun(GetUserData(go).roomType,nil,nil,ruleSettings.scoreSelect)
        elseif GetUserData(go).roomType == proxy_pb.SYBP then
            obj.transform:Find('num'):GetComponent('UILabel').text = "钻石："..GetPayMun(GetUserData(go).roomType,nil,ruleSettings.size,nil)
        else
            obj.transform:Find('num'):GetComponent('UILabel').text = "钻石："..GetPayMun(GetUserData(go).roomType,ruleSettings.rounds,nil,nil)
        end
       
        if clubPlay.gameType== proxy_pb.PHZ then 
            obj.transform:Find('paly'):Find('Label'):GetComponent('UILabel').text = getWanFaText(ruleSettings,true,false, false);
        elseif clubPlay.gameType == proxy_pb.PDK then 
            obj.transform:Find('paly'):Find('Label'):GetComponent('UILabel').text = getWanFaText_pdk(ruleSettings,true,false);
        elseif clubPlay.gameType == proxy_pb.XHZD then 
            obj.transform:Find('paly'):Find('Label'):GetComponent('UILabel').text = getXHZDRuleString(ruleSettings,false,false);
        elseif clubPlay.gameType == proxy_pb.MJ then 
            ruleSettings.roomTypeValue = ruleSettings.roomType
            obj.transform:Find('paly'):Find('Label'):GetComponent('UILabel').text = GetMJRuleText(ruleSettings,false)
        elseif clubPlay.gameType == proxy_pb.DTZ then
            obj.transform:Find('paly'):Find('Label'):GetComponent('UILabel').text = GetDTZRuleString(ruleSettings,false,false);
        elseif clubPlay.gameType == proxy_pb.BBTZ then
            obj.transform:Find('paly'):Find('Label'):GetComponent('UILabel').text = GetBBTZRuleString(json:decode(rules[i].settings),false,false);
        elseif clubPlay.gameType == proxy_pb.XPLP then 
            obj.transform:Find('paly'):Find('Label'):GetComponent('UILabel').text = GetXPLPRuleText(json:decode(rules[i].settings),false,false);
        elseif clubPlay.gameType == proxy_pb.HNM and clubPlay.roomType == proxy_pb.HNHSM then 
            obj.transform:Find('paly'):Find('Label'):GetComponent('UILabel').text = GetHNHSMRuleText(json:decode(rules[i].settings),false,false);
        elseif clubPlay.gameType == proxy_pb.HNM and clubPlay.roomType == proxy_pb.HNZZM then 
            obj.transform:Find('paly'):Find('Label'):GetComponent('UILabel').text = GetHNZZMRuleText(json:decode(rules[i].settings),false,false);
        elseif clubPlay.gameType == proxy_pb.YJQF then 
            obj.transform:Find('paly'):Find('Label'):GetComponent('UILabel').text = getYJQFRuleString(json:decode(rules[i].settings));
        elseif clubPlay.gameType == proxy_pb.DZM and clubPlay.roomType == proxy_pb.DZAHM then 
            obj.transform:Find('paly'):Find('Label'):GetComponent('UILabel').text = GetDZAHMRuleText(json:decode(rules[i].settings),false,false);
        end
        message:AddClick(obj.transform:Find('ButtonModify').gameObject, this.OnClickModify)
        message:AddClick(obj.transform:Find('ButtonDelet').gameObject, this.OnClickDeletRule)
        local canSetPlay = IsCanSetPlay()
        obj.transform:Find('ButtonModify').gameObject:SetActive(canSetPlay)
        obj.transform:Find('ButtonDelet').gameObject:SetActive(canSetPlay)

        obj.transform:Find('Background').gameObject:SetActive(i ~= #rules);
        obj.gameObject:SetActive(true)
    end

    --Tabel.repositionNow = true

    ruleGrid.parent.gameObject:SetActive(true)
    ruleGrid:GetComponent('UIGrid'):Reposition()

    local newHight = ruleGrid:GetComponent('UIGrid').cellHeight * #rules + 15;
    local curHight = go.transform:GetComponent('UIWidget').height;
    go.transform:GetComponent('UIWidget').height = curHight + newHight;
    go.transform:Find('Background'):GetComponent('UISprite').height = curHight + newHight;
    ruleGrid.parent.transform:GetComponent('UIWidget').height = newHight;

    Tabel:GetComponent('UITable'):Reposition()
end

function this.hideRuleListView(go)
    local rules = go.transform:Find('Rules/Grid')
    rules.parent.gameObject:SetActive(false)
    Util.ClearChild(rules)
    go.transform:GetComponent('UIWidget').height = 110;
    go.transform:Find('Background'):GetComponent('UISprite').height = 110;
    Tabel:GetComponent('UITable'):Reposition()
end

--删除返回
function this.OnDeleteClubPlayResult(msg)
    local b = proxy_pb.RResult()
	b:ParseFromString(msg.body)
    if b.code == 1 then
        panelMessageTip.SetParamers('删除成功', 1.5)
	    PanelManager.Instance:ShowWindow('panelMessageTip');
		this.PlayRuleInfos()
	else
		panelMessageTip.SetParamers(b.msg, 1.5)
    end
end

--删除规则
function this.OnClickDeletRule(go)
    AudioManager.Instance:PlayAudio('btn')
    local msg = Message.New()
	msg.type = proxy_pb.DELETE_PLAY_RULE
    local body = proxy_pb.PDeletePlayRule();
    local data = GetUserData(go.transform.parent.gameObject)
    body.ruleId = data.ruleId;
	
    body.playId =data.playId;
	body.clubId =data.clubId;
    msg.body = body:SerializeToString();
    
    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
        SendProxyMessage(msg, this.OnDeleteClubPlayResult)
    end, nil, "是否移除该规则")
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi');
end

function this.OnClickAddRule(go)
    AudioManager.Instance:PlayAudio('btn')
    local play = GetUserData(go.transform.parent.gameObject);

    local data = {}
    data.optionData = {};
    data.optionData.addPlay = false;
    data.optionData.addRule = true;
    data.playId = play.playId;
    data.name = play.name;
	data.roomType = play.roomType;
    data.clubId = panelClub.clubInfo.clubId
    if play.gameType == proxy_pb.PDK then 
        PanelManager.Instance:ShowWindow("panelCreatePDKSet",data);
    elseif play.gameType == proxy_pb.MJ then 
        PanelManager.Instance:ShowWindow("panelCreateMJSet",data);
    elseif play.gameType == proxy_pb.PHZ then
        PanelManager.Instance:ShowWindow('panelSetModify', data);
    elseif play.gameType == proxy_pb.XHZD then
        PanelManager.Instance:ShowWindow('panelCreateXHZDSet', data);
    elseif play.gameType == proxy_pb.DTZ then 
        PanelManager.Instance:ShowWindow("panelCreateDTZSet",data);
    elseif play.gameType == proxy_pb.BBTZ then
        PanelManager.Instance:ShowWindow("panelCreateBBTZSet",data);
    elseif play.gameType == proxy_pb.XPLP then 
        PanelManager.Instance:ShowWindow("panelCreateXPLPSet",data);
    elseif play.gameType == proxy_pb.HNM and play.roomType == proxy_pb.HNHSM then 
        PanelManager.Instance:ShowWindow("panelCreateHNHSMSet",data);
    elseif play.gameType == proxy_pb.HNM and play.roomType == proxy_pb.HNZZM then 
        PanelManager.Instance:ShowWindow("panelCreateHNZZMSet",data);
    elseif play.gameType == proxy_pb.YJQF then 
        PanelManager.Instance:ShowWindow("panelCreateYJQFSet",data)
    elseif play.gameType == proxy_pb.DZM and play.roomType == proxy_pb.DZAHM then 
        PanelManager.Instance:ShowWindow("panelCreateDZAHMSet",data);
    end
end

function this.OnClickSelect(go)
    AudioManager.Instance:PlayAudio('btn')
    panelClub.shuaXinPlays(panelClub.clubInfo.clubId, GetUserData(go.transform.parent.gameObject).playId)
end

function this.OnClickModify(go)
    AudioManager.Instance:PlayAudio('btn')
    local rule = GetUserData(go.transform.parent.gameObject);

    local data      = {};
    data.playId     = rule.playId;
    data.ruleId     = rule.ruleId;
    data.name       = rule.name;
    data.settings   = rule.settings;
    data.roomType   = rule.roomType
    --print("playId:"..data.playId);
    data.play       = GetUserData(go.transform.parent.parent.parent.parent.gameObject);
    --print("data.play.gameType:"..data.play.gameType);
    data.clubInfo = panelClub.clubInfo;
    data.optionData = {};
    data.optionData.addPlay = false;
    data.optionData.addRule = false;
    if data.play.gameType == proxy_pb.PDK then 
        PanelManager.Instance:ShowWindow("panelCreatePDKSet",data);
    elseif data.play.gameType == proxy_pb.MJ then 
        PanelManager.Instance:ShowWindow("panelCreateMJSet",data);
    elseif data.play.gameType == proxy_pb.PHZ then 
        PanelManager.Instance:ShowWindow('panelSetModify', data);
    elseif data.play.gameType == proxy_pb.XHZD then
        PanelManager.Instance:ShowWindow("panelCreateXHZDSet",data);
    elseif data.play.gameType == proxy_pb.DTZ then
        PanelManager.Instance:ShowWindow("panelCreateDTZSet",data);
    elseif data.play.gameType == proxy_pb.BBTZ then
        PanelManager.Instance:ShowWindow("panelCreateBBTZSet",data);
    elseif data.play.gameType == proxy_pb.XPLP then 
        PanelManager.Instance:ShowWindow("panelCreateXPLPSet",data);
    elseif data.play.gameType == proxy_pb.HNM and data.play.roomType == proxy_pb.HNHSM then 
        PanelManager.Instance:ShowWindow("panelCreateHNHSMSet",data)
    elseif data.play.gameType == proxy_pb.HNM and data.play.roomType == proxy_pb.HNZZM then 
        PanelManager.Instance:ShowWindow("panelCreateHNZZMSet",data)
    elseif data.play.gameType == proxy_pb.YJQF then 
        PanelManager.Instance:ShowWindow("panelCreateYJQFSet",data)
    elseif data.play.gameType == proxy_pb.DZM and data.play.roomType == proxy_pb.DZAHM then 
        PanelManager.Instance:ShowWindow("panelCreateDZAHMSet",data)
    end
    
end

function this.GetData(plays, playId)
    for i=1,#plays do
        if plays[i].playId == playId then
            return plays[i]
        end
    end
end


function this.ShowEditPanel(playData)
	this.PClubPlayInfo(playData.playId)
end
function this.PClubPlayInfo(playId)
	local msg = Message.New()
    msg.type = proxy_pb.CLUB_PLAY_INFO
    local body = proxy_pb.PClubPlayInfo();
    body.playId = playId;
    msg.body = body:SerializeToString();
    SendProxyMessage(msg, this.RClubPlayInfo)
end

function this.RClubPlayInfo(msg)
    local playData = proxy_pb.RClubPlayInfo();
    playData:ParseFromString(msg.body);
	curEditPlay = playData
    NameInput.transform:GetComponent('UIInput').value = ''
    NameInput.transform:GetComponent('UIInput').defaultText = playData.name
    WinPlayInput.transform:GetComponent('UIInput').value = ''
    WinPlayInput.transform:GetComponent('UIInput').defaultText= playData.lowScore
    FFInput.transform:GetComponent('UIInput').value = ''
    FFInput.transform:GetComponent('UIInput').defaultText = playData.lowFee

    smallWinerInput:GetComponent('UIInput').value = ''
    smallWinerInput:GetComponent('UIInput').defaultText = playData.minScore
    smallWinerFeeInput:GetComponent('UIInput').value = ''
    smallWinerFeeInput:GetComponent('UIInput').defaultText = playData.minFee
    print('playData.aaPayment :'..tostring(playData.aaPayment))
    ToggleAAPay:GetComponent('UIToggle'):Set(playData.aaPayment)

    EnterMinFeeInput.gameObject:SetActive(panelClub.clubInfo.gameMode)
    EnterMinFeeInput.transform:GetComponent('UIInput').value = ''
    EnterMinFeeInput.transform:GetComponent('UIInput').defaultText = playData.enterMinFee

    OneScoreFeeInput.gameObject:SetActive(panelClub.clubInfo.gameMode)
    OneScoreFeeInput.transform:GetComponent('UIInput').value = ''
    OneScoreFeeInput.transform:GetComponent('UIInput').defaultText = string.format('%.2f', playData.oneScoreFee) 

    AutoDissolveInput.gameObject:SetActive(panelClub.clubInfo.gameMode)
    AutoDissolveInput.transform:GetComponent('UIInput').value = ''
    AutoDissolveInput.transform:GetComponent('UIInput').defaultText = playData.dissolveFee
    AutoDissolveToggle.transform:GetComponent('UIToggle'):Set(playData.autoDissolve)

    print('是否开启自动解散：'..tostring(playData.autoDissolve))
    print('自动结束最低分值：'..tostring(playData.dissolveFee))

    AllowXiPaiInput.gameObject:SetActive(panelClub.clubInfo.gameMode)
    AllowXiPaiInput.transform:GetComponent('UIInput').value = ''
    AllowXiPaiInput.transform:GetComponent('UIInput').defaultText = playData.shuffleFee
    AllowXiPaiToggle.transform:GetComponent('UIToggle'):Set(playData.openShuffle)
    
    print('是否开启每小局洗牌：'..tostring(playData.autoDissolve))
    print('每小局洗牌分值：'..tostring(playData.dissolveFee))

    EditPanel.gameObject:SetActive(true)
    InputCollection.transform:GetComponent('UIGrid').repositionNow = true
    InputCollection.transform:GetComponent('UIGrid'):Reposition()
end

function this.OnClickUpdatePlay(go)
    AudioManager.Instance:PlayAudio('btn')
    local msg = Message.New()
    msg.type = proxy_pb.UPDATE_CLUB_PLAY
    local body=proxy_pb.PUpdateClubPlay()
    body.clubId = panelClub.clubInfo.clubId
    body.playId = curEditPlay.playId
    body.playName = NameInput.transform:GetComponent('UILabel').text
    body.lowScore = tonumber(WinPlayInput.transform:GetComponent('UILabel').text) 
    body.lowFee = tonumber(FFInput.transform:GetComponent('UILabel').text)
    local minWinerFee = tonumber(smallWinerFeeInput.transform:GetComponent('UILabel').text)
    local minWiner = tonumber(smallWinerInput.transform:GetComponent('UILabel').text) 
    if panelClub.clubInfo.gameMode then
        body.enterMinFee = tonumber(EnterMinFeeInput.transform:GetComponent('UILabel').text) 
        body.oneScoreFee = tonumber(OneScoreFeeInput.transform:GetComponent('UILabel').text) 
        body.dissolveFee = tonumber(AutoDissolveInput.transform:GetComponent('UILabel').text)
        body.autoDissolve = AutoDissolveToggle.transform:GetComponent('UIToggle').value
        body.openShuffle = AllowXiPaiToggle.transform:GetComponent('UIToggle').value
        body.shuffleFee = keepTwoDecimalPlaces(tonumber(AllowXiPaiInput.transform:GetComponent('UILabel').text))
        if body.lowScore <= minWiner then
            panelMessageTip.SetParamers('大赢家最低分的值不能小于等于最小大赢家的值', 2)
            PanelManager.Instance:ShowWindow('panelMessageTip')
            return 
        elseif body.lowScore < 0 or body.lowScore > 9999 then
            panelMessageTip.SetParamers('请输入1~9999之间的数值', 2)
            PanelManager.Instance:ShowWindow('panelMessageTip')
            return 
        end
        if body.shuffleFee>1 then
            panelMessageTip.SetParamers('每小局洗牌数值不能大于1', 2)
            PanelManager.Instance:ShowWindow('panelMessageTip')
            return
        elseif body.shuffleFee<0 then
            panelMessageTip.SetParamers('每小局洗牌数值不能小于0', 2)
            PanelManager.Instance:ShowWindow('panelMessageTip')
            return
        end
        if minWiner < 0 or minWiner > 9999 then
            panelMessageTip.SetParamers('请输入0~9999之间的数值', 2)
            PanelManager.Instance:ShowWindow('panelMessageTip')
            return 
        end
        if minWinerFee < 0 or minWinerFee > 1 then
            panelMessageTip.SetParamers('请输入0.0~1.0之间的数值', 2)
            PanelManager.Instance:ShowWindow('panelMessageTip')
            return 
        end
    end
    body.minScore = minWiner
    body.minFee = minWinerFee
    body.aaPayment = ToggleAAPay:GetComponent('UIToggle').value
    print('body.aaPayment :'..tostring(body.aaPayment))
    msg.body = body:SerializeToString()
    print('玩法名字：'..tostring(NameInput.transform:GetComponent('UILabel').text))
    SendProxyMessage(msg, this.UpdateClubPlayResult)
end

function this.OnInputChangeWinDeductFee()
    LimitInputFloat(smallWinerFeeInput:GetComponent('UIInput'),1)
end
function this.OnClickMoveupPlay(go)
    AudioManager.Instance:PlayAudio('btn')
    local playInfo = GetUserData(go.transform.parent.gameObject)
    local msg = Message.New()
    msg.type = proxy_pb.UPDATE_PLAY_SORT
    local body = proxy_pb.PUpdatePlaySort()
    body.playId = playInfo.playId;
    msg.body = body:SerializeToString();

    SendProxyMessage(msg, function (msg)
        panelMessageTip.SetParamers('更新成功。', 2)
        PanelManager.Instance:ShowWindow('panelMessageTip')
        PanelManager.Instance:ShowWindow('panelNetWaitting')
        panelClub.shuaXinPlays(panelClub.clubInfo.clubId,panelClub.clubInfo.playId);
    end)
end

function this.UpdateClubPlayResult(msg)
    local b = proxy_pb.RResult()
    b:ParseFromString(msg.body)
    if b.code == 1 then
        EditPanel.gameObject:SetActive(false)
        panelMessageTip.SetParamers('更新成功。', 2)
        PanelManager.Instance:ShowWindow('panelMessageTip')
		this.PlayRuleInfos()
    end
end

function this.PlayRuleInfos()
	local msg = Message.New()
	msg.type = proxy_pb.CLUB_PLAY_LIST;
	local body=proxy_pb.PClubPlaySetting()
	body.clubId = panelClub.clubInfo.clubId
	msg.body = body:SerializeToString()
	SendProxyMessage(msg, function (msg)
		local data = proxy_pb.RClubPlayList()
		data:ParseFromString(msg.body)
		playRuleInfos={};
		for i=1,#data.plays do
			table.insert(playRuleInfos,i,data.plays[i]);
        end
        
        this.Refresh();
	end);
end

function this.GetOnePlayRules()
    return PlayRules[1].obj.transform:Find('ruleSize');
end

local curr_value
function this.OnInputChangeNameInput()
    AudioManager.Instance:PlayAudio('btn')
    local str = NameInput:GetComponent('UIInput').value
    if charachterIsLimit(str, 14) then
        NameInput:GetComponent('UIInput').value = curr_value
		return
    end
    curr_value = NameInput:GetComponent('UIInput').value
end