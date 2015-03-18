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

exports.dologout = (req,res) ->
  res.clearCookie "token"
  res.clearCookie "tokenExpires"
  delete req.session.member
  res.redirect "/"
