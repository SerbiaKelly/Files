require("class")
PlayerViewBase = class()

--不要修改父类文件  如果需要自己继承实现
-- 名字 头像 分数 托管 离线 准备 标识
function PlayerViewBase:ctor(playerObj,inGameObj)

    self.name               = playerObj.transform:Find("Info/Name");
    self.image              = playerObj.transform:Find("Info/Image");
    self.score              = playerObj.transform:Find("Info/Score");
    self.magicEmoji         = playerObj.transform:Find("GameState/MagicEmoji");
    self.chatMsg            = playerObj.transform:Find("GameState/ChatMsg");
    self.chatImage          = playerObj.transform:Find("GameState/ChatEmoji");
    self.voiceFlag          = playerObj.transform:Find("GameState/VoiceFlag");
    self.activeFlag         = playerObj.transform:Find("GameState/Active");
    self.offineFlag         = playerObj.transform:Find("GameState/OfflineTime");
    self.trusteeshipFlag    = playerObj.transform:Find("GameState/Trusteeship");
    self.masterFlag         = playerObj.transform:Find("GameState/Master");
    self.readyFlag          = playerObj.transform:Find("GameState/Ready");
    self.gameObject         = playerObj;
    self._offlineTiming     = nil
    self._emojiAnimtor      = nil
    self._chatCoroutiner    = nil

    EventDelegate.AddForLua(UIEventTrigger.Get(self.image.gameObject).onClick, function(go) self:OnClickImage() end)
end

function PlayerViewBase:SetGameLogic(logic)
    self.logic = logic;
    return self;
end

function PlayerViewBase:SetRoundDetail(RoundDetail)
    -- print("SetRoundDetail was called");
    self.RoundDetail = RoundDetail;
    return self;
end

function PlayerViewBase:SetGameRoomData(roomData)
    -- print("SetGameRoomData was called");
    self.roomData = roomData;
    return self;
end

function PlayerViewBase:UpdateInfo(name, imageUrl, score)
    self.name.gameObject:GetComponent('UILabel').text = name
    self.logic:DownImage(imageUrl, self.image)
    self:UpdateScore(score)
end

function PlayerViewBase:SetReady(enable)
    self.readyFlag.gameObject:SetActive(enable)
end

function PlayerViewBase:SetMaster(enable)
    self.masterFlag.gameObject:SetActive(enable)
end

function PlayerViewBase:SetActiveFlag(enable, ...)
    self.activeFlag.gameObject:SetActive(enable)
end

function PlayerViewBase:SetTrusteeship(enable)
    self.trusteeshipFlag.gameObject:SetActive(enable)
end

function PlayerViewBase:SetVoiceFlag(enable)
    self.voiceFlag.gameObject:SetActive(enable)
end

function PlayerViewBase:UpdateScore(score)
    if score == nil then score = 0 end
    self.score.gameObject:GetComponent('UILabel').text = score
end

function PlayerViewBase:ResetView(playerData)
    self.playerData = playerData
    self:UpdateInfo(playerData.name, playerData.icon, playerData.score)
    self:SetTrusteeship(playerData.trusteeship)
    self:SetOffineFlag(not playerData.connected, playerData.disconnectTimes)
end

local function playMagicEmoji(emojiSpirte, delay, animName, inx, interval, soundName)
    coroutine.wait(delay)
    if soundName ~= nil then
        AudioManager.Instance:PlayAudio(soundName);
    end
    for i = 1, inx do
        emojiSpirte:GetComponent('UISprite').spriteName = animName..'_'..i;
        emojiSpirte:GetComponent('UISprite'):MakePixelPerfect();
        coroutine.wait(interval);
    end
    emojiSpirte.gameObject:SetActive(false)
    emojiSpirte.transform.localPosition = Vector3.zero
end

function PlayerViewBase:SetMagicEmoji(positionFrom, positionTo, animName, inx, soundName)
    print("要播放动画了", animName)
    self.magicEmoji.gameObject:GetComponent('UISprite').spriteName = animName
	self.magicEmoji.gameObject:GetComponent('UISprite'):MakePixelPerfect()
	self.magicEmoji.gameObject:GetComponent('TweenPosition').worldSpace 	= true
	self.magicEmoji.gameObject:GetComponent('TweenPosition').from = positionFrom
	self.magicEmoji.gameObject:GetComponent('TweenPosition').to = positionTo
	self.magicEmoji.gameObject:GetComponent('TweenPosition').duration = 1;
	self.magicEmoji.gameObject:GetComponent('TweenPosition'):ResetToBeginning();
    self.magicEmoji.gameObject:GetComponent('TweenPosition'):PlayForward();
    self.magicEmoji.gameObject:SetActive(true);
    
    if self._emojiAnimtor ~= nil then
        coroutine.stop(self._emojiAnimtor)
        self._emojiAnimtor = nil
    end
    self._emojiAnimtor = coroutine.start(playMagicEmoji, self.magicEmoji, 1, animName, inx, 0.1, soundName)
end

local function SetMsgTest(label, msg, sound)
    label.gameObject:SetActive(true)
    label.transform:GetComponent("UILabel").text = msg
    label.transform:GetComponent("UILabel").color = Color(244/255,244/255,244/255)
    if sound ~= nil then
        AudioManager.Instance:PlayAudio(sound)
    end
    coroutine.wait(3)
    label.gameObject:SetActive(false)
end

local function SetChatEmoji(image, position, interval)
    local myTable = {
        ['emoji_1'] = 2,
        ['emoji_2'] = 4,
        ['emoji_3'] = 9,
	    ['emoji_4'] = 2,
        ['emoji_5'] = 5,
        ['emoji_6'] = 9,
        ['emoji_7'] = 3,
        ['emoji_8'] = 4,
        ['emoji_9'] = 2,
        ['emoji_10'] = 4,
        ['emoji_11'] = 4,
	    ['emoji_12'] = 2,
    }
    local str = 'emoji_' .. position
    image.gameObject:SetActive(true)
    for i = 1, 30 do
        image:GetComponent('UISprite').spriteName = str .. '_' .. (i % myTable[str] + 1)
        -- image:GetComponent('UISprite'):MakePixelPerfect();
        coroutine.wait(interval)
    end
    image.gameObject:SetActive(false)
end

function PlayerViewBase:SetChat(data)
    print("有玩家聊天了", data.seat, data.position)
    if self._chatCoroutiner ~= nil then
        coroutine.stop(self._chatCoroutiner)
        self._chatCoroutiner = nil
    end
   
    if data.type == 0 then
        if self._chartEmojiCor ~= nil then 
            coroutine.stop(self._chartEmojiCor);
            self._chartEmojiCor = nil;
        end
        self.chatMsg.gameObject:SetActive(false)
        self._chartEmojiCor = coroutine.start(SetChatEmoji, self.chatImage, data.position, 0.1)
    elseif data.type == 1 then -- 语音文本
        local sound = string.format('chat_%d_%d', self.playerData.sex, data.position)
        self._chatCoroutiner = coroutine.start(SetMsgTest, self.chatMsg, data.text, sound)
    else --纯文本
        self._chatCoroutiner = coroutine.start(SetMsgTest, self.chatMsg, data.text, nil)
    end
end

function PlayerViewBase:SetOffineFlag(enable, time) 
    self.offineFlag.gameObject:SetActive(enable) 
    if enable then
        self:StartOfflineTiming(time and time or 0)
    else
        self:StopOffineTiming()
    end
end

function PlayerViewBase:SetOnlyOfflineFlag(enable)
    self.offineFlag.gameObject:SetActive(enable)
    self.offineFlag:Find("Flag").gameObject:SetActive(enable);
    self.offineFlag:Find("Time").gameObject:SetActive(false);
end

local function OfflineTiming(time, view)
    while true do
        view:OnRefreshTime(time)
		coroutine.wait(1)
		time = time + 1
	end
end

function PlayerViewBase:StartOfflineTiming(time)
    if self._offlineTiming ~= nil then
        self:StopOffineTiming()
    end

    self.offineFlag.gameObject:SetActive(true)
    self.offineFlag:Find("Flag").gameObject:SetActive(true);
    self.offineFlag:Find("Time").gameObject:SetActive(true);
    self.OnStartOfflineTiming()
    self._offlineTiming = coroutine.start(OfflineTiming, time, self)
end

function PlayerViewBase:StopOffineTiming()
    local coroutines = self._offlineTiming

	if coroutines ~= nil then
		coroutine.stop(coroutines);
        coroutines = nil;
	end

    self.offineFlag.gameObject:SetActive(false)
    self:OnStopOffineTiming()
    self._offlineTiming = coroutines
end

function PlayerViewBase:OnStartOfflineTiming()
end

function PlayerViewBase:OnRefreshTime(time)

end

function PlayerViewBase:OnStopOffineTiming()

end

function PlayerViewBase:CleanView()
    self.playerData = nil;
    self.name.gameObject:GetComponent("UILabel").text = ""
    self.image.gameObject:GetComponent("UITexture").mainTexture = nil
    self.score.gameObject:GetComponent("UILabel").text = ""
    self.chatMsg.gameObject:SetActive(false)
    self.chatImage.gameObject:SetActive(false)
    self:SetReady(false)
    self:SetMaster(false)
    self:SetOffineFlag(false)
    self:SetTrusteeship(false)
    self:SetActiveFlag(false)
    self:SetVoiceFlag(false)
    self:StopOffineTiming()
end

function PlayerViewBase:CloseView()
    self.gameObject:SetActive(false)
end

function PlayerViewBase:OpenView()
    self.gameObject:SetActive(true)
end

function PlayerViewBase:OnClickImage()
    if self.playerData == nil then
        return
    end
	
	if self.RoundDetail.openUserCard then
		local userData = {}
		userData.rseat          = self.playerData.seat
		userData.mySeat	        = self.logic.mySeat;
		userData.nickname       = self.playerData.name
		userData.icon           = self.playerData.icon
		userData.sex            = self.playerData.sex
		userData.ip             = self.playerData.ip
		userData.userId         = self.playerData.id
		userData.address        = self.playerData.address
		userData.imgUrl         = self.playerData.imgUrl
		userData.gameType       = self.logic.gameType
		userData.signature      = self.playerData.signature
		userData.sendMsgAllowed = self.roomData.setting.sendMsgAllowed
		userData.fee            = self.playerData.fee
		userData.isShowSomeID   = not self.RoundDetail.isLord
		userData.gameMode       = self.roomData.setting.gameMode
		PanelManager.Instance:ShowWindow('panelPlayerInfo', userData)
	end
end