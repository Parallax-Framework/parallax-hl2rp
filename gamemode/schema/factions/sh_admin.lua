FACTION.name = "City Administration"
FACTION.description = "The public face of Combine rule, spearheaded by the City Administrator and loyal aides. They disseminate propaganda, manage quotas and coordinate with Civil Protection."
FACTION.color = Color(125, 60, 160)

FACTION.image = ax.util:GetMaterial("parallax/hl2rp/banners/admin.png")

FACTION.models = {
    "models/breen.mdl"
}

FACTION_ADMIN = FACTION.index

for i = 1, #FACTION.models do
    local model = FACTION.models[i]
    util.PrecacheModel(model)
    ax.animations:SetModelClass(model, string.find(model, "female") and "citizen_female" or "citizen_male")
end

ax.animations:SetModelClass("models/breen.mdl", "citizen_male")
