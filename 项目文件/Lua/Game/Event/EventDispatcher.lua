--EventDispatcher.lua
local EventDispatcher = {}
EventDispatcher.__index = EventDispatcher
function EventDispatcher:New()
    local store = nil

    local creat = function (self)
        if store then return store end
        local o =  {}
        setmetatable(o, self)
        self.__index = self
        store = o
        self.m_listeners = {}
        return o
    end

    return creat(EventDispatcher)
end

EventDispatcher.Instance = EventDispatcher:New()

function EventDispatcher:AddEvent(name,listener)
    -- 先看看事件是否存在
    local index = 1
    if self.m_listeners[name] == nil then
        self.m_listeners[name] = {}
    else
        local existIndex = self:getEventIndex(name,listener)
        if existIndex ~= -1 then
            return
        end
        index = #self.m_listeners[name] + 1
    end
    self.m_listeners[name][index] = listener
end

function EventDispatcher:RemoveEvent(name,listener)
    if self.m_listeners[name] == nil then
        return
    end
    local existIndex = self:getEventIndex(name,listener)
    if existIndex == -1 then return end
    table.remove(self.m_listeners[name],existIndex)
end

function EventDispatcher:RemoveAllEvent(name)
    if self.m_listeners[name] == nil then
        return
    end
    self.m_listeners[name] = nil
end

function EventDispatcher:DispatchEvent(name,...)
    if self.m_listeners[name] == nil then
        return
    end
    
    print('派发事件：'..tostring(name))
    for k,v in pairs(self.m_listeners[name]) do
        v(...)
    end    
end

function EventDispatcher:getEventIndex(name,listener)
    if self.m_listeners[name] == nil then
        return -1
    end
    for i=1,#self.m_listeners[name] do
        if self.m_listeners[name][i] == listener then
            return i
        end
    end
    return -1
end

return EventDispatcher