local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local plr = Players.LocalPlayer
local isTeleporting = false 


function howManySlappleActive()
    local n = 0
    local slapplesFolder = Workspace:FindFirstChild("Arena") and Workspace.Arena:FindFirstChild("island5") and Workspace.Arena.island5:FindFirstChild("Slapples")
    if not slapplesFolder then return 0 end
    
    for _, slapple in pairs(slapplesFolder:GetChildren()) do
        local mesh = slapple:FindFirstChildOfClass("MeshPart")
        if mesh and mesh.Transparency ~= 1 then 
            n += 1
        end
    end
    return n
end


function inArena()
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
        task.wait(1)
        return inArena()
    end
    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
    if not plr.Character:FindFirstChild("isInArena") or (humanoid and humanoid.Health == 0) then
        task.wait(1)
        return inArena()
    end
    if not plr.Character:FindFirstChild("isInArena").Value and not plr.Backpack:FindFirstChildOfClass("Tool") then
        plr.Character:PivotTo(CFrame.new(-1310, 330, 4))
        task.wait(1)
        if not plr.Character:FindFirstChild("isInArena").Value and not plr.Backpack:FindFirstChildOfClass("Tool") then 
            return inArena()
        end
    end
end


TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
    if player == plr then
        print("Ошибка телепортации: " .. tostring(teleportResult) .. " (" .. errorMessage .. ")")
        task.wait(5) 
        isTeleporting = false 
        Serverhop()
    end
end)


function Serverhop()
    if isTeleporting then return end 
    isTeleporting = true
    
    print("Ищем новый сервер...")
    local servers = {}
    local successReq, req = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/"..tostring(6403373529).."/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true")
    end)
        
    if successReq then
        local body = HttpService:JSONDecode(req)
        if body and body.data then
            for _, v in next, body.data do
                if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers-1 and v.id ~= game.JobId then
                    table.insert(servers, v.id)
                end
            end
        end
    else
        print("Не удалось получить список сервеers через API")
    end    

    if #servers > 0 then
        local id = servers[math.random(1, #servers)]
        print("Попытка телепортации на сервер: " .. tostring(id))
        
        local success, response = pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, id, plr)
        end)
            
        if not success then
            print("Ошибка метода TeleportToPlaceInstance: " .. tostring(response))
            task.wait(5)
            isTeleporting = false
            Serverhop()
        end
    else
        print("Подходящие сервера не найдены, используем обычный Teleport")
        local success, response = pcall(function()
            TeleportService:Teleport(game.PlaceId, plr)
        end)
        if not success then
            print("Ошибка метода Teleport: " .. tostring(response))
            task.wait(5)
            isTeleporting = false
            Serverhop()
        end
    end
end


function CollectSlapple(obj)
    inArena()
    local mesh = obj:FindFirstChildOfClass("MeshPart")
    if not mesh or mesh.Transparency == 1 then return end
    
    plr.Character:PivotTo(mesh.CFrame)
    if plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.Anchored = true
        task.wait(0.3)
        plr.Character.HumanoidRootPart.Anchored = false
    end
    task.wait(0.2)
    if mesh.Transparency ~= 1 then
        CollectSlapple(obj)
    end
end


function sborslapov()
    print("вызвана функция")
    plr = Players.LocalPlayer
    if not plr or not plr.Character then
        task.wait(1)
        sborslapov()
        return
    end    
    
    local Arena = Workspace:WaitForChild("Arena")
    
    if howManySlappleActive() == 0 then
        print("Активных Slapple нет")
        Serverhop()
        return 
    end 
    
    if plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.Anchored = false
    end
    
    for _, slapple in pairs(Arena.island5.Slapples:GetChildren()) do
        CollectSlapple(slapple)
    end
    
    task.wait(1)
    print("Все Slapple собраны. Меняем сервер...")
    Serverhop()
end

sborslapov()
