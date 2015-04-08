QRCode = require "qrcode"
Canvas = require "canvas"
fs = require "fs"
Image = Canvas.Image
logoSize = 0.23

drawWithLogo = (text,logo,scale,callback) ->
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
      callback error,canvas

draw = (text,scale,callback) ->
  console.log "start draw",text,scale,callback
  QRCode.draw text,scala:4*scala,(error,canvas) ->
    callback error,canvas

exports.toPngFile = (text,logo,scale=1,callback) ->
  console.log text,logo,scale
  if logo?
    console.log "---logo---"
    drawWithLogo text,logo,scale,(err,canvas) ->
      console.log err,canvas
      out = fs.createWriteStream "#{__dirname}/#{text}.png"
      stream = canvas.pngStream()
      stream.pipe out,end:false
      stream.on "end",() ->
        out.end()
        callback null,text
  else
    console.log "---no logo---"
    draw text,scale,(err,canvas) ->
      console.log err,canvas
      out = fs.createWriteStream "#{__dirname}/#{text}.png"
      stream = canvas.pngStream()
      stream.pipe out,end:false
      stream.on "end",() ->
        out.end()
        callback null,text


exports.withLogoToDataURL = (text,logo,scala=1,callback) ->
#  drawWithLogo text,logo,scala,(err,canvas) ->
#    callback null,canvas.toDataURL()
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
#  draw text,scala,(err,canvas) ->
#    callback null,canvas.toDataURL()
  QRCode.draw text,scala:4*scala,(error,canvas) ->
    callback null,canvas.toDataURL()