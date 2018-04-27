package.path = package.path..";./lua/?.lua"
package.cpath = package.cpath..";./clibs/?.dll"
local oil  = require "oil"
local openrtm  = require "openrtm"
local OpenRestySample = require "OpenRestySample2"


local args = ngx.req.get_uri_args()
local command = tostring( args.command )



if command == "start" then
	local f = io.open("public/images/sample.html", "r")
	local content = f:read("*all")
	f:close()
	local MyModuleInit = function(manager)
	OpenRestySample.Init(manager)
	local comp = manager:createComponent("OpenRestySample2")
	end
	if oil.corba == nil then
		oil.corba = {}
		oil.corba.idl = {}
	end
	local manager = openrtm.Manager
	manager:init({"-o","logger.enable:NO","-o","exec_cxt.periodic.type:OpenHRPExecutionContext"})
	manager:setModuleInitProc(MyModuleInit)
	manager:activateManager()
	manager:runManager(true)
	ngx.say(content)
elseif command == "update" then
	--local f = io.open("luahooks/Activity_0.png", "rb")
	--input_file_stream = f:read("*a")
	--f:close()
	local manager = openrtm.Manager
	manager:step()
	local comp = manager:getComponent("OpenRestySample20")
	local ec = comp:get_owned_contexts()[1]
	ec:tick()
	local data = comp:getData()
	ngx.say(data)

	--ngx.say(input_file_stream)
end
