
'bad'

if 'good'
  'bad'

if 'good'
  a = 'good'

'bad'

a = ()->
  'good'

b = ()->
  'bad'
  return

c = ()->
  return 'good'

class Thing
  aaa: ()->
    return

  bbb: ()->
    'bad'
    return

  ccc: ()->
    return 'good'

{d:'bad'}

good = "good"
good = "good#{good}good"