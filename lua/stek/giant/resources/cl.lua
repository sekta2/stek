local vec50 = Vector(0, 0, 50)
local EyePos = EyePos

--[[------------------------]]--

function s_res.holo(ent, relPos, relAng, scale, renderDist, renderFunc, absolutePositions)
    renderDist = renderDist^2

    local eyepos = EyePos()
    if absolutePositions then
        if eyepos:DistToSqr(relPos) < renderDist then
            cam.Start3D2D(relPos, relAng, scale)
            renderFunc()
            cam.End3D2D()
        end

        return
    end

    local Ang, Pos = relAng, relPos

    if IsValid(ent) and ent.GetAngles then
        Ang = ent:GetAngles()
        Pos = ent:GetPos()
    end

    local Right, Up, Forward = Ang:Right(), Ang:Up(), Ang:Forward()

    if eyepos:DistToSqr(Pos) < renderDist then
        if ent then
            Ang:RotateAroundAxis(Right, relAng.p)
            Ang:RotateAroundAxis(Up, relAng.y)
            Ang:RotateAroundAxis(Forward, relAng.r)
        end

        local RenderPos = Vector(Pos)
        RenderPos:Add(relPos.x * Right)
        RenderPos:Add(relPos.y * Forward)
        RenderPos:Add(relPos.z * Up)

        -- world coords
        if not ent then
            RenderPos = Pos + vec50
        end

        cam.Start3D2D(RenderPos, Ang, scale)
        renderFunc()
        cam.End3D2D()
    end
end

--[[------------------------]]--

local surfaceSDC = surface.SetDrawColor
local surfaceSM = surface.SetMaterial
local surfaceDTR = surface.DrawTexturedRect
local surfaceST = draw.SimpleText

local cached = {}

--[[------------------------]]--

function s_res.resource_display(type, amt, maximum, x, y, siz, vertical, font, opacity, rateDisplay, brite, showunits)
    font = font or "s_res.title"
    opacity = opacity or 150
    brite = brite or 200

    local res = s_res.get_by_id(type)
    local name = res.name

    surfaceSDC(255, 255, 255, opacity)
    surfaceSM(res.icon)
    surfaceDTR(x - siz / 2, y - siz / 2, siz, siz)

    local Col = cached[brite]

    if not Col then
        Col = Color(brite, brite, brite, opacity)
        cached[brite] = Col
    end

    local UnitText = tostring(amt) .. " ЮНИТОВ"

    if rateDisplay then
        UnitText = tostring(amt) .. " В СЕКУНДУ"
    end

    if vertical then
        surfaceST(name, font, x, y - siz / 2 - 10, Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        if not showunits then
            surfaceST(UnitText, font, x, y + siz / 2 + 10, Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        end
    else
        surfaceST(name, font, x - siz / 2 - 10, y, Col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        if not showunits then
            surfaceST(UnitText, font, x + siz / 2 + 10, y, Col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end
end
