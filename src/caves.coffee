FW.Caves = class Caves
  constructor: ->
    @numCaves = 5
    @positions = []
    @caveSpreadFactor = 50
    parameters = 
        alea: RAND_MT,
        generator: PN_GENERATOR,
        width: 300
        height: 300
        widthSegments: 30
        heightSegments: 30
        depth: 200
        param: 4,
        filterparam: 1
        filter: [ CIRCLE_FILTER ]
        postgen: [ MOUNTAINS_COLORS ]
        effect: [ DESTRUCTURE_EFFECT ]

      for i in [1..@numCaves]
        terrainGeo = TERRAINGEN.Get(parameters)
        terrainMaterial = new THREE.MeshPhongMaterial vertexColors: THREE.VertexColors, shading: THREE.FlatShading, side: THREE.DoubleSide 
        terrain = new THREE.Mesh terrainGeo, terrainMaterial
        position = new THREE.Vector3 rnd(-FW.width/@caveSpreadFactor, FW.width/@caveSpreadFactor), -2, rnd(-FW.width/@caveSpreadFactor, FW.width/@caveSpreadFactor)
        terrain.position = position
        @positions.push position
        FW.scene.add terrain