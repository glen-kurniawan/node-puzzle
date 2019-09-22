assert = require 'assert'
WordCount = require '../lib'
fs = require 'fs'

helper = (input, expected, done) ->
  pass = false
  counter = new WordCount()

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()


describe '10-word-count', ->

  it 'should count a single word', (done) ->
    input = 'test'
    expected = words: 1, lines: 1, characters: 4
    helper input, expected, done

  it 'should count words in a phrase', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1, characters: 20
    helper input, expected, done

  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!"'
    expected = words: 1, lines: 1, characters: 19
    helper input, expected, done

  # !!!!!
  # Make the above tests pass and add more tests!
  # !!!!!

  it 'should count camel cased words', (done) ->
    input = 'FunPuzzle'
    expected = words: 2, lines: 1, characters: 9
    helper input, expected, done

  it 'should count words from file 1,9,44.txt', (done) ->
    fs.readFile "./test/fixtures/1,9,44.txt", 'utf8', (err, data) ->
      input = data
      expected = words: 9, lines: 1, characters: 44
      helper input, expected, done

  it 'should count words from file 3,7,46.txt', (done) ->
    fs.readFile "./test/fixtures/3,7,46.txt", 'utf8', (err, data) ->
      input = data
      expected = words: 7, lines: 3, characters: 46
      helper input, expected, done

  it 'should count words from file 5,9,40.txt', (done) ->
    fs.readFile "./test/fixtures/5,9,40.txt", 'utf8', (err, data) ->
      input = data
      expected = words: 9, lines: 5, characters: 40
      helper input, expected, done
