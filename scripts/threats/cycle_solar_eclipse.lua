GLOBAL.require("utils/utils_events")
local BaseThreat = GLOBAL.require("threats/base")

SolarEclipseThreat = Class(BaseThreat, function(self, data)
    BaseThreat._ctor(self, "SolarEclipseThreat")
    self.tag = 'cycle_start'
    local NUM_SEGS = 16
    self.chance = .15
    self.segsMin = NUM_SEGS
    self.segsMax = NUM_SEGS
    self.isRegular = false

    function self:Subscribe(world, storyteller, id)
        world:WatchWorldState("cycles", function()
            storyteller:OnSubscription(id)
        end)
        --[[world:ListenForEvent("cycleschanged", function()
            storyteller:OnSubscription(event_id)
        end, GLOBAL.TheWorld)]]
    end

    function self:OnStart()
        local nightSegs = GLOBAL.TheWorld.state.phasesegs.night
        local duskSegs = NUM_SEGS - nightSegs;
        GLOBAL.TheWorld:PushEvent("ms_setclocksegs", { day = 0, dusk = duskSegs, night = nightSegs })
    end

    function self.OnStop()
        if force then
            GLOBAL.TheWorld:PushEvent("ms_setclocksegs")
        end
    end
end)

GLOBAL.AddThreat('cycle_solar_eclipse', SolarEclipseThreat({}))