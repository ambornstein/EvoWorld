extends CharacterBody2D

var Fireball = preload("res://Scenes/Fireball.tscn")

@export var health: HealthComponent
@export var speed = 400  # speed in pixels/sec

@onready var sprite = $AnimatedSprite2D

func _ready():
	health.connect("hurt", _damaged_animation)

func _process(delta):
	if Input.is_action_just_pressed("click"):
		#print(get_global_mouse_position())
		var vec = position.direction_to(get_global_mouse_position())
		_shoot(vec)

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
		
func _shoot(direction: Vector2):
	var fire = Fireball.instantiate()
	add_child(fire)
	fire.fire(direction)

###signals
	
func _damaged_animation():
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE
