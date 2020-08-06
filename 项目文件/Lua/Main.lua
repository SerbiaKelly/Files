local proxy_pb = require 'proxy_pb'

require "panelClub"
require "panelInGameLand"

inviteId=''
--主入口函数。从这里开始lua逻辑
function Main()					
	local breakSocketHandle,debugXpCall = require("LuaDebugjit")("localhost",7003)

	--加载NGUI共享Altas
    --ResourceManager.Instance:LoadShareBundle('common');
	ResourceManager.Instance:LoadShareBundle('emoji');
    ResourceManager.Instance:LoadShareBundle('ingame');
	ResourceManager.Instance:LoadShareBundle('dating');
	ResourceManager.Instance:LoadShareBundle('Game');
    ResourceManager.Instance:LoadShareBundle('ingamemj');
	ResourceManager.Instance:LoadShareBundle('club');
	ResourceManager.Instance:LoadShareBundle('public');
	--ResourceManager.Instance:LoadShareBundle('bankgroud');
    --ResourceManager.Instance:LoadShareBundle('lobby');
	--ResourceManager.Instance:LoadShareBundle('font');
	ResourceManager.Instance:LoadShareBundle('FZPC-DH');
	ResourceManager.Instance:LoadShareBundle('FZZY');
	ResourceManager.Instance:LoadShareBundle('FZCY');
	ResourceManager.Instance:LoadShareBundle('ingamexhzd');
	ResourceManager.Instance:LoadShareBundle('ingamedtz');
	ResourceManager.Instance:LoadShareBundle('ingamebbtz');
	ResourceManager.Instance:LoadShareBundle('ingamexplp');
	ResourceManager.Instance:LoadShareBundle('dice');
	ResourceManager.Instance:LoadShareBundle('dtzAnimation');
	--ResourceManager.Instance:LoadShareBundle('bgTexture');
	print("资源加载完成")
	if Util.GetPlatformStr() ~= 'win' then
		if ConfigManager.getBoolProperty('GameShield', 'IsUserShield', false) then
			local mAppKey;
			if Util.GetPlatformStr() == 'ios' then
				mAppKey = 'VF3llB3a2_Z1KUkAv5bG6TOXu7YRw5cVLv_CWuFSjB1ninrwPfv5SRbFlF+X5YOMw3dgVrvVxjVktkm_a3Fwmf1J7c3qAe9tzvIm797eCJljX1rLb2EWdQGL_LvGU92pLG7p7PoDCj6RP2eFg3IMCPfS0f5+wxqreeNnhFtu--PRLZ3NN5nATIqylFVFGn9ghgpsHUgutlQNE5C3wBO4TyjJoArpHLvXMKv2Eb_xu8kOCiJp1+zYEFYtdBYLPsrPCeDOOwqYnYI_R-AW-qtAQbhfxWVGQQoZKQIaXmKOf6TbPlpoXIla+CSNe+gG1DOK78y+DZdlYITHrS9F1Aafame1uX8oHcn+TUAj+tRKa3ArebUd8QTWgRYw2c3ZSg2ghPkEvXV53DSO4gt5XMJriUJYWUyolNYL_N6xY-RjCjC52ZubtqsvQmRrKUZFm';
			else
				mAppKey = 'VF3llB3a2_Z1KUkAv5bG6TOXu7YRw5cVLv_CWuFSjB1ninrwPfv5SRbFlF+X5YOMw3dgVrvVxjVktkm_a3Fwmf1J7c3qAe9tzvIm797eCJljX1rLb2EWdQGL_LvGU92pLG7p7PoDCj6RP2eFg3IMCPfS0f5+wxqreeNnhFtu--PRLZ3NN5nATIqylFVFGn9ghgpsHUgutlQNE5C3wBO4TyjJoArpHLvXMKv2Eb_xu8kOCiJp1+zYEFYtdBYLPsrPCeDOOwqYnYI_R-AW-qtAQbhfxWVGQQoZKQIaXmKOf6TbPlpoXIla+CSNe+gG1DOK78y+DZdlYITHrS9F1Aafame1uX8oHcn+TUAj+tRKa3ArebUd8QTWgRYw2c3ZSg2ghPkEvXV53DSO4gt5XMJriUJYWUyolNYL_N6xY-RjCjC52ZubtqsvQmRrKUZFm';
			end
			local ret  = PlatformManager.Instance:InitYunCeng(mAppKey);
			while ret ~= 0 do
				ret = PlatformManager.Instance:InitYunCeng(mAppKey);
			end
		end
	end
	coroutine.start(function()
		coroutine.wait(0.1)
		print("实例化登录界面")
		PanelManager.Instance:ShowWindow("panelLogin");
	end)
end

--场景切换通知
function OnLevelWasLoaded(level)
	collectgarbage("collect")
	Time.timeSinceLevelLoad = 0
	print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',level)
end

--响应魔窗进入房间请求
function OnMWEnterRoom(roomNumber)
	Debugger.Log('OnMWEnterRoom', nil)

	--仅当玩家不在游戏中
	if isIngame and (not RoundAllData.over) then
		return false
	end
	
	Debugger.Log('OnMWEnterRoom2', nil)

	isLoginPong = false
	if string.find(roomNumber,"clubId") then
		local clubid=string.sub(roomNumber,8,15)
		Debugger.Log('OnMWEnterClubMW牌友群号'..clubid, nil)
		coroutine.start(
			function()
				while not isLogin  or not isLoginPong do
					coroutine.wait(1)
				end
				
				
				local data={}
				data.name='moChuang'
				data.clubId=clubid
				PanelManager.Instance:HideAllWindow()
				PanelManager.Instance:ShowWindow('panelClub',data)
			end
		)
	elseif string.find(roomNumber,"invite") then
		inviteId=string.sub(roomNumber,8,14)
		Debugger.Log('OnMWEinvite邀请人id'..inviteId, nil)
	elseif string.find(roomNumber,"Trko4uPSy2312d") then
		local openId=string.sub(roomNumber,16)
		Debugger.Log('OnMWEinvite闲聊openId'..openId, nil)
	elseif string.find(roomNumber,"roomNumber") then
		local fangJiaoHao=string.sub(roomNumber,12)
		local msg = Message.New()
		msg.type = proxy_pb.ENTER_ROOM
		local body = proxy_pb.PEnterRoom()
		body.roomNumber = fangJiaoHao
		if UnityEngine.PlayerPrefs.HasKey("longitude") then
			body.longitude = UnityEngine.PlayerPrefs.GetFloat("longitude",0)
			body.latitude = UnityEngine.PlayerPrefs.GetFloat("latitude",0)
		end
		msg.body = body:SerializeToString()
		Debugger.Log('OnMWEnterRoom房间号'..fangJiaoHao, nil)
		coroutine.start(
			function()
				while not isLogin  or not isLoginPong do
					coroutine.wait(1)
				end
				
				Debugger.Log('OnMWEnterRoom3', nil)
				SendProxyMessage(msg, 
					function (resp)
						local b = proxy_pb.REnterRoom();
						b:ParseFromString(resp.body);
						roomInfo.host = b.host
						roomInfo.port = b.port
						roomInfo.token = b.token
						roomInfo.roomNumber = b.roomNumber
						roomInfo.gameType = b.gameType
						roomInfo.roomType = b.roomType
						PanelManager.Instance:HideAllWindow()
						-- if UnityEngine.PlayerPrefs.GetInt('landScape') == 1 then
							PanelManager.Instance:ShowWindow('panelInGameLand')
						-- else
						-- 	PanelManager.Instance:ShowWindow('panelInGamePortrait')
						-- end
					end
				)
			end
		)
	end

	
	return true
end
function OnApplicationQuit()
end