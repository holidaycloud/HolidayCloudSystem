CouponCtrl = require "./../ctrl/couponCtrl"
QRCodeExtend = require "./../tools/qrcodeExtend"
async = require "async"

QRCodeExtend.toPngFile "550f7c9c9270a9154dfbdc63",3,(e,r) ->
  console.log e,r

#createFun = (text) ->
#  (cb) ->
#    QRCodeExtend.toPngFile text,null,3,(err,res) ->
#      cb err,res
#
#CouponCtrl.marketingList "550f7c079270a9154dfbdc1f",(err,res) ->
#  data = res.data
#  console.log data.length
#  coupon = data[0]
#  console.log coupon
#  QRCodeExtend.toPngFile "550f7c9c9270a9154dfbdc63",3,(e,r) ->
#    console.log e,r
#  funcArr = []
#  for coupon in data
#    console.log coupon
#    funcArr.push createFun coupon._id
#
#  async.parallel funcArr,(err,results) ->
#    console.log err,results

