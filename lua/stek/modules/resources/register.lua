return function(Resources)
    function Resources.Init()
        ---@class ResourceModule
        Resources = Resources -- konchenyi lua linter

        Resources.Add("advancedparts", {
            name = "Advanced Parts",
            icon = "materials/ez_resource_icons/advanced parts.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/hard_case_b.mdl",
                color = Color(100, 100, 100)
            }
        })

        Resources.Add("advancedtextiles", {
            name = "Advanced Textile",
            icon = "materials/ez_resource_icons/advanced textiles.png",
            auto_entity = true,
            entity = {
                model = "models/stek_resources/roll01.mdl",
                material = "models/mat_jack_gmod_advtextileroll",
                color = Color(200, 200, 200)
            }
        })

        Resources.Add("aluminum", {
            name = "Aluminum",
            icon = "materials/ez_resource_icons/aluminum.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/ingot001.mdl",
                material = "models/props_mining/ingot_jack_aluminum",
                color = Color(180, 180, 180)
            }
        })

        Resources.Add("aluminumore", {
            name = "Ore Aluminum",
            icon = "materials/ez_resource_icons/aluminum ore.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/resourcecube.mdl",
                material = "models/mat_jack_gmod_aluminumore"
            }
        })

        Resources.Add("ammo", {
            name = "Ammo",
            icon = "materials/ez_resource_icons/ammo.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/items/BoxJRounds.mdl",
                material = "models/mat_jack_gmod_ezammobox"
            }
        })

        Resources.Add("antimatter", {
            name = "Antimatter",
            icon = "materials/ez_resource_icons/antimatter.png",
            auto_entity = true,
            entity = {
                model = "models/thedoctor/darkmatter.mdl"
            }
        })

        Resources.Add("basicparts", {
            name = "Basic Parts",
            icon = "materials/ez_resource_icons/basic parts.png",
            auto_entity = true,
            entity = {
                model = "models/stek_resources/itemcrate01.mdl"
            }
        })

        Resources.Add("power", {
            name = "Battery",
            icon = "materials/ez_resource_icons/power.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/battery_v2.mdl"
            }
        })

        Resources.Add("ceramic", {
            name = "Ceramic",
            icon = "materials/ez_resource_icons/ceramic.png",
            auto_entity = true,
            entity = {
                model = "models/stek_resources/blocks01.mdl"
            }
        })

        Resources.Add("chemicals", {
            name = "Chemicals",
            icon = "materials/ez_resource_icons/chemicals.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/plastic_crate25a.mdl"
            }
        })

        Resources.Add("cloth", {
            name = "Cloth",
            icon = "materials/ez_resource_icons/cloth.png",
            auto_entity = true,
            entity = {
                model = "models/stek_resources/roll01.mdl",
            }
        })

        Resources.Add("coal", {
            name = "Coal",
            icon = "materials/ez_resource_icons/coal.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/resourcecube.mdl",
                material = "models/mat_jack_gmod_coal",
                color = Color(150, 150, 150)
            }
        })

        Resources.Add("concrete", {
            name = "Concrete",
            icon = "materials/ez_resource_icons/concrete.png",
            auto_entity = true,
            entity = {
                model = "models/hunter/blocks/cube05x05x05.mdl",
                material = "phoenix_storms/concrete3",
                color = Color(214, 221, 223)
            }
        })

        Resources.Add("coolant", {
            name = "Coolant",
            icon = "materials/ez_resource_icons/coolant.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/coolantbottle.mdl",
                material = "models/shiny",
                color = Color(50, 120, 180)
            }
        })

        Resources.Add("copper", {
            name = "Copper",
            icon = "materials/ez_resource_icons/copper.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/ingot001.mdl",
                material = "models/props_mining/ingot_jack_copper",
                color = Color(150, 100, 80)
            }
        })

        Resources.Add("copperore", {
            name = "Ore Copper",
            icon = "materials/ez_resource_icons/copper ore.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/resourcecube.mdl",
                material = "models/mat_jack_gmod_copperore"
            }
        })

        Resources.Add("diamond", {
            name = "Diamond",
            icon = "materials/ez_resource_icons/diamond.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/diamondbox_open.mdl",
                material = "phoenix_storms/grey_steel",
                color = Color(100, 100, 100)
            }
        })

        Resources.Add("explosives", {
            name = "Explosives",
            icon = "materials/ez_resource_icons/explosives.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/jack_crate.mdl",
                material = "models/mat_jack_gmod_ezexplosives"
            }
        })

        Resources.Add("fissilematerial", {
            name = "Fissile Material",
            icon = "materials/ez_resource_icons/fissile material.png",
            auto_entity = true,
            entity = {
                model = "models/kali/props/cases/hard case c.mdl",
                material = nil,
                skin = 2
            }
        })

        Resources.Add("fuel", {
            name = "Fuel",
            icon = "materials/ez_resource_icons/fuel.png",
            auto_entity = true,
            entity = {
                model = "models/stek_resources/gascan01.mdl"
            }
        })

        Resources.Add("gas", {
            name = "Gas",
            icon = "materials/ez_resource_icons/gas.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/explosives/props_explosive/explosive_butane_can.mdl",
                material = "models/shiny",
                color = Color(100, 100, 100)
            }
        })

        Resources.Add("glass", {
            name = "Glass",
            icon = "materials/ez_resource_icons/glass.png",
            auto_entity = true,
            entity = {
                model = "models/hunter/blocks/cube05x05x025.mdl",
                material = "models/mat_jack_gmod_generic_glass",
                color = Color(200, 200, 200)
            }
        })

        Resources.Add("gold", {
            name = "Gold",
            icon = "materials/ez_resource_icons/gold.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/ingot001.mdl",
                material = "models/props_mining/ingot_jack_gold",
                color = Color(150, 120, 50)
            }
        })

        Resources.Add("goldore", {
            name = "Ore Gold",
            icon = "materials/ez_resource_icons/gold ore.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/resourcecube.mdl",
                material = "models/mat_jack_gmod_goldore"
            }
        })

        Resources.Add("ironore", {
            name = "Ore Iron",
            icon = "materials/ez_resource_icons/iron ore.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/resourcecube.mdl",
                material = "models/mat_jack_gmod_ironore"
            }
        })

        Resources.Add("lead", {
            name = "Lead",
            icon = "materials/ez_resource_icons/lead.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/ingot001.mdl",
                material = "models/props_mining/ingot_jack_lead",
                color = Color(50, 50, 60)
            }
        })

        Resources.Add("leadore", {
            name = "Ore Lead",
            icon = "materials/ez_resource_icons/lead ore.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/resourcecube.mdl",
                material = "models/mat_jack_gmod_leadore"
            }
        })

        Resources.Add("medicalsupplies", {
            name = "Medical Supplies",
            icon = "materials/ez_resource_icons/medical supplies.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/hard_case_b.mdl",
                material = "models/kali/props/cases/hardcase/jardcase_b"
            }
        })

        Resources.Add("munitions", {
            name = "Munition",
            icon = "materials/ez_resource_icons/munitions.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/items/BoxJMunitions.mdl",
                material = "models/mat_jack_gmod_ezmunitionbox"
            }
        })

        Resources.Add("nutrients", {
            name = "Nutrient",
            icon = "materials/ez_resource_icons/nutrients.png",
            auto_entity = true,
            entity = {
                model = "models/stek_resources/organics01.mdl",
            }
        })

        Resources.Add("oil", {
            name = "Oil",
            icon = "materials/ez_resource_icons/oil.png",
            auto_entity = true,
            entity = {
                model = "models/stek_resources/barrel02.mdl"
            }
        })

        Resources.Add("organics", {
            name = "Organics",
            icon = "materials/ez_resource_icons/organics.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/plastic_crate25a.mdl"
            }
        })

        Resources.Add("paper", {
            name = "Paper",
            icon = "materials/ez_resource_icons/paper.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/ez_paper.mdl",
                color = Color(200, 200, 200)
            }
        })

        Resources.Add("plastic", {
            name = "Plastic",
            icon = "materials/ez_resource_icons/plastic.png",
            auto_entity = true,
            entity = {
                model = "models/hunter/blocks/cube05x05x05.mdl",
                color = Color(200, 200, 200)
            }
        })

        Resources.Add("platinum", {
            name = "Platinum",
            icon = "materials/ez_resource_icons/platinum.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/ingot001.mdl",
                material = "models/props_mining/ingot_jack_platinum",
                color = Color(170, 160, 165)
            }
        })

        Resources.Add("platinumore", {
            name = "Ore Platinum",
            icon = "materials/ez_resource_icons/platinum ore.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/resourcecube.mdl",
                material = "models/mat_jack_gmod_platinumore"
            }
        })

        Resources.Add("precisionparts", {
            name = "Precision Parts",
            icon = "materials/ez_resource_icons/precision parts.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/hard_case_b.mdl"
            }
        })

        Resources.Add("propellant", {
            name = "Propellant",
            icon = "materials/ez_resource_icons/propellant.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/propellent.mdl",
                material = "models/entities/mat_jack_powderbottle"
            }
        })

        Resources.Add("rubber", {
            name = "Rubber",
            icon = "materials/ez_resource_icons/rubber.png",
            auto_entity = true,
            entity = {
                model = "models/stek_resources/tirestack01.mdl"
            }
        })

        Resources.Add("sand", {
            name = "Sand",
            icon = "materials/ez_resource_icons/sand.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/sandbag.mdl",
                color = Color(255, 237, 197)
            }
        })

        Resources.Add("silver", {
            name = "Silver",
            icon = "materials/ez_resource_icons/silver.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/ingot001.mdl",
                material = "models/props_mining/ingot_jack_silver",
                color = Color(150, 150, 150)
            }
        })

        Resources.Add("silverore", {
            name = "Ore Silver",
            icon = "materials/ez_resource_icons/silver ore.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/resourcecube.mdl",
                material = "models/mat_jack_gmod_silverore"
            }
        })

        Resources.Add("steel", {
            name = "Steel",
            icon = "materials/ez_resource_icons/steel.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/ingot001.mdl",
                material = "models/props_mining/ingot_jack_steel",
                color = Color(50, 50, 50)
            }
        })

        Resources.Add("titanium", {
            name = "Titanium",
            icon = "materials/ez_resource_icons/titanium.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/ingot001.mdl",
                material = "models/props_mining/ingot_jack_titanium",
                color = Color(160, 160, 160)
            }
        })

        Resources.Add("titaniumore", {
            name = "Ore Titanium",
            icon = "materials/ez_resource_icons/titanium ore.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/resourcecube.mdl",
                material = "models/mat_jack_gmod_titaniumore"
            }
        })

        Resources.Add("tungsten", {
            name = "Tungsten",
            icon = "materials/ez_resource_icons/tungsten.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/ingot001.mdl",
                material = "models/props_mining/ingot_jack_tungsten",
                color = Color(150, 150, 170)
            }
        })

        Resources.Add("tungstenore", {
            name = "Ore Tungsten",
            icon = "materials/ez_resource_icons/tungsten ore.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/resourcecube.mdl",
                material = "models/mat_jack_gmod_tungstenore"
            }
        })

        Resources.Add("uranium", {
            name = "Uranium",
            icon = "materials/ez_resource_icons/uranium.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/ingot001.mdl",
                material = "models/props_mining/ingot_jack_uranium",
                color = Color(50, 55, 50)
            }
        })

        Resources.Add("uraniumore", {
            name = "Ore Uranium",
            icon = "materials/ez_resource_icons/uranium ore.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/resourcecube.mdl",
                material = "models/mat_jack_gmod_uraniumore"
            }
        })

        Resources.Add("water", {
            name = "Water",
            icon = "materials/ez_resource_icons/water.png",
            auto_entity = true,
            entity = {
                model = "models/stek_resources/barrel01.mdl"
            }
        })

        Resources.Add("wood", {
            name = "Wood",
            icon = "materials/ez_resource_icons/wood.png",
            auto_entity = true,
            entity = {
                model = "models/jmod/resources/ez_wood.mdl",
                color = Color(100, 100, 100)
            }
        })
    end
end