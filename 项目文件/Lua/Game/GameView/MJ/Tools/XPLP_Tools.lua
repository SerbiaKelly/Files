XPLP_Tools = {};
local this = XPLP_Tools;
local baseScale = 1.2;
local baseGridHandHorizontalMove = 80;
local baseGridVerticalMove = 17;
local baseGridMoHorizontalMove = 130;
local baseGridMoVerticalMove = 17;
local baseRatio = 2.1;

local countDownCor = nil;

--倒计时
--请注意 startTime>=endTime
function this.CountDown(timeLabel,startTime,endTime)
   
    if not timeLabel or (startTime < endTime) then 
        print("bad argument in CountDown");
        return;
    end

    local countTime = startTime;
    timeLabel:GetComponent("UILabel").text = (startTime - endTime);
    -- body
    if countDownCor then 
        coroutine.stop(countDownCor);
        countDownCor = nil;
    end
    local currenTime = Time.realtimeSinceStartup;
    local finalTime = currenTime + (startTime-endTime);
    countDownCor = coroutine.start(function()
        while Time.realtimeSinceStartup < finalTime + 1 do
            timeLabel:GetComponent("UILabel").text = string.format('%02d', math.ceil(finalTime - Time.realtimeSinceStartup));
            coroutine.wait(0.05);
        end
    end);
    
end

--停止计时
function this.StopCount(timeLabel)
    if not timeLabel then 
        print("bad argument in StopCount");
        return ;
    end
    if countDownCor then 
        coroutine.stop(countDownCor);
        timeLabel:GetComponent("UILabel").text = string.format('%02d', 0);
        countDownCor = nil;
    end
end

--刷新房间解散的剩余时间（创建房间要是没有玩家进来的花，会在规定的时间内解散）
function this.RefreshRoomRestTime(time,funPerSecond,funComplete)
    local currenTime = Time.realtimeSinceStartup;
    local finalTime = currenTime + time;
    if time <= 0 then 
        funComplete();
        return;
    end
    local restCor = coroutine.start(function()
        local count = time;
        while Time.realtimeSinceStartup < finalTime + 1 do
            local tempCount = math.ceil(finalTime - Time.realtimeSinceStartup);
            if count - tempCount == 1 then 
                if funPerSecond ~= nil then 
                    funPerSecond(count);
                    count = tempCount;
                end
            end
            coroutine.wait(0.05);
        end
        funComplete();
    end);
    return restCor;
end



--判断是否需要自适应
function this.IfNeedAutoLayOut()
    return PlatformManager.Instance.isIphoneX or PlatformManager.Instance.isIphoneXSMAX or UnityEngine.Screen.width/UnityEngine.Screen.height>1.9;
end

--获得当前分辨率跟基础分辨率的比
function this.GetRatioToBase()
    return UnityEngine.Screen.width/UnityEngine.Screen.height/baseRatio;
end

function this.ExchangeGridHandPos(origionGridHandPos)
end
local plate_CH_Table = {
[0 ] = "一万",        
[1 ] = "两万",        
[2 ] = "三万",        
[3 ] = "四万",        
[4 ] = "五万",        
[5 ] = "六万",        
[6 ] = "七万",        
[7 ] = "八万",        
[8 ] = "九万",        
[9 ] = "一筒",        
[10] = "两筒",        
[11] = "三筒",        
[12] = "四筒",        
[13] = "五筒",        
[14] = "六筒",        
[15] = "七筒",        
[16] = "八筒",        
[17] = "九筒",        
[18] = "一条",        
[19] = "两条",        
[20] = "三条",        
[21] = "四条",        
[22] = "五条",        
[23] = "六条",        
[24] = "七条",        
[25] = "八条",        
[26] = "九条",        
[27] = "老钱",        
[28] = "飘花",        
[29] = "牛婆", 
}       

--获得对应牌面的中文字符出
function this.GetPlateCHString(plate)
    if plate > 29 or plate < 0 then 
        print("bad plate in GetPlateCHString");
        return "bad plate";
    end
    return plate_CH_Table[plate];
end



--对吃牌的喜牌，被吃的牌要放在最前面
function this.SortOperationCards(operationCards)
    if operationCards == nil then 
        return;
    end

    for i=1,#operationCards do
        if operationCards[i].operation ==  xplp_pb.SORT_CHI then 
            local tempPlate = operationCards[i].cards[2];
            operationCards[i].cards[2] = operationCards[i].cards[1];
            operationCards[i].cards[1] = tempPlate;
        end
    end
end


