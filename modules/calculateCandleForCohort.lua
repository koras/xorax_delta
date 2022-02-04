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

    -- очередь свечей
    local candleMaxQueue = 0;
    local candleMax = 0
    -- высота свечи
    local candleRaundMax = defaultRange;
    local datetimeMax = {};
    -- максимум по отношению к прошлому максимуму
    local candleMaxLast = 0;
    -- last max a candle
    local candleMaxFractal = 0;

 
    -- очередь свечей
    local candleMinQueue = defaultMax;
    local candleMin = defaultMax
    -- высота свечи
    local candleRaundMin = defaultRange;
    local datetimeMin = {};
    -- максимум по отношению к прошлому максимуму
    local candleMinLast = defaultMax;
    -- last minimal a candle
    local candleMinFractal = defaultMax;


    function obj:deleteLabelId(labelId)
        obj.LabelGraff:delete(obj.Setting.tag,labelId)
    end

 
    function checkLabel(data)
      
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
                        obj:deleteLabelId(labelId)
                        obj.Setting.labels[labelCheck] = nil
                        obj.Setting.fractals_point_collection[labelCheck] = nil
                        return false
                    end 
                end 
            end
        end
        return true
    end

    function getMax(candleGraff)
        -- мы перебираем все свечи и проверяем на свечах уровни
        local dt = obj.Setting:getTime(candleGraff.datetime)

       -- obj.Log:save(candleGraff.high..' = '.. dt);     
        if candleMaxLast < candleGraff.high and candleMax < candleGraff.high then
            -- Претендент на фрактал 
            --if candleMax < candleGraff.high then
                candleMax = candleGraff.high
                datetimeMax = candleGraff.datetime
                candleMaxQueue = candleRaundMax


        else

            if candleMaxQueue ~= 0 then
                candleMaxQueue = candleMaxQueue - 1
            end

            if candleMaxQueue == 0 and candleMax ~= 0 then
                -- есть максимум   
                local f = {} 
                candleMaxFractal = candleMax
                f.price = candleMax
                f.datetime = datetimeMax
                f.type = "max"
                f.dt = dt
                
                candleMax = 0;
                if checkLabel(f) then
                        f.labelId = obj.LabelGraff:set('fractalUp', f.price, f.datetime);
                        obj.Setting.fractals_point_collection[#obj.Setting.fractals_point_collection+1] = f
                end
                --   obj.Setting.sellTable[(#obj.Setting.sellTable + 1)] = data;
                -- obj.Setting.fractals_point_collection
            end
        end
        candleMaxLast = candleGraff.high
    end




    function getMin(candleGraff)
        -- мы перебираем все свечи и проверяем на свечах уровни
        local dt = obj.Setting:getTime(candleGraff.datetime)
 
        if candleMinLast > candleGraff.low and candleMin > candleGraff.low then
                candleMin = candleGraff.low
                datetimeMin = candleGraff.datetime
                candleMinQueue = candleRaundMin
               --    obj.Log:save(number .. '  dt '.. candleMin .. '  '.. dt )
           -- else
               -- if candleMinQueue < candleRaundMin then
                --    candleMinQueue = candleMinQueue + 1
            --    end
         --   end

        else

          --  obj.Log:save(candleMinQueue .. '  dt '.. candleMin .. '  '.. dt )
            if candleMinQueue ~= 0 then
                candleMinQueue = candleMinQueue - 1
            end

            if candleMinQueue == 0 and candleMin ~= 0 then
                -- есть максимум   
                local f = {}  

                
                candleMinFractal = candleMin

                f.price = candleMin
                f.datetime = datetimeMin
                f.type = "min"
                f.dt = dt 

                candleMin = defaultMax;
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

    function obj:calculate()
        if #obj.Setting.array_candle > 0 then
            for candle = 1, #obj.Setting.array_candle do
                -- в одну сторону
                getMax(obj.Setting.array_candle[candle])
                getMin(obj.Setting.array_candle[candle]) 
            end
  
        end

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
            --    obj.Log:save('============ LineBuyHigh:destructor')
               -- if (obj.Setting.fractals_point_collection[label] ~= nil) then 
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
