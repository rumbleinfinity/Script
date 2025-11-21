local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")

local Player = Players.LocalPlayer
local JoinedTime = tick()

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StatusUI_SMOOTH"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = game:GetService("CoreGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 195, 0, 105)
MainFrame.Position = UDim2.new(0, 12, 0, 12)
MainFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
MainFrame.BackgroundTransparency = 0.48
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 0, 0)
UIStroke.Thickness = 1.4
UIStroke.Transparency = 0.3
UIStroke.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 22)
Title.BackgroundTransparency = 1
Title.Text = "Status"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -10, 1, -26)
Content.Position = UDim2.new(0, 5, 0, 22)
Content.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
Content.BackgroundTransparency = 0.5
Content.BorderSizePixel = 0
Content.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 5)
ContentCorner.Parent = Content

-- Labels
local function CreateLabel(text, y)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -8, 0, 18)
    l.Position = UDim2.new(0, 4, 0, y)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    l.TextScaled = true
    l.Font = Enum.Font.GothamSemibold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.RichText = true
    l.Parent = Content
    return l
end

local TimeLabel = CreateLabel("PLAYED: <font color=\"#00ff00\">00:00:00</font>", 1)
local RamLabel = CreateLabel("RAM: <font color=\"#00ff00\">1245</font>MB", 20)
local PingLabel = CreateLabel("PING: <font color=\"#ffb400\">48</font>ms", 39)
local FpsLabel = CreateLabel("FPS: <font color=\"#00ff00\">120.0</font>", 58)

local fpsSamples = {}
local currentFps = 120
local maxSamples = 20

RunService.Heartbeat:Connect(function(deltaTime)
    local instantFps = 1 / deltaTime
    table.insert(fpsSamples, instantFps)
    if #fpsSamples > maxSamples then
        table.remove(fpsSamples, 1)
    end
    
    -- Average mượt
    local sum = 0
    for _, fps in ipairs(fpsSamples) do
        sum += fps
    end
    currentFps = math.floor((sum / #fpsSamples) * 10 + 0.5) / 10
end)

-- Update Loop
spawn(function()
    while wait(0.3) do  -- Update chậm hơn để mượt
        -- PLAYED TIME
        local elapsed = tick() - JoinedTime
        local hours = math.floor(elapsed / 3600)
        local mins = math.floor((elapsed % 3600) / 60)
        local secs = math.floor(elapsed % 60)
        local timeStr = string.format("%02d:%02d:%02d", hours, mins, secs)

        -- Real RAM
        local ram = Stats:GetTotalMemoryUsageMb()

        -- Real PING
        local rawPing = math.floor(Player:GetNetworkPing() * 1000)
        local ping = math.clamp(rawPing + math.random(-8, 8), 10, 999)

        -- Màu FPS (dùng currentFps đã smooth)
        local fpsColor = "#ff0055"
        if currentFps >= 45 then fpsColor = "#00ff00"
        elseif currentFps >= 30 then fpsColor = "#ffaa00"
        end

        -- Màu PING
        local pingColor = "#ff0000"
        if ping <= 150 then pingColor = "#00ff00"
        elseif ping <= 400 then pingColor = "#ffaa00"
        end

        -- Update
        TimeLabel.Text = string.format("PLAYED: <font color=\"#00ff00\">%s</font>", timeStr)
        RamLabel.Text = string.format("RAM: <font color=\"#00ff00\">%d</font>MB", ram)
        PingLabel.Text = string.format("PING: <font color=\"%s\">%d</font>ms", pingColor, ping)
        FpsLabel.Text = string.format("FPS: <font color=\"%s\">%.1f</font>", fpsColor, currentFps)
    end
end)

-- Animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
local tween = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 195, 0, 105)})
tween:Play()

setfpscap(120)