function ax.character.meta:IsCombine()
    return self:GetFaction() == FACTION_MPF or self:GetFaction() == FACTION_OTA
end

function ax.character.meta:IsMetrocop()
    return self:GetFaction() == FACTION_MPF
end

function ax.character.meta:IsOWSoldier()
    return self:GetFaction() == FACTION_OTA
end
