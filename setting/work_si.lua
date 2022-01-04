    -- Перед тем чтоб робота перевести робота в боевой режим, посмотрите работу робота XoraX в режиме эмуляции
    -- Следите за объёмом и рисками
    -- Не гонитеь за большими заработками
    -- Удачи...
    -- @xorax <=> @koras
    -- счёт клиента, как вариант его можно узнать в зваяках в таблице заявок
 
 

 

    
-- Доллар/рубль
--класс
 
local EngineSet =    dofile(script_path .. "\\setting\\engine.lua");

local Setting = {}
 
Setting.__index = Setting


 local EngineSetting2 = EngineSet:new()
 setting = {}

 extended(Setting, EngineSetting2)

 setmetatable(Setting, {
    __index = EngineSetting2, -- this is what makes the inheritance work
    __call = function (cls, ...)
      local self = setmetatable({}, cls)
      self:_init(...)
      return self
    end,
  })

function Setting:new()

 
    
  --  local setting = {}
 
    setting.ACCOUNT = '4105F8Y'

    -- класс бумаги. У фьючерсов в основном он одинаков
    setting.CLASS_CODE = "SPBFUT"

    -- код бумаги. Название бумаги разная от месяца к месяцу 
    setting.SEC_CODE = "SiH2"

    -- тег графика, необходимо указывать в том графике из которого робот будет получать данные. 
    -- график нужен в минутном таймфрейме(обязательно)
    setting.tag = "si";
    
    -- пароль для чтения данных
    setting.password = "12345"

    -- токен для записи
    setting.token = "12345" 

    -- тип инструмента, каждый тип имеет свои настройки
    -- 1 фьючерс
    -- 2 акции на moex
    setting.type_instrument = 3;

    -- минимальная прибыль
    setting.profit_range = 100;

    -- минимальная прибыль при больших заявках при торговле веерной продажей
    setting.profit_range_array = 80;
    -- для веерной продажи. Какой промежуток между заявками
    setting.profit_range_array_panel = 20;

    -- изменение  минимальной прибыли в панели
    setting.profit_range_panel = 10;

    -- погрешность, необходимо для предотвращения проскальзывания при активной торговле
    setting.profit_infelicity = 2;

    -- лимит количества заявок на сессию работы робота.
    setting.LIMIT_BID = 10;

    -- сколько использовать контрактов по умолчанию в режиме скальпинга
    setting.use_contract = 1;

    
    setting.gap = {};
    -- сколько использовать контрактов для гэпа
    setting.gap.use_contract = 1;
    -- разрыв цены от открытия позиции
    setting.gap.well_price = 20;
    
    setting.gap.takeProfit = 350;
    setting.gap.stopLimit = 20;
    



    -- включён или выключен режим эмуляции по умолчанию
    setting.emulation = true;

    -- Выставлять контракт на продажу через тейки или лимитки
    -- Если рыно слабо ходит то выгоднее лимитки. Так как при выставлении тейков, продаваться будет ниже, что не выгодно.
    -- по умолчанию стоят тейки
    setting.sell_take_or_limit = true;


    setting.SPRED_LONG_BUY_UP = 2; -- условия; не покупаем если здесь ранее мы купили | вверх диапозон;
    setting.SPRED_LONG_BUY_down = 1; -- условия; не покупаем если здесь ранее мы купили | вниз диапозон

    setting.not_buy_high_UP = 400; -- условия; цена входа при запуске скрипта 
    setting.not_buy_high_change = 30; --  изменения в контрольеой панели

    setting.not_buy_low_UP = 1500; -- условия; цена входа при запуске скрипта 
    setting.not_buy_low_change = 10; --  изменения в контрольеой панели

    setting.take_profit_offset = 10;
    setting.take_profit_spread = 10;

    
    setting.candle_buy_number_down_price = 6; -- сколько свечей должно пройти чтобы отпустить продажу  
    
    setting.fractal_down_range = 5; -- если цена ниже; значит здесб был уровень; а под уровнем не покупаем.
    setting.fractal_candle = 3;
    setting.fractal_under_up = 6; -- под вверхом не покупаем; можем пробить а цена не пойдёт в нашу сторону

    -- сколько нужно подряд купить контрактов при падении рынка
    -- что-бы заблокировать кнопку покупки
    -- +1 покупка, блокировка покупок
    setting.each_to_buy_to_block = 2; -- потом только решение за человеком или пока не будут проданы все позиции


    -- рынок падает, увеличиваем растояние между покупками
    setting.SPRED_LONG_TREND_DOWN = 30;
    setting.SPRED_LONG_TREND_DOWN_SPRED = 40; -- на сколько увеличиваем растояние

    -- рынок падает, увеличиваем растояние между покупками(минимальное число)
    setting.SPRED_LONG_TREND_DOWN_minimal = 10;


    -- минимильное измерение в инструменте 
    setting.instrument_measurement = 1;

    -- расстояние от максимальной покупки
    -- зависимость от используемых контрактов
    setting.spred = 50;
    setting.spred_default = 50;
    -- на сколько исзменять параметр в панели управления
    setting.spred_limit = 11;

    -- увеличение промежутка между стопами
    setting.spred_range = 50;
    setting.spred_range_default = 9;

    -- на сколько исзменять параметр в панели управления
    setting.spred_range_limit = 1;

    -- сколько свечей являются уходящими по тренду для расчёта общей динамики
    setting.candle_range = 10;

    -- какой средний промежуток в цене инструмента считается допустимый при расчёте формации
    setting.candle_price_range = 5; -- для нефти например

    -- какая высота должна быть, для того чтобы понять, текущий уровень высокий или низкий
    -- минимальная высота в цене
    setting.candle_price_max_hight = 5;

    -- минутные свечи. используются для подсчёта 
    setting.count_of_candle = 1;

       

    -- for k, v in pairs(arr) do
    --     print(k, v[1], v[2], v[3])
    -- end
 
    setmetatable(setting, self) 

    function  Setting:test()
    --    return "extended "..Setting.version .. ' Setting:test()' 
    end

    self.__index = self; return setting

end 
  
return Setting:new()