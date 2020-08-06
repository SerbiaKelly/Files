Line = class()
function Line:ctor( ... )
    self.index = 0
    self.activeCount = 0
    self.members = {}
end

function Line:SetIndex(index)
    self.index = index
end

function Line:GetIndex()
    return self.index
end

function Line:SetActiveCount(count)
    self.activeCount = count
end

function Line:GetActiveCount()
    return self.activeCount
end

function Line:GetIndex(index)
    return  self.index
end

function Line:AddMember(member)
    table.insert(self.members, member)
end

function Line:MemberCount()
    return #self.members
end

function Line:GetMember(index)
    return self.members[index]
end