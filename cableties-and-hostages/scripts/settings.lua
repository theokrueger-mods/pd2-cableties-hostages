_G.CTH = _G.CTH or {}

-- default settings
CTH.settings = {
        ['cth_infiniteties'] = true,
        ['cth_numsync'] = false,
        ['cth_hidehud'] = false,
        ['cth_increasefollowers'] = 3
}

-- save and load function
function CTH:savesettings()
        local f = io.open(CTH.savefile, 'w+')
        if f then
                f:write(json.encode(CTH.settings))
                f:close()
        end
end

function CTH:loadsettings()
        local f = io.open(CTH.savefile, 'r')
        if f then
                local tbl = json.decode(f:read('*all'))
                if tbl ~= nil and type(tbl) == 'table' then
                        for k, v in pairs(tbl) do
                                CTH.settings[k] = v
                        end
                end
                f:close()
        end
end
