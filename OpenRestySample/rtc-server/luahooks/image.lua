package.path = package.path..";./lua/?.lua"
package.cpath = package.cpath..";./clibs/?.dll"
local oil  = require "oil"
local openrtm  = require "openrtm"
local OpenRestySample = require "OpenRestySample"
local cjson = require "cjson"

local args = ngx.req.get_uri_args()
--local size = tonumber( args.s );
--local quality = tonumber( args.q );

local command = tostring( args.command )




--ngx.say(package.path)
--ngx.say(package.cpath)
--ngx.say(tostring(openrtm))

--ngx.say(tostring(ngx.req.get_uri_args))
--ngx.say(tostring(args))
if command == "start" then
	local f = io.open("public/images/sample.html", "r")
	local content = f:read("*all")
	f:close()
	

	local MyModuleInit = function(manager)
		OpenRestySample.Init(manager)
		local comp = manager:createComponent("OpenRestySample")
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
	
	--openrtm.x = 0
	
	ngx.say(content)
elseif command == "update" then
	local x = 0
	local y = 0
	
	--if openrtm.start_clock ~= nil then
		--if os.clock() - openrtm.start_clock > 1.0 then
			--ngx.log(ngx.ERR, "time", ": "..tostring(os.clock() - openrtm.start_clock))
			
			local manager = openrtm.Manager
			--oil.main(function()
			--	manager:run_step(10)
			--end)
			manager:step()
			local comp = manager:getComponent("OpenRestySample0")
			local ec = comp:get_owned_contexts()[1]
			ec:tick()
			local data = comp:getData()
			--ngx.log(ngx.ERR, "", ": "..tostring(data))
			x = data[1]
			y = data[2]
			
		--end
	--end
	--math.randomseed(os.time())
	--local x = openrtm.x
	--openrtm.x = openrtm.x+10
	--local y = math.random(100)
	--ngx.log(ngx.ERR, "random", "number: "..tostring(x))
	--ngx.header.content_type = "application/json; charset=utf-8";
	ngx.say(cjson.encode({x=tostring(x),y=tostring(y)}))
end



