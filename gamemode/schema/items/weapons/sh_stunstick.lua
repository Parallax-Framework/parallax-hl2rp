local ITEM = ax.item:Instance()

ITEM:SetName("Stunstick")
ITEM:SetDescription("A shocking melee baton used by the Civil Protection to subdue citizens. It delivers a powerful electric shock on contact.")
ITEM:SetCategory("Weapons")
ITEM:SetModel(Model("models/weapons/w_stunbaton.mdl"))

ITEM:SetWeaponClass("weapon_stunstick")
ITEM:SetWeight(2)

ITEM:Register()