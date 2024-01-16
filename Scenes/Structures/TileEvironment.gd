extends TileMap
class_name TileEnvironment

var forest = preload("res://Scenes/Structures/tree/Forest.tscn")
var boulder = preload("res://Scenes/Structures/boulders/Boulder.tscn")

@onready var half_cell_size := tile_set.tile_size * 0.5

@export var TILE_SCENES := {
	Vector2i(0,3): generate_forest.bind(1, Forest.TreeType.POPLAR),
	Vector2i(1,3): generate_forest.bind(2, Forest.TreeType.POPLAR),
	Vector2i(2,3): generate_forest.bind(4, Forest.TreeType.POPLAR),
	Vector2i(3,3): generate_forest.bind(7, Forest.TreeType.POPLAR),
	Vector2i(0,4): generate_forest.bind(1, Forest.TreeType.PINE),
	Vector2i(1,4): generate_forest.bind(2, Forest.TreeType.PINE),
	Vector2i(2,4): generate_forest.bind(3, Forest.TreeType.PINE),
	Vector2i(3,4): generate_forest.bind(7, Forest.TreeType.PINE),
	Vector2i(0,5): generate_forest.bind(1, Forest.TreeType.CHOPPED_DOWN),
	Vector2i(1,5): generate_forest.bind(2, Forest.TreeType.CHOPPED_DOWN),
	Vector2i(2,5): generate_forest.bind(3, Forest.TreeType.CHOPPED_DOWN),
	Vector2i(3,5): generate_forest.bind(7, Forest.TreeType.CHOPPED_DOWN),
}

func generate_forest(size, type):
	var item = forest.instantiate()
	item.size = size
	item.type = type
	return item

func generate_boulder(size, ore):
	var item = boulder.instantiate()
	item.size = size
	item.ore = ore
	return item

# Called when the node enters the scene tree for the first time.
func _ready():
	_replace_tiles_with_scenes()

func _replace_tiles_with_scenes(scene_dictionary: Dictionary = TILE_SCENES): 
	for tile_pos in get_used_cells(0):
		var tile_id = get_cell_atlas_coords(0, tile_pos)
		
		if scene_dictionary.has(tile_id):
			var object_scene = scene_dictionary[tile_id]
			_replace_tile_with_object(tile_pos, object_scene)
			
func _replace_tile_with_object(tile_pos: Vector2i, generator: Callable, parent: Node = get_tree().current_scene):
	if generator:
		var obj = generator.call()
		var obj_pos = map_to_local(tile_pos) 
		parent.add_child.call_deferred(obj)
		obj.global_position = obj_pos
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
