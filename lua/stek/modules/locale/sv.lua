local function ShareLocales()
    local locales = file.Find("stek/localization/*.lua", "LUA")

    for i = 1, #locales do
        local name = locales[i]
        AddCSLuaFile("stek/localization/" .. name)
    end
end

local function ShareAddonsLocales()
    local _, addons = file.Find("stekpacks/*", "LUA")

    for i = 1, #addons do
        local addon_name = addons[i]

        local path = "stekpacks/" .. addon_name .. "/"
        if not file.Exists(path, "LUA") then continue end

        local locales_path = path .. "locale/"
        if not file.Exists(locales_path, "LUA") then continue end

        local locales_files, _ = file.Find(locales_path .. "*.lua", "LUA")
        for j = 1, #locales_files do
            local locale_filename = locales_files[j]
            AddCSLuaFile(locales_path .. locale_filename)
        end
    end
end

ShareLocales()
ShareAddonsLocales()
