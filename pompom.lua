local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

print("PANGET")

local buyToolFolder = ReplicatedStorage:FindFirstChild("BuyTool")
if buyToolFolder then
	local pdCoin = buyToolFolder:FindFirstChild("PDCoin")
	if pdCoin then
		local clone = pdCoin:Clone()
		clone.Parent = player:WaitForChild("Backpack")

    print("SUCCESS TANGINA")
	else
		warn("PDCoin not found")
	end
else
	warn("BuyTool folder not found")
end
