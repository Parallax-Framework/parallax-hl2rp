FACTION.name = "Metropolice Force"
FACTION.description = "Implanted human collaborators who police the urban zones for the Combine. They impose curfews, break up dissent and suppress resistance with lethal efficiency."
FACTION.color = Color(45, 90, 140)

FACTION.image = ax.util:GetMaterial("gamepadui/hl2/chapter3")

FACTION.models = {
    "models/police.mdl"
}

FACTION.AllowNonAscii = true

FACTION.Taglines = {
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
    return "MPF:" .. ax.config:Get("city.abbreviation") .. "-" .. self.Taglines[math.random(#self.Taglines)] .. "-" .. ax.util:ZeroNumber(math.random(1, 9999), 4), true
end

FACTION_MPF = FACTION.index

ax.animations:SetModelClass("models/police.mdl", "metrocop")
ax.animations:SetModelClass("models/police/eliteghostcp.mdl", "metrocop")
ax.animations:SetModelClass("models/police/eliteshockcp.mdl", "metrocop")
ax.animations:SetModelClass("models/police/leet_police2.mdl", "metrocop")
ax.animations:SetModelClass("models/police/policetrench.mdl", "metrocop")
ax.animations:SetModelClass("models/police/sect_police2.mdl", "metrocop")