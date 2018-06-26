
local _class = {}
function class(classname, supercls, definition)
    local cls = {__cname = classname}

    local superType = type(supercls)
    assert(superType == "nil" or superType == "table" or superType == "function",
        string.format("class() - new class \"%s\" with invalid super class type \"%s\"",
            classname, superType))

    if superType == "table" then
        -- super is pure lua class
        if not cls.super then
            -- set first super pure lua class as class.super
            if supercls then
                cls = setmetatable(cls, {__index = supercls})
            end
            cls.supercls = supercls or nil
        end
    end

    local definitionType = type(definition)
    if definitionType == "table" then
        if not cls.definition then
            cls.definition = definition
           
        end
    end

    if not cls.ctor then
        -- add default constructor
        cls.ctor = function() end
    end
    cls._create = function()
        local instance = {}
        if cls.definition then
            for i,v in pairs(cls.definition) do
                instance[i] = v
            end
        end
        local super_inst = cls.supercls and cls.supercls._create() or nil
        instance = setmetatable(instance, {__index = function (t, k)
            if cls and cls[k] then
                return cls[k]
            end

            if super_inst and super_inst[k] then
                return super_inst[k]
            end
        end})
        instance.super = super_inst
        instance.class = cls
        return instance
    end
    cls.new = function(_, ...)
        local instance = cls._create()
        instance:ctor(...)
        return instance
    end

    return cls
end

local iskindof_
iskindof_ = function(cls, name)
    local __index = rawget(cls, "__index")
    if type(__index) == "table" and rawget(__index, "__cname") == name then return true end

    if rawget(cls, "__cname") == name then return true end
    local super = rawget(cls, "super")
    if not super then return false end
    if iskindof_(super, name) then return true end
    return false
end

function iskindof(obj, classname)
    local t = type(obj)
    if t ~= "table" and t ~= "userdata" then return false end

    local mt
    if t == "userdata" then
        if tolua.iskindof(obj, classname) then return true end
        mt = tolua.getpeer(obj)
    else
        mt = getmetatable(obj)
    end
    if mt then
        return iskindof_(mt, classname)
    end
    return false
end