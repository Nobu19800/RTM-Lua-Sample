package = "EV3Sample"
version = "1.0.0-1"
source = {
   url = "",
   dir = "",
}

description = {
   summary = "ev3dev Sample",
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
      ["EV3Sample"] = "EV3Sample.lua",
    },
    install = {
      lua = {
      ["idl.ExtendedDataTypes"] = "idl/ExtendedDataTypes.idl",
      ["idl.BasicDataType"] = "idl/BasicDataType.idl",
    }
  }
}