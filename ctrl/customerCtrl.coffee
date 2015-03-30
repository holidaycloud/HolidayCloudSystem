request = require "request"
config = require "./../config/config.json"
async = require "async"
Q = require "q"
Marketing = require "./../config/marketing.json"
class CustomerCtrl
  @locations:(ent,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/api/customer/customerLocations?ent=#{ent}"
    request {url,timeout:3000,method:"GET"},(err,response,body) ->
      if err
        fn err
      else
        try
          res = JSON.parse(body)
          if res.error? is 1
            fn new Error(res.errMsg)
          else
            fn null,res.data
        catch error
          fn new Error("Parse Error")

  @updateLocation:(openid,lat,lon,fn) ->
    async.auto {
      customerInfo:(cb) ->
        url = "#{config.inf.host}:#{config.inf.port}/api/customer/weixinLogin?ent=#{global.weixinEnt}&openId=#{openid}"
        request {url,timeout:3000,method:"GET"},(err,response,body) ->
          if err
            cb err
          else
            try
              res = JSON.parse(body)
              if res.error is 1
               cb new Error(res.errMsg)
              else
                cb res.data
            catch error
              cb new Error("Parse Error")
      ,update:["customerInfo",(cb,results) ->
        customer = results.customerInfo
        url = "#{config.inf.host}:#{config.inf.port}/api/customer/updateLocation"
        request {url,timeout:3000,method:"POST",form:{id:customer._id,lat,lon}},(err,response,body) ->
          if err
            fn err
          else
            try
              res = JSON.parse(body)
              if res.error? is 1
                fn new Error(res.errMsg)
              else
                fn null,res.data
            catch error
              fn new Error("Parse Error")
      ]
    },(err,results) ->


  @list:(ent,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/api/customer/fulllist?ent=#{ent}"
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

  ###
    TODO:浏河临时活动
  ###
  #public static method
  @detail:(id,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/api/customer/detail?id=#{id}"
    request {url,timeout:3000,method:"GET"},(err,response,body) ->
      if err
        fn err
      else
        try
          res = JSON.parse(body)
          if res.error is 1
            fn new Error(res.errMsg)
          else
            fn null,res
        catch error
          fn new Error("Parse Error")

  @weixinSubscribe:(openid,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/api/customer/weixinSubscribe"
    request {url,timeout:3000,method:"POST",form: {ent:global.weixinEnt,openid}},(err,response,body) ->
      if err
        fn err
      else
        try
          res = JSON.parse(body)
          if res.error is 1
            fn new Error(res.errMsg)
          else
            fn null,res
        catch error
          fn new Error("Parse Error")

  @weixinSubscribeAndCoupon:(openid,from,scene,fn) ->
    _this = @
    async.series([
      (cb) ->
        _this.weixinSubscribe openid,(err,res) ->
          cb err,res
      ,(cb) ->
        _this.weixinCoupon openid,from,scene.replace("qrscene_",""),(err,res) ->
          cb err,res
    ],(err,results) ->
      fn null,results[1]
    )

  @weixinCoupon:(openid,from,sceneid,fn) ->
    _getCustomerInfo openid
    .then(
      (customer) ->
          _getCoupon customer._id,Marketing[sceneid].id
      ,(err) ->
        fn err
      )
    .then(
      (coupon) ->
        fn null,"""
                <xml>
                <ToUserName><![CDATA[#{openid}]]></ToUserName>
                <FromUserName><![CDATA[#{from}]]></FromUserName>
                <CreateTime>#{Date.now()}</CreateTime>
                <MsgType><![CDATA[news]]></MsgType>
                <ArticleCount>1</ArticleCount>
                <Articles>
                <item>
                <Title><![CDATA[您获得一张优惠券]]></Title>
                <Description><![CDATA[#{coupon.data.name}]]></Description>
                <PicUrl><![CDATA[#{Marketing[sceneid].image}]]></PicUrl>
                <Url><![CDATA[http://test.meitrip.net/couponDetail?id=#{coupon.data._id}]]></Url>
                </item>
                </Articles>
                </xml>
                """
      ,(err) ->
        fn err
      )
    .catch (err) ->
      fn err

  #private method
  _getCustomerInfo = (openid) ->
    deferred = Q.defer()
    url = "#{config.inf.host}:#{config.inf.port}/api/customer/weixinLogin?ent=#{global.weixinEnt}&openId=#{openid}"
    request {url,timeout:3000,method:"GET"},(err,response,body) ->
      if err
        deferred.reject err
      else
        try
          res = JSON.parse(body)
          if res.error is 1
            deferred.reject new Error(res.errMsg)
          else
            deferred.resolve res.data
        catch error
          deferred.reject new Error("Parse Error")
    deferred.promise

  _getCoupon = (customer,marketing) ->
    deferred = Q.defer()
    url = "#{config.inf.host}:#{config.inf.port}/api/coupon/give"
    request {url,timeout:3000,method:"POST",form:{ent:global.weixinEnt,customer,marketing}},(err,response,body) ->
      if err
        deferred.reject err
      else
        try
          res = JSON.parse(body)
          if res.error is 1
            deferred.reject new Error(res.errMsg)
          else
            deferred.resolve res
        catch error
          deferred.reject new Error("Parse Error")
    deferred.promise

module.exports = CustomerCtrl
