local function ShareLocales()
    local locales = file.Find("stek/localization/*.lua", "LUA")

    for i = 1, #locales do
        local name = locales[i]
        AddCSLuaFile("lua/stek/localization/" .. name)
    end
end

ShareLocales()