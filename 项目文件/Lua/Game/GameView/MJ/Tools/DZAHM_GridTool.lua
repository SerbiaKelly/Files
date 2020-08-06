require("const");
require("dzm_pb");
require("DZAHM_Tools");
DZAHM_GridTool  = {};
DZAHM_GridTool  = class();
local this      = DZAHM_GridTool;
local uiLayer   = nil;


--gridHand      麻将手牌grid
--gridXi        麻将吃碰杠补grid
--gridThrow     麻将已出牌grid
--gridMo        麻将摸牌grid
--posIndex      玩家位置信息，逆时针有1，2，3，4这4个位置
--callBacktable 回调函数，主要是一些手牌的点击拖拽回调
function DZAHM_GridTool:ctor(gridHand,gridXi,gridThrow,gridMo,chuPaiShow,posIndex,callBacktable,extraParameter)
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
    end
end


--刷新手牌grid，填充数据
function DZAHM_GridTool:RefreshGridHand(plates,mahjongCount)
    -- body
    if plates == nil then 
        return ;
    end
    if self.posIndex == 0 then 
        table.sort(plates, tableSortDesc);
        --处理混牌
        local hunPlatesCount = {};
        local hunPlates = uiLayer:GetHunPlates();
        table.sort( hunPlates, tableSortDesc );
        for i=1,#hunPlates do
            hunPlatesCount[hunPlates[i]] = GetMJPlateCount(plates,hunPlates[i]);
        end
        for i=1,#hunPlates do
            tableRemoveByKeys(plates,getRemoveKeys({hunPlates[i]}));
        end
      
		for plate,Count in pairs(hunPlatesCount) do
            for i=1,Count do
                tableAdd(plates,{plate});
            end
        end
    else
        table.sort(plates,tableSortAsc);
    end
    local prefabName = CONST.cardPrefabHand[self.posIndex+1];
    for i=self.gridHand.childCount,mahjongCount-1 do
        local cardObj   = ResourceManager.Instance:LoadAssetSync(prefabName);
        local obj       = NGUITools.AddChild(self.gridHand.gameObject, cardObj);
        obj.name        = prefabName..i;
        if self.posIndex == 0 then 
            obj:GetComponent('UISprite').depth = 30-i;
            obj.transform:Find('card'):GetComponent('UISprite').depth = 30-i+1;
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
    self.gridHand:GetComponent("UIGrid").cellWidth  = CONST.cardPrefabHandStandGridCell[self.posIndex+1].x;
    self.gridHand:GetComponent("UIGrid").cellHeight = CONST.cardPrefabHandStandGridCell[self.posIndex+1].y;
    for i=0,self.gridHand.childCount -1 do
        if i < mahjongCount then 
            local cardItem = self.gridHand:GetChild(i);
            cardItem.name = prefabName..i;
            cardItem.gameObject:SetActive(true);
            local cardItemBG = cardItem:GetComponent("UISprite");
            local cardItemPlate = cardItem:Find("card"):GetComponent("UISprite");
            --设置麻将牌的背板类型，目前有黄色和绿色,而且只有自己的派才能看到牌面，别人是看不到的，没有牌面值，服务器也不会传过来
            cardItemBG.spriteName = uiLayer:getColorCardName(CONST.cardPrefabHandStandBg[self.posIndex+1],uiLayer:getCardColor());
            -- print("getcardText:"..uiLayer:getcardText()..",posIndex:"..self.posIndex);
            if self.posIndex == 0 then 
                cardItemBG.transform:GetComponent("BoxCollider").enabled = true;
                cardItemPlate.spriteName = uiLayer:GetCardTextName(plates[i+1],uiLayer:getcardText());
                SetUserData(cardItem.gameObject, plates[i+1]);
                cardItemPlate.transform.localPosition = CONST.cardPrefabHandStandOffset[self.posIndex+1];
                cardItemPlate.width     = uiLayer:GetCardPlateSize(plates[i+1],uiLayer:getcardText()).x;
                cardItemPlate.height    = uiLayer:GetCardPlateSize(plates[i+1],uiLayer:getcardText()).y;
                cardItemPlate.gameObject:SetActive(true);
                cardItemBG.depth = 51;
                cardItemPlate.depth = 52;--这里之所以设置为这个深度，是因为点击手牌的时候，上移的手牌要在右边位置的玩家出牌的上面
                --混牌检测
                local hunPlates = uiLayer:GetHunPlates();
                cardItem:Find("mark").gameObject:SetActive(false);
                for j=1,#hunPlates do
                    if plates[i+1] == hunPlates[j] then 
                        cardItem:Find("mark").gameObject:SetActive(true);
                        cardItem:Find("mark/marklabel"):GetComponent("UILabel").text = "王";
                    else
                        
                    end
                    cardItem:Find("mark").transform.localPosition = Vector3.New(-14.9,18.5,0);
                end
                
            else
                cardItemPlate.gameObject:SetActive(false);
            end

            --右手边位置玩家的牌需要设置一下层级，不然会有问题
            if self.posIndex == 1 then 
                cardItemBG.depth = 20 - i;
                cardItemPlate.depth = 20 - i + 1;
            end

            if self.posIndex ~= 0 then 
                cardItemBG:MakePixelPerfect();
            end

        else
            self.gridHand:GetChild(i).gameObject:SetActive(false);--这些是多出来的，隐藏起来
        end
    end
    self.gridHand:GetComponent('UIGrid').cellWidth  = CONST.cardPrefabHandStandGridCell[self.posIndex+1].x;
    self.gridHand:GetComponent('UIGrid').cellHeight = CONST.cardPrefabHandStandGridCell[self.posIndex+1].y;
    self.gridHand:GetComponent("UIGrid"):Reposition();
    local gridMoPos,gridMoScale = this.GetGridMoPos(self.gridHand,self.gridMo,self.posIndex,mahjongCount);
	self.gridMo.localPosition = gridMoPos;--让摸牌跟手牌上下对齐[处于同一排]
	self.gridMo.localScale = gridMoScale;--让摸牌跟手牌上下对齐[处于同一排]
	--清除手牌的颜色
	if self.posIndex == 0 then
		-- uiLayer.SetPlateUIColor(self.gridHand, {}, false);
	end

end

function this.GetGridMoPos(gridHand,gridMo, posIndex,mahjongCount)
    local pos               = gridHand.localPosition;
	local gridcellWidth     = gridHand:GetComponent('UIGrid').cellWidth;
    local gridcellHeight    = gridHand:GetComponent('UIGrid').cellHeight;
    local scale =  Vector3(1.0,1.0,1.0);
    if posIndex == 0 then 
        scale = DZAHM_Tools.IfNeedAutoLayOut() and Vector3(FitScale, FitScale, 1) or Vector3(1.0,1.0,1.0);
    end
	if posIndex == 0 then
		pos.y = gridHand.localPosition.y;
		pos.x = DZAHM_Tools.IfNeedAutoLayOut() and 574*FitScale or gridMo.localPosition.x;
	elseif posIndex == 1 then
		pos.y = gridHand.localPosition.y - (gridcellHeight * mahjongCount) + gridcellHeight*0.5  + 50
	elseif posIndex == 2 then
		pos.x = gridHand.localPosition.x - (gridcellWidth * mahjongCount) + gridcellWidth*0.5 - 12
	else
		pos.y = gridHand.localPosition.y - (gridcellHeight * mahjongCount) + gridcellHeight*0.5 - 50
	end
	return pos,scale;
end

function this.GetGridMoDownPos(gridHand,gridMo,posIndex,mahjongCount)
    local pos               = gridHand.localPosition;
	local gridcellWidth     = gridHand:GetComponent('UIGrid').cellWidth;
	local gridcellHeight    = gridHand:GetComponent('UIGrid').cellHeight;
	if posIndex == 0 then
		pos.y = gridHand.localPosition.y;
		pos.x = gridMo.localPosition.x;
	elseif posIndex == 1 then
		pos.y = gridHand.localPosition.y - (gridcellHeight * mahjongCount) + gridcellHeight*0.5 + 29;
	elseif posIndex == 2 then
        pos.x = gridHand.localPosition.x - (gridcellWidth * mahjongCount) + gridcellWidth*0.5 - 8 ;
    else
		pos.y = gridHand.localPosition.y - (gridcellHeight * mahjongCount) + gridcellHeight*0.5 - 29;
	end
	return pos;
end

--刷新吃碰杠补,填充数据
function DZAHM_GridTool:RefreshGridXi(operationCards)
    print("已完成操作个数" .. #operationCards)
    if not operationCards then 
        return ;
    end
    local xiParameter = this.GetXiParameter(self.posIndex);
    local xiGridData = this.GetXiGridData(operationCards);
    for i=self.gridXi.childCount,#xiGridData-1 do
        local xiLocalObj = ResourceManager.Instance:LoadAssetSync(xiParameter.prefabName);
        local obj  = NGUITools.AddChild(self.gridXi.gameObject, xiLocalObj);
    end
    --对喜牌进行赋值
    for i=0,self.gridXi.childCount -1 do
        if i < #xiGridData then 
            local group = xiGridData[i+1];
            local xiItem = self.gridXi:GetChild(i);
            for j=0,xiItem.childCount-1 do
                if j < #group.plates then 
                    --判断杠牌类型 --明杠：下面三张，上面一张，四张全部正面朝上 点杠：下面三张朝上，上面一张朝下 暗杠：下面三张朝下，上面一张朝上
                    local show = true;
                    if j < 3 then --下面三张盖住，上面那张展示
                        if group.state == dzm_pb.AN then 
                            show = false;
                        end
                    else--下面三张展示，上面那张盖住
                        if group.state == dzm_pb.MING then 
                            show = false;
                        end
                    end
                    if not show then 
                        xiItem:GetChild(j):GetComponent("UISprite").spriteName = uiLayer:getColorCardName(xiParameter.downSpriteName,uiLayer:getCardColor());
                        xiItem:GetChild(j):GetChild(0).gameObject:SetActive(false);
                    else
                        xiItem:GetChild(j):GetComponent("UISprite").spriteName = uiLayer:getColorCardName(xiParameter.upSpriteName,uiLayer:getCardColor());
                        xiItem:GetChild(j):GetChild(0):GetComponent("UISprite").spriteName = uiLayer:GetCardTextName(group.plates[j+1],uiLayer:getcardText());
                        xiItem:GetChild(j):GetChild(0).gameObject:SetActive(true);
                    end
                    xiItem:GetChild(j).gameObject:SetActive(true);
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

    if self.posIndex == 0 then 
        self.gridXi.localScale = DZAHM_Tools.IfNeedAutoLayOut() and Vector3(FitScale, FitScale, 1) or Vector3(1.0,1.0,1.0);
        self.gridXi.localPosition = DZAHM_Tools.IfNeedAutoLayOut() and Vector3(-636-FitOffset, -315, 0) or Vector3(-638,-314.9,0);
    elseif self.posIndex ==1 then 
        self.gridXi.localPosition = DZAHM_Tools.IfNeedAutoLayOut() and Vector3(594,-160,0) or Vector3(526,-160.9,0);
    elseif self.posIndex ==3 then 
        self.gridXi.localPosition = DZAHM_Tools.IfNeedAutoLayOut() and Vector3(-595,287,0) or Vector3(-529.6,287,0);
    end

    if self.posIndex ~= 0 then 
        self.gridHand.localPosition = this.GetGridHandPos(self.gridXi,self.gridHand,self.posIndex,xiGridData);
    end

end

function this.GetGridHandPos(gridXi,gridHand,posIndex,xiGridData)
    
    local pos               = gridHand.localPosition;
    local gridcellWidth     = gridXi:GetComponent('UIGrid').cellWidth;
    local gridcellHeight    = gridXi:GetComponent('UIGrid').cellHeight;
    local gameUIObjects     = uiLayer:GetgameUIObjects();
    if posIndex == 0 then 

    elseif posIndex == 1 then 
        if #xiGridData > 0 then 
            pos.y = gridXi.localPosition.y + (gridcellHeight*#xiGridData) - gridcellHeight*0.5 + 20;
            pos.x = DZAHM_Tools.IfNeedAutoLayOut() and 607.3 or gameUIObjects.playerHandGridPos[posIndex+1].x;
        else
            pos = DZAHM_Tools.IfNeedAutoLayOut() and Vector3(607.3,-146,0) or  gameUIObjects.playerHandGridPos[posIndex+1];
        end
    elseif posIndex == 2 then 
        if #xiGridData > 0 then 
            pos.x = gridXi.localPosition.x - gridcellWidth * (#xiGridData) + 110;--不要去想110怎么来的，对着界面一点一点调出来的
        else
            pos = gameUIObjects.playerHandGridPos[posIndex+1];
        end
    else
        if #xiGridData > 0 then 
            pos.y = gridXi.localPosition.y - (gridcellHeight*(#xiGridData)) + gridcellHeight*0.5-45;
            pos.x = DZAHM_Tools.IfNeedAutoLayOut() and -610 or gameUIObjects.playerHandGridPos[posIndex+1].x;
        else
            pos = DZAHM_Tools.IfNeedAutoLayOut() and Vector3(-610,265,0) or  gameUIObjects.playerHandGridPos[posIndex+1];
        end
    end
    -- print("GetGridHandPos was called..posIndex="..posIndex..",pos="..tostring(pos));
    return pos;
end

--刷新打出去的牌，填充数据
function DZAHM_GridTool:RefreshGridThrow(plates)
    if not plates then 
        return ;
    end
    local throwData = this.GetThrowParameter(self.posIndex);
    -- print("throwData:------------------");
    -- print_r(throwData);
    for i=self.gridThrow.childCount,#plates-1 do
        local throwLocalObj = ResourceManager.Instance:LoadAssetSync(throwData.prefabName);
        local rot = throwLocalObj.transform.localRotation;
        local obj = NGUITools.AddChild(self.gridThrow.gameObject, throwLocalObj);
        obj.transform.localRotation = rot;
    end
    --设置牌桌上已出牌的排版，2人跟[3,4]人的排版时不同的
    for i=0,self.gridThrow.childCount-1 do
        if i < #plates then 
            local throwItem             = self.gridThrow:GetChild(i);
            local cardItemBG            = throwItem:GetComponent("UISprite");
            local cardItemPlate         = throwItem:Find("card"):GetComponent("UISprite");
            cardItemBG.spriteName       = uiLayer:getColorCardName(CONST.cardPrefabHandDownBg[self.posIndex+1],uiLayer:getCardColor());
            cardItemPlate.spriteName    = uiLayer:GetCardTextName(plates[i+1],uiLayer:getcardText());
            cardItemPlate.gameObject:SetActive(true);
            uiLayer:SetPlateColor(throwItem.gameObject,false);
            SetUserData(throwItem.gameObject,plates[i+1]);
            this.SetThrowPlateDepth(self.gridThrow,throwItem.gameObject,self.posIndex,i);
            throwItem.gameObject:SetActive(true);
        else
            self.gridThrow:GetChild(i).gameObject:SetActive(false);
        end
    end

    self.gridThrow:GetComponent("UIGrid"):Reposition();

end

--将已出的牌盖起来
function DZAHM_GridTool:CoverGridThrow()
    if self.gridThrow == nil then 
        print("CoverGridThrow gridThrow is nil");
        return;
    end
   
    for i=0,self.gridThrow.childCount - 1 do
        local throwItem = self.gridThrow:GetChild(i);
        if throwItem.gameObject.activeInHierarchy then --展示的才给盖牌
            local cardItemBG = throwItem:GetComponent("UISprite");
            local cardItemPlate = throwItem:Find("card"):GetComponent("UISprite");
            cardItemPlate.gameObject:SetActive(false);
            cardItemBG.spriteName = uiLayer:getColorCardName(CONST.cardPrefabPaiHeCoverBg[self.posIndex+1],uiLayer:getCardColor());
        end
    end

end

--刷新摸的牌，填充数据
function DZAHM_GridTool:RefreshMoPai(plate)
   
    if plate == -1 or not plate then -- 当前玩家没有摸牌
        return ;
    end
    -- print("RefreshMoPai-------------->:"..plate);
    local cardItemBG        = self.gridMo:GetChild(0):GetComponent("UISprite");
    local cardItemPlate     = self.gridMo:GetChild(0):Find("card"):GetComponent("UISprite");
    cardItemBG.spriteName   = uiLayer:getColorCardName(CONST.cardPrefabHandStandBg[self.posIndex+1],uiLayer:getCardColor());
    cardItemBG.gameObject:SetActive(true);
    if self.posIndex == 0 then 
        SetUserData(cardItemBG.gameObject,plate);
        cardItemPlate.spriteName                = uiLayer:GetCardTextName(plate,uiLayer:getcardText());
        cardItemPlate.width                     = uiLayer:GetCardPlateSize(plate,uiLayer:getcardText()).x;
        cardItemPlate.height                    = uiLayer:GetCardPlateSize(plate,uiLayer:getcardText()).y;
        cardItemPlate.transform.localPosition   = CONST.cardPrefabHandStandOffset[self.posIndex+1];
        cardItemPlate.gameObject:SetActive(true);
        cardItemBG.transform.localPosition = Vector3.New(0,0,0);
        
        --为自己的摸牌牌添加事件
        UIEventListener.Get(self.gridMo:GetChild(0).gameObject).onDragStart     = self.OnDragStartPlate;
		UIEventListener.Get(self.gridMo:GetChild(0).gameObject).onDrag          = self.OnDragging;
		UIEventListener.Get(self.gridMo:GetChild(0).gameObject).onDragEnd       = self.OnDragEndtPlate;
		UIEventListener.Get(self.gridMo:GetChild(0).gameObject).onDoubleClick   = self.OnDoubleClickPlate;
		UIEventListener.Get(self.gridMo:GetChild(0).gameObject).onClick         = self.OnClickMahjong;
        UIEventListener.Get(self.gridMo:GetChild(0).gameObject).onPress         = self.OnPressMahJong;
        local cardMark = cardItemBG.transform:Find("mark");
        cardMark.gameObject:SetActive(false);
        local hunPlates = uiLayer:GetHunPlates();
        for i=1,#hunPlates do
            if cardMark ~= nil then 
                cardMark.localPosition = Vector3.New(-14.9,18.5,0);
                if plate == hunPlates[i] then 
                    cardMark.gameObject:SetActive(true);
                    cardMark:Find("marklabel"):GetComponent("UILabel").text = "王";
                    break;
                else
                    cardMark.gameObject:SetActive(false);
                end
            end
        end
        
    else
        cardItemPlate.gameObject:SetActive(false);
    end
    if self.posIndex ~= 0 then 
        cardItemBG:MakePixelPerfect();
    end
end

--摸牌的倒牌
function DZAHM_GridTool:MoPaiDown(plate,gridMahjongCount)
    self.gridMo.gameObject:SetActive(true);
    local cardItemBG = self.gridMo:GetChild(0):GetComponent("UISprite");
    local cardItemPlate = self.gridMo:GetChild(0):Find("card"):GetComponent("UISprite");
    cardItemBG.spriteName = uiLayer:getColorCardName(CONST.cardPrefabHandDownBg[self.posIndex+1],uiLayer:getCardColor());
    cardItemPlate.spriteName = uiLayer:GetCardTextName(plate,uiLayer:getcardText());
    cardItemPlate.transform.localPosition = CONST.cardPrefabHandDownOffset[self.posIndex+1];
    cardItemPlate.gameObject:SetActive(true);
    if self.posIndex ~= 0 then 
        cardItemBG.width = CONST.cardDownSize[self.posIndex+1].x;
        cardItemBG.height = CONST.cardDownSize[self.posIndex+1].y;
    else
        local cardMark = cardItemBG.transform:Find("mark");
        local hunPlates = uiLayer:GetHunPlates();
        for i=1,#hunPlates do
            if cardMark ~= nil then 
                cardMark.localPosition = Vector3.New(-18.61,42.9,0);
                if plate == hunPlates[i] then 
                    cardMark.gameObject:SetActive(true);
                    cardMark:Find("marklabel"):GetComponent("UILabel").text = "王";
                    break;
                else
                    cardMark.gameObject:SetActive(false);
                end
            end
        end
    end
    
    self.gridMo.localPosition = this.GetGridMoDownPos(self.gridHand,self.gridMo,self.posIndex,gridMahjongCount);
    
end



--手牌倒牌
function DZAHM_GridTool:GridHandPlatesDown(plates,downPlates)
    if plates == nil then 
        return ;
    end
    if self.posIndex == 0 then 
        table.sort(plates, tableSortDesc);
        --处理混牌
        local hunPlatesCount = {};
        local hunPlates = uiLayer:GetHunPlates();
        table.sort( hunPlates, tableSortDesc );
        for i=1,#hunPlates do
            hunPlatesCount[hunPlates[i]] = GetMJPlateCount(plates,hunPlates[i]);
        end
        for i=1,#hunPlates do
            tableRemoveByKeys(plates,getRemoveKeys({hunPlates[i]}));
        end
		for plate,Count in pairs(hunPlatesCount) do
            for i=1,Count do
                tableAdd(plates,{plate});
            end
        end
    else
        table.sort(plates,tableSortAsc);
    end
    self.gridHand:GetComponent("UIGrid").cellWidth  = CONST.cardPrefabHandDownGridCell[self.posIndex+1].x;
    self.gridHand:GetComponent("UIGrid").cellHeight = CONST.cardPrefabHandDownGridCell[self.posIndex+1].y;
    for i=1,#plates do
        local cardItem = self.gridHand:GetChild(i-1);
        cardItemBG = cardItem:GetComponent("UISprite");
        cardItemPlate = cardItem:Find("card"):GetComponent("UISprite");
        for j=#downPlates,1,-1 do
            if downPlates[j] == plates[i] then 
                cardItemBG.spriteName = uiLayer:getColorCardName(CONST.cardPrefabHandDownBg[self.posIndex+1],uiLayer:getCardColor());
                cardItemPlate.spriteName = uiLayer:GetCardTextName(downPlates[j],uiLayer:getcardText());
                cardItemPlate.gameObject:SetActive(true);
                cardItemPlate.transform.localPosition = CONST.cardPrefabHandDownOffset[self.posIndex+1];
                if self.posIndex ~= 0 then 
                    cardItemBG.width    = CONST.cardDownSize[self.posIndex+1].x;
                    cardItemBG.height   = CONST.cardDownSize[self.posIndex+1].y;
                end
                 --赖子检测
                local cardMark = cardItemBG.transform:Find("mark");
                -- print("cardItemBG----------------"..tostring(cardItemBG));
                -- print("cardMark----------------"..tostring(cardMark));
                local hunPlates = uiLayer:GetHunPlates();
                if cardMark ~= nil then 
                     cardMark.gameObject:SetActive(false);
                end
                for k = 1,#hunPlates do
                    if cardMark ~= nil then 
                        if downPlates[j] == hunPlates[k] then 
                            cardMark.gameObject:SetActive(true);
                            cardMark:Find("marklabel"):GetComponent("UILabel").text = "王";
                        else
                            
                        end
                        cardMark.localPosition = Vector3.New(-14.9,42.9,0);
                    end
                end
            end
        end
    end
    self.gridHand:GetComponent("UIGrid"):Reposition();
end

function DZAHM_GridTool:RefreshChuPai(plate)
    self.chuPaiShow.gameObject:SetActive(true);
    local cardItemBG            = self.chuPaiShow:GetComponent("UISprite");
    local cardItemPlate         = self.chuPaiShow:Find("card"):GetComponent("UISprite");
    cardItemBG.spriteName       = uiLayer:getColorCardName("mj_02",uiLayer:getCardColor());
    cardItemPlate.spriteName    = uiLayer:GetCardTextName(plate,uiLayer:getcardText());
    cardItemPlate.width         = uiLayer:GetCardPlateSize(plate,uiLayer:getcardText()).x;
    cardItemPlate.height        = uiLayer:GetCardPlateSize(plate,uiLayer:getcardText()).y;
    cardItemPlate.gameObject:SetActive(true);
    StartCoroutine(function() 
        WaitForSeconds(1);
        self.chuPaiShow.gameObject:SetActive(false);
    end);

end

--盖住出牌
function DZAHM_GridTool:CoverChupai()
    self.chuPaiShow.gameObject:SetActive(true);
    local cardItemBG            = self.chuPaiShow:GetComponent("UISprite");
    local cardItemPlate         = self.chuPaiShow:Find("card"):GetComponent("UISprite");
    cardItemBG.spriteName       = uiLayer:getColorCardName("mj_03",uiLayer:getCardColor());
    cardItemPlate.gameObject:SetActive(false);
    StartCoroutine(function() 
        WaitForSeconds(1);
        self.chuPaiShow.gameObject:SetActive(false);
    end);
end

function DZAHM_GridTool:SetGridHandVisible(enable)
    self.gridHand.gameObject:SetActive(enable);
end

function DZAHM_GridTool:SetGridThrowVisible(enable)
    self.gridThrow.gameObject:SetActive(enable);
end

function DZAHM_GridTool:SetGridMoVisible(enable)
    self.gridMo.gameObject:SetActive(enable);
end

function DZAHM_GridTool:SetGridXiVisible(enable)
    self.gridXi.gameObject:SetActive(enable);
end

function DZAHM_GridTool:HideAllGrid()
    self:SetGridHandVisible(false);
    self:SetGridThrowVisible(false);
    self:SetGridMoVisible(false);
    self:SetGridXiVisible(false);
end

function DZAHM_GridTool:ShowAllGrid()
    self:SetGridHandVisible(true);
    self:SetGridThrowVisible(true);
    self:SetGridMoVisible(true);
    self:SetGridXiVisible(true);
end

--根据位置获取吃碰杠补的预制加载项，牌面和牌背等Sprite信息[盖住的牌，翻过来的牌都用的时哪些图片资源名称]
function this.GetXiParameter(posIndex)
    local data          = {};
    data.prefabName     = "cardZuoButtom";
    data.downSpriteName = "mj_04";
    data.upSpriteName   = "mj_01";
    if posIndex == 0 then 
        data.prefabName     = "cardZuoButtom";
        data.downSpriteName = "mj_04";
        data.upSpriteName   = "mj_01";
    elseif posIndex == 1 then 
        data.prefabName = "cardZuoRight";
        data.downSpriteName = "mj_08";
        data.upSpriteName = "mj_07";
    elseif posIndex == 2 then 
        data.prefabName = "cardZuoTop";
        data.downSpriteName = "mj_04";
        data.upSpriteName = "mj_09";
    else
        data.prefabName = "cardZuoLeft";
        data.downSpriteName = "mj_08";
        data.upSpriteName = "mj_07";
    end

    return data;
end

--根据位置获取牌桌上牌的预制加载项
function this.GetThrowParameter(posIndex)
    local data = {};
    data.prefabName = "cardPaiHeButtom";
    if posIndex == 0 then 
        data.prefabName = "cardPaiHeButtom";
    elseif posIndex == 1 then 
        data.prefabName = "cardPaiHeRight";
    elseif posIndex == 2 then 
        data.prefabName = "cardPaiHeTop";
    else
        data.prefabName = "cardPaiHeLeft";
    end
    return data;
end

function this.GetXiGridData(operationCards)
    if not operationCards then 
        return {};
    end
    local xiGridData = {};
    for i=1,#operationCards do
        local operation_type = operationCards[i].operation;
        local op_cards = operationCards[i].cards;
        if operation_type == dzm_pb.SORT_CHI then 
            table.insert( xiGridData, {operation == dzm_pb.CHI,plates = {op_cards[1] , op_cards[2], op_cards[3]}} );
        elseif operation_type == dzm_pb.SORT_PENG then 
            table.insert(xiGridData, {operation = dzm_pb.PENG, plates={op_cards[1] , op_cards[1], op_cards[1]}});
        elseif operation_type == dzm_pb.SORT_MING then
			table.insert(xiGridData, {operation = dzm_pb.GANG, plates={op_cards[1], op_cards[1], op_cards[1], op_cards[1]}, state = dzm_pb.MING});
		elseif operation_type == dzm_pb.SORT_DARK then
			table.insert(xiGridData, {operation = dzm_pb.GANG, plates={op_cards[1], op_cards[1], op_cards[1], op_cards[1]}, state = dzm_pb.AN});
		elseif operation_type == dzm_pb.SORT_DIAN then
			table.insert(xiGridData, {operation = dzm_pb.GANG, plates={op_cards[1], op_cards[1], op_cards[1], op_cards[1]}, state = dzm_pb.DIAN});
        end
    end

    return xiGridData;

end

function DZAHM_GridTool:SetLayOut()
    this.SetThrowGridLayOut(self.gridThrow,self.posIndex,uiLayer:GetGameLogic().totalSize);
    this.SetHandGridLayOut(self.gridHand,self.posIndex,uiLayer:GetGameLogic().totalSize);
end

--根据人数对牌桌上的牌的grid要重新布局，比如两个人的时候，坐在0，2的位置。那么牌桌上已出的牌，每行可以多排更多的牌
function this.SetThrowGridLayOut(gridThrow,posIndex,playerSize)
    -- print("SetThrowGridLayOut was called-----> gridThrow:"..tostring(gridThrow)..",posIndex:"..posIndex..",playerSize:"..playerSize);
    local gameUIObjects = uiLayer:GetgameUIObjects();
    if playerSize == 2 then --两个人的排版
        local grid = gridThrow:GetComponent("UIGrid");
        grid.maxPerLine = 22;
        if posIndex == 2 then 
            gridThrow.localPosition = Vector3(505,196,0);
        elseif posIndex == 0 then 
            gridThrow.localPosition =  Vector3(-501,-157.3,0);
        end
    elseif playerSize == 3 then --三个人的排版
        local grid = gridThrow:GetComponent("UIGrid");
        if posIndex == 0 then 
            gridThrow.localPosition = Vector3(-294,-157,0);
            grid.maxPerLine = 11;
        elseif posIndex == 1 then 
            grid.maxPerLine = 11;
            gridThrow.localPosition = Vector3(460,-171,0);
        elseif posIndex == 3 then
            grid.maxPerLine = 11;
            gridThrow.localPosition = Vector3(-463,252,0); 
        end
    else--四个人的排版
        local grid = gridThrow:GetComponent("UIGrid");
        if posIndex == 1 or posIndex == 3 then 
            grid.maxPerLine = 10;
            gridThrow.localPosition = gameUIObjects.playerTableThrowGridPos[posIndex+1];
        elseif posIndex == 0 or posIndex == 2 then 
            grid.maxPerLine = 11;
            if posIndex == 2 then 
                gridThrow.localPosition = Vector3(215,199.1,0); 
            else
                gridThrow.localPosition = Vector3(-294.5,-157,0);
            end
        end
    end
   
end

--根据人数和自适应要求对gridMo重新布局--暂时用不上，因为再gridhand中会更新它的位置
function this.SetGridMoLayOut(gridMo,posIndex,playerSize)

end

--根据人数对gridHand重新布局
function this.SetHandGridLayOut(gridHand,posIndex,playerSize)
    -- print("SetHandGridLayOut was called-----> gridHand:"..tostring(gridHand)..",posIndex:"..posIndex..",playerSize:"..playerSize);
    -- print("DZAHM_Tools.IfNeedAutoLayOut()="..tostring(DZAHM_Tools.IfNeedAutoLayOut()));
    local gameUIObjects = uiLayer:GetgameUIObjects();
    if playerSize == 2 then --两个人的排版
        if posIndex == 0 then 
            gridHand.localScale = DZAHM_Tools.IfNeedAutoLayOut() and  Vector3(FitScale, FitScale, 1) or Vector3(1.0,1.0,1.0);
            gridHand.localPosition = DZAHM_Tools.IfNeedAutoLayOut() and Vector3(455*FitScale, -288, 0) or gameUIObjects.playerHandGridPos[posIndex+1];
        end
    elseif playerSize == 3 then --三个人的排版
        if posIndex == 0 then 
            gridHand.localScale = DZAHM_Tools.IfNeedAutoLayOut() and Vector3(FitScale, FitScale, 1) or Vector3(1.0,1.0,1.0);
            gridHand.localPosition = DZAHM_Tools.IfNeedAutoLayOut() and Vector3(455*FitScale, -288, 0) or gameUIObjects.playerHandGridPos[posIndex+1];
        elseif posIndex == 1 then 
            gridHand.localPosition = DZAHM_Tools.IfNeedAutoLayOut() and  Vector3(542,-182.6,0) or Vector3(542,-182.6,0) ;
        elseif posIndex == 3 then
            gridHand.localPosition = DZAHM_Tools.IfNeedAutoLayOut() and Vector3(-654,242.8,0) or Vector3(-545,242.8,0) ;
        end
    else--四个人的排版
        if posIndex == 0 then 
            gridHand.localScale = DZAHM_Tools.IfNeedAutoLayOut() and Vector3(FitScale, FitScale, 1) or Vector3(1.0,1.0,1.0);
            gridHand.localPosition = DZAHM_Tools.IfNeedAutoLayOut() and Vector3(455*FitScale, -288, 0) or gameUIObjects.playerHandGridPos[posIndex+1];
        elseif posIndex == 1 then 
            gridHand.localPosition = DZAHM_Tools.IfNeedAutoLayOut() and  Vector3(542,-182.6,0) or Vector3(542,-182.6,0) ;
        elseif posIndex == 3 then 
            gridHand.localPosition = DZAHM_Tools.IfNeedAutoLayOut() and Vector3(-545,242.8,0) or Vector3(-545,242.8,0) ;
        else
            gridHand.localPosition = gameUIObjects.playerHandGridPos[posIndex+1];
        end
        
    end

    

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



