-- базовые функции, чтобы не переносить с одного файла в другой
local LogicClass = dofile(script_path .. "\\modules\\logic.lua")
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

    local sell = CheckBit(trade.flags, 1);

    if (sell == 0) then end



    if bit.band(trade.flags, 2) == 0 then
        -- direction
       -- market.startContract(trade);
        
    --    marketGap.executedContract(trade);
    else
        obj.Log:save('OnTrade ')
      --  market.takeExecutedContract(trade);
    end

    if not obj.Setting:CheckBit(trade.flags, 0) and not obj.Setting:CheckBit(trade.flags, 1) then

        
        if bit.band(trade.flags, 2) == 0 then

         --   market.startContract(trade);
         --   marketGap.executedContract(trade);
        else
            obj.Log:save(  'OnTrade  flag 2')
         --   market.takeExecutedContract(trade);
        end
    end

    
    end

    -- when update a candle
    local function updateTick(result) end

    function obj:EngineMain()

        -- получаем график и сигнал
        obj.candleClass:getSignal(updateTick)

        obj.Log:save("start")

        -- panelBids.show(setting)
        -- обновляем 

        -- получаем текущую цену из логики
        obj.Logic:getPriceStep()

        -- show controll [anel] 

        while obj.Setting.Run do

            sleep(obj.Setting.sleep)

            -- сработал стоп, проверка 

            -- обновление панели статистики

            -- fractalSignal.last();

            if obj.Setting.status then

                obj.Log.save("start 2")
                obj.Logic:conditionTimeTrading()
                --  conditionTimeTrading(setting);
                -- старая схема покупок на объёмах

                obj.candleClass:getSignal(updateTick)
                --        candles.getSignal(setting, updateTick)
            end
        end
    end

    -- Функция вызывается терминалом когда с сервера приходит информация по сделке
    function obj:EngineStopOrder(trade) end

    -- Функция вызывается терминалом QUIK при получении новой стоп-заявки или при изменении параметров существующей стоп-заявки (Таблица стоп-заявок).
    -- OnStopOrder(stop_order)
    local function EngineTransReply(trans_reply, setting) end

    setmetatable(obj, self)
    self.__index = self;
    return obj
end

return Engine
