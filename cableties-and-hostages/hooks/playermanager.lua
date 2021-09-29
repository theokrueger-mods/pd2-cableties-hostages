if not _G.CTH then
	dofile(ModPath .. 'scripts/setup.lua')
end

-- clients always see you have 2 cableties
if CTH.settings.cth_hidehud then
	local update_synced_cable_ties_to_peers_old = PlayerManager.update_synced_cable_ties_to_peers
	function PlayerManager:update_synced_cable_ties_to_peers()
		update_synced_cable_ties_to_peers_old(self, 2)
	end
end

-- always have infinite cabletie upgrade. this is more efficient than overriding the function where it uses cableties since that function is bloated and supergeneral.
if CTH.settings.cth_infiniteties then
	local has_category_upgrade_old = PlayerManager.has_category_upgrade
	function PlayerManager:has_category_upgrade(category, upgrade)
		return has_category_upgrade_old(self, category, upgrade) or
			(category == 'cable_tie' and upgrade == 'quantity_unlimited')
	end
end
