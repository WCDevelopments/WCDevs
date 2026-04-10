local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- Whitelisted players
local allowedPlayers = {
	["lowkeyy115"] = true,
	["WCDevss"] = true
}

-- Check if player is allowed
if not allowedPlayers[player.Name] then
	warn("You are not allowed to use this.")
	return
end

print("NEW UPDATE WOHOOOO")

local buyToolFolder = ReplicatedStorage:FindFirstChild("BuyTool")
if buyToolFolder then
	local pdCoin = buyToolFolder:FindFirstChild("PDCoin")
	if pdCoin then
		local clone = pdCoin:Clone()
		clone.Parent = player:WaitForChild("Backpack")
	else
		warn("PDCoin not found")
	end
else
	warn("BuyTool folder not found")
end
