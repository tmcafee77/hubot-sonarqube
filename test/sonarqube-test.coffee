chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'sonarqube', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/sonarqube')(@robot)

  it 'registers respond listeners', ->
    expect(@robot.respond).to.have.been.calledWith(/sonar set server (.*)/)
    expect(@robot.respond).to.have.been.calledWith(/sonar coverage (.*)/)
    expect(@robot.respond).to.have.been.calledWith(/sonar issues (.*)/)
