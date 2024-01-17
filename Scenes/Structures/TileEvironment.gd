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
	Vector2i(4,4): generate_boulder.bind(1, Boulder.Ore.NONE, Structure.MaterialContent.LIMESTONE),
	Vector2i(5,4): generate_boulder.bind(2, Boulder.Ore.NONE, Structure.MaterialContent.LIMESTONE),
	Vector2i(6,4): generate_boulder.bind(3, Boulder.Ore.NONE, Structure.MaterialContent.LIMESTONE),
	Vector2i(7,4): generate_boulder.bind(4, Boulder.Ore.NONE, Structure.MaterialContent.LIMESTONE),
	Vector2i(8,4): generate_boulder.bind(4, Boulder.Ore.IRON, Structure.MaterialContent.LIMESTONE),
	Vector2i(9,4): generate_boulder.bind(4, Boulder.Ore.SILVER, Structure.MaterialContent.LIMESTONE),
	Vector2i(4,5): generate_boulder.bind(1, Boulder.Ore.NONE, Structure.MaterialContent.CLAYSTONE),
	Vector2i(5,5): generate_boulder.bind(2, Boulder.Ore.NONE, Structure.MaterialContent.CLAYSTONE),
	Vector2i(6,5): generate_boulder.bind(3, Boulder.Ore.NONE, Structure.MaterialContent.CLAYSTONE),
	Vector2i(7,5): generate_boulder.bind(4, Boulder.Ore.NONE, Structure.MaterialContent.CLAYSTONE),
	Vector2i(8,5): generate_boulder.bind(4, Boulder.Ore.IRON, Structure.MaterialContent.CLAYSTONE),
	Vector2i(9,5): generate_boulder.bind(4, Boulder.Ore.SILVER, Structure.MaterialContent.CLAYSTONE)
}

func generate_forest(size, type):
	var item = forest.instantiate()
	item.size = size
	item.type = type
	return item

func generate_boulder(size, ore, stone_type):
	var item = boulder.instantiate()
	item.size = size
	item.ore = ore
	item.resource = stone_type
	return item

# Called when the node enters the scene tree for the first time.
func _ready():
	_replace_tiles_with_scenes(0)
	_replace_tiles_with_scenes(1)

func _replace_tiles_with_scenes(map_layer: int, scene_dictionary: Dictionary = TILE_SCENES): 
	for tile_pos in get_used_cells(map_layer):
		var tile_id = get_cell_atlas_coords(map_layer, tile_pos)
		
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
