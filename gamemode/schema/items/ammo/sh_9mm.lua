local ITEM = ax.item:Instance()

ITEM:SetName("9mm Ammo")
ITEM:SetDescription("A box of 9mm ammunition, commonly used in handguns and submachine guns. It contains 30 rounds.")
ITEM:SetCategory("Ammunition")
ITEM:SetModel(Model("models/items/boxsrounds.mdl"))

ITEM:SetAmmo("pistol")
ITEM:SetAmmoAmount(30)
ITEM:SetWeight(0.3)

ITEM:Register()