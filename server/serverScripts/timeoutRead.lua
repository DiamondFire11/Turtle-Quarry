---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Duster.
--- DateTime: 10/30/2012 11:33 AM
---

local function timedRead(time)
    result = nil
    a = coroutine.wrap(function() result=read() os.queueEvent('timer') end)
    local events ={}
    os.startTimer(time)
    while true do
        a(unpack(events))
        events = {os.pullEvent()}
        if events[1] == 'timer' then
            break
        end
    end
    return result
end