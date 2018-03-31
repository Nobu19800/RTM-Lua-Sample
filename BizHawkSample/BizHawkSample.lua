---------------------------------
--! @file BizHawkSample.lua
--! @brief BizHawk Sample
--! @date $Date$
--! @author n-miyamoto@aist.go.jp
--! LGPL
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
local bizhawksample_spec = {["implementation_id"]="BizHawkSample",
		 ["type_name"]="BizHawkSample",
		 ["description"]="BizHawk Sample",
		 ["version"]="1.0.0",
		 ["vendor"]="Nobuhiko Miyamoto",
		 ["category"]="Sample",
		 ["activity_type"]="STATIC",
		 ["max_instance"]="1",
		 ["language"]="Lua",
		 ["lang_type"]="SCRIPT",
		 ""}
-- </rtc-template>


-- @class BizHawkSample
-- @brief BizHawk Sample
--
-- BizHawk上でRTCを動作させるためのサンプル
local BizHawkSample = {}
BizHawkSample.new = function(manager)
	local obj = {}
	setmetatable(obj, {__index=openrtm.RTObject.new(manager)})


	obj._d_in = openrtm.RTCUtil.instantiateDataType("::RTC::TimedFloatSeq")
	--[[
		ボタン入力用インポート
		1番目のデータ：左右
		2番目のデータ：Aボタン
		 - Type: RTC::TimedFloatSeq
		 - Number: 2
	--]]
	obj._inIn = openrtm.InPort.new("in", obj._d_in, "::RTC::TimedFloatSeq")





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
			local buttons = {["Left"]=false, ["Right"]=false, ["A"]=false}
			if data.data[1] > 20 then
				buttons["Right"] = true
			elseif data.data[1] < -20 then
				buttons["Left"] = true
			end
			if data.data[2] > 70 then
				buttons["A"] = true
			end
			joypad.set(buttons, 1)
		end
		emu.frameadvance()
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
	return obj
end



BizHawkSample.Init = function(manager)
    local profile = openrtm.Properties.new{defaults_map=bizhawksample_spec}
    manager:registerFactory(profile,
                            BizHawkSample.new,
                            openrtm.Factory.Delete)
end

local MyModuleInit = function(manager)
    BizHawkSample.Init(manager)

    -- Create a component
    local comp = manager:createComponent("BizHawkSample")
end

if openrtm.Manager.is_main() then
	local manager = openrtm.Manager
	--manager:init(arg)
	manager:init({"-o", "manager.components.preconnect:BizHawkSample0.in?port=rtcname://localhost/TkJoyStick0.pos", "-o", "manager.components.preactivation:BizHawkSample0,rtcname://localhost/TkJoyStick0"})
	manager:setModuleInitProc(MyModuleInit)
	manager:activateManager()
	manager:runManager()
else
	return BizHawkSample
end

