local function GetPreferredCarryAngles(ent, ply)
    if ent.IsStekResource then
        return ent.CarryAngles or angle_zero
    end
end

hook.Add("GetPreferredCarryAngles", "stek.carry_angles", GetPreferredCarryAngles)