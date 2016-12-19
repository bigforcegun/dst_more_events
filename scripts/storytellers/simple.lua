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
    local timeToNextEvent = 0
    local currentEvents = {}

    local eventDelays =
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

    local eventDelayFn = eventDelays.occasional


    local function CalcComplexityLevel()
        local day = self:GetAveragePlayerAgeInDays()
        if day < 10 then
            eventDelayFn = eventDelays.rare
        elseif day < 25 then
            eventDelayFn = eventDelays.rare
        elseif day < 50 then
            eventDelayFn = eventDelays.occasional
        elseif day < 100 then
            eventDelayFn = eventDelays.occasional
        else
            eventDelayFn = eventDelays.frequent
        end
    end

    local function PlanNextEvent()
        if timeToNextEvent > 0 then
            return
        end
        local timetoattackbase, timetoattackvariance = eventDelayFn()
        timeToNextEvent = timetoattackbase + timetoattackvariance
    end

    function self:Init()
        PlanNextEvent()
    end

    function self:StartRandomEvent()
        local eventId = "temperature"
        local newEvent = GetGlobalEventById(eventId)
        c_announce("STARTING EVENT " .. eventId)
        currentEvents[eventId] = newEvent
        currentEvents[eventId]:OnStart()
    end

    function self:GetCurrentEvents()
        return currentEvents
    end

    function self:StopAllEvents()
        for eventId, event in pairs(currentEvents) do
            event:OnStop()
            c_announce("STOPPING EVENT " .. eventId)
            currentEvents[eventId] = nil
        end
    end

    function self:UpdateCurrentEvents(dt)
        --print("UpdateCurrentEvents " )
        -- dumptable(currentEvents)
        for eventId, event in pairs(currentEvents) do
            if event ~= nil then
                event:OnUpdate(dt)
                if event:IsOut() then
                    event:OnStop()
                    c_announce("STOPPING EVENT " .. eventId)
                    currentEvents[eventId] = nil
                end
            end
            -- print("try update " .. eventId)
        end
    end

    function self:OnUpdate(dt)
        --print(timeToNextEvent)
        -- print("TEST" .. tostring(dt))
        timeToNextEvent = timeToNextEvent - dt
        if timeToNextEvent < 0 then

            self:StartRandomEvent();
            PlanNextEvent()
        end

        self:UpdateCurrentEvents(dt)
    end

    function self:DumpCurrentEvents()
        for eventId, event in pairs(currentEvents) do
            if event ~= nil then
                event:GetDebugString()
            end
        end
    end
end)