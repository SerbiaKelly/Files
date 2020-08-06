local dzm_pb = require 'dzm_pb'

panelStageClearAll_dzahm = {}
local this = panelStageClearAll_dzahm

local message
local gameObject

local LinkShare, JieTuShare, quit,matchNext;

local roomID;
local time;
local wanfaName
local roundSize = 4;--2人/3人/4人

local playerSize4 = {};
local playerSize3and2 = {};
local midPanel;

local size4Obj;
local size3and2Obj;
local RoundAllData;
local roomInfo;
local cardText;

local chengJiStr = ""
function this.Awake(obj)
	gameObject = obj

	roomID 			= gameObject.transform:Find('room');
	time 			= gameObject.transform:Find('time');
	wanfaName		= gameObject.transform:Find('wanfa');

	message = gameObject:GetComponent('LuaBehaviour');

    DownButtons = gameObject.transform:Find("DownButtons")
    LinkShare 	= DownButtons:Find('LinkShare')         --按钮
    JieTuShare 	= DownButtons:Find('JieTuShare')
    quit 		= DownButtons:Find('quit')
    matchNext 	= DownButtons:Find('next')
    message:AddClick(LinkShare.gameObject, 	this.OnClickShareLink)
    message:AddClick(JieTuShare.gameObject, this.OnClickJieTuShare)
    message:AddClick(quit.gameObject, 		this.OnClickMask)
    message:AddClick(matchNext.gameObject, 	this.OnClickMatchNext)
	this.GetPlayerUI();
end

--获得UI对象
function this.GetPlayerUI()
	size4Obj		= gameObject.transform:Find("Size4");
	size3and2Obj	= gameObject.transform:Find("Size3and2");
	midPanel 		= gameObject.transform:Find("Size3and2/midPanel");
--	四人

	for i = 1, 4 do
		playerSize4[i] = {};
		playerSize4[i].transform 		= size4Obj:Find("Player"..i);
		playerSize4[i].ScoreGroup 		= playerSize4[i].transform:Find("ScoreGroup");
		playerSize4[i].totalSocre 		= playerSize4[i].transform:Find("totalSocre/totalSocre_num");
		playerSize4[i].QRCode 			= playerSize4[i].transform:Find("QRCode");
		playerSize4[i].ZimoCount 		= playerSize4[i].transform:Find("ScoreGroup/grid/ZimoCount");
		playerSize4[i].JiepaoCount 		= playerSize4[i].transform:Find("ScoreGroup/grid/JiepaoCount");
		playerSize4[i].DianpaoCount 	= playerSize4[i].transform:Find("ScoreGroup/grid/DianpaoCount");
		playerSize4[i].BirdCount 		= playerSize4[i].transform:Find("ScoreGroup/grid/BirdCount");
		playerSize4[i].showTex 			= playerSize4[i].transform:Find("QRCode/showTex");
		playerSize4[i].sign 			= playerSize4[i].transform:Find("QRCode/sign");
		playerSize4[i].moreInfo 		= playerSize4[i].transform:Find("QRCode/moreInfo");
		playerSize4[i].HeadImage 		= playerSize4[i].transform:Find("HeadImage/HeadIcon");
		playerSize4[i].trusteeship 		= playerSize4[i].transform:Find("HeadImage/trusteeship");
		playerSize4[i].Name 			= playerSize4[i].transform:Find("HeadImage/Name");
		playerSize4[i].ID 				= playerSize4[i].transform:Find("HeadImage/ID");
		playerSize4[i].ScoreGet 		= playerSize4[i].transform:Find("ScoreGet");
		playerSize4[i].ScoreLose 		= playerSize4[i].transform:Find("ScoreLose");
		playerSize4[i].fatigue 			= playerSize4[i].transform:Find("fatigue");
		playerSize4[i].bigWinner 		= playerSize4[i].transform:Find("bigWinner");
		playerSize4[i].winner 			= playerSize4[i].transform:Find("winner");
		playerSize4[i].Roomer 			= playerSize4[i].transform:Find("HeadImage/Roomer");
		message:AddClick(playerSize4[i].transform:Find("ScoreGroup/scoreMask").gameObject, this.OnClickButtonMoreInfo);
		message:AddClick(playerSize4[i].moreInfo.gameObject, this.OnClickButtonMoreInfo);
	end
--	三人和二人
	for i = 1, 3 do
		playerSize3and2[i] = {};
		playerSize3and2[i].transform 		= size3and2Obj:Find("Player"..i);
		playerSize3and2[i].ScoreGroup 		= playerSize3and2[i].transform:Find("ScoreGroup");
		playerSize3and2[i].totalSocre 		= playerSize3and2[i].transform:Find("totalSocre/totalSocre_num");
		playerSize3and2[i].QRCode 			= playerSize3and2[i].transform:Find("QRCode");
		playerSize3and2[i].ZimoCount 		= playerSize3and2[i].transform:Find("ScoreGroup/grid/ZimoCount");
		playerSize3and2[i].JiepaoCount 		= playerSize3and2[i].transform:Find("ScoreGroup/grid/JiepaoCount");
		playerSize3and2[i].DianpaoCount 	= playerSize3and2[i].transform:Find("ScoreGroup/grid/DianpaoCount");
		playerSize3and2[i].BirdCount 		= playerSize3and2[i].transform:Find("ScoreGroup/grid/BirdCount");
		playerSize3and2[i].showTex 			= playerSize3and2[i].transform:Find("QRCode/showTex");
		playerSize3and2[i].sign 			= playerSize3and2[i].transform:Find("QRCode/sign");
		playerSize3and2[i].moreInfo 		= playerSize3and2[i].transform:Find("QRCode/moreInfo");
		playerSize3and2[i].HeadImage 		= playerSize3and2[i].transform:Find("HeadImage/HeadIcon");
		playerSize3and2[i].trusteeship 		= playerSize3and2[i].transform:Find("HeadImage/trusteeship");
		playerSize3and2[i].Name 			= playerSize3and2[i].transform:Find("HeadImage/Name");
		playerSize3and2[i].ID 				= playerSize3and2[i].transform:Find("HeadImage/ID");
		playerSize3and2[i].ScoreGet 		= playerSize3and2[i].transform:Find("ScoreGet");
		playerSize3and2[i].ScoreLose 		= playerSize3and2[i].transform:Find("ScoreLose");
		playerSize3and2[i].fatigue 			= playerSize3and2[i].transform:Find("fatigue");
		playerSize3and2[i].bigWinner 		= playerSize3and2[i].transform:Find("bigWinner");
		playerSize3and2[i].winner 			= playerSize3and2[i].transform:Find("winner");
		playerSize3and2[i].Roomer 			= playerSize3and2[i].transform:Find("HeadImage/Roomer");
		message:AddClick(playerSize3and2[i].transform:Find("ScoreGroup/scoreMask").gameObject, this.OnClickButtonMoreInfo);
		message:AddClick(playerSize3and2[i].moreInfo.gameObject, this.OnClickButtonMoreInfo);
	end
end


function this.Start()
end

function this.OnEnable()

end

function this.WhoShow(data)
	cardText = UnityEngine.PlayerPrefs.GetInt('cardText_mj', 1);
	RoundAllData = data.RoundAllData;
	roomInfo = data.roomInfo;
	print("WhoShow was called");
	matchNext.gameObject:SetActive(RoundAllData.roomData.clubId ~= "0");
	DownButtons:GetComponent("UIGrid"):Reposition();
	roomID:GetComponent('UILabel').text = "房间号："..roomInfo.roomNumber;
	time:GetComponent('UILabel').text = '时间：' .. os.date('%Y/%m/%d %H:%M');
	wanfaName:GetComponent('UILabel').text = RoundAllData.playName;
	this.Refresh();
end

function this.Update()

end

function this.OnClickMask(go)
	AudioManager.Instance:PlayAudio('btn')
	PanelManager.Instance:HideWindow('panelInGame_dzahm');
	if RoundAllData.roomData.clubId ~= '0' then
		
        local data = {}
        data.name = gameObject.name
        data.clubId = RoundAllData.roomData.clubId
        PanelManager.Instance:ShowWindow('panelClub', data)
    else
        PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
    end
end

function this.OnClickMatchNext(go)
	AudioManager.Instance:PlayAudio('btn')
	if panelInGame.HideCoroutine then 
		StopCoroutine(panelInGame.HideCoroutine);
	end
    local msg 		= Message.New()
    msg.type 		= proxy_pb.QUICK_MATCH;
    local body 		= proxy_pb.PQuickMatch();
    body.ruleId 	= RoundAllData.roomData.setting.ruleId;
    body.gameType 	= proxy_pb.DZM;
    msg.body = body:SerializeToString()
    SendProxyMessage(msg, QuickMatch);
end

function this.Refresh()
	print("Refresh was called");
	chengJiStr = ""
	----先隐藏全部
	for i = 1, #RoundAllData.data.players do
        print('RoundAllData.data.players[i].fee : '..tostring(RoundAllData.data.players[i].fee))
    end
	size4Obj.gameObject:SetActive(RoundAllData.roomData.setting.size == 4);
	size3and2Obj.gameObject:SetActive(RoundAllData.roomData.setting.size ~= 4);

	--四人局
	if RoundAllData.roomData.setting.size == 4 then
		for i = 1, 4 do
			playerSize4[i].trusteeship.gameObject:SetActive(false)
		end
		for i = 1, 4 do
			local player = RoundAllData.data.players[i];
			this.SetPlayerInfo(playerSize4[i],player);
			--托管标志
            playerSize4[this.GetPlayerIndex(RoundAllData.roomData.setting.size,i)].trusteeship.gameObject:SetActive(RoundAllData.isTrusteeships[player.seat])
		end
	elseif RoundAllData.roomData.setting.size == 3 then
		for i = 1, 3 do
			playerSize3and2[i].transform.gameObject:SetActive(false);
			playerSize3and2[i].trusteeship.gameObject:SetActive(false)
		end
		midPanel.gameObject:SetActive(false);

		for i = 1, #RoundAllData.data.players do
			local player = RoundAllData.data.players[i];
			this.SetPlayerInfo(playerSize3and2[i],player);
			--托管标志
            playerSize3and2[this.GetPlayerIndex(RoundAllData.roomData.setting.size,i)].trusteeship.gameObject:SetActive(RoundAllData.isTrusteeships[player.seat])
		end

	elseif RoundAllData.roomData.setting.size == 2 then
		for i = 1, 3 do
			playerSize3and2[i].transform.gameObject:SetActive(false);
			playerSize3and2[i].trusteeship.gameObject:SetActive(false)
		end
		local needShowMidPanel = false;
		needShowMidPanel = this.HasWin(RoundAllData.data.players) or this.HasBigWin(RoundAllData.data.players);
		midPanel.gameObject:SetActive(needShowMidPanel);
		for i = 1, #RoundAllData.data.players do
			local player = RoundAllData.data.players[i];
			
			if needShowMidPanel then
				this.SetPlayerInfo(playerSize3and2[this.GetPlayerIndex(RoundAllData.roomData.setting.size,i)],player);
				playerSize3and2[this.GetPlayerIndex(RoundAllData.roomData.setting.size,i)].ScoreGroup.gameObject:SetActive(true);
				playerSize3and2[this.GetPlayerIndex(RoundAllData.roomData.setting.size,i)].QRCode.gameObject:SetActive(false);
				if player.winner or player.bigWinner then
					midPanel:Find("QRCode/showTex"):GetComponent('UITexture').mainTexture=nil
					coroutine.start(LoadFengCaiZhao, midPanel:Find("QRCode/showTex"):GetComponent('UITexture'), player.imgUrl);
					midPanel:Find("QRCode/sign"):GetComponent("UILabel").text = player.signature;
				end
			else
				this.SetPlayerInfo(playerSize3and2[i],player);
			end

			--托管标志
			local  k = i
            if needShowMidPanel then
                if RoundAllData.roomData.setting.size == 2 then
                    if i == 2 then
                        k = 3					
                    end
                end
            end
			print(i..' RoundAllData.isTrusteeships[player.seat] : '..tostring(RoundAllData.isTrusteeships[player.seat])..' player.seat :  '..player.seat)
			playerSize3and2[k].trusteeship.gameObject:SetActive(RoundAllData.isTrusteeships[player.seat])
		end
	end
end

function this.SetPlayerInfo(playerObj,playerData)
	playerObj.transform.gameObject:SetActive(true);
	local pData = RoundAllData.playerData[playerData.seat];
	--1.姓名
	playerObj.Name:GetComponent("UILabel").text = pData.name;
	--2.id
	playerObj.ID:GetComponent("UILabel").text = pData.id;
	--3.头像
	coroutine.start(LoadPlayerIcon, playerObj.HeadImage:GetComponent('UITexture'), pData.icon);
	--4.赢家
	playerObj.winner.gameObject:SetActive(playerData.winner);
	--5.大赢家
	playerObj.bigWinner.gameObject:SetActive(playerData.bigWinner);
	--6.庄家
	--playerObj.Roomer.gameObject:SetActive(playerData.seat == RoundAllData.roomData.bankerSeat);
	playerObj.Roomer.gameObject:SetActive(false);
	--7.风采照
	local hasWiner = (playerData.winner or playerData.bigWinner) and RoundAllData.mySeat == playerData.seat;
	playerObj.QRCode.gameObject:SetActive(hasWiner);
	playerObj.ScoreGroup.gameObject:SetActive(not(hasWiner));
	playerObj.ScoreGroup:Find("scoreMask"):GetComponent("BoxCollider").enabled = hasWiner;
	print("player:"..tostring(playerObj.transform).." imgUrl:"..playerData.imgUrl);
	if hasWiner then
		playerObj.showTex:GetComponent('UITexture').mainTexture=nil
		coroutine.start(LoadFengCaiZhao, playerObj.showTex:GetComponent('UITexture'), playerData.imgUrl);
	end
	--总得分
	playerObj.totalSocre:GetComponent("UILabel").text = playerData.win
	--8.签名
	playerObj.sign:GetComponent("UILabel").text = playerData.signature;
	--9.自摸次数
	playerObj.ZimoCount:GetComponent("UILabel").text 		= "自摸次数："..playerData.mo;
	--10.接炮次数
	playerObj.JiepaoCount:GetComponent("UILabel").text 		= "接炮次数："..playerData.jie;
	--11.点炮次数
	playerObj.DianpaoCount:GetComponent("UILabel").text 	= "点炮次数："..playerData.dian;
	--12.中鸟个数
	playerObj.BirdCount:GetComponent("UILabel").text 	= "中鸟个数："..playerData.bird;
	--14.积分
	playerObj.ScoreGet.gameObject:SetActive(playerData.score >= 0);
	playerObj.ScoreLose.gameObject:SetActive(playerData.score < 0);
	if playerData.score >= 0 then
		if playerData.score > 0 then
			playerObj.ScoreGet:GetComponent("UILabel").text = "+"..playerData.score;
		else
			playerObj.ScoreGet:GetComponent("UILabel").text = playerData.score;
		end
	end
	chengJiStr=chengJiStr..'【'..pData.name..'】 '..playerData.win..';'
	playerObj.ScoreLose:GetComponent("UILabel").text = playerData.score;
	if playerData.fee ~= nil then
		playerObj.fatigue:GetComponent("UILabel").text = playerData.fee;
		playerObj.fatigue.gameObject:SetActive(tonumber(playerData.fee)~=0)
		local sumGetPos = playerObj.ScoreGet.localPosition
		sumGetPos.y = tonumber(playerData.fee)~=0 and -205 or -220
		playerObj.ScoreGet.localPosition = sumGetPos
		local sumLosePos = playerObj.ScoreLose.localPosition
		sumLosePos.y = tonumber(playerData.fee)~=0 and -205 or -220
		playerObj.ScoreLose.localPosition = sumLosePos
	end
end

--是否有赢家
function this.HasWin(players)
	for i = 1, #players do
		if players[i].winner then
			return true;
		end
	end

	return false;
end

--是否有大赢家
function this.HasBigWin(players)
	for i = 1, #players do
		if players[i].bigWinner then
			return true;
		end
	end
	return false;
end

function this.GetPlayerIndex(size,index)
	if size == 4 or size == 3 then
		return index;
	elseif size == 2 then
		if index == 2 then
			return 3;
		else
			return index;
		end
	end
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
	msg = msg..'郑州麻将'
	print("RoundAllData.data.roomId",'http://'..panelLogin.HttpUrl..'/share/toResult/' .. RoundAllData.data.roomId)
	
	local data = {}
    data.showName = 'LinkShare'
    data.roomId = RoundAllData.data.roomId
    data.title = title
    data.msg = msg
    PanelManager.Instance:ShowWindow('panelShared', data)
end

function this.OnClickButtonMoreInfo(go)
	--print("OnClickButtonMoreInfo was called:"..tostring(go));
	if go.name == "moreInfo" then
		go.transform.parent.gameObject:SetActive(false);
		go.transform.parent.parent:Find("ScoreGroup").gameObject:SetActive(true);
	else
		go.transform.parent.gameObject:SetActive(false);
		go.transform.parent.parent:Find("QRCode").gameObject:SetActive(true);

	end

end

