local utf8 = require("utf8")

local text = ""
local delflag = false
local font_size = 56

function love.load()
  love.keyboard.setKeyRepeat(true)

  package.preload["mime.core"] = nil
  package.preload["socket.ftp"] = nil
  package.preload["socket.headers"] = nil
  package.preload["socket.url"] = nil
  package.preload["socket.smtp"] = nil
  package.preload["socket.http"] = nil
  package.preload["socket.core"] = nil
  package.preload["socket.tp"] = nil
  package.preload["mime"] = nil
  package.preload["socket"] = nil


  local openrtm  = require "openrtm"
  local mgr = openrtm.Manager
  --mgr:init({"-o","exec_cxt.periodic.type:OpenHRPExecutionContext",
  --          "-o","manager.components.precreate:LOVEStringIO",
  --          "-o","manager.components.preconnect:LOVEStringIO0.output_string?port=rtcname://localhost/StringIn0.in,LOVEStringIO0.input_string?port=rtcname://localhost/StringOut0.out",
  --          "-o","manager.components.preactivation:LOVEStringIO0,rtcname://localhost/StringIn0,rtcname://localhost/StringOut0"})
  mgr:init({"-o","exec_cxt.periodic.type:OpenHRPExecutionContext","-o","manager.components.precreate:LOVEStringIO"})
  mgr:activateManager()
  mgr:runManager(true)

  local font = love.graphics.newFont(font_size)
  love.graphics.setFont(font)
  
end
   
   
function love.update(dt)
  local openrtm = require "openrtm"
  local mgr = openrtm.Manager
  mgr:step()

  local comp = mgr:getComponent("LOVEStringIO0")
  local ec = comp:get_owned_contexts()[1]
  ec:tick()

  
end

function love.keypressed(key)
  if key == "return" then
    local openrtm = require "openrtm"
    local mgr = openrtm.Manager
    local comp = mgr:getComponent("LOVEStringIO0")
    comp:writeText(text)
    delflag = true
  elseif key == "backspace" then
    local byteoffset = utf8.offset(text, -1)
    if byteoffset then
      text = string.sub(text, 1, byteoffset - 1)
    end
  end

end

function draw_text(str, x, y)
  local openrtm = require "openrtm"
  local str_list = openrtm.StringUtil.split(str, " ")
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight
  local length = 0
  local print_text = ""
  local count = 0
  for k,s in ipairs(str_list) do
      length = length+#s
      if width < length*font_size*3/4 then
        print_text = print_text.."\n"..s
        length = #s
        count = count+1
      else
        print_text = print_text..s.." "
      end
  end
  love.graphics.print(print_text, x, y-count*font_size)
end
   
function love.draw()
  
  local openrtm = require "openrtm"
  local mgr = openrtm.Manager
  local comp = mgr:getComponent("LOVEStringIO0")
  local intext = comp:getText()

  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()

  

  love.graphics.setColor(222, 160, 134)
  love.graphics.polygon("fill", 0,0, width,0, width,height/2, 0,height/2)

  love.graphics.setColor(172, 240, 114)
  love.graphics.polygon("fill", 0,height/2, width,height/2, width,height, 0,height)

  love.graphics.setColor(0, 0, 0)
  
  
  --love.graphics.print(text, 10, height/4, 0, 1, 1)
  --love.graphics.print(intext, 10, height/4*3, 0, 1, 1)
  draw_text(text, 10, height/4)
  draw_text(intext, 10, height/4*3)
end


function love.textinput(t)
  if delflag then
    delflag = false
    text = ""
  end
  text = text..t
end