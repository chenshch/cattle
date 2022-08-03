local skynet = require("skynet")
require("skynet.manager")


skynet.start(function()
    skynet.uniqueservice()
end)