FW.Meteors = class Meteors
  constructor: ()->
    @calcTimeout = 1000
    @meteors = []
    @meteorGroup = new ShaderParticleGroup
      texture: THREE.ImageUtils.loadTexture('assets/star.png'),
      blending: THREE.AdditiveBlending,
      maxAge: 3
    @meteorVisibleDistance = 50000
    for i in [1..6]
      @newMeteor()
    FW.scene.add(@meteorGroup.mesh)
    @calcPositions()

    

  resetMeteor: (meteor)->
    meteor.speedX = rnd(0.01, 3)
    meteor.speedZ = rnd(0.01, 3)
    meteor.speedY = 0
    meteor.accelX = rnd(.001, .2)
    meteor.accelZ = rnd(.001, .2)
    meteor.accelY = rnd(-0.005, 0.005)
    meteor.dirX = rnd(-1, 1)
    meteor.dirY = -1
    meteor.dirZ = rnd(1, -1)
    meteor.position = new THREE.Vector3(rnd(-30000, 30000), rnd(2000, 7000), rnd(-30000, 30000))


  newMeteor: ->
    colorStart = new THREE.Color()
    colorStart.setRGB(Math.random(),Math.random(),Math.random() )
    meteor = new THREE.Object3D()
    @resetMeteor meteor
    colorEnd = new THREE.Color()
    colorEnd.setRGB(Math.random(),Math.random(),Math.random() )
    meteor.light = new THREE.PointLight(colorStart, 2, 1000)
    FW.scene.add(meteor.light)
    meteor.tailEmitter = new ShaderParticleEmitter
      position: meteor.position
      positionSpread: new THREE.Vector3(20, 20, 2)
      size: rnd(100, 1000)
      sizeSpread: 500
      acceleration: new THREE.Vector3(meteor.dirX * .1, meteor.dirY * .1, meteor.dirZ * .1),
      accelerationSpread: new THREE.Vector3(.7, .7, .7),
      particlesPerSecond: 100
      colorStart: colorStart
      colorEnd: colorEnd
    @meteorGroup.addEmitter meteor.tailEmitter
    @meteors.push meteor
    
  calcPositions: ->
    console.log 'shnur'
    for meteor in @meteors
      distance =  FW.controls.getPosition().distanceTo(meteor.position)
      #meteor is far away, respawn it somewhere. Randomize for staggered show
      if distance > @meteorVisibleDistance + rnd(-@meteorVisibleDistance/2, @meteorVisibleDistance/2)
        @resetMeteor meteor
    setTimeout(=>
      @calcPositions()
    ,@calcTimeout)

    

  update: ->
    for meteor in @meteors
      meteor.speedX +=meteor.accelX
      meteor.speedY +=meteor.accelY
      meteor.speedZ +=meteor.accelZ
      meteor.translateX(meteor.speedX * meteor.dirX)
      meteor.translateY( meteor.speedY * meteor.dirY)
      meteor.translateZ(meteor.speedZ * meteor.dirZ)
      meteor.light.position = new THREE.Vector3().copy(meteor.position)
      meteor.tailEmitter.position = new THREE.Vector3().copy(meteor.position)
    @meteorGroup.tick()
    


