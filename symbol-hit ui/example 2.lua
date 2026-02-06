-- Example usage
local Library = loadstring(game:HttpGet("YOUR_RAW_GITHUB_URL_HERE"))()

local lib = Library({
    Name = "My Custom Library",
    AccentColor = Color3.fromHex('305261'),
    TextColor = Color3.fromHex('546d88'),
    BackgroundColor = Color3.fromHex('171717'),
    FontSize = 20,
    TweenSpeed = 0.2
})

local win = lib:Window({
    name = 'Library',
    size = UDim2.fromOffset(750, 550),
    open = true,
})

-- Create tabs
local ragebot_tab = win:Tab({
    name = 'ragebot',
    icon = lib.v.icons.ragebot,
})

local misc_tab = win:Tab({
    name = 'misc',
    icon = lib.v.icons.misc,
})

local visuals_tab = win:Tab({
    name = 'visuals',
    icon = lib.v.icons.visuals,
})

local settings_tab = win:Tab({
    name = 'settings',
    icon = lib.v.icons.settings,
})

-- Add sections and controls
local general_section = ragebot_tab:Section({
    name = 'general',
    description = 'main settings',
    side = 'left',
})

general_section:Toggle({
    name = 'ragebot',
    value = false,
    callback = function(v)
        lib.Flags.ragebot_enabled = v
    end,
    flag = 'ragebot_enabled',
})

-- Add watermark
local watermarkObj = lib:Watermark({
    text = 'Library | {fps}',
    visible = false,
    rate = 0.2,
})

-- Add notification
lib:Notification({
    name = 'Library',
    description = 'UI loaded successfully!',
    type = 'Time',
    time = 5,
})

-- Set default tab
ragebot_tab.Set(true)

-- Add unload callback
lib:AddUnloadCallback(function()
    print("Library has been unloaded!")
end)
