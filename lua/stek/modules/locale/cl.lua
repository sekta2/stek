local Locale = stek.Locale

function LanguageChanged(lang)
    if Locale.exists[lang] then
        Locale.Load(lang)
    end
end