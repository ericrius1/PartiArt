FW.Bubbles = class Bubbles
  constructor: ->
    @name = 'bubbles'
    @riseSpeed = .05
    @numEmitters = 100
    @emitterActivateFraction = 1/ (@numEmitters)
    @spellEmitters = []
    @height = 220
    @distanceFromPlayer = 30
    @castingTimeoutInterval = 500
    @startingPos = new THREE.Vector3 0, 0, 0
    @fakeObject = new THREE.Mesh(new THREE.SphereGeometry(), new THREE.MeshBasicMaterial())


    texture = THREE.ImageUtils.loadTexture('assets/bubbles.png')
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
      colorStart.setRGB Math.random(), Math.random(), Math.random()
      colorEnd = new THREE.Color()
      colorEnd.setRGB Math.random(), Math.random(), Math.random()
      spellEmitter = new ShaderParticleEmitter
        positionSpread: new THREE.Vector3(1, 1, 1)
        sizeEnd: 5
        colorStart: colorStart
        colorEnd: colorEnd
        particlesPerSecond: 50
        opacityStart: 0.5
        opacityMiddle: 1
        opacityEnd: 0
        accelerationSpread: new THREE.Vector3(2, 2, 2)

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
    @castingTimeout = setTimeout(=>
      @castSpell()
    @castingTimeoutInterval)

  endSpell: ->
    window.clearTimeout @castingTimeout

  update: ->
    @spellGroup.tick()
    for spellEmitter in @spellEmitters
      spellEmitter.position.y += @riseSpeed

