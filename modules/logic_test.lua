-- базовая логика
local transactionService = dofile(script_path ..
                                      "\\transaction\\transactionService.lua")

local Logic = {}

-- phase:
-- 1 get a target and direction
-- 2 send stop order or limit

function Logic:new(setting, Log)

    -- свойства
    local obj = {}
    obj.Log = Log
    obj.Setting = setting

    --  function obj:Init()
    --  riskStop.calculateMaxStopStart()
    -- panelBids.CreateNewTableBids()

    function obj:init()
        -- транзакция
        obj.transaction = transactionService:new(obj.Setting, obj.Log);

    end

    local Error = '';
    -- подключаем текущий график
    obj.Log:save('connect curent graff')
    local ds, Error = CreateDataSource(obj.Setting.CLASS_CODE,
                                       obj.Setting.SEC_CODE,
                                       obj.Setting.INTERVAL)

    if Error ~= "" and Error ~= nil then
        message("Error Logic Init: " .. Error)
        return
    end

    GET_GRAFFIC = ds:SetEmptyCallback();

    -- получаем новую стоимость позиции
    -- только при запуске скрипта
    local function getNewPriceForPosition()
        local rangeCost = obj.Setting.instrument_measurement;
        local currentPrice = obj.Setting.current_price
        if (obj.Setting.gap.direct == 'B') then
            obj.Setting.current_price = currentPrice + rangeCost +
                                            obj.Setting.profit_infelicity +
                                            obj.Setting.profit_infelicity;
        end

        if (obj.Setting.gap.direct == 'S') then
            obj.Setting.current_price = currentPrice - rangeCost -
                                            obj.Setting.profit_infelicity -
                                            obj.Setting.profit_infelicity;
        end
        return obj.Setting.current_price
    end

    local function getRand() return tostring(math.random(2000000000)); end

    local function getPriceTakeAndStop(contract)
        local price = 0;
        if tostring(contract.direct) == "B" then
            obj.Setting.gap.priceTake = contract.price +
                                            obj.Setting.gapper.takeProfit
            obj.Setting.gap.priceStop = contract.price -
                                            obj.Setting.gapper.stopLimit
        else
            -- gap down
            obj.Setting.gap.priceTake = contract.price -
                                            obj.Setting.gapper.takeProfit
            obj.Setting.gap.priceStop = contract.price +
                                            obj.Setting.gapper.stopLimit
                                            
        end
        -- Цена Тэйк-Профита
        obj.Setting.STOPPRICE = obj.Setting.gap.priceTake
        -- Цена Стоп-Лосса 
        obj.Setting.STOPPRICE2 =  obj.Setting.gap.priceStop

        obj.Setting.SPREAD = obj.Setting.gapper.stopLimit
        obj.Log:save('New take price = ' .. price)
    end

    local function getDirectionTakeAndStop(contract)
        if tostring(contract.direct) == "B" then
            obj.Setting.gap.directionTake = "S"
        else
            obj.Setting.gap.directionTake = "B"
        end
    end
    -- @link http://luaq.ru/sendTransaction.html
    
    local function getTypeTakeAndStop(contract)
        if obj.Setting.gapper.typeType == "stop" then
            obj.Setting.gapper.typeTypeTake = "TAKE_PROFIT_AND_STOP_LIMIT_ORDER" 
        end
    end
    --   if obj.Setting.emulation then end

    -- @description  второй этап регистрации события
    --  если шорт, то здесь выставляем заявку на покупку, после продажи
    --  лонг, выставляем заявку на продажу, если купили контракт
    -- @param trade
    -- @param contract

    function obj:secondOperation(trade)
        local contract = {}

        contract.price = 75836
        contract.direct = "S"
        
        
        -- ставим лимитку на профит и стоп 
        obj.Setting.gap.phase = 2
        local event = 2;

        obj.Log:save('createTake phase:2 secondOperation')
        getPriceTakeAndStop(contract)

        getDirectionTakeAndStop(contract)

        getTypeTakeAndStop(contract)
        -- генерация trans_id 

        local data = {};
        data.price = obj.Setting.gap.priceTake
        data.direct = obj.Setting.gap.directionTake
        data.datetime = obj.Setting.datetime;
        data.trans_id = getRand();
        data.relation_trans_id = 1111111
        -- сколько контрактов исполнилось
        data.use_contract = 1
        -- type order
        data.type = "NEW_ORDER";
        data.type = obj.Setting.gapper.typeTypeTake
        data.work = true
        data.phase = obj.Setting.gap.phase
        data.executed = false
        data.emulation = obj.Setting.emulation
        data.contract = t1
        data.buy_contract = obj.Setting.gap.priceTake
        obj.Setting.gap.dataTake = data
        obj.Setting.sellTable[(#obj.Setting.sellTable + 1)] = data;

        obj.transaction:send(data.direct, data.type, data.price, data.trans_id,
                             1,  data.phase);

        nextEmulation();

        obj.Log:save('obj.Setting.gap.phase ' .. obj.Setting.gap.phase)
    end

    -- we are checking a position for 
    function obj:executedContract(trade)
        -- сперва находим контракт который (купили|продали) и ставим статус что мы купили контракт
        -- which a phase? 

        obj.Log:save('obj:executedContract ')
        if #obj.Setting.sellTable > 0 then
            for contract = 1, #obj.Setting.sellTable do
                if obj.Setting.sellTable[contract].executed == false and
                    tostring(obj.Setting.sellTable[contract].trans_id) ==
                    tostring(trade.trans_id) then
                    obj.Setting.sellTable[contract].executed = true;
                    -- выставляем на продажу контракт.
                    -- ставим стоп, ибо нехуй деньгами разбрасываться 
                    obj:secondOperation(trade, obj.Setting.sellTable[contract])
                    return;
                end
            end
        end
    end

    function nextEmulation() 
        if obj.Setting.emulation then 
            if obj.Setting.gap.phase == 1 then
                obj.Log:save('obj:nextEmulation 1')
                -- step 1
                -- prepare data for executedContract
                local data = obj.Setting.gap.data
                local trade = {}
                trade.trans_id = data.trans_id
                trade.datetime = data.datetime
                trade.qty = obj.Setting.gapper.use_contract
                trade.order_num = getRand()
                obj:executedContract(trade)
            elseif obj.Setting.gap.phase == 2 then
                -- step 2

                obj.Log:save('obj:nextEmulation 2')



            elseif obj.Setting.gap.phase == 3 then
                -- step 3
            else
                print "The program has been terminated\nThank you!"
            end
        end
    end

    local function openPosition()

        local newPrice = getNewPriceForPosition();
        -- генерация trans_id 
        local trans_id = getRand()
        local event = 1;

        obj.Setting.count_contract = obj.Setting.gapper.use_contract
        local data = {};
        data.price = newPrice
        data.direct = obj.Setting.gapper.direct
        data.datetime = obj.Setting.datetime;
        data.trans_id = trans_id;
        -- сколько контрактов исполнилось 
        data.use_contract = obj.Setting.gapper.use_contract;
        -- type order
        data.type = "NEW_ORDER";
        data.phase = 1
        data.work = true
        data.executed = false
        data.emulation = obj.Setting.emulation
        data.contract = obj.Setting.gapper.use_contract
        data.buy_contract = newPrice -- стоимость продажи
        obj.Setting.gap.data = data
        -- send a order 
        obj.transaction:send(data.direct, data.type, data.price, data.trans_id,
                             obj.Setting.gapper.use_contract, data.phase);
        -- call mode emulation for next step

        obj.Setting.sellTable[(#obj.Setting.sellTable + 1)] = data;

        -- We opened a position

        --   obj.Log:save('addSignal 23')
        --   obj.Log:save('Execution request')
        --  signalShowLog.addSignal(23, false, newPrice);
        --    panelBids.show(setting);
        --      control.use_contract_limit();
    end

    -- получаем направление для торговли в GAP
    local function getDirection()
        obj.Log:save(obj.Setting.current_price .. ' >=   ' ..
                         obj.Setting.array_candle[2].close);

        if (obj.Setting.current_price >= obj.Setting.array_candle[2].close) then

            obj.Setting.gapper.direct = 'B';
        else
            -- short
            obj.Setting.gapper.direct = 'S';
        end

        obj.Log:save('old price = ' .. obj.Setting.array_candle[2].close ..
                         'setting.current_price = ' .. obj.Setting.current_price);
        obj.Log:save('direct = ' .. obj.Setting.gapper.direct)

    end

    --  end
    -- первоначальная логика которая решает как сработает гэп
    function logicGap()
        -- получаем направление для торговли в GAP
        getDirection();
        openPosition()
        obj.Setting.gap.phase = 1
        nextEmulation()

    end

    -- получаем текущий шаг цены
    function obj:getPriceStep()
        obj.Setting.SEC_PRICE_STEP = tostring(getParamEx2(
                                                  obj.Setting.CLASS_CODE,
                                                  obj.Setting.SEC_CODE,
                                                  "SEC_PRICE_STEP").param_value)
        obj.Log:save("Current step price : " .. obj.Setting.SEC_PRICE_STEP)
        if GET_GRAFFIC then
        else
            obj.Setting.Run = false;
        end
    end

    function obj:conditionTimeTrading()
        if (obj.Setting.datetime == 0) then return; end
        local datetime = obj.Setting.datetime;

        --   obj.Log:save('currentTime = '.. setting.datetime.hour.. ':' .. setting.datetime.min);

        local currentTime = datetime.hour .. ':' .. datetime.min;
        local gapTime = obj.Setting.timeWork.start[1];

        currentTime = "7:00";
        --   loger.save('currentTime = '.. setting.datetime.hour.. ':' .. setting.datetime.min);
        --  loger.save('currentTime currentTime = '.. currentTime);
        --     loger.save('gapTime = '.. gapTime)

        -- start traiding day  
        --   if gapTime == currentTime and setting.gap.status then 

        if gapTime == currentTime and obj.Setting.gap.status and
            setting.current_price ~= 0 then

            if obj.Setting.gap.phase == 0 then
                -- find direction
                -- open posit,mion

                obj.Log:save("-- setting.gap.phase == 0")
                -- если время подошло, можно смотреть логику
                logicGap();

                --    obj.Setting.gap.phase = 1;
            end
        else

        end

        if obj.Setting.gap.phase == 2 and obj.Setting.gap.status then
            -- stop traiding

            obj.Log:save("-- setting.gap.phase == 2")
            obj.Setting.gap.status = false
            --  marketGap.logicGap(setting);
        end

        if obj.Setting.gap.phase == 1 and obj.Setting.gap.status then
            --  obj.Log:save("-- setting.gap.phase == 1")
            -- look at closing a position
            -- closed positions 

            --   marketGap.logicGap(setting);
            --   setting.gap.status = false 

        end
    end

    -- вызывается при остановке скрипта при кнопке стоп
    function obj:destructor()
        -- очистка графика от линий 
        -- obj.LabelGraff:delete(obj.Setting.tag, obj.labelIdHigh);
    end


    
    -- стоп заявка установлена 
    function obj:EngineStopOrder(trade)
        if bit.band(trade.flags, 2) == 0 then
            if obj.Setting.gap.order_num_stop == 0 then 
                obj.Setting.gap.phase = 3
                obj.Log:save('EngineStopOrder(1)  flag 2')
            --   market.startContract(trade);
            --   marketGap.executedContract(trade); 
                obj.Setting.gap.order_num_stop = trade.order_num
                obj.Log:save("-- set stop "..trade.order_num)
            end 
        else
            if obj.Setting.gap.order_num_stop  == trade.order_num  then 
               
                obj.Log:save('EngineStopOrder(2)  flag 2')
                obj.Setting.gap.order_num_stop = 0
                obj.Log:save("-- delete stop "..  trade.order_num)
            --   market.takeExecutedContract(trade);
            end 
        end
    end


    setmetatable(obj, self)
    self.__index = self;
    return obj
end

return Logic
