CouponCtrl = require "./../ctrl/couponCtrl"
QRCodeExtend = require "./../tools/qrcodeExtend"
async = require "async"
createFun = (text) ->
  (cb) ->
    QRCodeExtend.toPngFile text,2,(err,res) ->
      cb err,res

CouponCtrl.marketingList "5526056f2c4236ab601027ae",(err,res) ->
  data = res.data
  funcArr = []
  for coupon in data
    funcArr.push createFun coupon._id

  async.series funcArr,(err,results) ->
    console.log err,results

