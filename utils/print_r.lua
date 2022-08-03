-- 调试打印函数(打印table)

local print = print
local type = type
local pairs = pairs
local tostring = _tostring or tostring
local next = next
local skynet = require "skynet"

function print_rs(root)
    if type(root) ~= "table" then
        return "is " .. type(root) .. " not table"
    end
    local cache = {  [root] = "." }
    local function _dump(t,space,name)
        local temp = {}
        for k,v in pairs(t) do
            local key = tostring(k)
            if cache[v] then
                table.insert(temp,"+" .. key .. " {" .. cache[v].."}")
            elseif type(v) == "table" then
                local new_key = name .. "." .. key
                cache[v] = new_key
                table.insert(temp,"+" .. key .. _dump(v,space .. (next(t,k) and "|" or " " ).. string.rep(" ",#key),new_key))
            else
                table.insert(temp,"+" .. key .. " [" .. tostring(v).."]")
            end
        end
        return table.concat(temp,"\n"..space)
    end
    return _dump(root, "","")
end

function print_r(root)
    skynet.error(print_rs(root))
end

return print_r
