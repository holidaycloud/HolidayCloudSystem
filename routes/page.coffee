express = require "express"
AjaxAction = require "./../action/ajaxAction"
AuthAction = require "./../action/authAction"
router = express.Router()

router.get "/dashboard",AuthAction.auth,AjaxAction.dashboard
router.get "/profile",AuthAction.auth,AjaxAction.profile
router.get "/productList",AuthAction.auth,AjaxAction.productList
router.get "/images",AuthAction.auth,AjaxAction.images
router.get "/userList",AuthAction.auth,AjaxAction.userList
router.get "/setting",AuthAction.auth,AjaxAction.setting
router.get "/members",AuthAction.auth,AjaxAction.members
router.get "/couponList",AuthAction.auth,AjaxAction.couponList
module.exports = router