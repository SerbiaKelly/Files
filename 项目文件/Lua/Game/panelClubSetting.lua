

panelClubSetting = {}
local this = panelClubSetting;
local gameObject
local message;
local gameObject;

local inputName
local id
local num
local time
local lord

local recieveOn
local recieveOff

local ButtonJieSan
local ButtonCreate
local ButtonOK
local mask

local isRecieve = 1

local stopRoomOn
local stopRoomOff

local bySelfJoinOn
local bySelfJoinOff

local clubName

function this.Awake(obj)
	gameObject = obj;

	clubName = gameObject.transform:Find('clubName')

	inputName = clubName.transform:Find('write')
	id = gameObject.transform:Find('id')
	num = gameObject.transform:Find('num')
	time = gameObject.transform:Find('time')
	lord = gameObject.transform:Find('lord')

	recieveOn = gameObject.transform:Find('recieve/on')
	recieveOff = gameObject.transform:Find('recieve/off')

	ButtonJieSan = gameObject.transform:Find('ButtonJieSan');
	ButtonCreate = gameObject.transform:Find('ButtonCreate');
	ButtonOK = gameObject.transform:Find('ButtonOK');
    mask = gameObject.transform:Find('mask');

	stopRoomOn = gameObject.transform:Find('StopRoom/on')
	stopRoomOff = gameObject.transform:Find('StopRoom/off')

	bySelfJoinOn = gameObject.transform:Find('BySelfJoinRoom/on')
	bySelfJoinOff = gameObject.transform:Find('BySelfJoinRoom/off')

	message = gameObject:GetComponent('LuaBehaviour');

	message:AddClick(ButtonJieSan.gameObject, this.OnClickButtonJieSan);
	message:AddClick(ButtonCreate.gameObject, this.OnClickButtonCreate);
	message:AddClick(recieveOn.gameObject, this.OnClickRecieveOn);
	message:AddClick(recieveOff.gameObject, this.OnClickRecieveOff);
	message:AddSubmit(inputName.gameObject, this.OnSubmit);

	message:AddClick(ButtonOK.gameObject, this.OnClickMask);
	message:AddClick(stopRoomOn.gameObject, this.OnClickStopRoom)
	message:AddClick(stopRoomOff.gameObject, this.OnClickStopRoom)
end

function this.OnSubmit(go)
	print('输入完成')
	local wenBen=trim(inputName:GetComponent('UIInput').value)
	if wenBen and wenBen~='' and wenBen~=panelClub.clubInfo.name and #wenBen <=21 then
		print('一样吗')
		local msg = Message.New()
		msg.type = proxy_pb.UPDATE_CLUB
		local body = proxy_pb.PUpdateClub();
		body.clubId = panelClub.clubInfo.clubId
		body.name = wenBen
		body.pauseRoom = panelClub.clubInfo.pauseRoom
		msg.body = body:SerializeToString()
		SendProxyMessage(msg, this.OnResult);
	else
		if #wenBen > 21 then
			panelMessageTip.SetParamers('牌友群名称不能超过七个字', 1)
			PanelManager.Instance:ShowWindow('panelMessageTip')
		else
			panelMessageTip.SetParamers('请输入牌友群名称', 1)
			PanelManager.Instance:ShowWindow('panelMessageTip')
		end
	end
end

function this.OnResult(msg)
	local b = proxy_pb.RResult()
	b:ParseFromString(msg.body)
	if b.code == 1 then
		print('成功')
		-- panelClub.shuaXinClub()
		panelClub.clubInfo.name=inputName:GetComponent('UIInput').value
        panelMessageTip.SetParamers('修改成功', 1.5)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	else
		print('失败')
		inputName:GetComponent('UIInput').value=panelClub.clubInfo.name
	end
end

function this.Update()
   
end
function this.Start()
	
	
end

function this.WhoShow(name)
	print(name..'打开'..gameObject.name)
	
end

function this.OnEnable()
	id:GetComponent('UILabel').text='群ID：'..panelClub.clubInfo.clubId
	num:GetComponent('UILabel').text='群成员：'..panelClub.clubInfo.memberSize..'/'..panelClub.clubInfo.clubSize
	time:GetComponent('UILabel').text='创建时间：'..os.date('%Y/%m/%d %H:%M', panelClub.clubInfo.createTime)
    --isRecieve = UnityEngine.PlayerPrefs.GetInt('isRecieve'..panelClub.clubInfo.clubId, 1)
	lord:GetComponent('UILabel').text = '群主：'..panelClub.clubInfo.lordNickname..'(ID：'..panelClub.clubInfo.lordId..')'
	inputName:GetComponent('UIInput').value = panelClub.clubInfo.name
	clubName.transform:Find('Name'):GetComponent('UILabel').text = panelClub.clubInfo.name

	recieveOn:GetComponent('UIToggle'):Set(isRecieve == 1)
	recieveOff:GetComponent('UIToggle'):Set(isRecieve ~= 1)

	stopRoomOn:GetComponent('UIToggle'):Set(panelClub.clubInfo.pauseRoom)
	stopRoomOff:GetComponent('UIToggle'):Set(not panelClub.clubInfo.pauseRoom)

	if panelClub.clubInfo.userType==proxy_pb.LORD then
		print('我是群主')
		gameObject.transform:Find('StopRoom').gameObject:SetActive(true)
		gameObject.transform:Find('BySelfJoinRoom').gameObject:SetActive(false)
		ButtonJieSan:Find('Label'):GetComponent('UILabel').text='解散本群'
		clubName.transform:Find('write').gameObject:SetActive(true)
	else
		print('我是成员')
		gameObject.transform:Find('StopRoom').gameObject:SetActive(false)
		gameObject.transform:Find('BySelfJoinRoom').gameObject:SetActive(true)
		ButtonJieSan:Find('Label'):GetComponent('UILabel').text='退出本群'
		clubName.transform:Find('write').gameObject:SetActive(false)
	end
end

function this.OnClickCopyName(go)
	local str = inputName:GetComponent('UIInput').value
	Util.CopyToSystemClipbrd(str)
    panelMessageTip.SetParamers('复制成功', 1.5)
	PanelManager.Instance:ShowWindow('panelMessageTip')	
end

function this.OnClickStopRoom(go)
	local msg = Message.New()
    msg.type = proxy_pb.UPDATE_CLUB
	local body = proxy_pb.PUpdateClub()
	body.clubId = panelClub.clubInfo.clubId
	body.name = panelClub.clubInfo.name

	if go == stopRoomOn.gameObject then
		body.pauseRoom = true
	else
		body.pauseRoom = false
	end
	print('暂停开房'..tostring(body.pauseRoom))
	msg.body = body:SerializeToString()
	SendProxyMessage(msg, this.StopRoomResult);
end

function this.StopRoomResult(msg)
	local b = proxy_pb.RResult()
	b:ParseFromString(msg.body)
	if b.code == 1 then
		--panelClub.shuaXinClub()
		PanelManager.Instance:HideWindow(gameObject.name)
	end
end

function this.OnClickButtonJieSan(go)
	AudioManager.Instance:PlayAudio('btn')
	if ButtonJieSan:Find('Label'):GetComponent('UILabel').text=='解散本群' then
		panelMessageBoxTiShi.SetParamers(OK_CANCLE, this.OnClicButton, nil, '该操作不可逆，请确认是否解散该牌友群！', '确 定')
		PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
	else
		if panelClub.clubInfo.userType==proxy_pb.MANAGER then
			panelMessageBoxTiShi.SetParamers(OK_CANCLE, this.OnClicQuitButton, nil, '是否确定退出本群？ 若退出成功，则您的直属玩家将全部从本群移除；请谨慎操作！', '确 定')
			
		else
			panelMessageBoxTiShi.SetParamers(OK_CANCLE, this.OnClicQuitButton, nil, '该操作不可逆，请确认是否退出该牌友群！', '确 定')
		end
		PanelManager.Instance:ShowWindow('panelMessageBoxTiShi')
	end
	
end

function this.OnClicButton()
	local msg = Message.New()
    msg.type = proxy_pb.DELETE_CLUB
	local body = proxy_pb.PDeleteClub()
	body.clubId = panelClub.clubInfo.clubId
	msg.body = body:SerializeToString()
	SendProxyMessage(msg, this.deleteResult);
end
function this.OnClicQuitButton()
	local msg = Message.New()
    msg.type = proxy_pb.CLUB_USER_MANAGE
	local body = proxy_pb.PClubUserManage()
	body.clubId = panelClub.clubInfo.clubId
	body.userId = info_login.id
	body.operation = proxy_pb.QUIT
	msg.body = body:SerializeToString()
	SendProxyMessage(msg, nil);
	PanelManager.Instance:HideWindow(gameObject.name)
	PanelManager.Instance:HideWindow('panelMessageBox')
end
-- function this.QuitResult(msg)
--     print('QuitResult')
-- 	local b = proxy_pb.RResult()
-- 	b:ParseFromString(msg.body)
-- 	if b.code == 1 then
-- 		PanelManager.Instance:HideWindow(gameObject.name)
-- 		PanelManager.Instance:HideWindow('panelClub')
-- 		PanelManager.Instance:ShowWindow('panelLobby')
--         panelMessageTip.SetParamers('退出牌友群成功', 1.5)
-- 		PanelManager.Instance:ShowWindow('panelMessageTip')
-- 	end
-- end
function this.deleteResult(msg)
    print('deleteResult')
	local b = proxy_pb.RResult()
	b:ParseFromString(msg.body)
	if b.code == 1 then
		PanelManager.Instance:HideWindow(gameObject.name)
		-- PanelManager.Instance:HideWindow('panelClub')
		-- PanelManager.Instance:ShowWindow('panelLobby')
        -- panelMessageTip.SetParamers('解散牌友群成功', 1.5)
		-- PanelManager.Instance:ShowWindow('panelMessageTip')
	end
end
function this.OnClickButtonCreate(go)
	AudioManager.Instance:PlayAudio('btn')
	PanelManager.Instance:HideAllWindow()
	PanelManager.Instance:ShowWindow('panelClubHome','panelClub')
end

function this.OnClickRecieveOn(go)
	AudioManager.Instance:PlayAudio('btn')
	isRecieve = 1
	UnityEngine.PlayerPrefs.SetInt('isRecieve'..panelClub.clubInfo.clubId, isRecieve)
end
function this.OnClickRecieveOff(go)
	AudioManager.Instance:PlayAudio('btn')
	isRecieve = 0
	UnityEngine.PlayerPrefs.SetInt('isRecieve'..panelClub.clubInfo.clubId, isRecieve)
end


function this.OnClickMask(go)
	AudioManager.Instance:PlayAudio('btn')
    PanelManager.Instance:HideWindow(gameObject.name)
end