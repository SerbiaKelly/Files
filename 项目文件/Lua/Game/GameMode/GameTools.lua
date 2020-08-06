function StartTrusteeshipVerification(time, downTimeAction, completedAction)
    local showDelayTime = 10
    local delayTime = time - showDelayTime;
    local doweTime = delayTime < 0 and time or showDelayTime
    local trusteeshipCoroutine = coroutine.start(function() 
        if time <= 0 then
            completedAction()
            return
        end
        coroutine.wait(delayTime)
        for i=doweTime, 1, -1 do
            if downTimeAction ~= nil then
                 downTimeAction(i) 
            end
            coroutine.wait(1)
        end	
        completedAction()
    end)
    return trusteeshipCoroutine
end

function StopTrusteeshipVerification(trusteeshipCoroutine)
    if trusteeshipCoroutine ~= nil then
        coroutine.stop(trusteeshipCoroutine)
        trusteeshipCoroutine = nil
    end
end