local bbtz_pb = require("bbtz_pb")
require("GameLogic")
require("HandCard")
require("CardGrid")

ScoreCardPanel = {}
local this = ScoreCardPanel

local scoreCardPanel = nil
local cardKGrid = nil
local card10Grid = nil
local card5Grid = nil
local message = nil;
local mask = nil;


function this.Init(panel, cardPrefab)
    message = panel.transform.parent:GetComponent('LuaBehaviour');
    mask = panel.transform:Find("mask");
    scoreCardPanel = panel
    local grid = panel.transform:Find("KCards")
    cardKGrid = CardGrid.New(cardPrefab, grid, this.RefreshCards):InitCont(4, 66)
    local grid = panel.transform:Find("10Cards")
    card10Grid = CardGrid.New(cardPrefab, grid, this.RefreshCards):InitCont(4, 66)
    local grid = panel.transform:Find("5Cards")
    card5Grid = CardGrid.New(cardPrefab, grid, this.RefreshCards):InitCont(4, 66)
    message:AddClick(mask.gameObject,this.OnClickMask);
end

function this.RefreshCards(i, obj, card)
    local cardBody = obj.transform:Find("Body")
    local bbtzPaiSize = UnityEngine.PlayerPrefs.GetInt("bbtzPaiSize",1);
    SetCardKeyColor(cardBody, card,bbtzPaiSize);
    SetWidgetDepth(obj, i * 2 + 66)
end

function this.Refresh()
    -- print("score panel  refresh");
    GameLogic:SendGameMsg(bbtz_pb.REFRESH_SCORECARDS, nil, function(msg)
        local body = GameLogic:GetMesaageData(bbtz_pb.RRefScoreCard(), msg)
        print("已出分数牌的数量："..#body.scoreCards)
        local hanCard = HandCard.New(body.scoreCards)

        --按照花色排序
        function tempsort(a,b)
            return Card.GetCardColor(a) > Card.GetCardColor(b);
        end
        local cardsK    = hanCard:GetKeyCards(13);
        local cards10   = hanCard:GetKeyCards(10);
        local cards5    = hanCard:GetKeyCards(5);
        table.sort(cardsK,  tempsort);
        table.sort(cards10, tempsort);
        table.sort(cards5,  tempsort);
        cardKGrid:RefreshCards(cardsK);
        card10Grid:RefreshCards(cards10);
        card5Grid:RefreshCards(cards5);
    end)
end

function this.SetScoreCards(scoreCards)
    local hanCard = HandCard.New(scoreCards)

    --按照花色排序
    function tempsort(a,b)
        return Card.GetCardColor(a) > Card.GetCardColor(b);
    end
    local cardsK    = hanCard:GetKeyCards(13);
    local cards10   = hanCard:GetKeyCards(10);
    local cards5    = hanCard:GetKeyCards(5);
    table.sort(cardsK,  tempsort);
    table.sort(cards10, tempsort);
    table.sort(cards5,  tempsort);
    cardKGrid:RefreshCards(cardsK);
    card10Grid:RefreshCards(cards10);
    card5Grid:RefreshCards(cards5);
end

function this.OnClickMask(go)
    this.Hide();
end

function this.Show()
    this.Refresh();
    scoreCardPanel.gameObject:SetActive(true)
end

function this.IsActive()
    return scoreCardPanel.gameObject.activeSelf
end

function this.ClearData()
    card5Grid:Hide();
    card10Grid:Hide();
    cardKGrid:Hide();
end

function this.Hide()
    scoreCardPanel.gameObject:SetActive(false)
end



