through2 = require 'through2'


module.exports = ->
  words = 0
  lines = 0
  characters = 0

  transform = (chunk, encoding, cb) ->
    unQuoteChunk = chunk.replace(/"([^\\"]|\\")*"/g, 'quote')
    unCamelCaseChunk = unQuoteChunk.replace(/([A-Z]+|[A-Z]?[a-z]+)(?=[A-Z]|\b)/g, '$1 ').replace(/\s\s+/g, ' ').trim()
    tokens = unCamelCaseChunk.split(' ')
    words = tokens.length
    linesArray = chunk.split('\n').filter (l) -> l.length > 0
    lines = linesArray.length
    characters = chunk.replace(/\n/g, '').length

    return cb()

  flush = (cb) ->
    this.push {words, lines, characters}
    this.push null
    return cb()

  

  return through2.obj transform, flush
