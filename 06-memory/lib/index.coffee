fs = require 'fs'
readline = require 'readline'

exports.countryIpCounter = (countryCode, cb) ->
  return cb() unless countryCode
  
  counter = 0
  
  input = fs.createReadStream "#{__dirname}/../data/geo.txt"

  rl = readline.createInterface {input: input}

  rl.on('line', (line) -> 
    line = line.split '\t'
    if line[3] == countryCode then counter += +line[1] - +line[0]
  )

  input.on('end', () ->
    cb null, counter
  )

  
