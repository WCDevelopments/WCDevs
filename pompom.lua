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
    local lugaw = buyToolFolder:FindFirstChild("Lugaw")
    if lugaw then
        for i = 1, 10 do
            lugaw:Clone().Parent = backpack
        end
        print("Successfully gave 10 Lugaw to " .. player.Name)
    else
        warn("Lugaw not found")
    end

    -- Give 10 Yakult
    local yakult = buyToolFolder:FindFirstChild("Yakult")
    if yakult then
        for i = 1, 10 do
            yakult:Clone().Parent = backpack
        end
        print("Successfully gave 10 Yakult to " .. player.Name)
    else
        warn("Yakult not found")
    end
end
