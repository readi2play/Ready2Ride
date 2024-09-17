--[[----------------------------------------------------------------------------
BASICS
----------------------------------------------------------------------------]]--
local AddonName, r2r = ...
local configKeys = {"info", "mounts", "specials", "anchoring", "profiles"}
local data = CopyTable(R2R.data)
data.keyword = "config"
R2R.config = {}


r2r.windowWidth = SettingsPanel.Container:GetWidth()
r2r.columns = 2
r2r.columnWidth = r2r.windowWidth / r2r.columns - 20
--[[----------------------------------------------------------------------------
-- OPTIONS PANEL CREATION
----------------------------------------------------------------------------]]--
function R2R:SetupConfig()
  for i,key in ipairs(configKeys) do
    local FillPanelFunctionName = format("Fill%sPanel", READI.Helper.string:Capitalize(key))
    local panelExists = READI.Helper.functions:Exists("R2R."..FillPanelFunctionName)

    if panelExists then
      R2R.config[key] = R2R.config[key] or {}
      local panelName = R2R.L[READI.Helper.string:Capitalize(key)]
      local parentPanel = nil
      local titleText = R2R.L[READI.Helper.string:Capitalize(key)]

      if key == "info" then
        panelName = AddonName
        titleText = AddonName
      else
        parentPanel = AddonName
      end
  
      --------------------------------------------------------------------------------
      R2R.config[key].panel, R2R.config[key].container, R2R.config[key].anchorline = READI:OptionPanel(data, {
        name = panelName,
        parent = parentPanel,
        title = {
          text = titleText,
          color = "r2r"
        }
      })
      --------------------------------------------------------------------------------
  
      if Settings and Settings.RegisterCanvasLayoutCategory then
        if parentPanel then
          local category = Settings.GetCategory(parentPanel)
          local subcategory = Settings.RegisterCanvasLayoutSubcategory(category, R2R.config[key].panel, panelName)
        else
          local category = Settings.RegisterCanvasLayoutCategory(R2R.config[key].panel, AddonName)
          category.ID = AddonName
          Settings.RegisterAddOnCategory(category)
        end
  
      else
        InterfaceOptions_AddCategory(R2R.config[key].panel)
      end
    end
  end
end
--[[----------------------------------------------------------------------------
-- OPTIONS PANEL INITIALIZATION
----------------------------------------------------------------------------]]--
function R2R:InitializeOptions()
  for i,key in ipairs(configKeys) do
    local FillPanelFunctionName = format("Fill%sPanel", READI.Helper.string:Capitalize(key))
    local panelExists = READI.Helper.functions:Exists("R2R."..FillPanelFunctionName)
    if panelExists then
      R2R[FillPanelFunctionName](self, R2R.config[key].panel, R2R.config[key].container, R2R.config[key].anchorline)
    end
  end
end
function R2R:UpdateOptions(shuffle)
  if shuffle == nil then
    shuffle = true
  end
  R2R.Anchoring:Update()
  -- R2R.Bindings:Update()

  R2R.SkyButton:ScaleButton()
  R2R.SkyButton:SetPosition()
  R2R.SkyButton:SetStrata()

  R2R.SkyButton:Update()
end