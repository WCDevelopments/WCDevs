local onoffgui1 = true

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local seedShopGui = playerGui:WaitForChild("Seed_Shop")
local seedTimerLabel = seedShopGui:WaitForChild("Frame"):WaitForChild("Frame"):WaitForChild("Timer")
local petEggTimerLabel = workspace:WaitForChild("NPCS"):WaitForChild("Pet Stand"):WaitForChild("Timer")
	:WaitForChild("SurfaceGui"):WaitForChild("ResetTimeLabel")

-- UI Setup
local displayGui = Instance.new("ScreenGui")
displayGui.Name = "ModernSeedTimerUI"
displayGui.ResetOnSpawn = false
displayGui.Parent = playerGui

local bgFrame = Instance.new("ImageLabel")
bgFrame.Name = "Background"
bgFrame.Size = UDim2.new(0, 260, 0, 80)
bgFrame.Position = UDim2.new(0.5, -130, 0.1, 0)
bgFrame.BackgroundTransparency = 1
bgFrame.Image = "rbxassetid://110208924430993"
bgFrame.ScaleType = Enum.ScaleType.Stretch
bgFrame.Active = true
bgFrame.Visible = onoffgui1
bgFrame.Parent = displayGui

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -25, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.ZIndex = 10
closeBtn.Parent = bgFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)

closeBtn.MouseButton1Click:Connect(function()
	bgFrame.Visible = false
end)

-- Container for text
local textHolder = Instance.new("Frame")
textHolder.Size = UDim2.new(1, -16, 1, -12)
textHolder.Position = UDim2.new(0, 8, 0, 6)
textHolder.BackgroundTransparency = 1
textHolder.Parent = bgFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.3, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "Seed & Gear Restock In:"
title.Parent = textHolder

-- Seed timer
local seedLabel = Instance.new("TextLabel")
seedLabel.Size = UDim2.new(1, 0, 0.3, 0)
seedLabel.Position = UDim2.new(0, 0, 0.3, 0)
seedLabel.BackgroundTransparency = 1
seedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
seedLabel.Font = Enum.Font.GothamMedium
seedLabel.TextScaled = true
seedLabel.TextXAlignment = Enum.TextXAlignment.Left
seedLabel.Text = ""
seedLabel.Parent = textHolder

-- Pet timer
local petLabel = Instance.new("TextLabel")
petLabel.Size = UDim2.new(1, 0, 0.3, 0)
petLabel.Position = UDim2.new(0, 0, 0.6, 0)
petLabel.BackgroundTransparency = 1
petLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
petLabel.Font = Enum.Font.GothamMedium
petLabel.TextScaled = true
petLabel.TextXAlignment = Enum.TextXAlignment.Left
petLabel.Text = "New Pet Eggs In ..."
petLabel.Parent = textHolder

-- Drag Support (Mobile + PC)
local dragging, dragStart, startPos
bgFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = bgFrame.Position
	end
end)

bgFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		input.Changed:Connect(function()
			if dragging and input.UserInputState == Enum.UserInputState.Change then
				local delta = input.Position - dragStart
				bgFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
					startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

-- Live Timer Sync
game:GetService("RunService").RenderStepped:Connect(function()
	if onoffgui1 and bgFrame.Visible then
		if seedTimerLabel and seedTimerLabel:IsA("TextLabel") then
			seedLabel.Text = "New seeds in " .. seedTimerLabel.Text
		end
		if petEggTimerLabel and petEggTimerLabel:IsA("TextLabel") then
			petLabel.Text = "New Pet Eggs In: " .. petEggTimerLabel.Text
		end
	end
end)
