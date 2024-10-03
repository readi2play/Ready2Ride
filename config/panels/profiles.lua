--[[----------------------------------------------------------------------------
BASICS
----------------------------------------------------------------------------]]--
  local AddonName, r2r = ...
  local data = CopyTable(R2R.data)
  data.keyword = "profiles"
  local charName = format("%s-%s", GetUnitName("player"), GetRealmName())
  local __default = "global"
  local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
  --[[----------------------------------------------------------------------------
CREATE PROFILES PANEL CONTENT
----------------------------------------------------------------------------]]--
local Profiler = {
  defaultProfile = {txt = R2R.L["Default"], val = __default},
  activeProfile = {
    label = "",
    description = "",
    dropdown = nil,
    selection = nil,
  },
  copyProfile = {
    label = "",
    description = "",
    dropdown = nil,
  },
  deleteProfile = {
    label = "",
    description = "",
    dropdown = nil,
  },
}

R2R.Profile = R2R.Profile or {
  Select = function()
    local __selection = Profiler.activeProfile.dropdown:GetValue()
    _G[AddonName.."DB"].chars[charName].assigned_profile = __selection
  
    if __selection ==  __default then
      R2R.db = _G[AddonName.."DB"].global
    else
      R2R.db = _G[AddonName.."DB"].chars[__selection]
    end
    R2R:UpdateOptions()    
  end,
  Copy = function()
    --[[---------------------------------------------------------------------
    get value currently selected and return early if no value could
    be fetched
    ---------------------------------------------------------------------]]--
      local __selection = Profiler.copyProfile.dropdown:GetValue()
      if not __selection then return end
    --[[---------------------------------------------------------------------
    get currently selected active profile and set the destinated profile
    according to the fetched value
    ---------------------------------------------------------------------]]--      
      local __active = Profiler.activeProfile.dropdown:GetValue()
      local dst = _G[AddonName.."DB"].global
      if __active ~=  __default then
        dst = _G[AddonName.."DB"].chars[__active]
      end
    --[[---------------------------------------------------------------------
    set the source profile to copy settings from according to the currently
    selected profile
    ---------------------------------------------------------------------]]--
      local src = _G[AddonName.."DB"].global
      if __selection ~=  __default then src = _G[AddonName.."DB"].chars[__selection] end
    --[[---------------------------------------------------------------------
    manually copy settings from selected source profile to destinated profile
    this cannot be done using CopyTable on the entire profile table because
    that doesn't seem to assign the values to their respective keys properly
    ---------------------------------------------------------------------]]--
      for k,v in pairs(src) do
        if type(v) == "table" then
          dst[k] = CopyTable(v)
        else
          dst[k] = v
        end
      end
    R2R:UpdateOptions()    
    Profiler.copyProfile.dropdown:SetValue(nil)
  end,
  Delete = function()
    --[[----------------------------------------------------------------------
    get the value currently selected within the dropdown and return early if
    no value has been selected
    ----------------------------------------------------------------------]]--
      local __selection = Profiler.deleteProfile.dropdown:GetValue()
      if not __selection then return end
    --[[----------------------------------------------------------------------
    prepare a filler function for the prompt shown when trying to delete a
    profile
    ----------------------------------------------------------------------]]--
      local function FillPrompt(__p)
        __p.text = __p.text or __p:CreateFontString(READI.ARTWORK, nil, "GameFontNormal")
        __p.text:SetText(
          READI.Helper.color:Get("white", nil, format(
            R2R.L["Are your sure that you want to delete the profile %s"],
            READI.Helper.color:Get("r2r_light", R2R.Colors, __selection)
          ))
        )
        if __p.title then
          __p.text:SetPoint(READI.ANCHOR_TOPLEFT, __p.titleDivider, READI.ANCHOR_BOTTOMLEFT, 0, -5)
        else
          __p.text:SetPoint(READI.ANCHOR_TOPLEFT, __p, READI.ANCHOR_TOPLEFT, 20, -30)
        end
        __p.text:SetWidth(__p.titleDivider:GetWidth())
        __p.text:SetJustifyH(READI.ANCHOR_LEFT)
        __p.text:SetJustifyV(READI.ANCHOR_TOP)
        __p.text:SetWordWrap(true)

        if __p.icon then
          __p.icon:SetPoint(READI.ANCHOR_CENTER, __p, READI.ANCHOR_TOPLEFT, 10,-10)
          __p.icon:SetFrameStrata(READI.Strata[6])
          __p.icon:SetFrameLevel(100)
        end
      end
    --[[----------------------------------------------------------------------
    define the frame name of the prompt and reuse the frame if already existent
    create a new dialog frame otherwise
    ----------------------------------------------------------------------]]--
      local promptName = "R2R_DeleteProfilePrompt"
      local prompt = _G[promptName] or READI:Dialog(data, {
        name = promptName,
        title = READI.Helper.color:Get("r2r", R2R.Colors, R2R.L["Delete Profile"]),
        buttonSet = {
          {
            key = "cancel",
            label = R2R.L["No"],
            offsetY = 10,
            parent = {
              anchor = READI.ANCHOR_BOTTOMRIGHT,
            },
            onClick = function() end
          },
          {
            key = "confirm",
            label = R2R.L["Yes"],
            parent = {
              anchor = READI.ANCHOR_BOTTOMLEFT,
            },
                onClick = function()
              local __selection = Profiler.deleteProfile.dropdown:GetValue()
              local __active = Profiler.activeProfile.dropdown:GetValue()
    
              local src = _G[AddonName.."DB"].chars[__selection]
              if __selection == __active then
                if __selection == charName then
                  R2R.db = _G[AddonName.."DB"].global
                  Profiler.activeProfile.dropdown:SetValue(Profiler.defaultProfile.val, Profiler.defaultProfile.txt)
                else
                  R2R.db = _G[AddonName.."DB"].chars[charName]
                  Profiler.activeProfile.dropdown:SetValue(charName)
                end
              end      
              local __actIdx = READI.Helper.table:Get(Profiler.activeProfile.dropdown.MenuList, function(k,v) return v == __selection end)
              table.remove(Profiler.activeProfile.dropdown.MenuList, __actIdx)
        
              local __copIdx = READI.Helper.table:Get(Profiler.copyProfile.dropdown.MenuList, function(k,v) return v == __selection end)
              table.remove(Profiler.copyProfile.dropdown.MenuList, __copIdx)
        
              local __delIdx = READI.Helper.table:Get(Profiler.deleteProfile.dropdown.MenuList, function(k,v) return v == __selection end)
              table.remove(Profiler.deleteProfile.dropdown.MenuList, __delIdx)
        
              _G[AddonName.."DB"].chars[__selection] = nil
            end
          }
        },
        level = 900,
        allowKeyboard = true,
        closeOnEsc = true,
        createHidden = false,
        closeXButton = {
          hidden = true,
        },
        onClose = function()
          Profiler.deleteProfile.dropdown:SetValue(nil)
        end
      })
    --[[----------------------------------------------------------------------
    calling the filler function and handling when to show the prompt
    ----------------------------------------------------------------------]]--
      FillPrompt(prompt)
      if not prompt:IsVisible() then prompt:Show() end
  end,
}
function R2R:FillProfilesPanel(panel, container, anchorline)
  local namingPrefix = "SettingsPanel"
  if panel == R2R.ConfigDialog then
    r2r.windowWidth = ceil(container:GetWidth() - 20)
    namingPrefix = panel:GetName()
  else
    r2r.windowWidth = SettingsPanel.Container:GetWidth()
  end
  r2r.columnWidth = r2r.windowWidth / r2r.columns - 20

  --[[---------------------------------------------------------------------------
  Toggle profile usage
  ---------------------------------------------------------------------------]]--
    local activated = _G[AddonName.."DB"].use_profiles
    -------------------------------------------------------------------------------
    local profiles_sectionTitle = container:CreateFontString(READI.ARTWORK, nil, "GameFontHighlightLarge")
    profiles_sectionTitle:SetPoint(READI.ANCHOR_TOPLEFT, anchorline, 20, -20)
    profiles_sectionTitle:SetText(READI.Helper.color:Get("r2r", R2R.Colors, R2R.L["Character Profiles"]))
    -------------------------------------------------------------------------------
    local activationDescription = container:CreateFontString(READI.ARTWORK, nil, "GameFontNormal")
    activationDescription:SetPoint(READI.ANCHOR_TOPLEFT, profiles_sectionTitle, READI.ANCHOR_BOTTOMLEFT, 0, -10)
    activationDescription:SetText(READI.Helper.color:Get("white", nil, R2R.L["This checkbox allows you to activate or deactivate character specific storage profiles allowing you to individually configure the SkyridingButton for each of your characters."]))
    activationDescription:SetJustifyH(READI.ANCHOR_LEFT)
    activationDescription:SetJustifyV(READI.ANCHOR_TOP)
    activationDescription:SetWidth(r2r.windowWidth - 20)
    activationDescription:SetWordWrap(true)
    local cbName = format("%s%s_%s_activate", data.prefix, namingPrefix, READI.Helper.string:Capitalize(data.keyword))
    local opts = {
      name = cbName,
      region = container,
      label = R2R.L["Activate character specific profiles"],
      parent = activationDescription,
      p_anchor = READI.ANCHOR_BOTTOMLEFT,
      offsetX = 0,
      offsetY = -10,
      onClick = function(self)
        _G[AddonName.."DB"].use_profiles = self:GetChecked()
        activated = self:GetChecked()
        EventRegistry:TriggerEvent("R2R.PROFILE_ACTIVATION_CHANGED")
      end
    }
    local activationCB = READI:CheckBox(data, opts)
    activationCB:SetState(true)
    activationCB:SetChecked(activated)
    -------------------------------------------------------------------------------
    local wrapper = CreateFrame("Frame", nil, container)
    wrapper:SetPoint(READI.ANCHOR_TOPLEFT, activationCB, READI.ANCHOR_BOTTOMLEFT, 0,0)
    wrapper:SetPoint(READI.ANCHOR_RIGHT, container, READI.ANCHOR_RIGHT, 0,0)
    wrapper:SetHeight(0)
    -------------------------------------------------------------------------------
    if activated then
      wrapper:Show()
    else
      wrapper:Hide()
    end

  --[[----------------------------------------------------------------------------
  Handling of profile activation
  ----------------------------------------------------------------------------]]--
    EventRegistry:RegisterCallback("R2R.PROFILE_ACTIVATION_CHANGED", function(evt)
      R2R.db = _G[AddonName.."DB"].global
      if activated then
        _G[AddonName.."DB"].chars[charName] = _G[AddonName.."DB"].chars[charName] or CopyTable(R2R.defaults)
        _G[AddonName.."DB"].chars[charName].assigned_profile = _G[AddonName.."DB"].chars[charName].assigned_profile or __default
        local __ap = _G[AddonName.."DB"].chars[charName].assigned_profile
        if __ap ~= __default then
          R2R.db = _G[AddonName.."DB"].chars[ __ap ]
          Profiler.activeProfile.dropdown:SetValue(__ap)
        else
          Profiler.activeProfile.dropdown:SetValue(Profiler.defaultProfile.val, Profiler.defaultProfile.txt)
        end
        wrapper:Show()
        Profiler.activeProfile.dropdown:AddToMenuList(charName)
        Profiler.copyProfile.dropdown:AddToMenuList(charName)
        Profiler.deleteProfile.dropdown:AddToMenuList(charName)
      else
        wrapper:Hide()
      end
      R2R:UpdateOptions()    
    end)
  --[[----------------------------------------------------------------------------
  Active Profile section
  ----------------------------------------------------------------------------]]--
    Profiler.activeProfile.list = READI.Helper.table:Filter(READI.Helper.table:Keys(_G[AddonName.."DB"].chars), function(val) return val ~= __default end)
    table.insert(Profiler.activeProfile.list, 1, Profiler.defaultProfile)
    --------------------------------------------------------------------------------
    Profiler.activeProfile.label = wrapper:CreateFontString(READI.ARTWORK, nil, "GameFontNormal")
    Profiler.activeProfile.label:SetPoint(READI.ANCHOR_TOPLEFT, wrapper, READI.ANCHOR_TOPLEFT, 0, -10)
    Profiler.activeProfile.label:SetText(READI.Helper.color:Get("white", nil, R2R.L["Select the profile to be used for this Character"]))
    Profiler.activeProfile.label:SetJustifyH(READI.ANCHOR_LEFT)
    Profiler.activeProfile.label:SetJustifyV(READI.ANCHOR_TOP)
    Profiler.activeProfile.label:SetWidth(r2r.columnWidth)
    Profiler.activeProfile.label:SetWordWrap(true)
    -------------------------------------------------------------------------------
    Profiler.activeProfile.dropdown = READI:DropDown(data, {
      values = Profiler.activeProfile.list,
      storage = "R2R.db",
      option = "assigned_profile",
      condition = R2R.db ~= _G[AddonName.."DB"].global,
      name = format("%s%s_Dropdown_activeProfile", data.prefix, namingPrefix),
      region = wrapper,
      parent = Profiler.activeProfile.label,
      offsetX = -20,
      offsetY = -10,
      onChange = R2R.Profile.Select
    })

  --[[----------------------------------------------------------------------------
  Copy Profile section
  ----------------------------------------------------------------------------]]--
    Profiler.copyProfile.list = CopyTable(Profiler.activeProfile.list)
    --------------------------------------------------------------------------------
    Profiler.copyProfile.label = wrapper:CreateFontString(READI.ARTWORK, nil, "GameFontNormal")
    Profiler.copyProfile.label:SetPoint(READI.ANCHOR_TOPLEFT, Profiler.activeProfile.dropdown, READI.ANCHOR_BOTTOMLEFT, 20, -100)
    Profiler.copyProfile.label:SetText(READI.Helper.color:Get("r2r_light", R2R.Colors, R2R.L["Copy from ..."]))
    Profiler.copyProfile.label:SetJustifyH(READI.ANCHOR_LEFT)
    Profiler.copyProfile.label:SetJustifyV(READI.ANCHOR_TOP)
    Profiler.copyProfile.label:SetWidth(r2r.columnWidth - 20)
    Profiler.copyProfile.label:SetWordWrap(true)
    -------------------------------------------------------------------------------
    Profiler.copyProfile.dropdown = READI:DropDown(data, {
      values = Profiler.copyProfile.list,
      option = nil,
      name = format("%s%s_Dropdown_copyProfile",data.prefix, namingPrefix),
      region = wrapper,
      parent = Profiler.copyProfile.label,
      offsetX = -20,
      offsetY = -10,
    })
    -------------------------------------------------------------------------------
    Profiler.copyProfile.description = wrapper:CreateFontString(READI.ARTWORK, nil, "GameFontNormalSmall")
    Profiler.copyProfile.description:SetPoint(READI.ANCHOR_TOPLEFT, Profiler.copyProfile.dropdown, READI.ANCHOR_BOTTOMLEFT, 20, -5)
    Profiler.copyProfile.description:SetText(READI.Helper.color:Get("white", nil, format(R2R.L["This will copy settings from another profile into the active one when hitting the \"%s\" button."], R2R.L["Submit"]), "white"))
    Profiler.copyProfile.description:SetJustifyH(READI.ANCHOR_LEFT)
    Profiler.copyProfile.description:SetJustifyV(READI.ANCHOR_TOP)
    Profiler.copyProfile.description:SetWidth(r2r.columnWidth - 20)
    Profiler.copyProfile.description:SetWordWrap(true)
    -------------------------------------------------------------------------------
    Profiler.copyProfile.button = READI:Button(data, {
      name = format("%s%s_CopyProfileButton",data.prefix, namingPrefix),
      label = R2R.L["Submit"],
      region = wrapper,
      parent = Profiler.copyProfile.description,
      p_anchor = READI.ANCHOR_BOTTOMLEFT,
      offsetY = -10,
      onClick = R2R.Profile.Copy
    })
  --[[----------------------------------------------------------------------------
  Delete Profile section
  ----------------------------------------------------------------------------]]--
    Profiler.deleteProfile.list = READI.Helper.table:Filter(READI.Helper.table:Keys(_G[AddonName.."DB"].chars), function(val) return val ~= __default end)
    --------------------------------------------------------------------------------
    Profiler.deleteProfile.label = wrapper:CreateFontString(READI.ARTWORK, nil, "GameFontNormal")
    Profiler.deleteProfile.label:SetPoint(READI.ANCHOR_TOPLEFT, Profiler.copyProfile.label, READI.ANCHOR_TOPLEFT, r2r.columnWidth, 0)
    Profiler.deleteProfile.label:SetText(READI.Helper.color:Get("r2r_light", R2R.Colors, R2R.L["Delete Profile"], "r2r_light"))
    Profiler.deleteProfile.label:SetJustifyH(READI.ANCHOR_LEFT)
    Profiler.deleteProfile.label:SetJustifyV(READI.ANCHOR_TOP)
    Profiler.deleteProfile.label:SetWidth(r2r.columnWidth - 20)
    Profiler.deleteProfile.label:SetWordWrap(true)
    -------------------------------------------------------------------------------
    Profiler.deleteProfile.dropdown = READI:DropDown(data, {
      values = Profiler.deleteProfile.list,
      option = nil,
      name = format("%s%s_Dropdown_deleteProfile",data.prefix, namingPrefix),
      region = wrapper,
      parent = Profiler.deleteProfile.label,
      p_anchor = READI.ANCHOR_BOTTOMLEFT,
      offsetX = -20,
      offsetY = -10,
    })
    -------------------------------------------------------------------------------
    Profiler.deleteProfile.description = wrapper:CreateFontString(READI.ARTWORK, nil, "GameFontNormalSmall")
    Profiler.deleteProfile.description:SetPoint(READI.ANCHOR_TOPLEFT, Profiler.deleteProfile.dropdown, READI.ANCHOR_BOTTOMLEFT, 20, -5)
    Profiler.deleteProfile.description:SetText(READI.Helper.color:Get("white", nil, format(R2R.L["Hit the \"%s\" button to remove an unused or no longer required profile."], R2R.L["Submit"])))
    Profiler.deleteProfile.description:SetJustifyH(READI.ANCHOR_LEFT)
    Profiler.deleteProfile.description:SetJustifyV(READI.ANCHOR_TOP)
    Profiler.deleteProfile.description:SetWidth(r2r.columnWidth - 20)
    Profiler.deleteProfile.description:SetWordWrap(true)
    -------------------------------------------------------------------------------
    Profiler.deleteProfile.button = READI:Button(data, {
      name = format("%s%s_DeleteProfileButton",data.prefix, namingPrefix),
      label = R2R.L["Submit"],
      region = wrapper,
      parent = Profiler.deleteProfile.description,
      p_anchor = READI.ANCHOR_BOTTOMLEFT,
      offsetY = -10,
      onClick = R2R.Profile.Delete
    })
end