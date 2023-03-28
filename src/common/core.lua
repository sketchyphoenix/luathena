local core = {}

function core:DisplayTitle()
end

function core:PrintNotice(message)
    print("[Notice]: " .. message)
end

function core:AddClientToTable(client, client_table)
    for index,value in ipairs(client_table) do
        if value == client then
            print('already here')
            return client
        end
    end

    client_table[#client_table+1] = client
    return client
end

function core:RemoveClientFromTable(client, client_table)
    for index,value in ipairs(client_table) do
        if value == client then
            client_table[index] = nil
        end
    end
    return client_table[index]
end

function core:ReadSocket(client)
    client:settimeout(0.1)
    local data, status, partial = client:receive(65535)
    
    if partial then
        data = partial
    end

    return data, status
end

function core:Handler(data)
    local code = string.unpack("<i2", data)

    if code == 0x2710 then return core:ParseCharConnectRequest(data) end

    return nil
end

--[[
   0x2710
]]
function core:ParseCharConnectRequest(data)
    local inter_username = string.sub(data,3,26)
    local inter_password = string.sub(data,27,50)

    local ip_byte_array = string.unpack(">i4", string.sub(data,55,58))
    local ipaddr = tonumber(ip_byte_array)
    local oct1 = (ipaddr >> 24) & 0xFF
    local oct2 = (ipaddr >> 16) & 0xFF
    local oct3 = (ipaddr >> 8) & 0xFF
    local oct4 = (ipaddr >> 0) & 0xFF
    ipaddr = oct1.."."..oct2.."."..oct3.."."..oct4

    local port = string.unpack(">i2", string.sub(data,59,60))
    local server_name = string.sub(data,61,80)
    local maintenance_flag = string.unpack("<i1", string.sub(data,83))
    local display_new_flag = string.unpack("<i1", string.sub(data,85))

    local code = string.pack("<i2", 0x2711)
    local status = string.pack("<i1", 0)
    return (code .. status)
end

return core