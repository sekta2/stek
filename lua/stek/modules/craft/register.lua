return function(Craft)
    function Craft.Init()
        ---@class CraftModule
        Craft = Craft

        Craft.Create("test", {
            name = "Krutoi test  craft",
            description = "opis",

            resources = {
                ["basicparts"] = 5,
                ["power"] = 2
            },

            output = {
                type = "resource",
                data = {
                    resource = "chemicals",
                    amount = 10
                }
            }
        })
    end
end
