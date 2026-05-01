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

        local nut = buyToolFolder:FindFirstChild("Nut")
        if nut then
            local clone = nut:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Nut to " .. player.Name)
        else
            warn("Nutt not found")
        end

        
        
         local ammobox = buyToolFolder:FindFirstChild("AmmoBox")
        if ammobox then
            local clone = ammobox:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave AmmoBox to " .. player.Name)
        else
            warn("AmmoBox not found")
        end

        
        
        local scrapmetal = buyToolFolder:FindFirstChild("Scrap Metal")
        if scrapmetal then
            local clone = scrapmetal:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Scrap Metal to " .. player.Name)
        else
            warn("Scrap Metal not found")
        end
        

        local metaltube = buyToolFolder:FindFirstChild("Metal Tube")
        if metaltube then
            local clone = metaltube:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Metal Tube to " .. player.Name)
        else
            warn("Metal Tube not found")
        end


        local spring = buyToolFolder:FindFirstChild("Spring")
        if spring then
            local clone = spring:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Spring to " .. player.Name)
        else
            warn("Spring not found")
        end

        
    else
        warn("BuyTool folder not found")
    end
end
