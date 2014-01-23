
FW.World = class World
  constructor : ->
    FW.clock = new THREE.Clock()
    @SCREEN_WIDTH = window.innerWidth
    @SCREEN_HEIGHT = window.innerHeight
    FW.width = 100000
    @camFar = FW.width * 2
    @time = Date.now()
    @rippleFactor = 90

    # CAMERA
    FW.camera = new THREE.PerspectiveCamera(75.0, @SCREEN_WIDTH / @SCREEN_HEIGHT, 1, @camFar)


    # SCENE 
    FW.scene = new THREE.Scene()
    #CONTROLS
    @controls = new FW.Controls(FW.camera)
    FW.scene.add FW.controls.getObject()
    FW.controls.fly = true

    # RENDERER
    FW.Renderer = new THREE.WebGLRenderer()
    FW.Renderer.setSize @SCREEN_WIDTH, @SCREEN_HEIGHT
    FW.Renderer.setClearColor 0x06071a
    document.body.appendChild FW.Renderer.domElement

    # LIGHTING
    light1 = new THREE.DirectionalLight( 0xffffff, 1.0 );
    light1.position.set( 1, 1, 1 );
    FW.scene.add( light1 );

    light2 = new THREE.DirectionalLight( 0xffffff, 1.0 );
    light2.position.set( 0, -1, -1);
    FW.scene.add( light2 );

    #CAVES 
    @caves = new FW.Caves()
    #METEORS
    @meteors = new FW.Meteors()
    #STARS
    @stars = new FW.Stars()
    #SPELLS
    FW.spells = new FW.Spells()
   
    #DOUGS SHIT
    @dougsShit = new FW.DougsShit(@caves.positions[0])

    # WATER
    waterNormals = new THREE.ImageUtils.loadTexture './assets/waternormals.jpg'
    waterNormals.wrapS = waterNormals.wrapT = THREE.RepeatWrapping
    @water = new THREE.Water FW.Renderer, FW.camera, FW.scene,
      textureWidth: 512
      textureHeight: 512
      waterNormals: waterNormals
      alpha: 1.0
      distortionScale: 20

    aMeshMirror = new THREE.Mesh(
      new THREE.PlaneGeometry FW.width, FW.width, 50, 50
      @water.material
    )
    aMeshMirror.add @water
    aMeshMirror.rotation.x = -Math.PI * 0.5
    FW.scene.add aMeshMirror

    # EVENTS
    window.addEventListener "resize", (=>
      @onWindowResize()
    ), false

  
  onWindowResize : (event) ->
    @SCREEN_WIDTH = window.innerWidth
    @SCREEN_HEIGHT = window.innerHeight
    FW.Renderer.setSize @SCREEN_WIDTH, @SCREEN_HEIGHT
    FW.camera.aspect = @SCREEN_WIDTH / @SCREEN_HEIGHT
    FW.camera.updateProjectionMatrix()

  animate : =>
    requestAnimationFrame @animate
    delta = FW.clock.getDelta()
    time = Date.now()
    @water.material.uniforms.time.value += 1.0 / @rippleFactor
    FW.controls.update(Date.now() - @time)
    @stars.update()
    FW.spells.update()
    @meteors.update()
    @dougsShit.update()
    @time = Date.now()

    @render()
  render : ->
    delta = FW.clock.getDelta()
    @water.render()
    FW.Renderer.render( FW.scene, FW.camera );

   