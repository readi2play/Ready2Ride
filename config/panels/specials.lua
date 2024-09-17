--[[----------------------------------------------------------------------------
BASICS
----------------------------------------------------------------------------]]--
local AddonName, r2r = ...
local data = CopyTable(R2R.data)
data.keyword = "bindings"

R2R.Specials = R2R.Specials or {
  noMountArea = {
    label = "",
    selected = "",
    description = "",
    editBox = nil
  },
  swimming = {
    label = "",
    description = "",
    dropdown = nil,
    editBox = nil
  }
}
--[[----------------------------------------------------------------------------
OPTIONS PANEL CREATION
----------------------------------------------------------------------------]]--
function R2R:FillSpecialsPanel(panel, container, anchorline)
  local isSwimmingAbility = false
  if R2R.db.bindings.swimming.ability ~= "" then
    isSwimmingAbility = C_Spell.GetSpellInfo(R2R.db.bindings.swimming.ability) ~= nil
  end
  local isIndoorsAbility = false
  if R2R.db.bindings.indoors ~= "" then
    isIndoorsAbility = C_Spell.GetSpellInfo(R2R.db.bindings.indoors) ~= nil
  end
  local function CompareMountsSet(id, option)
    return id == option
  end

  --[[----------------------------------------------------------------------------
  define wordings for field labels and descriptions
  ----------------------------------------------------------------------------]]--
  R2R.Specials.swimming.label = R2R.L["When Swimming"]
  R2R.Specials.swimming.description = R2R.L["Select a specific mount or ability to be used while swimming. To do so either use the Dropdown to select an aquatic mount or enter the |cFFFFE680name|r or |cFFFFE680spellID|r of your ability of choice into the Editbox."]
  R2R.Specials.noMountArea.label = R2R.L["When in No-Mount Area"]
  R2R.Specials.noMountArea.description = R2R.L["Select a specific ability to be used while in a no-mount area (e.g. being indoors). To do so enter the |cFFFFE680name|r or |cFFFFE680spellID|r of your ability of choice into the Editbox."]

  --[[----------------------------------------------------------------------------
  create the font strings, define their formatting and set text
  ----------------------------------------------------------------------------]]--
  local swimming_sectionTitle = container:CreateFontString(READI.ARTWORK, nil, "GameFontHighlightLarge")
  swimming_sectionTitle:SetPoint(READI.ANCHOR_TOPLEFT, anchorline, 0, -20)
  swimming_sectionTitle:SetText(READI.Helper.color:Get("r2r", R2R.Colors, R2R.Specials.swimming.label))
  swimming_sectionTitle:SetJustifyH("LEFT")
  swimming_sectionTitle:SetWidth(r2r.columnWidth)

  local swimming_sectionSubTitle = container:CreateFontString("ARTWORK", nil, "GameFontHighlight")
  swimming_sectionSubTitle:SetPoint(READI.ANCHOR_TOPLEFT, swimming_sectionTitle, READI.ANCHOR_BOTTOMLEFT, 0, -5)
  swimming_sectionSubTitle:SetJustifyH("LEFT")
  swimming_sectionSubTitle:SetJustifyV(READI.ANCHOR_TOP)
  swimming_sectionSubTitle:SetWordWrap(true)
  swimming_sectionSubTitle:SetWidth(r2r.columnWidth)
  swimming_sectionSubTitle:SetText(READI.Helper.color:Get("white", nil, R2R.Specials.swimming.description))

  local noMountArea_sectionTitle = container:CreateFontString(READI.ARTWORK, nil, "GameFontHighlightLarge")
  noMountArea_sectionTitle:SetPoint(READI.ANCHOR_TOPLEFT, swimming_sectionTitle, READI.ANCHOR_TOPRIGHT, 20, 0)
  noMountArea_sectionTitle:SetText(READI.Helper.color:Get("r2r", R2R.Colors, R2R.Specials.noMountArea.label))
  noMountArea_sectionTitle:SetJustifyH("LEFT")
  noMountArea_sectionTitle:SetWidth(r2r.columnWidth)

  local noMountArea_sectionSubTitle = container:CreateFontString("ARTWORK", nil, "GameFontHighlight")
  noMountArea_sectionSubTitle:SetPoint(READI.ANCHOR_TOPLEFT, noMountArea_sectionTitle, READI.ANCHOR_BOTTOMLEFT, 0, -5)
  noMountArea_sectionSubTitle:SetJustifyH("LEFT")
  noMountArea_sectionSubTitle:SetJustifyV(READI.ANCHOR_TOP)
  noMountArea_sectionSubTitle:SetWordWrap(true)
  noMountArea_sectionSubTitle:SetWidth(r2r.columnWidth)
  noMountArea_sectionSubTitle:SetText(READI.Helper.color:Get("white", nil, R2R.Specials.noMountArea.description))

  --[[----------------------------------------------------------------------------
  create fields
  ----------------------------------------------------------------------------]]--
  R2R.Specials.swimming.dropdown = READI:DropDown(data, {
    values = R2R:GetFilteredListOfMounts(READI.MOUNT_TYPE_AQUATIC),
    storage = "R2R.db.bindings.swimming",
    option = "mount",
    name = AddonName.."Dropdown_swimming",
    region = container,
    width = r2r.columnWidth - 20,
    parent = swimming_sectionSubTitle,
    offsetX = -20,
    offsetY = -10,
    onReset = function()
      R2R.db.bindings.swimming = R2R.defaults.bindings.swimming
      UIDropDownMenu_SetText(R2R.Specials.swimming.editBox, C_MountJournal.GetMountInfoByID(R2R.defaults.bindings.swimming.mount))
      CloseDropDownMenus()    
    end,
    onChange = function ()
      if not R2R.Specials.swimming.editBox:HasText() then
        R2R.db.bindings.swimming.mount = R2R.Specials.swimming.dropdown:GetValue()
        R2R.SkyButton:Update()
      end
    end
  })

  local swimmingPreset = ""
  if isSwimmingAbility then swimmingPreset = C_Spell.GetSpellInfo(R2R.db.bindings.swimming.ability).name end
  R2R.Specials.swimming.editBox = READI:EditBox(data, {
    region = container,
    type = "text",
    value = swimmingPreset,
    width = r2r.columnWidth,
    parent = R2R.Specials.swimming.dropdown,
    showButtons = true,
    offsetX = 20,
    validity = READI.Helper.color:Get("error", nil, R2R.L["Invalid |cFFFFE680SpellID|r or |cFFFFE680spell name|r. Please check your input and try again."]),
    onChange = function()
      if R2R.Specials.swimming.editBox:GetText() == "0" then
        R2R.Specials.swimming.editBox:SetText("")
      end

      if not R2R.Specials.swimming.editBox:HasText() then
        R2R.db.bindings.swimming.ability = ""
        R2R.SkyButton:Update()
        return 
      end
      local ebNum = R2R.Specials.swimming.editBox:GetNumber()
      local ebTxt = R2R.Specials.swimming.editBox:GetText()
      local spellInfo = nil

      if tostring(ebNum) == ebTxt then
        spellInfo = C_Spell.GetSpellInfo(ebNum)
      else
        spellInfo = C_Spell.GetSpellInfo(ebTxt)
      end

      if spellInfo then
        R2R.db.bindings.swimming.ability = spellInfo.spellID
        R2R.Specials.swimming.editBox:SetText(spellInfo.name)
      else
        local _spell = nil
        if R2R.db.bindings.swimming.ability ~= "" then
          _spell = C_Spell.GetSpellInfo(R2R.db.bindings.swimming.ability)
        end
        R2R.Specials.swimming.editBox.validCheck:SetAlpha(1)
        C_Timer.After(5, function()
          UIFrameFadeOut(R2R.Specials.swimming.editBox.validCheck, 0.25, 1, 0)
        end)
        if _spell then
          R2R.Specials.swimming.editBox:SetText(_spell.name)
        else
          R2R.Specials.swimming.editBox:SetText("")
        end
      end
      R2R.SkyButton:Update()
    end,
    onReset = function()
      R2R.Specials.swimming.editBox:SetText("")
      EventRegistry:TriggerEvent(format("%s.%s.%s", data.prefix, data.keyword, "OnChange"))
    end
  })
  local indoorsPreset = ""
  if isIndoorsAbility then indoorsPreset = C_Spell.GetSpellInfo(R2R.db.bindings.indoors).name end
  R2R.Specials.noMountArea.editBox = READI:EditBox(data, {
    region = container,
    type = "text",
    value = indoorsPreset,
    width = r2r.columnWidth,
    parent = noMountArea_sectionSubTitle,
    offsetY = -8,
    showButtons = true,
    validity = READI.Helper.color:Get("error", nil, R2R.L["Invalid |cFFFFE680SpellID|r or |cFFFFE680spell name|r. Please check your input and try again."]),
    onChange = function()
      if R2R.Specials.noMountArea.editBox:GetText() == "0" then
        R2R.Specials.noMountArea.editBox:SetText("")
      end

      if not R2R.Specials.noMountArea.editBox:HasText() then
        R2R.db.bindings.indoors = ""
        R2R.SkyButton:Update()
        return 
      end
      local ebNum = R2R.Specials.noMountArea.editBox:GetNumber()
      local ebTxt = R2R.Specials.noMountArea.editBox:GetText()
      local spellInfo = nil

      if tostring(ebNum) == ebTxt then
        spellInfo = C_Spell.GetSpellInfo(ebNum)
      else
        spellInfo = C_Spell.GetSpellInfo(ebTxt)
      end

      if spellInfo then
        R2R.db.bindings.indoors = spellInfo.spellID
        R2R.Specials.noMountArea.editBox:SetText(spellInfo.name)
      else
        local _spell = nil
        if R2R.db.bindings.indoors ~= "" then
          _spell = C_Spell.GetSpellInfo(R2R.db.bindings.indoors)
        end
        R2R.Specials.noMountArea.editBox.validCheck:SetAlpha(1)
        C_Timer.After(5, function() UIFrameFadeOut(R2R.Specials.noMountArea.editBox.validCheck, 0.25, 1, 0) end)
        if _spell then
          R2R.Specials.noMountArea.editBox:SetText(_spell.name)
        else
          R2R.Specials.noMountArea.editBox:SetText("")
        end
      end
      R2R.SkyButton:Update()
    end,
    onReset = function()
      R2R.Specials.noMountArea.editBox:SetText("")
      EventRegistry:TriggerEvent(format("%s.%s.%s", data.prefix, data.keyword, "OnChange"))
    end
  })
  --[[----------------------------------------------------------------------------
  create buttons
  ----------------------------------------------------------------------------]]--
  local btn_Reset = READI:Button(data,
    {
      name = AddonName..READI.Helper.string:Capitalize(data.keyword).."ResetButton",
      region = panel,
      label = READI:l10n("general.labels.buttons.reset"),
      anchor = READI.ANCHOR_BOTTOMLEFT,
      parent = panel,
      offsetY = 20,
      onClick = function()
        R2R.db[data.keyword] = CopyTable(R2R.defaults[data.keyword])
        EventRegistry:TriggerEvent(format("%s.%s.%s", data.prefix, string.upper(data.keyword), "OnReset"))
        -- R2R[READI.Helper.string:Capitalize(data.keyword)]:Update()
    end
    }
  )
end
