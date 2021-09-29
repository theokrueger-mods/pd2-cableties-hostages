_G.CTH = _G.CTH or {}
CTH.path = ModPath
CTH.savefile = SavePath .. 'cth_settings.json'
CTH.i18n = ModPath .. 'i18n/'

-- load settings
dofile(CTH.path .. 'scripts/settings.lua')
CTH:loadsettings()

-- add mod options menu
dofile(CTH.path .. 'scripts/menu.lua')