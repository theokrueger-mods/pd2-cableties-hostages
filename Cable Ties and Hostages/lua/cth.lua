_G.CTH = _G.CTH or {}
_G.CTH.Settings = _G.CTH.settings or {}
CTH.Path = ModPath
local Net = _G.LuaNetworking

-- Load settings
function CTH:LoadSettings()
	local options = io.open(SavePath.."CTH_Settings.json", "r")
	if options then
		local tabledata = json.decode(options:read("*all"))
		for key, val in pairs(tabledata) do
			self.Settings[key] = val
		end
		options:close()
	end
end

-- Saves loaded settings to variables or sets defaults
CTH.Settings.CTHCTEnabled = CTH.Settings["CTHCTEnabled"] or true -- more ties
CTH.Settings.CTHHEnabled = CTH.Settings["CTHHEnabled"] or true -- more hostage followers
CTH.Settings.CTHHSSlider = CTH.Settings["CTHHSSlider"] or 1.3 -- hostage speed
CTH.Settings.CTHAEnabled = CTH.Settings["CTHAEnabled"] or true -- announce in chat mod is active

-- Save Settings
function CTH:SaveSettings()
	local options = io.open(SavePath.."CTH_Settings.json", "w+")
	if options then
		options:write(json.encode(CTH.Settings))
		options:close()
	end
end

-- Saves defaults if cannot be loaded
if not io.open(SavePath.."CTH_Settings.json", "r") then CTH:SaveSettings() end

-- Adds localization
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

Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_CTH", function(menu)

	MenuCallbackHandler.cth_ct_save = function(self, item)
		CTH.Settings.CTHCTEnabled = item:value() == "on"
	end
	MenuCallbackHandler.cth_h_save = function(self, item)
		CTH.Settings.CTHHEnabled = item:value() == "on"
	end
	MenuCallbackHandler.cth_hs_save = function(self, item)
		CTH.Settings.CTHHSSlider = tonumber(item:value())
	end
	MenuCallbackHandler.cth_a_save = function(self, item)
		CTH.Settings.CTHAEnabled = item:value() == "on"
	end
	
	MenuCallbackHandler.cth_savedata = function(_)
		CTH:SaveSettings()
	end

	CTH:LoadSettings()
	MenuHelper:LoadFromJsonFile(CTH.Path.."menu/options.json", CTH, CTH.Settings)
end)

-- Sets hostage following speed
if string.lower(RequiredScript) == "lib/tweak_data/charactertweakdata" then
	local set_charactertweakdata_original = CharacterTweakData._presets
	function CharacterTweakData:_presets(tweak_data, ...)
	local presets = set_charactertweakdata_original(self, tweak_data, ...)
		presets.move_speed.civ_fast.stand.walk.cbt = {
			fwd = 210 * CTH.Settings.CTHHSSlider,
			strafe = 175 * CTH.Settings.CTHHSSlider,
			bwd = 160 * CTH.Settings.CTHHSSlider
		}
		return presets
	end
end

-- Increases Max Cable Ties
if string.lower(RequiredScript) == "lib/tweak_data/equipmentstweakdata" then
	local old_init = EquipmentsTweakData.init
	function EquipmentsTweakData:init(...)
		old_init(self, ...)
		if CTH.Settings.CTHCTEnabled and Net:IsHost() then
			self.specials.cable_tie.max_quantity = 60 -- max ties = 60
		else
			self.specials.cable_tie.max_quantity = 8 -- max ties = 8 (emulating FF basic)
		end
	end
end

-- Increase Max Following Hostages
if string.lower(RequiredScript) == "lib/tweak_data/playertweakdata" then
	local old_ptd0001_init = PlayerTweakData.init
	function PlayerTweakData:init(tweak_data)
		old_ptd0001_init(self, tweak_data)
		if CTH.Settings.CTHHEnabled and Net:IsHost() then
			self.max_nr_following_hostages = 3
		else
			self.max_nr_following_hostages = 1 -- This allows the "max following hostages" popup to appear
		end
	end
end

-- Increase Starting Cable Ties
if string.lower(RequiredScript) == "lib/tweak_data/upgradestweakdata" then
	local old_init_pd2_values = UpgradesTweakData._init_pd2_values
	function UpgradesTweakData:_init_pd2_values(...)
		old_init_pd2_values(self, ...)
		if CTH.Settings.CTHCTEnabled and Net:IsHost() then
			self.values.cable_tie.quantity_1 = {50} -- add 50 starting ties (52 total)
			self.values.cable_tie.quantity_2 = {50}
		else
			self.values.cable_tie.quantity_1 = {4} -- add 4 starting ties (emulating FF basic)
			self.values.cable_tie.quantity_2 = {4}
		end
	end
end

if not Global.game_settings then
	return
end

-- Announces in chat you are using this mod
Hooks:Add("NetworkManagerOnPeerAdded", "NetworkManagerOnPeerAdded_CTH", function(peer, peer_id)
	if Network:is_server() and (tonumber(CTH.Settings.CTHHSSlider) ~= 1.0 or CTH.Settings.CTHHEnabled or CTH.Settings.CTHCTEnabled) and (CTH.Settings.CTHAEnabled or Global.game_settings.permission == "public") then
		DelayedCalls:Add("DelayedWarnModCTH" .. tostring(peer_id), 2, function()
			local message = "Heads up, I'm running Cable Ties and Hostages Mod (CTH), which gives me surplus cable ties and 3 maximum following hostages."
			local peer2 = managers.network:session() and managers.network:session():peer(peer_id)
			if peer2 then
				peer2:send("send_chat_message", ChatManager.GAME, message)
			end
		end)
	end
end)
