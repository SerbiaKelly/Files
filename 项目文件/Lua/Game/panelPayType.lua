


panelPayType = {}
local this = panelPayType;

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
    panelPayOption.OnClickAlipay()
end
function this.OnClicFriendCircle()
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
    
end

function this.OnClickFriendGroup()
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
    
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