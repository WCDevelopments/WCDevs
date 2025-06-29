-- Dependencies
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local PlayerGUI = player:WaitForChild("PlayerGui")
local SprayService_RE = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("SprayService_RE")

-- Vars
local selectedFruit = nil
local toolActive = false
local mouseConnection
local highlightInstance = nil
local selectedMutations = { "Choc" }

local allMutations = {
    "Overgrown", "Wet", "Chilled", "Frozen", "Moonlit", "Pollinated",
    "Bloodlit", "Burnt", "Cooked", "HoneyGlazed", "Plasma", "Heavenly",
    "Choc", "Zombified", "Molten", "Sundried", "Verdant", "Paradisal",
    "Windstruck", "Gold", "Rainbow", "Shocked", "Celestial", "Twisted",
    "Voidtouched", "Meteoric", "Alienlike", "Galactic", "Dawnbound", "Disco"
}

-- Proximity Prompt Handler
local function setProximityPromptsEnabled(state)
    for _, prompt in ipairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            prompt.Enabled = state
        end
    end
end

-- Functions
local function applyHighlight(model)
    if highlightInstance then highlightInstance:Destroy() end
    local hl = Instance.new("Highlight")
    hl.Adornee = model
    hl.FillTransparency = 1
    hl.OutlineColor = Color3.new(1,1,1)
    hl.OutlineTransparency = 0
    hl.Parent = game:GetService("CoreGui")
    highlightInstance = hl
end

local function clearHighlight()
    if highlightInstance then
        highlightInstance:Destroy()
        highlightInstance = nil
    end
end

local function getOwnedFarm()
    for _, farm in ipairs(workspace.Farm:GetChildren()) do
        local data = farm:FindFirstChild("Important") and farm.Important:FindFirstChild("Data")
        if data and data:FindFirstChild("Owner") and data.Owner.Value == player.Name then
            return farm
        end
    end
end

local function isValidFruit(model)
    if not model or not model:IsA("Model") then return false end
    if not model.PrimaryPart then
        local part = model:FindFirstChildWhichIsA("BasePart")
        if part then pcall(function() model.PrimaryPart = part end) end
    end
    local fruitsFolder = model.Parent
    if not fruitsFolder or fruitsFolder.Name ~= "Fruits" then return false end
    local plantModel = fruitsFolder.Parent
    local farm = getOwnedFarm()
    local physical = farm and farm:FindFirstChild("Important") and farm.Important:FindFirstChild("Plants_Physical")
    return physical and physical:FindFirstChild(plantModel.Name) ~= nil
end

local function connectClick()
    mouseConnection = mouse.Button1Down:Connect(function()
        if not toolActive then return end
        local target = mouse.Target
        if not target then return end
        local fruitModel = target:FindFirstAncestorOfClass("Model")
        if fruitModel and isValidFruit(fruitModel) then
            selectedFruit = fruitModel
            applyHighlight(fruitModel)
            print("Selected Path:", fruitModel:GetFullName())
        end
    end)
end

-- Spray Loop
task.spawn(function()
    while true do
        task.wait(2)
        if toolActive and selectedFruit and selectedFruit:IsDescendantOf(workspace) then
            for _, mutation in ipairs(selectedMutations) do
                if selectedFruit:GetAttribute(mutation) == true then
                    for _, item in ipairs(player.Backpack:GetChildren()) do
                        if item:IsA("Tool") and item.Name:match("Cleaning Spray x%d+") then
                            item.Parent = player.Character
                            break
                        end
                    end
                    task.wait(0.2)
                    SprayService_RE:FireServer("TrySpray", selectedFruit)
                    task.wait(0.2)
                    local tool = player.Character:FindFirstChildWhichIsA("Tool")
                    if tool then tool.Parent = player.Backpack end
                    break
                end
            end
        end
    end
end)

-- UI Confirmation
local Confirmed = false
WindUI:Popup({
    Title = "Grow A Garden",
    Icon = "spraycan",
    IconThemed = true,
    Content = "Welcome to Auto‑Spray Mutation Tool!",
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function() end },
        { Title = "Start", Variant = "Primary", Callback = function() Confirmed = true end },
    }
})
repeat task.wait() until Confirmed

-- UI Window
local Window = WindUI:CreateWindow({
    Title = "Grow A Garden",
    Author = "WCDevs",
    Folder = "GrowAGarden",
    Size = UDim2.fromOffset(440, 320),
    Theme = "Dark",
    Transparent = true,
    SideBarWidth = 150,
})
Window:EditOpenButton({ Title = "Garden UI", Icon = "spraycan", Draggable = true })
Window:CreateTopbarButton("Fullscreen", "maximize-2", function() Window:ToggleFullscreen() end, 990)

-- Main Tab
local mainTab = Window:Tab({ Title = "Main", Icon = "spraycan", ShowTabTitle = true })
mainTab:Section({ Title = "Automatics" })

mainTab:Dropdown({
    Title = "Mutations to Auto-Clean",
    Values = allMutations,
    Value = { "Choc" },
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedMutations = options
        print("Selected mutations:", HttpService:JSONEncode(options))
    end
})

mainTab:Toggle({
    Title = "Auto Cleaning Spray",
    Desc = "Automatically sprays selected mutated fruits",
    Value = false,
    Callback = function(state)
        toolActive = state
        if state and not mouseConnection then
            connectClick()
        elseif not state and mouseConnection then
            mouseConnection:Disconnect()
            mouseConnection = nil
            clearHighlight()
            selectedFruit = nil
        end
    end
})

mainTab:Toggle({
    Title = "Disable ProximityPrompts",
    Desc = "Disables or enables all fruit harvesting prompts",
    Value = false,
    Callback = function(state)
        setProximityPromptsEnabled(not state)
    end
})

-- GUI Panels Tab
local guiTab = Window:Tab({ Title = "UI Panels", Icon = "layout" })
guiTab:Section({ Title = "Toggle UI Panels" })

local function safeToggle(name, isVisible)
    local gui = PlayerGUI:FindFirstChild(name)
    if not gui then return end

    if gui:IsA("ScreenGui") then
        -- If the ScreenGui has a Frame child, prefer toggling that
        local frame = gui:FindFirstChild("Frame")
        if frame and frame:IsA("GuiObject") then
            frame.Visible = isVisible
        else
            gui.Enabled = isVisible
        end
    elseif gui:IsA("GuiObject") then
        gui.Visible = isVisible
    end
end

local function createGuiToggle(name, label)
    guiTab:Toggle({
        Title = label,
        Value = false,
        Callback = function(state)
            safeToggle(name, state)
        end
    })
end

createGuiToggle("CosmeticShop_UI", "Cosmetic Shop")
createGuiToggle("SummerCoins_UI", "Summer Coins UI")
createGuiToggle("Honey_UI", "Honey Coins UI")

-- Teleport Helper
local function teleportToPosition(x, y, z)
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    rootPart.CFrame = CFrame.new(x, y, z)
end

-- Teleports Tab
local teleportTab = Window:Tab({ Title = "Teleports", Icon = "map-pin" })

teleportTab:Button({
    Title = "Teleport to Summer Event",
    Callback = function()
        teleportToPosition(-106, 4, -5)
    end
})

teleportTab:Button({
    Title = "Teleport to Gear Shop",
    Callback = function()
        teleportToPosition(-276, 3, -14)
    end
})

-- Cleanup
Window:OnClose(function()
    if mouseConnection then mouseConnection:Disconnect() end
    clearHighlight()
end)
