ax.config:Add("cityName", ax.type.string, "City 17", {
    description = "The name of the city your server is set in.",
    category = "schema"
})

ax.config:Add("cityAbbreviation", ax.type.string, "C17", {
    description = "The abbreviation of the city your server is set in.",
    category = "schema"
})

ax.config:Add("colorModifcation", ax.type.bool, true, {
    description = "Whether the color modification system is enabled or not.",
    category = "schema"
})

-- ax.config:SetDefault("color, Color(30, 60, 90, 255))
-- ax.config:SetDefault("currencyPlural", "tokens")
-- ax.config:SetDefault("currencySingular", "token")
-- ax.config:SetDefault("currencySymbol", "T")
-- ax.config:SetDefault("mainmenuMusic", "music/hl2_song19.mp3")
-- ax.config:SetDefault("voice", false)
