QRCode = require "qrcode"
Canvas = require "canvas"
fs = require "fs"
Image = Canvas.Image
logoSize = 0.23

exports.toPngFile = (text,scala=1,callback) ->
  QRCode.draw text,scala:4*scala,(error,canvas) ->
    console.log "#{__dirname}/#{text}.png"
    out = fs.createWriteStream "#{__dirname}/#{text}.png"
    stream = canvas.pngStream()
    stream.pipe out,end:false
    stream.on "end",() ->
      out.end()
      callback null,text

exports.withLogoToDataURL = (text,logo,scala=1,callback) ->
  QRCode.draw text,scala:4*scala,(error,canvas) ->
    fs.readFile logo,(err,squid) ->
      callback err if err?
      img = new Image
      img.src = squid
      ctx = canvas.getContext "2d"
      w = canvas.width*logoSize
      h = canvas.height*logoSize
      x = (canvas.width/2) - (w/2)
      y = (canvas.height/2) - (h/2)
      ctx.drawImage img,x,y,w,h
      callback null,canvas.toDataURL()

exports.toDataUrl = (text,scala=1,callback) ->
  QRCode.draw text,scala:4*scala,(error,canvas) ->
    callback null,canvas.toDataURL()