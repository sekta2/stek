# Хуки > s_inv.serialize
<!-- TODO: Написать описание хука -->

## Аргументы

| Название | Тип | Описание |
| -------- | ------- | ------- |
| inv | table | Инвентарь |
| ent | Entity | Энтити |

## Возвращает

| Тип | Описание |
| ------- | ------- |
| table | Данные о энтити |

## Пример

Создаём хук который будет правильно сохранять данные об энтити

```lua
local function serialize(inv, ent)
    if ent:GetClass() == "custom_serv_ent" then
        return {
            type = "custom_serv_ent",
            somedata1 = ent.SomeDataOne
        }
    end
end

hook.Add("s_inv.serialize", "server.custom_serv", serialize)
```