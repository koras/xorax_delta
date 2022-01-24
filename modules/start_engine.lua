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
            --  market.callSELL_emulation(setting, result);
            --  marketGap.tick(setting, result);
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

        if (sell == 0) then obj.Log:save('OnTrade(6)  flag 2') end

        if bit.band(trade.flags, 2) == 0 then
            -- direction
            -- obj.Log:save('OnTrade(5)  flag 2')
            -- market.startContract(trade);

            --    marketGap.executedContract(trade);
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
                --   marketGap.executedContract(trade);
            else
                obj.Log:save('OnTrade(2)  flag 2')
                --   market.takeExecutedContract(trade);
            end
        end

    end

    -- when update a candle
    local function updateTick(candle)
        -- obj.Logic:getPriceStep()
        obj.Logic:tick(candle)
        -- obj.Log:save("updateTick  -- when update a candle")
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

    local function startTime()
 


 
        local timeOS = os.date("%H%M", os.time()) + 0
        -- attempt to compare number with string
        local timeOSsecond = os.date("%S", os.time()) + 0
        local timeStart = obj.Setting.gap.timeWork.start[1]
        local timeFinish = obj.Setting.gap.timeWork.start[2]

        if timeStart <= timeOS and timeOS <= timeFinish then
            obj.Log:save(
                timeStart .. ' timeFinish ' .. timeFinish .. " timeOS " ..
                    timeOS .. " gap " .. timeOSsecond ..
                    "obj.Setting.current_price " .. obj.Setting.current_price)
            return true
        else
            --  obj.Log:save("start 5")
            return false
        end
        --   obj.Log:save(" px= " .. os.date("%H:%M:%S", px) .."\n next_px= " .. os.date("%H:%M:%S", px), 2)
    end

    function obj:EngineMain()

        -- get graffic and price
        obj.candleClass:getSignal(updateTick)

        obj.Log:save("start")

        -- panelBids.show(setting)

        -- get current price from a logic
        obj.Logic:getPriceStep()

        -- show controll [anel] 

        while obj.Setting.Run do

            if stopSleep() then sleep(obj.Setting.sleep) end

            if obj.Setting.status then
                --  obj.Log:save("start 2 ")
                obj.candleClass:getSignal(updateTick)
                -- time for start engine
              --  if startTime() or true then
                if startTime() then
                       obj.Logic:conditionTimeTrading()

                end
            end
        end
    end

    -- Функция вызывается терминалом когда с сервера приходит информация по сделке
    function obj:EngineStopOrder(trade)
        Log:save("-- obj:EngineStopOrder " .. trade.order_num)
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
