---@diagnostic disable: assign-type-mismatch
--- Bits checker

---Возвращает сколько нужно бит для хранения беззнакого целого числа в num
---@param num number
---@return integer
function stek.BitsForUnsignedInt(num)
    if num == 0 then
        return 1
    end

    local log2_n = math.log(num) / math.log(2)
    local bits = math.floor(log2_n) + 1

    return bits
end

---Возвращает сколько нужно бит для хранения целого числа в num
---@param num number
---@return number
function stek.BitsForSignedInt(num)
    local absolute_n = math.abs(num)

    local bits = stek.BitsForUnsignedInt(absolute_n) + 1
    local bits_for_magnitude = stek.BitsForUnsignedInt(absolute_n)

    if num > 0 and (bit.band(num, (num - 1))) == 0 then
        bits = bits_for_magnitude + 1
    elseif num < 0 and (bit.band(absolute_n, (absolute_n - 1))) == 0 and absolute_n ~= 1 then
        bits = bits_for_magnitude
    else
        bits = bits_for_magnitude + 1
    end

    return bits
end

--- LanguageChanged Patcher

LCPatched = LCPatched or false

if not LCPatched then
    LCPatched = true

    local old_LanguageChanged = LanguageChanged
    function LanguageChanged(...)
        hook.Run("LanguageChanged", ...)
        if old_LanguageChanged then old_LanguageChanged(...) end
    end
end
