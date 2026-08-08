local Locale = stek.Locale

hook.Add("LanguageChanged", "stek.ChangeLocale", function(lang)
    if Locale.exists[lang] then
        Locale.load(lang)
    else
        Locale.load(Locale.default_language)
    end
end)
