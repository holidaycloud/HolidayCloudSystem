// Generated by CoffeeScript 1.8.0
(function() {
  var Canvas, Image, QRCode, fs, logoSize;

  QRCode = require("qrcode");

  Canvas = require("canvas");

  fs = require("fs");

  Image = Canvas.Image;

  logoSize = 0.23;

  exports.toPngFile = function(text, scale, callback) {
    if (scale == null) {
      scale = 1;
    }
    return QRCode.draw(text, {
      scala: 4 * scala
    }, function(error, canvas) {
      var out, stream;
      out = fs.createWriteStream("" + __dirname + "/" + text + ".png");
      stream = canvas.pngStream();
      stream.pipe(out, {
        end: false
      });
      stream.on("end", function() {});
      out.end();
      return callback(null, text);
    });
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
