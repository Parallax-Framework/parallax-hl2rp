FACTION.name = "Vortigaunt"
FACTION.description = "Inter-dimensional aliens freed from the Nihilanth who now wield vortessence alongside humanity. They mend wounds, guide resistance strategy and share ancient knowledge."
FACTION.color = Color(60, 140, 60)

FACTION.image = ax.util:GetMaterial("parallax/hl2rp/banners/vortigaunt.png")

FACTION.models = {
    "models/vortigaunt.mdl",
    "models/vortigaunt_blue.mdl"
}

FACTION_VORTIGAUNT = FACTION.index

ax.animations:SetModelClass("models/vortigaunt.mdl", "vortigaunt")
ax.animations:SetModelClass("models/vortigaunt_blue.mdl", "vortigaunt")
