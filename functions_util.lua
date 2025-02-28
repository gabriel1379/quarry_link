function quarry_link.snake_case(this_string)
    this_string = string.lower(this_string)
    this_string = string.gsub(this_string, ' ', '_')

    return this_string
end

function quarry_link.firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function quarry_link.capitalize_firsts(this_string)
    this_string = string.gsub(this_string, '_', ' ')
    local new_string = ''
    for token in string.gmatch(this_string, "[^%s]+") do
        token = quarry_link.firstToUpper(token)
        new_string = new_string..' '..token
    end

    return string.gsub(new_string, ' ', '', 1)
end

function quarry_link.read_block_suffix(base_stone)
    local is_block = string.find(base_stone, "block") or false
    local block_suffix = is_block and "_block" or ""

    return block_suffix
end

function quarry_link.table_flip(t)
    local s={}
    for k,v in pairs(t) do
        s[v]=k
    end
    return s
end
