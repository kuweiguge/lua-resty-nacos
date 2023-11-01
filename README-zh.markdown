# lua-resty-http [English](https://github.com/kuweiguge/lua-resty-nacos/blob/main/README.markdown)
Lua [Nacos Open API](https://nacos.io/zh-cn/docs/open-api.html) Client for [OpenResty](http://openresty.org/en/) / [ngx_lua](https://github.com/openresty/lua-nginx-module).

# Status
Beta version

# Features
- 配置管理
    - 获取配置
    - 监听配置
    - 发布配置
    - 删除配置
- 服务发现
    - 注册实例
    - 注销实例
    - 修改实例
    - 查询实例列表
    - 查询实例详情
    - 发送实例心跳
    - 创建服务
    - 删除服务
    - 修改服务
    - 查询服务
    - 查询服务列表
    - 查询系统开关
    - 修改系统开关
    - 查看系统当前数据指标
    - 查看当前集群Server列表
    - 查看当前集群leader
    - 更新实例的健康状态
    - 批量更新实例元数据(Beta)
    - 批量删除实例元数据(Beta)
- 命名空间
    - 查询命名空间列表
    - 创建命名空间
    - 修改命名空间
    - 删除命名空间
# Synopsis
```shell
opm get kuweiguge/lua-resty-nacos
```


```conf
lua_package_path "/path/to/lua-resty-nacos/lib/?.lua;;";

server {

    location /test{
        default_type text/plain;
        content_by_lua_block {
            local nacos = require("resty.nacos")
            local domain = "http://localhost:8848"
            local result = nacos.push_config(domain,'nacos.example','111',nil,nil,nil)
            ngx.say("push_config result:  ",result)

            local result = nacos.get_config(domain,'nacos.example',nil,nil)
            ngx.say("get_config result:  ",result)

            local result = nacos.delete_config(domain,'nacos.example',nil,nil)
            ngx.say("delete_config result:  ",result)
            
            local result = nacos.register_instance(domain,'192.168.1.15',9028,'testService',nil,nil,nil,nil,nil,nil,nil,nil)
            ngx.say("register_instance result:  ",result)

            local result = nacos.get_instance_list(domain,'testService',nil,nil,nil,nil)
            ngx.say("get_instance_list result:  ",result)

            local result = nacos.get_instance_detail(domain,'192.168.1.15',9028,'testService',nil,nil,nil,nil)
            ngx.say("get_instance_detail result:  ",result)

            local beat = '{"cluster":"DEFAULT","ip":"192.168.1.15","metadata":{},"port":9028,"scheduled":true,"serviceName":"testService","weight":1}'
            local result = nacos.send_instance_beat(domain,'192.168.1.15',9028,'testService',beat,nil,nil,nil,nil)
            ngx.say("send_instance_beat result:  ",result)
        }
    }
}
```
# Licence
This module is licensed under the 2-clause BSD license.

Copyright (c) 2023-2026,  zhengwei kuweiguge@gmail.com

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.