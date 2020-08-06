local phz_pb = require 'phz_pb'
local json = require 'json'
panelStageClear = {}
local this = panelStageClear;

local message
local gameObject

local roomNum
local time
local dipaikuang
local shukuang_pai
local mingtangType
local win
local lose
local wast
local ButtonOK
local ButtonShare
local ButtonClose
local ButtonXiPai

local ButtonKnow
local Guide

local allWinnerPlates = {}
local mingTangName={
    --名堂索引  对应图片名字   胡示众牌不是名堂但是需要显示在名堂的位置，始终放到最后
    [phz_pb.TIAN_HU] = '天胡',
    [phz_pb.DI_HU] = '地胡',
    [phz_pb.HEI_HU] = '黑胡',
    [phz_pb.HONG_HU] = '红胡',
    [phz_pb.DIAN_HU] = '点胡',
    [phz_pb.WU_HU] = '乌胡',
    [phz_pb.PENG_PENG_HU] = '碰碰胡',
    [phz_pb.SHI_BA_DA] = '十八大',
    [phz_pb.SHI_LIU_XIAO] = '十六小',
    [phz_pb.HAI_DI_HU] = '海底胡',
    [phz_pb.YI_DIAN_HONG] = '一点红',
    [phz_pb.YI_KUAI_BIAN] = '一块匾',
    [phz_pb.SHI_SAN_HONG] = '十三红',
    [phz_pb.SHI_HONG] = '十红',
    [phz_pb.KA_HU_20] = '20卡',
    [phz_pb.KA_HU_30] = '30卡',
    [phz_pb.ZI_MO] = '自摸',
    [phz_pb.TING_HU] = '听胡',
    [phz_pb.DA_HU] = '大胡',
    [phz_pb.XIAO_HU] = '小胡',
    [phz_pb.DUI_DUI_HU] = '对子胡',
    [phz_pb.SHUA_HOU] = '耍猴',
    [phz_pb.HUANG_FAN] = '黄番',
    [phz_pb.SHI_BA_XIAO] = '十八小',
    [phz_pb.ER_BI] = '二比',
    [phz_pb.SAN_BI] = '三比',
    [phz_pb.SI_BI] = '四比',
    [phz_pb.SHUANG_PIAO] = '双飘',
    [phz_pb.HANG_HANG_XI] = '行行息拷贝',
    [phz_pb.TUAN_TUAN_XI] = '团团息拷贝',
    [phz_pb.HONG_WU] = '红乌',
    [phz_pb.HU_30] = '30胡',
    [phz_pb.HU_30_SHI_HONG] = '30胡十红',
    [phz_pb.DAO_DI_DI_HU] = '到底地胡',
    [phz_pb.DA_HONG] = '大红',
    [phz_pb.XIAO_HONG] = '小红',
    [phz_pb.PIAO_HU] = '飘胡',

    [phz_pb.JU_SHOU] = '举手',
    [phz_pb.ZUI_WU_HU] = '无胡',
    [phz_pb.XIAO_KA_HU] = '10卡',
    [phz_pb.DA_KA_HU] = '20卡',
    [phz_pb.JIA_HONG] = '夹红',
    [phz_pb.HONG_DUI_HU] = '红对胡',
    [phz_pb.WU_DUI_HU] = '乌对胡',
    [phz_pb.JIA_HONG_DUI] = '夹红对',
    [phz_pb.ER_BIAN] = '二扁',
    [phz_pb.SAN_BIAN] = '三扁',
    [phz_pb.SI_BIAN] = '四扁',
    [phz_pb.QI_DUI] = '七对',
    [phz_pb.SHUANG_LONG] = '双龙',
    [phz_pb.WU_FU] = '五福',

    [phz_pb.WU_XI_PING] = '无息平',
    [phz_pb.DA_ZI_HU] = '大字胡',
    [phz_pb.XIAO_ZI_HU] = '小字胡',
    [phz_pb.HUO_HU_ZI] = '火胡子',
    [phz_pb.DIAO_DIAO_SHOU] = '吊吊手',
    [phz_pb.JIU_DUI_BAN] = '九对半',
    [phz_pb.JIA_HANG_HANG] = '假行行',
    [phz_pb.HONG_47] = '四七红',
}

--三人
local size3Objects = {}
--两人
local size2Objects = {}
local winnerDataItem
local xingItem
function this.Awake(obj)
    gameObject = obj;
    message    = gameObject:GetComponent('LuaBehaviour')
    roomNum         = gameObject.transform:Find('roomNum')
    time            = gameObject.transform:Find('time')
    dipaikuang      = gameObject.transform:Find('dipaikuang')
    shukuang_pai    = gameObject.transform:Find('shukuang_pai')
    mingtangType    = gameObject.transform:Find('mingtangtype')
    win             = gameObject.transform:Find('title/Win')
    lose            = gameObject.transform:Find('title/Lose')
    wast            = gameObject.transform:Find('title/Wast')

    ButtonOK        = gameObject.transform:Find('ButtonOK')
    ButtonShare     = gameObject.transform:Find('ButtonShare')
    ButtonXiPai     = gameObject.transform:Find('ButtonXiPai')
    ButtonKnow      = gameObject.transform:Find('size3/zhishi/Guide/ButtonKnow')
    Guide           = gameObject.transform:Find('size3/zhishi/Guide')
    message:AddClick(ButtonOK.gameObject, this.OnClickButtonOK)
    message:AddClick(ButtonShare.gameObject, this.OnClickButtonShare)
    message:AddClick(ButtonKnow.gameObject, this.OnClickButtonKnow)
    message:AddClick(ButtonXiPai.gameObject, this.OnClickButtonXiPai)
    size3Objects.Trans = gameObject.transform:Find("size3")
    size2Objects.Trans = gameObject.transform:Find("size2")
    this.GetSize3Objects()
    this.GetSize2Objects()
    winnerDataItem = gameObject.transform:Find('winnerDataItem')
    xingItem = gameObject.transform:Find('xingItem')
    if IsAppleReview() then
        ButtonShare.gameObject:SetActive(false)
    end
end

function this.setButtonsStatus(hideXiPai)
    if hideXiPai==nil and roomData.setting.openShuffle==true and RoundData.data.gameOver==false and RoundData.isInGame==true then
        ButtonXiPai.gameObject:SetActive(true)
        ButtonXiPai:Find('Label'):GetComponent('UILabel').text='洗牌'
        ButtonXiPai:GetComponent('UIButton').isEnabled=true
    else
        ButtonXiPai.gameObject:SetActive(false)
    end
end

function this.OnClickButtonXiPai(go)
    panelMessageBoxTiShi.SetParamers(OK_CANCLE, function ()
        print('执行了')
        ButtonXiPai:GetComponent('UIButton').isEnabled=false
        AudioManager.Instance:PlayAudio('btn')
        local msg = Message.New()
        msg.type = phz_pb.SHUFFLE
        SendGameMessage(msg, nil)
    end, nil, '洗牌会消耗'..roomData.setting.shuffleFee..'疲劳值，是否确认洗牌？(确认洗牌后将自动进入下一局)')
    PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
end

function this.onGetXiPaiResult(msg)
    local b = phz_pb.RShuffle()
    b:ParseFromString(msg.body)
    if b.seat==RoundData.mySeat then
        --错误码 83:洗牌成功  84:洗牌失败非疲劳值不足  85:洗牌失败疲劳值不足  86:重复洗牌
        if b.code==83 then
            ButtonXiPai:Find('Label'):GetComponent('UILabel').text='已洗牌'
            local msg = Message.New()
            msg.type = phz_pb.READY
            SendGameMessage(msg, nil)
            panelInGameLand.hasStageClear=false
            PanelManager.Instance:HideWindow(gameObject.name)
        elseif  b.code==84 then
            ButtonXiPai:GetComponent('UIButton').isEnabled=true
            panelMessageBox.SetParamers(ONLY_OK, nil, nil, '暂时不能洗牌')
            PanelManager.Instance:ShowWindow('panelMessageBox')
        elseif  b.code==85 then
            ButtonXiPai:GetComponent('UIButton').isEnabled=true
            panelMessageBox.SetParamers(ONLY_OK, nil, nil, '疲劳值不足')
            PanelManager.Instance:ShowWindow('panelMessageBox')
        elseif  b.code==86 then
            ButtonXiPai:GetComponent('UIButton').isEnabled=true
            panelMessageBox.SetParamers(ONLY_OK, nil, nil, '请勿重复点击')
            PanelManager.Instance:ShowWindow('panelMessageBox')
        else
            ButtonXiPai:GetComponent('UIButton').isEnabled=true
            panelMessageBox.SetParamers(ONLY_OK, nil, nil, '洗牌未知错误')
            PanelManager.Instance:ShowWindow('panelMessageBox')
        end
    end
    if panelInGame.needXiPai==false and b.code==83 then
        panelInGame.needXiPai=true
    end
end

function this.GetSize3Objects()
    size3Objects.huxi_data       = size3Objects.Trans:Find('player/player1/huxi/huxiData')
    size3Objects.mingtang        = size3Objects.Trans:Find('player/player1/mingtang')
    size3Objects.winerbg         = size3Objects.Trans:Find('player/player1/winner_bg')
    
    size3Objects.players = {}
    for i = 1, 4 do
        local playerTrans = size3Objects.Trans:Find("player/player"..i)
        size3Objects.players[i] = {}
        size3Objects.players[i].headImg         = playerTrans:Find("txk/tx")
        size3Objects.players[i].master          = playerTrans:Find("txk/master")
        size3Objects.players[i].name            = playerTrans:Find("name")
        size3Objects.players[i].id              = playerTrans:Find("id")
        size3Objects.players[i].hupai           = playerTrans:Find("hong")
        size3Objects.players[i].fangpao         = playerTrans:Find("lan")
        size3Objects.players[i].myself          = playerTrans:Find("myself")
        size3Objects.players[i].addupScore      = playerTrans:Find("addupScore/leijifenshu_data")
        size3Objects.players[i].currentScoreP   = playerTrans:Find("dangjufenshu/get")
        size3Objects.players[i].currentScoreM   = playerTrans:Find("dangjufenshu/lost")
        size3Objects.players[i].paixingGrid     = playerTrans:Find("paixing")
        size3Objects.players[i].winner_data     = playerTrans:Find('winner_data')
    end
end

function this.GetSize2Objects()
    size2Objects.huxi_data = size2Objects.Trans:Find('huxi/huxiData')
    size2Objects.mingtang = size2Objects.Trans:Find('mingtang')
    size2Objects.winerbg = size2Objects.Trans:Find('framebgwin')
    size2Objects.players = {}
    for i = 1, 2 do
        local playerTrans = size2Objects.Trans:Find("player"..i)
        size2Objects.players[i] = {}
        size2Objects.players[i].headImg         = playerTrans:Find("txk/tx")
        size2Objects.players[i].master          = playerTrans:Find("txk/master")
        size2Objects.players[i].name            = playerTrans:Find("name")
        size2Objects.players[i].id              = playerTrans:Find("id")
        size2Objects.players[i].hupai           = playerTrans:Find("hong")
        size2Objects.players[i].fangpao         = playerTrans:Find("lan")
        size2Objects.players[i].myself          = playerTrans:Find("myself")
        size2Objects.players[i].addupScore      = playerTrans:Find("addupScore/leijifenshu_data")
        size2Objects.players[i].currentScoreP   = playerTrans:Find("dangjufenshu/get")
        size2Objects.players[i].currentScoreM   = playerTrans:Find("dangjufenshu/lost")
        size2Objects.players[i].paixingGrid     = playerTrans:Find("paixing")
        size2Objects.players[i].winner_data     = playerTrans:Find('winner_data')
    end
end

function this.Start()
end

function this.Update()
end

function this.OnEnable()
    RegisterGameCallBack(phz_pb.SHUFFLE, this.onGetXiPaiResult)
    this.setButtonsStatus()
    this.SetNormalInfo()
    allWinnerPlates = {}
    for i = 1, roomData.setting.size do
        if RoundData and i <= roomData.setting.size then
            if RoundData.data.players[i].seat == RoundData.data.seat then
                local winData = RoundData.data.players[i]
                table.remove(RoundData.data.players, i)
                table.insert(RoundData.data.players, 1, winData)
            end
        end
    end
    if roomData.setting.size == 3 or roomData.setting.size == 4 then
        Guide.gameObject:SetActive((roomData.setting.size == 4 and UnityEngine.PlayerPrefs.GetInt('roundEndGuide', 0) == 0))
        size3Objects.Trans.gameObject:SetActive(true)
        size2Objects.Trans.gameObject:SetActive(false)
        size3Objects.players[4].name.parent.gameObject:SetActive(roomData.setting.size == 4)
        gameObject.transform:Find('size3/zhishi/jiantou').gameObject:SetActive(roomData.setting.size == 4)
        for i = 1, 4 do
            size3Objects.players[i].hupai.gameObject:SetActive(false)
            size3Objects.players[i].fangpao.gameObject:SetActive(false)
            size3Objects.players[i].myself.gameObject:SetActive(false)
            size3Objects.players[i].master.gameObject:SetActive(false)
            Util.ClearChild(size3Objects.players[i].paixingGrid)
        end
        this.fuzhi(size3Objects,RoundData.data.players)
        size3Objects.Trans:Find('player'):GetComponent('UIScrollView'):ResetPosition()
    elseif roomData.setting.size == 2 then
        size3Objects.Trans.gameObject:SetActive(false)
        size2Objects.Trans.gameObject:SetActive(true)
        for i = 1, 2 do
            size2Objects.players[i].hupai.gameObject:SetActive(false)
            size2Objects.players[i].fangpao.gameObject:SetActive(false)
            size2Objects.players[i].myself.gameObject:SetActive(false)
            size2Objects.players[i].master.gameObject:SetActive(false)
            Util.ClearChild(size2Objects.players[i].paixingGrid)
        end
        this.fuzhi(size2Objects,RoundData.data.players)
    end
end

function this.SetNormalInfo()
    if roomInfo then print('房间号' .. roomInfo.roomNumber) end
    roomNum:GetComponent('UILabel').text = '房间号：' .. roomInfo.roomNumber
    time:GetComponent('UILabel').text = os.date('时间：%Y.%m.%d %H:%M', os.time())
    this.TitleLoseOrWin() -- 输赢标题 动画
    this.InitDipai() --底牌
end

function this.GetPlayerDataBySeat(playerData,seat)
    for i = 1, #playerData do
        if playerData[i].seat == seat then
            return playerData[i]
        end
    end
    return nil
end

function this.TitleLoseOrWin()
    if RoundData.data.seat == -1 then
        print("荒庄， 我的座位号：" .. RoundData.mySeat)
        local audioName = ""
        if UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 1) == 1 then
            audioName = string.format('huang_%d', 1)
        elseif UnityEngine.PlayerPrefs.GetInt(PLAYER_NOT_SHIELD_VOICE, 1) == 0 then
            audioName = string.format('fhuang_%d', 1)
        end
        
        AudioManager.Instance:PlayAudio(audioName)
        lose.gameObject:SetActive(false)
        win.gameObject:SetActive(false)
        wast.gameObject:SetActive(true)
        size2Objects.winerbg.gameObject:SetActive(false)
        size3Objects.winerbg.gameObject:SetActive(false)
    else
        size2Objects.winerbg.gameObject:SetActive(true)
        size3Objects.winerbg.gameObject:SetActive(true)
        if RoundData.data.seat == RoundData.mySeat then
            AudioManager.Instance:PlayAudio('win')
            lose.gameObject:SetActive(false)
            win.gameObject:SetActive(true)
            wast.gameObject:SetActive(false)
        else
            AudioManager.Instance:PlayAudio('lose')
            lose.gameObject:SetActive(true)
            win.gameObject:SetActive(false)
            wast.gameObject:SetActive(false)
        end
    end
end
function this.setPaiMian(tu, zhi)
    tu.gameObject:SetActive(true)
    local sp = tu:GetComponent('UISprite')
    sp.spriteName = 'card' .. (UnityEngine.PlayerPrefs.GetInt('paiMian', 1) == 1 and '_' or '1_') .. zhi
end
function this.InitDipai()
    print("InitDipai was called")
    --Util.ClearChild(dipaikuang)
    local tmpcard = ResourceManager.Instance:LoadAssetSync('card')
    for i=dipaikuang.childCount,#RoundData.data.plates-1 do
		NGUITools.AddChild(dipaikuang.gameObject,tmpcard.gameObject)
	end
    local pos =  dipaikuang.localPosition
    if #RoundData.data.plates>34 then
        pos.y=-276
    else
        pos.y=-289
    end
    dipaikuang.localPosition=pos
    local needDepth = 2
    for i=0,dipaikuang.childCount-1 do
        local card = dipaikuang:GetChild(i)
        if i<#RoundData.data.plates then
            card.transform.localScale = Vector3.New(0.8,0.8,0)

            card:GetComponent("UISprite").depth = needDepth
            card.transform:Find("plate"):GetComponent("UISprite").depth = needDepth + 1
            card.gameObject:SetActive(true)
            this.setPaiMian(card.transform:GetChild(0), RoundData.data.plates[i+1])
        else
            card.gameObject:SetActive(false)
        end
    end
    dipaikuang.gameObject:GetComponent('UIGrid'):Reposition()
end

function this.fuzhi(playerObj,playerRoundData) --赋值（2人的）
    Util.ClearChild(playerObj.mingtang)
    for i = 1, roomData.setting.size do
        Util.ClearChild(playerObj.players[i].winner_data)
    end
    
    --名堂显示
    for j = 1, #playerRoundData[1].categories do 
        if mingTangName[playerRoundData[1].categories[j]] then 
            local mt = NGUITools.AddChild(playerObj.mingtang.gameObject, mingtangType.gameObject)
            mt.gameObject:SetActive(true)
            if playerRoundData[1].categories[j] == phz_pb.DUI_DUI_HU 
            and (roomData.setting.roomTypeValue == phz_pb.HSPHZ or roomData.setting.roomTypeValue == phz_pb.CDDHD) then
                mt.transform:GetComponent('UISprite').spriteName = '对对胡'
            else
                mt.transform:GetComponent('UISprite').spriteName = mingTangName[playerRoundData[1].categories[j]]
            end
            mt.transform:GetComponent('UISprite'):MakePixelPerfect()
        end 
    end
    if roomData.setting.roomTypeValue == phz_pb.YJGHZ then
        if playerRoundData.neiYuan ~= 0 then
            local mt = NGUITools.AddChild(playerObj.mingtang.gameObject, mingtangType.gameObject)
            mt.gameObject:SetActive(true)
            mt.transform:GetComponent('UISprite').spriteName = '内元'
            mt.transform:GetComponent('UISprite'):MakePixelPerfect()
        end
        if playerRoundData.waiYuan ~= 0 then
            local mt = NGUITools.AddChild(playerObj.mingtang.gameObject, mingtangType.gameObject)
            mt.gameObject:SetActive(true)
            mt.transform:GetComponent('UISprite').spriteName = '外元'
            mt.transform:GetComponent('UISprite'):MakePixelPerfect()
        end
    end
    
    --胡示众牌，始终放到grid的最后
    if roomData.setting.roomTypeValue == phz_pb.HYSHK or roomData.setting.roomTypeValue == phz_pb.HYLHQ then
        if RoundData.data.huShowPlate~=nil and RoundData.data.huShowPlate then
            local mt = NGUITools.AddChild(playerObj.mingtang.gameObject, mingtangType.gameObject)
            mt.gameObject:SetActive(true)
            mt.transform:GetComponent('UISprite').spriteName = '胡示众牌'
            mt.transform:GetComponent('UISprite'):MakePixelPerfect()
        end
    end
    playerObj.mingtang.gameObject:GetComponent('UITable'):Reposition()

    for i = 1, roomData.setting.size do
        if RoundData and i <= roomData.setting.size then
            local playerData = this.GetPlayerDataBySeat(RoundData.playerData,playerRoundData[i].seat)
            --头像
            coroutine.start(LoadPlayerIcon,  playerObj.players[i].headImg:GetComponent('UITexture'), playerData.icon)
            --名字
            playerObj.players[i].name:GetComponent("UILabel").text = playerData.name
            --ID
            playerObj.players[i].id:GetComponent("UILabel").text = "ID:"..playerData.id
            --累计分数
            playerObj.players[i].addupScore:GetComponent("UILabel").text = playerRoundData[i].total
            --当局分数
            playerObj.players[i].currentScoreP:GetComponent("UILabel").text = playerRoundData[i].score==0 and playerRoundData[i].score or "+"..playerRoundData[i].score
            playerObj.players[i].currentScoreM:GetComponent("UILabel").text = playerRoundData[i].score
            playerObj.players[i].currentScoreP.gameObject:SetActive(playerRoundData[i].score >= 0)
            playerObj.players[i].currentScoreM.gameObject:SetActive(playerRoundData[i].score < 0)
            
            if RoundData.data.seat == -1 then
                if roomData.setting.roomTypeValue == phz_pb.SYZP 
                or roomData.setting.roomTypeValue == phz_pb.HHHGW 
				or roomData.setting.roomTypeValue == phz_pb.AHPHZ 
                or roomData.setting.roomTypeValue == phz_pb.HYLHQ
                or roomData.setting.roomTypeValue == phz_pb.HYSHK
                or roomData.setting.roomTypeValue == phz_pb.CDPHZ
                or roomData.setting.roomTypeValue == phz_pb.CSPHZ then
                    playerObj.players[i].currentScoreM:GetComponent("UILabel").text = 0
                    playerObj.players[i].currentScoreM.gameObject:SetActive(true)
                    playerObj.players[i].currentScoreP.gameObject:SetActive(false)
                end
            end
            --胡牌标记
            if playerRoundData[i].seat == RoundData.data.seat then      
                playerObj.players[i].hupai.gameObject:SetActive(true)
            end
            --放炮标记
            if playerRoundData[i].seat == RoundData.data.paoSeat then
                playerObj.players[i].fangpao.gameObject:SetActive(true)
            end
            --本人标记
            if playerRoundData[i].seat == RoundData.mySeat then
                playerObj.players[i].myself.gameObject:SetActive(true)
            end
            --庄家标记
            if playerRoundData[i].seat == roomData.bankerSeat then
                playerObj.players[i].master.gameObject:SetActive(true)
            end
            --显示玩家牌
            for j=playerObj.players[i].paixingGrid.childCount,#playerRoundData[i].plates-1 do
                NGUITools.AddChild(playerObj.players[i].paixingGrid.gameObject,shukuang_pai.gameObject)
            end
            for j = 0, playerObj.players[i].paixingGrid.childCount-1 do
                local paiGroup = playerObj.players[i].paixingGrid:GetChild(j)
                if j<#playerRoundData[i].plates then
                    local plates = playerRoundData[i].plates[j+1].plates
                    local operation = playerRoundData[i].plates[j+1].operation
                    local num
                    if operation == phz_pb.CHI or operation == phz_pb.JIAO or operation == phz_pb.JU then
                        num=#plates
                    elseif operation == phz_pb.DUI then
                        num=2
                    elseif operation == phz_pb.PENG or operation == phz_pb.WEI or operation == phz_pb.KAN or operation == phz_pb.CHOU_WEI then
                        num=3
                    elseif operation == phz_pb.PAO or operation == phz_pb.TI or operation == phz_pb.START_TI then
                        num=4
                    else
                        num=0
                    end
                    for k=2,paiGroup.childCount-1 do
                        local pai = paiGroup.transform:GetChild(k)
                        if k<num+2 then
                            this.setPaiMian(pai.transform:GetChild(0),#plates==1 and plates[1] or plates[k-1])
                            if i == 1 then
                                table.insert(allWinnerPlates, #plates==1 and plates[1] or plates[k-1])
                            end
                            pai:Find('pai/Sprite').gameObject:SetActive(false)
                            pai:Find('pai/Sprite2').gameObject:SetActive(false)
                            pai.gameObject:SetActive(true)
                        else
                            pai.gameObject:SetActive(false)
                        end
                    end
                    paiGroup.gameObject:SetActive(true)
                    paiGroup.gameObject.name = j+1
                    paiGroup.transform:Find("Labelup").gameObject:SetActive(true)
                    paiGroup.transform:Find("Labelup"):GetComponent("UILabel").text = this.GetShukuang_pai(operation)
                    paiGroup.transform:Find("Labeldown"):GetComponent("UILabel").text = this.GetHuXi(operation, plates)
                    if j == #playerRoundData[i].plates-1 and playerRoundData[i].seat == RoundData.data.seat then
                        for z = 1, #plates do
                            if playerRoundData[i].huPlate == plates[z] then
                                paiGroup.transform:GetChild(2):Find('pai/Sprite').gameObject:SetActive(true)
                                paiGroup.transform:GetChild(2):Find('pai/Sprite2').gameObject:SetActive(true)
                            end
                        end
                    end
                else
                    paiGroup.gameObject:SetActive(false)
                end
            end
            playerObj.players[i].paixingGrid:GetComponent('UIGrid'):Reposition()
        end
    end
    local HandHuXi = 0  --手牌胡息
    for j = 0, 6 do
        if j <= (playerObj.players[1].paixingGrid.childCount-1) and playerObj.players[1].paixingGrid:GetChild(j) then
            local labelHuXi =playerObj.players[1].paixingGrid:GetChild(j):Find('Labeldown').gameObject:GetComponent('UILabel').text
            HandHuXi = HandHuXi + labelHuXi
        end
    end
    --胡息
    playerObj.huxi_data.parent.gameObject:SetActive(RoundData.data.seat ~= -1)
    playerObj.huxi_data.parent:GetComponent('UILabel').text = roomData.setting.roomTypeValue == proxy_pb.YXPHZ and '胡分：' or '胡息：' 
    if roomData.setting.roomTypeValue == proxy_pb.YXPHZ 
    or roomData.setting.roomTypeValue == proxy_pb.YJGHZ
    or roomData.setting.roomTypeValue == proxy_pb.CZZP then
        print('playerRoundData[1].huXi: '..playerRoundData[1].huXi)
        playerObj.huxi_data:GetComponent('UILabel').text = playerRoundData[1].huXi
    else
        playerObj.huxi_data:GetComponent('UILabel').text = HandHuXi
    end
    
    this.SetWinData(roomData.setting.roomTypeValue,playerRoundData[1],HandHuXi,playerObj.players[1])
    --设置其他玩家中途分
    if roomData.setting.roomTypeValue == proxy_pb.YXPHZ then
        for i = 2, roomData.setting.size do
            this.CreateAndSetWinnerData(playerObj.players[i].winner_data,winnerDataItem,'中途：',(playerRoundData[i].halfScore<0 and '' or '+')..playerRoundData[i].halfScore..'分',true)
            print(i..' categories length : '..#playerRoundData[i].categories)
            for j = 1, #playerRoundData[i].categories do
                print(i..' categories : '..playerRoundData[i].categories[j])
                if playerRoundData[i].categories[j]==phz_pb.QI_DUI then
                    this.CreateAndSetWinnerData(playerObj.players[i].winner_data,winnerDataItem,'七对：','40分',true)
                end
                if playerRoundData[i].categories[j]==phz_pb.SHUANG_LONG then
                    this.CreateAndSetWinnerData(playerObj.players[i].winner_data,winnerDataItem,'双龙：','40分',true)
                end
            end
            playerObj.players[i].winner_data:GetComponent('UITable'):Reposition()
        end
        if roomData.setting.size == 3 then
            for i = 2, roomData.setting.size do
                local obj = playerObj.players[i].winner_data
                for j = 0, obj.childCount-1 do
                    this.SetWinnerDataFontSize(obj:GetChild(j),22,20)
                end
            end
        end
    end

    --设置其他玩家提龙
    if roomData.setting.roomTypeValue == proxy_pb.LYZP then
        for i = 2, roomData.setting.size do
            if playerRoundData[i].tiScore > 0 then
                this.CreateAndSetWinnerData(playerObj.players[i].winner_data,winnerDataItem,'提龙：','+'..playerRoundData[i].tiScore..'分',true)
            elseif playerRoundData[i].tiScore < 0 then
                this.CreateAndSetWinnerData(playerObj.players[i].winner_data,winnerDataItem,'提龙：',playerRoundData[i].tiScore..'分',true)
            end
            playerObj.players[i].winner_data:GetComponent('UITable'):Reposition()
        end
        if roomData.setting.size == 3 then
            for i = 2, roomData.setting.size do
                local obj = playerObj.players[i].winner_data
                for j = 0, obj.childCount-1 do
                    this.SetWinnerDataFontSize(obj:GetChild(j),22,20)
                end
            end
        end
    end
    --设置其他玩家扎鸟
    if (roomData.setting.roomTypeValue == proxy_pb.NXPHZ or roomData.setting.roomTypeValue == proxy_pb.CSPHZ) and roomData.setting.zhaNiao ~= 0 then
        for i = 2, roomData.setting.size do
            if playerRoundData[i].zhaNiao > 0 then
                this.CreateAndSetWinnerData(playerObj.players[i].winner_data,winnerDataItem,'扎鸟：','+'..playerRoundData[i].zhaNiao..'分',true)
            elseif playerRoundData[i].zhaNiao < 0 then
                this.CreateAndSetWinnerData(playerObj.players[i].winner_data,winnerDataItem,'扎鸟：',playerRoundData[i].zhaNiao..'分',true)
            end
            playerObj.players[i].winner_data:GetComponent('UITable'):Reposition()
        end
        if roomData.setting.size == 3 then
            for i = 2, roomData.setting.size do
                local obj = playerObj.players[i].winner_data
                for j = 0, obj.childCount-1 do
                    this.SetWinnerDataFontSize(obj:GetChild(j),22,20)
                end
            end
        end
    end
    --其他玩家飘分
    if roomData.setting.roomTypeValue == proxy_pb.CZZP and roomData.setting.piao ~= 0 then
        for i = 2, roomData.setting.size do
            if playerRoundData[i].piao > 0 then
                this.CreateAndSetWinnerData(playerObj.players[i].winner_data,winnerDataItem,'飘分：','+'..playerRoundData[i].piao..'分',true)
            elseif playerRoundData[i].piao < 0 then
                this.CreateAndSetWinnerData(playerObj.players[i].winner_data,winnerDataItem,'飘分：',playerRoundData[i].piao..'分',true)
            end
            playerObj.players[i].winner_data:GetComponent('UITable'):Reposition()
        end
        if roomData.setting.size == 3 then
            for i = 2, roomData.setting.size do
                local obj = playerObj.players[i].winner_data
                for j = 0, obj.childCount-1 do
                    this.SetWinnerDataFontSize(obj:GetChild(j),22,20)
                end
            end
        end
    end
end

function this.SetWinData(roomType,playerDatas,HandHuXi,playerObj)
    --囤数
    if roomType ~= proxy_pb.SYBP 
    and roomType ~= proxy_pb.LDFPF
    and roomType ~= proxy_pb.XXGHZ
    and roomType ~= proxy_pb.YXPHZ
    and roomType ~= proxy_pb.YJGHZ then
        this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'囤数：',playerDatas.tun,RoundData.data.seat ~= -1)
    end
   
    --番数
    if roomType ~= proxy_pb.SYBP 
    and roomType ~= proxy_pb.SYZP
    and roomType ~= proxy_pb.LDFPF
    and roomType ~= proxy_pb.XXGHZ
    and roomType ~= proxy_pb.YXPHZ then
        this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'番数：',playerDatas.fan,RoundData.data.seat ~= -1)
    end
    if roomType == proxy_pb.CZZP and RoundData.data.paoSeat~=-1 then
        this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'放炮：',tostring(roomData.setting.size)..'倍',true)
    end
    --倍数
    if roomType == proxy_pb.HYSHK and roomData.setting.fangPao and RoundData.data.paoSeat~=-1 then
        this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'倍数：',tostring(roomData.setting.fangPaoMultiple)..'倍',true)
    end
    --中途分
    if roomType == proxy_pb.YXPHZ then
        this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'中途：',(playerDatas.halfScore<0 and '' or '+')..playerDatas.halfScore..'分',true)
    end 
    --内外元
    if roomType == proxy_pb.YJGHZ then
        if playerDatas.neiYuan ~= 0 then
            this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'内元：','x'..playerDatas.neiYuan,true) 
        end
        if playerDatas.waiYuan ~= 0 then
            this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'外元：','x'..playerDatas.waiYuan,true) 
        end
    end  
	--爬坡 
	if roomType == proxy_pb.AHPHZ and RoundData.data.paPo then  
		this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'爬坡：','x2',true) 
	end

    for i = 1, #playerDatas.categories do 
        if roomType == proxy_pb.SYZP then
            if playerDatas.categories[i]==phz_pb.TIAN_HU then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'天胡：','10息',true)
            end
            if playerDatas.categories[i]==phz_pb.DI_HU then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'地胡：','10息',true)
            end
            if playerDatas.categories[i]==phz_pb.HEI_HU then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'黑胡：','10息',true)
            end
            if playerDatas.categories[i]==phz_pb.HONG_HU then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'红胡：','10息',true)
            end
            if playerDatas.categories[i]==phz_pb.ZI_MO then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'自摸：',roomData.setting.ziMoAddHu == 10 and '+10息' or '+1囤',true)
            end
        end
        if roomType == proxy_pb.SYBP then
            if playerDatas.categories[i]==phz_pb.TIAN_HU then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'天胡：','10息',true)
            end
            if playerDatas.categories[i]==phz_pb.DI_HU then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'地胡：','10息',true)
            end
            if playerDatas.categories[i]==phz_pb.ZI_MO then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'自摸：','10息',true)
            end
            if roomData.setting.heiHongDian then
                if playerDatas.categories[i]==phz_pb.HEI_HU then
                    if HandHuXi and HandHuXi < 30 then
                        this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'黑胡：','60息',true)
                    else
                        this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'黑胡：',tostring(HandHuXi*2)..'息',true)
                    end
                end
                if playerDatas.categories[i]==phz_pb.SHI_SAN_HONG then
                    if HandHuXi and HandHuXi < 30 then
                        this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'十三红：','60息',true)
                    else
                        this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'十三红：',tostring(HandHuXi*2)..'息',true)
                    end
                end
                if playerDatas.categories[i]==phz_pb.HONG_HU then
                    this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'红胡：','1番',true)
                end
                if playerDatas.categories[i]==phz_pb.YI_DIAN_HONG then
                    this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'点红：','1番',true)
                end
            end
            if roomData.setting.heiHongHu then
                if playerDatas.categories[i]==phz_pb.TIAN_HU then
                    this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'天胡：','10息',true)
                end
                if playerDatas.categories[i]==phz_pb.DI_HU then
                    this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'地胡：','10息',true)
                end
                if playerDatas.categories[i]==phz_pb.HEI_HU then
                    this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'黑胡：','10息',true)
                end
                if playerDatas.categories[i]==phz_pb.HONG_HU then
                    this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'红胡：','10息',true)
                end
            end
        end 
        if roomType == proxy_pb.LDFPF then
            if playerDatas.categories[i]==phz_pb.TIAN_HU then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'天胡：','100息',true)
            end
            if playerDatas.categories[i]==phz_pb.DI_HU then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'地胡：','100息',true)
            end
            if playerDatas.categories[i]==phz_pb.WU_HU then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'乌胡：','100息',true)
            end
            if playerDatas.categories[i]==phz_pb.SHI_SAN_HONG then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'十三红：','100息',true)
            end
            if playerDatas.categories[i]==phz_pb.KA_HU_30 then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'30卡：','100息',true)
            end
            if playerDatas.categories[i]==phz_pb.HAI_DI_HU then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'海底胡：','1番',true)
            end
            if playerDatas.categories[i]==phz_pb.YI_DIAN_HONG then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'一点红：','1番',true)
            end
            if playerDatas.categories[i]==phz_pb.YI_KUAI_BIAN then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'一块匾：','1番',true)
            end
            if playerDatas.categories[i]==phz_pb.SHI_HONG then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'十红：','1番',true)
            end
            if playerDatas.categories[i]==phz_pb.KA_HU_20 then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'20卡：','1番',true)
            end
            if playerDatas.categories[i]==phz_pb.ZI_MO then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'自摸：','1番',true)
            end
        end
        if roomType == proxy_pb.XXGHZ then
            if playerDatas.categories[i]==phz_pb.TIAN_HU then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'天胡：','110息',true)
            end
            if playerDatas.categories[i]==phz_pb.DI_HU then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'地胡：','100息',true)
            end
            if playerDatas.categories[i]==phz_pb.HEI_HU then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'黑胡：','100息',true)
            end
            if playerDatas.categories[i]==phz_pb.HONG_HU then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'红胡：','2番',true)
            end
            if playerDatas.categories[i]==phz_pb.KA_HU_30 then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'30卡：','2番',true)
            end
            if playerDatas.categories[i]==phz_pb.HU_30 then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'30胡：','2番',true)
            end
            if playerDatas.categories[i]==phz_pb.HONG_WU then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'红乌：','100息',true)
            end
            if playerDatas.categories[i]==phz_pb.HU_30_SHI_HONG then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'30胡且十红：','100息',true)
            end
            if playerDatas.categories[i]==phz_pb.DAO_DI_DI_HU then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'到底地胡：','2番',true)
            end
        end
        if roomType == proxy_pb.CDPHZ 
        or roomType == proxy_pb.XTPHZ 
        or roomType == proxy_pb.CDDHD then
            if playerDatas.categories[i]==phz_pb.ZI_MO then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'自摸：','+1囤',true)
            end
            if playerDatas.categories[i]==phz_pb.HUANG_FAN then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'黄番：','2倍',true)
            end
        end
        if roomType == proxy_pb.HHHGW then
            if playerDatas.categories[i]==phz_pb.ZI_MO and roomData.setting.ziMoFan == 0 then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'自摸：','+1囤',true)
            end
        end 
        if roomType == proxy_pb.LYZP then
            if playerDatas.categories[i]==phz_pb.ZI_MO then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'自摸：','囤x2',true)
            end
        end
        if roomType == proxy_pb.NXPHZ or roomType == proxy_pb.AHPHZ then
            if playerDatas.categories[i]==phz_pb.ZI_MO and roomData.setting.ziMoAddTun ~= 0 then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'自摸：','+'..roomData.setting.ziMoAddTun..'囤',true)
            end
        end
        if roomType == proxy_pb.YXPHZ then
            if playerDatas.categories[i]==phz_pb.QI_DUI then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'七对：','40分',true)
            end
            if playerDatas.categories[i]==phz_pb.SHUANG_LONG then
                this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'双龙：','40分',true)
            end
        end
    end 
    
    if roomType == proxy_pb.YXPHZ then
        local isHaveWuFu = false
        for i = 1, #playerDatas.categories do
            if playerDatas.categories[i]==phz_pb.WU_FU then
                isHaveWuFu = true
            end
        end
        if not isHaveWuFu then
            if roomData.setting.mode == 0 then
                if playerDatas.lianzhuang > 1 then
                    this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'连庄：','x'..playerDatas.lianzhuang,true)
                end
            else
                if playerDatas.lianzhuang > 1 then
                    this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'中庄：','x2',true)
                end
            end
        end
    end
    if roomType == proxy_pb.LYZP then
        if playerDatas.tiScore > 0 then
            this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'提龙：','+'..playerDatas.tiScore..'分',true)
        elseif playerDatas.tiScore < 0 then
            this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'提龙：',playerDatas.tiScore..'分',true)
        end
    end 
    if (roomData.setting.roomTypeValue == proxy_pb.NXPHZ or roomData.setting.roomTypeValue == proxy_pb.CSPHZ or roomData.setting.roomTypeValue == proxy_pb.AHPHZ) and roomData.setting.zhaNiao ~= 0 then
        if playerDatas.zhaNiao > 0 then
            this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'扎鸟：','+'..playerDatas.zhaNiao..'分',true)
        elseif playerDatas.zhaNiao < 0 then
            this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'扎鸟：',playerDatas.zhaNiao..'分',true)
        end
    end
    if roomData.setting.roomTypeValue == proxy_pb.CZZP and roomData.setting.piao ~= 0 then
        if playerDatas.piao > 0 then
            this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'飘分：','+'..playerDatas.piao..'分',true)
        elseif playerDatas.piao < 0 then
            this.CreateAndSetWinnerData(playerObj.winner_data,winnerDataItem,'飘分：',playerDatas.piao..'分',true)
        end
    end
    --翻醒和跟醒
    if roomType == proxy_pb.HYSHK or roomType == proxy_pb.HYLHQ and roomData.setting.xing ~= 2 then
        local obj = NGUITools.AddChild(playerObj.winner_data.gameObject, xingItem.gameObject)
        obj.gameObject:SetActive(true)
        obj.transform:GetComponent('UILabel').text = roomData.setting.xing == 0 and '翻醒:' or '跟醒:'
        obj.transform:Find('plate/num'):GetComponent('UISprite').spriteName = 'card1_'..playerDatas.xingPlate
        obj.transform:Find('data'):GetComponent('UILabel').text = 'x'..playerDatas.xingPlateCount
    end
    playerObj.winner_data:GetComponent('UITable'):Reposition()
    StartCoroutine(function()
        WaitForEndOfFrame()
        for i = 0, playerObj.winner_data.childCount-1 do
            if playerObj.winner_data:GetChild(i).gameObject.name == 'xingItem' then
                local pos =  playerObj.winner_data:GetChild(i).localPosition
                pos.y = -14
                playerObj.winner_data:GetChild(i).localPosition = pos
            end
        end
	end)
    
end

function this.CreateAndSetWinnerData(grid,item,text1,text2,isShow)
    local obj = NGUITools.AddChild(grid.gameObject, item.gameObject)
    obj.gameObject:SetActive(isShow)
    obj.transform:GetComponent('UILabel').text = text1
    obj.transform:Find('data'):GetComponent('UILabel').text = text2
end

function this.SetWinnerDataFontSize(obj,size1,size2)
    obj:GetComponent('UILabel').fontSize = size1
    obj:Find('data'):GetComponent('UILabel').fontSize = size2
end
function this.OnClickButtonOK(go)
    AudioManager.Instance:PlayAudio('btn')
    print('RoundData.over',tostring(RoundData.over))
	if RoundData.isInGame then 
		if RoundData.over==true  then
        if RoundAllData.over==true then
            PanelManager.Instance:ShowWindow('panelStageClearAll')
        else
            print('总结算数据还没过来，请等待')    
        end
		else
			local msg = Message.New()
			msg.type = phz_pb.READY
			SendGameMessage(msg, nil)
		end
		panelInGameLand.hasStageClear=false
	end
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickButtonShare()
	if not RoundData.isInGame then 
		return
	end
    local data = {}
    data.showName = 'JieTuShare'
    PanelManager.Instance:ShowWindow('panelShared', data)
end

function this.OnClickButtonKnow(go)
    Guide.gameObject:SetActive(false)
    UnityEngine.PlayerPrefs.SetInt('roundEndGuide', 1)
end 

function this.GetShukuang_pai(operation)
    --print("牌操作码：" .. operation)
    if operation == phz_pb.CHI then
        return "吃"
    elseif operation == phz_pb.PENG then
        return "碰"
    elseif operation == phz_pb.WEI or operation == phz_pb.CHOU_WEI then
        return roomData.setting.roomTypeValue == proxy_pb.YJGHZ and '歪' or "偎"
    elseif operation == phz_pb.PAO then
        return roomData.setting.roomTypeValue == proxy_pb.YJGHZ and '漂' or "跑"
    elseif operation == phz_pb.TI or operation == phz_pb.START_TI then
        return roomData.setting.roomTypeValue == proxy_pb.YJGHZ and '溜' or "提"
    elseif operation == phz_pb.KAN then
        return "坎"
    elseif operation == phz_pb.JIAO then
        return "绞"
    elseif operation == phz_pb.JU then
        return "句"
    elseif operation == phz_pb.DUI then
        return "对"
    else
        print("牌操作码：" .. operation .. "没有对上")
        return "空"
    end
end

--牌 大小字判断 大为true 
function this.IsDAorXiao(plates)
    for i = 1, #plates do
        if plates[i] > 9 then
            return true
        end
    end

    return false
end

function this.Is123or2710or1510(plates)
    table.sort(plates, tableSortAsc)

    if (plates[1] == 0 and plates[2] == 1 and plates[3] == 2) or
    (plates[1] == 10 and plates[2] == 11 and plates[3] == 12) then
        return true
    elseif (plates[1] == 1 and plates[2] == 6 and plates[3] == 9) or
    (plates[1] == 11 and plates[2] == 16 and plates[3] == 19) then
        return true
	elseif (plates[1] == 0 and plates[2] == 4 and plates[3] == 9) or
    (plates[1] == 10 and plates[2] == 14 and plates[3] == 19) then
        return true
    end

    return false
end

function this.GetHuXi(operation, plates)

    local huxi = 0
    local IsDa = this.IsDAorXiao(plates)

    if operation == phz_pb.CHI or operation == phz_pb.JU or operation == phz_pb.JIAO then
        local str = ""
        for i = 1, #plates do
            str = str .. "牌值：" .. plates[i] .. "|"
        end

        print("牌型码：" .. operation .. "|" .. str .. "牌型长度：" .. #plates)

        if this.Is123or2710or1510(plates) then
            if IsDa then
                huxi = 6
            else
                huxi = 3
            end
        else
            huxi = 0
        end
    elseif operation == phz_pb.PENG then
        if IsDa then
            huxi = 3
        else
            huxi = 1
        end
    elseif operation == phz_pb.KAN or operation == phz_pb.WEI or operation == phz_pb.CHOU_WEI then
        if IsDa then
            huxi = 6
        else
            huxi = 3
        end
    elseif operation == phz_pb.PAO then
        if IsDa then
            huxi = 9
        else
            huxi = 6
        end
    elseif operation == phz_pb.TI or operation == phz_pb.START_TI then
        if IsDa then
            huxi = 12
        else
            huxi = 9
        end
    end

    return huxi
end

function  this.ScoreOrFengDing(score)
    if score < roomData.setting.maxHuXi then
        return score
    else
        return roomData.setting.maxHuXi
    end
end


function this.ZongJi()
    local min =0
    for i=2 ,roomData.setting.size do
        if RoundData.data.players[i].score <min then 
            min = RoundData.data.players[i].score
        end
    end 
    return math.abs( min )
end


function this.WhoShow(fuc)
	fuc()
end