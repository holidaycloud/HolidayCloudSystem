express = require "express"
router = express.Router()
PageAction = require "./../action/pageAction"
Action = require "./../action/action"

router.get "/",PageAction.index
router.post "/dologin",Action.dologin
router.get "/dologout",Action.dologout

module.exports = router