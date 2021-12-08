-- scriptTest.lua (in your scripts directory)
local M = {}
local Transaction = {}

local script_path = getScriptPath()
local loger = dofile(script_path .. "\\engine\\loger.lua");

local function random_max()

    local res = (16807 * (RANDOM_SEED or 137137)) % 2147483647
    RANDOM_SEED = res
    return res
end


local  function setTransDefault(setting)

    Transaction = {}
    Transaction.CLASSCODE = setting.CLASS_CODE;
    Transaction.SECCODE = setting.SEC_CODE;
    Transaction.ACCOUNT = setting.ACCOUNT;
    Transaction.USE_CASE_SENSITIVE_CONSTANTS = 'PROGRAM';
    Transaction.CLIENT_CODE = setting.comment_quik;
    Transaction.EXPIRY_DATE = "TODAY";
end

local function getOperation(market)
    if market == "buy" then 
        return "B"
    else
        return "S"
    end
end



 local function send_TAKE_PROFIT_STOP_ORDER(setting, typeMarket, prices, quantity, trans_id)

    setTransDefault(setting);
    
    loger.save( " - " ..typeMarket.. " - " .. prices._stopprice .. " - " .. prices._stopprice2 .. " - " .. quantity.. " - " .. trans_id );
    
    loger.save("send = " .. tostring(setting.SEC_CODE));
 

--     --local trans_id = random_max();

--     -- https://quikluacsharp.ru/quik-qlua/prostoj-ma-robot-qlua-s-vystavleniem-tejk-profit-i-stop-limit/

--     -- http://luaq.ru/sendTransaction.html
  
--     Transaction.trans_id = tostring(trans_id);
--     Transaction.ACTION = 'NEW_ORDER';
--     Transaction.OPERATION = getOperation(typeMarket); --  ("B" - buy, ??? "S" - sell)
--     Transaction.QUANTITY = tostring(quantity)

--     if setting.type_instrument  == 3 then  
        
--     loger.save("math.cei prices.STOPPRICE = " .. prices._stopprice2);
 
--   --  prices._stopprice = _stopprice;
--    -- prices._stopprice2 = _stopprice2;

--         STOPPRICE  =  tostring(math.ceil(prices._stopprice));
--         STOPPRICE2  =  tostring(math.ceil(prices._stopprice2));
--     else 
--         STOPPRICE  =  tostring(prices._stopprice);
--         STOPPRICE2 =  tostring(prices._stopprice2);
  
--     end;
--         Transaction.PRICE = STOPPRICE
--         Transaction.STOP_ORDER_KIND = "TAKE_PROFIT_AND_STOP_LIMIT_ORDER";
--         Transaction.ACTION = "NEW_STOP_ORDER";
--         Transaction.OFFSET_UNITS = "PRICE_UNITS";
--         -- stopprice = orderPrice + TAKE_PROFIT * priceStep; //--Уровень цены, когда активируется Тейк - профит
--         -- stopprice2 = orderPrice - STOP_LOSS * priceStep; //--Уровень цены, когда активируется Стоп - лосс
--         Transaction.STOPPRICE = STOPPRICE;
--         Transaction.STOPPRICE2 = STOPPRICE2;
--         Transaction.OFFSET = tostring(setting.take_profit_offset);
--         Transaction.KILL_IF_LINKED_ORDER_PARTLY_FILLED = "NO";
--         Transaction.USE_BASE_ORDER_BALANCE = "NO";
--         Transaction.ACTIVATE_IF_BASE_ORDER_PARTLY_FILLED = "YES";
--         Transaction.BASE_ORDER_KEY = tostring(trans_id);
--         Transaction.SPREAD = tostring(setting.take_profit_spread);
--         Transaction.SPREAD_UNITS = "PRICE_UNITS";
--         loger.save('Transaction.STOP_ORDER_KIND ' .. Transaction.STOP_ORDER_KIND)


--     local res = sendTransaction(Transaction);
--     message('res 3 ' .. tostring(res));

--     if res ~= "" then
--         loger.save("res  error send_TAKE_PROFIT_STOP_ORDE " .. res.. " "..setting.type_instrument );
        
--         message("res  error send_TAKE_PROFIT_STOP_ORDE " .. res.. " "..setting.type_instrument );
        
--         loger.save('Transaction  ' .. res)
--         return nil, res
--     else
--         return trans_id;
--     end
 end





function delete(transId_del_order, stopOrder_num, type)

    setTransDefault();
    Transaction.ACTION = "KILL_STOP_ORDER";

    if type == "TAKE_PROFIT_STOP_ORDER" or type == "KILL_STOP_ORDER" or type ==
        "SIMPLE_STOP_ORDER" then
        Transaction.ACTION = "KILL_STOP_ORDER";
    else
        Transaction.ACTION = "KILL_ORDER";
    end

    Transaction.TRANS_ID = tostring(transId_del_order);
    Transaction.STOP_ORDER_KEY = tostring(stopOrder_num);
    Transaction.ORDER_KEY = tostring(stopOrder_num);
    Transaction.TYPE = "L";

    loger.save("Delete :  " .. tostring(transId_del_order) ..
                   "  Transaction.ACTION = " .. tostring(Transaction.ACTION))

    local res = sendTransaction(Transaction)
    if string.len(res) ~= 0 then
        -- message('Error: '..res, 3)
        loger.save("Delete: fail " .. tostring(res))
    else
        loger.save("Delete: " .. tostring(stopOrder_num) .. " success ")
    end
end

function sendStop(typeMarket, priceParam, quantity, direction)

    setTransDefault();
    local price = ""
    local STOPPRICE = tostring(priceParam)

    local operation = "S"
    if typeMarket == "BUY" then
        operation = "B"
        price = tostring(priceParam + 1);
    else
        price = tostring(priceParam - 1);

    end

    
    if setting.type_instrument  == 3 then 
        price =  tostring(math.ceil(price));
    else 
        
        price =  tostring(price);
    end;

    local trans_id = random_max();

    -- https://quikluacsharp.ru/quik-qlua/prostoj-ma-robot-qlua-s-vystavleniem-tejk-profit-i-stop-limit/
    -- http://luaq.ru/sendTransaction.html

    Transaction.TYPE = 'L';
    Transaction.trans_id = tostring(trans_id);
    Transaction.OPERATION = operation; --  ("B" - buy, OR "S" - sell)

    Transaction.QUANTITY = tostring(quantity);
    Transaction.PRICE = price;
    Transaction.ACTION = "NEW_STOP_ORDER";

    --  Направленность стоп-цены. Возможные значения: «4» — меньше или равно, «5» – больше или равно
    Transaction.CONDITION = tostring(direction);
    Transaction.STOPPRICE = STOPPRICE;
    Transaction.STOP_ORDER_KIND = "SIMPLE_STOP_ORDER";

    local res = sendTransaction(Transaction);
    loger.save('sendStop ' .. tostring(res))

    if res ~= "" then
        message("res 2 " .. res);
        loger.save('Transaction  ' .. res)
        return nil, res

    else
        loger.save('===============')
        loger.save('Выставляем стоп  trans_id=' ..
                       tostring(trans_id))
        return trans_id;
    end

end
 

M.delete = delete
M.send_TAKE_PROFIT_STOP_ORDER = send_TAKE_PROFIT_STOP_ORDER
M.sendStop = sendStop

return M
