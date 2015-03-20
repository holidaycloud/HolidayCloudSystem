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