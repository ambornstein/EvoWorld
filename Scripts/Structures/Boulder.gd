extends Structure
class_name Boulder

enum StoneType {
	LIMESTONE,
	CLAYSTONE
}

@export var stone_type: StoneType
@export var moss: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	MAX_YIELD = 4
	super._ready()
	
	set_animation(StoneType.keys()[stone_type].to_lower())
	select_collision(0)
	if moss:
		set_frame(3)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
