FACTION.name = "Citizen"
FACTION.description = "Ordinary humans trying to survive under the Universal Union’s occupation. They queue for rations, heed curfews, and cling to rumours of freedom."
FACTION.color = Color(150, 150, 150)
FACTION.isDefault = true

FACTION.image = ax.util:GetMaterial("parallax/hl2rp/banners/citizen.png")

FACTION.models = {
    "models/humans/group01/male_01.mdl",
    "models/humans/group01/male_02.mdl",
    "models/humans/group01/male_03.mdl",
    "models/humans/group01/male_04.mdl",
    "models/humans/group01/male_05.mdl",
    "models/humans/group01/male_06.mdl",
    "models/humans/group01/male_07.mdl",
    "models/humans/group01/male_08.mdl",
    "models/humans/group01/male_09.mdl",
    "models/humans/group01/female_01.mdl",
    "models/humans/group01/female_02.mdl",
    "models/humans/group01/female_03.mdl",
    "models/humans/group01/female_04.mdl",
    "models/humans/group01/female_06.mdl"
}

FACTION_CITIZEN = FACTION.index

for i = 1, #FACTION.models do
    local model = FACTION.models[i]
    util.PrecacheModel(model)

    -- Remove this if you want to do your own animation mapping.
    ax.animations:SetModelClass(model, string.find(model, "female") and "citizen_female" or "citizen_male")
end
