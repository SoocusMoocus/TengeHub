local UIModule = {}

function UIModule.CreateWindow(titleText)
    -- Core Services
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")

    -- Main ScreenGui Container
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DeltaYellowBlueGUI"
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = CoreGui
    end

    -- Main Window Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    MainFrame.Size = UDim2.new(0, 450, 0, 300)
    MainFrame.BackgroundColor3 = Color3.fromRGB(255, 235, 59) -- Yellow
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui

    -- Main Outline
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(0, 87, 231) -- Blue
    MainStroke.Thickness = 3
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = MainFrame

    -- Rounded Corners
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    -- Drag Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Color3.fromRGB(240, 210, 20)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = TopBar

    local TopBarCover = Instance.new("Frame")
    TopBarCover.Size = UDim2.new(1, 0, 0, 10)
    TopBarCover.Position = UDim2.new(0, 0, 1, -10)
    TopBarCover.BackgroundColor3 = TopBar.BackgroundColor3
    TopBarCover.BorderSizePixel = 0
    TopBarCover.Parent = TopBar

    -- Window Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText or "Delta Script"
    Title.TextColor3 = Color3.fromRGB(0, 87, 231) -- Blue text
    Title.TextSize = 18
    Title.Font = Enum.Font.SourceSansBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Position = UDim2.new(1, -35, 0, 0)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(200, 0, 0)
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.Parent = TopBar

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Content Frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "Content"
    ContentFrame.Position = UDim2.new(0, 10, 0, 45)
    ContentFrame.Size = UDim2.new(1, -20, 1, -55)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame

    -- Layout Manager (Automatically stacks buttons down cleanly)
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = ContentFrame
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8)

    -- Smooth Dragging Implementation
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(MainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    end

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    return ContentFrame
end

-- NEW BUTTON CREATION FUNCTION
function UIModule.CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = text .. "Button"
    Button.Size = UDim2.new(1, 0, 0, 35) -- Fills frame width, 35px height
    Button.BackgroundColor3 = Color3.fromRGB(0, 87, 231) -- Blue Button background
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 16
    Button.Parent = parent

    -- Round button corners
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button

    -- Yellow stroke border for the button
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(240, 210, 20)
    ButtonStroke.Thickness = 1.5
    ButtonStroke.Parent = Button

    -- Trigger code when clicked
    Button.MouseButton1Click:Connect(function()
        local success, err = pcall(callback)
        if not success then
            warn("Button error: " .. tostring(err))
        end
    end)

    return Button
end

return UIModule
