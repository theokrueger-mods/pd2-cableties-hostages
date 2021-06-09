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
