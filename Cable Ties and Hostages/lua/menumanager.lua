Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_CTH", function(menu)
	MenuCallbackHandler.cth_save = function(self, item)
		CTH.Settings[item] = item:value() == "on"
	end
	CTH:LoadSettings()
	MenuHelper:LoadFromJsonFile(CTH.Path.."menu/options.json", CTH, CTH.Settings)
end)