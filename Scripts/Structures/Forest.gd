extends Structure
class_name Forest

enum TreeType {
	POPLAR,
	POPLAR_FALL,
	POPLAR_WINTER,
	PINE,
	PINE_FALL,
	PINE_WINTER,
	FRUIT,
	DRY
}

enum TreeSize {
	TREE,
	BUSH
}

@export var type: TreeType
@export var height: TreeSize
@export var stump: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	MAX_YIELD = 7
	
	super._ready()
	if stump:
		set_animation("stump")
		select_collision(0)
	
	if height == TreeSize.BUSH:
		set_animation("bush")
		select_collision(0)
		match type:
			TreeType.POPLAR, TreeType.PINE:
				set_frame(0)
			TreeType.POPLAR_FALL, TreeType.PINE_FALL:
				set_frame(1)
			TreeType.POPLAR_WINTER, TreeType.PINE_WINTER:
				set_frame(2)
			TreeType.FRUIT:
				set_frame(3)
			TreeType.DRY:
				set_frame(4)
	else:
		select_collision(1)
		set_animation("tree")
		set_frame(type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		
func exhaust():
	stump = true;
	set_animation("stump")
