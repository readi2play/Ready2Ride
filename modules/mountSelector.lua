--[[----------------------------------------------------------------------------
BASICS
----------------------------------------------------------------------------]]--
local AddonName, r2r = ...
local data = CopyTable(R2R.data)
data.keyword = "MountSelector"

-- function MountSelector:Init(field)
--   print(field)
-- end
-- function MountSelector:Open(field)
--   MSelDialog = MSelDialog or CreateMSelDialog()

--   MountSelector:Init(field)
-- end
-- function MountSelector:SelectMount() end
-- function MountSelector:FilterMountList(filter) end
-- function MountSelector:Close() end
-- function MountSelector:Cancel() end