
local _M = { _VERSION = '0.0.1' }

local http = require "resty.http"
local httpc,err = http.new()
if not httpc then
    ngx.log(ngx.ERR, "failed to instantiate http: ", err)
    return
end

function _M.get(url, params)
    ngx.log(ngx.INFO, "get ==> ", url .. (params or ''))
    local res, err = httpc:request_uri(url .. (params or ''), {
        method = "GET",
        headers = {
            ["Content-Type"] = "application/x-www-form-urlencoded",
        },
        ssl_verify = false
    })
    if not res then
        ngx.log(ngx.ERR, "nacos get request error: ", err)
        return
    end
    return res.body
end

function _M.post(url, body)
    ngx.log(ngx.INFO, "post ==> ", url .. ",body=" .. (body or ''))
    local res, err = httpc:request_uri(url,{
        method = "POST",
        body = body,
        headers = {
            ["Content-Type"] = "application/x-www-form-urlencoded",
        },
        ssl_verify = false
    })
    if not res then
        ngx.log(ngx.ERR, "nacos post request error: ", err)
        return
    end
    return res.body
end

function _M.delete(url, body)
    ngx.log(ngx.INFO, "delete ==> ", url .. ",body=" .. (body or ''))
    local res, err = httpc:request_uri(url,{
        method = "DELETE",
        body = body,
        headers = {
            ["Content-Type"] = "application/x-www-form-urlencoded",
        },
        ssl_verify = false
    })
    if not res then
        ngx.log(ngx.ERR, "nacos delete request error: ", err)
        return
    end
    return res.body
end

function _M.put(url, body)
    ngx.log(ngx.INFO, "put ==> ", url .. ",body=" .. (body or ''))
    local res, err = httpc:request_uri(url,{
        method = "PUT",
        body = body,
        headers = {
            ["Content-Type"] = "application/x-www-form-urlencoded",
        },
        ssl_verify = false
    })
    if not res then
        ngx.log(ngx.ERR, "nacos put request error: ", err)
        return
    end
    return res.body
end

return _M