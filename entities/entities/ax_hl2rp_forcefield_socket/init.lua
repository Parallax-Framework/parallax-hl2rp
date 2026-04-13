AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local vector_up = Vector(0, 0, 1)

function ENT:SpawnFunction(_, tr, class)
    if ( !tr.Hit ) then return end

    local ent = ents.Create(class)
    if ( !IsValid(ent) ) then return end

    local hitNormal = tr.HitNormal
    local offset = hitNormal:Cross(vector_up) * 12.5
    offset = offset + -hitNormal

    ent:SetPos(tr.HitPos + offset)
    ent:SetAngles(hitNormal:Angle())
    ent:Spawn()

    return ent
end

function ENT:Initialize()
    self:SetModel("models/props_lab/tpplugholder_single.mdl")

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    -- stop annoying bouncing off plug, when plugged after spawning!
    --CAMPAIGN_ENTS.EasyFreeze( self )

    local physicsObject = self:GetPhysicsObject()
    if ( IsValid(physicsObject) ) then
        physicsObject:EnableMotion(false)
    end

    if not WireLib then return end
    self.Inputs = Wire_CreateInputs( self, { "Powered" } )
end

function ENT:TriggerInput( iname, value )
    if ( iname == "Powered" ) then
        self:SetIsPowered( value >= 1 )
    end
end

function ENT:MakeALilSpark()
    self:EmitSound("ambient/energy/spark" .. math.random(6) .. ".wav")
    effect = EffectData()
    effect:SetOrigin(self:WorldSpaceCenter())
    effect:SetEntity(self)
    effect:SetMagnitude(2)
    effect:SetScale(2)
    effect:SetRadius(2)

    util.Effect("ElectricSpark", effect, true, true)
end
