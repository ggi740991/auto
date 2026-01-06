
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer


local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SantaFarmGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or CoreGui


local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 220)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 0.7
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.ZIndex = -1
shadow.Parent = mainFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 18)
shadowCorner.Parent = shadow


local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 20, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 30, 50))
}
gradient.Rotation = 45
gradient.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0.6),
    NumberSequenceKeypoint.new(1, 0.8)
}
gradient.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "Santa Farm"
title.TextColor3 = Color3.fromRGB(220, 180, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 24
title.Parent = mainFrame


local santaToggleBtn = Instance.new("TextButton")
santaToggleBtn.Size = UDim2.new(0.9, 0, 0, 50)
santaToggleBtn.Position = UDim2.new(0.05, 0, 0, 60)
santaToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
santaToggleBtn.Text = "Spawn Timer : OFF"
santaToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
santaToggleBtn.Font = Enum.Font.GothamSemibold
santaToggleBtn.TextSize = 18
santaToggleBtn.AutoButtonColor = false
santaToggleBtn.Parent = mainFrame

local timerCorner = Instance.new("UICorner")
timerCorner.CornerRadius = UDim.new(0, 12)
timerCorner.Parent = santaToggleBtn

local timerStroke = Instance.new("UIStroke")
timerStroke.Thickness = 1.5
timerStroke.Color = Color3.fromRGB(120, 80, 180)
timerStroke.Transparency = 0.5
timerStroke.Parent = santaToggleBtn


local autoFarmBtn = Instance.new("TextButton")
autoFarmBtn.Size = UDim2.new(0.9, 0, 0, 50)
autoFarmBtn.Position = UDim2.new(0.05, 0, 0, 120)
autoFarmBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
autoFarmBtn.Text = "Auto Farm : OFF"
autoFarmBtn.TextColor3 = Color3.fromRGB(180, 255, 200)
autoFarmBtn.Font = Enum.Font.GothamSemibold
autoFarmBtn.TextSize = 18
autoFarmBtn.AutoButtonColor = false
autoFarmBtn.Parent = mainFrame

local farmCorner = Instance.new("UICorner")
farmCorner.CornerRadius = UDim.new(0, 12)
farmCorner.Parent = autoFarmBtn

local farmStroke = Instance.new("UIStroke")
farmStroke.Thickness = 1.5
farmStroke.Color = Color3.fromRGB(80, 180, 120)
farmStroke.Transparency = 0.5
farmStroke.Parent = autoFarmBtn


local function addHoverEffect(btn, onColor, offColor)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = onColor}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if (btn == santaToggleBtn and not isTimerOn) or (btn == autoFarmBtn and not isAutoFarmOn) then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = offColor}):Play()
        end
    end)
end

addHoverEffect(santaToggleBtn, Color3.fromRGB(80, 50, 120), Color3.fromRGB(35, 35, 45))
addHoverEffect(autoFarmBtn, Color3.fromRGB(50, 120, 80), Color3.fromRGB(35, 35, 45))


local dragging = false
local dragInput, mousePos, framePos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - mousePos
        mainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)


local isTimerOn = false
local santaGui = nil
local isAutoFarmOn = false

local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local patrolPoints = {
    Vector3.new(226.07867431640625, 205.39108276367188, 3528.91943359375),
    Vector3.new(-346.95526123046875, 180.53976440429688, 3215.173095703125),
    Vector3.new(-133.61676025390625, 160.21591186523438, 1905.654296875),
    Vector3.new(-196.74612426757812, 56.33758544921875, 931.7725219726562),
    Vector3.new(209.63037109375, 49.647117614746094, 2776.905029296875),
    Vector3.new(-69.61618041992188, 56.33758544921875, -216.33465576171875),
}

local currentPointIndex = 1
local autoFarmConnection = nil

-- 산타 찾기 함수
local function findNearestSanta()
    local mobs = Workspace:FindFirstChild("Mobs") or Workspace
    local closest, bestDist = nil, math.huge
    for _, v in mobs:GetChildren() do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and (v.Name:lower():find("santa") or v.Name == "산타") then
            local dist = (v.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
            if dist < bestDist then bestDist = dist closest = v end
        end
    end
    return closest
end


local function createSantaTimer()
    if santaGui then santaGui:Destroy() end

    local uiParent = (gethui and gethui()) or CoreGui
    local gui = Instance.new("ScreenGui")
    gui.Name = "SantaSpawnUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 9999
    gui.Parent = uiParent
    santaGui = gui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromScale(0.32, 0.1)
    frame.Position = UDim2.fromScale(0.5, 0.05)
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    frame.BackgroundTransparency = 0.2
    frame.ZIndex = 10000
    frame.Parent = gui

    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 16)
    fCorner.Parent = frame

    local fStroke = Instance.new("UIStroke")
    fStroke.Color = Color3.fromRGB(180, 100, 255)
    fStroke.Thickness = 2
    fStroke.Parent = frame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.fromScale(1, 0.45)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Santa Timer"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 26
    titleLabel.TextColor3 = Color3.fromRGB(200, 140, 255)
    titleLabel.ZIndex = 10001
    titleLabel.Parent = frame

    local timerText = Instance.new("TextLabel")
    timerText.Position = UDim2.fromScale(0, 0.45)
    timerText.Size = UDim2.fromScale(1, 0.55)
    timerText.BackgroundTransparency = 1
    timerText.Font = Enum.Font.GothamSemibold
    timerText.TextSize = 22
    timerText.TextColor3 = Color3.fromRGB(230, 230, 255)
    timerText.ZIndex = 10001
    timerText.Parent = frame

    local santaFolder = Workspace:WaitForChild("Spawner"):WaitForChild("산타")
    local Cool = santaFolder:WaitForChild("Cool")
    local CoolTime = santaFolder:WaitForChild("CoolTime")

    local function updateTimer()
        local remaining = CoolTime.Value - Cool.Value
        if remaining <= 0 then
            timerText.Text = "Spawning Now"
        elseif remaining >= CoolTime.Value then
            timerText.Text = "Waiting..."
        else
            timerText.Text = "Time Left: " .. remaining .. "s"
        end
    end

    updateTimer()
    Cool:GetPropertyChangedSignal("Value"):Connect(updateTimer)
    CoolTime:GetPropertyChangedSignal("Value"):Connect(updateTimer)

    task.spawn(function()
        while gui.Parent do
            updateTimer()
            task.wait(1)
        end
    end)
end


santaToggleBtn.MouseButton1Click:Connect(function()
    isTimerOn = not isTimerOn
    if isTimerOn then
        createSantaTimer()
        santaToggleBtn.Text = "Spawn Timer : ON"
        TweenService:Create(santaToggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(100, 60, 150)}):Play()
        timerStroke.Color = Color3.fromRGB(200, 120, 255)
    else
        if santaGui then santaGui:Destroy() santaGui = nil end
        santaToggleBtn.Text = "Spawn Timer : OFF"
        TweenService:Create(santaToggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
        timerStroke.Color = Color3.fromRGB(120, 80, 180)
    end
end)


autoFarmBtn.MouseButton1Click:Connect(function()
    isAutoFarmOn = not isAutoFarmOn
    if isAutoFarmOn then
        autoFarmBtn.Text = "Auto Farm : ON"
        TweenService:Create(autoFarmBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(70, 150, 100)}):Play()
        farmStroke.Color = Color3.fromRGB(120, 255, 180)

        local lastPatrolUpdate = 0  

        autoFarmConnection = RunService.Heartbeat:Connect(function()
            if not humanoidRootPart or not humanoidRootPart.Parent then return end

            local now = tick()
            local santa = findNearestSanta()

            if santa and santa:FindFirstChild("HumanoidRootPart") then
              
                local root = santa.HumanoidRootPart
                local behind = root.Position - root.CFrame.LookVector * 5
                humanoidRootPart.CFrame = CFrame.new(behind + Vector3.new(0, 3, 0), root.Position + Vector3.new(0, 2, 0))
                
                lastPatrolUpdate = now  
            else
           
                if now - lastPatrolUpdate >= 0.5 then
                    lastPatrolUpdate = now

                    local target = patrolPoints[currentPointIndex]
                    humanoidRootPart.CFrame = CFrame.new(target)

                    if (humanoidRootPart.Position - target).Magnitude < 20 then
                        currentPointIndex = currentPointIndex % #patrolPoints + 1
                    end
                end
            end
        end)

    else
        autoFarmBtn.Text = "Auto Farm : OFF"
        TweenService:Create(autoFarmBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
        farmStroke.Color = Color3.fromRGB(80, 180, 120)
        
        if autoFarmConnection then
            autoFarmConnection:Disconnect()
            autoFarmConnection = nil
        end
    end
end)


player.CharacterAdded:Connect(function(c)
    character = c
    humanoidRootPart = c:WaitForChild("HumanoidRootPart")
end)
