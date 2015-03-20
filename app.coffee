express = require "express"
session = require "cookie-session"
path = require "path"
favicon = require "static-favicon"
cookieParser = require "cookie-parser"
bodyParser = require "body-parser"
config = require "./config/config.json"
flash = require "connect-flash"
compression = require "compression"
require("./tools/dateExtend")()

log4js = require "log4js"
log4js.configure appenders:[type:"console"],replaceConsole:true
logger = log4js.getLogger "normal"

index = require "./routes/index"
page = require "./routes/page"

#TODO 浏河临时活动
weixin = require "./routes/weixin"
#TODO 浏河临时活动

app = express()

app.set "views",path.join __dirname,"views"
app.set "view engine","ejs"

app.enable "trust proxy"
app.use compression()
app.use favicon()
app.use bodyParser.json()
app.use bodyParser.urlencoded()
app.use cookieParser()
app.use express.static path.join __dirname,"public"
app.use log4js.connectLogger logger,level:log4js.levels.INFO
app.use session({secret:"holidaycloud"})
app.use (req,res,next) ->
  res.set "X-Powered-By","Server"
  next()
app.use flash()

app.use "/",index
app.use "/page",page

#TODO 浏河临时活动
app.use "/weixin",weixin
global.isDebug = true
#TODO 浏河临时活动

app.use (req,res,next) ->
  res.status(404).end()

if (app.get "env") is "development"
  app.use (err,req,res,next) ->
    console.log err
    res.status(err.status or 500).end()

app.use (err,req,res,next) ->
  console.log err
  res.status(err.status or 500).end()

app.set "port",process.env.PORT or 8888

server = app.listen (app.get "port"),() ->
  console.log "Express server listening on port #{server.address().port}"

global.weixinEnt = "54124f09e07fa9341ba90cf3"
#ws global object
global.users = {};
ws = require("socket.io")(server)
ws.on "connection",(conn) ->
  conn.on "login",(message) ->
    global.users[message.token] = conn;
    global.users[message.token].emit('connected',{type:1,content:"connect success"});
  conn.on "disconnect",(socket) ->
module.exports = app