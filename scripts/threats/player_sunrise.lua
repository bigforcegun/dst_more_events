--'sunrise'

GLOBAL.require("utils/utils_events")
local BaseThreat = GLOBAL.require("threats/base")

PlayerSunriseThreat = Class(BaseThreat, function(self, data)
    BaseThreat._ctor(self, "PlayerSunriseThreat")
    self.tag = 'player_sunrise'
    local NUM_SEGS = 0
    local EAST_DIRECTION = -135
    local EAST_DIRECTION_ANGLE = 40
    self.chance = 1
    self.segsMin = NUM_SEGS
    self.segsMax = NUM_SEGS
    self.isRegular = false

    local function CalculateDefinitions()
    end

    function self:Subscribe(world, storyteller, id)
        world:WatchWorldState("isday", function()
            storyteller:OnSubscription(id)
        end)
        --[[
        world:ListenForEvent("phasechanged", function()
             storyteller:OnSubscription(event_id)
         end, GLOBAL.TheWorld)
         ]]
    end

    function self:CheckConditions()
        return GLOBAL.TheWorld.state.isday and GLOBAL.TheWorld.state.phasesegs.day > 0
    end

    function self:CalculateDefinitions()
        self.defs.isPositive = true
        self.defs.sanityDrain = 20
        if (math.random() < .50) then
            self.defs.isPositive = false
            self.defs.sanityDrain = -20
        end
    end

    local function IsPlayerRotationOnSunrise(player)
        local rotation = player:GetRotation();
        if (EAST_DIRECTION - EAST_DIRECTION_ANGLE) < rotation and rotation < (EAST_DIRECTION + EAST_DIRECTION_ANGLE) then
            return true
        end
        return false
        --return (EAST_DIRECTION - EAST_DIRECTION_ANGLE) < rotation < (EAST_DIRECTION + EAST_DIRECTION_ANGLE)
    end

    function self:OnStart()
        --TheCamera:GetHeading()
        --if true then
        for key, player in ipairs(GLOBAL.AllPlayers) do
            if IsPlayerRotationOnSunrise(player) then
                local talk = GLOBAL.T('PLAYER_MEETS_UGLY_SUNRISE')
                if self:IsPositive() then
                    talk = GLOBAL.T('PLAYER_MEETS_BEAUTIFUL_SUNRISE')
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

GLOBAL.AddThreat('player_sunrise', PlayerSunriseThreat({}))