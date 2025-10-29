function SCHEMA:PlayerFootstep(client, position, foot, soundName, volume)
    if ( client:IsSprinting() ) then
        if ( client:Team() == FACTION_MPF ) then
            client:EmitSound("npc/metropolice/gear" .. math.random(1, 6) .. ".wav", 80, 100, 1, CHAN_AUTO)

            return true
        elseif ( client:Team() == FACTION_OTA ) then
            client:EmitSound("npc/combine_soldier/gear" .. math.random(1, 6) .. ".wav", 80, 100, 1, CHAN_AUTO)

            return true
        end
    end
end

function SCHEMA:PostPlayerLoadout(client)
    client:SetCanZoom(client:IsCombine())

    if ( client:IsCombine() ) then
        if ( client:Team() == FACTION_MPF ) then
            client:SetArmor(50)
        else
            client:SetArmor(100)
        end
    end
end

function SCHEMA:PlayerUse(client, entity)
    if ( !IsValid(entity) or !entity:RateLimit("use", 1) ) then return end

    local isAdminFaction = client:Team() == FACTION_ADMIN
    if ( ( client:IsCombine() or isAdminFaction ) and entity:GetClass() == "func_door" and ( !entity:HasSpawnFlags(256) and !entity:HasSpawnFlags(1024) ) ) then
        entity:Fire("Open", "", 0)
        entity:EmitSound("buttons/combine_button1.wav", 70, 100, 0.5, CHAN_AUTO)
    end
end

function SCHEMA:PlayerSwitchFlashlight(client, enabled)
    return client:IsCombine()
end
