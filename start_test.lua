 
-- test
script_path = getScriptPath()

dofile(script_path .. "\\setting\\path.lua");

obj = {}
obj.Setting =  dofile(script_path .. "\\setting\\work_si.lua");


local Gap = dofile(script_path .. "\\logic\\gap_engine.lua");
local Cohort = dofile(script_path .. "\\logic\\cohort_engine.lua");
local Loger = dofile(script_path .. "\\engine\\loger.lua");
local candleClass = dofile(script_path .. "\\signals\\candle.lua")
local calculateCandleForCohort = dofile(script_path ..  "\\modules\\calculateCandleForCohort.lua")



function OnInit()
       
   obj.Log = Loger:new(obj.Setting)
   -- очищаем логи
   obj.Log:clearFile()
   
   obj.gap = Gap:new(obj.Setting, obj.Log);
   obj.cohort = Cohort:new(obj.Setting, obj.Log);
   obj.candleClass = candleClass:new(obj.Setting, obj.Log)
   obj.calculateCandleForCohort = calculateCandleForCohort:new(obj.Setting, obj.Log)
   obj.gap.EngineOnInit()
   obj.cohort.EngineOnInit()
   
end
 
function main()


        
        local a = {}
        local b = {}
        local c = {}
        local AB = {}
        local AC = {}

        a.x = 2246; -- time
        a.y = 76625; -- price


        -- down
        b.x = 2349;-- time
        b.y = 76670; -- price

        

        c.x = b.x;
        c.y = a.y;

        -- вычисляем вектор угла AB
        AB.x = (b.x - a.x) ;
        AB.y = (b.y - a.y) ;

        -- вычисляем вектор угла AC
        AC.x = (c.x - a.x) ;
        AC.y = (c.y - a.y) ;

        local x3  = (b.x - a.x);
        local y3  = (b.y - a.y);


    local  res =  math.acos( (x3*x3+y3*0) / ( ((x3^2+y3^2)^0.5) * ((x3^2+0^2)^0.5))); 

    message("result = " ..   math.deg(res) )


    --    local ans = math.acos(a:dot(b) / (a:len() * b:len()))
    --    message(math.deg(ans))

    --   local result = angle(x1, y1, z1, x2, y2, z2);
    --  message("result = " .. result);
end
 
