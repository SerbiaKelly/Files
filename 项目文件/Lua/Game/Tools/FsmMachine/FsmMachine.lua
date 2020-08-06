require("FsmState")

FsmMachine = {}
function FsmMachine:New()
    self.__index = self
    local o = setmetatable({}, self)
    o.states = {}
    o.curState = nil
    return o;
end

function FsmMachine:AddState(state)
    self.states[state.name] = state
end

function FsmMachine:Add(name, enter, update, leave)
    self.states[name] = FsmState:New(name, enter, update, leave)
end

function FsmMachine:Update(deltaTime)
    if self.curState == nil then
        return
    end

    self.curState.Update(deltaTime)
end

function FsmMachine:Switch(name, ...)
    local newState = self.states[name]

    if newState == nil then
        return
    end

    if self.curState ~= nil then
        self.curState:Leave();
    end
    
    newState:Enter(...)
    self.curState = newState;
end

function FsmMachine:Shutdown()
    if self.curState == nil then
        return;
    end

    self.curState.Leave()

    self.curState = nil
end

return FsmMachine

