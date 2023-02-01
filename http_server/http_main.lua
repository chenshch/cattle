local skynet = require("skynet")
require("skynet.manager")


skynet.start(function()
    local http_port = skynet.getenv("http_port")
    skynet.newservice("srv_http", http_port)
    skynet.error("Listen Http Port: " .. http_port)
end)