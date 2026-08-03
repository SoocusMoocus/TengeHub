local PlaceId = game.PlaceId
local Games = {
    [2210085102] = "https://raw.githubusercontent.com/SoocusMoocus/TengeHub/refs/heads/main/naval.lua",
}

local UniversalScript = "https://githubusercontent.com"

if Games[PlaceId] then
    loadstring(game:HttpGet(Games[PlaceId]))()
else
    loadstring(game:HttpGet(UniversalScript))()
end
