--
-- Created by IntelliJ IDEA.
-- User: bigfo
-- Date: 13.12.2016
-- Time: 17:09
-- To change this template use File | Settings | File Templates.
--

local _activeplayers = {}

local BaseStoryTeller = Class(function(self, name)

    self.name = name or "Undefined Story Teller"
end)

function BaseStoryTeller:GetName()
    return self.name
end


function BaseStoryTeller:OnPlayerJoined(src, player)
    for i, v in ipairs(_activeplayers) do
        if v == player then
            return
        end
    end
    table.insert(_activeplayers, player)
end

function BaseStoryTeller:OnPlayerLeft(src, player)
    for i, v in ipairs(_activeplayers) do
        if v == player then
            table.remove(_activeplayers, i)
            return
        end
    end
end


function BaseStoryTeller:GetAveragePlayerAgeInDays()
    local sum = 0
    for i, v in ipairs(_activeplayers) do
        sum = sum + v.components.age:GetAgeInDays()
    end
    local average = sum / #_activeplayers
    return average
end

function BaseStoryTeller:OnUpdate(dt)
end


return BaseStoryTeller

