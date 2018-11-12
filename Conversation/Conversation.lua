---------------------------------
--! @file Conversation.lua
--! @brief Seq2Deq Conversation Component
--! @date $Date$
--! @author 宮本　信彦　n-miyamoto@aist.go.jp
---------------------------------


--if not string.gfind then
--   string.gfind = string.gmatch
--end
package.path="./lua/?.lua;"..package.path
package.cpath="./clibs/?.so;"..package.cpath
-- Import RTM module
local openrtm  = require "openrtm"
require 'neuralconvo'
local tokenizer = require "tokenizer"
local list = require "pl.List"


-- Import Service implementation class
-- <rtc-template block="service_impl">







-- </rtc-template>


-- This module's spesification
-- <rtc-template block="module_spec">
-- This module's spesification
-- <rtc-template block="module_spec">
local conversation_spec = {["implementation_id"]="Conversation",
		 ["type_name"]="Conversation",
		 ["description"]="Seq2Deq Conversation Component",
		 ["version"]="1.0.0",
		 ["vendor"]="Nobuhiko Miyamoto",
		 ["category"]="DeepLarning",
		 ["activity_type"]="STATIC",
		 ["max_instance"]="1",
		 ["language"]="Lua",
		 ["lang_type"]="SCRIPT",
		 ["conf.default.model_file"]="data/model.t7",
		 ["conf.__widget__.model_file"]="text",
         ["conf.__type__.model_file"]="string",
		 ""}
-- </rtc-template>


-- @class Conversation
-- @brief Seq2Deq Conversation Component
local Conversation = {}
Conversation.new = function(manager)
	local obj = {}
	setmetatable(obj, {__index=openrtm.RTObject.new(manager)})


	obj._d_output_words = openrtm.RTCUtil.instantiateDataType("::RTC::TimedString")
	--[[
		入力に対する返答を出力する。現在は英語限定。
		 - Type: RTC::TimedString
	--]]
	obj._output_wordsOut = openrtm.OutPort.new("output_words", obj._d_output_words, "::RTC::TimedString")
	obj._d_input_words = openrtm.RTCUtil.instantiateDataType("::RTC::TimedString")
	--[[
		会話のために文章を入力する。現在は英語限定。
		 - Type: RTC::TimedString
	--]]
	obj._input_wordsIn = openrtm.InPort.new("input_words", obj._d_input_words, "::RTC::TimedString")





	-- initialize of configuration-data.
	-- <rtc-template block="init_conf_param">
	--[[
		モデルファイルを指定する。モデルファイルは事前に作成しておく必要がある。
		 - Name: model_file model_file
		 - DefaultValue: data/model.t7
	--]]
	obj._model_file = {_value='data/model.t7'}

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
		self:bindParameter("model_file", self._model_file, "data/model.t7")

		-- Set OutPort buffers
		self:addOutPort("output_words",self._output_wordsOut)

		-- Set InPort buffers
		self:addInPort("input_words",self._input_wordsIn)

		-- Set service provider to Ports

		-- Set service consumers to Ports

		-- Set CORBA Service Ports
		self.dataset = neuralconvo.DataSet()

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
		if self.model == nil then
			self.model = torch.load(self._model_file._value)
		end

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
		if self._input_wordsIn:isNew() then
			local data = self._input_wordsIn:read()
			self._d_output_words.data = self:say(data.data)
			openrtm.OutPort.setTimestamp(self._d_output_words)
			self._output_wordsOut:write()
		end
		return self._ReturnCode_t.RTC_OK
	end

	function obj:pred2sent(wordIds)
		local words = {}
	  
		for _, wordId in ipairs(wordIds) do
			local word = self.dataset.id2word[wordId[1]]
			table.insert(words, word)
		end
	  
		return tokenizer.join(words)
	end

	function obj:say(text)
		local wordIds = {}

		for t, word in tokenizer.tokenize(text) do
			local id = self.dataset.word2id[word:lower()] or self.dataset.unknownToken
			table.insert(wordIds, id)
		end

		local input = torch.Tensor(list.reverse(wordIds))
		local wordIds, _ = self.model:eval(input)

		return self:pred2sent(wordIds)
	end

	--	--
	--	-- The aborting action when main logic error occurred.
	--	-- former rtc_aborting_entry()
	--	--
	--	-- @param ec_id target ExecutionContext  -o corba.endpoints:Id
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



Conversation.Init = function(manager)
    local profile = openrtm.Properties.new{defaults_map=conversation_spec}
    manager:registerFactory(profile,
                            Conversation.new,
                            openrtm.Factory.Delete)
end

local MyModuleInit = function(manager)
    Conversation.Init(manager)

    -- Create a component
    local comp = manager:createComponent("Conversation")
end

--if openrtm.Manager.is_main() then
	local manager = openrtm.Manager
	manager:init(arg)
	manager:setModuleInitProc(MyModuleInit)
	manager:activateManager()
	manager:runManager()
--else
--	return Conversation
--end

