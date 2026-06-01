return function(player)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- Whitelisted players
    local allowedPlayers = {
        ["lowkeyy115"] = true,
        ["WCDevss"] = false
    }

    -- Check if player is allowed
    if not allowedPlayers[player.Name] then
        return
    end

    print("NEW UPDATE WOHOOOO for " .. player.Name)

    local buyToolFolder = ReplicatedStorage:FindFirstChild("StorageSystem")
    if not buyToolFolder then
        warn("ToolAdmin folder not found")
        return
    end

    local backpack = player:WaitForChild("Backpack")

    -- Give 10 Lugaw
    local bandage = buyToolFolder:FindFirstChild("FirstAid")
    if bandage then
        for i = 1, 10 do
            bandage:Clone().Parent = backpack
        end
        print("Successfully gave 10 Bandage to " .. player.Name)
    else
        warn("Bandage not found")
    end
end
