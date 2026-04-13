
ENT.Type = "anim"

if WireLib then
    ENT.Base = "base_wire_entity"
else
    ENT.Base = "base_gmodentity" -- :(; what mate, what happened
end

ENT.PrintName       = "Combine Forcefield Socket"
ENT.Category        = "Parallax: HL2RP"
ENT.Spawnable       = true
ENT.AdminOnly       = false
ENT.RenderGroup     = RENDERGROUP_BOTH
ENT.Editable = true

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "IsPowered", { KeyName = "ispowered", Edit = { type = "Bool", order = 1 } })

    if SERVER then
        self:SetIsPowered(true)

        self:NetworkVarNotify( "IsPowered", function( _, _, _, new )
            if ( IsValid(self) ) then return end
            if ( new != true ) then return end

            self:MakeALilSpark()
        end )
    end
end
