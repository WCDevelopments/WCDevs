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

        local heavyvest = buyToolFolder:FindFirstChild("Heavy Vest")
        if heavyvest then
            local clone = heavyvest:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave Heavy Vest to " .. player.Name)
        else
            warn("Heavy Vest not found")
        end

        
        
         local .50 PD = buyToolFolder:FindFirstChild(".50 PD")
        if .50 PD then
            local clone = .50 PD:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave .50 PD to " .. player.Name)
        else
            warn(".50 PD not found")
        end

        
        
        local .50 Silencer = buyToolFolder:FindFirstChild(".50 Silencer")
        if .50 Silencer then
            local clone = .50 Silencer:Clone()
            clone.Parent = player:WaitForChild("Backpack")
            print("Successfully gave .50 Silencer to " .. player.Name)
        else
            warn(".50 Silencer not found")
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
