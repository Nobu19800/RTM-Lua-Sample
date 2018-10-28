---------------------------------
--! @file EV3Sample.lua
--! @brief ev3dev Sample
--! @date $Date$
--! @author 宮本　信彦
--! n-miyamoto@aist.go.jp
--! 産業技術総合研究所　ロボットイノベーション研究センター
--! ロボットソフトウエアプラットフォーム研究チーム
--! LGPL
---------------------------------



-- Import RTM module
package.path=package.path..";./lua/?.lua"
package.cpath=package.cpath..";./clibs/?.so"
local openrtm  = require "openrtm"

require 'ev3dev'


-- Import Service implementation class
-- <rtc-template block="service_impl">







-- </rtc-template>


-- This module's spesification
-- <rtc-template block="module_spec">
-- This module's spesification
-- <rtc-template block="module_spec">
local ev3sample_spec = {["implementation_id"]="EV3Sample",
		 ["type_name"]="EV3Sample",
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


-- @class EV3Sample
-- @brief ev3dev Sample
--
-- EV3上で動作するLuaのRTCのサンプル
local EV3Sample = {}
EV3Sample.new = function(manager)
	local obj = {}
	setmetatable(obj, {__index=openrtm.RTObject.new(manager)})



	obj._d_touch = openrtm.RTCUtil.instantiateDataType("::RTC::TimedBooleanSeq")
	--[[
		タッチセンサのオンオフ
		 - Type: RTC::TimedBooleanSeq
		 - Number: 2
	--]]
	obj._touchOut = openrtm.OutPort.new("touch", obj._d_touch, "::RTC::TimedBooleanSeq")
	obj._d_velocity = openrtm.RTCUtil.instantiateDataType("::RTC::TimedVelocity2D")
	--[[
		EducatorVehicleの速度
		 - Type: RTC::TimedVelocity2D
		 - Unit: m/s、rad/s
	--]]
	obj._velocityIn = openrtm.InPort.new("velocity", obj._d_velocity, "::RTC::TimedVelocity2D")





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
		self:addOutPort("touch",self._touchOut)

		-- Set InPort buffers
		self:addInPort("velocity",self._velocityIn)

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
		-- ポート1に接続したタッチセンサの初期化
		self._touchsensor1 = TouchSensor("in1")
		-- 接続失敗でエラーに遷移
		if not self._touchsensor1:connected() then
			return self._ReturnCode_t.RTC_ERROR
		end
		-- ポート3に接続したタッチセンサの初期化
		self._touchsensor2 = TouchSensor("in3")
		-- 接続失敗でエラーに遷移
		if not self._touchsensor2:connected() then
			return self._ReturnCode_t.RTC_ERROR
		end

		-- ポートBに接続したLモーターの初期化
		-- 右側の車輪を回転させるモーター
		self._lmotor1 = LargeMotor("outB")
		-- 接続失敗でエラーに遷移
		if not self._lmotor1:connected() then
			return self._ReturnCode_t.RTC_ERROR
		end
		-- 速度調整機能をオンにする
		-- ev3devのstretchではオンオフを切り替えることができないためpcallで呼び出す
		pcall(
			function()
				self._lmotor1:setSpeedRegulationEnabled("on")
			end
		)

		-- ポートCに接続したLモーターの初期化
		-- 左側の車輪を回転させるモーター
		self._lmotor2 = LargeMotor("outC")
		-- 接続失敗でエラーに遷移
		if not self._lmotor2:connected() then
			return self._ReturnCode_t.RTC_ERROR
		end

		-- 速度調整機能をオンにする
		-- ev3devのstretchではオンオフを切り替えることができないためpcallで呼び出す
		pcall(
			function()
				self._lmotor2:setSpeedRegulationEnabled("on")
			end
		)
		
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
		-- ポートAのLモーターを停止
		if self._lmotor1 ~= nil then
			self._lmotor1:setCommand("stop")
		end
		-- ポートCのLモーターを停止
		if self._lmotor2 ~= nil then
			self._lmotor2:setCommand("stop")
		end
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
		-- 車輪の半径
		local wheelRadius = 0.028
		-- 車輪間の距離
		local wheelDistance = 0.108

		-- タッチセンサの値を格納
		self._d_touch.data = {self._touchsensor1:pressed(),
							  self._touchsensor2:pressed()}
		-- データにタイムスタンプを設定
		openrtm.OutPort.setTimestamp(self._d_touch)
		-- touchのOutPortからタッチセンサの値を送信
		obj._touchOut:write()

		-- velocityのInPortに入力がある場合
		if self._velocityIn:isNew() then
			-- データ読み込み
			local data = self._velocityIn:read()
			-- 直進速度vx、旋回角速度vaから左右の車輪の回転速度を計算
			local r = wheelRadius
			local d = wheelDistance/2.0
			local vx = data.data.vx
			local va = data.data.va
			local right_motor_speed = (vx + va*d)/r
			local left_motor_speed = (vx - va*d)/r

			-- モーター1回転当たりのカウントを取得
			local cpr1 = self._lmotor1:countPerRot()
			local cpr2 = self._lmotor2:countPerRot()
			
			-- 回転速度[rad]からモーターに指令するカウント数に変換
			local speed1 = right_motor_speed/(2*math.pi)*cpr1
			local speed2 = left_motor_speed/(2*math.pi)*cpr2


			-- モーターに回転速度を指令
			self._lmotor1:setSpeedSP(math.floor(speed1))
			self._lmotor1:setCommand("run-forever")

			self._lmotor2:setSpeedSP(math.floor(speed2))
			self._lmotor2:setCommand("run-forever")
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
	return obj
end



EV3Sample.Init = function(manager)
    local profile = openrtm.Properties.new{defaults_map=ev3sample_spec}
    manager:registerFactory(profile,
                            EV3Sample.new,
                            openrtm.Factory.Delete)
end

local MyModuleInit = function(manager)
    EV3Sample.Init(manager)

    -- Create a component
    local comp = manager:createComponent("EV3Sample")
end

if openrtm.Manager.is_main() then
	local manager = openrtm.Manager
	manager:init(arg)
	manager:setModuleInitProc(MyModuleInit)
	manager:activateManager()
	manager:runManager()
else
	return EV3Sample
end

