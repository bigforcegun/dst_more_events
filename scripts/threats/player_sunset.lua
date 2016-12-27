GLOBAL.require("utils/utils_events")
local BaseThreat = GLOBAL.require("threats/base")

PlayerSunsetThreat = Class(BaseThreat, function(self, data)
    BaseThreat._ctor(self, "PlayerSunriseThreat")
    self.tag = 'player_sunset'
    local NUM_SEGS = 0
    local WEST_DIRECTION = 45
    local WEST_DIRECTION_ANGLE = 40
    self.chance = 1
    self.segsMin = NUM_SEGS
    self.segsMax = NUM_SEGS
    self.isRegular = false
    self.defs = {
        isPositive = true,
        sanityDrain = 0
    }

    function self:Subscribe(world, storyteller, id)
        world:WatchWorldState("isdusk", function()
            storyteller:OnSubscription(id)
        end)
        --[[
        world:ListenForEvent("phasechanged", function()
             storyteller:OnSubscription(id)
        end, GLOBAL.TheWorld)
         ]]
    end

    function self:CheckConditions()
        return GLOBAL.TheWorld.state.isdusk and GLOBAL.TheWorld.state.phasesegs.dusk > 0
    end

    function self:CalculateDefinitions()
        self.defs.isPositive = true
        self.defs.sanityDrain = 20
        if (math.random() < .50) then
            self.defs.isPositive = false
            self.defs.sanityDrain = -20
        end
    end

    local function IsPlayerRotationOnSunset(player)
        local rotation = player:GetRotation();
        if (WEST_DIRECTION - WEST_DIRECTION_ANGLE) < rotation and rotation < (WEST_DIRECTION + WEST_DIRECTION_ANGLE) then
            return true
        end
        return false
    end

    function self:OnStart()
        --if true then
        for key, player in ipairs(GLOBAL.AllPlayers) do
            if IsPlayerRotationOnSunset(player) then
                local talk = GLOBAL.T('PLAYER_MEETS_UGLY_SUNSET')
                if self:IsPositive() then
                    talk = GLOBAL.T('PLAYER_MEETS_BEAUTIFUL_SUNSET')
                end
                player.components.sanity:DoDelta(self.defs.sanityDrain)
                player.components.talker:Say(talk)
            end
        end
    end

    function self.OnStop()
        --GLOBAL.TheWorld:PushEvent("ms_setclocksegs")
    end
end)

GLOBAL.AddThreat('player_sunset', PlayerSunsetThreat({}))