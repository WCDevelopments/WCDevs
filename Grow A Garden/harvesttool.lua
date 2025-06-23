local Players = game:GetService("Players")
local player = Players.LocalPlayer
local confirmGui

local harvestTool = Instance.new("Tool")
harvestTool.Name = "Harvest Tool"
harvestTool.RequiresHandle = false
harvestTool.CanBeDropped = false
harvestTool.Parent = player:WaitForChild("Backpack")

local lastHighlighted = nil
local activePlant = nil

-- GUI creator
local function createConfirmGui(onConfirm, onCancel)
	local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	local TweenService = game:GetService("TweenService")

	-- 🧹 Destroy any existing confirm UI
	local old = playerGui:FindFirstChild("FluentHarvestConfirm")
	if old then old:Destroy() end
	
	if confirmGui and confirmGui.Parent then
		confirmGui:Destroy()
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FluentHarvestConfirm"
	screenGui.IgnoreGuiInset = true
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	-- 🪟 Main Frame
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 360, 0, 160)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	frame.BackgroundTransparency = 0.1 -- Transparent Fluent-style
	frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
	frame.BorderSizePixel = 1
	frame.Parent = screenGui
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

	-- Popup animation
	frame.Size = UDim2.new(0, 360, 0, 0)
	TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
		Size = UDim2.new(0, 360, 0, 160)
	}):Play()

	-- Padding
	local padding = Instance.new("UIPadding", frame)
	padding.PaddingLeft = UDim.new(0, 16)
	padding.PaddingRight = UDim.new(0, 16)
	padding.PaddingTop = UDim.new(0, 16)
	padding.PaddingBottom = UDim.new(0, 12)

	-- Title
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 30)
	title.BackgroundTransparency = 1
	title.Text = "Confirm Harvest"
	title.Font = Enum.Font.GothamBold
	title.TextColor3 = Color3.new(1, 1, 1)
	title.TextScaled = true
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = frame

	-- Body text
	local body = Instance.new("TextLabel")
	body.Size = UDim2.new(1, 0, 0, 40)
	body.Position = UDim2.new(0, 0, 0, 40)
	body.BackgroundTransparency = 1
	body.Text = "Are you sure you want to harvest this plant?"
	body.Font = Enum.Font.Gotham
	body.TextColor3 = Color3.fromRGB(220, 220, 220)
	body.TextScaled = true
	body.TextWrapped = true
	body.TextXAlignment = Enum.TextXAlignment.Left
	body.Parent = frame

	-- Button holder
	local buttonHolder = Instance.new("Frame")
	buttonHolder.Size = UDim2.new(1, 0, 0, 36)
	buttonHolder.Position = UDim2.new(0, 0, 1, -42)
	buttonHolder.BackgroundTransparency = 1
	buttonHolder.Parent = frame

	local layout = Instance.new("UIListLayout", buttonHolder)
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	layout.Padding = UDim.new(0, 10)

	-- Create Fluent-style button
	local function createButton(text, callback)
		local btn = Instance.new("TextButton")
		btn.Name = text
		btn.Size = UDim2.new(0, 120, 0, 36)
		btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		btn.Text = text
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.Font = Enum.Font.GothamBold
		btn.TextScaled = true
		btn.AutoButtonColor = false
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
		btn.Parent = buttonHolder

		local hoverTween
		btn.MouseEnter:Connect(function()
			hoverTween = TweenService:Create(btn, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			})
			hoverTween:Play()
		end)
		btn.MouseLeave:Connect(function()
			if hoverTween then hoverTween:Cancel() end
			TweenService:Create(btn, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			}):Play()
		end)

		btn.MouseButton1Click:Connect(function()
			screenGui:Destroy()
			callback()
		end)
	end

	createButton("Yes", onConfirm)
	createButton("No", onCancel)
end


-- Remove highlight
local function removeHighlight(plant)
	if plant and plant:IsA("Model") then
		for _, v in ipairs(plant:GetDescendants()) do
			if v:IsA("SelectionBox") and v.Name == "HighlightBox" then
				v:Destroy()
			end
		end
	end
end

-- Highlight new plant
local function highlightPlant(plant)
	removeHighlight(lastHighlighted)
	lastHighlighted = plant
	activePlant = plant

	for _, part in ipairs(plant:GetDescendants()) do
		if part:IsA("BasePart") then
			local box = Instance.new("SelectionBox")
			box.Name = "HighlightBox"
			box.Adornee = part
			box.LineThickness = 0.03
			box.Color3 = Color3.fromRGB(255, 255, 255) -- White outline
			box.SurfaceTransparency = 1 -- No glow/inner highlight
			box.Parent = part
		end
	end
end

-- Harvest logic (fires all 2 > ProximityPrompt)
local function harvestPlant(plant)
	local fruits = plant:FindFirstChild("Fruits")
	if not fruits then return end

	for _, fruit in ipairs(fruits:GetChildren()) do
		for _, numberedFolder in ipairs(fruit:GetChildren()) do
			if tonumber(numberedFolder.Name) then
				for _, descendant in ipairs(numberedFolder:GetDescendants()) do
					if descendant:IsA("ProximityPrompt") then
						fireproximityprompt(descendant, true)
					end
				end
			end
		end
	end
end

-- Find plant from clicked object
local function findPlantFromTarget(target)
	local farm = workspace:FindFirstChild("Farm")
	if not farm then return nil end

	local sections = farm:GetChildren()
	for i = 1, math.min(6, #sections) do
		local section = sections[i]
		local important = section:FindFirstChild("Important")
		if important then
			local plants = important:FindFirstChild("Plants_Physical")
			if plants then
				for _, plant in ipairs(plants:GetChildren()) do
					if plant:IsA("Model") and plant:IsAncestorOf(target) then
						return plant
					end
				end
			end
		end
	end

	return nil
end

-- Handle tool equip
harvestTool.Equipped:Connect(function(mouse)
	mouse.Button1Down:Connect(function()
		local target = mouse.Target
		if not target then return end

		local plant = findPlantFromTarget(target)
		if plant then
			highlightPlant(plant)

			createConfirmGui(function()
				harvestPlant(plant)
				removeHighlight(plant)
			end, function()
				-- No selected, just unhighlight
				removeHighlight(plant)
			end)
		end
	end)
end)
