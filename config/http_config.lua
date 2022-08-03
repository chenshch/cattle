skynet_root = "3rd/skynet/"
root = "./"
thread = 8
logger = "logs/http.log"
logpath = "../log/"
statistic_path = "./logs/statistic/"
harbor = 0
start = "http_main"
bootstrap = "snlua bootstrap"
cluster = root .. "etc/clustername.lua"
http_service = root .. "http_server/?.lua;" ..
				root .. "http_server/srv/?.lua;" ..
				root .. "service/?.lua" 
luaservice = skynet_root .. "service/?.lua;" .. http_service
cpath = "cservice/?.so;" .. skynet_root .. "cservice/?.so"
lua_path = skynet_root .. "lualib/?.lua;" ..
	root .. "?.lua;" ..
	root .. "lib/lualib/?.lua;" ..
	root .. "lib/lualib/hotfix/?.lua;" ..
	root .. "lib/lualib/auth/?.lua;" ..
	root .. "lib/lualib/proto/?.lua;" ..
	root .. "lib/lualib/web/?.lua;" ..
	root .. "lib/lualib/redis/?.lua;" ..
	root .. "preload/?.lua;" ..
	root .. "data/?.lua;" ..
	root .. "utils/?.lua;" ..
	root .. "etc/?.lua;" ..
	root .. "proto/?.lua;" ..
	root .. "http_server/?.lua"
lua_cpath = skynet_root .. "luaclib/?.so;" .. root .. "lib/luaclib/?.so"
preload = root .. "preload/preload.lua"
lualoader = skynet_root.."lualib/loader.lua"
daemon = "./skynet-http.pid"

nodename = "http"
console_port = 9100
http_port = 2100
http_agent_num = 3

-- 用于客户端登录
gate1 = "127.0.0.1:8080"

-- 实时数据推送
-- real_server_host = "127.0.0.1:9090"
-- real_server_host = "112.74.174.134:9090"