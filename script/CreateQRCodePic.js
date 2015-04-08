// Generated by CoffeeScript 1.8.0
(function() {
  var CouponCtrl, QRCodeExtend, async, createFun;

  CouponCtrl = require("./../ctrl/couponCtrl");

  QRCodeExtend = require("./../tools/qrcodeExtend");

  async = require("async");

  createFun = function(text) {
    return function(cb) {
      return QRCodeExtend.toPngFile(text, null, 3, function(err, res) {
        return cb(err, res);
      });
    };
  };

  CouponCtrl.marketingList("550f7c079270a9154dfbdc1f", function(err, res) {
    var data;
    data = res.data;
    return QRCodeExtend.toPngFile(data[0]._id, null, 3, function(err, res) {
      return console.log(err, res);
    });
  });

}).call(this);
