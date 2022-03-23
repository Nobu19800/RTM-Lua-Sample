---------------------------------
--! @file CoppeliaSimSample.lua
--! @brief CoppeliaSim RTC Example
--! @date $Date$
---------------------------------



-- Import RTM module
openrtm_ms = require "openrtm_ms"



-- Import Service implementation class
-- <rtc-template block="service_impl">







-- </rtc-template>


-- This module's spesification
-- <rtc-template block="module_spec">
-- This module's spesification
-- <rtc-template block="module_spec">
coppeliasimsample_spec = {["implementation_id"]:"CoppeliaSimSample",
        ["type_name"]:"CoppeliaSimSample",
        ["description"]:"CoppeliaSim RTC Example",
        ["version"]:"1.0.0",
        ["vendor"]:"Nobuhiko Miyamoto",
        ["category"]:"Simulator",
        ["activity_type"]:"STATIC",
        ["max_instance"]:"1",
        ["language"]:"MoonScript",
        ["lang_type"]:"SCRIPT",
        ""}
-- </rtc-template>


-- @class CoppeliaSimSample
-- @brief CoppeliaSim RTC Example
class CoppeliaSimSample extends openrtm_ms.RTObject
    new: (manager) =>
        super manager


        self._d_in = openrtm_ms.RTCUtil.instantiateDataType("::RTC::TimedFloatSeq")
        --[[
        --]]
        self._inIn = openrtm_ms.InPort("in", self._d_in, "::RTC::TimedFloatSeq")





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
    onInitialize: =>
        -- Bind variables and configuration variable

        -- Set OutPort buffers

        -- Set InPort buffers
        @addInPort("in",self._inIn)

        -- Set service provider to Ports

        -- Set service consumers to Ports

        -- Set CORBA Service Ports

        return self._ReturnCode_t.RTC_OK

    --	--
    --	-- The finalize action (on ALIVE->END transition)
    --	-- formaer rtc_exiting_entry()
    --	--
    --	-- @return RTC::ReturnCode_t
    --	
    --	--
    --	 onFinalize: =>
    --	
    --	        return self._ReturnCode_t.RTC_OK
    --	
    --	--
    --	-- The startup action when ExecutionContext startup
    --	-- former rtc_starting_entry()
    --	--
    --	-- @param ec_id target ExecutionContext Id
    --	--
    --	-- @return RTC::ReturnCode_t
    --	--
    --	--
    --	 onStartup: (ec_id) =>
    --	
    --	    return self._ReturnCode_t.RTC_OK
    --	
    --	--
    --	-- The shutdown action when ExecutionContext stop
    --	-- former rtc_stopping_entry()
    --	--
    --	-- @param ec_id target ExecutionContext Id
    --	--
    --	-- @return RTC::ReturnCode_t
    --	--
    --	--
    --	 onShutdown: (ec_id) =>
    --	
    --	    return self._ReturnCode_t.RTC_OK
    --	
    --	--
    --	-- The activated action (Active state entry action)
    --	-- former rtc_active_entry()
    --	--
    --	-- @param ec_id target ExecutionContext Id
    --	--
    --	-- @return RTC::ReturnCode_t
    --	--
    --	--
    --	 onActivated: (ec_id) =>
    --	
    --	    return self._ReturnCode_t.RTC_OK
    --	
    --	--
    --	-- The deactivated action (Active state exit action)
    --	-- former rtc_active_exit()
    --	--
    --	-- @param ec_id target ExecutionContext Id
    --	--
    --	-- @return RTC::ReturnCode_t
    --	--
    --	--
    --	 onDeactivated: (ec_id) =>
    --	
    --	    return self._ReturnCode_t.RTC_OK
    --	
    --
    -- The execution action that is invoked periodically
    -- former rtc_active_do()
    --
    -- @param ec_id target ExecutionContext Id
    --
    -- @return RTC::ReturnCode_t
    --
    --
    onExecute: (ec_id) =>
    
        return self._ReturnCode_t.RTC_OK
    
    --	--
    --	-- The aborting action when main logic error occurred.
    --	-- former rtc_aborting_entry()
    --	--
    --	-- @param ec_id target ExecutionContext Id
    --	--
    --	-- @return RTC::ReturnCode_t
    --	--
    --	--
    --	 onAborting: (ec_id) =>
    --	
    --	    return self._ReturnCode_t.RTC_OK
    --	
    --	--
    --	-- The error action in ERROR state
    --	-- former rtc_error_do()
    --	--
    --	-- @param ec_id target ExecutionContext Id
    --	--
    --	-- @return RTC::ReturnCode_t
    --	--
    --	--
    --	 onError: (ec_id) =>
    --	
    --	    return self._ReturnCode_t.RTC_OK
    --	
    --	--
    --	-- The reset action that is invoked resetting
    --	-- This is same but different the former rtc_init_entry()
    --	--
    --	-- @param ec_id target ExecutionContext Id
    --	--
    --	-- @return RTC::ReturnCode_t
    --	--
    --	--
    --	 onReset: (ec_id) =>
    --	
    --	    return self._ReturnCode_t.RTC_OK
    --	
    --	--
    --	-- The state update action that is invoked after onExecute() action
    --	-- no corresponding operation exists in OpenRTm-aist-0.2.0
    --	--
    --	-- @param ec_id target ExecutionContext Id
    --	--
    --	-- @return RTC::ReturnCode_t
    --	--

    --	--
    --	 onStateUpdate: (ec_id) =>
    --	
    --	    return self._ReturnCode_t.RTC_OK
    --	
    --	--
    --	-- The action that is invoked when execution context's rate is changed
    --	-- no corresponding operation exists in OpenRTm-aist-0.2.0
    --	--
    --	-- @param ec_id target ExecutionContext Id
    --	--
    --	-- @return RTC::ReturnCode_t
    --	--
    --	--
    --	 onRateChanged: (ec_id) =>
    --	
    --	    return self._ReturnCode_t.RTC_OK
    --	


CoppeliaSimSampleInit = (manager) ->
    profile = openrtm_ms.Properties({defaults_map:coppeliasimsample_spec})
    manager\registerFactory(profile,
                            CoppeliaSimSample,
                            openrtm_ms.Factory.Delete)


MyModuleInit = (manager) ->
    CoppeliaSimSampleInit(manager)

    -- Create a component
    comp = manager\createComponent("CoppeliaSimSample")


manager = openrtm_ms.Manager
manager\init(arg)
manager\setModuleInitProc(MyModuleInit)
manager\activateManager()
manager\runManager()

