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
        

        local bandage = buyToolFolder:FindFirstChild("Bandage")
        if bandage then
            local clone = bandage:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave bandage to " .. player.Name)
        else
            warn("bandage not found")
        end


         local malungaypandesal = buyToolFolder:FindFirstChild("Malungay Pandesal")
        if malungaypandesal then
            local clone = bandage:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Malungay Pandesal to " .. player.Name)
        else
            warn("Malungay Pandesal not found")
        end

        
    else
        warn("BuyTool folder not found")
    end
end
