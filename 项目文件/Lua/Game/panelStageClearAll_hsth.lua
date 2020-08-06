panelStageClearAll_hsth = {}
local this = panelStageClearAll_hsth

local message
local gameObject

local LinkShare, JieTuShare, quit

local roomID
local time
local wanfaName
local nextBtn
local DownButtons

local playerInfo={}
local winPlayer={}
local chengJiStr = ""
local playerScrollView
local playerGrid 
local playerItem
function this.Awake(obj)
	gameObject = obj
	message = gameObject:GetComponent('LuaBehaviour')

	roomID 			= gameObject.transform:Find('room')
	time 			= gameObject.transform:Find('time')
	wanfaName 		= gameObject.transform:Find('wanfa')

	DownButtons = gameObject.transform:Find("DownButtons")
    message:AddClick(DownButtons.transform:Find("quit").gameObject, this.OnClickMask)
    message:AddClick(DownButtons.transform:Find("JieTuShare").gameObject, this.OnClickJieTuShare)
	message:AddClick(DownButtons.transform:Find("LinkShare").gameObject, this.OnClickShareLink)
	nextBtn = DownButtons.transform:Find("next")
    message:AddClick(nextBtn.gameObject, function()
        AudioManager.Instance:PlayAudio('btn')
        local msg = Message.New()
        msg.type = proxy_pb.QUICK_MATCH
        local body = proxy_pb.PQuickMatch()
        body.ruleId = roomData.setting.ruleId
        body.gameType = proxy_pb.HSTH
        msg.body = body:SerializeToString()
        SendProxyMessage(msg, QuickMatch)
	end)
	playerItem = gameObject.transform:Find('playerItem')
	playerScrollView = gameObject.transform:Find('scrollView')
	playerGrid = playerScrollView:Find('players')
	
	for i = 0, 5 do
		local obj = NGUITools.AddChild(playerGrid.gameObject,playerItem.gameObject)
		local playerUI = {}
		playerUI.obj  = obj.transform
		playerUI.frame = playerUI.obj:Find('frame')
		playerUI.playerRoomer = playerUI.obj:Find('HeadImage/Roomer')
		playerUI.playerIcon = playerUI.obj:Find('HeadImage/HeadIcon')
		playerUI.playerName = playerUI.obj:Find('HeadImage/name')
		playerUI.playerID = playerUI.obj:Find('HeadImage/ID')
		playerUI.trusteeship = playerUI.obj:Find('HeadImage/trusteeship')
		playerUI.playerBigWinner = playerUI.obj:Find('HeadImage/bigWinner')
		playerUI.playerZongDeFen = playerUI.obj:Find('zongdefen/totalSocre_num')
		playerUI.playerScoreGroup = playerUI.obj:Find('ScoreGroup')
		message:AddClick(playerUI.playerScoreGroup.gameObject, this.OnClickButtonMoreInfo)
		playerUI.playerFirstCount = playerUI.playerScoreGroup:Find('firstCount')
		playerUI.playerTongCount = playerUI.playerScoreGroup:Find('tongCount')
		playerUI.playerTeamScore = playerUI.playerScoreGroup:Find('teamScore')
		playerUI.playerHapplyScore = playerUI.playerScoreGroup:Find('happlyScore')
		playerUI.playerResultReward = playerUI.playerScoreGroup:Find('resultReward')	
		playerUI.playerZongScore = playerUI.obj:Find('zongScore')	
		playerUI.playerFatigue = playerUI.obj:Find('fatigue')
		playerUI.playerQRCode = playerUI.obj:Find('QRCode')
		playerUI.playerShowTex = playerUI.playerQRCode:Find('showTex')
		playerUI.playerSign = playerUI.playerQRCode:Find('sign')
		playerUI.playerMoreInfo = playerUI.playerQRCode:Find('moreInfo')
		message:AddClick(playerUI.playerMoreInfo.gameObject, this.OnClickButtonMoreInfo)
		table.insert(playerInfo,playerUI)
	end
	winPlayer.obj = gameObject.transform:Find('winPlayer')
	winPlayer.qianming = winPlayer.obj:Find('qianming')
	winPlayer.erweima = winPlayer.obj:Find('2weima')
end

function this.Start()
end

function this.OnEnable()
	this.Refresh()
end

function this.WhoShow()
end

function this.Update()
end

function this.OnClickMask(go)
	AudioManager.Instance:PlayAudio('btn')
	PanelManager.Instance:HideWindow('panelInGame_hsth')
	PanelManager.Instance:HideWindow('panelStageClearAll_hsth')
	if roomData.clubId ~= '0' then
		local data = {}
		data.name = 'panelInGame_hsth'
		data.clubId = roomData.clubId
		PanelManager.Instance:ShowWindow('panelClub', data)
		print('我是俱乐部退出的游戏')
	else
		print('我不是俱乐部退出的游戏')
		PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
	end
	roomData.clubId = '0'
	return 
end
function this.OnClickJieTuShare(go)
	AudioManager.Instance:PlayAudio('btn')
    local data = {}
    data.showName = 'JieTuShare'
    PanelManager.Instance:ShowWindow('panelShared', data)
end
function this.OnClickShareLink(go)
	AudioManager.Instance:PlayAudio('btn')
	local data = {}
    data.showName = 'LinkShare'
    data.roomId = RoundAllData.roomId
    data.title = '房号:【' .. roomInfo.roomNumber.."】成绩出炉啦！"
    data.msg = chengJiStr..'时间：'..os.date('%Y/%m/%d %H:%M，')..'沅江千分'
    PanelManager.Instance:ShowWindow('panelShared', data)
end
function this.Refresh()
	nextBtn.gameObject:SetActive(roomData.clubId ~= '0')
	DownButtons:GetComponent('UIGrid'):Reposition()
	wanfaName:GetComponent('UILabel').text = roomData.playName
	roomID:GetComponent('UILabel').text = "房间号："..roomInfo.roomNumber
	time:GetComponent('UILabel').text = '时间：' .. os.date('%Y/%m/%d %H:%M')
	chengJiStr = ''
	for i = 1, roomData.setting.size do
		playerInfo[i].obj.gameObject:SetActive(false)
	end
	winPlayer.obj.gameObject:SetActive(roomData.setting.size==2)
	for i = 1, #RoundAllData.players do
		if roomData.setting.size == 2 then
			if i==2 then
				this.SetPlayerInfo(playerInfo[3],RoundAllData.players[i])
			else
				this.SetPlayerInfo(playerInfo[i],RoundAllData.players[i])
			end
		else
			this.SetPlayerInfo(playerInfo[i],RoundAllData.players[i])
		end
	end
	local cellHeight = 0
	local posX = 0
	if roomData.setting.size == 2 then
		playerInfo[2].obj.gameObject:SetActive(true)
		cellHeight = 430
		posX = -417
	elseif roomData.setting.size == 4 then
		cellHeight = 319
		posX = -460
	elseif roomData.setting.size == 6 then
		cellHeight = 304
		posX = -467
	end
	playerGrid.localPosition = Vector3(posX,playerGrid.localPosition.y,playerGrid.localPosition.z)
	playerGrid:GetComponent('UIGrid').cellHeight = cellHeight
	playerGrid:GetComponent('UIGrid'):Reposition()
	playerScrollView:GetComponent('UIScrollView'):ResetPosition()
end

function this.SetPlayerInfo(playerObj,data)
	playerObj.obj.gameObject:SetActive(true)
	local scsle = 1
	local posX1 = 0
	local posX2 = 0
	if roomData.setting.size == 2 then
		scsle = 1
		posX1 = -195
		posX2 = -43
	elseif roomData.setting.size == 4 then
		scsle = 0.83
		posX1 = -168
		posX2 = -14
	elseif roomData.setting.size == 6 then
		scsle = 0.82
		posX1 = -168
		posX2 = -14
	end
	playerObj.frame.localPosition = Vector3(posX1,playerObj.frame.localPosition.y,playerObj.frame.localPosition.z)
	playerObj.frame.localScale = Vector3.New(scsle,1,1)
	playerObj.playerBigWinner.localPosition = Vector3(posX2,playerObj.playerBigWinner.localPosition.y,playerObj.playerBigWinner.localPosition.z)

	chengJiStr=chengJiStr..'【'..data.name..'】 '..data.score..';'
	--房主
	playerObj.playerRoomer.gameObject:SetActive(data.seat==0)
	--头像
	coroutine.start(LoadPlayerIcon, playerObj.playerIcon:GetComponent('UITexture'), data.icon)
	--姓名
	playerObj.playerName:GetComponent("UILabel").text = data.name
	--id
	playerObj.playerID:GetComponent("UILabel").text = 'ID：'..data.id
	--大赢家
	playerObj.playerBigWinner.gameObject:SetActive(data.bigWinner)
	--托管
	playerObj.trusteeship.gameObject:SetActive(data.trusteeship)
	--总得分
	playerObj.playerZongDeFen:GetComponent("UILabel").text = data.win
	--上有次数
	playerObj.playerFirstCount:GetComponent("UILabel").text = "上游次数："..data.firstCount
	--同花次数
	playerObj.playerTongCount:GetComponent("UILabel").text = "同花次数："..data.happlyCount
	--团队得分
	local str = '牌面总分：'
	if roomData.setting.size == 2 then
		str = '牌面总分：'
	else
		if data.team == 1 then
			str = "A  组得分："
		elseif data.team == 2 then
			str = "B  组得分："
		end
	end
	playerObj.playerTeamScore:GetComponent("UILabel").text = str..data.happlyScore
	--喜得分
	playerObj.playerHapplyScore:GetComponent("UILabel").text = "喜总得分："..data.cardsScore
	--结算奖励
	playerObj.playerResultReward:GetComponent("UILabel").text = "结算奖励："..data.resultScore
	--总得分
	playerObj.playerZongScore:GetComponent("UILabel").text 	= data.score < 0 and ('[165CF9]'..data.score) or ('[D61200]+'..data.score)
	local sumLosePos = playerObj.playerZongScore.localPosition
	sumLosePos.y = roomData.clubId ~= '0' and -220 or -230
	playerObj.playerZongScore.localPosition = sumLosePos
	--疲劳值
	local fee = tonumber(data.fee)
	playerObj.playerFatigue:GetComponent("UILabel").text = roomData.clubId ~= '0' and (fee < 0 and fee or ('+'..fee)) or ''
	--7.风采照,签名
	if roomData.setting.size == 2 then
		winPlayer.erweima:GetComponent('UITexture').mainTexture=nil
		if data.bigWinner then
			coroutine.start(LoadPlayerIcon, winPlayer.erweima:GetComponent('UITexture'), data.imgUrl)	
			winPlayer.qianming:GetComponent("UILabel").text = data.signature
		end
		playerObj.playerScoreGroup:GetComponent("BoxCollider").enabled = false
		playerObj.playerScoreGroup.gameObject:SetActive(true)
		playerObj.playerQRCode.gameObject:SetActive(false)
	else
		local hasWiner = (data.bigWinner) and RoundAllData.mySeat == data.seat
		playerObj.playerQRCode.gameObject:SetActive(hasWiner)
		playerObj.playerScoreGroup.gameObject:SetActive(not(hasWiner))
		playerObj.playerScoreGroup:GetComponent("BoxCollider").enabled = hasWiner
		if hasWiner then
			playerObj.playerShowTex:GetComponent('UITexture').mainTexture=nil
			coroutine.start(LoadPlayerIcon, playerObj.playerShowTex:GetComponent('UITexture'), data.imgUrl)
			playerObj.playerSign:GetComponent("UILabel").text = data.signature
		end
	end
end

function this.OnClickButtonMoreInfo(go)
	if go.name == "moreInfo" then
		go.transform.parent.gameObject:SetActive(false)
		go.transform.parent.parent:Find("ScoreGroup").gameObject:SetActive(true)
	else
		go:SetActive(false)
		go.transform.parent:Find("QRCode").gameObject:SetActive(true)
	end
end

