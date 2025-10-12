local Locale = stek.Locale

hook.Add("LanguageChanged", "stek_ChangeLocale", function(lang)
    if Locale.exists[lang] then
        Locale.Load(lang)
    end
end)