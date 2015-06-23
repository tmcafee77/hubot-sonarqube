module.exports = (robot) ->
  @server = ''

  robot.respond /sonar test coverage (.*)/, (msg) ->
    findResource robot, msg, msg.match[1], (resourceName, robot, msg) ->
      coverage(resourceName, robot, msg)

  robot.respond /sonar set server (.*)/, (msg) ->
    server = msg.match[1]
    msg.send "Sonar server set to: #{server}"

coverage = (resourceName, robot, msg) ->
  robot.http("http://#{server}/api/resources?resource=#{resourceName}&metrics=coverage").get() (err, res, body) ->
    handleError(err, res.statusCode, msg)

    resource = JSON.parse(body)[0]
    name = resource.name
    val = resource.msr[0].val
    msg.send "Unit test coverage for \"#{name}\" is #{val}%"

findResource = (robot, msg, searchTerm, callback) ->
  robot.http("http://#{server}/api/resources").get() (err, res, body) ->
    handleError(err, res.statusCode, msg)
    resourceName = resource.key for resource in JSON.parse(body) when resource.key.toLowerCase().indexOf(searchTerm.toLowerCase()) isnt -1
    if resourceName? callback(resourceName, robot, msg) 
    else msg.send "Resource \"#{searchTerm}\" not found"

handleError = (err, statusCode, msg) ->
  if err
    msg.send "Encountered an error: #{err}"
    return

  if statusCode isnt 200
    msg.send "Request didn't come back HTTP 200."
    return