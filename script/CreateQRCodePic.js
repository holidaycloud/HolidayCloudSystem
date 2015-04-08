// Generated by CoffeeScript 1.8.0
(function() {
  var CouponCtrl, QRCodeExtend, async, createFun;

  CouponCtrl = require("./../ctrl/couponCtrl");

  QRCodeExtend = require("./../tools/qrcodeExtend");

  async = require("async");

  createFun = function(text) {
    return function(cb) {
      return QRCodeExtend.toPngFile(text, 2, function(err, res) {
        return cb(err, res);
      });
    };
  };

  CouponCtrl.marketingList("550f7c079270a9154dfbdc1f", function(err, res) {
    var coupon, data, funcArr, _i, _len;
    data = res.data;
    funcArr = [];
    for (_i = 0, _len = data.length; _i < _len; _i++) {
      coupon = data[_i];
      funcArr.push(createFun(coupon._id));
    }
    return async.parallel(funcArr, function(err, results) {
      return console.log(err, results);
    });
  });

}).call(this);
