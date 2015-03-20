request = require "request"
config = require "./../config/config.json"
class WeixinCtrl
  @jsapiSign:(ent,posturl,fn) ->
    url = "#{config.weixin.host}:#{config.weixin.port}/weixin/jsapisign/#{ent}"
    request {url,timeout:3000,method:"POST",form:{url:posturl}},(err,response,body) ->
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

  @getOpenid:(ent,code,fn) ->
    url = "#{config.weixin.host}:#{config.weixin.port}/weixin/codeAccesstoken/#{ent}?code=#{code}"
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
module.exports = WeixinCtrl