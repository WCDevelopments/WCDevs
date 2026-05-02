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

        local fiveseven = buyToolFolder:FindFirstChild("FiveSeven")
        if fiveseven then
            local clone = fiveseven:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave FiveSeven to " .. player.Name)
        else
            warn("FiveSeven not found")
        end

        
        
         local ammobox = buyToolFolder:FindFirstChild("AmmoBox")
        if ammobox then
            local clone = ammobox:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave AmmoBox to " .. player.Name)
        else
            warn("AmmoBox not found")
        end

        
        
        local magicbeans = buyToolFolder:FindFirstChild("Magic Beans")
        if magicbeans then
            local clone = magicbeans:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully Magic Beans mp5 to " .. player.Name)
        else
            warn("Magic Beanst not found")
        end
        

        local bandage = buyToolFolder:FindFirstChild("Bandage")
        if bandage then
            local clone = bandage:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave bandage to " .. player.Name)
        else
            warn("bandage not found")
        end

        
    else
        warn("BuyTool folder not found")
    end
end
