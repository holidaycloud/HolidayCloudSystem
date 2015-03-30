ProductCtrl = require "./../ctrl/productCtrl"
CustomerCtrl = require "./../ctrl/customerCtrl"
SettingCtrl = require "./../ctrl/settingCtrl"
MemberCtrl = require "./../ctrl/memberCtrl"
CouponCtrl = require "./../ctrl/couponCtrl"
async = require "async"
exports.dashboard = (req,res) ->
  async.auto {
    pieAnalysis: (cb) ->
      CouponCtrl.pieAnalysis req.session.member.ent._id, (err, res) ->
        cb err, res
    , locations: (cb) ->
      CustomerCtrl.locations req.session.member.ent._id, (err, res) ->
        cb err, res
  },(err,results) ->
    res.render "./page/dashboard",data:results.pieAnalysis,locations:results.locations

exports.profile = (req,res) ->
  res.render "./page/profile",{member:req.session.member}

exports.images = (req,res) ->
  res.render "./page/images"

exports.setting = (req,res) ->
  async.parallel [
    (cb) ->
      SettingCtrl.webConfigDetail req.session.member.ent._id,(err,results) ->
        cb err,results
    ,(cb) ->
      SettingCtrl.weixinConfigDetail req.session.member.ent._id,(err,results) ->
        cb err,results
  ],(err,results) ->
    if results?
      res.render "./page/setting",{web:results[0].data,weixin:results[1].data}
    else
      res.status(500).end()




exports.productList = (req,res) ->
  ProductCtrl.list req.session.member.ent._id,(err,results) ->
    if results.data?
      res.render "./page/productList",{products:results.data}
    else
      res.status(500).end()

exports.userList = (req,res) ->
  CustomerCtrl.list req.session.member.ent._id,(err,results) ->
    if results.data?
      res.render "./page/userList",{customers:results.data}
    else
      res.status(500).end()

exports.members = (req,res) ->
  MemberCtrl.fulllist req.session.member.ent._id,(err,results) ->
    if results.data?
      res.render "./page/members",{members:results.data}
    else
      res.status(500).end()

exports.couponList = (req,res) ->
  res.render "./page/couponList"
#  CouponCtrl.list req.session.member.ent._id,(err,results) ->
#    console.log err,results
#    if results.data?
#      res.render "./page/couponList",coupons:results.data,types:[ "金额券","折扣券","产品固定价格","免费券"]
#    else
#      res.status(500).end()

exports.couponAjaxList = (req,res) ->
  orderArr = ["code","ent","name","type","value","minValue","status","startDate"]
  types = ["金额券","折扣券","定价券","免费券"]
  statusArr = ["未使用","已使用"]
  draw = req.body.draw
  start = req.body.start
  length = req.body.length
  order = orderArr[parseInt(req.body.order[0].column)]
  dir = req.body.order[0].dir
  search = req.body.search.value
  CouponCtrl.ajaxList req.session.member.ent._id,start,length,order,dir,search,(err,results) ->
    coupons = results.data.coupons
    for c in coupons
      c.type = types[c.type]
      c.status = statusArr[c.status]
      c.startDate = "#{new Date(c.startDate).Format("yyyy-MM-dd")}至#{new Date(c.endDate).Format("yyyy-MM-dd")}"
      delete c.endDate
    res.json draw:draw,recordsTotal:results.data.totalSize,recordsFiltered:results.data.totalSize,data:coupons
