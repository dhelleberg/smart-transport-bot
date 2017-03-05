#https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->
  robot.hear /@test (.*)/i, (msg) -> #capture everything and forward it to API.AI
    url = "https://api.api.ai/api/query?v=20150910&lang=en&sessionId="+createUID()+"&query="+encodeURI(msg.match[1])
    robot.logger.debug('url: '+url)
    robot.http(url)
        .headers(Accept: 'application/json', Authorization: 'Bearer '+process.env.APIAI_AUTH)
        .get() (err, res, body) ->
            robot.logger.debug('response: '+body)
            data   = JSON.parse body
            robot.logger.debug('response: '+JSON.stringify data.result.fulfillment)
            msg.send data.result.fulfillment.speech
            return

uid = undefined
HEX_CHARS =
  ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]

defaultOptions =
  uppercase: true
  braces: false
  hyphens: true

# Return random UID char
getRandomChar = () -> HEX_CHARS[Math.floor(Math.random() * 16)]


createUID = (options) ->

    if !uid 
        options = options || defaultOptions
        uid = ""
        uid += getRandomChar() for i in [1..8]
        uid += "-" if options.hyphens
        uid += getRandomChar() for j in [1..4]
        uid += "-" if options.hyphens
        uid += getRandomChar() for j in [1..4]
        uid += "-" if options.hyphens
        uid += getRandomChar() for j in [1..4]
        uid += "-" if options.hyphens
        uid += ("0000000" + new Date().getTime().toString(16)).substr(-8)
        uid += getRandomChar() for i in [1..4]
        uid = uid.toUpperCase() if options.uppercase
        uid = "{#{uid}}" if options.braces
    
    return uid