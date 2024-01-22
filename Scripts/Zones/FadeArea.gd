extends TransformArea

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _transform(node):
	_fade(node)

func _untransform(node):
	_unfade(node)

func _fade(node):
	if _can_fade(node):
		node.set_layer_alpha(3, 0.5)
	else:
		for child in node.get_children():
			_fade(child)
			
func _unfade(node):
	if _can_fade(node):
		node.set_layer_alpha(3, 1)
	else:
		for child in node.get_children():
			_unfade(child)
	
func _can_fade(node):
	print("modulate active")
	return "set_layer_modulate" in node

func _on_player_entered(body):
	print("player entered")
	var parent = get_parent()
	_transform(parent)

func _on_player_exited(body):
	print("player exited")
	var parent = get_parent()
	_untransform(parent)
