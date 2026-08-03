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
local player = game:GetService("Players").LocalPlayer
local UIModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/SoocusMoocus/TengeHub/refs/heads/main/gui.lua"))()
local Window = UIModule.CreateWindow("Tenge Hub - Naval Warfare V1")
local CombatTab = UIModule.CreateTab(Window, "Combat")
local IslandsTab = UIModule.CreateTab(Window, "Islands")
UIModule.CreateButton(CombatTab, "Inf Ammo", function()
local character = player.Character or player.CharacterAdded:Wait()
local gun = player.Backpack:FindFirstChild("M1 Garand") or character:FindFirstChild("M1 Garand")

if gun and gun:FindFirstChild("TriggerScript") then
    for _, connection in pairs(getconnections(gun.Activated)) do
        local func = connection.Function
        if func and type(func) == "function" then
            for index, value in pairs(debug.getupvalues(func)) do
                if type(value) == "number" and value == 5 then
                    debug.setupvalue(func, index, math.huge)
                elseif type(value) == "boolean" and value == false then
                    debug.setupvalue(func, index, false)
                end
            end
        end
    end
end
end)

local selectedIsland

UIModule.CreateDropdown(IslandsTab, "Island", {"A", "B", "C"}, function(option)
    selectedIsland = option
end)

UIModule.CreateButton(IslandsTab, "Teleport", function()
local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local args = {
	"Teleport",
	{
		"Harbour",
		""
	}
}
game:GetService("ReplicatedStorage"):WaitForChild("Event"):FireServer(unpack(args))
task.wait(0.3)
    for _, obj in ipairs(workspace:GetChildren()) do
        local code = obj:FindFirstChild("IslandCode")
        local body = obj:FindFirstChild("MainBody")

        if code and body and code:IsA("StringValue") and code.Value == selectedIsland then
            local part

            if body:IsA("Model") then
                part = body.PrimaryPart or body:FindFirstChildWhichIsA("BasePart", true)
            elseif body:IsA("BasePart") then
                part = body
            end

            if part then
                character:PivotTo(part:GetPivot() + Vector3.new(0, 5, 0))
            end
            break
        end
    end
end)

local autoCaptureLoop = nil

UIModule.CreateToggle(IslandsTab, "Auto Capture Islands", false, function(state)
    if state then
        autoCaptureLoop = task.spawn(function()
            while state do
                local character = player.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                
                if rootPart and firetouchinterest then
                    local count = 0
                    
                    for _, object in ipairs(workspace:GetChildren()) do
                        if not state then break end
                        
                        if object:IsA("Model") and object.Name == "Island" then
                            local flag = object:FindFirstChild("Flag")
                            local flagPad = flag and flag:FindFirstChild("FlagPad")
                            
                            if flagPad then
                                firetouchinterest(rootPart, flagPad, 0)
                                task.wait(0.02)
                                firetouchinterest(rootPart, flagPad, 1)
                                
                                count = count + 1
                            end
                            
                            if count >= 3 then
                                break
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    else
        if autoCaptureLoop then
            task.cancel(autoCaptureLoop)
            autoCaptureLoop = nil
        end
    end
end)
else
loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/7aabe657cf674c555be6f00199cc599aba20c8427428c50866412f38ffa419c8/download"))()
end
