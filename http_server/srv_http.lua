local skynet = require "skynet"
local socket = require "skynet.socket"
require "skynet.manager"

local port, body_size_limit = ...

local CMD = {}
local agent = {}

-- http代理服务数量,可配置
local http_agent_num = skynet.getenv("http_agent_num") or 50

function CMD.get_http_handles()
    return agent
end

skynet.dispatch("lua", function(session, _, cmd, ...)
    local func = assert(CMD[cmd], cmd .. " not found")
    local ret = func(...)
    if session > 0 and cmd ~= "exit" then skynet.retpack(ret) end
end)

skynet.start(function()
    skynet.register(".http")
    body_size_limit = body_size_limit or 8192

    -- 创建代理服务
    for i= 1, http_agent_num do
        agent[i] = skynet.newservice("srv_http_agent", body_size_limit)
    end

    local balance = 1
    local listen_id = socket.listen("0.0.0.0", port, 128)
    socket.start(listen_id , function(id, addr)
        -- 当一个 http 请求到达的时候, 把 socket id 分发到事先准备好的代理中去处理。
        local ip, _ = addr:match("([^:]+):?(%d*)$")
        skynet.send(agent[balance], "lua", _, id, ip)
        balance = balance + 1
        if balance > #agent then
            balance = 1
        end
    end)
end)
