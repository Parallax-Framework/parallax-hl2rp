--DOES WORK WHEN DUPED!

AddCSLuaFile("cl_init.lua") -- Make sure clientside
AddCSLuaFile("shared.lua") -- and shared scripts are sent.
include("shared.lua")

-- Forcefield is taken from Campaign entities, which waws taken from nutscript, which is released under a MIT License. ( which was then taken by straw w wagen for campaign entities )
-- https://steamcommunity.com/sharedfiles/filedetails/?id=2001220293
-- https://github.com/Chessnut/hl2rp/blob/1.1/LICENSE

local upFourty = Vector(0, 0, 40)

function ENT:SpawnFunction(client, trace)
    local angles = ( client:GetPos() - trace.HitPos ):Angle()
    angles.p = 0
    angles.r = 0

    local snapToFloorTrace = {}
    snapToFloorTrace.start = trace.HitPos + upFourty
    snapToFloorTrace.endpos = trace.HitPos + -upFourty * 10

    local snapToFloorTraceR = util.TraceLine( snapToFloorTrace )

    angles:RotateAroundAxis( angles:Up(), 270 )
    local entity = ents.Create( "ax_hl2rp_forcefield" )
    entity:SetCreator(client)
    entity:SetPos(snapToFloorTraceR.HitPos + upFourty)
    entity:SetAngles(angles:SnapTo("y", 45))
    entity:Spawn()
    entity:SetName( "ax.forcefield." .. entity:GetCreationID() )

    return entity

end
function ENT:SetupSessionVars()
    local selfTable = self:GetTable()

    selfTable.doDissolveTime = 0
    selfTable.nextCreateSound = 0
    selfTable.redoTheShieldSound = 0
    selfTable.buzzerSoundsPlaying = {}
    selfTable.fieldShouldCollideCache = {}
    selfTable.field_loopingSound = nil
    selfTable.field_loopingSoundDummy = nil
    selfTable.oldPositionProductLeng = 0
    selfTable.shieldIsOn = true -- starts on?!?!?
    selfTable.isForceField = true
end

local forceFields = {}

function ENT:Initialize()
    forceFields[self] = true
    self:UpdateShouldCollideHook()

    self:CallOnRemove( "campaignents_removefrom_forcefieldcache", function( me )
        forceFields[me] = nil
        me:UpdateShouldCollideHook()
    end)

    self:SetupSessionVars()

    self:SetName("ax.forcefield." .. self:GetCreationID())
    self:SetModel("models/props_combine/combine_fence01b.mdl")

    self:DrawShadow(false)

    local selfPos = self:GetPos()
    local selfAngles = self:GetAngles()
    local selfTable = self:GetTable()

    selfTable.startDummy = ents.Create("prop_physics")
    selfTable.startDummy:SetModel("models/props_combine/combine_fence01b.mdl")
    selfTable.startDummy:SetPos(selfPos)
    selfTable.startDummy:SetAngles(selfAngles)
    selfTable.startDummy:Spawn()
    selfTable.startDummy:SetName("ax.forcefield." .. self:GetCreationID() .. ".dummystart")
    selfTable.startDummy.DoNotDuplicate = true

    selfTable.startDummy:SetOwner(self)
    self:DeleteOnRemove(selfTable.startDummy)
    self:SetDummyStart(selfTable.startDummy)

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_NONE)

    self:AddSolidFlags(FSOLID_CUSTOMRAYTEST)
    self:SetCustomCollisionCheck(true)
    self:EnableCustomCollisions(true)

    self:DoShieldCollisions()

    local phys = self:GetPhysicsObject()
    if ( IsValid(phys) ) then
        phys:EnableMotion(false)
    end

    phys = selfTable.startDummy:GetPhysicsObject()
    if ( IsValid(phys) ) then
        phys:EnableMotion(false)
    end

    timer.Simple( 0, function()
        if ( !IsValid(self) ) then return end

        local dummyEndPos = selfTable.dummyEndPos
        local dummyEndAng = selfTable.dummyEndAng
        if not dummyEndPos or not dummyEndAng then
            dummyEndAng = selfAngles

            local dummyEndTrData = {}
            dummyEndTrData.start = selfPos + self:GetRight() * -16
            dummyEndTrData.endpos = selfPos + self:GetRight() * -800
            dummyEndTrData.filter = { self, self:GetCreator() }

            local dummyEndTrace = util.TraceLine( dummyEndTrData )
            dummyEndPos = dummyEndTrace.HitPos
        end

        selfTable.endDummy = ents.Create("prop_physics")
        selfTable.endDummy:SetModel("models/props_combine/combine_fence01a.mdl")
        selfTable.endDummy:SetPos(dummyEndPos)
        selfTable.endDummy:SetAngles(dummyEndAng)
        selfTable.endDummy:Spawn()
        selfTable.endDummy:SetName("ax.forcefield." .. self:GetCreationID() .. ".dummyend")
        selfTable.endDummy.DoNotDuplicate = true

        selfTable.endDummy:SetOwner(self)
        self:DeleteOnRemove(selfTable.endDummy)
        self:SetDummyEnd(selfTable.endDummy)

        --CAMPAIGN_ENTS.EasyFreeze( self.endDummy )

        phys = selfTable.endDummy:GetPhysicsObject()
        if ( IsValid(phys) ) then
            phys:EnableMotion(false)
        end
    end )
end

function ENT:SpawnMyPlug()
    local plug = ents.Create( "ax_hl2rp_forcefield_plug" )
    local plugPos, plugAng = nil, nil

    local selfTable = self:GetTable()
    if selfTable.plugDupedPos and selfTable.plugDupedAng then
        plugPos = selfTable.plugDupedPos
        plugAng = selfTable.plugDupedAng

    else
        plugPos = selfTable.startDummy:GetPos() + selfTable.startDummy:GetRight() * -20.525 + selfTable.startDummy:GetUp() * -16
        plugAng = selfTable.startDummy:GetAngles()
    end

    plug.DoNotDuplicate = true

    plug:SetPos( plugPos )
    plug:SetAngles( plugAng )
    plug:SetModel( "models/props_lab/tpplug.mdl" )
    plug:Activate()
    plug:SetName( "ax.forcefield.plug" .. self:GetCreationID() )
    plug:Spawn()

    constraint.Rope( plug, self.startDummy, 0, 0, Vector( 11, 0, 0 ), Vector( 0, 12, 5 ), 350, 0, 0, 2.5, "Cable/cable2", false )

    self:GetTable().forcefield_Plug = plug
    self:DeleteOnRemove(plug)
end

function ENT:OnDuplicated()
    self.duplicatedIn = true
    self:SetupSessionVars()

end


duplicator.RegisterEntityModifier( "forcefield_wheremyplugwas", function( _, pasted, offsets )
    if offsets.posOffset and offsets.angOffset then
        pasted.plugDupedPos = pasted:LocalToWorld( offsets.posOffset )
        pasted.plugDupedAng = pasted:LocalToWorldAngles( offsets.angOffset )

    end

    if offsets.dummyEndPosOffset and offsets.dummyEndAngOffset then
        pasted.dummyEndPos = pasted:LocalToWorld( offsets.dummyEndPosOffset )
        pasted.dummyEndAng = pasted:LocalToWorldAngles( offsets.dummyEndAngOffset )

    end
end )

function ENT:PreEntityCopy()
    local offsets = {}
    local selfTable = self:GetTable()
    if IsValid( selfTable.forcefield_Plug ) then
        offsets.posOffset = self:WorldToLocal( selfTable.forcefield_Plug:GetPos() )
        offsets.angOffset = self:WorldToLocalAngles( selfTable.forcefield_Plug:GetAngles() )

    end

    if IsValid( selfTable.endDummy ) then
        offsets.dummyEndPosOffset = self:WorldToLocal( selfTable.endDummy:GetPos() )
        offsets.dummyEndAngOffset = self:WorldToLocalAngles( selfTable.endDummy:GetAngles() )

    end

    duplicator.StoreEntityModifier( self, "forcefield_wheremyplugwas", offsets )

end

function ENT:PositionsThink()
    local dummyStart = self:GetDummyStart()
    local dummyEnd = self:GetDummyEnd()
    if not IsValid( dummyStart ) then return end
    if not IsValid( dummyEnd ) then return end

    if dummyStart:GetPhysicsObject():IsMotionEnabled() then return false end
    if dummyEnd:GetPhysicsObject():IsMotionEnabled() then return false end

    local posProductLeng = ( dummyStart:GetPos() + dummyEnd:GetPos() ):LengthSqr()
    posProductLeng = math.Round( posProductLeng )

    if self.oldPositionProductLeng and self.oldPositionProductLeng == posProductLeng then return true end

    self.oldPositionProductLeng = posProductLeng

    self:SetPos( dummyStart:GetPos() )
    self:SetAngles( dummyStart:GetAngles() )

    return false

end

function ENT:Think()
    local tbl = self:GetTable()
    if tbl.Dead then SafeRemoveEntity( self ) return end

    local alwaysOn = tbl.GetAlwaysOn and self:GetAlwaysOn()

    if alwaysOn then
        SafeRemoveEntity( tbl.forcefield_Plug )
    elseif not IsValid( tbl.forcefield_Plug ) then
        self:SpawnMyPlug()
    end

    local positionsResult = self:PositionsThink()
    local broken = positionsResult == nil
    local beingMoved = positionsResult == false
    local isOn = alwaysOn or ( IsValid( tbl.forcefield_Plug ) and IsValid( tbl.forcefield_Plug.Shield_Socket ) and tbl.forcefield_Plug.Shield_Socket:GetIsPowered() )

    for entIndex, soundDat in pairs( tbl.buzzerSoundsPlaying ) do
        if ( !IsValid(soundDat.entity) ) then
            tbl.buzzerSoundsPlaying[ entIndex ] = nil
            continue
        end

        if ( !IsValid(soundDat.theSound) ) then
            tbl.buzzerSoundsPlaying[ entIndex ] = nil
            continue
        end

        if ( soundDat.stopTime < CurTime() ) then
            soundDat.theSound:Stop()
            soundDat.theSound = nil
            soundDat.entity:RemoveCallOnRemove( "stopplayingfieldsound" )
            soundDat.entity.field_BuzzerSound = nil
        end
    end

    if broken then
        tbl.Dead = true

        if tbl.shieldIsOn then
            tbl.shieldIsOn = nil
            TurnOff( self )
        end
    elseif beingMoved then
        if tbl.shieldIsOn then
            tbl.shieldIsOn = nil

            TurnOff( self )
        end
    elseif isOn and not tbl.shieldIsOn then
        tbl.shieldIsOn = true
        TurnOn( self )
    elseif not isOn and tbl.shieldIsOn then
        tbl.shieldIsOn = nil
        TurnOff( self )
    end

    if ( math.abs(self:GetCreationTime() - CurTime()) < 0.25 ) then return end

    local dummyEnd = self:GetDummyEnd()

    -- fix it not playing sometimes
    local redoTheShieldSound = tbl.redoTheShieldSound < CurTime()

    if tbl.shieldIsOn then
        if ( tbl.field_loopingSound ) then
            self:EmitSound( "campaign_entities/combineshield_activate.wav", 80, math.random( 95, 105 ) )
        end

        if ( !tbl.field_loopingSound or redoTheShieldSound ) then
            if ( tbl.field_loopingSound ) then
                tbl.field_loopingSound:Stop()
            end

            tbl.field_loopingSound = CreateSound(self, "ambient/machines/combine_shield_loop3.wav")
            tbl.field_loopingSound:Play()
            tbl.field_loopingSound:ChangeVolume(0.5, 0)
            tbl.redoTheShieldSound = CurTime() + math.random(10, 20)
        end

        if ( !tbl.field_loopingSoundDummy ) then
            dummyEnd:EmitSound( "campaign_entities/combineshield_activate.wav", 80, math.random( 95, 105 ) )
        end

        if ( !tbl.field_loopingSoundDummy or redoTheShieldSound ) then
            if ( tbl.field_loopingSoundDummy ) then
                tbl.field_loopingSoundDummy:Stop()
            end

            tbl.field_loopingSoundDummy = CreateSound(dummyEnd, "ambient/machines/combine_shield_loop3.wav")
            tbl.field_loopingSoundDummy:Play()
            tbl.field_loopingSoundDummy:ChangeVolume(0.5, 0)
            tbl.redoTheShieldSound = CurTime() + math.random(10, 20)

        end
    elseif not tbl.shieldIsOn then
        if tbl.field_loopingSound then
            self:EmitSound("campaign_entities/combineshield_deactivate.wav", 80, math.random( 95, 105 ))

            tbl.field_loopingSound:ChangeVolume(0, 0)
            tbl.field_loopingSound:Stop()
            tbl.field_loopingSound = nil
        end

        if tbl.field_loopingSoundDummy and IsValid( dummyEnd ) then
            dummyEnd:EmitSound("campaign_entities/combineshield_deactivate.wav", 80, math.random( 95, 105 ))

            tbl.field_loopingSoundDummy:ChangeVolume(0, 0)
            tbl.field_loopingSoundDummy:Stop()
            tbl.field_loopingSoundDummy = nil
        end
    end

    self:NextThink( CurTime() + 0.25 )
    return true
end

function ENT:TryToDissolve( entity )
    if self:GetTable().doDissolveTime < CurTime() then return end

    local dummyStart = self:GetDummyStart()
    local dummyEnd = self:GetDummyEnd()

    if ( ( entity == dummyStart ) or ( entity == dummyEnd ) ) then return end

    local dissolveDamage = DamageInfo()
    dissolveDamage:SetDamage( 10000 )
    dissolveDamage:SetDamageType( bit.bor( DMG_DISSOLVE ) )
    dissolveDamage:SetAttacker( self )
    dissolveDamage:SetInflictor( self )

    entity:TakeDamageInfo( dissolveDamage )
end

function ENT:StartTouch( entity )
    self:TryToDissolve( entity )
end

function ENT:Touch( entity )
    if ( self:GetSkin() != 0 ) then return end

    local selfTable = self:GetTable()

    local creationID = entity:GetCreationID()
    local soundDat = selfTable.buzzerSoundsPlaying[ creationID   ]
    if selfTable.nextCreateSound > CurTime() then return end
    if not soundDat or not soundDat.theSound then
        selfTable.nextCreateSound = CurTime() + 0.1
        local field_BuzzerSound = CreateSound( entity, "ambient/machines/combine_shield_touch_loop1.wav" )
        field_BuzzerSound:SetSoundLevel(65)
        field_BuzzerSound:Play()
        field_BuzzerSound:ChangeVolume(0, 0.5)

        selfTable.buzzerSoundsPlaying[ creationID ] = { entity = entity, theSound = field_BuzzerSound, stopTime = CurTime() + 0.5 }

        entity:CallOnRemove( "stopplayingfieldsound", function( ent )
            ent:StopSound( "ambient/machines/combine_shield_touch_loop1.wav" )
        end )
    else
        soundDat.theSound:SetSoundLevel(65)
        soundDat.theSound:ChangeVolume(0.5, 0)
        soundDat.theSound:ChangeVolume(0, 0.5)

        selfTable.buzzerSoundsPlaying[ creationID ].stopTime = CurTime() + 0.5

        entity:CallOnRemove("stopplayingfieldsound", function( ent )
            ent:StopSound("ambient/machines/combine_shield_touch_loop1.wav")
        end)
    end

end

function ENT:OnRemove()
    local selfTable = self:GetTable()
    if selfTable.field_BuzzerSound then
        selfTable.field_BuzzerSound:Stop()
        selfTable.field_BuzzerSound = nil
    end

    if selfTable.field_loopingSound then
        selfTable.field_loopingSound:ChangeVolume( 0, 0 )
        selfTable.field_loopingSound:Stop()
        selfTable.field_loopingSound = nil
    end

    if selfTable.field_loopingSoundDummy then
        selfTable.field_loopingSoundDummy:ChangeVolume( 0, 0 )
        selfTable.field_loopingSoundDummy:Stop()
        selfTable.field_loopingSoundDummy = nil
    end

    for _, ent in ipairs( ents.FindByName( "ax.forcefield." .. self:GetCreationID() .. ".*" ) ) do
        ent:Remove()
    end
end

local function isCombineModel( mdl )
    if ( !isstring(mdl) ) then return end
    local mdlLower = string.lower(mdl)

    if string.find( mdlLower, "combine", 1, true ) then return true end
    if string.find( mdlLower, "metrocop", 1, true ) then return true end
    if string.find( mdlLower, "civilprotection", 1, true ) then return true end
    if string.find( mdlLower, "police", 1, true )  then return true end
    if string.find( mdlLower, "breen", 1, true ) then return true end
    if string.find( mdlLower, "overwatch", 1, true ) then return true end

    return false
end

local combineClasses = {
    ["npc_combine_s"] = true,
    ["npc_metropolice"] = true,
    ["npc_rollermine"] = true,
    ["npc_manhack"] = true,
    ["npc_clawscanner"] = true,
    ["npc_cscanner"] = true,
    ["npc_helicopter"] = true,
    ["npc_combinedropship"] = true,
    ["npc_combinegunship"] = true,
    ["npc_hunter"] = true,
    ["npc_stalker"] = true,
    ["npc_strider"] = true,
    ["npc_turret_floor"] = true,
    ["npc_zombine"] = true, -- lol

}

ENT.AllowedTeams = {}
ENT.AllowedCityCodes = {}
local function plyShouldBeBlocked( ply, field )
    local mdl = ply:GetModel()
    if ( isCombineModel(mdl) ) then return false end

    local plyTeam = ply:Team()

    -- TODO
    -- if ( field.AllowedCityCodes[impulse.GetCityCode()] ) then return false end
    if ( field.AllowedTeams[plyTeam] ) then return false end

    return true
end

-- returns two vars
-- first, if it should collide, second, if the result should never be cached ( big optimisation )
local function fieldShouldCollideExpensive( field, colliding )
    local collidingsClass = colliding:GetClass()

    -- !!!!!!!! return false, ent can pass through no problem, return TRUE and ent will be stopped by shield !!!!!!!!
    -- result is then CACHED by each shield!
    -- always double check after you impliment hooks that work with other peoples stuff!
    local hookShouldCollide, hookBlockCaching = hook.Run( "campaignents_field_shouldcollide", field, colliding, collidingsClass )
    if hookShouldCollide != nil then
        return hookShouldCollide, hookBlockCaching

    elseif colliding:IsNPC() and !( combineClasses[collidingsClass] or isCombineModel(colliding:GetModel()) ) then
        return true
    elseif colliding:IsPlayer() and plyShouldBeBlocked( colliding, field ) then
        return true
    elseif colliding:IsVehicle() then
        local mdl = colliding:GetModel()
        local driver = colliding:GetDriver()
        if isCombineModel( mdl ) then
            return false
        elseif IsValid( driver ) and not plyShouldBeBlocked( driver, field ) then
            return false, true
        else
            return true, true
        end
    end

    return false
end

function ENT:ResetShouldCollideCache()
    self:GetTable().fieldShouldCollideCache = {}
end

local function fieldShouldCollideCheap( entA, entB )
    if ( !forceFields[entA] and !forceFields[entB] ) then return end

    local colliding
    local field

    local aIsForcefield = forceFields[entA]
    local bIsForcefield = forceFields[entB]

    if bIsForcefield then
        colliding = entA
        field = entB
    elseif aIsForcefield then
        colliding = entB
        field = entA
    end

    -- cache this for optomisation
    --[[
    local shouldCollide = field.fieldShouldCollideCache[ colliding:GetCreationID() ]

    if shouldCollide ~= nil then
        return shouldCollide

    end]]

    local blockCaching
    local shouldCollide, blockCaching = fieldShouldCollideExpensive( field, colliding, collidingsClass )

    --[[
    if blockCaching == true then return shouldCollide end

    field.fieldShouldCollideCache[ colliding:GetCreationID() ] = shouldCollide
    ]]
    return shouldCollide

end

local theHooksName = "campaignents_realistic_forcefield"
local hookExists

function ENT:UpdateShouldCollideHook()
    local shouldBeHook = table.Count( forceFields ) >= 1
    if shouldBeHook and not hookExists then
        hook.Add( "ShouldCollide", theHooksName, fieldShouldCollideCheap )
        hookExists = true
    elseif not shouldBeHook and hookExists then
        hookExists = nil
        hook.Remove( "ShouldCollide", theHooksName )
    end
end

function TurnOff( self )
    for _, ent in ipairs( ents.FindByName( "ax.forcefield." .. self:GetCreationID() .. ".*" ) ) do -- this code smells!
        ent:SetSkin( 1 )
        util.ScreenShake( ent:GetPos(), 0.25, 10, 0.25, 1500 )
    end

    timer.Simple( 0.05, function()
        if not IsValid( self ) then return end

        self:ResetShouldCollideCache()
        self:DoShieldCollisions()
    end )
end

function TurnOn( self )
    for _, ent in ipairs( ents.FindByName( "ax.forcefield." .. self:GetCreationID() .. ".*" ) ) do -- this too!
        ent:SetSkin( 0 )
        util.ScreenShake( ent:GetPos(), 2, 10, 0.25, 1500 )
    end

    timer.Simple( 0.05, function()
        if not IsValid( self ) then return end

        self:ResetShouldCollideCache()
        self:GetTable().doDissolveTime = CurTime() + 0.15

        self:DoShieldCollisions()
        self:TryToDissolveWithTraces()
    end )
end

local dissolveMaxs = Vector( 2, 2, 5 )
local dissolveMins = -dissolveMaxs

function ENT:TryToDissolveWithTraces()
    local dummyStart = self:GetDummyStart()
    local dummyEnd = self:GetDummyEnd()
    local dummyStartPos = dummyStart:GetPos()
    local dummyEndPos = dummyEnd:GetPos()
    local dummyStartUp = dummyStart:GetUp()
    local dummyEndUp = dummyEnd:GetUp()

    local damagedStuff = {}

    local doStart = -10
    local doEnd = 47 + doStart
    local sounds = 0

    for index = doStart, doEnd do
        local offset = index * 4

        local currStart = dummyStartPos + ( dummyStartUp * offset )
        local currEnd = dummyEndPos + ( dummyEndUp * offset )

        local found = ents.FindAlongRay( currStart, currEnd, dissolveMins, dissolveMaxs )
        for _, entity in ipairs( found ) do
            if ( fieldShouldCollideExpensive(self, entity) == false ) then continue end

            local creationID = entity:GetCreationID()
            if ( damagedStuff[creationID] ) then continue end

            local hadHealth = entity:Health() > 0

            self:TryToDissolve(entity)
            damagedStuff[ creationID ] = true

            if ( !hadHealth ) then continue end
            if ( sounds >= 5 ) then continue end

            sounds = sounds + 1

            timer.Simple( 0, function()
                if ( IsValid(entity) ) then return end
                if ( entity:Health() > 0 ) then return end

                entity:EmitSound("ambient/machines/slicer" .. math.random( 1, 4 ) .. ".wav", 75, 80)
            end )
        end
    end
end

hook.Add( "PlayerSpawn", "campaignents_resetshieldcaches", function(spawned)
    local forcefieldEnts = ents.FindByClass("ax_hl2rp_forcefield")
    for _ = 1, #forcefieldEnts do
        local field = forcefieldEnts[_]
        field:GetTable().fieldShouldCollideCache[spawned:GetCreationID()] = nil
    end
end )
