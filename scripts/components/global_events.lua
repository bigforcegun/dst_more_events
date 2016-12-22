--
-- Created by IntelliJ IDEA.
-- User: bigfo
-- Date: 13.12.2016
-- Time: 14:46
-- To change this template use File | Settings | File Templates.
--

--[[
GLOBAL_EVENTS = {
    'tempterature_grow',
    'tempterature_low'
}



for k,global_event in ipairs(GLOBAL_EVENTS) do
    inst.components.curses:AddCurse(curse)
    curse:SetOwner(inst)
end]]

return Class(function(self, inst)

    --Public
    self.inst = inst
    local currentStoryTeller
    local currentEvents = {}

    function self:SetStoryTeller(storyTellerName)
        local storyTellerClass = require('storytellers/' .. storyTellerName)
        currentStoryTeller = storyTellerClass(self.inst)
    end

    function self:GetStoryTeller()
        return currentStoryTeller
    end


    function self:OnSave()
        return {}
    end

    function self:OnLoad(data)
    end

    function self:OnUpdate(dt)
        currentStoryTeller:OnUpdate(dt)
    end

    function self:LongUpdate(dt)
        self:OnUpdate(dt)
    end

    function self:DoDelta()
    end

    function self:StartEvent(eventName)
    end

    function self:GetDebugString()

        local dbString = "Global Events: \n"
        dbString = dbString .. "Story Teller: " .. self:GetStoryTeller():GetName()

        return string.format(dbString)
    end


    local function OnPlayerJoined(src, player)
        currentStoryTeller:OnPlayerJoined(src, player)
    end

    local function OnPlayerLeft(src, player)
        currentStoryTeller:OnPlayerLeft(src, player)
    end


    function self:Init()
        self:SetStoryTeller('simple')
        self.inst:StartUpdatingComponent(self)
        inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, TheWorld)
        inst:ListenForEvent("ms_playerleft", OnPlayerLeft, TheWorld)
        currentStoryTeller:Init();
    end



    self:Init()
end)
