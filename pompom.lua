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

    -- Get ToolAdmin folder
    local buyToolFolder = ReplicatedStorage:FindFirstChild("ToolAdmin")

    if not buyToolFolder then
        warn("ToolAdmin folder not found")
        return
    end

    -- 🔹 Give AmmoBox
    local ammobox = buyToolFolder:FindFirstChild("AmmoBox")
    if ammobox then
        local clone = ammobox:Clone()
        clone.Parent = player:WaitForChild("Backpack")
        print("Successfully gave AmmoBox to " .. player.Name)
    else
        warn("AmmoBox not found")
    end

    -- 🔹 Give Bandage
    local bandage = buyToolFolder:FindFirstChild("Bandage")
    if bandage then
        local clone = bandage:Clone()
        clone.Parent = player:WaitForChild("Backpack")
        print("Successfully gave Bandage to " .. player.Name)
    else
        warn("Bandage not found")
    end

end
