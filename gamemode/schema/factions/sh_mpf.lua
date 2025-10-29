FACTION.name = "Metropolice Force"
FACTION.description = "Implanted human collaborators who police the urban zones for the Combine. They impose curfews, break up dissent and suppress resistance with lethal efficiency."
FACTION.color = Color(45, 90, 140)

FACTION.image = ax.util:GetMaterial("parallax/hl2rp/banners/mpf.png")

FACTION.models = {
    "models/police.mdl"
}

FACTION.deathSound = {
    "npc/metropolice/die1.wav",
    "npc/metropolice/die2.wav",
    "npc/metropolice/die3.wav"
}

FACTION.painSound = {
    "npc/metropolice/pain1.wav",
    "npc/metropolice/pain2.wav",
    "npc/metropolice/pain3.wav",
    "npc/metropolice/pain4.wav",
    "npc/metropolice/pain5.wav",
    "npc/metropolice/pain6.wav"
}

FACTION.allowNonAscii = true
FACTION.allowSkinCustomization = false

FACTION.taglines = {
    "DEFENDER",
    "HERO",
    "JURY",
    "KING",
    "LINE",
    "PATROL",
    "QUICK",
    "ROLLER",
    "STICK",
    "TAP",
    "UNION",
    "VICTOR",
    "XRAY",
    "YELLOW"
}

function FACTION:GetDefaultName(client)
    return "MPF:" .. ax.config:Get("cityAbbreviation") .. "-" .. self.taglines[math.random(#self.taglines)] .. "-" .. ax.util:PadNumber(math.random(1, 9999), 4), true
end

FACTION_MPF = FACTION.index

ax.animations:SetModelClass("models/police.mdl", "metrocop")
