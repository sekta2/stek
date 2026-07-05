local Locale = stek.Locale

hook.Add("LanguageChanged", "stek.ChangeLocale", function(lang)
    if Locale.exists[lang] then
        Locale.Load(lang)
    else
        Locale.Load(Locale.default_language)
    end
end)
