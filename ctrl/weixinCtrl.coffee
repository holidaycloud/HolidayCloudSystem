request = require "request"
config = require "./../config/config.json"
Q = require "q"
CustomerCtrl = require "./customerCtrl"
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
    console.log signature,timestamp,nonce,msg
    url = "#{config.weixin.host}:#{config.weixin.port}/weixin/#{global.weixinEnt}"
    request {url,timeout:3000,method:"POST",form: {signature,timestamp,nonce,msg}},(err,response,body) ->
      console.log err,body
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
        if msgObj.xml.EventKey?
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
      else
        fn null,""

  @text:(msgObj,fn) ->
    fn null,""

module.exports = WeixinCtrl