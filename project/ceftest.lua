function init (args)
    local needs = {}
    needs["type"] = "packet"
    needs["filter"] = "alerts" 
    return needs
end

function setup (args)
    filename = SCLogPath() .. "/" .. "ceftest.cef"
    file = assert(io.open(filename, "a"))
    SCLogInfo("ModbusLuaTest Log Filename " .. filename)
    packet = 1
end

function log(args)   
    timestring = SCPacketTimeString()
    ip_version, src_ip, dst_ip, protocol, src_port, dst_port = SCPacketTuple()
    msg = SCRuleMsg()
    p = SCPacketPayload()
    sid, rev, gid = SCRuleIds()
    class, prio = SCRuleClass()
    local handle = io.popen("suricata -V | awk '{print $5}'")
    local result = handle:read("*a")
    str = result:gsub("\n", "")
    handle:close()
    if protocol == 6 then
	    proto = "TCP"
    end
   
    if dst_port ~= 502 then
	return
    end
     if p == "" then
        return
    end

    file:write ("CEF:0|OISF|Suricata|" .. str .. "|" .. rev .. ":" .. sid .. ":" .. gid .. "|Modbus Communication|" .. prio .. "| rt=" .. timestring .. " act=alert" .. " proto=" .. proto .. " src=" .. src_ip .. " spt=" .. src_port .. " dst=" .. dst_ip .. " dpt= " .. dst_port  .. " msg=" .. msg .. "\n\n")
    file:flush()

    packet = packet + 1
end

function deinit (args)
    SCLogInfo ("Modbus transactions logged: " .. packet);
    file:close(file)
end
