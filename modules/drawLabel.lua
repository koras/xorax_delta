local drawLabel = {}

function drawLabel:new(setting, Log)

    -- свойства
    local obj = {}
    obj.Log = Log
    obj.Setting = setting

    local Labels = {}
    obj.label_params = {}
    obj.label_params['TEXT'] = ''

    obj.IMAGE_PATH = ''
    obj.count = 1

    obj.minute = ''
    obj.hour = ''

    obj.path = script_path .. '\\images\\'
 

    local function getPicture(Operation)
    --    obj.Log:save("Operation".. Operation   )
        if Operation == 'B' then
            obj.IMAGE_PATH = obj.path .. 'myDeals_buy1.bmp';
        end

        if Operation == 'S' then
            obj.IMAGE_PATH = obj.path .. 'myDeals_sell1.bmp';
        end

        if Operation == 'sell_stop' then
            obj.IMAGE_PATH = obj.path .. 'sell_stop.bmp';
        end
        if Operation == 'buy_stop' then
            obj.IMAGE_PATH = obj.path .. 'buy_stop.bmp';
        end

        if Operation == 'sell_take' then
            obj.IMAGE_PATH = obj.path .. 'sell_take.bmp';
        end
        if Operation == 'buy_take' then
            obj.IMAGE_PATH = obj.path .. 'buy_take.bmp';
        end

        if Operation == 'redCircle' then
            obj.IMAGE_PATH = obj.path .. 'circle_red.bmp'
        end
        if Operation == 'greenCircle' then
            obj.IMAGE_PATH = obj.path .. 'circle_green.bmp'
        end
        if Operation == 'circleYellow' then
            obj.IMAGE_PATH = obj.path .. 'circle_yellow.bmp'
        end
        if Operation == 'circleBlue' then
            obj.IMAGE_PATH = obj.path .. 'circle_blue.bmp'
        end

        if Operation == 'stop' then
            obj.IMAGE_PATH = obj.path .. 'line_stop.jpeg'
        end
        if Operation == 'purchase_height' then
            obj.IMAGE_PATH = obj.path .. 'purchase_height.jpg'
        end

        if Operation == 'line_candle_min_max' then
            obj.IMAGE_PATH = obj.path .. 'line_candle_height.jpg'
        end

        if Operation == 'purchase_low' then
            obj.IMAGE_PATH = obj.path .. 'purchase_low.jpg'
        end
        if Operation == 'fractalUp' then
            obj.IMAGE_PATH = obj.path .. 'f_ups.bmp'
        end

        obj.label_params['IMAGE_PATH'] = obj.IMAGE_PATH;

    end

    local function getDateGraff(datetime)
        local day = datetime.day;
        if datetime.day < 10 then day = '0' .. datetime.day; end
        local month = datetime.month;
        if datetime.month < 10 then month = '0' .. datetime.month end
        obj.label_params['DATE'] = datetime.year .. month .. day;
    end

    local function getTimeGraff(datetime)
        local hour = datetime.hour;
        if datetime.hour < 10 then hour = '0' .. datetime.hour end
        local minute = datetime.min;
        if datetime.min < 10 then minute = '0' .. datetime.min end
        obj.label_params['TIME'] = hour .. minute .. '00'
    end

    local function setProperty()
        obj.label_params['R'] = 255;
        obj.label_params['G'] = 255;
        obj.label_params['B'] = 0;
        obj.label_params['TRANSPARENCY'] = 0;
        obj.label_params['TRANSPARENT_BACKGROUND'] = 1
        obj.label_params['FONT_FACE_NAME'] = "Webdings"
        obj.label_params['FONT_HEIGHT'] = 14
        obj.label_params['ALIGNMENT'] = 'BOTTOM'
    end

    local function setPrice(price) obj.label_params['YVALUE'] = price end
    local function setHint(textInfo)
        obj.label_params['HINT'] = 'Price ' .. obj.label_params['YVALUE'] ..
                                       " \n " .. textInfo
    end

    function obj:set(Operation, Price, datetime, count, textInfo)

        getPicture(Operation)
        getDateGraff(datetime)
        getTimeGraff(datetime)
        setPrice(Price)
        setProperty()
        setHint('')

        local id = AddLabel(obj.Setting.tag, obj.label_params)
        obj.Setting.labels[#obj.Setting.labels + 1] = id
        return id
    end

    -- удаляем с графика определённыую метку(линию или тэг)
    function obj:create(operation, price, datetime, quantity, textInfo)
        --  setTime(datetime)
        getDateGraff(datetime)
        getTimeGraff(datetime)
        setProperty()
        setPrice(price)
        getPicture(operation)
        setHint(textInfo .. ' ' .. quantity)

        -- message(obj.label_params['DATE']..' - '..obj.label_params['TIME'] )
        local id = AddLabel(obj.Setting.tag, obj.label_params)

        obj.Setting.labels[#obj.Setting.labels + 1] = id
        return id

    end

    -- удаляем с графика определённыую метку(линию или тэг)
    function obj:delete(tag, id) DelLabel(tag, id) end

    function obj:deletePosition(tag, id) 
  
        DelLabel(tag, id)
    end

    function obj:init(tag) obj.Log:save(tag .. ' tag ') end

    setmetatable(obj, self)
    self.__index = self;
    return obj
end

return drawLabel
