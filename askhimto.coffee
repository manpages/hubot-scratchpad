# Description:
#  Ask him to do something 
#
# Commands:
#   hubot ask <user> to <action> — ask <user> someone to do <action>
#   hubot [I have] done <action_id> — report that you have finished action with <action_id>
#   hubot [what] to[ ]do — list <action_id>: <action> you have to perform

module.exports = (robot) ->

  robot.respond /ask (.*)? to (.*)/i, (msg) ->
    who = msg.match[1].toLowerCase()
    what = msg.match[2]
    robot.brain.data ?= []
    robot.brain.data.todo ?= {}
    robot.brain.data.todo[who] ?= []
    robot.brain.data.done ?= {}
    robot.brain.data.done[who] ?= []
    robot.brain.data.todo[who].push what
    msg.send "Ok"
    robot.brain.save(robot.brain.data)

  robot.respond /(I have )?done (\d+)/i, (msg) ->
    aid = msg.match[2]
    who = msg.message.user.name.toLowerCase()
    robot.brain.data ?= []
    robot.brain.data.todo ?= {}
    robot.brain.data.todo[who] ?= []
    robot.brain.data.done ?= {}
    robot.brain.data.done[who] ?= []
    whatlist = robot.brain.data.todo[who].splice(aid, 1)
    robot.brain.data.done[who].push whatlist[0]
    msg.send whatlist[0]+"→"
    msg.send "You have no tasks left, congratulations for being productive!" if robot.brain.data.todo[who].length == 0
    msg.send "That's great! You have more important stuff to do though." if robot.brain.data.todo[who].length != 0
    robot.brain.save(robot.brain.data)

  robot.respond /(what )?to( )?do/i, (msg) ->
    who = msg.message.user.name.toLowerCase()
    robot.brain.data ?= []
    robot.brain.data.todo ?= {}
    robot.brain.data.todo[who] ?= []
    robot.brain.data.done ?= {}
    robot.brain.data.done[who] ?= []
    todo = "\n"
    todo += robot.brain.data.todo[who].indexOf(what)+": "+what+"\n" for what in robot.brain.data.todo[who]
    msg.send todo if robot.brain.data.todo[who].length != 0
    msg.send "You have nothing left to do" if robot.brain.data.todo[who].length == 0
    robot.brain.save(robot.brain.data)
   
#
#  robot.respond /pug bomb( (\d+))?/i, (msg) ->
#    count = msg.match[2] || 5
#    msg.http("http://pugme.herokuapp.com/bomb?count=" + count)
#      .get() (err, res, body) ->
#        msg.send pug for pug in JSON.parse(body).pugs
#
#  robot.respond /how many pugs are there/i, (msg) ->
#    msg.http("http://pugme.herokuapp.com/count")
#      .get() (err, res, body) ->
#        msg.send "There are #{JSON.parse(body).pug_count} pugs."
