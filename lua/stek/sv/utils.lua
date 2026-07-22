
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
