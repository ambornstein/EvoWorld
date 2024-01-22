extends Area2D
class_name TransformArea

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", _on_player_entered)
	connect("body_exited", _on_player_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_player_entered(body):
	print("player entered")
	var parent = get_parent()
	_transform(parent)

func _on_player_exited(body):
	print("player exited")
	var parent = get_parent()
	_untransform(parent)

func _transform(_node):
	pass

func _untransform(_node):
	pass
