MemberCtrl = require "./../ctrl/memberCtrl"
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

