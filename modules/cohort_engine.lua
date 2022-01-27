-- базовые функции, чтобы не переносить с одного файла в другой
local LogicClass = dofile(script_path .. "\\modules\\cohort_logic.lua") 

local Engine = {}

function Engine:new(setting, Log)

    -- свойства
    local obj = {}
    obj.Log = Log
    obj.Setting = setting

    function obj:EngineOnInit()
        -- логика  

        obj.Logic = LogicClass:new(obj.Setting, obj.Log)
        obj.Logic:init()
        --  работа с графиком
       -- obj.candleClass = candleClass:new(obj.Setting, obj.Log)
        obj.Log:clearFile()
    end

            -- when update a candle
    function obj:updateTick(candle)
        obj.Logic:tick(candle)
    end


    function obj:update() end

    function obj:EngineStop()
        obj.Setting.Run = false
       -- obj.candleClass:destructor()
        obj.Logic:destructor()
    end

    function obj:eventTranc(price, datetime, levelLocal, event) end

    function obj:EngineOrder(order) end

    -- OnTransReply -> OnTrade -> OnOrder 
    -- The function is called by the terminal when information on the deal comes from the server
    function obj:EngineOnTrade(trade)

        message(trade.order_num)

        obj.Log:save('OnTrade ' .. trade.order_num)

        -- riskStop.updateOrderNumber(trade);

        local sell = obj.Setting:CheckBit(trade.flags, 1);

        if (sell == 0) then obj.Log:save('OnTrade(6)  flag 2') end

        if bit.band(trade.flags, 2) == 0 then
            -- direction
            -- obj.Log:save('OnTrade(5)  flag 2')
            -- market.startContract(trade);

            --    marketcohort.executedContract(trade);
        else
            obj.Log:save('OnTrade ')
            obj.Log:save('OnTrade(3)  flag 2')
            --  market.takeExecutedContract(trade);
        end

        if not obj.Setting:CheckBit(trade.flags, 0) and
            not obj.Setting:CheckBit(trade.flags, 1) then

            --  obj.Log:save('OnTrade(4)  flag 2')
            if bit.band(trade.flags, 2) == 0 then

                obj.Logic:executedContract(trade);

                obj.Log:save('OnTrade(1)  flag 2')
                --   market.startContract(trade);
                --   marketcohort.executedContract(trade);
            else
                obj.Log:save('OnTrade(2)  flag 2')
                --   market.takeExecutedContract(trade);
            end
        end

    end

 

    local function stopSleep()
        local timeOS = os.date("%H:%M", os.time())
        -- attempt to compare number with string
        local timeOSsecond = os.date("%S", os.time()) + 0
        if timeOS == '06:59' and timeOSsecond >= 57 or timeOS == '07:00' and
            timeOSsecond < 5 then
            return false
        else
            return true
        end
    end

 

    function obj:EngineMain()
  

        -- panelBids.show(setting)

        -- get current price from a logic
        obj.Logic:getPriceStep()

        -- show controll [anel] 

        if stopSleep() then sleep(obj.Setting.sleep) end
      
        obj.Log:save("-- obj:EngineStopOrder ".. obj.Setting.cohort.price )
 
     --   if obj.Setting.cohort.allowed then  
                obj.Log:save("-- obj:EngineStopOrder " )
                obj.Logic:conditionTimeTrading()
      --  end
    end

    -- Функция вызывается терминалом когда с сервера приходит информация по сделке
    function obj:EngineStopOrder(trade)
        obj.Log:save("-- obj:EngineStopOrder " .. trade.order_num)
        obj.Logic:EngineStopOrder(trade)

    end

    -- Функция вызывается терминалом QUIK при выставлении новой стоп-заявки или при изменении параметров существующей стоп-заявки (Таблица стоп-заявок).
    -- OnStopOrder(stop_order)
    function obj:EngineTransReply(trans_reply)
        obj.Log:save('startEngine EngineTransReply ' .. trans_reply.trans_id ..
                         '/' .. trans_reply.order_num);

        obj.Logic:EngineTransReply(trans_reply)

    end

    setmetatable(obj, self)
    self.__index = self;
    return obj
end

return Engine
