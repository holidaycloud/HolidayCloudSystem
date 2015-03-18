#UPYUN = require "upyun"
#upyun = new UPYUN "holidaycloud", "admin","Lian2014"
#upyun.listDir "/",(err,result) ->
#  console.log err,JSON.stringify result

pg = require "pg"
connStr = "postgres://postgres:20070428@localhost/test"
client = new pg.Client connStr
client.connect (err) ->
  client.query "select * from weather",(err,result) ->
    console.log err,result.rows[0]
    client.end()
