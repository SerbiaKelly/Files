require("class")
GPSTool = class();
function GPSTool:ctor(logic,roomData,distanceUITable,playerUITable)
    -- print("distanceUITable")
    -- print_r(distanceUITable)
    -- print("playerUITable")
    -- print_r(playerUITable)
    self.logic              = logic;
    self.roomData           = roomData;
    self.distanceUITable    = distanceUITable;
    self.playerUITable      = playerUITable;
end

function GPSTool:Refresh(logic,roomData)
    self.roomData = roomData;
    self.logic = logic;
    self:SetGPSUI(self.roomData.setting.size);
    self:SetDistance(self:GetDistance(self.roomData.setting.size));
end

--设置距离
function GPSTool:SetDistance(distanceTable)
    if not self.roomData.setting.openGps then
        return
    end
    if self.roomData.setting.size == 2 then 
        if roomInfo.gameType ~= proxy_pb.MJ or roomInfo.gameType == proxy_pb.XPLP or roomInfo.gameType == proxy_pb.HNM or roomInfo.gameType == proxy_pb.DZM then 
            return 
        end
    end;
    for key, value in pairs(distanceTable) do
        --print("key="..key..",value:"..value);
        if value == -1 then
            --distances[key].gameObject:SetActive(false);
            self.distanceUITable[key].transform:Find("disLabel"):GetComponent("UILabel").text = "";
        else
            self.distanceUITable[key].gameObject:SetActive(true);
            self.distanceUITable[key].transform:Find("disLabel"):GetComponent("UILabel").text = value;
        end

    end
end


--根据玩的人数设置GSP的显隐
function GPSTool:SetGPSUI(playerSize)
    print("几个人的定位啊~~",playerSize)
    self:showDistanceUI(playerSize);
    self:showPlayerUI(playerSize);
    self:setPlayerInfo(playerSize);
end


function GPSTool:showDistanceUI(playerSize)
    print("showDistanceUI---------------------roomInfo.gameType:"..tostring(roomInfo.gameType));
    if roomInfo.gameType == proxy_pb.MJ or roomInfo.gameType == proxy_pb.XPLP or roomInfo.gameType == proxy_pb.HNM or roomInfo.gameType == proxy_pb.DZM then 
        for i = 1, 6 do
            self.distanceUITable[i].gameObject:SetActive(false);
        end
        if not self.roomData.setting.openGps then
            return
        end
        if playerSize == 2 then 
            --self.distanceUITable[6].gameObject:SetActive(true);
        elseif playerSize == 3 then 
            self.distanceUITable[1].gameObject:SetActive(true);
            self.distanceUITable[4].gameObject:SetActive(true);
            self.distanceUITable[5].gameObject:SetActive(true);
        elseif playerSize == 4 then 
            for i = 1, 6 do
                self.distanceUITable[i].gameObject:SetActive(true);
            end
        end
    else
        if playerSize == 2 then 
            for i = 1, 6 do
                self.distanceUITable[i].gameObject:SetActive(false);
            end
        elseif playerSize == 3 then 
            self.distanceUITable[1].gameObject:SetActive(false);
            self.distanceUITable[2].gameObject:SetActive(false);
            self.distanceUITable[5].gameObject:SetActive(false);
            self.distanceUITable[3].gameObject:SetActive(true);
            self.distanceUITable[4].gameObject:SetActive(true);
            self.distanceUITable[6].gameObject:SetActive(true);
        elseif playerSize == 4 then 
            for i = 1, 6 do
                self.distanceUITable[i].gameObject:SetActive(true);
            end
        end
    end
end

function GPSTool:showPlayerUI(playerSize)
    print("roomInfo.gameType:"..roomInfo.gameType);
    if roomInfo.gameType == proxy_pb.MJ or roomInfo.gameType == proxy_pb.XPLP or roomInfo.gameType == proxy_pb.HNM or roomInfo.gameType == proxy_pb.DZM then 
        if playerSize == 2 then 
           self.playerUITable[1].gameObject:SetActive(true);
           self.playerUITable[2].gameObject:SetActive(false);
           self.playerUITable[3].gameObject:SetActive(true);
           self.playerUITable[4].gameObject:SetActive(false);
        elseif playerSize == 3 then 
            self.playerUITable[1].gameObject:SetActive(true);
            self.playerUITable[2].gameObject:SetActive(true);
            self.playerUITable[3].gameObject:SetActive(false);
            self.playerUITable[4].gameObject:SetActive(true);
        elseif playerSize == 4 then 
            for i=1,4 do
                self.playerUITable[i].gameObject:SetActive(true);
            end
        end
    else
        if playerSize == 2 then 
            for i = 1, 4 do
                self.playerUITable[i].gameObject:SetActive(false);
            end
            self.playerUITable[1].transform.gameObject:SetActive(true);
		    self.playerUITable[2].transform.gameObject:SetActive(true);
        elseif playerSize == 3 then 
            self.playerUITable[1].gameObject:SetActive(true);
            self.playerUITable[3].gameObject:SetActive(true);
            self.playerUITable[4].gameObject:SetActive(true);
            self.playerUITable[2].gameObject:SetActive(false);
        elseif playerSize == 4 then 
            for i = 1, 4 do
                self.playerUITable[i].gameObject:SetActive(true);
            end
        end

    end
end

--设置玩家的信息
function GPSTool:setPlayerInfo(playerSize)

    function getIndex(index)
        if index == 2 then
            return 3;
        elseif index == 3 then
            return 4;
        else
            return index;
        end
    end
    if playerSize == 2 then --两个人不显示定位
    elseif playerSize == 3 then
       
        for i = 1, 3 do
            local player = self.logic:GetPlayerDataByUIIdex(i);
            local playerName =  self.playerUITable[getIndex(i)].transform:Find("Name");
            if player and playerName then
                playerName:GetComponent("UILabel").text = player.name;
            else
                if playerName then 
                    playerName:GetComponent("UILabel").text = "";
                end
            end
        end
    else
        for i = 1, 4 do
            local player =  self.logic:GetPlayerDataByUIIdex(i);
            local playerName =  self.playerUITable[getIndex(i)].transform:Find("Name");
            if player and playerName then
                playerName:GetComponent("UILabel").text = player.name;
            else
                if playerName then 
                    playerName:GetComponent("UILabel").text = "";
                end
            end
        end
    end
end

--根据玩的人数和玩家的GPS信息返回对应的距离
function GPSTool:GetDistance(playerSize)
    local keys = self:GetDistanceKey(playerSize);
   
    local i = 1;
    local distanceTable = {};
    for key, value in pairs(keys) do
        if i <= 3 then
            local playerData1 = self.logic:GetPlayerDataByUIIdex(i);
            local p2index = (i + 1) % playerSize;
            local playerData2 = self.logic:GetPlayerDataByUIIdex(p2index);

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
                playerData1 = self.logic:GetPlayerDataByUIIdex(2);
                playerData2 = self.logic:GetPlayerDataByUIIdex(4);
            elseif key == 6 then
                playerData1 = self.logic:GetPlayerDataByUIIdex(1);
                playerData2 = self.logic:GetPlayerDataByUIIdex(3);
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
    -- print("distanceTable-------------------------->");
    -- print_r(distanceTable);
    return distanceTable;
end


function GPSTool:GetDistanceKey(playerSize)
    if playerSize == 2 then
        --return {};
        return {6};
    elseif playerSize == 3 then
        if roomInfo.gameType == proxy_pb.MJ or roomInfo.gameType == proxy_pb.XPLP or roomInfo.gameType == proxy_pb.HNM or roomInfo.gameType == proxy_pb.DZM then 
            return {1,4,5}
        else
            return {6,3,4};
        end
    else
        return {1,2,3,4,5,6};
    end
end

