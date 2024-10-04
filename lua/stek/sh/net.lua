local bitTable = {
    1,
    3,
    7,
    15,
    31,
    63,
    127,
    255,
    511,
    1023,
    2047,
    4095,
    8191,
    16383,
    32767,
    65535,
    131071,
    262143,
    524287,
    1048575,
    2097151,
    4194303,
    8388607,
    16777215,
    33554431,
    67108863,
    134217727,
    268435455,
    536870911,
    1073741823,
    2147483647,
    4294967295
}

local function checkBitOfNum(num)
    local bitValue = 1

    for i = 1, #bitTable do
        local bitValue2 = bitTable[i]
        if num <= bitValue2 then
            bitValue = i
            break
        end
    end

    return bitValue
end

function net.WriteSmartUInt(num)
    local bitValue = checkBitOfNum(num)

    net.WriteUInt(bitValue, 6)
    net.WriteUInt(num, bitValue)
end

function net.ReadSmartUInt()
    local bitValue = net.ReadUInt(6)
    return net.ReadUInt(bitValue)
end