_G.CTH = _G.CTH or {}

-- add menu loc
Hooks:Add(
        'LocalizationManagerPostInit',
        'CTH_LocalizationManagerPostInit',
        function(loc)
                for _, filename in pairs(file.GetFiles(CTH.i18n)) do
                        local str = filename:match('^(.*).json$')
                        if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
                                loc:load_localization_file(CTH.i18n .. filename)
                                break
                        end
                end
                -- load fallback lang
                loc:load_localization_file(CTH.i18n .. 'english.json', false)
        end
)

-- menu callbacks
Hooks:Add(
        'MenuManagerInitialize',
        'CTH_MenuManagerInitialize',
        function(menu)
                MenuCallbackHandler.cth_upd = function(self, item)
                        if item._type == 'toggle' then
                                CTH.settings[item._parameters.name] = item:value() == 'on'
                        elseif item._type == 'slider' then
                                CTH.settings[item._parameters.name] = math.floor(tonumber(item:value()) + 0.5)
                        end
                        CTH:savesettings()
                end
                MenuHelper:LoadFromJsonFile(CTH.path .. 'menus/mainmenu.json', CTH, CTH.settings)
        end
)
