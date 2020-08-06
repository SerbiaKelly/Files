local pdk_pb = require 'pdk_pb'

panelStageClearAll_pdk = {}
local this = panelStageClearAll_pdk;

local message;
local gameObject;

local LinkShare, JieTuShare, quit
local chengJiStr = ""
local showbg
local nextBtn
local DownButtons
function this.Awake(obj)
	gameObject = obj;
	showbg = gameObject.transform:Find('showbg');

	message = gameObject:GetComponent('LuaBehaviour');


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
        body.gameType = proxy_pb.PDK
        msg.body = body:SerializeToString()
        SendProxyMessage(msg, QuickMatch);
    end)
end

function this.Start()
end
function this.Update()
end
function this.OnEnable()
	nextBtn.gameObject:SetActive(roomData.clubId ~= '0')
    DownButtons:GetComponent('UIGrid'):Reposition()
    this.Refresh() 
end

--�����¼�--
function this.OnClickMask(go)
	AudioManager.Instance:PlayAudio('btn')
	NetWorkManager.Instance:DeleteConnect('game');
	PanelManager.Instance:HideAllWindow()
	
    if roomData.clubId ~= '0' then
        local data = {}
        data.name = gameObject.name
        data.clubId = roomData.clubId
        PanelManager.Instance:ShowWindow('panelClub', data)
    else
        PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
    end
end

function this.Refresh()

	gameObject.transform:Find('time'):GetComponent('UILabel').text = '时间：' .. os.date('%Y/%m/%d %H:%M')
    gameObject.transform:Find('room'):GetComponent('UILabel').text = '房间号：' .. roomInfo.roomNumber
	gameObject.transform:Find('wanfa'):GetComponent('UILabel').text = RoundAllData.playName
	chengJiStr = ""
	local winSeat = -1
	local maxSore = 0
	for i = 1, 3 do
		gameObject.transform:Find('player'..i..'/txk/trusteeship').gameObject:SetActive(false)
	end
	for i=1,#RoundAllData.data.players do
		if RoundAllData.data.players[i].score > maxSore then
			maxSore = RoundAllData.data.players[i].score
			winSeat = RoundAllData.data.players[i].seat
		end
	end
	for i = 1, #RoundAllData.data.players do
        print('RoundAllData.data.players[i].fee : '..tostring(RoundAllData.data.players[i].fee))
    end
	if #RoundAllData.data.players == 3 then
		showbg.gameObject:SetActive(false)
		gameObject.transform:Find('player3').localPosition = Vector3(475,1,0)
		for i=1,3 do
			local p = gameObject.transform:Find('player'..i);
			message:RemoveClick(p:Find('2weima'):Find('1').gameObject)
			message:RemoveClick(p:Find('bg').gameObject)
			if i <= #RoundAllData.data.players then
				p.gameObject:SetActive(true)
				local pData = RoundAllData.playerData[RoundAllData.data.players[i].seat];
				p:Find('playerName'):GetComponent('UILabel').text = pData.name
				p:Find('playerID'):GetComponent('UILabel').text = 'ID:' .. pData.id
				p:Find('info/playerBomb/num'):GetComponent('UILabel').text = RoundAllData.data.players[i].bombCount
				p:Find('info/playerWin/num'):GetComponent('UILabel').text = RoundAllData.data.players[i].winCount
				if RoundAllData.data.players[i].totalScore > 0 then
					p:Find('playerSocre/num'):GetComponent('UILabel').color = Color(214/225,18/255,0)
					p:Find('playerSocre/num'):GetComponent('UILabel').text = "+"..RoundAllData.data.players[i].totalScore
					--p:Find('playerSocre/num'):GetComponent('UILabel').effectColor = Color(1,1,1)
				else
					p:Find('playerSocre/num'):GetComponent('UILabel').color = Color(22/225,92/255,249/255)
					p:Find('playerSocre/num'):GetComponent('UILabel').text = RoundAllData.data.players[i].totalScore
					--p:Find('playerSocre/num'):GetComponent('UILabel').effectColor = Color(20/255,144/255,185/255)
				end
				print('RoundAllData.data.players[i].fee : '..tostring(RoundAllData.data.players[i].fee))
				if RoundAllData.data.players[i].fee ~= 0 then
					p:Find('playerSocre/fatigue'):GetComponent('UILabel').text = RoundAllData.data.players[i].fee

					p:Find('playerSocre/fatigue').gameObject:SetActive(tonumber(RoundAllData.data.players[i].fee)~=0)
					local sumPos = p:Find('playerSocre/num').localPosition
					sumPos.y = tonumber(RoundAllData.data.players[i].fee)~=0 and -52 or -65
					p:Find('playerSocre/num').localPosition = sumPos
				end
				
				p:Find('info/playerSocreMax/num'):GetComponent('UILabel').text = RoundAllData.data.players[i].maxRoundScore
				coroutine.start(LoadPlayerIcon, p:Find('Texture'):GetComponent('UITexture'), pData.icon)
				if winSeat == pData.seat then
					p:Find('winner').gameObject:SetActive(true)
				else
					p:Find('winner').gameObject:SetActive(false)
				end
				--托管标志
				gameObject.transform:Find('player'..i..'/txk/trusteeship').gameObject:SetActive(RoundAllData.isTrusteeships[RoundAllData.data.players[i].seat])

				if RoundAllData.data.players[i].score > 0 then
					print("RoundAllData.mySeat == pData.seat")
					print("RoundAllData.mySeat",RoundAllData.mySeat)
					print("pData.seat",pData.seat)
				end
				if RoundAllData.data.players[i].score > 0 and RoundAllData.mySeat == pData.seat then
					p:Find('info').gameObject:SetActive(false)
					p:Find('2weima').gameObject:SetActive(true)
					p:Find('2weima'):Find('qianming'):GetComponent('UILabel').text=RoundAllData.data.players[i].signature
					showbg:Find('2weima'):GetComponent('UITexture').mainTexture=nil
					coroutine.start(LoadFengCaiZhao, p:Find('2weima'):GetComponent('UITexture'), RoundAllData.data.players[i].imgUrl)

					message:AddClick(p:Find('2weima'):Find('1').gameObject, this.OnClickMoreData)
					message:AddClick(p:Find('bg').gameObject, this.OnClickPress)
				else
					p:Find('info').gameObject:SetActive(true)
					p:Find('2weima').gameObject:SetActive(false)
				end

				this.SetNiaoValue(p, pData, RoundAllData.data.players[i])

				p:Find('totalSocre/totalSocre_num'):GetComponent('UILabel').text = RoundAllData.data.players[i].score

				chengJiStr=chengJiStr..'【'..pData.name..'】 '..RoundAllData.data.players[i].score..';'
			else
				p.gameObject:SetActive(false)
			end
		end
	else
		showbg.gameObject:SetActive(true)
		local  winindex  = 1
		for i=1,3 do
			local p = gameObject.transform:Find('player'..i);
			message:RemoveClick(p:Find('2weima'):Find('1').gameObject)
			message:RemoveClick(p:Find('bg').gameObject)
			if i == 2 then
				--i = i+1
				p.gameObject:SetActive(false)
			else
				local  k = i
				if i == 3 then
					k = 2					
				end
				p.gameObject:SetActive(true)
				local pData = RoundAllData.playerData[RoundAllData.data.players[k].seat];
				p:Find('playerName'):GetComponent('UILabel').text = pData.name
				p:Find('playerID'):GetComponent('UILabel').text = 'ID:' .. pData.id
				p:Find('info/playerBomb/num'):GetComponent('UILabel').text = RoundAllData.data.players[k].bombCount
				p:Find('info/playerWin/num'):GetComponent('UILabel').text = RoundAllData.data.players[k].winCount
				--p:Find('playerSocre/num'):GetComponent('UILabel').text = RoundAllData.data.players[k].score
				--托管标志
				gameObject.transform:Find('player'..i..'/txk/trusteeship').gameObject:SetActive(RoundAllData.isTrusteeships[RoundAllData.data.players[k].seat])
				if RoundAllData.data.players[k].totalScore > 0 then
					p:Find('playerSocre/num'):GetComponent('UILabel').color = Color(214/225,18/255,0)
					p:Find('playerSocre/num'):GetComponent('UILabel').text = "+"..RoundAllData.data.players[k].totalScore
					--p:Find('playerSocre/num'):GetComponent('UILabel').effectColor = Color(1,1,1)
				else
					p:Find('playerSocre/num'):GetComponent('UILabel').color = Color(22/225,92/255,249/255)
					p:Find('playerSocre/num'):GetComponent('UILabel').text = RoundAllData.data.players[k].totalScore
					--p:Find('playerSocre/num'):GetComponent('UILabel').effectColor = Color(20/255,144/255,185/255)
				end

				print('RoundAllData.data.players[i].fee : '..tostring(RoundAllData.data.players[k].fee))
				if RoundAllData.data.players[k].fee ~= 0 then
					p:Find('playerSocre/fatigue'):GetComponent('UILabel').text = RoundAllData.data.players[k].fee

					p:Find('playerSocre/fatigue').gameObject:SetActive(tonumber(RoundAllData.data.players[k].fee)~=0)
					local sumPos = p:Find('playerSocre/num').localPosition
					sumPos.y = tonumber(RoundAllData.data.players[k].fee)~=0 and -52 or -65
					p:Find('playerSocre/num').localPosition = sumPos
				end

				p:Find('info/playerSocreMax/num'):GetComponent('UILabel').text = RoundAllData.data.players[k].maxRoundScore
				coroutine.start(LoadPlayerIcon, p:Find('Texture'):GetComponent('UITexture'), pData.icon)
				if winSeat == pData.seat then
					p:Find('winner').gameObject:SetActive(true)
					winindex = k
				else
					p:Find('winner').gameObject:SetActive(false)
				end

				this.SetNiaoValue(p, pData, RoundAllData.data.players[k])

				p:Find('totalSocre/totalSocre_num'):GetComponent('UILabel').text = RoundAllData.data.players[k].score

				p:Find('2weima').gameObject:SetActive(false)
				chengJiStr=chengJiStr..'【'..pData.name..'】 '..RoundAllData.data.players[k].score..';'
			end
		end
		if RoundAllData.data.players[1].score == RoundAllData.data.players[2].score then
			showbg.gameObject:SetActive(false)
			gameObject.transform:Find('player3').localPosition = Vector3(68,1,0)
		else
			gameObject.transform:Find('player3').localPosition = Vector3(475,1,0)
			showbg:Find('2weima'):Find('qianming'):GetComponent('UILabel').text=RoundAllData.data.players[winindex].signature
			showbg:Find('2weima'):GetComponent('UITexture').mainTexture=nil
			coroutine.start(LoadFengCaiZhao, showbg:Find('2weima'):GetComponent('UITexture'), RoundAllData.data.players[winindex].imgUrl)
		end
	end
end
function this.OnClickMoreData(go)
	print('查看更多!!!!!!!!!~.')
	go.transform.parent.parent:Find("info").gameObject:SetActive(true)
	go.transform.parent.gameObject:SetActive(false)
end
function this.OnClickPress(go)
	print('二维码!!!!!!!!!~.')
	go.transform.parent:Find("info").gameObject:SetActive(false)
	go.transform.parent:Find("2weima").gameObject:SetActive(true)
end
function this.OnClickJieTuShare(go)
	AudioManager.Instance:PlayAudio('btn')
    local data = {}
    data.showName = 'JieTuShare'
    PanelManager.Instance:ShowWindow('panelShared', data)
end
function this.OnClickShareLink(go)
    AudioManager.Instance:PlayAudio('btn')
    local title = '房号:【' .. roomInfo.roomNumber.."】成绩出炉啦！"
    local msg = chengJiStr..'时间：' .. os.date('%Y/%m/%d %H:%M，')
	msg = msg..'跑得快'
	print("RoundAllData.data.roomId",'http://'..panelLogin.HttpUrl..'/share/toResult/' .. RoundAllData.data.roomId)
	
	local data = {}
    data.showName = 'LinkShare'
    data.roomId = RoundAllData.data.roomId
    data.title = title
    data.msg = msg
    PanelManager.Instance:ShowWindow('panelShared', data)
end

function this.SetNiaoValue(obj, playerData, overData)
	print('data.hitBird:'..tostring(playerData.hitBird))
	print('overData.hitBirdScore:'..tostring(overData.hitBirdScore))
	if overData.hitBirdScore > 0 then
		--obj:Find('info/niaoSocre/num'):GetComponent('UILabel').color = Color(214/225,18/255,0)
		--obj:Find('info/niaoSocre/num'):GetComponent('UILabel').effectColor = Color(1,1,1)
		obj:Find('info/niaoSocre/num'):GetComponent('UILabel').text = overData.hitBirdScore == 0 and overData.hitBirdScore or "+"..overData.hitBirdScore
	else
		--obj:Find('info/niaoSocre/num'):GetComponent('UILabel').color = Color(22/225,92/255,249/255)
		--obj:Find('info/niaoSocre/num'):GetComponent('UILabel').effectColor = Color(20/255,144/255,185/255)
		obj:Find('info/niaoSocre/num'):GetComponent('UILabel').text = overData.hitBirdScore
	end

	--不打鸟也展示 默认值0
	obj:Find('info/niaoSocre').gameObject:SetActive(true)

	if roomData.setting.hitBird ~= 0  then
		obj:Find('Niao').gameObject:SetActive(playerData.hitBird ~= 0)
	else
		obj:Find('Niao').gameObject:SetActive(false)
	end
end