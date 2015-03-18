dateExtend = () ->
  Date::Format = (fmt) ->
    getWeek = (w) ->
      switch w
        when 0 then x="周日"
        when 1 then x="周一"
        when 2 then x="周二"
        when 3 then x="周三"
        when 4 then x="周四"
        when 5 then x="周五"
        when 6 then x="周六"

    o =
      "M+" : @getMonth()+1
      "d+" : @getDate()
      "h+" : @getHours()
      "m+" : @getMinutes()
      "s+" : @getSeconds()
      "q+" : Math.floor (@.getMonth()+3)/3
      "S"  : @getMilliseconds()
      "W"  : getWeek @getDay()

    fmt = fmt.replace RegExp.$1,"#{@getFullYear()}".substr 4-RegExp.$1.length if /(y+)/.test fmt
    for key,value of o
      if new RegExp("(#{key})").test fmt
        fmt = fmt.replace RegExp.$1,(if RegExp.$1.length is 1 then value else "00#{value}".substr "#{value}".length)
    fmt

module.exports = dateExtend