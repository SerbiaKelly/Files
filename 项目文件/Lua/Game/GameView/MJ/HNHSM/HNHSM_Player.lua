require("PlayerViewBase");
require("stringTool");
local hnm_pb = require("hnm_pb");


HNHSM_Player = class(PlayerViewBase);


function HNHSM_Player:ctor(playerObj,inGameObj)
    -- print("child---->playerObj:"..tostring(playerObj).."|inGameObj:"..tostring(inGameObj));
    self.fish = playerObj.transform:Find("Fish");
end

function HNHSM_Player:ResetView( data )
    -- print("ResetView---------------------------->");
    self.super.ResetView(self, data)
    self:SetMaster(self.logic.roomData.bankerSeat == data.seat and self.logic.roomData.state == hnm_pb.GAMING)--庄家
    if self.logic.roomData.state == hnm_pb.READYING then
        self:SetReady(data.ready);
    end
    self:SetFish(data.yuScore);
end

function HNHSM_Player:SetFish(number)
    if number == nil or number == 0 then 
        self.fish:GetComponent("UILabel").text = "";
        return ;
    end
    self.fish:GetComponent("UILabel").text = "抓"..number.."条鱼";
end

function HNHSM_Player:SetMJGridTool(hnhsm_GridTool,logic,uilayer)
    self.hnhsm_GridTool = hnhsm_GridTool;
    self.logic          = logic;
    self.uilayer        = uilayer;
end

--设置人物头像在准备状态和游戏状态中不同的位置
function HNHSM_Player:SetPos(isInReadyState)
    if self.hnhsm_GridTool then 
        if isInReadyState then 
            if self.hnhsm_GridTool.posIndex == 0 then 
                self.gameObject.transform.localPosition = Vector3.New(0,-119,0);
            elseif self.hnhsm_GridTool.posIndex == 1 then 
                self.gameObject.transform.localPosition = Vector3.New(395,55,0);
            elseif self.hnhsm_GridTool.posIndex == 2 then 
                self.gameObject.transform.localPosition = Vector3.New(0,271,0);
            else
                self.gameObject.transform.localPosition = Vector3.New(-393,55,0)
            end
        else
            if self.hnhsm_GridTool.posIndex == 0 then 
                self.gameObject.transform.localPosition = HNHSM_Tools.IfNeedAutoLayOut() and  Vector3(-697,-130,0) or Vector3.New(-611,-168,0);
            elseif self.hnhsm_GridTool.posIndex == 1 then 
                self.gameObject.transform.localPosition =  HNHSM_Tools.IfNeedAutoLayOut() and Vector3(697,180,0) or Vector3.New(610,180,0);
            elseif self.hnhsm_GridTool.posIndex == 2 then 
                self.gameObject.transform.localPosition = Vector3.New(316.8,298.1,0);
            else
                self.gameObject.transform.localPosition = HNHSM_Tools.IfNeedAutoLayOut() and Vector3(-697,177.5,0)  or Vector3.New(-611,177.5,0);
            end
        end
    end
end


--根据房间人数多少，把不用的玩家UI隐藏起来
function HNHSM_Player:NeedHideSelf(roomSize)
    if roomSize == 2 then --两个人的房间
        if self.hnhsm_GridTool.posIndex == 0 or self.hnhsm_GridTool.posIndex == 2 then 
            self:OpenView();
        else
            self:CloseView();
        end
    elseif roomSize == 3 then --三个人的房间
        if self.hnhsm_GridTool.posIndex == 2 then 
            self.gameObject:SetActive(false);
        else
            self.gameObject:SetActive(true);
        end
    elseif roomSize == 4 then --四个人的房间
        self.gameObject:SetActive(true);
    end
end





function HNHSM_Player:OnRefreshTime(time)
    local timeStr =  os.date("%M:%S", time);
    if self.timeLabel == nil then
        self.timeLabel = self.offineFlag.transform:Find("Time")
    end
    self.timeLabel:GetComponent("UILabel").text = timeStr
end

function HNHSM_Player:SetActiveFlag(enable)
    self.super.SetActiveFlag(self, enable)
  
end

function HNHSM_Player:CleanView()
    self.super.CleanView(self);
    self:ResetGameState();
   
end



function HNHSM_Player:CloseView()
    self.super.CloseView(self);
    self:ResetGameState();
end

function HNHSM_Player:ResetRoundStartState()
    self:SetReady(false)
    self:UpdateScore(0)
end

function HNHSM_Player:ResetGameState()
    self:SetMaster(false)
    self:SetActiveFlag(false)
    self:SetFish(0);
    -- CloseChild(self.flags)
end