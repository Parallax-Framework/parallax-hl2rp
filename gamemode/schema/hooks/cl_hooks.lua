local color = {}
color["$pp_colour_addr"] = 0
color["$pp_colour_addg"] = 0
color["$pp_colour_addb"] = 0
color["$pp_colour_brightness"] = -0.05
color["$pp_colour_contrast"] = 1.25
color["$pp_colour_colour"] = 0.75
color["$pp_colour_mulr"] = 0
color["$pp_colour_mulg"] = 0
color["$pp_colour_mulb"] = 0

local combineOverlay = ax.util:GetMaterial("effects/combine_binocoverlay")
function SCHEMA:RenderScreenspaceEffects()
    local client = ax.client
    local character = client:GetCharacter()
    if ( !character ) then return end

    local health, healthMax = client:Health(), client:GetMaxHealth()
    local healthFraction = math.Clamp(health / healthMax, 0, 1)
    local healthFractionInv = 1 - healthFraction

    color["$pp_colour_brightness"] = -0.05 - (0.05 * healthFractionInv)
    color["$pp_colour_contrast"] = 1.25 - (0.5 * healthFractionInv)
    color["$pp_colour_colour"] = 0.75 * healthFraction

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

function SCHEMA:ShouldDrawHealthHUD()
    if ( ax.client:IsCombine() ) then
        return false
    end
end

function SCHEMA:ShouldDrawArmorHUD()
    if ( ax.client:IsCombine() ) then
        return false
    end
end

local nextMessage = 0
local idleMessages = {
    "Checking exodus protocol status...",
    "Establishing DC link...",
    "Idle connection...",
    "Pinging loopback...",
    "Sending commdata to dispatch...",
    "Updating biosignal coordinates..."
}

local storedMessages = {}

local function addIdleMessage()
    if ( #storedMessages >= 5 ) then
        table.remove(storedMessages, 1)
    end

    local availableMessages = {}
    for _, msg in ipairs(idleMessages) do
        local alreadyExists = false
        for _, storedMsg in ipairs(storedMessages) do
            if ( storedMsg.message == msg ) then
                alreadyExists = true
                break
            end
        end

        if ( !alreadyExists ) then
            table.insert(availableMessages, msg)
        end
    end

    local message = availableMessages[math.random(#availableMessages)]
    table.insert(storedMessages, { message = message, color = Color(0, 0, 0, 175) })
end

local direction = {
    [0] = "N",
    [45] = "NE",
    [90] = "E",
    [135] = "SE",
    [180] = "S",
    [225] = "SW",
    [270] = "W",
    [315] = "NW",
    [360] = "N"
}

local healthStatusMessages = {
    { threshold = 90, color = Color(180, 220, 180), message = "NOTICE: minor bio-signal variance detected" },
    { threshold = 70, color = Color(255, 228, 0), message = "WARNING: local unit requires medical attention!" },
    { threshold = 50, color = Color(255, 180, 0), message = "ALERT: bio-signal degraded — seek aid" },
    { threshold = 30, color = Color(255, 120, 0), message = "CRITICAL: vitals unstable — immediate care required" },
    { threshold = 15, color = Color(255, 40, 40), message = "EXTREME: life support failure imminent" },
    { threshold = 5, color = Color(255, 0, 0), message = "TERMINAL: bio-signal flatlining" },
}

function SCHEMA:HUDPaintCurvy()
    local client = ax.client
    if ( !client:IsCombine() ) then return end

    if ( CurTime() >= nextMessage ) then
        addIdleMessage()
        nextMessage = CurTime() + math.Rand(5, 10)
    end

    local x, y = ax.util:ScreenScale(8), ax.util:ScreenScaleH(8)
    for i = 1, #storedMessages do
        local msgData = storedMessages[i]

        local displayText = string.sub(msgData.message, 1, math.floor((CurTime() - (msgData.startTime or CurTime())) * 30))
        if ( !msgData.startTime ) then
            msgData.startTime = CurTime()
        end

        surface.SetFont("BudgetLabel")
        local w, h = surface.GetTextSize(displayText)

        ax.render.Draw(0, x, y + 6, w + 12, h, msgData.color or color_white)

        draw.SimpleText(displayText, "BudgetLabel", x + 6, y + 6, color_white, 0, 0)

        y = y + h + 8
    end

    local ang = EyeAngles()
    local bearing = math.floor(math.NormalizeAngle(360 - ang.y))
    local scrW = ScrW()
    local width = scrW * 0.25
    local m = 1
    local spacing = ( width * m ) / 360
    local lines = width / spacing
    local rang = math.Round(ang.y)
    local comX = scrW / 2

    ax.render.Draw(0, scrW / 2 - (width / 2) - 8, 30, width + 16, 40, Color(0, 0, 0, 175))

    draw.SimpleText(bearing, "BudgetLabel", scrW / 2, 70, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    for i = (rang - (lines / 2)) % 360, ((rang - (lines / 2)) % 360) + lines do
        x = (comX + (width / 2)) - ((i - ang.y - 180) % 360) * spacing

        if ( i % 30 == 0 and i > 0 ) then
            local text = direction[360 - (i % 360)] and direction[360 - (i % 360)] or 360 - (i % 360)

            draw.SimpleText(text, "BudgetLabel", x, 30, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        end
    end

    local zone = client:GetCurrentZoneName()
    if ( !zone ) then
        zone = "UNKNOWN"
    end

    x, y = scrW - ax.util:ScreenScale(8), ax.util:ScreenScaleH(8)

    local pos = client:GetPos()
    local grid = math.Round(pos.x / 100) .. "/" .. math.Round(pos.y / 100)
    local hp = client:Health()
    local armor = client:Armor()
    local add = 0
    local sps = false

    local textHeight = draw.GetFontHeight("BudgetLabel")

    draw.SimpleText("AUX DATA ::>", "BudgetLabel", x, y, nil, TEXT_ALIGN_RIGHT)
    draw.SimpleText("BIOSIGNAL: ON ::>", "BudgetLabel", x, y + textHeight, nil, TEXT_ALIGN_RIGHT)
    draw.SimpleText("BIOSIGNAL ZONE: " .. zone .. " ::>", "BudgetLabel", x, y + textHeight * 2, nil, TEXT_ALIGN_RIGHT)
    draw.SimpleText("BIOSIGNAL GRID: " .. grid .. " ::>", "BudgetLabel", x, y + textHeight * 3, nil, TEXT_ALIGN_RIGHT)

    if ( client:Team() == FACTION_OTA ) then
        sps = true
        draw.SimpleText("SUIT PROTECTION SYSTEM CHARGE: " .. armor .. " ::>", "BudgetLabel", x, y + 80, nil, TEXT_ALIGN_RIGHT)
        add = add + textHeight
    end

    add = add + 5

    local selectedStatus
    for _, status in ipairs(healthStatusMessages) do
        if ( hp <= status.threshold and ( !selectedStatus or status.threshold < selectedStatus.threshold ) ) then
            selectedStatus = status
        end
    end

    if ( selectedStatus ) then
        add = add + textHeight
        draw.SimpleText(string.upper(selectedStatus.message), "BudgetLabel", x, y + 80 + add, selectedStatus.color, TEXT_ALIGN_RIGHT)
    end

    if ( sps and armor <= 40 ) then
        if ( CurTime() > nextArmFlash + 1 and armor <= 5 ) then
            nextArmFlash = CurTime() + 1
        end

        add = add + textHeight

        if ( CurTime() > nextArmFlash ) then
            draw.SimpleText("WARNING: LOCAL UNIT SPS REQUIRES RECHARGE!", "BudgetLabel", scrW - 8, 80 + add, Color(255, 0, 0), TEXT_ALIGN_RIGHT)
        end
    end
end

function SCHEMA:PlayerFootstep(client, position, foot, soundName, volume)
    return false
end
