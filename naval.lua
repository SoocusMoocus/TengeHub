local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "TengeHub"
Junkie.identifier = "1172144"
Junkie.provider = "TengeHub Key" 

local FileName = "TengeHub_Key.txt" 

local function checkSavedKey()
if readfile and isfile and isfile(FileName) then
local success, content = pcall(function()
return readfile(FileName)
end)
if success and content then
local cleanKey = content:gsub("%s+", "")
if cleanKey ~= "" then
local apiSuccess, result = pcall(function()
return Junkie.check_key(cleanKey)
end)
if apiSuccess and result and result.valid then
getgenv().SCRIPT_KEY = cleanKey
return true
end
end
end
end
return false
end 

if checkSavedKey() then
local UIModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/SoocusMoocus/TengeHub/refs/heads/main/gui.lua"))()
local Window = UIModule.CreateWindow("TengeHub")
local CombatTab = UIModule.CreateTab(Window, "Combat")
else
loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/7aabe657cf674c555be6f00199cc599aba20c8427428c50866412f38ffa419c8/download"))()
end
