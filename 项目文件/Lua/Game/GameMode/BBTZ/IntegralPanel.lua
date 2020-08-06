require("BBTZ.BBTZ_Tools")
IntegralPanel = {}
local this = IntegralPanel

local logic = nil
local integralItems = {}
function this.Init(obj, lc)
    logic = lc
    for i = 1, 3 do
        local objectStr = "Player"..i
        local item = obj.transform:Find("Gamers/"..objectStr)
        local scoring = {
            gameObject = item.gameObject,
            Name = item:Find("Name"),
            History = item:Find("History"),
            RoundNow = item:Find("RoundNow"),
        }
        table.insert(integralItems, scoring)
    end

    logic.InitView:Add(this.InitView, nil)
    logic.PlayerJoin:Add(this.Refresh, nil)
    logic.PlayerLeave:Add(this.Refresh, nil)
    logic.RoundStart:Add(this.Refresh, nil)
    logic.RefreshScoreBoard:Add(this.UpdataScores, nil)
end

function this.InitView()
    for i = 1, 3 do
        integralItems[i].gameObject:SetActive(false)
    end
end

function this.Refresh()
    local index = 1
    local playerDatas = logic:GetPlayerDatas()
    for seat,playerData in pairs(playerDatas) do
        local view = integralItems[index]
        view.gameObject:SetActive(true)
        this.SetItemView(view, playerData, playerData.history, playerData.roundGrab)
        index = index + 1
    end

    for i = index, 3 do
        integralItems[i].gameObject:SetActive(false)
    end
end

function this.UpdataScores(scores)
    for i = 1, #scores do
        local view = integralItems[scores[i].seat + 1]
        this.SetItemView(view, logic:GetPlayerDataBySeat(scores[i].seat), scores[i].history, scores[i].roundGarb)
    end
end

function this.SetItemView(view, playerData, history, roundGrab)
    SetLabelText(view.Name, playerData.name)
    SetLabelText(view.History, history)
    SetLabelText(view.RoundNow, roundGrab)
end