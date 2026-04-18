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

        local hk416 = buyToolFolder:FindFirstChild("HK416")
        if hk416 then
            local clone = hk416:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave HK416 to " .. player.Name)
        else
            warn("HK416 not found")
        end

        
        
         local jdragon = buyToolFolder:FindFirstChild("JDragon")
        if jdragon then
            local clone = jdragon:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave JDragon to " .. player.Name)
        else
            warn("JDragon not found")
        end

        
        
        local scar-h = buyToolFolder:FindFirstChild("SCAR-H")
        if scar-h then
            local clone = scar-h:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave SCAR-H to " .. player.Name)
        else
            warn("SCAR-H not found")
        end
        

        local tommygun = buyToolFolder:FindFirstChild("Tommy Gun")
        if tommygun then
            local clone = tommygun:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Tommy Gun to " .. player.Name)
        else
            warn("Tommy Gun not found")
        end

        
    else
        warn("BuyTool folder not found")
    end
end
