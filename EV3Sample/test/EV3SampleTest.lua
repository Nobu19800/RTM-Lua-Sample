---------------------------------
--! @file EV3SampleTest.py
--! @brief ev3dev Sample
--! @date $Date$

--! @author ${tmpltHelperPy.convertAuthorDocPy(${rtcParam.docCreator})}

--! ${tmpltHelperPy.convertDocPy(${rtcParam.docLicense})}
---------------------------------

local openrtm  = require "openrtm"



-- Import Service implementation class
-- <rtc-template block="service_impl">
local ExtendedDataTypes_idl_example = require "ExtendedDataTypes_idl_example"
local BasicDataType_idl_example = require "BasicDataType_idl_example"


-- </rtc-template>


-- This module's spesification
-- <rtc-template block="module_spec">
local ev3sampletest_spec = {["implementation_id"]="EV3SampleTest", 
		 ["type_name"[="EV3SampleTest", 
		 ["description"]="ev3dev Sample",
		 ["version"]="1.0.0",
		 ["vendor"]="Nobuhiko Miyamoto",
		 ["category"]="Sample",
		 ["activity_type"]="STATIC",
		 ["max_instance"]="1",
		 ["language"]="Lua",
		 ["lang_type"]="SCRIPT",
		 ""}
-- </rtc-template>

-- @class EV3SampleTest
-- @brief ev3dev Sample
--
-- EV3上で動作するLuaのRTCのサンプル
local EV3SampleTest = {}
EV3SampleTest.new = function(manager)
	local obj = {}
	setmetatable(obj, {__index=openrtm.RTObject.new(manager)})

	manager:loadIdLFile("idl/ExtendedDataTypes.idl")
	manager:loadIdLFile("idl/BasicDataType.idl")


	obj._d_touch = openrtm.RTCUtil.instantiateDataType("::RTC::TimedBooleanSeq")
	--[[
		タッチセンサのオンオフ
		 - Type: RTC::TimedBooleanSeq
		 - Number: 2
	--]]
	obj._touchIn = openrtm.InPort.new("touch", obj._d_touch, "::RTC::TimedBooleanSeq")
	obj._d_velocity = openrtm.RTCUtil.instantiateDataType("::RTC::TimedVelocity2D")
	--[[
		EducatorVehicleの速度
		 - Type: RTC::TimedVelocity2D
		 - Unit: m/s、rad/s
	--]]
	obj._velocityOut = openrtm.OutPort.new("velocity", obj._d_velocity, "::RTC::TimedVelocity2D")





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
		self:addInPort("touch",self._touchIn)

		-- Set InPort buffers
		self:addOutPort("velocity",self._velocityOut)

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
	--	function obj:onFinalize()
	--	
	--		return self._ReturnCode_t.RTC_OK
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

	--
	-- The activated action (Active state entry action)
	-- former rtc_active_entry()
	--
	-- @param ec_id target ExecutionContext Id
	--
	-- @return RTC::ReturnCode_t
	--
	--
	function obj:onActivated(ec_id)
	
		return self._ReturnCode_t.RTC_OK
	end

	--
	-- The deactivated action (Active state exit action)
	-- former rtc_active_exit()
	--
	-- @param ec_id target ExecutionContext Id
	--
	-- @return RTC::ReturnCode_t
	--
	--
	function obj:onDeactivated(ec_id)
	
		return self._ReturnCode_t.RTC_OK
	end

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


local MyModuleInit = function(manager)
    EV3SampleTest.Init(manager)

    -- Create a component
    local comp = manager:createComponent("EV3SampleTest")
end

if openrtm.Manager.is_main() then
	local manager = openrtm.Manager
	manager:init(arg)
	manager:setModuleInitProc(MyModuleInit)
	manager:activateManager()
	manager:runManager()
else
	return EV3SampleTest
end

