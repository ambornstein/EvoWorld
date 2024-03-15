extends CharacterBody2D

enum {
	IDLE,
	WANDER,
	CHASE
}

#@export var health: HealthComponent

@export var ACCELERATION = 300
@export var MAX_SPEED = 100
@export var TOLERANCE = 0.5
@export var health: HealthComponent

@onready var sprite = $AnimatedSprite2D

var state = IDLE

var follow_target
var target_displacement: Vector2
var target_position: Vector2

func _ready():
	health.hurt.connect(_damaged_animation)
	
func _process(delta):
	target_displacement = target_position - global_position
	#print(target_displacement.normalized())

func _physics_process(delta):
	if follow_target != null:
		velocity = velocity.move_toward(position.direction_to(follow_target.position) * MAX_SPEED, ACCELERATION * delta)
	else:
		match state:
			IDLE:
				state = WANDER
				# Maybe wait for X seconds with a timer before moving on
			WANDER:
				random_target_position()
				velocity = velocity.move_toward(target_displacement * MAX_SPEED, ACCELERATION * delta)
				
				if is_at_target_position():
					velocity = Vector2(0,0)
					state = IDLE
	move_and_slide()

func _damaged_animation():
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE

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
	if body.name == "Player":
		follow_target = body
		print(body)

func _on_area_2d_body_exited(body):
	follow_target = null
