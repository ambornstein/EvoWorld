extends Structure
class_name Boulder

enum Ore {
	IRON,
	SILVER,
	NONE
}

@export var ore: Ore

# Called when the node enters the scene tree for the first time.
func _ready():
	MAX_YIELD = 4
	super._ready()
	
	var animation_mode = MaterialContent.keys()[resource].to_lower()
	if not (animation_mode == "limestone" or animation_mode == "claystone"):
		animation_mode = "limestone"
	set_animation(animation_mode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ore != Ore.NONE:
		select_collision(2)
		match ore:
			Ore.IRON:
				set_frame(4)
			Ore.SILVER:
				set_frame(5)
	else:
		match size:
			1:
				select_collision(0)
			2:
				select_collision(1)
			3,4:
				select_collision(2)
		set_frame(size-1)
