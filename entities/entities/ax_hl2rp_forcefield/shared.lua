ENT.Type            = "anim"
ENT.Base            = "base_anim"
ENT.PrintName       = "Combine Forcefield"
ENT.Category        = "Parallax: HL2RP"
ENT.Spawnable       = true
ENT.AdminOnly       = false
ENT.RenderGroup     = RENDERGROUP_BOTH
ENT.Editable = true
ENT.PhysgunDisabled = true

ENT.SUBMAT_FENCE_GLOW = 0
ENT.SUBMAT_FENCE_SIDEGLOW = 2

function ENT:SetupDataTables()
    -- for servers or something idk, good luck editing this without lua
    -- above comment is wrong, you can just edit it when the shield is on

    -- lmao, that was a fun thing to read

    self:NetworkVar("Bool", 1, "AlwaysOn", { KeyName = "alwayson", Edit = { type = "Bool", order = 2 } })

    self:NetworkVar("Entity", 0, "DummyStart")
    self:NetworkVar("Entity", 1, "DummyEnd")

    local i = 1
    -- not using ipairs, cus some teams have shitty indexes like and go like, 0, 1001, 1002
    local factions = ax.faction.instances
    for i = 1, #factions do
        local v = factions[i]

        local spacelessName = string.Replace( v.name, " ", "" )
        self:NetworkVar("Bool", i, "Allow " .. spacelessName, { KeyName = "allow_" .. string.lower(spacelessName), Edit = { category = "Teams", type = "Bool", order = i + 2 } })

        if ( SERVER ) then
            self:NetworkVarNotify( "Allow " .. spacelessName, function(ent, _name, _old, new)
                ent.AllowedTeams[k] = new == true and true or nil

                self:ResetShouldCollideCache()
            end)
        end

        i = i + 1
    end

    --[[
    for k, v in ipairs(HL2RP_CityCodes) do
        local spacelessName = string.Replace( v[1], " ", "" )

        self:NetworkVar("Bool", i, "Allow " .. spacelessName, { KeyName = "allow_" .. string.lower(spacelessName), Edit = { category = "City Codes", type = "Bool", order = i + 2 } })

        if ( SERVER ) then
            self:NetworkVarNotify( "Allow " .. spacelessName, function(ent, _name, _old, new)
                ent.AllowedCityCodes[k] = new == true and true or nil
            end)
        end

        i = i + 1
    end

    self:SetAllowCivil(true)
    ]]

    if SERVER then
        self:SetAlwaysOn( false )

        self:SetDummyEnd( nil )
        self:SetDummyStart( nil )
    end
end

if CLIENT then
    language.Add( "campaignents_forcefield_new", ENT.PrintName )

end

function ENT:DoShieldCollisions()
    local dummyEnd = self:GetDummyEnd()

    if ( !IsValid(dummyEnd) ) then return end

    local verts = {}
    local physMat = ""

    if self:GetSkin() == 0 then -- on
        local dummyEndPos = dummyEnd:GetPos()
        local dummyEndUp = dummyEnd:GetUp()
        verts = {
            {
                pos = Vector( 0, 0, -25 )
            },
            {
                pos = Vector( 0, 0, 150 )
            },
            {
                pos = self:WorldToLocal( dummyEndPos + dummyEndUp * 150 )
            },
            {
                pos = self:WorldToLocal( dummyEndPos + dummyEndUp * 150 )
            },
            {
                pos = self:WorldToLocal( dummyEndPos + -dummyEndUp * 25 )
            },
            {
                pos = Vector( 0, 0, -25 )
            },
        }
        physMat = "Default_silent"

    else
        verts = {
            {
                pos = Vector( 0, 0, -25 )
            },
            {
                pos = Vector( 0, 0, 150 )
            },
            {
                pos = Vector( 0, 15, 150 )
            },
            {
                pos = Vector( 0, 15, 150 )
            },
            {
                pos = Vector( 0, 15, -25 )
            },
            {
                pos = Vector( 0, 0, 25 )
            },
        }
        physMat = "Metal"

    end

    self:PhysicsFromMesh( verts )
    local object = self:GetPhysicsObject()
    object:SetMaterial( physMat )
    object:EnableMotion( false )

    return true

end

-- let bullets thru!
local sent_contents = CONTENTS_GRATE
local bit_band = bit.band
function ENT:TestCollision( _, _, _, _, mask )
    if bit_band( mask, sent_contents ) != 0 then return true end
end
