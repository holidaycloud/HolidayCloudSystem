MemberCtrl = require "./../ctrl/memberCtrl"
exports.dologin = (req,res) ->
  userName = req.body.userName
  passwd = req.body.passwd
  MemberCtrl.login userName,passwd,(err,results) ->
    if err
      res.redirect "/"
    else
      res.cookie "token",results.data.token
      res.cookie "tokenExpires",results.data.expireDate
      req.flash "token",results.data.token
      req.flash "tokenExpires",results.data.expireDate
      res.redirect "/"

exports.dobind = (req,res) ->
  userName = req.body.userName
  passwd = req.body.passwd
  openid = req.body.openid
  MemberCtrl.weixinBind userName,passwd,openid,(err,res) ->
    console.log err,res
    res.json {error:0,errMsg:"用户名或密码错误！"}

exports.dologout = (req,res) ->
  res.clearCookie "token"
  res.clearCookie "tokenExpires"
  delete req.session.member
  res.redirect "/"
#https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx56f37f15c380728b&redirect_uri=http%3A%2F%2Ftest.meitrip.net%2fcoupons&response_type=code&scope=snsapi_base&state=coupons#wechat_redirect