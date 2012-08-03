# Description:
#   No description
# 
# Dependencies:
#   None
#
# Configuration:
#
# Commands:
# 	hubot count me commits for $user
# 	hubot count me ci $user
#
# Author:
#   manpages

module.exports = (robot) ->
  robot.router.post '/hubot/git/pushed/:room', (req, res) ->
    room = req.params.room + '@is.memorici.de'
    action = req.params.action
    
    msg = "#{req.body.user} just pushed #{req.body.num} commits to #{req.body.branch} in #{req.body.repo}"
    
    robot.messageRoom room, msg
    #robot.messageRoom 'MagBo', req.body.payload
    #console.log(req.body.payload)
      
    res.writeHead 204, { 'Content-Length': 0 }
    res.end()

#  robot.respond /count( me)? (commits|ci) (.*)/i, (msg) ->
#    who = msg.match[3]
	    

#    msg = "#{robot.brains.data.isltd.payloads.}"
