--[[----------------------------------------------------------------------------
BASICS
----------------------------------------------------------------------------]]--
local AddonName, r2r = ...
local data = CopyTable(R2R.data)
data.keyword = "MountSelector"
R2R.MountSelector = R2R.MountSelector or {
  Filters = {},
  Mounts = {},
  fieldName = nil,
  selection = "",
}
local rows = 3
local perRow = 6
local pageSize = perRow * rows
local selectorTileWidth = 96
local selectorTileHeight = selectorTileWidth * 1.5
local inset = 10

local filterTextures = {
  MountSelectorFilterGrounded,
  MountSelectorFilterFlying,
  MountSelectorFilterAquatic,
  MountSelectorFilterDynamic,
}

local function BuildGrid(wrapper, field)
  local to = #wrapper.mounts
  if #wrapper.mounts > pageSize then to = pageSize end
  for i = 1, to do
    local parent = wrapper
    local p_anchor = READI.ANCHOR_TOPLEFT
    local x = 0
    local y = 0


    if i == 1 then
    elseif i > 1 and i <= perRow then
      parent = wrapper.Selectors[i - 1]
      p_anchor = READI.ANCHOR_TOPRIGHT
      x = inset
    else
      parent = wrapper.Selectors[i - perRow]
      p_anchor = READI.ANCHOR_BOTTOMLEFT
      x = 0
      y = -(inset)
    end
    
    local textures = {
      normal = MountSelectorSelectorNormal,
      highlight = MountSelectorSelectorHighlight,
      active = MountSelectorSelectorActive,
    }
    local btnName = format("%s_%s_%s_%d", data.prefix, data.keyword, wrapper:GetName().."Selector", i)
    local mount = wrapper.mounts[i]
    wrapper.Selectors[i] = wrapper.Selectors[i] or READI:RadioButton(data, {
      name = btnName,
      region = wrapper,
      width = selectorTileWidth,
      height = selectorTileHeight,
      textures = textures,
      option = field:GetName(),
      condition = field:GetText() == mount.txt or field:GetText() == mount.val,
      value = mount.val,
      tooltip = mount.txt,
      parent = parent,
      p_anchor = p_anchor,
      offsetX = x,
      offsetY = y,
      onClick = function(self)
        for i=1, #wrapper.Selectors do
          local btn = wrapper.Selectors[i]
          btn:SetChecked(false)
          btn.tex:SetTexture(textures.normal)
        end
        self:SetChecked(true)
        self.tex:SetTexture(textures.active)

        if type(self.value) == "string" then
          R2R.MountSelector.selection = self.value
        else
          R2R.MountSelector.selection = C_MountJournal.GetMountInfoByID(self.value)
        end
      end
    })
    
    wrapper.Selectors[i].Model = wrapper.Selectors[i].Model or CreateFrame("PlayerModel", btnName.."Model", wrapper.Selectors[i], "ModelTemplate")
    wrapper.Selectors[i].Model:SetFrameStrata(RD.BACKGROUND)
    wrapper.Selectors[i].Model:SetPoint(RD.ANCHOR_CENTER, wrapper.Selectors[i], RD.ANCHOR_CENTER, 0, 0)
    wrapper.Selectors[i].Model:SetSize(selectorTileWidth * 0.8, selectorTileHeight * 0.8)

    if wrapper.Selectors[i].value ~= "" then
      local creatureID = C_MountJournal.GetAllCreatureDisplayIDsForMountID(wrapper.Selectors[i].value)[1]
      wrapper.Selectors[i].Model:SetDisplayInfo(creatureID)
    else
      wrapper.Selectors[i].Model:ClearModel()
    end

  end
end

local function UpdateGrid(wrapper, field)
  local textures = {
    normal = MountSelectorSelectorNormal,
    highlight = MountSelectorSelectorHighlight,
    active = MountSelectorSelectorActive,
  }
  local to = #wrapper.mounts
  if #wrapper.mounts > pageSize then
    to = pageSize
  end

  for i=1, to do
    local mount = wrapper.mounts[i + pageSize * (wrapper.page - 1)]
    if wrapper.page == 1 then mount = wrapper.mounts[i] end

    if mount then
      wrapper.Selectors[i].value = mount.val
      wrapper.Selectors[i].tt_txt = mount.txt
      wrapper.Selectors[i]:Show()

      if wrapper.Selectors[i].value ~= "" then
        local creatureID = C_MountJournal.GetAllCreatureDisplayIDsForMountID(wrapper.Selectors[i].value)[1]
        wrapper.Selectors[i].Model:SetDisplayInfo(creatureID)
        else
        wrapper.Selectors[i].Model:ClearModel()
      end

      if field:GetText() == wrapper.Selectors[i].tt_txt or field:GetText() == wrapper.Selectors[i].value then
        wrapper.Selectors[i]:SetChecked(true)
        wrapper.Selectors[i].tex:SetTexture(textures.active)
      else
        wrapper.Selectors[i]:SetChecked(false)
        wrapper.Selectors[i].tex:SetTexture(textures.normal)
      end
    else
      wrapper.Selectors[i]:Hide()
      wrapper.Selectors[i].Model:ClearModel()
    end
  end
end

local function Paging(wrapper, delta, field)
  if delta < 0 and wrapper.page == wrapper.maxPages then return end
  if delta > 0 and wrapper.page == 1 then return end

  wrapper.page = wrapper.page + delta * -1
  if R2R.MountSelector.PagingText then
    R2R.MountSelector.PagingText:SetText(RD.Helper.color:Get("white", nil, format("%s %d %s %d", R2R.L["Page"], wrapper.page, R2R.L["of"], wrapper.maxPages)))
  end

  R2R.MountSelector.PagingBack:SetEnabled(wrapper.page > 1)
  R2R.MountSelector.PagingNext:SetEnabled(wrapper.page < wrapper.maxPages)

  UpdateGrid(wrapper, field)
end

function R2R.MountSelector:Init()
  R2R.MountSelectorDialog = R2R.MountSelectorDialog or READI:Dialog(data, {
    name = format("%s_%sDialog", data.prefix, READI.Helper.string:Capitalize(data.keyword)),
    -- createHidden = true,
    title = {
      text = READI.Helper.color:Get("white", nil, format("%1$s %2$s", READI.Helper.color:Get("r2r", R2R.Colors, AddonName), R2R.L["Mount Selector"])),
      offsetY = -4
    },
    level = 200,
    createHidden = true,
    width = (selectorTileWidth + inset) * perRow + inset * 3,
    height = (selectorTileHeight + inset) * rows + inset * 3 + 144,
    closeOnEsc = false,
    movable = true,
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
    },
    onShow = function(self)
      R2R.ConfigDialog:Hide()
    end,
    onHide = function(self)
      R2R.ConfigDialog:Show()
    end
  })
  for i, list in ipairs(R2R.mountLists) do
    R2R.MountSelector.Mounts[i] = math.ceil(#R2R.mountLists[i].mounts / pageSize)
  end
end

function R2R.MountSelector:Open(field)
  R2R.MountSelector.fieldName = field:GetName()
  local _mountID = nil
  local _val = field:GetText()

  if _val and _val ~= "" then
    C_MountJournal.SetSearch(_val)
    _mountID = C_MountJournal.GetDisplayedMountID(1)
    C_MountJournal.SetSearch("")
  end

  local _filterButtonSize = 28
  local _filterAnchor = READI.ANCHOR_TOP
  local _filterParent = R2R.MountSelectorDialog
  local _filterParentAnchor = READI.ANCHOR_TOP
  local _filterOffsetX = _filterButtonSize * -(#R2R.MountSelector.Mounts / 2)
  local _filterOffsetY = _filterButtonSize * -1

  R2R.MountSelector.PagingText = R2R.MountSelector.PagingText or R2R.MountSelectorDialog:CreateFontString(RD.ARTWORK, nil, "GameFontNormal")
  R2R.MountSelector.PagingText:ClearAllPoints()
  R2R.MountSelector.PagingText:SetPoint(RD.ANCHOR_BOTTOM, R2R.MountSelectorDialog, RD.ANCHOR_BOTTOM, 0, 72)

  R2R.MountSelector.PagingBack = R2R.MountSelector.PagingBack or CreateFrame("Button", format("%s_%s%s", data.prefix, data.keyword, "PagingBackButton"), R2R.MountSelectorDialog)
  R2R.MountSelector.PagingBack:SetSize(20,20)
  R2R.MountSelector.PagingBack:SetPoint(RD.ANCHOR_RIGHT, R2R.MountSelector.PagingText, RD.ANCHOR_LEFT, -(inset), 0)

  R2R.MountSelector.PagingBack:SetNormalTexture(RD.T.rdl140001)
  R2R.MountSelector.PagingBack:SetHighlightTexture(RD.T.rdl140005)
  R2R.MountSelector.PagingBack:SetPushedTexture(RD.T.rdl140005)
  R2R.MountSelector.PagingBack:SetDisabledTexture(RD.T.rdl140003)
  local normalBackTex = R2R.MountSelector.PagingBack:GetNormalTexture()
  normalBackTex:SetAllPoints()
  local highlightBackTex = R2R.MountSelector.PagingBack:GetHighlightTexture()
  highlightBackTex:SetAllPoints()
  local pushedBackTex = R2R.MountSelector.PagingBack:GetPushedTexture()
  pushedBackTex:SetAllPoints()
  local disabledBackTex = R2R.MountSelector.PagingBack:GetDisabledTexture()
  disabledBackTex:SetAllPoints()

  R2R.MountSelector.PagingNext = R2R.MountSelector.PagingNext or CreateFrame("Button", format("%s_%s%s", data.prefix, data.keyword, "PagingNextButton"), R2R.MountSelectorDialog)
  R2R.MountSelector.PagingNext:SetSize(20,20)
  R2R.MountSelector.PagingNext:SetPoint(RD.ANCHOR_LEFT, R2R.MountSelector.PagingText, RD.ANCHOR_RIGHT, inset, 0)

  R2R.MountSelector.PagingNext:SetNormalTexture(RD.T.rdl140002)
  R2R.MountSelector.PagingNext:SetHighlightTexture(RD.T.rdl140006)
  R2R.MountSelector.PagingNext:SetPushedTexture(RD.T.rdl140006)
  R2R.MountSelector.PagingNext:SetDisabledTexture(RD.T.rdl140004)
  local normalNextTex = R2R.MountSelector.PagingNext:GetNormalTexture()
  normalNextTex:SetAllPoints()
  local highlightNextTex = R2R.MountSelector.PagingNext:GetHighlightTexture()
  highlightNextTex:SetAllPoints()
  local pushedNextTex = R2R.MountSelector.PagingNext:GetPushedTexture()
  pushedNextTex:SetAllPoints()
  local disabledNextTex = R2R.MountSelector.PagingNext:GetDisabledTexture()
  disabledNextTex:SetAllPoints()

  R2R.MountSelector.PagingBack:SetScript("OnClick", function()
    local wrapper = READI.Helper.table:Filter(R2R.MountSelector.Filters, function(v) return v.Wrapper:IsShown() end)[1].Wrapper
    Paging(wrapper, 1, field)
  end)
  R2R.MountSelector.PagingNext:SetScript("OnClick", function()
    local wrapper = READI.Helper.table:Filter(R2R.MountSelector.Filters, function(v) return v.Wrapper:IsShown() end)[1].Wrapper
    Paging(wrapper, -1, field)
  end)
  
  for i, filter in ipairs(R2R.MountSelector.Mounts) do
    local function OnEnter(self)
      if not self.tooltip then return end
      self.tooltip:SetOwner(self, "ANCHOR_LEFT")
      self.tooltip:ClearLines()
      self.tooltip:AddLine(self.tt_txt, 1, 1, 1, true)
      self.tooltip:Show()
    end

    local function OnLeave(self)
      if not self.tooltip then return end
      self.tooltip:Hide()
    end

    local filterButtonName = format("%s_%sFilter_%s", data.prefix, data.keyword, R2R.mountLists[i].title)
    R2R.MountSelector.Filters[i] = R2R.MountSelector.Filters[i] or CreateFrame("Button", filterButtonName, R2R.MountSelectorDialog, "SecureActionButtonTemplate")
    R2R.MountSelector.Filters[i]:SetHighlightTexture(READI.T.rdl110004, "ADD")
    R2R.MountSelector.Filters[i].tt_txt = R2R.mountLists[i].title
    if i > 1 then
      _filterAnchor = READI.ANCHOR_TOPLEFT
      _filterParent = R2R.MountSelector.Filters[i - 1]
      _filterParentAnchor = READI.ANCHOR_TOPRIGHT
      _filterOffsetX = _filterButtonSize / 2
      _filterOffsetY = 0
    end
    R2R.MountSelector.Filters[i]:SetPoint(_filterAnchor, _filterParent, _filterParentAnchor, _filterOffsetX, _filterOffsetY)
    R2R.MountSelector.Filters[i]:SetSize(28,28)

    R2R.MountSelector.Filters[i].tooltip = R2R.MountSelector.Filters[i].tooltip or CreateFrame("GameTooltip", filterButtonName.."Tooltip", UIParent, "GameTooltipTemplate")

    R2R.MountSelector.Filters[i].icon = R2R.MountSelector.Filters[i].icon or R2R.MountSelector.Filters[i]:CreateTexture(AddonName .. "Icon", "ARTWORK")
    R2R.MountSelector.Filters[i].icon:SetTexture(filterTextures[i])
    R2R.MountSelector.Filters[i].icon:SetAllPoints()

    R2R.MountSelector.Filters[i]:SetScript("OnEnter", OnEnter)
    R2R.MountSelector.Filters[i]:SetScript("OnLeave", OnLeave)

    --[[ -----------------------------------------------------------------------
    build up the page frames
    ------------------------------------------------------------------------]]--
    local pagesWrapperName = filterButtonName.."PagesWrapper"
    R2R.MountSelector.Filters[i].Wrapper = R2R.MountSelector.Filters[i].Wrapper or CreateFrame("Frame", pagesWrapperName, R2R.MountSelectorDialog) -- investigate more on "CollectionsPagingFrameTemplate"
    R2R.MountSelector.Filters[i].Wrapper:ClearAllPoints()
    R2R.MountSelector.Filters[i].Wrapper:SetPoint(RD.ANCHOR_TOPLEFT, R2R.MountSelectorDialog, RD.ANCHOR_TOPLEFT, inset, -72)
    R2R.MountSelector.Filters[i].Wrapper:SetPoint(RD.ANCHOR_BOTTOMRIGHT, R2R.MountSelectorDialog, RD.ANCHOR_BOTTOMRIGHT, -(inset), 72)
    R2R.MountSelector.Filters[i].Wrapper:SetClipsChildren(true)
    R2R.MountSelector.Filters[i].Wrapper:Hide()
    R2R.MountSelector.Filters[i].Wrapper.mounts = R2R.mountLists[i].mounts
    R2R.MountSelector.Filters[i].Wrapper.Selectors = R2R.MountSelector.Filters[i].Wrapper.Selectors or {}

    R2R.MountSelector.Filters[i].Wrapper:SetScript("OnMouseWheel", function(self, delta) Paging(self, delta, field) end)
    --[[ -------------------------------------------------------------------]]--

    R2R.MountSelector.Filters[i]:RegisterForClicks("LeftButtonDown")
    R2R.MountSelector.Filters[i]:SetAttribute("type", "filter")
    R2R.MountSelector.Filters[i]:SetAttribute("_filter", function()
      for x=1, #R2R.MountSelector.Filters do
        R2R.MountSelector.Filters[x]:SetHighlightLocked(false)
        R2R.MountSelector.Filters[x].Wrapper:Hide()
      end
      R2R.MountSelector.Filters[i]:SetHighlightLocked(true)
      R2R.MountSelector.Filters[i].Wrapper:Show()
      R2R.MountSelector.Filters[i].Wrapper.page = 1
      R2R.MountSelector.Filters[i].Wrapper.maxPages = R2R.MountSelector.Mounts[i]
      if R2R.MountSelector.PagingText then
        R2R.MountSelector.PagingText:SetText(RD.Helper.color:Get("white", nil, format("%s %d %s %d", R2R.L["Page"], R2R.MountSelector.Filters[i].Wrapper.page, R2R.L["of"], R2R.MountSelector.Filters[i].Wrapper.maxPages)))
      end

      if R2R.MountSelector.PagingBack then
        R2R.MountSelector.PagingBack:SetEnabled(R2R.MountSelector.Filters[i].Wrapper.page > 1)
      end
      if R2R.MountSelector.PagingNext then
        R2R.MountSelector.PagingNext:SetEnabled(R2R.MountSelector.Filters[i].Wrapper.page < R2R.MountSelector.Filters[i].Wrapper.maxPages)
      end


      if #R2R.MountSelector.Filters[i].Wrapper.Selectors == 0 then
        BuildGrid(R2R.MountSelector.Filters[i].Wrapper, field)
      else
        UpdateGrid(R2R.MountSelector.Filters[i].Wrapper, field)
      end
    end)

    if i == 1 then R2R.MountSelector.Filters[i]:Click("LeftButton", 1) end
  end

  R2R.MountSelectorDialog:Show()
end

-- function R2R.MountSelector:InitField(field)
--   print(field)
-- end
function R2R.MountSelector:SelectMount()
  local field = R2R.Mounts.fields[R2R.MountSelector.fieldName]
  field:SetText(R2R.MountSelector.selection)
  EventRegistry:TriggerEvent(format("%s.%s", R2R.MountSelector.fieldName, "OnChange"))
end
function R2R.MountSelector:Close()
  print("MountSelector closed without selection")
end
function R2R.MountSelector:Cancel()
  print("Selection Cancelled")
end