local phz_pb = require 'phz_pb'

panelStageClearAll = {}
local this = panelStageClearAll

local message
local gameObject

local bg
local title
local ButtonSharde
local ButtonOk
local LinkShare, JieTuShare, quit
local diBan
local markWin
local wanFa
local id
local name
local player = {}

local size2or3
local size4Trans
local size4Objects={}

local ErRenWinDiBan--两个人的时候赢家的底板
local DownButtons
local nextBtn
local chengJiStr--输赢分数的string
function this.Awake(obj)
    gameObject = obj
    bg    = gameObject.transform:Find('bg')
    title = gameObject.transform:Find('bg/title')

    message = gameObject:GetComponent('LuaBehaviour')


    size2or3=gameObject.transform:Find('bg/size2or3')
    size4Trans=gameObject.transform:Find('bg/size4')
    ErRenWinDiBan=gameObject.transform:Find('bg/size2or3/ditu')
    for i = 1, 3 do
        player[i] = {}
        player[i].diBan = gameObject.transform:Find('bg/size2or3/ditu' .. i)
        player[i].mygrid = player[i].diBan:Find('Grid')
        
        player[i].erweima = player[i].diBan:Find('2weima')
        player[i].qianming = player[i].erweima:Find('qianming')
        player[i].moredata = player[i].erweima:Find(i)
        message:AddClick(player[i].moredata.gameObject, this.OnClickMoreData)

        player[i].tx = player[i].diBan:Find('txk/tx')				--頭像
        player[i].trusteeship = player[i].diBan:Find('txk/trusteeship') --托管标志
        player[i].name = player[i].diBan:Find('Label1')            --名字
        player[i].id = player[i].diBan:Find('Label2')              --用户ID
        player[i].bigWin = player[i].diBan:Find('bigWin')				-- 大赢家彩带
        player[i].win = player[i].diBan:Find('win')				-- 赢家彩带
        player[i].markWin = player[i].diBan:Find('markwin')			--markwin
        player[i].niao = player[i].diBan:Find('Niao')
        player[i].tuo = player[i].diBan:Find('Tuo')

        player[i].totalHuXi = player[i].diBan:Find('totalHuXi')    --总胡息
        player[i].Label_hp = player[i].mygrid:Find('Label_hp')      --胡牌次数
        player[i].Label_zm = player[i].mygrid:Find('Label_zm')      --自摸次数
        player[i].Label_dp = player[i].mygrid:Find('Label_dp')      --点炮次数
        player[i].Label_tp = player[i].mygrid:Find('Label_tp')      --提牌次数
        player[i].Label_pp = player[i].mygrid:Find('Label_pp')      --跑牌次数
        player[i].Label_niao = player[i].diBan:Find('Label_niao')  --鸟分
        player[i].Label_sum = player[i].diBan:Find('Label_sum')    --总成绩
        message:AddClick(player[i].Label_sum.gameObject, this.OnClickPress)    
        ------------------------------------------------------------------------------下面的是数据
        player[i].totalHuXi_num = player[i].totalHuXi:GetChild(0)   --总胡息    
        player[i].Label_hp_num = player[i].Label_hp:GetChild(0)      --胡牌次数
        player[i].Label_zm_num = player[i].Label_zm:GetChild(0)     --自摸次数
        player[i].Label_dp_num = player[i].Label_dp:GetChild(0)    --点炮次数
        player[i].Label_tp_num = player[i].Label_tp:GetChild(0)      --提牌次数
        player[i].Label_pp_num = player[i].Label_pp:GetChild(0)      --跑牌次数
        player[i].Label_sum_num = player[i].Label_sum:GetChild(0)    --总成绩
        player[i].fatigue = player[i].Label_sum:Find('fatigue')  --疲劳值
        player[i].Label_niao_num = player[i].Label_niao:GetChild(0)   --鸟分
    end
    this.GetSize4Objects()
    if IsAppleReview() then
        bt1.gameObject:SetActive(false)
    end


    DownButtons = gameObject.transform:Find("DownButtons")
    local backButton = DownButtons.transform:Find("quit")
    local jieTuShareBtn = DownButtons.transform:Find("JieTuShare")
    local linkShareBtn = DownButtons.transform:Find("LinkShare")
    nextBtn = DownButtons.transform:Find("next")
    message:AddClick(backButton.gameObject, this.OnClickMask)
    message:AddClick(jieTuShareBtn.gameObject, this.OnClickJieTuShare)
    message:AddClick(linkShareBtn.gameObject, this.OnClickShareLink)
    message:AddClick(nextBtn.gameObject, function()
        AudioManager.Instance:PlayAudio('btn')
        local msg = Message.New()
        msg.type = proxy_pb.QUICK_MATCH;
        local body = proxy_pb.PQuickMatch();
        body.ruleId = roomData.setting.ruleId
        body.gameType = proxy_pb.PHZ
        msg.body = body:SerializeToString()
        SendProxyMessage(msg, QuickMatch);
    end)
end

function this.GetSize4Objects()
    for i = 1, 4 do
        size4Objects[i] = {}
        size4Objects[i].diBan = size4Trans.transform:Find('player'.. i)
        size4Objects[i].mygrid = size4Objects[i].diBan:Find('Grid')
        
        size4Objects[i].erweima = size4Objects[i].diBan:Find('2weima')
        size4Objects[i].qianming = size4Objects[i].erweima:Find('qianming')
        size4Objects[i].moredata = size4Objects[i].erweima:Find(i)
        message:AddClick(size4Objects[i].moredata.gameObject, this.OnClickMoreData)

        size4Objects[i].tx = size4Objects[i].diBan:Find('txk/tx')				--頭像
        size4Objects[i].trusteeship = size4Objects[i].diBan:Find('txk/trusteeship') --托管标志
        size4Objects[i].name = size4Objects[i].diBan:Find('name')            --名字
        size4Objects[i].id = size4Objects[i].diBan:Find('id')              --用户ID
        size4Objects[i].bigWin = size4Objects[i].diBan:Find('bigWin')				-- 大赢家彩带
        size4Objects[i].win = size4Objects[i].diBan:Find('win')				-- 赢家彩带
        size4Objects[i].markWin = size4Objects[i].diBan:Find('markwin')			--markwin
        size4Objects[i].niao = size4Objects[i].diBan:Find('Niao')
        size4Objects[i].tuo = size4Objects[i].diBan:Find('Tuo')

        size4Objects[i].totalHuXi = size4Objects[i].diBan:Find('totalHuXi')    --总胡息
        size4Objects[i].Label_hp = size4Objects[i].mygrid:Find('Label_hp')      --胡牌次数
        size4Objects[i].Label_zm = size4Objects[i].mygrid:Find('Label_zm')      --自摸次数
        size4Objects[i].Label_dp = size4Objects[i].mygrid:Find('Label_dp')      --点炮次数
        size4Objects[i].Label_tp = size4Objects[i].mygrid:Find('Label_tp')      --提牌次数
        size4Objects[i].Label_pp = size4Objects[i].mygrid:Find('Label_pp')      --跑牌次数
        size4Objects[i].Label_niao = size4Objects[i].diBan:Find('Label_niao')  --鸟分
        size4Objects[i].Label_sum = size4Objects[i].diBan:Find('Label_sum')    --总成绩
        message:AddClick(size4Objects[i].Label_sum.gameObject, this.OnClickPress)    
        ------------------------------------------------------------------------------下面的是数据
        size4Objects[i].totalHuXi_num = size4Objects[i].totalHuXi:GetChild(0)   --总胡息    
        size4Objects[i].Label_hp_num = size4Objects[i].Label_hp:GetChild(0)      --胡牌次数
        size4Objects[i].Label_zm_num = size4Objects[i].Label_zm:GetChild(0)     --自摸次数
        size4Objects[i].Label_dp_num = size4Objects[i].Label_dp:GetChild(0)    --点炮次数
        size4Objects[i].Label_tp_num = size4Objects[i].Label_tp:GetChild(0)      --提牌次数
        size4Objects[i].Label_pp_num = size4Objects[i].Label_pp:GetChild(0)      --跑牌次数
        size4Objects[i].Label_sum_num = size4Objects[i].Label_sum:GetChild(0)    --总成绩
        size4Objects[i].fatigue = size4Objects[i].Label_sum:Find('fatigue')      --疲劳值
        size4Objects[i].Label_niao_num = size4Objects[i].Label_niao:GetChild(0)   --鸟分
    end
end
function this.Start()
end

function this.Update()
end

function this.OnEnable()
    if RoundAllData.roomData.setting.roomTypeValue then
        wanFa = RoundAllData.roomData.setting.roomTypeValue
    else
        wanFa = ''
        print('木有玩法传过来')
    end
    gameObject.transform:Find('bg/wanfa'):GetComponent('UILabel').text = RoundAllData.playName
    gameObject.transform:Find('bg/time'):GetComponent('UILabel').text = '时间：' .. os.date('%Y/%m/%d %H:%M')
    gameObject.transform:Find('bg/room'):GetComponent('UILabel').text = '房间号：' .. roomInfo.roomNumber
    if roomData.setting.size == 4 then
        size2or3.gameObject:SetActive(false)
        size4Trans.gameObject:SetActive(true)
        this.fuzhi(size4Objects) 
    else
        size2or3.gameObject:SetActive(true)
        size4Trans.gameObject:SetActive(false)
        this.fuzhi(player)  
    end
    panelInGameLand.initHandGridAndEffect()
    nextBtn.gameObject:SetActive(roomData.clubId ~= '0')
    DownButtons:GetComponent('UIGrid'):Reposition()
end
function this.fuzhi(obj) 
    chengJiStr=''
    local mark, morewin, two = 0, 0, 0                   --mark 统计最高分，morewin标记大赢家位置，two表明第二个同分数大赢家
    for i = 1, #obj do
        obj[i].bigWin.gameObject:SetActive(false)
        obj[i].win.gameObject:SetActive(false)
        obj[i].niao.gameObject:SetActive(false)
        obj[i].tuo.gameObject:SetActive(false)
        obj[i].trusteeship.gameObject:SetActive(false)
        if wanFa == proxy_pb.SYBP or wanFa == proxy_pb.SYZP or wanFa == proxy_pb.HHHGW or wanFa == proxy_pb.CSPHZ then
            obj[i].Label_dp.gameObject:SetActive(false)
        end
        obj[i].totalHuXi.gameObject:SetActive(true)
        if wanFa == proxy_pb.SYBP 
        or wanFa == proxy_pb.LDFPF 
        or wanFa == proxy_pb.XXGHZ
        or wanFa == proxy_pb.YJGHZ then
            obj[i].totalHuXi:GetComponent('UISprite').spriteName='总胡息：拷贝4'
            obj[i].totalHuXi:GetComponent("UISprite"):MakePixelPerfect()
        else
            obj[i].totalHuXi:GetComponent('UISprite').spriteName='大结算-总得分'
            obj[i].totalHuXi:GetComponent("UISprite"):MakePixelPerfect()
        end
        obj[i].diBan:Find('txk/Sprite').gameObject:SetActive(false)
        obj[i].mygrid:GetComponent('UIGrid'):Reposition()
    end
    
    for i = 1, #obj do
        if RoundAllData and i <= roomData.setting.size then
            local playerData = panelInGame.GetPlayerDataBySeat(RoundAllData.data.players[i].seat)
            coroutine.start(LoadPlayerIcon, obj[i].tx:GetComponent('UITexture'), playerData.icon)
            if playerData then
                if playerData.seat == roomData.bankerSeat then
                    obj[i].diBan:Find('txk/Sprite').gameObject:SetActive(true)
                end
                coroutine.start(LoadPlayerIcon, obj[i].tx:GetComponent('UITexture'), playerData.icon)
                obj[i].id:GetComponent('UILabel').text = 'ID:' .. playerData.id
            end
            chengJiStr=chengJiStr..'【'..playerData.name..'】 '..RoundAllData.data.players[i].sum..';'
            obj[i].name:GetComponent('UILabel').text = playerData.name
            obj[i].totalHuXi_num:GetComponent('UILabel').text = RoundAllData.data.players[i].totalHuXi
            obj[i].Label_hp_num:GetComponent('UILabel').text = RoundAllData.data.players[i].huCount
            obj[i].Label_zm_num:GetComponent('UILabel').text = RoundAllData.data.players[i].ziMoCount
            obj[i].Label_dp_num:GetComponent('UILabel').text = RoundAllData.data.players[i].dianPaoCount

            obj[i].Label_tp_num.parent:GetComponent('UILabel').text = wanFa == proxy_pb.YJGHZ and '溜牌次数：' or '提牌次数：'
            obj[i].Label_pp_num.parent:GetComponent('UILabel').text = wanFa == proxy_pb.YJGHZ and '漂牌次数：' or '跑牌次数：'

            obj[i].Label_tp_num:GetComponent('UILabel').text = RoundAllData.data.players[i].tiCount
            obj[i].Label_pp_num:GetComponent('UILabel').text = RoundAllData.data.players[i].paoCount
            obj[i].Label_niao.gameObject:SetActive(false)
            --托管标志
            local  k = i
            if RoundAllData.data.players[i].bigWinner~=nil and RoundAllData.data.players[i].bigWinner==true then
                if roomData.setting.size == 2 then
                    if i == 2 then
                        k = 3					
                    end
                end
            end
            obj[k].trusteeship.gameObject:SetActive(RoundAllData.isTrusteeships[RoundAllData.data.players[i].seat])
            
            --自摸，点炮的显隐
            if roomData.setting.roomTypeValue == proxy_pb.LDFPF then
                obj[i].Label_zm.gameObject:SetActive(false)
                obj[i].Label_dp.gameObject:SetActive(true)
            else
                obj[i].Label_zm.gameObject:SetActive(true)
                obj[i].Label_dp.gameObject:SetActive(false)
            end
            --打鸟和打陀标记设置
            if roomData.setting.roomTypeValue ~= proxy_pb.XXGHZ then
                obj[i].niao.gameObject:SetActive(playerData.daNiao == 1)
                 --不打鸟也展示 默认值0
                obj[i].Label_niao.gameObject:SetActive(true)
                obj[i].tuo.gameObject:SetActive(false);
            end
            
            if roomData.setting.roomTypeValue == proxy_pb.XXGHZ then--湘乡告胡子才有打陀
                obj[i].tuo.gameObject:SetActive(playerData.daTuo == 1)
                obj[i].niao.gameObject:SetActive(false);
            end
            obj[i].Label_niao_num:GetComponent('UILabel').text = (RoundAllData.data.players[i].niaoValue > 0 and '+' or '')..tostring(RoundAllData.data.players[i].niaoValue)
            
            obj[i].Label_sum_num:GetComponent('UILabel').effectColor = RoundAllData.data.players[i].sum > 0 and Color(218 / 255, 218 / 255, 218 / 255) or Color(20 / 255, 144 / 255, 185 / 255)
            obj[i].Label_sum_num:GetComponent('UILabel').color = RoundAllData.data.players[i].sum > 0 and Color(214 / 255, 18 / 255, 0 / 255) or Color(22 / 255, 92 / 255, 249 / 255)
            obj[i].Label_sum_num:GetComponent('UILabel').text = (RoundAllData.data.players[i].sum > 0 and '+' or '').. RoundAllData.data.players[i].sum

            if RoundAllData.data.players[i].fee ~= nil then
                obj[i].fatigue:GetComponent('UILabel').text = RoundAllData.data.players[i].fee
                obj[i].fatigue.gameObject:SetActive(tonumber(RoundAllData.data.players[i].fee)~=0)
                local sumPos = obj[i].Label_sum_num.localPosition
                sumPos.y = tonumber(RoundAllData.data.players[i].fee)~=0 and 15 or -3
                obj[i].Label_sum_num.localPosition = sumPos
            end
            obj[i].diBan.gameObject:SetActive(true)
            obj[i].mygrid.gameObject:SetActive(true)
            obj[i].Label_sum:GetComponent('BoxCollider').enabled = false
            obj[i].erweima.gameObject:SetActive(false)

            obj[i].bigWin.gameObject:SetActive(RoundAllData.data.players[i].bigWinner~=nil and RoundAllData.data.players[i].bigWinner==true)
            obj[i].win.gameObject:SetActive(not obj[i].bigWin.gameObject.activeSelf and RoundAllData.data.players[i].winner~=nil and RoundAllData.data.players[i].winner==true)
            if roomData.setting.size ~= 2 and (obj[i].bigWin.gameObject.activeSelf or obj[i].win.gameObject.activeSelf) then
                print('大赢家是'..i)
                print('我的座位号是'..RoundAllData.mySeat)
                print('大赢家的座位号是'..RoundAllData.data.players[i].seat)
                if roomData.setting.size == 3 then
                    obj[2].diBan.localPosition = Vector3(0, 10, 0)
                end
                if RoundAllData.mySeat==RoundAllData.data.players[i].seat then
                    obj[i].mygrid.gameObject:SetActive(false)
                    obj[i].erweima.gameObject:SetActive(true)
                    if RoundAllData.data.players[i] then
                        local tmpData=panelInGame.GetPlayerDataBySeat(RoundAllData.data.players[i].seat)
                        obj[i].qianming:GetComponent('UILabel').text=tmpData.signature
                        obj[i].erweima:GetComponent('UITexture').mainTexture=nil
                        coroutine.start(LoadFengCaiZhao, obj[i].erweima:GetComponent('UITexture'), tmpData.imgUrl)
                    end
                end
            end
            obj[i].mygrid:GetComponent('UIGrid'):Reposition()
        else
            obj[i].diBan.gameObject:SetActive(false)
        end
    end
    ErRenWinDiBan.gameObject:SetActive(false)
    if roomData.setting.size == 2 then
        for i=1,#obj do
            if obj[i].bigWin.gameObject.activeSelf or obj[i].win.gameObject.activeSelf then
                print('大赢家是aa'..i)
                obj[2].diBan.localPosition = Vector3(406, 10, 0)
                ErRenWinDiBan.gameObject:SetActive(true)
                if RoundAllData.data.players[i] then
                    local tmpData=panelInGame.GetPlayerDataBySeat(RoundAllData.data.players[i].seat)
                    ErRenWinDiBan:Find('2weima/qianming'):GetComponent('UILabel').text=tmpData.signature
                    ErRenWinDiBan:Find('2weima'):GetComponent('UITexture').mainTexture=nil
                    coroutine.start(LoadFengCaiZhao, ErRenWinDiBan:Find('2weima'):GetComponent('UITexture'), tmpData.imgUrl)
                end
                break
            end
        end
    end
end

function this.OnClickMask(go)
    AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow('panelInGameLand')
    if roomData.clubId ~= '0' then
        local data = {}
        data.name = gameObject.name
        data.clubId = roomData.clubId
        PanelManager.Instance:ShowWindow('panelClub', data)
    else
        PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
    end
end

function this.OnClickJieTuShare(go)
    AudioManager.Instance:PlayAudio('btn')
    local data = {}
    data.showName = 'JieTuShare'
    PanelManager.Instance:ShowWindow('panelShared', data)
end

--http://agent.gzrt8.cn/shareResult.html?roomId=38c1327e-2a64-4b62-ba1f-efd7146ee55a
function this.OnClickShareLink(go)
    AudioManager.Instance:PlayAudio('btn')
    local title = '房号:【' .. roomInfo.roomNumber.."】成绩出炉啦！"
    local msg = chengJiStr..'时间：' .. os.date('%Y/%m/%d %H:%M，')
    if roomData.setting.roomTypeValue ~= nil and playTypeString[roomData.setting.roomTypeValue] ~= nil then
        msg = msg..playTypeString[roomData.setting.roomTypeValue]
    end
    local data = {}
    data.showName = 'LinkShare'
    data.roomId = RoundAllData.data.roomId
    data.title = title
    data.msg = msg
    PanelManager.Instance:ShowWindow('panelShared', data)
end


function this.OnClickMoreData(go)
    print('查看更多!!!!!!!!!~.'..go.name)
    if roomData.setting.size == 4 then
        for i = 1, #size4Objects do
            if go.name == tostring(i) then
                size4Objects[i].mygrid.gameObject:SetActive(true)
                size4Objects[i].Label_sum:GetComponent('BoxCollider').enabled = true
                size4Objects[i].erweima.gameObject:SetActive(false)
            end
        end
    else
        if go.name == '1' then
            player[1].mygrid.gameObject:SetActive(true)
            player[1].Label_sum:GetComponent('BoxCollider').enabled = true
            player[1].erweima.gameObject:SetActive(false)
        elseif go.name == '2' then
            player[2].mygrid.gameObject:SetActive(true)
            player[2].Label_sum:GetComponent('BoxCollider').enabled = true
            player[2].erweima.gameObject:SetActive(false)
        elseif go.name == '3' then
            player[3].mygrid.gameObject:SetActive(true)
            player[3].Label_sum:GetComponent('BoxCollider').enabled = true
            player[3].erweima.gameObject:SetActive(false)
        end
    end
end

function this.OnClickPress(go)
    print('二维码!!!!!!!!!~.'..go.name)
    if roomData.setting.size == 4 then
        for i = 1, #size4Objects do
            if go.transform.parent.name == 'player'..tostring(i) then
                size4Objects[i].mygrid.gameObject:SetActive(false)
                size4Objects[i].Label_sum:GetComponent('BoxCollider').enabled = false
                size4Objects[i].erweima.gameObject:SetActive(true)
            end
        end
    else   
        if go.transform.parent.name == 'ditu1' then
            player[1].mygrid.gameObject:SetActive(false)
            player[1].Label_sum:GetComponent('BoxCollider').enabled = false
            player[1].erweima.gameObject:SetActive(true)
        elseif go.transform.parent.name == 'ditu2' then
            player[2].mygrid.gameObject:SetActive(false)
            player[2].Label_sum:GetComponent('BoxCollider').enabled = false
            player[2].erweima.gameObject:SetActive(true)
        elseif go.transform.parent.name == 'ditu3' then
            player[3].mygrid.gameObject:SetActive(false)
            player[3].Label_sum:GetComponent('BoxCollider').enabled = false
            player[3].erweima.gameObject:SetActive(true)
        end
    end
    
end