
-- Доллар/рубль
-- script_path = getScriptPath()

 script_path = getScriptPath()

dofile(script_path .. "\\setting\\path.lua");
 

local Setting =  dofile(script_path .. "\\setting\\work_si.lua");
 

local EngineClass = dofile(script_path .. "\\modules\\start_engine_test.lua");
local Loger = dofile(script_path .. "\\engine\\loger.lua");


local Log = Loger:new(Setting);
local Engine = EngineClass:new(Setting, Log);

if (Setting.gap.status) then
    Log:save("-- Setting.gap.status",' start')
end


function OnInit()
    Engine.EngineOnInit()
    
end


function main()
    Engine:EngineMain()
end

-- https://quikluacsharp.ru/quik-qlua/primer-prostogo-torgovogo-dvizhka-simple-engine-qlua-lua/

-- OnTrade shows the statuses of transactions.
-- The function is called by the terminal when information on the request comes from the server
    -- http://luaq.ru/OnOrder.html
function OnOrder(order)
 --  Engine:EngineOrder(order)
end

-- OnTransReply -> OnTrade -> OnOrder 
-- The function is called by the terminal when information on the deal comes from the server
-- Функция вызывается терминалом QUIK при получении сделки или при изменении параметров существующей сделки.
function OnTrade(trade)
  --  Engine:EngineOnTrade(trade)
end
 

-- The function is called by the terminal when information on the deal comes from the server
function OnStopOrder(trade)
  Log:save("--  OnStopOrder".. trade.order_num	)
 
   Engine:EngineStopOrder(trade)
end

 -- @link http://luaq.ru/OnTransReply.html
 -- Функция вызывается терминалом QUIK при получении ответа на транзакцию пользователя

function OnTransReply(trans_reply) 
  --  Engine:EngineTransReply(trans_reply)
end

-- This function is called when the script is stopped
function OnStop()
  Log:save("--  OnStop",' start')
 --   Engine:EngineStop()
end