---
--- Generated by
--- Created by liurenhai.
--- DateTime: 2020/2/12 
---

panelChiPai_xplp = {}
local this = panelChiPai_xplp;

local message
local gameObject

local chiGrid
local mask
local gridBG;
local itemPrefab = nil;
local EventTool = nil;

local newOperationData;


function this.Awake(obj)
    gameObject = obj
    chiGrid     = gameObject.transform:Find('chiGrid');
    mask        = gameObject.transform:Find('mask');
    gridBG      = gameObject.transform:Find('Bg');
    itemPrefab  = gameObject.transform:Find("xplpChooseItem");
    message     = gameObject:GetComponent('LuaBehaviour')

    message:AddClick(mask.gameObject, this.OnClickMask)

end

function this.Start()
end

function this.Update()

end

function this.WhoShow(data)
    OPType              = data.op;
    newOperationData    = data.newOperationData;
    EventTool           = data.EventTool;
    print('panelChiPai mahjongs:'..#newOperationData);
    chiIndex = -1
    this.RefreshGrid(chiGrid, newOperationData);
end



function this.OnEnable()

end

function this.OnClickMask(go)
    print("OnClickMask was called--------");
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickButtonOk(go)
    chiIndex = GetUserData(go);
    if chiIndex <= 0 then
        return
    end
    AudioManager.Instance:PlayAudio('btn');
    EventTool.SendMsg(chiIndex,newOperationData);
    --this.OnClickMask(go)
    PanelManager.Instance:HideWindow(gameObject.name);
end


function this.RefreshGrid(grid, ROperationData)
    
    --1.先隐藏上一次的记录
    for i=0,grid.childCount-1 do
        grid:GetChild(i).gameObject:SetActive(false);
    end
    --2.生成新的grid
    for i=1,#ROperationData do
        local cardItem = nil;
        if i <= grid.childCount then 
            cardItem = grid:GetChild(i-1).gameObject;
        else
            cardItem = NGUITools.AddChild(grid.gameObject, itemPrefab.gameObject);
            message:AddClick(cardItem.gameObject,this.OnClickButtonOk);
        end
        cardItem:SetActive(true);
        SetUserData(cardItem.gameObject,i);
        
        --3.赋值牌面
        for j=1,#ROperationData[i].mahjongs do
            cardItem.transform:Find("card"..j):Find("card"):GetComponent("UISprite").spriteName = tostring(ROperationData[i].mahjongs[j]);
            cardItem.transform:Find("card"..j):Find("gray").gameObject:SetActive(j == 1 and ROperationData[i].type == xplp_pb.CHI);
        end
    end
    

    local itemCount = #ROperationData;

    this.ResetGridPos(chiGrid,itemCount);
    grid:GetComponent('UIGrid'):Reposition();
end


function this.ResetGridPos(grid,itemCount)
    --2.设置背景的宽度
    gridBG:GetComponent("UISprite").width = grid:GetComponent("UIGrid").cellWidth * itemCount + 90 ;
end

