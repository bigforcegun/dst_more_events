--
-- Created by IntelliJ IDEA.
-- User: bigfo
-- Date: 09.12.2016
-- Time: 23:29
-- To change this template use File | Settings | File Templates.
--

GLOBAL.require("utils/utils_events")
local BaseGlobalEvent = GLOBAL.require("events/base")

TemperatureEvent = Class(BaseGlobalEvent, function(self, data)
    BaseGlobalEvent._ctor(self, "TemperatureEvent")
    print("TemperatureEventINIT")
    self.name = "Weather cold snap"
    self.defs = {
        sign = 0,
        minRange = 10,
        maxRange = 50,
        toTemperature = 0
    }
    local TEMPERATURE_SIGNS = {
        colder = -1,
        warmer = 1
    }
    local PHASE_TEMPERATURES =
    {
        day = 5,
        night = -6,
    }

    local startTemperature = 0

    local MIN_TEMPERATURE = -30
    local MAX_TEMPERATURE = 99

    self.segsMin = 5
    self.segsMax = 10

    local function CalculatePhaseTemperature()
        local phase = GLOBAL.TheWorld.state.phase
        local timeInPhase = GLOBAL.TheWorld.state.timeinphase
        return PHASE_TEMPERATURES[phase] ~= nil and PHASE_TEMPERATURES[phase] * math.sin(timeInPhase * PI) or 0
    end

    local function GetWorldTemperature()
        return GLOBAL.TheWorld.state.temperature
    end

    local function CalculateSeasonRanges()
        if GLOBAL.TheWorld.state.iswinter or GLOBAL.TheWorld.state.issummer then
            return 20, 50
        end
        return 10, 40
    end

    local function RandomizeTemperatureSign()
        local chance = math.random(0, 100);
        if GLOBAL.TheWorld.state.iswinter then
            if chance < 75 then
                return TEMPERATURE_SIGNS.colder
            end
        elseif GLOBAL.TheWorld.state.issummer then
            if chance < 25 then
                return TEMPERATURE_SIGNS.colder
            end
        else
            if chance < 50 then
                return TEMPERATURE_SIGNS.colder
            end
        end
        return TEMPERATURE_SIGNS.warmer
    end

    local function CalculateToTemperature()
        local temp = self.defs.sign * (math.random(self.defs.minRange, self.defs.maxRange));
        if temp < MIN_TEMPERATURE then temp = MIN_TEMPERATURE end
        if temp > MAX_TEMPERATURE then temp = MAX_TEMPERATURE end
        return temp
    end

    local function CalculateDefinitions()
        self:CalculateEventDuration()
        startTemperature = GetWorldTemperature()
        self.defs.sign = RandomizeTemperatureSign()
        self.defs.minRange, self.defs.maxRange = CalculateSeasonRanges()
        self.defs.toTemperature = CalculateToTemperature()
    end



    local function SetTemperature(temperature)
        if GetWorldTemperature ~= temperature then
            GLOBAL.TheWorld.net.components.worldtemperature:SetTemperatureMod(0, temperature)
        end
    end

    local function ResetTemperature()
        GLOBAL.TheWorld.net.components.worldtemperature:SetTemperatureMod(1, 0)
    end

    function self:OnStart()
        -- change temp
        CalculateDefinitions()
    end

    local function CalculateStageTemperature()
        local preparationPercent = 20
        local percentage = self:GetCompletePercentage()
        local stageTemperature = 0
        if percentage < preparationPercent then
            local stagePercent = percentage / preparationPercent * 100
            stageTemperature = self.defs.toTemperature / 100 * stagePercent
        elseif percentage > 100 - preparationPercent then
            local stagePercent = (100 - percentage) / preparationPercent * 100
            stageTemperature = self.defs.toTemperature / 100 * stagePercent
        else
            stageTemperature = self.defs.toTemperature
        end
        local phaseTemperature = 0 --CalculatePhaseTemperature()
        stageTemperature = startTemperature + phaseTemperature + stageTemperature
        return stageTemperature
    end

    function self:OnUpdate(dt)
        self:UpdateTime(dt)
        local stageTemperature = CalculateStageTemperature()
        SetTemperature(stageTemperature)
    end

    function self:CheckConditions()
    end

    function self:OnStop()
        -- change temp
        ResetTemperature()
    end


end)

GLOBAL.AddGlobalEventByClass('temperature', TemperatureEvent({}))

--[[
AddGlobalEventByDef("temperature_low_test", {
    name = "Weather cold snap",
    segs_min = 5,
    segs_max = 15,
    tags = { 'temperature' },
    onStart = function()
    end,
    onEnd = function()
        --TheWorld.net.components.worldtemperature:SetTemperatureMod(1, 1)
    end,
    onUpdate = function(dt)
    end
})]]