local player = ax.player.meta or FindMetaTable("Player")

function player:IsCombine()
    return self:Team() == FACTION_MPF or self:Team() == FACTION_OTA
end

function player:IsMetrocop()
    return self:Team() == FACTION_MPF
end

function player:IsOWSoldier()
    return self:Team() == FACTION_OTA
end
