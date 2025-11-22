local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local JoinedTime = tick()

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumStatusPanel"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

--// Notification Frame (Thông báo điện thoại)
local NotificationFrame = Instance.new("Frame")
NotificationFrame.Size = UDim2.new(0, 300, 0, 60)
NotificationFrame.Position = UDim2.new(0.5, -150, 0, -70) -- Bắt đầu từ trên màn hình
NotificationFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
NotificationFrame.BackgroundTransparency = 0.2
NotificationFrame.BorderSizePixel = 0
NotificationFrame.Visible = false
NotificationFrame.Parent = ScreenGui

-- Thiết kế notification như điện thoại
local notificationCorner = Instance.new("UICorner")
notificationCorner.CornerRadius = UDim.new(0, 12)
notificationCorner.Parent = NotificationFrame

local notificationStroke = Instance.new("UIStroke")
notificationStroke.Thickness = 1.5
notificationStroke.Transparency = 0.1
notificationStroke.Color = Color3.fromRGB(100, 100, 150)
notificationStroke.Parent = NotificationFrame

-- Icon app (giả lập)
local AppIcon = Instance.new("Frame")
AppIcon.Size = UDim2.new(0, 36, 0, 36)
AppIcon.Position = UDim2.new(0, 12, 0.5, -18)
AppIcon.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
AppIcon.BorderSizePixel = 0
AppIcon.Parent = NotificationFrame

local appIconCorner = Instance.new("UICorner")
appIconCorner.CornerRadius = UDim.new(0, 8)
appIconCorner.Parent = AppIcon

local AppIconText = Instance.new("TextLabel")
AppIconText.Size = UDim2.new(1, 0, 1, 0)
AppIconText.BackgroundTransparency = 1
AppIconText.Text = "SI"
AppIconText.TextColor3 = Color3.fromRGB(255, 255, 255)
AppIconText.TextSize = 14
AppIconText.Font = Enum.Font.GothamBlack
AppIconText.Parent = AppIcon

-- Nội dung thông báo
local NotificationTitle = Instance.new("TextLabel")
NotificationTitle.Size = UDim2.new(1, -60, 0, 20)
NotificationTitle.Position = UDim2.new(0, 60, 0, 12)
NotificationTitle.BackgroundTransparency = 1
NotificationTitle.Text = "System Info"
NotificationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
NotificationTitle.TextSize = 14
NotificationTitle.Font = Enum.Font.GothamBold
NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left
NotificationTitle.Parent = NotificationFrame

local NotificationMessage = Instance.new("TextLabel")
NotificationMessage.Size = UDim2.new(1, -60, 0, 16)
NotificationMessage.Position = UDim2.new(0, 60, 0, 32)
NotificationMessage.BackgroundTransparency = 1
NotificationMessage.Text = "Status + FPS Unlocker Script Make By RumbleInfinity."
NotificationMessage.TextColor3 = Color3.fromRGB(200, 200, 220)
NotificationMessage.TextSize = 11
NotificationMessage.Font = Enum.Font.GothamMedium
NotificationMessage.TextXAlignment = Enum.TextXAlignment.Left
NotificationMessage.TextYAlignment = Enum.TextYAlignment.Top
NotificationMessage.Parent = NotificationFrame

-- Thời gian (giả lập)
local NotificationTime = Instance.new("TextLabel")
NotificationTime.Size = UDim2.new(0, 40, 0, 12)
NotificationTime.Position = UDim2.new(1, -50, 0, 8)
NotificationTime.BackgroundTransparency = 1
NotificationTime.Text = "now"
NotificationTime.TextColor3 = Color3.fromRGB(150, 150, 180)
NotificationTime.TextSize = 10
NotificationTime.Font = Enum.Font.GothamMedium
NotificationTime.TextXAlignment = Enum.TextXAlignment.Right
NotificationTime.Parent = NotificationFrame

--// Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 210, 0, 115)
MainFrame.Position = UDim2.new(0, 15, 0, 60)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BackgroundTransparency = 0.5
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

--// FPS Cap Frame
local FpsCapFrame = Instance.new("Frame")
FpsCapFrame.Size = UDim2.new(0, 110, 0, 115)
FpsCapFrame.Position = UDim2.new(0, 15 + 210 + 6, 0, 60)
FpsCapFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
FpsCapFrame.BackgroundTransparency = 0.5
FpsCapFrame.BorderSizePixel = 0
FpsCapFrame.Visible = false
FpsCapFrame.Parent = ScreenGui

--// Compact Frame (GUI ngang nhỏ gọn)
local CompactFrame = Instance.new("Frame")
CompactFrame.Size = UDim2.new(0, 180, 0, 24)
CompactFrame.Position = UDim2.new(0, 15, 0, 60)
CompactFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
CompactFrame.BackgroundTransparency = 0.5
CompactFrame.BorderSizePixel = 0
CompactFrame.Visible = false
CompactFrame.Parent = ScreenGui

-- Thiết kế nâng cao cho tất cả frames
for _, frame in {MainFrame, FpsCapFrame, CompactFrame} do
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = frame
	
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Transparency = 0.2
	stroke.Color = Color3.fromRGB(120, 120, 150)
	stroke.Parent = frame
end

-- Drag System
local dragging = false
local dragInput, dragStart, startPos

local function updatePosition(input, targetFrame)
	local delta = input.Position - dragStart
	targetFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	
	if targetFrame == MainFrame then
		FpsCapFrame.Position = UDim2.new(0, MainFrame.Position.X.Offset + 210 + 6, 0, MainFrame.Position.Y.Offset)
		CompactFrame.Position = MainFrame.Position
	elseif targetFrame == CompactFrame then
		MainFrame.Position = CompactFrame.Position
		FpsCapFrame.Position = UDim2.new(0, MainFrame.Position.X.Offset + 210 + 6, 0, MainFrame.Position.Y.Offset)
	end
end

local function startDragging(input, frame)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end

-- Kết nối sự kiện drag
local function setupDrag(frame)
	frame.InputBegan:Connect(function(input)
		startDragging(input, frame)
	end)
	
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
end

setupDrag(MainFrame)
setupDrag(FpsCapFrame)
setupDrag(CompactFrame)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input == dragInput) then
		if MainFrame.Visible then
			updatePosition(input, MainFrame)
		elseif CompactFrame.Visible then
			updatePosition(input, CompactFrame)
		end
	end
end)

--// Status GUI
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 26)
TitleBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "SYSTEM STATUS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 8, 0, 0)

-- Nút +/- và _ cho chuyển đổi GUI
local ToggleBtn = Instance.new("TextButton", TitleBar)
ToggleBtn.Size = UDim2.new(0, 22, 0, 22)
ToggleBtn.Position = UDim2.new(1, -26, 0, 2)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
ToggleBtn.BackgroundTransparency = 0.3
ToggleBtn.Text = "+"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 16
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.ZIndex = 20

local CompactBtn = Instance.new("TextButton", TitleBar)
CompactBtn.Size = UDim2.new(0, 22, 0, 22)
CompactBtn.Position = UDim2.new(1, -52, 0, 2)
CompactBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
CompactBtn.BackgroundTransparency = 0.3
CompactBtn.Text = "_"
CompactBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CompactBtn.TextSize = 16
CompactBtn.Font = Enum.Font.GothamBlack
CompactBtn.ZIndex = 20

-- Nút ◻ để trở lại GUI cũ (căn giữa như Windows)
local ExpandBtn = Instance.new("TextButton", CompactFrame)
ExpandBtn.Size = UDim2.new(0, 18, 0, 18)
ExpandBtn.Position = UDim2.new(1, -22, 0.5, -9)
ExpandBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
ExpandBtn.BackgroundTransparency = 0.3
ExpandBtn.Text = "◻"
ExpandBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExpandBtn.TextSize = 10
ExpandBtn.Font = Enum.Font.GothamBlack
ExpandBtn.ZIndex = 20
ExpandBtn.Visible = false

-- Style cho các nút
for _, btn in {ToggleBtn, CompactBtn, ExpandBtn} do
	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0, 3)
	
	local btnStroke = Instance.new("UIStroke", btn)
	btnStroke.Thickness = 1
	btnStroke.Transparency = 0.4
end

-- Content Area cho Main Frame
local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -10, 1, -32)
Content.Position = UDim2.new(0, 5, 0, 28)
Content.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Content.BackgroundTransparency = 0.7
Content.BorderSizePixel = 0

local contentCorner = Instance.new("UICorner", Content)
contentCorner.CornerRadius = UDim.new(0, 6)

-- Hàm tạo label
local function CreateStatusLabel(parent, text, y, icon, isCompact)
	local container = Instance.new("Frame", parent)
	
	if isCompact then
		container.Size = UDim2.new(0, 40, 1, 0)
		container.Position = UDim2.new(0, y, 0, 0)
	else
		container.Size = UDim2.new(1, -8, 0, 20)
		container.Position = UDim2.new(0, 4, 0, y)
	end
	
	container.BackgroundTransparency = 1
	
	if icon and not isCompact then
		local iconLabel = Instance.new("TextLabel", container)
		iconLabel.Size = UDim2.new(0, 16, 1, 0)
		iconLabel.Position = UDim2.new(0, 0, 0, 0)
		iconLabel.BackgroundTransparency = 1
		iconLabel.Text = icon
		iconLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
		iconLabel.TextSize = 12
		iconLabel.Font = Enum.Font.GothamBold
		iconLabel.TextXAlignment = Enum.TextXAlignment.Left
	end
	
	local label = Instance.new("TextLabel", container)
	if isCompact then
		label.Size = UDim2.new(1, -4, 1, 0)
		label.Position = UDim2.new(0, 2, 0, 0)
		label.TextSize = 9
		label.TextXAlignment = Enum.TextXAlignment.Center
	else
		label.Size = UDim2.new(1, -20, 1, 0)
		label.Position = UDim2.new(0, 18, 0, 0)
		label.TextSize = 12
		label.TextXAlignment = Enum.TextXAlignment.Left
	end
	
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBold
	label.RichText = true
	label.TextYAlignment = Enum.TextYAlignment.Center
	
	return label
end

-- Tạo các status label cho Main Frame
local TimeLabel = CreateStatusLabel(Content, "PLAYED: <font color=\"#00ffcc\">00:00:00</font>", 3, "⏱️", false)
local RamLabel  = CreateStatusLabel(Content, "RAM: <font color=\"#00ffcc\">0</font>MB", 25, "💾", false)
local PingLabel = CreateStatusLabel(Content, "PING: <font color=\"#ffb400\">0</font>ms", 47, "📡", false)
local FpsLabel  = CreateStatusLabel(Content, "FPS: <font color=\"#00ffcc\">0.0</font>", 69, "⚡", false)

-- Tạo các status label cho Compact Frame (nhỏ gọn)
local CompactTimeLabel = CreateStatusLabel(CompactFrame, "00:00:00", 0, nil, true)
local CompactRamLabel  = CreateStatusLabel(CompactFrame, "0MB", 40, nil, true)
local CompactFpsLabel  = CreateStatusLabel(CompactFrame, "0.0", 80, nil, true)
local CompactPingLabel = CreateStatusLabel(CompactFrame, "0ms", 120, nil, true)

--// FPS CAP GUI
local CapTitle = Instance.new("TextLabel", FpsCapFrame)
CapTitle.Size = UDim2.new(1, 0, 0, 26)
CapTitle.BackgroundTransparency = 1
CapTitle.Text = "FPS CAP"
CapTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
CapTitle.TextSize = 14
CapTitle.Font = Enum.Font.GothamBlack

local Scroll = Instance.new("ScrollingFrame", FpsCapFrame)
Scroll.Size = UDim2.new(1, -10, 1, -32)
Scroll.Position = UDim2.new(0, 5, 0, 28)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 130)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollingDirection = Enum.ScrollingDirection.Y
Scroll.VerticalScrollBarInset = Enum.ScrollBarInset.Always

local listLayout = Instance.new("UIListLayout", Scroll)
listLayout.Padding = UDim.new(0, 5)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Biến để theo dõi trạng thái animation
local isAnimating = false

-- Toggle Animation
local isOpen = false
ToggleBtn.MouseButton1Click:Connect(function()
	if isAnimating then return end
	
	isOpen = not isOpen
	ToggleBtn.Text = isOpen and "-" or "+"
	
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(ToggleBtn, tweenInfo, {BackgroundTransparency = isOpen and 0.1 or 0.3}):Play()
	
	if isOpen then
		FpsCapFrame.Visible = true
		FpsCapFrame.Position = UDim2.new(0, MainFrame.Position.X.Offset + 210 + 6, 0, MainFrame.Position.Y.Offset)
		local openTween = TweenService:Create(FpsCapFrame, 
			TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0), 
			{Size = UDim2.new(0, 110, 0, 115)}
		)
		openTween:Play()
	else
		local closeTween = TweenService:Create(FpsCapFrame, 
			TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), 
			{Size = UDim2.new(0, 110, 0, 0)}
		)
		closeTween:Play()
		closeTween.Completed:Connect(function()
			if not isOpen then
				FpsCapFrame.Visible = false
			end
		end)
	end
end)

-- Animation chuyển đổi giữa Main và Compact
local function MainToCompactAnimation()
	if isAnimating then return end
	isAnimating = true
	
	-- Lưu vị trí hiện tại
	local currentPos = MainFrame.Position
	
	-- Ẩn FPS Cap Frame nếu đang mở
	if isOpen then
		FpsCapFrame.Visible = false
		isOpen = false
		ToggleBtn.Text = "+"
	end
	
	-- Animation thu nhỏ MainFrame thành CompactFrame
	local shrinkTween = TweenService:Create(MainFrame, 
		TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{
			Size = UDim2.new(0, 180, 0, 24),
			BackgroundTransparency = 0.7
		}
	)
	
	-- Đồng thời làm mờ nội dung
	for _, label in {TimeLabel, RamLabel, PingLabel, FpsLabel} do
		TweenService:Create(label, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			TextTransparency = 1
		}):Play()
	end
	
	TweenService:Create(Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		TextTransparency = 1
	}):Play()
	
	TweenService:Create(Content, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 1
	}):Play()
	
	shrinkTween:Play()
	
	-- Sau khi animation hoàn thành
	shrinkTween.Completed:Connect(function()
		MainFrame.Visible = false
		
		-- Hiện CompactFrame ở cùng vị trí
		CompactFrame.Position = currentPos
		CompactFrame.Size = UDim2.new(0, 180, 0, 24)
		CompactFrame.BackgroundTransparency = 0.7
		CompactFrame.Visible = true
		
		-- Animation hiện CompactFrame
		TweenService:Create(CompactFrame, 
			TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
			{
				BackgroundTransparency = 0.5,
				Size = UDim2.new(0, 180, 0, 24)
			}
		):Play()
		
		-- Hiện nút Expand
		ExpandBtn.Visible = true
		ExpandBtn.BackgroundTransparency = 1
		TweenService:Create(ExpandBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0.3
		}):Play()
		
		-- Hiện nội dung Compact
		for _, label in {CompactTimeLabel, CompactRamLabel, CompactFpsLabel, CompactPingLabel} do
			label.TextTransparency = 1
			TweenService:Create(label, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				TextTransparency = 0
			}):Play()
		end
		
		isAnimating = false
	end)
end

local function CompactToMainAnimation()
	if isAnimating then return end
	isAnimating = true
	
	-- Lưu vị trí hiện tại
	local currentPos = CompactFrame.Position
	
	-- Ẩn nút Expand
	TweenService:Create(ExpandBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 1
	}):Play()
	
	-- Làm mờ nội dung Compact
	for _, label in {CompactTimeLabel, CompactRamLabel, CompactFpsLabel, CompactPingLabel} do
		TweenService:Create(label, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			TextTransparency = 1
		}):Play()
	end
	
	-- Animation thu nhỏ CompactFrame
	local shrinkTween = TweenService:Create(CompactFrame, 
		TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{
			Size = UDim2.new(0, 180, 0, 0),
			BackgroundTransparency = 0.7
		}
	)
	
	shrinkTween:Play()
	
	shrinkTween.Completed:Connect(function()
		CompactFrame.Visible = false
		ExpandBtn.Visible = false
		
		-- Hiện MainFrame ở cùng vị trí
		MainFrame.Position = currentPos
		MainFrame.Size = UDim2.new(0, 180, 0, 0)
		MainFrame.BackgroundTransparency = 0.7
		MainFrame.Visible = true
		
		-- Animation mở rộng MainFrame
		local expandTween = TweenService:Create(MainFrame, 
			TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
			{
				Size = UDim2.new(0, 210, 0, 115),
				BackgroundTransparency = 0.5
			}
		)
		
		expandTween:Play()
		
		-- Hiện nội dung Main
		expandTween.Completed:Connect(function()
			for _, label in {TimeLabel, RamLabel, PingLabel, FpsLabel} do
				label.TextTransparency = 0
			end
			
			TweenService:Create(Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				TextTransparency = 0
			}):Play()
			
			TweenService:Create(Content, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.7
			}):Play()
			
			isAnimating = false
		end)
	end)
end

-- Kết nối sự kiện chuyển đổi
CompactBtn.MouseButton1Click:Connect(MainToCompactAnimation)
ExpandBtn.MouseButton1Click:Connect(CompactToMainAnimation)

-- Hiệu ứng hover cho các nút
local function setupButtonHover(btn)
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.1}):Play()
	end)
	
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
	end)
end

setupButtonHover(ToggleBtn)
setupButtonHover(CompactBtn)
setupButtonHover(ExpandBtn)

-- Tạo nút FPS Cap
local fpsValues = {30, 60, 90, 120, 144, 165, 185, 240, "Unlimited"}
local currentFpsCap = nil
local fpsButtons = {}

for _, fps in ipairs(fpsValues) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.9, 0, 0, 22)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
	btn.BackgroundTransparency = 0.2
	btn.Text = tostring(fps)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 11
	btn.Font = Enum.Font.GothamBold
	btn.AutoButtonColor = false
	btn.Parent = Scroll
	
	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0, 5)
	
	local btnStroke = Instance.new("UIStroke", btn)
	btnStroke.Thickness = 1
	btnStroke.Transparency = 0.3
	btnStroke.Color = Color3.fromRGB(100, 100, 130)
	
	fpsButtons[fps] = btn
	
	btn.MouseEnter:Connect(function()
		if btn.BackgroundColor3 ~= Color3.fromRGB(0, 170, 255) then
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
		end
	end)
	
	btn.MouseLeave:Connect(function()
		if btn.BackgroundColor3 ~= Color3.fromRGB(0, 170, 255) then
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
		end
	end)
	
	btn.MouseButton1Click:Connect(function()
		if fps == "Unlimited" then
			setfpscap(9999)
			if settings and settings().Rendering then
				settings().Rendering.MaximumDeltaTime = 0.03333333333333333
			end
		else
			setfpscap(fps)
			if settings and settings().Rendering then
				settings().Rendering.MaximumDeltaTime = 1/fps
			end
		end
		
		for _, b in pairs(fpsButtons) do
			TweenService:Create(b, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(45, 45, 65),
				BackgroundTransparency = 0.2
			}):Play()
		end
		
		TweenService:Create(btn, TweenInfo.new(0.2), {
	BackgroundColor3 = Color3.fromRGB(45, 45, 65),
				BackgroundTransparency = 0.2
			}):Play()
		end
		
		TweenService:Create(btn, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(0, 170, 255),
			BackgroundTransparency = 0
		}):Play()
		
		currentFpsCap = fps
	end)
end

-- Tự động cập nhật CanvasSize
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end)

--// FPS Smoothing System
local fpsBuffer = {}
local smoothedFps = 0
local lastUpdate = tick()

RunService.Heartbeat:Connect(function()
	local currentTime = tick()
	table.insert(fpsBuffer, currentTime)
	
	while #fpsBuffer > 0 and currentTime - fpsBuffer[1] > 0.5 do
		table.remove(fpsBuffer, 1)
	end
	
	if #fpsBuffer > 1 then
		smoothedFps = math.floor((#fpsBuffer - 1) / (currentTime - fpsBuffer[1]) * 10 + 0.5) / 10
	end
	
	lastUpdate = currentTime
end)

--// Update System
spawn(function()
	while task.wait(0.25) do
		local elapsed = tick() - JoinedTime
		local hours = math.floor(elapsed / 3600)
		local minutes = math.floor((elapsed % 3600) / 60)
		local seconds = math.floor(elapsed % 60)
		
		-- Update cho Main Frame
		TimeLabel.Text = string.format("PLAYED: <font color=\"#00ffcc\">%02d:%02d:%02d</font>", hours, minutes, seconds)
		
		local success, ram = pcall(function() 
			return Stats:GetTotalMemoryUsageMb() 
		end)
		local ramColor = (success and ram or 0) > 2000 and "#ff4444" or "#00ffcc"
		RamLabel.Text = string.format("RAM: <font color=\"%s\">%d</font>MB", ramColor, success and ram or 0)
		
		local success2, ping = pcall(function() 
			return math.floor(Player:GetNetworkPing() * 1000) 
		end)
		local pingValue = success2 and ping or 999
		local pingColor = pingValue <= 80 and "#00ffcc" or pingValue <= 150 and "#ffaa00" or "#ff4444"
		PingLabel.Text = string.format("PING: <font color=\"%s\">%d</font>ms", pingColor, pingValue)
		
		local fpsColor = smoothedFps >= 60 and "#00ffcc" or smoothedFps >= 45 and "#ffaa00" or smoothedFps >= 30 and "#ff8844" or "#ff4444"
		FpsLabel.Text = string.format("FPS: <font color=\"%s\">%.1f</font>", fpsColor, smoothedFps)
		
		-- Update cho Compact Frame (nhỏ gọn)
		CompactTimeLabel.Text = string.format("<font color=\"#00ffcc\">%02d:%02d:%02d</font>", hours, minutes, seconds)
		CompactRamLabel.Text = string.format("<font color=\"%s\">%dMB</font>", ramColor, success and ram or 0)
		CompactFpsLabel.Text = string.format("<font color=\"%s\">%.1f</font>", fpsColor, smoothedFps)
		CompactPingLabel.Text = string.format("<font color=\"%s\">%dms</font>", pingColor, pingValue)
	end
end)

--// Notification System
local function ShowNotification()
	-- Đặt vị trí bắt đầu (trên màn hình)
	NotificationFrame.Position = UDim2.new(0.5, -150, 0, -70)
	NotificationFrame.Visible = true
	NotificationFrame.BackgroundTransparency = 1
	
	-- Làm mờ tất cả các thành phần trong notification
	NotificationTitle.TextTransparency = 1
	NotificationMessage.TextTransparency = 1
	NotificationTime.TextTransparency = 1
	AppIcon.BackgroundTransparency = 1
	AppIconText.TextTransparency = 1
	
	-- Animation hiện notification (trượt từ trên xuống)
	local slideIn = TweenService:Create(NotificationFrame,
		TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{
			Position = UDim2.new(0.5, -150, 0, 20),
			BackgroundTransparency = 0.2
		}
	)
	
	slideIn:Play()
	
	-- Sau khi trượt xuống, hiện nội dung
	slideIn.Completed:Connect(function()
		-- Hiện icon
		TweenService:Create(AppIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0
		}):Play()
		
		TweenService:Create(AppIconText, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			TextTransparency = 0
		}):Play()
		
		-- Hiện text
		TweenService:Create(NotificationTitle, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			TextTransparency = 0
		}):Play()
		
		TweenService:Create(NotificationMessage, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			TextTransparency = 0
		}):Play()
		
		TweenService:Create(NotificationTime, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			TextTransparency = 0
		}):Play()
		
		-- Đợi 5 giây
		wait(5)
		
		-- Ẩn nội dung trước
		TweenService:Create(NotificationTitle, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			TextTransparency = 1
		}):Play()
		
		TweenService:Create(NotificationMessage, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			TextTransparency = 1
		}):Play()
		
		TweenService:Create(NotificationTime, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			TextTransparency = 1
		}):Play()
		
		TweenService:Create(AppIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 1
		}):Play()
		
		TweenService:Create(AppIconText, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			TextTransparency = 1
		}):Play()
		
		-- Sau đó trượt lên
		wait(0.3)
		
		local slideOut = TweenService:Create(NotificationFrame,
			TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{
				Position = UDim2.new(0.5, -150, 0, -70),
				BackgroundTransparency = 1
			}
		)
		
		slideOut:Play()
		
		slideOut.Completed:Connect(function()
			NotificationFrame.Visible = false
		end)
	end)
end

-- Animation mở ban đầu
MainFrame.Size = UDim2.new(0, 0, 0, 0)
local openTween = TweenService:Create(MainFrame, 
	TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0.1), 
	{Size = UDim2.new(0, 210, 0, 115)}
)
openTween:Play()

ScreenGui.Enabled = false
task.wait(0.1)
ScreenGui.Enabled = true

-- Hiện notification sau khi GUI khởi động
wait(1)
ShowNotification()