local old_ptd0001_init = PlayerTweakData.init
function PlayerTweakData:init(tweak_data)
    old_ptd0001_init(self, tweak_data)
    if CTH.Settings.CTHHEnabled and Net:IsHost() then
        self.max_nr_following_hostages = 3
    else
        self.max_nr_following_hostages = 1 -- This allows the "max following hostages" popup to appear
    end
end
