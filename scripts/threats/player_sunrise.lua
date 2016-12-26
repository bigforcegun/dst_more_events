--'sunrise'

GLOBAL.require("utils/utils_events")
local BaseThreat = GLOBAL.require("threats/base")

PlayerSunriseThreat = Class(BaseThreat, function(self, data)
    BaseThreat._ctor(self, "PlayerSunriseThreat")
    self.tag = 'player_cycle_start'
    local NUM_SEGS = 0
    local EAST_DIRECTION = -135
    local EAST_DIRECTION_ANGLE = 40
    self.chance = 1
    self.segsMin = NUM_SEGS
    self.segsMax = NUM_SEGS
    self.isRegular = false

    local function CalculateDefinitions()
    end

    function self:Subscribe(world, storyteller, event_id)
        world:ListenForEvent("phasechanged", function()
            storyteller:OnSubscription(event_id)
        end, GLOBAL.TheWorld)
    end

    function self:CalculateDefinitions()
        self.defs.isPositive = true
        if (math.random() < .50) then
            self.defs.isPositive = false
        end
    end

    local function IsPlayerRotationOnSunrise(player)
        local rotation = player:GetRotation();
        --GLOBAL.c_announce(rotation)
        if (EAST_DIRECTION - EAST_DIRECTION_ANGLE) < rotation and rotation < (EAST_DIRECTION + EAST_DIRECTION_ANGLE) then
            return true
        end
        return false
        --return (EAST_DIRECTION - EAST_DIRECTION_ANGLE) < rotation < (EAST_DIRECTION + EAST_DIRECTION_ANGLE)
    end

    function self:OnStart()
        self:CalculateDefinitions()
        if GLOBAL.TheWorld.state.isday then
            for key, player in ipairs(GLOBAL.AllPlayers) do
                if IsPlayerRotationOnSunrise(player) then
                    local talk = GLOBAL.T('PLAYER_MEETS_UGLY_SUNRISE')
                    local sanity = -20
                    if self:IsPositive() then
                        talk = GLOBAL.T('PLAYER_MEETS_BEAUTIFUL_SUNRISE')
                        sanity = 20
                    end
                    player.components.talker:Say(talk)
                    player.components.sanity:DoDelta(sanity)
                end
                --TheCamera:GetHeading()
            end
        end

        --self:CalculateDuration()
    end

    function self.OnStop()
        --GLOBAL.TheWorld:PushEvent("ms_setclocksegs")
    end
end)

GLOBAL.AddThreat('player_sunrise', PlayerSunriseThreat({}))