-- Доллар/рубль
-- класс
EngineSetting = {}

-- EngineSetting.__index = EngineSetting

-- setmetatable(EngineSetting, {
--     __call = function (cls, ...)
--       local self = setmetatable({}, cls)
--       self:_init(...)
--       return self
--     end,
--   })

function EngineSetting:new()

    local setting = {}

    --- ##### ENGINE ##### ----

    -- сюда перенесены настройки которые необходимы во всём роботе но для каждого инструмента они разные
    -- но от инструмента к инструменту они не меняются
    -- версия продукта 
    setting.version = "2.0.1";

    -- второй минимум
    setting.low_formacia = {}
    
    setting.candle_test = 0

    -- count condles inside graffic
    setting.lenInit = 500


    setting.candle_current_high = 0; -- верхняя граница свечи; для промежутка покупки
    setting.candle_current_low = 0; -- верхняя граница свечи; для промежутка покупки

    setting.old_candle_price_high = 0; -- верхняя граница свечи; для промежутка покупки
    setting.old_candle_price_low = 0; -- верхняя граница свечи; для промежутка покупки

    -- На какой свече была оследняя покупка
    -- это надо для понимания роботом, что покупка была давно
    -- Если покупка была давно, то робот начнёт уменьшать спред последней покупки
    setting.last_buy_candle = 0

    -- открыта, закрыта панель покупок
    setting.show_panel_bue_sell = false;

    setting.use_windows = false;

    -- примерное время работы, пока не используется
    setting.timeWork = {};
    setting.timeWork.start = {'7:00', '14:00'};
    setting.timeWork.lunch = {'14:05', '18:45'};
    setting.timeWork.supper = {'19:00', '23:50'};

    -- status gap
    setting.gap = {}
 
    --  0 - gap start 
    -- 1 - buy OR sell contract 
    -- 2 - closed position 
    setting.gap.phase = 0;

    setting.gap.direct = 'none direct'
    -- разрешено ли использовать такую стратегию торговли
    setting.gap.allowed = true;
    -- цена открытия позиции
    setting.gap.price = 0

    setting.gap.order_num_stop = 0;

    setting.gap.order_num = 0;
    -- тейк профит
    setting.gap.priceProfit = 0
  
    -- следующий шаг для передвижения стопа
    setting.gap.nextPriceStop = 0
    -- где должна быть цена чтобы мы передвинули стоп
    setting.gap.whereIsPriceForStop = 0

    
    setting.gap.timeWork = {}
    -- This morning a gap
    setting.gap.timeWork.start = {700, 710}
 
    setting.cohort2 = {}
 
    --  0 - gap start 
    -- 1 - buy OR sell contract 
    -- 2 - closed position 
    setting.cohort2.phase = 1212
  
    setting.labels = {}
    setting.STOPPRICE = 0
    setting.SPREAD = 0
    setting.STOPPRICE2 = 0 --stopprice2, -- Цена Стоп-Лосса
    -- Здесь сохраняем id лэйблы для стопов
    setting.gap.label = {}
    -- stop
    setting.gap.label.redCircle_stop = 0
    -- take
    setting.gap.label.redCircle_take = 0
    -- next stop
    setting.gap.label.circleBlue_next_stop = 0
    -- next price point
    setting.gap.label.circleYellow_next_price = 0
    -- next price point
    setting.gap.label.take_and_profit_trans_id = 0

    setting.gap.stop = {}

    -- transaction a request. When sent a stop request
    setting.gap.stop.trans_id = 0
    -- transaction get a request. When get number before sent stop a request
    setting.gap.stop.order_num = 0

    -- stop loss trans id
    setting.gap.stop_loss_trans_id = 0
    -- stop loss number
    setting.gap.stop_loss_order_num = 0

    -- объект в котором храниться вся информация об открытой позиции
    setting.gap.data = {};


    setting.cohorten = {}
    setting.cohorten.label = {}
    setting.cohorten.phase = 0
    -- stop
    setting.cohorten.label.redCircle_stop = 0
    -- take
    setting.cohorten.label.redCircle_take = 0
    -- next stop
    setting.cohorten.label.circleBlue_next_stop = 0
    -- next price point
    setting.cohorten.label.circleYellow_next_price = 0
    -- next price point
    setting.cohorten.label.take_and_profit_trans_id = 0

    setting.cohorten.stop = {}

    -- transaction a request. When sent a stop request
    setting.cohorten.stop.trans_id = 0
    -- transaction get a request. When get number before sent stop a request
    setting.cohorten.stop.order_num = 0

    -- stop loss trans id
    setting.cohorten.stop_loss_trans_id = 0
    -- stop loss number
    setting.cohorten.stop_loss_order_num = 0

    -- объект в котором храниться вся информация об открытой позиции
    setting.cohorten.data = {};






    setting.arrGraff = {};

    setting.closed_buy = {
        {'13:00', '14:00'}, {'18:00', '19:02'}, {'22:55', '23:55'}
    };

    -- https://open-broker.ru/pricing-plans/

    -- стоп заявки
    setting.array_stop = {};
    setting.array_stop.work = 0;
    setting.array_stop.order_num = 0;
    setting.array_stop.trans_id = 0;
    setting.array_stop.price = 0;
    setting.array_stop.stop_number = 0;
    -- обновление стопов
    setting.update = true;

    -- минимальная и максимальная цена покупки
    setting.price_min_buy = 0;
    setting.price_max_buy = 0;

    -- обновили максимальную цену, передвигаем стоп, сбрасываем тригер на обновление
    setting.triger_update_up = true;

    setting.comment_quik = 'Robot XoraX';

    -- Использовать стопы или нет, по умолчанию да
    setting.use_stop = false;
    -- Показывать или скрывать панель стопов, по умолчинию скрыта
    setting.show_panel = false;

    -- максимальная цена в заявке
    setting.price_max = 0;
    -- минимальная цена в  заявке
    setting.price_min = 10000000;

    -- количество контрактов в работе
    setting.contract_work = 0;

    -- количество контрактов добавленных трейдером
    setting.contract_add = 0;

    -- минимальная цена контракта на продажу среди установленных заявок
    setting.price_min_sell = 0
    -- максимальная цена контракта на продажу среди установленных заявок
    setting.price_max_sell = 0

    -- минимальная цена купленного ранее контракта
    setting.price_min_buy = 0
    -- максимальная цена купленного ранее контракта
    setting.price_max_buy = 0

    -- подсчёт прибыли, считается после каждой продажи
    setting.profit = 0.00;

    -- текущее время в свече, для внетреннего использования в роботе
    setting.datetime = 0;

    -- режим разработки, используется только для тестирования нового функционала
    setting.developer = true;

    -- кнопка закрытия позиции
    setting.close_positions = false;

    setting.count_buyin_a_row = 0; -- покупок сколько было за торговую сессию
    setting.current_price = 0; -- текщая цена

    -- сколько куплено раз
    setting.count_buy = 0;
    -- сколько продано раз
    setting.count_sell = 0;

    setting.count_contract_buy = 0; -- сколько куплено контрактов за сессию
    setting.count_contract_sell = 0; -- сколько продано контрактов за сессию 

    setting.count_contract = 0; -- сколько продано контрактов за сессию 

    -- тип интервала на свече, обязательный параметр
    setting.INTERVAL = INTERVAL_M1;

    setting.number_of_candles = 0; -- current a candle
    setting.old_number_of_candles = 0; -- old current candle

    setting.number_of_candle_init = true

    -- сработал стоп или нет
    -- если сработал стоп, то другие стопы не передигаем
    -- число отвечающее на сколько отодвинуты стопы от первоначальной версии
    setting.triger_stop = 0;

    -- отвечает за расчёты в свечах
    -- информация по свечам для анализа
    setting.array_candle = {};

    -- На сколько прибавить к свече чтобы закупится ниже профита
    setting.profit_add_candle = 0;
    -- открыта или закрыта панель покупок

    -- максимальная цена в заявке
    setting.price_max = 0;
    -- минимальная цена в  заявке
    setting.price_min = 10000000;

    -- количество контрактов в работе
    setting.contract_work = 0;

    -- количество контрактов добавленных трейдером
    setting.contract_add = 0;

    -- какая последняя покупка была при падении
    setting.SPRED_LONG_TREND_DOWN_LAST_PRICE = 0; -- 
    -- когда следующая покупка при падении
    setting.SPRED_LONG_TREND_DOWN_NEXT_BUY = 0;

    setting.each_to_buy_step = 0; -- сколько подряд раз уже купили

    setting.each_to_buy_status_block = false; -- сколько подряд раз уже купили

    -- Последняя цена сделки по продаже констракта
    setting.SPRED_LONG_LOST_SELL = 0;

    -- Последняя цена сделки по продаже констракта
    setting.SPRED_LONG_LOST_SELL = 0.00;

    -- условия; Выше какого диапазона не покупать(на хаях)
    setting.not_buy_high = 0

    -- условия; ниже  какого диапазона не покупать(на хаях)
    setting.not_buy_low = 0

    -- лимит на покупку ( сколько контрактов купили на текущий момент )
    setting.limit_count_buy = 0

    -- текущее время в свече, для внетреннего использования в роботе
    setting.datetime = 0;

    setting.candles = {}; -- свечи

    -- кнопка запуска
    setting.status = true;
    setting.buy = true;
    setting.sell = true;
    -- таблица заявок, здесь все заявки используемые в работе робота
    setting.sellTable = {};

    -- long = 'buy'
    -- long = 'sell'
    setting.mode = 'buy'

    setting.fractals_collection = {};
    setting.fractal_up = 0;
    setting.fractal_down = 0;


    
    setting.fractals_point_collection = {};
    -- calculate trend
    setting.trendMin = {};
    setting.trendMax = {};
 

    -- на какой свече была последняя операция по входу в рынок
    setting.candles_operation_last = 0;
    setting.range_down_price_candles = 0;

    -- id линии высокой свечки на графике
    setting.line_candle_height_label_id = 0;

    -- id линии низкой свечки на графике
    setting.line_candle_min_label_id = 0;

    -- старые данные на свечке, для сравнения, максимум
    setting.line_candle_height_old = 0;

    -- старые данные на свечке, для сравнения, минимум
    setting.line_candle_min_old = 0;
    -- рисовать полоски максимума и минимума свечей
    setting.line_candle_min_max_show = true;

    -- сколько контрактов для разблокировки надо продать
    setting.each_to_buy_to_block_contract = 0;

    -- сколько продано 
    setting.each_to_sell_to_block_contract = 0

    -- по умолчанию срабатывает запуск скрипта робота
    setting.Run = true
    -- таймаут для того чтобы робот не зависал в цикле
    setting.sleep = 100

    -- are you'll log in data
    setting.log = false

    setting.SEC_PRICE_STEP = 0;

    function EngineSetting:test() return "  EngineSetting:test()" end

    function EngineSetting:CheckBit(flags, _bit)
        if type(flags) ~= "number" then
            loger.save(
                "������!!! Checkbit: 1-� �������� �� �����!")
        end
        if type(_bit) ~= "number" then
            loger.save(
                "������!!! Checkbit: 2-� �������� �� �����!")
        end

        if _bit == 0 then
            _bit = 0x1
        elseif _bit == 1 then
            _bit = 0x2
        elseif _bit == 2 then
            _bit = 0x4
        elseif _bit == 3 then
            _bit = 0x8
        elseif _bit == 4 then
            _bit = 0x10
        elseif _bit == 5 then
            _bit = 0x20
        elseif _bit == 6 then
            _bit = 0x40
        elseif _bit == 7 then
            _bit = 0x80
        elseif _bit == 8 then
            _bit = 0x100
        elseif _bit == 9 then
            _bit = 0x200
        elseif _bit == 10 then
            _bit = 0x400
        elseif _bit == 11 then
            _bit = 0x800
        elseif _bit == 12 then
            _bit = 0x1000
        elseif _bit == 13 then
            _bit = 0x2000
        elseif _bit == 14 then
            _bit = 0x4000
        elseif _bit == 15 then
            _bit = 0x8000
        elseif _bit == 16 then
            _bit = 0x10000
        elseif _bit == 17 then
            _bit = 0x20000
        elseif _bit == 18 then
            _bit = 0x40000
        elseif _bit == 19 then
            _bit = 0x80000
        elseif _bit == 20 then
            _bit = 0x100000
        end

        if bit.band(flags, _bit) == _bit then
            return true
        else
            return false
        end
    end


    function EngineSetting:getTime(datetime)
        
        local hour = datetime.hour

        if datetime.hour < 10 then hour = '0' .. datetime.hour end

        local minute = datetime.min;

        if datetime.min < 10 then  
            minute = '0' .. tostring(datetime.min )
        else
            minute = tostring(datetime.min)
        end
 
        return hour .. ':' .. minute;
    end


    function EngineSetting:getTimeFull(datetime)
        
        local hour = datetime.hour

        if datetime.hour < 10 then hour = '0' .. datetime.hour end

        local minute = datetime.min;

        if datetime.min < 10 then 
             minute = '0' .. datetime.min
            end
 
        return hour .. ':' .. minute;
    end




    setmetatable(setting, self)
    self.__index = self
    return setting

end

return EngineSetting
