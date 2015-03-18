class SettingCtrl
  request = require "request"
  config = require "./../config/config.json"
  @webConfigDetail:(ent,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/api/domain/detail?ent=#{ent}"
    request {url,timeout:3000,method:"GET"},(err,response,body) ->
      if err
        fn err
      else
        try
          res = JSON.parse(body)
          if res.error? is 1
            fn new Error(res.errMsg)
          else
            fn null,res
        catch error
          fn new Error("Parse Error")

  @weixinConfigDetail:(ent,fn) ->
    url = "#{config.weixin.host}:#{config.weixin.port}/weixin/configDetail/#{ent}"
    request {url,timeout:3000,method:"GET"},(err,response,body) ->
      if err
        fn err
      else
        try
          res = JSON.parse(body)
          if res.error? is 1
            fn new Error(res.errMsg)
          else
            fn null,res
        catch error
          fn new Error("Parse Error")
module.exports = SettingCtrl