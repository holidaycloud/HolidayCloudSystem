request = require "request"
config = require "./../config/config.json"
async = require "async"
Q = require "q"
class CustomerCtrl
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
      console.log "---------------------------------\n",err,results,"\n---------------------------------"
      coupon = results[1]
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
                <PicUrl><![CDATA[http://test.meitrip.net/images/coupon.jpg]]></PicUrl>
                <Url><![CDATA[http://test.meitrip.net/couponDetail?id=#{coupon.data._id}]]></Url>
                </item>
                </Articles>
                </xml>
                """
    )

  @weixinCoupon:(openid,from,sceneid,fn) ->
    _getCustomerInfo openid
    .then(
      (customer) ->
        if parseInt(sceneid) is 99999
          _getCoupon customer._id,"54fa5b5f7284d93d4a49a19a"
        else
          _getCoupon customer._id,"54fa82d751abf6d65a37dd37"
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
                <PicUrl><![CDATA[http://test.meitrip.net/images/coupon.jpg]]></PicUrl>
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