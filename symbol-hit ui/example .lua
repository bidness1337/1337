local LoadingTick = os.clock()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bidness1337/1337/refs/heads/main/symbol-hit%20ui/theme/test%200.2%20.lua"))()

local Window = Library:Window({
    Name = "brrr.lol",
    Size = UDim2.new(0, 550, 0, 470),
    Open = true,
    FontSize = 20
})

Library.Theme.Accent = Color3.fromHex('99eeff')
Library.Theme.Text = Color3.fromHex('99eeff')
Library.Theme['Dark Text'] = Color3.fromHex('565656')
Library.Theme.Background = Color3.fromHex('030303')
Library.Theme['Section Background'] = Color3.fromHex('000000')
Library.Theme['Page Background'] = Color3.fromHex('000000')
Library.Theme['Light Text'] = Color3.fromHex('676767')
Library.Theme['Inline'] = Color3.fromHex('131313')
Library.Theme['Dark Background'] = Color3.fromHex('000000')

local icons = {
    combat = 'rbxassetid://111386589037485',
    misc = 'rbxassetid://126028986879491',
    visuals = 'rbxassetid://115907015044719',
    settings = 'rbxassetid://137300573942266',
}

-- Create tabs
local CombatTab = Window:Tab({
    Name = "combat",
    Icon = icons.combat,
})

local MiscTab = Window:Tab({
    Name = "misc",
    Icon = icons.misc,
})

local VisualsTab = Window:Tab({
    Name = "visuals",
    Icon = icons.visuals,
})

local SettingsTab = Window:Tab({
    Name = "settings",
    Icon = icons.settings,
})

-- Create watermark
local Watermark = Library:Watermark({
    Text = 'brrr.lol | {fps} FPS | {ping} ms',
    Visible = true,
    Rate = 0.2
})

-- ==================== ESP PREVIEW + KEYBIND LIST (from NH UI) ====================
local ESPPreview = Library:ESPPreview({
    name = 'esp preview',
    visible = true,
})

local KeybindList = Library:KeybindList({
    name = 'keybinds',
    visible = true,
})

-- Example keybind entries
KeybindList:Add('RCtrl', 'menu keybind', 'Toggle')
KeybindList:Add('RCtrl', 'watermark', 'Toggle')

-- ==================== SETTINGS TAB ====================
do
    local cs = SettingsTab:Section({
        Name = 'configs',
        Side = 'left',
    })

    -- NEW: Utility section
    local us = SettingsTab:Section({
        Name = 'utility',
        Side = 'left',
    })

    local ts = SettingsTab:Section({
        Name = 'theme',
        Side = 'right',
    })

    cs:Textbox({
        Name = 'config name',
        Value = '',
        Placeholder = 'config name...',
        Flag = 'config_name',
    })

    local cfgPath = 'brrr.lol\\Configs'
    local function getCfgList()
        local cfg = {}
        if isfolder(cfgPath) then
            for _, f in pairs(listfiles(cfgPath)) do
                if f:match('%.json$') then
                    local n = f:match('([^\\/]+)%.json$')
                    if n then
                        table.insert(cfg, n)
                    end
                end
            end
        end
        return #cfg > 0 and cfg or {'no configs'}
    end

    local dd = cs:Dropdown({
        Name = 'configs',
        Values = getCfgList(),
        Value = getCfgList()[1] or 'no configs',
        Callback = function(value) end,
        Flag = 'selected_config',
    })

    local function cfgOp(op)
        local flag = (op == 'load' or op == 'del' or op == 'ovr') and 'selected_config' or 'config_name'
        local nm = Library.Flags[flag]
        if not nm or nm == '' or nm == 'no configs' then
            return
        end
        if not isfolder(cfgPath) then
            makefolder(cfgPath)
        end
        local p = cfgPath .. '\\' .. nm .. '.json'
        if op == 'save' or op == 'ovr' then
            local s, d = pcall(function()
                return Library.GetConfig()
            end)
            if s and d then
                writefile(p, d)
                if dd and dd.Refresh then
                    dd.Refresh(getCfgList())
                end
            end
        elseif op == 'load' then
            if isfile(p) then
                local s, d = pcall(function()
                    return readfile(p)
                end)
                if s and d then
                    pcall(function()
                        Library.LoadConfig(d)
                    end)
                end
            end
        elseif op == 'del' then
            if isfile(p) then
                pcall(function()
                    delfile(p)
                end)
                if dd and dd.Refresh then
                    dd.Refresh(getCfgList())
                end
            end
        end
    end

    cs:Button({
        Name = 'save',
        Callback = function()
            cfgOp('save')
        end,
    })

    cs:Button({
        Name = 'load',
        Callback = function()
            cfgOp('load')
        end,
    })

    cs:Button({
        Name = 'overwrite',
        Callback = function()
            cfgOp('ovr')
        end,
    })

    cs:Button({
        Name = 'delete',
        Callback = function()
            cfgOp('del')
        end,
    })

    cs:Button({
        Name = 'refresh list',
        Callback = function()
            if dd and dd.Refresh then
                dd.Refresh(getCfgList())
            end
        end,
    })

    -- ==================== UTILITY SECTION ====================

    -- Menu keybind
    us:Keybind({
        Name = 'menu keybind',
        Key = Enum.KeyCode.RightControl,
        Mode = 'Toggle',
        Callback = function(v)
            if Window and Window.Open then
                Window:Open()
            end
        end,
        Flag = 'menu_keybind',
    })

    -- Watermark master toggle
    local watermarkToggle = us:Toggle({
        Name = 'watermark',
        Value = false,
        Callback = function(v)
            if Watermark and Watermark.SetVisible then
                Watermark.SetVisible(v)
            end
        end,
        Flag = 'watermark_enabled',
    })

    -- Watermark settings popup
    local watermarkPopup = watermarkToggle:Popup({Size = 200})
    local function updateWatermark()
        local text = 'brrr.lol'
        local types = Library.Flags.watermark_types
        if types and #types > 0 then
            for _, v in ipairs(types) do
                text = text .. ' | {' .. v .. '}'
            end
        end
        if Watermark and Watermark.SetText then
            Watermark.SetText(text)
        end
    end

    watermarkPopup:Slider({
        Name = 'update rate',
        Value = 200,
        Min = 0,
        Max = 1000,
        Float = 1,
        Suffix = '%s ms',
        Callback = function(v)
            Library.Flags.watermark_rate = v
            if Watermark and Watermark.SetRate then
                Watermark.SetRate(v / 1000)
            end
        end,
        Flag = 'watermark_rate',
    })

    watermarkPopup:Dropdown({
        Name = 'info types',
        Values = {'fps', 'ping', 'time', 'date', 'hour', 'minute', 'second', 'ap', 'month', 'day', 'year', 'game', 'n'},
        Value = {'game', 'time'},
        Multi = true,
        Callback = function(v)
            Library.Flags.watermark_types = v
            updateWatermark()
        end,
        Flag = 'watermark_types',
    })

    -- Attach watermark toggle
    us:Toggle({
        Name = 'attach watermark',
        Value = true,
        Callback = function(v)
            if Watermark and Watermark.SetAttached then
                Watermark.SetAttached(v)
            end
        end,
        Flag = 'watermark_attached',
    })

    -- NEW: ESP Preview toggle
    us:Toggle({
        Name = 'esp preview',
        Value = true,
        Callback = function(v)
            if ESPPreview and ESPPreview.SetVisibility then
                ESPPreview.SetVisibility(v)
            end
        end,
        Flag = 'esp_preview_enabled',
    })

    -- NEW: Keybind list toggle
    us:Toggle({
        Name = 'keybind list',
        Value = true,
        Callback = function(v)
            if KeybindList and KeybindList.SetVisibility then
                KeybindList.SetVisibility(v)
            end
        end,
        Flag = 'keybind_list_enabled',
    })

    -- ==================== THEME SECTION ====================

    for theme, color in pairs(Library.Theme) do
        ts:Colorpicker({
            Name = theme:lower(),
            Value = color,
            Alpha = 0,
            Callback = function(d)
                Library.UpdateTheme(theme, d.c)
            end,
            Flag = 'theme_' .. theme:lower():gsub(' ', '_'),
        })
    end

    local gs = SettingsTab:Section({
        Name = 'game panel',
        Side = 'right',
    })

    gs:Button({
        Name = 'copy jobid',
        Callback = function()
            setclipboard(game.JobId)
        end,
    })

    gs:Button({
        Name = 'copy gameid',
        Callback = function()
            setclipboard(tostring(game.GameId))
        end,
    })

    gs:Button({
        Name = 'copy join script',
        Callback = function()
            setclipboard('game:GetService("TeleportService"):TeleportToPlaceInstance(' .. game.PlaceId .. ',"' .. game.JobId .. '",game.Players.LocalPlayer)')
        end,
    })

    gs:Button({
        Name = 'rejoin',
        Callback = function()
            local tps = game:GetService('TeleportService')
            tps:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end,
    })

    gs:Button({
        Name = 'join new server',
        Callback = function()
            local min, max = Library.Flags['srv_min'] or 1, Library.Flags['srv_max'] or 15
            local http = game:GetService('HttpService')
            local tps = game:GetService('TeleportService')

            local s, d = pcall(function()
                return http:JSONDecode(game:HttpGetAsync('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
            end)
            if not s then
                return
            end
            local valid = {}
            for _, srv in pairs(d.data) do
                if srv.playing >= min and srv.playing <= max then
                    table.insert(valid, srv)
                end
            end
            if #valid > 0 then
                tps:TeleportToPlaceInstance(game.PlaceId, valid[math.random(1, #valid)].id, LocalPlayer)
            end
        end,
    })

    gs:Slider({
        Name = 'min players',
        Value = 1,
        Min = 1,
        Max = 30,
        Float = 1,
        Callback = function() end,
        Flag = 'srv_min',
    })

    gs:Slider({
        Name = 'max players',
        Value = 15,
        Min = 1,
        Max = 30,
        Float = 1,
        Callback = function() end,
        Flag = 'srv_max',
    })
end

CombatTab.Set(true)

Library.Notification({
    name = 'brrr.lol',
    description = 'welcome back, brrr.lol is ready and set',
    type = 'Time',
    time = 5,
})
