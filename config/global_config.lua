skynet_root = "3rd/skynet/"
root = "./"
thread = 8
logger = "logs/global.log"
logpath = "../log/"
statistic_path = "./logs/statistic/"
harbor = 0
start = "global_main"
bootstrap = "snlua bootstrap"
cluster = root .. "etc/clustername.lua"
global_service = root .. "global_server/?.lua;" ..
			   root .. "global_server/srv/?.lua;" ..
			   root .. "service/?.lua"
luaservice = skynet_root .. "service/?.lua;" .. global_service
cpath = "cservice/?.so;" .. skynet_root .. "cservice/?.so"
lua_path = skynet_root .. "lualib/?.lua;" ..
	root .. "?.lua;" ..
	root .. "lib/lualib/?.lua;" ..
	root .. "lib/lualib/hotfix/?.lua;" ..
	root .. "lib/lualib/auth/?.lua;" ..
	root .. "lib/lualib/proto/?.lua;" ..
	root .. "lib/lualib/redis/?.lua;" ..
	root .. "preload/?.lua;" ..
	root .. "data/?.lua;" ..
	root .. "utils/?.lua;" ..
	root .. "etc/?.lua;" ..
	root .. "proto/?.lua;" ..
	root .. "game_server/base/?.lua;" ..
	root .. "game_server/adapt/?.lua;" ..
    root .. "global_server/?.lua"
lua_cpath = skynet_root .. "luaclib/?.so;" .. root .. "lib/luaclib/?.so"
preload = root .. "preload/preload.lua"
lualoader = skynet_root.."lualib/loader.lua"
snax = global_service
daemon = "./skynet-global.pid"

nodename = "global"
console_port = 9400
global_port = 5100