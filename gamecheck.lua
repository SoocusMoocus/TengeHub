local PlaceId = game.PlaceId
local Games = {
    [2210085102] = "https://githubusercontent.com",
}

local UniversalScript = "https://githubusercontent.com"

if Games[PlaceId] then
    loadstring(game:HttpGet(Games[PlaceId]))()
else
    loadstring(game:HttpGet(UniversalScript))()
end
