s_res = {
    list = {},
    id_list = {}
}

local error_material = Material("icon16/error.png")

--[[
    Структура ресурса

    name - Название ресурса
    auto_entity - Создавать ли энтити для этого ресурса(по дефолту true)

    !!! Если auto_entity стоит на false тогда всё что ниже использовать не обязательно !!!

    model - Моделька ресурса
    material - Материал ресурса
    mass - Масса ресурса
    color - Цвет ресурса
    skin - Скин модельки ресурса

    holovec - Позиция голограммы(по дефолту vector_origin)
    holoang - Угол поворота голограммы(по дефолту angle_zero)
    holovertical - Является ли голограмма ресурса вертиальной(по дефолту false)
    holosize - Размер голограммы(по дефолту 0.035, можно не ставить)

    carryangles - Угол поворота при подбирании энтити ресурса
]]

function s_res.add(id, struct)
    local icon_exists = file.Exists("materials/stek_resources/" .. id .. ".png", "GAME")
    local icon_exists_small = file.Exists("materials/stek_resources/" .. id .. " smol.png", "GAME")

    local m_struct = {
        id = id,

        name = struct.name,
        auto_entity = struct.auto_entity == nil and true or struct.auto_entity,

        model = struct.model,
        material = struct.material,
        mass = struct.mass,
        color = struct.color,
        skin = struct.skin,

        holovec = struct.holovec,
        holoang = struct.holoang,
        holovertical = struct.holovertical,
        holosize = struct.holosize,

        carryangles = struct.carryangles,

        classname = "stek_res_" .. id,

        icon = icon_exists and Material("materials/stek_resources/" .. id .. ".png") or error_material,
        icon_small = icon_exists_small and Material("materials/stek_resources/" .. id .. " smol.png") or error_material,
    }

    local uid = #s_res.list + 1

    m_struct.uid = uid

    s_res.list[uid] = m_struct
    s_res.id_list[id] = m_struct

    s_util.print("Added new resource: " .. id .. " | UID: " .. uid)

    return uid
end

function s_res.get_by_id(id)
    return s_res.id_list[id]
end

function s_res.get_by_uid(uid)
    return s_res.list[uid]
end

--[[------------------------]]--

function s_res.load()
    s_res.add("adv_parts", {
        name = "Передовые детали",
        model = "models/jmod/resources/hard_case_b.mdl",
        holovec = Vector(0, 3.5, 1),
        holoang = Angle(-90, 0, 90),
        holovertical = true,
        carryangles = Angle(0, 180, 0)
    })

    s_res.add("adv_textiles", {
        name = "Передовой текстиль",
        model = "models/jmod/resources/cylinderx15.mdl",
        material = "models/mat_jack_gmod_advtextileroll",
        color = Color(200, 200, 200),
        mass = 60,
        holovec = Vector(0, 3, 9),
        holoang = angle_zero,
        holosize = 0.017,
        carryangles = Angle(0, -90, 100)
    })

    s_res.add("ammo", {
        name = "Патроны",
        model = "models/jmod/items/BoxJRounds.mdl",
        material = "models/mat_jack_gmod_ezammobox",
        mass = 50,
        holovec = Vector(0, 5, 9),
        holoang = Angle(-90, 0, 90),
        holosize = 0.04,
        carryangles = Angle(0, 180, 0)
    })

    s_res.add("antimatter", {
        name = "Антиматерия",
        model = "models/thedoctor/darkmatter.mdl",
        holovec = Vector(1, -6.2, 8),
        holoang = Angle(90, 0, 90),
        holovertical = true,
        holosize = 0.02
    })

    s_res.add("basic_parts", {
        name = "Базовые части",
        model = "models/jmod/resources/jack_crate.mdl",
        mass = 50,
        holovec = Vector(0.5, 13, 10),
        holoang = Angle(-90, 0, 90),
        holovertical = true,
        holosize = 0.043,
        carryangles = Angle(0, 180, 0)
    })

    s_res.add("power", {
        name = "Энергия",
        model = "models/jmod/resources/battery_v2.mdl",
        mass = 50,
        holovec = Vector(0, 7, 6.5),
        holoang = Angle(-90, 0, 90),
        holovertical = false,
        holosize = 0.03,
        carryangles = Angle(0, 180, 0)
    })

    s_res.add("ceramic", {
        name = "Керамика",
        model = "models/jmod/resources/resourcecube.mdl",
        material = "models/props_building_details/courtyard_template001c_bars",
        mass = 80,
        color = Color(200, 177, 120),
        holovec = Vector(0, -12, 0),
        holoang = Angle(90, 0, 90),
        holovertical = true,
        holosize = 0.06
    })

    s_res.add("chemicals", {
        name = "Химикаты",
        model = "models/jmod/resources/plastic_crate25a.mdl",
        mass = 50,
        holovec = Vector(-1, 11, 0),
        holoang = Angle(-90, 0, 90),
        holosize = 0.04,
        carryangles = Angle(0, 180, 0)
    })

    s_res.add("cloth", {
        name = "Ткань",
        model = "models/jmod/resources/cylinderx15.mdl",
        material = "models/mat_jack_gmod_clothroll",
        color = Color(200, 200, 200),
        mass = 30,
        holovec = Vector(0, -.5, 9),
        holoang = angle_zero,
        holosize = 0.025,
        carryangles = Angle(0, -90, 100)
    })

    s_res.add("coal", {
        name = "Уголь",
        model = "models/jmod/resources/resourcecube.mdl",
        material = "models/mat_jack_gmod_coal",
        color = Color(150, 150, 150),
        mass = 50,
        holovec = Vector(0, -12, 1),
        holoang = Angle(90, 0, 90),
        holovertical = true,
        holosize = 0.04
    })

    s_res.add("coolant", {
        name = "Охлаждающая жидкость",
        model = "models/jmod/resources/coolantbottle.mdl",
        material = "models/shiny",
        color = Color(50, 120, 180),
        mass = 40,
        holovec = Vector(-5.1, 0, 0),
        holoang = Angle(180, 0, 90),
        holovertical = true,
        holosize = 0.04,
        carryangles = Angle(0, 90, 0)
    })

    s_res.add("copper", {
        name = "Медь",
        model = "models/jmod/resources/ingot001.mdl",
        material = "models/props_mining/ingot_jack_copper",
        color = Color(150, 100, 80),
        mass = 50,
        holovec = Vector(0, -3, 4.9),
        holoang = angle_zero,
        holosize = 0.025,
        carryangles = Angle(180, 90, -90)
    })

    s_res.add("diamond", {
        name = "Алмазы",
        model = "models/jmod/resources/diamondbox_open.mdl",
        holovec = Vector(0, -9.7, 9),
        holoang = Angle(-90, 15, 90),
        carryangles = Angle(0, 180, 0)
    })

    s_res.add("explosives", {
        name = "Взрывчатые вещества",
        model = "models/jmod/resources/jack_crate.mdl",
        material = "models/mat_jack_gmod_ezexplosives",
        holovec = Vector(1, -11.3, 10),
        holoang = Angle(90, 0, 90),
        holovertical = true,
        holosize = 0.03
    })

    s_res.add("fissile", {
        name = "Делящийся материал",
        model = "models/kali/props/cases/hard case c.mdl",
        mass = 50,
        skin = 2,
        holovec = Vector(0, 0, 21.75),
        holoang = Angle(0, 90, 0),
        holovertical = true,
        holosize = 0.06,
        carryangles = Angle(0, 180, 0)
    })

    s_res.add("fuel", {
        name = "Топливо",
        model = "models/props_junk/gascan001a.mdl",
        holovec = Vector(0, 3.9, -1.5),
        holoang = Angle(-90, 0, 90),
        holovertical = true,
        carryangles = Angle(0, 180, 0)
    })

    s_res.add("gas", {
        name = "Газ",
        model = "models/jmod/explosives/props_explosive/explosive_butane_can.mdl",
        material = "models/shiny",
        holovec = Vector(0, 8.15, 15),
        holoang = Angle(-90, 0, 90),
        holovertical = true,
        holosize = 0.03,
        carryangles = Angle(0, 180, 0)
    })

    s_res.add("gold", {
        name = "Золото",
        model = "models/jmod/resources/ingot001.mdl",
        material = "models/props_mining/ingot_jack_gold",
        color = Color(150, 120, 50),
        mass = 90,
        holovec = Vector(0, -3, 4.9),
        holoang = angle_zero,
        holosize = 0.025,
        carryangles = Angle(180, 90, -90)
    })

    s_res.add("medical", {
        name = "Медицина",
        model = "models/jmod/resources/hard_case_b.mdl",
        material = "models/kali/props/cases/hardcase/jardcase_b",
        mass = 30,
        holovec = Vector(0, 3.4, 0),
        holoang = Angle(-90, 0, -90),
        holovertical = true,
        holosize = 0.045,
        carryangles = Angle(0, 180, 180)
    })

    s_res.add("munitions", {
        name = "Боеприпасы",
        model = "models/jmod/items/BoxJMunitions.mdl",
        material = "models/mat_jack_gmod_ezmunitionbox",
        mass = 70,
        holovec = Vector(-0.7, 7.4, 14),
        holoang = Angle(-90, 0, 90),
        holosize = 0.043,
        carryangles = Angle(0, 180, 0)
    })

    s_res.add("nutrients", {
        name = "Еда",
        model = "models/props_junk/cardboard_box003a.mdl",
        material = "models/mat_jack_gmod_ezammobox",
        holovec = Vector(-3, 18, -2.8),
        holoang = Angle(-90, 0, 90),
        holosize = 0.033,
        carryangles = Angle(0, 180, 0)
    })

    s_res.add("oil", {
        name = "Нефть",
        model = "models/jmod/resources/oildrum075.mdl",
        material = "phoenix_storms/black_chrome",
        mass = 50,
        holovec = Vector(0, -10.6, 17),
        holoang = Angle(90, 0, 90),
        holovertical = true
    })

    s_res.add("organics", {
        name = "Органика",
        model = "models/jmod/resources/plastic_crate25a.mdl",
        holovec = Vector(-1, 11, 0),
        holoang = Angle(-90, 0, 90),
        holosize = 0.04,
        carryangles = Angle(0, 180, 0)
    })

    s_res.add("paper", {
        name = "Бумага",
        model = "models/jmod/resources/ez_paper.mdl",
        holovec = Vector(6.4, -0.5, 0),
        holoang = Angle(0, 0, 90),
        holosize = 0.025,
        carryangles = Angle(0, -90, 0)
    })

    s_res.add("plastic", {
        name = "Пластик",
        model = "models/hunter/blocks/cube05x05x05.mdl",
        color = Color(200, 200, 200),
        mass = 30,
        holovec = Vector(0, -11.9, 5),
        holoang = Angle(90, 0, 90)
    })

    s_res.add("prec_parts", {
        name = "Прецизионные детали",
        model = "models/jmod/resources/hard_case_b.mdl",
        holovec = Vector(0, 3.5, 1),
        holoang = Angle(-90, 0, 90),
        holovertical = true,
        carryangles = Angle(0, 180, 0)
    })

    s_res.add("propellant", {
        name = "Горючее",
        model = "models/jmod/resources/propellent.mdl",
        material = "models/entities/mat_jack_powderbottle",
        mass = 30,
        holovec = Vector(.5, 0, 10.4),
        holoang = angle_zero,
        holovertical = true,
        holosize = 0.025,
        carryangles = Angle(0, -90, 0)
    })

    s_res.add("rubber", {
        name = "Резина",
        model = "models/xqm/airplanewheel1medium.mdl",
        material = "phoenix_storms/road",
        mass = 30,
        color = Color(200, 200, 200),
        holovec = Vector(-1, -9.5, 0),
        holoang = Angle(90, 0, 90),
        holosize = 0.05
    })

    s_res.add("sand", {
        name = "Песок",
        model = "models/jmod/resources/sandbag.mdl",
        color = Color(255, 237, 197),
        mass = 100,
        holovec = Vector(-2, -13, 0),
        holoang = Angle(90, 0, 90),
        holosize = 0.04
    })

    s_res.add("silver", {
        name = "Серебро",
        model = "models/jmod/resources/ingot001.mdl",
        material = "models/props_mining/ingot_jack_silver",
        color = Color(150, 150, 150),
        mass = 40,
        holovec = Vector(0, -3, 4.9),
        holoang = angle_zero,
        holosize = 0.025,
        carryangles = Angle(180, 90, -90)
    })

    s_res.add("steel", {
        name = "Сталь",
        model = "models/jmod/resources/ingot001.mdl",
        material = "models/props_mining/ingot_jack_steel",
        color = Color(50, 50, 50),
        mass = 40,
        holovec = Vector(0, -3, 4.9),
        holoang = angle_zero,
        holosize = 0.025,
        carryangles = Angle(180, 90, -90)
    })

    s_res.add("tungsten", {
        name = "Вольфрам",
        model = "models/jmod/resources/ingot001.mdl",
        material = "models/props_mining/ingot_jack_tungsten",
        color = Color(150, 150, 170),
        mass = 90,
        holovec = Vector(0, -3, 4.9),
        holoang = angle_zero,
        holosize = 0.025,
        carryangles = Angle(180, 90, -90)
    })

    s_res.add("uranium", {
        name = "Уран",
        model = "models/jmod/resources/ingot001.mdl",
        material = "models/props_mining/ingot_jack_uranium",
        color = Color(50, 55, 50),
        mass = 100,
        holovec = Vector(0, -3, 4.9),
        holoang = angle_zero,
        holosize = 0.025,
        carryangles = Angle(180, 90, -90)
    })

    s_res.add("water", {
        name = "Вода",
        model = "models/jmod/resources/water_barrel.mdl",
        mass = 40,
        holovec = Vector(0, -10.8, 0),
        holoang = Angle(90, 0, 90),
        holovertical = true,
        holosize = 0.04
    })

    s_res.add("wood", {
        name = "Древесина",
        model = "models/jmod/resources/ez_wood.mdl",
        color = Color(100, 100, 100),
        mass = 50,
        holovec = Vector(0, -12.5, 1),
        holoang = Angle(90, 0, 90),
        holovertical = true,
        holosize = 0.05
    })

    s_res.create_entities()
end

function s_res.create_entities()
    local ls = s_res.list

    for i = 1, #ls do
        local res = ls[i]

        if not res.auto_entity then continue end

        local ENT = {
            IsStekResource = true,
            StekResource = i,

            StekResLink = res,
            StekResID = res.id,
            StekResUID = i,

            HoloVec = res.holovec or vector_origin,
            HoloAng = res.holoang or angle_zero,
            HoloVertical = res.holovertical or false,
            HoloSize = res.holosize or 0.035,

            CarryAngles = res.carryangles,

            Type = "anim",
            Base = "stek_res_base",

            PrintName = res.name,
            Category = "STek - Resources",
            Model = res.model,
            Material = res.material,
            Mass = res.mass,
            Color = res.color,
            Skin = res.skin,
            IconOverride = "stek_resources/" .. res.id .. ".png",

            Spawnable = true
        }

        scripted_ents.Register(ENT, res.classname)
    end
end