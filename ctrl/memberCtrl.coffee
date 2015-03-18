class MemberCtrl
  request = require "request"
  config = require "./../config/config.json"

  @login:(mobile,passwd,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/api/member/login?mobile=#{mobile}&passwd=#{passwd.toLowerCase()}"
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

  @memberInfo:(token,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/api/member/token?token=#{token}"
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

  @fulllist:(ent,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/api/member/fulllist?ent=#{ent}"
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

module.exports = MemberCtrl