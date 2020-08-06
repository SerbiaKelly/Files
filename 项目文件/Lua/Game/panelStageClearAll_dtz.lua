local dtz_pb = require 'dtz_pb'

panelStageClearAll_dtz = {}
local this = panelStageClearAll_dtz

local message
local gameObject

local LinkShare, JieTuShare, quit

local roomID;
local time;
local wanfaName
local roundSize = 4;--2人/3人/4人

local playerSize4 = {};
local playerSize3and2 = {};
local midPanel;

local size4Obj;
local size3and2Obj;
local chengJiStr = ""
local nextBtn
local DownButtons
function this.Awake(obj)
	gameObject = obj

	roomID 			= gameObject.transform:Find('room');
	time 			= gameObject.transform:Find('time');
	wanfaName		= gameObject.transform:Find('wanfa');
	message 		= gameObject:GetComponent('LuaBehaviour');
	this.GetPlayerUI();
end

--获得UI对象
function this.GetPlayerUI()
	size4Obj		= gameObject.transform:Find("Size4");
	size3and2Obj	= gameObject.transform:Find("Size3and2");
	midPanel 		= gameObject.transform:Find("Size3and2/midPanel");
	--四人
	for i = 1, 4 do
		playerSize4[i] = {};
		playerSize4[i].transform 		= size4Obj:Find("Player"..i);
		playerSize4[i].ScoreGroup 		= playerSize4[i].transform:Find("ScoreGroup");
		playerSize4[i].QRCode 			= playerSize4[i].transform:Find("QRCode");
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
		playerSize4[i].Roomer 			= playerSize4[i].transform:Find("HeadImage/Roomer");
		playerSize4[i].selfTotal 		= playerSize4[i].transform:Find("selfTotal/selfTotalNum");
		playerSize4[i].totalXi 			= playerSize4[i].ScoreGroup:Find("totalXiNum");
		playerSize4[i].totalTong 		= playerSize4[i].ScoreGroup:Find("totalTongNum");
		playerSize4[i].totalDiZha 		= playerSize4[i].ScoreGroup:Find("totalDiZhaNum");
		playerSize4[i].totalPaiMian 	= playerSize4[i].ScoreGroup:Find("totalPaiMianum");
		if i == 1 or i == 3 then
			playerSize4[i].FinalScore 	= playerSize4[i].transform:Find("FinalScore");
		end
		message:AddClick(playerSize4[i].transform:Find("ScoreGroup/scoreMask").gameObject, this.OnClickButtonMoreInfo);
		message:AddClick(playerSize4[i].moreInfo.gameObject, this.OnClickButtonMoreInfo);
	end
--	三人和二人
	for i = 1, 3 do
		playerSize3and2[i] = {};
		playerSize3and2[i].transform 		= size3and2Obj:Find("Player"..i);
		playerSize3and2[i].ScoreGroup 		= playerSize3and2[i].transform:Find("ScoreGroup");
		playerSize3and2[i].QRCode 			= playerSize3and2[i].transform:Find("QRCode");
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
		playerSize3and2[i].Roomer 			= playerSize3and2[i].transform:Find("HeadImage/Roomer");
		playerSize3and2[i].selfTotal 		= playerSize3and2[i].transform:Find("selfTotal/selfTotalNum");
		playerSize3and2[i].totalXi 			= playerSize3and2[i].ScoreGroup:Find("totalXiNum");
		playerSize3and2[i].totalTong 		= playerSize3and2[i].ScoreGroup:Find("totalTongNum");
		playerSize3and2[i].totalDiZha 		= playerSize3and2[i].ScoreGroup:Find("totalDiZhaNum");
		playerSize3and2[i].totalPaiMian 	= playerSize3and2[i].ScoreGroup:Find("totalPaiMianum");
		playerSize3and2[i].FinalScore 		= playerSize3and2[i].transform:Find("ScoreGroup/totalFinalNum");
		message:AddClick(playerSize3and2[i].transform:Find("ScoreGroup/scoreMask").gameObject, this.OnClickButtonMoreInfo);
		message:AddClick(playerSize3and2[i].moreInfo.gameObject, this.OnClickButtonMoreInfo);
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
        body.ruleId = RoundAllData.roomData.setting.ruleId
        body.gameType = proxy_pb.DTZ
        msg.body = body:SerializeToString()
        SendProxyMessage(msg, QuickMatch);
    end)
end


function this.Start()
end

function this.OnEnable()
    nextBtn.gameObject:SetActive(RoundAllData.roomData.clubId ~= '0')
    DownButtons:GetComponent('UIGrid'):Reposition()
end

function this.WhoShow(data)
	print("WhoShow was called");
	roomID:GetComponent('UILabel').text = "房间号："..data.roomNumber;
	wanfaName:GetComponent('UILabel').text = RoundAllData.playName;
	time:GetComponent('UILabel').text = '时间：' .. os.date('%Y/%m/%d %H:%M');
	this.Refresh();
end

function this.Update()

end


function this.OnClickMask(go)
	AudioManager.Instance:PlayAudio('btn')
	PanelManager.Instance:HideWindow('panelInGame_dtz')
	PanelManager.Instance:HideWindow(gameObject.name)
	if RoundAllData.roomData.clubId ~= '0' then
        local data = {}
        data.name = gameObject.name
        data.clubId = RoundAllData.roomData.clubId
        PanelManager.Instance:ShowWindow('panelClub', data)
    else
        PanelManager.Instance:ShowWindow('panelLobby',gameObject.name)
    end
end

function this.SetPlayerInfo(playerObj,playerData,index)
	playerObj.transform.gameObject:SetActive(true);

	local pData = panelInGame_dtz.GetPlayerDataBySeat(playerData.seat);
	--1.姓名
	playerObj.Name:GetComponent("UILabel").text = pData.name;
	--2.id
	playerObj.ID:GetComponent("UILabel").text = "ID："..pData.id;
	--3.头像
	coroutine.start(LoadPlayerIcon, playerObj.HeadImage:GetComponent('UITexture'), pData.icon);
	--print("pData.icon:"..pData.icon);
	--5.大赢家
	if RoundAllData.roomData.setting.size == 4 then
		if index == 1 or index == 3 then
			playerObj.bigWinner.gameObject:SetActive(playerData.bigWinner);
		end
	else
		playerObj.bigWinner.gameObject:SetActive(playerData.bigWinner);
	end
	--房主
	print(" RoundAllData.roomData.ownerId-------------id:".. tostring(playerData.isOwner));

	--6.庄家
	playerObj.Roomer.gameObject:SetActive(playerData.isOwner);
	--7.风采照
	local hasWiner = (playerData.bigWinner) and RoundAllData.mySeat == playerData.seat;

	playerObj.QRCode.gameObject:SetActive(hasWiner);
	playerObj.ScoreGroup.gameObject:SetActive(not(hasWiner));
	playerObj.ScoreGroup:Find("scoreMask"):GetComponent("BoxCollider").enabled = hasWiner;
	print("player:"..tostring(playerObj.transform).." imgUrl:"..playerData.imgUrl);
	if hasWiner then
		playerObj.showTex:GetComponent('UITexture').mainTexture=nil
		coroutine.start(LoadFengCaiZhao, playerObj.showTex:GetComponent('UITexture'), playerData.imgUrl);
	end

	--8.签名
	playerObj.sign:GetComponent("UILabel").text = playerData.signature;
	--个人总分
	playerObj.selfTotal:GetComponent("UILabel").text = playerData.score;
	--总喜分
	playerObj.totalXi:GetComponent("UILabel").text  = playerData.happly;
	--筒子总分
	playerObj.totalTong:GetComponent("UILabel").text = playerData.tong;
	--地炸总分
	playerObj.totalDiZha:GetComponent("UILabel").text = playerData.deep;
	--牌面总分
	playerObj.totalPaiMian:GetComponent("UILabel").text = playerData.grab;
	chengJiStr=chengJiStr..'【'..pData.name..'】 '..playerData.score..';'
	--总成绩
	local needShow = false;
	if RoundAllData.roomData.setting.size == 4 then
		if index == 1 or index == 3 then
			needShow = true;
		end
	else
		needShow = true;
	end
	
	if needShow then
		playerObj.ScoreGet.gameObject:SetActive(playerData.totalScore >=0 );
		playerObj.ScoreLose.gameObject:SetActive(playerData.totalScore < 0 );
		playerObj.ScoreGet:GetComponent("UILabel").text = playerData.totalScore == 0 and playerData.totalScore or "+"..playerData.totalScore;
		playerObj.ScoreLose:GetComponent("UILabel").text = playerData.totalScore;
	end
	if playerData.fee ~= nil then
		playerObj.fatigue:GetComponent("UILabel").text = playerData.fee;

		playerObj.fatigue.gameObject:SetActive(tonumber(playerData.fee)~=0)
		local sumGetPos = playerObj.ScoreGet.localPosition
		sumGetPos.y = tonumber(playerData.fee)~=0 and -225 or -240
		playerObj.ScoreGet.localPosition = sumGetPos

		local sumLosePos = playerObj.ScoreLose.localPosition
		sumLosePos.y = tonumber(playerData.fee)~=0 and -225 or -240
		playerObj.ScoreLose.localPosition = sumLosePos
	end
	--终局奖励
    print("FinalScore use index---------------->"..index);
	if needShow and RoundAllData.roomData.setting.size == 4 then
		playerObj.FinalScore:GetComponent("UILabel").text = "（终局+"..playerData.bonusScore.."）";
	elseif needShow and (RoundAllData.roomData.setting.size == 3 or RoundAllData.roomData.setting.size == 2) then
		playerObj.FinalScore:GetComponent("UILabel").text = playerData.bonusScore;
	else
		if playerObj.FinalScore then
			playerObj.FinalScore:GetComponent("UILabel").text = "";
		end
	end

end

function this.Refresh()
	print("Refresh was called");
	chengJiStr = "";
	--先隐藏全部
	size4Obj.gameObject:SetActive(RoundAllData.roomData.setting.size == 4);
	size3and2Obj.gameObject:SetActive(RoundAllData.roomData.setting.size ~= 4);

	for i = 1, #RoundAllData.data.players do
        print('RoundAllData.data.players[i].fee : '..tostring(RoundAllData.data.players[i].fee))
    end
	--四人局
	if RoundAllData.roomData.setting.size == 4 then
		for i = 1, 4 do
			playerSize4[i].trusteeship.gameObject:SetActive(false)
		end
		for i = 1, 4 do
			local player = RoundAllData.data.players[i];
			this.SetPlayerInfo(playerSize4[i],player,i)
			--托管标志
			playerSize4[i].trusteeship.gameObject:SetActive(RoundAllData.isTrusteeships[player.seat])
			print(string.format("seat:%d,i:%d,group:%d,totalScore:%d,bonusScore:%d",player.seat,i,player.group,player.totalScore,player.bonusScore));
		end
	elseif RoundAllData.roomData.setting.size == 3 then
		for i = 1, 3 do
			playerSize3and2[i].transform.gameObject:SetActive(false);
			playerSize3and2[i].trusteeship.gameObject:SetActive(false)
		end
		midPanel.gameObject:SetActive(false);
		for i = 1, #RoundAllData.data.players do
			local player = RoundAllData.data.players[i];
			this.SetPlayerInfo(playerSize3and2[i],player,i);
			--托管标志
			playerSize3and2[i].trusteeship.gameObject:SetActive(RoundAllData.isTrusteeships[player.seat])
		end
	elseif RoundAllData.roomData.setting.size == 2 then
		for i = 1, 3 do
			playerSize3and2[i].transform.gameObject:SetActive(false);
			playerSize3and2[i].trusteeship.gameObject:SetActive(false)
		end
		local needShowMidPanel = false;
		needShowMidPanel = this.HasBigWin(RoundAllData.data.players);
		midPanel.gameObject:SetActive(needShowMidPanel);
		for i = 1, #RoundAllData.data.players do
			local player = RoundAllData.data.players[i];
			
			if needShowMidPanel then
				this.SetPlayerInfo(playerSize3and2[this.GetPlayerIndex(RoundAllData.roomData.setting.size,i)],player,i);
				playerSize3and2[this.GetPlayerIndex(RoundAllData.roomData.setting.size,i)].ScoreGroup.gameObject:SetActive(true);
				playerSize3and2[this.GetPlayerIndex(RoundAllData.roomData.setting.size,i)].QRCode.gameObject:SetActive(false);
				if player.bigWinner then
					midPanel:Find("QRCode/showTex"):GetComponent('UITexture').mainTexture=nil
					coroutine.start(LoadFengCaiZhao, midPanel:Find("QRCode/showTex"):GetComponent('UITexture'), player.imgUrl);
					midPanel:Find("QRCode/sign"):GetComponent("UILabel").text = player.signature;
				end
			else
				this.SetPlayerInfo(playerSize3and2[i],player,i);
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
	msg = msg..'打筒子'
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

