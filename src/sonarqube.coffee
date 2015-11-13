# Description:
#   A hubot script that displays stats from SonarQube.
#
# Dependencies:
#   N/A
#
# Configuration:
#   knife configured in your $PATH, you'll see a WARNING in console if you don't have it
#
# Commands:
#   hubot sonar set server <server> - Set address of SonarQube server
#   hubot sonar coverage <project name> - chef: Runs chef-client across an environment
#   hubot sonar issues <project name> -  chef: Lists all environments on chef server
#
# Author:
#   Peter Strapp <peter@strapp.co.uk>
#   Brian Antonelli <brian.antonelli@autotrader.com>
#


server = process.env.HUBOT_JENKINS_URL
auth = 'Basic ' + new Buffer(process.env.HUBOT_JENKINS_AUTH).toString('base64')

module.exports = (robot) ->
  robot.respond /sonar coverage (.*)/, (msg) ->
    findResource robot, msg, msg.match[1], (resourceName, robot, msg) ->
      coverage(resourceName, robot, msg)

  robot.respond /sonar issues (.*)/, (msg) ->
    findResource robot, msg, msg.match[1], (resourceName, robot, msg) ->
      violations(resourceName, robot, msg)

  robot.respond /sonar set server (.*)/, (msg) ->
    #server = msg.match[1].replace(/http:\/\//i, '')
    msg.send "Sonar server set to: #{server}"

coverage = (resourceName, robot, msg) ->
  robot.http("#{server}/api/resources?resource=#{resourceName}&metrics=coverage")
    .headers(Authorization: auth)
    .get() (err, res, body) ->
    handleError(err, res.statusCode, msg)

    resource = JSON.parse(body)[0]
    name = resource.name
    val = resource.msr[0].val
    msg.send "Unit test coverage for \"#{name}\" is #{val}%."

violations = (resourceName, robot, msg) ->
  robot.http("#{server}/api/resources?resource=#{resourceName}&metrics=violations")
    .headers(Authorization: auth)
    .get() (err, res, body) ->
    handleError(err, res.statusCode, msg)

    resource = JSON.parse(body)[0]
    name = resource.name
    val = resource.msr[0].val
    msg.send "The project \"#{name}\" has #{val}% issues."

findResource = (robot, msg, searchTerm, callback) ->
  robot.http("#{server}/api/resources")
    .headers(Authorization: auth)
    .get() (err, res, body) ->
    handleError(err, res.statusCode, msg)
    resourceName = resource.key for resource in JSON.parse(body) when resource.key.toLowerCase().indexOf(searchTerm.toLowerCase()) isnt -1

    if typeof resourceName isnt 'undefined'
      callback(resourceName, robot, msg)
    else
      msg.send "Resource \"#{searchTerm}\" not found"

handleError = (err, statusCode, msg) ->
  if err
    msg.send "Encountered an error: #{err}"
    return

  if statusCode isnt 200
    msg.send "Request didn't come back HTTP 200."
    return
