---------------------------------
--! @file OpenRestySample.lua
--! @brief OpenResty Sample Component
--! @date $Date$
--! @author n-miyamoto@aist.go.jp
--! MIT
---------------------------------



-- Import RTM module
local openrtm  = require "openrtm"



-- Import Service implementation class
-- <rtc-template block="service_impl">







-- </rtc-template>


-- This module's spesification
-- <rtc-template block="module_spec">
-- This module's spesification
-- <rtc-template block="module_spec">
local openrestysample_spec = {["implementation_id"]="OpenRestySample",
		 ["type_name"]="OpenRestySample",
		 ["description"]="OpenResty Sample Component",
		 ["version"]="1.0.0",
		 ["vendor"]="Nobuhiko Miyamoto",
		 ["category"]="Sample",
		 ["activity_type"]="STATIC",
		 ["max_instance"]="1",
		 ["language"]="Lua",
		 ["lang_type"]="SCRIPT",
		 ""}
-- </rtc-template>


-- @class OpenRestySample
-- @brief OpenResty Sample Component
--
-- OpenResty上で動作するRTC
local OpenRestySample = {}
OpenRestySample.new = function(manager)
	local obj = {}
	setmetatable(obj, {__index=openrtm.RTObject.new(manager)})


	obj._d_in = openrtm.RTCUtil.instantiateDataType("::RTC::TimedFloatSeq")
	--[[
		JoyStickの位置を入力
		 - Type: RTC::TimedFloatSeq
		 - Number: 2
	--]]
	obj._inIn = openrtm.InPort.new("in", obj._d_in, "::RTC::TimedFloatSeq")



	obj.input_data = {0,0}

	-- initialize of configuration-data.
	-- <rtc-template block="init_conf_param">

	-- </rtc-template>
	--
	-- The initialize action (on CREATED->ALIVE transition)
	-- formaer rtc_init_entry()
	--
	-- @return RTC::ReturnCode_t
	--
	--
	function obj:onInitialize()
		-- Bind variables and configuration variable

		-- Set OutPort buffers

		-- Set InPort buffers
		self:addInPort("in",self._inIn)

		-- Set service provider to Ports

		-- Set service consumers to Ports

		-- Set CORBA Service Ports

		return self._ReturnCode_t.RTC_OK
	end

	--	--
	--	-- The finalize action (on ALIVE->END transition)
	--	-- formaer rtc_exiting_entry()
	--	--
	--	-- @return RTC::ReturnCode_t
	--
	--	--
	--	funtion obj:onFinalize()
	--
	--	return self._ReturnCode_t.RTC_OK
	--	end

	--	--
	--	-- The startup action when ExecutionContext startup
	--	-- former rtc_starting_entry()
	--	--
	--	-- @param ec_id target ExecutionContext Id
	--	--
	--	-- @return RTC::ReturnCode_t
	--	--
	--	--
	--	function obj:onStartup(ec_id)
	--	
	--		return self._ReturnCode_t.RTC_OK
	--	end

	--	--
	--	-- The shutdown action when ExecutionContext stop
	--	-- former rtc_stopping_entry()
	--	--
	--	-- @param ec_id target ExecutionContext Id
	--	--
	--	-- @return RTC::ReturnCode_t
	--	--
	--	--
	--	function obj:onShutdown(ec_id)
	--	
	--		return self._ReturnCode_t.RTC_OK
	--	end

	--	--
	--	-- The activated action (Active state entry action)
	--	-- former rtc_active_entry()
	--	--
	--	-- @param ec_id target ExecutionContext Id
	--	--
	--	-- @return RTC::ReturnCode_t
	--	--
	----
	--function obj:onActivated(ec_id)
	--
	--	return self._ReturnCode_t.RTC_OK
	--end

	--	--
	--	-- The deactivated action (Active state exit action)
	--	-- former rtc_active_exit()
	--	--
	--	-- @param ec_id target ExecutionContext Id
	--	--
	--	-- @return RTC::ReturnCode_t
	--	--
	--	--
	--	function obj:onDeactivated(ec_id)
	--	
	--		return self._ReturnCode_t.RTC_OK
	--	end

	--
	-- The execution action that is invoked periodically
	-- former rtc_active_do()
	--
	-- @param ec_id target ExecutionContext Id
	--
	-- @return RTC::ReturnCode_t
	--
	--
	function obj:onExecute(ec_id)
		if self._inIn:isNew() then
            local data = self._inIn:read()
            self.input_data[1] = data.data[1]
            self.input_data[2] = data.data[2]
        end
		return self._ReturnCode_t.RTC_OK
	end

	--	--
	--	-- The aborting action when main logic error occurred.
	--	-- former rtc_aborting_entry()
	--	--
	--	-- @param ec_id target ExecutionContext Id
	--	--
	--	-- @return RTC::ReturnCode_t
	--	--
	--	--
	--	function obj:onAborting(ec_id)
	--	
	--	return self._ReturnCode_t.RTC_OK
	--end

	--	--
	--	-- The error action in ERROR state
	--	-- former rtc_error_do()
	--	--
	--	-- @param ec_id target ExecutionContext Id
	--	--
	--	-- @return RTC::ReturnCode_t
	--	--
	--	--
	--	function obj:onError(ec_id)
	--	
	--		return self._ReturnCode_t.RTC_OK
	--	end

	--	--
	--	-- The reset action that is invoked resetting
	--	-- This is same but different the former rtc_init_entry()
	--	--
	--	-- @param ec_id target ExecutionContext Id
	--	--
	--	-- @return RTC::ReturnCode_t
	--	--
	--	--
	--	function obj:onReset(ec_id)
	--	
	--		return self._ReturnCode_t.RTC_OK
	--	end

	--	--
	--	-- The state update action that is invoked after onExecute() action
	--	-- no corresponding operation exists in OpenRTm-aist-0.2.0
	--	--
	--	-- @param ec_id target ExecutionContext Id
	--	--
	--	-- @return RTC::ReturnCode_t
	--	--

	--	--
	--	function obj:onStateUpdate(ec_id)
	--	
	--		return self._ReturnCode_t.RTC_OK
	--	end

	--	--
	--	-- The action that is invoked when execution context's rate is changed
	--	-- no corresponding operation exists in OpenRTm-aist-0.2.0
	--	--
	--	-- @param ec_id target ExecutionContext Id
	--	--
	--	-- @return RTC::ReturnCode_t
	--	--
	--	--
	--	function obj:onRateChanged(ec_id)
	--	
	--		return self._ReturnCode_t.RTC_OK
	--	end
	function obj:getData()
		return self.input_data
	end
	return obj
end



OpenRestySample.Init = function(manager)
    local profile = openrtm.Properties.new{defaults_map=openrestysample_spec}
    manager:registerFactory(profile,
                            OpenRestySample.new,
                            openrtm.Factory.Delete)
end

local MyModuleInit = function(manager)
    OpenRestySample.Init(manager)

    -- Create a component
    local comp = manager:createComponent("OpenRestySample")
end

if openrtm.Manager.is_main() then
	local manager = openrtm.Manager
	manager:init(arg)
	manager:setModuleInitProc(MyModuleInit)
	manager:activateManager()
	manager:runManager()
else
	return OpenRestySample
end

