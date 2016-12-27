local BaseThreat = Class(function(self, data)
    self.name = data.name
    self.segsMin = data.segsMin
    self.segsMax = data.segsMax
    self.timeTotal = 0
    self.timeToOut = 0;
    self.defs = data.defs or {}
    self.chance = .50
    self.tag = 'threat'
    self.isRegular = true
    --if type(data) == 'function'
end)

function BaseThreat:CalculateDuration()
    local threatSegs = math.random(self.segsMin, self.segsMax)
    self.timeTotal = threatSegs * TUNING.SEG_TIME
    self.timeToOut = self.timeTotal
end

function BaseThreat:CalculateDefinitions()
   -- self.defs = {}
end

function BaseThreat:OnStart()
    -- Stub for override
end

function BaseThreat:OnStop()
    -- Stub for override
end

---
--
function BaseThreat:Start()
    self:CalculateDuration()
    self:CalculateDefinitions()
    return self:OnStart()
end

function BaseThreat:Stop(force)
    force = force or false
    return self:OnStop(force)
end



function BaseThreat:GetCompletePercentage()
    return 100 - math.floor((self.timeToOut / self.timeTotal) * 100)
end

function BaseThreat:GetStagePercentage()
end



function BaseThreat:UpdateTime(dt)
    self.timeToOut = self.timeToOut - dt
end

function BaseThreat:OnUpdate(dt)
    self:UpdateTime(dt)
end


function BaseThreat:CheckConditions()
    return true
end

function BaseThreat:GetChance()
    return self.chance
end

function BaseThreat:IsPositive()
    if self.defs and self.defs.isPositive ~= nil then
        return self.defs.isPositive
    end
    return false
end

function BaseThreat:IsNegative()
    return not self:IsPositive()
end

function BaseThreat:CheckChance()
    --[[
    local  d_c = math.random()
    local res = (math.random() < self.chance)
    c_announce(self.chance)
    if res then c_announce('true') else c_announce('false') end
    return res
    ]]
    return (math.random() < self:GetChance())
end

function BaseThreat:GetTag()
    return self.tag
end

function BaseThreat:HasTag(tag)
    return (self.tag == tag)
end

function BaseThreat:IsOut()
    return (self.timeToOut < 0)
end

function BaseThreat:IsRegular()
    return self.isRegular
end

function BaseThreat:IsEvent()
    return not self:IsRegular()
end


function BaseThreat:Dump()
    local keys = sortedKeys(self.defs)
    local t = {}
    for i, key in ipairs(keys) do
        t[i] = string.format("\t%s\t%s", key, tostring(self.defs[key]))
    end
    return table.concat(t, '\n')
end

function BaseThreat:GetDebugString()
    print("")
    print("//======================== DUMPING THREAT STATE ========================\\\\")
    print("\n" .. self:Dump())
    print("\\\\=====================================================================//")
    print("")
end

return BaseThreat