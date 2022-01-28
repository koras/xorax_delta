 

local labelClass = dofile(script_path .. "\\modules\\drawLabel.lua");

local LineBuyHigh = {}

function LineBuyHigh:new(setting, Log)

    -- свойства
    local obj = {}
    obj.Log = Log
    obj.Setting = setting
    -- количество шума между свечами максимум или минимум
    obj.range = 50

    obj.points = {}
    obj.points.maxOne = 0
    obj.points.maxOneNum = 0
    obj.points.maxTwo = 0
    obj.points.maxTwoNum = 0

    obj.points.maxTwo = 0
    obj.points.maxThree = 0
    obj.points.maxThreeNum = 0

    obj.points.maxOneDt = {}
    obj.points.maxTwoDt = {}
    obj.points.maxThreeDt = {}

    obj.points.maxOneDtName = 0
    obj.points.maxTwoDtName = 0
    obj.points.maxThreeDtName = 0
     
  
    obj.points.minOne = 100000000
    obj.points.minTwo = 100000000


    obj.labelIdHigh = 0
    obj.labelIdLow = 0
    obj.Logic = {}
    obj.LabelGraff = labelClass:new(obj.Setting, obj.Log)

    function obj:updateBuyHigh()

        obj.LabelGraff:delete(obj.Setting.tag, obj.labelIdHigh);

        obj.labelIdHigh = tonumber(obj.LabelGraff:set('purchase_height',
                                             obj.Setting.not_buy_high,
                                             obj.Setting.datetime, 0,
                                             'Buy high '))
    end
  


    function getMax(number, candleGraff)
            -- мы перебираем все свечи и проверяем на свечах уровни
        local dt =  obj.Setting:getTime(candleGraff.datetime) 
                                --    loger.save('currentTime 5555 = '.. bars_temp[j - 1].datetime.hour.. ':' .. bars_temp[j - 1].datetime.min);     
 
            if obj.points.maxOne <= candleGraff.high then
                obj.points.maxOne = candleGraff.high;
                obj.points.maxOneNum = number
                obj.points.maxOneDt = candleGraff.datetime
                obj.points.maxOneDtName = dt  
           --    obj.Log:save(obj.points.maxOneNum .. ' |1|= obj.points.maxOne '..obj.points.maxOne..'  dt '.. dt )
            end


            if  obj.points.maxOneNum  > number   + obj.range
           -- and  obj.points.maxOneNum - obj.range < number  
             and
          
            obj.points.maxOneNum ~= number
          --  number < obj.points.maxOneNum - obj.range   
             then
           --     obj.Log:save(number .. ' obj.points.maxOneNum + obj.range '..obj.points.maxOneNum + obj.range )
              
                if obj.points.maxTwo <= candleGraff.high then
                    obj.points.maxTwo = candleGraff.high;
                    obj.points.maxTwoNum = number
                    obj.points.maxTwoDt = candleGraff.datetime

                    obj.points.maxTwoDt = candleGraff.datetime
                    obj.points.maxTwoDtName = dt  


                --   obj.Log:save(number .. ' |2|= obj.points.maxTwo '..obj.points.maxTwo..'  dt '.. dt )
                end

            end

    end



    function  getMaxBack(number, candleGraff)

        
      --  obj.Log:save(number ..  '  dt  ' ..obj.points.maxOneNum  .. ' ' )


    -- мы перебираем все свечи и проверяем на свечах уровни
        local dt =  obj.Setting:getTimeFull(candleGraff.datetime) 
                        --    loger.save('currentTime 5555 = '.. bars_temp[j - 1].datetime.hour.. ':' .. bars_temp[j - 1].datetime.min);     
 

        --  obj.Log:save(number .. ' Num '.. setting.lenInit - number .. ' obj.points.maxOneNum ' ..obj.points.maxOneNum     )
      
                        
        local oldNum = obj.Setting.lenInit - number + 1;


     --   obj.Log:save(obj.points.maxOneNum +  obj.range ..  '  '..number  ..  '  dt '..  obj.points.maxOneNum - obj.range .. '   '.. obj.points.maxOneNum )
      --  obj.Log:save( number  ..  '  dt '.. oldNum .. ' ' ..obj.points.maxOneNum  .. ' ' .. obj.points.maxTwoNum)
           

        if 
         obj.points.maxOneNum +  obj.range   <  number    
    -- and  obj.points.maxOneNum - obj.range < number   
        and
    
        obj.points.maxOneNum ~= oldNum   and 
        obj.points.maxTwoNum ~= oldNum
    --  number < obj.points.maxOneNum - obj.range   
        then

            
   --   obj.Log:save( 'number  - obj.range ' .. number  - obj.range  )
    --     obj.Log:save(number .. ' obj.points.maxOneNum + obj.range '..obj.points.maxOneNum + obj.range )
        
            if obj.points.maxThree <= candleGraff.high then
                obj.points.maxThree = candleGraff.high;
                obj.points.maxThreeNum = number
                
                obj.points.maxThreeDt = candleGraff.datetime


                obj.points.maxThreeDt = candleGraff.datetime
                obj.points.maxThreeDtName = dt  


             --   obj.Log:save(obj.Setting.lenInit  ..  '  dt '.. oldNum .. ' ' ..obj.points.maxOneNum  .. ' ' .. oldNum)

             --  obj.Log:save(number .. ' |3|= obj.points.ThreeNum '..obj.points.maxThree..'  dt '.. dt )
            --    obj.Log:save(number .. ' |3|= obj.points.ThreeNum '..obj.points.maxThree..'  dt '.. dt .. '  dt '..  obj.points.maxOneNum + obj.range  )
            end

        end

    end













    function getMin(number, candleGraff)

                    -- мы перебираем все свечи и проверяем на свечах уровни
        local dt =  obj.Setting:getTimeFull(candleGraff.datetime) 
                               

            if obj.points.minOne >= candleGraff.low then
                obj.points.minOne = candleGraff.low;
                obj.points.minOneNum = number
          --      obj.Log:save(obj.points.minOneNum .. ' |1|= obj.points.minOne '..obj.points.minOne..'  dt '.. dt )
            end


            if  obj.points.minOneNum  > number   + obj.range
           -- and  obj.points.maxOneNum - obj.range < number  
             and
          
            obj.points.minOneNum ~= number  then
          --  number < obj.points.maxOneNum - obj.range   
             
           --     obj.Log:save(number .. ' obj.points.maxOneNum + obj.range '..obj.points.maxOneNum + obj.range )
              
                if obj.points.minTwo >= candleGraff.low then
                    obj.points.minTwo = candleGraff.low;
                    obj.points.minTwoNum = number
                --    obj.Log:save(number .. ' |2|= obj.points.minTwo '..obj.points.minTwo..'  dt '.. dt )
                end
            end
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
                getMax(candle, obj.Setting.array_candle[candle])
                getMin(candle, obj.Setting.array_candle[candle])

                -- в другую
                 

               --  obj.Log:save(' num '..#obj.Setting.array_candle - candle )
                -- obj.Log:save('numb '..candle )
              --  local numberBack  = #obj.Setting.array_candle - candle;
               -- getMaxBack(numberBack, obj.Setting.array_candle[candle])

            end
       
            for candle = 1, #obj.Setting.array_candle do 
                -- в другую
                 

               --  obj.Log:save(' num '..#obj.Setting.array_candle - candle )
                -- obj.Log:save('numb '..candle )
                local numberBack  = #obj.Setting.array_candle - candle + 1;
                getMaxBack(numberBack, obj.Setting.array_candle[numberBack])

            end


            obj.LabelGraff:setFractal('fractalUp', obj.points.maxOne, obj.points.maxOneDt);
             if(obj.points.maxOneDtName ~= 0 )then
                
                obj.LabelGraff:setFractal('fractalUp', obj.points.maxOne, obj.points.maxOneDt);
                 obj.Log:save('|1|= obj.points.maxOne '..obj.points.maxOne..'  dt '.. obj.points.maxOneDtName)
                end
                
            if(obj.points.maxTwoDtName ~= 0 )then
                 obj.Log:save('|2|= obj.points.maxTwo '..obj.points.maxTwo..'  dt '.. obj.points.maxTwoDtName)
                end
            if(obj.points.maxThreeDtName ~= 0 )then
             obj.Log:save('|3|= obj.points.ThreeNum '..obj.points.maxThree..'  dt '.. obj.points.maxThreeDtName  )
            end
   
            
         
        end


    end








    function obj:updateBuyLow()
        obj.LabelGraff:delete(obj.Setting.tag, obj.labelIdLow);
        obj.labelIdLow = tonumber(obj.LabelGraff:set('purchase_low',
                                            obj.Setting.not_buy_low,
                                            obj.Setting.datetime, 0, 'Buy high '))
    end

    -- обновление максимальной свечи
    -- обновление минимальной свечи
    function obj:updateLineCandleMinMax()
        if obj.Setting.line_candle_min_max_show then


            obj.LabelGraff:delete(obj.Setting.tag,
                         obj.Setting.line_candle_height_label_id)

            --- lineBuyHigh.lua
            obj.Setting.line_candle_height_label_id =   tonumber(obj.LabelGraff:set( 'line_candle_min_max',obj.Setting.candle_current_high,   obj.Setting.datetime, 0, 'Buy high ')) 
            obj.LabelGraff:delete(obj.Setting.tag, obj.Setting.line_candle_min_label_id);
            --- lineBuyHigh.lua
            obj.Setting.line_candle_min_label_id = tonumber(obj.LabelGraff:set(
                                                            'line_candle_min_max',
                                                            obj.Setting.candle_current_low, obj.Setting.datetime, 0,'minimum price'))
        end
    end

    -- вызывается при остановке скрипта при кнопке стоп
    function obj:destructor()
        -- очистка графика от линий
        obj.Log:save('============ LineBuyHigh:destructor' )

        -- чистим все графики от мусора при остановке робота
        obj.LabelGraff:delete(obj.Setting.tag, obj.labelIdHigh);
        obj.LabelGraff:delete(obj.Setting.tag, obj.Setting.line_candle_height_label_id);
        obj.LabelGraff:delete(obj.Setting.tag, obj.Setting.line_candle_min_label_id);
        obj.LabelGraff:delete(obj.Setting.tag, obj.labelIdLow);

        -- удаляем все лэйблы на графике
        if #obj.Setting.labels > 0 then 
            for label = 1, #obj.Setting.labels do
                if (obj.Setting.labels[label] ~= nil) then
                    obj.LabelGraff:delete(obj.Setting.tag, obj.Setting.labels[label])
                    obj.Setting.labels[label] = nil
                end
            end
        end
    end
    setmetatable(obj, self)
    self.__index = self;
    return obj
end

return LineBuyHigh
