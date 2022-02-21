
local labelClass = dofile(script_path .. "\\modules\\drawLabel.lua");

local transactionService = {}

-- Cлой отвечающий за реализацию отправку заявок
-- рисует на графике значения при эмуляции
-- Здесь только минимальная логика выбора что надо сделать при эмуляции или боевом режиме
-- @url http://luaq.ru/sendTransaction.html
function transactionService:new(setting, Log)

    local obj = {}
    obj.Log = Log
    obj.Setting = setting
    obj.LabelGraff = labelClass:new(obj.Setting, obj.Log)
    obj.RANDOM_SEED = 1;
    obj.Transaction = {}
    obj.Transaction.CLASSCODE = obj.Setting.CLASS_CODE
    obj.Transaction.SECCODE = obj.Setting.SEC_CODE
    obj.Transaction.ACCOUNT = obj.Setting.ACCOUNT
    obj.Transaction.CLIENT_CODE = obj.Setting.comment_quik
    obj.Transaction.USE_CASE_SENSITIVE_CONSTANTS = 'PROGRAM'
    obj.Transaction.EXPIRY_DATE = "TODAY"
    obj.Transaction.TYPE = 'L' 
    -- Единицы измерения отступа. Возможные значения:«PERCENTS» – в процентах (шаг изменения – одна сотая процента),  «PRICE_UNITS» – в параметрах цены (шаг изменения равен шагу цены по данному инструменту) Используется при «STOP_ORDER_KIND» = «TAKE_PROFIT_STOP_ORDER» или «ACTIVATED_BY_ORDER_TAKE_PROFIT_STOP_ORDER»
    obj.Transaction.OFFSET_UNITS = "PRICE_UNITS"
    obj.Transaction.SPREAD_UNITS = "PRICE_UNITS";
    obj.Transaction.KILL_IF_LINKED_ORDER_PARTLY_FILLED = "NO"
    obj.Transaction.USE_BASE_ORDER_BALANCE = "NO"
    obj.Transaction.ACTIVATE_IF_BASE_ORDER_PARTLY_FILLED = "YES"
    obj.Transaction.OFFSET = tostring(obj.Setting.take_profit_offset)
    obj.Transaction.SPREAD = tostring(obj.Setting.take_profit_spread)

    -- set direction
    local function setDirect(direct)
         obj.Transaction.OPERATION = direct
    end
    -- set type a order
    local function setType(type) 
        if tostring(type) == 'NEW_ORDER' then
          obj.Transaction.ACTION = 'NEW_ORDER'
        end
        if tostring(type) == 'TAKE_PROFIT_AND_STOP_LIMIT_ORDER' then
            -- https://forum.quik.ru/forum10/topic1404/
            
          obj.Transaction.ACTION = 'NEW_STOP_ORDER'
          obj.Transaction.STOP_ORDER_KIND = 'TAKE_PROFIT_AND_STOP_LIMIT_ORDER'
        --  ["STOPPRICE"]           = stopprice, -- Цена Тэйк-Профита
       -- ["EXPIRY_DATE"]         = "TODAY", -- Срок действия стоп-заявки ("GTC" – до отмены,"TODAY" - до окончания текущей торговой сессии, Дата в формате "ГГММДД")
       -- ["SPREAD_UNITS"]        = "PRICE_UNITS", -- Единицы измерения защитного спрэда ("PRICE_UNITS" - шаг цены, или "PERCENTS" - проценты)
       --  ["SPREAD"]              = tostring(100*SEC_PRICE_STEP),
       --["STOPPRICE2"]          = stopprice2, -- Цена Стоп-Лосса
        end 
    end
    -- set current price for a order
    local function setPrice(price)
        obj.Transaction.MARKET_TAKE_PROFIT = "NO"


        if obj.Setting.type_instrument  == 3 then 
            obj.Transaction.PRICE = tostring(math.ceil( obj.Setting.PRICE));
            
        
            if(obj.Transaction.ACTION == 'NEW_STOP_ORDER') then 
          
              --  obj.Log:save(" ==== 2 ")
                obj.Transaction.SPREAD =  tostring(math.ceil(obj.Setting.SPREAD))
                obj.Transaction.STOPPRICE =  tostring(math.ceil( obj.Setting.STOPPRICE))  
                obj.Transaction.STOPPRICE2 = tostring(math.ceil( obj.Setting.STOPPRICE2)) --stopprice2, -- Цена Стоп-Лосса
             --   obj.Log:save("obj.Transaction.SPREAD 1 " ..  obj.Transaction.SPREAD)
             --   obj.Log:save("obj.Transaction.STOPPRICE  1 " ..  obj.Transaction.STOPPRICE )
            --    obj.Log:save(" obj.Transaction.STOPPRICE2  1 " ..   obj.Transaction.STOPPRICE2 )
            --    obj.Log:save(" obj.Transaction.PRICE  " ..    obj.Transaction.PRICE)
            end

        else 
            obj.Transaction.PRICE = tostring( obj.Setting.PRICE);

            if(obj.Transaction.ACTION == 'NEW_STOP_ORDER') then  
 
                obj.Transaction.SPREAD =  tostring(obj.Setting.SPREAD) 
                obj.Transaction.STOPPRICE =  tostring( obj.Setting.STOPPRICE) 
                -- stopprice2, -- Цена Стоп-Лосса 
                obj.Transaction.STOPPRICE2 = tostring( obj.Setting.STOPPRICE2) --stopprice2, -- Цена Стоп-Лосса
             --   obj.Log:save("  obj.Transaction.SPREAD 2 " ..  obj.Transaction.SPREAD)
             --   obj.Log:save("obj.Transaction.STOPPRICE  2 " ..  obj.Transaction.STOPPRICE )
             --   obj.Log:save(" obj.Transaction.STOPPRICE2  2 " ..   obj.Transaction.STOPPRICE2 )
              --  obj.Log:save("obj.Transaction.STOPPRICE2 " ..obj.Transaction.STOPPRICE2)
            end

        end;

  

         
    end
    -- set transaction id for a order
    local function setTransId(transId)
        obj.Transaction.trans_id = transId;
    end

    -- set count contract
    local function setContractsCount(contractsCount)
    --    obj.Log:save("obj.Transaction.contractsCount" .. tostring(contractsCount)) 

        
         contractsCount = tostring(math.ceil( contractsCount)) 
        obj.Log:save("contractsCount " .. contractsCount)
        obj.Transaction.QUANTITY = contractsCount
    end


    -- execute order
    local function executeEmulation(transId)
            -- mode edulation
            --message('transactionService:send')
            -- данные собраны по ходу формирования транкзакции
            -- ставим метку
            local price = obj.Transaction.PRICE 
            local datetime = obj.Setting.datetime
            local text ='create new position for label '

            if tostring(obj.Transaction.ACTION) == 'NEW_ORDER' then
              obj.LabelGraff:create(obj.Transaction.OPERATION, price, datetime, obj.Transaction.QUANTITY, text)
            end 
            
            if  obj.Transaction.ACTION == 'NEW_STOP_ORDER' then 
          
                if  obj.Transaction.OPERATION == "B" then 
                    obj.LabelGraff:create('sell_stop', obj.Transaction.STOPPRICE2 , datetime, obj.Transaction.QUANTITY, text)
                    obj.LabelGraff:create('sell_take', obj.Transaction.STOPPRICE , datetime, obj.Transaction.QUANTITY, text)
                else 
                    obj.LabelGraff:create('buy_stop', obj.Transaction.STOPPRICE2 , datetime, obj.Transaction.QUANTITY, text)
                    obj.LabelGraff:create('buy_take', obj.Transaction.STOPPRICE , datetime, obj.Transaction.QUANTITY, text)
                end
         --   obj.Setting.labelsTransaction[#obj.Setting.labelsTransaction + 1] = labelId;
            end 

            
            if  obj.Transaction.ACTION == "KILL_STOP_ORDER" then 
                 obj.LabelGraff:create('delete_stop', obj.Transaction.STOPPRICE2 , datetime, obj.Transaction.QUANTITY, 'delete')
            end 
             
    end

    -- execute order
    local function execute(transId)
        if obj.Setting.emulation then
            executeEmulation(transId)
           -- set(Operation, Price, datetime, count, textInfo)
        else
            -- http://luaq.ru/sendTransaction.html
           
          --  obj.Log:save("obj.Transaction.PRICE " .. obj.Transaction.PRICE)
          --  obj.Log:save("obj.Transaction.QUANTITY" .. obj.Transaction.QUANTITY)
           -- obj.Log:save("obj.Transaction.OPERATION" .. obj.Transaction.OPERATION)
       
         --  local QUANTITY = tostring(math.ceil( obj.Transaction.QUANTITY)) 
         --  obj.Log:save("QUANTITY" .. QUANTITY)
            local res = sendTransaction(obj.Transaction)
            if string.len(res) ~= 0 then 
                obj.Log:save("execute: fail " .. tostring(res))
            else
                obj.Log:save("execute: success " .. tostring(res))
            end
        end
    end

    -- send a order in a broker
    -- @param direct string - target a direct
    -- @param type string - type
    -- @param price integer|float - cost
    -- @param transId integer - random number
    -- @param event integer - какое событие сейчас происходит
    
    function obj:send(direct, type, price, transId, contractsCount, event)
        setDirect(direct)
        setType(type) 
        setPrice(price) 
        setTransId(transId) 
        setContractsCount(contractsCount)
        execute(transId)
    end

    function obj:deleteStop(stopOrder_num)
      
        obj.Log:save("obj:deleteStop " )
        obj.Transaction.ACTION = "KILL_STOP_ORDER"
        obj.Transaction.STOP_ORDER_KEY = tostring(stopOrder_num)
        execute(0) 
    end


    -- send request for delete a order
    function obj:delete()

        if obj.Setting.emulation then
            -- mode edulation
            message('transactionService:send' .. obj.Setting.gapper.data.buy_contract)

        else

        end
    end

    function random_max()

        local res = (16807 * (obj.RANDOM_SEED or 137137)) % 2147483647
        obj.RANDOM_SEED = res
        return res
    end

    setmetatable(obj, self)
    self.__index = self;
    return obj
end

return transactionService
