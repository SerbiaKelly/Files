require 'panelInGame_xhzd'

panelGPS_xhzd = {}
local this = panelGPS_xhzd;

local message
local gameObject

local PlayerUIObjs = {};
local DistanceObjs = {};

function this.Awake(obj)
    gameObject = obj;
    message = gameObject:GetComponent('LuaBehaviour');

    message:AddClick(gameObject.transform:Find('ButtonClose').gameObject, function ()
        PanelManager.Instance:HideWindow(gameObject.name)
    end)

    this.GetDistanceUI();
end

function this.Start()
end
function this.Update()
end
function this.OnEnable()
    this.SetGPSUI();
    this.SetDistance();
    this.SetPlayerInfo();
end

function this.WhoShow()
    
end

function this.GetDistanceUI()
    local distanceObj = gameObject.transform:Find("Distance");
    local playerObj = gameObject.transform:Find("players");
    --用户信息
    for i = 0, 3 do
        PlayerUIObjs[i] = {};
        PlayerUIObjs[i].transform = playerObj:Find("Player"..i+1);
        PlayerUIObjs[i].HeadImage = PlayerUIObjs[i].transform:Find("tx");
        PlayerUIObjs[i].Name = PlayerUIObjs[i].transform:Find("name");
        PlayerUIObjs[i].ID = PlayerUIObjs[i].transform:Find("id");
    end
    --距离信息
    for i = 1, 6 do
        DistanceObjs[i] = {};
        DistanceObjs[i].transform = distanceObj:Find("distance"..i);
        DistanceObjs[i].disLabel = DistanceObjs[i].transform:Find("disLabel");
    end
end

--根据玩的人数设置GSP的显隐
function this.SetGPSUI(playerSize)
    for i = 1, 6 do
        DistanceObjs[i].transform.gameObject:SetActive(true);
    end
    for i = 0, 3 do
        PlayerUIObjs[i].transform.gameObject:SetActive(true);
    end
end

--设置距离
function this.SetDistance()
    local distanceTable = this.GetDistance();
    for key, value in pairs(distanceTable) do
        print("key="..key..",value:"..value);
        if value == -1 then
            DistanceObjs[key].transform.gameObject:SetActive(false);
        else
            DistanceObjs[key].transform.gameObject:SetActive(true);
            DistanceObjs[key].disLabel:GetComponent("UILabel").text = value;
        end
    end
end

function this.GetDistance()
	local keys = {1,2,3,4,5,6};
	local i = 0;
	local distanceTable = {};
	for key, value in pairs(keys) do
        print('hdoasdhosaaaaaaaaaaaaaaaaaaaaaaaai');
        if i <= 3 then
            print('hdoasdhosaaaaaaaaaaaaaaaaaaaaaaaai : '..i)
			local playerData1 = panelInGame.GetPlayerDataByUIIndex(i);
			local p2index = (i + 1) % 4;
			local playerData2 = panelInGame.GetPlayerDataByUIIndex(p2index);

			if playerData1 and playerData2 then
				local tempDistance = GetDistance(playerData1.longitude, playerData1.latitude, playerData2.longitude, playerData2.latitude);
				distanceTable[value] = tempDistance;
			else
				distanceTable[value] = -1;
			end
		else
			local playerData1;
			local playerData2;
			if key == 5 then
				playerData1 = panelInGame.GetPlayerDataByUIIndex(1);
				playerData2 = panelInGame.GetPlayerDataByUIIndex(3);
			elseif key == 6 then
				playerData1 = panelInGame.GetPlayerDataByUIIndex(0);
				playerData2 = panelInGame.GetPlayerDataByUIIndex(2);
			end

			if playerData1 and playerData2 then
				local tempDistance = GetDistance(playerData1.longitude, playerData1.latitude, playerData2.longitude, playerData2.latitude);
				distanceTable[value] = tempDistance;
			else
				distanceTable[value] = -1;
			end
		end
		i = i+1;
	end
	return distanceTable;
end

function this.SetPlayerInfo()
    for i = 0, 3 do
        local player = panelInGame.GetPlayerDataByUIIndex(i);
        if player then
            --头像
            coroutine.start(LoadPlayerIcon, PlayerUIObjs[panelInGame.GetUIIndexBySeat(player.seat)].HeadImage:GetComponent('UITexture'), player.icon);
            --名字
            PlayerUIObjs[panelInGame.GetUIIndexBySeat(player.seat)].Name:GetComponent("UILabel").text = player.name;
            --id
            PlayerUIObjs[panelInGame.GetUIIndexBySeat(player.seat)].ID:GetComponent("UILabel").text = player.id;
        end
    end
end

function this.OnClickMask(go)
    PanelManager.Instance:HideWindow(gameObject.name)
end