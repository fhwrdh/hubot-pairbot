# Description
#   Forwards messages to a pair.
#
# Dependencies
#
#
# Configuration
#
#
# Commands
#   pairbot start pairing with <user>
#   pairbot stop pairing
#   pairbot clear pairs
#   pairbot list pairs
#   pairbot help
#
# Notes
#   - 'start pairing' will clobber any previous pairing.
#   -
#
# Author:
#   fhwrdh@fhwrdh.net
#
_         = require 'underscore'
moment    = require 'moment'
stringify = JSON.stringify

commands =
    start: [
        'spw'
        'pair with'
        'pairing with'
        'start pairing with'
        'start with'
        'i\'m pairing with'
    ].join('|')
    stop: [
        'spw'
        'stop pairing'
        'done pairing'
        'end pairing'
        'not pairing'
        'stop'
        'done'
    ].join('|')
    list: [
        'list pairs'
        'list pairing'
        'list'
    ].join('|')
    clear: [
        'clear pairs'
        'clear pairing'
        'clear'
    ].join('|')

START_PAIRING = ///(#{commands.start})\s+(.+)///i
STOP_PAIRING  = ///(#{commands.stop})$///i
LIST_PAIRS    = ///(#{commands.list})$///i
CLEAR_PAIRS   = ///(#{commands.clear})$///i
HELP          = ///(\?|help)///i

getStorage = (robot) ->
    return JSON.parse(robot.brain.get 'pairbot') or {}

setStorage = (robot, data) ->
    robot.brain.set 'pairbot', stringify(data)

startPair = (robot, msg) ->
    data = getStorage robot
    user = msg.message.user.name
    pair = msg.match[2]
    data[user] = { pair: pair, ts: moment.utc() }
    setStorage robot, data
    msg.reply "Got it, you are now pairing with #{pair}"

stopPair = (robot, msg) ->
    data = getStorage robot
    user = msg.message.user.name
    if not data[user]?
        msg.reply "Hmmm, didn't have you in the list"
    else
        pairing = data[user]
        delete data[user]
        setStorage robot, data
        msg.reply "Got it, you are done pairing with #{pairing.pair}"

listPairs = (robot, msg) ->
    data = getStorage robot
    if not data or _.keys(data).length == 0
        msg.send "Looks like nobody is pairing right now? Weird."
    else
        count = _.keys(data).length
        msg.send "Listing #{count} pairs:"
        _.each data, (value, key) ->
            time = moment(value.ts).fromNow()
            msg.send "  #{key} pairing with #{value.pair} since #{time}"

clearPairs = (robot, msg) ->
    data = getStorage robot
    setStorage robot, {}
    msg.send "Ok, all pairs cleared. Hope you know what you are doing."

sendHelp = (robot, msg) ->
    msg.send "Need help? I respond to the following commands (and a few aliases):"
    msg.send "  start pairing with <user>"
    msg.send "  stop pairing"
    msg.send "  list pairs"
    msg.send "  help"

extras =
    Shell: 'testing'

getExtrasFor = (user) ->
    extra = extras[user]
    if extra?
        return " (#{extra})"
    ''

listen = (robot, msg) ->
    return if STOP_PAIRING.test msg.message
    return if START_PAIRING.test msg.message
    return if LIST_PAIRS.test msg.message
    return if CLEAR_PAIRS.test msg.messag

    data = getStorage robot
    found = _.find _.keys(data), (key) ->
        return ///\b#{key}\b///.test msg.message.text
    return unless found

    pairing = data[found]

    # dont repeat the message is the pair is already mentioned
    pairMentioned = ///\b#{pairing.pair}\b///.test msg.message.text
    return if pairMentioned

    # don't repeat the message if sent from the pair
    sender = msg.message.user.name
    return if sender == pairing.pair

    extrasForFound = getExtrasFor found
    msg.send "#{pairing.pair}: #{msg.message.text}#{extrasForFound}"

module.exports = (robot) ->

    robot.respond HELP, (msg) ->
        sendHelp robot, msg

    robot.respond START_PAIRING, (msg) ->
        startPair robot, msg

    robot.respond STOP_PAIRING, (msg) ->
        stopPair robot, msg

    robot.respond LIST_PAIRS, (msg) ->
        listPairs robot, msg

    robot.respond CLEAR_PAIRS, (msg) ->
        clearPairs robot, msg

    robot.respond /(.*)/, (msg) ->
        if msg.match[1] == ''
            sendHelp robot, msg

    robot.hear /(.*)/, (msg) ->
        listen robot, msg

    testHelper =
        testListen: listen
    return testHelper

