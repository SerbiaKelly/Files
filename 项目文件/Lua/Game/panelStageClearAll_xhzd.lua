local xhzd_pb = require 'xhzd_pb'

panelStageClearAll_xhzd = {}
local this = panelStageClearAll_xhzd

local message
local gameObject

local LinkShare, JieTuShare, quit

local roomID;
local time;
local wanfaName
local playersNum4 = {};
local playersNum2 = {}
local playersNum2WinSign
local playersNum2WinBG

local players2
local players4
local chengJiStr = ""
local nextBtn
local DownButtons
function this.Awake(obj)
	gameObject = obj
	roomID 			= gameObject.transform:Find('room');
	time 			= gameObject.transform:Find('time');
	wanfaName 		= gameObject.transform:Find('wanfa');
	message = gameObject:GetComponent('LuaBehaviour');
	players2 = gameObject.transform:Find("PlayersNum2");
	players4 = gameObject.transform:Find("PlayersNum4");
	this.GetPlayerUI();
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
        body.gameType = proxy_pb.XHZD
        msg.body = body:SerializeToString()
        SendProxyMessage(msg, QuickMatch);
    end)
end

--获得UI对象
function this.GetPlayerUI()
	playersNum2WinBG = gameObject.transform:Find("PlayersNum2/winPlayer/2weima");
	playersNum2WinSign = gameObject.transform:Find("PlayersNum2/winPlayer/qianming")
	for i = 1, 2 do
		playersNum2[i] = {};
		playersNum2[i].transform 			= gameObject.transform:Find("PlayersNum2/Player"..i);
		playersNum2[i].zongdefen 			= playersNum2[i].transform:Find("ScoreGroup/zongdefen/totalSocre_num");
		playersNum2[i].TotalScore 			= playersNum2[i].transform:Find("ScoreGroup/TotalScore");
		playersNum2[i].TotalXiScore 		= playersNum2[i].transform:Find("ScoreGroup/TotalXiScore");
		playersNum2[i].TotalXiScoreCount 	= playersNum2[i].transform:Find("ScoreGroup/TotalXiScoreCount");
		playersNum2[i].ShangyouCount 		= playersNum2[i].transform:Find("ScoreGroup/ShangyouCount");
		playersNum2[i].NiaoFen 				= playersNum2[i].transform:Find("ScoreGroup/niaofen");
		playersNum2[i].HeadImage 			= playersNum2[i].transform:Find("HeadImage/HeadIcon");
		playersNum2[i].trusteeship 			= playersNum2[i].transform:Find("HeadImage/trusteeship");
		playersNum2[i].Name 				= playersNum2[i].transform:Find("HeadImage/Name");
		playersNum2[i].ID 					= playersNum2[i].transform:Find("HeadImage/ID");
		playersNum2[i].Roomer 				= playersNum2[i].transform:Find("HeadImage/Roomer");
		playersNum2[i].ScoreGet 			= playersNum2[i].transform:Find("ScoreGet");
		playersNum2[i].ScoreLose 			= playersNum2[i].transform:Find("ScoreLose");
		playersNum2[i].bigWinner 			= playersNum2[i].transform:Find("bigWinner");
		playersNum2[i].niaoSign 			= playersNum2[i].transform:Find("Niao");
		playersNum2[i].fatigue 				= playersNum2[i].transform:Find("fatigue");
	end
	for i = 1, 4 do
		playersNum4[i] = {};
		playersNum4[i].transform 			= gameObject.transform:Find("PlayersNum4/Player"..i);
		playersNum4[i].ScoreGroup 			= playersNum4[i].transform:Find("ScoreGroup");
		playersNum4[i].QRCode 				= playersNum4[i].transform:Find("QRCode");
		playersNum4[i].TotalScore 			= playersNum4[i].transform:Find("ScoreGroup/TotalScore");
		playersNum4[i].TotalXiScore 		= playersNum4[i].transform:Find("ScoreGroup/TotalXiScore");
		playersNum4[i].TotalXiScoreCount 	= playersNum4[i].transform:Find("ScoreGroup/TotalXiScoreCount");
		playersNum4[i].TotalBaoCount 		= playersNum4[i].transform:Find("ScoreGroup/TotalBaoCount");
		playersNum4[i].ShangyouCount 		= playersNum4[i].transform:Find("ScoreGroup/ShangyouCount");
		playersNum4[i].showTex 				= playersNum4[i].transform:Find("QRCode/showTex");
		playersNum4[i].sign 				= playersNum4[i].transform:Find("QRCode/sign");
		playersNum4[i].moreInfo 			= playersNum4[i].transform:Find("QRCode/moreInfo");
		playersNum4[i].HeadImage 			= playersNum4[i].transform:Find("HeadImage/HeadIcon");
		playersNum4[i].trusteeship 			= playersNum4[i].transform:Find("HeadImage/trusteeship");
		playersNum4[i].Name 				= playersNum4[i].transform:Find("HeadImage/Name");
		playersNum4[i].ID 					= playersNum4[i].transform:Find("HeadImage/ID");
		playersNum4[i].Roomer 				= playersNum4[i].transform:Find("HeadImage/Roomer");
		playersNum4[i].ScoreGet 			= playersNum4[i].transform:Find("ScoreGet");
		playersNum4[i].ScoreLose 			= playersNum4[i].transform:Find("ScoreLose");
		playersNum4[i].bigWinner 			= playersNum4[i].transform:Find("bigWinner");
		playersNum4[i].fatigue 				= playersNum4[i].transform:Find("fatigue");
		message:AddClick(playersNum4[i].transform:Find("ScoreGroup/scoreMask").gameObject, this.OnClickButtonMoreInfo);
		message:AddClick(playersNum4[i].moreInfo.gameObject, this.OnClickButtonMoreInfo);
	end
end


function this.Start()
end

function this.OnEnable()
    nextBtn.gameObject:SetActive(roomData.clubId ~= '0')
    DownButtons:GetComponent('UIGrid'):Reposition()
end

function this.WhoShow(data)
	print("WhoShow was called。。。。。。。。。。。。。。。。。。。。。。。。。。。。");
	wanfaName:GetComponent('UILabel').text = data.playName;
	roomID:GetComponent('UILabel').text = "房间号："..roomInfo.roomNumber;
	time:GetComponent('UILabel').text = '时间：' .. os.date('%Y/%m/%d %H:%M');
	this.Refresh(data);
end

function this.Update()
end

function this.OnClickMask(go)
	AudioManager.Instance:PlayAudio('btn')
	PanelManager.Instance:HideWindow('panelInGame_xhzd')
	PanelManager.Instance:HideWindow('panelStageClearAll_xhzd')
	if roomData.clubId ~= '0' then
		local data = {}
		data.name = 'panelInGame_xhzd'
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

function this.Refresh(temp)
	print("Refresh was called。。。。。。。。。。。。。。。。。。。。。");
	chengJiStr = ''
	players2.gameObject:SetActive(roomData.setting.size == 2);
	players4.gameObject:SetActive(roomData.setting.size == 4);
	if roomData.setting.size == 2 then
		for i = 1, 2 do
			playersNum2[i].trusteeship.gameObject:SetActive(false)
		end
		for i = 1, 2 do
			this.SetPlayerInfo(playersNum2[i],temp.data.players[i]);
			--托管标志
			print(i..' temp.isTrusteeships[temp.data.players[i].seat] : '..tostring(temp.isTrusteeships[temp.data.players[i].seat])..' temp.data.players[i].seat : '..temp.data.players[i].seat)
			playersNum2[i].trusteeship.gameObject:SetActive(temp.isTrusteeships[temp.data.players[i].seat])
		end
	else
		for i = 1, 4 do
			playersNum4[i].trusteeship.gameObject:SetActive(false)
		end
		for i = 1, 4 do
			this.SetPlayerInfo(playersNum4[i],temp.data.players[i]);
			--托管标志
			print(i..' temp.isTrusteeships[temp.data.players[i].seat] : '..tostring(temp.isTrusteeships[temp.data.players[i].seat])..' temp.data.players[i].seat : '..temp.data.players[i].seat)
            playersNum4[i].trusteeship.gameObject:SetActive(temp.isTrusteeships[temp.data.players[i].seat])
		end
	end
end

function this.SetPlayerInfo(playerObj,playerData)
	local pData = panelInGame_xhzd.GetPlayerDataBySeat(playerData.seat);
	playerObj.transform.gameObject:SetActive(true);
	--1.姓名
	playerObj.Name:GetComponent("UILabel").text = pData.name;
	--2.id
	playerObj.ID:GetComponent("UILabel").text = pData.id;
	--3.头像
	coroutine.start(LoadPlayerIcon, playerObj.HeadImage:GetComponent('UITexture'), pData.icon);
	--5.大赢家
	playerObj.bigWinner.gameObject:SetActive(playerData.bigWinner);
	playerObj.Roomer.gameObject:SetActive(false);
	--7.风采照,签名
	if roomData.setting.size == 2 then
		playersNum2WinBG:GetComponent('UITexture').mainTexture=nil
		coroutine.start(LoadPlayerIcon, playersNum2WinBG:GetComponent('UITexture'), playerData.imgUrl);
		playersNum2WinSign:GetComponent("UILabel").text = playerData.signature;
		--总得分
		playerObj.zongdefen:GetComponent("UILabel").text 	= playerData.totalScore+playerData.happyScore;
		--鸟分
		if playerData.niaoScore>0 then
			playerObj.NiaoFen:GetComponent("UILabel").text 	= "鸟分：+"..playerData.niaoScore;
		else
			playerObj.NiaoFen:GetComponent("UILabel").text 	= "鸟分："..playerData.niaoScore;
		end
		
		playerObj.niaoSign.gameObject:SetActive(playerData.isNiao);
	else
		local hasWiner = (playerData.bigWinner) and RoundAllData.mySeat == playerData.seat;
		playerObj.QRCode.gameObject:SetActive(hasWiner);
		playerObj.ScoreGroup.gameObject:SetActive(not(hasWiner));
		playerObj.ScoreGroup:Find("scoreMask"):GetComponent("BoxCollider").enabled = hasWiner;

		if hasWiner then
			playerObj.showTex:GetComponent('UITexture').mainTexture=nil
			coroutine.start(LoadPlayerIcon, playerObj.showTex:GetComponent('UITexture'), playerData.imgUrl);
		end
		playerObj.sign:GetComponent("UILabel").text = playerData.signature;
		--12.包庄次数
		playerObj.TotalBaoCount:GetComponent("UILabel").text 	= "包庄次数："..playerData.wrapCount;
	end
	--9.总计分
	playerObj.TotalScore:GetComponent("UILabel").text 		= "总得计分："..playerData.totalScore;
	--10.喜总得分
	playerObj.TotalXiScore:GetComponent("UILabel").text 	= "总得喜分："..playerData.happyScore;
	--11.喜总次数
	playerObj.TotalXiScoreCount:GetComponent("UILabel").text = "喜总次数："..playerData.happyCount;
	
	--13.上有次数
	playerObj.ShangyouCount:GetComponent("UILabel").text 	= "上游次数："..playerData.firstCount;

	chengJiStr=chengJiStr..'【'..pData.name..'】 '..playerData.score..';'

	playerObj.ScoreGet.gameObject:SetActive(playerData.score >= 0);
	playerObj.ScoreLose.gameObject:SetActive(playerData.score < 0);
	if playerData.score >= 0 then
		if playerData.score > 0 then
			playerObj.ScoreGet:GetComponent("UILabel").text = "+"..playerData.score;
		else
			playerObj.ScoreGet:GetComponent("UILabel").text = playerData.score;
		end
	end
	playerObj.ScoreLose:GetComponent("UILabel").text = playerData.score;
	print('playerData.fee : '..tostring(playerData.fee))
	if playerData.fee ~= nil then
		playerObj.fatigue:GetComponent("UILabel").text = playerData.fee;

		playerObj.fatigue.gameObject:SetActive(tonumber(playerData.fee)~=0)
		local sumGetPos = playerObj.ScoreGet.localPosition
		sumGetPos.y = tonumber(playerData.fee)~=0 and -220 or -230
		playerObj.ScoreGet.localPosition = sumGetPos

		local sumLosePos = playerObj.ScoreLose.localPosition
		sumLosePos.y = tonumber(playerData.fee)~=0 and -220 or -230
		playerObj.ScoreLose.localPosition = sumLosePos
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
	msg = msg..'新化炸弹'
	print("RoundAllData.data.roomId",'http://'..panelLogin.HttpUrl..'/share/toResult/' .. RoundAllData.data.roomId)
	
	local data = {}
    data.showName = 'LinkShare'
    data.roomId = RoundAllData.data.roomId
    data.title = title
    data.msg = msg
    PanelManager.Instance:ShowWindow('panelShared', data)
end

function this.OnClickButtonMoreInfo(go)
	if go.name == "moreInfo" then
		go.transform.parent.gameObject:SetActive(false);
		go.transform.parent.parent:Find("ScoreGroup").gameObject:SetActive(true);
	else
		go.transform.parent.gameObject:SetActive(false);
		go.transform.parent.parent:Find("QRCode").gameObject:SetActive(true);
	end

end

