// Generated by CoffeeScript 1.8.0
(function() {
  var MemberCtrl;

  MemberCtrl = require("./../ctrl/memberCtrl");

  exports.dologin = function(req, res) {
    var passwd, userName;
    userName = req.body.userName;
    passwd = req.body.passwd;
    return MemberCtrl.login(userName, passwd, function(err, results) {
      if (err) {
        return res.redirect("/");
      } else {
        res.cookie("token", results.data.token);
        res.cookie("tokenExpires", results.data.expireDate);
        req.flash("token", results.data.token);
        req.flash("tokenExpires", results.data.expireDate);
        return res.redirect("/");
      }
    });
  };

  exports.dobind = function(req, res) {
    var openid, passwd, userName;
    userName = req.body.userName;
    passwd = req.body.passwd;
    openid = req.body.openid;
    console.log(userName, passwd, openid);
    return res.json({
      error: 0,
      errMsg: "用户名或密码错误！"
    });
  };

  exports.dologout = function(req, res) {
    res.clearCookie("token");
    res.clearCookie("tokenExpires");
    delete req.session.member;
    return res.redirect("/");
  };

}).call(this);
