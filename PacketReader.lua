local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local safeLogTemplate = {
    ["MessageInfo"] = {
        [1] = "GrabLocal active"
    },
    ["MessageError"] = {},
    ["MessageWarning"] = {},
    ["MessageOutput"] = {
        [1] = "[TomahawkVFX]: Client listener initialized",
        [2] = "[SecondTracker] initialized"
    }
}

local function formatTable(tbl, depth)
    depth = depth or 0
    if depth > 3 then return "{...}" end
    local result = {}
    for k, v in pairs(tbl) do
        local key = type(k) == "string" and string.format("[%q]", k) or string.format("[%s]", tostring(k))
        local val
        if type(v) == "table" then val = formatTable(v, depth + 1)
        elseif type(v) == "string" then val = string.format("%q", v)
        else val = tostring(v) end
        table.insert(result, key .. " = " .. val)
    end
    return "{" .. table.concat(result, ", ") .. "}"
end

local function logRemote(method, self, args)
    if checkcaller() then return end
    
    local path = "Unknown"
    pcall(function() path = self:GetFullName() end)
    
    
    if string.find(path, "ChatService") or string.find(path, "RobloxGui") or string.find(path, "BridgeNet") then 
        return 
    end

    local calling = getcallingscript()
    local callingPath = calling and calling:GetFullName() or "Unknown Script"
    local argCount = args.n or #args

    print("----------------------------------------")
    print(string.format("[REMOTE SPY] Вызов метода: %s", method))
    print(string.format("[Путь к Remote]: %s", path))
    print(string.format("[Кол-во аргументов]: %d", argCount))
    print(string.format("[Кто вызвал]: %s", callingPath))
    print("[Аргументы]:")
    
    if argCount == 0 then
        print("  -> (Пустой вызов / Нет аргументов)")
    else
        for i = 1, argCount do
            local arg = args[i]
            local argType = type(arg)
            
            if arg == nil then
                print(string.format("  [%d] is nil", i))
            elseif argType == "table" then
                print(string.format("  [%d] (table): %s", i, formatTable(arg)))
            elseif argType == "string" then
                print(string.format("  [%d] (string): %q", i, arg))
            elseif argType == "userdata" and typeof(arg) == "Instance" then
                local instancePath = "Unknown Instance"
                pcall(function() instancePath = arg:GetFullName() end)
                print(string.format("  [%d] (Instance): %s", i, instancePath))
            else
                print(string.format("  [%d] (%s): %s", i, argType, tostring(arg)))
            end
        end
    end
    print("----------------------------------------")
end


local emptyRemoteEvent = Instance.new("RemoteEvent")
local emptyRemoteFunction = Instance.new("RemoteFunction")

local c_FireServer = emptyRemoteEvent.FireServer
local c_InvokeServer = emptyRemoteFunction.InvokeServer
local c_Kick = LocalPlayer.Kick


emptyRemoteEvent:Destroy()
emptyRemoteFunction:Destroy()




oth.hook(c_FireServer, function(self, ...)
    if not checkcaller() then
        local path = "Unknown"
       
        pcall(function() path = self:GetFullName() end)
        
      
        if string.find(path, "Remotes.Grab") then
            print(" Был вызван Grab через FireServer подмена на safeLogTemplate")
            local original = oth.get_root_callback()
            return original(self, safeLogTemplate)
        end
        
        logRemote("FireServer", self, table.pack(...))
    end
    
   
    return oth.get_root_callback()(self, ...)
end)


oth.hook(c_InvokeServer, function(self, ...)
    if not checkcaller() then
        local path = "Unknown"
       
        pcall(function() path = self:GetFullName() end)
        
        if string.find(path, "Remotes.Grab") then
            print("[oth.hook]: Был вызван Grab через InvokeServer подмена на safeLogTemplate")
            local original = oth.get_root_callback()
            return original(self, safeLogTemplate)
        end
        
        logRemote("InvokeServer", self, table.pack(...))
    end
    
    return oth.get_root_callback()(self, ...)
end)

oth.hook(c_Kick, function(self, ...)
    if not checkcaller() and self == LocalPlayer then
        local args = {...}
        local reason = args[1] or "Без причины"
        print(string.format("[ANTI-KICK ]: Игра попыталась кикнуть вас по причине: %s", tostring(reason)))
        return nil 
    end
    
    return oth.get_root_callback()(self, ...)
end)

print("[Remote Spy ]: Успешно запущен")

