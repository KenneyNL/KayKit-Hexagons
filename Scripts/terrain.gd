extends Node

# Define the GridMap components

onready var terrain = $TerrainMap
onready var tiles = $TileMap

# World size

var worldSize = 64

func _ready(): generate()

func generate():
	
	# Define noise for terrain
	
	var noise = OpenSimplexNoise.new()
	
	noise.seed = randi()
	noise.octaves = 3
	noise.period = 20.0
	noise.persistence = 0.8
	
	# Start terrain generation
	
	var offset = 0
	
	for x in worldSize:
		
		offset = 0
		
		for y in worldSize:
			
			if x % 2 and y % 2:
				
				if offset == 1:
					offset = 0
				else:
					offset = 1
				
				# Get noise value for tile
					
				var _noise = round(noise.get_noise_2d(x, y) * 10)
				
				# Terrain tile (color)
				
				var _tile = 0
				if _noise < 0: _tile = 1
				if _noise > 1: _tile = 2
				
				set_terrain(Vector3(x + offset, _noise, y), _tile)
				
				# Place objects (randomly)
				
				var _random = rand_range(0, 6)
				
				var _quaternion = Quat(Vector3(0, 1, 0), deg2rad(rand_range(0, 180)))
				var _randomRotation = Basis(_quaternion).get_orthogonal_index()
				
				if _tile == 0 and _random < 2:
					set_tile(Vector3(x + offset, _noise, y), 0, _randomRotation)

				if _tile == 0 and _random < 1:
					set_tile(Vector3(x + offset, _noise, y), 2, _randomRotation)

				if _tile > 1 and _random < 1:
					set_tile(Vector3(x + offset, _noise, y), 1, _randomRotation)

# Set terrain tile

func set_terrain(_position, _tile):
	terrain.set_cell_item(_position.x - (worldSize / 2), _position.y, _position.z - (worldSize / 2), _tile)
	
# Set object tile

func set_tile(_position, _tile, _orientation):
	tiles.set_cell_item(_position.x - (worldSize / 2), _position.y + 5, _position.z - (worldSize / 2), _tile, _orientation)
