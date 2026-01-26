local elements, _ = file.Find("stek/modules/gui/elements/*.lua", "LUA")

for i = 1, #elements do
    local filename = elements[i]
    stek.client("elements/" .. filename)
end

stek.client("dev.lua")
