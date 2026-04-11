FACTION.name = "Overwatch Transhuman Arm"
FACTION.description = "Genetically-augmented shock troops deployed when civilian forces fail. Their purpose is the decisive annihilation of hostile elements and fortification of Combine interests."
FACTION.color = Color(150, 15, 15)

FACTION.image = ax.util:GetMaterial("parallax/hl2rp/banners/ota.png")

FACTION.models = {
    "models/combine_soldier.mdl",
    "models/combine_super_soldier.mdl",
    "models/combine_soldier_prisonguard.mdl"
}

FACTION.deathSound = {
    "npc/combine_soldier/die1.wav",
    "npc/combine_soldier/die2.wav",
    "npc/combine_soldier/die3.wav",
    "npc/combine_soldier/die4.wav"
}

FACTION.painSound = {
    "npc/combine_soldier/pain1.wav",
    "npc/combine_soldier/pain2.wav",
    "npc/combine_soldier/pain3.wav",
    "npc/combine_soldier/pain4.wav",
    "npc/combine_soldier/pain5.wav",
    "npc/combine_soldier/pain6.wav"
}

FACTION.allowNonAscii = true
FACTION.allowSkinCustomization = false

FACTION.taglines = {
    "BLADE",
    "FIST",
    "FLASH",
    "HAMMER",
    "HUNTER",
    "LEADER",
    "RANGER",
    "RAZOR",
    "SAVAGE",
    "SCAR",
    "SLASH",
    "SPEAR",
    "STAB",
    "SWEEPER",
    "SWIFT",
    "SWORD",
    "TRACKER"
}

function FACTION:GetDefaultName(client)
    return "OTA:" .. ax.config:Get("cityAbbreviation") .. "-" .. self.taglines[math.random(#self.taglines)] .. "-" .. ax.util:PadNumber(math.random(9999), 4), true
end

function FACTION:OnCharacterCreated(client, character)
    local defaultClass = 0
    local classes = ax.class:GetAll({faction = self.index})
    for i = 1, #classes do
        local class = classes[i]
        if ( class.isDefault ) then
            defaultClass = class.index
            break
        end
    end

    if ( defaultClass == 0 ) then return end
    character:SetClass(defaultClass)
end

FACTION_OTA = FACTION.index

ax.animations:SetModelClass("models/combine_soldier.mdl", "overwatch")
ax.animations:SetModelClass("models/combine_super_soldier.mdl", "overwatch")
ax.animations:SetModelClass("models/combine_soldier_prisonguard.mdl", "overwatch")
