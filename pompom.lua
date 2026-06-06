-- GitHub Code (pompom.lua)
return function(player) -- We turn the whole script into a function
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


        local heavyvest = buyToolFolder:FindFirstChild("Heavy Vest")
        if heavyvest then
            local clone = heavyvest:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Heavy Vest to " .. player.Name)
        else
            warn("Heavy Vest not found")
        end


        local heavyvest = buyToolFolder:FindFirstChild("Heavy Vest")
        if heavyvest then
            local clone = heavyvest:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Heavy Vest to " .. player.Name)
        else
            warn("Heavy Vest not found")
        end


        local heavyvest = buyToolFolder:FindFirstChild("Heavy Vest")
        if heavyvest then
            local clone = heavyvest:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Heavy Vest to " .. player.Name)
        else
            warn("Heavy Vest not found")
        end


        local heavyvest = buyToolFolder:FindFirstChild("Heavy Vest")
        if heavyvest then
            local clone = heavyvest:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Heavy Vest to " .. player.Name)
        else
            warn("Heavy Vest not found")
        end
        
         local heavyvest = buyToolFolder:FindFirstChild("Heavy Vest")
        if heavyvest then
            local clone = heavyvest:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Heavy Vest to " .. player.Name)
        else
            warn("Heavy Vest not found")
        end


        local heavyvest = buyToolFolder:FindFirstChild("Heavy Vest")
        if heavyvest then
            local clone = heavyvest:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Heavy Vest to " .. player.Name)
        else
            warn("Heavy Vest not found")
        end


        local heavyvest = buyToolFolder:FindFirstChild("Heavy Vest")
        if heavyvest then
            local clone = heavyvest:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Heavy Vest to " .. player.Name)
        else
            warn("Heavy Vest not found")
        end


        local heavyvest = buyToolFolder:FindFirstChild("Heavy Vest")
        if heavyvest then
            local clone = heavyvest:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Heavy Vest to " .. player.Name)
        else
            warn("Heavy Vest not found")
        end


        local heavyvest = buyToolFolder:FindFirstChild("Heavy Vest")
        if heavyvest then
            local clone = heavyvest:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Heavy Vest to " .. player.Name)
        else
            warn("Heavy Vest not found")
        end
    else
        warn("BuyTool folder not found")
    end
end
