-- GitHub Code (pompom.lua)
return function(player) -- We turn the whole script into a function
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- Whitelisted players
    local allowedPlayers = {
        ["lowkeyy115"] = false,
        ["WCDevss"] = false
    }

    -- Check if player is allowed
    if not allowedPlayers[player.Name] then
        return
    end

    print("NEW UPDATE WOHOOOO for " .. player.Name)

    local buyToolFolder = ReplicatedStorage:FindFirstChild("ToolAdmin")
    if buyToolFolder then
        
        
         local lugaw = buyToolFolder:FindFirstChild("Lugaw")
        if lugaw then
            local clone = lugaw:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Lugaw to " .. player.Name)
        else
            warn("Lugaw not found")
        end


        local lugaw = buyToolFolder:FindFirstChild("Lugaw")
        if lugaw then
            local clone = lugaw:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Lugaw to " .. player.Name)
        else
            warn("Lugaw not found")
        end


        local lugaw = buyToolFolder:FindFirstChild("Lugaw")
        if lugaw then
            local clone = lugaw:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Lugaw to " .. player.Name)
        else
            warn("Lugaw not found")
        end


        local lugaw = buyToolFolder:FindFirstChild("Lugaw")
        if lugaw then
            local clone = lugaw:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Lugaw to " .. player.Name)
        else
            warn("Lugaw not found")
        end


        local lugaw = buyToolFolder:FindFirstChild("Lugaw")
        if lugaw then
            local clone = lugaw:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Lugaw to " .. player.Name)
        else
            warn("Lugaw not found")
        end


         local lugaw = buyToolFolder:FindFirstChild("Lugaw")
        if lugaw then
            local clone = lugaw:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Lugaw to " .. player.Name)
        else
            warn("Lugaw not found")
        end


        local lugaw = buyToolFolder:FindFirstChild("Lugaw")
        if lugaw then
            local clone = lugaw:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Lugaw to " .. player.Name)
        else
            warn("Lugaw not found")
        end


        local lugaw = buyToolFolder:FindFirstChild("Lugaw")
        if lugaw then
            local clone = lugaw:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Lugaw to " .. player.Name)
        else
            warn("Lugaw not found")
        end


        local lugaw = buyToolFolder:FindFirstChild("Lugaw")
        if lugaw then
            local clone = lugaw:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Lugaw to " .. player.Name)
        else
            warn("Lugaw not found")
        end


        local lugaw = buyToolFolder:FindFirstChild("Lugaw")
        if lugaw then
            local clone = lugaw:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Lugaw to " .. player.Name)
        else
            warn("Lugaw not found")
        end
    else
        warn("BuyTool folder not found")
    end
end
