--[[----------------------------------------------------------------------------
BASICS
----------------------------------------------------------------------------]]--
local AddonName, r2r = ...
local data = CopyTable(R2R.data)
data.keyword = "MountSelector"
R2R.MountSelector = R2R.MountSelector or {
  Filters = {}
}
local filterTextures = {
  MountSelectorFilterGrounded,
  MountSelectorFilterFlying,
  MountSelectorFilterAquatic,
  MountSelectorFilterDynamic,
}

function R2R.MountSelector:Open(field)
  -- R2R.ConfigDialog:SetAlpha(0)
  R2R.MountSelectorDialog = R2R.MountSelectorDialog or READI:Dialog(data, {
    name = format("%s_%sDialog", data.prefix, READI.Helper.string:Capitalize(data.keyword)),
    -- createHidden = true,
    title = {
      text = READI.Helper.color:Get("white", nil, format("%1$s %2$s", READI.Helper.color:Get("r2r", R2R.Colors, AddonName), R2R.L["Mount Selector"])),
      offsetY = -4
    },
    level = 200,
    width = R2R.Mounts.ScrollFrame:GetWidth(),
    height = R2R.Mounts.ScrollFrame:GetHeight(),
    closeOnEsc = false,
    texture = {
      path = READI.UIPanelNineTile,
      width = 216,
      height = 216,
      per_row = 3,
      rows = 3  
    },
    allowKeyboard = true,
    closeXButton = {
      -- hidden = true,
      tex = {
        highlight = READI.T.rdl130002,
        pushed = READI.T.rdl130003,
        normal = READI.T.rdl130001,
      },
      width = 24,
      height = 24,
      offsetX = 4,
      offsetY = 4,
      onClick = R2R.MountSelector.Close
    },
    buttonSet = {
      {
        key = "cancel",
        label = R2R.L["Cancel"],
        offsetX = -20,
        offsetY = 30,
        parent = {
          anchor = READI.ANCHOR_BOTTOMRIGHT,
        },
        onClick = R2R.MountSelector.Cancel
      },
      {
        key = "confirm",
        label = R2R.L["Submit"],
        parent = {
          anchor = READI.ANCHOR_BOTTOMLEFT,
        },
        onClick = R2R.MountSelector.SelectMount
      },
    }
  })
  local _mountID = nil
  local _val = field:GetText()
  if _val and _val ~= "" then
    C_MountJournal.SetSearch(_val)
    _mountID = C_MountJournal.GetDisplayedMountID(1)
    C_MountJournal.SetSearch("")
    print(format("%s (%d)", _val, _mountID))
  end

  local _filterAnchor = READI.ANCHOR_TOPLEFT
  local _filterParent = R2R.MountSelectorDialog
  local _filterParentAnchor = READI.ANCHOR_TOPLEFT
  local _filterOffsetX = 216
  local _filterOffsetY = -28
  for i, filter in ipairs(READI.MOUNT_TYPES) do

    if i > 1 then
      _filterAnchor = READI.ANCHOR_TOPLEFT
      _filterParent = R2R.MountSelector.Filters[i - 1]
      _filterParentAnchor = READI.ANCHOR_TOPRIGHT
      _filterOffsetX = 21
      _filterOffsetY = 0
    end

    local filterButtonName = format("%s_%sFilter_%d", data.prefix, data.keyword, i)
    R2R.MountSelector.Filters[i] = R2R.MountSelector.Filters[i] or CreateFrame("Button", filterButtonName, R2R.MountSelectorDialog, "SecureActionButtonTemplate")
    R2R.MountSelector.Filters[i]:SetHighlightTexture(READI.T.rdl110004, "ADD")
    R2R.MountSelector.Filters[i]:SetPoint(_filterAnchor, _filterParent, _filterParentAnchor, _filterOffsetX, _filterOffsetY)
    R2R.MountSelector.Filters[i]:SetSize(28,28)

    R2R.MountSelector.Filters[i].tooltip = R2R.MountSelector.Filters[i].tooltip or CreateFrame("GameTooltip", filterButtonName.."Tooltip", UIParent, "GameTooltipTemplate")
    R2R.MountSelector.Filters[i].icon = R2R.MountSelector.Filters[i].icon or R2R.MountSelector.Filters[i]:CreateTexture(AddonName .. "Icon", "ARTWORK")
    R2R.MountSelector.Filters[i].icon:SetTexture(filterTextures[i])
    R2R.MountSelector.Filters[i].icon:SetAllPoints()
    
    R2R.MountSelector.Filters[i]:RegisterForClicks("LeftButtonDown")
    R2R.MountSelector.Filters[i]:SetAttribute("type", "filter")
    R2R.MountSelector.Filters[i]:SetAttribute("_filter", function()
      print("Yeah")
    end)
  
  
  end

  R2R.MountSelectorDialog:Show()
  -- R2R.MountSelector:Init(field)
end

-- function R2R.MountSelector:Init(field)
--   print(field)
-- end
function R2R.MountSelector:SelectMount()
  print("Mount Selected")
  -- R2R.ConfigDialog:SetAlpha(1)
end
-- function R2R.MountSelector:FilterMountList(filter) end
function R2R.MountSelector:Close()
  print("MountSelector closed without selection")
  -- R2R.ConfigDialog:SetAlpha(1)
end
function R2R.MountSelector:Cancel()
  print("Selection Cancelled")
end