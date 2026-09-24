local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")


function howManySlappleActive()
    local n = 0
    for i,slapple in pairs(game.Workspace.Arena.island5.Slapples:GetChildren()) do
      if slapple:FindFirstChildOfClass("MeshPart").Transparency == 1 then continue end
      n += 1
    end
    return n
end

function inArena()
   if not plr.Character then
      task.wait(1)
      inArena()
      return
   end
   if not plr.Character:FindFirstChild("isInArena") or plr.Character.Humanoid.Health == 0 then
      task.wait(1)
      inArena()
      return
   end
   if not plr.Character:FindFirstChild("isInArena").Value and not plr.Backpack:FindFirstChildOfClass("Tool") then
      plr.Character:PivotTo(CFrame.new(-1310,330,4))
      task.wait(1)
       if not plr.Character:FindFirstChild("isInArena").Value and not plr.Backpack:FindFirstChildOfClass("Tool") then 
            inArena()
       end
   end
end
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local isTeleporting = false 

TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
    if player == LocalPlayer then
        print("Ошибка телепортации: " .. tostring(teleportResult) .. " (" .. errorMessage .. ")")
        task.wait(10) 
        isTeleporting = false 
    end
end)

function Serverhop()
    task.spawn(function()
        while true do
            task.wait(3)
            if not isTeleporting then
                local servers = {}
                local successReq, req = pcall(function()
                    return game:HttpGet("https://games.roblox.com/v1/games/"..tostring(6403373529).."/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true")
                end)
                
                if successReq then
                    local body = HttpService:JSONDecode(req)
                    if body and body.data then
                        for i, v in next, body.data do
                            if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers-1 and v.id ~= game.JobId then
                                table.insert(servers, 1, v.id)
                            end
                        end
                    end
                else
                    print("Не удалось отправить HTTP-запрос к API серверов")
                end
                
                if #servers > 0 then
                    local id = servers[math.random(1, #servers)]
                    print("Попытка телепортации на сервер: " .. tostring(id))
                    
                    isTeleporting = true 
                    local success, response = pcall(function()
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, id, LocalPlayer)
                    end)
                    
                    if not success then
                        print("Ошибка вызова метода TeleportToPlaceInstance: " .. tostring(response))
                        task.wait(10)
                        isTeleporting = false
                    end
                else
                    print("Подходящие сервера не найдены, пробуем обычный Teleport")
                    isTeleporting = true
                    local success, response = pcall(function()
                        TeleportService:Teleport(game.PlaceId, LocalPlayer)
                    end)
                    
                    if not success then
                        print("Ошибка вызова метода Teleport: " .. tostring(response))
                        task.wait(10)
                        isTeleporting = false
                    end
                end
            end
        end
    end)
end


function CollectSlapple(obj)
      inArena()
      if obj:FindFirstChildOfClass("MeshPart").Transparency == 1 then return end
      plr.Character:PivotTo(obj:FindFirstChildOfClass("MeshPart").CFrame)
      plr.Character.HumanoidRootPart.Anchored = true
      task.wait(0.2)
      plr.Character.HumanoidRootPart.Anchored = false
      task.wait(0.5)
      if obj:FindFirstChildOfClass("MeshPart").Transparency ~= 0 then
         CollectSlapple(obj)
      end
end
function sborslapov()
    plr = Players.LocalPlayer
    if not plr or not plr.Character then
        task.wait(1)
        sborslapov()
    end    
    local Arena = game.Workspace:WaitForChild("Arena")
    if howManySlappleActive() == 0 then
        Serverhop()
        return
    end 
    plr.Character:WaitForChild("HumanoidRootPart").Anchored = false
   for i,slapple in pairs(Arena.island5.Slapples:GetChildren()) do
     CollectSlapple(slapple)
   end
   task.wait(4)
   Serverhop()
end

sborslapov()
