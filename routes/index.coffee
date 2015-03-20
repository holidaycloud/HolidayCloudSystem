express = require "express"
router = express.Router()
PageAction = require "./../action/pageAction"
Action = require "./../action/action"

router.get "/",PageAction.index
router.get "/bind",PageAction.bind
router.post "/dobind",Action.dobind
router.post "/dologin",Action.dologin
router.get "/dologout",Action.dologout

###
  TODO:浏河临时活动
###
router.get "/coupons",PageAction.coupons
router.get "/couponDetail",PageAction.couponDetail
router.get "/couponuse",PageAction.couponuse
module.exports = router