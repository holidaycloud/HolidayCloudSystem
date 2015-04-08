CouponCtrl = require "./../ctrl/couponCtrl"
QRCodeExtend = require "./../tools/qrcodeExtend"
async = require "async"
createFun = (text) ->
  (cb) ->
    QRCodeExtend.toPngFile text,6,(err,res) ->
      cb err,res

CouponCtrl.marketingList "550f7c079270a9154dfbdc1f",(err,res) ->
  data = res.data
  funcArr = []
  for coupon in data
    funcArr.push createFun coupon._id

  async.parallel funcArr,(err,results) ->
    console.log err,results

