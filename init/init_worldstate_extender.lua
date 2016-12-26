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

