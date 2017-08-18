local middleclass = {
  _VERSION     = 'middleclass X v1.1 - Middleclass v4.1.0 fork by CodingKitsune, original by Enrique García Cota',
  _DESCRIPTION = 'Middleclass fork with many improvements to the original!',
  _URL         = 'https://github.com/kikito/middleclass or https://github.com/codingkitsune/riritools',
  _LICENSE     = [[
    MIT LICENSE

    Copyright (c) 2011 Enrique García Cota

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  ]]
}

local table_utils = require("riritools.lua.table_utils")
local rt_assert = require("riritools.lua.assert")
local rt_json = require("riritools.lua.json")

local setmetatable = setmetatable
local rawget = rawget
local pairs = pairs
local type = type

local classes = {}

local function _createIndexWrapper(aClass, f)
  if f == nil then
    return aClass.__instanceDict
  else
    return function(self, name)
      local value = aClass.__instanceDict[name]

      if value ~= nil then
        return value
      elseif type(f) == "function" then
        return (f(self, name))
      else
        return f[name]
      end
    end
  end
end

local function _propagateInstanceMethod(aClass, name, f)
  f = name == "__index" and _createIndexWrapper(aClass, f) or f
  aClass.__instanceDict[name] = f

  for subclass in pairs(aClass.subclasses) do
    if rawget(subclass.__declaredMethods, name) == nil then
      _propagateInstanceMethod(subclass, name, f)
    end
  end
end

local function _declareInstanceMethod(aClass, name, f)
  aClass.__declaredMethods[name] = f

  if f == nil and aClass.super then
    f = aClass.super.__instanceDict[name]
  end

  _propagateInstanceMethod(aClass, name, f)
end

local function _tostring(self) return "class " .. self.name end
local function _call(self, ...) return self:new(...) end

local function _createClass(name, super)
  local dict = {}
  dict.__index = dict

  local aClass = { name = name, super = super, static = {},
                   __instanceDict = dict, __declaredMethods = {},
                   subclasses = setmetatable({}, {__mode='k'})  }

  if super then
    setmetatable(aClass.static, { __index = function(_,k) return rawget(dict,k) or super.static[k] end })
  else
    setmetatable(aClass.static, { __index = function(_,k) return rawget(dict,k) end })
  end

  setmetatable(aClass, { __index = aClass.static, __tostring = _tostring,
                         __call = _call, __newindex = _declareInstanceMethod })

  return aClass
end

local function _addMethod(aClass, name, method, append_method)
  if (aClass[name]) then
      local old_func = aClass[name]
      if (append_method) then
        aClass[name] = function(...)
          local instance = (...).class
          instance.__appended_return = old_func(...)
          instance.__appended_return = method(...) or instance.__appended_return
          local new_return = instance.__appended_return
          instance.__appended_return = nil
          return new_return
        end
      else
        aClass[name] = function(...)
          local instance = (...).class
          instance.__prepended_return = method(...)
          instance.__prepended_return = old_func(...) or instance.__prepended_return
          local new_return = instance.__prepended_return
          instance.__prepended_return = nil
          return new_return
        end
      end
  else
    aClass[name] = method
  end
end

local function _includeMixin(aClass, mixin)

  local reserved_words = {
    prepended_methods=true,
    appended_methods=true,
    add_only_existing=true,
    included=true,
    static=true,
  }

  for name,method in pairs(mixin) do
    if (not reserved_words[name] and (not mixin.add_only_existing or aClass[name])) then
      aClass[name] = method
    end
  end

  for name,method in pairs(mixin.appended_methods or {}) do
    if (not mixin.add_only_existing or aClass[name]) then
      _addMethod(aClass, name, method, true)
    end
  end

  for name,method in pairs(mixin.prepended_methods or {}) do
    if (not mixin.add_only_existing or aClass[name]) then
      _addMethod(aClass, name, method, false)
    end
  end

  for name,method in pairs(mixin.static or {}) do
    aClass.static[name] = method
  end

  if type(mixin.included)=="function" then mixin:included(aClass) end
  return aClass
end

local DefaultMixin = {
  __initialize   = function() end,

  static = {
    allocate = function(self)
      return setmetatable({ class = self }, self.__instanceDict)
    end,

    new = function(self, ...)
      local instance = self:allocate()
      instance:__initialize(...)
      return instance
    end,

    subclass = function(self, name)
      local subclass = _createClass(name, self)

      for methodName, f in pairs(self.__instanceDict) do
        _propagateInstanceMethod(subclass, methodName, f)
      end
      subclass.__initialize = function(instance, ...) return self.__initialize(instance, ...) end

      self.subclasses[subclass] = true

      return subclass
    end,

    include = function(self, ...)
      rt_assert(type(self) == 'table', "[ERROR] - Make sure that you are using 'Class:include' and not 'Class.include'")
      for _,mixin in ipairs({...}) do _includeMixin(self, mixin) end
      return self
    end
  }
}

middleclass.default_mixin = DefaultMixin

function middleclass.class(name, super)
  rt_assert(type(name) == 'string', "[ERROR] - A name (string) is needed for the new class")
  classes[name] = super and super:subclass(name) or _includeMixin(_createClass(name), DefaultMixin)
  return classes[name]
end

function middleclass.get_class_by_name(name)
  return classes[name]
end

function middleclass.set_table_classes(table)
  if (table.class) then
    classes[table.class].__before_deserialization(table)
  end
  for key, value in pairs(table) do
    local type_v = type(value)
    if (type_v == "string") then
      if (key == "class") then
        table[key] = classes[value]
        setmetatable(table, classes[value].__instanceDict)
      end
    elseif (type_v == "table") then
      middleclass.set_table_classes(value)
    end
  end
  if (table.class) then
    table:__after_deserialization()
  end
  return table
end

local function add_underscore(t, is_class, seen)
  seen = seen or {}
  local new_t
  local key_name
  if (not seen[t]) then
    seen[t] = true
    new_t = {}
    for key, value in pairs(t) do
      key_name = is_class and "__"..key or key
      if (key == "class") then
        new_t.class = value
      elseif (type(value) ~= "table") then
        new_t[key_name] = value
      else
        new_t[key_name] = add_underscore(value, value.class and true or false, seen)
      end
    end
    return new_t
  end
  return t
end

function middleclass.deserialize(json_string, should_add_underscore)
  local new_table
  if (should_add_underscore) then
    new_table = add_underscore(json.decode(json_string))
  else
    new_table = json.decode(json_string)
  end
  return middleclass.set_table_classes(table_utils.sanitize_numbers(new_table))
end

middleclass.mixins = {}

middleclass.mixins.complex_meta = {
  static = {

    __tostring   = function(self) return "instance of " .. tostring(self.class) end,

    isInstanceOf = function(self, aClass)
      return type(aClass) == 'table' and (aClass == self.class or self.class:isSubclassOf(aClass))
    end,

    isSubclassOf = function(self, other)
      return type(other)      == 'table' and
             type(self.super) == 'table' and
             ( self.super == other or self.super:isSubclassOf(other) )
    end,
  }
}

middleclass.mixins.serializable = {

  __before_deserialization = function(self)
  end,

  __after_deserialization = function(self)
  end,

  __before_serialization = function(self)
  end,

  __after_serialization = function(self)
  end,

  serialize_to_table = function(self, remove_underscore, remove_class)
    self:__before_serialization()
    local serializableTable = {}
    local key_name

    for k, v in pairs(self) do
      local type_v = type(v)
      if (type_v ~= "function" and type_v ~= "userdata") then
        if (remove_underscore and type_v == "") then
          key_name = string.gsub(tostring(k), "__", "")
        else
          key_name = tostring(k)
        end
        if (key_name ~= "class" and not (self.class.static.__serialization_blacklist or {})[k]) then
          if (type_v == "table") then
             if (rawget(v, "class") and type(v.class) == "table") then
              serializableTable[key_name] = v:serialize_to_table(remove_underscore, remove_class)
            else
              serializableTable[key_name] = table_utils.serialize_to_table(v, remove_underscore, remove_class)
            end
          else
            serializableTable[key_name] = type_v == "number" and v or tostring(v)
          end
        end
      end
    end
    if (not remove_class) then
      serializableTable.class = tostring(self.class.name)
    end
    self:__after_serialization()
    return serializableTable
  end,

  serialize = function(self, remove_underscore, remove_class)
    return rt_json.encode(self:serialize_to_table(remove_underscore, remove_class))
  end,
}

middleclass.mixins.cloneable = {
  clone = function(self)
    local clone = setmetatable({}, getmetatable(self))
    for k, v in pairs(self) do
      clone[k] = v
    end
    return clone
  end,

  deep_clone = function(self, seen)
    seen = seen or {}
    local clone
    if (self.class) then
      clone = setmetatable({}, getmetatable(self))
    else
      clone = {}
    end
    for k, v in pairs(self) do
      local type_v = type(v)
      if (type_v == "table") then
        if (not seen[v]) then
          seen[v] = true
          if (k == "class") then
            clone[k] = v
          else
            if (v.class) then
              clone[k] = v:deep_clone(seen)
            else
              clone[k] = middleclass.default_mixin.deep_clone(v, seen)
            end
          end
        end
      else
        clone[k] = v
      end
    end
    return clone
  end,
}

setmetatable(middleclass, { __call = function(_, ...) return middleclass.class(...) end })

return middleclass
