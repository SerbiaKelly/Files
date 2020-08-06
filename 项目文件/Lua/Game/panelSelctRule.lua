panelSelctRule = {}
local this = panelSelctRule
local json = require 'json'

local Grid

local message
local gameObject
function this.Awake(go)
    gameObject = go
    message = gameObject:GetComponent('LuaBehaviour');

    Grid = gameObject.transform:Find('Rules/Scroll View')

    message:AddClick(gameObject.transform:Find('BaseContent/ButtonClose').gameObject, function (go)
        PanelManager.Instance:HideWindow(gameObject.name)
    end)
end

function this.Update()
   
end
function this.Start()

end

local needSelcted = false
function this.WhoShow(data)
    needSelcted = data.needSelcted
    Util.ClearChild(Grid)

    gameObject.transform:Find('tip').gameObject:SetActive(true);
    if panelClub.playInfo.playId ~= nil then
        local msg = Message.New()
        msg.type = proxy_pb.PLAY_RULE_LIST;
        local body=proxy_pb.PPlayRuleList()
        body.playId = panelClub.clubInfo.playId
        body.clubId = panelClub.clubInfo.clubId
        --print("查看的玩法ID："..tostring(body.playId))
        msg.body = body:SerializeToString()
        SendProxyMessage(msg, function (msg)
            gameObject.transform:Find('tip').gameObject:SetActive(false)
            local data = proxy_pb.RPlayRuleList()
            data:ParseFromString(msg.body)
            this.Show(data.rules)
        end);
    else
        gameObject.transform:Find('tip').gameObject:SetActive(true) 
    end
end

local curSelRuleSettings;
function this.Show(rules)
    local itemPrefab = gameObject.transform:Find('item')
    for i=1, #rules do
        while true do
            local playInfo = panelClub.GetGameTyeByPlay(rules[i].playId)
            if not playInfo then
                break
            end
            local obj = NGUITools.AddChild(Grid.gameObject, itemPrefab.gameObject)
            SetUserData(obj, rules[i]);
            local ruleSetting= json:decode(rules[i].settings);
            obj.transform:Find("name"):GetComponent('UILabel').text = playInfo.name;
            local gameType = playInfo.gameType;
            local roomType = playInfo.roomType;
            if gameType == proxy_pb.PHZ then 
                    obj.transform:Find('play'):GetComponent('UILabel').text = getWanFaText(json:decode(rules[i].settings),true, false, false);
            elseif gameType == proxy_pb.PDK then 
                if json:decode(rules[i].settings) == nil then 
                    obj.transform:Find('play'):GetComponent('UILabel').text = "网络有点小问题，退出刷新重进";
                    return;
                end
                obj.transform:Find('play'):GetComponent('UILabel').text = getWanFaText_pdk(json:decode(rules[i].settings),false,false);
            elseif gameType == proxy_pb.MJ then 
                if json:decode(rules[i].settings) == nil then 
                    obj.transform:Find('play'):GetComponent('UILabel').text = "网络有点小问题，退出刷新重进";
                    return;
                end
                obj.transform:Find('play'):GetComponent('UILabel').text = GetMJRuleText(json:decode(rules[i].settings),false);
            elseif gameType == proxy_pb.XHZD then 
                if json:decode(rules[i].settings) == nil then 
                    obj.transform:Find('play'):GetComponent('UILabel').text = "网络有点小问题，退出刷新重进";
                    return;
                end
                obj.transform:Find('play'):GetComponent('UILabel').text = getXHZDRuleString(json:decode(rules[i].settings),false);
            elseif gameType == proxy_pb.DTZ then

                if json:decode(rules[i].settings) == nil then 
                    obj.transform:Find('play'):GetComponent('UILabel').text = "网络有点小问题，退出刷新重进";
                    return;
                end
                obj.transform:Find('play'):GetComponent('UILabel').text = GetDTZRuleString(json:decode(rules[i].settings),false);
            elseif gameType == proxy_pb.BBTZ then 
                if json:decode(rules[i].settings) == nil then 
                    obj.transform:Find('play'):GetComponent('UILabel').text = "网络有点小问题，退出刷新重进";
                    return;
                end
                obj.transform:Find('play'):GetComponent('UILabel').text = GetBBTZRuleString(json:decode(rules[i].settings),false);
            elseif gameType == proxy_pb.XPLP then 
                if json:decode(rules[i].settings) == nil then 
                    obj.transform:Find('play'):GetComponent('UILabel').text = "网络有点小问题，退出刷新重进";
                    return;
                end
                obj.transform:Find('play'):GetComponent('UILabel').text = GetXPLPRuleText(json:decode(rules[i].settings),false);
            elseif gameType == proxy_pb.HNM and roomType == proxy_pb.HNHSM then 
                if json:decode(rules[i].settings) == nil then 
                    obj.transform:Find('play'):GetComponent('UILabel').text = "网络有点小问题，退出刷新重进";
                    return;
                end
                obj.transform:Find('play'):GetComponent('UILabel').text = GetHNHSMRuleText(json:decode(rules[i].settings),false);
            elseif gameType == proxy_pb.HNM and roomType == proxy_pb.HNZZM then 
                if json:decode(rules[i].settings) == nil then 
                    obj.transform:Find('play'):GetComponent('UILabel').text = "网络有点小问题，退出刷新重进";
                    return;
                end
                obj.transform:Find('play'):GetComponent('UILabel').text = GetHNZZMRuleText(json:decode(rules[i].settings),false);
            elseif gameType == proxy_pb.YJQF then 
                if json:decode(rules[i].settings) == nil then 
                    obj.transform:Find('play'):GetComponent('UILabel').text = "网络有点小问题，退出刷新重进";
                    return;
                end
                obj.transform:Find('play'):GetComponent('UILabel').text = getYJQFRuleString(json:decode(rules[i].settings))
            end
            
            local ButtonCreatePulish = obj.transform:Find('ButtonCreatePulish')
            local ButtonCreatePrivate = obj.transform:Find('ButtonCreatePrivate')

            if needSelcted then
                ButtonCreatePulish.gameObject:SetActive(false)
                ButtonCreatePrivate.gameObject:SetActive(false)
                if rules[i].choiced then
                    obj.transform:Find('ButtonSelect'):GetComponent('BoxCollider').enabled = false
                    obj.transform:Find('ButtonSelect'):Find('Label'):GetComponent('UILabel').text = '已选'
                else
                    message:AddClick(obj.transform:Find('ButtonSelect').gameObject, this.OnClickSelct)
                end
            else
                obj.transform:Find('ButtonSelect').gameObject:SetActive(false)
                message:AddClick(ButtonCreatePulish.gameObject, this.OnClickCreatePulish)
                ButtonCreatePulish.gameObject:SetActive(panelClub.clubInfo.publicRoom)
                message:AddClick(ButtonCreatePrivate.gameObject, this.OnClickCreatePrivate)
                ButtonCreatePrivate.gameObject:SetActive(panelClub.clubInfo.privateRoom)
            end
            obj.gameObject:SetActive(true)
            break
        end
    end

    Grid:GetComponent('UIGrid').repositionNow = true
    Grid:GetComponent('UIGrid'):Reposition()
    Grid.transform:GetComponent('UIScrollView'):ResetPosition()
end


function this.OnClickSelct(go)
    local msg   = Message.New()
    msg.type    = proxy_pb.SELECT_PLAY_RULE;
    local rule  = GetUserData(go.transform.parent.gameObject)
    local body  = proxy_pb.PSelectPlayRule()
    body.playId = panelClub.clubInfo.playId
    body.ruleId = rule.ruleId
    msg.body    = body:SerializeToString()
    SendProxyMessage(msg, function (msg)
        local b = proxy_pb.RResult()
        b:ParseFromString(msg.body)
        if b.code == 1 then
            print('选择的规则ID：'..body.ruleId)
            panelClub.RefreshPlayText(rule)
            panelMessageTip.SetParamers('选择成功', 1.5)
            PanelManager.Instance:HideWindow(gameObject.name)
            PanelManager.Instance:ShowWindow('panelMessageTip')
            panelClub.clubInfo.ruleInfo = rule
            panelClub.shuaXinClub()
        end
    end);
end

function this.OnClickCreatePulish(go)
    local data = GetUserData(go.transform.parent.gameObject)
    panelClub.CreateRoom(data, true)
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickCreatePrivate(go)  
    local data = GetUserData(go.transform.parent.gameObject)
    panelClub.CreateRoom(data, false)
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnEnable()
end