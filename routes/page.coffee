express = require "express"
AjaxAction = require "./../action/ajaxAction"
router = express.Router()

router.get "/dashboard",AjaxAction.dashboard
router.get "/profile",AjaxAction.profile
router.get "/productList",AjaxAction.productList
router.get "/images",AjaxAction.images
router.get "/userList",AjaxAction.userList
router.get "/setting",AjaxAction.setting
router.get "/members",AjaxAction.members
router.get "/couponList",AjaxAction.couponList
module.exports = router