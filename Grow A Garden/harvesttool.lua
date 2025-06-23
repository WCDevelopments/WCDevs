local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local confirmGui
local highlightedFruits = {}
local harvestTool = Instance.new("Tool")
harvestTool.Name = "Harvest Tool"
harvestTool.RequiresHandle = false
harvestTool.CanBeDropped = false
harvestTool.Parent = player:WaitForChild("Backpack")

-- Clear all active highlights
local function clearHighlights()
	for _, hl in ipairs(highlightedFruits) do
		if hl and hl.Parent then
			hl:Destroy()
		end
	end
	table.clear(highlightedFruits)
end

-- Highlight fruit models inside Fruits folder
local function highlightFruits(fruitsFolder)
	clearHighlights()

	for _, fruitModel in ipairs(fruitsFolder:GetChildren()) do
		if fruitModel:IsA("Model") then
			local primary = fruitModel:FindFirstChildWhichIsA("BasePart")
			if primary then
				local highlight = Instance.new("Highlight")
				highlight.Name = "FruitHighlight"
				highlight.FillTransparency = 1
				highlight.OutlineColor = Color3.new(1, 1, 1)
				highlight.OutlineTransparency = 0
				highlight.Parent = fruitModel
				table.insert(highlightedFruits, highlight)
			end
		end
	end
end

-- Fluent-style confirm GUI
local function createConfirmGui(onConfirm, onCancel)
	-- Destroy previous one
	local old = playerGui:FindFirstChild("FluentHarvestConfirm")
	if old then old:Destroy() end

	confirmGui = Instance.new("ScreenGui")
	confirmGui.Name = "FluentHarvestConfirm"
	confirmGui.IgnoreGuiInset = true
	confirmGui.ResetOnSpawn = false
	confirmGui.Parent = playerGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 360, 0, 160)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	frame.BackgroundTransparency = 0.1
	frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
	frame.BorderSizePixel = 1
	frame.Parent = confirmGui
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

	-- Popup animation
	frame.Size = UDim2.new(0, 360, 0, 0)
	TweenService:Create(frame, TweenInfo.new(0.25), { Size = UDim2.new(0, 360, 0, 160) }):Play()

	local padding = Instance.new("UIPadding", frame)
	padding.PaddingLeft = UDim.new(0, 16)
	padding.PaddingRight = UDim.new(0, 16)
	padding.PaddingTop = UDim.new(0, 16)
	padding.PaddingBottom = UDim.new(0, 12)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 30)
	title.BackgroundTransparency = 1
	title.Text = "Confirm Harvest"
	title.Font = Enum.Font.GothamBold
	title.TextColor3 = Color3.new(1, 1, 1)
	title.TextScaled = true
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = frame

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

	local buttonHolder = Instance.new("Frame")
	buttonHolder.Size = UDim2.new(1, 0, 0, 36)
	buttonHolder.Position = UDim2.new(0, 0, 1, -42)
	buttonHolder.BackgroundTransparency = 1
	buttonHolder.Parent = frame

	local layout = Instance.new("UIListLayout", buttonHolder)
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	layout.Padding = UDim.new(0, 10)

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

		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			}):Play()
		end)
		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			}):Play()
		end)

		btn.MouseButton1Click:Connect(function()
			if confirmGui then confirmGui:Destroy() end
			confirmGui = nil
			callback()
		end)
	end

	createButton("Yes", onConfirm)
	createButton("No", onCancel)
end

-- Main click handler when plant is selected
local function onPlantClicked(plantModel)
	local fruitsFolder = plantModel:FindFirstChild("Fruits")
	if not fruitsFolder then return end

	highlightFruits(fruitsFolder)

	createConfirmGui(function()
		clearHighlights()
		for _, fruit in ipairs(fruitsFolder:GetChildren()) do
			for _, numbered in ipairs(fruit:GetChildren()) do
				if tonumber(numbered.Name) then
					for _, obj in ipairs(numbered:GetDescendants()) do
						if obj:IsA("ProximityPrompt") then
							fireproximityprompt(obj, true)
						end
					end
				end
			end
		end
	end, function()
		clearHighlights()
	end)
end

local function setPromptVisibility(visible)
	for i = 1, 6 do
		local farm = workspace:FindFirstChild("Farm")
		if not farm then continue end

		local section = farm:GetChildren()[i]
		if section and section:FindFirstChild("Important") and section.Important:FindFirstChild("Plants_Physical") then
			for _, plant in ipairs(section.Important.Plants_Physical:GetChildren()) do
				local fruits = plant:FindFirstChild("Fruits")
				if fruits then
					for _, fruit in ipairs(fruits:GetChildren()) do
						for _, folder in ipairs(fruit:GetChildren()) do
							if tonumber(folder.Name) then
								for _, obj in ipairs(folder:GetDescendants()) do
									if obj:IsA("ProximityPrompt") then
										if visible then
											obj.MaxActivationDistance = 10 -- or original value
											obj.UIOffset = Vector2.new(0, 0)
										else
											obj.MaxActivationDistance = 0
											obj.UIOffset = Vector2.new(0, 9999) -- effectively hides UI
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end


-- Tool equipped handler
harvestTool.Equipped:Connect(function(mouse)
    setPromptVisibility(false)
	mouse.Button1Down:Connect(function()
		local target = mouse.Target
		if not target then return end

		for i = 1, 6 do
			local farm = workspace:FindFirstChild("Farm")
			if not farm then continue end

			local section = farm:GetChildren()[i]
			if section and section:FindFirstChild("Important") and section.Important:FindFirstChild("Plants_Physical") then
				for _, plant in ipairs(section.Important.Plants_Physical:GetChildren()) do
					if plant:IsA("Model") and target:IsDescendantOf(plant) then
						onPlantClicked(plant)
						return
					end
				end
			end
		end
	end)
end)

harvestTool.Unequipped:Connect(function()
	setPromptVisibility(true)
end)

