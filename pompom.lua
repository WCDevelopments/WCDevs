-- GitHub Code (pompom.lua)
return function(player) -- We turn the whole script into a function
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- Whitelisted players
    local allowedPlayers = {
        ["Maskateey"] = true,
        ["WCDevss"] = true
    }

    -- Check if player is allowed
    if not allowedPlayers[player.Name] then
        return
    end

    print("NEW UPDATE WOHOOOO for " .. player.Name)

    local buyToolFolder = ReplicatedStorage:FindFirstChild("ToolAdmin")
    if buyToolFolder then

       local ammobox = buyToolFolder:FindFirstChild("AmmoBox")
        if ammobox then
            local clone = ammobox:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave AmmoBox to " .. player.Name)
        else
            warn("AmmoBox not found")
        end

        
        
         local ammobox = buyToolFolder:FindFirstChild("AmmoBox")
        if ammobox then
            local clone = ammobox:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave AmmoBox to " .. player.Name)
        else
            warn("AmmoBox not found")
        end

        
        
        local ammobox = buyToolFolder:FindFirstChild("AmmoBox")
        if ammobox then
            local clone = ammobox:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave AmmoBox to " .. player.Name)
        else
            warn("AmmoBox not found")
        end
        

        local ammobox = buyToolFolder:FindFirstChild("AmmoBox")
        if ammobox then
            local clone = ammobox:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave AmmoBox to " .. player.Name)
        else
            warn("AmmoBox not found")
        end

        
    else
        warn("BuyTool folder not found")
    end
end
