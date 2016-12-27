--
-- Created by IntelliJ IDEA.
-- User: bigfo
-- Date: 20.12.2016
-- Time: 3:13
-- To change this template use File | Settings | File Templates.
--

GLOBAL.require("utils/utils_events")
local BaseThreat = GLOBAL.require("threats/base")

DarknessThreat = Class(BaseThreat, function(self, data)
    BaseThreat._ctor(self, "DarknessThreat")
    self.tag = 'cycle_start'
    local NUM_SEGS = 16
    self.chance = .10
    self.segsMin = NUM_SEGS
    self.segsMax = NUM_SEGS
    self.isRegular = false

    function self:Subscribe(world, storyteller, id)
        world:WatchWorldState("cycles", function()
            storyteller:OnSubscription(id)
        end)

        --[[world:ListenForEvent("cycleschanged", function()
            storyteller:OnSubscription(id)
        end, GLOBAL.TheWorld)]]
    end

    function self:OnStart()
        GLOBAL.TheWorld:PushEvent("ms_setclocksegs", { day = 0, dusk = 0, night = NUM_SEGS })
    end

    function self.OnStop(force)
        if force then
            GLOBAL.TheWorld:PushEvent("ms_setclocksegs")
        end
    end
end)

GLOBAL.AddThreat('cycle_darkness', DarknessThreat({}))

