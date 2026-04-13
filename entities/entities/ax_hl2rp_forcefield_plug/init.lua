AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SetupSessionVars()
    local selfTable = self:GetTable()
    selfTable.Shield_CanPlug = true
    selfTable.Shield_Plugged = false
end

function ENT:Initialize()
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetMoveType(MOVETYPE_VPHYSICS)

    self:SetupSessionVars()
    self:SetModel("models/props_lab/tpplug.mdl")

    self:PhysWake()

    local result = util.QuickTrace(self:WorldSpaceCenter(), -self:GetForward() * 100, self)

    if ( !IsValid(result.Entity) ) then return end
    self:TryToPlugInto(result.Entity)

end

function ENT:MakeALilSpark()
    self:EmitSound("ambient/energy/spark" .. math.random( 1, 6 ) .. ".wav")
    effect = EffectData()
    effect:SetOrigin(self:GetPos())
    effect:SetEntity(self)
    effect:SetMagnitude(2)
    effect:SetScale(2)
    effect:SetRadius(2)

    util.Effect("ElectricSpark", effect, true, true)

end

function ENT:TryToPlugInto( socket )
    if ( !IsValid(socket) ) then return end

    local selfTable = self:GetTable()
    if ( selfTable.Shield_Plugged != false or selfTable.Shield_CanPlug != true ) then return end
    if ( socket:GetModel() != "models/props_lab/tpplugholder_single.mdl" ) then return end

    selfTable.Shield_Plugged = true
    selfTable.Shield_Socket = socket
    self:ForcePlayerDrop()

    self:SetPos(socket:GetPos() + socket:GetForward() * 5 + socket:GetUp() * 10 + socket:GetRight() * -13)
    self:SetAngles(socket:GetAngles() * 1)

    self.pluggingConstraint = constraint.Weld(self, socket, 0, 0, 5000, true, false)

    self.pluggingConstraint:CallOnRemove("unplugged", function()
        if ( !IsValid(self) ) then return end

        self:TryToUnplug()

        if ( IsValid(socket) and socket:GetIsPowered() ) then
            self:MakeALilSpark()
        end
    end)

    if ( IsValid(socket) and socket:GetIsPowered() ) then
        self:MakeALilSpark()
    end
end

function ENT:TryToUnplug()
    local selfTable = self:GetTable()
    if ( selfTable.Shield_Plugged != true ) then return end

    selfTable.Shield_CanPlug = false
    timer.Simple( 0.5, function()
        if ( !IsValid(self) ) then return end

        selfTable.Shield_CanPlug = true
    end )

    selfTable.Shield_Plugged = false
    selfTable.Shield_Socket = nil
    self:SetPos( self:GetPos() + self:GetForward() * 8 )

    if ( IsValid(self.pluggingConstraint) ) then
        SafeRemoveEntity( self.pluggingConstraint )

    end

    timer.Simple( 0.01, function()
        if ( !IsValid(self) ) then return end

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:EnableMotion(true)
            phys:Wake()
        end
    end )
end

function ENT:StartTouch(other)
    self:TryToPlugInto(other)
end

function ENT:Use(user)
    self:TryToUnplug()
    user:PickupObject(self)
end

function ENT:OnTakeDamage(dmgInfo)
    self:TakePhysicsDamage(dmgInfo)

    if dmgInfo:GetDamage() <= 50 then return end

    self:TryToUnplug()
end
