function ax.player.meta:IsCombine()
    return self:Team() == FACTION_MPF or self:Team() == FACTION_OTA
end

function ax.player.meta:IsMetrocop()
    return self:Team() == FACTION_MPF
end

function ax.player.meta:IsOWSoldier()
    return self:Team() == FACTION_OTA
end
