request = require "request"
config = require "./../config/config.json"
MemberCtrl = require "./memberCtrl"
async = require "async"
class CouponCtrl

  @list:(ent,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/api/coupon/fulllist?ent=#{ent}"
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

  @ajaxList:(ent,start,length,order,dir,search,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/api/coupon/customlist?ent=#{ent}&start=#{start}&length=#{length}&order=#{order}&dir=#{dir}&search=#{search}"
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

  @use:(id,openid,fn) ->
    console.log id
    async.auto {
      getMember:(cb) ->
        MemberCtrl.weixinLogin openid,(err,res) ->
          cb err,res
      couponUse:["getMember",(cb,results) ->
        member = results.getMember?.data
        if member?
          url = "#{config.inf.host}:#{config.inf.port}/api/coupon/scanUse"
          request {url,timeout:3000,method:"POST",form:{id}},(err,response,body) ->
            if err
              cb err
            else
              try
                res = JSON.parse(body)
                if res.error is 1
                  cb new Error(res.errMsg)
                else
                  cb null,res
              catch error
                cb new Error "Parse Error"
        else
          cb new Error "请先绑定账户"
      ]
    },(err,results) ->
      fn err,results.couponUse

module.exports = CouponCtrl