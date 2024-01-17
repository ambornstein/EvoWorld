extends Structure
class_name Forest

enum TreeType {
	POPLAR,
	PINE,
	CHOPPED_DOWN
}

@export var type: TreeType

# Called when the node enters the scene tree for the first time.
func _ready():
	MAX_YIELD = 7
	super._ready()
	
	var animation_mode = TreeType.keys()[type].to_lower()
	super.set_animation(animation_mode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match size:
		1:
			select_collision(0)
			set_frame(0)
		2,3:
			select_collision(1)
			if size == 3:
				set_frame(2)
			elif size == 2:
				set_frame(1)
		_:
			select_collision(2)
			set_frame(3)
	if type == 2:
		clear_collision()
