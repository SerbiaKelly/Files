


panelJoinRoom = {}
local this = panelJoinRoom;

local message
local gameObject
local strNum

local ButtonNums={}
local ButtonDelete
local ButtonReInput
local ButtonClose
local selectRoot

local mask

local SelectNums={}
function this.Update()
   
end
local allNum=5
--���¼�--
function this.Awake(obj)
	gameObject = obj;

	selectRoot = gameObject.transform:Find('mainObj/numSelect')
    ButtonDelete = gameObject.transform:Find('mainObj/ButtonDelete')
    ButtonReInput = gameObject.transform:Find('mainObj/ButtonReInput')
	ButtonClose = gameObject.transform:Find('ButtonClose')
	
	message = gameObject:GetComponent('LuaBehaviour')
    mask = gameObject.transform:Find('mask')
    message:AddClick(ButtonDelete.gameObject, this.OnClickButtonDelete)
    message:AddClick(ButtonReInput.gameObject, this.OnClickButtonReInput)
	message:AddClick(ButtonClose.gameObject, this.OnClickMask)

	for i=0,9 do
        ButtonNums[i] = gameObject.transform:Find('mainObj/Button'..i);
        message:AddClick(ButtonNums[i].gameObject, this.OnClickButtonNum);
		SetUserData(ButtonNums[i].gameObject, i)
    end
	
    for i=1,allNum do
        SelectNums[i] = selectRoot:Find('num'..i);
    end
	
end

function this.Start()
	-- gameObject.transform.parent = panelLobby.gameObject.transform
end

function this.OnEnable()
	selectRoot.gameObject:SetActive(false)
	
    strNum=''
    this.Refresh()
end

--�����¼�--
function this.OnClickMask(go)
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnClickButtonDelete(go)
	AudioManager.Instance:PlayAudio('btn')
	strNum = string.sub(strNum, 1, -2)
	this.Refresh()

	if #strNum == 0 then
		selectRoot.gameObject:SetActive(false)
	end
end

function this.OnClickButtonNum(go)
	AudioManager.Instance:PlayAudio('btn')
	if #strNum >= allNum then
		return
	else
		strNum = strNum..GetUserData(go)
		this.Refresh()
	end
	
	if ConfigManager.getIntProperty('Setting', 'LoginType', 0) == 0 and strNum == "88888" then
		CONST.showAllGame = not CONST.showAllGame
		print(CONST.showAllGame)
		panelMessageTip.SetParamers("设置成功", 2)
		PanelManager.Instance:ShowWindow('panelMessageTip')
		return
	end
	
    if #strNum == allNum then
        this.OnEnter()
        return
    end
	
	selectRoot.gameObject:SetActive(true)
end

function this.OnClickButtonReInput(go)
	AudioManager.Instance:PlayAudio('btn')
    strNum=''
	this.Refresh()
	
	selectRoot.gameObject:SetActive(false)
end

function this.OnLogin()
	if #strNum == allNum and gameObject.activeSelf then
        this.OnEnter()
    end
end

function this.Refresh()
    for i=1,allNum do
        if i <= #strNum then
            SelectNums[i]:GetComponent('UILabel').text=string.sub(strNum, i, i)
        else
            SelectNums[i]:GetComponent('UILabel').text='';
        end
    end    
end

function this.OnEnter()
	local msg = Message.New()
	msg.type = proxy_pb.ENTER_ROOM
	local body = proxy_pb.PEnterRoom();
	body.roomNumber = strNum
	if UnityEngine.PlayerPrefs.HasKey("longitude") then
		body.longitude = UnityEngine.PlayerPrefs.GetFloat("longitude",0)
		body.latitude = UnityEngine.PlayerPrefs.GetFloat("latitude",0)
	end
	msg.body = body:SerializeToString();
	SendProxyMessage(msg, this.OnEnterRoomResult);
end

function this.OnEnterRoomResult(msg)
	print('OnEnterRoomResult')
	local b = proxy_pb.REnterRoom();
    b:ParseFromString(msg.body);
	roomInfo.host = b.host
	roomInfo.port = b.port
	roomInfo.token = b.token
	roomInfo.roomNumber = b.roomNumber
	roomInfo.gameType = b.gameType
	roomInfo.roomType = b.roomType
	
	for key,value in ipairs(roomInfo) do
		print(key, value)
	end

	local testDIC = {};
	testDIC[proxy_pb.PDK] = "PDK";
	testDIC[proxy_pb.PHZ] = "PHZ";
	testDIC[proxy_pb.MJ] = "MJ";
	testDIC[proxy_pb.XHZD] = "XHZD";
	testDIC[proxy_pb.XPLP] = "XPLP";
	if testDIC[b.gameType] then 
		print("b.gameType:"..testDIC[b.gameType]);
	else
		print("wrong b.gameType");
	end
	
	if b.gameType == proxy_pb.PDK then
		PanelManager.Instance:ShowWindow('panelInGame_pdk',gameObject.name);
		print("加入跑得快的房间");
	elseif b.gameType == proxy_pb.PHZ then
		PanelManager.Instance:ShowWindow('panelInGameLand',gameObject.name);
		print("加入跑胡子的房间");
	elseif b.gameType == proxy_pb.MJ then
		PanelManager.Instance:ShowWindow('panelInGamemj',gameObject.name);
		print("加入跑麻将的房间");
	elseif b.gameType == proxy_pb.XHZD then
		PanelManager.Instance:ShowWindow('panelInGame_xhzd',gameObject.name);
		print("加入新化炸弹的房间");
	elseif b.gameType == proxy_pb.DTZ then
		PanelManager.Instance:ShowWindow('panelInGame_dtz',gameObject.name);
		print("加入打筒子的房间");
	elseif b.gameType == 5 then
		PanelManager.Instance:ShowWindow('panelInGame_bbtz',gameObject.name);
	elseif b.gameType == proxy_pb.XPLP then 
		PanelManager.Instance:ShowWindow('panelInGame_xplp',gameObject.name);
	elseif b.gameType == proxy_pb.HNM and b.roomType == proxy_pb.HNHSM then 
		PanelManager.Instance:ShowWindow('panelInGame_hnhsm',gameObject.name);
	elseif b.gameType == proxy_pb.HNM and b.roomType == proxy_pb.HNZZM then 
		PanelManager.Instance:ShowWindow('panelInGame_hnzzm',gameObject.name);
	elseif b.gameType == proxy_pb.YJQF then 
		PanelManager.Instance:ShowWindow('panelInGame_yjqf',gameObject.name)
	elseif b.gameType == proxy_pb.DZM and b.roomType == proxy_pb.DZAHM then 
		PanelManager.Instance:ShowWindow('panelInGame_dzahm',gameObject.name)
	end
	--PanelManager.Instance:HideWindow(gameObject.name)
	--PanelManager.Instance:HideWindow('panelLobby')
	-- local landScape = UnityEngine.PlayerPrefs.GetInt('landScape')
	-- if landScape == 1 then
		--PanelManager.Instance:ShowWindow('panelInGame',gameObject.name)  --需要改回去
	-- else
	-- 	PanelManager.Instance:ShowWindow('panelInGamePortrait')
	-- end
end