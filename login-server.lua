local core = require "src/common/core"
local loginserver = require "config/login_config"

local client_table = {}
local socket = require("socket")
local server = socket.bind(loginserver.bind_ip, loginserver.port)

while 1 do
    local recvt = socket.select(client_table, nil, 1)
    local client = server:accept()
    client:settimeout(10)

    --[[
    local co = coroutine.create(function (client, recvt)
        if client then
            client_table[#client_table+1] = client
        end

        if #recvt > 0 then
            --if 
        end

    end)
    --]]

    if client then
        client_table[#client_table+1] = client
    end

    local line, err = client:receive(86)
    if not err then
        local data_out = core:Handler(line)
        client:send(data_out)
    end
    --client:close()
    --shutdown() seems more applicable here???
end
