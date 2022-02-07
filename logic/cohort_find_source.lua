local MLogic = {}

-- phase:
-- 1 get a target and direction
-- 2 send stop order or limit

function MLogic:new(setting, Log)

    -- свойства
    local obj = {}
    obj.Log = Log
    obj.Setting = setting
    -- obj.a.x = 0 -- time
    -- obj.a.y = 0 -- price
    -- obj.b.x = 0 -- time
    -- obj.b.y = 0 -- price

    --  function obj:Init()
    --  riskStop.calculateMaxStopStart()
    -- panelBids.CreateNewTableBids()

    function obj:init() end

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

    local function getTimeTrend(datetime)

        local hour = datetime.hour

        if datetime.hour < 10 then hour = '0' .. datetime.hour end

        local minute = datetime.min;

        if datetime.min < 10 then minute = '0' .. datetime.min end

        return hour .. minute;
    end

    local function getAccos(a, b)
        -- например

        --   local a = {}
        --  local b = {}
        local c = {}
        local AB = {}
        local AC = {}

        -- a.x = 1133; 
        -- a.y = 4135;
        -- b.x = 1504 ;
        -- b.y = 4100;

        c.x = b.x;
        c.y = a.y;

        -- вычисляем вектор угла AB
        AB.x = (b.x - a.x);
        AB.y = (b.y - a.y);

        -- вычисляем вектор угла AC
        AC.x = (c.x - a.x);
        AC.y = (c.y - a.y);

        local x3 = (b.x - a.x);
        local y3 = (b.y - a.y);

        local res =  math.acos((x3 * x3 + y3 * 0) /
                             (((x3 ^ 2 + y3 ^ 2) ^ 0.5) *
                                 ((x3 ^ 2 + 0 ^ 2) ^ 0.5)))
            return  math.deg(res)
        -- message("result = " ..   math.deg(res) )

        --    local ans = math.acos(a:dot(b) / (a:len() * b:len()))
        --    message(math.deg(ans))

        --   local result = angle(x1, y1, z1, x2, y2, z2);
        --  message("result = " .. result);

    end
    function obj:searchStart()

        if #obj.Setting.trendMax > 0 then
 
            for trend = 1, #obj.Setting.trendMax do
                --    obj.Log:save('==== '..data.price.. ' = ' .. obj.Setting.fractals_point_collection[labelCheck].price.. '==== '..data.dt ..' = '.. obj.Setting.fractals_point_collection[labelCheck].dt )
                -- obj.Setting.current_price

                if obj.Setting.trendMax[trend].type == "max" then

                    trend = obj.Setting.trendMax[trend];

                    --  local trendTime = obj.Setting:getTime(trend.datetime)
                    local a = {}
                    local b = {}

                    a.x = getTimeTrend(obj.Setting.datetime) -- time
                    a.y = obj.Setting.current_price -- price

                    b.x = getTimeTrend(trend.datetime) -- time
                    b.y = trend.price -- price
                   percent =  getAccos(a, b)
                --   obj.Log:save(obj.Setting.current_price..'==== '..trend.price.. ' dt '..trend.dt.. ' = ' .. b.x.. '='..a.x..'=== '.. ' = '.. percent)
                end
            end
        end
    end

    if #obj.Setting.fractals_point_collection > 0 then

        for candle = 1, #obj.Setting.fractals_point_collection do
            local fractal = obj.Setting.fractals_point_collection[candle];
            if (maxFractal < fractal.price) and fractal.type == "max" then
                maxFractal = fractal.price
                obj.Setting.trendMax[#obj.Setting.trendMax + 1] = fractal
                --     obj.Log:save(fractal.price .. " / "..  fractal.type ..' = '.. fractal.dt..' .datetime = '..fractal.datetime.min)
            end

            if (minFractal > fractal.price) and fractal.type == "min" then
                minFractal = fractal.price

                obj.Setting.trendMin[#obj.Setting.trendMin + 1] = fractal
                --    obj.Log:save(fractal.price .. " / "..  fractal.type ..' = '.. fractal.dt..' .datetime = '..fractal.datetime.min)
            end
        end 
    end

    setmetatable(obj, self)
    self.__index = self;
    return obj
end

return MLogic
