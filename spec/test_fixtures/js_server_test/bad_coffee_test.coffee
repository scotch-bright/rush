 This is a little script that will refresh the contents on your page every 5 seconds. 
# This helps you to make changes and see them in the browser instantly. Just a little 
# convenience baked into the Rush framework. This will be automatically removed when
# your site is being made ready for production. DO NOT place any JS here and DO NOT
# change the name of this file and everything will go well.
window.onload = ->
  setInterval (->
    location.reload()
    return
  ), 10000
  return