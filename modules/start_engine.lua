-- базовые функции, чтобы не переносить с одного файла в другой

local script_path = getScriptPath()

local uTransaction = dofile(script_path .. "\\shop\\transaction_V2.lua")

-- local candles = dofile(script_path .. "\\Signals\\candle.lua")
local loger = dofile(script_path .. "\\engine\\loger.lua");



 

local marketGap = dofile(script_path .. "\\shop\\marketGap.lua")

 
local Run = true;

function update(setting) 

end


function EngineStop()
    Run = false;   
end 

 
function eventTranc(price, datetime, levelLocal, event) 
end

function EngineOrder(order)
    
end


function EngineOnTrade(trade)

    
end
 

-- срабатывает при обновлении свечи
function updateTick(setting, result)

end

function EngineMain(setting)

end


-- Функция вызывается терминалом когда с сервера приходит информация по сделке
function EngineStopOrder(trade)
  
end


function EngineInit(setting)

 
end




-- Функция вызывается терминалом QUIK при получении новой стоп-заявки или при изменении параметров существующей стоп-заявки (Таблица стоп-заявок).
--OnStopOrder(stop_order)
function EngineTransReply(trans_reply, setting)

end


 