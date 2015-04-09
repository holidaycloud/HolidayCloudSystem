request = require "request"
config = require "./../config/config.json"
MemberCtrl = require "./memberCtrl"
CustomerCtrl = require "./customerCtrl"
async = require "async"
class CouponCtrl
  @pieAnalysis:(ent,fn) ->
    _this = @
    async.parallel [
      (cb) ->
        _this.count ent,"noreceived",(err,res) ->
          cb err,res
      ,(cb) ->
        _this.count ent,"received",(err,res) ->
          cb err,res
      ,(cb) ->
        _this.count ent,"used",(err,res) ->
          cb err,res
    ],(err,results) ->
      if err
        fn err
      else
        fn err,results

  @count:(ent,type,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/api/coupon/count?ent=#{ent}&type=#{type}"
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

  @marketingList:(marketing,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/api/coupon/marketList?marketing=#{marketing}"
    request {url,method:"GET"},(err,response,body) ->
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

  @list:(ent,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/api/coupon/fulllist?ent=#{ent}"
    request {url,method:"GET"},(err,response,body) ->
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
      ,getCoupon:["couponUse",(cb) ->
        _this.detail id,(err,res) ->
          cb null,res
      ]
      ,getCustomer:["getCoupon",(cb,results) ->
        coupon = results.getCoupon.data
        CustomerCtrl.detail coupon.customer,(err,res) ->
          cb null,res
      ]
      ,sendTemplate:["getCoupon","couponUse","getCustomer",(cb,results) ->
        coupon = results.getCoupon.data
        customer = results.getCustomer?.data
        if customer
          tempId = "wij1QbErYRCBnewBVFgzqh2UiHCYau3qFxexGx-0Qos"
          toUser = customer.weixinOpenId
          couponId = coupon._id
          name = coupon.name
          entName = coupon.ent.name
          useDate = new Date(coupon.useTime).Format("yyyy-MM-dd hh:mm:ss")
          remark = "感谢您的支持"
          url = "#{config.weixin.host}:#{config.weixin.port}/weixin/sendCouponTemplate/#{global.weixinEnt}"
          request {url,timeout:3000,method:"POST",form:{tempId,toUser,couponId,name,entName,useDate,remark}},(err,response,body) ->
           if err
             console.log err
             cb null
           else
             try
               res = JSON.parse(body)
               if res.error? is 1
                 console.log new Error(res.errMsg)
                 cb null
               else
                 cb null,res
             catch error
               console.log new Error("Parse Error")
               cb null
        else
          cb null
      ]
    },(err,results) ->
      console.log results
      fn err,results.couponUse

module.exports = CouponCtrl