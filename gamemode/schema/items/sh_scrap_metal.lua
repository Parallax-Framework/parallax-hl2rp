local ITEM = ax.item:Instance()

ITEM:SetName("Scrap Metal")
ITEM:SetDescription("A piece of scrap metal, often used for repairs or crafting. It can be melted down and repurposed for various uses.")
ITEM:SetCategory("Junk")
ITEM:SetModel(Model("models/gibs/metal_gib4.mdl"))

ITEM:SetWeight(0.7)

ITEM:Register()