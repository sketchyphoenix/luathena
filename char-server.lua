local core = require "src/common/core"
local charserver = require "config/char_config"

local socket = require("socket")
local tcp = assert(socket.tcp())
tcp:connect(charserver.loginserver_ip, charserver.loginserver_port)
tcp:send("hello world\n")

while 1 do
    local s, status, partial = tcp:receive()
    print(s or partial)
    if status == "closed" then break end
end
tcp:close()