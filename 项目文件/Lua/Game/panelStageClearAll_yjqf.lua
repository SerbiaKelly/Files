local yjqf_pb = require 'yjqf_pb'

panelStageClearAll_yjqf = {}
local this = panelStageClearAll_yjqf

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
        body.gameType = proxy_pb.YJQF
        msg.body = body:SerializeToString()
        SendProxyMessage(msg, QuickMatch)
	end)
	
	local play = gameObject.transform:Find('players')
	for i = 0,play.childCount - 1 do
		local playerUI = {}
		playerUI.obj  = play:Find(i)
		playerUI.playerRoomer = playerUI.obj:Find('HeadImage/Roomer')
		playerUI.playerIcon = playerUI.obj:Find('HeadImage/HeadIcon')
		playerUI.playerName = playerUI.obj:Find('HeadImage/name')
		playerUI.playerID = playerUI.obj:Find('HeadImage/ID')
		playerUI.trusteeship = playerUI.obj:Find('HeadImage/trusteeship')
		playerUI.playerBigWinner = playerUI.obj:Find('HeadImage/bigWinner')
		playerUI.playerZongDeFen = playerUI.obj:Find('zongdefen/totalSocre_num')
		playerUI.playerScoreGroup = playerUI.obj:Find('ScoreGroup')
		message:AddClick(playerUI.playerScoreGroup.gameObject, this.OnClickButtonMoreInfo)
		playerUI.playerShangYouNum = playerUI.playerScoreGroup:Find('shangYouNum')
		playerUI.playerXiCount = playerUI.playerScoreGroup:Find('xiCount')
		playerUI.playerXiScore = playerUI.playerScoreGroup:Find('xiScore')
		playerUI.playerCardScore = playerUI.playerScoreGroup:Find('cardScore')
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
	PanelManager.Instance:HideWindow('panelInGame_yjqf')
	PanelManager.Instance:HideWindow('panelStageClearAll_yjqf')
	if roomData.clubId ~= '0' then
		local data = {}
		data.name = 'panelInGame_yjqf'
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
end

function this.SetPlayerInfo(playerObj,data)
	playerObj.obj.gameObject:SetActive(true)
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
	playerObj.playerShangYouNum:GetComponent("UILabel").text = "上游次数："..data.firstCount
	--喜总次数
	playerObj.playerXiCount:GetComponent("UILabel").text = "喜总次数："..data.happlyCount
	--喜总得分
	playerObj.playerXiScore:GetComponent("UILabel").text = "喜总得分："..data.happlyScore
	--牌面总分
	playerObj.playerCardScore:GetComponent("UILabel").text = "牌面总分："..data.cardsScore
	--结算奖励：
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

