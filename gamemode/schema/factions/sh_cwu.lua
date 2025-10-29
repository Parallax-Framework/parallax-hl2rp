FACTION.name = "Civil Workers’ Union"
FACTION.description = "A Combine-sanctioned labour guild that staffs factories, clinics and ration dispensaries. In return for loyalty it gains modest privileges and extra food tokens."
FACTION.color = Color(200, 120, 30)

FACTION.image = ax.util:GetMaterial("parallax/hl2rp/banners/cwu.png")

FACTION.models = {
    "models/humans/group02/male_01.mdl",
    "models/humans/group02/male_02.mdl",
    "models/humans/group02/male_03.mdl",
    "models/humans/group02/male_04.mdl",
    "models/humans/group02/male_05.mdl",
    "models/humans/group02/male_06.mdl",
    "models/humans/group02/male_07.mdl",
    "models/humans/group02/male_08.mdl",
    "models/humans/group02/male_09.mdl",
    "models/humans/group02/female_01.mdl",
    "models/humans/group02/female_02.mdl",
    "models/humans/group02/female_03.mdl",
    "models/humans/group02/female_04.mdl",
    "models/humans/group02/female_06.mdl"
}

FACTION_CWU = FACTION.index

for i = 1, #FACTION.models do
    local model = FACTION.models[i]
    util.PrecacheModel(model)

    -- Remove this if you want to do your own animation mapping.
    ax.animations:SetModelClass(model, string.find(model, "female") and "citizen_female" or "citizen_male")
end
