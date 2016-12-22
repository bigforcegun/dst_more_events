_DEBUG_ENABLED = true
if _DEBUG_ENABLED then
    GLOBAL.CHEATS_ENABLED = true
    GLOBAL.DEBUG_MENU_ENABLED = true
    GLOBAL.CONTROL_OPEN_DEBUG_MENU = 72 -- I
    GLOBAL.require "debugcommands"
    GLOBAL.require "debugkeys"
    print("MORE EVENT DEBUG ENABLED")
end


--[[
	Dependencies
--]]


modimport("init/init_global_events")
modimport("init/init_worldstate_extender")
-- modimport("scripts/utils/utils_events")
--modimport("utils/utils_common")
--modimport("utils/utils_main")


--[[
	Globals
--]]

modimport("scripts/threats/temperature")
modimport("scripts/threats/cycle_solstice")
modimport("scripts/threats/cycle_solar_eclipse")
modimport("scripts/threats/cycle_darkness")

--modimport("scripts/components/threats")


-- Add extra components
-- console commands must be require
GLOBAL.require "lib/console_commands"
--modimport("scripts/lib/console_commands")
