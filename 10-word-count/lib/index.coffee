through2 = require 'through2'


module.exports = ->
  words = 0
  lines = 0
  characters = 0

  transform = (chunk, encoding, cb) ->

    # handle quote chunk, I do this by replacing any of the quoted words with the word quote, ex: "word" => quote
    # it might not be ideal, but since the puzzle only require the count of the word, this should work
    unQuoteChunk = chunk.replace(/"([^\\"]|\\")*"/g, 'quote')

    # handle camel case chunk, the first replace will replace CamelCase to Camel Case (Camel space Case)
    # however, it will affect the normal (not camel case words), therefore I do another replace and trim to fix the space
    unCamelCaseChunk = unQuoteChunk.replace(/([A-Z]+|[A-Z]?[a-z]+)(?=[A-Z]|\b)/g, '$1 ').replace(/\s\s+/g, ' ').trim()

    # split by space and filter to only non blank token get the length to get the count of words
    tokens = unCamelCaseChunk.split(' ').filter (t) -> t.length > 0
    words = tokens.length

    # split by \n and filter to only the non blank lines to get the count of lines
    linesArray = chunk.split('\n').filter (l) -> l.length > 0
    lines = linesArray.length
    
    # replace the \n with '' and get the length to get the count of characters
    characters = chunk.replace(/\n/g, '').length

    return cb()

  flush = (cb) ->
    this.push {words, lines, characters}
    this.push null
    return cb()

  

  return through2.obj transform, flush
