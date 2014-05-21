FW.Fire = class Fire
  constructor: ->
    @name = 'fire'
    @numEmitters = 200
    @emitterActivateFraction = 1/ (@numEmitters)
    @spellEmitters = []
    @distanceFromPlayer = 50
    @castingTimeoutInterval = 50
    @fakeObject = new THREE.Mesh(new THREE.SphereGeometry(), new THREE.MeshBasicMaterial())


    texture = THREE.ImageUtils.loadTexture('assets/smokeparticle.png')
    texture.minFilter = THREE.LinearMipMapLinearFilter;

    @spellGroup = new ShaderParticleGroup
      texture: texture
      maxAge: 2
      # blending: THREE.NormalBlending

    @initializeSpells()
    @spellGroup.mesh.renderDepth = -1;
    FW.scene.add(@spellGroup.mesh)
  initializeSpells: ->
    for i in [0...@numEmitters]
      colorStart = new THREE.Color()
      colorStart.setHSL rnd(0.55, 0.65), .3, .3
      colorEnd = new THREE.Color()
      colorEnd.setHSL rnd(0, .1), 0.8, 0.3
      spellEmitter = new ShaderParticleEmitter
        positionSpread: new THREE.Vector3(2, 7, 2)
        sizeEnd: 15
        colorStart: colorStart
        colorEnd: colorEnd
        particlesPerSecond: 50
        opacityStart: 0.8
        opacityMiddle: 1.0
        opacityEnd: 0.1
        acceleration: new THREE.Vector3 0, rnd(1, 4), 0
        velocity: new THREE.Vector3(0, 10, 0)
        accelerationSpread: new THREE.Vector3(3, 1, 3)

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
        spellEmitter.position.y = Math.max 0, spellEmitter.position.y-50
        spellEmitter.enable()
        FW.spellsToUndo.push spellEmitter
    @castingTimeout = setTimeout(=>
      @castSpell()
    @castingTimeoutInterval)

  endSpell: ->
    window.clearTimeout @castingTimeout

  update: ->
    @spellGroup.tick()


