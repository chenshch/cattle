skynet_root = "3rd/skynet/"
root = "./"
thread = 8
logger = "logs/gate.log"
logpath = "../log/"
harbor = 0
start = "gate_main"
bootstrap = "snlua bootstrap"
cluster = root .. "etc/clustername.lua"
gate_service = root .. "gate_server/?.lua;" ..
			   root .. "gate_server/srv/?.lua;" ..
			   root .. "game_server/srv/?.lua;" ..
			   root .. "service/?.lua" 
luaservice = skynet_root .. "service/?.lua;" .. gate_service
cpath = "cservice/?.so;" .. skynet_root .. "cservice/?.so"
lua_path = skynet_root .. "lualib/?.lua;" ..
	root .. "?.lua;" ..
	root .. "lib/lualib/?.lua;" ..
	root .. "lib/lualib/hotfix/?.lua;" ..
	root .. "lib/lualib/auth/?.lua;" ..
	root .. "lib/lualib/proto/?.lua;" ..
	root .. "lib/lualib/redis/?.lua;" ..
	root .. "lib/lualib/websocket/?.lua;" ..
	root .. "preload/?.lua;" ..
	root .. "data/?.lua;" ..
	root .. "utils/?.lua;" ..
	root .. "proto/?.lua;" ..
	root .. "/etc/?.lua;" ..
	root .. "game_server/?.lua;" ..
	root .. "gate_server/?.lua"
lua_cpath = skynet_root .. "luaclib/?.so;" .. root .. "lib/luaclib/?.so"
preload = root .. "preload/preload.lua"
lualoader = skynet_root.."lualib/loader.lua"
snax = gate_service
daemon = "./skynet-gate.pid"

nodename = "gate1"
console_port = 9200
gate_port = 8080

