// Generated by CoffeeScript 1.8.0
(function() {
  var CustomerCtrl, Q, config, request;

  request = require("request");

  config = require("./../config/config.json");

  Q = require("q");

  CustomerCtrl = (function() {
    var _getCoupon, _getCustomerInfo;

    function CustomerCtrl() {}

    CustomerCtrl.list = function(ent, fn) {
      var url;
      url = "" + config.inf.host + ":" + config.inf.port + "/api/customer/fulllist?ent=" + ent;
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


    /*
      TODO:浏河临时活动
     */

    CustomerCtrl.weixinSubscribe = function(openid, fn) {
      var url;
      url = "" + config.inf.host + ":" + config.inf.port + "/api/customer/weixinSubscribe";
      return request({
        url: url,
        timeout: 3000,
        method: "POST",
        form: {
          ent: global.ent,
          openid: openid
        }
      }, function(err, response, body) {
        var error, res;
        if (err) {
          return fn(err);
        } else {
          try {
            res = JSON.parse(body);
            if (res.error === 1) {
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

    CustomerCtrl.weixinCoupon = function(openid, from, sceneid, fn) {
      return _getCustomerInfo(openid).then(function(customer) {
        if (parseInt(sceneid) === 99999) {
          return _getCoupon(customer._id, "54fa5b5f7284d93d4a49a19a");
        } else {
          return _getCoupon(customer._id, "54fa82d751abf6d65a37dd37");
        }
      }, function(err) {
        return fn(err);
      }).then(function(coupon) {
        return fn(null, "<xml>\n<ToUserName><![CDATA[" + openid + "]]></ToUserName>\n<FromUserName><![CDATA[" + from + "]]></FromUserName>\n<CreateTime>" + (Date.now()) + "</CreateTime>\n<MsgType><![CDATA[news]]></MsgType>\n<ArticleCount>1</ArticleCount>\n<Articles>\n<item>\n<Title><![CDATA[您获得一张优惠券]]></Title>\n<Description><![CDATA[" + coupon.data.name + "]]></Description>\n<PicUrl><![CDATA[http://test.meitrip.net/images/coupon.jpg]]></PicUrl>\n<Url><![CDATA[http://test.meitrip.net/couponDetail?id=" + coupon.data._id + "]]></Url>\n</item>\n</Articles>\n</xml>");
      }, function(err) {
        return fn(err);
      })["catch"](function(err) {
        return fn(err);
      });
    };

    _getCustomerInfo = function(openid) {
      var deferred, url;
      deferred = Q.defer();
      url = "" + config.inf.host + ":" + config.inf.port + "/api/customer/weixinLogin?ent=" + global.ent + "&openId=" + openid;
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

    _getCoupon = function(customer, marketing) {
      var deferred, url;
      deferred = Q.defer();
      url = "" + config.inf.host + ":" + config.inf.port + "/api/coupon/give";
      request({
        url: url,
        timeout: 3000,
        method: "POST",
        form: {
          ent: global.ent,
          customer: customer,
          marketing: marketing
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
              return deferred.resolve(res);
            }
          } catch (_error) {
            error = _error;
            return deferred.reject(new Error("Parse Error"));
          }
        }
      });
      return deferred.promise;
    };

    return CustomerCtrl;

  })();

  module.exports = CustomerCtrl;

}).call(this);
