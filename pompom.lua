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



        
        local pdCoin = buyToolFolder:FindFirstChild("PDCoin")
        if pdCoin then
            local clone = pdCoin:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave PDCoin to " .. player.Name)
        else
            warn("PDCoin not found")
        end

        
        
         local mint = buyToolFolder:FindFirstChild("Mint")
        if mint then
            local clone = mint:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Mint to " .. player.Name)
        else
            warn("Mint not found")
        end

        
        
        local revolver = buyToolFolder:FindFirstChild("Revolver")
        if revolver then
            local clone = revolver:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave revolver to " .. player.Name)
        else
            warn("revolver not found")
        end


        
        
         local jdragon = buyToolFolder:FindFirstChild("JDragon")
        if jdragon then
            local clone = jdragon:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave jdragon to " .. player.Name)
        else
            warn("jdragon not found")
        end
    else
        warn("BuyTool folder not found")
    end
end
