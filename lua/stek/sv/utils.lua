
--[[---------------------------------------------------------

	stek.CreateExplosion( vector_origin, angle_zero, ply, 128,
	 256, 32 + 64, ply, 6144, DMG_BURN, ply, "prop_physics" )

	Creates CEnvExplosion entity with a lot of options

	inflictor = ent that "created" an explosion ( grenade )

	attacker = entity that caused an explosion creation
	( player that pulled the pin  )

-----------------------------------------------------------]]

---@param pos Vector
---@param ang Angle
---@param attacker Entity?
---@param magnitude number
---@param radius number
---@param flags number
---@param inflictor Entity?
---@param force Vector
---@param dmgType DMG
---@param ignore Entity
---@param ignoreClass string
function stek.CreateExplosion( pos, ang, attacker, magnitude, radius, flags, inflictor, force, dmgType, ignore, ignoreClass )

	local explosion = ents.Create( "env_explosion" )

	explosion:SetPos( pos )
	explosion:SetAngles( ang )
	explosion:SetParent( inflictor )

	explosion:SetKeyValue( "iMagnitude", tostring( magnitude ) )

	if flags then
		explosion:AddSpawnFlags( flags )
	end

	if radius then
		explosion:SetKeyValue( "iRadiusOverride", tostring( radius ) )
	end

	if force ~= 0 then
		explosion:SetKeyValue( "DamageForce", tostring( force ) )
	end

	explosion:SetSaveValue( "m_hInflictor", inflictor )

	if ignore then
		explosion:SetSaveValue( "m_hEntityIgnore", ignore )
	end

	if ignoreClass then
		explosion:SetSaveValue( "m_iClassIgnore", ignoreClass )
	end

	if dmgType then
		explosion:SetSaveValue( "m_iCustomDamageType", dmgType )
	end

	explosion:SetRenderMode( RENDERMODE_TRANSADD )
	explosion:SetOwner( attacker )
	explosion:Spawn()

	explosion:Fire( "Explode", 0, 0 )

end

--- World Bounds

local function any_positions_visible(stort, eyund, offsets)
    if not (stort and eyund) then return false end

    for k, v in pairs(offsets) do
        local Tr = util.TraceLine({
            start = stort + Vector(0, 0, v[1]),
            endpos = eyund + Vector(0, 0, v[2])
        })

        if not Tr.Hit then return true end
    end

    return false
end

---@param iter integer
---@return number x_min
---@return number x_max
---@return number y_min
---@return number y_max
---@return number z_min
---@return number z_max
function stek.determineMapBounds(iter)
    local x_min, x_max, y_min, y_max, z_min, z_max, sky_cam_pos = 9e9, -9e9, 9e9, -9e9, 9e9, -9e9, nil

    for _, v in pairs(ents.FindByClass("sky_camera")) do
        sky_cam_pos = v:GetPos()
    end

    for _ = 1, iter do
        local pos = Vector(math.random(-20000, 20000), math.random(-20000, 20000), math.random(-20000, 20000))

        if util.IsInWorld(pos) then
            if not any_positions_visible(sky_cam_pos, pos, {
                    { 0,    0 },
                    { 1000, 0 },
                    { 0,    500 },
                    { 0,    -500 },
                    { 0,    1000 },
                    { 1000, 1000 }
                }) then
                x_min = math.min(x_min, pos.x)
                x_max = math.max(x_max, pos.x)
                y_min = math.min(y_min, pos.y)
                y_max = math.max(y_max, pos.y)
                z_min = math.min(z_min, pos.z)
                z_max = math.max(z_max, pos.z)
            end
        end
    end

    z_max = z_max * .9

    return x_min, x_max, y_min, y_max, z_min, z_max
end
