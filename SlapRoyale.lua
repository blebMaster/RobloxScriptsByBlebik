getgenv().RAYFIELD_SECURE =  true
-- getgenv().RAYFIELD_ASSET_ID = 138361542409015

print("запуск blebik script")
--GUI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()
local Window = Rayfield:CreateWindow({
   Name = "BLEBIK SCRIPT",
   LoadingTitle = "blebik script",
   LoadingSubtitle = "made by blebik",
   ConfigurationSaving = { Enabled = false },
})

Window:ChangeTheme("Amethyst")
--Табы
local MovementTab = Window:CreateTab({ name = "All games"})
local SBTab = Window:CreateTab({ name = "Slap Battles"})
local FriendsTab = Window:CreateTab({ name = "Friends"})
local SRTab = Window:CreateTab({ name = "Slap Royale"})
local RivalsTab = Window:CreateTab({ name = "Rivals"})
local MiscTab = Window:CreateTab({ name = "other"})
--Services
local input = game:GetService("UserInputService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char = plr.Character
local Mouse = plr:GetMouse()
local RunService = game:GetService("RunService")
local Storage = game:GetService("ReplicatedStorage")
--variables
local selectedPlayer = nil
local platform = false --AntiVoid Platform
local targetCD = false
local autoFlick = false
local esp = false
local notify = false -- SR Items Notify
local EspUpdCd = 3
local triggerBot = false
local onlyHeads = false
local AIM_ASSIST_RANGE = 250
local AIM_ASSIST_FOV = 180
local FriendEspColor = Color3.fromRGB(66, 245, 87) 
local selectedCFG = nil
local items = {
    ["Bomb"] = Color3.fromRGB(26, 25, 25), 
    ["Bull's essence"] = Color3.fromRGB(77, 29, 0), 
    ["True Power"] = Color3.fromRGB(168, 12, 12),
    ["Potion of Strength"] = Color3.fromRGB(156, 23, 3), 
    ["Frog Potion"] = Color3.fromRGB(3, 72, 156), 
    ["Bandage"] = Color3.fromRGB(247, 89, 89),
    ["Lightining Potion"] = Color3.fromRGB(255, 255, 61),
    ["Speed Potion"] = Color3.fromRGB(255, 255, 61),
    ["Gravitation Shard"] = Color3.fromRGB(107, 16, 130),
    ["Boba"] = Color3.fromRGB(255, 211, 189),
    ["Apple"] = Color3.fromRGB(66, 245, 138),
    ["Forcefield Crystal"] = Color3.fromRGB(16, 107, 98),
    ["Sphere of fury"] = Color3.fromRGB(189, 66, 0),
    ["First Aid Kit"] = Color3.fromRGB(30, 247, 59),
    ["Cube of Ice"] = Color3.fromRGB(19, 240, 232),
    ["Tomahawk"] = Color3.fromRGB(109, 115, 115),
    ["Healing Potion"] = Color3.fromRGB(240, 98, 221),
}
local nameForCfg = nil
local healItems = {"Apple","Bandage","First Aid Kit","Healing Potion"}
local Permsitems = {"Bull's essence","Frog Potion","Speed Potion","Boba","Potion of Strength"}
local SpeedStrengh = 15
local friends = {}
local FriendRem = nil
local speedsUsed = false
local aimAssist = false
local youInRagdoll = false
local targetName =  nil
local ignorePlayers = {} --Slap aura ignore them
local skipFlick = false
local SlapAuraHitbox = 15
local AimtargetPlayer = nil
local FriendAdd = nil
local AutoHeal = false
local hpHeal = 20
local lastCheck = 0
local AutoPerms = false
local antiRagdollEnabled = false
local SMOOTHNESS = 1
local SRStats = false
local codes = {
   ["http://www.roblox.com/asset/?id=9648755440"] = "8", --1
   ["http://www.roblox.com/asset/?id=9648765536"] = "2", --2
   ["http://www.roblox.com/asset/?id=9648723237"] = "3",--3
   ["http://www.roblox.com/asset/?id=9648718450"] = "6",--4
   ["http://www.roblox.com/asset/?id=9648769161"] = "4",--5
   ["http://www.roblox.com/asset/?id=9648730082"] = "6",--6
   ["http://www.roblox.com/asset/?id=9648734698"] = "2",--7
   ["http://www.roblox.com/asset/?id=9648712563"] = "2",--8
   ["http://www.roblox.com/asset/?id=9648742013"] = "7",--9
   ["http://www.roblox.com/asset/?id=9648745618"] = "3",--10
   ["http://www.roblox.com/asset/?id=9648715920"] = "6",--11
   ["http://www.roblox.com/asset/?id=9648752438"] = "2",--12
   ["http://www.roblox.com/asset/?id=9648749145"] = "8",--13
   ["http://www.roblox.com/asset/?id=9648759883"] = "9",--14
   ["http://www.roblox.com/asset/?id=9648738553"] = "8",--15
    
}
local Colors = {
    Power = Color3.fromRGB(255, 60, 60),  
    Speed = Color3.fromRGB(60, 255, 100),  
    Jump  = Color3.fromRGB(80, 180, 255)   
}
local SlapTp = false
local slapAura = false
local ItemESP = false
local camera = Workspace.CurrentCamera
local humanoidForHeal = nil
local bhop = false
local pressedD = false
local pressedA = false
local tpdist = 10
local tpcd = 2
local TpSpeed = false
local SRTp = false
local TpTolayerName = nil


function getPlayers()
   local t={}
   for _,v in pairs(Players:GetPlayers()) do
      if v~= plr then table.insert(t,v.Name) end
   end
   table.sort(t)
   return t
end


if game.Workspace:FindFirstChild("Shipments") then
local CratesService = game.Workspace.Shipments.Crates
CratesService.ChildAdded:Connect(function(object)
      local highlight = Instance.new("Highlight")
      highlight.OutlineColor = Color3.fromRGB(181, 63, 5)
      highlight.FillColor = Color3.fromRGB(59, 20, 1)
      highlight.Parent = object    
end)
local MeteorService = game.Workspace.Shipments.Instances
MeteorService.ChildAdded:Connect(function(object)
   Window:Notify({
   Title = "METEOR SPAWNED",
   Content="где то появился метеорит",
   Duration = 5
   })
   local highlight2 = Instance.new("Highlight")
   highlight2.OutlineColor = Color3.fromRGB(181, 63, 5)
   highlight2.FillColor = Color3.fromRGB(59, 20, 1)
   highlight2.Parent = object
end)
end

if game.Workspace:FindFirstChild("Items") then
humanoidForHeal = plr.Character:FindFirstChildOfClass("Humanoid")

local ItemService = game.Workspace.Items
ItemService.ChildAdded:Connect(function(object)
   task.spawn(function()
   if ItemESP then
      local color = items[object.Name]
      if not object:FindFirstChild("Highlight") then
         if not color then
            color = Color3.fromRGB(168, 12, 12) 
         end
         local highlight = Instance.new("Highlight")
         highlight.OutlineColor = color
         highlight.FillColor = color
         highlight.FillTransparency = 0.3
         highlight.Parent = object
         if not object:FindFirstChild("ItemESP") then
             local billboard = Instance.new("BillboardGui")
         billboard.Name = "ItemESP"
         billboard.Parent = object
         billboard.Size = UDim2.new(0, 200, 0, 50)
         billboard.StudsOffset = Vector3.new(0, 2, 0)
         billboard.AlwaysOnTop = true

         local label = Instance.new("TextLabel")
         label.Parent = billboard
         label.Size = UDim2.new(1, 0, 1, 0)
         label.BackgroundTransparency = 1

         label.Text = object.Name
         label.TextColor3 = color
         label.TextStrokeTransparency = 0
         label.TextScaled = false
         label.TextSize = 18
         label.Font = Enum.Font.SourceSansBold
         if notify then 
             Window:Notify({
               title = "Item has spawned",
               content = object.Name,
               duration = 3,
            })
         end            
         end
      end   
   end   
end)
end)

humanoidForHeal.HealthChanged:Connect(function(health)
if not AutoHeal then return end
   if health <= 0 then return end
        if health <= hpHeal then
         useHealingItem()
        end
    end)
end


--GUI Functions
local Dropdown = MiscTab:CreateDropdown({
   name="Select Player",
   options=getPlayers(),
   callback=function(opt)
      local name = typeof(opt)=="table" and opt[1] or opt
      targetName = name
   end
})

MiscTab:CreateButton({
   name="Refresh ",
   callback=function()
      Dropdown:Refresh(getPlayers())
   end
})

MiscTab:CreateButton({
   name="tool's childs",
   callback=function()
      local obj = plr.Character:FindFirstChildOfClass("Tool")
      for i,v in pairs(obj:GetChildren()) do
         print("name: " .. v.Name)
         print("type:".. v.ClassName)
      end
   end
})


MiscTab:CreateToggle({
   Name = "BHop",
   CurrentValue = false,
   Callback = function(v)
      bhop = v 
      if not v then
         local leg = plr.Character:FindFirstChild("Right Leg")
         local leg2 = plr.Character:FindFirstChild("Left Leg")
         leg.CanCollide = true
         leg.CanTouch = true
         leg.Position = leg2.Position + (leg2.CFrame.RightVector * 1)
      end
   end,
})


MovementTab:CreateToggle({
   Name="ESP",
   CurrentValue=false,
   Callback=function(a)
      esp = a
      for _,v in pairs(Players:GetPlayers()) do
         if v~=plr and v.Character then
            if esp then
               if not v.Character:FindFirstChild("Highlight") then
                  Instance.new("Highlight",v.Character)
                  isFriend = table.find(friends,v.Name)
                  if isFriend then
                  v.Character.Highlight.FillColor = FriendEspColor
                  end
               end
            else
               local h=v.Character:FindFirstChild("Highlight")
               if h then h:Destroy() end
            end
         end
      end
   end
})
MovementTab:CreateSlider({
   Name = "Esp Update Cooldown ",
   Range = {1, 20},
   Increment = 1,
   CurrentValue = 10,
   Callback = function(v)
      EspUpdCd = v
   end,
})

local TpDropdown = MovementTab:CreateDropdown({
   name="Select Player for tp to him",
   options=getPlayers(),
   callback=function(opt)
      local name = typeof(opt)=="table" and opt[1] or opt
      TpToPlayerName = name
   end
})

MovementTab:CreateButton({
   name="Refresh ",
   callback=function()
      TpDropdown:Refresh(getPlayers())
   end
})

MovementTab:CreateButton({
   Name="Tp to player",
   Callback=function(v)
    if not TpToPlayerName then return end
    local targetCFrame = Players:FindFirstChild(TpToPlayerName).Character:GetPivot()
    local safeCFrame = targetCFrame * CFrame.new(0, 3, 0)
    plr.Character:PivotTo(safeCFrame)
   end
})



MovementTab:CreateSlider({
   Name = "Speed",
   Range = {10, 50},
   Increment = 1,
   CurrentValue = 20,
   Callback = function(v)
      local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
      if hum then hum.WalkSpeed = v end
   end,
})


MovementTab:CreateToggle({
   Name = "NoClip",
   CurrentValue = false,
   Callback = function(v)
      _G.noclip = v
      game:GetService("RunService").Stepped:Connect(function()
         if _G.noclip and plr.Character then
            for _,p in pairs(plr.Character:GetDescendants()) do
               if p:IsA("BasePart") then p.CanCollide=false end
            end
         end
      end)
   end,
})


SBTab:CreateToggle({
   Name="AntiVoid Platform ",
   CurrentValue=false,
   Callback=function(v)
      if not v then
            local p = game.Workspace:FindFirstChild("plat")
            if p then
            p:Destroy()
            end
        else
        local plat = Instance.new("Part")
            plat.Position = Vector3.new(0,-15,0)
            plat.Size = Vector3.new(2048 ,0.7,2048 )
            plat.CanCollide = true
            plat.Anchored = true
            plat.Transparency = 0.5
            plat.Parent = game.Workspace
            plat.Name = "plat"
        end    
   end
})


SBTab:CreateButton({
   Name="Tp to Center of Map",
   Callback=function()
        tp()
   end
})


MiscTab:CreateButton({
   Name="Character",
   Callback=function()
      for i,v in pairs(plr.Character:GetChildren()) do
         print("Name: "..v.Name) 
         print(v.ClassName)
      end
      
   end
})
MiscTab:CreateButton({
   Name="HideName",  
   Callback=function()
      plr.Character.Head.Nametag.Labels.TopLabel.Text = "Tencell"
   end
})




SBTab:CreateToggle({
   Name="AutoFlick ",
   CurrentValue=false,
   Callback=function(v)
       autoFlick = not autoFlick
   end
})
SBTab:CreateToggle({ 
   Name="Skip Flick ",
   CurrentValue=false,
   Callback=function(v)
       skipFlick = v
   end
})



SBTab:CreateButton({ 
   Name="Collect all Slapple ",
   Callback=function()
      local skipped = 0
      for i,slapple in pairs(game.Workspace.Arena.island5.Slapples:GetChildren()) do
         local res = CollectSlapple(slapple)
         if not res then
         skipped += 1
         end
      end
      if skipped == 10 then
         Window:Notify({
         title = "Slap Collect debug",
         content = "No slapple on the server",
         duration = 5,
      })
      end
   end
})

SRTab:CreateToggle({
   Name="Item ESP",
   CurrentValue=false,
   Callback=function(a)
      ItemESP = a
      ItemESPFunc(ItemESP)
   end
})
SRTab:CreateToggle({
   Name="Players stats ",
   CurrentValue=false,
   Callback=function(v)
         SRStats = v
         if v then
            for i,v in pairs(Players:GetPlayers()) do 
               print(v.Name)
               createBillboard(v)
            end
         else
            for i,v in pairs(Players:GetPlayers()) do 
               for index,player in pairs(v:GetChildren()) do
                  if v.Character.Head:FindFirstChild("StatsGui") then
                     v.Character.Head:FindFirstChild("StatsGui"):Destroy()
                  else
                     break
                  end
               end 
            end
         end
   end
})

SRTab:CreateToggle({
   Name="Anti Ragdoll ",
   CurrentValue=false,
   Callback=function(v)
      antiRagdollEnabled = v
   end
})

SRTab:CreateButton({
   Name="Tp Code",
   Callback=function()
      game.Workspace.Map.CodeBrick.Position = plr.Character.HumanoidRootPart.Position
   end
})
SRTab:CreateButton({
   Name="Auto Code",
   Callback=function()
   Window:Notify({
   title ="Code",
   content=AutoCode(),
   duration = 5
})
   end
})
SRTab:CreateToggle({
   Name="Item Spawn Notify ",
   CurrentValue=false,
   Callback=function(v)
       notify = v
   end
})






SRTab:CreateToggle({
   Name="Auto Slap ",
   CurrentValue=false,
   Callback=function(v)
      if v then
         setupCharacter2()
      else
         if plr.Character:FindFirstChild("ItemDetector") then
         plr.Character.ItemDetector:Destroy()
         end
      end
   end
})


SRTab:CreateToggle({
   Name="Slap Aura ",
   CurrentValue=false,
   Callback=function(v)
        slapAura = v
   end
})

SRTab:CreateToggle({
   Name="Slap Aura Tp",
   CurrentValue=SlapTp,
   Callback=function(v)
      SlapTp = v
   end
})


SRTab:CreateSlider({
   Name = "Slap Aura Hitbox",
   Range = {10, 25},
   Increment = 1,
   CurrentValue = 15,
   Callback = function(v)
      if plr.Character:FindFirstChild("ItemDetector") then
         plr.Character.ItemDetector.Size = Vector3.new(v, 5, v)
      end
      SlapAuraHitbox = v
   end,
})




SRTab:CreateSlider({
   Name = "Speed Strengh",
   Range = {5, 50},
   Increment = 1,
   CurrentValue = SpeedStrengh,
   Callback = function(v)
      SpeedStrengh = v
   end,
})


SRTab:CreateToggle({
   Name="Speed hack ",
   CurrentValue=false,
   Callback=function(v)
       if v then
         local leg = plr.Character:FindFirstChild("Right Leg")
         local leg2 = plr.Character:FindFirstChild("Left Leg")
         leg.Position = leg2.Position + (leg2.CFrame.RightVector * SpeedStrengh)
         leg.CanCollide = false
         leg.CanTouch = false
         speedsUsed = true
       else
         local object1 = plr.Character:FindFirstChild("Right Leg")
         local object2 = plr.Character:FindFirstChild("Left Leg")
         object1.Position = object2.Position + (object2.CFrame.RightVector * 1)
         object1.CanCollide = true
         object1.CanTouch = true
         speedsUsed = false
      end
      speedsUsed = v
   end
})


SRTab:CreateToggle({
   Name="Tp Speeds ",
   CurrentValue=SRTp,
   Callback=function(v)
      SRTp = v
   end
})

SRTab:CreateSlider({
   Name = "Tp Strengh",
   Range = {3, 15},
   Increment = 1,
   CurrentValue = tpdist,
   Callback = function(v)
      tpdist = v
   end,
})
SRTab:CreateSlider({
   Name = "Tp Cooldown",
   Range = {0.5, 5},
   Increment = 0.5,
   CurrentValue = tpcd,
   Callback = function(v)
      tpcd = v
   end,
})



SRTab:CreateToggle({
   Name="Auto Heal ",
   CurrentValue=AutoHeal,
   Callback=function(v)
      AutoHeal = v
      if v then
         if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
         if plr.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then return end
            if plr.Character:FindFirstChildOfClass("Humanoid").Health <= hpHeal then
               useHealingItem()
            end
         end   
      end    
   end
})

SRTab:CreateSlider({
   Name = "Auto Heal Minimum",
   Range = {10, 50},
   Increment = 1,
   CurrentValue = hpHeal,
   Callback = function(v)
      hpHeal  = v
   end,
})


SRTab:CreateToggle({
   Name="Auto Perms",
   CurrentValue=AutoPerms,
   Callback=function(v)
      AutoPerms = v
      if v then
         for index, tool in pairs(plr.Backpack:GetChildren()) do
            local toolNow = plr.Character:FindFirstChildOfClass("Tool")
            for i,v in pairs(Permsitems) do
               if v == tool.Name then
                  humanoidForHeal:EquipTool(tool)
                  task.wait(0.1)
                  toolActivate()
               end
            end
            if toolNow then
               humanoidForHeal:EquipTool(plr.Backpack:FindFirstChild(toolNow.Name))
            end
            task.wait(0.2)
         end
         plr.Backpack.ChildAdded:Connect(onItemAdded)
      end    
   end
})



SRTab:CreateKeybind({
   Name = "Forcefield Crystal bind",
   value = nil,
   Hold = false,
   Callback = function()
      print("pressed a keybind")
      for i,v in pairs(plr.Backpack:GetChildren()) do
         if v.Name == "Forcefield Crystal" then
            local obj = plr.Character:FindFirstChildOfClass("Tool")
            humanoidForHeal:EquipTool(v)
            task.wait(0.1)
            toolActivate()
            task.wait(0.1)
            if plr.Backpack:FindFirstChild(obj.Name) then
               humanoidForHeal:EquipTool(plr.Backpack:FindFirstChild(obj.Name))
            end
            return
         end
      end
      Window:Notify({
               title = "Forcefield Crystal bind",
               content = "No Forcefield Crystal in your inventory",
               duration = 5,
            })
   end,
})


SRTab:CreateKeybind({
   Name = "Sphere of fury bind",
   value = nil,
   Hold = false,
   Callback = function()
      print("pressed a keybind")
      for i,v in pairs(plr.Backpack:GetChildren()) do
         if v.Name == "Sphere of fury" then
            local obj = plr.Character:FindFirstChildOfClass("Tool")
            humanoidForHeal:EquipTool(v)
            task.wait(0.1)
            toolActivate()
            task.wait(0.1)
            if plr.Backpack:FindFirstChild(obj.Name) then
               humanoidForHeal:EquipTool(plr.Backpack:FindFirstChild(obj.Name))
            end
            return
         end
      end
      Window:Notify({
               title = "Sphere of fury bind",
               content = "No Sphere of fury in your inventory",
               duration = 5,
            })
   end,
})


RivalsTab:CreateToggle({
   Name="Triger Bot",
   CurrentValue=false,
   Callback=function(a)
      triggerBot = a
   end
})
RivalsTab:CreateDropdown({
   Name="Select Player",
   Options=getPlayers(),
   Callback=function(opt)
      local name = typeof(opt)=="table" and opt[1] or opt
      AimtargetPlayer = name
   end
})
RivalsTab:CreateToggle({
   Name="Aim Assist",
   CurrentValue=false,
   Callback=function(a)
      aimAssist = a
      plr.Character:FindFirstChildOfClass("Humanoid").AutoRotate = a
   end
})

RivalsTab:CreateSlider({
   Name = "AIM ASSIST FOV",
   Range = {25, 180},
   Increment = 1,
   CurrentValue = AIM_ASSIST_FOV ,
   Callback = function(v)
      AIM_ASSIST_FOV = v
   end,
})

RivalsTab:CreateSlider({
   Name = "AIM ASSIST STRENGH",
   Range = {0.5, 1},
   Increment = 0.1,
   CurrentValue = SMOOTHNESS ,
   Callback = function(v)
      SMOOTHNESS = v
   end,
})

RivalsTab:CreateToggle({
   Name="Only heads",
   CurrentValue=false,
   Callback=function(a)
      onlyHeads = a
   end
})



--Функции


function setupCharacter2()
local hrp = plr.Character:WaitForChild("HumanoidRootPart")
local detector = Instance.new("Part")
detector.Name = "ItemDetector"
detector.Size = Vector3.new(11, 5, 11)
detector.Transparency = 0.7
detector.CanCollide = false
detector.Anchored = false
detector.Massless = true
detector.Parent = plr.Character
detector.CFrame = hrp.CFrame
local weld = Instance.new("Weld")
weld.Part0 = detector
weld.Part1 = hrp
weld.Parent = detector
   detector.Touched:Connect(function(hit)
       slap(hit)
   end)
end

function antiRagdoll()
    if not plr.Character then return end
    local character = plr.Character
    for i, part in ipairs(character:GetChildren()) do
        if part.Name:find("FakePart") then
            part:Destroy()
        end
    end
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.PlatformStand = false
        humanoid.Sit = false
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
    
    for index, obj in ipairs(character:GetDescendants()) do
        if obj:IsA("BallSocketConstraint") or obj:IsA("NoCollisionConstraint") then
            if obj.Parent and obj.Parent.Name:find("Fake") then
                obj:Destroy()
            end
        end
    end
end   

RunService.Heartbeat:Connect(function()
    if not antiRagdollEnabled then return end
    antiRagdoll()
end)






RunService.Heartbeat:Connect(function()
    if not slapAura then return end

    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
    if not toolChecker() then return end
    if youInRagdoll then return end

    local myRoot = plr.Character.HumanoidRootPart
    local myPos = myRoot.Position

    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer == plr then continue end
        local isFriend = table.find(friends, otherPlayer.Name)
        if ignorePlayers[otherPlayer.Character] or isFriend then continue end

        local char = otherPlayer.Character
        if not char then continue end
        local part,dist = getClosestPart(char)
        if not part then return end
        if dist <= SlapAuraHitbox then
            kilka(part)
        end
    end
end)

function tpKilka(myRoot,targetRoot)
task.spawn(function()
	local originalCFrame = myRoot.CFrame
	local targetPosition = targetRoot.Position - (targetRoot.CFrame.LookVector * 3)
	local teleportCFrame = CFrame.lookAt(targetPosition, targetRoot.Position)
	myRoot.CFrame = teleportCFrame
end)
end

function kilka(hit)
    if not toolChecker() then return end
    local targetChar = hit.Parent
    if not targetChar then return end
    if not targetChar:FindFirstChildOfClass("Humanoid") or targetChar.Name == "Crate" then return end
    if targetChar:FindFirstChildOfClass("ForceField") then return end
    if ignorePlayers[targetChar] or youInRagdoll then return end
    if plr.Character:FindFirstChild("FakePart Right Arm") then youInragdoll() return end
    if targetChar:FindFirstChild("FakePart Right Arm") then addToIgnore(targetChar) return end
    if targetCD then return end
    local myRoot = plr.Character:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not myRoot or not targetRoot then return end
    if raycast(myRoot,hit) then return end
    targetCD = true
    local tool = plr.Character:FindFirstChildOfClass("Tool")
    if not tool then targetCD = false return end
    local glove = tool:FindFirstChild("Glove")
    if not glove then targetCD = false return end
    glove.Position = hit.Position
    local distance = (targetRoot.Position - myRoot.Position).Magnitude
	 if SlapTp and distance > 15 then
	 tpKilka(myRoot,targetRoot)
	 end
    task.wait(0.1)
    mouse1press()
    plr.Character.Humanoid.AutoRotate = false
     myRoot.CFrame = CFrame.new(myRoot.Position, Vector3.new(targetRoot.Position.X, myRoot.Position.Y, targetRoot.Position.Z))
    for i = 1,25 do
      glove.Position = hit.Position
      if targetChar:FindFirstChild("FakePart Right Arm") or (targetRoot.Position - myRoot.Position).Magnitude > 20 then break end
      task.wait(0.02)
    end
    glove.Position = tool.Handle.Position + (tool.Handle.CFrame.UpVector * 2)
    task.wait(0.10)
    if targetChar:FindFirstChild("FakePart Right Arm") then
      addToIgnore(targetChar)
    end    
   plr.Character.Humanoid.AutoRotate = true
    task.wait(0.50)
    targetCD = false
end

function getClosestPart(parent)
   local playerCharacter = plr.Character
	local rootPart = playerCharacter:FindFirstChild("HumanoidRootPart")
	if not rootPart then return nil end
	
	local characterPosition = rootPart.Position
	local closestPart = nil
	local shortestDistance = math.huge 

	for _, child in ipairs(parent:GetChildren()) do
		if child:IsA("BasePart") then
			local distance = (child.Position - characterPosition).Magnitude
			if distance < shortestDistance then
				shortestDistance = distance
				closestPart = child
			end
		end
	end
	return closestPart, shortestDistance
end

function slap(hit)
if not hit.Parent:FindFirstChildOfClass("Humanoid") or hit.Parent.Name == "Crate" or hit.ClassName == "Tool" then return end
         if not toolChecker() then return end
         if ignorePlayers[hit.Parent] or youInRagdoll then return end
         if plr.Character:FindFirstChild("FakePart Right Arm") then youInragdoll() return end
         if hit.Parent:FindFirstChild("FakePart Right Arm")  then addToIgnore(hit.Parent) return end
         if targetCD == true then return end
         local isFound = table.find(friends, hit.Parent.Name)
         if isFound then return end
         mouse1click()
         print(hit.ClassName)
         if not skipFlick then
         task.wait(0.1)
         end
         local root = plr.Character:FindFirstChild("HumanoidRootPart")
         print("расстояние рутов" .. tostring(hit.Position.Y - root.Position.Y))
         if  (hit.Position.Y - root.Position.Y) < -1 then return end
         if (hit.Position.Y - root.Position.Y) > 2 then 
            HitLater()
         end
         plr.Character.Humanoid.AutoRotate = false
         local targetRoot = hit.Parent:FindFirstChild("Head")
         if not root or not targetRoot then
         plr.Character.Humanoid.AutoRotate = true
         return 
          end
         root.CFrame = CFrame.new(root.Position, Vector3.new(targetRoot.Position.X, root.Position.Y, targetRoot.Position.Z))
         targetCD = true
         task.wait(0.2)
         plr.Character.Humanoid.AutoRotate = true
         task.wait(0.7)
         targetCD = false
         
end

function HitLater(obj)
   while (obj.Position.Y - root.Position.Y) > 2 do
      if (obj.Position.Y - root.Position.Y) > 5 then return end
      task.wait(0.01)
   end       
   slap(obj)
end

function toolChecker()
local tool = plr.Character:FindFirstChildOfClass("Tool")
if not tool or tool.Name == "Glider" then return end
return true
end

function youInragdoll()
   youInRagdoll = true
   local leg = plr.Character:FindFirstChild("Right Leg")
   local leg2 = plr.Character:FindFirstChild("Left Leg")
    if speedsUsed  then
      leg.Position = leg2.Position + (leg2.CFrame.RightVector * 1)
   end
   while plr.Character:FindFirstChild("FakePart Right Arm") do
   if plr.Character.Humanoid.Health <= 0 then break end
   task.wait()
   end 
   if speedsUsed then
      leg.Position = leg2.Position + (leg2.CFrame.RightVector * SpeedStrengh)
   end
   youInRagdoll = false
end


function addToIgnore(player)
   task.spawn(function()
      ignorePlayers[player] = true
      
      if player:FindFirstChild("Highlight") then
           player.Highlight.FillColor = Color3.fromRGB(36, 26, 235)
      end
      
      while player:FindFirstChild("FakePart Right Arm") do
          if player.Humanoid.Health <= 0 then
              break
          end
          task.wait(0.01)
      end
      
      task.wait(0.2)
      ignorePlayers[player] = nil
      
      if player:FindFirstChild("Highlight") then
         player.Highlight.FillColor = Color3.fromRGB(255, 0, 0)
      end
   end)
end

function toolActivate()
local tool = plr.Character:FindFirstChildOfClass("Tool")
   if tool  then
      if tool.Name == "Glider" then return end
      tool:Activate()
      return true
   end
end

function ItemESPFunc(v)
   for i, object in pairs(game.Workspace.Items:GetChildren()) do
   if v then
      local color = items[object.Name]
      if not object:FindFirstChild("Highlight") then
         if not color then
            color = Color3.fromRGB(168, 12, 12) 
         end
         local highlight = Instance.new("Highlight")
         highlight.OutlineColor = color
         highlight.FillColor = color
         highlight.FillTransparency = 0
         highlight.Parent = object
         if not object:FindFirstChild("ItemESP") then
         local billboard = Instance.new("BillboardGui")
         billboard.Name = "ItemESP"
         billboard.Parent = object
         billboard.Size = UDim2.new(0, 200, 0, 50)
         billboard.StudsOffset = Vector3.new(0, 2, 0)
         billboard.AlwaysOnTop = true
         local label = Instance.new("TextLabel")
         label.Parent = billboard
         label.Size = UDim2.new(1, 0, 1, 0)
         label.BackgroundTransparency = 1
         label.Text = object.Name
         label.TextColor3 = color
         label.TextStrokeTransparency = 0
         label.TextScaled = false
         label.TextSize = 18
         label.Font = Enum.Font.SourceSansBold
         end
      end  
   else
       if object:FindFirstChild("Highlight") then
         object.Highlight:Destroy()
       end
      if object:FindFirstChild("ItemESP") then 
         object.ItemESP:Destroy()
      end
   end   
   task.wait(0.05)  
   end
end



function append(str, suffix)
   if not suffix then
   return str .. "?"
   end
   return str .. suffix
end


function AutoCode()
res = ""
for i,v in pairs(game.Workspace.Map.CodeBrick.SurfaceGui:GetChildren()) do
   if v.ClassName == "ImageLabel" then
      print(codes[v.Image])
      res = append(res, codes[v.Image])
   end
end
print(res)
return res
end

function onInputBegan(input, gameProcessed)  
  if gameProcessed then return end 
       if input.KeyCode == Enum.KeyCode.Q then
          mouseTarget()
          Childrenoftarget(Mouse.Target)
      end  
      if input.KeyCode == Enum.KeyCode.W then
      TpSpeed= true
      end
      if input.KeyCode == Enum.KeyCode.D then
      pressedD = true
      end
       if input.KeyCode == Enum.KeyCode.A then
      pressedA = true
      end
end

function onInputEnded(input, gameProcessedEvent)
 if input.KeyCode == Enum.KeyCode.W then
  TpSpeed = false
 end
  if input.KeyCode == Enum.KeyCode.D then
  pressedD = false
 end
 if input.KeyCode == Enum.KeyCode.A then
  pressedA = false
 end
end


function platformChangeStatus()
 platform = not platform
        if platform == false then
            local p = game.Workspace:FindFirstChild("plat")
            if p then
            p:Destroy()
            end
        else
        local plat = Instance.new("Part")
            plat.Position = Vector3.new(0,-15,0)
            plat.Size = Vector3.new(20000,0.5,20000)
            plat.CanCollide = true
            plat.Anchored = true
            plat.Transparency = 0.5
            plat.Parent = game.Workspace
            plat.Name = "plat"
        end    
end   


function tp()
    plr.Character.HumanoidRootPart.CFrame = CFrame.new(0,0,2.2)
end

function mouseTarget()
local target = Mouse.Target

  if target then
    print("Объект: " .. target.Name)
       print("Полное имя: " .. target:GetFullName())
       print("тип: " .. target.ClassName)
  else
  end
end  




function smartHumanizedTurn(target)
    local targetHRP = target:FindFirstChild("HumanoidRootPart")
    local HRP = plr.Character:FindFirstChild("HumanoidRootPart")
    if not HRP or not targetHRP  then return end
    local startPos = HRP.Position
    local targetCFrame = CFrame.lookAt(HRP.Position, Vector3.new(targetHRP.Position.X, HRP.Position.Y, targetHRP.Position.Z))
    local alpha = 0
    local time = 0
    local targetAlpha = math.random(90, 100)/ 100

    targetCD = true
    plr.Character.Humanoid.AutoRotate = false
    while alpha < targetAlpha do
      if target:FindFirstChild("FakePart Right Arm")  then addToIgnore(target) break end
      if youInRagdoll then break end
      if ignorePlayers[target] then break end
        local targetHRP = target:FindFirstChild("HumanoidRootPart")
        local targetCFrame = CFrame.lookAt(HRP.Position, Vector3.new(targetHRP.Position.X, HRP.Position.Y, targetHRP.Position.Z))

        local step = 0 
        step = math.random(10, 40) / 100
       
        local multiple = math.random(100000,150000)
        local microNoise = math.random(100, 10000)/ multiple
        alpha = alpha + step + microNoise
        time += 1
        print(alpha)
        if alpha >= targetAlpha then
            break
        end
        HRP.CFrame = HRP.CFrame:Lerp(targetCFrame, alpha)
        task.wait(0.05)
    end
    print(time)
    plr.Character.Humanoid.AutoRotate = true
    task.wait(1 - 0.02* time)
    targetCD = false
end




function getNearestHumanoidRootPart()
    local myRoot = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    local nearestPlayer = nil
    local shortestDistance = math.huge 
    for _, player in ipairs(Players:GetPlayers()) do
        if player == plr then continue end 
        local enemyChar = player.Character 
        local enemyRoot = enemyChar and enemyChar:FindFirstChild("HumanoidRootPart")
        local enemyHumanoid = enemyChar and enemyChar:FindFirstChildOfClass("Humanoid")
        
        if enemyRoot and enemyHumanoid and enemyHumanoid.Health > 0 then
            if raycast(myRoot, enemyRoot) then continue end
            local distance = (myRoot.Position - enemyRoot.Position).Magnitude
            if distance < shortestDistance and distance < 25 then
                shortestDistance = distance
                nearestPlayer = player    
            end
        end
    end
    if nearestPlayer then
    return nearestPlayer,  nearestPlayer.Character
    else
      return nearestPlayer
     end 
end


Mouse.Button1Down:Connect(function()
if targetCD == true or autoFlick == false then return end
local closest,Enemychar = getNearestHumanoidRootPart()
if not closest or not Enemychar then return end
if ignorePlayers[Enemychar] or youInRagdoll then return end
if plr.Character:FindFirstChild("FakePart Right Arm") then youInragdoll() return end
if closest.Character:FindFirstChild("FakePart Right Arm")  then addToIgnore(Enemychar) return end
smartHumanizedTurn(Enemychar)
end)


-- function getNearestPlayer(maxRadius)
--     local character = plr.Character
--     if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
--     local root = character.HumanoidRootPart
--     local closest = nil
--    for _, other in pairs(Players:GetChildren()) do
--       if table.find(friends,other.Name) then continue end 
--       if other ~= plr  and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
--          local dist = (other.Character.HumanoidRootPart.Position - root.Position).Magnitude
--          if dist > maxRadius then
--             continue
--          end
--          closest = other
--       end
--    end
-- if closest then
-- return closest.Character
-- end
-- end



input.InputBegan:Connect(onInputBegan)
input.InputEnded:Connect(onInputEnded)


function inArena()
   if not plr.Character:FindFirstChild("isInArena").Value and not plr.Backpack:FindFirstChildOfClass("Tool") then
      plr.Character:PivotTo(CFrame.new(-1210,330,4))
      task.wait(1)
       if not plr.Character:FindFirstChild("isInArena").Value and not plr.Backpack:FindFirstChildOfClass("Tool") then 
            inArena()
       end
   end
end

function CollectSlapple(obj)
      inArena()
      if obj:FindFirstChildOfClass("MeshPart").Transparency == 1 then return false end
      plr.Character:PivotTo(obj:FindFirstChildOfClass("MeshPart").CFrame)
      plr.Character.HumanoidRootPart.Anchored = true
      task.wait(0.2)
      plr.Character.HumanoidRootPart.Anchored = false
      task.wait(0.5)
      if obj:FindFirstChildOfClass("MeshPart").Transparency == 0 then
         CollectSlapple(obj)
         return "не удача"
      end
      return true
end
function espUpd()
   while task.wait(EspUpdCd) do
      if esp then
         for _,v in pairs(Players:GetPlayers()) do
            if v~=plr and v.Character then
               if not v.Character:FindFirstChild("Highlight") then
                  Instance.new("Highlight",v.Character)
                  isFriend = table.find(friends,v.Name)
                  if isFriend then
                  v.Character.Highlight.FillColor = FriendEspColor
                  end
               end
            end   
         end   
      end
   end   
end   



function Childrenoftarget(v) 
for i,a in pairs(v:GetChildren()) do
print("children name: ".. a.Name)
print("Children Full name: ".. a:GetFullName())
print("Children Class: ".. a.ClassName)
end
end




local function getTargetRoot()
    if not AimtargetPlayer or AimtargetPlayer == "" then return nil end
    
    local targetPlayer = Players:FindFirstChild(AimtargetPlayer)
    if not targetPlayer then return nil end
    
    local character = targetPlayer.Character
    if not character then return nil end
    local humanoid = character:FindFirstChild("Humanoid")
    local root = nil
    if onlyHeads then
    root = character:FindFirstChild("Head")
    else
    root = character:FindFirstChild("HumanoidRootPart")
    end 
    if humanoid and humanoid.Health > 0 and root then
        return root
    end
 
    return nil
end

RunService.RenderStepped:Connect(function()
   if aimAssist then
        local targetRoot = getTargetRoot()
      if targetRoot and plr.Character then
         local char = plr.Character
         local head = char:FindFirstChild("Head")
         local humanoid = char:FindFirstChild("Humanoid")
         local currentCFrame = camera.CFrame
         local targetCFrame = CFrame.lookAt(currentCFrame.Position, targetRoot.Position)
         camera.CFrame = currentCFrame:Lerp(targetCFrame, SMOOTHNESS)

         if head and head:FindFirstChild("Neck") then
            local neck = head.Neck
            local headPos = head.Position
            local lookDirection = (targetRoot.Position - headPos).Unit
                
            local targetHeadCFrame = CFrame.lookAt(headPos, headPos + lookDirection)
            neck.C0 = neck.C0:Lerp(
                  CFrame.new(neck.C0.Position) * targetHeadCFrame.Rotation, 
                  1.6
            )
         end
      end         
   end  
if not triggerBot then return end
local target = Mouse.Target
if not target then return end
local isFriend = table.find(friends,target.Parent.Name)
if isFriend then return end    
if onlyHeads then
   if target.Name == "Head" or target.Name == "HitboxHead" then
      mouse1click()
      return
	end
else
   if target.Parent:FindFirstChild("HumanoidRootPart") then
      mouse1click()
      return
   end
end
end)

function updateStats(player)
    local char = player.Character
    if not char then return end
    if not char:FindFirstChild("Head") then return end
    local labels = char.Head:FindFirstChild("StatsGui")
    if not labels then createBillboard(player) return end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    local speed = humanoid.WalkSpeed or "?"
    local power = char:GetAttribute("Power") or "?"
    local jump =  humanoid.JumpPower or "?"
    labels.SpeedLabel.Text = "Speed: " .. tostring(speed)
    labels.PowerLabel.Text = "Power: " .. tostring(power)
    labels.JumpLabel.Text  = "Jump: " .. tostring(jump)
end








function createBillboard(player)
    local head = player.Character and player.Character:FindFirstChild("Head")
    if not head then return end

    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "StatsGui"
    Billboard.Adornee = head
    Billboard.AlwaysOnTop = true
    Billboard.Size = UDim2.new(15, 0, 10, 0) 
    Billboard.StudsOffset = Vector3.new(0, 6.5, 0)
    Billboard.MaxDistance = 500                   
    Billboard.LightInfluence = 0
    Billboard.Parent = head

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Name = "NameLabel"
    NameLabel.Size = UDim2.new(1, 0, 0.25, 0)
    NameLabel.Position = UDim2.new(0, 0, 0, 0)
    NameLabel.BackgroundTransparency = 1
    if player == plr then
    NameLabel.Text = "Undetected"
    else
    NameLabel.Text = player.Name
    end
    NameLabel.TextColor3 = Color3.new(1,1,1)
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextStrokeTransparency = 0.3
    NameLabel.TextStrokeColor3 = Color3.new(0,0,0)
    NameLabel.TextScaled = true
    NameLabel.Parent = Billboard


    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Name = "SpeedLabel"
    SpeedLabel.Size = UDim2.new(1, 0, 0.25, 0)
    SpeedLabel.Position = UDim2.new(0, 0, 0.25, 0)
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.TextColor3 = Colors.Speed
    SpeedLabel.Font = Enum.Font.GothamSemibold
    SpeedLabel.TextStrokeTransparency = 0.4
    SpeedLabel.TextStrokeColor3 = Color3.new(0,0,0)
    SpeedLabel.TextScaled = true 
    SpeedLabel.Parent = Billboard


    local PowerLabel = Instance.new("TextLabel")
    PowerLabel.Name = "PowerLabel"
    PowerLabel.Size = UDim2.new(1, 0, 0.25, 0)
    PowerLabel.Position = UDim2.new(0, 0, 0.50, 0)
    PowerLabel.BackgroundTransparency = 1
    PowerLabel.TextColor3 = Colors.Power
    PowerLabel.Font = Enum.Font.GothamSemibold
    PowerLabel.TextStrokeTransparency = 0.4
    PowerLabel.TextStrokeColor3 = Color3.new(0,0,0)
    PowerLabel.TextScaled = true 
    PowerLabel.Parent = Billboard


    local JumpLabel = Instance.new("TextLabel")
    JumpLabel.Name = "JumpLabel"
    JumpLabel.Size = UDim2.new(1, 0, 0.25, 0)
    JumpLabel.Position = UDim2.new(0, 0, 0.75, 0)
    JumpLabel.BackgroundTransparency = 1
    JumpLabel.TextColor3 = Colors.Jump
    JumpLabel.Font = Enum.Font.GothamSemibold
    JumpLabel.TextStrokeTransparency = 0.4
    JumpLabel.TextStrokeColor3 = Color3.new(0,0,0)
    JumpLabel.TextScaled = true 
    JumpLabel.Parent = Billboard

    updateStats(player)
end

function getBestHealItem()
   for i,v in pairs(healItems) do
      for index, tool in pairs(plr.Backpack:GetChildren()) do
         if v == tool.Name then
            print("Найден ", v)
            return tool
         end
      end
      print(v," Не найден в инвентаре")
   end
   print("Не найденно хила")
end












function tpSpeed()
task.spawn(function()
   while task.wait(tpcd) do
      hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
      
      for i=1,3 do
         if not TpSpeed or not hrp or not SRTp then break end
         
         local lookVector = hrp.CFrame.LookVector
         local rayDirection = lookVector * tpdist
         
         local raycastParams = RaycastParams.new()
         raycastParams.FilterType = Enum.RaycastFilterType.Exclude
         raycastParams.FilterDescendantsInstances = {plr.Character} -- Игнорируем своего персонажа
         
         local raycastResult = workspace:Raycast(hrp.Position, rayDirection, raycastParams)
         
         if raycastResult then
            local hitPosition = raycastResult.Position
            local safePosition = hitPosition - (lookVector * 2) 
            
            hrp.CFrame = CFrame.new(safePosition) * (hrp.CFrame - hrp.CFrame.Position)
         else
            hrp.CFrame = hrp.CFrame + rayDirection
         end
         
         task.wait(1)
      end
   end
end)
end

  

function onItemAdded(item)
   if not AutoPerms then return end
   task.wait(0.2)
   local tool = plr.Character:FindFirstChildOfClass("Tool")
   if table.find(Permsitems, item.Name) then
      humanoidForHeal:EquipTool(item)
      task.wait(0.1)
      toolActivate()
      task.wait(0.1)
      if tool  and plr.Backpack:FindFirstChild(tool.Name) then
         humanoidForHeal:EquipTool(plr.Backpack:FindFirstChild(tool.Name))
      end
   end
end

function getPlayersWithoutFriends()
   local t={}
   for _,v in pairs(Players:GetPlayers()) do
      if v~= plr and not table.find(friends,v.Name) then table.insert(t,v.Name) end
   end
   table.sort(t)
   return t
end


local playersToFriends = FriendsTab:CreateDropdown({
   Name="Select Player to add",
   Options=getPlayersWithoutFriends(),
   Callback=function(opt)
      local name = typeof(opt)=="table" and opt[1] or opt
      FriendAdd = name
   end
})

FriendsTab:CreateButton({
   Name="Add Friend",
   Callback=function()
      if FriendAdd then
         if table.find(friends,FriendAdd) then
            FriendAdd = nil
            return
         end
         table.insert(friends,FriendAdd)
            if Players:FindFirstChild(FriendAdd).Character and Players:FindFirstChild(FriendAdd).Character:FindFirstChild("Highlight") then
            Players:FindFirstChild(FriendAdd).Character.Highlight.FillColor = FriendEspColor
            end
         RefreshFriends() 
         FriendAdd = nil
         playersToFriends:Refresh(getPlayersWithoutFriends())
      end
   end   
})

local FriendsDropdown = FriendsTab:CreateDropdown({
   Name="Select Friend",
   Options=friends,
   Callback=function(opt)
      local name = typeof(opt)=="table" and opt[1] or opt
      FriendRem = name
   end
})




FriendsTab:CreateButton({
   Name="Remove Friend",
   Callback=function()
         if FriendRem then
         local index = table.find(friends,FriendRem)
         if index then
	      table.remove(friends, index)
         end
            if Players:FindFirstChild(FriendRem).Character and Players:FindFirstChild(FriendRem).Character:FindFirstChild("Highlight") then
               Players:FindFirstChild(FriendRem).Character:FindFirstChild("Highlight").FillColor = Color3.fromRGB(255,0,0)
            end
         FriendsDropdown:Refresh(friends)   
         FriendRem = nil
         playersToFriends:Refresh(getPlayersWithoutFriends())
         end
   end
})


local ColorPicker = FriendsTab:CreateColorPicker({
   Name = "Set Friend Esp Color",
   Color = FriendEspColor,
   Callback = function(Value)
      FriendEspColor = Value
   end
})


FriendsTab:CreateButton({
   Name="Set color",
   Callback=function()
      if not FriendRem or not  Players:FindFirstChild(FriendRem).Character:FindFirstChild("Highlight") then
      return
      end
      Players:FindFirstChild(FriendRem).Character:FindFirstChild("Highlight").FillColor = FriendEspColor
   end
})


function RefreshFriends()
   FriendsDropdown:Refresh(friends)
end

function useHealingItem()
   local healItem = getBestHealItem()
   if not healItem then return end
   if not humanoidForHeal then return end
   humanoidForHeal:EquipTool(healItem)
   toolActivate()
   task.wait(0.5)
   if humanoidForHeal.Health <= hpHeal then
   useHealingItem()
   else
      for index, tool in pairs(plr.Backpack:GetChildren()) do
         if tool:FindFirstChild("Glove") then
            humanoidForHeal:EquipTool(tool)
            return
         end
      end
   end
end





function updStat()
while true do
   if SRStats then
      for i,v in pairs(Players:GetChildren()) do
         updateStats(v)
         task.wait()
      end
   end
   task.wait(1)  
end
end

function raycast(part1,part2)
local origin = part1.Position
local direction = part2.Position - origin
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
raycastParams.FilterDescendantsInstances = {plr.Character}
local result = Workspace:Raycast(origin, direction, raycastParams)
local Enemychar = part2.Parent
if result then
   for i,v in pairs(Enemychar:GetDescendants()) do
      if v == result.Instance then return false end
   end
   return true
else
   return false
end
end


delay(5,function()
   task.spawn(function()
      while task.wait(0.1) do
         if bhop then
            local leg = plr.Character:FindFirstChild("Right Leg")
            local leg2 = plr.Character:FindFirstChild("Left Leg")
            leg.CanTouch = false
            if pressedA and pressedD then
               leg.Position = leg2.Position + (leg2.CFrame.RightVector * 1)
            elseif pressedD then
               leg.Position = leg2.Position + (leg2.CFrame.RightVector * SpeedStrengh)
            elseif pressedA then 
               leg.Position = leg2.Position - (leg2.CFrame.RightVector * SpeedStrengh)
            else
               leg.Position = leg2.Position + (leg2.CFrame.RightVector * 1)
            end
         end
      end   
   end)
end)
delay(5,espUpd)
delay(5,updStat)
delay(5,tpSpeed)
print("готов к работе")
