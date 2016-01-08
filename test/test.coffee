fs = require 'fs'
expect = require('chai').expect
CoffeeScript = require 'coffee-script'
Rule = require '../index'

getFixtureAST = (fixture)->
  source = fs.readFileSync("#{__dirname}/fixtures/#{fixture}.coffee").toString()
  return CoffeeScript.nodes source

describe 'lint the things', ->


  getErrors = (fixture)=>
    @rule = new Rule()
    @rule.errors = []
    astApi =
      config: use_strict: {}
      createError: (e) -> e
    @rule.lintAST getFixtureAST(fixture), astApi
    @rule.errors.sort (a, b)->
      return a.lineNumber > b.lineNumber
    return

  it 'Numbers', =>
    getErrors('numbers')
    expect(@rule.errors.length).to.be.equal(6)
    expect(@rule.errors[0].lineNumber).to.be.equal(2)
    expect(@rule.errors[1].lineNumber).to.be.equal(5)
    expect(@rule.errors[2].lineNumber).to.be.equal(10)
    expect(@rule.errors[3].lineNumber).to.be.equal(16)
    expect(@rule.errors[4].lineNumber).to.be.equal(27)
    expect(@rule.errors[5].lineNumber).to.be.equal(33)
    return

  it 'strings', =>
    getErrors('strings')
    expect(@rule.errors.length).to.be.equal(6)
    expect(@rule.errors[0].lineNumber).to.be.equal(2)
    expect(@rule.errors[1].lineNumber).to.be.equal(5)
    expect(@rule.errors[2].lineNumber).to.be.equal(10)
    expect(@rule.errors[3].lineNumber).to.be.equal(16)
    expect(@rule.errors[4].lineNumber).to.be.equal(27)
    expect(@rule.errors[5].lineNumber).to.be.equal(33)
    return

  it 'functions', =>
    getErrors('funcs')
    expect(@rule.errors.length).to.be.equal(2)
    expect(@rule.errors[0].lineNumber).to.be.equal(2)
    expect(@rule.errors[1].lineNumber).to.be.equal(7)
    return

  it 'random tests', =>
    getErrors('basic')
    expect(@rule.errors.length).to.be.equal(5)
    expect(@rule.errors[0].lineNumber).to.be.equal(9)
    expect(@rule.errors[1].lineNumber).to.be.equal(16)
    expect(@rule.errors[2].lineNumber).to.be.equal(17)
    expect(@rule.errors[3].lineNumber).to.be.equal(25)
    expect(@rule.errors[4].lineNumber).to.be.equal(27)
    return
  return
