# Description:
#   No description
# 
# Dependencies:
#   None
#
# Configuration:
#
# Author:
#   manpages

module.exports = (robot) ->
  robot.router.post '/hubot/githooks/:action/:room', (req, res) ->
    room = req.params.room + '@is.memorici.de'
    action = req.params.action
    
    #data = JSON.parse req.body.payload
    #commits = data.commits
    
    msg = "#{action} by #{req.body.user} to #{req.body.wc}: #{req.body.msg}"
    robot.brain.data.commits ?= []
    robot.brain.data.commits.push {user: req.body.user, repo: req.body.wc, message: req.body.msg}

    robot.messageRoom room, msg
    #robot.messageRoom 'MagBo', req.body.payload
    #console.log(req.body.payload)
      
    res.writeHead 204, { 'Content-Length': 0 }
    res.end()
