require("PlayerViewBase");
require("stringTool");
local dzm_pb = require("dzm_pb");
DZAHM_Player = {};
DZAHM_Player = class(PlayerViewBase);


function DZAHM_Player:ctor(playerObj,inGameObj)
    -- print("child---->playerObj:"..tostring(playerObj).."|inGameObj:"..tostring(inGameObj));
    self.piaofen = playerObj.transform:Find("piaofen");
    self.playerGameMsg = playerObj.transform:Find("gameMsg");
end

function DZAHM_Player:ResetView( data )
    -- print("ResetView---------------------------->");
    self.super.ResetView(self, data)
    self:SetMaster(self.logic.roomData.bankerSeat == data.seat and self.logic.roomData.state == dzm_pb.GAMING)--庄家
    if self.logic.roomData.state == dzm_pb.READYING then
        self:SetReady(data.ready);
    end
    self:SetPiaofen(data.piaoScore)
    
end



function DZAHM_Player:SetMJGridTool(dzahm_GridTool,logic,uilayer)
    self.dzahm_GridTool = dzahm_GridTool;
    self.logic          = logic;
    self.uilayer        = uilayer;
end

--设置人物头像在准备状态和游戏状态中不同的位置
function DZAHM_Player:SetPos(isInReadyState)
    if self.dzahm_GridTool then 
        if isInReadyState then 
            if self.dzahm_GridTool.posIndex == 0 then 
                self.gameObject.transform.localPosition = Vector3.New(0,-119,0);
            elseif self.dzahm_GridTool.posIndex == 1 then 
                self.gameObject.transform.localPosition = Vector3.New(395,55,0);
            elseif self.dzahm_GridTool.posIndex == 2 then 
                self.gameObject.transform.localPosition = Vector3.New(0,271,0);
            else
                self.gameObject.transform.localPosition = Vector3.New(-393,55,0)
            end
        else
            if self.dzahm_GridTool.posIndex == 0 then 
                self.gameObject.transform.localPosition = DZAHM_Tools.IfNeedAutoLayOut() and  Vector3(-697,-130,0) or Vector3.New(-611,-168,0);
            elseif self.dzahm_GridTool.posIndex == 1 then 
                self.gameObject.transform.localPosition =  DZAHM_Tools.IfNeedAutoLayOut() and Vector3(697,180,0) or Vector3.New(610,180,0);
            elseif self.dzahm_GridTool.posIndex == 2 then 
                self.gameObject.transform.localPosition = Vector3.New(316.8,298.1,0);
            else
                self.gameObject.transform.localPosition = DZAHM_Tools.IfNeedAutoLayOut() and Vector3(-697,177.5,0)  or Vector3.New(-611,177.5,0);
            end
        end
    end
end


--根据房间人数多少，把不用的玩家UI隐藏起来
function DZAHM_Player:NeedHideSelf(roomSize)
    if roomSize == 2 then --两个人的房间
        if self.dzahm_GridTool.posIndex == 0 or self.dzahm_GridTool.posIndex == 2 then 
            self:OpenView();
        else
            self:CloseView();
        end
    elseif roomSize == 3 then --三个人的房间
        if self.dzahm_GridTool.posIndex == 2 then 
            self.gameObject:SetActive(false);
        else
            self.gameObject:SetActive(true);
        end
    elseif roomSize == 4 then --四个人的房间
        self.gameObject:SetActive(true);
    end
end





function DZAHM_Player:OnRefreshTime(time)
    local timeStr =  os.date("%M:%S", time);
    if self.timeLabel == nil then
        self.timeLabel = self.offineFlag.transform:Find("Time")
    end
    self.timeLabel:GetComponent("UILabel").text = timeStr
end

function DZAHM_Player:SetActiveFlag(enable)
    self.super.SetActiveFlag(self, enable)
  
end

function DZAHM_Player:CleanView()
    self.super.CleanView(self);
    self:ResetGameState();
   
end



function DZAHM_Player:CloseView()
    self.super.CloseView(self);
    self:ResetGameState();
end

function DZAHM_Player:ResetRoundStartState()
    self:SetReady(false)
    self:UpdateScore(0)
    self:SetPiaofen(0);
end

function DZAHM_Player:ResetGameState()
    self:SetMaster(false)
    self:SetActiveFlag(false)
    self:SetPiaofen(0);
    -- CloseChild(self.flags)
end


--设置玩家的飘分
function DZAHM_Player:SetPiaofen(piaofen)
    if piaofen == nil  or piaofen == -1 then ---1:表示未操作飘分
        self.piaofen:GetComponent("UILabel").text = "";
        return;
    elseif piaofen == 0 then
        self.piaofen:GetComponent("UILabel").text = "不飘分";
    else
        self.piaofen:GetComponent("UILabel").text = "飘"..piaofen .. "分";
    end
end