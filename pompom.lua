return function(player)
    local ReplicatedStorage = game:GetService("ServerStorage")

    local allowedPlayers = {
        ["lowkeyy115"] = true,
        ["WCDevss"] = false -- change to false if you want to block them
    }

    if not allowedPlayers[player.Name] then
        return
    end

    print("NEW UPDATE WOHOOOO for " .. player.Name)

    local toolFolder = ReplicatedStorage:FindFirstChild("ToolAdmin")
    if not toolFolder then
        warn("ToolAdmin folder not found")
        return
    end

    local heavyVest = toolFolder:FindFirstChild("Heavy Vest")
    if not heavyVest then
        warn("Heavy Vest not found")
        return
    end

    local backpack = player:WaitForChild("Backpack")

    -- Give 10 Heavy Vests
    for i = 1, 10 do
        heavyVest:Clone().Parent = backpack
    end

    print("Successfully gave 10 Heavy Vests to " .. player.Name)
end
