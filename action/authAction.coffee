MemberCtrl = require "./../ctrl/memberCtrl"
exports.auth = (req,res,next) ->
  token = req.cookies.token or req.flash "token"
  tokenExpires = req.cookies.tokenExpires or req.flash "tokenExpires"
  if token? and tokenExpires > Date.now()
    req.session.flash = {}
    MemberCtrl.memberInfo token,(err,results) ->
      if results.data?
        req.session.member = results.data.member
        next()
      else
        res.json {error:502}
  else
    res.json {error:502}