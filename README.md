-- loadstring(game:HttpGet("https://raw.githubusercontent.com/ninvislnive/aotr-script/main/src.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- // ЭФФЕКТ ЧЁРНОЙ ДЫРЫ //
local function createBlackHoleEffect()
    local screenGui = Instance.new("ScreenGui", CoreGui)
    local blackFrame = Instance.new("Frame", screenGui)
    blackFrame.Size = UDim2.new(1, 0, 1, 0)
    blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    blackFrame.BackgroundTransparency = 1
    TweenService:Create(blackFrame, TweenInfo.new(1.5), {BackgroundTransparency = 0.3}):Play()
    
    local vortex = Instance.new("ImageLabel", screenGui)
    vortex.Size = UDim2.new(2, 0, 2, 0)
    vortex.Position = UDim2.new(-0.5, 0, -0.5, 0)
    vortex.BackgroundTransparency = 1
    vortex.Image = "rbxassetid://15267164995" -- анимированная спираль
    vortex.ImageTransparency = 1
    TweenService:Create(vortex, TweenInfo.new(2), {ImageTransparency = 0.5, Rotation = 360}):Play()
    
    for i = 1, 30 do
        local particle = Instance.new("Frame", screenGui)
        particle.Size = UDim2.new(0, 4, 0, 4)
        particle.BackgroundColor3 = Color3.new(1, 1, 1)
        particle.Position = UDim2.new(0.5, math.random(-200, 200), 0.5, math.random(-200, 200))
        particle.AnchorPoint = Vector2.new(0.5, 0.5)
        local tween = TweenService:Create(particle, TweenInfo.new(2 + math.random(), Enum.EasingStyle.InQuad), {
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        })
        tween:Play()
        task.delay(2.5, function() particle:Destroy() end)
    end
    
    task.wait(2.2)
    screenGui:Destroy()
end

-- // ГЛАВНОЕ МЕНЮ //
local function createMainGUI()
    local gui = Instance.new("ScreenGui", CoreGui)
    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 320, 0, 440)
    main.Position = UDim2.new(0, 20, 0, 20)
    main.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", main).Color = Color3.fromRGB(180, 100, 255)
    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Text = "🌌 AOTR SWILL | КОСМОС"
    title.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SciFi
    title.TextSize = 16
    Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)
    local scroll = Instance.new("ScrollingFrame", main)
    scroll.Size = UDim2.new(1, 0, 1, -30)
    scroll.Position = UDim2.new(0, 0, 0, 30)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 500)
    scroll.ScrollBarThickness = 4
    scroll.BackgroundTransparency = 1
    local list = Instance.new("UIListLayout", scroll)
    list.Padding = UDim.new(0, 5)
    local function addBtn(name, callback)
        local btn = Instance.new("TextButton", scroll)
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.Text = name
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 14
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end
    local settings = {Farm = false, Chest = false, Jacket = false, Speed = 16}
    local tglFarm = addBtn("Автофарм [ВЫКЛ]", function()
        settings.Farm = not settings.Farm
        tglFarm.Text = "Автофарм [" .. (settings.Farm and "ВКЛ" or "ВЫКЛ") .. "]"
    end)
    local tglChest = addBtn("Сбор сундуков [ВЫКЛ]", function()
        settings.Chest = not settings.Chest
        tglChest.Text = "Сбор сундуков [" .. (settings.Chest and "ВКЛ" or "ВЫКЛ") .. "]"
    end)
    local tglJacket = addBtn("Куртка семьи [ВЫКЛ]", function()
        settings.Jacket = not settings.Jacket
        tglJacket.Text = "Куртка семьи [" .. (settings.Jacket and "ВКЛ" or "ВЫКЛ") .. "]"
    end)
    addBtn("Speed x5", function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = 50 end
    end)
    addBtn("NoClip", function()
        for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)
    addBtn("Сменить сервер", function()
        local http = game:GetService("HttpService")
        local tp = game:GetService("TeleportService")
        local servers = {}
        local cursor = ""
        repeat
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100&cursor=" .. cursor
            local ok, data = pcall(function() return http:JSONDecode(game:HttpGet(url)) end)
            if not ok then break end
            for _, s in ipairs(data.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    table.insert(servers, s.id)
                end
            end
            cursor = data.nextPageCursor or ""
        until cursor == "" or #servers >= 10
        if #servers > 0 then
            tp:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        end
    end)
    
    -- РАБОЧИЕ ФУНКЦИИ
    local function getChar() return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() end
    local function getRoot() return getChar() and getChar():FindFirstChild("HumanoidRootPart") end
    local function tween(pos)
        local root = getRoot()
        if not root then return end
        TweenService:Create(root, TweenInfo.new(0.5), {CFrame = CFrame.new(pos)}):Play()
    end
    
    RunService.Heartbeat:Connect(function()
        if settings.Farm then
            local root = getRoot()
            if not root then return end
            local nearest, ndist = nil, 200
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and obj.Name:lower():find("titan") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                    local hrp = obj:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local dist = (root.Position - hrp.Position).Magnitude
                        if dist < ndist then ndist = dist; nearest = obj end
                    end
                end
            end
            if nearest then
                tween(nearest.HumanoidRootPart.Position)
                task.wait(0.2)
                pcall(function()
                    local atk = ReplicatedStorage:FindFirstChild("Attack") or ReplicatedStorage:FindFirstChild("Hit")
                    if atk then atk:FireServer(nearest) end
                end)
            end
        end
        if settings.Chest then
            local root = getRoot()
            if root then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj.Name == "Chest" and obj:IsA("BasePart") and obj.Transparency < 1 then
                        if (root.Position - obj.Position).Magnitude < 100 then
                            tween(obj.Position)
                            task.wait(0.3)
                            fireproximityprompt(obj)
                            break
                        end
                    end
                end
            end
        end
        if settings.Jacket then
            local char = getChar()
            if char then
                for _, v in ipairs(LocalPlayer.Backpack:GetChildren()) do
                    if (v.Name == "Yeager Jacket" or v.Name == "Ackerman Jacket") and v:IsA("Tool") then
                        char.Humanoid:EquipTool(v)
                        break
                    end
                end
            end
        end
    end)
end

-- ЗАПУСК
createBlackHoleEffect()
task.wait(2.5)
createMainGUI()
print("Метка: SWILL – AOTR скрипт с эффектом чёрной дыры запущен.")
