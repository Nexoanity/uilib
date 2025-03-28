local library = {}
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local stats = game:GetService("Stats")

-- create ui window
function library:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.CoreGui

    local window = Instance.new("Frame")
    window.Size = UDim2.new(0, 400, 0, 250)
    window.Position = UDim2.new(0.5, -200, 0.3, 0)
    window.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    window.BorderSizePixel = 0
    window.Parent = screenGui
    window.Active = true
    window.Draggable = true
    window.ClipsDescendants = true
    
    local titleBar = Instance.new("TextLabel")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleBar.Text = title
    titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleBar.Parent = window

    -- minimize & close buttons
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.Parent = window
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -60, 0, 0)
    minimizeButton.Text = "_"
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.Parent = window
    minimizeButton.MouseButton1Click:Connect(function()
        window.Visible = not window.Visible
    end)
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 30)
    tabContainer.Position = UDim2.new(0, 0, 0, 30)
    tabContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabContainer.Parent = window

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -60)
    contentFrame.Position = UDim2.new(0, 0, 0, 60)
    contentFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    contentFrame.Parent = window

    local tabs = {}
    
    function library:AddTab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0, 100, 1, 0)
        tabButton.Text = name
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.Parent = tabContainer

        local tabFrame = Instance.new("Frame")
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.Visible = false
        tabFrame.Parent = contentFrame

        tabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(tabs) do
                t.Frame.Visible = false
            end
            tabFrame.Visible = true
        end)
        
        local tabData = {Frame = tabFrame}
        table.insert(tabs, tabData)
        return tabData
    end
    
    return library
end

-- fps & ping display
local fpsCounter = Instance.new("TextLabel")
fpsCounter.Size = UDim2.new(0, 200, 0, 30)
fpsCounter.Position = UDim2.new(1, -210, 0, 10)
fpsCounter.BackgroundTransparency = 1
fpsCounter.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsCounter.Text = "FPS: 0 | Ping: 0ms"
fpsCounter.Parent = game.CoreGui

runService.RenderStepped:Connect(function()
    fpsCounter.Text = string.format("FPS: %d | Ping: %dms", math.floor(1 / runService.RenderStepped:Wait()), stats.Network.ServerStatsItem["Data Ping"]:GetValue())
end)

return library
