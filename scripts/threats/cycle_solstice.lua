--
-- Created by IntelliJ IDEA.
-- User: bigfo
-- Date: 20.12.2016
-- Time: 3:13
-- To change this template use File | Settings | File Templates.
--

GLOBAL.require("utils/utils_events")
local BaseThreat = GLOBAL.require("threats/base")

SolsticeThreat = Class(BaseThreat, function(self, data)
    BaseThreat._ctor(self, "SolsticeThreat")
    self.tag = 'cycle_start'
    local NUM_SEGS = 16
    self.chance = .5
    self.segsMin = NUM_SEGS
    self.segsMax = NUM_SEGS
    self.isRegular = false

    function self:Subscribe(world, storyteller, id)
        world:WatchWorldState("cycles", function()
            storyteller:OnSubscription(id)
        end)
        --[[ world:ListenForEvent("cycleschanged", function()
             storyteller:OnSubscription(event_id)
         end, GLOBAL.TheWorld)]]
    end

    function self:OnStart()
        -- TODO - event start BEFORE NEXT SEASON SEGS CALCULATION
        -- then OnStop tooggles bad segs
        local nightSegs = GLOBAL.TheWorld.state.phasesegs.night
        local daySegs = NUM_SEGS - nightSegs;
        GLOBAL.TheWorld:PushEvent("ms_setclocksegs", { day = daySegs, dusk = 0, night = nightSegs })
    end

    function self.OnStop()
        -- TODO change rehresh clocksets
        -- This event refreshes clocksegs TO default value, not to season value. It's bad
        -- seasons.lua in DST core doen't allow to get clocksegs for season, only allow to change them
        if force then
            GLOBAL.TheWorld:PushEvent("ms_setclocksegs")
        end
    end
end)

GLOBAL.AddThreat('cycle_solstice', SolsticeThreat({}))

