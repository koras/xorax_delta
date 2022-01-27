
-- Доллар/рубль
-- script_path = getScriptPath()

 script_path = getScriptPath()

dofile(script_path .. "\\setting\\path.lua");
 

local obj = {}
obj.Setting =  dofile(script_path .. "\\setting\\work_si.lua");
 

local EngineClass = dofile(script_path .. "\\modules\\gap_start_engine.lua");
local Loger = dofile(script_path .. "\\engine\\loger.lua");

local candleClass = dofile(script_path .. "\\signals\\candle.lua")

 

obj.Log = Loger:new(obj.Setting);
local Engine = EngineClass:new(obj.Setting, obj.Log);

 


function OnInit()
    
    obj.candleClass = candleClass:new(obj.Setting, obj.Log)
    Engine.EngineOnInit()
    
end

    -- when update a candle
function updateTick(candle)

        Engine:updateTick(candle)
end

function main()

    obj.Log:save("start")

    obj.candleClass:getSignal(updateTick)
    
    while obj.Setting.Run do 
        
        -- get graffic and price
        obj.candleClass:getSignal(updateTick)

        if obj.Setting.status then
            Engine:EngineMain()
        end
    end
end

-- https://quikluacsharp.ru/quik-qlua/primer-prostogo-torgovogo-dvizhka-simple-engine-qlua-lua/

-- OnTrade shows the statuses of transactions.
-- The function is called by the terminal when information on the request comes from the server
    -- http://luaq.ru/OnOrder.html
function OnOrder(order)
    Engine:EngineOrder(order)
end

-- OnTransReply -> OnTrade -> OnOrder 
-- The function is called by the terminal when information on the deal comes from the server
-- Функция вызывается терминалом QUIK при получении сделки или при изменении параметров существующей сделки.
function OnTrade(trade)
    Engine:EngineOnTrade(trade)
end
 

-- The function is called by the terminal when information on the deal comes from the server
function OnStopOrder(trade)
    Engine:EngineStopOrder(trade)
end

 -- @link http://luaq.ru/OnTransReply.html
 -- Функция вызывается терминалом QUIK при получении ответа на транзакцию пользователя

function OnTransReply(trans_reply) 
    Engine:EngineTransReply(trans_reply)
end


-- This function is called when the script is stopped
function OnStop()
    Engine:EngineStop()
    obj.candleClass:destructor()
end