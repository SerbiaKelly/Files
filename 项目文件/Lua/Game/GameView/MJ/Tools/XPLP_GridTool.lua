require("class");
require("const");
require("xplp_pb");
require("XPLP_Tools");

XPLP_GridTool = class();
local this = XPLP_GridTool;
local uiLayer = nil;


--gridHand      溆浦老牌手牌grid
--gridXi        溆浦老牌吃碰grid
--gridThrow     溆浦老牌已出牌grid
--gridMo        溆浦摸牌grid
--posIndex      玩家位置信息，逆时针有1，2，3，4这4个位置
--callBacktable 回调函数，主要是一些手牌的点击拖拽回调
function XPLP_GridTool:ctor(gridHand,gridXi,gridThrow,gridMo,chuPaiShow,posIndex,callBacktable,extraParameter)
    self.posIndex       = posIndex;
    self.gridHand       = gridHand;
    self.gridXi         = gridXi;
    self.gridThrow      = gridThrow;
    self.gridMo         = gridMo;
    self.chuPaiShow     = chuPaiShow;
    uiLayer             = extraParameter.uiLayer; 
    if callBacktable ~= nil then --其实只有自己的角度才会有操作，就是拿着手机的你的位置
       
        self.OnDragStartPlate       = callBacktable.OnDragStartPlate;
        self.OnDragEndtPlate        = callBacktable.OnDragEndtPlate;
        self.OnDoubleClickPlate     = callBacktable.OnDoubleClickPlate;
        self.OnClickMahjong         = callBacktable.OnClickMahjong;
        self.OnDragging             = callBacktable.OnDragging;
        self.OnPressMahJong         = callBacktable.OnPressMahJong;
        self.OnClickOutMahjong      = callBacktable.OnClickOutMahjong;
        self.OnClickXiMahjong       = callBacktable.OnClickXiMahjong;
    end
end


--刷新手牌grid，填充数据
function XPLP_GridTool:RefreshGridHand(plates,mahjongCount)
    -- body
    if plates == nil then 
        return ;
    end
   
    if self.posIndex == 0 then 
        table.sort(plates, tableSortAsc);
        print("plates.length:"..(#plates)..",mahjongCount:"..mahjongCount);
    else
        return;--溆浦老牌只有自己展示手牌，其他人展示剩余牌
    end
    local prefabName = CONST.XPLPCardhandPrefabName[self.posIndex+1];
    for i=self.gridHand.childCount,mahjongCount-1 do
        local cardObj   = ResourceManager.Instance:LoadAssetSync(prefabName);
        local obj       = NGUITools.AddChild(self.gridHand.gameObject, cardObj);
        obj.name        = prefabName..i;
        if self.posIndex == 0 then 
            -- obj:GetComponent('UISprite').depth = 30-i;
            -- obj.transform:Find('card'):GetComponent('UISprite').depth = 30-i+1;
            --为自己的手牌添加事件
            UIEventListener.Get(obj.gameObject).onDragStart     = self.OnDragStartPlate;
			UIEventListener.Get(obj.gameObject).onDrag          = self.OnDragging;
			UIEventListener.Get(obj.gameObject).onDragEnd       = self.OnDragEndtPlate;
			UIEventListener.Get(obj.gameObject).onDoubleClick   = self.OnDoubleClickPlate;
			UIEventListener.Get(obj.gameObject).onClick         = self.OnClickMahjong;
			UIEventListener.Get(obj.gameObject).onPress         = self.OnPressMahJong;
        end
    end
    --设置gridHand的布局
    -- this.SetHandGridLayOut(self.gridHand,self.posIndex,uiLayer:GetGameLogic().totalSize);
    --牌面赋值
    for i=0,self.gridHand.childCount -1 do
        if i < mahjongCount then 
            local cardItem = self.gridHand:GetChild(i);
            cardItem.name = prefabName..i;
            cardItem.gameObject:SetActive(true);
            local cardItemBG = cardItem:Find("cardbg"):GetComponent("UISprite");
            local cardItemPlate = cardItem:Find("card"):GetComponent("UISprite");
            local graybg = cardItem:Find("gray");
            -- print("getcardText:"..uiLayer:getcardText()..",posIndex:"..self.posIndex);
            if self.posIndex == 0 then 
                SetUserData(cardItem.gameObject, plates[i+1]);
                cardItemPlate.gameObject:SetActive(true);
                cardItemPlate.spriteName = plates[i+1];
                --箍臭处理
                local logic = uiLayer:GetGameLogic();
                local myData = logic:GetPlayerDataBySeat(logic.mySeat);
                graybg.gameObject:SetActive(myData.guChou == 1);
                graybg.parent:GetComponent("BoxCollider").enabled = uiLayer:GetGameLogic():CanChuPai() and not(myData.guChou == 1);
                if myData.guChou == 1 then 
                    this.SetHandPlateDepth(self.gridHand,cardItem.gameObject,self.posIndex,i);
                end

            else
                cardItemPlate.gameObject:SetActive(false);
                SetUserData(cardItem.gameObject, nil);
            end
        else
            self.gridHand:GetChild(i).gameObject:SetActive(false);--这些是多出来的，隐藏起来
        end
    end
    self.gridHand:GetComponent("UIGrid"):Reposition();
end


--刷新吃碰杠补,填充数据
function XPLP_GridTool:RefreshGridXi(operationCards)
    print("operationCards.length="..(#operationCards));
    if not operationCards then 
        return ;
    end
    local xiItemPrefabName = CONST.XPLPXiPrefabName[self.posIndex+1];
    print("xiItemPrefabName:"..xiItemPrefabName);
    local xiGridData = this.GetXiGridData(operationCards);
    for i=self.gridXi.childCount,#xiGridData-1 do
       
        local xiLocalObj = ResourceManager.Instance:LoadAssetSync(xiItemPrefabName);
        local obj  = NGUITools.AddChild(self.gridXi.gameObject, xiLocalObj);
        print("create new xi item------obj:"..tostring(obj));
        if self.posIndex == 0 then 
            obj.transform.localScale = Vector3.New(0.9,0.9,1);
        end
        UIEventListener.Get(obj.gameObject).onClick  = self.OnClickXiMahjong;
    end
    --对喜牌进行赋值
    for i=0,self.gridXi.childCount -1 do
        if i < #xiGridData then 
            local group = xiGridData[i+1];
            local xiItem = self.gridXi:GetChild(i);
            for j=0,xiItem.childCount-1 do
                if j < #group.plates then 
                    xiItem:GetChild(j):Find("card"):GetComponent("UISprite").spriteName = uiLayer:GetCardTextName(group.plates[j+1],uiLayer:getcardText());
                    xiItem:GetChild(j):Find("gray").gameObject:SetActive(group.operation == xplp_pb.CHI and j == 0);
                    xiItem:GetChild(j).gameObject:SetActive(true);
                    SetUserData(xiItem:GetChild(j).gameObject,group.plates[j+1]);
                else
                    xiItem:GetChild(j).gameObject:SetActive(false);
                end
            end
            xiItem.gameObject:SetActive(true);
        else
            self.gridXi:GetChild(i).gameObject:SetActive(false);
        end
    end
    self.gridXi:GetComponent("UIGrid"):Reposition();
end

--刷新打出去的牌，填充数据
function XPLP_GridTool:RefreshGridThrow(plates)
    print("RefreshGridThrow--------------> plates.length="..#plates..",self.posIndex="..self.posIndex);
    if not plates then 
        return ;
    end
    local throwDataPrefabName = CONST.XPLPThrowPrefabName[self.posIndex+1];
    -- print("throwDataPrefabName:------------------");
    -- print_r(throwDataPrefabName);
    for i=self.gridThrow.childCount,#plates-1 do
        local throwLocalObj = ResourceManager.Instance:LoadAssetSync(throwDataPrefabName);
        -- local rot = throwLocalObj.transform.localRotation;
        local obj = NGUITools.AddChild(self.gridThrow.gameObject, throwLocalObj);
        -- obj.transform.localRotation = rot;
        UIEventListener.Get(obj.gameObject).onClick         = self.OnClickOutMahjong;
        print("self.OnClickOutMahjon is nil:"..tostring(self.OnClickOutMahjong == nil));
    end
    --设置牌桌上已出牌的排版，2人跟[3,4]人的排版时不同的
    for i=0,self.gridThrow.childCount-1 do
        if i < #plates then 
            local throwItem             = self.gridThrow:GetChild(i);
            local cardItemPlate         = throwItem:Find("card"):GetComponent("UISprite");
            cardItemPlate.spriteName    = uiLayer:GetOutCardTextName(plates[i+1],uiLayer:getcardText());
            cardItemPlate.gameObject:SetActive(true);
            SetUserData(throwItem.gameObject,plates[i+1]);
            -- this.SetThrowPlateDepth(self.gridThrow,throwItem.gameObject,self.posIndex,i);
            throwItem.gameObject:SetActive(true);
            uiLayer:SetPlateColor(throwItem.gameObject,false);
        else
            self.gridThrow:GetChild(i).gameObject:SetActive(false);
        end
    end

    self.gridThrow:GetComponent("UIGrid"):Reposition();

end

--设置牌面的各种排版
function XPLP_GridTool:SetLayOut()
    self:SetThrowGridLayOut(self.gridThrow,self.posIndex,uiLayer:GetGameLogic().totalSize);
end

--根据人数对牌桌上的牌的grid要重新布局，比如两个人的时候，坐在0，2的位置。那么牌桌上已出的牌，每行可以多排更多的牌
function XPLP_GridTool:SetThrowGridLayOut(gridThrow,posIndex,playerSize)
    local gameUIObjects = uiLayer:GetgameUIObjects();
    local grid = gridThrow:GetComponent("UIGrid");
    if playerSize == 2 then 
        if posIndex == 0 then 
            grid.maxPerLine = 26;
            gridThrow.localPosition = Vector3(-468,-113,0);
        elseif posIndex == 2 then 
            grid.maxPerLine = 26;
            gridThrow.localPosition = Vector3(395,136,0);
        end
    else
        if posIndex == 0 or posIndex == 2  then 
            grid.maxPerLine = 13;
        end
        gridThrow.localPosition = gameUIObjects.playerTableThrowGridPos[posIndex + 1];
    end
end



--刷新摸的牌，填充数据
function XPLP_GridTool:RefreshMoPai(plate)
   
    if plate == -1 or not plate then -- 当前玩家没有摸牌
        return ;
    end
    -- print("RefreshMoPai-------------->:"..plate);
    
    local cardItemPlate     = self.gridMo:GetChild(0):Find("card"):GetComponent("UISprite");
    if self.posIndex == 0 then 
        SetUserData(self.gridMo:GetChild(0).gameObject,plate);
        cardItemPlate.spriteName                = uiLayer:GetCardTextName(plate,uiLayer:getcardText());
        cardItemPlate.gameObject:SetActive(true);
        self.gridMo:GetChild(0).localPosition = Vector3.New(0,0,0);
        
        --为自己的摸牌牌添加事件
        UIEventListener.Get(self.gridMo:GetChild(0).gameObject).onDragStart     = self.OnDragStartPlate;
		UIEventListener.Get(self.gridMo:GetChild(0).gameObject).onDrag          = self.OnDragging;
		UIEventListener.Get(self.gridMo:GetChild(0).gameObject).onDragEnd       = self.OnDragEndtPlate;
		UIEventListener.Get(self.gridMo:GetChild(0).gameObject).onDoubleClick   = self.OnDoubleClickPlate;
		UIEventListener.Get(self.gridMo:GetChild(0).gameObject).onClick         = self.OnClickMahjong;
		UIEventListener.Get(self.gridMo:GetChild(0).gameObject).onPress         = self.OnPressMahJong;
        
    else
        cardItemPlate.gameObject:SetActive(false);
    end
end


function XPLP_GridTool:RefreshChuPai(plate)
    local cardItemPlate         = self.chuPaiShow:Find("card"):GetComponent("UISprite");
    cardItemPlate.spriteName    = uiLayer:GetCardTextName(plate,uiLayer:getcardText());
    self:SetChuPaiVisible(true);
    StartCoroutine(function() 
        WaitForSeconds(1);
        self:SetChuPaiVisible(false);
    end);
    
end

function XPLP_GridTool:HideAllChuPai()

end


function XPLP_GridTool:SetGridHandVisible(enable)
    self.gridHand.gameObject:SetActive(enable);
end

function XPLP_GridTool:SetGridThrowVisible(enable)
    self.gridThrow.gameObject:SetActive(enable);
end

function XPLP_GridTool:SetGridMoVisible(enable)
    self.gridMo.gameObject:SetActive(enable);
    if self.gridMo:Find("curMoPai").gameObject.activeSelf == false then 
        self.gridMo:Find("curMoPai").gameObject:SetActive(enable);
    end
end

function XPLP_GridTool:SetGridXiVisible(enable)
    self.gridXi.gameObject:SetActive(enable);
end

function XPLP_GridTool:SetChuPaiVisible(enable)
    self.chuPaiShow.gameObject:SetActive(enable);
end

function XPLP_GridTool:HideAllGrid()
    self:SetGridHandVisible(false);
    self:SetGridThrowVisible(false);
    self:SetGridMoVisible(false);
    self:SetGridXiVisible(false);
    self:SetChuPaiVisible(false);
end

function XPLP_GridTool:ShowAllGrid()
    self:SetGridHandVisible(true);
    self:SetGridThrowVisible(true);
    self:SetGridMoVisible(true);
    self:SetGridXiVisible(true);
    self:SetChuPaiVisible(true);
end


function this.GetXiGridData(operationCards)
    if not operationCards then 
        return {};
    end
    local xiGridData = {};
    for i=1,#operationCards do
        local operation_type = operationCards[i].operation;
        local op_cards = operationCards[i].cards;
        if operation_type == xplp_pb.SORT_CHI then 
            table.insert( xiGridData, {operation = xplp_pb.CHI,plates = {op_cards[1],op_cards[2],op_cards[3]}} );
        elseif operation_type == xplp_pb.SORT_PENG then 
            table.insert(xiGridData, {operation = xplp_pb.PENG, plates={op_cards[1],op_cards[1],op_cards[1]}});
        end
    end

    return xiGridData;

end


--根据位置信息，设置已出牌的深度信息
function this.SetThrowPlateDepth(gridThrow,itemObject,posIndex,index)
    if posIndex == 0 then --bottom
        if index > gridThrow:GetComponent('UIGrid').maxPerLine-1 then
            local maxPerLine = gridThrow:GetComponent('UIGrid').maxPerLine;
            itemObject:GetComponent('UISprite').depth = 5- math.floor(index/maxPerLine)+10;
        else
            itemObject:GetComponent('UISprite').depth = 5+10;
        end
        itemObject.transform:Find("card"):GetComponent("UISprite").depth = itemObject:GetComponent('UISprite').depth +1;
    elseif posIndex == 2 then 
        itemObject:GetComponent('UISprite').depth = 10;
        itemObject.transform:Find('card'):GetComponent('UISprite').depth = 11;
    elseif posIndex == 1 then --right
        itemObject:GetComponent('UISprite').depth = 50-index-1;
		itemObject.transform:Find('card'):GetComponent('UISprite').depth = 50-index;
    elseif posIndex == 3 then --left
        itemObject:GetComponent('UISprite').depth = index+2;
		itemObject.transform:Find('card'):GetComponent('UISprite').depth = index+3;
    end
end

--当箍臭的时候，设置手牌的图片的深度信息
function this.SetHandPlateDepth(gridHand,itemObject,posIndex,index)
    if posIndex == 0 then --bottom
        local cardbg        = itemObject.transform:Find("cardbg"):GetComponent('UISprite');
        local gray          = itemObject.transform:Find("gray"):GetComponent("UISprite");
        local cardItemPlate = itemObject.transform:Find("card"):GetComponent("UISprite");
        local tingTip       = itemObject.transform:Find("tingTip"):GetComponent("UISprite");
        if index > gridHand:GetComponent('UIGrid').maxPerLine-1 then
            local maxPerLine    = gridHand:GetComponent('UIGrid').maxPerLine;
            cardbg.depth        = 14 - math.floor(index/maxPerLine)*4;
        else
            cardbg.depth = 14;
        end
        cardItemPlate.depth = cardbg.depth +1;
        gray.depth          = cardItemPlate.depth +1;
        tingTip.depth       = gray.depth +1;
        cardItemPlate.depth = cardbg.depth +1;
    elseif posIndex == 2 then 
       
    elseif posIndex == 1 then --right
        
    elseif posIndex == 3 then --left
        
    end
end



