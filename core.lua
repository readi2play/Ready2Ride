local AddonName, r2r = ...
--[[----------------------------------------------------------------------------
-- ADDON MAIN FRAME AND LOCALIZATION TABLE
----------------------------------------------------------------------------]]--
R2R = CreateFrame("Frame")
R2R.title = READI.GetAddOnMetadata(AddonName, "Title")
R2R.icon = READI.GetAddOnMetadata(AddonName, "IconTexture")
R2R.version = READI.GetAddOnMetadata(AddonName, "Version")
R2R.author = READI.GetAddOnMetadata(AddonName, "Author")

R2R.Colors = READI.Helper.table:Merge(
  CopyTable(READI.Colors), {
    r2r = "d4aa00",
    r2r_light = "ffe680"
  }
)
R2R.data = {
  ["addon"] = R2R.title,
  ["prefix"] = "R2R",
  ["colors"] = R2R.Colors
}
--[[----------------------------------------------------------------------------
TEXTURES
----------------------------------------------------------------------------]]--
Ready2RideLogo = "Interface\\AddOns\\Ready2Ride\\Media\\r2r_logo"
--[[------------------------------------------------------------------------]]--
MountSelectorIconMask = "Interface\\AddOns\\Ready2Ride\\Media\\MountSelector_TileIconMaskrder"
MountSelectorSelectorNormal = "Interface\\AddOns\\Ready2Ride\\Media\\MountSelector_SelectorNormal"
MountSelectorSelectorHighlight = "Interface\\AddOns\\Ready2Ride\\Media\\MountSelector_SelectorHighlight"
MountSelectorSelectorActive = "Interface\\AddOns\\Ready2Ride\\Media\\MountSelector_SelectorActive"

MountSelectorFilterGrounded = "Interface\\AddOns\\Ready2Ride\\Media\\MountSelector_FilterGrounded"
MountSelectorFilterFlying = "Interface\\AddOns\\Ready2Ride\\Media\\MountSelector_FilterFlying"
MountSelectorFilterAquatic = "Interface\\AddOns\\Ready2Ride\\Media\\MountSelector_FilterAquatic"
MountSelectorFilterDynamic = "Interface\\AddOns\\Ready2Ride\\Media\\MountSelector_FilterDynamic"
--[[------------------------------------------------------------------------]]--

R2R.Locale = GAME_LOCALE or GetLocale()
R2R.L = {}
R2R.mountLists = {}

--[[----------------------------------------------------------------------------
-- EVENT HANDLERS
----------------------------------------------------------------------------]]--
-- Native Events

function R2R:OnEvent(evt, ...)
  if self[evt] then self[evt](self, evt, ...) end
end

R2R:SetScript("OnEvent", R2R.OnEvent)

R2R:RegisterEvent("ADDON_LOADED")
R2R:RegisterEvent("PLAYER_ENTERING_WORLD")
R2R:RegisterEvent("PLAYER_LEAVING_WORLD")
R2R:RegisterEvent("FIRST_FRAME_RENDERED")

function R2R:ADDON_LOADED(evt, addon)
  if addon ~= AddonName then return end
  self:UnregisterEvent(evt)
  self:InitializeDB()
  self:SetupConfig()
end

function R2R:PLAYER_ENTERING_WORLD(evt, isLogin, isReload)
  R2R.faction, _ = string.lower(UnitFactionGroup("player"))  
  R2R.registered = C_ChatInfo.RegisterAddonMessagePrefix(R2R.data.prefix)

  if not R2R.SkyButton then return end
  R2R.SkyButton:Update()
end

function R2R:PLAYER_LEAVING_WORLD(evt, isLogout, isReload)
  local dbName = AddonName .. "DB"
  if not _G[dbName].use_profiles then return end 
  local charName = format("%s-%s", GetUnitName("player"), GetRealmName())
  _G[dbName.."Chr"] = CopyTable(_G[dbName].chars[charName] or R2R.defaults)
end

function R2R:FIRST_FRAME_RENDERED(evt)
  local mountTypeTitles = {
    R2R.L["Grounded"],
    R2R.L["Flying"],
    R2R.L["Aquatic"],
    R2R.L["Skyriding"],
  }
  for i=1, #RD.MOUNT_TYPES do
    R2R.mountLists[i] = {
      title = mountTypeTitles[i],
      mounts = R2R:GetFilteredListOfMounts(RD.MOUNT_TYPES[i]),
    }
    table.insert(R2R.mountLists[i].mounts, 1, {txt = R2R.L["Unselect Mount"], val = ""})
  end

  R2R:InitializeOptions()
  R2R:InitializeButton()
end

function R2R:GetContinent(zoneID)
  local _r = {mapID = nil, name = nil}
  if not zoneID then return _r end

  local info = C_Map.GetMapInfo(zoneID)
  if not info then return _r end

  while info.mapType and info.mapType > 2 do
    info = C_Map.GetMapInfo(info.parentMapID)
  end

  if info.mapType == 2 then
    _r = C_Map.GetMapInfo(info.mapID)
  end

  return _r
end

function R2R:GetFilteredListOfMounts(filter, ...)
  -- print(filter)
  local filters = { filter }
  local __addFlts = select("#", ...)
  if __addFlts > 0 then
    for i=1,__addFlts do
      table.insert(filters, select(i, ...))
    end
  end
  --[[
    check whether player is using default filter settings
      - all types active
      - all sources active
      - showing collected and not collected but NOT unusable mounts
  ]]--
  local isUsingDefaultFilters = C_MountJournal.IsUsingDefaultFilters()
  
  -- get players current filter settings to restore them later
  local showCollected = C_MountJournal.GetCollectedFilterSetting(RD.MOUNT_COLLECTED)
  local showNotCollected = C_MountJournal.GetCollectedFilterSetting(RD.MOUNT_NOT_COLLECTED)
  local showUnusable = C_MountJournal.GetCollectedFilterSetting(RD.MOUNT_UNUSABLE)

  -- unset all active type filters
  C_MountJournal.SetAllTypeFilters(false)
  C_MountJournal.SetCollectedFilterSetting(RD.MOUNT_NOT_COLLECTED, false)
  C_MountJournal.SetCollectedFilterSetting(RD.MOUNT_UNUSABLE, false)

  -- apply only the specified type filters
  for _,filterIdx in ipairs(filters) do
    C_MountJournal.SetTypeFilter(filterIdx, true)
  end
  -- get all mountIDs for that filter
  local numMounts = C_MountJournal.GetNumDisplayedMounts()
  local mounts = {}

  for i=1,numMounts do
    local name = select(1, C_MountJournal.GetDisplayedMountInfo(i))
    local mountID = select(12, C_MountJournal.GetDisplayedMountInfo(i))
    table.insert(mounts, { txt = name, val = mountID })
  end
  
  -- reset all type filters or default settings (if applied)
  if isUsingDefaultFilters then
    C_MountJournal.SetDefaultFilters()
  else
    C_MountJournal.SetAllTypeFilters(true)
  end
  return mounts
end

function R2R:GetMountID()
  if IsSubmerged() then
    local hasAbility = R2R.db.bindings.swimming.ability ~= ""
    if hasAbility then
      return R2R.db.bindings.swimming.ability
    else
      return R2R.db.bindings.swimming.mount
    end
  end

  R2R.ZoneID = C_Map.GetBestMapForUnit("player")
  if not R2R.ZoneID then return nil end
  R2R.ContinentID = R2R:GetContinent(R2R.ZoneID).mapID or R2R.ZoneID

  local currentContinent = RD.Helper.table:Filter(R2R.db.continents, function(c) return c.zoneID == R2R.ContinentID end)[1]

  if currentContinent.hasZones and currentContinent.useZones then
    local currentZone = RD.Helper.table:Filter(currentContinent.zones, function(z) return z.zoneID == R2R.ZoneID end)[1]
    if currentZone and currentZone.mountID ~= "" then
      return currentZone.mountID
    else
      return currentContinent.mountID
    end
  end
  return currentContinent.mountID
end

function R2R:GetMount(id)
  if not id then return nil, nil, nil end
  local name, spellID, icon = C_MountJournal.GetMountInfoByID(id)
  return name, spellID, icon
end

function R2R:IsMount(id)
  local name, spellID, icon = R2R:GetMount(id)
  return (name and spellID and icon) ~= nil
end

function R2R:InitializeDB ()
  local dbName = AddonName .. "DB"
  local charName = format("%s-%s", GetUnitName("player"), GetRealmName())
  -- get or create the overall SavedVariables
  _G[dbName] = _G[dbName] or {
    use_profiles = false
  }

  -- get or create the global table
  _G[dbName].global = _G[dbName].global or {}
  READI.Helper.table:Move(R2R.defaults, _G[dbName], _G[dbName].global)
  if not next(_G[dbName].global) then
    _G[dbName].global = CopyTable(R2R.defaults)
  else
    _G[dbName].global = READI.Helper.table:Merge({}, CopyTable(R2R.defaults), _G[dbName].global)
  end

  R2R.db = _G[dbName].global

  -- get or create the character specific table
  _G[dbName].chars = _G[dbName].chars or {}
  if _G[dbName].use_profiles then
    _G[dbName].chars[charName] = _G[dbName].chars[charName] or CopyTable(R2R.defaults)
    
    _G[dbName].chars[charName].assigned_profile = _G[dbName].chars[charName].assigned_profile or charName
    local _ap = _G[dbName].chars[charName].assigned_profile

    if _ap ~= "global" then
      _G[dbName].chars[_ap] = READI.Helper.table:Merge({}, CopyTable(R2R.defaults), _G[dbName].chars[_ap])
    else
      _G[dbName].chars[_ap] = _G[dbName].global
    end

    R2R.db = _G[dbName].chars[_ap]
  end

  -- perform a cleanup to remove no longer used keys
  READI.Helper.table:CleanUp(R2R.defaults, R2R.db, "assigned_profile")
end
--[[------------------------------------------------------------------------]]--
_G[AddonName .. '_Options'] = function(key)
  _G[R2R.data.prefix .. RD.Helper.string:Capitalize(key).."TabButton"]:Click()
  R2R.ConfigDialog:Show()
  -- Settings.OpenToCategory(AddonName)
end
-- enable the addon, this is defined in classic/modern
if type(r2r.Enable) == "function" then R2R:Enable() end

--[[----------------------------------------------------------------------------
-- SLASH COMMANDS
----------------------------------------------------------------------------]]--
SLASH_R2R1 = "/sky"

-- define the corresponding slash command handlers
SlashCmdList.R2R = function(msg, editBox)
  msg = string.lower(msg)
  local configKeywords = {"mounts", "specials", "anchoring", "profiles"}
  if READI.Helper.table:Contains(msg, configKeywords) then
    _G[AddonName .. '_Options'](msg)
  else
    R2R.ConfigDialog:Clear()
    R2R.ConfigDialog:Show()
  end
end
