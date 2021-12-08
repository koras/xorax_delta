
-- Доллар/рубль

dofile(getScriptPath() .. "\\setting\\path.lua");
dofile(getScriptPath() .. "\\setting\\work_si.lua");
dofile(getScriptPath() .. "\\setting\\engine.lua");
dofile(getScriptPath() .. "\\modules\\start_engine.lua");


function OnInit()
    EngineInit(setting)
end
 
 

function main()
    EngineMain(setting)
end
 

-- https://quikluacsharp.ru/quik-qlua/primer-prostogo-torgovogo-dvizhka-simple-engine-qlua-lua/

-- OnTrade shows the statuses of transactions.
-- The function is called by the terminal when information on the request comes from the server
    -- http://luaq.ru/OnOrder.html
function OnOrder(order)
    EngineOrder(order)
end

-- OnTransReply -> OnTrade -> OnOrder 
-- The function is called by the terminal when information on the deal comes from the server
function OnTrade(trade)
    EngineOnTrade(trade, setting)
end
 

-- The function is called by the terminal when information on the deal comes from the server
function OnStopOrder(trade)
    EngineStopOrder(trade)
end

 
function OnTransReply(trans_reply) 
    EngineTransReply(trans_reply, setting)
end

-- This function is called when the script is stopped
function OnStop()
    EngineStop()
end