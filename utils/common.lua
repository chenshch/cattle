--[[
 * File name: utils.lua
 * Created by vscode.
 * Author: lxq
 * Date time: 2019-04-25 09:58:29
 * Copyright (C) 2019 .
 * Description: 常用基础函数
--]]

local skynet = require "skynet"
local lfs = require "lfs"
local MD5

--创建定时器
function create_timeout(ti, func)
    local active = true
    local function cb()
        if active then
            func()
            func = nil
        end
    end
    skynet.timeout(ti, cb)
    return function() active, func = false, nil end
end

-- url编码
function url_encode(s)  
     s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)  
    return string.gsub(s, " ", "+")  
end  
-- url解码
function url_decode(s)  
    s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)  
    return s  
end

--检查sql注入
function check_sql_str(str)
    if not str or str == "" then
        return false
    end
    local str1 = string.lower(str)
    local str_list = {';', 'and','exec', 'insert','select', 'delete','update','count','master','truncate','declare','char(','mid(','chr('}
    for _, v in ipairs(str_list) do
        local pos = string.find(str1, v, 1 , true)
        if pos then
            return true
        end
    end
    return false
end

-- 过滤并替换特殊字符
function quote_sql_str(str)
    local escape_map = {
        ['\0'] = "*",
        ['\b'] = "\\b",
        ['\n'] = "\\n",
        ['\r'] = "\\r",
        ['\t'] = "\\t",
        ['\26'] = "*",
        ['\\'] = "\\\\",
        ["'"] = "*",
        ['"'] = '\\"',
    }
    return string.format("%s", string.gsub(str, "[\0\b\n\r\t\26\\\'\"]", escape_map))
end

-- 获取文件夹下所有的文件名(lua文件)
function get_dir_all_files(path)
    local files = {}
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." and file ~= ".git" then
            local file_name = string.sub(file, 1, -5)
            if not string.find(file_name, "%.") then table.insert(files, file_name) end
        end
    end
    return files
end

-- 重新组装从redis获取的data列表
function format_redis_data(data)
    if not data or type(data) ~= 'table' then return end
    local ret = {}
    for i=1, #data, 2 do
        ret[data[i]] = data[i+1]
    end
    return ret
end

--根据权重筛选
function key_rand(obj, key)
    if #obj == 0 then
        return
    end

    local weight = {}
    local t = 0
    for k, v in ipairs(obj) do
        t = t + v[key]
        weight[k] = t
    end
    if t <= 0 then
        return math.random(1, #weight)
    end
    local c = math.random(1, t)
    for k, v in ipairs(weight) do
        if c <= v then
            return k
        end
    end
    return #weight
end

-- 获取当前天数（自1970年）
function GGetYDay(timestamp)
    return math.floor((timestamp + (8 * 3600)) / (3600 * 24))
end

-- 获取某时间戳的0点时间
function unixtime_zero_time(unix_time)
    local t_date = os.date("*t", unix_time)
    return os.time({
        year    = t_date.year,
        month   = t_date.month,
        day     = t_date.day,
        hour    = 0,
        min     = 0,
        sec     = 0
    })
end

-- 检查两个时间是否同一天
function GUnixtimeIsSame(time1, time2)
    local t_date_1 = os.date("*t", time1)
    local t_date_2 = os.date("*t", time2)
    return t_date_1.year == t_date_2.year and t_date_1.month == t_date_2.month
            and t_date_1.day == t_date_2.day
end

-- 获取当天0点时间戳
function GUnixtimeToday()
    local t_date = os.date("*t")
    return os.time({
        year = t_date.year,
        month = t_date.month,
        day = t_date.day,
        hour = 0,
        min = 0,
        sec = 0
    })
end

-- 获取明天0点时间戳
function GUnixtimeTomorrow()
    return GUnixtimeToday() + 86400
end

-- 根据资源id获取资源key
function get_key_by_resid(res_id)
    for k, v in pairs(const.res_type) do
        if v == res_id then return k end
    end
end

-- 判断是否是资源
function GIsResourceId(_resId)
    for k, v in pairs(const.res_type) do
        if v == _resId then 
            return true
        end
    end
end

-- 判断是否是资源
function GIsResourceExtId(_resId)
    for k, v in pairs(const.res_type_ext) do
        if v == _resId then 
            return true
        end
    end
end

-- 判断是否是资源
function GIsResourceExtKey(_key)
    for k, v in pairs(const.res_type_ext) do
        if k == _key then 
            return true
        end
    end
end

-- 获取今天是哪月
function GGetDateMonth()
    local t_date    = os.date("*t")
    return t_date.month
end
--  -------------------------- 新添加可能没被使用 --------------------------

-- ----------- 时间相关 -----------


-- ----------- 筛选 -----------

--[[ 
 * 功能描述: 根据权重筛选
 * @Param obj: table
 * @Param key: 作为权重的Key名称 
 * @ 
 * @Return: 返回随机的index
]]
function GRandOfKeyByWeight(obj, key)
    if #obj == 0 then
        return
    end

    local weight = {}
    local t = 0
    for k, v in ipairs(obj) do
        t = t + v[key]
        weight[k] = t
    end
    if t <= 0 then
        return math.random(1, #weight)
    end
    local c = math.random(1, t)
    for k, v in ipairs(weight) do
        if c <= v then
            return k
        end
    end
    return #weight
end

--[[ 
 * 功能描述: 两者取较大值
 * @Param val1
 * @Param val2 
 * @ 
 * @Return 返回较大的
]]
function max(val1, val2)
    if val1 > val2 then
        return val1
    end
    return val2
end

--[[ 
 * 功能描述: 两者取最小值
 * @Param val1
 * @Param val2 
 * @ 
 * @Return 返回较小的
]]
function min(val1, val2)
    if val1 < val2 then
        return val1
    end
    return val2
end

-- 列表转为发送数据
function GEmptyToData(t)
    if not t or table.empty(t) then
        return nil
    end
    return t
end

-- 列表随机rc一个值
function GListRand(obj)
    if not obj or #obj == 0 then
        return
    end
    local index = math.random(1, #obj)
    return obj[index]
end

--将字符串转换为bool
function GStringToBool(str)
    if str == "true" then
        return true
    end
    return false
end

-- bool 转换成number
function GBoolToNumber(boolean)
    if type(boolean) == "boolean" and boolean then
        return 1
    else
        return 0
    end
end

--时间相关-------
-- Skynet时间(时间戳0.01秒) 如:151716185073
function GGetSkynetTime()
    return math.floor(skynet.time() * 100)
end

--时间戳,秒
function GGetNowTimestamp()
    return os.time()
end

--获取今天是哪一天
function GGetDateDay()
    local t_date = os.date("*t")
    return t_date.day
end

--获取昨天0点时间戳
function GGetYesterdayZeroTimestamp()
    return GUnixtimeToday() - G_TIME.ONE_DAY
end

--获取当天指定时刻时间戳， h:m:s
function GGetTimeTimestamp(str)
    local arr = string.split(str, ":")
    local t_date = os.date("*t")
    return os.time({
        year    = t_date.year,
        month   = t_date.month,
        day     = t_date.day,
        hour    = tonumber(arr[1]),
        min     = tonumber(arr[2]),
        sec     = tonumber(arr[3])
    })
end

--获取明天0点时间戳
function GGetTomorrowZeroTimestamp()
    return GUnixtimeToday() + G_TIME.ONE_DAY
end

--获取星期
function GGetWeekNum()
    local t_date = os.date("*t")
    if t_date.wday == 1 then
        return 7
    end
    return t_date.wday - 1
end

--获取星期一时间戳
function GGetTimestampZeroMonday()
    return GUnixtimeToday() - G_TIME.ONE_DAY * (GGetWeekNum() - 1)
end

--获取下周一时间戳
function GGetNextMondayZeroTimestamp()
    return GUnixtimeToday() + G_TIME.ONE_DAY * (8 - GGetWeekNum())
end

--获取下个月1号的时间戳
function GGetNextMonthFristTimestamp()
    local t_date    = os.date("*t")
    local month     = t_date.month + 1
    local year      = t_date.year

    if month > 12 then
        month   = 1
        year    = year + 1
    end
    
    return os.time({
        year    = year,
        month   = month,
        day     = 1,
        hour    = 0,
        min     = 0,
        sec     = 0
    })
end

--获取昨天的日期
function GGetYesterdayDate()
    local today_time = GUnixtimeToday()
    return os.date("%Y-%m-%d", today_time - 10)
end

--获取某个自定义时间戳
function GGetTimeHmsTimestamp(hour, min, sec)
    return GUnixtimeToday() + hour * 60 * 60 + min * 60 + sec
end

--获取下一个h,m,s时间
function GGetNextDayHMSTimestamp(hour, min, sec)
    local ts = GGetTimeHmsTimestamp(hour, min, sec)
    local now = GGetNowTimestamp()
    if now < ts then
        return ts
    else
        return ts + 86400
    end
end

--diff时间
function GGetTimestampDiffToday(hour, min, sec)
    local UT1 = GGetNextDayHMSTimestamp(hour, min, sec)
    local UT2 = GGetNowTimestamp()
    return UT1 - UT2
end



--获取字符串时间戳
--time_str = "2016-7-18 0:0:0
function GGetTimestampOfStr(time_str)
    local time_str  = string.split(time_str, " ")
    local time_date = string.split(time_str[1], "-")
    local time_time = string.split(time_str[2], ":")

    return os.time({
        year    = tonumber(time_date[1]),
        month   = tonumber(time_date[2]),
        day     = tonumber(time_date[3]),
        hour    = tonumber(time_time[1]),
        min     = tonumber(time_time[2]),
        sec     = tonumber(time_time[3])
    })
end

-- 获取时间戳转成字符串:秒
function GGetTimestampToStr(time)
    return os.date("%Y-%m-%d %H:%M:%S", time)
end

function GGetTimestampToDateStr(time)
    return os.date("%Y-%m-%d", time)
end

-- 检查格式2017-07-01和2017-7-1是否同一天
function GIsSameDate(date1, date2)
    local time_date1 = string.split(date1, "-")
    local time_date2 = string.split(date2, "-")

    return tonumber(time_date1[1]) == tonumber(time_date2[1]) and tonumber(time_date1[2]) == tonumber(time_date2[2]) and tonumber(time_date1[3]) == tonumber(time_date2[3])
end

-- 检查格式date1:"2017-07-02"和今天相比相差天数,<0为比今天早,=0是同一天,>0为未来时间
function GGetDaysCompareToday(date)
    local timestamp = GGetTimestampOfStr(date .. " 0:0:0") or 0
    local temp_day  = GGetYDay(timestamp)
    local now_day   = GGetYDay(GGetNowTimestamp())
    return (temp_day - now_day)
end

-- 检查注册天数/某个时间戳到今天的天数(包括当天).如:2017-7-1到2017-7-2为2天
function GGetCompareDaysForTimestamp(_startTime)
    local now       = GGetNowTimestamp()
    local now_day   = GGetYDay(now)
    return (now_day - GGetYDay(_startTime) + 1)
end

-- 检查格式date1:"2017-07-02"和今天相比相差天数,true为未来时间,false为过去日期
function GUnixtimeCompare(date)
    local timestamp     = GGetTimestampOfStr(date) or 0
    local nowTimestamp  = GGetNowTimestamp()
    return (timestamp > nowTimestamp)
end

-- 获取当前天数（自1970年）
function GGetDayForComputerTime()
    local timestamp     = GGetNowTimestamp()
    return math.floor((timestamp + (8 * 3600)) / (3600 * 24))
end

-- 查找两个日期之间的所有日期
-- date2必须大于等于date1
function GForeachDays(date1, date2, f)
    local date = date1
    local t = GGetTimestampOfStr(date .. " 0:0:0")
    while true do
        f(date)

        if GIsSameDate(date, date2) then
            break
        end
        t = t + 24 * 3600
        date = os.date("%Y-%m-%d", t)
    end
end

-- 
local function split(s, p)
    local rt = {}
    string.gsub(
    s,
    "[^" .. p .. "]+",
    function(w)
        table.insert(rt, w)
    end
    )
    return rt
end


-- 获取路径
function GStripFileName(filename)
    return string.match(filename, "(.+)/[^/]*%.%w+$") --*nix system
end

-- 获取文件名
function GGStripFilePath(filename)
    return string.match(filename, ".+/([^/]*%.%w+)$") -- *nix system
end

-- 去除扩展名
function GGStripFileExtension(filename)
    local idx = filename:match(".+()%.%w+$")
    if (idx) then
        return filename:sub(1, idx - 1)
    else
        return filename
    end
end

-- 获取扩展名
function GGetFileExtension(filename)
    return filename:match(".+%.(%w+)$")
end

-- 取2位小数
function GGet2Decimal(num)
    return math.floor(num * 100 + 0.5) * 0.01
end

-- 取3位小数
function GGet3Decimal(num)
    return math.floor(num * 1000 + 0.5) * 0.001
end

-- 取整数:4舍5入
function GGetFloor(num)
    return math.floor(num + 0.5)
end

--[[
 * 功能描述: 加数器
]]
function GCreatCounter(_count)
    local count = tonumber(_count) or 0;

    return function()
        count = count + 1;
        return count;
    end
end

--[[
 * 功能描述: 区间加数器
]]
function GCreatSectionCounter(_count, _section)
    local count     = tonumber(_count) or 0;
    local section   = tonumber(_section) or 10;

    return function()
        count = (count + 1) % section;
        return count + 1;
    end
end

-- 业务相关

-- 检查用户所属城市是否屏蔽城市: true 是屏蔽，false 是开放
function GCheckCity(city_config, city)
    if city_config and city then
        for _, v in ipairs(city_config) do
            local i = string.find(city, v)
            if i then
                return true
            end
        end
        return false
    end

    return true
end

-- 检查用户渠道是否开放红包功能: true 是开放，false 是屏蔽
function GCheckChannel(channel_config, channel)
    return not channel_config or
    (channel_config.type == 1 and table.include(channel_config.channel, channel)) or
    (channel_config.type == 2 and not table.include(channel_config.channel, channel))
end

--[[ 
 * 功能描述: 检查用户用户群是否开放功能: true 是开放，false 是屏蔽
]]
function CheckUserType(_userTypeConfig, _userType)
    -- 如果是空,对所有玩家开放.
    if not _userTypeConfig or table.empty(_userTypeConfig) or not _userType then
        return true
    end

    -- 用户群是空
    if table.empty(_userType) then
        return false
    end

    -- 判断user ids
    for _, _vUserType in ipairs(_userType) do
        if table.include(_userTypeConfig, _vUserType) then
            -- 已经包含了用户群
            return true
        end
    end
    return false
end

-- 检查用户所属城市是否屏蔽城市: true 是开放，false 是屏蔽
function GCheckCityAndType(city_config, city )
    if city_config and city_config.city and not table.empty(city_config.city) and
    city_config.type and city then

        if city_config.type == 1 then
            return table.include(city_config.city, city)
        elseif city_config.type == 2 then
            return not table.include(city_config.city, city)
        end
        return true
    end

    return true
end


-- 获取当前天数（自1970年）
function GGetDaysFrom1970(timestamp)
    return math.floor((timestamp + (8 * 3600)) / (3600 * 24))
end

-- 
local function GVersionToNumber(version)
    if not version or version == "" then
        return 0
    end

    local arr = split(version, "%.")
    return tonumber(arr[1]) * 100 + tonumber(arr[2]) * 10 + tonumber(arr[3])
end

-- 检查版本是否大于等于指定版本号
function GIsGreaterVersion(version, user_version)
    return GVersionToNumber(user_version) >= GVersionToNumber(version)
end

-- 检查版本是否小于等于指定版本号
function GIsLessVersion(version, user_version)
    return GVersionToNumber(user_version) <= GVersionToNumber(version)
end

-- 检查用户版本号是否开放功能: true 是开放，false 是屏蔽
function GCheckVersion(version_tar, version_cfg)
    if not version_cfg then
        return true
    end
    local version = string.match(version_tar, "%d+.%d+.%d+")
    if version_cfg.type == 1 then --只有这些版本生效
        if not table.member(version_cfg.version, version) then
            return false
        end
    elseif version_cfg.type == 2 then --除了这些版本，其他均生效
        if table.member(version_cfg.version, version) then
            return false
        end
    elseif version_cfg.type == 3 and version_cfg.version[1] then --只能填一个版本,小于等于这个版本才生效
        if not GIsLessVersion(version_cfg.version[1], version) then
            return false
        end
    elseif version_cfg.type == 4 and version_cfg.version[1] then --只能填一个版本,大于等于这个版本才生效
        if not GIsGreaterVersion(version_cfg.version[1], version) then
            return false
        end
    end
    return true
end

-- data: {{3,10},{4,10},{5,10},{6,10},{7,10}}
function getRandomWithWeight(data)
    local weight = {}
    for k, v in pairs(data) do
        table.insert(weight, v[2])
    end
    local index = RandomWithWeight(weight)
    local area = data[index]
    return area[1]
end

--[[ 
 * 功能描述:
 * @Param data: {{3,1,10},{4,1,10},{5,1,10},{6,1,10},{7,1,10}}
 * @Param {10,1,10}: 第三个参数是权重(以后配置最好统一)
 * @ 
 * @Return table
]]
function GGetRandomWithWeightThree(data)
    local weight    = {}

    -- 
    for k, v in pairs(data) do
        table.insert(weight, v[3])
    end

    -- 
    local index     = RandomWithWeight(weight)
    local area      = data[index]
    return area
end


-- data: {{min1,max1,weight1},{min2,max2,weight2},{min3,max3,weight3}}
function GGetRandomWithWeightEx(data)
    local weight = {}
    for k, v in pairs(data) do
        table.insert(weight, v[3])
    end
    local index = RandomWithWeight(weight)
    local min, max = data[index][1], data[index][2]
    return math.random(min, max)
end

function GGetRandomWithWeightKey(data)
    local weight = {}
    for k, v in pairs(data) do
        table.insert(weight, v.weight)
    end
    local index = RandomWithWeight(weight)
    local obj = data[index]
    return obj
end

-- 打印日志信息
function GSkynetError( fmt, ... )
    if not IS_DEBUG then
        return
    end

    --加入行号和文件名
    local str  = string.format( "[%s] LOG->INFO: "..fmt, os.date("%Y-%m-%d %H:%M:%S"), ...)
    -- print(str)
    skynet.error( str )
end

--[[ 
 * 功能描述: 
]]
function GMakeSign(_args)
    if not MD5 then
        MD5 = require "md5"
    end
    local keys  = {}
    for k, _ in pairs(_args) do
        table.insert(keys, k)
    end

    table.sort(keys)
    local argsStr = ""
    for _, v in ipairs(keys) do
        if argsStr == "" then
            argsStr = (v .. "=" .. _args[v])
        else
            argsStr = argsStr .. "&" .. (v .. "=" .. _args[v])
        end
    end
    local sign = MD5.sumhexa(argsStr)
    return sign
end

-- 获取时间戳转成字符串:秒
function GGetTimeToTtr( time )
    return os.date("%H:%M:%S", time)
end

--[[
 * 功能描述: 身份证号获取生日
]]
function GGetBirthdayByIdentity(identity)
    local len       = string.len( identity )
    if len >= 16 then
        local birthdayStr   = string.sub(identity, 7, 14)
        len                 = string.len(birthdayStr)

        if len == 8 then

            local year  = string.sub(birthdayStr, 1, 4)
            local month = string.sub(birthdayStr, 5, 6)
            local day   = string.sub(birthdayStr, 7, 8)
            
            return os.time({
                year    = tonumber(year or 0),
                month   = tonumber(month or 0),
                day     = tonumber(day or 0),
                hour    = 0,
                min     = 0,
                sec     = 0
            })
        end
    end
end

function GBuildAwardConfig(_awardInfo)
    local awards = {}
    for _, value in ipairs(_awardInfo) do

        if value.bid then
            table.insert(awards, {
                bid = value.bid,
                num = value.num or value.count or 0,
            })
        elseif value.id then
            table.insert(awards, {
                bid = value.id,
                num = value.count or value.num or 0,
            })
        else
            local v1, v2    =  table.unpack(value)
            table.insert(awards, {
                bid = v1 or 0,
                num = v2 or 0,
            })
        end
    end

    return awards
end

-- 设置Table的属性,当属性存在才设置,如果属性是Table空的Table不设置.
function GSetDataProperty(_targetData, _sourceData, _property)
    if _sourceData and _targetData and _sourceData[_property] then
        local surData   = _sourceData[_property]
        if type(surData) == "table" then
            if table.nonempty(surData) then
                _targetData[_property]  = surData
            end
        else
            _targetData[_property]      = surData
        end
    end
end

-- 解析客户端版本号
function parse_client_version(client_version)
    if not client_version then return end
    local index = string.find(client_version, "%_")
    if not index then return end
    local h5_version = string.sub(client_version, index+1, string.len(client_version))
    local app_version = string.sub(client_version, 1, index-1)
    return h5_version, app_version
end

-- 打印错误信息
function __GAME_TRACKBACK__(errmsg)
    local trackText    = debug.traceback(tostring(errmsg), 6);
    -- skynet.error("--------- TRACK BACK START ---------");
    skynet.error(trackText, "<<--- LUA ERROR --->>");
    -- skynet.error("--------- TRACK BACK END ---------");
    return false;
end

--[[ 
 * 功能描述: XPCall返回参数处理
]]
function XPCallReutrnFunc(_fucName, _data)
    local reutrnFunc = function(...)
        local ok = ...
        if not ok then
            return {code = 8}
        end
        return select(2, ...)
    end

    -- 
    return reutrnFunc(xpcall(_fucName, __GAME_TRACKBACK__, _data))
end
