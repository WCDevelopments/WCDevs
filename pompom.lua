-- GitHub Code (pompom.lua)
return function(player)
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

        -- CUSTOMIZABLE QUANTITIES
        local heavyVestAmount = 1
        local yakultAmount = 10
        local revolverAmount = 1
        local bandageAmount = 1

        -- Heavy Vest
        local heavyvest = buyToolFolder:FindFirstChild("Heavy Vest")
        if heavyvest then
            for i = 1, heavyVestAmount do
                local clone = heavyvest:Clone()
                clone.Parent = player:WaitForChild("Backpack")
            end
            print("Successfully gave " .. heavyVestAmount .. " Heavy Vest(s) to " .. player.Name)
        else
            warn("Heavy Vest not found")
        end

        -- Mint
        local yakult = buyToolFolder:FindFirstChild("Yakult")
        if yakult then
            for i = 1, yakultAmount do
                local clone = yakult:Clone()
                clone.Parent = player:WaitForChild("Backpack")
            end
            print("Successfully gave " .. mintAmount .. " Yakult(s) to " .. player.Name)
        else
            warn("Yakult not found")
        end

        -- Revolver
        local revolver = buyToolFolder:FindFirstChild("Revolver")
        if revolver then
            for i = 1, revolverAmount do
                local clone = revolver:Clone()
                clone.Parent = player:WaitForChild("Backpack")
            end
            print("Successfully gave " .. revolverAmount .. " Revolver(s) to " .. player.Name)
        else
            warn("Revolver not found")
        end

        -- Bandage
        local bandage = buyToolFolder:FindFirstChild("Bandage")
        if bandage then
            for i = 1, bandageAmount do
                local clone = bandage:Clone()
                clone.Parent = player:WaitForChild("Backpack")
            end
            print("Successfully gave " .. bandageAmount .. " Bandage(s) to " .. player.Name)
        else
            warn("Bandage not found")
        end

    else
        warn("ToolAdmin folder not found")
    end
end
