CouponCtrl = require "./../ctrl/couponCtrl"
QRCodeExtend = require "./../tools/qrcodeExtend"
async = require "async"

createFun = (text) ->
  (cb) ->
    QRCodeExtend.toPngFile coupon._id,null,3,(err,res) ->
      cb err,res

CouponCtrl.marketingList "550f7c079270a9154dfbdc1f",(err,res) ->
  console.log err,res
  data = res.data
  funcArr = []
  for coupon in data
    funcArr.push createFun coupon._id
  console.log funcArr.length
  async.parallel funcArr,(err,results) ->
    console.log err,results

