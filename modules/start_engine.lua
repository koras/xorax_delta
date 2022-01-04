-- базовые функции, чтобы не переносить с одного файла в другой

  

local LogicClass = dofile(script_path .. "\\modules\\logic.lua")
 


local Engine = {}

function Engine:new(setting , Log)

    -- свойства
    local obj= {}
    obj.Log = Log
    obj.Setting = setting
    obj.Logic = {}
    


    function obj:EngineOnInit()
        -- логика 
        obj.Logic = LogicClass:new(obj.Setting, obj.Log);
        obj.Logic:Init()

    end



    function obj:update() 

    end


    function obj:EngineStop()
        obj.Setting.Run = false
    end 

    
    function obj:eventTranc(price, datetime, levelLocal, event) 

    end

    function obj:EngineOrder(order)
        
    end


    function obj:EngineOnTrade(trade)

        
    end
    

    -- срабатывает при обновлении свечи
    function obj:updateTick( result)

    end

    function obj:EngineMain()
         

        -- получаем график и сигнал
 
        obj.Log:save("start")


       -- panelBids.show(setting)
        -- обновляем 
     
       -- получаем текущую цену из логики
                obj.Logic:getPrice()
 
       -- show controll [anel] 

        while obj.Setting.Run do
    
            obj.Log:save("start 1")

            sleep(obj.Setting.sleep)

          
            -- сработал стоп, проверка 
          
            -- обновление панели статистики
    

            -- fractalSignal.last();
    
            if obj.Setting.status then 

                obj.Log.save("start 2")
                obj.Logic:conditionTimeTrading()
              --  conditionTimeTrading(setting);
        -- старая схема покупок на объёмах
        --        candles.getSignal(setting, updateTick)
            end
        end
         
    end


    -- Функция вызывается терминалом когда с сервера приходит информация по сделке
    function obj:EngineStopOrder(trade)
    
    end
 

    -- Функция вызывается терминалом QUIK при получении новой стоп-заявки или при изменении параметров существующей стоп-заявки (Таблица стоп-заявок).
    --OnStopOrder(stop_order)
    local function EngineTransReply(trans_reply, setting)

    end
    
        setmetatable(obj, self)
        self.__index = self; return obj
end

return Engine