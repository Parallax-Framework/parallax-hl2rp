local FACTION = ax.faction:Instance()
FACTION:SetName("Resistance")
FACTION:SetDescription("A clandestine network of rebels who sabotage Combine infrastructure and smuggle citizens to safety. United under the Lambda, they scavenge alien tech to push humanity’s fight for liberation.")
FACTION:SetColor(Color(80, 110, 60))

FACTION.Image = ax.util:GetMaterial("gamepadui/hl2/chapter5")

FACTION:SetModels({
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
})

FACTION_RESISTANCE = FACTION:Register()