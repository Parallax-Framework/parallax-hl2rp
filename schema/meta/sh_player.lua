local PLAYER = FindMetaTable("Player")

function PLAYER:IsCombine()
    return self:Team() == FACTION_MPF or self:Team() == FACTION_OTA
end