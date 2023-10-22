function init (args)
    local needs = {}
    needs["type"] = "packet"
    needs["filter"] = "alerts" 
    return needs
end

function setup (args)
    filename = SCLogPath() .. "/" .. "luatest.log"
    file = assert(io.open(filename, "a"))
    SCLogInfo("ModbusLuaTest Log Filename " .. filename)
    packet = 1
end

function log(args)   
    timestring = SCPacketTimeString()
    ip_version, src_ip, dst_ip, protocol, src_port, dst_port = SCPacketTuple()
    p = SCPacketPayload()
    msg = SCRuleMsg()
    sid, rev, gid = SCRuleIds()
    class, prio = SCRuleClass()
    if protocol == 6 then
	    proto = "TCP"
    end
    
    local reversed_payload = p:reverse()
    local reversed_temperature = string.match(reversed_payload, "(%d+) :erutarepmeT")

    local temperature = nil
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

    if dst_port ~= 502 then
	return
    end
    if p == "" then
	return
    end
    file:write ("---------------------------------------------------------------------".."\n" .. "ALERT DETAILS" .. "\n" .. msg .. "\n" .. "sid: " .. sid .. ", rev: " .. rev .. ", gid: " .. gid .. ", Priority: " .. prio .. "\n" .. "N:" .. packet .. " | Timestamp: " .. timestring .." | IPv" .. ip_version .. " | Protocol: " .. proto .."\n".."| Source/Destination: ".. src_ip .. ":" .. src_port .. " -> " .. dst_ip .. ":" .. dst_port .. "\n" .. "| CRITICAL PAYLOAD" .. "\n" .. "CPU Usage: " .. cpu1 .. "%" .. "\n" .. "Temperature: " .. temp1 .. "°" .. "\n" .. "Humidity: " .. hum1 .. "%" .. "\n" .. "\n" .. "TOTAL PAYLOAD:" .. "\n" ..  p .. "\n")
    file:flush()
    packet = packet + 1
end

function deinit (args)
    SCLogInfo ("Modbus transactions logged: " .. packet);
    file:close(file)
end
