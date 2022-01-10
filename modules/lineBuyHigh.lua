 

local labelClass = dofile(script_path .. "\\modules\\drawLabel.lua");

local LineBuyHigh = {}

function LineBuyHigh:new(setting, Log)

    -- свойства
    local obj = {}
    obj.Log = Log
    obj.Setting = setting
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
