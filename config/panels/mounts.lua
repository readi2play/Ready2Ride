--[[----------------------------------------------------------------------------
BASICS
----------------------------------------------------------------------------]]--
local AddonName, r2r = ...
local data = CopyTable(R2R.data)
data.keyword = "mounts"
R2R.Mounts = R2R.Mounts or {
  sections = {},
  fields = {},
  ScrollFrame = nil,
  ScrollChild = nil,
}
--[[----------------------------------------------------------------------------
OPTIONS PANEL CREATION
----------------------------------------------------------------------------]]--
function R2R:FillMountsPanel(panel, container, anchorline)
  r2r.windowWidth = ceil(container:GetWidth() - 20)
  r2r.columnWidth = r2r.windowWidth / r2r.columns - 20

  --[[--------------------------------------------------------------------------
  CREATE SCROLLABLE FRAME
  --------------------------------------------------------------------------]]--

  local scrollFrameName = format("%s_%sScrollFrame", data.prefix, data.keyword)
  R2R.Mounts.ScrollFrame = R2R.Mounts.ScrollFrame or CreateFrame("ScrollFrame", scrollFrameName, container, "UIPanelScrollFrameTemplate")
  R2R.Mounts.ScrollFrame:ClearAllPoints()
  R2R.Mounts.ScrollFrame:SetPoint(RD.ANCHOR_TOPLEFT, anchorline, RD.ANCHOR_TOPLEFT, 10, -10)
  R2R.Mounts.ScrollFrame:SetPoint(RD.ANCHOR_BOTTOMRIGHT, container, RD.ANCHOR_BOTTOMRIGHT, -30, 10)
  
  local scrollChildName = format("%s_%sScrollChild", data.prefix, data.keyword)
  if not R2R.Mounts.ScrollChild then
    R2R.Mounts.ScrollChild = CreateFrame("Frame", scrollChildName, R2R.Mounts.ScrollFrame)
    R2R.Mounts.ScrollChild:SetSize(R2R.Mounts.ScrollFrame:GetWidth(), R2R.Mounts.ScrollFrame:GetHeight())
    R2R.Mounts.ScrollFrame:SetScrollChild(R2R.Mounts.ScrollChild)
  end

  local schrollChildHeight = 0
  
  for i=#R2R.db.continents, 1, -1 do
    local map = R2R.db.continents[i]
    local sectionHeight = 0
    local wrapperHeight = 0
    local gap = 10
    local mapID = map.zoneID
    local mapName = C_Map.GetMapInfo(map.zoneID).name
    local frameName = format("%s_%sMapSection_ID%d", data.prefix, data.keyword, mapID)
    local region = R2R.Mounts.ScrollChild
    local p_anchor = RD.ANCHOR_TOPLEFT
    local offsetY = 0
    local columnWidth = R2R.Mounts.ScrollChild:GetWidth() / r2r.columns - 20

    if R2R.Mounts.sections[i+1] then
      region = R2R.Mounts.sections[i+1]
      p_anchor = RD.ANCHOR_BOTTOMLEFT
      offsetY = gap * -1
    end

    schrollChildHeight = schrollChildHeight + offsetY

    -- remember "SettingsExpandableSectionTemplate" maybe this could be helpful somewhen for now we gonna use "BackdropTemplate"
    R2R.Mounts.sections[i] = R2R.Mounts.sections[i] or CreateFrame("Frame", frameName, R2R.Mounts.ScrollChild, "BackdropTemplate")
    R2R.Mounts.sections[i]:ClearAllPoints()
    R2R.Mounts.sections[i]:SetClipsChildren(true)
    R2R.Mounts.sections[i]:SetPoint(RD.ANCHOR_TOPLEFT, region, p_anchor, 0, offsetY)
    R2R.Mounts.sections[i]:SetWidth(R2R.Mounts.ScrollChild:GetWidth())

    R2R.Mounts.sections[i].background = R2R.Mounts.sections[i].background or R2R.Mounts.sections[i]:CreateTexture(R2R.Mounts.sections[i]:GetName().."BACKGROUND", RD.BACKGROUND)
    R2R.Mounts.sections[i].background:ClearAllPoints()
    R2R.Mounts.sections[i].background:SetAllPoints()
    R2R.Mounts.sections[i].background:SetColorTexture(0.03,0.02,0,0.5)

    R2R.Mounts.sections[i]:SetBackdrop({
      edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
      edgeSize = 8,
      insets = {left = 0, right = 0, top = 0, bottom = 0},
    })
    R2R.Mounts.sections[i]:SetBackdropBorderColor(0.7,0.68,0.69,0.5)
  
    R2R.Mounts.sections[i].Title = R2R.Mounts.sections[i].Title or R2R.Mounts.sections[i]:CreateFontString(RD.ARTWORK, nil, "GameFontHighlightLarge")
    R2R.Mounts.sections[i].Title:SetPoint(RD.ANCHOR_TOPLEFT, R2R.Mounts.sections[i], RD.ANCHOR_TOPLEFT, gap, gap * -1)
    R2R.Mounts.sections[i].Title:SetJustifyH(RD.ANCHOR_LEFT)
    R2R.Mounts.sections[i].Title:SetWidth(R2R.Mounts.sections[i]:GetWidth())
    R2R.Mounts.sections[i].Title:SetText(RD.Helper.color:Get("r2r", R2R.Colors, mapName))
    
    sectionHeight = sectionHeight + R2R.Mounts.sections[i].Title:GetLineHeight() + gap * 2
    local cbName = nil
    if map.hasZones and map.zones then
      cbName = format("%s_%sUseZones_%d", data.prefix, data.keyword, mapID)
      R2R.Mounts.fields[cbName] = READI:CheckBox(data, {
        name = cbName,
        region = R2R.Mounts.sections[i],
        enabled = true,
        label = {
          string = R2R.L["Use zone specific mounts"],
          spacing = 0,
          scale = 1.3,
        },
        parent = R2R.Mounts.sections[i].Title,
        p_anchor = "BOTTOMLEFT",
        offsetY = -10,
        offsetX = 0,
        onClick = function()
          R2R.db.continents[i].useZones = R2R.Mounts.fields[cbName]:GetChecked()
          R2R.SkyButton:Update()
        end,
      })
      R2R.Mounts.fields[cbName]:SetChecked(map.useZones)
      sectionHeight = sectionHeight + R2R.Mounts.fields[cbName]:GetHeight() + gap
    end
    local parent = R2R.Mounts.sections[i].Title
    
    if cbName then
      parent = R2R.Mounts.fields[cbName]
    end

    R2R.Mounts.sections[i].Wrapper = R2R.Mounts.sections[i].Wrapper or CreateFrame("Frame", wrapperName, R2R.Mounts.sections[i])
    R2R.Mounts.sections[i].Wrapper:ClearAllPoints()
    R2R.Mounts.sections[i].Wrapper:SetPoint(RD.ANCHOR_TOPLEFT, parent, RD.ANCHOR_BOTTOMLEFT, gap, gap * -1)

    local continentMountTitle = R2R.Mounts.sections[i]:CreateFontString(RD.ARTWORK, nil, "GameFontHighlight")
    continentMountTitle:SetPoint(RD.ANCHOR_TOPLEFT, R2R.Mounts.sections[i].Wrapper, RD.ANCHOR_TOPLEFT, 0, gap * -1)
    continentMountTitle:SetJustifyH(RD.ANCHOR_LEFT)
    continentMountTitle:SetWidth(R2R.Mounts.sections[i]:GetWidth())
    continentMountTitle:SetText(
      RD.Helper.color:Get("white", nil, R2R.L["Select the mount to be used for:"]).."\n"..
      RD.Helper.color:Get("r2r_light", R2R.Colors, mapName)..
      RD.Helper.color:Get("white", nil, format(" (mapID: %d)", mapID))
    )
    sectionHeight = sectionHeight + continentMountTitle:GetLineHeight() + gap * 2

    local c_ebName = format("%s_%sZoneMount_%d", data.prefix, data.keyword, mapID)
    local c_ebVal = ""
    if R2R.db.continents[i].mountID ~= "" then
      c_ebVal = C_MountJournal.GetMountInfoByID(R2R.db.continents[i].mountID)
    end
    R2R.Mounts.fields[c_ebName] = R2R.Mounts.fields[c_ebName] or READI:EditBox(data, {
      name = c_ebName,
      region = R2R.Mounts.sections[i].Wrapper,
      type = "text",
      value = c_ebVal,
      parent = continentMountTitle,
      showButtons = true,
      onChange = function()
        local _old = R2R.db.continents[i].mountID
        local _val = R2R.Mounts.fields[c_ebName]:GetText()
        local _new = nil
        if _val == "" then
          R2R.db.continents[i].mountID = ""
        elseif _val ~= _old then
          C_MountJournal.SetSearch(_val)
          _new = C_MountJournal.GetDisplayedMountID(1)
          print(new)
          if _new and R2R.db.continents[i].useZones then
            R2R.db.continents[i].mountID = _new
          else
            R2R.db.continents[i].mountID = ""
          end
          C_MountJournal.SetSearch("")
        end
        R2R.SkyButton:Update()
      end,
    })
    R2R.Mounts.fields[c_ebName.."Button"] = R2R.Mounts.fields[c_ebName.."Button"] or READI:Button(data, {
      name = c_ebName.."Button",
      region = R2R.Mounts.sections[i].Wrapper,
      label = R2R.L["Select"],
      height = 22,
      anchor = RD.ANCHOR_LEFT,
      parent = R2R.Mounts.fields[c_ebName],
      p_anchor = RD.ANCHOR_RIGHT,
      offsetX = 5,
      onClick = function(self)
        local field = R2R.Mounts.fields[c_ebName]
        data.frameName = field:GetText()
        R2R.MountSelector:Open(field)
      end,
    })
    wrapperHeight = R2R.Mounts.fields[c_ebName]:GetHeight() + gap
    sectionHeight = sectionHeight + wrapperHeight
    R2R.Mounts.sections[i].Wrapper:SetSize(columnWidth, wrapperHeight)

    if map.hasZones and map.zones then
      R2R.Mounts.sections[i].subs = R2R.Mounts.sections[i].subs or {}

      for k, zone in ipairs(map.zones) do
        local wrapperName = format("%s_%sZoneWrapper_%d_%d", data.prefix, data.keyword, mapID, zone.zoneID)
        local wrapperHeight = 0

        R2R.Mounts.sections[i].subs[k] = R2R.Mounts.sections[i].subs[k] or CreateFrame("Frame", wrapperName, R2R.Mounts.sections[i])
        R2R.Mounts.sections[i].subs[k]:ClearAllPoints()
        R2R.Mounts.sections[i].subs[k]:SetWidth(columnWidth)

        local parent = R2R.Mounts.fields[c_ebName]
        local offsetX = 0
        local offsetY = gap * -2
        local p_anchor = RD.ANCHOR_BOTTOMLEFT

        if k % r2r.columns == 0 then
          parent = R2R.Mounts.sections[i].subs[k - 1]
          offsetX = 10
          offsetY = 0
          p_anchor = RD.ANCHOR_TOPRIGHT
        elseif k > r2r.columns and k % r2r.columns == 1 then
          offsetY = gap * -1
          parent = R2R.Mounts.sections[i].subs[k - r2r.columns]
        end

        R2R.Mounts.sections[i].subs[k]:SetPoint(RD.ANCHOR_TOPLEFT, parent, p_anchor, offsetX, 0)
        
        R2R.Mounts.sections[i].subs[k].Title = R2R.Mounts.sections[i].subs[k].Title or R2R.Mounts.sections[i].subs[k]:CreateFontString(RD.ARTWORK, nil, "GameFontHighlight")
        R2R.Mounts.sections[i].subs[k].Title:SetPoint(RD.ANCHOR_TOPLEFT, R2R.Mounts.sections[i].subs[k], RD.ANCHOR_TOPLEFT, gap, gap * -1)
        R2R.Mounts.sections[i].subs[k].Title:SetJustifyH(RD.ANCHOR_LEFT)
        R2R.Mounts.sections[i].subs[k].Title:SetWidth(columnWidth)
        R2R.Mounts.sections[i].subs[k].Title:SetText(
          RD.Helper.color:Get("white", nil, R2R.L["Select the mount to be used for:"]).."\n"..
          RD.Helper.color:Get("r2r_light", R2R.Colors, C_Map.GetMapInfo(zone.zoneID).name)..
          RD.Helper.color:Get("white", nil, format(" (mapID: %d)", zone.zoneID))
        )
        wrapperHeight = wrapperHeight + (R2R.Mounts.sections[i].subs[k].Title:GetLineHeight() * R2R.Mounts.sections[i].subs[k].Title:GetNumLines()) + gap

        local z_ebName = format("%s_%sZoneMount_%d_%d", data.prefix, data.keyword, mapID, zone.zoneID)
        local z_ebVal = ""
        if R2R.db.continents[i].zones[k].mountID ~= "" then
          z_ebVal = C_MountJournal.GetMountInfoByID(R2R.db.continents[i].zones[k].mountID)
        end

        R2R.Mounts.fields[z_ebName] = R2R.Mounts.fields[z_ebName] or READI:EditBox(data, {
          name = z_ebName,
          region = R2R.Mounts.sections[i].subs[k],
          type = "text",
          value = z_ebVal,
          parent = R2R.Mounts.sections[i].subs[k].Title,
          showButtons = true,
          onChange = function()
            local _old = R2R.db.continents[i].zones[k].mountID
            local _val = R2R.Mounts.fields[z_ebName]:GetText()
            local _new = nil
            if _val == "" then
              R2R.db.continents[i].zones[k].mountID = ""
            elseif _val ~= _old then
              C_MountJournal.SetSearch(_val)
              _new = C_MountJournal.GetDisplayedMountID(1)
              if _new and R2R.db.continents[i].useZones then
                R2R.db.continents[i].zones[k].mountID = _new
              else
                R2R.db.continents[i].zones[k].mountID = ""
              end
              C_MountJournal.SetSearch("")
            end
            R2R.SkyButton:Update()
          end,
        })
        R2R.Mounts.fields[z_ebName.."Button"] = R2R.Mounts.fields[z_ebName.."Button"] or READI:Button(data, {
          name = z_ebName.."Button",
          region = R2R.Mounts.sections[i].subs[k],
          label = R2R.L["Select"],
          height = 22,
          anchor = RD.ANCHOR_LEFT,
          parent = R2R.Mounts.fields[z_ebName],
          p_anchor = RD.ANCHOR_RIGHT,
          offsetX = 5,
          onClick = function(self)
            local field = R2R.Mounts.fields[z_ebName]
            data.frameName = field:GetText()
            R2R.MountSelector:Open(field)
          end,
        })
      
        wrapperHeight = wrapperHeight + R2R.Mounts.fields[z_ebName]:GetHeight()

        R2R.Mounts.sections[i].subs[k]:SetSize(columnWidth, wrapperHeight)
        if k % r2r.columns == 0 or k == #map.zones then
          sectionHeight = sectionHeight + wrapperHeight
        end
      end
    end

    --[[ DEFINE SECTION HEIGHT ------------------------------------------------]]--
    R2R.Mounts.sections[i]:SetHeight(sectionHeight)
    schrollChildHeight = schrollChildHeight + R2R.Mounts.sections[i]:GetHeight()
    -- print(mapName, R2R.Mounts.sections[i]:GetNumChildren())
  end

  R2R.Mounts.ScrollChild:SetHeight(schrollChildHeight)
  R2R.MountSelector:Init()
end