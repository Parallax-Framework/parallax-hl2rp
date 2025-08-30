ax.config:Register("city.name", {
    Name = "hl2rp.city.name",
    Description = "hl2rp.city.name.description",
    Category = "hl2rp",
    Type = ax.types.string,
    Default = "City 17"
})

ax.config:Register("city.abbreviation", {
    Name = "hl2rp.city.abbreviation",
    Description = "hl2rp.city.abbreviation.description",
    Category = "hl2rp",
    Type = ax.types.string,
    Default = "C17"
})

ax.config:SetDefault("color.schema", Color(30, 60, 90, 255))

ax.config:SetDefault("currency.plural", "tokens")
ax.config:SetDefault("currency.singular", "token")
ax.config:SetDefault("currency.symbol", "T")

ax.config:SetDefault("mainmenu.music", "music/hl2_song19.mp3")

ax.config:SetDefault("voice", false)