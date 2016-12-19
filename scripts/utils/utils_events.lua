--
-- Created by IntelliJ IDEA.
-- User: bigfo
-- Date: 09.12.2016
-- Time: 23:00
-- To change this template use File | Settings | File Templates.
--

local baseGlobalEvent = require "events/base"
local globalEvents = {}


function AddGlobalEventByClass(id, classDef)
    --table.insert(globalEvents[type], classDef)
    globalEvents[id] = classDef
end

function GetGlobalEvents()
    return globalEvents
end


function AddGlobalEventByDef(id, data)
    --assert(GetDataForLevelID(data.id) == nil, string.format("Tried adding a level with id %s, but one already exists!", data.id))
    local newEvent = baseGlobalEvent(data)
    AddGlobalEventByClass(id, newEvent)
    --table.insert(globalEvents[type], baseGlobalEvent(data))
end

function GetGlobalEventById(id)
    return globalEvents[id]
end
