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

        local bandage = buyToolFolder:FindFirstChild("Bandage")
        if bandage then
            
            -- Give 10 bandages
            for i = 1, 10 do
                local clone = bandage:Clone()
                clone.Parent = player:WaitForChild("Backpack")
            end

            print("Successfully gave 10 bandages to " .. player.Name)

        else
            warn("Bandage not found")
        end
        
    else
        warn("ToolAdmin folder not found")
    end
end
