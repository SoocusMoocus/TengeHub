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
    Title.Size = UDim2.new(1, -85, 1, 0)
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

    -- ==========================================
    -- HIDE / UNHIDE & DRAGGABLE OPEN BUTTON
    -- ==========================================
    
    local OpenButton = Instance.new("TextButton")
    OpenButton.Name = "OpenButton"
    OpenButton.Size = UDim2.new(0, 50, 0, 50)
    OpenButton.Position = UDim2.new(0, 20, 0.5, -25)
    OpenButton.BackgroundColor3 = Color3.fromRGB(255, 235, 59)
    OpenButton.Text = "Open"
    OpenButton.TextColor3 = Color3.fromRGB(0, 87, 231)
    OpenButton.Font = Enum.Font.SourceSansBold
    OpenButton.TextSize = 14
    OpenButton.Active = true
    OpenButton.Visible = false
    OpenButton.Parent = ScreenGui

    local OpenCorner = Instance.new("UICorner")
    OpenCorner.CornerRadius = UDim.new(0, 8)
    OpenCorner.Parent = OpenButton

    local OpenStroke = Instance.new("UIStroke")
    OpenStroke.Color = Color3.fromRGB(0, 87, 231)
    OpenStroke.Thickness = 2
    OpenStroke.Parent = OpenButton

    local HideButton = Instance.new("TextButton")
    HideButton.Name = "HideButton"
    HideButton.Size = UDim2.new(0, 35, 0, 35)
    HideButton.Position = UDim2.new(1, -70, 0, 0)
    HideButton.BackgroundTransparency = 1
    HideButton.Text = "-"
    HideButton.TextColor3 = Color3.fromRGB(0, 87, 231)
    HideButton.TextSize = 24
    HideButton.Font = Enum.Font.SourceSansBold
    HideButton.Parent = TopBar

    -- Toggle Actions (With simple click verification to block trigger during drag)
    local isDraggingOpenBtn = false

    HideButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        OpenButton.Visible = true
    end)

    OpenButton.MouseButton1Click:Connect(function()
        if not isDraggingOpenBtn then
            MainFrame.Visible = true
            OpenButton.Visible = false
        end
    end)

    -- OpenButton Dragging Implementation
    local btnDragging, btnDragInput, btnDragStart, btnStartPos

    local function updateOpenBtn(input)
        local delta = input.Position - btnDragStart
        local targetPos = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
        TweenService:Create(OpenButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    end

    OpenButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            btnDragging = true
            isDraggingOpenBtn = false
            btnDragStart = input.Position
            btnStartPos = OpenButton.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    btnDragging = false
                    task.wait()
                    isDraggingOpenBtn = false
                end
            end)
        end
    end)

    OpenButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            btnDragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == btnDragInput and btnDragging then
            if (input.Position - btnDragStart).Magnitude > 5 then
                isDraggingOpenBtn = true
            end
            updateOpenBtn(input)
        end
    end)

    -- ==========================================

    -- Smooth Dragging Implementation (MainFrame)
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
        -- Tab Sidebar Container (Left side)
    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.Position = UDim2.new(0, 10, 0, 45)
    TabBar.Size = UDim2.new(0, 100, 1, -55)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = MainFrame

    local TabBarLayout = Instance.new("UIListLayout")
    TabBarLayout.Parent = TabBar
    TabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabBarLayout.Padding = UDim.new(0, 5)

    -- Container for all Tab Content Pages (Right side)
    local PagesContainer = Instance.new("Frame")
    PagesContainer.Name = "PagesContainer"
    PagesContainer.Position = UDim2.new(0, 120, 0, 45)
    PagesContainer.Size = UDim2.new(1, -130, 1, -55)
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.Parent = MainFrame

    -- Tracking system for your tabs
    local WindowData = {
        TabBar = TabBar,
        PagesContainer = PagesContainer,
        CurrentTab = nil
    }

    return WindowData
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
-- ФУНКЦИЯ СОЗДАНИЯ ПЕРЕКЛЮЧАТЕЛЯ (TOGGLE)
function UIModule.CreateToggle(parent, text, defaultState, callback)
    local TweenService = game:GetService("TweenService")
    
    -- Конфигурация по умолчанию
    local ToggleState = (defaultState == nil) and false or defaultState
    
    -- Главный контейнер для тогла (строка)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = text .. "ToggleFrame"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(245, 220, 25) -- Чуть темнее основного фона
    ToggleFrame.BackgroundTransparency = 0.2
    ToggleFrame.Parent = parent

    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 6)
    FrameCorner.Parent = ToggleFrame

    -- Текст тогла
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "Label"
    ToggleLabel.Size = UDim2.new(1, -45, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.fromRGB(0, 87, 231) -- Синий текст
    ToggleLabel.Font = Enum.Font.SourceSansBold
    ToggleLabel.TextSize = 16
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame

    -- Квадратный бокс-индикатор
    local ToggleBox = Instance.new("Frame")
    ToggleBox.Name = "ToggleBox"
    ToggleBox.Size = UDim2.new(0, 22, 0, 22)
    ToggleBox.Position = UDim2.new(1, -32, 0.5, 0)
    ToggleBox.AnchorPoint = Vector2.new(0, 0.5)
    ToggleBox.BackgroundColor3 = Color3.fromRGB(180, 180, 180) -- Серый по умолчанию (выключен)
    ToggleBox.Parent = ToggleFrame

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 5)
    BoxCorner.Parent = ToggleBox

    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Color = Color3.fromRGB(0, 87, 231)
    BoxStroke.Thickness = 1.5
    BoxStroke.Parent = ToggleBox

    -- Невидимая кнопка для клика по всей площади тогла
    local ClickButton = Instance.new("TextButton")
    ClickButton.Name = "ClickButton"
    ClickButton.Size = UDim2.new(1, 0, 1, 0)
    ClickButton.BackgroundTransparency = 1
    ClickButton.Text = ""
    ClickButton.Parent = ToggleFrame

    -- Объект управления тогла (интерфейс)
    local ToggleObject = {
        Value = ToggleState
    }

    -- Функция обновления визуального состояния и вызова callback
    function ToggleObject:Set(value)
        ToggleObject.Value = value
        
        -- Цвета для анимации: Синий если включен, Серый если выключен
        local targetColor = ToggleObject.Value and Color3.fromRGB(0, 87, 231) or Color3.fromRGB(180, 180, 180)
        
        -- Плавная анимация цвета бокса
        TweenService:Create(ToggleBox, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = targetColor
        }):Play()

        -- Безопасный вызов вашей функции
        local success, err = pcall(callback, ToggleObject.Value)
        if not success then
            warn("Toggle error: " .. tostring(err))
        end
    end

    -- Обработка клика
    ClickButton.MouseButton1Click:Connect(function()
        ToggleObject:Set(not ToggleObject.Value)
    end)

    -- Установка начального состояния без задержек
    ToggleObject:Set(ToggleObject.Value)

    return ToggleObject
end

-- TAB CREATION FUNCTION
function UIModule.CreateTab(windowData, tabName)
    -- Create the navigation button on the left sidebar
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName .. "Tab"
    TabButton.Size = UDim2.new(1, 0, 0, 30)
    TabButton.BackgroundColor3 = Color3.fromRGB(0, 87, 231) -- Blue
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.Font = Enum.Font.SourceSansBold
    TabButton.TextSize = 14
    TabButton.Parent = windowData.TabBar

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 4)
    ButtonCorner.Parent = TabButton

    -- Create the page frame for this tab on the right side
    local PageFrame = Instance.new("Frame")
    PageFrame.Name = tabName .. "Page"
    PageFrame.Size = UDim2.new(1, 0, 1, 0)
    PageFrame.BackgroundTransparency = 1
    PageFrame.Visible = false -- Hidden by default
    PageFrame.Parent = windowData.PagesContainer

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = PageFrame
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 8)

    -- Switch logic when clicked
    TabButton.MouseButton1Click:Connect(function()
        -- Hide all other pages
        for _, page in ipairs(windowData.PagesContainer:GetChildren()) do
            if page:IsA("Frame") then page.Visible = false end
        end
        -- Reset all tab button styles to normal
        for _, btn in ipairs(windowData.TabBar:GetChildren()) do
            if btn:IsA("TextButton") then btn.BackgroundColor3 = Color3.fromRGB(0, 87, 231) end
        end
        -- Show this page and highlight button
        PageFrame.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(0, 60, 180) -- Darker blue when active
    end)

    -- Auto-open the very first tab created
    if not windowData.CurrentTab then
        windowData.CurrentTab = PageFrame
        PageFrame.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(0, 60, 180)
    end

    return PageFrame -- Returns the page frame so you can pass it to UIModule.CreateButton()
end
-- DROPDOWN CREATION FUNCTION
function UIModule.CreateDropdown(parent, text, options, callback)
    local DropdownData = {
        Open = false,
        Selected = nil,
        Options = options or {}
    }

    -- Main Dropdown Button Container
    local DropdownMain = Instance.new("TextButton")
    DropdownMain.Name = text .. "Dropdown"
    DropdownMain.Size = UDim2.new(1, 0, 0, 35)
    DropdownMain.BackgroundColor3 = Color3.fromRGB(0, 87, 231) -- Blue
    DropdownMain.Text = "  " .. text .. ": None"
    DropdownMain.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownMain.Font = Enum.Font.SourceSansBold
    DropdownMain.TextSize = 14
    DropdownMain.TextXAlignment = Enum.TextXAlignment.Left
    DropdownMain.ClipsDescendants = false
    DropdownMain.Parent = parent

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 6)
    MainCorner.Parent = DropdownMain

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(240, 210, 20) -- Yellow
    MainStroke.Thickness = 1.5
    MainStroke.Parent = DropdownMain

    -- Arrow Visual Indicator
    local Arrow = Instance.new("TextLabel")
    Arrow.Name = "Arrow"
    Arrow.Size = UDim2.new(0, 35, 1, 0)
    Arrow.Position = UDim2.new(1, -35, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
    Arrow.TextSize = 12
    Arrow.Font = Enum.Font.SourceSansBold
    Arrow.Parent = DropdownMain

    -- Scrolling Container for Dropdown Options
    local ItemsContainer = Instance.new("ScrollingFrame")
    ItemsContainer.Name = "ItemsContainer"
    ItemsContainer.Size = UDim2.new(1, 0, 0, 0) -- Starts at 0 height
    ItemsContainer.Position = UDim2.new(0, 0, 1, 5)
    ItemsContainer.BackgroundColor3 = Color3.fromRGB(0, 60, 180) -- Darker Blue
    ItemsContainer.BorderSizePixel = 0
    ItemsContainer.Visible = false
    ItemsContainer.ZIndex = 5 -- Ensures it renders above elements below it
    ItemsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    ItemsContainer.ScrollBarThickness = 4
    ItemsContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 235, 59)
    ItemsContainer.Parent = DropdownMain

    local ItemsLayout = Instance.new("UIListLayout")
    ItemsLayout.Parent = ItemsContainer
    ItemsLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local ItemsCorner = Instance.new("UICorner")
    ItemsCorner.CornerRadius = UDim.new(0, 6)
    ItemsCorner.Parent = ItemsContainer

    -- Auto-adjust CanvasSize based on elements added
    ItemsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ItemsContainer.CanvasSize = UDim2.new(0, 0, 0, ItemsLayout.AbsoluteContentSize.Y)
    end)

    -- Toggle Dropdown Open/Closed State
    local function ToggleDropdown()
        DropdownData.Open = not DropdownData.Open
        if DropdownData.Open then
            Arrow.Text = "▲"
            ItemsContainer.Visible = true
            -- Dynamically size height based on choices (cap at 105px max height)
            local targetHeight = math.min(ItemsLayout.AbsoluteContentSize.Y, 105)
            game:GetService("TweenService"):Create(ItemsContainer, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
        else
            Arrow.Text = "▼"
            local closeTween = game:GetService("TweenService"):Create(ItemsContainer, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, 0)})
            closeTween:Play()
            closeTween.Completed:Connect(function()
                if not DropdownData.Open then ItemsContainer.Visible = false end
            end)
        end
    end

    DropdownMain.MouseButton1Click:Connect(ToggleDropdown)

    -- Function to populate elements into the list
    local function RefreshOptions()
        for _, child in ipairs(ItemsContainer:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        for _, optionName in ipairs(DropdownData.Options) do
            local OptionBtn = Instance.new("TextButton")
            OptionBtn.Name = optionName .. "Option"
            OptionBtn.Size = UDim2.new(1, 0, 0, 30)
            OptionBtn.BackgroundColor3 = Color3.fromRGB(0, 60, 180)
            OptionBtn.BackgroundTransparency = 1
            OptionBtn.Text = "  " .. optionName
            OptionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            OptionBtn.TextSize = 14
            OptionBtn.Font = Enum.Font.SourceSans
            OptionBtn.TextXAlignment = Enum.TextXAlignment.Left
            OptionBtn.ZIndex = 6
            OptionBtn.Parent = ItemsContainer

            OptionBtn.MouseButton1Click:Connect(function()
                DropdownData.Selected = optionName
                DropdownMain.Text = "  " .. text .. ": " .. optionName
                ToggleDropdown()
                task.spawn(callback, optionName)
            end)
        end
    end

    RefreshOptions()

    -- Expose helper methods to modify dropdown choices on the fly
    function DropdownData:UpdateOptions(newOptions)
        DropdownData.Options = newOptions or {}
        RefreshOptions()
    end

    return DropdownData
end

return UIModule
