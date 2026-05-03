local player = ax.player.meta or FindMetaTable("Player")

--- Returns whether this player belongs to any Combine faction.
-- Includes both Civil Protection and Overwatch Transhuman Arm factions.
-- @realm shared
-- @return boolean True if the player's team is `FACTION_MPF` or `FACTION_OTA`.
-- @usage if ( client:IsCombine() ) then
--     print("Player is Combine.")
-- end
function player:IsCombine()
    return self:Team() == FACTION_MPF or self:Team() == FACTION_OTA
end

--- Returns whether this player is a metrocop.
-- Checks whether the player's current team is the Civil Protection faction.
-- @realm shared
-- @return boolean True if the player's team is `FACTION_MPF`.
-- @usage if ( client:IsMetrocop() ) then
--     print("Player is Civil Protection.")
-- end
function player:IsMetrocop()
    return self:Team() == FACTION_MPF
end

--- Returns whether this player is an Overwatch soldier.
-- Checks whether the player's current team is the Overwatch Transhuman Arm faction.
-- @realm shared
-- @return boolean True if the player's team is `FACTION_OTA`.
-- @usage if ( client:IsOWSoldier() ) then
--     print("Player is OTA.")
-- end
function player:IsOWSoldier()
    return self:Team() == FACTION_OTA
end
