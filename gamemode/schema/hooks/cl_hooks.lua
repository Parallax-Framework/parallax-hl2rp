local color = {}
color["$pp_colour_addr"] = 0
color["$pp_colour_addg"] = 0
color["$pp_colour_addb"] = 0
color["$pp_colour_brightness"] = -0.01
color["$pp_colour_contrast"] = 1.35
color["$pp_colour_colour"] = 0.65
color["$pp_colour_mulr"] = 0
color["$pp_colour_mulg"] = 0
color["$pp_colour_mulb"] = 0

local combineOverlay = ax.util:GetMaterial("effects/combine_binocoverlay")
function SCHEMA:RenderScreenspaceEffects()
    local client = ax.client
    local health, healthMax = client:Health(), client:GetMaxHealth()
    local healthFraction = math.Clamp(health / healthMax, 0, 1)
    local healthFractionInv = 1 - healthFraction

    color["$pp_colour_brightness"] = -0.05 - (0.05 * healthFractionInv)
    color["$pp_colour_contrast"] = 1.5 - (0.5 * healthFractionInv)
    color["$pp_colour_colour"] = 0.65 * healthFraction

    DrawColorModify(color)

    if ( client:IsCombine() ) then
        render.UpdateScreenEffectTexture()

        combineOverlay:SetFloat("$refractamount", 0.3)
        combineOverlay:SetFloat("$envmaptint", 0)
        combineOverlay:SetFloat("$envmap", 0)
        combineOverlay:SetFloat("$alpha", 0.5)
        combineOverlay:SetInt("$ignorez", 1)

        render.SetMaterial(combineOverlay)
        render.DrawScreenQuad()
    end
end

function SCHEMA:PlayerFootstep(client, position, foot, soundName, volume)
    return false
end