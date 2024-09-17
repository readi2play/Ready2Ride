--[[----------------------------------------------------------------------------
BASICS
----------------------------------------------------------------------------]]--
local AddonName, r2r = ...
local data = CopyTable(R2R.data)
data.keyword = "info"
local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata

local addon = {
  ["icon"] = GetAddOnMetadata(AddonName, "IconTexture"),
  ["version"] = GetAddOnMetadata(AddonName, "Version"),
  ["author"] = GetAddOnMetadata(AddonName, "Author"),
}
local lib = {
  ["title"] = GetAddOnMetadata("readiLIB", "Title"), 
  ["icon"] = GetAddOnMetadata("readiLIB", "IconTexture"),
  ["version"] = GetAddOnMetadata("readiLIB", "Version"),
  ["author"] = GetAddOnMetadata("readiLIB", "Author"),
}
--------------------------------------------------------------------------------
-- OPTIONS PANEL CREATION
--------------------------------------------------------------------------------
function R2R:FillInfoPanel(panel, container, anchorline)
  local logo = READI:Icon(data, {
    texture = addon.icon,
    name = format("%s Logo", AddonName),
    region = container,
    width = 80,
    height = 80,
  })
  logo:SetPoint("TOP", 0, -20)

  local headline_infos = container:CreateFontString("ARTWORK", nil, "GameFontHighlightLarge")
  headline_infos:SetPoint("TOP", logo, "BOTTOM", 0, -20)
  headline_infos:SetText(READI.Helper.color:Get("r2r", R2R.Colors, AddonName))

  local infos_text = container:CreateFontString("ARTWORK", nil, "GameFontHighlight")
  infos_text:SetPoint("TOP", headline_infos, "BOTTOM", 0, -5)
  infos_text:SetText(
    READI.Helper.color:Get("r2r", R2R.Colors, R2R.L["Version: "]) ..
    READI.Helper.color:Get("white", nil, addon.version.."\n") ..
    READI.Helper.color:Get("r2r", R2R.Colors, R2R.L["Author: "]) ..
    READI.Helper.color:Get("readi", nil, addon.author.."\n")
  )

  local headline_features = container:CreateFontString("ARTWORK", nil, "GameFontHighlightLarge")
  headline_features:SetPoint("TOPLEFT", container, 0, -180)
  headline_features:SetText(READI.Helper.color:Get("r2r", R2R.Colors, R2R.L["Core Features"]))

  local text_features = container:CreateFontString("ARTWORK", nil, "GameFontHighlight")
  text_features:SetPoint("TOPLEFT", headline_features, "BOTTOMLEFT", 0, -10)
  text_features:SetJustifyH("LEFT")
  text_features:SetJustifyV("TOP")
  text_features:SetWordWrap(true)
  text_features:SetWidth(r2r.windowWidth - 18)
  text_features:SetText(
    READI.Helper.color:Get("white", nil, format(
      R2R.L[ [=[
- Right click the %1$s to easily %2$s
- Hold SHIFT while left clicking the %1$s to display your current zone and continent (incl. their MapIDs)
- Saddle onto your configured Mount
    - per continent
    - per zone (if configured, falls back to continent specific Mount)
    - when swimming (if configured)
- Configure a movement ability to be used in no-mount areas (e.g. indoors)
- Place the %1$s wherever you want on your screen
- The %1$s is accessible via Macros using %3$s
]=] ],
      READI.Helper.color:Get("r2r", R2R.Colors, R2R.L["SkyridingButton"]),
      READI.Helper.color:Get("r2r_light", R2R.Colors, R2R.L["Switch Flight Style"]),
      format("%s %s", READI.Helper.color:Get("r2r", R2R.Colors, "/click"), READI.Helper.color:Get("r2r_light", R2R.Colors, R2R.L["SkyridingButton"].." LeftButton 1"))
    ))
  )

  local headline_commands = container:CreateFontString("ARTWORK", nil, "GameFontHighlightLarge")
  headline_commands:SetPoint("BOTTOMLEFT", text_features, 0, -20)
  headline_commands:SetText(READI.Helper.color:Get("r2r", R2R.Colors, R2R.L["Slash Command"]))

  local text_commands = container:CreateFontString("ARTWORK", nil, "GameFontHighlight")
  text_commands:SetPoint("TOPLEFT", headline_commands, "BOTTOMLEFT", 0, -10)
  text_commands:SetJustifyH("LEFT")
  text_commands:SetJustifyV("TOP")
  text_commands:SetWordWrap(true)
  text_commands:SetWidth(r2r.windowWidth - 18)
  text_commands:SetText(
    READI.Helper.color:Get("white", nil, format(
      R2R.L[ [=[
Use the following slash command to open up this config panel and to adjust the Size and Position of the %1$s. You might also want to configure specific mounts for specific zones or situations like swimming or being indoors.

    %3$s


Thanks for using %4$s and stay healthy

Yours sincerely

%2$s
]=] ],
      READI.Helper.color:Get("r2r", R2R.Colors, R2R.L["SkyridingButton"]),
      READI.Helper.color:Get("readi", nil, addon.author),
      format("%s %s", READI.Helper.color:Get("r2r", R2R.Colors, "/sky"), READI.Helper.color:Get("r2r_light", R2R.Colors, "config")),
      READI.Helper.color:Get("r2r", R2R.Colors, AddonName)
    ))
  )

  local libLogo = READI:Icon(data, {
    texture = lib.icon,
    name = format("%s Logo", "readiLIB"),
    region = panel,
    width = 16,
    height = 16,
  })

  local libText = panel:CreateFontString("ARTWORK", nil, "GameFontNormalSmall")
  libText:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -5,5)
  libText:SetText(READI.Helper.color:Get("white", nil, format("%s v%s", lib.title, lib.version)))

  libLogo:SetPoint("RIGHT", libText, "LEFT", -5, 0)

  local powered_by = panel:CreateFontString("ARTWORK", nil, "GameFontNormalSmall")
  powered_by:SetPoint("RIGHT", libLogo, "LEFT", -5,0)
  powered_by:SetText(READI.Helper.color:Get("white", nil, "powered by:"))
end
