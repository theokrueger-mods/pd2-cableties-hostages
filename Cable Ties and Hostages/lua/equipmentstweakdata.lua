local old_init = EquipmentsTweakData.init
function EquipmentsTweakData:init(...)
    old_init(self, ...)
    if CTH.Settings.CTHCTEnabled and Net:IsHost() then
        self.specials.cable_tie.max_quantity = 60 -- max ties = 60
    else
        self.specials.cable_tie.max_quantity = 8 -- max ties = 8 (emulating FF basic)
    end
end
