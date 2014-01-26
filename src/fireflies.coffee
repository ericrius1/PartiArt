FW.Fireflies = class Fireflies
  constructor: ->
    @name = 'fireflies'
    @wormholeSpeed = 1
    @riseSpeed = .1
    @numEmitters = 10
    @emitterActivateFraction = 1/ (@numEmitters)
    @spellEmitters = []
    @height = 220
    @distanceFromPlayer = 70
    @castingTimeoutInterval = 1000
    @startingPos = new THREE.Vector3 0, 0, 0
    @fakeObject = new THREE.Mesh(new THREE.SphereGeometry(1), new THREE.MeshBasicMaterial())


    texture = THREE.ImageUtils.loadTexture('assets/firefly.png')
    texture.minFilter = THREE.LinearMipMapLinearFilter;

    @spellGroup = new ShaderParticleGroup
      texture: texture
      maxAge: 3

    @initializeSpells()
    FW.scene.add(@spellGroup.mesh)
  initializeSpells: ->
    for i in [0...@numEmitters]
      spellEmitter = new ShaderParticleEmitter
        positionSpread: new THREE.Vector3(60, 20, 60)
        size: 10
        sizeEnd: 10
        colorEnd: new THREE.Color()
        particlesPerSecond: 100
        opacityStart: 0.5
        opacityMiddle: 1
        opacityEnd: 0.5
        velocitySpread: new THREE.Vector3(5, 5, 5)
        accelerationSpread: new THREE.Vector3(2, 2, 2)

      @spellGroup.addEmitter spellEmitter
      @spellEmitters.push spellEmitter
      spellEmitter.disable()

#velocity at start over accel at start is time of flight

  castSpell: ->
    # FW.scene.remove @fakeObject
    # FW.scene.add @fakeObject
    @fakeObject.position.copy FW.controls.getPosition()
    @direction = FW.controls.getDirection()
    @fakeObject.translateZ(@direction.z * @distanceFromPlayer)
    @fakeObject.translateY(@direction.y * @distanceFromPlayer)
    @fakeObject.translateX(@direction.x * @distanceFromPlayer)

    for spellEmitter in @spellEmitters
      if Math.random() < @emitterActivateFraction
        spellEmitter.position.copy(@fakeObject.position)
        spellEmitter.enable()
    @castingTimeout = setTimeout(=>
      @castSpell()
    @castingTimeoutInterval)

  endSpell: ->
    window.clearTimeout @castingTimeout

  update: ->
    @spellGroup.tick()





