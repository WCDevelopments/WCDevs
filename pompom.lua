-- GitHub Code (pompom.lua)
return function(player) -- We turn the whole script into a function
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
    if buyToolFolder then


        local malungayPandesal = buyToolFolder:FindFirstChild("Malungay Pandesal")

        if malungayPandesal then
        local clone = malungayPandesal:Clone()
        clone.Parent = player:WaitForChild("Backpack")
        print("Successfully gave Malungay Pandesal to " .. player.Name)
        else
        warn("Malungay Pandesal not found")
        end

        
    else
        warn("BuyTool folder not found")
    end
end
