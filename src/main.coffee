window.$ = document.querySelectorAll.bind(document)
Element::on = Element::addEventListener


if !Detector.webgl
   Detector.addGetWebGLMessage()

window.FW = {}
SC?.initialize({
    client_id: "7da24ca214bf72b66ed2494117d05480",
});

FW.sfxVolume = 0.2
FW.globalTick = 0.16
window.soundOn = true

window.onload = ->
  FW.myWorld = new FW.World()
  FW.myWorld.animate()
  FW.main = new FW.Main()
  infoEl = document.getElementsByClassName('infoWrapper')[0]
  infoShowing = false
  document.onclick = (event)-> 
    el = event.target;
    if (el.className is "icon") 
      infoEl.style.display = if infoShowing then 'none' else 'block'
      infoShowing = !infoShowing;

FW.Main = class Main
  constructor: ->
    if soundOn
      #Put a sound you want from soundcloud here
      SC.stream "/tracks/rameses-b-inspire", (sound)->
        if soundOn
          sound.play()





