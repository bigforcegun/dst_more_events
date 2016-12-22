--
-- Created by IntelliJ IDEA.
-- User: bigfo
-- Date: 13.12.2016
-- Time: 17:01
-- To change this template use File | Settings | File Templates.
--
require("utils/utils_events")

local BaseStoryTeller = require "storytellers/base"

return Class(BaseStoryTeller, function(self, inst)
    self.name = 'Simple And Dumb story Teller'
    local timeToNextThreat = 0
    local currentThreats = {}

    local threatDelays =
    {
        rare = function()
            return TUNING.TOTAL_DAY_TIME * 6, math.random() * TUNING.TOTAL_DAY_TIME * 7
        end,
        occasional = function()
            return TUNING.TOTAL_DAY_TIME * 4, math.random() * TUNING.TOTAL_DAY_TIME * 7
        end,
        frequent = function()
            return TUNING.TOTAL_DAY_TIME * 3, math.random() * TUNING.TOTAL_DAY_TIME * 5
        end,
    }

    local threatDelayFn = threatDelays.occasional


    local function CalcComplexityLevel()
        local day = self:GetAveragePlayerAgeInDays()
        if day < 10 then
            threatDelayFn = threatDelays.rare
        elseif day < 25 then
            threatDelayFn = threatDelays.rare
        elseif day < 50 then
            threatDelayFn = threatDelays.occasional
        elseif day < 100 then
            threatDelayFn = threatDelays.occasional
        else
            threatDelayFn = threatDelays.frequent
        end
    end

    local function PlanNextRegualThreat()
        if timeToNextThreat > 0 then
            return
        end
        local timetoattackbase, timetoattackvariance = threatDelayFn()
        timeToNextThreat = timetoattackbase + timetoattackvariance
    end



    function self:SubscribeThreatsAtEvents()
        for threatId, threat in pairs(GetEventsThreats()) do
            threat:Subscribe(inst, self, threatId)
        end
    end

    function self:StartRandomRegualarThreat()
        --local eventId = "temperature"
        --eventId = "solar_eclipse"
        --local newEvent = GetRandomThreatById(eventId)
        --c_announce("STARTING EVENT " .. eventId)
        --currentEvents[eventId] = newEvent
        --currentEvents[eventId]:OnStart()
    end

    function self:StartThreat(threat_id)
        local threat = GetThreatById(threat_id)
        c_announce("STARTING THREAT " .. threat_id)
        currentThreats[threat_id] = threat
        currentThreats[threat_id]:OnStart()
    end

    function self:GetCurrentThreats()
        return currentThreats
    end

    function self:TryStartThreat(threat_id, force)
        force = force or false
        local threat = GetThreatById(threat_id)
        -- Chain of if
        -- Made specifically for the simplification
        if force then
            self:StartThreat(threat_id)
        else
            if threat:CheckConditions() then
                if threat:CheckChance() then
                    if not self:CurrentThreatsHasTag(threat:GetTag()) then
                        self:StartThreat(threat_id)
                    end
                end
            end
        end
    end

    function self:OnSubscription(threat_id)
        --self:StartThreat(threat_id)
        self:TryStartThreat(threat_id)
    end

    function self:CurrentThreatsHasTag(tag)
        local res = false;
        -- TODO - see lua return in foreach
        for threatId, threat in pairs(self:GetCurrentThreats()) do
            if threat:HasTag(tag) then res = true end
        end
        return res
    end

    function self:StopThreat(threatId)
        c_announce("STOPPING THREAT " .. threatId)
        local threat = GetThreatById(threatId)
        if threat ~= nil then
            threat:OnStop()
            currentThreats[threatId] = nil
        end

    end

    function self:StopAllThreats()
        for threatId, threat in pairs(self:GetCurrentThreats()) do
            self:StopThreat(threatId)
        end
    end

    function self:UpdateCurrentThreats(dt)
        for threatId, threat in pairs(self:GetCurrentThreats()) do
            if threat ~= nil then
                threat:OnUpdate(dt)
                if threat:IsOut() then
                    self:StopThreat(threatId)
                end
            end
        end
    end

    function self:OnUpdate(dt)
        --print(timeToNextEvent)
        -- print("TEST" .. tostring(dt))
        timeToNextThreat = timeToNextThreat - dt
        if timeToNextThreat < 0 then
            self:StartRandomRegualarThreat();
            PlanNextRegualThreat()
        end

        self:UpdateCurrentThreats(dt)
    end

    function self:Init()
        self:SubscribeThreatsAtEvents()
        PlanNextRegualThreat()
    end

    function self:DumpCurrentThreats()
        for threatId, threat in pairs(self:GetCurrentThreats()) do
            if threat ~= nil then
                threat:GetDebugString()
            end
        end
    end
end)