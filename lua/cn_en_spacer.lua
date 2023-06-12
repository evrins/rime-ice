-- 为中英混输词条（cn_en.dict.yaml）自动空格
-- 示例：`VIP中P` → `VIP 中 P`
--
-- ChatGPT 写的

local function add_spaces(s)
    -- 在中文字符后和英文字符前插入空格
    s = s:gsub("([\228-\233][\128-\191]-)([%w%p])", "%1 %2")
    -- 在英文字符后和中文字符前插入空格
    s = s:gsub("([%w%p])([\228-\233][\128-\191]-)", "%1 %2")
    return s
end

local function is_mixed_cn_en_num(s)
    -- 检查是否含有中文
    if not s:find("([\228-\233][\128-\191]-)") then
        return false
    end
    -- 检查是否含有英文或数字
    if not s:find("[%a%d]") then
        return false
    end
    return true
end

local function cn_en_spacer(input, env)
    for cand in input:iter() do
        if is_mixed_cn_en_num(cand.text) then
            cand = cand:to_shadow_candidate(cand.type, add_spaces(cand.text), cand.comment)
        end
        yield(cand)
    end
end

return cn_en_spacer
