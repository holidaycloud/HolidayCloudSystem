CouponCtrl = require "./../ctrl/couponCtrl"
QRCodeExtend = require "./../tools/qrcodeExtend"

CouponCtrl.marketingList "550f7c079270a9154dfbdc1f",(err,res) ->
  data = res.data
  for coupon in res
    console.log coupon._id
    QRCodeExtend.toPngFile coupon._id,null,3

