-- свечной анализ графика
-- 
local lineBuyHighClass = dofile(script_path .. "\\modules\\lineBuyHigh.lua")

local Candle = {}

-- перебор графика идёт с право на лево. 
-- Это важно при получении информации о свечках и анализе роботом
-- Время получается именно от сюда

function Candle:new(setting, Log)

    local obj = {}
    obj.Log = Log
    obj.Setting = setting
    obj.start_init = true;
    obj.bigCandle = 0;
    obj.min = 1000000000;
    obj.minDefault = 1000000000;
    obj.max = 0;
    obj.test = 'test';
    obj.lenInit = setting.lenInit
    obj.Initshift = 0

    obj.lineBuyHigh = lineBuyHighClass:new(obj.Setting, obj.Log)
 

    local function calculateVolume(volume) end

    local function calculatePrice(price, datetime) end

    local function calculateSignal(object)
        --   calculateVolume(object.volume)
        --  calculatePrice(object.close, object.datetime) 
    end

    function obj:setRange(range) obj.rangeLocal = rangegetNumCandle end

    function obj:getRange() return obj.rangeLocal; end

    local function initCandle(barCandleLocal)

        if obj.start_init then

            obj.Setting.not_buy_high = obj.Setting.not_buy_high_UP +
                                           barCandleLocal.close;
            
             obj.Setting.datetime = os.date("!*t", os.time())
            --obj.Setting.datetime = barCandleLocal.datetime;
         --   obj.Log:save(tostring(obj.Setting.datetime.hour .. " //datetime  ".. obj.Setting.datetime.min))
         
            obj.lineBuyHigh.updateBuyHigh()

            obj.Setting.not_buy_low = barCandleLocal.close -
                                          obj.Setting.not_buy_low_UP;
            obj.lineBuyHigh.updateBuyLow()
            obj.start_init = false;
        end
    end

    --    local O = t[i].open; -- Получить значение Open для указанной свечи (цена открытия свечи)
    --    local H = t[i].high; -- Получить значение High для указанной свечи (наибольшая цена свечи)
    --    local L = t[i].low; -- Получить значение Low для указанной свечи (наименьшая цена свечи)
    --    local C = t[i].close; -- Получить значение Close для указанной свечи (цена закрытия свечи)
    --    local V = t[i].volume; -- Получить значение Volume для указанной свечи (объем сделок в свече)
    --    local T = t[i].datetime; -- Получить значение datetime для указанной свечи

    local function setArrayCandles(barCandle, numberCandle)

        local localCandle = barCandle;
        localCandle.numberCandle = numberCandle;
        
        if #obj.Setting.array_candle > 0 then

            for candle = 1, #obj.Setting.array_candle do
                -- мы перебираем все свечи и проверяем на свечах уровни

                if obj.Setting.array_candle[candle].numberCandle +
                    obj.Setting.count_of_candle >= numberCandle then
                    -- обновляем высокую цену на текущей свече
                    if barCandle.high <= obj.Setting.array_candle[candle].high then
                        -- проверяем старую свечу
                        if obj.Setting.array_candle[candle].high >= obj.max then
                            obj.max = obj.Setting.array_candle[candle].high;
                        end

                    else
                        -- проверяем текущий максимум
                        if barCandle.high >= obj.max then
                            obj.max = barCandle.high;
                        end
                    end
                    -- текущее закрытие
                    if barCandle.close > obj.max then
                        obj.max = barCandle.close;
                    end

                    if barCandle.low >= obj.Setting.array_candle[candle].low then
                        -- проверяем старую свечу
                        if obj.Setting.array_candle[candle].low <= obj.min then
                            obj.min = obj.Setting.array_candle[candle].low;
                        end

                    else
                        -- проверяем текущий минимум
                        if barCandle.low <= obj.min then
                            obj.min = barCandle.low;
                        end
                    end

                    if barCandle.close < obj.min then
                        obj.min = barCandle.close;
                    end

                else
                    if obj.Setting.candle_test ~=
                        obj.Setting.array_candle[candle].numberCandle then
                        obj.Setting.candle_test =
                            obj.Setting.array_candle[candle].numberCandle;
                    end

                end
                
                if (candle == 1) then
                    -- устанавливаем время, берём из свечей
                    obj.Setting.datetime = obj.Setting.array_candle[candle].datetime
                 end
                    
               
            end

            -- max  = barCandle.high

            if obj.Setting.candle_current_high == 0 then
                obj.Setting.candle_current_high = barCandle.close;
            end

            if obj.max ~= 0 and obj.Setting.candle_current_high ~= obj.max then
                obj.Setting.candle_current_high = obj.max;
                --  control.use_contract_limit();
            end

            if obj.Setting.candle_current_high ~=
                obj.Setting.line_candle_height_old then
                -- обновляем положение максимума
                -- меняем местоположение полоски
                obj.Setting.line_candle_height_old = obj.Setting
                                                         .candle_current_high;
                obj.lineBuyHigh.updateLineCandleMinMax()
            end

            if obj.Setting.candle_current_low == 0 then
                obj.Setting.candle_current_low = barCandle.close;
            end

            if obj.min ~= minDefault and obj.Setting.candle_current_low ~=
                obj.min then
                obj.Setting.candle_current_low = obj.min;
                --  control.use_contract_limit();
            end

            if obj.Setting.candle_current_low ~= obj.Setting.line_candle_min_old then
                -- обновляем положение минимума
                -- меняем местоположение полоски
                obj.Setting.line_candle_min_old = obj.Setting.candle_current_low;
                obj.lineBuyHigh.updateLineCandleMinMax()
            end

            
        --    obj.Log:save('obj.Setting.candle_current_low '.. obj.Setting.candle_current_low )
        ----    obj.Log:save('obj.Setting.candle_current_low '.. obj.Setting.candle_current_high )
       --     obj.Log:save('#obj.Setting.array_candle '.. #obj.Setting.array_candle )

        else

            if obj.Setting.candle_current_high < localCandle.high then
                obj.Setting.candle_current_high = localCandle.high;
            end
 

            if obj.Setting.candle_current_low > localCandle.low then
                obj.Setting.candle_current_low = localCandle.low;
                obj.lineBuyHigh.updateLineCandleMinMax()
            end
            obj.Setting.array_candle[#obj.Setting.array_candle + 1] =
                localCandle;
 
        end  
        --  candleGraff.addSignal(obj.Setting.array_candle); 
    end

    --    local O = t[i].open; -- Получить значение Open для указанной свечи (цена открытия свечи)
    --    local H = t[i].high; -- Получить значение High для указанной свечи (наибольшая цена свечи)
    --    local L = t[i].low; -- Получить значение Low для указанной свечи (наименьшая цена свечи)
    --    local C = t[i].close; -- Получить значение Close для указанной свечи (цена закрытия свечи)
    --    local V = t[i].volume; -- Получить значение Volume для указанной свечи (объем сделок в свече)

    -- вызывается для сигналов
    local function initCandles()

        -- local lenInit = 120
        -- local Initshift = 0
        local currentCandle = getNumCandles(obj.Setting.tag);
        candlesArray, res, legend = getCandlesByIndex(obj.Setting.tag, 0,
                                                      currentCandle - 2 *
                                                          obj.lenInit -
                                                          obj.Initshift,
                                                      2 * obj.lenInit)

        local i = obj.lenInit
        local j = 2 * obj.lenInit

        local first_candle = currentCandle - j - obj.Initshift

        while i >= 1 do

            if candlesArray[j - 1] == nil then

                --  Run = false;
                return;
            end
         
            if candlesArray[j - 1].datetime.hour ~= nil then

                if candlesArray[j - 1].datetime.hour >= 7 then
                    local dt = candlesArray[j - 1].datetime;
                    local bar = candlesArray[j - 1];
                    bar.numberCandle = first_candle + j - 1;
                    obj.Setting.array_candle[#obj.Setting.array_candle + 1] =bar;

                  --  obj.Log:save(tostring(dt.hour .. ":".. dt.min .. '   '..#obj.Setting.array_candle +1  .. " |  ".. bar.close))
         
                    i = i - 1
                end
                j = j - 1
            end
            t = obj.lenInit + 1
        end
        -- candleGraff.addSignal(obj.Setting.array_candle)
    end

    -- логика обновления данных из графика
    local function setBarCandle(bar, collbackFunc)

        bar.numberCandle = obj.Setting.number_of_candle;

        if obj.Setting.old_number_of_candle ~= obj.Setting.number_of_candle then

            obj.Setting.array_candle[#obj.Setting.array_candle + 1] = bar;
            obj.Setting.old_number_of_candle = obj.Setting.number_of_candle;

        else
            -- обновляем бар в таблице
            obj.Setting.array_candle[#obj.Setting.array_candle] = bar;
        end

        setArrayCandles(bar, obj.Setting.number_of_candle);
      
        -- обновляем текущую стоимость
        obj.Setting.current_price = bar.close;
 
      
        --obj.Setting.datetime = bar.datetime;

        calculateSignal(bar);
        if nil ~= collbackFunc then collbackFunc(bar); end
    end

    -- вызывается для сигналов
    function obj:getSignal(collbackFunc)

    

        if obj.Setting.number_of_candle_init then

           -- obj.Setting.datetime = os.date("!*t", os.time())
           -- datetime = obj.Setting.datetime
         --   obj.Log:save(tostring(datetime.hour .. " // os.date  "..datetime.min))
        
            initCandles();
            obj.Setting.number_of_candle_init = false
            return;
        end
        local shift = 0;
        local len = 10

        -- seconds = os.time(datetime); -- в seconds 

        obj.Setting.number_of_candle = getNumCandles(obj.Setting.tag);

        bars_temp, res, legend = getCandlesByIndex(obj.Setting.tag, 0,
                                                   obj.Setting.number_of_candle -
                                                       2 * len - shift, 2 * len)
        -- analyse candles  
        i = len
        j = 2 * len
        while i >= 1 do

            if candlesArray[j - 1] == nil then

                --    Run = false
                return;
            end

            if bars_temp[j - 1].datetime.hour ~= nil then

            --    obj.Setting.datetime = bars_temp[j - 1].datetime;

                 if bars_temp[j - 1].datetime.hour >= 7 then

                    --    loger.save('currentTime 5555 = '.. bars_temp[j - 1].datetime.hour.. ':' .. bars_temp[j - 1].datetime.min); 
                    local bar = bars_temp[j - 1];
                    initCandle(bar);

                    if obj.bigCandle <= i then
                        obj.bigCandle = i;
                        -- чтобы всегда был доступ к текущему времени
                        setBarCandle(bar, collbackFunc);
                    end
                    i = i - 1

                end
                j = j - 1
            end
            t = len + 1
        end
        
                 
    end




    

    -- вызывается при остановке скрипта при кнопке стоп
    function obj:destructor()
        obj.lineBuyHigh.destructor()
    end


    setmetatable(obj, self)
    self.__index = self;
    return obj
end

return Candle
