const process = require('process')
const { Elm } = require('../dist/elm.js')

const app =
  Elm.Main.init()

let buffer = []
process.stdin.on('data', function (chunk) { buffer = buffer + chunk })
process.stdin.on('end', () => app.ports.stdin.send(buffer))

app.ports.stdout.subscribe((data) => process.stdout.write(data))
