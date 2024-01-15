extends CharacterBody2D

var Fireball = preload("res://Scenes/Fireball.tscn")

var speed = 400  # speed in pixels/sec

func _process(delta):
	if Input.is_action_just_pressed("click"):
		#print(get_global_mouse_position())
		var vec = position.direction_to(get_global_mouse_position())
		#print(vec)
		var fire = Fireball.instantiate()
		add_child(fire)
		fire.fire(vec)

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed

	move_and_slide()

#func flash():
	#$Sprite2D.modulate = 
