panelChat = {}
local this = panelChat;

local message;
local gameObject;
local ButtonSend
local mask
local words = {}
local icons = {}
local ButtonClose
local input
local chatList

--启动事件--
function this.Awake(obj)
    gameObject = obj;

    mask = gameObject.transform:Find('mask');
    input = gameObject.transform:Find('window_chat/input');
	chatList = gameObject.transform:Find('window_chat/ChatArea');
    ButtonClose = gameObject.transform:Find('ButtonClose');
    ButtonSend = gameObject.transform:Find('window_chat/ButtonSend')
    message = gameObject:GetComponent('LuaBehaviour');
    message:AddClick(mask.gameObject, this.OnClickMask);
    message:AddClick(ButtonClose.gameObject,this.OnClickClose);
    message:AddClick(ButtonSend.gameObject,this.OnClickSend);

    for i = 1, 12 do
        words[i] = gameObject.transform:Find('window_common/word/word' .. i);
        icons[i] = gameObject.transform:Find('window_emoji/icon/icon' .. i);
        message:AddClick(words[i].gameObject, this.OnClickWord);
        message:AddClick(icons[i].gameObject, this.OnClickIcon);
    end

	EventDelegate.AddForLua(input:GetComponent('UIInput').onSubmit, this.OnInputSubmit)
end
function this.Update()
   
end
function this.Start()
	
end

function this.OnEnable()
	if panelInGame and panelInGame.chatTexts ~= nil and #panelInGame.chatTexts > 0 then
		for i=1,#panelInGame.chatTexts do
			this.AddChatToLabel(panelInGame.chatTexts[i])
		end
		panelInGame.chatTexts = {}
	end
end

--单击事件--
function this.OnClickMask(go)
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickWord(go)
    if panelInGame == panelInGame_pdk  then
        local msg = Message.New()
        msg.type = pdk_pb.SEND_CHAT
        local body = pdk_pb.PChat()
        body.type = pdk_pb.CHOOSE
        local str = string.gsub(go.name, 'word', '', 1)
        body.position = tonumber(str)
        body.text = go:GetComponent("UILabel").text
        msg.body = body:SerializeToString();
        SendGameMessage(msg, nil)
    elseif panelInGame == panelInGameLand then
        local msg = Message.New()
        msg.type = phz_pb.SEND_CHAT
        local body = phz_pb.PChat()
        body.type = phz_pb.CHOOSE
        local str = string.gsub(go.name, 'word', '', 1)
        body.position = tonumber(str)
        body.text = go:GetComponent("UILabel").text
        msg.body = body:SerializeToString();
        SendGameMessage(msg, nil)
    elseif panelInGame == panelInGamemj then
        local msg = Message.New()
        msg.type = csm_pb.SEND_CHAT
        local body = csm_pb.PChat()
        body.type = csm_pb.CHOOSE
        local str = string.gsub(go.name, 'word', '', 1)
        body.position = tonumber(str)
        body.text = go:GetComponent("UILabel").text
        msg.body = body:SerializeToString();
        SendGameMessage(msg, nil)
    elseif panelInGame == panelInGame_xhzd then
        local msg = Message.New()
        msg.type = xhzd_pb.SEND_CHAT
        local body = xhzd_pb.PChat()
        body.type = xhzd_pb.CHOOSE
        local str = string.gsub(go.name, 'word', '', 1)
        body.position = tonumber(str)
        body.text = go:GetComponent("UILabel").text
        msg.body = body:SerializeToString();
        SendGameMessage(msg, nil)
    elseif panelInGame == panelInGame_dtz then
        local msg = Message.New()
        msg.type = dtz_pb.SEND_CHAT
        local body = dtz_pb.PChat()
        body.type = dtz_pb.CHOOSE
        local str = string.gsub(go.name, 'word', '', 1)
        body.position = tonumber(str)
        body.text = go:GetComponent("UILabel").text
        msg.body = body:SerializeToString();
        SendGameMessage(msg, nil)
    elseif panelInGame == panelInGame_bbtz then
        local msg = Message.New()
        msg.type = bbtz_pb.SEND_CHAT
        local body = bbtz_pb.PChat()
        body.type = bbtz_pb.CHOOSE
        local str = string.gsub(go.name, 'word', '', 1)
        body.position = tonumber(str)
        body.text = go:GetComponent("UILabel").text
        msg.body = body:SerializeToString();
        SendGameMessage(msg, nil)
    elseif panelInGame == panelInGame_xplp then
        local msg = Message.New()
        msg.type = xplp_pb.SEND_CHAT
        local body = xplp_pb.PChat()
        body.type = xplp_pb.CHOOSE
        local str = string.gsub(go.name, 'word', '', 1)
        body.position = tonumber(str)
        body.text = go:GetComponent("UILabel").text
        msg.body = body:SerializeToString();
        SendGameMessage(msg, nil)
    elseif panelInGame == panelInGame_hnhsm then
        local msg   = Message.New()
        msg.type    = hnm_pb.SEND_CHAT
        local body  = hnm_pb.PChat()
        body.type   = hnm_pb.CHOOSE
        local str   = string.gsub(go.name, 'word', '', 1)
        body.position = tonumber(str)
        body.text = go:GetComponent("UILabel").text
        msg.body = body:SerializeToString();
        SendGameMessage(msg, nil)
    elseif panelInGame == panelInGame_hnzzm then
        local msg   = Message.New()
        msg.type    = hnm_pb.SEND_CHAT
        local body  = hnm_pb.PChat()
        body.type   = hnm_pb.CHOOSE
        local str   = string.gsub(go.name, 'word', '', 1)
        body.position = tonumber(str)
        body.text = go:GetComponent("UILabel").text
        msg.body = body:SerializeToString();
        SendGameMessage(msg, nil)
	elseif panelInGame == panelInGame_yjqf then
        local msg   = Message.New()
        msg.type    = yjqf_pb.SEND_CHAT
        local body  = yjqf_pb.PChat()
        body.type   = yjqf_pb.CHOOSE
        local str   = string.gsub(go.name, 'word', '', 1)
        body.position = tonumber(str)
        body.text = go:GetComponent("UILabel").text
        msg.body = body:SerializeToString();
        SendGameMessage(msg, nil)
    elseif panelInGame == panelInGame_dzahm then
        local msg   = Message.New()
        msg.type    = dzm_pb.SEND_CHAT
        local body  = dzm_pb.PChat()
        body.type   = dzm_pb.CHOOSE
        local str   = string.gsub(go.name, 'word', '', 1)
        body.position = tonumber(str)
        body.text = go:GetComponent("UILabel").text
        msg.body = body:SerializeToString();
        SendGameMessage(msg, nil)
    end
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickIcon(go)
    if panelInGame == panelInGame_pdk  then
        local msg = Message.New()
        msg.type = pdk_pb.SEND_CHAT
        local body = pdk_pb.PChat()
        body.type = pdk_pb.IMAGE
        local str = string.gsub(go.name, 'icon', '', 1)
        body.position = tonumber(str)
        body.text = ''
        msg.body = body:SerializeToString();
        SendGameMessage(msg, nil)
    elseif panelInGame == panelInGameLand then
        local msg = Message.New()
        msg.type = phz_pb.SEND_CHAT
        local body = phz_pb.PChat()
        body.type = phz_pb.IMAGE
        local str = string.gsub(go.name, 'icon', '', 1)
        body.position = tonumber(str)
        body.text = ''
        msg.body = body:SerializeToString();
        SendGameMessage(msg, nil)
    elseif panelInGame == panelInGamemj then
        print("")
        local msg = Message.New()
        msg.type = csm_pb.SEND_CHAT
        local body = csm_pb.PChat()
        body.type = csm_pb.IMAGE
        local str = string.gsub(go.name, 'icon', '', 1)
        body.position = tonumber(str)
        body.text = ''
        msg.body = body:SerializeToString();
        SendGameMessage(msg, nil)
    elseif panelInGame == panelInGame_xhzd then
        local msg = Message.New()
        msg.type = xhzd_pb.SEND_CHAT
        local body = xhzd_pb.PChat()
        body.type = xhzd_pb.IMAGE
        local str = string.gsub(go.name, 'icon', '', 1)
        body.position = tonumber(str)
        body.text = ''
        msg.body = body:SerializeToString();
        SendGameMessage(msg, nil)
    elseif panelInGame == panelInGame_dtz then
        local msg = Message.New()
        msg.type = dtz_pb.SEND_CHAT
        local body = dtz_pb.PChat()
        body.type = dtz_pb.IMAGE
        local str = string.gsub(go.name, 'icon', '', 1)
        body.position = tonumber(str)
        body.text = ''
        msg.body = body:SerializeToString();
        SendGameMessage(msg, nil)
    elseif panelInGame == panelInGame_bbtz then
        local msg = Message.New()
        msg.type = bbtz_pb.SEND_CHAT
        local body = bbtz_pb.PChat()
        body.type = bbtz_pb.IMAGE
        local str = string.gsub(go.name, 'icon', '', 1)
        body.position = tonumber(str)
        body.text = ''
        msg.body = body:SerializeToString();
        SendGameMessage(msg, nil)
    elseif panelInGame == panelInGame_xplp then
        local msg = Message.New()
        msg.type = xplp_pb.SEND_CHAT
        local body = xplp_pb.PChat()
        body.type = xplp_pb.IMAGE
        local str = string.gsub(go.name, 'icon', '', 1)
        body.position = tonumber(str)
        body.text = ''
        msg.body = body:SerializeToString();
        SendGameMessage(msg, nil)
    elseif panelInGame == panelInGame_hnhsm then
        local msg = Message.New()
        msg.type = hnm_pb.SEND_CHAT
        local body = hnm_pb.PChat()
        body.type = hnm_pb.IMAGE
        local str = string.gsub(go.name, 'icon', '', 1)
        body.position = tonumber(str)
        body.text = ''
        msg.body = body:SerializeToString();
        SendGameMessage(msg, nil)
    elseif panelInGame == panelInGame_hnzzm then
        local msg = Message.New()
        msg.type = hnm_pb.SEND_CHAT
        local body = hnm_pb.PChat()
        body.type = hnm_pb.IMAGE
        local str = string.gsub(go.name, 'icon', '', 1)
        body.position = tonumber(str)
        body.text = ''
        msg.body = body:SerializeToString();
        SendGameMessage(msg, nil)
	elseif panelInGame == panelInGame_yjqf then
        local msg = Message.New()
        msg.type = yjqf_pb.SEND_CHAT
        local body = yjqf_pb.PChat()
        body.type = yjqf_pb.IMAGE
        local str = string.gsub(go.name, 'icon', '', 1)
        body.position = tonumber(str)
        body.text = ''
        msg.body = body:SerializeToString();
        SendGameMessage(msg, nil)
    elseif panelInGame == panelInGame_dzahm then
        local msg = Message.New()
        msg.type = dzm_pb.SEND_CHAT
        local body = dzm_pb.PChat()
        body.type = dzm_pb.IMAGE
        local str = string.gsub(go.name, 'icon', '', 1)
        body.position = tonumber(str)
        body.text = ''
        msg.body = body:SerializeToString();
        SendGameMessage(msg, nil)
    end

    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnInputSubmit()
    -- local str = input:GetComponent('UIInput').value
    -- if str ~= nil and str ~= '' then
    --     local msg = Message.New()
    --     msg.type = phz_pb.SEND_CHAT
    --     local body = phz_pb.PChat()
    --     body.type = phz_pb.WRITE
    --     body.position = 0
    --     body.text = str
    --     msg.body = body:SerializeToString();
    --     SendGameMessage(msg, nil)
    --     input:GetComponent('UIInput').value = ''
    --     PanelManager.Instance:HideWindow(gameObject.name)
    -- end
end

function this.AddChatToLabel(text)
	chatList:GetComponent('UITextList'):Add(text)
end

function this.ClearChat()
	chatList:GetComponent('UITextList'):Clear()
end

function this.OnClickClose()
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickSend(go)
    AudioManager.Instance:PlayAudio('btn')
    local str = input:GetComponent('UIInput').value
    if str ~= nil and str ~= '' then
        if panelInGame == panelInGame_pdk  then
            local msg = Message.New()
            msg.type = pdk_pb.SEND_CHAT
            local body = pdk_pb.PChat()
            body.type = pdk_pb.WRITE
            body.position = 0
            body.text = str
            msg.body = body:SerializeToString();
            SendGameMessage(msg, nil)
        elseif panelInGame == panelInGameLand then

            local msg = Message.New()
            msg.type = phz_pb.SEND_CHAT
            local body = phz_pb.PChat()
            body.type = phz_pb.WRITE
            body.position = 0
            body.text = str
            msg.body = body:SerializeToString();
            SendGameMessage(msg, nil)
        elseif panelInGame == panelInGamemj then
            local msg = Message.New()
            msg.type = csm_pb.SEND_CHAT
            local body = csm_pb.PChat()
            body.type = csm_pb.WRITE
            body.position = 0
            body.text = str
            msg.body = body:SerializeToString();
            SendGameMessage(msg, nil)
        elseif panelInGame == panelInGame_xhzd then
            local msg = Message.New()
            msg.type = xhzd_pb.SEND_CHAT
            local body = xhzd_pb.PChat()
            body.type = xhzd_pb.WRITE
            body.position = 0
            body.text = str
            msg.body = body:SerializeToString();
            SendGameMessage(msg, nil)
        elseif panelInGame == panelInGame_dtz then
            local msg = Message.New()
            msg.type = dtz_pb.SEND_CHAT
            local body = dtz_pb.PChat()
            body.type = dtz_pb.WRITE
            body.position = 0
            body.text = str
            msg.body = body:SerializeToString();
            SendGameMessage(msg, nil)
        elseif panelInGame == panelInGame_xplp then
            local msg = Message.New()
            msg.type = xplp_pb.SEND_CHAT
            local body = xplp_pb.PChat()
            body.type = xplp_pb.WRITE
            body.position = 0
            body.text = str
            msg.body = body:SerializeToString();
            SendGameMessage(msg, nil)
        elseif panelInGame == panelInGame_hnhsm then
            local msg = Message.New()
            msg.type = hnm_pb.SEND_CHAT
            local body = hnm_pb.PChat()
            body.type = hnm_pb.WRITE
            body.position = 0
            body.text = str
            msg.body = body:SerializeToString();
            SendGameMessage(msg, nil)
        elseif panelInGame == panelInGame_hnzzm then
            local msg = Message.New()
            msg.type = hnm_pb.SEND_CHAT
            local body = hnm_pb.PChat()
            body.type = hnm_pb.WRITE
            body.position = 0
            body.text = str
            msg.body = body:SerializeToString();
            SendGameMessage(msg, nil)
        elseif panelInGame == panelInGame_yjqf then
            local msg = Message.New()
            msg.type = yjqf_pb.SEND_CHAT
            local body = yjqf_pb.PChat()
            body.type = yjqf_pb.WRITE
            body.position = 0
            body.text = str
            msg.body = body:SerializeToString();
            SendGameMessage(msg, nil)
        elseif panelInGame == panelInGame_dzahm then
            local msg = Message.New()
            msg.type = dzm_pb.SEND_CHAT
            local body = dzm_pb.PChat()
            body.type = dzm_pb.WRITE
            body.position = 0
            body.text = str
            msg.body = body:SerializeToString();
            SendGameMessage(msg, nil)
        end
        input:GetComponent('UIInput').value = ''
        PanelManager.Instance:HideWindow(gameObject.name)
    end
end