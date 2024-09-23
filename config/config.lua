--[[----------------------------------------------------------------------------
BASICS
----------------------------------------------------------------------------]]--
local AddonName, r2r = ...
local configKeys = {"info", "mounts", "specials", "anchoring", "profiles"}
local data = CopyTable(R2R.data)
data.keyword = "config"

R2R.config = {}
R2R.settings = {}

r2r.windowWidth = SettingsPanel.Container:GetWidth()
r2r.columns = 2
r2r.columnWidth = r2r.windowWidth / r2r.columns - 20

--[[----------------------------------------------------------------------------
-- CONFIG DIALOG CREATION
----------------------------------------------------------------------------]]--
function CreateConfigDialog()
  local width, height = GetPhysicalScreenSize()
  local settings = {
    name = format("%s_%sDialog", data.prefix, READI.Helper.string:Capitalize(data.keyword)),
    -- createHidden = true,
    title = {
      text = READI.Helper.color:Get("white", nil, format("%1$s %2$s", READI.Helper.color:Get("r2r", R2R.Colors, AddonName), R2R.L["Configuration"])),
      offsetY = -4
    },
    width = math.floor(GetScreenWidth()),
    height = math.floor(GetScreenHeight()),
    closeOnEsc = true,
    icon = {
      texture = R2R.icon,
      height = 64,
      width = 64,
    },
    texture = {
      path = READI.UIPanelNineTile,
      width = 216,
      height = 216,
      per_row = 3,
      rows = 3  
    },
    allowKeyboard = false,
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
      offsetY = 4
    },
    buttonSet = {
      {
        key = "close",
        label = R2R.L["Close"],
        offsetX = -20,
        offsetY = 30,
        parent = {
          anchor = READI.ANCHOR_BOTTOMRIGHT,
        }
      },
      -- {
      --   key = "cancel",
      --   label = R2R.L["Cancel"],
      --   offsetX = -20,
      --   offsetY = 30,
      --   parent = {
      --     anchor = READI.ANCHOR_BOTTOMRIGHT,
      --   }
      -- },
      -- {
      --   key = "confirm",
      --   label = R2R.L["Okay"],
      --   parent = {
      --     anchor = READI.ANCHOR_BOTTOMLEFT,
      --   },
      -- }
    }
  }

  local dialog = READI:Dialog(data, settings)

  local libLogo = READI:Icon(data, {
    texture = RD.icon,
    name = format("%s Logo", "readiLIB"),
    region = dialog,
    width = 14,
    height = 14,
  })

  local libText = dialog:CreateFontString("ARTWORK", nil, "GameFontNormalSmall")
  libText:SetPoint(READI.ANCHOR_BOTTOMRIGHT, dialog, READI.ANCHOR_BOTTOMRIGHT, -72,5)
  libText:SetText(READI.Helper.color:Get("white", nil, format("%s v%s", READI.title, READI.version)))

  libLogo:SetPoint(READI.ANCHOR_RIGHT, libText, READI.ANCHOR_LEFT, -5, 0)

  local powered_by = dialog:CreateFontString("ARTWORK", nil, "GameFontNormalSmall")
  powered_by:SetPoint(READI.ANCHOR_RIGHT, libLogo, READI.ANCHOR_LEFT, -5,0)
  powered_by:SetText(READI.Helper.color:Get("white", nil, R2R.L["powered by:"]))

  return dialog
end
--[[----------------------------------------------------------------------------
-- OPTIONS PANEL CREATION
----------------------------------------------------------------------------]]--
function R2R:SetupConfig()
  R2R.ConfigDialog = R2R.ConfigDialog or CreateConfigDialog()

  function R2R.ConfigDialog:Clear()
    for i, key in ipairs(configKeys) do
      if key ~= "info" then
        if R2R.config[configKeys[i]] and R2R.config[configKeys[i]].container then
          R2R.config[configKeys[i]].container:Hide()
        end
      end
    end
  end

  local infoWidth = 450

  for i,key in ipairs(configKeys) do
    local FillPanelFunctionName = format("Fill%sPanel", READI.Helper.string:Capitalize(key))
    local panelExists = READI.Helper.functions:Exists("R2R."..FillPanelFunctionName)

    if panelExists then
      R2R.config[key] = R2R.config[key] or {}
      R2R.settings[key] = R2R.settings[key] or {}
      local panelName = R2R.L[READI.Helper.string:Capitalize(key)]
      local parentPanel = nil
      local c_titleText = R2R.L[READI.Helper.string:Capitalize(key)]
      local s_titleText = R2R.L[READI.Helper.string:Capitalize(key)]
      local l_offsetX, l_offsetY, r_offsetX, r_offsetYich, panelHidden, c_width

      if key == "info" then
        panelName = AddonName
        c_titleText = nil
        s_titleText = AddonName
        l_offsetX = 10
        l_offsetY = -72
        c_width = infoWidth        
      else
        parentPanel = AddonName
        l_offsetX = infoWidth + 20
        l_offsetY = -100
        r_offsetX = -10
        r_offsetY = 72
        c_width = nil
        panelHidden = true
      end

      --[[------------------------------------------------------------------------]]--
      local tb_region = R2R.ConfigDialog
      local tb_pAnchor = READI.ANCHOR_TOPLEFT
      local tb_offsetX = infoWidth + 20
      local tb_offsetY = -72

      if R2R.config[configKeys[i-1]] and R2R.config[configKeys[i-1]].tabButton then
        tb_region = R2R.config[configKeys[i-1]].tabButton
        tb_pAnchor = READI.ANCHOR_TOPRIGHT
        tb_offsetX = 10
        tb_offsetY = 0
        else
      end
      local tabBtnSettings = {
        name = data.prefix .. RD.Helper.string:Capitalize(key).."TabButton",
        region = tb_region,
        label = s_titleText,
        onClick = function()
          for i=2, #configKeys do
            if R2R.config[configKeys[i]] and R2R.config[configKeys[i]].container then
              R2R.config[configKeys[i]].container:Hide()
            end
          end
          R2R.config[key].container:Show()
        end,
        anchor = READI.ANCHOR_TOPLEFT,
        parent = tb_region,
        p_anchor = tb_pAnchor,
        offsetX = tb_offsetX,
        offsetY = tb_offsetY,
      }
      if key ~= "info" then
        R2R.config[key].tabButton = R2R.config[key].tabButton or RD:Button(data, tabBtnSettings)
      end
      --[[------------------------------------------------------------------------]]--
      R2R.config[key].container, R2R.config[key].anchorline = READI:OptionsContainer(data, {
        name = panelName,
        parent = R2R.ConfigDialog,
        width = c_width,
        hidden = panelHidden,
        background = "0.03,0.02,0,0.5",
        border = "0.7,0.68,0.69,0.5",
        left = {
          offsetX = l_offsetX,
          offsetY = l_offsetY,
        },
        right = {
          offsetX = r_offsetX,
          offsetY = r_offsetY,
        },
        title = {
          text = c_titleText,
          color = "r2r",
        },
      })

      R2R.settings[key].panel, R2R.settings[key].container, R2R.settings[key].anchorline = READI:OptionPanel(data, {
        name = panelName,
        parent = parentPanel,
        title = {
          text = s_titleText,
          color = "r2r",
        },
      })

      --[[------------------------------------------------------------------------]]--
      if Settings and Settings.RegisterCanvasLayoutCategory then
        if parentPanel then
          local category = Settings.GetCategory(parentPanel)
          local subcategory = Settings.RegisterCanvasLayoutSubcategory(category, R2R.settings[key].panel, panelName)
        else
          local category = Settings.RegisterCanvasLayoutCategory(R2R.settings[key].panel, AddonName)
          category.ID = AddonName
          Settings.RegisterAddOnCategory(category)
        end
      else
        InterfaceOptions_AddCategory(R2R.settings[key].panel)
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
      R2R[FillPanelFunctionName](self, R2R.settings[key].panel, R2R.settings[key].container, R2R.settings[key].anchorline)
      R2R[FillPanelFunctionName](self, R2R.ConfigDialog, R2R.config[key].container, R2R.config[key].anchorline)
    end
  end
end
function R2R:UpdateOptions(shuffle)
  if shuffle == nil then
    shuffle = true
  end
  R2R.Anchoring:Update()

  R2R.SkyButton:ScaleButton()
  R2R.SkyButton:SetPosition()
  R2R.SkyButton:SetStrata()

  R2R.SkyButton:Update()
end