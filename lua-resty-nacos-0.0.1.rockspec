package = "lua-resty-nacos"
version = "0.01"
source = {
   url = "git://github.com/kuweiguge/lua-resty-nacos",
   tag = "v0.01"
}
description = {
   summary = "Lua Nacos Open API Client for OpenResty / ngx_lua.",
   homepage = "https://github.com/kuweiguge/lua-resty-nacos",
   license = "2-clause BSD",
   maintainer = "zhengwei <kuweiguge@gmail.com>"
}
dependencies = {
   "lua >= 5.1"
}
build = {
   type = "builtin",
   modules = {
      ["resty.nacos"] = "lib/resty/nacos.lua"
   }
}