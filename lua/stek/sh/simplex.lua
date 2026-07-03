-- 3D Simplex Noise Implementation for Lua 5.1/LuaJIT
-- Based on Stefan Gustavson's implementation
-- By Claude Sonnet 4.5

local SimplexNoise = {}

local grad3 = {
    { 1, 1, 0 }, { -1, 1, 0 }, { 1, -1, 0 }, { -1, -1, 0 },
    { 1, 0, 1 }, { -1, 0, 1 }, { 1, 0, -1 }, { -1, 0, -1 },
    { 0, 1, 1 }, { 0, -1, 1 }, { 0, 1, -1 }, { 0, -1, -1 }
}

local p = {}
local perm = {
    151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 140, 36, 103, 30, 69, 142,
    8, 99, 37, 240, 21, 10, 23, 190, 6, 148, 247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117,
    35, 11, 32, 57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175, 74, 165, 71,
    134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111, 229, 122, 60, 211, 133, 230, 220, 105, 92, 41,
    55, 46, 245, 40, 244, 102, 143, 54, 65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89,
    18, 169, 200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64, 52, 217, 226,
    250, 124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182,
    189, 28, 42, 223, 183, 170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43,
    172, 9, 129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104, 218, 246, 97,
    228, 251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 145, 235, 249, 14, 239,
    107, 49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254,
    138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180
}

for i = 0, 511 do
    p[i] = perm[(i % 256) + 1]
end

local F3 = 1.0 / 3.0
local G3 = 1.0 / 6.0

local function fastfloor(x)
    return x > 0 and math.floor(x) or math.floor(x) - 1
end

local function dot(g, x, y, z)
    return g[1] * x + g[2] * y + g[3] * z
end

function SimplexNoise.noise(xin, yin, zin)
    local n0, n1, n2, n3

    local s = (xin + yin + zin) * F3
    local i = fastfloor(xin + s)
    local j = fastfloor(yin + s)
    local k = fastfloor(zin + s)

    local t = (i + j + k) * G3
    local X0 = i - t
    local Y0 = j - t
    local Z0 = k - t
    local x0 = xin - X0
    local y0 = yin - Y0
    local z0 = zin - Z0

    local i1, j1, k1
    local i2, j2, k2

    if x0 >= y0 then
        if y0 >= z0 then
            i1, j1, k1 = 1, 0, 0
            i2, j2, k2 = 1, 1, 0
        elseif x0 >= z0 then
            i1, j1, k1 = 1, 0, 0
            i2, j2, k2 = 1, 0, 1
        else
            i1, j1, k1 = 0, 0, 1
            i2, j2, k2 = 1, 0, 1
        end
    else
        if y0 < z0 then
            i1, j1, k1 = 0, 0, 1
            i2, j2, k2 = 0, 1, 1
        elseif x0 < z0 then
            i1, j1, k1 = 0, 1, 0
            i2, j2, k2 = 0, 1, 1
        else
            i1, j1, k1 = 0, 1, 0
            i2, j2, k2 = 1, 1, 0
        end
    end

    local x1 = x0 - i1 + G3
    local y1 = y0 - j1 + G3
    local z1 = z0 - k1 + G3
    local x2 = x0 - i2 + 2.0 * G3
    local y2 = y0 - j2 + 2.0 * G3
    local z2 = z0 - k2 + 2.0 * G3
    local x3 = x0 - 1.0 + 3.0 * G3
    local y3 = y0 - 1.0 + 3.0 * G3
    local z3 = z0 - 1.0 + 3.0 * G3

    local ii = i % 256
    local jj = j % 256
    local kk = k % 256
    local gi0 = p[ii + p[jj + p[kk]]] % 12
    local gi1 = p[ii + i1 + p[jj + j1 + p[kk + k1]]] % 12
    local gi2 = p[ii + i2 + p[jj + j2 + p[kk + k2]]] % 12
    local gi3 = p[ii + 1 + p[jj + 1 + p[kk + 1]]] % 12

    local t0 = 0.6 - x0 * x0 - y0 * y0 - z0 * z0
    if t0 < 0 then
        n0 = 0.0
    else
        t0 = t0 * t0
        n0 = t0 * t0 * dot(grad3[gi0 + 1], x0, y0, z0)
    end

    local t1 = 0.6 - x1 * x1 - y1 * y1 - z1 * z1
    if t1 < 0 then
        n1 = 0.0
    else
        t1 = t1 * t1
        n1 = t1 * t1 * dot(grad3[gi1 + 1], x1, y1, z1)
    end

    local t2 = 0.6 - x2 * x2 - y2 * y2 - z2 * z2
    if t2 < 0 then
        n2 = 0.0
    else
        t2 = t2 * t2
        n2 = t2 * t2 * dot(grad3[gi2 + 1], x2, y2, z2)
    end

    local t3 = 0.6 - x3 * x3 - y3 * y3 - z3 * z3
    if t3 < 0 then
        n3 = 0.0
    else
        t3 = t3 * t3
        n3 = t3 * t3 * dot(grad3[gi3 + 1], x3, y3, z3)
    end

    local result = 32.0 * (n0 + n1 + n2 + n3)
    return (result + 1) * 0.5
end

function SimplexNoise.octave(x, y, z, octaves, persistence)
    octaves = octaves or 4
    persistence = persistence or 0.5

    local total = 0
    local frequency = 1
    local amplitude = 1
    local maxValue = 0

    for i = 1, octaves do
        total = total + SimplexNoise.noise(x * frequency, y * frequency, z * frequency) * amplitude
        maxValue = maxValue + amplitude
        amplitude = amplitude * persistence
        frequency = frequency * 2
    end

    return total / maxValue
end

function SimplexNoise.combined(x, y, z, largeScale, smallScale, smallWeight)
    largeScale = largeScale or 50
    smallScale = smallScale or 10
    smallWeight = smallWeight or 0.3

    local largeNoise = SimplexNoise.noise(x / largeScale, y / largeScale, z / largeScale)
    local smallNoise = SimplexNoise.noise(x / smallScale, y / smallScale, z / smallScale)

    return largeNoise * (1 - smallWeight) + smallNoise * smallWeight
end

stek.SimplexNoise = SimplexNoise
