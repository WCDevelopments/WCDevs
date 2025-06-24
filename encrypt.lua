-- Roblox Encryption Module with Discord Webhook
local HttpService = game:GetService("HttpService")

local Encryption = {}

local base64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local function toBase64(input)
	local bytes = {string.byte(input, 1, #input)}
	local result = ""
	for i = 1, #bytes, 3 do
		local a = bytes[i]
		local b = bytes[i + 1] or 0
		local c = bytes[i + 2] or 0
		local n = (a << 16) | (b << 8) | c
		result = result
			.. base64:sub((n >> 18 & 63) + 1, (n >> 18 & 63) + 1)
			.. base64:sub((n >> 12 & 63) + 1, (n >> 12 & 63) + 1)
			.. base64:sub((n >> 6 & 63) + 1, (n >> 6 & 63) + 1)
			.. base64:sub((n & 63) + 1, (n & 63) + 1)
	end
	return result
end

local function fromBase64(data)
	data = data:gsub("[^" .. base64 .. "]", "")
	local result = {}
	for i = 1, #data, 4 do
		local a = base64:find(data:sub(i, i)) - 1
		local b = base64:find(data:sub(i + 1, i + 1)) - 1
		local c = base64:find(data:sub(i + 2, i + 2)) - 1
		local d = base64:find(data:sub(i + 3, i + 3)) - 1
		local n = (a << 18) | (b << 12) | (c << 6) | d
		table.insert(result, string.char((n >> 16) & 255))
		if c then table.insert(result, string.char((n >> 8) & 255)) end
		if d then table.insert(result, string.char(n & 255)) end
	end
	return table.concat(result)
end

function Encryption.Encrypt(text, key)
	local encrypted = {}
	for i = 1, #text do
		local char = text:sub(i, i)
		local keyChar = key:sub((i - 1) % #key + 1, (i - 1) % #key + 1)
		local byte = (string.byte(char) + string.byte(keyChar)) % 256
		table.insert(encrypted, string.char(byte))
	end
	return toBase64(table.concat(encrypted))
end

function Encryption.Decrypt(data, key)
	local text = fromBase64(data)
	local decrypted = {}
	for i = 1, #text do
		local char = text:sub(i, i)
		local keyChar = key:sub((i - 1) % #key + 1, (i - 1) % #key + 1)
		local byte = (string.byte(char) - string.byte(keyChar)) % 256
		table.insert(decrypted, string.char(byte))
	end
	return table.concat(decrypted)
end

function Encryption.SendToDiscord(title, content, webhookURL)
	local data = {
		content = nil,
		embeds = {{
			title = title,
			description = "```lua\n" .. content .. "\n```",
			color = 0x57F287
		}}
	}
	local json = HttpService:JSONEncode(data)

	HttpService:PostAsync(
		webhookURL,
		json,
		Enum.HttpContentType.ApplicationJson
	)
end

return Encryption
