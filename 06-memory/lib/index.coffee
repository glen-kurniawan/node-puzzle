fs = require 'fs'
readline = require 'readline'

exports.countryIpCounter = (countryCode, cb) ->
  return cb() unless countryCode
  
  counter = 0
  
  # create read stream
  input = fs.createReadStream "#{__dirname}/../data/geo.txt"

  # return if there is any error with the read stream
  input.on('error', (err) ->
    return cb err
  )

  # create interface to read line by line
  rl = readline.createInterface {input: input}

  # read line by line and add the counter if the country code == countryCode parameter
  rl.on('line', (line) -> 
    line = line.split '\t'
    if line[3] == countryCode then counter += +line[1] - +line[0]
  )

  # at the end of the stream callback to return the counter
  input.on('end', () ->
    cb null, counter
  )

  
