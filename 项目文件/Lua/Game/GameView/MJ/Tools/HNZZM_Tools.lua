HNZZM_Tools = {};
local this = HNZZM_Tools;
local baseScale = 1.2;
local baseGridHandHorizontalMove = 80;
local baseGridVerticalMove = 17;
local baseGridMoHorizontalMove = 130;
local baseGridMoVerticalMove = 17;
local baseRatio = 2.1;

local countDownCor = nil;
local huResultTable = {};
--划水麻将
huResultTable[1] = {name = "基础分",    str = "+"};
huResultTable[2] = {name = "基础分",    str = "+"};
huResultTable[3] = {name = "抢杠胡",    str = "x"};
huResultTable[4] = {name = "杠上开花",  str = "x"};
huResultTable[5] = {name = "七对",      str = "x"};
huResultTable[6] = {name = "豪华七对", str = "x"};
huResultTable[7] = {name = "双豪华七对", str = "x"};
huResultTable[8] = {name = "三豪华七对", str = "x"};

huResultTable[9] = {name = "过路杠", str = ""};
huResultTable[10] = {name = "点杠分", str = ""};
huResultTable[11] = {name = "暗杠分", str = ""};
huResultTable[12] = {name = "荒庄", str = "x"};
huResultTable[13] = {name = "平胡", str = "x"};
--郑州麻将
huResultTable[31] = {name = "基础分",    str = "+"};
huResultTable[32] = {name = "基础分",    str = "+"};
huResultTable[33] = {name = "抢杠胡",    str = "x"};
huResultTable[34] = {name = "杠上开花",  str = "x"};
huResultTable[35] = {name = "七对",      str = "x"};
huResultTable[36] = {name = "豪华七对", str = "x"};
huResultTable[37] = {name = "双豪华七对", str = "x"};
huResultTable[38] = {name = "三豪华七对", str = "x"};

huResultTable[39] = {name = "回头杠", str = ""};
huResultTable[40] = {name = "点杠分", str = ""};
huResultTable[41] = {name = "暗杠分", str = ""};
huResultTable[42] = {name = "荒庄", str = "x"};
huResultTable[43] = {name = "平胡", str = "x"};
huResultTable[44] = {name = "四混加倍", str = "x"};
huResultTable[45] = {name = "八混加倍", str = "x"};

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

--获得麻将胡牌的结果字符串
function this.GetMJWinResult( huScoreResult )
    -- return "测试名堂，还未具体实现"
    if not huScoreResult then 
        print("bad argument in GetMJWinResult");
        return ;
    end
    local resultText = "";
    for i=1,#huScoreResult do
        if  huScoreResult[i].name == 9 or 
            huScoreResult[i].name == 10 or 
            huScoreResult[i].name == 11 or 
            huScoreResult[i].name == 39 or 
            huScoreResult[i].name == 40 or 
            huScoreResult[i].name == 41 then 

            resultText = resultText..huResultTable[huScoreResult[i].name].name..(huScoreResult[i].value >= 0 and ("+"..huScoreResult[i].value) or huScoreResult[i].value )..(i < #huScoreResult and "," or "");
        else
            resultText = resultText..huResultTable[huScoreResult[i].name].name..huResultTable[huScoreResult[i].name].str..huScoreResult[i].value..(i < #huScoreResult and "," or "");
        end 
        
    end
    return resultText;
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



