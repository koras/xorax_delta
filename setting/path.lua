
 local lua54path = "F:\\Lua\\" -- путь, куда установлен дистрибутив Lua 5.* for Windows

 package.cpath = "./?.dll;./?54.dll;" .. lua54path .. "?.dll;" .. lua54path ..
                   "?54.dll;" .. lua54path .. "clibs/?.dll;" .. lua54path ..
                    "clibs/?54.dll;" .. lua54path .. "loadall.dll;" .. lua54path ..
                    "clibs/loadall.dll;" .. package.cpath
 package.path = package.path .. ";./?.lua;" .. lua54path .. "lua/?.lua;" ..
                   lua54path .. "lua/?/init.lua;" .. lua54path .. "?.lua;" ..
                   lua54path .. "?/init.lua;" .. lua54path .. "lua/?.luac;"

require("table")

-- for extand classes
function extended (child, parent)
  --  local child = {}
    setmetatable(child,{__index = parent})
  --  return child
end
 
