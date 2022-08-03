skynet_root = "3rd/skynet/"
root = "./"
thread = 8
logger = "logs/game1.log"
logpath = "../log/"
statistic_path = "./logs/statistic/"
harbor = 0
start = "game_main"
bootstrap = "snlua bootstrap"
cluster = root .. "etc/clustername.lua"
game_service = root .. "game_server/?.lua;" ..
			   root .. "game_server/srv/?.lua;" ..
			   root .. "service/?.lua"
luaservice = skynet_root .. "service/?.lua;" .. game_service
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
	root .. "game_server/?.lua"
lua_cpath = skynet_root .. "luaclib/?.so;" .. root .. "lib/luaclib/?.so"
preload = root .. "preload/preload.lua"
lualoader = skynet_root.."lualib/loader.lua"
snax = game_service
daemon = "./skynet-game.pid"

nodename = "game1"
console_port = 9300
game_port = 4100
