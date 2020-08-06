require("class")
require("PlayerViewBase")
local bbtz_pb = require("bbtz_pb")

BBTZ_Player = class(PlayerViewBase);
local RoundOrder = {[0] = '上游', [1] = '二游', [2] = '三游', [3] = '下游'}
function BBTZ_Player:ResetView(data)
    self.super.ResetView(self, data)

    self:SetBoom(data.boom == 1 and roomData.setting.size > 2)
    self:SetRoundOrder(data.roundOrder)
    self:SetMaster(roomData.banker == data.seat)
    self:SetHammer(data.hammer == 1):SetShoot(data.shoot == 1):SetRobbing(data.robbing == 1)
    :SetSteep(data.steep == 1):SetHelpSteep(data.helpSteep == 1):SetReverse(data.reverse == 1):FlagsResetPosition()

    if roomData.state == bbtz_pb.READYING then
        self:SetReady(data.ready)
    end
end

function BBTZ_Player:SetWidhetObj(outOwedCard, restCardGrid, playerObj, inGameObject, index)
    self.flags              = playerObj.transform:Find("GameState/Flags");
    self.zhaFlag            = playerObj.transform:Find("GameState/ZhaFlag");
    self.restCardNum        = playerObj.transform:Find("GameState/RestCardNum");
    self.outOwedCard        = outOwedCard
    self.restCardGrid       = restCardGrid
    self.effect             = inGameObject.transform:Find("GamerEffects/Player"..index);
    self.warnning           = playerObj.transform:Find("GameState/Warnning");
    self.outCardFinish      = playerObj.transform:Find("GameState/OutCardFinish");
    local scoringTrans      = inGameObject.transform:Find("GamerScorings/Gamers/Player"..index);
    self.scoring = {
        gameObject  = scoringTrans.gameObject,
        Name        = scoringTrans.transform:Find("Name"),
        History     = scoringTrans.transform:Find("History"),
        RoundNow    = scoringTrans.transform:Find("RoundNow"),
    }
end

function BBTZ_Player:SetOptionFlag(option, confim)
    if option == bbtz_pb.OPTION_EMPTY then 
        return 
    end
    if option == bbtz_pb.OPTION_HAMMER then
        self:SetHammer(confim)
    elseif option == bbtz_pb.OPTION_SHOOT then
        self:SetShoot(confim)
    elseif option == bbtz_pb.OPTION_ROBBING then
    elseif option == bbtz_pb.OPTION_STEEP then
        self:SetSteep(confim)
    elseif option == bbtz_pb.OPTION_HELP_STEEP then
        self:SetHelpSteep(confim)
    elseif option == bbtz_pb.OPTION_REVERSE then
        self:SetReverse(confim)
    end
    self:FlagsResetPosition()
    self:PlayEffects(true, {option = option, confim = confim}, nil, nil, true)
end

function BBTZ_Player:SetHammer(enable) self.flags.transform:Find("Chui").gameObject:SetActive(enable) return self end

function BBTZ_Player:SetShoot(enable) self.flags.transform:Find("Gun").gameObject:SetActive(enable) return self end

function BBTZ_Player:SetRobbing(enable) self.flags.transform:Find("") return self end

function BBTZ_Player:SetSteep(enable) self.flags.transform:Find("Dou").gameObject:SetActive(enable) return self end

function BBTZ_Player:SetHelpSteep(enable) self.flags.transform:Find("Zhudou").gameObject:SetActive(enable) return self end

function BBTZ_Player:SetReverse(enable) self.flags.transform:Find("FanDou").gameObject:SetActive(enable) return self end

function BBTZ_Player:FlagsResetPosition()
    self.flags.gameObject:SetActive(true)
    self.flags.transform:GetComponent("UIGrid"):Reposition() 
end

function BBTZ_Player:SetBoom(enable) 
    self.zhaFlag.gameObject:SetActive(enable) 
    return self 
end

function BBTZ_Player:SetRestCardNum(num, hide)
    self.warnning.gameObject:SetActive(num == 1)
    if hide or not roomData.setting.show then 
        self.restCardNum.gameObject:SetActive(false)
        return
    end
    self.restCardNum.gameObject:SetActive(true)
    self.restCardNum.gameObject.transform:Find("num"):GetComponent('UILabel').text = num
    if num == 1 then
        coroutine.start(function()
            coroutine.wait(1)
            AudioManager.Instance:PlayAudio(string.format('baodan_%d_1', self.playerData.sex));
        end
        )
    end
end

function BBTZ_Player:ShowWarnningText(seat)
    --print("ShowWarnningText was called,seat:"..seat.."|self.playerData.seat:"..self.playerData.seat);



end

function BBTZ_Player:OnRefreshTime(time)
    local timeStr =  os.date("%M:%S", time);
    if self.timeLabel == nil then
        self.timeLabel = self.offineFlag.transform:Find("Time")
    end
    self.timeLabel:GetComponent("UILabel").text = timeStr
end

function BBTZ_Player:SetOutCards(lastHandCards, roundOrder, needEffect)
    --print("SetOutCards was caled");
    if lastHandCards.cards == nil or #lastHandCards.cards == 0 then
        return
    end
    self:SetRoundOrder(roundOrder)
    self:PlayEffects(false, nil, lastHandCards.cards, lastHandCards.category, needEffect)
    self.outOwedCard:RefreshCards(Bbtz_CardLogic.GetDeskOutHanCard(lastHandCards))
end

function BBTZ_Player:SetRestCards(cards)
    self:SetRestCardNum(0, true)
    self:CleanOutCardAndEffect()
    self.restCardGrid:RefreshCards(Bbtz_CardLogic.GetDeskOutHanCard(cards))
end

function BBTZ_Player:SetRoundOrder(roundOrder)
    if roundOrder ~= nil and roundOrder ~= -1 then
        self:SetRestCardNum(0, true)
        self.outCardFinish.gameObject:SetActive(true)
        self.outCardFinish:GetComponent('UISprite').spriteName = RoundOrder[roundOrder];
    end
end

function BBTZ_Player:SetPass()
    SetAnimation(self.effect:Find("Pass"));
    AudioManager.Instance:PlayAudio("buyao");
    self.effect.gameObject:SetActive(true);
end

function BBTZ_Player:PlayEffects(isOption, options, cards, category, needEffect)
    local str = ""
    if isOption then
        str = GetOptionEffects(options.option, options.confim)
        SetSpriteName(self.effect:Find("Category"), str)
        PlayOptionEffectSound(options.option, options.confim)
    else
        str = GetCategoryEffects(#cards, category)
        SetSpriteName(self.effect:Find("Category"), str)
        PlayCardEffectSound(cards, category)
    end
    
    if str == "" or (not needEffect) then 
        return 
    end
    --print("PlayEffects", str)
    self.effect.gameObject:SetActive(true)
    SetAnimation(self.effect:Find("Category"))
end

function BBTZ_Player:SetActiveFlag(enable)
    self.super.SetActiveFlag(self, enable)
    if enable then 
        self:CleanOutCardAndEffect()
    end
end

function BBTZ_Player:CleanOutCardAndEffect()
    --print("CleanOutCardAndEffect was called -----------> ")
    self.outOwedCard:Hide()
    StartCoroutine(function()
		WaitForSeconds(0.7);
        self:HideEffects()
	end);
end

function BBTZ_Player:HideEffects()
    self.effect:Find("Pass").gameObject:SetActive(false)
    self.effect:Find("Category").gameObject:SetActive(false)
end

function BBTZ_Player:CleanOutCards()
    --print("CleanOutCards was called----->");
    self.outOwedCard:Clean()
end

function BBTZ_Player:HideWarnning()

end

function BBTZ_Player:CleanView()
    self.super.CleanView(self)
    self:SetRestCardNum(0, true);
    self:HideWarnning();
    self:ResetGameState();
end





function BBTZ_Player:CloseView()
    self.super.CloseView(self)
    self:ResetGameState()
end

function BBTZ_Player:ResetRoundStartState()
    self:SetReady(false)
    self:UpdateScore(0)
end

function BBTZ_Player:ResetGameState()
    --print("ResetGameState was called------>")
    --self:ResetRoundStartState()
    self:SetBoom(false)
    self:SetMaster(false)
    self:HideEffects()
    self:SetRestCardNum(0, true)
    self:SetActiveFlag(false)
    CloseChild(self.flags)
    self.outOwedCard:Hide()
    self.restCardGrid:Hide()
    self.warnning.gameObject:SetActive(false)
    self.outCardFinish.gameObject:SetActive(false)
end

