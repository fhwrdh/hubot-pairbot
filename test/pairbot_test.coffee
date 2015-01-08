chai   = require 'chai'
sinon  = require 'sinon'
chai.use require 'sinon-chai'
expect = chai.expect

describe 'pairbot', ->
    beforeEach ->
        @robot =
            respond: sinon.spy()
            hear:    sinon.spy()
        require('../src/pairbot')(@robot)

    it 'registers a listener to list', ->
        expect(@robot.respond).to.have.been.calledWith(/(list pairs|list pairing|list)$/i)

    it 'registers a listener to clear', ->
        expect(@robot.respond).to.have.been.calledWith(/(clear pairs|clear pairing|clear)$/i)

    it 'registers a listener for help', ->
        expect(@robot.respond).to.have.been.calledWith(/(\?|help)/i)

describe 'listening', ->

    beforeEach ->
        @robot =
            respond: sinon.spy()
            hear:    sinon.spy()
            brain:
                set: sinon.spy()
                get: () ->
                    data =
                        stu:
                            pair: 'billy'
                    return JSON.stringify data

        @pairbot = require('../src/pairbot') (@robot)



    it 'registers a hear listener', ->
        expect(@robot.hear).to.have.been.calledWith(/(.*)/)

    buildMessage = (text) ->
        msg =
            message:
                user:
                    name: 'TEST'
                text: text
            reply: (reply) -> @reply = reply
            send: (response) -> @response = response
        msg

    it 'should let the pair end the pairing session', ->
        msg = buildMessage 'MESSAGE'
        msg.message.user.name = 'billy'
        @pairbot.testStopPair @robot, msg
        expect(msg.reply).to.equal 'Got it, you are done pairing with stu'

    it 'repeats message to pair', ->
        msg = buildMessage 'stu: MESSAGE'
        @pairbot.testListen @robot, msg
        expect(msg.response).to.equal 'billy: stu: MESSAGE'

    it 'does not repeat message to pair when pair is already mentioned', ->
        # billy is the pair
        msg = buildMessage 'stu billy: MESSAGE'
        @pairbot.testListen @robot, msg
        expect(msg.response).to.be.undefined

    it 'does not repeat the message to the pair if it comes from the pair', ->
        msg = buildMessage 'stu: MESSAGE'
        msg.message.user.name = 'billy'
        @pairbot.testListen @robot, msg
        expect(msg.response).to.be.undefined



    it 'does correctly match names', ->
        messages = [
            'stu'
            '@stu'
            'stu:'
        ]
        for msg in messages
            msg = buildMessage msg
            @pairbot.testListen @robot, msg
            expect(msg.response).to.not.be.undefined

    it 'doesnt mistakenly match names', ->
        messages = [
            'stunning'
            '1stu'
            'stu1'
            's t u'
        ]
        for msg in messages
            msg = buildMessage msg
            @pairbot.testListen @robot, msg
            expect(msg.response).to.be.undefined


