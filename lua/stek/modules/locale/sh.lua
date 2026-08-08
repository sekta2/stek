local Locale = {
    pack = nil,
    pack_name = nil,
    default_language = "en",

    index = {}
}

function Locale.checkLocales()
    local files = file.Find("stek/localization/*", "LUA")

    for i = 1, #files do
        local filename = files[i]
        local name = string.match(filename, "(.+)%.")

        Locale.index[name] = true
    end
end

function Locale.load(locale_name)
    if not Locale.index[locale_name] then error(("Locale '%s' not exists"):format(locale_name)) end

    Locale.pack = include("stek/localization/" .. locale_name .. ".lua")
    Locale.pack_name = locale_name

    Locale.injectAddonsLocales()
end

function Locale.injectAddonsLocales()
    local _, addons = file.Find("stekpacks/*", "LUA")

    for i = 1, #addons do
        local addon_name = addons[i]
        local path = "stekpacks/" .. addon_name .. "/"
        if not file.Exists(path, "LUA") then continue end

        local locales_path = path .. "locale/"
        if not file.Exists(locales_path, "LUA") then continue end

        local current_lang_path = locales_path .. Locale.pack_name .. ".lua"
        if not file.Exists(current_lang_path, "LUA") then
            local fallback_lang_path = locales_path .. Locale.default_language .. ".lua"
            if not file.Exists(fallback_lang_path, "LUA") then continue end

            local lang_tbl = include(fallback_lang_path)
            local count = 0
            for k, v in pairs(lang_tbl) do
                if not Locale.pack.phrases[k] then
                    Locale.pack.phrases[k] = v
                    count = count + 1
                end
            end

            print("Loaded locale " ..
                Locale.default_language .. "(fallback) for addon " .. addon_name .. " (" .. count .. " phrases)")

            continue
        end

        local lang_tbl = include(current_lang_path)
        local count = 0
        for k, v in pairs(lang_tbl) do
            if not Locale.pack.phrases[k] then
                Locale.pack.phrases[k] = v
                count = count + 1
            end
        end

        print("Loaded locale " .. Locale.pack_name .. " for addon " .. addon_name .. " (" .. count .. " phrases)")
    end
end

function Locale.exists(phrase_name)
    if not Locale.pack then
        return false
    end

    return Locale.pack.phrases[phrase_name] and true or false
end

function Locale.get(phrase_name)
    if not Locale.pack then
        return "[PACK NOT LOADED]"
    end

    local phrase = Locale.pack.phrases[phrase_name]
    if not phrase then
        return "[UNKNOWN]"
    end

    return phrase
end

function Locale.format(text)
    if not Locale.pack then
        return text
    end

    local result = string.gsub(text, "%$%{([^}]+)%}", function(variable_name)
        local phrase = Locale.pack.phrases[variable_name]
        if phrase then
            return phrase
        else
            return ("${%s}"):format(variable_name)
        end
    end)

    return result
end

function Locale.init()
    local GmodLocale = GetConVar("gmod_language"):GetString()

    if Locale.index[GmodLocale] then
        Locale.load(GmodLocale)
    else
        Locale.load(Locale.default_language)
    end
end

---

Locale.checkLocales()

stek.Locale = Locale
