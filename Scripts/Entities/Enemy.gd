extends Human
class_name Enemy

enum {
	IDLE,
	WANDER,
	CHASE
}

#@export var health: HealthComponent

@export var TOLERANCE = 0.5

var state = IDLE

var follow_target
var target_displacement: Vector2
var target_position: Vector2
	
func _process(delta):
	_attack_orientation = target_displacement-weapon.position
	super._process(delta)
	
	if follow_target:
		target_displacement = follow_target.position - position
		if not animation.is_playing():
			set_weapon_starting_pos()
			update_animation_position(_attack_orientation)
	#print(target_displacement.normalized())

func _physics_process(delta):
	if follow_target != null:
		if position.distance_to(follow_target.position) > 50:
			velocity = velocity.move_toward(position.direction_to(follow_target.position) * SPEED, ACCELERATION * delta)
		else: 
			velocity = velocity.move_toward(Vector2(0,0), ACCELERATION*delta)
			#attack()
	else:
		match state:
			IDLE:
				state = WANDER
				# Maybe wait for X seconds with a timer before moving on
			WANDER:
				random_target_position()
				velocity = velocity.move_toward(target_displacement * SPEED, ACCELERATION * delta)
				
				if is_at_target_position():
					velocity = Vector2(0,0)
					state = IDLE
	move_and_slide()

func random_target_position():
	var rng = RandomNumberGenerator.new()
	var target_vector = Vector2(rng.randi_range(-100, 100), rng.randi_range(-100, 100))
	#var target_vector = Vector2(2, 0)
	target_position = global_position + target_vector
	
func is_at_target_position(): 
	# Stop moving when at target +/- tolerance
	return target_displacement.length() < TOLERANCE

###signals

func _on_area_2d_body_entered(body):
	if body is Player:
		follow_target = body
		print(body)

func _on_area_2d_body_exited(body):
	follow_target = null
	#target_displacement = Vector2(0,0)
