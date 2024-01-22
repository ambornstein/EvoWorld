extends TileMap
class_name TileEnvironment

var forest = preload("res://Scenes/Structures/tree/Forest.tscn")
var boulder = preload("res://Scenes/Structures/boulders/Boulder.tscn")

@onready var half_cell_size := tile_set.tile_size * 0.5

@export var TILE_SCENES := {
	Vector2i(13,9): _generate_forest.bind(1, Forest.TreeType.POPLAR, Forest.TreeSize.BUSH, false),
	Vector2i(14,9): _generate_forest.bind(1, Forest.TreeType.POPLAR_FALL, Forest.TreeSize.BUSH, false),
	Vector2i(15,9): _generate_forest.bind(1, Forest.TreeType.POPLAR_WINTER, Forest.TreeSize.BUSH, false),
	
	Vector2i(13,10): _generate_forest.bind(3, Forest.TreeType.POPLAR_FALL, Forest.TreeSize.TREE, false),
	Vector2i(14,10): _generate_forest.bind(3, Forest.TreeType.POPLAR_FALL, Forest.TreeSize.TREE, false),
	Vector2i(15,10): _generate_forest.bind(3, Forest.TreeType.POPLAR_WINTER, Forest.TreeSize.TREE, false),
	Vector2i(16,10): _generate_forest.bind(3, Forest.TreeType.PINE, Forest.TreeSize.TREE, false),
	Vector2i(17,10): _generate_forest.bind(3, Forest.TreeType.PINE_FALL, Forest.TreeSize.TREE, false),
	Vector2i(18,10): _generate_forest.bind(3, Forest.TreeType.PINE_WINTER, Forest.TreeSize.TREE, false),
	
	Vector2i(23,9): _generate_forest.bind(1, Forest.TreeType.FRUIT, Forest.TreeSize.BUSH, false),
	Vector2i(23,10): _generate_forest.bind(3, Forest.TreeType.FRUIT, Forest.TreeSize.TREE, false),
	
	Vector2i(27,11): _generate_forest.bind(3, Forest.TreeType.DRY, Forest.TreeSize.TREE, false),
	Vector2i(27,9): _generate_forest.bind(1, Forest.TreeType.DRY, Forest.TreeSize.BUSH, false),

	Vector2i(54,21): _generate_boulder.bind(3, Boulder.StoneType.LIMESTONE, false),
	Vector2i(54,19): _generate_boulder.bind(3, Boulder.StoneType.CLAYSTONE, false)
}

enum Layers {
	GROUND,
	INSIDE,
	STRUCT,
	ROOF
}

func _generate_forest(size, type, height, stump):
	var tree: Forest = forest.instantiate()
	tree.size = size
	tree.type = type
	tree.height = height
	tree.stump = stump
	tree.add_to_group("rescources")
	return tree

func _generate_boulder(size, stone_type, moss):
	var item: Boulder = boulder.instantiate()
	item.size = size
	item.resource = stone_type
	item.stone_type = stone_type
	item.moss = moss
	item.add_to_group("rescources")
	return item

# Called when the node enters the scene tree for the first time.
func _ready():
	_replace_tiles_with_scenes(0)
	_replace_tiles_with_scenes(2)

func _replace_tiles_with_scenes(map_layer: int, scene_dictionary: Dictionary = TILE_SCENES): 
	for tile_pos in get_used_cells(map_layer):
		var tile_id = get_cell_atlas_coords(map_layer, tile_pos)
		
		if scene_dictionary.has(tile_id):
			var object_scene = scene_dictionary[tile_id]
			_replace_tile_with_object(tile_pos, object_scene)
			set_cell(map_layer, tile_pos, -1, Vector2i(-1,-1))
			
func _replace_tile_with_object(tile_pos: Vector2i, generator: Callable, parent: Node = get_tree().current_scene):
	if generator:
		var obj = generator.call()
		var obj_pos = map_to_local(tile_pos) 
		parent.add_child.call_deferred(obj)
		obj.global_position = obj_pos
		
func _process(delta):
	pass
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_resource_destroyed(delta):
	pass
	
func set_layer_alpha(layer: int, alpha):
	var color = get_layer_modulate(layer)
	color.a = alpha
	set_layer_modulate(layer, color)
