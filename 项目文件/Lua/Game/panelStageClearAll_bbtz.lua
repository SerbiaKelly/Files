panelStageClearAll_bbtz = {}
local this = panelStageClearAll_bbtz

local message
local gameObject = nil
local playerViews = {}

local TimeLabel
local RoomIDLabel

local showbg
local chengJiStr = "";
local nextBtn
local DownButtons
function this.Awake(go)
    gameObject = go
    message = gameObject:GetComponent('LuaBehaviour')

    local gamers = gameObject.transform:Find("Gamers")
    for i = 1, 3 do
        local playerView = {}
        local objectStr = "Player"..i.."/"
        playerView.gameObject = gamers.transform:Find("Player"..i).gameObject
        playerView.Info = {}
        playerView.Info.ID = gamers.transform:Find(objectStr.."playerID")
        playerView.Info.Name = gamers.transform:Find(objectStr.."playerName")
        playerView.Info.Image = gamers.transform:Find(objectStr.."Texture")
        playerView.Info.Qrcode = gamers.transform:Find(objectStr.."Qrcode")
        playerView.Info.Signature = gamers.transform:Find(objectStr.."Qrcode/signature")
        playerView.Info.trusteeship = gamers.transform:Find(objectStr.."trusteeship");
        playerView.Info.fatigue = gamers.transform:Find(objectStr.."fatigue");
        playerView.Info.Roomer = gamers.transform:Find(objectStr.."Roomer");
        playerView.GameInfo = {}
        playerView.GameInfo.Winner = gamers.transform:Find(objectStr.."winner")
        playerView.GameInfo.DiZhaTime = gamers.transform:Find(objectStr.."info/DiZhaTime/num")
        playerView.GameInfo.KingTime = gamers.transform:Find(objectStr.."info/KingTime/num")
        playerView.GameInfo.MasterTime = gamers.transform:Find(objectStr.."info/MasterTime/num")
        playerView.GameInfo.FirstTime = gamers.transform:Find(objectStr.."info/FirstTime/num")
        playerView.GameInfo.TotalSocre = gamers.transform:Find(objectStr.."totalSocre/totalSocre_num")
        playerView.GameInfo.PlayerSocre = gamers.transform:Find(objectStr.."playerSocre/num")
        table.insert(playerViews, playerView)

        message:AddClick(playerView.gameObject.transform:Find('Qrcode/1').gameObject, this.OnClickMoreData)
		message:AddClick(playerView.gameObject.transform:Find('Background').gameObject, this.OnClickPress)
    end

    TimeLabel = gameObject.transform:Find("RoomInfo/Time")
    RoomIDLabel = gameObject.transform:Find("RoomInfo/Room")

    showbg = gameObject.transform:Find("showbg")

    DownButtons = gameObject.transform:Find("DownButtons")
    local backButton = DownButtons.transform:Find("quit")
    local jieTuShareBtn = DownButtons.transform:Find("JieTuShare")
    local linkShareBtn = DownButtons.transform:Find("LinkShare")
    nextBtn = DownButtons.transform:Find("next")
    message:AddClick(backButton.gameObject, this.OnClickBack)
    message:AddClick(jieTuShareBtn.gameObject, this.OnClickJieTuShare)
    message:AddClick(linkShareBtn.gameObject, this.OnClickShareLink)
    message:AddClick(nextBtn.gameObject, function()
        AudioManager.Instance:PlayAudio('btn')
        local msg = Message.New()
        msg.type = proxy_pb.QUICK_MATCH;
        local body = proxy_pb.PQuickMatch();
        body.ruleId = RoundAllData.roomData.setting.ruleId
        body.gameType = proxy_pb.BBTZ
        msg.body = body:SerializeToString()
        SendProxyMessage(msg, QuickMatch);
    end)
end

function this.OnEnable()
    nextBtn.gameObject:SetActive(RoundAllData.roomData.clubId ~= '0')
    DownButtons:GetComponent('UIGrid'):Reposition()
    for i = 1, #playerViews do
        local playerView = playerViews[i]
        this.ResetPlayerView(playerView,0, 0, 0, 0, 0, 0, 0, 0, 0,false,nil,false,false)
    end

    this.InitView()
end

function this.InitView()
    this.SetLabelText(TimeLabel, '时间：' .. os.date('%Y/%m/%d %H:%M'))
    this.SetLabelText(RoomIDLabel, '房间号：' .. roomInfo.roomNumber)
    chengJiStr = "";

    local maxSore, winSeat = 0, 0
    for i=1,#RoundAllData.data.players do
		if RoundAllData.data.players[i].score > maxSore then
			maxSore = RoundAllData.data.players[i].score
			winSeat = RoundAllData.data.players[i].seat
		end
	end

    local needHide = #RoundAllData.data.players == 2
    playerViews[2].gameObject:SetActive(not needHide)
    for i = 1, 3 do
        while true do
            if needHide and i == 2 then
                break
            end

            local playerView = playerViews[i]
            if needHide and i == 3 then i = 2 end
            local playerEnd = RoundAllData.data.players[i]
            local playerData = RoundAllData.playerDatas[playerEnd.seat]
            print("playerEnd.fatigue:"..tostring(playerEnd.fee));
            print("playerEnd.isOwner:"..tostring(playerEnd.isOwner));

            this.ResetPlayerView(
                playerView, 
                playerData.seat, 
                playerData.id, 
                playerData.name, 
                playerEnd.signature,
                playerEnd.boomCount, 
                playerEnd.kingCount, 
                playerEnd.blankerCount,
                playerEnd.firstCount, 
                playerEnd.score, 
                winSeat == playerEnd.seat,
                playerEnd.fee,
                playerEnd.isOwner,
                RoundAllData.roomData.setting.gameMode
            )

           

            coroutine.start(LoadPlayerIcon, playerView.Info.Image:GetComponent("UITexture"), playerData.icon)
            coroutine.start(LoadFengCaiZhao, playerView.Info.Qrcode:GetComponent('UITexture'), playerEnd.imgUrl)
            break
        end
    end

    local mienPanel = gameObject.transform:Find("MienPanel")
    mienPanel.gameObject:SetActive(needHide)
    if needHide then
        local playerEnd = RoundAllData.playerDatas[winSeat]
        local qrcode = mienPanel.transform:Find("Qrcode")
        this.SetLabelText(qrcode:Find("signature"), playerEnd.signature)
        coroutine.start(LoadFengCaiZhao, qrcode:GetComponent('UITexture'), playerEnd.imgUrl)
    end
end

function this.UpdatePlayerView(playerView, info, gameInfo)
    this.SetLabelText(playerView.Info.ID, info.ID)
    this.SetLabelText(playerView.Info.Name, info.Name)
    coroutine.start(LoadPlayerIcon, playerView.Info.Iamge:Find('Texture'):GetComponent('UITexture'), info.icon)
end

function this.ResetPlayerView(playerView,seat, id, name, signature, boomCount, kingCount, blankerCount, firstCount, score, isWinner,fatigue,isOwner,gameMode)
    this.SetLabelText(playerView.Info.ID, id)
    this.SetLabelText(playerView.Info.Name, name)
    this.SetLabelText(playerView.Info.Signature, signature)
    playerView.Info.Image:GetComponent("UITexture").mainTexture = nil
    playerView.Info.Qrcode:GetComponent('UITexture').mainTexture = nil
    this.SetLabelText(playerView.GameInfo.DiZhaTime, boomCount)
    this.SetLabelText(playerView.GameInfo.KingTime, kingCount)
    this.SetLabelText(playerView.GameInfo.MasterTime, blankerCount)
    this.SetLabelText(playerView.GameInfo.FirstTime, firstCount)
    this.SetLabelText(playerView.GameInfo.TotalSocre, score)
    this.SetLabelText(playerView.GameInfo.PlayerSocre, this.GetNumColorAndString(score))
    playerView.Info.Qrcode.gameObject:SetActive(false)
    playerView.GameInfo.DiZhaTime.parent.gameObject:SetActive(true)
    playerView.GameInfo.Winner.gameObject:SetActive(isWinner)
    playerView.Info.trusteeship.gameObject:SetActive(RoundAllData.trusteeshipData[seat]);

    playerView.Info.Roomer.gameObject:SetActive(isOwner);

    if fatigue ~= nil then 
        this.SetLabelText(playerView.Info.fatigue,fatigue);
    end
    playerView.Info.fatigue.gameObject:SetActive(gameMode);
    local playerScoreLocation = playerView.GameInfo.PlayerSocre.localPosition;
    playerScoreLocation.y = gameMode and -57 or -69;
    playerView.GameInfo.PlayerSocre.localPosition = playerScoreLocation;

    chengJiStr=chengJiStr..'【'..name..'】 '..score..';'
end

function this.SetLabelText(label, text, color)
    label.gameObject:GetComponent("UILabel").text = text
    if color ~= nil then
        label.gameObject:GetComponent('UILabel').color = color
    end
end

function this.GetNumColorAndString(num)
    num = (num == nil) and 0 or num
    if num >= 0 then
        return "+"..num, Color(214/256, 18/256, 0)
    else
        return num, Color(0, 63/256, 165/256)
    end
end

function this.OnClickBack(go)
    PanelManager.Instance:HideAllWindow()
    if RoundAllData.roomData.clubId ~= '0' then
        local data = {}
        data.name = gameObject.name
        data.clubId = RoundAllData.roomData.clubId
        PanelManager.Instance:ShowWindow('panelClub', data)
    else
        PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
    end
end

function this.OnClickJieTuShare(go)
	AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:ShowWindow('panelShared', {showName = "JieTuShare"})
end

function this.OnClickShareLink(go)
    AudioManager.Instance:PlayAudio('btn')
    local title = '房号:【' .. roomInfo.roomNumber.."】成绩出炉啦！"
	local msg = chengJiStr..'时间：' .. os.date('%Y/%m/%d %H:%M，')
	msg = msg..'半边天炸'
	print("RoundAllData.data.roomId",'http://'..panelLogin.HttpUrl..'/share/toResult/' .. RoundAllData.data.roomId)

	local data = {}
    data.showName = 'LinkShare'
    data.roomId = RoundAllData.data.roomId
    data.title = title
    data.msg = msg
    PanelManager.Instance:ShowWindow('panelShared', data)
end

function this.OnClickMoreData(go)
	print('查看更多!!!!!!!!!~.')
	go.transform.parent.parent:Find("info").gameObject:SetActive(true)
	go.transform.parent.gameObject:SetActive(false)
end
function this.OnClickPress(go)
	print('二维码!!!!!!!!!~.')
	go.transform.parent:Find("info").gameObject:SetActive(false)
	go.transform.parent:Find("Qrcode").gameObject:SetActive(true)
end

function this.Update()
end
