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

    obj.line_candle_min_max = obj.path .. 'line_candle_height.jpg'
    obj.purchase_height = obj.path .. 'purchase_height.jpg'
    obj.purchase_low = obj.path .. 'purchase_low.jpg'

    obj.circleRed = obj.path .. 'circle_red.bmp'
    obj.circleGreen = obj.path .. 'circle_green.bmp'
    obj.circleYellow = obj.path .. 'circle_yellow.bmp'
    obj.circleBlue = obj.path .. 'circle_blue.bmp'
    obj.PicPathSell = obj.path .. 'myDeals_sell'
    obj.PicPathBuy = obj.path .. 'myDeals_buy'
    obj.PicPathSTOP = obj.path .. 'line_stop.jpeg'

    local function getPicture(Operation)

        if Operation == 'B' then
            obj.IMAGE_PATH = obj.PicPathBuy .. obj.count .. '.bmp';
        end

        if Operation == 'S' then
            obj.IMAGE_PATH = obj.PicPathSell .. obj.count .. '.bmp';
        end

        if Operation == 'redCircle' then obj.IMAGE_PATH = obj.circleRed end
        if Operation == 'greenCircle' then
            obj.IMAGE_PATH = obj.circleGreen
        end
        if Operation == 'circleYellow' then
            obj.IMAGE_PATH = obj.circleYellow
        end
        if Operation == 'circleBlue' then
            obj.IMAGE_PATH = obj.circleBlue;
        end

        if Operation == 'stop' then obj.IMAGE_PATH = obj.PicPathSTOP; end
        if Operation == 'purchase_height' then
            obj.IMAGE_PATH = obj.purchase_height
        end

        if Operation == 'line_candle_min_max' then
            obj.IMAGE_PATH = obj.line_candle_min_max
        end

        if Operation == 'purchase_low' then
            obj.IMAGE_PATH = obj.purchase_low
        end

        obj.label_params['IMAGE_PATH'] = obj.IMAGE_PATH;

    end

    local function getImages(Operation)
     
        if Operation == 'B' then
            obj.IMAGE_PATH = obj.PicPathBuy .. obj.count .. '.bmp'
        end

        if Operation == 'S' then
            obj.IMAGE_PATH = obj.PicPathSell .. obj.count .. '.bmp'
        end

        if Operation == 'redCircle' then obj.IMAGE_PATH = obj.circleRed end
        if Operation == 'greenCircle' then
            obj.IMAGE_PATH = obj.circleGreen
        end
        if Operation == 'circleYellow' then
            obj.IMAGE_PATH = obj.circleYellow
        end
        if Operation == 'circleBlue' then obj.IMAGE_PATH = obj.circleBlue end

        if Operation == 'stop' then obj.IMAGE_PATH = obj.PicPathSTOP end
        if Operation == 'purchase_height' then
            obj.IMAGE_PATH = obj.purchase_height
        end

        if Operation == 'line_candle_min_max' then
            obj.IMAGE_PATH = obj.line_candle_min_max
        end

        if Operation == 'purchase_low' then
            obj.IMAGE_PATH = obj.purchase_low
        end
 
        return obj.IMAGE_PATH;
    end

    function obj:set(Operation, Price, datetime, count, textInfo)

        count = 1;

        if (textInfo == nul) then textInfo = ''; end

        obj.hour = datetime.hour;

        if datetime.hour < 10 then obj.hour = '0' .. datetime.hour end

        obj.minute = datetime.min;

        if datetime.min < 10 then obj.minute = '0' .. datetime.min end

        if Operation == "buy" then
            obj.label_params['ALIGNMENT'] = 'BOTTOM';
        else
            obj.label_params['ALIGNMENT'] = 'TOP';
        end

        obj.currentTime = datetime.hour .. ':' .. datetime.min;

        obj.label_params['ALIGNMENT'] = 'BOTTOM';
        obj.label_params['IMAGE_PATH'] = getImages(Operation);

        obj.day = datetime.day;
        if datetime.day < 10 then obj.day = '0' .. datetime.day; end

        obj.month = datetime.month;
        if datetime.month < 10 then obj.month = '0' .. datetime.month end

        obj.label_params['DATE'] = datetime.year .. obj.month .. obj.day
        obj.label_params['TIME'] = obj.hour .. obj.minute .. '00'
        obj.label_params['YVALUE'] = Price
        obj.label_params['R'] = 255
        obj.label_params['G'] = 255
        obj.label_params['B'] = 0
        obj.label_params['TRANSPARENCY'] = 0
        obj.label_params['TRANSPARENT_BACKGROUND'] = 1
        obj.label_params['FONT_FACE_NAME'] = "Webdings"
        obj.label_params['FONT_HEIGHT'] = 14
        obj.label_params['HINT'] = 'Price ' .. Price .. " \n " .. textInfo
        local id = AddLabel(obj.Setting.tag, obj.label_params)
        obj.Setting.labels[#obj.Setting.labels + 1] = id
        return id
    end

    -- устанавливаем время для того чтобы на графике установить
    local function setTime(datetime)
        obj.hour = datetime.hour;
        if datetime.hour < 10 then obj.hour = '0' .. datetime.hour end

        obj.minute = datetime.min;

        if datetime.min < 10 then obj.minute = '0' .. datetime.min end

        obj.day = datetime.day;
        if datetime.day < 10 then obj.day = '0' .. datetime.day; end

        obj.month = datetime.month;
        if datetime.month < 10 then obj.month = '0' .. datetime.month; end

        obj.label_params['DATE'] = datetime.year .. obj.month .. obj.day;
        obj.label_params['TIME'] = obj.hour .. obj.minute .. '00'
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

    -- удаляем с графика определённыую метку(линию или тэг)
    function obj:create(operation, price, datetime, quantity, textInfo)
        setTime(datetime)
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

    function obj:init(tag) obj.Log:save(tag .. ' tag ') end

    setmetatable(obj, self)
    self.__index = self;
    return obj
end

return drawLabel
