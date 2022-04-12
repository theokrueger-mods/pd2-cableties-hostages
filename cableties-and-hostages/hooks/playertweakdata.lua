if not _G.CTH then
        dofile(ModPath .. 'scripts/setup.lua')
end

-- set maximum following hostages to n (based on settings)
Hooks:PostHook(
        PlayerTweakData,
        'init',
        'CTH_PTD_init',
        function(self, tweak_data)
                if _G.LuaNetworking:IsHost() then
                        self.max_nr_following_hostages = CTH.settings.cth_increasefollowers or 1 -- excessive nil check
                end
        end
)
