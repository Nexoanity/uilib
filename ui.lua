local library = {}

-- services
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- create screen gui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui

-- create main window
function library:CreateWindow(title)
    local window = Instance.new("Frame")
    window.Size = UDim2.new(0, 400, 0, 250)
    window.Position = UDim2.new(0.5, -200, 0.3, 0)
    window.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    window.BorderSizePixel = 0
    window.ClipsDescendants = true
    window.Parent = screenGui

    -- rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = window

    -- title bar
    local titleBar = Instance.new("TextLabel")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titleBar.Text = title
    titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleBar.Parent = window

    local cornerBar = Instance.new("UICorner")
    cornerBar.CornerRadius = UDim.new(0, 10)
    cornerBar.Parent = titleBar

    -- close button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.Text = "X"
    closeButton.Parent = titleBar
    closeButton.MouseButton1Click:Connect(function()
        window:Destroy()
    end)

    -- minimize button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -60, 0, 0)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    minimizeButton.Text = "_"
    minimizeButton.Parent = titleBar
    local minimized = false
    minimizeButton.MouseButton1Click:Connect(function()
        if minimized then
            window:TweenSize(UDim2.new(0, 400, 0, 250), "Out", "Quad", 0.3, true)
        else
            window:TweenSize(UDim2.new(0, 400, 0, 30), "Out", "Quad", 0.3, true)
        end
        minimized = not minimized
    end)

    -- drag function
    local dragging, dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
        end
    end)
    titleBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- tab system
    local tabs = {}
    local currentTab = nil
    function window:AddTab(tabName)
        local tab = Instance.new("ScrollingFrame")
        tab.Size = UDim2.new(1, 0, 1, -30)
        tab.Position = UDim2.new(0, 0, 0, 30)
        tab.BackgroundTransparency = 1
        tab.Visible = false
        tab.Parent = window

        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 100, 0, 30)
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        button.Text = tabName
        button.Parent = titleBar
        button.MouseButton1Click:Connect(function()
            if currentTab then currentTab.Visible = false end
            tab.Visible = true
            currentTab = tab
        end)

        tabs[#tabs+1] = tab
        if #tabs == 1 then
            currentTab = tab
            tab.Visible = true
        end

        function tab:AddButton(text, callback)
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, -10, 0, 30)
            button.Position = UDim2.new(0, 5, 0, #tab:GetChildren() * 35)
            button.BackgroundColor3 = Color3.fromRGB(80, 80, 255)
            button.Text = text
            button.Parent = tab
            button.MouseButton1Click:Connect(callback)

            local hover = Instance.new("UIStroke")
            hover.Thickness = 2
            hover.Color = Color3.fromRGB(255, 255, 255)
            hover.Parent = button

            button.MouseEnter:Connect(function()
                hover.Thickness = 3
            end)
            button.MouseLeave:Connect(function()
                hover.Thickness = 2
            end)
        end

        return tab
    end

    return window
end

-- FPS & Ping Counter
local statsGui = Instance.new("ScreenGui")
statsGui.Parent = game.CoreGui

local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.new(0, 200, 0, 30)
statsLabel.Position = UDim2.new(1, -210, 0, 10)
statsLabel.BackgroundTransparency = 1
statsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statsLabel.Text = "FPS: 0 | Ping: 0ms"
statsLabel.Parent = statsGui

RunService.RenderStepped:Connect(function()
    local ping = math.random(20, 100) -- fake ping, replace with real ping
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    statsLabel.Text = "FPS: " .. fps .. " | Ping: " .. ping .. "ms"
end)

-- Notifications
function library:SendNotification(title, text)
    local notification = Instance.new("TextLabel")
    notification.Size = UDim2.new(0, 200, 0, 50)
    notification.Position = UDim2.new(1, -220, 0, 50)
    notification.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    notification.Text = title .. ": " .. text
    notification.Parent = statsGui

    local fadeOut = TweenService:Create(notification, TweenInfo.new(2, Enum.EasingStyle.Quad), {BackgroundTransparency = 1, TextTransparency = 1})
    wait(3)
    fadeOut:Play()
    fadeOut.Completed:Connect(function()
        notification:Destroy()
    end)
end

return library
