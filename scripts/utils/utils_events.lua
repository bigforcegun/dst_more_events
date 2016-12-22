--
-- Created by IntelliJ IDEA.
-- User: bigfo
--

-- temporally global register of random and byevents threats

-- local baseGlobalEvent = require "threats/base"
_ = require 'lib/underscore'

local threats = {}

function AddThreat(id, classDef)
    --table.insert(globalEvents[type], classDef)
    threats[id] = classDef
end

function GetAllThreats()
    return threats
end

function GetRegularThreats()
    return _.select(threats, function(t) return t:IsRegular() == true end)
end
-- TODO cache results
function GetEventsThreats()
    local _threats = {}
    for threatId, threat in pairs(GetAllThreats()) do
        if threat:IsEvent() then
            _threats[threatId] = threat
        end
    end

    return _threats
    --return _.select(threats, function(t) return t:IsEvent() == true end)
end

--function AddGlobalEventByDef(id, data)
    --assert(GetDataForLevelID(data.id) == nil, string.format("Tried adding a level with id %s, but one already exists!", data.id))
   -- local newEvent = baseGlobalEvent(data)
    --AddGlobalEventByClass(id, newEvent)
    --table.insert(globalEvents[type], baseGlobalEvent(data))
--end

function GetThreatById(id)
    return threats[id]
end
