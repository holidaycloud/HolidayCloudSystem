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
        return callback(err, canvas);
      });
    });
  };

  draw = function(text, scale, callback) {
    return QRCode.draw(text, {
      scala: 4 * scala
    }, function(error, canvas) {
      return callback(err, canvas);
    });
  };

  exports.toPngFile = function(text, logo, scale, callback) {
    if (scale == null) {
      scale = 1;
    }
    if (logo != null) {
      return drawWithLogo(text, logo, scale, function(err, canvas) {
        var out, stream;
        out = fs.createWriteStream("" + __dirname + "/" + text + ".png");
        stream = canvas.pngStream();
        stream.pipe(out, {
          end: false
        });
        return stream.on("end", function() {
          return callback(null, text);
        });
      });
    } else {
      return draw(text, scale, function(err, canvas) {
        var out, stream;
        out = fs.createWriteStream("" + __dirname + "/" + text + ".png");
        stream = canvas.pngStream();
        stream.pipe(out, {
          end: false
        });
        return stream.on("end", function() {
          return callback(null, text);
        });
      });
    }
  };

  exports.withLogoToDataURL = function(text, logo, scala, callback) {
    if (scala == null) {
      scala = 1;
    }
    return drawWithLogo(text, logo, scala, function(err, canvas) {
      return callback(null, canvas.toDataURL());
    });
  };

  exports.toDataUrl = function(text, scala, callback) {
    if (scala == null) {
      scala = 1;
    }
    return draw(text, scala, function(err, canvas) {
      return callback(null, canvas.toDataURL());
    });
  };

}).call(this);
