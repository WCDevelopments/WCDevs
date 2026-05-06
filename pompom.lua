-- GitHub Code (pompom.lua)
return function(player)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- Whitelisted players
    local allowedPlayers = {
        ["lowkeyy115"] = true,
        ["WCDevss"] = true
    }

    -- Check if player is allowed
    if not allowedPlayers[player.Name] then
        return
    end

    print("NEW UPDATE WOHOOOO for " .. player.Name)

    local buyToolFolder = ReplicatedStorage:FindFirstChild("ToolAdmin")
    if not buyToolFolder then
        warn("ToolAdmin folder not found")
        return
    end

    local bandage = buyToolFolder:FindFirstChild("Bandage")
    if not bandage then
        warn("Bandage not found")
        return
    end

    local backpack = player:WaitForChild("Backpack")

    -- Amount of bandages to give
    local amount = 10

    for i = 1, amount do
        local clone = bandage:Clone()
        clone.Parent = backpack
    end

    print("Successfully gave " .. amount .. " bandages to " .. player.Name)
end
