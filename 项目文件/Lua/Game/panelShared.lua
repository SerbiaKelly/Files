


panelShared = {}
local this = panelShared;

local message
local gameObject
local ButtonClose

local mask
local friendGroup
local friendCircle
local xianLiao

--���¼�--
function this.Awake(obj)
	gameObject = obj;

    mask = gameObject.transform:Find('BaseContent/mask');
    friendGroup = gameObject.transform:Find('friendGroup');
    friendCircle = gameObject.transform:Find('friendCircle');
    xianLiao = gameObject.transform:Find('xianLiao');
	ButtonClose = gameObject.transform:Find('BaseContent/ButtonClose')

	message = gameObject:GetComponent('LuaBehaviour');
    message:AddClick(ButtonClose.gameObject, this.OnClickMask);
    message:AddClick(friendGroup.gameObject, this.OnClickFriendGroup);
    message:AddClick(friendCircle.gameObject, this.OnClicFriendCircle);
    message:AddClick(xianLiao.gameObject, this.OnClicXianLiao);
end
local mData
function this.WhoShow(data)
    print('传入的'..data.showName)
    mData=data
    -- if mData.showName=='shareGame' then
    --     friendCircle.gameObject:SetActive(true)
    -- elseif mData.showName=='hongBao' then
    --     friendCircle.gameObject:SetActive(true)
    -- elseif mData.showName == 'gameOver' then
    --     friendCircle.gameObject:SetActive(true)
    -- elseif mData.showName=='LinkShare' then
    --     friendCircle.gameObject:SetActive(false)
    -- elseif mData.showName == 'JieTuShare' then
    --     friendCircle.gameObject:SetActive(false)
    -- end
end
function this.Start()
end

function this.OnEnable()
end
function this.Update()
   
end
--�����¼�--
function this.OnClickMask(go)
	AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
end
function this.OnClicXianLiao()
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
    print('mData.showName'..mData.showName)
    if mData.showName=='shareGame' then
        PlatformManager.Instance:ShareLinkToXL('http://www.17hiya.com/hpphz.html', '嗨皮湖南棋牌', '大家快来玩吧！')
    elseif mData.showName=='hongBao' then
        PlatformManager.Instance:ShareScreenshotToXL('嗨皮湖南棋牌',false)
    elseif mData.showName == 'LinkShare' then
        PlatformManager.Instance:ShareLinkToXL('http://'..panelLogin.HttpUrl..'/share/shareResult.html?appType=1&roomId='..mData.roomId, mData.title, mData.msg)
    elseif mData.showName == 'JieTuShare' then
        PlatformManager.Instance:ShareScreenshotToXL('嗨皮湖南棋牌', false)
    end
end
function this.OnClicFriendCircle()
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
    print('mData.showName'..mData.showName)
    if mData.showName=='shareGame' then
        PlatformManager.Instance:ShareLink('http://www.17hiya.com/hpphz.html', '嗨皮湖南棋牌', '大家快来玩吧！',1)
    elseif mData.showName=='hongBao' then
        PlatformManager.Instance:ShareScreenshot('嗨皮湖南棋牌',false,1)
    elseif mData.showName=='LinkShare' then
        PlatformManager.Instance:ShareLink('http://'..panelLogin.HttpUrl..'/share/toResult/' .. mData.roomId..'/1', mData.title, mData.msg, 1)
    elseif mData.showName == 'JieTuShare' then
        PlatformManager.Instance:ShareScreenshot('嗨皮湖南棋牌', false, 1)
    end
end

function this.OnClickFriendGroup()
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
    print('mData.showName'..mData.showName)
    if mData.showName=='shareGame' then
        PlatformManager.Instance:ShareLink('http://www.17hiya.com/hpphz.html', '嗨皮湖南棋牌', '大家快来玩吧！',0)
    elseif mData.showName=='hongBao' then
        PlatformManager.Instance:ShareScreenshot('嗨皮湖南棋牌',false,0)
    elseif mData.showName=='LinkShare' then
        PlatformManager.Instance:ShareLink('http://'..panelLogin.HttpUrl..'/share/toResult/' .. mData.roomId..'/1', mData.title, mData.msg, 0)
    elseif mData.showName == 'JieTuShare' then
        PlatformManager.Instance:ShareScreenshot('嗨皮湖南棋牌', false, 0)
    end
    
end

function this.onWeiXinShareCallBack(code)--// 0：用户同意；-4：用户拒绝授权；-2：用户取消
    if mData.showName=='shareGame' then
       
    elseif mData.showName=='hongBao' then
    end
    
end

function this.onXianLiaoShareCallBack(code)--// 0：用户同意；-4：用户拒绝授权；-2：用户取消
    if mData.showName=='shareGame' then
       
    elseif mData.showName=='hongBao' then
    end
end