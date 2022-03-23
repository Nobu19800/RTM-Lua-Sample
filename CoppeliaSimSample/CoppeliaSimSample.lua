---------------------------------
--! @file CoppeliaSimSample.lua
--! @brief CoppeliaSim RTC Example
--! @date $Date$
---------------------------------

sim.setThreadAutomaticSwitch(false)

-- Import RTM module
local openrtm  = require "openrtm"



-- Import Service implementation class
-- <rtc-template block="service_impl">







-- </rtc-template>


-- This module's spesification
-- <rtc-template block="module_spec">
-- This module's spesification
-- <rtc-template block="module_spec">
local coppeliasimsample_spec = {["implementation_id"]="CoppeliaSimSample",
		 ["type_name"]="CoppeliaSimSample",
		 ["description"]="CoppeliaSim RTC Example",
		 ["version"]="1.0.0",
		 ["vendor"]="Nobuhiko Miyamoto",
		 ["category"]="Simulator",
		 ["activity_type"]="STATIC",
		 ["max_instance"]="1",
		 ["language"]="Lua",
		 ["lang_type"]="SCRIPT",
		 ""}
-- </rtc-template>


-- @class CoppeliaSimSample
-- @brief CoppeliaSim RTC Example
local CoppeliaSimSample = {}
CoppeliaSimSample.new = function(manager)
	local obj = {}
	setmetatable(obj, {__index=openrtm.RTObject.new(manager)})


	obj._d_in = openrtm.RTCUtil.instantiateDataType("::RTC::TimedFloatSeq")
	--[[
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

	--	--
	--	-- The activated action (Active state entry action)
	--	-- former rtc_active_entry()
	--	--
	--	-- @param ec_id target ExecutionContext Id
	--	--
	--	-- @return RTC::ReturnCode_t
	--	--
	--	--
	--	function obj:onActivated(ec_id)
	--	
	--		return self._ReturnCode_t.RTC_OK
	--	end

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
			local joint_front_left_wheel=sim.getObjectHandle('joint_front_left_wheel')
			local joint_front_right_wheel=sim.getObjectHandle('joint_front_right_wheel')
			local joint_back_right_wheel=sim.getObjectHandle('joint_back_right_wheel')
			local joint_back_left_wheel=sim.getObjectHandle('joint_back_left_wheel')

			sim.setJointTargetVelocity(joint_front_left_wheel, data.data[2]/50+data.data[1]/50)
			sim.setJointTargetVelocity(joint_front_right_wheel, -data.data[2]/50+data.data[1]/50)
			sim.setJointTargetVelocity(joint_back_right_wheel, -data.data[2]/50+data.data[1]/50)
			sim.setJointTargetVelocity(joint_back_left_wheel, data.data[2]/50+data.data[1]/50)
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
	--		return self._ReturnCode_t.RTC_OK
	--	end

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



CoppeliaSimSample.Init = function(manager)
	local profile = openrtm.Properties.new{defaults_map=coppeliasimsample_spec}
	manager:registerFactory(profile,
							CoppeliaSimSample.new,
							openrtm.Factory.Delete)
end

local MyModuleInit = function(manager)
	CoppeliaSimSample.Init(manager)

	-- Create a component
	local comp = manager:createComponent("CoppeliaSimSample")
end

if openrtm.Manager.is_main() then
	function sysCall_init()
		local manager = openrtm.Manager
		manager:init({"-o","exec_cxt.periodic.type:OpenHRPExecutionContext",
				"-o", "manager.components.preconnect:CoppeliaSimSample0.in?port=rtcname://localhost/TkJoyStick0.pos",
				"-o", "manager.components.preactivation:CoppeliaSimSample0,rtcname://localhost/TkJoyStick0",})
		manager:setModuleInitProc(MyModuleInit)
		manager:activateManager()
		manager:runManager(true)
		local naming = manager:getNaming()
		local comps = naming:string_to_component("rtcname://localhost/TkJoyStick0")
		local ec = comps[1]:get_owned_contexts()[1]
		ec:set_rate(10)
	end
else
	return CoppeliaSimSample
end

function sysCall_actuation()
	local openrtm = require "openrtm"
	local mgr = openrtm.Manager
	mgr:step()

	local comp = mgr:getComponent("CoppeliaSimSample0")
	local ec = comp:get_owned_contexts()[1]
	ec:tick()
end

function sysCall_cleanup()
	local openrtm = require "openrtm"
	local mgr = openrtm.Manager
	mgr:shutdown()
end