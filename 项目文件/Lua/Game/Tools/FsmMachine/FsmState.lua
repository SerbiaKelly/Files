require("StateAction")

FsmState = {}

FsmState.Status = {
    None = 0;
    Initialization = 1;
    Running = 2;
    Completed = 4;
}

function FsmState:New(name, enter, update, leave)
    self.__index = self
    local o = setmetatable({}, self)
    o.name = name;
    o.action = StateAction:New(enter, update, leave)
    o.status = FsmState.Status.None
    return o;
end

function FsmState:Enter(customData)
    self.status = FsmState.Status.Initialization;

    self.action:Enter(customData)

    self.Status = FsmState.Status.Running;
end

function FsmState:Update(deltaTime)
    self.action:Update(deltaTime)
end

function FsmState:Leave()
    self.action:Leave()

    self.status = FsmState.Status.Completed;
end

return FsmState