AddCSLuaFile()

---

SWEP.Spawnable = true

SWEP.PrintName = "STek Hands"
SWEP.Author = "sekta"

---

SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = ""

---

function SWEP:Initialize()
    self:SetHoldType("fist")
end