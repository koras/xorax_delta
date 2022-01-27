 

script_path = getScriptPath()

dofile(script_path .. "\\setting\\path.lua");
 

 obj = {}
obj.Setting =  dofile(script_path .. "\\setting\\work_si.lua");
 
message(obj.Setting.cohort.price);

local Gap = dofile(script_path .. "\\modules\\gap_engine.lua");
local Cohort = dofile(script_path .. "\\modules\\cohort_engine.lua");
local Loger = dofile(script_path .. "\\engine\\loger.lua");

local candleClass = dofile(script_path .. "\\signals\\candle.lua")

 
 

 


function OnInit()
        
    obj.Log = Loger:new(obj.Setting);  
    obj.Log:save("-- obj:EngineStopOrder ".. obj.Setting.cohort.price )
    obj.gap = Gap:new(obj.Setting, obj.Log);
    obj.cohort = Cohort:new(obj.Setting, obj.Log);
    obj.candleClass = candleClass:new(obj.Setting, obj.Log)
    obj.gap.EngineOnInit()
    obj.cohort.EngineOnInit()
    
end

    -- when update a candle
function updateTick(candle)

    obj.gap:updateTick(candle)
    obj.cohort:updateTick(candle)
end

function main()

    obj.Log:save("start")

    obj.candleClass:getSignal(updateTick)
    
    while obj.Setting.Run do 
        
        -- get graffic and price
        obj.candleClass:getSignal(updateTick)

        if obj.Setting.status then
            obj.gap:EngineMain()
            obj.cohort:EngineMain()
        end
    end
end

-- https://quikluacsharp.ru/quik-qlua/primer-prostogo-torgovogo-dvizhka-simple-engine-qlua-lua/

-- OnTrade shows the statuses of transactions.
-- The function is called by the terminal when information on the request comes from the server
    -- http://luaq.ru/OnOrder.html
function OnOrder(order)
    obj.gap:EngineOrder(order)
    obj.cohort:EngineOrder(order)
end

-- OnTransReply -> OnTrade -> OnOrder 
-- The function is called by the terminal when information on the deal comes from the server
-- Функция вызывается терминалом QUIK при получении сделки или при изменении параметров существующей сделки.
function OnTrade(trade)
    obj.gap:EngineOnTrade(trade)
end
 

-- The function is called by the terminal when information on the deal comes from the server
function OnStopOrder(trade)
    obj.gap:EngineStopOrder(trade)
end

 -- @link http://luaq.ru/OnTransReply.html
 -- Функция вызывается терминалом QUIK при получении ответа на транзакцию пользователя

function OnTransReply(trans_reply) 
    obj.gap:EngineTransReply(trans_reply)
end


-- This function is called when the script is stopped
function OnStop()
    obj.gap:EngineStop()
    obj.candleClass:destructor()
end