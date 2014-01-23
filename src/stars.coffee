FW.Stars = class Stars
  constructor: ()->

    @colorStart = new THREE.Color()
    @colorStart.setRGB(Math.random(),Math.random(),Math.random() )
    texture = THREE.ImageUtils.loadTexture('assets/star.png')
    texture.minFilter = THREE.LinearMipMapLinearFilter;

    @starGroup = new ShaderParticleGroup({
      texture: texture,
      blending: THREE.AdditiveBlending,
      maxAge: 10
    });

    @generateStars()
    FW.scene.add(@starGroup.mesh)

  generateStars: ->
    @starEmitter = new ShaderParticleEmitter
      type: 'sphere'
      radius: 50000
      speed: .1
      size: rnd(4000, 6000)
      sizeSpread: 4000
      particlesPerSecond: rnd(500, 1100)
      opacityStart: 0
      opacityMiddle: 1
      opacityEnd: 0
      colorStart: @colorStart
      colorSpread: new THREE.Vector3(rnd(.1, .5), rnd(.1, .5), rnd(.1, .5))
    
    @starGroup.addEmitter @starEmitter
  

   
    
  update: ->
    @starGroup.tick()
    


