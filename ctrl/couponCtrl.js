// Generated by CoffeeScript 1.8.0
(function() {
  var CouponCtrl, CustomerCtrl, MemberCtrl, async, config, request;

  request = require("request");

  config = require("./../config/config.json");

  MemberCtrl = require("./memberCtrl");

  CustomerCtrl = require("./customerCtrl");

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

    CouponCtrl.ajaxList = function(ent, start, length, order, dir, search, fn) {
      var url;
      url = "" + config.inf.host + ":" + config.inf.port + "/api/coupon/customlist?ent=" + ent + "&start=" + start + "&length=" + length + "&order=" + order + "&dir=" + dir + "&search=" + search;
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

    CouponCtrl.detail = function(id, fn) {
      var url;
      url = "" + config.inf.host + ":" + config.inf.port + "/api/coupon/detail?id=" + id;
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
      var _this;
      _this = this;
      console.log(id, openid);
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
        ],
        getCoupon: function(cb) {
          return _this.detail(id, function(err, res) {
            return cb(err, res);
          });
        },
        getCustomer: [
          "getCoupon", function(cb, results) {
            var coupon;
            coupon = results.getCoupon.data;
            return CustomerCtrl.detail(coupon.customer, function(err, res) {
              return cb(err, res);
            });
          }
        ],
        sendTemplate: [
          "getCoupon", "couponUse", "getCustomer", function(cb, results) {
            var coupon, couponId, customer, entName, name, remark, tempId, toUser, url, useDate;
            coupon = results.getCoupon.data;
            customer = results.getCustomer.data;
            tempId = "wij1QbErYRCBnewBVFgzqh2UiHCYau3qFxexGx-0Qos";
            toUser = customer.weixinOpenId;
            couponId = coupon._id;
            name = coupon.name;
            entName = coupon.ent.name;
            useDate = new Date(coupon.useTime).Format("yyyy-MM-dd hh:mm:ss");
            remark = "感谢您的支持";
            console.log("send weixin coupon temp", toUser, global.weixinEnt);
            url = "" + config.weixin.host + ":" + config.weixin.port + "/weixin/sendCouponTemplate/" + global.weixinEnt;
            return request({
              url: url,
              timeout: 3000,
              method: "POST",
              form: {
                tempId: tempId,
                toUser: toUser,
                couponId: couponId,
                name: name,
                entName: entName,
                useDate: useDate,
                remark: remark
              }
            }, function(err, response, body) {
              var error, res;
              if (err) {
                return fn(err);
              } else {
                try {
                  res = JSON.parse(body);
                  if ((res.error != null) === 1) {
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
          }
        ]
      }, function(err, results) {
        console.log(results);
        return fn(err, results.couponUse);
      });
    };

    return CouponCtrl;

  })();

  module.exports = CouponCtrl;

}).call(this);
