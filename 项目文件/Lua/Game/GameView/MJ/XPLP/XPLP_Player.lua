-- require("class");
require("PlayerViewBase");
require("stringTool");
local xplp_pb = require("xplp_pb");


XPLP_Player = class(PlayerViewBase);


function XPLP_Player:ctor(playerObj,inGameObj)
    -- print("child---->playerObj:"..tostring(playerObj).."|inGameObj:"..tostring(inGameObj));
    self.playerObj  = playerObj;
    self.guChou     = playerObj.transform:Find("GameState/guChou"); --箍臭
    self.chong      = playerObj.transform:Find("chong");            --冲分
    self.restCards  = playerObj.transform:Find("restCards");        --剩余牌
end

function XPLP_Player:ResetView( data )
    self.super.ResetView(self, data)
    self:SetMaster(self.logic.roomData.bankerSeat == data.seat and self.logic.roomData.state == xplp_pb.GAMING)--庄家
    if self.restCards then 
        self.restCards.gameObject:SetActive(self.logic.roomData.state == xplp_pb.GAMING);
    end
    -- print("aa"..nulldd);
    if self.logic.roomData.state == xplp_pb.READYING then
        self:SetReady(data.ready);
    end
    -- print("name："..data.name..",guChou="..tostring(data.guChou == 1));
    -- 设置箍臭
    self:SetPlayerGuChou(data.guChou == 1);
    -- 设置剩余牌
    self:SetRestCards(data.mahjongCount)
    -- 设置冲分
    self:SetPlayerChong(data.choiceRoundScore);
end


function XPLP_Player:SetMJGridTool(xplp_GridTool,logic,uilayer)
    self.xplp_GridTool  = xplp_GridTool;
    self.logic          = logic;
    self.uilayer        = uilayer;
    
end

--设置人物头像在准备状态和游戏状态中不同的位置
function XPLP_Player:SetPos(isInReadyState)
    if self.xplp_GridTool then 
        if isInReadyState then 
            if self.xplp_GridTool.posIndex == 0 then 
                self.gameObject.transform.localPosition = Vector3.New(0,-119,0);
            elseif self.xplp_GridTool.posIndex == 1 then 
                self.gameObject.transform.localPosition = Vector3.New(395,55,0);
            elseif self.xplp_GridTool.posIndex == 2 then 
                self.gameObject.transform.localPosition = Vector3.New(0,271,0);
            else
                self.gameObject.transform.localPosition = Vector3.New(-393,55,0)
            end
        else
            if self.xplp_GridTool.posIndex == 0 then 
                self.gameObject.transform.localPosition = XPLP_Tools.IfNeedAutoLayOut() and  Vector3(-697,-304,0) or Vector3.New(-611,-304,0);
            elseif self.xplp_GridTool.posIndex == 1 then 
                self.gameObject.transform.localPosition =  XPLP_Tools.IfNeedAutoLayOut() and Vector3(697,215,0) or Vector3.New(610,215,0);
            elseif self.xplp_GridTool.posIndex == 2 then 
                self.gameObject.transform.localPosition = Vector3.New(150,298,0);
            else
                self.gameObject.transform.localPosition = XPLP_Tools.IfNeedAutoLayOut() and Vector3(-697,217.3,0)  or Vector3.New(-611,217.3,0);
            end
        end
    end
end

--设置玩家是否箍臭
function XPLP_Player:SetPlayerGuChou(enable)
    self.guChou.gameObject:SetActive(enable);
end

--设置冲分
function XPLP_Player:SetPlayerChong(chongNum)
    if chongNum < 0 then 
        self.chong.gameObject:SetActive(false);
        return;
    end
    self.chong.gameObject:SetActive(true);
    self.chong:GetComponent("UILabel").text = "冲"..chongNum;
end

--设置剩余牌
function XPLP_Player:SetRestCards(restCardNum)
    if self.restCards then 
        self.restCards:Find("restLabel"):GetComponent("UILabel").text = restCardNum;
    end
end

--根据房间人数多少，把不用的玩家UI隐藏起来
function XPLP_Player:NeedHideSelf(roomSize)
    if roomSize == 2 then --两个人的房间
        if self.xplp_GridTool.posIndex == 0 or self.xplp_GridTool.posIndex == 2 then 
            self:OpenView();
        else
            self:CloseView();
        end
    elseif roomSize == 3 then --三个人的房间
        if self.xplp_GridTool.posIndex == 2 then 
            self.gameObject:SetActive(false);
        else
            self.gameObject:SetActive(true);
        end
    elseif roomSize == 4 then --四个人的房间
        self.gameObject:SetActive(true);
    end
end





function XPLP_Player:OnRefreshTime(time)
    local timeStr =  os.date("%M:%S", time);
    if self.timeLabel == nil then
        self.timeLabel = self.offineFlag.transform:Find("Time")
    end
    self.timeLabel:GetComponent("UILabel").text = timeStr
end

function XPLP_Player:SetActiveFlag(enable)
    self.super.SetActiveFlag(self, enable)
  
end

function XPLP_Player:CleanView()
    self.super.CleanView(self);
    self:ResetGameState();
end







function XPLP_Player:CloseView()
    self.super.CloseView(self);
    self:ResetGameState();
end

function XPLP_Player:ResetRoundStartState()
    self:SetReady(false)
    self:UpdateScore(0)
end

function XPLP_Player:ResetGameState()
    self:SetMaster(false)
    self:SetActiveFlag(false)
    if self.restCards then 
        self.restCards.gameObject:SetActive(false);
        self.restCards:Find("restLabel"):GetComponent("UILabel").text = "";
    end
    -- 设置箍臭
    self:SetPlayerGuChou(false);
    -- 设置剩余牌
    -- 设置冲分
    self.chong:GetComponent("UILabel").text = ""
end