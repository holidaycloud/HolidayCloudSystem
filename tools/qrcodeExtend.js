// Generated by CoffeeScript 1.8.0
(function() {
  var Canvas, Image, QRCode, draw, drawWithLogo, fs, logoSize;

  QRCode = require("qrcode");

  Canvas = require("canvas");

  fs = require("fs");

  Image = Canvas.Image;

  logoSize = 0.23;

  drawWithLogo = function(text, logo, scale, callback) {
    return QRCode.draw(text, {
      scala: 4 * scala
    }, function(error, canvas) {
      return fs.readFile(logo, function(err, squid) {
        var ctx, h, img, w, x, y;
        if (err != null) {
          callback(err);
        }
        img = new Image;
        img.src = squid;
        ctx = canvas.getContext("2d");
        w = canvas.width * logoSize;
        h = canvas.height * logoSize;
        x = (canvas.width / 2) - (w / 2);
        y = (canvas.height / 2) - (h / 2);
        ctx.drawImage(img, x, y, w, h);
        return callback(error, canvas);
      });
    });
  };

  draw = function(text, scale, callback) {
    return QRCode.draw(text, {
      scala: 4 * scala
    }, function(error, canvas) {
      return callback(error, canvas);
    });
  };

  exports.toPngFile = function(text, logo, scale, callback) {
    if (scale == null) {
      scale = 1;
    }
    console.log(text, logo, scale);
    if (logo != null) {
      return drawWithLogo(text, logo, scale, function(err, canvas) {
        var out, stream;
        console.log(err, canvas);
        out = fs.createWriteStream("" + __dirname + "/" + text + ".png");
        stream = canvas.pngStream();
        stream.pipe(out, {
          end: false
        });
        return stream.on("end", function() {
          out.end();
          return callback(null, text);
        });
      });
    } else {
      return draw(text, scale, function(err, canvas) {
        var out, stream;
        console.log(err, canvas);
        out = fs.createWriteStream("" + __dirname + "/" + text + ".png");
        stream = canvas.pngStream();
        stream.pipe(out, {
          end: false
        });
        return stream.on("end", function() {
          out.end();
          return callback(null, text);
        });
      });
    }
  };

  exports.withLogoToDataURL = function(text, logo, scala, callback) {
    if (scala == null) {
      scala = 1;
    }
    return QRCode.draw(text, {
      scala: 4 * scala
    }, function(error, canvas) {
      return fs.readFile(logo, function(err, squid) {
        var ctx, h, img, w, x, y;
        if (err != null) {
          callback(err);
        }
        img = new Image;
        img.src = squid;
        ctx = canvas.getContext("2d");
        w = canvas.width * logoSize;
        h = canvas.height * logoSize;
        x = (canvas.width / 2) - (w / 2);
        y = (canvas.height / 2) - (h / 2);
        ctx.drawImage(img, x, y, w, h);
        return callback(null, canvas.toDataURL());
      });
    });
  };

  exports.toDataUrl = function(text, scala, callback) {
    if (scala == null) {
      scala = 1;
    }
    return QRCode.draw(text, {
      scala: 4 * scala
    }, function(error, canvas) {
      return callback(null, canvas.toDataURL());
    });
  };

}).call(this);
