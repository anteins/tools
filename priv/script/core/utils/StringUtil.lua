--[[
-- added by wsh @ 2017-12-18
-- string扩展工具类，对string不支持的功能执行扩展
--]]

local unpack = unpack or table.unpack

-- 字符串分割
-- @split_string：被分割的字符串
-- @pattern：分隔符，可以为模式匹配
-- @init：起始位置
-- @plain：为true禁用pattern模式匹配；为false则开启模式匹配
local function split(split_string, pattern, search_pos_begin, plain)
	assert(type(split_string) == "string")
	assert(type(pattern) == "string" and #pattern > 0)
	search_pos_begin = search_pos_begin or 1
	plain = plain or true
	local split_result = {}

	while true do
		local find_pos_begin, find_pos_end = string.find(split_string, pattern, search_pos_begin, plain)
		if not find_pos_begin then
			break
		end
		local cur_str = ""
		if find_pos_begin > search_pos_begin then
			cur_str = string.sub(split_string, search_pos_begin, find_pos_begin - 1)
		end
		split_result[#split_result + 1] = cur_str
		search_pos_begin = find_pos_end + 1
	end

	if search_pos_begin < string.len(split_string) then
		split_result[#split_result + 1] = string.sub(split_string, search_pos_begin)
	else
		split_result[#split_result + 1] = ""
	end

	return split_result
end

-- 字符串连接
local function join(join_table, joiner)
	if #join_table == 0 then
		return ""
	end

	local fmt = "%s"
	for i = 2, #join_table do
		fmt = fmt .. joiner .. "%s"
	end

	return string.format(fmt, unpack(join_table))
end

-- 是否包含
-- 注意：plain为true时，关闭模式匹配机制，此时函数仅做直接的 “查找子串”的操作
local function contains(target_string, pattern, plain)
	plain = plain or true
	local find_pos_begin, find_pos_end = string.find(target_string, pattern, 1, plain)
	return find_pos_begin ~= nil
end

-- 以某个字符串开始
local function startswith(target_string, start_pattern, plain)
	plain = plain or true
	local find_pos_begin, find_pos_end = string.find(target_string, start_pattern, 1, plain)
	return find_pos_begin == 1
end

-- 以某个字符串结尾
local function endswith(target_string, start_pattern, plain)
	plain = plain or true
	local find_pos_begin, find_pos_end = string.find(target_string, start_pattern, -#start_pattern, plain)
	return find_pos_end == #target_string
end

--判断字符串中 汉字、字母、数字、其他字符 的个数
local function getStringNumCount(content)
    local chineseCount = 0
    local englishCount = 0
    local numberCount = 0
    local otherCount = 0
    local contentArray = string.gmatch(content, ".[\128-\191]*")
    for w in contentArray do   
        local ascii = string.byte(w)
        if (ascii >= 65 and ascii <= 90) or (ascii>=97 and ascii <=122) then
            englishCount = englishCount + 1
        elseif ascii >= 48 and ascii <= 57 then
            numberCount = numberCount + 1
        elseif (ascii >= 0 and ascii <= 47) or (ascii >= 58 and ascii <= 64) or 
            (ascii >= 91 and ascii <= 96) or (ascii >= 123 and ascii <= 127)  then
            otherCount = otherCount + 1
        else
            --ios输入法上可以输入系统表情，而此表情的ascii码值正好在这个区间，所以要用字节数来判断是否是中文
            --226 227 239 240 为ios系统表情的ascii码值
            if string.len(w) == 3 and ascii ~= 226 and ascii ~= 227 and ascii ~= 239 and ascii ~= 240  then
                chineseCount = chineseCount + 1
            else
                otherCount = otherCount + 1
            end
        end
    end
    return chineseCount,englishCount,numberCount,otherCount
end

--判断输入的字符串个数（2个英文字母算一个，1个汉字算一个，如果含特殊字符，返回-1,否则返回正确个数）
local function getStringCount(content)
    local chineseCount,englishCount,numberCount,otherCount = M2.util.getCharCount(content)
    if otherCount > 0 then
        return -1
    else
        local eCount = englishCount / 2
        return chineseCount+eCount+numberCount
    end
end

string.split = split
string.join = join
string.contains = contains
string.startswith = startswith
string.endswith = endswith
string.getStringNumCount = getStringNumCount
string.getStringCount = getStringCount
