# Description:
#   Rodent Motivation
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# Author:
#   maddox
{Adapter,Robot,TextMessage,EnterMessage,LeaveMessage} = require 'hubot'
util = require 'util'

module.exports = (robot) ->
  robot.hear /R2: (.*)> R2: (.*)/i, (msg) ->
    proxy_user = msg.message.user
    proxy_user.name = msg.match[1]
    robot.receive new TextMessage(proxy_user, "R2: "+msg.match[2])
