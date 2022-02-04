

local MLogic = {}

-- phase:
-- 1 get a target and direction
-- 2 send stop order or limit

function MLogic:new(setting, Log)

    -- свойства
    local obj = {}
    obj.Log = Log
    obj.Setting = setting

    --  function obj:Init()
    --  riskStop.calculateMaxStopStart()
    -- panelBids.CreateNewTableBids()

    function obj:init() 

    end

    
--     function main2() 
--         -- например

        
--         local a = {}
--         local b = {}
--         local c = {}
--         local AB = {}
--         local AC = {}

--         a.x = 1133; 
--         a.y = 4135;
--         b.x = 1504 ;
--         b.y = 4100;

        

--         c.x = b.x;
--         c.y = a.y;

--         -- вычисляем вектор угла AB
--         AB.x = (b.x - a.x) ;
--         AB.y = (b.y - a.y) ;

--         -- вычисляем вектор угла AC
--         AC.x = (c.x - a.x) ;
--         AC.y = (c.y - a.y) ;

--         local x3  = (b.x - a.x);
--         local y3  = (b.y - a.y);


--     local  res =  math.acos( (x3*x3+y3*0) / ( ((x3^2+y3^2)^0.5) * ((x3^2+0^2)^0.5))); 

--    -- message("result = " ..   math.deg(res) )


--     --    local ans = math.acos(a:dot(b) / (a:len() * b:len()))
--     --    message(math.deg(ans))

--     --   local result = angle(x1, y1, z1, x2, y2, z2);
--     --  message("result = " .. result);

--     end;
 
    function obj:searchStart()

        if #obj.Setting.fractals_point_collection > 0 then 

            for labelCheck = 1, #obj.Setting.fractals_point_collection do
                --    obj.Log:save('==== '..data.price.. ' = ' .. obj.Setting.fractals_point_collection[labelCheck].price.. '==== '..data.dt ..' = '.. obj.Setting.fractals_point_collection[labelCheck].dt )
               -- obj.Setting.current_price
            
                if obj.Setting.fractals_point_collection[labelCheck].type == "max"  then

            
                    
                end 
            
            end
        end

    end



    setmetatable(obj, self)
    self.__index = self;
    return obj
end

return MLogic
