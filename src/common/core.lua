local core = {}

function core:DisplayTitle()
end

function core:PrintNotice(message)
    print("[Notice]: " .. message)
end

function core:AddClientToTable(client, client_table)
    for index,value in ipairs(client_table) do
        if value == client then
            return client
        end
    end

    client_table[#client_table+1] = client
    return client
end

function core:Handler(data)
    local code = string.unpack("<i2", data)

    if code == 0x2710 then return core:ParseCharConnectRequest(data) end
end

--[[
   0x2710
]]
function core:ParseCharConnectRequest(data)
    local inter_username = string.sub(data,3,26) print(inter_username)
    local inter_password = string.sub(data,27,50) print(inter_password)

    local ip_byte_array = string.unpack(">i4", string.sub(data,55,58))
    local ipaddr = tonumber(ip_byte_array)
    local oct1 = (ipaddr >> 24) & 0xFF
    local oct2 = (ipaddr >> 16) & 0xFF
    local oct3 = (ipaddr >> 8) & 0xFF
    local oct4 = (ipaddr >> 0) & 0xFF
    ipaddr = oct1.."."..oct2.."."..oct3.."."..oct4
    print (ipaddr)

    local port = string.unpack(">i2", string.sub(data,59,60)) print(port)
    local server_name = string.sub(data,61,80) print(server_name)
    local maintenance_flag = string.unpack("<i1", string.sub(data,83)) print(maintenance_flag)
    local display_new_flag = string.unpack("<i1", string.sub(data,85)) print(display_new_flag)

    local code = string.pack("<i2", 0x2711)
    local status = string.pack("<i1", 0)
    return (code .. status)
end

return core