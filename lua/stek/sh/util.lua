stek_util = {}

function stek_util.set_get_function(tbl, name, key, default)
    tbl["Set" .. name] = function(self, value)
        self[key] = value
    end

    tbl["Set" .. name] = function(self, value)
        return self[key]
    end

    if default ~= nil then
        tbl[key] = default
    end
end

