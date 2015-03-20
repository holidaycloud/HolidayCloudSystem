// Generated by CoffeeScript 1.8.0
(function() {
  var app, bodyParser, compression, config, cookieParser, express, favicon, flash, index, log4js, logger, page, path, server, session, weixin, ws;

  express = require("express");

  session = require("cookie-session");

  path = require("path");

  favicon = require("static-favicon");

  cookieParser = require("cookie-parser");

  bodyParser = require("body-parser");

  config = require("./config/config.json");

  flash = require("connect-flash");

  compression = require("compression");

  require("./tools/dateExtend")();

  log4js = require("log4js");

  log4js.configure({
    appenders: [
      {
        type: "console"
      }
    ],
    replaceConsole: true
  });

  logger = log4js.getLogger("normal");

  index = require("./routes/index");

  page = require("./routes/page");

  weixin = require("./routes/weixin");

  app = express();

  app.set("views", path.join(__dirname, "views"));

  app.set("view engine", "ejs");

  app.enable("trust proxy");

  app.use(compression());

  app.use(favicon());

  app.use(bodyParser.json());

  app.use(bodyParser.urlencoded());

  app.use(cookieParser());

  app.use(express["static"](path.join(__dirname, "public")));

  app.use(log4js.connectLogger(logger, {
    level: log4js.levels.INFO
  }));

  app.use(session({
    secret: "holidaycloud"
  }));

  app.use(function(req, res, next) {
    res.set("X-Powered-By", "Server");
    return next();
  });

  app.use(flash());

  app.use("/", index);

  app.use("/page", page);

  app.use("/weixin", weixin);

  global.isDebug = true;

  app.use(function(req, res, next) {
    return res.status(404).end();
  });

  if ((app.get("env")) === "development") {
    app.use(function(err, req, res, next) {
      console.log(err);
      return res.status(err.status || 500).end();
    });
  }

  app.use(function(err, req, res, next) {
    console.log(err);
    return res.status(err.status || 500).end();
  });

  app.set("port", process.env.PORT || 8888);

  server = app.listen(app.get("port"), function() {
    return console.log("Express server listening on port " + (server.address().port));
  });

  global.weixinEnt = "54124f09e07fa9341ba90cf3";

  global.users = {};

  ws = require("socket.io")(server);

  ws.on("connection", function(conn) {
    conn.on("login", function(message) {
      global.users[message.token] = conn;
      return global.users[message.token].emit('connected', {
        type: 1,
        content: "connect success"
      });
    });
    return conn.on("disconnect", function(socket) {});
  });

  module.exports = app;

}).call(this);
