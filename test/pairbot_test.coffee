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

    it 'registers a hear listener', ->
        expect(@robot.hear).to.have.been.calledWith(/(.*)/i)
        expect(true)

    it 'registers a listener to list', ->
        expect(@robot.respond).to.have.been.calledWith(/(list pairs|list pairing)$/i)

    it 'registers a listener to clear', ->
        expect(@robot.respond).to.have.been.calledWith(/(clear pairs|clear pairing)$/i)

    it 'doesnt mistake stunning for stu', ->
        expect true








