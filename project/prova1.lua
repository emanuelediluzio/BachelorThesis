function init (args)
    local needs = {}
    needs["payload"] = tostring(true)
    return needs
end

function match(args)
    local a = args["payload"]

    local reversed_payload = a:reverse()
    local reversed_temperature = string.match(reversed_payload, "(%d+) :erutarepmeT")

    local pressure = nil
    if reversed_temperature then
        temperature = reversed_temperature:reverse()
    end

    local reversed_cpu = string.match(reversed_payload, "(%d+) :egasU UPC")

    local cpu = nil
    if reversed_cpu then
        cpu = reversed_cpu:reverse()
    end

    local reversed_humidity = string.match(reversed_payload, "(%d+) :ytidimuH")

    local humidity = nil
    if reversed_humidity then
        humidity = reversed_humidity:reverse()
    end
    cpu1 = tonumber(cpu)
    temp1 = tonumber(temperature)
    hum1 = tonumber(humidity)

    if cpu1 > 60 and temp1 > 50 and hum1 > 40 then
        return 1
    end
    return 0
end

return 0

