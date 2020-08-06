local proxy_pb = require 'proxy_pb'
local json = require 'json'

panelCreateRoomNew = {}
local this = panelCreateRoomNew;

local message;
local gameObject;

local ButtonClose
local RuleButton
local ButtonOK

local tableGame
local gridRoom
local scrollviewRoom

local tishi

local createRoomType=1--对应proxy协议里的 RoomType
local createGameType=0--0字牌，1扑克，2麻将

local subRooms = {};
subRooms["CDPHZ_7"] 	= true;
subRooms["CSM_50"]		= true;
subRooms["CSPHZ_9"]		= true;
subRooms["HHHGW_2"]		= true;
subRooms["HYLHQ_3"]		= true;
subRooms["HYSHK_4"]		= true;
subRooms["HZM_52"]		= true;
subRooms["LDFPF_6"]		= true;
subRooms["PDKSLZ_31"]	= true;
subRooms["PDKSWZ_30"]	= true;
subRooms["PKBBTZ_37"]	= true;
subRooms["PKDTZ_36"]	= true;
subRooms["PKXHZD_35"]	= true;
subRooms["SYBP_1"]		= true;
subRooms["SYZP_0"]		= true;
subRooms["XXGHZ_11"]	= true;
subRooms["ZZM_51"]		= true;
subRooms["LYZP_8"]		= true;
subRooms["HSPHZ_12"]	= true;
subRooms["CDDHD_13"]	= true;
subRooms["NXPHZ_16"]	= true;
subRooms["XTPHZ_15"]	= true;
subRooms["XPLP_55"]		= true;
subRooms["HNHSM_56"]	= true;
subRooms["HNZZM_57"]	= true;
subRooms["DZAHM_58"]	= true;
subRooms["YXPHZ_17"]	= true;
subRooms["PKYJQF_40"]	= true;
subRooms["YJGHZ_18"]	= true;
subRooms["CZZP_10"]		= true;
subRooms["PKHSTH_41"]	= true;
subRooms["AHPHZ_19"]	= true;
local panelCreateRoomSub ={}

local btnRoomTypeNum = 1
--新增游戏需要把游戏对应的索引，和脚本加上去
local panelLuaCreateRoomSub={
	[proxy_pb.SYZP] 	= require 'subWinCreate_SYZP',
	[proxy_pb.SYBP] 	= require 'subWinCreate_SYBP',
	[proxy_pb.HYLHQ] 	= require 'subWinCreate_HYLHQ',
	[proxy_pb.HHHGW] 	= require 'subWinCreate_HHHGW',
	[proxy_pb.HYSHK] 	= require 'subWinCreate_HYSHK',
	[proxy_pb.LDFPF] 	= require 'subWinCreate_LDFPF',
	[proxy_pb.CDPHZ] 	= require 'subWinCreate_CDPHZ',
	[proxy_pb.CSPHZ] 	= require 'subWinCreate_CSPHZ',
	[proxy_pb.XXGHZ] 	= require 'subWinCreate_XXGHZ',
	[proxy_pb.LYZP] 	= require 'subWinCreate_LYZP',
	[proxy_pb.HSPHZ] 	= require 'subWinCreate_HSPHZ',
	[proxy_pb.CDDHD] 	= require 'subWinCreate_CDDHD',
	[proxy_pb.NXPHZ] 	= require 'subWinCreate_NXPHZ',
	[proxy_pb.XTPHZ] 	= require 'subWinCreate_XTPHZ',
	[proxy_pb.YXPHZ] 	= require 'subWinCreate_YXPHZ',
	[proxy_pb.YJGHZ] 	= require 'subWinCreate_YJGHZ',
	[proxy_pb.CZZP] 	= require 'subWinCreate_CZZP',
	[proxy_pb.AHPHZ] 	= require 'subWinCreate_AHPHZ', 

	[proxy_pb.PDKSWZ] 	= require 'subWinCreate_PDKSWZ',
	[proxy_pb.PDKSLZ] 	= require 'subWinCreate_PDKSLZ',
	[proxy_pb.PKXHZD] 	= require 'subWinCreate_PKXHZD',
	[proxy_pb.PKDTZ] 	= require 'subWinCreate_PKDTZ',
	[proxy_pb.PKBBTZ] 	= require 'subWinCreate_PKBBTZ',
	[proxy_pb.PKYJQF] 	= require 'subWinCreate_PKYJQF',
	[proxy_pb.PKHSTH] 	= require 'subWinCreate_PKHSTH',

	[proxy_pb.CSM] 		= require 'subWinCreate_CSM',
	[proxy_pb.ZZM] 		= require 'subWinCreate_ZZM',
	[proxy_pb.HZM] 		= require 'subWinCreate_HZM',
	[proxy_pb.XPLPM] 	= require 'subWinCreate_XPLP',
	[proxy_pb.HNHSM] 	= require 'subWinCreate_HNHSM',
	[proxy_pb.HNZZM] 	= require 'subWinCreate_HNZZM',
	[proxy_pb.DZAHM] 	= require 'subWinCreate_DZAHM',
}
 
--切换GameType按钮设置初始值，目前就跑胡子，扑克，麻将三个
local gameTypeDefaultRoomType={
	[0]=1,--邵阳剥皮
	[1]=30,--15张跑得快
	[2]=50--长沙麻将
}

--新增一个游戏需要  Refresh，Init，GetConfig三个方法名需要一样 才能实现统一接口，UI设置也需要命名成 游戏类型+下划线+对应的游戏类型索引
				
function this.Awake(obj)
	gameObject = obj
	message = gameObject:GetComponent('LuaBehaviour')
	
	ButtonClose = gameObject.transform:Find('ButtonClose')
	RuleButton = gameObject.transform:Find('RuleButton')
	ButtonOK = gameObject.transform:Find('ButtonOK')

	tishi = gameObject.transform:Find('tishi')

	message:AddClick(ButtonClose.gameObject, this.OnClickClose)
	message:AddClick(RuleButton.gameObject, this.OnShowRuleInfo)
	message:AddClick(ButtonOK.gameObject, this.OnClickButtonOK)

	message:AddClick(tishi.transform:Find('ButtonOK').gameObject, this.OnClickTiShiButtonOK)

	tableGame =  gameObject.transform:Find('table')
	for i=0,tableGame.childCount-1 do
		local item = tableGame:GetChild(i)
		message:AddClick(item.gameObject, this.OnClickButtonGameType)
	end
	
	gridRoom =  gameObject.transform:Find('gridBtn/grid')
	for i=0,gridRoom.childCount-1 do
		local item = gridRoom:GetChild(i)
		message:AddClick(item.gameObject, this.OnClickButtonRoomType)
	end
	scrollviewRoom = gameObject.transform:Find('scrollview')
	
end

function this.Start()
end

function this.OnEnable()
	btnRoomTypeNum=1
	tishi.gameObject:SetActive(false)
	createGameType = UnityEngine.PlayerPrefs.GetInt('createGameType', 0)
	createRoomType = UnityEngine.PlayerPrefs.GetInt('createRoomType', 1)
	print('OnEnable  createGameType : '..createGameType..' createRoomType : '..createRoomType)
	for i=0,tableGame.childCount-1 do
		local item = tableGame:GetChild(i)
		local gametype = string.match(item.gameObject.name,'%d')
		if tonumber(gametype) == createGameType then
			this.OnClickButtonGameType(item.gameObject)
		end
	end
end

function this.Update()
end

function this.OnApplicationFocus()
end

function this.OnClickClose(go)
	AudioManager.Instance:PlayAudio('btn')
	btnRoomTypeNum=1
    PanelManager.Instance:HideWindow(gameObject.name)
end

function this.OnShowRuleInfo(go)
	PanelManager.Instance:ShowWindow('panelHelp', createRoomType)
end

function this.OnClickButtonOK(go)
	AudioManager.Instance:PlayAudio('btn')
	local moneyLess,body = panelCreateRoomSub[createRoomType].GetConfig()
	if moneyLess then
		panelMessageTip.SetParamers('钻石不够啦！赶紧去购买钻石吧', 2)
		PanelManager.Instance:ShowWindow('panelMessageTip')
	end
	
	if not GpsCheck(body) then
		return
	end

	local msg = Message.New()
	msg.type = proxy_pb.CREATE_ROOM
	local bigbody = proxy_pb.PCreateRoom()
	if createGameType == 0 then
		bigbody.gameType = proxy_pb.PHZ
	elseif createGameType == 1 then
		if createRoomType == 31 or createRoomType == 30 then
			bigbody.gameType = proxy_pb.PDK
		elseif createRoomType == 35 then
			bigbody.gameType = proxy_pb.XHZD
		elseif createRoomType == 36 then
			bigbody.gameType = proxy_pb.DTZ
		elseif createRoomType == 37 then
			bigbody.gameType = proxy_pb.BBTZ
		elseif createRoomType == 40 then
			bigbody.gameType = proxy_pb.YJQF
		end
	elseif createGameType == 2 then
		if createRoomType == 50 or createRoomType == 51 or createRoomType == 52 then
			bigbody.gameType = proxy_pb.MJ
		end
		if createRoomType == proxy_pb.XPLPM then 
			bigbody.gameType = proxy_pb.XPLP
		end
		if createRoomType == proxy_pb.HNHSM or createRoomType == proxy_pb.HNZZM then 
			bigbody.gameType = proxy_pb.HNM
		end
		if createRoomType == proxy_pb.DZAHM then 
			bigbody.gameType = proxy_pb.DZM
		end
	end
	local str = 'body======'
	for k,v in pairs(body) do
		str = str .. k .. ':'..tostring(v)..breakString(true)
	end
	print(str)
	
	bigbody.settings = json:encode(body)
	msg.body = bigbody:SerializeToString() 
	SendProxyMessage(msg, this.OnCreateRoomResult)
end

function this.OnCreateRoomResult(msg)
	print('OnCreateRoomResult')
	btnRoomTypeNum=1
	local b = proxy_pb.RCreateRoom()
    b:ParseFromString(msg.body)
	roomInfo.host = b.host
	roomInfo.port = b.port
	roomInfo.token = b.token
	roomInfo.roomNumber = b.roomNumber
	roomInfo.gameType = b.gameType
	roomInfo.roomType = b.roomType
		
	print('host:'..b.host..' port:'..b.port..' token:'..b.token..' roomNumber:'..b.roomNumber)
	if b.gameType == proxy_pb.MJ then
		PanelManager.Instance:ShowWindow('panelInGamemj',gameObject.name)
	elseif b.gameType == proxy_pb.PHZ then
		PanelManager.Instance:ShowWindow('panelInGameLand',gameObject.name)
	elseif b.gameType == proxy_pb.PDK then
		PanelManager.Instance:ShowWindow('panelInGame_pdk',gameObject.name)
	elseif b.gameType == proxy_pb.XHZD then
		PanelManager.Instance:ShowWindow('panelInGame_xhzd',gameObject.name)
	elseif b.gameType == proxy_pb.DTZ then
		PanelManager.Instance:ShowWindow('panelInGame_dtz',gameObject.name)
	elseif b.gameType == proxy_pb.BBTZ then
		PanelManager.Instance:ShowWindow('panelInGame_bbtz',gameObject.name)
	elseif b.gameType == proxy_pb.XPLP then
		PanelManager.Instance:ShowWindow('panelInGame_xplp',gameObject.name)
	elseif b.gameType == proxy_pb.HNM and b.roomType == proxy_pb.HNHSM then 
		PanelManager.Instance:ShowWindow('panelInGame_hnhsm',gameObject.name)
	elseif b.gameType == proxy_pb.HNM and b.roomType == proxy_pb.HNZZM then 
		PanelManager.Instance:ShowWindow('panelInGame_hnzzm',gameObject.name)
	elseif b.gameType == proxy_pb.YJQF then 
		PanelManager.Instance:ShowWindow('panelInGame_yjqf',gameObject.name)
	elseif b.gameType == proxy_pb.HSTH then 
		PanelManager.Instance:ShowWindow('panelInGame_hsth',gameObject.name)
	elseif b.gameType == proxy_pb.DZM and b.roomType == proxy_pb.DZAHM then 
		PanelManager.Instance:ShowWindow('panelInGame_dzahm',gameObject.name)
	end
end

function this.OnClickButtonGameType(go)
	print('OnClickButtonGameType    '..go.name)
	AudioManager.Instance:PlayAudio('btn')
	local gametype = string.match(go.gameObject.name,'%d')
	local tempRoomType = createRoomType
	local tempGameType = tonumber(gametype)
	
	if createGameType ~= tempGameType then
		btnRoomTypeNum=1
		if tempGameType==0 then
			tempRoomType = UnityEngine.PlayerPrefs.GetInt('createRoomTypeZiPai', 1)
		elseif tempGameType==2 then
			tempRoomType = UnityEngine.PlayerPrefs.GetInt('createRoomTypeMaJiang', 50)
		elseif tempGameType==1 then
			tempRoomType = UnityEngine.PlayerPrefs.GetInt('createRoomTypePuKe', 30)
		end
	end
	createGameType = tempGameType
	UnityEngine.PlayerPrefs.SetInt('createGameType', createGameType)
	---设置tableGame按钮状态
	for i=0,tableGame.childCount-1 do
		local tab = tableGame:GetChild(i)
		local tableRoomType = tonumber(string.match(tab.gameObject.name,'%d+'))
		tab:Find('highlight'):GetComponent('UISprite').alpha = tableRoomType ~= tempGameType and 0 or 1
	end
	
	for i=0,gridRoom.childCount-1 do
		local item = gridRoom:GetChild(i)
		local roomtype = string.match(item.gameObject.name,'%d+')
		if tonumber(roomtype) == tempRoomType then
			this.OnClickButtonRoomType(item.gameObject)
			gridRoom.parent:GetComponent('UIScrollView'):ResetPosition()
			break
		end
	end
end

function this.OnClickButtonRoomType(go)
	print('OnClickButtonRoomType')
	AudioManager.Instance:PlayAudio('btn')
	local roomtype = string.match(go.gameObject.name,'%d+')
	createRoomType = tonumber(roomtype)
	UnityEngine.PlayerPrefs.SetInt('createRoomType', createRoomType)
	--字牌和麻将需要记录上次操作值
	if createGameType == 0 then
		UnityEngine.PlayerPrefs.SetInt('createRoomTypeZiPai', createRoomType)
	elseif createGameType == 2 then
		UnityEngine.PlayerPrefs.SetInt('createRoomTypeMaJiang', createRoomType)
	elseif createGameType == 1 then
		UnityEngine.PlayerPrefs.SetInt('createRoomTypePuKe', createRoomType)
	end
	---设置gridRoom按钮状态
	for i=0,gridRoom.childCount-1 do
		local room = gridRoom:GetChild(i)
		local gridRoomType = tonumber(string.match(room.gameObject.name,'%d+'))
		if gridRoomType == proxy_pb.PDKSWZ 
			or gridRoomType == proxy_pb.PDKSLZ 
			or gridRoomType == proxy_pb.PKXHZD 
			or gridRoomType == proxy_pb.PKDTZ 
			or gridRoomType == proxy_pb.PKBBTZ then
			room.gameObject:SetActive(createGameType==1)
		elseif gridRoomType == proxy_pb.CSM 
		or gridRoomType == proxy_pb.ZZM 
		or gridRoomType == proxy_pb.HZM then
			room.gameObject:SetActive(createGameType==2)
		elseif gridRoomType == proxy_pb.SYZP 
			or gridRoomType == proxy_pb.SYBP 
			or gridRoomType == proxy_pb.LDFPF 
			or gridRoomType == proxy_pb.XXGHZ then
			room.gameObject:SetActive(createGameType==0)
		else 
			room.gameObject:SetActive(false)
		end
		if CONST.showAllGame then
			if gridRoomType < proxy_pb.PDKSWZ then
				room.gameObject:SetActive(createGameType==0)
			elseif gridRoomType < proxy_pb.CSM then
				room.gameObject:SetActive(createGameType==1)
			else
				room.gameObject:SetActive(createGameType==2)
			end
		end
		room:Find('highlight').gameObject:SetActive(createRoomType == gridRoomType)
		room:Find('Sprite').gameObject:SetActive(createRoomType ~= gridRoomType)
		if createRoomType == gridRoomType and btnRoomTypeNum == 1 then
			room:SetSiblingIndex(0)
		end
	end

	if btnRoomTypeNum==1 then
		for i=0,gridRoom.childCount-1 do
			gridRoom:GetChild(i):SetAsFirstSibling()
		end
	end
	gridRoom:GetComponent('UIGrid'):Reposition()
	---设置scrollviewRoom按钮状态
	for i=0,scrollviewRoom.childCount-1 do
		scrollviewRoom:GetChild(i).gameObject:SetActive(false)
		scrollviewRoom:GetChild(i):GetComponent('UIScrollView'):ResetPosition()
	end
	
	for subRoom,canCreate in pairs(subRooms) do
		local matchRoomType = tonumber(string.match(subRoom,'%d+'));
		
		if createRoomType == matchRoomType and canCreate then 
			--1.首先判断是否加载了，没有加载则要加载并且实例化
			if scrollviewRoom:Find(subRoom) == nil then 
				local subRoomObj = ResourceManager.Instance:LoadAssetSync(subRoom);
				subRoomObj.name = subRoom;
				subRoomObj = NGUITools.AddChild(scrollviewRoom.gameObject, subRoomObj);
				if not panelCreateRoomSub[matchRoomType] then 
					panelCreateRoomSub[matchRoomType] = panelLuaCreateRoomSub[matchRoomType];
					print('matchRoomType =====   '..matchRoomType, ' subRoomObj ======== '..subRoomObj.name) 
					panelCreateRoomSub[matchRoomType].Init(subRoomObj.transform,message);
				end
				panelCreateRoomSub[matchRoomType].Refresh();
				subRoomObj:GetComponent('UIScrollView'):ResetPosition();
				subRoomObj.gameObject:SetActive(true);
			else--已经加载过了，直接初始化即可
				panelCreateRoomSub[matchRoomType].Refresh();
				scrollviewRoom:Find(subRoom):GetComponent('UIScrollView'):ResetPosition();
				scrollviewRoom:Find(subRoom).gameObject:SetActive(true);
			end
			break;
		end
	end
	btnRoomTypeNum=btnRoomTypeNum+1
end

function this.OnClickTiShiButtonOK(go)
	AudioManager.Instance:PlayAudio('btn')
	tishi.gameObject:SetActive(false)
end