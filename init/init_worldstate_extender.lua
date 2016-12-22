--
-- Created by IntelliJ IDEA.
-- User: bigfo
-- Date: 19.12.2016
-- Time: 17:51
-- To change this template use File | Settings | File Templates.
--

-- Temporaly modify global worldstate
function UpdateWorldStateSegs(inst,data)
    inst.components.worldstate.data.phasesegs = data
end


function ExtendWorldState(inst)
    inst.components.worldstate.inst:ListenForEvent("clocksegschanged", UpdateWorldStateSegs)
end


function InitWorldStateExtender()
    AddPrefabPostInit("world", function(inst)
        ExtendWorldState(inst)
    end)
end

InitWorldStateExtender()

