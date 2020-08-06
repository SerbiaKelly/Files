local csm_pb = require 'csm_pb'

panelStartHu = {};
local this = panelStartHu;
local gameObject;
local message;

local playerPrefab;
local startHuGrid;
local mask;
local roomData = nil;
local clockCoroutine = nil;



function this.Awake(obj)
    gameObject = obj;
    this.gameObject = obj;
    message = gameObject:GetComponent("LuaBehaviour");
    this.GetObjects(gameObject);
    this.BindEvents(gameObject);
end

local fuc=nil
function this.WhoShow(data)
    if data.fuc then
        fuc=data.fuc
    end
    roomData = data.roomData;
    this.Refresh(data);
    this.StartColor(2);
end



function this.Update()

end

function this.Start()

end

function this.OnEnable()

end

function this.OnApplicationFocus()

end

function this.StartColor(timeLenght)
    gameObject.transform:Find("Clock"):GetComponent("TweenScale").enabled = false;
    if clockCoroutine then
        StopCoroutine(clockCoroutine);
    end
    local timeTick = timeLenght;
    local timeLabel = gameObject.transform:Find("Clock/time"):GetComponent("UILabel");
    timeLabel.text = timeLenght;
    clockCoroutine = StartCoroutine(function ()

        while(true)
        do
            if timeTick <=timeLenght then
                gameObject.transform:Find("Clock"):GetComponent("TweenScale").enabled = true;
            end
            timeLabel.text = timeTick;
            WaitForSeconds(1);

            timeTick = timeTick -1;
            if timeTick < 0 then
                break;
            end
        end
        if fuc then
            fuc()
            fuc=nil
        end
        gameObject:SetActive(false);
    end);
end


function this.GetObjects(gameObject)

    playerPrefab = gameObject.transform:Find("PlayerItem");
    mask = gameObject.transform:Find("mask");
    startHuGrid = gameObject.transform:Find("Grid");

end

function this.BindEvents(gameObject)

end


function this.Refresh(data)

    for i = 1, startHuGrid.childCount do
        startHuGrid:GetChild(i-1).gameObject:SetActive(false);
    end

    for i = 1, #data.startHu do
        local playerData = panelInGame.GetPlayerDataBySeat(data.startHu[i].seat);
        print("data.startHu[i].seat:"..data.startHu[i].seat);
        local playerObj = nil;
        if i <= startHuGrid.childCount then
            playerObj = startHuGrid:GetChild(i-1).gameObject;
        else
            playerObj = NGUITools.AddChild(startHuGrid.gameObject, playerPrefab.gameObject);
        end
        playerObj.gameObject:SetActive(true);

        this.SetPlayerInfo(playerObj,playerData);
        this.SetStartHuText(playerObj.transform:Find("PaixingLabel").gameObject,data.startHu[i].categories);
        this.SetStartHuMahjongs(playerObj.transform:Find("player_mj/GridHand"),data.startHu[i]);
    end

    startHuGrid:GetComponent("UIGrid"):Reposition();

end


--设置玩家信息
function this.SetPlayerInfo(playerObj,playerData)

    if playerObj == nil or playerData == nil then
        print("panelStartHu SetPlayerInfo playerObj or playerData is nil");
        return ;
    end

    coroutine.start(LoadPlayerIcon,playerObj.transform:Find("HeadImage/HeadIcon"):GetComponent("UITexture"),playerData.icon);
    playerObj.transform:Find("HeadImage/Name"):GetComponent("UILabel").text = playerData.name;
    playerObj.transform:Find("Zhuang").gameObject:SetActive(roomData.bankerSeat == playerData.seat);


end

--设置起手胡的文字，麻将下面的一行文字
function this.SetStartHuText(lableObj, categories)
    if lableObj == nil or categories == nil then
        print("panelStartHu SetStartHuText lable or categories is nil");
        return;
    end

    local catString = "";
    print("Paixin categories----------");
    for i = 1, #categories do
        print("cate:"..(categories[i].category+1));
        catString = catString..(GetCategoryNameStr()[categories[i].category+1]).."   ";
    end

    lableObj:GetComponent("UILabel").text = catString;

end

--设置起手胡的麻将
function this.SetStartHuMahjongs(grid,startHu)
    --需要展示所有手牌
    if this.NeedShowAll(startHu) then
        --1.展示手牌
        local categoryNames = GetCategoryNameStr();
        local cate_mahjongs = {};
        for i = 1, #startHu.categories do
            local cateName = categoryNames[startHu.categories[i].category+1];
            if cateName == "板板胡" or cateName == "缺一色" or cateName == "一枝花" then
                table.insert(cate_mahjongs,startHu.categories[i].mahjongs);
                break;
            end

        end

        this.SetMahjons(grid,cate_mahjongs);
        --清除颜色
        this.ClearMahjongColor(grid);
        --2.做颜色区分
        this.SetMahjongsColor(grid,startHu);

    else

        --1.添加牌
        local cate_mahjongs = {};
        for i = 1, #startHu.categories do
            table.insert(cate_mahjongs,startHu.categories[i].mahjongs);
        end
        this.SetMahjons(grid, cate_mahjongs);
        --清除颜色
        this.ClearMahjongColor(grid);

    end

end

function this.ClearMahjongColor (grid)
    -- body...
    --先把颜色清除
    for i = 1, grid.childCount do
        grid:GetChild(i-1):Find("color").gameObject:SetActive(false);
    end
end

function this.SetMahjons(grid, cate_mahjongs)

    if grid == nil or cate_mahjongs ==  nil then
        print("panelStartHu SetMahjons grid or startHu is nil");
        return ;
    end

    --麻将字体
    local cardColor 	= UnityEngine.PlayerPrefs.GetInt('cardColor_mj', 1);
    --麻将颜色
    local cardText 	    = UnityEngine.PlayerPrefs.GetInt('cardText_mj', 1);
    local addItemObj    = grid.parent:Find("cardHand").gameObject;
    local startPos      = Vector3.New(-314.0998,-20,0);
    local gap           = addItemObj:GetComponent("UISprite").width-7;
    local cate_gap      = 30;
    local addCount      = 1;
    local posX          = startPos.x;

    for i = 1, grid.childCount do
        grid:GetChild(i-1).gameObject:SetActive(false);
    end


    for i = 1, #cate_mahjongs do
        --添加麻将
        print("cate_mahjongs[i].length:"..(#cate_mahjongs[i]));
        for j = 1, #cate_mahjongs[i] do

            local mahjonItemObj = nil;
            if addCount <= grid.childCount then
                mahjonItemObj = grid:GetChild(addCount-1).gameObject;
            else
                mahjonItemObj = NGUITools.AddChild(grid.gameObject, addItemObj);
            end
            mahjonItemObj.gameObject:SetActive(true);

            --绑定数据
            SetUserData(mahjonItemObj, cate_mahjongs[i][j]);
            --设置牌面
            mahjonItemObj:GetComponent("UISprite").spriteName = panelInGame.getColorCardName("mj_01",cardColor);
            mahjonItemObj.transform:Find("card"):GetComponent("UISprite").spriteName = panelInGame.GetCardTextName(cate_mahjongs[i][j],cardText);
            --设置位置

            mahjonItemObj.transform.localPosition = Vector3.New(posX,startPos.y,0);
            posX        = posX + gap;
            addCount    = addCount + 1;

        end

        --添加间隔
        posX = posX + cate_gap;

    end

end


--设置麻将的颜色
function this.SetMahjongsColor(grid,startHu)

    if grid == nil or startHu == nil then
        print("panelStartHu SetMahjongsColor grid or startHu is nil");
        return ;
    end



    --重新上色
    print("childCount:"..grid.childCount);
    for i = 1, grid.childCount do
        for j = 1, #startHu.categories do
            local categoryNames = GetCategoryNameStr();
            local judgeName = categoryNames[startHu.categories[j].category+1];
            --print("judgeName:"..judgeName);
            if judgeName == "大四喜" or  judgeName == "六六顺" then
                for k = 1, #startHu.categories[j].mahjongs do
                    local mahjong = GetUserData(grid:GetChild(i-1).gameObject);
                    --print("card mahjong:"..mahjong.."|cate mahjong:"..startHu.categories[j].mahjongs[k]);
                    if mahjong == startHu.categories[j].mahjongs[k] then
                        grid:GetChild(i-1):Find("color").gameObject:SetActive(true);

                    end
                end
            end
        end
    end

end


--是否需要展示所有手牌
function this.NeedShowAll(startHu)
    local categoryNames = GetCategoryNameStr();

    for i = 1, #startHu.categories do

        local cateName = categoryNames[startHu.categories[i].category+1];
        if cateName == "板板胡" or cateName == "缺一色" or cateName == "一枝花" then
            return true;
        end

    end

    return false;

end
