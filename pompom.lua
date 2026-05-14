-- GitHub Code (pompom.lua)
return function(player)

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

        local makarov = buyToolFolder:FindFirstChild("Makarov")

        if makarov then

            -- Give 5 Makarovs
            for i = 1, 5 do
                local clone = makarov:Clone()
                clone.Parent = player:WaitForChild("Backpack")
            end

            print("Successfully gave 5 Makarovs to " .. player.Name)

        else
            warn("Makarov not found")
        end

    else
        warn("ToolAdmin folder not found")
    end
end
