FW.Mystery = class Mystery
  constructor: ->
    @name = 'mystery'
    @numEmitters = 20000
    @emitterActivateFraction = 1/ (@numEmitters)
    @spellEmitters = []
    @height = 220
    @distanceFromPlayer = 50
    @castingTimeoutInterval = 50
    @startingPos = new THREE.Vector3 0, 0, 0
    @fakeObject = new THREE.Mesh(new THREE.SphereGeometry(), new THREE.MeshBasicMaterial())


    texture = THREE.ImageUtils.loadTexture('assets/smokeparticle.png')
    texture.minFilter = THREE.LinearMipMapLinearFilter;

    @spellGroup = new ShaderParticleGroup
      texture: texture
      maxAge: 20
      # blending: THREE.NormalBlending

    @initializeSpells()
    FW.scene.add(@spellGroup.mesh)
  initializeSpells: ->
    for i in [0...@numEmitters]
      colorStart = new THREE.Color()
      colorStart.setRGB 1.0, 0, 0
      spellEmitter = new ShaderParticleEmitter
        size: 10
        sizeEnd: 100000
        colorStart: colorStart
        particlesPerSecond: 1
        opacityStart: 0.2
        opacityMiddle: 1
        opacityEnd: 1

      @spellGroup.addEmitter spellEmitter
      @spellEmitters.push spellEmitter
      spellEmitter.disable()

#velocity at start over accel at start is time of flight

  castSpell: ->
    # FW.scene.remove @fakeObject
    # FW.scene.add @fakeObject
    @fakeObject.position.copy FW.controls.getPosition()
    direction = FW.controls.getDirection()
    @fakeObject.translateZ(direction.z * @distanceFromPlayer)
    @fakeObject.translateY(direction.y * @distanceFromPlayer)
    @fakeObject.translateX(direction.x * @distanceFromPlayer)
    for spellEmitter in @spellEmitters
      if Math.random() < @emitterActivateFraction
        spellEmitter.position.copy(@fakeObject.position)
        spellEmitter.position.y = Math.max 5, spellEmitter.position.y
        spellEmitter.enable()
        FW.spellsToUndo.push spellEmitter
    @castingTimeout = setTimeout(=>
      @castSpell()
    @castingTimeoutInterval)

  endSpell: ->
    window.clearTimeout @castingTimeout

  update: ->
    @spellGroup.tick()

