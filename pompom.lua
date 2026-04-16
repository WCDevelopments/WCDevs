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

        local heavyvest = buyToolFolder:FindFirstChild("Heavy Vest")
        if heavyvest then
            local clone = heavyvest:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Heavy Vest to " .. player.Name)
        else
            warn("Heavy Vest not found")
        end
        
        local revolver = buyToolFolder:FindFirstChild("Revolver")
        if revolver then
            local clone = revolver:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave revolver to " .. player.Name)
        else
            warn("revolver not found")
        end
        

        local yakult = buyToolFolder:FindFirstChild("Yakult")
        if yakult then
            local clone = yakult:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave yakult to " .. player.Name)
        else
            warn("yakult not found")
        end

        
    else
        warn("BuyTool folder not found")
    end
end
