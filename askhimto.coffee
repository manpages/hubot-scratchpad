# Description:
#  Ask him to do something 
#
# Commands:
#   hubot ask <user> to <action> — ask <user> someone to do <action>
#   hubot [I have] done <action_id> — report that you have finished action with <action_id>
#   hubot [what] to[ ]do — list <action_id>: <action> you have to perform
#   hubot suggest <user> to <action> for <category>

Util = require "util"
{TextMessage,EnterMessage,LeaveMessage,CatchAllMessage} = require '../node_modules/hubot/src/message'

class HumanTaskManager
  constructor: (@robot) ->
    @free_message = [
      "Consider going out?",
      "You may take your time to read a book!",
      "Maybe there was something that wasn't on the list?",
      "Now go upgrade your linux distro. It takes a lot of time lately.",
      "Chill.",
      "Relax.",
      "Have fun.",
      "But you might assign a task to somebody. Isn't it fun?",
      "Don't forget to push your changes!",
      "Don't forget to add new files in the repo!",
      "Take a deep breath and taste the freedom.",
      "You are free to sleep now",
      "Everyone is grateful to you!",
      "And this is horosho."
    ]

  stuff_to_do: (who, msg) ->
    if @robot.brain.data.todo && @robot.brain.data.todo[who]
      msg.send "By the way, you have stuff to do. For instance"
      msg.send msg.random @robot.brain.data.todo[who]

  data_init: () ->
    @robot.brain.data.todo ?= {}
    @robot.brain.data.done ?= {}
    @robot.brain.data.suggestions ?= {}
    @robot.brain.data.trashcan ?= []

  person_init: (who) ->
    @robot.brain.data.todo[who] ?= []
    @robot.brain.data.done[who] ?= []

  ask: (who, what, msg) ->
    @robot.brain.data.todo[who].push what
    msg.send "Ok"
    @robot.brain.save(@robot.brain.data)
     
  done: (aid, who, msg) ->
    whatlist = @robot.brain.data.todo[who].splice(aid, 1)
    @robot.brain.data.done[who].push whatlist[0]
    msg.send whatlist[0]+" → (done)"
    if @robot.brain.data.todo[who].length == 0
      msg.send "You have no tasks left, congratulations for being productive!" 
      msg.send msg.random taskmanager.free_message
    msg.send "That's great! You have more important stuff to do though." if @robot.brain.data.todo[who].length != 0
    @robot.brain.save(@robot.brain.data)

  todo: (who, msg) ->
    todo = "\n"
    todo += "   | "+@robot.brain.data.todo[who].indexOf(what)+": "+what+"\n" for what in @robot.brain.data.todo[who]
    msg.send todo if @robot.brain.data.todo[who].length != 0
    if @robot.brain.data.todo[who].length == 0
      msg.send "Nothing to do yet."
      msg.send msg.random taskmanager.free_message
    @robot.brain.save(@robot.brain.data)
  
  suggest: (who, what, cat, msg) ->
    @robot.brain.data.suggestions ?= {}
    @robot.brain.data.suggestions[cat] ?= {}
    @robot.brain.data.suggestions[cat][who] ?= []
    @robot.brain.data.suggestions[cat][who].push what
    msg.send "("+cat+") ← "+what

  mood_for: (who, cat, msg) ->
    todo = "\n"
    if @robot.brain.data.suggestions[cat] && @robot.brain.data.suggestions[cat][who]
      todo += "   | "+@robot.brain.data.suggestions[cat][who].indexOf(sgt)+": "+sgt+"\n" for sgt in @robot.brain.data.suggestions[cat][who]
      msg.send todo
    else
      msg.send "Sadly, you don't have anything suggested for «"+cat+"» mood"
    @stuff_to_do who, msg

  enjoyed: (who, cat, aid, msg) ->
    if @robot.brain.data.suggestions[cat] && @robot.brain.data.suggestions[cat][who]
      whatlist = @robot.brain.data.suggestions[cat][who].splice(aid, 1)
      @robot.brain.data.trashcan.push whatlist[0]
    msg.send whatlist[0]+"→ (done)"
    taskmanager.stuff_to_do who, msg


 
module.exports = (robot) ->

  taskmanager = new HumanTaskManager(robot)

  robot.respond /ask (.*?) to (.*)/i, (msg) ->
    who = msg.match[1].toLowerCase()
    what = msg.match[2]
    taskmanager.data_init()
    taskmanager.person_init(who)
    taskmanager.ask(who, what, msg)

  robot.respond /(I have )?done (\d+)/i, (msg) ->
    aid = msg.match[2]
    who = msg.message.user.name.toLowerCase()
    taskmanager.data_init()
    taskmanager.person_init(who)
    taskmanager.done(aid, who, msg)

  robot.respond /(what )?to( )?do/i, (msg) ->
    who = msg.message.user.name.toLowerCase()
    taskmanager.data_init()
    taskmanager.person_init(who)
    taskmanager.todo(who, msg)
  
  robot.respond /suggest (.*?) to (.*) for (.*)/i, (msg) ->
    who = msg.match[1].toLowerCase()
    what = msg.match[2]
    cat = msg.match[3]
    taskmanager.data_init()
    taskmanager.person_init(who)
    taskmanager.suggest(who, what, cat, msg)
 
  robot.respond /moods/i, (msg) ->
    out = Util.inspect(robot.brain.data.suggestions, false, 1)
    msg.send out

  robot.respond /mood for (.*) as (.*)/i, (msg) ->
    cat = msg.match[1]
    who = msg.match[2].toLowerCase()
    taskmanager.data_init()
    taskmanager.person_init(who)
    taskmanager.mood_for(who, cat, msg)

  robot.respond /mood for (.*)/i, (msg) ->
    cat = msg.match[1]
    who = msg.message.user.name.toLowerCase()
    taskmanager.data_init()
    taskmanager.person_init(who)
    taskmanager.mood_for(who, cat, msg)    

  robot.respond /(enjoyed|disliked) (.*) (\d*)/i, (msg) ->
    cat = msg.match[2]
    aid = msg.match[3]
    who = msg.message.user.name.toLowerCase()
    taskmanager.data_init()
    taskmanager.person_init(who)
    taskmanager.enjoyed(who, cat, aid, msg)

  robot.respond /dev askhimto delete (.*) end( invalid user (.*))? end/i, (msg) ->
    taskmanager.data_init()
    if msg.match[2]
      msg.send robot.brain.data.suggestions[msg.match[1]][msg.match[3]] 
      delete robot.brain.data.suggestions[msg.match[1]][msg.match[3]]
    else
      msg.send robot.brain.data.suggestions[msg.match[1]]
      delete robot.brain.data.suggestions[msg.match[1]]
    msg.send "Ok"
