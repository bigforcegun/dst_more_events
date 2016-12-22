--
-- Created by IntelliJ IDEA.
-- User: bigfo
-- Date: 14.12.2016
-- Time: 2:03
-- To change this template use File | Settings | File Templates.
--

function InitGlobalEvents()
    AddPrefabPostInit("world", function(inst)
        inst:AddComponent("global_events")
        ExtendWorldState(inst)
    end)
end

InitGlobalEvents()

