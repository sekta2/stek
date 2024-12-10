function s_res.holo(ent, relPos, relAng, scale, renderDist, renderFunc, absolutePositions)
    if absolutePositions then
        if EyePos():Distance(relPos) < renderDist then
            cam.Start3D2D(relPos, relAng, scale)
            renderFunc()
            cam.End3D2D()
        end

        return
    end

    local Ang, Pos = Angle(0, 0, 0), Vector(0, 0, 0)

    if IsValid(ent) and ent.GetAngles then
        Ang = ent:GetAngles()
        Pos = ent:GetPos()
    else -- we're using world coordinates
        Pos = relPos
        Ang = relAng
    end

    local Right, Up, Forward = Ang:Right(), Ang:Up(), Ang:Forward()

    if EyePos():Distance(Pos) < renderDist then
        if ent then
            Ang:RotateAroundAxis(Right, relAng.p)
            Ang:RotateAroundAxis(Up, relAng.y)
            Ang:RotateAroundAxis(Forward, relAng.r)
        end

        local RenderPos = Pos + relPos.x * Right + relPos.y * Forward + relPos.z * Up

        -- world coords
        if not ent then
            RenderPos = Pos + Vector(0, 0, 50)
        end

        cam.Start3D2D(RenderPos, Ang, scale)
        renderFunc()
        cam.End3D2D()
    end
end

function s_res.resource_display(type, amt, maximum, x, y, siz, vertical, font, opacity, rateDisplay, brite, showunits)
    font = font or "s_res.title"
    opacity = opacity or 150
    brite = brite or 200

    local res = s_res.get_by_id(type)
    local name = res.name

    surface.SetDrawColor(255, 255, 255, opacity)
    surface.SetMaterial(res.icon)
    surface.DrawTexturedRect(x - siz / 2, y - siz / 2, siz, siz)

    local Col = Color(brite, brite, brite, opacity)
    local UnitText = tostring(amt) .. " ШТУК"

    if rateDisplay then
        UnitText = tostring(amt) .. " В СЕКУНДУ"
    end

    if vertical then
        draw.SimpleText(name, font, x, y - siz / 2 - 10, Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        if not showunits then
            draw.SimpleText(UnitText, font, x, y + siz / 2 + 10, Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        end
    else
        draw.SimpleText(name, font, x - siz / 2 - 10, y, Col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        if not showunits then
            draw.SimpleText(UnitText, font, x + siz / 2 + 10, y, Col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end
end
