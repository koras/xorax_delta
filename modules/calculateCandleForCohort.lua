local labelClass = dofile(script_path .. "\\modules\\drawLabel.lua");

local LineBuyHigh = {}

function LineBuyHigh:new(setting, Log)

    -- свойства
    local obj = {}
    obj.Log = Log
    obj.Setting = setting
    -- количество шума между свечами максимум или минимум
 

    obj.points = {} 
 
 
  

    obj.labelIdHigh = 0
    obj.labelIdLow = 0 
    obj.LabelGraff = labelClass:new(obj.Setting, obj.Log)




    function obj:updateBuyHigh()
        obj.LabelGraff:delete(obj.Setting.tag, obj.labelIdHigh);
        obj.labelIdHigh = tonumber(obj.LabelGraff:set('purchase_height',
                                                      obj.Setting.not_buy_high,
                                                      obj.Setting.datetime, 0,
                                                      'Buy high '))
    end

    local defaultMax = 10000000;
    local defaultRange = 7;


    -- template candle
    
    local tmpCandleMax = {};
    local tmpCandleMin = {};

    -- очередь свечей
    local candleMaxQueue = 0;
    local candleMax = 0
    -- высота свечи
    local candleRaundMax = defaultRange;
    -- максимум по отношению к прошлому максимуму
    local candleMaxLast = 0;

 
    -- очередь свечей
    local candleMinQueue = defaultMax;
    local candleMin = defaultMax
    -- высота свечи
    local candleRaundMin = defaultRange;
    -- максимум по отношению к прошлому максимуму
    local candleMinLast = defaultMax; 



    local maxFractal = 0
    local minFractal = defaultMax


    function obj:deleteLabelId(labelId)
        obj.LabelGraff:delete(obj.Setting.tag,labelId)
    end

 
    local function checkLabel(data)
      
        if data.price == defaultMax or data.price == 0 then
            return false
        end 
        
        if #obj.Setting.fractals_point_collection > 0 then 
            for labelCheck = 1, #obj.Setting.fractals_point_collection do
            --    obj.Log:save('==== '..data.price.. ' = ' .. obj.Setting.fractals_point_collection[labelCheck].price.. '==== '..data.dt ..' = '.. obj.Setting.fractals_point_collection[labelCheck].dt )

                if obj.Setting.fractals_point_collection[labelCheck].price == data.price  then
                    return false
                else
                    if obj.Setting.fractals_point_collection[labelCheck].dt == data.dt  then
                        -- delete old fractal 
                        obj:deleteLabelId(obj.Setting.fractals_point_collection[labelCheck].labelId)
                        obj.Setting.labels[labelCheck] = nil
                        obj.Setting.fractals_point_collection[labelCheck] = nil
                        return false
                    end 
                end 
            end
        end
        return true
    end

    local function getMax(candleGraff,candle)
        -- мы перебираем все свечи и проверяем на свечах уровни
      --  local dt = obj.Setting:getTime(candleGraff.datetime)

       -- obj.Log:save(candleGraff.high..' = '.. dt);     
        if candleMaxLast < candleGraff.high and candleMax < candleGraff.high then
            -- Претендент на фрактал 
            --if candleMax < candleGraff.high then
                candleMax = candleGraff.high
                
                candleMaxQueue = 5

                tmpCandleMax = candleGraff;
                local tmpCandleMin = {};

        else

            local dts = obj.Setting:getTime(candleGraff.datetime);
            if candleMaxQueue ~= 0 or  candleMax > candleGraff.high then
                candleMaxQueue = candleMaxQueue - 1 
              --  obj.Log:save(candleMaxQueue .. "|".. candle ..'| '..dts..' price = '.. candleGraff.high)
            end

            if candleMaxQueue == 0 and candleMax ~= 0 then

               -- obj.Log:save( "MAX " ..candleMaxQueue .. "|".. candle ..'| '..dts..' price = '.. candleGraff.high)
                -- есть максимум   
                local f = {}
                f.price = tmpCandleMax.high
                f.datetime = tmpCandleMax.datetime
                f.type = "max"
                f.volume = candleGraff.volume;
                f.dt = obj.Setting:getTime(tmpCandleMax.datetime)
                
            --    candleMax = 0;
                if checkLabel(f) then
                        f.labelId = obj.LabelGraff:set('fractalUp', f.price, f.datetime);
                        obj.Setting.fractals_point_collection[#obj.Setting.fractals_point_collection+1] = f
                end 
            end
        end
        candleMaxLast = candleGraff.high
    end




    local function getMin(candleGraff)
        -- мы перебираем все свечи и проверяем на свечах уровни
        --local dt = obj.Setting:getTime(candleGraff.datetime)
 
        if candleMinLast > candleGraff.low and candleMin > candleGraff.low then
                tmpCandleMin = candleGraff
                candleMin = candleGraff.low 
                candleMinQueue = candleRaundMin
        else
            if candleMinQueue ~= 0 then
                candleMinQueue = candleMinQueue - 1
            end

            if candleMinQueue == 0 and candleMin ~= 0 then
                -- есть максимум   
                f = {}
                f.price = tmpCandleMin.low
                f.datetime = tmpCandleMin.datetime
                f.type = "min"
                f.dt = obj.Setting:getTime(tmpCandleMin.datetime)
                f.volume = tmpCandleMin.volume;

               -- candleMin = defaultMax;
                if checkLabel(f) then
                    f.labelId =  obj.LabelGraff:set('fractalUp', f.price, f.datetime);
               
                    obj.Setting.fractals_point_collection[#obj.Setting.fractals_point_collection+1] = f
                end 
            end
        end
        candleMinLast = candleGraff.low
    end

    --    local O = t[i].open; -- Получить значение Open для указанной свечи (цена открытия свечи)
    --    local H = t[i].high; -- Получить значение High для указанной свечи (наибольшая цена свечи)
    --    local L = t[i].low; -- Получить значение Low для указанной свечи (наименьшая цена свечи)
    --    local C = t[i].close; -- Получить значение Close для указанной свечи (цена закрытия свечи)
    --    local V = t[i].volume; -- Получить значение Volume для указанной свечи (объем сделок в свече)
    --    local T = t[i].datetime; -- Получить значение datetime для указанной свечи

    -- We are always found max and min a fractal
    local function getFractal() 
        obj.Setting.trend = {}

        if #obj.Setting.fractals_point_collection > 0 then
            for candle = 1, #obj.Setting.fractals_point_collection do
                local fractal = obj.Setting.fractals_point_collection[candle];
                
                if(maxFractal < fractal.price) and fractal.type == "max" then
                    maxFractal =  fractal.price 
                    obj.Setting.trend[#obj.Setting.trend+1] = fractal
                 end 

                if minFractal > fractal.price and fractal.type == "min" then 
                    minFractal =  fractal.price
                    obj.Setting.trend[#obj.Setting.trend+1] = fractal
               end
            end 
        end
    end


    function obj:calculate()

      --  obj.Log:save( "#obj.Setting.array_candle " ..#obj.Setting.array_candle)
            

        if #obj.Setting.array_candle > 0 then
            for candle = 1, #obj.Setting.array_candle do
                -- в одну сторону
                getMax(obj.Setting.array_candle[candle],candle)
                getMin(obj.Setting.array_candle[candle])
            end
        end

        --  obj.Setting.fractals_point_collection[#obj.Setting.fractals_point_collection+1] = f
 
        if #obj.Setting.fractals_point_collection > 0 then
            getFractal()
        end
        maxFractal = 0
        minFractal = defaultMax
         
    end

    function obj:updateBuyLow()
        obj.LabelGraff:delete(obj.Setting.tag, obj.labelIdLow);
        obj.labelIdLow = tonumber(obj.LabelGraff:set('purchase_low',
                                                     obj.Setting.not_buy_low,
                                                     obj.Setting.datetime, 0,
                                                     'Buy high '))
    end

    -- обновление максимальной свечи
    -- обновление минимальной свечи
    function obj:updateLineCandleMinMax()
        if obj.Setting.line_candle_min_max_show then

            obj.LabelGraff:delete(obj.Setting.tag,
                                  obj.Setting.line_candle_height_label_id)

            --- lineBuyHigh.lua
            obj.Setting.line_candle_height_label_id = tonumber(
                                                          obj.LabelGraff:set(
                                                              'line_candle_min_max',
                                                              obj.Setting
                                                                  .candle_current_high,
                                                              obj.Setting
                                                                  .datetime, 0,
                                                              'Buy high '))
            obj.LabelGraff:delete(obj.Setting.tag,
                                  obj.Setting.line_candle_min_label_id);
            --- lineBuyHigh.lua
            obj.Setting.line_candle_min_label_id =
                tonumber(obj.LabelGraff:set('line_candle_min_max',
                                            obj.Setting.candle_current_low,
                                            obj.Setting.datetime, 0,
                                            'minimum price'))
        end
    end

    -- вызывается при остановке скрипта при кнопке стоп
    function obj:destructor()
        -- очистка графика от линий
        if #obj.Setting.fractals_point_collection > 0 then 
            for label = 1, #obj.Setting.fractals_point_collection do 
                    obj:deleteLabelId( obj.Setting.fractals_point_collection[label].labelId)
                    obj.Setting.labels[label] = nil
            --    end
            end
        end
    end

    
    setmetatable(obj, self)
    self.__index = self;
    return obj
end

return LineBuyHigh
