--
-- Created by IntelliJ IDEA.
-- User: bigfo
-- Date: 09.12.2016
-- Time: 14:57
-- To change this template use File | Settings | File Templates.
--

function c_ge_debug()
    print(TheWorld.components.global_events:GetDebugString())
end


function c_ge_o()
    return TheWorld.components.global_events
end

function c_ge_st()
    return c_ge_o():GetStoryTeller()
end

function c_ge_dc()
    return c_ge_st():DumpCurrentThreats()
end

function c_ge_se(threat_id)
    return c_ge_st():StartThreat(threat_id)
end

function c_ge_r()
    c_ge_st():StartRandomEvent()
end

function c_ge_s()
    c_ge_st():StopAllThreats()
end

function c_ge_t()
    for i = 1, 10 do
        c_ge_r()
        c_ge_dc()
        c_ge_s()
    end
end

function c_ge_de()
    dumptable(c_ge_st():GetCurrentThreats());
end

