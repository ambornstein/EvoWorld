extends Structure
class_name Boulder

enum Size {
	SMALL,
	MEDIUM,
	LARGE,
	FULL
}

enum Ore {
	IRON,
	SILVER,
	NONE
}

@export var size: Size
@export var ore: Ore

# Called when the node enters the scene tree for the first time.
func _ready():
	print(str(resource).to_lower())
	print(sprite)
	#sprite.animation = str(resource).to_lower()
	if ore != Ore.NONE:
		match ore:
			Ore.IRON:
				super.set_frame(4)
			Ore.SILVER:
				super.set_frame(5)
	else:
		match size:
			Size.SMALL:
				super.set_frame(0)
			Size.MEDIUM:
				super.set_frame(1)
			Size.LARGE:
				super.set_frame(2)
			Size.FULL:
				super.set_frame(3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
