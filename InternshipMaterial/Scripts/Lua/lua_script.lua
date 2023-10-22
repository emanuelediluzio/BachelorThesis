--Lua script

function init (args)
    local needs = {}
    needs["payload"] = tostring(true)
    return needs
end

function match(args)
    
    local a = args["payload"]
    local cpu = string.sub(string.match(a, "CPU Usage:(.*)"), 1, 3)
    local num_cpu = tonumber(cpu)
    --[[local temp = string.sub(string.match(a, "Temperature:(.*)"), 1, 3)
    local num_temp = tonumber(temp)
    local hum = string.sub(string.match(a, "Humidity:(.*)"), 1, 3)
    local num_hum = tonumber(hum)]]--
    if num_cpu > 60 """and num_temp > 50 and num_hum > 40""" then
        return 1
    end
    return 0
end

return 0
