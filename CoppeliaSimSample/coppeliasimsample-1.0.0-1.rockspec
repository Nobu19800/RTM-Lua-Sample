package = "CoppeliaSimSample"
version = "1.0.0-1"
source = {
   url = ""
}

description = {
   summary = "CoppeliaSim RTC Example",
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
      ["CoppeliaSimSample"] = "CoppeliaSimSample.lua",
    },
    install = {
      lua = {
    }
  }
}