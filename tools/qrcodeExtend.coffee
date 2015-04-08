QRCode = require "qrcode"
Canvas = require "canvas"
fs = require "fs"
Image = Canvas.Image
logoSize = 0.23

exports.toPngFile = (text,scale=1,callback) ->
  QRCode.draw text,scale:4*scale,(error,canvas) ->
    out = fs.createWriteStream "./image/#{text}.png"
    stream = canvas.pngStream()
    stream.pipe out,end:false
    stream.on "end",() ->
      out.end()
      callback null,text

exports.withLogoToDataURL = (text,logo,scale=1,callback) ->
  QRCode.draw text,scale:4*scale,(error,canvas) ->
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

exports.toDataUrl = (text,scale=1,callback) ->
  QRCode.draw text,scale:4*scale,(error,canvas) ->
    callback null,canvas.toDataURL()