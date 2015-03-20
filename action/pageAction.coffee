MemberCtrl = require "./../ctrl/memberCtrl"
WeixinCtrl = require "./../ctrl/weixinCtrl"
async = require "async"
exports.index = (req,res) ->
  token = req.cookies.token or req.flash "token"
  tokenExpires = req.cookies.tokenExpires or req.flash "tokenExpires"
  if token? and tokenExpires > Date.now()
    req.session.flash = {}
    MemberCtrl.memberInfo token,(err,results) ->
      if results.data?
        req.session.member = results.data.member
        res.render "index",{member:results.data.member}
      else
        res.render "login"
  else
    res.render "login"

exports.bind = (req,res) ->
  async.parallel [
    (cb) ->
#      WeixinCtrl.getOpenid weixinEnt,code,(err,results) ->
#        cb err,results
        cb null,"123123123123123"
    ,(cb) ->
      url = "http://#{req.hostname}#{req.url}"
      WeixinCtrl.jsapiSign weixinEnt,url,(err,results) ->
        cb err,results
  ]
  ,(err,results) ->
    console.log err,results
    res.render "weixinBind",weixin:results[1].data,openid:results[0]

###
  TODO:浏河临时活动
###
#private method
_getOpenid = (code) ->
  deferred = Q.defer()
  url = "#{config.weixin.host}:#{config.weixin.port}/weixin/codeAccesstoken/#{global.ent}?code=#{code}"
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

_getCustomerInfo = (openid) ->
  deferred = Q.defer()
  url = "#{config.inf.host}:#{config.inf.port}/api/customer/weixinLogin?ent=#{global.ent}&openId=#{openid}"
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

_getCoupons = (customer) ->
  deferred = Q.defer()
  url = "#{config.inf.host}:#{config.inf.port}/api/coupon/customerCoupons?ent=#{global.ent}&customer=#{customer}&status=0"
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

_couponDetail = (id) ->
  deferred = Q.defer()
  url = "#{config.inf.host}:#{config.inf.port}/api/coupon/detail?id=#{id}"
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

_createQrcode = (id) ->
  deferred = Q.defer()
  QRCode.toDataURI "http://test.meitrip.net/couponuse?id=#{id}",(err,url) ->
    if err
      deferred.reject err
    else
      deferred.resolve url
  deferred.promise

_couponUse = (id) ->
  deferred = Q.defer()
  url = "#{config.inf.host}:#{config.inf.port}/api/coupon/scanUse"
  request {url,timeout:3000,method:"POST",form:{id}},(err,response,body) ->
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

exports.coupons = (req,res) ->
  code = req.query.code
  state = req.query.state
  _getOpenid(code).then(
    (openid) ->
      _getCustomerInfo(openid.openid)
    ,(err) ->
      console.log err
      res.status(500).end()
  ).then(
    (customer) ->
      _getCoupons(customer._id)
    ,(err) ->
      console.log err
      res.status(500).end()
  ).then(
    (coupons) ->
      res.render "coupons",{coupons}
    (err) ->
      console.log err
      res.status(500).end()
  ).catch (err) ->
    console.log err
    res.status(500).end()

exports.couponDetail = (req,res) ->
  id = req.query.id
  url=""
  _createQrcode(id).then(
    (u) ->
      url = u
      _couponDetail(id)
    ,(err) ->
      console.log err
      res.status(500).end()
  ).then(
    (coupon) ->
      res.render "couponDetail",{coupon,url}
    ,(err) ->
      console.log err
      res.status(500).end()
  )

exports.couponuse = (req,res) ->
  if req.headers["user-agent"].indexOf("MicroMessenger")>-1
    id = req.query.id
    _couponUse(id).then(
      (coupon) ->
        res.render "useResult",{result:true,coupon}
      ,(err) ->
        res.render "useResult",{result:false,message:err.message}
      )
  else
    res.render "useResult",{result:false,message:"请使用微信扫一扫"}