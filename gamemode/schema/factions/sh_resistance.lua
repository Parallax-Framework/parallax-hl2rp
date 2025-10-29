FACTION.name = "Resistance"
FACTION.description = "A clandestine network of rebels who sabotage Combine infrastructure and smuggle citizens to safety. United under the Lambda, they scavenge alien tech to push humanity’s fight for liberation."
FACTION.color = Color(80, 110, 60)

FACTION.image = ax.util:GetMaterial("parallax/hl2rp/banners/resistance.png")

FACTION.models = {
    "models/humans/group03/male_01.mdl",
    "models/humans/group03/male_02.mdl",
    "models/humans/group03/male_03.mdl",
    "models/humans/group03/male_04.mdl",
    "models/humans/group03/male_05.mdl",
    "models/humans/group03/male_06.mdl",
    "models/humans/group03/male_07.mdl",
    "models/humans/group03/male_08.mdl",
    "models/humans/group03/male_09.mdl",
    "models/humans/group03/female_01.mdl",
    "models/humans/group03/female_02.mdl",
    "models/humans/group03/female_03.mdl",
    "models/humans/group03/female_04.mdl",
    "models/humans/group03/female_06.mdl"
}

FACTION_RESISTANCE = FACTION.index

for i = 1, #FACTION.models do
    local model = FACTION.models[i]
    util.PrecacheModel(model)

    -- Remove this if you want to do your own animation mapping.
    ax.animations:SetModelClass(model, string.find(model, "female") and "citizen_female" or "citizen_male")
end
