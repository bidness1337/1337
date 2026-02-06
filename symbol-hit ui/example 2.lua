local LoadingTick = os.clock()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bidness1337/samets-drawing-lib-for-skids/refs/heads/main/symbol-hit%20ui/library.lua"))()()

local Window = Library:Window({
    Name = "wahwahwah",
    Size = UDim2.new(0, 760, 0, 500),
    Open = true,
    FontSize = 20
})

-- Customize theme
Library.Theme.Accent = Color3.fromHex('305261')
Library.Theme.Text = Color3.fromHex('546d88')
Library.Theme['Dark Text'] = Color3.fromHex('324250')

-- Create tabs
local CombatTab = Window:Tab({
    Name = "Combat",
    Icon = Library.icons.ragebot, -- Use the icons from the library
})

local MiscTab = Window:Tab({
    Name = "Misc",
    Icon = Library.icons.misc,
})

local VisualsTab = Window:Tab({
    Name = "Visuals",
    Icon = Library.icons.visuals,
})

local SettingsTab = Window:Tab({
    Name = "Settings",
    Icon = Library.icons.settings,
})

-- Create sections and elements
local AimbotSection = CombatTab:Section({
    Name = "Aimbot",
    Side = "left",
    Description = "Aimbot settings"
})

AimbotSection:Toggle({
    Name = "Enabled",
    Value = false,
    Flag = "Aimbot_Enabled",
    Callback = function(Value)
        print("Aimbot:", Value)
    end
})

AimbotSection:Keybind({
    Name = "Aimbot Key",
    Key = Enum.KeyCode.Z,
    Mode = "Toggle",
    Flag = "Aimbot_Key",
    Callback = function(Value)
        print("Aimbot Key:", Value)
    end
})

AimbotSection:Slider({
    Name = "FOV",
    Value = 180,
    Min = 0,
    Max = 360,
    Float = 1,
    Suffix = "%s°",
    Flag = "Aimbot_FOV",
    Callback = function(Value)
        print("FOV:", Value)
    end
})

AimbotSection:Dropdown({
    Name = "Target Selection",
    Values = {"Closest to Crosshair", "Highest Health", "Lowest Health"},
    Value = "Closest to Crosshair",
    Flag = "Aimbot_Target",
    Callback = function(Value)
        print("Target:", Value)
    end
})

AimbotSection:Colorpicker({
    Name = "FOV Color",
    Value = Color3.fromRGB(255, 255, 255),
    Alpha = 0,
    Flag = "FOV_Color",
    Callback = function(Value)
        print("FOV Color:", Value)
    end
})

-- Create a watermark
local Watermark = Library.Watermark({
    Text = 'Library | {fps} FPS | {ping} ms',
    Visible = true,
    Rate = 0.2
})

-- Create notification
Library.Notification({
    Name = "Library Loaded",
    Description = string.format("Loaded in %.4f seconds", os.clock() - LoadingTick),
    Type = "Time",
    Time = 5
})

-- Settings tab example
local SettingsSection = SettingsTab:Section({
    Name = "Settings",
    Side = "left"
})

SettingsSection:Toggle({
    Name = "Watermark",
    Value = true,
    Flag = "Watermark_Enabled",
    Callback = function(Value)
        Watermark.SetVisible(Value)
    end
})

SettingsSection:Keybind({
    Name = "Menu Toggle",
    Key = Enum.KeyCode.RightControl,
    Mode = "Toggle",
    Flag = "Menu_Key",
    Callback = function(Value)
        Window:Open()
    end
})
