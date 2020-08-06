panelPlatesCount_xplp   = {};
local this              = panelPlatesCount_xplp;
local message           = nil;
local gameObject        = nil;
local uiLayer           = nil;
local logic             = nil;
local cardItemPrefab    = nil;
local wanGrid           = nil;
local tiaoGrid          = nil;
local tongGrid          = nil;
local niuPoItem         = nil;
local piaoHuaItem       = nil;
local laoQianItem       = nil;
local mask              = nil;

function this.Awake(obj)
    gameObject      = obj;
    message         = gameObject:GetComponent('LuaBehaviour');
    cardItemPrefab  = gameObject.transform:Find("cardItem");
    wanGrid         = gameObject.transform:Find("wanGrid");
    tongGrid        = gameObject.transform:Find("tongGrid");
    tiaoGrid        = gameObject.transform:Find("tiaoGrid");

    niuPoItem       = gameObject.transform:Find("niuPoItem");
    piaoHuaItem     = gameObject.transform:Find("piaoHuaItem");
    laoQianItem     = gameObject.transform:Find("laoQianItem");
    mask            = gameObject.transform:Find("mask"); 

    message:AddClick(mask.gameObject,   this.OnClickMask);



end

function this.Update( )
    -- body
end

function this.Start( )
    -- body
end

function this.OnApplicationFocus( )
    -- body
end

function this.WhoShow(data)
    uiLayer = data.uiLayer;
    logic   = data.logic;
    this.RefreshPlatesCount(logic);
end

function this.OnEnable( )
    -- body
end

function this.RefreshPlatesCount(logic)
    local plateCounts = this.GetCountTotal(logic);

    this.RefreshWanGrid(plateCounts);
    this.RefreshTongGrid(plateCounts);
    this.RefreshTiaoGrid(plateCounts);

    --老钱
    laoQianItem.transform:Find("card"):GetComponent("UISprite").spriteName = "27";
    laoQianItem.transform:Find("number/numLabel"):GetComponent("UILabel").text = tostring(plateCounts[27]);
    --飘花
    piaoHuaItem.transform:Find("card"):GetComponent("UISprite").spriteName = "28";
    piaoHuaItem.transform:Find("number/numLabel"):GetComponent("UILabel").text = tostring(plateCounts[28]);
    --牛婆
    niuPoItem.transform:Find("card"):GetComponent("UISprite").spriteName = "29";
    niuPoItem.transform:Find("number/numLabel"):GetComponent("UILabel").text = tostring(plateCounts[29]);
end

--刷新已出的万
function this.RefreshWanGrid(plateCounts)
    if plateCounts == nil then 
        return;
    end
    for i=0, 8 do
        local wanItem = nil;
        if i+1 > wanGrid.childCount then 
            wanItem = NGUITools.AddChild(wanGrid.gameObject,cardItemPrefab.gameObject);
        else
            wanItem = wanGrid:GetChild(i).gameObject;
        end
        wanItem.gameObject:SetActive(true);
        wanItem.transform:Find("card"):GetComponent("UISprite").spriteName = tostring(i);
        wanItem.transform:Find("number/numLabel"):GetComponent("UILabel").text = tostring(plateCounts[i]);
    end

    wanGrid:GetComponent("UIGrid"):Reposition();

end

--刷新已出的筒子
function this.RefreshTongGrid(plateCounts)
    if plateCounts == nil then 
        return ;
    end

    for i=9,17 do
        local tongItem = nil;
        if i - 8 > tongGrid.childCount then 
            tongItem = NGUITools.AddChild(tongGrid.gameObject,cardItemPrefab.gameObject);
        else
            tongItem = tongGrid:GetChild(i-9);
        end
        tongItem.gameObject:SetActive(true);
        tongItem.transform:Find("card"):GetComponent("UISprite").spriteName = tostring(i);
        tongItem.transform:Find("number/numLabel"):GetComponent("UILabel").text = tostring(plateCounts[i]);
        
    end
    tongGrid:GetComponent("UIGrid"):Reposition();

end

--刷新已出的条
function this.RefreshTiaoGrid(plateCounts)
    if plateCounts == nil then 
        return ;
    end

    for i=18,26 do
        local tiaoItem = nil;
        if i - 17 > tiaoGrid.childCount then 
            tiaoItem = NGUITools.AddChild(tiaoGrid.gameObject,cardItemPrefab.gameObject);
        else
            tiaoItem = tiaoGrid:GetChild(i - 18);
        end
        tiaoItem.gameObject:SetActive(true);
        tiaoItem.transform:Find("card"):GetComponent("UISprite").spriteName = tostring(i);
        tiaoItem.transform:Find("number/numLabel"):GetComponent("UILabel").text = tostring(plateCounts[i]);
    end

    tiaoGrid:GetComponent("UIGrid"):Reposition();

end

--获得已出牌的统计【牌的牌面从0-29，0-8万，9-17筒，18-26条子，27老钱，28飘花，29牛婆】
function this.GetCountTotal(logic)
    local plateCounts = {};
    local playerDatas = logic:GetPlayerDatas();
    --统计已出牌数目
    for seat,playerdata in pairs(playerDatas) do
        for i=1,#playerdata.paiHe do
            if plateCounts[playerdata.paiHe[i]] == nil then 
                plateCounts[playerdata.paiHe[i]] = 1;
            else
                plateCounts[playerdata.paiHe[i]] = plateCounts[playerdata.paiHe[i]] + 1;
            end
        end
    end

    --加入那些完全还没有出的牌，数目是0
    for i=0,29 do
        if plateCounts[i] == nil then 
            plateCounts[i] = 0;
        end
    end

    return plateCounts;
end

function this.OnClickMask(go)
    gameObject:SetActive(false);
end



