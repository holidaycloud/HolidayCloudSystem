request = require "request"
config = require "./../config/config.json"
MemberCtrl = require "./memberCtrl"
CustomerCtrl = require "./customerCtrl"
WeixinCtrl = require "./weixinCtrl"
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
  @detail:(id,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/api/coupon/detail?id=#{id}"
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
    _this = @
    console.log id,openid
    async.auto {
      getMember:(cb) ->
        MemberCtrl.weixinLogin openid,(err,res) ->
          cb err,res
      couponUse:["getMember",(cb,results) ->
        member = results.getMember?.data
        console.log """
                      ----------------------------
                      #{JSON.stringify member}
                      ----------------------------
                     """
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
      ,getCoupon:(cb) ->
        _this.detail id,(err,res) ->
          cb err,res
      ,getCustomer:["getCoupon",(cb,results) ->
        coupon = results.getCoupon.data
        CustomerCtrl.detail coupon.customer,(err,res) ->
          cb err,res
      ]
      ,sendTemplate:["getCoupon","couponUse","getCustomer",(cb,results) ->
        console.log "-----------------",WeixinCtrl,"-------------------------"
        cb null
#        useResult = results.couponUse
#        if useResult?
#          coupon = results.getCoupon.data
#          customer = results.getCustomer.data
#          WeixinCtrl.sendCT global.weixinEnt,"wij1QbErYRCBnewBVFgzqh2UiHCYau3qFxexGx-0Qos",customer.weixinOpenId,coupon._id,coupon.name,coupon.ent.name,new Date(coupon.useTime).Format("yyyy-MM-dd hh:mm:ss"),"感谢您的支持",(err,res) ->
#            cb err,res
#        else
#          cb null,null
      ]
    },(err,results) ->
      console.log results
      fn err,results.couponUse

module.exports = CouponCtrl