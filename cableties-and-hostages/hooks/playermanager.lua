if not _G.CTH then
        dofile(ModPath .. 'scripts/setup.lua')
end

-- clients always see you have 2 cableties
if CTH.settings.cth_numsync then
        local update_synced_cable_ties_to_peers_old = PlayerManager.update_synced_cable_ties_to_peers
        function PlayerManager:update_synced_cable_ties_to_peers()
                update_synced_cable_ties_to_peers_old(self, 8)
        end
end

-- do not consume ties on usage
if CTH.settings.cth_infiniteties then
        local remove_special_old = PlayerManager.remove_special
        function PlayerManager:remove_special(name)
                if self._equipment.specials[name] and not self._equipment.specials[name].is_cable_tie then
                        remove_special_old(self, name)
                end
        end
end
