

local LoadingTick = os.clock()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bidness1337/1337/refs/heads/main/symbol-hit%20ui/theme/cut%20out%20accent%201%20.lua"))()

local Window = Library:Window({
    Name = "stride",
    Size = UDim2.new(0, 750, 0, 550),
    Open = true,
    FontSize = 20
})

Library.Windows = {Window}
Library.Theme.Accent = Color3.fromHex('546d88')
Library.Theme.Text = Color3.fromHex('546d88')
Library.Theme['Dark Text'] = Color3.fromHex('324250')
Library.Theme.Background = Color3.fromHex('1b1b1b')
Library.Theme['Section Background'] = Color3.fromHex('151515')
Library.Theme['Page Background'] = Color3.fromHex('171717')
Library.Theme['Light Text'] = Color3.fromHex('676767')
Library.Theme['Inline'] = Color3.fromHex('313131')

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
    Text = 'stride | {fps} FPS | {ping} ms',
    Visible = true,
    Rate = 0.2
})

-- Create notification
Library:Notification({
    Name = "stride",
    Description = string.format("Loaded in %.4f seconds", os.clock() - LoadingTick),
    Type = "Time",
    Time = 5
})

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Global variables
local parts = {"Head","UpperTorso","LowerTorso","LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm","LeftUpperLeg","RightUpperLeg","LeftLowerLeg","RightLowerLeg"}
local easingStyles = {"Linear","Sine","Quad","Cubic","Quart","Quint","Back","Elastic","Bounce","Exponential","Circular"}
local easingDirections = {"In","Out","InOut"}
local Target = nil
local SilentAimActive = false
local AimAssistActive = false
local AimAssistConnection
local CheckConnection
local MainEventSupported = game.PlaceId == 2788229376
local MainEvent = MainEventSupported and ReplicatedStorage:WaitForChild("MainEvent")

-- Initialize default flag values
Library.Flags.silentaim_hitpart = "Head"
Library.Flags.silentaim_airpart = "Head"
Library.Flags.silentaim_prediction = 0
Library.Flags.silentaim_jumpoffset = 0
Library.Flags.silentaim_falloffset = 0
Library.Flags.silentaim_check_knocked = true
Library.Flags.silentaim_check_visible = false
Library.Flags.silentaim_check_team = false

Library.Flags.aimassist_hitpart = "Head"
Library.Flags.aimassist_airpart = "Head"
Library.Flags.aimassist_prediction = 0
Library.Flags.aimassist_smoothness = 0
Library.Flags.aimassist_jumpoffset = 0
Library.Flags.aimassist_falloffset = 0
Library.Flags.aimassist_check_knocked = false
Library.Flags.aimassist_check_visible = false
Library.Flags.aimassist_check_team = false
Library.Flags.aimassist_easing_first = "Cubic"
Library.Flags.aimassist_easing_second = "InOut"

Library.Flags.fov_sync = false
Library.Flags.fov_targetmode = "Keybind"
Library.Flags.fov_visual = false
Library.Flags.fov_color = Color3.fromRGB(77, 77, 77)
Library.Flags.fov_size = 155
Library.Flags.fov_filled = false
Library.Flags.fov_fillcolor = Color3.fromRGB(77, 77, 77)
Library.Flags.fov_gradient = false
Library.Flags.fov_gradient_start = Color3.fromRGB(0, 0, 0)
Library.Flags.fov_gradient_end = Color3.fromRGB(255, 255, 255)
Library.Flags.fov_transparency = 80

-- ESP Defaults
Library.Flags.esp_box_enabled = false
Library.Flags.esp_box_color = Color3.fromRGB(255, 255, 255)
Library.Flags.esp_filled_enabled = false
Library.Flags.esp_filled_color1 = Color3.fromRGB(0, 255, 0)
Library.Flags.esp_filled_color2 = Color3.fromRGB(255, 255, 0)
Library.Flags.esp_filled_color3 = Color3.fromRGB(255, 165, 0)
Library.Flags.esp_filled_color4 = Color3.fromRGB(255, 0, 0)
Library.Flags.esp_filled_transparency = 80

Library.Flags.esp_name_enabled = false
Library.Flags.esp_name_color = Color3.fromRGB(255, 255, 255)
Library.Flags.esp_name_mode = "display"
Library.Flags.esp_studs_enabled = false
Library.Flags.esp_studs_color = Color3.fromRGB(255, 255, 255)
Library.Flags.esp_tool_enabled = false
Library.Flags.esp_tool_color = Color3.fromRGB(255, 255, 255)
Library.Flags.esp_healthbar_enabled = false
Library.Flags.esp_healthnum_toggle = false
Library.Flags.esp_healthnum_color = Color3.fromRGB(255, 255, 255)
Library.Flags.esp_health_lerp = true
Library.Flags.esp_health_high = Color3.fromRGB(0, 255, 0)
Library.Flags.esp_health_medium = Color3.fromRGB(255, 255, 0)
Library.Flags.esp_health_low = Color3.fromRGB(255, 128, 0)
Library.Flags.esp_health_critical = Color3.fromRGB(255, 0, 0)
Library.Flags.esp_armorbar_enabled = false
Library.Flags.esp_armornum_toggle = false
Library.Flags.esp_armornum_color = Color3.fromRGB(255, 255, 255)
Library.Flags.esp_armor_lerp = true
Library.Flags.esp_armor_high = Color3.fromRGB(0, 191, 255)
Library.Flags.esp_armor_medium = Color3.fromRGB(30, 144, 255)
Library.Flags.esp_armor_low = Color3.fromRGB(100, 0, 255)
Library.Flags.esp_armor_critical = Color3.fromRGB(128, 0, 128)

-- Player Chams
Library.Flags.player_chams_enabled = false
Library.Flags.player_chams_color = Color3.fromRGB(255, 255, 255)
Library.Flags.player_chams_transparency = 80

-- Self Visuals
Library.Flags.self_body_material = false
Library.Flags.self_body_color = Color3.fromRGB(255, 255, 255)
Library.Flags.self_body_type = "Neon"
Library.Flags.self_wireframe = false
Library.Flags.self_wireframe_color = Color3.fromRGB(255, 255, 255)
Library.Flags.self_wireframe_thickness = 1
Library.Flags.self_gun_material = false
Library.Flags.self_gun_color = Color3.fromRGB(255, 255, 255)
Library.Flags.self_gun_type = "Neon"
Library.Flags.self_highlight = false
Library.Flags.self_highlight_color = Color3.fromRGB(255, 255, 255)
Library.Flags.self_highlight_transparency = 80

-- Hit Effects
Library.Flags.hit_effect_main = false
Library.Flags.hit_effect_color = Color3.fromRGB(255, 255, 255)
Library.Flags.hit_effect_type = "Particle"
Library.Flags.hit_sound_main = false
Library.Flags.hit_sound_selection = "1"
Library.Flags.hit_sound_volume = 5
Library.Flags.hit_sound_pitch = 1
Library.Flags.hit_chams_main = false
Library.Flags.hit_chams_color = Color3.fromRGB(255, 0, 0)
Library.Flags.hit_chams_material = "Neon"
Library.Flags.hit_chams_duration = 2
Library.Flags.hit_chams_Transparency = 80
Library.Flags.hit_screen_main = false
Library.Flags.hit_screen_color = Color3.fromRGB(255, 0, 0)
Library.Flags.hit_screen_transparency = 0
Library.Flags.hit_screen_duration = 0.5

-- Font system
local fonts = {}
do
    local function Register_Font(Name, Weight, Style, Asset)
        if not isfile(Asset.Id) then
            writefile(Asset.Id, game:HttpGet(Asset.Url))
        end
        if isfile(Name .. ".font") then
            delfile(Name .. ".font")
        end
        local Data = {
            name = Name,
            faces = {
                {
                    name = "Normal",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(Asset.Id),
                },
            },
        }
        writefile(Name .. ".font", HttpService:JSONEncode(Data))
        return getcustomasset(Name .. ".font")
    end

    local ProggyTinyAsset = Register_Font("ProggyTinyCustom", 100, "Normal", {
        Id = "ProggyTiny.ttf",
        Url = "https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyTiny.ttf",
    })
    fonts.main = Font.new(ProggyTinyAsset, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
end

-- Utility functions
local Utility = {
    Connect = function(connection, func)
        return connection:Connect(func)
    end
}

-- LPH NO VIRTUALIZE wrapper
local LPH_NO_VIRTUALIZE = function(func) return func end

-- Signal implementation (same as before)
local Signal = {}
Signal.__index = Signal

do
    Signal.ClassName = 'Signal'
    
    function Signal.new()
        local self = setmetatable({}, Signal)
        self._bindableEvent = Instance.new('BindableEvent')
        self._argMap = {}
        self._source = ''
        
        self._bindableEvent.Event:Connect(function(key)
            self._argMap[key] = nil
            if (not self._bindableEvent) and (not next(self._argMap)) then
                self._argMap = nil
            end
        end)
        
        return self
    end
    
    function Signal:Fire(...)
        if not self._bindableEvent then return end
        local args = {...}
        local key = 1 + #self._argMap
        self._argMap[key] = args
        self._bindableEvent:Fire(key)
    end
    
    function Signal:Connect(handler)
        if not (type(handler) == 'function') then
            error(('connect(%s)'):format(typeof(handler)), 2)
        end
        return self._bindableEvent.Event:Connect(function(key)
            handler(unpack(self._argMap[key]))
        end)
    end
    
    function Signal:Wait()
        local key = self._bindableEvent.Event:Wait()
        local args = self._argMap[key]
        if args then
            return unpack(args)
        else
            error('Missing arg data, probably due to reentrance.')
            return nil
        end
    end
    
    function Signal:Destroy()
        if self._bindableEvent then
            self._bindableEvent:Destroy()
            self._bindableEvent = nil
        end
        setmetatable(self, nil)
    end
    
    Signal.Disconnect = Signal.Destroy
end

-- PlayerInfo system (same as before)
local PlayerInfo = {Info = {}}

do
    PlayerInfo.PlayerAdded = Signal.new()
    PlayerInfo.PlayerRemoved = Signal.new()
    
    function PlayerInfo.GetPlayers()
        return Players:GetPlayers()
    end
    
    function PlayerInfo.GetInfo(player)
        return PlayerInfo.Info[player]
    end
    
    function PlayerInfo.RegisterPlayer(player)
        local Struct = {}
        local IsPlayer = player:IsA('Player')
        
        Struct.Data = {
            Name = player.Name,
            Team = nil,
            DisplayName = IsPlayer and player.DisplayName or player.Name,
            Health = 0,
            MaxHealth = 100,
            Alive = false,
            Character = nil,
            Torso = nil,
            Tool = nil,
            IsTeammate = false,
        }
        
        local Data = Struct.Data
        Data.Spawned = Signal.new()
        Data.Died = Signal.new()
        Data.IsPlayer = IsPlayer
        
        Struct.Step = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
            local Character = Data.IsPlayer and player.Character or player
            Data.Character = Character
            Data.Torso = Character and Character:FindFirstChild('HumanoidRootPart')
            Data.Head = Character and Character:FindFirstChild('Head')
            Data.Alive = Data.Character and Data.Torso
            Data.Tool = Character and Character:FindFirstChildOfClass('Tool') and Character:FindFirstChildOfClass('Tool').Name
            Data.Health = Character and Character:FindFirstChild('Humanoid') and Character.Humanoid.Health
            Data.MaxHealth = Character and Character:FindFirstChild('Humanoid') and Character.Humanoid.MaxHealth
            
            if Data.IsPlayer then
                Data.Team = player.Team
                Data.IsTeammate = Data.Team == LocalPlayer.Team
            end
            
            if Data.Health then
                Data.Health = math.clamp(Data.Health, 0, math.huge)
            end
        end))
        
        Struct.Destroy = function()
            Struct.Step:Disconnect()
            PlayerInfo.PlayerRemoved:Fire(player, Data.IsPlayer)
            PlayerInfo.Info[player] = nil
        end
        
        Struct.Spawned = function()
            Data.Alive = true
            Data.Spawned:Fire()
        end
        
        Struct.Died = function()
            Data.Alive = false
            Data.Died:Fire()
        end
        
        PlayerInfo.Info[player] = Struct
        PlayerInfo.PlayerAdded:Fire(player, Data.IsPlayer)
    end
    
    function PlayerInfo.RemovePlayer(player)
        local Info = PlayerInfo.Info[player]
        if Info then
            Info.Destroy()
        end
    end
    
    for _, player in PlayerInfo.GetPlayers() do
        PlayerInfo.RegisterPlayer(player)
    end
    
    Players.PlayerAdded:Connect(function(player)
        PlayerInfo.RegisterPlayer(player)
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        PlayerInfo.RemovePlayer(player)
    end)
end

-- LocalPlayerData
local LocalPlayerData
RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
    LocalPlayerData = PlayerInfo.GetInfo(LocalPlayer)
end))

-- Cache system
local Cache = {
    getPing = function() 
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000 
    end,
    getPingMs = function() 
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() 
    end,
    getMainEvent = function() 
        return ReplicatedStorage:FindFirstChild("MainEvent") 
    end,
    RunService = RunService,
    vec3 = Vector3.new,
    abs = math.abs,
    clamp = math.clamp,
    insert = table.insert,
    sort = table.sort,
    floor = math.floor,
    huge = math.huge,
}

-- LoopManager (same as before)
local LoopManager = {
    RenderStepped = {Functions = {}, Connection = nil},
    Heartbeat = {Functions = {}, Connection = nil},
    Stepped = {Functions = {}, Connection = nil},
}

function LoopManager:AddRenderStepped(name, func)
    if self.RenderStepped.Functions[name] then
        warn("[LoopManager] RenderStepped function '" .. name .. "' already exists, overwriting")
    end
    self.RenderStepped.Functions[name] = LPH_NO_VIRTUALIZE(func)
    return name
end

function LoopManager:AddHeartbeat(name, func)
    if self.Heartbeat.Functions[name] then
        warn("[LoopManager] Heartbeat function '" .. name .. "' already exists, overwriting")
    end
    self.Heartbeat.Functions[name] = LPH_NO_VIRTUALIZE(func)
    return name
end

function LoopManager:AddStepped(name, func)
    if self.Stepped.Functions[name] then
        warn("[LoopManager] Stepped function '" .. name .. "' already exists, overwriting")
    end
    self.Stepped.Functions[name] = LPH_NO_VIRTUALIZE(func)
    return name
end

function LoopManager:RemoveRenderStepped(name)
    if not self.RenderStepped.Functions[name] then
        warn("[LoopManager] RenderStepped function '" .. name .. "' not found")
        return false
    end
    self.RenderStepped.Functions[name] = nil
    return true
end

function LoopManager:RemoveHeartbeat(name)
    if not self.Heartbeat.Functions[name] then
        warn("[LoopManager] Heartbeat function '" .. name .. "' not found")
        return false
    end
    self.Heartbeat.Functions[name] = nil
    return true
end

function LoopManager:RemoveStepped(name)
    if not self.Stepped.Functions[name] then
        warn("[LoopManager] Stepped function '" .. name .. "' not found")
        return false
    end
    self.Stepped.Functions[name] = nil
    return true
end

LoopManager.RenderStepped.Connection = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
    for name, func in pairs(LoopManager.RenderStepped.Functions) do
        local ok, err = pcall(func)
        if not ok then
            warn("[LoopManager] RenderStepped error in '" .. name .. "': " .. tostring(err))
        end
    end
end))

LoopManager.Heartbeat.Connection = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
    for name, func in pairs(LoopManager.Heartbeat.Functions) do
        local ok, err = pcall(func)
        if not ok then
            warn("[LoopManager] Heartbeat error in '" .. name .. "': " .. tostring(err))
        end
    end
end))

LoopManager.Stepped.Connection = RunService.Stepped:Connect(LPH_NO_VIRTUALIZE(function()
    for name, func in pairs(LoopManager.Stepped.Functions) do
        local ok, err = pcall(func)
        if not ok then
            warn("[LoopManager] Stepped error in '" .. name .. "': " .. tostring(err))
        end
    end
end))

-- Targeting system (same as before)
local Targeting = {
    target = nil,
    targetPlayer = nil,
    charConn = nil,
    removeConn = nil,
    OnTargetSet = nil,
    OnTargetLeft = nil,
}

local function isOnScreen(pos)
    local _, onScreen = Camera:WorldToViewportPoint(pos)
    return onScreen
end

local function hasWall(origin, char)
    if not char or not char:FindFirstChild('HumanoidRootPart') then return true end
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character, char}
    
    local dir = (char.HumanoidRootPart.Position - origin).Unit * 500
    return Workspace:Raycast(origin, dir, params) ~= nil
end

local function getDist(char, mode)
    if not char or not char:FindFirstChild('HumanoidRootPart') then return Cache.huge end
    
    if mode == '3D' then
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
            return Cache.huge
        end
        return (LocalPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
    else
        local hrp = char.HumanoidRootPart
        local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        if not onScreen then return Cache.huge end
        
        local mousePos = UserInputService:GetMouseLocation()
        local targetPos = Vector2.new(screenPos.X, screenPos.Y)
        return (mousePos - targetPos).Magnitude
    end
end

local function checkFilters(char, filters)
    if not char then return false end
    if not char:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

local defaultFilters = {
    SkipFF = true,
    SkipKO = true,
    SkipDead = true,
    SkipGrabbed = true,
}

function Targeting:SetTarget(source, filters)
    filters = filters or defaultFilters
    
    local char
    if type(source) == 'string' then
        local player = Players:FindFirstChild(source)
        if player and player.Character then
            char = player.Character
        end
    else
        local closestDist, closest = Cache.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and checkFilters(p.Character, filters) then
                local dist = getDist(p.Character)
                if dist < closestDist then
                    closestDist = dist
                    closest = p.Character
                end
            end
        end
        char = closest
    end
    
    if not char then return false end
    
    self.target = char
    
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character == char then
            self.targetPlayer = p
            self:setupCharTracking(p)
            if self.OnTargetSet then
                self.OnTargetSet(p.Name)
            end
            break
        end
    end
    
    return true
end

function Targeting:ClearTarget(playerLeft)
    if self.charConn then
        self.charConn:Disconnect()
        self.charConn = nil
    end
    if self.removeConn then
        self.removeConn:Disconnect()
        self.removeConn = nil
    end
    
    local hadTarget = self.targetPlayer ~= nil
    self.target = nil
    self.targetPlayer = nil
    
    if hadTarget then
        if playerLeft and self.OnTargetLeft then
            self.OnTargetLeft()
        elseif self.OnTargetSet then
            self.OnTargetSet(nil)
        end
    end
end

function Targeting:IsTargetValid()
    if not self.targetPlayer then return false end
    if not self.targetPlayer.Parent then
        self:ClearTarget()
        return false
    end
    
    local char = self.targetPlayer.Character
    if char and char.Parent then
        self.target = char
        return true
    end
    return false
end

function Targeting:GetTargetInfo(infoTypes)
    if not self:IsTargetValid() then return nil end
    
    infoTypes = infoTypes or {'all'}
    
    local hum = self.target:FindFirstChildOfClass('Humanoid')
    local bodyEffects = self.target:FindFirstChild('BodyEffects')
    local hrp = self.target:FindFirstChild('HumanoidRootPart')
    local player = self.targetPlayer
    local info = {}
    local isAll = infoTypes[1] == 'all'
    local types = {}
    
    for _, t in ipairs(infoTypes) do types[t] = true end
    
    if isAll or types['basic'] then
        info.Character = self.target
        info.Player = player
        info.PlayerName = player and player.Name or 'Unknown'
    end
    if isAll or types['health'] then
        info.HP = hum and Cache.floor(hum.Health) or 0
        info.MaxHP = hum and Cache.floor(hum.MaxHealth) or 0
    end
    if isAll or types['position'] then
        info.HRP = hrp
        info.Coords = hrp and hrp.Position or Vector3.new(0,0,0)
    end
    if isAll or types['distance'] then
        info.Distance = getDist(self.target, '3D')
        info.MouseDistance = getDist(self.target)
    end
    if isAll or types['visibility'] then
        info.OnScreen = hrp and isOnScreen(hrp.Position) or false
        info.HasWall = hrp and LocalPlayer.Character and hasWall(LocalPlayer.Character.HumanoidRootPart.Position, self.target) or false
    end
    if isAll or types['state'] then
        info.IsKO = (bodyEffects and bodyEffects:FindFirstChild('K.O') and bodyEffects['K.O'].Value) or (hum and hum.Health <= 0)
        info.IsDead = bodyEffects and bodyEffects:FindFirstChild('SDeath') and bodyEffects.SDeath.Value
        info.IsGrabbed = self.target:FindFirstChild('GRABBING_CONSTRAINT') ~= nil
        info.HasFF = (self.target:FindFirstChild('ForceField') or self.target:FindFirstChild('ForceField_TESTING')) ~= nil
    end
    if isAll or types['effects'] then
        info.BodyEffects = bodyEffects
    end
    
    return info
end

function Targeting:GetTargetPlayer()
    if not self.target then return nil end
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character == self.target then
            return p
        end
    end
    return nil
end

function Targeting:setupCharTracking(player)
    if self.charConn then
        self.charConn:Disconnect()
        self.charConn = nil
    end
    if self.removeConn then
        self.removeConn:Disconnect()
        self.removeConn = nil
    end
    
    self.targetPlayer = player
    self.charConn = player.CharacterAdded:Connect(function(newChar)
        self.target = newChar
    end)
    self.removeConn = Players.PlayerRemoving:Connect(function(p)
        if p == self.targetPlayer then
            self:ClearTarget(true)
        end
    end)
end

-- Desync system (same as before)
local Desync = {
    state = {
        enabled = false,
        target = nil,
        real = nil,
        hooked = false,
        follow = false,
        conn = nil,
        priority = 0,
        priorityOwner = nil,
        lastSyncTime = 0,
        syncCooldown = 0,
    }
}

do
    function Desync:validate()
        local char = LocalPlayer.Character
        if not char then return false end
        
        local hum = char:FindFirstChildOfClass('Humanoid')
        if not hum or hum.Health <= 0 then return false end
        
        return hum.RootPart ~= nil
    end
    
    function Desync:getRoot()
        local char = LocalPlayer.Character
        if not char then return nil end
        
        local hum = char:FindFirstChildOfClass('Humanoid')
        return hum and hum.RootPart
    end
    
    function Desync:parseCF(arg1, arg2, arg3)
        local t = typeof(arg1)
        if t == 'CFrame' then
            return arg1
        elseif t == 'Vector3' then
            return CFrame.new(arg1.X, arg1.Y, arg1.Z)
        elseif t == 'table' and arg1[1] and arg1[2] and arg1[3] then
            return CFrame.new(arg1[1], arg1[2], arg1[3])
        elseif t == 'number' and type(arg2) == 'number' and type(arg3) == 'number' then
            return CFrame.new(arg1, arg2, arg3)
        end
        return nil
    end
    
    do
        local function install()
            if Desync.state.hooked then return end
            if not hookmetamethod or not newcclosure or not checkcaller then
                Desync.state.hooked = true
                return
            end
            
            local old
            local hookFunction = newcclosure(LPH_NO_VIRTUALIZE(function(self, key)
                if not checkcaller() and key == 'CFrame' and Desync.state.enabled then
                    local root = Desync:getRoot()
                    if root and self == root and Desync.state.real then
                        return Desync.state.real
                    end
                end
                return old(self, key)
            end))
            
            old = hookmetamethod(game, '__index', hookFunction)
            Desync.state.hooked = true
        end
        
        function Desync:installHook()
            install()
        end
    end
    
    do
        local function start()
            if Desync.state.conn then return end
            
            Desync.state.conn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
                if not Desync.state.enabled then
                    if Desync.state.conn then
                        Desync.state.conn:Disconnect()
                        Desync.state.conn = nil
                    end
                    return
                end
                if not Desync:validate() then return end
                
                local root = Desync:getRoot()
                if not root then return end
                
                Desync.state.real = root.CFrame
                
                local targetCF = Desync.state.follow and root.CFrame or (Desync.state.target or Desync.state.real)
                root.CFrame = targetCF
                
                RunService.RenderStepped:Wait()
                root.CFrame = Desync.state.real
            end))
        end
        
        function Desync:startLoop()
            start()
        end
    end
    
    function Desync:setPriority(priority, owner)
        self.state.priority = priority
        self.state.priorityOwner = owner
    end
    
    function Desync:getPriority()
        return self.state.priority, self.state.priorityOwner
    end
    
    function Desync:canMove(priority, owner)
        local currentTime = tick()
        if currentTime - self.state.lastSyncTime < self.state.syncCooldown then
            return false
        end
        if self.state.priority == 0 then return true end
        if priority > self.state.priority then return true end
        if priority == self.state.priority and self.state.priorityOwner == owner then return true end
        return false
    end
    
    function Desync:moveTo(arg1, arg2, arg3, priority, owner)
        priority = priority or 0
        owner = owner or 'unknown'
        
        if not self:canMove(priority, owner) then return nil end
        
        local targetCF = self:parseCF(arg1, arg2, arg3)
        if not targetCF then return nil end
        
        self.state.target = targetCF
        self.state.follow = false
        self.state.enabled = true
        self.state.priority = priority
        self.state.priorityOwner = owner
        
        self:installHook()
        self:startLoop()
        
        return targetCF
    end
    
    function Desync:syncWithPlayer(syncCooldown)
        if not self:validate() then return nil end
        
        self.state.target = nil
        self.state.follow = true
        self.state.enabled = true
        self.state.priority = 0
        self.state.priorityOwner = nil
        self.state.lastSyncTime = tick()
        self.state.syncCooldown = syncCooldown or 0
        
        self:installHook()
        self:startLoop()
        
        local root = self:getRoot()
        return root and root.CFrame or nil
    end
    
    function Desync:stop()
        self.state.enabled = false
        self.state.target = nil
        self.state.follow = false
        
        if self.state.conn then
            pcall(function() self.state.conn:Disconnect() end)
            self.state.conn = nil
        end
    end
    
    function Desync:isEnabled()
        return self.state.enabled
    end
    
    function Desync:getPosition()
        return self.state.target and self.state.target.Position or (self:getRoot() and self:getRoot().Position)
    end
    
    function Desync:getState()
        return self.state.enabled
    end
    
    function Desync:moveDesyncTo(arg1, arg2, arg3, priority, owner)
        return self:moveTo(arg1, arg2, arg3, priority, owner)
    end
    
    function Desync:synchronizeSyncWithPlayer()
        return self:syncWithPlayer()
    end
end

-- General visual effects system (using flags)
local General = {}

do
    local tracer_outline, tracer_main = Drawing.new('Line'), Drawing.new('Line')
    local circle_lines = {}
    local highlight = nil
    local circle_c1, circle_c2, circle_c3, circle_c4 = Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255), Color3.fromRGB(255,255,0)
    local circle_speed = 0.25
    local tracerSmooth, tracerLastTo = false, nil
    local tracerSmoothType, tracerCustomDelay = 'ping', 200
    
    tracer_outline.Visible = false
    tracer_outline.Color = Color3.fromRGB(0,0,0)
    tracer_outline.Thickness = 3
    tracer_outline.Transparency = 1
    
    tracer_main.Visible = false
    tracer_main.Color = Color3.fromRGB(255,255,255)
    tracer_main.Thickness = 1.5
    tracer_main.Transparency = 1
    
    local function lerp(a, b, t)
        return a + (b - a) * t
    end
    
    local function lerpVec2(a, b, t)
        return Vector2.new(a.X + (b.X - a.X) * t, a.Y + (b.Y - a.Y) * t)
    end
    
    local function getTracerSmoothFactor()
        if tracerSmoothType == 'ping' then
            return math.clamp(Cache.getPingMs() / 1000, 0.05, 0.5)
        else
            return tracerCustomDelay / 1000
        end
    end
    
    local function col_lerp(a, b, t)
        return Color3.new(lerp(a.R, b.R, t), lerp(a.G, b.G, t), lerp(a.B, b.B, t))
    end
    
    local function get_circle_col(t)
        t = (t + tick() * circle_speed) % 1
        if t < 0.25 then
            return col_lerp(circle_c1, circle_c2, t * 4)
        elseif t < 0.5 then
            return col_lerp(circle_c2, circle_c3, (t - 0.25) * 4)
        elseif t < 0.75 then
            return col_lerp(circle_c3, circle_c4, (t - 0.5) * 4)
        else
            return col_lerp(circle_c4, circle_c1, (t - 0.75) * 4)
        end
    end
    
    LoopManager:AddHeartbeat('general', function()
        local isTargetAlive = Targeting.target and Targeting.target:FindFirstChildOfClass('Humanoid') and Targeting.target:FindFirstChildOfClass('Humanoid').Health > 0
        
        if Library.Flags.visualise_view then
            local target = isTargetAlive and Targeting.target or nil
            if target and target:FindFirstChild('Humanoid') then
                Camera.CameraSubject = target.Humanoid
            elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('Humanoid') then
                Camera.CameraSubject = LocalPlayer.Character.Humanoid
            end
        else
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('Humanoid') then
                Camera.CameraSubject = LocalPlayer.Character.Humanoid
            end
        end
        
        if Library.Flags.visualise_tracer then
            local target, destPart = isTargetAlive and Targeting.target or nil
            if target then
                destPart = target:FindFirstChild(Library.Flags.tracer_destination or 'HumanoidRootPart')
            end
            if destPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(destPart.Position)
                if onScreen and screenPos.Z > 0 then
                    local origin = Library.Flags.tracer_origin or 'mouse'
                    local vp = Camera.ViewportSize
                    local fromPos = origin == 'mouse' and UserInputService:GetMouseLocation() or 
                                   origin == 'center' and Vector2.new(vp.X/2, vp.Y/2) or 
                                   origin == 'top' and Vector2.new(vp.X/2, 0) or 
                                   Vector2.new(vp.X/2, vp.Y)
                    local targetTo = Vector2.new(screenPos.X, screenPos.Y)
                    
                    if tracerSmooth and tracerLastTo then
                        local factor = math.clamp(getTracerSmoothFactor(), 0.05, 0.5)
                        targetTo = lerpVec2(tracerLastTo, targetTo, factor)
                    end
                    
                    tracerLastTo = targetTo
                    tracer_outline.From = fromPos
                    tracer_outline.To = targetTo
                    tracer_outline.Visible = true
                    
                    tracer_main.From = fromPos
                    tracer_main.To = targetTo
                    tracer_main.Visible = true
                else
                    tracer_outline.Visible = false
                    tracer_main.Visible = false
                    tracerLastTo = nil
                end
            else
                tracer_outline.Visible = false
                tracer_main.Visible = false
                tracerLastTo = nil
            end
        else
            tracer_outline.Visible = false
            tracer_main.Visible = false
            tracerLastTo = nil
        end
        
        if Library.Flags.visualise_highlight then
            local target = isTargetAlive and Targeting.target or nil
            if target then
                if not highlight or highlight.Parent ~= target then
                    if highlight then highlight:Destroy() end
                    highlight = Instance.new('Highlight')
                    highlight.Adornee = target
                    highlight.FillColor = Library.Flags.highlight_fill_color or Color3.fromRGB(255,255,255)
                    highlight.FillTransparency = Library.Flags.highlight_fill_alpha or 0.5
                    highlight.OutlineColor = Library.Flags.highlight_outline_color or Color3.fromRGB(0,0,0)
                    highlight.OutlineTransparency = Library.Flags.highlight_outline_alpha or 0
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = target
                end
            else
                if highlight then
                    highlight:Destroy()
                    highlight = nil
                end
            end
        else
            if highlight then
                highlight:Destroy()
                highlight = nil
            end
        end
        
        if Library.Flags.visualise_circle then
            local target = isTargetAlive and Targeting.target or nil
            if target then
                local root = target:FindFirstChild('HumanoidRootPart')
                if root then
                    local radius = Library.Flags.circle_radius or 2
                    local thick = Library.Flags.circle_thickness or 2.5
                    local rotSpeed = Library.Flags.circle_rotspeed or 3
                    local visible = (Library.Flags.circle_visible or 35) / 100
                    local angleOffset = (tick() * rotSpeed) % (math.pi * 2)
                    
                    for i = 1, 60 do
                        local f = i / 60
                        if f > visible then
                            if circle_lines[i] then circle_lines[i].Visible = false end
                            return
                        end
                        
                        local line = circle_lines[i] or Drawing.new('Line')
                        circle_lines[i] = line
                        line.Thickness = thick
                        line.Color = get_circle_col(f)
                        
                        local a = f * math.pi * 2 + angleOffset
                        local b = (i + 1) / 60 * math.pi * 2 + angleOffset
                        local p1 = root.Position + Vector3.new(math.cos(a), 0, math.sin(a)) * radius
                        local p2 = root.Position + Vector3.new(math.cos(b), 0, math.sin(b)) * radius
                        local s1 = Camera:WorldToViewportPoint(p1)
                        local s2 = Camera:WorldToViewportPoint(p2)
                        
                        line.From = Vector2.new(s1.X, s1.Y)
                        line.To = Vector2.new(s2.X, s2.Y)
                        local d1 = f * 60
                        local d2 = visible * 60 - f * 60
                        line.Transparency = (d1 < 7 and d1 / 7) or (d2 < 7 and d2 / 7) or 1
                        line.Visible = true
                    end
                else
                    for _, l in ipairs(circle_lines) do if l then l.Visible = false end end
                end
            else
                for _, l in ipairs(circle_lines) do if l then l.Visible = false end end
            end
        end
        
        if Library.Flags.visualise_lookat then
            local target = isTargetAlive and Targeting.target or nil
            if target and LocalPlayer.Character then
                local root = LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
                local targetRoot = target:FindFirstChild('HumanoidRootPart')
                if root and targetRoot then
                    local dir = (targetRoot.Position - root.Position).Unit
                    local angle = math.atan2(dir.X, dir.Z)
                    root.CFrame = root.CFrame * CFrame.Angles(0, angle - math.atan2(root.CFrame.LookVector.X, root.CFrame.LookVector.Z), 0)
                end
            end
        end
    end)
    
    function General:setTracerSmooth(v)
        tracerSmooth = v
        tracerLastTo = nil
    end
    
    function General:setTracerSmoothType(t)
        tracerSmoothType = t
    end
    
    function General:setTracerCustomDelay(d)
        tracerCustomDelay = d
    end
    
    function General:setTracerOutlineColor(c, a)
        tracer_outline.Color = c
        tracer_outline.Transparency = 1 - a
    end
    
    function General:setTracerMainColor(c, a)
        tracer_main.Color = c
        tracer_main.Transparency = 1 - a
    end
    
    function General:setTracerOutlineThickness(t)
        tracer_outline.Thickness = t
    end
    
    function General:setTracerMainThickness(t)
        tracer_main.Thickness = t
    end
    
    function General:setHighlightFillColor(c, a)
        if highlight then
            highlight.FillColor = c
            highlight.FillTransparency = a
        end
    end
    
    function General:setHighlightOutlineColor(c, a)
        if highlight then
            highlight.OutlineColor = c
            highlight.OutlineTransparency = a
        end
    end
    
    function General:setCircleColor(c)
        circle_c1 = c
    end
    
    function General:setCircleColor2(c)
        circle_c2 = c
    end
    
    function General:setCircleColor3(c)
        circle_c3 = c
    end
    
    function General:setCircleColor4(c)
        circle_c4 = c
    end
    
    function General:setCircleSpeed(s)
        circle_speed = s
    end
end

-- Auto Fire system (using flags)
local AutoFire = {
    cooldown = 4,
    lastShoot = 0,
    swayDir = 1,
}

local function getOrigin(origin, targetPart, desyncPos)
    if origin == 'sway' then
        return (desyncPos or targetPart.Position) + Vector3.new(0, AutoFire.swayDir * 15, 0)
    end
    if origin == 'upper' then
        return (desyncPos or targetPart.Position) + Vector3.new(0, 25, 0)
    end
    if origin == 'random' then
        return (desyncPos or targetPart.Position) + Vector3.new(math.random(-20,20), math.random(-20,20), math.random(-20,20))
    end
    return desyncPos or targetPart.Position
end

function AutoFire:setCooldown(ms)
    self.cooldown = ms
end

LoopManager:AddHeartbeat('autofire', function()
    if not Library.Flags.autofire_enabled then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local hasTools = false
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA('Tool') and t:FindFirstChild('Handle') then
            hasTools = true
            break
        end
    end
    
    if not hasTools then return end
    
    local target = Targeting.target
    if not target then return end
    
    if Library.Flags.autofire_checks then
        local info = Targeting:GetTargetInfo({'state'})
        if not info then return end
        if Library.Flags.autofire_check_ko and info.IsKO then return end
        if Library.Flags.autofire_check_ff and info.HasFF then return end
        if Library.Flags.autofire_check_dead and info.IsDead then return end
        if Library.Flags.autofire_check_grabbed and info.IsGrabbed then return end
    end
    
    local tPart = target:FindFirstChild(Library.Flags.autofire_destination or 'Head')
    if not tPart then return end
    
    local now = tick()
    if now - AutoFire.lastShoot < AutoFire.cooldown / 1000 then return end
    
    local origin = Library.Flags.autofire_origin or 'destination'
    local desyncPos = Desync and Desync:getPosition() or nil
    local mainEvent = Cache.getMainEvent()
    if not mainEvent then return end
    
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA('Tool') and tool:FindFirstChild('Handle') then
            pcall(function()
                mainEvent:FireServer('ShootGun', tool.Handle, getOrigin(origin, tPart, desyncPos), tPart.Position, tPart, Vector3.new(0,0,0))
            end)
        end
    end
    
    AutoFire.lastShoot = now
    AutoFire.swayDir = -AutoFire.swayDir
end)

-- Auto Equip system (using flags)
local AutoEquip = {}

do
    local equipCd = 100
    local loopCd = 80
    local lastEquip = 0
    local lastLoop = 0
    local wasEnabled = true
    
    LoopManager:AddHeartbeat('autoequip', function()
        if not Library.Flags.autoequip_enabled then
            if wasEnabled then
                wasEnabled = false
                local char = LocalPlayer.Character
                if char then
                    for _, tool in ipairs(char:GetChildren()) do
                        if tool:IsA('Tool') then
                            pcall(function()
                                tool.Parent = LocalPlayer:FindFirstChild('Backpack') or LocalPlayer
                            end)
                        end
                    end
                end
            end
            return
        end
        
        wasEnabled = true
        
        if Library.Flags.autoequip_check_target and not Targeting.target then return end
        
        local now = tick()
        if now - lastLoop < loopCd / 1000 then return end
        lastLoop = now
        
        local char = LocalPlayer.Character
        if not char then return end
        if not char:FindFirstChild('FULLY_LOADED_CHAR') then return end
        
        local hum = char:FindFirstChildOfClass('Humanoid')
        if not hum or hum.Health <= 0 then return end
        
        local selectedGuns = Library.Flags.autoequip_guns or {}
        if #selectedGuns == 0 then return end
        
        local backpack = LocalPlayer:FindFirstChild('Backpack')
        if not backpack then return end
        
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA('Tool') then
                for _, gun in ipairs(selectedGuns) do
                    local toolName = tool.Name
                    local gunName = gun
                    local match = (toolName == gunName) or (toolName == '[' .. gunName .. ']') or (toolName:gsub('[%[%]]', '') == gunName)
                    
                    if match then
                        local equipNow = tick()
                        if equipNow - lastEquip >= equipCd / 1000 then
                            pcall(function()
                                tool.Parent = char
                            end)
                            lastEquip = equipNow
                        end
                        return
                    end
                end
            end
        end
    end)
    
    function AutoEquip:setEquipCooldown(ms)
        equipCd = ms
    end
end

-- Velocity Break system (using flags)
local VelocityBreak = {}

do
    local velX, velY, velZ = 0, 0, 0
    local tracer = Drawing.new('Line')
    
    tracer.Visible = false
    tracer.Color = Color3.fromRGB(255,255,255)
    tracer.Thickness = 1
    tracer.Transparency = 0
    
    LoopManager:AddHeartbeat('velocity_break', function()
        if not Library.Flags.velocity_break_enabled then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local root = char:FindFirstChild('HumanoidRootPart')
        if not root then return end
        
        local oldVel = root.Velocity
        local vel = Vector3.new(velX, velY, velZ)
        
        root.Velocity = vel
        RunService.RenderStepped:Wait()
        root.Velocity = oldVel
        
        if Library.Flags.velocity_break_visualise then
            local endPos = root.Position + vel
            local s1, onScreen1 = Camera:WorldToViewportPoint(root.Position)
            local s2, onScreen2 = Camera:WorldToViewportPoint(endPos)
            
            tracer.From = Vector2.new(s1.X, s1.Y)
            tracer.To = Vector2.new(s2.X, s2.Y)
            tracer.Visible = onScreen1 and onScreen2
        else
            tracer.Visible = false
        end
    end)
    
    function VelocityBreak:setVelocityX(v) velX = v end
    function VelocityBreak:setVelocityY(v) velY = v end
    function VelocityBreak:setVelocityZ(v) velZ = v end
    function VelocityBreak:setTracerColor(c, a)
        tracer.Color = c
        tracer.Transparency = 1 - a
    end
end

-- Physics Sender Rate system (using flags)
local PhysicsSenderRate = {}

do
    local rate = 240
    local mode = 'default'
    
    LoopManager:AddHeartbeat('physics_sender_rate', function()
        if Library.Flags.physics_sender_rate_enabled then
            local val = mode == 'extra low' and 1 or mode == 'extra big' and 223222323 or (Library.Flags.physics_sender_rate_value or 240)
            pcall(function()
                setfflag('S2PhysicsSenderRate', tostring(val))
            end)
        else
            pcall(function()
                setfflag('S2PhysicsSenderRate', '240')
            end)
        end
    end)
    
    function PhysicsSenderRate:setRate(v) rate = v end
    function PhysicsSenderRate:setMode(m) mode = m end
end

-- A-Sync system (using flags)
local ASync = {}

do
    local cooldown = 0.1
    
    LoopManager:AddHeartbeat('a_sync', function()
        if not Library.Flags.a_sync_enabled then return end
        
        pcall(function() setfflag('PhysicsSenderMaxBandwidthBps', '1') end)
        task.wait(cooldown)
        pcall(function() setfflag('PhysicsSenderMaxBandwidthBps', '999999') end)
        task.wait(0.05)
    end)
    
    function ASync:setCooldown(v) cooldown = v end
end

-- Visualise Desync system (using flags)
local VisualiseDesync = {}

do
    local tracer_outline = Drawing.new('Line')
    local tracer_main = Drawing.new('Line')
    
    tracer_outline.Visible = false
    tracer_outline.Color = Color3.fromRGB(0,0,0)
    tracer_outline.Thickness = 3
    tracer_outline.Transparency = 1
    
    tracer_main.Visible = false
    tracer_main.Color = Color3.fromRGB(255,255,255)
    tracer_main.Thickness = 1.5
    tracer_main.Transparency = 0
    
    local function getRealPosition()
        if Desync and Desync:isEnabled() then
            return Desync:getPosition()
        end
        local char = LocalPlayer and LocalPlayer.Character
        if not char then return nil end
        local hum = char:FindFirstChildOfClass('Humanoid')
        return hum and hum.RootPart and hum.RootPart.Position or nil
    end
    
    local function isSynced()
        local realPos = getRealPosition()
        local playerRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
        return realPos and playerRoot and realPos == playerRoot.Position
    end
    
    local tracerLoopAdded = false
    local tracerSmooth = false
    local tracerLastTo = nil
    local tracerSmoothType = 'ping'
    local tracerCustomDelay = 200
    
    local function lerpVec2(a, b, t)
        return Vector2.new(a.X + (b.X - a.X) * t, a.Y + (b.Y - a.Y) * t)
    end
    
    local function getTracerSmoothFactor()
        local delay = tracerSmoothType == 'ping' and math.max(Cache.getPingMs(), 50) or tracerCustomDelay
        return math.clamp(16 / delay, 0.05, 0.5)
    end
    
    local function updateTracer()
        if not Library.Flags.desync_tracer_enabled or (Library.Flags.desync_dont_show_if_synced and isSynced()) then
            tracer_outline.Visible = false
            tracer_main.Visible = false
            tracerLastTo = nil
            return
        end
        
        local realPos = getRealPosition()
        if not realPos then
            tracer_outline.Visible = false
            tracer_main.Visible = false
            tracerLastTo = nil
            return
        end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(realPos)
        if onScreen and screenPos.Z > 0 then
            local targetTo = Vector2.new(screenPos.X, screenPos.Y)
            local fromPos = UserInputService:GetMouseLocation()
            
            if tracerSmooth and tracerLastTo then
                targetTo = lerpVec2(tracerLastTo, targetTo, getTracerSmoothFactor())
            end
            
            tracerLastTo = targetTo
            tracer_outline.From = fromPos
            tracer_outline.To = targetTo
            tracer_outline.Visible = true
            
            tracer_main.From = fromPos
            tracer_main.To = targetTo
            tracer_main.Visible = true
        else
            tracer_outline.Visible = false
            tracer_main.Visible = false
            tracerLastTo = nil
        end
    end
    
    function VisualiseDesync:setTracerSmooth(v)
        tracerSmooth = v
        tracerLastTo = nil
    end
    
    function VisualiseDesync:setTracerSmoothType(t)
        tracerSmoothType = t
    end
    
    function VisualiseDesync:setTracerSmoothDelay(d)
        tracerCustomDelay = d
    end
    
    function VisualiseDesync:setTracerEnabled(enabled)
        if enabled and not tracerLoopAdded then
            LoopManager:AddRenderStepped('desync_tracer', updateTracer)
            tracerLoopAdded = true
        elseif not enabled and tracerLoopAdded then
            LoopManager:RemoveRenderStepped('desync_tracer')
            tracerLoopAdded = false
            tracer_outline.Visible = false
            tracer_main.Visible = false
        end
    end
    
    function VisualiseDesync:setTracerColor(c, a)
        tracer_main.Color = c
        tracer_main.Transparency = 1 - a
    end
    
    function VisualiseDesync:setTracerOutlineColor(c, a)
        tracer_outline.Color = c
        tracer_outline.Transparency = 1 - a
    end
    
    function VisualiseDesync:setTracerOutlineThickness(t)
        tracer_outline.Thickness = t
    end
    
    function VisualiseDesync:setTracerMainThickness(t)
        tracer_main.Thickness = t
    end
    
    do
        local screenGui = nil
        local frame = nil
        local imageLabel = nil
        local uiStroke = nil
        local imgSize = 100
        local imgColor = Color3.fromHex('305261')
        local bgColor = Color3.fromHex('1b1b1b')
        local strokeColor = Color3.fromHex('305261')
        local smoothEnabled = false
        local currentTween = nil
        local smoothType = 'ping'
        local customDelay = 200
        
        local function getSmoothDuration()
            if smoothType == 'ping' then
                return math.max(Cache.getPingMs() / 1000, 0.05)
            else
                return customDelay / 1000
            end
        end
        
        local function createImage()
            if screenGui then pcall(function() screenGui:Destroy() end) end
            
            screenGui = Instance.new('ScreenGui')
            screenGui.Name = 'DesyncImageGui'
            screenGui.ResetOnSpawn = false
            screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            screenGui.Parent = LocalPlayer:WaitForChild('PlayerGui')
            
            frame = Instance.new('Frame')
            frame.Size = UDim2.fromOffset(imgSize, imgSize)
            frame.AnchorPoint = Vector2.new(0.5, 0.5)
            frame.BorderSizePixel = 0
            frame.BackgroundColor3 = bgColor
            frame.Parent = screenGui
            
            local corner = Instance.new('UICorner')
            corner.CornerRadius = UDim.new(2, 8)
            corner.Parent = frame
            
            uiStroke = Instance.new('UIStroke')
            uiStroke.Color = strokeColor
            uiStroke.Thickness = 1.5
            uiStroke.Parent = frame
            
            imageLabel = Instance.new('ImageLabel')
            imageLabel.Size = UDim2.fromScale(1, 1)
            imageLabel.BackgroundTransparency = 1
            imageLabel.BorderSizePixel = 0
            imageLabel.Image = 'rbxassetid://128540628323761'
            imageLabel.ImageColor3 = imgColor
            imageLabel.Parent = frame
            
            local imgCorner = Instance.new('UICorner')
            imgCorner.CornerRadius = UDim.new(2, 8)
            imgCorner.Parent = imageLabel
        end
        
        local function updateImage()
            if not Library.Flags.desync_image_enabled or (Library.Flags.desync_dont_show_if_synced and isSynced()) then
                if screenGui then screenGui.Enabled = false end
                if currentTween then currentTween:Cancel() currentTween = nil end
                return
            end
            
            local realPos = getRealPosition()
            if not realPos then
                if screenGui then screenGui.Enabled = false end
                return
            end
            
            if not screenGui or not frame then createImage() end
            
            local screenPos, onScreen = Camera:WorldToScreenPoint(realPos)
            if screenGui then screenGui.Enabled = (onScreen and screenPos.Z > 0) end
            
            if onScreen and screenPos.Z > 0 then
                local targetPos = UDim2.fromOffset(screenPos.X, screenPos.Y)
                if smoothEnabled then
                    if currentTween then currentTween:Cancel() end
                    local tweenInfo = TweenInfo.new(getSmoothDuration(), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    currentTween = TweenService:Create(frame, tweenInfo, {Position = targetPos})
                    currentTween:Play()
                else
                    frame.Position = targetPos
                end
            end
        end
        
        function VisualiseDesync:setImageColor(c) 
            imgColor = c 
            if imageLabel then imageLabel.ImageColor3 = c end
        end
        
        function VisualiseDesync:setImageScale(s) 
            imgSize = 100 * s 
            if frame then frame.Size = UDim2.fromOffset(imgSize, imgSize) end
        end
        
        function VisualiseDesync:setStrokeColor(c) 
            strokeColor = c 
            if uiStroke then uiStroke.Color = c end
        end
        
        function VisualiseDesync:setBackgroundColor(c) 
            bgColor = c 
            if frame then frame.BackgroundColor3 = c end
        end
        
        function VisualiseDesync:setSmooth(v) smoothEnabled = v end
        function VisualiseDesync:setSmoothType(t) smoothType = t end
        function VisualiseDesync:setCustomDelay(d) customDelay = d end
        
        local imageLoopAdded = false
        
        function VisualiseDesync:setImageEnabled(e)
            Library.Flags.desync_image_enabled = e
            if e and not imageLoopAdded then
                LoopManager:AddRenderStepped('desync_image', updateImage)
                imageLoopAdded = true
            elseif not e and imageLoopAdded then
                LoopManager:RemoveRenderStepped('desync_image')
                imageLoopAdded = false
                if screenGui then
                    pcall(function() screenGui:Destroy() end)
                    screenGui = nil
                    frame = nil
                    imageLabel = nil
                    uiStroke = nil
                end
            end
        end
        
        local dummyType = 'R6'
        local dummyColor = Color3.fromRGB(255,255,255)
        local dummyTransparency = 0.3
        local dummyMaterial = Enum.Material.Neon
        local dummyModel = nil
        local clonePartMap = {}
        
        local function createR6Dummy()
            local model = Instance.new('Model')
            model.Name = 'DesyncDummy'
            model.Parent = workspace
            
            local parts = {
                {'Head', Vector3.new(2,1,1)},
                {'Torso', Vector3.new(2,2,1)},
                {'Left Arm', Vector3.new(1,2,1)},
                {'Right Arm', Vector3.new(1,2,1)},
                {'Left Leg', Vector3.new(1,2,1)},
                {'Right Leg', Vector3.new(1,2,1)},
            }
            
            for _, p in ipairs(parts) do
                local part = Instance.new('Part')
                part.Name = p[1]
                part.Size = p[2]
                part.Material = dummyMaterial
                part.Color = dummyColor
                part.Transparency = dummyTransparency
                part.CanCollide = false
                part.Anchored = true
                part.CastShadow = false
                part.TopSurface = Enum.SurfaceType.Smooth
                part.BottomSurface = Enum.SurfaceType.Smooth
                part.Parent = model
            end
            return model
        end
        
        local function createCloneDummy()
            local char = LocalPlayer.Character
            if not char then return nil end
            
            local model = Instance.new('Model')
            model.Name = 'DesyncClone'
            model.Parent = workspace
            clonePartMap = {}
            
            local r15Parts = {
                'Head', 'UpperTorso', 'LowerTorso', 'LeftUpperArm', 'LeftLowerArm',
                'LeftHand', 'RightUpperArm', 'RightLowerArm', 'RightHand',
                'LeftUpperLeg', 'LeftLowerLeg', 'LeftFoot', 'RightUpperLeg',
                'RightLowerLeg', 'RightFoot'
            }
            
            for i, pn in ipairs(r15Parts) do
                local orig = char:FindFirstChild(pn)
                if orig and orig:IsA('BasePart') then
                    local clone = orig:Clone()
                    for _, d in pairs(clone:GetDescendants()) do
                        if d:IsA('Motor6D') or d:IsA('Weld') or d:IsA('Attachment') then
                            d:Destroy()
                        end
                    end
                    if clone.Name == 'Head' and clone:IsA('MeshPart') then
                        clone.TextureID = ''
                    end
                    clone.Material = dummyMaterial
                    clone.CanCollide = false
                    clone.Anchored = true
                    clone.CastShadow = false
                    clone.Parent = model
                    clonePartMap[clone] = orig
                end
            end
            return model
        end
        
        local function createDummy()
            if dummyModel then pcall(function() dummyModel:Destroy() end) clonePartMap = {} end
            dummyModel = (dummyType == 'R6' and createR6Dummy()) or (dummyType == 'Clone' and createCloneDummy())
            if dummyModel then
                for _, p in pairs(dummyModel:GetChildren()) do
                    if p:IsA('BasePart') then
                        p.Color = dummyColor
                        p.Transparency = dummyTransparency
                        p.Material = dummyMaterial
                    end
                end
            end
        end
        
        local function destroyDummy()
            if dummyModel then
                pcall(function() dummyModel:Destroy() end)
                dummyModel = nil
                clonePartMap = {}
            end
        end
        
        local function updateDummy()
            if not Library.Flags.desync_dummy_enabled or (Library.Flags.desync_dont_show_if_synced and isSynced()) then
                destroyDummy()
                return
            end
            
            local realPos = getRealPosition()
            if not realPos then
                if dummyModel then
                    for _, p in pairs(dummyModel:GetChildren()) do
                        if p:IsA('BasePart') then p.Transparency = 1 end
                    end
                end
                return
            end
            
            if not dummyModel then
                createDummy()
                if not dummyModel then return end
            end
            
            if dummyType == 'R6' then
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
                local rot = root and root.CFrame or CFrame.new(0,0,0)
                local cf = CFrame.new(realPos) * (rot - rot.Position)
                local t = dummyModel:FindFirstChild('Torso')
                local h = dummyModel:FindFirstChild('Head')
                local la = dummyModel:FindFirstChild('Left Arm')
                local ra = dummyModel:FindFirstChild('Right Arm')
                local ll = dummyModel:FindFirstChild('Left Leg')
                local rl = dummyModel:FindFirstChild('Right Leg')
                
                if t then t.CFrame = cf end
                if h then h.CFrame = cf * CFrame.new(0, 1.5, 0) end
                if la then la.CFrame = cf * CFrame.new(-1.5, 0, 0) end
                if ra then ra.CFrame = cf * CFrame.new(1.5, 0, 0) end
                if ll then ll.CFrame = cf * CFrame.new(-0.5, -2, 0) end
                if rl then rl.CFrame = cf * CFrame.new(0.5, -2, 0) end
            elseif dummyType == 'Clone' then
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
                if not root then return end
                
                for cp, op in pairs(clonePartMap) do
                    if not op or not op.Parent then
                        destroyDummy()
                        createDummy()
                        return
                    end
                end
                
                local off = realPos - root.Position
                for cp, op in pairs(clonePartMap) do
                    cp.CFrame = op.CFrame + off
                    cp.CanCollide = false
                end
            end
        end
        
        local dummyLoopAdded = false
        
        function VisualiseDesync:setDummyEnabled(e)
            Library.Flags.desync_dummy_enabled = e
            if e then
                createDummy()
                if not dummyLoopAdded then
                    LoopManager:AddRenderStepped('desync_dummy', updateDummy)
                    dummyLoopAdded = true
                end
            else
                destroyDummy()
                if dummyLoopAdded then
                    LoopManager:RemoveRenderStepped('desync_dummy')
                    dummyLoopAdded = false
                end
            end
        end
        
        function VisualiseDesync:setDummyType(t)
            dummyType = t
            if Library.Flags.desync_dummy_enabled then
                destroyDummy()
                createDummy()
            end
        end
        
        function VisualiseDesync:setDummyColor(c, a)
            dummyColor = c
            dummyTransparency = a
            if dummyModel then
                for _, p in pairs(dummyModel:GetChildren()) do
                    if p:IsA('BasePart') then
                        p.Color = c
                        p.Transparency = a
                    end
                end
            end
        end
        
        function VisualiseDesync:setDummyMaterial(m)
            dummyMaterial = m
            if dummyModel then
                for _, p in pairs(dummyModel:GetChildren()) do
                    if p:IsA('BasePart') then p.Material = m end
                end
            end
        end
    end
end

-- Follow Target system (using flags)
local FollowTarget = {}

do
    local breakValue = 1e16
    local farCoords = {-1E8, -5E7, -25E6, -1E7, 10000000, 25000000, 50000000, 100000000}
    
    local function getDeepVoid()
        local x = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
        local y = -breakValue
        local z = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
        return Vector3.new(x, y, z)
    end
    
    local state = {
        enabled = false,
        mode = 'Circle',
        radius = 15,
        speed = 1,
        angle = 0,
        lastLoop = 0,
        loopCd = 80,
        wasActive = false,
        lastTarget = nil,
        randomStrengthX = 30,
        randomStrengthY = 30,
        randomStrengthZ = 30,
        resolveEnabled = false,
        resolveMode = 'predict',
        predictionType = 'Custom',
        predictionMultiplier = 2,
        lastTargetPosition = nil,
        lastTargetTime = nil,
        expMinDist = 10,
        expMaxDist = 100,
        expDirection = 1,
        expCurrentDist = 10,
        artRefreshTime = 3,
        artForgiveness = 14.4,
        artOutOfVoidBonus = 13,
        artDistancePenalty = 3.2,
        artMinMatches = 3,
        artPositionLog = {},
        artLastRefresh = 0,
        artFoundPattern = nil,
        experimentalState = 'around',
        experimentalTimer = 0,
        experimentalAroundDuration = 3,
        experimentalVoidDuration = 10,
        experimentalV2State = 'around',
        experimentalV2Timer = 0,
        experimentalV2VoidDuration = 4,
    }
    
    local function isTargetValid()
        if not Targeting.target then return false end
        
        local targetHum = Targeting.target:FindFirstChildOfClass('Humanoid')
        if not targetHum or targetHum.Health <= 0 then return false end
        
        if Library.Flags.follow_target_check_ff ~= false then
            if Targeting.target:FindFirstChild('ForceField') or Targeting.target:FindFirstChild('ForceField_TESTING') then return false end
        end
        
        local targetBodyEffects = Targeting.target:FindFirstChild('BodyEffects')
        if targetBodyEffects then
            local koValue = targetBodyEffects:FindFirstChild('K.O')
            if Library.Flags.follow_target_check_ko ~= false and koValue and koValue.Value == true then return false end
            
            local sDeath = targetBodyEffects:FindFirstChild('SDeath')
            if Library.Flags.follow_target_check_dead ~= false and sDeath and sDeath.Value == true then return false end
            
            local grabbed = targetBodyEffects:FindFirstChild('Grabbed')
            if Library.Flags.follow_target_check_grabbed ~= false and grabbed and grabbed.Value == true then return false end
        end
        
        if not Targeting.target:FindFirstChild('HumanoidRootPart') then return false end
        if not LocalPlayer.Character then return false end
        
        local lpHum = LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
        if not lpHum or lpHum.Health <= 0 then return false end
        
        local tool = nil
        for _, item in ipairs(LocalPlayer.Character:GetChildren()) do
            if item:IsA('Tool') then tool = item break end
        end
        
        return tool ~= nil
    end
    
    local function resolvePredictPosition(targetRoot, targetPos)
        local currentTime = tick()
        
        if state.lastTargetPosition and state.lastTargetTime then
            local deltaTime = currentTime - state.lastTargetTime
            if deltaTime > 0 and deltaTime < 1 then
                local calculatedVelocity = (targetPos - state.lastTargetPosition) / deltaTime
                local velocityMagnitude = calculatedVelocity.Magnitude
                
                if state.predictionType == 'Custom' then
                    if velocityMagnitude > 0.001 then
                        local predictionStrength = state.predictionMultiplier * 0.01
                        local distance = (targetPos - state.lastTargetPosition).Magnitude
                        local predictedDistance = (distance / deltaTime) * predictionStrength
                        local direction = (targetPos - state.lastTargetPosition).Unit
                        targetPos = targetPos + direction * predictedDistance
                    end
                elseif state.predictionType == 'Regular' then
                    if velocityMagnitude > 0.001 then
                        local predictionStrength = state.predictionMultiplier * 0.01
                        targetPos = targetPos + (calculatedVelocity * predictionStrength)
                    end
                end
            end
        end
        
        state.lastTargetPosition = targetRoot.Position
        state.lastTargetTime = currentTime
        return targetPos
    end
    
    local function resolveExponentialPosition(targetRoot, targetPos)
        local step = (state.expMaxDist - state.expMinDist) / 10
        state.expCurrentDist = state.expCurrentDist + (step * state.expDirection)
        
        if state.expCurrentDist >= state.expMaxDist then
            state.expCurrentDist = state.expMaxDist
            state.expDirection = -1
        elseif state.expCurrentDist <= state.expMinDist then
            state.expCurrentDist = state.expMinDist
            state.expDirection = 1
        end
        
        local upVector = targetRoot.CFrame.UpVector
        return targetPos + (upVector * state.expCurrentDist)
    end
    
    local function resolveArtificalPosition(targetRoot, targetPos)
        local now = tick()
        if now - state.artLastRefresh >= state.artRefreshTime then
            state.artPositionLog = {}
            state.artFoundPattern = nil
            state.artLastRefresh = now
        end
        
        local forgiveness = state.artForgiveness
        local distFromCenter = math.abs(targetPos.X) + math.abs(targetPos.Z)
        local isOutOfVoid = distFromCenter < 7000
        
        if isOutOfVoid then
            forgiveness = forgiveness + state.artOutOfVoidBonus
        end
        
        local myChar = LocalPlayer.Character
        if myChar and myChar:FindFirstChild('HumanoidRootPart') then
            local dist = (targetPos - myChar.HumanoidRootPart.Position).Magnitude
            local penalty = (dist / 100) * state.artDistancePenalty
            forgiveness = math.clamp(forgiveness - penalty, 1, 1000)
        end
        
        table.insert(state.artPositionLog, {pos = targetPos, time = now})
        
        if #state.artPositionLog > 500 then
            local newLog = {}
            for i = #state.artPositionLog - 300, #state.artPositionLog do
                table.insert(newLog, state.artPositionLog[i])
            end
            state.artPositionLog = newLog
        end
        
        local matches = {}
        for i = 1, #state.artPositionLog do
            local p1 = state.artPositionLog[i].pos
            local count = 0
            local sum = Vector3.new(0,0,0)
            
            for j = 1, #state.artPositionLog do
                if i ~= j then
                    local p2 = state.artPositionLog[j].pos
                    local diff = (p1 - p2).Magnitude
                    if diff <= forgiveness then
                        count = count + 1
                        sum = sum + p2
                    end
                end
            end
            
            if count >= state.artMinMatches then
                table.insert(matches, {pos = (sum + p1) / (count + 1), count = count})
            end
        end
        
        local best = nil
        for _, m in ipairs(matches) do
            if not best or m.count > best.count then best = m end
        end
        
        if best then
            state.artFoundPattern = best.pos
            return best.pos
        end
        
        return getDeepVoid()
    end
    
    local function getResolvedPosition(targetRoot)
        local basePos = targetRoot.Position
        if not state.resolveEnabled then return basePos end
        
        if state.resolveMode == 'predict' then
            return resolvePredictPosition(targetRoot, basePos)
        elseif state.resolveMode == 'exponential' then
            return resolveExponentialPosition(targetRoot, basePos)
        elseif state.resolveMode == 'artifical' then
            return resolveArtificalPosition(targetRoot, basePos)
        end
        return basePos
    end
    
    local function moveToPosition(pos)
        if Desync then
            if Desync.moveTo then
                Desync:moveTo(pos.X, pos.Y, pos.Z, 50, 'followTarget')
            elseif Desync.moveDesyncTo then
                Desync:moveDesyncTo(pos.X, pos.Y, pos.Z, 50, 'followTarget')
            end
        end
    end
    
    LoopManager:AddHeartbeat('follow_target', function()
        if not Library.Flags.follow_target_enabled then
            if state.wasActive then
                state.wasActive = false
                state.lastTarget = nil
                if Desync and Desync.syncWithPlayer then
                    Desync:syncWithPlayer(Cache.getPing() + 0.05)
                end
            end
            return
        end
        
        if not isTargetValid() then
            if state.wasActive then
                state.wasActive = false
                state.lastTarget = nil
                if Desync and Desync.syncWithPlayer then
                    Desync:syncWithPlayer(Cache.getPing() + 0.05)
                end
            end
            return
        end
        
        if state.lastTarget ~= Targeting.target then
            state.lastTarget = Targeting.target
            state.angle = 0
            state.expCurrentDist = state.expMinDist
            state.expDirection = 1
            state.artPositionLog = {}
            state.artFoundPattern = nil
            state.artLastRefresh = tick()
        end
        
        state.wasActive = true
        
        local targetRoot = Targeting.target:FindFirstChild('HumanoidRootPart')
        if not targetRoot then return end
        
        local targetPos = getResolvedPosition(targetRoot)
        
        if state.mode == 'Random' then
            local offsetX = (math.random() - 0.5) * 2 * state.randomStrengthX
            local offsetY = (math.random() - 0.5) * 2 * state.randomStrengthY
            local offsetZ = (math.random() - 0.5) * 2 * state.randomStrengthZ
            moveToPosition(Vector3.new(targetPos.X + offsetX, targetPos.Y + offsetY, targetPos.Z + offsetZ))
            return
        end
        
        if state.mode == 'Experimental' then
            state.experimentalTimer = state.experimentalTimer + 0.016
            
            if state.experimentalState == 'around' and state.experimentalTimer >= state.experimentalAroundDuration then
                state.experimentalState = 'void'
                state.experimentalTimer = 0
            elseif state.experimentalState == 'void' and state.experimentalTimer >= state.experimentalVoidDuration then
                state.experimentalState = 'around'
                state.experimentalTimer = 0
            end
            
            if state.experimentalState == 'around' then
                local offsetX = (math.random() - 0.5) * 2 * state.randomStrengthX
                local offsetY = (math.random() - 0.5) * 2 * state.randomStrengthY
                local offsetZ = (math.random() - 0.5) * 2 * state.randomStrengthZ
                moveToPosition(Vector3.new(targetPos.X + offsetX, targetPos.Y + offsetY, targetPos.Z + offsetZ))
            else
                local huge = 10000000000000000
                moveToPosition(Vector3.new(targetPos.X + (math.random() - 0.5) * 2 * huge, targetPos.Y + (math.random() - 0.5) * 2 * huge, targetPos.Z + (math.random() - 0.5) * 2 * huge))
            end
            return
        end
        
        if state.mode == 'Experimental v2' then
            local aroundDuration = Cache.getPing() + 0.02
            state.experimentalV2Timer = state.experimentalV2Timer + 0.016
            
            if state.experimentalV2State == 'around' and state.experimentalV2Timer >= aroundDuration then
                state.experimentalV2State = 'void'
                state.experimentalV2Timer = 0
            elseif state.experimentalV2State == 'void' and state.experimentalV2Timer >= state.experimentalV2VoidDuration then
                state.experimentalV2State = 'around'
                state.experimentalV2Timer = 0
            end
            
            if state.experimentalV2State == 'around' then
                local offsetX = (math.random() - 0.5) * 2 * state.randomStrengthX
                local offsetY = (math.random() - 0.5) * 2 * state.randomStrengthY
                local offsetZ = (math.random() - 0.5) * 2 * state.randomStrengthZ
                moveToPosition(Vector3.new(targetPos.X + offsetX, targetPos.Y + offsetY, targetPos.Z + offsetZ))
            else
                local huge = 10000000000000000
                moveToPosition(Vector3.new(targetPos.X + (math.random() - 0.5) * 2 * huge, targetPos.Y + (math.random() - 0.5) * 2 * huge, targetPos.Z + (math.random() - 0.5) * 2 * huge))
            end
            return
        end
        
        local now = tick()
        if now - state.lastLoop < state.loopCd / 1000 then return end
        state.lastLoop = now
        
        if state.mode == 'Circle' then
            state.angle = state.angle + (state.speed * 0.016 * 4 * 10 * 5)
            if state.angle >= 360 then state.angle = state.angle - 360 end
            
            local angleRad = math.rad(state.angle)
            moveToPosition(Vector3.new(targetPos.X + math.cos(angleRad) * state.radius, targetPos.Y, targetPos.Z + math.sin(angleRad) * state.radius))
        elseif state.mode == 'SpiralY' then
            state.angle = state.angle + (state.speed * 0.016 * 4 * 10 * 5)
            if state.angle >= 360 then state.angle = state.angle - 360 end
            
            local angleRad = math.rad(state.angle)
            moveToPosition(Vector3.new(targetPos.X + math.cos(angleRad) * state.radius, targetPos.Y + math.sin(angleRad) * state.radius, targetPos.Z))
        end
    end)
    
    function FollowTarget:setEnabled(e)
        state.enabled = e
        Library.Flags.follow_target_enabled = e
    end
    function FollowTarget:setMode(m) state.mode = m; state.angle = 0 end
    function FollowTarget:setRadius(r) state.radius = r end
    function FollowTarget:setSpeed(s) state.speed = s end
    function FollowTarget:setRandomStrengthX(v) state.randomStrengthX = v end
    function FollowTarget:setRandomStrengthY(v) state.randomStrengthY = v end
    function FollowTarget:setRandomStrengthZ(v) state.randomStrengthZ = v end
    function FollowTarget:setResolveEnabled(v) state.resolveEnabled = v end
    function FollowTarget:setResolveMode(m) state.resolveMode = m end
    function FollowTarget:setPredictionType(t) state.predictionType = t end
    function FollowTarget:setPredictionMultiplier(m) state.predictionMultiplier = m end
    function FollowTarget:setExpMinDist(v) state.expMinDist = tonumber(v) or 10; state.expCurrentDist = state.expMinDist end
    function FollowTarget:setExpMaxDist(v) state.expMaxDist = tonumber(v) or 100 end
    function FollowTarget:setArtRefreshTime(v) state.artRefreshTime = v end
    function FollowTarget:setArtForgiveness(v) state.artForgiveness = v end
    function FollowTarget:setArtOutOfVoidBonus(v) state.artOutOfVoidBonus = v end
    function FollowTarget:setArtDistancePenalty(v) state.artDistancePenalty = v end
    function FollowTarget:setArtMinMatches(v) state.artMinMatches = v end
end

-- Void Hide system (using flags)
local VoidHide = {}

do
    local state = {
        enabled = false,
        pattern = 'Deep Void',
        direction = '-Y',
        depthMultiplier = 1,
        switchSpeed = 0.05,
        lastSwitch = 0,
        deepVoidPositions = {},
        breakNullPositions = {},
        currentDeepVoidIndex = 1,
        currentBreakNullIndex = 1,
        syncDelayTimer = 0,
        syncDelayActive = false,
        syncDelayDuration = 0,
        wasSynced = false,
    }
    
    local function generateDeepVoidPositions()
        local positions = {}
        local deepValues = {-2E6, -5E6, -1E7, -2E7, -5E7}
        local farCoords = {-1E6, -5E5, -25E4, -1E5, 100000, 250000, 500000, 1000000}
        
        for i = 1, 20 do
            local x, y, z
            
            if state.direction == '+Y' then
                x = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                y = -deepValues[math.random(1, #deepValues)] + math.random(-1E4, 10000)
                z = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
            elseif state.direction == '-Y' then
                x = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                y = deepValues[math.random(1, #deepValues)] + math.random(-1E4, 10000)
                z = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
            elseif state.direction == '+Z' then
                x = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                y = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                z = -deepValues[math.random(1, #deepValues)] + math.random(-1E4, 10000)
            elseif state.direction == '-Z' then
                x = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                y = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                z = deepValues[math.random(1, #deepValues)] + math.random(-1E4, 10000)
            elseif state.direction == '+X' then
                x = -deepValues[math.random(1, #deepValues)] + math.random(-1E4, 10000)
                y = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                z = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
            elseif state.direction == '-X' then
                x = deepValues[math.random(1, #deepValues)] + math.random(-1E4, 10000)
                y = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                z = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
            end
            
            table.insert(positions, {x = x, y = y, z = z})
        end
        
        if state.direction == '+Y' then
            table.insert(positions, {x = 0, y = 8000000, z = 0})
            table.insert(positions, {x = 750000, y = 7500000, z = 750000})
            table.insert(positions, {x = -750000, y = 7500000, z = -750000})
        elseif state.direction == '-Y' then
            table.insert(positions, {x = 0, y = -5000000, z = 0})
            table.insert(positions, {x = 750000, y = -7500000, z = 750000})
            table.insert(positions, {x = -750000, y = -7500000, z = -750000})
        elseif state.direction == '+Z' then
            table.insert(positions, {x = 0, y = 0, z = 8000000})
            table.insert(positions, {x = 750000, y = 750000, z = 7500000})
            table.insert(positions, {x = -750000, y = -750000, z = 7500000})
        elseif state.direction == '-Z' then
            table.insert(positions, {x = 0, y = 0, z = -5000000})
            table.insert(positions, {x = 750000, y = 750000, z = -7500000})
            table.insert(positions, {x = -750000, y = -750000, z = -7500000})
        elseif state.direction == '+X' then
            table.insert(positions, {x = 8000000, y = 0, z = 0})
            table.insert(positions, {x = 7500000, y = 750000, z = 750000})
            table.insert(positions, {x = 7500000, y = -750000, z = -750000})
        elseif state.direction == '-X' then
            table.insert(positions, {x = -5000000, y = 0, z = 0})
            table.insert(positions, {x = -7500000, y = 750000, z = 750000})
            table.insert(positions, {x = -7500000, y = -750000, z = -750000})
        end
        
        return positions
    end
    
    local function generateBreakNullPositions()
        local positions = {}
        local breakValue = 1e16
        local farCoords = {-1E8, -5E7, -25E6, -1E7, 10000000, 25000000, 50000000, 100000000}
        
        for i = 1, 20 do
            local x, y, z
            
            if state.direction == '+Y' then
                x = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                y = breakValue
                z = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
            elseif state.direction == '-Y' then
                x = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                y = -breakValue
                z = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
            elseif state.direction == '+Z' then
                x = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                y = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                z = breakValue
            elseif state.direction == '-Z' then
                x = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                y = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                z = -breakValue
            elseif state.direction == '+X' then
                x = breakValue
                y = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                z = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
            elseif state.direction == '-X' then
                x = -breakValue
                y = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                z = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
            end
            
            table.insert(positions, {x = x, y = y, z = z})
        end
        
        if state.direction == '+Y' then
            table.insert(positions, {x = 0, y = 1e16, z = 0})
            table.insert(positions, {x = 75000000, y = 1e16, z = 75000000})
            table.insert(positions, {x = -75000000, y = 1e16, z = -75000000})
        elseif state.direction == '-Y' then
            table.insert(positions, {x = 0, y = -1E16, z = 0})
            table.insert(positions, {x = 75000000, y = -1E16, z = 75000000})
            table.insert(positions, {x = -75000000, y = -1E16, z = -75000000})
        elseif state.direction == '+Z' then
            table.insert(positions, {x = 0, y = 0, z = 1e16})
            table.insert(positions, {x = 75000000, y = 75000000, z = 1e16})
            table.insert(positions, {x = -75000000, y = -75000000, z = 1e16})
        elseif state.direction == '-Z' then
            table.insert(positions, {x = 0, y = 0, z = -1E16})
            table.insert(positions, {x = 75000000, y = 75000000, z = -1E16})
            table.insert(positions, {x = -75000000, y = -75000000, z = -1E16})
        elseif state.direction == '+X' then
            table.insert(positions, {x = 1e16, y = 0, z = 0})
            table.insert(positions, {x = 1e16, y = 75000000, z = 75000000})
            table.insert(positions, {x = 1e16, y = -75000000, z = -75000000})
        elseif state.direction == '-X' then
            table.insert(positions, {x = -1E16, y = 0, z = 0})
            table.insert(positions, {x = -1E16, y = 75000000, z = 75000000})
            table.insert(positions, {x = -1E16, y = -75000000, z = -75000000})
        end
        
        return positions
    end
    
    LoopManager:AddHeartbeat('void_hide', function()
        if not Library.Flags.void_hide_enabled then
            if not state.wasSynced then
                if state.syncDelayActive then
                    state.syncDelayActive = false
                    state.syncDelayTimer = 0
                end
                if Desync and Desync.syncWithPlayer then
                    local playerPing = Cache.getPing()
                    Desync:syncWithPlayer(playerPing + 0.05)
                end
                state.wasSynced = true
            end
            return
        end
        
        state.wasSynced = false
        
        if AutoStomp and AutoStomp:isStompingInProgress() then return end
        
        if state.syncDelayActive then
            state.syncDelayTimer = state.syncDelayTimer + 0.016
            if state.syncDelayTimer >= state.syncDelayDuration then
                state.syncDelayActive = false
                state.syncDelayTimer = 0
            end
            return
        end
        
        local x, y, z
        
        if state.pattern == 'Deep Void' then
            local currentTime = tick()
            if currentTime - state.lastSwitch < state.switchSpeed then return end
            if #state.deepVoidPositions == 0 then
                state.deepVoidPositions = generateDeepVoidPositions()
            end
            
            state.currentDeepVoidIndex = (state.currentDeepVoidIndex % #state.deepVoidPositions) + 1
            local base = state.deepVoidPositions[state.currentDeepVoidIndex]
            
            x = base.x * state.depthMultiplier
            y = base.y * state.depthMultiplier
            z = base.z * state.depthMultiplier
            state.lastSwitch = currentTime
        elseif state.pattern == 'Break Null' then
            local currentTime = tick()
            if currentTime - state.lastSwitch < state.switchSpeed then return end
            if #state.breakNullPositions == 0 then
                state.breakNullPositions = generateBreakNullPositions()
            end
            
            state.currentBreakNullIndex = (state.currentBreakNullIndex % #state.breakNullPositions) + 1
            local base = state.breakNullPositions[state.currentBreakNullIndex]
            
            x = base.x
            y = base.y
            z = base.z
            state.lastSwitch = currentTime
        elseif state.pattern == 'World Random' then
            x = (math.random() - 0.5) * 2 * 10000000000000000
            y = (math.random() - 0.5) * 2 * 10000000000000000
            z = (math.random() - 0.5) * 2 * 10000000000000000
        end
        
        if Desync then
            if Desync.moveTo then
                Desync:moveTo(x, y, z, 30, 'voidHide')
            elseif Desync.moveDesyncTo then
                Desync:moveDesyncTo(x, y, z, 30, 'voidHide')
            end
        end
    end)
    
    function VoidHide:setEnabled(enabled)
        state.enabled = enabled
        Library.Flags.void_hide_enabled = enabled
        if enabled then
            self:startLoop()
        else
            self:stopLoop()
        end
    end
    
    function VoidHide:setPattern(pattern)
        state.pattern = pattern
        if pattern == 'Deep Void' then
            state.deepVoidPositions = generateDeepVoidPositions()
            state.currentDeepVoidIndex = 1
        elseif pattern == 'Break Null' then
            state.breakNullPositions = generateBreakNullPositions()
            state.currentBreakNullIndex = 1
        end
        state.lastSwitch = 0
    end
    
    function VoidHide:setDirection(direction)
        state.direction = direction
        state.deepVoidPositions = generateDeepVoidPositions()
        state.breakNullPositions = generateBreakNullPositions()
        state.currentDeepVoidIndex = 1
        state.currentBreakNullIndex = 1
        state.lastSwitch = 0
    end
    
    function VoidHide:setSwitchSpeed(speed) state.switchSpeed = speed end
    function VoidHide:setDepthMultiplier(multiplier) state.depthMultiplier = multiplier end
    function VoidHide:startSyncDelay(playerPing)
        state.syncDelayDuration = playerPing + 0.03
        state.syncDelayTimer = 0
        state.syncDelayActive = true
    end
    function VoidHide:isSyncDelayActive() return state.syncDelayActive end
    
    function VoidHide:startLoop() end
    function VoidHide:stopLoop() end
end

-- Void Reload system (using flags)
local VoidReload = {}

do
    local mainEvent = Cache.getMainEvent()
    local state = {
        enabled = false,
        breakDirection = '-Y',
        breakSwitchSpeed = 0.05,
        breakNullPositions = {},
        currentBreakNullIndex = 1,
        lastBreakNullSwitch = 0,
        wasInVoid = false,
    }
    
    local function generateBreakNullPositions()
        local positions = {}
        local breakValue = 1e16
        local farCoords = {-1E8, -5E7, -25E6, -1E7, 10000000, 25000000, 50000000, 100000000}
        
        for i = 1, 20 do
            local x, y, z
            
            if state.breakDirection == '+Y' then
                x = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                y = breakValue
                z = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
            elseif state.breakDirection == '-Y' then
                x = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                y = -breakValue
                z = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
            elseif state.breakDirection == '+Z' then
                x = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                y = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                z = breakValue
            elseif state.breakDirection == '-Z' then
                x = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                y = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                z = -breakValue
            elseif state.breakDirection == '+X' then
                x = breakValue
                y = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                z = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
            elseif state.breakDirection == '-X' then
                x = -breakValue
                y = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
                z = farCoords[math.random(1, #farCoords)] + math.random(-1E4, 10000)
            end
            
            table.insert(positions, {x = x, y = y, z = z})
        end
        
        if state.breakDirection == '+Y' then
            table.insert(positions, {x = 0, y = 1e16, z = 0})
            table.insert(positions, {x = 75000000, y = 1e16, z = 75000000})
            table.insert(positions, {x = -75000000, y = 1e16, z = -75000000})
        elseif state.breakDirection == '-Y' then
            table.insert(positions, {x = 0, y = -1E16, z = 0})
            table.insert(positions, {x = 75000000, y = -1E16, z = 75000000})
            table.insert(positions, {x = -75000000, y = -1E16, z = -75000000})
        elseif state.breakDirection == '+Z' then
            table.insert(positions, {x = 0, y = 0, z = 1e16})
            table.insert(positions, {x = 75000000, y = 75000000, z = 1e16})
            table.insert(positions, {x = -75000000, y = -75000000, z = 1e16})
        elseif state.breakDirection == '-Z' then
            table.insert(positions, {x = 0, y = 0, z = -1E16})
            table.insert(positions, {x = 75000000, y = 75000000, z = -1E16})
            table.insert(positions, {x = -75000000, y = -75000000, z = -1E16})
        elseif state.breakDirection == '+X' then
            table.insert(positions, {x = 1e16, y = 0, z = 0})
            table.insert(positions, {x = 1e16, y = 75000000, z = 75000000})
            table.insert(positions, {x = 1e16, y = -75000000, z = -75000000})
        elseif state.breakDirection == '-X' then
            table.insert(positions, {x = -1E16, y = 0, z = 0})
            table.insert(positions, {x = -1E16, y = 75000000, z = 75000000})
            table.insert(positions, {x = -1E16, y = -75000000, z = -75000000})
        end
        
        return positions
    end
    
    local function isReloading()
        if not LocalPlayer.Character then return false end
        local bodyEffects = LocalPlayer.Character:FindFirstChild('BodyEffects')
        if not bodyEffects then return false end
        local reloadValue = bodyEffects:FindFirstChild('Reload')
        return reloadValue and reloadValue.Value == true
    end
    
    local function needsReload()
        if not LocalPlayer.Character then return false end
        for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA('Tool') and tool:FindFirstChild('Ammo') and tool.Ammo.Value <= 0 then
                return true
            end
        end
        return false
    end
    
    local function reloadAllTools()
        if not LocalPlayer.Character then return end
        for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA('Tool') and tool:FindFirstChild('Ammo') and tool.Ammo.Value <= 0 then
                pcall(function()
                    if mainEvent then
                        mainEvent:FireServer('Reload', tool)
                    end
                end)
            end
        end
    end
    
    function VoidReload:setEnabled(enabled)
        state.enabled = enabled
        Library.Flags.void_reload_enabled = enabled
        if enabled then
            self:startLoop()
        else
            self:stopLoop()
        end
    end
    
    function VoidReload:setBreakDirection(direction)
        state.breakDirection = direction
        state.breakNullPositions = generateBreakNullPositions()
        state.currentBreakNullIndex = 1
        state.lastBreakNullSwitch = 0
    end
    
    function VoidReload:setBreakSwitchSpeed(speed) state.breakSwitchSpeed = speed end
    function VoidReload:isInVoid() return state.wasInVoid end
    
    do
        local function voidReloadLoop()
            if not Library.Flags.void_reload_enabled then return end
            if not (isReloading() or needsReload()) then
                if state.wasInVoid then
                    if Desync and Desync.syncWithPlayer then
                        Desync:syncWithPlayer()
                    end
                    state.wasInVoid = false
                end
                return
            end
            
            state.wasInVoid = true
            
            local currentTime = tick()
            if currentTime - state.lastBreakNullSwitch < state.breakSwitchSpeed then return end
            if #state.breakNullPositions == 0 then
                state.breakNullPositions = generateBreakNullPositions()
            end
            
            state.currentBreakNullIndex = (state.currentBreakNullIndex % #state.breakNullPositions) + 1
            local base = state.breakNullPositions[state.currentBreakNullIndex]
            state.lastBreakNullSwitch = currentTime
            
            if Desync and Desync.moveTo then
                Desync:moveTo(base.x, base.y, base.z, 60, 'voidReload')
            end
            
            reloadAllTools()
        end
        
        local conn = nil
        
        function VoidReload:startLoop()
            if conn then return end
            conn = LoopManager:AddHeartbeat('void_reload_main', voidReloadLoop)
        end
        
        function VoidReload:stopLoop()
            if conn then
                LoopManager:RemoveHeartbeat('void_reload_main')
                conn = nil
            end
            if state.wasInVoid then
                if Desync and Desync.syncWithPlayer then
                    Desync:syncWithPlayer()
                end
                state.wasInVoid = false
            end
        end
    end
end

-- Network Desync system (using flags)
local NetworkDesync = {}

do
    local mode = 'Aggressive'
    local canSetHidden = sethiddenproperty ~= nil
    
    LoopManager:AddHeartbeat('network_desync', function()
        if not Library.Flags.network_desync_enabled then return end
        if not canSetHidden then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local hrp = char:FindFirstChild('HumanoidRootPart')
        if not hrp then return end
        
        if mode == 'Slow' then
            pcall(function() sethiddenproperty(hrp, 'NetworkIsSleeping', true) end)
            task.wait(0.1)
            pcall(function() sethiddenproperty(hrp, 'NetworkIsSleeping', false) end)
        else
            pcall(function() sethiddenproperty(hrp, 'NetworkIsSleeping', true) end)
            RunService.PostSimulation:Wait()
            pcall(function() sethiddenproperty(hrp, 'NetworkIsSleeping', false) end)
        end
    end)
    
    function NetworkDesync:setMode(m) mode = m end
end

-- Ultra Instinct system (using flags)
local UltraInstinct = {}

do
    local function setupBlock(plr)
        task.spawn(function()
            local be = plr:WaitForChild('BodyEffects', 5)
            if not be then return end
            
            local attacking = be:WaitForChild('Attacking', 5)
            if not attacking then return end
            
            attacking.Changed:Connect(function()
                if not Library.Flags.ultra_instinct_enabled then return end
                
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild('HumanoidRootPart') then return end
                
                local hrp = plr:FindFirstChild('HumanoidRootPart')
                if not hrp then return end
                
                if attacking.Value and (hrp.Position - char.HumanoidRootPart.Position).Magnitude <= 10 then
                    local mainEvent = Cache.getMainEvent()
                    if mainEvent then
                        repeat
                            mainEvent:FireServer('Block', true)
                            task.wait()
                        until not attacking.Value or not Library.Flags.ultra_instinct_enabled
                        mainEvent:FireServer('Block', false)
                    end
                end
            end)
        end)
    end
    
    local function initializeUltraInstinct()
        local wPlayers = workspace:FindFirstChild('Players')
        if not wPlayers then return end
        
        for _, plr in pairs(wPlayers:GetChildren()) do
            setupBlock(plr)
        end
        
        wPlayers.ChildAdded:Connect(setupBlock)
    end
    
    function UltraInstinct:setEnabled(enabled)
        Library.Flags.ultra_instinct_enabled = enabled
        if enabled then
            initializeUltraInstinct()
        end
    end
end

-- Fake Position system (using flags)
local FakePos = {}

do
    function FakePos:setEnabled(enabled)
        Library.Flags.fakepos_enabled = enabled
        
        if enabled then
            pcall(function()
                task.wait(1)
                if LocalPlayer and LocalPlayer.Kill then
                    replicatesignal(LocalPlayer.Kill)
                end
                task.wait(0.04)
                setfflag('NextGenReplicatorEnabledWrite4', 'false')
                setfflag('NextGenReplicatorEnabledWrite4', 'false')
                setfflag('NextGenReplicatorEnabledWrite4', 'false')
                if LocalPlayer and LocalPlayer.Kill then
                    replicatesignal(LocalPlayer.Kill)
                end
                task.wait(0.04)
                setfflag('NextGenReplicatorEnabledWrite4', 'true')
                task.wait(0.04)
                if LocalPlayer and LocalPlayer.Kill then
                    replicatesignal(LocalPlayer.Kill)
                end
            end)
        else
            pcall(function()
                task.wait(1)
                if LocalPlayer and LocalPlayer.Kill then
                    replicatesignal(LocalPlayer.Kill)
                end
                task.wait(0.04)
                setfflag('NextGenReplicatorEnabledWrite4', 'false')
                setfflag('NextGenReplicatorEnabledWrite4', 'false')
                setfflag('NextGenReplicatorEnabledWrite4', 'false')
                if LocalPlayer and LocalPlayer.Kill then
                    replicatesignal(LocalPlayer.Kill)
                end
            end)
        end
    end
end

-- Anti-Stomp system (using flags)
local AntiStomp = {}

do
    local stompCooldown = 0.5
    local lastStompDetected = 0
    
    local function onStomp(plr)
        if not Library.Flags.anti_stomp_enabled then return end
        if plr == LocalPlayer then return end
        
        local now = tick()
        if now - lastStompDetected < stompCooldown then return end
        lastStompDetected = now
        
        local distance = 10
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart') and
           plr.Character and plr.Character:FindFirstChild('HumanoidRootPart') then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if dist <= distance then
                local dir = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Unit
                local escapePos = LocalPlayer.Character.HumanoidRootPart.Position + dir * 30
                if Desync and Desync.moveTo then
                    Desync:moveTo(escapePos.X, escapePos.Y, escapePos.Z, 90, 'antiStomp')
                end
            end
        end
    end
    
    local mainEvent = Cache.getMainEvent()
    if mainEvent then
        mainEvent.OnClientEvent:Connect(function(...)
            local args = {...}
            if args[1] == 'Stomp' then
                onStomp(Players:GetPlayers()[1])
            end
        end)
    end
    
    function AntiStomp:setEnabled(enabled)
        Library.Flags.anti_stomp_enabled = enabled
    end
    
    function AntiStomp:setCooldown(ms)
        stompCooldown = ms / 1000
    end
end

-- Auto Stomp system (using flags)
local AutoStomp = {
    state = {
        enabled = false,
        stompHeight = 2.7,
        wasStomping = false,
        lastStompTime = 0,
        lastSyncTime = 0,
        syncDelay = 0.1,
    }
}

do
    local function canSyncNow()
        if AutoStomp.state.lastStompTime == 0 then return true end
        local currentTime = tick()
        local timeSinceLastStomp = currentTime - AutoStomp.state.lastStompTime
        local requiredDelay = Cache.getPing()
        return timeSinceLastStomp >= requiredDelay
    end
    
    local function canContinueAfterSync()
        if AutoStomp.state.lastSyncTime == 0 then return true end
        local currentTime = tick()
        local timeSinceSync = currentTime - AutoStomp.state.lastSyncTime
        local requiredDelay = (Cache.getPing() + 0.04)
        return timeSinceSync >= requiredDelay
    end
    
    local function canStomp()
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then return false end
        if LocalPlayer.Character:FindFirstChild('SDeath') then return false end
        
        local myBodyEffects = LocalPlayer.Character:FindFirstChild('BodyEffects')
        if myBodyEffects then
            if myBodyEffects:FindFirstChild('Reload') and myBodyEffects.Reload.Value then return false end
            if myBodyEffects:FindFirstChild('Attacking') and myBodyEffects.Attacking.Value then return false end
        end
        return true
    end
    
    local function shouldStompTarget()
        if not Targeting.target then return false end
        
        local bodyEffects = Targeting.target:FindFirstChild('BodyEffects')
        if bodyEffects then
            local sDeathValue = bodyEffects:FindFirstChild('SDeath')
            if sDeathValue and sDeathValue.Value == true then return false end
        end
        
        if Library.Flags.follow_target_check_grabbed ~= false then
            if Targeting.target:FindFirstChild('GRABBING_CONSTRAINT') then return false end
        end
        
        if bodyEffects then
            local koValue = bodyEffects:FindFirstChild('K.O')
            if koValue and koValue.Value == true then return true end
        end
        return false
    end
    
    function AutoStomp:setEnabled(enabled)
        self.state.enabled = enabled
        Library.Flags.auto_stomp_enabled = enabled
        if enabled then
            self:startLoop()
        else
            self:stopLoop()
        end
    end
    
    function AutoStomp:setStompHeight(height)
        self.state.stompHeight = height
    end
    
    function AutoStomp:shouldExecuteStomp()
        if not Library.Flags.auto_stomp_enabled then return false end
        if not canStomp() then return false end
        if not shouldStompTarget() then
            return false
        end
        
        local targetUpperTorso = Targeting.target and Targeting.target:FindFirstChild('UpperTorso')
        if not targetUpperTorso then return false end
        return true
    end
    
    function AutoStomp:executeStomp()
        if not self:shouldExecuteStomp() then return false end
        
        local targetUpperTorso = Targeting.target:FindFirstChild('UpperTorso')
        if not targetUpperTorso then return false end
        
        local stompPosition = targetUpperTorso.Position + Vector3.new(0, self.state.stompHeight, 0)
        
        if Desync then
            if Desync.moveTo then
                Desync:moveTo(stompPosition.X, stompPosition.Y, stompPosition.Z, 80, 'autoStomp')
            elseif Desync.moveDesyncTo then
                Desync:moveDesyncTo(stompPosition.X, stompPosition.Y, stompPosition.Z, 80, 'autoStomp')
            end
        end
        
        self.state.wasStomping = true
        
        pcall(function()
            local mainEvent = Cache.getMainEvent()
            if mainEvent then
                mainEvent:FireServer('Stomp')
                self.state.lastStompTime = tick()
            end
        end)
        
        return true
    end
    
    function AutoStomp:onStompFinished()
        if self.state.wasStomping and canSyncNow() then
            if Desync and Desync.syncWithPlayer then
                local ping = Cache.getPing()
                Desync:syncWithPlayer(ping + 0.05)
            end
            self.state.wasStomping = false
            self.state.lastStompTime = 0
            self.state.lastSyncTime = tick()
        end
    end
    
    function AutoStomp:isStompingInProgress()
        return self.state.wasStomping
    end
    
    function AutoStomp:canContinueDesync()
        return canSyncNow() and canContinueAfterSync()
    end
    
    do
        local function autoStompLoop()
            if not Library.Flags.auto_stomp_enabled then return end
            if not canStomp() then
                if AutoStomp.state.wasStomping and canSyncNow() then
                    if Desync and Desync.syncWithPlayer then
                        local ping = Cache.getPing()
                        Desync:syncWithPlayer(ping + 0.05)
                    end
                    AutoStomp.state.wasStomping = false
                    AutoStomp.state.lastStompTime = 0
                    AutoStomp.state.lastSyncTime = tick()
                end
                return
            end
            
            local shouldStomp = shouldStompTarget()
            if not shouldStomp then
                if AutoStomp.state.wasStomping and canSyncNow() then
                    if Desync and Desync.syncWithPlayer then
                        local ping = Cache.getPing()
                        Desync:syncWithPlayer(ping + 0.05)
                    end
                    AutoStomp.state.wasStomping = false
                    AutoStomp.state.lastStompTime = 0
                    AutoStomp.state.lastSyncTime = tick()
                end
                return
            end
            
            local targetUpperTorso = Targeting.target:FindFirstChild('UpperTorso')
            if not targetUpperTorso then
                if AutoStomp.state.wasStomping and canSyncNow() then
                    if Desync and Desync.syncWithPlayer then
                        local ping = Cache.getPing()
                        Desync:syncWithPlayer(ping + 0.05)
                    end
                    AutoStomp.state.wasStomping = false
                    AutoStomp.state.lastStompTime = 0
                    AutoStomp.state.lastSyncTime = tick()
                end
                return
            end
            
            local stompPosition = targetUpperTorso.Position + Vector3.new(0, AutoStomp.state.stompHeight, 0)
            
            if Desync and Desync.moveTo then
                Desync:moveTo(stompPosition.X, stompPosition.Y, stompPosition.Z, 80, 'autoStomp')
            end
            
            AutoStomp.state.wasStomping = true
            
            pcall(function()
                local mainEvent = Cache.getMainEvent()
                if mainEvent then
                    mainEvent:FireServer('Stomp')
                    AutoStomp.state.lastStompTime = tick()
                end
            end)
        end
        
        local conn = nil
        
        function AutoStomp:startLoop()
            if conn then return end
            conn = LoopManager:AddHeartbeat('auto_stomp_main', autoStompLoop)
        end
        
        function AutoStomp:stopLoop()
            if conn then
                LoopManager:RemoveHeartbeat('auto_stomp_main')
                conn = nil
            end
            if Desync and Desync.syncWithPlayer then
                local ping = Cache.getPing()
                Desync:syncWithPlayer(ping + 0.05)
            end
            self.state.wasStomping = false
            self.state.lastStompTime = 0
            self.state.lastSyncTime = 0
        end
    end
end

-- Auto Loadout system (using flags)
local AutoLoadout = {}

do
    local lp = LocalPlayer
    local desync = Desync
    local targeting = Targeting
    local loopManager = LoopManager
    local auto_stomp = AutoStomp
    local shop = workspace:FindFirstChild("Ignored") and workspace.Ignored:FindFirstChild("Shop")
    local armor_shop = shop and shop:FindFirstChild('[High-Medium Armor] - $2589')
    local fire_armor_shop = shop and shop:FindFirstChild('[Fire Armor] - $2701')
    
    local state = {
        enabled = false,
        armor = false,
        fire_armor = false,
        guns = false,
        ammo = false,
        buying = false,
        ammo_count = 1,
        armor_target = 130,
        fire_armor_target = 200,
        ammo_only_selected = false,
        conditions = {
            noTarget = false,
            targetNotKO = false,
            notSafe = false,
        },
        isWorking = false,
    }
    
    local weapons = {
        { name = '[Rifle]', shop = '[Rifle] - $1745', ammo = '5 [Rifle Ammo] - $281', enabled = false },
        { name = '[Flintlock]', shop = '[Flintlock] - $1463', ammo = '6 [Flintlock Ammo] - $168', enabled = false },
        { name = '[LMG]', shop = '[LMG] - $4221', ammo = '200 [LMG Ammo] - $338', enabled = false },
        { name = '[AUG]', shop = '[AUG] - $2195', ammo = '90 [AUG Ammo] - $90', enabled = false },
        { name = '[AK47]', shop = '[AK47] - $2799', ammo = '30 [AK47 Ammo] - $168', enabled = false },
        { name = '[P90]', shop = '[P90] - $2999', ammo = '50 [P90 Ammo] - $150', enabled = false },
        { name = '[Revolver]', shop = '[Revolver] - $1199', ammo = '6 [Revolver Ammo] - $84', enabled = false },
        { name = '[Double-Barrel SG]', shop = '[Double-Barrel SG] - $1399', ammo = '8 [Double-Barrel SG Ammo] - $112', enabled = false },
        { name = '[TacticalShotgun]', shop = '[TacticalShotgun] - $2199', ammo = '8 [TacticalShotgun Ammo] - $112', enabled = false },
    }
    
    local function getArmor(armor_type)
        local effects = lp.Character and lp.Character:FindFirstChild('BodyEffects')
        if not effects then return 0 end
        local armor_val = effects:FindFirstChild(armor_type)
        return armor_val and tonumber(armor_val.Value) or 0
    end
    
    local function hasWeapon(name)
        return (lp.Backpack:FindFirstChild(name) or (lp.Character and lp.Character:FindFirstChild(name))) ~= nil
    end
    
    local function getAmmo(name)
        local inv = lp.DataFolder and lp.DataFolder.Inventory and lp.DataFolder.Inventory:FindFirstChild(name)
        return inv and tonumber(inv.Value) or 0
    end
    
    local function removeTools()
        if not lp.Character then return end
        for _, tool in pairs(lp.Character:GetChildren()) do
            if tool:IsA('Tool') then
                tool.Parent = lp.Backpack
            end
        end
    end
    
    local function checkConditions()
        if not targeting then return true end
        if state.conditions.noTarget and not targeting.target then return false end
        if state.conditions.targetNotKO and targeting.target then
            local info = targeting:GetTargetInfo({'state'})
            if info and (not info.IsKO and not info.IsDead) or info.HasFF then return false end
        end
        if state.conditions.notSafe and not (lp.Character and (lp.Character:FindFirstChild('ForceField') or lp.Character:FindFirstChild('ForceField_TESTING'))) then return false end
        return true
    end
    
    local function buyItem(shop_item, armor_type, target)
        if not shop_item or state.buying or not lp.Character or not lp.Character:FindFirstChild('HumanoidRootPart') then return end
        
        local current = getArmor(armor_type)
        if current >= target or not checkConditions() then return end
        
        state.buying = true
        state.isWorking = true
        
        local head = shop_item:FindFirstChild('Head')
        local cd = shop_item:FindFirstChild('ClickDetector')
        local timeout = tick() + 5
        
        if head and cd then
            while tick() < timeout do
                current = getArmor(armor_type)
                if current >= target then break end
                removeTools()
                if desync and desync.moveDesyncTo then
                    desync:moveDesyncTo(head.Position.X, head.Position.Y, head.Position.Z, 100, 'autoLoadout')
                end
                fireclickdetector(cd)
                task.wait(0.1)
            end
        end
        
        if desync and desync.synchronizeSyncWithPlayer then
            desync:synchronizeSyncWithPlayer()
        end
        
        state.buying = false
        state.isWorking = false
    end
    
    local function buyAmmo(weapon)
        if state.buying or not hasWeapon(weapon.name) or not checkConditions() then return end
        
        local ammo = getAmmo(weapon.name)
        if ammo > 0 then return end
        
        state.buying = true
        state.isWorking = true
        
        local ammo_shop = shop and shop:FindFirstChild(weapon.ammo)
        if not ammo_shop then
            state.buying = false
            return
        end
        
        local head = ammo_shop:FindFirstChild('Head')
        local cd = ammo_shop:FindFirstChild('ClickDetector')
        local timeout = tick() + 5
        
        if head and cd then
            local count = 0
            local last = ammo
            while tick() < timeout and count < state.ammo_count do
                removeTools()
                if desync and desync.moveDesyncTo then
                    desync:moveDesyncTo(head.Position.X, head.Position.Y, head.Position.Z, 100, 'autoLoadout')
                end
                fireclickdetector(cd)
                task.wait(0.1)
                local new_ammo = getAmmo(weapon.name)
                if new_ammo > last then
                    count = count + 1
                    last = new_ammo
                end
            end
        end
        
        if desync and desync.synchronizeSyncWithPlayer then
            desync:synchronizeSyncWithPlayer()
        end
        
        state.buying = false
        state.isWorking = false
    end
    
    local function mainLoop()
        if not state.enabled or state.buying or not lp.Character then return end
        if auto_stomp and auto_stomp:isStompingInProgress() then return end
        
        if state.armor and armor_shop then
            buyItem(armor_shop, 'Armor', state.armor_target)
        end
        
        if state.fire_armor and fire_armor_shop then
            buyItem(fire_armor_shop, 'FireArmor', state.fire_armor_target)
        end
        
        if state.guns then
            for _, w in ipairs(weapons) do
                if w.enabled and not hasWeapon(w.name) and checkConditions() then
                    local w_shop = shop and shop:FindFirstChild(w.shop)
                    if w_shop then
                        local head = w_shop:FindFirstChild('Head')
                        local cd = w_shop:FindFirstChild('ClickDetector')
                        if head and cd then
                            state.buying = true
                            state.isWorking = true
                            
                            local timeout = tick() + 5
                            while tick() < timeout and not hasWeapon(w.name) do
                                removeTools()
                                if desync and desync.moveDesyncTo then
                                    desync:moveDesyncTo(head.Position.X, head.Position.Y, head.Position.Z, 100, 'autoLoadout')
                                end
                                fireclickdetector(cd)
                                task.wait(0.1)
                            end
                            
                            if desync and desync.synchronizeSyncWithPlayer then
                                desync:synchronizeSyncWithPlayer()
                            end
                            
                            state.buying = false
                            state.isWorking = false
                        end
                    end
                end
            end
        end
        
        if state.ammo then
            for _, w in ipairs(weapons) do
                if state.ammo_only_selected and not w.enabled then
                    return
                end
                buyAmmo(w)
            end
        end
    end
    
    loopManager:AddHeartbeat('autoLoadout', mainLoop)
    
    function AutoLoadout:setEnabled(e) 
        state.enabled = e 
        Library.Flags.auto_loadout_enabled = e 
    end
    
    function AutoLoadout:setArmorEnabled(e) 
        state.armor = e 
    end
    
    function AutoLoadout:setFireArmorEnabled(e) 
        state.fire_armor = e 
    end
    
    function AutoLoadout:setGunsEnabled(e) 
        state.guns = e 
    end
    
    function AutoLoadout:setAmmoEnabled(e) 
        state.ammo = e 
    end
    
    function AutoLoadout:setAmmoPurchaseCount(c) 
        state.ammo_count = c 
    end
    
    function AutoLoadout:setArmorTarget(t) 
        state.armor_target = t 
    end
    
    function AutoLoadout:setFireArmorTarget(t) 
        state.fire_armor_target = t 
    end
    
    function AutoLoadout:setConditions(c) 
        state.conditions = c 
    end
    
    function AutoLoadout:setWeaponEnabled(name, e)
        for _, w in ipairs(weapons) do
            if w.name == name then 
                w.enabled = e 
                break 
            end
        end
    end
    
    function AutoLoadout:setAmmoOnlySelected(e) 
        state.ammo_only_selected = e 
    end
    
    function AutoLoadout:isWorking() 
        return state.isWorking 
    end
    
    function AutoLoadout:getWeaponsConfig() 
        return weapons 
    end
end

-- ESP System Variables
local utility, connections, cache = {}, {}, {}
local originalClothing = {}
local originalBodyColors = {}
local originalGunColors = {}
local toolConnection = nil
local selfHighlight = nil
local materialsList = {"Neon", "ForceField"}

-- Player Chams variables
local chamsCache = {}
local bodyParts = {
    "Head", "Torso", "Left Arm", "Right Arm", 
    "Left Leg", "Right Leg", "UpperTorso", "LowerTorso"
}
local chamsFolder = nil

-- Initialize chams folder
local function initChamsFolder()
    if not chamsFolder then
        chamsFolder = Instance.new("Folder")
        chamsFolder.Name = "PlayerChamsFolder"
        chamsFolder.Parent = game.CoreGui
    end
    return chamsFolder
end

-- Player Chams functions
utility.chams = {
    create = function(player)
        local character = player.Character
        if not character or not character:FindFirstChild('HumanoidRootPart') then
            return nil
        end

        initChamsFolder()

        local chamsList = {}
        local partMap = {}

        for _, partName in ipairs(bodyParts) do
            local part = character:FindFirstChild(partName)
            if part and (part:IsA('BasePart') or part:IsA('MeshPart')) then
                local adornment = Instance.new('BoxHandleAdornment')
                adornment.Size = part.Size
                adornment.Adornee = part
                adornment.ZIndex = 0
                adornment.Color3 = Color3.fromRGB(255, 255, 255)
                adornment.Transparency = 0.5
                adornment.AlwaysOnTop = true
                adornment.Visible = false
                adornment.Parent = chamsFolder
                partMap[adornment] = partName
                table.insert(chamsList, adornment)
            end
        end

        chamsCache[player] = {
            chams = chamsList,
            partMap = partMap,
        }

        return {chams = chamsList}
    end,

    remove = function(player)
        local chamsData = chamsCache[player]
        if chamsData and chamsData.chams then
            for _, adornment in ipairs(chamsData.chams) do
                pcall(function()
                    adornment:Destroy()
                end)
            end
            table.clear(chamsData.chams)
            if chamsData.partMap then
                table.clear(chamsData.partMap)
            end
        end
        chamsCache[player] = nil
    end,

    update = function(player, settings)
        local chamsData = chamsCache[player]

        if not chamsData then
            if settings.Enabled then
                local newData = utility.chams.create(player)
                if newData then
                    chamsData = chamsCache[player]
                end
            end
            if not chamsData or not chamsData.chams then
                return
            end
        end

        local character = player.Character
        if not character or not character.Parent or not character:FindFirstChild('HumanoidRootPart') then
            for _, adornment in ipairs(chamsData.chams) do
                if adornment then
                    adornment.Visible = false
                end
            end
            return
        end

        local partMap = chamsData.partMap or {}
        local existingParts = {}

        for _, adornment in ipairs(chamsData.chams) do
            if adornment and adornment.Parent then
                local partName = partMap[adornment]
                if partName then
                    local part = character:FindFirstChild(partName)
                    if part and (part:IsA('BasePart') or part:IsA('MeshPart')) then
                        existingParts[partName] = true
                        if adornment.Adornee ~= part then
                            adornment.Adornee = part
                            adornment.Size = part.Size
                        elseif adornment.Size ~= part.Size then
                            adornment.Size = part.Size
                        end

                        adornment.Visible = settings.Enabled
                        adornment.Color3 = settings.Color
                        adornment.Transparency = settings.Transparency
                    else
                        adornment.Visible = false
                    end
                else
                    if adornment.Adornee and adornment.Adornee.Parent then
                        adornment.Visible = settings.Enabled
                        adornment.Color3 = settings.Color
                        adornment.Transparency = settings.Transparency
                    else
                        adornment.Visible = false
                    end
                end
            end
        end

        if settings.Enabled then
            for _, partName in ipairs(bodyParts) do
                if not existingParts[partName] then
                    local part = character:FindFirstChild(partName)
                    if part and (part:IsA('BasePart') or part:IsA('MeshPart')) then
                        local adornment = Instance.new('BoxHandleAdornment')
                        adornment.Size = part.Size
                        adornment.Adornee = part
                        adornment.ZIndex = 0
                        adornment.Color3 = settings.Color
                        adornment.Transparency = settings.Transparency
                        adornment.AlwaysOnTop = true
                        adornment.Visible = true
                        adornment.Parent = chamsFolder
                        partMap[adornment] = partName
                        table.insert(chamsData.chams, adornment)
                    end
                end
            end
        end
    end,

    clearAll = function()
        for player in pairs(chamsCache) do
            utility.chams.remove(player)
        end
    end
}

-- ESP Drawing Functions
local Vec3 = Vector3.new
local Edges = {
    {1, 2}, {2, 4}, {4, 3}, {3, 1},
    {5, 6}, {6, 8}, {8, 7}, {7, 5},
    {1, 5}, {2, 6}, {3, 7}, {4, 8},
}

local function CornerVec(part: BasePart)
    local s = part.Size * 0.5
    return {
        Vec3(-s.X, -s.Y, -s.Z),
        Vec3(s.X, -s.Y, -s.Z),
        Vec3(-s.X, -s.Y, s.Z),
        Vec3(s.X, -s.Y, s.Z),
        Vec3(-s.X, s.Y, -s.Z),
        Vec3(s.X, s.Y, -s.Z),
        Vec3(-s.X, s.Y, s.Z),
        Vec3(s.X, s.Y, s.Z),
    }
end

local function RemoveWireChams(part: BasePart)
    if not part then return end
    local chams = part:FindFirstChild("Chams")
    if chams and chams:IsA("WireframeHandleAdornment") then
        chams:Destroy()
    end
end

utility.funcs = utility.funcs or {}
utility.funcs.make_text = function(p)
    local d = Instance.new("TextLabel")
    d.Parent = p
    d.Size = UDim2.new(0, 0, 0, 0)
    d.AutomaticSize = Enum.AutomaticSize.XY
    d.BackgroundTransparency = 1
    d.TextColor3 = Color3.fromRGB(255,255,255)
    d.TextStrokeTransparency = 0
    d.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    d.TextScaled = false
    d.TextSize = 9
    d.FontFace = fonts.main
    d.TextXAlignment = Enum.TextXAlignment.Center
    d.TextYAlignment = Enum.TextYAlignment.Center
    d.AnchorPoint = Vector2.new(0.5, 0.5)
    return d
end

utility.funcs.render = function(player)
    if not player or player == LocalPlayer then return end
    cache[player] = cache[player] or {}
    cache[player].Box = {}
    cache[player].Bars = {}
    cache[player].Text = {}
    cache[player].Box.Full = {
        Square = Drawing.new("Square"),
        Inline = Drawing.new("Square"),
        Outline = Drawing.new("Square"),
        Filled = Instance.new('Frame')
    }
    local FilledGui = Instance.new('ScreenGui', game.CoreGui)
    FilledGui.Name = player.Name .. "_BoxFilled"
    FilledGui.IgnoreGuiInset = true
    cache[player].Box.Full.Filled.Parent = FilledGui
    local Studs = Instance.new("ScreenGui")
    Studs.Name = player.Name .. "_Studs"
    Studs.IgnoreGuiInset = true
    Studs.Parent = game.CoreGui
    local Name = Instance.new("ScreenGui")
    Name.Name = player.Name .. "_Name"
    Name.IgnoreGuiInset = true
    Name.Parent = game.CoreGui
    local Tool = Instance.new("ScreenGui")
    Tool.Name = player.Name .. "_Tool"
    Tool.IgnoreGuiInset = true
    Tool.Parent = game.CoreGui
    cache[player].Text.Studs = utility.funcs.make_text(Studs)
    cache[player].Text.Tool = utility.funcs.make_text(Tool)
    local nameLabel = utility.funcs.make_text(Name)
    cache[player].Text.Name = nameLabel
    local armorGui = Instance.new("ScreenGui")
    armorGui.Name = player.Name .. "_ArmorBar"
    armorGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    armorGui.IgnoreGuiInset = true
    armorGui.Parent = game.CoreGui
    local armorOutline = Instance.new("Frame")
    armorOutline.BackgroundColor3 = Color3.new(0, 0, 0)
    armorOutline.BorderSizePixel = 0
    armorOutline.Name = "Outline"
    armorOutline.Parent = armorGui
    local armorFill = Instance.new("Frame")
    armorFill.BackgroundTransparency = 0
    armorFill.BorderSizePixel = 0
    armorFill.Name = "Fill"
    armorFill.AnchorPoint = Vector2.new(0, 1)
    armorFill.Position = UDim2.new(0, 1, 1, -1)
    armorFill.Size = UDim2.new(0, 3, 0, 0)
    armorFill.Parent = armorOutline
    local armorGradient = Instance.new("UIGradient", armorFill)
    armorGradient.Rotation = 90
    cache[player].Bars.Armor = {
        Gui = armorGui,
        Outline = armorOutline,
        Frame = armorFill,
        Gradient = armorGradient
    }
    local healthGui = Instance.new("ScreenGui")
    healthGui.Name = player.Name .. "_HealthBar"
    healthGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    healthGui.IgnoreGuiInset = true
    healthGui.Parent = game.CoreGui
    local healthOutline = Instance.new("Frame")
    healthOutline.BackgroundColor3 = Color3.new(0, 0, 0)
    healthOutline.BorderSizePixel = 0
    healthOutline.Name = "Outline"
    healthOutline.Parent = healthGui
    local healthFill = Instance.new("Frame")
    healthFill.BackgroundTransparency = 0
    healthFill.BorderSizePixel = 0
    healthFill.Name = "Fill"
    healthFill.AnchorPoint = Vector2.new(0, 1)
    healthFill.Position = UDim2.new(0, 1, 1, -1)
    healthFill.Size = UDim2.new(0, 3, 0, 0)
    healthFill.Parent = healthOutline
    local healthGradient = Instance.new("UIGradient", healthFill)
    healthGradient.Rotation = 90
    cache[player].Bars.Health = {
        Gui = healthGui,
        Outline = healthOutline,
        Frame = healthFill,
        Gradient = healthGradient
    }
    local healthNumGui = Instance.new("ScreenGui")
    healthNumGui.Name = player.Name .. "_HealthNum"
    healthNumGui.IgnoreGuiInset = true
    healthNumGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    healthNumGui.Parent = game.CoreGui
    cache[player].Text.HealthNum = utility.funcs.make_text(healthNumGui)
    local armorNumGui = Instance.new("ScreenGui")
    armorNumGui.Name = player.Name .. "_ArmorNum"
    armorNumGui.IgnoreGuiInset = true
    armorNumGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    armorNumGui.Parent = game.CoreGui
    cache[player].Text.ArmorNum = utility.funcs.make_text(armorNumGui)
end

utility.funcs.clear_esp = function(player)
    if not cache[player] then return end
    if cache[player].Box and cache[player].Box.Full then
        cache[player].Box.Full.Square.Visible = false
        cache[player].Box.Full.Outline.Visible = false
        cache[player].Box.Full.Inline.Visible = false
        if cache[player].Box.Full.Filled then
            cache[player].Box.Full.Filled.Visible = false
        end
    end
    if cache[player].Text then
        if cache[player].Text.Studs then cache[player].Text.Studs.Visible = false end
        if cache[player].Text.Tool then cache[player].Text.Tool.Visible = false end
        if cache[player].Text.Name then cache[player].Text.Name.Visible = false end
        if cache[player].Text.HealthNum then cache[player].Text.HealthNum.Visible = false end
        if cache[player].Text.ArmorNum then cache[player].Text.ArmorNum.Visible = false end
    end
    if cache[player].Bars then
        if cache[player].Bars.Health then
            cache[player].Bars.Health.Frame.Visible = false
            cache[player].Bars.Health.Outline.Visible = false
        end
        if cache[player].Bars.Armor then
            cache[player].Bars.Armor.Frame.Visible = false
            cache[player].Bars.Armor.Outline.Visible = false
        end
    end
end

utility.funcs.get_name_text = function(player, mode)
    if mode == "display" then
        return player.DisplayName
    elseif mode == "username" then
        return player.Name
    elseif mode == "username I display" then
        return player.Name .. " I " .. player.DisplayName
    elseif mode == "userid" then
        return tostring(player.UserId)
    else
        return player.DisplayName
    end
end

utility.funcs.update = function(player)
    if not player or player == LocalPlayer or not cache[player] then return end
    local character = player.Character
    if not character then
        utility.funcs.clear_esp(player)
        return
    end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    if not rootPart or not humanoid then
        utility.funcs.clear_esp(player)
        return
    end
    local isTeammate = player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team
    
    -- Use flags for ESP settings
    local Pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
    if not onScreen then
        utility.funcs.clear_esp(player)
        return
    end
    local playerCache = cache[player]
    local position, size
    
    local ok, cf, sz = pcall(function() return character:GetBoundingBox() end)
    if ok and cf and sz and sz.Magnitude > 0 then
        local padX, padY, padZ = 0.05, 0.3, 0.05
        local half = sz / 2 + Vector3.new(padX, padY, padZ)
        local local_corners = {
            Vector3.new( half.X, half.Y, half.Z),
            Vector3.new( half.X, half.Y, -half.Z),
            Vector3.new( half.X, -half.Y, half.Z),
            Vector3.new( half.X, -half.Y, -half.Z),
            Vector3.new(-half.X, half.Y, half.Z),
            Vector3.new(-half.X, half.Y, -half.Z),
            Vector3.new(-half.X, -half.Y, half.Z),
            Vector3.new(-half.X, -half.Y, -half.Z),
        }
        local min_x, min_y = math.huge, math.huge
        local max_x, max_y = -math.huge, -math.huge
        local has_visible = false
        for _, loc in ipairs(local_corners) do
            local world = cf * loc
            local scr, vis = Camera:WorldToViewportPoint(world)
            if vis then
                min_x = math.min(min_x, scr.X)
                min_y = math.min(min_y, scr.Y)
                max_x = math.max(max_x, scr.X)
                max_y = math.max(max_y, scr.Y)
                has_visible = true
            end
        end
        if has_visible and max_x > min_x and max_y > min_y then
            position = Vector2.new(math.floor(min_x), math.floor(min_y))
            size = Vector2.new(math.floor(max_x - min_x), math.floor(max_y - min_y))
        else
            local headOffset = Vector3.new(0, 2.8, 0)
            local feetOffset = Vector3.new(0, -2.5, 0)
            local headY = Camera:WorldToViewportPoint(rootPart.Position + headOffset).Y
            local feetY = Camera:WorldToViewportPoint(rootPart.Position + feetOffset).Y
            local screenHeight = math.abs(feetY - headY)
            local approxWidth = screenHeight * 0.42
            size = Vector2.new(math.floor(approxWidth), math.floor(screenHeight))
            position = Vector2.new(math.floor(Pos.X - size.X / 2), math.floor(math.min(headY, feetY)))
        end
    else
        local headOffset = Vector3.new(0, 2.8, 0)
        local feetOffset = Vector3.new(0, -2.5, 0)
        local headY = Camera:WorldToViewportPoint(rootPart.Position + headOffset).Y
        local feetY = Camera:WorldToViewportPoint(rootPart.Position + feetOffset).Y
        local screenHeight = math.abs(feetY - headY)
        local approxWidth = screenHeight * 0.42
        size = Vector2.new(math.floor(approxWidth), math.floor(screenHeight))
        position = Vector2.new(math.floor(Pos.X - size.X / 2), math.floor(math.min(headY, feetY)))
    end

    if Library.Flags.esp_box_enabled then
        local fullBox = playerCache.Box.Full
        local square, outline, inline, filled = fullBox.Square, fullBox.Outline, fullBox.Inline, fullBox.Filled
        square.Visible = true
        square.Position = position
        square.Size = size
        square.Color = Library.Flags.esp_box_color or Color3.fromRGB(255,255,255)
        square.Thickness = 2
        square.Filled = false
        square.ZIndex = 9e9
        outline.Visible = true
        outline.Position = position - Vector2.new(1, 1)
        outline.Size = size + Vector2.new(2, 2)
        outline.Color = Color3.new(0, 0, 0)
        outline.Thickness = 1
        outline.Filled = false
        inline.Visible = true
        inline.Position = position + Vector2.new(1, 1)
        inline.Size = size - Vector2.new(2, 2)
        inline.Color = Color3.new(0, 0, 0)
        inline.Thickness = 1
        inline.Filled = false
        if Library.Flags.esp_filled_enabled and filled then
            filled.Position = UDim2.new(0, position.X, 0, position.Y)
            filled.Size = UDim2.new(0, size.X, 0, size.Y)
            filled.BackgroundTransparency = Library.Flags.esp_filled_transparency and (Library.Flags.esp_filled_transparency / 100) or 0.5
            filled.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            filled.Visible = true
            filled.ZIndex = -9e9
            local gradient = filled:FindFirstChild("Gradient") or Instance.new("UIGradient")
            gradient.Name = "Gradient"
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Library.Flags.esp_filled_color1 or Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.333, Library.Flags.esp_filled_color2 or Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.666, Library.Flags.esp_filled_color3 or Color3.fromRGB(255, 165, 0)),
                ColorSequenceKeypoint.new(1, Library.Flags.esp_filled_color4 or Color3.fromRGB(255, 0, 0))
            })
            gradient.Rotation = 90
            gradient.Parent = filled
        elseif filled then
            filled.Visible = false
            if filled:FindFirstChild("Gradient") then
                filled.Gradient:Destroy()
            end
        end
    else
        playerCache.Box.Full.Square.Visible = false
        playerCache.Box.Full.Outline.Visible = false
        playerCache.Box.Full.Inline.Visible = false
        if playerCache.Box.Full.Filled then playerCache.Box.Full.Filled.Visible = false end
    end

    local bar_height = size.Y
    local bar_width = 3
    local base_x = position.X
    local bar_y = position.Y
    local bar_bottom = position.Y + bar_height
    
    local bodyEffects = character:FindFirstChild("BodyEffects")
    local armorValue = bodyEffects and bodyEffects:FindFirstChild("Armor")
    local currentArmor = armorValue and armorValue.Value or 0

    -- Health Bar
    if Library.Flags.esp_healthbar_enabled then
        local targetHealth = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
        local lastHealth = playerCache.Bars.Health.LastHealth or targetHealth
        local lerpedHealth = Library.Flags.esp_health_lerp and (lastHealth + (targetHealth - lastHealth) * 0.1) or targetHealth
        playerCache.Bars.Health.LastHealth = lerpedHealth
        
        -- Position bar to the left of the box
        local bar_x = base_x - bar_width - 4
        
        local outline = playerCache.Bars.Health.Outline
        local fill = playerCache.Bars.Health.Frame
        local gradient = playerCache.Bars.Health.Gradient
        
        if outline and fill and gradient then
            -- Set gradient colors
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Library.Flags.esp_health_high or Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.333, Library.Flags.esp_health_medium or Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.666, Library.Flags.esp_health_low or Color3.fromRGB(255, 128, 0)),
                ColorSequenceKeypoint.new(1, Library.Flags.esp_health_critical or Color3.fromRGB(255, 0, 0))
            })
            
            -- Calculate fill height based on current health
            local fillHeight = math.max(1, lerpedHealth * bar_height)
            
            -- Outline - positioned so bottom aligns with box bottom, height matches fill
            outline.Position = UDim2.new(0, bar_x - 1, 0, bar_bottom - fillHeight - 1)
            outline.Size = UDim2.new(0, bar_width + 2, 0, fillHeight + 2)
            outline.BackgroundTransparency = 0.3
            outline.Visible = true
            
            -- Fill - anchored to bottom
            fill.Position = UDim2.new(0, 1, 1, -1)
            fill.Size = UDim2.new(0, bar_width, 0, fillHeight)
            fill.Visible = lerpedHealth > 0
        end
    else
        if playerCache.Bars.Health then
            playerCache.Bars.Health.Frame.Visible = false
            playerCache.Bars.Health.Outline.Visible = false
        end
    end

    -- Armor Bar
    if Library.Flags.esp_armorbar_enabled then
        local targetArmor = math.clamp(currentArmor / 130, 0, 1)
        local lastArmor = playerCache.Bars.Armor.LastArmor or targetArmor
        local lerpedArmor = Library.Flags.esp_armor_lerp and (lastArmor + (targetArmor - lastArmor) * 0.1) or targetArmor
        playerCache.Bars.Armor.LastArmor = lerpedArmor
        
        -- Position bar further left (next to health bar)
        local bar_x = base_x - bar_width * 2 - 8
        
        local outline = playerCache.Bars.Armor.Outline
        local fill = playerCache.Bars.Armor.Frame
        local gradient = playerCache.Bars.Armor.Gradient
        
        if outline and fill and gradient then
            -- Set gradient colors
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Library.Flags.esp_armor_high or Color3.fromRGB(0, 191, 255)),
                ColorSequenceKeypoint.new(0.333, Library.Flags.esp_armor_medium or Color3.fromRGB(30, 144, 255)),
                ColorSequenceKeypoint.new(0.666, Library.Flags.esp_armor_low or Color3.fromRGB(100, 0, 255)),
                ColorSequenceKeypoint.new(1, Library.Flags.esp_armor_critical or Color3.fromRGB(128, 0, 128))
            })
            
            -- Calculate fill height based on current armor
            local fillHeight = math.max(1, lerpedArmor * bar_height)
            
            -- Outline - positioned so bottom aligns with box bottom, height matches fill
            outline.Position = UDim2.new(0, bar_x - 1, 0, bar_bottom - fillHeight - 1)
            outline.Size = UDim2.new(0, bar_width + 2, 0, fillHeight + 2)
            outline.BackgroundTransparency = 0.3
            outline.Visible = true
            
            -- Fill - anchored to bottom
            fill.Position = UDim2.new(0, 1, 1, -1)
            fill.Size = UDim2.new(0, bar_width, 0, fillHeight)
            fill.Visible = lerpedArmor > 0
        end
    else
        if playerCache.Bars.Armor then
            playerCache.Bars.Armor.Frame.Visible = false
            playerCache.Bars.Armor.Outline.Visible = false
        end
    end

    playerCache.Text.HealthNum.Visible = false
    playerCache.Text.ArmorNum.Visible = false
    local right_labels = {}
    local right_x = position.X + size.X + 4
    
    if Library.Flags.esp_armornum_toggle then
        local label = playerCache.Text.ArmorNum
        label.Text = string.format("armor: %.0f/130", currentArmor)
        label.TextColor3 = Library.Flags.esp_armornum_color or Color3.fromRGB(255,255,255)
        table.insert(right_labels, label)
    end
    
    if Library.Flags.esp_healthnum_toggle then
        local label = playerCache.Text.HealthNum
        label.Text = string.format("health: %.0f/%.0f", humanoid.Health, humanoid.MaxHealth)
        label.TextColor3 = Library.Flags.esp_healthnum_color or Color3.fromRGB(255,255,255)
        table.insert(right_labels, label)
    end

    local function get_height(label)
        return label.AbsoluteSize.Y > 0 and label.AbsoluteSize.Y or 12
    end

    if #right_labels > 0 then
        local spacing_right = 3
        local heights = {}
        local total_height = 0
        for _, label in ipairs(right_labels) do
            local h = get_height(label)
            table.insert(heights, h)
            total_height = total_height + h
        end
        local num = #right_labels
        if num > 1 then
            total_height = total_height + (num - 1) * spacing_right
        end
        local start_y = position.Y + 6
        local current_y = start_y
        for i, label in ipairs(right_labels) do
            local height = heights[i]
            label.Position = UDim2.new(0, right_x, 0, current_y)
            label.AnchorPoint = Vector2.new(0, 0)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Visible = true
            if i < num then
                current_y = current_y + height + spacing_right
            end
        end
    end

    playerCache.Text.Name.Visible = false
    playerCache.Text.Studs.Visible = false
    playerCache.Text.Tool.Visible = false
    
    local top_labels = {}
    local bottom_labels = {}
    local baseX = position.X + size.X / 2
    local distance = (Camera.CFrame.Position - rootPart.Position).Magnitude
    local meters = distance * 0.28
    
    if Library.Flags.esp_name_enabled then
        local label = playerCache.Text.Name
        label.Text = utility.funcs.get_name_text(player, Library.Flags.esp_name_mode or "display")
        label.TextColor3 = Library.Flags.esp_name_color or Color3.fromRGB(255,255,255)
        table.insert(top_labels, label)
    end
    
    if Library.Flags.esp_studs_enabled then
        local label = playerCache.Text.Studs
        label.Text = string.format("[%.0fm]", meters)
        label.TextColor3 = Library.Flags.esp_studs_color or Color3.fromRGB(255,255,255)
        table.insert(bottom_labels, label)
    end
    
    if Library.Flags.esp_tool_enabled then
        local label = playerCache.Text.Tool
        local tool = character:FindFirstChildOfClass("Tool")
        label.Text = tool and tool.Name or "none"
        label.TextColor3 = Library.Flags.esp_tool_color or Color3.fromRGB(255,255,255)
        table.insert(bottom_labels, label)
    end
    
    local spacing = 3
    local box_padding = 4
    
    -- Top labels (above box)
    local current_bottom_y = position.Y - box_padding
    for _, label in ipairs(top_labels) do
        local height = get_height(label)
        label.AnchorPoint = Vector2.new(0.5, 1)
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.Position = UDim2.new(0, baseX, 0, current_bottom_y)
        label.Visible = true
        current_bottom_y = current_bottom_y - height - spacing
    end
    
    -- Bottom labels (below box)
    local current_top_y = position.Y + size.Y + box_padding
    for _, label in ipairs(bottom_labels) do
        local height = get_height(label)
        label.AnchorPoint = Vector2.new(0.5, 0)
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.Position = UDim2.new(0, baseX, 0, current_top_y)
        label.Visible = true
        current_top_y = current_top_y + height + spacing
    end
end

-- Initialize ESP for all players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        utility.funcs.render(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        utility.funcs.render(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if player ~= LocalPlayer then
        utility.funcs.clear_esp(player)
        if cache[player] then
            for _, v in pairs(cache[player].Box or {}) do if v and v.Parent then v.Parent:Destroy() end end
            for _, v in pairs(cache[player].Bars or {}) do if v.Gui then v.Gui:Destroy() end end
            for _, v in pairs(cache[player].Text or {}) do
                if v and v.Parent then
                    v.Parent:Destroy()
                end
            end
            cache[player] = nil
        end
        utility.chams.remove(player)
    end
end)

-- Self Visuals Functions (using flags)
local function applySelfVisuals()
    local char = LocalPlayer.Character
    if not char or not char.Parent then return end
    
    if Library.Flags.self_body_material then
        if not originalClothing[char] then
            originalClothing[char] = {}
            local shirt = char:FindFirstChildWhichIsA("Shirt")
            if shirt then originalClothing[char].Shirt = shirt.ShirtTemplate end
            local pants = char:FindFirstChildWhichIsA("Pants")
            if pants then originalClothing[char].Pants = pants.PantsTemplate end
            local shirtGraphic = char:FindFirstChildWhichIsA("ShirtGraphic")
            if shirtGraphic then originalClothing[char].ShirtGraphic = shirtGraphic.Graphic end
        end
        local shirt = char:FindFirstChildWhichIsA("Shirt")
        if shirt then shirt.ShirtTemplate = "" end
        local pants = char:FindFirstChildWhichIsA("Pants")
        if pants then pants.PantsTemplate = "" end
        local shirtGraphic = char:FindFirstChildWhichIsA("ShirtGraphic")
        if shirtGraphic then shirtGraphic.Graphic = "" end
        if not originalBodyColors[char] then
            originalBodyColors[char] = {}
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    originalBodyColors[char][part] = part.Color
                end
            end
        end
        local mat = Enum.Material[Library.Flags.self_body_type or "Neon"]
        local col = Library.Flags.self_body_color or Color3.fromRGB(255, 0, 255)
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Material = mat
                if part.Name ~= "Head" then
                    part.Color = col
                end
            end
        end
        
        if mat == Enum.Material.Neon then
            local existingBodyHighlight = char:FindFirstChild("BodyNeonHighlight")
            if existingBodyHighlight then existingBodyHighlight:Destroy() end
            
            local bodyHighlight = Instance.new("Highlight")
            bodyHighlight.Name = "BodyNeonHighlight"
            bodyHighlight.Adornee = char
            bodyHighlight.FillColor = col
            bodyHighlight.FillTransparency = 0.4
            bodyHighlight.OutlineColor = col
            bodyHighlight.OutlineTransparency = 0.2
            bodyHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            bodyHighlight.Parent = char
        else
            local existingBodyHighlight = char:FindFirstChild("BodyNeonHighlight")
            if existingBodyHighlight then existingBodyHighlight:Destroy() end
        end
    else
        if originalClothing[char] then
            local shirt = char:FindFirstChildWhichIsA("Shirt")
            if shirt and originalClothing[char].Shirt then shirt.ShirtTemplate = originalClothing[char].Shirt end
            local pants = char:FindFirstChildWhichIsA("Pants")
            if pants and originalClothing[char].Pants then pants.PantsTemplate = originalClothing[char].Pants end
            local shirtGraphic = char:FindFirstChildWhichIsA("ShirtGraphic")
            if shirtGraphic and originalClothing[char].ShirtGraphic then shirtGraphic.Graphic = originalClothing[char].ShirtGraphic end
            originalClothing[char] = nil
        end
        if originalBodyColors[char] then
            for part, col in pairs(originalBodyColors[char]) do
                if part and part.Parent then
                    part.Color = col
                    part.Material = Enum.Material.Plastic
                end
            end
            originalBodyColors[char] = nil
        end
        local existingBodyHighlight = char:FindFirstChild("BodyNeonHighlight")
        if existingBodyHighlight then existingBodyHighlight:Destroy() end
    end

    if Library.Flags.self_wireframe then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                RemoveWireChams(part)
            end
        end
        local wcolor = Library.Flags.self_wireframe_color or Color3.fromRGB(255, 0, 255)
        local thickness = Library.Flags.self_wireframe_thickness or 1
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency < 1 then
                local ad = Instance.new("WireframeHandleAdornment")
                ad.Name = "Chams"
                ad.Adornee = part
                ad.AlwaysOnTop = false
                ad.Thickness = thickness
                ad.ZIndex = 1
                ad.Color3 = wcolor
                ad.Parent = part
                local corners = CornerVec(part)
                local points = {}
                for _, e in Edges do
                    points[#points + 1] = corners[e[1]]
                    points[#points + 1] = corners[e[2]]
                end
                ad:AddLines(points)
            end
        end
    else
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                RemoveWireChams(part)
            end
        end
    end

    if Library.Flags.self_gun_material then
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool then
            if not originalGunColors[currentTool] then
                originalGunColors[currentTool] = {}
                for _, part in pairs(currentTool:GetDescendants()) do
                    if part:IsA("BasePart") then
                        originalGunColors[currentTool][part] = {Color = part.Color, Material = part.Material}
                    end
                end
            end
            
            local mat = Enum.Material[Library.Flags.self_gun_type or "Neon"]
            local col = Library.Flags.self_gun_color or Color3.fromRGB(0, 255, 255)
            
            local existingHighlight = currentTool:FindFirstChild("NeonHighlight")
            if existingHighlight then existingHighlight:Destroy() end
            
            for _, part in pairs(currentTool:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Material = mat
                    part.Color = col
                end
            end
            
            if mat == Enum.Material.Neon then
                local highlight = Instance.new("Highlight")
                highlight.Name = "NeonHighlight"
                highlight.Adornee = currentTool
                highlight.FillColor = col
                highlight.FillTransparency = 0.3
                highlight.OutlineColor = col
                highlight.OutlineTransparency = 0.1
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = currentTool
            end
        end
        
        if toolConnection then toolConnection:Disconnect() end
        toolConnection = char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                if not originalGunColors[child] then
                    originalGunColors[child] = {}
                    for _, part in pairs(child:GetDescendants()) do
                        if part:IsA("BasePart") then
                            originalGunColors[child][part] = {Color = part.Color, Material = part.Material}
                        end
                    end
                end
                
                local mat = Enum.Material[Library.Flags.self_gun_type or "Neon"]
                local col = Library.Flags.self_gun_color or Color3.fromRGB(0, 255, 255)
                
                local existingHighlight = child:FindFirstChild("NeonHighlight")
                if existingHighlight then existingHighlight:Destroy() end
                
                for _, part in pairs(child:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Material = mat
                        part.Color = col
                    end
                end
                
                if mat == Enum.Material.Neon then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "NeonHighlight"
                    highlight.Adornee = child
                    highlight.FillColor = col
                    highlight.FillTransparency = 0.3
                    highlight.OutlineColor = col
                    highlight.OutlineTransparency = 0.1
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = child
                end
                
                child.Equipped:Connect(function()
                    task.wait(0.1)
                    for _, part in pairs(child:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Material = mat
                            part.Color = col
                        end
                    end
                end)
            end
        end)
    else
        if toolConnection then
            toolConnection:Disconnect()
            toolConnection = nil
        end
        
        for tool, data in pairs(originalGunColors) do
            if tool and tool.Parent then
                local highlight = tool:FindFirstChild("NeonHighlight")
                if highlight then highlight:Destroy() end
                
                for part, originalData in pairs(data) do
                    if part and part.Parent then
                        part.Color = originalData.Color
                        part.Material = originalData.Material or Enum.Material.Plastic
                    end
                end
            end
        end
        originalGunColors = {}
    end
    
    if Library.Flags.self_highlight then
        if selfHighlight then selfHighlight:Destroy() end
        selfHighlight = Instance.new("Highlight")
        selfHighlight.Adornee = char
        selfHighlight.FillColor = Library.Flags.self_highlight_color or Color3.fromRGB(255, 255, 255)
        selfHighlight.FillTransparency = (Library.Flags.self_highlight_transparency or 50) / 100
        selfHighlight.OutlineTransparency = 1
        selfHighlight.Parent = char
    elseif selfHighlight then
        selfHighlight:Destroy()
        selfHighlight = nil
    end
end

-- Update chams for all players
local function updateAllChams()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local isTeammate = player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team
            local chamsSettings = {
                Enabled = Library.Flags.player_chams_enabled or false,
                Color = Library.Flags.player_chams_color or Color3.fromRGB(255, 255, 255),
                Transparency = (Library.Flags.player_chams_transparency or 50) / 100
            }
            utility.chams.update(player, chamsSettings)
        end
    end
end

-- ESP and Chams update loop
local espUpdateConnection = RunService.Heartbeat:Connect(function()
    for player, _ in pairs(cache) do
        if player and player.Parent then
            utility.funcs.update(player)
        else
            cache[player] = nil
        end
    end
    
    updateAllChams()
end)

-- Initialize Self Visuals on character added
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(3)
    applySelfVisuals()
end)

if LocalPlayer.Character then
    applySelfVisuals()
end

-- Hit Effects System (using flags)
local function __modImpl()
    return function(api)
        local hitEffects = {}
        local ws = workspace
        local tweenService = game:GetService('TweenService')
        local players = game:GetService('Players')
        local lp = players.LocalPlayer
        local chamsEnabled = false
        local chamsColor = Color3.fromRGB(255, 0, 0)
        local chamsMaterial = Enum.Material.Neon
        local chamsDuration = 2
        local chamsTransparency = 0.5
        local lastChamsTime = 0
        local soundsEnabled = false
        local soundVolume = 5
        local soundPitch = 1
        local soundSelection = '1'
        local soundsFolder
        local availableSounds = {}
        local lastSoundTime = 0

        local function getSoundsFolder()
            if not soundsFolder then
                local symbolData = getgenv().SymbolDogShit

                if symbolData and symbolData.Folders and type(symbolData.Folders.GetPath) == 'function' then
                    soundsFolder = symbolData.Folders.GetPath('Sounds')
                else
                    soundsFolder = 'SymbolDogShit\\Sounds'
                end
            end

            return soundsFolder
        end

        local effectsEnabled = false
        local effectsColor = Color3.fromRGB(255, 255, 255)
        local effectsType = 'Particle'
        local lastEffectTime = 0
        local screenEnabled = false
        local screenColor = Color3.fromRGB(255, 0, 0)
        local screenTransparency = 0
        local screenDuration = 0.5
        local lastScreenTime = 0
        local bodyParts = {
            'Head',
            'UpperTorso',
            'LowerTorso',
            'LeftUpperArm',
            'LeftLowerArm',
            'LeftHand',
            'RightUpperArm',
            'RightLowerArm',
            'RightHand',
            'LeftUpperLeg',
            'LeftLowerLeg',
            'LeftFoot',
            'RightUpperLeg',
            'RightLowerLeg',
            'RightFoot',
        }

        local function createHitChams(target)
            if not chamsEnabled then
                return
            end

            local currentTime = tick()

            if currentTime - lastChamsTime < 0.2 then
                return
            end

            lastChamsTime = currentTime

            if not target or not target.Character then
                return
            end

            local hrp = target.Character:FindFirstChild('HumanoidRootPart')

            if not hrp then
                return
            end

            target.Character.Archivable = true

            local clone = target.Character:Clone()

            clone.Name = 'HitChams_Clone'

            for _, child in ipairs(clone:GetChildren())do
                if child:IsA('BasePart') then
                    local keep = false

                    for _, name in ipairs(bodyParts)do
                        if child.Name == name then
                            keep = true

                            break
                        end
                    end

                    if not keep then
                        child:Destroy()
                    end
                elseif child:IsA('Accessory') or child:IsA('Tool') or child:IsA('Shirt') or child:IsA('Pants') or child:IsA('Hat') then
                    child:Destroy()
                end
            end

            if clone:FindFirstChild('Humanoid') then
                clone.Humanoid:Destroy()
            end

            for _, part in ipairs(clone:GetChildren())do
                if part:IsA('BasePart') then
                    part.CanCollide = false
                    part.Anchored = true
                    part.Transparency = chamsTransparency
                    part.Color = chamsColor
                    part.Material = chamsMaterial
                end
            end

            if clone:FindFirstChild('Head') then
                local head = clone.Head

                head.Transparency = chamsTransparency
                head.Color = chamsColor
                head.Material = chamsMaterial

                if head:FindFirstChild('face') then
                    head.face:Destroy()
                end
            end

            clone.Parent = ws

            local tweenInfo = TweenInfo.new(chamsDuration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true)

            for _, part in ipairs(clone:GetChildren())do
                if part:IsA('BasePart') then
                    tweenService:Create(part, tweenInfo, {Transparency = 1}):Play()
                end
            end

            task.delay(chamsDuration, function()
                if clone and clone.Parent then
                    clone:Destroy()
                end
            end)
        end
        local function loadSounds()
            local folder = getSoundsFolder()

            availableSounds = {}

            if isfolder(folder) and listfiles then
                local files = listfiles(folder)

                for _, file in ipairs(files)do
                    local fileName = file:match('([^\\]+)$')

                    if fileName and (fileName:match('%.wav$') or fileName:match('%.mp3$') or fileName:match('%.ogg$')) then
                        local name = fileName:gsub('%.%w+$', '')

                        table.insert(availableSounds, name)
                    end
                end
            end
            if #availableSounds == 0 then
                for i = 1, 20 do
                    table.insert(availableSounds, tostring(i))
                end
            end
        end
        local function getSoundPath(name)
            local folder = getSoundsFolder()
            local extensions = {
                '.wav',
                '.mp3',
                '.ogg',
            }

            for _, ext in ipairs(extensions)do
                local path = folder .. '\\' .. name .. ext

                if isfile(path) then
                    return path
                end
            end

            return nil
        end
        local function playHitSound()
            if not soundsEnabled then
                return
            end

            local currentTime = tick()

            if currentTime - lastSoundTime < 0.2 then
                return
            end

            lastSoundTime = currentTime

            local path = getSoundPath(soundSelection)

            if path and isfile(path) then
                local sound = Instance.new('Sound')

                sound.Volume = soundVolume
                sound.PlaybackSpeed = soundPitch

                local ok, asset = pcall(function()
                    if getcustomasset then
                        return getcustomasset(path)
                    elseif getsynasset then
                        return getsynasset(path)
                    else
                        return 'rbxassetid://6565367558'
                    end
                end)

                if ok and asset then
                    sound.SoundId = asset
                    sound.Parent = ws

                    sound:Play()
                    sound.Ended:Connect(function()
                        sound:Destroy()
                    end)
                end
            end
        end

        local effectTemplates = {}

        local function createEffectTemplates()
            -- [Particle templates remain the same as in your original code]
            -- Keeping them short for brevity, but they should be copied from your original
        end
        local function createHitEffect(target)
            if not effectsEnabled then
                return
            end

            local currentTime = tick()

            if currentTime - lastEffectTime < 0.2 then
                return
            end

            lastEffectTime = currentTime

            if not target or not target.Character then
                return
            end

            local hrp = target.Character:FindFirstChild('HumanoidRootPart')

            if not hrp then
                return
            end
            if not next(effectTemplates) then
                createEffectTemplates()
            end

            local template = effectTemplates[effectsType]

            if not template then
                return
            end

            local effect = template:Clone()

            for _, child in pairs(effect:GetDescendants())do
                if child:IsA('ParticleEmitter') then
                    child.Color = ColorSequence.new(effectsColor)
                elseif child:IsA('Beam') then
                    child.Color = ColorSequence.new(effectsColor)
                elseif child:IsA('Trail') then
                    child.Color = ColorSequence.new(effectsColor)
                end
            end

            effect.Parent = hrp

            for _, child in pairs(effect:GetDescendants())do
                if child:IsA('ParticleEmitter') then
                    child:Emit(child.Rate or 100)
                end
            end

            task.delay(2, function()
                if effect and effect.Parent then
                    effect:Destroy()
                end
            end)
        end
        local function createHitScreen()
            if not screenEnabled then
                return
            end

            local currentTime = tick()

            if currentTime - lastScreenTime < 0.2 then
                return
            end

            lastScreenTime = currentTime

            local playerGui = lp:FindFirstChild('PlayerGui')

            if not playerGui then
                return
            end

            local screenGui = Instance.new('ScreenGui')

            screenGui.Name = 'HitScreen'
            screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            screenGui.IgnoreGuiInset = true
            screenGui.Parent = playerGui

            local imageLabel = Instance.new('ImageLabel')

            imageLabel.Size = UDim2.new(1, 0, 1, 0)
            imageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
            imageLabel.BackgroundTransparency = 1
            imageLabel.BorderSizePixel = 0
            imageLabel.Image = 'rbxassetid://1066498967'
            imageLabel.ImageColor3 = screenColor
            imageLabel.ImageTransparency = screenTransparency
            imageLabel.Parent = screenGui

            task.delay(screenDuration, function()
                if screenGui and screenGui.Parent then
                    screenGui:Destroy()
                end
            end)
        end

        function hitEffects:onHit(target)
            if chamsEnabled then
                createHitChams(target)
            end
            if soundsEnabled then
                playHitSound()
            end
            if effectsEnabled then
                createHitEffect(target)
            end
            if screenEnabled then
                createHitScreen()
            end
        end
        function hitEffects:setChamsEnabled(v)
            chamsEnabled = v
        end
        function hitEffects:setChamsColor(c)
            chamsColor = c
        end
        function hitEffects:setChamsMaterial(m)
            local mats = {
                Neon = Enum.Material.Neon,
                ForceField = Enum.Material.ForceField,
                Glass = Enum.Material.Glass,
                Plastic = Enum.Material.Plastic,
                Metal = Enum.Material.Metal,
                Concrete = Enum.Material.Concrete,
            }

            chamsMaterial = mats[m] or Enum.Material.Neon
        end
        function hitEffects:setChamsDuration(d)
            chamsDuration = d
        end
        function hitEffects:setChamsTransparency(t)
            chamsTransparency = t
        end
        function hitEffects:setSoundsEnabled(v)
            soundsEnabled = v
        end
        function hitEffects:setSoundVolume(v)
            soundVolume = v
        end
        function hitEffects:setSoundPitch(p)
            soundPitch = p
        end
        function hitEffects:setSoundSelection(s)
            soundSelection = s
        end
        function hitEffects:getAvailableSounds()
            return availableSounds
        end
        function hitEffects:setEffectsEnabled(v)
            effectsEnabled = v
        end
        function hitEffects:setEffectsColor(c)
            effectsColor = c
        end
        function hitEffects:setEffectsType(t)
            effectsType = t
        end
        function hitEffects:setScreenEnabled(v)
            screenEnabled = v
        end
        function hitEffects:setScreenColor(c)
            screenColor = c
        end
        function hitEffects:setScreenTransparency(t)
            screenTransparency = t
        end
        function hitEffects:setScreenDuration(d)
            screenDuration = d
        end

        loadSounds()

        return hitEffects
    end
end

local hitEffects = __modImpl()({lp = LocalPlayer, spawn = task.spawn, wait = task.wait})

-- Aura Module (using flags)
local AuraModule = function()
    return function(api)
        local selfAura = {}
        local lp = api.lp
        local spawn = api.spawn or task.spawn
        local wait = api.wait or task.wait
        local enabled = false
        local auraColor = Color3.fromRGB(133, 220, 255)
        local auraTypes = {}
        local attachments = {}
        local particles = {}
        local charConnection
        
        local function clearAll()
            for _, att in attachments do
                if att and att.Parent then att:Destroy() end
            end
            attachments = {}
            particles = {}
        end
        
        local function updateColors()
            for _, p in particles do
                if p and p.Parent then
                    p.Color = ColorSequence.new(auraColor)
                end
            end
        end
        
        local function createAngelic()
            local character = lp.Character
            if not character then return end
            local torso = character:FindFirstChild('Torso') or character:FindFirstChild('UpperTorso')
            if not torso then return end
            
            local attachment1 = Instance.new('Attachment')
            attachment1.CFrame = CFrame.new(-1.012, 0.5, 0.852, 0.966, 0, 0.259, 0, 1, 0, -0.259, 0, 0.966)
            attachment1.Parent = torso
            table.insert(attachments, attachment1)
            
            local emitter1 = Instance.new('ParticleEmitter')
            emitter1.Lifetime = NumberRange.new(1, 1)
            emitter1.LockedToPart = true
            emitter1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.944), NumberSequenceKeypoint.new(0.2, 0), NumberSequenceKeypoint.new(0.8, 0), NumberSequenceKeypoint.new(1, 1)})
            emitter1.LightEmission = 1
            emitter1.Color = ColorSequence.new(auraColor)
            emitter1.Speed = NumberRange.new(0.05, 0.05)
            emitter1.Size = NumberSequence.new(2.75, 3.5)
            emitter1.Rate = 4
            emitter1.Texture = 'http://www.roblox.com/asset/?id=13267054240'
            emitter1.EmissionDirection = Enum.NormalId.Back
            emitter1.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            emitter1.Rotation = NumberRange.new(-15, -15)
            emitter1.Parent = attachment1
            table.insert(particles, emitter1)
            
            local attachment2 = Instance.new('Attachment')
            attachment2.CFrame = CFrame.new(1.167, 0.5, 0.852, 0.966, 0, -0.259, 0, 1, 0, 0.259, 0, 0.966)
            attachment2.Parent = torso
            table.insert(attachments, attachment2)
            
            local emitter2 = Instance.new('ParticleEmitter')
            emitter2.Lifetime = NumberRange.new(1, 1)
            emitter2.LockedToPart = true
            emitter2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.944), NumberSequenceKeypoint.new(0.2, 0), NumberSequenceKeypoint.new(0.8, 0), NumberSequenceKeypoint.new(1, 1)})
            emitter2.LightEmission = 1
            emitter2.Color = ColorSequence.new(auraColor)
            emitter2.Speed = NumberRange.new(0.05, 0.05)
            emitter2.Size = NumberSequence.new(2.75, 3.5)
            emitter2.Rate = 4
            emitter2.Texture = 'http://www.roblox.com/asset/?id=13267054240'
            emitter2.EmissionDirection = Enum.NormalId.Front
            emitter2.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            emitter2.Rotation = NumberRange.new(-15, -15)
            emitter2.Parent = attachment2
            table.insert(particles, emitter2)
            
            local attachment3 = Instance.new('Attachment')
            attachment3.CFrame = CFrame.new(0, 0.3, 0)
            attachment3.Parent = torso
            table.insert(attachments, attachment3)
            
            local emitter3 = Instance.new('ParticleEmitter')
            emitter3.Lifetime = NumberRange.new(2, 2)
            emitter3.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
            emitter3.SpreadAngle = Vector2.new(180, 180)
            emitter3.LockedToPart = true
            emitter3.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.3), NumberSequenceKeypoint.new(1, 1)})
            emitter3.LightEmission = 1
            emitter3.Color = ColorSequence.new(auraColor)
            emitter3.VelocitySpread = 180
            emitter3.Speed = NumberRange.new(0.5, 0.5)
            emitter3.Brightness = 2
            emitter3.Size = NumberSequence.new(3, 4)
            emitter3.Rate = 5
            emitter3.Texture = 'rbxassetid://11402221943'
            emitter3.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
            emitter3.Rotation = NumberRange.new(0, 360)
            emitter3.Parent = attachment3
            table.insert(particles, emitter3)
        end
        
        local function createAmbient()
            local character = lp.Character
            if not character then return end
            local hrp = character:FindFirstChild('HumanoidRootPart')
            if not hrp then return end
            
            local attachment = Instance.new('Attachment')
            attachment.CFrame = CFrame.new(0, -2.75, 0)
            attachment.Parent = hrp
            table.insert(attachments, attachment)
            
            local emitter1 = Instance.new('ParticleEmitter')
            emitter1.Lifetime = NumberRange.new(2, 2)
            emitter1.SpreadAngle = Vector2.new(0.001, 0.001)
            emitter1.LockedToPart = true
            emitter1.Transparency = NumberSequence.new(0, 1)
            emitter1.LightEmission = 1
            emitter1.Color = ColorSequence.new(auraColor)
            emitter1.VelocitySpread = 0.001
            emitter1.Squash = NumberSequence.new(0)
            emitter1.Speed = NumberRange.new(0.001, 0.001)
            emitter1.Brightness = 2
            emitter1.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.3, 1), NumberSequenceKeypoint.new(0.6, 2.5), NumberSequenceKeypoint.new(0.8, 4), NumberSequenceKeypoint.new(1, 6)})
            emitter1.RotSpeed = NumberRange.new(-600, 600)
            emitter1.Texture = 'https://assetgame.roblox.com/asset/?id=12713358087&assetName=crescent'
            emitter1.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            emitter1.Rotation = NumberRange.new(0, 360)
            emitter1.Parent = attachment
            table.insert(particles, emitter1)
            
            local emitter2 = Instance.new('ParticleEmitter')
            emitter2.Lifetime = NumberRange.new(2, 2)
            emitter2.SpreadAngle = Vector2.new(0.001, 0.001)
            emitter2.LockedToPart = true
            emitter2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.6, 0.2), NumberSequenceKeypoint.new(1, 1)})
            emitter2.LightEmission = 1
            emitter2.Color = ColorSequence.new(auraColor)
            emitter2.VelocitySpread = 0.001
            emitter2.Squash = NumberSequence.new(0, 2)
            emitter2.Speed = NumberRange.new(0.001, 0.001)
            emitter2.Brightness = 2
            emitter2.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.3, 1), NumberSequenceKeypoint.new(0.6, 2.5), NumberSequenceKeypoint.new(0.8, 4), NumberSequenceKeypoint.new(1, 6)})
            emitter2.RotSpeed = NumberRange.new(-30, 30)
            emitter2.Texture = 'rbxassetid://7216849325'
            emitter2.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            emitter2.Rotation = NumberRange.new(0, 360)
            emitter2.Parent = attachment
            table.insert(particles, emitter2)
            
            local emitter3 = Instance.new('ParticleEmitter')
            emitter3.Lifetime = NumberRange.new(2, 2)
            emitter3.SpreadAngle = Vector2.new(0.001, 0.001)
            emitter3.LockedToPart = true
            emitter3.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.2, 0.3), NumberSequenceKeypoint.new(1, 1)})
            emitter3.LightEmission = 1
            emitter3.Color = ColorSequence.new(auraColor)
            emitter3.VelocitySpread = 0.001
            emitter3.Squash = NumberSequence.new(0)
            emitter3.Speed = NumberRange.new(0.001, 0.001)
            emitter3.Brightness = 2
            emitter3.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.3, 2), NumberSequenceKeypoint.new(0.6, 5), NumberSequenceKeypoint.new(0.8, 8), NumberSequenceKeypoint.new(1, 12)})
            emitter3.RotSpeed = NumberRange.new(-40, 40)
            emitter3.Texture = 'rbxassetid://7216855136'
            emitter3.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            emitter3.Rotation = NumberRange.new(0, 360)
            emitter3.Parent = attachment
            table.insert(particles, emitter3)
        end
        
        local function createNimb()
            local character = lp.Character
            if not character then return end
            local head = character:FindFirstChild('Head')
            if not head then return end
            
            local attachment = Instance.new('Attachment')
            attachment.CFrame = CFrame.new(-0.25, 0.933, 0.259, 0.469, -0.25, -0.847, -0.117, 0.933, -0.34, 0.875, 0.259, 0.408)
            attachment.Parent = head
            table.insert(attachments, attachment)
            
            local emitter1 = Instance.new('ParticleEmitter')
            emitter1.Lifetime = NumberRange.new(1, 1)
            emitter1.SpreadAngle = Vector2.new(5, 5)
            emitter1.LockedToPart = true
            emitter1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.2, 0), NumberSequenceKeypoint.new(0.8, 0), NumberSequenceKeypoint.new(1, 1)})
            emitter1.LightEmission = 1
            emitter1.Color = ColorSequence.new(auraColor)
            emitter1.VelocitySpread = 5
            emitter1.Speed = NumberRange.new(0.001, 0.001)
            emitter1.Brightness = 2
            emitter1.Size = NumberSequence.new(2.5, 3)
            emitter1.RotSpeed = NumberRange.new(-400, 400)
            emitter1.Rate = 7
            emitter1.Texture = 'rbxassetid://8819682608'
            emitter1.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            emitter1.Rotation = NumberRange.new(0, 360)
            emitter1.Parent = attachment
            table.insert(particles, emitter1)
            
            local emitter2 = Instance.new('ParticleEmitter')
            emitter2.Lifetime = NumberRange.new(1, 1)
            emitter2.SpreadAngle = Vector2.new(5, 5)
            emitter2.LockedToPart = true
            emitter2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.2, 0), NumberSequenceKeypoint.new(0.8, 0), NumberSequenceKeypoint.new(1, 1)})
            emitter2.LightEmission = 1
            emitter2.Color = ColorSequence.new(auraColor)
            emitter2.VelocitySpread = 5
            emitter2.Speed = NumberRange.new(0.001, 0.001)
            emitter2.Brightness = 2
            emitter2.Size = NumberSequence.new(2, 3)
            emitter2.RotSpeed = NumberRange.new(-400, 400)
            emitter2.Rate = 7
            emitter2.Texture = 'rbxassetid://8819682608'
            emitter2.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            emitter2.Rotation = NumberRange.new(0, 360)
            emitter2.Parent = attachment
            table.insert(particles, emitter2)
        end
        
        local function createTornado()
            local character = lp.Character
            if not character then return end
            local hrp = character:FindFirstChild('HumanoidRootPart')
            if not hrp then return end
            
            local attachment = Instance.new('Attachment')
            attachment.CFrame = CFrame.new(0, -3, 0)
            attachment.Parent = hrp
            table.insert(attachments, attachment)
            
            local emitter = Instance.new('ParticleEmitter')
            emitter.LightInfluence = 1
            emitter.LockedToPart = true
            emitter.LightEmission = 1
            emitter.Color = ColorSequence.new(auraColor)
            emitter.Speed = NumberRange.new(0.01, 0.01)
            emitter.Size = NumberSequence.new(6, 10)
            emitter.RotSpeed = NumberRange.new(360, 360)
            emitter.Rate = 1
            emitter.Texture = 'http://www.roblox.com/asset/?id=8553497052'
            emitter.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            emitter.Parent = attachment
            table.insert(particles, emitter)
        end
        
        local function refreshAuras()
            if not enabled then clearAll() return end
            clearAll()
            if auraTypes['Angelic'] then createAngelic() end
            if auraTypes['Ambient'] then createAmbient() end
            if auraTypes['Nimb'] then createNimb() end
            if auraTypes['Tornado'] then createTornado() end
        end
        
        local function onCharacterAdded()
            if enabled then
                wait(0.5)
                refreshAuras()
            end
        end
        
        function selfAura:setEnabled(val)
            enabled = val
            Library.Flags.self_aura_main = val
            if val then
                if not charConnection then
                    charConnection = lp.CharacterAdded:Connect(onCharacterAdded)
                end
                if lp.Character then
                    spawn(function()
                        wait(0.5)
                        refreshAuras()
                    end)
                end
            else
                if charConnection then
                    charConnection:Disconnect()
                    charConnection = nil
                end
                clearAll()
            end
        end
        
        function selfAura:setAuraTypes(types)
            auraTypes = {}
            if type(types) == 'table' then
                for _, auraType in ipairs(types) do
                    auraTypes[auraType] = true
                end
            end
            Library.Flags.self_aura_types = types
            refreshAuras()
        end
        
        function selfAura:setAuraColor(color)
            auraColor = color
            Library.Flags.self_aura_color = color
            if enabled and #particles > 0 then
                updateColors()
            end
        end
        
        return selfAura
    end
end

local Aura = AuraModule()({lp = LocalPlayer, spawn = task.spawn, wait = task.wait})

-- Silent Aim Functions (using flags)
local function IsKnocked(character)
    local bodyEffects = character:FindFirstChild("BodyEffects")
    local ko = bodyEffects and bodyEffects:FindFirstChild("K.O")
    return ko and ko.Value
end

local function GetClosestPart(character)
    local mousePos = UserInputService:GetMouseLocation()
    local minDistance = math.huge
    local closestPart = nil
    
    for _, partName in ipairs(parts) do
        local part = character:FindFirstChild(partName)
        if part then
            local screenPos, visible = Camera:WorldToScreenPoint(part.Position)
            if visible then
                local distance = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                local fovRadius = Library.Flags.fov_sync and Library.Flags.fov_size or math.huge
                if distance < minDistance and distance <= fovRadius then
                    minDistance = distance
                    closestPart = part
                end
            end
        end
    end
    
    return closestPart
end

local function GetClosestPlayer(feature)
    local mousePos = UserInputService:GetMouseLocation()
    local minDistance = math.huge
    local closestPlayer = nil
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            local humanoid = character and character:FindFirstChild("Humanoid")
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart and humanoid.Health > 0 then
                if feature == "SilentAim" and Library.Flags.silentaim_check_team and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then continue end
                if feature == "AimAssist" and Library.Flags.aimassist_check_team and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then continue end
                
                local screenPos, visible = Camera:WorldToScreenPoint(rootPart.Position)
                if visible then
                    local distance = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    local fovRadius = Library.Flags.fov_sync and Library.Flags.fov_size or math.huge
                    if distance < minDistance and distance <= fovRadius then
                        minDistance = distance
                        closestPlayer = {Character = character, Player = player}
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local function GetPlayerInFOV(feature)
    local mousePos = UserInputService:GetMouseLocation()
    local fovRadius = Library.Flags.fov_size
    local candidates = {}
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            local humanoid = character and character:FindFirstChild("Humanoid")
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart and humanoid.Health > 0 then
                if feature == "SilentAim" and Library.Flags.silentaim_check_team and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then continue end
                if feature == "AimAssist" and Library.Flags.aimassist_check_team and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then continue end
                
                local screenPos, visible = Camera:WorldToScreenPoint(rootPart.Position)
                if visible then
                    local distance = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    if distance <= fovRadius then
                        table.insert(candidates, {Character = character, Player = player, Distance = distance})
                    end
                end
            end
        end
    end
    
    if #candidates == 0 then return nil end
    table.sort(candidates, function(a,b) return a.Distance < b.Distance end)
    return candidates[1]
end

local function IsVisible(part)
    local origin = Camera.CFrame.Position
    local targetPos = part.Position
    local direction = (targetPos - origin).Unit
    local distance = (targetPos - origin).Magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, part.Parent}
    raycastParams.IgnoreWater = true
    local result = workspace:Raycast(origin, direction * distance, raycastParams)
    return not result
end

local function GetAimedPart(character, feature)
    local useNearest = (feature == "SilentAim" and false) or (feature == "AimAssist" and false) -- You can add flags for these if needed
    local humanoid = character:FindFirstChild("Humanoid")
    local jumping = humanoid and humanoid:GetState() == Enum.HumanoidStateType.Freefall
    local partName = jumping and (feature == "SilentAim" and Library.Flags.silentaim_airpart or Library.Flags.aimassist_airpart) or (feature == "SilentAim" and Library.Flags.silentaim_hitpart or Library.Flags.aimassist_hitpart)
    local part = useNearest and GetClosestPart(character) or character:FindFirstChild(partName)
    return part
end

local function UpdateSilentAimTarget()
    local mode = Library.Flags.fov_targetmode
    if mode == 'Keybind' then return
    elseif mode == 'InsideFOV' then
        local newTarget = GetPlayerInFOV("SilentAim")
        if newTarget then Target = newTarget SilentAimActive = true else SilentAimActive = false Target = nil end
    elseif mode == 'Closest' then
        local newTarget = GetClosestPlayer("SilentAim")
        if newTarget then Target = newTarget SilentAimActive = true else SilentAimActive = false Target = nil end
    end
end

local function checkFunc()
    if not Library.Flags.silentaim_enabled then return end
    local mode = Library.Flags.fov_targetmode
    if mode ~= 'Keybind' then UpdateSilentAimTarget() end
    
    if Target and SilentAimActive then
        local feature = "SilentAim"
        local player = Target.Player
        local character = Target.Character
        local humanoid = character:FindFirstChild("Humanoid")
        local part = GetAimedPart(character, feature)
        
        if not humanoid or humanoid.Health <= 0 then
            SilentAimActive = false
            Target = nil
            return
        end
        
        if Library.Flags.silentaim_check_knocked and IsKnocked(character) then
            SilentAimActive = false
            Target = nil
            return
        end
        
        if Library.Flags.silentaim_check_visible and not IsVisible(part) then
            SilentAimActive = false
            Target = nil
            return
        end
    end
end

local function aimAssistFunc()
    if not AimAssistActive or not Target or not Target.Character then return end
    
    local feature = "AimAssist"
    local character = Target.Character
    local player = Target.Player
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not humanoid or humanoid.Health <= 0 then
        AimAssistActive = false
        if not SilentAimActive then Target = nil end
        return
    end
    
    local part = GetAimedPart(character, feature)
    if not part then
        AimAssistActive = false
        if not SilentAimActive then Target = nil end
        return
    end
    
    if IsKnocked(character) or (Library.Flags.aimassist_check_visible and not IsVisible(part)) then
        AimAssistActive = false
        if not SilentAimActive then Target = nil end
        return
    end
    
    local prediction = Library.Flags.aimassist_prediction or 0
    local jumpOffset = Library.Flags.aimassist_jumpoffset or 0
    local fallOffset = Library.Flags.aimassist_falloffset or 0
    local velocityY = part.Velocity.Y
    local offsetY = velocityY > 1 and jumpOffset or velocityY < -1 and fallOffset or 0
    local aimPosition = part.Position + part.Velocity * prediction + Vector3.new(0, offsetY, 0)
    
    local targetCFrame = CFrame.new(Camera.CFrame.Position, aimPosition)
    local smoothness = Library.Flags.aimassist_smoothness or 0
    local easingStyle = Enum.EasingStyle[Library.Flags.aimassist_easing_first or "Cubic"]
    local easingDirection = Enum.EasingDirection[Library.Flags.aimassist_easing_second or "InOut"]
    
    Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, smoothness, easingStyle, easingDirection)
end

-- Silent Aim Metatable Hook
local mt = getrawmetatable(game)
local oldIndex = mt.__index
local oldNamecall = mt.__namecall
setreadonly(mt, false)

local Mouse = LocalPlayer:GetMouse()

mt.__index = newcclosure(function(self, key)
    if not checkcaller() then
        if self == Mouse and (key == "Hit" or key == "Target") then
            if Library.Flags.silentaim_enabled and SilentAimActive and Target and Target.Character then
                local character = Target.Character
                local humanoid = character:FindFirstChild("Humanoid")
                
                if humanoid and humanoid.Health > 0 then
                    local part = character:FindFirstChild(Library.Flags.silentaim_hitpart or "Head") or character:FindFirstChild("Head")
                    
                    if part then
                        if Library.Flags.silentaim_check_knocked and IsKnocked(character) then
                            SilentAimActive = false
                            Target = nil
                            return oldIndex(self, key)
                        end
                        
                        if Library.Flags.silentaim_check_visible and not IsVisible(part) then
                            SilentAimActive = false
                            Target = nil
                            return oldIndex(self, key)
                        end
                        
                        local prediction = Library.Flags.silentaim_prediction or 0
                        local jumpOffset = Library.Flags.silentaim_jumpoffset or 0
                        local fallOffset = Library.Flags.silentaim_falloffset or 0
                        local velocity = part.Velocity
                        local position = part.Position + (velocity * prediction)
                        local velocityY = velocity.Y
                        local offsetY = velocityY > 1 and jumpOffset or velocityY < -1 and fallOffset or 0
                        local finalPosition = position + Vector3.new(0, offsetY, 0)
                        
                        if key == "Hit" then
                            return CFrame.new(finalPosition)
                        elseif key == "Target" then
                            return part
                        end
                    end
                end
            end
        end
    end
    
    return oldIndex(self, key)
end)

mt.__namecall = newcclosure(function(self, ...)
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- Blur effect for menu
local BlurEnabled = false
local WindowOpen = false
local Lighting = game:GetService("Lighting")
local blur = Instance.new("BlurEffect")
blur.Name = "stride_Blur"
blur.Size = 80
blur.Parent = nil

local function updateBlur()
    if BlurEnabled and WindowOpen then
        blur.Parent = Lighting
    else
        blur.Parent = nil
    end
end

local oldSetOpen = Window.SetOpen
Window.SetOpen = function(self, Bool)
    oldSetOpen(self, Bool)
    WindowOpen = Bool
    updateBlur()
end

updateBlur()

-- ==================== COMBAT TAB ====================
do
    -- Silent Aim Section (Left Side)
    local silentaim_section = CombatTab:Section({
        Name = 'Silent Aim',
        Side = 'left',
    })
    
    local silentaim_toggle = silentaim_section:Toggle({
        Name = 'Enabled',
        Value = false,
        Callback = function(v)
            Library.Flags.silentaim_enabled = v
            if not v then 
                SilentAimActive = false 
                if CheckConnection then 
                    CheckConnection:Disconnect() 
                    CheckConnection = nil 
                end 
                if not AimAssistActive then 
                    Target = nil 
                end 
            end
            if v and not CheckConnection then 
                CheckConnection = RunService.RenderStepped:Connect(checkFunc) 
            end
        end,
        Flag = 'silentaim_enabled',
    })
    
    silentaim_toggle:Keybind({
        Key = Enum.KeyCode.Unknown,
        Mode = 'Toggle',
        Callback = function(v)
            if not Library.Flags.silentaim_enabled or Library.Flags.fov_targetmode ~= 'Keybind' then return end
            local newTarget = GetClosestPlayer("SilentAim")
            if v and newTarget then 
                Target = newTarget 
                SilentAimActive = true 
            else 
                SilentAimActive = false 
                if not AimAssistActive then 
                    Target = nil 
                end 
            end
        end,
        Flag = 'silentaim_keybind',
    })
    
    silentaim_section:Slider({
        Name = 'Prediction',
        Value = 0,
        Min = 0,
        Max = 2,
        Float = 0.01,
        Suffix = '%s',
        Callback = function(v)
            Library.Flags.silentaim_prediction = v
        end,
        Flag = 'silentaim_prediction',
    })
    
    silentaim_section:Dropdown({
        Name = 'Hit Part',
        Values = parts,
        Value = 'Head',
        Callback = function(v)
            Library.Flags.silentaim_hitpart = v
        end,
        Flag = 'silentaim_hitpart',
    })
    
    silentaim_section:Dropdown({
        Name = 'Air Part',
        Values = parts,
        Value = 'Head',
        Callback = function(v)
            Library.Flags.silentaim_airpart = v
        end,
        Flag = 'silentaim_airpart',
    })
    
    local counteracts_toggle = silentaim_section:Toggle({
        Name = 'Counteracts',
        Value = false,
        Callback = function(v) end,
        Flag = 'silentaim_counteracts_toggle',
    })
    
    local counteracts_popup = counteracts_toggle:Popup({Size = 150})
    
    counteracts_popup:Slider({
        Name = 'Jump Offset',
        Value = 0,
        Min = -10,
        Max = 10,
        Float = 0.01,
        Suffix = '%s',
        Callback = function(v)
            Library.Flags.silentaim_jumpoffset = v
        end,
        Flag = 'silentaim_jumpoffset',
    })
    
    counteracts_popup:Slider({
        Name = 'Fall Offset',
        Value = 0,
        Min = -10,
        Max = 10,
        Float = 0.01,
        Suffix = '%s',
        Callback = function(v)
            Library.Flags.silentaim_falloffset = v
        end,
        Flag = 'silentaim_falloffset',
    })
    
    local checks_toggle = silentaim_section:Toggle({
        Name = 'Checks',
        Value = false,
        Callback = function(v) end,
        Flag = 'silentaim_checks_toggle',
    })
    
    local checks_popup = checks_toggle:Popup({Size = 150})
    
    checks_popup:Toggle({
        Name = 'Knocked',
        Value = true,
        Callback = function(v)
            Library.Flags.silentaim_check_knocked = v
        end,
        Flag = 'silentaim_check_knocked',
    })
    
    checks_popup:Toggle({
        Name = 'Visible',
        Value = false,
        Callback = function(v)
            Library.Flags.silentaim_check_visible = v
        end,
        Flag = 'silentaim_check_visible',
    })
    
    checks_popup:Toggle({
        Name = 'Team Check',
        Value = false,
        Callback = function(v)
            Library.Flags.silentaim_check_team = v
        end,
        Flag = 'silentaim_check_team',
    })
    
    -- FOV Section (Left Side)
    local fov_section = CombatTab:Section({
        Name = 'FOV',
        Side = 'left',
    })
    
    fov_section:Toggle({
        Name = 'Sync',
        Value = false,
        Callback = function(v)
            Library.Flags.fov_sync = v
        end,
        Flag = 'fov_sync',
    })
    
    fov_section:Dropdown({
        Name = 'Target Mode',
        Values = {'Keybind', 'InsideFOV', 'Closest'},
        Value = 'Keybind',
        Callback = function(v)
            Library.Flags.fov_targetmode = v
        end,
        Flag = 'fov_targetmode',
    })
    
    local fov_visual_toggle = fov_section:Toggle({
        Name = 'Visual',
        Value = false,
        Callback = function(v)
            Library.Flags.fov_visual = v
        end,
        Flag = 'fov_visual',
    })
    
    fov_visual_toggle:Colorpicker({
        Value = Color3.fromRGB(77, 77, 77),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.fov_color = d.c
        end,
        Flag = 'fov_color',
    })
    
    fov_section:Slider({
        Name = 'FOV Size',
        Value = 155,
        Min = 0,
        Max = 1000,
        Float = 1,
        Suffix = '%s',
        Callback = function(v)
            Library.Flags.fov_size = v
        end,
        Flag = 'fov_size',
    })
    
    local fov_filled_toggle = fov_section:Toggle({
        Name = 'Filled',
        Value = false,
        Callback = function(v)
            Library.Flags.fov_filled = v
        end,
        Flag = 'fov_filled',
    })
    
    fov_filled_toggle:Colorpicker({
        Value = Color3.fromRGB(77, 77, 77),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.fov_fillcolor = d.c
        end,
        Flag = 'fov_fillcolor',
    })
    
    local fov_gradient_toggle = fov_section:Toggle({
        Name = 'Gradient',
        Value = false,
        Callback = function(v)
            Library.Flags.fov_gradient = v
        end,
        Flag = 'fov_gradient',
    })
    
    fov_gradient_toggle:Colorpicker({
        Name = 'Start Color',
        Value = Color3.fromRGB(0, 0, 0),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.fov_gradient_start = d.c
        end,
        Flag = 'fov_gradient_start',
    })
    
    fov_gradient_toggle:Colorpicker({
        Name = 'End Color',
        Value = Color3.fromRGB(255, 255, 255),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.fov_gradient_end = d.c
        end,
        Flag = 'fov_gradient_end',
    })
    
    fov_section:Slider({
        Name = 'Transparency',
        Value = 75,
        Min = 0,
        Max = 100,
        Float = 1,
        Suffix = '%s',
        Callback = function(v)
            Library.Flags.fov_transparency = v
        end,
        Flag = 'fov_transparency',
    })
    
    -- Aim Assist Section (Right Side)
    local aimassist_section = CombatTab:Section({
        Name = 'Aim Assist',
        Side = 'right',
    })
    
    local aimassist_toggle = aimassist_section:Toggle({
        Name = 'Enabled',
        Value = false,
        Callback = function(v)
            Library.Flags.aimassist_enabled = v
            if not v then 
                AimAssistActive = false 
                if AimAssistConnection then 
                    AimAssistConnection:Disconnect() 
                    AimAssistConnection = nil 
                end 
                if not SilentAimActive then 
                    Target = nil 
                end 
            end
            if v and not AimAssistConnection then 
                AimAssistConnection = RunService.RenderStepped:Connect(aimAssistFunc) 
            end
        end,
        Flag = 'aimassist_enabled',
    })
    
    aimassist_toggle:Keybind({
        Key = Enum.KeyCode.Unknown,
        Mode = 'Toggle',
        Callback = function(v)
            if not Library.Flags.aimassist_enabled then return end
            local newTarget = GetClosestPlayer("AimAssist")
            if v and newTarget then
                Target = newTarget
                AimAssistActive = true
                if not AimAssistConnection then 
                    AimAssistConnection = RunService.RenderStepped:Connect(aimAssistFunc) 
                end
            else
                AimAssistActive = false
                if not SilentAimActive then Target = nil end
                if AimAssistConnection then 
                    AimAssistConnection:Disconnect() 
                    AimAssistConnection = nil 
                end
            end
        end,
        Flag = 'aimassist_keybind',
    })
    
    aimassist_section:Slider({
        Name = 'Prediction',
        Value = 0,
        Min = 0,
        Max = 2,
        Float = 0.001,
        Suffix = '%s',
        Callback = function(v)
            Library.Flags.aimassist_prediction = v
        end,
        Flag = 'aimassist_prediction',
    })
    
    aimassist_section:Slider({
        Name = 'Smoothness',
        Value = 0,
        Min = 0,
        Max = 1,
        Float = 0.001,
        Suffix = '%s',
        Callback = function(v)
            Library.Flags.aimassist_smoothness = v
        end,
        Flag = 'aimassist_smoothness',
    })
    
    aimassist_section:Dropdown({
        Name = 'Hit Part',
        Values = parts,
        Value = 'Head',
        Callback = function(v)
            Library.Flags.aimassist_hitpart = v
        end,
        Flag = 'aimassist_hitpart',
    })
    
    aimassist_section:Dropdown({
        Name = 'Air Part',
        Values = parts,
        Value = 'Head',
        Callback = function(v)
            Library.Flags.aimassist_airpart = v
        end,
        Flag = 'aimassist_airpart',
    })
    
    local aimassist_counteracts_toggle = aimassist_section:Toggle({
        Name = 'Counteracts',
        Value = false,
        Callback = function(v) end,
        Flag = 'aimassist_counteracts_toggle',
    })
    
    local aimassist_counteracts_popup = aimassist_counteracts_toggle:Popup({Size = 150})
    
    aimassist_counteracts_popup:Slider({
        Name = 'Jump Offset',
        Value = 0,
        Min = -10,
        Max = 10,
        Float = 0.01,
        Suffix = '%s',
        Callback = function(v)
            Library.Flags.aimassist_jumpoffset = v
        end,
        Flag = 'aimassist_jumpoffset',
    })
    
    aimassist_counteracts_popup:Slider({
        Name = 'Fall Offset',
        Value = 0,
        Min = -10,
        Max = 10,
        Float = 0.01,
        Suffix = '%s',
        Callback = function(v)
            Library.Flags.aimassist_falloffset = v
        end,
        Flag = 'aimassist_falloffset',
    })
    
    local aimassist_checks_toggle = aimassist_section:Toggle({
        Name = 'Checks',
        Value = false,
        Callback = function(v) end,
        Flag = 'aimassist_checks_toggle',
    })
    
    local aimassist_checks_popup = aimassist_checks_toggle:Popup({Size = 150})
    
    aimassist_checks_popup:Toggle({
        Name = 'Knocked',
        Value = false,
        Callback = function(v)
            Library.Flags.aimassist_check_knocked = v
        end,
        Flag = 'aimassist_check_knocked',
    })
    
    aimassist_checks_popup:Toggle({
        Name = 'Visible',
        Value = false,
        Callback = function(v)
            Library.Flags.aimassist_check_visible = v
        end,
        Flag = 'aimassist_check_visible',
    })
    
    aimassist_checks_popup:Toggle({
        Name = 'Team Check',
        Value = false,
        Callback = function(v)
            Library.Flags.aimassist_check_team = v
        end,
        Flag = 'aimassist_check_team',
    })
    
    local easing_toggle = aimassist_section:Toggle({
        Name = 'Easing Style',
        Value = false,
        Callback = function(v) end,
        Flag = 'aimassist_easing_toggle',
    })
    
    local easing_popup = easing_toggle:Popup({Size = 150})
    
    easing_popup:Dropdown({
        Name = 'First',
        Values = easingStyles,
        Value = 'Cubic',
        Callback = function(v)
            Library.Flags.aimassist_easing_first = v
        end,
        Flag = 'aimassist_easing_first',
    })
    
    easing_popup:Dropdown({
        Name = 'Second',
        Values = easingDirections,
        Value = 'InOut',
        Callback = function(v)
            Library.Flags.aimassist_easing_second = v
        end,
        Flag = 'aimassist_easing_second',
    })
end

-- ==================== MISC TAB ====================
do
    -- Ragebot Section (Left Side)
    local ragebot_section = MiscTab:Section({
        Name = "Ragebot",
        Side = "left",
    })

    local ragebot_toggle = ragebot_section:Toggle({
        Name = "Ragebot",
        Value = false,
        Flag = "ragebot_enabled",
        Callback = function(v)
            Library.Flags.ragebot_enabled = v
        end
    })

    ragebot_toggle:Keybind({
        Name = "Ragebot Key",
        Key = Enum.KeyCode.Unknown,
        Mode = "Toggle",
        Flag = "ragebot_keybind",
        Callback = function(v)
            if not Library.Flags.ragebot_enabled then return end
            if v then
                local filters = {
                    SkipKO = Library.Flags.skip_ko,
                    SkipGrabbed = Library.Flags.skip_grabbed,
                    SkipDead = Library.Flags.skip_dead,
                    SkipFF = Library.Flags.skip_ff,
                }
                Targeting:SetTarget(true, filters)
            else
                Targeting:ClearTarget()
            end
        end
    })

    local ragebot_popup = ragebot_toggle:Popup({Size = 200})

    ragebot_popup:Toggle({
        Name = "knocked",
        Value = false,
        Flag = "skip_ko"
    })

    ragebot_popup:Toggle({
        Name = "grabbed",
        Value = false,
        Flag = "skip_grabbed"
    })

    ragebot_popup:Toggle({
        Name = "dead",
        Value = false,
        Flag = "skip_dead"
    })

    ragebot_popup:Toggle({
        Name = "forcefield",
        Value = false,
        Flag = "skip_ff"
    })

    -- Auto Fire
    local autofire_toggle = ragebot_section:Toggle({
        Name = "Auto Fire",
        Value = false,
        Flag = "autofire_enabled",
        Callback = function(v)
            Library.Flags.autofire_enabled = v
        end
    })

    local autofire_popup = autofire_toggle:Popup({Size = 200})

    autofire_popup:Slider({
        Name = "Cooldown",
        Value = 4,
        Min = 1,
        Max = 15,
        Float = 1,
        Suffix = "%s ms",
        Flag = "autofire_cooldown",
        Callback = function(v)
            AutoFire:setCooldown(v)
        end
    })

    autofire_popup:Dropdown({
        Name = "Destination",
        Values = {"Head", "Torso", "HumanoidRootPart", "LeftArm", "RightArm", "LeftLeg", "RightLeg", "UpperTorso", "LowerTorso"},
        Value = "Head",
        Flag = "autofire_destination"
    })

    autofire_popup:Dropdown({
        Name = "Origin",
        Values = {"destination", "sway", "upper", "random"},
        Value = "destination",
        Flag = "autofire_origin"
    })

    local checks_toggle = autofire_popup:Toggle({
        Name = "Checks",
        Value = false,
        Flag = "autofire_checks"
    })

    local checks_popup = checks_toggle:Popup({Size = 200})

    checks_popup:Toggle({
        Name = "knocked",
        Value = false,
        Flag = "autofire_check_ko"
    })

    checks_popup:Toggle({
        Name = "Check Forcefield",
        Value = false,
        Flag = "autofire_check_ff"
    })

    checks_popup:Toggle({
        Name = "dead",
        Value = false,
        Flag = "autofire_check_dead"
    })

    checks_popup:Toggle({
        Name = "Grabbed",
        Value = false,
        Flag = "autofire_check_grabbed"
    })

    -- Auto Equip
    local autoequip_toggle = ragebot_section:Toggle({
        Name = "Auto Equip",
        Value = false,
        Flag = "autoequip_enabled"
    })

    local autoequip_popup = autoequip_toggle:Popup({Size = 200})

    autoequip_popup:Toggle({
        Name = "Check if target exists",
        Value = false,
        Flag = "autoequip_check_target"
    })

    autoequip_popup:Dropdown({
        Name = "Guns",
        Values = {"AUG", "Rifle", "LMG", "P90", "Flintlock", "Revolver", "Double-Barrel SG", "AK47", "TacticalShotgun", "Shotgun", "SMG", "DrumGun", "Glock", "Silencer", "AR"},
        Value = {},
        Multi = true,
        Flag = "autoequip_guns"
    })

    -- Visualization Section (Left Side)
    local visualization_section = MiscTab:Section({
        Name = "Visualization",
        Side = "left",
    })

    -- 3D Circle
    local circle_toggle = visualization_section:Toggle({
        Name = "3D Target Circle",
        Value = false,
        Flag = "visualise_circle"
    })

    local circle_popup = circle_toggle:Popup({Size = 200})

    circle_popup:Slider({
        Name = "Thickness",
        Value = 1.5,
        Min = 0.1,
        Max = 3,
        Float = 0.1,
        Flag = "circle_thickness"
    })

    circle_popup:Slider({
        Name = "Radius",
        Value = 2,
        Min = 1,
        Max = 10,
        Float = 0.5,
        Flag = "circle_radius"
    })

    circle_popup:Slider({
        Name = "Visible",
        Value = 35,
        Min = 1,
        Max = 100,
        Float = 1,
        Flag = "circle_visible"
    })

    circle_popup:Slider({
        Name = "Rot Speed",
        Value = 3,
        Min = 1,
        Max = 10,
        Float = 0.5,
        Flag = "circle_rotspeed"
    })

    circle_popup:Colorpicker({
        Name = "Color 1",
        Value = Color3.fromRGB(255,255,255),
        Alpha = 0,
        Flag = "circle_color",
        Callback = function(d)
            General:setCircleColor(d.c)
        end
    })

    circle_popup:Colorpicker({
        Name = "Color 2",
        Value = Color3.fromRGB(255,255,255),
        Alpha = 0,
        Flag = "circle_color2",
        Callback = function(d)
            General:setCircleColor2(d.c)
        end
    })

    circle_popup:Colorpicker({
        Name = "Color 3",
        Value = Color3.fromRGB(255,255,255),
        Alpha = 0,
        Flag = "circle_color3",
        Callback = function(d)
            General:setCircleColor3(d.c)
        end
    })

    circle_popup:Colorpicker({
        Name = "Color 4",
        Value = Color3.fromRGB(255,255,255),
        Alpha = 0,
        Flag = "circle_color4",
        Callback = function(d)
            General:setCircleColor4(d.c)
        end
    })

    -- View
    local view_toggle = visualization_section:Toggle({
        Name = "View",
        Value = false,
        Flag = "visualise_view"
    })

    local view_popup = view_toggle:Popup({Size = 150})

    view_popup:Toggle({
        Name = "Look At",
        Value = false,
        Flag = "visualise_lookat"
    })

    -- Tracer
    local tracer_toggle = visualization_section:Toggle({
        Name = "Tracer",
        Value = false,
        Flag = "visualise_tracer"
    })

    local tracer_popup = tracer_toggle:Popup({Size = 250})

    tracer_popup:Colorpicker({
        Name = "Outline Color",
        Value = Color3.fromRGB(0,0,0),
        Alpha = 0,
        Flag = "tracer_outline",
        Callback = function(d)
            General:setTracerOutlineColor(d.c, d.a)
        end
    })

    tracer_popup:Colorpicker({
        Name = "Main Color",
        Value = Color3.fromRGB(255,255,255),
        Alpha = 0,
        Flag = "tracer_main",
        Callback = function(d)
            General:setTracerMainColor(d.c, d.a)
        end
    })

    tracer_popup:Slider({
        Name = "Outline Thickness",
        Value = 3,
        Min = 0.5,
        Max = 5,
        Float = 0.1,
        Flag = "tracer_outline_thickness",
        Callback = function(v)
            General:setTracerOutlineThickness(v)
        end
    })

    tracer_popup:Slider({
        Name = "Main Thickness",
        Value = 1.5,
        Min = 0.5,
        Max = 5,
        Float = 0.1,
        Flag = "tracer_main_thickness",
        Callback = function(v)
            General:setTracerMainThickness(v)
        end
    })

    tracer_popup:Dropdown({
        Name = "Origin",
        Values = {"mouse", "center", "top", "bottom"},
        Value = "mouse",
        Flag = "tracer_origin"
    })

    tracer_popup:Dropdown({
        Name = "Destination",
        Values = {"HumanoidRootPart", "Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg", "UpperTorso", "LowerTorso"},
        Value = "HumanoidRootPart",
        Flag = "tracer_destination"
    })

    local tracersmooth_toggle = tracer_popup:Toggle({
        Name = "Smooth",
        Value = false,
        Flag = "target_tracer_smooth",
        Callback = function(v)
            General:setTracerSmooth(v)
        end
    })

    local tracersmooth_popup = tracersmooth_toggle:Popup({Size = 150})

    tracersmooth_popup:Dropdown({
        Name = "Type",
        Values = {"ping", "custom"},
        Value = "ping",
        Flag = "target_tracer_smooth_type",
        Callback = function(v)
            General:setTracerSmoothType(v)
        end
    })

    tracersmooth_popup:Slider({
        Name = "Delay",
        Value = 200,
        Min = 10,
        Max = 800,
        Float = 10,
        Suffix = "%s ms",
        Flag = "target_tracer_smooth_delay",
        Callback = function(v)
            General:setTracerCustomDelay(v)
        end
    })

    -- Desync Visuals
    local visualize_toggle = visualization_section:Toggle({
        Name = "Visualize",
        Value = false,
        Flag = "desync_visuals_enabled"
    })

    local visualize_popup = visualize_toggle:Popup({Size = 250})

    -- Dummy sub-popup
    local dummy_toggle = visualize_popup:Toggle({
        Name = "Dummy",
        Value = false,
        Flag = "desync_dummy_enabled",
        Callback = function(v)
            VisualiseDesync:setDummyEnabled(v)
        end
    })

    local dummy_popup = dummy_toggle:Popup({Size = 200})

    dummy_popup:Dropdown({
        Name = "Type",
        Values = {"R6", "Clone"},
        Value = "R6",
        Flag = "desync_dummy_type",
        Callback = function(v)
            VisualiseDesync:setDummyType(v)
        end
    })

    dummy_popup:Dropdown({
        Name = "Material",
        Values = {"Neon", "SmoothPlastic", "Metal", "Glass", "Brick"},
        Value = "Neon",
        Flag = "desync_dummy_material",
        Callback = function(v)
            VisualiseDesync:setDummyMaterial(Enum.Material[v])
        end
    })

    dummy_popup:Colorpicker({
        Name = "Color",
        Value = Color3.fromRGB(255,255,255),
        Alpha = 0.3,
        Flag = "desync_dummy_color",
        Callback = function(d)
            VisualiseDesync:setDummyColor(d.c, d.a)
        end
    })

    -- Tracer sub-popup
    local desynctracer_toggle = visualize_popup:Toggle({
        Name = "Tracer",
        Value = false,
        Flag = "desync_tracer_enabled",
        Callback = function(v)
            VisualiseDesync:setTracerEnabled(v)
        end
    })

    local desynctracer_popup = desynctracer_toggle:Popup({Size = 200})

    desynctracer_popup:Colorpicker({
        Name = "Outline Color",
        Value = Color3.fromRGB(0,0,0),
        Alpha = 0,
        Flag = "desync_tracer_outline",
        Callback = function(d)
            VisualiseDesync:setTracerOutlineColor(d.c, d.a)
        end
    })

    desynctracer_popup:Colorpicker({
        Name = "Main Color",
        Value = Color3.fromRGB(255,255,255),
        Alpha = 0,
        Flag = "desync_tracer_main",
        Callback = function(d)
            VisualiseDesync:setTracerColor(d.c, d.a)
        end
    })

    local desynctracersmooth_toggle = desynctracer_popup:Toggle({
        Name = "Smooth",
        Value = false,
        Flag = "desync_tracer_smooth",
        Callback = function(v)
            VisualiseDesync:setTracerSmooth(v)
        end
    })

    local desynctracersmooth_popup = desynctracersmooth_toggle:Popup({Size = 150})

    desynctracersmooth_popup:Dropdown({
        Name = "Type",
        Values = {"ping", "custom"},
        Value = "ping",
        Flag = "desync_tracer_smooth_type",
        Callback = function(v)
            VisualiseDesync:setTracerSmoothType(v)
        end
    })

    desynctracersmooth_popup:Slider({
        Name = "Delay",
        Value = 200,
        Min = 10,
        Max = 800,
        Float = 10,
        Suffix = "%s ms",
        Flag = "desync_tracer_smooth_delay",
        Callback = function(v)
            VisualiseDesync:setTracerSmoothDelay(v)
        end
    })

    -- Image sub-popup
    local desyncimage_toggle = visualize_popup:Toggle({
        Name = "Image",
        Value = false,
        Flag = "desync_image_enabled",
        Callback = function(v)
            VisualiseDesync:setImageEnabled(v)
        end
    })

    local desyncimage_popup = desyncimage_toggle:Popup({Size = 200})

    desyncimage_popup:Colorpicker({
        Name = "Image Color",
        Value = Color3.fromHex('305261'),
        Flag = "desync_image_color",
        Callback = function(d)
            VisualiseDesync:setImageColor(d.c)
        end
    })

    desyncimage_popup:Colorpicker({
        Name = "Stroke Color",
        Value = Color3.fromHex('305261'),
        Flag = "desync_image_stroke",
        Callback = function(d)
            VisualiseDesync:setStrokeColor(d.c)
        end
    })

    desyncimage_popup:Colorpicker({
        Name = "Background",
        Value = Color3.fromHex('1b1b1b'),
        Flag = "desync_image_bg",
        Callback = function(d)
            VisualiseDesync:setBackgroundColor(d.c)
        end
    })

    desyncimage_popup:Slider({
        Name = "Scale",
        Value = 0.5,
        Min = 0.1,
        Max = 1,
        Float = 0.1,
        Flag = "desync_image_scale",
        Callback = function(v)
            VisualiseDesync:setImageScale(v)
        end
    })

    local desyncimagesmooth_toggle = desyncimage_popup:Toggle({
        Name = "Smooth",
        Value = false,
        Flag = "desync_image_smooth",
        Callback = function(v)
            VisualiseDesync:setSmooth(v)
        end
    })

    local desyncimagesmooth_popup = desyncimagesmooth_toggle:Popup({Size = 150})

    desyncimagesmooth_popup:Dropdown({
        Name = "Type",
        Values = {"ping", "custom"},
        Value = "ping",
        Flag = "desync_smooth_type",
        Callback = function(v)
            VisualiseDesync:setSmoothType(v)
        end
    })

    desyncimagesmooth_popup:Slider({
        Name = "Delay",
        Value = 200,
        Min = 10,
        Max = 800,
        Float = 10,
        Suffix = "%s ms",
        Flag = "desync_smooth_delay",
        Callback = function(v)
            VisualiseDesync:setCustomDelay(v)
        end
    })

    visualize_popup:Toggle({
        Name = "Hide if Synced",
        Value = false,
        Flag = "desync_dont_show_if_synced"
    })

    -- Highlight
    local highlight_toggle = visualization_section:Toggle({
        Name = "Highlight",
        Value = false,
        Flag = "visualise_highlight"
    })

    local highlight_popup = highlight_toggle:Popup({Size = 200})

    highlight_popup:Colorpicker({
        Name = "Fill Color",
        Value = Color3.fromRGB(255,255,255),
        Alpha = 0.5,
        Flag = "highlight_fill",
        Callback = function(d)
            General:setHighlightFillColor(d.c, d.a)
        end
    })

    highlight_popup:Colorpicker({
        Name = "Outline Color",
        Value = Color3.fromRGB(0,0,0),
        Alpha = 0,
        Flag = "highlight_outline",
        Callback = function(d)
            General:setHighlightOutlineColor(d.c, d.a)
        end
    })

    -- Anti Measures Section (Right Side)
    local anti_section = MiscTab:Section({
        Name = "Anti",
        Side = "right",
    })

    local voidhide_toggle = anti_section:Toggle({
        Name = "Void Hide",
        Value = false,
        Flag = "void_hide_enabled",
        Callback = function(v)
            VoidHide:setEnabled(v)
        end
    })

    local voidhide_popup = voidhide_toggle:Popup({Size = 300})

    voidhide_popup:Dropdown({
        Name = "Pattern",
        Values = {"Deep Void", "Break Null", "World Random"},
        Value = "Deep Void",
        Flag = "void_hide_pattern",
        Callback = function(v)
            VoidHide:setPattern(v)
        end
    })

    voidhide_popup:Dropdown({
        Name = "Direction",
        Values = {"+X", "-X", "+Y", "-Y", "+Z", "-Z"},
        Value = "-Y",
        Flag = "void_hide_direction",
        Callback = function(v)
            VoidHide:setDirection(v)
        end
    })

    voidhide_popup:Slider({
        Name = "Switch Speed",
        Value = 0.05,
        Min = 0.01,
        Max = 0.5,
        Float = 0.01,
        Suffix = "%s s",
        Flag = "void_hide_switch_speed",
        Callback = function(v)
            VoidHide:setSwitchSpeed(v)
        end
    })

    voidhide_popup:Slider({
        Name = "Depth Multiplier",
        Value = 1,
        Min = 0.5,
        Max = 5,
        Float = 0.1,
        Flag = "void_hide_depth_multiplier",
        Callback = function(v)
            VoidHide:setDepthMultiplier(v)
        end
    })

    local fakepos_toggle = anti_section:Toggle({
        Name = "Fake Position",
        Value = false,
        Flag = "fakepos_enabled",
        Callback = function(v)
            FakePos:setEnabled(v)
        end
    })

    local fakepos_popup = fakepos_toggle:Popup({Size = 200})

    local physics_toggle = fakepos_popup:Toggle({
        Name = "Physics Sender Rate",
        Value = false,
        Flag = "physics_sender_rate_enabled"
    })

    local physics_popup = physics_toggle:Popup({Size = 200})

    physics_popup:Dropdown({
        Name = "Mode",
        Values = {"default", "extra low", "extra big"},
        Value = "default",
        Flag = "physics_sender_rate_mode",
        Callback = function(v)
            PhysicsSenderRate:setMode(v)
        end
    })

    physics_popup:Slider({
        Name = "Rate",
        Value = 240,
        Min = 1,
        Max = 240,
        Float = 1,
        Flag = "physics_sender_rate_value",
        Callback = function(v)
            PhysicsSenderRate:setRate(v)
        end
    })

    local network_toggle = anti_section:Toggle({
        Name = "Network",
        Value = false,
        Flag = "network_desync_enabled"
    })

    local network_popup = network_toggle:Popup({Size = 200})

    network_popup:Dropdown({
        Name = "Mode",
        Values = {"Slow", "Aggressive"},
        Value = "Aggressive",
        Flag = "network_desync_mode",
        Callback = function(v)
            NetworkDesync:setMode(v)
        end
    })

    local async_toggle = anti_section:Toggle({
        Name = "A-Sync",
        Value = false,
        Flag = "a_sync_enabled"
    })

    local async_popup = async_toggle:Popup({Size = 150})

    async_popup:Slider({
        Name = "Cooldown",
        Value = 100,
        Min = 10,
        Max = 800,
        Float = 10,
        Suffix = "%s ms",
        Flag = "a_sync_cooldown",
        Callback = function(v)
            ASync:setCooldown(v / 1000)
        end
    })

    local velocity_toggle = anti_section:Toggle({
        Name = "Velocity Break",
        Value = false,
        Flag = "velocity_break_enabled"
    })

    local velocity_popup = velocity_toggle:Popup({Size = 200})

    velocity_popup:Slider({
        Name = "Velocity X",
        Value = 0,
        Min = -25,
        Max = 25,
        Float = 1,
        Suffix = "%s studs",
        Flag = "velocity_break_x",
        Callback = function(v)
            VelocityBreak:setVelocityX(v)
        end
    })

    velocity_popup:Slider({
        Name = "Velocity Y",
        Value = 0,
        Min = -25,
        Max = 25,
        Float = 1,
        Suffix = "%s studs",
        Flag = "velocity_break_y",
        Callback = function(v)
            VelocityBreak:setVelocityY(v)
        end
    })

    velocity_popup:Slider({
        Name = "Velocity Z",
        Value = 0,
        Min = -25,
        Max = 25,
        Float = 1,
        Suffix = "%s studs",
        Flag = "velocity_break_z",
        Callback = function(v)
            VelocityBreak:setVelocityZ(v)
        end
    })

    local velocityvisualise_toggle = velocity_popup:Toggle({
        Name = "Visualise",
        Value = false,
        Flag = "velocity_break_visualise"
    })

    local velocityvisualise_popup = velocityvisualise_toggle:Popup({Size = 150})

    velocityvisualise_popup:Colorpicker({
        Name = "Tracer Color",
        Value = Color3.fromRGB(255,255,255),
        Alpha = 0,
        Flag = "velocity_break_tracer_color",
        Callback = function(d)
            VelocityBreak:setTracerColor(d.c, d.a)
        end
    })

    -- Utility Section (Right Side)
    local utility_section = MiscTab:Section({
        Name = "Utility",
        Side = "right",
    })

    local autoloadout_toggle = utility_section:Toggle({
        Name = "Auto Loadout",
        Value = false,
        Flag = "auto_loadout_enabled",
        Callback = function(v)
            AutoLoadout:setEnabled(v)
        end
    })

    autoloadout_toggle:Keybind({
        Key = Enum.KeyCode.Unknown,
        Mode = 'Toggle',
        Callback = function(v)
            autoloadout_toggle.Set(v)
        end,
        Flag = 'auto_loadout_keybind',
    })

    local autoloadout_popup = autoloadout_toggle:Popup({Size = 350})

    local armor_toggle = autoloadout_popup:Toggle({
        Name = "Armor",
        Value = false,
        Flag = "auto_loadout_armor",
        Callback = function(v)
            AutoLoadout:setArmorEnabled(v)
        end
    })

    local armor_popup = armor_toggle:Popup({Size = 200})

    armor_popup:Slider({
        Name = "Target Armor",
        Value = 130,
        Min = 1,
        Max = 130,
        Float = 1,
        Flag = "auto_loadout_armor_target",
        Callback = function(v)
            AutoLoadout:setArmorTarget(v)
        end
    })

    local firearmor_toggle = autoloadout_popup:Toggle({
        Name = "Fire Armor",
        Value = false,
        Flag = "auto_loadout_fire_armor",
        Callback = function(v)
            AutoLoadout:setFireArmorEnabled(v)
        end
    })

    local firearmor_popup = firearmor_toggle:Popup({Size = 200})

    firearmor_popup:Slider({
        Name = "Target Fire Armor",
        Value = 200,
        Min = 1,
        Max = 200,
        Float = 1,
        Flag = "auto_loadout_fire_armor_target",
        Callback = function(v)
            AutoLoadout:setFireArmorTarget(v)
        end
    })

    local guns_toggle = autoloadout_popup:Toggle({
        Name = "Guns",
        Value = false,
        Flag = "auto_loadout_guns",
        Callback = function(v)
            AutoLoadout:setGunsEnabled(v)
        end
    })

    local guns_popup = guns_toggle:Popup({Size = 250})

    guns_popup:Dropdown({
        Name = "Weapons",
        Values = {"[Rifle]", "[Flintlock]", "[LMG]", "[AUG]", "[AK47]", "[P90]", "[Revolver]", "[Double-Barrel SG]", "[TacticalShotgun]"},
        Value = {},
        Multi = true,
        Flag = "auto_loadout_weapons",
        Callback = function(selected)
            local weapons = AutoLoadout:getWeaponsConfig()
            for _, w in ipairs(weapons) do
                local enabled = false
                for _, sel in ipairs(selected) do
                    if w.name == sel then 
                        enabled = true 
                        break 
                    end
                end
                AutoLoadout:setWeaponEnabled(w.name, enabled)
            end
        end
    })

    local ammo_toggle = autoloadout_popup:Toggle({
        Name = "Ammo",
        Value = false,
        Flag = "auto_loadout_ammo",
        Callback = function(v)
            AutoLoadout:setAmmoEnabled(v)
        end
    })

    local ammo_popup = ammo_toggle:Popup({Size = 200})

    ammo_popup:Slider({
        Name = "Purchase Count",
        Value = 1,
        Min = 1,
        Max = 5,
        Float = 1,
        Flag = "auto_loadout_ammo_count",
        Callback = function(v)
            AutoLoadout:setAmmoPurchaseCount(v)
        end
    })

    ammo_popup:Toggle({
        Name = "Only Selected Weapons",
        Value = false,
        Flag = "auto_loadout_ammo_only_selected",
        Callback = function(v)
            AutoLoadout:setAmmoOnlySelected(v)
        end
    })

    autoloadout_popup:Dropdown({
        Name = "Don't Buy If",
        Values = {"no target", "target not ko", "not safe"},
        Value = {},
        Multi = true,
        Flag = "auto_loadout_conditions",
        Callback = function(selected)
            local cond = {
                noTarget = false,
                targetNotKO = false,
                notSafe = false,
            }
            
            for _, s in ipairs(selected) do
                if s == "no target" then
                    cond.noTarget = true
                elseif s == "target not ko" then
                    cond.targetNotKO = true
                elseif s == "not safe" then
                    cond.notSafe = true
                end
            end
            
            AutoLoadout:setConditions(cond)
        end
    })

    local autostomp_toggle = utility_section:Toggle({
        Name = "Auto Stomp",
        Value = false,
        Flag = "auto_stomp_enabled",
        Callback = function(v)
            AutoStomp:setEnabled(v)
        end
    })

    local autostomp_popup = autostomp_toggle:Popup({Size = 200})

    autostomp_popup:Slider({
        Name = "Stomp Height",
        Value = 2.7,
        Min = 1,
        Max = 5,
        Float = 0.1,
        Suffix = "%s studs",
        Flag = "auto_stomp_height",
        Callback = function(v)
            AutoStomp:setStompHeight(v)
        end
    })

    local antistomp_toggle = utility_section:Toggle({
        Name = "Anti Stomp",
        Value = false,
        Flag = "anti_stomp_enabled",
        Callback = function(v)
            AntiStomp:setEnabled(v)
        end
    })

    local antistomp_popup = antistomp_toggle:Popup({Size = 200})

    antistomp_popup:Slider({
        Name = "Cooldown",
        Value = 800,
        Min = 100,
        Max = 2000,
        Float = 100,
        Suffix = "%s ms",
        Flag = "anti_stomp_cooldown",
        Callback = function(v)
            AntiStomp:setCooldown(v)
        end
    })

    local followtarget_toggle = utility_section:Toggle({
        Name = "Follow Target",
        Value = false,
        Flag = "follow_target_enabled",
        Callback = function(v)
            FollowTarget:setEnabled(v)
        end
    })

    local followtarget_popup = followtarget_toggle:Popup({Size = 400})

    followtarget_popup:Dropdown({
        Name = "Strafe Type",
        Values = {"Circle", "SpiralY", "Random", "Experimental", "Experimental v2"},
        Value = "Circle",
        Flag = "follow_target_mode",
        Callback = function(v)
            FollowTarget:setMode(v)
        end
    })

    followtarget_popup:Slider({
        Name = "Radius",
        Value = 15,
        Min = 1,
        Max = 100,
        Float = 0.5,
        Suffix = "%s studs",
        Flag = "follow_target_radius",
        Callback = function(v)
            FollowTarget:setRadius(v)
        end
    })

    followtarget_popup:Slider({
        Name = "Speed",
        Value = 1,
        Min = 0.1,
        Max = 8,
        Float = 0.1,
        Suffix = "%s x",
        Flag = "follow_target_speed",
        Callback = function(v)
            FollowTarget:setSpeed(v)
        end
    })

    followtarget_popup:Slider({
        Name = "Random Strength X",
        Value = 30,
        Min = 1,
        Max = 100,
        Float = 1,
        Flag = "follow_target_random_strength_x",
        Callback = function(v)
            FollowTarget:setRandomStrengthX(v)
        end
    })

    followtarget_popup:Slider({
        Name = "Random Strength Y",
        Value = 30,
        Min = 1,
        Max = 100,
        Float = 1,
        Flag = "follow_target_random_strength_y",
        Callback = function(v)
            FollowTarget:setRandomStrengthY(v)
        end
    })

    followtarget_popup:Slider({
        Name = "Random Strength Z",
        Value = 30,
        Min = 1,
        Max = 100,
        Float = 1,
        Flag = "follow_target_random_strength_z",
        Callback = function(v)
            FollowTarget:setRandomStrengthZ(v)
        end
    })

    local followtargetresolve_toggle = followtarget_popup:Toggle({
        Name = "resolver",
        Value = false,
        Flag = "follow_target_resolve_enabled",
        Callback = function(v)
            FollowTarget:setResolveEnabled(v)
        end
    })

    local followtargetresolve_popup = followtargetresolve_toggle:Popup({Size = 300})

    followtargetresolve_popup:Dropdown({
        Name = "Mode",
        Values = {"predict", "exponential", "artifical"},
        Value = "predict",
        Flag = "follow_target_resolve_mode",
        Callback = function(v)
            FollowTarget:setResolveMode(v)
        end
    })

    followtargetresolve_popup:Dropdown({
        Name = "Predict Type",
        Values = {"Custom", "Regular"},
        Value = "Custom",
        Flag = "follow_target_predict_type",
        Callback = function(v)
            FollowTarget:setPredictionType(v)
        end
    })

    followtargetresolve_popup:Label({
        Name = "Predict Strength",
        Bold = false,
        Dark = true
    })

    followtargetresolve_popup:Textbox({
        Name = "",
        Value = "2.0",
        Flag = "follow_target_predict_strength",
        Callback = function(v)
            local num = tonumber(v)
            if num then
                FollowTarget:setPredictionMultiplier(num)
            end
        end
    })

    followtargetresolve_popup:Label({
        Name = "Expo Min Distance",
        Bold = false,
        Dark = true
    })

    followtargetresolve_popup:Textbox({
        Name = "",
        Value = "10",
        Flag = "follow_target_exp_min",
        Callback = function(v)
            FollowTarget:setExpMinDist(v)
        end
    })

    followtargetresolve_popup:Label({
        Name = "Expo Max Distance",
        Bold = false,
        Dark = true
    })

    followtargetresolve_popup:Textbox({
        Name = "",
        Value = "100",
        Flag = "follow_target_exp_max",
        Callback = function(v)
            FollowTarget:setExpMaxDist(v)
        end
    })

    followtargetresolve_popup:Slider({
        Name = "Art Refresh Time",
        Value = 3,
        Min = 1,
        Max = 10,
        Float = 0.1,
        Suffix = "%s s",
        Flag = "follow_target_art_refresh",
        Callback = function(v)
            FollowTarget:setArtRefreshTime(v)
        end
    })

    followtargetresolve_popup:Slider({
        Name = "Art Forgiveness",
        Value = 14.4,
        Min = 1,
        Max = 80,
        Float = 0.1,
        Flag = "follow_target_art_forgiveness",
        Callback = function(v)
            FollowTarget:setArtForgiveness(v)
        end
    })

    local followtargetchecks_toggle = followtarget_popup:Toggle({
        Name = "Checks",
        Value = false,
        Flag = "follow_target_checks_enabled"
    })

    local followtargetchecks_popup = followtargetchecks_toggle:Popup({Size = 200})

    followtargetchecks_popup:Toggle({
        Name = "Check Forcefield",
        Value = false,
        Flag = "follow_target_check_ff"
    })

    followtargetchecks_popup:Toggle({
        Name = "knocked",
        Value = false,
        Flag = "follow_target_check_ko"
    })

    followtargetchecks_popup:Toggle({
        Name = "Grabbed",
        Value = false,
        Flag = "follow_target_check_grabbed"
    })

    followtargetchecks_popup:Toggle({
        Name = "dead",
        Value = false,
        Flag = "follow_target_check_dead"
    })

    local voidreload_toggle = utility_section:Toggle({
        Name = "Void Reload",
        Value = false,
        Flag = "void_reload_enabled",
        Callback = function(v)
            VoidReload:setEnabled(v)
        end
    })

    local voidreload_popup = voidreload_toggle:Popup({Size = 300})

    voidreload_popup:Dropdown({
        Name = "Direction",
        Values = {"+X", "-X", "+Y", "-Y", "+Z", "-Z"},
        Value = "-Y",
        Flag = "void_reload_direction",
        Callback = function(v)
            VoidReload:setBreakDirection(v)
        end
    })

    voidreload_popup:Slider({
        Name = "Switch Speed",
        Value = 0.05,
        Min = 0.01,
        Max = 0.5,
        Float = 0.01,
        Suffix = "%s s",
        Flag = "void_reload_switch_speed",
        Callback = function(v)
            VoidReload:setBreakSwitchSpeed(v)
        end
    })
end

-- ==================== VISUALS TAB ====================
do
    -- ESP Section (Left Side)
    local esp_section = VisualsTab:Section({
        Name = 'ESP',
        Side = 'left',
    })
    
    local box_esp_toggle = esp_section:Toggle({
        Name = 'Box ESP',
        Value = false,
        Callback = function(v)
            Library.Flags.esp_box_enabled = v
        end,
        Flag = 'esp_box_enabled',
    })
    
    local box_popup = box_esp_toggle:Popup({Size = 200})
    
    box_popup:Colorpicker({
        Name = 'Box Color',
        Value = Color3.fromRGB(255,255,255),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.esp_box_color = d.c
        end,
        Flag = 'esp_box_color',
    })
    
    local filled_toggle = box_popup:Toggle({
        Name = 'Filled Box',
        Value = false,
        Callback = function(v)
            Library.Flags.esp_filled_enabled = v
        end,
        Flag = 'esp_filled_enabled',
    })
    
    local filled_popup = filled_toggle:Popup({Size = 180})
    
    filled_popup:Colorpicker({
        Name = 'Color 1',
        Value = Color3.fromRGB(0,255,0),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.esp_filled_color1 = d.c
        end,
        Flag = 'esp_filled_color1',
    })
    
    filled_popup:Colorpicker({
        Name = 'Color 2',
        Value = Color3.fromRGB(255,255,0),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.esp_filled_color2 = d.c
        end,
        Flag = 'esp_filled_color2',
    })
    
    filled_popup:Colorpicker({
        Name = 'Color 3',
        Value = Color3.fromRGB(255,165,0),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.esp_filled_color3 = d.c
        end,
        Flag = 'esp_filled_color3',
    })
    
    filled_popup:Colorpicker({
        Name = 'Color 4',
        Value = Color3.fromRGB(255,0,0),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.esp_filled_color4 = d.c
        end,
        Flag = 'esp_filled_color4',
    })
    
    filled_popup:Slider({
        Name = 'Transparency',
        Value = 80,
        Min = 0,
        Max = 100,
        Float = 1,
        Suffix = '%s',
        Callback = function(v)
            Library.Flags.esp_filled_transparency = v
        end,
        Flag = 'esp_filled_transparency',
    })
    
    local name_esp_toggle = esp_section:Toggle({
        Name = 'Name ESP',
        Value = false,
        Callback = function(v)
            Library.Flags.esp_name_enabled = v
        end,
        Flag = 'esp_name_enabled',
    })
    
    local name_popup = name_esp_toggle:Popup({Size = 180})
    
    name_popup:Colorpicker({
        Name = 'Name Color',
        Value = Color3.fromRGB(255,255,255),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.esp_name_color = d.c
        end,
        Flag = 'esp_name_color',
    })
    
    name_popup:Dropdown({
        Name = 'Mode',
        Values = {"display", "username", "username I display", "userid"},
        Value = "display",
        Callback = function(v)
            Library.Flags.esp_name_mode = v
        end,
        Flag = 'esp_name_mode',
    })
    
    local studs_esp_toggle = esp_section:Toggle({
        Name = 'Studs ESP',
        Value = false,
        Callback = function(v)
            Library.Flags.esp_studs_enabled = v
        end,
        Flag = 'esp_studs_enabled',
    })
    
    local studs_popup = studs_esp_toggle:Popup({Size = 150})
    
    studs_popup:Colorpicker({
        Name = 'Studs Color',
        Value = Color3.fromRGB(255,255,255),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.esp_studs_color = d.c
        end,
        Flag = 'esp_studs_color',
    })
    
    local tool_esp_toggle = esp_section:Toggle({
        Name = 'Tool ESP',
        Value = false,
        Callback = function(v)
            Library.Flags.esp_tool_enabled = v
        end,
        Flag = 'esp_tool_enabled',
    })
    
    local tool_popup = tool_esp_toggle:Popup({Size = 150})
    
    tool_popup:Colorpicker({
        Name = 'Tool Color',
        Value = Color3.fromRGB(255,255,255),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.esp_tool_color = d.c
        end,
        Flag = 'esp_tool_color',
    })
    
    local healthbar_esp_toggle = esp_section:Toggle({
        Name = 'Health Bar',
        Value = false,
        Callback = function(v)
            Library.Flags.esp_healthbar_enabled = v
            if v then
                Library.Flags.esp_healthnum_toggle = false
            end
        end,
        Flag = 'esp_healthbar_enabled',
    })
    
    local healthbar_popup = healthbar_esp_toggle:Popup({Size = 300})
    
    local healthnum_toggle = healthbar_popup:Toggle({
        Name = 'Damage Numbers',
        Value = false,
        Callback = function(v)
            Library.Flags.esp_healthnum_toggle = v
        end,
        Flag = 'esp_healthnum_toggle',
    })
    
    local healthnum_popup = healthnum_toggle:Popup({Size = 150})
    
    healthnum_popup:Colorpicker({
        Name = 'Damage Number Color',
        Value = Color3.fromRGB(255,255,255),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.esp_healthnum_color = d.c
        end,
        Flag = 'esp_healthnum_color',
    })
    
    healthbar_popup:Toggle({
        Name = 'Lerp',
        Value = true,
        Callback = function(v)
            Library.Flags.esp_health_lerp = v
        end,
        Flag = 'esp_health_lerp',
    })
    
    healthbar_popup:Colorpicker({
        Name = 'High Color',
        Value = Color3.fromRGB(0,255,0),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.esp_health_high = d.c
        end,
        Flag = 'esp_health_high',
    })
    
    healthbar_popup:Colorpicker({
        Name = 'Medium Color',
        Value = Color3.fromRGB(255,255,0),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.esp_health_medium = d.c
        end,
        Flag = 'esp_health_medium',
    })
    
    healthbar_popup:Colorpicker({
        Name = 'Low Color',
        Value = Color3.fromRGB(255,128,0),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.esp_health_low = d.c
        end,
        Flag = 'esp_health_low',
    })
    
    healthbar_popup:Colorpicker({
        Name = 'Critical Color',
        Value = Color3.fromRGB(255,0,0),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.esp_health_critical = d.c
        end,
        Flag = 'esp_health_critical',
    })
    
    local armorbar_esp_toggle = esp_section:Toggle({
        Name = 'Armor Bar',
        Value = false,
        Callback = function(v)
            Library.Flags.esp_armorbar_enabled = v
            if v then
                Library.Flags.esp_armornum_toggle = false
            end
        end,
        Flag = 'esp_armorbar_enabled',
    })
    
    local armorbar_popup = armorbar_esp_toggle:Popup({Size = 300})
    
    local armornum_toggle = armorbar_popup:Toggle({
        Name = 'Damage Numbers',
        Value = false,
        Callback = function(v)
            Library.Flags.esp_armornum_toggle = v
        end,
        Flag = 'esp_armornum_toggle',
    })
    
    local armornum_popup = armornum_toggle:Popup({Size = 150})
    
    armornum_popup:Colorpicker({
        Name = 'Damage Number Color',
        Value = Color3.fromRGB(255,255,255),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.esp_armornum_color = d.c
        end,
        Flag = 'esp_armornum_color',
    })
    
    armorbar_popup:Toggle({
        Name = 'Lerp',
        Value = true,
        Callback = function(v)
            Library.Flags.esp_armor_lerp = v
        end,
        Flag = 'esp_armor_lerp',
    })
    
    armorbar_popup:Colorpicker({
        Name = 'High Color',
        Value = Color3.fromRGB(0,191,255),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.esp_armor_high = d.c
        end,
        Flag = 'esp_armor_high',
    })
    
    armorbar_popup:Colorpicker({
        Name = 'Medium Color',
        Value = Color3.fromRGB(30,144,255),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.esp_armor_medium = d.c
        end,
        Flag = 'esp_armor_medium',
    })
    
    armorbar_popup:Colorpicker({
        Name = 'Low Color',
        Value = Color3.fromRGB(100,0,255),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.esp_armor_low = d.c
        end,
        Flag = 'esp_armor_low',
    })
    
    armorbar_popup:Colorpicker({
        Name = 'Critical Color',
        Value = Color3.fromRGB(128,0,128),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.esp_armor_critical = d.c
        end,
        Flag = 'esp_armor_critical',
    })
    
    local chams_toggle = esp_section:Toggle({
        Name = 'Player Chams',
        Value = false,
        Callback = function(v)
            Library.Flags.player_chams_enabled = v
            updateAllChams()
        end,
        Flag = 'player_chams_enabled',
    })
    
    local chams_popup = chams_toggle:Popup({Size = 150})
    
    chams_popup:Colorpicker({
        Name = 'Chams Color',
        Value = Color3.fromRGB(255, 255, 255),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.player_chams_color = d.c
            updateAllChams()
        end,
        Flag = 'player_chams_color',
    })
    
    chams_popup:Slider({
        Name = 'Transparency',
        Value = 80,
        Min = 0,
        Max = 100,
        Float = 1,
        Suffix = '%s',
        Callback = function(v)
            Library.Flags.player_chams_transparency = v
            updateAllChams()
        end,
        Flag = 'player_chams_transparency',
    })
    
    -- Self Visuals Section (Right Side)
    local self_visuals_section = VisualsTab:Section({
        Name = 'Self Visuals',
        Side = 'right',
    })
    
    local body_mat_toggle = self_visuals_section:Toggle({
        Name = 'Body Material',
        Value = false,
        Callback = function(v)
            Library.Flags.self_body_material = v
            applySelfVisuals()
        end,
        Flag = 'self_body_material',
    })
    
    local body_mat_popup = body_mat_toggle:Popup({Size = 150})
    
    body_mat_popup:Colorpicker({
        Name = 'Color',
        Value = Color3.fromRGB(255, 255, 255),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.self_body_color = d.c
            applySelfVisuals()
        end,
        Flag = 'self_body_color',
    })
    
    body_mat_popup:Dropdown({
        Name = 'Material Type',
        Values = {"Neon", "ForceField"},
        Value = "Neon",
        Callback = function(v)
            Library.Flags.self_body_type = v
            applySelfVisuals()
        end,
        Flag = 'self_body_type',
    })
    
    local wireframe_toggle = self_visuals_section:Toggle({
        Name = 'Wireframe',
        Value = false,
        Callback = function(v)
            Library.Flags.self_wireframe = v
            applySelfVisuals()
        end,
        Flag = 'self_wireframe',
    })
    
    local wireframe_popup = wireframe_toggle:Popup({Size = 150})
    
    wireframe_popup:Colorpicker({
        Name = 'Color',
        Value = Color3.fromRGB(255, 255, 255),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.self_wireframe_color = d.c
            applySelfVisuals()
        end,
        Flag = 'self_wireframe_color',
    })
    
    wireframe_popup:Slider({
        Name = 'Thickness',
        Value = 1,
        Min = 1,
        Max = 10,
        Float = 1,
        Suffix = '%s',
        Callback = function(v)
            Library.Flags.self_wireframe_thickness = v
            applySelfVisuals()
        end,
        Flag = 'self_wireframe_thickness',
    })
    
    local gun_mat_toggle = self_visuals_section:Toggle({
        Name = 'Gun Material',
        Value = false,
        Callback = function(v)
            Library.Flags.self_gun_material = v
            applySelfVisuals()
        end,
        Flag = 'self_gun_material',
    })
    
    local gun_mat_popup = gun_mat_toggle:Popup({Size = 150})
    
    gun_mat_popup:Colorpicker({
        Name = 'Color',
        Value = Color3.fromRGB(255, 255, 255),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.self_gun_color = d.c
            applySelfVisuals()
        end,
        Flag = 'self_gun_color',
    })
    
    gun_mat_popup:Dropdown({
        Name = 'Material Type',
        Values = {"Neon", "ForceField"},
        Value = "Neon",
        Callback = function(v)
            Library.Flags.self_gun_type = v
            applySelfVisuals()
        end,
        Flag = 'self_gun_type',
    })
    
    local highlight_toggle = self_visuals_section:Toggle({
        Name = 'Highlight',
        Value = false,
        Callback = function(v)
            Library.Flags.self_highlight = v
            applySelfVisuals()
        end,
        Flag = 'self_highlight',
    })
    
    local highlight_popup = highlight_toggle:Popup({Size = 150})
    
    highlight_popup:Colorpicker({
        Name = 'Color',
        Value = Color3.fromRGB(255, 255, 255),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.self_highlight_color = d.c
            applySelfVisuals()
        end,
        Flag = 'self_highlight_color',
    })
    
    highlight_popup:Slider({
        Name = 'Transparency',
        Value = 80,
        Min = 0,
        Max = 100,
        Float = 1,
        Suffix = '%s',
        Callback = function(v)
            Library.Flags.self_highlight_transparency = v
            applySelfVisuals()
        end,
        Flag = 'self_highlight_transparency',
    })
    
    -- Aura Section
    local aura_toggle = self_visuals_section:Toggle({
        Name = 'Aura Effects',
        Value = false,
        Callback = function(v)
            Aura:setEnabled(v)
        end,
        Flag = 'self_aura_main',
    })
    
    local aura_popup = aura_toggle:Popup({Size = 200})
    
    aura_popup:Colorpicker({
        Name = 'Aura Color',
        Value = Color3.fromRGB(255, 255, 255),
        Alpha = 0,
        Callback = function(d)
            Aura:setAuraColor(d.c)
        end,
        Flag = 'self_aura_color',
    })
    
    aura_popup:Dropdown({
        Name = 'Aura Types',
        Values = {"Angelic", "Ambient", "Nimb", "Tornado"},
        Value = {"Angelic", "Ambient", "Nimb", "Tornado"},
        Multi = true,
        Callback = function(v)
            Aura:setAuraTypes(v)
        end,
        Flag = 'self_aura_types',
    })
    
    -- Hit Effects Section
    local hit_effects_section = VisualsTab:Section({
        Name = 'Hit Effects',
        Side = 'right',
    })
    
    local hit_effect_toggle = hit_effects_section:Toggle({
        Name = 'Hit Effect',
        Value = false,
        Callback = function(v)
            hitEffects:setEffectsEnabled(v)
            Library.Flags.hit_effect_main = v
        end,
        Flag = 'hit_effect_main',
    })
    
    local hit_effect_popup = hit_effect_toggle:Popup({Size = 200})
    
    hit_effect_popup:Colorpicker({
        Name = 'Color',
        Value = Color3.fromRGB(255,255,255),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.hit_effect_color = d.c
            hitEffects:setEffectsColor(d.c)
        end,
        Flag = 'hit_effect_color',
    })
    
    hit_effect_popup:Dropdown({
        Name = 'Type',
        Values = {'Particle', 'Blood', 'Light', 'Lightning', 'BlackFlash', 'Gravity', 'Meteor'},
        Value = 'Particle',
        Callback = function(v)
            Library.Flags.hit_effect_type = v
            hitEffects:setEffectsType(v)
        end,
        Flag = 'hit_effect_type',
    })
    
    local hit_sound_toggle = hit_effects_section:Toggle({
        Name = 'Hit Sound',
        Value = false,
        Callback = function(v)
            hitEffects:setSoundsEnabled(v)
            Library.Flags.hit_sound_main = v
        end,
        Flag = 'hit_sound_main',
    })
    
    local hit_sound_popup = hit_sound_toggle:Popup({Size = 200})
    
    local function refreshSoundList()
        hitEffects:getAvailableSounds()
        local sounds = hitEffects:getAvailableSounds()
        if #sounds == 0 then
            sounds = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10'}
        end
        return sounds
    end
    
    hit_sound_popup:Dropdown({
        Name = 'Sound',
        Values = refreshSoundList(),
        Value = '1',
        Callback = function(v)
            Library.Flags.hit_sound_selection = v
            hitEffects:setSoundSelection(v)
        end,
        Flag = 'hit_sound_selection',
    })
    
    hit_sound_popup:Slider({
        Name = 'Volume',
        Value = 5,
        Min = 0,
        Max = 10,
        Float = 0.1,
        Suffix = '%s',
        Callback = function(v)
            Library.Flags.hit_sound_volume = v
            hitEffects:setSoundVolume(v)
        end,
        Flag = 'hit_sound_volume',
    })
    
    hit_sound_popup:Slider({
        Name = 'Pitch',
        Value = 1,
        Min = 0.5,
        Max = 2,
        Float = 0.05,
        Suffix = '%s',
        Callback = function(v)
            Library.Flags.hit_sound_pitch = v
            hitEffects:setSoundPitch(v)
        end,
        Flag = 'hit_sound_pitch',
    })
    
    hit_sound_popup:Button({
        Name = 'Refresh List',
        Callback = function()
            local sounds = refreshSoundList()
            local dropdown = Library.Flags.hit_sound_selection
            if dropdown and dropdown.Refresh then
                dropdown.Refresh(sounds)
            end
        end,
    })
    
    local hit_chams_toggle = hit_effects_section:Toggle({
        Name = 'Hit Chams',
        Value = false,
        Callback = function(v)
            hitEffects:setChamsEnabled(v)
            Library.Flags.hit_chams_main = v
        end,
        Flag = 'hit_chams_main',
    })
    
    local hit_chams_popup = hit_chams_toggle:Popup({Size = 200})
    
    hit_chams_popup:Colorpicker({
        Name = 'Color',
        Value = Color3.fromRGB(255,0,0),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.hit_chams_color = d.c
            hitEffects:setChamsColor(d.c)
        end,
        Flag = 'hit_chams_color',
    })
    
    hit_chams_popup:Dropdown({
        Name = 'Material',
        Values = {'Neon', 'ForceField', 'Glass', 'Plastic', 'Metal', 'Concrete'},
        Value = 'Neon',
        Callback = function(v)
            Library.Flags.hit_chams_material = v
            hitEffects:setChamsMaterial(v)
        end,
        Flag = 'hit_chams_material',
    })
    
    hit_chams_popup:Slider({
        Name = 'Duration',
        Value = 2,
        Min = 0.5,
        Max = 5,
        Float = 0.1,
        Suffix = '%s',
        Callback = function(v)
            Library.Flags.hit_chams_duration = v
            hitEffects:setChamsDuration(v)
        end,
        Flag = 'hit_chams_duration',
    })
    
    hit_chams_popup:Slider({
        Name = 'Transparency',
        Value = 80,
        Min = 0,
        Max = 100,
        Float = 1,
        Suffix = '%s',
        Callback = function(v)
            local trans = v / 100
            Library.Flags.hit_chams_transparency = v
            hitEffects:setChamsTransparency(trans)
        end,
        Flag = 'hit_chams_transparency',
    })
    
    local hit_screen_toggle = hit_effects_section:Toggle({
        Name = 'Hit Screen',
        Value = false,
        Callback = function(v)
            hitEffects:setScreenEnabled(v)
            Library.Flags.hit_screen_main = v
        end,
        Flag = 'hit_screen_main',
    })
    
    local hit_screen_popup = hit_screen_toggle:Popup({Size = 200})
    
    hit_screen_popup:Colorpicker({
        Name = 'Color',
        Value = Color3.fromRGB(255,0,0),
        Alpha = 0,
        Callback = function(d)
            Library.Flags.hit_screen_color = d.c
            hitEffects:setScreenColor(d.c)
        end,
        Flag = 'hit_screen_color',
    })
    
    hit_screen_popup:Slider({
        Name = 'Transparency',
        Value = 0,
        Min = 0,
        Max = 100,
        Float = 1,
        Suffix = '%s',
        Callback = function(v)
            local trans = v / 100
            Library.Flags.hit_screen_transparency = v
            hitEffects:setScreenTransparency(trans)
        end,
        Flag = 'hit_screen_transparency',
    })
    
    hit_screen_popup:Slider({
        Name = 'Duration',
        Value = 0.5,
        Min = 0.1,
        Max = 2,
        Float = 0.05,
        Suffix = '%s',
        Callback = function(v)
            Library.Flags.hit_screen_duration = v
            hitEffects:setScreenDuration(v)
        end,
        Flag = 'hit_screen_duration',
    })
    
    -- World Customization Section (Right Side)
    local world_section = VisualsTab:Section({
        Name = 'World Customization',
        Side = 'right',
    })

    local world_lighting = game:GetService("Lighting")
    local world_originals = {
        Ambient = world_lighting.Ambient,
        OutdoorAmbient = world_lighting.OutdoorAmbient,
        FogColor = world_lighting.FogColor,
        FogStart = world_lighting.FogStart,
        FogEnd = world_lighting.FogEnd,
    }

    local world_color_correction = world_lighting:FindFirstChild("stride_ColorCorrection") or Instance.new("ColorCorrectionEffect")
    world_color_correction.Name = "stride_ColorCorrection"
    world_color_correction.Parent = world_lighting
    world_color_correction.Saturation = 0
    world_color_correction.Brightness = 0
    world_color_correction.Contrast = 0

    Library.Flags.world_enabled = false
    Library.Flags.world_ambient_color = world_originals.Ambient
    Library.Flags.world_fogcolor = world_originals.FogColor
    Library.Flags.world_fogstart = world_originals.FogStart
    Library.Flags.world_fogend = world_originals.FogEnd
    Library.Flags.world_colorcorrection = false
    Library.Flags.world_saturation = 0
    Library.Flags.world_brightness = 0
    Library.Flags.world_contrast = 0

    local function updateWorldSettings()
        if Library.Flags.world_enabled then
            world_lighting.Ambient = Library.Flags.world_ambient_color
            world_lighting.OutdoorAmbient = Library.Flags.world_ambient_color
            world_lighting.FogColor = Library.Flags.world_fogcolor
            world_lighting.FogStart = Library.Flags.world_fogstart
            world_lighting.FogEnd = Library.Flags.world_fogend
            world_color_correction.Enabled = Library.Flags.world_colorcorrection
            world_color_correction.Saturation = Library.Flags.world_saturation
            world_color_correction.Brightness = Library.Flags.world_brightness
            world_color_correction.Contrast = Library.Flags.world_contrast
        else
            world_lighting.Ambient = world_originals.Ambient
            world_lighting.OutdoorAmbient = world_originals.OutdoorAmbient
            world_lighting.FogColor = world_originals.FogColor
            world_lighting.FogStart = world_originals.FogStart
            world_lighting.FogEnd = world_originals.FogEnd
            world_color_correction.Enabled = false
            world_color_correction.Saturation = 0
            world_color_correction.Brightness = 0
            world_color_correction.Contrast = 0
        end
    end

    local ambient_toggle = world_section:Toggle({
        Name = 'Ambient',
        Value = false,
        Callback = function(v)
            Library.Flags.world_enabled = v
            updateWorldSettings()
        end,
        Flag = 'world_ambient_toggle',
    })

    local ambient_popup = ambient_toggle:Popup({Size = 150})

    ambient_popup:Colorpicker({
        Name = 'Ambient Color',
        Value = world_originals.Ambient,
        Alpha = 0,
        Callback = function(d)
            Library.Flags.world_ambient_color = d.c
            if Library.Flags.world_enabled then
                world_lighting.Ambient = d.c
                world_lighting.OutdoorAmbient = d.c
            end
        end,
        Flag = 'world_ambient_color',
    })

    local fog_toggle = world_section:Toggle({
        Name = 'Fog',
        Value = false,
        Callback = function(v) end,
        Flag = 'world_fog_toggle',
    })

    local fog_popup = fog_toggle:Popup({Size = 150})

    fog_popup:Colorpicker({
        Name = 'Fog Color',
        Value = world_originals.FogColor,
        Alpha = 0,
        Callback = function(d)
            Library.Flags.world_fogcolor = d.c
            if Library.Flags.world_enabled then
                world_lighting.FogColor = d.c
            end
        end,
        Flag = 'world_fogcolor',
    })

    fog_popup:Slider({
        Name = 'Fog Start',
        Value = world_originals.FogStart,
        Min = 0,
        Max = 1000,
        Float = 1,
        Suffix = '%s',
        Callback = function(v)
            Library.Flags.world_fogstart = v
            if Library.Flags.world_enabled then
                world_lighting.FogStart = v
            end
        end,
        Flag = 'world_fogstart',
    })

    fog_popup:Slider({
        Name = 'Fog End',
        Value = world_originals.FogEnd,
        Min = 100,
        Max = 10000,
        Float = 1,
        Suffix = '%s',
        Callback = function(v)
            Library.Flags.world_fogend = v
            if Library.Flags.world_enabled then
                world_lighting.FogEnd = v
            end
        end,
        Flag = 'world_fogend',
    })

    local colorcorrection_toggle = world_section:Toggle({
        Name = 'Color Correction',
        Value = false,
        Callback = function(v) end,
        Flag = 'world_colorcorrection_toggle',
    })

    local colorcorrection_popup = colorcorrection_toggle:Popup({Size = 150})

    colorcorrection_popup:Toggle({
        Name = 'Enabled',
        Value = false,
        Callback = function(v)
            Library.Flags.world_colorcorrection = v
            if Library.Flags.world_enabled then
                world_color_correction.Enabled = v
            end
        end,
        Flag = 'world_colorcorrection',
    })

    colorcorrection_popup:Slider({
        Name = 'Saturation',
        Value = 0,
        Min = -1,
        Max = 1,
        Float = 0.01,
        Suffix = '%s',
        Callback = function(v)
            Library.Flags.world_saturation = v
            if Library.Flags.world_enabled then
                world_color_correction.Saturation = v
            end
        end,
        Flag = 'world_saturation',
    })

    colorcorrection_popup:Slider({
        Name = 'Brightness',
        Value = 0,
        Min = -1,
        Max = 1,
        Float = 0.01,
        Suffix = '%s',
        Callback = function(v)
            Library.Flags.world_brightness = v
            if Library.Flags.world_enabled then
                world_color_correction.Brightness = v
            end
        end,
        Flag = 'world_brightness',
    })

    colorcorrection_popup:Slider({
        Name = 'Contrast',
        Value = 0,
        Min = -1,
        Max = 1,
        Float = 0.01,
        Suffix = '%s',
        Callback = function(v)
            Library.Flags.world_contrast = v
            if Library.Flags.world_enabled then
                world_color_correction.Contrast = v
            end
        end,
        Flag = 'world_contrast',
    })

    world_section:Button({
        Name = 'Reset to Defaults',
        Callback = function()
            Library.Flags.world_ambient_color = world_originals.Ambient
            Library.Flags.world_fogcolor = world_originals.FogColor
            Library.Flags.world_fogstart = world_originals.FogStart
            Library.Flags.world_fogend = world_originals.FogEnd
            Library.Flags.world_colorcorrection = false
            Library.Flags.world_saturation = 0
            Library.Flags.world_brightness = 0
            Library.Flags.world_contrast = 0
            
            if Library.Flags.world_enabled then
                world_lighting.Ambient = world_originals.Ambient
                world_lighting.OutdoorAmbient = world_originals.OutdoorAmbient
                world_lighting.FogColor = world_originals.FogColor
                world_lighting.FogStart = world_originals.FogStart
                world_lighting.FogEnd = world_originals.FogEnd
                world_color_correction.Enabled = false
                world_color_correction.Saturation = 0
                world_color_correction.Brightness = 0
                world_color_correction.Contrast = 0
            end
        end,
    })
end

-- ==================== SETTINGS TAB ====================
do
    local cs = SettingsTab:Section({
        Name = 'Configs',
        Side = 'left',
    })
  
    local ts = SettingsTab:Section({
        Name = 'Theme',
        Side = 'right',
    })
    
    cs:Textbox({
        Name = 'Config Name',
        Value = '',
        Placeholder = 'config name...',
        Flag = 'config_name',
    })
    
    local cfgPath = 'stride\\Configs'
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
        Name = 'Configs',
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
                        -- Update all systems with new config
                        updateAllChams()
                        applySelfVisuals()
                        if Library.Flags.self_aura_main then
                            Aura:setEnabled(Library.Flags.self_aura_main)
                            Aura:setAuraColor(Library.Flags.self_aura_color or Color3.fromRGB(255, 255 ,255))
                            Aura:setAuraTypes(Library.Flags.self_aura_types or {"Angelic", "Ambient", "Nimb", "Tornado"})
                        end
                        if Library.Flags.hit_effect_main then
                            hitEffects:setEffectsEnabled(Library.Flags.hit_effect_main)
                            hitEffects:setEffectsColor(Library.Flags.hit_effect_color or Color3.fromRGB(255,255,255))
                            hitEffects:setEffectsType(Library.Flags.hit_effect_type or "Particle")
                        end
                        if Library.Flags.hit_sound_main then
                            hitEffects:setSoundsEnabled(Library.Flags.hit_sound_main)
                            hitEffects:setSoundVolume(Library.Flags.hit_sound_volume or 5)
                            hitEffects:setSoundPitch(Library.Flags.hit_sound_pitch or 1)
                            hitEffects:setSoundSelection(Library.Flags.hit_sound_selection or "1")
                        end
                        if Library.Flags.hit_chams_main then
                            hitEffects:setChamsEnabled(Library.Flags.hit_chams_main)
                            hitEffects:setChamsColor(Library.Flags.hit_chams_color or Color3.fromRGB(255,0,0))
                            hitEffects:setChamsMaterial(Library.Flags.hit_chams_material or "Neon")
                            hitEffects:setChamsDuration(Library.Flags.hit_chams_duration or 2)
                            hitEffects:setChamsTransparency((Library.Flags.hit_chams_transparency or 50) / 100)
                        end
                        if Library.Flags.hit_screen_main then
                            hitEffects:setScreenEnabled(Library.Flags.hit_screen_main)
                            hitEffects:setScreenColor(Library.Flags.hit_screen_color or Color3.fromRGB(255,0,0))
                            hitEffects:setScreenTransparency((Library.Flags.hit_screen_transparency or 0) / 100)
                            hitEffects:setScreenDuration(Library.Flags.hit_screen_duration or 0.5)
                        end
                        updateWorldSettings()
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
        Name = 'Save',
        Callback = function()
            cfgOp('save')
        end,
    })
  
    cs:Button({
        Name = 'Load',
        Callback = function()
            cfgOp('load')
        end,
    })
  
    cs:Button({
        Name = 'Overwrite',
        Callback = function()
            cfgOp('ovr')
        end,
    })
  
    cs:Button({
        Name = 'Delete',
        Callback = function()
            cfgOp('del')
        end,
    })
  
    cs:Button({
        Name = 'Refresh List',
        Callback = function()
            if dd and dd.Refresh then
                dd.Refresh(getCfgList())
            end
        end,
    })
    
    -- Theme Section
    local watermarkToggle = ts:Toggle({
        Name = 'Watermark',
        Value = true,
        Callback = function(v)
            Watermark.SetVisible(v)
        end,
        Flag = 'watermark_enabled',
    })
  
    local watermarkPopup = watermarkToggle:Popup({Size = 200})
    local function updateWatermark()
        local text = 'stride'
        local types = Library.Flags.watermark_types
        if types and #types > 0 then
            for _, v in ipairs(types) do
                text = text .. ' | {' .. v .. '}'
            end
        end
        Watermark.SetText(text)
    end
    
    watermarkPopup:Slider({
        Name = 'Update Rate',
        Value = 200,
        Min = 0,
        Max = 1000,
        Float = 1,
        Suffix = '%s ms',
        Callback = function(v)
            Library.Flags.watermark_rate = v
            Watermark.SetRate(v / 1000)
        end,
        Flag = 'watermark_rate',
    })
  
    watermarkPopup:Dropdown({
        Name = 'Info Types',
        Values = {'fps', 'ping', 'time', 'date', 'hour', 'minute', 'second', 'ap', 'month', 'day', 'year', 'game', 'n'},
        Value = {'fps', 'ping'},
        Multi = true,
        Callback = function(v)
            Library.Flags.watermark_types = v
            updateWatermark()
        end,
        Flag = 'watermark_types',
    })
  
    ts:Keybind({
        Name = 'Menu Toggle',
        Key = Enum.KeyCode.RightControl,
        Mode = 'Toggle',
        Callback = function(v)
            if Window and Window.Open then
                Window:Open()
            end
        end,
        Flag = 'menu_keybind',
    })
    
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
    
    -- Game Panel Section
    local gs = SettingsTab:Section({
        Name = 'Game Panel',
        Description = 'Useful utilities',
        Side = 'right',
    })
    
    gs:Button({
        Name = 'Copy JobID',
        Callback = function()
            setclipboard(game.JobId)
        end,
    })
  
    gs:Button({
        Name = 'Copy GameID',
        Callback = function()
            setclipboard(tostring(game.GameId))
        end,
    })
  
    gs:Button({
        Name = 'Copy Join Script',
        Callback = function()
            setclipboard('game:GetService("TeleportService"):TeleportToPlaceInstance(' .. game.PlaceId .. ',"' .. game.JobId .. '",game.Players.LocalPlayer)')
        end,
    })
  
    gs:Button({
        Name = 'Rejoin',
        Callback = function()
            local tps = game:GetService('TeleportService')
            local lp = game:GetService('Players').LocalPlayer
            tps:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
        end,
    })
  
    gs:Button({
        Name = 'Join New Server',
        Callback = function()
            local min, max = Library.Flags['srv_min'] or 1, Library.Flags['srv_max'] or 15
            local http = game:GetService('HttpService')
            local tps = game:GetService('TeleportService')
            local lp = game:GetService('Players').LocalPlayer
          
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
                tps:TeleportToPlaceInstance(game.PlaceId, valid[math.random(1, #valid)].id, lp)
            end
        end,
    })
  
    gs:Slider({
        Name = 'Min Players',
        Value = 1,
        Min = 1,
        Max = 30,
        Float = 1,
        Callback = function() end,
        Flag = 'srv_min',
    })
  
    gs:Slider({
        Name = 'Max Players',
        Value = 15,
        Min = 1,
        Max = 30,
        Float = 1,
        Callback = function() end,
        Flag = 'srv_max',
    })
end

-- Set the ragebot tab as active by default
CombatTab.Set(true)

-- Finalize
updateBlur()
Library:Notification({
    Name = 'stride',
    Description = string.format('Loaded in %.4f seconds', os.clock() - LoadingTick),
    Type = 'Time',
    Time = 5,
})

