-- scriptTest.lua (in your scripts directory)
local M = {}

local dataLog = getScriptPath() .. "\\log\\dataLog.txt";
local logSignal = getScriptPath() .. "\\log\\EventLog.txt";

local function saveFile(file, text)

    f = io.open(file, "a");
    if f == nil then
        f = io.open(file, "w");
        f:close();
        f = io.open(file, "a");
    end
    f:write(text .. "\n")
    -- Закрывает файл
    f:close();

end

-- I try to open this file
local function save(text) saveFile(dataLog, text) end

-- I try to open this file
local function saveSignal(text) saveFile(logSignal, text) end

M.save = save
M.saveSignal = saveSignal
return M
