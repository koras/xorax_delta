-- ЗДесь принимается решение о покупке или продаже в зависимости от текущего состояния счёта
-- https://open-broker.ru/pricing-plans/universal/
-- 751,97 ₽
-- 7,5  = 0.01


local script_path = getScriptPath()
local loger = dofile(script_path .. "\\engine\\loger.lua") 

 

local http = dofile(script_path .. "\\engine\\http.lua");

local transaction = dofile(script_path .. "\\shop\\transaction_v2.lua");

-- сервис, общие математические операции
dofile(script_path .. "\\shop\\market_service.lua");

-- SHORT  = FALSE
-- LONG = true 


local function getNewPriceForPosition(setting) 
 
    local rangeCost = setting.instrument_measurement;
    local currentPrice = setting.current_price

    if(setting.gap.direct == 'buy') then
        setting.current_price = currentPrice + rangeCost + setting.profit_infelicity + setting.profit_infelicity;
    end     

    if(setting.gap.direct == 'sell') then
        setting.current_price = currentPrice - rangeCost - setting.profit_infelicity - setting.profit_infelicity;
    end     
    return setting.current_price;
end


local function getRand() return tostring(math.random(2000000000)); end

local function getUseContractForGap(setting)
    return setting.gap.use_contract;
end


local function openPosition(setting) 
    
        loger.save('addSignal  21' ); 
        
        local newPrice =  getNewPriceForPosition(setting);

        
        loger.save('addSignal  23' ); 

        local type = "NEW_ORDER";
        -- генерация trans_id для эмуляции 
        local trans_id = getRand()

        local use_contract = getUseContractForGap(setting);
        setting.count_contract = use_contract;

        if setting.emulation == false then
            trans_id = transaction.send(setting.gap.direct, newPrice, use_contract, type, 0);
        end
    
        local data = {};
            data.price = newPrice;
            data.datetime = setting.datetime;
            data.trans_id = trans_id;
            -- сколько контрактов исполнилось 
            data.use_contract = use_contract;
            data.trans_id_buy = trans_id;
        
            data.work = true;
            data.executed = false;
            data.type = setting.gap.direct;
            data.emulation = setting.emulation;
            data.contract = use_contract;
            data.buy_contract = newPrice; -- стоимость продажи
            setting.gap.data = data;
             
            loger.save('open position = ' .. newPrice); 
        if setting.emulation then 
                label.set(setting.gap.direct, newPrice, setting.datetime, use_contract);
        end
    
        setting.sellTable[(#setting.sellTable + 1)] = data;
        -- We opened a position
        
        loger.save('addSignal 23')
        loger.save('Execution request') 
    --    panelBids.show(setting);
  --      control.use_contract_limit();
end



local function getDirection(setting) 
           loger.save('old price = ' .. setting.array_candle[2].close); 
           loger.save('setting.current_price = ' .. setting.current_price); 
          
 

          local DIRECT = 'buy'
 
         if(setting.current_price >= setting.array_candle[2].close) then

                DIRECT = 'buy';
            else
                -- short
                DIRECT = 'sell';
            end     

            setting.gap.direct = DIRECT;
            loger.save('====================')
            loger.save('gap.direct = '..DIRECT )
            loger.save('====================')
            return DIRECT;
end


-- второй этап регистрации события
-- если шорт, то здесь выставляем заявку на покупку, после продажи
-- лонг, выставляем заявку на продажу, если купили контракт
-- done
local function secondOperation(order, _setting, contract)
    _setting.gap.phase = 2;
    loger.save("GAP secondOperation");

    local _stopprice = 0
    local _stopprice2 = 0
 
    if contract.use_contract == 0 then
        loger.save("нет контрактов " .. contract.use_contract);
    end
 

  --  local type = "TAKE_PROFIT_STOP_ORDER";
   -- local type = "TAKE_PROFIT_AND_STOP_LIMIT_ORDER";
  --  if _setting.sell_take_or_limit == false then type = "NEW_ORDER"; end

    -- first need to know a direction
    -- when we get the price
 
        local data = {};
        data.number = 0
        local prices = {};

        
        -- stopprice = orderPrice + TAKE_PROFIT * priceStep; //--Уровень цены, когда активируется Тейк - профит
        -- stopprice2 = orderPrice - STOP_LOSS * priceStep; //--Уровень цены, когда активируется Стоп - лосс


                -- stopprice = orderPrice + TAKE_PROFIT * priceStep; //--Уровень цены, когда активируется Тейк - профит
        -- stopprice2 = orderPrice - STOP_LOSS * priceStep; //--Уровень цены, когда активируется Стоп - лосс
        if _setting.mode == 'buy' then
            data.type = 'sell'

            _stopprice = contract.price + _setting.gap.takeProfit
            _stopprice2 = contract.price - _setting.gap.stopLimit;

            prices._stopprice = _stopprice;
            prices._stopprice2 = _stopprice2;
        else
            -- short
            data.type = 'buy'
            _stopprice = contract.price - _setting.gap.takeProfit
            _stopprice2 = contract.price + _setting.gap.stopLimit;

            
            prices._stopprice = _stopprice;
            prices._stopprice2 = _stopprice2;
        end

        data.datetime = order.datetime
        data.order_type = type;
        data.work = true;
        data.executed = false; -- покупка исполнилась
        data.emulation = _setting.emulation;
        data.contract = _setting.gap.use_contract;
        data.use_contract = _setting.gap.use_contract;
        data.buy_contract = _stopprice; -- стоимость продажи
        data.trans_id_buy = contract.trans_id_buy
       
        loger.save("secondOperation 1"); 
 
        data.price = _stopprice;
        data.stopprice = _stopprice;
        data.trans_id = getRand();

        if _setting.emulation then
  

            if data.type == 'buy' then
                label.set("redCircle", _stopprice, contract.datetime, 1, data.type);
            else
                label.set("greenCircle", _stopprice, contract.datetime, 1, data.type);
            end

        else
            data.order_num = order.order_num;
            if _setting.mode == 'buy' then
                -- setting bid
                

                -- setting take
                data.trans_id = transaction_v2.send_TAKE_PROFIT_STOP_ORDER(_setting, "SELL", prices, order.order_num, data.trans_id);
            else
                data.trans_id = transaction_v2.send_TAKE_PROFIT_STOP_ORDER(_setting, "BUY", prices,  order.order_num, data.trans_id);
            end 
        end
        
        _setting.gap.trans_id = data.trans_id;

        _setting.sellTable[#_setting.sellTable + 1] = data;
        panelBids.show(_setting);
         -- We need to set STOP
end

-- Функция вызывается терминалом QUIK при получении новой стоп-заявки или при изменении параметров существующей стоп-заявки (Таблица стоп-заявок).

function EngineTransReply(stop_order, _setting)

    -- if stop_order.trans_id == _setting.gap.trans_id then BuyOrderNum = stop_order.order_num; end;
    -- if stop_order.trans_id == _setting.gap.trans_id then SellOrderNum = stop_order.order_num; end;
    -- if stop_order.trans_id == _setting.gap.trans_id then SlTpOrderNum = stop_order.linkedorder; end;

    
    -- Если зарегистрирована Стоп-лимит на покупку, то сохраняет ее номер
        if stop_order.trans_id == _setting.gap.trans_id then 
            _setting.gap.order_num = stop_order.order_num; 
        end
            -- Если зарегистрирована Стоп-лимит на продажу, то сохраняет ее номер
            if stop_order.trans_id == _setting.gap.trans_id then 
            _setting.gap.order_num = stop_order.order_num; 
        end


            -- Если зарегистрирована "Тейк-профит", то сохраняет ее номер
        if stop_order.trans_id == _setting.gap.trans_id then
        _setting.gap.order_num = stop_order.linkedorder; 
        end
        

        -- Если зарегистрирована "Стоп-лосс", то сохраняет ее номер
        if stop_order.trans_id == _setting.gap.stop_loss_trans_id then 
            _setting.gap.stop_loss_order_num = stop_order.linkedorder
        end
        
end
 

-- we are checking a position for 
local function executedContract(_setting, trade)
        -- сперва находим контракт который купили и ставим статус что мы купили контракт
        -- which a phase? 
        if #_setting.sellTable > 0 then
            for contract = 1, #_setting.sellTable do
                -- loger.save(setting.sellTable[contract].type)  
                if _setting.sellTable[contract].executed == false and
                        _setting.sellTable[contract].trans_id == trade.trans_id then
     
                        _setting.sellTable[contract].executed = true;
                        -- выставляем на продажу контракт.
                        -- ставим стоп, ибо нехуй деньгами разбрасываться 
                        secondOperation(trade, _setting, _setting.sellTable[contract])
                    return;
                end
            end
        end
end

local function logicGap(setting) 

    loger.save('setting.gap.allowed');
    if setting.gap.allowed  then

        loger.save('setting.gap.allowed 1');
        if setting.gap.phase == 0 then 
            loger.save('setting.gap.allowed 2');

            local arrGraff =  setting.array_candle

            if(#arrGraff > 10) then  
                loger.save('setting.gap.allowed 2');

                loger.save('http.sendHttp');
                http.sendHttp(setting, "logicGap");
                
                loger.save('call getDirection '  )
                local direction = getDirection(setting);
                loger.save('call openPosition '  )
                openPosition(setting)
                
                loger.save('call openPosition 1'  )
                setting.gap.phase = 1;
 
            end
        elseif(setting.gap.phase == 1) then 
           -- closePosition(setting)
            loger.save('setting.gap.phase == 1');

        elseif(setting.gap.phase == 2) then 

            loger.save('setting.gap.phase == 2');
        end
    end
end
 

-- This function will call when 

local function startContract(order, setting)

end




-- create take profit and stop
local function createTakeProfitAndStop(setting)

    setting.gap.stop.trans_id = tostring(math.random(1, 9999))
    local trans_id = setting.gap.stop.trans_id
    local prices = {}
    -- setting.gap.stop.trans_id

    if(setting.gap.direct == 'sell') then 
        setting.gap.priceProfit = setting.gap.data.price - setting.gap.takeProfit;
        --цена активации тейк профита
        prices.STOPPRICE = tostring(setting.gap.priceProfit);  
         -- Цена Стоп-Лосса
        prices.STOPPRICE2 = tostring(setting.gap.data.price + setting.gap.stopLimit)
        -- куда двигать стоп
        setting.gap.nextPriceStop =  setting.gap.data.price - setting.gap.stopLimit - setting.gap.stopLimit;
        -- где должна быть цена чтобы передвинуть стоп
        setting.gap.whereIsPriceForStop = setting.gap.data.price - setting.gap.stopLimit - setting.gap.stopLimit- setting.gap.stopLimit;
    else

        setting.gap.priceProfit = setting.gap.data.price + setting.gap.takeProfit;
        --цена активации тейк профита
        prices.STOPPRICE =  tostring(setting.gap.priceProfit);
         -- Цена Стоп-Лосса
        prices.STOPPRICE2 = tostring(setting.gap.data.price - setting.gap.stopLimit)

        -- куда двигать стоп
        setting.gap.nextPriceStop =  setting.gap.data.price + setting.gap.stopLimit + setting.gap.stopLimit;
        -- где должна быть цена чтобы передвинуть стоп
        setting.gap.whereIsPriceForStop = setting.gap.data.price + setting.gap.stopLimit + setting.gap.stopLimit + setting.gap.stopLimit;
    end
    
  --  transaction.send(typeMarket, price, quantity, type, trans_id_buy, direction);
        
    if setting.emulation == false then
        transaction_v2.send_TAKE_PROFIT_STOP_ORDER(setting, setting.gap.direct, prices, setting.gap.use_contract, trans_id);
    else

        if(setting.gap.direct == 'sell') then
             setting.gap.label.redCircle_stop = label.set("redCircle", prices.STOPPRICE, setting.datetime, setting.gap.use_contract, "Take profit");
            setting.gap.label.redCircle_take = label.set("redCircle", prices.STOPPRICE2, setting.datetime, setting.gap.use_contract, "STOP LIMIT");
            setting.gap.label.circleBlue_next_stop = label.set("circleBlue", setting.gap.whereIsPriceForStop, setting.datetime, setting.gap.use_contract, "Next Price");
            setting.gap.label.circleYellow_next_price = label.set("circleYellow", setting.gap.nextPriceStop, setting.datetime, setting.gap.use_contract, "Next stop");
        else
            setting.gap.label.redCircle_stop = label.set("redCircle", prices.STOPPRICE, setting.datetime, setting.gap.use_contract, "Take profit");
            setting.gap.label.redCircle_take = label.set("redCircle", prices.STOPPRICE2, setting.datetime, setting.gap.use_contract, "STOP LIMIT");
            setting.gap.label.circleBlue_next_stop = label.set("circleBlue", setting.gap.whereIsPriceForStop, setting.datetime, setting.gap.use_contract, "Next Price");
            setting.gap.label.circleYellow_next_price = label.set("circleYellow", setting.gap.nextPriceStop, setting.datetime, setting.gap.data.use_contract, "Next stop");
        end
    end
    setting.gap.phase = 2;
end

local function  weRemoveTheOldApplication(setting)
    if setting.emulation then
        label.delete(setting, setting.gap.label.circleYellow_next_price);
        label.delete(setting, setting.gap.label.circleBlue_next_stop);
    else
        
    end
end


-- исполнение продажи контракта в режиме эмуляции
-- создание стоп заявки
-- create the stop order
local function executionGapPositionfor_Emulation(setting, result)
    local price = result.close;

    --  local price_callSELL_emulation = result.close;
    if #setting.sellTable > 0 then 

       -- loger.save("forEmulation  sell ".. price .." < "..setting.gap.data.price);

        if setting.gap.direct == 'sell' and  price  <= setting.gap.data.price  then 
                -- execution position
                -- create stop
                -- create take profit
                loger.save("forEmulation sell");
           --   setting.gap.priceProfit = setting.gap.data.price - setting.gap.well_price;
                weRemoveTheOldApplication(setting);
                createTakeProfitAndStop(setting);
             
        end

       -- loger.save("forEmulation  sell ".. price .." < "..setting.gap.data.price);
        if setting.gap.direct == 'buy' and price  >= setting.gap.data.price  then 
                -- execution position
           --    setting.gap.priceProfit = setting.gap.data.price + setting.gap.well_price;
                -- create stop
                -- create take profit
                loger.save("forEmulation buy");
                weRemoveTheOldApplication(setting);
                createTakeProfitAndStop(setting);
           
        end 
    end
end
 

-- Сработал стоп или тейк 
local function executionStopOrTake(setting, result)
    local price = result.close;

end
-- трейлим стоп
local function nextStepTakeProfitAndStop(setting, result)
 


end

-- двигаем стоп в сторону движения цены
-- делаем это пока не словим стоп или тейк
local function executionGapPositionfor_Emulation_nextStep(setting, result)

        -- куда двигать стоп
      --  setting.gap.nextPriceStop =  prices.STOPPRICE2 + setting.profit_range;
        -- где должна быть цена чтобы передвинуть стоп
      --  setting.gap.whereIsPriceForStop =  prices.STOPPRICE2 + setting.profit_range + setting.profit_range;

    if(setting.gap.phase == 2) then 

        if setting.gap.direct == 'sell' and  result.close  <= setting.gap.whereIsPriceForStop  then 
                nextStepTakeProfitAndStop(setting)
        end

        if setting.gap.direct == 'buy' and result.close  >= setting.gap.whereIsPriceForStop  then 
                nextStepTakeProfitAndStop(setting)
        end 
    end 
end


-- check the price
local function forEmulation(setting, result)
     
    if(setting.gap.phase == 1) then
        executionGapPositionfor_Emulation(setting, result);
    end 

    if(setting.gap.phase == 2) then
        executionGapPositionfor_Emulation_nextStep(setting, result);
    end 
end


 

-- обновление номера стопа 
-- это надо для удаления стопа

function updateStopNumber(order)
    if(setting.gap.phase == 1 or setting.gap.phase == 2) then

        if setting.gap.stop.trans_id ==  order.trans_id and setting.gap.stop.trans_id ~= 0 then 
             
            stopClass.array_stop.stop_number = order.order_num;
            loger.save("GAP updateOrderNumber  order_num=" .. stopClass.array_stop.stop_number..  " trans_id=" .. setting.gap.stop.trans_id)
        end
    end
end

-- mode is emulationing
-- each tick is updating

local function tick(setting, result)
    forEmulation(setting, result);
end

local M = {}; 
 
M.updateStopNumber = updateStopNumber
M.logicGap = logicGap
M.tick = tick
M.executedContract = executedContract
M.EngineTransReply = EngineTransReply
M.forEmulation = forEmulation
return M
