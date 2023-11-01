
local _M = { _VERSION = '0.0.1'}
local httpUtils = require "resty.httpUtils"

local default_domain = "http://127.0.0.1:8848"
local default_namespace = "public"
local default_group = "DEFAULT_GROUP"
-- 官方文档 https://nacos.io/zh-cn/docs/open-api.html
-- 配置管理 ----------------------------------------- 
local configUrl = "/nacos/v1/cs/configs"
-- 获取配置
-- @param domain        nacos地址, 默认 http://127.0.0.1:8848
-- @param dataId        配置ID, 必填
-- @param tenant        命名空间, 默认 public
-- @param group         分组, 默认 DEFAULT_GROUP
function _M.get_config(domain, dataId, tenant, group)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end
    local url = (domain or default_domain) .. configUrl
    local params = "?dataId=" .. tostring(dataId) .. "&group=" .. tostring(group or default_group) .. "&tenant=" .. tostring(tenant or default_namespace)
    ngx.log(ngx.INFO, "【get nacos config】")
    return httpUtils.get(url, params)
end
-- 发布配置
-- @param domain        nacos地址, 默认 http://127.0.0.1:8848
-- @param dataId        配置ID, 必填
-- @param content       配置内容, 必填
-- @param tenant        命名空间, 默认 空
-- @param group         分组, 默认 DEFAULT_GROUP
-- @param type          配置类型, 非必填, 默认为text，可选[json、xml、yaml、html、properties]
function _M.push_config(domain, dataId, content, tenant, group, type)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end
    local url = (domain or default_domain) .. configUrl
    if dataId == nil then
        ngx.log(ngx.ERR, "nacos push config error: dataId is nil")
        return
    end
    if content == nil then
        ngx.log(ngx.ERR, "nacos push config error: content is nil")
        return
    end
    local params = "dataId=" .. tostring(dataId) .. "&group=" .. tostring(group or default_group) .. "&tenant=" .. tostring(tenant or '') .. "&content=" .. tostring(content) .. "&type=" .. tostring(type or "")
    ngx.log(ngx.INFO, "【push nacos config】")
    return httpUtils.post(url, params)
end
-- 删除配置
-- @param domain        nacos地址, 默认 http://
-- @param dataId        配置ID, 必填
-- @param tenant        命名空间, 默认 空
-- @param group         分组, 默认 DEFAULT_GROUP
function _M.delete_config(domain, dataId, tenant, group)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end
    local url = (domain or default_domain) .. configUrl
    local params = "dataId=" .. tostring(dataId) .. "&group=" .. tostring(group or default_group) .. "&tenant=" .. tostring(tenant or '')
    ngx.log(ngx.INFO, "【delete nacos config】")
    return httpUtils.delete(url, params)
end
-- 服务发现 -----------------------------------------
local instanceUrl = "/nacos/v1/ns/instance"
local serviceUrl = "/nacos/v1/ns/service"
-- 注册实例
-- @param domain        nacos地址, 默认 http://
-- @param ip            实例IP, 必填
-- @param port          实例端口, 必填
-- @param serviceName   服务名, 必填
-- @param namespaceId   命名空间, 默认 空
-- @param weight        权重, 非必填, 默认为1
-- @param enable        是否上线, 非必填, 默认为true
-- @param healthy       是否健康, 非必填, 默认为true
-- @param metadata      元数据, 非必填, 默认为{}
-- @param clusterName   集群名, 非必填, 默认为DEFAULT
-- @param groupName     分组名, 非必填, 默认为DEFAULT_GROUP
-- @param ephemeral     是否临时实例, 非必填, 默认为true.集群模式设置为false，单机模式不要设置
function _M.register_instance(domain, ip, port, serviceName, namespaceId, weight, enable, healthy, metadata, clusterName, groupName, ephemeral)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end
    local url = (domain or default_domain) .. instanceUrl
    if ip == nil or port == nil then
        ngx.log(ngx.ERR, "nacos register instance error: ip or port is nil")
        return
    end
    if serviceName == nil then
        ngx.log(ngx.ERR, "nacos register instance error: serviceName is nil")
        return
    end
    local params = "ip=" .. tostring(ip) .. "&port=" .. tostring(port) .. "&namespaceId=" .. tostring(namespaceId or '') .. "&weight=" .. tostring(weight or 1) .. "&enable=" .. tostring(enable or true) .. "&healthy=" .. tostring(healthy or true) .. "&metadata=" .. tostring(metadata or '') .. "&clusterName=" .. tostring(clusterName or '') .. "&serviceName=" .. tostring(serviceName) .. "&groupName=" .. tostring(groupName or default_group) .. "&ephemeral=" .. tostring(ephemeral or true)
    ngx.log(ngx.INFO, "【register nacos instance】")
    return httpUtils.post(url, params)
end

-- 注销实例
-- @param domain        nacos地址, 默认 http://
-- @param ip            实例IP, 必填
-- @param port          实例端口, 必填
-- @param serviceName   服务名, 必填
-- @param groupName     分组名, 非必填, 默认为DEFAULT_GROUP
-- @param namespaceId   命名空间, 默认 空
-- @param clusterName   集群名, 非必填, 默认为DEFAULT
-- @param ephemeral     是否临时实例, 非必填, 默认为true.集群模式设置为false，单机模式不要设置
function _M.deregister_instance(domain, ip, port, serviceName, groupName, namespaceId, clusterName, ephemeral)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end
    local url = (domain or default_domain) .. instanceUrl
    if ip == nil or port == nil then
        ngx.log(ngx.ERR, "nacos deregister instance error: ip or port is nil")
        return
    end
    if serviceName == nil then
        ngx.log(ngx.ERR, "nacos deregister instance error: serviceName is nil")
        return
    end
    local params = "ip=" .. tostring(ip) .. "&port=" .. tostring(port) .. "&namespaceId=" .. tostring(namespaceId or '') .. "&clusterName=" .. tostring(clusterName or '') .. "&serviceName=" .. tostring(serviceName) .. "&groupName=" .. tostring(groupName or default_group) .. "&ephemeral=" .. tostring(ephemeral or true)
    ngx.log(ngx.INFO, "【deregister nacos instance】")
    return httpUtils.delete(url, params)
end
-- 修改实例
-- @param domain        nacos地址, 默认 http://
-- @param ip            实例IP, 必填
-- @param port          实例端口, 必填
-- @param serviceName   服务名, 必填
-- @param namespaceId   命名空间, 默认 空
-- @param weight        权重, 非必填, 默认为1
-- @param enable        是否上线, 非必填, 默认为true
-- @param healthy       是否健康, 非必填, 默认为true
-- @param metadata      元数据, 非必填, 默认为{}
-- @param clusterName   集群名, 非必填, 默认为DEFAULT
-- @param groupName     分组名, 非必填, 默认为DEFAULT_GROUP
-- @param ephemeral     是否临时实例, 非必填, 默认为true.集群模式设置为false，单机模式不要设置
function _M.update_instance(domain, ip, port, serviceName, namespaceId, weight, enable, healthy, metadata, clusterName, groupName, ephemeral)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end
    local url = (domain or default_domain) .. instanceUrl
    if ip == nil or port == nil then
        ngx.log(ngx.ERR, "nacos update instance error: ip or port is nil")
        return
    end
    if serviceName == nil then
        ngx.log(ngx.ERR, "nacos update instance error: serviceName is nil")
        return
    end
    local params = "ip=" .. tostring(ip) .. "&port=" .. tostring(port) .. "&namespaceId=" .. tostring(namespaceId or default_namespace) .. "&weight=" .. tostring(weight or 1) .. "&enable=" .. tostring(enable or true) .. "&healthy=" .. tostring(healthy or true) .. "&metadata=" .. tostring(metadata or '') .. "&clusterName=" .. tostring(clusterName or '') .. "&serviceName=" .. tostring(serviceName) .. "&groupName=" .. tostring(groupName or default_group) .. "&ephemeral=" .. tostring(ephemeral or true)
    ngx.log(ngx.INFO, "【update nacos instance】")
    return httpUtils.put(url, params)
end
-- 查询实例列表
-- @param domain        nacos地址, 默认 http://
-- @param serviceName   服务名, 必填
-- @param namespaceId   命名空间, 默认 空
-- @param groupName     分组名, 非必填, 默认为DEFAULT_GROUP
-- @param clusters      集群名, 非必填, 默认为DEFAULT
-- @param healthyOnly   是否只返回健康实例, 非必填, 默认为false
function _M.get_instance_list(domain, serviceName, namespaceId, groupName, clusters, healthyOnly)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end
    local url = (domain or default_domain) .. instanceUrl .. "/list"
    if serviceName == nil then
        ngx.log(ngx.ERR, "nacos get instance list error: serviceName is nil")
        return
    end
    local params = "?serviceName=" .. tostring(serviceName) .. "&namespaceId=" .. tostring(namespaceId or '') .. "&groupName=" .. tostring(groupName or default_group) .. "&clusters=" .. tostring(clusters or '') .. "&healthyOnly=" .. tostring(healthyOnly or false)
    ngx.log(ngx.INFO, "【get nacos instance list】")
    return httpUtils.get(url, params)
end
-- 查询实例详情
-- @param domain        nacos地址, 默认 http://
-- @param ip            实例IP, 必填
-- @param port          实例端口, 必填
-- @param serviceName   服务名, 必填
-- @param namespaceId   命名空间, 默认 空
-- @param cluster       集群名, 非必填, 默认为DEFAULT
-- @param healthyOnly   是否只返回健康实例, 非必填, 默认为false
-- @param ephemeral     是否临时实例, 非必填, 默认为true.集群模式设置为false，单机模式不要设置
function _M.get_instance_detail(domain, ip, port, serviceName, namespaceId, cluster, healthyOnly, ephemeral)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end
    local url = (domain or default_domain) .. instanceUrl
    if ip == nil or port == nil then
        ngx.log(ngx.ERR, "nacos get instance detail error: ip or port is nil")
        return
    end
    if serviceName == nil then
        ngx.log(ngx.ERR, "nacos get instance detail error: serviceName is nil")
        return
    end
    local params = "?ip=" .. tostring(ip) .. "&port=" .. tostring(port) .. "&namespaceId=" .. tostring(namespaceId or default_namespace) .. "&cluster=" .. tostring(cluster or '') .. "&healthyOnly=" .. tostring(healthyOnly or false) .. "&ephemeral=" .. tostring(ephemeral or true) .. "&serviceName=" .. tostring(serviceName)
    ngx.log(ngx.INFO, "【get nacos instance detail】")
    return httpUtils.get(url, params)
end

-- 发送实例心跳
-- @param domain        nacos地址, 默认 http://
-- @param ip            实例IP, 必填
-- @param port          实例端口, 必填
-- @param serviceName   服务名, 必填
-- @param beat          心跳内容, 必填,JSON格式字符串
-- @param namespaceId   命名空间, 默认 空
-- @param groupName     分组名, 非必填, 默认为DEFAULT_GROUP
-- @param ephemeral     是否临时实例, 非必填, 默认为true.集群模式设置为false，单机模式不要设置
function _M.send_instance_beat(domain, ip, port, serviceName, beat, namespaceId, groupName, ephemeral)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end
    local url = (domain or default_domain) .. instanceUrl .. "/beat"
    if ip == nil or port == nil then
        ngx.log(ngx.ERR, "nacos send instance beat error: ip or port is nil")
        return
    end
    if serviceName == nil then
        ngx.log(ngx.ERR, "nacos send instance beat error: serviceName is nil")
        return
    end
    if beat == nil then
        ngx.log(ngx.ERR, "nacos send instance beat error: beat is nil")
        return
    end
    local params = "ip=" .. tostring(ip) .. "&port=" .. tostring(port) .. "&namespaceId=" .. tostring(namespaceId or default_namespace) .. "&groupName=" .. tostring(groupName or default_group) .. "&ephemeral=" .. tostring(ephemeral or true) .. "&serviceName=" .. tostring(serviceName) .. "&beat=" .. ngx.escape_uri(tostring(beat))
    ngx.log(ngx.INFO, "【send nacos instance beat】")
    return httpUtils.put(url, params)
end

-- 创建服务
-- @param domain            nacos地址, 默认 http://
-- @param serviceName       服务名, 必填
-- @param namespaceId       命名空间, 默认 空
-- @param groupName         分组名, 非必填, 默认为DEFAULT_GROUP
-- @param protectThreshold  保护阈值,取值0到1,默认0,浮点数
-- @param metadata          元数据, 非必填, 默认为{}
-- @param selector          服务选择器, 非必填, 默认为{}
function _M.create_service(domain, serviceName, namespaceId, groupName, protectThreshold, metadata, selector)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end
    local url = (domain or default_domain) .. serviceUrl
    if serviceName == nil then
        ngx.log(ngx.ERR, "nacos create service error: serviceName is nil")
        return
    end
    local params = "serviceName=" .. tostring(serviceName) .. "&namespaceId=" .. tostring(namespaceId or default_namespace) .. "&groupName=" .. tostring(groupName or default_group) .. "&protectThreshold=" .. tostring(protectThreshold or 0) .. "&metadata=" .. tostring(metadata or '') .. "&selector=" .. tostring(selector or '')
    ngx.log(ngx.INFO, "【create nacos service】")
    return httpUtils.post(url, params)
end
-- 删除服务
-- @param domain            nacos地址, 默认 http://
-- @param serviceName       服务名, 必填
-- @param namespaceId       命名空间, 默认 空
-- @param groupName         分组名, 非必填, 默认为DEFAULT_GROUP
function _M.delete_service(domain, serviceName, namespaceId, groupName)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end
    local url = (domain or default_domain) .. serviceUrl
    if serviceName == nil then
        ngx.log(ngx.ERR, "nacos delete service error: serviceName is nil")
        return
    end
    local params = "serviceName=" .. tostring(serviceName) .. "&namespaceId=" .. tostring(namespaceId or default_namespace) .. "&groupName=" .. tostring(groupName or default_group)
    ngx.log(ngx.INFO, "【delete nacos service】")
    return httpUtils.delete(url, params)
end
-- 修改服务
-- @param domain            nacos地址, 默认 http://
-- @param serviceName       服务名, 必填
-- @param namespaceId       命名空间, 默认 空
-- @param groupName         分组名, 非必填, 默认为DEFAULT_GROUP
-- @param protectThreshold  保护阈值,取值0到1,默认0,浮点数
-- @param metadata          元数据, 非必填, 默认为{}
-- @param selector          服务选择器, 非必填, 默认为{}
function _M.update_service(domain, serviceName, namespaceId, groupName, protectThreshold, metadata, selector)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end
    local url = (domain or default_domain) .. serviceUrl
    if serviceName == nil then
        ngx.log(ngx.ERR, "nacos update service error: serviceName is nil")
        return
    end
    local params = "serviceName=" .. tostring(serviceName) .. "&namespaceId=" .. tostring(namespaceId or default_namespace) .. "&groupName=" .. tostring(groupName or default_group) .. "&protectThreshold=" .. tostring(protectThreshold or 0) .. "&metadata=" .. tostring(metadata or '') .. "&selector=" .. tostring(selector or '')
    ngx.log(ngx.INFO, "【update nacos service】")
    return httpUtils.put(url, params)
end
-- 查询服务
-- @param domain            nacos地址, 默认 http://
-- @param serviceName       服务名, 必填
-- @param namespaceId       命名空间, 默认 空
-- @param groupName         分组名, 非必填, 默认为DEFAULT_GROUP
function _M.get_service(domain, serviceName, namespaceId, groupName)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end
    if serviceName == nil then
        ngx.log(ngx.ERR, "nacos get service error: serviceName is nil")
        return
    end
    local url = (domain or default_domain) .. serviceUrl
    local params = "?serviceName=" .. tostring(serviceName) .. "&namespaceId=" .. tostring(namespaceId or default_namespace) .. "&groupName=" .. tostring(groupName or default_group)
    ngx.log(ngx.INFO, "【get nacos service】")
    return httpUtils.get(url, params)
end
-- 查询服务列表
-- @param domain            nacos地址, 默认 http://
-- @param pageNo            页码, 非必填, 默认为1
-- @param pageSize          每页大小, 非必填, 默认为10
-- @param groupName         分组名, 非必填, 默认为DEFAULT_GROUP
-- @param namespaceId       命名空间, 默认 空
function _M.get_service_list(domain, pageNo, pageSize, groupName, namespaceId)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end
    local url = (domain or default_domain) .. serviceUrl .. "/list"
    local params = "?pageNo=" .. tostring(pageNo or 1) .. "&pageSize=" .. tostring(pageSize or 10) .. "&groupName=" .. tostring(groupName or default_group) .. "&namespaceId=" .. tostring(namespaceId or default_namespace)
    ngx.log(ngx.INFO, "【get nacos service list】")
    return httpUtils.get(url, params)
end
-- 查询系统开关
-- @param domain            nacos地址, 默认 http://
function _M.get_switches(domain)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end
    local url = (domain or default_domain) .. "/nacos/v1/ns/operator/switches"
    ngx.log(ngx.INFO, "【get nacos switches】")
    return httpUtils.get(url,nil)
end
-- 修改系统开关
-- @param domain            nacos地址, 默认 http://
-- @param entry             开关名, 必填
-- @param value             开关值, 必填
-- @param debug             是否开启debug, 非必填, 默认为false
function _M.update_switches(domain, entry, value, debug)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end
    if entry == nil then
        ngx.log(ngx.ERR, "nacos update switches error: entry is nil")
        return
    end
    if value == nil then
        ngx.log(ngx.ERR, "nacos update switches error: value is nil")
        return
    end
    local url = (domain or default_domain) .. "/nacos/v1/ns/operator/switches"
    local params = "entry=" .. tostring(entry) .. "&value=" .. tostring(value) .. "&debug=" .. tostring(debug or false)
    ngx.log(ngx.INFO, "【update nacos switches】")
    return httpUtils.put(url, params)
end
-- 查看系统当前数据指标
-- @param domain            nacos地址, 默认 http://
function _M.get_metrics(domain)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end
    local url = (domain or default_domain) .. "/nacos/v1/ns/operator/metrics"
    ngx.log(ngx.INFO, "【get nacos metrics】")
    return httpUtils.get(url,nil)
end
-- 查看当前集群Server列表
-- @param domain            nacos地址, 默认 http://]
-- @param healthy           是否只返回健康Server节点, 非必填, 默认为false
function _M.get_server_list(domain, healthy)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end
    local url = (domain or default_domain) .. "/nacos/v1/ns/operator/servers"
    local params = "?healthy=" .. tostring(healthy or false)
    ngx.log(ngx.INFO, "【get nacos server list】")
    return httpUtils.get(url, params)
end
-- 查看当前集群leader
-- @param domain            nacos地址, 默认 http://]
function _M.get_leader(domain)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end
    local url = (domain or default_domain) .. "/nacos/v1/ns/raft/leader"
    ngx.log(ngx.INFO, "【get nacos leader】")
    return httpUtils.get(url,nil)
end
-- 更新实例的健康状态
-- @param domain            nacos地址, 默认 http://]
-- @param serviceName       服务名, 必填
-- @param ip                实例IP, 必填
-- @param port              实例端口, 必填
-- @param healthy           是否健康, 非必填, 默认为true
-- @param namespaceId       命名空间, 默认 空
-- @param clusterName       集群名, 非必填, 默认为DEFAULT
-- @param groupName         分组名, 非必填, 默认为DEFAULT_GROUP
function _M.update_instance_healthy(domain, serviceName, ip, port, healthy, namespaceId, clusterName, groupName)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end
     if serviceName == nil then
        ngx.log(ngx.ERR, "nacos update instance healthy error: serviceName is nil")
        return
    end
    if ip == nil or port == nil then
        ngx.log(ngx.ERR, "nacos update instance healthy error: ip or port is nil")
        return
    end
    local url = (domain or default_domain) .. "/nacos/v1/ns/instance/health"
    local params = "serviceName=" .. tostring(serviceName) .. "&ip=" .. tostring(ip) .. "&port=" .. tostring(port) .. "&healthy=" .. tostring(healthy or true) .. "&namespaceId=" .. tostring(namespaceId or default_namespace) .. "&clusterName=" .. tostring(clusterName or '') .. "&groupName=" .. tostring(groupName or default_group)
    ngx.log(ngx.INFO, "【update nacos instance healthy】")
    return httpUtils.put(url, params)
end
-- 批量更新实例元数据(Beta)
-- @param domain            nacos地址, 默认 http://]
-- @param serviceName       服务名, 必填
-- @param namespaceId       命名空间, 必填
-- @param metadata          元数据, 必填, JSON格式字符串
-- @param instances         实例列表, 非必填, JSON格式字符串
-- @param consistencyType   实例的类型(ephemeral/persist), 非必填, 默认为ephemeral
function _M.batch_update_instance_metadata(domain, serviceName, namespaceId, metadata, instances, consistencyType)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end
     if serviceName == nil then
        ngx.log(ngx.ERR, "nacos batch update instance metadata error: serviceName is nil")
        return
    end
    if namespaceId == nil then
        ngx.log(ngx.ERR, "nacos batch update instance metadata error: namespaceId is nil")
        return
    end
    if metadata == nil then
        ngx.log(ngx.ERR, "nacos batch update instance metadata error: metadata is nil")
        return
    end
    local url = (domain or default_domain) .. "/nacos/v1/ns/instance/metadata/batch"
    local params = "serviceName=" .. tostring(serviceName) .. "&namespaceId=" .. tostring(namespaceId) .. "&metadata=" .. tostring(metadata) .. "&instances=" .. tostring(instances or '') .. "&consistencyType=" .. tostring(consistencyType or 'ephemeral')
    ngx.log(ngx.INFO, "【batch update nacos instance metadata】")
    return httpUtils.put(url, params)
end
-- 批量删除实例元数据(Beta)
-- @param domain            nacos地址, 默认 http://]
-- @param serviceName       服务名, 必填
-- @param namespaceId       命名空间, 必填
-- @param metadata          元数据, 必填, JSON格式字符串
-- @param instances         实例列表, 非必填, JSON格式字符串
-- @param consistencyType   实例的类型(ephemeral/persist), 非必填, 默认为ephemeral
function _M.batch_delete_instance_metadata(domain, serviceName, namespaceId, metadata, instances, consistencyType)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end
     if serviceName == nil then
        ngx.log(ngx.ERR, "nacos batch delete instance metadata error: serviceName is nil")
        return
    end
    if namespaceId == nil then
        ngx.log(ngx.ERR, "nacos batch delete instance metadata error: namespaceId is nil")
        return
    end
    if metadata == nil then
        ngx.log(ngx.ERR, "nacos batch delete instance metadata error: metadata is nil")
        return
    end
    local url = (domain or default_domain) .. "/nacos/v1/ns/instance/metadata/batch"
    local params = "serviceName=" .. tostring(serviceName) .. "&namespaceId=" .. tostring(namespaceId) .. "&metadata=" .. tostring(metadata) .. "&instances=" .. tostring(instances or '') .. "&consistencyType=" .. tostring(consistencyType or 'ephemeral')
    ngx.log(ngx.INFO, "【batch delete nacos instance metadata】")
    return httpUtils.delete(url, params)
end

-- 命名空间 --------------------------------------
local namespaceUrl = "/nacos/v1/console/namespaces"
-- 查询命名空间列表
-- @param domain            nacos地址, 默认 http://]
function _M.get_namespace_list(domain)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end 
    local url = (domain or default_domain) .. namespaceUrl .. "/names"
    ngx.log(ngx.INFO, "【get nacos namespace list】")
    return httpUtils.get(url,nil)
end
-- 创建命名空间
-- @param domain            nacos地址, 默认 http://]
-- @param customNamespaceId 命名空间ID, 必填
-- @param namespaceName     命名空间名称, 必填
-- @param namespaceDesc     命名空间描述, 非必填
function _M.create_namespace(domain, customNamespaceId, namespaceName, namespaceDesc)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end 
    if customNamespaceId == nil then
        ngx.log(ngx.ERR, "nacos create namespace error: customNamespaceId is nil")
        return
    end
    if namespaceName == nil then
        ngx.log(ngx.ERR, "nacos create namespace error: namespaceName is nil")
        return
    end
    local url = (domain or default_domain) .. namespaceUrl
    local params = "customNamespaceId=" .. tostring(customNamespaceId) .. "&namespaceName=" .. tostring(namespaceName) .. "&namespaceDesc=" .. tostring(namespaceDesc or '')
    ngx.log(ngx.INFO, "【create nacos namespace】")
    return httpUtils.post(url, params)
end
-- 修改命名空间
-- @param domain            nacos地址, 默认 http://]
-- @param namespace         命名空间ID, 必填
-- @param namespaceShowName 命名空间名称, 必填
-- @param namespaceDesc     命名空间描述, 必填
function _M.update_namespace(domain, namespace, namespaceShowName, namespaceDesc)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end 
    if namespace == nil then
        ngx.log(ngx.ERR, "nacos update namespace error: namespace is nil")
        return
    end
    if namespaceShowName == nil then
        ngx.log(ngx.ERR, "nacos update namespace error: namespaceShowName is nil")
        return
    end
    local url = (domain or default_domain) .. namespaceUrl
    local params = "namespace=" .. tostring(namespace) .. "&namespaceShowName=" .. tostring(namespaceShowName) .. "&namespaceDesc=" .. tostring(namespaceDesc or '')
    ngx.log(ngx.INFO, "【update nacos namespace】")
    return httpUtils.put(url, params)
end
-- 删除命名空间
-- @param domain            nacos地址, 默认 http://]
-- @param namespaceId       命名空间ID, 必填
function _M.delete_namespace(domain, namespaceId)
    if domain == nil then
        ngx.log(ngx.ERR, "nacos push config error: domain is nil")
        return
    end 
    if namespaceId == nil then
        ngx.log(ngx.ERR, "nacos delete namespace error: namespaceId is nil")
        return
    end
    local url = (domain or default_domain) .. namespaceUrl
    local params = "namespaceId=" .. tostring(namespaceId)
    ngx.log(ngx.INFO, "【delete nacos namespace】")
    return httpUtils.delete(url, params)
end

return _M