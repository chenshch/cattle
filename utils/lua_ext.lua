-- lua扩展

-- table扩展

-- 返回table大小

table.include = function(array, val)
    for _, v in ipairs(array) do
        if v == val then
            return true
        end
    end
    return false
end

table.size = function(t)
	local count = 0
	for _ in pairs(t) do
		count = count + 1
	end
	return count
end

-- 判断table是否为空
table.empty = function(t)
    return table.size(t) == 0
end

-- 判断table是否为空:非空,减少外界判断
table.nonempty = function(t)
    return table.size(t) > 0
end

-- 返回table索引列表
table.indices = function(t)
    local result = {}
    for k, _ in pairs(t) do
        table.insert(result, k)
    end
    return result
end

-- 返回table值列表
table.values = function(t)
    local result = {}
    for k, v in pairs(t) do
        table.insert(result, v)
    end
end

-- 浅拷贝
table.clone = function(t, nometa)
    local result = {}
    if not nometa then
        setmetatable(result, getmetatable(t))
    end
    for k, v in pairs (t) do
        result[k] = v
    end
    return result
end

-- 深拷贝
table.copy = function(t, nometa)
    if type(t) ~= "table" then
        return t
    end

    local result = {}
    if not nometa then
        setmetatable(result, getmetatable(t))
    end
    for k, v in pairs(t) do
        if type(v) == "table" then
            result[k] = table.copy(v)
        else
            result[k] = v
        end
    end
    return result
end

-- 深拷贝
table.copy_ext = function(t)
    if type(t) ~= "table" then
        return t
    end

    local result = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            result[k] = table.copy_ext(v)
        else
            result[k] = v
        end
    end
    return result
end

table.merge = function(dest, src)
    for k, v in pairs(src) do
        dest[k] = v
    end
end

-- 列表中,某个值相加
-- dest={{key=11, count=10},};src={key=11, count=5} =>dest={{key=11, count=15},}
table.inc_values = function(dest, key, v_key, src)
    for _, v in pairs(dest) do
        if v[key] == src[key] then
            v[v_key] = v[v_key] + src[v_key]
            break
        end
    end
end

table.unique_insert = function(t,val)
    for _, v in pairs(t) do
        if v == val then return end
    end
    table.insert(t,val)
end

table.delete = function(t,val)
    for k,v in pairs(t) do
        if v==val then
            table.remove(t, k)
            return true
        end
    end
end

--根据table某个字段获取值,array所有值为table结构
table.key_find = function(array, key, val)
    for _, v in pairs(array) do
        if v[key] == val then
            return v 
        end
    end
    return nil
end

table.key_find_all = function(array, key, val)
    local data = {}
    for _,v in ipairs(array) do
        if v[key] == val then
            table.insert(data, v)
        end
    end
    return data
end

table.key_find_table = function(array, key, conArray)
    local dataList = {}

    for _, value in ipairs(conArray) do
        -- 
        local data      = table.key_find_all(array, key, value)
        if data then
            local dTemp  = table.copy(data)
            table.link(dataList, dTemp)
        end
    end

    return dataList
end

table.key_delete = function(list, key, val)
    for k, v in pairs(list) do
        if v[key] == val then
            table.remove(list, k)
            return true
        end
    end
    return false
end

--删除所有v[key] = val的值
table.key_delete_all = function(list, key, val)
    local i = 1
    for i=#list, 1, -1 do
        if list[i][key] == val then
            table.remove(list, i)
        end
    end
end

--删除多个数据
table.array_delete = function(array, t_val)
    for _,v in pairs(t_val) do
        table.delete(array, v)
    end
end

--检测某个值是否在table里面
table.member = function(array, val)
    for _,v in pairs(array) do
        if v==val then
            return true
        end
    end
    return false
end

--连接
table.link = function(dest, obj)
    for _, v in pairs(obj) do
        table.insert(dest,v)
    end
end

--分割
table.split = function(list, split_num)
    local first = {}
    local last = {}
    for i=1, #list do
        if not list[i] then
            break
        end
        if i <= split_num then
            table.insert(first, list[i])
        else
            table.insert(last, list[i])
        end
    end
    return first,last
end

--连接两个表
table.append = function(list, obj)
    if table.empty(obj) then
        return
    end
    for _,v in ipairs(obj) do
        table.insert(list, v)
    end
end

--列表去重复
table.verify_uniq = function(list, key)
    local data = {}
    for _, v in ipairs(list) do
        if not table.key_find(data, key, v[key]) then
            table.insert(data, v)
        end
    end
    return data
end

--清空表
table.clear = function(list)
    if type(list) ~= "table" then
        return
    end
    for k,_ in pairs(list) do
        list[k] = nil
    end
end

--随即获取不重复的数据
table.rand_num = function(list, num)
    local data = {}
    for i=1, num do
        local len = #list
        local index = math.random(1, len)
        table.insert(data, list[index])
        table.remove(list, index)
    end
    return data
end

--将列表某个键值转换为列表
table.key2list = function(list, key)
    local data = {}
    for _, v in pairs(list) do
        table.insert(data, v[key])
    end
    return data
end

--获取某个列表指定键值元素
table.specify_list = function(list, key, val)
    local data = {}
    for _, v in pairs(list) do
        if v[key] == val then
            table.insert(data, v)
        end
    end
    return data
end

--列表原地随机
table.list_rand = function(list, num)
    local len = #list
    if len < num then
        return list
    end

    --随机n个不重复的元素
    local stop = len - num +1
    local data = {}
    for i = len, stop, -1 do
        local index = math.random(1, i)
        local tmp = list[i]
        list[i] = list[index]
        list[index] = tmp
        if stop ~= 1 then
            table.insert(data, list[i])
        end
    end
    if stop == 1 then
        return list
    else
        return data
    end
end

--获取对象的键值,元素只能是k = val的值
table.get_array_key = function(array)
    local data = {}
    for k, v in pairs(array) do
        table.insert(data, k)
    end
    return data
end

--获取列表某个值的索引
table.val_index = function(list, key, val)
    for k, v in ipairs(list) do
        if v[key] == val then
            return k
        end
    end
end

table.insertto= function(dest, src, begin)
    begin = checkint(begin)
    if begin <= 0 then
        begin = #dest + 1
    end

    local len = #src
    for i = 0, len - 1 do
        dest[i + begin] = src[i + 1]
    end
end

-- 根据value获取key
table.get_key = function(tbl, value)
    for k, v in pairs(tbl) do
        if v == value then
            return k
        end
    end
end

-- 遍历table
table.foreachi = function(tab, fun)
    if type(tab) ~= "table" then
        return 
    end

    for k, v in ipairs(tab) do
        if fun(k, v) then
            return
        end
    end
end

-- 遍历table
table.foreach = function(tab, fun)
    if type(tab) ~= "table" then
        return 
    end
    
    for k, v in pairs(tab) do
        if fun(k, v) then
            return
        end
    end
end

-- 两个表是否有交集
table.mix = function(t1, t2)
    for _, v in ipairs(t2) do
        if table.member(t1, v) then
            return true
        end
    end
    return false
end

-- string扩展

-- 下标运算
do
    local mt = getmetatable("")
    local _index = mt.__index

    mt.__index = function (s, ...)
        local k = ...
        if "number" == type(k) then
            return _index.sub(s, k, k)
        else
            return _index[k]
        end
    end
end

string.split = function(s, delim)
    local split = {}
    local pattern = "[^" .. delim .. "]+"
    string.gsub(s, pattern, function(v) table.insert(split, v) end)
    return split
end

string.ltrim = function(s, c)
    local pattern = "^" .. (c or "%s") .. "+"
    return (string.gsub(s, pattern, ""))
end

string.rtrim = function(s, c)
    local pattern = (c or "%s") .. "+" .. "$"
    return (string.gsub(s, pattern, ""))
end

string.trim = function(s, c)
    return string.rtrim(string.ltrim(s, c), c)
end

local function dump(obj)
    local getIndent, quoteStr, wrapKey, wrapVal, dumpObj
    getIndent = function(level)
        return string.rep("\t", level)
    end
    quoteStr = function(str)
        return '"' .. string.gsub(str, '"', '\\"') .. '"'
    end
    wrapKey = function(val)
        if type(val) == "number" then
            return "[" .. val .. "]"
        elseif type(val) == "string" then
            return "[" .. quoteStr(val) .. "]"
        else
            return "[" .. tostring(val) .. "]"
        end
    end
    wrapVal = function(val, level)
        if type(val) == "table" then
            return dumpObj(val, level)
        elseif type(val) == "number" then
            return val
        elseif type(val) == "string" then
            return quoteStr(val)
        else
            return tostring(val)
        end
    end
    dumpObj = function(obj, level)
        if type(obj) ~= "table" then
            return wrapVal(obj)
        end
        level = level + 1
        local tokens = {}
        tokens[#tokens + 1] = "{"
        for k, v in pairs(obj) do
            tokens[#tokens + 1] = getIndent(level) .. wrapKey(k) .. " = " .. wrapVal(v, level) .. ","
        end
        tokens[#tokens + 1] = getIndent(level - 1) .. "}"
        return table.concat(tokens, "\n")
    end
    return dumpObj(obj, 0)
end

--dump第二个版本
local function dump2(value)
    local str = ''

    if (type(value) ~= 'table') then
        if (type(value) == 'string') then
            str = string.format("%q", value)
        else
            str = tostring(value)
        end
    else
        local auxTable = {}
        for key in pairs(value) do
            if (tonumber(key) ~= key) then
                table.insert(auxTable, key)
            else
                table.insert(auxTable, dump2(key))
            end
        end
        --table.sort(auxTable)

        str = str..'{'
        local separator = ""
        local entry = ""
        for _, fieldName in ipairs(auxTable) do
            if ((tonumber(fieldName)) and (tonumber(fieldName) > 0)) then
                entry = dump2(value[tonumber(fieldName)])
            else
                entry = fieldName.." = "..dump2(value[fieldName])
            end
            str = str..separator..entry
            separator = ", "
        end
        str = str..'}'
    end
    return str
end

do
    _tostring = tostring
    tostring = function(v)
        if type(v) == 'table' then
            return dump2(v)
        else
            return _tostring(v)
        end
    end
end

-- math扩展
do
	local _floor = math.floor
	math.floor = function(n, p)
		if p and p ~= 0 then
			local e = 10 ^ p
			return _floor(n * e) / e
		else
			return _floor(n)
		end
	end
end

math.round = function(n, p)
        local e = 10 ^ (p or 0)
        return math.floor(n * e + 0.5) / e
end

-- lua面向对象扩展
function class(classname, super)
    local superType = type(super)
    local cls

    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end

    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object
        cls = {}

        if superType == "table" then
            -- copy fields from super
            for k,v in pairs(super) do cls[k] = v end
            cls.__create = super.__create
            cls.super    = super
        else
            cls.__create = super
            cls.ctor = function() end
        end

        cls.__cname = classname
        cls.__ctype = 1

        function cls.new(...)
            local instance = cls.__create(...)
            -- copy fields from class to native object
            for k,v in pairs(cls) do instance[k] = v end
            instance.class = cls
            instance:ctor(...)
            return instance
        end

    else
        -- inherited from Lua Object
        if super then
            cls = {}
            setmetatable(cls, {__index = super})
            cls.super = super
        else
            cls = {ctor = function() end}
        end

        cls.__cname = classname
        cls.__ctype = 2 -- lua

        function cls.new(...)
            local instance = setmetatable({}, {__index = cls})
            --instance.class = cls
            instance:ctor(...)
            return instance
        end
    end

    return cls
end

function iskindof(obj, classname)
    if obj.__cname == classname then
        return true
    end
    return false
end

function checknumber(value, base)
    return tonumber(value, base) or 0
end

function checkint(value)
    return math.round(checknumber(value))
end

function RandomWithWeight(list, sum)
    if list == nil or #list == 0 then
        return 0, 0
    end

    if sum == nil or sum == 0 then
        sum = 0
        for _, aWeight in ipairs(list) do
            sum = sum + aWeight
        end
    end

    local ret = 1
    if sum > 0 then
        local r = math.random(1, sum)
        local didSum = 0
        for index, q in ipairs(list) do
            didSum = didSum + q
            if r <= didSum then
                ret = index
                break
            end
        end
    end

    return ret, sum
end


