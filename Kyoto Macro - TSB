-- ╔════════════════════════════╗
-- ║       RumbleInfinity            ║
-- ╚════════════════════════════╝
-- This script is Open Source - Feel free to use, modify, and share it!
-- However, please keep this credit line intact. Do not remove or alter
-- the "RumbleInfinity" credit in any form. Thank you for respecting the creator.
-- 
-- This is a recorded macro that has been converted and refined into a script.
-- It is safe to use as provided.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local macroRunning = false
local activeTasks = {}
local taskCounter = 0

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TSBKyotoMacro"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundTransparency = 1
MainFrame.Position = UDim2.new(0, 20, 0, 20)
MainFrame.Size = UDim2.new(0, 120, 0, 60)

local BorderFrame = Instance.new("Frame")
BorderFrame.Name = "BorderFrame"
BorderFrame.Parent = MainFrame
BorderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
BorderFrame.BorderSizePixel = 0
BorderFrame.Size = UDim2.new(1, 0, 1, 0)
BorderFrame.Active = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = BorderFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
}
UIGradient.Rotation = 90
UIGradient.Parent = BorderFrame

local ButtonsContainer = Instance.new("Frame")
ButtonsContainer.Name = "ButtonsContainer"
ButtonsContainer.Parent = BorderFrame
ButtonsContainer.BackgroundTransparency = 1
ButtonsContainer.Position = UDim2.new(0, 8, 0, 8)
ButtonsContainer.Size = UDim2.new(1, -16, 1, -16)

local KyotoButton = Instance.new("TextButton")
KyotoButton.Name = "KyotoButton"
KyotoButton.Parent = ButtonsContainer
KyotoButton.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
KyotoButton.BorderSizePixel = 0
KyotoButton.Position = UDim2.new(0, 0, 0, 0)
KyotoButton.Size = UDim2.new(0.48, 0, 1, 0)
KyotoButton.Font = Enum.Font.GothamBlack
KyotoButton.Text = "KYOTO"
KyotoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KyotoButton.TextScaled = true
KyotoButton.TextStrokeTransparency = 0.5
KyotoButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

local KyotoCorner = Instance.new("UICorner")
KyotoCorner.CornerRadius = UDim.new(0, 10)
KyotoCorner.Parent = KyotoButton

local KyotoStroke = Instance.new("UIStroke")
KyotoStroke.Color = Color3.fromRGB(255, 60, 60)
KyotoStroke.Thickness = 2.5
KyotoStroke.Transparency = 0.3
KyotoStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
KyotoStroke.Parent = KyotoButton

local StopButton = Instance.new("TextButton")
StopButton.Name = "StopButton"
StopButton.Parent = ButtonsContainer
StopButton.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
StopButton.BorderSizePixel = 0
StopButton.Position = UDim2.new(0.52, 0, 0, 0)
StopButton.Size = UDim2.new(0.48, 0, 1, 0)
StopButton.Font = Enum.Font.GothamBlack
StopButton.Text = "STOP"
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.TextScaled = true
StopButton.TextStrokeTransparency = 0.5
StopButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 10)
StopCorner.Parent = StopButton

local StopStroke = Instance.new("UIStroke")
StopStroke.Color = Color3.fromRGB(180, 60, 60)
StopStroke.Thickness = 2.5
StopStroke.Transparency = 0.4
StopStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
StopStroke.Parent = StopButton

local dragging = false
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

BorderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

BorderFrame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateInput(input)
    end
end)

local function forceStopAllTasks()
    macroRunning = false
    
    for _, task in pairs(activeTasks) do
        if task and type(task) == "thread" then
            coroutine.close(task)
        end
    end
    
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.One, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.D, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
    
    activeTasks = {}
    taskCounter = 0
    
    KyotoButton.Text = "KYOTO"
    KyotoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    KyotoStroke.Color = Color3.fromRGB(255, 60, 60)
    KyotoStroke.Transparency = 0.3
    
    StopButton.Text = "STOP"
    StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    StopStroke.Color = Color3.fromRGB(180, 60, 60)
    StopStroke.Transparency = 0.4
end

local function rotateCamera90Degrees()
    local currentCFrame = camera.CFrame
    camera.CFrame = currentCFrame * CFrame.Angles(0, math.rad(90), 0)
end

local function executeSideDashCancelRight()
    local rand = math.random(0, 15) / 1000
    
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.D, false, game)
    task.wait(0.09 + rand)
    
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
    task.wait(0.03 + rand / 2)
    
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
    task.wait(0.04 + rand / 2)
    
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.D, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
end

local function runTSBMacro()
    if macroRunning then return end
    macroRunning = true
    
    KyotoButton.Text = "RUNNING"
    KyotoButton.TextColor3 = Color3.fromRGB(200, 255, 200)
    KyotoStroke.Color = Color3.fromRGB(120, 255, 160)
    KyotoStroke.Transparency = 0
    KyotoStroke.Thickness = 3.5
    
    StopButton.Text = "STOP"
    StopButton.TextColor3 = Color3.fromRGB(255, 200, 200)
    StopStroke.Color = Color3.fromRGB(255, 100, 100)
    StopStroke.Transparency = 0
    StopStroke.Thickness = 3.5
    
    taskCounter = taskCounter + 1
    local currentTaskId = taskCounter
    
    local task = coroutine.create(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.One, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.One, false, game)
        
        task.wait(2.0)
        
        if not macroRunning then return end
        
        rotateCamera90Degrees()
        task.wait(0.10)
        
        if not macroRunning then return end
        
        executeSideDashCancelRight()
        
        task.wait(0.25)
        
        if macroRunning then
            macroRunning = false
            KyotoButton.Text = "KYOTO"
            KyotoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            KyotoStroke.Color = Color3.fromRGB(255, 60, 60)
            KyotoStroke.Transparency = 0.3
            KyotoStroke.Thickness = 2.5
            
            StopButton.Text = "STOP"
            StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            StopStroke.Color = Color3.fromRGB(180, 60, 60)
            StopStroke.Transparency = 0.4
            StopStroke.Thickness = 2.5
        end
        
        activeTasks[currentTaskId] = nil
    end)
    
    activeTasks[currentTaskId] = task
    coroutine.resume(task)
end

KyotoButton.MouseButton1Click:Connect(runTSBMacro)
KyotoButton.TouchTap:Connect(runTSBMacro)

StopButton.MouseButton1Click:Connect(forceStopAllTasks)
StopButton.TouchTap:Connect(forceStopAllTasks)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Escape and macroRunning then
        forceStopAllTasks()
    end
end)

ScreenGui.Destroying:Connect(forceStopAllTasks)

print("╔════════════════════════════╗")
print("║       RumbleInfinity            ║")
print("╚════════════════════════════╝")
