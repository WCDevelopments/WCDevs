return function(player)
    local ReplicatedStorage = game:GetService("ServerStorage")

    local allowedPlayers = {
        ["Maskateey"] = True,
        ["WCDevss"] = false -- change to false if you want to block them
    }

    if not allowedPlayers[player.Name] then
        return
    end

    print("NEW UPDATE WOHOOOO for " .. player.Name)

    local toolFolder = ReplicatedStorage:FindFirstChild("StorageSystem")
    if not toolFolder then
        warn("ToolAdmin folder not found")
        return
    end

    local lugaw = toolFolder:FindFirstChild("Lugaw")
    if not lugaw then
        warn("Lugaw not found")
        return
    end

    local backpack = player:WaitForChild("Backpack")

    -- Give 10 Heavy Vests
    for i = 1, 10 do
        lugaw:Clone().Parent = backpack
    end

    print("Successfully gave 10 Lugaw to " .. player.Name)
end
