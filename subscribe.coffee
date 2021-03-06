mqtt = require 'mqtt'
url = require 'url'

MQTT_URL = process.env.MQTT_URL

MQTT_TOPIC = '/highland/device/#'

client = do ->
  urlObj = url.parse MQTT_URL
  if urlObj.auth
    [username, password] = (urlObj.auth or ':').split ':', 2
    username = urlObj.path.slice(1) + ':' + username if urlObj.pathname
    urlObj.pathname = null
    urlObj.auth = username + ':' + password if username
    urlObj = url.format urlObj
  return mqtt.connect urlObj

client.on 'connect', ->
  client.subscribe MQTT_TOPIC
  console.info 'subscribed to', MQTT_TOPIC

client.on 'reconnect', ->
   console.log 'MQTT client reconnect'

client.on 'close', ->
   console.log 'MQTT client close'

client.on 'offline', ->
   console.log 'MQTT client offline'

client.on 'error', (err) ->
   console.error 'MQTT client error:', err

module.exports = client

if require.main is module
  client.handleMessage = (message, cb) ->
    console.log message.topic, message.payload.toString()
