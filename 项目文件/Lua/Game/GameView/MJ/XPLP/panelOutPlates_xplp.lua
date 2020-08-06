panelOutPlates_xplp         = {};
local this                  = panelOutPlates_xplp;
local gameObject            = nil;
local message               = nil;
local mask                  = nil;
local outPlatesGrid         = nil;
local outPlateItemPrefab    = nil;
local uiLayer               = nil;

function this.Awake( obj )
    gameObject          = obj;
    message             = gameObject:GetComponent('LuaBehaviour');
    outPlateItemPrefab  = gameObject.transform:Find("outPlateItem");
    mask                = gameObject.transform:Find("maskbg");
    outPlatesGrid       = gameObject.transform:Find("outPlatesGrid");

    message:AddClick(mask.gameObject, function(go) 
        gameObject:SetActive(false);
        if uiLayer then --游戏内和回放中都会用到，但是游戏内这个uilayer不会传过来
            uiLayer:PlayPause(false);
        end
    end);
    

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
    -- body
    uiLayer = data.uiLayer;
    this.RefreshOutPlates(data.plates);
end

function this.OnEnable( )
    -- body
end

--刷新已出牌的grid
function this.RefreshOutPlates(plates)
    if plates == nil or #plates == 0 then 
        return ;
    end
    --先隐藏
    for i=0,outPlatesGrid.childCount - 1 do
        outPlatesGrid:GetChild(i).gameObject:SetActive(false);
    end

    for i=1,#plates do
        local plateItem = nil;
        if i <= outPlatesGrid.childCount then 
            plateItem = outPlatesGrid:GetChild(i-1).gameObject;
        else
            plateItem = NGUITools.AddChild(outPlatesGrid.gameObject,outPlateItemPrefab.gameObject);
        end
        plateItem.transform:Find("card"):GetComponent("UISprite").spriteName = tostring(plates[i]);
        plateItem:SetActive(true);
    end

    outPlatesGrid:GetComponent("UIGrid"):Reposition();

end