-- Lucide icons with real asset IDs + animation + smooth drag + resize handle + responsive system

local player = game:GetService("Players").LocalPlayer
local seedShop = player:WaitForChild("PlayerGui"):WaitForChild("Seed_Shop")
local seedContainer = seedShop:WaitForChild("Frame"):WaitForChild("ScrollingFrame")
local replicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local rarityColors = {
	Common = Color3.fromRGB(200, 200, 200),
	Uncommon = Color3.fromRGB(144, 238, 144),
	Rare = Color3.fromRGB(100, 149, 237),
	Legendary = Color3.fromRGB(255, 255, 100),
	Mythical = Color3.fromRGB(186, 85, 211),
	Divine = Color3.fromRGB(255, 140, 0),
}

local rarityOrder = {
	Common = 1,
	Uncommon = 2,
	Rare = 3,
	Legendary = 4,
	Mythical = 5,
	Divine = 6
}

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ModernSeedRestock"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 400)
frame.Position = UDim2.new(1, -410, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local lastFrameSize = frame.Size

-- Log label bottom-left
local logLabel = Instance.new("TextLabel")
logLabel.Position = UDim2.new(0, 10, 1, -20)
logLabel.Size = UDim2.new(1, -20, 0, 20)
logLabel.BackgroundTransparency = 1
logLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
logLabel.Font = Enum.Font.Gotham
logLabel.TextSize = 14
logLabel.TextXAlignment = Enum.TextXAlignment.Left
logLabel.Text = "Timer: ..."
logLabel.Name = "Timer"
logLabel.Parent = frame

-- Resize Handle
local resizeHandle = Instance.new("Frame")
resizeHandle.Size = UDim2.new(0, 20, 0, 20)
resizeHandle.Position = UDim2.new(1, -20, 1, -20)
resizeHandle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
resizeHandle.BorderSizePixel = 0
resizeHandle.ZIndex = 2
resizeHandle.Name = "Resize"
resizeHandle.Parent = frame
Instance.new("UICorner", resizeHandle).CornerRadius = UDim.new(0, 4)

local resizing = false
local resizeStart, initialSize
local MIN_WIDTH, MIN_HEIGHT = 400, 250
local MAX_WIDTH, MAX_HEIGHT = 600, 600

resizeHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 and not isMinimized then
		resizing = true
		resizeStart = input.Position
		initialSize = frame.Size
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				resizing = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if resizing and input.UserInputType == Enum.UserInputType.MouseMovement and not isMinimized then
		local delta = input.Position - resizeStart
		local newWidth = math.clamp(initialSize.X.Offset + delta.X, MIN_WIDTH, MAX_WIDTH)
		local newHeight = math.clamp(initialSize.Y.Offset + delta.Y, MIN_HEIGHT, MAX_HEIGHT)
		frame.Size = UDim2.new(initialSize.X.Scale, newWidth, initialSize.Y.Scale, newHeight)
		lastFrameSize = frame.Size
	end
end)

-- Dragging setup with smooth motion
local dragging, dragInput, dragStart, startPos
local dragTween

frame.InputBegan:Connect(function(input)
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
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging and not resizing then
		local delta = input.Position - dragStart
		local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		if dragTween then dragTween:Cancel() end
		dragTween = TweenService:Create(frame, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Position = newPos
		})
		dragTween:Play()
	end
end)
-- Top bar
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Seed Restocks - Cy_Peanut"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Name = "Title"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left

-- Button container
local buttonHolder = Instance.new("Frame", frame)
buttonHolder.Size = UDim2.new(0, 90, 0, 26)
buttonHolder.Position = UDim2.new(1, -100, 0, 7)
buttonHolder.Name = "ButtonHolder"
buttonHolder.BackgroundTransparency = 1

local uiList = Instance.new("UIListLayout", buttonHolder)
uiList.FillDirection = Enum.FillDirection.Horizontal
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Right
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 4)

-- Refresh button
local refreshBtn = Instance.new("ImageButton", buttonHolder)
refreshBtn.Size = UDim2.new(0, 26, 0, 26)
refreshBtn.Image = "rbxassetid://10734940376"
refreshBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
refreshBtn.BackgroundTransparency = 0
refreshBtn.Name = "Refresh"
Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 6)

-- Minimize behavior
local isMinimized = false
local minimizeBtn = Instance.new("ImageButton", buttonHolder)
minimizeBtn.Size = UDim2.new(0, 26, 0, 26)
minimizeBtn.Image = "rbxassetid://10734895698"
minimizeBtn.Name = "Minimize"
minimizeBtn.BackgroundTransparency = 1

-- Close button
local closeBtn = Instance.new("ImageButton", buttonHolder)
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Image = "rbxassetid://10747384394"
closeBtn.BackgroundTransparency = 1
closeBtn.Name = "Close"
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

-- Scrolling list
local list = Instance.new("ScrollingFrame", frame)
list.Position = UDim2.new(0, 0, 0, 40)
list.Size = UDim2.new(1, 0, 1, -40)
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.ScrollBarThickness = 3
list.BackgroundTransparency = 1
list.AutomaticCanvasSize = Enum.AutomaticSize.Y

local function updateMinimizeVisuals()
	for _, child in ipairs(frame:GetChildren()) do
		if not (child.Name == "Minimize" or child.Name == "Timer" or child.name == "ButtonHolder" or child.Name == "Title" or child.Name == "Refresh" or child.Name == "Close" or child:IsA("UICorner")) then
			child.Visible = not isMinimized
		end
	end
end


minimizeBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		lastFrameSize = frame.Size
		TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Size = UDim2.new(lastFrameSize.X.Scale, lastFrameSize.X.Offset, 0, 60)
		}):Play()
		minimizeBtn.Image = "rbxassetid://10734886735"
	else
		TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Size = lastFrameSize
		}):Play()
		minimizeBtn.Image = "rbxassetid://10734895698"
	end
	updateMinimizeVisuals()
end)

local function createLayout()
	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 8)
	layout.Parent = list
end

createLayout()

local function createSeedEntry(seedName, stockTextLabel, rarityText)
	local stockCount = tonumber(stockTextLabel.Text:match("(%d+)"))
	if not stockCount or stockCount < 1 then return end

	local entry = Instance.new("Frame")
	entry.Size = UDim2.new(1, 0, 0, 40)
	entry.BackgroundTransparency = 1
	entry.Parent = list
	entry.Name = seedName

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, -20, 1, 0)
	container.Position = UDim2.new(0, 10, 0, 0)
	container.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	container.BorderSizePixel = 0
	container.Parent = entry
	Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

	local padding = Instance.new("UIPadding", container)
	padding.PaddingLeft = UDim.new(0, 12)
	padding.PaddingRight = UDim.new(0, 12)
	padding.PaddingTop = UDim.new(0, 4)
	padding.PaddingBottom = UDim.new(0, 4)

	local layout = Instance.new("UIListLayout", container)
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 8)

	local label = Instance.new("TextLabel", container)
	label.Size = UDim2.new(1, -200, 1, 0)
	label.BackgroundTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.GothamBold
	label.TextSize = 14
	label.TextColor3 = rarityColors[rarityText] or Color3.new(1, 1, 1)
	label.Text = seedName .. " - X" .. stockCount .. " Stock"

	local buyBtn = Instance.new("TextButton", container)
	buyBtn.Size = UDim2.new(0, 80, 1, 0)
	buyBtn.Text = "Buy"
	buyBtn.Font = Enum.Font.GothamBold
	buyBtn.TextSize = 14
	buyBtn.TextColor3 = Color3.new(1, 1, 1)
	buyBtn.BackgroundColor3 = Color3.fromRGB(85, 200, 100)
	Instance.new("UICorner", buyBtn).CornerRadius = UDim.new(0, 6)

	local buyAllBtn = Instance.new("TextButton", container)
	buyAllBtn.Size = UDim2.new(0, 80, 1, 0)
	buyAllBtn.Text = "Buy All"
	buyAllBtn.Font = Enum.Font.GothamBold
	buyAllBtn.TextSize = 14
	buyAllBtn.TextColor3 = Color3.new(1, 1, 1)
	buyAllBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
	Instance.new("UICorner", buyAllBtn).CornerRadius = UDim.new(0, 6)

	local function updateSeed()
		local updated = tonumber(stockTextLabel.Text:match("(%d+)"))
		if updated then
			if updated <= 0 then
				entry:Destroy()
			else
				label.Text = seedName .. " - X" .. updated .. " Stock"
			end
		end
	end

	buyBtn.MouseButton1Click:Connect(function()
		replicatedStorage.GameEvents.BuySeedStock:FireServer(seedName:gsub(" ", ""))
		task.delay(0.2, updateSeed)
	end)

	buyAllBtn.MouseButton1Click:Connect(function()
		local safeName = seedName:gsub(" ", "")
		for _ = 1, stockCount do
			replicatedStorage.GameEvents.BuySeedStock:FireServer(safeName)
		end
		task.delay(0.4, updateSeed)
	end)
end

local function scanSeeds()
	list:ClearAllChildren()
	createLayout()

	local allSeeds = {}

	for _, seedFrame in ipairs(seedContainer:GetChildren()) do
		if seedFrame:IsA("Frame") and seedFrame:FindFirstChild("Main_Frame") then
			local main = seedFrame.Main_Frame
			local stockLabel = main:FindFirstChild("Stock_Text")
			local rarityLabel = main:FindFirstChild("Rarity_Text")

			if stockLabel and rarityLabel and stockLabel:IsA("TextLabel") then
				local count = tonumber(stockLabel.Text:match("(%d+)"))
				if count and count >= 1 then
					table.insert(allSeeds, {
						name = seedFrame.Name:gsub("_Frame", ""),
						stockLabel = stockLabel,
						rarity = rarityLabel.Text
					})
				end
			end
		end
	end

	table.sort(allSeeds, function(a, b)
		return (rarityOrder[a.rarity] or 0) > (rarityOrder[b.rarity] or 0)
	end)

	for _, seed in ipairs(allSeeds) do
		createSeedEntry(seed.name, seed.stockLabel, seed.rarity)
	end
end

refreshBtn.MouseButton1Click:Connect(scanSeeds)
scanSeeds()

local seedTimerLabel = seedShop:WaitForChild("Frame"):WaitForChild("Frame"):WaitForChild("Timer")
seedTimerLabel:GetPropertyChangedSignal("Text"):Connect(function()
	local text = seedTimerLabel.Text
	logLabel.Text = text
	if string.match(text, "^New seeds in 0s") then
	    wait(1.5)
		scanSeeds()
		print("refreshing...")
	end
end)

