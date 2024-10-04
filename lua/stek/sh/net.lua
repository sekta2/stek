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

--[[------------------------]]--

local abitTable = {
    {-4, 3},
    {-8, 7},
    {-16, 15},
    {-32, 31},
    {-64, 63},
    {-128, 127},
    {-256, 255},
    {-512, 511},
    {-1024, 1023},
    {-2048, 2047},
    {-4096, 4095},
    {-8192, 8191},
    {-16384, 16383},
    {-32768, 32767},
    {-65536, 65535},
    {-131072, 131071},
    {-262144, 262143},
    {-524288, 524287},
    {-1048576, 1048575},
    {-2097152, 2097151},
    {-4194304, 4194303},
    {-8388608, 8388607},
    {-16777216, 16777215},
    {-33554432, 33554431},
    {-67108864, 67108863},
    {-134217728, 134217727},
    {-268435456, 268435455},
    {-536870912, 536870911},
    {-1073741824, 1073741823},
    {-2147483648, 2147483647}
}

local function checkBitOfNum_INT(num)
    local bitValue = 3

    if num >= 0 then
        for i = 1, #abitTable do
            local bitValue2 = abitTable[i][2]
            if num <= bitValue2 then
                bitValue = i + 3
                break
            end
        end
    else
        for i = 1, #abitTable do
            local bitValue2 = abitTable[i][1]
            if num >= bitValue2 then
                bitValue = i + 3
                break
            end
        end
    end

    return bitValue
end

function net.WriteSmartInt(num)
    local bitValue = checkBitOfNum_INT(num)

    net.WriteUInt(bitValue, 6)
    net.WriteUInt(num, bitValue)
end

function net.ReadSmartInt()
    local bitValue = net.ReadUInt(6)
    return net.ReadInt(bitValue)
end