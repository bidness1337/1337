local Window = Library:Window({
    Name = "wahwahwah", -- You can change this to your script name
    FadeSpeed = 0.25
})

local Watermark = Library:Watermark("wahwahwah ~ ".. os.date("%b %d %Y") .. " ~ ".. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
local KeybindList = Library:KeybindList()

Watermark:SetVisibility(false)
KeybindList:SetVisibility(false)

local CombatTab = Window:Page({Name = "Combat", Columns = 2, Subtabs = false})
local MiscTab = Window:Page({Name = "Misc", Columns = 2, Subtabs = true})
local VisualsTab = Window:Page({Name = "Visuals", Columns = 2, Subtabs = false})
local PlayersTab = Window:Page({Name = "Players", Columns = 2, Subtabs = false})
local SettingsTab = Library:CreateSettingsPage(Window, Watermark, KeybindList)

local NewSubtab = MiscTab:SubPage({Icon = "79080568477801", Columns = 2})
local NewSubtab2 = MiscTab:SubPage({Icon = "84929780240463", Columns = 2})

-- NEW: EXAMPLE TOGGLE WITH CONFIGURATION POPUP
do -- Combat Tab
    local AimbotSection = CombatTab:Section({Name = "Aimbot", Side = 1})

    -- Example toggle with configuration popup
    AimbotSection:Toggle({
        Name = "Enabled", 
        Flag = "AimbotEnabled", 
        Default = false, 
        Callback = function(Value)
            print("Aimbot enabled:", Value)
        end,
        -- Configuration options for the popup
        Config = {
            FieldOfView = {
                Type = "slider",
                Name = "Field of View",
                Min = 0,
                Max = 360,
                Default = 90,
                Decimals = 1,
                Suffix = "°",
                Callback = function(Value)
                    print("FoV set to:", Value)
                end
            },
            Smoothness = {
                Type = "slider",
                Name = "Smoothness",
                Min = 0,
                Max = 100,
                Default = 50,
                Decimals = 1,
                Suffix = "%",
                Callback = function(Value)
                    print("Smoothness set to:", Value)
                end
            },
            AimColor = {
                Type = "colorpicker",
                Name = "Aim Color",
                Default = Color3.fromRGB(0, 255, 0),
                Callback = function(Value)
                    print("Aim color set to:", Value)
                end
            },
            AimKey = {
                Type = "keybind",
                Name = "Aim Key",
                Default = "MB2",
                Mode = "Hold",
                Callback = function(Value)
                    print("Aim key set to:", Value)
                end
            },
            TargetBone = {
                Type = "dropdown",
                Name = "Target Bone",
                Items = {"Head", "Torso", "Random"},
                Default = "Head",
                Callback = function(Value)
                    print("Target bone set to:", Value)
                end
            },
            VisibleCheck = {
                Type = "toggle",
                Name = "Visible Check",
                Default = true,
                Callback = function(Value)
                    print("Visible check:", Value)
                end
            }
        }
    })

    AimbotSection:Slider({Name = "Hit Chance", Min = 0, Max = 100, Default = 100, Suffix = "%", Decimals = 1, Compact = true, Flag = "Hit Chance", Callback = function(Value)
        print(Value)
    end})

    AimbotSection:Toggle({Name = "FoV", Flag = "FoV", Default = false, Callback = function(Value)
        print(Value)
    end}):Colorpicker({Name = "FoV Color", Flag = "FoV Color", Default = Color3.fromRGB(255, 255, 255), Callback = function(Value, Alpha)
        print(Value, Alpha)
    end})

    local Divider = AimbotSection:Divider()

    AimbotSection:Toggle({Name = "Silent Aim", Flag = "Silent Aim", Default = false, Callback = function(Value)
        print(Value)
    end})

    AimbotSection:Toggle({Name = "Auto Fire", Flag = "Auto Fire", Default = false, Callback = function(Value)
        print(Value)
    end})

    AimbotSection:Slider({Name = "FoV Size", Min = 0, Max = 1000, Default = 50, Decimals = 0.1, Flag = "FoV Size", Callback = function(Value)
        print(Value)
    end})

    AimbotSection:Dropdown({Name = "Bone", Flag = "Bone", Default = "Head", Items = {"Head", "Torso", "Cock", "Ass🤤"}, Callback = function(Value)
        print(Value)
    end})

    AimbotSection:Dropdown({Name = "Multi part", Flag = "Multi Bone", Default = {"Head", "Torso"}, Multi = true, Items = {"Head", "Torso", "Cock", "Ass🤤"}, Callback = function(Value)
        print(Value)
    end})

    AimbotSection:Toggle({Name = "Visible Check", Flag = "Visible Check2", Default = false, Callback = function(Value)
        print(Value)
    end})

    AimbotSection:Toggle({Name = "Wall Check", Flag = "Wall Check2", Default = false, Callback = function(Value)
        print(Value)
    end})

    local WeaponSection = CombatTab:Section({Name = "Weapon", Side = 2})

    WeaponSection:Toggle({Name = "Auto reload", Flag = "Auto Reload", Default = false, Callback = function(Value)
        print(Value)
    end})

    WeaponSection:Toggle({Name = "Infinite ammo", Flag = "Infinite Ammo", Default = false, Callback = function(Value)
        print(Value)
    end})

    WeaponSection:Toggle({Name = "No recoil", Flag = "No Recoil", Default = false, Callback = function(Value)
        print(Value)
    end})

    WeaponSection:Toggle({Name = "No spread", Flag = "No spread", Default = false, Callback = function(Value)
        print(Value)
    end})

    WeaponSection:Toggle({Name = "Instant hit", Flag = "Instant hit", Default = false, Callback = function(Value)
        print(Value)
    end})

    WeaponSection:Toggle({Name = "Instant reload", Flag = "Instant reload", Default = false, Callback = function(Value)
        print(Value)
    end})

    WeaponSection:Toggle({Name = "Rapid fire", Flag = "Rapid fire", Default = false, Callback = function(Value)
        print(Value)
    end})

    local Ragebot, Originscan, Visuals = CombatTab:MultiSection({Sections = {"Ragebot", "Origin scan", "Visuals"}, Side = 2})

    Ragebot:Toggle({Name = "Enabled", Flag = "Ragebot", Default = false, Callback = function(Value)
        print(Value)
    end})

    Ragebot:Toggle({Name = "Visible Check", Flag = "Visible Check", Default = false, Callback = function(Value)
        print(Value)
    end})

    Ragebot:Toggle({Name = "Wall Check", Flag = "Wall Check", Default = false, Callback = function(Value)
        print(Value)
    end})

    Originscan:Toggle({Name = "Enabled", Flag = "Origin Scan", Default = false, Callback = function(Value)
        print(Value)
    end})

    Originscan:Slider({Name = "Studs", Min = 0, Max = 50, Default = 15, Decimals = 1, Flag = "st", Callback = function(Value)
        print(Value)
    end})

    Visuals:Toggle({Name = "Enabled", Flag = "Visuals", Default = false, Callback = function(Value)
        print(Value)
    end})

    Visuals:Toggle({Name = "Indicator", Flag = "Box", Default = false, Callback = function(Value)
        print(Value)
    end}):Colorpicker({Name = "Color", Flag = "Box Color", Default = Color3.fromRGB(255, 255, 255), Callback = function(Value)
        print(Value)
    end})

    local HighlightLabel = Visuals:Toggle({Name = "Highlight", Flag = "Highlight", Default = false, Callback = function(Value)
        print(Value)
    end})
    HighlightLabel:Colorpicker({Name = "Color", Flag = "Highlight Color", Default = Color3.fromRGB(255, 255, 255), Callback = function(Value)
        print(Value)
    end})

    HighlightLabel:Colorpicker({Name = "Outline Color", Flag = "Highlight Outline Color", Default = Color3.fromRGB(0, 0, 0), Callback = function(Value)
        print(Value)
    end})

    local ScrollableSection = CombatTab:ScrollableSection({Name = "Section", Side = 2, Size = 185})

    for Index = 1, 25 do 
        ScrollableSection:Toggle({Name = "Toggle", Flag = "Toggle1234" .. Index})
    end

    ScrollableSection:Slider({Name = "Slider", Min = 0, Max = 100, Default = 50, Suffix = "%", Decimals = 1, Compact = true, Flag = "Slider"})
end

-- ANOTHER EXAMPLE: ESP toggle with configuration
local ESPToggle = VisualsTab:Section({Name = "ESP", Side = 1}):Toggle({
    Name = "ESP",
    Flag = "ESPEnabled",
    Default = false,
    Callback = function(Value)
        print("ESP enabled:", Value)
    end,
    Config = {
        _order = {"BoxColor", "NameColor", "Distance", "HealthBar", "ShowTeam"},
        BoxColor = {
            Type = "colorpicker",
            Name = "Box Color",
            Default = Color3.fromRGB(255, 0, 0),
            Callback = function(Value)
                print("Box color:", Value)
            end
        },
        NameColor = {
            Type = "colorpicker",
            Name = "Name Color",
            Default = Color3.fromRGB(255, 255, 255),
            Callback = function(Value)
                print("Name color:", Value)
            end
        },
        Distance = {
            Type = "slider",
            Name = "Max Distance",
            Min = 0,
            Max = 1000,
            Default = 500,
            Suffix = " studs",
            Decimals = 0,
            Callback = function(Value)
                print("Max distance:", Value)
            end
        },
        HealthBar = {
            Type = "toggle",
            Name = "Health Bar",
            Default = true,
            Callback = function(Value)
                print("Health bar:", Value)
            end
        },
        ShowTeam = {
            Type = "toggle",
            Name = "Show Team",
            Default = false,
            Callback = function(Value)
                print("Show team:", Value)
            end
        }
    }
})

-- Initialize the library
Library:Init()
