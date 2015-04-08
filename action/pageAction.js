// Generated by CoffeeScript 1.8.0
(function() {
  var MarketingImg, MemberCtrl, Q, QRCodeExtend, WeixinCtrl, async, config, request, _couponDetail, _couponUse, _createQrcode, _getCoupons, _getCustomerInfo, _getOpenid;

  MemberCtrl = require("./../ctrl/memberCtrl");

  WeixinCtrl = require("./../ctrl/weixinCtrl");

  Q = require("q");

  QRCodeExtend = require("./../tools/qrcodeExtend");

  config = require("./../config/config.json");

  MarketingImg = require("./../config/marketingImg.json");

  request = require("request");

  async = require("async");

  exports.index = function(req, res) {
    var token, tokenExpires;
    token = req.cookies.token || req.flash("token");
    tokenExpires = req.cookies.tokenExpires || req.flash("tokenExpires");
    if ((token != null) && tokenExpires > Date.now()) {
      req.session.flash = {};
      return MemberCtrl.memberInfo(token, function(err, results) {
        if (results.data != null) {
          req.session.member = results.data.member;
          return res.render("index", {
            member: results.data.member
          });
        } else {
          return res.render("login");
        }
      });
    } else {
      return res.render("login");
    }
  };

  exports.bind = function(req, res) {
    var code, state;
    code = req.query.code;
    state = req.query.state;
    return async.parallel([
      function(cb) {
        return WeixinCtrl.getOpenid(weixinEnt, code, function(err, results) {
          return cb(err, results);
        });
      }, function(cb) {
        var url;
        url = "http://" + req.hostname + req.url;
        return WeixinCtrl.jsapiSign(weixinEnt, url, function(err, results) {
          return cb(err, results);
        });
      }
    ], function(err, results) {
      var _ref;
      console.log(err, results);
      return res.render("weixinBind", {
        weixin: results[1].data,
        openid: (_ref = results[0].data) != null ? _ref.openid : void 0
      });
    });
  };


  /*
    TODO:浏河临时活动
   */

  _getOpenid = function(code) {
    var deferred, url;
    deferred = Q.defer();
    url = "" + config.weixin.host + ":" + config.weixin.port + "/weixin/codeAccesstoken/" + global.weixinEnt + "?code=" + code;
    request({
      url: url,
      timeout: 3000,
      method: "GET"
    }, function(err, response, body) {
      var error, res;
      if (err) {
        return deferred.reject(err);
      } else {
        try {
          res = JSON.parse(body);
          if (res.error === 1) {
            return deferred.reject(new Error(res.errMsg));
          } else {
            return deferred.resolve(res.data);
          }
        } catch (_error) {
          error = _error;
          return deferred.reject(new Error("Parse Error"));
        }
      }
    });
    return deferred.promise;
  };

  _getCustomerInfo = function(openid) {
    var deferred, url;
    deferred = Q.defer();
    url = "" + config.inf.host + ":" + config.inf.port + "/api/customer/weixinLogin?ent=" + global.weixinEnt + "&openId=" + openid;
    request({
      url: url,
      timeout: 3000,
      method: "GET"
    }, function(err, response, body) {
      var error, res;
      if (err) {
        return deferred.reject(err);
      } else {
        try {
          res = JSON.parse(body);
          if (res.error === 1) {
            return deferred.reject(new Error(res.errMsg));
          } else {
            return deferred.resolve(res.data);
          }
        } catch (_error) {
          error = _error;
          return deferred.reject(new Error("Parse Error"));
        }
      }
    });
    return deferred.promise;
  };

  _getCoupons = function(customer) {
    var deferred, url;
    deferred = Q.defer();
    url = "" + config.inf.host + ":" + config.inf.port + "/api/coupon/customerCoupons?ent=" + global.weixinEnt + "&customer=" + customer;
    request({
      url: url,
      timeout: 3000,
      method: "GET"
    }, function(err, response, body) {
      var error, res;
      if (err) {
        return deferred.reject(err);
      } else {
        try {
          res = JSON.parse(body);
          if (res.error === 1) {
            return deferred.reject(new Error(res.errMsg));
          } else {
            return deferred.resolve(res.data);
          }
        } catch (_error) {
          error = _error;
          return deferred.reject(new Error("Parse Error"));
        }
      }
    });
    return deferred.promise;
  };

  _couponDetail = function(id) {
    var deferred, url;
    deferred = Q.defer();
    url = "" + config.inf.host + ":" + config.inf.port + "/api/coupon/detail?id=" + id;
    request({
      url: url,
      timeout: 3000,
      method: "GET"
    }, function(err, response, body) {
      var error, res;
      if (err) {
        return deferred.reject(err);
      } else {
        try {
          res = JSON.parse(body);
          if (res.error === 1) {
            return deferred.reject(new Error(res.errMsg));
          } else {
            return deferred.resolve(res.data);
          }
        } catch (_error) {
          error = _error;
          return deferred.reject(new Error("Parse Error"));
        }
      }
    });
    return deferred.promise;
  };

  _createQrcode = function(id) {
    var deferred, logoSize, scala;
    scala = 3;
    logoSize = 0.2;
    deferred = Q.defer();
    QRCodeExtend.toDataUrl(id, 2, function(err, results) {
      if (err != null) {
        deferred.reject(err);
      }
      return deferred.resolve(results);
    });
    return deferred.promise;
  };

  _couponUse = function(id) {
    var deferred, url;
    deferred = Q.defer();
    url = "" + config.inf.host + ":" + config.inf.port + "/api/coupon/scanUse";
    request({
      url: url,
      timeout: 3000,
      method: "POST",
      form: {
        id: id
      }
    }, function(err, response, body) {
      var error, res;
      if (err) {
        return deferred.reject(err);
      } else {
        try {
          res = JSON.parse(body);
          if (res.error === 1) {
            return deferred.reject(new Error(res.errMsg));
          } else {
            return deferred.resolve(res.data);
          }
        } catch (_error) {
          error = _error;
          return deferred.reject(new Error("Parse Error"));
        }
      }
    });
    return deferred.promise;
  };

  exports.coupons = function(req, res) {
    var code, state;
    code = req.query.code;
    state = req.query.state;
    return _getOpenid(code).then(function(openid) {
      return _getCustomerInfo(openid.openid);
    }, function(err) {
      console.log(err);
      return res.status(500).end();
    }).then(function(customer) {
      return _getCoupons(customer._id);
    }, function(err) {
      console.log(err);
      return res.status(500).end();
    }).then(function(coupons) {
      return res.render("coupons", {
        coupons: coupons,
        MarketingImg: MarketingImg
      });
    }, function(err) {
      console.log(err);
      return res.status(500).end();
    })["catch"](function(err) {
      console.log(err);
      return res.status(500).end();
    });
  };

  exports.couponDetail = function(req, res) {
    var id, url;
    id = req.query.id;
    url = "";
    return _createQrcode(id).then(function(u) {
      url = u;
      return _couponDetail(id);
    }, function(err) {
      console.log(err);
      return res.status(500).end();
    }).then(function(coupon) {
      return res.render("couponDetail", {
        coupon: coupon,
        url: url
      });
    }, function(err) {
      console.log(err);
      return res.status(500).end();
    });
  };

  exports.couponuse = function(req, res) {
    var id;
    if (req.headers["user-agent"].indexOf("MicroMessenger") > -1) {
      id = req.query.id;
      return _couponUse(id).then(function(coupon) {
        return res.render("useResult", {
          result: true,
          coupon: coupon
        });
      }, function(err) {
        return res.render("useResult", {
          result: false,
          message: err.message
        });
      });
    } else {
      return res.render("useResult", {
        result: false,
        message: "请使用微信扫一扫"
      });
    }
  };

  exports.map = function(req, res) {
    return res.render("map");
  };

}).call(this);
