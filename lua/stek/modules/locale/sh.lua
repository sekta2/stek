local Locale = {
    pack = nil,
    pack_name = nil,

    exists = {}
}

function Locale.CheckLocales()
    local files = file.Find("stek/localization/*", "LUA")

    for i = 1, #files do
        local filename = files[i]
        local name = string.match(filename, "(.+)%.")

        Locale.exists[name] = true
    end
end

function Locale.Load(locale_name)
    if not Locale.exists[locale_name] then error(("Locale '%s' not exists"):format(locale_name)) end

    Locale.pack = include("stek/localization/" .. locale_name .. ".lua")
    Locale.pack_name = locale_name
end

function Locale.Exists(phrase_name)
    if not Locale.pack then
        return false
    end

    return Locale.pack.phrases[phrase_name] and true or false
end

function Locale.Get(phrase_name)
    if not Locale.pack then
        return "[PACK NOT LOADED]"
    end

    local phrase = Locale.pack.phrases[phrase_name]
    if not phrase then
        return "[UNKNOWN]"
    end

    return phrase
end

function Locale.Format(text)
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

function Locale.Init()
    local GmodLocale = GetConVar("gmod_language"):GetString()

    if Locale.exists[GmodLocale] then
        Locale.Load(GmodLocale)
    else
        Locale.Load("en")
    end
end

---

Locale.CheckLocales()

stek.Locale = Locale