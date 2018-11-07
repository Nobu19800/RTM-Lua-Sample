package = "LOVEStringIO"
version = "1.0.0-1"
source = {
   url = "",
   dir = "",
}

description = {
   summary = "LOVE2D String Input Output",
   detailed = [[

   ]],
   homepage = "",
   license = ""
}

dependencies = {
   "openrtm >= 0.0"
}

build = {
    type = "builtin",
    modules = {
      ["LOVEStringIO"] = "LOVEStringIO.lua",
    },
    install = {
      lua = {
      ["idl.BasicDataType"] = "idl/BasicDataType.idl",
    }
  }
}