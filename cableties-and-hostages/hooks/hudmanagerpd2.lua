if not _G.CTH then
        dofile(ModPath .. 'setup.lua')
end

-- remove display of cableties from HUD, since you have infinite anyways.
if CTH.settings.cth_hidehud then
        function HUDManager:set_cable_ties_amount(i, amount)
                if i == HUDManager.PLAYER_PANEL then
                        amount = 0
                end
                self._teammate_panels[i]:set_cable_ties_amount(amount)
        end

        function HUDManager:set_cable_tie(i, data)
                if i == HUDManager.PLAYER_PANEL then
                        data.amount = 0
                end
                self._teammate_panels[i]:set_cable_tie(data)
        end
end
