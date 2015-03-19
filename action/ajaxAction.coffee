ProductCtrl = require "./../ctrl/productCtrl"
CustomerCtrl = require "./../ctrl/customerCtrl"
SettingCtrl = require "./../ctrl/settingCtrl"
MemberCtrl = require "./../ctrl/memberCtrl"
CouponCtrl = require "./../ctrl/couponCtrl"
async = require "async"
exports.dashboard = (req,res) ->
  res.render "./page/dashboard"

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
  CouponCtrl.list req.session.member.ent._id,(err,results) ->
    console.log JSON.stringify(results)
    if results.data?
      res.render "./page/couponList",coupons:results.data,types:[ "金额券","折扣券","产品固定价格","免费券"]
    else
      res.status(500).end()
