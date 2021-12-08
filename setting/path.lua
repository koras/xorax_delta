-- local lua51path = "C:\\Program Files (x86)\\Lua\\5.1\\" -- путь, куда установлен дистрибутив Lua 5.1 for Windows

-- package.cpath = "./?.dll;./?51.dll;" .. lua51path .. "?.dll;" .. lua51path ..
--                   "?51.dll;" .. lua51path .. "clibs/?.dll;" .. lua51path ..
--                    "clibs/?51.dll;" .. lua51path .. "loadall.dll;" .. lua51path ..
--                    "clibs/loadall.dll;" .. package.cpath
-- package.path = package.path .. ";./?.lua;" .. lua51path .. "lua/?.lua;" ..
--                   lua51path .. "lua/?/init.lua;" .. lua51path .. "?.lua;" ..
--                   lua51path .. "?/init.lua;" .. lua51path .. "lua/?.luac;"

 local lua54path = "F:\\Lua\\" -- путь, куда установлен дистрибутив Lua 5.1 for Windows

 package.cpath = "./?.dll;./?54.dll;" .. lua54path .. "?.dll;" .. lua54path ..
                   "?54.dll;" .. lua54path .. "clibs/?.dll;" .. lua54path ..
                    "clibs/?54.dll;" .. lua54path .. "loadall.dll;" .. lua54path ..
                    "clibs/loadall.dll;" .. package.cpath
 package.path = package.path .. ";./?.lua;" .. lua54path .. "lua/?.lua;" ..
                   lua54path .. "lua/?/init.lua;" .. lua54path .. "?.lua;" ..
                   lua54path .. "?/init.lua;" .. lua54path .. "lua/?.luac;"

require("table")

setting = {};
stopClass = {};
engine = {};
