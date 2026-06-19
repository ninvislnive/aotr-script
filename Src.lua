local p,R,S,V,W,WS,plr,char,hrp=getfenv,game.ReplicatedStorage,game.GetService,game.VirtualInputManager,game.Workspace,game.RunService,game.Players.LocalPlayer,plr.Character or plr.CharacterAdded:Wait,char and char:WaitForChild("HumanoidRootPart")
local A,SETTINGS=function(n)return S("Players").LocalPlayer.Character or S("Players").LocalPlayer.CharacterAdded:Wait()end,{
Farm=true,Up=true,Chests=true,Jacket=true,Speed=100,Jump=80,HopTime=60}
local function getRoot()return A().HumanoidRootPart end
local function getHum()return A().Humanoid end
local function tweenTo(pos)if getRoot()then local d=(pos-getRoot().Position).Magnitude;local t=S("TweenService"):Create(getRoot(),TweenInfo.new(d/SETTINGS.Speed,Enum.EasingStyle.Linear),{CFrame=CFrame.new(pos)});t:Play()end end
local function jacket()if not SETTINGS.Jacket then return end;local n={"Yeager Jacket","Jaeger Jacket","Ackerman Jacket"};for _,t in ipairs(plr.Backpack:GetChildren())do for _,j in ipairs(n)do if t.Name==j and t:IsA("Tool")then getHum():EquipTool(t)end end end end
local function farm()if SETTINGS.Farm then for _,v in ipairs(W:GetDescendants())do if v:IsA("Model")and v.Name:lower():find("titan")and v:FindFirstChild("Humanoid")and v.Humanoid.Health>0 then local r=v:FindFirstChild("HumanoidRootPart");if r then tweenTo(r.Position);wait(0.1);local atk=R:FindFirstChild("Attack")or R:FindFirstChild("Hit");if atk then atk:FireServer(v)end break end end end end end
local function chests()if SETTINGS.Chests then for _,c in ipairs(W:GetDescendants())do if c.Name=="Chest"and c:IsA("BasePart")and c.Transparency<1 then tweenTo(c.Position);wait(0.2);fireproximityprompt(c)end end end end
local function upgrade()if SETTINGS.Up then local g=plr.PlayerGui:FindFirstChild("MainGui")or plr.PlayerGui:FindFirstChild("StatsGui");if g then local f=g:FindFirstChild("Upgrade")or g:FindFirstChild("Stats");if f then for _,b in ipairs(f:GetChildren())do if b:IsA("TextButton")and b.Visible then for _=1,10 do fireclickdetector(b)wait(0.05)end end end end end end
local function noClip()for _,p in ipairs(A():GetDescendants())do if p:IsA("BasePart")then p.CanCollide=false end end;WS.Stepped:Connect(function()if A()then for _,p in ipairs(A():GetDescendants())do if p:IsA("BasePart")then p.CanCollide=false end end end end)end
local function fastAtk()if SETTINGS.Farm then pcall(function()local h=getHum();local a=h:LoadAnimation(R:WaitForChild("Animations"):WaitForChild("Attack"));a:Play();a:AdjustSpeed(10)end)end end
local function hop()if tick()-lastHop>SETTINGS.HopTime then local s={};local c="";while#s<10 do local r=game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100&cursor="..c)local d=S("HttpService"):JSONDecode(r)for _,v in ipairs(d.data)do if v.playing<v.maxPlayers and v.id~=game.JobId then table.insert(s,v.id)end end;c=d.nextPageCursor or""if c==""then break end end;if#s>0 then S("TeleportService"):TeleportToPlaceInstance(game.PlaceId,s[math.random(1,#s)],plr)end;lastHop=tick()end end
local lastHop=tick()
noClip()
plr.CharacterAdded:Connect(function()wait(1);jacket();getHum().WalkSpeed=SETTINGS.Speed;getHum().JumpPower=SETTINGS.Jump;noClip()end)
spawn(function()while wait(0.1)do pcall(farm)pcall(chests)pcall(upgrade)pcall(jacket)pcall(fastAtk)pcall(hop)end end)
