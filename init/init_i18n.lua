local steamSupportLanguages = {} -- STUB
STRINGS = GLOBAL.STRINGS
local function InitI18N()
    --[[  local steamlang = GLOBAL.TheNet:GetLanguageCode() or nil
      if steamlang and steamSupportLanguages[steamlang] then
          -- STUB
      else
      end]]
    STRINGS.MORE_THREATS = {}
    modimport('locale/strings.en')
end

function GLOBAL.T(key)
    local tr = 'Translation missing for key ' .. key
    if key then
        if STRINGS.MORE_THREATS[string.upper(key)] then
            tr = STRINGS.MORE_THREATS[string.upper(key)]
        end
    end
    return tr
end

AddPrefabPostInit("world", function(inst)
    --InitI18N()
end)
AddClassPostConstruct("widgets/controls", InitI18N)