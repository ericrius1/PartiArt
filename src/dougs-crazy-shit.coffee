FW.DougsShit = class DougsShit
  constructor: (@position)->
    @dougsCrazyShit = []
    @startRotationSpeed = .02
    @endRotationSpeed = .005
    @zRotationStart = 0
    @zRotationEnd = 2 * Math.PI
    @startRadius = 5
    @endRadius = 50
    @numLayers = 40
    @startSegments = 20
    @endSegments = 50
    @width = 1
    @height = 1
    @squareGeo = new THREE.PlaneGeometry(1, 1)
    @materials = []
    @placeNodes()


  placeNodes: ->

    for i in [1..@numLayers]
      @radius = map(i, 1, @numLayers, @startRadius, @endRadius)
      @numSegments = Math.floor(map(i, 1, @numLayers, @startSegments, @endSegments))
      geoLayer = new THREE.CircleGeometry @radius, @numSegments
      layerMesh = new THREE.ParticleSystem geoLayer
      layerMesh.position = @position
      FW.scene.add layerMesh
      layer = 
        mesh: layerMesh
        rotationSpeed: map(i, 1, @numLayers, @startRotationSpeed, @endRotationSpeed)
      @dougsCrazyShit.push layer



    
  update: ->
    for layer in @dougsCrazyShit
      layer.mesh.rotation.z += layer.rotationSpeed 






