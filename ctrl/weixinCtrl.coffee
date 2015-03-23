request = require "request"
config = require "./../config/config.json"
Q = require "q"
CustomerCtrl = require "./customerCtrl"
CouponCtrl = require "./couponCtrl"
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

  @sendCT:(ent,tempId,toUser,couponId,name,entName,useDate,remark,fn) ->
    url = "#{config.weixin.host}:#{config.weixin.port}/weixin/sendCouponTemplate/#{ent}"
    request {url,timeout:3000,method:"POST",form:{tempId,toUser,couponId,name,entName,useDate,remark}},(err,response,body) ->
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
  @check:(signature,timestamp,nonce,echostr,fn) ->
    url = "#{config.weixin.host}:#{config.weixin.port}/weixin/#{global.weixinEnt}?signature=#{signature}&timestamp=#{timestamp}&nonce=#{nonce}&echostr=#{echostr}"
    request {url,timeout:3000,method:"GET"},(err,response,body) ->
      if err
        fn err
      else
        fn null,body

  @msg:(signature,timestamp,nonce,msg,fn) ->
    url = "#{config.weixin.host}:#{config.weixin.port}/weixin/#{global.weixinEnt}"
    request {url,timeout:3000,method:"POST",form: {signature,timestamp,nonce,msg}},(err,response,body) ->
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

  @event:(msgObj,fn) ->
    eventType = msgObj.xml.Event[0]
    switch eventType
      when "subscribe"
        if msgObj.xml.EventKey[0].indexOf("qrscene")>-1
          CustomerCtrl.weixinSubscribeAndCoupon msgObj.xml.FromUserName[0],msgObj.xml.ToUserName[0],msgObj.xml.EventKey[0],(err,res) ->
            fn err,res
        else
          CustomerCtrl.weixinSubscribe msgObj.xml.FromUserName[0],(err,res) ->
            fn err,res
      when "SCAN" then CustomerCtrl.weixinCoupon msgObj.xml.FromUserName[0],msgObj.xml.ToUserName[0],msgObj.xml.EventKey[0],(err,res) ->
        if err
          fn null,"""
                    <xml>
                    <ToUserName><![CDATA[#{msgObj.xml.FromUserName[0]}]]></ToUserName>
                    <FromUserName><![CDATA[#{msgObj.xml.ToUserName[0]}]]></FromUserName>
                    <CreateTime>#{Date.now()}</CreateTime>
                    <MsgType><![CDATA[text]]></MsgType>
                    <Content><![CDATA[#{err.message}]]></Content>
                    </xml>
                    """
        else
          fn null,res
      when "scancode_waitmsg" then CouponCtrl.use msgObj.xml.ScanCodeInfo[0].ScanResult[0],msgObj.xml.FromUserName[0],(err,res) ->
        console.log err,res
        if err
          fn null,"""
                    <xml>
                    <ToUserName><![CDATA[#{msgObj.xml.FromUserName[0]}]]></ToUserName>
                    <FromUserName><![CDATA[#{msgObj.xml.ToUserName[0]}]]></FromUserName>
                    <CreateTime>#{Date.now()}</CreateTime>
                    <MsgType><![CDATA[text]]></MsgType>
                    <Content><![CDATA[#{err.message}]]></Content>
                    </xml>
                    """
        else
          fn null,"""
                    <xml>
                    <ToUserName><![CDATA[#{msgObj.xml.FromUserName[0]}]]></ToUserName>
                    <FromUserName><![CDATA[#{msgObj.xml.ToUserName[0]}]]></FromUserName>
                    <CreateTime>#{Date.now()}</CreateTime>
                    <MsgType><![CDATA[text]]></MsgType>
                    <Content><![CDATA[优惠券:#{res.data.code}使用成功。\n使用时间:#{new Date(res.data.useTime).Format("yyyy-MM-dd hh:mm:ss")}]]></Content>
                    </xml>
                    """
      else
        fn null,""

  @text:(msgObj,fn) ->
    fn null,""

module.exports = WeixinCtrl