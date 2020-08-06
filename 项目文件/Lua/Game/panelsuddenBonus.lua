local csm_pb = require 'csm_pb'

panelsuddenBonus = {};
local this = panelsuddenBonus;
local message;
local gameObject;
local suddenData = nil;
local gridBG;
local suddenGrid;
local suddentPrefab;
local mask;


function this.Awake(obj)
    gameObject      = obj;
    message         = gameObject:GetComponent("LuaBehaviour");
    gridBG          = gameObject.transform:Find("bg");
    suddenGrid      = gameObject.transform:Find("suddenGrid");
    suddentPrefab   = gameObject.transform:Find("suddenItem");
    mask            = gameObject.transform:Find("mask");

    this.BindEvents();

end

function this.BindEvents()

    message:AddClick(mask.gameObject, this.OnClickMask);

end


function this.WhoShow(data)
    suddenData = data;
    this.RefreshSuddenGrid(suddenData);
end



function this.Start()


end

function this.Update()

end

function this.OnEnable()

end

--刷新中途四喜的牌
function this.RefreshSuddenGrid(suddenData)

    --先隐藏所有item
    for i = 1, suddenGrid.childCount do
        local tempChild = suddenGrid:GetChild(i-1);
        if tempChild then
            tempChild.gameObject:SetActive(false);
        end
    end

    if suddenData then
        for i = 1, #suddenData do
            local setObj = nil;
            if i <= suddenGrid.childCount then
                setObj = suddenGrid:GetChild(i-1).gameObject;
            else
                setObj = NGUITools.AddChild(suddenGrid.gameObject, suddentPrefab.gameObject);
                message:AddClick(setObj, this.OnClickSuddenItem);
            end

            this.setSuddenItem(suddenData[i],setObj);
        end

        --设置背景的宽度
        gridBG:GetComponent("UISprite").width = suddenGrid:GetComponent("UIGrid").cellWidth * (#suddenData)+80;
        suddenGrid:GetComponent("UIGrid"):Reposition();

    end


end

--设置中途四喜中的一个元素
function this.setSuddenItem(suddenItemData,setObj)
    if (not suddenItemData) or (not setObj) then
        print("invalid data in setSuddenItem,");
        return ;
    end

    --保存数据
    SetUserData(setObj,suddenItemData);
    --起手胡的牌放进去
    for i = 1, #suddenItemData.plates do
        local cardItem = setObj.transform:Find("chuPaiShow"..i);
        cardItem:Find("card"):GetComponent("UISprite").spriteName = suddenItemData.plates[i];
        cardItem:GetComponent("UISprite").spriteName = panelInGamemj.getColorCardName("mj_01",panelInGamemj.GetCardColor());
    end

    setObj:SetActive(true);
end


--点击某个中途起手胡
function this.OnClickSuddenItem(obj)
    local suddenItemData = GetUserData(obj);
    this.SendSuddenMsg(suddenItemData);
end


function this.OnClickMask(obj)
    gameObject:SetActive(false);
    panelInGame.RefreshOperationSend(panelInGame.GetPlayerDataByUIIndex(0).operations,"zthu");--获取我的信息
end


--向服务器发送消息
function this.SendSuddenMsg(suddenItemData)
    print("SendSuddenMsg was called");
    local msg = Message.New();
    msg.type = csm_pb.ZT_HU;
    local msgBody = csm_pb.POperation();
    msgBody.mahjong = suddenItemData.op_plate;
    table.insert(msgBody.mahjongs,suddenItemData.op_mahjong);
    msg.body = msgBody:SerializeToString();
    SendGameMessage(msg, nil)
    PanelManager.Instance:HideWindow(gameObject.name);


end






