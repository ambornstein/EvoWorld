extends TileMap
class_name TileEnvironment

var tree = preload("res://Scenes/Structures/tree/Tree.tscn")
var boulder = preload("res://Scenes/Structures/boulders/Boulder.tscn")

@onready var half_cell_size := tile_set.tile_size * 0.5

@export var tile_replacements: Array[StructureData]
@export var tile_locations := [
	Vector2i(13,9),
	Vector2i(14,9),
	Vector2i(15,9),
	Vector2i(13,10),
	Vector2i(14,10),
	Vector2i(15,10),
	Vector2i(16,10),
	Vector2i(17,10),
	Vector2i(18,10),
	Vector2i(23,9),
	Vector2i(23,10),
	Vector2i(27,9),
	Vector2i(27,10),
	Vector2i(54,21),
	Vector2i(54,19)
]

enum Layers {
	GROUND,
	INSIDE,
	STRUCT,
	FACADE,
	ROOF
}

# Called when the node enters the scene tree for the first time.
func _ready():
	_replace_tiles_with_scenes(Layers.GROUND)
	_replace_tiles_with_scenes(Layers.STRUCT)

func _replace_tiles_with_scenes(map_layer: int): 
	for tile_pos in get_used_cells(map_layer):
		var tile_id = get_cell_atlas_coords(map_layer, tile_pos)
		
		var tile = tile_locations.find(tile_id)
		if tile != -1:
			_replace_tile_with_object(tile_pos, tile_replacements[tile])
			set_cell(map_layer, tile_pos, -1, Vector2i(-1,-1))
			
func _replace_tile_with_object(tile_pos: Vector2i, data: StructureData, parent: Node = get_tree().current_scene):
	var struct_inst
	if data is TreeData:
		struct_inst = tree.instantiate()
		struct_inst.set_tree_data(data)
	elif data is BoulderData:
		struct_inst = boulder.instantiate()
		struct_inst.set_boulder_data(data)
		
	var obj_pos = map_to_local(tile_pos) 

	parent.call_deferred("add_child", struct_inst)
	struct_inst.global_position = obj_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_resource_destroyed(delta):
	pass
	
func set_layer_alpha(layer: int, alpha):
	var color = get_layer_modulate(layer)
	color.a = alpha
	set_layer_modulate(layer, color)
