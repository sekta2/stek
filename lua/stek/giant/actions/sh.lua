s_actions = {
    list = {},
    list_uid = {},
    uid = 0
}

--[[
    () - обязательно, [] - опционально

    (вывод) [функция]
    ^ Выводимое значение из функции

    Action Struct:

    (func) - Функция которая вызывается при выполнении,
        (ply) - игрок,
        [args] - аргументы
    
    (bool) (table) [check_func] - Функция проверки аргументов, работает на двух сторонах, ДОЛЖНА выводить успех(bool) и таблицу аргументов для (func)
                                  в случае ошибки, ложь(bool) и строку-причину,
        (ply) - игрок,
        [raw_args] - "сырые"-аргументы,
        (args) - таблица аргументов ниже
    
    [args] - Таблица с аргументами, используется стандарт-функцией проверки,
        пример - {
        --  {идентификатор, дефолт_значение, обязательно, тип}
            {"name",        _,               true,        "string"},
            {"age",         18,              false,       "number"}
        }
    
    [description] - Описание действия (для кон.команды),
    [cooldown] - Задержка перед следующим выполнением,

    [is_client] - Является ли действие клиентским, если да то [cooldown] и серверное выполнение не будет работать
--]]

local convert = {
    ["number"] = tonumber,
    ["string"] = tostring,
    ["boolean"] = tobool
}

-- ply - игрок
-- args - аргументы действия
-- raw_args - сырые аргументы, взятые из кон-команды
local function default_check(ply, raw_args, args)
    if #args <= 0 then return true, {} end

    local c_args = {}

    for i = 1, #args do
        local exp_arg = args[i]
        local conv = convert[exp_arg[4]]

        local arg = conv and conv(raw_args[i]) or raw_args[i]

        if exp_arg[3] and arg == nil then
            return false, i .. "-st argument is required!"
        end

        if arg ~= nil and exp_arg[4] and type(arg) ~= exp_arg[4] then
            return false, i .. "-st the argument is not " .. exp_arg[4]
        end

        c_args[exp_arg[1]] = arg or exp_arg[2]
    end

    return true, c_args
end

s_actions.default_check = default_check

-- name - ид действия
-- t - вводная структура действия
function s_actions.AddAction(name, t)
    s_actions.uid = s_actions.uid + 1
    local uid = s_actions.uid

    s_actions.list_uid[name] = uid

    local st = {
        name = name, -- дублируем имя действия, хз для чего лол
        uid = uid,

        func = t.func,
        check_func = t.check_func or default_check,

        args = t.args or {},

        description = t.description or "",
        cooldown = t.cooldown or 0,

        is_client = t.is_client or false
    }

    s_actions.list[uid] = st

    if CLIENT then
        local id = t.custom_name or "stek_act_" .. name

        concommand.Add(id, function(ply, cmd, args)
            local st_cfn = st.check_func

            local success, c_args = st_cfn(ply, args, st.args)

            if not success then
                print("[CLIENT] Action execution error:\n" .. c_args)
                return
            end

            if st.is_client then
                local st_fn = st.func
                st_fn(ply, c_args)

                return
            end

            net.Start("s_actions.act")
                net.WriteSmartUInt(uid)
                net.WriteTable(args, true)
            net.SendToServer()
        end)
    end
end