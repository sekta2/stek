# ⚒️ STek (Sekta Tech)
Аддон, база для всех JMod-подобных аддонов.

[Workshop Item](https://steamcommunity.com/sharedfiles/filedetails/?id=3764080270)
[Протестировать СТек | Готовые ресурсы и данные для тестирования](https://github.com/sekta2/stek-jmod-pack)

## Стиль кода

### Именования

Переменные/Поля классов - **snake_case**

Функции(локальные) - **snake_case**

Функции в таблице - **camelCase**

Методы - **PascalCase**

Энумерации/Константы - **SCREAMING_SNAKE_CASE**

Модули/Под-модули/Библиотеки - **PascalCase**

Глобальные функции - **PascalCase**

Аргументы в функциях - **snake_case**

Поля у Энтити - **PascalCase**

### Табы vs Пробелы
Табы

## Философия/Концепция
STek подразумевается как база для всех JMod-подобных аддонов, предоставляя базовые инструменты, энтити и модули.

### Структура аддона/контент пака
```
lua/
    stekpacks/
        pack_name/
            locale/
                ru.lua
                en.lua
            config.lua
            crafts.lua
            resources.lua
            gas.lua
```
- структура не финальная, по мере разработке возможны большие изменения в структуре
