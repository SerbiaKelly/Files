local json = require 'json'
panelLookTable = {}
local this = panelLookTable;

local message;
local gameObject;

local mask
local closeButton
local destroyButton
local joinButton
local players={}
local maxPlayerNum=4

function this.Awake(obj)
	gameObject = obj;
	this.gameObject = obj
	message = gameObject:GetComponent('LuaBehaviour');
	
	mask=gameObject.transform:Find('BaseContent/mask');
	closeButton=gameObject.transform:Find('BaseContent/ButtonClose');
	destroyButton=gameObject.transform:Find('Buttons/ButtonDestroy');
	joinButton=gameObject.transform:Find('Buttons/ButtonJoin');
	for i=1,maxPlayerNum do
		players[i]={};
		players[i].transform=gameObject.transform:Find('player'..i);
		players[i].head=players[i].transform:Find('head');
		players[i].name=players[i].transform:Find('name');
		players[i].ID=players[i].transform:Find('ID');
		players[i].null=players[i].transform:Find('null');
		SetUserData(players[i].null.gameObject, i)
		message:AddClick(players[i].null.gameObject, this.OnClickSeat);
	end

    message:AddClick(closeButton.gameObject, this.OnClickClose);
    --message:AddClick(mask.gameObject, this.OnClickClose);
    message:AddClick(destroyButton.gameObject, this.OnClickDestroy);
    message:AddClick(joinButton.gameObject, this.OnClickJoin);
end
local deskInfo={}
function this.WhoShow(data)
	deskInfo = {}
	deskInfo=data
	for i=1,#players do
		if i<=data.size then
			players[i].head.gameObject:SetActive(false)
			players[i].head:GetComponent('UITexture').mainTexture=nil
			players[i].null.gameObject:SetActive(true)
			players[i].name:GetComponent('UILabel').text=''
			players[i].ID:GetComponent('UILabel').text=''
			players[i].transform.gameObject:SetActive(true)
		else
			players[i].transform.gameObject:SetActive(false)
		end
	end
	for i=1,#deskInfo.desk.players do
		if deskInfo.desk.players[i] then
			local seat=deskInfo.desk.players[i].seat
			players[seat+1].head.gameObject:SetActive(true)
			players[seat+1].null.gameObject:SetActive(false)
			coroutine.start(LoadPlayerIcon, players[seat+1].head:GetComponent('UITexture'), deskInfo.desk.players[i].icon)
			players[seat+1].name:GetComponent('UILabel').text=deskInfo.desk.players[i].nickname
			local userid = deskInfo.desk.players[i].userId
			if not IsCanOperatingMenber() then
				userid = string.sub (userid, 1,4).."***"
			end
			players[seat+1].ID:GetComponent('UILabel').text= 'ID:' ..userid
		end
	end

	joinButton.gameObject:SetActive(#deskInfo.desk.players ~= deskInfo.size)
	destroyButton.gameObject:SetActive(IsCanDestoryRoom())
	gameObject.transform:Find('Buttons'):GetComponent('UIGrid'):Reposition()

	local gameType = panelClub.GetGameTyeByPlay(deskInfo.desk.playId).gameType
	local roomType = panelClub.GetGameTyeByPlay(deskInfo.desk.playId).roomType
	print('gameType',gameType)
	gameObject.transform:Find('Rule/roomid'):GetComponent('UILabel').text='房间号：'..deskInfo.desk.roomNumber
	if gameType == proxy_pb.PDK then
		gameObject.transform:Find('Rule/text'):GetComponent('UILabel').text='当前玩法：'..deskInfo.playName..','..getWanFaText_pdk(deskInfo.rule,true,false,false, true)
	elseif gameType == proxy_pb.PHZ  then
		gameObject.transform:Find('Rule/text'):GetComponent('UILabel').text='当前玩法：'..deskInfo.playName..','..getWanFaText(deskInfo.rule, true, false, false, true,true)
	elseif gameType == proxy_pb.MJ  then
		gameObject.transform:Find('Rule/text'):GetComponent('UILabel').text='当前玩法：'..deskInfo.playName..','..GetMJRuleText(deskInfo.rule,false,false,false, true)
    elseif gameType == proxy_pb.XHZD then 
		gameObject.transform:Find('Rule/text'):GetComponent('UILabel').text='当前玩法：'..deskInfo.playName..','..getXHZDRuleString(deskInfo.rule,false,true,false)
	elseif gameType == proxy_pb.DTZ then
		gameObject.transform:Find('Rule/text'):GetComponent('UILabel').text='当前玩法：'..deskInfo.playName..','..GetDTZRuleString(deskInfo.rule,false,false,false, true)
	elseif gameType == proxy_pb.BBTZ then
		gameObject.transform:Find('Rule/text'):GetComponent('UILabel').text='当前玩法：'..deskInfo.playName..','..GetBBTZRuleString(deskInfo.rule,false,false,false, true)
	elseif gameType == proxy_pb.XPLP then
		gameObject.transform:Find('Rule/text'):GetComponent('UILabel').text='当前玩法：'..deskInfo.playName..','..GetXPLPRuleText(deskInfo.rule,false,false,false, true)
	elseif gameType == proxy_pb.HNM and roomType == proxy_pb.HNHSM then
		gameObject.transform:Find('Rule/text'):GetComponent('UILabel').text='当前玩法：'..deskInfo.playName..','..GetHNHSMRuleText(deskInfo.rule,false,false,false, true)
	elseif gameType == proxy_pb.HNM and roomType == proxy_pb.HNZZM then
		gameObject.transform:Find('Rule/text'):GetComponent('UILabel').text='当前玩法：'..deskInfo.playName..','..GetHNZZMRuleText(deskInfo.rule,false,false,false, true)
	elseif gameType == proxy_pb.YJQF then
		gameObject.transform:Find('Rule/text'):GetComponent('UILabel').text='当前玩法：'..deskInfo.playName..','..getYJQFRuleString(deskInfo.rule, false, true, false,true)
	else
		gameObject.transform:Find('Rule/text'):GetComponent('UILabel').text=''
	end

end
function this.Start()
	
end
function this.Update()
   
end
function this.OnEnable()

    
end

function this.OnClickDestroy(go)
	panelMessageBoxTiShi.SetParamers(OK_CANCLE, this.OnClicDestroyButton, nil, '该操作不可逆，请确认是否解散该房间！', '确 定')
	PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
	
end

function this.OnClicDestroyButton()
	local msg = Message.New()
	msg.type = proxy_pb.DISSOLVE_ROOM
	local body = proxy_pb.PDissolveRoom();
	body.roomNumber = deskInfo.desk.roomNumber
	body.clubId = panelClub.clubInfo.clubId
	msg.body = body:SerializeToString();
	SendProxyMessage(msg, this.OnDestoryResult);
	PanelManager.Instance:HideWindow("panelLookTable")
end

function this.OnDestoryResult(msg)
	local b = proxy_pb.RResult()
	b:ParseFromString(msg.body)
	if b.code == 1 then
		panelMessageTip.SetParamers('解散成功', 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	end
end

function this.OnClickClose(go)
	PanelManager.Instance:HideWindow(gameObject.name)
end
function this.OnClickJoin(go)
	local ruleTemp = panelClub.GetPlayRuleByRuleId(deskInfo.desk.ruleId)
	if not GpsCheck(ruleTemp) then
		return
	end
	
	if deskInfo.desk.open then
		local msg = Message.New()
		msg.type = proxy_pb.ENTER_ROOM
		local body = proxy_pb.PEnterRoom();
		if UnityEngine.PlayerPrefs.HasKey("longitude") then
			body.longitude = UnityEngine.PlayerPrefs.GetFloat("longitude",0)
			body.latitude = UnityEngine.PlayerPrefs.GetFloat("latitude",0)
		end
		body.roomNumber = deskInfo.desk.roomNumber
		msg.body = body:SerializeToString();
		SendProxyMessage(msg, this.OnEnterRoomResult);
	else
		PanelManager.Instance:ShowWindow('panelJoinRoom')
		PanelManager.Instance:HideWindow(gameObject.name)
	end
end

function this.OnClickSeat(go)
	local ruleTemp = panelClub.GetPlayRuleByRuleId(deskInfo.desk.ruleId)
	if not GpsCheck(ruleTemp) then
		return
	end
	
	local msg = Message.New()
	msg.type = proxy_pb.ENTER_ROOM
	local body = proxy_pb.PEnterRoom();
	body.roomNumber = deskInfo.desk.roomNumber
	if UnityEngine.PlayerPrefs.HasKey("longitude") then
		body.longitude = UnityEngine.PlayerPrefs.GetFloat("longitude",0)
		body.latitude = UnityEngine.PlayerPrefs.GetFloat("latitude",0)
	end
	body.seat=GetUserData(go)
	msg.body = body:SerializeToString();
	SendProxyMessage(msg, this.OnEnterRoomResult);
end

function this.OnEnterRoomResult(msg)
	print('OnEnterRoomResult')
	local b = proxy_pb.REnterRoom();
    b:ParseFromString(msg.body);
	roomInfo.host 		= b.host
	roomInfo.port 		= b.port
	roomInfo.token 		= b.token
	roomInfo.roomNumber = b.roomNumber
	roomInfo.gameType 	= b.gameType
	roomInfo.roomType 	= b.roomType
	
	for key,value in ipairs(roomInfo) do
		print(key, value)
	end
	if b.gameType==proxy_pb.PHZ then
		PanelManager.Instance:ShowWindow('panelInGameLand',gameObject.name);
		print("加入跑胡子的房间");
	elseif b.gameType==proxy_pb.PDK then
		PanelManager.Instance:ShowWindow('panelInGame_pdk',gameObject.name);
		print("加入跑得快的房间");
	elseif b.gameType == proxy_pb.MJ then 
		PanelManager.Instance:ShowWindow('panelInGamemj',gameObject.name);
		print("加入跑麻将的房间");
	elseif b.gameType == proxy_pb.XHZD then 
		PanelManager.Instance:ShowWindow('panelInGame_xhzd',gameObject.name);
		print("加入新化炸弹的房间");
	elseif b.gameType == proxy_pb.DTZ then
		PanelManager.Instance:ShowWindow('panelInGame_dtz',gameObject.name);
		print("加入打筒子的房间");
	elseif b.gameType == proxy_pb.BBTZ then
		PanelManager.Instance:ShowWindow('panelInGame_bbtz',gameObject.name);
		print("加入半边天炸的房间");
	elseif b.gameType == proxy_pb.XPLP then
		PanelManager.Instance:ShowWindow('panelInGame_xplp',gameObject.name);
		print("加入溆浦老牌的房间");
	elseif b.gameType == proxy_pb.HNM and b.roomType == proxy_pb.HNHSM then
		PanelManager.Instance:ShowWindow('panelInGame_hnhsm',gameObject.name);
		print("加入划水麻将的房间");
	elseif b.gameType == proxy_pb.HNM and b.roomType == proxy_pb.HNZZM then
		PanelManager.Instance:ShowWindow('panelInGame_hnzzm',gameObject.name);
		print("加入郑州麻将的房间");
	elseif b.gameType == proxy_pb.YJQF then 
		PanelManager.Instance:ShowWindow('panelInGame_yjqf',gameObject.name)
	end
end


function this.OnClickTable(go)
	
end
