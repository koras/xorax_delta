

local Logic = {}

-- phase:
-- 1 get a target and direction
-- 2 send stop order or limit

function Logic:new(setting, Log)

    -- свойства
    local obj = {}
    obj.Log = Log
    obj.Setting = setting

    --  function obj:Init()
    --  riskStop.calculateMaxStopStart()
    -- panelBids.CreateNewTableBids()

    function obj:init() 

    end
 
    function obj:searchStart()

        if #obj.Setting.fractals_point_collection > 0 then 

            for labelCheck = 1, #obj.Setting.fractals_point_collection do
                --    obj.Log:save('==== '..data.price.. ' = ' .. obj.Setting.fractals_point_collection[labelCheck].price.. '==== '..data.dt ..' = '.. obj.Setting.fractals_point_collection[labelCheck].dt )
                obj.Setting.current_price
            
                if obj.Setting.fractals_point_collection[labelCheck].type == "max"  then
                        
            
                    
                end 
            
            end
        end

    end



    setmetatable(obj, self)
    self.__index = self;
    return obj
end

return Logic
