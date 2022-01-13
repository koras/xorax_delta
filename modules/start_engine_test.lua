-- базовые функции, чтобы не переносить с одного файла в другой
local LogicClass = dofile(script_path .. "\\modules\\logic_test.lua")
local candleClass = dofile(script_path .. "\\signals\\candle.lua")

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
        obj.candleClass = candleClass:new(obj.Setting, obj.Log)
        obj.Log:clearFile()
    end

    -- срабатывает при обновлении свечи
    function obj:updateTick(setting, result)

        if setting.emulation then
            -- обработка во время эмуляции
            market.callSELL_emulation(setting, result);
            marketGap.tick(setting, result);
            -- сработал стоп в режиме эмуляции
            --  riskStop.appruveOrderStopEmulation(result)
        end

    end

    function obj:update() end

    function obj:EngineStop()
        obj.Setting.Run = false
        obj.candleClass:destructor()
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

        if (sell == 0) then
            obj.Log:save('OnTrade(6)  flag 2')
        end

        if bit.band(trade.flags, 2) == 0 then
            -- direction
            obj.Log:save('OnTrade(5)  flag 2')
            -- market.startContract(trade);

            --    marketGap.executedContract(trade);
        else
            obj.Log:save('OnTrade ')
            obj.Log:save('OnTrade(3)  flag 2')
            --  market.takeExecutedContract(trade);
        end

        if not obj.Setting:CheckBit(trade.flags, 0) and
            not obj.Setting:CheckBit(trade.flags, 1) then

            obj.Log:save('OnTrade(4)  flag 2')
            if bit.band(trade.flags, 2) == 0 then

                obj.Logic:executedContract(trade);

                obj.Log:save('OnTrade(1)  flag 2')
                --   market.startContract(trade);
                --   marketGap.executedContract(trade);
            else
                obj.Log:save('OnTrade(2)  flag 2')
                --   market.takeExecutedContract(trade);
            end
        end

    end

    -- when update a candle
    local function updateTick(result)

       -- obj.Log:save("updateTick  -- when update a candle")
    end

    function obj:EngineMain()

        -- получаем график и сигнал
        obj.candleClass:getSignal(updateTick)

        obj.Log:save("start")

        -- panelBids.show(setting)
        -- обновляем 

        -- получаем текущую цену из логики
        obj.Logic:getPriceStep()

        -- show controll [anel] 
                obj.Logic:secondOperation({})

        while obj.Setting.Run do

            sleep(obj.Setting.sleep)

            -- сработал стоп, проверка 

            -- обновление панели статистики

            -- fractalSignal.last();

            if obj.Setting.status then

                obj.Log.save("start 2")

                 

           --     obj.Logic:conditionTimeTrading()
                --  conditionTimeTrading(setting);
                -- старая схема покупок на объёмах

                obj.candleClass:getSignal(updateTick)
                --        candles.getSignal(setting, updateTick)
            end
        end
    end
 
    -- Функция вызывается терминалом QUIK при получении новой стоп-заявки или при изменении параметров существующей стоп-заявки (Таблица стоп-заявок).
    -- OnStopOrder(stop_order)
    function obj:EngineTransReply(trans_reply)
        obj.Log:save('EngineTransReply trans_rtrans_rtrans_r ' ..
                         trans_reply.trans_id);
        -- loger.save('trans_reply.result_msg ' ..  trans_reply.result_msg );
        obj.Log:save('EngineTransReply order_num ' .. trans_reply.order_num);

    end

    -- Функция вызывается терминалом когда с сервера приходит информация по сделке
    function obj:EngineStopOrder(trade)
        Log:save("-- obj:EngineStopOrder ".. trade.order_num	)
        obj.Logic:EngineStopOrder(trade)

    end

    setmetatable(obj, self)
    self.__index = self;
    return obj
end

return Engine
