local AddonName, r2r = ...

--[[----------------------------------------------------------------------------
Button factory for the Ready2Ride SkyButton
----------------------------------------------------------------------------]]--
local function CreateButton()
  --[[--------------------------------------------------------------------------
  button creation
  --------------------------------------------------------------------------]]--
  R2R.SkyButton = R2R.SkyButton or CreateFrame("Button", "R2R_SkyridingButton", _G[R2R.config.anchoring.frame], "SecureActionButtonTemplate")
  R2R.SkyButton:SetFrameLevel(100)
  R2R.SkyButton:SetHighlightTexture(READI.T.rdl110004, "ADD")
  R2R.SkyButton:EnableKeyboard()

  --[[--------------------------------------------------------------------------
  Drag & Drop functionality
  --------------------------------------------------------------------------]]--
  R2R.SkyButton:SetMovable(true)

  --[[--------------------------------------------------------------------------
  create children
  --------------------------------------------------------------------------]]--
  R2R.SkyButton.tooltip = R2R.SkyButton.tooltip or CreateFrame("GameTooltip", AddonName.."Tooltip", UIParent, "GameTooltipTemplate")
  R2R.SkyButton.background = R2R.SkyButton.background or R2R.SkyButton:CreateTexture(AddonName .. "Background", "BACKGROUND")
  R2R.SkyButton.border = R2R.SkyButton.border or R2R.SkyButton:CreateTexture(AddonName .. "Border", "OVERLAY")
  R2R.SkyButton.icon = R2R.SkyButton.icon or R2R.SkyButton:CreateTexture(AddonName .. "Icon", "ARTWORK")
  R2R.SkyButton.mask = R2R.SkyButton.mask or R2R.SkyButton:CreateMaskTexture()

  --[[--------------------------------------------------------------------------
  METHODS ---
  This function updates the button's icon, tooltip and cooldown
  --------------------------------------------------------------------------]]--
  function R2R.SkyButton:Update()
    if InCombatLockdown() then return end
    --[[----------------------------------------------------------------------
    if the character is infight, just return early to prevent the addon throwing a bunch of errors
    secure buttons are not allowed to change in fight therefore we have to prevent this by all meaning  
    ----------------------------------------------------------------------]]--
      if IsOutdoors() or IsIndoors() == nil then
        r2r.id = R2R:GetMountID()
      else
        r2r.id = R2R.config.bindings.indoors
      end

      if not r2r.id then
        R2R.SkyButton:Clear()
      end


      local isMount = R2R:IsMount(r2r.id)
      if isMount then
        r2r.name, r2r.spellID, r2r.icon = R2R:GetMount(r2r.id)
      else
        local _spell = C_Spell.GetSpellInfo(r2r.id)
        r2r.name = _spell.name
        r2r.icon = _spell.iconID
        r2r.spellID = _spell.spellID

        if not IsSpellKnown(r2r.spellID) then
          r2r.id = nil
          R2R.SkyButton:Clear()
          return
        end
      end

      --[[----------------------------------------------------------------------
      set icon
      ----------------------------------------------------------------------]]--
      R2R.SkyButton.icon:SetTexture(r2r.icon)
      --[[----------------------------------------------------------------------
      update functionality
      ----------------------------------------------------------------------]]--
        R2R.SkyButton:SetAttribute("spell1", C_Spell.GetSpellInfo(r2r.spellID).name)
      if r2r.id then
        R2R.SkyButton:Show()
      end
  end

  r2r.iconPos = 0
  function R2R.SkyButton:SetPosition()
    R2R.SkyButton:ClearAllPoints()
    R2R.SkyButton:SetPoint(R2R.config.anchoring.button_anchor, R2R.config.anchoring.frame, R2R.config.anchoring.parent_anchor, R2R.config.anchoring.position_x, R2R.config.anchoring.position_y)
  end

  function R2R.SkyButton:ScaleButton()
    R2R.SkyButton:SetSize(R2R.config.anchoring.button_size, R2R.config.anchoring.button_size)
    R2R.SkyButton.mask:SetSize(R2R.config.anchoring.button_size, R2R.config.anchoring.button_size)
  end

  function R2R.SkyButton:SetStrata()
    local btnStrata = R2R.config.anchoring.button_strata
    if btnStrata == "PARENT" then
      local parent = R2R.SkyButton:GetParent() 
      R2R.SkyButton:SetFrameStrata(parent:GetFrameStrata())
    else
      R2R.SkyButton:SetFrameStrata(btnStrata)
    end
  end

  function R2R.SkyButton:Clear()
    R2R.SkyButton.icon:SetTexture(nil)
    R2R.SkyButton.tooltip:ClearLines()
    R2R.SkyButton:Hide()
  end

  --[[--------------------------------------------------------------------------
  button action configuration
  --------------------------------------------------------------------------]]--
  R2R.SkyButton:RegisterForClicks("LeftButtonDown", "RightButtonDown")
  R2R.SkyButton:SetAttribute("type", "spell")
  R2R.SkyButton:SetAttribute("alt-type1", "spell")
  R2R.SkyButton:SetAttribute("ctrl-type1", "spell")
  R2R.SkyButton:SetAttribute("altshift-type1", "spell")
  R2R.SkyButton:SetAttribute("shift-type1", "report")

  -- R2R.SkyButton:SetAttribute("spell1", C_Spell.GetSpellInfo(r2r.spellID).name)
  R2R.SkyButton:SetAttribute("spell2", C_Spell.GetSpellInfo(460002).name)

  R2R.SkyButton:SetAttribute("_report", function()
    local zoneID = C_Map.GetBestMapForUnit("player")
    local continentID = R2R:GetContinent(zoneID)
    local zoneReport = format("%s (%d) in %s (%d)", C_Map.GetMapInfo(zoneID).name, zoneID, continentID.name, continentID.mapID)
    local text = text or UIParent:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    text:SetPoint("CENTER")
    text:SetText( READI.Helper.color:Get("system", R2R.Colors, zoneReport) )
    
    UIFrameFadeOut(text, 2, 1, 0)
  end)
  

  --[[------------------------------------------------------------------------
  button background positioning
  ------------------------------------------------------------------------]]--
  R2R.SkyButton.background:SetAllPoints(R2R.SkyButton)
  R2R.SkyButton.background:SetTexture(READI.T.rdl110005)
  --[[------------------------------------------------------------------------
  icon texture positioning
  ------------------------------------------------------------------------]]--
  R2R.SkyButton.icon:SetAllPoints(R2R.SkyButton)

  --[[------------------------------------------------------------------------
  mask texture positioning
  ------------------------------------------------------------------------]]--
  R2R.SkyButton.mask:SetPoint("CENTER", R2R.SkyButton.icon, "CENTER", 0, 0)
  --[[------------------------------------------------------------------------
  use the texture id of the "TempPortraitAlphaMask" (130924)
  ------------------------------------------------------------------------]]--
  R2R.SkyButton.mask:SetTexture(READI.T.rdl110003, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
  R2R.SkyButton.icon:AddMaskTexture(R2R.SkyButton.mask)
  --[[------------------------------------------------------------------------
  button border positioning
  ------------------------------------------------------------------------]]--
  R2R.SkyButton.border:SetAllPoints(R2R.SkyButton)
  R2R.SkyButton.border:SetTexture(READI.T.rdl110007)

  r2r.isLogin = false
  return R2R.SkyButton
end

--[[----------------------------------------------------------------------------
Inititialize the Back2Home button
----------------------------------------------------------------------------]]--
function R2R:InitializeButton()
  --[[------------------------------------------------------------------------
  Create the Button and initially set scale, position and strate
  ------------------------------------------------------------------------]]--
    R2R.SkyButton = R2R.SkyButton or CreateButton()
    R2R.SkyButton:ScaleButton()
    R2R.SkyButton:SetPosition()
    R2R.SkyButton:SetStrata()
    R2R.SkyButton:Update()

    local ButtonPosition = {}

  --[[------------------------------------------------------------------------
  EVENT HANDLERS
  ----------------------------------------------------------------------------
  register all events that should trigger the button
  ------------------------------------------------------------------------]]--
  --[[------------------------------------------------------------------------
  The MOUNT_JOURNAL_USABILITY_CHANGED event is used to check whether the player
  enters a building or another area where mounting is prohibited. This is
  because the ZONE_CHANGED_INDOORS event doesn't fire reliable
  ------------------------------------------------------------------------]]--
    R2R.SkyButton:RegisterEvent("MOUNT_JOURNAL_USABILITY_CHANGED")
    R2R.SkyButton:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    R2R.SkyButton:RegisterEvent("ZONE_CHANGED")
  --[[------------------------------------------------------------------------
  generic event handler so we can implement dedicated methods for each event
  the button should listen on
  ------------------------------------------------------------------------]]--
    local function OnEvent(self, evt, ...)
      if self[evt] then self[evt](self, evt, ...) end
      R2R.SkyButton:Update()
    end

    function R2R.SkyButton:MODIFIER_STATE_CHANGED(evt, key, down)
      if InCombatLockdown() then return end
      
      if down > 0 then
        if key == "LALT" then R2R.ActiveKeys[1] = key end
        if key == "LCTRL" then R2R.ActiveKeys[2] = key end
        if key == "LSHIFT" then R2R.ActiveKeys[3] = key end
      else
        if key == "LALT" then R2R.ActiveKeys[1] = nil end
        if key == "LCTRL" then R2R.ActiveKeys[2] = nil end
        if key == "LSHIFT" then R2R.ActiveKeys[3] = nil end
      end
    end
  --[[------------------------------------------------------------------------
  handling the mouseover event to show the tooltip of the selected mount
  ------------------------------------------------------------------------]]--
    local function OnEnter(self)
      if R2R.SkyButton.tooltip then
        R2R.SkyButton.tooltip:SetOwner(self, "ANCHOR_RIGHT")
        --[[----------------------------------------------------------------------
        set tooltip
        ----------------------------------------------------------------------]]--
          local isMount = R2R:IsMount(r2r.id)
          if isMount then
            R2R.SkyButton.tooltip:SetMountBySpellID(r2r.spellID)
          else
            local i = 1
            local spellBookID = nil
            while true do
              local spell = C_SpellBook.GetSpellBookItemName(i, 0)
              if (not spell) then break end
              if spell == r2r.name then spellBookID = i end
              i = i + 1
            end
            R2R.SkyButton.tooltip:SetSpellBookItem(spellBookID, 0)
          end
        R2R.SkyButton.tooltip:Show()
      end
    end
  --[[------------------------------------------------------------------------
  handling the mouseout event to hide the tooltip
  ------------------------------------------------------------------------]]--
    local function OnLeave(self)
      if R2R.SkyButton.tooltip then
        R2R.SkyButton.tooltip:Hide()
      end
    end
  --[[------------------------------------------------------------------------
  set event scripts
  ------------------------------------------------------------------------]]--
    R2R.SkyButton:SetScript("OnEvent", OnEvent)
    R2R.SkyButton:SetScript("OnEnter", OnEnter)
    R2R.SkyButton:SetScript("OnLeave", OnLeave)
    R2R.SkyButton:SetScript("OnMouseDown", function(self, button)
      if button ~= "MiddleButton" then return end
      ButtonPosition.origin = {R2R.SkyButton:GetPoint(1)}
      self:StartMoving()
      ButtonPosition.dragInit = {R2R.SkyButton:GetPoint(1)}
    end)
    R2R.SkyButton:SetScript("OnMouseUp", function(self, button)
      if button ~= "MiddleButton" then return end

      ButtonPosition.dragOut = {R2R.SkyButton:GetPoint(1)}
      self:StopMovingOrSizing()
      local delta = {
        x = ButtonPosition.dragOut[4] - ButtonPosition.dragInit[4],
        y = ButtonPosition.dragOut[5] - ButtonPosition.dragInit[5],
      }
      R2R.config.anchoring.position_x = format("%.2f", R2R.config.anchoring.position_x + delta.x)
      R2R.config.anchoring.position_y = format("%.2f", R2R.config.anchoring.position_y + delta.y)

      R2R:UpdateOptions(false)
    end)
end