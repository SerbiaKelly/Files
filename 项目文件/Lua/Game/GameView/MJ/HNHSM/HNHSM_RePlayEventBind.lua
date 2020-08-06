
HNHSM_RePlayEventBind   = {};
local this              = HNHSM_RePlayEventBind;
local replayUILayer     = nil;
local gameUIObjects     = nil;
local HNHSM_RePlayLogic = nil;
local message           = nil;
local isEventInit       = false;



function this.Init(_replayUILayer,_gameUIObjects,_rePlayLogic )
    -- body
    replayUILayer       = _replayUILayer;
    gameUIObjects       = _gameUIObjects;
    HNHSM_RePlayLogic    = _rePlayLogic;
    message             = replayUILayer.gameObject:GetComponent('LuaBehaviour');
    if isEventInit then 
        return ;
    end

    message:AddClick(gameUIObjects.ButtonSlow.gameObject,           this.OnClickButtonSlow);
    message:AddClick(gameUIObjects.ButtonPause.gameObject,          this.OnClickButtonPause);
    message:AddClick(gameUIObjects.ButtonFast.gameObject,           this.OnClickButtonFast);
    message:AddClick(gameUIObjects.ButtonBack.gameObject,           this.OnClickButtonBack);
    message:AddClick(gameUIObjects.ButtondismissBackType.gameObject,this.OnClickButtondismissType);
    message:AddClick(gameUIObjects.ButtondismissPopType.gameObject, this.OnClickButtondismissType);
    isEventInit = true;

end

--播放降速
function this.OnClickButtonSlow(go)
    AudioManager.Instance:PlayAudio('btn')
    replayUILayer:PlaySlow();
end

--播放和暂停
function this.OnClickButtonPause(go)
    AudioManager.Instance:PlayAudio('btn')
    replayUILayer:PlayPause();
end

--播放加速
function this.OnClickButtonFast(go)
    AudioManager.Instance:PlayAudio('btn')
    replayUILayer:PlayFast();
end

--播放倒退
function this.OnClickButtonBack(go)
    AudioManager.Instance:PlayAudio('btn')
    replayUILayer:ExitPlay();
end

--查看解散原因
function this.OnClickButtondismissType(go)
    AudioManager.Instance:PlayAudio('btn')
    replayUILayer:SetDismissType(go);
end








