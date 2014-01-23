FW.Controls = class Controls
  constructor: ->
    FW.controls = new THREE.PointerLockControls(FW.camera)

    document.addEventListener 'click', (event)->

      havePointerLock = "pointerLockElement" of document or "mozPointerLockElement" of document or "webkitPointerLockElement" of document
      if havePointerLock
        element = document.body
        pointerLockChange = (event)=>
          if document.pointerLockElement = element || document.mozPointerLockElement == element || document.webkitPointerLockElement == element 
            FW.controls.enabled = true
            
        #Ask the browser to lock the pointer
        element.requestPointerLock = element.requestPointerLock || element.mozRequestPointerLock || element.webkitRequestPointerLock
        element.requestPointerLock()



      document.addEventListener( 'pointerlockchange', -> 
          pointerLockChange()
          false );
      document.addEventListener( 'mozpointerlockchange', pointerLockChange, false );
      document.addEventListener( 'webkitpointerlockchange', -> 
        pointerLockChange()
        false )

  update: ->
    @controls.update()