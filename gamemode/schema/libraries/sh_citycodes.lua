SCHEMA.CityCodes = {}
SCHEMA.CityCodes.List = {
    {name = "Preserved",            color = Color(100, 255, 100)},
    {name = "Unrest",               color = Color(255, 250, 100)},
    {name = "Autonomous Judgment",  color = Color(255, 128, 55)},
    {name = "Judgment Waiver",      color = Color(255, 35, 35)},
}

function SCHEMA.CityCodes:GetCityCode()
    return GetRelay("hl2rp.citycode", 1)
end

function SCHEMA.CityCodes:Find(identifier)
    if ( identifier == nil ) then
        return self.List[self:GetCityCode()]
    end

    for i = 1, #self.List do
        local codeData = self.List[i]
        if ( ax.util:FindString(codeData.name, identifier, false)) then
            return codeData
        end
    end

    return nil
end

if ( SERVER ) then
    function SCHEMA.CityCodes:Set(iCityCode)
        SetRelay("hl2rp.citycode", iCityCode)
    end
end
