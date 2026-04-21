-- GitHub Code (pompom.lua)
return function(player) -- We turn the whole script into a function
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- Whitelisted players
    local allowedPlayers = {
        ["lowkeyy115"] = false,
        ["WCDevss"] = true
    }

    -- Check if player is allowed
    if not allowedPlayers[player.Name] then
        return
    end

    print("NEW UPDATE WOHOOOO for " .. player.Name)

        local parachute = buyToolFolder:FindFirstChild("Parachute")
        if parachute then
            local clone = parachute:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Parachute to " .. player.Name)
        else
            warn("Parachute not found")
        end

        
    else
        warn("BuyTool folder not found")
    end
end
