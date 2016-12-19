--
-- Created by IntelliJ IDEA.
-- User: bigfo
-- Date: 09.12.2016
-- Time: 22:54
-- To change this template use File | Settings | File Templates.
--

local BaseGlobalEvent = Class(function(self, data)
    self.name = data.name
    self.segsMin = data.segsMin
    self.segsMax = data.segsMax
    self.timeTotal = 0
    self.timeToEventOut = 0;
    self.defs = data.defs or {}
    --if type(data) == 'function'
end)

function BaseGlobalEvent:CalculateEventDuration()
    local eventSegs = math.random(self.segsMin, self.segsMax)

    self.timeTotal = eventSegs * TUNING.SEG_TIME
    self.timeToEventOut = self.timeTotal
end

function BaseGlobalEvent:OnStart()
    self:CalculateEventDuration()
end

function BaseGlobalEvent:GetCompletePercentage()
    return 100 - math.floor((self.timeToEventOut / self.timeTotal) * 100)
end

function BaseGlobalEvent:GetStagePercentage()
end


function BaseGlobalEvent:OnStop()
end

function BaseGlobalEvent:UpdateTime(dt)
    self.timeToEventOut = self.timeToEventOut - dt
end

function BaseGlobalEvent:OnUpdate(dt)
    self:UpdateTime(dt)
end

function BaseGlobalEvent:CheckConditions()
    return false
end


function BaseGlobalEvent:IsOut()
    return (self.timeToEventOut < 0)
end

function BaseGlobalEvent:Dump()
    local keys = sortedKeys(self.defs)
    local t = {}
    for i, key in ipairs(keys) do
        t[i] = string.format("\t%s\t%s", key, tostring(self.defs[key]))
    end
    return table.concat(t, '\n')
end

function BaseGlobalEvent:GetDebugString()
    print("")
    print("//======================== DUMPING EVENT STATE ========================\\\\")
    print("\n" .. self:Dump())
    print("\\\\=====================================================================//")
    print("")
end

return BaseGlobalEvent