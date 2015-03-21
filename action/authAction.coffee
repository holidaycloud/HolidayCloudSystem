MemberCtrl = require "./../ctrl/memberCtrl"
exports.auth = (req,res,next) ->
  console.log "-----------starting auth---------------"
  token = req.cookies.token or req.flash "token"
  tokenExpires = req.cookies.tokenExpires or req.flash "tokenExpires"
  if token? and tokenExpires > Date.now()
    req.session.flash = {}
    MemberCtrl.memberInfo token,(err,results) ->
      if results.data?
        console.log "-----------auth success---------------"
        req.session.member = results.data.member
        next()
      else
        console.log "-----------auth failed---------------"
        res.render "login"
  else
    console.log "-----------auth failed---------------"
    res.render "login"