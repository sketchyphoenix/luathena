local core = require "src/common/core"
local loginserver = require "config/login_config"

local client_table = {}
local threads = {}
local socket = require("socket")
local server = socket.bind(loginserver.bind_ip, loginserver.port)

while 1 do
    local recvt = socket.select(client_table, nil, 1)
    local client = server:accept()

    local co = coroutine.create(function (client)
        client:settimeout(0.1)
        local data, status, partial = client:receive(65535)
        
        if partial then
            data = partial
        end

        if status == "timeout" then
            coroutine.yield(data, status)
        end

        return data, status
    end)

    if client then
        core:AddClientToTable(client, client_table)
        table.insert(threads,co)
    end

    for i=1,#threads do
        local coroutine_status, data, socket_status = coroutine.resume(threads[i], client)
        if socket_status == "closed" or coroutine_status == false then
            table.remove(threads,i)
            break
        end
        local data_out = core:Handler(data)
        client:send(data_out)
    end

    --client:close()
end
