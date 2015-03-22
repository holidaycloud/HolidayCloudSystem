// Generated by CoffeeScript 1.8.0
(function() {
  var CouponCtrl, MemberCtrl, async, config, request;

  request = require("request");

  config = require("./../config/config.json");

  MemberCtrl = require("./memberCtrl");

  async = require("async");

  CouponCtrl = (function() {
    function CouponCtrl() {}

    CouponCtrl.list = function(ent, fn) {
      var url;
      url = "" + config.inf.host + ":" + config.inf.port + "/api/coupon/fulllist?ent=" + ent;
      return request({
        url: url,
        timeout: 3000,
        method: "GET"
      }, function(err, response, body) {
        var error, res;
        if (err) {
          return fn(err);
        } else {
          try {
            res = JSON.parse(body);
            if ((res.error != null) === 1) {
              return fn(new Error(res.errMsg));
            } else {
              return fn(null, res);
            }
          } catch (_error) {
            error = _error;
            return fn(new Error("Parse Error"));
          }
        }
      });
    };

    CouponCtrl.use = function(id, openid, fn) {
      console.log(id);
      return async.auto({
        getMember: function(cb) {
          return MemberCtrl.weixinLogin(openid, function(err, res) {
            return cb(err, res);
          });
        },
        couponUse: [
          "getMember", function(cb, results) {
            var member, url, _ref;
            member = (_ref = results.getMember) != null ? _ref.data : void 0;
            if (member != null) {
              url = "" + config.inf.host + ":" + config.inf.port + "/api/coupon/scanUse";
              return request({
                url: url,
                timeout: 3000,
                method: "POST",
                form: {
                  id: id
                }
              }, function(err, response, body) {
                var error, res;
                if (err) {
                  return cb(err);
                } else {
                  try {
                    res = JSON.parse(body);
                    if (res.error === 1) {
                      return cb(new Error(res.errMsg));
                    } else {
                      return cb(null, res);
                    }
                  } catch (_error) {
                    error = _error;
                    return cb(new Error("Parse Error"));
                  }
                }
              });
            } else {
              return cb(new Error("请先绑定账户"));
            }
          }
        ]
      }, function(err, results) {
        return fn(err, results.couponUse);
      });
    };

    return CouponCtrl;

  })();

  module.exports = CouponCtrl;

}).call(this);
