package = "LOVESample"
version = "1.0.0-1"
source = {
   url = "",
   dir = "",
}

description = {
   summary = "LOVE2D Sample",
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
      ["LOVESample"] = "LOVESample.lua",
    },
    install = {
      lua = {
      ["idl.BasicDataType"] = "idl/BasicDataType.idl",
    }
  }
}