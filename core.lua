local AddonName, r2r = ...
--------------------------------------------------------------------------------
-- ADDON MAIN FRAME AND LOCALIZATION TABLE
--------------------------------------------------------------------------------
R2R = CreateFrame("Frame")


R2R.Colors = READI.Helper.table:Merge(
  CopyTable(READI.Colors), {
    r2r = "d4aa00",
    r2r_light = "ffe680"
  }
)

R2R.data = {
  ["addon"] = "Back2Home",
  ["prefix"] = "R2R",
  ["colors"] = R2R.Colors
}
R2R.Locale = GAME_LOCALE or GetLocale()
R2R.KeysToBind = {"LALT", "LCTRL", "LSHIFT"}
R2R.ActiveKeys = {nil, nil, nil}

R2R.L = {}

--------------------------------------------------------------------------------
-- EVENT HANDLERS
--------------------------------------------------------------------------------
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
  -- implement functionality
  R2R.mounts = R2R.mounts or C_MountJournal.GetCollectedDragonridingMounts()
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

function R2R:GetMountID()
  -- if #R2R.ActiveKeys > 0 then
  --   local key = table.concat(READI.Helper.table:Filter(R2R.ActiveKeys, function(v) return v ~= nil end), "+")
  --   if R2R.config.bindings.keys[key] then
  --     return R2R.config.bindings.keys[key]
  --   end
  -- end

  if IsSubmerged() then
    return R2R.config.bindings.swimming
  end

  R2R.Zone = C_Map.GetBestMapForUnit("player")
  local zoneID = tostring(R2R.Zone)
  R2R.ContinentID = tostring(R2R:GetContinent(R2R.Zone).mapID)

  
  if R2R.config.continents[R2R.ContinentID].hasZones and R2R.config.continents[R2R.ContinentID].useZones and R2R.config.continents[R2R.ContinentID].zones[zoneID] then
    return R2R.config.continents[R2R.ContinentID].zones[zoneID].mountID or R2R.config.continents[R2R.ContinentID].mountID
  end

  return R2R.config.continents[R2R.ContinentID].mountID
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

function R2R:InitializeDB()
  local dbName = AddonName .. "DB"
  local _char = format("%s-%s", GetUnitName("player"), GetRealmName())

  R2R.db = READI:InitConfig(dbName, _G[dbName], R2R.defaults)

  if R2R.db.use_profiles then
    local _ap = R2R.db.chars[_char].assigned_profile
    R2R.config = R2R.db.chars[_ap]
  else
    R2R.config = R2R.db.global
  end
end