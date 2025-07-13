local FACTION = ax.faction:Instance()
FACTION:SetName("Civil Workers’ Union")
FACTION:SetDescription("A Combine-sanctioned labour guild that staffs factories, clinics and ration dispensaries. In return for loyalty it gains modest privileges and extra food tokens.")
FACTION:SetColor(Color(200, 120, 30))

FACTION.Image = ax.util:GetMaterial("gamepadui/hl2/chapter2")

FACTION:SetModels({
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
})

FACTION_CWU = FACTION:Register()