ccc = 888

console.log 1,2,3, a_cb, a_cb()

expect(ccc.getProperty(ccc)).to.be.null

a_cb = ()->
  c = 9
  a = "asdf#{1}asdf#{2}a#{abc()}"
  return

a_cb()
a_cb()

"asdf#{3}asdf#{4}"

if 1
  "asdf#{ccc}asdf#{a()}"

just_a_variable = 999

doSomeStuff = ()->
  just_a_variable
  return

async = require 'async'
steps = []
steps.push (cb)->
  if 1
    cb 1
  cb 0
  return

steps.push (cb)->
  if 1
    cb 1
  cb 0
  return

steps.push (cb,extra)->
  a = 9
  b = 5
  cb()
  return

steps.push (cb)->
  if 1
    cb 1
  else
    cb 2
  return

func = (cb)->
  if 1
    cb 1
    return
  cb 0
  return

steps.push func

async.each steps, (err)->
  process.exit 0
  return

(->
  console.log(123)
)()