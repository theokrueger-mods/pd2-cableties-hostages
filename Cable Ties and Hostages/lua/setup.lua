_G.CTH = _G.CTH or {}

-- functions
function CTH:save()
	local options = io.open(SavePath.."cth_settings.json", "w+")
	if options then
		options:write(json.encode(CTH.Settings))
		options:close()
	end
end

function CTH:load()
	local options = io.open(SavePath.."cth_settings.json", "r")
	if options then
		local tabledata = json.decode(options:read("*all"))
		for key, val in pairs(tabledata) do
			self.Settings[key] = val
		end
		options:close()
	end
end

-- globals
CTH.Path = ModPath

_G.CTH.Settings = _G.CTH.Settings or {
    -- default settings
    ["cth_add_ties"] = true,
    ["cth_increase_hostages"] = true,
    ["cth_hostage_speed"] = 1.3,
    ["cth_disable_trades"] = false,
    ["cth_announce"] = true
}

-- setup script

-- save defaults if settings cannot be loaded
if not io.open(SavePath.."CTH_Settings.json", "r") then CTH:save() end



-- Announces in chat you are using this mod
if not Global.game_settings then
	return
end

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
