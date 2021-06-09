-- add loc
Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_CTH", function(loc)
	for _, filename in pairs(file.GetFiles(CTH.Path .. "loc/")) do
		local str = filename:match('^(.*).json$')
		if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
			loc:load_localization_file(CTH.Path .. "loc/" .. filename)
			break
		end
	end
	loc:load_localization_file(CTH.Path .. "loc/english.json", false)
end)