StateAction = {}

function StateAction:New(enter, update, leave)
    self.__index = self
    local o = setmetatable({}, self)
    o._enter = enter;
    o._update = update;
    o._leave = leave;
    return o;
end

function StateAction:Enter(customData)
    if self._enter then
        self._enter(customData)
    end
end

function StateAction:Update(deltaTime)
    if self._update then
        self._update(deltaTime)
    end
end

function StateAction:Leave()
    if self._leave then
        self._leave()
    end
end

return StateAction