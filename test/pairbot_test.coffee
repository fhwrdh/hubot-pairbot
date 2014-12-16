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

describe 'listening', ->

    beforeEach ->
        @robot =
            respond: sinon.spy()
            hear:    sinon.spy()
            brain:
                get: () ->
                    data =
                        stu:
                            pair: 'billy'
                    return JSON.stringify data

        @pairbot = require('../src/pairbot') (@robot)

    it 'registers a hear listener', ->
        expect(@robot.hear).to.have.been.calledWith(/(.*)/i)

    buildMessage = (text) ->
        msg =
            message:
                text: text
            send: (response) ->
                @response = response
        msg

    it 'does correctly match', ->
        messages = [
            'stu'
            '@stu'
            'stu:'
        ]
        for msg in messages
            msg = buildMessage msg
            @pairbot.testListener @robot, msg
            expect(msg.response).to.not.be.undefined

    it 'doesnt mistakenly match', ->
        messages = [
            'stunning'
            '1stu'
            'stu1'
            's t u'
        ]
        for msg in messages
            msg = buildMessage msg
            @pairbot.testListener @robot, msg
            expect(msg.response).to.be.undefined


